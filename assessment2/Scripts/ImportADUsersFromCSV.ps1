#import user's information from the file UserList.csv
$FilePath = "UserList.csv"
$UserList = Import-Csv -Path $FilePath

#add users one by one
foreach( $UserInfo in $UserList) 
{   
    #Check the group exists or not, if the group does not exist, create it first.
    $Group = Get-ADGroup -Filter ('Name -eq "' + $UserInfo.Group  + '"')
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
    $User = Get-ADUser -Filter ('Name -eq "' + $UserInfo.'First Name' + '"')
    if($User)
    {
         Write-Host $UserInfo.'First name' " user exists." 
    }
    else
    {
        $Parameters = @{
            Name = $UserInfo.'First Name'
            AccountPassword = (ConvertTo-SecureString -AsPlainText 'Aspire2' -Force)
            Enabled = $true
            GivenName = $UserInfo.'First Name'
            Surname = $UserInfo.'Last Name'        
        }

        $User = New-ADUser @Parameters
        Write-Host $UserInfo.'First Name'  " is created."
    }

    #add the use to its group
    Add-ADGroupMember -Identity $UserInfo.Group -Members $UserInfo.'First Name'

}