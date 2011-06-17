unit UDataModule_Principal;

{ DataModule comum. Copyright 2010 / 2011 ZTO Soluções Tecnológicas Ltda. }

interface

uses
  Windows, SysUtils, Classes, Controls, Forms, ExtCtrls,
  Menus, ActnPopup, ActnList, ZConnection, DB, ZAbstractRODataset, ZDataset,
  ZSqlProcessor, UBalloonToolTip,
  ZTO.Wizards.FormTemplates.DataModule, ZTO.Win32.Db.ZeosLib.MySQL.Utils, ZTO.Win32.Db.ZeosLib.MySQL.Types,
  PlatformDefaultStyleActnCtrls,
  UZTODataModule_Clientes, Mdl.Lib.Configuracoes;

type
  TDataModule_Principal = class(TDataModule)
    TrayIcon_Splash: TTrayIcon;
    PopupActionBar_TrayIcon: TPopupActionBar;
    ActionList_TrayIcon: TActionList;
    Action_Sobre: TAction;
    Action_Fechar: TAction;
    Action_Clientes: TAction;
    rabalhos1: TMenuItem;
    Sobre1: TMenuItem;
    Fechar1: TMenuItem;
    N1: TMenuItem;
    Action_Usuarios: TAction;
    Regies1: TMenuItem;
    MenuItem_Relatorios: TMenuItem;
    Action_RelClientes: TAction;
    MenuItem_RelTrabalhos: TMenuItem;
    GYMWORKS: TZConnection;
    Cadastros: TMenuItem;
    procedure ZTODataModuleCreate(Sender: TObject);
    procedure Action_FecharExecute(Sender: TObject);
    procedure GYMWORKSAfterConnect(Sender: TObject);
    procedure Action_UsuariosExecute(Sender: TObject);
    procedure DataModuleDestroy(Sender: TObject);
    procedure Action_ClientesExecute(Sender: TObject);
    procedure GYMWORKSBeforeConnect(Sender: TObject);
  private
    { Declarações privadas }
//    FProcessorEvents: TProcessorEvents;
    FModules: TList;
    FConfiguracoes: TConfiguracoes;
    FZTODataModule_Clientes: TZTODataModule_Clientes;
    procedure DoBeforeExecute(aProcessor: TZSQLProcessor; aStatementIndex: Integer);
    procedure DoAfterExecute(aProcessor: TZSQLProcessor; aStatementIndex: Integer);
    procedure DoZLibNotification(aSender: TObject);
    procedure DoExecuteSQLScript(const aProcessor: TZSQLProcessor;
                                 const aExecuteSQLScriptEvent: TExecuteScriptEvent;
                                 const aScriptParts: TScriptParts);
    procedure DoException(aSender: TObject;
                          aE     : Exception);
    procedure ShowBalloonToolTipValidationFor(aForm      : TCustomForm;
                                              aDataSet   : TDataSet;
                                              aFieldError: TField);
    procedure AddModule(aModule: PZTODataModule);
    function InsertingOrUpdating: Boolean;
    procedure CancelAllOperations;
    procedure BancoConfigurado(aSim: Boolean);
    procedure AcessoConfigurado;
  protected
    { Declarações protegidas }
    FDiretorioAtual: String;
  public
    { Declarações públicas }
  end;

var
  DataModule_Principal: TDataModule_Principal;

implementation

{$R *.dfm}

uses ZTO.Win32.Rtl.Common.FileUtils
   , ZTO.Win32.Rtl.Sys.Types
   , ZTO.Win32.Rtl.Common.Classes
   , ZTO.Win32.Rtl.Common.Classes.Interposer
   , ZTO.Win32.Db.Controls.Utils
   , CFDBValidationChecks
   , UForm_Splash
   , UZTODialog_Configuracoes
   , UZTODialog_Login
   , ZDBCIntfs;

