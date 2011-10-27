unit ZTO.Win32.Rtl.Common.Classes;

{$WEAKPACKAGEUNIT ON}

interface

uses Classes
   , StdCtrls
   , Buttons
   , ExtCtrls
   , Graphics
   , SysUtils
   , Controls
   , XMLIntf
   , ZTO.Win32.Rtl.Sys.Types;

type
  TMyFormClassName = String;

  EInvalidParameter = class (Exception)
  private
    FRoutineName: ShortString;
    FParameterName: ShortString;
  public
    constructor CreateFmt(const aRoutineName  : ShortString;
                          const aParameterName: ShortString;
                          const aMsg          : String;
                          const aArgs         : array of const);

    constructor Create(const aRoutineName  : ShortString;
                       const aParameterName: ShortString;
                       const aMsg          : String);

    property RoutineName  : ShortString read FRoutineName;
    property ParameterName: ShortString read FParameterName;
  end;

  EInvalidArgumentData = class(Exception);

  { A função não lançou nenhuma exceção, mas internamente uma condição de erro
  foi verificada e por isso o retorno da função não é válido }
  EUnexpectedInformation = class(Exception);

  ENoPermission = class(Exception);

  { Main class Object File. All file structures must inherit it }
  { Cada subclasse na estrutura de arquivo deve ser derivada de }
  { TPersistent. TCollection e TCollectionItem, p.e., são       }
  TObjectFile = class(TComponent)
  private
    function ObjectBinaryToXML(Input: TStream): IXMLDocument;
  protected
  public
    procedure LoadFromBinaryFile(const aFileName: TFileName);
    procedure LoadFromTextualRepresentation(const aTextualRepresentation: String);
    procedure SaveToBinaryFile(const aFileName: TFileName);
    { TODO : Criar um metodo publico "SaveBinary" e "SaveText" que usa um campo
    interno do objeto com o nome de arquivo para salvar usando savetobinaryfile.
    O campo é preenchido após usar um método Load qualqer e só é limpo com outro
    método chamado close, que limpa o objeto e limpa a variavel }
    function ToString: String; {$IFNDEF VER180}override;{$ENDIF}
    function ToXML: String;
  end;

  TZTOCustomFormProperties = class (TPersistent)
  private
    FFocusControlOnEdit: TWinControl;
    FFocusControlOnInsert: TWinControl;
    { Alguns destes campos não serão published. mANTENHA PUBLISHED APENAS
    AQUELES CAMPOS QUE MUDAM PARA CADA FORM CRIADO OS DEMAIS CAMPOS PODEM
    SER PUBLIC }
//        FConfigurations: TXXXConfigurations; { nil }
//    FDataModuleClass: TZTODataModule_BasicClass; { nil }
//        FMyDataModule: TXXXDataModule; { nil }
//        FMyDataModuleDescription: ShortString; { '' }
//        FDataModuleMain: TXXXDataModule_Main; { nil }

//        OnFormCreate: TNotifyEvent; { nil }
//        OnFormDestroy: TNotifyEvent; { nil }
    property FocusControlOnEdit: TWinControl read FFocusControlOnEdit write FFocusControlOnEdit;
    property FocusControlOnInsert: TWinControl read FFocusControlOnInsert write FFocusControlOnInsert;
  protected
    procedure AssignTo(Dest: TPersistent); override;

  public
    constructor Create; virtual;
    destructor Destroy; override;

    procedure Assign(Source: TPersistent); override;

  published
  end;

  TZTOSDIFormProperties = class (TZTOCustomFormProperties)
  private
    { Alguns destes campos não serão published. mANTENHA PUBLISHED APENAS
    AQUELES CAMPOS QUE MUDAM PARA CADA FORM CRIADO OS DEMAIS CAMPOS PODEM
    SER PUBLIC }
//        FConfigurations: TXXXConfigurations; { nil }
//    FDataModuleClass: TZTODataModule_BasicClass; { nil }
//        FMyDataModule: TXXXDataModule; { nil }
//        FMyDataModuleDescription: ShortString; { '' }
//        FDataModuleMain: TXXXDataModule_Main; { nil }

//        OnFormCreate: TNotifyEvent; { nil }
//        OnFormDestroy: TNotifyEvent; { nil }
  protected
    procedure AssignTo(Dest: TPersistent); override;

  public
    constructor Create; reintroduce;
    destructor Destroy; override;

    procedure Assign(Source: TPersistent); override;

  published
