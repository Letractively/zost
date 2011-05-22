unit UXXXDataModule_Administration;

interface

uses
  	Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  	Dialogs, ImgList, ActnList, Menus, ActnPopup, DB, StdCtrls, ExtCtrls, DBGrids,

    UXXXDataModule, UXXXForm_AdminModule, UXXXTypesConstantsAndClasses, _ActnList,

    UCFDBGrid, ZDataset, ZSqlUpdate, ZAbstractRODataset, ZAbstractDataset,
 	CFDBValidationChecks, PlatformDefaultStyleActnCtrls;

type
	TModifyMode = (mmInsert, mmUpdate, mmDelete);

  	TXXXDataModule_Administration = class(TXXXDataModule)
	    ImageList_Administration: TImageList;
        ENTIDADESDOSISTEMA: TZQuery;
        ENTIDADESDOSISTEMAIN_ENTIDADESDOSISTEMA_ID: TIntegerField;
        ENTIDADESDOSISTEMAVA_NOME: TStringField;
        ENTIDADESDOSISTEMATI_TIPO: TSmallintField;
        UpdateSQL_EDS: TZUpdateSQL;
        DataSource_EDS: TDataSource;
        USUARIOS: TZQuery;
        USUARIOSSM_USUARIOS_ID: TIntegerField;
        USUARIOSVA_NOME: TStringField;
        USUARIOSVA_LOGIN: TStringField;
        USUARIOSTB_SENHA: TBlobField;
	    UpdateSQL_USU: TZUpdateSQL;
    	DataSource_USU: TDataSource;
        GRUPOSDOSUSUARIOS: TZQuery;
        GRUPOSDOSUSUARIOSMI_GRUPOSDOSUSUARIOS_ID: TIntegerField;
        GRUPOSDOSUSUARIOSTI_GRUPOS_ID: TSmallintField;
        GRUPOSDOSUSUARIOSSM_USUARIOS_ID: TIntegerField;
        GRUPOSDOSUSUARIOSVA_NOME: TStringField;
	    UpdateSQL_GDU: TZUpdateSQL;
    	DataSource_GDU: TDataSource;
        PERMISSOESDOSUSUARIOS: TZQuery;
        PERMISSOESDOSUSUARIOSIN_PERMISSOESDOSUSUARIOS_ID: TIntegerField;
        PERMISSOESDOSUSUARIOSIN_ENTIDADESDOSISTEMA_ID: TIntegerField;
        PERMISSOESDOSUSUARIOSSM_USUARIOS_ID: TIntegerField;
        PERMISSOESDOSUSUARIOSTI_LER: TSmallintField;
        PERMISSOESDOSUSUARIOSTI_INSERIR: TSmallintField;
        PERMISSOESDOSUSUARIOSTI_ALTERAR: TSmallintField;
        PERMISSOESDOSUSUARIOSTI_EXCLUIR: TSmallintField;
    	PERMISSOESDOSUSUARIOSNOME: TStringField;
        UpdateSQL_PDU: TZUpdateSQL;
        DataSource_PDU: TDataSource;
        GRUPOS: TZQuery;
        GRUPOSTI_GRUPOS_ID: TSmallintField;
        GRUPOSVA_NOME: TStringField;
        GRUPOSVA_DESCRICAO: TStringField;
	    UpdateSQL_GRU: TZUpdateSQL;
    	DataSource_GRU: TDataSource;
        PERMISSOESDOSGRUPOS: TZQuery;
        PERMISSOESDOSGRUPOSIN_PERMISSOESDOSGRUPOS_ID: TIntegerField;
        PERMISSOESDOSGRUPOSIN_ENTIDADESDOSISTEMA_ID: TIntegerField;
        PERMISSOESDOSGRUPOSTI_GRUPOS_ID: TSmallintField;
        PERMISSOESDOSGRUPOSTI_LER: TSmallintField;
        PERMISSOESDOSGRUPOSTI_INSERIR: TSmallintField;
        PERMISSOESDOSGRUPOSTI_ALTERAR: TSmallintField;
        PERMISSOESDOSGRUPOSTI_EXCLUIR: TSmallintField;
        PERMISSOESDOSGRUPOSVA_NOME: TStringField;
        UpdateSQL_PDG: TZUpdateSQL;
        DataSource_PDG: TDataSource;
	    USUARIOSDATAEHORADOCADASTRO: TStringField;
    	PERMISSOESDOSGRUPOSTIPO: TStringField;
	    PERMISSOESDOSUSUARIOSTIPO: TStringField;
    	ENTIDADESDOSISTEMATIPO: TStringField;
        PopupActionBar_PDU: TPopupActionBar;
        MenuItem_PDU_Full: TMenuItem;
        MenuItem_PDU_None: TMenuItem;
        MenuItem_PDU_Delete: TMenuItem;
        PopupActionBar_PDG: TPopupActionBar;
        MenuItem_PDG_Full: TMenuItem;
        MenuItem_PDG_None: TMenuItem;
        MenuItem_PDG_Delete: TMenuItem;
	    Action_USU_Insert: TAction;
    	Action_USU_Edit: TAction;
	    Action_USU_Delete: TAction;
    	CFDBValidationChecks_USU: TCFDBValidationChecks;
	    CFDBValidationChecks_GRU: TCFDBValidationChecks;
    	Action_GRU_Insert: TAction;
	    Action_GRU_Edit: TAction;
    	Action_GRU_Delete: TAction;
    	Action_GDU_Insert: TAction;
    	Action_GDU_Delete: TAction;
    	ImageList_PDU_PDG: TImageList;
        Action_PDU_PDG_Insert: TAction;
        Action_EDS_Insert: TAction;
        Action_EDS_Delete: TAction;
        CFDBValidationChecks_GDU: TCFDBValidationChecks;
        CFDBValidationChecks_EDS: TCFDBValidationChecks;
        CFDBValidationChecks_PDU: TCFDBValidationChecks;
        CFDBValidationChecks_PDG: TCFDBValidationChecks;
        Action_PDU_Delete: TAction;
        Action_PDG_Delete: TAction;
        Action_PDG_Full: TAction;
        Action_PDG_None: TAction;
        Action_PDU_Full: TAction;
        Action_PDU_None: TAction;
    Action_RecordInformation: TAction;
    PopupActionBar_RecordInformation: TPopupActionBar;
    MenuItem_InformacoesSobreORegistro: TMenuItem;
    N1: TMenuItem;
    N2: TMenuItem;
    Informaessobreoregistro1: TMenuItem;
    Informaessobreoregistro2: TMenuItem;
    USUARIOSXUSUVA_EMAILX: TStringField;
	    procedure PopupActionBar_PDUPopup(Sender: TObject);
    	procedure PopupActionBar_PDGPopup(Sender: TObject);
	    procedure Action_USU_InsertExecute(Sender: TObject);
    	procedure Action_USU_EditExecute(Sender: TObject);
	    procedure Action_USU_DeleteExecute(Sender: TObject);
        procedure Action_GRU_InsertExecute(Sender: TObject);
        procedure Action_GRU_EditExecute(Sender: TObject);
        procedure Action_GRU_DeleteExecute(Sender: TObject);
    	procedure USUARIOSTB_SENHAGetText(Sender: TField; var Text: string; DisplayText: Boolean);
    	procedure USUARIOSTB_SENHASetText(Sender: TField; const Text: string);
    	procedure Action_GDU_InsertExecute(Sender: TObject);
    	procedure Action_GDU_DeleteExecute(Sender: TObject);
	    procedure Action_PDU_PDG_InsertExecute(Sender: TObject);
        procedure Action_EDS_InsertExecute(Sender: TObject);
        procedure Action_EDS_DeleteExecute(Sender: TObject);
        procedure Action_PDU_FullExecute(Sender: TObject);
        procedure Action_PDU_NoneExecute(Sender: TObject);
        procedure Action_PDU_DeleteExecute(Sender: TObject);
        procedure Action_PDG_FullExecute(Sender: TObject);
        procedure Action_PDG_NoneExecute(Sender: TObject);
        procedure Action_PDG_DeleteExecute(Sender: TObject);
    procedure Action_RecordInformationExecute(Sender: TObject);
  	private
    	{ Private declarations }
        function MyModule: TXXXForm_AdminModule;
    	procedure RemoveGroupFromUser;
   		procedure DoDestroyAvailableGroups(aSender: TObject);
    	procedure AddEntitiesToUserOrGroup;
	    procedure GiveFullUserPermission(const aAllow: Boolean);
    	procedure GiveFullGroupPermission(const aAllow: Boolean);
    protected
        procedure SetRefreshSQL(const aZQuery: TZQuery; const aDBAction: TDBAction; out aRefreshSQL: AnsiString); override;
        procedure DoBeforePost(aDataSet: TDataSet); override;
        procedure DoBeforeDelete(aDataSet: TDataSet); override;
        procedure DoDataChange(aSender: TObject; aField: TField); override;
		procedure DoStateChange(aSender: TObject); override;
  	public
    	{ Public declarations }
        procedure LocalizarPermissaoPorIdentificacaoETipo(const aLabeledEdit: TLabeledEdit; const aComboBox: TComboBox; aTipoDePermissao: Char);
        procedure LocalizarEntidadePorIdentificacaoETipo(const aLabeledEdit: TLabeledEdit; const aComboBox: TComboBox);
        procedure LocalizarGrupoPorNome(const aLabeledEdit: TLabeledEdit);
        procedure LocalizarUsuarioPorLogin(const aLabeledEdit: TLabeledEdit);
        procedure LocalizarUsuarioPorNome(const aLabeledEdit: TLabeledEdit);
    	procedure ToggleGroupModifyPermission(aModifyMode: TModifyMode);
        procedure ToggleUserModifyPermission(aModifyMode: TModifyMode);
	    procedure ToggleUserReadPermission;
    	procedure ToggleGroupReadPermission;
        function GetColumnByField(const aCFDBGrid: TCFDBGrid; const aField: TField): TColumn;
        procedure ShowAddEntityForm;
	    procedure DBButtonClick_USU(aDBButton: TDBButton; aComponentToFocusOnInsertAndEdit: TWinControl = nil);
		procedure DBButtonClick_GRU(aDBButton: TDBButton; aComponentToFocusOnInsertAndEdit: TWinControl = nil);
  	end;

