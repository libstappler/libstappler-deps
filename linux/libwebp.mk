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

LIBNAME = libwebp

CONFIGURE := \
	CC=$(CC) CXX=$(CXX) \
	CFLAGS="$(OPT) -fPIC $(ARCH_CFLAGS)" \
	CPP="$(CC) -E" \
	CPPFLAGS="-I$(PREFIX)/include $(ARCH_CFLAGS)" \
	LDFLAGS="-L$(PREFIX)/lib" \
	PKG_CONFIG_PATH="$(PREFIX)/lib/pkgconfig" \
	LIBS="-lz -lm" \
	LIBPNG_CONFIG="$(PREFIX)/bin/libpng16-config" \
	--includedir=$(PREFIX)/include \
	--libdir=$(PREFIX)/lib \
	--bindir=$(MAKE_ROOT)$(LIBNAME)/bin \
	--datarootdir=$(MAKE_ROOT)$(LIBNAME)/share \
	--prefix=$(PREFIX) \
	--enable-shared=no \
	--enable-static=yes \
	--disable-gl \
	--disable-sdl \
	--disable-tiff \
	--disable-wic \
	--disable-dependency-tracking

ifeq ($(ARCH),e2k)
CONFIGURE += --host=e2k-linux
endif

ifeq ($(ARCH),aarch64)
CONFIGURE += --host=aarch64-linux-gnu
endif

all:
	@mkdir -p $(LIBNAME)
	cd $(LIBNAME); \
		$(LIB_SRC_DIR)/$(LIBNAME)/configure $(CONFIGURE); \
		make -j8; \
		make install
	rm -rf $(LIBNAME)

.PHONY: all
