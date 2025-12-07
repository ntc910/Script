```sh
scrcpy.exe --turn-screen-off \
--stay-awake \
--mouse=uhid \
 -K \
 --keyboard=uhid \
 --video-bit-rate=10M \
 --audio-codec=raw \
 --print-fps \
 --pause-on-exit=if-error %* \
 --video-codec=h265

```


scrcpy.exe --serial=tlyjcam.localto.net:7757 --turn-screen-off --stay-awake --max-fps=60 --mouse-bind=++++  -K --keyboard=uhid --video-bit-rate=20M --audio-codec=raw --print-fps --pause-on-exit=if-error %* --video-codec=h264


scrcpy --video-bit-rate=20M --audio-codec=raw --print-fps --max-fps=120