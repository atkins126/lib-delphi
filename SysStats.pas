unit SysStats;

{
Copyright (c) 2008, Shinya Okano<xxshss@yahoo.co.jp>
All rights reserved.

Redistribution and use in source and binary forms, with or without
modification, are permitted provided that the following conditions
are met:

1. Redistributions of source code must retain the above copyright
   notice, this list of conditions and the following disclaimer

2. Redistributions in binary form must reproduce the above copyright
   notice, this list of conditions and the following disclaimer in the
   documentation and/or other materials provided with the distribution.

3. Neither the name of the authors nor the names of its contributors
   may be used to endorse or promote products derived from this
   software without specific prior written permission.

THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS
"AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT
LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR
A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT
OWNER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL,
SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED
TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR
PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF
LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING
NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS
SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.

--
license: New BSD License
web: http://www.bitbucket.org/tokibito/lib_delphi/overview/
}

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
function GetVolumeName(DriveLetter: Char): string;
function GetRemoteVolumeName(DriveLetter: Char): string;
function GetVersionInformation: TOSVersionInfo;

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

function GetVolumeName(DriveLetter: Char): string;
var
  MaxComponentLength, VolumeFlags: Cardinal;
  VolumeNameBuffer: array [0..255] of Char;
begin
  if GetVolumeInformation(PChar(DriveLetter + ':\'), VolumeNameBuffer,
      SizeOf(VolumeNameBuffer), nil, MaxComponentLength, VolumeFlags, nil, 0) then
    Result := VolumeNameBuffer
  else
    Result := '';
end;

function GetRemoteVolumeName(DriveLetter: Char): string;
var
  VolumeNameBuffer: array [0..255] of Char;
  BufferSize: Cardinal;
begin
  BufferSize := SizeOf(VolumeNameBuffer);
  if WNetGetConnection(PChar(DriveLetter + ':'), VolumeNameBuffer,
      BufferSize) = NO_ERROR then
    Result := VolumeNameBuffer
  else
    Result := '';
end;

function GetVersionInformation: TOSVersionInfo;
begin
  Result.dwOSVersionInfoSize := SizeOf(TOSVersionInfo);
  GetVersionEx(Result);
end;

end.
