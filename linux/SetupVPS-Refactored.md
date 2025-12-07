# Low-Latency Game Streaming with VPS Relay

A concise guide to setup Parsec and Moonlight with Tailscale using a VPS as relay server to reduce latency and bypass port forwarding restrictions.

## 🎯 When to Use This Guide

- You need to setup game streaming without router access
- You're experiencing Parsec error 6023
- You can't configure port forwarding on your network
- You want to reduce latency for remote gaming
- You can afford ~$1-2/month for a VPS

## 📋 Prerequisites

- Host PC (gaming machine)
- Client PC (where you'll play)
- VPS with public IP (Ubuntu recommended)
- Tailscale, Parsec, and/or Moonlight installed on all devices

## 🚀 Quick Setup

### 1. Install Required Software

Install on **both host and client**:
- [Tailscale](https://tailscale.com/kb/1347/installation)
- [Parsec](https://parsec.app/downloads)
- [Moonlight](https://github.com/moonlight-stream/moonlight-docs/wiki/Setup-Guide)

### 2. Configure Parsec for Tailscale

1. Close Parsec completely
2. Edit config file: `%AppData%\Parsec\config.json`
3. Add this configuration:
```json
"app_custom_address": {
    "value": "<host-tailscale-ip>"
}
```
4. Restart Parsec

**Note:** Remove this config to revert to normal Parsec connections.

### 3. Configure Moonlight

Simply add the host PC using its Tailscale IP address.

## 🖥️ VPS Setup

### Choose VPS Provider

- Select a server in your country/city for lowest ping
- Minimum specs: 1 CPU, 1GB RAM, 100Mbps bandwidth
- Ubuntu OS recommended

### Initial VPS Configuration

```bash
# Update system
sudo apt update && sudo apt upgrade -y

# Install Tailscale
curl -fsSL https://tailscale.com/install.sh | sh

# Start Tailscale
sudo tailscale up

# Check connection
sudo tailscale status
```

### Enable IP Forwarding

```bash
# Enable port forwarding
sudo nano /etc/sysctl.conf
# Uncomment: net.ipv4.ip_forward=1

# Apply changes
sudo sysctl -p

# Install persistent iptables
sudo apt install netfilter-persistent iptables-persistent -y
```

## 🔌 Port Forwarding Setup

### For Parsec (Single Port)

```bash
# Forward port 9000 to host PC
sudo iptables -t nat -A PREROUTING -p udp --dport 9000 -j DNAT --to-destination <host-tailscale-ip>:9000
```

### For Moonlight (Multiple Ports)

```bash
# TCP ports
sudo iptables -t nat -A PREROUTING -p tcp --dport 47984 -j DNAT --to-destination <host-tailscale-ip>:47984
sudo iptables -t nat -A PREROUTING -p tcp --dport 47989 -j DNAT --to-destination <host-tailscale-ip>:47989
sudo iptables -t nat -A PREROUTING -p tcp --dport 48010 -j DNAT --to-destination <host-tailscale-ip>:48010

# UDP ports
sudo iptables -t nat -A PREROUTING -p udp --dport 47998 -j DNAT --to-destination <host-tailscale-ip>:47998
sudo iptables -t nat -A PREROUTING -p udp --dport 47999 -j DNAT --to-destination <host-tailscale-ip>:47999
sudo iptables -t nat -A PREROUTING -p udp --dport 48000 -j DNAT --to-destination <host-tailscale-ip>:48000
sudo iptables -t nat -A PREROUTING -p udp --dport 48002 -j DNAT --to-destination <host-tailscale-ip>:48002
sudo iptables -t nat -A PREROUTING -p udp --dport 48010 -j DNAT --to-destination <host-tailscale-ip>:48010
```

### Save Configuration

```bash
# Save and reload iptables rules
sudo netfilter-persistent save && sudo netfilter-persistent reload

# Verify rules
sudo iptables-save
```

## 🎮 Final Configuration

### Parsec Settings
- **Host PC:** Set "Host Start Port" to `9000`
- **Client PC:** Set "Client Port" to `9000`
- **Both:** Update Parsec config to use VPS Tailscale IP

### Moonlight Settings
- Add new computer using VPS Tailscale IP
- Or use VPS public IP (client doesn't need Tailscale)

## 📊 Expected Results

Before VPS relay:
```
Host PC ↔ Client PC: ~100ms (high latency)
```

After VPS relay:
```
Host PC ↔ VPS: ~4ms
VPS ↔ Client PC: ~4ms
Total: ~8ms (much better!)
```

## 🔧 Troubleshooting

- **Connection Issues:** Verify all devices are connected to Tailscale
- **High Latency:** Choose VPS closer to your physical location
- **Port Errors:** Check iptables rules with `sudo iptables-save`
- **Parsec 6023 Error:** Ensure Tailscale IP is correctly configured in Parsec settings

## 💡 Pro Tips

- Test ping between all devices before starting game streaming
- Use VPS public IP to avoid installing Tailscale on client devices
- Monitor VPS bandwidth usage if you have data limits
- Consider automated scripts for iptables rule persistence

---

**Happy Gaming! 🎮**