implementation

uses
  	Math, StrUtils,

    UXXXForm_DialogTemplate, UXXXForm_AvailableGroups;

{$R *.dfm}

{ TODO 5 -ocarlos -cATUALIZAÇÃO : no form deste datamodule, altere todas as referencias para apontar para variaveis de banco x[mne.objname]x }
function TXXXDataModule_Administration.MyModule: TXXXForm_AdminModule;
begin
	Result := TXXXForm_AdminModule(Owner);
end;

procedure TXXXDataModule_Administration.LocalizarUsuarioPorNome(const aLabeledEdit: TLabeledEdit);
begin
    LocateFirstRecord(USUARIOS,TEdit(aLabeledEdit),'VA_NOME');
end;

procedure TXXXDataModule_Administration.LocalizarGrupoPorNome(const aLabeledEdit: TLabeledEdit);
begin
    LocateFirstRecord(GRUPOS,TEdit(aLabeledEdit),'VA_NOME');
end;

procedure TXXXDataModule_Administration.LocalizarUsuarioPorLogin(const aLabeledEdit: TLabeledEdit);
begin
    LocateFirstRecord(USUARIOS,TEdit(aLabeledEdit),'VA_LOGIN');
end;

procedure TXXXDataModule_Administration.LocalizarPermissaoPorIdentificacaoETipo(const aLabeledEdit: TLabeledEdit; const aComboBox: TComboBox; aTipoDePermissao: Char);
var
    PrimaryKey: Cardinal;
    VA_NOME: ShortString;
    TI_TIPO: Byte;
begin
    VA_NOME := '*' + aLabeledEdit.Text + '*';

    if aComboBox.ItemIndex > 0 then
    begin
        TI_TIPO := aComboBox.ItemIndex - 1;
        PrimaryKey := LocateFirstMatchedRecord(DataModuleMain.ZConnections[0].Connection
                                              ,[IfThen(aTipoDePermissao = 'U','PERMISSOESDOSUSUARIOS','PERMISSOESDOSGRUPOS'),'ENTIDADESDOSISTEMA']
                                              ,['IN_ENTIDADESDOSISTEMA_ID']
                                              ,['ENTIDADESDOSISTEMA.VA_NOME','ENTIDADESDOSISTEMA.TI_TIPO']
                                              ,[VA_NOME,TI_TIPO]
                                              ,[coLike,coEqual]
                                              ,[IfThen(aTipoDePermissao = 'U','PERMISSOESDOSUSUARIOS.IN_PERMISSOESDOSUSUARIOS_ID','PERMISSOESDOSGRUPOS.IN_PERMISSOESDOSGRUPOS_ID')]
                                              ,IfThen(aTipoDePermissao = 'U','PERMISSOESDOSUSUARIOS.IN_PERMISSOESDOSUSUARIOS_ID','PERMISSOESDOSGRUPOS.IN_PERMISSOESDOSGRUPOS_ID')).AsDWord;

    end
    else
    begin
        PrimaryKey := LocateFirstMatchedRecord(DataModuleMain.ZConnections[0].Connection
                                              ,[IfThen(aTipoDePermissao = 'U','PERMISSOESDOSUSUARIOS','PERMISSOESDOSGRUPOS'),'ENTIDADESDOSISTEMA']
                                              ,['IN_ENTIDADESDOSISTEMA_ID']
                                              ,['ENTIDADESDOSISTEMA.VA_NOME']
                                              ,[VA_NOME]
                                              ,[coLike]
                                              ,[IfThen(aTipoDePermissao = 'U','PERMISSOESDOSUSUARIOS.IN_PERMISSOESDOSUSUARIOS_ID','PERMISSOESDOSGRUPOS.IN_PERMISSOESDOSGRUPOS_ID')]
                                              ,IfThen(aTipoDePermissao = 'U','PERMISSOESDOSUSUARIOS.IN_PERMISSOESDOSUSUARIOS_ID','PERMISSOESDOSGRUPOS.IN_PERMISSOESDOSGRUPOS_ID')).AsDWord;
    end;

    if PrimaryKey = 0 then
    begin
        MessageBeep(MB_OK);
        aLabeledEdit.Color := clRed;
        aLabeledEdit.Font.Color := clWhite;
        aComboBox.Color := clRed;
        aComboBox.Font.Color := clWhite;
    end
    else
    begin
        aLabeledEdit.Color := clWindow;
        aLabeledEdit.Font.Color := clWindowText;
        aComboBox.Color := clWindow;
        aComboBox.Font.Color := clWindowText;

        if aTipoDePermissao = 'U' then
            PERMISSOESDOSUSUARIOS.Locate('IN_PERMISSOESDOSUSUARIOS_ID',PrimaryKey,[])
        else
            PERMISSOESDOSGRUPOS.Locate('IN_PERMISSOESDOSGRUPOS_ID',PrimaryKey,[])

    end;
end;

procedure TXXXDataModule_Administration.LocalizarEntidadePorIdentificacaoETipo(const aLabeledEdit: TLabeledEdit; const aComboBox: TComboBox);
var
    PrimaryKey: Cardinal;
    VA_NOME: ShortString;
    TI_TIPO: Byte;
begin
    VA_NOME := '*' + aLabeledEdit.Text + '*';

    if aComboBox.ItemIndex > 0 then
    begin
        TI_TIPO := aComboBox.ItemIndex - 1;
        PrimaryKey := LocateFirstMatchedRecord(DataModuleMain.ZConnections[0].Connection
                                              ,['ENTIDADESDOSISTEMA']
                                              ,[]
                                              ,['VA_NOME','TI_TIPO']
                                              ,[VA_NOME,TI_TIPO]
                                              ,[coLike,coEqual]
                                              ,['IN_ENTIDADESDOSISTEMA_ID']
                                              ,'IN_ENTIDADESDOSISTEMA_ID').AsDWord;

    end
    else
    begin
        PrimaryKey := LocateFirstMatchedRecord(DataModuleMain.ZConnections[0].Connection
                                              ,['ENTIDADESDOSISTEMA']
                                              ,[]
                                              ,['VA_NOME']
                                              ,[VA_NOME]
                                              ,[coLike]
                                              ,['IN_ENTIDADESDOSISTEMA_ID']
                                              ,'IN_ENTIDADESDOSISTEMA_ID').AsDWord;
    end;

    if PrimaryKey = 0 then
    begin
        MessageBeep(MB_OK);
        aLabeledEdit.Color := clRed;
        aLabeledEdit.Font.Color := clWhite;
        aComboBox.Color := clRed;
        aComboBox.Font.Color := clWhite;
    end
    else
    begin
        aLabeledEdit.Color := clWindow;
        aLabeledEdit.Font.Color := clWindowText;
        aComboBox.Color := clWindow;
        aComboBox.Font.Color := clWindowText;
        ENTIDADESDOSISTEMA.Locate('IN_ENTIDADESDOSISTEMA_ID',PrimaryKey,[]);
    end;
end;


