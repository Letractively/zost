unit UXXXForm_MainDialogTemplate;

interface

uses
    Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
    Dialogs, StdCtrls, Buttons, ExtCtrls, ActnList,

    UXXXDataModule, UXXXTypesConstantsAndClasses;

type
	{ TODO : Isso � necess�rio aqui pois UXXXDataModule altera o comportamento
    padr�o dos TAction e TActionList }
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

    { Se a aplica��o terminou antes de come�ar ent�o n�o precisamos fazer mais
    nada. O uso de Processmessages � obrigat�rio para mudar o status de
    Application.Terminated. Isso pode parecer for�ado, mas deve ser colocado em
    todos os templates de formul�rio principal, pois o DataModule criado
    juntamente com cada formul�rio principal pode cancelar o carregamento da
    aplica��o }
    Application.ProcessMessages;
    if Application.Terminated then
    	Exit;

    inherited Create(aOwner);

    { O c�digo a seguir seta o form atual como sendo o principal. Nunca crie uma
    inst�ncia deste dentro da aplica��o sendo executada... }
	P := @Application.Mainform;
    Pointer(P^) := Self;
end;

procedure TXXXForm_MainDialogTemplate.CreateNewDataModule;
var
    DataModuleCreateParameters: TDataModuleCreateParameters;
begin
    { Quando este procedure acabar "FCreateParameters.MyDataModule" sempre
    conter� uma refer�ncia a um datamodule ou NIL caso o Form n�o possua
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
