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

LOCAL_LDFLAGS +=





##################################################
# Included Static Libraries should be extracted  
##################################################

#JLLim [FUNCTION]
#
# Used for command-line under Makefile recipe
#
# $(1) is one target equaled to $@
# $(2) is the associated prerequisites equaled to $^
# $(3) is the source path equaled to LOCAL_PATH
# $(4) is the static libraries equaled to LOCAL_STATIC_LIBRARIES
#
#
ifeq ($(strip $(JLLim_DEBUG)), 1)
define collect-and-extract-static-libs-to-o-by-shell
    echo  __1__=$(1); \
    echo  __2__=$(2); \
    echo  __3__=$(3); \
    echo  __4__=$(4); \
    __lstLib=; \
    for f in $(4); do \
        echo _fl=$$$${f};  \
        if [ -e $(3)/$$$${f} ]; then \
            __lstLib="$$$${__lstLib} $(3)/$$$${f}"; \
        elif [ -e $$$${f} ]; then \
            __lstLib="$$$${__lstLib} $$$${f}"; \
        elif [ -e $(OUT_OBJS_DIR)static_library/$$$${f} ]; then \
            __lstLib="$$$${__lstLib} $(OUT_OBJS_DIR)static_library/$$$${f}"; \
        else \
            echo -e "\nFound associated static libraries as follows:\n$$$${__lstLib}\n"; \
            echo -e "ERROR: not found $$$${f} \n\n"; \
			exit -1; \
        fi \
    done; \
    echo __lstLib=$$$${__lstLib}; \
    mkdir -pv $(1); \
 	i=0; \
    __lstObjs=; \
    for f in $$$${__lstLib}; do \
        for _f in `$(AR) -t $$$${f}`; do \
            $(AR) p $$$${f} $$$${_f} > $(1)/$$$${i}_`basename $$$${f}`_$$$${_f}; \
            i=$$$$((i+1)); \
        done; \
    done; \
    #rm -rvf $(1);
endef
else  #JLLim_DEBUG=0
define collect-and-extract-static-libs-to-o-by-shell
    __lstLib=; \
    for f in $(4); do \
        if [ -e $(3)/$$$${f} ]; then \
            __lstLib="$$$${__lstLib} $(3)/$$$${f}"; \
        elif [ -e $$$${f} ]; then \
            __lstLib="$$$${__lstLib} $$$${f}"; \
        elif [ -e $(OUT_OBJS_DIR)static_library/$$$${f} ]; then \
            __lstLib="$$$${__lstLib} $(OUT_OBJS_DIR)static_library/$$$${f}"; \
        else \
            echo -e "\nFound associated static libraries as follows:\n$$$${__lstLib}\n"; \
            echo -e "ERROR: not found $$$${f} \n\n"; \
			exit -1; \
        fi \
    done; \
    mkdir -p $(1); \
 	i=0; \
    __lstObjs=; \
    for f in $$$${__lstLib}; do \
        for _f in `$(AR) -t $$$${f}`; do \
            $(AR) p $$$${f} $$$${_f} > $(1)/$$$${i}_`basename $$$${f}`_$$$${_f}; \
            i=$$$$((i+1)); \
        done; \
    done; \
    #rm -rvf $(1);
endef
endif

define get-obj-list
$(shell ls $(strip $(1)) 2>/dev/null)
endef

###########################################################################
# Makefile Recipes, namely the rules associated with how to build modules
###########################################################################

