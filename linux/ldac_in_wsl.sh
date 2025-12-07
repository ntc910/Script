# Cài đặt usbipd-win từ GitHub hoặc sử dụng công cụ cài đặt thích hợp.


sudo add-apt-repository ppa:git-core/ppa
sudo apt-get update
sudo apt-get install usbip

# win shell
usbipd list
usbipd bind --busid=<bus_id>
usbipd attach --wsl --busid=<bus_id>


sudo apt install pulseaudio
sudo apt install usbutils
sudo apt install linux-tools-virtual hwdata

sudo service bluetooth start

#


wsl --export Ubuntu-24.04 D:/wsl-usbip.tar

https://github.com/dorssel/usbipd-win/wiki/WSL-support#building-your-own-usbip-enabled-wsl-2-kernel

wsl --distribution wsl2-usbip --user ntc

sudo apt install build-essential flex bison libssl-dev libelf-dev libncurses-dev autoconf libudev-dev libtool

git clone https://github.com/microsoft/WSL2-Linux-Kernel.git
# better download outside with IDM etc
# then use tar -xpvf *.gz