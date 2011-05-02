unit UDataModule_Principal;

interface

uses
  Classes, ActnList, DB,
  ZDataset, ZConnection, ExtCtrls, 
  Controls, CFDBValidationChecks, Windows, SysUtils, UBalloonToolTip, Forms, ImgList,
  ZAbstractRODataset, ZAbstractDataset, UCFSHChangeNotify, ZSqlUpdate,
  OverbyteIcsWndControl, OverbyteIcsFtpSrv, OverbyteIcsWSocket, UGlobalFunctions,
  Menus, ActnPopup, Dialogs;

type
  TFileInfo = class (TCollectionItem)
  private
    FFullPath: ShortString;
    FDateTime: TDateTime;
    FSize: Cardinal;
  public
    property FullPath: ShortString read FFullPath write FFullPath;
    property DateTime: TDateTime read FDateTime write FDateTime;
    property Size: Cardinal read FSize write FSize;
  end;

  TFileInfos = class (TCollection)
	private
    function GetFileInfo(i: Cardinal): TFileInfo;
  public
    function Add: TFileInfo;
	  property FileInfo[i: Cardinal]: TFileInfo read GetFileInfo; default;
  end;

  TMonitoredSystem = class (TCollectionItem)
  private
    FCFSHChangeNotifier: TCFSHChangeNotifier;
    FID: Int64;
    FSystemName: ShortString;
    FFileInfos: TFileInfos;
    FZReadOnlyQuery: TZReadOnlyQuery;
    procedure GetRelativePaths;
    procedure ClearFilesFromSystem;
    procedure AddFilesToSystem;
  public
    constructor Create(Collection: TCollection); override;
    destructor Destroy; override;
    procedure DoNotification; 
    property CFSHChangeNotifier: TCFSHChangeNotifier read FCFSHChangeNotifier;
    property ID: Int64 read FID write FID;
    property SystemName: ShortString read FSystemName write FSystemName;
    property FileInfos: TFileInfos read FFileInfos;
  end;

  TMonitoredSystems = class (TCollection)
	private
    FZConnection: TZConnection;
    function GetMonitoredSystem(i: Word): TMonitoredSystem;
    function GetMonitoredSystemById(id: Int64): TMonitoredSystem;
    function GetLastMonitoredSystem: TMonitoredSystem;
  public
    constructor Create(ItemClass: TCollectionItemClass; aZConnection: TZConnection); reintroduce;
    function Add: TMonitoredSystem;
	  property MonitoredSystem[i: Word]: TMonitoredSystem read GetMonitoredSystem; default;
    property MonitoredSystemById[id: Int64]: TMonitoredSystem read GetMonitoredSystemById;
    property LastMonitoredSystem: TMonitoredSystem read GetLastMonitoredSystem;
    property ZConnection: TZConnection read FZConnection;
  end;

  TDBAction = (dbaBeforeInsert, dbaBeforeEdit);

  TDataModule_Principal = class(TDataModule)
    ActionList_Principal: TActionList;
    Action_DesativarServidor: TAction;
    Action_AtivarServidor: TAction;
    Action_ConfigurarServidor: TAction;
    Action_Sobre: TAction;
    ZConnection_Principal: TZConnection;
    SISTEMAS: TZQuery;
    DataSource_SIS: TDataSource;
    TrayIcon_Principal: TTrayIcon;
    SISTEMASBI_SISTEMAS_ID: TLargeintField;
    SISTEMASVA_NOME: TStringField;
    SISTEMASVA_DIRETORIO: TStringField;
    SISTEMASVA_DESCRICAO: TStringField;
    Action_DiretorioDeMonitoramento: TAction;
    ImageList_Principal: TImageList;
    CFDBValidationChecks_SIS: TCFDBValidationChecks;
    DataSource_ARQ: TDataSource;
    ZUpdateSQL_SIS: TZUpdateSQL;
    ARQUIVOS: TZQuery;
    ARQUIVOSBI_ARQUIVOS_ID: TLargeintField;
    ARQUIVOSBI_SISTEMAS_ID: TLargeintField;
    ARQUIVOSVA_CAMINHOCOMPLETO: TStringField;
    ARQUIVOSDT_DATAEHORA: TDateTimeField;
    Action_MinimizeToTray: TAction;
    FtpServer_Main: TFtpServer;
    USUARIOS: TZQuery;
    ZUpdateSQL_USU: TZUpdateSQL;
    DataSource_USU: TDataSource;
    USUARIOSVA_NOME: TStringField;
    USUARIOSVA_LOGIN: TStringField;
    USUARIOSVA_SENHA: TStringField;
    USUARIOSVA_EMAIL: TStringField;
    USUARIOSBI_USUARIOS_ID: TLargeintField;
    DataSource_SDU: TDataSource;
    Action_SDU_Adicionar: TAction;
    Action_SDU_Remover: TAction;
    SISTEMASDOSUSUARIOS: TZQuery;
    SISTEMASDOSUSUARIOSVA_NOME: TStringField;
    SISTEMASDOSUSUARIOSBI_SISTEMAS_ID: TLargeintField;
    SISTEMASDOSUSUARIOSBI_USUARIOS_ID: TLargeintField;
    USUARIOSBO_ADMINISTRADOR: TSmallintField;
    Timer_UpdateClientCount: TTimer;
    PopupActionBar_TrayIcon: TPopupActionBar;
    Servidor1: TMenuItem;
    Ativar1: TMenuItem;
    Desativar1: TMenuItem;
    Ajuda1: TMenuItem;
    SobreoMPSUpdater1: TMenuItem;
    N1: TMenuItem;
    ServidorFTP1: TMenuItem;
    Action_RestaurarAplicacao: TAction;
    N2: TMenuItem;
    ActionRestaurarAplicacao1: TMenuItem;
    Action_Sair: TAction;
    Sair1: TMenuItem;
    EXCLUSOES: TZQuery;
    EXCLUSOESBI_ARQUIVOS_ID: TLargeintField;
    EXCLUSOESBI_SISTEMAS_ID: TLargeintField;
    EXCLUSOESVA_CAMINHOCOMPLETO: TStringField;
    DataSource_EXC: TDataSource;
    ZUpdateSQL_EXC: TZUpdateSQL;
    SISTEMASVA_CHAVEDEINSTALACAO: TStringField;
    ZUpdateSQL_ARQ: TZUpdateSQL;
    SaveDialog_Log: TSaveDialog;
    procedure DataModuleCreate(Sender: TObject);
    procedure ZConnection_PrincipalAfterConnect(Sender: TObject);
    procedure Action_DiretorioDeMonitoramentoExecute(Sender: TObject);
    procedure SISTEMASBeforePost(DataSet: TDataSet);
    procedure DataModuleDestroy(Sender: TObject);
    procedure CFDBValidationChecks_SISCustomValidate(const aSender: TObject;
                                                     const aValidateAction: TValidateAction;
                                                     const aValidateMoment: TValidateMoment);
    procedure SISTEMASBeforeEdit(DataSet: TDataSet);
    procedure SISTEMASBeforeInsert(DataSet: TDataSet);
    procedure SISTEMASAfterPost(DataSet: TDataSet);
    procedure SISTEMASBeforeDelete(DataSet: TDataSet);
    procedure SISTEMASAfterDelete(DataSet: TDataSet);
    procedure DataSource_ARQDataChange(Sender: TObject; Field: TField);
    procedure Action_MinimizeToTrayExecute(Sender: TObject);
    procedure FtpServer_MainAnswerToClient(Sender: TObject; Client: TFtpCtrlSocket; var Answer: TFtpString);
    procedure FtpServer_MainAuthenticate(Sender: TObject; Client: TFtpCtrlSocket; UserName, Password: TFtpString; var Authenticated: Boolean);
    procedure FtpServer_MainChangeDirectory(Sender: TObject; Client: TFtpCtrlSocket; Directory: TFtpString; var Allowed: Boolean);
    procedure FtpServer_MainClientCommand(Sender: TObject; Client: TFtpCtrlSocket; var Keyword, Params, Answer: TFtpString);
    procedure FtpServer_MainClientConnect(Sender: TObject; Client: TFtpCtrlSocket; AError: Word);
    procedure FtpServer_MainClientDisconnect(Sender: TObject; Client: TFtpCtrlSocket; AError: Word);
    procedure FtpServer_MainGetProcessing(Sender: TObject; Client: TFtpCtrlSocket; var DelayedSend: Boolean);
    procedure FtpServer_MainMakeDirectory(Sender: TObject; Client: TFtpCtrlSocket; Directory: TFtpString; var Allowed: Boolean);
    procedure FtpServer_MainRetrSessionClosed(Sender: TObject; Client: TFtpCtrlSocket; Data: TWSocket; AError: Word);
    procedure FtpServer_MainRetrSessionConnected(Sender: TObject; Client: TFtpCtrlSocket; Data: TWSocket; AError: Word);
    procedure FtpServer_MainStart(Sender: TObject);
    procedure FtpServer_MainStop(Sender: TObject);
    procedure FtpServer_MainStorSessionClosed(Sender: TObject; Client: TFtpCtrlSocket; Data: TWSocket; AError: Word);
    procedure FtpServer_MainStorSessionConnected(Sender: TObject; Client: TFtpCtrlSocket; Data: TWSocket; AError: Word);
    procedure FtpServer_MainValidateDele(Sender: TObject; Client: TFtpCtrlSocket; var FilePath: TFtpString; var Allowed: Boolean);
    procedure FtpServer_MainValidateGet(Sender: TObject; Client: TFtpCtrlSocket; var FilePath: TFtpString; var Allowed: Boolean);
    procedure FtpServer_MainValidatePut(Sender: TObject; Client: TFtpCtrlSocket; var FilePath: TFtpString; var Allowed: Boolean);
    procedure FtpServer_MainValidateRmd(Sender: TObject; Client: TFtpCtrlSocket; var FilePath: TFtpString; var Allowed: Boolean);
    procedure FtpServer_MainValidateRnFr(Sender: TObject; Client: TFtpCtrlSocket; var FilePath: TFtpString; var Allowed: Boolean);
    procedure FtpServer_MainValidateRnTo(Sender: TObject; Client: TFtpCtrlSocket; var FilePath: TFtpString; var Allowed: Boolean);
    procedure FtpServer_MainValidateSize(Sender: TObject; Client: TFtpCtrlSocket; var FilePath: TFtpString; var Allowed: Boolean);
    procedure Action_AtivarServidorExecute(Sender: TObject);
    procedure Action_DesativarServidorExecute(Sender: TObject);
    procedure USUARIOSBeforeEdit(DataSet: TDataSet);
    procedure USUARIOSBeforeInsert(DataSet: TDataSet);
    procedure USUARIOSVA_SENHAGetText(Sender: TField; var Text: string; DisplayText: Boolean);
    procedure USUARIOSVA_SENHASetText(Sender: TField; const Text: string);
    procedure Action_SDU_AdicionarExecute(Sender: TObject);
    procedure Action_SDU_RemoverExecute(Sender: TObject);
    procedure DataSource_SDUDataChange(Sender: TObject; Field: TField);
    procedure FtpServer_MainRetrDataSent(Sender: TObject;  Client: TFtpCtrlSocket; Data: TWSocket; AError: Word);
    procedure Action_SobreExecute(Sender: TObject);
    procedure Timer_UpdateClientCountTimer(Sender: TObject);
    procedure Action_RestaurarAplicacaoExecute(Sender: TObject);
    procedure Action_SairExecute(Sender: TObject);
    procedure EXCLUSOESAfterInsert(DataSet: TDataSet);
    procedure EXCLUSOESBeforeEdit(DataSet: TDataSet);
    procedure EXCLUSOESBeforeInsert(DataSet: TDataSet);
    procedure ARQUIVOSBeforeDelete(DataSet: TDataSet);
    procedure DataSource_EXCDataChange(Sender: TObject; Field: TField);
    procedure ZUpdateSQL_ARQAfterDeleteSQL(Sender: TObject);
    procedure ARQUIVOSAfterDelete(DataSet: TDataSet);
    procedure EXCLUSOESBeforeDelete(DataSet: TDataSet);
  private
    { Private declarations }
    FMonitoredSystems: TMonitoredSystems;
    FCurrentSystemId: Word;
    FTPPublic: ShortString;
