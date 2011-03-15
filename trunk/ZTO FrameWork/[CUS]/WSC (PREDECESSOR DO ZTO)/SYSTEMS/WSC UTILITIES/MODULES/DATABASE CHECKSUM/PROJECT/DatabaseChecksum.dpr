program DatabaseChecksum;

uses
  Forms,
  UMain in '..\Source\UMain.pas' {Form1},
  UWSCTypesConstantsAndClasses in '..\..\..\..\..\Libraries\UWSCTypesConstantsAndClasses.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TForm1, Form1);
  Application.Run;
end.
