import ftd2xx/[ftd2xx_wrapper,defines]
export defines
import strformat

type FTD2XX* = ref object of RootObj
  handle*: FT_HANDLE
  status*: int
  update*: bool

type FTDeviceInfo* = tuple
  deviceType: FTDeviceType
  id: int
  description:string
  serialNumber:string

type FTDeviceDetailedInfo* = tuple
  index: int
  flags: int
  deviceType: FTDeviceType
  id: int
  location:int
  serialNumber:string
  description:string
  handle:FT_HANDLE

type DeviceError*  = object of CatchableError

#proc newFTD2xx*(handle:FT_HANDLE, update=true) : FTD2XX 

template call_ft(function:untyped, args:varargs[untyped]) =
  let status = function(args)
  if FTDeviceStatus(status) != FT_OK:
    raise newException(DeviceError,$FTDeviceStatus(status))

proc listDevices*(flags:int=0):seq[string] = 
  ##　flags only accept OPEN_BY_SERIAL_NUMBER or OPEN_BY_DESCRIPTION
  var n: DWORD
  var status: FT_STATUS
  call_ft(FT_ListDevices,addr n, nil, DWORD(FT_LIST_NUMBER_ONLY))
  var seqBuf : seq[cstring]
  if n.int > 0:
    for i in 0 ..< n:
      seqBuf.add(newString(MAX_DESCRIPTION_SIZE).cstring)
    call_ft(FT_ListDevices, addr seqBuf[0], addr n, DWORD(FT_LIST_ALL or flags))  
    for i in 0 ..< n:
      result.add($seqBuf[i])


proc getLibraryVersion*(): int = 
  var lpdwVersion:DWORD
  #let status = FT_GetLibraryVersion(addr lpdwVersion)
  call_ft(FT_GetLibraryVersion,addr lpdwVersion)
  result= lpdwVersion.int


proc createDeviceInfoList*(): int = 
  var lpdwNumDevs:DWORD
  call_ft(FT_CreateDeviceInfoList,addr lpdwNumDevs)
  result= lpdwNumDevs.int

proc getDeviceInfoDetail*(devnum:int=0,update:bool=true) :FTDeviceDetailedInfo= 
  var lpdwFlags,lpdwType,lpdwID,lpdwLocId: DWORD
  var lpSerialNumber = newString(MAX_DESCRIPTION_SIZE).cstring
  var lpDescription = newString(MAX_DESCRIPTION_SIZE).cstring
  var ftHandle: FT_HANDLE

  if update: discard createDeviceInfoList()
  call_ft(FT_GetDeviceInfoDetail, DWORD(devnum),addr lpdwFlags, addr lpdwType,addr lpdwID,
                    addr lpdwLocId,lpSerialNumber, lpDescription, addr ftHandle)
  result = (index:devnum,flags:lpdwFlags.int,deviceType: FTDeviceType(lpdwType),
              id:lpdwID.int, location:lpdwLocId.int, serialNumber: $lpSerialNumber,
              description: $lpDescription, handle: ftHandle)
##############################################



proc open*(deviceIndex:int) : FT_HANDLE =
  var handle: FT_HANDLE
  call_ft(FT_Open,deviceIndex.cint,addr handle)
  #result = newFTD2xx(handle)
  result = handle
  
#proc openEx(idStr:string, flags:int=FT_OPEN_BY_SERIAL_NUMBER) : FTD2XX =
#  var handle: FT_HANDLE
#  call_ft(FT_OpenEx,idStr[0].unsafeAddr, DWORD(flags), addr handle)
#  result = newFTD2xx(handle)
#
#proc openEx(idInt:int, flags:int=FT_OPEN_BY_SERIAL_NUMBER) : FTD2XX =
#  var handle: FT_HANDLE
#  call_ft(FT_OpenEx,idInt.unsafeAddr, DWORD(flags), addr handle)
#  result = newFTD2xx(handle)

proc openEx*(idStr:string, flags:int=FT_OPEN_BY_SERIAL_NUMBER) : FT_HANDLE =
  var handle: FT_HANDLE
  call_ft(FT_OpenEx,idStr, DWORD(flags), addr handle)
  result = handle

