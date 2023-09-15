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

LIBNAME = openssl-gost-engine

ifeq ($(ARCH),x86)
ANDROID_ARCH := x86
endif

ifeq ($(ARCH),x86_64)
ANDROID_ARCH := x86_64
endif

ifeq ($(ARCH),arm64-v8a)
ANDROID_ARCH := arm64
endif

ifeq ($(ARCH),armeabi-v7a)
ANDROID_ARCH := arm
endif

PRE_CONFIGURE := CC=$(CC) CXX=$(CXX) \
	CFLAGS="$(OPT) -fPIC" \
	CPP="$(CC) -E" \
	CPPFLAGS="-I$(PREFIX)/include" \
	LDFLAGS="-L$(PREFIX)/lib" \
	PKG_CONFIG_PATH="$(PREFIX)/lib/pkgconfig" \
	OPENSSL_ROOT_DIR=$(PREFIX) \
	LIBS="-lz -lm"

all:
	@mkdir -p $(LIBNAME)
	cd $(LIBNAME); \
		export ANDROID_NDK_ROOT=$(NDK); \
		export PATH=$(NDKPATH):$$PATH; \
		$(PRE_CONFIGURE) cmake -DCMAKE_SYSTEM_NAME=Android -DCMAKE_ANDROID_ARCH=$(ANDROID_ARCH) -DCMAKE_ANDROID_ARCH_ABI=$(ARCH) \
			-DCMAKE_BUILD_TYPE=Release -DOPENSSL_USE_STATIC_LIBS=TRUE -DCMAKE_VERBOSE_MAKEFILE=TRUE \
			-DOPENSSL_ROOT_DIR=$(PREFIX) -DOPENSSL_CRYPTO_LIBRARY=$(PREFIX)/lib/libcrypto.a \
			-DOPENSSL_INCLUDE_DIR=$(PREFIX)/include \
			-DRELAXED_ALIGNMENT=TRUE \
			-DADDCARRY_U64=FALSE \
			$(LIB_SRC_DIR)/$(LIBNAME); \
		make gost_engine_static
	mv -f $(LIBNAME)/libgost.a $(PREFIX)/lib/libgost.a 
	cp -f $(LIB_SRC_DIR)/$(LIBNAME)/gost-engine.h $(PREFIX)/include
	cp -f $(LIB_SRC_DIR)/$(LIBNAME)/e_gost_err.h $(PREFIX)/include
	rm -rf $(LIBNAME)

.PHONY: all
