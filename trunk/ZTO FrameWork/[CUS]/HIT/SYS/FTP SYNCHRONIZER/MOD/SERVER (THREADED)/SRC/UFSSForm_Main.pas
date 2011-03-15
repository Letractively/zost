unit UFSSForm_Main;
{ Esta é a unit principal do programa. Ela contém os métodos usados no
formulário principal (§[link FPrincipal]). E outros usados pelo servidor FTP }

interface
                                                           
uses
    Windows, Messages, Variants, Classes, Graphics, Controls, Forms,
    Dialogs, StdCtrls, XPStyleActnCtrls, ActnList, ActnMan,
    ToolWin, ActnCtrls, ActnMenus, ComCtrls, XPMan, ExtCtrls, FtpSrv, FtpSrvC,
    WSocket, WSocketS, Winsock, ZConnection, ZDataSet, UFSYGlobals, UXXXTypesConstantsAndClasses, 
    SysUtils;

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
        FtpRoot: ShortString;
        FFSYGlobals: TFSYGlobals;
        procedure Ativar;
        function Desativar: Boolean;
        procedure UpdateClientCount;
        function UsuarioAutenticado(Usuario, Senha: ShortString; ClienteConectado: TFtpCtrlSocket): Boolean;
        function UsuarioRoboAutenticado(Usuario, Senha: ShortString; ClienteConectado: TFtpCtrlSocket; var DecodedUser: ShortString): Boolean;
        procedure ClearDirectory(Directory: String);
        procedure AbortEverything(ConnectedClient: TConnectedClient; ErrorMessage: String);
        {$IFDEF THREADED}
        procedure DoTerminate(Sender: TObject);
        {$ENDIF}
    public
        procedure SalvarLog;
        property FSYGlobals: TFSYGlobals read FFSYGlobals;
    end;

var
    FSSForm_Main: TFSSForm_Main;

implementation

uses
	UFSSForm_Configurations, DB, ZDbcIntfs, UFSSForm_Splash,
  	UFSYTypesConstantsAndClasses, UFSYSyncStructures, UObjectFile;

{$R *.dfm}

procedure TFSSForm_Main.Button1Click(Sender: TObject);
begin
	SalvarLog;
    RichEditLog.Clear;
    FFSYGlobals.ShowOnLog('§ Log salvo e limpo em ' + FormatDateTime('dd.mm.yyyy "às" hh.nn.ss',Now),RichEditLog);
end;

{Este procedure ativa o servidor na porta selecionada nas configurações
(§[linkUnit UConfiguracoes])}
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
        FFSYGlobals.ShowOnLog('  ' + Trim(WSocket.CopyRight),RichEditLog);
        FFSYGlobals.ShowOnLog('  ' + Trim(FtpSrv.CopyRight),RichEditLog);
        FFSYGlobals.ShowOnLog('  Informações sobre o Winsock...',RichEditLog);
        FFSYGlobals.ShowOnLog('    Versão .....: ' + Format('%d.%d', [WSI.wHighVersion shr 8,WSI.wHighVersion and 15]),RichEditLog);
        FFSYGlobals.ShowOnLog('    Descrição ..: ' + StrPas(@WSI.szDescription),RichEditLog);
        FFSYGlobals.ShowOnLog('    Status .....: ' + StrPas(@WSI.szSystemStatus),RichEditLog);

        if Assigned(WSI.lpVendorInfo) then
            FFSYGlobals.ShowOnLog('    ' + StrPas(@WSI.lpVendorInfo),RichEditLog);

        Self.Tag := 1;
    end;

    FTPServer.Port := IntToStr(FFSYGlobals.Configurations.FT_PortNumb);
    FTPServer.Addr := '0.0.0.0';
    FTPServer.ClientClass := TConnectedClient;
    FTPServer.Start;
end;

{Este procedure desativo o servidor fazendo exatamente o contrário que o
procedure §[link Ativar]}
function TFSSForm_Main.Desativar;
begin
    Result := False;
    if FTPServer.ClientCount > 0 then
        MessageBox(Handle,'Ainda existem clientes conectados, não é possível desativar o servidor. Aguarde até que todos os clientes tenham se desconectado para poder desativar o servidor','Operação pendente detectada',MB_ICONWARNING)
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
  	Caption := 'FTP Syncronizer - Edição exclusiva para ' + FTPSYNC_CUSTOMCLIENT;

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
    { TODO : só permita desativação se não houver ninguem conectado }
end;

{Este procedure atualiza um label que contém a quantidade de clientes conectados
no momento}
procedure TFSSForm_Main.UpdateClientCount;
begin
    if FTPServer.Active then
    begin
        if FTPServer.ClientCount = 0 then
        begin
            ClientCountLabel.Caption := 'Nenhum usuário no momento';
            GreenImage.Visible := True;
            RedImage.Visible   := False;
        end
    else
    begin
        ClientCountLabel.Caption := IntToStr(FTPServer.ClientCount) + ' usuário(s) conectado(s)';
        GreenImage.Visible := False;
        RedImage.Visible   := True;
    end
    end
    else
        ClientCountLabel.Caption := 'O FTP Synchronizer econtra-se desativado e não pode responder a requisições';

    Application.ProcessMessages;
end;
{ TODO -oCARLOS FEITOZA -cEXPLICAÇÃO : Ainda não sei se as explicações abaixo
estão certas. Ainda não sei se poderei usar threades sem comprometer a sincronização }
procedure TFSSForm_Main.DoGetProcessing;
{$IFDEF THREADED}
var
    ConnectedClient: TConnectedClient;
{$ENDIF}
begin
    {$IFDEF THREADED}
	{ Este  evento é executado sempre que um cliente usa GET e pode ser usado
    para executar inúmeras linhas de execução para cada download de cliente.
    Desta forama não haverá bloqueio de uso quando vários usuários estiverem
    conectados }
    ConnectedClient := TConnectedClient(Client);

	{ Se o cliente requerer um arquivo específico (*.PHPS), então uma nova
    Thread será criada, garantindo que cada usuário pegue a cópia do arquivo
    simultaneamente.  Neste caso a thread simplesmente espera 10 segundos
    (veja o método resume) e ao terminar envia os dados }
    if UpperCase(ExtractFileExt(ConnectedClient.FileName)) = '.PHPS' then
    begin
        ConnectedClient.WorkerThread := TGetProcessingThread.Create(True);
        ConnectedClient.WorkerThread.FreeOnTerminate := True;
        ConnectedClient.WorkerThread.OnTerminate := DoTerminate;

        ConnectedClient.WorkerThread.Server := TFtpServer(Sender);
        ConnectedClient.WorkerThread.Client := ConnectedClient;

        ConnectedClient.WorkerThread.FSSForm_Main := Self;

        ConnectedClient.WorkerThread.Resume;
        { Informa ao servidor para não enviar automaticamente. Isto será feito
        mais adiante, no evento WorkerThreadTerminated. Isto é usado apenas com
        threads, eu creio }
        DelayedSend := True;
    end;
  {$ENDIF}
