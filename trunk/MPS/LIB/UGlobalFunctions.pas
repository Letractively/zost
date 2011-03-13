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
    AsShortString: ShortString;
    AsString: String;
    AsSingle: Single;
    AsFloat: Single;
    AsDouble: Double;
    AsCurrency: Currency;
    AsDateTime: TDateTime;
  end;

  EInvalidPath = class(Exception);

  TFileSizeUnit = (fsuBytes, fsuKBytes, fsuMBytes, fsuGBytes, fsuTBytes);

  TSyncCmd = function: Boolean of object;

  TFileInformation = class
  private
    FFileInfo: TVSFixedFileInfo;
    FFileName: TFileName;
	  procedure SetFileName(const Value: TFileName);
    function GetFileInfo(const aInfo: ShortString): TMultiTypedResult;
  public
    class function GetInfo(const aFileName: TFileName; const aInfo: ShortString): TMultiTypedResult;
    property FileName: TFileName read FFileName write SetFileName;
    property FileInfo[const Info: ShortString]: TMultiTypedResult read GetFileInfo;
  end;

  TConnectedClient  = class(TFtpCtrlSocket)
  private
    FRealName: ShortString;
    FEmail: ShortString;
    FIP: ShortString;
    FID: Cardinal;
  public
    constructor Create(AOwner: TComponent); override;

    property ID: Cardinal read FID write FID;
    property RealName: ShortString read FRealName write FRealName;
    property Email: ShortString read FEmail write FEmail;
    property IP: ShortString read FIP write FIP;
  end;

  TFileInfo = class(TCollectionItem)
  private
    FFilePath: TFileName;
    FLastModified: TDateTime;
  published
    property LastModified: TDateTime read FLastModified write FLastModified;
    property FilePath: TFileName read FFilePath write FFilePath;
  end;

  TFiles = class(TCollection)
  private
    function GetFileInfo(i: Cardinal): TFileInfo;
  public
    function Add: TFileInfo;
    property FileInfo[i: Cardinal]: TFileInfo read GetFileInfo; default;
  end;

  TModifiedFiles = class(TObjectFile)
  private
    FFiles: TFiles;
    FDirectory: ShortString;
    FChaveDeInstalacao: ShortString;
  public
    constructor Create(aOwner: TComponent); override;
    destructor Destroy; override;
    procedure Clear; override;
  published
    property Files: TFiles read FFiles write FFiles;
    property Directory: ShortString read FDirectory write FDirectory;
    property ChaveDeInstalacao: ShortString read FChaveDeInstalacao write FChaveDeInstalacao;
  end;

procedure ShowOnLog(const aText: String; aRichEdit: TRichEdit);

function PutLineBreaks(const aText: String; aCharsPerLine: Byte): String;

function ExecuteCmd(aFTPClient       : TFtpClient;
                    aSyncCmd         : TSyncCmd;
                    aRichEdit        : TRichEdit;
                    aDescription     : ShortString = '';
                    aCommandDelay    : Word = 0;
                    aProgressBar     : TProgressBar = nil;
                    aLabelPercentDone: TLabel = nil): Boolean;

procedure Autenticar(aFTPClient: TFtpClient;
                     aUserName
                    ,aPassWord : ShortString;
                     aRichEdit : TRichEdit);

procedure Conectar(aFTPClient: TFtpClient;
                   aHostName : ShortString;
                   aPortNumb : Word;
                   aRichEdit : TRichEdit);

procedure Desconectar(aFTPClient: TFtpClient;
                      aRichEdit : TRichEdit);

procedure MudarDiretorio(aFTPClient: TFtpClient;
                         aDiretorio: ShortString;
                         aRichEdit : TRichEdit);

function ObterArquivo(aFTPClient       : TFtpClient;
                      aProgressBar     : TProgressBar;
                      aLabelPercentDone: TLabel;
                      aLocalFileName
                     ,aRemoteFileName  : ShortString;
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
                     aStatus: ShortString);
function GetUSFormatSettings: TFormatSettings;

function ReplaceSpecialConstants(aFilePath
                                ,aDefaultLocation: TFileName): ShortString;

function ParamIsPresent(aParamName: ShortString): Boolean;

function GetParamValue(aParamName: ShortString): ShortString;

const
  TXT = 0;
  BIN = 1;
  FORMATOS: array [0..1] of ShortString = ('OBJ','XML');

  { Comandos podem ter parâmetos ou não. Se houver parametros estes são
  colocados dentro das chaves, separados por vírgulas. Comandos podem ter
  respostas ou não. Caso haja resposta está será enviada como um arquivo de
  volta ao solicitante. Devido a natureza do FTP, mesmo comandos que não tem
  resposta retornam um valor genérico dentro de um arquivo. O arquivo gerado
  como resposta tem o mesmo nome do comando completo quando obtido a partir de
  um cliente de FTP comum ou o mesmo nome do comando sem os parâmetros, quando
  obtido a partir do MPS Updater Client }

  MODIFIEDFILES = 'MODIFIEDFILES';
  CMD_MODIFIEDFILES = MODIFIEDFILES + '{*,???,*}';

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
   , ShFolder;

