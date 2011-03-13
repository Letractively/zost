unit UFuncoes;

interface

uses

  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms,
  Dialogs, XPMan, StdCtrls, CommCtrl, ComCtrls, ExtCtrls, ToolWin, ImgList,
  Buttons, DB, DBClient, IdFTPList, ShellApi, IniFiles, TLHelp32, PsAPI;



const
  NIF_INFO = $10;
  NIF_MESSAGE = 1;
  NIF_ICON = 2;
  NOTIFYICON_VERSION = 3;
  NIF_TIP = 4;
  NIM_SETVERSION = $00000004;
  NIM_SETFOCUS = $00000003;
  NIIF_INFO = $00000001;
  NIIF_WARNING = $00000002;
  NIIF_ERROR = $00000003;
  NIN_BALLOONSHOW = WM_USER + 2;
  NIN_BALLOONHIDE = WM_USER + 3;
  NIN_BALLOONTIMEOUT = WM_USER + 4;
  NIN_BALLOONUSERCLICK = WM_USER + 5;
  NIN_SELECT = WM_USER + 0;
  NINF_KEY = $1;
  NIN_KEYSELECT = NIN_SELECT or NINF_KEY;
  TRAY_CALLBACK = WM_USER + $7258;

type
  PNewNotifyIconData = ^TNewNotifyIconData;
  TDUMMYUNIONNAME    = record
    case Integer of
      0: (uTimeout: UINT);
      1: (uVersion: UINT);
  end;

  TNewNotifyIconData = record
    cbSize: DWORD;
    Wnd: HWND;
    uID: UINT;
    uFlags: UINT;
    uCallbackMessage: UINT;
    hIcon: HICON;
    szTip: array [0..127] of Char;
    dwState: DWORD;
    dwStateMask: DWORD;
    szInfo: array [0..255] of Char;
    DUMMYUNIONNAME: TDUMMYUNIONNAME;
    szInfoTitle: array [0..63] of Char;
    dwInfoFlags: DWORD;
  end;

type
  TFuncoes = Class(TObject)

published
  procedure LerIniFile;
  function ArquivoLixeira(NomeArq: string): Boolean;
  function DataArquivo(NomeArq: string): string;
  function Cripto(Texto: String): String;
  function DesCripto(Texto: String): String;
  function ValorAsc(Letra: String): Byte;
  function DefineDataHoraArq( Path_E_NomeArq: string; DataHora: TDateTime ): boolean;
  procedure ListaDir(NumSis:string; NomeAplicativo: string; DirLocal, DirRemoto: TStringList);
  function ExecutavelRodando(sFile: String): Boolean;
  function TamanhoArquivo(Arquivo: string): Integer;
  function TerminarProcesso(sFile: String): Boolean;
  procedure SetaIniFile(Heder,variavel, valor:string);
public
  iLogin, iSenha, iIP, iAtualizaMPSDist: string;
  iQtdeSistemas: integer;
  Sistema: array[1..3] of String;

private

end;


var
  Funcoes: TFuncoes;

implementation

uses uPrinc;

{ TFuncoes }


function TFuncoes.DataArquivo(NomeArq: string): string;
begin
  try
    Result := FormatDateTime('dd/mm/yyyy hh:mm',FileDateToDateTime(FileAge(NomeArq)));
  except
    Result := '' ;
  end;
end;

function TFuncoes.ArquivoLixeira(NomeArq: string): Boolean;
var
  Op:  TSHFileOpStruct;
begin

  if not FileExists(NomeArq) then
  begin
    Result := False;
    Exit;
  end;

  FillChar(Op, SizeOf(Op), 0);
  with Op do
  begin
    wFunc := FO_DELETE;
    pFrom := PChar(NomeArq);
    fFlags := FOF_ALLOWUNDO or FOF_NOCONFIRMATION or FOF_SILENT;
  end;
  Result := ShFileOperation(Op) = 0;

end;

function TFuncoes.ValorAsc(Letra: String): Byte;
begin
  if Length(letra) > 0 then
    ValorAsc := Ord(Letra[1]) else ValorAsc := 0;
end;

