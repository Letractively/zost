unit UFSCForm_Main;

interface

uses
    Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
    Dialogs, ComCtrls, OverbyteIcsFtpCli, StdCtrls, ActnList, XPStyleActnCtrls, ActnMan,
    ToolWin, ActnCtrls, ActnMenus, ZDataSet, ZConnection, ExtCtrls, Grids,
    UFSYGlobals, UXXXTypesConstantsAndClasses, OverbyteIcsWndControl;

type
    TFSCForm_Main = class(TForm)
    FTPClient: TFtpClient;
    MenuPrincipal: TActionMainMenuBar;
    ActionManager1: TActionManager;
    ActionConfig: TAction;
    RichEditLog: TRichEdit;
    PageControl1: TPageControl;
    TabSheet1: TTabSheet;
    TabSheet2: TTabSheet;
    Label2: TLabel;
    Label1: TLabel;
    ProgressBar1: TProgressBar;
    PanelInicialA: TPanel;
    SincronizarC_A: TButton;
    PanelDiferencasA: TPanel;
    SincronizarD_A: TButton;
    Bevel1: TBevel;
    SalvarLog: TButton;
    SaveDialog1: TSaveDialog;
    Label3: TLabel;
    TabSheet3: TTabSheet;
    GroupBox1: TGroupBox;
    RadioButtonRemoto: TRadioButton;
    RadioButtonLocal: TRadioButton;
    RadioButtonAmbos: TRadioButton;
    PanelSnapshotA: TPanel;
    MakeSnapshot_A: TButton;
    Label4: TLabel;
    Label5: TLabel;
    Label6: TLabel;
    ButtonStop1: TButton;
    Button_SalvarArquivoDeDados: TButton;
    ButtonStop3: TButton;
    Action1: TAction;
    ActionChecarChavesEstrangeiras: TAction;
    ActionObterDadosTemporariosEmCasoDeErro: TAction;
    TimerGetTemporaryData: TTimer;
    PanelExecutandoSQL: TPanel;
    ProgressBarBlocos: TProgressBar;
    LabelInstrucoes: TLabel;
    LabelBlocos: TLabel;
    LabelInstrucoesValor: TLabel;
    LabelBlocosValor: TLabel;
    ProgressBarInstrucoes: TProgressBar;
    Action_DiffSimulationMode: TAction;
    Action_ConfirmarMesmoEmCasoDeErro: TAction;
    Action_SalvarScriptGerado: TAction;
    Action_TesteDeTimeout: TAction;
    Action_TesteDeTamanhoDeConteudo: TAction;
    Button_ContinuarSincronizacaoCompleta: TButton;
    TabSheet_SincronizacaoDeCache: TTabSheet;
    Button_CarregarArquivoDeDados: TButton;
    procedure TimerGetTemporaryDataTimer(Sender: TObject);
    procedure ActionObterDadosTemporariosEmCasoDeErroExecute(Sender: TObject);
    procedure ActionChecarChavesEstrangeirasExecute(Sender: TObject);
    procedure Action1Execute(Sender: TObject);
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
    procedure PageControl1Changing(Sender: TObject; var AllowChange: Boolean);
    procedure MakeSnapshot_AClick(Sender: TObject);
    procedure DoSessionClosed(Sender: TObject; ErrCode: Word);
    procedure SalvarLogClick(Sender: TObject);
    procedure FTPClientResponse(Sender: TObject);
    procedure FTPClientRequestDone(Sender: TObject; RqType: TFtpRequest; ErrCode: Word);
    procedure SincronizarC_AClick(Sender: TObject);
    procedure SincronizarD_AClick(Sender: TObject);
    procedure ActionConfigExecute(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure FTPClientDisplay(Sender: TObject; var Msg: string);
    procedure FTPClientCommand(Sender: TObject; var Cmd: string);
    procedure FormCreate(Sender: TObject);
    procedure Action_DiffSimulationModeExecute(Sender: TObject);
    procedure Action_ConfirmarMesmoEmCasoDeErroExecute(Sender: TObject);
    procedure Action_SalvarScriptGeradoExecute(Sender: TObject);
    procedure Action_TesteDeTimeoutExecute(Sender: TObject);
    procedure Action_TesteDeTamanhoDeConteudoExecute(Sender: TObject);
    procedure FTPClientProgress64(Sender: TObject; Count: Int64;
      var Abort: Boolean);
    procedure Button_ContinuarSincronizacaoCompletaClick(Sender: TObject);
    procedure Button_CarregarArquivoDeDadosClick(Sender: TObject);
    procedure Button_SalvarArquivoDeDadosClick(Sender: TObject);
  private
    { Private declarations }
    DataBaseConnection: TZConnection;
    FFSYGlobals: TFSYGlobals;
    { Processing é true quando se está no meio de uma operação demorada e  false
    quando está  aguardando uma  resposta  do  usuário. Busy  é true  quando uma
    operação foi iniciada, e false quando nada está sendo feito }
    FProcessing, FBusy: Boolean;
    procedure setBusy(const Value: Boolean);
    procedure setProcessing(const Value: Boolean);
    procedure DoZlibNotification(aNotificatioType: TZlibNotificationType;
                                 aOperation: TZLibOperation;
                                 aInputFile
                                ,aOutputFile: TFileName);
  public
    { Public declarations }
    property FSYGlobals: TFSYGlobals read FFSYGlobals write FFSYGlobals;
    property Busy: Boolean read FBusy write setBusy;
  	property Processing: Boolean read FProcessing write setProcessing;
  end;

var
    FSCForm_Main: TFSCForm_Main;

implementation

uses
	UFSCForm_Configurations, ZAbstractRODataset, StrUtils, UFSCForm_Splash,
    UFSYTypesConstantsAndClasses, UObjectFile;

{$R *.dfm}

procedure TFSCForm_Main.FormCreate(Sender: TObject);
begin
    {$IFDEF DEVELOPING}
    ActionManager1.ActionBars[0].Items[2].Visible := True;
    {$ENDIF}
    TabSheet_SincronizacaoDeCache.TabVisible := False;
    
	Randomize;
  	FFSYGlobals := TFSYGlobals.Create;

  	FtpClient.LocalFileName := FFSYGlobals.FTPDirectory + '\fakefile.sql';

  	Busy := True;
  	Busy := False;
end;

procedure TFSCForm_Main.FTPClientCommand(Sender: TObject; var Cmd: string);
var
  Comando: String;
begin
  Comando := Cmd;
  if Pos('PASS',Comando) = 1 then
    Comando := 'PASS ' + DupeString(#248,Random(15));

  FFSYGlobals.ShowOnLog('COMANDO:> ' + AnsiString(Comando),RichEditLog);
end;

procedure TFSCForm_Main.FormDestroy(Sender: TObject);
begin
	FFSYGlobals.Free;
end;

procedure TFSCForm_Main.ActionConfigExecute(Sender: TObject);
begin
	Application.CreateForm(TFSCForm_Configurations,FSCForm_Configurations);
  	FSCForm_Configurations.ShowModal;
end;

procedure TFSCForm_Main.DoZlibNotification(aNotificatioType: TZlibNotificationType;
                                           aOperation: TZLibOperation;
                                           aInputFile
                                          ,aOutputFile: TFileName);
begin
  if aOperation = zloDecompress then
    case aNotificatioType of
      zlntBeforeProcess: FFSYGlobals.ShowOnLog('§ Descomprimindo arquivo de dados ' + AnsiString(ExtractFileName(aInputFile)) + '...',RichEditLog);
      zlntAfterProcess: FFSYGlobals.ShowOnLog('§ Descompressão concluída!',RichEditLog);
    end
  else if aOperation = zloCompress then
    case aNotificatioType of
      zlntBeforeProcess: FFSYGlobals.ShowOnLog('§ Comprimindo arquivo de dados ' + AnsiString(ExtractFileName(aInputFile)) + '...',RichEditLog);
      zlntAfterProcess: FFSYGlobals.ShowOnLog('§ Compressão concluída!',RichEditLog);
    end;
end;


procedure TFSCForm_Main.SincronizarD_AClick(Sender: TObject);
var
  WillGetTempData: Boolean;
  TempBusy: Boolean;
begin
  WillGetTempData := False;
  try
    Busy := True;
    TempBusy := Busy;
    try
      RichEditLog.Clear;
      FFSYGlobals.DropAllUniqueIndexes(RichEditLog);
      FFSYGlobals.SynchronizeByDelta(FTPClient
                                    ,DataBaseConnection
                                    ,ProgressBar1
                                    ,Label3
                                    ,ActionChecarChavesEstrangeiras.Checked
                                    ,TempBusy
                                    ,Action_DiffSimulationMode.Checked
                                    ,RichEditLog
                                    ,Action_ConfirmarMesmoEmCasoDeErro.Checked
                                    ,Action_SalvarScriptGerado.Checked
                                    ,DoZlibNotification);
    except
      on E: Exception do
      begin
        WillGetTempData := ActionObterDadosTemporariosEmCasoDeErro.Checked;
        FFSYGlobals.AbortEverything(FTPClient,AnsiString(E.Message),TempBusy,RichEditLog);
      end;
    end;
  finally
    Busy := TempBusy;
    FFSYGlobals.AddAllUniqueIndexes(RichEditLog);
    if not WillGetTempData then
      Busy := False;
  end;
end;

procedure TFSCForm_Main.SincronizarC_AClick(Sender: TObject);
var
	WillGetTempData: Boolean;
  TempBusy: Boolean;
begin
	WillGetTempData := False;
	try
	  Busy := True;
    TempBusy := Busy;

		try
			if MessageBox(Handle,PWideChar('A operação que está para ser iniciada DESTRUIRÁ/SUBSTITUIRÁ o banco de dados "' + WideString(FFSYGlobals.Configurations.DB_DataBase) + '". Esta operação não poderá ser interrompida e nem desfeita. Tem certeza?'),'Tem certeza?',MB_ICONWARNING or MB_YESNO) = idYes then
			begin
				RichEditLog.Clear;
				FFSYGlobals.SynchronizeFull(FTPClient
                                   ,DataBaseConnection
                                   ,ProgressBar1
                                   ,Label3
                                   ,ProgressBarInstrucoes
                                   ,ProgressBarBlocos
                                   ,LabelInstrucoes
                                   ,LabelBlocos
                                   ,LabelInstrucoesValor
                                   ,LabelBlocosValor
                                   ,TempBusy
                                   ,RichEditLog
                                   ,DoZlibNotification
                                   ,False
                                   ,nil);
			end;
		except
			on E: Exception do
      begin
        WillGetTempData := ActionObterDadosTemporariosEmCasoDeErro.Checked;
        FFSYGlobals.AbortEverything(FTPClient,AnsiString(E.Message),TempBusy,RichEditLog);
      end;
		end;
	finally
    Busy := TempBusy;
    if not WillGetTempData then
		  Busy := False;
	end;
end;

procedure TFSCForm_Main.TimerGetTemporaryDataTimer(Sender: TObject);
var
	TempBusy: Boolean;
begin
	{ É preciso setar TempBusy aqui por que seu valor será usado dentro de
    GetTemporaryData e não apenas setado como saída, como acontece com AbortEveryThing }
	TempBusy := Busy;
    TimerGetTemporaryData.Enabled := False;
	FFSYGlobals.GetTemporaryData(FTPClient,DataBaseConnection,ProgressBar1,Label3,TempBusy,RichEditLog);
    Busy := TempBusy;
end;

procedure TFSCForm_Main.DoSessionClosed(Sender: TObject; ErrCode: Word);
var
	NeedGetTemporaryData{, UseDefrag}: Boolean;
begin
	NeedGetTemporaryData := False;
	FFSYGlobals.ShowOnLog('§ A conexão com o servidor foi encerrada...',RichEditLog);
	{ Se uma conexão com o banco foi estabelecida então devemos destruí-la }
	if Assigned(DataBaseConnection) then
	begin
		if DataBaseConnection.Connected then
		begin
//			UseDefrag := False;
			{ Se há algum transação ativa deveremos confirmar ou descartar as alterações feitas }
			if DataBaseConnection.InTransaction then
			begin
				{ Se o flag de erro estiver habilitado então executa um rollback... }
				if DataBaseConnection.Tag <> 0 then
				begin
					FFSYGlobals.ShowOnLog('§ Revertendo banco de dados a seu estado pré-sincronização...',RichEditLog);
					DataBaseConnection.Rollback; //use defrag já está false
                    NeedGetTemporaryData := ActionObterDadosTemporariosEmCasoDeErro.Checked;
   				end
				{ ...do contrário commit }
				else
				begin
					FFSYGlobals.ShowOnLog('§ Confirmando alterações realizadas no banco de dados...',RichEditLog);
					DataBaseConnection.Commit;
//					UseDefrag := True;
				end;
			end;

            Application.ProcessMessages;

            { REMOVIDA A DESFRAGMENTAÇÃO POIS PROVOCA ERROS! }

			{ A desfragmentação só ocorre quando a sincronização for bem-sucedida }
//			if UseDefrag then
//				try
//					Busy := True;
//					Processing := True;
//
//					FFSYGlobals.ShowOnLog('§ Desfragmentando tabelas. Favor aguardar...',RichEditLog);
//					Application.ProcessMessages;
//					FFSYGlobals.MySQLDefragDatabase(DataBaseConnection,ProgressBar1,Label3);
//					FFSYGlobals.ShowOnLog('§ Desfragmentação concluída',RichEditLog);
//				finally
//					Busy := False;
//				end;

			DataBaseConnection.Disconnect;
		end;
        FreeAndNil(DataBaseConnection);
	end;

    { Apenas quando a opção do menu está marcada, "Interval" segundos depois de
    terminada a conexão, para dar tempo de realizar o defrag no servidor }
    if NeedGetTemporaryData then
    begin
	    FFSYGlobals.ShowOnLog('§ Erros ocorreram durante a última tentativa de sincronização. Os dados temporários remotos\nserão obtidos dentro de ' + AnsiString(FloatToStr((TimerGetTemporaryData.Interval / 1000))) + ' segundos para depuração e análise. Por favor aguarde...',RichEditLog);
      	TimerGetTemporaryData.Enabled := True;
        Busy := True;
    end;
end;

procedure TFSCForm_Main.FTPClientRequestDone(Sender: TObject; RqType: TFtpRequest; ErrCode: Word);
var
  Comando, Texto: String;
begin
  case RqType of
    ftpOpenAsync: Comando := 'OPEN';
    ftpGetAsync: Comando := 'GET';
    ftpPutAsync: Comando := 'PUT';
    ftpMd5Async: Comando := 'MD5';
    ftpPassAsync: Comando := 'PASS';
    ftpUserAsync: Comando := 'USER';
    ftpQuitAsync: Comando := 'QUIT';
  else
    Comando := 'Desconhecido';
  end;
  Texto := '@ Comando "' + Comando + '" concluído (Código de retorno = ' + IntToStr(ErrCode) + ') ';
  Texto := Texto + DupeString('<',95 - Length(Texto));

  FFSYGlobals.ShowOnLog(AnsiString(Texto),RichEditLog);

  { Caso algum erro ocorra devemos exibir uma informação de acordo com o mesmo }
  case ErrCode of
    421: FFSYGlobals.ShowOnLog('! O número máximo de usuários simultâneos foi atingido. Favor tentar novamente em alguns minutos.',RichEditLog);
    10061: FFSYGlobals.ShowOnLog('! O servidor recusou sua conexão. Favor entrar em contato com o HelpDesk.',RichEditLog);
    10060: FFSYGlobals.ShowOnLog('! O servidor está ativo mas não respondeu dentro do limite de tempo esperado. Favor tentar novamente em alguns minutos. Se o problema persistir por mais de uma hora, favor entrar em contato com o HelpDesk.',RichEditLog);
  end;
end;

procedure TFSCForm_Main.FTPClientResponse(Sender: TObject);
begin
	if Pos('# SOC: ',FTPClient.LastResponse) = 1 then
    	FFSYGlobals.InitializeProgress(ProgressBar1,Label3,StrToInt(Copy(FTPClient.LastResponse,Pos(':',FTPClient.LastResponse) + 2,Length(FTPClient.LastResponse))));
end;

procedure TFSCForm_Main.FTPClientDisplay(Sender: TObject; var Msg: string);
begin
  if Pos('>',Msg) <> 1 then
  begin
    Msg := StringReplace(Msg,'< ','',[]);
    Msg := StringReplace(Msg,'! ','',[]);
    FFSYGlobals.ShowOnLog('RETORNO:> ' + AnsiString(Msg),RichEditLog);
  end
end;

procedure TFSCForm_Main.FTPClientProgress64(Sender: TObject; Count: Int64; var Abort: Boolean);
begin
	FFSYGlobals.SetProgressWith(ProgressBar1,Label3,Count);
end;

procedure TFSCForm_Main.SalvarLogClick(Sender: TObject);
begin
	if RichEditLog.Lines.Count > 0 then
  	begin
		if SaveDialog1.Execute then
  			RichEditLog.Lines.SaveToFile(SaveDialog1.FileName);
  	end
  	else
  		MessageBox(Handle,'O log está vazio e não pode ser salvo','Log vazio',MB_ICONERROR);
end;

procedure TFSCForm_Main.MakeSnapshot_AClick(Sender: TObject);
var
	TempBusy: Boolean;
begin
	try
		Busy := True;
		TempBusy := Busy;
        
		TButton(Sender).Enabled := False;
		GroupBox1.Enabled := False;
		RichEditLog.Clear;
		try
			if RadioButtonLocal.Checked then
				FFSYGlobals.TakeSnapshot(FTPClient,DataBaseConnection,0,ProgressBar1,Label3,TempBusy,RichEditLog,DoZlibNotification)
			else if RadioButtonRemoto.Checked then
				FFSYGlobals.TakeSnapshot(FTPClient,DataBaseConnection,1,ProgressBar1,Label3,TempBusy,RichEditLog,DoZlibNotification)
			else if RadioButtonAmbos.Checked then
				FFSYGlobals.TakeSnapshot(FTPClient,DataBaseConnection,2,ProgressBar1,Label3,TempBusy,RichEditLog,DoZlibNotification);
		except
			on E: Exception do
				FFSYGlobals.ShowOnLog('! ' + FFSYGlobals.PutLineBreaks(AnsiString(E.Message),93),RichEditLog);
		end;

	finally
   	{ Parece estupidez o que eu fiz abaixo... e é! Mas fiz isso
    intencionalmente para indicar que no final, Busy sempre tem receber
    TempBusy. Isso é uma regra, que se seguida sempre, mesmo quando
    desnecessariamente, evita problemas }
    TempBusy := False;
    Busy := TempBusy;

    if FTPClient.Connected then
      FFSYGlobals.ExecuteCmd(FTPClient,FTPClient.Quit,RichEditLog,'QUIT',ProgressBar1,Label3);
	end;
end;

procedure TFSCForm_Main.setBusy(const Value: Boolean);
begin
	if Value <> FBusy then
  	begin
    	FBusy := Value;
    	{ Certas coisas devem ser habilitadas / desabilitadas de acordo com o
        status de FBusy }
    	FProcessing := False;

    	SalvarLog.Enabled := not FBusy;
    	MenuPrincipal.Enabled := not FBusy;

    	SincronizarD_A.Enabled := not FBusy;
    	SincronizarC_A.Enabled := not FBusy;
    	MakeSnapshot_A.Enabled := not FBusy;
      Button_ContinuarSincronizacaoCompleta.Enabled := not Busy;
      Button_CarregarArquivoDeDados.Enabled := not FBusy;
      Button_SalvarArquivoDeDados.Enabled := not FBusy;

    	GroupBox1.Enabled := not FBusy;
  	end;
end;

procedure TFSCForm_Main.setProcessing(const Value: Boolean);
begin
	{ Só posso alterar o valor de fProcessing se estiver ocupado (fBusy = true) }
	if (Value <> FProcessing) and FBusy then
	    FProcessing := Value;
end;

procedure TFSCForm_Main.PageControl1Changing;
begin
	AllowChange := not FBusy;
end;

procedure TFSCForm_Main.FormCloseQuery(Sender: TObject; var CanClose: Boolean);
begin
	CanClose := not FTPClient.Connected;
    if not CanClose then
  		MessageBox(Handle,'Por favor aguarde até o final do processamento atual. O processo atual terminará quando o programa desconectar do servidor. Isto acontece quando o comando QUIT aparecer no log de ações','Operação em andamento,aguarde...',MB_ICONWARNING);
end;

procedure TFSCForm_Main.Button_CarregarArquivoDeDadosClick(Sender: TObject);
begin
  { Copia o arquivo SERVER_DATABASE.DAT no diretório corret }
end;

procedure TFSCForm_Main.Button_ContinuarSincronizacaoCompletaClick(Sender: TObject);
var
	WillGetTempData: Boolean;
  TempBusy: Boolean;
begin
  if not FileExists(FFSYGlobals.FTPDirectory + '\SERVER_DATABASE.DAT') then
  begin
    if Application.MessageBox('Não foi possível encontrar um arquivo de dados válido. Deseja realizar a sincronização completa desde o início?','O que deseja fazer?',MB_ICONWARNING or MB_YESNO) = IDYES then
      SincronizarC_A.Click;
    Exit;
  end;
  
	WillGetTempData := False;
	try
	  Busy := True;
    TempBusy := Busy;

		try
			if MessageBox(Handle,PWideChar('A operação que está para ser iniciada DESTRUIRÁ/SUBSTITUIRÁ o banco de dados "' + WideString(FFSYGlobals.Configurations.DB_DataBase) + '". Esta operação não poderá ser interrompida e nem desfeita. Tem certeza?'),'Tem certeza?',MB_ICONWARNING or MB_YESNO) = idYes then
			begin
				RichEditLog.Clear;
				FFSYGlobals.SynchronizeFull(FTPClient
                                   ,DataBaseConnection
                                   ,ProgressBar1
                                   ,Label3
                                   ,ProgressBarInstrucoes
                                   ,ProgressBarBlocos
                                   ,LabelInstrucoes
                                   ,LabelBlocos
                                   ,LabelInstrucoesValor
                                   ,LabelBlocosValor
                                   ,TempBusy
                                   ,RichEditLog
                                   ,DoZlibNotification
                                   ,True
                                   ,SincronizarD_AClick);
			end;
		except
			on E: Exception do
      begin
        WillGetTempData := ActionObterDadosTemporariosEmCasoDeErro.Checked;
        FFSYGlobals.AbortEverything(FTPClient,AnsiString(E.Message),TempBusy,RichEditLog);
      end;
		end;
	finally
    Busy := TempBusy;
    if not WillGetTempData then
		  Busy := False;
	end;
end;

procedure TFSCForm_Main.Button_SalvarArquivoDeDadosClick(Sender: TObject);
begin
  { Salva o arquivo SERVER_DATABASE.DAT em um diretório correto }
end;

procedure TFSCForm_Main.Action1Execute(Sender: TObject);
begin
	Application.CreateForm(TFSCForm_Splash,FSCForm_Splash);
  	FSCForm_Splash.ShowModal;
end;

procedure TFSCForm_Main.ActionChecarChavesEstrangeirasExecute(Sender: TObject);
begin
	{ Não é necessário fazer nada! }
    if not ActionChecarChavesEstrangeiras.Checked then
    	if MessageBox(Handle,'Desabilitar as checagem de chaves estrangeiras não é recomendável, tem certeza?','Tem certeza?',MB_ICONQUESTION or MB_YESNO) = idNo then
        	ActionChecarChavesEstrangeiras.Checked := True;
end;

procedure TFSCForm_Main.ActionObterDadosTemporariosEmCasoDeErroExecute(Sender: TObject);
begin
	{ Não é necessário fazer nada! }
    if ActionObterDadosTemporariosEmCasoDeErro.Checked then
    	MessageBox(Handle,'Com esta oção ativada, uma conexão adicional será realizada no caso de um erro acontecer, para a obtenção dos últimos arquivos temporários gerados no servidor, com propósito de depuração e análise.','Aviso importante',MB_ICONWARNING);
end;


procedure TFSCForm_Main.Action_ConfirmarMesmoEmCasoDeErroExecute(Sender: TObject);
begin
    { Não é necessário fazer nada! }
end;

procedure TFSCForm_Main.Action_DiffSimulationModeExecute(Sender: TObject);
begin
	SincronizarC_A.Enabled := not Action_DiffSimulationMode.Checked;

	if Action_DiffSimulationMode.Checked then
    begin
	    Caption := 'FTP Synchronizer (Modo Simulado)';
        SincronizarC_A.Caption := 'Não é possível realizar uma sincronização completa no modo simulado';
    end
	else
    begin
    	Caption := 'FTP Synchronizer';
        SincronizarC_A.Caption := 'Clique aqui para sincronizar o banco dedados local com o banco de dados remoto';
    end;
end;

procedure TFSCForm_Main.Action_SalvarScriptGeradoExecute(Sender: TObject);
begin
    { Não é necessário fazer nada! }
end;

procedure TFSCForm_Main.Action_TesteDeTamanhoDeConteudoExecute(Sender: TObject);
{$IFDEF DEVELOPING}
var
    TempBusy: Boolean;
{$ENDIF}
begin
    {$IFDEF DEVELOPING}
	try
		Busy := True;
        TempBusy := Busy;
		try
            RichEditLog.Clear;
            FFSYGlobals.ContentSizeTest(FTPClient
                                       ,DataBaseConnection
                                       ,TempBusy
                                       ,RichEditLog
                                       ,ProgressBar1
                                       ,Label3);
		except
			on E: Exception do
            begin
				FFSYGlobals.AbortEverything(FTPClient,E.Message,TempBusy,RichEditLog);
            end;
		end;
	finally
        Busy := TempBusy;
		Busy := False;
	end;
    {$ENDIF}
end;

procedure TFSCForm_Main.Action_TesteDeTimeoutExecute(Sender: TObject);
{$IFDEF DEVELOPING}
var
    TempBusy: Boolean;
{$ENDIF}
begin
    {$IFDEF DEVELOPING}
	try
		Busy := True;
        TempBusy := Busy;
		try
            RichEditLog.Clear;
            FFSYGlobals.TimeOutTest(FTPClient
                                   ,DataBaseConnection
                                   ,TempBusy
                                   ,RichEditLog
                                   ,ProgressBar1
                                   ,Label3);
		except
			on E: Exception do
            begin
				FFSYGlobals.AbortEverything(FTPClient,E.Message,TempBusy,RichEditLog);
            end;
		end;
	finally
        Busy := TempBusy;
		Busy := False;
	end;
    {$ENDIF}
end;

end.
