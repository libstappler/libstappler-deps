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

CONFIGURE_AUTOCONF := \
	CC=$(CC) \
	CPP="$(CC) -E" \
	CXX=$(CXX) \
	CFLAGS="$(OPT) -target $(TARGET) -mmacosx-version-min=$(OS_VERSION_TARGET)" \
	CXXFLAGS="$(OPT)" \
	CPPFLAGS="-I$(PREFIX)/include" \
	LDFLAGS="-L$(PREFIX)/lib -mmacosx-version-min=$(OS_VERSION_TARGET)" \
	PKG_CONFIG_PATH="$(PREFIX)/lib/pkgconfig" \
	LIBS="-lz -lm" \
	--includedir=$(PREFIX)/include \
	--libdir=$(PREFIX)/lib \
	--bindir=$(MAKE_ROOT)$(LIBNAME)/bin \
	--datarootdir=$(MAKE_ROOT)$(LIBNAME)/share \
	--prefix=$(PREFIX) \
	--enable-shared=no \
	--enable-static=yes

CONFIGURE_CMAKE := \
	-DCMAKE_C_FLAGS_INIT="-I$(PREFIX)/include $(OPT)" \
	-DCMAKE_EXE_LINKER_FLAGS_INIT="-L$(PREFIX)/lib" \
	-DCMAKE_SHARED_LINKER_FLAGS_INIT="-L$(PREFIX)/lib" \
	-DCMAKE_INSTALL_PREFIX=$(PREFIX) \
	-DCMAKE_PREFIX_PATH=$(PREFIX) \
	-DCMAKE_VERBOSE_MAKEFILE:BOOL=ON \
	-DBUILD_SHARED_LIBS=OFF \
	-DCMAKE_OSX_DEPLOYMENT_TARGET=$(OS_VERSION_TARGET) \
	-DCMAKE_OSX_ARCHITECTURES=$(ARCH)

ifeq ($(DEBUG),1)
CONFIGURE_CMAKE += -DCMAKE_BUILD_TYPE=Debug
else
CONFIGURE_CMAKE += -DCMAKE_BUILD_TYPE=Release
endif

AR := ar
