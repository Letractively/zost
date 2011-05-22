{ Este datamodule contém as regras de negócio da aplicação e que são
compartilhadas por toda ela. a partir deste DM é herdado o DM que contém o
componente Zconnection unico da aplicação }
unit UBDODataModule;

interface

uses
	{ VCL }
  	Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
    DB, ActnList, ImgList, ComCtrls, StdCtrls,
    { COMPONENTES }
    ZConnection, ZDataset,
    { FRAMEWORK }
  	UXXXDataModule, UXXXTypesConstantsAndClasses,
    { APLICAÇÃO }
    UBDOForm_AutoSync;

type
  	TBDODataModule = class(TXXXDataModule)
    	ImageList_Local: TImageList;
        ImageList_PopUps: TImageList;
        Action_RecordInformation: TAction;
  	private
    	{ Private declarations }
        Form_AutoSync: TBDOForm_AutoSync;
    protected
        procedure ExibirGeradorDeProposta(const aPropostaID: Cardinal);
        procedure ExibirGeradorDeRelatorioDeEquipamentos;
        procedure ExibirGeradorDeRelatorioDeFamilias;
        procedure ExibirGeradorDeRelatorioDeObras;
        procedure ExibirGeradorDeRelatorioDePropostas;
        procedure ExibirGeradorDeRelatorioDeJustificativasDasObras;
        procedure ExibirInformacoesDaProposta(const aPropostaID: Cardinal);
        procedure ExibirInformacoesDoEquipamento(const aMes, aAno, aEquipamento, aVoltagem: Cardinal);

        function SituacaoJustificavel(const aTI_SITUACOES_ID: Byte): Boolean;
        function SimboloMonetario(const aCodigo: Byte): AnsiString;
        function CodigoDaProposta(const aIN_PROPOSTAS_ID: Cardinal): AnsiString;
        function ValorDaProposta(const aIN_PROPOSTAS_ID: Cardinal; aSubTotal, aAutoDetectarCotacoes: Boolean; const aCotacoes: AnsiString): Currency;
//        function ReajusteDaProposta(const aIN_PROPOSTAS_ID: Cardinal): Double;
        function ValorDaObra(const aIN_OBRAS_ID: Cardinal; aAutoDetectarCotacoes: Boolean; const aCotacoes: AnsiString): Currency;
        function QuantidadeDePropostas(const aIN_OBRAS_ID: Cardinal): Byte;
        function PropostaPadrao(const aIN_OBRAS_ID: Cardinal): Cardinal;
        function RegiaoDaProposta(const aIN_PROPOSTAS_ID: Cardinal): Byte;
        function SituacaoDaProposta(const aIN_PROPOSTAS_ID: Cardinal): Byte;
        function SituacaoDaObra(const aIN_OBRAS_ID: Cardinal): Byte;
        function RegioesDoUsuario(const aSM_USUARIOS_ID: Word): TBytesArray;
        function Equipamento(const aIN_EQUIPAMENTOS_ID: Cardinal): AnsiString;
    	//procedure AddAllUniqueIndexes(aProgressBar: TProgressBar; aLabelPercentDone: TLabel);
    	//procedure DropAllUniqueIndexes(aProgressBar: TProgressBar; aLabelPercentDone: TLabel);
        function ShowAutoSyncForm(const aDescription: String): TModalResult;
        //function DatabaseCheckSum(const aZConnection: TZConnection): AnsiString;
        procedure LoadGeneralConfigurations(const aZConnection: TZConnection; aForm: TForm; const aPagesToShow: TPagesToShow; const aBasicConfigurations: TXXXConfigurations); override;
        procedure SaveGeneralConfigurations(const aZConnection: TZConnection; aForm: TForm; const aPagesToShow: TPagesToShow; const aBasicConfigurations: TXXXConfigurations); override;
    public
    	{ Public declarations }
        procedure ExibirExportadorImportador;
        function ObraDaProposta(const aIN_PROPOSTA_ID: Cardinal): Cardinal;
        function RegiaoPermitidaParaOUsuario(const aSM_USUARIOS_ID: Word; const aTI_REGIOES_ID: Byte): Boolean;
		function ReplaceSystemObjectNames(const aText: AnsiString): AnsiString; override;
		procedure ReplaceSystemObjectNames(const aZQuery: TZQuery); override;
        function SHBrowseForObject(const aOwner: TComponent;
                                   const aDialogTitle: AnsiString;
                                   const aDialogText: String;
                                     out aSelection: String): Boolean;
        function EhRichText(const aText: String): Boolean;
  	end;

implementation

uses
	{ VCL }
    DBCtrls, AnsiStrings,
    { FRAMEWORK }
    UXXXForm_ModuleTabbedTemplate, UXXXForm_DialogTemplate,
    { APLICAÇÃO }
    UBDOTypesConstantsAndClasses, UBDOForm_GeneralConfigurations,
    UBDODataModule_AutoSync,

    UBDODataModule_GeradorDeProposta, UBDOForm_GeradorDeProposta,
    UBDODataModule_Relatorio_EQP, UBDOForm_Relatorio_EQP,
    UBDODataModule_Relatorio_FAM, UBDOForm_Relatorio_FAM,
    UBDODataModule_Relatorio_OBR, UBDOForm_Relatorio_OBR,
    UBDODataModule_Relatorio_PRO, UBDOForm_Relatorio_PRO,
    UBDODataModule_Relatorio_JDO, UBDOForm_Relatorio_JDO,
    UBDODataModule_InformacoesDaProposta, UBDOForm_InformacoesDaProposta,
    UBDODataModule_ImportarExportarObras, UBDOForm_ImportarExportarObras,
    UBDODataModule_InformacoesDoEquipamento, UBDOForm_InformacoesDoEquipamento,
    { COMPONENTES }
  	ZAbstractRODataset, UAPIWrappers;