end;

{$IFDEF THREADED}
procedure TFSSForm_Main.DoTerminate(Sender: TObject);
begin
    { Quando a thread termina com sucesso de sua operação, manda os dados
    manualmente. DoStartSendData lança o evento OnRetrSessionConnected, que é
    manipulado pelo método DoRetrSessionConnected }
    TGetProcessingThread(Sender).Server.DoStartSendData(TGetProcessingThread(Sender).Client);
end;

{ TGetProcessingThread }
procedure TGetProcessingThread.SetLogMessage(const aValue: String);
begin
    FLogMessage := aValue;
    Synchronize(ShowOnLog);
end;

procedure TGetProcessingThread.ShowOnLog;
begin
    FFSSForm_Main.FSYGlobals.ShowOnLog(FLogMessage,FFSSForm_Main.RichEditLog);
end;

procedure TGetProcessingThread.SetStatusMessage(const aValue: String);
begin
    FStatusMessage := aValue;
    Synchronize(SendStatus);
end;

procedure TGetProcessingThread.SendStatus;
begin
    if FVerboseMode then
        FFSSForm_Main.FSYGlobals.SendStatus(FClient,FStatusMessage);
end;

procedure TGetProcessingThread.SetAbortMessage(const aValue: String);
begin
    FAbortMessage := aValue;
    Synchronize(AbortEveryThing);
end;

procedure TGetProcessingThread.AbortEveryThing;
begin
    FFSSForm_Main.AbortEverything(FClient,FAbortMessage);
end;

procedure TGetProcessingThread.DoGetChecksum(      aTableName: ShortString;
                                                   aTableNo
                                                 , aTableCount: Word;
                                                   aTableChecksum: ShortString;
                                             const aIgnored: Boolean);
begin
    if not aIgnored then
        StatusMessage := 'Tabela: "' + aTableName + '" (' + IntToStr(aTableNo) + '/' + IntToStr(aTableCount) + ') | MD5: ' + aTableChecksum
    else
        StatusMessage := 'Tabela: "' + aTableName + '" (' + IntToStr(aTableNo) + '/' + IntToStr(aTableCount) + ') | IGNORADA...';
end;

procedure TGetProcessingThread.DoZlibNotification(aNotificatioType: TZlibNotificationType; aOperation: TZLibOperation; aInputFile, aOutputFile: TFileName);
begin
    if aOperation = zloDecompress then
        case aNotificatioType of
            zlntBeforeProcess: LogMessage := '§ Descomprimindo arquivo de dados ' + ExtractFileName(aInputFile) + '...';
            zlntAfterProcess: LogMessage := '§ Descompressão concluída!';
        end
    else if aOperation = zloCompress then
        case aNotificatioType of
            zlntBeforeProcess: LogMessage := '§ Comprimindo arquivo de dados ' + ExtractFileName(aInputFile) + '...';

            zlntAfterProcess: LogMessage := '§ Compressão concluída!';
        end;
end;

procedure TGetProcessingThread.Execute;
{ ---------------------------------------------------------------------------- }
procedure ReadParameters(out aRetrSessionParameters: TRetrSessionParameters);
var
    f: file of TRetrSessionParameters;
begin
    ZeroMemory(@aRetrSessionParameters,SizeOf(TRetrSessionParameters));

    if FileExists(FClient.HomeDir + FTPFIL_PARAMETERS) then
        try
            AssignFile(f,FClient.HomeDir + FTPFIL_PARAMETERS);
            FileMode := fmOpenRead;
            Reset(f);
            Read(f,aRetrSessionParameters);
        finally
            CloseFile(f);
        end;
end;

procedure CreateSendStream(aClient: TFtpCtrlSocket; const aBuffer; aDataSize: Cardinal);
begin
    aClient.UserData := 1;
    if Assigned(aClient.DataStream) then
        aClient.DataStream.Destroy;

    aClient.DataStream := TMemoryStream.Create;
    aClient.DataStream.Write(aBuffer,aDataSize);
    aClient.DataStream.Seek(0,0);
end;
{ ---------------------------------------------------------------------------- }
var
    RetrSessionParameters: TRetrSessionParameters;
    TempStr: String;
    DataSize: Cardinal;
    ClientDelta, ServerDelta: TSynchronizationFile;
