#ifndef ANDROID_MPLAYERMETADATARETRIEVER_H
#define ANDROID_MPLAYERMETADATARETRIEVER_H

#include <utils/threads.h>
#include <utils/Errors.h>
#include <media/MediaMetadataRetrieverInterface.h>

#include "MPlayer.h"

namespace android {

	class MPlayerMetadataRetriever : public MediaMetadataRetrieverInterface {
		public:
			MPlayerMetadataRetriever() {}
			~MPlayerMetadataRetriever() {}

			virtual status_t                setDataSource(const char *url);
			virtual status_t                setDataSource(int fd, int64_t offset, int64_t length);
			virtual const char*             extractMetadata(int keyCode);

		private:
			static const uint32_t MAX_METADATA_STRING_LENGTH = 128;
			void clearMetadataValues();

			Mutex               mLock;
			sp<MPlayer>    mMPlayerPlayer;
			char                mMetadataValues[1][MAX_METADATA_STRING_LENGTH];
	};

}; // namespace android

#endif
