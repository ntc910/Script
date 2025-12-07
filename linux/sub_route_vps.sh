VNPT nha
admin
Vnpt123@

  1     1 ms     2 ms     1 ms  XiaoQiang [192.168.10.1]
  2     3 ms     1 ms     1 ms  192.168.1.1
  3    11 ms     4 ms     3 ms  static.vnpt.vn [123.29.4.43]
  4     5 ms     7 ms     4 ms  static.vnpt.vn [113.171.36.169]
  5     *        *        *     Request timed out.
  6    11 ms     6 ms     7 ms  static.vnpt.vn [113.171.35.83]
  7    25 ms    22 ms    23 ms  static.vnpt.vn [113.171.37.91]
  8     *       25 ms     *     103.22.203.242
  9    25 ms    25 ms    25 ms  103.22.203.227
 10    24 ms    23 ms    24 ms  one.one.one.one [1.1.1.1]

 Tracing route to 45.124.94.196 over a maximum of 30 hops

  1    <1 ms     1 ms    <1 ms  192.168.1.1
  2    23 ms    30 ms     4 ms  100.123.0.149
  3    10 ms     *       15 ms  42.112.2.241
  4     2 ms     2 ms     1 ms  100.123.0.167
  5     5 ms     *        2 ms  42.112.0.91
  6     *        2 ms    10 ms  113.22.4.110
  7    14 ms     2 ms     4 ms  static.vnpt.vn [123.29.16.73]
  8     3 ms     *        3 ms  static.vnpt.vn [113.171.5.9]
  9     3 ms     3 ms     2 ms  static.vnpt.vn [113.171.27.126]
 10    52 ms    44 ms    11 ms  static.vnpt.vn [113.171.35.45]
 11     2 ms     2 ms     2 ms  dynamic.vnpt.vn [123.30.232.219]
 12     2 ms     2 ms     2 ms  45.124.94.196

   1    <1 ms     1 ms    <1 ms  192.168.1.1
  2    18 ms     1 ms     4 ms  100.123.0.149
  3     3 ms     *        3 ms  42.112.2.241
  4     3 ms     2 ms     2 ms  100.123.0.167
  5    14 ms    13 ms     3 ms  42.112.0.91
  6     *        *        2 ms  113.22.4.110
  7     3 ms     4 ms     3 ms  203.113.158.105
  8     *        3 ms     5 ms  CUONG-PREDATOR [27.68.228.25]
  9     2 ms     3 ms     3 ms  CUONG-PREDATOR [27.68.194.177]
 10     5 ms     4 ms     4 ms  dynamic-ip-adsl.viettel.vn [116.104.81.226]
 11     8 ms     7 ms     5 ms  dynamic-ip-adsl.viettel.vn [171.245.111.222]

ssh root@45.124.94.196

ssh ntc@192.168.1.99

103.69.193.1
18.142.227.62
171.245.111.222        # nha chi Quy

"app_custom_address": {
    "value": "18.142.227.62"
},

"app_custom_address": {
    "value": "100.64.0.3"
},

"app_custom_address": {
    "value": "45.124.94.196"
},

"app_custom_address": {
    "value": "100.64.0.3"
},

#install zerotier
https://www.zerotier.com/download/

curl -s https://install.zerotier.com | sudo bash

zerotier-cli join 1d71939404493e63


#
sudo sysctl -w net.ipv4.ip_forward=1

export PHY_IFACE=eth0
export ZT_IFACE=ztkse36uxh

sudo iptables -t nat -A POSTROUTING -o $PHY_IFACE -j MASQUERADE
sudo iptables -A FORWARD -i $PHY_IFACE -o $ZT_IFACE -m state --state RELATED,ESTABLISHED -j ACCEPT
sudo iptables -A FORWARD -i $ZT_IFACE -o $PHY_IFACE -j ACCEPT

sudo apt install iptables-persistent
sudo bash -c iptables-save > /etc/iptables/rules.v4

# open port
netstat -lntu

sudo iptables -t nat -A PREROUTING -p udp --dport 9001 -j DNAT --to-destination 1.53.37.230:9001
sudo iptables -A FORWARD -p udp -d 1.53.37.230 --dport 9001 -m state --state NEW,ESTABLISHED,RELATED -j ACCEPT


sudo iptables -A INPUT -p udp --dport 9001 -j ACCEPT
sudo iptables -A INPUT -p tcp --dport 9001 -j ACCEPT

iptables -A INPUT -p tcp --dport 9001 -j ACCEPT
iptables -A INPUT -p udp --dport 9001 -j ACCEPT

iptables -A INPUT -p tcp --dport 9001 -j ACCEPT
iptables -A INPUT -p tcp --dport 9001 -j ACCEPT

sudo ufw allow 9001/udp
sudo ufw allow 9001/tcp

sysctl -w net.ipv4.ip_forward=1


./udpfwd 27.67.73.75 9993 1.53.37.230 9993
./udpfwd 1.53.37.230 9993 27.67.73.75 9993 

103.69.193.2
45.32.227.204

45.124.94.196

iptables -A INPUT -p tcp --dport <port number> -j ACCEPT

sudo nmap -sT -p- 45.124.94.196

#######################################################################
sudo apt-get install tailscale

echo 'net.ipv4.ip_forward = 1' | sudo tee -a /etc/sysctl.d/99-tailscale.conf
echo 'net.ipv6.conf.all.forwarding = 1' | sudo tee -a /etc/sysctl.d/99-tailscale.conf
sudo sysctl -p /etc/sysctl.d/99-tailscale.conf

