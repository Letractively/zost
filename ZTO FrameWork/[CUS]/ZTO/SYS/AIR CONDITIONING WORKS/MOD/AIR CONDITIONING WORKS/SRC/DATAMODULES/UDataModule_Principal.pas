unit UDataModule_Principal;

{ DataModule comum. Copyright 2010 / 2011 ZTO Soluções Tecnológicas Ltda. }

interface

uses
  Windows, SysUtils, Classes, Controls, Forms, ExtCtrls,
  Menus, ActnPopup, ActnList, ZConnection, DB, ZAbstractRODataset, ZDataset,
  ZTO.Win32.Db.ZeosLib.MySQL.Types, ZSqlProcessor, UZTODataModule_Regioes,
  UBalloonToolTip, ZTO.Components.Standard.HotSpots, ZTO.Wizards.FormTemplates.DataModule,
  PlatformDefaultStyleActnCtrls;

type
  TDataModule_Principal = class(TDataModule)
    TrayIcon_Splash: TTrayIcon;
    PopupActionBar_TrayIcon: TPopupActionBar;
    ActionList_TrayIcon: TActionList;
    Action_Sobre: TAction;
    Action_Fechar: TAction;
    Action_Trabalhos: TAction;
    rabalhos1: TMenuItem;
    Sobre1: TMenuItem;
    Fechar1: TMenuItem;
    N1: TMenuItem;
    MenuItem_TabelasAuxiliares: TMenuItem;
    Action_Regioes: TAction;
    Action_Situacoes: TAction;
    Regies1: TMenuItem;
    Situaes1: TMenuItem;
    MenuItem_Relatorios: TMenuItem;
    Action_RelTrabalhos: TAction;
    MenuItem_RelTrabalhos: TMenuItem;
    Action_RelPropostas: TAction;
    MenuItem_RelPropostas: TMenuItem;
    ACW: TZConnection;
    procedure ZTODataModuleCreate(Sender: TObject);
    procedure Action_FecharExecute(Sender: TObject);
    procedure ACWAfterConnect(Sender: TObject);
    procedure Action_RegioesExecute(Sender: TObject);
    procedure DataModuleDestroy(Sender: TObject);
  private
    { Declarações privadas }
    FModules: TList;
    FZTODataModule_Regioes: TZTODataModule_Regioes;
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
    procedure DoAfterExecute(aProcessor: TZSQLProcessor; aStatementIndex: Integer);
    procedure DoBeforeExecute(aProcessor: TZSQLProcessor; aStatementIndex: Integer);
  protected
    { Declarações protegidas }
    FDiretorioAtual: String;
  public
    { Declarações públicas }
  end;

var
  DataModule_Principal: TDataModule_Principal;

implementation

uses ZTO.Win32.Rtl.Common.FileUtils
   , ZTO.Win32.Rtl.Sys.Types
   , ZTO.Win32.Rtl.Common.Classes
   , ZTO.Win32.Rtl.Common.Classes.Interposer
   , ZTO.Win32.Db.Controls.Utils
   , ZTO.Win32.Db.ZeosLib.MySQL.Utils
   , CFDBValidationChecks
   , UForm_Splash;

resourcestring
  RS_DATABASENAME = 'ACW';
  SOFTWARE_ID     = '00000000000000000000000000000000';

const
  DROPDATABASE = True;

//function GetAuthorizationFile(aSoftwareId: PChar): PChar; external 'zolm.dll';

{$R *.dfm}

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

procedure TDataModule_Principal.Action_RegioesExecute(Sender: TObject);
begin
  { montar uma coleção de variaveis para guardar todos os forms }
  if not Assigned(FZTODataModule_Regioes) then
  begin
    AddModule(@FZTODataModule_Regioes);

    TZTODataModule_Regioes.CreateDataModule(Self
                                           ,FZTODataModule_Regioes
                                           ,TZTODataModule_Regioes
                                           ,cmAutoFree);
  end;
end;

procedure TDataModule_Principal.ACWAfterConnect(Sender: TObject);
var
  DataBaseACWCriada, DataBaseMySQLCriada: Boolean;
