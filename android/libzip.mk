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

PRE_CONFIGURE := CC=$(CC) CXX=$(CXX) \
	CFLAGS="$(OPT) -fPIC" \
	CPP="$(CC) -E" \
	CPPFLAGS="-I$(PREFIX)/include" \
	LDFLAGS="-L$(PREFIX)/lib" \
	PKG_CONFIG_PATH="$(PREFIX)/lib/pkgconfig" \
	LIBS="-lz -lm"

CONFIGURE := \
	-DBUILD_SHARED_LIBS=OFF \
	-DMbedTLS_LIBRARY=$(PREFIX)/lib/libmbedtls.a -DMbedTLS_INCLUDE_DIR=$(PREFIX)/include \
	-DENABLE_GNUTLS=OFF \
	-DENABLE_COMMONCRYPTO=OFF \
	-DENABLE_OPENSSL=OFF \
	-DENABLE_BZIP2=OFF \
	-DENABLE_LZMA=OFF \
	-DENABLE_ZSTD=OFF \
	-DBUILD_TOOLS=OFF \
	-DBUILD_REGRESS=OFF \
	-DBUILD_EXAMPLES=OFF \
	-DBUILD_DOC=OFF \
	-DCMAKE_INSTALL_PREFIX=$(PREFIX) \
	-DZLIB_LIBRARY="-lz"

all:
	@mkdir -p $(LIBNAME)
	cd $(LIBNAME); \
		$(PRE_CONFIGURE) cmake $(LIB_SRC_DIR)/$(LIBNAME) $(CONFIGURE); \
		make; make install
	rm -rf $(LIBNAME)
