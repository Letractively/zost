unit UBDODataModule_TiposDeObra;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ImgList, DB, ActnList, ExtCtrls,

  UBDODataModule, UXXXTypesConstantsAndClasses, _ActnList, 

  ZSqlUpdate, ZAbstractRODataset, ZAbstractDataset, ZAbstractTable, ZDataset,
  CFDBValidationChecks, Menus, ActnPopup;

type
	TBDODataModule_TiposDeObra = class(TBDODataModule)
	    TIPOS: TZQuery;
    	TIPOSTI_TIPOS_ID: TSmallintField;
	    TIPOSVA_DESCRICAO: TStringField;
    	UpdateSQL_TIP: TZUpdateSQL;
    	DataSource_TIP: TDataSource;
    	CFDBValidationChecks_TIP: TCFDBValidationChecks;
	    Action_TIP_Insert: TAction;
    	Action_TIP_Edit: TAction;
	    Action_TIP_Delete: TAction;
        PopupActionBar_RecordInformation: TPopupActionBar;
        MenuItem_InformacoesSobreORegistro: TMenuItem;
        procedure Action_TIP_DeleteExecute(Sender: TObject);
        procedure Action_TIP_InsertExecute(Sender: TObject);
	    procedure Action_TIP_EditExecute(Sender: TObject);
        procedure Action_RecordInformationExecute(Sender: TObject);
  	private
    	{ Private declarations }
    protected
        procedure SetRefreshSQL(const aZQuery: TZQuery; const aDBAction: TDBAction; out aRefreshSQL: AnsiString); override;
        procedure DoBeforePost(aDataSet: TDataSet); override;
        procedure DoBeforeDelete(aDataSet: TDataSet); override;
	public
    	{ Public declarations }
        procedure LocalizarTipoPorDescricao(const aLabeledEdit: TLabeledEdit);

		procedure DBButtonClick_TIP(aDBButton: TDBButton; aComponentToFocusOnInsertAndEdit: TWinControl = nil);
        procedure DoDataChange(aSender: TObject; aField: TField); override;
  	end;

implementation

uses
  	UBDOForm_TiposDeObra, StdCtrls, UXXXDataModule;

{$R *.dfm}

procedure TBDODataModule_TiposDeObra.Action_RecordInformationExecute(Sender: TObject);
begin
    inherited;
    ShowRecordInformationForm(DataModuleMain.ZConnections.ByName['ZConnection_BDO'].Connection
                             ,'TIPOS'
                             ,'TI_TIPOS_ID'
                             ,TIPOSTI_TIPOS_ID.AsInteger);
end;

procedure TBDODataModule_TiposDeObra.Action_TIP_DeleteExecute(Sender: TObject);
begin
  	inherited;
    DBButtonClick_TIP(dbbDelete);
end;

procedure TBDODataModule_TiposDeObra.Action_TIP_EditExecute(Sender: TObject);
begin
	inherited;
    DBButtonClick_TIP(dbbEdit,TBDOForm_TiposDeObra(Owner).DBEdit_TIP_VA_DESCRICAO);
end;

procedure TBDODataModule_TiposDeObra.Action_TIP_InsertExecute(Sender: TObject);
begin
	inherited;
    DBButtonClick_TIP(dbbInsert,TBDOForm_TiposDeObra(Owner).DBEdit_TIP_VA_DESCRICAO);
end;

procedure TBDODataModule_TiposDeObra.DBButtonClick_TIP(aDBButton: TDBButton; aComponentToFocusOnInsertAndEdit: TWinControl = nil);
begin
	DBButtonClick(TIPOS,aDBButton,aComponentToFocusOnInsertAndEdit);
end;

procedure TBDODataModule_TiposDeObra.DoBeforeDelete(aDataSet: TDataSet);
begin
    CFDBValidationChecks_TIP.ValidateBeforeDelete;
  	inherited;
end;

procedure TBDODataModule_TiposDeObra.DoBeforePost(aDataSet: TDataSet);
begin
	inherited; { Verifica permissão }
  	CFDBValidationChecks_TIP.ValidateBeforePost;
end;

procedure TBDODataModule_TiposDeObra.DoDataChange(aSender: TObject; aField: TField);
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

    if aSender = DataSource_TIP then
    begin
        SafeSetActionEnabled(TBDOForm_TiposDeObra(Owner).Action_SIT_First,ButtonEnabled[0]);
        SafeSetActionEnabled(TBDOForm_TiposDeObra(Owner).Action_SIT_Previous,ButtonEnabled[1]);
        SafeSetActionEnabled(TBDOForm_TiposDeObra(Owner).Action_SIT_Next,ButtonEnabled[2]);
        SafeSetActionEnabled(TBDOForm_TiposDeObra(Owner).Action_SIT_Last,ButtonEnabled[3]);
        SafeSetActionEnabled(Action_TIP_Insert,ButtonEnabled[4] and Action_TIP_Insert.Allowed);
        SafeSetActionEnabled(Action_TIP_Delete,ButtonEnabled[5] and Action_TIP_Delete.Allowed);
        SafeSetActionEnabled(Action_TIP_Edit,ButtonEnabled[6] and Action_TIP_Edit.Allowed);
        SafeSetActionEnabled(TBDOForm_TiposDeObra(Owner).Action_SIT_Post,ButtonEnabled[7]);
        SafeSetActionEnabled(TBDOForm_TiposDeObra(Owner).Action_SIT_Cancel,ButtonEnabled[8]);
        SafeSetActionEnabled(TBDOForm_TiposDeObra(Owner).Action_SIT_Refresh,ButtonEnabled[9]);
    end;
end;

procedure TBDODataModule_TiposDeObra.LocalizarTipoPorDescricao(const aLabeledEdit: TLabeledEdit);
begin
    LocateFirstRecord(TIPOS,TEdit(aLabeledEdit),'VA_DESCRICAO');
end;

procedure TBDODataModule_TiposDeObra.SetRefreshSQL(const aZQuery: TZQuery; const aDBAction: TDBAction; out aRefreshSQL: AnsiString);
begin
    inherited;
    case aDBAction of
        dbaBeforeInsert: aRefreshSQL := 'SELECT TI_TIPOS_ID FROM TIPOS WHERE TI_TIPOS_ID = LAST_INSERT_ID()';
        dbaBeforeEdit: aRefreshSQL := '';
    end;
end;

end.
