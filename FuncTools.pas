unit FuncTools;

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
