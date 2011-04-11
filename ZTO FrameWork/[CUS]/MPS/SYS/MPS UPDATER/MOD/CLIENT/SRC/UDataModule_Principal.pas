{ TODO -oCARLOS FEITOZA -cADI��O : PARA CADA SISTEMA NO INI, SEPARADO POR ";", DEVEMOS REALIZAR A CHECAGEM (RealizarChecagem, RealizarAtualizacao e ObterListaDeArquivosModificados). ATUALMENTE APENAS UM SISTEMA EST� SENDO CHECADO }
{ TODO -oCARLOS FEITOZA -cADI��O : NO SERVIDOR CRIAR UM COMANDO PARA OBTER APENAS A RESPOSTA DE EXISTIR OU N�O ARQUIVOS A MODIFICAR. ATUALMENTE TODA A LISTA DE ARQUIVOS MODIFICADO � RETORNADA SEM NECESSIDADE. }
{ TODO -oCARLOS FEITOZA -cCORRE��O : ALTERAR OS NOMES DOS SCRIPTS PARA ALGO MAIS EXPLICATIVO, COMO SINCRONIZA��O, ETC }
{ TODO -oCARLOS FEITOZA -cINFORMA��O : AINDA N�O � POSS�VEL MANIPULAR DIRET�RIOS VAZIOS, POR ISSO, DIRET�RIOS QUE PRECISAM SER VAZIOS PRECISAM DE AO MENOS UM ARQUIVO DENTRO DELE }
unit UDataModule_Principal;

interface

uses
  SysUtils, Classes, OverbyteIcsFtpCli, OverbyteIcsLogger, OverbyteIcsWndControl,
  ActnList, ComCtrls, ExtCtrls, Menus, Messages, StdCtrls, UGlobalFunctions;

type
  TTrayIcon = class(ExtCtrls.TTrayIcon)
  private
    FOnClickFor: ShortInt;
  protected
    procedure WindowProc(var Message: TMessage); override;
  public
    property OnClickFor: ShortInt read FOnClickFor write FOnClickFor;
  end;

  TStringList = class(Classes.TStringList)
  private
  protected
  public
    function IndexOfPart(const S: String): Integer;
  end;
  
  TAutoChecagem = class(TThread)
  private
    FProximaChecagem: TDateTime;
    FIntervaloDeChecagem: Cardinal;
  protected
    procedure Execute; override;
  public
    constructor Create(aCreateSuspended: Boolean);
    property ProximaChecagem: TDateTime read FProximaChecagem write FProximaChecagem;
    property IntervaloDeChecagem: Cardinal read FIntervaloDeChecagem write FIntervaloDeChecagem;
  end;
 
  TDataModule_Principal = class(TDataModule)
    FtpClient_Principal: TFtpClient;
    ActionList_Principal: TActionList;
    Action_AtualizarAgora: TAction;
    Action_EsconderNaBarraDeTarefas: TAction;
    Action_RestaurarTela: TAction;
    TrayIcon_Principal: TTrayIcon;
    PopupMenu_TrayIcon: TPopupMenu;
    Restaurartela1: TMenuItem;
    Action_FecharAplicacao: TAction;
    FecharoMPSUpdater1: TMenuItem;
    N1: TMenuItem;
    VerificarImediatamente1: TMenuItem;
    Action_SalvarLOG: TAction;
    procedure Action_AtualizarAgoraExecute(Sender: TObject);
    procedure FtpClient_PrincipalCommand(Sender: TObject; var Cmd: string);
    procedure FtpClient_PrincipalDisplay(Sender: TObject; var Msg: string);
    procedure FtpClient_PrincipalRequestDone(Sender: TObject; RqType: TFtpRequest; ErrCode: Word);
    procedure FtpClient_PrincipalResponse(Sender: TObject);
    procedure FtpClient_PrincipalSessionClosed(Sender: TObject; ErrCode: Word);
    procedure DataModuleCreate(Sender: TObject);
    procedure FtpClient_PrincipalProgress64(Sender: TObject; Count: Int64; var Abort: Boolean);
    procedure Action_RestaurarTelaExecute(Sender: TObject);
    procedure Action_FecharAplicacaoExecute(Sender: TObject);
    procedure Action_EsconderNaBarraDeTarefasExecute(Sender: TObject);
    procedure DataModuleDestroy(Sender: TObject);
    procedure Action_SalvarLOGExecute(Sender: TObject);
  private
    { Private declarations }
    FFTPDirectory: TFileName;
    FAutoChecagem: TAutoChecagem;
    FProgressCount: Int64;
    procedure RealizarAtualizacao(const aProgressBarArquivo, aProgressBarGeral: TProgressBar; aRichEdit: TRichEdit; const aLabelPercentArquivo, aLabelPercentGeral: TLabel); overload;
    procedure RealizarChecagem(const aProgressBarArquivo
                                   , aProgressBarGeral: TProgressBar;
                                     aRichEdit: TRichEdit;
                               const aLabelPercentArquivo
                                   , aLabelPercentGeral: TLabel); overload;
    {$HINTS OFF}
    procedure RealizarChecagem; overload;
    {$HINTS ON}
    procedure ObterListaDeArquivosMonitorados(aProgressBarArquivo: TProgressBar;
                                              aRichEdit: TRichEdit);
    procedure ExcluirArquivo(aFileName: TFileName; aRichEdit: TRichEdit);
    procedure ExcluirDiretorio(aDirName: TFileName; aRichEdit: TRichEdit);
    procedure ObterArquivoAtualizado(aProgressBarArquivo: TProgressBar;
                                     aRootDirectory: TFileName;
                                     aFileName: TFileInfo;
                                     aRichEdit: TRichEdit);
    procedure MinimizarNaBarraDeTarefas(aSender: TObject);
    procedure AtivarEAtualizar;
    procedure PararAutoChecagem;
    procedure ContinuarAutoChecagem;
    procedure AtualizarTextoAutoChecagem;
    procedure RessetarProgressos;
    procedure UpdateLastSynchronizationInfo;
    procedure AtualizarStatus;
    procedure ConfigurarAcoes(aMonitoredFiles: TMonitoredFiles);
  public
    { Public declarations }
    procedure RealizarAtualizacao; overload;
    function PodeFechar(aQual: Byte): Boolean;
    procedure ConfigureBalloonHint(aQual: Byte);
    procedure ShowErrorMessage(aText: String; aRichEdit: TRichEdit);
    property AutoChecagem: TAutoChecagem read FAutoChecagem;
 end;

