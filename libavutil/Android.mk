LOCAL_PATH := $(call my-dir)
include  $(LOCAL_PATH)/../preconfig_x86_mmx_sse.mak

AVUTIL_FILES-yes = adler32.c                                              \
       aes.c                                                            \
       avstring.c                                                       \
       base64.c                                                         \
       crc.c                                                            \
       des.c                                                            \
       error.c                                                          \
       eval.c                                                           \
       fifo.c                                                           \
       intfloat_readwrite.c                                             \
       lfg.c                                                            \
       lls.c                                                            \
       log.c                                                            \
       lzo.c                                                            \
       mathematics.c                                                    \
       md5.c                                                            \
       mem.c                                                            \
       pixdesc.c                                                        \
       random_seed.c                                                    \
       rational.c                                                       \
       rc4.c                                                            \
       sha.c                                                            \
       tree.c                                                           \
       utils.c                                                        

FFCFLAGS += -include $(LOCAL_PATH)/../config.h \
			-DHAVE_AV_CONFIG_H
include $(CLEAR_VARS)
LOCAL_MODULE = libavutil
LOCAL_CFLAGS = $(FFCFLAGS)
LOCAL_SRC_FILES = $(AVUTIL_FILES-yes)
LOCAL_C_INCLUDES = $(LOCAL_PATH)/..
LOCAL_STATIC_LIBRARIES = 
include $(BUILD_STATIC_LIBRARY)
include $(CLEAR_VARS)
LOCAL_MODULE = libavutil_crc
LOCAL_CFLAGS = $(FFCFLAGS) -DTEST
LOCAL_SRC_FILES = crc.c
LOCAL_MODULE_TAGS := debug
LOCAL_C_INCLUDES = $(LOCAL_PATH)/..
LOCAL_STATIC_LIBRARIES = libavutil 
include $(BUILD_EXECUTABLE)