//procedure Register;
//begin
//    RegisterClass(TBDODataModule);
//end;

{$R *.dfm}

procedure TBDODataModule.LoadGeneralConfigurations(const aZConnection: TZConnection; aForm: TForm; const aPagesToShow: TPagesToShow; const aBasicConfigurations: TXXXConfigurations);
begin
  	inherited;
    with TBDOConfigurations(aBasicConfigurations), TBDOForm_GeneralConfigurations(aForm) do
    begin
        { FTP Synchronizer }
        if (ptsAll in aPagesToShow) or (ptsCustom0 in aPagesToShow) then
        begin
            TabSheet_FTPSynchronizer.TabVisible := True;

            Label_FTPSynchronizerLocationValue.Caption := FTPSynchronizerLocation; 
        end
        else
            TabSheet_FTPSynchronizer.TabVisible := False;


        { Não é necessário ocultar a a página aqui porque isso já é feito na
        classe base }
        if (ptsAll in aPagesToShow) or (ptsOtherOptions in aPagesToShow) then
        begin
            { Pagina 2 }
            CheckBox_ITE_LucroBruto.Checked := ExibirColunaLucroBrutoEmCadastroDeItens;
        end;
    end;
end;

function TBDODataModule.SituacaoDaObra(const aIN_OBRAS_ID: Cardinal): Byte;
const
    SQL =
    'SELECT TI_SITUACOES_ID'#13#10 +
    '  FROM OBRAS'#13#10 +
    ' WHERE IN_OBRAS_ID = %u';
var
    RODataSet: TZReadOnlyQuery;
begin
    Result := 0;
    RODataSet := nil;
    try
        ConfigureDataSet(DataModuleMain.ZConnections.ByName['ZConnection_BDO'].Connection
                        ,RODataSet
                        ,MySQLFormat(SQL
                                    ,[aIN_OBRAS_ID]));

        if Assigned(RODataSet) then
            Result := RODataSet.Fields[0].AsInteger;
    finally
        if Assigned(RODataSet) then
            RODataSet.Free;
    end;
end;

function TBDODataModule.SituacaoDaProposta(const aIN_PROPOSTAS_ID: Cardinal): Byte;
const
    SQL =
    'SELECT OBR.TI_SITUACOES_ID'#13#10 +
    '  FROM OBRAS OBR'#13#10 +
    '  JOIN PROPOSTAS PRO USING (IN_OBRAS_ID)'#13#10 +
    ' WHERE PRO.IN_PROPOSTAS_ID = %u';
var
    RODataSet: TZReadOnlyQuery;
begin
    Result := 0;
    RODataSet := nil;
    try
        ConfigureDataSet(DataModuleMain.ZConnections.ByName['ZConnection_BDO'].Connection
                        ,RODataSet
                        ,Format(SQL,[aIN_PROPOSTAS_ID]));

        if Assigned(RODataSet) then
            Result := RODataSet.Fields[0].AsInteger;
    finally
        if Assigned(RODataSet) then
            RODataSet.Free;
    end;
end;

//function TBDODataModule.ReajusteDaProposta(const aIN_PROPOSTAS_ID: Cardinal): Double;
//begin
//	Result := ExecuteDbFunction(DataModuleMain.ZConnections.ByName['ZConnection_BDO'].Connection
//                               ,Format('FNC_GET_PROPOSAL_REAJUST_MULTIPLIER(%u)'
//                                      ,[aIN_PROPOSTAS_ID])).AsDouble;
//end;

function TBDODataModule.RegiaoDaProposta(const aIN_PROPOSTAS_ID: Cardinal): Byte;
const
    SQL =
    'SELECT OBR.TI_REGIOES_ID'#13#10 +
    '  FROM OBRAS OBR'#13#10 +
    '  JOIN PROPOSTAS PRO USING (IN_OBRAS_ID)'#13#10 +
    ' WHERE PRO.IN_PROPOSTAS_ID = %u';
var
    RODataSet: TZReadOnlyQuery;
begin
    Result := 0;
    RODataSet := nil;
    try
        ConfigureDataSet(DataModuleMain.ZConnections.ByName['ZConnection_BDO'].Connection
                        ,RODataSet
                        ,Format(SQL,[aIN_PROPOSTAS_ID]));

        if Assigned(RODataSet) then
            Result := RODataSet.Fields[0].AsInteger;
    finally
        if Assigned(RODataSet) then
            RODataSet.Free;
    end;
end;

function TBDODataModule.RegiaoPermitidaParaOUsuario(const aSM_USUARIOS_ID: Word; const aTI_REGIOES_ID: Byte): Boolean;
const
    SQL =
    'SELECT RDU.TI_REGIOES_ID'#13#10 +
    '  FROM REGIOESDOSUSUARIOS RDU'#13#10 +
    ' WHERE RDU.SM_USUARIOS_ID = %u AND RDU.TI_REGIOES_ID = %u';
var
	RODataSet: TZReadOnlyQuery;
