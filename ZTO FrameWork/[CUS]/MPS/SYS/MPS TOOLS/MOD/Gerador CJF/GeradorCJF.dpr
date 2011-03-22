program GeradorCJF;

uses
  Forms,
  UForm_Principal in 'UForm_Principal.pas' {Form_Principal},
  UDataModule_Principal in 'UDataModule_Principal.pas' {DataModule_Principal: TDataModule},
  UConfigurations in 'UConfigurations.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TForm_Principal, Form_Principal);
  Application.CreateForm(TDataModule_Principal, DataModule_Principal);
  Application.Run;
end.
