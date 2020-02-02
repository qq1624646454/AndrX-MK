#Copyrights(C) 2020-2100.    Jielong Lin.    All rights reserved.
#
include $(BUILD_SYSTEM)/lib.mk

#0: disable compile log in meanwhile mm re-compile this module only when source is changed.
#1: enable compile log in meanwhile mm will re-compile this module
JLLim_DEBUG := 0

###########################################
# CFLAGS
###########################################

LOCAL_CFLAGS += -fPIC


###########################################
# LDFLAGS
###########################################

LOCAL_LDFLAGS += -L out/objs/shared_library
LOCAL_LDFLAGS += -L out/objs/static_library

#All symbols are retrieved from static libraries then imported to this shared
ifneq ($(strip $(LOCAL_WHOLE_STATIC_LIBRARIES)),)
LOCAL_LDFLAGS += -Wl$(comma)--whole-archive \
                 $(call find-path-for-static-libs \
                    , $(call normalize-target-libraries,$(LOCAL_WHOLE_STATIC_LIBRARIES)) \
                    , $(LOCAL_PATH)/ \
                 ) \
                 -Wl$(comma)--no-whole-archive
endif

ifneq ($(strip $(LOCAL_STATIC_LIBRARIES)),)
#LOCAL_LDFLAGS += -Wl$(comma)--start-group \
#                 $(call normalize-target-libraries,$(LOCAL_STATIC_LIBRARIES)) \
#                 -Wl$(comma)--end-group
LOCAL_LDFLAGS += -Wl$(comma)--start-group \
                 $(call find-path-for-static-libs \
                    , $(call normalize-target-libraries, $(LOCAL_STATIC_LIBRARIES)) \
                    , $(LOCAL_PATH)/ \
                 ) \
                 -Wl$(comma)--end-group
endif





###########################################################################
# Makefile Recipes, namely the rules associated with how to build modules
###########################################################################

#JLLim:
#    recipe list for all source files to object files then all object files to shared library
#
ifeq ($(strip $(JLLim_DEBUG)), 1)
$(foreach _tgt, $(LOCAL_MODULE), \
    $(eval $(call recipe-for-ObjList-colon-RuleForObj-colon-RuleForSrc \
               , $(OUT_OBJS_DIR)executable/build/$(_tgt)/ \
               , $(LOCAL_PATH)/ \
               , $(LOCAL_SRC_FILES) \
               , $(LOCAL_CFLAGS) \
               , \
           ) \
    ) \
    $(eval $(call recipe-for-target-colon-prerequisites \
               , $(strip $(OUT_OBJS_DIR)executable/build/$(_tgt)/)___static_libs \
               , $(shell rm -rf \
                            $(strip $(OUT_OBJS_DIR)executable/build/$(_tgt)/)___static_libs \
                            >/dev/null) \
               , mkdir -p $(strip $(OUT_OBJS_DIR)executable/build/$(_tgt)/)___static_libs; \
           ) \
    ) \
    $(eval $(call recipe-for-target-colon-prerequisites \
               , $(OUT_OBJS_DIR)executable/$(_tgt) \
               , $(addprefix $(strip $(OUT_OBJS_DIR)executable/build/$(_tgt)/), \
                     $(call generate-ObjList-from-SrcTree, $(LOCAL_SRC_FILES))) \
                     $(call filter-out-static-libs-as-prerequisites \
                        , $(call normalize-target-libraries, $(LOCAL_STATIC_LIBRARIES)) \
                        , $(LOCAL_PATH)/ \
                     ) \
                     $(strip $(OUT_OBJS_DIR)executable/build/$(_tgt)/)___static_libs \
               , $(CC) $$(filter %.o, $$^) \
                     $(subst $(comma),__________, $(LOCAL_LDFLAGS)) -o $$@; \
                 rm -rf $(strip $(OUT_OBJS_DIR)executable/build/$(_tgt)/)___static_libs; \
           ) \
    ) \
)
else  #JLLim_DEBUG=0
$(foreach _tgt, $(LOCAL_MODULE), \
    $(eval $(call recipe-for-ObjList-colon-RuleForObj-colon-RuleForSrc \
               , $(OUT_OBJS_DIR)executable/build/$(_tgt)/ \
               , $(LOCAL_PATH)/ \
               , $(LOCAL_SRC_FILES) \
               , $(LOCAL_CFLAGS) \
               , @ \
           ) \
    ) \
    $(eval $(call recipe-for-target-colon-prerequisites \
               , $(strip $(OUT_OBJS_DIR)executable/build/$(_tgt)/)___static_libs \
               , \
               , @mkdir -p $(strip $(OUT_OBJS_DIR)executable/build/$(_tgt)/)___static_libs; \
           ) \
    ) \
    $(eval $(call recipe-for-target-colon-prerequisites \
               , $(OUT_OBJS_DIR)executable/$(_tgt) \
               , $(addprefix $(strip $(OUT_OBJS_DIR)executable/build/$(_tgt)/), \
                     $(call generate-ObjList-from-SrcTree, $(LOCAL_SRC_FILES))) \
                     $(call filter-out-static-libs-as-prerequisites \
                        , $(call normalize-target-libraries, $(LOCAL_STATIC_LIBRARIES)) \
                        , $(LOCAL_PATH)/ \
                     ) \
                     $(strip $(OUT_OBJS_DIR)executable/build/$(_tgt)/)___static_libs \
               , @$(CC) $$(filter %.o, $$^) \
                     $(subst $(comma),__________, $(LOCAL_LDFLAGS)) -o $$@ \
           ) \
    ) \
)
endif


##### Why to put all libraries between --start-group and --end-group #####
#The archives should be a list of archive files. 
#They may be either explicit file names, or -l options.
#The specified archives are searched repeatedly until no new undefined references 
#are created. Normally, an archive is searched only once in the order that it is 
#specified on the command line. If a symbol in that archive is needed to resolve 
#an undefined symbol referred to by an object in an archive that appears later on 
#the command line, the linker would not be able to resolve that reference. 
#By grouping the archives, they all be searched repeatedly until all possible references 
#are resolved.
#Using this option has a significant performance cost. It is best to use it only when 
#there are unavoidable circular references between two or more archives


### JLLim:
###     := can directly read the value of the variable but += not,
###     The value of the module target list should be appended to ALL_MODULES rather than
###     its variable name that the value of the same variable may be changed to another value.
ALL_MODULES := $(ALL_MODULES) \
               $(addprefix $(OUT_OBJS_DIR)executable/, $(LOCAL_MODULE))

