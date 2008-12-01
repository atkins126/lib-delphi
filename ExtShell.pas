unit ExtShell;

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
  Windows, SysUtils, Registry, ShellAPI;

procedure RefreshSystemIcon;
procedure ShellOpen(FileName: string; Directory: string = ''; hWnd: HWND = 0);

implementation

procedure RefreshSystemIcon;
const
  REG_DESKTOP_ICON_SIZE = 'Control Panel\Desktop\WindowMetrics';
  KEY_SHEEL_ICON_SIZE = 'Shell Icon Size';
var
  Registry: TRegistry;
  IconSize: Integer;

  procedure NotifyChange;
  var
    IconMetrics: TIconMetrics;
  begin
    IconMetrics.cbSize := SizeOf(TIconMetrics);
    SystemParametersInfo(SPI_GETICONMETRICS, 0, @IconMetrics, 0);
    SystemParametersInfo(SPI_SETICONMETRICS, 0, @IconMetrics,
        SPIF_UPDATEINIFILE or SPIF_SENDWININICHANGE);
  end;

begin
  Registry := TRegistry.Create;
  try
    Registry.OpenKey(REG_DESKTOP_ICON_SIZE, False);
    IconSize := StrToIntDef(Registry.ReadString('Shell Icon Size'), 32);
    Registry.WriteString(KEY_SHEEL_ICON_SIZE, IntToStr(IconSize - 1));
    NotifyChange;
    Registry.WriteString(KEY_SHEEL_ICON_SIZE, IntToStr(IconSize));
    NotifyChange;
  finally
    Registry.Free;
  end;
end;

procedure ShellOpen(FileName: string; Directory: string = ''; hWnd: HWND = 0);
var
  DirectoryPointer: PChar;
begin
  if Directory <> '' then
    DirectoryPointer := PChar(Directory)
  else
    DirectoryPointer := nil;
  ShellExecute(hWnd, 'open', PChar(FileName), nil, DirectoryPointer, SW_NORMAL);
end;

end.