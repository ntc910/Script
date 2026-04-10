# 1. Download SharePoint Online Management Shell

# 2. Connect to your admin account
```sh
Connect-SPOService -Url "https://6b5l0g-admin.sharepoint.com"
Connect-SPOService -Url "https://osapp-admin.sharepoint.com"

```

# 3. Change the domain name
Check if name is available [here](https://o365.rocks/)

```sh
Start-SPOTenantRename -DomainName "osapp" -ScheduledDateTime "2026-02-19T10:00:00"
```

# Check status
```sh
Get-SPOTenantRenameStatus
```

# IMPORTANT: Unlock drive
After done, the onedrive state is **readonly****

Check by
Get-SPOSite -IncludePersonalSite $true `
>> | Where-Object {$_.Url -like "*-my.sharepoint.com/personal/*"} `
>> | Select Url, LockState


Run this to fix
```sh
Get-SPOSite -IncludePersonalSite $true | Where-Object {$_.LockState -eq "ReadOnly"} | ForEach-Object {
    Set-SPOSite -Identity $_.Url -LockState Unlock
}
```

