{ TODO -oCARLOS FEITOZA -cADIÇÃO : ALTERAR O PROCEDURE ReplaceSpecialConstants DE FORMA QUE ESTE CONSIDER WINDOWS DE 64 BITS }
{ TODO -oCARLOS FEITOZA -cADIÇÃO : CRIAR UM OBJETO NOS MOLDES DE "TMONITOREDFILES" DE NOME "TEXCLUDEDFILES" }
unit UGlobalFunctions;

interface

uses
  ComCtrls, Windows, SysUtils, DB, OverbyteIcsFtpCli, StdCtrls, 
  OverbyteIcsFtpSrv, Classes, UObjectFile;

type
	TMultiTypedResult = record
    DataType: TFieldType;
    IsNull: Boolean;
    AsByte: Byte;
    AsWord: Word;
    AsDWord: Cardinal;
    AsShortInt: ShortInt;
    AsSmallInt: SmallInt;
    AsInteger: Integer;
    AsInt64: Int64;
    AsChar: Char;
    AsString: String;
    AsSingle: Single;
    AsFloat: Single;
    AsDouble: Double;
    AsCurrency: Currency;
    AsDateTime: TDateTime;
  end;

  EInvalidPath = class(Exception);
  EUnsuccessfulExclusion = class(Exception);
  ERunningApplication = class(Exception);

  TFileSizeUnit = (fsuBytes, fsuKBytes, fsuMBytes, fsuGBytes, fsuTBytes);

  TSyncCmd = function: Boolean of object;

  TProcessCallBack = function (aSearchRec: TSearchRec): Boolean;

  TFileInformation = class
  private
    FFileInfo: TVSFixedFileInfo;
    FFileName: TFileName;
	  procedure SetFileName(const Value: TFileName);
    function GetFileInfo(const aInfo: String): TMultiTypedResult;
  public
    class function GetInfo(const aFileName: TFileName; const aInfo: String): TMultiTypedResult;
    property FileName: TFileName read FFileName write SetFileName;
    property FileInfo[const Info: String]: TMultiTypedResult read GetFileInfo;
  end;

  TConnectedClient  = class(TFtpCtrlSocket)
  private
    FRealName: String;
    FEmail: String;
    FIP: String;
    FID: Cardinal;
  public
    constructor Create(AOwner: TComponent); override;

    property ID: Cardinal read FID write FID;
    property RealName: String read FRealName write FRealName;
    property Email: String read FEmail write FEmail;
    property IP: String read FIP write FIP;
  end;

  TActionOnFile = (aofNone, aofDownload, aofDeleteFile, aofDeleteDir);

  TFileInfo = class(TCollectionItem)
  private
    FFilePath: TFileName;
    FLastModified: TDateTime;
    FActionOnFile: TActionOnFile;
    function GetTranslatedFilePath: TFileName;
  public
    constructor Create(Collection: TCollection); override;
    property TranslatedFilePath: TFileName read GetTranslatedFilePath;
  published
    property LastModified: TDateTime read FLastModified write FLastModified;
    property FilePath: TFileName read FFilePath write FFilePath;
    property ActionOnFile: TActionOnFile read FActionOnFile write FActionOnFile;
  end;

  TMonitoredFiles = class;

  TFiles = class(TCollection)
  private
    FMonitoredFiles: TMonitoredFiles;
    function GetFileInfo(i: Cardinal): TFileInfo;
  public
    function IndexOfFilePath(aFilePath: TFileName; aPartial: Boolean = False): Integer;
    function IndexOfTranslatedFilePath(aFilePath: TFileName; aPartial: Boolean = False): Integer;
    function DownloadCount: Integer;
    function DeleteFileCount: Integer;
    function DeleteDirCount: Integer;
    function Add: TFileInfo;
    property FileInfo[i: Cardinal]: TFileInfo read GetFileInfo; default;
    property MonitoredFiles: TMonitoredFiles read FMonitoredFiles write FMonitoredFiles;
  end;

  TMonitoredFiles = class(TObjectFile)
  private
    FFiles: TFiles;
    FDirectory: String;
    FInstallationKey: String;
    FDefaultAppDir: String;
//    function GetAppDir: String;
  public
    constructor Create(aOwner: TComponent; aDefaultAppDir: String); reintroduce;
    destructor Destroy; override;
    procedure Clear; override;
//    property AppDir: String read GetAppDir;
  published
    property Files: TFiles read FFiles write FFiles;
    property Directory: String read FDirectory write FDirectory; { diretório sendo monitorado no servidor }
    property DefaultAppDir: String read FDefaultAppDir;
    property InstallationKey: String read FInstallationKey write FInstallationKey;
  end;

procedure ShowOnLog(const aText: String; aRichEdit: TRichEdit; aMaxLines: Word = 0; aAutoSaveFile: TFileName = '');

function PutLineBreaks(const aText: String; aCharsPerLine: Byte): String;

function ExecuteCmd(aFTPClient       : TFtpClient;
                    aSyncCmd         : TSyncCmd;
                    aRichEdit        : TRichEdit;
                    aDescription     : String = '';
                    aCommandDelay    : Word = 0;
                    aProgressBar     : TProgressBar = nil;
                    aLabelPercentDone: TLabel = nil): Boolean;

procedure Autenticar(aFTPClient: TFtpClient;
                     aUserName
                    ,aPassWord : String;
                     aRichEdit : TRichEdit);

procedure Conectar(aFTPClient: TFtpClient;
                   aHostName : String;
                   aPortNumb : Word;
                   aRichEdit : TRichEdit);

procedure Desconectar(aFTPClient: TFtpClient;
                      aRichEdit : TRichEdit);

procedure MudarDiretorio(aFTPClient: TFtpClient;
                         aDiretorio: String;
                         aRichEdit : TRichEdit);

function ObterArquivo(aFTPClient       : TFtpClient;
                      aProgressBar     : TProgressBar;
                      aLabelPercentDone: TLabel;
                      aLocalFileName
                     ,aRemoteFileName  : String;
                      aRichEdit        : TRichEdit;
                      aObterTamanho    : Boolean = False;
                      aMaxTries        : Byte = 5): Boolean;

