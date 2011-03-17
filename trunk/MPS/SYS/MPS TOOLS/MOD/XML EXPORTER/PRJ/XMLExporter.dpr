program XMLExporter;

uses
  Forms,
  UConfigurations in '..\SRC\UConfigurations.pas',
  UDataModule_Principal in '..\SRC\UDataModule_Principal.pas' {DataModule_Principal: TDataModule},
  UForm_Principal in '..\SRC\UForm_Principal.pas' {Form_Principal},
  UThreadedTask in '..\SRC\UThreadedTask.pas' {ThreadedTask: TDataModule},
  UTaskThread in '..\SRC\UTaskThread.pas';

{$R *.res}

begin
  Application.Initialize;
  //Application.MainFormOnTaskbar := True;
  Application.CreateForm(TForm_Principal, Form_Principal);
  Application.Run;
end.
