LOCAL_PATH:= $(call my-dir)

#include $(CLEAR_VARS)

#LOCAL_SRC_FILES:=               \
    AudioFlinger.cpp            \
    Threads.cpp                 \
    Tracks.cpp                  \
    Effects.cpp                 \
    AudioMixer.cpp.arm          \
    AudioResampler.cpp.arm      \
    AudioPolicyService.cpp      \
    ServiceUtilities.cpp        \
    AudioResamplerCubic.cpp.arm \
    AudioResamplerSinc.cpp.arm

#LOCAL_SRC_FILES += StateQueue.cpp

#LOCAL_C_INCLUDES := \
    $(call include-path-for, audio-effects) \
    $(call include-path-for, audio-utils)

#LOCAL_SHARED_LIBRARIES := \
    libaudioutils \
    libcommon_time_client \
    libcutils \
    libutils \
    liblog \
    libbinder \
    libmedia \
    libnbaio \
    libhardware \
    libhardware_legacy \
    libeffects \
    libdl \
    libpowermanager

#LOCAL_STATIC_LIBRARIES := \
    libscheduling_policy \
    libcpustats \
    libmedia_helper
#LOCAL_MODULE:= libaudioflinger

#LOCAL_SRC_FILES += FastMixer.cpp FastMixerState.cpp AudioWatchdog.cpp

#LOCAL_CFLAGS += -DSTATE_QUEUE_INSTANTIATIONS='"StateQueueInstantiations.cpp"'

#include $(BUILD_SHARED_LIBRARY)

#
# build audio resampler test tool
#
include $(CLEAR_VARS)

LOCAL_SRC_FILES := $(call all-subdir-c-files)

LOCAL_MODULE := main 

LOCAL_MODULE_TAGS := optional

LOCAL_LDFLAGS += -L out/objs/static_library

#LOCAL_SHARED_LIBRARIES  := libutils liblog
LOCAL_STATIC_LIBRARIES  := libHello libWorld

include $(BUILD_EXECUTABLE)

include $(call all-makefiles-under,$(LOCAL_PATH))