var
  DataModule_Principal: TDataModule_Principal;

implementation

uses UForm_Principal, IniFiles, Forms, StrUtils, Windows,
     USingleEncrypt, DateUtils, ShellApi, UObjectFile;

{$R *.dfm}

resourcestring
  LOGTEXT0 = '� Foram detectadas vers�es atualizadas dos softwares da MPS. � altamente recomend�vel realizar a atualiza��o.';
  LOGTEXT1 = '� N�o existem arquivos a serem processados. Todos os arquivos locais est�o em suas vers�es mais recentes!';
  LOGTEXT2 = '� Todos os arquivos foram processados com sucesso! Agora, os softwares da MPS est�o em suas vers�es mais recentes neste computador.';
  LOGTEXT3 = '� O MPS Updater n�o conseguiu processar todos os arquivos';

  BALLOONTEXT0 = 'Clique neste �cone com o bot�o direito do mouse para acessar o menu do MPS Updater';
  BALLOONTEXT1 = 'O MPS Updater detectou novas vers�es dos softwares da MPS. Clique neste bal�o para atualizar para as vers�es mais recentes';
  BALLOONTEXT2 = 'O MPS Updater atualizou os softwares da MPS neste computador com sucesso.';
  BALLOONTEXT3 = 'O MPS Updater n�o conseguiu atualizar todos os arquivos. Clique neste bal�o para ver o log de atualiza��o.';
  BALLOONTEXT4 = 'N�o existem arquivos a serem atualizados. Todos os arquivos locais est�o em suas vers�es mais recentes!';

  BALLOONTITLE0 = 'O MPS Updater ainda est� ativo!';
  BALLOONTITLE1 = 'Novas vers�es dispon�veis!';
  BALLOONTITLE2 = 'Todas as atualiza��es foram realizadas com sucesso!';
  BALLOONTITLE3 = 'Houve problemas na atualiza��o de alguns arquivos!';
  BALLOONTITLE4 = 'A atualiza��o n�o � necess�ria';

const
  AUTOCHECAGEMSTR = '"Autochecagem em:" nn:ss';

{ TDataModule_Principal }

procedure TDataModule_Principal.UpdateLastSynchronizationInfo;
begin
  with TIniFile.Create(ChangeFileExt(Application.ExeName,'.ini')) do
    try
      Form_Principal.StatusBar2.Panels[1].Text := '�ltima sincroniza��o em ' + FormatDateTime('dd/mm/yyyy "�s" hh:nn:ss',ReadFloat('ULTIMASINCRONIZACAO','DATA',0.0));
    finally
      Free;
    end;
end;

procedure TDataModule_Principal.Action_AtualizarAgoraExecute(Sender: TObject);
begin
  try
    Action_AtualizarAgora.Enabled := False;
    RealizarAtualizacao;
  finally
    Action_AtualizarAgora.Enabled := True;
    Form_Principal.StatusBar1.Panels[0].Text := '';
  end;
end;

procedure TDataModule_Principal.Action_EsconderNaBarraDeTarefasExecute(Sender: TObject);
begin
  MinimizarNaBarraDeTarefas(Sender);
end;

procedure TDataModule_Principal.Action_FecharAplicacaoExecute(Sender: TObject);
begin
  Form_Principal.OnCloseQuery := nil;

  if PodeFechar(0) then
    Form_Principal.Close
  else
    Form_Principal.OnCloseQuery := Form_Principal.FormCloseQuery;
end;

procedure TDataModule_Principal.Action_RestaurarTelaExecute(Sender: TObject);
begin
  TrayIcon_Principal.Visible := False;
  Form_Principal.Show;
end;

procedure TDataModule_Principal.Action_SalvarLOGExecute(Sender: TObject);
begin
  FAutoChecagem.Suspend;
end;

procedure TDataModule_Principal.AtivarEAtualizar;
begin
  Action_RestaurarTela.Execute;
  RealizarAtualizacao;
end;

procedure TDataModule_Principal.AtualizarStatus;
begin
  Form_Principal.Label_ModoMini.Caption := Form_Principal.Label_ModoMini.Caption + ' (' + FormatFloat('###,###,###,###',Form_Principal.ProgressBar_Arquivo.Max) + ' Bytes)';
  Form_Principal.Label_ModoMini.Update;

  Form_Principal.StatusBar1.Panels[0].Text := Form_Principal.Label_ModoMini.Caption;
end;

procedure TDataModule_Principal.AtualizarTextoAutoChecagem;
begin
  if Assigned(Form_Principal) and Assigned(Form_Principal.StatusBar2) then
    Form_Principal.StatusBar2.Panels[0].Text := FormatDateTime(AUTOCHECAGEMSTR,Now - FAutoChecagem.ProximaChecagem);
end;

