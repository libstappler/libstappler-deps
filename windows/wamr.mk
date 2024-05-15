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

WARN := -Wno-ignored-attributes -Wno-deprecated-declarations -Wno-nonportable-include-path -Wno-pragma-pack \
	-Wno-microsoft-anon-tag -Wno-ignored-pragma-intrinsic -Wno-unused-parameter -Wno-sign-compare -Wno-unknown-pragmas
CFLAGS_INIT := $(REPLACEMENTS_INCLUDE) $(CRT_INCLUDE) -I$(PREFIX)/include --target=$(TARGET) $(WARN) -msse2 \
	-D_CRT_USE_BUILTIN_OFFSETOF -Dgetcwd=_getcwd
LDFLAGS_INIT := $(CRT_LIB) -L$(PREFIX)/lib -fuse-ld=lld-link --target=$(TARGET) -lkernel32 -loldnames -lbcrypt -lpathcch -lntdll
export CFLAGS := $(CFLAGS_INIT)
export LDFLAGS := $(LDFLAGS_INIT)

CONFIGURE_ARGS := \
	-DCMAKE_C_COMPILER_TARGET="$(TARGET)" \
	-DCMAKE_C_FLAGS_INIT="$(CFLAGS_INIT)" \
	-DCMAKE_CXX_FLAGS_INIT="-std=gnu++20 $(CFLAGS_INIT)" \
	-DCMAKE_EXE_LINKER_FLAGS_INIT="$(LDFLAGS_INIT)" \
	-DCMAKE_SHARED_LINKER_FLAGS_INIT="$(LDFLAGS_INIT)" \
	-DCMAKE_INSTALL_PREFIX=$(PREFIX)\
	-DCMAKE_RC_COMPILER=$(CC) \
	-DCMAKE_SYSTEM_NAME=Windows \
	-DCMAKE_VERBOSE_MAKEFILE:BOOL=ON \
	-DBUILD_SHARED_LIBS=OFF \
	-DCMAKE_POLICY_DEFAULT_CMP0091=NEW \
	-DWAMR_BUILD_PLATFORM=windows \
	-DWAMR_BUILD_TARGET=X86_64 \
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
	-DWAMR_BUILD_LIB_PTHREAD=0 \
	-DWAMR_BUILD_LIB_PTHREAD_SEMAPHORE=0 \
	-DWAMR_BUILD_LIB_WASI_THREADS=0 \
	-DWAMR_BUILD_TARGET=X86_64 \
	-DWAMR_BUILD_AOT=1

ifdef RELEASE
CONFIGURE_ARGS += -DCMAKE_MSVC_RUNTIME_LIBRARY=MultiThreaded -DCMAKE_BUILD_TYPE=Release
else
CFLAGS += -g -Xclang -gcodeview -D_DEBUG
CONFIGURE_ARGS += -DCMAKE_MSVC_RUNTIME_LIBRARY=MultiThreadedDebug -DCMAKE_BUILD_TYPE=Debug
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

$(PREFIX)/lib/vmlib-release.lib:
	@mkdir -p $(LIBNAME)
	cd $(LIBNAME); cmake $(CONFIGURE) $(LIB_SRC_DIR)/$(LIBNAME)
	cd $(LIBNAME); cmake  --build . --config Release
	cp -f $(LIBNAME)/vmlib.lib $(PREFIX)/lib/vmlib-release.lib
	rm -rf $(LIBNAME)

$(PREFIX)/lib/vmlib-debug.lib:
	@mkdir -p $(LIBNAME)
	cd $(LIBNAME); cmake $(CONFIGURE_DEBUG) $(LIB_SRC_DIR)/$(LIBNAME)
	cd $(LIBNAME); cmake  --build . --config Debug
	cp -f $(LIBNAME)/vmlib.lib $(PREFIX)/lib/vmlib-debug.lib
	rm -rf $(LIBNAME)

all: $(INCLUDES) $(PREFIX)/lib/vmlib-release.lib $(PREFIX)/lib/vmlib-debug.lib

.PHONY: all
