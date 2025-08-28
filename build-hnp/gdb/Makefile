include ../utils/Makefrag

SOURCE_URL = $(GNU_MIRROR)/gnu/gdb/gdb-16.3.tar.xz
SOURCE_FILE = gdb-16.3.tar.xz
SOURCE_DIR = gdb-16.3
CONFIG_ARGS = --prefix=$(PREFIX) --with-lzma --disable-sim --disable-static --enable-shared --with-system-readline --host $(OHOS_ARCH)-unknown-linux-musl --disable-nls
ifeq ($(OHOS_ARCH),x86_64)
PATCH_SOURCE = cd temp/$(SOURCE_DIR) \
	&& cat ../../linux-btrace.diff | patch -Np1 \
	&& cat ../../linux-amd64-ipa.patch | patch -Np1 
endif

$(eval $(call define_autotools_package))
