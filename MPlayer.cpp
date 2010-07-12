/* started from VorbisPlayer
 *
 * okkwon -_-;
 *
 */

#define LOG_TAG "MPlayer"
#include "utils/Log.h"

#include <stdio.h>
#include <assert.h>
#include <limits.h>
#include <unistd.h>
#include <fcntl.h>
#include <sched.h>
#include <sys/types.h>
#include <sys/stat.h>

#include "mplayer_lib.h"
#include "MPlayer.h"
#include "MPlayerRenderer.h"
#include "MPDebug.h"

#ifdef HAVE_GETTID
static pid_t myTid() { return gettid(); }
#else
static pid_t myTid() { return getpid(); }
#endif

namespace android {
	static status_t ERROR_NOT_OPEN = -1;
	static status_t ERROR_OPEN_FAILED = -2;
	static status_t ERROR_ALLOCATE_FAILED = -4;
	static status_t ERROR_NOT_SUPPORTED = -8;
	static status_t ERROR_NOT_READY = -16;
	static status_t STATE_INIT = 0;
	static status_t STATE_ERROR = 1;
	static status_t STATE_OPEN = 2;
	static status_t STATE_PREPARED = 3;


	bool MPlayer::libInUse = false;

	MPlayer::MPlayer() :
		mAudioBuffer(NULL), mPlayTime(-1), mDuration(-1), mState(STATE_ERROR),
		mStreamType(AudioSystem::MUSIC), mLoop(false), mAndroidLoop(false),
		mExit(false), mPaused(false), mRender(false), mRenderTid(-1),
		mMPInitialized(false), mVideoRenderer(NULL)
	{
		LOGE("constructor\n");
	}

	void MPlayer::onFirstRef()
	{
		LOGE("initCheck\n");
		Mutex::Autolock l(mMutex);
		createThreadEtc(renderThread, this, "mplayer main loop", 
				ANDROID_PRIORITY_AUDIO);
		mCondition.wait (mMutex);
		if (mRenderTid > 0) {
			LOGV("render thread(%d) started", mRenderTid);
			mState = STATE_INIT;
		}
	}

	status_t MPlayer ::initCheck()
	{
		if (mState == STATE_ERROR) return ERROR_NOT_READY;
		return NO_ERROR;
	}

	MPlayer::~MPlayer() {
	    LOGE("VorbisPlayer destructor\n");
		release();
	}

	status_t MPlayer::setDataSource(const char* path)
	{
		return setdatasource(path, -1, 0, 0x78ffffLL);
	}

	status_t MPlayer::setDataSource(int fd, int64_t offset, int64_t length)
	{
		return setdatasource(NULL, fd, offset, length);
	}

	status_t MPlayer::setdatasource (const char *path, int fd, int64_t offset,
			int64_t length)
	{
		int ret;

		LOGE("setdatasource url%d, fd%d\n", path, fd);
		LOGE("setdatasource offset%d, length%d\n", offset, length);

		if (libInUse) return INVALID_OPERATION;

		Mutex::Autolock l(mMutex);
		if (mState == STATE_OPEN) {
			reset_nosync();
		}

		struct stat sb;
		if (path) {
			ret = stat(path, &sb);
		} else {
			ret = fstat(fd, &sb);
		}
		if (ret != 0) {
			mState = STATE_ERROR;
			close(fd);
			return ERROR_OPEN_FAILED;
		}
		/* todo : need to handle offset and length */
		if (sb.st_size > (length+offset)) {
			mLength = length;
		} else {
			mLength = sb.st_size - offset;
		}

		int argca;
		char * argva[30] = {"mplayer", "fd", "-vo", "mem",
			"-ao", "pcm_mem", "-noconsolecontrols", "-nojoystick",
			"-nolirc", "-nomouseinput", "-slave", "-zoom", "-fs",
			0};
		char url_buffer[100];


		mfd = dup(fd);

		sprintf (url_buffer, "fd://%d", mfd);
		argva[1] = url_buffer;
		for (argca=0; argca<30; argca++) {
			if (argva[argca] == 0)
				break;
		}
		libInUse = true;
		ret = mplayer_init (&mMPContext, argca, argva);
		ret = fstat(mfd, &sb);
		LOGV("okkwon stat result %d", ret);

		if (!ret) { 
			libInUse = true;
			mMPInitialized = true;
			mState = STATE_OPEN;
			return NO_ERROR;
		} else {
			libInUse = false;
			mplayer_close (&mMPContext);
			return ERROR_OPEN_FAILED;
		}
	}

	void MPlayer::depopulateISurface() {
		if (mVideoRenderer) {
			delete mVideoRenderer;
			mVideoRenderer = NULL;
		}
	}

