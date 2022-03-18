import defines

type

  FT_HANDLE* = pointer
  P_FT_HANDLE = ptr FT_HANDLE
  FT_STATUS* = culong
  FT_DEVICE* = culong
  P_FT_DEVICE* = ptr FT_DEVICE
  
  DWORD* = culong
  LPDWORD* = ptr DWORD
  CHAR* = cchar
  PCHAR* = ptr CHAR

  LPVOID* = pointer
  PVOID* = pointer

{.push dynlib: libName.}

#FT_STATUS WINAPI FT_Open(int deviceNumber,FT_HANDLE *pHandle);
proc FT_Open*(deviceNumber:cint, pHandle:P_FT_HANDLE): FT_STATUS {.stdcall, importc: "FT_Open".}

#	FT_STATUS WINAPI FT_OpenEx(PVOID pArg1,DWORD Flags,FT_HANDLE *pHandle);
proc FT_OpenEx*(pArg1:cint, Flags:DWORD, pHandle:P_FT_HANDLE): FT_STATUS {.stdcall, importc: "FT_OpenEx".}
proc FT_OpenEx*(pArg1:cstring, Flags:DWORD, pHandle:P_FT_HANDLE): FT_STATUS {.stdcall, importc: "FT_OpenEx".}
#proc FT_OpenEx*(pArg1:pointer, Flags:DWORD, pHandle:P_FT_HANDLE): FT_STATUS {.stdcall, importc: "FT_OpenEx".}
#FT_STATUS WINAPI FT_Close(FT_HANDLE ftHandle);
proc FT_Close*(ftHandle:FT_HANDLE): FT_STATUS {.stdcall, importc: "FT_Close".}

#	FTD2XX_API
#		FT_STATUS WINAPI FT_GetDeviceInfo(
#		FT_HANDLE ftHandle,
#		FT_DEVICE *lpftDevice,
#		LPDWORD lpdwID,
#		PCHAR SerialNumber,
#		PCHAR Description,
#		LPVOID Dummy
#		);

proc FT_GetDeviceInfo*(ftHandle:FT_HANDLE,
  lpftDevice: P_FT_DEVICE,
  lpdwID: LPDWORD,
  SerialNumber:cstring,
  Description: cstring,
  Dummy: LPVOID 
  ):FT_STATUS {.stdcall, importc: "FT_GetDeviceInfo".}


#	FTD2XX_API 
#		FT_STATUS WINAPI FT_ListDevices(
#		PVOID pArg1,
#		PVOID pArg2,
#		DWORD Flags
#		);
proc FT_ListDevices*(
  pArg1: pointer,
  pArg2: pointer,
  Flags: DWORD
):FT_STATUS {.stdcall, importc: "FT_ListDevices".}

proc FT_ListDevices*(
  pArg1: cint,
  pArg2: pointer,
  Flags: DWORD
):FT_STATUS {.stdcall, importc: "FT_ListDevices".}

#	FTD2XX_API
#		FT_STATUS WINAPI FT_GetLibraryVersion(
#		LPDWORD lpdwVersion
#		);
proc FT_GetLibraryVersion*(
  lpdwVersion:LPDWORD
):FT_STATUS {.stdcall, importc: "FT_GetLibraryVersion".}


#	FTD2XX_API
#		FT_STATUS WINAPI FT_CreateDeviceInfoList(
#		LPDWORD lpdwNumDevs
#		);
proc FT_CreateDeviceInfoList*(
  lpdwNumDevs:LPDWORD
):FT_STATUS {.stdcall, importc: "FT_CreateDeviceInfoList".}


#	FTD2XX_API
#		FT_STATUS WINAPI FT_GetDeviceInfoDetail(
#		DWORD dwIndex,
#		LPDWORD lpdwFlags,
#		LPDWORD lpdwType,
#		LPDWORD lpdwID,
#		LPDWORD lpdwLocId,
#		LPVOID lpSerialNumber,
#		LPVOID lpDescription,
#		FT_HANDLE *pftHandle
#		);
proc FT_GetDeviceInfoDetail*(
  dwIndex: DWORD,
  lpdwFlags: LPDWORD,
  lpdwType: LPDWORD,
  lpdwID: LPDWORD,
  lpdwLocId: LPDWORD,
  lpSerialNumber: LPVOID,
  lpDescription: LPVOID,
  pftHandle:P_FT_HANDLE
):FT_STATUS {.stdcall, importc: "FT_GetDeviceInfoDetail".}



