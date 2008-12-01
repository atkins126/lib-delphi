unit FuncTools;

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
  Generics.Collections;

type
  TFunc<T> = reference to function (Value: T): T;
  TFunc2<T> = reference to function (Base, Value: T): T;

  TFuncTools<T> = class
  public
    class function Map(Func: TFunc<T>; const List: TList<T>): TList<T>;
    class function Reduce(Func: TFunc2<T>; const List: TList<T>): T;
  end;

implementation

class function TFuncTools<T>.Map(Func: TFunc<T>; const List: TList<T>): TList<T>;
var
  Value: T;
begin
  Result := TList<T>.Create;
  for Value in List do
    Result.Add(Func(Value));
end;

class function TFuncTools<T>.Reduce(Func: TFunc2<T>; const List: TList<T>): T;
var
  I: Integer;
begin
  Result := List[0];
  for I := 1 to List.Count - 1 do
    Result := Func(Result, List[I]);
end;

end.
