
###########################################################
## Retrieve the directory of the current makefile
###########################################################

# Figure out where we are.
define my-dir
$(strip \
  $(eval LOCAL_MODULE_MAKEFILE := $$(lastword $$(MAKEFILE_LIST))) \
  $(if $(filter $(CLEAR_VARS),$(LOCAL_MODULE_MAKEFILE)), \
    $(error LOCAL_PATH must be set before including $$(CLEAR_VARS)) \
   , \
    $(patsubst %/,%,$(dir $(LOCAL_MODULE_MAKEFILE))) \
   ) \
 )
endef



###########################################################
## Retrieve a list of all makefiles immediately below some directory
###########################################################

define all-makefiles-under
$(wildcard $(1)/*/AndrX.mk)
endef



###########################################################
## Look under a directory for makefiles that don't have parent
## makefiles.
###########################################################

# $(1): directory to search under
# Ignores $(1)/Android.mk
#huangzhl add for filter .svn modem dir
define first-makefiles-under
$(shell build/tools/findleaves.py --prune=$(OUT_DIR) --prune=.repo --prune=.git --prune=.svn --prune=modem \
        --mindepth=2 $(1) Android.mk)
endef



###########################################################
## Retrieve a list of all makefiles immediately below your directory
###########################################################

define all-subdir-makefiles
$(call all-makefiles-under,$(call my-dir))
endef



###########################################################
## Find all of the c files under the named directories.
## Meant to be used like:
##    SRC_FILES := $(call all-c-files-under,src tests)
###########################################################

define all-c-files-under
$(patsubst ./%,%, \
  $(shell cd $(LOCAL_PATH) ; \
          find -L $(1) -name "*.c" -and -not -name ".*") \
 )
endef



###########################################################
## Find all of the c files from here.  Meant to be used like:
##    SRC_FILES := $(call all-subdir-c-files)
###########################################################

define all-subdir-c-files
$(call all-c-files-under,.)
endef



###########################################################
## Find all of the files matching pattern
##    SRC_FILES := $(call find-subdir-files, <pattern>)
###########################################################

define find-subdir-files
$(patsubst ./%,%,$(shell cd $(LOCAL_PATH) ; find -L $(1)))
endef



###########################################################
# find the files in the subdirectory $1 of LOCAL_DIR
# matching pattern $2, filtering out files $3
# e.g.
#     SRC_FILES += $(call find-subdir-subdir-files, \
#                         css, *.cpp, DontWantThis.cpp)
###########################################################

define find-subdir-subdir-files
$(filter-out $(patsubst %,$(1)/%,$(3)),$(patsubst ./%,%,$(shell cd \
            $(LOCAL_PATH) ; find -L $(1) -maxdepth 1 -name $(2))))
endef



###########################################################
## Scan through each directory of $(1) looking for files
## that match $(2) using $(wildcard).  Useful for seeing if
## a given directory or one of its parents contains
## a particular file.  Returns the first match found,
## starting furthest from the root.
###########################################################

define find-parent-file
$(strip \
  $(eval _fpf := $(wildcard $(foreach f, $(2), $(strip $(1))/$(f)))) \
  $(if $(_fpf),$(_fpf), \
       $(if $(filter-out ./ .,$(1)), \
             $(call find-parent-file,$(patsubst %/,%,$(dir $(1))),$(2)) \
        ) \
   ) \
)
endef



###########################################################
## Convert "path/to/libXXX.so" to "-lXXX".
## Any "path/to/libXXX.a" elements pass through unchanged.
###########################################################

define normalize-libraries
$(foreach so,$(filter %.so,$(1)),-l$(patsubst lib%.so,%,$(notdir $(so))))\
$(filter-out %.so,$(1))
endef

# TODO: change users to call the common version.
define normalize-host-libraries
$(call normalize-libraries,$(1))
endef

define normalize-target-libraries
$(call normalize-libraries,$(1))
endef






###########################################################
## Commands for running gcc to link a shared library or package
###########################################################

# ld just seems to be so finicky with command order that we allow
# it to be overriden en-masse see combo/linux-arm.make for an example.
ifneq ($(TARGET_CUSTOM_LD_COMMAND),true)
define transform-o-to-shared-lib-inner
$(hide) $(PRIVATE_CXX) \
    $(PRIVATE_TARGET_GLOBAL_LDFLAGS) \
    -Wl,-rpath-link=$(TARGET_OUT_INTERMEDIATE_LIBRARIES) \
    -Wl,-rpath,\$$ORIGIN/../lib \
    -shared -Wl,-soname,$(notdir $@) \
    $(PRIVATE_LDFLAGS) \
    $(PRIVATE_TARGET_GLOBAL_LD_DIRS) \
    $(PRIVATE_ALL_OBJECTS) \
    -Wl,--whole-archive \
    $(call normalize-target-libraries,$(PRIVATE_ALL_WHOLE_STATIC_LIBRARIES)) \
    -Wl,--no-whole-archive \
    $(if $(PRIVATE_GROUP_STATIC_LIBRARIES),-Wl$(comma)--start-group) \
    $(call normalize-target-libraries,$(PRIVATE_ALL_STATIC_LIBRARIES)) \
    $(if $(PRIVATE_GROUP_STATIC_LIBRARIES),-Wl$(comma)--end-group) \
    $(call normalize-target-libraries,$(PRIVATE_ALL_SHARED_LIBRARIES)) \
    -o $@ \
    $(PRIVATE_LDLIBS)
endef
endif

define transform-o-to-shared-lib
@mkdir -p $(dir $@)
@echo "target SharedLib: $(PRIVATE_MODULE) ($@)"
$(transform-o-to-shared-lib-inner)
endef


###########################################################
## Commands for filtering a target executable or library
###########################################################

define transform-to-stripped
@mkdir -p $(dir $@)
@echo "target Strip: $(PRIVATE_MODULE) ($@)"
$(hide) $(TARGET_STRIP_COMMAND)
endef


###########################################################
## Commands for running gcc to link an executable
###########################################################

ifneq ($(TARGET_CUSTOM_LD_COMMAND),true)
define transform-o-to-executable-inner
$(hide) $(PRIVATE_CXX) \
    $(PRIVATE_TARGET_GLOBAL_LDFLAGS) \
    $(PRIVATE_TARGET_GLOBAL_LD_DIRS) \
    -Wl,-rpath-link=$(TARGET_OUT_INTERMEDIATE_LIBRARIES) \
    -Wl,-rpath,\$$ORIGIN/../lib \
    $(PRIVATE_LDFLAGS) \
    $(PRIVATE_ALL_OBJECTS) \
    -Wl,--whole-archive \
    $(call normalize-target-libraries,$(PRIVATE_ALL_WHOLE_STATIC_LIBRARIES)) \
    -Wl,--no-whole-archive \
    $(if $(PRIVATE_GROUP_STATIC_LIBRARIES),-Wl$(comma)--start-group) \
    $(call normalize-target-libraries,$(PRIVATE_ALL_STATIC_LIBRARIES)) \
    $(if $(PRIVATE_GROUP_STATIC_LIBRARIES),-Wl$(comma)--end-group) \
    $(call normalize-target-libraries,$(PRIVATE_ALL_SHARED_LIBRARIES)) \
    -o $@ \
    $(PRIVATE_LDLIBS)
endef
endif

define transform-o-to-executable
@mkdir -p $(dir $@)
@echo "target Executable: $(PRIVATE_MODULE) ($@)"
$(transform-o-to-executable-inner)
endef



###########################################################
## Commands for running gcc to link a statically linked
## executable.  In practice, we only use this on arm, so
## the other platforms don't have the
## transform-o-to-static-executable defined
###########################################################

ifneq ($(TARGET_CUSTOM_LD_COMMAND),true)
define transform-o-to-static-executable-inner
endef
endif

define transform-o-to-static-executable
@mkdir -p $(dir $@)
@echo "target StaticExecutable: $(PRIVATE_MODULE) ($@)"
$(transform-o-to-static-executable-inner)
endef











###########################################################
## Jielong Lin 
###########################################################

#JLLim [FUNCTION]
#
# $(1) is srctree, default by $(LOCAL_SRC_FILES) when $(1) is empty.
#
# TEST as follows:
# .
# ├── A
# │   ├── AA
# │   │   └── test.c
# │   └── test.c
# ├── AndrX.mk
# ├── B
# │   └── test.c
# ├── C
# │   └── test.c
# ├── main.c
# └── test.c 
#
# For example:
#     $(info $(call clone-DirTree-from-SrcTree, $(LOCAL_SRC_FILES)))
#   OR
#     $(info $(call clone-DirTree-from-SrcTree))
# As result:
#     ./ A/ A/AA/ B/ C/
# The above equal to the below:
#     .
#     ├── A
#     │   └── AA
#     ├── B
#     └── C
# 
define clone-DirTree-from-SrcTree
$(if $(strip $(1)), \
     $(sort $(foreach _item, $(strip $(1)), $(dir $(_item)))), \
     $(sort $(foreach _item, $(strip $(LOCAL_SRC_FILES)), $(dir $(_item)))) \
)
endef

#JLLim [FUNCTION]
#
# $(1) is srctree, default by $(LOCAL_SRC_FILES) when $(1) is empty.
#
# For example:
#     $(info $(call generate-ObjList-from-SrcTree))
# As result:
#     A/AA/test.o A/test.o B/test.o C/test.o main.o test.o
#
define generate-ObjList-from-SrcTree
$(if $(1), \
     $(sort $(patsubst %.c, %.o, $(strip $(1)))), \
     $(sort $(patsubst %.c, %.o, $(strip $(LOCAL_SRC_FILES)))) \
)
endef


# $(words $(LOCAL_MODULE)) # to get the count



###
### Recipe for target colon prerequisites
###     Target : Prerequisites 
###     [\t]Commands
###


#JLLim [FUNCTION]
#
# $(1) is build work path to target that its relative path to TOPDIR
# $(2) is work path to source code, default by LOCAL_PATH
# $(3) is source file list, default by LOCAL_SRC_FILES
# $(4) is cflags 
# $(5) is echo selection by pass @
define recipe-for-ObjList-colon-RuleForObj-colon-RuleForSrc
$(addprefix $(strip $(1)), $(call generate-ObjList-from-SrcTree, $(3))) : $(strip $(1))%.o : $(strip $(2))%.c
	$(5)mkdir -p $$(dir $$@)
	$(5)$(CC) $$< $(4) -c -o $$@
endef


#comma := ,

#JLLim [FUNCTION]
#
#
define recipe-for-target-colon-prerequisites 
$(strip $(1)) : $(strip $(2))
	@$(if $(filter-out ___static_libs, $(notdir $(strip $(1)))) \
	       , echo -e "\n[Build] Recipe for target: $(notdir $(strip $(1)))" \
           , )
	$(subst __________,$(comma), $(3))
endef

