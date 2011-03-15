program MySQLBackupAndRestoreSAE;

uses
  XPMan,
  Windows,
  Forms,
  UMBRDataModule in '..\Source\DataModule Repository\UMBRDataModule.pas' {MBRDataModule},
  UMBRDataModule_Main in '..\Source\UMBRDataModule_Main.pas' {MBRDataModule_Main},
  UMBRTypesConstantsAndClasses in '..\Source\Libraries\UMBRTypesConstantsAndClasses.pas',
  UMBRForm_Main in '..\Source\UMBRForm_Main.pas' {MBRForm_Main},
  UMBRForm_MySQLBackupAndRestore in '..\Source\UMBRForm_MySQLBackupAndRestore.pas' {MBRForm_MySQLBackupAndRestore},
  UXXXForm_DialogTemplate in '..\..\..\..\..\..\..\[FW1.1]\Form repository\UXXXForm_DialogTemplate.pas' {XXXForm_DialogTemplate},
  UXXXForm_MySQLBackupAndRestore in '..\..\..\..\..\..\..\[FW1.1]\UXXXForm_MySQLBackupAndRestore.pas' {XXXForm_MySQLBackupAndRestore},
  UXXXDataModule in '..\..\..\..\..\..\..\[FW1.1]\UXXXDataModule.pas' {XXXDataModule: TDataModule},
  UXXXForm_MainDialogTemplate in '..\..\..\..\..\..\..\[FW1.1]\Form repository\UXXXForm_MainDialogTemplate.pas' {XXXForm_MainDialogTemplate};

{$R *.res}

begin
    Application.Initialize;
    Application.Title := 'MySQL Backup And Restore (SAE)';
  TMBRForm_Main.Create(Application,TMBRConfigurations.Create(Application),TMBRDataModule_Main,'Módulo principal');
//        CloseDelayed(2);
  Application.Run;
//    end;
end.