//procedure TXXXDataModule_Administration.ShowAvailableGroupsForm;
//var
//	Form_DialogTemplateCreateParameters: UXXXForm_DialogTemplate.TCreateParameters;
//begin
//	ZeroMemory(@Form_DialogTemplateCreateParameters,SizeOf(UXXXForm_DialogTemplate.TCreateParameters));
//    with Form_DialogTemplateCreateParameters do
//    begin
//        AutoFree := True;
//        Modal := False;
//        Configurations := FConfigurations;
//        DataModule_BasicClass := TXXXDataModule_AddEntity;
//        DataModule_Basic := nil;
//        DataModuleMain := FDataModuleMain;
//    end;
//	TXXXForm_DialogTemplate.CreateDialog(Owner,Form_AddEntity,TXXXForm_AddEntity,Form_DialogTemplateCreateParameters);
//
////    TDataModule_AddEntity,nil,instancia,True,False,FConfigurations,FMainDataModule
//// dm class,dm instancia, form instancia, AutoFree, Modal, Config, Alpha DM
//end;

procedure TXXXDataModule_Administration.PopupActionBar_PDGPopup(Sender: TObject);
begin
  	inherited;
    if AddEntitiesForm <> nil then
    	Exit;

    Action_PDG_Full.Enabled := False;
    Action_PDG_None.Enabled := False;
   	Action_PDG_Delete.Enabled := False;

	DoBeforeEdit(PERMISSOESDOSGRUPOS);

    if (PERMISSOESDOSGRUPOS.RecordCount > 0)
       and not ((GRUPOS.FieldByName(Configurations.GroupTableKeyFieldName).AsInteger in ArrayOfByteToSet(GetUserGroups))
            	{ Não é possível alterar as permissões para as estidades
                listadas abaixo deste ponto }
                and ((PERMISSOESDOSGRUPOS.FieldByName('NOME').AsString = Configurations.AdministrativeActionName)
	                 or (PERMISSOESDOSGRUPOS.FieldByName('NOME').AsString = Configurations.AddEntityActionName)
                     or (PERMISSOESDOSGRUPOS.FieldByName('NOME').AsString = Configurations.AddEntityToUserOrGroupActionName)
                     or (PERMISSOESDOSGRUPOS.FieldByName('NOME').AsString = Configurations.GroupPermissionTableTableName)
                     or (PERMISSOESDOSGRUPOS.FieldByName('NOME').AsString = Configurations.GroupTableTableName)
                     or (PERMISSOESDOSGRUPOS.FieldByName('NOME').AsString = Configurations.EntitiesTableTableName))) then


    begin
    	SafeSetActionEnabled(Action_PDG_Delete,Action_PDG_Delete.Allowed);

    	if (PERMISSOESDOSGRUPOS.FieldByName('TIPO').AsString = 'Tabela')
        and not IsSystemTable(PERMISSOESDOSGRUPOS.FieldByName('NOME').AsString) then
        begin
            SafeSetActionEnabled(Action_PDG_Full,Action_PDG_Full.Allowed);
            SafeSetActionEnabled(Action_PDG_None,Action_PDG_None.Allowed);
        end;
    end;
end;

procedure TXXXDataModule_Administration.PopupActionBar_PDUPopup(Sender: TObject);
begin
  	inherited;
    if AddEntitiesForm <> nil then
    	Exit;

    Action_PDU_Full.Enabled := False;
    Action_PDU_None.Enabled := False;
   	Action_PDU_Delete.Enabled := False;

    DoBeforeEdit(PERMISSOESDOSUSUARIOS);
    
	if (PERMISSOESDOSUSUARIOS.RecordCount > 0)
       and not ((Configurations.AuthenticatedUser.Id = Cardinal(USUARIOS.FieldByName(Configurations.UserTableKeyFieldName).AsInteger))
            	{ Não é possível alterar as permissões para as estidades
                listadas abaixo deste ponto }
                and ((PERMISSOESDOSUSUARIOS.FieldByName('NOME').AsString = Configurations.AdministrativeActionName)
	                 or (PERMISSOESDOSUSUARIOS.FieldByName('NOME').AsString = Configurations.AddEntityActionName)
                     or (PERMISSOESDOSUSUARIOS.FieldByName('NOME').AsString = Configurations.AddEntityToUserOrGroupActionName)
                     or (PERMISSOESDOSUSUARIOS.FieldByName('NOME').AsString = Configurations.UserPermissionTableTableName)
                     or (PERMISSOESDOSUSUARIOS.FieldByName('NOME').AsString = Configurations.UserTableTableName)
                     or (PERMISSOESDOSUSUARIOS.FieldByName('NOME').AsString = Configurations.EntitiesTableTableName))) then
    begin
        SafeSetActionEnabled(Action_PDU_Delete,Action_PDU_Delete.Allowed);
        
        if (PERMISSOESDOSUSUARIOS.FieldByName('TIPO').AsString = 'Tabela')
        and not IsSystemTable(PERMISSOESDOSUSUARIOS.FieldByName('NOME').AsString) then
        begin
        	SafeSetActionEnabled(Action_PDU_Full,Action_PDU_Full.Allowed);
        	SafeSetActionEnabled(Action_PDU_None,Action_PDU_None.Allowed);
        end;
    end;
end;

procedure TXXXDataModule_Administration.ToggleUserReadPermission;
const
	SQL_UPDATE =
    'UPDATE X[PDU.PERMISSOESDOSUSUARIOS]X PDU'#13#10 +
    '  JOIN X[EDS.ENTIDADESDOSISTEMA]X EDS ON (PDU.X[PDU.IN_ENTIDADESDOSISTEMA_ID]X = EDS.X[EDS.IN_ENTIDADESDOSISTEMA_ID]X)'#13#10 +
    '   SET PDU.X[TI_LER]X = IF(PDU.X[TI_LER]X = 1,0,1)'#13#10 +
    '     , PDU.X[TI_INSERIR]X = IF(EDS.X[EDS.TI_TIPO]X = 0,IF(PDU.X[TI_LER]X = 0,0,PDU.X[TI_INSERIR]X),-1)'#13#10 +
    '     , PDU.X[TI_ALTERAR]X = IF(EDS.X[EDS.TI_TIPO]X = 0,IF(PDU.X[TI_LER]X = 0,0,PDU.X[TI_ALTERAR]X),-1)'#13#10 +
    '     , PDU.X[TI_EXCLUIR]X = IF(EDS.X[EDS.TI_TIPO]X = 0,IF(PDU.X[TI_LER]X = 0,0,PDU.X[TI_EXCLUIR]X),-1)'#13#10 +
    ' WHERE PDU.X[PDU.SM_USUARIOS_ID]X = %u'#13#10 +
    '   AND PDU.X[PDU.IN_ENTIDADESDOSISTEMA_ID]X = %u';
var
	BS: TBookmark;
begin
  	inherited;
   	DoBeforeEdit(PERMISSOESDOSUSUARIOS);
    { O Toggle só deve ser feito se houver algum registro listado, se o usuário
    selecionado não for usuário logado, se o item não for a ação administrativa
    e se o item não for uma tabela de sistema }
	if (PERMISSOESDOSUSUARIOS.RecordCount > 0)
       and not ((Configurations.AuthenticatedUser.Id = Cardinal(USUARIOS.FieldByName(Configurations.UserTableKeyFieldName).AsInteger))
                and ((PERMISSOESDOSUSUARIOS.FieldByName('NOME').AsString = Configurations.AdministrativeActionName)
                     or (PERMISSOESDOSUSUARIOS.FieldByName('NOME').AsString = Configurations.UserPermissionTableTableName))) then
    begin
    	if not IsSystemTable(PERMISSOESDOSUSUARIOS.FieldByName('NOME').AsString) then
        begin
            ExecuteQuery(DataModuleMain.ZConnections[0].Connection
                        ,Format(ReplaceSystemObjectNames(SQL_UPDATE)
                               ,[PERMISSOESDOSUSUARIOS.FieldByName(Configurations.UserPermissionTableUserFieldName).AsInteger
                                ,PERMISSOESDOSUSUARIOS.FieldByName(Configurations.UserPermissionTableEntityFieldName).AsInteger]));
            try
                BS := PERMISSOESDOSUSUARIOS.Bookmark;
                PERMISSOESDOSUSUARIOS.Refresh;
            finally
                PERMISSOESDOSUSUARIOS.Bookmark := BS;
            end;

        end;
    end;
end;

{camisas novas ana
polo azul listrada
camisa verde maracaja
camisa rosa
camisa marrom escura
tenis adidas
tenis preto e branco
bermuda preta nova
bermuda marrom nova
bermuda branca
seaway
bermudas "praia"
short praia + camiseta branca
camisa branca

sabonete
pasta de dente
perfume
desodorante
toalha
cuecas

}

procedure TXXXDataModule_Administration.USUARIOSTB_SENHAGetText(Sender: TField; var Text: string; DisplayText: Boolean);
begin
  inherited;
  if DisplayText then
  begin
    MyModule.DBEdit_USU_TB_SENHA.PasswordChar := #0;
 	Text := '<Senha indisponível>';
  end
  else
	MyModule.DBEdit_USU_TB_SENHA.PasswordChar := #248;
end;

procedure TXXXDataModule_Administration.USUARIOSTB_SENHASetText(Sender: TField; const Text: string);
begin
	inherited;
    Sender.AsString :=
    GetStringCheckSum(Text,[Configurations.PasswordCipherAlgorithm]);
