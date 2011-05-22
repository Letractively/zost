unit UBDODataModule_Situacoes;

interface

uses
  	Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  	Dialogs, ActnList, ImgList, DB, ExtCtrls

  	, UBDODataModule,  UXXXTypesConstantsAndClasses, _ActnList,

  	ZSqlUpdate, ZAbstractRODataset, ZAbstractDataset, ZAbstractTable, ZDataset,
  	CFDBValidationChecks, Menus, ActnPopup;

type
  	TBDODataModule_Situacoes = class(TBDODataModule)
    	Action_SIT_Insert: TAction;
    	Action_SIT_Edit: TAction;
    	Action_SIT_Delete: TAction;
	    SITUACOES: TZQuery;
    	SITUACOESTI_SITUACOES_ID: TSmallintField;
	    SITUACOESVA_DESCRICAO: TStringField;
    	SITUACOESBO_EXPIRAVEL: TSmallintField;
	    UpdateSQL_SIT: TZUpdateSQL;
    	DataSource_SIT: TDataSource;
	    CFDBValidationChecks_SIT: TCFDBValidationChecks;
    	SITUACOESTI_DIASPARAEXPIRACAO: TSmallintField;
    SITUACOESBO_JUSTIFICAVEL: TSmallintField;
    PopupActionBar_RecordInformation: TPopupActionBar;
    MenuItem_InformacoesSobreORegistro: TMenuItem;
    	procedure Action_SIT_DeleteExecute(Sender: TObject);
	    procedure Action_SIT_EditExecute(Sender: TObject);
    	procedure Action_SIT_InsertExecute(Sender: TObject);
    	procedure SITUACOESTI_DIASPARAEXPIRACAOGetText(Sender: TField; var Text: string; DisplayText: Boolean);
    	procedure SITUACOESBO_EXPIRAVELGetText(Sender: TField; var Text: string; DisplayText: Boolean);
    procedure SITUACOESBO_JUSTIFICAVELGetText(Sender: TField; var Text: string;
      DisplayText: Boolean);
    procedure Action_RecordInformationExecute(Sender: TObject);
  	private
    	{ Private declarations }
	protected
        procedure SetRefreshSQL(const aZQuery: TZQuery; const aDBAction: TDBAction; out aRefreshSQL: AnsiString); override;
        procedure DoBeforePost(aDataSet: TDataSet); override;
        procedure DoBeforeDelete(aDataSet: TDataSet); override;
  	public
    	{ Public declarations }
        procedure LocalizarSituacaoPorDescricao(const aLabeledEdit: TLabeledEdit);
	    procedure DBButtonClick_SIT(aDBButton: TDBButton; aComponentToFocusOnInsertAndEdit: TWinControl = nil);
        procedure DoDataChange(aSender: TObject; aField: TField); override;
  	end;

implementation

uses
  	StrUtils,

    UBDOForm_Situacoes, UXXXDataModule, StdCtrls;

{$R *.dfm}

procedure TBDODataModule_Situacoes.Action_RecordInformationExecute(Sender: TObject);
begin
    inherited;
    ShowRecordInformationForm(DataModuleMain.ZConnections.ByName['ZConnection_BDO'].Connection
                             ,'SITUACOES'
                             ,'TI_SITUACOES_ID'
                             ,SITUACOESTI_SITUACOES_ID.AsInteger);
end;

procedure TBDODataModule_Situacoes.Action_SIT_DeleteExecute(Sender: TObject);
begin
  	inherited;
    DBButtonClick_SIT(dbbDelete);
end;

procedure TBDODataModule_Situacoes.Action_SIT_InsertExecute(Sender: TObject);
begin
	inherited;
    DBButtonClick_SIT(dbbInsert,TBDOForm_Situacoes(Owner).DBEdit_SIT_VA_DESCRICAO);
end;

procedure TBDODataModule_Situacoes.Action_SIT_EditExecute(Sender: TObject);
begin
  	inherited;
    DBButtonClick_SIT(dbbEdit,TBDOForm_Situacoes(Owner).DBEdit_SIT_VA_DESCRICAO);
end;

procedure TBDODataModule_Situacoes.DBButtonClick_SIT(aDBButton: TDBButton; aComponentToFocusOnInsertAndEdit: TWinControl = nil);
begin
	DBButtonClick(SITUACOES,aDBButton,aComponentToFocusOnInsertAndEdit);
end;

procedure TBDODataModule_Situacoes.DoBeforeDelete(aDataSet: TDataSet);
begin
    CFDBValidationChecks_SIT.ValidateBeforeDelete;
  	inherited;
end;

