unit UFSSForm_Main;
{ Esta � a unit principal do programa. Ela cont�m os m�todos usados no
formul�rio principal (�[link FPrincipal]). E outros usados pelo servidor FTP }

interface
                                                           
uses
    Windows, Messages, Variants, Classes, Graphics, Controls, Forms,
    Dialogs, StdCtrls, XPStyleActnCtrls, ActnList, ActnMan,
    ToolWin, ActnCtrls, ActnMenus, ComCtrls, ExtCtrls, OverbyteIcsFtpSrv,
    Winsock, ZConnection, ZDataSet, UFSYGlobals,
    UFSYTypesConstantsAndClasses, UXXXTypesConstantsAndClasses, SysUtils,
    OverbyteIcsWndControl, OverbyteIcsWSocket;
type
    TFSSForm_Main = class(TForm)
        ActionMainMenuBar1: TActionMainMenuBar;
        ActionManager: TActionManager;
        ActionLigarServidor: TAction;
        ActionDesligarServidor: TAction;
        StatusBar1: TStatusBar;
        Panel1: TPanel;
        Button1: TButton;
        FTPServer: TFtpServer;
        RedImage: TImage;
        GreenImage: TImage;
        ClientCountLabel: TLabel;
        ActionSobre: TAction;
        ActionConfiguracoes: TAction;
        Button2: TButton;
        RichEditLog: TRichEdit;
        SaveDialog1: TSaveDialog;
        Timer1: TTimer;
        ActionToolBar1: TActionToolBar;
        procedure ActionSobreExecute(Sender: TObject);
        procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
        procedure Timer1Timer(Sender: TObject);
        procedure Button2Click(Sender: TObject);
        procedure DoValidateRnTo(Sender: TObject; Client: TFtpCtrlSocket; var FilePath: TFtpString; var Allowed: Boolean);
        procedure DoValidateRnFr(Sender: TObject; Client: TFtpCtrlSocket; var FilePath: TFtpString; var Allowed: Boolean);
        procedure DoValidateRmd(Sender: TObject; Client: TFtpCtrlSocket; var FilePath: TFtpString; var Allowed: Boolean);
        procedure DoValidateSize(Sender: TObject; Client: TFtpCtrlSocket; var FilePath: TFtpString; var Allowed: Boolean);
        procedure DoValidateDele(Sender: TObject; Client: TFtpCtrlSocket; var FilePath: TFtpString; var Allowed: Boolean);
        procedure DoMakeDirectory(Sender: TObject; Client: TFtpCtrlSocket; Directory: TFtpString; var Allowed: Boolean);
        procedure DoCalculateMd5(Sender: TObject; Client: TFtpCtrlSocket; var FilePath, Md5Sum: TFtpString; var Allowed: Boolean);
        procedure DoChangeDirectory(Sender: TObject; Client: TFtpCtrlSocket; Directory: TFtpString; var Allowed: Boolean);
        procedure DoValidatePut(Sender: TObject; Client: TFtpCtrlSocket; var FilePath: TFtpString; var Allowed: Boolean);
        procedure DoValidateGet(Sender: TObject; Client: TFtpCtrlSocket; var FilePath: TFtpString; var Allowed: Boolean);
        procedure ActionConfiguracoesExecute(Sender: TObject);
        procedure FormDestroy(Sender: TObject);
        procedure DoStorSessionConnected(Sender: TObject; Client: TFtpCtrlSocket; Data: TWSocket; AError: Word);
        procedure DoStorSessionClosed(Sender: TObject; Client: TFtpCtrlSocket; Data: TWSocket; AError: Word);
        procedure DoRetrSessionConnected(Sender: TObject; Client: TFtpCtrlSocket; Data: TWSocket; AError: Word);
        procedure DoRetrSessionClosed(Sender: TObject; Client: TFtpCtrlSocket; Data: TWSocket; AError: Word);
        procedure DoRetrDataSent(Sender: TObject; Client: TFtpCtrlSocket; Data: TWSocket; AError: Word);
        procedure DoClientCommand(Sender: TObject; Client: TFtpCtrlSocket; var Keyword, Params, Answer: TFtpString);
        procedure DoAuthenticate(Sender: TObject; Client: TFtpCtrlSocket; UserName, Password: TFtpString; var Authenticated: Boolean);
        procedure DoAnswerToClient(Sender: TObject; Client: TFtpCtrlSocket; var Answer: TFtpString);
        procedure DoStop(Sender: TObject);
        procedure DoStart(Sender: TObject);
        procedure DoClientDisconnect(Sender: TObject; Client: TFtpCtrlSocket; AError: Word);
        procedure DoClientConnect(Sender: TObject; Client: TFtpCtrlSocket; AError: Word);
        procedure DoGetProcessing(Sender: TObject; Client: TFtpCtrlSocket; var DelayedSend: Boolean);
        procedure ActionDesligarServidorExecute(Sender: TObject);
        procedure ActionLigarServidorExecute(Sender: TObject);
        procedure FormCreate(Sender: TObject);
        procedure Button1Click(Sender: TObject);
    private
        FtpRoot: String;
        FFSYGlobals: TFSYGlobals;

        { Estes campos devem estar dentro das threads }
        FConnectedClient: TConnectedClient;
        FVerboseMode: Boolean;

        procedure Ativar;
        function Desativar: Boolean;
        procedure UpdateClientCount;
        function UsuarioAutenticado(Usuario, Senha: String; ClienteConectado: TFtpCtrlSocket): Boolean;
        function UsuarioRoboAutenticado(Usuario, Senha: String; ClienteConectado: TFtpCtrlSocket; var DecodedUser: String): Boolean;
        procedure ClearDirectory(Directory: String);
        procedure AbortEverything(aConnectedClient: TConnectedClient;
                                  aErrorMessage: String);

        { Estes m�todos devem estar dentro das Threads }
        procedure DoGetChecksum(aTableName: String; aTableNo, aTableCount: Word; aTableChecksum: String; const aIgnored: Boolean);
        procedure ProcessRequest(aClient: TConnectedClient);
        procedure DoZlibNotification(aNotificatioType: TZlibNotificationType; aOperation: TZLibOperation; aInputFile, aOutputFile: TFileName);
    public
        procedure SalvarLog;
        property FSYGlobals: TFSYGlobals read FFSYGlobals;
    end;

var
    FSSForm_Main: TFSSForm_Main;

implementation

uses
	UFSSForm_Configurations, DB, ZDbcIntfs, UFSSForm_Splash,
  	UFSYSyncStructures, UObjectFile, OverbyteIcsFtpSrvT;

{$R *.dfm}

procedure TFSSForm_Main.Button1Click(Sender: TObject);
begin
	SalvarLog;
    RichEditLog.Clear;
    FFSYGlobals.ShowOnLog('� Log salvo e limpo em ' + FormatDateTime('dd.mm.yyyy "�s" hh.nn.ss',Now),RichEditLog);
end;

{Este procedure ativa o servidor na porta selecionada nas configura��es
(�[linkUnit UConfiguracoes])}
procedure TFSSForm_Main.Ativar;
var
	WSI: TWSAData;
begin
	GreenImage.Visible := False;
  RedImage.Visible := True;
  Update;

  WSI := WinsockInfo;

  if Self.Tag = 0 then
    begin
        FFSYGlobals.ShowOnLog('Usando:',RichEditLog);
        FFSYGlobals.ShowOnLog('  ' + Trim(OverbyteIcsWSocket.CopyRight),RichEditLog);
        FFSYGlobals.ShowOnLog('  ' + Trim(OverbyteIcsFtpSrv.CopyRight),RichEditLog);
        FFSYGlobals.ShowOnLog('  Informa��es sobre o Winsock...',RichEditLog);
        FFSYGlobals.ShowOnLog('    Vers�o .....: ' + Format('%d.%d', [WSI.wHighVersion shr 8,WSI.wHighVersion and 15]),RichEditLog);
        FFSYGlobals.ShowOnLog('    Descri��o ..: ' + StrPas(WSI.szDescription),RichEditLog);
        FFSYGlobals.ShowOnLog('    Status .....: ' + StrPas(WSI.szSystemStatus),RichEditLog);

        if Assigned(WSI.lpVendorInfo) then
            FFSYGlobals.ShowOnLog('    ' + StrPas(WSI.lpVendorInfo),RichEditLog);

        Self.Tag := 1;
    end;

    FTPServer.Port := IntToStr(FFSYGlobals.Configurations.FT_PortNumb);
    FTPServer.Addr := '0.0.0.0';
    FTPServer.ClientClass := TConnectedClient;
    FTPServer.Start;
end;

{Este procedure desativo o servidor fazendo exatamente o contr�rio que o
procedure �[link Ativar]}
function TFSSForm_Main.Desativar;
begin
    Result := False;
    if FTPServer.ClientCount > 0 then
        MessageBox(Handle,'Ainda existem clientes conectados, n�o � poss�vel desativar o servidor. Aguarde at� que todos os clientes tenham se desconectado para poder desativar o servidor','Opera��o pendente detectada',MB_ICONWARNING)
    else
    begin
        FTPServer.DisconnectAll;
        FTPServer.Stop;
        Result := True;
    end;
end;