begin
  with TZReadOnlyQuery.Create(Self) do
    try
      Connection := ACW;
      Close;

      SQL.Text := 'SHOW DATABASES WHERE UPPER(`DATABASE`) = ''ACW''';
      Open;

      DataBaseACWCriada := RecordCount = 1;

      SQL.Text := 'SHOW DATABASES WHERE UPPER(`DATABASE`) = ''MYSQL''';
      Open;

      DataBaseMySQLCriada := RecordCount = 1;
    finally
      Close;
      Free;
    end;

  if not DataBaseMySQLCriada then
  begin
    Form_Splash.Label_StatusInicial.Show;

    // Banco De Dados
    Form_Splash.Label_StatusInicial.Caption := 'Primeira execução: Criando esquema do sistema...'#13#10'Criando esquema propriamente dito...';
    Form_Splash.Update;
    MySQLExecuteSQLScript(ACW
                         ,'DROP DATABASE IF EXISTS MYSQL; CREATE DATABASE IF NOT EXISTS MYSQL DEFAULT CHARACTER SET LATIN1; USE MYSQL;');

    // Tabelas de Sistema
    Form_Splash.Label_StatusInicial.Caption := 'Primeira execução: Criando esquema do sistema...'#13#10'Criando tabelas do sistema...';
    Form_Splash.Update;
    MySQLExecuteSQLScript(ACW
                         ,FDiretorioAtual + '\DAT\SHARE\mysql_system_tables.sql');

    // Preenchendo Tabelas do sistema
    Form_Splash.Label_StatusInicial.Caption := 'Primeira execução: Criando esquema do sistema...'#13#10'Preenchendo tabelas do sistema...';
    Form_Splash.Update;
    MySQLExecuteSQLScript(ACW
                         ,FDiretorioAtual + '\DAT\SHARE\mysql_system_tables_data.sql');

    // Preenchendo Tabelas de ajuda do sistema
    Form_Splash.Label_StatusInicial.Caption := 'Primeira execução: Criando esquema do sistema...'#13#10'Preenchendo tabelas de ajuda do sistema...';
    Form_Splash.Update;
    MySQLExecuteSQLScript(ACW
                         ,FDiretorioAtual + '\DAT\SHARE\fill_help_tables.sql');
  end;

  if not DataBaseACWCriada then
  begin
    Form_Splash.Label_StatusInicial.Show;
    MySQLExecuteSQLScript(ACW
                         ,LoadZLibCompressedTextFile(FDiretorioAtual + '\DAT\SHARE\ACW.SQL',DoZLibNotification)
                         ,DoExecuteSQLScript);
  end;

  if not (DataBaseMySQLCriada and DataBaseACWCriada) then
  begin
    Form_Splash.Label_StatusInicial.Caption := 'Todos os esquemas criados com sucesso!'#13#10'Continuando a carregar o Air Conditioning Works...';
    Form_Splash.Update;
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
      Form_Splash.Label_StatusInicial.Caption := 'Primeira execução: Criando esquema do Air Conditioning Works...'#13#10'Descomprimindo script de criação...';
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
      Form_Splash.Label_StatusInicial.Caption := 'Primeira execução: Criando esquema do Air Conditioning Works...'#13#10'Executando script de criação...';
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

(*
antigamente processor events fazia o abaixo
mas agora com a nova implementação eu não sei se é necessário
acima, eu usei exatamente oque existia no GymWorks, mas não sei se funciona bem...
ainda nao testei
procedure TProcessorEvents.DoAfterExecute(aProcessor: TZSQLProcessor; aStatementIndex: Integer);
begin
	if Assigned(FProgressBarCurrent) then
  begin
    FProgressBarCurrent.StepIt;
    Application.ProcessMessages;
  end;
end;

procedure TProcessorEvents.DoBeforeExecute(aProcessor: TZSQLProcessor; aStatementIndex: Integer);
begin
  if Assigned(FLabelCurrentDescription) and Assigned(FLabelCurrentValue) then
  begin
    SetLabelDescriptionValue(FLabelCurrentDescription
                            ,FLabelCurrentValue
                            ,IntToStr(Succ(aStatementIndex)) + ' / ' + IntToStr(aProcessor.StatementCount));
    Application.ProcessMessages;
  end;
end;
*)

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


procedure TDataModule_Principal.ZTODataModuleCreate(Sender: TObject);
begin
//verifica se existe zolm.lic
//se existe usa.
//se nao existe conecta obtem e salva
//em seguida usa (volta pro inicio)

//ao usar compara se é autorizado a rodar no HD onde o programa está atualmente instalado
//o arquivo deve estar criptografado. A chave de descriptografia deve ser o SOFTWAREID
//  MessageBox(0,GetAuthorizationFile(PChar(SOFTWARE_ID)),'xxx',0);

  FDiretorioAtual := GetCurrentDir;

  Form_Splash.Show;
  Form_Splash.Update;

  ACW.Connect;

  Form_Splash.DelayedHide(1);

  Application.OnException := DoException;

  FModules := TList.Create;
end;

end.
