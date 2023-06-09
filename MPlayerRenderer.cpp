/* 
 * copied from StageFright
 *
 * okkwon <pinebud@gmail.com>
 *
 */

#define LOG_TAG "MPlayerRenderer"
#include <utils/Log.h>

#include <utils/MemoryHeapBase.h>
#include <ui/ISurface.h>
#include "MPDebug.h"
#include "MPlayerRenderer.h"

namespace android {
	MPlayerRenderer::MPlayerRenderer(
			const sp<ISurface> &surface,
			size_t displayWidth, size_t displayHeight)
		: mISurface(surface),
	   	mDisplayWidth(displayWidth),
		mDisplayHeight(displayHeight),
		mFrameSize(displayWidth * displayHeight * 2), //RGB565
		mMemoryHeap (new MemoryHeapBase(2 * mFrameSize)),
		mIndex(0)
	{
		LOGI("creator");

		CHECK(mISurface.get() != NULL);
		CHECK(mDisplayWidth > 0);
		CHECK(mDisplayHeight >0);
		CHECK(mMemoryHeap->heapID() >= 0);

		ISurface::BufferHeap bufferHeap (
				mDisplayWidth, mDisplayHeight,
				mDisplayWidth, mDisplayHeight,
				PIXEL_FORMAT_RGB_565,
				mMemoryHeap);

		char * buffer = (char*) mMemoryHeap->getBase();
		memset (buffer, 0, mFrameSize * 2);

		status_t err = mISurface->registerBuffers(bufferHeap);
		CHECK_EQ(err, OK);
	}

	MPlayerRenderer::~MPlayerRenderer() {
		mISurface->unregisterBuffers();
	}

	void MPlayerRenderer::getVideoOutSize (int orig_w, int orig_h,
			int *new_w, int *new_h)
	{
		float ratio;

		ratio = (float)mDisplayWidth / (float)orig_w;
		if (orig_h * ratio < mDisplayHeight) {
			*new_w = mDisplayWidth;
			*new_h = (int)((float)orig_h * ratio);
		} else {
			ratio = (float)mDisplayHeight / (float)orig_h;
			*new_w = (int)((float)orig_w * ratio);
			*new_h = mDisplayHeight;
		}
	}

	void MPlayerRenderer::renderBuffer() {
		size_t offset = mIndex * mFrameSize;
		mISurface->postBuffer(offset);
		mIndex = 1 - mIndex;
	}

	bool MPlayerRenderer::getBuffer(char**pbuffer, size_t*size){
		size_t offset = mIndex * mFrameSize;
		*pbuffer = (char*)mMemoryHeap->getBase() + offset;
		*size = mFrameSize;
		LOGV("get buffer result pos%x, size%u", *pbuffer, *size);
		return true;
	}
}
