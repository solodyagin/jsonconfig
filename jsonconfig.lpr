library jsonconfig;

{$mode objfpc}{$H+}

uses
  Classes, SysUtils, Math, fpjson, jsonConf;

  function JSONReadString(AFileName, APath, ADefault: PWideChar; var AValue: PWideChar; var AValueLength: Integer): Boolean; stdcall;
  var
    len: Integer;
    s: String;
  begin
    Result := False;
    if not FileExists(AFileName) then Exit;
    with TJSONConfig.Create(nil) do
    begin
      try
        Filename := AFileName;
        len := Min(Length(String(ADefault)), AValueLength);
        StrLCopy(AValue, ADefault, len);
        s := GetValue(String(APath), ADefault);
        AValueLength := Min(AValueLength, Length(s));
        if Assigned(AValue) and (AValueLength > 0) then
          StrPLCopy(AValue, s, AValueLength);
        Result := True;
      except
      end;
      Free;
    end;
  end;

  function JSONReadBoolean(AFileName, APath: PWideChar; ADefault: Boolean; var AValue: Boolean): Boolean; stdcall;
  begin
    Result := False;
    if not FileExists(AFileName) then Exit;
    with TJSONConfig.Create(nil) do
    begin
      try
        Filename := AFileName;
        AValue := GetValue(String(APath), ADefault);
        Result := True;
      except
      end;
      Free;
    end;
  end;

  function JSONReadInteger(AFileName, APath: PWideChar; ADefault: Int64; var AValue: Int64): Boolean; stdcall;
  begin
    Result := False;
    if not FileExists(AFileName) then Exit;
    with TJSONConfig.Create(nil) do
    begin
      try
        Filename := AFileName;
        AValue := GetValue(String(APath), ADefault);
        Result := True;
      except
      end;
      Free;
    end;
  end;

  function JSONWriteString(AFileName, APath, AValue: PWideChar): Boolean; stdcall;
  begin
    Result := False;
    if not FileExists(AFileName) then Exit;
    with TJSONConfig.Create(nil) do
    begin
      try
        Filename := AFileName;
        Formatted := True;
        FormatOptions := [{foUseTabchar,} foSkipWhiteSpace, foSkipWhiteSpaceOnlyLeading];
        SetValue(String(APath), String(AValue));
        Result := True;
      except
      end;
      Free;
    end;
  end;

  function JSONWriteBoolean(AFileName, APath: PWideChar; AValue: Boolean): Boolean; stdcall;
  begin
    Result := False;
    if not FileExists(AFileName) then Exit;
    with TJSONConfig.Create(nil) do
    begin
      try
        Filename := AFileName;
        Formatted := True;
        FormatOptions := [{foUseTabchar,} foSkipWhiteSpace, foSkipWhiteSpaceOnlyLeading];
        SetValue(String(APath), AValue);
        Result := True;
      except
      end;
      Free;
    end;
  end;

  function JSONWriteInteger(AFileName, APath: PWideChar; AValue: Int64): Boolean; stdcall;
  begin
    Result := False;
    if not FileExists(AFileName) then Exit;
    with TJSONConfig.Create(nil) do
    begin
      try
        Filename := AFileName;
        Formatted := True;
        FormatOptions := [{foUseTabchar,} foSkipWhiteSpace, foSkipWhiteSpaceOnlyLeading];
        SetValue(String(APath), AValue);
        Result := True;
      except
      end;
      Free;
    end;
  end;

exports
  JSONReadString,
  JSONReadBoolean,
  JSONReadInteger,
  JSONWriteString,
  JSONWriteBoolean,
  JSONWriteInteger;

end.
