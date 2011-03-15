unit UCommonFuncs;

interface

uses
  Classes;

procedure ChangePassword(theHost: PChar; thePort: Word; theProtocol, theUser, theAtHost, OldPass, NewPass: PChar); stdcall;
procedure ChangeRootPassword(OldPass, NewPass: PChar); stdcall;
function CompareVersions4(VersionA, VersionB: PChar): ShortInt; stdcall;
function CompareVersions3(VersionA, VersionB: PChar): ShortInt; stdcall;
function CompareVersions2(VersionA, VersionB: PChar): ShortInt; stdcall;
function GetMySQLProtocolNames: PChar; stdcall;

implementation

uses
  ZDbcIntfs, ZConnection, ZSqlProcessor, SysUtils;

function CompareVersions4;
var
	VA, VB: Word;
	i: 0..3;
	InternalVersionA, InternalVersionB: ShortString;
begin
	Result := 0;
	InternalVersionA := VersionA + '.';
	InternalVersionB := VersionB + '.';

	for i := 0 to 3 do
	begin
		VA := StrToInt(Copy(InternalVersionA,1,Pos('.',InternalVersionA) - 1));
		VB := StrToInt(Copy(InternalVersionB,1,Pos('.',InternalVersionB) - 1));

		if VA > VB then
		begin
			Result := -1;
			Break;
		end
		else if VA < VB then
		begin
			Result := 1;
			Break;
		end;

		Delete(InternalVersionA,1,Pos('.',InternalVersionA));
		Delete(InternalVersionB,1,Pos('.',InternalVersionB));
	end;
end;

function CompareVersions3;
var
	VA, VB: Word;
	i: 0..2;
	InternalVersionA, InternalVersionB: ShortString;
begin
	Result := 0;
	InternalVersionA := VersionA + '.';
	InternalVersionB := VersionB + '.';

	for i := 0 to 2 do
	begin
		VA := StrToInt(Copy(InternalVersionA,1,Pos('.',InternalVersionA) - 1));
		VB := StrToInt(Copy(InternalVersionB,1,Pos('.',InternalVersionB) - 1));

		if VA > VB then
		begin
			Result := -1;
			Break;
			end
		else if VA < VB then
		begin
			Result := 1;
			Break;
		end;

		Delete(InternalVersionA,1,Pos('.',InternalVersionA));
		Delete(InternalVersionB,1,Pos('.',InternalVersionB));
	end;
end;

function CompareVersions2;
var
	VA, VB: Word;
	i: 0..1;
	InternalVersionA, InternalVersionB: ShortString;
begin
	Result := 0;
	InternalVersionA := VersionA + '.';
	InternalVersionB := VersionB + '.';

	for i := 0 to 1 do
	begin
		VA := StrToInt(Copy(InternalVersionA,1,Pos('.',InternalVersionA) - 1));
		VB := StrToInt(Copy(InternalVersionB,1,Pos('.',InternalVersionB) - 1));

		if VA > VB then
		begin
			Result := -1;
			Break;
			end
		else if VA < VB then
		begin
			Result := 1;
			Break;
		end;

		Delete(InternalVersionA,1,Pos('.',InternalVersionA));
		Delete(InternalVersionB,1,Pos('.',InternalVersionB));
	end;
end;
{$hints off}
procedure ChangePassword;
var
	theConnection: TZConnection;
	Processor: TZSQLProcessor;
begin
	theConnection := nil;
	Processor := nil;
	try
		theConnection := TZConnection.Create(nil);
		with theConnection do
		begin
			Protocol := theProtocol;
			HostName := theHost;
			Port     := thePort;
			Database := ''; //Nenhuma database
			User     := theUser;
			Password := OldPass;
			TransactIsolationLevel := tiReadCommitted;
			SQLHourGlass := True;
		end;

		try
			theConnection.Connect;

			Processor := TZSQLProcessor.Create(theConnection);
			with Processor do
			begin
				Connection := theConnection;
				ParamCheck := False;
				Script.Text := 'SET PASSWORD FOR ' + QuotedStr(theUser) + '@' + QuotedStr(theAtHost) + ' = PASSWORD(' + QuotedStr(NewPass) + ');';
			end;

			Processor.Execute;
		except
			on E: Exception do
				raise Exception.Create('Um erro ocorreu na função "ChangePassword"'#13#10'Detalhes:'#13#10 + E.Message) at @ChangePassword;
//				MessageBox(0,PChar(E.Message),'',0);
		end;
	finally
		theConnection.Free; // Já se encarrega de destruir seus filhos
	end;
end;
{$hints on}

procedure ChangeRootPassword(OldPass, NewPass: PChar);
begin
	ChangePassword('127.0.0.1',3306,'mysql-5','root','localhost',OldPass,NewPass);
end;

function GetMySQLProtocolNames;
var
	theConnection: TZConnection;
	theProtocolNames: TStringList;
	Cursor, Eol: Byte;
begin
	theConnection := nil;
	theProtocolNames := nil;
	try
		theConnection := TZConnection.Create(nil);
		theProtocolNames := TStringList.Create;
		theConnection.GetProtocolNames(theProtocolNames);
		Cursor := 0;
		Eol := Pred(theProtocolNames.Count);
		repeat
			if Pos('mysql',LowerCase(theProtocolNames[Cursor])) = 0 then
			begin
				theProtocolNames.Delete(Cursor);
				Eol := Pred(theProtocolNames.Count);
			end
			else
				Inc(Cursor);
		until Cursor > Eol;
		Result := PChar(theProtocolNames.Text);
	finally
		theProtocolNames.Free;
		theConnection.Free;
	end;
end;

//function GetTickCount;
//begin
//	Result := GetTickCount;
//end;

end.