const
  _APP   = '{APP}';
  _WIN   = '{WIN}';
  _SYS   = '{SYS}';
  _SD    = '{SD}';
  _PF    = '{PF}';
  _CF    = '{CF}';
  _FONTS = '{FONTS}';

  // {app} = Diretório onde a aplicação foi instalada com o instalador
  //         automático INNO SETUP
  // {win} = Diretório do windows. Tipicamente C:\WINDOWS ou C:\WINNT
  // {sys} = Diretório "System" ou "System32"
  // {sd} = Diretório do sistema, tipicamente "C:"
  // {pf} = Diretório "Arquivos de Programas"
  // {cf} = Diretório "Arquivos Comuns"
  // {fonts} = Diretório "Fonts"


function ParamIsPresent(aParamName: ShortString): Boolean;
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

function GetParamValue(aParamName: ShortString): ShortString;
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

function GetWinDir: ShortString;
var
  Buffer: array[0..Pred(MAX_PATH)] of Char;
begin
  GetWindowsDirectory(Buffer, SizeOf(Buffer) div SizeOf(Buffer[0]));
  Result := StrPas(Buffer);
end;

function GetSystemDir: ShortString;
var
  Buffer: array[0..Pred(MAX_PATH)] of Char;
begin
  GetSystemDirectory(Buffer, SizeOf(Buffer) div SizeOf(Buffer[0]));
  Result := StrPas(Buffer);
end;

function GetSystemDrive: ShortString;
begin
  Result := Copy(GetWinDir,1,2);
end;

function GetProgramFilesDir: ShortString;
var
  Buffer: array[0..Pred(MAX_PATH)] of Char;
begin
  SHGetSpecialFolderPath(0
                        ,Buffer
                        ,CSIDL_PROGRAM_FILES
                        ,False);
  Result := StrPas(Buffer);
end;

function GetCommonFilesDir: ShortString;
var
  Buffer: array[0..Pred(MAX_PATH)] of Char;
begin
  SHGetSpecialFolderPath(0
                        ,Buffer
                        ,CSIDL_PROGRAM_FILES_COMMON
                        ,False);
  Result := StrPas(Buffer);
end;

function GetFontsDir: ShortString;
var
  Buffer: array[0..Pred(MAX_PATH)] of Char;
begin
  SHGetSpecialFolderPath(0
                        ,Buffer
                        ,CSIDL_FONTS
                        ,False);
  Result := StrPas(Buffer);
end;

function GetAppDir: ShortString;
begin
  { É necessário ter o instalador e um GUID onde deveremos procurar pelo
  diretório de instalação. Até lá isso não poderá ser usado}
  Result := '';
end;

function ReplaceSpecialConstants(aFilePath
                                ,aDefaultLocation: TFileName): ShortString;

begin
  // {app} = Diretório onde a aplicação foi instalada com o instalador
  //         automático INNO SETUP
  // {win} = Diretório do windows. Tipicamente C:\WINDOWS ou C:\WINNT
  // {sys} = Diretório "System" ou "System32"
  // {sd} = Diretório do sistema, tipicamente "C:"
  // {pf} = Diretório "Arquivos de Programas"
  // {cf} = Diretório "Arquivos Comuns"
  // {fonts} = Diretório "Fonts"

  Result := UpperCase(aFilePath);

  if Pos(_APP,Result) = 1 then
    Result := StringReplace(Result
                           ,_APP,GetAppDir,[])
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
                           ,_FONTS,GetFontsDir,[])
  else
  begin
    if aDefaultLocation <> '' then
    begin
      { Seria bom aqui validar o caminho padrão antes de usá-lo }
      Result := aDefaultLocation + '\' + Result
    end
    else
      raise EInvalidPath.Create('Não há constante de substituição e não foi informado um local padrão para o caminho "' + aFilePath + '". Não é possível obter este arquivo');
  end;
end;

function GetUSFormatSettings: TFormatSettings;
begin
  ZeroMemory(@Result,SizeOf(TFormatSettings));
  GetLocaleFormatSettings(((SORT_DEFAULT shl 16) or (SUBLANG_ENGLISH_US shl 10) or LANG_ENGLISH),Result);
end;

procedure SendStatus(aClient: TConnectedClient;
                     aStatus: ShortString);
