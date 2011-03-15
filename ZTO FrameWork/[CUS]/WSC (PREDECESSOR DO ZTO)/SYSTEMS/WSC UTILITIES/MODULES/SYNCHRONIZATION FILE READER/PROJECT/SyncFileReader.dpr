program SyncFileReader;

uses
  Forms,
  UMain in '..\Source\UMain.pas' {FForm_Main},
  UWSCTypesConstantsAndClasses in '..\..\..\..\..\Libraries\UWSCTypesConstantsAndClasses.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TFForm_Main, FForm_Main);
  Application.Run;
end.
