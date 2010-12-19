unit ZTO.Components.DataControls.VariableColumnsEditor;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, CheckLst, ExtCtrls, Buttons;

type
  TForm_VariableColumnsEditor = class(TForm)
    CheckListBox_Columns: TCheckListBox;
    Panel_Top: TPanel;
    Panel_Bottom: TPanel;
    Label_Top: TLabel;
    BitBtn_Confirmar: TBitBtn;
    BitBtn_Cancelar: TBitBtn;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

implementation

{$R *.dfm}

end.
