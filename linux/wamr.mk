# Copyright (c) 2024-2024 Stappler LLC <admin@stappler.dev>
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

LIBNAME = wasm-micro-runtime

include configure.mk

CONFIGURE_ARGS := \
	$(CONFIGURE_CMAKE) \
	-DWAMR_BUILD_PLATFORM=linux \
	-DWAMR_BUILD_INTERP=1 \
	-DWAMR_BUILD_JIT=0 \
	-DWAMR_BUILD_LIBC_BUILTIN=1 \
	-DWAMR_BUILD_LIBC_WASI=1 \
	-DWAMR_BUILD_TAIL_CALL=1 \
	-DWAMR_BUILD_REF_TYPES=1 \
	-DWAMR_BUILD_MODULE_INST_CONTEXT=1 \
	-DWAMR_BUILD_MULTI_MODULE=1 \
	-DWAMR_BUILD_BULK_MEMORY=1 \
	-DWAMR_BUILD_SIMD=0 \
	-DWAMR_BUILD_LIB_PTHREAD=1 \
	-DWAMR_BUILD_LIB_PTHREAD_SEMAPHORE=1 \
	-DWAMR_BUILD_LIB_WASI_THREADS=1

ifeq ($(ARCH),e2k)
CONFIGURE_ARGS += \
	-DWAMR_BUILD_TARGET=E2K_64 \
	-DWAMR_BUILD_AOT=0
endif

ifeq ($(ARCH),aarch64)
CONFIGURE_ARGS += \
	-DWAMR_BUILD_TARGET=AARCH64 \
	-DWAMR_BUILD_AOT=1
endif

ifeq ($(ARCH),x86_64)
CONFIGURE_ARGS += \
	-DWAMR_BUILD_TARGET=X86_64 \
	-DWAMR_BUILD_AOT=1
endif

CONFIGURE := \
	$(CONFIGURE_ARGS) \
	-DWAMR_BUILD_FAST_INTERP=1

CONFIGURE_DEBUG := \
	$(CONFIGURE_ARGS) \
	-DWAMR_DISABLE_WRITE_GS_BASE=1 \
	-DWAMR_BUILD_DEBUG_INTERP=1 \
	-DWAMR_BUILD_DEBUG_AOT=1 \
	-DWAMR_BUILD_FAST_INTERP=0

INCLUDES := $(PREFIX)/include/wamr/wasm_export.h $(PREFIX)/include/wamr/lib_export.h

$(PREFIX)/include/wamr/wasm_export.h:
	mkdir -p $(PREFIX)/include/wamr
	cp -f $(LIB_SRC_DIR)/$(LIBNAME)/core/iwasm/include/wasm_export.h $(PREFIX)/include/wamr/wasm_export.h

$(PREFIX)/include/wamr/lib_export.h:
	mkdir -p $(PREFIX)/include/wamr
	cp -f $(LIB_SRC_DIR)/$(LIBNAME)/core/iwasm/include/lib_export.h $(PREFIX)/include/wamr/lib_export.h

$(PREFIX)/lib/libvmlib-release.a:
	@mkdir -p $(LIBNAME)
	cd $(LIBNAME); cmake $(CONFIGURE) $(LIB_SRC_DIR)/$(LIBNAME)
	cd $(LIBNAME); cmake  --build . --config Release
	cp -f $(LIBNAME)/libiwasm.a $(PREFIX)/lib/libiwasm-release.a
	rm -rf $(LIBNAME)

$(PREFIX)/lib/libvmlib-debug.a:
	@mkdir -p $(LIBNAME)
	cd $(LIBNAME); cmake $(CONFIGURE_DEBUG) $(LIB_SRC_DIR)/$(LIBNAME)
	cd $(LIBNAME); cmake  --build . --config Debug
	cp -f $(LIBNAME)/libiwasm.a $(PREFIX)/lib/libiwasm-debug.a
	rm -rf $(LIBNAME)

all: $(INCLUDES) $(PREFIX)/lib/libvmlib-release.a $(PREFIX)/lib/libvmlib-debug.a

.PHONY: all
