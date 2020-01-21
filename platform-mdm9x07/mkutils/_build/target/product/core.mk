#
# Copyright (C) 2007 The Android Open Source Project
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#      http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#

# Base configuration for communication-oriented android devices
# (phones, tablets, etc.).  If you want a change to apply to ALL
# devices (including non-phones and non-tablets), modify
# core_minimal.mk instead.

# Added by chengl 2014-07-10: add EngineerMode
# Added by huangzhl 2014-08-28: add GenerateCommand, StressTestBurnIn
PRODUCT_PACKAGES += \
    BasicDreams \
    Browser \
    Contacts \
    EngineerMode \
    StressTestBurnIn \
    GenerateCommand \
    DocumentsUI \
    DownloadProviderUi \
    ExternalStorageProvider \
    KeyChain \
    PicoTts \
    PacProcessor \
    ProxyHandler \
    SharedStorageBackup \
    VpnDialogs

$(call inherit-product, $(SRC_TARGET_DIR)/product/core_base.mk)
# [begin] add GMS packages
ifneq ($(USES_GMS_DISABLED), yes)
$(call inherit-product-if-exists, vendor/reach/google/products/gms.mk)
$(call inherit-product-if-exists, vendor/reach/google/products/gms_$(TARGET_PRODUCT).mk)
endif
# [end]
