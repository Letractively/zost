unit UBDODataModule_TabelasAuxiliares;

interface

uses
  	Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  	Dialogs, UBDODataModule, ImgList, ActnList, DB, ExtCtrls,

    UXXXTypesConstantsAndClasses, UBDOForm_TabelasAuxiliares, _ActnList,

    ZSqlUpdate, ZAbstractRODataset, ZAbstractDataset, ZAbstractTable, ZDataset,
  	CFDBValidationChecks, Menus, ActnPopup;

type
  	TBDODataModule_TabelasAuxiliares = class(TBDODataModule)
	    Action_ICM_Insert: TAction;
    	Action_ICM_Edit: TAction;
	    Action_ICM_Delete: TAction;
	    Action_UNI_Insert: TAction;
    	Action_UNI_Edit: TAction;
	    Action_UNI_Delete: TAction;
	    ICMS: TZQuery;
    	UpdateSQL_ICM: TZUpdateSQL;
	    DataSource_ICM: TDataSource;
    	UNIDADES: TZQuery;
	    UpdateSQL_UNI: TZUpdateSQL;
    	DataSource_UNI: TDataSource;
	    ICMSFL_VALOR: TFloatField;
    	UNIDADESTI_UNIDADES_ID: TSmallintField;
        ICMSTI_ICMS_ID: TSmallintField;
    	UNIDADESVA_ABREVIATURA: TStringField;
	    UNIDADESVA_DESCRICAO: TStringField;
    	CFDBValidationChecks_ICM: TCFDBValidationChecks;
	    CFDBValidationChecks_UNI: TCFDBValidationChecks;
        PopupActionBar_RecordInformation: TPopupActionBar;
        MenuItem_InformacoesSobreORegistro: TMenuItem;
        Action_JUS_Insert: TAction;
        Action_JUS_Edit: TAction;
        Action_JUS_Delete: TAction;
        JUSTIFICATIVAS: TZQuery;
        UpdateSQL_JUS: TZUpdateSQL;
        DataSource_JUS: TDataSource;
        CFDBValidationChecks_JUS: TCFDBValidationChecks;
        JUSTIFICATIVASTI_JUSTIFICATIVAS_ID: TSmallintField;
        JUSTIFICATIVASEN_CATEGORIA: TStringField;
        JUSTIFICATIVASVA_JUSTIFICATIVA: TStringField;
        JUSTIFICATIVASCATEGORIA: TStringField;
    	procedure ICMSFL_VALORGetText(Sender: TField; var Text: string; DisplayText: Boolean);
	    procedure Action_ICM_InsertExecute(Sender: TObject);
    	procedure Action_ICM_EditExecute(Sender: TObject);
	    procedure Action_ICM_DeleteExecute(Sender: TObject);
    	procedure Action_UNI_InsertExecute(Sender: TObject);
	    procedure Action_UNI_EditExecute(Sender: TObject);
    	procedure Action_UNI_DeleteExecute(Sender: TObject);
        procedure Action_RecordInformationExecute(Sender: TObject);
        procedure JUSTIFICATIVASEN_CATEGORIASetText(Sender: TField; const Text: string);
        procedure JUSTIFICATIVASEN_CATEGORIAGetText(Sender: TField; var Text: string; DisplayText: Boolean);
        procedure Action_JUS_InsertExecute(Sender: TObject);
        procedure Action_JUS_EditExecute(Sender: TObject);
        procedure Action_JUS_DeleteExecute(Sender: TObject);
  	private
    	{ Private declarations }
        function MyModule: TBDOForm_TabelasAuxiliares;
	protected
        procedure SetRefreshSQL(const aZQuery: TZQuery; const aDBAction: TDBAction; out aRefreshSQL: AnsiString); override;
    	procedure DoBeforeDelete(aDataSet: TDataSet); override;
	    procedure DoBeforePost(aDataSet: TDataSet); override;
  	public
    	{ Public declarations }
	    procedure DBButtonClick_ICM(aDBButton: TDBButton; aComponentToFocusOnInsertAndEdit: TWinControl = nil);
    	procedure DBButtonClick_UNI(aDBButton: TDBButton; aComponentToFocusOnInsertAndEdit: TWinControl = nil);
	    procedure DBButtonClick_JUS(aDBButton: TDBButton; aComponentToFocusOnInsertAndEdit: TWinControl = nil);
    	procedure DoDataChange(aSender: TObject; aField: TField); override;
  	end;

