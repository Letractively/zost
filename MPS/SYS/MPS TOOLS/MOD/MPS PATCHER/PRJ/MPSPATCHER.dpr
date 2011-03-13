program MPSPATCHER;

uses
  Forms,
  UForm_Principal in '..\SRC\FORMS\UForm_Principal.pas' {Form1};

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TForm1, Form1);
  Application.Run;
end.