end;

procedure TXXXDataModule_Administration.ToggleGroupReadPermission;
const
	SQL_UPDATE =
    'UPDATE X[PDG.PERMISSOESDOSGRUPOS]X PDG'#13#10 +
    '  JOIN X[EDS.ENTIDADESDOSISTEMA]X EDS ON (PDG.X[PDG.IN_ENTIDADESDOSISTEMA_ID]X = EDS.X[EDS.IN_ENTIDADESDOSISTEMA_ID]X)'#13#10 +
    '   SET PDG.X[TI_LER]X = IF(PDG.X[TI_LER]X = 1,0,1)'#13#10 +
    '     , PDG.X[TI_INSERIR]X = IF(EDS.X[EDS.TI_TIPO]X = 0,IF(PDG.X[TI_LER]X = 0,0,PDG.X[TI_INSERIR]X),-1)'#13#10 +
    '     , PDG.X[TI_ALTERAR]X = IF(EDS.X[EDS.TI_TIPO]X = 0,IF(PDG.X[TI_LER]X = 0,0,PDG.X[TI_ALTERAR]X),-1)'#13#10 +
    '     , PDG.X[TI_EXCLUIR]X = IF(EDS.X[EDS.TI_TIPO]X = 0,IF(PDG.X[TI_LER]X = 0,0,PDG.X[TI_EXCLUIR]X),-1)'#13#10 +
    ' WHERE PDG.X[PDG.TI_GRUPOS_ID]X = %u'#13#10 +
    '   AND PDG.X[PDG.IN_ENTIDADESDOSISTEMA_ID]X = %u';
var
	BS: TBookmark;
begin
  	inherited;
  	DoBeforeEdit(PERMISSOESDOSGRUPOS);
    { O Toggle só deve ser feito se houver algum registro listado, se o usuário
    selecionado não for usuário logado, se o item não for a ação administrativa
    e se o item não for uma tabela de sistema }
    if (PERMISSOESDOSGRUPOS.RecordCount > 0)
       and not ((GRUPOS.FieldByName(Configurations.GroupTableKeyFieldName).AsInteger in ArrayOfByteToSet(GetUserGroups))
                and ((PERMISSOESDOSGRUPOS.FieldByName('NOME').AsString = Configurations.AdministrativeActionName)
                     or (PERMISSOESDOSGRUPOS.FieldByName('NOME').AsString = Configurations.GroupPermissionTableTableName))) then
    begin
    	if not IsSystemTable(PERMISSOESDOSGRUPOS.FieldByName('NOME').AsString) then
        begin
            ExecuteQuery(DataModuleMain.ZConnections[0].Connection
                        ,Format(ReplaceSystemObjectNames(SQL_UPDATE)
                               ,[PERMISSOESDOSGRUPOS.FieldByName(Configurations.GroupPermissionTableGroupFieldName).AsInteger
                                ,PERMISSOESDOSGRUPOS.FieldByName(Configurations.GroupPermissionTableEntityFieldName).AsInteger]));
            try
                BS := PERMISSOESDOSGRUPOS.Bookmark;
                PERMISSOESDOSGRUPOS.Refresh;
            finally
                PERMISSOESDOSGRUPOS.Bookmark := BS;
            end;
        end;
    end;
end;

procedure TXXXDataModule_Administration.ToggleUserModifyPermission(aModifyMode: TModifyMode);
const
	SQL_UPDATE =
    'UPDATE X[PDU.PERMISSOESDOSUSUARIOS]X PDU'#13#10 +
    '  JOIN X[EDS.ENTIDADESDOSISTEMA]X EDS ON (PDU.X[PDU.IN_ENTIDADESDOSISTEMA_ID]X = EDS.X[EDS.IN_ENTIDADESDOSISTEMA_ID]X)'#13#10 +
    '   SET PDU.X[TI_LER]X = IF(PDU.%s = 0,1,PDU.X[TI_LER]X)'#13#10 +
    '     , PDU.%0:s = IF(EDS.X[EDS.TI_TIPO]X = 0,IF(PDU.%0:s = 0,1,0),-1)'#13#10 +
    ' WHERE PDU.X[PDU.SM_USUARIOS_ID]X = %u'#13#10 +
    '   AND PDU.X[PDU.IN_ENTIDADESDOSISTEMA_ID]X = %u';
var
	ModifyField: ShortString;
	BS: TBookmark;
begin
  	inherited;
	DoBeforeEdit(PERMISSOESDOSUSUARIOS);

	if (PERMISSOESDOSUSUARIOS.RecordCount > 0)
       and not ((Configurations.AuthenticatedUser.Id = Cardinal(USUARIOS.FieldByName(Configurations.UserTableKeyFieldName).AsInteger))
                and ((PERMISSOESDOSUSUARIOS.FieldByName('NOME').AsString = Configurations.AdministrativeActionName)
                     or (PERMISSOESDOSUSUARIOS.FieldByName('NOME').AsString = Configurations.UserPermissionTableTableName))) then
    begin
    	if PERMISSOESDOSUSUARIOS.FieldByName('TIPO').AsString = 'Tabela' then
        begin
            case aModifyMode of
                mmInsert: ModifyField := Configurations.PermissionTableInsertFieldName;
                mmUpdate: ModifyField := Configurations.PermissionTableUpdateFieldName;
                mmDelete: ModifyField := Configurations.PermissionTableDeleteFieldName;
            end;

            ExecuteQuery(DataModuleMain.ZConnections[0].Connection
                        ,Format(ReplaceSystemObjectNames(SQL_UPDATE)
                               ,[ModifyField
                                ,PERMISSOESDOSUSUARIOS.FieldByName(Configurations.UserPermissionTableUserFieldName).AsInteger
                                ,PERMISSOESDOSUSUARIOS.FieldByName(Configurations.UserPermissionTableEntityFieldName).AsInteger]));
            try
                BS := PERMISSOESDOSUSUARIOS.Bookmark;
                PERMISSOESDOSUSUARIOS.Refresh;
            finally
                PERMISSOESDOSUSUARIOS.Bookmark := BS;
            end;
        end;
    end;
end;

procedure TXXXDataModule_Administration.ToggleGroupModifyPermission(aModifyMode: TModifyMode);
const
	SQL_UPDATE =
    'UPDATE X[PDG.PERMISSOESDOSGRUPOS]X PDG'#13#10 +
    '  JOIN X[EDS.ENTIDADESDOSISTEMA]X EDS ON (PDG.X[PDG.IN_ENTIDADESDOSISTEMA_ID]X = EDS.X[EDS.IN_ENTIDADESDOSISTEMA_ID]X)'#13#10 +
    '   SET PDG.X[TI_LER]X = IF(PDG.%s = 0,1,PDG.X[TI_LER]X)'#13#10 +
    '     , PDG.%0:s = IF(EDS.X[EDS.TI_TIPO]X = 0,IF(PDG.%0:s = 0,1,0),-1)'#13#10 +
    ' WHERE PDG.X[PDG.TI_GRUPOS_ID]X = %u'#13#10 +
    '   AND PDG.X[PDG.IN_ENTIDADESDOSISTEMA_ID]X = %u';
var
	ModifyField: ShortString;
	BS: TBookmark;
begin
  	inherited;
	DoBeforeEdit(PERMISSOESDOSGRUPOS);

    if (PERMISSOESDOSGRUPOS.RecordCount > 0)
       and not ((GRUPOS.FieldByName(Configurations.GroupTableKeyFieldName).AsInteger in ArrayOfByteToSet(GetUserGroups))
                and ((PERMISSOESDOSGRUPOS.FieldByName('NOME').AsString = Configurations.AdministrativeActionName)
                     or (PERMISSOESDOSGRUPOS.FieldByName('NOME').AsString = Configurations.GroupPermissionTableTableName))) then
    begin
    	if PERMISSOESDOSGRUPOS.FieldByName('TIPO').AsString = 'Tabela' then
        begin
            case aModifyMode of
                mmInsert: ModifyField := Configurations.PermissionTableInsertFieldName;
                mmUpdate: ModifyField := Configurations.PermissionTableUpdateFieldName;
                mmDelete: ModifyField := Configurations.PermissionTableDeleteFieldName;
            end;

            ExecuteQuery(DataModuleMain.ZConnections[0].Connection
                        ,Format(ReplaceSystemObjectNames(SQL_UPDATE)
                               ,[ModifyField
                                ,PERMISSOESDOSGRUPOS.FieldByName(Configurations.GroupPermissionTableGroupFieldName).AsInteger
                                ,PERMISSOESDOSGRUPOS.FieldByName(Configurations.GroupPermissionTableEntityFieldName).AsInteger]));
            try
                BS := PERMISSOESDOSGRUPOS.Bookmark;
                PERMISSOESDOSGRUPOS.Refresh;
            finally
                PERMISSOESDOSGRUPOS.Bookmark := BS;
            end;
        end;
    end;
