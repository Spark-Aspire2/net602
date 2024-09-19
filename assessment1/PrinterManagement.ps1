##########################################
##### Spark Zheng 16/08/2024 #############
##########################################

# Install Printer Services
Install-WindowsFeature -Name Print-Server -IncludeManagementTools 
#Restart-Computer

$PrinterDriverName = "Lexmark Universal v2 XL"
$PrinterName="iac-printer"

Add-PrinterDriver -Name $PrinterDriverName

# add a printer on server side.
Add-Printer -Name $PrinterName -DriverName $PrinterDriverName -PortName "LPT1:" -shared -ShareName "iac-printer" -Published
#Set-Printer -Name $PrinterName -Shared $true


#Get-Command -Module GroupPolicy
New-GPO -Name PrinterPolicy 
#New-GPLink -Name PrinterPolicy  -Target "ou=Sales,dc=spark,dc=com" -LinkEnabled Yes


# Link GPO to OUs.
$OUs=("Staff","Management","Account")

foreach ($OU in $OUs) {
    New-GPLink -Name PrinterPolicy  -Target "ou=$OU,dc=spark,dc=com" -LinkEnabled Yes
}
