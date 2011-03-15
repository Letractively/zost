unit UBDOForm_AdminModule;

interface

uses
  	Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  	Dialogs, UXXXForm_AdminModule, ActnList, Mask, DBCtrls, Buttons, StdCtrls,
  	Grids, ExtCtrls, ComCtrls, _StdCtrls, _DBCtrls, DBGrids, UCFDBGrid;

type
    TBDOForm_AdminModule = class(TXXXForm_AdminModule)
        GroupBox_RDU: TGroupBox;
        Panel1: TPanel;
        Label1: TLabel;
        BitBtn_RDU_Adicionar: TBitBtn;
        BitBtn_RDU_Remover: TBitBtn;
    CFDBGrid_RDU: TCFDBGrid;
    procedure CFDBGrid_RDUAfterMultiselect(aSender: TObject;
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

procedure TBDOForm_AdminModule.CFDBGrid_RDUAfterMultiselect(aSender: TObject; aMultiSelectEventTrigger: TMultiSelectEventTrigger);
begin
    inherited;
    MyDataModule.SafeSetActionEnabled(TBDODataModule_Administration(MyDataModule).Action_RDU_Delete,(CFDBGrid_RDU.SelectedRows.Count > 0) and TBDODataModule_Administration(MyDataModule).Action_RDU_Delete.Allowed);
end;

end.