begin
	RODataSet := nil;
    try
        ConfigureDataSet(DataModuleMain.ZConnections.ByName['ZConnection_BDO'].Connection,RODataSet,Format(ReplaceSystemObjectNames(SQL),[aSM_USUARIOS_ID,aTI_REGIOES_ID]));
        Result := RODataSet.RecordCount = 1;
    finally
        if Assigned(RODataSet) then
            RODataSet.Free;
    end;
end;

function TBDODataModule.RegioesDoUsuario(const aSM_USUARIOS_ID: Word): TBytesArray;
var
	RegioesDosUsuarios: TZReadOnlyQuery;
	i: Word;
begin
	Result := nil;

	RegioesDosUsuarios := nil;
    try
	    ConfigureDataSet(DataModuleMain.ZConnections.ByName['ZConnection_BDO'].Connection
                        ,RegioesDosUsuarios
                        ,'SELECT TI_REGIOES_ID FROM REGIOESDOSUSUARIOS WHERE SM_USUARIOS_ID = ' + IntToStr(aSM_USUARIOS_ID));
    	with RegioesDosUsuarios do
		    if RecordCount > 0 then
		    begin
			    i := 0;
			    SetLength(Result,RecordCount);
			    First;

			    while not Eof do
			    begin
				    Result[i] := Fields[0].AsInteger;
				    Inc(i);
				    Next;
			    end;
		    end;
    finally
	    if Assigned(RegioesDosUsuarios) then
    		RegioesDosUsuarios.Free;
    end;
end;

function TBDODataModule.ReplaceSystemObjectNames(const aText: AnsiString): AnsiString;
begin
	Result := inherited ReplaceSystemObjectNames(aText);
    Result := AnsiStrings.StringReplace(Result,'X[RDU.' + DEFAULT_USERREGIONS_TABLENAME + ']X',TBDOConfigurations(Configurations).UserRegionsTableTableName,[rfReplaceAll,rfIgnoreCase]);
    Result := AnsiStrings.StringReplace(Result,'X[RDU.' + DEFAULT_USERREGIONS_KEYFIELDNAME + ']X',TBDOConfigurations(Configurations).UserRegionsTableKeyFieldName,[rfReplaceAll,rfIgnoreCase]);
    Result := AnsiStrings.StringReplace(Result,'X[RDU.' + DEFAULT_USERREGIONS_USERFIELDNAME + ']X',TBDOConfigurations(Configurations).UserRegionsTableUserFieldName,[rfReplaceAll,rfIgnoreCase]);
    Result := AnsiStrings.StringReplace(Result,'X[RDU.' + DEFAULT_USERREGIONS_REGIONFIELDNAME + ']X',TBDOConfigurations(Configurations).UserRegionsTableRegionFieldName,[rfReplaceAll,rfIgnoreCase]);
end;

procedure TBDODataModule.ReplaceSystemObjectNames(const aZQuery: TZQuery);
var
	i: Byte;
begin
    inherited;
	for i := 0 to Pred(aZQuery.FieldCount) do
    begin
        aZQuery.Fields[i].FieldName := StringReplace(aZQuery.Fields[i].FieldName,'X[RDU.' + DEFAULT_USERREGIONS_TABLENAME + ']X',TBDOConfigurations(Configurations).UserRegionsTableTableName,[rfReplaceAll,rfIgnoreCase]);
        aZQuery.Fields[i].FieldName := StringReplace(aZQuery.Fields[i].FieldName,'X[RDU.' + DEFAULT_USERREGIONS_KEYFIELDNAME + ']X',TBDOConfigurations(Configurations).UserRegionsTableKeyFieldName,[rfReplaceAll,rfIgnoreCase]);
        aZQuery.Fields[i].FieldName := StringReplace(aZQuery.Fields[i].FieldName,'X[RDU.' + DEFAULT_USERREGIONS_USERFIELDNAME + ']X',TBDOConfigurations(Configurations).UserRegionsTableUserFieldName,[rfReplaceAll,rfIgnoreCase]);
        aZQuery.Fields[i].FieldName := StringReplace(aZQuery.Fields[i].FieldName,'X[RDU.' + DEFAULT_USERREGIONS_REGIONFIELDNAME + ']X',TBDOConfigurations(Configurations).UserRegionsTableRegionFieldName,[rfReplaceAll,rfIgnoreCase]);
    end;
end;

function TBDODataModule.ObraDaProposta(const aIN_PROPOSTA_ID: Cardinal): Cardinal;
begin
	Result := ExecuteDbFunction(DataModuleMain.ZConnections.ByName['ZConnection_BDO'].Connection
                               ,Format('FNC_GET_WORK_FROM_PROPOSAL(%u)',[aIN_PROPOSTA_ID])).AsDWord;
end;

function TBDODataModule.PropostaPadrao(const aIN_OBRAS_ID: Cardinal): Cardinal;
begin
	Result := ExecuteDbFunction(DataModuleMain.ZConnections.ByName['ZConnection_BDO'].Connection
                               ,Format('FNC_GET_DEFAULT_PROPOSAL(%u)',[aIN_OBRAS_ID])).AsDWord;
end;

function TBDODataModule.ValorDaProposta(const aIN_PROPOSTAS_ID: Cardinal;
                                              aSubTotal
                                            , aAutoDetectarCotacoes: Boolean;
                                        const aCotacoes: AnsiString): Currency;
