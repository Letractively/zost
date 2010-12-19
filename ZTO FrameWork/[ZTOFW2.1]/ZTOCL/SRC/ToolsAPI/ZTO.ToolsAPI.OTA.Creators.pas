unit ZTO.ToolsAPI.OTA.Creators;

{$WEAKPACKAGEUNIT ON}

//
// Base classes to implement various types of OTA IOTAModuleCreator's and
// IOTAFile's
//
// The following Creators are available (IOTAModule)
//       TFormCreatorModule:          Creates a standard Win32 Form
//       TDataModuleCreatorModule:    Creates a stardard Win32 DataModule
//       TFrameCreatorModule          Creates a stardard Win32 Frame
//
// The following Files are avaialble (IOTAFile)
//       TBaseFormCreatorFile:        Creates code for Form, DataModule, Frame
//

interface

{$I ..\Compilers.inc}
                  
uses
    Windows, SysUtils, ZTO.ToolsAPI.OTA.Utilities, ToolsApi;

type
    //
    //  Implements a basic IOTAFile
    //
    TBaseCreatorFile = class(TInterfacedObject, IOTAFile)
    private
        FAge: TDateTime;
    public
        constructor Create;
        function GetSource: string; virtual;
        function GetAge: TDateTime;
    end;

    TBaseCreatorFileClass = class of TBaseCreatorFile;

    //
    // Implements IOTAFile for the TBaseFormCreatorModule to create
    // a Form
    //
    TModuleCreatorFile = class(TBaseCreatorFile)
    private
        FModuleIdent: String;
        FFormIdent: String;
        FAncestorIdent: string;
    public
        constructor Create(const ModuleIdent, FormIdent, AncestorIdent: string);
        function GetSource: String; override;
    end;

    TModuleCreatorFileClass = class of TModuleCreatorFile;

    //
    // Implements IOTACreator and IOTAModuleCreator for Module creation
    //
    TBaseCreatorModule = class(TInterfacedObject, IOTACreator, IOTAModuleCreator)
    public
        // IOTACreator
        function GetCreatorType: string; virtual; abstract;
        function GetExisting: Boolean;
        function GetFileSystem: string;
        function GetOwner: IOTAModule;
        function GetUnnamed: Boolean;

        // IOTAModuleCreator
        function GetAncestorName: string; virtual;
        function GetImplFileName: string;
        function GetIntfFileName: string;
        function GetFormName: string; virtual;
        function GetMainForm: Boolean;
        function GetShowForm: Boolean;
        function GetShowSource: Boolean;
        function NewFormFile(const FormIdent, AncestorIdent: string): IOTAFile;
        function NewImplSource(const ModuleIdent, FormIdent, AncestorIdent: string): IOTAFile; virtual;
        function NewIntfSource(const ModuleIdent, FormIdent, AncestorIdent: string): IOTAFile; virtual;
        procedure FormCreated(const FormEditor: IOTAFormEditor);

        function GetImplFile: TModuleCreatorFileClass; virtual;
        function GetIntfFile: TModuleCreatorFileClass; virtual;

        property AncestorName: string read GetAncestorName;
        property FormName: string read GetFormName;
        property ImplFileName: string read GetImplFileName;
        property IntfFileName: string read GetIntfFileName;
        property MainForm: Boolean read GetMainForm;
        property ShowForm: Boolean read GetShowForm;
        property ShowSource: Boolean read GetShowSource;
    end;

    //
    //  Implements a specialized Form Module
    //
    TFormCreatorModule = class(TBaseCreatorModule)
    public
        function GetCreatorType: string; override;
        function GetAncestorName: string; override;
    end;

    //
    //  Implements a specialized DataModule Module
    //
    TDataModuleCreatorModule = class(TBaseCreatorModule)
    public
        function GetAncestorName: string; override;
    end;

    //
    //  Implements a specialized Frame Module
    //
    TModuleCreatorModule = class(TBaseCreatorModule)
        function GetAncestorName: string; override;
    end;

{$IFDEF COMPILER_8_UP}
    // These must be called in the initialization section of a unit
    function AddDelphiCategory(CategoryID, CategoryCaption: string): IOTAGalleryCategory;
    function AddBuilderCategory(CategoryID, CategoryCaption: string): IOTAGalleryCategory;
    procedure RemoveCategory(Category: IOTAGalleryCategory);
{$ENDIF COMPILER_8_UP}


implementation

{$IFDEF COMPILER_8_UP}
function AddDelphiCategory(CategoryID, CategoryCaption: string): IOTAGalleryCategory;
var
    Manager: IOTAGalleryCategoryManager;
    ParentCategory: IOTAGalleryCategory;
begin
    Result := nil;
    Manager := BorlandIDEServices as IOTAGalleryCategoryManager;

    if Assigned(Manager) then
    begin
        ParentCategory := Manager.FindCategory(sCategoryDelphiNew);
        if Assigned(ParentCategory) then
            Result := Manager.AddCategory(ParentCategory, CategoryID, CategoryCaption);
    end;
end;

