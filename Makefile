CROSS_COMPILE ?= aarch64-linux-gnu-
MKDIR ?= mkdir -p
CP ?= cp
CAT ?= cat
TAR ?= tar
PWD = $(shell pwd)
SUDO ?= $(and $(filter pip,$(shell whoami)),sudo)

# INCLUDE_DEBOOTSTRAP = t
INCLUDE_MODULES = t

all: build/pearl.macho

%/:
	$(MKDIR) $@

clean:
	rm -rf build

# Alias target
build/pearl.macho: build/stages/stage1/stage1.image.macho | build/
	$(CP) $< $@

include g/stampserver/stampserver.mk

include dtc/dtc.mk

include linux/linux.mk

include deb/deb.mk

include snippet/snippet.mk

include macho-tools/macho-tools.mk

include busybox/busybox.mk

include kexec/kexec.mk

include dt/dt.mk

include github/github.mk

include m1n1/m1n1.mk

include stages/stages.mk

include packs/packs.mk

.SECONDARY:
.PHONY: %}
