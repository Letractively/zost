unit UFSYTypesConstantsAndClasses;

interface

uses
  	SysUtils, Classes, UObjectFile, ComCtrls, StdCtrls, ZSQLProcessor,
    OverbyteIcsFtpSrv, ZConnection;

type
    {$IFDEF THREADED}
    TGetProcessingThread = class;
    {$ENDIF}

    TConnectedClient  = class(TFtpCtrlSocket)
    private
        FRealName: AnsiString;
        FDescription: AnsiString;
        FIP: AnsiString;
        {$IFDEF THREADED}
        FWorkerThread: TGetProcessingThread;
        {$ENDIF}
    public
        { TODO -oCARLOS FEITOZA -cEXPLICAÇÃO : Foi necessário manter
        DataBaseConnection como um campo público de forma que ele pudesse ser
        usado com a função ConfigureConnection }
        DataBaseConnection: TZConnection;

        constructor Create(AOwner: TComponent); override;

        property RealName: AnsiString read FRealName write FRealName;
        property Description: AnsiString read FDescription write FDescription;
        property IP: AnsiString read FIP write FIP;
    end;
    {$IFDEF THREADED}
        isso tem de ser consertado
    TGetProcessingThread = class(TThread)
    private
        { Variáveis de objetos externos à thread }
        FServer: TFtpServer;
        FClient: TConnectedClient;
        FFSSForm_Main: TFSSForm_Main;
        FVerboseMode: Boolean;

        FLogMessage: AnsiString;
        FStatusMessage: AnsiString;
        FAbortMessage: AnsiString;

        procedure DoGetChecksum(      aTableName: AnsiString;
                                      aTableNo
                                    , aTableCount: Word;
                                      aTableChecksum: AnsiString;
                                const aIgnored: Boolean);
        procedure DoZlibNotification(aNotificatioType: TZlibNotificationType; aOperation: TZLibOperation; aInputFile, aOutputFile: TFileName);

        { Membros que tornam possível o envio de mensagem para o log }
        procedure SetLogMessage(const aValue: AnsiString);
        procedure ShowOnLog;

        { Membros que tornam possível o envio de mensagem para o cliente }
        procedure SetStatusMessage(const aValue: AnsiString);
        procedure SendStatus;

        { Membros que tornam possível o término da conexão por causa de um erro }
        procedure SetAbortMessage(const aValue: AnsiString);
        procedure AbortEveryThing;
    protected
        property Server: TFtpServer read FServer write FServer;
        property Client: TConnectedClient read FClient write FClient;

        property FSSForm_Main: TFSSForm_Main write FFSSForm_Main;
//        property FSYGlobals: TFSYGlobals write FFSYGlobals;
//        property RichEditLog: TRichEdit write FRichEditLog;

        property LogMessage: AnsiString write SetLogMessage;
        property StatusMessage: AnsiString write SetStatusMessage;
        property AbortMessage: AnsiString write SetAbortMessage;
    public
        procedure Execute; override;
    end;
    {$ENDIF}

    EAddSynchronizableItem = class(Exception)
    private
        fTableName: AnsiString;
        fPrimaryKeyValue: Cardinal;
        fActionPerformed: Byte; { Precisará de cast para TActionPerformed }
    public
        constructor CreateFmt(const aTableName: AnsiString; const aPrimaryKeyValue: Cardinal; const aActionPerformed: Byte; const aMsg: AnsiString; const aArgs: array of const);
        constructor Create(const aTableName: AnsiString; const aPrimaryKeyValue: Cardinal; const aActionPerformed: Byte; const aMsg: AnsiString);
    end;

    TScriptPart = class (TCollectionItem)
    private
    	FDelimiter: AnsiString;
        FScript: AnsiString;
    public
    	constructor Create(Collection: TCollection); override;
    	property Delimiter: AnsiString read FDelimiter write FDelimiter;
        property Script: AnsiString read FScript write FScript;
    end;

    TScriptParts = class (TCollection)
    private
	    function GetScriptPart(i: Cardinal): TScriptPart;
	    function GetLast: TScriptPart;
	public
	    function Add: TScriptPart;
		property Part[i: Cardinal]: TScriptPart read GetScriptPart; default;
        property Last: TScriptPart read GetLast;
    end;

    TProcessorEvents = class
    private
    	FProgressBarCurrent: TProgressBar;
        FLabelCurrentValue: TLabel;
        FLabelCurrentDescription: TLabel;
    public
    	constructor Create(aProgressBarCurrent: TProgressBar; aLabelCurrentValue, aLabelCurrentDescription: TLabel);
    	procedure DoAfterExecute(Processor: TZSQLProcessor; StatementIndex: Integer);
    	procedure DoBeforeExecute(Processor: TZSQLProcessor; StatementIndex: Integer);
    end;

    TVersion = class(TPersistent)
    private
	    FMinor: Word;
    	FRelease: Word;
	    FMajor: Word;
    	FBuild: Word;
        function GetFullVersionNumber: Int64;
        function GetFullVersionString: AnsiString;
