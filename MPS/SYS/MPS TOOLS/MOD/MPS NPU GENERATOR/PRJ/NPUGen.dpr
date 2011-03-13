program NPUGen;

uses
  XPMan,
  Forms,
  UForm_Principal in '..\SRC\UForm_Principal.pas' {Form_Principal},
  UMPSNPU in '..\SRC\UMPSNPU.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.Title := 'NPU Generator';
  Application.CreateForm(TForm_Principal, Form_Principal);
  Application.Run;
end.