begin
    inherited;
    ReadParameters(RetrSessionParameters);

   	// Podem ser scripts mesmo em PHP! PHPS = PHP Script. Quando forem scripts
    // de verdade deverá acessar os scripts que estão localizados em
    // FTPROOT\SCRIPTS
    try
        { GET.DBCHECKSUM.MD5.PHPS: Este script obtém todas as tabelas do banco
        de dados, depois circula por todas elas, gerando o checksum que é
        retornado ao cliente
        ---------------------------------------------------------------------- }
        if UpperCase(FClient.FilePath) = UpperCase(FClient.HomeDir) + FTPSCR_DBCHECKSUM then
        begin
            LogMessage := '@ Executando script ' + ExtractFileName(FTPSCR_DBCHECKSUM);
            DeleteFile(FClient.HomeDir + FTPFIL_DBCHECKSUM);

            FVerboseMode := True;
            { TODO -oCARLOS FEITOZA -cDÚVIDA : Acho que não seria necessário
            sincronizar o método sendstatus, pois ele envia dados para nosso
            proprio cliente em nosso proprio espaço de memoria }
            StatusMessage := '== DBCHECKSUM: Iniciando geração de conteúdo... ===================================';
            StatusMessage := '-----------------------------------------------------------------------------------';

            { Criando o arquivo localmente }
            FVerboseMode := RetrSessionParameters.VerboseMode;
            TempStr := FFSSForm_Main.FSYGlobals.DatabaseCheckSum(FClient.DataBaseConnection,FClient.HomeDir,DoGetChecksum);
            FFSSForm_Main.FSYGlobals.SaveTextFile(TempStr,FClient.HomeDir + FTPFIL_DBCHECKSUM);
            DataSize := Trunc(FFSSForm_Main.FSYGlobals.FileSize(Client.HomeDir + FTPFIL_DBCHECKSUM));

            FVerboseMode := True;
            StatusMessage := 'DATABASE CHECKSUM (MD5): ' + TempStr;
            StatusMessage := '-----------------------------------------------------------------------------------';
            StatusMessage := 'SOC: ' + IntToStr(DataSize);
        	StatusMessage := '== DBCHECKSUM: Conteúdo gerado com sucesso ========================================';

            { Reinicializando o stream de envio }
            CreateSendStream(FClient,FFSSForm_Main.FSYGlobals.LoadTextFile(FClient.HomeDir + FTPFIL_DBCHECKSUM)[1],DataSize);
        end
        { GET.SERVERINFO.DAT.PHPS: Este script obtém algumas informações sobre o
        servidor
        ---------------------------------------------------------------------- }
        else if UpperCase(FClient.FilePath) = UpperCase(FClient.HomeDir) + FTPSCR_SERVERINFO then
        begin
            LogMessage := '@ Executando script ' + ExtractFileName(FTPSCR_SERVERINFO);
            DeleteFile(FClient.HomeDir + FTPFIL_SERVERINFO);

            FVerboseMode := True;

            { Criando o arquivo localmente }
            StatusMessage := '== SERVERINFO: Iniciando geração de conteúdo... ===================================';
            StatusMessage := '-----------------------------------------------------------------------------------';

            FVerboseMode := RetrSessionParameters.VerboseMode;

            with TServerInformation.Create(nil) do
                try
                    MinimumClientVersion.Major := MINIMUM_CLIENT_MAJORVERSION;
                    MinimumClientVersion.Minor := MINIMUM_CLIENT_MINORVERSION;
                    MinimumClientVersion.Release := MINIMUM_CLIENT_RELEASE;
                    MinimumClientVersion.Build := MINIMUM_CLIENT_BUILD;

                    SaveToBinaryFile(Client.HomeDir + FTPFIL_SERVERINFO);
                    StatusMessage := 'Versão do software servidor: ' + Version.FullVersionString;
                    StatusMessage := 'Data e hora no servidor....: ' + FormatDateTime('dd/mm/yyyy hh:nn:ss',DateAndTime);
                    StatusMessage := 'Cliente mínimo aceitável...: ' + MinimumClientVersion.FullVersionString;
                finally
                    Free
                end;

            FVerboseMode := True;

            DataSize := Trunc(FFSSForm_Main.FSYGlobals.FileSize(Client.HomeDir + FTPFIL_SERVERINFO));
            StatusMessage := '-----------------------------------------------------------------------------------';
            StatusMessage := 'SOC: ' + IntToStr(DataSize);
            StatusMessage := '== SERVERINFO: Conteúdo gerado com sucesso ========================================';

            { Reinicializando o stream de envio }
            CreateSendStream(FClient,FFSSForm_Main.FSYGlobals.LoadTextFile(FClient.HomeDir + FTPFIL_SERVERINFO)[1],DataSize);
        end
        { GET.SERVER_DELTA.DAT.PHPS: Este é o script mais importante. Ele contém
        três partes principais. Na primeira o script SERVER_DELTA.DAT é criado
        com as alterações de outros usuários. Na segunda os script
        CLIENT_DELTA.DAT é executado e na terceira o script SERVER_DELTA.DAT é
        completado com as informações que precisam retornar ao cliente após a
        execução de CLIENT_DELTA.DAT
        ---------------------------------------------------------------------- }
        else if UpperCase(FClient.FilePath) = UpperCase(FClient.HomeDir) + FTPSCR_SERVER_DELTA then
        	try
                LogMessage := '@ Executando script ' + ExtractFileName(FTPSCR_SERVER_DELTA);
                DeleteFile(FClient.HomeDir + FTPFIL_SERVER_DELTA);

                { Gerando a primeira parte do Delta de retorno apenas com as
                alterações de outros clientes. Isso é exatamente o mesmo que
                o script GET.NEWACTIONS.PHPS faz }
                FVerboseMode := True;

                StatusMessage := '== SERVER_DELTA: Iniciando geração de conteúdo... =================================';
                StatusMessage := '-----------------------------------------------------------------------------------';

                FVerboseMode := RetrSessionParameters.VerboseMode;
                { TODO -oCARLOS FEITOZA -cCUIDADO! : Existem duas chamadas não
                protegidas dentro deste procedure uma para ShowOnLog e outra
                para SendStatus. No futuro será melhor colocar isso como um
                evento tal como foi feito pela função de retorno de checksum }
                FFSSForm_Main.FSYGlobals.GenerateDeltaFile(FClient
                                                          ,FClient.DataBaseConnection
                                                          ,FClient.HomeDir + FTPFIL_SERVER_DELTA
                                                          ,FFSSForm_Main.RichEditLog
                                                          ,FVerboseMode
                                                          ,'DT_DATAEHORADAACAO > ' + FFSSForm_Main.FSYGlobals.MySQLDateTimeFormat(FFSSForm_Main.FSYGlobals.GetClientLastSyncDateAndTime(FClient)));

                { Carrega e executa o arquivo CLIENT_DELTA.DAT. Todas as
                inserções são seguidas de atribuições a variáveis que devem
                conter o valor da chave automaticamente gerada ou zero caso
                não tenha sido possível inserir por algum motivo }
                StatusMessage := 'Inserindo dados vindos do cliente...';

                { Descomprimindo caso necessário }
                if RetrSessionParameters.UseCompression then
                    FFSSForm_Main.FSYGlobals.DescomprimirArquivo(FClient.HomeDir + FTPFIL_CLIENT_DELTA
                                                                ,FFSSForm_Main.RichEditLog
                                                                ,DoZlibNotification);

                FFSSForm_Main.FSYGlobals.LoadDeltaFile(FClient.HomeDir + FTPFIL_CLIENT_DELTA,ClientDelta,False);
                { TODO -oCARLOS FEITOZA -cCUIDADO! : Existem duas chamadas não
                protegidas dentro deste procedure. Ambas para ShowOnLog. No
                futuro será melhor colocar isso como um evento tal como foi
                feito pela função de retorno de checksum }
                FFSSForm_Main.FSYGlobals.MySQLExecuteSQLScript(FClient.DataBaseConnection
                                                              ,FFSSForm_Main.RichEditLog
                                                              ,''
                                                              ,ClientDelta.ToScript);

                { Após executar corretamente o script que veio do cliente, nós
                devemos apagá-lo, de forma que uma chamada subsequente ao script
                GET.SERVER_DELTA.DAT.PHPS não reinsira os dados no servidor }
                StatusMessage := 'Excluindo arquivo "' + FTPFIL_CLIENT_DELTA + '"';
                DeleteFile(FClient.HomeDir + FTPFIL_CLIENT_DELTA);

                { Agora é preciso processar ClientDelta de forma a completar
                ServerDelta com as informações que devem retornar ao cliente }
                FFSSForm_Main.FSYGlobals.LoadDeltaFile(FClient.HomeDir + FTPFIL_SERVER_DELTA,ServerDelta,True);
                { TODO -oCARLOS FEITOZA -cCUIDADO! : Existe uma chamada não
                protegida dentro deste procedure: SendStatus. No futuro será
                melhor colocar isso como um evento tal como foi feito pela
                função de retorno de checksum }
                FFSSForm_Main.FSYGlobals.ProcessClientDeltaToServerDelta(FClient
                                                                        ,FClient.DataBaseConnection
                                                                        ,ClientDelta
                                                                        ,ServerDelta
                                                                        ,FVerboseMode);

                { Neste ponto já temos SERVER_DELTA.DAT pronto para ser
                salvo como arquivo }

                { Criando o arquivo localmente }
                ServerDelta.SaveToBinaryFile(FClient.HomeDir + FTPFIL_SERVER_DELTA);

                { Comprimindo o arquivo caso necessário }
                if RetrSessionParameters.UseCompression then
                    FFSSForm_Main.FSYGlobals.ComprimirArquivo(FClient.HomeDir + FTPFIL_SERVER_DELTA
                                                             ,FFSSForm_Main.RichEditLog
                                                             ,DoZlibNotification);

                FVerboseMode := True;

                DataSize := Trunc(FFSSForm_Main.FSYGlobals.FileSize(FClient.HomeDir + FTPFIL_SERVER_DELTA));
                StatusMessage := '-----------------------------------------------------------------------------------';
                StatusMessage := 'SOC: ' + IntToStr(DataSize);
                StatusMessage := '== SERVER_DELTA: Conteúdo gerado com sucesso ======================================';

                { Preparando o stream de envio }
                CreateSendStream(FClient,FFSSForm_Main.FSYGlobals.LoadTextFile(FClient.HomeDir + FTPFIL_SERVER_DELTA)[1],DataSize);
            finally
                ClientDelta.Free;
                ServerDelta.Free;
            end
        { GET.SERVER_DATABASE.DAT.PHPS: Este script meramente faz uma cópia do
        banco de dados local adaptado com a adição e/ou remoção de tabelas e/ou
        registros e envia o script gerado para o cliente, de forma que, ao ser
        executado, o cliente tenha exatamente aquilo que há no servidor. Esse
        script é o que é usado na sincronização completa!
        ---------------------------------------------------------------------- }
        else if UpperCase(FClient.FilePath) = UpperCase(FClient.HomeDir) + FTPSCR_SERVER_DATABASE then
        begin
            LogMessage := '@ Executando script ' + ExtractFileName(FTPSCR_SERVER_DATABASE);
            DeleteFile(FClient.HomeDir + FTPFIL_SERVER_DATABASE);

            FVerboseMode := RetrSessionParameters.VerboseMode;

            { Gerando o conteúdo a ser retornado ao cliente e salvando-o em
            arquivo comprimido, caso necessário }
            { TODO -oCARLOS FEITOZA -cCUIDADO! : Existem 23 chamadas não
            protegidas dentro deste procedure. Todas para SendStatus. No
            futuro será melhor colocar isso como um evento tal como foi
            feito pela função de retorno de checksum. Aparentemente já
            existe uma função em xxxdatamodule que possui uma implementação
            com uso de eventos. Unifique as duas }
            FFSSForm_Main.FSYGlobals.MySQLSmartSnapShot(FClient
                                                       ,FClient.DataBaseConnection
                                                       ,RetrSessionParameters.UseCompression
                                                       ,FFSSForm_Main.RichEditLog
                                                       ,FVerboseMode
                                                       ,DoZlibNotification);

            DataSize := Trunc(FFSSForm_Main.FSYGlobals.FileSize(FClient.HomeDir + FTPFIL_SERVER_DATABASE));

            { Preparando o stream de envio }
            CreateSendStream(FClient,FFSSForm_Main.FSYGlobals.LoadTextFile(FClient.HomeDir + FTPFIL_SERVER_DATABASE)[1],DataSize);
        end
        { DO.CONFIRMEVERYTHING.DAT.PHPS: A função deste script é simplesmente
        informar que quando o cliente desconectar todas as alterações devem ser
        confirmadas no banco de dados
        ---------------------------------------------------------------------- }
        else if UpperCase(FClient.FilePath) = UpperCase(FClient.HomeDir) + FTPSCR_CONFIRMEVERYTHING then
        begin
      		LogMessage := '@ Executando script ' + ExtractFileName(FTPSCR_CONFIRMEVERYTHING);
		   	DeleteFile(FClient.HomeDir + FTPFIL_CONFIRMEVERYTHING);

            if Assigned(FClient.DataBaseConnection) then
	            FClient.DataBaseConnection.Tag := 0;

            FVerboseMode := True;

            { Gerando o conteúdo a ser retornado ao cliente e salvando-o em
            arquivo }
            StatusMessage := '== CONFIRMEVERYTHING: Iniciando geração de conteúdo... ============================';
            StatusMessage := '-----------------------------------------------------------------------------------';

            FVerboseMode := RetrSessionParameters.VerboseMode;

            StatusMessage := 'Este arquivo é binário e contém apenas um byte de valor zero, que indica que se';
            StatusMessage := 'deve confirmar todas as operações no banco de dados quando a conexão for encerrada';

            FFSSForm_Main.FSYGlobals.SaveTextFile(Chr(FClient.DataBaseConnection.Tag),FClient.HomeDir + FTPFIL_CONFIRMEVERYTHING);
            DataSize := Trunc(FFSSForm_Main.FSYGlobals.FileSize(FClient.HomeDir + FTPFIL_CONFIRMEVERYTHING));

            FVerboseMode := True;

            StatusMessage := '-----------------------------------------------------------------------------------';
            StatusMessage := 'SOC: ' + IntToStr(DataSize);
            StatusMessage := '== CONFIRMEVERYTHING: Conteúdo gerado com sucesso =================================';

			{ Preparando o stream de envio }
            CreateSendStream(FClient
                            ,FFSSForm_Main.FSYGlobals.LoadTextFile(FClient.HomeDir + FTPFIL_CONFIRMEVERYTHING)[1]
                            ,DataSize);
    	end
        { GET.REMOTESNAPSHOT.DAT.PHPS: Este script cria uma cópia completa do
        banco de dados do servidor, enviando-a ao cliente
        ---------------------------------------------------------------------- }
        else if UpperCase(FClient.FilePath) = UpperCase(FClient.HomeDir) + FTPSCR_REMOTESNAPSHOT then
        begin
            LogMessage := '@ Executando script ' + ExtractFileName(FTPSCR_REMOTESNAPSHOT);
            DeleteFile(FClient.HomeDir + FTPFIL_REMOTESNAPSHOT);

            { Gerando o conteúdo a ser retornado ao cliente e salvando-o em
            arquivo comprimido, caso necessário }
            { TODO -oCARLOS FEITOZA -cCUIDADO! : Existem 21 chamadas não
            protegidas dentro deste procedure. Todas para SendStatus. No
            futuro será melhor colocar isso como um evento tal como foi
            feito pela função de retorno de checksum. Aparentemente já
            existe uma função em xxxdatamodule que possui uma implementação
            com uso de eventos. Unifique as duas }
            FFSSForm_Main.FSYGlobals.MySQLFullSnapShot(FClient
                                                      ,FClient.DataBaseConnection
                                                      ,RetrSessionParameters.UseCompression
                                                      ,FFSSForm_Main.RichEditLog
                                                      ,RetrSessionParameters.VerboseMode
                                                      ,DoZlibNotification);

            DataSize := Trunc(FFSSForm_Main.FSYGlobals.FileSize(FClient.HomeDir + FTPFIL_REMOTESNAPSHOT));

            { Reinicializando o stream de envio }
            CreateSendStream(FClient,FFSSForm_Main.FSYGlobals.LoadTextFile(FClient.HomeDir + FTPFIL_REMOTESNAPSHOT)[1],DataSize);
        end
        { GET.TEMPFILENAMES.DAT.PHPS: Este script obtém os nomes dos arquivos
        temporários salvos atualmente no servidor de forma que se possa, a
        partir do cliente, obtê-los com propósito depuração. Este script não usa
        verificação MD5, por isso nenhum arquivo local será salvo para ele. Todo
        conteúdo será gerado dinamicamente
        ---------------------------------------------------------------------- }
        else if UpperCase(FClient.FilePath) = UpperCase(FClient.HomeDir) + FTPSCR_TEMPFILENAMES then
        begin
            LogMessage := '@ Executando script ' + ExtractFileName(FTPSCR_TEMPFILENAMES);

            FVerboseMode := True;

            { Gerando o conteúdo a ser retornado ao cliente }
            StatusMessage := '== TEMPFILENAMES: Iniciando geração de conteúdo... ================================';
            StatusMessage := '-----------------------------------------------------------------------------------';

            TempStr := FFSSForm_Main.FSYGlobals.GetTempFileNames(FClient.HomeDir);
            DataSize := Length(TempStr);
            StatusMessage := 'SOC: ' + IntToStr(DataSize);
            StatusMessage := '-----------------------------------------------------------------------------------';
            StatusMessage := '== TEMPFILENAMES: Conteúdo gerado com sucesso =====================================';

            { Reinicializando o stream de envio }
            { TODO -oCarlos Feitoza -cEXPLICAÇÃO : Como não há verificação
            de MD5 aqui, não é preciso criar um arquivo físico }
            CreateSendStream(FClient,TempStr[1],DataSize);
        end
    except
        on E: Exception do
            AbortMessage := E.Message;
    end;
