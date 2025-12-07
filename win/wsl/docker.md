# Build with proxy
```sh
 sudo docker build \
  --build-arg HTTP_PROXY=${http_proxy} \
  --build-arg HTTPS_PROXY=${https_proxy} \
  -t ub22 .
```

# Restart
```sh
sudo systemctl daemon-reload
sudo systemctl restart docker
sudo mkdir -p /etc/systemd/system/docker.service.d
sudo vim /etc/systemd/system/docker.service.d/http-proxy.conf
```

# Install from files
```sh
#!/bin/bash
sudo dpkg -i ./containerd.io_*.deb \
  ./docker-ce_*.deb \
  ./docker-ce-cli_*.deb \
  ./docker-buildx-plugin_*.deb \
  ./docker-compose-plugin_*.deb
```