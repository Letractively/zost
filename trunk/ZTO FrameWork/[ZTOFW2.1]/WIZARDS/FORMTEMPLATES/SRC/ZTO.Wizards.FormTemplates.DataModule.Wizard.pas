unit ZTO.Wizards.FormTemplates.DataModule.Wizard;

interface

uses Windows
   , ToolsApi
   , ZTO.ToolsAPI.OTA.Creators
   , ZTO.Wizards.FormTemplates.Wizards;

type
  TZTODataModuleWizard = class(TZTOWizard)
  protected
    function GetIDString: string; override;
    function GetName: string; override;
    procedure Execute; override;

    function GetComment: string; override;
    function GetPage: string; override;
    function GetGlyph: Cardinal; override;

    function GetGalleryCategory: IOTAGalleryCategory; override;

    property GalleryCategory: IOTAGalleryCategory read GetGalleryCategory;
    property Personality;
  end;

  { Para cada formulário, datamodule ou frame devemos criar aqui uma classe
  para manipular seu código-fonte e incluir a Unit correta na cláusula USES }
  TZTODataModuleFileCreator = class(TModuleCreatorFile)
  public
    function GetSource: string; override;
  end;

  { Para cada formulário, datamodule ou frame devemos criar aqui uma classe
  para indicar o ancestral e qual o TModuleCreatorFile associado }
  TZTODataModuleModuleCreator = class(TFormCreatorModule)
  public
    function GetAncestorName: string; override;
    function GetImplFile: TModuleCreatorFileClass; override;
  end;

implementation

uses SysUtils
   , DateUtils;

const
  { As 3 constantes a seguir definem onde o Wizard vai aparecer. Wizards com
  estas mesmas informações, aparecem no mesmo lugar no Object Repository }
  OBJECT_REPOSITORY_CATEGORY_ID = 'ANAKKRAKATOA.WIZARD';
  OBJECT_REPOSITORY_CATEGORY_NAME = 'Anak Krakatoa Wizards';
  OBJECT_REPOSITORY_PAGE_NAME = OBJECT_REPOSITORY_CATEGORY_NAME;
  { As 3 constantes a seguir identificam este Wizard especificamente. Cada
  Wizard diferente deve ter suas próprias informações nas 3 constantes }
  WIZARD_ID = 'ZETTAOMNIS.ANAKKRAKATOA.WIZARD.DATAMODULE'; { EMPRESA.PRODUTO.TIPO.NOME }
  WIZARD_NAME = 'Anak Krakatoa DataModule';
  WIZARD_COMMENT = 'DataModule com opções avançadas adicionais. Contém coleçõ' +
  'es automaticamente preenchidas com todos os TDataSet, TDataSource, TClient' +
  'DataSet e TZConnection de forma a facilitar o acesso interativo a esses co' +
  'mponentes. Possui também propriedades para manipulação desses componentes ' +
  'simultaneamente. Contém uma propriedade exclusiva para armazenamento de SQ' +
  'Ls parametrizados, o que torna o código-fonte mais limpo e legível';
  WIZARD_ICONS = 'KRK_DATAMODULE_ICONS';
  { As duas constantes a seguir são substituídas dentro da constante
  FILE_CONTENT }
  DEFINITIONUNIT = 'ZTO.Wizards.FormTemplates.DataModule';
  ANCESTOR_ID = 'ZTODataModule'; { Sem o "T" inicial }

  FILE_CONTENT =
  'unit <UNITNAME>;'#13#10#13#10 +

  '{ Anak Krakatoa DataModule. Copyright <COPYRIGHTYEAR> Zetta-Ømnis Soluções Tecnológicas Ltda. }'#13#10#13#10 +

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

  'end.';

var
  DelphiCategory: IOTAGalleryCategory;

{ TZTODataModuleModuleCreator }

function TZTODataModuleModuleCreator.GetAncestorName: string;
begin
  Result := ANCESTOR_ID;
end;

function TZTODataModuleModuleCreator.GetImplFile: TModuleCreatorFileClass;
begin
  Result := TZTODataModuleFileCreator;
end;

{ TZTODataModuleFileCreator }

function TZTODataModuleFileCreator.GetSource: string;
begin
  Result := StringReplace(FILE_CONTENT, '<DEFINITIONUNIT>', DEFINITIONUNIT, [rfIgnoreCase]);
  Result := StringReplace(Result,'<COPYRIGHTYEAR>',IntToStr(YearOf(Now)) + ' / ' + IntToStr(YearOf(Now) + 1),[rfIgnoreCase]);
  Result := inherited GetSource;
end;

{ TZTODataModuleWizard }

procedure TZTODataModuleWizard.Execute;
begin
  inherited;
  (BorlandIDEServices as IOTAModuleServices).CreateModule(TZTODataModuleModuleCreator.Create);
end;

function TZTODataModuleWizard.GetComment: string;
begin
  Result := WIZARD_COMMENT;
end;

function TZTODataModuleWizard.GetIDString: string;
begin
  Result := WIZARD_ID;
end;

function TZTODataModuleWizard.GetName: string;
begin
  Result := WIZARD_NAME;
end;

function TZTODataModuleWizard.GetPage: string;
begin
  Result := OBJECT_REPOSITORY_PAGE_NAME;
end;

function TZTODataModuleWizard.GetGalleryCategory: IOTAGalleryCategory;
begin
  Result := DelphiCategory;
end;

function TZTODataModuleWizard.GetGlyph: Cardinal;
begin
  Result := LoadIcon(hInstance, WIZARD_ICONS);
end;

initialization
  DelphiCategory := AddDelphiCategory(OBJECT_REPOSITORY_CATEGORY_ID, OBJECT_REPOSITORY_CATEGORY_NAME);

finalization
  RemoveCategory(DelphiCategory);

end.
