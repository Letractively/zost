unit UBDOForm_GeradorDeRelatorio;

interface

uses
    Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
    Dialogs, UXXXForm_DialogTemplate, ActnList, ExtCtrls, StdCtrls, CheckLst,
    ComCtrls, Buttons, OleCtrls, {$IFDEF IE}SHDocVw{$ELSE}MOZILLACONTROLLib_TLB{$ENDIF};

type
    TBDOForm_GeradorDeRelatorio = class(TXXXForm_DialogTemplate)
        GroupBox_VisualizarImpressao: TGroupBox;
        PageControl_OpcoesEFiltragem: TPageControl;
        TabSheet_OpcoesDeListagem: TTabSheet;
        TabSheet_OpcoesDeFiltragem: TTabSheet;
        GroupBox_PoweredBy: TGroupBox;
        Image_Firefox: TImage;
        Image_IE: TImage;
        TabSheet_OpcoesDeExibicao: TTabSheet;
        Action_Salvar: TAction;
        Action_Regerar: TAction;
        Action_Configurar: TAction;
        Action_Imprimir: TAction;
        ProgressBar_GeracaoDeRelatorio: TProgressBar;
        SpeedButton_SalvarPrevisualizacao: TBitBtn;
        SpeedButton_Recarregar: TBitBtn;
        SpeedButton_ImprimirAgora: TBitBtn;
        SpeedButton_Configurar: TBitBtn;
        procedure Action_RegerarExecute(Sender: TObject);
        procedure Action_ConfigurarExecute(Sender: TObject);
        procedure Action_ImprimirExecute(Sender: TObject);
        procedure Action_SalvarExecute(Sender: TObject);
        procedure FormShow(Sender: TObject);
    private
        { Private declarations }
        FHTMLViewer: {$IFDEF IE}TWebBrowser{$ELSE}TMozillaBrowser{$ENDIF};
        FInitialGeneration: Boolean;
        procedure DelayedFormShow(const aDelay: Byte = 1);
    protected
        procedure DoBeforeNavigate2(      ASender: TObject;
                                    const pDisp: IDispatch;
                                      var URL
                                        , Flags
                                        , TargetFrameName
                                        , PostData
                                        , Headers: OleVariant;
                                      var Cancel: WordBool); virtual;
        procedure DoDelayedFormShow(var Msg: TMessage);
        procedure DoDelayedHideProgressBar(var Msg: TMessage);
        property InitialGeneration: Boolean write FInitialGeneration;
    public
        { Public declarations }
        property HTMLViewer: {$IFDEF IE}TWebBrowser{$ELSE}TMozillaBrowser{$ENDIF} read FHTMLViewer;
        procedure DelayedHideProgressBar(const aDelay: Byte = 1);

        constructor Create(const aOwner: TComponent; var aReference; const aCreateParameters: TDialogCreateParameters); override;
        destructor Destroy; override;
    end;

implementation

uses
    UBDODataModule_GeradorDeRelatorio, ActiveX;

const
    IDT_DELAYED_FORM_SHOW = 1;
    IDT_DELAYED_HIDE_PROGRESSBAR = 2;

{$R *.dfm}

procedure TBDOForm_GeradorDeRelatorio.Action_ConfigurarExecute(Sender: TObject);
begin
    inherited;
    TBDODataModule_GeradorDeRelatorio(CreateParameters.MyDataModule).ConfigurarPagina;
end;

procedure TBDOForm_GeradorDeRelatorio.Action_ImprimirExecute(Sender: TObject);
begin
    inherited;
    TBDODataModule_GeradorDeRelatorio(CreateParameters.MyDataModule).Imprimir;
end;

procedure TBDOForm_GeradorDeRelatorio.Action_RegerarExecute(Sender: TObject);
begin
    inherited;
    TBDODataModule_GeradorDeRelatorio(CreateParameters.MyDataModule).GerarRelatorio;
end;

procedure TBDOForm_GeradorDeRelatorio.Action_SalvarExecute(Sender: TObject);
begin
    inherited;
    TBDODataModule_GeradorDeRelatorio(CreateParameters.MyDataModule).SalvarComo;
end;

constructor TBDOForm_GeradorDeRelatorio.Create(const aOwner: TComponent; var aReference; const aCreateParameters: TDialogCreateParameters);
begin
    inherited;
    FHTMLViewer := {$IFDEF IE}TWebBrowser{$ELSE}TMozillaBrowser{$ENDIF}.Create(Self);
    TWinControl(FHTMLViewer).Parent := Self;
    FHTMLViewer.OnBeforeNavigate2 := DoBeforeNavigate2;
    FHTMLViewer.Top := 166;
    FHTMLViewer.Left := 6;
    FInitialGeneration := False;
end;

procedure TBDOForm_GeradorDeRelatorio.DelayedFormShow(const aDelay: Byte = 1);
begin
    SetTimer(Handle,IDT_DELAYED_FORM_SHOW,aDelay * 1000,Classes.MakeObjectInstance(DoDelayedFormShow));
end;

procedure TBDOForm_GeradorDeRelatorio.DelayedHideProgressBar(const aDelay: Byte = 1);
begin
    SetTimer(Handle,IDT_DELAYED_HIDE_PROGRESSBAR,aDelay * 1000,Classes.MakeObjectInstance(DoDelayedHideProgressBar));
end;

procedure TBDOForm_GeradorDeRelatorio.DoDelayedFormShow(var Msg: TMessage);
begin
    Action_Regerar.Execute;
    KillTimer(Handle,TWMTimer(Msg).TimerID);
end;

procedure TBDOForm_GeradorDeRelatorio.DoDelayedHideProgressBar(var Msg: TMessage);
begin
    ProgressBar_GeracaoDeRelatorio.Hide;
    KillTimer(Handle,TWMTimer(Msg).TimerID);
end;

destructor TBDOForm_GeradorDeRelatorio.Destroy;
begin
    FHTMLViewer.Free;
    inherited;
end;

procedure TBDOForm_GeradorDeRelatorio.DoBeforeNavigate2(      ASender: TObject;
                                                        const pDisp: IDispatch;
                                                          var URL
                                                            , Flags
                                                            , TargetFrameName
                                                            , PostData
                                                            , Headers: OleVariant;
                                                          var Cancel: WordBool);
begin
    { Nada aqui! }
end;

procedure TBDOForm_GeradorDeRelatorio.FormShow(Sender: TObject);
begin
    inherited;
    FHTMLViewer.Width := ClientWidth - FHTMLViewer.Left - 6;
    FHTMLViewer.Height := ClientHeight - FHTMLViewer.Top - Bevel_Footer.Height - 6;
    {$IFDEF IE}
    Image_IE.Show;
    Image_Firefox.Hide;
    {$ELSE}
    Image_IE.Hide;
    Image_Firefox.Show;
    {$ENDIF}

    if FInitialGeneration then
        DelayedFormShow
    else
        TBDODataModule_GeradorDeRelatorio(CreateParameters.MyDataModule).InitializeHTML;
end;

initialization
    OleInitialize(nil);

finalization
    OleUninitialize;


end.
