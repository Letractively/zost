program MPSUpdaterCli;

uses
  Forms,
  XPMan,
  UForm_Principal in '..\SRC\UForm_Principal.pas' {Form_Principal},
  UDataModule_Principal in '..\SRC\UDataModule_Principal.pas' {DataModule_Principal: TDataModule},
  UGlobalFunctions in '..\..\..\..\..\LIB\UGlobalFunctions.pas',
  UObjectFile in '..\..\..\..\..\LIB\UObjectFile.pas',
  UForm_Configuracoes in '..\SRC\UForm_Configuracoes.pas' {Form_Configuracoes},
  USingleEncrypt in '..\..\..\..\..\LIB\USingleEncrypt.pas';

{$R *.res}

begin
  ReportMemoryLeaksOnShutdown := DebugHook <> 0;
  
  Application.Initialize;
  Application.Title := 'MPS Updater (Client)';
  Application.CreateForm(TDataModule_Principal, DataModule_Principal);
  Application.CreateForm(TForm_Principal, Form_Principal);
  Application.Run;
end.
