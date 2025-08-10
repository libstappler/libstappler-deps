# Copyright (c) 2023-2024 Stappler LLC <admin@stappler.dev>
# Copyright (c) 2025 Stappler Team <admin@stappler.org>
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

LCC_TOOLCHAIN_PATH ?= /opt/mcst/lcc-1.28.09.e2k-v7.6.1

THIS_FILE := $(lastword $(MAKEFILE_LIST))
MAKE_FILE := $(realpath $(lastword $(MAKEFILE_LIST)))
MAKE_ROOT := $(dir $(MAKE_FILE))

MKDIR = mkdir -p

OPT := -O3 -fPIC -DPIC

LIBS := \
	libz.a \
	libjpeg.a \
	libpng16.a \
	libgif.a \
	libwebp.a \
	libbrotlienc.a \
	libfreetype.a \
	libsqlite3.a \
	libidn2.a \
	libmbedtls.a \
	libnghttp3.a \
	libssl.a \
	libgost.a \
	libcurl-openssl.a \
	libzip-openssl.a \
	libcurl-mbedtls.a \
	libzip-mbedtls.a \
	libiwasm-release.a \
	libiwasm-debug.a


ifndef ARCH

ARCHS := x86_64 aarch64

all: $(ARCHS)

clean:
	rm -rf x86_64 e2k aarch64

x86_64:
	$(MKDIR) x86_64
	$(MAKE) -f $(THIS_FILE) ARCH=x86_64 CC=gcc CXX=g++

e2k:
	$(MKDIR) e2k
	$(MAKE) -f $(THIS_FILE) ARCH=e2k CC=e2k-linux-lcc CXX=e2k-linux-l++

aarch64:
	$(MKDIR) aarch64
	$(MAKE) -f $(THIS_FILE) ARCH=aarch64 CC=aarch64-linux-gnu-gcc CXX=aarch64-linux-gnu-g++

.PHONY: all x86_64 e2k aarch64

else # ARCH

ifeq ($(ARCH),e2k)
LOCAL_PATH := $(LCC_TOOLCHAIN_PATH)/bin.toolchain:$(PATH)
export PATH = $(LOCAL_PATH)
endif # e2k

PREFIX := $(MAKE_ROOT)$(ARCH)
LIB_SRC_DIR := $(realpath $(MAKE_ROOT)../src)

FORWARD_VARS := \
	ARCH=$(ARCH) \
	PREFIX=$(PREFIX) \
	CC=$(CC) \
	CXX=$(CXX) \
	OPT="$(OPT)" \
	LIB_SRC_DIR=$(LIB_SRC_DIR) \
	MAKE_ROOT=$(MAKE_ROOT)

ARCH_LIBS = $(addprefix $(PREFIX)/lib/,$(LIBS))

all: $(ARCH_LIBS)

$(PREFIX)/lib/libjpeg.a: $(MAKE_ROOT)jpeg.mk
	$(MAKE) -f $(MAKE_ROOT)jpeg.mk $(FORWARD_VARS)

$(PREFIX)/lib/libpng16.a: $(MAKE_ROOT)libpng.mk
	$(MAKE) -f $(MAKE_ROOT)libpng.mk $(FORWARD_VARS)

$(PREFIX)/lib/libbrotlienc.a: $(MAKE_ROOT)brotli.mk
	$(MAKE) -f $(MAKE_ROOT)brotli.mk $(FORWARD_VARS)

$(PREFIX)/lib/libgif.a: $(MAKE_ROOT)gif.mk
	$(MAKE) -f $(MAKE_ROOT)gif.mk $(FORWARD_VARS)

$(PREFIX)/lib/libwebp.a: $(MAKE_ROOT)libwebp.mk $(PREFIX)/lib/libpng16.a $(PREFIX)/lib/libjpeg.a $(PREFIX)/lib/libgif.a
	$(MAKE) -f $(MAKE_ROOT)libwebp.mk $(FORWARD_VARS)

