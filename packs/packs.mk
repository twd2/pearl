include packs/pearl/pearl.mk

include packs/debootstrap/debootstrap.mk

define perpack
build/packs/$(pack)/bin/kexec: build/kexec/kexec
	$$(MKDIR) $$(dir $$@)
	$$(CP) -a $$< $$@

build/packs/$(pack)/bin/busybox: build/busybox/busybox
	$$(MKDIR) $$(dir $$@)
	$$(CP) -a $$< $$@

build/packs/$(pack)/common.tar: $(common-$(pack):%=build/packs/$(pack)/common/%)
	$$(MKDIR) $$(dir $$@)
	(cd build/packs/$(pack); tar c $$(^:build/packs/$(pack)/%=%)) > $$@

build/packs/$(pack)/stages.tar: $(stages-$(pack):%=build/packs/$(pack)/stages/%)
	$$(MKDIR) $$(dir $$@)
	(cd build/packs/$(pack); tar c $$(^:build/packs/$(pack)/%=%)) > $$@

build/packs/$(pack).cpiospec: packs/$(pack)/$(pack).cpiospec
	$$(MKDIR) $$(dir $$@)
	(cat $$<; $$(foreach file,$$(patsubst build/packs/$(pack)/%,/%,$$(wordlist 2,$$(words $$^),$$^)),echo dir $$(dir $(patsubst %/,%,$$(file))) 755 0 0; echo file $$(file) $$(PWD)/build/packs/$(pack)/$$(file) 755 0 0;)) | sort | uniq > $$@

build/packs/$(pack)/%: packs/$(pack)/%
	$$(MKDIR) $$(dir $$@)
	$$(CP) $$< $$@

build/packs/$(pack)/bin/%: build/dt/bin/%
	$$(MKDIR) $$(dir $$@)
	$$(CP) $$< $$@

build/packs/$(pack)/init: packs/$(pack)/bin/init
	$$(MKDIR) $$(dir $$@)
	$$(CP) $$< $$@

build/packs/$(pack)/boot/stage2.image: build/stages/stage2/stage2.image
	$$(MKDIR) $$(dir $$@)
	$$(CP) $$< $$@

build/packs/$(pack)/boot/stage2.dtb: build/stages/stage2/stage2.dtb
	$$(MKDIR) $$(dir $$@)
	$$(CP) $$< $$@

build/packs/$(pack)/boot/linux.image: build/stages/linux/linux.image
	$$(MKDIR) $$(dir $$@)
	$$(CP) $$< $$@

build/packs/$(pack)/boot/linux.dtb: build/stages/linux/linux.dtb
	$$(MKDIR) $$(dir $$@)
	$$(CP) $$< $$@

build/packs/$(pack)/deb.tar: build/deb.tar
	$$(MKDIR) $$(dir $$@)
	$$(CP) $$< $$@

build/packs/$(pack)/boot/m1n1.macho.image: build/m1n1/m1n1.macho.image
	$$(MKDIR) $$(dir $$@)
	$$(CP) $$< $$@

build/packs/$(pack)/bin/receive-commfile: build/commfile/receive-commfile
	$$(MKDIR) $$(dir $$@)
	$$(CP) $$< $$@

build/packs/$(pack)/modules.tar: build/stages/linux/linux-modules.tar
	$$(MKDIR) $$(dir $$@)
	$$(CP) $$< $$@

build/packs/$(pack).cpiospec: build/packs/$(pack)/bin/adtdump
build/packs/$(pack).cpiospec: build/packs/$(pack)/bin/adtp
build/packs/$(pack).cpiospec: build/packs/$(pack)/bin/busybox
build/packs/$(pack).cpiospec: build/packs/$(pack)/bin/dt
build/packs/$(pack).cpiospec: build/packs/$(pack)/bin/gadget
build/packs/$(pack).cpiospec: build/packs/$(pack)/bin/kexec
build/packs/$(pack).cpiospec: build/packs/$(pack)/bin/linux
build/packs/$(pack).cpiospec: build/packs/$(pack)/bin/receive-commfile
build/packs/$(pack).cpiospec: build/packs/$(pack)/bin/stage1
build/packs/$(pack).cpiospec: build/packs/$(pack)/bin/stage2
build/packs/$(pack).cpiospec: build/packs/$(pack)/boot/linux.dtb
build/packs/$(pack).cpiospec: build/packs/$(pack)/boot/linux.image
build/packs/$(pack).cpiospec: build/packs/$(pack)/boot/stage2.dtb
build/packs/$(pack).cpiospec: build/packs/$(pack)/boot/stage2.image
build/packs/$(pack).cpiospec: build/packs/$(pack)/deb.tar
build/packs/$(pack).cpiospec: build/packs/$(pack)/modules.tar
build/packs/$(pack).cpiospec: build/packs/$(pack)/init

build/packs/$(pack).cpio: build/packs/$(pack).cpiospec build/stages/linux/linux.image
	(cd build/linux/linux; $$(PWD)/submodule/linux/usr/gen_initramfs.sh -o $$(PWD)/$$@ ../../../$$<)

endef

$(foreach pack,$(packs),$(eval $(perpack)))
