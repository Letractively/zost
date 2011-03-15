unit UBDIForm_Main;

interface

uses
    Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
    Dialogs, UXXXForm_MainDialogTemplate, ActnList, ExtCtrls, StdCtrls, ComCtrls,
    Buttons;

type
    TBDIForm_Main = class(TXXXForm_MainDialogTemplate)
        PageControl_Principal: TPageControl;
        TabSheet_EmailsAutomaticos: TTabSheet;
        PageControl_EmailsAutomaticos: TPageControl;
        TabSheet_ObrasOciosas: TTabSheet;
        TabSheet_ObrasGanhas: TTabSheet;
        TabSheet_ObrasPerdidas: TTabSheet;
        TabSheet_ObrasExpirando: TTabSheet;
        TabSheet_Configuracoes: TTabSheet;
        PageControl_TiposDeConfiguracao: TPageControl;
        TabSheet_ConfiguracoesSMTP: TTabSheet;
        Label_ConfiguracoesSMTP: TLabel;
        Bevel_Linha2: TBevel;
        Label_Priority: TLabel;
        Label_ContentType: TLabel;
        Label_SendMode: TLabel;
        Label_ShareMode: TLabel;
        ComboBox_Priority: TComboBox;
        ComboBox_ContentType: TComboBox;
        ComboBox_SendMode: TComboBox;
        CheckBox_Confirm: TCheckBox;
        CheckBox_WrapMessageText: TCheckBox;
        ComboBox_ShareMode: TComboBox;
        BitBtn_MinimizarNoTray: TBitBtn;
        Action_MinimizarNoTray: TAction;
        Action_RestaurarDoTray: TAction;
        TabSheet_ConfiguracoesEmailsAutomaticos: TTabSheet;
        PageControl_ObrasOciosas: TPageControl;
        TabSheet_ObrasOciosasEmails: TTabSheet;
        TabSheet_ObrasOciosasConfiguracoes: TTabSheet;
        PageControl_ObrasGanhas: TPageControl;
        TabSheet_ObrasGanhasEmails: TTabSheet;
        PageControl_ObrasPerdidas: TPageControl;
        TabSheet_ObrasPerdidasEmails: TTabSheet;
        PageControl_ObrasExpirando: TPageControl;
        TabSheet_ObrasExpirandoEmails: TTabSheet;
        TabSheet_ObrasExpirandoConfiguracoes: TTabSheet;
        Label_ConfiguracoesGerais: TLabel;
        Bevel_ConfiguracoesGerais: TBevel;
        TabSheet_ConfiguracoesBD: TTabSheet;
        Memo_ObrasOciosas: TMemo;
        Panel_ObrasOciosas: TPanel;
        Panel_ObrasGanhas: TPanel;
        Memo_ObrasGanhas: TMemo;
        Panel_ObrasPerdidas: TPanel;
        Memo_ObrasPerdidas: TMemo;
        Panel_ObrasLimitrofes: TPanel;
        Memo_ObrasLimitrofes: TMemo;
        Label_BancoDeDados: TLabel;
        Bevel_BancoDeDados: TBevel;
        LabeledEdit_IntervaloDeChecagemGeral: TLabeledEdit;
        UpDown_IntervaloDeChecagemGeral: TUpDown;
        Action_FecharAplicacao: TAction;
        Label_IntervaloDeChecagemGeral: TLabel;
        LabeledEdit_ObrasOciosasIntervalo: TLabeledEdit;
        UpDown_ObrasOciosasIntervalo: TUpDown;
        LabeledEdit_ObrasLimitrofes: TLabeledEdit;
        UpDown_ObrasLimitrofesIntervalo: TUpDown;
        Label_ObrasLimitrofes: TLabel;
        LabeledEdit_ObrasOciosasDias: TLabeledEdit;
        UpDown_ObrasOciosasDias: TUpDown;
        Label_ObrasOciosasIntervalo: TLabel;
        Label_ObrasOciosasDias: TLabel;
        LabeledEdit_ObrasLimitrofesDias: TLabeledEdit;
        Label_ObrasLimitrofesDias: TLabel;
        UpDown_ObrasLimitrofesDias: TUpDown;
        ComboBoxProtocolo: TComboBox;
        LabelProtocolo: TLabel;
        LabelIsolationLevel: TLabel;
        ComboBoxIsolationLevel: TComboBox;
        EditEnderecoDoHost: TLabeledEdit;
        EditPorta: TLabeledEdit;
        EditBancoDeDados: TLabeledEdit;
        EditNomeDeUsuario: TLabeledEdit;
        EditSenha: TLabeledEdit;
        TabSheet_ServicoDeInformacoes: TTabSheet;
        LabeledEdit_SMTPLogin: TLabeledEdit;
        LabeledEdit_SMTPSenha: TLabeledEdit;
        Action_SalvarConfiguracoes: TAction;
        BitBtn_SalvarConfiguracoes: TBitBtn;
        LabeledEdit_SMTPHost: TLabeledEdit;
        TabSheet_ConfiguracoesHTTP: TTabSheet;
        Label_ConfiguracoesHTTP: TLabel;
        Bevel_ConfiguracoesHTTP: TBevel;
        LabeledEdit_SMTPFrom: TLabeledEdit;
        LabeledEdit_SMTPAssinatura: TLabeledEdit;
        LabeledEdit_SMTPCharSet: TLabeledEdit;
        Label_SMTPDefaultEncoding: TLabel;
        ComboBox_SMTPDefaultEncoding: TComboBox;
        CheckBox_SMTPAllow8bitChars: TCheckBox;
        Label_SMTPAutenticacao: TLabel;
        ComboBox_SMTPAutenticacao: TComboBox;
        LabeledEdit_PortaHTTP: TLabeledEdit;
        Label_HTTPDocumentRoot: TLabel;
        Label_HTTPTemplateDir: TLabel;
        Action_HTTPAtivarDesativar: TAction;
        BitBtn_SMTPAtivarDesativar: TBitBtn;
        BitBtn_HTTPAtivarDesativar: TBitBtn;
        TabSheet_InformacoesGerais: TTabSheet;
        Label_HTTPDocumentoPadrao: TLabel;
        Label_DocumentRootValor: TLabel;
        Label_HTTPTemplateDirValor: TLabel;
        Label_HTTPDocumentoPadraoValor: TLabel;
        Shape_HTTPDocumentRoot: TShape;
        Shape_HTTPTemplatesDir: TShape;
        Shape_HTTPDefaultDocument: TShape;
        Action_SMTPAtivarDesativar: TAction;
        GroupBox_SMTP: TGroupBox;
        GroupBox_HTTP: TGroupBox;
        ProgressBar_EmailsParaObrasOciosas: TProgressBar;
        Label_EmailParaObrasOciosas: TLabel;
        Label_EmailsParaObrasOciosasValor: TLabel;
        Label_EmailsParaObrasOciosasProximoEnvio: TLabel;
        Label_EmailParaObrasGanhas: TLabel;
        Label_EmailsParaObrasPerdidas: TLabel;
        Label_EmailsParaObrasLimitrofes: TLabel;
        ProgressBar_EmailsParaObrasPerdidas: TProgressBar;
        Label_EmailsParaObrasPerdidasValor: TLabel;
        Label_EmailsParaObrasPerdidasProximoEnvio: TLabel;
        Bevel_LinhaVertical1: TBevel;
        Label_EmailsParaObrasGanhasProximoEnvio: TLabel;
        ProgressBar_EmailsParaObrasGanhas: TProgressBar;
        Label_EmailsParaObrasGanhasValor: TLabel;
        Label_EmailsParaObrasLimitrofesProximoEnvio: TLabel;
        ProgressBar_EmailsParaObrasLimitrofes: TProgressBar;
        Label_EmailsParaObrasLimitrofesValor: TLabel;
        Panel_EmailsAutomaticos: TPanel;
        RichEdit_HTTPLog: TRichEdit;
        Panel_Status: TPanel;
        TabSheet_ObrasGanhasDefinicoes: TTabSheet;
        TabSheet_ObrasPerdidasDefinicoes: TTabSheet;
        Button_ObrasPerdidasLimparRegistros: TButton;
        Button_ObrasGanhasLimparRegistros: TButton;
        Action_ObrasPerdidasLimparRegistros: TAction;
        Action_ObrasGanhasLimparRegistros: TAction;
        procedure Action_MinimizarNoTrayExecute(Sender: TObject);
        procedure Action_RestaurarDoTrayExecute(Sender: TObject);
        procedure FormCreate(Sender: TObject);
        procedure DoGuardarConfiguracoes(Sender: TObject);
        procedure Action_FecharAplicacaoExecute(Sender: TObject);
        procedure DoCloseQuery(Sender: TObject; var CanClose: Boolean);
        procedure Action_SalvarConfiguracoesExecute(Sender: TObject);
        procedure DoKeyPresss(Sender: TObject; var Key: Char);
        procedure Action_HTTPAtivarDesativarExecute(Sender: TObject);
        procedure Action_SMTPAtivarDesativarExecute(Sender: TObject);
        procedure Action_ObrasPerdidasLimparRegistrosExecute(Sender: TObject);
        procedure Action_ObrasGanhasLimparRegistrosExecute(Sender: TObject);
    private
        { Private declarations }
    public
        { Public declarations }
    end;

