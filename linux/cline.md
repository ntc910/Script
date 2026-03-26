# Setup
cline auth -p gemini -k <key> -m gemini-3-flash-preview

# 2 Operation mode
1. Interactive mode
2. Headless Mode

# 2. Headless Mode
## YOLO mode
```sh
cline -y "message"
```
All actions are auto-approved
Output is plain text (non-interactive)
Process exits automatically when complete
Perfect for CI/CD and scripts

## Plan mode
```sh
cline -y -p
```

## Act mode
```sh
cline -y -a
```

## Include Image
```sh
cline -y -i image.png "message"
```

## Timeout Control
```sh
cline -y --timeout 600 "message"
```

## CI/CD

# Call from powershell to WSL
sudo ln -s $(which node) /usr/bin/node