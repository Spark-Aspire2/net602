##########################################
##### Spark Zheng 18/09/2024 #############
##########################################

# The variables are predefined.
$VolumeName = "C:\"                        #The disk volume which will be backuped.
$BackupFolderName = "BackupFolder"         #The folder name for backup   
$BackupFolderPath = "D:\$BackupFolderName" #The full path for backup
$BackupNetworkPath = "\\$env:COMPUTERNAME\$BackupFolderName"  #network share place
$BackupTime =  "11:40"                     #The time is scheduled to start backup action.


# 1. Prepare Backup folder on Backup server
New-Item $BackupFolderPath -Type directory -Force
New-SmbShare -Name $BackupFolderName -Path $BackupFolderPath  -FullAccess Administrators


# 2. Install Windows Backup Services
Install-WindowsFeature -Name Windows-Server-Backup -IncludeManagementTools 


# 3. Create a new Windows backup policy
$Policy = New-WBPolicy

# Configure the path of the files to backup
$FileSpec = New-WBFileSpec -FileSpec $VolumeName

# Add the file path to the backup policy
Add-WBFileSpec -Policy $Policy -FileSpec $FileSpec

# Prepare the Credential to access backup storage
$User = "administrator"
$PWord = ConvertTo-SecureString -AsPlainText 'Aspire2' -Force
$Credential = New-Object -TypeName System.Management.Automation.PSCredential -ArgumentList $User, $PWord

# Configure the backup location
$BackupLocation = New-WBBackupTarget -NetworkPath $BackupNetworkPath -Credential $Credential

# Add the target location to the backup policy
Add-WBBackupTarget -Policy $Policy -Target $BackupLocation

# 4. Set backup policy schedule time and add it to the task scheduler
Set-WBSchedule -Policy $Policy -Schedule $BackupTime

# Add the backup policy to the backup server
Set-WBPolicy -Policy $Policy

# 5. Encrypt the backup folder after the backup finished.
Get-ChildItem -Path $BackupNetworkPath -Recurse |Where-Object { if($_.GetType().Name -eq "FileInfo") {$_.Encrypt()}}

# 6. Decrypt the backup folder before to recover.
Get-ChildItem -Path $BackupNetworkPath -Recurse |Where-Object { if($_.GetType().Name -eq "FileInfo") {$_.Decrypt()}} 

