unit UBDODataModule_Regioes;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ActnList, DB, ExtCtrls,

  ZSqlUpdate, ZAbstractRODataset, ZAbstractDataset, ZAbstractTable, ZDataset,

  UXXXTypesConstantsAndClasses, UBDODataModule, CFDBValidationChecks,
  _ActnList, ImgList, Menus, ActnPopup;

type
  	TBDODataModule_Regioes = class(TBDODataModule)
    	REGIOES: TZQuery;
	    REGIOESTI_REGIOES_ID: TSmallintField;
    	REGIOESVA_REGIAO: TStringField;
	    REGIOESCH_PREFIXODAPROPOSTA: TStringField;
    	REGIOESVA_PRIMEIRORODAPE: TStringField;
	    REGIOESVA_SEGUNDORODAPE: TStringField;
    	UpdateSQL_REG: TZUpdateSQL;
    	DataSource_REG: TDataSource;
    	CFDBValidationChecks_REG: TCFDBValidationChecks;
    	Action_REG_Insert: TAction;
    	Action_REG_Edit: TAction;
    	Action_REG_Delete: TAction;
    PopupActionBar_RecordInformation: TPopupActionBar;
    MenuItem_InformacoesSobreORegistro: TMenuItem;
    	procedure Action_REG_InsertExecute(Sender: TObject);
	    procedure Action_REG_DeleteExecute(Sender: TObject);
    	procedure Action_REG_EditExecute(Sender: TObject);
    procedure Action_RecordInformationExecute(Sender: TObject);
 	private
    	{ Private declarations }
    protected
        procedure SetRefreshSQL(const aZquery: TZQuery; const aDBAction: TDBAction; out aRefreshSQL: AnsiString); override;
        procedure DoBeforePost(aDataSet: TDataSet); override;
        procedure DoBeforeDelete(aDataSet: TDataSet); override;
  	public
    	{ Public declarations }
        procedure LocalizarRegiaoPorNome(aLabeledEdit: TLabeledEdit);
        procedure DBButtonClick_REG(aDBButton: TDBButton; aComponentToFocusOnInsertAndEdit: TWinControl = nil);
        procedure DoDataChange(aSender: TObject; aField: TField); override;
	end;

implementation

uses
	UBDOForm_Regioes, UXXXDataModule, StdCtrls;

{$R *.dfm}

procedure TBDODataModule_Regioes.Action_RecordInformationExecute(Sender: TObject);
begin
    inherited;
    ShowRecordInformationForm(DataModuleMain.ZConnections.ByName['ZConnection_BDO'].Connection
                             ,'REGIOES'
                             ,'TI_REGIOES_ID'
                             ,REGIOESTI_REGIOES_ID.AsInteger);
end;

procedure TBDODataModule_Regioes.Action_REG_DeleteExecute(Sender: TObject);
begin
  	inherited;
    DBButtonClick_REG(dbbDelete,nil);
end;

procedure TBDODataModule_Regioes.Action_REG_InsertExecute(Sender: TObject);
begin
  	inherited;
    DBButtonClick_REG(dbbInsert,TBDOForm_Regioes(Owner).DBEdit_REG_VA_PRIMEIRORODAPE);
end;

procedure TBDODataModule_Regioes.Action_REG_EditExecute(Sender: TObject);
begin
  	inherited;
    DBButtonClick_REG(dbbEdit,TBDOForm_Regioes(Owner).DBEdit_REG_VA_PRIMEIRORODAPE);
end;

procedure TBDODataModule_Regioes.DBButtonClick_REG(aDBButton: TDBButton; aComponentToFocusOnInsertAndEdit: TWinControl = nil);
begin
	DBButtonClick(REGIOES,aDBButton,aComponentToFocusOnInsertAndEdit);
end;

procedure TBDODataModule_Regioes.DoBeforeDelete(aDataSet: TDataSet);
begin
    CFDBValidationChecks_REG.ValidateBeforeDelete;
  	inherited;
end;

procedure TBDODataModule_Regioes.DoBeforePost(aDataSet: TDataSet);
begin
	inherited; { Verifica permissão }
  	CFDBValidationChecks_REG.ValidateBeforePost;

end;

procedure TBDODataModule_Regioes.DoDataChange(aSender: TObject; aField: TField);
var
	ButtonEnabled: array [0..9] of Boolean;
begin
  	inherited;

	DBButtonsToggle(TDataSource(aSender).DataSet
                   ,ButtonEnabled[0]
                   ,ButtonEnabled[1]
                   ,ButtonEnabled[2]
                   ,ButtonEnabled[3]
                   ,ButtonEnabled[4]
                   ,ButtonEnabled[5]
                   ,ButtonEnabled[6]
                   ,ButtonEnabled[7]
                   ,ButtonEnabled[8]
                   ,ButtonEnabled[9]);

    if aSender = DataSource_REG then
    begin
        SafeSetActionEnabled(TBDOForm_Regioes(Owner).Action_REG_First,ButtonEnabled[0]);
        SafeSetActionEnabled(TBDOForm_Regioes(Owner).Action_REG_Previous,ButtonEnabled[1]);
        SafeSetActionEnabled(TBDOForm_Regioes(Owner).Action_REG_Next,ButtonEnabled[2]);
        SafeSetActionEnabled(TBDOForm_Regioes(Owner).Action_REG_Last,ButtonEnabled[3]);
        SafeSetActionEnabled(Action_REG_Insert,ButtonEnabled[4] and Action_REG_Insert.Allowed);
        SafeSetActionEnabled(Action_REG_Delete,ButtonEnabled[5] and Action_REG_Delete.Allowed);
        SafeSetActionEnabled(Action_REG_Edit,ButtonEnabled[6] and Action_REG_Edit.Allowed);
        SafeSetActionEnabled(TBDOForm_Regioes(Owner).Action_REG_Post,ButtonEnabled[7]);
        SafeSetActionEnabled(TBDOForm_Regioes(Owner).Action_REG_Cancel,ButtonEnabled[8]);
        SafeSetActionEnabled(TBDOForm_Regioes(Owner).Action_REG_Refresh,ButtonEnabled[9]);
    end;
end;

procedure TBDODataModule_Regioes.LocalizarRegiaoPorNome(aLabeledEdit: TLabeledEdit);
begin
    LocateFirstRecord(REGIOES,TEdit(aLabeledEdit),'VA_REGIAO');
end;

procedure TBDODataModule_Regioes.SetRefreshSQL(const aZquery: TZQuery; const aDBAction: TDBAction; out aRefreshSQL: AnsiString);
begin
    inherited;
    case aDBAction of
        dbaBeforeInsert: aRefreshSQL := 'SELECT TI_REGIOES_ID FROM REGIOES WHERE TI_REGIOES_ID = LAST_INSERT_ID()';
        dbaBeforeEdit: aRefreshSQL := '';
    end;
end;

end.
