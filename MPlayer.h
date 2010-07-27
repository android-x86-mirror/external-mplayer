/*
 * started from VorbisPlayer source code
 *
 * okkwon -_-;;
 *
 */

#ifndef _ANDROID_MPLAYER_H
#define _ANDROID_MPLAYER_H

#include <utils/threads.h>

#include <media/MediaPlayerInterface.h>
#include <media/AudioTrack.h>
#include <surfaceflinger/ISurface.h>

#include "mplayer_lib.h"

#define ANDROID_LOOP_TAG "ANDROID_LOOP"

namespace android {

	class MPlayerRenderer;

	class MPlayer : public MediaPlayerInterface {
		public:
			MPlayer ();
			~MPlayer ();

			virtual void        onFirstRef();
			virtual status_t    initCheck();
			virtual status_t    setDataSource(
					const char *uri, const KeyedVector<String8, String8>*headers);
			virtual status_t    setDataSource(int fd, int64_t offset, int64_t length);
			virtual status_t    setVideoSurface(const sp<ISurface>& surface);
			virtual status_t    prepare();
			virtual status_t    prepareAsync();
			virtual status_t    start();
			virtual status_t    stop();
			virtual status_t    seekTo(int msec);
			virtual status_t    pause();
			virtual bool        isPlaying();
			virtual status_t    getCurrentPosition(int* msec);
			virtual status_t    getDuration(int* msec);
			virtual status_t    release();
			virtual status_t    reset();
			virtual status_t    setLooping(int loop);
			virtual player_type playerType() { return MPLAYER_PLAYER; }
			virtual status_t    invoke(const Parcel& request, Parcel *reply) {return INVALID_OPERATION;}

		private:
			struct mplayer_context mMPContext;
			status_t	reset_nosync();
			status_t	createOutputTrack();
			static int	renderThread(void*);
			status_t	setdatasource(const char *path, int fd, int64_t offset,
					int64_t length);
			void		populateISurface();
			void		depopulateISurface();
			int			render();

			int			mDisplayWidth;
			int 		mDisplayHeight;
			int 		mVideoOutWidth;
			int 		mVideoOutHeight;
			Mutex 		mMutex;
			Condition	mCondition;
			bool		mMPInitialized;
			char * 		mAudioBuffer;
			bool		mLoop;
			bool 		mAndroidLoop;
			volatile bool		mExit;
			bool		mPaused;
			volatile bool mRender;
			status_t	mState;
			pid_t		mRenderTid;
			MPlayerRenderer *mVideoRenderer;
			sp<ISurface> mISurface;

			/* we don't support more than one thread at a time */
			static 	bool	libInUse;
	};
};	// namespace android

#endif /* _ANDROID_MPLAYER_H */
