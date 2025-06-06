$olFolderInbox = 6
$outlook = new-object -com outlook.application
$ns = $outlook.GetNameSpace("MAPI")
$collect= $ns.GetDefaultFolder($olFolderInbox).Folders.Item("Household")
$collect.items.count