//	    FFullVersionNumber: Int64;
//    	FFullVersionString: AnsiString;
    public
    	constructor Create;
        property FullVersionString: AnsiString read GetFullVersionString;
		property FullVersionNumber: Int64 read GetFullVersionNumber;
    published
    	property Minor: Word read FMinor write FMinor;
    	property Major: Word read FMajor write FMajor;
    	property Release: Word read FRelease write FRelease;
    	property Build: Word read FBuild write FBuild;
    end;

	TServerInformation = class(TObjectFile)
  	private
	    FDateAndTime: TDateTime;
	    FVersion: TVersion;
        FMinimumClientVersion: TVersion;
    public
    	constructor Create(aOwner: TComponent); override;
        destructor Destroy; override;
        procedure Clear; override;
  	published
        property DateAndTime: TDateTime read FDateAndTime write FDateAndTime;
        property Version: TVersion read FVersion write FVersion;
        property MinimumClientVersion: TVersion read FMinimumClientVersion write FMinimumClientVersion;
    end;

  TConfigurations = packed record
		{ Bando de dados }
		DB_Password: String[255];
		DB_UserName: String[255];
		DB_Protocol: String[255];
		DB_DataBase: String[255];
		DB_HostAddr: String[255];
		DB_PortNumb: Word;
  	{ FTP }
    {$IFDEF FTPSYNCCLI}
    FT_UserName: String[255];
    FT_PassWord: String[255];
    FT_HostName: String[255];
    FT_PassiveMode: Boolean;
    FT_CommandDelay: Byte;
    {$ENDIF}
    FT_PortNumb: Word;
    FT_TimeOut: Word;

  	{ LOGs }
    {$IFDEF FTPSYNCSER}
    SalvarLogACada: Word;
    {$ENDIF}
    {$IFDEF FTPSYNCCLI}
    VerboseMode: Boolean;
    CheckMD5: Boolean;
    UseCompression: Boolean;
    {$ENDIF}
  end;

