import strformat
import ../src/ftd2xx


var ftd = newFTD2xx(0)  # open by index
let devInfo = ftd.getDeviceInfo()
echo fmt"deviceType = {devInfo.deviceType}"
echo fmt"id = {devInfo.id}"
echo fmt"description = {devInfo.description}"
echo fmt"serialNumber = {devInfo.serialNumber}"
ftd.close() # close ftdi handle

# you will get the information like this if everything is OK
# deviceType = FT_DEVICE_2232H
# id = 67330064
# description = Dual RS232-HS A
# serialNumber = A

