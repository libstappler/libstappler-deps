
THIS_FILE := $(lastword $(MAKEFILE_LIST))
MAKE_FILE := $(realpath $(lastword $(MAKEFILE_LIST)))
MAKE_ROOT := $(dir $(MAKE_FILE))

XWIN_DIR := $(realpath $(MAKE_ROOT)/../../../xwin)
REPLACEMENTS_DIR := $(realpath $(MAKE_ROOT)/../../../windows/replacements/include)

ARCH ?= x86_64
ARCH_LOCAL ?= x64

CC ?= clang

TARGET ?= x86_64-windows-msvc

CRT_INCLUDE += \
	-I$(REPLACEMENTS_DIR) \
	-I$(XWIN_DIR)/splat/crt/include \
	-I$(XWIN_DIR)/splat/sdk/include/ucrt \
	-I$(XWIN_DIR)/splat/sdk/include/um \
	-I$(XWIN_DIR)/splat/sdk/include/shared

CRT_LIB += \
	-L$(XWIN_DIR)/splat/crt/lib/$(ARCH) \
	-L$(XWIN_DIR)/splat/sdk/lib/um/$(ARCH) \
	-L$(XWIN_DIR)/splat/sdk/lib/ucrt/$(ARCH) \
	-L$(XWIN_DIR)/.xwin-cache/unpack/Microsoft.VC.14.37.17.7.CRT.$(ARCH_LOCAL).Store.base.vsix/lib/$(ARCH_LOCAL) \
	-L$(XWIN_DIR)/.xwin-cache/unpack/ucrt.msi/lib/ucrt/$(ARCH_LOCAL)

hello.exe:
	$(CC) --target=$(TARGET) $(CRT_INCLUDE) $(CRT_LIB) -Wno-ignored-attributes -fuse-ld=lld -msse2 hello.c -o hello.exe

clean:
	rm -f hello.exe

all: hello.exe