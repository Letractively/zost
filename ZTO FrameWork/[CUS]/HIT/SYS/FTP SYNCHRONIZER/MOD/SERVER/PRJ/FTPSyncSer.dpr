program FTPSyncSer;

{%TogetherDiagram 'ModelSupport_FTPSyncSer\default.txaPackage'}
{%TogetherDiagram 'ModelSupport_FTPSyncSer\UFSSForm_Splash\default.txaPackage'}
{%TogetherDiagram 'ModelSupport_FTPSyncSer\UFSSForm_Configurations\default.txaPackage'}
{%TogetherDiagram 'ModelSupport_FTPSyncSer\UFSSForm_Main\default.txaPackage'}
{%TogetherDiagram 'ModelSupport_FTPSyncSer\FTPSyncSer\default.txaPackage'}
{%TogetherDiagram 'ModelSupport_FTPSyncSer\default.txvpck'}
{%TogetherDiagram 'ModelSupport_FTPSyncSer\FTPSyncSer\default.txvpck'}
{%TogetherDiagram 'ModelSupport_FTPSyncSer\UFSSForm_Configurations\default.txvpck'}
{%TogetherDiagram 'ModelSupport_FTPSyncSer\UFSSForm_Main\default.txvpck'}
{%TogetherDiagram 'ModelSupport_FTPSyncSer\UFSSForm_Splash\default.txvpck'}

uses
  Forms,
  XPMan,
  UFSSForm_Main in '..\SRC\UFSSForm_Main.pas' {FSSForm_Main},
  UFSSForm_Configurations in '..\SRC\UFSSForm_Configurations.pas' {FSSForm_Configurations},
  UFSSForm_Splash in '..\SRC\UFSSForm_Splash.pas' {FSSForm_Splash};

{$R *.res}

begin
    Application.Initialize;
    Application.Title := 'FTP Synchronizer - Módulo "Server"';
    Application.Run;

  	with TFSSForm_Splash.Create(Application) do
    begin
        CanClose := False;
        Show;
        Update;
        Application.CreateForm(TFSSForm_Main, FSSForm_Main);
        CloseDelayed(1);
        Application.Run;
    end;
end.
