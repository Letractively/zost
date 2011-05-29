program Autoitter;

uses
  Forms,
  UForm_Principal in '..\SRC\UForm_Principal.pas' {Form_Principal},
  UConfiguracoes in '..\SRC\UConfiguracoes.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TForm_Principal, Form_Principal);
  Application.Run;
end.