begin
	Result := ExecuteDbFunction(DataModuleMain.ZConnections.ByName['ZConnection_BDO'].Connection
                               ,Format('FNC_GET_PROPOSAL_VALUE(%u,%s,%s,''%s'',2)' //2 = DUAS CASAS DECIMAIS EM CADA ITEM SOMADO
                                      ,[aIN_PROPOSTAS_ID
                                       ,UpperCase(BoolToStr(aSubTotal,True))
                                       ,UpperCase(BoolToStr(aAutoDetectarCotacoes,True))
                                       ,aCotacoes])).AsCurrency;
end;

function TBDODataModule.ValorDaObra(const aIN_OBRAS_ID: Cardinal;
                                          aAutoDetectarCotacoes: Boolean;
                                    const aCotacoes: AnsiString): Currency;
begin
	Result := ExecuteDbFunction(DataModuleMain.ZConnections.ByName['ZConnection_BDO'].Connection
                               ,Format('FNC_GET_WORK_VALUE(%u,%s,''%s'',2)' //2 = DUAS CASAS DECIMAIS EM CADA ITEM SOMADO
                                      ,[aIN_OBRAS_ID
                                       ,UpperCase(BoolToStr(aAutoDetectarCotacoes,True))
                                       ,aCotacoes])).AsCurrency;
end;

function TBDODataModule.QuantidadeDePropostas(const aIN_OBRAS_ID: Cardinal): Byte;
begin
	Result := ExecuteDbFunction(DataModuleMain.ZConnections.ByName['ZConnection_BDO'].Connection
                               ,Format('FNC_GET_PROPOSAL_COUNT(%u)',[aIN_OBRAS_ID])).AsDWord;
end;

function TBDODataModule.CodigoDaProposta(const aIN_PROPOSTAS_ID: Cardinal): AnsiString;
begin
	Result := ExecuteDbFunction(DataModuleMain.ZConnections.ByName['ZConnection_BDO'].Connection
                               ,Format('FNC_GET_PROPOSAL_CODE(%u)',[aIN_PROPOSTAS_ID])).AsAnsiString;
end;


procedure TBDODataModule.SaveGeneralConfigurations(const aZConnection: TZConnection; aForm: TForm; const aPagesToShow: TPagesToShow; const aBasicConfigurations: TXXXConfigurations);
begin
  	inherited;
    with TBDOConfigurations(aBasicConfigurations), TBDOForm_GeneralConfigurations(aForm) do
    begin
        { FTP Synchronizer }
        if (ptsAll in aPagesToShow) or (ptsCustom0 in aPagesToShow) then
        begin
            FTPSynchronizerLocation := Label_FTPSynchronizerLocationValue.Caption;
        end;

        if (ptsAll in aPagesToShow) or (ptsOtherOptions in aPagesToShow) then
        begin
            { Pagina 2 }
            ExibirColunaLucroBrutoEmCadastroDeItens := CheckBox_ITE_LucroBruto.Checked;
        end;
    end;
end;

function TBDODataModule.SHBrowseForObject(const aOwner: TComponent;
                                          const aDialogTitle: AnsiString;
                                          const aDialogText: String;
                                            out aSelection: String): Boolean;
var
	SHBFO: TSHBrowseForObject;
begin
	SHBFO := nil;
	try
    	SHBFO := TSHBrowseForObject.Create(aOwner);
    	with SHBFO do
        begin
        	DialogTitle := aDialogTitle;
            DialogText := aDialogText;
            RootObject := ridDesktop;
            { TODO -oCarlos Feitoza -cMELHORIA : Para tornar mais genérico, use
            um parâmetro para indicar os flags }
		   	Flags := [bfDirectoriesOnly,bfStatusText,bfNewDialogStyle];
        end;

        Result := SHBFO.Execute;
        aSelection := SHBFO.SelectedObject;

    finally
    	if Assigned(SHBFO) then
        	SHBFO.Free;
    end;
end;

//function TBDODataModule.DatabaseCheckSum(const aZConnection: TZConnection): AnsiString;
//begin
//    Result := MySQLDatabaseCheckSum(aZConnection
//                                   ,['DELTA' { ambos }
//                                    ,'SEQUENCIAS' { servidor }
//                                    ,'SINCRONIZACOES' { cliente }
//                                    ,'REGISTROSEXCLUIDOS' { cliente - depreciada }
//                                    ]
//                                   ,['EN_SITUACAO']
//                                   );
//end;

//const
//    UNIQUE_KEY_COUNT = 18; { Faça uma forma disso ser dinamico }