end;

procedure TXXXDataModule_Administration.GiveFullUserPermission(const aAllow: Boolean);
const
	SQL_UPDATE =
    'UPDATE X[PDU.PERMISSOESDOSUSUARIOS]X PDU'#13#10 +
    '  JOIN X[EDS.ENTIDADESDOSISTEMA]X EDS ON (PDU.X[PDU.IN_ENTIDADESDOSISTEMA_ID]X = EDS.X[EDS.IN_ENTIDADESDOSISTEMA_ID]X)'#13#10 +
    '   SET PDU.X[TI_LER]X = %d'#13#10 +
    '     , PDU.X[TI_INSERIR]X = IF(EDS.X[EDS.TI_TIPO]X = 0,%0:d,-1)'#13#10 +
    '     , PDU.X[TI_ALTERAR]X = IF(EDS.X[EDS.TI_TIPO]X = 0,%0:d,-1)'#13#10 +
    '     , PDU.X[TI_EXCLUIR]X = IF(EDS.X[EDS.TI_TIPO]X = 0,%0:d,-1)'#13#10 +
    ' WHERE PDU.X[PDU.SM_USUARIOS_ID]X = %u'#13#10 +
    '   AND PDU.X[PDU.IN_ENTIDADESDOSISTEMA_ID]X = %u';
var
    Permission: Byte;
	BS: TBookmark;
begin
	inherited;
	DoBeforeEdit(PERMISSOESDOSUSUARIOS);

	if (PERMISSOESDOSUSUARIOS.RecordCount > 0)
       and not ((Configurations.AuthenticatedUser.Id = Cardinal(USUARIOS.FieldByName(Configurations.UserTableKeyFieldName).AsInteger))
                and ((PERMISSOESDOSUSUARIOS.FieldByName('NOME').AsString = Configurations.AdministrativeActionName)
                     or (PERMISSOESDOSUSUARIOS.FieldByName('NOME').AsString = Configurations.UserPermissionTableTableName))) then
    begin
        if (PERMISSOESDOSUSUARIOS.FieldByName('TIPO').AsString = 'Tabela')
        and not IsSystemTable(PERMISSOESDOSUSUARIOS.FieldByName('NOME').AsString) then
        begin
            if aAllow then
                Permission := 1
            else
                Permission := 0;

            ExecuteQuery(DataModuleMain.ZConnections[0].Connection
                        ,Format(ReplaceSystemObjectNames(SQL_UPDATE)
                               ,[Permission
                                ,PERMISSOESDOSUSUARIOS.FieldByName(Configurations.UserPermissionTableUserFieldName).AsInteger
                                ,PERMISSOESDOSUSUARIOS.FieldByName(Configurations.UserPermissionTableEntityFieldName).AsInteger]));

            try
                BS := PERMISSOESDOSUSUARIOS.Bookmark;
                PERMISSOESDOSUSUARIOS.Refresh;
            finally
                PERMISSOESDOSUSUARIOS.Bookmark := BS;
            end;
        end;
    end;
end;

procedure TXXXDataModule_Administration.DBButtonClick_GRU(aDBButton: TDBButton; aComponentToFocusOnInsertAndEdit: TWinControl);
begin
	DBButtonClick(GRUPOS,aDBButton,aComponentToFocusOnInsertAndEdit);
end;

procedure TXXXDataModule_Administration.DBButtonClick_USU(aDBButton: TDBButton; aComponentToFocusOnInsertAndEdit: TWinControl);
begin
	DBButtonClick(USUARIOS,aDBButton,aComponentToFocusOnInsertAndEdit);
end;

procedure TXXXDataModule_Administration.DoBeforeDelete(aDataSet: TDataSet);
begin
	if aDataSet = USUARIOS then
    	CFDBValidationChecks_USU.ValidateBeforeDelete
    else if aDataSet = GRUPOS then
    	CFDBValidationChecks_GRU.ValidateBeforeDelete
    else if aDataSet = GRUPOSDOSUSUARIOS then
    	CFDBValidationChecks_GDU.ValidateBeforeDelete
    else if aDataSet = ENTIDADESDOSISTEMA then
		CFDBValidationChecks_EDS.ValidateBeforeDelete
    else if aDataSet = PERMISSOESDOSGRUPOS then
		CFDBValidationChecks_PDG.ValidateBeforeDelete
    else if aDataSet = PERMISSOESDOSUSUARIOS then
		CFDBValidationChecks_PDU.ValidateBeforeDelete;

  	inherited;
end;

procedure TXXXDataModule_Administration.DoBeforePost(aDataSet: TDataSet);
begin
	inherited; { Verifica permissão }

	if aDataSet = USUARIOS then
    	CFDBValidationChecks_USU.ValidateBeforePost
    else if aDataSet = GRUPOS then
    	CFDBValidationChecks_GRU.ValidateBeforePost
    else if aDataSet = GRUPOSDOSUSUARIOS then
    	CFDBValidationChecks_GDU.ValidateBeforePost
    else if aDataSet = ENTIDADESDOSISTEMA then
		CFDBValidationChecks_EDS.ValidateBeforePost
    else if aDataSet = PERMISSOESDOSGRUPOS then
		CFDBValidationChecks_PDG.ValidateBeforePost
    else if aDataSet = PERMISSOESDOSUSUARIOS then
		CFDBValidationChecks_PDU.ValidateBeforePost;
end;

procedure TXXXDataModule_Administration.DoDataChange(aSender: TObject; aField: TField);
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

    if aSender = DataSource_USU then
    begin
        SafeSetActionEnabled(MyModule.Action_USU_First,ButtonEnabled[0]);
        SafeSetActionEnabled(MyModule.Action_USU_Previous,ButtonEnabled[1]);
        SafeSetActionEnabled(MyModule.Action_USU_Next,ButtonEnabled[2]);
        SafeSetActionEnabled(MyModule.Action_USU_Last,ButtonEnabled[3]);
        SafeSetActionEnabled(Action_USU_Insert,ButtonEnabled[4] and Action_USU_Insert.Allowed);
        SafeSetActionEnabled(Action_USU_Delete,ButtonEnabled[5] and Action_USU_Delete.Allowed);
        SafeSetActionEnabled(Action_USU_Edit,ButtonEnabled[6] and Action_USU_Edit.Allowed);
        SafeSetActionEnabled(MyModule.Action_USU_Post,ButtonEnabled[7]);
        SafeSetActionEnabled(MyModule.Action_USU_Cancel,ButtonEnabled[8]);
        SafeSetActionEnabled(MyModule.Action_USU_Refresh,ButtonEnabled[9]);

//		TBDOForm_EquipamentosEFamilias(Owner).Label_EQP_EquipamentosListadosValor.Caption := FormatFloat('###,###,##0',DataSource_EQP.DataSet.RecordCount);
    end
    else if aSender = DataSource_GRU then
    begin
        SafeSetActionEnabled(MyModule.Action_GRU_First,ButtonEnabled[0]);
        SafeSetActionEnabled(MyModule.Action_GRU_Previous,ButtonEnabled[1]);
        SafeSetActionEnabled(MyModule.Action_GRU_Next,ButtonEnabled[2]);
        SafeSetActionEnabled(MyModule.Action_GRU_Last,ButtonEnabled[3]);
        SafeSetActionEnabled(Action_GRU_Insert,ButtonEnabled[4] and Action_GRU_Insert.Allowed);
        SafeSetActionEnabled(Action_GRU_Delete,ButtonEnabled[5] and Action_GRU_Delete.Allowed);
        SafeSetActionEnabled(Action_GRU_Edit,ButtonEnabled[6] and Action_GRU_Edit.Allowed);
        SafeSetActionEnabled(MyModule.Action_GRU_Post,ButtonEnabled[7]);
        SafeSetActionEnabled(MyModule.Action_GRU_Cancel,ButtonEnabled[8]);
        SafeSetActionEnabled(MyModule.Action_GRU_Refresh,ButtonEnabled[9]);

//		TBDOForm_EquipamentosEFamilias(Owner).Label_FAM_FamiliasListadasValor.Caption := FormatFloat('###,###,##0',DataSource_FAM.DataSet.RecordCount);
    end
    else if (aSender = DataSource_EDS) and (Action_EDS_Delete.Tag = 0) then
    begin
        SafeSetActionEnabled(Action_EDS_Delete,(MyModule.CFDBGrid_EDS.SelectedRows.Count > 0) and Action_EDS_Delete.Allowed);
		SafeSetActionEnabled(Action_PDU_PDG_Insert,(MyModule.CFDBGrid_EDS.SelectedRows.Count > 0) and Action_PDU_PDG_Insert.Allowed);
        Action_EDS_Delete.Tag := 1;
    end
	else if (aSender = DataSource_GDU) and (Action_GDU_Delete.Tag = 0) then
    begin
        SafeSetActionEnabled(Action_GDU_Delete,(MyModule.CFDBGrid_GDU.SelectedRows.Count > 0) and Action_GDU_Delete.Allowed);
        Action_GDU_Delete.Tag := 1;
    end;
