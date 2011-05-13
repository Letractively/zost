unit _StdCtrls;

interface

uses
	StdCtrls, Classes, Forms;

type
	///<author>Carlos Feitoza Filho</author>
  ///    Esta classe mediadora introduz um comportamento padrão no método
  ///    "KeyDown" de qualquer TEdit criado abaixo desta unit
	TEdit = class (StdCtrls.TEdit)
	protected
    procedure KeyDown(var Key: Word; Shift: TShiftState); override;
  end;

	///<author>Carlos Feitoza Filho</author>
  ///    Esta classe mediadora introduz um comportamento padrão no método
  ///    "KeyDown" de qualquer TComboBox criado abaixo desta unit
  TComboBox = class (StdCtrls.TComboBox)
  protected
    procedure KeyDown(var Key: Word; Shift: TShiftState); override;
  end;

procedure EnterIsTab(const aFormOwner: TForm; const aKey: Word; const aClassName: AnsiString);

implementation

uses
  Windows, UXXXForm_ModuleTabbedTemplate, UXXXForm_DialogTemplate;

procedure EnterIsTab(const aFormOwner: TForm; const aKey: Word; const aClassName: AnsiString);
var
	TI: TagInput;
begin
  if (aFormOwner is TXXXForm_ModuleTabbedTemplate) and not TXXXForm_ModuleTabbedTemplate(aFormOwner).Configurations.ConvertEnterToTabFor[aClassName]  then
    Exit
  else if (aFormOwner is TXXXForm_DialogTemplate) and not TXXXForm_DialogTemplate(aFormOwner).CreateParameters.Configurations.ConvertEnterToTabFor[aClassName] then
    Exit;

  ZeroMemory(@TI,SizeOf(TagInput));
  TI.Itype := INPUT_KEYBOARD;
  TI.ki.wVk := VK_TAB;

  if aKey = VK_RETURN then
    SendInput(1,TI,SizeOf(TagInput));
end;

{ TEdit }

procedure TEdit.KeyDown(var Key: Word; Shift: TShiftState);
begin
  inherited;
  EnterIsTab(TForm(Owner),Key,AnsiString(ClassName));
end;


{ TComboBox }

procedure TComboBox.KeyDown(var Key: Word; Shift: TShiftState);
begin
  inherited;
  EnterIsTab(TForm(Owner),Key,AnsiString(ClassName));
end;

end.