procedure TDataModule_Principal.ConfigureBalloonHint(aQual: Byte);
begin
  case aQual of
    0: begin
      TrayIcon_Principal.BalloonTimeout := 10000;
      TrayIcon_Principal.BalloonFlags := bfInfo;
      TrayIcon_Principal.OnClickFor := 0;
      TrayIcon_Principal.BalloonHint := BALLOONTEXT0;
      TrayIcon_Principal.BalloonTitle := BALLOONTITLE0;
    end;
    1: begin
      TrayIcon_Principal.BalloonTimeout := 10000;
      TrayIcon_Principal.BalloonFlags := bfWarning;
      TrayIcon_Principal.OnClickFor := 1;
      TrayIcon_Principal.BalloonHint := BALLOONTEXT1;
      TrayIcon_Principal.BalloonTitle := BALLOONTITLE1;
    end;
    2: begin
      TrayIcon_Principal.BalloonTimeout := 10000;
      TrayIcon_Principal.BalloonFlags := bfInfo;
      TrayIcon_Principal.OnClickFor := 2;
      TrayIcon_Principal.BalloonHint := BALLOONTEXT2;
      TrayIcon_Principal.BalloonTitle := BALLOONTITLE2;
    end;
    3: begin
      TrayIcon_Principal.BalloonTimeout := 10000;
      TrayIcon_Principal.BalloonFlags := bfError;
      TrayIcon_Principal.OnClickFor := 3;
      TrayIcon_Principal.BalloonHint := BALLOONTEXT3;
      TrayIcon_Principal.BalloonTitle := BALLOONTITLE3;
    end;
    4: begin
      TrayIcon_Principal.BalloonTimeout := 10000;
      TrayIcon_Principal.BalloonFlags := bfInfo;
      TrayIcon_Principal.OnClickFor := 4;
      TrayIcon_Principal.BalloonHint := BALLOONTEXT4;
      TrayIcon_Principal.BalloonTitle := BALLOONTITLE4;
    end;
  end;
end;

procedure TDataModule_Principal.DataModuleCreate(Sender: TObject);
begin
  FFTPDirectory := GetCurrentDir + '\FTPSync';

  if not DirectoryExists(FFTPDirectory) then
    CreateDir(FFTPDirectory);

  { Cria o Thread de verifica��o em estado suspenso, setando apenas as
  propriedades que n�o mudam }
  FAutoChecagem := TAutoChecagem.Create(True);
  FAutoChecagem.Priority := tpLowest;

  FAutoChecagem.ProximaChecagem := Now;

  with TIniFile.Create(ChangeFileExt(Application.ExeName,'.ini')) do
    try
      FAutoChecagem.IntervaloDeChecagem := ReadInteger('AUTOCHECAGEM','INTERVALO',0);
    finally
      Free;
    end;
end;

procedure TDataModule_Principal.DataModuleDestroy(Sender: TObject);
begin
  FAutoChecagem.Terminate;
  FAutoChecagem.Free;
end;

procedure TDataModule_Principal.FtpClient_PrincipalCommand(Sender: TObject; var Cmd: string);
var
	Comando: String;
begin
	Comando := Cmd;
  	if Pos('PASS',Comando) = 1 then
  		Comando := 'PASS <SENHA OCULTADA>';

  ShowOnLog(PutLineBreaks('COMANDO:> ' + Comando,89),Form_Principal.RichEdit_Log);
end;

procedure TDataModule_Principal.FtpClient_PrincipalDisplay(Sender: TObject; var Msg: string);
begin
	if Pos('>',Msg) <> 1 then
  begin
    // < XXX-
    if Pos('EOM',Msg) = 1 then
      Exit;

    { Para o caso da resposta n�o conter codigos, devemos apenas remove-los caso
    os mesmos existam }
    if (Pos('220',Msg) = 3)
    or (Pos('331',Msg) = 3)
    or (Pos('230',Msg) = 3)
    or (Pos('200',Msg) = 3)
    or (Pos('150',Msg) = 3)
    or (Pos('226',Msg) = 3)
    or (Pos('221',Msg) = 3) then
      Delete(Msg,1,6);

		Msg := StringReplace(Msg,'< ','',[]);
 		Msg := StringReplace(Msg,'! ','',[]);
  	ShowOnLog(PutLineBreaks('RETORNO:> ' + Msg,89),Form_Principal.RichEdit_Log);
  end
end;

procedure TDataModule_Principal.FtpClient_PrincipalProgress64(Sender: TObject; Count: Int64; var Abort: Boolean);
begin
  FProgressCount := Count;
  SetProgressWith(Form_Principal.ProgressBar_Arquivo
                 ,Form_Principal.Label_ProgressDoArquivo
                 ,FProgressCount);
end;

procedure TDataModule_Principal.FtpClient_PrincipalRequestDone(Sender: TObject; RqType: TFtpRequest; ErrCode: Word);
var
  Comando, Texto: String;
begin
  case RqType of
    ftpOpenAsync: Comando := 'OPEN';
    ftpGetAsync : Comando := 'GET';
    ftpPutAsync : Comando := 'PUT';
    ftpMd5Async : Comando := 'MD5';
    ftpPassAsync: Comando := 'PASS';
    ftpUserAsync: Comando := 'USER';
    ftpQuitAsync: Comando := 'QUIT';
    ftpCwdAsync : Comando := 'CWD';
    ftpSizeAsync: Comando := 'SIZE';
    else
      Comando := 'Desconhecido';
  end;

  Texto := '@ Comando "' + Comando + '" conclu�do (C�digo de retorno = ' + IntToStr(ErrCode) + ') ';
  Texto := Texto + DupeString('<',89 - Length(Texto));

  ShowOnLog(PutLineBreaks(Texto,89),Form_Principal.RichEdit_Log);

  { Caso algum erro ocorra devemos exibir uma informa��o de acordo com o mesmo }
  case ErrCode of
    421  : ShowErrorMessage('! O n�mero m�ximo de usu�rios simult�neos foi atingido. Favor tentar novamente em alguns minutos.',Form_Principal.RichEdit_Log);
    10061: ShowErrorMessage('! O servidor recusou sua conex�o. Ele pode estar desativado. Tente novamente em alguns minutos. Caso o problema persista, favor entrar em contato com o suporte.',Form_Principal.RichEdit_Log);
    10060: ShowErrorMessage('! O servidor est� ativo mas n�o respondeu dentro do limite de tempo esperado. Favor tentar novamente em alguns minutos. Se o problema persistir por mais de uma hora, favor entrar em contato com o suporte.',Form_Principal.RichEdit_Log);
  end;