//procedure TBDODataModule.DropAllUniqueIndexes(aProgressBar: TProgressBar; aLabelPercentDone: TLabel);
//begin
//	InitializeProgress(aProgressBar,aLabelPercentDone,UNIQUE_KEY_COUNT);
//    MySQLDropIndex(DataModuleAlpha.ZConnections.ByName['ZConnection_BDO'].Connection,'EQUIPAMENTOS','EQP_VA_MODELO_UI');
//    IncreaseProgress(aProgressBar,aLabelPercentDone);
//    MySQLDropIndex(DataModuleAlpha.ZConnections.ByName['ZConnection_BDO'].Connection,'SITUACOES','SIT_VA_DESCRICAO_UI');
//    IncreaseProgress(aProgressBar,aLabelPercentDone);
//    MySQLDropIndex(DataModuleAlpha.ZConnections.ByName['ZConnection_BDO'].Connection,'TIPOS','TIP_VA_DESCRICAO_UI');
//    IncreaseProgress(aProgressBar,aLabelPercentDone);
//    MySQLDropIndex(DataModuleAlpha.ZConnections.ByName['ZConnection_BDO'].Connection,'INSTALADORES','INS_VA_NOME_UI');
//    IncreaseProgress(aProgressBar,aLabelPercentDone);
//    MySQLDropIndex(DataModuleAlpha.ZConnections.ByName['ZConnection_BDO'].Connection,'REGIOES','REG_VA_REGIAO_UI');
//    IncreaseProgress(aProgressBar,aLabelPercentDone);
//    MySQLDropIndex(DataModuleAlpha.ZConnections.ByName['ZConnection_BDO'].Connection,'REGIOES','REG_CH_PREFIXODAPROPOSTA_UI');
//    IncreaseProgress(aProgressBar,aLabelPercentDone);
//    MySQLDropIndex(DataModuleAlpha.ZConnections.ByName['ZConnection_BDO'].Connection,'PROJETISTAS','PRJ_VA_NOME_UI');
//    IncreaseProgress(aProgressBar,aLabelPercentDone);
//    MySQLDropIndex(DataModuleAlpha.ZConnections.ByName['ZConnection_BDO'].Connection,'ENTIDADESDOSISTEMA','EDS_VA_NOME_UI');
//    IncreaseProgress(aProgressBar,aLabelPercentDone);
//    MySQLDropIndex(DataModuleAlpha.ZConnections.ByName['ZConnection_BDO'].Connection,'USUARIOS','USU_VA_LOGIN_UI');
//    IncreaseProgress(aProgressBar,aLabelPercentDone);
//    MySQLDropIndex(DataModuleAlpha.ZConnections.ByName['ZConnection_BDO'].Connection,'UNIDADES','UNI_VA_ABREVIATURA_UI');
//    IncreaseProgress(aProgressBar,aLabelPercentDone);
//    MySQLDropIndex(DataModuleAlpha.ZConnections.ByName['ZConnection_BDO'].Connection,'UNIDADES','UNI_VA_DESCRICAO_UI');
//    IncreaseProgress(aProgressBar,aLabelPercentDone);
//    MySQLDropIndex(DataModuleAlpha.ZConnections.ByName['ZConnection_BDO'].Connection,'GRUPOS','GRU_VA_NOME_UI');
//    IncreaseProgress(aProgressBar,aLabelPercentDone);
//    MySQLDropIndex(DataModuleAlpha.ZConnections.ByName['ZConnection_BDO'].Connection,'FAMILIAS','FAM_VA_DESCRICAO_UI');
//    IncreaseProgress(aProgressBar,aLabelPercentDone);
//    MySQLDropIndex(DataModuleAlpha.ZConnections.ByName['ZConnection_BDO'].Connection,'REGIOESDOSUSUARIOS','RDU_SM_USUARIOS_ID_TI_REGIOES_ID_UI');
//    IncreaseProgress(aProgressBar,aLabelPercentDone);
//    MySQLDropIndex(DataModuleAlpha.ZConnections.ByName['ZConnection_BDO'].Connection,'GRUPOSDOSUSUARIOS','GDU_TI_GRUPOS_ID_SM_USUARIOS_ID_UI');
//    IncreaseProgress(aProgressBar,aLabelPercentDone);
//    MySQLDropIndex(DataModuleAlpha.ZConnections.ByName['ZConnection_BDO'].Connection,'PERMISSOESDOSGRUPOS','PDG_IN_ENTIDADESDOSISTEMA_ID_TI_GRUPOS_UI');
//    IncreaseProgress(aProgressBar,aLabelPercentDone);
//    MySQLDropIndex(DataModuleAlpha.ZConnections.ByName['ZConnection_BDO'].Connection,'PERMISSOESDOSUSUARIOS','PDU_IN_ENTIDADESDOSISTEMA_ID_SM_USUARIOS_ID_UI');
//    IncreaseProgress(aProgressBar,aLabelPercentDone);
//    MySQLDropIndex(DataModuleAlpha.ZConnections.ByName['ZConnection_BDO'].Connection,'PROPOSTAS','PRO_SM_CODIGO_YR_ANO_UI');
//    IncreaseProgress(aProgressBar,aLabelPercentDone);
//end;

