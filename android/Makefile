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
MAKE_FILE := $(realpath $(lastword $(MAKEFILE_LIST)))
MAKE_ROOT := $(dir $(MAKE_FILE))

MKDIR = mkdir -p

NDK ?= "/home/sbkarr/Android/Ndk"
NDKPATH = $(NDK)/toolchains/llvm/prebuilt/linux-x86_64/bin

ifdef ARCH

CC := $(NDKPATH)/$(NDKP)-clang
CXX := $(NDKPATH)/$(NDKP)-clang++
OPT := -O3

LIBS := \
	libjpeg.a \
	libpng16.a \
	libbrotlienc.a \
	libgif.a \
	libwebp.a \
	libfreetype.a \
	libbacktrace.a \
	libsqlite3.a \
	libidn2.a \
	libmbedtls.a \
	libssl.a \
	libcurl-mbedtls.a \
	libcurl-openssl.a \
	libzip-mbedtls.a \
	libzip-openssl.a \
	libgost.a

PREFIX := $(MAKE_ROOT)$(ARCH)
LIB_SRC_DIR := $(realpath $(MAKE_ROOT)../src)

FORWARD_VARS := ARCH=$(ARCH) NDK=$(NDK) NDKP=$(NDKP) NDKPATH=$(NDKPATH) TARGET=$(TARGET) \
	PREFIX=$(PREFIX) CC=$(CC) CXX=$(CXX) OPT=$(OPT) LIB_SRC_DIR=$(LIB_SRC_DIR) MAKE_ROOT=$(MAKE_ROOT)

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

$(PREFIX)/lib/libbacktrace.a: $(MAKE_ROOT)libbacktrace.mk
	$(MAKE) -f $(MAKE_ROOT)libbacktrace.mk $(FORWARD_VARS)

$(PREFIX)/lib/libsqlite3.a: $(MAKE_ROOT)sqlite.mk
	$(MAKE) -f $(MAKE_ROOT)sqlite.mk $(FORWARD_VARS)

$(PREFIX)/lib/libglfw3.a: $(MAKE_ROOT)glfw.mk
	$(MAKE) -f $(MAKE_ROOT)glfw.mk $(FORWARD_VARS)

# Actually, use libuidna to mimic libidn2
$(PREFIX)/lib/libidn2.a: $(MAKE_ROOT)uidna.mk
	$(MAKE) -f $(MAKE_ROOT)uidna.mk $(FORWARD_VARS)

# HTTP3 temporary disabled for android
# waiting for proper library, that can be build automatically

$(PREFIX)/lib/libssl.a: $(MAKE_ROOT)openssl.mk
	$(MAKE) -f $(MAKE_ROOT)openssl.mk $(FORWARD_VARS)

#$(PREFIX)/lib/libnghttp3.a: $(MAKE_ROOT)nghttp3.mk
#	$(MAKE) -f $(MAKE_ROOT)nghttp3.mk $(FORWARD_VARS)

#$(PREFIX)/lib/libngtcp2.a: $(MAKE_ROOT)ngtcp2.mk $(PREFIX)/lib/libnghttp3.a $(PREFIX)/lib/libssl.a
#	$(MAKE) -f $(MAKE_ROOT)ngtcp2.mk $(FORWARD_VARS)

$(PREFIX)/lib/libmbedtls.a: $(MAKE_ROOT)mbedtls.mk
	$(MAKE) -f $(MAKE_ROOT)mbedtls.mk $(FORWARD_VARS)

$(PREFIX)/lib/libcurl-mbedtls.a: $(MAKE_ROOT)curl.mk $(PREFIX)/lib/libmbedtls.a $(PREFIX)/lib/libidn2.a $(PREFIX)/lib/libbacktrace.a
	$(MAKE) -f $(MAKE_ROOT)curl.mk $(FORWARD_VARS) VARIANT=mbedtls

$(PREFIX)/lib/libcurl-openssl.a: $(MAKE_ROOT)curl.mk $(PREFIX)/lib/libssl.a $(PREFIX)/lib/libidn2.a $(PREFIX)/lib/libbacktrace.a
	$(MAKE) -f $(MAKE_ROOT)curl.mk $(FORWARD_VARS) VARIANT=openssl

$(PREFIX)/lib/libzip-mbedtls.a: $(MAKE_ROOT)libzip.mk $(PREFIX)/lib/libmbedtls.a
	$(MAKE) -f $(MAKE_ROOT)libzip.mk $(FORWARD_VARS) VARIANT=mbedtls

$(PREFIX)/lib/libzip-openssl.a: $(MAKE_ROOT)libzip.mk $(PREFIX)/lib/libssl.a
	$(MAKE) -f $(MAKE_ROOT)libzip.mk $(FORWARD_VARS) VARIANT=openssl

$(PREFIX)/lib/libgost.a: $(MAKE_ROOT)gost.mk $(PREFIX)/lib/libssl.a
	$(MAKE) -f $(MAKE_ROOT)gost.mk $(FORWARD_VARS)

.PHONY: all

else

ARCHS := x86 x86_64 arm64-v8a armeabi-v7a

all: $(ARCHS)

clean:
	rm -rf x86 x86_64 arm64-v8a armeabi-v7a

x86_64:
	$(MKDIR) x86_64
	$(MAKE) -f $(THIS_FILE) ARCH=x86_64 NDKP=x86_64-linux-android24 TARGET=x86_64-linux-android

x86:
	$(MKDIR) x86
	$(MAKE) -f $(THIS_FILE) ARCH=x86 NDKP=i686-linux-android24 TARGET=i686-linux-android

arm64-v8a:
	$(MKDIR) arm64-v8a
	$(MAKE) -f $(THIS_FILE) ARCH=arm64-v8a NDKP=aarch64-linux-android24 TARGET=aarch64-linux-android

armeabi-v7a:
	$(MKDIR) armeabi-v7a
	$(MAKE) -f $(THIS_FILE) ARCH=armeabi-v7a NDKP=armv7a-linux-androideabi24 TARGET=armv7a-linux-androideabi

.PHONY: all x86 x86_64 arm64-v8a armeabi-v7a

endif