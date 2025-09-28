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

include configure.mk

CONFIGURE := mingw-xwin-clang-x64 \
	--prefix=$(PREFIX) \
	CC=$(CC) \
	CXX=$(CXX) \
	AR=$(AR) \
	RC=windres \
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
	rm -rf $(LIBNAME)
	cp -f replacements/openssl/49-xwin-clang.conf $(LIB_SRC_DIR)/$(LIBNAME)/Configurations
	@mkdir -p $(LIBNAME)
	cd $(LIBNAME); \
		export CFLAGS="$(CPPFLAGS) $(CFLAGS)"; \
		export LDFLAGS="$(LDFLAGS)"; \
		export PATH="$(REPLACEMENTS_BIN):$(PATH)"; \
		export XWIN_DIR="$(XWIN_DIR)"; \
		$(LIB_SRC_DIR)/$(LIBNAME)/Configure $(CONFIGURE); \
		make -j8 build_libs; \
		cp libcrypto.a $(PREFIX)/lib/crypto.lib; \
		cp libssl.a $(PREFIX)/lib/ssl.lib; \
		make -j8; \
		make install_sw
	mv -f $(PREFIX)/lib/libcrypto.a $(PREFIX)/lib/crypto.lib
	mv -f $(PREFIX)/lib/libssl.a $(PREFIX)/lib/ssl.lib
	rm -f $(PREFIX)/lib/libssl.la $(PREFIX)/lib/libcrypto.la
	rm -rf $(LIBNAME)

.PHONY: all