procedure WaitFor(const aSeconds           : Byte;
                  const aUseProcessMessages: Boolean = True);

function LoadTextFile(const aFileName: TFileName): String;
function FileSize(aFileName  : TFileName;
                  aFileSizeIn: TFileSizeUnit = fsuBytes): Double;

procedure InitializeProgress(aProgressBar: TProgressBar; aLabelPercentDone: TLabel; aMax: Cardinal);
procedure IncreaseProgress(aProgressBar: TProgressBar; aLabelPercentDone: TLabel);
procedure SetProgressWith(aProgressBar: TProgressBar; aLabelPercentDone: TLabel; aPosition: Cardinal);
procedure SendStatus(aClient: TConnectedClient;
                     aStatus: String);
function GetUSFormatSettings: TFormatSettings;

function ParamIsPresent(aParamName: String): Boolean;
function GetFileModificationDate(aFileName: String): TDateTime;
function GetParamValue(aParamName: String): String;

procedure ProcessTree(aRoot, aMask: String; aRecursive: Boolean; aProcessFiles, aProcessDirs: TProcessCallBack);
function ProcessExists(aExeFileName: String): Boolean;

const
  TXT = 0;
  BIN = 1;
  FORMATOS: array [0..1] of String = ('OBJ','XML');

  { Comandos podem ter parâmetos ou não. Se houver parametros estes são
  colocados dentro das chaves, separados por vírgulas. Comandos podem ter
  respostas ou não. Caso haja resposta está será enviada como um arquivo de
  volta ao solicitante. Devido a natureza do FTP, mesmo comandos que não tem
  resposta retornam um valor genérico dentro de um arquivo. O arquivo gerado
  como resposta tem o mesmo nome do comando completo quando obtido a partir de
  um cliente de FTP comum ou o mesmo nome do comando sem os parâmetros, quando
  obtido a partir do MPS Updater Client }

  MONITOREDFILESLIST = 'MONITOREDFILESLIST';
  CMD_MONITOREDFILESLIST = MONITOREDFILESLIST + '{*,???}';

  EXCLUDEDFILESLIST = 'EXCLUDEDFILESLIST';
  CMD_EXCLUDEDFILESLIST = EXCLUDEDFILESLIST + '{*,???}';

  {$IFDEF SERVER}
  _COPYRIGHT = 'Copyright %s MPS Informática Ltda. Todos os direitos reservados.';
  _CUSTOMBANNER = 'Customizado para Hitachi Ar Condicionado do Brasil Ltda.';
  _WELCOME = '220-Bem-vindo(a) ao MPS Updater '#13#10 +
             '220-' + _COPYRIGHT + #13#10 +
             '220-ATENÇÃO: ESTE SERVIDOR É PRIVADO,  O QUE SIGNIFICA  QUE ELE  NÃO ACEITA  LOGINS'#13#10 +
             '220-ANÔNIMOS. SE  VOCÊ NÃO POSSUI LOGIN  E SENHA VÁLIDOS  PARA ESTE SERVIDOR,  SAIA'#13#10 +
             '220-IMEDIATAMENTE, DO CONTRÁRIO SERÃO TOMADAS MEDIDAS LEGAIS. SEU IP,  ASSIM COMO A'#13#10 +
             '220-DATA E A HORA DE SUA CONEXÃO JÁ FORAM LOGADOS.'#13#10 +
  	         '220--------------------------------------------------------------------------------'#13#10 +
             '220 EOM';
  _CLIENT_AUTHENTICATED = '230-%s sr(a). %s!';

//	SQL_SELECT_ALL_USERS2 =
//	'SELECT USER.USER'#13#10 +
//  	'     , USER.PASSWORD'#13#10 +
//  	'  FROM MYSQL.USER'#13#10 +
//    ' WHERE USER.USER = ''%s'''#13#10 +
//    '   AND USER.PASSWORD = PASSWORD(''%s'')';
  SQL_SELECT_ALL_USERS = '   SELECT VA_NOME'#13#10 +
                         '        , VA_EMAIL'#13#10 +
                         '        , BI_USUARIOS_ID'#13#10 +
                         '     FROM MPSUPDATER.USUARIOS'#13#10 +
                         '    WHERE VA_LOGIN = ''%s'' AND VA_SENHA = MD5(''%s'')';
  {$ELSE}
  _DUMMY = '';
  {$ENDIF}

implementation

uses Graphics
   , Messages
   , StrUtils
   , Forms
   , ShlObj
   , ShFolder
   , Registry
   , TlHelp32;

function ProcessExists(aExeFileName: String): Boolean;
var
  ContinueLoop: Boolean;
  SnapshotHandle: THandle;
  ProcessEntry32: TProcessEntry32;
begin
  Result := False;

  SnapshotHandle := 0;
  try
    SnapshotHandle := CreateToolhelp32Snapshot(TH32CS_SNAPPROCESS, 0);

    ProcessEntry32.dwSize := SizeOf(TProcessEntry32);

    ContinueLoop := Process32First(SnapshotHandle, ProcessEntry32);

    while Integer(ContinueLoop) <> 0 do
    begin
      if ((UpperCase(ExtractFileName(ProcessEntry32.szExeFile)) = UpperCase(aExeFileName)) or (UpperCase(ProcessEntry32.szExeFile) = UpperCase(aExeFileName))) then
      begin
        Result := True;
        Break;
      end;

      ContinueLoop := Process32Next(SnapshotHandle, ProcessEntry32);
    end;
  finally
    CloseHandle(SnapshotHandle);
  end;
end;

function GetFileModificationDate(aFileName: String): TDateTime;
var
  SearchRec: TSearchRec;
begin
  try
    FindFirst(aFileName,0,SearchRec);
    Result := FileDateToDatetime(SearchRec.Time);
  finally
    FindClose(SearchRec);
  end;
end;

