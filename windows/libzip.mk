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

LIBNAME = libzip

WARN := -Wno-ignored-attributes -Wno-deprecated-declarations -Wno-nonportable-include-path -Wno-pragma-pack \
	-Wno-microsoft-anon-tag -Wno-ignored-pragma-intrinsic
CFLAGS := $(REPLACEMENTS_INCLUDE) $(CRT_INCLUDE) -I$(PREFIX)/include --target=$(TARGET) $(WARN) -D_MT
LDFLAGS := $(CRT_LIB) -L$(PREFIX)/lib -fuse-ld=lld --target=$(TARGET) -Xlinker -nodefaultlibs -lkernel32 -loldnames

PRE_CONFIGURE := CC=$(CC) CXX=$(CXX) \
	CFLAGS="$(OPT)" \
	CPP="$(CC) -E" \
	CPPFLAGS="$(CFLAGS)" \
	LDFLAGS="$(LDFLAGS)" \
	PKG_CONFIG_PATH="$(PREFIX)/lib/pkgconfig" \
	LIBS="-lz"

CONFIGURE := \
	-DCMAKE_C_COMPILER_TARGET="$(TARGET)" \
	-DCMAKE_C_FLAGS_INIT="$(CFLAGS)" \
	-DCMAKE_EXE_LINKER_FLAGS_INIT="$(LDFLAGS)" \
	-DCMAKE_SHARED_LINKER_FLAGS_INIT="$(LDFLAGS)" \
	-DCMAKE_RC_COMPILER=$(CC) \
	-DCMAKE_SYSTEM_NAME=Windows \
	-DCMAKE_POLICY_DEFAULT_CMP0091=NEW \
	-DCMAKE_VERBOSE_MAKEFILE:BOOL=ON \
	-DBUILD_SHARED_LIBS=OFF \
	-DENABLE_BZIP2=OFF \
	-DENABLE_LZMA=OFF \
	-DENABLE_ZSTD=OFF \
	-DBUILD_TOOLS=OFF \
	-DBUILD_REGRESS=OFF \
	-DBUILD_EXAMPLES=OFF \
	-DBUILD_DOC=OFF \
	-DCMAKE_INSTALL_PREFIX=$(PREFIX) \
	-DZLIB_LIBRARY="-lz" \
	-DENABLE_MBEDTLS=OFF \
	-DENABLE_GNUTLS=OFF \
	-DENABLE_COMMONCRYPTO=OFF \
	-DENABLE_OPENSSL=OFF \
	-DENABLE_WINDOWS_CRYPTO=ON

ifdef RELEASE
CFLAGS +=  --dependent-lib=libcmt
LDFLAGS += -llibcmt -llibucrt -lvcruntime
CONFIGURE += -DCMAKE_MSVC_RUNTIME_LIBRARY=MultiThreaded -DCMAKE_BUILD_TYPE=Release
else
CFLAGS +=  --dependent-lib=libcmtd  -g -Xclang -gcodeview -D_DEBUG
LDFLAGS += -llibcmtd -llibucrtd -lvcruntimed
CONFIGURE += -DCMAKE_MSVC_RUNTIME_LIBRARY=MultiThreadedDebug -DCMAKE_BUILD_TYPE=Debug
endif

all:
	@mkdir -p $(LIBNAME)
	cd $(LIBNAME); \
		$(PRE_CONFIGURE) cmake $(LIB_SRC_DIR)/$(LIBNAME) $(CONFIGURE); \
		make; make install
	rm -rf $(LIBNAME)
