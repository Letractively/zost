unit UBDITypesConstantsAndClasses;

interface

uses
    UXXXTypesConstantsAndClasses, Classes;

type
    TBDIConfigurations = class(TXXXConfigurations)
    private
        FIntervaloDeChecagemGeral: Word;

        FEmailsParaObrasOciosas: TStringList;
        FIntervaloDeChecagemDeOciosas: Word;
        FDiasDeOciosidade: Byte;
        
        FEmailsParaObrasGanhas: TStringList;
        FEmailsParaObrasPerdidas: TStringList;

        FEmailsParaObrasLimitrofes: TStringList;
        FIntervaloDeChecagemDeLimitrofes: Word;
        FDiasParaAviso: Byte;

        { Configurações SMTP }
        FSMTPPrio: Word;        // TSmtpPriority
        FSMTPConf: Boolean;     // Confirmação de recebimento
        FSMTPCoTy: Word;        // TSmtpContentType
        FSMTPSeMo: Word;        // Send Mode
        FSMTPShMo: Word;        // Share Mode
        FSMTPWrMT: Boolean;     // Wrap Message Text
        FSMTPUsNa: ShortString; // Username
        FSMTPUsPa: ShortString; // Password
        FSMTPHost: ShortString; // HostAddress
        FSMTPFrom: ShortString; // MailFrom
        FSMTPSign: ShortString; // Signature
        FSMTPAuth: Word;        // TSmtpAuthType
        FSMTPA8bC: Boolean;     // Allow 8bit characters
        FSMTPChSe: ShortString; // Charset
        FSMTPDeEn: Word;        // Default Encoding

        { Configurações HTTP }
        FHTTPPort: Word;
    public
        constructor Create(aOwner: TComponent); override;
        destructor Destroy; override;
        procedure SalvarConfiguracoes;
    published
        property IntervaloDeChecagemGeral: Word read FIntervaloDeChecagemGeral write FIntervaloDeChecagemGeral;
        
        property EmailsParaObrasOciosas: TStringList read FEmailsParaObrasOciosas write FEmailsParaObrasOciosas;
        property IntervaloDeChecagemDeOciosas: Word read FIntervaloDeChecagemDeOciosas write FIntervaloDeChecagemDeOciosas;
        property DiasDeOciosidade: Byte read FDiasDeOciosidade write FDiasDeOciosidade;
        
        property EmailsParaObrasGanhas: TStringList read FEmailsParaObrasGanhas write FEmailsParaObrasGanhas;
        property EmailsParaObrasPerdidas: TStringList read FEmailsParaObrasPerdidas write FEmailsParaObrasPerdidas;

        property EmailsParaObrasLimitrofes: TStringList read FEmailsParaObrasLimitrofes write FEmailsParaObrasLimitrofes;
        property IntervaloDeChecagemDeLimitrofes: Word read FIntervaloDeChecagemDeLimitrofes write FIntervaloDeChecagemDeLimitrofes;
        property DiasParaAviso: Byte read FDiasParaAviso write FDiasParaAviso;

        property SMTPPrio: Word read FSMTPPrio write FSMTPPrio;
        property SMTPConf: Boolean read FSMTPConf write FSMTPConf;
        property SMTPCoTy: Word read FSMTPCoTy write FSMTPCoTy;
        property SMTPSeMo: Word read FSMTPSeMo write FSMTPSeMo;
        property SMTPShMo: Word read FSMTPShMo write FSMTPShMo;
        property SMTPWrMT: Boolean read FSMTPWrMT write FSMTPWrMT;
        property SMTPUsNa: ShortString read FSMTPUsNa write FSMTPUsNa;
        property SMTPUsPa: ShortString read FSMTPUsPa write FSMTPUsPa;
        property SMTPHost: ShortString read FSMTPHost write FSMTPHost;
        property SMTPFrom: ShortString read FSMTPFrom write FSMTPFrom;
        property SMTPSign: ShortString read FSMTPSign write FSMTPSign;
        property SMTPAuth: Word read FSMTPAuth write FSMTPAuth;
        property SMTPA8bC: Boolean read FSMTPA8bC write FSMTPA8bC;
        property SMTPChSe: ShortString read FSMTPChSe write FSMTPChSe;
        property SMTPDeEn: Word read FSMTPDeEn write FSMTPDeEn;

        property HTTPPort: Word read FHTTPPort write FHTTPPort;
    end;

implementation