//    FCaminhoExcluido: ShortString;
//    FSistema: Cardinal;

    procedure ConfigureEnvironment;
    procedure HandleException(Sender: TObject; E: Exception);
    procedure ShowBalloonToolTipValidationFor(aCurrentForm: TForm; aDataSet: TDataSet; aFieldError: TField);
    function IsValidDataWareComponent(aComponent: TComponent; out aDataSet: TDataSet; out aDataField: TField): Boolean;
    function SHBrowseForObject(const aOwner: TComponent;
                               const aDialogTitle: ShortString;
                               const aDialogText: String;
                                 out aSelection: String): Boolean;
    procedure SetRefreshSQL(const aZQuery: TZQuery;
                            const aDBAction: TDBAction);
    procedure UpdateClientCount;
    procedure ProcessRequest(aClient: TConnectedClient);
    procedure AtivarFTP;
    function DesativarFTP: Boolean;
    function UsuarioAutenticado(Usuario, Senha: ShortString; ClienteConectado: TConnectedClient): Boolean;
    procedure ExecuteQuery(const aDBConnection: TZConnection; const aSQLCommand: String);
    function IsAllowedDir(aDir: ShortString; aUserID: Cardinal): Boolean;
    function IsAllowedIp(aIP: ShortString): Boolean;
    function IsSuperUser(aID: Cardinal): Boolean;
    procedure MinimizarNaBarraDeTarefas(aSender: TObject);
    procedure ExcluirArquivosSelecionados;
    function HostNameToIP(const HostName: string): string;
    function IPToHostName(aIP: String): String;
  public
    { Public declarations }
  end;

var
  DataModule_Principal: TDataModule_Principal;

implementation

uses UForm_Principal
   , UAPIWrappers
   , WinSock
   , UForm_Sistemas
   , Masks
   , DBCtrls
   , DBGrids;

var
  ShowNotificationMessage: Boolean;

{$R *.dfm}

procedure TDataModule_Principal.ExcluirArquivosSelecionados;
const
  EXC_INSERT_HEADER =
  'INSERT INTO EXCLUSOES (BI_SISTEMAS_ID,VA_CAMINHOCOMPLETO)'#13#10 +
  '               VALUES '#13#10;

  EXC_INSERT_TEMPLATE =
	'(%u,''%s'')';

  ARQ_DELETE_HEADER =
  'DELETE FROM ARQUIVOS'#13#10 + 
  '      WHERE BI_ARQUIVOS_ID IN (<BI_ARQUIVOS_ID>)'#13#10;
var
  i: Word;
  SQL: String;
begin

  if Form_Principal.ZTODBGrid_Arquivos.SelectedRows.Count > 0 then
  begin
    SQL := '';
    for i := 0 to Pred(Form_Principal.ZTODBGrid_Arquivos.SelectedRows.Count) do
    begin
      ARQUIVOS.Bookmark := Form_Principal.ZTODBGrid_Arquivos.SelectedRows[i];

      if i > 0 then
        SQL := SQL + '            ';

      SQL := SQL + Format(EXC_INSERT_TEMPLATE,[ARQUIVOSBI_SISTEMAS_ID.AsInteger,ARQUIVOSVA_CAMINHOCOMPLETO.AsString]);


      if i < Pred(Form_Principal.ZTODBGrid_Arquivos.SelectedRows.Count) then
        SQL := SQL + ','#13#10;
    end;
//
//    	        ExecuteQuery(DataModuleMain.ZConnections[0].Connection,SQL);
//                GRUPOSDOSUSUARIOS.Refresh;
  end
  else
  begin

  end;
end;

