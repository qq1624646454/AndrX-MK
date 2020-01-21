# DO NOT use other shells such as zsh.

# Use bash, not whatever shell somebody has installed as /bin/sh
# This is repeated in config.mk, since envsetup.sh runs that file
# directly.
SHELL := /bin/bash

# this turns off the suffix rules built into make
.SUFFIXES:

# this turns off the RCS / SCCS implicit rules of GNU Make
% : RCS/%,v
% : RCS/%
% : %,v
% : s.%
% : SCCS/s.%

# If a rule fails, delete $@.
.DELETE_ON_ERROR:



# Absolute path of the present working direcotry.
# This overrides the shell variable $PWD, which does not necessarily points to
# the top of the source tree, for example when "make -C" is used in m/mm/mmm.
PWD := $(shell pwd)

TOP := .
TOPDIR :=

BUILD_SYSTEM := $(TOPDIR)mkutils/core


# This is the default target.  It must be the first declared target.
.PHONY: _default_goal 
DEFAULT_GOAL := _default_goal
$(DEFAULT_GOAL):

# Used to force goals to build.  Only use for conditionally defined goals.
.PHONY: FORCE
FORCE:


# Set up various standard variables based on configuration
# and host information.
include $(BUILD_SYSTEM)/config.mk


include $(BUILD_SYSTEM)/definitions.mk


$(shell mkdir -p $(OUT_DIR))

OUT_OBJS_DIR := $(OUT_DIR)objs/
$(shell mkdir -p $(OUT_OBJS_DIR))


# Make sure that there are no spaces in the absolute path; the
# build system can't deal with them.
ifneq ($(words $(shell pwd)),1)
$(warning ************************************************************)
$(warning You are building in a directory whose absolute path contains)
$(warning a space character:)
$(warning $(space))
$(warning "$(shell pwd)")
$(warning $(space))
$(warning Please move your source tree to a path that does not contain)
$(warning any spaces.)
$(warning ************************************************************)
$(error Directory names containing spaces not supported)
endif


ifneq ($(ONE_SHOT_MAKEFILE),)
# We've probably been invoked by the "mm" shell function
# with a subdirectory's makefile.
include $(ONE_SHOT_MAKEFILE)

#else # ONE_SHOT_MAKEFILE

#
# Include all of the makefiles in the system
#

# Can't use first-makefiles-under here because
# --mindepth=2 makes the prunes not work.
#subdir_makefiles := \
#	$(shell mkutils/tools/findleaves.py --prune=$(OUT_DIR) --prune=.repo --prune=.git --prune=.svn --prune=modem $(subdirs) AndrX.mk)
#
#$(foreach mk, $(subdir_makefiles), $(info including $(mk) ...)$(eval include $(mk)))

endif # ONE_SHOT_MAKEFILE



.PHONY: all_modules 
all_modules: $(ALL_MODULES)
	@echo


.PHONY: clean
clean:
	@rm -rf $(OUT_DIR)
	@echo "Entire build directory removed."



.PHONY: nothing
nothing:
	@echo Successfully read the makefiles.
