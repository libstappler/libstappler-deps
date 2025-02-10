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

THIS_FILE := $(lastword $(MAKEFILE_LIST))
LIBS_MAKE_FILE := $(realpath $(lastword $(MAKEFILE_LIST)))
LIBS_MAKE_ROOT := $(dir $(LIBS_MAKE_FILE))

SRC_ROOT := $(LIBS_MAKE_ROOT)src
XWIN_ROOT := $(LIBS_MAKE_ROOT)xwin

WGET = wget
MKDIR = mkdir -p
TAR_XF = tar -xf

LIBS = \
	jpeg \
	libpng \
	giflib \
	libwebp \
	brotli \
	curl \
	freetype \
	sqlite \
	libuidna \
	libbacktrace \
	mbedtls \
	nghttp3 \
	libzip \
	zlib \
	openssl \
	openssl-gost-engine \
	wasm-micro-runtime

all: $(addprefix $(SRC_ROOT)/,$(LIBS)) replacements/curl/cacert.pem

clean:
	rm -rf $(SRC_ROOT) $(XWIN_ROOT) replacements/curl/cacert.pem

# http://www.ijg.org/
$(SRC_ROOT)/jpeg:
	@$(MKDIR) $(SRC_ROOT)
	cd $(SRC_ROOT); $(WGET) http://ijg.org/files/jpegsrc.v9f.tar.gz # revised: 10 feb 2025
	cd $(SRC_ROOT); $(TAR_XF) jpegsrc.v9f.tar.gz
	rm $(SRC_ROOT)/jpegsrc.v9f.tar.gz
	mv $(SRC_ROOT)/jpeg-9f $(SRC_ROOT)/jpeg

# http://www.libpng.org/pub/png/libpng.html
$(SRC_ROOT)/libpng:
	@$(MKDIR) $(SRC_ROOT)
	cd $(SRC_ROOT); $(WGET) http://prdownloads.sourceforge.net/libpng/libpng-1.6.45.tar.xz # revised: 10 feb 2025
	cd $(SRC_ROOT); $(TAR_XF) libpng-1.6.45.tar.xz
	rm $(SRC_ROOT)/libpng-1.6.45.tar.xz
	mv $(SRC_ROOT)/libpng-1.6.45 $(SRC_ROOT)/libpng

# https://sourceforge.net/projects/giflib/files/latest/download
$(SRC_ROOT)/giflib:
	@$(MKDIR) $(SRC_ROOT)
	cd $(SRC_ROOT); $(WGET) https://altushost-swe.dl.sourceforge.net/project/giflib/giflib-5.2.2.tar.gz # revised: 10 feb 2025
	cd $(SRC_ROOT); $(TAR_XF) giflib-5.2.2.tar.gz
	rm $(SRC_ROOT)/giflib-5.2.2.tar.gz
	mv $(SRC_ROOT)/giflib-5.2.2 $(SRC_ROOT)/giflib

# https://storage.googleapis.com/downloads.webmproject.org/releases/webp/index.html
$(SRC_ROOT)/libwebp:
	@$(MKDIR) $(SRC_ROOT)
	cd $(SRC_ROOT); $(WGET) https://storage.googleapis.com/downloads.webmproject.org/releases/webp/libwebp-1.5.0.tar.gz # revised: 10 feb 2025
	cd $(SRC_ROOT); $(TAR_XF) libwebp-1.5.0.tar.gz
	rm $(SRC_ROOT)/libwebp-1.5.0.tar.gz
	mv $(SRC_ROOT)/libwebp-1.5.0 $(SRC_ROOT)/libwebp

# https://github.com/google/brotli/releases
$(SRC_ROOT)/brotli:
	@$(MKDIR) $(SRC_ROOT)
	cd $(SRC_ROOT); $(WGET) https://github.com/google/brotli/archive/refs/tags/v1.1.0.tar.gz # revised: 10 feb 2025
	cd $(SRC_ROOT); $(TAR_XF) v1.1.0.tar.gz
	rm $(SRC_ROOT)/v1.1.0.tar.gz
	mv $(SRC_ROOT)/brotli-1.1.0 $(SRC_ROOT)/brotli

# https://github.com/Mbed-TLS/mbedtls/releases
$(SRC_ROOT)/mbedtls:
	@$(MKDIR) $(SRC_ROOT)
	cd $(SRC_ROOT); $(WGET) https://github.com/Mbed-TLS/mbedtls/releases/download/mbedtls-3.6.1/mbedtls-3.6.1.tar.bz2 # revised: 10 feb 2025
	cd $(SRC_ROOT); $(TAR_XF) mbedtls-3.6.1.tar.bz2
	rm $(SRC_ROOT)/mbedtls-3.6.1.tar.bz2
	mv $(SRC_ROOT)/mbedtls-3.6.1 $(SRC_ROOT)/mbedtls