function ParamIsPresent(aParamName: String): Boolean;
var
  i: Byte;
begin
  Result := False;

  if ParamCount > 0 then
    for i := 1 to ParamCount do
      if ParamStr(i) = aParamName then
      begin
        Result := True;
        Break;
      end;
end;

function GetParamValue(aParamName: String): String;
var
  i: Byte;
begin
  Result := '';

  if ParamCount > 0 then
    for i := 1 to ParamCount do
      if Pos(UpperCase(aParamName) + '=',ParamStr(i)) = 1 then
      begin
        Result := Copy(ParamStr(i),Pos('=',ParamStr(i)) + 1,Length(ParamStr(i)));
        Break;
      end;
end;

function GetUSFormatSettings: TFormatSettings;
begin
  ZeroMemory(@Result,SizeOf(TFormatSettings));
  GetLocaleFormatSettings(((SORT_DEFAULT shl 16) or (SUBLANG_ENGLISH_US shl 10) or LANG_ENGLISH),Result);
end;

procedure SendStatus(aClient: TConnectedClient;
                     aStatus: String);
begin
	if Assigned(aClient) then
      aClient.SendAnswer('150-' + aStatus);
end;

function PutLineBreaks(const aText: String; aCharsPerLine: Byte): String;
var
  BreakPos: Byte;
  LineToAdd: String;
  BreakableText: String;
begin
  if Length(aText) > aCharsPerLine then
    with TStringList.Create do
    begin
      BreakableText := Trim(aText) + #0;

      while BreakableText <> '' do
      begin
        if Pred(Length(BreakableText)) > aCharsPerLine then
          BreakPos := aCharsPerLine
        else
          BreakPos := Length(BreakableText);

        while (BreakableText[BreakPos] <> #32) and (BreakableText[BreakPos] <> #0) do
          Dec(BreakPos);

        LineToAdd := Trim(Copy(BreakableText,1,BreakPos));

        Add(LineToAdd);
        System.Delete(BreakableText,1,BreakPos);
      end;
      Result := StringReplace(Trim(Text),#$0D#$0A,'\n',[rfReplaceAll]);
      Free;
    end
  else
    Result := aText;
end;

procedure ShowOnLog(const aText: String; aRichEdit: TRichEdit; aMaxLines: Word = 0; aAutoSaveFile: TFileName = '');
var
  Linhas: TStringList;
  i: Word;
  LinhaAExibir: String;

  function FirstToken(Line: String): String;
  begin
  	Result := Copy(Line,1,Pred(Pos(' ',Line)));
  end;

  function FirstAndSecondTokens(Line: String): String;
  var
    Idx: Word;
    TmpStr: String;
  begin
  	TmpStr := Line; //RETORNO:> XXX - XXXXXX
		Idx := Pos(' ',TmpStr);
    Delete(TmpStr,1,Idx); //XXX - XXXXXX
    Inc(Idx,Pos(' ',TmpStr));
  	Result := Copy(Line,1,Pred(Idx));
  end;

  procedure AddText(aLine: String; aColor: TColor; aFontName: TFontName; aFontSize: Byte; aFontStyle: TFontStyles);
  begin
    aRichEdit.SelAttributes.Color := aColor;
    aRichEdit.SelAttributes.Name  := aFontName;
    aRichEdit.SelAttributes.Size  := aFontSize;
    aRichEdit.SelAttributes.Style := aFontStyle;
    aRichEdit.SelText             := aLine;
  end;

  procedure AutoSaveLine(aLine: String);
  var
    FileName: TFileName;
  begin
    FileName := ExtractFilePath(Application.ExeName) + aAutoSaveFile;
    with TStringList.Create do
      try
        if FileExists(FileName) then
          LoadFromFile(FileName);

        Add(aLine);
      finally
        SaveToFile(FileName);
        Free;
      end;
  end;

begin
	Linhas := nil;

  try
    Linhas := TStringList.Create;
		Linhas.Text := StringReplace(aText,'\n',#13#10,[rfReplaceAll]);

    if (Pos('RETORNO:>',Linhas[0]) = 1) or (Pos('COMANDO:>',Linhas[0]) = 1) or (Linhas[0][1] = '!') or (Linhas[0][1] = '§') or (Linhas[0][1] = '@') then
      for i := 0 to Pred(Linhas.Count) do
      begin
        { Este IF e seu ELSE escrevem no log apenas a parte inicial da linha,
        que consiste, da data mais o colchete ou das linhas verticais, mais o
        colchete no caso de um comando ou resposta com mais de uma linha }
        if i = 0 then
        begin
          LinhaAExibir := Linhas[0];

          aRichEdit.SelStart := aRichEdit.GetTextLen;
          { dd/mm/yyyy hh:nn:ss ] RETORNO:> ??? - XXXXXXXXXXXX }

          { dd/mm/yyyy hh:nn:ss }
          AddText(FormatDateTime('dd/mm/yyyy hh:nn:ss',Now())
                 ,clWindowText
                 ,aRichEdit.Font.Name
                 ,aRichEdit.Font.Size
                 ,[fsBold]);

          { ] }
          AddText(' ] '
                 ,clWindowText
                 ,aRichEdit.Font.Name
                 ,aRichEdit.Font.Size
                 ,[]);
        end
        else
        begin
          // 24/08/2010 09:08:26 ] § XXXX LINHA xxxx
          // ||||||||||||||||||| ] § XXXX LINHA xxxx
          if (Linhas[0][1] <> '!') and (Linhas[0][1] <> '§') and (Linhas[0][1] <> '@') then
            LinhaAExibir := FirstAndSecondTokens(Linhas[0]) + ' ' + Linhas[i]
          else
            LinhaAExibir := FirstToken(Linhas[0]) + ' ' + Linhas[i];

          aRichEdit.SelStart := aRichEdit.GetTextLen;

          { ||||||||||||||||||| }
          AddText('|||||||||||||||||||'
                 ,clWindowText
                 ,aRichEdit.Font.Name
                 ,aRichEdit.Font.Size
                 ,[fsBold]);

          { ] }
          AddText(' ] '
                 ,clWindowText
                 ,aRichEdit.Font.Name
                 ,aRichEdit.Font.Size
                 ,[]);
        end;

        { A partir daqui será inserida a parte da linha que tem a informação }

        { RETORNO:> ??? - XXXXXXXXXXXX }

        {$IFDEF FTPSYNCCLI}
        { Pintando erros de vermelho }
        if Pos('RETORNO:> 666 - ',LinhaAExibir) = 1 then
        begin
          AddText('RETORNO:> '
                 ,clBlue
                 ,aRichEdit.Font.Name
                 ,aRichEdit.Font.Size
                 ,[fsBold]);

          AddText(Copy(LinhaAExibir,Pos('666',LinhaAExibir),Length(LinhaAExibir)) + #13#10
                 ,clRed
                 ,aRichEdit.Font.Name
                 ,aRichEdit.Font.Size
                 ,[fsBold]);
        end
        else
        {$ENDIF}
        if Pos('RETORNO:>',LinhaAExibir) = 1 then
          AddText(LinhaAExibir + #13#10
                 ,clBlue
                 ,aRichEdit.Font.Name
                 ,aRichEdit.Font.Size
                 ,[fsBold])
        else if Pos('COMANDO:>',LinhaAExibir) = 1 then
          AddText(LinhaAExibir + #13#10
                 ,clGreen
                 ,aRichEdit.Font.Name
                 ,aRichEdit.Font.Size
                 ,[fsBold])
        else if LinhaAExibir[1] = '!' then
          AddText(LinhaAExibir + #13#10
                 ,clRed
                 ,aRichEdit.Font.Name
                 ,aRichEdit.Font.Size
                 ,[fsBold])
        else if LinhaAExibir[1] = '§' then
          AddText(LinhaAExibir + #13#10
                 ,$000080FF
                 ,aRichEdit.Font.Name
                 ,aRichEdit.Font.Size
                 ,[fsBold])
        else if LinhaAExibir[1] = '@' then
          AddText(LinhaAExibir + #13#10
                 ,clPurple
                 ,aRichEdit.Font.Name
                 ,aRichEdit.Font.Size
                 ,[fsBold]);
      end
    else
      for i := 0 to Pred(Linhas.Count) do
      begin
        aRichEdit.SelStart := aRichEdit.GetTextLen;
        AddText('------------------- ] ' + Linhas[i] + #13#10
               ,clWindowText
               ,aRichEdit.Font.Name
               ,aRichEdit.Font.Size
               ,[]);
      end;
  finally
    Linhas.Free;

    if aMaxLines > 0 then
    begin
      if aRichEdit.Lines.Count > aMaxLines then
        for i := 1 to aRichEdit.Lines.Count - aMaxLines do
        begin
          if aAutoSaveFile <> '' then
            AutoSaveLine(aRichEdit.Lines[0]);

          // se for pra salvar, salva aqui.
          aRichEdit.Lines.Delete(0);
        end;
    end;


    SendMessage(aRichEdit.Handle,WM_VSCROLL,SB_BOTTOM,0);
  end;