const
  { FUNCIONA COM ANSISTRINGS MAS TEM ALGUM LIXO. TENTE USAR SOFTWARE_ID SEPARADO
  EM QUATRO PARTES NUMERCIAS OU HEXA!!! salve uma versão criptografada, que seja
  diferente daquilo que é visto na tela, pode ser um sha1 de 1 md5 ou vice versa.
  vice versa é melhor (md5 de um sha1) COLOQUE ESTAS CONSTANTES COMO RECURSOS
  DENTRO DE UMA DLL SEPARADA. CADA DLL TERÁ SEU NUMERO DE SERIE. OS EXECUTÁVEIS
  SERÃO OS MESMOS MAS CADA DLL SO FUNCIONA PARA UM HD E O EXECUTAVEL NAO FUNCIONA
  SEM A DLL. VOCÊ PODE ANEXAR UMA IMAGEM DE TAMANHO FIXO COM UMA ESTEGANOGRAFIA
  E AO LER A IMAGEM DO RECURSO VOCÊ TERA UM VALOR CRIPTOGRAFADO QUE É O SERIAL.
  VOCE PDOE CHAMAR O RECURSO DE IMAGEM DE ETIQUETA, IMEI, ROTULO OU MESMO LICENÇA.
  NAO ADIANTA A PESSOA SABER QUE EXISTE A IIMAGEM E QUE ELA É A LICENÇA SE ELA NAO
  SOUBER COMO A IMAGEM ESTÁ CODIFICADA. PODE SER UMA IMAGEM RAW. VOCE PODE USAR
  RCDATA E GRAVAR LA AS INFORMACOES.

  1. USE AS INSTRUÇÕES EM
     http://delphi.about.com/od/objectpascalide/a/embed_resources.htm
     PARA CRIAR UM ARQUIVO RC COM O RCDATA.
  2. CRIE UM PROGRAMA QUE ALTERE NO DLL ZOLM.DLL O RCDATA. A CADA EXECUÇÃO O
     RCDATA TERA UM SOFTWAREID DIFERENTE. UMA DAS OPÇÕES DO PROGRAMA É GERAR
     VARIAS COPIAS DO DLL, CADA UMA COM UM RCDATA DISTINTO. OUTRA OPÇÃO SERIA
     OBTER O RCDATA DE UM DLL.
  3. O DLL NÃO VAI JUNTO COM A APLICAÇÃO. ELE É RECEBIDO POR FORA COMO PARTE DA
     LICENÇA
  4. AO EXECUTAR A APLICAÇÃO PELA PRIMEIRA VEZ, CASO NÃO HAJA UM DLL O MESMO
     SERÁ BAIXADO, MEDIANTE INFORMAÇÃO DADA PELO USUÁRIO (CLIENTE). CADA CLIENTE
     TEM APENAS 1 DLL REGISTRADO E ESTE DLL SERÁ AUTORIZADO DE FORMA ONLINE A
     RODAR EM UM DETERMINADO HD.
  5. O CLIENTE COPIA O DLL EM UM COMPUTADOR AUTORIZADO E EXECUTA O PROGRAMA.
     CASO UM ARQUIVO DE LICENÇA EXISTA ELE SERA CONSULTADO PARA SABER SE O HD
     CRIPTOGRAFADO + SOFTWAREID (LOCAIS) = A LICENÇA SALVA NO ARQUIVO. SE NÃO
     FOR SERÁ FEITA UMA CONSULTA ONLINE E SE A LICENÇA FOR VALIDA PARA O HD
     ENTÃO O ARQUIVO DE LICENÇA SERÁ ATUALIZADO
  6. O ARQUIVO DE LICENÇA DEVE SER UM ARQUIVO DO TIPO TOBJECTFILE COM UMA LISTA
     INTERNA DE LICENÇAS
  7. DE FORMA ONLINE CADA LICENÇA COMPRADA SERÁ REGISTRADA. AO ACABAR AS
     LICENÇAS NAO SERÁ MAIS POSSIVEL REGISTRAR.
  8. LICENÇAS PODEM SER TROCADAS (PARA EXECUÇÃO EM OUTRO HD) MEDIANTE PAGAMENTO
  9. O PROCEDIMENTO DE TROCA DE LICENÇA É MUITO COMPLICADO POIS DÁ MARGEM A
     FRAUDES

   }
  TOKEN_INI_MD5 = '6011b182ab9cbf6b54ad03ab87080067';
  SOFTWARE_ID = '00000000000000000000000000000000';
  TOKEN_FIM_MD5 = '68f41f0b90452d121013868a936bbf9e';

resourcestring
  RS_DATABASENAME = 'GYMWORKS';

const
  DROPDATABASE = True;
  CONFIG_FILE     = 'CONFIG.DAT';

//function GetAuthorizationFile(aSoftwareId: PChar): PChar; external 'zolm.dll';