# https://github.com/ngtcp2/nghttp3/releases
$(SRC_ROOT)/nghttp3:
	@$(MKDIR) $(SRC_ROOT)
	cd $(SRC_ROOT); $(WGET) https://github.com/ngtcp2/nghttp3/releases/download/v1.7.0/nghttp3-1.7.0.tar.bz2 # revised: 10 feb 2025
	cd $(SRC_ROOT); $(TAR_XF) nghttp3-1.7.0.tar.bz2
	rm $(SRC_ROOT)/nghttp3-1.7.0.tar.bz2
	mv $(SRC_ROOT)/nghttp3-1.7.0 $(SRC_ROOT)/nghttp3

# https://curl.se/download.html
$(SRC_ROOT)/curl:
	@$(MKDIR) $(SRC_ROOT)
	cd $(SRC_ROOT); $(WGET) https://curl.se/download/curl-8.12.0.tar.xz # revised: 10 feb 2025
	cd $(SRC_ROOT); $(TAR_XF) curl-8.12.0.tar.xz
	rm $(SRC_ROOT)/curl-8.12.0.tar.xz
	mv $(SRC_ROOT)/curl-8.12.0 $(SRC_ROOT)/curl

#	cd $(SRC_ROOT)/curl; patch lib/curl_trc.h < ../../replacements/curl/0001-WS-fix.patch

# https://download.savannah.gnu.org/releases/freetype/?C=M&O=D
$(SRC_ROOT)/freetype:
	@$(MKDIR) $(SRC_ROOT)
	cd $(SRC_ROOT); $(WGET) https://download.savannah.gnu.org/releases/freetype/freetype-2.13.3.tar.xz # revised: 10 feb 2025
	cd $(SRC_ROOT); $(TAR_XF) freetype-2.13.3.tar.xz
	rm $(SRC_ROOT)/freetype-2.13.3.tar.xz
	mv $(SRC_ROOT)/freetype-2.13.3 $(SRC_ROOT)/freetype

# https://www.sqlite.org/download.html
$(SRC_ROOT)/sqlite:
	@$(MKDIR) $(SRC_ROOT)
	cd $(SRC_ROOT); $(WGET) https://www.sqlite.org/2025/sqlite-amalgamation-3490000.zip # revised: 10 feb 2025
	cd $(SRC_ROOT); unzip sqlite-amalgamation-3490000.zip -d .
	rm $(SRC_ROOT)/sqlite-amalgamation-3490000.zip
	mv $(SRC_ROOT)/sqlite-amalgamation-3490000 $(SRC_ROOT)/sqlite

# https://github.com/SBKarr/libuidna
$(SRC_ROOT)/libuidna:
	@$(MKDIR) $(SRC_ROOT)
	cd $(SRC_ROOT); git clone https://github.com/SBKarr/libuidna.git $(SRC_ROOT)/libuidna # use upstream: 10 feb 2025

# https://github.com/ianlancetaylor/libbacktrace
$(SRC_ROOT)/libbacktrace:
	@$(MKDIR) $(SRC_ROOT)
	cd $(SRC_ROOT); git clone https://github.com/ianlancetaylor/libbacktrace.git --depth 1 $(SRC_ROOT)/libbacktrace # use upstream: 10 feb 2025

# https://libzip.org/download/
$(SRC_ROOT)/libzip:
	@$(MKDIR) $(SRC_ROOT)
	cd $(SRC_ROOT); $(WGET) https://libzip.org/download/libzip-1.11.3.tar.xz # revised: 10 feb 2025
	cd $(SRC_ROOT); $(TAR_XF) libzip-1.11.3.tar.xz
	rm $(SRC_ROOT)/libzip-1.11.3.tar.xz
	mv $(SRC_ROOT)/libzip-1.11.3 $(SRC_ROOT)/libzip

# https://www.zlib.net/
$(SRC_ROOT)/zlib:
	@$(MKDIR) $(SRC_ROOT)
	cd $(SRC_ROOT); wget https://www.zlib.net/zlib-1.3.1.tar.gz # revised: 10 feb 2025
	cd $(SRC_ROOT); $(TAR_XF) zlib-1.3.1.tar.gz
	rm $(SRC_ROOT)/zlib-1.3.1.tar.gz
	mv $(SRC_ROOT)/zlib-1.3.1 $(SRC_ROOT)/zlib

