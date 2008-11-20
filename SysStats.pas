unit SysStats;

interface

uses
  Windows, SysUtils;

type
  TDiskSpace = record
    Directory: string;
    FreeAvailable: UInt64;
    TotalSpace: UInt64;
    TotalFree: UInt64;
  end;

function GetMemoryStatus: TMemoryStatusEx;
function GetAvailableMemory(Phy: Boolean = True): UInt64;
function GetTotalMemory(Phy: Boolean = True): UInt64;
function GetUsedMemory(Phy: Boolean = True): UInt64;
function GetDiskSpace(Directory: string): TDiskSpace;
function GetAvailableDiskSpace(Directory: string): UInt64;
function GetTotalDiskSpace(Directory: string): UInt64;
function GetUsedDiskSpace(Directory: string): UInt64;
function GetSystemInformation: TSystemInfo;
function GetProcessorCount: Cardinal;
function GetProcessorType: Cardinal;

implementation

function GetMemoryStatus: TMemoryStatusEx;
begin
  Result.dwLength := SizeOf(TMemoryStatusEx);
  GlobalMemoryStatusEx(Result);
end;

function GetAvailableMemory(Phy: Boolean = True): UInt64;
begin
  if Phy then
    Result := GetMemoryStatus.ullAvailPhys
  else
    Result := GetMemoryStatus.ullAvailVirtual;
end;

function GetTotalMemory(Phy: Boolean = True): UInt64;
begin
  if Phy then
    Result := GetMemoryStatus.ullTotalPhys
  else
    Result := GetMemoryStatus.ullTotalVirtual;
end;

function GetUsedMemory(Phy: Boolean = True): UInt64;
begin
  Result := GetTotalMemory(Phy) - GetAvailableMemory(Phy);
end;

function GetDiskSpace(Directory: string): TDiskSpace;
var
  FreeAvailable, TotalSpace, TotalFree: TLargeInteger;
begin
  GetDiskFreeSpaceEx(PChar(Directory), FreeAvailable, TotalSpace, @TotalFree);

  Result.Directory := Directory;
  Result.FreeAvailable := FreeAvailable;
  Result.TotalSpace := TotalSpace;
  Result.TotalFree := TotalFree;
end;

function GetAvailableDiskSpace(Directory: string): UInt64;
begin
  Result := GetDiskSpace(Directory).FreeAvailable;
end;

function GetTotalDiskSpace(Directory: string): UInt64;
begin
  Result := GetDiskSpace(Directory).TotalSpace;
end;

function GetUsedDiskSpace(Directory: string): UInt64;
begin
  Result := GetTotalDiskSpace(Directory) - GetAvailableDiskSpace(Directory);
end;

function GetSystemInformation: TSystemInfo;
begin
  GetSystemInfo(Result);
end;

function GetProcessorCount: Cardinal;
begin
  Result := GetSystemInformation.dwNumberOfProcessors;
end;

function GetProcessorType: Cardinal;
begin
  Result := GetSystemInformation.dwProcessorType;
end;

end.