proc openEx*(idInt:int, flags:int=FT_OPEN_BY_SERIAL_NUMBER) : FT_HANDLE =
  var handle: FT_HANDLE
  call_ft(FT_OpenEx,idInt.cint, DWORD(flags), addr handle)
  result = handle



#proc newFTD2xx*(handle:FT_HANDLE, update=true) : FTD2XX =
#  result = FTD2XX()
#  result.handle= handle
#  result.status = 1
#  result.update = false

proc newFTD2xx*(deviceIndex:int, update=true) : FTD2XX =
  result = FTD2XX()
  result.handle= open(deviceIndex)
  result.status = 1
  result.update = false

proc newFTD2xxEx*(idInt:int, flags:int=FT_OPEN_BY_SERIAL_NUMBER, update=true) : FTD2XX =
  result = FTD2XX()
  result.handle= openEx(idInt,flags)
  result.status = 1
  result.update = false

proc close*(self: var FTD2XX) =
  #let status = FT_Close(self.handle)
  call_ft(FT_Close, self.handle)
  self.status = 0

proc read*(self:FTD2XX, nchars:int=256) : seq[uint8] =
  var buffer = newSeq[uint8](nchars)
  var bytesReturned: culong
  call_ft(FT_Read, self.handle, addr buffer[0], nchars.culong, addr bytesReturned)
  result = buffer


proc write*(self:FTD2XX, data:openArray[char|int8|uint8]) : int {. discardable .} =
  var dwBytesToWrite: DWORD
  call_ft(FT_Write, self.handle, data[0].unsafeAddr, DWORD(data.len), addr dwBytesToWrite)
  result = dwBytesToWrite.int

proc setBaudRate*(self:FTD2XX, baudRate:int) = 
  call_ft(FT_SetBaudRate,self.handle, baudRate.culong)

proc setDivisor*(self:FTD2XX, divisor:int) = 
  ## This function sets the baud rate for the device.  It is used to set non-standard baud rates.
  call_ft(FT_SetDivisor, self.handle, divisor.cushort)

proc setDataCharacteristics*(self:FTD2XX, wordLength:uint8, stopBits:uint8, parity:uint8) =
  ## Set the data characteristics for UART
  call_ft(FT_SetDataCharacteristics, self.handle, wordLength.uint8,stopBits.uint8, parity.uint8)

proc setFlowControl*(self:FTD2XX, flowControl:int,xonchar,xoffchar:uint8) =
  call_ft(FT_SetFlowControl, self.handle, flowcontrol.cushort,xonchar.uint8, xoffchar.uint8)

proc resetDevice*(self:FTD2XX) =
  ## Reset the device
  call_ft(FT_ResetDevice, self.handle)

proc setDtr*(self:FTD2XX) = call_ft(FT_SetDtr, self.handle)

proc clrDtr*(self:FTD2XX) = call_ft(FT_ClrDtr, self.handle)

proc setRts*(self:FTD2XX) = call_ft(FT_SetRts, self.handle)

proc clrRts*(self:FTD2XX) = call_ft(FT_ClrRts, self.handle)

proc getModemStatus*(self:FTD2XX): int = 
  ## Gets the modem status and line status from the device
  var m:culong
  call_ft(FT_GetModemStatus, self.handle, addr m)
  result = m.int

proc setChars*(self:FTD2XX, eventChar:bool,eventCharEnabled:uint8,errorChar:bool,errorCharEnabled:uint8) =
  call_ft(FT_SetChars, self.handle, eventChar.uint8, eventCharEnabled.uint8,
                errorChar.uint8,errorCharEnabled.uint8)

proc purge*(self:FTD2XX, mask = FT_PURGE_RX or FT_PURGE_TX) = 
  call_ft(FT_Purge, self.handle, mask.culong)

proc setTimeouts*(self:FTD2XX, readTimeout,writeTimeout: int) =
  ## This function sets the read and write timeouts for the device in milliseconds.
  call_ft(FT_SetTimeouts, self.handle, readTimeout.culong, writeTimeout.culong)

proc setDeadmanTimeout*(self:FTD2XX, timeout:int) =
  call_ft(FT_SetDeadmanTimeout, self.handle, timeout.culong)