const
  MINIMUM_CLIENT_MAJORVERSION = 4;
  MINIMUM_CLIENT_MINORVERSION = 0;
  MINIMUM_CLIENT_RELEASE      = 1;
  MINIMUM_CLIENT_BUILD        = 100;

	MAX_QUERY_SIZE: Word = High(SmallInt);
	ARQUIVO_DE_CONFIGURACOES: AnsiString = 'FTPSyncConfig.dat';
	DB_PASSWORD: AnsiString = '';
	DB_USERNAME: AnsiString = 'root';
	DB_PROTOCOL: AnsiString = 'mysql-5';
	DB_DATABASE: AnsiString = '';
	DB_HOSTADDR: AnsiString = '127.0.0.1';
	DB_PORTNUMB: Word = 3306;
  	(* FTP *)
    {$IFDEF FTPSYNCCLI}
    FTP_USERNAME = '';
    FTP_PASSWORD = '';
    FTP_HOSTNAME = '10.0.2.2';
    FTP_PASSIVEMODE = TRUE;
    FTP_COMMANDDELAY = 0;
    {$ENDIF}
  	FTP_PORTNUMB = 3304;
    FTP_TIMEOUT  = 1200;
  	(* LOG *)
    {$IFDEF FTPSYNCSER}
  	SALVAR_LOG = 0;
    {$ENDIF}
    {$IFDEF FTPSYNCCLI}
    VERBOSEMODE = TRUE;
    CHECKMD5 = FALSE;
    USE_COMPRESSION = TRUE;
    {$ENDIF}

    {$IFDEF FTPSYNCSER}
  	FTPSYNC_COPYRIGHT = 'Copyright %s Carlos Barreto Feitoza Filho. Todos os direitos reservados.';
  	FTPSYNC_CUSTOMBANNER = 'Customizado para Hitachi Ar Condicionado do Brasil Ltda.';
  	FTPSYNC_CUSTOMCLIENT = 'Hitachi Ar Condicionado do Brasil Ltda.';
  	FTPSYNC_WELCOME =
  	'220 - Bem-vindo(a) ao Servidor FTP Syncronizer (FTPSync)'#13#10 +
	'220 - ' + FTPSYNC_COPYRIGHT + #13#10 +
  	'220 - ATENÇÃO: ESTE SERVIDOR É PRIVADO,  O QUE SIGNIFICA  QUE ELE  NÃO ACEITA  LOGINS '#13#10 +
  	'220 - ANÔNIMOS. SE  VOCÊ NÃO POSSUI LOGIN  E SENHA VÁLIDOS  PARA ESTE SERVIDOR,  SAIA '#13#10 +
  	'220 - IMEDIATAMENTE, DO CONTRÁRIO SERÃO TOMADAS MEDIDAS LEGAIS. SEU IP,  ASSIM COMO A '#13#10 +
  	'220 - DATA E A HORA DE SUA CONEXÃO JÁ FORAM LOGADOS. '#13#10 +
  	'220 - ------------------------------------------------------------------------------- '#13#10 +
  	'220 - ' + FTPSYNC_CUSTOMBANNER + #13#10 +
  	'220 - ------------------------------------------------------------------------------- ';
    FTPSYNC_CLIENT_AUTHENTICATED =
    '230 - %s sr(a). %s'#13#10 +
    '230 - Espero poder ajudá-lo(a) da melhor forma possível. Por favor, lembre-se  de que '#13#10 +
    '230 - este servidor só  aceita uma conexão por vez, por isso, realize conscientemente '#13#10 +
    '230 - suas  ações,  pois  podem  haver  outros   usuários  esperando.  Obrigado  pela '#13#10 +
    '230 - compreensão e bom trabalho!';

  SQL_SELECT_ALL_USERS2 =
	'SELECT USER.USER'#13#10 +
  '     , USER.PASSWORD'#13#10 +
  '  FROM MYSQL.USER'#13#10 +
  ' WHERE USER.USER = ''%s'''#13#10 +
  '   AND USER.PASSWORD = PASSWORD(''%s'')';
  SQL_SELECT_ALL_USERS =
	'   SELECT USER.USER'#13#10 +
  '        , USER.PASSWORD'#13#10 +
  '        , USER_INFO.FULL_NAME'#13#10 +
  '        , USER_INFO.DESCRIPTION'#13#10 +
  '     FROM MYSQL.USER'#13#10 +
  'LEFT JOIN MYSQL.USER_INFO ON USER.USER = USER_INFO.USER'#13#10 +
  '    WHERE USER.USER = ''%s'' AND USER.PASSWORD = PASSWORD(''%s'')';
  {$ENDIF}

  { ARQUIVO DE PARÂMETROS GERAIS ONDE OS PARÂMETROS DOS COMANDOS OU SCRIPTS
  SÃO EMPACOTADOS PARA NO SERVIDOR SEREM LIDOS E DECODIFICADOS }
  FTPFIL_PARAMETERS = 'PARAMETERS.DAT';


  { SCRIPTS DE FTP E SEUS ARQUIVOS GERADOS }
  FTPFIL_REMOTESNAPSHOT = 'REMOTESNAPSHOT.DAT';
  FTPSCR_REMOTESNAPSHOT = 'SCRIPTS\GET.' + FTPFIL_REMOTESNAPSHOT + '.PHPS';

  FTPFIL_SERVER_DELTA = 'SERVER_DELTA.DAT';
  FTPSCR_SERVER_DELTA = 'SCRIPTS\GET.' + FTPFIL_SERVER_DELTA + '.PHPS';

  FTPFIL_CLIENT_DELTA = 'CLIENT_DELTA.DAT';

  FTPFIL_LASTSYNCHRONIZEDON = 'LASTSYNCHRONIZEDON.DAT';

	FTPFIL_DBCHECKSUM = 'DBCHECKSUM.MD5';
  FTPSCR_DBCHECKSUM = 'SCRIPTS\GET.' + FTPFIL_DBCHECKSUM + '.PHPS';

  FTPFIL_SERVERINFO = 'SERVERINFO.DAT';
  FTPSCR_SERVERINFO = 'SCRIPTS\GET.' + FTPFIL_SERVERINFO + '.PHPS';

  FTPFIL_CONFIRMEVERYTHING = 'CONFIRMEVERYTHING.DAT';
  FTPSCR_CONFIRMEVERYTHING = 'SCRIPTS\DO.' + FTPFIL_CONFIRMEVERYTHING + '.PHPS';

