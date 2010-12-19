unit ZTO.Components.DataControls.LabeledDBEdit;

interface

uses DBCtrls
   , ExtCtrls
   , Controls
   , Classes
   , Messages;

type
  { Hack para acessar membros protegifos }
  TBoundLabel = class(ExtCtrls.TBoundLabel);

  TContentType = (ctGeneral, ctInteger, ctFloat, ctDate, ctTime, ctDateTime, ctCustom);

  TYearSize = (ys2, ys4);

  TCustomZTOLabeledDBEdit = class;
  
  TContentTypeOptions = class(TPersistent)
  private
    FParent: TCustomZTOLabeledDBEdit;
    FDecimalPlaces: Byte;
    FDigitGroups: Boolean;
    procedure SetDigitGroups(const Value: Boolean);
    procedure SetDecimalPlaces(const Value: Byte);
  public
    constructor Create(aParent: TCustomZTOLabeledDBEdit);
  published
    property DecimalPlaces: Byte read FDecimalPlaces write SetDecimalPlaces default 2;
    property DigitGroups: Boolean read FDigitGroups write SetDigitGroups default True;
  end;
  
  { TCustomLabeledDBEdit }
  TCustomZTOLabeledDBEdit = class(TDBEdit)
  private
    FEditLabel: TBoundLabel;
    FLabelPosition: TLabelPosition;
    FLabelSpacing: Integer;
    FContentType: TContentType;
    FContentTypeOptions: TContentTypeOptions;
    FContentTypeScript: TStrings;
    
    procedure SetLabelPosition(const Value: TLabelPosition);
    procedure SetLabelSpacing(const Value: Integer);
    procedure ApplyMask;
    procedure SetContentType(const Value: TContentType);
    procedure SetContentTypeScript(const Value: TStrings);
    function StoreContentTypeScript: Boolean;
  protected
    procedure SetParent(AParent: TWinControl); override;
    procedure Notification(AComponent: TComponent; Operation: TOperation); override;
    procedure SetName(const Value: TComponentName); override;
    procedure CMVisiblechanged(var Message: TMessage); message CM_VISIBLECHANGED;
    procedure CMEnabledchanged(var Message: TMessage); message CM_ENABLEDCHANGED;
    procedure CMBidimodechanged(var Message: TMessage); message CM_BIDIMODECHANGED;
    procedure Change; override;
    procedure AdjustsNeeded;

    property ContentType: TContentType read FContentType write SetContentType default ctGeneral;
    property ContentTypeOptions: TContentTypeOptions read FContentTypeOptions write FContentTypeOptions;
    property ContentTypeScript: TStrings read FContentTypeScript write SetContentTypeScript stored StoreContentTypeScript;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;

    procedure SetBounds(ALeft: Integer; ATop: Integer; AWidth: Integer; AHeight: Integer); override;
    procedure SetupInternalLabel;
    property EditLabel: TBoundLabel read FEditLabel;

    property LabelPosition: TLabelPosition read FLabelPosition write SetLabelPosition default lpAbove;
    property LabelSpacing: Integer read FLabelSpacing write SetLabelSpacing default 3;
  end;

  { TLabeledEdit }

  TZTOLabeledDBEdit = class(TCustomZTOLabeledDBEdit)
  published
    property EditLabel;
    property LabelPosition;
    property LabelSpacing;
    property ContentType;
    property ContentTypeOptions;
    property ContentTypeScript;
  end;

implementation

uses Types
   , SysUtils
   , StrUtils
   , Windows
   , ZTO.RegExp.PerlRegEx, DB;