end;

procedure TDataModule_Principal.FtpClient_PrincipalResponse(Sender: TObject);
begin
	if Pos('150-DFS: ',FtpClient_Principal.LastResponse) = 1 then
  begin
    InitializeProgress(Form_Principal.ProgressBar_Arquivo
                      ,Form_Principal.Label_ProgressDoArquivo
                      ,StrToInt(Copy(FtpClient_Principal.LastResponse,Pos('150-DFS: ',FtpClient_Principal.LastResponse) + 9,Length(FtpClient_Principal.LastResponse))));
  end
	else if Pos('213 ',FtpClient_Principal.LastResponse) = 1 then
  begin
    InitializeProgress(Form_Principal.ProgressBar_Arquivo
                      ,nil
                      ,StrToInt(Copy(FtpClient_Principal.LastResponse,Pos('213 ',FtpClient_Principal.LastResponse) + 4,Length(FtpClient_Principal.LastResponse))));

    AtualizarStatus;
  end;
end;

procedure TDataModule_Principal.FtpClient_PrincipalSessionClosed(Sender: TObject; ErrCode: Word);
begin
	ShowOnLog(PutLineBreaks('� A conex�o com o servidor foi encerrada...',98),Form_Principal.RichEdit_Log);
end;

procedure TDataModule_Principal.MinimizarNaBarraDeTarefas(aSender: TObject);
begin
  TrayIcon_Principal.Visible := True;
  ConfigureBalloonHint(0);
  TrayIcon_Principal.ShowBalloonHint;
  Form_Principal.Hide;
end;

procedure TDataModule_Principal.ExcluirArquivo(aFileName: TFileName; aRichEdit: TRichEdit);
begin
  ShowOnLog(PutLineBreaks('� Excluindo arquivo "' + aFileName + '"...',89), aRichEdit);

  Form_Principal.Label_ModoMini.Caption := 'Excluindo o arquivo: ' + aFileName;
  Form_Principal.Label_ModoMini.Update;

  Form_Principal.StatusBar1.Panels[0].Text := Form_Principal.Label_ModoMini.Caption;

  if not SysUtils.DeleteFile(aFileName) then
    raise EUnsuccessfulExclusion.Create('N�o foi poss�vel excluir o arquivo "' + aFileName + '"');
end;

procedure TDataModule_Principal.ExcluirDiretorio(aDirName: TFileName; aRichEdit: TRichEdit);
begin
  ShowOnLog(PutLineBreaks('� Excluindo diret�rio "' + aDirName + '"...',89), aRichEdit);

  Form_Principal.Label_ModoMini.Caption := 'Excluindo o diret�rio: ' + aDirName;
  Form_Principal.Label_ModoMini.Update;

  Form_Principal.StatusBar1.Panels[0].Text := Form_Principal.Label_ModoMini.Caption;

  RmDir(aDirName);
end;

procedure TDataModule_Principal.ObterArquivoAtualizado(aProgressBarArquivo: TProgressBar;
                                                       aRootDirectory: TFileName;
                                                       aFileName: TFileInfo;
                                                       aRichEdit: TRichEdit);
begin
  { Muda para o diret�rio do servidor onde est� o arquivo que queremos baixar }
  MudarDiretorio(FtpClient_Principal
                ,aRootDirectory + '\' + ExtractFilePath(aFileName.FilePath)
                ,aRichEdit);

  if not DirectoryExists(ExtractFilePath(aFileName.TranslatedFilePath)) then
    ForceDirectories(ExtractFilePath(aFileName.TranslatedFilePath));

  Form_Principal.Label_ModoMini.Caption := 'Baixando o arquivo: ' + aFileName.TranslatedFilePath;
  Form_Principal.Label_ModoMini.Update;

  Form_Principal.StatusBar1.Panels[0].Text := Form_Principal.Label_ModoMini.Caption;

  if not ObterArquivo(FtpClient_Principal
                     ,aProgressBarArquivo
                     ,nil
                     ,aFileName.TranslatedFilePath
                     ,ExtractFileName(aFileName.TranslatedFilePath)
                     ,aRichEdit
                     ,True) then
    raise EInvalidPath.Create('N�o foi poss�vel obter o arquivo "' + aFileName.TranslatedFilePath + '"');
end;

procedure TDataModule_Principal.ObterListaDeArquivosMonitorados(aProgressBarArquivo: TProgressBar;
                                                                aRichEdit: TRichEdit);
var
  Comando, Sistema, Formato: String;
//  Data: Double;
begin
  with TIniFile.Create(ChangeFileExt(Application.ExeName,'.ini')) do
    try
      Sistema := ReadString('CONFIGURACOES','SISTEMA','');
      Formato := FORMATOS[ReadInteger('CONFIGURACOES','FORMATO',0)];
