#!/bin/sh
set -e -x
rm -rf temp
mkdir temp
pushd temp
wget https://mirrors.tuna.tsinghua.edu.cn/alpine/latest-stable/main/aarch64/busybox-static-1.37.0-r18.apk
mkdir busybox
pushd busybox
tar xvf ../busybox-static-1.37.0-r18.apk
popd
/Applications/DevEco-Studio.app/Contents/sdk/default/openharmony/toolchains/hnpcli pack -i busybox -n busybox -v 1.37.0

cp *.hnp ../entry/hnp/arm64-v8a/