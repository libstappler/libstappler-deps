#!/bin/bash

if [ -z "$ANDROID_NDK_ROOT" ]; then
NDK="/home/sbkarr/Android/Sdk/ndk/23.1.7779620"
else
NDK="$ANDROID_NDK_ROOT"
fi

NDKPATH=$NDK/toolchains/llvm/prebuilt/linux-x86_64/bin

export AR=$NDKPATH/llvm-ar
export LD=$NDKPATH/ld
export RANLIB=$NDKPATH/llvm-ranlib
export STRIP=$NDKPATH/llvm-strip
export OBJDUMP=$NDKPATH/llvm-objdump
export OBJCOPY=$NDKPATH/llvm-objcopy
export READELF=$NDKPATH/llvm-readelf
export NM=$NDKPATH/llvm-nm
export LINK=$NDKPATH/llvm-link

LIBNAME=libidn2

Compile () {

mkdir -p $LIBNAME

BUILD_PREFIX=`pwd`/$LIBNAME
BUILD_INCLUDEDIR=`pwd`/$1/include
BUILD_LIBDIR=`pwd`/$1/lib
BUILD_BINDIR=`pwd`/$1/bin
BUILD_PKGCONFIG=`pwd`/$1/lib/pkgconfig

cd $LIBNAME

NDKP=$2
TARGET=$3

../../src/$LIBNAME/configure \
	CC=$NDKPATH/$NDKP-clang \
	CXX=$NDKPATH/$NDKP-clang++ \
	CFLAGS="-Os -fPIC" \
	CPPFLAGS="-I$BUILD_INCLUDEDIR" \
	LDFLAGS="-L$BUILD_LIBDIR" \
	PKG_CONFIG_PATH="$BUILD_PKGCONFIG" \
	--host=$TARGET \
	--includedir=$BUILD_INCLUDEDIR \
	--libdir=$BUILD_LIBDIR \
	--prefix=$BUILD_PREFIX \
	--with-pic=yes \
	--enable-static=yes \
	--enable-shared=no \
	--disable-valgrind-tests \
	--enable-gtk-doc-html=no \
	--disable-dependency-tracking \
	--disable-ld-version-script \
	--disable-doc \
	--disable-rpath

# Prevent symver, or shared library builds (e.g. serenity) will fail
sed -i -e 's/#define HAVE_SYMVER_ALIAS_SUPPORT 1//g' config.h

make
make install

cd -
rm -rf $LIBNAME

$NDKPATH/llvm-ar d $BUILD_LIBDIR/libidn2.a cloexec.o dup2.o fcntl.o getdelim.o \
	getdtablesize.o getline.o malloca.o stat-time.o strverscmp.o

}

Compile armeabi-v7a	armv7a-linux-androideabi19	armv7a-linux-androideabi
Compile	x86			i686-linux-android19		i686-linux-android
Compile	arm64-v8a	aarch64-linux-android21		aarch64-linux-android
Compile	x86_64		x86_64-linux-android21		x86_64-linux-android