//      Data := ReadFloat('ULTIMASINCRONIZACAO','DATA',0.0);

      { O comando vai trazer uma lista com todos os arquivos e suas datas.
      Localmente estes arquivos devem ser comparados com os existentes e s�
      ser�o baixados aqueles que realmente precisam de atualiza��o ou que n�o
      existam }
      Comando := StringReplace(CMD_MONITOREDFILESLIST,'*',Sistema,[]);
      Comando := StringReplace(Comando,'???',Formato,[]);

      Form_Principal.Label_ModoMini.Caption := 'Obtendo a lista de arquivos monitorados...';
      Form_Principal.Label_ModoMini.Update;

      if not ObterArquivo(FtpClient_Principal
                         ,aProgressBarArquivo
                         ,nil
                         ,FFTPDirectory + '\' + MONITOREDFILESLIST
                         ,Comando
                         ,aRichEdit
                         ,False
                         ,1) then
        raise Exception.Create('N�o foi poss�vel obter a lista de arquivos monitorados');
    finally
      Free;
    end;
end;

procedure TDataModule_Principal.PararAutoChecagem;
begin
  if FAutoChecagem.IntervaloDeChecagem > 0 then
  begin
    FAutoChecagem.Suspend;
    Form_Principal.StatusBar2.Panels[0].Text := 'Autochecagem desligada';
    Form_Principal.Update;
  end;
end;

procedure TDataModule_Principal.ContinuarAutoChecagem;
begin
  if FAutoChecagem.IntervaloDeChecagem > 0 then
  begin
    with TIniFile.Create(ChangeFileExt(Application.ExeName,'.ini')) do
      try
        FAutoChecagem.IntervaloDeChecagem := ReadInteger('AUTOCHECAGEM','INTERVALO',0);
        FAutoChecagem.ProximaChecagem := IncMinute(Now,ReadInteger('AUTOCHECAGEM','INTERVALO',0));
      finally
        Free;
      end;

    FAutoChecagem.Resume;
  end;
end;

function TDataModule_Principal.PodeFechar(aQual: Byte): Boolean;
begin
  case aQual of
    0: Result := Application.MessageBox('Tem certeza de que quer sair do MPS Updater? Se voc� sair, n�o ser� notificado de novas atualiza��es dos softwares da MPS','Tem certeza?',MB_ICONQUESTION or MB_YESNO) = IDYes;
    1: Result := Application.MessageBox('Tem certeza de que quer sair do MPS Updater? Se voc� sair, n�o ser� notificado de novas atualiza��es dos softwares da MPS. Ao inv�s de sair voc� pode ocultar esta tela clicando em "Esconder tela".','Tem certeza?',MB_ICONQUESTION or MB_YESNO) = IDYes;
    else
      Result := False; 
  end;
end;

type
  TCallbackData = record
    MonitoredFiles: TMonitoredFiles;
  end;

var
  CallbackData: TCallbackData;

function ProcessarArquivos(aSearchRec: TSearchRec): Boolean;
begin
  if CallbackData.MonitoredFiles.Files.IndexOfTranslatedFilePath(ExpandFileName(aSearchRec.Name)) = -1 then
  begin
    with CallbackData.MonitoredFiles.Files.Add do
    begin
      FilePath := ExpandFileName(aSearchRec.Name);
      ActionOnFile := aofDeleteFile;
    end;
  end;
  Result := True;
end;

function ProcessarDiretorios(aSearchRec: TSearchRec): Boolean;
begin
 if CallbackData.MonitoredFiles.Files.IndexOfTranslatedFilePath(ExpandFileName('.'),True) = -1 then
  begin
    with CallbackData.MonitoredFiles.Files.Add do
    begin
      FilePath := ExpandFileName('.');
      ActionOnFile := aofDeleteDir;
    end;
  end;
  Result := True;
end;


{ Altera aMonitoredFiles alterando a propriedade ActionOnFile de cada arquivo
para aofUpdate, quando o arquivo remoto n�o existir localmente ou for mais
novo. Tamb�m adiciona itens que precisam ser exclu�dos dos diret�rios locais com
a a��o aofDelete. }
procedure TDataModule_Principal.ConfigurarAcoes(aMonitoredFiles: TMonitoredFiles);
{ ---------------------------------------------------------------------------- }
function ObterAcao(aArquivoLocal: TFileName; aDataDeModificacaoArquivoRemoto: TDateTime): TActionOnFile;
begin
  Result := aofNone;
  if not FileExists(aArquivoLocal) or (aDataDeModificacaoArquivoRemoto > GetFileModificationDate(aArquivoLocal)) then
    Result := aofDownload;
end;
{ ---------------------------------------------------------------------------- }
var
  i: Word;
  Diretorio: String;
{ ---------------------------------------------------------------------------- }
begin
  { O primeiro loop atualiza ActionOnFile de cada arquivo }
  if aMonitoredFiles.Files.Count > 0 then
    for i := 0 to Pred(aMonitoredFiles.Files.Count) do
      aMonitoredFiles.Files[i].ActionOnFile := ObterAcao(aMonitoredFiles.Files[i].TranslatedFilePath
                                                        ,aMonitoredFiles.Files[i].LastModified);

  { O segundo loop vai varrer todos os diret�rios locais que foram referenciados
  em aMonitoredFiles, verificando quem realmente precisa existir localmente e
  caso n�o precise, uma nova entrada � adicionada em aMonitoredFiles com
  ActionOnFile configurada como aofDelete }
  with TStringList.Create do
    try
      CallbackData.MonitoredFiles := aMonitoredFiles;

      for i := 0 to Pred(aMonitoredFiles.Files.Count) do
      begin
        Diretorio := ExtractFilePath(aMonitoredFiles.Files[i].TranslatedFilePath);

        if IndexOfPart(Diretorio) = -1 then
        begin
          ProcessTree(Diretorio, '*.*', True, ProcessarArquivos, ProcessarDiretorios);
          Add(Diretorio);
        end;
      end;
    finally
      Free;
    end;