//        property MyDataModuleDescription: ShortString read FMyDataModuleDescription write FMyDataModuleDescription;
    property FocusControlOnEdit;
    property FocusControlOnInsert;
  end;

  TVisibleButton = (vbOk,vbYes,vbYesToAll,vbNo,vbIgnore,vbCancel,vbClose,vbHelp);
  TVisibleButtons = set of TVisibleButton;

  TDisabledButton = (dbOk,dbYes,dbYesToAll,dbNo,dbIgnore,dbCancel,dbClose,dbHelp);
  TDisabledButtons = set of TDisabledButton;

  TSelectedButton = (sbNone,sbOk,sbYes,sbYesToAll,sbNo,sbIgnore,sbCancel,sbClose,sbHelp);

  TDialogType = (dtNone,dtInformation,dtError,dtWarning,dtQuestion);

  TShowMode = (smNone,smShow,smShowModal,smShowAutoFree,smShowModalAutoFree);

  TCreateMode = (cmNone,cmManualFree,cmAutoFree,cmAutoNil);

  TInfoPanel = class (TPersistent)
  private
    FPanel: TPanel;
    function GetVisible: Boolean;
    procedure SetVisible(const Value: Boolean);
    function GetColor: TColor;
    procedure SetColor(const Value: TColor);
    function GetFont: TFont;
    procedure SetFont(const Value: TFont);
  public
    constructor Create(aPanel: TPanel);
  published
    property Visible: Boolean read GetVisible write SetVisible default True;
    property Color: TColor read GetColor write SetColor default clActiveCaption;
    property Font: TFont read GetFont write SetFont;
  end;

  TButtonPanel = class (TPersistent)
  private
    FPanel: TPanel;
    function GetVisible: Boolean;
    procedure SetVisible(const Value: Boolean);
    function GetColor: TColor;
    procedure SetColor(const Value: TColor);
  public
    constructor Create(aPanel: TPanel);
  published
    property Visible: Boolean read GetVisible write SetVisible default True;
    property Color: TColor read GetColor write SetColor default clActiveCaption;
  end;

  TZTODialogProperties = class(TZTOCustomFormProperties)
  private
    FInfoPanel: TInfoPanel;
    FButtonPanel: TButtonPanel;
    FDialogDescription: TLabel; { '' }
    FVisibleButtons: TVisibleButtons;
    FDisabledButtons: TDisabledButtons;
    FSelectedButton: TSelectedButton;
    FDialogType: TDialogType;

    FImage_Dialog: TImage;
    FBitBtn_Ok: TBitBtn;
    FBitBtn_Yes: TBitBtn;
    FBitBtn_YesToAll: TBitBtn;
    FBitBtn_No: TBitBtn;
    FBitBtn_Ignore: TBitBtn;
    FBitBtn_Cancel: TBitBtn;
    FBitBtn_Close: TBitBtn;
    FBitBtn_Help: TBitBtn;
//    coloque aqui as propriedades de classe e de instancia
//    a de classe s´oé acessivel em tempo de execução (propriedade pubica)
//    a de instancia talvez possa ser acessivel published
//    declare no datamodule uma propriedade publicada que retorne self
//    e veja se a propriedade publicada na caixa de dialogo a enxerga

    procedure SetDialogDescription(const Value: String);
    function GetDialogDescription: String;
    procedure SetVisibleButtons(const Value: TVisibleButtons);
    procedure SetDisabledButtons(const Value: TDisabledButtons);
    procedure SetDialogType(const Value: TDialogType);
  protected
    procedure AssignTo(Dest: TPersistent); override;
  public
    constructor Create(aInfoPanel
                      ,aButtonPanel      : TPanel;
                       aImage_Dialog     : TImage;
                       aLabel_Description: TLabel;
                       aBitBtn_Ok
                      ,aBitBtn_Yes
                      ,aBitBtn_YesToAll
                      ,aBitBtn_No
                      ,aBitBtn_Ignore
                      ,aBitBtn_Cancel
                      ,aBitBtn_Close
                      ,aBitBtn_Help      : TBitBtn); reintroduce;

    destructor Destroy; override;

    procedure Assign(Source: TPersistent); override;

  published
    property DialogDescription: String read GetDialogDescription write SetDialogDescription;
    property VisibleButtons: TVisibleButtons read FVisibleButtons write SetVisibleButtons default [];
    property DisabledButtons: TDisabledButtons read FDisabledButtons write SetDisabledButtons default [];
    property SelectedButton: TSelectedButton read FSelectedButton write FSelectedButton default sbNone;
    property DialogType: TDialogType read FDialogType write SetDialogType default dtNone;
    property InfoPanel: TInfoPanel read FInfoPanel write FInfoPanel;
    property ButtonPanel: TButtonPanel read FButtonPanel write FButtonPanel;
    property FocusControlOnEdit;
    property FocusControlOnInsert;