//    FTPFIL_NEWACTIONS = 'NEWACTIONS.DAT';
//    FTPSCR_NEWACTIONS = 'SCRIPTS\GET.' + FTPFIL_NEWACTIONS + '.PHPS';

  FTPFIL_SERVER_DATABASE = 'SERVER_DATABASE.DAT';
  FTPSCR_SERVER_DATABASE = 'SCRIPTS\GET.' + FTPFIL_SERVER_DATABASE + '.PHPS';

  FTPFIL_TEMPFILENAMES = 'TEMPFILENAMES.DAT';
  FTPSCR_TEMPFILENAMES = 'SCRIPTS\GET.' + FTPFIL_TEMPFILENAMES + '.PHPS';

  FTPFIL_TIMEOUTTEST = 'TIMEOUTTEST.DAT';
  FTPSCR_TIMEOUTTEST = 'SCRIPTS\GET.' + FTPFIL_TIMEOUTTEST + '.PHPS';

  FTPFIL_CONTENTSIZETEST = 'CONTENTSIZETEST.DAT';
  FTPSCR_CONTENTSIZETEST = 'SCRIPTS\GET.' + FTPFIL_CONTENTSIZETEST + '.PHPS';

resourcestring
  rs_ezse = '-------------------------------------------------------------------------------\nErro ao executar as instruções SQL com o método %s.\n\n%s\n-------------------------------------------------------------------------------';
  rs_ezde = '-------------------------------------------------------------------------------\nErro ao tentar conectar-se com o banco de dados no método %s.\n\n%s\n-------------------------------------------------------------------------------';
    
implementation

uses
  Forms,

  UXXXTypesConstantsAndClasses,

  UFSYGlobals;

{ TConnectedClient }

constructor TConnectedClient.Create(AOwner: TComponent);
begin
    inherited;
    DataBaseConnection := nil;
    FUserName := '';
    FPassword := '';
    FRealName := '';
    FDescription := '';
end;

{ TServerInformation }

procedure TServerInformation.Clear;
begin
  	inherited;
    { Foi incluído aqui apenas para remover o warning de compilação }
end;

constructor TServerInformation.Create(aOwner: TComponent);
begin
	inherited;
    FDateAndTime := Now;
    FVersion := TVersion.Create;
    FMinimumClientVersion := TVersion.Create;
