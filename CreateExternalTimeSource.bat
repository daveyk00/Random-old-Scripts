net stop w32time
w32tm /unregister
w32tm /register
net start w32time
w32tm /config /manualpeerlist:oceania.pool.ntp.org,0x1 /syncfromflags:manual /reliable:yes /update
net stop w32time && net start w32time
w32tm /resync /rediscover