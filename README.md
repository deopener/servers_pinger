# servers pinger
PowerShell console script for pinging list of servers to check if they are online

# how does it work
1. add your servers to 'servers.json' pointing server OS (Windows based/Linux based) and port (22 for Linux based and 3389 for Windows based) in JSON format:
     ```
     [
       { "IP": "7.77.7.77", "Port": 3389, "Type": "Windows" },   
       { "IP": "1.2.3.4", "Port": 22, "Type": "Linux" }
     ]
     ```
3. install [nmap](https://nmap.org/download.html) и [npcap](https://npcap.com/#download)
4. run this script in your PowerShell to install BurntToast:
     `Install-Module -Name BurntToast -Force`
5. reboot you PC/server/VM
6. configure CheckServers.ps1:
- edit line 16 - set telegram bot token (You can create new bot  with Telegram bot @BotFather)
- edit line 17 - set telegram chat_id (You can get chat_id if you write any message to your bot and then open in browser `https://api.telegram.org/bot<yourBotToken>/getUpdates` and search for your message from before)
- edit line 32 (optional) - to change log location
- edit line 88 (optional) - to change time interval between script repeats
- save changes!
7. launch script CheckServers.ps1 in PowerShell
8. enjoy =)

P.S. script supports hot servers list change - you can edit servers list and save it when script is working
