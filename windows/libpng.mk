# Copyright (c) 2023 Stappler LLC <admin@stappler.dev>
#
# Permission is hereby granted, free of charge, to any person obtaining a copy
# of this software and associated documentation files (the "Software"), to deal
# in the Software without restriction, including without limitation the rights
# to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
# copies of the Software, and to permit persons to whom the Software is
# furnished to do so, subject to the following conditions:
#
# The above copyright notice and this permission notice shall be included in
# all copies or substantial portions of the Software.
#
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
# IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
# FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
# AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
# LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
# OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
# THE SOFTWARE.

.DEFAULT_GOAL := all

LIBNAME = libpng

WARN := -Wno-ignored-attributes -Wno-deprecated-declarations -Wno-nonportable-include-path -Wno-pragma-pack \
	-Wno-microsoft-anon-tag -Wno-ignored-pragma-intrinsic
CFLAGS := $(REPLACEMENTS_INCLUDE) $(CRT_INCLUDE) -I$(PREFIX)/include --target=$(TARGET) $(WARN) -msse2 -D_MT -Xclang
LDFLAGS := $(CRT_LIB) -L$(PREFIX)/lib -fuse-ld=lld --target=$(TARGET) -Xlinker -nodefaultlibs

ifdef RELEASE
CFLAGS +=  --dependent-lib=libcmt $(OPT)
LDFLAGS += -llibcmt -llibucrt -llibvcruntime
else
CFLAGS +=  --dependent-lib=libcmtd  -g -Xclang -gcodeview -D_DEBUG
LDFLAGS += -llibcmtd -llibucrtd -llibvcruntimed
endif

CONFIGURE := \
	CC=$(CC) CXX=$(CXX) \
	CFLAGS="" \
	CPP="$(CC) -E" \
	CPPFLAGS="$(CFLAGS)" \
	LDFLAGS="$(LDFLAGS)" \
	PKG_CONFIG_PATH="$(PREFIX)/lib/pkgconfig" \
	--host=$(ARCH)-windows \
	--includedir=$(PREFIX)/include \
	--libdir=$(PREFIX)/lib \
	--bindir=$(PREFIX)/bin \
	--datarootdir=$(MAKE_ROOT)$(LIBNAME)/share \
	--prefix=$(PREFIX) \
	--enable-shared=no \
	--enable-static=yes \
	--disable-unversioned-links \
	--disable-unversioned-libpng-pc \
	--disable-unversioned-libpng-config \
	--disable-dependency-tracking \
	--with-sysroot=$(PREFIX)

all:
	rm -rf $(LIBNAME)
	@mkdir -p $(LIBNAME)
	cd $(LIBNAME); \
		$(LIB_SRC_DIR)/$(LIBNAME)/configure $(CONFIGURE); \
		make -j8; \
		make install
	rm -rf $(LIBNAME)
	cp -f $(PREFIX)/include/libpng16/* $(PREFIX)/include
	rm -rf $(PREFIX)/include/libpng16
	rm -rf $(PREFIX)/bin/png*
	mv -f $(PREFIX)/lib/libpng16.a $(PREFIX)/lib/png16.lib
	rm -f $(PREFIX)/lib/libpng16.la

.PHONY: all
