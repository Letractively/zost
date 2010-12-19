unit ZTO.ToolsAPI.OTA.Utilities;

{$WEAKPACKAGEUNIT ON}

interface

uses
    Windows, ToolsApi;

function GetCurrentProject: IOTAProject;
function GetCurrentProjectGroup: IOTAProjectGroup;
function ModuleIsForm(Module: IOTAModule): Boolean;
function ModuleIsProject(Module: IOTAModule): Boolean;
function ModuleIsProjectGroup(Module: IOTAModule): Boolean;
function ModuleIsTypeLib(Module: IOTAModule): Boolean;
function EditorIsFormEditor(Editor: IOTAEditor): Boolean;
function EditorIsProjectResEditor(Editor: IOTAEditor): Boolean;
function EditorIsTypeLibEditor(Editor: IOTAEditor): Boolean;
function EditorIsSourceEditor(Editor: IOTAEditor): Boolean;
function IsModule(Unk: IUnknown): Boolean;

implementation

function GetCurrentProject: IOTAProject;
var
  ProjectGroup: IOTAProjectGroup;
begin
  Result := nil;
  ProjectGroup := GetCurrentProjectGroup;

  if Assigned(ProjectGroup) then
    if ProjectGroup.ProjectCount > 0 then
      Result := ProjectGroup.ActiveProject
end;

function GetCurrentProjectGroup: IOTAProjectGroup;
var
  IModuleServices: IOTAModuleServices;
  IModule: IOTAModule;
  IProjectGroup: IOTAProjectGroup;
  i: Integer;
begin
  Result := nil;
  IModuleServices := BorlandIDEServices as IOTAModuleServices;
  for i := 0 to IModuleServices.ModuleCount - 1 do
  begin
    IModule := IModuleServices.Modules[i];
    if IModule.QueryInterface(IOTAProjectGroup, IProjectGroup) = S_OK then
    begin
      Result := IProjectGroup;
      Break;
    end;
  end;
end;

function ModuleIsForm(Module: IOTAModule): Boolean;
var
  i: Integer;
  FormEdit: IOTAFormEditor;
begin
  Result := False;
  if Assigned(Module) then
  begin
    // Form Module will have a DFM and a PAS file associated with it
    if Module.GetModuleFileCount > 1 then
    begin
      i := 0;
      // See if one of the Editors is a FormEditor
      while (i < Module.GetModuleFileCount) and not Result do
      begin
        {$IFDEF COMPILER_6_UP}
        Result := Succeeded( Module.ModuleFileEditors[i].QueryInterface(IOTAFormEditor, FormEdit));
        {$ELSE}
        Result := Succeeded( Module.GetModuleFileEditor(i).QueryInterface(IOTAFormEditor, FormEdit));
        {$ENDIF}
        Inc(i);
      end
    end
  end
end;

function ModuleIsProject(Module: IOTAModule): Boolean;
var
  Project: IOTAProject;
begin
  Result := False;
  if Assigned(Module) then
    Result := Succeeded( Module.QueryInterface(IOTAProject, Project))
end;

function ModuleIsProjectGroup(Module: IOTAModule): Boolean;
var
  ProjectGroup: IOTAProjectGroup;
begin
  Result := False;
  if Assigned(Module) then
    Result := Succeeded( Module.QueryInterface(IOTAProjectGroup, ProjectGroup))
end;

function ModuleIsTypeLib(Module: IOTAModule): Boolean;
var
  TypeLib: IOTATypeLibModule;
begin
  Result := False;
  if Assigned(Module) then
    Result := Succeeded( Module.QueryInterface(IOTATypeLibModule, TypeLib))
end;

function EditorIsFormEditor(Editor: IOTAEditor): Boolean;
var
  FormEdit: IOTAFormEditor;
begin
  Result := False;
  if Assigned(Editor) then
    Result := Succeeded( Editor.QueryInterface(IOTAFormEditor, FormEdit))
end;

function EditorIsProjectResEditor(Editor: IOTAEditor): Boolean;
var
  ProjRes: IOTAProjectResource;
begin
  Result := False;
  if Assigned(Editor) then
    Result := Succeeded( Editor.QueryInterface(IOTAProjectResource, ProjRes))
end;

function EditorIsTypeLibEditor(Editor: IOTAEditor): Boolean;
var
  TypeLib: IOTATypeLibEditor;
begin
  Result := False;
  if Assigned(Editor) then
    Result := Succeeded( Editor.QueryInterface(IOTATypeLibEditor, TypeLib))
end;

function EditorIsSourceEditor(Editor: IOTAEditor): Boolean;
var
  SourceEdit: IOTASourceEditor;
begin
  Result := False;
  if Assigned(Editor) then
    Result := Succeeded( Editor.QueryInterface(IOTASourceEditor, SourceEdit))
end;

function IsModule(Unk: IUnknown): Boolean;
var
  Module: IOTAModule;
begin
  Result := False;
  if Assigned(Unk) then
    Result := Succeeded( Unk.QueryInterface(IOTAModule, Module))
end;

end.
