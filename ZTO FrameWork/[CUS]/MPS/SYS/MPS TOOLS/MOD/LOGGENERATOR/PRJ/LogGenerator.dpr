program LogGenerator;

uses
  XPMan,
  Forms,
  UForm_Principal in '..\SRC\UForm_Principal.pas' {Form_Principal},
  UDataModule_Principal in '..\SRC\UDataModule_Principal.pas' {DataModule_Principal: TDataModule},
  UConfiguracoes in '..\SRC\UConfiguracoes.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TForm_Principal, Form_Principal);
  Application.CreateForm(TDataModule_Principal, DataModule_Principal);
  Application.Run;
end.
