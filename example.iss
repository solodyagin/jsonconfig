[Setup]
AppName=Example
AppVersion=1.0
DefaultDirName={commonpf}\Example

[Files]
Source: "jsonconfig.dll"; Flags: dontcopy
Source: "example.json"; DestDir: "{tmp}"; Flags: dontcopy

[Code]
function JSONReadString(AFileName, APath, ADefault: WideString; var AValue: WideString; var AValueLength: Integer): Boolean;
	external 'JSONReadString@files:jsonconfig.dll stdcall';
function JSONReadBoolean(AFileName, APath: WideString; ADefault: Boolean; var AValue: Boolean): Boolean;
	external 'JSONReadBoolean@files:jsonconfig.dll stdcall';
function JSONReadInteger(AFileName, APath: WideString; ADefault: Int64; var AValue: Int64): Boolean;
	external 'JSONReadInteger@files:jsonconfig.dll stdcall';
function JSONWriteString(AFileName, APath, AValue: WideString): Boolean;
	external 'JSONWriteString@files:jsonconfig.dll stdcall';
function JSONWriteBoolean(AFileName, APath: WideString; AValue: Boolean): Boolean;
	external 'JSONWriteBoolean@files:jsonconfig.dll stdcall';
function JSONWriteInteger(AFileName, APath: WideString; AValue: Int64): Boolean;
	external 'JSONWriteInteger@files:jsonconfig.dll stdcall';

function BoolToStr(Value: Boolean): String;
begin
	Result := 'True';
	if not Value then
		Result := 'False';
end;

procedure AddToRTF(var Res: String; FuncName: String; Path: String; Value: String; Ok: Boolean);
begin
	if Ok then
		Res := Res + Format('{\i %s}: {\b %s} = {\cf1 %s}\line', [FuncName, Path, Value])
	else
		Res := Res + Format('{\i %s}: {\b %s} = {\cf2 %s}\line', [FuncName, Path, Value]);
	Res := Res + #13#10;
end;

var
	Page: TOutputMsgMemoWizardPage;

procedure InitializeWizard;
var
	rtf: String;
	fileName: WideString;
	strVal: WideString;
	strLen: Integer;
	intVal: Int64;
	boolVal: Boolean;
begin
	Page := CreateOutputMsgMemoPage(wpWelcome, 'Information', 'Display results', '', '');
	Page.RichEditViewer.UseRichEdit := True;

	ExtractTemporaryFile('example.json')
	fileName := ExpandConstant('{tmp}\example.json');

	rtf := '{\rtf1{\colortbl;\red0\green0\blue255;\red255\green0\blue0;}';

	// Read
	SetLength(strVal, 256);
	strLen := Length(strVal);
	if JSONReadString(fileName, '/str', 'default', strVal, strLen) then
		AddToRTF(rtf, 'JSONReadString', 'str', Copy(strVal, 1, strLen), True)
	else
		AddToRTF(rtf, 'JSONReadString', 'str', 'failed', False);

	rtf := rtf + '\line' + #13#10;

	SetLength(strVal, 256);
	strLen := Length(strVal);
	if JSONReadString(fileName, '/foo/str', 'default', strVal, strLen) then
		AddToRTF(rtf, 'JSONReadString', 'foo.str', Copy(strVal, 1, strLen), True)
	else
		AddToRTF(rtf, 'JSONReadString', 'foo.str', 'failed', False);

	if JSONReadInteger(fileName, '/foo/int', 0, intVal) then
		AddToRTF(rtf, 'JSONReadInteger', 'foo.int', IntToStr(intVal), True)
	else
		AddToRTF(rtf, 'JSONReadInteger', 'foo.int', 'failed', False);
		
	if JSONReadBoolean(fileName, '/bar/bool', True, boolVal) then
		AddToRTF(rtf, 'JSONReadBoolean', 'bar.bool', BoolToStr(boolVal), True)
	else
		AddToRTF(rtf, 'JSONReadBoolean', 'bar.bool', 'failed', False);

	rtf := rtf + '\line' + #13#10;

	// Write
	SetLength(strVal, 256);
	strLen := Length(strVal);
	if JSONWriteString(fileName, '/foo/str', 'InnoSetup') and JSONReadString(fileName, '/foo/str', 'default', strVal, strLen) then
		AddToRTF(rtf, 'JSONWriteString', 'foo.str', Copy(strVal, 1, strLen), True)	
	else
		AddToRTF(rtf, 'JSONWriteString', 'foo.str', 'failed', False);

	if JSONWriteInteger(fileName, '/foo/int', 3) and JSONReadInteger(fileName, '/foo/int', 0, intVal) then
		AddToRTF(rtf, 'JSONWriteInteger', 'foo.int', IntToStr(intVal), True)
	else
		AddToRTF(rtf, 'JSONWriteInteger', 'foo.int', 'failed', False);

	if JSONWriteBoolean(fileName, '/bar/bool', True) and JSONReadBoolean(fileName, '/bar/bool', True, boolVal) then
		AddToRTF(rtf, 'JSONWriteBoolean', 'bar.bool', BoolToStr(boolVal), True)
	else
		AddToRTF(rtf, 'JSONWriteBoolean', 'bar.bool', 'failed', False);

	rtf := rtf + '}';

	Page.RichEditViewer.RTFText := rtf;
end;

function NextButtonClick(CurPageID: Integer): Boolean;
begin
	Result := not (CurPageID = Page.ID);
end;