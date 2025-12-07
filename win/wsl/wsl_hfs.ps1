# Danh sách các cổng cần chuyển tiếp
$ports = @(8080)

# Lấy địa chỉ IP của WSL
$wslIp = wsl -- ip -4 addr show eth0 | Select-String -Pattern 'inet\s+(\d+\.\d+\.\d+\.\d+)' | ForEach-Object { $_.Matches.Groups[1].Value }

if (-not $wslIp) {
    Write-Host "Không thể lấy địa chỉ IP của WSL. Vui lòng kiểm tra WSL đang chạy."
    exit
}

Write-Host "Địa chỉ IP của WSL: $wslIp"

# Lặp qua từng cổng
foreach ($port in $ports) {
    # Xóa portproxy cũ (nếu có)
    netsh interface portproxy delete v4tov4 listenport=$port listenaddress=0.0.0.0
    
    # Thêm portproxy mới với IP của WSL
    netsh interface portproxy add v4tov4 listenport=$port listenaddress=0.0.0.0 connectport=$port connectaddress=$wslIp
    
    Write-Host "Đã cấu hình chuyển tiếp cổng $port tới $wslIp"
}