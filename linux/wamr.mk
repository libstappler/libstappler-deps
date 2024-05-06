# Copyright (c) 2024 Stappler LLC <admin@stappler.dev>
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

CFLAGS := -I$(PREFIX)/include $(ARCH_CFLAGS)
LDFLAGS := $(CRT_LIB) -L$(PREFIX)/lib

CONFIGURE_ARGS := \
	-DCMAKE_C_COMPILER_TARGET="$(TARGET)" \
	-DCMAKE_C_FLAGS_INIT="$(CFLAGS)" \
	-DCMAKE_EXE_LINKER_FLAGS_INIT="$(LDFLAGS)" \
	-DCMAKE_SHARED_LINKER_FLAGS_INIT="$(LDFLAGS)" \
	-DCMAKE_INSTALL_PREFIX=$(PREFIX) \
	-DCMAKE_VERBOSE_MAKEFILE:BOOL=ON \
	-DBUILD_SHARED_LIBS=OFF \
	-DWAMR_BUILD_PLATFORM=linux \
	-DWAMR_BUILD_INTERP=1 \
	-DWAMR_BUILD_AOT=1 \
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

CONFIGURE := \
	-DCMAKE_BUILD_TYPE=Release \
	$(CONFIGURE_ARGS) \
	-DWAMR_BUILD_FAST_INTERP=1

CONFIGURE_DEBUG := \
	-DCMAKE_BUILD_TYPE=Debug \
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
	cp -f $(LIBNAME)/libvmlib.a $(PREFIX)/lib/libvmlib-release.a
	rm -rf $(LIBNAME)

$(PREFIX)/lib/libvmlib-debug.a:
	@mkdir -p $(LIBNAME)
	cd $(LIBNAME); cmake $(CONFIGURE_DEBUG) $(LIB_SRC_DIR)/$(LIBNAME)
	cd $(LIBNAME); cmake  --build . --config Debug
	cp -f $(LIBNAME)/libvmlib.a $(PREFIX)/lib/libvmlib-debug.a
	rm -rf $(LIBNAME)

all: $(INCLUDES) $(PREFIX)/lib/libvmlib-release.a $(PREFIX)/lib/libvmlib-debug.a

.PHONY: all