function AddBuilderCategory(CategoryID, CategoryCaption: string): IOTAGalleryCategory;
var
    Manager: IOTAGalleryCategoryManager;
    ParentCategory: IOTAGalleryCategory;
begin
    Result := nil;
    Manager := BorlandIDEServices as IOTAGalleryCategoryManager;
    if Assigned(Manager) then
    begin
        ParentCategory := Manager.FindCategory(sCategoryCBuilderNew);
        if Assigned(ParentCategory) then
            Result := Manager.AddCategory(ParentCategory, CategoryID, CategoryCaption);
    end
end;

procedure RemoveCategory(Category: IOTAGalleryCategory);
var
    Manager: IOTAGalleryCategoryManager;
begin
    Manager := BorlandIDEServices as IOTAGalleryCategoryManager;
    if Assigned(Manager) then
    begin
        if Assigned(Category) then
            Manager.DeleteCategory(Category)
    end
end;
{$ENDIF COMPILER_8_UP}

{ TBaseCreatorFile }
constructor TBaseCreatorFile.Create;
begin
    FAge := -1;  // Flag age as New File
end;

function TBaseCreatorFile.GetAge: TDateTime;
begin
    Result := FAge
end;

function TBaseCreatorFile.GetSource: string;
begin
    Result := ''
end;

{ TModuleCreatorFile }

constructor TModuleCreatorFile.Create(const ModuleIdent, FormIdent, AncestorIdent: string);
begin
    FAge := -1;  // Flag age as New File
    FModuleIdent := ModuleIdent;
    FFormIdent := FormIdent;
    FAncestorIdent := AncestorIdent;
end;

function TModuleCreatorFile.GetSource: String;
begin
    // Parameterize the code with the current Identifiers
    if FModuleIdent <> '' then
        Result := StringReplace(Result, '<UNITNAME>', FModuleIdent, [rfReplaceAll, rfIgnoreCase]);
    if FFormIdent <> '' then
        Result := StringReplace(Result, '<CLASS_ID>', FFormIdent, [rfReplaceAll, rfIgnoreCase]);
    if FAncestorIdent <> '' then
        Result := StringReplace(Result, '<ANCESTOR_ID>', FAncestorIdent, [rfReplaceAll, rfIgnoreCase]);
end;

{ TBaseCreatorModule }

procedure TBaseCreatorModule.FormCreated(const FormEditor: IOTAFormEditor);
begin

end;

function TBaseCreatorModule.GetAncestorName: string;
begin
    Result := '';
end;

function TBaseCreatorModule.GetExisting: Boolean;
begin
    Result := False; // Create a new module
end;

function TBaseCreatorModule.GetFileSystem: string;
begin
    Result := ''; // Default File System
end;

function TBaseCreatorModule.GetFormName: string;
begin
    Result := '';
end;

function TBaseCreatorModule.GetImplFile: TModuleCreatorFileClass;
begin
    Result := TModuleCreatorFile;
end;

function TBaseCreatorModule.GetImplFileName: string;
begin
    Result := '';
end;

function TBaseCreatorModule.GetIntfFileName: string;
begin
   Result := '';
end;

function TBaseCreatorModule.GetIntfFile: TModuleCreatorFileClass;
begin
    Result := TModuleCreatorFile;
end;

function TBaseCreatorModule.GetMainForm: Boolean;
begin
    Result := True;
end;

function TBaseCreatorModule.GetOwner: IOTAModule;
begin
    Result := GetCurrentProject;  // Owned by current project
end;

function TBaseCreatorModule.GetShowForm: Boolean;
begin
    Result := True;
end;

function TBaseCreatorModule.GetShowSource: Boolean;
begin
    Result := True;
end;

function TBaseCreatorModule.GetUnnamed: Boolean;
begin
    Result := True; // Project needs to be named/saved
end;

function TBaseCreatorModule.NewFormFile(const FormIdent, AncestorIdent: string): IOTAFile;
begin
    Result := nil;
end;

function TBaseCreatorModule.NewImplSource(const ModuleIdent, FormIdent, AncestorIdent: string): IOTAFile;
begin
    Result := nil;
    if GetImplFile <> nil then
        Result := GetImplFile.Create(ModuleIdent, FormIdent, AncestorIdent);
end;

function TBaseCreatorModule.NewIntfSource(const ModuleIdent, FormIdent, AncestorIdent: string): IOTAFile;
begin
    Result := nil;
    if GetIntfFile <> nil then
        Result := GetIntfFile.Create(ModuleIdent, FormIdent, AncestorIdent);
end;

{ TFormCreatorModule }

function TFormCreatorModule.GetAncestorName: string;
begin
    Result := 'TForm'
end;

function TFormCreatorModule.GetCreatorType: string;
begin
    Result := sForm
end;

{ TDataModuleCreatorModule }

function TDataModuleCreatorModule.GetAncestorName: string;
begin
    Result := 'TDataModule'
end;

{ TModuleCreatorModule }

function TModuleCreatorModule.GetAncestorName: string;
begin
    Result := 'TFrame'
end;

end.
