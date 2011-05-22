unit UBDODataModule_Administration;

interface

uses
  	Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  	Dialogs, UXXXDataModule_Administration, CFDBValidationChecks, Menus,
  	ActnPopup, DB, ZSqlUpdate, ZAbstractRODataset, ZAbstractDataset, ZDataset,
  	ImgList, ActnList, UBDOForm_AdminModule, UXXXTypesConstantsAndClasses, _ActnList,
  PlatformDefaultStyleActnCtrls;

type
    TBDODataModule_Administration = class(TXXXDataModule_Administration)
        REGIOESDOSUSUARIOS: TZQuery;
        REGIOESDOSUSUARIOSMI_REGIOESDOSUSUARIOS_ID: TIntegerField;
        REGIOESDOSUSUARIOSTI_REGIOES_ID: TSmallintField;
        REGIOESDOSUSUARIOSSM_USUARIOS_ID: TIntegerField;
        REGIOESDOSUSUARIOSVA_REGIAO: TStringField;
        UpdateSQL_RDU: TZUpdateSQL;
        DataSource_RDU: TDataSource;
        CFDBValidationChecks_RDU: TCFDBValidationChecks;
        Action_RDU_Insert: TAction;
        Action_RDU_Delete: TAction;
        REGIOES: TZReadOnlyQuery;
        DataSource_REG: TDataSource;
        REGIOESTI_REGIOES_ID: TSmallintField;
        REGIOESVA_REGIAO: TStringField;
        procedure Action_RDU_InsertExecute(Sender: TObject);
        procedure Action_RDU_DeleteExecute(Sender: TObject);
        procedure Action_RecordInformationExecute(Sender: TObject);
    private
    	{ Private declarations }
        function MyModule: TBDOForm_AdminModule;
        procedure RemoveRegionFromUser;
        procedure DoDestroyAvailableRegions(aSender: TObject);
    protected
        { Protected declarations }
        procedure SetRefreshSQL(const aZQuery: TZQuery; const aDBAction: TDBAction; out aRefreshSQL: AnsiString); override;
        procedure DoBeforePost(aDataSet: TDataSet); override;
        procedure DoBeforeDelete(aDataSet: TDataSet); override;
        procedure DoDataChange(aSender: TObject; aField: TField); override;
		function ReplaceSystemObjectNames(const aText: AnsiString): AnsiString; override;
		procedure ReplaceSystemObjectNames(const aZQuery: TZQuery); override;
        function IsSystemTable(const aTableName: AnsiString): Boolean; override;
    public
    	{ Public declarations }
    end;

implementation

uses
    UXXXForm_DialogTemplate, UBDOTypesConstantsAndClasses,
    UBDOForm_AvailableRegions, UXXXDataModule, UBDODataModule_Main, UCFDBGrid;

{$R *.dfm}

{ TBDODataModule_Administration }

function TBDODataModule_Administration.MyModule: TBDOForm_AdminModule;
begin
	Result := TBDOForm_AdminModule(Owner);
end;

{ TODO -oCarlos Feitoza -cDÚVIDA : Fica aqui uma dúvida... Se a tabela regiões
dos usuarios é uma tabela colocada na aplicação (não no frame) será necessário
incluir substituições para ela? Se isso for um padrão para o módulo de
permissões, então devemos deixar... }
function TBDODataModule_Administration.ReplaceSystemObjectNames(const aText: AnsiString): AnsiString;
begin
    Result := TBDODataModule_Main(DataModuleMain).ReplaceSystemObjectNames(aText);
end;

procedure TBDODataModule_Administration.ReplaceSystemObjectNames(const aZQuery: TZQuery);
begin
    TBDODataModule_Main(DataModuleMain).ReplaceSystemObjectNames(aZQuery);
end;

