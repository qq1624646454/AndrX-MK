
DEBUG_MENU := 3 

tgtlist := test1 test2


.PHONY: all test1_prerequisites test2_prerequisites 
all: $(tgtlist) 


define recipe-for-target-colon-prerequisites
$(1) : $(2)
	$(3)
endef

#define transform-o-to-shared-library
#endef



ifeq ($(strip $(DEBUG_MENU)), 1)
$(info ###########################                                                   )
$(info ###########################  TEST-1  directly recipe for multiple targets     )
$(info ###########################                                                   )

cvalue=1

test1_prerequisites:
	@echo [$@]

test2_prerequisites:
	@echo [$@]

test1: test1_prerequisites
	@echo [$@] $$\(cvalue\)=$(cvalue)
	@echo [$@] $$\(value cvalue\)=$(value cvalue)

cvalue=2
test2: test2_prerequisites
	@echo [$@] $$\(cvalue\)=$(cvalue)
	@echo [$@] $$\(value cvalue\)=$(value cvalue)
endif


ifeq ($(strip $(DEBUG_MENU)), 2)
$(info ###########################                                                   )
$(info ###########################  TEST-2  extension over makefile function         )
$(info ###########################                                                   )


$(eval $(call recipe-for-target-colon-prerequisites, test1_prerequisites, , \
                  @echo [$$@] ))
$(eval $(call recipe-for-target-colon-prerequisites, test2_prerequisites, , \
                  @echo [$$@] ))

cvalue := 1
##### JLLim: Print 2
#$(eval $(call recipe-for-target-colon-prerequisites, test1, , \
#                  @echo [$$@] $$$$\(cvalue\)=$$(cvalue); \
#                   echo [$$@] $$$$\(value cvalue\)=$$(value cvalue)))
##### JLLim: Print 1 
#$(eval $(call recipe-for-target-colon-prerequisites, test1, , @echo $(cvalue)))
$(eval $(call recipe-for-target-colon-prerequisites, test1, test1_prerequisites, \
                  @echo [$$@] $$$$\(cvalue\)=$(cvalue); \
                   echo [$$@] $$$$\(value cvalue\)=$(value cvalue)))

cvalue := 2
#$(eval $(call recipe-for-target-colon-prerequisites, test2, , @echo $(cvalue)))
$(eval $(call recipe-for-target-colon-prerequisites, test2, test2_prerequisites, \
                  @echo [$$@] $$$$\(cvalue\)=$(cvalue); \
                   echo [$$@] $$$$\(value cvalue\)=$(value cvalue)))
endif


###########################
###########################  TEST-3 foreach extension over makefile function
###########################
ifeq ($(strip $(DEBUG_MENU)), 3)
$(info ###########################                                                   )
$(info ###########################  TEST-3  foreach extension over makefile function )
$(info ###########################                                                   )

prelist := test1_prerequisites test2_prerequisites

$(info $(words $(prelist)))    #it will calculate the count of list
#$(info $(word 0, $(prelist))) #it will cause error
#$(info $(word 1, $(prelist)))  #it is test1_prerequisites


$(foreach _ptgt, $(prelist), \
    $(eval $(call recipe-for-target-colon-prerequisites, $(_ptgt), , @echo [$$@] )) \
)

idx := 1
cvalue := 1
$(foreach _tgt, $(tgtlist), \
     $(eval $(call recipe-for-target-colon-prerequisites, $(_tgt), $(word $(idx), $(prelist)), \
                      @echo [$$@] $$$$\(cvalue\)=$(cvalue); \
                       echo [$$@] $$$$\(value cvalue\)=$(value cvalue) \
             ) \
    ) \
    $(eval cvalue := $(shell expr $(cvalue) + 1 )) \
    $(eval idx := $(shell expr $(idx) + 1 )) \
)

comma := ,
LDFLAGS := -Wl,-O1 -Wl,--hash-style=gnu -Wl,--as-needed

$(info $(subst $(comma),___,$(LDFLAGS)))

endif



