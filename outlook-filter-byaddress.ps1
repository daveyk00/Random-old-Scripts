$comments = @'
Script name: Filter-ByAddress.ps1 
Created on: Wednesday, August 08, 2007 
Author: Kent Finkle 
Purpose: How can I use Windows Powershell to 
Filter Outlook Messages By Email Address? 
'@ 
 
$olFolderInbox = 6 
 
$o = new-object -comobject outlook.application 

$n = $o.GetNamespace("MAPI") 

$f = $n.GetDefaultFolder($olFolderInbox) 
 

$filter=

 
$Items = $f.Items 


foreach ($m in $f.Items) {
    Write-Host($m.SenderEmailAddress+" "+$m.Subect+" "+$m.ReceivedTime) 
}
