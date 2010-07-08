LOCAL_PATH := $(call my-dir)
include  $(LOCAL_PATH)/../preconfig_x86_mmx_sse.mak

SWSCALE_FILES-yes = options.c rgb2rgb.c swscale.c utils.c yuv2rgb.c

SWSCALE_FILES-$(ARCH_BFIN)          +=  bfin/internal_bfin.c     \
                               bfin/swscale_bfin.c      \
                               bfin/yuv2rgb_bfin.c
SWSCALE_FILES-$(CONFIG_MLIB)        +=  mlib/yuv2rgb_mlib.c
SWSCALE_FILES-$(HAVE_ALTIVEC)       +=  ppc/yuv2rgb_altivec.c
SWSCALE_FILES-$(HAVE_MMX)           +=  x86/yuv2rgb_mmx.c
SWSCALE_FILES-$(HAVE_VIS)           +=  sparc/yuv2rgb_vis.c

include $(CLEAR_VARS)
FFCFLAGS += -fno-PIC  -include $(LOCAL_PATH)/../config.h \
			-DHAVE_AV_CONFIG_H
LOCAL_MODULE = libswscale
LOCAL_CFLAGS = $(FFCFLAGS)
LOCAL_SRC_FILES = $(SWSCALE_FILES-yes)
LOCAL_C_INCLUDES = $(LOCAL_PATH)/..
LOCAL_STATIC_LIBRARIES = libavutil
include $(BUILD_STATIC_LIBRARY)



