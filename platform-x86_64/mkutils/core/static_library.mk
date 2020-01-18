
include $(BUILD_SYSTEM)/lib.mk

.PHONY: $(LOCAL_MODULE)
$(LOCAL_MODULE) ::
	@echo static lib: LOCAL_MODULE=$(LOCAL_MODULE) 
	@echo static lib: LOCAL_PATH=$(LOCAL_PATH)