//    property InfoPanelVisible: Boolean read GetInfoPanelVisible write SetInfoPanelVisible default True;
//    property ButtonPanelVisible: Boolean read GetButtonPanelVisible write SetButtonPanelVisible default True;
//    property DataModuleClass: TZTODataModuleClass;
  end;

  TZTODataModuleProperties = class(TZTOCustomFormProperties)
  private
    FOpenAllDataSets: Boolean;
    FDescription: ShortString;
  protected
    procedure AssignTo(Dest: TPersistent); override;
  public
    constructor Create; override;
    destructor Destroy; override;
    procedure Assign(Source: TPersistent); override;

  published
    property OpenAllDataSets: Boolean read FOpenAllDataSets write FOpenAllDataSets default False;
    property Description: ShortString read FDescription write FDescription;
  end;

  TWDP = (wdpAll,wdpDialogDecription,wdpVisibleButtons,wdpDisabledButtons,wdpSelectedButtons,wdpDialogType);
  TChangedWDP = set of TWDP;

  // Converte um procedure ou função para um método de um objeto, permitindo que
  // um procedure ou função não associado a um objeto possa ser usado como
  // manipulador de evento de um objeto qualquer. Pode ser necessário um
  // TypeCast no resultado desta função, por isso é uma boa idéia usar uma
  // função específica que chame esta função e já retorne o resultado com o
  // TypeCast aplicado 
  function ProcedureToMethod(aSelf       : TObject;
                             aProcAddress: Pointer): TMethod;

  // Converte um método de um objeto em um procedure ou função procedural. Este
  // é o oposto de "ProcedureToMethod". Isso funciona apenas para métodos com
  // convenção stdcall. A função de API que faz isso chama-se
  // MakeObjectInstance. ATENÇÃO: LIBERE O PONTEIRO DO PROCEDURE (FREEMEM)
  // QUANDO NÃO O QUISER MAIS EVITANDO ASSIM BURACOS NA MEMÓRIA
  function MethodToProcedure(aSelf         : TObject;
                             aMethodAddress: Pointer): Pointer; overload;
  function MethodToProcedure(aMethod: TMethod): Pointer; overload;

  procedure EnumClasses(Strings: TStrings);

resourcestring
  RS_INVALID_ARGUMENT_DATA = 'O parâmetro "%s" está correto quanto ao tipo, mas seus dados não são compatíveis com o método. %s';
  RS_INVALID_PARAMETER = 'Erro nos dados de um dos parâmetros do método %s.'#13#10#13#10'%s';
  RS_EXCEPTION = 'Erro desconhecido no método %s. É preciso uma depuração mais detalhada.'#13#10#13#10'%s';
  RS_ACCESS_VIOLATION = 'Houve um erro de violação de acesso no método %s.'#13#10#13#10'%s';
  RS_UNEXPECTED_INFORMATION = 'O método obteve internamente uma informação inesperada. %s';
  RS_ONLY_SELECT_ALLOWED = 'Apenas comandos SQL do tipo SELECT ou SHOW são aceitos';
//	RS_PAGECHANGENOTALLOWEDNOW = 'Não é possível alternar entre páginas enquanto a operação de inserção/edição atual não tiver sido concluída ou cancelada. Termine a operação atual ou cancele-a para poder mudar de página';
//	RS_ACTIONNOTALLOWEDNOW = 'Ação não permitida no momento';

implementation

uses Windows
   , RTLConsts
   , TypInfo
   , XMLDoc{, PngImage};

function MethodToProcedure(aSelf         : TObject;
                           aMethodAddress: Pointer): Pointer;
type
  TMethodToProc = packed record
    PopEax  : Byte;                // $58      pop EAX
    PushSelf: record               //          push self
                Opcode: Byte;      // $B8
                Self  : Pointer;   // self
              end;
    PushEax : byte;                // $50      push EAX
    Jump    : record               //          jmp [target]
                Opcode : Byte;     // $FF
                ModRm  : Byte;     // $25
                pTarget: ^Pointer; // @target
                Target : Pointer;  // @MethodAddr
              end;
  end;

var
  Mtp: ^TMethodToProc absolute Result;
begin
  New(Mtp);

  with Mtp^ do
  begin
    PopEax          := $58;
    PushSelf.Opcode := $68;
    PushSelf.Self   := aSelf;
    PushEax         := $50;
    Jump.Opcode     := $FF;
    Jump.ModRm      := $25;
    Jump.pTarget    := @Jump.Target;
    Jump.Target     := aMethodAddress;
  end;
end;

function MethodToProcedure(aMethod: TMethod): pointer;
begin
  Result := MethodToProcedure(TObject(aMethod.Data)
                             ,aMethod.Code);
end;

function ProcedureToMethod(aSelf       : TObject;
                           aProcAddress: Pointer): TMethod;
begin
  result.Data := aSelf;
  result.Code := aProcAddress;