implementation

uses
  	StrUtils, UXXXDataModule, StdCtrls, UCFDBGrid;

{$R *.dfm}

{ TBDODataModule_TabelasAuxiliares }

procedure TBDODataModule_TabelasAuxiliares.Action_ICM_DeleteExecute(Sender: TObject);
begin
  	inherited;
    DBButtonClick_ICM(dbbDelete);
end;

procedure TBDODataModule_TabelasAuxiliares.Action_ICM_EditExecute(Sender: TObject);
begin
  	inherited;
    DBButtonClick_ICM(dbbEdit,MyModule.DBEdit_ICM_FL_VALOR);
end;

procedure TBDODataModule_TabelasAuxiliares.Action_ICM_InsertExecute(Sender: TObject);
begin
  	inherited;
    DBButtonClick_ICM(dbbInsert,MyModule.DBEdit_ICM_FL_VALOR);
end;

procedure TBDODataModule_TabelasAuxiliares.Action_JUS_DeleteExecute(Sender: TObject);
begin
    inherited;
	DBButtonClick_JUS(dbbDelete);
end;

procedure TBDODataModule_TabelasAuxiliares.Action_JUS_EditExecute(Sender: TObject);
begin
    inherited;
	DBButtonClick_JUS(dbbEdit,MyModule.DBComboBox_JUS_EN_CATEGORIA);
end;

procedure TBDODataModule_TabelasAuxiliares.Action_JUS_InsertExecute(Sender: TObject);
begin
    inherited;
	DBButtonClick_JUS(dbbInsert,MyModule.DBComboBox_JUS_EN_CATEGORIA);
end;

procedure TBDODataModule_TabelasAuxiliares.Action_RecordInformationExecute(Sender: TObject);
begin
    inherited;
    if TCFDBGrid(PopupActionBar_RecordInformation.PopupComponent).DataSource.DataSet = ICMS then
        ShowRecordInformationForm(DataModuleMain.ZConnections.ByName['ZConnection_BDO'].Connection
                                 ,'ICMS'
                                 ,'TI_ICMS_ID'
                                 ,ICMSTI_ICMS_ID.AsInteger)
    else if TCFDBGrid(PopupActionBar_RecordInformation.PopupComponent).DataSource.DataSet = UNIDADES then
        ShowRecordInformationForm(DataModuleMain.ZConnections.ByName['ZConnection_BDO'].Connection
                                 ,'UNIDADES'
                                 ,'TI_UNIDADES_ID'
                                 ,UNIDADESTI_UNIDADES_ID.AsInteger)
    else if TCFDBGrid(PopupActionBar_RecordInformation.PopupComponent).DataSource.DataSet = JUSTIFICATIVAS then
        ShowRecordInformationForm(DataModuleMain.ZConnections.ByName['ZConnection_BDO'].Connection
                                 ,'JUSTIFICATIVAS'
                                 ,'TI_JUSTIFICATIVAS_ID'
                                 ,JUSTIFICATIVASTI_JUSTIFICATIVAS_ID.AsInteger)
end;

procedure TBDODataModule_TabelasAuxiliares.Action_UNI_DeleteExecute(Sender: TObject);
begin
  	inherited;
    DBButtonClick_UNI(dbbDelete);
end;

procedure TBDODataModule_TabelasAuxiliares.Action_UNI_EditExecute(Sender: TObject);
begin
  	inherited;
    DBButtonClick_UNI(dbbEdit,MyModule.DBEdit_UNI_VA_ABREVIATURA);
end;

procedure TBDODataModule_TabelasAuxiliares.Action_UNI_InsertExecute(Sender: TObject);
begin
  	inherited;
    DBButtonClick_UNI(dbbInsert,MyModule.DBEdit_UNI_VA_ABREVIATURA);
end;

procedure TBDODataModule_TabelasAuxiliares.DBButtonClick_ICM(aDBButton: TDBButton; aComponentToFocusOnInsertAndEdit: TWinControl);
begin
	DBButtonClick(ICMS,aDBButton,aComponentToFocusOnInsertAndEdit);
end;

procedure TBDODataModule_TabelasAuxiliares.DBButtonClick_JUS(aDBButton: TDBButton; aComponentToFocusOnInsertAndEdit: TWinControl);
begin
	DBButtonClick(JUSTIFICATIVAS,aDBButton,aComponentToFocusOnInsertAndEdit);
