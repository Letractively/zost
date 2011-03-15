program FTPSyncCli;

{%TogetherDiagram 'ModelSupport_FTPSyncCli\default.txaPackage'}
{%TogetherDiagram 'ModelSupport_FTPSyncCli\FTPSyncCli\default.txaPackage'}
{%TogetherDiagram 'ModelSupport_FTPSyncCli\UFSCForm_Splash\default.txaPackage'}
{%TogetherDiagram 'ModelSupport_FTPSyncCli\UFSCForm_Main\default.txaPackage'}
{%TogetherDiagram 'ModelSupport_FTPSyncCli\UFSCForm_Configurations\default.txaPackage'}
{%TogetherDiagram 'ModelSupport_FTPSyncCli\default.txvpck'}
{%TogetherDiagram 'ModelSupport_FTPSyncCli\FTPSyncCli\default.txvpck'}
{%TogetherDiagram 'ModelSupport_FTPSyncCli\UFSCForm_Configurations\default.txvpck'}
{%TogetherDiagram 'ModelSupport_FTPSyncCli\UFSCForm_Main\default.txvpck'}
{%TogetherDiagram 'ModelSupport_FTPSyncCli\UFSCForm_Splash\default.txvpck'}

uses
  Forms,
  Windows,
  XPMan,
  UFSCForm_Main in '..\SRC\UFSCForm_Main.pas' {FSCForm_Main},
  UFSCForm_Configurations in '..\SRC\UFSCForm_Configurations.pas' {FSCForm_Configurations},
  UFSCForm_Splash in '..\SRC\UFSCForm_Splash.pas' {FSCForm_Splash};

{$R *.res}

begin
	Application.Initialize;
  	Application.Title := 'FTP Synchronizer - Módulo "Client"';
    {$IFDEF DEVELOPING}
    Application.MessageBox('PARE A EXECUÇÃO DESTA APLICAÇÃO IMEDIATAMENTE! Est'+
    'a é uma aplicação de desenvolvimento que contém comandos extremamente per'+
    'igosos para os bancos de dados local e remoto. A utilização desta aplicaç'+
    'ão não é autorizada para ninguém. Feche a aplicação o mais rápido possíve'+
    'l e contate o HelpDesk informando esta mensagem','Execução arriscada',MB_ICONWARNING);
    {$ENDIF}
  	with TFSCForm_Splash.Create(Application) do
    begin
        CanClose := False;
        Show;
        Update;
        Application.CreateForm(TFSCForm_Main, FSCForm_Main);
  CloseDelayed(1);
        Application.Run;
    end;
end.
