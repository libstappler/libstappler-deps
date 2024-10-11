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

LIBNAME = freetype

include configure.mk

CONFIGURE := \
	$(CONFIGURE_AUTOCONF) \
	--with-bzip2=no \
	--with-zlib=yes \
	--with-png=yes \
	--with-harfbuzz=no \
	--with-pic=yes \
	--with-brotli=yes \
	--enable-static=yes \
	--enable-shared=no

all:
	@mkdir -p $(LIBNAME)
	cd $(LIBNAME); \
		PATH=$(REPLACEMENTS_BIN):$(PATH) $(LIB_SRC_DIR)/$(LIBNAME)/configure $(CONFIGURE); \
		PATH=$(REPLACEMENTS_BIN):$(PATH) make -j8; \
		PATH=$(REPLACEMENTS_BIN):$(PATH) make install
	rm -rf $(LIBNAME)
	cp -rf $(PREFIX)/include/freetype2/* $(PREFIX)/include
	rm -rf $(PREFIX)/include/freetype2
	mv -f $(PREFIX)/lib/libfreetype.a $(PREFIX)/lib/freetype.lib
	rm -f $(PREFIX)/lib/libfreetype.la

.PHONY: all
