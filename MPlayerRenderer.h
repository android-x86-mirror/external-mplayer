/* copied from Stagefright SoftwareRender
 *
 * okkwon <pinebud@gmail.com>
 *
 *
 * */

#ifndef _MPLAYER_RENDERER_H
#define _MPLAYER_RENDERER_H

#include <utils/RefBase.h>

namespace android {

	class ISurface;
	class MemoryHeapBase;

	class MPlayerRenderer {
		public:
			MPlayerRenderer(
					const sp<ISurface> &surface,
					size_t displayWidth, size_t displayHeight);
			~MPlayerRenderer();
			void renderBuffer();
			bool getBuffer(char **pbuffer, size_t *size);
			void getVideoOutSize (int orig_w, int orig_h,
					int *new_w, int *new_h);

		private:
			sp<ISurface> mISurface;
			size_t mDisplayWidth, mDisplayHeight;
			size_t mFrameSize;
			sp<MemoryHeapBase> mMemoryHeap;
			int mIndex;
	};
}

#endif