Function TFuncoes.DefineDataHoraArq( Path_E_NomeArq: string; DataHora: TDateTime ): boolean;
var
F: integer;
Begin
 Result := false;
 F := FileOpen(Path_E_NomeArq, fmOpenWrite or fmShareDenyNone);

 Try
 If F > 0 then
    Result := FileSetDate(F, DateTimeToFileDate(DataHora)) = 0;
  finally
  FileClose(F);

End;
End;

function TFuncoes.ExecutavelRodando(sFile: String): Boolean;
var
hdlSnap,hdlProcess: THandle;
bPath,bLoop: Bool;
peEntry: TProcessEntry32;
Resultado:Boolean;
begin
  Result:=False;
  Resultado:=False;
  hdlSnap:=CreateToolhelp32Snapshot(TH32CS_SNAPPROCESS, 0);
  peEntry.dwSize:=Sizeof(peEntry);
  bLoop:=Process32First(hdlSnap,peEntry);
  while integer(bLoop)<>0 do
     begin
       if ((UpperCase(ExtractFileName(peEntry.szExeFile)) = UpperCase(sFile)) or
          (UpperCase(peEntry.szExeFile) = UpperCase(sFile))) then
           Resultado:=True;
       bLoop := Process32Next(hdlSnap,peEntry);
     End;
     
Result:=Resultado;
CloseHandle(hdlSnap);
end;

function TFuncoes.Cripto(Texto: String): String;
var
  Cont, Cod: Integer;
  Retorna: String;
begin
  for Cont := 1 to Length(Texto) do
  begin
    Cod := ValorAsc(Copy(Texto, Cont, 1));
    Retorna := Retorna + Chr(Cod + 57);
  end;
  Cripto := Retorna;
end;

procedure TFuncoes.SetaIniFile(Heder,variavel, valor:string);
var
  ArqIni : TIniFile;
begin
  ArqIni   := TIniFile.Create(ExtractFilePath(Application.ExeName) + 'mps.ini');
  try
    ArqIni.WriteString(Heder, variavel, valor);
  Finally
    ArqIni.Free;
  end;

end;


function TFuncoes.TamanhoArquivo(Arquivo: string): Integer;
begin
  with TFileStream.Create(Arquivo, fmOpenRead or fmShareExclusive) do
  try
    Result := Size;
  finally
   Free;
  end;
end;



function TFuncoes.DesCripto(Texto: String): String;
var
  Cont, Cod: integer;
  Retorna: String;
begin
  for Cont := 1 to Length(Texto) do
  begin
    Cod := ValorAsc(Copy(Texto, Cont, 1));
    Retorna := Retorna + Chr(Cod - 57);
  end;
  DesCripto := Retorna;
end;

procedure TFuncoes.LerIniFile;
var
  ArqIni : TIniFile;
begin
  ArqIni   := TIniFile.Create(ExtractFilePath(Application.ExeName) + 'mps.ini');
  try
    iLogin          := ArqIni.ReadString('conexao', 'login', '');
    iSenha          := ArqIni.ReadString('conexao', 'senha', '');
    iIP             := ArqIni.ReadString('conexao', 'ip', '');
    iQtdeSistemas   := StrToInt(ArqIni.ReadString('conexao', 'NumSis', ''));
    Sistema[1]      := ArqIni.ReadString('0', 'sistema', '');
    Sistema[2]      := ArqIni.ReadString('1', 'sistema', '');
    Sistema[3]      := ArqIni.ReadString('2', 'sistema', '');
    iAtualizaMPSDist := ArqIni.ReadString('opcoes','atualizampsdist','');
  Finally
    ArqIni.Free;
  end;

end;