#	FTD2XX_API
#		FT_STATUS WINAPI FT_Read(
#		FT_HANDLE ftHandle,
#		LPVOID lpBuffer,
#		DWORD dwBytesToRead,
#		LPDWORD lpBytesReturned
#		);
proc FT_Read*(ftHandle:FT_HANDLE, lpBuffer:pointer, dwBytesToRead:culong, lpBytesReturned:ptr culong):
      FT_STATUS {.stdcall, importc: "FT_Read".}

#FT_STATUS FT_Write (FT_HANDLE ftHandle, LPVOID lpBuffer, DWORD dwBytesToWrite,LPDWORD lpdwBytesWritten)

proc FT_Write*(ftHandle:FT_HANDLE, lpBuffer:pointer, dwBytesToWrite:DWORD, 
      lpdwBytesWritten:LPDWORD):FT_STATUS {.stdcall, importc: "FT_Write".}



#		FT_STATUS WINAPI FT_SetBaudRate(
#		FT_HANDLE ftHandle,
#		ULONG BaudRate
#		);
proc FT_SetBaudRate*(ftHandle:FT_HANDLE, BaudRate: culong ): 
      FT_STATUS {.stdcall, importc: "FT_SetBaudRate".}



#		FT_STATUS WINAPI FT_SetDivisor(
#		FT_HANDLE ftHandle,
#		USHORT Divisor
#		);
proc FT_SetDivisor*(ftHandle:FT_HANDLE, Divisor: cushort): 
      FT_STATUS {.stdcall, importc: "FT_SetDivisor".}



#		FT_STATUS WINAPI FT_SetDataCharacteristics(
#		FT_HANDLE ftHandle,
#		UCHAR WordLength,
#		UCHAR StopBits,
#		UCHAR Parity
#		);
#
proc FT_SetDataCharacteristics*(ftHandle:FT_HANDLE, wordLength:uint8,
      stopBits:uint8, parity:uint8): 
      FT_STATUS {.stdcall, importc: "FT_SetDataCharacteristics".}


#		FT_STATUS WINAPI FT_SetFlowControl(
#		FT_HANDLE ftHandle,
#		USHORT FlowControl,
#		UCHAR XonChar,
#		UCHAR XoffChar
#		);
proc FT_SetFlowControl*(ftHandle:FT_HANDLE, flowControl:cushort,
      xonchar,xoffchar: uint8): 
      FT_STATUS {.stdcall, importc: "FT_SetFlowControl".}


#		FT_STATUS WINAPI FT_ResetDevice(
#		FT_HANDLE ftHandle
#		);
proc FT_ResetDevice*(ftHandle:FT_HANDLE): 
      FT_STATUS {.stdcall, importc: "FT_ResetDevice".}

#	FTD2XX_API
#		FT_STATUS WINAPI FT_SetDtr(
#		FT_HANDLE ftHandle
#		);
proc FT_SetDtr*(ftHandle:FT_HANDLE): FT_STATUS {.stdcall, importc: "FT_SetDtr".}

#	FTD2XX_API
#		FT_STATUS WINAPI FT_ClrDtr(
#		FT_HANDLE ftHandle
#		);
proc FT_ClrDtr*(ftHandle:FT_HANDLE): FT_STATUS {.stdcall, importc: "FT_ClrDtr".}

#	FTD2XX_API
#		FT_STATUS WINAPI FT_SetRts(
#		FT_HANDLE ftHandle
#		);
proc FT_SetRts*(ftHandle:FT_HANDLE): FT_STATUS {.stdcall, importc: "FT_SetRts".}

#	FTD2XX_API
#		FT_STATUS WINAPI FT_ClrRts(
#		FT_HANDLE ftHandle
#		);
proc FT_ClrRts*(ftHandle:FT_HANDLE): FT_STATUS {.stdcall, importc: "FT_ClrRts".}


