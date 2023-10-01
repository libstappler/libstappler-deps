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

LIBNAME = libbacktrace

WARN := -Wno-ignored-attributes -Wno-deprecated-declarations -Wno-nonportable-include-path -Wno-pragma-pack \
	-Wno-microsoft-anon-tag -Wno-ignored-pragma-intrinsic -Wno-unused-parameter
CFLAGS := $(REPLACEMENTS_INCLUDE) $(CRT_INCLUDE) -I$(PREFIX)/include --target=$(TARGET) $(WARN) -D_MT
LDFLAGS := $(CRT_LIB) -L$(PREFIX)/lib -fuse-ld=lld --target=$(TARGET) -Xlinker -nodefaultlibs -lkernel32 -loldnames

ifdef RELEASE
CFLAGS += -Xclang --dependent-lib=libcmt $(OPT)
LDFLAGS += -llibucrt -llibcmt -llibvcruntime
else
CFLAGS += -Xclang --dependent-lib=libcmtd -g -Xclang -gcodeview -D_DEBUG
LDFLAGS += -llibucrtd -llibcmtd -llibvcruntimed
endif

CONFIGURE := \
	CC=$(CC) CXX=$(CXX) \
	CFLAGS="$(OPT)" \
	CPP="$(CC) -E" \
	CPPFLAGS="$(CFLAGS)" \
	LDFLAGS="$(LDFLAGS)" \
	PKG_CONFIG_PATH="$(PREFIX)/lib/pkgconfig" \
	--host=$(ARCH)-windows \
	--includedir=$(PREFIX)/include \
	--libdir=$(PREFIX)/lib \
	--bindir=$(MAKE_ROOT)$(LIBNAME)/bin \
	--datarootdir=$(MAKE_ROOT)$(LIBNAME)/share \
	--prefix=$(PREFIX) \
	--enable-shared=no \
	--enable-static=yes

all:
	@mkdir -p $(LIBNAME)
	cd $(LIBNAME); \
		$(LIB_SRC_DIR)/$(LIBNAME)/configure $(CONFIGURE); \
		make -j8; \
		make install
	rm -rf $(LIBNAME)
	mv -f $(PREFIX)/lib/libbacktrace.a $(PREFIX)/lib/backtrace.lib
	rm -f $(PREFIX)/lib/libbacktrace.la

.PHONY: all
