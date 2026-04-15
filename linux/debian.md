

# Base setup

This is setup for WSL2. Run some GUI app.

## 1. Import rootfs
Download from [here](https://github.com/mvaisakh/wsl-distro-tars)

```sh
wsl --import debian-gui D:\WSL\debian-gui/ D:\Download\Compressed\debian.stable-slim-150420260234.tar
```

## 2. Install common software
Login to distro
```sh
wsl -d debian-gui
```


Update
```sh
apt update && apt upgrade -y
```
Set password for root

```sh
passwd
```

Currently, user is `root`. Create new one

```sh
apt install sudo -y

useradd -m -s /bin/bash user
passwd user
usermod -aG sudo user
su user
```

Now you can update with new user
```sh
sudo apt update && sudo apt upgrade -y

```

Fix locales and install software for my developemnt
```sh
sudo apt install -y build-essential procps curl git wget gpg dnsutils locales
sudo dpkg-reconfigure locales
```

## 3. Install GUI apps


### 3.1 P4V
Download the latest version for linux and copy to `opt` <br>
Link `p4v` to bin. NOTE: version may different

```sh
sudo ln -s /opt/p4v-2026.1.2913202/bin/p4v /usr/local/bin/p4v
```
Install require package
```sh
sudo apt install libqt6gui6 libnss3 libxkbfile1
```



---


## TEMP

### Fix bad theme

### 3.0 GPU

```sh
sudo apt install libgl1-mesa-dri mesa-utils

export GALLIUM_DRIVER=d3d12

export MESA_D3D12_DEFAULT_ADAPTER_NAME=NVIDIA
```



```
file
iputils-ping
ca-certificates
openssl
locale

select vdisk file="D:\WSL2\ext4.vhdx"
attach vdisk readonly
compact vdisk
detach vdisk
exit

```


# p4v
sudo apt install libqt6gui6 libnss3 libxkbfile1

OK

// optimize
sudo apt install -y libgl1-mesa-dri mesa-utils

# edge

sudo apt install software-properties-common apt-transport-https curl ca-certificates


# GWSL
sudo apt update
sudo apt install iproute2 net-tools -y

.profile
export DISPLAY=$(ip route | grep default | awk '{print $3; exit;}'):0.0


## HW acceleraoin

'export GALLIUM_DRIVER=d3d12'

'export MESA_D3D12_DEFAULT_ADAPTER_NAME=NVIDIA'