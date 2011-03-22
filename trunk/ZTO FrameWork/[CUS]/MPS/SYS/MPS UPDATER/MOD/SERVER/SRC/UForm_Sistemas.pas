unit UForm_Sistemas;

interface

uses
    Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
    Dialogs, Grids, DBGrids, UCFDBGrid, ExtCtrls, StdCtrls, Buttons;

type
    TForm_Sistemas = class(TForm)
      CFDBGrid_SIS: TCFDBGrid;
    Panel_SIS: TPanel;
    BitBtn_Cancelar: TBitBtn;
    BitBtn_Confirmar: TBitBtn;
    procedure CFDBGrid_SISAfterMultiselect(aSender: TObject;
      aMultiSelectEventTrigger: TMultiSelectEventTrigger);
    private
      { Private declarations }
    public
      { Public declarations }
    end;

implementation

uses
  UDataModule_Principal;

{$R *.dfm}

procedure TForm_Sistemas.CFDBGrid_SISAfterMultiselect(aSender: TObject; aMultiSelectEventTrigger: TMultiSelectEventTrigger);
begin
  BitBtn_Confirmar.Enabled := CFDBGrid_SIS.SelectedRows.Count > 0;
  
end;

end.
