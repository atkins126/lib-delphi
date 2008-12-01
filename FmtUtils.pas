unit FmtUtils;

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
