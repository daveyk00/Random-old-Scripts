$comments = @'
Script name: Convert-EmailToTextFile.ps1
Created on: Tuesday, July 31, 2007
Author: Kent Finkle
Purpose: How can I use Windows Powershell to
Convert an Outlook Email Message into a Text File?
'@
 
$olFolderInbox = 6 
$olTxt = 0 
 
$o = new-object -comobject outlook.application 
 
$n = $o.GetNamespace("MAPI") 
 
$fld = $n.GetDefaultFolder($olFolderInbox) 
 
$colMailItems = $fld.Items 
 
$objItem = $colMailItems.GetFirst() 
 
$objItem.SaveAs("C:\temp\MailMessage.txt", $olTxt)

$objItem = $colMailItems.GetNext() 

$objItem.SaveAs("C:\temp\MailMessage2.txt", $olTxt)