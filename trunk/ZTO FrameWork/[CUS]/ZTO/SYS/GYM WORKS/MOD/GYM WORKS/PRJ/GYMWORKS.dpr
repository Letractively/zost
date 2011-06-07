program GYMWORKS;



uses
  Forms,
  XPMan,
  Sys.Lib.Types in '..\..\..\..\..\LIB\Sys.Lib.Types.pas',
  Sys.Lib.Zeos.MySQL.Utils in '..\..\..\..\..\LIB\Sys.Lib.Zeos.MySQL.Utils.pas',
  Sys.Lib.Zeos.Types in '..\..\..\..\..\LIB\Sys.Lib.Zeos.Types.pas',
  Mdl.Lib.ZTODataModule_Base in '..\..\..\LIB\Mdl.Lib.ZTODataModule_Base.pas' {ZTODataModule_Base: TZTODataModule},
  Mdl.Lib.ZTODialog_Base in '..\..\..\LIB\Mdl.Lib.ZTODialog_Base.pas' {ZTODialog_Base: TZTODialog},
  Mdl.Lib.ZTODialog_TaskBar in '..\..\..\LIB\Mdl.Lib.ZTODialog_TaskBar.pas' {ZTODialog_TaskBar: TZTODialog},
  Mdl.Lib.ZTOSDIForm_Base in '..\..\..\LIB\Mdl.Lib.ZTOSDIForm_Base.pas' {ZTOSDIForm_Base: TZTOSDIForm},
  Mdl.Lib.ZTOSDIForm_TaskBar in '..\..\..\LIB\Mdl.Lib.ZTOSDIForm_TaskBar.pas' {ZTOSDIForm_TaskBar: TZTOSDIForm},
  UForm_Splash in '..\SRC\FORMS\UForm_Splash.pas' {Form_Splash},
  UDataModule_Principal in '..\SRC\DATAMODULES\UDataModule_Principal.pas' {DataModule_Principal: TZTODataModule},
  UZTODataModule_Clientes in '..\SRC\DATAMODULES\UZTODataModule_Clientes.pas' {ZTODataModule_Clientes: TZTODataModule},
  UZTOSDIForm_Clientes in '..\SRC\FORMS\UZTOSDIForm_Clientes.pas' {ZTOSDIForm_Clientes: TZTOSDIForm},
  Mdl.Lib.ZTOSDIForm_Cadastro1 in '..\..\..\LIB\Mdl.Lib.ZTOSDIForm_Cadastro1.pas' {ZTOSDIForm_Cadastro1: TZTOSDIForm},
  UZTODialog_Configuracoes in '..\SRC\FORMS\UZTODialog_Configuracoes.pas' {ZTODialog_Configuracoes: TZTODialog},
  Mdl.Lib.Configuracoes in '..\..\..\LIB\Mdl.Lib.Configuracoes.pas',
  UZTODialog_Login in '..\SRC\FORMS\UZTODialog_Login.pas' {ZTODialog_Login: TZTODialog};

{$R *.res}

begin
  Application.Initialize;

  { Para não mostrar o botão na barra de tarefas }
  Application.MainFormOnTaskBar := False;
  Application.Title := 'Gym Works';
  Application.CreateForm(TForm_Splash, Form_Splash);
  Application.CreateForm(TDataModule_Principal, DataModule_Principal);
  Application.Run;
end.