end;

procedure TBDODataModule_TabelasAuxiliares.DBButtonClick_UNI(aDBButton: TDBButton; aComponentToFocusOnInsertAndEdit: TWinControl);
begin
	DBButtonClick(UNIDADES,aDBButton,aComponentToFocusOnInsertAndEdit);
end;

procedure TBDODataModule_TabelasAuxiliares.DoBeforeDelete(aDataSet: TDataSet);
begin
	if aDataSet = ICMS then
    	CFDBValidationChecks_ICM.ValidateBeforeDelete
    else if aDataSet = UNIDADES then
    	CFDBValidationChecks_UNI.ValidateBeforeDelete
    else if aDataSet = JUSTIFICATIVAS then
    	CFDBValidationChecks_JUS.ValidateBeforeDelete;
        
  	inherited;
end;

procedure TBDODataModule_TabelasAuxiliares.DoBeforePost(aDataSet: TDataSet);
begin
	inherited; { Verifica permissão }

	if aDataSet = ICMS then
    	CFDBValidationChecks_ICM.ValidateBeforePost
    else if aDataSet = UNIDADES then
    	CFDBValidationChecks_UNI.ValidateBeforePost
    else if aDataSet = JUSTIFICATIVAS then
    	CFDBValidationChecks_JUS.ValidateBeforePost;
        
    { Outras validações específicas de negócio}
end;

procedure TBDODataModule_TabelasAuxiliares.DoDataChange(aSender: TObject; aField: TField);
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

    if aSender = DataSource_ICM then
    begin
        SafeSetActionEnabled(MyModule.Action_ICM_First,ButtonEnabled[0]);
        SafeSetActionEnabled(MyModule.Action_ICM_Previous,ButtonEnabled[1]);
        SafeSetActionEnabled(MyModule.Action_ICM_Next,ButtonEnabled[2]);
        SafeSetActionEnabled(MyModule.Action_ICM_Last,ButtonEnabled[3]);
        SafeSetActionEnabled(Action_ICM_Insert,ButtonEnabled[4] and Action_ICM_Insert.Allowed);
        SafeSetActionEnabled(Action_ICM_Delete,ButtonEnabled[5] and Action_ICM_Delete.Allowed);
        SafeSetActionEnabled(Action_ICM_Edit,ButtonEnabled[6] and Action_ICM_Edit.Allowed);
        SafeSetActionEnabled(MyModule.Action_ICM_Post,ButtonEnabled[7]);
        SafeSetActionEnabled(MyModule.Action_ICM_Cancel,ButtonEnabled[8]);
        SafeSetActionEnabled(MyModule.Action_ICM_Refresh,ButtonEnabled[9]);

		MyModule.Label_ICM_TaxasListadasValor.Caption := FormatFloat('###,###,##0',DataSource_ICM.DataSet.RecordCount);
    end
    else if aSender = DataSource_UNI then
    begin
        SafeSetActionEnabled(MyModule.Action_UNI_First,ButtonEnabled[0]);
        SafeSetActionEnabled(MyModule.Action_UNI_Previous,ButtonEnabled[1]);
        SafeSetActionEnabled(MyModule.Action_UNI_Next,ButtonEnabled[2]);
        SafeSetActionEnabled(MyModule.Action_UNI_Last,ButtonEnabled[3]);
        SafeSetActionEnabled(Action_UNI_Insert,ButtonEnabled[4] and Action_UNI_Insert.Allowed);
        SafeSetActionEnabled(Action_UNI_Delete,ButtonEnabled[5] and Action_UNI_Delete.Allowed);
        SafeSetActionEnabled(Action_UNI_Edit,ButtonEnabled[6] and Action_UNI_Edit.Allowed);
        SafeSetActionEnabled(MyModule.Action_UNI_Post,ButtonEnabled[7]);
        SafeSetActionEnabled(MyModule.Action_UNI_Cancel,ButtonEnabled[8]);
        SafeSetActionEnabled(MyModule.Action_UNI_Refresh,ButtonEnabled[9]);

		MyModule.Label_UNI_UnidadesListadasValor.Caption := FormatFloat('###,###,##0',DataSource_UNI.DataSet.RecordCount);
    end
    else if aSender = DataSource_JUS then
    begin
        SafeSetActionEnabled(MyModule.Action_JUS_First,ButtonEnabled[0]);
        SafeSetActionEnabled(MyModule.Action_JUS_Previous,ButtonEnabled[1]);
        SafeSetActionEnabled(MyModule.Action_JUS_Next,ButtonEnabled[2]);
        SafeSetActionEnabled(MyModule.Action_JUS_Last,ButtonEnabled[3]);
        SafeSetActionEnabled(Action_JUS_Insert,ButtonEnabled[4] and Action_JUS_Insert.Allowed);
        SafeSetActionEnabled(Action_JUS_Delete,ButtonEnabled[5] and Action_JUS_Delete.Allowed);
        SafeSetActionEnabled(Action_JUS_Edit,ButtonEnabled[6] and Action_JUS_Edit.Allowed);
        SafeSetActionEnabled(MyModule.Action_JUS_Post,ButtonEnabled[7]);
        SafeSetActionEnabled(MyModule.Action_JUS_Cancel,ButtonEnabled[8]);
        SafeSetActionEnabled(MyModule.Action_JUS_Refresh,ButtonEnabled[9]);

		MyModule.Label_JUS_JustificativasListadasValor.Caption := FormatFloat('###,###,##0',DataSource_JUS.DataSet.RecordCount);
    end;
