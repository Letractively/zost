unit UBDOForm_AvailableRegions;

interface

uses
  	Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  	Dialogs, ActnList, ExtCtrls, StdCtrls, Buttons, Grids, DB,

    UXXXForm_DialogTemplate, ZAbstractDataset,

    UCFDBGrid, DBGrids;
type
    TBDOForm_AvailableRegions = class(TXXXForm_DialogTemplate)
    CFDBGrid_REG: TCFDBGrid;
	    BitBtn_Confirm: TBitBtn;
    	BitBtn_Cancel: TBitBtn;
        procedure FormCreate(Sender: TObject);
    procedure CFDBGrid_REGAfterMultiselect(aSender: TObject;
      aMultiSelectEventTrigger: TMultiSelectEventTrigger);
    private
	    { Private declarations }
    public
    	{ Public declarations }
    end;


implementation

uses
    UBDODataModule_Administration;

{$R *.dfm}

{ TBDOForm_AvailableRegions }

procedure TBDOForm_AvailableRegions.CFDBGrid_REGAfterMultiselect(aSender: TObject; aMultiSelectEventTrigger: TMultiSelectEventTrigger);
begin
    inherited;
    BitBtn_Confirm.Enabled := CFDBGrid_REG.SelectedRows.Count > 0;
end;

procedure TBDOForm_AvailableRegions.FormCreate(Sender: TObject);
begin
    inherited;
    CFDBGrid_REG.DataSource := TBDODataModule_Administration(CreateParameters.MyDataModule).DataSource_REG;
end;

end.
