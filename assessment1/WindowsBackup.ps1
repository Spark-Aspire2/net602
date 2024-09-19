##########################################
##### Spark Zheng 16/08/2024 #############
##########################################

# Install Printer Services
Install-WindowsFeature -Name Windows-Server-Backup -IncludeManagementTools 

# Create a new Windows backup policy
$Policy = New-WBPolicy

# Configure the path of the files to backup
$FileSpec = New-WBFileSpec -FileSpec "C:\Test4Backup"

# Add the file path to the backup policy
Add-WBFileSpec -Policy $Policy -FileSpec $FileSpec

# Prepare the Credential to access backup storage
$User = "administrator"
$PWord = ConvertTo-SecureString -AsPlainText 'Aspire2' -Force
$Credential = New-Object -TypeName System.Management.Automation.PSCredential -ArgumentList $User, $PWord

# Configure the backup location
$BackupLocation = New-WBBackupTarget -NetworkPath "\\VMWINDOWSSERVER\ShareFolder" -Credential $Credential

# Add the target location to the backup policy
Add-WBBackupTarget -Policy $Policy -Target $BackupLocation

# Set backup time 
Set-WBSchedule -Policy $Policy -Schedule 23:23

# Add the backup policy to the backup server
Set-WBPolicy -Policy $Policy

# for once time backup execute start cmdlet directly.
#Start-WBBackup -Policy $Policy



