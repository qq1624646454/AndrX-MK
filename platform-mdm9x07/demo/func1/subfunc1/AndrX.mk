
LOCAL_PATH := $(call my-dir)

include $(CLEAR_VARS)

LOCAL_SRC_FILES := $(call all-subdir-c-files) 

LOCAL_MODULE := libsubfunc1 libsubfuncX

LOCAL_MODULE_TAGS := optional

#LOCAL_SHARED_LIBRARIES  := libutils liblog
#LOCAL_STATIC_LIBRARIES  := libtest

include $(BUILD_SHARED_LIBRARY)

include $(CLEAR_VARS)

#LOCAL_SRC_FILES := $(call all-subdir-c-files) 
LOCAL_SRC_FILES := A/test.c A/AA/test.c B/test.c C/test.c

LOCAL_MODULE := libsubfunc2 libsubfuncY

LOCAL_MODULE_TAGS := optional

#LOCAL_SHARED_LIBRARIES  := libutils liblog
#LOCAL_STATIC_LIBRARIES  := libtest

include $(BUILD_SHARED_LIBRARY)


include $(CLEAR_VARS)

#LOCAL_SRC_FILES := $(call all-subdir-c-files) 
LOCAL_SRC_FILES := test.c  

LOCAL_MODULE := libWorld libHello

LOCAL_MODULE_TAGS := optional

#LOCAL_SHARED_LIBRARIES  := libutils liblog
LOCAL_STATIC_LIBRARIES  := libtest libtest2 libY libs/libX

include $(BUILD_STATIC_LIBRARY)


include $(CLEAR_VARS)

LOCAL_SRC_FILES := $(call all-subdir-c-files) 

LOCAL_MODULE := libWorld___x libHello__x

LOCAL_MODULE_TAGS := optional

#LOCAL_SHARED_LIBRARIES  := libutils liblog
#LOCAL_STATIC_LIBRARIES  := libtest libtest2 libY libs/libX

include $(BUILD_STATIC_LIBRARY)


include $(CLEAR_VARS)

LOCAL_SRC_FILES := $(call all-subdir-c-files) 

LOCAL_MODULE := World___x Hello__x

LOCAL_MODULE_TAGS := optional

#LOCAL_SHARED_LIBRARIES  := libutils liblog
#LOCAL_STATIC_LIBRARIES  := libtest libtest2 libY libs/libX

include $(BUILD_EXECUTABLE)

