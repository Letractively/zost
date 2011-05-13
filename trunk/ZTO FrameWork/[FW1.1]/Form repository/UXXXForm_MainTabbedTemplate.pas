unit UXXXForm_MainTabbedTemplate;

interface

uses
  Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ComCtrls, ExtCtrls, ActnList, ActnCtrls, ToolWin, ActnMan, ActnMenus,
  UXXXForm_ModuleTabbedTemplate, UXXXDataModule, UXXXTypesConstantsAndClasses,
  ImgList, UBalloonToolTip;

type
	{ TODO : Isso é necessário aqui pois UDataModule_Basic altera o comportamento
    padrão dos TAction e TActionList }
	TAction = class(ActnList.TAction);
    TActionList = class(ActnList.TActionList);

    TPageControl = class(ComCtrls.TPageControl)
  	private
	    FOnActivatePage: TNotifyEvent;
    	function GetActivePage: TTabSheet;
    	procedure SetActivePage(Page: TTabSheet);
    public
    	property ActivePage: TTabSheet read GetActivePage write SetActivePage;
        property OnActivatePage: TNotifyEvent read FOnActivatePage write FOnActivatePage;
    end;

	///<author>Carlos Feitoza Filho</author>
    ///    Finalmente um uso interessante para uma classe interposer.
    ///    Descreva mais aqui posteriormente...
    TTabSheet = class(ComCtrls.TTabSheet)
    private
        FOnAfterDestroy: TNotifyEvent;
    public
	    constructor Create(AOwner: TComponent; aNotifyTabsChangedEventHandler: TNotifyEvent); reintroduce;
     	destructor Destroy; override;
    end;

	///<author>Carlos Feitoza Filho</author>
    ///    Esta classe inteposer coloca um comportamento adicional no método
    ///    HIDE dos progressbar de forma que eles se escondam após um certo
    ///    inrvalo de tempo em segundos
    TProgressBar = class(ComCtrls.TProgressBar)
    private
        procedure DoDelayedHide(var Msg: TMessage);
    public
        procedure Hide;
    end;

  	TXXXForm_MainTabbedTemplate = class(TForm)
    	ActionMainMenuBar_Main: TActionMainMenuBar;
    	StatusBar_Main: TStatusBar;
	    ProgressBar_ModuleLoad: TProgressBar;
    	Panel_MainBackground: TPanel;
	    Image_MainBackground: TImage;
    	PageControl_Main: TPageControl;
    	Panel_LayerToolBar: TPanel;
    	ActionToolBar_Main: TActionToolBar;
    	Panel_LayerMainMenu: TPanel;
    	Shape_MainBackground: TShape;
	    ActionList_Tabs: TActionList;
    	Action_PreviousModule: TAction;
	    Action_NextModule: TAction;
    	Action_CloseApplication: TAction;
	    Action_FullScreenApplication: TAction;
    	Action_ModuleNavigator: TAction;
	    Action_CloseAllModules: TAction;
    	Action_BackgroundImage: TAction;
    	Action_ChangePassword: TAction;
    	BalloonToolTip_Validation: TBalloonToolTip;
        Action_MySQLBackupAdRestore: TAction;
    	procedure Action_BackgroundImageExecute(Sender: TObject);

    	procedure DoPanel_MainBackgroundResize(Sender: TObject);
    	procedure DoCreate(Sender: TObject); reintroduce;
	    procedure DoShow(Sender: TObject); reintroduce;
	    procedure Action_PreviousModuleExecute(Sender: TObject);
    	procedure Action_NextModuleExecute(Sender: TObject);
    	procedure Action_CloseApplicationExecute(Sender: TObject);
    	procedure Action_FullScreenApplicationExecute(Sender: TObject);
	    procedure Action_ModuleNavigatorExecute(Sender: TObject);
    	procedure Action_CloseAllModulesExecute(Sender: TObject);
	    procedure StatusBar_MainMouseDown(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
    	procedure Action_ChangePasswordExecute(Sender: TObject);
        procedure DoCloseQuery(Sender: TObject; var CanClose: Boolean);
        procedure Action_MySQLBackupAdRestoreExecute(Sender: TObject);
	private
    	{ Private declarations }
        FDataModule: TXXXDataModule;
        FConfigurations: TXXXConfigurations;
        procedure CreateNewOrUseDataModuleReference(const aConfigurations: TXXXConfigurations; const aDataModuleClass: TXXXDataModuleClass; const aDataModuleReference: TXXXDataModule; aDescription: ShortString);

        procedure LoadBackgroundImage(aRefreshTiled: Boolean = False);
	    procedure DoNotifyTabsChanged(Sender: TObject);
	    procedure AdjustModuleSpecificActions;
	    procedure DoShowHint(Sender: TObject);
    protected
//        function CreateSDIModule(aForm_SDITemplateClass: TForm_ModuleSDITemplateClass; aDataModule_BasicClass: TXXXDataModule_BasicClass; aIsModal: Boolean; var aReference; const aConfigurations: TXXXConfigurations = nil): TModalResult; virtual;
//        function CreateDialog(aForm_DialogTemplateClass: TXXXForm_DialogTemplateClass; aDataModuleClass: TXXXDataModule_BasicClass; aDataModuleReference: TXXXDataModule; var aReference; aAutoFree: Boolean = True; const aConfigurations: TXXXConfigurations = nil): TModalResult; virtual;
        { Esta form é para ser principal, logo ele deve estar ligado ao
        DataModule principal e por isso não temos duas propriedades (Uma para o
        DataModule principal e outra para o Data Module local) }
        property MyDataModule: TXXXDataModule read FDataModule;
        property Configurations: TXXXConfigurations read FConfigurations;
    public
	    { Public declarations }
        constructor Create(aOwner: TComponent; aDescription: ShortString; aConfigurations: TXXXConfigurations = nil; aDataModuleClass: TXXXDataModuleClass = nil; aDataModuleReference: TXXXDataModule = nil); reintroduce;
        destructor Destroy; override;
		procedure CreateTabbedModule(aForm_ModuleTabbedTemplateClass: TXXXForm_ModuleTabbedTemplateClass; aDataModule_BasicClass: TXXXDataModuleClass; var aReference; const aConfigurations: TXXXConfigurations = nil; aDataModuleAlpha: TXXXDataModule_Main = nil); virtual;
	end;

implementation

uses
	Windows,

  	UXXXForm_DialogTemplate, UForm_ConfigureBackgroundImage, UForm_ModulesThumbnails,
  	UXXXForm_ChangePassword, UXXXForm_MySQLBackupAndRestore;

{$R *.dfm}

const
    IDT_DELAYED_HIDE_PROGRESSBAR = 1;

{ TForm_MainTabbedTemplate }

procedure TXXXForm_MainTabbedTemplate.LoadBackgroundImage(aRefreshTiled: Boolean = False);
var
	i,j: Word;
    TempImage: TImage;
begin
	Image_MainBackground.Picture := nil;
    with Configurations do
        if (Trim(BackGroundImage) <> '') and (FileExists(BackGroundImage)) then
        begin
            Image_MainBackground.Picture.LoadFromFile(BackGroundImage);

//            if aRefreshTiled and (BackgroundImageModifier = bimTiled) and (BackgroundImagePosition = bipCentered) then
//            begin
//                with Image_MainBackground do
//                    try
//                        TempImage := nil;
//                        TempImage := TImage.Create(Self);
//                        TempImage.Picture.Assign(Picture);
//                        Picture := nil;
//                        Align := alClient;
//                        AutoSize := False;
//                        Stretch := False;
//                        Center := False;
//                        for i := 0 to Width div TempImage.Picture.Width do
//                            for j := 0 to Height div TempImage.Picture.Height do
//                                Canvas.Draw(i*TempImage.Picture.Width,j*TempImage.Picture.Height,TempImage.Picture.Graphic);
//                    finally
//                        FreeAndNil(TempImage);
//                    end;
//            end
//            else
                case BackgroundImagePosition of
                    bipTopLeft: with Image_MainBackground do
                    begin
                        Align := alNone;
                        AutoSize := True;
                        Anchors := [akLeft,akTop];
                        Top := 0;
                        Left := 0;
                    end;
                    bipTopRight: with Image_MainBackground do
                    begin
                        Align := alNone;
                        AutoSize := True;
                        Anchors := [akRight,akTop];
                        Top := 0;
                        Left := Panel_MainBackground.Width - Width;
                    end;
                    bipBottomLeft: with Image_MainBackground do
                    begin
                        Align := alNone;
                        AutoSize := True;
                        Anchors := [akLeft,akBottom];
                        Top := Panel_MainBackground.Height - Height;
                        Left := 0;
                    end;
                    bipBottomRight: with Image_MainBackground do
                    begin
                        Align := alNone;
                        AutoSize := True;
                        Anchors := [akRight,akBottom];
                        Top := Panel_MainBackground.Height - Height;
                        Left := Panel_MainBackground.Width - Width;
                    end;
                    bipCentered: case BackgroundImageModifier of
                        bimNormal: with Image_MainBackground do
                        begin
                            Align := alClient;
                            AutoSize := False;
                            Stretch := False;
                            Center := True;
                        end;
                        bimZoomed: with Image_MainBackground do
                        begin
                            Align := alClient;
                            AutoSize := False;
                            Stretch := True;
                        end;
                        bimTiled: with Image_MainBackground do
                        begin
                            TempImage := nil;
                            try
                                TempImage := TImage.Create(Self);
                                TempImage.Picture.Assign(Picture);
                                Picture := nil;
                                Align := alClient;
                                AutoSize := False;
                                Stretch := False;
                                Center := False;
                                for i := 0 to Width div TempImage.Picture.Width do
                                    for j := 0 to Height div TempImage.Picture.Height do
                                        Canvas.Draw(i*TempImage.Picture.Width,j*TempImage.Picture.Height,TempImage.Picture.Graphic);
                            finally
                                TempImage.Free;
                            end;
                        end; 
                    end;
                end;
        end;
end;

procedure TXXXForm_MainTabbedTemplate.StatusBar_MainMouseDown(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
	if (X > 0) and (X < TStatusBar(Sender).Panels[0].Width) then
    	Action_ModuleNavigator.Execute;
end;

procedure TXXXForm_MainTabbedTemplate.DoPanel_MainBackgroundResize(Sender: TObject);
begin
	LoadBackgroundImage(True);
end;

procedure TXXXForm_MainTabbedTemplate.DoShow(Sender: TObject);
begin
	AdjustModuleSpecificActions;
end;

procedure TXXXForm_MainTabbedTemplate.DoNotifyTabsChanged(Sender: TObject);
begin
    AdjustModuleSpecificActions;
end;

procedure TXXXForm_MainTabbedTemplate.DoCreate(Sender: TObject);
begin
  PageControl_Main.OnChange := DoNotifyTabsChanged;
  PageControl_Main.OnActivatePage := DoNotifyTabsChanged;

  Application.OnHint := DoShowHint;

  BalloonToolTip_Validation.TipTitle := ShortString(RS_VALIDATE_ERROR_BALLOON_TITLE);
	BalloonToolTip_Validation.TipIcon := tiError;
end;

constructor TXXXForm_MainTabbedTemplate.Create(aOwner: TComponent; aDescription: ShortString; aConfigurations: TXXXConfigurations = nil; aDataModuleClass: TXXXDataModuleClass = nil; aDataModuleReference: TXXXDataModule = nil);
var
	P: Pointer;
begin
	FDataModule := nil;
    FConfigurations := aConfigurations;
	CreateNewOrUseDataModuleReference(aConfigurations,aDataModuleClass,aDataModuleReference,aDescription);

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

destructor TXXXForm_MainTabbedTemplate.Destroy;
begin
    FreeAndNil(FDataModule);
    inherited;
end;

procedure TXXXForm_MainTabbedTemplate.CreateTabbedModule(aForm_ModuleTabbedTemplateClass: TXXXForm_ModuleTabbedTemplateClass; aDataModule_BasicClass: TXXXDataModuleClass; var aReference; const aConfigurations: TXXXConfigurations = nil; aDataModuleAlpha: TXXXDataModule_Main = nil);
var
	TabSheet: TTabSheet;
begin
	try
        if not Assigned(TXXXForm_ModuleTabbedTemplate(aReference)) then
        begin
            TabSheet := TTabSheet.Create(PageControl_Main,DoNotifyTabsChanged);
            TXXXForm_ModuleTabbedTemplate(aReference) := aForm_ModuleTabbedTemplateClass.Create(TabSheet,aReference,True,aConfigurations,aDataModule_BasicClass,nil,aDataModuleAlpha,ProgressBar_ModuleLoad);
            TabSheet.Caption := TXXXForm_ModuleTabbedTemplate(aReference).Caption;
            TXXXForm_ModuleTabbedTemplate(aReference).Parent := TabSheet;
            TXXXForm_ModuleTabbedTemplate(aReference).BorderStyle := bsNone;
            TXXXForm_ModuleTabbedTemplate(aReference).Align := alClient;
	        TabSheet.PageControl := PageControl_Main;
            TXXXForm_ModuleTabbedTemplate(aReference).Top := 0;
            TXXXForm_ModuleTabbedTemplate(aReference).Left := 0;
            TXXXForm_ModuleTabbedTemplate(aReference).Height := TXXXForm_ModuleTabbedTemplate(aReference).Parent.Height;
            TXXXForm_ModuleTabbedTemplate(aReference).Width := TXXXForm_ModuleTabbedTemplate(aReference).Parent.Width;

//			AnimateWindow(TXXXForm_ModuleTabbedTemplate(aReference).Handle,200,AW_CENTER);
        end;
        TXXXForm_ModuleTabbedTemplate(aReference).Show;
    finally
	  	PageControl_Main.ActivePage := TTabSheet(TXXXForm_ModuleTabbedTemplate(aReference).Parent);
        PageControl_Main.Visible := True;
    end;
end;

{ TODO : Considere mover certas rotinas genéricas de criação de janelas para o
DataModule_Basic }
//function TXXXForm_MainTabbedTemplate.CreateSDIModule(aForm_SDITemplateClass: TForm_ModuleSDITemplateClass; aDataModule_BasicClass: TXXXDataModule_BasicClass; aIsModal: Boolean; var aReference; const aConfigurations: TXXXConfigurations = nil): TModalResult;
//begin
//    Result := -1;
//    if not Assigned(TForm_ModuleSDITemplate(aReference)) then
//    begin
//        TForm_ModuleSDITemplate(aReference) := aForm_SDITemplateClass.Create(Self,aConfigurations,aDataModule_BasicClass);
////    	TForm_ModuleSDITemplate(aReference).Hide;
//
//    	if aIsModal then
//		    Result := TForm_ModuleSDITemplate(aReference).ShowModal
//        else
//        	TForm_ModuleSDITemplate(aReference).Show;
//    end;
//end;
//                          cria novamente a acao de configurar imagem aqui
//                          e faz dentro do evento algo = ao que foi feito em
//                          TDataModule_DBBasic.ConfigureDataBase
//function TForm_MainTabbedTemplate.CreateDialog(aForm_DialogTemplateClass: TXXXForm_DialogTemplateClass; aDataModuleClass: TXXXDataModule_BasicClass; aDataModuleReference: TXXXDataModule; var aReference; aAutoFree: Boolean = True; const aConfigurations: TXXXConfigurations = nil): TModalResult;
//begin
//    Result := -1;
//    if not Assigned(TXXXForm_DialogTemplate(aReference)) then
//    begin
//        TXXXForm_DialogTemplate(aReference) := aForm_DialogTemplateClass.Create(Self,aReference,aAutoFree,aConfigurations,aDataModuleClass,aDataModuleReference);
//        Result := TForm_ModuleSDITemplate(aReference).ShowModal;
//    end;
//end;


procedure TXXXForm_MainTabbedTemplate.CreateNewOrUseDataModuleReference(const aConfigurations: TXXXConfigurations; const aDataModuleClass: TXXXDataModuleClass; const aDataModuleReference: TXXXDataModule; aDescription: ShortString);
var
    DataModule_BasicCreateParameters: TDataModuleCreateParameters;
begin
    if Assigned(aDataModuleReference) then
    	FDataModule := aDataModuleReference
	else if Assigned(aDataModuleClass) then
    begin
    	ZeroMemory(@DataModule_BasicCreateParameters,SizeOf(TDataModuleCreateParameters));
        with DataModule_BasicCreateParameters do
        begin
            Configurations := aConfigurations;
            DataModuleMain := nil;
            Description := aDescription;
            ProgressBarModuleLoad := ProgressBar_ModuleLoad;
        end;
    	FDataModule := aDataModuleClass.Create(Self,DataModule_BasicCreateParameters);
    end;
end;

procedure TXXXForm_MainTabbedTemplate.Action_BackgroundImageExecute(Sender: TObject);
var
	Form_ConfigureBackgroundImage: TForm_ConfigureBackgroundImage;
    Form_DialogTemplateCreateParameters: TDialogCreateParameters;
begin
    Form_ConfigureBackgroundImage := nil;
    ZeroMemory(@Form_DialogTemplateCreateParameters,SizeOf(TDialogCreateParameters));
    with Form_DialogTemplateCreateParameters do
    begin
		AutoFree := True;
        AutoShow := True;
        Modal := True;
        Configurations := FConfigurations;
        MyDataModuleClass := nil;
        MyDataModule := nil;
        DataModuleMain := nil;
    end;
    TXXXForm_DialogTemplate.CreateDialog(Self,Form_ConfigureBackgroundImage,TForm_ConfigureBackgroundImage,Form_DialogTemplateCreateParameters);
    LoadBackgroundImage;
end;

procedure TXXXForm_MainTabbedTemplate.Action_ChangePasswordExecute(Sender: TObject);
var
	Form_ChangePassword: TXXXForm_ChangePassword;
    Form_DialogTemplateCreateParameters: TDialogCreateParameters;
begin
    Form_ChangePassword := nil;
    ZeroMemory(@Form_DialogTemplateCreateParameters,SizeOf(TDialogCreateParameters));
    with Form_DialogTemplateCreateParameters do
    begin
		AutoFree := True;
        AutoShow := True;
        Modal := True;
        Configurations := FConfigurations;
        MyDataModuleClass := nil;
        MyDataModule := Self.MyDataModule.DataModuleMain;
        DataModuleMain := Self.MyDataModule.DataModuleMain;
    end;
    TXXXForm_DialogTemplate.CreateDialog(Self,Form_ChangePassword,TXXXForm_ChangePassword,Form_DialogTemplateCreateParameters);
end;

procedure TXXXForm_MainTabbedTemplate.Action_CloseAllModulesExecute(Sender: TObject);
begin
	if PageControl_Main.PageCount > 0 then
    	if MessageBox(Handle,'Todos os módulos abertos serão fechados e todas as informações não salvas serão perdidas. Tem certeza?','Tem certeza?',MB_ICONQUESTION or MB_YESNO) = IDYES then
        	while PageControl_Main.PageCount > 0 do
    			PageControl_Main.Pages[Pred(PageControl_Main.PageCount)].Free;
end;

procedure TXXXForm_MainTabbedTemplate.Action_CloseApplicationExecute(Sender: TObject);
begin
	Close;
end;

procedure TXXXForm_MainTabbedTemplate.Action_FullScreenApplicationExecute(Sender: TObject);
begin
    case TAction(Sender).Tag of
        0: begin
            BorderIcons := [biSystemMenu,biMinimize,biMaximize];
            BorderStyle := bsSizeable;
        end;
        1: begin
            BorderIcons := [];
            BorderStyle := bsNone;
            WindowState := wsMaximized;
        end;
    end;
end;

procedure TXXXForm_MainTabbedTemplate.Action_ModuleNavigatorExecute(Sender: TObject);
begin
	TForm_ModulesThumbnails.Execute(Self)
end;

procedure TXXXForm_MainTabbedTemplate.Action_MySQLBackupAdRestoreExecute(Sender: TObject);
var
	XXXForm_MySQLBackupAndRestore: TXXXForm_MySQLBackupAndRestore;
    CreateParameters: TDialogCreateParameters;
begin
    XXXForm_MySQLBackupAndRestore := nil;
    ZeroMemory(@CreateParameters,SizeOf(TDialogCreateParameters));
    with CreateParameters do
    begin
		AutoFree := True;
        AutoShow := True;
        Modal := True;
        Configurations := FConfigurations;
        MyDataModuleClass := nil;
        MyDataModule := Self.MyDataModule.DataModuleMain;
        DataModuleMain := Self.MyDataModule.DataModuleMain;
    end;
    TXXXForm_DialogTemplate.CreateDialog(Self
                                        ,XXXForm_MySQLBackupAndRestore
                                        ,TXXXForm_MySQLBackupAndRestore
                                        ,CreateParameters);
end;

procedure TXXXForm_MainTabbedTemplate.Action_NextModuleExecute(Sender: TObject);
begin
	PageControl_Main.SelectNextPage(True);
end;

procedure TXXXForm_MainTabbedTemplate.Action_PreviousModuleExecute(Sender: TObject);
begin
	PageControl_Main.SelectNextPage(False);
end;

procedure TXXXForm_MainTabbedTemplate.AdjustModuleSpecificActions;
begin
	Action_NextModule.Enabled := False;
  	Action_PreviousModule.Enabled := False;

  	if PageControl_Main.PageCount > 0 then
    begin
        StatusBar_Main.Panels[0].Text := 'Módulo nº ' + IntToStr(Succ(PageControl_Main.ActivePageIndex)) + ' (' + IntToStr(PageControl_Main.PageCount) + ' em execução)';
    	Action_NextModule.Enabled := PageControl_Main.ActivePageIndex < Pred(PageControl_Main.PageCount);
		Action_PreviousModule.Enabled := PageControl_Main.ActivePageIndex > 0;
  	end
    else
    	StatusBar_Main.Panels[0].Text := 'Nenhum módulo em execução';

    Action_ModuleNavigator.Enabled := PageControl_Main.PageCount > 1;
    Action_CloseAllModules.Enabled := PageControl_Main.PageCount > 0;
    PageControl_Main.Visible := PageControl_Main.PageCount > 0;
end;

procedure TXXXForm_MainTabbedTemplate.DoShowHint(Sender: TObject);
begin
	StatusBar_Main.Panels[1].Text := Application.Hint;
end;

procedure TXXXForm_MainTabbedTemplate.DoCloseQuery(Sender: TObject; var CanClose: Boolean);
begin
    { TODO -oCarlos Feitoza -cCOMPLEMENTO : Coloque a pergunta de fechamento aqui }
    if MyDataModule.AddEntitiesForm <> nil then
    	MyDataModule.AddEntitiesForm.Close;
end;

{ TTabSheet }

constructor TTabSheet.Create(AOwner: TComponent; aNotifyTabsChangedEventHandler: TNotifyEvent);
begin
  	inherited Create(AOwner);

    FOnAfterDestroy := aNotifyTabsChangedEventHandler;
end;

destructor TTabSheet.Destroy;
begin
  	inherited;
    if Assigned(FOnAfterDestroy) then
    	FOnAfterDestroy(Self);
end;

{ TPageControl }

function TPageControl.GetActivePage: ComCtrls.TTabSheet;
begin
	Result := inherited ActivePage;
end;

procedure TPageControl.SetActivePage(Page: ComCtrls.TTabSheet);
begin
	inherited ActivePage := Page;
    if Assigned(FOnActivatePage) then
		FOnActivatePage(Page);
end;

{ TProgressBar }

procedure TProgressBar.Hide;
begin
    SetTimer(Handle,IDT_DELAYED_HIDE_PROGRESSBAR,1000,Classes.MakeObjectInstance(DoDelayedHide));
end;

procedure TProgressBar.DoDelayedHide(var Msg: TMessage);
begin
    inherited Hide;
    KillTimer(Handle,TWMTimer(Msg).TimerID);
end;

end.
