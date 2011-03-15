{ Este datamodule é herdado a partir do datamodule da aplicação (TBDODataModule)
e deve ser usado como ponto concentrador de todas as conexões de banco de dados }
unit UBDODataModule_Main;

interface

uses
    { VCL }
  	Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  	Dialogs, ActnList, ImgList,
	{ FRAMEWORK }
    UXXXTypesConstantsAndClasses, UXXXDataModule, _ActnList,
    { COMPONENTES }
    ZConnection, UBalloonToolTip,
    { APLICAÇÃO }
	UBDODataModule, UBDOForm_Main, UBDOForm_GeneralConfigurations,
    UBDOForm_Regioes, UBDOForm_Situacoes, UBDOForm_TiposDeObra,
    UBDOForm_Projetistas, UBDOForm_Instaladores, UBDOForm_EquipamentosEFamilias,
    UBDOForm_TabelasAuxiliares, UBDOForm_AdminModule, UBDOForm_Obras;

type
  	TBDODataModule_Main = class(TBDODataModule)
    	ZConnection_BDO: TZConnection;
    	Action_Obras: TAction;
    	Action_Regioes: TAction;
    	Action_Situacoes: TAction;
    	ImageList_Main: TImageList;
    	Action_TiposDeObra: TAction;
	    Action_Projetistas: TAction;
    	Action_Instaladores: TAction;
	    Action_EquipamentosEFamilias: TAction;
    	Action_TabelasAuxiliares: TAction;
	    Action_GeneralConfigurations: TAction;
    	Action_SecurityAndPermissions: TAction;
        Action_RelatorioObras: TAction;
        Action_RelatorioPropostas: TAction;
        Action_RelatorioFamilias: TAction;
        Action_RelatorioEquipamentosPorSituacao: TAction;
        Action_RelatorioJustificativasDasObras: TAction;
    	procedure DataModuleCreate(Sender: TObject);
    	procedure Action_RegioesExecute(Sender: TObject);
    	procedure Action_SituacoesExecute(Sender: TObject);
    	procedure Action_GeneralConfigurationsExecute(Sender: TObject);
	    procedure Action_TiposDeObraExecute(Sender: TObject);
    	procedure Action_ProjetistasExecute(Sender: TObject);
	    procedure Action_InstaladoresExecute(Sender: TObject);
	    procedure Action_EquipamentosEFamiliasExecute(Sender: TObject);
    	procedure Action_TabelasAuxiliaresExecute(Sender: TObject);
    	procedure Action_SecurityAndPermissionsExecute(Sender: TObject);
        procedure Action_ObrasExecute(Sender: TObject);
        procedure Action_RelatorioEquipamentosPorSituacaoExecute(Sender: TObject);
        procedure Action_RelatorioFamiliasExecute(Sender: TObject);
        procedure Action_RelatorioObrasExecute(Sender: TObject);
        procedure Action_RelatorioPropostasExecute(Sender: TObject);
        procedure Action_RelatorioJustificativasDasObrasExecute(Sender: TObject);
  	private
    	{ Private declarations }
        { Apenas modulos e provavelmente caixas de dialgo não modais precisam de
        variaveis ! }
        Form_Regioes: TBDOForm_Regioes;
        Form_Situacoes: TBDOForm_Situacoes;
        Form_TiposDeObra: TBDOForm_TiposDeObra;
        Form_Projetistas: TBDOForm_Projetistas;
        Form_Instaladores: TBDOForm_Instaladores;
        Form_EquipamentosEFamilias: TBDOForm_EquipamentosEFamilias;
        Form_TabelasAuxiliares: TBDOForm_TabelasAuxiliares;
        BDOForm_AdminModule: TBDOForm_AdminModule;
        BDOForm_Obras: TBDOForm_Obras;
        function MyModule: TBDOForm_Main;
  	public
    	{ Public declarations }
        procedure ShowSplash;
  	end;

implementation

uses
	{ FRAMEWORK }

    { APLICAÇÃO }
    UBDODataModule_Administration, UBDODataModule_Regioes, UBDODataModule_Situacoes, UBDODataModule_TiposDeObra,
    UBDODataModule_Projetistas, UBDODataModule_Instaladores,
    UBDODataModule_EquipamentosEFamilias, UBDODataModule_TabelasAuxiliares, UBDODataModule_Obras,
    UBDOForm_Splash;

{$R *.dfm}

procedure TBDODataModule_Main.Action_EquipamentosEFamiliasExecute(Sender: TObject);
begin
	inherited;
    MyModule.CreateTabbedModule(TBDOForm_EquipamentosEFamilias,TBDODataModule_EquipamentosEFamilias,Form_EquipamentosEFamilias,Configurations,TXXXDataModule_Main(Self));
end;