	void MPlayer::populateISurface() {
		if (mState != STATE_OPEN) {
			return;
		}

		int width, height;
		int ret;
		ret = mplayer_get_video_size(&mMPContext, &width, &height);
		LOGE("video size w%d h%d", width, height);
		if (!ret) 
			mVideoRenderer = new MPlayerRenderer (mISurface, width, height);
		else mVideoRenderer = NULL;
	}

	status_t MPlayer::setVideoSurface(const sp<ISurface> &isurface) {
		LOGE("setVideoSurface");

		Mutex::Autolock l(mMutex);
		if (mState != STATE_INIT && mState != STATE_OPEN) {
			return NO_INIT;
		}

		depopulateISurface();

		mISurface = isurface;

		if (mISurface.get() != NULL) {
			populateISurface();
		}

		return NO_ERROR;
	}


	status_t MPlayer::prepare()
	{
		LOGE("prepare\n");
		if (mState != STATE_OPEN) {
			return ERROR_NOT_OPEN;
		}
		return NO_ERROR;
	}

	status_t MPlayer::prepareAsync()
	{
		LOGE("prepareAsync\n");
		if (mState != STATE_OPEN) {
			sendEvent (MEDIA_ERROR);
			return NO_ERROR;
		}
		struct stat sb;
		int ret;
		ret = fstat(mfd, &sb);
		LOGE("stat result %d", ret);

		sendEvent (MEDIA_PREPARED);	/* todo : should be moved to main loop */
		return NO_ERROR;
	}

	status_t MPlayer::start()
	{
		LOGE("start\n");
		Mutex::Autolock l(mMutex);
		if (mState != STATE_OPEN) {
			return ERROR_NOT_OPEN;
		}
		mPaused = false;
		mRender = true;

		// wake up render thread
		LOGE("  wakeup render thread\n");
		mCondition.signal();
		return NO_ERROR;
	}

	status_t MPlayer::stop()
	{
		LOGE("stop\n");
		Mutex::Autolock l(mMutex);
		if (mState != STATE_OPEN) {
			return ERROR_NOT_OPEN;
		}
		mPaused = true;
		mRender = false;
		return NO_ERROR;
	}

	status_t MPlayer::seekTo(int position)
	{
		LOGE("seekTo pos%d\n", position);
		Mutex::Autolock l(mMutex);
		if (mState != STATE_OPEN) {
			return ERROR_NOT_OPEN;
		}
		mplayer_seek (&mMPContext, position);
		sendEvent(MEDIA_SEEK_COMPLETE);
		return NO_ERROR;
	}

	status_t MPlayer::pause()
	{
		LOGE("pause\n");
		Mutex::Autolock l(mMutex);
		if (mState != STATE_OPEN) {
			return ERROR_NOT_OPEN;
		}
		mPaused = true;
		return NO_ERROR;
	}

	bool MPlayer::isPlaying()
	{
		LOGE("isPlaying\n");
		if (mState == STATE_OPEN) {
			return mRender;
		}
		return 1;
	}

	status_t MPlayer::getCurrentPosition(int* position)
	{
		LOGE("getCurrentPosition\n");
		Mutex::Autolock l(mMutex);
		if (mState != STATE_OPEN) {
			LOGE("getCurrentPosition(): file not open");
			return ERROR_NOT_OPEN;
		}
		/* todo : get the position */
		mplayer_get_pos (&mMPContext, position);
		LOGE("position %d", *position);
		return NO_ERROR;
	}

	status_t MPlayer::getDuration(int *duration)
	{
		LOGE("getDuration\n");
		Mutex::Autolock l(mMutex);
		if (mState != STATE_OPEN) {
			return ERROR_NOT_OPEN;
		}
		mplayer_get_duration (&mMPContext, duration);
		LOGE("duration %d", *duration);
		return NO_ERROR;
	}

	status_t MPlayer::release()
	{
		LOGE("release\n");
		Mutex::Autolock l(mMutex);
		reset_nosync();

		if (mRenderTid > 0) {
			mExit = true;
			mCondition.signal();
			mCondition.wait(mMutex);
		}
		return NO_ERROR;
	}

	status_t MPlayer::reset()
	{
		LOGE("reset\n");
		Mutex::Autolock l(mMutex);
		return reset_nosync();
	}

	status_t MPlayer::reset_nosync()
	{
		//close file
		if (mMPInitialized)
		   	mplayer_close(&mMPContext);
		mMPInitialized = false;
		mState = STATE_ERROR;
		libInUse = false;

		mPlayTime = -1;
		mDuration = -1;
		mLoop = false;
		mAndroidLoop = false;
		mPaused = false;
		mRender = false;
		return NO_ERROR;
	}

