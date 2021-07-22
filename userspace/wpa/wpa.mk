$(BUILD)/wpa_supplicant/done/install: $(BUILD)/wpa_supplicant/done/build
	$(WITH_CROSS_PATH) $(MAKE) -C $(BUILD)/wpa_supplicant/build/wpa_supplicant $(WITH_CROSS_CC) PKG_CONFIG=/bin/false DESTDIR=$(BUILD)/pearl/install install
	@touch $@

$(BUILD)/wpa_supplicant/done/build: $(BUILD)/wpa_supplicant/done/configure
	$(WITH_CROSS_PATH) $(MAKE) -C $(BUILD)/wpa_supplicant/build/wpa_supplicant $(WITH_CROSS_CC) EXTRA_CFLAGS="$(CROSS_CFLAGS) -I$(BUILD)/pearl/install/include/libnl3" PKG_CONFIG=/bin/false
	@touch $@

$(BUILD)/wpa_supplicant/done/configure: userspace/wpa/wpa_supplicant.config $(BUILD)/wpa_supplicant/done/copy $(BUILD)/libnl/done/install $(BUILD)/openssl/done/install
	cp $< $(BUILD)/wpa_supplicant/build/wpa_supplicant/.config
	$(WITH_CROSS_PATH) $(MAKE) -C $(BUILD)/wpa_supplicant/build/wpa_supplicant $(WITH_CROSS_CC) EXTRA_CFLAGS="$(CROSS_CFLAGS) -I$(BUILD)/pearl/install/include/libnl3" PKG_CONFIG=/bin/false defconfig
	@touch $@

$(BUILD)/wpa_supplicant/done/copy: $(BUILD)/wpa_supplicant/done/checkout | $(BUILD)/wpa_supplicant/build/
	$(CP) -aus $(PWD)/userspace/wpa/wpa/* $(BUILD)/wpa_supplicant/build/
	@touch $@

$(BUILD)/wpa_supplicant/done/checkout: | $(BUILD)/wpa_supplicant/done/
	$(MAKE) userspace/wpa/wpa{checkout}
	@touch $@

userspace-modules += wpa_supplicant
