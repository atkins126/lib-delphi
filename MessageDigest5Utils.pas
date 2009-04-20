unit MessageDigest5Utils;

interface

uses
  SysUtils,
  Classes,
  IdGlobal,
  IdHash,
  IdHashMessageDigest;

function MD5FromString(AString: string): string;

implementation

function MD5FromString(AString: string): string;
var
  md5: TIdHashMessageDigest5;
  stream: TStream;
begin
  md5 := TIdHashMessageDigest5.Create;
  try
    stream := TMemoryStream.Create;
    try
      WriteStringToStream(stream, AString, enUTF8);
      stream.Position := 0;
      Result := LowerCase(md5.HashStreamAsHex(stream));
    finally
      FreeAndNil(stream);
    end;
  finally
    FreeAndNil(md5);
  end;
end;

end.
