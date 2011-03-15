unit UXXXForm_DialogTemplate;

interface

uses
    Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
    Dialogs, StdCtrls, Buttons, ExtCtrls, ActnList,

    UXXXDataModule, UXXXTypesConstantsAndClasses;

type
	TXXXForm_DialogTemplateClass = class of TXXXForm_DialogTemplate;

    PXXXForm_DialogTemplate = ^TXXXForm_DialogTemplate;

    TDialogCreateParameters = record
    	AutoFree: Boolean; { False }
        AutoShow: Boolean; { False}
        FormStyle: TFormStyle; { fsNormal }
        Modal: Boolean; { False }
        Configurations: TXXXConfigurations; { nil }
        MyDataModuleClass: TXXXDataModuleClass; { nil }
        MyDataModule: TXXXDataModule; { nil }
        MyDataModuleDescription: ShortString; { '' }
        DataModuleMain: TXXXDataModule_Main; { nil }
        DialogDescription: String; { '' }
        OnFormCreate: TNotifyEvent; { nil }
        OnFormDestroy: TNotifyEvent; { nil }
    end;

    TXXXForm_DialogTemplate = class(TForm)
    	Shape_FooterBackground: TShape;
    	Shape_FooterLine: TShape;
	    Shape_Organizer: TShape;
    	Shape_BackgroundHeader: TShape;
	    Shape_HeaderLine: TShape;
	    Label_DialogDescription: TLabel;
    	Image_Dialog: TImage;
    	ActionList_LocalActions: TActionList;
        Panel_Header: TPanel;
        Bevel_Header: TBevel;
        Panel_Footer: TPanel;
        Bevel_Footer: TBevel;
	    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    	procedure FormCreate(Sender: TObject);
	    procedure FormDestroy(Sender: TObject);
    private
    	{ Private declarations }
        FMyReference: PXXXForm_DialogTemplate;
//        FMyDataModule: TXXXDataModule;
        FAutoDestroyDataModule: Boolean;

        FCreateParameters: TDialogCreateParameters;

        FOnFormCreate: TNotifyEvent;
        FOnFormDestroy: TNotifyEvent;

        procedure CreateNewDataModuleOrUseAReference;
    protected
    	{ Protected declarations }
        procedure Loaded; override;

//	    property MyDataModule: TXXXDataModule read FMyDataModule;
    public
	    { Public declarations }
        { TODO : Eu acho que os construtores deveriam ser privados. Veja como isso pode ser feito sem afetar o resto do programa }
        constructor Create(const aOwner: TComponent; var aReference; const aCreateParameters: TDialogCreateParameters); reintroduce; virtual;
        destructor Destroy; override;

		class function CreateDialog(aOwner: TComponent; var aReference; aForm_DialogTemplateClass: TXXXForm_DialogTemplateClass; aCreateParameters: TDialogCreateParameters): TModalResult; static;
        property CreateParameters: TDialogCreateParameters read FCreateParameters;
    end;

implementation

uses
  	DB;

{$R *.dfm}

constructor TXXXForm_DialogTemplate.Create(const aOwner: TComponent; var aReference; const aCreateParameters: TDialogCreateParameters);
begin
    FMyReference := @aReference;
    FCreateParameters := aCreateParameters;
    CreateNewDataModuleOrUseAReference;
    inherited Create(aOwner);
end;

procedure TXXXForm_DialogTemplate.CreateNewDataModuleOrUseAReference;
var
    DataModuleCreateParameters: TDataModuleCreateParameters;
begin
    { Quando este procedure acabar "FCreateParameters.MyDataModule" sempre
    conterá uma referência a um datamodule ou NIL caso o Form não possua
    datamodule associado }
	FAutoDestroyDataModule := True;

    if Assigned(FCreateParameters.MyDataModule) then
        FAutoDestroyDataModule := False
	else if Assigned(FCreateParameters.MyDataModuleClass) then
    begin
    	ZeroMemory(@DataModuleCreateParameters,SizeOf(TDataModuleCreateParameters));
        with DataModuleCreateParameters do
        begin
            Configurations := FCreateParameters.Configurations;
            DataModuleMain := FCreateParameters.DataModuleMain;
            Description := FCreateParameters.MyDataModuleDescription;
        end;
    	FCreateParameters.MyDataModule := FCreateParameters.MyDataModuleClass.Create(Self
                                                                                  ,DataModuleCreateParameters);
    end;
end;

