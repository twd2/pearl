$(BUILD)/lvm2/done/install: $(BUILD)/lvm2/done/build
	$(WITH_CROSS_PATH) $(MAKE) -C $(BUILD)/lvm2/build DESTDIR=$(BUILD)/pearl/install/ install
	@touch $@

$(BUILD)/lvm2/done/build: $(BUILD)/lvm2/done/configure
	$(WITH_CROSS_PATH) $(MAKE) -C $(BUILD)/lvm2/build
	@touch $@

$(BUILD)/lvm2/done/configure: $(BUILD)/lvm2/done/copy $(call deps,libaio libblkid glibc gcc)
	(cd $(BUILD)/lvm2/build; $(WITH_CROSS_PATH) ./configure --host=aarch64-linux-gnu --target=aarch64-linux-gnu --prefix=/ CFLAGS="$(CROSS_CFLAGS) -I." LDFLAGS="-L$(BUILD)/pearl/install/lib")
	@touch $@

$(BUILD)/lvm2/done/copy: $(BUILD)/lvm2/done/checkout | $(BUILD)/lvm2/build/ $(BUILD)/lvm2/done/
	$(CP) -aus $(PWD)/userspace/lvm2/lvm2/* $(BUILD)/lvm2/build
	@touch $@

$(BUILD)/lvm2/done/checkout: | $(BUILD)/lvm2/done/
	$(MAKE) userspace/lvm2/lvm2{checkout}
	@touch $@

userspace-modules += lvm2
