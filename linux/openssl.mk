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

DEBUG ?= 0

LIBNAME = openssl

CONFIGURE := \
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

ifeq ($(ARCH),e2k)
CONFIGURE += no-asm -mno-sse4.2
endif

ifeq ($(DEBUG),1)

CONFIGURE += -d

all:
	rm -rf $(LIBNAME)
	cp -r $(LIB_SRC_DIR)/$(LIBNAME) $(LIBNAME)
	cd $(LIBNAME); \
		./Configure $(CONFIGURE); \
		make -j8; \
		make install_sw
	mv -f $(PREFIX)/lib64/libssl.a $(PREFIX)/lib/libssl.a 
	mv -f $(PREFIX)/lib64/libcrypto.a $(PREFIX)/lib/libcrypto.a 
	mv -f $(PREFIX)/lib64/pkgconfig/libssl.pc $(PREFIX)/lib/pkgconfig/libssl.pc
	mv -f $(PREFIX)/lib64/pkgconfig/libcrypto.pc $(PREFIX)/lib/pkgconfig/libcrypto.pc
	rm -rf $(PREFIX)/lib64 $(PREFIX)/bin/c_rehash
	sed -i -e 's/ -lssl/ -lssl -lpthread/g' $(PREFIX)/lib/pkgconfig/libssl.pc

else

all:
	@mkdir -p $(LIBNAME)
	cd $(LIBNAME); \
		$(LIB_SRC_DIR)/$(LIBNAME)/Configure $(CONFIGURE); \
		make -j8; \
		make install_sw
	rm -rf $(LIBNAME)
	mv -f $(PREFIX)/lib64/libssl.a $(PREFIX)/lib/libssl.a 
	mv -f $(PREFIX)/lib64/libcrypto.a $(PREFIX)/lib/libcrypto.a 
	mv -f $(PREFIX)/lib64/pkgconfig/libssl.pc $(PREFIX)/lib/pkgconfig/libssl.pc
	mv -f $(PREFIX)/lib64/pkgconfig/libcrypto.pc $(PREFIX)/lib/pkgconfig/libcrypto.pc
	rm -rf $(PREFIX)/lib64 $(PREFIX)/bin/c_rehash
	sed -i -e 's/ -lssl/ -lssl -lpthread/g' $(PREFIX)/lib/pkgconfig/libssl.pc

endif

.PHONY: all
