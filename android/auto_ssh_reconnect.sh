#!/data/data/com.termux/files/usr/bin/bash

# Script SSH tự động kết nối lại khi bị ngắt kết nối
# Sử dụng trong Termux trên Android

# Cấu hình
HOST=""        # Địa chỉ IP hoặc hostname của máy chủ
USER=""        # Tên người dùng SSH
PORT="22"      # Cổng SSH (mặc định là 22)
KEY_FILE=""    # Đường dẫn đến file khóa riêng tư (nếu có)
RECONNECT_INTERVAL=5  # Thời gian chờ giữa các lần kết nối lại (giây)

# Kiểm tra tham số đầu vào
if [ $# -lt 2 ]; then
    echo "Sử dụng: $0 <user> <host> [port] [key_file]"
    echo "Ví dụ: $0 user 192.168.1.100"
    echo "       $0 user example.com 2222"
    echo "       $0 user 192.168.1.100 22 ~/.ssh/id_rsa"
    exit 1
fi

USER=$1
HOST=$2

if [ ! -z "$3" ]; then
    PORT=$3
fi

if [ ! -z "$4" ]; then
    KEY_FILE=$4
fi

# Hàm kết nối SSH với tùy chọn key file
ssh_connect() {
    if [ ! -z "$KEY_FILE" ]; then
        ssh -o ServerAliveInterval=60 -o ServerAliveCountMax=3 -o StrictHostKeyChecking=no -p $PORT -i "$KEY_FILE" "$USER@$HOST"
    else
        ssh -o ServerAliveInterval=60 -o ServerAliveCountMax=3 -o StrictHostKeyChecking=no -p $PORT "$USER@$HOST"
    fi
}

echo "Bắt đầu kết nối SSH đến $USER@$HOST:$PORT"
echo "Nhấn Ctrl+C để dừng hoàn toàn."

# Vòng lặp kết nối lại tự động
while true; do
    echo "$(date '+%Y-%m-%d %H:%M:%S') - Đang kết nối đến $HOST..."
    ssh_connect
    
    # Kiểm tra mã thoát của lệnh SSH
    EXIT_CODE=$?
    
    # Nếu mã thoát là 255, đó thường là lỗi kết nối
    if [ $EXIT_CODE -eq 255 ]; then
        echo "Kết nối bị ngắt. Sẽ thử kết nối lại sau $RECONNECT_INTERVAL giây..."
    else
        echo "SSH session kết thúc với mã thoát $EXIT_CODE."
    fi
    
    # Chờ trước khi kết nối lại
    sleep $RECONNECT_INTERVAL
done