#JLLim:
#    recipe list for all source files to object files then all object files to shared library
#
#
ifeq ($(strip $(JLLim_DEBUG)), 1)
#echo target-path: $(OUT_OBJS_DIR)static_library/build/$(basename $(notdir $$@))
$(foreach _tgt, $(LOCAL_MODULE), \
    $(eval $(call recipe-for-ObjList-colon-RuleForObj-colon-RuleForSrc \
               , $(OUT_OBJS_DIR)static_library/build/$(_tgt)/ \
               , $(LOCAL_PATH)/ \
               , $(LOCAL_SRC_FILES) \
               , $(LOCAL_CFLAGS) \
           ) \
    ) \
    $(eval $(call recipe-for-target-colon-prerequisites \
               , $(strip $(OUT_OBJS_DIR)static_library/build/$(_tgt)/)___static_libs \
               , $(shell rm -rf \
                            $(strip $(OUT_OBJS_DIR)static_library/build/$(_tgt)/)___static_libs \
                            >/dev/null) \
               , $(call collect-and-extract-static-libs-to-o-by-shell, $$@, $$^, \
                            $(LOCAL_PATH), $(LOCAL_STATIC_LIBRARIES) \
                 ) \
           ) \
    ) \
    $(eval $(call recipe-for-target-colon-prerequisites \
               , $(OUT_OBJS_DIR)static_library/$(_tgt).a \
               , $(addprefix $(strip $(OUT_OBJS_DIR)static_library/build/$(_tgt)/), \
                     $(call generate-ObjList-from-SrcTree, $(LOCAL_SRC_FILES)) \
                 )  \
                 $(strip $(OUT_OBJS_DIR)static_library/build/$(_tgt)/)___static_libs \
               , $(AR) rcs $$@ \
                       $(call get-obj-list \
                                , $(OUT_OBJS_DIR)static_library/build/$(_tgt)/___static_libs/*.o) \
                       $$(filter %.o, $$^) \
           ) \
    ) \
)
else  #JLLim_DEBUG=0
$(foreach _tgt, $(LOCAL_MODULE), \
    $(eval $(call recipe-for-ObjList-colon-RuleForObj-colon-RuleForSrc \
               , $(OUT_OBJS_DIR)static_library/build/$(_tgt)/ \
               , $(LOCAL_PATH)/ \
               , $(LOCAL_SRC_FILES) \
               , $(LOCAL_CFLAGS) \
               , @ \
           ) \
    ) \
    $(eval $(call recipe-for-target-colon-prerequisites \
               , $(strip $(OUT_OBJS_DIR)static_library/build/$(_tgt)/)___static_libs \
               , \
               , @$(call collect-and-extract-static-libs-to-o-by-shell, $$@, $$^, \
                            $(LOCAL_PATH), $(LOCAL_STATIC_LIBRARIES) \
                 ) \
           ) \
    ) \
    $(eval $(call recipe-for-target-colon-prerequisites \
               , $(OUT_OBJS_DIR)static_library/$(_tgt).a \
               , $(addprefix $(strip $(OUT_OBJS_DIR)static_library/build/$(_tgt)/), \
                     $(call generate-ObjList-from-SrcTree, $(LOCAL_SRC_FILES)) \
                 )  \
                 $(strip $(OUT_OBJS_DIR)static_library/build/$(_tgt)/)___static_libs \
               , @$(AR) rcs $$@ \
                       $(call get-obj-list \
                                , $(OUT_OBJS_DIR)static_library/build/$(_tgt)/___static_libs/*.o) \
                       $$(filter %.o, $$^) \
           ) \
    ) \
)
endif

#$(shell rm -rf \
#                            $(strip $(OUT_OBJS_DIR)static_library/build/$(_tgt)/)___static_libs \
#                            >/dev/null) 

#               , $(AR) rcs $$@ $(OUT_OBJS_DIR)static_library/build/$(_tgt)/)___static_libs/*.o \
#                     $$(filter %.o, $$^) \





### JLLim:
###     := can directly read the value of the variable but += not,
###     The value of the module target list should be appended to ALL_MODULES rather than
###     its variable name that the value of the same variable may be changed to another value.
ALL_MODULES := $(ALL_MODULES) \
               $(addsuffix .a, $(addprefix $(OUT_OBJS_DIR)static_library/, $(LOCAL_MODULE)))

