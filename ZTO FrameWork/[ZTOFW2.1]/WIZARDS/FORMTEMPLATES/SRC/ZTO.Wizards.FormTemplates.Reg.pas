unit ZTO.Wizards.FormTemplates.Reg;

interface

uses ToolsApi
   , DesignIntf
   , DesignEditors
   , ZTO.Wizards.FormTemplates.DataModule
   , ZTO.Wizards.FormTemplates.DataModule.Wizard;

procedure Register;

implementation

uses Classes
   , ZTO.Win32.Rtl.Common.Classes;

//type
//  TMyFormClassPropertyEditor = class(TPropertyEditor)
//  private
//    FList: TStringList;
//  public
//    constructor Create(const ADesigner: IDesigner; APropCount: Integer); override;
//    destructor Destroy; override;
//    function GetValue: string; override;
//    procedure SetValue(const Value: string); override;
//    procedure GetValues(Proc: TGetStrProc); override;
//    function GetAttributes: TPropertyAttributes; override;
//  end;

procedure Register;
begin
  // Registrando nossos formularios e datamodules
  RegisterCustomModule(TZTODataModule, TCustomModule);
//  RegisterPropertyEditor(TypeInfo(string), TZTODataModule,'MyFormClass', TMyFormClassPropertyEditor);

  // Registrando nosso wizard no Object Repository
  RegisterPackageWizard(TZTODataModuleWizard.Create);
end;

//constructor TMyFormClassPropertyEditor.Create(const ADesigner: IDesigner; APropCount: Integer);
//begin
//  inherited Create(ADesigner, APropCount);
//
//  FList := TStringList.Create;
//end;

//destructor TMyFormClassPropertyEditor.Destroy;
//begin
//  FList.Free;
//  inherited Destroy;
//end;

//function TMyFormClassPropertyEditor.GetAttributes: TPropertyAttributes;
//begin
//  Result := [paValueList, paSortList];
//end;

//function TMyFormClassPropertyEditor.GetValue: string;
//begin
//  Result := (GetComponent(0) as TZTODataModule).MyFormClass;
//end;

//procedure TMyFormClassPropertyEditor.GetValues(Proc: TGetStrProc);
//var
//  I: Longint;
//begin
//  EnumClasses(FList);
//
//  for I := 0 to FList.Count -1 do
//    Proc(FList.Strings[I]);
//end;

//procedure TMyFormClassPropertyEditor.SetValue(const Value: string);
//begin
//  (GetComponent(0) as TZTODataModule).MyFormClass := Value;
//  if FList.IndexOf(Value) = -1 then
//    FList.Add(Value);
//end;

end.
