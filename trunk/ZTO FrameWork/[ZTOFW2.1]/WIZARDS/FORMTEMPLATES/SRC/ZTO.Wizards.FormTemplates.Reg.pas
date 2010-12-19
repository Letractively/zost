unit ZTO.Wizards.FormTemplates.Reg;

interface

{$I ..\..\..\ZTOCL\SRC\Compilers.inc}

uses ToolsApi
{$IFDEF COMPILER_6_UP}
   , DesignIntf
   , DesignEditors
{$ELSE}
   , DsgnIntf
{$ENDIF}
   , ZTO.Wizards.FormTemplates.Dialog
   , ZTO.Wizards.FormTemplates.Dialog.Wizard
   , ZTO.Wizards.FormTemplates.DataModule
   , ZTO.Wizards.FormTemplates.DataModule.Wizard
   , ZTO.Wizards.FormTemplates.SDIForm
   , ZTO.Wizards.FormTemplates.SDIForm.Wizard;

procedure Register;

implementation

procedure Register;
begin
  // Registrando nossos formularios e datamodules
  RegisterCustomModule(TZTODialog, TCustomModule);
  RegisterCustomModule(TZTODataModule, TCustomModule);
  RegisterCustomModule(TZTOSDIForm, TCustomModule);

  // Registrando nosso wizard no Object Repository
  RegisterPackageWizard(TZTODialogWizard.Create);
  RegisterPackageWizard(TZTODataModuleWizard.Create);
  RegisterPackageWizard(TZTOSDIFormWizard.Create);
end;

end.
