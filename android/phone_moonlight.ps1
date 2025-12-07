$ports = @(
            # TCP
            47984,
            47989,
            48010,
            # UDP (-10000)
            37998,
            37999,
            38000,
            38002,
            38010
            )

foreach ($port in $ports) {
    netsh interface portproxy delete v4tov4 listenport=$port listenaddress=0.0.0.0

    adb forward tcp:$port tcp:$port

    netsh interface portproxy add v4tov4 listenport=$port listenaddress=0.0.0.0 connectport=$port connectaddress=127.0.0.1
}

