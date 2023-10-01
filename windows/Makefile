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

ifdef ARCH

CRT_INCLUDE :=
CRT_LIB :=

ifdef XWIN

XWIN_DIR := $(realpath $(MAKE_ROOT)/../xwin)
REPLACEMENTS_INCLUDE := $(realpath $(MAKE_ROOT)/../windows/replacements/include)
REPLACEMENTS_BIN := $(realpath $(MAKE_ROOT)/../windows/replacements/bin)

CRT_INCLUDE += \
	-I$(XWIN_DIR)/splat/crt/include \
	-I$(XWIN_DIR)/splat/sdk/include/ucrt \
	-I$(XWIN_DIR)/splat/sdk/include/um \
	-I$(XWIN_DIR)/splat/sdk/include/shared

CRT_LIB += \
	-L$(XWIN_DIR)/splat/crt/lib/$(ARCH) \
	-L$(XWIN_DIR)/splat/sdk/lib/um/$(ARCH) \
	-L$(XWIN_DIR)/splat/sdk/lib/ucrt/$(ARCH) \
	-L$(XWIN_DIR)/.xwin-cache/unpack/ucrt.msi/lib/ucrt/$(ARCH_LOCAL)

ifdef RELEASE
CRT_LIB += \
	-L$(XWIN_DIR)/.xwin-cache/unpack/Microsoft.VC.14.37.17.7.CRT.$(ARCH_LOCAL).Store.base.vsix/lib/$(ARCH_LOCAL)
else
CRT_LIB += \
	-L$(XWIN_DIR)/.xwin-cache/unpack/Microsoft.VC.14.37.17.7.CRT.$(ARCH_LOCAL).Desktop.base.vsix/lib/$(ARCH_LOCAL)
endif

endif

CC := clang-16
CXX := clang++-16
LD := lld-link
OPT := -O3

LIBS := \
	z.lib \
	jpeg.lib \
	png16.lib \
	brotlienc.lib \
	gif.lib \
	webp.lib \
	freetype.lib \
	backtrace.lib \
	sqlite3.lib \
	idn2.lib \
	mbedtls.lib \
	zip.lib \
	ssl.lib \
	gost.lib \
	curl-mbedtls.lib \
	curl-openssl.lib


ifdef RELEASE
PREFIX := $(MAKE_ROOT)$(ARCH)/release
FORWARD_VARS := RELEASE=1
else
PREFIX := $(MAKE_ROOT)$(ARCH)/debug
FORWARD_VARS :=
endif

LIB_SRC_DIR := $(realpath $(MAKE_ROOT)../src)

FORWARD_VARS := ARCH=$(ARCH) PREFIX=$(PREFIX) CC=$(CC) CXX=$(CXX) LD=$(LD) OPT=$(OPT) LIB_SRC_DIR=$(LIB_SRC_DIR) MAKE_ROOT=$(MAKE_ROOT) \
	REPLACEMENTS_INCLUDE="-I$(REPLACEMENTS_INCLUDE)" CRT_INCLUDE="$(CRT_INCLUDE)" CRT_LIB="$(CRT_LIB)" TARGET=$(TARGET) \
	REPLACEMENTS_BIN=$(REPLACEMENTS_BIN) XWIN_DIR=$(XWIN_DIR)

ARCH_LIBS = $(addprefix $(PREFIX)/lib/,$(LIBS))

all: $(ARCH_LIBS)

$(PREFIX)/lib/z.lib: $(MAKE_ROOT)zlib.mk
	$(MAKE) -f $(MAKE_ROOT)zlib.mk $(FORWARD_VARS)

$(PREFIX)/lib/jpeg.lib: $(MAKE_ROOT)jpeg.mk
	$(MAKE) -f $(MAKE_ROOT)jpeg.mk $(FORWARD_VARS)

$(PREFIX)/lib/png16.lib: $(MAKE_ROOT)libpng.mk $(PREFIX)/lib/z.lib
	$(MAKE) -f $(MAKE_ROOT)libpng.mk $(FORWARD_VARS)

