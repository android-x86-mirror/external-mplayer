/* 
 * copied from StageFright
 *
 * okkwon <pinebud@gmail.com>
 *
 */

#define LOG_TAG "MPlayerRenderer"
#include <utils/Log.h>

#include <binder/MemoryHeapBase.h>
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
		CHECK(mISurface.get() != NULL);
		CHECK(mDisplayWidth > 0);
		CHECK(mDisplayHeight >0);
		CHECK(mMemoryHeap->heapID() >= 0);

		LOGE("creator");

		ISurface::BufferHeap bufferHeap (
				mDisplayWidth, mDisplayHeight,
				mDisplayWidth, mDisplayHeight,
				PIXEL_FORMAT_RGB_565,
				mMemoryHeap);
	

		status_t err = mISurface->registerBuffers(bufferHeap);
		CHECK_EQ(err, OK);
	}

	MPlayerRenderer::~MPlayerRenderer() {
		mISurface->unregisterBuffers();
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
		LOGE("get buffer result pos%x, size%d", *pbuffer, size);
		return true;
	}
}
