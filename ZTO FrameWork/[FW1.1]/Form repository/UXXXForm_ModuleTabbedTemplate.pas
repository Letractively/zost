unit UXXXForm_ModuleTabbedTemplate;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ExtCtrls, ActnList, ComCtrls,

  UXXXDataModule, UXXXTypesConstantsAndClasses, UBalloonToolTip;

type
    { TODO 5 -oCarlos Feitoza -cMELHORIA : Eu deveria ter herdado uma vez cada
    formulario base e depois dentro da aplicação herdar deste form herdado,
    assim eu poderia converter coisas como configurations que ao inves de ser
    TXXXConfigurations seria TBDOConfigurations, entre outras vantagens. Um dia
    faça isso }
    
	{ TODO : Isso é necessário aqui pois UDataModule_Basic altera o comportamento
    padrão dos TAction e TActionList }
//	TAction = class(ActnList.TAction);
//    TActionList = class(ActnList.TActionList);

	TXXXForm_ModuleTabbedTemplateClass = class of TXXXForm_ModuleTabbedTemplate;

    PXXXForm_ModuleTabbedTemplate = ^TXXXForm_ModuleTabbedTemplate;

    TModuleCreateParameters = record
        { quando isso for implementado tem de ter esse nome. Veja o que foi
        feito com Dialog template }
    end;

    TXXXForm_ModuleTabbedTemplate = class(TForm)
	    Shape_HeaderBackground: TShape;
	    PanelTitulo: TPanel;
    	Shape_HeaderLine: TShape;
	    Label_HeaderTitle: TLabel;
    	Image_CloseModule: TImage;
    	Shape_HeaderLineVertical: TShape;
    	ActionList_LocalActions: TActionList;
    	procedure Image_CloseModuleClick(Sender: TObject);
    	procedure FormShow(Sender: TObject);
	    procedure FormClose(Sender: TObject; var Action: TCloseAction);
	private
    	{ Private declarations }
        FMyDataModule: TXXXDataModule;
        FConfigurations: TXXXConfigurations;
        FProgressBarModuleLoad: TProgressBar;
        FAutoFree: Boolean;
        FMyReference: PXXXForm_ModuleTabbedTemplate;
        procedure CreateNewOrUseDataModuleReference(const aConfigurations: TXXXConfigurations; const aDataModuleClass: TXXXDataModuleClass; const aDataModuleReference: TXXXDataModule; aDataModuleMain: TXXXDataModule_Main = nil);
    protected
    	property ProgressBarModuleLoad: TProgressBar read FProgressBarModuleLoad;
  	public
    	{ Public declarations }
	    constructor Create(aOwner: TComponent; var aReference; aAutoFree: Boolean = True; aConfigurations: TXXXConfigurations = nil; aDataModuleClass: TXXXDataModuleClass = nil; aDataModuleReference: TXXXDataModule = nil; aDataModuleMain: TXXXDataModule_Main = nil; aProgressBarModuleLoad: TProgressBar = nil); reintroduce;
        destructor Destroy; override;

        property MyDataModule: TXXXDataModule read FMyDataModule;
        property Configurations: TXXXConfigurations read FConfigurations;
    end;

implementation

{$R *.dfm}

//resourcestring
//    RS_NO_DATAMODULE_ASSIGNED = 'Este form não possui DataModule associado';

{ TForm_ModuleTabbedTemplate }

constructor TXXXForm_ModuleTabbedTemplate.Create(aOwner: TComponent; var aReference; aAutoFree: Boolean = True; aConfigurations: TXXXConfigurations = nil; aDataModuleClass: TXXXDataModuleClass = nil; aDataModuleReference: TXXXDataModule = nil; aDataModuleMain: TXXXDataModule_Main = nil; aProgressBarModuleLoad: TProgressBar = nil);
begin
	FMyDataModule := nil;
    FMyReference := @aReference;
    FAutoFree := aAutoFree;
    FConfigurations := aConfigurations;
    FProgressBarModuleLoad := aProgressBarModuleLoad;
	CreateNewOrUseDataModuleReference(aConfigurations,aDataModuleClass,aDataModuleReference,aDataModuleMain);
    inherited Create(aOwner);
end;

procedure TXXXForm_ModuleTabbedTemplate.CreateNewOrUseDataModuleReference(const aConfigurations: TXXXConfigurations; const aDataModuleClass: TXXXDataModuleClass; const aDataModuleReference: TXXXDataModule; aDataModuleMain: TXXXDataModule_Main = nil);
var
    DataModuleCreateParameters: TDataModuleCreateParameters;
begin
    if Assigned(aDataModuleReference) then
    	FMyDataModule := aDataModuleReference
	else if Assigned(aDataModuleClass) then
    begin
    	ZeroMemory(@DataModuleCreateParameters,SizeOf(TDataModuleCreateParameters));
        with DataModuleCreateParameters do
        begin
            Configurations := aConfigurations;
            DataModuleMain := aDataModuleMain;
            //Description := aDescription;
            ProgressBarModuleLoad := FProgressBarModuleLoad;
        end;
    	FMyDataModule := aDataModuleClass.Create(Self,DataModuleCreateParameters);
    end;
end;

destructor TXXXForm_ModuleTabbedTemplate.Destroy;
begin
    FreeAndNil(FMyDataModule);
    if FAutoFree then
		FMyReference^ := nil;
  	inherited;
end;

procedure TXXXForm_ModuleTabbedTemplate.FormClose(Sender: TObject; var Action: TCloseAction);
begin
	{ TODO : Ao fechar este form, seja com Close ou retornando um ModalResult,
    sua referência será liberada da memória }
    if FAutoFree then
		Action := caFree;
end;

procedure TXXXForm_ModuleTabbedTemplate.FormShow(Sender: TObject);
begin
    Label_HeaderTitle.Caption := Caption;
    { O método abaixo lançao o evento DataChange para todos os datasources da
    tela, o que realiza algumas operações básicas para cada um dos datasets }
    FMyDataModule.DoDataChangeForAllDataSources;
end;

//function TForm_ModuleTabbedTemplate.GetDataModule: TXXXDataModule;
//begin
//	if not Assigned(FDataModule) then
//    	raise Exception.Create(RS_NO_DATAMODULE_ASSIGNED);
//
//    Result := FDataModule;
//end;

procedure TXXXForm_ModuleTabbedTemplate.Image_CloseModuleClick(Sender: TObject);
begin
	{ Destruindo tabsheet pai deste form. Isso destroi por tabela este form }
	TTabSheet(Parent).Free;
end;

end.