begin
	if Assigned(aClient) then
      aClient.SendAnswer('150-' + aStatus);
end;

function PutLineBreaks(const aText: String; aCharsPerLine: Byte): String;
var
  BreakPos: Byte;
  LineToAdd: ShortString;
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

procedure ShowOnLog(const aText: String; aRichEdit: TRichEdit);
var
  Linhas: TStringList;
  i: Word;
  LinhaAExibir: ShortString;

  function FirstToken(Line: String): ShortString;
  begin
  	Result := Copy(Line,1,Pred(Pos(' ',Line)));
  end;

  function FirstAndSecondTokens(Line: String): ShortString;
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

          { RETORNO:> ??? - XXXXXXXXXXXX }

          {$IFDEF CLIENT}
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
                   ,[fsBold])
        end
        else
        begin
          // 24/08/2010 09:08:26 ] § XXXX LINHA xxxx
          // ||||||||||||||||||| ] § XXXX LINHA xxxx
          if (Linhas[0][1] <> '!') and  (Linhas[0][1] <> '§') and (Linhas[0][1] <> '@') then
            LinhaAExibir := FirstAndSecondTokens(Linhas[0]) + ' - ' + Linhas[i]
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

          { § XXXX LINHA xxxx }
          if LinhaAExibir[1] = '!' then
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
        end;
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
    SendMessage(aRichEdit.Handle,EM_SCROLLCARET,0,0);
  end;
end;



(*


procedure ShowOnLog(const aText: String; aRichEdit: TRichEdit);
var
  Linhas: TStringList;
  i: Word;
  LinhaAExibir: ShortString;

  function FirstToken(Line: String): ShortString;
  begin
  	Result := Copy(Line,1,Pred(Pos(' ',Line)));
  end;

  function FirstAndSecondTokens(Line: String): ShortString;
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
function TFileInformation.GetFileInfo(const aInfo: ShortString): TMultiTypedResult;
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
	    AsShortString := IntToStr(AsWord);
    end
    else if aInfo = 'MINORVERSION' then
    begin
      AsWord := LoWord(FFileInfo.dwFileVersionMS);
	    AsShortString := IntToStr(AsWord);
    end
    else if aInfo = 'RELEASE' then
    begin
      AsWord := HiWord(FFileInfo.dwFileVersionLS);
	    AsShortString := IntToStr(AsWord);
    end
    else if aInfo = 'BUILD' then
    begin
      AsWord := LoWord(FFileInfo.dwFileVersionLS);
	    AsShortString := IntToStr(AsWord);
    end
    else if aInfo = 'FULLVERSION' then
    begin
	    AsShortString := GetFileInfo('MAJORVERSION').AsShortString + '.' + GetFileInfo('MINORVERSION').AsShortString + '.' + GetFileInfo('RELEASE').AsShortString + '.' + GetFileInfo('BUILD').AsShortString;
      AsInt64 := StrToInt64(GetFileInfo('MAJORVERSION').AsShortString + GetFileInfo('MINORVERSION').AsShortString + GetFileInfo('RELEASE').AsShortString + GetFileInfo('BUILD').AsShortString);
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

class function TFileInformation.GetInfo(const aFileName: TFileName; const aInfo: ShortString): TMultiTypedResult;
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
  	aProgressBar.Position := aPosition;

  if Assigned(aLabelPercentDone) then
  	if aProgressBar.Max > 0 then
  		aLabelPercentDone.Caption := Format('%d%%',[Round(aProgressBar.Position / aProgressBar.Max * 100)])
  	else
  		aLabelPercentDone.Caption := '0%';
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
                   aHostName : ShortString;
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
                    ,aPassWord : ShortString;
                     aRichEdit : TRichEdit);
var
	ErrorText: ShortString;
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
                         aDiretorio: ShortString;
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
                     ,aRemoteFileName  : ShortString;
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
                    aDescription     : ShortString = '';
                    aCommandDelay    : Word = 0;
                    aProgressBar     : TProgressBar = nil;
                    aLabelPercentDone: TLabel = nil): Boolean;
var
	Text: ShortString;
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
    WaitFor(aCommandDelay);
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

procedure TModifiedFiles.Clear;
begin
  FFiles.Clear;
end;

constructor TModifiedFiles.Create(aOwner: TComponent);
begin
  inherited;
  FFiles := TFiles.Create(TFileInfo);
end;

destructor TModifiedFiles.Destroy;
begin
  FFiles.Free;
  inherited;
end;

{ TFiles }

function TFiles.Add: TFileInfo;
begin
	Result := TFileInfo(inherited Add);
end;

function TFiles.GetFileInfo(i: Cardinal): TFileInfo;
begin
	Result := TFileInfo(inherited Items[i]);
end;

end.
