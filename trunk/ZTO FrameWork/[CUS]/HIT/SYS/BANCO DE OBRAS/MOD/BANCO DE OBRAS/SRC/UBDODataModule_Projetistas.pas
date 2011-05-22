unit UBDODataModule_Projetistas;
                                                                        
interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ImgList, ActnList, DB, ExtCtrls,

  UBDODataModule, UXXXTypesConstantsAndClasses, _ActnList,

  ZSqlUpdate, ZAbstractRODataset, ZAbstractDataset, ZAbstractTable, ZDataset,
  CFDBValidationChecks, Menus, ActnPopup;

type
  	TBDODataModule_Projetistas = class(TBDODataModule)
	    Action_PRJ_Insert: TAction;
    	Action_PRJ_Edit: TAction;
	    Action_PRJ_Delete: TAction;
	    PROJETISTAS: TZQuery;
    	PROJETISTASSM_PROJETISTAS_ID: TIntegerField;
	    PROJETISTASVA_NOME: TStringField;
    	UpdateSQL_PRJ: TZUpdateSQL;
	    DataSource_PRJ: TDataSource;
    	CFDBValidationChecks_PRJ: TCFDBValidationChecks;
    PopupActionBar_RecordInformation: TPopupActionBar;
    MenuItem_InformacoesSobreORegistro: TMenuItem;
	    procedure Action_PRJ_DeleteExecute(Sender: TObject);
    	procedure Action_PRJ_InsertExecute(Sender: TObject);
	    procedure Action_PRJ_EditExecute(Sender: TObject);
    procedure Action_RecordInformationExecute(Sender: TObject);
  	private
    	{ Private declarations }
	protected
        procedure SetRefreshSQL(const aZQuery: TZQuery; const aDBAction: TDBAction; out aRefreshSQL: AnsiString); override;
        procedure DoBeforePost(aDataSet: TDataSet); override;
        procedure DoBeforeDelete(aDataSet: TDataSet); override;
        procedure DoDataChange(aSender: TObject; aField: TField); override;
  	public
    	{ Public declarations }
        procedure LocalizarProjetistaPorNome(const aLabeledEdit: TLabeledEdit);
	    procedure DBButtonClick_PRJ(aDBButton: TDBButton; aComponentToFocusOnInsertAndEdit: TWinControl = nil);
  	end;

implementation

uses
	UBDOForm_Projetistas, StdCtrls;

{$R *.dfm}

{ TDataModule_Projetistas }

procedure TBDODataModule_Projetistas.Action_PRJ_DeleteExecute(Sender: TObject);
begin
  	inherited;
    DBButtonClick_PRJ(dbbDelete);
end;

procedure TBDODataModule_Projetistas.Action_PRJ_EditExecute(Sender: TObject);
begin
  	inherited;
    DBButtonClick_PRJ(dbbEdit,TBDOForm_Projetistas(Owner).DBEdit_PRJ_VA_NOME);
end;

procedure TBDODataModule_Projetistas.Action_PRJ_InsertExecute(Sender: TObject);
begin
  	inherited;
    DBButtonClick_PRJ(dbbInsert,TBDOForm_Projetistas(Owner).DBEdit_PRJ_VA_NOME);
end;

procedure TBDODataModule_Projetistas.Action_RecordInformationExecute(Sender: TObject);
begin
    inherited;
    ShowRecordInformationForm(DataModuleMain.ZConnections.ByName['ZConnection_BDO'].Connection
                             ,'PROJETISTAS'
                             ,'SM_PROJETISTAS_ID'
                             ,PROJETISTASSM_PROJETISTAS_ID.AsInteger);
end;

procedure TBDODataModule_Projetistas.DBButtonClick_PRJ(aDBButton: TDBButton; aComponentToFocusOnInsertAndEdit: TWinControl);
begin
	DBButtonClick(PROJETISTAS,aDBButton,aComponentToFocusOnInsertAndEdit);
end;

procedure TBDODataModule_Projetistas.DoBeforeDelete(aDataSet: TDataSet);
begin
	CFDBValidationChecks_PRJ.ValidateBeforeDelete;
	inherited;
end;

procedure TBDODataModule_Projetistas.DoBeforePost(aDataSet: TDataSet);
begin
	inherited;
  	CFDBValidationChecks_PRJ.ValidateBeforePost;
end;

procedure TBDODataModule_Projetistas.DoDataChange(aSender: TObject; aField: TField);
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

    if aSender = DataSource_PRJ then
    begin
        SafeSetActionEnabled(TBDOForm_Projetistas(Owner).Action_PRJ_First,ButtonEnabled[0]);
        SafeSetActionEnabled(TBDOForm_Projetistas(Owner).Action_PRJ_Previous,ButtonEnabled[1]);
        SafeSetActionEnabled(TBDOForm_Projetistas(Owner).Action_PRJ_Next,ButtonEnabled[2]);
        SafeSetActionEnabled(TBDOForm_Projetistas(Owner).Action_PRJ_Last,ButtonEnabled[3]);
        SafeSetActionEnabled(Action_PRJ_Insert,ButtonEnabled[4] and Action_PRJ_Insert.Allowed);
        SafeSetActionEnabled(Action_PRJ_Delete,ButtonEnabled[5] and Action_PRJ_Delete.Allowed);
        SafeSetActionEnabled(Action_PRJ_Edit,ButtonEnabled[6] and Action_PRJ_Edit.Allowed);
        SafeSetActionEnabled(TBDOForm_Projetistas(Owner).Action_PRJ_Post,ButtonEnabled[7]);
        SafeSetActionEnabled(TBDOForm_Projetistas(Owner).Action_PRJ_Cancel,ButtonEnabled[8]);
        SafeSetActionEnabled(TBDOForm_Projetistas(Owner).Action_PRJ_Refresh,ButtonEnabled[9]);
    end;
end;

procedure TBDODataModule_Projetistas.SetRefreshSQL(const aZQuery: TZQuery; const aDBAction: TDBAction; out aRefreshSQL: AnsiString);
begin
    inherited;
    case aDBAction of
        dbaBeforeInsert: aRefreshSQL := 'SELECT SM_PROJETISTAS_ID FROM PROJETISTAS WHERE SM_PROJETISTAS_ID = LAST_INSERT_ID()';
        dbaBeforeEdit: aRefreshSQL := '';
    end;
end;

procedure TBDODataModule_Projetistas.LocalizarProjetistaPorNome(const aLabeledEdit: TLabeledEdit);
begin
    LocateFirstRecord(PROJETISTAS,TEdit(aLabeledEdit),'VA_NOME');
end;


end.
