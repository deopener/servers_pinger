#
# for the script to work it is necessary to run the command in PS beforehand  
# > Install-Module -Name BurntToast -Force
#
# install
# https://nmap.org/download.html
# https://npcap.com/#download
#
# then reboot computer and check in PS
# > nmap --version
# 

Import-Module BurntToast

# Telegram settings
$telegramToken = "222222222:XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX"  # bot token
$chatID = "333333333"       # your chat_id


# file with servers list
$serversFile = "$PSScriptRoot\servers.json"

function Load-Servers {
    if (Test-Path $serversFile) {
        return Get-Content -Path $serversFile | ConvertFrom-Json
    } else {
        Write-Host "Error: File $serversFile was not found!" -ForegroundColor Red
        return @()  # Return empty array if there is no file
    }
}

$logFile = "$env:USERPROFILE\Desktop\server_check_status.log"  # on Desktop, but you can change its location

function Write-Log($message) {
    $timestamp = Get-Date -Format "yyyy-MM-dd HH:mm:ss"
    "$timestamp - $message" | Out-File -Append -FilePath $logFile -Encoding utf8
}

function Send-TelegramMessage($text) {
    $url = "https://api.telegram.org/bot$telegramToken/sendMessage"

    # Forming the body of the request
    $body = @{
        chat_id = $chatID
        text = $text
    } | ConvertTo-Json -Depth 3

    # Request sending
    Invoke-RestMethod -Uri $url -Method Post -Body $body -ContentType "application/json; charset=utf-8"
}


while ($true) {
    clear
	$servers = Load-Servers  # Loading servers list

    foreach ($server in $servers) {
        $ip = $server.IP
        $port = $server.Port
        $type = $server.Type
        $isOnline = $false

        if ($type -eq "Linux") {
            $result = & nmap -p $port $ip | Out-String
            if ($result -match "open") { $isOnline = $true }
        }
        elseif ($type -eq "Windows") {
            $isOnline = Test-Connection -ComputerName $ip -Count 1 -Quiet
        }

        if ($isOnline) {
            # Write-Log "Server $ip is ok"
        }
        else {
            Write-Log "Server $ip is OFFLINE"
            [console]::beep(2000, 500)
            [console]::beep(1000, 500)
            [console]::beep(2000, 500)
            [console]::beep(1000, 500)
            
            $message = "Attention! Server $ip is DOWN!"
            Send-TelegramMessage $message

            # Show system notification via BurntToast
            New-BurntToastNotification -Text "Server $ip is DOWN!", "Please check the server status."
        }
    }
    Start-Sleep -Seconds 60
}