procedure TDataModule_Principal.Action_ClientesExecute(Sender: TObject);
begin
  if not Assigned(FZTODataModule_Clientes) then
  begin
    AddModule(@FZTODataModule_Clientes);

    TZTODataModule_Clientes.CreateDataModule(Self
                                            ,FZTODataModule_Clientes
                                            ,TZTODataModule_Clientes
                                            ,cmAutoFree);
  end;
end;

procedure TDataModule_Principal.Action_FecharExecute(Sender: TObject);
begin
  if InsertingOrUpdating then
  begin
    if Application.MessageBox('Ainda existem módulos abertos com alterações não confirmadas. Tem certeza de que deseja fechar o ACW e perder todas as alterações não salvas?','Alterações não confirmadas',MB_ICONWARNING or MB_YESNO) = IDYES then
    begin
      CancelAllOperations;
      Form_Splash.CloseForm(False);
    end;
  end
  else
    Form_Splash.CloseForm;
end;

procedure TDataModule_Principal.Action_UsuariosExecute(Sender: TObject);
begin
  { montar uma coleção de variaveis para guardar todos os forms }
//  if not Assigned(FZTODataModule_Regioes) then
//  begin
//    AddModule(@FZTODataModule_Regioes);
//
//    TZTODataModule_Regioes.CreateDataModule(Self
//                                           ,FZTODataModule_Regioes
//                                           ,TZTODataModule_Regioes
//                                           ,cmAutoFree);
//  end;
end;

