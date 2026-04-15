# Force over proxy

## Config ssh
```sh
sudo apt install netcat-openbsd

vim .ssh/config
```

```
Host ssh.dev.azure.com
    Hostname ssh.dev.azure.com
    Port 22
    User git
    ProxyCommand nc -X connect -x 107.98.150.183:3333 %h %p

Host github.com
    Hostname github.com
    Port 22
    User git
    ProxyCommand nc -X connect -x 107.98.150.183:3333 %h %p
```
## Stop non proxy traffic

```
Host github.com
    HostName 127.0.0.1
    Port 1
    User git
Host ssh.dev.azure.com
    HostName 127.0.0.1
    Port 1
    User git
```

## 2nd way
sudo nano /etc/hosts

127.0.0.1  ssh.dev.azure.com