end;
{$ENDIF}

{Este evento é lançado quando o servidor se inicia
§param Sender Diz respeito ao componente ao qual este evento está associado, no caso, ao componente FTPClient}
procedure TFSSForm_Main.DoStart;
begin
	GreenImage.Visible := True;
  	RedImage.Visible := False;
  	FFSYGlobals.ShowOnLog('§ Servidor ativado na porta ' + IntToStr(FFSYGlobals.Configurations.FT_PortNumb),RichEditLog);
  	FFSYGlobals.ShowOnLog('-----------------------------------------------------------------------------------------------',RichEditLog);
  	UpdateClientCount;
end;

{Este evento é lançado quando o servidor é parado
§param Sender Diz respeito ao componente ao qual este evento está associado, no caso, ao componente FTPClient}
procedure TFSSForm_Main.DoStop;
begin
	GreenImage.Visible := False;
  	RedImage.Visible   := True;
  	FFSYGlobals.ShowOnLog('§ Servidor desativado',RichEditLog);
  	FFSYGlobals.ShowOnLog('-----------------------------------------------------------------------------------------------',RichEditLog);
  	UpdateClientCount;
end;

{Este evento é lançado quando o servidor recebe um comando do cliente
§param Sender Diz respeito ao componente ao qual este evento está associado, no caso, ao componente FTPClient
§param Client Este parâmetro é um ponteiro para um tipo §[link TConnectedClient] que representa o cliente que está desconectando
§param Keyword Este parâmetro contém o nome do comando recebido
§param Params Este parâmetro variável contém os parâmetros que foram enviados juntamente com o comando e podem ser alterados aqui
§param Answer Este parâmetro contém a resposta a ser enviada para o cliente}
procedure TFSSForm_Main.DoClientCommand;
begin
	FFSYGlobals.ShowOnLog('COMANDO:> ' + Keyword + ' ' + Params + ' (' + Client.GetPeerAddr + ')',RichEditLog);