const
  DATE_REGEX     = '\Dª'#13#10 +
                   '(\d{2})(\d)º$1/$2'#13#10 +
                   '(\d{2}/\d{2})(\d)º$1/$2';        

  TIME_REGEX     = '\Dª'#13#10 +
                   '(\d{2})(\d)º$1:$2'#13#10 +
                   '(\d{2}:\d{2})(\d)º$1:$2';

  DATETIME_REGEX = '\Dª'#13#10 +
                   '(\d{2})(\d)º$1/$2'#13#10 +
                   '(\d{2}/\d{2})(\d)º$1/$2'#13#10 +
                   '(\d{2}/\d{2}/\d{4})(\d)º$1 $2'#13#10 +
                   '(\d{2}/\d{2}/\d{4}\s\d{2})(\d)º$1:$2'#13#10 +
                   '(\d{2}/\d{2}/\d{4}\s\d{2}:\d{2})(\d)º$1:$2';

  INTEGER_REGEX  = '\Dª'#13#10 +
                   '(\d)(\d{3})$º$1.$2'#13#10 +
                   '(\d)(\d{3}\.)º$1.$2'#13#10 +
                   '(\d)(\d{3}\.)º$1.$2'#13#10 +
                   '(\d)(\d{3}\.)º$1.$2'#13#10 +
                   '(\d)(\d{3}\.)º$1.$2'#13#10 +
                   '(\d)(\d{3}\.)º$1.$2';

  FLOAT_REGEX1   = '\Dª'#13#10 + {000.000.000,00}
                   '(\d)(\d{%d})$º$1,$2'#13#10 +
                   '(\d)(\d{3},)º$1.$2'#13#10 +
                   '(\d)(\d{3}\.)º$1.$2'#13#10 +
                   '(\d)(\d{3}\.)º$1.$2'#13#10 +
                   '(\d)(\d{3}\.)º$1.$2'#13#10 +
                   '(\d)(\d{3}\.)º$1.$2'#13#10 +
                   '(\d)(\d{3}\.)º$1.$2';

  FLOAT_REGEX2   = '\Dª'#13#10 + {000000000,00}
                   '(\d)(\d{%d})$º$1,$2';

{ TCustomLabeledDBEdit }

procedure TCustomZTOLabeledDBEdit.Change;
begin
  if not (FContentType = ctGeneral) then
    ApplyMask;

  inherited;
end;

procedure TCustomZTOLabeledDBEdit.AdjustsNeeded;
begin
  inherited;
  SetContentType(FContentType);
end;

procedure TCustomZTOLabeledDBEdit.CMBidimodechanged(var Message: TMessage);
begin
  inherited;
  if FEditLabel <> nil then
    FEditLabel.BiDiMode := BiDiMode;
end;

procedure TCustomZTOLabeledDBEdit.CMEnabledchanged(var Message: TMessage);
begin
  inherited;
  if FEditLabel <> nil then
    FEditLabel.Enabled := Enabled;
end;

procedure TCustomZTOLabeledDBEdit.CMVisiblechanged(var Message: TMessage);
begin
  inherited;
  if FEditLabel <> nil then
    FEditLabel.Visible := Visible;
end;

constructor TCustomZTOLabeledDBEdit.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);

  FContentType   := ctGeneral;
  FLabelPosition := lpAbove;
  FLabelSpacing  := 3;

  SetupInternalLabel;

  FContentTypeOptions := TContentTypeOptions.Create(Self);
  FContentTypeScript  := TStringList.Create;
end;

destructor TCustomZTOLabeledDBEdit.Destroy;
begin
  FContentTypeScript.Free;
  FContentTypeOptions.Free;

  inherited;
end;

procedure TCustomZTOLabeledDBEdit.Notification(AComponent: TComponent;  Operation: TOperation);
begin
  inherited Notification(AComponent, Operation);

  if (AComponent = FEditLabel) and (Operation = opRemove) then
    FEditLabel := nil;
end;

procedure TCustomZTOLabeledDBEdit.SetBounds(ALeft, ATop, AWidth, AHeight: Integer);
begin
  inherited SetBounds(ALeft, ATop, AWidth, AHeight);

  SetLabelPosition(FLabelPosition);
end;