procedure TFSSForm_Main.FormCreate(Sender: TObject);
begin
	FTPServer.Banner := Format(FTPSYNC_WELCOME,[FormatDateTime('yyyy',Now)]);

    with TServerInformation.Create(Self) do
        try
            FFSYGlobals.ShowOnLog('FTP Syncronizer (FTPSync) - v' + Version.FullVersionString,RichEditLog);
        finally
            Free
        end;

  	FFSYGlobals.ShowOnLog(Format(FTPSYNC_COPYRIGHT,[FormatDateTime('yyyy',Now)]),RichEditLog);
  	FFSYGlobals.ShowOnLog('-----------------------------------------------------------------------------------------------',RichEditLog);
  	Caption := 'FTP Syncronizer - Edi��o exclusiva para ' + FTPSYNC_CUSTOMCLIENT;

  	UpdateClientCount;

  	FtpRoot := GetCurrentDir + '\FTPROOT\';

  	if not DirectoryExists(FtpRoot) then
  		CreateDir(FtpRoot);

	FFSYGlobals := TFSYGlobals.Create;

  	if FFSYGlobals.Configurations.SalvarLogACada > 0 then
  	begin
  		Timer1.Interval := FFSYGlobals.Configurations.SalvarLogACada * 1000;
	  	Timer1.Enabled := True;
  	end;
end;

procedure TFSSForm_Main.ActionLigarServidorExecute(Sender: TObject);
begin
	Ativar;
    ActionDesligarServidor.Enabled := True;
    ActionLigarServidor.Enabled := not ActionDesligarServidor.Enabled;
end;

procedure TFSSForm_Main.ActionDesligarServidorExecute(Sender: TObject);
begin
	Desativar;
    ActionLigarServidor.Enabled := True;
	ActionDesligarServidor.Enabled := not ActionLigarServidor.Enabled;
    { TODO : s� permita desativa��o se n�o houver ninguem conectado }
end;

{Este procedure atualiza um label que cont�m a quantidade de clientes conectados
no momento}
procedure TFSSForm_Main.UpdateClientCount;
begin
    if FTPServer.Active then
    begin
        if FTPServer.ClientCount = 0 then
        begin
            ClientCountLabel.Caption := 'Nenhum usu�rio no momento';
            GreenImage.Visible := True;
            RedImage.Visible   := False;
        end
    else
    begin
        ClientCountLabel.Caption := IntToStr(FTPServer.ClientCount) + ' usu�rio(s) conectado(s)';
        GreenImage.Visible := False;
        RedImage.Visible   := True;
    end
    end
    else
        ClientCountLabel.Caption := 'O FTP Synchronizer econtra-se desativado e n�o pode responder a requisi��es';

    Application.ProcessMessages;
end;

{Este evento � lan�ado quando o servidor se inicia
�param Sender Diz respeito ao componente ao qual este evento est� associado, no caso, ao componente FTPClient}
procedure TFSSForm_Main.DoStart;
begin
	GreenImage.Visible := True;
  	RedImage.Visible := False;
  	FFSYGlobals.ShowOnLog('� Servidor ativado na porta ' + IntToStr(FFSYGlobals.Configurations.FT_PortNumb),RichEditLog);
  	FFSYGlobals.ShowOnLog('-----------------------------------------------------------------------------------------------',RichEditLog);
  	UpdateClientCount;
end;

{Este evento � lan�ado quando o servidor � parado
�param Sender Diz respeito ao componente ao qual este evento est� associado, no caso, ao componente FTPClient}
procedure TFSSForm_Main.DoStop;
begin
	GreenImage.Visible := False;
  	RedImage.Visible   := True;
  	FFSYGlobals.ShowOnLog('� Servidor desativado',RichEditLog);
  	FFSYGlobals.ShowOnLog('-----------------------------------------------------------------------------------------------',RichEditLog);
  	UpdateClientCount;
end;

{Este evento � lan�ado quando o servidor recebe um comando do cliente
�param Sender Diz respeito ao componente ao qual este evento est� associado, no caso, ao componente FTPClient
�param Client Este par�metro � um ponteiro para um tipo �[link TConnectedClient] que representa o cliente que est� desconectando
�param Keyword Este par�metro cont�m o nome do comando recebido
�param Params Este par�metro vari�vel cont�m os par�metros que foram enviados juntamente com o comando e podem ser alterados aqui
�param Answer Este par�metro cont�m a resposta a ser enviada para o cliente}
procedure TFSSForm_Main.DoClientCommand;
begin
	FFSYGlobals.ShowOnLog('COMANDO:> ' + Keyword + ' ' + Params + ' (' + Client.GetPeerAddr + ')',RichEditLog);
end;

{Este evento � lan�ado quando o servidor manda uma resposta ao cliente
�param Sender Diz respeito ao componente ao qual este evento est� associado, no caso, ao componente FTPClient
�param Client Este par�metro � um ponteiro para um tipo �[link TConnectedClient] que representa o cliente que est� desconectando
�param Answer Este par�metro vari�vel cont�m a resposta a ser enviada para o cliente e pode ser alterao aqui}
procedure TFSSForm_Main.DoAnswerToClient;
begin
	FFSYGlobals.ShowOnLog('RETORNO:> ' + Answer + ' (' + Client.GetPeerAddr + ')',RichEditLog);
end;

{Este procedure limpa o diret�rio passado como par�metro, removendo todos os
arquivos e diret�rios contidos no mesmo
�param Directory Diret�rio a ser esvaziado}
procedure TFSSForm_Main.ClearDirectory;
	{Procedures e fun��es locais}
  procedure SearchTree;
  var
    SearchRec: TSearchRec;
    DosError: integer;
  begin
    DosError := FindFirst('*.*', 0, SearchRec);
    while DosError = 0 do
    begin
      try
      	DeleteFile(SearchRec.Name);
      except
        on EOutOfResources do
          MessageBox(Handle,'A quantidade de arquivos localizados excede o limite de recursos do seu sistema. Favor limitar seu crit�rio de busca escolhendo diret�rio(s) de n�vel mais interno.','Recursos do sitema esgotados',MB_ICONERROR);
      end;
      DosError := FindNext(SearchRec);
    end;

    DosError := FindFirst('*.*', faDirectory, SearchRec);
    while DosError = 0 do
    begin
      if ((SearchRec.attr and faDirectory = faDirectory) and (SearchRec.name <> '.') and (SearchRec.name <> '..')) then
      begin
        ChDir(SearchRec.Name);
        SearchTree;
        ChDir('..');
        RemoveDir(SearchRec.Name);
      end;
      DosError := FindNext(SearchRec);
    end;
  end;

begin
	ChDir(Directory);
	SearchTree;
end;

{Este manipulador de evento � executado sempre que um cliente se conecta ao
servidor.
�param Sender Diz respeito ao componente ao qual este evento est� associado, no caso, ao componente FTPClient
�param Client Este par�metro � um ponteiro para um tipo �[link TConnectedClient] que representa o cliente conectado
�param AError Este par�metro cont�m um c�digo de erro. Se for zero indica que n�o houve erro. Se for maior que zero houve um erro}
procedure TFSSForm_Main.DoClientConnect;
begin
	{ O cliente iniciou o processo de conex�o. Aqui  podem ser feitas verifica��es
  	que limitam o acesso. Tente usar uma mascara e compare com o IP }
  	if Client.GetPeerAddr = '193.121.12.25' then
  	begin
		Client.SendAnswer('421 - Conex�o n�o permitida.');
    	Client.Close;
    	Exit;
	end;

	FFSYGlobals.ShowOnLog('� O cliente ' + Client.GetPeerAddr + '/' + Client.GetPeerPort + ' acabou de conectar-se',RichEditLog);

    UpdateClientCount;

  	Client.HomeDir := '';
  	Client.Directory := FtpRoot;
end;

{ Este manipulador de evento � executado sempre que um cliente se desconecta do
servidor.
�param Sender Diz respeito ao componente ao qual este evento est� associado, no caso, ao componente FTPClient
�param Client Este par�metro � um ponteiro para um tipo �[link TConnectedClient] que representa o cliente que est� desconectando
�param AError Este par�metro cont�m um c�digo de erro. Se for zero indica que n�o houve erro. Se for maior que zero houve um erro}
procedure TFSSForm_Main.DoClientDisconnect;
begin
	FFSYGlobals.ShowOnLog('� Cliente (' + Client.GetPeerAddr + ') desconectado',RichEditLog);
    UpdateClientCount;
	{ Se uma conex�o com o banco foi estabelecida ent�o devemos destru�-la }
	if Assigned((Client as TConnectedClient).DataBaseConnection) then
        with (Client as TConnectedClient) do
        begin
            if DataBaseConnection.Connected then
            begin
            	{ Se h� algum transa��o ativa deveremos confirmar ou descartar as altera��es feitas }
                if DataBaseConnection.InTransaction then
                	{ Se o flag de erro estiver habilitado ent�o executa um rollback... }
                    if DataBaseConnection.Tag <> 0 then
                    begin
                    	FFSYGlobals.ShowOnLog('� Revertendo banco de dados a seu estado pr�-sincroniza��o...',RichEditLog);
                        DataBaseConnection.Rollback;
                    end
                    { ...do contr�rio commit }
                    else
                    begin
                    	FFSYGlobals.ShowOnLog('� Confirmando altera��es realizadas no banco de dados...',RichEditLog);
                        DataBaseConnection.Commit;
                    end;

                Application.ProcessMessages;
                { FOI REMOVIDA POIS SEU USO CAUSA ERROS DE SINCRONIZA��O A LONGO
                PRAZO }
                { S� realiza desfragmenta��o caso o n�o haja mais nenhum cliente conectado }
//                if FTPServer.ClientCount = 0 then
//                begin
//    				FFSYGlobals.ShowOnLog('� Desfragmentando tabelas. Favor aguardar...',RichEditLog);
//                    Application.ProcessMessages;
//                    FFSYGlobals.MySQLDefragDatabase(DataBaseConnection);
//                    FFSYGlobals.ShowOnLog('� Desfragmenta��o conclu�da',RichEditLog);
//                end;
            end;

            DataBaseConnection.Disconnect;
            DataBaseConnection.Free;
        end;
end;

function TFSSForm_Main.UsuarioAutenticado;
var
	RODataSet: TZReadOnlyQuery;
    ROConnection: TZConnection;
