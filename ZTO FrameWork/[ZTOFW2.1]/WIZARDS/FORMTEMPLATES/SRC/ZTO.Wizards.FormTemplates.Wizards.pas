unit ZTO.Wizards.FormTemplates.Wizards;

interface

{$I ..\..\..\ZTOCL\SRC\Compilers.inc}

uses ToolsApi
   , Windows;

type
  TZTOWizard = class(TNotifierObject
                    ,IOTAWizard
                    ,IOTARepositoryWizard
                    {$IFDEF COMPILER_6_UP},IOTARepositoryWizard60{$ENDIF}
                    {$IFDEF COMPILER_8_UP},IOTARepositoryWizard80{$ENDIF}
                    ,IOTAFormWizard)
  protected
    // IOTAWizard
    function GetIDString: string; virtual; abstract;
    function GetName: string; virtual; abstract;
    function GetState: TWizardState; virtual;
    procedure Execute; virtual; abstract;

    // IOTARepositoryWizard
    function GetAuthor: string; virtual;
    function GetComment: string; virtual;
    function GetPage: string; virtual; abstract;
    function GetGlyph: Cardinal; virtual;

    // IOTARepositoryWizard60
    function GetDesigner: string; virtual;
    property Designer: string read GetDesigner;

    // IOTARepositoryWizard80
    function GetGalleryCategory: IOTAGalleryCategory; virtual; abstract;
    function GetPersonality: string; virtual;
    property GalleryCategory: IOTAGalleryCategory read GetGalleryCategory;
    property Personality: string read GetPersonality;
  end;

implementation

{ TZTOWizard }

function TZTOWizard.GetAuthor: string;
begin
  Result := 'Zetta-Ømnis Soluções Tecnológicas Ltda. / Carlos Barreto Feitoza Filho';
end;

function TZTOWizard.GetComment: string;
begin
  Result := 'Anak Krakatoa Base Wizard';
end;

function TZTOWizard.GetDesigner: string;
begin
  Result := dVCL;
end;

function TZTOWizard.GetPersonality: string;
begin
  Result := sDelphiPersonality; // or sDelphiDotNetPersonality or sCBuilderPersonality or sCSharpPersonality, etc
end;

function TZTOWizard.GetGlyph: Cardinal;
begin
  Result := 0;
end;

function TZTOWizard.GetState: TWizardState;
begin
  Result := [];
end;

end.
