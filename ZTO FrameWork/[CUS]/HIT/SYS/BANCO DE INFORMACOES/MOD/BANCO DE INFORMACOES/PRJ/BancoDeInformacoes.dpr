program BancoDeInformacoes;

{%TogetherDiagram 'ModelSupport_BancoDeInformacoes\default.txaPackage'}
{%TogetherDiagram 'ModelSupport_BancoDeInformacoes\BancoDeInformacoes\default.txaPackage'}
{%TogetherDiagram 'ModelSupport_BancoDeInformacoes\UBDIDataModule_Main\default.txaPackage'}
{%TogetherDiagram 'ModelSupport_BancoDeInformacoes\UBDIForm_Splash\default.txaPackage'}
{%TogetherDiagram 'ModelSupport_BancoDeInformacoes\UBDITypesConstantsAndClasses\default.txaPackage'}
{%TogetherDiagram 'ModelSupport_BancoDeInformacoes\UBDIForm_Main\default.txaPackage'}
{%TogetherDiagram 'ModelSupport_BancoDeInformacoes\UBDIDataModule\default.txaPackage'}
{%TogetherDiagram 'ModelSupport_BancoDeInformacoes\default.txvpck'}
{%TogetherDiagram 'ModelSupport_BancoDeInformacoes\BancoDeInformacoes\default.txvpck'}
{%TogetherDiagram 'ModelSupport_BancoDeInformacoes\UBDIDataModule\default.txvpck'}
{%TogetherDiagram 'ModelSupport_BancoDeInformacoes\UBDIDataModule_Main\default.txvpck'}
{%TogetherDiagram 'ModelSupport_BancoDeInformacoes\UBDIForm_Main\default.txvpck'}
{%TogetherDiagram 'ModelSupport_BancoDeInformacoes\UBDITypesConstantsAndClasses\default.txvpck'}
{%TogetherDiagram 'ModelSupport_BancoDeInformacoes\UBDIForm_Splash\default.txvpck'}

uses
  XPMan,
  Windows,
  Forms,
  UBDIDataModule in '..\SRC\UBDIDataModule.pas' {BDIDataModule: TDataModule},
  UBDIDataModule_Main in '..\SRC\UBDIDataModule_Main.pas' {BDIDataModule_Main: TDataModule},
  UBDITypesConstantsAndClasses in '..\SRC\UBDITypesConstantsAndClasses.pas',
  UBDIForm_Main in '..\SRC\UBDIForm_Main.pas' {BDIForm_Main},
  UBDIForm_Splash in '..\SRC\UBDIForm_Splash.pas' {BDIForm_Splash};

{$R *.res}

begin
    Application.Initialize;
    Application.Title := 'Banco De Informações';
    {$IFDEF DEVELOPING}
    Application.MessageBox('Modo de depuração ativo','Modo de depuração ativo',0);
    {$ENDIF}
  	with TBDIForm_Splash.Create(Application) do
    begin
        CanClose := False;
        Show;
        Update;
        TBDIForm_Main.Create(Application,TBDIConfigurations.Create(Application),TBDIDataModule_Main,'Módulo principal');
        CloseDelayed(1);
        Application.Run;
    end;
end.
