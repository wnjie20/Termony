#!/bin/sh
set -e -x
mkdir -p temp
pushd temp

rm -rf busybox
wget -c https://mirrors.tuna.tsinghua.edu.cn/alpine/latest-stable/main/aarch64/busybox-static-1.37.0-r18.apk
mkdir busybox
pushd busybox
tar xvf ../busybox-static-1.37.0-r18.apk
popd
/Applications/DevEco-Studio.app/Contents/sdk/default/openharmony/toolchains/hnpcli pack -i busybox -n busybox -v 1.37.0

wget -c https://mirrors.tuna.tsinghua.edu.cn/gnu/bash/bash-5.2.37.tar.gz
rm -rf bash
rm -rf bash-source
mkdir bash-source
pushd bash-source
tar xvf ../bash-5.2.37.tar.gz
cd bash-5.2.37
mkdir build
cd build
../configure --host aarch64-unknown-linux-musl --disable-readline --without-bash-malloc CC=/Applications/DevEco-Studio.app/Contents//sdk/default/openharmony/native/llvm/bin/aarch64-unknown-linux-ohos-clang --prefix=/
make -j $(nproc)
make install DESTDIR=$PWD/../../../bash
popd
/Applications/DevEco-Studio.app/Contents/sdk/default/openharmony/toolchains/hnpcli pack -i bash -n bash -v 5.2.37

rm -f ../entry/hnp/arm64-v8a/*.hnp
cp *.hnp ../entry/hnp/arm64-v8a/