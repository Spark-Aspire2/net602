
#import user's information from the file UserList.csv
$UserList = Import-Csv -Path "UserList.csv"

#add users one by one
foreach( $UserInfo in $UserList) 
{   
    #Check the OU exists or not, if the OU does not exist, create it first.
    $OU = Get-ADOrganizationalUnit -Filter ('Name -eq "' + $UserInfo.OU + '"')
    if($OU)
    {
        Write-Host  $UserInfo.OU  " OU exists."   
    }
    else
    {
        $OU = New-ADOrganizationalUnit -Name $UserInfo.OU -ProtectedFromAccidentalDeletion $false
        Write-Host $UserInfo.OU  " is created."
    }

    #Check the group exists or not, if the group does not exist, create it first.
    $Group = Get-ADGroup -Filter ('Name -eq "' + $UserInfo.Group + '"')
    if($Group)
    {
        Write-Host $UserInfo.Group  " group exists."   
    }
    else
    {
        $Group = New-ADGroup -Name $UserInfo.Group -GroupScope Global
        Write-Host $UserInfo.Group  " is created."
    }

    #Check the user exists or not, if the user does not exist, create it first.
    $User = Get-ADUser -Filter ('Name -eq "' + $UserInfo.User + '"')
    if($User)
    {
         Write-Host $UserInfo.User " user exists." 
    }
    else
    {
        $User = New-ADUser -Name $UserInfo.User -AccountPassword(ConvertTo-SecureString -AsPlainText 'Aspire2' -Force) -Enabled $true
        Write-Host $UserInfo.User  " is created."
    }

    #add the use to its group
    Add-ADGroupMember -Identity $UserInfo.Group -Members $UserInfo.User

    #add the use to its OU
    $User = Get-ADUser -Filter ('Name -eq "' + $UserInfo.User + '"')
    Move-ADObject -Identity $User -TargetPath ("OU=" + $UserInfo.OU+ ",DC=spark,DC=com")
}