end;



(*


procedure ShowOnLog(const aText: String; aRichEdit: TRichEdit);
var
  Linhas: TStringList;
  i: Word;
  LinhaAExibir: String;

  function FirstToken(Line: String): String;
  begin
  	Result := Copy(Line,1,Pred(Pos(' ',Line)));
  end;

  function FirstAndSecondTokens(Line: String): String;
  var
    Idx: Word;
    TmpStr: String;
  begin
  	TmpStr := Line; //RETORNO:> XXX - XXXXXX
		Idx := Pos(' ',TmpStr);
    Delete(TmpStr,1,Idx); //XXX - XXXXXX
    Inc(Idx,Pos(' ',TmpStr));
  	Result := Copy(Line,1,Pred(Idx));
  end;

begin
	Linhas := nil;

  try
    Linhas := TStringList.Create;
		Linhas.Text := StringReplace(aText,'\n',#13#10,[rfReplaceAll]);

    if (Pos('RETORNO:>',Linhas[0]) = 1) or (Pos('COMANDO:>',Linhas[0]) = 1) or (Linhas[0][1] = '!') or (Linhas[0][1] = '§') or (Linhas[0][1] = '@') then
      for i := 0 to Pred(Linhas.Count) do
      begin
        if i = 0 then
        begin
          LinhaAExibir := Linhas[0];
          aRichEdit.Lines.Add(FormatDateTime('dd/mm/yyyy hh:nn:ss',Now()) + ' ] ' + LinhaAExibir);
        end
        else
        begin
          if (Linhas[0][1] <> '!') and  (Linhas[0][1] <> '§') and (Linhas[0][1] <> '@') then
            LinhaAExibir := FirstAndSecondTokens(Linhas[0]) + ' - ' + Linhas[i]
          else
            LinhaAExibir := FirstToken(Linhas[0]) + ' ' + Linhas[i];

          aRichEdit.Lines.Add('||||||||||||||||||| ] ' + LinhaAExibir);
        end;

        { A partir daqui, a última linha do RichEdit contém algo como
        dd/mm/yyyy hh:nn:ss ] RETORNO:> ??? - XXXXXXXXXXXX }

        { Tornando negrito e na cor preta a string inteira }
        aRichEdit.SelStart := Length(aRichEdit.Text) - Length(aRichEdit.Lines[Pred(aRichEdit.Lines.Count)]) - 2;
        aRichEdit.SelLength := Length(aRichEdit.Lines[Pred(aRichEdit.Lines.Count)]);
        aRichEdit.SelAttributes.Color := clWindowText;
        aRichEdit.SelAttributes.Style := [fsBold];

        { Removendo o atributo negrito do colchete (]) }
        aRichEdit.SelStart := aRichEdit.SelStart + 20;
        aRichEdit.SelLength := 1;
        aRichEdit.SelAttributes.Style := [];

        { Seleconando a segunda parte do texto }
        aRichEdit.SelStart := Length(aRichEdit.Text) - Length(aRichEdit.Lines[Pred(aRichEdit.Lines.Count)]) + 20;
        aRichEdit.SelLength := Length(LinhaAExibir);

        { Pintando a linha da mensagem de acordo com o texto }
        if Pos('RETORNO:>',LinhaAExibir) = 1 then
          aRichEdit.SelAttributes.Color := clBlue
        else if Pos('COMANDO:>',LinhaAExibir) = 1 then
          aRichEdit.SelAttributes.Color := clGreen
        else if LinhaAExibir[1] = '!' then
          aRichEdit.SelAttributes.Color := clRed
        else if LinhaAExibir[1] = '§' then
          aRichEdit.SelAttributes.Color := $000080FF
        else if LinhaAExibir[1] = '@' then
          aRichEdit.SelAttributes.Color := clPurple;

        {$IFDEF CLIENT}
        { Pintando erros de vermelho }
        if Pos('RETORNO:> 666 - ',LinhaAExibir) = 1 then
        begin
          aRichEdit.SelStart := aRichEdit.SelStart + 10;
          aRichEdit.SelLength := Length(LinhaAExibir) - 10;
          aRichEdit.SelAttributes.Color := clRed;
        end;
        {$ENDIF}

        aRichEdit.SelLength := 0;
      end
    else
      for i := 0 to Pred(Linhas.Count) do
          aRichEdit.Lines.Add('------------------- ] ' + Linhas[i]);
    finally
  	  Linhas.Free;
      SendMessage(aRichEdit.Handle,EM_SCROLLCARET,0,0);
  end;
