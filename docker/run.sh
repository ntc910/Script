# export DONT_PROMPT_WSL_INSTALL=1
# export LD_LIBRARY_PATH=./libs:/usr/lib/x86_64-linux-gnu

# export XKB_CONFIG_ROOT=./xkb

mkdir -p ~/.local
rm -r ~/.local/
cp -r ./usr ~/.local

export PATH="$HOME/.local/bin:$PATH"
export LD_LIBRARY_PATH="$HOME/.local/lib:$LD_LIBRARY_PATH"
export XKB_CONFIG_ROOT="$HOME/.local/share/X11/xkb"
export FONTCONFIG_PATH="$HOME/.local/share/fonts"

export XFILESEARCHPATH="$HOME/.local/share/X11/%L/%T/%N%C%S"
export XAPPLRESDIR="$HOME/.local/share/X11/app-defaults"

ln -s "$HOME/.local/lib/libxkbcommon-x11.so.0.0.0" "$HOME/.local/lib/libxkbcommon-x11.so.0"
ln -s "$HOME/.local/lib/libXfont2.so.2.0.0" "$HOME/.local/lib/libXfont2.so.2"
ln -s "$HOME/.local/lib/libxkbcommon.so.0.0.0" "$HOME/.local/lib/libxkbcommon.so.0"
ln -s "$HOME/.local/lib/libpixman-1.so.0.0.0" "$HOME/.local/lib/libpixman-1.so.0 "

ln -s "$HOME/.local/lib/libX11-xcb.so.1.0.0" "$HOME/.local/lib/libX11-xcb.so.1"
ln -s "$HOME/.local/lib/libX11.so.6.4.0" "$HOME/.local/lib/libX11.so"
ln -s "$HOME/.local/lib/libX11.so.6.4.0" "$HOME/.local/lib/libX11.so.6"
ln -s "$HOME/.local/lib/libXfont2.so.2.0.0" "$HOME/.local/lib/libXfont2.so.2"

ldconfig -n ~/.local/lib
# fc-cache -fv ~/.local/share/fonts

mkdir -p /tmp/.X11-unix
chmod 1777 /tmp/.X11-unix

# setxkbmap -model pc104 -layout us -option ""
eval "$(dbus-launch --sh-syntax)"
Xvfb :1 -screen 0 1024x768x24 -ac -noreset
export DISPLAY=:1

#./VSCode-linux-x64/bin/code --no-sandbox --verbose --user-data-dir ./
