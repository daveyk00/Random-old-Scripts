# SERVER 2012 WSUS CLEANUP

# This will perform the following actions on a WSUS 3.0 SP2 server running on server 2012:
# Run the cleanup wizard;
# Reindex the database;
# Decline itanium updates;
# Shrink the database.
# Optionally send an email with results from the above

# Requirements:
# WSUSDBMaintenance script: https://gallery.technet.microsoft.com/scriptcenter/6f8cde49-5c52-4abd-9820-f1d270ddea61
# SQL Management Studio: https://www.microsoft.com/en-us/download/details.aspx?id=43351

# Configuration
# SendReport - $TRUE will send the email / $FALSE will not
# WsusServer - Name or IP Address of WSUS Server
# UseSSL - Is the WSUS server using SSL or not
# PortNumber - WSUS Port Number
# SMTPServer - Name or IP address of SMTP server for email
# FromAddress - email address the email will come from
# Recipients - email address the email will be sent to
# MessageSubject - Subject of the email
# SQLCMDFILEPATH - location to sqlcmd.exe from SQL Management Studio
# HypenI - "-i" to allow the sqlcmd.exe process to run the WSUSDBMaintenance.sql script
# WSUSCLEANUPSCRIPT - location to WSUSDBMaintenance.sql script - available https://gallery.technet.microsoft.com/scriptcenter/6f8cde49-5c52-4abd-9820-f1d270ddea61
# WSUSSHRINKCOMMAND - sql command to shrink the database
# HypenS - "-S" to allow the sqlcmd.exe process to connect to a server
# HypenQ - "-Q" to allow the sqlcmd.exe process to run the Shrink command
# SQLDatabaseConnection - Connection string to WSUS database

#Report Configuration
$SendReport=$TRUE

#WSUS Configuration
$WsusServer = "wsus"
$UseSSL = $false
$PortNumber = 8530

#E-mail Configuration
$SMTPServer = "smtp"
$FromAddress = "sender@example.com"
$Recipients = "recipient@example.com"
$MessageSubject = "wsus maintenace"

#SQL Configuration

# If SQL Management studio is a different version than 2012 R2 - change the path to sqlcmd.exe below
$SQLCMDFILEPATH="c:\program files\microsoft sql server\110\tools\binn\sqlcmd.exe"
$WSUSCLEANUPSCRIPT="C:\maintenance\WSUSDBMaintenance.sql"

#------------------------------------------------------------

# The following probably doesn't need to be changed

$WSUSSHRINKCOMMAND='"DBCC ShrinkDatabase (SUSDB,10)"'
$HypenS="-S"
$HypenQ="-Q"
$HypenI="-i"
# Server 2008 / SQL2008 should use 'np:\\.\pipe\MSSQL$MICROSOFT##SSEE\sql\query'
$SQLDatabaseConnection='np:\\.\pipe\Microsoft##WID\tsql\query'
#$SQLDatabaseConnection='ducefps01'

#------------------------------------------------------------

Function SendEmailStatus($MessageSubject, $MessageBody)
{
	$SMTPMessage = New-Object System.Net.Mail.MailMessage $FromAddress, $Recipients, $MessageSubject, $MessageBody
    $SMTPMessage.IsBodyHTML = $false
	$SMTPClient = New-Object System.Net.Mail.SMTPClient $SMTPServer
	$SMTPClient.Send($SMTPMessage)
	$SMTPMessage.Dispose()
	rv SMTPClient
	rv SMTPMessage
}

#------------------------------------------------------------

# Out-Null used to prevent writing to console

# Run the WSUS Cleanup Wizard
Invoke-WsusServerCleanup -CleanupObsoleteComputers -CleanupObsoleteUpdates -CleanupUnneededContentFiles -DeclineExpiredUpdates -DeclineSupersededUpdates  | Tee-Object -Variable WSUSCleanupResults | Out-Null


# Reindex the database
& $SQLCMDFILEPATH $HypenS $SQLDatabaseConnection $hypenI $WSUSCLEANUPSCRIPT | Tee-Object -Variable SQLCleanupResults | Out-Null


# Decline itanium updates
# The following two scripts were combined to give the best results.
# http://learn-powershell.net/2013/11/12/automatically-declining-itanium-updates-in-wsus-using-powershell/
# https://gallery.technet.microsoft.com/scriptcenter/Automatically-Declining-a4fec7be#content
#Connect to the WSUS 3.0 interface.
[reflection.assembly]::LoadWithPartialName("Microsoft.UpdateServices.Administration") | out-null
$WsusServerAdminProxy = [Microsoft.UpdateServices.Administration.AdminProxy]::GetUpdateServer($WsusServer,$UseSSL,$PortNumber);
$approveState = 'Microsoft.UpdateServices.Administration.ApprovedStates' -as [type]
$updateScope = New-Object Microsoft.UpdateServices.Administration.UpdateScope -Property @{
    TextIncludes = 'itanium'
    ApprovedStates = $approveState::NotApproved,
    $approveState::LatestRevisionApproved,
    $approveState::HasStaleUpdateApprovals
}
$itanium = $WsusServerAdminProxy.GetUpdates($updateScope) | ?{-not $_.IsDeclined -and $_.Title -match “ia64|itanium”}
$itanium | %{$_.Decline()} | Tee-Object -Variable itaniumdeclineresults


# Shrink the database
& $SQLCMDFILEPATH $HypenS $SQLDatabaseConnection $HypenQ $WSUSSHRINKCOMMAND | Tee-Object -Variable SQLShrinkResults | Out-Null


If ($itanium.Count -gt 0)
{
    $ITaniumUpdateName=""
    ForEach ($ItaniumUpdate in $Itanium)
    {
        $ItaniumUpdateName=$ItaniumUpdateName+$ItaniumUpdate.Title+"`r`n"
    }
    $ItaniumMessageBody=$ItaniumUpdateName
}
else
{
    $ItaniumMessageBody="No Itanium Updates to decline"
}

$MessageBreak="`r`n`r`n`r`n-------------------------------------------------------------------------------------------`r`n`r`n`r`n"
$MessageBody1=$WSUSCleanupResults+$MessageBreak
$MessageBody2=$SQLCleanupResults+$MessageBreak
$MessageBody2=$MessageBody2 -replace "  ","`r`n"
$MessageBody3=$SQLShrinkResults+$MessageBreak
$MessageBody4=$ItaniumMessageBody+$MessageBreak
$MessageBody=$MessageBody1+$MessageBody2+$MessageBody3+$MessageBody4

if ($SendReport)
{
    SendEmailStatus $MessageSubject $Messagebody
}