(*
Set a flag or overlay multiple values: flags := flags or flagbitN
Unset a flag                         : flags := flags and not flagbitN
Check if a bit is set                : (flags and flagbitN) = flagbitN
Invert a pattern of bits 	           : not flags
*)

procedure TCustomZTOLabeledDBEdit.SetContentType(const Value: TContentType);
begin
  FContentType := Value;

  { Remove todos os atributos do componente }
  SetWindowLong(Handle, GWL_STYLE, GetWindowLong(Handle, GWL_STYLE) and not ES_NUMBER);

  case FContentType of
    ctCustom: { Não precisa fazer nada };
    ctGeneral: begin
      FContentTypeScript.Text := '';
      MaxLength := 0;
      ApplyMask;
    end;
    ctInteger: begin
      SetWindowLong(Handle, GWL_STYLE, GetWindowLong(Handle, GWL_STYLE) or ES_NUMBER);

      if FContentTypeOptions.DigitGroups then
      begin
        FContentTypeScript.Text := INTEGER_REGEX;
        MaxLength := 27;
      end
      else
      begin
        FContentTypeScript.Text := '\Dª';
        MaxLength := 0;
      end;

      ApplyMask;
    end;
    ctFloat: begin
      SetWindowLong(Handle, GWL_STYLE, GetWindowLong(Handle, GWL_STYLE) or ES_NUMBER);


      if FContentTypeOptions.DigitGroups then
      begin
        FContentTypeScript.Text := Format(FLOAT_REGEX1,[FContentTypeOptions.DecimalPlaces]);
        MaxLength := 28 + FContentTypeOptions.DecimalPlaces
      end
      else
      begin
        FContentTypeScript.Text := Format(FLOAT_REGEX2,[FContentTypeOptions.DecimalPlaces]);
        MaxLength := 0;
      end;

      ApplyMask;
    end;
    ctDate: begin
      SetWindowLong(Handle, GWL_STYLE, GetWindowLong(Handle, GWL_STYLE) or ES_NUMBER);
      FContentTypeScript.Text := DATE_REGEX;
      MaxLength := 10;
      ApplyMask;
    end;
    ctTime: begin
      SetWindowLong(Handle, GWL_STYLE, GetWindowLong(Handle, GWL_STYLE) or ES_NUMBER);
      FContentTypeScript.Text := TIME_REGEX;
      MaxLength := 8;
      ApplyMask;
    end;
    ctDateTime: begin
      SetWindowLong(Handle, GWL_STYLE, GetWindowLong(Handle, GWL_STYLE) or ES_NUMBER);
      FContentTypeScript.Text := DATETIME_REGEX;
      MaxLength := 19;
      ApplyMask;
    end;
  end;
end;

procedure TCustomZTOLabeledDBEdit.SetContentTypeScript(const Value: TStrings);
begin
  if FContentType = ctCustom then
  begin
    FContentTypeScript.Assign(Value);
    ApplyMask;
  end
  else
    raise Exception.Create('Não é possível alterar o script quando o ContentType não é ctCustom. Suas alterações foram descartadas.');
end;

{ Deve armazenar o valor de ContentTypeScript apenas quando o tipo de conteúdo
for ctCustom. Em qualquer outra situação o Script não será salvo, mas sim
recriado }
function TCustomZTOLabeledDBEdit.StoreContentTypeScript: Boolean;
begin
  Result := FContentType = ctCustom;
end;

procedure TCustomZTOLabeledDBEdit.SetLabelPosition(const Value: TLabelPosition);
var
  P: TPoint;
begin
  if FEditLabel = nil then
    exit;

  FLabelPosition := Value;

  case Value of
    lpAbove: P := Point(Left, Top - FEditLabel.Height - FLabelSpacing);
    lpBelow: P := Point(Left, Top + Height + FLabelSpacing);
    lpLeft : P := Point(Left - FEditLabel.Width - FLabelSpacing, Top + ((Height - FEditLabel.Height) div 2));
    lpRight: P := Point(Left + Width + FLabelSpacing, Top + ((Height - FEditLabel.Height) div 2));
  end;

  FEditLabel.SetBounds(P.x, P.y, FEditLabel.Width, FEditLabel.Height);
