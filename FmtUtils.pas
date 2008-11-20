unit FmtUtils;

interface

uses
  SysUtils;

const
  UNIT_BYTES = 1024;
  MAX_UNITS = 6;
  UNITS_STRING: array[0..MAX_UNITS] of string = ('B', 'KB', 'MB', 'GB', 'TB', 'PB', 'EB');
  DEFAULT_BYTES_FORMAT = '%f %s';

function Int64Power(Base: UInt64; Exponent: Integer): UInt64;
function DetectUnit(Value: UInt64): Integer;
function DetectUnitStr(Value: UInt64): string;
function DetectUnitValue(Value: UInt64): Extended;
function FormatByte(Value: UInt64; Fmt: string = '%f %s'): string;
function CalcBytes(Value: UInt64; UnitValue: Integer): UInt64;

implementation

function Int64Power(Base: UInt64; Exponent: Integer): UInt64;
var
  i: Integer;
begin
  Result := 1;
  for i := 0 to Exponent - 1 do
    Result := Result * Base;
end;

function DetectUnit(Value: UInt64): Integer;
begin
  for Result := 0 to MAX_UNITS do
  begin
    if Value < UNIT_BYTES then Break;
    Value := Value div UNIT_BYTES;
  end;
end;

function DetectUnitStr(Value: UInt64): string;
begin
  Result := UNITS_STRING[DetectUnit(Value)];
end;

function DetectUnitValue(Value: UInt64): Extended;
begin
  Result := Value / Int64Power(UNIT_BYTES, DetectUnit(Value));
end;

function FormatByte(Value: UInt64; Fmt: string = DEFAULT_BYTES_FORMAT): string;
begin
  Result := Format(Fmt, [DetectUnitValue(Value), DetectUnitStr(Value)]);
end;

function CalcBytes(Value: UInt64; UnitValue: Integer): UInt64;
begin
  Result := Value * Int64Power(UNIT_BYTES, UnitValue);
end;

end.
