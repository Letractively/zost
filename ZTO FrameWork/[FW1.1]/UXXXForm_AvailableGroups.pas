unit UXXXForm_AvailableGroups;

interface

uses
  	Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  	Dialogs, ActnList, ExtCtrls, StdCtrls, Buttons, Grids, DB,

    UXXXForm_DialogTemplate, ZAbstractDataset,

    UCFDBGrid, DBGrids;
type
    TXXXForm_AvailableGroups = class(TXXXForm_DialogTemplate)
	    CFDBGrid_GRU: TCFDBGrid;
	    BitBtn_Confirm: TBitBtn;
    	BitBtn_Cancel: TBitBtn;
        procedure FormCreate(Sender: TObject);
    procedure CFDBGrid_GRUAfterMultiselect(aSender: TObject;
      aMultiSelectEventTrigger: TMultiSelectEventTrigger);
    private
	    { Private declarations }
    public
    	{ Public declarations }
    end;


implementation

uses
    UXXXDataModule_Administration;

{$R *.dfm}

{ TXXXForm_AvailableGroups }

procedure TXXXForm_AvailableGroups.CFDBGrid_GRUAfterMultiselect(aSender: TObject; aMultiSelectEventTrigger: TMultiSelectEventTrigger);
begin
  inherited;
  BitBtn_Confirm.Enabled := CFDBGrid_GRU.SelectedRows.Count > 0;
end;

procedure TXXXForm_AvailableGroups.FormCreate(Sender: TObject);
begin
    inherited;
    CFDBGrid_GRU.DataSource := TXXXDataModule_Administration(CreateParameters.MyDataModule).DataSource_GRU;
end;

end.