implementation

uses
    UBDIDataModule_Main;

{$R *.dfm}

procedure TBDIForm_Main.Action_FecharAplicacaoExecute(Sender: TObject);
begin
    inherited;
    Close;
end;

procedure TBDIForm_Main.Action_HTTPAtivarDesativarExecute(Sender: TObject);
begin
    inherited;
    TBDIDataModule_Main(CreateParameters.MyDataModule).AtivarDesativarServidorHTTP;
end;

procedure TBDIForm_Main.Action_MinimizarNoTrayExecute(Sender: TObject);
begin
    inherited;
    TBDIDataModule_Main(CreateParameters.MyDataModule).MinimizarNoTray;
end;

procedure TBDIForm_Main.Action_ObrasGanhasLimparRegistrosExecute(Sender: TObject);
begin
    inherited;
    TBDIDataModule_Main(CreateParameters.MyDataModule).LimparRegistros('GANHA');
end;

procedure TBDIForm_Main.Action_ObrasPerdidasLimparRegistrosExecute(Sender: TObject);
begin
    inherited;
    TBDIDataModule_Main(CreateParameters.MyDataModule).LimparRegistros('PERDIDA');
end;

procedure TBDIForm_Main.Action_RestaurarDoTrayExecute(Sender: TObject);
begin
    inherited;
    TBDIDataModule_Main(CreateParameters.MyDataModule).RestaurarDoTray;
