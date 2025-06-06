$comments = @'
Script name: Filter-Subject.ps1 
Created on: Tuesday, August 14, 2007 
Author: Kent Finkle 
Purpose: How can I use Windows Powershell to 
Filtering Email Messages in Microsoft Outlook? 
'@ 
 
$olFolderInbox = 6 
$o = new-object -comobject outlook.application 
$n = $o.GetNamespace("MAPI") 

$f = $n.GetDefaultFolder($olFolderInbox) 
 
$items = $f.Items 

$filtered = $items.Restrict("[Subject] = 'Payment confirmation'") 
 
foreach ($item In $filtered) { 
    Write-Host($item.Body) 
}