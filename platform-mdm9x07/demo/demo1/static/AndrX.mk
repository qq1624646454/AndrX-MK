
LOCAL_PATH := $(call my-dir)

include $(CLEAR_VARS)

#LOCAL_SRC_FILES := $(call all-subdir-c-files) 
LOCAL_SRC_FILES := my.c

LOCAL_MODULE := libmy

LOCAL_MODULE_TAGS := optional

#LOCAL_SHARED_LIBRARIES  := libutils liblog
#LOCAL_STATIC_LIBRARIES  := libtest libtest2 libY libs/libX

include $(BUILD_STATIC_LIBRARY)