begin
	Result := False;
  ROConnection := nil;
	RODataSet := nil;
 	try
  	try
      FFSYGlobals.ConfigureConnection(ROConnection);
      FFSYGlobals.ConfigureDataSet(ROConnection,RODataSet,Format(SQL_SELECT_ALL_USERS,[Usuario,Senha]));
      { Verificando senha e login -- Inicio ============================ }
			if RODataSet.RecordCount = 1 then
      begin
        Result := True;
        (ClienteConectado as TConnectedClient).UserName := ClienteConectado.UserName;
        (ClienteConectado as TConnectedClient).PassWord := ClienteConectado.PassWord;
        (ClienteConectado as TConnectedClient).RealName := RODataSet.FieldByName('FULL_NAME').AsString;
        (ClienteConectado as TConnectedClient).Description := RODataSet.FieldByName('DESCRIPTION').AsString;
      end;
            { Verificando senha e login -- Fim =============================== }
        except
        	raise;
        end;
    finally
    	if Assigned(RODataSet) then
	    	RODataSet.Free;

    	if Assigned(ROConnection) then
        	ROConnection.Free;
	end;
end;

function TFSSForm_Main.UsuarioRoboAutenticado;
var
	RODataSet: TZReadOnlyQuery;
    ROConnection: TZConnection;
    DecodedPass: String;
begin
	Result := False;
    ROConnection := nil;
  	RODataSet := nil;

    if Pos('RobotNoDB',Usuario) = 1 then
    	DecodedUser := Copy(Usuario,10,Length(Usuario))
    else if Pos('Robot',Usuario) = 1 then
    	DecodedUser := Copy(Usuario,6,Length(Usuario))
    else
    	DecodedUser := '';

    if Pos('My Name Is DO, BDO!',Senha) = 1 then
    	DecodedPass := Copy(Senha,20,Length(Senha))
    else
    	DecodedPass := '';

  	try
		try
        	FFSYGlobals.ConfigureConnection(ROConnection);
            FFSYGlobals.ConfigureDataSet(ROConnection,RODataSet,Format(SQL_SELECT_ALL_USERS2,[DecodedUser,DecodedPass]));

            { Verificando senha e login -- Inicio ============================ }
			if RODataSet.RecordCount = 1 then
            begin
                with (ClienteConectado as TConnectedClient) do
                begin
                    UserName := Usuario;
                    Password := Senha;
                    RealName := 'Optimus Prime (' + Copy(Usuario,10,Length(Usuario)) + ')';
                    Description := 'Usu�rio-Rob� de conex�o autom�tica avan�ada';
                end;
            	Result := True;
            end;
            { Verificando senha e login -- Fim =============================== }
        except
        	raise;
        end;
    finally
    	if Assigned(RODataSet) then
	    	RODataSet.Free;

    	if Assigned(ROConnection) then
        	ROConnection.Free;
	end;
end;
{Este evento � lan�ado quando o servidor tenta autenticar o cliente com seu login e sua senha
�param Sender Diz respeito ao componente ao qual este evento est� associado, no caso, ao componente FTPClient
�param Client Este par�metro � um ponteiro para um tipo �[link TConnectedClient] que representa o cliente que est� desconectando
�param UserName Este par�metro cont�m o nome de usu�rio que o cliente passou com o comando USER
�param Password Este par�metro cont�m a senha que o cliente passou com o comando PASS
�param Authenticated Este par�metro vari�vel pode ser alterado para refletir o status pos autentica��o. Se ele receber true, o usu�rio est� autenticado}
procedure TFSSForm_Main.DoAuthenticate;
var
  	StrTemp: String;
  	HoraAtual: Byte;
    ClientConnectedIP: String;
begin
	{ If you need to store info about the client for later processing }
  	{ you can use Client.UserData to store a pointer to an object or  }
  	{ a record with the needed info.                                  }
  	Authenticated := False;
  	try
		if UsuarioAutenticado(UserName,Password,Client) then
    	begin
        	{ Criando conex�o com o banco e mantendo-a atrelada ao usu�rio }
  			FFSYGlobals.ShowOnLog('� Iniciando conex�o transacional com o banco de dados...',RichEditLog);
//            (Client as TConnectedClient).DataBaseConnection := nil; j� � limpo no create de TConnectedCliente
            FFSYGlobals.ConfigureConnection(TConnectedClient(Client).DataBaseConnection);

            { Configura outros par�metros }
            if (Client as TConnectedClient).DataBaseConnection.Connected then
            begin
                (Client as TConnectedClient).DataBaseConnection.Tag := 1; { Condi��o pessimista: assume sempre que deve fazer rollback }
	            (Client as TConnectedClient).DataBaseConnection.AutoCommit := True;
                (Client as TConnectedClient).DataBaseConnection.StartTransaction;
                FFSYGlobals.MySQLSetVariable((Client as TConnectedClient).DataBaseConnection,'SQL_QUOTE_SHOW_CREATE',0);
                FFSYGlobals.MySQLSetDBUserVariable((Client as TConnectedClient).DataBaseConnection,'SYNCHRONIZING',True);
                FFSYGlobals.MySQLSetDBUserVariable((Client as TConnectedClient).DataBaseConnection,'SERVERSIDE',True);
                FFSYGlobals.MySQLSetDBUserVariable((Client as TConnectedClient).DataBaseConnection,'ADJUSTINGDB',False);
                FFSYGlobals.ExecuteQuery((Client as TConnectedClient).DataBaseConnection,'CREATE TEMPORARY TABLE IF NOT EXISTS ORPHANFIELDS (MI_ORDEM MEDIUMINT)');
            end;

            { Os nomes dos diret�rios ser�o o IPs das pessoas que conectam }
            (Client as TConnectedClient).IP := Client.GetPeerAddr;
            ClientConnectedIP := (Client as TConnectedClient).IP;// + '#' + IntToStr(Client.ID);

            if not DirectoryExists(FtpRoot + StringReplace(ClientConnectedIP,'.','x',[rfReplaceAll])) then
            begin
                if CreateDir(FtpRoot + StringReplace(ClientConnectedIP,'.','x',[rfReplaceAll])) then
                    Client.HomeDir := FtpRoot + StringReplace(ClientConnectedIP,'.','x',[rfReplaceAll]) + '\';
            end
            else
            begin
                ClearDirectory(FtpRoot + StringReplace(ClientConnectedIP,'.','x',[rfReplaceAll]));
                Client.HomeDir := FtpRoot + StringReplace(ClientConnectedIP,'.','x',[rfReplaceAll]) + '\';
            end;

            HoraAtual := StrToInt(FormatDateTime('hh',Now));

            if HoraAtual < 12 then
                StrTemp := 'Bom dia'
            else if HoraAtual < 18 then
                StrTemp := 'Boa tarde'
            else
                StrTemp := 'Boa noite';

            Authenticated := True;
            FFSYGlobals.ShowOnLog('� O usu�rio "' + UserName + '@' + ClientConnectedIP + '" foi autenticado',RichEditLog);
            Client.SendAnswer(Format(FTPSYNC_CLIENT_AUTHENTICATED,[StrTemp,(Client as TConnectedClient).RealName]));
		end
    	{ Conex�es cujo usu�rio come�a com "Robot" s�o tempor�rias. S�o conex�es
        autom�ticas para depura��o e utiliza��o avan�ada }
        else if UsuarioRoboAutenticado(UserName,Password,Client,StrTemp) then
        begin
			if not (Pos('RobotNoDB',UserName) = 1) then
            begin
            	{ Criando conex�o com o banco e mantendo-a atrelada ao usu�rio }
                FFSYGlobals.ShowOnLog('� Iniciando conex�o transacional com o banco de dados...',RichEditLog);
