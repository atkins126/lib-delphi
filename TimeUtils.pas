unit TimeUtils;

interface

uses
  Windows,
  Classes,
  SysUtils;

function DateTimeToFileTime(Src: TDatetime): TFileTime;

implementation

function DateTimeToFileTime(Src: TDatetime): TFileTime;
var
  SysTime: TSystemTime;
begin
  DateTimeToSystemTime(Src, SysTime);
  SystemTimeToFileTime(SysTime, Result);
end;

end.
