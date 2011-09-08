program DEC;

uses
  Forms,
  UPrincipal in '..\SRC\UPrincipal.pas' {Form_Principal};

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TForm_Principal, Form_Principal);
  Application.Run;
end.
