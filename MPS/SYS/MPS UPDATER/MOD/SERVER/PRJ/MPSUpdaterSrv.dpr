program MPSUpdaterSrv;

uses
  XPMan,
  Forms,
  UForm_Principal in '..\SRC\UForm_Principal.pas' {Form_Principal},
  UDataModule_Principal in '..\SRC\UDataModule_Principal.pas' {DataModule_Principal: TDataModule},
  UAPIWrappers in '..\..\..\..\..\LIB\UAPIWrappers.pas',
  UGlobalFunctions in '..\..\..\..\..\LIB\UGlobalFunctions.pas',
  UForm_Sistemas in '..\SRC\UForm_Sistemas.pas' {Form_Sistemas},
  UObjectFile in '..\..\..\..\..\LIB\UObjectFile.pas';

{$R *.res}

begin
  {$WARNINGS OFF}
  ReportMemoryLeaksOnShutdown := DebugHook <> 0;
  {$WARNINGS ON}  
  Application.Initialize;
  Application.Title := 'MPS Updater (Server)';
  Application.CreateForm(TForm_Principal, Form_Principal);
  Application.Run;
end.
