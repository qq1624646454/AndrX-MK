

LOCAL_MODULE := $(strip $(LOCAL_MODULE))
ifeq ($(LOCAL_MODULE),)
  $(error $(LOCAL_PATH): LOCAL_MODULE is not defined)
endif


LOCAL_CFLAGS += $(foreach _incfile, $(LOCAL_C_INCLUDES), -I"$(dir $(_incfile)"))
LOCAL_CFLAGS += ${CFLAGS}

#LDFLAGS is defined to -Wl,-O1 -Wl,--hash-style=gnu -Wl,--as-needed which are the 
#parameter of gcc/g++ rather than ld, so LDFLAGS should be append to LOCAL_CFLAGS
# 
#Config the runtime library path
LOCAL_LDFLAGS += ${LDFLAGS}\
                 -Wl,-rpath,/reach/vendor/modules/bin:/reach/vendor/modules/lib

#$(foreach <var>,<list>,<text>) for Makefile
LOCAL_SHARED_LIBRARIES := $(foreach lib,$(LOCAL_SHARED_LIBRARIES), $(lib).so)
LOCAL_STATIC_LIBRARIES := $(foreach lib,$(LOCAL_STATIC_LIBRARIES), $(lib).a)
LOCAL_WHOLE_STATIC_LIBRARIES := $(foreach lib,$(LOCAL_WHOLE_STATIC_LIBRARIES), $(lib).a)

#Pass all shared libraries to ld by converting libXXX.so to -lXXX
#But any static library elements named path/to/libXXX.a pass through unchanged.
LOCAL_LDFLAGS += $(call normalize-target-libraries,$(LOCAL_SHARED_LIBRARIES))


#LOCAL_SRC_FILES :=

#OUT_OBJS_DIR

#$(patsubst %.c, %.o, $(LOCAL_SRC_FILES)) : %.o : %.c
#	@echo $(CC) $(LOCAL_CFLAGS) $< -o $@

#ALL_MODULES += $(LOCAL_MODULE)

