#run c:\windows\system32\sysprep\sysprep.exe -> reset the computer to factory with Generalize option. if the same virtual machine copy is used.

#Set Time zone
Set-TimeZone -Name "New Zealand Standard Time"

#Change Computer Name
$serverName = "VPN"
Rename-Computer -NewName $serverName -Restart


#Set a static IP address in the same subnet of the primary domain controller. 
#Get-NetAdapter
$interfaceIndex = 6
$ipAddress = "192.168.1.3"
$defaultGateway = "192.168.1.1"
$dnsServerAddresses= ("192.168.1.1")

New-NetIPAddress -InterfaceIndex $interfaceIndex -IPAddress $ipAddress -PrefixLength 24 -DefaultGateway $defaultGateway
#Set DNS for the static IPv4
Set-DnsClientServerAddress -InterfaceIndex $interfaceIndex -ServerAddresses $dnsServerAddresses


#Prepare credential information
#$User = "spark\administrator"
#$PWord = ConvertTo-SecureString -AsPlainText 'Aspire2' -Force
#$Credential = New-Object -TypeName System.Management.Automation.PSCredential -ArgumentList $User, $PWord

#Join to the domain

$domainName = "techco.co.nz"
$domainNetbiosName = "TECHCO"

$Credential = Get-Credential "$domainNetbiosName\administrator"
Add-Computer –domainname $domainName -Credential $Credential -Restart

#Restart-Computer


#Install Rols and Feature of Active Directory
Install-WindowsFeature -Name "AD-Domain-Services" -IncludeManagementTools 