//                (Client as TConnectedClient).DataBaseConnection := nil; j� � limpo no create de tconnectedclient
                FFSYGlobals.ConfigureConnection((Client as TConnectedClient).DataBaseConnection);
                { Configura outros par�metros }
                if (Client as TConnectedClient).DataBaseConnection.Connected then
                begin
                    (Client as TConnectedClient).DataBaseConnection.Tag := 1; { Condi��o pessimista: assume sempre que deve fazer rollback }
                    (Client as TConnectedClient).DataBaseConnection.AutoCommit := True;
                    (Client as TConnectedClient).DataBaseConnection.StartTransaction;
                    FFSYGlobals.MySQLSetVariable((Client as TConnectedClient).DataBaseConnection,'SQL_QUOTE_SHOW_CREATE',0);
                    FFSYGlobals.MySQLSetDBUserVariable((Client as TConnectedClient).DataBaseConnection,'SYNCHRONIZING',True);
                    FFSYGlobals.MySQLSetDBUserVariable((Client as TConnectedClient).DataBaseConnection,'SERVERSIDE',True);
	                FFSYGlobals.MySQLSetDBUserVariable((Client as TConnectedClient).DataBaseConnection,'ADJUSTINGDB',False);
                end;
            end;

            (Client as TConnectedClient).IP := Client.GetPeerAddr;
            ClientConnectedIP := (Client as TConnectedClient).IP;

            if DirectoryExists(FtpRoot + StrTemp + '\' + StringReplace(ClientConnectedIP,'.','x',[rfReplaceAll])) then
	            Client.HomeDir := FtpRoot + StrTemp + '\' + StringReplace(ClientConnectedIP,'.','x',[rfReplaceAll]) + '\'
            else
            	raise Exception.Create('O usu�rio "' + StrTemp + '" ao qual este usu�rio-rob� se refere, n�o possui um diret�rio no servidor. Talvez o usu�rio "' + StrTemp + '" ainda n�o tenha feito nenhuma sincroniza��o. Por isso n�o � poss�vel usar seu usu�rio-rob�.');

            HoraAtual := StrToInt(FormatDateTime('hh',Now));

            if HoraAtual < 12 then
                StrTemp := 'Bom dia'
            else if HoraAtual < 18 then
                StrTemp := 'Boa tarde'
            else
                StrTemp := 'Boa noite';

            Authenticated := True;
            FFSYGlobals.ShowOnLog('� O usu�rio-rob� "' + UserName + '@' + ClientConnectedIP + '" foi autenticado',RichEditLog);
            Client.SendAnswer(Format(FTPSYNC_CLIENT_AUTHENTICATED,[StrTemp,(Client as TConnectedClient).RealName]));
        end;
    except
    	on E: Exception do
        	AbortEverything(Client as TConnectedClient,E.Message);
    end;
end;

{Este evento � lan�ado quando o buffer de dados � enviado ao cliente depois de
um comando GET
�param Sender Diz respeito ao componente ao qual este evento est� associado, no caso, ao componente FTPClient
�param Client Este par�metro � um ponteiro para um tipo �[link TConnectedClient] que representa o cliente que est� desconectando
�param Data Este par�metro � um ponteiro para um tipo TWSocket e cont�m informa��es sobre o peda�o de dados sendo enviado
�param AError Este par�metro cont�m um c�digo de erro que se for maior que zero, indica um erro}
procedure TFSSForm_Main.DoRetrDataSent;
begin
	if AError <> 0 then
  		FFSYGlobals.ShowOnLog('! ' + Client.GetPeerAddr + ' Dados n�o enviados. Erro #' + IntToStr(AError),RichEditLog);
  { TODO :
No futuro coloque uma barra de progresso multiprop�sito. Aqui ela cresce de acordo com a quantidade de dados
enviados ao cliente. }
end;

{Este evento � lan�ado quando a sess�o de dados � finalizada
�param Sender Diz respeito ao componente ao qual este evento est� associado, no caso, ao componente FTPClient
�param Client Este par�metro � um ponteiro para um tipo �[link TConnectedClient] que representa o cliente que est� desconectando
�param Data Este par�metro � um ponteiro para um tipo TWSocket e cont�m informa��es sobre o peda�o de dados sendo enviado
�param AError Este par�metro cont�m um c�digo de erro que se for maior que zero, indica um erro}
procedure TFSSForm_Main.DoRetrSessionClosed;
begin
    if AError <> 0 then
        FFSYGlobals.ShowOnLog('! ' + Client.GetPeerAddr + ' Sess�o de dados finalizada. Erro #' + IntToStr(AError),RichEditLog)
    else
        FFSYGlobals.ShowOnLog('� ' + Client.GetPeerAddr + ' Sess�o de dados finalizada sem erros!',RichEditLog);

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

{Este procedimento � executado sempre que algo de errado (n�o previsto) ocorre.
Ele grava uma mensagem no log e a envia para o cliente, que posteriormente �
desconectado
�param ConnectedClient Cliente que tentou executar a a��o que falhou
�param ErrorMessage Mensagem de erro a ser informada}
procedure TFSSForm_Main.AbortEverything;
begin
    { Enviando uma mensagem para o cliente de forma que este desfa�a tudo  que foi
    feito antes de desconectar }
    aConnectedClient.SendAnswer('666 - ' + aErrorMessage);
    FFSYGlobals.ShowOnLog('! ' + aErrorMessage,RichEditLog);
    aConnectedClient.Close;
end;

{ TODO -oCARLOS FEITOZA -cEXPLICA��O : Este � o manipulador do evento OnGetChecksum gerado pela gera��o de checksum do banco de dados }
procedure TFSSForm_Main.DoGetChecksum(      aTableName: String;
                                            aTableNo
                                          , aTableCount: Word;
                                            aTableChecksum: String;
                                      const aIgnored: Boolean);
begin
    if not aIgnored then
    begin
        if FVerboseMode then
            FFSYGlobals.SendStatus(FConnectedClient,'Tabela: "' + aTableName + '" (' + IntToStr(aTableNo) + '/' + IntToStr(aTableCount) + ') | MD5: ' + aTableChecksum);
    end
    else
    begin
        if FVerboseMode then
            FFSYGlobals.SendStatus(FConnectedClient,'Tabela: "' + aTableName + '" (' + IntToStr(aTableNo) + '/' + IntToStr(aTableCount) + ') | IGNORADA...');
    end;
end;

{ TODO -oCARLOS FEITOZA -cEXPLICA��O : Este � o manipulador do evento OnNotification gerado pela compress�o ou descompress�o de um arquivo }
procedure TFSSForm_Main.DoZlibNotification(aNotificatioType: TZlibNotificationType;
                                           aOperation: TZLibOperation;
                                           aInputFile
                                          ,aOutputFile: TFileName);
begin
    if aOperation = zloDecompress then
        case aNotificatioType of
            zlntBeforeProcess: FFSYGlobals.ShowOnLog('� Descomprimindo arquivo de dados ' + ExtractFileName(aInputFile) + '...',RichEditLog);
            zlntAfterProcess: FFSYGlobals.ShowOnLog('� Descompress�o conclu�da!',RichEditLog);
        end
    else if aOperation = zloCompress then
        case aNotificatioType of
            zlntBeforeProcess: FFSYGlobals.ShowOnLog('� Comprimindo arquivo de dados ' + ExtractFileName(aInputFile) + '...',RichEditLog);

            zlntAfterProcess: FFSYGlobals.ShowOnLog('� Compress�o conclu�da!',RichEditLog);
        end;
end;


{ TODO -oCARLOS FEITOZA -cEXPLICA��O : Este procedure processa uma requisi��o de
um cliente e gera ao final um arquivo de acordo com a requisi��o feita }
procedure TFSSForm_Main.ProcessRequest(aClient: TConnectedClient);
{ ---------------------------------------------------------------------------- }
procedure ReadParameters(out aRetrSessionParameters: TRetrSessionParameters);
var
    f: file of TRetrSessionParameters;
begin
    ZeroMemory(@aRetrSessionParameters,SizeOf(TRetrSessionParameters));

    if FileExists(aClient.HomeDir + FTPFIL_PARAMETERS) then
        try
            AssignFile(f,aClient.HomeDir + FTPFIL_PARAMETERS);
            FileMode := fmOpenRead;
            Reset(f);
            Read(f,aRetrSessionParameters);
        finally
            CloseFile(f);
        end;
end;
{ ---------------------------------------------------------------------------- }
var
    RetrSessionParameters: TRetrSessionParameters;
	TempStr: String;
    ClientDelta, ServerDelta: TSynchronizationFile;
begin
  FConnectedClient := aClient;

  ReadParameters(RetrSessionParameters);
  FVerboseMode := RetrSessionParameters.VerboseMode;

  try
        { GET.DBCHECKSUM.DAT.PHPS: Este script obt�m todas as tabelas do banco
        de dados, depois circula por todas elas, gerando o checksum que �
        retornado ao cliente
        ---------------------------------------------------------------------- }
        if UpperCase(aClient.FilePath) = UpperCase(aClient.HomeDir) + FTPSCR_DBCHECKSUM then
        begin
            FFSYGlobals.ShowOnLog('@ Executando script ' + ExtractFileName(FTPSCR_DBCHECKSUM),RichEditLog);
            DeleteFile(aClient.HomeDir + FTPFIL_DBCHECKSUM);

            { Criando o arquivo localmente }
            FFSYGlobals.SendStatus(aClient,'== DBCHECKSUM: Iniciando gera��o de conte�do... ===================================');
            FFSYGlobals.SendStatus(aClient,'-----------------------------------------------------------------------------------');

            TempStr := FFSYGlobals.DatabaseCheckSum(aClient.DataBaseConnection
                                                   ,aClient.HomeDir
                                                   ,DoGetChecksum);
            FFSYGlobals.SaveTextFile(TempStr,aClient.HomeDir + FTPFIL_DBCHECKSUM);

            FFSYGlobals.SendStatus(aClient,'-----------------------------------------------------------------------------------');
            FFSYGlobals.SendStatus(aClient,'DATABASE CHECKSUM (MD5): ' + TempStr);
            FFSYGlobals.SendStatus(aClient,'-----------------------------------------------------------------------------------');
            FFSYGlobals.SendStatus(aClient,'SOC: ' + IntToStr(Trunc(FFSYGlobals.FileSize(aClient.HomeDir + FTPFIL_DBCHECKSUM))));
            FFSYGlobals.SendStatus(aClient,'== DBCHECKSUM: Conte�do gerado com sucesso ========================================');
        end
    { GET.SERVERINFO.DAT.PHPS: Este script obt�m algumas informa��es sobre o
    servidor
    -------------------------------------------------------------------------- }
    else if UpperCase(aClient.FilePath) = UpperCase(aClient.HomeDir) + FTPSCR_SERVERINFO then
    begin
        FFSYGlobals.ShowOnLog('@ Executando script ' + ExtractFileName(FTPSCR_SERVERINFO),RichEditLog);
        DeleteFile(aClient.HomeDir + FTPFIL_SERVERINFO);

        { Previne que os dados sejam enviados automaticamente, permitindo que o
        envio seja feito em OnRetrSessionConnected }
        aClient.DataStream := TMemoryStream.Create;

        { Criando o arquivo localmente }
        FFSYGlobals.SendStatus(aClient,'== SERVERINFO: Iniciando gera��o de conte�do... ===================================');
        FFSYGlobals.SendStatus(aClient,'-----------------------------------------------------------------------------------');
        with TServerInformation.Create(Self) do
            try
                MinimumClientVersion.Major := MINIMUM_CLIENT_MAJORVERSION;
                MinimumClientVersion.Minor := MINIMUM_CLIENT_MINORVERSION;
                MinimumClientVersion.Release := MINIMUM_CLIENT_RELEASE;
                MinimumClientVersion.Build := MINIMUM_CLIENT_BUILD;

                SaveToBinaryFile(aClient.HomeDir + FTPFIL_SERVERINFO);

                if FVerboseMode then
                begin
                    FFSYGlobals.SendStatus(aClient,'Vers�o do software servidor: ' + Version.FullVersionString);
                    FFSYGlobals.SendStatus(aClient,'Data e hora no servidor....: ' + FormatDateTime('dd/mm/yyyy hh:nn:ss',DateAndTime));
                    FFSYGlobals.SendStatus(aClient,'Cliente m�nimo aceit�vel...: ' + MinimumClientVersion.FullVersionString);
                end;
            finally
                Free
            end;

        FFSYGlobals.SendStatus(aClient,'-----------------------------------------------------------------------------------');
        FFSYGlobals.SendStatus(aClient,'SOC: ' + IntToStr(Trunc(FFSYGlobals.FileSize(aClient.HomeDir + FTPFIL_SERVERINFO))));
        FFSYGlobals.SendStatus(aClient,'== SERVERINFO: Conte�do gerado com sucesso ========================================');
    end
    { GET.SERVER_DELTA.DAT.PHPS: Este � o script mais importante. Ele cont�m
    tr�s partes. Na primeira SERVER_DELTA.DAT � gerado com as altera��es de
    outros clientes. Na segunda o script CLIENT_DELTA.DAT � executado de forma
    que no servidor sejam inseridas todas as altera��es feitas pelo cliente. Na
    terceira ser� juntado a SERVER_DELTA.DAT as altera��es que ocorreram ap�s a
    inser��o dos dados vindos do cliente
    -------------------------------------------------------------------------- }
    else if UpperCase(aClient.FilePath) = UpperCase(aClient.HomeDir) + FTPSCR_SERVER_DELTA then
        try
            FFSYGlobals.ShowOnLog('@ Executando script ' + ExtractFileName(FTPSCR_SERVER_DELTA),RichEditLog);
            DeleteFile(aClient.HomeDir + FTPFIL_SERVER_DELTA);
            aClient.DataStream := TMemoryStream.Create;

            { Gerando a primeira parte do Delta de retorno apenas com as
            altera��es de outros clientes }
            FFSYGlobals.SendStatus(aClient,'== SERVER_DELTA: Iniciando gera��o de conte�do... =================================');
            FFSYGlobals.SendStatus(aClient,'-----------------------------------------------------------------------------------');

            FFSYGlobals.GenerateDeltaFile(aClient
                                         ,aClient.DataBaseConnection
                                         ,aClient.HomeDir + FTPFIL_SERVER_DELTA
                                         ,RichEditLog
                                         ,FVerboseMode
                                         ,'DT_DATAEHORADAACAO > ' + FFSYGlobals.MySQLDateTimeFormat(FFSYGlobals.GetClientLastSyncDateAndTime(aClient)));


            { Carrega e executa o arquivo CLIENT_DELTA.DAT. Todas as inser��es
            s�o seguidas de atribui��es a vari�veis que devem conter o valor da
            chave automaticamente gerada ou zero caso n�o tenha sido poss�vel
            inserir por algum motivo }
            if FVerboseMode then
                FFSYGlobals.SendStatus(aClient,'Inserindo dados vindos do cliente...');

            { Descomprimindo caso necess�rio }
            if RetrSessionParameters.UseCompression then
                FFSYGlobals.DescomprimirArquivo(aClient.HomeDir + FTPFIL_CLIENT_DELTA
                                               ,RichEditLog
                                               ,DoZlibNotification);

            FFSYGlobals.LoadDeltaFile(aClient.HomeDir + FTPFIL_CLIENT_DELTA
                                     ,ClientDelta
                                     ,False);
            { TODO -oCARLOS FEITOZA -cMELHORIA : Use um evento aqui }
            FFSYGlobals.MySQLExecuteSQLScript(aClient.DataBaseConnection
                                             ,RichEditLog
                                             ,''
                                             ,ClientDelta.ToScript);

            { Ap�s executar corretamente o script que veio do cliente, n�s
            devemos apag�-lo, de forma que uma chamada subsequente ao script
            GET.SERVER_DELTA.DAT.PHPS n�o reinsira os dados no servidor }
            if FVerboseMode then
                FFSYGlobals.SendStatus(aClient,'Excluindo arquivo "' + FTPFIL_CLIENT_DELTA + '"');
            DeleteFile(aClient.HomeDir + FTPFIL_CLIENT_DELTA);

            { Agora � preciso processar ClientDelta de forma a completar
            ServerDelta com as informa��es que devem retornar ao cliente }
            FFSYGlobals.LoadDeltaFile(aClient.HomeDir + FTPFIL_SERVER_DELTA
                                     ,ServerDelta
                                     ,True);
            { TODO -oCARLOS FEITOZA -cMELHORIA : Use um evento aqui }
            FFSYGlobals.ProcessClientDeltaToServerDelta(aClient
                                                       ,aClient.DataBaseConnection
                                                       ,ClientDelta
                                                       ,ServerDelta
                                                       ,FVerboseMode);

            { Neste ponto j� temos SERVER_DELTA.DAT pronto para ser salvo como
            arquivo }

            { Criando o arquivo localmente }
            ServerDelta.SaveToBinaryFile(aClient.HomeDir + FTPFIL_SERVER_DELTA);

            { Comprimindo o arquivo caso necess�rio }
            if RetrSessionParameters.UseCompression then
                FSYGlobals.ComprimirArquivo(aClient.HomeDir + FTPFIL_SERVER_DELTA
                                           ,RichEditLog
                                           ,DoZlibNotification);

            FFSYGlobals.SendStatus(aClient,'-----------------------------------------------------------------------------------');
            FFSYGlobals.SendStatus(aClient,'SOC: ' + IntToStr(Trunc(FFSYGlobals.FileSize(aClient.HomeDir + FTPFIL_SERVER_DELTA))));
            FFSYGlobals.SendStatus(aClient,'== SERVER_DELTA: Conte�do gerado com sucesso ======================================');
        finally
            ClientDelta.Free;
            ServerDelta.Free;
        end
    { GET.SERVER_DATABASE.DAT.PHPS: Este script meramente faz uma c�pia do banco
    de dados local adaptado com a adi��o e/ou remo��o de tabelas e/ou registros
    e envia o script gerado para o cliente, de forma que, ao ser executado, o
    cliente tenha exatamente aquilo que h� no servidor. Este � o script usado na
    sincroniza��o completa
    -------------------------------------------------------------------------- }
    else if UpperCase(aClient.FilePath) = UpperCase(aClient.HomeDir) + FTPSCR_SERVER_DATABASE then
    begin
        FFSYGlobals.ShowOnLog('@ Executando script ' + ExtractFileName(FTPSCR_SERVER_DATABASE),RichEditLog);
        DeleteFile(aClient.HomeDir + FTPFIL_SERVER_DATABASE);
        aClient.DataStream := TMemoryStream.Create;

        { Gerando o conte�do a ser retornado ao cliente e salvando-o em
        arquivo comprimido, caso necess�rio }
        { TODO -oCARLOS FEITOZA -cMELHORIA : Use um evento aqui }
        FFSYGlobals.MySQLSmartSnapShot(aClient
                                      ,aClient.DataBaseConnection
                                      ,RetrSessionParameters.UseCompression
                                      ,RichEditLog
                                      ,FVerboseMode
                                      ,DoZlibNotification);
    end
    { DO.CONFIRMEVERYTHING.DAT.PHPS: A fun��o deste script � simplesmente
    informar que quando o cliente desconectar todas as altera��es devem ser
    confirmadas
    -------------------------------------------------------------------------- }
    else if UpperCase(aClient.FilePath) = UpperCase(aClient.HomeDir) + FTPSCR_CONFIRMEVERYTHING then
    begin
        FFSYGlobals.ShowOnLog('@ Executando script ' + ExtractFileName(FTPSCR_CONFIRMEVERYTHING),RichEditLog);
        DeleteFile(aClient.HomeDir + FTPFIL_CONFIRMEVERYTHING);
        aClient.DataStream := TMemoryStream.Create;

        if Assigned(aClient.DataBaseConnection) then
            aClient.DataBaseConnection.Tag := 0;

        { Gerando o conte�do a ser retornado ao cliente e salvando-o em
        arquivo }
        FFSYGlobals.SendStatus(aClient,'== CONFIRMEVERYTHING: Iniciando gera��o de conte�do... ============================');
        FFSYGlobals.SendStatus(aClient,'-----------------------------------------------------------------------------------');
        if FVerboseMode then
        begin
            FFSYGlobals.SendStatus(aClient,'Este arquivo � bin�rio e cont�m apenas um byte de valor zero, que indica que se');
            FFSYGlobals.SendStatus(aClient,'deve confirmar todas as opera��es no banco de dados quando a conex�o for encerrada');
        end;
        FFSYGlobals.SaveTextFile(Chr(aClient.DataBaseConnection.Tag),aClient.HomeDir + FTPFIL_CONFIRMEVERYTHING);

        FFSYGlobals.SendStatus(aClient,'-----------------------------------------------------------------------------------');
        FFSYGlobals.SendStatus(aClient,'SOC: ' + IntToStr(Trunc(FFSYGlobals.FileSize(aClient.HomeDir + FTPFIL_CONFIRMEVERYTHING))));
        FFSYGlobals.SendStatus(aClient,'== CONFIRMEVERYTHING: Conte�do gerado com sucesso =================================');
    end
    { GET.REMOTESNAPSHOT.DAT.PHPS: Este script cria uma c�pia completa do banco
    de dados do servidor, enviando-a ao cliente
    -------------------------------------------------------------------------- }
    else if UpperCase(aClient.FilePath) = UpperCase(aClient.HomeDir) + FTPSCR_REMOTESNAPSHOT then
    begin
        FFSYGlobals.ShowOnLog('@ Executando script ' + ExtractFileName(FTPSCR_REMOTESNAPSHOT),RichEditLog);
        DeleteFile(aClient.HomeDir + FTPFIL_REMOTESNAPSHOT);
        aClient.DataStream := TMemoryStream.Create;

        { Gerando o conte�do a ser retornado ao cliente e salvando-o em
        arquivo comprimido, caso necess�rio }
        { TODO -oCARLOS FEITOZA -cMELHORIA : Use um evento aqui }
        FFSYGlobals.MySQLFullSnapShot(aClient
                                     ,aClient.DataBaseConnection
                                     ,RetrSessionParameters.UseCompression
                                     ,RichEditLog
                                     ,FVerboseMode
                                     ,DoZlibNotification);
    end
    { GET.TEMPFILENAMES.DAT.PHPS: Este script obt�m os nomes dos arquivos
    tempor�rios salvos atualmente no servidor de forma que se possa, a partir do
    cliente, obt�-los com prop�sito depura��o.
    -------------------------------------------------------------------------- }
    else if UpperCase(aClient.FilePath) = UpperCase(aClient.HomeDir) + FTPSCR_TEMPFILENAMES then
    begin
        FFSYGlobals.ShowOnLog('@ Executando script ' + ExtractFileName(FTPSCR_TEMPFILENAMES),RichEditLog);
        DeleteFile(aClient.HomeDir + FTPFIL_TEMPFILENAMES);
        aClient.DataStream := TMemoryStream.Create;

        { Gerando o conte�do a ser retornado ao cliente }
        FFSYGlobals.SendStatus(aClient,'== TEMPFILENAMES: Iniciando gera��o de conte�do... ================================');
        FFSYGlobals.SendStatus(aClient,'-----------------------------------------------------------------------------------');

        TempStr := FFSYGlobals.GetTempFileNames(aClient.HomeDir);
        FFSYGlobals.SaveTextFile(TempStr,aClient.HomeDir + FTPFIL_TEMPFILENAMES);

        FFSYGlobals.SendStatus(aClient,'SOC: ' + IntToStr(Trunc(FFSYGlobals.FileSize(aClient.HomeDir + FTPFIL_TEMPFILENAMES))));
        FFSYGlobals.SendStatus(aClient,'-----------------------------------------------------------------------------------');
        FFSYGlobals.SendStatus(aClient,'== TEMPFILENAMES: Conte�do gerado com sucesso =====================================');
    end
    { TODO -oCARLOS FEITOZA -cEXPLICA��O : Daqui para baixo n�o alterei nada, continua original e vai dar pau se eu ativar DEVELOPING }
    { TESTES ================================================================= }
    { TESTE DE TIMEOUT }
    {$IFDEF DEVELOPING}
    else if UpperCase(Client.FilePath) = UpperCase(Client.HomeDir) + FTPSCR_TIMEOUTTEST then
        try
            FFSYGlobals.ShowOnLog('@ Executando script ' + ExtractFileName(FTPSCR_TIMEOUTTEST),RichEditLog);

            { Obtendo par�metros do teste }
            DataSize := RetrSessionParameters.CustIntParm;

            { Gerando o conte�do a ser retornado ao cliente e salvando-o em
            arquivo }
            FFSYGlobals.SendStatus(Client,'== TIMEOUTTEST: Iniciando gera��o de conte�do... ==================================');
            FFSYGlobals.SendStatus(Client,'TESTE DE TIMEOUT INICIADO: DELAY DE ' + IntToStr(DataSize) + 's');
            FFSYGlobals.SendStatus(Client,'-----------------------------------------------------------------------------------');
            FFSYGlobals.SendStatus(Client,'IN�CIO DA GERA��O: ' + FormatDateTime('dd/mm/yyyy hh:nn:ss',Now));
            FFSYGlobals.SendStatus(Client,'DELAY... (AGUARDE ' + IntToStr(DataSize) + 's)');
            FFSYGlobals.WaitFor(DataSize,False);
            FFSYGlobals.SendStatus(Client,'FIM DA GERA��O: ' + FormatDateTime('dd/mm/yyyy hh:nn:ss',Now));
            TempStr := 'NENHUM CONTE�DO FOI GERADO PARA O TESTE DE TIMEOUT';
            FFSYGlobals.SaveTextFile(TempStr,Client.HomeDir + FTPFIL_TIMEOUTTEST);
            DataSize := Trunc(FFSYGlobals.FileSize(Client.HomeDir + FTPFIL_TIMEOUTTEST));
            FFSYGlobals.SendStatus(Client,'-----------------------------------------------------------------------------------');
            FFSYGlobals.SendStatus(Client,'SOC: ' + IntToStr(DataSize));
            FFSYGlobals.SendStatus(Client,'== TIMEOUTTEST: Conte�do gerado com sucesso =======================================');

            { Reinicializando o stream de envio }
            CreateSendStream(Client,FFSYGlobals.LoadTextFile(Client.HomeDir + FTPFIL_TIMEOUTTEST)[1],DataSize);
//                Client.UserData := 1;
//                if Assigned(Client.DataStream) then
//                    Client.DataStream.Destroy;
//
//                Client.DataStream := TMemoryStream.Create;
//                Client.DataStream.Write(TempStr[1],DataSize);
//                Client.DataStream.Seek(0,0);
        except
            on E: Exception do
                AbortEverything(Client as TConnectedClient,E.Message);
        end
    { TESTE DE TAMANHO DE CONTEUDO }
    else if UpperCase(Client.FilePath) = UpperCase(Client.HomeDir) + FTPSCR_CONTENTSIZETEST then
        try
            FFSYGlobals.ShowOnLog('@ Executando script ' + ExtractFileName(FTPSCR_CONTENTSIZETEST),RichEditLog);

            { Obtendo par�metros do teste }
            DataSize := RetrSessionParameters.CustIntParm;

            { Gerando o conte�do a ser retornado ao cliente }
            FFSYGlobals.SendStatus(Client,'== CONTENTSIZETEST: Iniciando gera��o de conte�do... ==============================');
            FFSYGlobals.SendStatus(Client,'TESTE DE TAMANHO DE CONTE�DO INICIADO: CONTE�DO DE TAMANHO = ' + IntToStr(DataSize) + ' Bytes');
            FFSYGlobals.SendStatus(Client,'-----------------------------------------------------------------------------------');
            FFSYGlobals.SendStatus(Client,'IN�CIO DA GERA��O: ' + FormatDateTime('dd/mm/yyyy hh:nn:ss',Now));
            FFSYGlobals.SendStatus(Client,'GERANDO CONTE�DO ALEAT�RIO...');
            TempStr := FFSYGlobals.GenerateRandomText(DataSize);
            FFSYGlobals.SaveTextFile(TempStr,Client.HomeDir + FTPFIL_CONTENTSIZETEST);
            FFSYGlobals.SendStatus(Client,'FIM DA GERA��O: ' + FormatDateTime('dd/mm/yyyy hh:nn:ss',Now));
            FFSYGlobals.SendStatus(Client,'-----------------------------------------------------------------------------------');
            FFSYGlobals.SendStatus(Client,'SOC: ' + IntToStr(DataSize));
            FFSYGlobals.SendStatus(Client,'== CONTENTSIZETEST: Conte�do gerado com sucesso ===================================');

            { Reinicializando o stream de envio }
            CreateSendStream(Client,TempStr[1],DataSize);
//                Client.UserData := 1;
//                if Assigned(Client.DataStream) then
//                    Client.DataStream.Destroy;
//
//                Client.DataStream := TMemoryStream.Create;
//                Client.DataStream.Write(TempStr[1],DataSize);
//                Client.DataStream.Seek(0,0);
        except
            on E: Exception do
                AbortEverything(Client as TConnectedClient,E.Message);
        end
    {$ENDIF}
    { ==================================================================== }
    { A configura��o abaixo permite criar arquivos virtuais, ou respostas em forma
    de arquivos. Ao mudar para o diret�rio "C:\VIRTUAL\" deve ser criado um stream
    de mem�ria com um conte�do que pode ser qualquer coisa!  }
    else if Copy(UpperCase(aClient.FilePath), 1, 11) = 'C:\VIRTUAL\' then
    begin
        FFSYGlobals.ShowOnLog('� VIRTUAL FILE',RichEditLog);

        aClient.UserData   := 1;        { Remember we created a stream }
        if Assigned(aClient.DataStream) then
            aClient.DataStream.Destroy; { Prevent memory leaks         }

        aClient.DataStream := TMemoryStream.Create;
        TempStr := 'This is a file created on the fly by the FTP server' + #13#10 +
         'It could result of a query to a database or anything else.' + #13#10 +
         'The request was: ''' + aClient.FilePath + '''' + #13#10;
         aClient.DataStream.Write(TempStr[1], Length(TempStr));
         aClient.DataStream.Seek(0, 0);
    end;
    { Outro exemplo...}
    { A configura��o a seguir permite limitar o acesso a um determinado diret�rio }
    // else if MatchesMask(Client.FilePath, '*\VIRTUAL\FORBIDEN*') then
        // raise Exception.Create('Access prohibed !')
  except
        on E: Exception do
            AbortEverything(aClient,E.Message);
  end;
end;

{ TODO -oCARLOS FEITOZA -cEXPLICA��O : Este evento � lan�ado imediatamente antes
do envio de um arquivo solicitado e serve para processar tal arquivo, gerando-o,
comprimindo-o etc. }
procedure TFSSForm_Main.DoGetProcessing;
begin
  ProcessRequest(TConnectedClient(Client));
end;

{ TODO -oCARLOS FEITOZA -cEXPLICA��O : Este evento � lan�ado no momento do envio
dos arquivos requisitados. Tais arquivos foram criados, processados ou comprimidos
no evento OnGetProcessing }
procedure TFSSForm_Main.DoRetrSessionConnected;

procedure CreateSendStream(aClient: TFtpCtrlSocket; const aBuffer; aDataSize: Cardinal);
begin
    aClient.UserData := 1;
    if Assigned(aClient.DataStream) then
        aClient.DataStream.Destroy;

    aClient.DataStream := TMemoryStream.Create;
    aClient.DataStream.Write(aBuffer,aDataSize);
    aClient.DataStream.Seek(0,0);
end;

begin
  	if AError <> 0 then
  		FFSYGlobals.ShowOnLog('! ' + Client.GetPeerAddr + ' Sess�o de dados iniciada. Erro #' + IntToStr(AError),RichEditLog)
  	else
  		FFSYGlobals.ShowOnLog('� ' + Client.GetPeerAddr + ' Sess�o de dados iniciada sem erros!',RichEditLog);

    { Enviando arquivos gerados na etapa de processamento (GetProcessing) }
	if AError = 0 then
        if UpperCase(Client.FilePath) = UpperCase(Client.HomeDir) + FTPSCR_DBCHECKSUM then
        begin
            CreateSendStream(Client
                            ,FFSYGlobals.LoadTextFile(Client.HomeDir + FTPFIL_DBCHECKSUM)[1]
                            ,Trunc(FFSYGlobals.FileSize(Client.HomeDir + FTPFIL_DBCHECKSUM)));
        end
        else if UpperCase(Client.FilePath) = UpperCase(Client.HomeDir) + FTPSCR_SERVERINFO then
        begin
            CreateSendStream(Client
                            ,FFSYGlobals.LoadTextFile(Client.HomeDir + FTPFIL_SERVERINFO)[1]
                            ,Trunc(FFSYGlobals.FileSize(Client.HomeDir + FTPFIL_SERVERINFO)));
        end
        else if UpperCase(Client.FilePath) = UpperCase(Client.HomeDir) + FTPSCR_SERVER_DELTA then
        begin
            CreateSendStream(Client
                            ,FFSYGlobals.LoadTextFile(Client.HomeDir + FTPFIL_SERVER_DELTA)[1]
                            ,Trunc(FFSYGlobals.FileSize(Client.HomeDir + FTPFIL_SERVER_DELTA)));
        end
        else if UpperCase(Client.FilePath) = UpperCase(Client.HomeDir) + FTPSCR_SERVER_DATABASE then
        begin
            CreateSendStream(Client
                            ,FFSYGlobals.LoadTextFile(Client.HomeDir + FTPFIL_SERVER_DATABASE)[1]
                            ,Trunc(FFSYGlobals.FileSize(Client.HomeDir + FTPFIL_SERVER_DATABASE)));
        end
        else if UpperCase(Client.FilePath) = UpperCase(Client.HomeDir) + FTPSCR_CONFIRMEVERYTHING then
        begin
            CreateSendStream(Client
                            ,FFSYGlobals.LoadTextFile(Client.HomeDir + FTPFIL_CONFIRMEVERYTHING)[1]
                            ,Trunc(FFSYGlobals.FileSize(Client.HomeDir + FTPFIL_CONFIRMEVERYTHING)));
        end
        else if UpperCase(Client.FilePath) = UpperCase(Client.HomeDir) + FTPSCR_REMOTESNAPSHOT then
        begin
            CreateSendStream(Client
                            ,FFSYGlobals.LoadTextFile(Client.HomeDir + FTPFIL_REMOTESNAPSHOT)[1]
                            ,Trunc(FFSYGlobals.FileSize(Client.HomeDir + FTPFIL_REMOTESNAPSHOT)));
        end
        else if UpperCase(Client.FilePath) = UpperCase(Client.HomeDir) + FTPSCR_TEMPFILENAMES then
        begin
            CreateSendStream(Client
                            ,FFSYGlobals.LoadTextFile(Client.HomeDir + FTPFIL_TEMPFILENAMES)[1]
                            ,Trunc(FFSYGlobals.FileSize(Client.HomeDir + FTPFIL_TEMPFILENAMES)));
        end;
end;

procedure TFSSForm_Main.DoStorSessionClosed(Sender: TObject; Client: TFtpCtrlSocket; Data: TWSocket; AError: Word);
begin
    if AError <> 0 then
		FFSYGlobals.ShowOnLog('! ' + Client.GetPeerAddr + ' Sess�o de dados finalizada de forma incorreta. Erro #' + IntToStr(AError),RichEditLog)
    else
  	    FFSYGlobals.ShowOnLog('� ' + Client.GetPeerAddr + ' Sess�o de dados finalizada sem erros!',RichEditLog);
end;

procedure TFSSForm_Main.DoStorSessionConnected(Sender: TObject; Client: TFtpCtrlSocket; Data: TWSocket; AError: Word);
begin
    if AError <> 0 then
  	    FFSYGlobals.ShowOnLog('! ' + Client.GetPeerAddr + ' N�o foi poss�vel iniciar a sess�o de dados. Erro #' + IntToStr(AError),RichEditLog)
    else
        FFSYGlobals.ShowOnLog('� ' + Client.GetPeerAddr + ' A sess�o de dados foi iniciada sem erros!',RichEditLog);
end;

procedure TFSSForm_Main.FormDestroy(Sender: TObject);
begin
	FFSYGlobals.Free;
end;

procedure TFSSForm_Main.ActionConfiguracoesExecute(Sender: TObject);
begin
	Application.CreateForm(TFSSForm_Configurations,FSSForm_Configurations);
  	FSSForm_Configurations.ShowModal;
end;

procedure TFSSForm_Main.DoValidateGet;
begin
	{ Pode colocar qualquer coisa abaixo de home directory }
	Allowed := Pos(Client.HomeDir,FilePath) = 1;
end;

procedure TFSSForm_Main.DoValidatePut;
begin
	{ Pode pegar qualquer coisa abaixo de home directory }
	Allowed := Pos(Client.HomeDir,FilePath) = 1;
end;

procedure TFSSForm_Main.DoChangeDirectory;
begin
	{ Pode mudar para qualquer subdiret�rio dentro de home directory }
	Allowed := Pos(Client.HomeDir,Directory) = 1;
end;

procedure TFSSForm_Main.DoMakeDirectory;
begin
	{ Pode criar qualquer diret�rio abaixo de home directory }
	Allowed := Pos(Client.HomeDir,Directory) = 1;
end;

procedure TFSSForm_Main.DoValidateDele;
begin
	{ Pode apagar qualquer coisa abaixo de home directory }
	Allowed := Pos(Client.HomeDir,FilePath) = 1;
end;

procedure TFSSForm_Main.DoValidateSize;
begin
	{ Pode obter o tamanho de qualuqer arquivo abaixo de home directory }
	Allowed := Pos(Client.HomeDir,FilePath) = 1;
end;

procedure TFSSForm_Main.DoValidateRmd;
begin
	{ Pode apagar qualquer diret�rio abaixo de Home directory }
	Allowed := Pos(Client.HomeDir,FilePath) = 1;
end;

procedure TFSSForm_Main.DoValidateRnFr;
begin
	{ Pode renomear qualquer arquivo abaixo de Home directory }
	Allowed := Pos(Client.HomeDir,FilePath) = 1;
end;

procedure TFSSForm_Main.DoValidateRnTo;
begin
	{ Pode renomear para qualquer nome qualquer arquivo abaixo de Home directory }
	Allowed := Pos(Client.HomeDir,FilePath) = 1;
end;

procedure TFSSForm_Main.DoCalculateMd5;
begin

//	showmessage('calculando md5');
end;

procedure TFSSForm_Main.Button2Click(Sender: TObject);
begin
    if SaveDialog1.Execute then
    begin
	    RichEditLog.Lines.SaveToFile(SaveDialog1.FileName);
    	FFSYGlobals.ShowOnLog('� Log salvo em ' + FormatDateTime('dd.mm.yyyy "�s" hh.nn.ss',Now),RichEditLog);
    end;
end;

procedure TFSSForm_Main.Timer1Timer(Sender: TObject);
begin
	SalvarLog;
end;

procedure TFSSForm_Main.SalvarLog;
var
	DataEHora: String;
begin
	if not DirectoryExists(FFSYGlobals.CurrentDir + 'logs') then
  	CreateDir(FFSYGlobals.CurrentDir + 'logs');

  DataEHora := FormatDateTime('dd.mm.yyyy "�s" hh.nn.ss',Now);
  RichEditLog.Lines.SaveToFile(FFSYGlobals.CurrentDir + 'logs\' + DataEHora + '.rtf');
end;

procedure TFSSForm_Main.FormCloseQuery(Sender: TObject; var CanClose: Boolean);
begin
	{ Se for poss�vel desativar o servidor, tamb�m ser� poss�vel fechar a aplica��o }
	CanClose := Desativar;
end;

procedure TFSSForm_Main.ActionSobreExecute(Sender: TObject);
begin
	Application.CreateForm(TFSSForm_Splash,FSSForm_Splash);
  	FSSForm_Splash.ShowModal;
end;

(*
const
    msgDftBanner      = '220 - ICS FTP Server ready.';
    msgTooMuchClients = '421 - Muitos usu�rios conectados.';
    msgCmdUnknown     = '500 - "%s": comando desconhecido.';
    msgLoginFailed    = '530 - Login incorreto.';
    msgNotLogged      = '530 - Por favor fa�a login com USER e PASS.';
    msgNoUser         = '503 - Login com USER primeiro.';
    msgLogged         = '230 - O usu�rio %s foi autenticado.';
    msgPassRequired   = '331 - Senha requerida para %s.';
    msgCWDSuccess     = '250 - Comando CWD executado com sucesso. "%s" � o diret�rio atual.';
    msgCWDFailed      = '501 - O comando CWD falhou. %s.';
    msgPWDSuccess     = '257 - "%s" � o diret�rio atual.';
    msgQuit           = '221 - Adeus.';
    msgPortSuccess    = '200 - Comando PORT executado com sucesso.';
    msgPortFailed     = '501 - Comando PORT inv�lido.';

    msgStorDisabled   = '500 - Permiss�o negada para STOR.'; {'500 Cannot STOR.';}
    msgStorSuccess    = '150 - Abrindo conex�o de dados para %s.';
    msgStorFailed     = '501 - N�o foi poss�vel enviar o arquivo (STOR). %s.';
    msgStorAborted    = '426 - Conex�o fechada. %s.';
    msgStorOk         = '226 - Arquivo recebido com sucesso.';
    msgStorError      = '426 - Conex�o fechada. Transfer�ncia cancelada. Error #%d.';

    msgRetrDisabled   = '500 - N�o foi poss�vel receber (RETR). O comando RETR est� desabilitado';
    msgRetrSuccess    = '150 - Abrindo conex�o de dados para %s.';
    msgRetrFailed     = '501 - N�o foi poss�vel obter o arquivo (RETR). %s.';
    msgRetrAborted    = '426 - Conex�o fechada. %s.';
    msgRetrOk         = '226 - Arquivo enviado com sucesso.';
    msgRetrError      = '426 - Conex�o fechada. Transfer�ncia cancelada. Error #%d.';
    
    msgSystem         = '215 - UNIX Type: L8 Internet Component Suite';

    msgDirOpen        = '150 - Abrindo conex�o de dados para listagem de diret�rio.';
    msgDirFailed      = '451 - Falhou: %s.';

    msgTypeOk         = '200 - Tipo configurado para %s.';
    msgTypeFailed     = '500 - "TYPE %s": comando desconhecido.';

    msgDeleNotExists  = '550 "%s": no such file or directory.';
    msgDeleOk         = '250 File "%s" deleted.';
    msgDeleFailed     = '450 File "%s" can''t be deleted.';
    msgDeleSyntax     = '501 Syntax error in parameter.';
    msgDeleDisabled   = '550 Cannot delete.';

    msgRnfrNotExists  = '550 ''%s'': no such file or directory.';
    msgRnfrSyntax     = '501 Syntax error is parameter.';
    msgRnfrOk         = '350 File exists, ready for destination name.';
    msgRnFrDisabled   = '500 Cannot RNFR.';

    msgRntoNotExists  = '550 ''%s'': no such file or directory.';
    msgRntoAlready    = '553 ''%s'': file already exists.';
    msgRntoOk         = '250 File ''%s'' renamed to ''%s''.';
    msgRntoFailed     = '450 File ''%s'' can''t be renamed.';
    msgRntoSyntax     = '501 Syntax error in parameter.';
    msgRnToDisabled   = '500 Cannot RNTO.';

    msgMkdOk          = '257 ''%s'': directory created.';
    msgMkdAlready     = '550 ''%s'': file or directory already exists.';
    msgMkdFailed      = '550 ''%s'': can''t create directory.';
    msgMkdSyntax      = '501 Syntax error in parameter.';

    msgRmdOk          = '250 ''%s'': directory removed.';
    msgRmdNotExists   = '550 ''%s'': no such directory.';
    msgRmdFailed      = '550 ''%s'': can''t remove directory.';
    msgRmdDisabled    = '500 Cannot remove directory.';
    msgRmdSyntax      = '501 Syntax error in parameter.';

    msgNoopOk         = '200 Ok. Parameter was ''%s''.';
    msgAborOk         = '225 ABOR command successful.';

    msgPasvLocal      = '227 Entering Passive Mode (127,0,0,1,%d,%d).';
    msgPasvRemote     = '227 Entering Passive Mode (%d,%d,%d,%d,%d,%d).';
    msgPasvExcept     = '500 PASV exception: ''%s''.';

    msgSizeOk         = '213 - %d';
    msgSizeDisabled   = '502 - Comando n�o implementado ou desabilitado.';
    msgSizeFailed     = '550 - O comando falhou: %s.';
    msgSizeSyntax     = '501 - Erro de sintaxe no par�metro.';

    msgRestOk         = '350 - REST suportado. Pronto para resumir a partir do byte de offset %d.';
    msgRestZero       = '501 - O byte de offset (requerido como par�metro) � incorreto ou est� faltando.';
    msgRestFailed     = '501 - Erro de sintaxe no par�metro: %s.';

    msgAppeFailed     = '550 APPE failed.';
    msgAppeSuccess    = '150 Opening data connection for %s (append).';
    msgAppeDisabled   = '500 Cannot APPE.';
    msgAppeAborted    = '426 Connection closed; %s.';
    msgAppeOk         = '226 File received ok';
    msgAppeError      = '426 Connection closed; transfer aborted. Error #%d';
    msgAppeReady      = '150 APPE supported.  Ready to append file "%s" at offset %d.';

    msgStruOk         = '200 Ok. STRU parameter ''%s'' ignored.';
    msgMdtmOk         = '213 - %s';
    msgMdtmFailed     = '550 %s';
    msgMdtmSyntax     = '501 Syntax error in MDTM/MFMT parameter.';
    msgMdtmNotExists  = '550 ''%s'': no such file or directory.';

    msgModeOK         = '200 MODE Ok';
    msgModeSyntax     = '501 Missing argument for MODE';
    msgModeNotS       = '502 MODE other than S not supported';

    msgOverflow       = '500 - Comando muito extenso.';
    msgStouOk         = '250 - "%s": arquivo criado.';
    msgStouSuccess    = msgStorSuccess;
    msgStouFailed     = '501 Cannot STOU. %s';
    msgStouAborted    = msgStorAborted;
    msgStouError      = msgStorError;

    msgFeatFollows    = '211�- Extens�es suportadas - inicio';
    msgFeatFollowDone = '211 - Extens�es suportadas - fim';
    msgFeatFailed     = '211 - Sem extens�es';

    msgMdtmChangeOK   = '253 Date/time changed OK';                  { angus V1.38 }
    msgMfmtChangeOK   = '213 Date/time changed OK';                  { angus V1.39 }
    msgMdtmChangeFail = '550 MDTM/MFMT cannot change date/time on this server';  { angus V1.38 }
    msgCWDNoDir       = '550 - O comando CWD falhou ao mudar o diret�rio para %s.';  { angus V1.38 }
    msgMlstFollows    = '250 - Listando:';                              { angus V1.38 }
    msgMlstFollowDone = '250 - FIM';                                   { angus V1.38 }
    msgMlstNotExists  = '550 - "%s": diret�rio ou arquivo inexistente.';    { angus V1.38 }
    msgMd5NotFound    = '550 - "%s": arquivo inexistente.';                 { angus V1.39 }
    msgMd5Failed      = '550 - A checagem MD5 SUM falhou: "%s".';              { angus V1.39 }
    msgMd5Ok          = '251 - "%s" %s';                               { angus V1.39 }

procedure TFtpServer.CommandFEAT(
    Client      : TFtpCtrlSocket;
    var Keyword : TFtpString;
    var Params  : TFtpString;
    var Answer  : TFtpString);
const
	EXTENSIONS =
  #13#10'211�-   SIZE'#13#10 +
  '211�-   REST STREAM'#13#10 + { angus V1.39 (been supported for years) }
  '211�-   MDTM'#13#10 +
  '211�-   MDTM YYYYMMDDHHMMSS[+-TZ] filename'#13#10 +  { angus V1.38 }
  '211�-   MLST size*;type*;perm*;create*;modify*;'#13#10 + { angus V1.39 }
  '211�-   MFMT'#13#10 + { angus V1.39 }
  '211�-   MD5'#13#10; { angus V1.38 }
begin
    if Client.FtpState <> ftpcReady then begin
        Answer := msgNotLogged;
        Exit;
    end;

    try
        Client.CurCmdType := ftpcFEAT;
        Answer := msgFeatFollows + EXTENSIONS + msgFeatFollowDone;
    except
        on E:Exception do begin
            Answer := Format(msgFeatFailed, [E.Message]);
        end;
    end;
end;


procedure TCustomFtpCli.ExtractMoreResults;
var
    NumericCode : LongInt;
    p           : PChar;
    S           : String;
begin
    if FRequestResult = 0 then begin
        if FFctPrv in [ftpFctSize] then begin
            p := GetInteger(@FLastResponse[1], NumericCode);
            GetInteger(p, FSizeResult);
        end;
        if FFctPrv in [ftpFctMdtm] then begin  { V2.90 get file modification time }
            p := GetInteger(@FLastResponse[1], NumericCode);
            if NumericCode = 213 then begin
               GetNextString (p, S);        { V2.94 }
               FRemFileDT := MDTM2Date(S);  { UTC time }
            end
            else
                FRemFileDT := -1;
        end;
        if FFctPrv in [ftpFctCDup, ftpFctPwd, ftpFctMkd, ftpFctCwd] then begin
            p := GetInteger(@FLastResponse[1], NumericCode);
            GetQuotedString(p, FDirResult);
        end;
        if FFctPrv in [ftpFctMd5] then begin  { V2.94 get MD5 hash sum }
            FDirResult := '';
            FMd5Result := '';
            p := GetInteger(@FLastResponse[1], NumericCode);
            if NumericCode = 251 then
            begin
	            p := GetNextString(p, FDirResult); // Retira "-" da string
              p := GetQuotedString(p, FDirResult);
              if FDirResult = '' then
                p := GetNextString(p, FDirResult);
              GetNextString(p, FMd5Result);
            end;
        end;
    end;
end;

*)

end.



