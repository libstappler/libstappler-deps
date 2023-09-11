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

LIBNAME = openssl

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

CONFIGURE := android-$(ANDROID_ARCH) \
	--prefix=$(PREFIX) \
	CC=$(CC) \
	CXX=$(CXX) \
	no-tests \
	no-shared \
	no-module \
	no-legacy \
	no-srtp \
	no-srp \
	no-dso \
	no-filenames \
	no-autoload-config

all:
	@mkdir -p $(LIBNAME)
	cd $(LIBNAME); \
		export ANDROID_NDK_ROOT=$(NDK); \
		export PATH=$(NDKPATH):$$PATH; \
		$(LIB_SRC_DIR)/$(LIBNAME)/Configure $(CONFIGURE); \
		make -j8; \
		make install_sw
	rm -rf $(LIBNAME)
#	mv -f $(PREFIX)/lib64/libssl.a $(PREFIX)/lib/libssl.a 
#	mv -f $(PREFIX)/lib64/libcrypto.a $(PREFIX)/lib/libcrypto.a 
#	mv -f $(PREFIX)/lib64/pkgconfig/libssl.pc $(PREFIX)/lib/pkgconfig/libssl.pc
#	mv -f $(PREFIX)/lib64/pkgconfig/libcrypto.pc $(PREFIX)/lib/pkgconfig/libcrypto.pc
#	rm -rf $(PREFIX)/lib64 $(PREFIX)/bin/c_rehash
	sed -i -e 's/ -lssl/ -lssl -lpthread/g' $(PREFIX)/lib/pkgconfig/libssl.pc

.PHONY: all