procedure TDataModule_Principal.BancoConfigurado(aSim: Boolean);
begin
  FConfiguracoes.BancoConfigurado := aSim;
  FConfiguracoes.SaveToBinaryFile(FDiretorioAtual + '\' +CONFIG_FILE);
end;

procedure TDataModule_Principal.AcessoConfigurado;
begin
  FConfiguracoes.AcessoConfigurado := True;
  FConfiguracoes.SaveToBinaryFile(FDiretorioAtual + '\' +CONFIG_FILE);
end;

procedure TDataModule_Principal.GYMWORKSBeforeConnect(Sender: TObject);
begin
  if not FConfiguracoes.BancoConfigurado then
    GYMWORKS.Database := 'MYSQL'
  else
    GYMWORKS.Database := FConfiguracoes.DBEsquema;

  GYMWORKS.HostName := FConfiguracoes.DBHost;
  GYMWORKS.Password := FConfiguracoes.DBSenha;
  GYMWORKS.Port     := FConfiguracoes.DBPorta;
  GYMWORKS.Protocol := FConfiguracoes.DBProtocolo;
  GYMWORKS.TransactIsolationLevel := FConfiguracoes.DBIsolamentoTransacional;
  GYMWORKS.User     := FConfiguracoes.DBUsuario;

  { Força a "desconfiguração" do banco de dados de forma que isso seja
  confirmado ou não no AfterConnect }
  BancoConfigurado(False);
end;

procedure TDataModule_Principal.GYMWORKSAfterConnect(Sender: TObject);
var
  EsquemaCriado: Boolean;
begin
  { Se chegou aqui, conseguiu conectar no banco de dados, logo, confirma que
  está ok a configuração de banco de dados }
  if not FConfiguracoes.BancoConfigurado then
    BancoConfigurado(True);

  with TZReadOnlyQuery.Create(Self) do
    try
      Connection := GYMWORKS;
      Close;

      SQL.Text := 'SHOW DATABASES LIKE ''' + RS_DATABASENAME + '''';
      Open;

      EsquemaCriado := RecordCount = 1;

    finally
      Close;
      Free;
    end;

  if not EsquemaCriado then
  begin
    Form_Splash.Show;
    Form_Splash.Update;

    Form_Splash.Label_StatusInicial.Show;

    if IsZLibCompressedFile(FDiretorioAtual + '\RES\DBA\SQL\GYMWORKS.SQL') then
      MySQLExecuteSQLScript(GYMWORKS
                           ,LoadZLibCompressedTextFile(FDiretorioAtual + '\RES\DBA\SQL\GYMWORKS.SQL',DoZLibNotification)
                           ,DoExecuteSQLScript)
    else
      MySQLExecuteSQLScript(GYMWORKS
                           ,FDiretorioAtual + '\RES\DBA\SQL\GYMWORKS.SQL'
                           ,DoExecuteSQLScript);

    Form_Splash.Label_StatusInicial.Caption := 'Todos os esquemas criados com sucesso!'#13#10'Continuando a carregar o Gym Works...';
    Form_Splash.Update;
  end;

  { Se chegar aqui criou o esquema e neste caso usa-o }
  GYMWORKS.Disconnect;
  GYMWORKS.BeforeConnect := nil;
  GYMWORKS.AfterConnect := nil;
  GYMWORKS.Database := FConfiguracoes.DBEsquema;

  try
    GYMWORKS.Connect;
    { Executar aqui o form de login no sistema, nos moldes do form de configuração }
    if TZTODialog_Login.FazerLogin(GYMWORKS,FConfiguracoes) = mrCancel then
      Form_Splash.CloseForm(False)
    else
    begin
      Form_Splash.Show;
      Form_Splash.Update;
    end;
  except
    on E: Exception do
    begin
      Application.MessageBox(PWideChar(E.Message),'Erro!',MB_ICONERROR);
      Form_Splash.CloseForm(False)
    end;
    { Se der pau no connect é porque:
      1. não criou corretamente o banco anteriormente
      2. os campos do select na tela de login estão errados }
  end;
end;

procedure TDataModule_Principal.ZTODataModuleCreate(Sender: TObject);
begin
//verifica se existe zolm.lic
//se existe usa.
//se nao existe conecta obtem e salva
//em seguida usa (volta pro inicio)

//ao usar compara se é autorizado a rodar no HD onde o programa está atualmente instalado
//o arquivo deve estar criptografado. A chave de descriptografia deve ser o SOFTWAREID
//  MessageBox(0,GetAuthorizationFile(PChar(SOFTWARE_ID)),'xxx',0);
  Application.OnException := DoException;

  FDiretorioAtual := GetCurrentDir;
  FConfiguracoes := TConfiguracoes.Create(Self);
  FModules := TList.Create;

  if TZTODialog_Configuracoes.CarregarConfiguracoes(FConfiguracoes,FDiretorioAtual + '\' + CONFIG_FILE) = mrCancel then
  begin
    Application.MessageBox('A aplicação não foi configurada e será terminada agora. Para configurá-la em outro momento, execute-a novamente','Aplicação não configurada',MB_ICONINFORMATION);
    Form_Splash.CloseForm(False);
  end
  else
  begin
    try
      GYMWORKS.Connect;
      Form_Splash.DelayedHide(3);
    except
      Application.MessageBox('Não foi possível conectar-se ao banco de dados. Ele pode estar inacessível ou as configurações da aplicação estão incorretas. Por favor, tente executar a aplicação novamente. Se o problema persistir, contate o suporte técnico','Banco de dados inacessível',MB_ICONERROR);
      Form_Splash.CloseForm(False);
    end;
  end;
end;

procedure TDataModule_Principal.AddModule(aModule: PZTODataModule);
begin
  if FModules.IndexOf(aModule) = -1 then
    FModules.Add(aModule);
end;

function TDataModule_Principal.InsertingOrUpdating: Boolean;
var
  i: Word;
  ZTODataModule: TZTODataModule;
begin
  Result := False;

  if FModules.Count > 0 then
    for i := 0 to Pred(FModules.Count) do
    begin
      ZTODataModule := TZTODataModule(FModules[i]^);
      if Assigned(ZTODataModule)
         and ((ZTODataModule.DataSources.ItemsInserting <> '')
          or  (ZTODataModule.DataSources.ItemsUpdating <> '')) then
      begin
        Result := True;
        Break;
      end;
    end;
end;

procedure TDataModule_Principal.CancelAllOperations;
var
  i: Word;
  ZTODataModule: TZTODataModule;
begin
  if FModules.Count > 0 then
    for i := 0 to Pred(FModules.Count) do
    begin
      ZTODataModule := TZTODataModule(FModules[i]^);
      if Assigned(ZTODataModule) then
      begin
        ZTODataModule.DataSets.CancelAll;
        ZTODataModule.ClientDataSets.CancelAll;
      end;
    end;
end;

procedure TDataModule_Principal.DoZLibNotification(aSender: TObject);
begin
  case TDecompressionStream(aSender).Moment of
    znmBeforeProcess: begin
      Form_Splash.Label_StatusInicial.Caption := 'Primeira execução: Criando esquema do Gym Works...'#13#10'Descomprimindo script de criação...';
      Form_Splash.ProgressBar_Decompress.Step := 1;
      Form_Splash.ProgressBar_Decompress.Max := TDecompressionStream(aSender).FileSize;
      Form_Splash.ProgressBar_Decompress.Position := 0;
      Form_Splash.ProgressBar_Decompress.Show;
      Form_Splash.Update;
    end;
    znmInsideProcess: begin
      Form_Splash.ProgressBar_Decompress.Position := TDecompressionStream(aSender).Position;
      Form_Splash.Update;
    end;
    znmAfterProcess: begin
      Form_Splash.Label_StatusInicial.Caption := 'Primeira execução: Criando esquema do Gym Works...'#13#10'Executando script de criação...';
      Form_Splash.ProgressBar_Decompress.Hide;
      Form_Splash.Update;
    end;
  end;
  Form_Splash.Update;
end;

procedure TDataModule_Principal.ShowBalloonToolTipValidationFor(aForm      : TCustomForm;
                                                                aDataSet   : TDataSet;
                                                                aFieldError: TField);
var
	i: Word;
	Componente: TComponent;
	DataSet: TDataSet;
	DataField: TField;
begin
	for i := 0 to Pred(aForm.ComponentCount) do
	begin
		Componente := aForm.Components[i];

		if not IsDataWare(Componente,DataSet,DataField) then
    	Continue;

    if (DataSet <> aDataSet) or (DataField <> aFieldError) then
     	Continue;

    Form_Splash.BalloonToolTip.AssociatedWinControl := TWinControl(Componente);
    Form_Splash.BalloonToolTip.TipAlignment := taTopRight;
    Form_Splash.BalloonToolTip.Show;
    Break;
	end;
end;


procedure TDataModule_Principal.DataModuleDestroy(Sender: TObject);
begin
  FModules.Free;
  FConfiguracoes.Free;
end;

procedure TDataModule_Principal.DoException(aSender: TObject;
                                            aE     : Exception);
begin
	{ TODO : Inclua opções avançadas de Exceção }
  { Se for um erro de validação, lançado por um componente de validação, exibe
  o erro adequadamente de acordo com as opções da aplicação }
	if aE is EInvalidFieldValue then
  begin
    Form_Splash.BalloonToolTip.TipText := aE.Message;
    Form_Splash.BalloonToolTip.TipIcon := tiError;
    Form_Splash.BalloonToolTip.TipTitle := 'Erro de validação';
    ShowBalloonToolTipValidationFor(EInvalidFieldValue(aE).Form
                                   ,EInvalidFieldValue(aE).FieldError.DataSet
                                   ,EInvalidFieldValue(aE).FieldError);
  end
  else if aE is EInvalidExclusionOperation then
    MessageBox(Application.Handle,PChar(aE.Message),'Erro de validação',MB_ICONERROR)
  else
   	Application.ShowException(aE);
end;

procedure TDataModule_Principal.DoBeforeExecute(aProcessor: TZSQLProcessor; aStatementIndex: Integer);
begin
  { Nada ainda }
end;

procedure TDataModule_Principal.DoAfterExecute(aProcessor: TZSQLProcessor; aStatementIndex: Integer);
begin
  Form_Splash.ProgressBar_Instrucoes.StepIt;
  Application.ProcessMessages;
end;

procedure TDataModule_Principal.DoExecuteSQLScript(const aProcessor: TZSQLProcessor;
                                                   const aExecuteSQLScriptEvent: TExecuteScriptEvent;
                                                   const aScriptParts: TScriptParts);
begin
  case aExecuteSQLScriptEvent of
    eseBeforeExecuteScript: begin
      aProcessor.AfterExecute := DoAfterExecute;
      aProcessor.BeforeExecute := DoBeforeExecute;

      Form_Splash.ProgressBar_Blocos.Max := aScriptParts.Count;
      Form_Splash.ProgressBar_Blocos.Position := 0;
      Form_Splash.ProgressBar_Blocos.Step := 1;

      Form_Splash.ProgressBar_Blocos.Show;
      Form_Splash.ProgressBar_Instrucoes.Show;
    end;

    eseBeforeExecuteScriptPart: begin
      aProcessor.Parse;
      Form_Splash.ProgressBar_Instrucoes.Position := 0;
      Form_Splash.ProgressBar_Instrucoes.Step := 1;
      Form_Splash.ProgressBar_Instrucoes.Max := aProcessor.StatementCount;
    end;

    eseAfterExecuteScriptPart: begin
      Form_Splash.ProgressBar_Blocos.StepIt;
      Application.ProcessMessages;
    end;

    eseAfterExecuteScript: begin
      Form_Splash.ProgressBar_Blocos.Hide;
      Form_Splash.ProgressBar_Instrucoes.Hide;
    end;
  end;
end;



end.