procedure TBDODataModule_Administration.SetRefreshSQL(const aZQuery: TZQuery; const aDBAction: TDBAction; out aRefreshSQL: AnsiString);
begin
    inherited;
    if aZQuery = REGIOESDOSUSUARIOS then
        case aDBAction of
            dbaBeforeInsert: aRefreshSQL :=
                             'SELECT RDU.MI_REGIOESDOSUSUARIOS_ID'#13#10 +
                             '     , REG.VA_REGIAO AS REGIAO'#13#10 +
                             '  FROM REGIOESDOSUSUARIOS RDU'#13#10 +
                             '  JOIN REGIOES REG USING(TI_REGIOES_ID)'#13#10 +
                             ' WHERE RDU.MI_REGIOESDOSUSUARIOS_ID = LAST_INSERT_ID()';
            dbaBeforeEdit: aRefreshSQL := '';
        end;
end;

procedure TBDODataModule_Administration.RemoveRegionFromUser;
const
    RDU_DELETE_TEMPLATE =
    'DELETE FROM X[RDU.REGIOESDOSUSUARIOS]X'#13#10 +
    'WHERE X[RDU.MI_REGIOESDOSUSUARIOS_ID]X IN (%s)';
var
	i: Word;
	KeysToDelete: String;
begin
    inherited;

	if MyModule.CFDBGrid_RDU.SelectedRows.Count > 0 then
    begin
	    DoBeforeDelete(REGIOESDOSUSUARIOS);

    	if MyModule.CFDBGrid_RDU.SelectedRows.Count > High(Word) then
        	MessageBox(MyModule.Handle,PChar('A quantidade de regiões selecionadas excede o limite permitido de ' + IntToStr(High(Word)) + #13#10'Por favor selecione menos ítens'),'Não é possível remover regiões',MB_ICONERROR)
        else
        begin
        	KeysToDelete := '';
            for i := 0 to Pred(MyModule.CFDBGrid_RDU.SelectedRows.Count) do
            begin
                REGIOESDOSUSUARIOS.Bookmark := MyModule.CFDBGrid_RDU.SelectedRows[i];

                KeysToDelete := KeysToDelete + REGIOESDOSUSUARIOS.FieldByName(TBDOConfigurations(Configurations).UserRegionsTableKeyFieldName).AsString;

                if i < Pred(MyModule.CFDBGrid_RDU.SelectedRows.Count) then
                    KeysToDelete := KeysToDelete + ',';
            end;
            ExecuteQuery(DataModuleMain.ZConnections[0].Connection,Format(ReplaceSystemObjectNames(RDU_DELETE_TEMPLATE),[KeysToDelete]));
            REGIOESDOSUSUARIOS.Refresh;
            { TODO -oCarlos Feitoza -cPOG : Ao excluir os registros
            selecionados, SelectedRows ainda mantém bookmarks para os registros
            selecionados que foram excluídos, o que está errado... O comando
            abaixo garante que ao se excluir, não haja mais nenhum registro
            selecionado. Isso deverá ser retirado caso a nova implementação do
            CFDBGrid resolva o problema por si só }
            MyModule.CFDBGrid_RDU.SelectedRows.Clear;
        end;
    end;
end;


procedure TBDODataModule_Administration.Action_RDU_DeleteExecute(Sender: TObject);
begin
    inherited;
	RemoveRegionFromUser;
    { O comando abaixo garante que o status do botão seja mantido correto
    (habilitado ou desabilitado) }
    MyModule.CFDBGrid_RDUAfterMultiselect(Sender,msetMouseDown);
end;

procedure TBDODataModule_Administration.DoDestroyAvailableRegions(aSender: TObject);
const
    RDU_INSERT_HEADER =
    'INSERT IGNORE INTO'#13#10 +
    '       X[RDU.REGIOESDOSUSUARIOS]X (X[RDU.SM_USUARIOS_ID]X,X[RDU.TI_REGIOES_ID]X)'#13#10 +
    'VALUES'#13#10;
    RDU_INSERT_TEMPLATE =
	'       (%u,%u)';
var
	SQL: String;
    i: Word;
	BDOForm_AvailableRegions: TBDOForm_AvailableRegions;
begin
	BDOForm_AvailableRegions := TBDOForm_AvailableRegions(aSender);

	if BDOForm_AvailableRegions.ModalResult = mrOk then
    begin
	    SQL := ReplaceSystemObjectNames(RDU_INSERT_HEADER);

        if BDOForm_AvailableRegions.CFDBGrid_REG.SelectedRows.Count > 0 then
        begin
    	   	if BDOForm_AvailableRegions.CFDBGrid_REG.SelectedRows.Count > High(Word) then
            	Application.MessageBox(PChar('A quantidade de grupos selecionados excede o limite permitido de ' + IntToStr(High(Word)) + #13#10'Por favor selecione menos grupos'),'Não é possível atribuir grupos',MB_ICONERROR)
            else
            begin
    	        for i := 0 to Pred(BDOForm_AvailableRegions.CFDBGrid_REG.SelectedRows.Count) do
                begin
                    REGIOES.Bookmark := BDOForm_AvailableRegions.CFDBGrid_REG.SelectedRows[i];
                    SQL := SQL + Format(RDU_INSERT_TEMPLATE,[USUARIOS.FieldByName(Configurations.UserTableKeyFieldName).AsInteger,REGIOES.FieldByName('TI_REGIOES_ID').AsInteger]);

                    if i < Pred(BDOForm_AvailableRegions.CFDBGrid_REG.SelectedRows.Count) then
                        SQL := SQL + ','#13#10;
                end;

    	        ExecuteQuery(DataModuleMain.ZConnections[0].Connection,SQL);
                REGIOESDOSUSUARIOS.Refresh;
            end;
        end;

    end;
end;

procedure TBDODataModule_Administration.Action_RDU_InsertExecute(Sender: TObject);
var
	CreateParameters: TDialogCreateParameters;
    BDOForm_AvailableRegions: TBDOForm_AvailableRegions;
begin
	inherited;
    DoBeforeInsert(REGIOESDOSUSUARIOS);

    BDOForm_AvailableRegions := nil;

 	ZeroMemory(@CreateParameters,SizeOf(TDialogCreateParameters));
    with CreateParameters do
    begin
        AutoFree := True;
        AutoShow := True;
        Modal := True;
        Configurations := Self.Configurations;
        MyDataModuleClass := nil;
        MyDataModule := Self;
        DataModuleMain := Self.DataModuleMain;
        OnFormDestroy := DoDestroyAvailableRegions;
    end;

	TXXXForm_DialogTemplate.CreateDialog(Owner,BDOForm_AvailableRegions,TBDOForm_AvailableRegions,CreateParameters);
end;

procedure TBDODataModule_Administration.Action_RecordInformationExecute(Sender: TObject);
begin
    inherited;
    if TCFDBGrid(PopupActionBar_RecordInformation.PopupComponent).DataSource.DataSet = REGIOESDOSUSUARIOS then
        ShowRecordInformationForm(DataModuleMain.ZConnections.ByName['ZConnection_BDO'].Connection
                                 ,'REGIOESDOSUSUARIOS'
                                 ,'MI_REGIOESDOSUSUARIOS_ID'
                                 ,REGIOESDOSUSUARIOSMI_REGIOESDOSUSUARIOS_ID.AsInteger)
end;

procedure TBDODataModule_Administration.DoBeforeDelete(aDataSet: TDataSet);
begin
    inherited;
    if aDataSet = REGIOESDOSUSUARIOS then
		CFDBValidationChecks_RDU.ValidateBeforeDelete;
end;

procedure TBDODataModule_Administration.DoBeforePost(aDataSet: TDataSet);
begin
    inherited;
	if aDataSet = REGIOESDOSUSUARIOS then
    	CFDBValidationChecks_RDU.ValidateBeforePost
end;

procedure TBDODataModule_Administration.DoDataChange(aSender: TObject; aField: TField);
begin
  	inherited;
    if (aSender = DataSource_RDU) and (Action_RDU_Delete.Tag = 0) then
    begin
        SafeSetActionEnabled(Action_RDU_Delete,(MyModule.CFDBGrid_RDU.SelectedRows.Count > 0) and Action_RDU_Delete.Allowed);
        Action_RDU_Delete.Tag := 1;
    end;
end;

function TBDODataModule_Administration.IsSystemTable(const aTableName: AnsiString): Boolean;
begin
    Result := (inherited IsSystemTable(aTableName)) or (aTableName = TBDOConfigurations(Configurations).UserRegionsTableTableName);
end;

end.
