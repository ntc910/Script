

ca-certificates

openssl

wget

gpg

locale

select vdisk file="D:\WSL2\ext4.vhdx"
attach vdisk readonly
compact vdisk
detach vdisk
exit

# setup 2
wsl --import debian-gui D:/WSL2 D:\Download\Compressed\debian.unstable-slim-080420260230.tar



sudo apt update && sudo apt upgrade -y
sudo apt install -y build-essential procps curl file git

sudo apt install -y wget gpg dnsutils iputils-ping

sudo apt install locales

sudo dpkg-reconfigure locales

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