$(PREFIX)/lib/brotlienc.lib: $(MAKE_ROOT)brotli.mk
	$(MAKE) -f $(MAKE_ROOT)brotli.mk $(FORWARD_VARS)

$(PREFIX)/lib/gif.lib: $(MAKE_ROOT)gif.mk
	$(MAKE) -f $(MAKE_ROOT)gif.mk $(FORWARD_VARS)

$(PREFIX)/lib/webp.lib: $(MAKE_ROOT)libwebp.mk $(PREFIX)/lib/png16.lib $(PREFIX)/lib/jpeg.lib $(PREFIX)/lib/gif.lib
	$(MAKE) -f $(MAKE_ROOT)libwebp.mk $(FORWARD_VARS)

$(PREFIX)/lib/freetype.lib: $(MAKE_ROOT)freetype.mk $(PREFIX)/lib/brotlienc.lib $(PREFIX)/lib/png16.lib
	$(MAKE) -f $(MAKE_ROOT)freetype.mk $(FORWARD_VARS)

$(PREFIX)/lib/backtrace.lib: $(MAKE_ROOT)libbacktrace.mk
	$(MAKE) -f $(MAKE_ROOT)libbacktrace.mk $(FORWARD_VARS)

$(PREFIX)/lib/sqlite3.lib: $(MAKE_ROOT)sqlite.mk
	$(MAKE) -f $(MAKE_ROOT)sqlite.mk $(FORWARD_VARS)

# Actually, use libuidna to mimic libidn2
$(PREFIX)/lib/idn2.lib: $(MAKE_ROOT)uidna.mk
	$(MAKE) -f $(MAKE_ROOT)uidna.mk $(FORWARD_VARS)

$(PREFIX)/lib/mbedtls.lib: $(MAKE_ROOT)mbedtls.mk
	$(MAKE) -f $(MAKE_ROOT)mbedtls.mk $(FORWARD_VARS)

$(PREFIX)/lib/zip.lib: $(MAKE_ROOT)libzip.mk $(PREFIX)/lib/brotlienc.lib $(PREFIX)/lib/z.lib
	$(MAKE) -f $(MAKE_ROOT)libzip.mk $(FORWARD_VARS)

$(PREFIX)/lib/ssl.lib: $(MAKE_ROOT)openssl.mk
	$(MAKE) -f $(MAKE_ROOT)openssl.mk $(FORWARD_VARS)

$(PREFIX)/lib/gost.lib: $(MAKE_ROOT)gost.mk $(PREFIX)/lib/ssl.lib
	$(MAKE) -f $(MAKE_ROOT)gost.mk $(FORWARD_VARS)

$(PREFIX)/lib/curl-openssl.lib: $(MAKE_ROOT)curl.mk $(PREFIX)/lib/ssl.lib $(PREFIX)/lib/idn2.lib $(PREFIX)/lib/backtrace.lib
	$(MAKE) -f $(MAKE_ROOT)curl.mk $(FORWARD_VARS) VARIANT=openssl

$(PREFIX)/lib/curl-mbedtls.lib: $(MAKE_ROOT)curl.mk $(PREFIX)/lib/mbedtls.lib $(PREFIX)/lib/idn2.lib $(PREFIX)/lib/backtrace.lib
	$(MAKE) -f $(MAKE_ROOT)curl.mk $(FORWARD_VARS) VARIANT=mbedtls

.PHONY: all

else

ARCHS := x86_64/release x86_64/debug

all: $(ARCHS)

clean:
	rm -rf x86_64/release x86_64/debug

x86_64/debug:
	$(MKDIR) x86_64/debug
	$(MAKE) -f $(THIS_FILE) ARCH=x86_64 XWIN=1 TARGET=x86_64-windows-msvc ARCH_LOCAL=x64

x86_64/release:
	$(MKDIR) x86_64/release
	$(MAKE) -f $(THIS_FILE) ARCH=x86_64 XWIN=1 TARGET=x86_64-windows-msvc ARCH_LOCAL=x64 RELEASE=1

.PHONY: all x86_64/debug x86_64/release

endif