end;


*)

{ TFileInformation }

{ TODO -oCarlos Feitoza : Esta função está incompleta. Ela só está retornando as
informações de versão. Por favor complete-a! }
function TFileInformation.GetFileInfo(const aInfo: String): TMultiTypedResult;
var
  W32FAD: PWin32FileAttributeData;
  SystemTime: TSystemTime;
begin
  ZeroMemory(@Result,SizeOf(TMultiTypedResult));
  W32FAD := nil;

  with Result do
  begin
    if aInfo = 'MAJORVERSION' then
    begin
      AsWord := HiWord(FFileInfo.dwFileVersionMS);
	    AsString := IntToStr(AsWord);
    end
    else if aInfo = 'MINORVERSION' then
    begin
      AsWord := LoWord(FFileInfo.dwFileVersionMS);
	    AsString := IntToStr(AsWord);
    end
    else if aInfo = 'RELEASE' then
    begin
      AsWord := HiWord(FFileInfo.dwFileVersionLS);
	    AsString := IntToStr(AsWord);
    end
    else if aInfo = 'BUILD' then
    begin
      AsWord := LoWord(FFileInfo.dwFileVersionLS);
	    AsString := IntToStr(AsWord);
    end
    else if aInfo = 'FULLVERSION' then
    begin
	    AsString := GetFileInfo('MAJORVERSION').AsString + '.' + GetFileInfo('MINORVERSION').AsString + '.' + GetFileInfo('RELEASE').AsString + '.' + GetFileInfo('BUILD').AsString;
      AsInt64 := StrToInt64(GetFileInfo('MAJORVERSION').AsString + GetFileInfo('MINORVERSION').AsString + GetFileInfo('RELEASE').AsString + GetFileInfo('BUILD').AsString);
    end
    else if aInfo = 'MODIFIEDDATETIME' then
    begin
      GetFileAttributesEx(PChar(FFileName),GetFileExInfoStandard,W32FAD);
      FileTimeToSystemTime(W32FAD^.ftLastWriteTime,SystemTime);

      AsDateTime := SystemTimeToDateTime(SystemTime);
      AsDouble   := AsDateTime;
      AsFloat    := AsDateTime;
    end;
  end;
end;

class function TFileInformation.GetInfo(const aFileName: TFileName; const aInfo: String): TMultiTypedResult;
begin
  with TFileInformation.Create do
  try
    FileName := aFileName;
    Result := FileInfo[aInfo];
  finally
    Free;
  end;
end;

procedure TFileInformation.SetFileName(const Value: TFileName);
var
  InternalFileName: array [0..255] of Char;
  VersionInfoSize, Dummy: Cardinal;
  VersionInfo: PChar;
  FixedInfoData: PVSFixedFileInfo;
  QueryLen: Cardinal;
