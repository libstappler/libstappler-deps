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

LIBNAME = sqlite

WARN := -Wno-ignored-attributes -Wno-deprecated-declarations -Wno-nonportable-include-path -Wno-pragma-pack \
	-Wno-microsoft-anon-tag -Wno-ignored-pragma-intrinsic -Wno-unused-parameter
CFLAGS := $(REPLACEMENTS_INCLUDE) $(CRT_INCLUDE) -I$(PREFIX)/include --target=$(TARGET) $(WARN) -D_MT
LDFLAGS := $(CRT_LIB) -L$(PREFIX)/lib -fuse-ld=lld --target=$(TARGET) -Xlinker -nodefaultlibs -lkernel32 -loldnames

ifdef RELEASE
CFLAGS += -Xclang --dependent-lib=libcmt $(OPT)
LDFLAGS += -llibucrt -llibcmt -llibvcruntime
else
CFLAGS += -Xclang --dependent-lib=libcmtd -g -Xclang -gcodeview -D_DEBUG
LDFLAGS += -llibucrtd -llibcmtd -llibvcruntimed
endif

all:
	@mkdir -p $(PREFIX)/lib $(PREFIX)/include
	@mkdir -p $(LIBNAME)
	cd $(LIBNAME); \
		$(CC) $(OPT) $(CFLAGS) -c -o sqlite3.o $(LIB_SRC_DIR)/$(LIBNAME)/sqlite3.c; \
		ar rcs sqlite3.lib sqlite3.o
	mv -f $(LIBNAME)/sqlite3.lib $(PREFIX)/lib/
	rm -rf $(LIBNAME)
	cp -f $(LIB_SRC_DIR)/$(LIBNAME)/*.h $(PREFIX)/include/