//procedure TBDODataModule.AddAllUniqueIndexes;
//begin
//	InitializeProgress(aProgressBar,aLabelPercentDone,UNIQUE_KEY_COUNT);
//    MySQLAddIndex(DataModuleAlpha.ZConnections.ByName['ZConnection_BDO'].Connection,'EQUIPAMENTOS','EQP_VA_MODELO_UI','VA_MODELO',mikUnique);
//    IncreaseProgress(aProgressBar,aLabelPercentDone);
//    MySQLAddIndex(DataModuleAlpha.ZConnections.ByName['ZConnection_BDO'].Connection,'SITUACOES','SIT_VA_DESCRICAO_UI','VA_DESCRICAO',mikUnique);
//    IncreaseProgress(aProgressBar,aLabelPercentDone);
//    MySQLAddIndex(DataModuleAlpha.ZConnections.ByName['ZConnection_BDO'].Connection,'TIPOS','TIP_VA_DESCRICAO_UI','VA_DESCRICAO',mikUnique);
//    IncreaseProgress(aProgressBar,aLabelPercentDone);
//    MySQLAddIndex(DataModuleAlpha.ZConnections.ByName['ZConnection_BDO'].Connection,'INSTALADORES','INS_VA_NOME_UI','VA_NOME',mikUnique);
//    IncreaseProgress(aProgressBar,aLabelPercentDone);
//    MySQLAddIndex(DataModuleAlpha.ZConnections.ByName['ZConnection_BDO'].Connection,'REGIOES','REG_VA_REGIAO_UI','VA_REGIAO',mikUnique);
//    IncreaseProgress(aProgressBar,aLabelPercentDone);
//    MySQLAddIndex(DataModuleAlpha.ZConnections.ByName['ZConnection_BDO'].Connection,'REGIOES','REG_CH_PREFIXODAPROPOSTA_UI','CH_PREFIXODAPROPOSTA',mikUnique);
//    IncreaseProgress(aProgressBar,aLabelPercentDone);
//    MySQLAddIndex(DataModuleAlpha.ZConnections.ByName['ZConnection_BDO'].Connection,'PROJETISTAS','PRJ_VA_NOME_UI','VA_NOME',mikUnique);
//    IncreaseProgress(aProgressBar,aLabelPercentDone);
//    MySQLAddIndex(DataModuleAlpha.ZConnections.ByName['ZConnection_BDO'].Connection,'ENTIDADESDOSISTEMA','EDS_VA_NOME_UI','VA_NOME',mikUnique);
//    IncreaseProgress(aProgressBar,aLabelPercentDone);
//    MySQLAddIndex(DataModuleAlpha.ZConnections.ByName['ZConnection_BDO'].Connection,'USUARIOS','USU_VA_LOGIN_UI','VA_LOGIN',mikUnique);
//    IncreaseProgress(aProgressBar,aLabelPercentDone);
//    MySQLAddIndex(DataModuleAlpha.ZConnections.ByName['ZConnection_BDO'].Connection,'UNIDADES','UNI_VA_ABREVIATURA_UI','VA_ABREVIATURA',mikUnique);
//    IncreaseProgress(aProgressBar,aLabelPercentDone);
//    MySQLAddIndex(DataModuleAlpha.ZConnections.ByName['ZConnection_BDO'].Connection,'UNIDADES','UNI_VA_DESCRICAO_UI','VA_DESCRICAO',mikUnique);
//    IncreaseProgress(aProgressBar,aLabelPercentDone);
//    MySQLAddIndex(DataModuleAlpha.ZConnections.ByName['ZConnection_BDO'].Connection,'GRUPOS','GRU_VA_NOME_UI','VA_NOME',mikUnique);
//    IncreaseProgress(aProgressBar,aLabelPercentDone);
//    MySQLAddIndex(DataModuleAlpha.ZConnections.ByName['ZConnection_BDO'].Connection,'FAMILIAS','FAM_VA_DESCRICAO_UI','VA_DESCRICAO',mikUnique);
//    IncreaseProgress(aProgressBar,aLabelPercentDone);
//    MySQLAddIndex(DataModuleAlpha.ZConnections.ByName['ZConnection_BDO'].Connection,'REGIOESDOSUSUARIOS','RDU_SM_USUARIOS_ID_TI_REGIOES_ID_UI','SM_USUARIOS_ID,TI_REGIOES_ID',mikUnique);
//    IncreaseProgress(aProgressBar,aLabelPercentDone);
//    MySQLAddIndex(DataModuleAlpha.ZConnections.ByName['ZConnection_BDO'].Connection,'GRUPOSDOSUSUARIOS','GDU_TI_GRUPOS_ID_SM_USUARIOS_ID_UI','TI_GRUPOS_ID,SM_USUARIOS_ID',mikUnique);
//    IncreaseProgress(aProgressBar,aLabelPercentDone);
//    MySQLAddIndex(DataModuleAlpha.ZConnections.ByName['ZConnection_BDO'].Connection,'PERMISSOESDOSGRUPOS','PDG_IN_ENTIDADESDOSISTEMA_ID_TI_GRUPOS_UI','IN_ENTIDADESDOSISTEMA_ID,TI_GRUPOS_ID',mikUnique);
//    IncreaseProgress(aProgressBar,aLabelPercentDone);
//    MySQLAddIndex(DataModuleAlpha.ZConnections.ByName['ZConnection_BDO'].Connection,'PERMISSOESDOSUSUARIOS','PDU_IN_ENTIDADESDOSISTEMA_ID_SM_USUARIOS_ID_UI','IN_ENTIDADESDOSISTEMA_ID,SM_USUARIOS_ID',mikUnique);
//    IncreaseProgress(aProgressBar,aLabelPercentDone);
//    MySQLAddIndex(DataModuleAlpha.ZConnections.ByName['ZConnection_BDO'].Connection,'PROPOSTAS','PRO_SM_CODIGO_YR_ANO_UI','SM_CODIGO,YR_ANO',mikUnique);
//    IncreaseProgress(aProgressBar,aLabelPercentDone);
//end;

function TBDODataModule.ShowAutoSyncForm(const aDescription: String): TModalResult;
var
	CreateParameters: TDialogCreateParameters;
begin
	ZeroMemory(@CreateParameters,SizeOf(TDialogCreateParameters));
    CreateParameters.Configurations := Configurations;
    with CreateParameters do
    begin
        AutoFree := True;
        AutoShow := True;
        Modal := True;
        MyDataModuleClass := TBDODataModule_AutoSync;
        DataModuleMain := Self.DataModuleMain;
        DialogDescription := aDescription;
    end;
	Result := TXXXForm_DialogTemplate.CreateDialog(Owner,Form_AutoSync,TBDOForm_AutoSync,CreateParameters);
