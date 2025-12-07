export DONT_PROMPT_WSL_INSTALL=1
export LD_LIBRARY_PATH=./libs:/usr/lib/x86_64-linux-gnu
export PATH=$PATH:./bin

export XKB_CONFIG_ROOT=./xkb

eval "$(dbus-launch --sh-syntax)"

 fc-cache -fv
Xvfb :9 -screen 0 1920x1080x24 
export DISPLAY=:9

x11vnc -display :9

#./VSCode-linux-x64/bin/code --no-sandbox --verbose --user-data-dir ./
