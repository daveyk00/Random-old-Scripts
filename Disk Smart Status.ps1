$known_attributes = @{
 0x01 = 'Read Error Rate (CRITICAL)';
 0x02 = 'Throughput Performance';
 0x03 = 'Spin-Up Time';
 0x04 = 'Start/Stop Count';
 0x05 = 'Reallocated Sectors Count (CRITICAL)';
 0x07 = 'Seek Error Rate';
 0x08 = 'Seek Time Performance';
 0x09 = 'Power-On Hours';
 0x0a = 'Spin Retry Count';
 0x0b = 'Recalibration Retries';
 0x0c = 'Device Power Cycle Count';
 0x0d = 'Soft Read Error Rate';
 0xc3 = 'Hardware ECC Recovered';
 0xc4 = 'Reallocation Event Count (CRITICAL)';
 0xc5 = 'Current Pending Sector Count (CRITICAL)';
 0xc6 = 'Uncorrectable Sector Count (CRITICAL)';
 0xc7 = 'UltraDMA CRC Error Count';
 0xc8 = 'Write Error Rate / Multi-Zone Error Rate';
 0xc9 = 'Soft Read Error Rate (CRITICAL)';
 0xdc = 'Disk Shift (CRITICAL)'
}

$txt = $(Get-WmiObject Win32_DiskDrive | % {
 $drive_id = $_.PNPDeviceId + '_0'
 $drive_status = Get-WmiObject -namespace root\wmi 
MSStorageDriver_FailurePredictStatus -filter $("InstanceName='" + 
$($drive_id -replace '\\','\\') + "'")
 $drive_data = $(Get-WmiObject -namespace root\wmi 
MSStorageDriver_FailurePredictData -filter $("InstanceName='" + 
$($drive_id -replace '\\','\\') + "'")).VendorSpecific
 $threshold_data = $(Get-WmiObject -namespace root\wmi 
MSStorageDriver_FailurePredictThresholds -filter $("InstanceName='" + 
$($drive_id -replace '\\','\\') + "'")).VendorSpecific
 $drive_data_value_d = @{}
 $drive_data_worst_d = @{}
 $threshold_data_d = @{}
 for ($i = 0 ; $i -lt 30 ; $i = $i + 1) {
  $drive_data_value_d[[int]$drive_data[$i * 12 + 2]] = [int]$drive_data[$i * 
12 + 5]
  $drive_data_worst_d[[int]$drive_data[$i * 12 + 2]] = [int]$drive_data[$i * 
12 + 6]
  $threshold_data_d[[int]$threshold_data[$i * 12 + 2]] = 
[int]$threshold_data[$i * 12 + 3]
 }
 '____________________________________________________________'
 if ($drive_status.PredictFailure) { ''; '!!! WARNING !!! This disk is 
failing.' }
 $_ | Format-Table -autosize DeviceID,MediaType,Model
 $known_attributes | Format-Table -autosize @{ Label='Name'; Expression={ 
$_.Value } },@{ Label='Value'; Expression={ 
$drive_data_value_d[$_.Name] } },@{ Label='Worst'; Expression={ 
$drive_data_worst_d[$_.Name] } },@{ Label='Threshold'; Expression={ 
$threshold_data_d[$_.Name] } }
} | Out-String)

$msg = New-Object System.Net.Mail.MailMessage
$msg.SubjectEncoding = [System.Text.Encoding]::UTF8
$msg.BodyEncoding = [System.Text.Encoding]::UTF8
$msg.From = 'Bill Sanderson <EmailAddress1>'
$msg.To.Add('Bill Sanderson <EmailAddress2>')
$msg.Subject = 'SMART report for ' + $(Get-WmiObject 
Win32_ComputerSystem).Name
$msg.Body = $txt

$smtp = New-Object System.Net.Mail.SmtpClient('SMTPServerNameorIP')
$smtp.Send($msg)