proc getQueueStatus*(self:FTD2XX): int =
  ## Gets the number of bytes in the receive queue.
  var rxQAmount: culong
  call_ft(FT_GetQueueStatus, self.handle, addr rxQAmount)
  result = rxQAmount.int

proc setEventNotification*(self:FTD2XX,evtmask:int, evthandle:pointer) =
  call_ft(FT_SetEventNotification, self.handle, evtmask.culong, evthandle)

proc getStatus*(self:FTD2XX) :array[3, int]= 
  var rxQAmount,txQAmount,evtStatus: culong
  call_ft(FT_GetStatus, self.handle, addr rxQAmount,
                addr txQAmount, addr evtStatus)
  result = [rxQAmount.int,txQAmount.int,evtStatus.int]

proc setBreakOn*(self:FTD2XX) = call_ft(FT_SetBreakOn, self.handle)
proc setBreakOff*(self:FTD2XX) = call_ft(FT_SetBreakOff, self.handle)

proc setWaitMask*(self:FTD2XX, mask:int) =
  call_ft(FT_SetWaitMask, self.handle, mask.culong)

proc waitOnMask*(self:FTD2XX): int =
  var mask: culong
  call_ft(FT_WaitOnMask, self.handle, addr mask)
  result = mask.int

proc getEventStatus*(self:FTD2XX): int =
  var evtStatus: culong
  call_ft(FT_GetEventStatus, self.handle, addr evtStatus)
  result = evtStatus.int

proc setLatencyTimer*(self:FTD2XX, latency:uint8)=
  call_ft(FT_SetLatencyTimer, self.handle, latency.uint8)

proc getLatencyTimer*(self:FTD2XX) : uint8=
  var latency: uint8
  call_ft(FT_GetLatencyTimer, self.handle, addr latency)
  result = latency.uint8

proc setBitMode*(self:FTD2XX, mask:uint8, enable:uint8) =
  call_ft(FT_SetBitMode, self.handle, mask.uint8, enable.uint8)

proc getBitMode*(self:FTD2XX):uint8 = 
  var mask: uint8
  call_ft(FT_GetBitMode, self.handle, addr mask)
  result = mask.uint8

proc setUSBParameters*(self:FTD2XX, in_tx_size, out_tx_size:int) =
  call_ft(FT_SetUSBParameters, self.handle, in_tx_size.culong, out_tx_size.culong)

proc getDeviceInfo*(self:FTD2XX) : FTDeviceInfo = 
  var ftDevice: FT_DEVICE 
  var deviceID: DWORD 
  var serialNumber = newString(MAX_DESCRIPTION_SIZE).cstring
  var description = newString(MAX_DESCRIPTION_SIZE).cstring
  #let ftStatus = FT_GetDeviceInfo(self.handle,addr ftDevice,addr deviceID, serialNumber, description,nil)
  call_ft(FT_GetDeviceInfo,self.handle,addr ftDevice,addr deviceID, serialNumber, description,nil)
  result = (deviceType: FTDeviceType(ftDevice),
            id: int(deviceID),
            description: $description,
            serialNumber: $serialNumber)

if isMainModule:
  #var d = newFTD2xx(0)
  var d = newFTD2xxEx(4643,FT_OPEN_BY_LOCATION)
  echo d.getDeviceInfo()
  #echo d.write(@[1'i8,2'i8,3'i8])
  #d.setBitMode(0x03, 1)
  #echo d.getBitMode()
  #d.setBaudRate(115200)
  #d.setDivisor(2)
  #d.resetDevice()
  #echo d.getModemStatus()
  #d.setChars(false,0,false,0)
  d.close()
  #echo listDevices()
  #echo fmt"{getLibraryVersion():08X}"
  #echo createDeviceInfoList()
  #echo getDeviceInfoDetail(0)
  #let d2 = openEx("Single RS232-HS",FT_OPEN_BY_DESCRIPTION)
  #let d2 = openEx(34,FT_OPEN_BY_LOCATION)
  #let d2 = openEx("A",FT_OPEN_BY_SERIAL_NUMBER)
  #echo d2.getDeviceInfo()