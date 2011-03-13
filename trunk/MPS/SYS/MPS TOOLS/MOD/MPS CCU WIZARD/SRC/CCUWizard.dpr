program CCUWizard;

uses
  Forms,
  UForm_Principal in 'UForm_Principal.pas' {Form_Principal},
  UDataModule_Principal in 'UDataModule_Principal.pas' {DataModule_Principal: TDataModule};

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.Title := 'CCU Wizard';
  Application.CreateForm(TForm_Principal, Form_Principal);
  Application.CreateForm(TDataModule_Principal, DataModule_Principal);
  Application.Run;
end.