$(PREFIX)/lib/libfreetype.a: $(MAKE_ROOT)freetype.mk $(PREFIX)/lib/libbrotlienc.a $(PREFIX)/lib/libpng16.a
	$(MAKE) -f $(MAKE_ROOT)freetype.mk $(FORWARD_VARS)

$(PREFIX)/lib/libsqlite3.a: $(MAKE_ROOT)sqlite.mk
	$(MAKE) -f $(MAKE_ROOT)sqlite.mk $(FORWARD_VARS)

# Actually, use libuidna to mimic libidn2
$(PREFIX)/lib/libidn2.a: $(MAKE_ROOT)uidna.mk
	$(MAKE) -f $(MAKE_ROOT)uidna.mk $(FORWARD_VARS)

$(PREFIX)/lib/libcurl-openssl.a: $(MAKE_ROOT)curl.mk $(PREFIX)/lib/libssl.a $(PREFIX)/lib/libidn2.a
	$(MAKE) -f $(MAKE_ROOT)curl.mk $(FORWARD_VARS) VARIANT=openssl

$(PREFIX)/lib/libcurl-mbedtls.a: $(MAKE_ROOT)curl.mk $(PREFIX)/lib/libmbedtls.a $(PREFIX)/lib/libidn2.a
	$(MAKE) -f $(MAKE_ROOT)curl.mk $(FORWARD_VARS) VARIANT=mbedtls

$(PREFIX)/lib/libcurl-gnutls.a: $(MAKE_ROOT)curl.mk $(PREFIX)/lib/libidn2.a
	$(MAKE) -f $(MAKE_ROOT)curl.mk $(FORWARD_VARS) VARIANT=gnutls

$(PREFIX)/lib/libmbedtls.a: $(MAKE_ROOT)mbedtls.mk
	$(MAKE) -f $(MAKE_ROOT)mbedtls.mk $(FORWARD_VARS)

$(PREFIX)/lib/libnghttp3.a: $(MAKE_ROOT)nghttp3.mk
	$(MAKE) -f $(MAKE_ROOT)nghttp3.mk $(FORWARD_VARS)

$(PREFIX)/lib/libzip-openssl.a: $(MAKE_ROOT)libzip.mk $(PREFIX)/lib/libssl.a
	$(MAKE) -f $(MAKE_ROOT)libzip.mk $(FORWARD_VARS) VARIANT=openssl

$(PREFIX)/lib/libzip-mbedtls.a: $(MAKE_ROOT)libzip.mk $(PREFIX)/lib/libmbedtls.a
	$(MAKE) -f $(MAKE_ROOT)libzip.mk $(FORWARD_VARS) VARIANT=mbedtls

$(PREFIX)/lib/libzip-gnutls.a: $(MAKE_ROOT)libzip.mk
	$(MAKE) -f $(MAKE_ROOT)libzip.mk $(FORWARD_VARS) VARIANT=gnutls

$(PREFIX)/lib/libz.a: $(MAKE_ROOT)zlib.mk
	$(MAKE) -f $(MAKE_ROOT)zlib.mk $(FORWARD_VARS)

$(PREFIX)/lib/libssl.a: $(MAKE_ROOT)openssl.mk
	$(MAKE) -f $(MAKE_ROOT)openssl.mk $(FORWARD_VARS)

$(PREFIX)/lib/libgost.a: $(MAKE_ROOT)gost.mk $(PREFIX)/lib/libssl.a
	$(MAKE) -f $(MAKE_ROOT)gost.mk $(FORWARD_VARS)

$(PREFIX)/lib/libiwasm-release.a $(PREFIX)/lib/libiwasm-debug.a: $(MAKE_ROOT)wamr.mk $(PREFIX)/lib/libz.a
	$(MAKE) -f $(MAKE_ROOT)wamr.mk $(FORWARD_VARS)

.PHONY: all

endif