end;

function TBDODataModule.SimboloMonetario(const aCodigo: Byte): AnsiString;
begin
    Result := CURRENCY_STRINGS[aCodigo];
end;

function TBDODataModule.SituacaoJustificavel(const aTI_SITUACOES_ID: Byte): Boolean;
const
    SQL =
    'SELECT SIT.BO_JUSTIFICAVEL'#13#10 +
    '  FROM SITUACOES SIT'#13#10 +
    ' WHERE SIT.TI_SITUACOES_ID = %u';
var
	RODataSet: TZReadOnlyQuery;
begin
	RODataSet := nil;
    try
        ConfigureDataSet(DataModuleMain.ZConnections.ByName['ZConnection_BDO'].Connection
                        ,RODataSet
                        ,MySQLFormat(SQL,[aTI_SITUACOES_ID]));
                        
        Result := RODataSet.Fields[0].AsInteger = 1;
    finally
        if Assigned(RODataSet) then
            RODataSet.Free;
    end;
end;

procedure TBDODataModule.ExibirGeradorDeProposta(const aPropostaID: Cardinal);
var
	CreateParameters: TDialogCreateParameters;
    BDOForm_GeradorDeProposta: TBDOForm_GeradorDeProposta;
begin
	ZeroMemory(@CreateParameters,SizeOf(TDialogCreateParameters));
    CreateParameters.Configurations := Configurations;
    with CreateParameters do
    begin
        AutoFree := True;
        Modal := True;
        MyDataModuleClass := TBDODataModule_GeradorDeProposta;
        DataModuleMain := Self.DataModuleMain;
    end;

    BDOForm_GeradorDeProposta := nil;
    BDOForm_GeradorDeProposta := TBDOForm_GeradorDeProposta.Create(Owner
                                                                  ,BDOForm_GeradorDeProposta
                                                                  ,CreateParameters);

    with BDOForm_GeradorDeProposta do
    begin
        PropostaID := aPropostaID;
        ShowModal;
    end;
end;

procedure TBDODataModule.ExibirGeradorDeRelatorioDeEquipamentos;
var
	CreateParameters: TDialogCreateParameters;
    BDOForm_Relatorio_EQP: TBDOForm_Relatorio_EQP;
begin
	ZeroMemory(@CreateParameters,SizeOf(TDialogCreateParameters));
    CreateParameters.Configurations := Configurations;
    with CreateParameters do
    begin
        AutoFree := True;
        Modal := True;
        MyDataModuleClass := TBDODataModule_Relatorio_EQP;
        DataModuleMain := Self.DataModuleMain;
    end;

    BDOForm_Relatorio_EQP := nil;
    BDOForm_Relatorio_EQP := TBDOForm_Relatorio_EQP.Create(Owner
                                                          ,BDOForm_Relatorio_EQP
                                                          ,CreateParameters);

    with BDOForm_Relatorio_EQP do
    begin
//        PropostaID := aPropostaID;
        ShowModal;
    end;
end;

procedure TBDODataModule.ExibirGeradorDeRelatorioDeFamilias;
var
	CreateParameters: TDialogCreateParameters;
    BDOForm_Relatorio_FAM: TBDOForm_Relatorio_FAM;
begin
	ZeroMemory(@CreateParameters,SizeOf(TDialogCreateParameters));
    CreateParameters.Configurations := Configurations;
    with CreateParameters do
    begin
        AutoFree := True;
        Modal := True;
        MyDataModuleClass := TBDODataModule_Relatorio_FAM;
        DataModuleMain := Self.DataModuleMain;
    end;

    BDOForm_Relatorio_FAM := nil;
    BDOForm_Relatorio_FAM := TBDOForm_Relatorio_FAM.Create(Owner
                                                          ,BDOForm_Relatorio_FAM
                                                          ,CreateParameters);

    with BDOForm_Relatorio_FAM do
    begin
//        PropostaID := aPropostaID;
        ShowModal;
    end;
end;

procedure TBDODataModule.ExibirGeradorDeRelatorioDeJustificativasDasObras;
var
	CreateParameters: TDialogCreateParameters;
    BDOForm_Relatorio_JDO: TBDOForm_Relatorio_JDO;
begin
	ZeroMemory(@CreateParameters,SizeOf(TDialogCreateParameters));
    CreateParameters.Configurations := Configurations;
    with CreateParameters do
    begin
        AutoFree := True;
        Modal := True;
        MyDataModuleClass := TBDODataModule_Relatorio_JDO;
        DataModuleMain := Self.DataModuleMain;
    end;

    BDOForm_Relatorio_JDO := nil;
    BDOForm_Relatorio_JDO := TBDOForm_Relatorio_JDO.Create(Owner
                                                          ,BDOForm_Relatorio_JDO
                                                          ,CreateParameters);

    with BDOForm_Relatorio_JDO do
    begin
//        PropostaID := aPropostaID;
        ShowModal;
    end;
end;

procedure TBDODataModule.ExibirGeradorDeRelatorioDeObras;
var
	CreateParameters: TDialogCreateParameters;
    BDOForm_Relatorio_OBR: TBDOForm_Relatorio_OBR;