end;

type
  TClassesEnum = class(TObject)
  private
    FStrings: TStrings;
    procedure GetClassesProc(AClass: TPersistentClass);
  public
    procedure EnumClasses(Strings: TStrings);
  end;

{ TClassesEnum }

procedure TClassesEnum.EnumClasses(Strings: TStrings);
begin
  if not Assigned(Strings) then
    Exit;

  Strings.Clear;

  FStrings := Strings;
  with TClassFinder.Create(nil, True) do
    try
      GetClasses(GetClassesProc);
    finally
      Free;
    end;
end;

procedure TClassesEnum.GetClassesProc(AClass: TPersistentClass);
begin
  FStrings.Add(AClass.ClassName);
end;

procedure EnumClasses(Strings: TStrings);
begin
  with TClassesEnum.Create do
    try
      EnumClasses(Strings);
    finally
      Free;
    end;
end;

{ TZTOSDIFormProperties }

procedure TZTOSDIFormProperties.Assign(Source: TPersistent);
begin
  if Source is TZTOSDIFormProperties then
  begin
    inherited;
//    FProp1 := TZTOSDIFormProperties(Source).Prop1;
//    FProp2 := TZTOSDIFormProperties(Source).Prop2;
//    FProp3 := TZTOSDIFormProperties(Source).Prop3;
  end
  else
    { Transferindo a responsabilidade para TZTOCustomFormProperties }
    inherited;
end;

procedure TZTOSDIFormProperties.AssignTo(Dest: TPersistent);
begin
  if Dest is TZTOSDIFormProperties then
  begin
    inherited;
//    TZTOSDIFormProperties(Dest).prop1 := FProp1;
//    TZTOSDIFormProperties(Dest).prop2 := FProp2;
//    TZTOSDIFormProperties(Dest).prop3 := FProp3;
  end
  else
    { Transferindo a responsabilidade para TZTOCustomFormProperties }
    inherited;
end;

constructor TZTOSDIFormProperties.Create;
begin
  inherited;
  
end;

destructor TZTOSDIFormProperties.Destroy;
begin

  inherited;
end;


{ TZTOFormProperties }

procedure TZTOCustomFormProperties.Assign(Source: TPersistent);
begin
  if Source is TZTOCustomFormProperties then
  begin
    { Propriedades que devem ser copiadas }
  end
  else
    { Ao chamar o método homonimo na classe pai estamos transferindo a esta
    última a responsabilidade de validar se é possível ou não realizar a cópia.
    Na maioria das vezes isso vai gerar uma exceção, que é o comportamento
    correto esperado. }
    inherited;
end;

procedure TZTOCustomFormProperties.AssignTo(Dest: TPersistent);
begin
  inherited;

end;

constructor TZTOCustomFormProperties.Create;
begin
  { Valores padrão das propriedades }
end;

destructor TZTOCustomFormProperties.Destroy;
begin

  inherited;
end;

{ TZTODialogProperties }

procedure TZTODialogProperties.Assign(Source: TPersistent);
begin
  if Source is TZTODialogProperties then
  begin
    inherited;
    FDialogDescription.Caption := TZTODialogProperties(Source).DialogDescription;
    FVisibleButtons            := TZTODialogProperties(Source).VisibleButtons;
    FSelectedButton            := TZTODialogProperties(Source).SelectedButton;
  end
  else
    { Transferindo a responsabilidade para TZTOFormProperties }
    inherited;
end;

procedure TZTODialogProperties.AssignTo(Dest: TPersistent);
begin
  if Dest is TZTODialogProperties then
  begin
    inherited;
    TZTODialogProperties(Dest).DialogDescription    := FDialogDescription.Caption;
    TZTODialogProperties(Dest).VisibleButtons       := FVisibleButtons;
    TZTODialogProperties(Dest).SelectedButton       := FSelectedButton;
  end
  else
    { Transferindo a responsabilidade para TZTOFormProperties }
    inherited;
end;


constructor TZTODialogProperties.Create(aInfoPanel
                                       ,aButtonPanel      : TPanel;
                                        aImage_Dialog     : TImage;
                                        aLabel_Description: TLabel;
                                        aBitBtn_Ok
                                       ,aBitBtn_Yes
                                       ,aBitBtn_YesToAll
                                       ,aBitBtn_No
                                       ,aBitBtn_Ignore
                                       ,aBitBtn_Cancel
                                       ,aBitBtn_Close
                                       ,aBitBtn_Help      : TBitBtn);