end;

procedure TDataModule_Principal.RealizarAtualizacao(const aProgressBarArquivo
                                                        , aProgressBarGeral: TProgressBar;
                                                          aRichEdit: TRichEdit;
                                                    const aLabelPercentArquivo
                                                        , aLabelPercentGeral: TLabel);
var
  MF: TMonitoredFiles;
  Formato: Byte;
  i, ArquivosABaixar, ArquivosAExcluir, DiretoriosAExcluir: Cardinal;
begin
  RessetarProgressos;
  
  { TODO -oCARLOS FEITOZA -cMELHORIA : Verifique aqui se existem m�dulos abertos }
  with TIniFile.Create(ChangeFileExt(Application.ExeName,'.ini')) do
    try
      PararAutoChecagem;
      // Por padr�o, o local de instala��o de arquivos, quando n�o especificado
      // explicitamente � C:\<NOMEDOSISTEMA> OU C:\MPSUPDATER quando um nome de
      // sistema n�o tiver sido especificado nas configura��es
      MF := TMonitoredFiles.Create(Self,'C:\' + ReadString('CONFIGURACOES','SISTEMA','MPSUPDATER'));
      try
        Form_Principal.RichEdit_Log.Clear;

        Conectar(FtpClient_Principal
                ,ReadString('CONEXAO','HOST','127.0.0.1')
                ,ReadInteger('CONEXAO','PORT',21)
                ,Form_Principal.RichEdit_Log);

        Autenticar(FtpClient_Principal
                  ,ReadString('AUTENTICACAO','USER','')
                  ,Decrypt(ReadString('AUTENTICACAO','PASS',''),12985)
                  ,Form_Principal.RichEdit_Log);

        InitializeProgress(aProgressBarGeral,aLabelPercentGeral,1);

        ObterListaDeArquivosMonitorados(aProgressBarArquivo
                                       ,aRichEdit);

        SetProgressWith(aProgressBarGeral,aLabelPercentGeral,1);

        { A partir deste ponto temos uma lista com os arquivos que precisam ser
        obtidos do servidor (Arquivos modificados). Caso este arquivo contenha
        uma lista vazia, significa que n�o h� arquivos modificados desde nossa
        �ltima verifica��o }
        Formato := ReadInteger('CONFIGURACOES','FORMATO',TXT);

        if Formato = TXT then
          MF.LoadFromTextualRepresentation(LoadTextFile(FFTPDirectory + '\' + MONITOREDFILESLIST))
        else if Formato = BIN then
          MF.LoadFromBinaryFile(FFTPDirectory + '\' + MONITOREDFILESLIST);

        if MF.Files.Count > 0 then
        begin
          ShowOnLog(PutLineBreaks('� Processando lista de arquivos monitorados...',89),Form_Principal.RichEdit_Log);
          { Varre MF, marcando cada arquivo de acordo com a a��o que ser�
          executada localmente e adiciona a ele arquivos que precisam ser
          exclu�dos }
          ConfigurarAcoes(MF);

//          with TStringList.Create do
//            try
//              Text := MF.ToString;
//              SaveToFile('d:\carlos.txt');
//            finally
//              Free;
//            end;
//          exit;

          { Finalmente, atualizando os arquivos... }
          ArquivosABaixar    := MF.Files.DownloadCount;
          ArquivosAExcluir   := MF.Files.DeleteFileCount;
          DiretoriosAExcluir := MF.Files.DeleteDirCount;

          if (ArquivosABaixar + ArquivosAExcluir + DiretoriosAExcluir) > 0 then
          begin
            { Usa as contagens das atualiza��es mais exclus�es }
            InitializeProgress(aProgressBarGeral,aLabelPercentGeral,ArquivosABaixar + ArquivosAExcluir + DiretoriosAExcluir);

            ShowOnLog(PutLineBreaks('� A lista cont�m ' + IntToStr(ArquivosABaixar) + ' download(s), ' + IntToStr(ArquivosAExcluir) + ' exclus�o(�es) de arquivo(s) e ' + IntToStr(DiretoriosAExcluir) + ' exclus�o(�es) de diret�rio(s).',89),Form_Principal.RichEdit_Log);

            { O primeiro loop processa apenas arquivos, excluindo-os ou
            baixando-os segundo a necessidade }
            for i := 0 to Pred(MF.Files.Count) do
              if MF.Files[i].ActionOnFile in [aofDownload,aofDeleteFile] then
                try
                  try
                    if MF.Files[i].ActionOnFile = aofDownload then
                    begin
                      ObterArquivoAtualizado(aProgressBarArquivo
                                            ,MF.Directory
                                            ,MF.Files[i]
                                            ,aRichEdit);
                      Dec(ArquivosABaixar);
                    end
                    else if MF.Files[i].ActionOnFile = aofDeleteFile then
                    begin
                      ExcluirArquivo(MF.Files[i].FilePath,aRichEdit);
                      Dec(ArquivosAExcluir);
                    end
                  except
                    { De todas as exce��es lan�adas, apenas EInvalidPath e
                    EUnsuccessfulExclusion devem ser silenciosa e n�o impedir o
                    restante do processamento. Todas as outras exce��es s�o passadas
                    adiante }
                    on E: EInvalidPath do ShowOnLog(PutLineBreaks('! ' + E.Message,89),Form_Principal.RichEdit_Log);
                    on E: EUnsuccessfulExclusion do ShowOnLog(PutLineBreaks('! ' + E.Message,89),Form_Principal.RichEdit_Log);
                    else
                      raise;
                  end;
                finally
                  IncreaseProgress(aProgressBarGeral,aLabelPercentGeral);
//                  SetProgressWith(aProgressBarGeral,aLabelPercentGeral,Succ(i))
                end;

            { O segundo loop processa apenas diret�rios, excluindo-os ou
            baixando-os segundo a necessidade }
            for i := 0 to Pred(MF.Files.Count) do
              if MF.Files[i].ActionOnFile = aofDeleteDir then
                try
                  try
                    if MF.Files[i].ActionOnFile = aofDeleteDir then
                    begin
                      ExcluirDiretorio(MF.Files[i].FilePath,aRichEdit);
                      Dec(DiretoriosAExcluir);
                    end;
                  except
                    { De todas as exce��es lan�adas, apenas EInvalidPath e
                    EUnsuccessfulExclusion devem ser silenciosa e n�o impedir o
                    restante do processamento. Todas as outras exce��es s�o passadas
                    adiante }
                    on E: EInvalidPath do ShowOnLog(PutLineBreaks('! ' + E.Message,89),Form_Principal.RichEdit_Log);
                    on E: EUnsuccessfulExclusion do ShowOnLog(PutLineBreaks('! ' + E.Message,89),Form_Principal.RichEdit_Log);
                    else
                      raise;
                  end;
                finally
                  IncreaseProgress(aProgressBarGeral,aLabelPercentGeral);
//                  SetProgressWith(aProgressBarGeral,aLabelPercentGeral,Succ(i))
                end;

            { Caso todos os arquivos tenham sido processados, mostra a mensagem de
            erro, do contr�rio informa que problemas aconteceram }
            if (ArquivosABaixar = 0) and (ArquivosAExcluir = 0) and (DiretoriosAExcluir = 0) then
            begin
              ShowOnLog(PutLineBreaks(LOGTEXT2,89),Form_Principal.RichEdit_Log);
              ConfigureBalloonHint(2);

              { No final do procedimento devemos salvar a data da nossa �ltima
              sincroniza��o bem sucedida }
              WriteFloat('ULTIMASINCRONIZACAO','DATA',Now);
              UpdateFile; // Atualiza o arquivo imediatamente!
              UpdateLastSynchronizationInfo;
            end
            else
            begin
              ShowOnLog(PutLineBreaks(LOGTEXT3,89),Form_Principal.RichEdit_Log);
              ConfigureBalloonHint(3);
            end;
          end
          else
          begin
            ShowOnLog(PutLineBreaks(LOGTEXT1,89),Form_Principal.RichEdit_Log);
            ConfigureBalloonHint(4);
          end;
        end
        else
        begin
          ShowOnLog(PutLineBreaks(LOGTEXT1,89),Form_Principal.RichEdit_Log);
          ConfigureBalloonHint(4);
        end;
        { Sempre exibe o bal�o, mas ele s� ser� efetivamente exibido se a
        aplica��o estiver minimizada na barra de tarefas, portanto � seguro
        chamar incondicionalmente aqui }
        TrayIcon_Principal.ShowBalloonHint;
      except
        on E: Exception do
          ShowOnLog(PutLineBreaks('! ' + E.Message,89),Form_Principal.RichEdit_Log);
      end;

    finally
      if FtpClient_Principal.Connected then
        Desconectar(FtpClient_Principal
                   ,Form_Principal.RichEdit_Log);

      MF.Free;
      Free;
      ContinuarAutoChecagem;
    end;
end;

procedure TDataModule_Principal.RealizarAtualizacao;
begin
  UpdateLastSynchronizationInfo;

  RealizarAtualizacao(Form_Principal.ProgressBar_Arquivo
                     ,Form_Principal.ProgressBar_Geral
                     ,Form_Principal.RichEdit_Log
                     ,Form_Principal.Label_ProgressDoArquivo
                     ,Form_Principal.Label_ProgressGeral);
end;

procedure TDataModule_Principal.RealizarChecagem;
begin
  UpdateLastSynchronizationInfo;

  RealizarChecagem(Form_Principal.ProgressBar_Arquivo
                  ,Form_Principal.ProgressBar_Geral
                  ,Form_Principal.RichEdit_Log
                  ,Form_Principal.Label_ProgressDoArquivo
                  ,Form_Principal.Label_ProgressGeral);
end;

procedure TDataModule_Principal.RessetarProgressos;
begin
  InitializeProgress(Form_Principal.ProgressBar_Arquivo,Form_Principal.Label_ProgressDoArquivo,0);
  InitializeProgress(Form_Principal.ProgressBar_Geral,Form_Principal.Label_ProgressGeral,0);
end;

procedure TDataModule_Principal.RealizarChecagem(const aProgressBarArquivo
                                                     , aProgressBarGeral: TProgressBar;
                                                       aRichEdit: TRichEdit;
                                                 const aLabelPercentArquivo
                                                     , aLabelPercentGeral: TLabel);
var
  MF: TMonitoredFiles;
  Formato: Byte;
  ArquivosABaixar, ArquivosAExcluir, DiretoriosAExcluir: Cardinal;
begin
  RessetarProgressos;

  with TIniFile.Create(ChangeFileExt(Application.ExeName,'.ini')) do
    try
      PararAutoChecagem;
      MF := TMonitoredFiles.Create(Self,'C:\' + ReadString('CONFIGURACOES','SISTEMA','MPSUPDATER'));
      try
        Form_Principal.RichEdit_Log.Clear;

        Conectar(FtpClient_Principal
                ,ReadString('CONEXAO','HOST','127.0.0.1')
                ,ReadInteger('CONEXAO','PORT',21)
                ,Form_Principal.RichEdit_Log);

        Autenticar(FtpClient_Principal
                  ,ReadString('AUTENTICACAO','USER','')
                  ,Decrypt(ReadString('AUTENTICACAO','PASS',''),12985)
                  ,Form_Principal.RichEdit_Log);

        InitializeProgress(aProgressBarGeral,aLabelPercentGeral,1);

        ObterListaDeArquivosMonitorados(aProgressBarArquivo
                                       ,aRichEdit);

        SetProgressWith(aProgressBarGeral,aLabelPercentGeral,1);

        { A partir deste ponto temos uma lista com os arquivos que precisam ser
        obtidos do servidor (Arquivos modificados). Caso este arquivo contenha
        uma lista vazia, significa que n�o h� arquivos modificados desde nossa
        �ltima verifica��o }
        Formato := ReadInteger('CONFIGURACOES','FORMATO',TXT);

        if Formato = TXT then
          MF.LoadFromTextualRepresentation(LoadTextFile(FFTPDirectory + '\' + MONITOREDFILESLIST))
        else if Formato = BIN then
          MF.LoadFromBinaryFile(FFTPDirectory + '\' + MONITOREDFILESLIST);


        { Neste ponto existem arquivos que precisam ser obtidos do servidor.
        Toda informa��o est� dispon�vel. � s� baixar cada coisa em seu lugar }
        if MF.Files.Count > 0 then
        begin
          ShowOnLog(PutLineBreaks('� Processando lista de arquivos monitorados...',89),Form_Principal.RichEdit_Log);
          { Detectando poss�veis atualiza��es }
          ConfigurarAcoes(MF);

//          with TStringList.Create do
//            try
//              Text := MF.ToString;
//              SaveToFile('d:\carlos.txt');
//            finally
//              Free;
//            end;

          ArquivosABaixar    := MF.Files.DownloadCount;
          ArquivosAExcluir   := MF.Files.DeleteFileCount;
          DiretoriosAExcluir := MF.Files.DeleteDirCount;

          if (ArquivosABaixar + ArquivosAExcluir + DiretoriosAExcluir) > 0 then
          begin
            ShowOnLog(PutLineBreaks('� A lista cont�m ' + IntToStr(ArquivosABaixar) + ' download(s), ' + IntToStr(ArquivosAExcluir) + ' exclus�o(�es) de arquivo(s) e ' + IntToStr(DiretoriosAExcluir) + ' exclus�o(�es) de diret�rio(s).',89),Form_Principal.RichEdit_Log);
            ShowOnLog(PutLineBreaks(LOGTEXT0,89),Form_Principal.RichEdit_Log);
            ConfigureBalloonHint(1);
            TrayIcon_Principal.ShowBalloonHint;
          end
          else
            ShowOnLog(PutLineBreaks(LOGTEXT1,89),Form_Principal.RichEdit_Log);
        end
        else
          ShowOnLog(PutLineBreaks(LOGTEXT1,89),Form_Principal.RichEdit_Log);

      except
        on E: Exception do
          ShowOnLog(PutLineBreaks('! ' + E.Message,89),Form_Principal.RichEdit_Log);
      end;

    finally
      if FtpClient_Principal.Connected then
        Desconectar(FtpClient_Principal
                   ,Form_Principal.RichEdit_Log);

      MF.Free;
      Free;
      ContinuarAutoChecagem;
    end;
end;

procedure TDataModule_Principal.ShowErrorMessage(aText: String; aRichEdit: TRichEdit);
begin
  ShowOnLog(PutLineBreaks(aText,89),aRichEdit);

  if TrayIcon_Principal.Visible then
  begin
    TrayIcon_Principal.BalloonTitle := 'MPS Updater: Problema ao executar tarefa!';
    TrayIcon_Principal.BalloonFlags := bfError;
    TrayIcon_Principal.BalloonHint  := Copy(aText,3,Length(aText));
    TrayIcon_Principal.ShowBalloonHint;
  end;
end;

{ TAutoChecagem }

constructor TAutoChecagem.Create(aCreateSuspended: Boolean);
begin
  inherited;

end;

procedure TAutoChecagem.Execute;
begin
  inherited;
  if FIntervaloDeChecagem > 0 then
  begin
    { O loop � infinito mesmo pois esta fun��o ficar� executando eternamente
    dentro de seu pr�prio thread }
    while True do
    begin
      { Este loop aguarda uma quantidade espec�fica de minutos. Quando esta
      quantidade de minutos passa, o loop acaba }
      while Now < FProximaChecagem do
      begin
        { Se o Thread tiver acabado, sai imediatamente sem fazer mais nada! }
        if Terminated then
          Break;

        Synchronize(DataModule_Principal.AtualizarTextoAutoChecagem);
      end;

      if Terminated then
        Exit;

      FProximaChecagem := IncMinute(FProximaChecagem,FIntervaloDeChecagem);

      { Quando o fluxo chega neste ponto uma nova verifica��o � feita e em seguida
      o tempo de nova checagem � recalculado e... }
      Synchronize(DataModule_Principal.RealizarChecagem);

//      Application.ProcessMessages;
    end;
  end;
end;

{ TTrayIcon }

procedure TTrayIcon.WindowProc(var Message: TMessage);
begin
  case Message.Msg of
    WM_SYSTEM_TRAY_MESSAGE: begin
      case Message.lParam of
        NIN_BALLOONUSERCLICK: begin
          case OnClickFor of
            1: TDataModule_Principal(Owner).AtivarEAtualizar;
            3: TDataModule_Principal(Owner).Action_RestaurarTela.Execute; 
          end;
        end
        else
          inherited;
      end;
    end;
  else
    Inherited;
  end;
end;

{ TStringList }

function TStringList.IndexOfPart(const S: String): Integer;
var
  i: Cardinal;
begin
  Result := -1;
  if Count > 0 then
    for i := 0 to Pred(Count) do
      if Pos(S,Strings[i]) > 0 then
      begin
        Result := i;
        Break;
      end;
end;

end.
