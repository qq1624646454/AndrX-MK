LOCAL_PATH:= $(call my-dir)

include $(CLEAR_VARS)

LOCAL_SRC_FILES := $(call all-subdir-c-files)

LOCAL_MODULE := demo-app

LOCAL_MODULE_TAGS := optional

LOCAL_SHARED_LIBRARIES  := libmy
LOCAL_STATIC_LIBRARIES  := libmy

include $(BUILD_EXECUTABLE)

#include $(call all-makefiles-under,$(LOCAL_PATH))

