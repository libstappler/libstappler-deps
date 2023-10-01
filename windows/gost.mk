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

WARN := -Wno-ignored-attributes -Wno-deprecated-declarations -Wno-nonportable-include-path -Wno-pragma-pack \
	-Wno-microsoft-anon-tag -Wno-ignored-pragma-intrinsic
CFLAGS := $(REPLACEMENTS_INCLUDE) $(CRT_INCLUDE) -I$(PREFIX)/include --target=$(TARGET) $(WARN) -D_MT
LDFLAGS := $(CRT_LIB) -L$(PREFIX)/lib -fuse-ld=lld --target=$(TARGET) -Xlinker -nodefaultlibs -lkernel32 -loldnames

ifdef RELEASE
CFLAGS += -Xclang --dependent-lib=libcmt $(OPT)
LDFLAGS += -llibucrt -llibcmt -llibvcruntime
else
CFLAGS += -Xclang --dependent-lib=libcmtd -g -Xclang -gcodeview -D_DEBUG
LDFLAGS += -llibucrtd -llibcmtd -llibvcruntimed
endif

PRE_CONFIGURE := CC=$(CC) CXX=$(CXX) \
	CFLAGS="$(OPT)" \
	CPP="$(CC) -E" \
	CPPFLAGS="$(CFLAGS)" \
	LDFLAGS="$(LDFLAGS)" \
	PKG_CONFIG_PATH="$(PREFIX)/lib/pkgconfig" \
	OPENSSL_ROOT_DIR=$(PREFIX) \
	LIBS="-lz -lm"

all:
	rm -rf $(LIBNAME)
	@mkdir -p $(LIBNAME)
	cd $(LIBNAME); \
		export ANDROID_NDK_ROOT=$(NDK); \
		export PATH=$(NDKPATH):$$PATH; \
		$(PRE_CONFIGURE) cmake \
			-DVERBOSE=TRUE \
			-DCMAKE_C_COMPILER_TARGET="$(TARGET)" \
			-DCMAKE_C_FLAGS_INIT="$(CFLAGS)" \
			-DCMAKE_EXE_LINKER_FLAGS_INIT="$(LDFLAGS)" \
			-DCMAKE_SHARED_LINKER_FLAGS_INIT="$(LDFLAGS)" \
			-DCMAKE_RC_COMPILER=$(CC) \
			-DCMAKE_SYSTEM_NAME=Windows \
			-DCMAKE_MSVC_RUNTIME_LIBRARY=MultiThreaded \
			-DCMAKE_BUILD_TYPE=Release \
			-DOPENSSL_USE_STATIC_LIBS=TRUE \
			-DCMAKE_VERBOSE_MAKEFILE=TRUE \
			-DOPENSSL_ROOT_DIR=$(PREFIX) \
			-DOPENSSL_CRYPTO_LIBRARY=$(PREFIX)/lib/crypto.lib \
			-DOPENSSL_INCLUDE_DIR=$(PREFIX)/include \
			-DRELAXED_ALIGNMENT=TRUE \
			-DADDCARRY_U64=FALSE \
			$(LIB_SRC_DIR)/$(LIBNAME); \
		make gost_engine_static
	mv -f $(LIBNAME)/gost.lib $(PREFIX)/lib/gost.lib
	cp -f $(LIB_SRC_DIR)/$(LIBNAME)/gost-engine.h $(PREFIX)/include
	cp -f $(LIB_SRC_DIR)/$(LIBNAME)/e_gost_err.h $(PREFIX)/include
	rm -rf $(LIBNAME)

.PHONY: all