{



const     
    GDU_INSERT_HEADER =
    'INSERT IGNORE INTO'#13#10 +
    '       X[GDU.GRUPOSDOSUSUARIOS]X (X[GDU.SM_USUARIOS_ID]X,X[GDU.TI_GRUPOS_ID]X)'#13#10 +
    'VALUES'#13#10;
    GDU_INSERT_TEMPLATE =
	'       (%u,%u)';
var
	SQL: String;
    i: Word;
	XXXForm_AvailableGroups: TXXXForm_AvailableGroups;
begin
	XXXForm_AvailableGroups := TXXXForm_AvailableGroups(aSender);

	if XXXForm_AvailableGroups.ModalResult = mrOk then
    begin
	    SQL := ReplaceSystemObjectNames(GDU_INSERT_HEADER);

        if XXXForm_AvailableGroups.CFDBGrid_GRU.SelectedRows.Count > 0 then
        begin
    	   	if XXXForm_AvailableGroups.CFDBGrid_GRU.SelectedRows.Count > High(Word) then
            	Application.MessageBox(PChar('A quantidade de grupos selecionados excede o limite permitido de ' + IntToStr(High(Word)) + #13#10'Por favor selecione menos grupos'),'Não é possível atribuir grupos',MB_ICONERROR)
            else
            begin
    	        for i := 0 to Pred(XXXForm_AvailableGroups.CFDBGrid_GRU.SelectedRows.Count) do
                begin
                    GRUPOS.Bookmark := XXXForm_AvailableGroups.CFDBGrid_GRU.SelectedRows[i];
                    SQL := SQL + Format(GDU_INSERT_TEMPLATE,[USUARIOS.FieldByName(Configurations.UserTableKeyFieldName).AsInteger,GRUPOS.FieldByName(Configurations.GroupTableKeyFieldName).AsInteger]);

                    if i < Pred(XXXForm_AvailableGroups.CFDBGrid_GRU.SelectedRows.Count) then
                        SQL := SQL + ','#13#10;
                end;

    	        ExecuteQuery(DataModuleMain.ZConnections[0].Connection,SQL);
                GRUPOSDOSUSUARIOS.Refresh;
            end;
        end;

    end;
end;





}

function TDataModule_Principal.IPToHostName(aIP: String): String;
var
  SockAddrIn: TSockAddrIn;
  HostEnt: PHostEnt;
  WSAData: TWSAData;
begin
  Result := '';
  WSAStartup($101, WSAData);

  try
    SockAddrIn.sin_addr.s_addr := inet_addr(PChar(aIP));

    HostEnt := gethostbyaddr(@SockAddrIn.sin_addr.S_addr, 4, AF_INET);

    if Assigned(HostEnt) then
      Result := StrPas(Hostent^.h_name);
  finally
    WSACleanup;
  end;
end;

function TDataModule_Principal.HostNameToIP(const HostName: string): string;
type
  TaPInAddr = array[0..10] of PInAddr;
  PaPInAddr = ^TaPInAddr;
var
  phe: PHostEnt;
  pptr: PaPInAddr;
  i: Integer;
  GInitData: TWSAData;
begin
  Result := '';
  WSAStartup($101, GInitData);

  try
    phe := GetHostByName(PChar(HostName));
    if not Assigned(phe) then
      Exit;

    pPtr := PaPInAddr(phe^.h_addr_list);

    i := 0;
    while pPtr^[i] <> nil do
    begin
      Result := inet_ntoa(pptr^[i]^);
      Inc(i);
    end;
  finally
    WSACleanup;
  end;
end;

procedure TDataModule_Principal.EXCLUSOESAfterInsert(DataSet: TDataSet);
begin
  EXCLUSOESBI_SISTEMAS_ID.AsInteger := SISTEMASBI_SISTEMAS_ID.AsInteger;
end;

procedure TDataModule_Principal.EXCLUSOESBeforeDelete(DataSet: TDataSet);
begin
  if Application.MessageBox('Remover um arquivo da lista de exclusão não vai recuperá-lo. Isso apenas vai permitir que este arquivo exista nos sistemas clientes. Pretende realmente realizar esta ação','Tem certeza?',MB_YESNO or MB_ICONQUESTION) = IDNO then
    Abort;
end;

procedure TDataModule_Principal.EXCLUSOESBeforeEdit(DataSet: TDataSet);
begin
  if (DataSet is TZQuery) and Assigned(TZQuery(DataSet).UpdateObject) then
    SetRefreshSQL(TZQuery(DataSet),dbaBeforeEdit);
end;

procedure TDataModule_Principal.EXCLUSOESBeforeInsert(DataSet: TDataSet);
begin
  if (DataSet is TZQuery) and Assigned(TZQuery(DataSet).UpdateObject) then
    SetRefreshSQL(TZQuery(DataSet),dbaBeforeInsert);
end;

procedure TDataModule_Principal.ExecuteQuery(const aDBConnection: TZConnection; const aSQLCommand: String);
var
	WODataSet: TZQuery;
  ComandoSQLLocal: String;
begin
	ComandoSQLLocal := Trim(UpperCase(aSQLCommand));
  WODataSet := nil;

  if Assigned(aDBConnection) then
    try
      WODataSet := TZQuery.Create(Self);
      if Assigned(WODataSet) then
        with WODataSet do
        begin
          Connection := aDBConnection;
          ReadOnly := False;
          SQL.Text := ComandoSQLLocal;
          ExecSQL;
        end;
    finally
      if Assigned(WODataSet) then
        WODataSet.Free;
    end;
end;

function TDataModule_Principal.UsuarioAutenticado(Usuario, Senha: ShortString; ClienteConectado: TConnectedClient): Boolean;
begin
  Result := False;
  with TZReadOnlyQuery.Create(nil) do
    try
      Connection := ZConnection_Principal;
      SQL.Text := Format(SQL_SELECT_ALL_USERS,[Usuario,Senha]);
      Open;

			if RecordCount = 1 then
      begin
        Result := True;
        ClienteConectado.UserName := Usuario;
        ClienteConectado.PassWord := Senha;
        ClienteConectado.ID := FieldByName('BI_USUARIOS_ID').AsInteger;
        ClienteConectado.RealName := FieldByName('VA_NOME').AsString;
        ClienteConectado.Email := FieldByName('VA_EMAIL').AsString;
      end;
    finally
    	Free;
    end;
end;

procedure TDataModule_Principal.AtivarFTP;
var
	WSI: TWSAData;
begin
  Form_Principal.Image_Green.Visible := False;
  Form_Principal.Image_Yellow.Visible := False;
  Form_Principal.Image_Red.Visible := True;
  Form_Principal.Update;

  WSI := WinsockInfo;

  if Self.Tag = 0 then
  begin
    ShowOnLog('Usando:',Form_Principal.RichEdit_LogFTP,500,'AutoSaveFTP.log');
    ShowOnLog('  ' + Trim(OverbyteIcsWSocket.CopyRight),Form_Principal.RichEdit_LogFTP,500,'AutoSaveFTP.log');
    ShowOnLog('  Informações sobre o Winsock...',Form_Principal.RichEdit_LogFTP,500,'AutoSaveFTP.log');
    ShowOnLog('    Versão .....: ' + Format('%d.%d', [WSI.wHighVersion shr 8,WSI.wHighVersion and 15]),Form_Principal.RichEdit_LogFTP,500,'AutoSaveFTP.log');
    ShowOnLog('    Descrição ..: ' + StrPas(@WSI.szDescription),Form_Principal.RichEdit_LogFTP,500,'AutoSaveFTP.log');
    ShowOnLog('    Status .....: ' + StrPas(@WSI.szSystemStatus),Form_Principal.RichEdit_LogFTP,500,'AutoSaveFTP.log');

    if Assigned(WSI.lpVendorInfo) then
      ShowOnLog('    ' + StrPas(@WSI.lpVendorInfo),Form_Principal.RichEdit_LogFTP,500,'AutoSaveFTP.log');

    Self.Tag := 1;
  end;

  FtpServer_Main.Port := '21';
  FtpServer_Main.Addr := '0.0.0.0';
  FtpServer_Main.ClientClass := TConnectedClient;
  FtpServer_Main.Start;
end;

function TDataModule_Principal.DesativarFTP: Boolean;
begin
    Result := False;
    if FtpServer_Main.ClientCount > 0 then
        Application.MessageBox('Ainda existem clientes conectados, não é possível desativar o servidor. Aguarde até que todos os clientes tenham se desconectado para poder desativar o servidor','Operação pendente detectada',MB_ICONWARNING)
    else
    begin
        FtpServer_Main.DisconnectAll;
        FtpServer_Main.Stop;
        Result := True;
    end;
end;

procedure TDataModule_Principal.Action_AtivarServidorExecute(Sender: TObject);
begin
	AtivarFTP;
  Action_DesativarServidor.Enabled := True;
  Action_AtivarServidor.Enabled := not Action_DesativarServidor.Enabled;

end;

procedure TDataModule_Principal.Action_DesativarServidorExecute(Sender: TObject);
begin
	DesativarFTP;
  Action_AtivarServidor.Enabled := True;
	Action_DesativarServidor.Enabled := not Action_AtivarServidor.Enabled;
end;

procedure TDataModule_Principal.Action_DiretorioDeMonitoramentoExecute(Sender: TObject);
var
  Selecao: String;
begin
  if SHBrowseForObject(Form_Principal
                      ,'Selecione uma pasta...'
                      ,'Por favor selecione uma pasta para ser monitorada pelo ' +
                       'MPS Updater. Todas as modificações em arquivos e diret' +
                       'órios contidos nesta pasta provocarão atualizações na ' +
                       'tabela de ARQUIVOS',Selecao) then
  begin
    SISTEMAS.Edit;

    SISTEMASVA_DIRETORIO.AsString := Selecao;
  end;
end;

procedure TDataModule_Principal.MinimizarNaBarraDeTarefas(aSender: TObject);
begin
  TrayIcon_Principal.Visible := True;
  TrayIcon_Principal.ShowBalloonHint;
  Form_Principal.Hide;
end;

procedure TDataModule_Principal.Action_MinimizeToTrayExecute(Sender: TObject);
begin
  MinimizarNaBarraDeTarefas(Sender);
end;

procedure TDataModule_Principal.Action_RestaurarAplicacaoExecute(Sender: TObject);
begin
  TrayIcon_Principal.Visible := False;

  Form_Principal.OnShow := nil;
  try
    Form_Principal.Show;
  finally
    Form_Principal.OnShow := Form_Principal.FormShow;
  end;
end;

procedure TDataModule_Principal.Action_SairExecute(Sender: TObject);
begin
  Form_Principal.Close;
end;

procedure TDataModule_Principal.Action_SDU_AdicionarExecute(Sender: TObject);
const
  SQL_INSERT = 'INSERT INTO MPSUPDATER.SISTEMASDOSUSUARIOS (BI_SISTEMAS_ID,BI_USUARIOS_ID)'#13#10 +
               '     VALUES <VALUES>';
  SQL_VALUES = '(<BI_SISTEMAS_ID>,<BI_USUARIOS_ID>)'#13#10;
var
  SqlInsert: String;
  i: Word;
begin
  with TForm_Sistemas.Create(Self) do
    try
      SqlInsert := '';
      { Se confirmou as operações }
      if ShowModal = mrOk then
      begin
        for i := 0 to Pred(ZTODBGrid_SIS.SelectedRows.Count) do
        begin
          SISTEMAS.Bookmark := ZTODBGrid_SIS.SelectedRows[i];

          if i > 0 then
            SqlInsert := SqlInsert + '          , ';

          SqlInsert := SqlInsert + SQL_VALUES;
          SqlInsert := StringReplace(SqlInsert,'<BI_SISTEMAS_ID>',SISTEMASBI_SISTEMAS_ID.AsString,[]);
          SqlInsert := StringReplace(SqlInsert,'<BI_USUARIOS_ID>',USUARIOSBI_USUARIOS_ID.AsString,[]);
        end;

        SqlInsert := StringReplace(SQL_INSERT,'<VALUES>',SqlInsert,[]);
        ExecuteQuery(ZConnection_Principal,SqlInsert);
        SISTEMASDOSUSUARIOS.Refresh;
      end;
    finally
      Free;
    end;
end;

procedure TDataModule_Principal.Action_SDU_RemoverExecute(Sender: TObject);
const
  SQL_DELETE = 'DELETE FROM MPSUPDATER.SISTEMASDOSUSUARIOS'#13#10 +
               '      WHERE (BI_SISTEMAS_ID,BI_USUARIOS_ID) IN (<VALUES>)';
  SQL_VALUES = '(<BI_SISTEMAS_ID>,<BI_USUARIOS_ID>)';
               
var
  SqlDelete: String;
  i: Word;
begin
  SqlDelete := '';

  for i := 0 to Pred(Form_Principal.ZTODBGrid_SistemasDosUsuarios.SelectedRows.Count) do
  begin
    SISTEMASDOSUSUARIOS.Bookmark := Form_Principal.ZTODBGrid_SistemasDosUsuarios.SelectedRows[i];

    if i > 0 then
      SqlDelete := SqlDelete + ',';

    SqlDelete := SqlDelete + SQL_VALUES;
    SqlDelete := StringReplace(SqlDelete,'<BI_SISTEMAS_ID>',SISTEMASDOSUSUARIOSBI_SISTEMAS_ID.AsString,[]);
    SqlDelete := StringReplace(SqlDelete,'<BI_USUARIOS_ID>',SISTEMASDOSUSUARIOSBI_USUARIOS_ID.AsString,[]);
  end;

  SqlDelete := StringReplace(SQL_DELETE,'<VALUES>',SqlDelete,[]);
  ExecuteQuery(ZConnection_Principal,SqlDelete);

  Form_Principal.ZTODBGrid_SistemasDosUsuarios.SelectedRows.Clear;

  SISTEMASDOSUSUARIOS.Refresh;
end;

procedure TDataModule_Principal.Action_SobreExecute(Sender: TObject);
begin
  Application.MessageBox('Este software foi idealizado e implementado por Carlos Barreto Feitoza Filho (PE) no período de julho de 2009 a julho de 2010', 'Sobre o MPS Updater', MB_OK or MB_ICONINFORMATION);
end;

procedure TDataModule_Principal.ARQUIVOSAfterDelete(DataSet: TDataSet);
begin
  { Insere o registro na tabela de exclusão caso ele não exista }
//  if not EXCLUSOES.Locate('VA_CAMINHOCOMPLETO',FCaminhoExcluido,[loCaseInsensitive]) then
//  begin
//    EXCLUSOES.Insert;
//    EXCLUSOESBI_SISTEMAS_ID.AsInteger    := FSistema;
//    EXCLUSOESVA_CAMINHOCOMPLETO.AsString := FCaminhoExcluido;
//    EXCLUSOES.Post;
//  end;
//
//  { Exclui fisicamente o arquivo }
//  DeleteFile(SISTEMASVA_DIRETORIO.AsString + '\' + FCaminhoExcluido);
//  FCaminhoExcluido := '';
//  FSistema := 0;
end;

procedure TDataModule_Principal.ARQUIVOSBeforeDelete(DataSet: TDataSet);
begin
  if Application.MessageBox('Esta operação vai excluir fisicamente o arquivo selecionado e colocá-lo na lista de exclusão permanente, garantindo que o mesmo não exista nos sistemas clientes. Esta operação não poderá ser desfeita. Tem certeza?','Tem certeza?',MB_YESNO or MB_ICONQUESTION) = IDYES then
  begin
    ExcluirArquivosSelecionados;

//    FCaminhoExcluido := ARQUIVOSVA_CAMINHOCOMPLETO.AsString;
//    FSistema         := SISTEMASBI_SISTEMAS_ID.AsInteger;
  end;
  
  Abort;
end;

procedure TDataModule_Principal.CFDBValidationChecks_SISCustomValidate(const aSender: TObject;
                                                                       const aValidateAction: TValidateAction;
                                                                       const aValidateMoment: TValidateMoment);
var
  Field: TField;
begin
  if (aValidateAction = vaBeforePost) and (aValidateMoment = vmBegin) then
  begin
    Field := CFDBValidationChecks_SIS.CheckableFields.ByFieldName['VA_DIRETORIO'].Field;
    if not DirectoryExists(Field.AsString) then
      raise EInvalidFieldValue.Create(Field,'O diretório especificado é inválido. Por favor selecione outro diretório.');
  end;
end;

procedure TDataModule_Principal.ConfigureEnvironment;
begin
  Application.OnException := HandleException;

  // Verifica se o banco de dados existe e se todas as tabela existem
  ShowOnLog('Verificando integridade do banco de dados...',Form_Principal.RichEdit_LogMonitoramento,100,'AutoSaveMon.log');
  Form_Principal.RichEdit_LogMonitoramento.Lines[Pred(Form_Principal.RichEdit_LogMonitoramento.Lines.Count)] := Form_Principal.RichEdit_LogMonitoramento.Lines[Pred(Form_Principal.RichEdit_LogMonitoramento.Lines.Count)] + ' Concluído!';

  ShowOnLog('Conectando-se ao banco de dados...',Form_Principal.RichEdit_LogMonitoramento,100,'AutoSaveMon.log');

  ZConnection_Principal.Connect; // o restante está sendo feito no after connect

  ShowOnLog('Aplicação pronta para utilização!',Form_Principal.RichEdit_LogMonitoramento,100,'AutoSaveMon.log');
  ShowOnLog('-------------------------------------------------------------------------------------',Form_Principal.RichEdit_LogMonitoramento,100,'AutoSaveMon.log');

  Form_Principal.TabSheet_Sistemas.TabVisible := True;
  Form_Principal.TabSheet_Arquivos.TabVisible := True;
  Form_Principal.TabSheet_Usuarios.TabVisible := True;
end;

procedure TDataModule_Principal.DataModuleCreate(Sender: TObject);
begin
  ConfigureEnvironment;
end;

procedure TDataModule_Principal.DataModuleDestroy(Sender: TObject);
begin
  FMonitoredSystems.Free;
end;

procedure TDataModule_Principal.DataSource_ARQDataChange(Sender: TObject; Field: TField);
begin
  Form_Principal.StatusBar_Arquivos.SimpleText := IntToStr(ARQUIVOS.RecordCount) + ' arquivos monitorados no sistema selecionado...';
end;

procedure TDataModule_Principal.DataSource_EXCDataChange(Sender: TObject; Field: TField);
begin
  Form_Principal.StatusBar_Exclusoes.SimpleText := IntToStr(EXCLUSOES.RecordCount) + ' arquivos excluídos no sistema selecionado...';
end;

procedure TDataModule_Principal.DataSource_SDUDataChange(Sender: TObject; Field: TField);
begin
  Action_SDU_Remover.Enabled := (SISTEMASDOSUSUARIOS.RecordCount > 0) and (Form_Principal.ZTODBGrid_SistemasDosUsuarios.SelectedRows.Count > 0);
end;

procedure TDataModule_Principal.FtpServer_MainAnswerToClient(Sender: TObject; Client: TFtpCtrlSocket; var Answer: TFtpString);
begin
	ShowOnLog(PutLineBreaks('RETORNO:> ' + Answer + ' ' + IPToHostName(Client.GetPeerAddr) + ' (' + Client.GetPeerAddr + ':' + Client.GetPeerPort + ')',85),Form_Principal.RichEdit_LogFTP,500,'AutoSaveFTP.log');
end;

procedure TDataModule_Principal.FtpServer_MainAuthenticate(Sender: TObject; Client: TFtpCtrlSocket; UserName, Password: TFtpString; var Authenticated: Boolean);
var
  StrTemp: ShortString;
  HoraAtual: Byte;
begin
  Authenticated := False;
  if UsuarioAutenticado(UserName,Password,TConnectedClient(Client)) then
  begin
    (Client as TConnectedClient).IP := Client.GetPeerAddr;
    Client.HomeDir := FTPPublic;

    HoraAtual := StrToInt(FormatDateTime('hh',Now));

    if HoraAtual < 12 then
      StrTemp := 'Bom dia'
    else if HoraAtual < 18 then
      StrTemp := 'Boa tarde'
    else
      StrTemp := 'Boa noite';

    Authenticated := True;
    ShowOnLog('§ O usuário "' + UserName + '@' + (Client as TConnectedClient).IP + '" foi autenticado',Form_Principal.RichEdit_LogFTP,500,'AutoSaveFTP.log');
    Client.SendAnswer(Format(_CLIENT_AUTHENTICATED,[StrTemp,(Client as TConnectedClient).RealName]));
  end;
end;

function TDataModule_Principal.IsSuperUser(aID: Cardinal): Boolean;
const
  SQL_SELECT = 'SELECT USU.BO_ADMINISTRADOR'#13#10 +
               '  FROM MPSUPDATER.USUARIOS USU'#13#10 +
               ' WHERE USU.BI_USUARIOS_ID = <BI_USUARIOS_ID>';
begin
  with TZReadOnlyQuery.Create(nil) do
    try
      Connection := ZConnection_Principal;
      SQL.Text := StringReplace(SQL_SELECT,'<BI_USUARIOS_ID>',IntToStr(aID),[]);
      Open;

      Result := (RecordCount = 1) and (Fields[0].AsInteger = 1);
    finally
      Free;
    end;
end;

procedure TDataModule_Principal.FtpServer_MainChangeDirectory(Sender: TObject; Client: TFtpCtrlSocket; Directory: TFtpString; var Allowed: Boolean);
begin
	{ Pode mudar para qualquer subdiretório dentro de um dos diretórios dos
  sistemas de cada usuário ou dentro do diretório público }
	Allowed := (Pos(FTPPublic, Directory) = 1) or IsAllowedDir(Directory,TConnectedClient(Client).ID);
end;

procedure TDataModule_Principal.FtpServer_MainClientCommand(Sender: TObject; Client: TFtpCtrlSocket; var Keyword, Params, Answer: TFtpString);
var
  Parametros: ShortString;
begin
  Parametros := Params;
  if UpperCase(Keyword) = 'PASS' then
    Parametros := '<SENHA OCULTADA>';

	ShowOnLog('COMANDO:> ' + Keyword + ' ' + Parametros + ' ' + IPToHostName(Client.GetPeerAddr) + ' (' + Client.GetPeerAddr + ':' + Client.GetPeerPort + ')',Form_Principal.RichEdit_LogFTP,500,'AutoSaveFTP.log');
end;

procedure TDataModule_Principal.UpdateClientCount;
begin
  Form_Principal.Image_Red.Visible   := True;
  Form_Principal.Image_Yellow.Visible := False;
  Form_Principal.Image_Green.Visible := False;
  if FtpServer_Main.Active then
  begin
    if FtpServer_Main.ClientCount = 0 then
    begin
      Form_Principal.Label_ClientCount.Caption := 'Nenhum usuário no momento';
      Form_Principal.Image_Red.Visible := False;
      Form_Principal.Image_Yellow.Visible := False;
      Form_Principal.Image_Green.Visible := True;
    end
    else
    begin
      Form_Principal.Label_ClientCount.Caption := IntToStr(FtpServer_Main.ClientCount) + '/' + IntToStr(FtpServer_Main.MaxClients) + ' usuário(s) conectado(s)';
      if FtpServer_Main.ClientCount = FtpServer_Main.MaxClients then
      begin
        Form_Principal.Image_Red.Visible := True;
        Form_Principal.Image_Yellow.Visible := False;
        Form_Principal.Image_Green.Visible := False;
      end
      else if FtpServer_Main.ClientCount >= (FtpServer_Main.MaxClients * 0.75) then
      begin
        Form_Principal.Image_Red.Visible := False;
        Form_Principal.Image_Yellow.Visible := True;
        Form_Principal.Image_Green.Visible := False;
      end
      else
      begin
        Form_Principal.Image_Red.Visible   := False;
        Form_Principal.Image_Yellow.Visible := False;
        Form_Principal.Image_Green.Visible := True;
      end;
    end
  end
  else
    Form_Principal.Label_ClientCount.Caption := 'O MPS Updater econtra-se desativado e não pode responder a requisições';

    Application.ProcessMessages;
end;

procedure TDataModule_Principal.USUARIOSBeforeEdit(DataSet: TDataSet);
begin
  if (DataSet is TZQuery) and Assigned(TZQuery(DataSet).UpdateObject) then
    SetRefreshSQL(TZQuery(DataSet),dbaBeforeEdit);
end;

procedure TDataModule_Principal.USUARIOSBeforeInsert(DataSet: TDataSet);
begin
  if (DataSet is TZQuery) and Assigned(TZQuery(DataSet).UpdateObject) then
    SetRefreshSQL(TZQuery(DataSet),dbaBeforeInsert);
end;

procedure TDataModule_Principal.USUARIOSVA_SENHAGetText(Sender: TField; var Text: string; DisplayText: Boolean);
begin
  Text := '<senha oculta mané>';
end;

procedure TDataModule_Principal.USUARIOSVA_SENHASetText(Sender: TField; const Text: string);
begin
  if Text <> '<senha oculta mané>' then
    Sender.AsString := Text;
end;

function TDataModule_Principal.IsAllowedIp(aIP: ShortString): Boolean;
begin
  Result := True;
  { Usar aqui uma tabela de IPs autorizados }
//  if aIP = '193.121.12.25' then
//  begin
//
//  end;
end;

procedure TDataModule_Principal.FtpServer_MainClientConnect(Sender: TObject; Client: TFtpCtrlSocket; AError: Word);
begin
	{ O cliente iniciou o processo de conexão. Aqui  podem ser feitas verificações
  que limitam o acesso. Tente usar uma mascara e compare com o IP }
  if not IsAllowedIp(Client.GetPeerAddr) then
  begin
 	  Client.SendAnswer('421 - Conexão recusada. Você está acessando a partir de um local não autorizado');
    Client.Close;
  end
  else
  begin
    ShowOnLog('§ Cliente ' + IPToHostName(Client.GetPeerAddr) + ' (' + Client.GetPeerAddr + ':' + Client.GetPeerPort + ') conectado',Form_Principal.RichEdit_LogFTP,500,'AutoSaveFTP.log');

//    UpdateClientCount;

    Client.HomeDir := '';
    Client.Directory := FTPPublic;
  end;
end;

procedure TDataModule_Principal.FtpServer_MainClientDisconnect(Sender: TObject; Client: TFtpCtrlSocket; AError: Word);
begin
  ShowOnLog('§ Cliente ' + IPToHostName(Client.GetPeerAddr) + ' (' + Client.GetPeerAddr + ':' + Client.GetPeerPort + ') desconectado',Form_Principal.RichEdit_LogFTP,500,'AutoSaveFTP.log');
//  UpdateClientCount;
end;

procedure TDataModule_Principal.FtpServer_MainMakeDirectory(Sender: TObject; Client: TFtpCtrlSocket; Directory: TFtpString; var Allowed: Boolean);
begin
	{ Para usuários normais nunca poderá criar diretórios. Para superusuários
  poderá criar criar qualquer diretório dentro de um de seus diretórios
  autorizados ou do diretório público  }
  Allowed := IsSuperUser(TConnectedClient(Client).ID) and ((Pos(FTPPublic, Directory) = 1) or IsAllowedDir(Directory,TConnectedClient(Client).ID));
end;

procedure TDataModule_Principal.FtpServer_MainRetrDataSent(Sender: TObject; Client: TFtpCtrlSocket; Data: TWSocket; AError: Word);
begin
  if AError <> 0 then
    ShowOnLog('! ' + IPToHostName(Client.GetPeerAddr) + ' (' + Client.GetPeerAddr + ':' + Client.GetPeerPort + ') Dados não enviados. Erro #' + IntToStr(AError),Form_Principal.RichEdit_LogFTP,500,'AutoSaveFTP.log');
  { TODO : No futuro coloque uma barra de progresso multipropósito. Aqui ela
  cresce de acordo com a quantidade de dados enviados ao cliente. }
end;

procedure TDataModule_Principal.FtpServer_MainRetrSessionClosed(Sender: TObject; Client: TFtpCtrlSocket; Data: TWSocket; AError: Word);
begin
  if AError <> 0 then
    ShowOnLog('! ' + IPToHostName(Client.GetPeerAddr) + ' (' + Client.GetPeerAddr + ':' + Client.GetPeerPort + ') Sessão de dados finalizada. Erro #' + IntToStr(AError),Form_Principal.RichEdit_LogFTP,500,'AutoSaveFTP.log')
  else
    ShowOnLog('§ ' + IPToHostName(Client.GetPeerAddr) + ' (' + Client.GetPeerAddr + ':' + Client.GetPeerPort + ') Sessão de dados finalizada sem erros!',Form_Principal.RichEdit_LogFTP,500,'AutoSaveFTP.log');

  if AError = 0 then
    if Client.UserData = 1 then
    begin
      { We created a stream for a virtual file or dir. Delete the TStream }
      if Assigned(Client.DataStream) then
      begin
        { There is no reason why we should not come here, but who knows ? }
        Client.DataStream.Destroy;
        Client.DataStream := nil;
      end;
      Client.UserData := 0; { Reset the flag }
    end;
end;


procedure TDataModule_Principal.ProcessRequest(aClient: TConnectedClient);
{ ---------------------------------------------------------------------------- }
function CreateSendStream(aClient: TFtpCtrlSocket; const aBuffer): Cardinal;
begin
  aClient.UserData := 1;
  if Assigned(aClient.DataStream) then
    aClient.DataStream.Destroy;

  Result := Length(PChar(@aBuffer));

  aClient.DataStream := TMemoryStream.Create;
  aClient.DataStream.Write(aBuffer,Result);
  aClient.DataStream.Seek(0,0);
end;

function GetParameter(aCommand: ShortString; aParamIndex: Byte): TMultiTypedResult;
var
  Bop,Eop: Byte;
	FS: TFormatSettings;
begin
  FS := GetUSFormatSettings;

  Bop := Succ(Pos('{',aCommand));
  Eop := Pred(Pos('}',aCommand));

  with TStringList.Create do
  try
    Text := StringReplace(Copy(aCommand,Bop, Eop - Bop + 1),',',#13#10,[rfReplaceAll]);
    if aParamIndex < Count then
    begin
      { TODO -oCarlos Feitoza -cCONSERTE : Melhore isso! Não está correto }
      with Result do
      begin
        AsByte        := Byte(StrToIntDef(Strings[aParamIndex],0));
        AsWord        := Word(StrToIntDef(Strings[aParamIndex],0));
        AsDWord       := StrToIntDef(Strings[aParamIndex],0);
        AsShortInt    := ShortInt(StrToIntDef(Strings[aParamIndex],0));
        AsSmallInt    := SmallInt(StrToIntDef(Strings[aParamIndex],0));
        AsInteger     := StrToIntDef(Strings[aParamIndex],0);
        AsInt64       := StrToInt64Def(Strings[aParamIndex],0);

        AsChar        := Strings[aParamIndex][1];
        AsString      := Strings[aParamIndex];

        AsSingle      := StrToFloatDef(Strings[aParamIndex],0,FS);
        AsDouble      := StrToFloatDef(Strings[aParamIndex],0,FS);
        AsCurrency    := StrToCurrDef(Strings[aParamIndex],0,FS);

        AsDateTime    := StrToFloatDef(Strings[aParamIndex],0,FS);
      end;
    end;
  finally
    Free;
  end;
end;

function ExcludedFilesList(aSistema, aFormatoDoArquivo: ShortString): String;
//const
//  SQL_SELECT = 'SELECT ARQ.DT_DATAEHORA'#13#10 +
//               '     , ARQ.VA_CAMINHOCOMPLETO'#13#10 +
//               '     , SIS.VA_DIRETORIO'#13#10 +
//               '     , SIS.VA_CHAVEDEINSTALACAO'#13#10 +
//               '  FROM MPSUPDATER.ARQUIVOS ARQ'#13#10 +
//               '  JOIN MPSUPDATER.SISTEMAS SIS USING(BI_SISTEMAS_ID)'#13#10 +
//               ' WHERE SIS.VA_NOME = <VA_NOME>';
//var
//  MonitoredFiles: TMonitoredFiles;
begin
//  Result := '';
//  MonitoredFiles := nil;
//
//  with TZReadOnlyQuery.Create(Self) do
//    try
//      MonitoredFiles := TMonitoredFiles.Create(Self);
//
//      Connection := ZConnection_Principal;
//      SQL.Text := StringReplace(SQL_SELECT,'<VA_NOME>',QuotedStr(aSistema),[rfReplaceAll]);
//      Open;
//
//      if not Eof then
//      begin
//        MonitoredFiles.Directory := FieldByName('VA_DIRETORIO').AsString;
//        MonitoredFiles.ChaveDeInstalacao := FieldByName('VA_CHAVEDEINSTALACAO').AsString;
//      end;
//
//      while not Eof do
//      begin
//        with MonitoredFiles.Files.Add do
//        begin
//          LastModified := FieldByName('DT_DATAEHORA').AsDateTime;
//          FilePath := FieldByName('VA_CAMINHOCOMPLETO').AsString;
//        end;
//        Next;
//      end;
//
//      if aFormatoDoArquivo = 'XML' then
//        Result := Trim(MonitoredFiles.ToXML)
//      else
//        Result := Trim(MonitoredFiles.ToString);
//
//    finally
//      MonitoredFiles.Free;
//      Free;
//    end;
end;

function MonitoredFilesList(aSistema, aFormatoDoArquivo: ShortString): String;
const
  SQL_SELECT = 'SELECT ARQ.DT_DATAEHORA'#13#10 +
               '     , ARQ.VA_CAMINHOCOMPLETO'#13#10 +
               '     , SIS.VA_DIRETORIO'#13#10 +
               '     , SIS.VA_CHAVEDEINSTALACAO'#13#10 +
               '  FROM MPSUPDATER.ARQUIVOS ARQ'#13#10 +
               '  JOIN MPSUPDATER.SISTEMAS SIS USING(BI_SISTEMAS_ID)'#13#10 +
               ' WHERE SIS.VA_NOME = <VA_NOME>';
var
  MonitoredFiles: TMonitoredFiles;
begin
  Result := '';
  MonitoredFiles := nil;

  with TZReadOnlyQuery.Create(Self) do
    try
      MonitoredFiles := TMonitoredFiles.Create(Self,'');

      Connection := ZConnection_Principal;
      SQL.Text := StringReplace(SQL_SELECT,'<VA_NOME>',QuotedStr(aSistema),[rfReplaceAll]);
      Open;

      if not Eof then
      begin
        MonitoredFiles.Directory := FieldByName('VA_DIRETORIO').AsString;
        MonitoredFiles.InstallationKey := FieldByName('VA_CHAVEDEINSTALACAO').AsString;
      end;

      while not Eof do
      begin
        with MonitoredFiles.Files.Add do
        begin
          LastModified := FieldByName('DT_DATAEHORA').AsDateTime;
          FilePath := FieldByName('VA_CAMINHOCOMPLETO').AsString;
        end;
        Next;
      end;

      if aFormatoDoArquivo = 'XML' then
        Result := Trim(MonitoredFiles.ToXML)
      else
        Result := Trim(MonitoredFiles.ToString);

    finally
      MonitoredFiles.Free;
      Free;
    end;
end;

{ ---------------------------------------------------------------------------- }
var
  Arquivo: String;
begin
  Arquivo := UpperCase(ExtractFileName(aClient.FilePath));

  // MONITOREDFILESLIST{<sistema>,<formato>}.CMD
  // Este comando gera um arquivo contendo os nomes e caminhos dos arquivos
  // monitorados no sistema <sistema>. O formato do arquivo gerado é definido no
  // parâmetro <formato> que pode assumir XML ou OBJ
  { -------------------------------------------------------------------------- }
  if MatchesMask(Arquivo,CMD_MONITOREDFILESLIST) then
  begin
    ShowOnLog('@ Executando comando ' + Arquivo,Form_Principal.RichEdit_LogFTP,500,'AutoSaveFTP.log');

    { Gerando o arquivo }
    SendStatus(aClient,'== MONITOREDFILESLIST: Iniciando geração de conteúdo... =======================');
    SendStatus(aClient,'-------------------------------------------------------------------------------');
    SendStatus(aClient,'UM ARQUIVO ESTÁ SENDO GERADO COM AS CONFIGURAÇÕES A SEGUIR');
    SendStatus(aClient,'');
    SendStatus(aClient,'SISTEMA............: ' + GetParameter(Arquivo,0).AsString);
    SendStatus(aClient,'FORMATO DE GERAÇÃO.: ' + GetParameter(Arquivo,1).AsString);
    SendStatus(aClient,'-------------------------------------------------------------------------------');

    Arquivo := MonitoredFilesList(GetParameter(Arquivo,0).AsString
                                 ,GetParameter(Arquivo,1).AsString);

    SendStatus(aClient,'DFS: ' + IntToStr(CreateSendStream(aClient,Arquivo[1])));
    SendStatus(aClient,'-------------------------------------------------------------------------------');
    SendStatus(aClient,'== MONITOREDFILESLIST: Conteúdo gerado com sucesso ============================');
  end;
  // EXCLUDEDFILESLIST{<sistema>,<formato>}.CMD
  // Este comando gera um arquivo contendo os nomes e caminhos dos arquivos
  // marcados para exclusão no sistema <sistema>. O formato do arquivo gerado é
  // definido no parâmetro <formato> que pode assumir XML ou OBJ
  { -------------------------------------------------------------------------- }
  if MatchesMask(Arquivo,CMD_EXCLUDEDFILESLIST) then
  begin
    ShowOnLog('@ Executando comando ' + Arquivo,Form_Principal.RichEdit_LogFTP,500,'AutoSaveFTP.log');

    { Gerando o arquivo }
    SendStatus(aClient,'== EXCLUDEDFILESLIST: Iniciando geração de conteúdo... ========================');
    SendStatus(aClient,'-------------------------------------------------------------------------------');
    SendStatus(aClient,'UM ARQUIVO ESTÁ SENDO GERADO COM AS CONFIGURAÇÕES A SEGUIR');
    SendStatus(aClient,'');
    SendStatus(aClient,'SISTEMA............: ' + GetParameter(Arquivo,0).AsString);
    SendStatus(aClient,'FORMATO DE GERAÇÃO.: ' + GetParameter(Arquivo,1).AsString);
    SendStatus(aClient,'-------------------------------------------------------------------------------');

    Arquivo := ExcludedFilesList(GetParameter(Arquivo,0).AsString
                                ,GetParameter(Arquivo,1).AsString);

    SendStatus(aClient,'DFS: ' + IntToStr(CreateSendStream(aClient,Arquivo[1])));
    SendStatus(aClient,'-------------------------------------------------------------------------------');
    SendStatus(aClient,'== EXCLUDEDFILESLIST: Conteúdo gerado com sucesso =============================');
  end;
end;

procedure TDataModule_Principal.FtpServer_MainGetProcessing(Sender: TObject; Client: TFtpCtrlSocket; var DelayedSend: Boolean);
begin
  ProcessRequest(TConnectedClient(Client));
end;

procedure TDataModule_Principal.FtpServer_MainRetrSessionConnected(Sender: TObject; Client: TFtpCtrlSocket; Data: TWSocket; AError: Word);
begin
  if AError <> 0 then
    ShowOnLog('! ' + IPToHostName(Client.GetPeerAddr) + ' (' + Client.GetPeerAddr + ':' + Client.GetPeerPort + ') Sessão de dados iniciada. Erro #' + IntToStr(AError),Form_Principal.RichEdit_LogFTP,500,'AutoSaveFTP.log')
  else
    ShowOnLog('§ ' + IPToHostName(Client.GetPeerAddr) + ' (' + Client.GetPeerAddr + ':' + Client.GetPeerPort + ') Sessão de dados iniciada sem erros!',Form_Principal.RichEdit_LogFTP,500,'AutoSaveFTP.log');
end;

procedure TDataModule_Principal.FtpServer_MainStart(Sender: TObject);
begin
  ShowOnLog('§ Servidor ativado na porta ' + FtpServer_Main.Port,Form_Principal.RichEdit_LogFTP,500,'AutoSaveFTP.log');
  ShowOnLog('-------------------------------------------------------------------------------------',Form_Principal.RichEdit_LogFTP,500,'AutoSaveFTP.log');
//  UpdateClientCount;
end;

procedure TDataModule_Principal.FtpServer_MainStop(Sender: TObject);
begin
  ShowOnLog('§ Servidor desativado',Form_Principal.RichEdit_LogFTP,500,'AutoSaveFTP.log');
  ShowOnLog('-------------------------------------------------------------------------------------',Form_Principal.RichEdit_LogFTP,500,'AutoSaveFTP.log');
//  UpdateClientCount;
end;

procedure TDataModule_Principal.FtpServer_MainStorSessionClosed(Sender: TObject; Client: TFtpCtrlSocket; Data: TWSocket; AError: Word);
begin
  if AError <> 0 then
	  ShowOnLog('! ' + IPToHostName(Client.GetPeerAddr) + ' (' + Client.GetPeerAddr + ':' + Client.GetPeerPort + ') Sessão de dados finalizada de forma incorreta. Erro #' + IntToStr(AError),Form_Principal.RichEdit_LogFTP,500,'AutoSaveFTP.log')
  else
    ShowOnLog('§ ' + IPToHostName(Client.GetPeerAddr) + ' (' + Client.GetPeerAddr + ':' + Client.GetPeerPort + ') Sessão de dados finalizada sem erros!',Form_Principal.RichEdit_LogFTP,500,'AutoSaveFTP.log');
end;

procedure TDataModule_Principal.FtpServer_MainStorSessionConnected(Sender: TObject; Client: TFtpCtrlSocket; Data: TWSocket; AError: Word);
begin
  if AError <> 0 then
    ShowOnLog('! ' + IPToHostName(Client.GetPeerAddr) + ' (' + Client.GetPeerAddr + ':' + Client.GetPeerPort + ') Não foi possível iniciar a sessão de dados. Erro #' + IntToStr(AError),Form_Principal.RichEdit_LogFTP,500,'AutoSaveFTP.log')
  else
    ShowOnLog('§ ' + IPToHostName(Client.GetPeerAddr) + ' (' + Client.GetPeerAddr + ':' + Client.GetPeerPort + ') A sessão de dados foi iniciada sem erros!',Form_Principal.RichEdit_LogFTP,500,'AutoSaveFTP.log');
end;

procedure TDataModule_Principal.FtpServer_MainValidateDele(Sender: TObject; Client: TFtpCtrlSocket; var FilePath: TFtpString; var Allowed: Boolean);
begin
	{ Pode apagar qualquer coisa abaixo de home directory }
//	Allowed := Pos(Client.HomeDir,FilePath) = 1;
  Allowed := False;
end;

procedure TDataModule_Principal.FtpServer_MainValidateGet(Sender: TObject; Client: TFtpCtrlSocket; var FilePath: TFtpString; var Allowed: Boolean);
begin
	{ Pode pegar qualquer coisa dentro do diretório público ou dentro de um dos diretórios permitidos }
	Allowed := (Pos(FTPPublic, FilePath) = 1) or IsAllowedDir(FilePath,TConnectedClient(Client).ID);
end;

procedure TDataModule_Principal.FtpServer_MainValidatePut(Sender: TObject; Client: TFtpCtrlSocket; var FilePath: TFtpString; var Allowed: Boolean);
begin
	{ Pode colocar qualquer coisa abaixo de home directory }
//	Allowed := Pos(Client.HomeDir,FilePath) = 1;
  Allowed := False;
end;

procedure TDataModule_Principal.FtpServer_MainValidateRmd(Sender: TObject; Client: TFtpCtrlSocket; var FilePath: TFtpString; var Allowed: Boolean);
begin
	{ Pode apagar qualquer diretório abaixo de Home directory }
//	Allowed := Pos(Client.HomeDir,FilePath) = 1;
  Allowed := False;
end;

procedure TDataModule_Principal.FtpServer_MainValidateRnFr(Sender: TObject; Client: TFtpCtrlSocket; var FilePath: TFtpString; var Allowed: Boolean);
begin
	{ Pode renomear qualquer arquivo abaixo de Home directory }
	//Allowed := Pos(Client.HomeDir,FilePath) = 1;
  Allowed := False;
end;

procedure TDataModule_Principal.FtpServer_MainValidateRnTo(Sender: TObject; Client: TFtpCtrlSocket; var FilePath: TFtpString; var Allowed: Boolean);
begin
	{ Pode renomear para qualquer nome qualquer arquivo abaixo de Home directory }
//	Allowed := Pos(Client.HomeDir,FilePath) = 1;
  Allowed := False;
end;

procedure TDataModule_Principal.FtpServer_MainValidateSize(Sender: TObject; Client: TFtpCtrlSocket; var FilePath: TFtpString; var Allowed: Boolean);
begin
	{ Pode obter o tamanho de qualquer arquivo dentro do diretório público ou dentro de um dos diretórios permitidos }
//	Allowed := Pos(Client.HomeDir,FilePath) = 1;
	Allowed := (Pos(FTPPublic, FilePath) = 1) or IsAllowedDir(FilePath,TConnectedClient(Client).ID);
end;

procedure TDataModule_Principal.HandleException(Sender: TObject; E: Exception);
begin
	{ TODO : Ainda não faz nada... mas fará! }
    { Se for um erro de validação, lançado por um componente de validação, exibe
    o erro adequadamente de acordo com as opções da aplicação }
	if E is EInvalidFieldValue then
  begin
    Form_Principal.BalloonToolTip_Principal.TipText := E.Message;
    ShowBalloonToolTipValidationFor(Form_Principal,EInvalidFieldValue(E).FieldError.DataSet,EInvalidFieldValue(E).FieldError)
  end
  else
  	Application.ShowException(E);
end;

function TDataModule_Principal.IsAllowedDir(aDir: ShortString; aUserID: Cardinal): Boolean;
const
  SQL_SELECT = 'SELECT SDU.BI_USUARIOS_ID'#13#10 +
               '     , UPPER(USU.VA_LOGIN)'#13#10 +
               '     , UPPER(SIS.VA_DIRETORIO)'#13#10 +
               '  FROM MPSUPDATER.SISTEMASDOSUSUARIOS SDU'#13#10 +
               '  JOIN MPSUPDATER.SISTEMAS SIS USING (BI_SISTEMAS_ID)'#13#10 +
               '  JOIN MPSUPDATER.USUARIOS USU USING (BI_USUARIOS_ID)'#13#10 +
               ' WHERE SDU.BI_USUARIOS_ID = <BI_USUARIOS_ID>'#13#10 +
               '   AND LOCATE(UPPER(SIS.VA_DIRETORIO),UPPER(<VA_DIRETORIO>)) = 1';
begin
  with TZReadOnlyQuery.Create(nil) do
    try
      if aDir[Length(aDir)] = '\' then
        System.Delete(aDir,Length(aDir),1);

      Connection := ZConnection_Principal;
      SQL.Text := StringReplace(SQL_SELECT,'<BI_USUARIOS_ID>',IntToStr(aUserID),[]);
      SQL.Text := StringReplace(SQL.Text,'<VA_DIRETORIO>',QuotedStr(StringReplace(aDir,'\','\\',[rfReplaceAll])),[]);

      SQL.SaveTofile('d:\carlos.txt');

      Open;

      Result := not Eof;
    finally
      Free;
    end;
end;

function TDataModule_Principal.IsValidDataWareComponent(aComponent: TComponent; out aDataSet: TDataSet; out aDataField: TField): Boolean;
begin
	aDataSet := nil;
	aDataField := nil;
	Result := False;

	if aComponent is TDBEdit then
	begin
		Result := Assigned(TDBEdit(aComponent).DataSource)
                  and Assigned(TDBEdit(aComponent).DataSource.DataSet)
                  and Assigned(TDBEdit(aComponent).Field);

		if Result then
		begin
			aDataSet := TDBEdit(aComponent).DataSource.DataSet;
			aDataField := TDBEdit(aComponent).Field;
		end;
	end
	else if aComponent is TDBMemo then
	begin
		Result := Assigned(TDBMemo(aComponent).DataSource)
                  and Assigned(TDBMemo(aComponent).DataSource.DataSet)
                  and Assigned(TDBMemo(aComponent).Field);

		if Result then
		begin
			aDataSet := TDBMemo(aComponent).DataSource.DataSet;
			aDataField := TDBMemo(aComponent).Field;
		end;
	end
	else if aComponent is TDBImage then
	begin
		Result := Assigned(TDBImage(aComponent).DataSource)
                  and Assigned(TDBImage(aComponent).DataSource.DataSet)
                  and Assigned(TDBImage(aComponent).Field);

		if Result then
		begin
			aDataSet := TDBImage(aComponent).DataSource.DataSet;
			aDataField := TDBImage(aComponent).Field;
		end;
	end
	else if aComponent is TDBListBox then
	begin
		Result := Assigned(TDBListBox(aComponent).DataSource)
                  and Assigned(TDBListBox(aComponent).DataSource.DataSet)
                  and Assigned(TDBListBox(aComponent).Field);

		if Result then
		begin
			aDataSet := TDBListBox(aComponent).DataSource.DataSet;
			aDataField := TDBListBox(aComponent).Field;
		end;
	end
	else if aComponent is TDBComboBox then
	begin
		Result := Assigned(TDBComboBox(aComponent).DataSource)
                  and Assigned(TDBComboBox(aComponent).DataSource.DataSet)
                  and Assigned(TDBComboBox(aComponent).Field);

		if Result then
		begin
			aDataSet := TDBComboBox(aComponent).DataSource.DataSet;
			aDataField := TDBComboBox(aComponent).Field;
		end;
	end
	else if aComponent is TDBCheckBox then
	begin
		Result := Assigned(TDBCheckBox(aComponent).DataSource)
                  and Assigned(TDBCheckBox(aComponent).DataSource.DataSet)
                  and Assigned(TDBCheckBox(aComponent).Field);

		if Result then
		begin
			aDataSet := TDBCheckBox(aComponent).DataSource.DataSet;
			aDataField := TDBCheckBox(aComponent).Field;
		end;
	end
	else if aComponent is TDBRadioGroup then
	begin
		Result := Assigned(TDBRadioGroup(aComponent).DataSource)
                  and Assigned(TDBRadioGroup(aComponent).DataSource.DataSet)
                  and Assigned(TDBRadioGroup(aComponent).Field);

		if Result then
		begin
			aDataSet := TDBRadioGroup(aComponent).DataSource.DataSet;
			aDataField := TDBRadioGroup(aComponent).Field;
		end;
	end
	else if aComponent is TDBLookupListBox then
	begin
		Result := Assigned(TDBLookupListBox(aComponent).DataSource)
                  and Assigned(TDBLookupListBox(aComponent).DataSource.DataSet)
                  and Assigned(TDBLookupListBox(aComponent).Field);

		if Result then
		begin
			aDataSet := TDBLookupListBox(aComponent).DataSource.DataSet;
			aDataField := TDBLookupListBox(aComponent).Field;
		end;
	end
	else if aComponent is TDBLookupComboBox then
	begin
		Result := Assigned(TDBLookupComboBox(aComponent).DataSource)
                  and Assigned(TDBLookupComboBox(aComponent).DataSource.DataSet)
                  and Assigned(TDBLookupComboBox(aComponent).Field);

		if Result then
		begin
			aDataSet := TDBLookupComboBox(aComponent).DataSource.DataSet;
			aDataField := TDBLookupComboBox(aComponent).Field;
		end;
	end
	else if aComponent is TDBRichEdit then
	begin
		Result := Assigned(TDBRichEdit(aComponent).DataSource)
                  and Assigned(TDBRichEdit(aComponent).DataSource.DataSet)
                  and Assigned(TDBRichEdit(aComponent).Field);

		if Result then
		begin
			aDataSet := TDBRichEdit(aComponent).DataSource.DataSet;
			aDataField := TDBRichEdit(aComponent).Field;
    	end;
	end
	else if aComponent is TDBGrid then
	begin
		Result := Assigned(TDBGrid(aComponent).DataSource)
                  and Assigned(TDBGrid(aComponent).DataSource.DataSet);
		if Result then
			aDataSet := TDBGrid(aComponent).DataSource.DataSet;
	end;
end;

procedure TDataModule_Principal.SetRefreshSQL(const aZQuery: TZQuery;
                                              const aDBAction: TDBAction);
var
  RefreshSQL: string;
begin
  if aZQuery = SISTEMAS then
    case aDBAction of
      dbaBeforeInsert: RefreshSQL :=
      'SELECT BI_SISTEMAS_ID'#13#10 +
      '  FROM MPSUPDATER.SISTEMAS'#13#10 +
      ' WHERE BI_SISTEMAS_ID = LAST_INSERT_ID()';
      dbaBeforeEdit: RefreshSQL :=
      'SELECT BI_SISTEMAS_ID'#13#10 +
      '  FROM MPSUPDATER.SISTEMAS'#13#10 +
      ' WHERE BI_SISTEMAS_ID = :OLD_BI_SISTEMAS_ID';
    end
  else if aZQuery = USUARIOS then
    case aDBAction of
      dbaBeforeInsert: RefreshSQL :=
      'SELECT BI_USUARIOS_ID'#13#10 +
      '  FROM MPSUPDATER.USUARIOS'#13#10 +
      ' WHERE BI_USUARIOS_ID = LAST_INSERT_ID()';
      dbaBeforeEdit: RefreshSQL :=
      'SELECT BI_USUARIOS_ID'#13#10 +
      '  FROM MPSUPDATER.USUARIOS'#13#10 +
      ' WHERE BI_USUARIOS_ID = :OLD_BI_USUARIOS_ID';
    end
  else if aZQuery = EXCLUSOES then
    case aDBAction of
      dbaBeforeInsert: RefreshSQL :=
      'SELECT BI_EXCLUSOES_ID'#13#10 +
      '  FROM MPSUPDATER.EXCLUSOES'#13#10 +
      ' WHERE BI_EXCLUSOES_ID = LAST_INSERT_ID()';
      dbaBeforeEdit: RefreshSQL :=
      'SELECT BI_EXCLUSOES_ID'#13#10 +
      '  FROM MPSUPDATER.EXCLUSOES'#13#10 +
      ' WHERE BI_EXCLUSOES_ID = :OLD_BI_EXCLUSOES_ID';
    end;

  aZQuery.UpdateObject.RefreshSQL.Text := RefreshSQL;
end;

function TDataModule_Principal.SHBrowseForObject(const aOwner: TComponent;
                                                 const aDialogTitle: ShortString;
                                                 const aDialogText: String;
                                                   out aSelection: String): Boolean;
var
	SHBFO: TSHBrowseForObject;
begin
	SHBFO := nil;
	try
    SHBFO := TSHBrowseForObject.Create(aOwner);
    with SHBFO do
    begin
      DialogTitle := aDialogTitle;
      DialogText := aDialogText;
      RootObject := ridDesktop;
      Flags := [bfDirectoriesOnly,bfStatusText,bfNewDialogStyle];
    end;

    Result := SHBFO.Execute;
    aSelection := SHBFO.SelectedObject;

  finally
    if Assigned(SHBFO) then
      SHBFO.Free;
  end;
end;

procedure TDataModule_Principal.ShowBalloonToolTipValidationFor(aCurrentForm: TForm; aDataSet: TDataSet; aFieldError: TField);
var
	i: Word;
	Componente: TComponent;
	DataSet: TDataSet;
	DataField: TField;
  BTT: TBalloonToolTip;
begin
	BTT := Form_Principal.BalloonToolTip_Principal;

	for i := 0 to Pred(aCurrentForm.ComponentCount) do
	begin
		Componente := aCurrentForm.Components[i];

		if not IsValidDataWareComponent(Componente,DataSet,DataField) then
        	Continue;

        if (DataSet <> aDataSet) or (DataField <> aFieldError) then
        	Continue;

        if Componente is TDBEdit then
        begin
	        BTT.AssociatedWinControl := TDBEdit(Componente);
    	    BTT.Show;
            Break;
        end
        else if Componente is TDBMemo then
        begin
  	        BTT.AssociatedWinControl := TDBMemo(Componente);
            BTT.Show;
            Break;
        end
        else if Componente is TDBImage then
        begin
            BTT.AssociatedWinControl := TDBImage(Componente);
            BTT.Show;
            Break;
        end
        else if Componente is TDBListBox then
        begin
            BTT.AssociatedWinControl := TDBListBox(Componente);
            BTT.Show;
            Break;
        end
        else if Componente is TDBComboBox then
        begin
            BTT.AssociatedWinControl := TDBComboBox(Componente);
            BTT.Show;
            Break;
        end
        else if Componente is TDBCheckBox then
        begin
            BTT.AssociatedWinControl := TDBCheckBox(Componente);
            BTT.Show;
            Break;
        end
        else if Componente is TDBRadioGroup then
        begin
            BTT.AssociatedWinControl := TDBRadioGroup(Componente);
            BTT.Show;
            Break;
        end
        else if Componente is TDBLookupListBox then
        begin
            BTT.AssociatedWinControl := TDBLookupListBox(Componente);
            BTT.Show;
            Break;
        end
        else if Componente is TDBLookupComboBox then
        begin
            BTT.AssociatedWinControl := TDBLookupComboBox(Componente);
            BTT.Show;
            Break;
        end
        else if Componente is TDBRichEdit then
        begin
            BTT.AssociatedWinControl := TDBRichEdit(Componente);
            BTT.Show;
            Break;
        end;
	end;
end;

procedure TDataModule_Principal.SISTEMASAfterDelete(DataSet: TDataSet);
begin
  { Após excluir um sistema precisamos excluir este sistema da coleção de
  sistemas }
  FMonitoredSystems.Delete(FMonitoredSystems.GetMonitoredSystemById(FCurrentSystemId).Index);
end;

procedure TDataModule_Principal.SISTEMASAfterPost(DataSet: TDataSet);
var
  MonitoredDirChange: Boolean;
  MonitoredSystem: TMonitoredSystem;
begin
  MonitoredDirChange := True;

  { Se estivermos editando um sistema já existente... }
  if FCurrentSystemId > 0 then
  begin
    MonitoredSystem := FMonitoredSystems.MonitoredSystemById[FCurrentSystemId];
    { Atualizando o diretório de monitoramento apenas se o mesmo mudou }
    MonitoredDirChange := MonitoredSystem.FCFSHChangeNotifier.Root <> SISTEMASVA_DIRETORIO.AsString;

    with MonitoredSystem do
    begin
      FCFSHChangeNotifier.Root := SISTEMASVA_DIRETORIO.AsString;
      SystemName := SISTEMASVA_NOME.AsString;
    end;
  end
  { ...do contrário será um sistema novo! }
  else
  begin
    with FMonitoredSystems.Add do
    begin
      ID := SISTEMASBI_SISTEMAS_ID.AsLargeInt;
      CFSHChangeNotifier.Root := SISTEMASVA_DIRETORIO.AsString;
      SystemName := SISTEMASVA_NOME.AsString;
    end;
    MonitoredSystem := FMonitoredSystems.LastMonitoredSystem;
  end;


  { Reconstrói a lista de arquivos baseando-se no novo diretório de monitoramento }
  if MonitoredDirChange then
    MonitoredSystem.DoNotification;
end;

procedure TDataModule_Principal.SISTEMASBeforeDelete(DataSet: TDataSet);
begin
  FCurrentSystemId := SISTEMASBI_SISTEMAS_ID.AsInteger;
end;

procedure TDataModule_Principal.SISTEMASBeforeEdit(DataSet: TDataSet);
begin
  FCurrentSystemId := SISTEMASBI_SISTEMAS_ID.AsInteger;
  if (DataSet is TZQuery) and Assigned(TZQuery(DataSet).UpdateObject) then
    SetRefreshSQL(TZQuery(DataSet),dbaBeforeEdit);
end;

procedure TDataModule_Principal.SISTEMASBeforeInsert(DataSet: TDataSet);
begin
  FCurrentSystemId := 0;
  if (DataSet is TZQuery) and Assigned(TZQuery(DataSet).UpdateObject) then
    SetRefreshSQL(TZQuery(DataSet),dbaBeforeInsert);
end;

procedure TDataModule_Principal.SISTEMASBeforePost(DataSet: TDataSet);
begin
  CFDBValidationChecks_SIS.ValidateBeforePost;
end;

procedure TDataModule_Principal.Timer_UpdateClientCountTimer(Sender: TObject);
begin
  UpdateClientCount;
end;

procedure TDataModule_Principal.ZConnection_PrincipalAfterConnect(Sender: TObject);
var
  i: Word;
begin
  Form_Principal.RichEdit_LogMonitoramento.Lines[Pred(Form_Principal.RichEdit_LogMonitoramento.Lines.Count)] := Form_Principal.RichEdit_LogMonitoramento.Lines[Pred(Form_Principal.RichEdit_LogMonitoramento.Lines.Count)] + ' Concluído!';

  ShowOnLog('Abrindo tabelas...',Form_Principal.RichEdit_LogMonitoramento,100,'AutoSaveMon.log');
  ShowOnLog('> SISTEMAS...',Form_Principal.RichEdit_LogMonitoramento,100,'AutoSaveMon.log');
  SISTEMAS.Open;
  Form_Principal.RichEdit_LogMonitoramento.Lines[Pred(Form_Principal.RichEdit_LogMonitoramento.Lines.Count)] := Form_Principal.RichEdit_LogMonitoramento.Lines[Pred(Form_Principal.RichEdit_LogMonitoramento.Lines.Count)] + ' Concluído!';

  ShowOnLog('> ARQUIVOS...',Form_Principal.RichEdit_LogMonitoramento,100,'AutoSaveMon.log');
  ARQUIVOS.Open;
  Form_Principal.RichEdit_LogMonitoramento.Lines[Pred(Form_Principal.RichEdit_LogMonitoramento.Lines.Count)] := Form_Principal.RichEdit_LogMonitoramento.Lines[Pred(Form_Principal.RichEdit_LogMonitoramento.Lines.Count)] + ' Concluído!';

  ShowOnLog('> USUARIOS...',Form_Principal.RichEdit_LogMonitoramento,100,'AutoSaveMon.log');
  USUARIOS.Open;
  Form_Principal.RichEdit_LogMonitoramento.Lines[Pred(Form_Principal.RichEdit_LogMonitoramento.Lines.Count)] := Form_Principal.RichEdit_LogMonitoramento.Lines[Pred(Form_Principal.RichEdit_LogMonitoramento.Lines.Count)] + ' Concluído!';

  ShowOnLog('> SISTEMASDOSUSUARIOS...',Form_Principal.RichEdit_LogMonitoramento,100,'AutoSaveMon.log');
  SISTEMASDOSUSUARIOS.Open;
  Form_Principal.RichEdit_LogMonitoramento.Lines[Pred(Form_Principal.RichEdit_LogMonitoramento.Lines.Count)] := Form_Principal.RichEdit_LogMonitoramento.Lines[Pred(Form_Principal.RichEdit_LogMonitoramento.Lines.Count)] + ' Concluído!';

  ShowOnLog('> EXCLUSOES...',Form_Principal.RichEdit_LogMonitoramento,100,'AutoSaveMon.log');
  EXCLUSOES.Open;
  Form_Principal.RichEdit_LogMonitoramento.Lines[Pred(Form_Principal.RichEdit_LogMonitoramento.Lines.Count)] := Form_Principal.RichEdit_LogMonitoramento.Lines[Pred(Form_Principal.RichEdit_LogMonitoramento.Lines.Count)] + ' Concluído!';

  // Criando a coleção de monitoramentos...
  ShowOnLog('Carregando coleção de monitoradores de sistemas...',Form_Principal.RichEdit_LogMonitoramento,100,'AutoSaveMon.log');
  FMonitoredSystems := TMonitoredSystems.Create(TMonitoredSystem,ZConnection_Principal);

  SISTEMAS.First;
  while not SISTEMAS.Eof do
  begin
    with FMonitoredSystems.Add do
    begin
      ID := SISTEMASBI_SISTEMAS_ID.AsLargeInt;
      CFSHChangeNotifier.Root := SISTEMASVA_DIRETORIO.AsString;
      SystemName := SISTEMASVA_NOME.AsString;
    end;
    ShowOnLog('> ID#' + SISTEMASBI_SISTEMAS_ID.AsString + ': '+ SISTEMASVA_NOME.AsString + ' (' + SISTEMASVA_DIRETORIO.AsString + ')',Form_Principal.RichEdit_LogMonitoramento,100,'AutoSaveMon.log');
    SISTEMAS.Next
  end;

  if FMonitoredSystems.Count > 0 then
    try
      ShowNotificationMessage := False;

      { Para cada sistema monitorado devemos atualizar as tabelas de monitoramento }
      ShowOnLog('Atualizando tabelas de monitoramento...',Form_Principal.RichEdit_LogMonitoramento,100,'AutoSaveMon.log');
      Form_Principal.RichEdit_LogMonitoramento.Update;
      for i := 0 to Pred(FMonitoredSystems.Count) do
      begin
        ShowOnLog('> ID#' + IntToStr(FMonitoredSystems[i].ID) + ': ' + FMonitoredSystems[i].SystemName + '...',Form_Principal.RichEdit_LogMonitoramento,100,'AutoSaveMon.log');
        FMonitoredSystems[i].DoNotification;
        Form_Principal.RichEdit_LogMonitoramento.Lines[Pred(Form_Principal.RichEdit_LogMonitoramento.Lines.Count)] := Form_Principal.RichEdit_LogMonitoramento.Lines[Pred(Form_Principal.RichEdit_LogMonitoramento.Lines.Count)] + ' Concluído!';
      end;

    finally
      ShowNotificationMessage := True;
    end
  else
    ShowOnLog('> Não há nenhum sistema sendo monitorado!',Form_Principal.RichEdit_LogMonitoramento,100,'AutoSaveMon.log');

  ShowOnLog('-------------------------------------------------------------------------------------',Form_Principal.RichEdit_LogMonitoramento,100,'AutoSaveMon.log');
	FtpServer_Main.Banner := Format(_WELCOME,[FormatDateTime('yyyy',Now)]);
  ShowOnLog('MPS Updater - v' + TFileInformation.GetInfo(ParamStr(0),'FULLVERSION').AsString,Form_Principal.RichEdit_LogMonitoramento,100,'AutoSaveMon.log');

  ShowOnLog(Format(_COPYRIGHT,[FormatDateTime('yyyy',Now)]),Form_Principal.RichEdit_LogMonitoramento,100,'AutoSaveMon.log');
  ShowOnLog('-------------------------------------------------------------------------------------',Form_Principal.RichEdit_LogMonitoramento,100,'AutoSaveMon.log');
	Form_Principal.Caption := 'MPS Updater (Server)';

 	FTPPublic := ExtractFilePath(Application.ExeName) + 'FTPPUBLIC';
 	if not DirectoryExists(FTPPublic) then
  	CreateDir(FTPPublic);

//  UpdateClientCount;
end;

procedure TDataModule_Principal.ZUpdateSQL_ARQAfterDeleteSQL(Sender: TObject);
begin
//  begin
//    VA_CAMINHOCOMPLETO := ARQUIVOSVA_CAMINHOCOMPLETO.AsString;
//    BI_SISTEMAS_ID     := SISTEMASBI_SISTEMAS_ID.AsInteger;
//
//    { Primeiro insere o registro na tabela de exclusão caso ele não exista }
//    if not EXCLUSOES.Locate('VA_CAMINHOCOMPLETO',VA_CAMINHOCOMPLETO,[loCaseInsensitive]) then
//    begin
//      EXCLUSOES.Insert;
//      EXCLUSOESBI_SISTEMAS_ID.AsInteger := BI_SISTEMAS_ID;
//      EXCLUSOESVA_CAMINHOCOMPLETO.AsString := VA_CAMINHOCOMPLETO;
//      EXCLUSOES.Post;
//    end;
//
//    { Depois exclui o arquivo fisicamente }
//    DeleteFile(SISTEMASVA_DIRETORIO.AsString + '\' + )
//
//  end;

end;

{ TMonitoredSystems }

function TMonitoredSystems.Add: TMonitoredSystem;
begin
  Result := TMonitoredSystem(inherited Add);
end;

constructor TMonitoredSystems.Create(ItemClass: TCollectionItemClass; aZConnection: TZConnection);
begin
  inherited Create(ItemClass);
  FZConnection := aZConnection;
end;

function TMonitoredSystems.GetLastMonitoredSystem: TMonitoredSystem;
begin
  Result := nil;
  if Count > 0 then
    Result := GetMonitoredSystem(Pred(Count));
end;

function TMonitoredSystems.GetMonitoredSystem(i: Word): TMonitoredSystem;
begin
  Result := TMonitoredSystem(inherited Items[i]);
end;

function TMonitoredSystems.GetMonitoredSystemById(id: Int64): TMonitoredSystem;
var
  i: Cardinal;
begin
    Result := nil;
    for i := 0 to Pred(Count) do
        if Self[i].ID = id then
        begin
            Result := Self[i];
            Break;
        end;
end;

{ TMonitoredSystem }

procedure TMonitoredSystem.ClearFilesFromSystem;
begin
  with FZReadOnlyQuery do
  begin
    SQL.Text := 'DELETE FROM MPSUPDATER.ARQUIVOS WHERE BI_SISTEMAS_ID = ' + IntToStr(FID);
    ExecSQL;
  end;
end;

procedure TMonitoredSystem.AddFilesToSystem;
function StringToHex(S: String): String;
var
  i: Integer;
begin
  Result := '';
  for i := 1 to length (S) do
    Result:= Result + IntToHex(Ord(S[i]),2);
end;

const
  SQL_INSERT = 'INSERT INTO MPSUPDATER.ARQUIVOS(BI_SISTEMAS_ID'#13#10 +
               '                               ,VA_CAMINHOCOMPLETO'#13#10 +
               '                               ,DT_DATAEHORA)'#13#10 +
               '     VALUES %s';
  SQL_VALUES = '(%u,0x%s,%s)'#13#10;
var
  i: Cardinal;
  Values: string;
begin
  if FileInfos.Count > 0 then
  begin
    Values := '';
    with FZReadOnlyQuery do
    begin
      { Montando a string com valores da inserção }
      for i := 0 to Pred(FileInfos.Count) do
      begin
        if i = 0 then
          Values := Format(SQL_VALUES,[FID
                                      ,StringToHex(FFileInfos[i].FullPath)
                                      ,FormatDateTime('yyyymmddhhnnss',FFileInfos[i].DateTime)])
        else
          Values := Values + '          , ' + Format(SQL_VALUES,[FID
                                                                ,StringToHex(FFileInfos[i].FullPath)
                                                                ,FormatDateTime('yyyymmddhhnnss',FFileInfos[i].DateTime)]);
      end;
      SQL.Text := Format(SQL_INSERT,[Values]);
      ExecSQL;
    end;
  end;
end;

constructor TMonitoredSystem.Create(Collection: TCollection);
begin
  inherited;
  { Cria o notificador }
  FCFSHChangeNotifier := TCFSHChangeNotifier.Create(nil);
  { Cria a coleção com informações sobre arquivos }
  FFileInfos := TFileInfos.Create(TFileInfo);
  { Cria a query auxiliar para este sistema }
  FZReadOnlyQuery := TZReadOnlyQuery.Create(nil);
  FZReadOnlyQuery.Connection := TMonitoredSystems(Collection).ZConnection;
  { Para cada notificação indicada realiza os mesmos procedimentos }
  FCFSHChangeNotifier .OnChangeFileName := DoNotification;
  FCFSHChangeNotifier.OnChangeDirName := DoNotification;
  FCFSHChangeNotifier.OnChangeSize := DoNotification;
  FCFSHChangeNotifier.OnChangeLastWrite := DoNotification;
//  FCFSHChangeNotifier.OnChangeAttributes := DoNotification;
end;

destructor TMonitoredSystem.Destroy;
begin
  FZReadOnlyQuery.Free;
  FFileInfos.Free;
  FCFSHChangeNotifier.Free;
  inherited;
end;

procedure TMonitoredSystem.DoNotification;
begin
  if ShowNotificationMessage then
    ShowOnLog('§ Alteração detectada em "' + FSystemName + '". Atualizando tabela de arquivos...',Form_Principal.RichEdit_LogMonitoramento,100,'AutoSaveMon.log');

  { (Re)Preenche a coleção de arquivos deste sistema }
  GetRelativePaths;

  { Não me chame de estúpido, eu sei que excluir e recriar tudo todas as vezes
  está longe de ser eficiente mas, considerando que as atualizações nos arquivos
  serão pontuais, para acelerar o desenvolvimento e não ter de lidar com uma
  rotina de sincronização inteligente (normalmente complexa), esta foi a melhor
  solução imediata }

  { Limpa a tabela de arquivos deste sistema }
  ClearFilesFromSystem;

  { Preenche a tabela de arquivos do sistema }
  AddFilesToSystem;
end;

procedure TMonitoredSystem.GetRelativePaths;
{ ---------------------------------------------------------------------------- }
function RelativePath: ShortString;
begin
  Result := ExtractRelativePath(IncludeTrailingPathDelimiter(FCFSHChangeNotifier.Root),IncludeTrailingPathDelimiter(GetCurrentDir))
//  ExtractShortPathName
end;

procedure SearchTree;
var
  SearchRec: TSearchRec;
  DosError: integer;
begin
  try
    DosError := FindFirst('*.*', 0, SearchRec);

    while DosError = 0 do
    begin
      with FFileInfos.Add do
      begin
        FullPath := RelativePath + SearchRec.Name;
        DateTime := FileDateToDateTime(SearchRec.Time);
        Size := SearchRec.Size;
      end;
      DosError := FindNext(SearchRec);
    end;
  finally
    FindClose(SearchRec);
  end;

  try
    DosError := FindFirst('*.*', faDirectory, SearchRec);

    while DosError = 0 do
    begin
      if ((SearchRec.attr and faDirectory = faDirectory) and (SearchRec.name <> '.') and (SearchRec.name <> '..')) then
      begin
        ChDir(SearchRec.Name);
//        aStrings.Add(RelativePath + SearchRec.Name);
        SearchTree;
        ChDir('..');
      end;
      DosError := FindNext(SearchRec);
    end;
  finally
    FindClose(SearchRec)
  end;

end;
{ ---------------------------------------------------------------------------- }
begin
	FFileInfos.Clear;
	ChDir(FCFSHChangeNotifier.Root);
	SearchTree;
end;

{ TFileInfos }

function TFileInfos.Add: TFileInfo;
begin
  Result := TFileInfo(inherited Add);
end;

function TFileInfos.GetFileInfo(i: Cardinal): TFileInfo;
begin
    Result := TFileInfo(inherited Items[i]);
end;

end.






