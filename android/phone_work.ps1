# Danh sách các cổng
$ports = @(2222, # ssh termux
            8888, # termux file server
            9999) # proxy server

foreach ($port in $ports) {
    netsh interface portproxy delete v4tov4 listenport=$port listenaddress=0.0.0.0

    adb forward tcp:$port tcp:$port

    netsh interface portproxy add v4tov4 listenport=$port listenaddress=0.0.0.0 connectport=$port connectaddress=127.0.0.1
}