end;

{Este evento é lançado quando o servidor manda uma resposta ao cliente
§param Sender Diz respeito ao componente ao qual este evento está associado, no caso, ao componente FTPClient
§param Client Este parâmetro é um ponteiro para um tipo §[link TConnectedClient] que representa o cliente que está desconectando
§param Answer Este parâmetro variável contém a resposta a ser enviada para o cliente e pode ser alterao aqui}
procedure TFSSForm_Main.DoAnswerToClient;
begin
	FFSYGlobals.ShowOnLog('RETORNO:> ' + Answer + ' (' + Client.GetPeerAddr + ')',RichEditLog);
end;

{Este procedure limpa o diretório passado como parâmetro, removendo todos os
arquivos e diretórios contidos no mesmo
§param Directory Diretório a ser esvaziado}
procedure TFSSForm_Main.ClearDirectory;
	{Procedures e funções locais}
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
          MessageBox(Handle,'A quantidade de arquivos localizados excede o limite de recursos do seu sistema. Favor limitar seu critério de busca escolhendo diretório(s) de nível mais interno.','Recursos do sitema esgotados',MB_ICONERROR);
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

{Este manipulador de evento é executado sempre que um cliente se conecta ao
servidor.
§param Sender Diz respeito ao componente ao qual este evento está associado, no caso, ao componente FTPClient
§param Client Este parâmetro é um ponteiro para um tipo §[link TConnectedClient] que representa o cliente conectado
§param AError Este parâmetro contém um código de erro. Se for zero indica que não houve erro. Se for maior que zero houve um erro}
procedure TFSSForm_Main.DoClientConnect;
begin
	{ O cliente iniciou o processo de conexão. Aqui  podem ser feitas verificações
  	que limitam o acesso. Tente usar uma mascara e compare com o IP }
  	if Client.GetPeerAddr = '193.121.12.25' then
  	begin
		Client.SendAnswer('421 - Conexão não permitida.');
    	Client.Close;
    	Exit;
	end;

	FFSYGlobals.ShowOnLog('§ O cliente ' + Client.GetPeerAddr + '/' + Client.GetPeerPort + ' acabou de conectar-se',RichEditLog);

    UpdateClientCount;

  	Client.HomeDir := '';
  	Client.Directory := FtpRoot;
