program MPSVersionChanger;

uses
  XPMan,
  Forms,
  UForm_Principal in '..\SRC\UForm_Principal.pas' {Form_Principal},
  UClasses in '..\..\..\..\..\LIB\UClasses.pas',
  UFuncoes in '..\..\..\..\..\LIB\UFuncoes.pas',
  UAPIWrappers in '..\..\..\..\..\LIB\UAPIWrappers.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.Title := 'MPS Version Changer';
  Application.CreateForm(TForm_Principal, Form_Principal);
  Application.Run;
end.