end;

procedure TCustomZTOLabeledDBEdit.SetLabelSpacing(const Value: Integer);
begin
  FLabelSpacing := Value;
  SetLabelPosition(FLabelPosition);
end;

procedure TCustomZTOLabeledDBEdit.SetName(const Value: TComponentName);
var
  LClearText: Boolean;
begin
  if (csDesigning in ComponentState) and (FEditLabel <> nil) and ((FEditlabel.GetTextLen = 0) or (CompareText(FEditLabel.Caption, Name) = 0)) then
    FEditLabel.Caption := Value;

  LClearText := (csDesigning in ComponentState) and (Text = '');

  inherited SetName(Value);

  if LClearText then
    Text := '';
end;

procedure TCustomZTOLabeledDBEdit.SetParent(AParent: TWinControl);
begin
  inherited SetParent(AParent);

  if FEditLabel = nil then
    exit;

  FEditLabel.Parent := AParent;
  FEditLabel.Visible := True;
end;

procedure TCustomZTOLabeledDBEdit.SetupInternalLabel;
begin
  if Assigned(FEditLabel) then
    exit;

  FEditLabel := TBoundLabel.Create(Self);
  FEditLabel.FreeNotification(Self);
  FEditLabel.FocusControl := Self;
end;

{$WARNINGS OFF}
procedure TCustomZTOLabeledDBEdit.ApplyMask;
begin
  if FContentTypeScript.Count > 0 then
    with TPerlRegEx.Create(Self) do
      try
        Subject := Text;

        ScriptReplace(FContentTypeScript);

        Text := Subject;

        SelStart := Length(Text);
      finally
        Free;
      end;
end;
{$WARNINGS ON}

{ TContentTypeOptions }

constructor TContentTypeOptions.Create(aParent: TCustomZTOLabeledDBEdit);
begin
  inherited Create;
  FParent := aParent;
  FDecimalPlaces := 2;
  FDigitGroups := True;
end;

procedure TContentTypeOptions.SetDecimalPlaces(const Value: Byte);
begin
  FDecimalPlaces := Value;
  FParent.AdjustsNeeded;
end;

procedure TContentTypeOptions.SetDigitGroups(const Value: Boolean);
begin
  FDigitGroups := Value;
  FParent.AdjustsNeeded;
end;

(*
function cpf(v){
    v=v.replace(/\D/g,"");                   //Remove tudo o que não é dígito
    v=v.replace(/(\d{3})(\d)/,"$1.$2");      //Coloca um ponto entre o terceiro e o quarto dígitos
    v=v.replace(/(\d{3})(\d)/,"$1.$2");       //Coloca um ponto entre o terceiro e o quarto dígitos
                                             //de novo (para o segundo bloco de números)
    v=v.replace(/(\d{3})(\d{1,2})$/,"$1-$2"); //Coloca um hífen entre o terceiro e o quarto dígitos
    return v;
}

function cnpj(v){
    v=v.replace(/\D/g,"");                           //Remove tudo o que não é dígito
    v=v.replace(/^(\d{2})(\d)/,"$1.$2");            //Coloca ponto entre o segundo e o terceiro dígitos
    v=v.replace(/^(\d{2})\.(\d{3})(\d)/,"$1.$2.$3"); //Coloca ponto entre o quinto e o sexto dígitos
    v=v.replace(/\.(\d{3})(\d)/,".$1/$2");           //Coloca uma barra entre o oitavo e o nono dígitos
    v=v.replace(/(\d{4})(\d)/,"$1-$2");              //Coloca um hífen depois do bloco de quatro dígitos
    return v;
}


*)

end.
