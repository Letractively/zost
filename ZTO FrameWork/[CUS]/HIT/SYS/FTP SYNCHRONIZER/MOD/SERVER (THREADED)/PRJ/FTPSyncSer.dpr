program FTPSyncSer;

uses
  Forms,
  UFSSForm_Main in '..\SRC\UFSSForm_Main.pas' {FSSForm_Main},
  UFSSForm_Configurations in '..\SRC\UFSSForm_Configurations.pas' {FSSForm_Configurations},
  UFSSForm_Splash in '..\SRC\UFSSForm_Splash.pas' {FSSForm_Splash},
  UFSYTypesConstantsAndClasses in '..\..\..\Libraries\UFSYTypesConstantsAndClasses.pas',
  UFSYGlobals in '..\..\..\Libraries\UFSYGlobals.pas',
  UFSYSyncStructures in '..\..\..\Libraries\UFSYSyncStructures.pas';

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
