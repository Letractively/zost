unit _DBCtrls;

interface

uses
	DBCtrls, Classes;

type
	///<author>Carlos Feitoza Filho</author>
    ///    Esta classe mediadora introduz um comportamento padrão no método
    ///    "KeyDown" de qualquer TDBEdit criado abaixo desta unit
	TDBEdit = class(DBCtrls.TDBEdit)
        procedure KeyDown(var Key: Word; Shift: TShiftState); override;
    end;

	///<author>Carlos Feitoza Filho</author>
    ///    Esta classe mediadora introduz um comportamento padrão no método
    ///    "KeyDown" de qualquer TDBComboBox criado abaixo desta unit
	TDBComboBox = class(DBCtrls.TDBComboBox)
        procedure KeyDown(var Key: Word; Shift: TShiftState); override;
    end;

	///<author>Carlos Feitoza Filho</author>
    ///    Esta classe mediadora introduz um comportamento padrão no método
    ///    "KeyDown" de qualquer TDBComboBox criado abaixo desta unit
	TDBLookupComboBox = class(DBCtrls.TDBLookupComboBox)
        procedure KeyDown(var Key: Word; Shift: TShiftState); override;
    end;

implementation

uses
  	Windows, Forms,

    _StdCtrls;

{ TDBEdit }

procedure TDBEdit.KeyDown(var Key: Word; Shift: TShiftState);
begin
  inherited;
  EnterIsTab(TForm(Owner),Key,AnsiString(ClassName));
end;

{ TDBComboBox }

procedure TDBComboBox.KeyDown(var Key: Word; Shift: TShiftState);
begin
    inherited;
    EnterIsTab(TForm(Owner),Key,AnsiString(ClassName));
end;

{ TDBLookupComboBox }

procedure TDBLookupComboBox.KeyDown(var Key: Word; Shift: TShiftState);
begin
    inherited;
    EnterIsTab(TForm(Owner),Key,AnsiString(ClassName));
end;

end.
