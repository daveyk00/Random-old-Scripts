# Configure the Firewall for a reason
#
# Adds the relevant IP addresses based on the following to remote address in firewall rules
#
#		Printers	Wireless	Wired
#	SiteID	lan1.600 IP /26	lan1.410 IP /25	lan1.500 IP /25
#site1,’172.18.18.62/26’,’172.18.17.254/25’,’172.18.17.126/25’
#
#

$rulesToModify=@('File and Printer Sharing (LLMNR-UDP-In)','File and Printer Sharing (NB-Datagram-In)','File and Printer Sharing (NB-Name-In)','File and Printer Sharing (NB-Session-In)','File and Printer Sharing (Spooler Service - RPC)','File and Printer Sharing (Spooler Service - RPC-EPMAP)','File and Printer Sharing (SMB-In)','File and Printer Sharing (Echo Request - ICMPv4-In)')
$remoteFirewallAddress=@('LocalSubnet',’172.18.18.62/26’,’172.18.17.254/25’,’172.18.17.126/25’)
ForEach($rule in $rulesToModify)
{
    get-netfirewallrule -displayname $rule | where profile -like "*pr*" | get-netfirewalladdressfilter | set-netfirewalladdressfilter -localaddress any -remoteaddress $remoteFirewallAddress
}






