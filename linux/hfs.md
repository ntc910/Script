sudo vim /etc/systemd/system/hfs.service

[Unit]
Description=HFS Rejetto Service
After=network.target

[Service]
User=ntc
WorkingDirectory=/home/ntc/
ExecStart=/usr/local/bin/hfs
Restart=always

[Install]
WantedBy=multi-user.target


sudo systemctl daemon-reload
sudo systemctl enable hfs
sudo systemctl start hfs
sudo systemctl status hfs
