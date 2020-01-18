SHELL := /bin/bash

# Utility variables.
empty :=
space := $(empty) $(empty)
comma := ,



# ---------------------------------------------------------------
# figure out the output directories by referring to envsetup.mk
# ---------------------------------------------------------------

ifeq (,$(strip $(OUT_DIR)))
ifeq (,$(strip $(OUT_DIR_COMMON_BASE)))
OUT_DIR := $(TOPDIR)out/$(TARGET_PRODUCT)
else
OUT_DIR := $(OUT_DIR_COMMON_BASE)/$(notdir $(PWD))
endif
endif

TARGET_OUT_COMMON_INTERMEDIATES := $(TARGET_COMMON_OUT_ROOT)/obj

TARGET_OUT := $(PRODUCT_OUT)/$(TARGET_COPY_OUT_SYSTEM)
TARGET_OUT_EXECUTABLES:= $(TARGET_OUT)/bin
TARGET_OUT_SHARED_LIBRARIES:= $(TARGET_OUT)/lib
TARGET_OUT_ETC := $(TARGET_OUT)/etc

# Standard source directories.

# TODO: Enforce some kind of layering; only add include paths
#       when a module links against a particular library.
# TODO: See if we can remove most of these from the global list.
SRC_HEADERS := \
	$(TOPDIR)system/core/include \
	$(TOPDIR)hardware/libhardware/include \
	$(TOPDIR)hardware/libhardware_legacy/include \
	$(TOPDIR)hardware/ril/include \
	$(TOPDIR)libnativehelper/include \
	$(TOPDIR)frameworks/native/include \
	$(TOPDIR)frameworks/native/opengl/include \
	$(TOPDIR)frameworks/av/include \
	$(TOPDIR)frameworks/base/include \
	$(TOPDIR)external/skia/include

SRC_LIBRARIES:= $(TOPDIR)libs


# ---------------------------------------------------------------
# Various mappings to avoid hard-coding paths all over the place by referring to pathmap.mk
# ---------------------------------------------------------------
#
## A mapping from shorthand names to include directories.
#
pathmap_INCL := \
    bootloader:bootable/bootloader/legacy/include \
    camera:system/media/camera/include \
    corecg:external/skia/include/core \
    frameworks-base:frameworks/base/include \
    frameworks-native:frameworks/native/include \
    graphics:external/skia/include/core \
    libc:bionic/libc/include \
    libhardware:hardware/libhardware/include \
    libhardware_legacy:hardware/libhardware_legacy/include \
    libhost:build/libs/host/include \
    libm:bionic/libm/include \
    libnativehelper:libnativehelper/include \
    libpagemap:system/extras/libpagemap/include \
    libril:hardware/ril/include \
    libstdc++:bionic/libstdc++/include \
    libthread_db:bionic/libthread_db/include \
    mkbootimg:system/core/mkbootimg \
    opengl-tests-includes:frameworks/native/opengl/tests/include \
    recovery:bootable/recovery \
    system-core:system/core/include \
    audio-effects:system/media/audio_effects/include \
    audio-utils:system/media/audio_utils/include \
    audio-route:system/media/audio_route/include \
    wilhelm:frameworks/wilhelm/include \
    wilhelm-ut:frameworks/wilhelm/src/ut \
    speex:external/speex/include
#
# Returns the path to the requested module's include directory,
# relative to the root of the source tree.  Does not handle external
# modules.
#
# $(1): a list of modules (or other named entities) to find the includes for
#
define include-path-for
$(foreach n,$(1),$(patsubst $(n):%,%,$(filter $(n):%,$(pathmap_INCL))))
endef




# ###############################################################
# Build system internal files
# ###############################################################

CLEAR_VARS:= $(BUILD_SYSTEM)/clear_vars.mk
BUILD_STATIC_LIBRARY:= $(BUILD_SYSTEM)/static_library.mk
BUILD_SHARED_LIBRARY:= $(BUILD_SYSTEM)/shared_library.mk
BUILD_EXECUTABLE:= $(BUILD_SYSTEM)/executable.mk





# ###############################################################
# Set up final options.
# ###############################################################

HOST_GLOBAL_CFLAGS += $(COMMON_GLOBAL_CFLAGS)
HOST_RELEASE_CFLAGS += $(COMMON_RELEASE_CFLAGS)

HOST_GLOBAL_CPPFLAGS += $(COMMON_GLOBAL_CPPFLAGS)
HOST_RELEASE_CPPFLAGS += $(COMMON_RELEASE_CPPFLAGS)

TARGET_GLOBAL_CFLAGS += $(COMMON_GLOBAL_CFLAGS)
TARGET_RELEASE_CFLAGS += $(COMMON_RELEASE_CFLAGS)

TARGET_GLOBAL_CPPFLAGS += $(COMMON_GLOBAL_CPPFLAGS)
TARGET_RELEASE_CPPFLAGS += $(COMMON_RELEASE_CPPFLAGS)

HOST_GLOBAL_LD_DIRS += -L$(HOST_OUT_INTERMEDIATE_LIBRARIES)
TARGET_GLOBAL_LD_DIRS += -L$(TARGET_OUT_INTERMEDIATE_LIBRARIES)

HOST_PROJECT_INCLUDES:= $(SRC_HEADERS) $(SRC_HOST_HEADERS) $(HOST_OUT_HEADERS)
TARGET_PROJECT_INCLUDES:= $(SRC_HEADERS) $(TARGET_OUT_HEADERS) \
		$(TARGET_DEVICE_KERNEL_HEADERS) $(TARGET_BOARD_KERNEL_HEADERS) \
		$(TARGET_PRODUCT_KERNEL_HEADERS)

# Many host compilers don't support these flags, so we have to make
# sure to only specify them for the target compilers checked in to
# the source tree.
TARGET_GLOBAL_CFLAGS += $(TARGET_ERROR_FLAGS)
TARGET_GLOBAL_CPPFLAGS += $(TARGET_ERROR_FLAGS)

HOST_GLOBAL_CFLAGS += $(HOST_RELEASE_CFLAGS)
HOST_GLOBAL_CPPFLAGS += $(HOST_RELEASE_CPPFLAGS)

TARGET_GLOBAL_CFLAGS += $(TARGET_RELEASE_CFLAGS)
TARGET_GLOBAL_CPPFLAGS += $(TARGET_RELEASE_CPPFLAGS)



# Historical SDK version N is stored in $(HISTORICAL_SDK_VERSIONS_ROOT)/N.
# The 'current' version is whatever this source tree is.
#
# sgrax     is the opposite of xargs.  It takes the list of args and puts them
#           on each line for sort to process.
# sort -g   is a numeric sort, so 1 2 3 10 instead of 1 10 2 3.

# Numerically sort a list of numbers
# $(1): the list of numbers to be sorted
define numerically_sort
$(shell function sgrax() { \
    while [ -n "$$1" ] ; do echo $$1 ; shift ; done \
    } ; \
    ( sgrax $(1) | sort -g ) )
endef
#TARGET_AVAILABLE_SDK_VERSIONS := $(call numerically_sort,\
#    $(patsubst $(HISTORICAL_SDK_VERSIONS_ROOT)/%/android.jar,%, \
#    $(wildcard $(HISTORICAL_SDK_VERSIONS_ROOT)/*/android.jar)))
#


