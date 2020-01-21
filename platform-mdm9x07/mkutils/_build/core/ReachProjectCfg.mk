#==============================================================================
# Copyright (c) 2012 Reach Tech(Xiamen) Co.,LTD .  All Rights Reserved
#==============================================================================

KERNEL_REACH_ARGS :=

ifneq ( ,$(strip $(REACHPROJECT)))
COMMON_GLOBAL_CFLAGS := $(COMMON_GLOBAL_CFLAGS) -D$(REACHPROJECT)_SPECIFIC
KERNEL_REACH_ARGS := $(KERNEL_REACH_ARGS) REACHPROJECT=$(REACHPROJECT)
endif

ifeq ($(strip $(USES_ODM_UPDATE)),yes)
COMMON_GLOBAL_CFLAGS := $(COMMON_GLOBAL_CFLAGS) -DUSES_ODM_UPDATE
KERNEL_REACH_ARGS := $(KERNEL_REACH_ARGS) USES_ODM_UPDATE=yes
endif

ifeq ($(strip $(GC2235_ROTATE_180_ENABLE)),yes)
COMMON_GLOBAL_CFLAGS := $(COMMON_GLOBAL_CFLAGS) -DGC2235_ROTATE_180_ENABLE
KERNEL_REACH_ARGS := $(KERNEL_REACH_ARGS) GC2235_ROTATE_180_ENABLE=yes
endif