end;

procedure TXXXDataModule_Administration.DoStateChange(aSender: TObject);
begin
  	inherited;
   	MyModule.DBEdit_USU_TB_SENHA.Enabled := USUARIOS.State = dsInsert;
end;

function TXXXDataModule_Administration.GetColumnByField(const aCFDBGrid: TCFDBGrid; const aField: TField): TColumn;
var
	i: Byte;
begin
	Result := nil;
	for i := 0 to Pred(aCFDBGrid.Columns.Count) do
    	if aCFDBGrid.Columns[i].Field = aField then
        begin
        	Result := aCFDBGrid.Columns[i];
            Break;
        end;
end;

procedure TXXXDataModule_Administration.GiveFullGroupPermission(const aAllow: Boolean);
const
	SQL_UPDATE =
    'UPDATE X[PDG.PERMISSOESDOSGRUPOS]X PDG'#13#10 +
    '  JOIN X[EDS.ENTIDADESDOSISTEMA]X EDS ON (PDG.X[PDG.IN_ENTIDADESDOSISTEMA_ID]X = EDS.X[EDS.IN_ENTIDADESDOSISTEMA_ID]X)'#13#10 +
    '   SET PDG.X[TI_LER]X = %d'#13#10 +
    '     , PDG.X[TI_INSERIR]X = IF(EDS.X[EDS.TI_TIPO]X = 0,%0:d,-1)'#13#10 +
    '     , PDG.X[TI_ALTERAR]X = IF(EDS.X[EDS.TI_TIPO]X = 0,%0:d,-1)'#13#10 +
    '     , PDG.X[TI_EXCLUIR]X = IF(EDS.X[EDS.TI_TIPO]X = 0,%0:d,-1)'#13#10 +
    ' WHERE PDG.X[PDG.TI_GRUPOS_ID]X = %u'#13#10 +
    '   AND PDG.X[PDG.IN_ENTIDADESDOSISTEMA_ID]X = %u';
var
    Permission: Byte;
	BS: TBookmark;
begin
	inherited;
	DoBeforeEdit(PERMISSOESDOSGRUPOS);

    if (PERMISSOESDOSGRUPOS.RecordCount > 0)
       and not ((GRUPOS.FieldByName(Configurations.GroupTableKeyFieldName).AsInteger in ArrayOfByteToSet(GetUserGroups))
                and ((PERMISSOESDOSGRUPOS.FieldByName('NOME').AsString = Configurations.AdministrativeActionName)
                     or (PERMISSOESDOSGRUPOS.FieldByName('NOME').AsString = Configurations.GroupPermissionTableTableName))) then
    begin
    	if (PERMISSOESDOSGRUPOS.FieldByName('TIPO').AsString = 'Tabela')
        and not IsSystemTable(PERMISSOESDOSGRUPOS.FieldByName('NOME').AsString) then
        begin
            if aAllow then
                Permission := 1
            else
                Permission := 0;

            ExecuteQuery(DataModuleMain.ZConnections[0].Connection
                        ,Format(ReplaceSystemObjectNames(SQL_UPDATE)
                               ,[Permission
                                ,PERMISSOESDOSGRUPOS.FieldByName(Configurations.GroupPermissionTableGroupFieldName).AsInteger
                                ,PERMISSOESDOSGRUPOS.FieldByName(Configurations.GroupPermissionTableEntityFieldName).AsInteger]));

            try
                BS := PERMISSOESDOSGRUPOS.Bookmark;
                PERMISSOESDOSGRUPOS.Refresh;
            finally
                PERMISSOESDOSGRUPOS.Bookmark := BS;
            end;
        end;
    end;
end;

procedure TXXXDataModule_Administration.Action_EDS_DeleteExecute(Sender: TObject);
begin
  	inherited;
	if MyModule.CFDBGrid_EDS.SelectedRows.Count > 1 then
  	begin
		Application.MessageBox('Por motivo de segurança, a fim de evitar exclusões acidentais, não é possível excluir mais de um registro por vez. Por favor selecione apenas um registro para poder excluí-lo', 'Múltiplos registros selecionados', MB_ICONWARNING or MB_OK);
    	Exit;
  	end;

    if ENTIDADESDOSISTEMA.FieldByName(Configurations.EntitiesTableTypeFieldName).AsInteger = 0 then
		Application.MessageBox('Não é possível remover entidades do tipo "Tabela" da lista de entidades do sistema. Apenas entidades do tipo "Ação" podem ser removidas', 'Remoção não permitida', MB_ICONERROR or MB_OK)
	else
		if ENTIDADESDOSISTEMA.FieldByName(Configurations.EntitiesTableNameFieldName).AsString = Configurations.AdministrativeActionName then
        	Application.MessageBox('A entidade administração de permissões (módulo de permissões) não pode ser excluída pois ela é necessária para a aplicação de permissões de usuários e grupos','Remoção não permitida', MB_ICONERROR or MB_OK)
		else
        begin
        	ENTIDADESDOSISTEMA.Delete;
            { TODO -oCarlos Feitoza -cPOG : Ao excluir os registros
            selecionados, SelectedRows ainda mantém bookmarks para os registros
            selecionados que foram excluídos, o que está errado... O comando
            abaixo garante que ao se excluir, não haja mais nenhum registro
            selecionado. Isso deverá ser retirado caso a nova implementação do
            CFDBGrid resolver o problema por si só }
            MyModule.CFDBGrid_EDS.SelectedRows.Clear;
            { Garante que o status de habilitação dos botões se mantenha correto }
            MyModule.CFDBGrid_EDSMultiSelect(Sender);

            PERMISSOESDOSUSUARIOS.Refresh;
            PERMISSOESDOSGRUPOS.Refresh;
        end;
end;

procedure TXXXDataModule_Administration.Action_EDS_InsertExecute(Sender: TObject);
begin
  	inherited;
	ShowAddEntityForm;
end;

procedure TXXXDataModule_Administration.Action_GDU_DeleteExecute(Sender: TObject);
begin
    inherited;
	RemoveGroupFromUser;
    { O comando abaixo garante que o status do botão seja mantido correto
    (habilitado ou desabilitado) }
    MyModule.CFDBGrid_GDUMultiSelect(Sender);
end;

procedure TXXXDataModule_Administration.DoDestroyAvailableGroups(aSender: TObject);
const     
    GDU_INSERT_HEADER =
    'INSERT IGNORE INTO'#13#10 +
    '       X[GDU.GRUPOSDOSUSUARIOS]X (X[GDU.SM_USUARIOS_ID]X,X[GDU.TI_GRUPOS_ID]X)'#13#10 +
    'VALUES'#13#10;
    GDU_INSERT_TEMPLATE =
	'       (%u,%u)';
var
	SQL: String;
    i: Word;
	XXXForm_AvailableGroups: TXXXForm_AvailableGroups;