procedure TBDODataModule_Main.Action_GeneralConfigurationsExecute(Sender: TObject);
begin
  	inherited;
  	ShowGeneralConfigurationForm(DataModuleMain.ZConnections[0].Connection,TBDOForm_GeneralConfigurations,Configurations,[ptsAll]);
end;

procedure TBDODataModule_Main.Action_InstaladoresExecute(Sender: TObject);
begin
  	inherited;
    MyModule.CreateTabbedModule(TBDOForm_Instaladores,TBDODataModule_Instaladores,Form_Instaladores,Configurations,TXXXDataModule_Main(Self));
end;

procedure TBDODataModule_Main.Action_ObrasExecute(Sender: TObject);
begin
    inherited;
    MyModule.CreateTabbedModule(TBDOForm_Obras,TBDODataModule_Obras,BDOForm_Obras,Configurations,TXXXDataModule_Main(Self));
end;

procedure TBDODataModule_Main.Action_ProjetistasExecute(Sender: TObject);
begin
  	inherited;
    MyModule.CreateTabbedModule(TBDOForm_Projetistas,TBDODataModule_Projetistas,Form_Projetistas,Configurations,TXXXDataModule_Main(Self));
end;

procedure TBDODataModule_Main.Action_RegioesExecute(Sender: TObject);
begin
    inherited;
    MyModule.CreateTabbedModule(TBDOForm_Regioes,TBDODataModule_Regioes,Form_Regioes,Configurations,TXXXDataModule_Main(Self));
end;

procedure TBDODataModule_Main.Action_RelatorioEquipamentosPorSituacaoExecute(Sender: TObject);
begin
    inherited;
    ExibirGeradorDeRelatorioDeEquipamentos;
end;

procedure TBDODataModule_Main.Action_RelatorioFamiliasExecute(Sender: TObject);
begin
    inherited;
    ExibirGeradorDeRelatorioDeFamilias;
end;

procedure TBDODataModule_Main.Action_RelatorioJustificativasDasObrasExecute(Sender: TObject);
begin
    inherited;
    ExibirGeradorDeRelatorioDeJustificativasDasObras;
end;

procedure TBDODataModule_Main.Action_RelatorioObrasExecute(Sender: TObject);
begin
    inherited;
    ExibirGeradorDeRelatorioDeObras;
end;

procedure TBDODataModule_Main.Action_RelatorioPropostasExecute(Sender: TObject);
begin
    inherited;
    ExibirGeradorDeRelatorioDePropostas;
end;

procedure TBDODataModule_Main.Action_SecurityAndPermissionsExecute(Sender: TObject);
begin
	inherited;
    MyModule.CreateTabbedModule(TBDOForm_AdminModule,TBDODataModule_Administration,BDOForm_AdminModule,Configurations,DataModuleMain);
end;

procedure TBDODataModule_Main.Action_SituacoesExecute(Sender: TObject);
begin
  	inherited;
	MyModule.CreateTabbedModule(TBDOForm_Situacoes,TBDODataModule_Situacoes,Form_Situacoes,Configurations,TXXXDataModule_Main(Self));
end;

procedure TBDODataModule_Main.Action_TabelasAuxiliaresExecute(Sender: TObject);
begin
  	inherited;
	MyModule.CreateTabbedModule(TBDOForm_TabelasAuxiliares,TBDODataModule_TabelasAuxiliares,Form_TabelasAuxiliares,Configurations,TXXXDataModule_Main(Self));
end;

procedure TBDODataModule_Main.Action_TiposDeObraExecute(Sender: TObject);
begin
    inherited;
    MyModule.CreateTabbedModule(TBDOForm_TiposDeObra,TBDODataModule_TiposDeObra,Form_TiposDeObra,Configurations,TXXXDataModule_Main(Self));
end;

procedure TBDODataModule_Main.DataModuleCreate(Sender: TObject);
begin
	Form_Regioes := nil;
    Form_Situacoes := nil;

    try
	  	InitializeConfigurations(ZConnection_BDO,TBDOForm_GeneralConfigurations,Configurations,[ptsAll]);
    except
    	on E: Exception do
        begin
        	MessageBox(Application.Handle,PChar(E.Message),'Configurações incompletas',MB_ICONERROR);
	 		Application.Terminate;
            Exit;
        end;
    end;

    if not MakeLogin(ZConnection_BDO,Configurations.ExpandedLoginDialog) then
        Application.Terminate
    else
        with TBDOForm_Splash.Create(Application) do
        begin
            CanClose := False;
            Show;
            Update;
            inherited;
            CloseDelayed(2);
        end;
end;

function TBDODataModule_Main.MyModule: TBDOForm_Main;
begin
	Result := TBDOForm_Main(Owner);
end;

procedure TBDODataModule_Main.ShowSplash;
begin
    with TBDOForm_Splash.Create(Application) do
    begin
        LabelVersion.Visible := True;
        ShowModal;
    end;
end;

end.
