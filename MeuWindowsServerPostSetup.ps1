# REMOTE DESKTOP #######################################################################################################
# Allow Remote Desktop connections
(Get-WmiObject -Class "Win32_TerminalServiceSetting" -Namespace root\cimv2\terminalservices).SetAllowTsConnections(1)
# Configure Windows Firewall to allow Remote Desktop connections
if ((Get-WinUserLanguageList).LanguageTag -ieq "pt-BR") {
    Get-NetFirewallRule -DisplayGroup "*rea de Trabalho Remota" | Set-NetFirewallRule -Enabled True
} else {
    Get-NetFirewallRule -DisplayGroup "Remote Desktop" | Set-NetFirewallRule -Enabled True
}
# Configure Windows Firewall to allow PING
Get-NetFirewallRule -DisplayName "*ICMPv4-In)" | Set-NetFirewallRule -Enabled True
Get-NetFirewallRule -DisplayName "*ICMPv6-In)" | Set-NetFirewallRule -Enabled True


# WINDOWS FEATURES #####################################################################################################
# Disable Server Manager autostart
Get-ScheduledTask -TaskName ServerManager | Disable-ScheduledTask
# Disable PowerShell v2
if ((Get-WindowsOptionalFeature -Online -FeatureName MicrosoftWindowsPowerShellV2).state -eq 'Enabled') {
    disable-WindowsOptionalFeature -Online -FeatureName MicrosoftWindowsPowerShellV2 -norestart
}
if ((Get-WindowsOptionalFeature -Online -FeatureName MicrosoftWindowsPowerShellV2Root).state -eq 'Enabled') {
    disable-WindowsOptionalFeature -Online -FeatureName MicrosoftWindowsPowerShellV2Root -norestart
}
# Disable Windows Media Player (legacy)
if ((get-WindowsOptionalFeature -Online -FeatureName WindowsMediaPlayer).state -eq 'Enabled') {
    disable-WindowsOptionalFeature -Online -FeatureName WindowsMediaPlayer -norestart
}
# Disable Internet Explorer
if ((get-WindowsOptionalFeature -Online -FeatureName Internet-Explorer-Optional-amd64).state -eq 'Enabled') {
    disable-WindowsOptionalFeature -Online -FeatureName Internet-Explorer-Optional-amd64 -norestart
}
# Disable Azure Arc Setup
if ((get-WindowsOptionalFeature -Online -FeatureName AzureArcSetup).state -eq 'Enabled') {
    disable-WindowsOptionalFeature -Online -FeatureName AzureArcSetup -norestart
}
# Enable Telnet Client
if ((get-WindowsOptionalFeature -Online -FeatureName TelnetClient).state -eq 'Disabled') {
    enable-WindowsOptionalFeature -Online -FeatureName TelnetClient -norestart
}


# WINDOWS UPDATE CLIENT ################################################################################################
# Turn on to receive updates for other microsoft products
(New-Object -com "Microsoft.Update.ServiceManager").AddService2("7971f918-a847-4430-9279-4a52d1efe18d",7,"")
# Turn on to receive messages about meed restart to apply updates
New-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\WindowsUpdate\UX\Settings" -Name "RestartNotificationsAllowed2" -Value "1" -PropertyType "DWORD" -Force
# Open Windows Update
C:\Windows\System32\control.exe /name Microsoft.WindowsUpdate
