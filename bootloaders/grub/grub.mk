$(BUILD)/grub.efi: $(BUILD)/grub/done/install
	$(BUILD)/toolchain/bin/grub-mkimage -Oarm64-efi -p / acpi adler32 affs afs afsplitter all_video archelp bfs bitmap bitmap_scale blocklist boot bswap_test btrfs bufio cat cbfs chain cmdline_cat_test cmp cmp_test configfile cpio_be cpio crc64 cryptodisk crypto ctz_test datehook date datetime diskfilter disk div div_test dm_nv echo efifwsetup efi_gop efinet elf eval exfat exfctest ext2 extcmd f2fs fat fdt file font fshelp functional_test gcry_arcfour gcry_blowfish gcry_camellia gcry_cast5 gcry_crc gcry_des gcry_dsa gcry_idea gcry_md4 gcry_md5 gcry_rfc2268 gcry_rijndael gcry_rmd160 gcry_rsa gcry_seed gcry_serpent gcry_sha1 gcry_sha256 gcry_sha512 gcry_tiger gcry_twofish gcry_whirlpool geli gettext gfxmenu gfxterm_background gfxterm_menu gfxterm gptsync gzio halt hashsum hello help hexdump hfs hfspluscomp hfsplus http iso9660 jfs jpeg json keystatus ldm linux loadenv loopback lsacpi lsefimmap lsefi lsefisystab lsmmap ls lssal luks2 luks lvm lzopio macbless macho mdraid09_be mdraid09 mdraid1x memdisk memrw minicmd minix2_be minix2 minix3_be minix3 minix_be minix mmap mpi msdospart mul_test net newc nilfs2 normal ntfscomp ntfs odc offsetio part_acorn part_amiga part_apple part_bsd part_dfly part_dvh part_gpt part_msdos part_plan part_sun part_sunpc parttool password password_pbkdf2 pbkdf2 pbkdf2_test pgp png priority_queue probe procfs progress raid5rec raid6rec read reboot regexp reiserfs romfs scsi search_fs_file search_fs_uuid search_label search serial setjmp setjmp_test sfs shift_test signature_test sleep sleep_test smbios squash4 strtoull_test syslinuxcfg tar terminal terminfo test_blockarg testload test testspeed tftp tga time tpm trig tr true udf ufs1_be ufs1 ufs2 video_colors video_fb videoinfo video videotest_checksum videotest xfs xnu_uuid xnu_uuid_test xzio zfscrypt zfsinfo zfs zstd > $@

$(BUILD)/grub/done/install: $(BUILD)/grub/done/build | $(BUILD)/grub/done/
	$(WITH_CROSS_PATH) $(MAKE) -C $(BUILD)/grub/build install
	@touch $@

$(BUILD)/grub/done/build: $(BUILD)/grub/done/configure
	$(WITH_CROSS_PATH) $(MAKE) -C $(BUILD)/grub/build
	@touch $@

$(BUILD)/grub/done/configure: $(BUILD)/grub/done/copy $(BUILD)/glibc/done/glibc/install | $(BUILD)/grub/build/
	(cd $(BUILD)/grub/build; sh bootstrap)
	(cd $(BUILD)/grub/build; $(WITH_CROSS_PATH) ./configure --host=$(NATIVE_TRIPLE) --build=$(NATIVE_TRIPLE) --target=aarch64-linux-gnu --with-platform=efi --prefix=$(BUILD)/toolchain --disable-werror)
	@touch $@

$(BUILD)/grub/done/copy: $(BUILD)/grub/done/checkout | $(BUILD)/grub/build/
	$(CP) -aus $(PWD)/bootloaders/grub/grub/* $(BUILD)/grub/build/
	@touch $@

$(BUILD)/grub/done/checkout: | $(BUILD)/grub/done/
	$(MAKE) bootloaders/grub/grub{checkout}
	@touch $@
