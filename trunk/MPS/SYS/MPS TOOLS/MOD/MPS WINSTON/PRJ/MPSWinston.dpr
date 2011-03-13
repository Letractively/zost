program MPSWinston;

uses
  Forms,
  XPMan,
  UForm_Principal in '..\SRC\UForm_Principal.pas' {Form_Principal},
  UDataModule_Principal in '..\SRC\UDataModule_Principal.pas' {DataModule_Principal: TDataModule},
  UForm_CCU in '..\SRC\UForm_CCU.pas' {Form_CCU};

{$R *.res}

begin
  Application.Initialize;
  Application.Title := 'MPS Winston';
  Application.CreateForm(TDataModule_Principal, DataModule_Principal);
  Application.CreateForm(TForm_Principal, Form_Principal);
  Application.Run;
end.
