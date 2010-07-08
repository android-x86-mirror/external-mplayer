LOCAL_PATH := $(call my-dir)
include  $(LOCAL_PATH)/../preconfig_x86_mmx_sse.mak

POSTPROC_FILES-yes := postprocess.c

include $(CLEAR_VARS)
FFCFLAGS += -include $(LOCAL_PATH)/../config.h \
			-DHAVE_AV_CONFIG_H
LOCAL_MODULE = libpostproc
LOCAL_CFLAGS = $(FFCFLAGS)
LOCAL_SRC_FILES = $(POSTPROC_FILES-yes)
LOCAL_C_INCLUDES = $(LOCAL_PATH)/..
LOCAL_STATIC_LIBRARIES = 
include $(BUILD_STATIC_LIBRARY)



