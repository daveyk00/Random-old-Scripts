# calc-date.ps1
#
# Prompts for an integer number of days
# Adds the given number to todays date
# Outputs the result
#
# Negative numbers will subtract the date


write-host `n'Calc-Date.ps1'`n
write-host 'This will take a number of days, add it to todays date, and output the date.'
write-host 'Negative days will subtract.'`n

$DaysToAdd=Read-Host `n'How many days to calculate?'
$TimeNow=[datetime]::today

write-host $DaysToAdd days from $TimeNow.toString("dd/MM/yyyy") is ($timenow.adddays($DaysToAdd)).tostring("dd/MM/yyyy")
Read-host `n'Press Enter to Exit'