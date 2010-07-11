/*
**
** Copyright 2009, The Android Open Source Project
**
** Licensed under the Apache License, Version 2.0 (the "License");
** you may not use this file except in compliance with the License.
** You may obtain a copy of the License at
**
**     http://www.apache.org/licenses/LICENSE-2.0
**
** Unless required by applicable law or agreed to in writing, software
** distributed under the License is distributed on an "AS IS" BASIS,
** WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
** See the License for the specific language governing permissions and
** limitations under the License.
*/

/* copied from Vorbis player */

//#define LOG_NDEBUG 0
#define LOG_TAG "MPlayerMetadataRetriever"
#include <utils/Log.h>

#include "MPlayerMetadataRetriever.h"
#include <media/mediametadataretriever.h>
#

namespace android {

void MPlayerMetadataRetriever::clearMetadataValues()
{
    LOGV("cleearMetadataValues");
    mMetadataValues[0][0] = '\0';
}

status_t MPlayerMetadataRetriever::setDataSource(const char *url)
{
    LOGV("setDataSource: url(%s)", url? url: "NULL pointer");
    Mutex::Autolock lock(mLock);
    clearMetadataValues();
    if (mMPlayerPlayer == 0) {
        mMPlayerPlayer = new MPlayer();
    }
    return mMPlayerPlayer->setDataSource(url);
}

status_t MPlayerMetadataRetriever::setDataSource(int fd, int64_t offset, int64_t length)
{
    LOGV("setDataSource: fd(%d), offset(%lld), and length(%lld)", fd, offset, length);
    Mutex::Autolock lock(mLock);
    clearMetadataValues();
    if (mMPlayerPlayer == 0) {
        mMPlayerPlayer = new MPlayer();
    }
    return mMPlayerPlayer->setDataSource(fd, offset, length);
}

const char* MPlayerMetadataRetriever::extractMetadata(int keyCode)
{
    LOGV("extractMetadata: key(%d)", keyCode);
    Mutex::Autolock lock(mLock);
    if (mMPlayerPlayer == 0 || mMPlayerPlayer->initCheck() != NO_ERROR) {
        LOGE("no vorbis player is initialized yet");
        return NULL;
    }
    switch (keyCode) {
    case METADATA_KEY_DURATION:
        {
            if (mMetadataValues[0][0] == '\0') {
                int duration = -1;
                if (mMPlayerPlayer->getDuration(&duration) != NO_ERROR) {
                    LOGE("failed to get duration");
                    return NULL;
                }
                snprintf(mMetadataValues[0], MAX_METADATA_STRING_LENGTH, "%d", duration);
            }
            LOGV("duration: %s ms", mMetadataValues[0]);
            return mMetadataValues[0];
        }
    default:
        LOGE("Unsupported key code (%d)", keyCode);
        return NULL;
    }
    return NULL;
}

};

