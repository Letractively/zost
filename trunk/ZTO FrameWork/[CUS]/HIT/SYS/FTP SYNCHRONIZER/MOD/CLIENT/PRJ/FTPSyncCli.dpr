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
  	Application.Title := 'FTP Synchronizer - M�dulo "Client"';
    {$IFDEF DEVELOPING}
    Application.MessageBox('PARE A EXECU��O DESTA APLICA��O IMEDIATAMENTE! Est'+
    'a � uma aplica��o de desenvolvimento que cont�m comandos extremamente per'+
    'igosos para os bancos de dados local e remoto. A utiliza��o desta aplica�'+
    '�o n�o � autorizada para ningu�m. Feche a aplica��o o mais r�pido poss�ve'+
    'l e contate o HelpDesk informando esta mensagem','Execu��o arriscada',MB_ICONWARNING);
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
