unit UXXXForm_MainDialogTemplate;

interface

uses
    Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
    Dialogs, StdCtrls, Buttons, ExtCtrls, ActnList,

    UXXXDataModule, UXXXTypesConstantsAndClasses;

type
	{ TODO : Isso é necessário aqui pois UXXXDataModule altera o comportamento
    padrão dos TAction e TActionList }
	TAction = class(ActnList.TAction);
    TActionList = class(ActnList.TActionList);

    TMainDialogCreateParameters = record
        Configurations: TXXXConfigurations; { nil }
        MyDataModule: TXXXDataModule;
        MyDataModuleClass: TXXXDataModuleClass; { nil }
        MyDataModuleDescription: ShortString; { '' }
    end;

    TXXXForm_MainDialogTemplate = class(TForm)
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

        procedure DoCloseQuery(Sender: TObject; var CanClose: Boolean);
    private
    	{ Private declarations }
        FCreateParameters: TMainDialogCreateParameters;

        procedure CreateNewDataModule;
    protected
    	{ Protected declarations }
        property CreateParameters: TMainDialogCreateParameters read FCreateParameters;
    public
	    { Public declarations }
        constructor Create(const aOwner: TComponent;
                           const aConfigurations: TXXXConfigurations;
                           const aMyDataModuleClass: TXXXDataModuleClass;
                           const aMyDataModuleDescription: ShortString); reintroduce; virtual;
        destructor Destroy; override;

    end;

implementation

uses
  	DB;

{$R *.dfm}

constructor TXXXForm_MainDialogTemplate.Create(const aOwner: TComponent;
                                               const aConfigurations: TXXXConfigurations;
                                               const aMyDataModuleClass: TXXXDataModuleClass;
                                               const aMyDataModuleDescription: ShortString);
var
	P: Pointer;
begin
    ZeroMemory(@FCreateParameters,SizeOf(TMainDialogCreateParameters));

	FCreateParameters.Configurations := aConfigurations;
    FCreateParameters.MyDataModuleClass := aMyDataModuleClass;
    FCreateParameters.MyDataModuleDescription := aMyDataModuleDescription;

    CreateNewDataModule;

    { Se a aplicação terminou antes de começar então não precisamos fazer mais
    nada. O uso de Processmessages é obrigatório para mudar o status de
    Application.Terminated. Isso pode parecer forçado, mas deve ser colocado em
    todos os templates de formulário principal, pois o DataModule criado
    juntamente com cada formulário principal pode cancelar o carregamento da
    aplicação }
    Application.ProcessMessages;
    if Application.Terminated then
    	Exit;

    inherited Create(aOwner);

    { O código a seguir seta o form atual como sendo o principal. Nunca crie uma
    instância deste dentro da aplicação sendo executada... }
	P := @Application.Mainform;
    Pointer(P^) := Self;
end;

procedure TXXXForm_MainDialogTemplate.CreateNewDataModule;
var
    DataModuleCreateParameters: TDataModuleCreateParameters;
begin
    { Quando este procedure acabar "FCreateParameters.MyDataModule" sempre
    conterá uma referência a um datamodule ou NIL caso o Form não possua
    datamodule associado }
	if Assigned(FCreateParameters.MyDataModuleClass) then
    begin
    	ZeroMemory(@DataModuleCreateParameters,SizeOf(TDataModuleCreateParameters));
        with DataModuleCreateParameters do
        begin
            Configurations := FCreateParameters.Configurations;
            Description := FCreateParameters.MyDataModuleDescription;
        end;
    	FCreateParameters.MyDataModule := FCreateParameters.MyDataModuleClass.Create(Self
                                                                                    ,DataModuleCreateParameters);
    end;
end;


destructor TXXXForm_MainDialogTemplate.Destroy;
begin
    FCreateParameters.MyDataModule.Free;
  	inherited;
end;

procedure TXXXForm_MainDialogTemplate.DoCloseQuery(Sender: TObject; var CanClose: Boolean);
begin
    { TODO -oCarlos Feitoza -cCOMPLEMENTO : Coloque a pergunta de fechamento aqui }
    if FCreateParameters.MyDataModule.AddEntitiesForm <> nil then
    	FCreateParameters.MyDataModule.AddEntitiesForm.Close;
end;

end.