end;

{ Este manipulador de evento é executado sempre que um cliente se desconecta do
servidor.
§param Sender Diz respeito ao componente ao qual este evento está associado, no caso, ao componente FTPClient
§param Client Este parâmetro é um ponteiro para um tipo §[link TConnectedClient] que representa o cliente que está desconectando
§param AError Este parâmetro contém um código de erro. Se for zero indica que não houve erro. Se for maior que zero houve um erro}
procedure TFSSForm_Main.DoClientDisconnect;
begin
	FFSYGlobals.ShowOnLog('§ Cliente (' + Client.GetPeerAddr + ') desconectado',RichEditLog);
    UpdateClientCount;
	{ Se uma conexão com o banco foi estabelecida então devemos destruí-la }
	if Assigned((Client as TConnectedClient).DataBaseConnection) then
        with (Client as TConnectedClient) do
        begin
            if DataBaseConnection.Connected then
            begin
            	{ Se há algum transação ativa deveremos confirmar ou descartar as alterações feitas }
                if DataBaseConnection.InTransaction then
                	{ Se o flag de erro estiver habilitado então executa um rollback... }
                    if DataBaseConnection.Tag <> 0 then
                    begin
                    	FFSYGlobals.ShowOnLog('§ Revertendo banco de dados a seu estado pré-sincronização...',RichEditLog);
                        DataBaseConnection.Rollback;
                    end
                    { ...do contrário commit }
                    else
                    begin
                    	FFSYGlobals.ShowOnLog('§ Confirmando alterações realizadas no banco de dados...',RichEditLog);
                        DataBaseConnection.Commit;
                    end;

                Application.ProcessMessages;
                { FOI REMOVIDA POIS SEU USO CAUSA ERROS DE SINCRONIZAÇÃO A LONGO
                PRAZO }
                { Só realiza desfragmentação caso o não haja mais nenhum cliente conectado }
//                if FTPServer.ClientCount = 0 then
//                begin
//    				FFSYGlobals.ShowOnLog('§ Desfragmentando tabelas. Favor aguardar...',RichEditLog);
//                    Application.ProcessMessages;
//                    FFSYGlobals.MySQLDefragDatabase(DataBaseConnection);
//                    FFSYGlobals.ShowOnLog('§ Desfragmentação concluída',RichEditLog);
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
    DecodedPass: ShortString;
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
                    Description := 'Usuário-Robô de conexão automática avançada';
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
{Este evento é lançado quando o servidor tenta autenticar o cliente com seu login e sua senha
§param Sender Diz respeito ao componente ao qual este evento está associado, no caso, ao componente FTPClient
§param Client Este parâmetro é um ponteiro para um tipo §[link TConnectedClient] que representa o cliente que está desconectando
§param UserName Este parâmetro contém o nome de usuário que o cliente passou com o comando USER
§param Password Este parâmetro contém a senha que o cliente passou com o comando PASS
§param Authenticated Este parâmetro variável pode ser alterado para refletir o status pos autenticação. Se ele receber true, o usuário está autenticado}
procedure TFSSForm_Main.DoAuthenticate;
var
  	StrTemp: ShortString;
  	HoraAtual: Byte;
    ClientConnectedIP: ShortString;
begin
	{ If you need to store info about the client for later processing }
  	{ you can use Client.UserData to store a pointer to an object or  }
  	{ a record with the needed info.                                  }
  	Authenticated := False;
  	try
		if UsuarioAutenticado(UserName,Password,Client) then
    	begin
        	{ Criando conexão com o banco e mantendo-a atrelada ao usuário }
  			FFSYGlobals.ShowOnLog('§ Iniciando conexão transacional com o banco de dados...',RichEditLog);
//            (Client as TConnectedClient).DataBaseConnection := nil; já é limpo no create de TConnectedCliente
            FFSYGlobals.ConfigureConnection((Client as TConnectedClient).DataBaseConnection);

            { Configura outros parâmetros }
            if (Client as TConnectedClient).DataBaseConnection.Connected then
            begin
                (Client as TConnectedClient).DataBaseConnection.Tag := 1; { Condição pessimista: assume sempre que deve fazer rollback }
	            (Client as TConnectedClient).DataBaseConnection.AutoCommit := True;
                (Client as TConnectedClient).DataBaseConnection.StartTransaction;
                FFSYGlobals.MySQLSetVariable((Client as TConnectedClient).DataBaseConnection,'SQL_QUOTE_SHOW_CREATE',0);
                FFSYGlobals.MySQLSetDBUserVariable((Client as TConnectedClient).DataBaseConnection,'SYNCHRONIZING',True);
                FFSYGlobals.MySQLSetDBUserVariable((Client as TConnectedClient).DataBaseConnection,'SERVERSIDE',True);
                FFSYGlobals.MySQLSetDBUserVariable((Client as TConnectedClient).DataBaseConnection,'ADJUSTINGDB',False);
                FFSYGlobals.ExecuteQuery((Client as TConnectedClient).DataBaseConnection,'CREATE TEMPORARY TABLE IF NOT EXISTS ORPHANFIELDS (MI_ORDEM MEDIUMINT)');
            end;

            { Os nomes dos diretórios serão o IPs das pessoas que conectam }
            (Client as TConnectedClient).IP := Client.GetPeerAddr;
            ClientConnectedIP := (Client as TConnectedClient).IP + '#' + IntToStr(Client.ID);

            if not DirectoryExists(FtpRoot + ClientConnectedIP) then
            begin
                if CreateDir(FtpRoot + ClientConnectedIP) then
                    Client.HomeDir := FtpRoot + ClientConnectedIP + '\';
            end
            else
            begin
                ClearDirectory(FtpRoot + ClientConnectedIP);
                Client.HomeDir := FtpRoot + ClientConnectedIP + '\';
            end;

            HoraAtual := StrToInt(FormatDateTime('hh',Now));

            if HoraAtual < 12 then
                StrTemp := 'Bom dia'
            else if HoraAtual < 18 then
                StrTemp := 'Boa tarde'
            else
                StrTemp := 'Boa noite';

            Authenticated := True;
            FFSYGlobals.ShowOnLog('§ O usuário "' + UserName + '@' + ClientConnectedIP + '" foi autenticado',RichEditLog);
            Client.SendAnswer(Format(FTPSYNC_CLIENT_AUTHENTICATED,[StrTemp,(Client as TConnectedClient).RealName]));
		end
    	{ Conexões cujo usuário começa com "Robot" são temporárias. São conexões
        automáticas para depuração e utilização avançada }
        else if UsuarioRoboAutenticado(UserName,Password,Client,StrTemp) then
        begin
			if not (Pos('RobotNoDB',UserName) = 1) then
            begin
            	{ Criando conexão com o banco e mantendo-a atrelada ao usuário }
                FFSYGlobals.ShowOnLog('§ Iniciando conexão transacional com o banco de dados...',RichEditLog);
