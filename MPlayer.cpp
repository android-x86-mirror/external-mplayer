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

#include "MPlayer.h"


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

	MPlayer::MPlayer() :
		mAudioBuffer(NULL), mPlayTime(-1), mDuration(-1), mState(STATE_ERROR),
		mStreamType(AudioSystem::MUSIC), mLoop(false), mAndroidLoop(false),
		mExit(false), mPaused(false), mRender(false), mRenderTid(-1)
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
		LOGE("setDataSource path=%s\n", path);
		mState = STATE_OPEN;
		return NO_ERROR;
	}

	status_t MPlayer::setDataSource(int fd, int64_t offset, int64_t length)
	{
		LOGE("setDataSource fd%d offset%lld length%lld\n", fd, offset, length);
		mState = STATE_OPEN;
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
		return NO_ERROR;
	}

	status_t MPlayer::seekTo(int position)
	{
		LOGE("seekTo pos%d\n", position);
		Mutex::Autolock l(mMutex);
		if (mState != STATE_OPEN) {
			return ERROR_NOT_OPEN;
		}
		/* todo : populate seek */
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
		*position = 100;
		return NO_ERROR;
	}

	status_t MPlayer::getDuration(int *duration)
	{
		LOGE("getDuration\n");
		Mutex::Autolock l(mMutex);
		if (mState != STATE_OPEN) {
			return ERROR_NOT_OPEN;
		}
		/* todo : need to populate */
		*duration = 100;
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
		if (mFile != NULL) {
			if (mFile != NULL) {
				LOGE("file not closed -_-;");
				fclose (mFile);
				mFile = NULL;
			}
		}
		mState = STATE_ERROR;

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
		/*
		if (mAudioSink->open(vi->rate, vi->channels, AudioSystem::PCM_16_BIT, DEFAULT_AUDIOSINK_BUFFERCOUNT) != NO_ERROR) {
			LOGE("mAudioSink open failed");
			return ERROR_OPEN_FAILED;
		}
		*/
		return NO_ERROR;
	}

	int MPlayer::renderThread(void*p) {
		return ((MPlayer*)p)->render();
	}

#define AUDIOBUFFER_SIZE 4096

	int MPlayer::render() {
		int result = -1;
		int temp;
		int count = 0;
		bool audioStarted = false;

		LOGE("render started\n");
		
		mAudioBuffer = new char[AUDIOBUFFER_SIZE];

		// let main thread know we're ready
		{
		   	Mutex::Autolock l(mMutex);
			mRenderTid = myTid();
			mCondition.signal();
		}

		while (1) {
			{
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

				count ++;
				if (count > 60) {
					if (mLoop || mAndroidLoop) {
						/* start loop again here */
					} else {
						mAudioSink->stop();
						audioStarted = false;
						mRender = false;
						mPaused = true;

						LOGE ("media playback complete");
						sendEvent(MEDIA_PLAYBACK_COMPLETE);

						mCondition.wait(mMutex);
						if (mExit) break;

						if (mState == STATE_OPEN) {
						}
					}
				}
			}
			if (count == 0) {
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
			if ((temp = mAudioSink->write(mAudioBuffer, 1000))<0) {
				LOGE("Error in writing %d", temp);
				result = temp;
				break;
			}

			//start audio output if necessary
			if (!audioStarted && !mPaused && !mExit) {
				mAudioSink->start();
				audioStarted = true;
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
