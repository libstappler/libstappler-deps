# Copyright (c) 2024 Stappler LLC <admin@stappler.dev>
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

DEBUG ?= 0

WARN := -Wno-ignored-attributes -Wno-deprecated-declarations -Wno-nonportable-include-path -Wno-pragma-pack \
	-Wno-ignored-pragma-intrinsic -Wno-microsoft-anon-tag -Wno-unknown-pragmas -Wno-extra-semi-stmt \
	-Wno-unused-parameter -Wno-strict-prototypes -Wno-cast-qual -Wno-unused-local-typedef
CPPFLAGS := --target=$(TARGET) $(REPLACEMENTS_INCLUDE) $(CRT_INCLUDE) -I$(PREFIX)/include -D_MT
CFLAGS := $(OPT) $(LIB_CFLAGS) $(WARN) -msse2 -maes -mpclmul $(LIB_CFLAGS)
CXXFLAGS := $(OPT) $(WARN) $(LIB_CFLAGS)
LDFLAGS := $(addprefix -L,$(CRT_LIB)) -L$(PREFIX)/lib -fuse-ld=$(LD) --target=$(TARGET) -nostartfiles -nostdlib
LIBS := -lkernel32 -loldnames $(LIB_LIBS)

ifdef RELEASE
CFLAGS += -Xclang --dependent-lib=libcmt $(OPT)
LIBS += -llibucrt -llibcmt -llibvcruntime
else
CFLAGS += -Xclang --dependent-lib=libcmtd -g -Xclang -gcodeview -D_DEBUG
LIBS += -llibucrtd -llibcmtd -llibvcruntimed
endif

CONFIGURE_AUTOCONF := \
	LD=$(LD) \
	CC=$(CC) \
	CPP="$(CC) -E --target=$(TARGET)" \
	CXX=$(CXX) \
	AR=$(AR) \
	CFLAGS="$(CFLAGS)" \
	CXXFLAGS="$(CXXFLAGS)" \
	CPPFLAGS="$(CPPFLAGS)" \
	LDFLAGS="$(LDFLAGS)" \
	LIBS="$(LIBS)" \
	PKG_CONFIG_PATH="$(PREFIX)/lib/pkgconfig" \
	--host=$(ARCH)-windows \
	--includedir=$(PREFIX)/include \
	--libdir=$(PREFIX)/lib \
	--bindir=$(PREFIX)/bin \
	--datarootdir=$(MAKE_ROOT)$(LIBNAME)/share \
	--prefix=$(PREFIX) \
	--enable-shared=no \
	--enable-static=yes \

CONFIGURE_CMAKE := \
	-G "Unix Makefiles" \
	-DCMAKE_SYSTEM_NAME=Windows \
	-DCMAKE_C_COMPILER=$(CC) \
	-DCMAKE_C_COMPILER_TARGET="$(TARGET)" \
	-DCMAKE_C_FLAGS_INIT="$(CPPFLAGS) $(CFLAGS)" \
	-DCMAKE_CXX_COMPILER=$(CXX) \
	-DCMAKE_CXX_COMPILER_TARGET="$(TARGET)" \
	-DCMAKE_CXX_FLAGS_INIT="$(CPPFLAGS) $(CXXFLAGS)" \
	-DCMAKE_RC_COMPILER=llvm-rc \
	-DCMAKE_EXE_LINKER_FLAGS_INIT="$(LDFLAGS) $(LIBS)" \
	-DCMAKE_SHARED_LINKER_FLAGS_INIT="$(LDFLAGS) $(LIBS)" \
	-DCMAKE_INSTALL_PREFIX=$(PREFIX) \
	-DCMAKE_PREFIX_PATH=$(PREFIX) \
	-DCMAKE_VERBOSE_MAKEFILE:BOOL=ON \
	-DBUILD_SHARED_LIBS:BOOL=OFF \
	-DCMAKE_POLICY_DEFAULT_CMP0091=NEW

ifdef RELEASE
CONFIGURE_CMAKE += -DCMAKE_MSVC_RUNTIME_LIBRARY=MultiThreaded -DCMAKE_BUILD_TYPE=Release
else
CONFIGURE_CMAKE += -DCMAKE_MSVC_RUNTIME_LIBRARY=MultiThreadedDebug -DCMAKE_BUILD_TYPE=Debug
endif