#	FTD2XX_API
#		FT_STATUS WINAPI FT_GetModemStatus(
#		FT_HANDLE ftHandle,
#		ULONG *pModemStatus
#		);
proc FT_GetModemStatus*(ftHandle:FT_HANDLE, pModemStatus: ptr culong) :
      FT_STATUS {.stdcall, importc: "FT_GetModemStatus".}

#	FTD2XX_API
#		FT_STATUS WINAPI FT_SetChars(
#		FT_HANDLE ftHandle,
#		UCHAR EventChar,
#		UCHAR EventCharEnabled,
#		UCHAR ErrorChar,
#		UCHAR ErrorCharEnabled
#		);
proc FT_SetChars*(ftHandle:FT_HANDLE, eventChar,eventCharEnabled,errorChar,errorCharEnabled:uint8):
      FT_STATUS {.stdcall, importc: "FT_SetChars".}

#	FTD2XX_API
#		FT_STATUS WINAPI FT_Purge(
#		FT_HANDLE ftHandle,
#		ULONG Mask
#		);
proc FT_Purge*(ftHandle:FT_HANDLE,mask:culong): FT_STATUS {.stdcall, importc: "FT_Purge".}

#	FTD2XX_API
#		FT_STATUS WINAPI FT_SetTimeouts(
#		FT_HANDLE ftHandle,
#		ULONG ReadTimeout,
#		ULONG WriteTimeout
#		);
proc FT_SetTimeouts*(ftHandle:FT_HANDLE,readTimeout,writeTimeout:culong):
      FT_STATUS {.stdcall, importc: "FT_SetTimeouts".}

#	FTD2XX_API
#		FT_STATUS WINAPI FT_GetQueueStatus(
#		FT_HANDLE ftHandle,
#		DWORD *dwRxBytes
#		);
proc FT_GetQueueStatus*(ftHandle:FT_HANDLE, dwRxBytes:ptr culong): 
      FT_STATUS {.stdcall, importc: "FT_GetQueueStatus".}


#	FTD2XX_API
#		FT_STATUS WINAPI FT_SetEventNotification(
#		FT_HANDLE ftHandle,
#		DWORD Mask,
#		PVOID Param
#		);
proc FT_SetEventNotification*(ftHandle:FT_HANDLE,mask:culong,param:pointer):
      FT_STATUS {.stdcall, importc: "FT_SetEventNotification".}  

#	FTD2XX_API
#		FT_STATUS WINAPI FT_GetStatus(
#		FT_HANDLE ftHandle,
#		DWORD *dwRxBytes,
#		DWORD *dwTxBytes,
#		DWORD *dwEventDWord
#		);
proc FT_GetStatus*(ftHandle:FT_HANDLE, dwRxBytes,dwTxBytes,dwEventDWord:ptr culong):
      FT_STATUS {.stdcall, importc: "FT_GetStatus".}  

#	FTD2XX_API
#		FT_STATUS WINAPI FT_SetBreakOn(
#		FT_HANDLE ftHandle
#		);
proc FT_SetBreakOn*(ftHandle:FT_HANDLE): FT_STATUS {.stdcall, importc: "FT_SetBreakOn".}  


#	FTD2XX_API
#		FT_STATUS WINAPI FT_SetBreakOff(
#		FT_HANDLE ftHandle
#		);
proc FT_SetBreakOff*(ftHandle:FT_HANDLE): FT_STATUS {.stdcall, importc: "FT_SetBreakOff".}  

#	FTD2XX_API
#		FT_STATUS WINAPI FT_SetWaitMask(
#		FT_HANDLE ftHandle,
#		DWORD Mask
#		);
proc FT_SetWaitMask*(ftHandle:FT_HANDLE, mask:culong): 
      FT_STATUS {.stdcall, importc: "FT_SetWaitMask".}  

#	FTD2XX_API
#		FT_STATUS WINAPI FT_WaitOnMask(
#		FT_HANDLE ftHandle,
#		DWORD *Mask
#		);
proc FT_WaitOnMask*(ftHandle:FT_HANDLE, mask:ptr culong): 
      FT_STATUS {.stdcall, importc: "FT_WaitOnMask".}  

