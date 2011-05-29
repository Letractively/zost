program ACW;



uses
  Forms,
  XPMan,
  Sys.Lib.Zeos.MySQL.Utils in '..\..\..\..\..\LIB\Sys.Lib.Zeos.MySQL.Utils.pas',
  Sys.Lib.Zeos.Types in '..\..\..\..\..\LIB\Sys.Lib.Zeos.Types.pas',
  UForm_Splash in '..\SRC\FORMS\UForm_Splash.pas' {Form_Splash},
  UDataModule_Principal in '..\SRC\DATAMODULES\UDataModule_Principal.pas' {DataModule_Principal: TZTODataModule},
  Sys.Lib.Types in '..\..\..\..\..\LIB\Sys.Lib.Types.pas',
  Mdl.Lib.ZTOSDIForm_Base in '..\..\..\LIB\Mdl.Lib.ZTOSDIForm_Base.pas' {ZTOSDIForm_Base: TZTOSDIForm},
  Mdl.Lib.ZTODataModule_Base in '..\..\..\LIB\Mdl.Lib.ZTODataModule_Base.pas' {ZTODataModule_Base: TZTODataModule},
  Mdl.Lib.ZTODialog_Base in '..\..\..\LIB\Mdl.Lib.ZTODialog_Base.pas' {ZTODialog_Base: TZTODialog},
  UZTODialog_Situacoes in '..\SRC\FORMS\UZTODialog_Situacoes.pas' {ZTODialog_Situacoes: TZTODialog},
  UZTODialog_Regioes in '..\SRC\FORMS\UZTODialog_Regioes.pas' {ZTODialog_Regioes: TZTODialog},
  Mdl.Lib.ZTODialog_TaskBar in '..\..\..\LIB\Mdl.Lib.ZTODialog_TaskBar.pas' {ZTODialog_TaskBar: TZTODialog},
  Mdl.Lib.ZTOSDIForm_TaskBar in '..\..\..\LIB\Mdl.Lib.ZTOSDIForm_TaskBar.pas' {ZTOSDIForm_TaskBar: TZTOSDIForm},
  UZTODataModule_Situacoes in '..\SRC\DATAMODULES\UZTODataModule_Situacoes.pas' {ZTODataModule_Situacoes: TZTODataModule},
  UZTODataModule_Regioes in '..\SRC\DATAMODULES\UZTODataModule_Regioes.pas' {ZTODataModule_Regioes: TZTODataModule};

{$R *.res}

begin
  Application.Initialize;

  Application.CreateForm(TForm_Splash, Form_Splash);
  Application.CreateForm(TDataModule_Principal, DataModule_Principal);
  Application.Run;
end.
