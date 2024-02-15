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

LIBNAME = brotli

CFLAGS := -I$(PREFIX)/include $(ARCH_CFLAGS)
LDFLAGS := $(CRT_LIB) -L$(PREFIX)/lib

CONFIGURE := \
	-DCMAKE_BUILD_TYPE=Release \
	-DCMAKE_C_COMPILER_TARGET="$(TARGET)" \
	-DCMAKE_C_FLAGS_INIT="$(CFLAGS)" \
	-DCMAKE_EXE_LINKER_FLAGS_INIT="$(LDFLAGS)" \
	-DCMAKE_SHARED_LINKER_FLAGS_INIT="$(LDFLAGS)" \
	-DCMAKE_INSTALL_PREFIX=$(PREFIX) \
	-DCMAKE_VERBOSE_MAKEFILE:BOOL=ON \
	-DBUILD_SHARED_LIBS=OFF \

all:
	@mkdir -p $(LIBNAME)
	cd $(LIBNAME); cmake $(CONFIGURE) $(LIB_SRC_DIR)/$(LIBNAME)
	cd $(LIBNAME); cmake  --build . --config Release --target install
	if [ -d "$(PREFIX)/lib64" ]; then cp -rf $(PREFIX)/lib64/* $(PREFIX)/lib/; fi
	if [ -d "$(PREFIX)/lib64" ]; then rm -rf $(PREFIX)/lib64; fi
	sed -i -e 's/ -lbrotlidec/ -lbrotlidec -lbrotlicommon/g' $(PREFIX)/lib/pkgconfig/libbrotlidec.pc
	sed -i -e 's/ -lbrotlienc/ -lbrotlienc -lbrotlicommon/g' $(PREFIX)/lib/pkgconfig/libbrotlienc.pc
	rm -rf $(LIBNAME)

.PHONY: all
