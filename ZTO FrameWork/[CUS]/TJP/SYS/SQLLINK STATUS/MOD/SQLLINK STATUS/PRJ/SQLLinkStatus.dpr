program SQLLinkStatus;

uses
  XPMan,
  Forms,
  UForm_Principal in '..\SRC\UForm_Principal.pas' {Form_Principal},
  UConfiguracoes in '..\SRC\UConfiguracoes.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.Title := 'SQL Link Status';
  Application.CreateForm(TForm_Principal, Form_Principal);
  Application.Run;
end.
