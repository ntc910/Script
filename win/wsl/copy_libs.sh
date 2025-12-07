WORKDIR=/home/ntc/Docker/libs

packages=(
  libpixman-1-0
  libunwind8
  libxfont2
  x11-xkb-utils
  xfonts-base
  xfonts-encodings
  xfonts-utils
  xkb-data
  xserver-common


  libs/libcairo-gobject.so.2 libs/libcairo.so.2 libs/libdatrie.so.1 libs/libepoxy.so.0 libs/libgdk_pixbuf-2.0.so.0 libs/libgdk-3.so.0 libs/libgtk-3.so.0 libs/libpango-1.0.so.0 libs/libpangocairo-1.0.so.0 libs/libpangoft2-1.0.so.0 libs/libpixman-1.so.0 libs/libthai.so.0 libs/libunwind.so.8 libs/libwayland-cursor.so.0 libs/libwayland-egl.so.1 libs/libxcb-render.so.0 libs/libXcursor.so.1 libs/libXdamage.so.1 libs/libXfont2.so.2 libs/libxkbcommon-x11.so.0 libs/libxkbcommon-x11.so.0.0.0 libs/libxkbcommon.so.0 libs/libxkbcommon.so.0.0.0
)

for pkg in "${packages[@]}"; do
  echo "Copying files for package: $pkg"
  dpkg -L "$pkg" | grep -E '\.so|/usr/share' | while read file; do
    if [ -f "$file" ]; then
      cp --parents "$file" "$WORKDIR"
    fi
  done
done
