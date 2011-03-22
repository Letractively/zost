program SMSExplorer;

uses
  Forms,
  UForm_Principal in '..\SRC\UForm_Principal.pas' {Form_Principal},
  UDataModule_Principal in '..\SRC\UDataModule_Principal.pas' {DataModule_Principal},
  UConfiguracoes in '..\SRC\UConfiguracoes.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TDataModule_Principal, DataModule_Principal);
  Application.CreateForm(TForm_Principal, Form_Principal);
  Application.Run;
end.