end;

destructor TServerInformation.Destroy;
begin
    FMinimumClientVersion.Free;
    FVersion.Free;
  	inherited;
end;

{ TScriptPart }

constructor TScriptPart.Create(Collection: TCollection);
begin
  	inherited;
    FScript := '';
    FDelimiter := ';';
end;

{ TScriptParts }

function TScriptParts.Add: TScriptPart;
begin
	Result := TScriptPart(inherited Add);
end;

function TScriptParts.GetLast: TScriptPart;
begin
	if Count = 0 then
    	Result := nil
    else
    	Result := GetScriptPart(Pred(Count));
end;

function TScriptParts.GetScriptPart(i: Cardinal): TScriptPart;
begin
	Result := TScriptPart(inherited Items[i]);
end;

{ TProcessorEvents }

constructor TProcessorEvents.Create(aProgressBarCurrent: TProgressBar; aLabelCurrentValue, aLabelCurrentDescription: TLabel);
begin
	FProgressBarCurrent := aProgressBarCurrent;
    FLabelCurrentValue := aLabelCurrentValue;
    FLabelCurrentDescription := aLabelCurrentDescription;
end;

procedure TProcessorEvents.DoAfterExecute(Processor: TZSQLProcessor; StatementIndex: Integer);
begin
  if Assigned(FProgressBarCurrent) then
    FProgressBarCurrent.StepIt;
end;

procedure TProcessorEvents.DoBeforeExecute(Processor: TZSQLProcessor; StatementIndex: Integer);
begin
  if Assigned(FLabelCurrentDescription) and Assigned(FLabelCurrentValue) then
  begin
    TFSYGlobals.SetLabelDescriptionValue(FLabelCurrentDescription,FLabelCurrentValue,AnsiString(IntToStr(Succ(StatementIndex))) + ' / ' + AnsiString(IntToStr(Processor.StatementCount)));
  end;
end;

{ TVersion }

constructor TVersion.Create;
begin
	FMinor := TFileInformation.GetInfo(ParamStr(0),'MINORVERSION').AsWord;
	FMajor := TFileInformation.GetInfo(ParamStr(0),'MAJORVERSION').AsWord;
	FRelease := TFileInformation.GetInfo(ParamStr(0),'RELEASE').AsWord;
	FBuild := TFileInformation.GetInfo(ParamStr(0),'BUILD').AsWord;
end;

function TVersion.GetFullVersionNumber: Int64;
begin
    Result := StrToInt64(IntToStr(FMajor)
                        +IntToStr(FMinor)
                        +IntToStr(FRelease)
                        +IntToStr(FBuild));
end;

function TVersion.GetFullVersionString: AnsiString;
begin
  Result := AnsiString(IntToStr(FMajor)) + '.' + AnsiString(IntToStr(FMinor)) + '.' + AnsiString(IntToStr(FRelease)) + '.' + AnsiString(IntToStr(FBuild));
end;

{ EDeltaReferenceNotFound }

constructor EAddSynchronizableItem.Create(const aTableName: AnsiString;
                                          const aPrimaryKeyValue: Cardinal;
                                          const aActionPerformed: Byte;
                                          const aMsg: AnsiString);
begin
  inherited Create(String(aMsg));
  fTableName := aTableName;
  fPrimaryKeyValue := aPrimaryKeyValue;
  fActionPerformed := aActionPerformed;
end;

constructor EAddSynchronizableItem.CreateFmt(const aTableName: AnsiString;
                                             const aPrimaryKeyValue: Cardinal;
                                             const aActionPerformed: Byte;
                                             const aMsg: AnsiString;
                                             const aArgs: array of const);
begin
  inherited CreateFmt(String(aMsg),aArgs);
  fTableName := aTableName;
  fPrimaryKeyValue := aPrimaryKeyValue;
  fActionPerformed := aActionPerformed;
end;

end.


