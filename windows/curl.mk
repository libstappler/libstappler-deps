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

VARIANT ?= mbedtls

LIBNAME = curl

WARN := -Wno-ignored-attributes -Wno-deprecated-declarations -Wno-nonportable-include-path -Wno-pragma-pack \
	-Wno-microsoft-anon-tag -Wno-ignored-pragma-intrinsic -Wno-unused-parameter -Wno-sign-compare -Wno-unknown-pragmas
CPPFLAGS :=  --target=$(TARGET) $(REPLACEMENTS_INCLUDE) $(CRT_INCLUDE) -I$(PREFIX)/include -D_MT -include time.h
CFLAGS := $(WARN)
LDFLAGS := $(CRT_LIB) -L$(PREFIX)/lib -fuse-ld=lld --target=$(TARGET) -Xlinker -nodefaultlibs
LIBS := -lkernel32 -loldnames -lws2_32

ifdef RELEASE
CFLAGS += -Xclang --dependent-lib=libcmt $(OPT)
LIBS += -llibucrt -llibcmt -llibvcruntime
else
CFLAGS += -Xclang --dependent-lib=libcmtd -g -Xclang -gcodeview -D_DEBUG
LIBS += -llibucrtd -llibcmtd -llibvcruntimed
endif

CONFIGURE := \
	CC=$(CC) CXX=$(CXX) \
	CFLAGS="$(CFLAGS)" \
	CPP="$(CC) -E" \
	CPPFLAGS="$(CPPFLAGS)" \
	LDFLAGS="$(LDFLAGS)" \
	PKG_CONFIG_PATH="$(PREFIX)/lib/pkgconfig" \
	--host=$(ARCH)-windows \
	--includedir=$(PREFIX)/include \
	--libdir=$(PREFIX)/lib \
	--bindir=$(PREFIX)/bin \
	--datarootdir=$(MAKE_ROOT)$(LIBNAME)/share \
	--prefix=$(PREFIX) \
	--enable-optimize \
	--enable-symbol-hiding \
	--enable-http \
	--enable-ftp \
	--enable-file \
	--enable-smtp \
	--enable-proxy \
	--enable-ipv6 \
	--enable-unix-sockets \
	--enable-cookies \
	--enable-shared=no \
	--enable-static=yes \
	--enable-websockets \
	--disable-warnings \
	--disable-curldebug \
	--disable-debug \
	--disable-dependency-tracking \
	--disable-ldap \
	--disable-ldaps \
	--disable-rtsp \
	--disable-dict \
	--disable-telnet \
	--disable-tftp \
	--disable-pop3 \
	--disable-imap \
	--disable-smb \
	--disable-gopher \
	--disable-manual \
	--disable-ntlm \
	--disable-versioned-symbols \
	--disable-verbose  \
	--disable-sspi \
	--disable-ntlm-wb  \
	--with-zlib \
	--with-brotli \
	--without-ca-path \
	--without-libssh2 \
	--without-librtmp \
	--without-nghttp3 \
	--without-ngtcp2 \
	--without-schannel \
	--without-libpsl \
	--with-winidn \
	--with-ca-bundle=$(realpath ../replacements/curl/cacert.pem) \
	--without-ca-path

ifeq ($(VARIANT),mbedtls)
CONFIGURE += \
	--with-mbedtls \
	--without-openssl \
	--without-gnutls \
	LIBS="$(LIBS) -ladvapi32 -lbcrypt"
endif

ifeq ($(VARIANT),openssl)
CONFIGURE += \
	--without-mbedtls \
	--with-openssl \
	--without-gnutls \
	LIBS="-ladvapi32 -luser32 -lcrypt32"
endif

all:
	@mkdir -p $(LIBNAME)
	cd $(LIBNAME); \
		PATH=$(REPLACEMENTS_BIN):$(PATH) $(LIB_SRC_DIR)/$(LIBNAME)/configure $(CONFIGURE); \
		PATH=$(REPLACEMENTS_BIN):$(PATH) XWIN_DIR=$(XWIN_DIR) make -j8; \
		PATH=$(REPLACEMENTS_BIN):$(PATH) make install
	mv -f $(PREFIX)/lib/libcurl.a $(PREFIX)/lib/curl-$(VARIANT).lib
	rm -f $(PREFIX)/lib/libcurl.la
	rm -rf $(LIBNAME)

.PHONY: all