begin
  inherited Create;
  FInfoPanel := TInfoPanel.Create(aInfoPanel);
  FButtonPanel := TButtonPanel.Create(aButtonPanel);
  
  FDialogDescription := aLabel_Description;
  FDialogDescription.Caption := '';
  FVisibleButtons := [];
  FDisabledButtons := [];
  FSelectedButton := sbNone;
  FDialogType := dtNone;

  FImage_Dialog := aImage_Dialog;
  FBitBtn_Ok := aBitBtn_Ok;
  FBitBtn_Yes := aBitBtn_Yes;
  FBitBtn_YesToAll := aBitBtn_YesToAll;
  FBitBtn_No := aBitBtn_No;
  FBitBtn_Ignore := aBitBtn_Ignore;
  FBitBtn_Cancel := aBitBtn_Cancel;
  FBitBtn_Close := aBitBtn_Close;
  FBitBtn_Help := aBitBtn_Help;
end;

destructor TZTODialogProperties.Destroy;
begin
  FButtonPanel.Free;
  FInfoPanel.Free;
  inherited;
end;

function TZTODialogProperties.GetDialogDescription: String;
begin
  Result := FDialogDescription.Caption;
end;

procedure TZTODialogProperties.SetDialogDescription(const Value: String);
begin
  if FDialogDescription.Caption <> Value then
    FDialogDescription.Caption := Value;
end;

procedure TZTODialogProperties.SetDialogType(const Value: TDialogType);
var
  Icon: TIcon;
begin
  if (Value <> FDialogType) and (Value = dtNone) then //estava pequeno, tem de crescer
  begin
    FDialogDescription.Left := 4;
    FDialogDescription.Width := FDialogDescription.Width + 36;
  end
  else if (Value <> FDialogType) and (FDialogType = dtNone) then // estava grande, tem de diminuir
  begin
    FDialogDescription.Left := 4 + 32 + 4;
    FDialogDescription.Width := FDialogDescription.Width - 36;
  end;

  FDialogType := Value;

  Icon := TIcon.Create;
  try
    case FDialogType of
      dtInformation:
        Icon.LoadFromResourceName(hInstance, 'DIALOG_INFO');
      dtError:
        Icon.LoadFromResourceName(hInstance, 'DIALOG_ERROR');
      dtWarning:
        Icon.LoadFromResourceName(hInstance, 'DIALOG_WARNING');
      dtQuestion:
        Icon.LoadFromResourceName(hInstance, 'DIALOG_QUESTION');
    end;
  finally
    FImage_Dialog.Visible := (Icon.Width = 32) and (Icon.Height = 32);

    if FImage_Dialog.Visible then
      FImage_Dialog.Picture.Graphic := Icon;

    Icon.Free;
  end;

end;

procedure TZTODialogProperties.SetDisabledButtons(const Value: TDisabledButtons);
begin
  FDisabledButtons := Value;

  { Desabilitando apenas os necessários... }
  FBitBtn_Ok.Enabled       := not (dbOk       in FDisabledButtons);
  FBitBtn_Yes.Enabled      := not (dbYes      in FDisabledButtons);
  FBitBtn_YesToAll.Enabled := not (dbYesToAll in FDisabledButtons);
  FBitBtn_No.Enabled       := not (dbNo       in FDisabledButtons);
  FBitBtn_Ignore.Enabled   := not (dbIgnore   in FDisabledButtons);
  FBitBtn_Cancel.Enabled   := not (dbCancel   in FDisabledButtons);
  FBitBtn_Close.Enabled    := not (dbClose    in FDisabledButtons);
  FBitBtn_Help.Enabled     := not (dbHelp     in FDisabledButtons);
end;

procedure TZTODialogProperties.SetVisibleButtons(const Value: TVisibleButtons);
var
  TotalWidth: SmallInt;