//procedure TXXXForm_DialogTemplate.CreateNewOrUseDataModuleReference;
//var
//    DataModuleCreateParameters: TDataModuleCreateParameters;
//begin
//	FAutoDestroyDataModule := True;
//    FMyDataModule := nil;
//
//    if Assigned(FCreateParameters.MyDataModule) then
//    begin
//    	FMyDataModule := FCreateParameters.MyDataModule;
//        FAutoDestroyDataModule := False;
//    end
//	else if Assigned(FCreateParameters.MyDataModuleClass) then
//    begin
//    	ZeroMemory(@DataModuleCreateParameters,SizeOf(TDataModuleCreateParameters));
//        with DataModuleCreateParameters do
//        begin
//            Configurations := FCreateParameters.Configurations;
//            DataModuleMain := FCreateParameters.DataModuleMain;
//            Description := FCreateParameters.MyDataModuleDescription;
//        end;
//    	FMyDataModule := FCreateParameters.MyDataModuleClass.Create(Self,DataModuleCreateParameters);
//    end;
//end;

(*
procedure TXXXForm_DialogTemplate.CreateNewOrUseDataModuleReference(const aConfigurations: TXXXConfigurations; const aDataModuleClass: TDataModuleClass; const aDataModuleReference: TDataModule; aMainDataModule: TDataModule);
var
    DataModule_BasicCreateParameters: TXXXDataModule_BasicCreateParameters;
begin
	AutoDestroyDataModule := True;
    if Assigned(aDataModuleReference) then
    begin
    	FDataModule := TXXXDataModule(aDataModuleReference);
        AutoDestroyDataModule := False;
    end
	else if Assigned(aDataModuleClass) then
    begin
    	ZeroMemory(@DataModule_BasicCreateParameters,SizeOf(TXXXDataModule_BasicCreateParameters));
        with DataModule_BasicCreateParameters do
        begin
            Owner := Self;
            Configurations := aConfigurations;
            MainDataModule := TBDODataModule_Connection(aMainDataModule);
            //Description := aDescription;
        end;
    	FDataModule := TXXXDataModule_BasicClass(aDataModuleClass).Create(Self,aConfigurations,TBDODataModule_Connection(aMainDataModule));
    end;
end;
*)

destructor TXXXForm_DialogTemplate.Destroy;
begin
	if FAutoDestroyDataModule then
	    FreeAndNil(FCreateParameters.MyDataModule);

    if FCreateParameters.AutoFree then
		FMyReference^ := nil;
  	inherited;
end;

procedure TXXXForm_DialogTemplate.FormClose(Sender: TObject; var Action: TCloseAction);
begin
	{ TODO : Ao fechar este form, seja com Close ou retornando um ModalResult,
    sua referência será liberada da memória }
    if FCreateParameters.AutoFree then
		Action := caFree;
end;

procedure TXXXForm_DialogTemplate.FormCreate(Sender: TObject);
begin
	if Trim(Label_DialogDescription.Caption) = '' then
	    Label_DialogDescription.Caption := FCreateParameters.DialogDescription;

    if Assigned(FOnFormCreate) then
    	FOnFormCreate(Self);
end;

procedure TXXXForm_DialogTemplate.FormDestroy(Sender: TObject);
begin
    if Assigned(FOnFormDestroy) then
		FOnFormDestroy(Self);
end;

{ TODO -oCarlos Feitoza -cEXPLICAÇÃO : O método Loaded é chamado para cada
componente de um form. Neste caso eu sobrescrevi o método Loaded do form. Este
método é chamado imediatamente após o término do construtor e é nele onde as
propriedades lidas do DFM são atribuídas às propriedades do objeto FORM. Aqui é
o lugar que pode ser usado para reatribuir eventos que foram atribuídos em
tempo de projeto. A intenção do uso deste método é se ter uma forma de interagir
na criação e na destruição com forms modais }
procedure TXXXForm_DialogTemplate.Loaded;
begin
  	inherited;
	FOnFormCreate := FCreateParameters.OnFormCreate;
    FOnFormDestroy := FCreateParameters.OnFormDestroy;
end;

class function TXXXForm_DialogTemplate.CreateDialog(aOwner: TComponent; var aReference; aForm_DialogTemplateClass: TXXXForm_DialogTemplateClass; aCreateParameters: TDialogCreateParameters): TModalResult;
begin
    Result := -1;
    if not Assigned(TXXXForm_DialogTemplate(aReference)) then
    begin
        TXXXForm_DialogTemplate(aReference) := aForm_DialogTemplateClass.Create(aOwner,aReference,aCreateParameters);

        TXXXForm_DialogTemplate(aReference).FormStyle := aCreateParameters.FormStyle;

        if aCreateParameters.AutoShow then
        begin
            if aCreateParameters.Modal then
                Result := TXXXForm_DialogTemplate(aReference).ShowModal
            else
                TXXXForm_DialogTemplate(aReference).Show;
        end;
    end;
end;

end.