begin
	XXXForm_AvailableGroups := TXXXForm_AvailableGroups(aSender);

	if XXXForm_AvailableGroups.ModalResult = mrOk then
    begin
	    SQL := ReplaceSystemObjectNames(GDU_INSERT_HEADER);

        if XXXForm_AvailableGroups.CFDBGrid_GRU.SelectedRows.Count > 0 then
        begin
    	   	if XXXForm_AvailableGroups.CFDBGrid_GRU.SelectedRows.Count > High(Word) then
            	Application.MessageBox(PChar('A quantidade de grupos selecionados excede o limite permitido de ' + IntToStr(High(Word)) + #13#10'Por favor selecione menos grupos'),'Não é possível atribuir grupos',MB_ICONERROR)
            else
            begin
    	        for i := 0 to Pred(XXXForm_AvailableGroups.CFDBGrid_GRU.SelectedRows.Count) do
                begin
                    GRUPOS.Bookmark := XXXForm_AvailableGroups.CFDBGrid_GRU.SelectedRows[i];
                    SQL := SQL + Format(GDU_INSERT_TEMPLATE,[USUARIOS.FieldByName(Configurations.UserTableKeyFieldName).AsInteger,GRUPOS.FieldByName(Configurations.GroupTableKeyFieldName).AsInteger]);

                    if i < Pred(XXXForm_AvailableGroups.CFDBGrid_GRU.SelectedRows.Count) then
                        SQL := SQL + ','#13#10;
                end;

    	        ExecuteQuery(DataModuleMain.ZConnections[0].Connection,SQL);
                GRUPOSDOSUSUARIOS.Refresh;
            end;
        end;

    end;
end;

procedure TXXXDataModule_Administration.Action_GDU_InsertExecute(Sender: TObject);
var
	CreateParameters: TDialogCreateParameters;
    XXXForm_AvailableGroups: TXXXForm_AvailableGroups;
begin
	inherited;
    DoBeforeInsert(GRUPOSDOSUSUARIOS);

    XXXForm_AvailableGroups := nil;

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
        OnFormDestroy := DoDestroyAvailableGroups;
    end;

	TXXXForm_DialogTemplate.CreateDialog(Owner,XXXForm_AvailableGroups,TXXXForm_AvailableGroups,CreateParameters);
end;

procedure TXXXDataModule_Administration.Action_GRU_DeleteExecute(Sender: TObject);
begin
  	inherited;
    DBButtonClick_GRU(dbbDelete);
    PERMISSOESDOSGRUPOS.Refresh;
    GRUPOSDOSUSUARIOS.Refresh;
end;

procedure TXXXDataModule_Administration.Action_GRU_EditExecute(Sender: TObject);
begin
  	inherited;
    DBButtonClick_GRU(dbbEdit,MyModule.DBEdit_GRU_VA_NOME);
end;

procedure TXXXDataModule_Administration.Action_GRU_InsertExecute(Sender: TObject);
begin
  	inherited;
    DBButtonClick_GRU(dbbInsert,MyModule.DBEdit_GRU_VA_NOME);
end;

procedure TXXXDataModule_Administration.Action_PDG_DeleteExecute(Sender: TObject);
begin
  	inherited;
    if (PERMISSOESDOSGRUPOS.RecordCount > 0)
       and not ((GRUPOS.FieldByName(Configurations.GroupTableKeyFieldName).AsInteger in ArrayOfByteToSet(GetUserGroups))
                and ((PERMISSOESDOSGRUPOS.FieldByName('NOME').AsString = Configurations.AdministrativeActionName)
                     or (PERMISSOESDOSGRUPOS.FieldByName('NOME').AsString = Configurations.GroupPermissionTableTableName))) then
    begin
	    PERMISSOESDOSGRUPOS.Delete;
    end;
end;

procedure TXXXDataModule_Administration.Action_PDG_FullExecute(Sender: TObject);
begin
  	inherited;
    GiveFullGroupPermission(True);
end;

procedure TXXXDataModule_Administration.Action_PDG_NoneExecute(Sender: TObject);
begin
  	inherited;
    GiveFullGroupPermission(False);
end;

procedure TXXXDataModule_Administration.Action_PDU_DeleteExecute(Sender: TObject);
begin
  	inherited;
	if (PERMISSOESDOSUSUARIOS.RecordCount > 0)
       and not ((Configurations.AuthenticatedUser.Id = Cardinal(USUARIOS.FieldByName(Configurations.UserTableKeyFieldName).AsInteger))
                and ((PERMISSOESDOSUSUARIOS.FieldByName('NOME').AsString = Configurations.AdministrativeActionName)
                     or (PERMISSOESDOSUSUARIOS.FieldByName('NOME').AsString = Configurations.UserPermissionTableTableName))) then
    begin
	    PERMISSOESDOSUSUARIOS.Delete;
    end;
end;

procedure TXXXDataModule_Administration.Action_PDU_FullExecute(Sender: TObject);
begin
  	inherited;
    GiveFullUserPermission(True);
end;

procedure TXXXDataModule_Administration.Action_PDU_NoneExecute(Sender: TObject);
begin
  	inherited;
    GiveFullUserPermission(False);
end;

procedure TXXXDataModule_Administration.Action_PDU_PDG_InsertExecute(Sender: TObject);
begin
  	inherited;
  	AddEntitiesToUserOrGroup
end;

procedure TXXXDataModule_Administration.Action_RecordInformationExecute(Sender: TObject);
begin
    inherited;

    if TMenuItem(Action_RecordInformation.ActionComponent).GetParentMenu = PopupActionBar_RecordInformation then
    begin
        if TCFDBGrid(PopupActionBar_RecordInformation.PopupComponent).DataSource.DataSet = USUARIOS then
            ShowRecordInformationForm(DataModuleMain.ZConnections.ByName['ZConnection_BDO'].Connection
                                     ,'USUARIOS'
                                     ,'SM_USUARIOS_ID'
                                     ,USUARIOSSM_USUARIOS_ID.AsInteger)
        else if TCFDBGrid(PopupActionBar_RecordInformation.PopupComponent).DataSource.DataSet = GRUPOS then
            ShowRecordInformationForm(DataModuleMain.ZConnections.ByName['ZConnection_BDO'].Connection
                                     ,'GRUPOS'
                                     ,'TI_GRUPOS_ID'
                                     ,GRUPOSTI_GRUPOS_ID.AsInteger)
        else if TCFDBGrid(PopupActionBar_RecordInformation.PopupComponent).DataSource.DataSet = GRUPOSDOSUSUARIOS then
            ShowRecordInformationForm(DataModuleMain.ZConnections.ByName['ZConnection_BDO'].Connection
                                     ,'GRUPOSDOSUSUARIOS'
                                     ,'MI_GRUPOSDOSUSUARIOS_ID'
                                     ,GRUPOSDOSUSUARIOSMI_GRUPOSDOSUSUARIOS_ID.AsInteger)
        else if TCFDBGrid(PopupActionBar_RecordInformation.PopupComponent).DataSource.DataSet = ENTIDADESDOSISTEMA then
            ShowRecordInformationForm(DataModuleMain.ZConnections.ByName['ZConnection_BDO'].Connection
                                     ,'ENTIDADESDOSISTEMA'
                                     ,'IN_ENTIDADESDOSISTEMA_ID'
                                     ,ENTIDADESDOSISTEMAIN_ENTIDADESDOSISTEMA_ID.AsInteger);
        end
    else if TMenuItem(Action_RecordInformation.ActionComponent).GetParentMenu = PopupActionBar_PDU then
        ShowRecordInformationForm(DataModuleMain.ZConnections[0].Connection
                                 ,'PERMISSOESDOSUSUARIOS'
                                 ,'IN_PERMISSOESDOSUSUARIOS_ID'
                                 ,PERMISSOESDOSUSUARIOSIN_PERMISSOESDOSUSUARIOS_ID.AsInteger)
    else if TMenuItem(Action_RecordInformation.ActionComponent).GetParentMenu = PopupActionBar_PDG then
            ShowRecordInformationForm(DataModuleMain.ZConnections[0].Connection
                                     ,'PERMISSOESDOSGRUPOS'
                                     ,'IN_PERMISSOESDOSGRUPOS_ID'
                                     ,PERMISSOESDOSGRUPOSIN_PERMISSOESDOSGRUPOS_ID.AsInteger);
end;

procedure TXXXDataModule_Administration.Action_USU_DeleteExecute(Sender: TObject);
begin
  	inherited;
    DBButtonClick_USU(dbbDelete);
    PERMISSOESDOSUSUARIOS.Refresh;
    GRUPOSDOSUSUARIOS.Refresh;
end;

procedure TXXXDataModule_Administration.Action_USU_EditExecute(Sender: TObject);
begin
  	inherited;
    DBButtonClick_USU(dbbEdit,MyModule.DBEdit_USU_VA_NOME);
end;

procedure TXXXDataModule_Administration.Action_USU_InsertExecute(Sender: TObject);
begin
  	inherited;
    DBButtonClick_USU(dbbInsert,MyModule.DBEdit_USU_VA_NOME);
end;

procedure TXXXDataModule_Administration.AddEntitiesToUserOrGroup;
const
    INSERT_HEADER =
    'INSERT IGNORE INTO %s                    (%s'#13#10 +
    '                                         ,%s'#13#10 +
    '                                         ,X[TI_LER]X'#13#10 +
    '                                         ,X[TI_INSERIR]X'#13#10 +
    '                                         ,X[TI_ALTERAR]X'#13#10 +
    '                                         ,X[TI_EXCLUIR]X)'#13#10 +
    'VALUES ';

    INSERT_TEMPLATE = '(%u,%u,%u,%d,%d,%d)';
var
	i: Word;
    SQL: String;
    GruUsuKey: Word;
    PduPdgDataSet: TZAbstractRODataset;
begin
	inherited;
    PduPdgDataSet := nil;
    GruUsuKey := 0;
	case MyModule.PageControl_USU_GRU_Consultar.ActivePageIndex of
    	0: begin { Adicionar Entidades Para o Usuário }
        	SQL := Format(ReplaceSystemObjectNames(INSERT_HEADER)
                         ,[Configurations.UserPermissionTableTableName
                          ,Configurations.UserPermissionTableUserFieldName
                          ,Configurations.UserPermissionTableEntityFieldName]);
            GruUsuKey := USUARIOS.FieldByName(Configurations.UserTableKeyFieldName).AsInteger;
            PduPdgDataSet := PERMISSOESDOSUSUARIOS;
        end;
    	1: begin { Adicionar Entidades Para o Grupo }
        	SQL := Format(ReplaceSystemObjectNames(INSERT_HEADER)
                         ,[Configurations.GroupPermissionTableTableName
                          ,Configurations.GroupPermissionTableGroupFieldName
                          ,Configurations.GroupPermissionTableEntityFieldName]);
            GruUsuKey := GRUPOS.FieldByName(Configurations.GroupTableKeyFieldName).AsInteger;
            PduPdgDataSet := PERMISSOESDOSGRUPOS;
        end;
    end;

    DoBeforeInsert(PduPdgDataSet);

    if MyModule.CFDBGrid_EDS.SelectedRows.Count > 0 then
    begin
        if MyModule.CFDBGrid_EDS.SelectedRows.Count > High(Word) then
            MessageBox(MyModule.Handle,PChar('A quantidade de entidades selecionadas excede o limite permitido de ' + IntToStr(High(Word)) + #13#10'Por favor selecione menos ítens'),'Não é possível atribuir entidades',MB_ICONERROR)
        else
        begin
            for i := 0 to Pred(MyModule.CFDBGrid_EDS.SelectedRows.Count) do
            begin
                ENTIDADESDOSISTEMA.Bookmark := MyModule.CFDBGrid_EDS.SelectedRows[i];

                SQL := SQL + Format(INSERT_TEMPLATE
                                   ,[GruUsuKey
                                    ,ENTIDADESDOSISTEMA.FieldByName(Configurations.EntitiesTableKeyFieldName).AsInteger
                                    ,IfThen((ENTIDADESDOSISTEMA.FieldByName(Configurations.EntitiesTableNameFieldName).AsString = Configurations.AdministrativeActionName) or IsSystemTable(ENTIDADESDOSISTEMA.FieldByName(Configurations.EntitiesTableNameFieldName).AsString),1,0)
                                    ,-ENTIDADESDOSISTEMA.FieldByName(Configurations.EntitiesTableTypeFieldName).AsInteger
                                    ,-ENTIDADESDOSISTEMA.FieldByName(Configurations.EntitiesTableTypeFieldName).AsInteger
                                    ,-ENTIDADESDOSISTEMA.FieldByName(Configurations.EntitiesTableTypeFieldName).AsInteger]);

                if i < Pred(MyModule.CFDBGrid_EDS.SelectedRows.Count) then
                    SQL := SQL + ','#13#10;
            end;

            ExecuteQuery(DataModuleMain.ZConnections[0].Connection,SQL);
            PduPdgDataSet.Refresh;
        end;
    end
    else
        MessageBox(MyModule.Handle,'Não há nenhuma entidade selecionada. Não é possível atribuir entidades','Não é possível atribuir entidades',MB_ICONERROR);
end;

procedure TXXXDataModule_Administration.RemoveGroupFromUser;
const
    GDU_DELETE_TEMPLATE =
    'DELETE FROM X[GDU.GRUPOSDOSUSUARIOS]X'#13#10 +
    'WHERE X[GDU.MI_GRUPOSDOSUSUARIOS_ID]X IN (%s)';
var
	i: Word;
	KeysToDelete: String;
begin
    inherited;

	if MyModule.CFDBGrid_GDU.SelectedRows.Count > 0 then
    begin
	    DoBeforeDelete(GRUPOSDOSUSUARIOS);

    	if MyModule.CFDBGrid_GDU.SelectedRows.Count > High(Word) then
        	MessageBox(MyModule.Handle,PChar('A quantidade de grupos selecionados excede o limite permitido de ' + IntToStr(High(Word)) + #13#10'Por favor selecione menos ítens'),'Não é possível remover grupos',MB_ICONERROR)
        else
        begin
        	KeysToDelete := '';
            for i := 0 to Pred(MyModule.CFDBGrid_GDU.SelectedRows.Count) do
            begin
                GRUPOSDOSUSUARIOS.Bookmark := MyModule.CFDBGrid_GDU.SelectedRows[i];

                KeysToDelete := KeysToDelete + GRUPOSDOSUSUARIOS.FieldByName(Configurations.UserGroupsTableKeyFieldName).AsString;

                if i < Pred(MyModule.CFDBGrid_GDU.SelectedRows.Count) then
                    KeysToDelete := KeysToDelete + ',';
            end;
            ExecuteQuery(DataModuleMain.ZConnections[0].Connection,Format(ReplaceSystemObjectNames(GDU_DELETE_TEMPLATE),[KeysToDelete]));
            GRUPOSDOSUSUARIOS.Refresh;
            { TODO -oCarlos Feitoza -cPOG : Ao excluir os registros
            selecionados, SelectedRows ainda mantém bookmarks para os registros
            selecionados que foram excluídos, o que está errado... O comando
            abaixo garante que ao se excluir, não haja mais nenhum registro
            selecionado. Isso deverá ser retirado caso a nova implementação do
            CFDBGrid resolver o problema por si só }
            MyModule.CFDBGrid_GDU.SelectedRows.Clear;
        end;
    end;
end;

procedure TXXXDataModule_Administration.SetRefreshSQL(const aZQuery: TZQuery; const aDBAction: TDBAction; out aRefreshSQL: AnsiString);
begin
    inherited;
    if aZQuery = ENTIDADESDOSISTEMA then
        case aDBAction of
            dbaBeforeInsert: aRefreshSQL :=
                             ReplaceSystemObjectNames('SELECT X[EDS.IN_ENTIDADESDOSISTEMA_ID]X'#13#10 +
                                                      '  FROM X[EDS.ENTIDADESDOSISTEMA]X'#13#10 +
                                                      ' WHERE X[EDS.IN_ENTIDADESDOSISTEMA_ID]X = LAST_INSERT_ID()');
            dbaBeforeEdit: aRefreshSQL := '';
        end
    else if aZQuery = PERMISSOESDOSUSUARIOS then
        case aDBAction of
            dbaBeforeInsert: aRefreshSQL :=
                             ReplaceSystemObjectNames('SELECT X[PDU.IN_PERMISSOESDOSUSUARIOS_ID]X'#13#10 +
                                                      '  FROM X[PDU.PERMISSOESDOSUSUARIOS]X'#13#10 +
                                                      ' WHERE X[PDU.IN_PERMISSOESDOSUSUARIOS_ID]X = LAST_INSERT_ID()');
            dbaBeforeEdit: aRefreshSQL := '';
        end
    else if aZQuery = PERMISSOESDOSGRUPOS then
        case aDBAction of
           dbaBeforeInsert: aRefreshSQL :=
                            ReplaceSystemObjectNames('SELECT X[PDG.IN_PERMISSOESDOSGRUPOS_ID]X'#13#10 +
                                                     '  FROM X[PDG.PERMISSOESDOSGRUPOS]X'#13#10 +
                                                     ' WHERE X[PDG.IN_PERMISSOESDOSGRUPOS_ID]X = LAST_INSERT_ID()');
           dbaBeforeEdit: aRefreshSQL := '';
        end

    else if aZQuery = USUARIOS then
        case aDBAction of
            dbaBeforeInsert: aRefreshSQL :=
                             ReplaceSystemObjectNames('SELECT X[USU.SM_USUARIOS_ID]X'#13#10 +
                                                      '     , DATE_FORMAT(DT_DATAEHORADACRIACAO,''%d/%m/%Y às %h:%i:%s'') AS DATAEHORADOCADASTRO'#13#10 +
                                                      '  FROM X[USU.USUARIOS]X'#13#10 +
                                                      ' WHERE X[USU.SM_USUARIOS_ID]X = LAST_INSERT_ID()');
            dbaBeforeEdit: aRefreshSQL := '';
        end
    else if aZQuery = GRUPOS then
        case aDBAction of
            dbaBeforeInsert: aRefreshSQL :=
                             ReplaceSystemObjectNames('SELECT X[GRU.TI_GRUPOS_ID]X'#13#10 +
                                                      '  FROM X[GRU.GRUPOS]X'#13#10 +
                                                      ' WHERE X[GRU.TI_GRUPOS_ID]X = LAST_INSERT_ID()');
            dbaBeforeEdit: aRefreshSQL := '';
        end
    else if aZQuery = GRUPOSDOSUSUARIOS then
        case aDBAction of
            dbaBeforeInsert: aRefreshSQL :=
                             ReplaceSystemObjectNames('SELECT X[GDU.MI_GRUPOSDOSUSUARIOS_ID]X'#13#10 +
                                                      '  FROM X[GDU.GRUPOSDOSUSUARIOS]X'#13#10 +
                                                      ' WHERE X[GDU.MI_GRUPOSDOSUSUARIOS_ID]X = LAST_INSERT_ID()');
            dbaBeforeEdit: aRefreshSQL := '';
        end;
end;

procedure TXXXDataModule_Administration.ShowAddEntityForm;
begin
	DoBeforeInsert(ENTIDADESDOSISTEMA);
	inherited ShowAddEntityForm;
end;

end.
