program ACW;

{%TogetherDiagram 'ModelSupport_ACW\Mdl\default.txaPackage'}
{%TogetherDiagram 'ModelSupport_ACW\UDataModule_Principal\default.txaPackage'}
{%TogetherDiagram 'ModelSupport_ACW\Sys\default.txaPackage'}
{%TogetherDiagram 'ModelSupport_ACW\UZTODialog_Situacoes\default.txaPackage'}
{%TogetherDiagram 'ModelSupport_ACW\UZTODataModule_Regioes\default.txaPackage'}
{%TogetherDiagram 'ModelSupport_ACW\UZTODialog_Regioes\default.txaPackage'}
{%TogetherDiagram 'ModelSupport_ACW\ACW\default.txaPackage'}
{%TogetherDiagram 'ModelSupport_ACW\UZTODataModule_Situacoes\default.txaPackage'}
{%TogetherDiagram 'ModelSupport_ACW\UForm_Splash\default.txaPackage'}
{%TogetherDiagram 'ModelSupport_ACW\default.txvpck'}
{%TogetherDiagram 'ModelSupport_ACW\UForm_Splash\default.txvpck'}
{%TogetherDiagram 'ModelSupport_ACW\ACW\default.txvpck'}
{%TogetherDiagram 'ModelSupport_ACW\UZTODataModule_Situacoes\default.txvpck'}
{%TogetherDiagram 'ModelSupport_ACW\UZTODataModule_Regioes\default.txvpck'}
{%TogetherDiagram 'ModelSupport_ACW\UZTODialog_Situacoes\default.txvpck'}
{%TogetherDiagram 'ModelSupport_ACW\Sys\Lib\default.txaPackage'}
{%TogetherDiagram 'ModelSupport_ACW\Sys\default.txvpck'}
{%TogetherDiagram 'ModelSupport_ACW\Sys\Lib\Zeos\default.txaPackage'}
{%TogetherDiagram 'ModelSupport_ACW\Sys\Lib\Types\default.txaPackage'}
{%TogetherDiagram 'ModelSupport_ACW\Sys\Lib\default.txvpck'}
{%TogetherDiagram 'ModelSupport_ACW\Sys\Lib\Zeos\MySQL\default.txaPackage'}
{%TogetherDiagram 'ModelSupport_ACW\Sys\Lib\Zeos\Types\default.txaPackage'}
{%TogetherDiagram 'ModelSupport_ACW\Sys\Lib\Zeos\default.txvpck'}
{%TogetherDiagram 'ModelSupport_ACW\Sys\Lib\Zeos\MySQL\Utils\default.txaPackage'}
{%TogetherDiagram 'ModelSupport_ACW\Sys\Lib\Zeos\MySQL\default.txvpck'}
{%TogetherDiagram 'ModelSupport_ACW\Sys\Lib\Zeos\MySQL\Utils\default.txvpck'}
{%TogetherDiagram 'ModelSupport_ACW\Sys\Lib\Zeos\Types\default.txvpck'}
{%TogetherDiagram 'ModelSupport_ACW\Sys\Lib\Types\default.txvpck'}
{%TogetherDiagram 'ModelSupport_ACW\UZTODialog_Regioes\default.txvpck'}
{%TogetherDiagram 'ModelSupport_ACW\UDataModule_Principal\default.txvpck'}
{%TogetherDiagram 'ModelSupport_ACW\Mdl\Lib\default.txaPackage'}
{%TogetherDiagram 'ModelSupport_ACW\Mdl\default.txvpck'}
{%TogetherDiagram 'ModelSupport_ACW\Mdl\Lib\ZTODialog_Base\default.txaPackage'}
{%TogetherDiagram 'ModelSupport_ACW\Mdl\Lib\ZTODialog_TaskBar\default.txaPackage'}
{%TogetherDiagram 'ModelSupport_ACW\Mdl\Lib\ZTOSDIForm_Base\default.txaPackage'}
{%TogetherDiagram 'ModelSupport_ACW\Mdl\Lib\ZTODataModule_Base\default.txaPackage'}
{%TogetherDiagram 'ModelSupport_ACW\Mdl\Lib\ZTOSDIForm_TaskBar\default.txaPackage'}
{%TogetherDiagram 'ModelSupport_ACW\Mdl\Lib\default.txvpck'}
{%TogetherDiagram 'ModelSupport_ACW\Mdl\Lib\ZTOSDIForm_Base\default.txvpck'}
{%TogetherDiagram 'ModelSupport_ACW\Mdl\Lib\ZTOSDIForm_TaskBar\default.txvpck'}
{%TogetherDiagram 'ModelSupport_ACW\Mdl\Lib\ZTODataModule_Base\default.txvpck'}
{%TogetherDiagram 'ModelSupport_ACW\Mdl\Lib\ZTODialog_TaskBar\default.txvpck'}
{%TogetherDiagram 'ModelSupport_ACW\Mdl\Lib\ZTODialog_Base\default.txvpck'}
{%TogetherDiagram 'ModelSupport_ACW\default.txaPackage'}

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
  UZTODataModule_Regioes in '..\SRC\DATAMODULES\UZTODataModule_Regioes.pas' {ZTODataModule_Regioes: TZTODataModule},
  Mdl.Lib.ZTODialog_TaskBar in '..\..\..\LIB\Mdl.Lib.ZTODialog_TaskBar.pas' {ZTODialog_TaskBar: TZTODialog},
  Mdl.Lib.ZTOSDIForm_TaskBar in '..\..\..\LIB\Mdl.Lib.ZTOSDIForm_TaskBar.pas' {ZTOSDIForm_TaskBar: TZTOSDIForm},
  UZTODataModule_Situacoes in '..\SRC\DATAMODULES\UZTODataModule_Situacoes.pas' {ZTODataModule_Situacoes: TZTODataModule};

{$R *.res}

begin
  Application.Initialize;

  Application.CreateForm(TForm_Splash, Form_Splash);
  Application.CreateForm(TDataModule_Principal, DataModule_Principal);
  Application.Run;
end.
