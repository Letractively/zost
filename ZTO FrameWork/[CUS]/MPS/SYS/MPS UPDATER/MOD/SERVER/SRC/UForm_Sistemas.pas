unit UForm_Sistemas;

interface

uses
    Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
    Dialogs, Grids, DBGrids, ExtCtrls, StdCtrls, Buttons,
    ZTO.Components.DataControls.ZTODBGrid;

type
    TForm_Sistemas = class(TForm)
			ZTODBGrid_SIS: TZTODBGrid;
			Panel_SIS: TPanel;
    	BitBtn_Cancelar: TBitBtn;
    	BitBtn_Confirmar: TBitBtn;
    	procedure ZTODBGrid_SISAfterMultiselect(aSender: TObject; aMultiSelectEventTrigger: TMultiSelectEventTrigger);
    private
      { Private declarations }
    public
      { Public declarations }
    end;

implementation

uses
  UDataModule_Principal;

{$R *.dfm}

procedure TForm_Sistemas.ZTODBGrid_SISAfterMultiselect(aSender: TObject; aMultiSelectEventTrigger: TMultiSelectEventTrigger);
begin
  BitBtn_Confirmar.Enabled := ZTODBGrid_SIS.SelectedRows.Count > 0;
  
end;

end.
