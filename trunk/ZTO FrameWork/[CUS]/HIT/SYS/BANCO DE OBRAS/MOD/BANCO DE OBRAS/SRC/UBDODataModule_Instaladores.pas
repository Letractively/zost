unit UBDODataModule_Instaladores;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ImgList, ActnList, ExtCtrls,

  UBDODataModule, UXXXTypesConstantsAndClasses, _ActnList,

  ZSqlUpdate, ZAbstractRODataset, ZAbstractDataset, ZAbstractTable, ZDataset,
  CFDBValidationChecks, DB, Menus, ActnPopup, PlatformDefaultStyleActnCtrls;

type
  	TBDODataModule_Instaladores = class(TBDODataModule)
    	INSTALADORES: TZQuery;
    	INSTALADORESSM_INSTALADORES_ID: TSmallIntField;
    INSTALADORESVA_NOME: TWideStringField;
    	UpdateSQL_INS: TZUpdateSQL;
    	DataSource_INS: TDataSource;
    	CFDBValidationChecks_INS: TCFDBValidationChecks;
	    Action_INS_Insert: TAction;
    	Action_INS_Edit: TAction;
	    Action_INS_Delete: TAction;
    PopupActionBar_RecordInformation: TPopupActionBar;
    MenuItem_InformacoesSobreORegistro: TMenuItem;
	    procedure Action_INS_DeleteExecute(Sender: TObject);
    	procedure Action_INS_InsertExecute(Sender: TObject);
	    procedure Action_INS_EditExecute(Sender: TObject);
    procedure Action_RecordInformationExecute(Sender: TObject);
  	private
    	{ Private declarations }
	protected
        procedure SetRefreshSQL(const aZQuery: TZQuery; const aDBAction: TDBAction; out aRefreshSQL: AnsiString); override;
        procedure DoBeforePost(aDataSet: TDataSet); override;
        procedure DoBeforeDelete(aDataSet: TDataSet); override;
	public
    	{ Public declarations }
        procedure LocalizarInstaladorPorNome(const aLabeledEdit: TLabeledEdit);
	    procedure DBButtonClick_INS(aDBButton: TDBButton; aComponentToFocusOnInsertAndEdit: TWinControl = nil);
        procedure DoDataChange(aSender: TObject; aField: TField); override;
  	end;

implementation

uses
	UBDOForm_Instaladores, UXXXDataModule, StdCtrls;

{$R *.dfm}

{ TDataModule_Projetistas }

procedure TBDODataModule_Instaladores.Action_INS_DeleteExecute(Sender: TObject);
begin
  	inherited;
    DBButtonClick_INS(dbbDelete);
end;

procedure TBDODataModule_Instaladores.Action_INS_EditExecute(Sender: TObject);
begin
  	inherited;
    DBButtonClick_INS(dbbEdit,TBDOForm_Instaladores(Owner).DBEdit_INS_VA_NOME);
end;

procedure TBDODataModule_Instaladores.Action_INS_InsertExecute(Sender: TObject);
begin
  	inherited;
    DBButtonClick_INS(dbbInsert,TBDOForm_Instaladores(Owner).DBEdit_INS_VA_NOME);
end;

procedure TBDODataModule_Instaladores.Action_RecordInformationExecute(Sender: TObject);
begin
    inherited;
    ShowRecordInformationForm(DataModuleMain.ZConnections.ByName['ZConnection_BDO'].Connection
                             ,'INSTALADORES'
                             ,'SM_INSTALADORES_ID'
                             ,INSTALADORESSM_INSTALADORES_ID.AsInteger);
end;

procedure TBDODataModule_Instaladores.DBButtonClick_INS(aDBButton: TDBButton; aComponentToFocusOnInsertAndEdit: TWinControl);
begin
	DBButtonClick(INSTALADORES,aDBButton,aComponentToFocusOnInsertAndEdit);
end;

procedure TBDODataModule_Instaladores.DoBeforeDelete(aDataSet: TDataSet);
begin
	CFDBValidationChecks_INS.ValidateBeforeDelete;
	inherited;
end;

procedure TBDODataModule_Instaladores.DoBeforePost(aDataSet: TDataSet);
begin
	inherited;
  	CFDBValidationChecks_INS.ValidateBeforePost;
end;

procedure TBDODataModule_Instaladores.DoDataChange(aSender: TObject; aField: TField);
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

    if aSender = DataSource_INS then
    begin
        SafeSetActionEnabled(TBDOForm_Instaladores(Owner).Action_INS_First,ButtonEnabled[0]);
        SafeSetActionEnabled(TBDOForm_Instaladores(Owner).Action_INS_Previous,ButtonEnabled[1]);
        SafeSetActionEnabled(TBDOForm_Instaladores(Owner).Action_INS_Next,ButtonEnabled[2]);
        SafeSetActionEnabled(TBDOForm_Instaladores(Owner).Action_INS_Last,ButtonEnabled[3]);
        SafeSetActionEnabled(Action_INS_Insert,ButtonEnabled[4] and Action_INS_Insert.Allowed);
        SafeSetActionEnabled(Action_INS_Delete,ButtonEnabled[5] and Action_INS_Delete.Allowed);
        SafeSetActionEnabled(Action_INS_Edit,ButtonEnabled[6] and Action_INS_Edit.Allowed);
        SafeSetActionEnabled(TBDOForm_Instaladores(Owner).Action_INS_Post,ButtonEnabled[7]);
        SafeSetActionEnabled(TBDOForm_Instaladores(Owner).Action_INS_Cancel,ButtonEnabled[8]);
        SafeSetActionEnabled(TBDOForm_Instaladores(Owner).Action_INS_Refresh,ButtonEnabled[9]);
    end;
end;

procedure TBDODataModule_Instaladores.LocalizarInstaladorPorNome(const aLabeledEdit: TLabeledEdit);
begin
    LocateFirstRecord(INSTALADORES,TEdit(aLabeledEdit),'VA_NOME');
end;

procedure TBDODataModule_Instaladores.SetRefreshSQL(const aZQuery: TZQuery; const aDBAction: TDBAction; out aRefreshSQL: AnsiString);
begin
    inherited;
    case aDBAction of
        dbaBeforeInsert: aRefreshSQL := 'SELECT SM_INSTALADORES_ID FROM INSTALADORES WHERE SM_INSTALADORES_ID = LAST_INSERT_ID()';
        dbaBeforeEdit: aRefreshSQL := '';
    end;
end;

end.
