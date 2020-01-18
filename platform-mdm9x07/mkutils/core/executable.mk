
include $(BUILD_SYSTEM)/lib.mk

#Append the runtime library path by self-definiton.
LOCAL_CFLAGS += -Wl,-rpath,/reach/vendor/modules/lib:/reach/vendor/modules/usr/lib

#LOCAL_SRC_FILES

#LOCAL_SHARED_LIBRARIES

#LOCAL_STATIC_LIBRARIES

#LOCAL_C_INCLUDES


.PHONY: $(LOCAL_MODULE)
$(LOCAL_MODULE) ::
	@echo exec: LOCAL_MODULE=$(LOCAL_MODULE) 
	@echo exec: LOCAL_PATH=$(LOCAL_PATH)
	@echo $(call normalize-target-libraries, $(LOCAL_SHARED_LIBRARIES))


COMM_FLAGS := -I"$(MKRootPath)" -I"./inc" -I. -g  -fPIC

LIB_SO_FLAGS := $(COMM_FLAGS) -shared

LIB_A_FLAGS := $(COMM_FLAGS)

EXEC_FLAGS := $(COMM_FLAGS) -L"$(MKPath)" \
              -Wl,-rpath,/reach/vendor/modules/lib:/reach/vendor/modules/usr/lib



#ALL_SRCFILES := $(shell find ./apis -type f -a -name *.c)

#SOURCE := $(wildcard *.c)
#OBJECT := $(patsubst %.c, %.o, $(SOURCE))

#	$(info      $(CC) $<)



.PHONY : $(MKTGT_CLEAN) clean $(MKTGT_SDK) sdk $(MKTGT_ALL) all

all : $(MKTGT_ALL) sdk


