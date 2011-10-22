unit ZTO.Wizards.FormTemplates.CustomForm;

interface

uses Forms
   , Classes
   , Controls
   , ZTO.Win32.Rtl.Common.Classes;

type
//  TZTOCustomFormClass = class of TCustomForm;
//  TZTOCustomFormClass = class of TForm;
//tem de herdar de customform, mas tem de aparecer em screen.activeform
//tem de criar um hack pra poder mudar FActiveForm
//veja forms.Screen e form.customform e sobrescreva o metodo adequado
  TZTOCustomForm = class(TCustomForm)
//  TZTOCustomForm = class(TForm)
  private
    FZTOFormProperties: TZTOCustomFormProperties;
    FShowMode: TShowMode;
//    function GetAutoSize: Boolean;
//    function GetAnchors: TAnchors;
//    function GetBorderWidth: Integer;
  protected
    property ZTOProperties: TZTOCustomFormProperties read FZTOFormProperties write FZTOFormProperties;
    property ShowMode: TShowMode read FShowMode write FShowMode;
  public
    constructor Create(aOwner: TComponent); override;
    destructor Destroy; override;
    function SetFocusedControl(Control: TWinControl): Boolean; override;
  published
//    property Anchors: TAnchors read GetAnchors;
//    property AutoSize: Boolean read GetAutoSize;
//    property BorderWidth: Integer read GetBorderWidth;
  end;

  TZTOCustomFormClass = class of TZTOCustomForm;

implementation

{ TZTOCustomForm }

type
  PForm = ^TForm;

constructor TZTOCustomForm.Create(aOwner: TComponent);
begin
  inherited;

end;

destructor TZTOCustomForm.Destroy;
begin

  inherited;
end;

function TZTOCustomForm.SetFocusedControl(Control: TWinControl): Boolean;
var
  FormAtivo: PForm;
begin
  Result := inherited {$IFDEF VER180}SetFocusedControl(Control){$ENDIF};
  FormAtivo := PForm(Integer(@Screen.ActiveForm));
  FormAtivo^ := TForm(Self);
//  Label1.Caption := Screen.ActiveForm.Caption;
//  SetActiveForm(TForm(Self));
//  TMyScreen(Screen).FActiveForm := TForm(Self);
//  TMyScreen(Screen).FForms.Remove(Self);
//  TMyScreen(Screen).FForms.Insert(0, TForm(Self));
end;

//function TZTOCustomForm.GetAnchors: TAnchors;
//begin
//  Result := inherited Anchors;
//end;

//function TZTOCustomForm.GetAutoSize: Boolean;
//begin
//  Result := inherited AutoSize;
//end;

//function TZTOCustomForm.GetBorderWidth: Integer;
//begin
//  Result := inherited BorderWidth;
//end;

end.
