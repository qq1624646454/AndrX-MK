
include $(BUILD_SYSTEM)/lib.mk

#LOCAL_MODULE := $(foreach lib,$(LOCAL_MODULE), $(lib).so)

TARGET_OUT_DIR := $(OUT_OBJS_DIR)$(LOCAL_PATH)/shared_library/build/

TARGET_MODS_LIST := $(addprefix $(TARGET_OUT_DIR:%/build/=%/), $(addsuffix .so, $(LOCAL_MODULE)))


TARGET_OBJS_LIST := $(foreach _ofile, $(patsubst %.c, %.o, $(LOCAL_SRC_FILES)), \
                      $(TARGET_OUT_DIR)$(_ofile))
#TARGET_OBJS_LIST := $(foreach _ofile, $(patsubst %.c, %.o, $(call all-subdir-c-files)), \
#                      $(TARGET_OUT_DIR)$(_ofile))

TARGET_OBJS_DIRS_LIST := $(foreach _ofile, $(TARGET_OBJS_LIST), $(dir $(_ofile)))



LOCAL_CFLAGS += -fPIC

LOCAL_LDFLAGS += -shared 

#All symbols are retrieved from static libraries then imported to this shared
LOCAL_LDFLAGS += -Wl,--whole-archive \
                 $(call normalize-target-libraries,$(LOCAL_WHOLE_STATIC_LIBRARIES)) \
                 -Wl,--no-whole-archive \
                 -Wl,--start-group \
                 $(call normalize-target-libraries,$(LOCAL_STATIC_LIBRARIES)) \
                 -Wl,--end-group


.PHONY: $(LOCAL_MODULE).PREBUILD $(TARGET_OBJS_DIRS_LIST)
$(LOCAL_MODULE).PREBUILD : $(TARGET_OBJS_DIRS_LIST)
	@mkdir -pv $^
#	@$(info [Build] $(foreach _mfile, $(LOCAL_MODULE), $(_mfile).so))



$(TARGET_MODS_LIST) : $(LOCAL_MODULE).PREBUILD $(TARGET_OBJS_LIST)
	@$(info [Build] recipe for target $@)
	$(CC)  $(TARGET_OBJS_LIST) -Wl,--soname,$(notdir $@) $(LOCAL_LDFLAGS) -o $@



#-fPIC is position independent code, needed for shared libraries 
$(TARGET_OBJS_LIST) : $(TARGET_OUT_DIR)%.o : $(LOCAL_PATH)/%.c
	@$(CC) $< $(LOCAL_CFLAGS) -c -o $@ 




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

#--------------------------------------------------------------------------
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
#--------------------------------------------------------------------------




ALL_MODULES += $(TARGET_MODS_LIST)


#
# -L: 指定的是链接时的库路径，生成的可执行文件在运行时库的路径由
#     LD_LIBRARY_PATH环境变量指定
# -rpath: 库的路径会被硬编码进目标文件中,所在运行时会优先使用-rpath指定的
#         库的路径去搜索所依赖的库文件，因此可以不必指定LD_LIBRARY_PATH.
#         如果同时指定LD_LIBRARY_PATH，那优先使用LD_LIBRARY_PATH，再使用
#         -rpath，最后是系统默认的库路径/usr/lib, /lib
#  -rpath和-rpath-link都可以在链接时指定库的路径；但是运行可执行文件时，
#  -rpath-link指定的路径就不再有效(链接器没有将库的路径包含进可执行文件中)，
#  而-rpath指定的路径还有效(因为链接器已经将库的路径包含在可执行文件中了。)
#  不管使用了-rpath还是-rpath-link，LD_LIBRARY_PATH还是有效的

