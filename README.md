# Termony

Termux for HarmonyOS Computer. Working in Progress.

It can run busybox.static on Huawei MateBook Pro now:

![](./screenshot.jpg)

Usage:

1. Connect your MateBook Pro to Mac, and do the following steps on Mac
2. Setup code signing in DevEco-Studio
3. Run `./create-hnp.sh` to create hnp package from alpine busybox-static package
4. Run `./build-macos.sh`
5. Run `./push.sh ./entry/build/default/outputs/default/entry-default-signed.hap`
6. Input command in the text input of the application, press enter
