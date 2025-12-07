# 1. Get the docker from

https://hub.docker.com/r/linuxserver/code-server

# Guides

docker run -d \
  --name=code-server \
  -e PUID=1000 \
  -e PGID=1000 \
  -e TZ=Etc/UTC \
  -e PASSWORD=password `#optional` \
  -e HASHED_PASSWORD= `#optional` \
  -e SUDO_PASSWORD=password `#optional` \
  -e SUDO_PASSWORD_HASH= `#optional` \
  -e PROXY_DOMAIN=code-server.my.domain `#optional` \
  -e DEFAULT_WORKSPACE=/config/workspace `#optional` \
  -e PWA_APPNAME=code-server `#optional` \
  -p 8443:8443 \
  -v /path/to/code-server/config:/config \
  --restart unless-stopped \
  lscr.io/linuxserver/code-server:latest


docker run -d \
  --name code-server \
  -e PUID=1000 \
  -e PGID=1000 \
  -e TZ=Asia/Ho_Chi_Minh \
  -e PASSWORD=your_strong_password_here \    # mật khẩu bạn muốn (hoặc bỏ dòng này để dùng token ngẫu nhiên)
  -e SUDO_PASSWORD=your_strong_password_here \ # mật khẩu sudo bên trong (có thể giống trên)
  -p 8686:8443 \                              # truy cập qua http://IP_CUA_MAY:8443
  --restart unless-stopped \
  lscr.io/linuxserver/code-server:latest


```sh
docker run -d \
--network host \
--name code-server \
-e PUID=1000 \
-e PGID=1000 \
-e TZ=Asia/Ho_Chi_Minh \
-e PASSWORD=1234 \
-e SUDO_PASSWORD=1234 \
--restart unless-stopped \
linuxserver/code-server:latest


socat TCP-LISTEN:8443,fork TCP:127.0.0.1:8686
```

```sh
docker run -d --name code-server -e PUID=1000 -e PGID=1000 -e TZ=Asia/Ho_Chi_Minh -e PASSWORD=1234 -e SUDO_PASSWORD=1234 --restart unless-stopped lscr.io/linuxserver/code-server:latest
```


```sh
sudo docker stop code-server
sudo docker rm code-server
```


```powershell
New-NetFirewallRule -DisplayName "code-server 8443" -Direction Inbound -Protocol TCP -LocalPort 8443 -Action Allow

## Need setting in WSL setting
```

```sh
# file at 
/config/Documents/Cline/Workflows/
```



# 
docker build -t my-codeserver-with-extensions .

