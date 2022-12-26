<#==================================================================================================================================================================
This script is to Export Teams AutoAttendants & its CallQueue's from Teams Admin center.


Author: Pramod.K.N (Pramodknataraj@gmail.com)

Date: December 15, 2022

Prereqisites :- 1) PowerShell Tool and access to Teams Admin Centre as Admin
                2) Authorization token from "api.interfaces." and "graph.microsoft.com" that you get from Browser (F12)
                         
               

================================================================================================================================================================== #>
$CurrentUser = whoami
$Report2 = ".\AA_List_Report.CSV"
$Token1 = ""
$Token2 = ""

$Headers1 = @{"Authorization" = $Token1
"Host" = "api.interfaces.records.teams.microsoft.com"
"Accept"="application/json"
"Content-Type"="application/json"
}

$Headers2 = @{"Authorization" = $Token2
"Host" = "graph.microsoft.com"
"Accept"="application/json"
"Content-Type"="application/json"
}

$Footer1 = "<BR><i>Report generated on $((Get-Date).ToString()) by $CurrentUser</i>" #$($Env:USERNAME)</i>"
$Footer2 = "<BR><i> <font color =""#99000""> Scripted by Pramod.KN (Pramod.KN@gds.ey.com), Teams Support </font></i>"


$Url = "https://api.interfaces.records.teams.microsoft.com/Teams.VoiceApps/auto-attendants?First=99999"

$jsonStrUrl = Invoke-WebRequest -Uri $Url -Method 'Get' -Headers $Headers1
$jsonobj = $jsonStrUrl | ConvertFrom-Json | select -expand AutoAttendants


ForEach ($AAID in $jsonobj )
{

$Url2 = "https://api.interfaces.records.teams.microsoft.com/Teams.PlatformService/v2/ApplicationInstances/"+$AAID.ApplicationInstances
$jsonStr2 = Invoke-WebRequest -Uri $Url2 -Method 'Get' -Headers $Headers1
$jsonobj2 = $jsonStr2 | ConvertFrom-Json

$AATACName = $AAID.Name
$AAResourceAccountName = $jsonobj2.displayName
$AAResourceAccountMail = $jsonobj2.userPrincipalName
$AAResourceAccountPhoneNumber = $jsonobj2.phoneNumber


$Url3 = "https://graph.microsoft.com/beta/users/"+$AAID.defaultcallflow.menu.MenuOptions.calltarget.id
$jsonStr3 = Invoke-WebRequest -Uri $Url3 -Method 'Get' -Headers $Headers2
$jsonobj3 = $jsonStr3 | ConvertFrom-Json

$CQResourceAccountName = $jsonobj3.Displayname
$CQResourceAccountMail = $jsonobj3.userPrincipalName
$CQResourceAccountNamePhone = $jsonobj3.businessPhones
$CQResourceAccountNameMobile = $jsonobj3.mobilePhone

$AATACName + ";" + $AAResourceAccountName + ";" + $AAResourceAccountMail + ";" + $AAResourceAccountPhoneNumber + ";" + $CQResourceAccountName+ ";" + $CQResourceAccountMail + ";" + $CQResourceAccountNamePhone + ";" + $CQResourceAccountNameMobile  >> $Report2

}