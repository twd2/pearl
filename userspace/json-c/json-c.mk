$(BUILD)/json-c/done/install: $(BUILD)/json-c/done/build
	$(WITH_CROSS_PATH) $(MAKE) -C $(BUILD)/json-c/build DESTDIR="$(BUILD)/pearl/install" install
	@touch $@

$(BUILD)/json-c/done/build: $(BUILD)/json-c/done/configure
	$(WITH_CROSS_PATH) $(MAKE) -C $(BUILD)/json-c/build
	@touch $@

$(BUILD)/json-c/done/configure: $(BUILD)/json-c/done/copy $(call deps,glibc gcc)
	(cd $(BUILD)/json-c/build; cmake -DCMAKE_LINKER=$(BUILD)/pearl/toolchain/bin/aarch64-linux-gnu-ld -DCMAKE_SHARED_LINKER=$(BUILD)/pearl/toolchain/bin/aarch64-linux-gnu-ld -DCMAKE_C_COMPILER=$(BUILD)/pearl/toolchain/bin/aarch64-linux-gnu-gcc -DCMAKE_C_FLAGS="-I$(BUILD)/pearl/install/include -L$(BUILD)/pearl/install/lib --sysroot=$(BUILD)/pearl/install" .)
	@touch $@

$(BUILD)/json-c/done/copy: $(BUILD)/json-c/done/checkout | $(BUILD)/json-c/done/ $(BUILD)/json-c/build/
	$(CP) -au $(PWD)/userspace/json-c/json-c/* $(BUILD)/json-c/build/
	@touch $@

$(BUILD)/json-c/done/checkout: | $(BUILD)/json-c/done/
	$(MAKE) userspace/json-c/json-c{checkout}
	@touch $@

userspace-modules += json-c