begin
	ZeroMemory(@CreateParameters,SizeOf(TDialogCreateParameters));
    CreateParameters.Configurations := Configurations;
    with CreateParameters do
    begin
        AutoFree := True;
        Modal := True;
        MyDataModuleClass := TBDODataModule_Relatorio_OBR;
        DataModuleMain := Self.DataModuleMain;
    end;

    BDOForm_Relatorio_OBR := nil;
    BDOForm_Relatorio_OBR := TBDOForm_Relatorio_OBR.Create(Owner
                                                          ,BDOForm_Relatorio_OBR
                                                          ,CreateParameters);

    with BDOForm_Relatorio_OBR do
    begin
//        PropostaID := aPropostaID;
        ShowModal;
    end;
end;

procedure TBDODataModule.ExibirGeradorDeRelatorioDePropostas;
var
	CreateParameters: TDialogCreateParameters;
    BDOForm_Relatorio_PRO: TBDOForm_Relatorio_PRO;
begin
	ZeroMemory(@CreateParameters,SizeOf(TDialogCreateParameters));
    CreateParameters.Configurations := Configurations;
    with CreateParameters do
    begin
        AutoFree := True;
        Modal := True;
        MyDataModuleClass := TBDODataModule_Relatorio_PRO;
        DataModuleMain := Self.DataModuleMain;
    end;

    BDOForm_Relatorio_PRO := nil;
    BDOForm_Relatorio_PRO := TBDOForm_Relatorio_PRO.Create(Owner
                                                          ,BDOForm_Relatorio_PRO
                                                          ,CreateParameters);

    with BDOForm_Relatorio_PRO do
    begin
//        PropostaID := aPropostaID;
        ShowModal;
    end;
end;

procedure TBDODataModule.ExibirInformacoesDaProposta(const aPropostaID: Cardinal);
var
	CreateParameters: TDialogCreateParameters;
    BDOForm_InformacoesDaProposta: TBDOForm_InformacoesDaProposta;
begin
	ZeroMemory(@CreateParameters,SizeOf(TDialogCreateParameters));
    CreateParameters.Configurations := Configurations;
    with CreateParameters do
    begin
        AutoFree := True;
        Modal := True;
        MyDataModuleClass := TBDODataModule_InformacoesDaProposta;
        DataModuleMain := Self.DataModuleMain;
    end;

    BDOForm_InformacoesDaProposta := nil;
    BDOForm_InformacoesDaProposta := TBDOForm_InformacoesDaProposta.Create(Owner
                                                                          ,BDOForm_InformacoesDaProposta
                                                                          ,CreateParameters);

    with BDOForm_InformacoesDaProposta do
    begin
        PropostaID := aPropostaID;
        ShowModal;
    end;
end;

procedure TBDODataModule.ExibirInformacoesDoEquipamento(const aMes, aAno, aEquipamento, aVoltagem: Cardinal);
var
	CreateParameters: TDialogCreateParameters;
    BDOForm_InformacoesDoEquipamento: TBDOForm_InformacoesDoEquipamento;
begin
	ZeroMemory(@CreateParameters,SizeOf(TDialogCreateParameters));
    CreateParameters.Configurations := Configurations;
    with CreateParameters do
    begin
        AutoFree := True;
        AutoShow := False;
        MyDataModuleClass := TBDODataModule_InformacoesDoEquipamento;
        DataModuleMain := Self.DataModuleMain;
    end;

    BDOForm_InformacoesDoEquipamento := nil;
    TXXXForm_DialogTemplate.CreateDialog(Owner,BDOForm_InformacoesDoEquipamento,TBDOForm_InformacoesDoEquipamento,CreateParameters);


    with BDOForm_InformacoesDoEquipamento do
    begin
        Mes := aMes;
        Ano := aAno;
        Equipamento := aEquipamento;
        Voltagem := aVoltagem;
        ShowModal;
    end;
end;

function TBDODataModule.EhRichText(const aText: String): Boolean;
begin
    Result := Pos('{\rtf1',aText) = 1;
end;

function TBDODataModule.Equipamento(const aIN_EQUIPAMENTOS_ID: Cardinal): AnsiString;
var
	Equipamentos: TZReadOnlyQuery;
begin
    Result := '';
    
	Equipamentos := nil;
    try
	    ConfigureDataSet(DataModuleMain.ZConnections.ByName['ZConnection_BDO'].Connection
                        ,Equipamentos
                        ,'SELECT VA_MODELO FROM EQUIPAMENTOS WHERE IN_EQUIPAMENTOS_ID = ' + IntToStr(aIN_EQUIPAMENTOS_ID));

	    if Equipamentos.RecordCount > 0 then
            Result := Equipamentos.Fields[0].AsString;
    finally
	    if Assigned(Equipamentos) then
    		Equipamentos.Free;
    end;
end;

procedure TBDODataModule.ExibirExportadorImportador;
var
	CreateParameters: TDialogCreateParameters;
    BDOForm_ImportarExportarObras: TBDOForm_ImportarExportarObras;
begin
	ZeroMemory(@CreateParameters,SizeOf(TDialogCreateParameters));
    CreateParameters.Configurations := Configurations;
    with CreateParameters do
    begin
        AutoFree := True;
        AutoShow := True;
        Modal := True;
        MyDataModuleClass := TBDODataModule_ImportarExportarObras;
        DataModuleMain := Self.DataModuleMain;
    end;
	TXXXForm_DialogTemplate.CreateDialog(Owner,BDOForm_ImportarExportarObras,TBDOForm_ImportarExportarObras,CreateParameters);
end;


end.