const
    CONFIG_FILENAME = '\CONFIG.DAT';

    DEFAULT_INTERVALOD_DE_CHECAGEM_GERAL = 5; { MINUTOS }

    DEFAULT_EMAILS_PARA_OBRAS_OCIOSAS = 'carlos.b.feitoza.filho@gmail.com,a.seravat@gmail.com';
    DEFAULT_INTERVALO_DE_CHECAGEM_DE_OCIOSAS = 15; { DIAS }
    DEFAULT_DIAS_DE_OCIOSIDADE = 30;  { DIAS }

    DEFAULT_EMAILS_PARA_OBRAS_GANHAS = 'carlos.b.feitoza.filho@gmail.com,a.seravat@gmail.com';
    DEFAULT_EMAILS_PARA_OBRAS_PERDIDAS = 'carlos.b.feitoza.filho@gmail.com,a.seravat@gmail.com';

    DEFAULT_EMAILS_PARA_OBRAS_LIMITROFES = 'carlos.b.feitoza.filho@gmail.com,a.seravat@gmail.com';
    DEFAULT_INTERVALO_DE_CHECAGEM_DE_LIMITROFES = 5; { DIAS }
    DEFAULT_DIAS_PARA_AVISO = 30; { DIAS }

    DEFAULT_SMTP_PRIO = 3;
    DEFAULT_SMTP_CONF = FALSE;
    DEFAULT_SMTP_COTY = 0;
    DEFAULT_SMTP_SEMO = 0;
    DEFAULT_SMTP_SHMO = 2;
    DEFAULT_SMTP_WRMT = FALSE;
    DEFAULT_SMTP_USNA = 'bdi00001';
    DEFAULT_SMTP_USPA = 'wsc@BDI';
    DEFAULT_SMTP_HOST = '10.0.2.5';
    DEFAULT_SMTP_FROM = 'bancoinformacao@hitachiapb.com.br';
    DEFAULT_SMTP_SIGN = 'Banco De Informacoes';
    DEFAULT_SMTP_AUTH = 2;
    DEFAULT_SMTP_A8BC = TRUE;
    DEFAULT_SMTP_CHSE = 'iso-8859-1';
    DEFAULT_SMTP_DEEN = 0;

    DEFAULT_HTTP_PORT = 80;
    
{ TBDIConfigurations }

constructor TBDIConfigurations.Create(aOwner: TComponent);
begin
    inherited;
    { Valores padrão customizados }
    FSMTPPrio := DEFAULT_SMTP_PRIO;
    FSMTPConf := DEFAULT_SMTP_CONF;
    FSMTPCoTy := DEFAULT_SMTP_COTY;
    FSMTPSeMo := DEFAULT_SMTP_SEMO;
    FSMTPShMo := DEFAULT_SMTP_SHMO;
    FSMTPWrMT := DEFAULT_SMTP_WRMT;
    FSMTPUsNa := DEFAULT_SMTP_USNA;
    FSMTPUsPa := DEFAULT_SMTP_USPA;
    FSMTPHost := DEFAULT_SMTP_HOST;
    FSMTPFrom := DEFAULT_SMTP_FROM;
    FSMTPSign := DEFAULT_SMTP_SIGN;
    FSMTPAuth := DEFAULT_SMTP_AUTH;
    FSMTPA8bC := DEFAULT_SMTP_A8BC;
    FSMTPChSe := DEFAULT_SMTP_CHSE;
    FSMTPDeEn := DEFAULT_SMTP_DEEN;

    FHTTPPort := DEFAULT_HTTP_PORT;

    FIntervaloDeChecagemGeral := DEFAULT_INTERVALOD_DE_CHECAGEM_GERAL;

    FEmailsParaObrasOciosas := TStringList.Create;
    FEmailsParaObrasOciosas.Sorted := True;
    FEmailsParaObrasOciosas.Duplicates := dupIgnore;
    FEmailsParaObrasOciosas.CommaText := DEFAULT_EMAILS_PARA_OBRAS_OCIOSAS;
    FIntervaloDeChecagemDeOciosas := DEFAULT_INTERVALO_DE_CHECAGEM_DE_OCIOSAS;
    FDiasDeOciosidade := DEFAULT_DIAS_DE_OCIOSIDADE;

    FEmailsParaObrasGanhas := TStringList.Create;
    FEmailsParaObrasGanhas.Sorted := True;
    FEmailsParaObrasGanhas.Duplicates := dupIgnore;
    FEmailsParaObrasGanhas.CommaText := DEFAULT_EMAILS_PARA_OBRAS_GANHAS;

    FEmailsParaObrasPerdidas := TStringList.Create;
    FEmailsParaObrasPerdidas.Sorted := True;
    FEmailsParaObrasPerdidas.Duplicates := dupIgnore;
    FEmailsParaObrasPerdidas.CommaText := DEFAULT_EMAILS_PARA_OBRAS_PERDIDAS;

    FEmailsParaObrasLimitrofes := TStringList.Create;
    FEmailsParaObrasLimitrofes.Sorted := True;
    FEmailsParaObrasLimitrofes.Duplicates := dupIgnore;
    FEmailsParaObrasLimitrofes.CommaText := DEFAULT_EMAILS_PARA_OBRAS_LIMITROFES;
    FIntervaloDeChecagemDeLimitrofes := DEFAULT_INTERVALO_DE_CHECAGEM_DE_LIMITROFES;
    FDiasParaAviso := DEFAULT_DIAS_PARA_AVISO;

    { Atribuição de propriedades padrão e criação de coisas aqui }
    LoadFromBinaryFile(CurrentDir + CONFIG_FILENAME);
end;

destructor TBDIConfigurations.Destroy;
begin
    SaveToBinaryFile(CurrentDir + CONFIG_FILENAME);
    { Destruição de coisas aqui }
    FEmailsParaObrasOciosas.Free;
    FEmailsParaObrasGanhas.Free;
    FEmailsParaObrasPerdidas.Free;
    FEmailsParaObrasLimitrofes.Free;
    inherited;
end;

procedure TBDIConfigurations.SalvarConfiguracoes;
begin
    SaveToBinaryFile(CurrentDir + CONFIG_FILENAME);
end;

end.
