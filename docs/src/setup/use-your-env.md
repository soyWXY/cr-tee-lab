# 使用自己的環境

因為我們目前只有在Ubuntu 22.04 LTS上測試過，所以如果在其它發行版上執行，可能會有些許差異。

## 1. 安裝依賴

```bash
sudo apt update && apt upgrade -y
sudo apt install -y adb acpica-tools autoconf automake bc bison build-essential ccache cpio cscope curl device-tree-compiler e2tools expect fastboot flex ftp-upload gdisk git libattr1-dev libcap-ng-dev libfdt-dev libftdi-dev libglib2.0-dev libgmp3-dev libhidapi-dev libmpc-dev libncurses5-dev libpixman-1-dev libslirp-dev libssl-dev libtool libusb-1.0-0-dev make mtools netcat ninja-build python3-cryptography python3-pip python3-pyelftools python3-serial python3-tomli python-is-python3 rsync swig unzip uuid-dev wget xdg-utils xsltproc xterm xz-utils zlib1g-dev
sudo curl https://storage.googleapis.com/git-repo-downloads/repo > /bin/repo && chmod a+x /bin/repo
```
- 註: 這裡安裝的`repo`是一個命令列工具，它使用 python 封裝 git，用來管理 polyrepo 的專案

## 2. 下載 OP-TEE專案的source code
```bash
mkdir optee
cd optee
repo init -u https://github.com/NTHU-SCOPELAB/cr-tee-manifest.git -m qemu_v8.xml
repo sync -j$(nproc)
```