end;

procedure TBDIForm_Main.Action_SalvarConfiguracoesExecute(Sender: TObject);
begin
    inherited;
    TBDIDataModule_Main(CreateParameters.MyDataModule).SalvarArquivoDeConfiguracoes;
end;

procedure TBDIForm_Main.Action_SMTPAtivarDesativarExecute(Sender: TObject);
begin
    inherited;
    TBDIDataModule_Main(CreateParameters.MyDataModule).AtivarDesativarEnvioSMTP;
end;

procedure TBDIForm_Main.DoCloseQuery(Sender: TObject; var CanClose: Boolean);
begin
    inherited;
    CanClose := Application.MessageBox('O Banco De Informações provê geração de estatísticas e envio destas por e-mails além de fornecer outras informações por demanda (pergunta/resposta) dentro da rede Hitachi. Se você fechar este programa nenhum destes serviços ficará disponível','Tem certeza?',MB_ICONQUESTION or MB_YESNO or MB_DEFBUTTON2) = IDYES;
end;

procedure TBDIForm_Main.DoGuardarConfiguracoes(Sender: TObject);
begin
    inherited;
    TBDIDataModule_Main(CreateParameters.MyDataModule).GuardarConfiguracoes;
end;

procedure TBDIForm_Main.DoKeyPresss(Sender: TObject; var Key: Char);
begin
    inherited;
    if not (Key in ['0'..'9',#8]) then
        Key := #0;
end;

procedure TBDIForm_Main.FormCreate(Sender: TObject);
begin
    inherited;
    TBDIDataModule_Main(CreateParameters.MyDataModule).ObterConfiguracoes;
    Panel_EmailsAutomaticos.Top := 14;
end;

end.
