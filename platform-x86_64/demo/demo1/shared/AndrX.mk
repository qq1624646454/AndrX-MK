
LOCAL_PATH := $(call my-dir)

include $(CLEAR_VARS)

LOCAL_SRC_FILES := $(call all-subdir-c-files) 

LOCAL_MODULE := libmy

#LOCAL_SHARED_LIBRARIES  := libutils liblog
#LOCAL_STATIC_LIBRARIES  := libtest

$(info LOCAL_SRC_FILES=$(LOCAL_SRC_FILES))

include $(BUILD_SHARED_LIBRARY)