begin
  FVisibleButtons := Value;

  { Exibindo apenas os necessários... }
  FBitBtn_Ok.Visible       := vbOk       in FVisibleButtons;
  FBitBtn_Yes.Visible      := vbYes      in FVisibleButtons;
  FBitBtn_YesToAll.Visible := vbYesToAll in FVisibleButtons;
  FBitBtn_No.Visible       := vbNo       in FVisibleButtons;
  FBitBtn_Ignore.Visible   := vbIgnore   in FVisibleButtons;
  FBitBtn_Cancel.Visible   := vbCancel   in FVisibleButtons;
  FBitBtn_Close.Visible    := vbClose    in FVisibleButtons;
  FBitBtn_Help.Visible     := vbHelp     in FVisibleButtons;

  TotalWidth := 0;

  { Configurando... }
  if FBitBtn_Help.Visible then
  begin
    FBitBtn_Help.Left := FBitBtn_Help.Parent.Width  - 4 - FBitBtn_Help.Width;
    Inc(TotalWidth,FBitBtn_Help.Width + 6);
  end;

  if FBitBtn_Close.Visible then
  begin
    FBitBtn_Close.Left := FBitBtn_Close.Parent.Width - 4 - FBitBtn_Close.Width - TotalWidth;
    Inc(TotalWidth,FBitBtn_Close.Width + 6);
  end;

  if FBitBtn_Cancel.Visible then
  begin
    FBitBtn_Cancel.Left := FBitBtn_Cancel.Parent.Width - 4 - FBitBtn_Cancel.Width - TotalWidth;
    Inc(TotalWidth,FBitBtn_Cancel.Width + 6);
  end;

  if FBitBtn_Ignore.Visible then
  begin
    FBitBtn_Ignore.Left := FBitBtn_Ignore.Parent.Width - 4 - FBitBtn_Ignore.Width - TotalWidth;
    Inc(TotalWidth,FBitBtn_Ignore.Width + 6);
  end;

  if FBitBtn_No.Visible then
  begin
    FBitBtn_No.Left := FBitBtn_No.Parent.Width - 4 - FBitBtn_No.Width - TotalWidth;
    Inc(TotalWidth,FBitBtn_No.Width + 6);
  end;

  if FBitBtn_YesToAll.Visible then
  begin
    FBitBtn_YesToAll.Left := FBitBtn_YesToAll.Parent.Width - 4 - FBitBtn_YesToAll.Width - TotalWidth;
    Inc(TotalWidth,FBitBtn_YesToAll.Width + 6);
  end;

  if FBitBtn_Yes.Visible then
  begin
    FBitBtn_Yes.Left := FBitBtn_Yes.Parent.Width - 4 - FBitBtn_Yes.Width - TotalWidth;
    Inc(TotalWidth,FBitBtn_Yes.Width + 6);
  end;

  if FBitBtn_Ok.Visible then
  begin
    FBitBtn_Ok.Left := FBitBtn_Ok.Parent.Width - 4 - FBitBtn_Ok.Width - TotalWidth;
//    Inc(TotalWidth,FBitBtn_Ok.Width + 6);
  end;
end;

{ TZTODataModuleProperties }

procedure TZTODataModuleProperties.Assign(Source: TPersistent);
begin
  if Source is TZTODataModuleProperties then
  begin
    inherited;
    FOpenAllDataSets := TZTODataModuleProperties(Source).OpenAllDataSets;
    FDescription     := TZTODataModuleProperties(Source).Description;
  end
  else
    { Transferindo a responsabilidade para o progenitor }
    inherited;
end;

procedure TZTODataModuleProperties.AssignTo(Dest: TPersistent);
begin
  if Dest is TZTODataModuleProperties then
  begin
    inherited;
    TZTODataModuleProperties(Dest).OpenAllDataSets := FOpenAllDataSets;
    TZTODataModuleProperties(Dest).Description     := FDescription;
  end
  else
    { Transferindo a responsabilidade para o progenitor }
    inherited;
end;

constructor TZTODataModuleProperties.Create;
begin
  inherited;
  FOpenAllDataSets := False;
  FDescription := '';
end;

destructor TZTODataModuleProperties.Destroy;
begin

  inherited;
end;

{ TInfoPanel }

constructor TInfoPanel.Create(aPanel: TPanel);
begin
  FPanel := aPanel;
  FPanel.Visible := True;
  FPanel.Color := clActiveCaption;
  FPanel.Font.Color := clCaptionText;
  FPanel.Font.Size := 8;
  FPanel.Font.Style := [];
end;

function TInfoPanel.GetColor: TColor;
begin
  Result := FPanel.Color;
end;

function TInfoPanel.GetFont: TFont;
begin
  Result := FPanel.Font;
end;

function TInfoPanel.GetVisible: Boolean;
begin
  Result := FPanel.Visible;
end;

procedure TInfoPanel.SetColor(const Value: TColor);
begin
  FPanel.Color := Value;
end;

procedure TInfoPanel.SetFont(const Value: TFont);
begin
  FPanel.Font := Value;
end;

procedure TInfoPanel.SetVisible(const Value: Boolean);
begin
  FPanel.Visible := Value;
end;

{ TButtonPanel }

constructor TButtonPanel.Create(aPanel: TPanel);
begin
  FPanel := aPanel;
  FPanel.Visible := True;
  FPanel.Color := clActiveCaption;
end;

function TButtonPanel.GetColor: TColor;
begin
  Result := FPanel.Color;
end;

function TButtonPanel.GetVisible: Boolean;
begin
  Result := FPanel.Visible;
end;

procedure TButtonPanel.SetColor(const Value: TColor);
begin
  FPanel.Color := Value;
end;

procedure TButtonPanel.SetVisible(const Value: Boolean);
begin
  FPanel.Visible := Value;
end;

{ TObjectFile }