#	FTD2XX_API
#		FT_STATUS WINAPI FT_GetEventStatus(
#		FT_HANDLE ftHandle,
#		DWORD *dwEventDWord
#		);
proc FT_GetEventStatus*(ftHandle:FT_HANDLE, dwEventDWord:ptr culong):
      FT_STATUS {.stdcall, importc: "FT_GetEventStatus".}  



#	FTD2XX_API
#		FT_STATUS WINAPI FT_ReadEE(
#		FT_HANDLE ftHandle,
#		DWORD dwWordOffset,
#		LPWORD lpwValue
#		);
#
#	FTD2XX_API
#		FT_STATUS WINAPI FT_WriteEE(
#		FT_HANDLE ftHandle,
#		DWORD dwWordOffset,
#		WORD wValue
#		);
#
#	FTD2XX_API
#		FT_STATUS WINAPI FT_EraseEE(
#		FT_HANDLE ftHandle
#		);

#	FTD2XX_API
#		FT_STATUS WINAPI FT_SetLatencyTimer(
#		FT_HANDLE ftHandle,
#		UCHAR ucLatency
#		);
proc FT_SetLatencyTimer*(ftHandle:FT_HANDLE, ucLatency:uint8):
      FT_STATUS {.stdcall, importc: "FT_SetLatencyTimer".}  

#	FTD2XX_API
#		FT_STATUS WINAPI FT_GetLatencyTimer(
#		FT_HANDLE ftHandle,
#		PUCHAR pucLatency
#		);
proc FT_GetLatencyTimer*(ftHandle:FT_HANDLE, pucLatency:ptr uint8):
      FT_STATUS {.stdcall, importc: "FT_GetLatencyTimer".}  

#		FT_STATUS WINAPI FT_SetBitMode(
#		FT_HANDLE ftHandle,
#		UCHAR ucMask,
#		UCHAR ucEnable
#		);
proc FT_SetBitMode*(ftHandle:FT_HANDLE, ucMask:uint8, ucEnable:uint8) : 
      FT_STATUS {.stdcall, importc: "FT_SetBitMode".}

#		FT_STATUS WINAPI FT_GetBitMode(
#		FT_HANDLE ftHandle,
#		PUCHAR pucMode
#		);
proc FT_GetBitMode*(ftHandle:FT_HANDLE, pucMode:ptr uint8) : 
      FT_STATUS {.stdcall, importc: "FT_GetBitMode".}

#	FTD2XX_API
#		FT_STATUS WINAPI FT_SetUSBParameters(
#		FT_HANDLE ftHandle,
#		ULONG ulInTransferSize,
#		ULONG ulOutTransferSize
#		);
proc FT_SetUSBParameters*(ftHandle:FT_HANDLE,ulInTransferSize,ulOutTransferSize:culong):
      FT_STATUS {.stdcall, importc: "FT_SetUSBParameters".}

#	FTD2XX_API
#		FT_STATUS WINAPI FT_SetDeadmanTimeout(
#		FT_HANDLE ftHandle,
#		ULONG ulDeadmanTimeout
#		);
proc FT_SetDeadmanTimeout*(ftHandle:FT_HANDLE,ulDeadmanTimeout:culong):
      FT_STATUS {.stdcall, importc: "FT_SetDeadmanTimeout".}  

{.pop.}




if isMainModule:
  var ftHandle: FT_HANDLE
  var ftStatus: FT_STATUS
  var ftDevice: FT_DEVICE 
  var deviceID: DWORD 
  var serialNumber = newString(MAX_DESCRIPTION_SIZE).cstring
  var description = newString(MAX_DESCRIPTION_SIZE).cstring

  ftStatus = FT_Open(0,addr ftHandle)
  if FTDeviceStatus(ftStatus) != FT_OK:
    echo FTDeviceStatus(ftStatus)
    echo "Error happned"

  else:
    
    ftStatus = FT_GetDeviceInfo(ftHandle,addr ftDevice,addr deviceID, serialNumber, description,nil)
    echo FTDeviceType(ftDevice)

    echo serialNumber
    echo description

