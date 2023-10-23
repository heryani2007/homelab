# Ask for user input
$IP = Read-Host -Prompt 'Enter the IP Address'
$HostName = Read-Host -Prompt 'Enter the Hostname'

# Display the entered IP and Hostname
Write-Host "IP Address: $IP"
Write-Host "Hostname: $HostName"

# Execute the commands with the provided IP and Hostname
Enable-WSManCredSSP -Role client -DelegateComputer $IP
Enable-WSManCredSSP -Role client -DelegateComputer *
Set-Item WSMan:\localhost\Client\TrustedHosts $HostName
Set-Item WSMan:\localhost\Client\TrustedHosts *

# Additional commands with hostname
Enable-WSManCredSSP -Role client -DelegateComputer "$HostName.local"
Get-Item WSMan:\localhost\Client\TrustedHosts
Enable-WSManCredSSP -Role client -DelegateComputer $HostName

# Modify GPO settings
$GPOPath = "Computer\administrator setting\System\credential delegation"

# Set Allow delegating fresh credentials
$GPOSetting = "$GPOPath\Allow delegating fresh credentials"
Set-GPRegistryValue -Name $GPOSetting -ValueName "Frigg.local,Frigg" -Type String

# Set Allow delegating fresh credentials with NTLM-only server authentication
$GPOSettingNTLM = "$GPOPath\Allow delegating fresh credentials with NTLM-only server authentication"
Set-GPRegistryValue -Name $GPOSettingNTLM -ValueName "Enable,frigg.local,frigg" -Type String