function TObjectFile.ObjectBinaryToXML(Input: TStream): IXMLDocument;
var
	Reader: TReader;
  	ObjectName, PropName: string; //for error reporting

  	procedure ConvertProperty(const Parent: IXMLNode); forward;

  	procedure ConvertValue(Current: IXMLNode; Independence: Boolean);
    	function ConvertBinary: string;
    	const
      		BytesPerLine = 32;
    	var
      		I: Integer;
      		Count: Longint;
      		Buffer: array[0..BytesPerLine - 1] of Char;
      		Text: array[0..BytesPerLine * 2 - 1] of Char;
      		Temp: string;
    	begin
      		Reader.ReadValue;
      		Reader.Read(Count, SizeOf(Count));
            Result := '';
            while Count > 0 do
            begin
	            if Count > BytesPerLine then
                	I := BytesPerLine
                else
                	I := Count;
                Reader.Read(Buffer, I);
                BinToHex(Buffer, Text, I);
                SetString(Temp, Text, I * 2);
                Result := Result + Temp;
                Dec(Count, I);
                if Count > 0 then
                    Result := Result + SLineBreak;
        	end;
    	end;

    	function ConvertSet: string;
    	var
      		S: string;
    	begin
      		Reader.ReadValue;
      		Result := '';
      		while True do
      		begin
                S := Reader.ReadStr;
                if S = '' then
                	Break;
                if Result <> '' then
                	Result := Result + ', ';
                Result := Result + S;
            end;
        end;

        procedure ConvertDate;
        var
        	D: TDateTime;
        begin
            D := Reader.ReadDate;
            Current.Attributes['value'] := FloatToStr(D);
            Current.Attributes['date'] := DateTimeToStr(D);
	    end;

        procedure ConvertCollection;
        var
	        Item: IXMLNode;
        begin
            Reader.ReadValue;
            while not Reader.EndOfList do
            begin
	            Item := Current.AddChild('item');
    	        if Reader.NextValue in [vaInt8, vaInt16, vaInt32] then
		            Item.Attributes['id'] := Reader.ReadInteger;
        	    Reader.CheckValue(vaList);
            	while not Reader.EndOfList do
                	ConvertProperty(Item);
	            Reader.ReadListEnd;
            end;
            Reader.ReadListEnd;
        end;

        procedure SetType(const s: string);
        begin
	        if Independence then
    	    begin
        		if s <> '' then
			        Current := Current.AddChild(s)
		        else
        			Current := Current.AddChild('ident')
		    end
        	else if s <> '' then
		        Current.Attributes['type'] := s;
        end;

  	begin
    	case Reader.NextValue of
  	  		vaList: begin
      			SetType('list');
                Reader.ReadValue;
                while not Reader.EndOfList do
                    ConvertValue(Current, True);
                Reader.ReadListEnd;
            end;
            vaInt8, vaInt16, vaInt32: begin
                SetType('integer');
                Current.Attributes['value'] := IntToStr(Reader.ReadInteger);
            end;
            vaInt64: begin
                SetType('integer');
                Current.Attributes['value'] := IntToStr(Reader.ReadInt64);
            end;
            vaExtended: begin
                SetType('real');
                Current.Attributes['value'] := FloatToStr(Reader.ReadFloat);
            end;
            vaSingle: begin
                SetType('real');
                Current.Attributes['precision'] := 'single';
                Current.Attributes['value'] := FloatToStr(Reader.ReadFloat);
            end;
            vaCurrency: begin
                SetType('real');
                Current.Attributes['precision'] := 'currency';
                Current.Attributes['value'] := CurrToStr(Reader.ReadCurrency);
            end;
            vaDate: begin
                SetType('real');
                Current.Attributes['precision'] := 'date';
                ConvertDate;
            end;
            vaWString, vaUTF8String: begin
                SetType('string');
                Current.Attributes['value'] := Reader.ReadWideString;
            end;
            vaString, vaLString: begin
                SetType('string');
                Current.Attributes['charset'] := 'locale';
                Current.Attributes['value'] := Reader.ReadString;
            end;
            vaIdent, vaFalse, vaTrue, vaNil, vaNull: begin
                SetType('');
                Current.Attributes['value'] := Reader.ReadIdent;
            end;
            vaBinary: begin
                SetType('binary');
                Current.Text := ConvertBinary
            end;
            vaSet: begin
                SetType('set');
                Current.Attributes['value'] := ConvertSet;
            end;
            vaCollection: begin
                SetType('collection');
                ConvertCollection;
            end;
    		else
      			raise EReadError.CreateFmt(sPropertyException, [ObjectName, DotSep, PropName, IntToStr(Ord(Reader.NextValue))]);
        end;
    end;

	procedure ConvertProperty(const Parent: IXMLNode);
  	var
    	Current: IXMLNode;
  	begin
    	PropName := Reader.ReadStr;
    	Current := Parent.AddChild(PropName);
    	ConvertValue(Current, False);
  	end;

  	procedure ConvertObject(const Parent: IXMLNode);
  	var
    	Current: IXMLNode;
    	ClassName: string;
    	Flags: TFilerFlags;
    	Position: Integer;
  	begin
    	Current := Parent.AddChild('object');

        Reader.ReadPrefix(Flags, Position);
        ClassName := Reader.ReadStr;
        ObjectName := Reader.ReadStr;

    	if ObjectName <> '' then
      		Current.Attributes['name'] := ObjectName;

    	Current.Attributes['class'] := ClassName;

    	if ffInherited in Flags then
      		Current.Attributes['kind'] := 'inherited'
    	else if ffInline in Flags then
     	 	Current.Attributes['kind'] := 'inline';

    	if ffChildPos in Flags then
      		Current.Attributes['position'] := IntToStr(Position);

    	while not Reader.EndOfList do
        	ConvertProperty(Current);

        Reader.ReadListEnd;
    	while not Reader.EndOfList do
    		ConvertObject(Current);
    	Reader.ReadListEnd;
  	end;