//                (Client as TConnectedClient).DataBaseConnection := nil; já é limpo no create de tconnectedclient
                FFSYGlobals.ConfigureConnection((Client as TConnectedClient).DataBaseConnection);
                { Configura outros parâmetros }
                if (Client as TConnectedClient).DataBaseConnection.Connected then
                begin
                    (Client as TConnectedClient).DataBaseConnection.Tag := 1; { Condição pessimista: assume sempre que deve fazer rollback }
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

            if DirectoryExists(FtpRoot + StrTemp + '\' + ClientConnectedIP) then
	            Client.HomeDir := FtpRoot + StrTemp + '\' + ClientConnectedIP + '\'
            else
            	raise Exception.Create('O usuário "' + StrTemp + '" ao qual este usuário-robô se refere, não possui um diretório no servidor. Talvez o usuário "' + StrTemp + '" ainda não tenha feito nenhuma sincronização. Por isso não é possível usar seu usuário-robô.');

            HoraAtual := StrToInt(FormatDateTime('hh',Now));

            if HoraAtual < 12 then
                StrTemp := 'Bom dia'
            else if HoraAtual < 18 then
                StrTemp := 'Boa tarde'
            else
                StrTemp := 'Boa noite';

            Authenticated := True;
            FFSYGlobals.ShowOnLog('§ O usuário-robô "' + UserName + '@' + ClientConnectedIP + '" foi autenticado',RichEditLog);
            Client.SendAnswer(Format(FTPSYNC_CLIENT_AUTHENTICATED,[StrTemp,(Client as TConnectedClient).RealName]));
        end;
    except
    	on E: Exception do
        	AbortEverything(Client as TConnectedClient,E.Message);
    end;
end;

{Este evento é lançado quando o buffer de dados é enviado ao cliente depois de
um comando GET
§param Sender Diz respeito ao componente ao qual este evento está associado, no caso, ao componente FTPClient
§param Client Este parâmetro é um ponteiro para um tipo §[link TConnectedClient] que representa o cliente que está desconectando
§param Data Este parâmetro é um ponteiro para um tipo TWSocket e contém informações sobre o pedaço de dados sendo enviado
§param AError Este parâmetro contém um código de erro que se for maior que zero, indica um erro}
procedure TFSSForm_Main.DoRetrDataSent;
begin
	if AError <> 0 then
  		FFSYGlobals.ShowOnLog('! ' + Client.GetPeerAddr + ' Dados não enviados. Erro #' + IntToStr(AError),RichEditLog);
  { TODO :
No futuro coloque uma barra de progresso multipropósito. Aqui ela cresce de acordo com a quantidade de dados
enviados ao cliente. }
end;

{Este evento é lançado quando a sessão de dados é finalizada
§param Sender Diz respeito ao componente ao qual este evento está associado, no caso, ao componente FTPClient
§param Client Este parâmetro é um ponteiro para um tipo §[link TConnectedClient] que representa o cliente que está desconectando
§param Data Este parâmetro é um ponteiro para um tipo TWSocket e contém informações sobre o pedaço de dados sendo enviado
§param AError Este parâmetro contém um código de erro que se for maior que zero, indica um erro}
procedure TFSSForm_Main.DoRetrSessionClosed;
begin
    if AError <> 0 then
        FFSYGlobals.ShowOnLog('! ' + Client.GetPeerAddr + ' Sessão de dados finalizada. Erro #' + IntToStr(AError),RichEditLog)
    else
        FFSYGlobals.ShowOnLog('§ ' + Client.GetPeerAddr + ' Sessão de dados finalizada sem erros!',RichEditLog);

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

{Este procedimento é executado sempre que algo de errado (não previsto) ocorre.
Ele grava uma mensagem no log e a envia para o cliente, que posteriormente é
desconectado
§param ConnectedClient Cliente que tentou executar a ação que falhou
§param ErrorMessage Mensagem de erro a ser informada}
procedure TFSSForm_Main.AbortEverything;
begin
    { Enviando uma mensagem para o cliente de forma que este desfaça tudo que foi
    feito antes de desconectar }
    ConnectedClient.SendAnswer('666 - ' + ErrorMessage);
    FFSYGlobals.ShowOnLog('! ' + ErrorMessage,RichEditLog);
    ConnectedClient.Close;
end;

{Este evento é lançado quando a sessão de dados é inicializada. É neste evento
onde há chamadas de script que realizam a maioria das ações suportadas pelo
servidor
§param Sender Diz respeito ao componente ao qual este evento está associado, no caso, ao componente FTPClient
§param Client Este parâmetro é um ponteiro para um tipo §[link TConnectedClient] que representa o cliente que está desconectando
§param Data Este parâmetro é um ponteiro para um tipo TWSocket e contém informações sobre o pedaço de dados sendo enviado
§param AError Este parâmetro contém um código de erro que se for maior que zero, indica um erro}
procedure TFSSForm_Main.DoRetrSessionConnected;
begin
  	if AError <> 0 then
  		FFSYGlobals.ShowOnLog('! ' + Client.GetPeerAddr + ' Sessão de dados iniciada. Erro #' + IntToStr(AError),RichEditLog)
  	else
  		FFSYGlobals.ShowOnLog('§ ' + Client.GetPeerAddr + ' Sessão de dados iniciada sem erros!',RichEditLog);
end;

procedure TFSSForm_Main.DoStorSessionClosed(Sender: TObject; Client: TFtpCtrlSocket; Data: TWSocket; AError: Word);
begin
    if AError <> 0 then
        FFSYGlobals.ShowOnLog('! ' + Client.GetPeerAddr + ' Sessão de dados finalizada de forma incorreta. Erro #' + IntToStr(AError),RichEditLog)
    else
  	    FFSYGlobals.ShowOnLog('§ ' + Client.GetPeerAddr + ' Sessão de dados finalizada sem erros!',RichEditLog);
end;

procedure TFSSForm_Main.DoStorSessionConnected(Sender: TObject; Client: TFtpCtrlSocket; Data: TWSocket; AError: Word);
begin
    if AError <> 0 then
  	    FFSYGlobals.ShowOnLog('! ' + Client.GetPeerAddr + ' Não foi possível iniciar a sessão de dados. Erro #' + IntToStr(AError),RichEditLog)
    else
        FFSYGlobals.ShowOnLog('§ ' + Client.GetPeerAddr + ' A sessão de dados foi iniciada sem erros!',RichEditLog);
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
	{ Pode mudar para qualquer subdiretório dentro de home directory }
	Allowed := Pos(Client.HomeDir,Directory) = 1;
end;

procedure TFSSForm_Main.DoMakeDirectory;
begin
	{ Pode criar qualquer diretório abaixo de home directory }
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
	{ Pode apagar qualquer diretório abaixo de Home directory }
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
    	FFSYGlobals.ShowOnLog('§ Log salvo em ' + FormatDateTime('dd.mm.yyyy "às" hh.nn.ss',Now),RichEditLog);
    end;
end;

procedure TFSSForm_Main.Timer1Timer(Sender: TObject);
begin
	SalvarLog;
end;

procedure TFSSForm_Main.SalvarLog;
var
	DataEHora: ShortString;
begin
	if not DirectoryExists(FFSYGlobals.CurrentDir + 'logs') then
  	CreateDir(FFSYGlobals.CurrentDir + 'logs');

  DataEHora := FormatDateTime('dd.mm.yyyy "às" hh.nn.ss',Now);
  RichEditLog.Lines.SaveToFile(FFSYGlobals.CurrentDir + 'logs\' + DataEHora + '.rtf');
end;

procedure TFSSForm_Main.FormCloseQuery(Sender: TObject; var CanClose: Boolean);
begin
	{ Se for possível desativar o servidor, também será possível fechar a aplicação }
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
    msgTooMuchClients = '421 - Muitos usuários conectados.';
    msgCmdUnknown     = '500 - "%s": comando desconhecido.';
    msgLoginFailed    = '530 - Login incorreto.';
    msgNotLogged      = '530 - Por favor faça login com USER e PASS.';
    msgNoUser         = '503 - Login com USER primeiro.';
    msgLogged         = '230 - O usuário %s foi autenticado.';
    msgPassRequired   = '331 - Senha requerida para %s.';
    msgCWDSuccess     = '250 - Comando CWD executado com sucesso. "%s" é o diretório atual.';
    msgCWDFailed      = '501 - O comando CWD falhou. %s.';
    msgPWDSuccess     = '257 - "%s" é o diretório atual.';
    msgQuit           = '221 - Adeus.';
    msgPortSuccess    = '200 - Comando PORT executado com sucesso.';
    msgPortFailed     = '501 - Comando PORT inválido.';

    msgStorDisabled   = '500 - Permissão negada para STOR.'; {'500 Cannot STOR.';}
    msgStorSuccess    = '150 - Abrindo conexão de dados para %s.';
    msgStorFailed     = '501 - Não foi possível enviar o arquivo (STOR). %s.';
    msgStorAborted    = '426 - Conexão fechada. %s.';
    msgStorOk         = '226 - Arquivo recebido com sucesso.';
    msgStorError      = '426 - Conexão fechada. Transferência cancelada. Error #%d.';

    msgRetrDisabled   = '500 - Não foi possível receber (RETR). O comando RETR está desabilitado';
    msgRetrSuccess    = '150 - Abrindo conexão de dados para %s.';
    msgRetrFailed     = '501 - Não foi possível obter o arquivo (RETR). %s.';
    msgRetrAborted    = '426 - Conexão fechada. %s.';
    msgRetrOk         = '226 - Arquivo enviado com sucesso.';
    msgRetrError      = '426 - Conexão fechada. Transferência cancelada. Error #%d.';
    
    msgSystem         = '215 - UNIX Type: L8 Internet Component Suite';

    msgDirOpen        = '150 - Abrindo conexão de dados para listagem de diretório.';
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
    msgSizeDisabled   = '502 - Comando não implementado ou desabilitado.';
    msgSizeFailed     = '550 - O comando falhou: %s.';
    msgSizeSyntax     = '501 - Erro de sintaxe no parâmetro.';

    msgRestOk         = '350 - REST suportado. Pronto para resumir a partir do byte de offset %d.';
    msgRestZero       = '501 - O byte de offset (requerido como parâmetro) é incorreto ou está faltando.';
    msgRestFailed     = '501 - Erro de sintaxe no parâmetro: %s.';

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

    msgFeatFollows    = '211 - Extensões suportadas - inicio';
    msgFeatFollowDone = '211 - Extensões suportadas - fim';
    msgFeatFailed     = '211 - Sem extensões';

    msgMdtmChangeOK   = '253 Date/time changed OK';                  { angus V1.38 }
    msgMfmtChangeOK   = '213 Date/time changed OK';                  { angus V1.39 }
    msgMdtmChangeFail = '550 MDTM/MFMT cannot change date/time on this server';  { angus V1.38 }
    msgCWDNoDir       = '550 - O comando CWD falhou ao mudar o diretório para %s.';  { angus V1.38 }
    msgMlstFollows    = '250 - Listando:';                              { angus V1.38 }
    msgMlstFollowDone = '250 - FIM';                                   { angus V1.38 }
    msgMlstNotExists  = '550 - "%s": diretório ou arquivo inexistente.';    { angus V1.38 }
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
  #13#10'211 -   SIZE'#13#10 +
  '211 -   REST STREAM'#13#10 + { angus V1.39 (been supported for years) }
  '211 -   MDTM'#13#10 +
  '211 -   MDTM YYYYMMDDHHMMSS[+-TZ] filename'#13#10 +  { angus V1.38 }
  '211 -   MLST size*;type*;perm*;create*;modify*;'#13#10 + { angus V1.39 }
  '211 -   MFMT'#13#10 + { angus V1.39 }
  '211 -   MD5'#13#10; { angus V1.38 }
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

{ TConnectedClient }

constructor TConnectedClient.Create(AOwner: TComponent);
begin
    inherited;
    {$IFDEF THREADED}
    WorkerThread := nil;
    {$ENDIF}
    DataBaseConnection := nil;
end;

end.