	status_t MPlayer::setLooping(int loop)
	{
		LOGE("setLooping %d\n", loop);
		Mutex::Autolock l(mMutex);
		mLoop = (loop != 0);
		return NO_ERROR;
	}

	status_t MPlayer::createOutputTrack() {
		uint32_t sampleRate;
	   	int channelCount;
		
		mplayer_get_audio_info(&mMPContext, &sampleRate, &channelCount);

		if (mAudioSink->open(sampleRate, channelCount,
				   	AudioSystem::PCM_16_BIT,
				   	DEFAULT_AUDIOSINK_BUFFERCOUNT) != NO_ERROR) {
			LOGE("mAudioSink open failed");
			return ERROR_OPEN_FAILED;
		}
		return NO_ERROR;
	}

	int MPlayer::renderThread(void*p) {
		return ((MPlayer*)p)->render();
	}

#define AUDIOBUFFER_SIZE (4096*6)

	int MPlayer::render() {
		int result = -1;
		int temp;
		bool audioStarted = false;
		int mpresult;
		int audio_pos;
		char * video_buffer;
		size_t video_buffer_size;
		
		mAudioBuffer = new char[AUDIOBUFFER_SIZE];

		// let main thread know we're ready
		{
		   	Mutex::Autolock l(mMutex);
			mRenderTid = myTid();
			mCondition.signal();
		}

		while (1) {
			int audio_pos;
			int decoded_frames;

			Mutex::Autolock l(mMutex);

			// pausing?
			if (mPaused) {
				if (mAudioSink->ready()) mAudioSink->pause();
				mRender = false;
				audioStarted = false;
			}

			//nothing to render?
			if (!mExit && !mRender) {
				LOGE("render - signal wait\n");
				mCondition.wait(mMutex);
				LOGE("render - signal rx\n");
			}
			if (mExit) break;

			if (!mRender) continue;

			mpresult = mplayer_decode_audio(&mMPContext, mAudioBuffer,
					AUDIOBUFFER_SIZE, &audio_pos);
			if (mpresult) {
				LOGE ("error in decode");
				sendEvent(MEDIA_ERROR);
				break;
			}

			//create audio output track
			if (!mAudioSink->ready()) {
				LOGE("create output track");
				if (createOutputTrack() != NO_ERROR) break;
			}

			//write data to the audio hardware
			if ((temp = mAudioSink->write(mAudioBuffer, audio_pos))<0) {
				LOGE("Error in writing %d", temp);
				result = temp;
				break;
			}

			//start audio output if necessary
			if (!audioStarted && !mPaused && !mExit) {
				mAudioSink->start();
				audioStarted = true;
			}

			if (mVideoRenderer) {
				mVideoRenderer->getBuffer (&video_buffer, &video_buffer_size);
			}
			//this function will decode video and sleep for video output timing
			mpresult |= mplayer_decode_video(&mMPContext, video_buffer, 
					&decoded_frames);
			if (mpresult)  {
				LOGE("mplayer_decode_video returned %d", mpresult);
				break;
			}

			if (mVideoRenderer && decoded_frames) {
				mVideoRenderer->renderBuffer();
			}

			mpresult |= mplayer_after_decode (&mMPContext);
			if (mpresult) {
				LOGE("mplayer_after_decode %d", mpresult);
				break;
			}

			if (mpresult) {
				/* EOF reached -_-? */
				if (mLoop || mAndroidLoop) {
					mplayer_seek (&mMPContext, 0);
					/*
					mpresult = mplayer_decode_audio(&mMPContext, mAudioBuffer,
							AUDIOBUFFER_SIZE, &audio_pos);
							*/
				} else {
					int endpos;

					mAudioSink->stop();
					audioStarted = false;
					mRender = false;
					mPaused = true;
					mplayer_get_pos (&mMPContext, &endpos);

					LOGE("send MEDIA_PLAYBACK_COMPLETE");
					sendEvent(MEDIA_PLAYBACK_COMPLETE);

					LOGE("playback complete - wait for signal");
					mCondition.wait(mMutex);
					LOGE("playback complete - signal rx'd");
					if (mExit) break;

					if (mState == STATE_OPEN) {
						int curpos;
						mplayer_get_pos(&mMPContext, &curpos);
						if (curpos == endpos) {
							mplayer_seek (&mMPContext, 0);
						}
						mplayer_decode_audio(&mMPContext, mAudioBuffer,
								AUDIOBUFFER_SIZE, &audio_pos);
					}
				}
			}

		}
threadExit:
		mAudioSink.clear();
		if (mAudioBuffer) {
			delete [] mAudioBuffer;
			mAudioBuffer = NULL;
		}

		//tell main thread goodbye
		Mutex::Autolock l(mMutex);
		mRenderTid = -1;
		mCondition.signal();
		return result;
	}


} //end namespace android
