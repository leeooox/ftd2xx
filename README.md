# ftd2xxx
Nim wrapper for FTDI ftd2xxx library

As I cannot find a ftdi wrapper for Nim, I decided to do it by myself. 

The API names is inspirated by its python counterpart https://github.com/snmishra/ftd2xx

Please also refer to FTDI's offical document of C API [D2XX_Programmer's_Guide](https://www.ftdichip.com/Support/Documents/ProgramGuides/D2XX_Programmer%27s_Guide(FT_000071).pdf), the usage of FTDI APIs is inside this document.

If you need MPSSE(JTAG,SPI,I2C) or Bitbang mode of FTDI chip, please also read the application note from FTDI, which is out of scope ftd2xxx nim libaray.

**ftd2xx_wrapper.nim** is the FFI of  C wrapper of ftd2xx.h to Nim and load ftd2xx.dll which will be shipped with FTDI driver package.

**ftd2xx.nim** is high level based nim styple API interface inspirated by python ftd2xx libaray.



## Installation

```shell
nimble install ftd2xxx
```

## Example 

```nim

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

```

## Benifits

* You could build a very small exe files without any dependency (ftdi driver and ftd2xx.dll must be installed as long as you need use the FTDI hardwares)
* You could use a python-like API interface, a mimic OOP type call method. (Yes, Nim's OOP is a kind of mimic thing)