var
  SaveSeparator: Char;
begin
  Reader := TReader.Create(Input, 4096);

  SaveSeparator := {$IFDEF VER220}FormatSettings.{$ENDIF}DecimalSeparator;
  {$IFDEF VER220}FormatSettings.{$ENDIF}DecimalSeparator := '.';
  try
    Result := NewXMLDocument;
    Result.Encoding := 'UTF-8';
    Reader.ReadSignature;
    //   	ConvertObject(Result.AddChild('dfm'));
    ConvertObject(Result.AddChild('ObjectFile'));
  finally
    {$IFDEF VER220}FormatSettings.{$ENDIF}DecimalSeparator := SaveSeparator;
    Reader.Free;
  end;
end;

{$HINTS OFF}
procedure TObjectFile.LoadFromBinaryFile(const aFileName: TFileName);
begin
	if FileExists(aFileName) then
	  Self := TObjectFile(ReadComponentResFile(aFileName, Self));
end;{$HINTS ON}

procedure TObjectFile.SaveToBinaryFile(const aFileName: TFileName);
begin
	WriteComponentResFile(aFileName,Self);
end;

{$HINTS OFF}
procedure TObjectFile.LoadFromTextualRepresentation(const aTextualRepresentation: String);
var
	BinStream: TMemoryStream;
  StrStream: TStringStream;
begin
  StrStream := TStringStream.Create(aTextualRepresentation);
  try
    BinStream := TMemoryStream.Create;
    try
      Strstream.Seek(0, sofrombeginning);
      ObjectTextToBinary(strStream,binStream);
      BinStream.Seek(0, soFromBeginning);
      Self := BinStream.ReadComponent(Self) as TObjectFile;
    finally
      BinStream.Free
    end;
  finally
    StrStream.Free;
  end;
end;{$HINTS ON}

function TObjectFile.ToString: String;
var
  BinStream: TMemoryStream;
  StrStream: TStringStream;
  s: string;
begin
  inherited;
  BinStream := TMemoryStream.Create;
  try
    StrStream := TStringStream.Create(s);
      try
        BinStream.WriteComponent(Self);
        BinStream.Seek(0, soFromBeginning);
        ObjectBinaryToText(BinStream, StrStream);
        StrStream.Seek(0, soFromBeginning);
        Result:= StrStream.DataString;
      finally
        StrStream.Free;
      end;
  finally
	  BinStream.Free
  end;
end;

function TObjectFile.ToXML: String;
var
  BinStream: TMemoryStream;
  XML: IXMLDocument;
begin
  BinStream := TMemoryStream.Create;
  try
    BinStream.WriteComponent(Self);
    BinStream.Seek(0, soFromBeginning);
    XML := ObjectBinaryToXML(BinStream);
    Result:= XML.XML.Text;
  finally
	  BinStream.Free
  end;
end;

{ EInvalidParameter }

constructor EInvalidParameter.Create(const aRoutineName  : ShortString;
                                     const aParameterName: ShortString;
                                     const aMsg          : String);
begin
    inherited Create(aMsg);
    FRoutineName   := aRoutineName;
    FParameterName := aParameterName;
end;

constructor EInvalidParameter.CreateFmt(const aRoutineName  : ShortString;
                                        const aParameterName: ShortString;
                                        const aMsg          : String;
                                        const aArgs         : array of const);
begin
    inherited CreateFmt(aMsg,aArgs);
    FRoutineName   := aRoutineName;
    FParameterName := aParameterName;
end;

end.
