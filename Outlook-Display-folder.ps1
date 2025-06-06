$comments = @'
Script name: Display-Folder.ps1
Created on: Monday, October 01, 2007
Author: Kent Finkle
Purpose: How can I use Windows Powershell to
Return a new Outlook Explorer to display a folder?
see http://msdn2.microsoft.com/en-us/library/aa158267(office.10).aspx
'@
#-----------------------------------------------------
function Release-Ref ($ref) {
([System.Runtime.InteropServices.Marshal]::ReleaseComObject(
[System.__ComObject]$ref) -gt 0)
[System.GC]::Collect()
[System.GC]::WaitForPendingFinalizers() 
}
#-----------------------------------------------------
$olFolderInbox = 6
 
# the Application $object.
$o = new-object -comobject outlook.application
 
$n = $o.GetNamespace("MAPI")
 
$myFolder = $n.GetDefaultFolder($olFolderInbox)
 
$myExplorer = $myFolder.GetExplorer()
 
$a = $myExplorer.Display()
 
$a = Release-Ref($myExplorer)
$a = Release-Ref($myFolder)
$a = Release-Ref($n)
$a = Release-Ref($o)