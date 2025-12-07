# Script SSH Tự Động Kết Nối Lại

Script `auto_ssh_reconnect.sh` giúp duy trì kết nối SSH đến máy chủ từ Termux trên Android, tự động kết nối lại khi bị ngắt kết nối.

## Cách Sử Dụng

### 1. Sao chép script vào Termux
Chuyển file `auto_ssh_reconnect.sh` vào thư mục Termux trên điện thoại Android của bạn.

### 2. Đặt quyền thực thi (trong Termux)
```bash
chmod +x auto_ssh_reconnect.sh
```

### 3. Chạy script
```bash
# Cú pháp cơ bản
./auto_ssh_reconnect.sh <user> <host> [port] [key_file]

# Ví dụ:
./auto_ssh_reconnect.sh user 192.168.1.100
./auto_ssh_reconnect.sh user example.com 2222
./auto_ssh_reconnect.sh user 192.168.1.100 22 ~/.ssh/id_rsa
```

## Các Tùy Chọn

- `user`: Tên người dùng SSH trên máy chủ
- `host`: Địa chỉ IP hoặc hostname của máy chủ
- `port`: Cổng SSH (mặc định là 22 nếu không chỉ định)
- `key_file`: Đường dẫn đến file khóa riêng tư (tùy chọn)

## Tính Năng

1. **Tự động kết nối lại**: Khi kết nối SSH bị ngắt, script sẽ tự động thử kết nối lại sau mỗi 5 giây.
2. **Duy trì kết nối**: Sử dụng các tùy chọn `ServerAliveInterval` và `ServerAliveCountMax` để phát hiện và xử lý kết nối bị treo.
3. **Linh hoạt**: Hỗ trợ cả xác thực bằng mật khẩu và khóa riêng tư.

## Các Tùy Chọn SSH

Script sử dụng các tùy chọn sau để duy trì kết nối ổn định:

- `-o ServerAliveInterval=60`: Gửi gói tin keepalive mỗi 60 giây
- `-o ServerAliveCountMax=3`: Số lần thử keepalive tối đa trước khi ngắt kết nối
- `-o StrictHostKeyChecking=no`: Bỏ qua kiểm tra host key (chỉ để thuận tiện, trong thực tế nên bật)

## Dừng Script

Để dừng hoàn toàn script, nhấn `Ctrl+C`.

## Yêu Cầu

- Đã cài đặt Termux trên Android
- Đã cài đặt OpenSSH client trong Termux (`pkg install openssh`)
- Có kết nối mạng đến máy chủ SSH
