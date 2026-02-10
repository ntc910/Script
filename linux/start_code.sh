export DONT_PROMPT_WSL_INSTALL=1
export LD_LIBRARY_PATH=./libs:/usr/lib/x86_64-linux-gnu


export XKB_CONFIG_ROOT=/app/Docker/xkb

eval "$(dbus-launch --sh-syntax)"

./Xvfb :1 -screen 0 1024x768x24 
export DISPLAY=:1

#./VSCode-linux-x64/bin/code --no-sandbox --verbose --user-data-dir ./