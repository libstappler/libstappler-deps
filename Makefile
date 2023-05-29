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

WGET = wget
MKDIR = mkdir -p
TAR_XF = tar -xf

LIBS = jpeg libpng giflib libwebp brotli curl freetype sqlite libuidna libbacktrace mbedtls libzip zlib

all: $(addprefix $(SRC_ROOT)/,$(LIBS))

clean:
	rm -rf $(addprefix $(SRC_ROOT)/,$(LIBS))

$(SRC_ROOT)/jpeg:
	@$(MKDIR) $(SRC_ROOT)
	$(WGET) http://www.ijg.org/files/jpegsrc.v9e.tar.gz # revised: 21 may 2023
	$(TAR_XF) jpegsrc.v9e.tar.gz
	rm jpegsrc.v9e.tar.gz
	mv jpeg-9e $(SRC_ROOT)/jpeg

$(SRC_ROOT)/libpng:
	@$(MKDIR) $(SRC_ROOT)
	$(WGET) http://prdownloads.sourceforge.net/libpng/libpng-1.6.39.tar.gz # revised: 21 may 2023
	$(TAR_XF) libpng-1.6.39.tar.gz
	rm libpng-1.6.39.tar.gz
	mv libpng-1.6.39 $(SRC_ROOT)/libpng

$(SRC_ROOT)/giflib:
	@$(MKDIR) $(SRC_ROOT)
	$(WGET) https://sourceforge.net/projects/giflib/files/giflib-5.2.1.tar.gz # revised: 21 may 2023
	$(TAR_XF) giflib-5.2.1.tar.gz
	rm giflib-5.2.1.tar.gz
	mv giflib-5.2.1 $(SRC_ROOT)/giflib

$(SRC_ROOT)/libwebp:
	@$(MKDIR) $(SRC_ROOT)
	$(WGET) https://storage.googleapis.com/downloads.webmproject.org/releases/webp/libwebp-1.3.0.tar.gz # revised: 21 may 2023
	$(TAR_XF) libwebp-1.3.0.tar.gz
	rm libwebp-1.3.0.tar.gz
	mv libwebp-1.3.0 $(SRC_ROOT)/libwebp

$(SRC_ROOT)/brotli:
	@$(MKDIR) $(SRC_ROOT)
	git clone https://github.com/google/brotli.git  --branch v1.0.9 --single-branch --depth 1 $(SRC_ROOT)/brotli # revised: 21 may 2023
	cd $(SRC_ROOT)/brotli; ./bootstrap

$(SRC_ROOT)/mbedtls:
	@$(MKDIR) $(SRC_ROOT)
	$(WGET) https://github.com/Mbed-TLS/mbedtls/archive/refs/tags/v3.4.0.tar.gz # revised: 21 may 2023
	$(TAR_XF) v3.4.0.tar.gz
	rm v3.4.0.tar.gz
	mv mbedtls-3.4.0 $(SRC_ROOT)/mbedtls

$(SRC_ROOT)/curl:
	@$(MKDIR) $(SRC_ROOT)
	$(WGET) https://curl.se/download/curl-8.1.0.tar.bz2 # revised: 21 may 2023
	$(TAR_XF) curl-8.1.0.tar.bz2
	rm curl-8.1.0.tar.bz2
	mv curl-8.1.0 $(SRC_ROOT)/curl

$(SRC_ROOT)/freetype:
	@$(MKDIR) $(SRC_ROOT)
	$(WGET) https://mirrors.sarata.com/non-gnu/freetype/freetype-2.13.0.tar.xz # revised: 21 may 2023
	$(TAR_XF) freetype-2.13.0.tar.xz
	rm freetype-2.13.0.tar.xz
	mv freetype-2.13.0 $(SRC_ROOT)/freetype

$(SRC_ROOT)/sqlite:
	@$(MKDIR) $(SRC_ROOT)
	$(WGET) https://www.sqlite.org/2023/sqlite-amalgamation-3420000.zip # revised: 21 may 2023
	unzip sqlite-amalgamation-3420000.zip -d .
	rm sqlite-amalgamation-3420000.zip
	mv sqlite-amalgamation-3420000 $(SRC_ROOT)/sqlite

$(SRC_ROOT)/libuidna:
	@$(MKDIR) $(SRC_ROOT)
	git clone https://github.com/SBKarr/libuidna.git $(SRC_ROOT)/libuidna # use upstream: 21 may 2023

$(SRC_ROOT)/libbacktrace:
	@$(MKDIR) $(SRC_ROOT)
	git clone https://github.com/ianlancetaylor/libbacktrace.git --depth 1 $(SRC_ROOT)/libbacktrace # use upstream: 21 may 2023

$(SRC_ROOT)/libzip:
	@$(MKDIR) $(SRC_ROOT)
	wget https://github.com/nih-at/libzip/releases/download/v1.9.2/libzip-1.9.2.tar.gz # revised: 21 may 2023
	$(TAR_XF) libzip-1.9.2.tar.gz
	rm libzip-1.9.2.tar.gz
	mv libzip-1.9.2 $(SRC_ROOT)/libzip
	sed -i -e 's/mbedtls\/version.h/mbedtls\/build_info.h/g' $(SRC_ROOT)/libzip/cmake/FindMbedTLS.cmake

$(SRC_ROOT)/zlib:
	@$(MKDIR) $(SRC_ROOT)
	wget https://github.com/madler/zlib/releases/download/v1.2.13/zlib-1.2.13.tar.gz # revised: 21 may 2023
	$(TAR_XF) zlib-1.2.13.tar.gz
	rm zlib-1.2.13.tar.gz
	mv zlib-1.2.13 $(SRC_ROOT)/zlib

xwin:
	@$(MKDIR) $(SRC_ROOT)
	$(WGET) https://github.com/Jake-Shadle/xwin/releases/download/0.2.1/xwin-0.2.1-x86_64-unknown-linux-musl.tar.gz
	$(TAR_XF) xwin-0.2.1-x86_64-unknown-linux-musl.tar.gz
	rm xwin-0.2.1-x86_64-unknown-linux-musl.tar.gz
	mv xwin-0.2.1-x86_64-unknown-linux-musl xwin
	cd xwin; ./xwin --accept-license unpack; ./xwin --accept-license splat
	mv xwin/.xwin-cache/splat xwin/splat

.PHONY: all clean