procedure TBDODataModule_Situacoes.DoBeforePost(aDataSet: TDataSet);
begin
	inherited; { Verifica permissão }
  	CFDBValidationChecks_SIT.ValidateBeforePost;

    { Outras validações específicas de negócio}
    if SITUACOES.FieldByName('BO_EXPIRAVEL').AsInteger = 0 then
    	SITUACOES.FieldByName('TI_DIASPARAEXPIRACAO').AsInteger := 0
    else
    	if SITUACOES.FieldByName('TI_DIASPARAEXPIRACAO').AsInteger = 0 then
        	raise EInvalidFieldValue.Create(SITUACOES.FieldByName('TI_DIASPARAEXPIRACAO'),'Para situações expiráveis é necessário informar a quantidade de dias para expiração. Por favor informe um valor entre 1 e 255');
end;

procedure TBDODataModule_Situacoes.DoDataChange(aSender: TObject; aField: TField);
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

    if aSender = DataSource_SIT then
    begin
        SafeSetActionEnabled(TBDOForm_Situacoes(Owner).Action_SIT_First,ButtonEnabled[0]);
        SafeSetActionEnabled(TBDOForm_Situacoes(Owner).Action_SIT_Previous,ButtonEnabled[1]);
        SafeSetActionEnabled(TBDOForm_Situacoes(Owner).Action_SIT_Next,ButtonEnabled[2]);
        SafeSetActionEnabled(TBDOForm_Situacoes(Owner).Action_SIT_Last,ButtonEnabled[3]);
        SafeSetActionEnabled(Action_SIT_Insert,ButtonEnabled[4] and Action_SIT_Insert.Allowed);
        SafeSetActionEnabled(Action_SIT_Delete,ButtonEnabled[5] and Action_SIT_Delete.Allowed);
        SafeSetActionEnabled(Action_SIT_Edit,ButtonEnabled[6] and Action_SIT_Edit.Allowed);
        SafeSetActionEnabled(TBDOForm_Situacoes(Owner).Action_SIT_Post,ButtonEnabled[7]);
        SafeSetActionEnabled(TBDOForm_Situacoes(Owner).Action_SIT_Cancel,ButtonEnabled[8]);
        SafeSetActionEnabled(TBDOForm_Situacoes(Owner).Action_SIT_Refresh,ButtonEnabled[9]);
    end;
end;

procedure TBDODataModule_Situacoes.LocalizarSituacaoPorDescricao(const aLabeledEdit: TLabeledEdit);
begin
    LocateFirstRecord(SITUACOES,TEdit(aLabeledEdit),'VA_DESCRICAO');
end;

procedure TBDODataModule_Situacoes.SetRefreshSQL(const aZQuery: TZQuery; const aDBAction: TDBAction; out aRefreshSQL: AnsiString);
begin
    inherited;
    case aDBAction of
        dbaBeforeInsert: aRefreshSQL := 'SELECT TI_SITUACOES_ID FROM SITUACOES WHERE TI_SITUACOES_ID = LAST_INSERT_ID()';
        dbaBeforeEdit: aRefreshSQL := '';
    end;
end;

procedure TBDODataModule_Situacoes.SITUACOESBO_EXPIRAVELGetText(Sender: TField; var Text: string; DisplayText: Boolean);
begin
	inherited;
    Text := IfThen(DisplayText,GetElementByIndex(Sender.AsInteger,['Não','Sim']),Sender.AsString);
end;

procedure TBDODataModule_Situacoes.SITUACOESBO_JUSTIFICAVELGetText(Sender: TField; var Text: string; DisplayText: Boolean);
begin
    inherited;
    Text := IfThen(DisplayText,GetElementByIndex(Sender.AsInteger,['Não','Sim']),Sender.AsString);
end;

procedure TBDODataModule_Situacoes.SITUACOESTI_DIASPARAEXPIRACAOGetText(Sender: TField; var Text: string; DisplayText: Boolean);
begin
	inherited;
    if DisplayText then
    begin
	    if SITUACOESBO_EXPIRAVEL.AsInteger = 1 then
    		Text := Sender.AsString + ' dias'
	    else
    		Text := 'N/A';
    end
    else
    	Text := Sender.AsString;
end;

{
  SELECT TI_SITUACOES_ID
       , VA_DESCRICAO
       , BO_EXPIRAVEL
       , TI_DIASPARAEXPIRACAO
       , IF(BO_EXPIRAVEL,'Sim','Não') AS EXPIRAVEL
       , IF(BO_EXPIRAVEL,CONCAT(TI_DIASPARAEXPIRACAO,' dias'),'N/A') AS DIASPARAEXPIRACAO
    FROM SITUACOES
ORDER BY VA_DESCRICAO

}

end.