begin
	FFileName := Value;

	ZeroMemory(@InternalFileName,256);
  ZeroMemory(@FFileInfo,SizeOf(TVSFixedFileInfo));
	StrPCopy(InternalFileName,FFileName);

 	VersionInfoSize := GetFileVersionInfoSize(InternalFileName, Dummy);

  if VersionInfoSize > 0 then
  begin
    GetMem(VersionInfo, VersionInfoSize);
    GetFileVersionInfo(InternalFileName, Dummy, VersionInfoSize, VersionInfo);

    VerQueryValue(VersionInfo, '\', Pointer(FixedInfoData), QueryLen);

    FFileInfo.dwSignature := FixedInfoData^.dwSignature;
    FFileInfo.dwStrucVersion := FixedInfoData^.dwStrucVersion;
    FFileInfo.dwFileVersionMS := FixedInfoData^.dwFileVersionMS;
    FFileInfo.dwFileVersionLS := FixedInfoData^.dwFileVersionLS;
    FFileInfo.dwProductVersionMS := FixedInfoData^.dwProductVersionMS;
    FFileInfo.dwProductVersionLS := FixedInfoData^.dwProductVersionLS;
    FFileInfo.dwFileFlagsMask := FixedInfoData^.dwFileFlagsMask;
    FFileInfo.dwFileFlags := FixedInfoData^.dwFileFlags;
    FFileInfo.dwFileOS := FixedInfoData^.dwFileOS;
    FFileInfo.dwFileType := FixedInfoData^.dwFileType;
    FFileInfo.dwFileSubtype := FixedInfoData^.dwFileSubtype;
    FFileInfo.dwFileDateMS := FixedInfoData^.dwFileDateMS;
    FFileInfo.dwFileDateLS := FixedInfoData^.dwFileDateLS;
  end;
end;

procedure IncreaseProgress(aProgressBar: TProgressBar; aLabelPercentDone: TLabel);
begin
  	aProgressBar.StepIt;

  if Assigned(aLabelPercentDone) then
  	if aProgressBar.Max > 0 then
  		aLabelPercentDone.Caption := Format('%d%%',[Round(aProgressBar.Position / aProgressBar.Max * 100)])
  	else
  		aLabelPercentDone.Caption := '0%';
end;

procedure SetProgressWith(aProgressBar: TProgressBar; aLabelPercentDone: TLabel; aPosition: Cardinal);
begin
	if Assigned(aProgressBar) then
  begin
  	aProgressBar.Position := aPosition;
    aProgressBar.Update;
  end;

  if Assigned(aLabelPercentDone) then
  begin
  	if aProgressBar.Max > 0 then
  		aLabelPercentDone.Caption := Format('%d%%',[Round(aProgressBar.Position / aProgressBar.Max * 100)])
  	else
  		aLabelPercentDone.Caption := '0%';
  end;
end;

procedure InitializeProgress(aProgressBar: TProgressBar; aLabelPercentDone: TLabel; aMax: Cardinal);
begin
	if Assigned(aProgressBar) then
  begin
    aProgressBar.Step := 1;
    aProgressBar.Max := aMax;
    aProgressBar.Position := 0;
  end;

  if Assigned(aLabelPercentDone) then
    aLabelPercentDone.Caption := '0%';
end;

function LoadTextFile(const aFileName: TFileName): String;
begin
	Result := '';
	with TFileStream.Create(aFileName, fmOpenRead or fmShareDenyWrite) do
  try
    try
      SetLength(Result, Size);
      Read(Pointer(Result)^, Size);
    except
      Result := ''; { Desaloca a memória };
      raise;
    end;
  finally
    Free;
  end;
end;

function FileSize(aFileName  : TFileName;
                  aFileSizeIn: TFileSizeUnit = fsuBytes): Double;
var
	FOB: file of 0..255;
  FOKB: file of 0..1024;
  FOMB: file of 0..1048576;
  FOGB: file of 0..1073741824;
begin
	case aFileSizeIn of
    fsuBytes: try
      AssignFile(FOB,aFileName);
      Reset(FOB);
      Result := System.FileSize(FOB);
    finally
      CloseFile(FOB);
    end;
    fsuKBytes: try
      AssignFile(FOKB,aFileName);
      Reset(FOKB);
      Result := System.FileSize(FOKB);
    finally
      CloseFile(FOKB);
    end;
    fsuMBytes: try
      AssignFile(FOMB,aFileName);
      Reset(FOMB);
      Result := System.FileSize(FOMB);
    finally
      CloseFile(FOMB);
    end;
    fsuGBytes: try
      AssignFile(FOGB,aFileName);
      Reset(FOGB);
      Result := System.FileSize(FOGB);
    finally
      CloseFile(FOGB);
    end;
    else
      Result := 0;
  end;
end;

procedure WaitFor(const aSeconds           : Byte;
                  const aUseProcessMessages: Boolean = True);
var
	TimeOut: TDateTime;
begin
 	TimeOut := GetTickCount + aSeconds * 1000;
    if aUseProcessMessages then
        while TimeOut > GetTickCount do
  		    Application.ProcessMessages
    else
        while TimeOut > GetTickCount do
        begin
            { Nada mesmo! }
        end;
end;

procedure Conectar(aFTPClient: TFtpClient;
                   aHostName : String;
                   aPortNumb : Word;
                   aRichEdit : TRichEdit);
begin
    aFtpClient.HostName := aHostName;
    aFtpClient.Port := IntToStr(aPortNumb);

    if not ExecuteCmd(aFTPClient,aFtpClient.Open,aRichEdit,'OPEN') then
	    raise Exception.Create('Não foi possível conectar-se ao servidor.');
end;

procedure Autenticar(aFTPClient: TFtpClient;
                     aUserName
                    ,aPassWord : String;
                     aRichEdit : TRichEdit);
var
	ErrorText: String;
begin
  ErrorText := 'Não foi possível autenticar sua conexão. Usuário e/ou senha inválidos.';

  aFtpClient.UserName := aUserName;
  aFtpClient.PassWord := aPassWord;

  if not ExecuteCmd(aFTPClient,aFTPClient.User,aRichEdit,'USER') then
    raise Exception.Create(ErrorText);

  if not ExecuteCmd(aFTPClient,aFTPClient.Pass,aRichEdit,'PASS') then
    raise Exception.Create(ErrorText);
end;

procedure Desconectar(aFTPClient: TFtpClient;
                      aRichEdit : TRichEdit);
begin
  if not ExecuteCmd(aFTPClient,aFTPClient.Quit,aRichEdit,'QUIT') then
    raise Exception.Create('Não foi possível desconectar do servidor!'); // Isso pode ocorrer?
end;

procedure MudarDiretorio(aFTPClient: TFtpClient;
                         aDiretorio: String;
                         aRichEdit : TRichEdit);
begin
    aFtpClient.HostDirName := aDiretorio;

    if not ExecuteCmd(aFTPClient,aFtpClient.Cwd,aRichEdit,'CWD') then
	    raise Exception.Create('Não foi possível mudar para o diretório "' + aDiretorio + '"');
end;

function ObterArquivo(aFTPClient       : TFtpClient;
                      aProgressBar     : TProgressBar;
                      aLabelPercentDone: TLabel;
                      aLocalFileName
                     ,aRemoteFileName  : String;
                      aRichEdit        : TRichEdit;
                      aObterTamanho    : Boolean = False;
                      aMaxTries        : Byte = 5): Boolean;
var
	Count: Byte;
begin
  aFtpClient.LocalFileName := aLocalFileName;
  aFtpClient.HostFileName := aRemoteFileName;
  aFTPClient.Passive := True;

  Count := 0;

  { Ao obter o tamanho devemos configurar o progressbar no evento OnResponse }
  if aObterTamanho then
    ExecuteCmd(aFTPClient
              ,aFtpClient.Size
              ,aRichEdit
              ,'SIZE');

  ShowOnLog('§ Obtendo arquivo "' + aRemoteFileName + '"', aRichEdit);

  repeat
	  Inc(Count);
        { Executa até que... }
  until ExecuteCmd(aFTPClient { tenha recebido o arquivo ou...}
                  ,aFtpClient.Get
                  ,aRichEdit
                  ,'GET'
                  ,0
                  ,aProgressBar
                  ,aLabelPercentDone)
        or not aFTPClient.Connected { o ftp tenha se desconectado ou... }
        or (Count > aMaxTries); { tenha excedido a quantidade máxima de tentativas }

  Result := (Count <= aMaxTries);
end;

function ExecuteCmd(aFTPClient       : TFtpClient;
                    aSyncCmd         : TSyncCmd;
                    aRichEdit        : TRichEdit;
                    aDescription     : String = '';
                    aCommandDelay    : Word = 0;
                    aProgressBar     : TProgressBar = nil;
                    aLabelPercentDone: TLabel = nil): Boolean;
var
	Text: String;
begin
  Text := '@ Executando comando "' + aDescription + '"... ';
  Text := Text + DupeString('>',89 - Length(Text));
  ShowOnLog(Text,aRichEdit);

  if @aSyncCmd = @TFtpClient.Put then
	  InitializeProgress(aProgressBar,aLabelPercentDone,Trunc(FileSize(aFtpClient.LocalFileName)));

  Result := aSyncCmd;

  if aCommandDelay > 0 then
  begin
    ShowOnLog('~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~',aRichEdit);
    ShowOnLog('Aguardando ' + IntToStr(aCommandDelay) + ' segundo(s) antes da próxima ação...',aRichEdit);
    ShowOnLog('~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~',aRichEdit);
    WaitFor(aCommandDelay,False);
  end;
end;

{ O conceito da função abaixo é interessante. Altere ela de forma que ela
funcione também para processar diretórios. Atualmente ela só executa
"aProcessCallBack" para arquivos }
procedure ProcessTree(aRoot, aMask: String; aRecursive: Boolean; aProcessFiles, aProcessDirs: TProcessCallBack);
{ ---------------------------------------------------------------------------- }
procedure SearchTree;
var
  SearchRec: TSearchRec;
begin
  { Processa arquivos na pasta atual }
  if FindFirst(aMask, 0, SearchRec) = 0 then
    try
      repeat
        if not aProcessFiles(SearchRec) then
          Break;
      until FindNext(SearchRec) <> 0;
    finally
      SysUtils.FindClose(SearchRec);
    end;
  { Processa pastas dentro da pasta atual apenas se a recursividade estiver
  ativa }
  if aRecursive then
    if FindFirst('*.*', faDirectory, SearchRec) = 0 then
      try
        repeat
          if ((SearchRec.attr and faDirectory = faDirectory) and (SearchRec.name <> '.') and (SearchRec.name <> '..')) then
          begin
            ChDir(SearchRec.Name);
            if Assigned(aProcessDirs) then
              aProcessDirs(SearchRec);

            SearchTree;

            ChDir('..');
          end;
        until FindNext(SearchRec) <> 0;
      finally
        SysUtils.FindClose(SearchRec);
      end;
  end;
{ ---------------------------------------------------------------------------- }
var
  CurrentDir: String;
begin
  if DirectoryExists(aRoot) then
  begin
    CurrentDir := GetCurrentDir;
    try
      ChDir(aRoot);
      SearchTree;
    finally
      ChDir(CurrentDir);
    end;
  end;
end;

{ TConnectedClient }

constructor TConnectedClient.Create(AOwner: TComponent);
begin
  inherited;
  FUserName := '';
  FPassword := '';
  FRealName := '';
  FEmail := '';
end;

{ TModifiedFiles }

procedure TMonitoredFiles.Clear;
begin
  FFiles.Clear;
end;

constructor TMonitoredFiles.Create(aOwner: TComponent; aDefaultAppDir: String);
begin
  inherited Create(aOwner);
  FDefaultAppDir := aDefaultAppDir;

  FFiles := TFiles.Create(TFileInfo);
  FFiles.MonitoredFiles := Self;
end;

destructor TMonitoredFiles.Destroy;
begin
  FFiles.Free;
  inherited;
end;

//function TMonitoredFiles.GetAppDir: String;
//begin
//
//end;

{ TFiles }

function TFiles.Add: TFileInfo;
begin
	Result := TFileInfo(inherited Add);
end;

function TFiles.DeleteDirCount: Integer;
var
  i: Integer;
begin
  Result := 0;

  for i := 0 to Pred(Count) do
    if TFileInfo(Items[i]).ActionOnFile = aofDeleteDir then
      Inc(Result);
end;

function TFiles.DeleteFileCount: Integer;
var
  i: Integer;
begin
  Result := 0;

  for i := 0 to Pred(Count) do
    if TFileInfo(Items[i]).ActionOnFile = aofDeleteFile then
      Inc(Result);
end;

function TFiles.GetFileInfo(i: Cardinal): TFileInfo;
begin
	Result := TFileInfo(inherited Items[i]);
end;

function TFiles.IndexOfFilePath(aFilePath: TFileName; aPartial: Boolean = False): Integer;
var
  i: Cardinal;
begin
  Result := -1;
  if aPartial then
  begin
    if Count > 0 then
      for i := 0 to Pred(Count) do
        if Pos(UpperCase(aFilePath),UpperCase(TFileInfo(Items[i]).FilePath)) > 0 then
        begin
          Result := i;
          Break;
        end;
  end
  else
  begin
    if Count > 0 then
      for i := 0 to Pred(Count) do
        if UpperCase(TFileInfo(Items[i]).FilePath) = UpperCase(aFilePath) then
        begin
          Result := i;
          Break;
        end;
  end;
end;

function TFiles.IndexOfTranslatedFilePath(aFilePath: TFileName; aPartial: Boolean = False): Integer;
var
  i: Cardinal;
begin
  Result := -1;
  if aPartial then
  begin
    if Count > 0 then
      for i := 0 to Pred(Count) do
      begin
        if Pos(UpperCase(aFilePath),UpperCase(TFileInfo(Items[i]).TranslatedFilePath)) > 0 then
        begin
          Result := i;
          Break;
        end;
      end;
  end
  else
  begin
    if Count > 0 then
      for i := 0 to Pred(Count) do
      begin
        if UpperCase(TFileInfo(Items[i]).TranslatedFilePath) = UpperCase(aFilePath) then
        begin
          Result := i;
          Break;
        end;
      end;
  end;
end;

function TFiles.DownloadCount: Integer;
var
  i: Integer;
begin
  Result := 0;

  for i := 0 to Pred(Count) do
    if TFileInfo(Items[i]).ActionOnFile = aofDownload then
      Inc(Result);
end;

{ TFileInfo }

const
  _APP   = '{APP}';
  _WIN   = '{WIN}';
  _SYS   = '{SYS}';
  _SD    = '{SD}';
  _PF    = '{PF}';
  _PF32  = '{PF32}';
  _PF64  = '{PF64}';
  _CF    = '{CF}';
  _FONTS = '{FONTS}';

constructor TFileInfo.Create(Collection: TCollection);
begin
  inherited;
  FActionOnFile := aofNone;
end;

function GetWinDir: String;
var
  Buffer: array[0..Pred(MAX_PATH)] of Char;
begin
  GetWindowsDirectory(Buffer, SizeOf(Buffer) div SizeOf(Buffer[0]));
  Result := StrPas(Buffer);
end;

function GetSystemDir: String;
var
  Buffer: array[0..Pred(MAX_PATH)] of Char;
begin
  GetSystemDirectory(Buffer, SizeOf(Buffer) div SizeOf(Buffer[0]));
  Result := StrPas(Buffer);
end;

function GetSystemDrive: String;
begin
  Result := Copy(GetWinDir,1,2);
end;

function GetProgramFilesDir: String;
var
  Buffer: array[0..Pred(MAX_PATH)] of Char;
begin
  SHGetSpecialFolderPath(0
                        ,Buffer
                        ,CSIDL_PROGRAM_FILES
                        ,False);
  Result := StrPas(Buffer);
end;

function GetCommonFilesDir: String;
var
  Buffer: array[0..Pred(MAX_PATH)] of Char;
begin
  SHGetSpecialFolderPath(0
                        ,Buffer
                        ,CSIDL_PROGRAM_FILES_COMMON
                        ,False);
  Result := StrPas(Buffer);
end;

function GetFontsDir: String;
var
  Buffer: array[0..Pred(MAX_PATH)] of Char;
begin
  SHGetSpecialFolderPath(0
                        ,Buffer
                        ,CSIDL_FONTS
                        ,False);
  Result := StrPas(Buffer);
end;

function GetAppDir(aInstallationKey: String): String;
begin
  Result := '';
  with TRegistry.Create do
    try
      RootKey := HKEY_LOCAL_MACHINE;
      if OpenKeyReadOnly('SOFTWARE\MICROSOFT\WINDOWS\CURRENTVERSION\UNINSTALL\' + aInstallationKey) then
        Result := ReadString('Inno Setup: App Path');
    finally
      Free;
    end;
end;

function TFileInfo.GetTranslatedFilePath: TFileName;
var
  AppDir: String;
begin
  // {app} = Diretório onde a aplicação foi instalada com o instalador
  //         automático INNO SETUP
  // {win} = Diretório do windows. Tipicamente C:\WINDOWS ou C:\WINNT
  // {sys} = Diretório "System" ou "System32"
  // {sd} = Diretório do sistema, tipicamente "C:"
  // {pf} = Diretório "Arquivos de Programas"
  // {pf32} = Diretório "Arquivos de Programas" para programas de 32 bits. Tipicamente "C:\Program Files" em Windows de 32-bit e "C:\Program Files (x86)" em Windows de 64 bits
  // {pf64} = Diretório "Arquivos de Programas" para programas de 64 bits. Tipicamente "C:\Program Files". Deve lançar uma exceção quando tentar usar esta constante em Windows de 32 bits
  // {cf} = Diretório "Arquivos Comuns"
  // {fonts} = Diretório "Fonts"

  Result := UpperCase(FFilePath);

  if Pos(_APP,Result) = 1 then
  begin
    AppDir := GetAppDir(TFiles(Collection).MonitoredFiles.InstallationKey);
    if AppDir <> '' then
      Result := StringReplace(Result,_APP,AppDir,[])
    else
    begin
      if TFiles(Collection).MonitoredFiles.DefaultAppDir <> '' then
        Result := StringReplace(Result,_APP,TFiles(Collection).MonitoredFiles.DefaultAppDir,[])
      else
        raise EInvalidPath.Create('Não foi possível encontrar o diretório de instalação e não foi informado um local padrão. Não é possível traduzir o caminho "' + FFilePath + '"');
    end;
  end
  else if Pos(_WIN,Result) = 1 then
    Result := StringReplace(Result
                           ,_WIN,GetWinDir,[])
  else if Pos(_SYS,Result) = 1 then
    Result := StringReplace(Result
                           ,_SYS,GetSystemDir,[])
  else if Pos(_SD,Result) = 1 then
    Result := StringReplace(Result
                           ,_SD,GetSystemDrive,[])
  else if Pos(_PF,Result) = 1 then
    Result := StringReplace(Result
                           ,_PF,GetProgramFilesDir,[])
  else if Pos(_CF,Result) = 1 then
    Result := StringReplace(Result
                           ,_CF,GetCommonFilesDir,[])
  else if Pos(_FONTS,Result) = 1 then
    Result := StringReplace(Result
                           ,_FONTS,GetFontsDir,[]);
end;

end.