end;

procedure TBDODataModule_TabelasAuxiliares.ICMSFL_VALORGetText(Sender: TField; var Text: string; DisplayText: Boolean);
begin
	inherited;
    Text := IfThen(DisplayText,FormatFloat('##0.00 %',Sender.AsFloat),Sender.AsString);
end;

procedure TBDODataModule_TabelasAuxiliares.JUSTIFICATIVASEN_CATEGORIAGetText(Sender: TField; var Text: string; DisplayText: Boolean);
begin
    inherited;
    if Sender.AsString = 'C' then
        Text := 'COMERCIAL'
    else if Sender.AsString = 'T' then
        Text := 'TÉCNICA';
end;

procedure TBDODataModule_TabelasAuxiliares.JUSTIFICATIVASEN_CATEGORIASetText(Sender: TField; const Text: string);
begin
    inherited;
    if Text = 'COMERCIAL' then
        Sender.AsString := 'C'
    else if Text = 'TÉCNICA' then
        Sender.AsString := 'T';
end;

function TBDODataModule_TabelasAuxiliares.MyModule: TBDOForm_TabelasAuxiliares;
begin
	Result := TBDOForm_TabelasAuxiliares(Owner);
end;

procedure TBDODataModule_TabelasAuxiliares.SetRefreshSQL(const aZQuery: TZQuery; const aDBAction: TDBAction; out aRefreshSQL: AnsiString);
begin
    inherited;
    if aZQuery = ICMS then
        case aDBAction of
            dbaBeforeInsert: aRefreshSQL := 'SELECT TI_ICMS_ID FROM ICMS WHERE TI_ICMS_ID = LAST_INSERT_ID()';
            dbaBeforeEdit: aRefreshSQL := '';
        end
    else if aZQuery = UNIDADES then
        case aDBAction of
            dbaBeforeInsert: aRefreshSQL := 'SELECT TI_UNIDADES_ID FROM UNIDADES WHERE TI_UNIDADES_ID = LAST_INSERT_ID()';
            dbaBeforeEdit: aRefreshSQL := '';
        end
    else if aZQuery = JUSTIFICATIVAS then
        case aDBAction of
            dbaBeforeInsert: aRefreshSQL :=
                             'SELECT TI_JUSTIFICATIVAS_ID'#13#10 +
                             '     , CASE EN_CATEGORIA WHEN ''C'' THEN ''COMERCIAL'' WHEN ''T'' THEN ''TÉCNICA'' ELSE ''N/A'' END AS CATEGORIA'#13#10 +
                             '  FROM JUSTIFICATIVAS WHERE TI_JUSTIFICATIVAS_ID = LAST_INSERT_ID()';
            dbaBeforeEdit: aRefreshSQL := 
                           'SELECT TI_JUSTIFICATIVAS_ID'#13#10 +
                           '     , CASE EN_CATEGORIA WHEN ''C'' THEN ''COMERCIAL'' WHEN ''T'' THEN ''TÉCNICA'' ELSE ''N/A'' END AS CATEGORIA'#13#10 +
                           '  FROM JUSTIFICATIVAS WHERE TI_JUSTIFICATIVAS_ID = :OLD_TI_JUSTIFICATIVAS_ID';
        end;
end;

end.