echo 'net.ipv4.ip_forward = 1' | tee -a /etc/sysctl.d/99-tailscale.conf
echo 'net.ipv6.conf.all.forwarding = 1' | tee -a /etc/sysctl.d/99-tailscale.conf
sysctl -p /etc/sysctl.d/99-tailscale.conf

p

# udp gro
NETDEV=$(ip -o route get 8.8.8.8 | cut -f 5 -d " ")
sudo ethtool -K $NETDEV rx-udp-gro-forwarding on rx-gro-list off

printf '#!/bin/sh\n\nethtool -K %s rx-udp-gro-forwarding on rx-gro-list off \n' "$(ip -o route get 8.8.8.8 | cut -f 5 -d " ")" | sudo tee /etc/networkd-dispatcher/routable.d/50-tailscale
sudo chmod 755 /etc/networkd-dispatcher/routable.d/50-tailscale

sudo /etc/networkd-dispatcher/routable.d/50-tailscale
test $? -eq 0 || echo 'An error occurred.'

sudo tailscale up --advertise-routes=192.168.2.0/24  --advertise-exit-node --accept-routes=true

sudo tailscale up --advertise-routes=192.168.2.0/24 --accept-routes=true

sudo tailscale up --advertise-exit-node --accept-routes=true

--advertise-exit-node
# setup route

###############################

sudo iptables -t nat -A PREROUTING -p tcp --dport 9001 -j DNAT --to-destination  1.53.37.230:61191
sudo iptables -A FORWARD -p tcp -d  1.53.37.230 --dport 9001 -j ACCEPT
sudo iptables -A INPUT -p tcp --dport <port_number> -j ACCEPT


sudo apt install iptables-persistent
sudo netfilter-persistent save



NETDEV=$(ip -o route get 8.8.8.8 | cut -f 5 -d " ")
ethtool -K $NETDEV rx-udp-gro-forwarding on rx-gro-list off

printf '#!/bin/sh\n\nethtool -K %s rx-udp-gro-forwarding on rx-gro-list off \n' "$(ip -o route get 8.8.8.8 | cut -f 5 -d " ")" | tee /etc/networkd-dispatcher/routable.d/50-tailscale
chmod 755 /etc/networkd-dispatcher/routable.d/50-tailscale

/etc/networkd-dispatcher/routable.d/50-tailscale
test $? -eq 0 || echo 'An error occurred.'

sudo tailscale up --advertise-exit-node --advertise-routes=100.64.0.0/10 

***

sudo apt update
sudo apt install socat

sudo socat UDP4-RECVFROM:9001,fork UDP4-SENDTO:1.53.37.230:61191


sudo nano /etc/systemd/system/socat-udp.service

[Unit]
Description=Socat UDP Port Forwarding

[Service]
ExecStart=/usr/bin/socat UDP4-RECVFROM:9001,fork UDP4-SENDTO:1.53.37.230:61191
Restart=always

[Install]
WantedBy=multi-user.target


sudo systemctl daemon-reload
sudo systemctl start socat-udp.service
sudo systemctl enable socat-udp.service

socat udp-listen:9001,reuseaddr,fork udp:1.53.37.230:61191
***

sudo zerotier-cli join db64858fed3add0a

sudo iptables -t nat -A POSTROUTING -o eth0 -j MASQUERADE
sudo iptables -A FORWARD -m conntrack --ctstate RELATED,ESTABLISHED -j ACCEPT
sudo iptables -A FORWARD -i zt0 -o eth0 -j ACCEPT
sudo iptables -A FORWARD -i eth0 -o zt0 -j ACCEPT


sudo apt install lxde-core

832XmRqk2jQUG3t86JV2cM3


sudo iptables -t nat -A POSTROUTING -o $PHY_IFACE -j MASQUERADE
sudo iptables -A FORWARD -i $ZT_IFACE -o $PHY_IFACE -j ACCEPT
sudo iptables -A FORWARD -i $PHY_IFACE -o $ZT_IFACE -m state --state RELATED,ESTABLISHED -j ACCEPT

sudo apt install iptables-persistent
sudo bash -c iptables-save > /etc/iptables/rules.v4

curl -fsSL https://pkgs.tailscale.com/stable/ubuntu/oracular.noarmor.gpg | sudo tee /usr/share/keyrings/tailscale-archive-keyring.gpg >/dev/null
curl -fsSL https://pkgs.tailscale.com/stable/ubuntu/oracular.tailscale-keyring.list | sudo tee /etc/apt/sources.list.d/tailscale.list


curl -fsSL https://pkgs.tailscale.com/stable/ubuntu/lunar.noarmor.gpg | sudo tee /usr/share/keyrings/tailscale-archive-keyring.gpg >/dev/null
curl -fsSL https://pkgs.tailscale.com/stable/ubuntu/lunar.tailscale-keyring.list | sudo tee /etc/apt/sources.list.d/tailscale.list


sudo apt-get install tailscale
sudo apt install tailscale

27.68.228.26
1.53.123.84

thanhcuong2k@gmail.com
Cuong@12021007


curl -fsSL https://pkgs.tailscale.com/stable/ubuntu/jammy.noarmor.gpg | tee /usr/share/keyrings/tailscale-archive-keyring.gpg >/dev/null
curl -fsSL https://pkgs.tailscale.com/stable/ubuntu/jammy.tailscale-keyring.list | tee /etc/apt/sources.list.d/tailscale.list