function TFuncoes.TerminarProcesso(sFile: String): Boolean;
var
verSystem: TOSVersionInfo; 
hdlSnap,hdlProcess: THandle; 
bPath,bLoop: Bool; 
peEntry: TProcessEntry32; 
arrPid: Array [0..1023] of DWORD; 
iC: DWord; 
k,iCount: Integer; 
arrModul: Array [0..299] of Char; 
hdlModul: HMODULE; 
begin 
Result := False; 
if ExtractFileName(sFile)=sFile then 
bPath:=false
else 
bPath:=true; 
verSystem.dwOSVersionInfoSize:=SizeOf(TOSVersionInfo); 
GetVersionEx(verSystem); 
if verSystem.dwPlatformId=VER_PLATFORM_WIN32_WINDOWS then 
begin 
hdlSnap:=CreateToolhelp32Snapshot(TH32CS_SNAPPROCESS, 0); 
peEntry.dwSize:=Sizeof(peEntry); 
bLoop:=Process32First(hdlSnap,peEntry); 
while integer(bLoop)<>0 do 
begin 
if bPath then 
begin 
if CompareText(peEntry.szExeFile,sFile) = 0 then 
begin
TerminateProcess(OpenProcess(PROCESS_TERMINATE,false,peEntry.th32ProcessID), 0); 
Result := True; 
end; 
end
else 
begin 
if CompareText(ExtractFileName(peEntry.szExeFile),sFile) = 0 then 
begin
TerminateProcess(OpenProcess(PROCESS_TERMINATE,false,peEntry.th32ProcessID), 0); 
Result := True; 
end; 
end; 
bLoop := Process32Next(hdlSnap,peEntry); 
end; 
CloseHandle(hdlSnap); 
end 
else 
if verSystem.dwPlatformId=VER_PLATFORM_WIN32_NT then 
begin 
EnumProcesses(@arrPid,SizeOf(arrPid),iC); 
iCount := iC div SizeOf(DWORD); 
for k := 0 to Pred(iCount) do 
begin 
hdlProcess:=OpenProcess(PROCESS_QUERY_INFORMATION or PROCESS_VM_READ,false,arrPid [k]); 
if (hdlProcess<>0) then 
begin 
EnumProcessModules(hdlProcess,@hdlModul,SizeOf(hdlModul),iC);
GetModuleFilenameEx(hdlProcess,hdlModul,arrModul,SizeOf(arrModul)); 
if bPath then 
begin
if CompareText(arrModul,sFile) = 0 then 
begin 
TerminateProcess(OpenProcess(PROCESS_TERMINATE or PROCESS_QUERY_INFORMATION,False,arrPid [k]), 0); 
Result := True; 
end; 
end 
else 
begin 
if CompareText(ExtractFileName(arrModul),sFile) = 0 then 
begin 
TerminateProcess(OpenProcess(PROCESS_TERMINATE or PROCESS_QUERY_INFORMATION,False,arrPid [k]), 0);
Result := True;
end;
end;
CloseHandle(hdlProcess);
end;
end;
end;
end;


procedure TFuncoes.ListaDir(NumSis:string; NomeAplicativo: string; DirLocal, DirRemoto: TStringList);
var
  ArqIni : TIniFile;
  sDirLocal,
  sDirRemoto:string;
begin
  ArqIni := TIniFile.Create(ExtractFilePath(Application.ExeName) + 'mps.ini');
  try
    NomeAplicativo := Sistema[StrToInt(NumSis)+1];
    sDirLocal      := ArqIni.ReadString(NumSis, 'local', '');
    sDirRemoto     := ArqIni.ReadString(NumSis, 'remoto', '');
  finally
    ArqIni.Free;
  end;
  // Preenche a Lista dos Diretórios Locais
  while Length(sDirLocal) > 0 do
  begin
    if Pos(';',sDirLocal) > 0 then
    begin
      DirLocal.Add(Copy(sDirLocal,0,Pred(Pos(';',sDirLocal))));
      Delete(sDirLocal,1,Pos(';',sDirLocal));
    end
    else
    begin
      DirLocal.Add(sDirLocal);
      sDirLocal := '';
    end;
  end;
  // Preenche a Lista dos Diretórios Remotos
  while Length(sDirRemoto) > 0 do
  begin
    if Pos(';',sDirRemoto) > 0 then
    begin
      DirRemoto.Add(Copy(sDirRemoto,0,Pred(Pos(';',sDirRemoto))));
      Delete(sDirRemoto,1,Pos(';',sDirRemoto));
    end
    else
    begin
      DirRemoto.Add(sDirRemoto);
      sDirRemoto := '';
    end;
  end;

end;

end.

