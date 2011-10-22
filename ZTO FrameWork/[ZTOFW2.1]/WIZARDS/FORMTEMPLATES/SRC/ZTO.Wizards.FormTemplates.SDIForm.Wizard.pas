unit ZTO.Wizards.FormTemplates.SDIForm.Wizard;

interface

uses Windows
   , ToolsApi
   , ZTO.ToolsAPI.OTA.Creators
   , ZTO.Wizards.FormTemplates.Wizards;

type
  TZTOSDIFormWizard = class(TZTOWizard)
  protected
    function GetIDString: string; override;
    function GetName: string; override;
    procedure Execute; override;

    function GetAuthor: string; override;
    function GetComment: string; override;
    function GetPage: string; override;
    function GetGlyph: Cardinal; override;

    function GetGalleryCategory: IOTAGalleryCategory; override;

    property GalleryCategory: IOTAGalleryCategory read GetGalleryCategory;
    property Personality;
  end;

  // Para cada formulário, datamodule ou frame devemos criar aqui uma classe
  // para manipular seu código-fonte e incluir a Unit correta na cláusula USES
  TZTOSDIFormFileCreator = class(TModuleCreatorFile)
  public
    function GetSource: string; override;
  end;

//    TZTOFormModuleTabedTemplateUnitFile = class(TModuleCreatorFile)
//    public
//        function GetSource: string; override;
//    end;

  // Para cada formulário, datamodule ou frame devemos criar aqui uma classe
  // para indicar o ancestral e qual o TModuleCreatorFile associado
  TZTOSDIFormModuleCreator = class(TFormCreatorModule)
  public
    function GetAncestorName: string; override;
    function GetImplFile: TModuleCreatorFileClass; override;
  end;

implementation

uses SysUtils
   , DateUtils;

const
  FILE_CONTENT =
  'unit <UNITNAME>;'#13#10#13#10 +

  '{ Formulário SDI comum. Copyright <COPYRIGHTYEAR> ZTO Soluções Tecnológicas Ltda. }'#13#10#13#10 +

  'interface'#13#10#13#10 +

  'uses'#13#10 +
  '  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms,'#13#10 +
  '  <DEFINITIONUNIT>;'#13#10#13#10 +

  'type'#13#10 +
  '  T<CLASS_ID> = class(T<ANCESTOR_ID>)'#13#10 +
  '  private'#13#10 +
  '    { Declarações privadas }'#13#10 +
  '  protected'#13#10 +
  '    { Declarações protegidas }'#13#10 +
  '  public'#13#10 +
  '    { Declarações públicas }'#13#10 +
  '  end;'#13#10#13#10 +

  'implementation'#13#10#13#10 +

  '{$R *.dfm}'#13#10#13#10 +

  'initialization'#13#10 +
  '  RegisterClass(T<CLASS_ID>)'#13#10#13#10 +

  'end.';

var
  DelphiCategory: IOTAGalleryCategory;

{ TZTOSDIFormModuleCreator }

function TZTOSDIFormModuleCreator.GetAncestorName: string;
begin
  Result := 'ZTOSDIForm';
end;

function TZTOSDIFormModuleCreator.GetImplFile: TModuleCreatorFileClass;
begin
  Result := TZTOSDIFormFileCreator;
end;

{ TZTOSDIFormFileCreator }

function TZTOSDIFormFileCreator.GetSource: string;
begin
  Result := StringReplace(FILE_CONTENT, '<DEFINITIONUNIT>', 'ZTO.Wizards.FormTemplates.SDIForm', [rfIgnoreCase]);
  Result := StringReplace(Result,'<COPYRIGHTYEAR>',IntToStr(YearOf(Now)) + ' / ' + IntToStr(YearOf(Now) + 1),[rfIgnoreCase]);
  Result := inherited GetSource;
end;

{ TZTOSDIFormWizard }

procedure TZTOSDIFormWizard.Execute;
begin
  inherited;
  (BorlandIDEServices as IOTAModuleServices).CreateModule(TZTOSDIFormModuleCreator.Create);
end;

function TZTOSDIFormWizard.GetAuthor: string;
begin
  Result := 'Zetta-Ømnis Soluções Tecnológicas';
end;

function TZTOSDIFormWizard.GetComment: string;
begin
  Result := 'Template de um formulário SDI padrão';
end;

function TZTOSDIFormWizard.GetIDString: string;
begin
  Result := 'TZTOSDIFormWizard';
end;

function TZTOSDIFormWizard.GetName: string;
begin
  Result := 'ZTO SDI Form';
end;

function TZTOSDIFormWizard.GetPage: string;
begin
  Result := 'ZTO Form Templates';
end;

function TZTOSDIFormWizard.GetGalleryCategory: IOTAGalleryCategory;
begin
  Result := DelphiCategory;
end;

function TZTOSDIFormWizard.GetGlyph: Cardinal;
begin
  Result := LoadIcon(hInstance, 'ZTO_DIALOG_ICONS');
end;

initialization
  DelphiCategory := AddDelphiCategory('ZTOFormTemplates', 'ZTO Form Templates');

finalization
  RemoveCategory(DelphiCategory);

end.