# https://openssl-library.org/source/index.html
$(SRC_ROOT)/openssl:
	@$(MKDIR) $(SRC_ROOT)
	cd $(SRC_ROOT); wget https://github.com/openssl/openssl/releases/download/openssl-3.3.2/openssl-3.3.2.tar.gz # revised: 10 feb 2025
	cd $(SRC_ROOT); $(TAR_XF) openssl-3.3.2.tar.gz
	rm $(SRC_ROOT)/openssl-3.3.2.tar.gz
	mv $(SRC_ROOT)/openssl-3.3.2 $(SRC_ROOT)/openssl
	cp -f replacements/openssl/async_posix.c $(SRC_ROOT)/openssl/crypto/async/arch/async_posix.c

# https://github.com/gost-engine/engine
$(SRC_ROOT)/openssl-gost-engine:
	@$(MKDIR) $(SRC_ROOT)
	cd $(SRC_ROOT); git clone  --recurse-submodules  --branch v3.0.3 https://github.com/gost-engine/engine.git --depth 1 openssl-gost-engine # revised: 10 feb 2025
	cp -f replacements/openssl-gost-engine/CMakeLists.txt $(SRC_ROOT)/openssl-gost-engine

# https://github.com/bytecodealliance/wasm-micro-runtime
$(SRC_ROOT)/wasm-micro-runtime:
	@$(MKDIR) $(SRC_ROOT)
	cd $(SRC_ROOT); git clone  --recurse-submodules  --branch WAMR-2.1.2 https://github.com/bytecodealliance/wasm-micro-runtime.git --depth 1 wasm-micro-runtime # revised: 10 feb 2025
	cd $(SRC_ROOT)/wasm-micro-runtime; git apply ../../replacements/wamr/0001-Initial-e2k-support.patch
	cd $(SRC_ROOT)/wasm-micro-runtime; git apply ../../replacements/wamr/0002-Windows-clang-fixes.patch

# Inject Russia Ministry of Digital Development certificates
# https://curl.se/ca
# https://www.gosuslugi.ru/crt
replacements/curl/cacert.pem: $(LIBS_MAKE_FILE)
	@$(MKDIR) replacements/curl
	cd replacements/curl; wget https://curl.se/ca/cacert-2024-12-31.pem # revised: 10 feb 2025
	cd replacements/curl; wget https://gu-st.ru/content/lending/russian_trusted_root_ca_pem.crt
	sed -i '1s;^;\nhttps://www.gosuslugi.ru/crt - Root\n====================\n;' replacements/curl/russian_trusted_root_ca_pem.crt
	cd replacements/curl; wget https://gu-st.ru/content/lending/russian_trusted_sub_ca_pem.crt
	sed -i '1s;^;\n\nhttps://www.gosuslugi.ru/crt - Sub\n====================\n;' replacements/curl/russian_trusted_sub_ca_pem.crt
	cd replacements/curl; wget https://gu-st.ru/content/lending/russian_trusted_sub_ca_2024_pem.crt
	sed -i '1s;^;\n\nhttps://www.gosuslugi.ru/crt - Sub 2024\n====================\n;' replacements/curl/russian_trusted_sub_ca_2024_pem.crt
	cd replacements/curl; cat \
		cacert-2024-12-31.pem \
		russian_trusted_root_ca_pem.crt \
		russian_trusted_sub_ca_pem.crt \
		russian_trusted_sub_ca_2024_pem.crt > cacert.pem
	cd replacements/curl; rm \
		cacert-2024-12-31.pem \
		russian_trusted_root_ca_pem.crt \
		russian_trusted_sub_ca_pem.crt \
		russian_trusted_sub_ca_2024_pem.crt

# https://github.com/Jake-Shadle/xwin/releases
xwin:
	@$(MKDIR) $(SRC_ROOT)
	$(WGET) https://github.com/Jake-Shadle/xwin/releases/download/0.6.5/xwin-0.6.5-x86_64-unknown-linux-musl.tar.gz # revised: 10 feb 2025
	$(TAR_XF) xwin-0.6.5-x86_64-unknown-linux-musl.tar.gz
	rm xwin-0.6.5-x86_64-unknown-linux-musl.tar.gz
	mv xwin-0.6.5-x86_64-unknown-linux-musl xwin
	cd xwin; ./xwin --accept-license unpack; ./xwin --accept-license splat
	mv xwin/.xwin-cache/splat xwin/splat

.PHONY: all clean
