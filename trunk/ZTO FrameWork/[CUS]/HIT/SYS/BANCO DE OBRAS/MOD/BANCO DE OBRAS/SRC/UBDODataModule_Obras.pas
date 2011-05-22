unit UBDODataModule_Obras;

interface

uses
    Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
    Dialogs, UBDODataModule, ImgList, ActnList, DB, ZAbstractRODataset,
    ZAbstractDataset, ZDataset, ZSqlUpdate, CFDBValidationChecks,
    UXXXTypesConstantsAndClasses, UBDOTypesConstantsAndClasses, UBDOForm_Obras,
    Menus, ActnPopup, UCFDBGrid, _ActnList, StdCtrls;

type
    TTabelaExpiravel = (teObra, teProposta, teItens, teEquipamentosDosItens);
    
    TBDODataModule_Obras = class(TBDODataModule)
        Action_OBR_insert: TAction;
        Action_OBR_Delete: TAction;
        Action_OBR_Edit: TAction;
        Action_PRO_Insert: TAction;
        Action_PRO_Delete: TAction;
        Action_PRO_Edit: TAction;
        Action_ITE_Insert: TAction;
        Action_ITE_Delete: TAction;
        Action_ITE_Edit: TAction;
        UpdateSQL_OBR: TZUpdateSQL;
        DataSource_OBR: TDataSource;
        PROPOSTAS: TZQuery;
        PROPOSTASIN_PROPOSTAS_ID: TIntegerField;
        PROPOSTASIN_OBRAS_ID: TIntegerField;
        PROPOSTASSM_INSTALADORES_ID: TIntegerField;
        PROPOSTASVA_CONTATO: TStringField;
        PROPOSTASBO_PROPOSTAPADRAO: TSmallintField;
        PROPOSTASFL_DESCONTOPERC: TFloatField;
        PROPOSTASFL_DESCONTOVAL: TFloatField;
        PROPOSTASVA_COTACOES: TStringField;
        PROPOSTASTI_VALIDADE: TSmallintField;
        PROPOSTASCODIGO: TStringField;
        PROPOSTASINSTALADOR: TStringField;
        PROPOSTASSUBTOTAL: TStringField;
        PROPOSTASREAJUSTE: TStringField;
        PROPOSTASTOTAL: TStringField;
        DataSource_PRO: TDataSource;
        UpdateSQL_PRO: TZUpdateSQL;
        ITENS: TZQuery;
        ITENSIN_ITENS_ID: TIntegerField;
        ITENSIN_PROPOSTAS_ID: TIntegerField;
        ITENSTI_FAMILIAS_ID: TSmallintField;
        ITENSFL_LUCROBRUTO: TFloatField;
        ITENSVA_DESCRICAO: TStringField;
        ITENSFL_CAPACIDADE: TFloatField;
        ITENSTI_UNIDADES_ID: TSmallintField;
        ITENSSM_QUANTIDADE: TIntegerField;
        ITENSEN_VOLTAGEM: TStringField;
        ITENSFL_DESCONTOPERC: TFloatField;
        ITENSTI_ORDEM: TSmallintField;
        ITENSFAMILIA: TStringField;
        ITENSCAPACIDADE: TStringField;
        ITENSSUBTOTAL: TStringField;
        ITENSREAJUSTE: TStringField;
        ITENSTOTAL: TStringField;
        ITENSLUCROBRUTO: TStringField;
        UpdateSQL_ITE: TZUpdateSQL;
        DataSource_ITE: TDataSource;
        EQUIPAMENTOSDOSITENS: TZQuery;
        EQUIPAMENTOSDOSITENSIN_EQUIPAMENTOSDOSITENS_ID: TIntegerField;
        EQUIPAMENTOSDOSITENSIN_ITENS_ID: TIntegerField;
        EQUIPAMENTOSDOSITENSIN_EQUIPAMENTOS_ID: TIntegerField;
        EQUIPAMENTOSDOSITENSFL_LUCROBRUTO: TFloatField;
        EQUIPAMENTOSDOSITENSFL_VALORUNITARIO: TFloatField;
        EQUIPAMENTOSDOSITENSTI_MOEDA: TSmallintField;
        EQUIPAMENTOSDOSITENSMODELO: TStringField;
        EQUIPAMENTOSDOSITENSVALORCOMIMPOSTOS: TStringField;
        EQUIPAMENTOSDOSITENSLUCROBRUTO: TStringField;
        UpdateSQL_EDI: TZUpdateSQL;
        OBRAS: TZQuery;
        OBRASIN_OBRAS_ID: TIntegerField;
        OBRASTI_REGIOES_ID: TSmallintField;
        OBRASVA_NOMEDAOBRA: TStringField;
        OBRASVA_CIDADE: TStringField;
        OBRASCH_ESTADO: TStringField;
        OBRASTI_SITUACOES_ID: TSmallintField;
        OBRASVA_PRAZODEENTREGA: TStringField;
        OBRASTX_CONDICAODEPAGAMENTO: TMemoField;
        OBRASEN_FRETE: TStringField;
        OBRASTX_CONDICOESGERAIS: TMemoField;
        OBRASTX_OBSERVACOES: TMemoField;
        OBRASVA_CONSTRUTORA: TStringField;
        OBRASTI_TIPOS_ID: TSmallintField;
        OBRASFL_ICMS: TFloatField;
        OBRASSM_PROJETISTAS_ID: TIntegerField;
        OBRASDA_DATADEEXPIRACAO: TDateField;
        DataSource_EDI: TDataSource;
        CFDBValidationChecks_OBR: TCFDBValidationChecks;
        CFDBValidationChecks_PRO: TCFDBValidationChecks;
        PROPOSTASTI_MOEDA: TSmallintField;
        CFDBValidationChecks_ITE: TCFDBValidationChecks;
        CFDBValidationChecks_EDI: TCFDBValidationChecks;
        REGIOES_LOOKUP: TZReadOnlyQuery;
        REGIOES_LOOKUPTI_REGIOES_ID: TSmallintField;
        REGIOES_LOOKUPVA_REGIAO: TStringField;
        DataSource_REG_LKP: TDataSource;
        OBRASDATADEENTRADA: TStringField;
        SITUACOES_LOOKUP: TZReadOnlyQuery;
        DataSource_SIT_LKP: TDataSource;
        SITUACOES_LOOKUPTI_SITUACOES_ID: TSmallintField;
        SITUACOES_LOOKUPVA_DESCRICAO: TStringField;
        TIPOS_LOOKUP: TZReadOnlyQuery;
        TIPOS_LOOKUPTI_TIPOS_ID: TSmallintField;
        TIPOS_LOOKUPVA_DESCRICAO: TStringField;
        DataSource_TIP_LKP: TDataSource;
        PROJETISTAS_LOOKUP: TZReadOnlyQuery;
        DataSource_PRJ_LKP: TDataSource;
        PROJETISTAS_LOOKUPSM_PROJETISTAS_ID: TIntegerField;
        PROJETISTAS_LOOKUPVA_NOME: TStringField;
        ICMS_LOOKUP: TZReadOnlyQuery;
        ICMS_LOOKUPFL_VALOR: TFloatField;
        DataSource_ICM_LKP: TDataSource;
        Action_ITE_MoveUp: TAction;
        Action_ITE_MoveDown: TAction;
        PopupActionBar_RecordInformation: TPopupActionBar;
        MenuItem_InformacoesSobreORegistro: TMenuItem;
        EQUIPAMENTOS_LOOKUP: TZReadOnlyQuery;
        DataSource_EQP_LKP: TDataSource;
        Action_ITE_Replicar: TAction;
        EQUIPAMENTOS_LOOKUPIN_EQUIPAMENTOS_ID: TIntegerField;
        EQUIPAMENTOS_LOOKUPVA_MODELO: TStringField;
        EQUIPAMENTOS_LOOKUPTI_MOEDA: TSmallintField;
        EQUIPAMENTOS_LOOKUPMOEDA: TStringField;
        PROPOSTAS_SEARCH: TZReadOnlyQuery;
        PROPOSTAS_SEARCHIN_PROPOSTAS_ID: TIntegerField;
        PROPOSTAS_SEARCHCODIGO: TStringField;
        PROPOSTAS_SEARCHNOMEDAOBRA: TStringField;
        PROPOSTAS_SEARCHINSTALADOR: TStringField;
        PROPOSTAS_SEARCHPROPOSTAPADRAO: TStringField;
        PROPOSTAS_SEARCHTOTAL: TStringField;
        OBRAS_SEARCH: TZReadOnlyQuery;
        OBRAS_SEARCHIN_OBRAS_ID: TIntegerField;
        OBRAS_SEARCHVA_NOMEDAOBRA: TStringField;
        OBRAS_SEARCHLOCALIDADE: TStringField;
        OBRAS_SEARCHREGIAO: TStringField;
        OBRAS_SEARCHDATAEHORADACRIACAO: TDateField;
        OBRAS_SEARCHSITUACAO: TStringField;
        OBRAS_SEARCHVALORPADRAO: TStringField;
        FAMILIAS_LOOKUP: TZReadOnlyQuery;
        FAMILIAS_LOOKUPTI_FAMILIAS_ID: TSmallintField;
        FAMILIAS_LOOKUPVA_DESCRICAO: TStringField;
        DataSource_FAM_LKP: TDataSource;
        UNIDADES_LOOKUP: TZReadOnlyQuery;
        UNIDADES_LOOKUPTI_UNIDADES_ID: TSmallintField;
        UNIDADES_LOOKUPVA_ABREVIATURA: TStringField;
        DataSource_UNI_LKP: TDataSource;
        INSTALADORES_LOOKUP: TZReadOnlyQuery;
        INSTALADORES_LOOKUPVA_NOME: TStringField;
        DataSource_INS_LKP: TDataSource;
        DataSource_OBR_SCH: TDataSource;
        DataSource_PRO_SCH: TDataSource;
        OBRAS_SEARCHTI_REGIOES_ID: TSmallintField;
        PROPOSTAS_SEARCHBO_PROPOSTAPADRAO: TSmallintField;
        OBRAS_SEARCHTI_SITUACOES_ID: TSmallintField;
        PROPOSTASDT_DATAEHORADACRIACAO: TDateField;
        INSTALADORES_LOOKUPSM_INSTALADORES_ID: TIntegerField;
        Action_PRO_DefinirCotacoes: TAction;
        Action_EDI_Insert: TAction;
        Action_EDI_Delete: TAction;
        Action_PRO_GerarProposta: TAction;
        PROPOSTASSUBTOTALSEMCOTACOES: TStringField;
        Action_OBR_Relatorio: TAction;
        Action_PRO_Relatorio: TAction;
        OBRASSM_USUARIOJUSTIFICADOR_ID: TIntegerField;
        Action_Justificativa: TAction;
        Justificativadesituao1: TMenuItem;
        PROPOSTAS_SEARCHSITUACAO: TStringField;
        PROPOSTAS_SEARCHLOCALIDADE: TStringField;
        EQUIPAMENTOS_SEARCH: TZReadOnlyQuery;
        DataSource_EQP_SCH: TDataSource;
        EQUIPAMENTOS_SEARCHIN_PROPOSTAS_ID: TIntegerField;
        EQUIPAMENTOS_SEARCHVA_MODELO: TStringField;
        EQUIPAMENTOS_SEARCHEN_VOLTAGEM: TStringField;
        EQUIPAMENTOS_SEARCHCODIGO: TStringField;
        EQUIPAMENTOS_SEARCHPROPOSTAPADRAO: TStringField;
        EQUIPAMENTOS_SEARCHBO_PROPOSTAPADRAO: TSmallintField;
        EQUIPAMENTOS_SEARCHIN_EQUIPAMENTOSDOSITENS_ID: TIntegerField;
        Action_EDI_Relatorio: TAction;
        EQUIPAMENTOS_SEARCHIN_ITENS_ID: TIntegerField;
        OBRAS_SEARCH_PAR: TZReadOnlyQuery;
        OBRAS_SEARCH_PARIN_OBRAS_ID: TIntegerField;
        OBRAS_SEARCH_PARVA_NOMEDAOBRA: TStringField;
        OBRAS_SEARCH_PARLOCALIDADE: TStringField;
        OBRAS_SEARCH_PARREGIAO: TStringField;
        OBRAS_SEARCH_PARDATADEENTRADA: TStringField;
        DataSource_OBR_SCH_PAR: TDataSource;
        OBRAS_SEARCH_PARTI_REGIOES_ID: TSmallintField;
        OBRAS_SEARCH_PAL: TZReadOnlyQuery;
        OBRAS_SEARCH_PALIN_OBRAS_ID: TIntegerField;
        OBRAS_SEARCH_PALVA_NOMEDAOBRA: TStringField;
        OBRAS_SEARCH_PALLOCALIDADE: TStringField;
        OBRAS_SEARCH_PALREGIAO: TStringField;
        OBRAS_SEARCH_PALDATADEENTRADA: TStringField;
        OBRAS_SEARCH_PALTI_REGIOES_ID: TSmallintField;
        DataSource_OBR_SCH_PAL: TDataSource;
        OBRASYR_ANOPROVAVELDEENTREGA: TSmallintField;
        OBRASTI_MESPROVAVELDEENTREGA: TSmallintField;
        OBRASDT_DATAEHORADACRIACAO: TDateTimeField;
        EQUIPAMENTOS_SEARCHNOMEDAOBRA: TStringField;
        procedure Action_OBR_DeleteExecute(Sender: TObject);
        procedure Action_OBR_insertExecute(Sender: TObject);
        procedure Action_OBR_EditExecute(Sender: TObject);
        procedure Action_PRO_InsertExecute(Sender: TObject);
        procedure Action_PRO_DeleteExecute(Sender: TObject);
        procedure Action_PRO_EditExecute(Sender: TObject);
        procedure Action_ITE_InsertExecute(Sender: TObject);
        procedure Action_ITE_DeleteExecute(Sender: TObject);
        procedure Action_ITE_EditExecute(Sender: TObject);
        procedure Action_ITE_MoveUpExecute(Sender: TObject);
        procedure Action_ITE_MoveDownExecute(Sender: TObject);
        procedure Action_RecordInformationExecute(Sender: TObject);
        procedure Action_ITE_ReplicarExecute(Sender: TObject);
        procedure DataModuleDestroy(Sender: TObject);
        procedure PROPOSTASTI_MOEDASetText(Sender: TField; const Text: string);
        procedure PROPOSTASTI_MOEDAGetText(Sender: TField; var Text: string; DisplayText: Boolean);
        procedure PROPOSTASTI_VALIDADEGetText(Sender: TField; var Text: string; DisplayText: Boolean);
        procedure Action_PRO_DefinirCotacoesExecute(Sender: TObject);
        procedure Action_EDI_InsertExecute(Sender: TObject);
        procedure Action_EDI_DeleteExecute(Sender: TObject);
        procedure Action_PRO_GerarPropostaExecute(Sender: TObject);
        procedure Action_OBR_RelatorioExecute(Sender: TObject);
        procedure Action_PRO_RelatorioExecute(Sender: TObject);
        procedure Action_JustificativaExecute(Sender: TObject);
        procedure PopupActionBar_RecordInformationPopup(Sender: TObject);
        procedure Action_EDI_RelatorioExecute(Sender: TObject);
        procedure OBRASTI_MESPROVAVELDEENTREGAGetText(Sender: TField; var Text: string; DisplayText: Boolean);
        procedure OBRASTI_MESPROVAVELDEENTREGASetText(Sender: TField; const Text: string);
    private
        { Private declarations }
        FSituacaoAnterior: Byte;
        FJustificativas: TBytesArray;
        OBR_SCH_RecordCount, PRO_SCH_RecordCount, EQP_SCH_RecordCount: Cardinal;
        OBR_SCH_PageCount, PRO_SCH_PageCount, EQP_SCH_PageCount,
        FOBR_SCH_RecordsByPage, FPRO_SCH_RecordsByPage, FEQP_SCH_RecordsByPage,
        FOBR_SCH_CurrentPage, FPRO_SCH_CurrentPage, FEQP_SCH_CurrentPage: Word;

        function MyModule: TBDOForm_Obras;
        procedure CreateTemporaryTableObrasSearch;
        procedure CreateTemporaryTablePropostasSearch;
        procedure CreateTemporaryTableEquipamentosSearch;
        procedure DropTemporaryTables;
        function OBR_SCH_WhereClause(const aOBRFilter: TOBRFilter): AnsiString;
        function PRO_SCH_WhereClause(const aPROFilter: TPROFilter): AnsiString;
        function EQP_SCH_WhereClause(const aEQPFilter: TEQPFilter): AnsiString;
        function ObraExpirou(aTabelaExpiravel: TTabelaExpiravel; const aID: Cardinal): TDateTime;
        procedure ExchangePositions(const aItem1, aItem2: Cardinal);
        function GetNextItem(const aCurrentItem: Cardinal): Cardinal;
        function GetPreviousItem(const aCurrentItem: Cardinal): Cardinal;
        procedure MoveItemToBottom(const aItemID: Cardinal);
        procedure MoveItemToTop(const aItemID: Cardinal);
        procedure CopiarItensDaPropostaPadrao(const aObra, aPropostaDeDestino: Cardinal);
        procedure AtualizarValores;
        procedure JustificativaParaObra(const aSituacaoAntiga
                                            , aSituacaoNova: Byte;
                                          out aUsuario: Integer;
                                          out aJustificativas: TBytesArray);
        procedure ExibirJustificativa(const aIN_OBRAS_ID: Cardinal);
        function ClausulaWherePorPalavras(const aVA_NOMEDAOBRA: AnsiString): String;
	protected
        procedure SetRefreshSQL(const aZQuery: TZQuery; const aDBAction: TDBAction; out aRefreshSQL: AnsiString); override;
        procedure DoNewRecord(aDataSet: TDataSet); override;
        procedure DoBeforeInsert(aDataSet: TDataSet); override;
        procedure DoBeforeEdit(aDataSet: TDataSet); override;
    	procedure DoBeforeDelete(aDataSet: TDataSet); override;
        procedure DoAfterDelete(aDataSet: TDataSet); override;
	    procedure DoBeforePost(aDataSet: TDataSet); override;
        procedure DoAfterPost(aDataSet: TDataSet); override;
        procedure DoBeforeOpen(aDataSet: TDataSet); override;
        procedure DoAfterOpen(aDataSet: TDataSet); override;
        procedure DoCustomValidate(const aSender: TObject; const aValidateAction: TValidateAction; const aValidateMoment: TValidateMoment); override;
    	procedure DoDataChange(aSender: TObject; aField: TField); override;
        procedure DoStateChange(aSender: TObject); override;
  	public
    	{ Public declarations }
        procedure ExibirJustificativa2(const aIN_OBRAS_ID: Cardinal);
        procedure ExibirComboDeSituacoes(const aSender: TObject);
        procedure LocalizarEquipamento(const aEdit: TEdit; const aFieldName: AnsiString);
        procedure TogglePropostaPadrao;
        procedure DefinirPropostaPadrao(const aIN_OBRAS_ID: Cardinal);
        procedure OBR_SCH_UpdateMetrics(const aCFDBGrid: TCFDBGrid; const aOBRFilter: TOBRFilter);
        procedure PRO_SCH_UpdateMetrics(const aCFDBGrid: TCFDBGrid; const aPROFilter: TPROFilter);
        procedure EQP_SCH_UpdateMetrics(const aCFDBGrid: TCFDBGrid; const aEQPFilter: TEQPFilter);
        procedure OBR_SCH_GotoPage(const aPageButton: TDBPageButton; aOBRFilter: TOBRFilter; const aOrderBy: AnsiString; const aPage: Word = 0);
        procedure PRO_SCH_GotoPage(const aPageButton: TDBPageButton; aPROFilter: TPROFilter; const aOrderBy: AnsiString; const aPage: Word = 0);
        procedure EQP_SCH_GotoPage(const aPageButton: TDBPageButton; aEQPFilter: TEQPFilter; const aOrderBy: AnsiString; const aPage: Word = 0);
	    procedure DBButtonClick_OBR(aDBButton: TDBButton; aComponentToFocusOnInsertAndEdit: TWinControl; aUseBookMark: Boolean = False);
        procedure DBButtonClick_OBR_SCH(aDBButton: TDBButton);
    	procedure DBButtonClick_PRO(aDBButton: TDBButton; aComponentToFocusOnInsertAndEdit: TWinControl; aUseBookMark: Boolean = False);
        procedure DBButtonClick_PRO_SCH(aDBButton: TDBButton);
        procedure DBButtonClick_EQP_SCH(aDBButton: TDBButton);
    	procedure DBButtonClick_ITE(aDBButton: TDBButton; aComponentToFocusOnInsertAndEdit: TWinControl; aUseBookMark: Boolean = False);
        procedure OBR_Information;
        procedure PRO_Information;
        procedure ITE_Information;
        procedure EDI_Infromation;
        procedure EQP_Information;
        procedure OBR_SCH_Information;
        procedure PRO_SCH_Information;
        procedure EQP_SCH_Information;
        procedure OBR_SCH_SEM_Information(const aIN_OBRAS_ID: Cardinal);
        procedure OBR_SCH_SelecionarObra;
        procedure PRO_SCH_SelecionarObra;
        procedure EQP_SCH_SelecionarObra;
        procedure OBR_SCH_SEM_SelecionarObra(const aDataSet: TDataSet);
        procedure OBR_SCH_Filtrar(const aOBRFilter: TOBRFilter; const aPageNo, aRecordsByPage: Word; const aOrderBy: AnsiString = 'IN_OBRAS_ID');
        procedure PRO_SCH_Filtrar(const aPROFilter: TPROFilter; const aPageNo, aRecordsByPage: Word; const aOrderBy: AnsiString = 'IN_PROPOSTAS_ID');
        procedure EQP_SCH_Filtrar(const aEQPFilter: TEQPFilter; const aPageNo, aRecordsByPage: Word; const aOrderBy: AnsiString = 'IN_EQUIPAMENTOSDOSITENS_ID');

        procedure AtualizarLabelDeDataDeExpiracao(const UsarRefresh: Boolean);
        procedure AdicionarJustificativas(const aIN_OBRAS_ID: Cardinal;
                                          const aJustificativas: TBytesArray);
        procedure LimparJustificativas(const aIN_OBRAS_ID: Cardinal);
        procedure DefinirNovaSituacao(const aTI_SITUACOES_ID: Byte;
                                      const aIN_OBRAS_ID: Cardinal);
        procedure PreencherComRegioes(const aItems: TStrings);
        procedure PreencherComTipos(const aItems: TStrings);
        procedure PreencherComSituacoes(const aItems: TStrings);
        procedure PreencherComProjetistas(const aItems: TStrings);
        procedure PreencherComInstaladores(const aItems: TStrings);
        procedure ObterJustificativas(const aItems: TStrings);
        function ObrasSemelhantes(const aVA_NOMEDAOBRA: AnsiString): Cardinal;
        procedure ExibirObrasSemelhantes(const aVA_NOMEDAOBRA: AnsiString);


        property OBR_SCH_RecordsByPage: Word read FOBR_SCH_RecordsByPage write FOBR_SCH_RecordsByPage;
        property OBR_SCH_CurrentPage: Word read FOBR_SCH_CurrentPage write FOBR_SCH_CurrentPage;
        property PRO_SCH_RecordsByPage: Word read FPRO_SCH_RecordsByPage write FPRO_SCH_RecordsByPage;
        property PRO_SCH_CurrentPage: Word read FPRO_SCH_CurrentPage write FPRO_SCH_CurrentPage;
        property EQP_SCH_RecordsByPage: Word read FEQP_SCH_RecordsByPage write FEQP_SCH_RecordsByPage;
        property EQP_SCH_CurrentPage: Word read FEQP_SCH_CurrentPage write FEQP_SCH_CurrentPage;
    end;

implementation

uses AnsiStrings,
    UXXXDataModule, UXXXForm_DialogTemplate,
    UBDOForm_JustificativaParaObra, UBDOForm_JustificativaSalva,
    UBDOForm_ObrasSemelhantes, ComCtrls, DateUtils;

const
  	DATA_NAO_EXPIRAVEL: TDateTime = 0;

    SQL_OBR_SEARCH_SELECT_FILTERED_RECORDS =
    '  SELECT OBR.IN_OBRAS_ID'#13#10 +
    '       , OBR.TI_REGIOES_ID'#13#10 +
    '       , OBR.TI_SITUACOES_ID'#13#10 +
    '       , OBR.VA_NOMEDAOBRA AS NOMEDAOBRA'#13#10 +
    '       , CONCAT(OBR.VA_CIDADE,'' / '',OBR.CH_ESTADO) AS LOCALIDADE'#13#10 +
    '       , REG.VA_REGIAO AS REGIAO'#13#10 +
    '       , OBR.DT_DATAEHORADACRIACAO AS DATAEHORADACRIACAO'#13#10 +
    '       , SIT.VA_DESCRICAO AS SITUACAO'#13#10 +
    '       , ELT(FNC_GET_CURRENCY_CODE_FROM_WORK(OBR.IN_OBRAS_ID),''US$'',''€'',''R$'',''£'',''¥'') AS MOEDA'#13#10 +
    '    FROM OBRAS OBR'#13#10 +
    '    JOIN REGIOES REG USING (TI_REGIOES_ID)'#13#10 +
    '    JOIN SITUACOES SIT USING (TI_SITUACOES_ID)'#13#10 +
    '   WHERE TRUE'#13#10 +
    '%s'#13#10 +
    'ORDER BY %s'#13#10 +
    '   LIMIT %u,%u';

    SQL_OBR_SEARCH_SELECT_COUNT_RECORDS =
    'SELECT COUNT(OBR.IN_OBRAS_ID)'#13#10 +
    '  FROM OBRAS OBR'#13#10 +
    '  JOIN REGIOES REG USING (TI_REGIOES_ID)'#13#10 +
    '  JOIN SITUACOES SIT USING (TI_SITUACOES_ID)'#13#10 +
    ' WHERE TRUE'#13#10 +
    '%s';

    SQL_PRO_SEARCH_SELECT_FILTERED_RECORDS =
    '  SELECT PRO.IN_PROPOSTAS_ID'#13#10 +
    '       , PRO.BO_PROPOSTAPADRAO'#13#10 +
    '       , ELT(PRO.TI_MOEDA,''US$'',''€'',''R$'',''£'',''¥'') AS MOEDA'#13#10 +
    '       , FNC_GET_PROPOSAL_CODE(PRO.IN_PROPOSTAS_ID) AS CODIGO'#13#10 +
    '       , OBR.VA_NOMEDAOBRA AS NOMEDAOBRA'#13#10 +
    '       , CONCAT(OBR.VA_CIDADE,'' / '',OBR.CH_ESTADO) AS LOCALIDADE'#13#10 +
    '       , INS.VA_NOME AS INSTALADOR'#13#10 +
    '       , SIT.VA_DESCRICAO AS SITUACAO'#13#10 +
    '    FROM PROPOSTAS PRO'#13#10 +
    '    JOIN OBRAS OBR USING (IN_OBRAS_ID)'#13#10 +
    '    JOIN INSTALADORES INS USING (SM_INSTALADORES_ID)'#13#10 +
    '    JOIN SITUACOES SIT USING (TI_SITUACOES_ID)'#13#10 +
    '   WHERE TRUE'#13#10 +
    '%s'#13#10 +
    'ORDER BY %s'#13#10 +
    '   LIMIT %u,%u';

    SQL_PRO_SEARCH_SELECT_COUNT_RECORDS =
    'SELECT COUNT(PRO.IN_PROPOSTAS_ID)'#13#10 +
    '  FROM PROPOSTAS PRO'#13#10 +
    '  JOIN OBRAS OBR USING (IN_OBRAS_ID)'#13#10 +
    '  JOIN INSTALADORES INS USING (SM_INSTALADORES_ID)'#13#10 +
    '  JOIN SITUACOES SIT USING (TI_SITUACOES_ID)'#13#10 + { * ISSO FOI COLOCADO DEPOIS! ACHO QUE TÁ CERTO }
    ' WHERE TRUE'#13#10 +
    '%s';

    SQL_EQP_SEARCH_SELECT_FILTERED_RECORDS =
    '  SELECT EDI.IN_EQUIPAMENTOSDOSITENS_ID'#13#10 +
    '       , PRO.IN_PROPOSTAS_ID'#13#10 +
    '       , EQP.VA_MODELO AS EQUIPAMENTO'#13#10 +
    '       , ITE.EN_VOLTAGEM AS VOLTAGEM'#13#10 +
    '       , ITE.IN_ITENS_ID'#13#10 +
//    '       , FNC_GET_PROPOSAL_CODE(PRO.IN_PROPOSTAS_ID) AS CODIGO'#13#10 +
    '       , OBR.VA_NOMEDAOBRA AS NOMEDAOBRA'#13#10 +
//    '       , INS.VA_NOME AS INSTALADOR'#13#10 +
//    '       , ELT(PRO.TI_MOEDA,''US$'',''€'',''R$'',''£'',''¥'') AS MOEDA'#13#10 +
    '       , PRO.BO_PROPOSTAPADRAO'#13#10 +
    '    FROM PROPOSTAS PRO'#13#10 +
    '    JOIN ITENS ITE USING (IN_PROPOSTAS_ID)'#13#10 +
    '    JOIN EQUIPAMENTOSDOSITENS EDI USING (IN_ITENS_ID)'#13#10 +
    '    JOIN EQUIPAMENTOS EQP USING (IN_EQUIPAMENTOS_ID)'#13#10 +
//    '    JOIN INSTALADORES INS USING (SM_INSTALADORES_ID)'#13#10 +
    '    JOIN OBRAS OBR USING (IN_OBRAS_ID)'#13#10 +
    '   WHERE TRUE'#13#10 +
    '%s'#13#10 +
    'ORDER BY %s'#13#10 +
    '   LIMIT %u,%u';

    SQL_EQP_SEARCH_SELECT_COUNT_RECORDS =
    'SELECT COUNT(PRO.IN_PROPOSTAS_ID)'#13#10 +
    '  FROM PROPOSTAS PRO'#13#10 +
    '  JOIN ITENS ITE USING (IN_PROPOSTAS_ID)'#13#10 +
    '  JOIN EQUIPAMENTOSDOSITENS EDI USING (IN_ITENS_ID)'#13#10 +
    '  JOIN EQUIPAMENTOS EQP USING (IN_EQUIPAMENTOS_ID)'#13#10 +
//    '  JOIN INSTALADORES INS USING (SM_INSTALADORES_ID)'#13#10 +
//    '  JOIN OBRAS OBR USING (IN_OBRAS_ID)'#13#10 +
    ' WHERE TRUE'#13#10 +
    '%s';    

resourcestring
  rs_naopodeexcluirobraexpirada = '"Não é possível excluir esta obra pois a mesma expirou em " dd/mm/yyyy';
  rs_naopodeexcluirpropostaexpirada = '"Não é possível excluir esta proposta pois a mesma pertence a uma obra expirada em " dd/mm/yyyy';
  rs_naopodeexcluiritemexpirado = '"Não é possível excluir este item pois o mesmo pertence a uma proposta de uma obra expirada em " dd/mm/yyyy';
  rs_naopodeexcluirequipamentoexpirado = '"Não é possível excluir este equipamento pois o mesmo é componente de um ítem pertencente a uma proposta de uma obra expirada em " dd/mm/yyyy';

  rs_naopodealterarobraexpirada = '"Não é possível alterar esta obra pois a mesma expirou em " dd/mm/yyyy';
  rs_naopodealterarpropostaexpirada = '"Não é possível alterar esta proposta pois a mesma pertence a uma obra expirada em " dd/mm/yyyy';
  rs_naopodealteraritemexpirado = '"Não é possível alterar este item pois o mesmo pertence a uma proposta de uma obra expirada em " dd/mm/yyyy';
  rs_naopodealterarequipamentoexpirado = '"Não é possível alterar este equipamento pois o mesmo é componente de um ítem pertencente a uma proposta de uma obra expirada em " dd/mm/yyyy';

  rs_naopodeinserirpropostaexpirada = '"Não é possível criar novas propostas para a obra atual pois a mesma expirou em " dd/mm/yyyy';
  rs_naopodeinseriritemexpirado = '"Não é possível inserir novos itens para a proposta atual pois a mesma pertence a uma obra que expirou em " dd/mm/yyyy';
  rs_naopodeinserirequipamentoexpirado = '"Não é possível incluir mais equipamentos no item atual pois o mesmo pertence a uma proposta de uma obra que expirou em " dd/mm/yyyy';


{$R *.dfm}

{ TBDODataModule_Obras }

function TBDODataModule_Obras.MyModule: TBDOForm_Obras;
begin
	Result := TBDOForm_Obras(Owner);
end;

procedure TBDODataModule_Obras.OBR_SCH_Filtrar(const aOBRFilter: TOBRFilter;
                                               const aPageNo
                                                   , aRecordsByPage: Word;
                                               const aOrderBy: AnsiString = 'IN_OBRAS_ID');
const
	SQL_CLEAR = 'DELETE FROM OBRAS_SEARCH';
    SQL_INSERT = 'INSERT INTO OBRAS_SEARCH %s';
var
	WhereClause: AnsiString;
    SQLFinal: AnsiString;
begin
    Screen.Cursor := crSQLWait;
    try
        { LIMPA A TABELA TEMPORÁRIA (VISUALMENTE NÃO ALTERA NADA) }
        ExecuteQuery(DataModuleMain.ZConnections.ByName['ZConnection_BDO'].Connection,SQL_CLEAR);

        { MONTANDO A CLÁUSULA WHERE QUE SERÁ USADA PARA FILTRAR OS DADOS }
        WhereClause := OBR_SCH_WhereClause(aOBRFilter);

        SQLFinal := AnsiStrings.Format(SQL_OBR_SEARCH_SELECT_FILTERED_RECORDS,[WhereClause,aOrderBy,GetRowOffsetByPageNo(aPageNo,aRecordsByPage),aRecordsByPage]);
        SQLFinal := AnsiStrings.Format(SQL_INSERT,[SQLFinal]);

        { PREENCHENDO A TABELA TEMPORÁRIA APENAS COM OS DADOS FILTRADOS }
        ExecuteQuery(DataModuleMain.ZConnections.ByName['ZConnection_BDO'].Connection,SQLFinal);

        { TODO -oCarlos Feitoza -cEXPLICAÇÃO : Para que nenhum erro de bookmark
        aconteça é necessário desativar os controles associados antes de
        executar um refresh }
        OBRAS_SEARCH.DisableControls;
        { FINALMENTE, ATUALIZANDO A QUERY CORRESPONDENTE...}
        OBRAS_SEARCH.Refresh; { isso pode demorar um pouco... }
    finally
        OBRAS_SEARCH.EnableControls;
        Screen.Cursor := crDefault;
    end;
end;

procedure TBDODataModule_Obras.PRO_SCH_Filtrar(const aPROFilter: TPROFilter;
                                               const aPageNo
                                                   , aRecordsByPage: Word;
                                               const aOrderBy: AnsiString = 'IN_PROPOSTAS_ID');
const
	SQL_CLEAR = 'DELETE FROM PROPOSTAS_SEARCH';
    SQL_INSERT = 'INSERT INTO PROPOSTAS_SEARCH %s';
var
	WhereClause: AnsiString;
    SQLFinal: AnsiString;
begin
    Screen.Cursor := crSQLWait;
    try
        { LIMPA A TABELA TEMPORÁRIA (VISUALMENTE NÃO ALTERA NADA) }
        ExecuteQuery(DataModuleMain.ZConnections.ByName['ZConnection_BDO'].Connection,SQL_CLEAR);

        { MONTANDO A CLÁUSULA WHERE QUE SERÁ USADA PARA FILTRAR OS DADOS }
        WhereClause := PRO_SCH_WhereClause(aPROFilter);

        SQLFinal := AnsiStrings.Format(SQL_PRO_SEARCH_SELECT_FILTERED_RECORDS,[WhereClause,aOrderBy,GetRowOffsetByPageNo(aPageNo,aRecordsByPage),aRecordsByPage]);
        SQLFinal := AnsiStrings.Format(SQL_INSERT,[SQLFinal]);

        { PREENCHENDO A TABELA TEMPORÁRIA APENAS COM OS DADOS FILTRADOS }
        ExecuteQuery(DataModuleMain.ZConnections.ByName['ZConnection_BDO'].Connection,SQLFinal);

        { TODO -oCarlos Feitoza -cEXPLICAÇÃO : Para que nenhum erro de bookmark
        aconteça é necessário desativar os controles associados antes de
        executar um refresh }
        PROPOSTAS_SEARCH.DisableControls;

        { FINALMENTE, ATUALIZANDO A QUERY CORRESPONDENTE...}
        PROPOSTAS_SEARCH.Refresh; { Isso pode demorar um pouco }
    finally
        PROPOSTAS_SEARCH.EnableControls;
        Screen.Cursor := crDefault;
    end;
end;

procedure TBDODataModule_Obras.OBR_SCH_GotoPage(const aPageButton: TDBPageButton; aOBRFilter: TOBRFilter; const aOrderBy: AnsiString; const aPage: Word = 0);
begin
    case aPageButton of
        dpbFirst: FOBR_SCH_CurrentPage := 1;
        dpbPrevious: Dec(FOBR_SCH_CurrentPage);
        dpbNext: Inc(FOBR_SCH_CurrentPage);
        dpbLast: FOBR_SCH_CurrentPage := OBR_SCH_PageCount;
        dpbCustom: FOBR_SCH_CurrentPage := aPage;
    end;
    OBR_SCH_Filtrar(aOBRFilter,FOBR_SCH_CurrentPage,FOBR_SCH_RecordsByPage,aOrderBy);
end;

procedure TBDODataModule_Obras.OBR_SCH_Information;
begin
    ShowRecordInformationForm(DataModuleMain.ZConnections.ByName['ZConnection_BDO'].Connection,'OBRAS','IN_OBRAS_ID',OBRAS_SEARCHIN_OBRAS_ID.AsInteger);
end;

procedure TBDODataModule_Obras.PRO_SCH_GotoPage(const aPageButton: TDBPageButton; aPROFilter: TPROFilter; const aOrderBy: AnsiString; const aPage: Word = 0);
begin
    case aPageButton of
        dpbFirst: FPRO_SCH_CurrentPage := 1;
        dpbPrevious: Dec(FPRO_SCH_CurrentPage);
        dpbNext: Inc(FPRO_SCH_CurrentPage);
        dpbLast: FPRO_SCH_CurrentPage := PRO_SCH_PageCount;
        dpbCustom: FPRO_SCH_CurrentPage := aPage;
    end;
    PRO_SCH_Filtrar(aPROFilter,FPRO_SCH_CurrentPage,FPRO_SCH_RecordsByPage,aOrderBy);
end;

procedure TBDODataModule_Obras.PRO_SCH_Information;
begin
    ShowRecordInformationForm(DataModuleMain.ZConnections.ByName['ZConnection_BDO'].Connection
                             ,'PROPOSTAS'
                             ,'IN_PROPOSTAS_ID'
                             ,PROPOSTAS_SEARCHIN_PROPOSTAS_ID.AsInteger);
end;

procedure TBDODataModule_Obras.OBRASTI_MESPROVAVELDEENTREGAGetText(Sender: TField; var Text: string; DisplayText: Boolean);
begin
    inherited;
    Text := MONTH_NAMES[Sender.AsInteger];
end;

procedure TBDODataModule_Obras.OBRASTI_MESPROVAVELDEENTREGASetText(Sender: TField; const Text: string);
var
	i: Byte;
begin
	inherited;
    for i := 1 to High(MONTH_NAMES) do
    	if Text = MONTH_NAMES[i] then
        begin
	        Sender.AsInteger := i;
            Break;
        end;
end;

procedure TBDODataModule_Obras.OBR_Information;
begin
    ShowRecordInformationForm(DataModuleMain.ZConnections.ByName['ZConnection_BDO'].Connection
                             ,'OBRAS'
                             ,'IN_OBRAS_ID'
                             ,OBRASIN_OBRAS_ID.AsInteger);
end;

procedure TBDODataModule_Obras.OBR_SCH_SEM_Information(const aIN_OBRAS_ID: Cardinal);
begin
    ShowRecordInformationForm(DataModuleMain.ZConnections.ByName['ZConnection_BDO'].Connection
                             ,'OBRAS'
                             ,'IN_OBRAS_ID'
                             ,aIN_OBRAS_ID);
end;

procedure TBDODataModule_Obras.OBR_SCH_SEM_SelecionarObra(const aDataSet: TDataSet);
begin
    if OBRAS.Active
   and aDataSet.Active then
  	    if RegiaoPermitidaParaOUsuario(Configurations.AuthenticatedUser.Id,aDataSet.FieldByName('TI_REGIOES_ID').AsInteger) then
        begin
            if aDataSet.RecordCount > 0 then
            begin
                ShowCancelQuestion := False;
                OBRAS.Cancel;
                OBRAS.Refresh; // Garante que todas as obras estejam disponívis
                OBRAS.Locate('IN_OBRAS_ID',aDataSet.FieldByName('IN_OBRAS_ID').AsInteger,[]); // Seleciona a obra para exibição
            end;
        end
        else
        begin
    	    Application.MessageBox('Você não pode abrir esta obra pois ela não ' +
            'pertence a nenhuma de suas regiões de atuação. Caso esta seja real' +
            'mente a obra que você está tentando digitar, por favor entre em co' +
            'ntato com a região da mesma para maiores esclarecimentos','Não é possível abrir a obra',MB_ICONWARNING);
            Abort;
        end;
end;

procedure TBDODataModule_Obras.ExibirComboDeSituacoes(const aSender: TObject);
var
	IndiceDoObjeto: Byte;
begin
    inherited;
    if aSender = MyModule.CFDBGrid_OBR_SCH then
    begin
        if (OBRAS_SEARCH.RecordCount > 0) and RegiaoPermitidaParaOUsuario(Configurations.AuthenticatedUser.Id,OBRAS_SEARCHTI_REGIOES_ID.AsInteger) then
        begin
            IndiceDoObjeto := MyModule.ComboBox_OBR_SCH_TI_SITUACOES_ID.Items.IndexOfObject(TObject(OBRAS_SEARCHTI_SITUACOES_ID.AsInteger));
            MyModule.ComboBox_OBR_SCH_TI_SITUACOES_ID.ItemIndex := IndiceDoObjeto;
            MyModule.ComboBox_OBR_SCH_TI_SITUACOES_ID.Show;
        end;
    end
    else if aSender = MyModule.CFDBGrid_PRO_SCH then
    begin
        if (PROPOSTAS_SEARCH.RecordCount > 0) and RegiaoPermitidaParaOUsuario(Configurations.AuthenticatedUser.Id,RegiaoDaProposta(PROPOSTAS_SEARCHIN_PROPOSTAS_ID.AsInteger)) then
        begin
            IndiceDoObjeto := MyModule.ComboBox_PRO_SCH_TI_SITUACOES_ID.Items.IndexOfObject(TObject(SituacaoDaProposta(PROPOSTAS_SEARCHIN_PROPOSTAS_ID.AsInteger)));
            MyModule.ComboBox_PRO_SCH_TI_SITUACOES_ID.ItemIndex := IndiceDoObjeto;
            MyModule.ComboBox_PRO_SCH_TI_SITUACOES_ID.Show;
        end;
    end;
end;

procedure TBDODataModule_Obras.Action_PRO_GerarPropostaExecute(Sender: TObject);
var
    Regiao: Byte;
    Valor: Currency;
    PropostaID: Cardinal;
    Mensagem1, Mensagem2: String;
begin
    inherited;
    Regiao := 0;
    Valor := 0.0;
    PropostaID := 0;

    Mensagem1 := 'Esta proposta não possui itens com equipamentos. Você não pode gerar sua impressão';
    Mensagem2 := 'Você não pode gerar a impressão desta proposta pois ela não pertence a nenhuma de suas regiões de atuação';

    case TAction(Sender).ActionComponent.Tag of
        0: begin { Tela de consulta de obras }
            if OBRAS_SEARCH.Active
            and PROPOSTAS.Active then
            begin
                Regiao := OBRAS_SEARCHTI_REGIOES_ID.AsInteger;
                Valor := ValorDaObra(OBRAS_SEARCHIN_OBRAS_ID.AsInteger,True,'');
                PropostaID := PropostaPadrao(OBRAS_SEARCHIN_OBRAS_ID.AsInteger);
                Mensagem1 := 'Esta obra não possui proposta padrão ou seus itens não contém equipamentos. Você não pode gerar impressão';
                Mensagem2 := 'Você não pode gerar a impressão da proposta padrão desta obra pois ela não pertence a nenhuma de suas regiões de atuação';
            end
            else
                Exit;
        end;
        1: begin { Tela de consulta de propostas }
            if PROPOSTAS_SEARCH.Active
            and PROPOSTAS.Active then
            begin
                Regiao := RegiaoDaProposta(PROPOSTAS_SEARCHIN_PROPOSTAS_ID.AsInteger);
                Valor := ValorDaProposta(PROPOSTAS_SEARCHIN_PROPOSTAS_ID.AsInteger,False,True,'');
                PropostaID := PROPOSTAS_SEARCHIN_PROPOSTAS_ID.AsInteger;
            end
            else
                Exit;
        end;
        2: begin { Tela de cadastro de obras e propostas }
            if PROPOSTAS.Active then
            begin
                Regiao := RegiaoDaProposta(PROPOSTASIN_PROPOSTAS_ID.AsInteger);
                Valor := ValorDaProposta(PROPOSTASIN_PROPOSTAS_ID.AsInteger,False,True,'');
                PropostaID := PROPOSTASIN_PROPOSTAS_ID.AsInteger;
            end
            else
                Exit;
        end;
    end;

    if RegiaoPermitidaParaOUsuario(Configurations.AuthenticatedUser.Id,Regiao) then
    begin
        if Valor > 0 then
            ExibirGeradorDeProposta(PropostaID)
        else
            Application.MessageBox(PChar(Mensagem1),'Geração não permitida',MB_ICONWARNING);
    end
    else
        Application.MessageBox(PChar(Mensagem2),'Geração não permitida',MB_ICONWARNING);
end;

procedure TBDODataModule_Obras.OBR_SCH_SelecionarObra;
begin
    if OBRAS.Active
   and OBRAS_SEARCH.Active then
  	    if RegiaoPermitidaParaOUsuario(Configurations.AuthenticatedUser.Id,OBRAS_SEARCHTI_REGIOES_ID.AsInteger) then
        begin
            if OBRAS_SEARCH.RecordCount > 0 then
            begin
                OBRAS.Refresh; // Garante que todas as obras estejam disponívis
                OBRAS.Locate('IN_OBRAS_ID',OBRAS_SEARCHIN_OBRAS_ID.AsInteger,[]); // Seleciona a obra para exibição
            end
            else
            begin
                Application.MessageBox('A sua última consulta não gerou resultado algum. Não é possível exibir mais detalhes','Detalhes indisponíveis',MB_ICONWARNING);
                Abort;
            end;
        end
        else
        begin
    	    Application.MessageBox('Você não pode exibir mais detalhes desta obra pois ela não pertence a nenhuma de suas regiões de atuação','Detalhes adicionais não disponíveis',MB_ICONWARNING);
            Abort;
        end;
end;

procedure TBDODataModule_Obras.PRO_SCH_SelecionarObra;
begin
    inherited;
    if OBRAS.Active
   and PROPOSTAS_SEARCH.Active
   and PROPOSTAS.Active then
        if RegiaoPermitidaParaOUsuario(Configurations.AuthenticatedUser.Id,RegiaoDaProposta(PROPOSTAS_SEARCHIN_PROPOSTAS_ID.AsInteger)) then
        begin
            if PROPOSTAS_SEARCH.RecordCount > 0 then
            begin
                OBRAS.Refresh; // Garante que todas as obras estejam disponívis
                OBRAS.Locate('IN_OBRAS_ID',ObraDaProposta(PROPOSTAS_SEARCHIN_PROPOSTAS_ID.AsInteger),[]); // Seleciona a obra para exibição
                PROPOSTAS.Refresh;  // Idem
                PROPOSTAS.Locate('IN_PROPOSTAS_ID',PROPOSTAS_SEARCHIN_PROPOSTAS_ID.AsInteger,[]); // Idem
            end
            else
            begin
               Application.MessageBox('A sua última consulta não gerou resultado algum. Não é possível exibir mais detalhes','Detalhes indisponíveis',MB_ICONWARNING);
               Abort;
            end;
        end
        else
        begin
    	    Application.MessageBox('Você não pode exibir mais detalhes desta proposta pois ela não pertence a nenhuma de suas regiões de atuação','Detalhes adicionais não disponíveis',MB_ICONWARNING);
            Abort;
        end;
end;

///<author>Carlos Feitoza Filho</author>
///    Este procedure recalcula os parâmetros variáveis da consulta usando como
///    base o CFDBGrid passado como parâmetro. Ele também é responsável por
///    validar alguns parâmetros, de forma que estes sejam sempre coerentes. Use
///    esta função sempre que necessário antes de usar qualquer um dos
///    parâmetros de pesquisa que ela valida ou retorna
procedure TBDODataModule_Obras.OBR_SCH_UpdateMetrics(const aCFDBGrid: TCFDBGrid; const aOBRFilter: TOBRFilter);
begin
    GetPageAndRecordMetrics(aCFDBGrid
                           ,0                      { Ou cálculo para obter o offset... }
                           ,FOBR_SCH_RecordsByPage { Sempre é calculado... }
                           ,OBR_SCH_PageCount      { Sempre é calculado... }
                           ,FOBR_SCH_CurrentPage   { Apenas para validação... }
                           ,OBR_SCH_RecordCount    { Pode ou não ser alterado, desde que haja um SQL de contagem... }
                           ,Format(SQL_OBR_SEARCH_SELECT_COUNT_RECORDS,[OBR_SCH_WhereClause(aOBRFilter)]));
end;

procedure TBDODataModule_Obras.PRO_SCH_UpdateMetrics(const aCFDBGrid: TCFDBGrid; const aPROFilter: TPROFilter);
begin
    GetPageAndRecordMetrics(aCFDBGrid
                           ,0                      { Ou cálculo para obter o offset... }
                           ,FPRO_SCH_RecordsByPage { Sempre é calculado... }
                           ,PRO_SCH_PageCount      { Sempre é calculado... }
                           ,FPRO_SCH_CurrentPage   { Apenas para validação... }
                           ,PRO_SCH_RecordCount    { Pode ou não ser alterado, desde que haja um SQL de contagem... }
                           ,Format(SQL_PRO_SEARCH_SELECT_COUNT_RECORDS,[PRO_SCH_WhereClause(aPROFilter)]));
end;

function TBDODataModule_Obras.OBR_SCH_WhereClause(const aOBRFilter: TOBRFilter): AnsiString;
begin
    Result := '';
    with aOBRFilter do
    begin
        if Trim(VA_NOMEDAOBRA) <> '' then
            Result := Result + '     AND UPPER(OBR.VA_NOMEDAOBRA) LIKE UPPER(' + QuotedStr(VA_NOMEDAOBRA) + ')'#13#10;

        if Trim(VA_CIDADE) <> '' then
          	Result := Result + '     AND UPPER(OBR.VA_CIDADE) LIKE UPPER(' + QuotedStr(VA_CIDADE) + ')'#13#10;

        if Trim(CH_ESTADO) <> '' then
         	Result := Result + '     AND UPPER(OBR.CH_ESTADO) LIKE UPPER(' + QuotedStr(CH_ESTADO) + ')'#13#10;

        if TI_REGIOES_ID > 0 then
           	Result := Result + '     AND OBR.TI_REGIOES_ID = ' + IntToStr(TI_REGIOES_ID) + #13#10;

  		if (DA_DATADEENTRADA_I > 0) and (DA_DATADEENTRADA_F > 0) then
        begin
            if DA_DATADEENTRADA_I > DA_DATADEENTRADA_F then
              	raise Exception.Create('A data de entrada final é menor que a data de entrada inicial. Por favor corrija as datas.')
      	    else
                Result := Result + '     AND OBR.DT_DATAEHORADACRIACAO BETWEEN ' + QuotedStr(FormatDateTime('yyyy-mm-dd 00:00:00',DA_DATADEENTRADA_I)) + ' AND ' + QuotedStr(FormatDateTime('yyyy-mm-dd 23:59:59',DA_DATADEENTRADA_F)) + #13#10;
   		end
        else if DA_DATADEENTRADA_I > 0 then
          	Result := Result + '     AND OBR.DT_DATAEHORADACRIACAO >= ' + QuotedStr(FormatDateTime('yyyy-mm-dd 00:00:00',DA_DATADEENTRADA_I)) + #13#10
    	else if DA_DATADEENTRADA_F > 0 then
           	Result := Result + '     AND OBR.DT_DATAEHORADACRIACAO <= ' + QuotedStr(FormatDateTime('yyyy-mm-dd 23:59:59',DA_DATADEENTRADA_F)) + #13#10;

    	if TI_TIPOS_ID > 0 then
            Result := Result + '     AND OBR.TI_TIPOS_ID = ' + IntToStr(TI_TIPOS_ID) + #13#10;

        if TI_SITUACOES_ID > 0 then
          	Result := Result + '     AND OBR.TI_SITUACOES_ID = ' + IntToStr(TI_SITUACOES_ID) + #13#10;

        if Trim(VA_CONSTRUTORA) <> '' then
           	Result := Result + '     AND UPPER(OBR.VA_CONSTRUTORA) LIKE UPPER(' + QuotedStr(VA_CONSTRUTORA) + ')' + #13#10;

        if SM_PROJETISTAS_ID > 0 then
            Result := Result + '     AND OBR.SM_PROJETISTAS_ID = ' + IntToStr(SM_PROJETISTAS_ID) + #13#10;

        case ComPropostas of
            'S': Result := Result + '     AND FNC_GET_PROPOSAL_COUNT(OBR.IN_OBRAS_ID) > 0'#13#10;
            'N': Result := Result + '     AND FNC_GET_PROPOSAL_COUNT(OBR.IN_OBRAS_ID) = 0'#13#10;
            //'X': não precisa verificar, simplesmente não inclui...
        end;

      	Result := StringReplace(Result,'*','%',[rfReplaceAll]);
       	Result := StringReplace(Result,'?','_',[rfReplaceAll]);
    end;
end;

function TBDODataModule_Obras.PRO_SCH_WhereClause(const aPROFilter: TPROFilter): AnsiString;
begin
    Result := '';
    with aPROFilter do
    begin
        if Trim(VA_CONTATO) <> '' then
            Result := Result + '     AND UPPER(PRO.VA_CONTATO) LIKE UPPER(' + QuotedStr(VA_CONTATO) + ')'#13#10;

        if Trim(VA_NOMEDAOBRA) <> '' then
          	Result := Result + '     AND UPPER(OBR.VA_NOMEDAOBRA) LIKE UPPER(' + QuotedStr(VA_NOMEDAOBRA) + ')'#13#10;

        if SM_CODIGO > 0 then
           	Result := Result + '     AND PRO.SM_CODIGO = ' + IntToStr(SM_CODIGO) + #13#10;

        if YR_ANO > 0 then
           	Result := Result + '     AND PRO.YR_ANO = ' + IntToStr(YR_ANO) + #13#10;

        if BO_PROPOSTAPADRAO <> 2 then
            Result := Result + '     AND PRO.BO_PROPOSTAPADRAO = ' + IntToStr(BO_PROPOSTAPADRAO) + #13#10;

        if SM_INSTALADORES_ID > 0 then
           	Result := Result + '     AND PRO.SM_INSTALADORES_ID = ' + IntToStr(SM_INSTALADORES_ID) + #13#10;

      	Result := StringReplace(Result,'*','%',[rfReplaceAll]);
       	Result := StringReplace(Result,'?','_',[rfReplaceAll]);
    end;
end;

procedure TBDODataModule_Obras.SetRefreshSQL(const aZQuery: TZQuery; const aDBAction: TDBAction; out aRefreshSQL: AnsiString);
begin
    inherited;
    if aZQuery = OBRAS then
        case aDBAction of
            dbaBeforeInsert: aRefreshSQL :=
                             'SELECT IN_OBRAS_ID'#13#10 +
                             '  FROM OBRAS'#13#10 +
                             ' WHERE IN_OBRAS_ID = LAST_INSERT_ID()';
            dbaBeforeEdit: aRefreshSQL :=
                           'SELECT IN_OBRAS_ID'#13#10 +
                           '     , TX_CONDICOESGERAIS'#13#10 +
                           '  FROM OBRAS'#13#10 +
                           ' WHERE IN_OBRAS_ID = :OLD_IN_OBRAS_ID';
        end
    else if aZQuery = PROPOSTAS then
    begin
        aRefreshSQL :=
        'SELECT PRO.IN_PROPOSTAS_ID'#13#10 +
        '     , PRO.DT_DATAEHORADACRIACAO'#13#10 +
        '     , FNC_GET_PROPOSAL_CODE(PRO.IN_PROPOSTAS_ID) AS CODIGO'#13#10 +
        '     , INS.VA_NOME AS INSTALADOR'#13#10 +
        '     , FNC_GET_FORMATTED_CURRENCY_VALUE(FNC_GET_PROPOSAL_VALUE(PRO.IN_PROPOSTAS_ID,TRUE,TRUE,NULL,2),ELT(PRO.TI_MOEDA,''US$'',''€'',''R$'',''£'',''¥''),FALSE) AS SUBTOTAL'#13#10 +
        '     , FNC_GET_FORMATTED_PROPOSAL_REAJUST(PRO.IN_PROPOSTAS_ID,ELT(PRO.TI_MOEDA,''US$'',''€'',''R$'',''£'',''¥'')) AS REAJUSTE'#13#10 +
        '     , FNC_GET_FORMATTED_CURRENCY_VALUE(FNC_GET_PROPOSAL_VALUE(PRO.IN_PROPOSTAS_ID,FALSE,TRUE,NULL,2),ELT(PRO.TI_MOEDA,''US$'',''€'',''R$'',''£'',''¥''),FALSE) AS TOTAL'#13#10 +
        '     , BO_PROPOSTAPADRAO'#13#10 +
        '  FROM PROPOSTAS PRO'#13#10 +
        '  JOIN INSTALADORES INS USING(SM_INSTALADORES_ID)'#13#10;
        case aDBAction of
            dbaBeforeInsert: aRefreshSQL := aRefreshSQL +
                             ' WHERE PRO.IN_PROPOSTAS_ID = LAST_INSERT_ID()';
            dbaBeforeEdit: aRefreshSQL := aRefreshSQL +
                           ' WHERE PRO.IN_PROPOSTAS_ID = :OLD_IN_PROPOSTAS_ID';
        end;
    end
    else if aZQuery = ITENS then
    begin
        aRefreshSQL :=
        'SELECT ITE.IN_ITENS_ID'#13#10 +
        '     , FAM.VA_DESCRICAO AS FAMILIA'#13#10 +
        '     , FNC_GET_FORMATTED_CAPACITY(ITE.FL_CAPACIDADE,UNI.VA_ABREVIATURA) AS CAPACIDADE'#13#10 +
        '     , FNC_GET_FORMATTED_CURRENCY_VALUE(FNC_GET_ITEM_VALUE(ITE.IN_ITENS_ID,TRUE,FALSE,NULL,2), ELT(FNC_GET_CURRENCY_CODE(ITE.IN_ITENS_ID),''US$'',''€'',''R$'',''£'',''¥''),FALSE) AS SUBTOTAL'#13#10 +
        '     , FNC_GET_FORMATTED_PERCENTUAL(ITE.FL_DESCONTOPERC,TRUE) AS REAJUSTE'#13#10 +
        '     , FNC_GET_FORMATTED_CURRENCY_VALUE(FNC_GET_ITEM_VALUE(ITE.IN_ITENS_ID,FALSE,FALSE,NULL,2),ELT(FNC_GET_CURRENCY_CODE(ITE.IN_ITENS_ID),''US$'',''€'',''R$'',''£'',''¥''),FALSE) AS TOTAL'#13#10 +
        '     , FNC_GET_FORMATTED_PERCENTUAL(FNC_GET_BRUTE_PROFIT(ITE.IN_ITENS_ID),FALSE) AS LUCROBRUTOFMT'#13#10 +
        '  FROM ITENS ITE'#13#10 +
        '  JOIN FAMILIAS FAM USING (TI_FAMILIAS_ID)'#13#10 +
        '  JOIN UNIDADES UNI USING (TI_UNIDADES_ID)'#13#10;
        case aDBAction of
            dbaBeforeInsert: aRefreshSQL := aRefreshSQL +
                             ' WHERE ITE.IN_ITENS_ID = LAST_INSERT_ID()';
            dbaBeforeEdit: aRefreshSQL := aRefreshSQL +
                           ' WHERE ITE.IN_ITENS_ID = :OLD_IN_ITENS_ID';
        end;
    end
//    else if aZQuery = EQUIPAMENTOSDOSITENS then
//    begin
//        UpdateSQL_EDI.RefreshSQL.Text :=
//        'SELECT EDI.IN_EQUIPAMENTOSDOSITENS_ID'#13#10 +
//        '     , EQP.VA_MODELO AS MODELO'#13#10 +
//        '     , FNC_GET_FORMATTED_CURRENCY_VALUE((FNC_GET_ICMS_MULTIPLIER(OBR.IN_OBRAS_ID) * EDI.FL_VALORUNITARIO),ELT(EDI.TI_MOEDA,''US$'',''€'',''R$'',''£'',''¥''),FALSE) AS VALORCOMIMPOSTOS'#13#10 +
//        '     , FNC_GET_FORMATTED_PERCENTUAL(EDI.FL_LUCROBRUTO,FALSE) AS LUCROBRUTO'#13#10 +
//        '  FROM EQUIPAMENTOSDOSITENS EDI'#13#10 +
//        '  JOIN EQUIPAMENTOS EQP USING (IN_EQUIPAMENTOS_ID)'#13#10 +
//        '  JOIN ITENS ITE USING (IN_ITENS_ID)'#13#10 +
//        '  JOIN PROPOSTAS PRO USING (IN_PROPOSTAS_ID)'#13#10 +
//        '  JOIN OBRAS OBR USING (IN_OBRAS_ID)'#13#10;
//        case aDBAction of
//            dbaBeforeInsert: UpdateSQL_EDI.RefreshSQL.Text := UpdateSQL_EDI.RefreshSQL.Text +
//                             ' WHERE IN_EQUIPAMENTOSDOSITENS_ID = LAST_INSERT_ID()';
//            dbaBeforeEdit: UpdateSQL_EDI.RefreshSQL.Text := UpdateSQL_EDI.RefreshSQL.Text +
//                             ' WHERE IN_EQUIPAMENTOSDOSITENS_ID = :OLD_IN_EQUIPAMENTOSDOSITENS_ID';
//        end;
//    end;
end;

procedure TBDODataModule_Obras.TogglePropostaPadrao;
var
    BS: TBookmark;
begin
  	inherited;
    DoBeforeEdit(PROPOSTAS);
  	if PROPOSTASBO_PROPOSTAPADRAO.AsInteger = 0 then
    begin
        ExecuteDbProcedure(DataModuleMain.ZConnections.ByName['ZConnection_BDO'].Connection
                          ,'PRC_SET_DEFAULT_PROPOSAL(' + PROPOSTASIN_PROPOSTAS_ID.AsString + ')');

        BS := PROPOSTAS.Bookmark;
        try
            PROPOSTAS.DisableControls;
            PROPOSTAS.Refresh;
        finally
            PROPOSTAS.Bookmark := BS;
            PROPOSTAS.EnableControls;
        end;
    end;
end;

procedure TBDODataModule_Obras.PopupActionBar_RecordInformationPopup(Sender: TObject);
begin
    inherited;
    Action_Justificativa.Visible := (PopupActionBar_RecordInformation.PopupComponent = MyModule.CFDBGrid_OBR_SCH)
                                 or (PopupActionBar_RecordInformation.PopupComponent = MyModule.CFDBGrid_PRO_SCH);

    Action_Justificativa.Enabled := TCFDBGrid(PopupActionBar_RecordInformation.PopupComponent).DataSource.DataSet.RecordCount > 0;
    Action_RecordInformation.Enabled := TCFDBGrid(PopupActionBar_RecordInformation.PopupComponent).DataSource.DataSet.RecordCount > 0;
end;

procedure TBDODataModule_Obras.PreencherComInstaladores(const aItems: TStrings);
var
    BS: TBookmark;
begin
    aItems.Clear;

    if not INSTALADORES_LOOKUP.Active then
        Exit;

    try
        BS := INSTALADORES_LOOKUP.Bookmark;
        aItems.AddObject('(TODOS)',TObject(0));
        INSTALADORES_LOOKUP.First;
        while not INSTALADORES_LOOKUP.Eof do
        begin
            aItems.AddObject(INSTALADORES_LOOKUPVA_NOME.AsString,TObject(INSTALADORES_LOOKUPSM_INSTALADORES_ID.AsInteger));
            INSTALADORES_LOOKUP.Next;
        end;
    finally
        INSTALADORES_LOOKUP.Bookmark := BS;
    end;
end;

procedure TBDODataModule_Obras.ObterJustificativas(const aItems: TStrings);
const
    SQL =
    'SELECT TI_JUSTIFICATIVAS_ID'#13#10 +
    '     , CASE EN_CATEGORIA WHEN ''C'' THEN ''COMERCIAL'' WHEN ''T'' THEN ''TÉCNICA'' ELSE ''N/A'' END'#13#10 +
    '     , VA_JUSTIFICATIVA'#13#10 +
    '  FROM JUSTIFICATIVAS';

var
    RODataSet: TZReadOnlyQuery;
begin
    aItems.Clear;
    RODataSet := nil;
    try
        ConfigureDataSet(DataModuleMain.ZConnections.ByName['ZConnection_BDO'].Connection
                        ,RODataSet
                        ,SQL);

        if Assigned(RODataSet) then
        begin
            RODataSet.First;
            while not RODataSet.Eof do
            begin
                aItems.AddObject(RODataSet.Fields[1].AsString + '|' + RODataSet.Fields[2].AsString,TObject(RODataSet.Fields[0].AsInteger));
                RODataSet.Next;
            end;
        end;
    finally
        if Assigned(RODataSet) then
            RODataSet.Free
    end;
end;

//procedure TBDODataModule_Obras.ObterObras(const aItems: TStrings);
//begin
//    aItems.Clear;
//    OBRAS_LOOKUP.Refresh;
//    OBRAS_LOOKUP.First;
//    while not OBRAS_LOOKUP.Eof do
//    begin
//        aItems.Add(OBRAS_LOOKUP.Fields[0].AsString);
//        OBRAS_LOOKUP.Next;
//    end;
//end;

procedure TBDODataModule_Obras.PreencherComProjetistas(const aItems: TStrings);
var
    BS: TBookmark;
begin
    aItems.Clear;

    if not PROJETISTAS_LOOKUP.Active then
        Exit;

    try
        BS := PROJETISTAS_LOOKUP.Bookmark;
        aItems.AddObject('(TODOS)',TObject(0));
        PROJETISTAS_LOOKUP.First;
        while not PROJETISTAS_LOOKUP.Eof do
        begin
            aItems.AddObject(PROJETISTAS_LOOKUPVA_NOME.AsString,TObject(PROJETISTAS_LOOKUPSM_PROJETISTAS_ID.AsInteger));
            PROJETISTAS_LOOKUP.Next;
        end;
    finally
        PROJETISTAS_LOOKUP.Bookmark := BS;
    end;
end;

procedure TBDODataModule_Obras.PreencherComRegioes(const aItems: TStrings);
var
    BS: TBookmark;
begin
    aItems.Clear;

    if not REGIOES_LOOKUP.Active then
        Exit;

    try
        BS := REGIOES_LOOKUP.Bookmark;
        aItems.AddObject('(TODAS)',TObject(0));
        REGIOES_LOOKUP.First;
        while not REGIOES_LOOKUP.Eof do
        begin
            aItems.AddObject(REGIOES_LOOKUPVA_REGIAO.AsString,TObject(REGIOES_LOOKUPTI_REGIOES_ID.AsInteger));
            REGIOES_LOOKUP.Next;           
        end;
    finally
        REGIOES_LOOKUP.Bookmark := BS;
    end;
end;

procedure TBDODataModule_Obras.PreencherComSituacoes(const aItems: TStrings);
var
    BS: TBookmark;
begin
    aItems.Clear;

    if not SITUACOES_LOOKUP.Active then
        Exit;

    try
        BS := SITUACOES_LOOKUP.Bookmark;
        aItems.AddObject('(TODAS)',TObject(0));
        SITUACOES_LOOKUP.First;
        while not SITUACOES_LOOKUP.Eof do
        begin
            aItems.AddObject(SITUACOES_LOOKUPVA_DESCRICAO.AsString,TObject(SITUACOES_LOOKUPTI_SITUACOES_ID.AsInteger));
            SITUACOES_LOOKUP.Next;
        end;
    finally
        SITUACOES_LOOKUP.Bookmark := BS;
    end;
end;

procedure TBDODataModule_Obras.PreencherComTipos(const aItems: TStrings);
var
    BS: TBookmark;
begin
    aItems.Clear;

    if not TIPOS_LOOKUP.Active then
        Exit;

    try
        BS := TIPOS_LOOKUP.Bookmark;
        aItems.AddObject('(TODOS)',TObject(0));
        TIPOS_LOOKUP.First;
        while not TIPOS_LOOKUP.Eof do
        begin
            aItems.AddObject(TIPOS_LOOKUPVA_DESCRICAO.AsString,TObject(TIPOS_LOOKUPTI_TIPOS_ID.AsInteger));
            TIPOS_LOOKUP.Next;
        end;
    finally
        TIPOS_LOOKUP.Bookmark := BS;
    end;
end;

procedure TBDODataModule_Obras.PROPOSTASTI_MOEDAGetText(Sender: TField; var Text: string; DisplayText: Boolean);
begin
    inherited;
    if Sender.AsInteger > 0 then
        Text := CURRENCY_STRINGS[Sender.AsInteger];
end;

procedure TBDODataModule_Obras.PROPOSTASTI_MOEDASetText(Sender: TField; const Text: string);
var
    i: Byte;
begin
    inherited;
    for i := 1 to High(CURRENCY_STRINGS) do
    	if Text = CURRENCY_STRINGS[i] then
        begin
	        Sender.AsInteger := i;
            Break;
        end;
end;

procedure TBDODataModule_Obras.PROPOSTASTI_VALIDADEGetText(Sender: TField; var Text: string; DisplayText: Boolean);
begin
    inherited;
    if not Sender.IsNull then
    begin
        Text := IntToStr(Sender.AsInteger);
        if DisplayText then
            Text := Text + ' dias';
    end
    else
        Text := 'N/A';
end;

procedure TBDODataModule_Obras.PRO_Information;
begin
    ShowRecordInformationForm(DataModuleMain.ZConnections.ByName['ZConnection_BDO'].Connection
                             ,'PROPOSTAS'
                             ,'IN_PROPOSTAS_ID'
                             ,PROPOSTASIN_PROPOSTAS_ID.AsInteger);
end;

procedure TBDODataModule_Obras.Action_EDI_DeleteExecute(Sender: TObject);
const
    EDI_DELETE_SQL =
    'DELETE'#13#10 +
    '  FROM EQUIPAMENTOSDOSITENS'#13#10 +
    ' WHERE IN_EQUIPAMENTOSDOSITENS_ID IN (%s)';
var
	i: Word;
	ChavesAExcluir: String;
begin
    inherited;
    ShowDeleteQuestion := False;
    DoBeforeDelete(EQUIPAMENTOSDOSITENS);

	if MyModule.CFDBGrid_EDI.SelectedRows.Count > 0 then
    begin
    	if MyModule.CFDBGrid_EDI.SelectedRows.Count > High(Word) then
        	MessageBox(MyModule.Handle,PChar('A quantidade de equipamentos selecionados excede o limite permitido de ' + IntToStr(High(Word)) + #13#10'Por favor selecione menos itens'),'Não é possível remover equipamentos',MB_ICONERROR)
        else
        begin
        	ChavesAExcluir := '';
            for i := 0 to Pred(MyModule.CFDBGrid_EDI.SelectedRows.Count) do
            begin
                    EQUIPAMENTOSDOSITENS.Bookmark := MyModule.CFDBGrid_EDI.SelectedRows[i];

                    ChavesAExcluir := ChavesAExcluir + EQUIPAMENTOSDOSITENSIN_EQUIPAMENTOSDOSITENS_ID.AsString;

                    if i < Pred(MyModule.CFDBGrid_EDI.SelectedRows.Count) then
                        ChavesAExcluir := ChavesAExcluir + ',';
            end;

            ExecuteQuery(DataModuleMain.ZConnections.ByName['ZConnection_BDO'].Connection
                        ,Format(EDI_DELETE_SQL,[ChavesAExcluir]));
            try
                EQUIPAMENTOSDOSITENS.DisableControls;
                EQUIPAMENTOSDOSITENS.Refresh;
                { TODO -oCarlos Feitoza -cPOG : Ao excluir os registros
                selecionados, SelectedRows ainda mantém bookmarks para os registros
                selecionados que foram excluídos, o que está errado... O comando
                abaixo garante que ao se excluir, não haja mais nenhum registro
                selecionado. Isso deverá ser retirado caso a nova implementação do
                CFDBGrid resolver o problema por si só }
                MyModule.CFDBGrid_EDI.SelectedRows.Clear;
            finally
                EQUIPAMENTOSDOSITENS.EnableControls;
            end;

            AtualizarValores;
        end;
    end;
end;

procedure TBDODataModule_Obras.Action_EDI_InsertExecute(Sender: TObject);
const
    EDI_INSERT_HEADER =
    'INSERT'#13#10 +
    '  INTO EQUIPAMENTOSDOSITENS (IN_ITENS_ID,IN_EQUIPAMENTOS_ID,FL_LUCROBRUTO,FL_VALORUNITARIO,TI_MOEDA)'#13#10 +
    'VALUES';
    EDI_INSERT_TEMPLATE =
	' (%u,%u,(SELECT FL_LUCROBRUTO FROM EQUIPAMENTOS WHERE IN_EQUIPAMENTOS_ID = %1:u),(SELECT FL_VALORUNITARIO FROM EQUIPAMENTOS WHERE IN_EQUIPAMENTOS_ID = %1:u),(SELECT TI_MOEDA FROM EQUIPAMENTOS WHERE IN_EQUIPAMENTOS_ID = %1:u))';

var
	i: Word;
    Moeda: SmallInt;
    SQL: String;
begin
	inherited;
    DoBeforeInsert(EQUIPAMENTOSDOSITENS);

    SQL := EDI_INSERT_HEADER;

	if MyModule.CFDBGrid_EQP.SelectedRows.Count > 0 then
    begin
    	if MyModule.CFDBGrid_EQP.SelectedRows.Count > High(Word) then
        	MessageBox(MyModule.Handle,PChar('A quantidade de equipamentos selecionados excede o limite permitido de ' + IntToStr(High(Word)) + #13#10'Por favor selecione menos equipamentos'),'Não é possível inserir equipamentos',MB_ICONERROR)
        else
        begin
            Moeda := -1;

			{ Validando a seleção no grid de equipamentos: Todos os equipamentos
            selecionados tem de ser da mesma moeda }
            for i := 0 to Pred(MyModule.CFDBGrid_EQP.SelectedRows.Count) do
            begin
                EQUIPAMENTOS_LOOKUP.Bookmark := MyModule.CFDBGrid_EQP.SelectedRows[i];

                if (Moeda <> -1) and (EQUIPAMENTOS_LOOKUPTI_MOEDA.AsInteger <> Moeda) then
                    Break;

                Moeda := EQUIPAMENTOS_LOOKUPTI_MOEDA.AsInteger;
            end;


            if i < MyModule.CFDBGrid_EQP.SelectedRows.Count then
                MessageBox(MyModule.Handle,'Apenas equipamentos de mesma moeda podem ser selecionados para inserção na lista de equipamentos dos itens','Equipamentos de moedas diferentes',MB_ICONERROR)
            else
            begin
            	{ Validando inserção no grid de equipamentos do item: Apenas
                equipamentos da mesma moeda existente na lista de equipamentos
                do item podem ser inseridos. Temos de obter a moeda de ao menos
                um dos equipamentos do item pra fazer a comparação }
                if (EQUIPAMENTOSDOSITENS.RecordCount > 0) and (EQUIPAMENTOSDOSITENSTI_MOEDA.AsInteger <> Moeda) then
                	MessageBox(MyModule.Handle,PChar('A moeda dos equipamentos selecionados não corresponde à moeda da lista de equipamentos do item atual.'#13#10'Apenas equipamentos com a mesma moeda já existente na lista de equipamentos do item podem ser inseridos na mesma'),'Equipamentos de moedas diferentes',MB_ICONERROR)
                else
                begin
                    for i := 0 to Pred(MyModule.CFDBGrid_EQP.SelectedRows.Count) do
                    begin
                        EQUIPAMENTOS_LOOKUP.Bookmark := MyModule.CFDBGrid_EQP.SelectedRows[i];


                        if i = 0 then
                            SQL := SQL + Format(EDI_INSERT_TEMPLATE,[ITENSIN_ITENS_ID.AsInteger,EQUIPAMENTOS_LOOKUPIN_EQUIPAMENTOS_ID.AsInteger])
                        else
                            SQL := SQL + Format('      ' + EDI_INSERT_TEMPLATE,[ITENSIN_ITENS_ID.AsInteger,EQUIPAMENTOS_LOOKUPIN_EQUIPAMENTOS_ID.AsInteger]);

                        if i < Pred(MyModule.CFDBGrid_EQP.SelectedRows.Count) then
                            SQL := SQL + ','#13#10;
                    end;
                    ExecuteQuery(DataModuleMain.ZConnections.ByName['ZConnection_BDO'].Connection
                                ,SQL);

                    AtualizarValores;
                end;
            end;
        end;
    end;
end;

procedure TBDODataModule_Obras.Action_EDI_RelatorioExecute(Sender: TObject);
begin
    inherited;
    ExibirGeradorDeRelatorioDeEquipamentos;
end;

procedure TBDODataModule_Obras.Action_ITE_DeleteExecute(Sender: TObject);
begin
    inherited;
    DBButtonClick(ITENS,dbbDelete);
end;

procedure TBDODataModule_Obras.Action_ITE_EditExecute(Sender: TObject);
begin
    inherited;
    DBButtonClick(ITENS,dbbEdit,MyModule.DBComboBox_ITE_VA_DESCRICAO);
end;

procedure TBDODataModule_Obras.Action_ITE_InsertExecute(Sender: TObject);
begin
    inherited;
    DBButtonClick(ITENS,dbbInsert,MyModule.DBComboBox_ITE_VA_DESCRICAO);
end;

procedure TBDODataModule_Obras.Action_ITE_MoveDownExecute(Sender: TObject);
var
	ItemComFoco: Cardinal;
begin
  	inherited;
	DoBeforeEdit(ITENS);
    
    ItemComFoco := ITENSIN_ITENS_ID.AsInteger;
    MoveItemToBottom(ItemComFoco);
    ITENS.Refresh;
    ITENS.Locate('IN_ITENS_ID',ItemComFoco,[]);
end;

procedure TBDODataModule_Obras.Action_ITE_MoveUpExecute(Sender: TObject);
var
	ItemComFoco: Cardinal;
begin
	inherited;
	DoBeforeEdit(ITENS);

    ItemComFoco := ITENSIN_ITENS_ID.AsInteger;
    MoveItemToTop(ItemComFoco);
    ITENS.Refresh;
    ITENS.Locate('IN_ITENS_ID',ItemComFoco,[]);
end;

procedure TBDODataModule_Obras.Action_ITE_ReplicarExecute(Sender: TObject);
var
    Mensagem: String;
    BS: TBookmark;
begin
    inherited;
    Mensagem := ''; { Evita sujeira no fim da string? }
    if PROPOSTASBO_PROPOSTAPADRAO.AsInteger <> 0 then
        Application.MessageBox('A proposta atualmente selecionada é a proposta padrão, não é possível fazer uma cópia de ítens da proposta padrão para ela própria. Por favor, selecione outra proposta','Cópia circular não permitida',MB_ICONERROR)
    else
    begin
        if (ITENS.RecordCount > 0) then
        begin
            if Application.MessageBox('A proposta atual já contém itens. O procedimento de cópia de itens da proposta padrão NÃO SUBSTITUI os itens existentes, ele apenas adiciona os itens da proposta padrão à proposta atual. Tem certeza de que quer continuar?','Tem certeza?',MB_ICONQUESTION or MB_YESNO) = idYes then
            begin
                CopiarItensDaPropostaPadrao(OBRASIN_OBRAS_ID.AsInteger
                                           ,PROPOSTASIN_PROPOSTAS_ID.AsInteger);
                Mensagem := 'A proposta atual agora possui os ítens e equipamentos da proposta padrão';
            end
            else
                Exit;
        end
        else
        begin
            CopiarItensDaPropostaPadrao(OBRASIN_OBRAS_ID.AsInteger
                                       ,PROPOSTASIN_PROPOSTAS_ID.AsInteger);
            Mensagem := 'A proposta atual foi preenchida com os itens e equipamentos da proposta padrão';
        end;

        try
            BS := PROPOSTAS.Bookmark;
            PROPOSTAS.Refresh;
        finally
            PROPOSTAS.Bookmark := BS;
        end;
        
        Application.MessageBox(PChar(Mensagem),'Ação concluída',MB_ICONINFORMATION);
    end;
end;

procedure TBDODataModule_Obras.ExibirJustificativa2(const aIN_OBRAS_ID: Cardinal);
begin
    if not HasPermission(DataModuleMain.ZConnections.ByName['ZConnection_BDO'].Connection,UpperCase(Action_Justificativa.FullyQualifiedName),0,etAction,pRead) then
        raise EPermissionException.Create(RS_NO_ACTION_PERMISSION);

    ExibirJustificativa(aIN_OBRAS_ID);
end;

procedure TBDODataModule_Obras.ExibirJustificativa(const aIN_OBRAS_ID: Cardinal);
const
    SQL =
    'SELECT COUNT(JUS.TI_JUSTIFICATIVAS_ID)'#13#10 +
    '     , USU.X[USU.' + DEFAULT_USERTABLE_REALNAMEFIELDNAME + ']X'#13#10 +
    '     , GROUP_CONCAT(CONCAT(''> '',JUS.VA_JUSTIFICATIVA) SEPARATOR ''\r\n'')'#13#10 +
    '  FROM OBRAS OBR'#13#10 +
    '  JOIN JUSTIFICATIVASDASOBRAS JDO USING (IN_OBRAS_ID)'#13#10 +
    '  JOIN JUSTIFICATIVAS JUS USING (TI_JUSTIFICATIVAS_ID)'#13#10 +
    '  JOIN X[USU.' + DEFAULT_USERTABLE_TABLENAME + ']X USU ON USU.X[USU.' + DEFAULT_USERTABLE_KEYFIELDNAME + ']X = OBR.SM_USUARIOJUSTIFICADOR_ID'#13#10 +
    ' WHERE OBR.IN_OBRAS_ID = %u';

var
    RODataSet: TZReadOnlyQuery;
	CreateParameters: TDialogCreateParameters;
    BDOForm_JustificativaSalva: TBDOForm_JustificativaSalva;
begin
    RODataSet := nil;
    try
        {$IFDEF DEVELOPING}
        SaveTextFile(MySQLFormat(ReplaceSystemObjectNames(SQL)
                                ,[aIN_OBRAS_ID])
                    ,Configurations.CurrentDir + '\ExibirJustificativa.sql');
        {$ENDIF}

        ConfigureDataSet(DataModuleMain.ZConnections.ByName['ZConnection_BDO'].Connection
                        ,RODataSet
                        ,MySQLFormat(ReplaceSystemObjectNames(SQL)
                                    ,[aIN_OBRAS_ID]));

        if not RODataSet.IsEmpty and (RODataSet.Fields[0].AsInteger > 0) then
        begin
            ZeroMemory(@CreateParameters,SizeOf(TDialogCreateParameters));
            with CreateParameters do
            begin
                AutoFree := True;
                Modal := True;
                Configurations := Self.Configurations;
            end;

            BDOForm_JustificativaSalva := nil;
            BDOForm_JustificativaSalva := TBDOForm_JustificativaSalva.Create(Owner
                                                                            ,BDOForm_JustificativaSalva
                                                                            ,CreateParameters);
            with BDOForm_JustificativaSalva do
            begin
                Label_UsuarioJustificadorValor.Caption := RODataSet.Fields[1].AsString;
                Memo_Justificativa.Text := Trim(RODataSet.Fields[2].AsString);
                ShowModal;
            end;
        end
        else
            Application.MessageBox('Não há justificativa salva. Provavelmente a situação desta obra (ou a situação da obra associada) não é justificável ou passou a ser justificável após a mudança da situação','Justificativa ausente',MB_ICONINFORMATION)
    finally
        if Assigned(RODataSet) then
            RODataSet.Free;
    end;
end;

procedure TBDODataModule_Obras.Action_JustificativaExecute(Sender: TObject);
begin
    inherited;
    if TCFDBGrid(PopupActionBar_RecordInformation.PopupComponent).DataSource.DataSet = PROPOSTAS_SEARCH then
        ExibirJustificativa(ObraDaProposta(PROPOSTAS_SEARCHIN_PROPOSTAS_ID.AsInteger))
    else if TCFDBGrid(PopupActionBar_RecordInformation.PopupComponent).DataSource.DataSet = OBRAS_SEARCH then
        ExibirJustificativa(OBRAS_SEARCHIN_OBRAS_ID.AsInteger);
end;

procedure TBDODataModule_Obras.Action_OBR_DeleteExecute(Sender: TObject);
begin
    inherited;
    DBButtonClick(OBRAS,dbbDelete);
end;

procedure TBDODataModule_Obras.Action_OBR_EditExecute(Sender: TObject);
begin
    inherited;
    DBButtonClick(OBRAS,dbbEdit,MyModule.DBEdit_OBR_VA_NOMEDAOBRA);
end;

procedure TBDODataModule_Obras.Action_OBR_insertExecute(Sender: TObject);
begin
    inherited;
    DBButtonClick(OBRAS,dbbInsert,MyModule.DBEdit_OBR_VA_NOMEDAOBRA);
//  if ModuloDeDados.OBRAS.State = dsInsert then
//    ModuloDeDados.OBRAS.FieldByName['TX_CONDICOESGERAIS').AsString := rs_textodecondicoesgerais;
end;

procedure TBDODataModule_Obras.Action_OBR_RelatorioExecute(Sender: TObject);
begin
    inherited;
    ExibirGeradorDeRelatorioDeObras;
end;

procedure TBDODataModule_Obras.Action_PRO_DefinirCotacoesExecute(Sender: TObject);
var
    Cotacoes: AnsiString;
begin
    inherited;
    if MyModule.DBComboBox_PRO_TI_MOEDA.ItemIndex = -1 then
        MessageBox(MyModule.Handle,'Antes de definir cotações, por favor selecione a moeda final','Selecione a moeda final',MB_ICONWARNING)
    else
    begin
        Cotacoes := ShowCurrencyConvertManager(PROPOSTASVA_COTACOES.AsString,Byte(MyModule.DBComboBox_PRO_TI_MOEDA.ItemIndex + 1));

        if Trim(Cotacoes) <> '' then
        begin
            if PROPOSTAS.State = dsBrowse then
                PROPOSTAS.Edit;

            PROPOSTASVA_COTACOES.AsString := Cotacoes;
        end;
    end;
end;

procedure TBDODataModule_Obras.Action_PRO_DeleteExecute(Sender: TObject);
begin
    inherited;
    DBButtonClick(PROPOSTAS,dbbDelete);
end;

procedure TBDODataModule_Obras.Action_PRO_EditExecute(Sender: TObject);
begin
    inherited;
    DBButtonClick(PROPOSTAS,dbbEdit,MyModule.DBEdit_PRO_TI_VALIDADE);
end;

procedure TBDODataModule_Obras.Action_PRO_InsertExecute(Sender: TObject);
begin
    inherited;
    DBButtonClick(PROPOSTAS,dbbInsert,MyModule.DBEdit_PRO_TI_VALIDADE);
end;

procedure TBDODataModule_Obras.Action_PRO_RelatorioExecute(Sender: TObject);
begin
    inherited;
    ExibirGeradorDeRelatorioDePropostas;
end;

procedure TBDODataModule_Obras.Action_RecordInformationExecute(Sender: TObject);
begin
    inherited;
    if TCFDBGrid(PopupActionBar_RecordInformation.PopupComponent).DataSource.DataSet = PROPOSTAS then
        PRO_Information
    else if TCFDBGrid(PopupActionBar_RecordInformation.PopupComponent).DataSource.DataSet = ITENS then
        ITE_Information
    else if TCFDBGrid(PopupActionBar_RecordInformation.PopupComponent).DataSource.DataSet = EQUIPAMENTOSDOSITENS then
        EDI_Infromation
    else if TCFDBGrid(PopupActionBar_RecordInformation.PopupComponent).DataSource.DataSet = EQUIPAMENTOS_LOOKUP then
        EQP_Information
    else if TCFDBGrid(PopupActionBar_RecordInformation.PopupComponent).DataSource.DataSet = OBRAS_SEARCH then
        OBR_SCH_Information
    else if TCFDBGrid(PopupActionBar_RecordInformation.PopupComponent).DataSource.DataSet = PROPOSTAS_SEARCH then
        PRO_SCH_Information
    else if TCFDBGrid(PopupActionBar_RecordInformation.PopupComponent).DataSource.DataSet = EQUIPAMENTOS_SEARCH then
        EQP_SCH_Information
    else if TCFDBGrid(PopupActionBar_RecordInformation.PopupComponent).DataSource.DataSet = OBRAS_SEARCH_PAR then
        OBR_SCH_SEM_Information(OBRAS_SEARCH_PARIN_OBRAS_ID.AsInteger)
    else if TCFDBGrid(PopupActionBar_RecordInformation.PopupComponent).DataSource.DataSet = OBRAS_SEARCH_PAL then
        OBR_SCH_SEM_Information(OBRAS_SEARCH_PALIN_OBRAS_ID.AsInteger);
end;

function TBDODataModule_Obras.ObraExpirou(aTabelaExpiravel: TTabelaExpiravel; const aID: Cardinal): TDateTime;
var
    RODataSet: TZReadOnlyQuery;
    SQL: String;
begin
    RODataSet := nil;
    Result := 0;
    try
        case aTabelaExpiravel of
            teObra: SQL := 'SELECT DA_DATADEEXPIRACAO'#13#10 +
                           '  FROM OBRAS'#13#10 +
                           ' WHERE IN_OBRAS_ID = %u'#13#10 +
                           '   AND DA_DATADEEXPIRACAO IS NOT NULL'#13#10 +
                           '   AND DA_DATADEEXPIRACAO < NOW()';

            teProposta: SQL := 'SELECT OBR.DA_DATADEEXPIRACAO'#13#10 +
                               '  FROM OBRAS OBR'#13#10 +
                               '  JOIN PROPOSTAS PRO USING(IN_OBRAS_ID)'#13#10 +
                               ' WHERE PRO.IN_PROPOSTAS_ID = %u'#13#10 +
                               '   AND OBR.DA_DATADEEXPIRACAO IS NOT NULL'#13#10 +
                               '   AND OBR.DA_DATADEEXPIRACAO < NOW()';

            teItens: SQL := 'SELECT OBR.DA_DATADEEXPIRACAO'#13#10 +
                            '  FROM OBRAS OBR'#13#10 +
                            '  JOIN PROPOSTAS PRO USING(IN_OBRAS_ID)'#13#10 +
                            '  JOIN ITENS ITE USING (IN_PROPOSTAS_ID)'#13#10 +
                            ' WHERE ITE.IN_ITENS_ID = %u'#13#10 +
                            '   AND OBR.DA_DATADEEXPIRACAO IS NOT NULL'#13#10 +
                            '   AND OBR.DA_DATADEEXPIRACAO < NOW()';

            teEquipamentosDosItens: SQL := 'SELECT OBR.DA_DATADEEXPIRACAO'#13#10 +
                                           '  FROM OBRAS OBR'#13#10 +
                                           '  JOIN PROPOSTAS PRO USING(IN_OBRAS_ID)'#13#10 +
                                           '  JOIN ITENS ITE USING (IN_PROPOSTAS_ID)'#13#10 +
                                           '  JOIN EQUIPAMENTOSDOSITENS EDI USING(IN_ITENS_ID)'#13#10 +
                                           ' WHERE EDI.IN_EQUIPAMENTOSDOSITENS_ID = %u'#13#10 +
                                           '   AND OBR.DA_DATADEEXPIRACAO IS NOT NULL'#13#10 +
                                           '   AND OBR.DA_DATADEEXPIRACAO < NOW()';
        end;

        ConfigureDataSet(DataModuleMain.ZConnections.ByName['ZConnection_BDO'].Connection
                        ,RODataSet
                        ,MySQLFormat(SQL,[aID]));

        if not RODataSet.IsEmpty then
            Result := RODataSet.Fields[0].AsDateTime;
    finally
        if Assigned(RODataSet) then
            RODataSet.Free;
    end;
end;

function TBDODataModule_Obras.ClausulaWherePorPalavras(const aVA_NOMEDAOBRA: AnsiString): String;
var
    i: Byte;
begin
    Result := '';

    with TStringList.Create do
        try
            DelimitedText := Trim(aVA_NOMEDAOBRA);

            { Tantas linhas quantas forem as palavras contidas em aVA_NOMEDAOBRA
            e para cada uma delas... }

            for i := 0 to Pred(Count) do
            begin
                if i > 0 then
                    Result := Result + '    OR ';

                Result := Result + 'UPPER(VA_NOMEDAOBRA) LIKE UPPER(' + QuotedStr(Strings[i] + ' %') + ')'#13#10 +
                                   '    OR UPPER(VA_NOMEDAOBRA) LIKE UPPER(' + QuotedStr('% ' + Strings[i] + ' %') + ')'#13#10 +
                                   '    OR UPPER(VA_NOMEDAOBRA) LIKE UPPER(' + QuotedStr('% ' + Strings[i]) + ')';
            end;
        finally
            Free;
        end;
end;

function TBDODataModule_Obras.ObrasSemelhantes(const aVA_NOMEDAOBRA: AnsiString): Cardinal;
const
    SQL1 =
    'SELECT COUNT(IN_OBRAS_ID)'#13#10 +
    '  FROM OBRAS'#13#10 +
    ' WHERE UPPER(VA_NOMEDAOBRA) LIKE UPPER(''%s'')';

    SQL2 =
    'SELECT COUNT(IN_OBRAS_ID)'#13#10 +
    '  FROM OBRAS'#13#10 +
    ' WHERE %s';
var
    RODataSet: TZReadOnlyQuery;
begin
    RODataSet := nil;
    Result := 0;
    try
        if Trim(aVA_NOMEDAOBRA) <> '' then
        begin
            ConfigureDataSet(DataModuleMain.ZConnections.ByName['ZConnection_BDO'].Connection
                            ,RODataSet
                            ,MySQLFormat(SQL1
                                        ,['%' + aVA_NOMEDAOBRA + '%']));

            if Assigned(RODataSet) then
                Result := RODataSet.Fields[0].AsInteger;

            ConfigureDataSet(DataModuleMain.ZConnections.ByName['ZConnection_BDO'].Connection
                            ,RODataSet
                            ,MySQLFormat(SQL2
                                        ,[ClausulaWherePorPalavras(aVA_NOMEDAOBRA)]));

            if Assigned(RODataSet) then
                Inc(Result,RODataSet.Fields[0].AsInteger);
        end;
    finally
        if Assigned(RODataSet) then
            RODataSet.Free
    end;
end;

procedure TBDODataModule_Obras.DataModuleDestroy(Sender: TObject);
begin
    inherited;
    DropTemporaryTables;
end;

procedure TBDODataModule_Obras.DBButtonClick_EQP_SCH(aDBButton: TDBButton);
begin
    DBButtonClick(EQUIPAMENTOS_SEARCH,aDBButton);
end;

procedure TBDODataModule_Obras.DBButtonClick_ITE(aDBButton: TDBButton; aComponentToFocusOnInsertAndEdit: TWinControl; aUseBookMark: Boolean = False);
var
    BS: TBookmark;
begin
    if (aDBButton = dbbRefresh) and aUseBookMark then
        BS := ITENS.Bookmark;

    try
        DBButtonClick(ITENS,aDBButton,aComponentToFocusOnInsertAndEdit);
    finally
        if (aDBButton = dbbRefresh) and aUseBookMark then
            ITENS.Bookmark := BS;
    end;
end;

procedure TBDODataModule_Obras.DBButtonClick_OBR(aDBButton: TDBButton; aComponentToFocusOnInsertAndEdit: TWinControl; aUseBookMark: Boolean = False);
var
    BS: TBookmark;
begin
    if (aDBButton = dbbRefresh) and aUseBookMark then
        BS := OBRAS.Bookmark;

    try
        DBButtonClick(OBRAS,aDBButton,aComponentToFocusOnInsertAndEdit);
    finally
        if (aDBButton = dbbRefresh) and aUseBookMark then
            OBRAS.Bookmark := BS;
    end;
end;

procedure TBDODataModule_Obras.DBButtonClick_OBR_SCH(aDBButton: TDBButton);
begin
    DBButtonClick(OBRAS_SEARCH,aDBButton);
end;

procedure TBDODataModule_Obras.DBButtonClick_PRO(aDBButton: TDBButton; aComponentToFocusOnInsertAndEdit: TWinControl; aUseBookMark: Boolean = False);
var
    BS: TBookmark;
begin
    if (aDBButton = dbbRefresh) and aUseBookMark then
        BS := PROPOSTAS.Bookmark;

    try
        DBButtonClick(PROPOSTAS,aDBButton,aComponentToFocusOnInsertAndEdit);
    finally
        if (aDBButton = dbbRefresh) and aUseBookMark then
            PROPOSTAS.Bookmark := BS;
    end;
end;

procedure TBDODataModule_Obras.DBButtonClick_PRO_SCH(aDBButton: TDBButton);
begin
    DBButtonClick(PROPOSTAS_SEARCH,aDBButton);
end;

procedure TBDODataModule_Obras.AdicionarJustificativas(const aIN_OBRAS_ID: Cardinal;
                                                       const aJustificativas: TBytesArray);
const
    SQL =
    'INSERT INTO JUSTIFICATIVASDASOBRAS (IN_OBRAS_ID,TI_JUSTIFICATIVAS_ID)'#13#10 +
    'VALUES %s';
var
    Justificativa: Byte;
    Justificativas: String;
begin
    Justificativas := '';
    for Justificativa in aJustificativas do
    begin
        if Justificativas <> '' then
            Justificativas := Justificativas + MySQLFormat(#13#10'     , (%u,%u)',[aIN_OBRAS_ID,Justificativa])
        else
            Justificativas := MySQLFormat('(%u,%u)',[aIN_OBRAS_ID,Justificativa])
    end;
    ExecuteQuery(DataModuleMain.ZConnections.ByName['ZConnection_BDO'].Connection
                ,MySQLFormat(SQL
                            ,[Justificativas]));
end;

procedure TBDODataModule_Obras.LimparJustificativas(const aIN_OBRAS_ID: Cardinal);
begin
    ExecuteQuery(DataModuleMain.ZConnections.ByName['ZConnection_BDO'].Connection
                ,'DELETE FROM JUSTIFICATIVASDASOBRAS WHERE IN_OBRAS_ID = ' + IntToStr(aIN_OBRAS_ID));
end;

//procedure TBDODataModule_Obras.FiltrarObras(const aItems: TStrings;
//                                            const aVA_NOMEDAOBRA: AnsiString);
//begin
//    aItems.Clear;
//    try
//        OBRAS_LOOKUP.Filtered := False;
//        OBRAS_LOOKUP.FilterOptions := [foCaseInsensitive];
//        OBRAS_LOOKUP.Filter := '*' + aVA_NOMEDAOBRA + '*';
//    finally
//        OBRAS_LOOKUP.Filtered := True;
//    end;
//end;

procedure TBDODataModule_Obras.DefinirNovaSituacao(const aTI_SITUACOES_ID: Byte;
                                                   const aIN_OBRAS_ID: Cardinal);
const
	SQL = 'UPDATE OBRAS'#13#10 +
          '   SET TI_SITUACOES_ID = %u'#13#10 +
          '%s' +
          ' WHERE IN_OBRAS_ID = %u';
var
    DataDeExpiracao: TDate;
    ComplementoSQL: String;

    UsuarioJustificador: Integer;
    Justificativas: TBytesArray;
begin
    inherited;
    { Verifica se a obra expirou. }
    DataDeExpiracao := ObraExpirou(teObra,aIN_OBRAS_ID);
    if DataDeExpiracao > 0 then
        raise Exception.Create(FormatDateTime(rs_naopodealterarobraexpirada,DataDeExpiracao));

    { Verifica se tem permissão para realizar a ação }
    if not HasPermission(DataModuleMain.ZConnections.ByName['ZConnection_BDO'].Connection,'OBRAS',0,etTable,pModify) then
        raise EPermissionException.Create(Format(RS_NO_UPDATE_PERMISSION,['OBRAS']));

    JustificativaParaObra(SituacaoDaObra(aIN_OBRAS_ID)
                         ,aTI_SITUACOES_ID
                         ,UsuarioJustificador
                         ,Justificativas);

    { Se a situação mudou, se a nova situação é justificavel, e se houve
    justificativa válida, coloca as informações }
    if UsuarioJustificador > 0 then
        ComplementoSQL :=
        '     , SM_USUARIOJUSTIFICADOR_ID = ' + IntToStr(UsuarioJustificador) + #13#10
    { Se a situação não mudou não inclui os campos }
    else if UsuarioJustificador = 0 then
        ComplementoSQL := ''
    { Se a situação não é justificável resseta os campos para NULL}
    else if UsuarioJustificador = -1 then
        ComplementoSQL :=
        '     , SM_USUARIOJUSTIFICADOR_ID = NULL'#13#10
    {  A situação nova é justificável mas nenhuma justificativa foi feita.
    (Cancelou a operação) }
    else if UsuarioJustificador = -2 then
        Abort;

    ExecuteQuery(DataModuleMain.ZConnections.ByName['ZConnection_BDO'].Connection
                ,MySQLFormat(SQL,[aTI_SITUACOES_ID
                                 ,ComplementoSQL
                                 ,aIN_OBRAS_ID]));

    if Length(Justificativas) > 0 then
        AdicionarJustificativas(aIN_OBRAS_ID,Justificativas)
    else
        LimparJustificativas(aIN_OBRAS_ID);
end;

{ Este método configura uma proposta como padrão caso a obra tenha propostas e
nenhuma delas seja uma proposta padrão }
procedure TBDODataModule_Obras.DefinirPropostaPadrao(const aIN_OBRAS_ID: Cardinal);
begin
    ExecuteDbProcedure(DataModuleMain.ZConnections.ByName['ZConnection_BDO'].Connection,'PRC_SET_DEFAULT_PROPOSAL_ON_FIRST_NON_DEFAULT_PROPOSAL('+ IntToStr(aIN_OBRAS_ID) +')');
    PROPOSTAS.Refresh;
end;

procedure TBDODataModule_Obras.DoAfterDelete(aDataSet: TDataSet);
begin
    inherited;
    if aDataSet = PROPOSTAS then
        DefinirPropostaPadrao(OBRASIN_OBRAS_ID.AsInteger)
    else if aDataSet = ITENS then
        AtualizarValores;
end;

procedure TBDODataModule_Obras.DoAfterOpen(aDataSet: TDataSet);
begin
    inherited;
    if aDataSet = OBRAS then
        OBRAS.Last;
end;

procedure TBDODataModule_Obras.AtualizarValores;
var
    BS_ITE,BS_EDI: TBookmark;
begin
    BS_ITE := ITENS.Bookmark;
    BS_EDI := EQUIPAMENTOSDOSITENS.Bookmark;

    try
        DBButtonClick_PRO(dbbRefresh,nil,True);
    finally
        ITENS.Bookmark := BS_ITE;
        EQUIPAMENTOSDOSITENS.Bookmark := BS_EDI;
    end;
end;

procedure TBDODataModule_Obras.DoBeforeDelete(aDataSet: TDataSet);
var
    DataDaExpiracao: TDate;
begin
	if aDataSet = OBRAS then
    begin
        DataDaExpiracao := ObraExpirou(teObra,OBRASIN_OBRAS_ID.AsInteger);
        if DataDaExpiracao > 0 then
            raise Exception.Create(FormatDateTime(rs_naopodeexcluirobraexpirada,DataDaExpiracao));

    	CFDBValidationChecks_OBR.ValidateBeforeDelete
    end
    else if aDataSet = PROPOSTAS then
    begin
        DataDaExpiracao := ObraExpirou(teProposta,PROPOSTASIN_PROPOSTAS_ID.AsInteger);
        if DataDaExpiracao > 0 then
            raise Exception.Create(FormatDateTime(rs_naopodeexcluirpropostaexpirada,DataDaExpiracao));

    	CFDBValidationChecks_PRO.ValidateBeforeDelete
    end
    else if aDataSet = ITENS then
    begin
        DataDaExpiracao := ObraExpirou(teItens,ITENSIN_ITENS_ID.AsInteger);
        if DataDaExpiracao > 0 then
            raise Exception.Create(FormatDateTime(rs_naopodeexcluiritemexpirado,DataDaExpiracao));

    	CFDBValidationChecks_ITE.ValidateBeforeDelete;
    end
    else if aDataSet = EQUIPAMENTOSDOSITENS then
    begin
        DataDaExpiracao := ObraExpirou(teEquipamentosDosItens,EQUIPAMENTOSDOSITENSIN_EQUIPAMENTOSDOSITENS_ID.AsInteger);
        if DataDaExpiracao > 0 then
            raise Exception.Create(FormatDateTime(rs_naopodeexcluirequipamentoexpirado,DataDaExpiracao));
    end;

  	inherited;
end;

procedure TBDODataModule_Obras.DoBeforeEdit(aDataSet: TDataSet);
var
    DataDaExpiracao: TDate;
begin
    inherited;

	if aDataSet = OBRAS then
    begin
        FSituacaoAnterior := OBRASTI_SITUACOES_ID.AsInteger;

        DataDaExpiracao := ObraExpirou(teObra,OBRASIN_OBRAS_ID.AsInteger);
        if DataDaExpiracao > 0 then
            raise Exception.Create(FormatDateTime(rs_naopodealterarobraexpirada,DataDaExpiracao));
    end
    else if aDataSet = PROPOSTAS then
    begin
        DataDaExpiracao := ObraExpirou(teProposta,PROPOSTASIN_PROPOSTAS_ID.AsInteger);
        if DataDaExpiracao > 0 then
            raise Exception.Create(FormatDateTime(rs_naopodealterarpropostaexpirada,DataDaExpiracao));
    end
    else if aDataSet = ITENS then
    begin
        DataDaExpiracao := ObraExpirou(teItens,ITENSIN_ITENS_ID.AsInteger);
        if DataDaExpiracao > 0 then
            raise Exception.Create(FormatDateTime(rs_naopodealteraritemexpirado,DataDaExpiracao));
    end;
end;

procedure TBDODataModule_Obras.DoBeforeInsert(aDataSet: TDataSet);
var
    DataDaExpiracao: TDate;
begin
    inherited;
    if aDataSet = OBRAS then
        FSituacaoAnterior := 0
	else if aDataSet = PROPOSTAS then
    begin
        DataDaExpiracao := ObraExpirou(teProposta,PROPOSTASIN_PROPOSTAS_ID.AsInteger);
        if DataDaExpiracao > 0 then
            raise Exception.Create(FormatDateTime(rs_naopodeinserirpropostaexpirada,DataDaExpiracao));
    end
    else if aDataSet = ITENS then
    begin
        DataDaExpiracao := ObraExpirou(teItens,ITENSIN_ITENS_ID.AsInteger);
        if DataDaExpiracao > 0 then
            raise Exception.Create(FormatDateTime(rs_naopodeinseriritemexpirado,DataDaExpiracao));
    end
    else if aDataSet = EQUIPAMENTOSDOSITENS then
    begin
        DataDaExpiracao := ObraExpirou(teEquipamentosDosItens,EQUIPAMENTOSDOSITENSIN_EQUIPAMENTOSDOSITENS_ID.AsInteger);
        if DataDaExpiracao > 0 then
            raise Exception.Create(FormatDateTime(rs_naopodeinserirequipamentoexpirado,DataDaExpiracao));
    end;
end;

procedure TBDODataModule_Obras.DoBeforeOpen(aDataSet: TDataSet);
begin
    inherited;
    if aDataSet = OBRAS then
        OBRAS.ParamByName('SM_USUARIOS_ID').AsInteger := Configurations.AuthenticatedUser.Id
    else if aDataSet = REGIOES_LOOKUP then
        REGIOES_LOOKUP.ParamByName('SM_USUARIOS_ID').AsInteger := Configurations.AuthenticatedUser.Id
    else if aDataSet = OBRAS_SEARCH then
        CreateTemporaryTableObrasSearch
    else if aDataSet = PROPOSTAS_SEARCH then
        CreateTemporaryTablePropostasSearch
    else if aDataSet = EQUIPAMENTOS_SEARCH then
        CreateTemporaryTableEquipamentosSearch;
end;

procedure TBDODataModule_Obras.JustificativaParaObra(const aSituacaoAntiga
                                                         , aSituacaoNova: Byte;
                                                       out aUsuario: Integer;
                                                       out aJustificativas: TBytesArray);
var
	CreateParameters: TDialogCreateParameters;
    BDOForm_JustificativaParaObra: TBDOForm_JustificativaParaObra;
    i: Word;
begin
    aUsuario := 0;
    SetLength(aJustificativas,0);
    { Se a situação sendo salva for diferente da situação que havia
    anteriormente e se ela for uma situação justificavel, abre o formulário
    de justificativa }
    if aSituacaoAntiga <> aSituacaoNova then
    begin
        aUsuario := -1;
        if SituacaoJustificavel(aSituacaoNova) then
        begin
        	ZeroMemory(@CreateParameters,SizeOf(TDialogCreateParameters));

            CreateParameters.Configurations := Configurations;
            with CreateParameters do
            begin
                AutoFree := False; // É necessário dar close e liberar a memoria com free, etc.
                Modal := True;
                MyDataModule := Self;
                DataModuleMain := Self.DataModuleMain;
            end;

            BDOForm_JustificativaParaObra := nil;
            BDOForm_JustificativaParaObra := TBDOForm_JustificativaParaObra.Create(Owner
                                                                                  ,BDOForm_JustificativaParaObra
                                                                                  ,CreateParameters);
//    retornar uma string com as justificativas selecionadas
            with BDOForm_JustificativaParaObra do
                try
                    
                    aUsuario := -2;
                    if ShowModal = mrOk then
                    begin
                        aUsuario := Configurations.AuthenticatedUser.Id;
                        SetLength(aJustificativas,ListView_JustificativasSelecionadas.Items.Count);
                        for i := 0 to High(aJustificativas) do
                            aJustificativas[i] := Byte(ListView_JustificativasSelecionadas.Items[i].Data);
                    end;
                finally
                    Free;
                end;
        end;
    end;
end;

procedure TBDODataModule_Obras.DoBeforePost(aDataSet: TDataSet);
var
    Usuario: Integer;
begin
	inherited; { Verifica permissão }

	if aDataSet = OBRAS then
    begin
        { Caso nenhuma texto esteja escrito significa que os deixamos em branco.
        Como estamos tratando com um richtext, ele nunca ficaria em branco,
        logo, temos de forçar isso! }
        if Length(MyModule.DBRichEdit_OBR_TX_CONDICAODEPAGAMENTO.Text) = 0 then
            OBRASTX_CONDICAODEPAGAMENTO.Clear;

        if Length(MyModule.DBRichEdit_OBR_TX_CONDICOESGERAIS.Text) = 0 then
            OBRASTX_CONDICOESGERAIS.Clear;

    	CFDBValidationChecks_OBR.ValidateBeforePost;
        JustificativaParaObra(FSituacaoAnterior
                             ,OBRASTI_SITUACOES_ID.AsInteger
                             ,Usuario
                             ,FJustificativas);

        { Se a situação mudou, se a nova situação é justificavel, e se houve
        justificativa válida, coloca as informações }
        if Usuario > 0 then
        begin
            OBRASSM_USUARIOJUSTIFICADOR_ID.AsInteger := Usuario;
        end
        { Se a situação não mudou não inclui os campos }
        else if Usuario = 0 then
            Application.ProcessMessages
        { Se a situação não é justificável resseta os campos para NULL}
        else if Usuario = -1 then
        begin
            OBRASSM_USUARIOJUSTIFICADOR_ID.Clear;
        end
        { A situação nova é justificável mas nenhuma justificativa foi feita.
        (Cancelou a operação) }
        else if Usuario = -2 then
            Abort;
    end
    else if aDataSet = PROPOSTAS then
    	CFDBValidationChecks_PRO.ValidateBeforePost
    else if aDataSet = ITENS then
    	CFDBValidationChecks_ITE.ValidateBeforePost;

    { Outras validações específicas de negócio}
end;

procedure TBDODataModule_Obras.DoAfterPost(aDataSet: TDataSet);
begin
    inherited;
    if aDataSet = ITENS then
    begin
        SaveComboBoxItems(MyModule.DBComboBox_ITE_VA_DESCRICAO,Configurations.CurrentDir + '\ITE_VA_DESCRICAO.TXT');
        AtualizarValores;
    end
    else if aDataSet = OBRAS then
    begin
        AtualizarLabelDeDataDeExpiracao(True);

        if Length(FJustificativas) > 0 then
           AdicionarJustificativas(OBRASIN_OBRAS_ID.AsInteger,FJustificativas)
        else
           LimparJustificativas(OBRASIN_OBRAS_ID.AsInteger);

//        ObterObras(MyModule.DBComboBox_OBR_VA_NOMEDAOBRA.Items)
    end;
end;

procedure TBDODataModule_Obras.DoCustomValidate(const aSender: TObject;
                                                const aValidateAction: TValidateAction;
                                                const aValidateMoment: TValidateMoment);
begin
    inherited;
    case aValidateAction of
        vaBeforePost: case aValidateMoment of
            vmBegin: if aSender = CFDBValidationChecks_OBR then
                with CFDBValidationChecks_OBR.CheckableFields.ByFieldName['YR_ANOPROVAVELDEENTREGA'].CheckNumberSet do
                begin
                    Active := True;
                    Numbers.Clear;

                    Numbers.Add(IntToStr(YearOf(Now)));

                    if OBRAS.State = dsInsert then
                        CustomValidationMessage := 'O ano a informar tem de ser obrigatoriamente um dos seguintes valores: "' + IntToStr(YearOf(Now)) + '" (ano atual) ou "' + IntToStr(Succ(YearOf(Now))) + '" (próximo ano)'
                    else if OBRAS.State = dsEdit then
                    begin
                        Numbers.Add(IntToStr(YearOf(OBRASDT_DATAEHORADACRIACAO.AsDateTime)));
                        CustomValidationMessage := 'O ano a informar tem de ser obrigatoriamente um dos seguintes valores: "' + IntToStr(YearOf(OBRASDT_DATAEHORADACRIACAO.AsDateTime)) + '" (ano de entrada), "' + IntToStr(YearOf(Now)) + '" (ano atual) ou "' + IntToStr(Succ(YearOf(Now))) + '" (próximo ano)';
                    end;
                    Numbers.Add(IntToStr(Succ(YearOf(Now))));


                end;
            vmEnd: ;
        end;
        vaBeforeDelete: case aValidateMoment of
            vmBegin: ;
            vmEnd: ;
        end;
    end;
end;

procedure TBDODataModule_Obras.DoStateChange(aSender: TObject);
begin
    inherited;
    if aSender = DataSource_OBR then
        MyModule.Action_OBR_ObrasSemelhantes.ImageIndex := 26;
end;

procedure TBDODataModule_Obras.DoDataChange(aSender: TObject; aField: TField);
const
    CURRENT_TOTAL = '%u / %u';
var
	ButtonEnabled: array [0..9] of Boolean;
    PButtonEnabled: array [0..3] of Boolean;
begin
  	inherited;
    if csDestroying in ComponentState then
        Exit;

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

    if aSender = DataSource_OBR then
    begin
        MyModule.GroupBox_PRO_BloqueiaProposta.Visible := (OBRAS.State = dsInsert) or (OBRAS.RecordCount = 0);
        MyModule.Panel_PRO_Dados.Visible := not MyModule.GroupBox_PRO_BloqueiaProposta.Visible;
        
        SafeSetActionEnabled(Action_OBR_Insert,ButtonEnabled[4] and Action_OBR_Insert.Allowed);
        SafeSetActionEnabled(Action_OBR_Delete,ButtonEnabled[5] and Action_OBR_Delete.Allowed);
        SafeSetActionEnabled(Action_OBR_Edit,ButtonEnabled[6] and Action_OBR_Edit.Allowed);
        SafeSetActionEnabled(MyModule.Action_OBR_Post,ButtonEnabled[7]);
        SafeSetActionEnabled(MyModule.Action_OBR_Cancel,ButtonEnabled[8]);
        SafeSetActionEnabled(MyModule.Action_OBR_Refresh,ButtonEnabled[9]);
        AtualizarLabelDeDataDeExpiracao(False);

        if not EhRichText(OBRASTX_CONDICOESGERAIS.AsString) then
            with MyModule.DBRichEdit_OBR_TX_CONDICOESGERAIS.DefAttributes do
            begin
                Color := MyModule.DBRichEdit_OBR_TX_CONDICOESGERAIS.Font.Color;
                Size := MyModule.DBRichEdit_OBR_TX_CONDICOESGERAIS.Font.Size;
                Charset := MyModule.DBRichEdit_OBR_TX_CONDICOESGERAIS.Font.Charset;
                Name := MyModule.DBRichEdit_OBR_TX_CONDICOESGERAIS.Font.Name;
                Pitch := MyModule.DBRichEdit_OBR_TX_CONDICOESGERAIS.Font.Pitch;
                Style := MyModule.DBRichEdit_OBR_TX_CONDICOESGERAIS.Font.Style;
            end;

        if not EhRichText(OBRASTX_CONDICAODEPAGAMENTO.AsString) then
            with MyModule.DBRichEdit_OBR_TX_CONDICAODEPAGAMENTO.DefAttributes do
            begin
                Color := MyModule.DBRichEdit_OBR_TX_CONDICAODEPAGAMENTO.Font.Color;
                Size := MyModule.DBRichEdit_OBR_TX_CONDICAODEPAGAMENTO.Font.Size;
                Charset := MyModule.DBRichEdit_OBR_TX_CONDICAODEPAGAMENTO.Font.Charset;
                Name := MyModule.DBRichEdit_OBR_TX_CONDICAODEPAGAMENTO.Font.Name;
                Pitch := MyModule.DBRichEdit_OBR_TX_CONDICAODEPAGAMENTO.Font.Pitch;
                Style := MyModule.DBRichEdit_OBR_TX_CONDICAODEPAGAMENTO.Font.Style;
            end;

        MyModule.Label_OBR_JustificativaSalva.Visible := (OBRAS.State = dsBrowse) and SituacaoJustificavel(OBRASTI_SITUACOES_ID.AsInteger);
    end
    else if aSender = DataSource_PRO then
    begin
        SafeSetActionEnabled(MyModule.Action_PRO_First,ButtonEnabled[0]);
        SafeSetActionEnabled(MyModule.Action_PRO_Previous,ButtonEnabled[1]);
        SafeSetActionEnabled(MyModule.Action_PRO_Next,ButtonEnabled[2]);
        SafeSetActionEnabled(MyModule.Action_PRO_Last,ButtonEnabled[3]);
        SafeSetActionEnabled(Action_PRO_Insert,ButtonEnabled[4] and Action_PRO_Insert.Allowed);
        SafeSetActionEnabled(Action_PRO_Delete,ButtonEnabled[5] and Action_PRO_Delete.Allowed);
        SafeSetActionEnabled(Action_PRO_Edit,ButtonEnabled[6] and Action_PRO_Edit.Allowed);
        SafeSetActionEnabled(MyModule.Action_PRO_Post,ButtonEnabled[7]);
        SafeSetActionEnabled(MyModule.Action_PRO_Cancel,ButtonEnabled[8]);
        SafeSetActionEnabled(MyModule.Action_PRO_Refresh,ButtonEnabled[9]);

        MyModule.BitBtn_PRO_Imprimir.Enabled := (PROPOSTAS.RecordCount > 0) and (PROPOSTAS.State = dsBrowse);

        if PROPOSTASTI_MOEDA.AsInteger > 0 then
	        MyModule.Label_PRO_FL_DESCONTOVAL.Caption := 'Reajuste (' + CURRENCY_STRINGS[PROPOSTASTI_MOEDA.AsInteger] + ')'
        else
            MyModule.Label_PRO_FL_DESCONTOVAL.Caption := 'Reajuste (---)';
            
	    if OBRAS.RecordCount > 0 then
            MyModule.Label_PRO_Info.Caption := 'Existe(m) ' + IntToStr(PROPOSTAS.RecordCount) + ' proposta(s) para a obra "' + OBRASVA_NOMEDAOBRA.AsString + '"'
	    else
		    MyModule.Label_PRO_Info.Caption := 'Ainda não existem obras registradas';
    end
    else if aSender = DataSource_ITE then
    begin
        SafeSetActionEnabled(MyModule.Action_ITE_First,ButtonEnabled[0]);
        SafeSetActionEnabled(MyModule.Action_ITE_Previous,ButtonEnabled[1]);
        SafeSetActionEnabled(MyModule.Action_ITE_Next,ButtonEnabled[2]);
        SafeSetActionEnabled(MyModule.Action_ITE_Last,ButtonEnabled[3]);
        SafeSetActionEnabled(Action_ITE_Insert,ButtonEnabled[4] and Action_ITE_Insert.Allowed);
        SafeSetActionEnabled(Action_ITE_Delete,ButtonEnabled[5] and Action_ITE_Delete.Allowed);
        SafeSetActionEnabled(Action_ITE_Edit,ButtonEnabled[6] and Action_ITE_Edit.Allowed);
        SafeSetActionEnabled(MyModule.Action_ITE_Post,ButtonEnabled[7]);
        SafeSetActionEnabled(MyModule.Action_ITE_Cancel,ButtonEnabled[8]);
        SafeSetActionEnabled(MyModule.Action_ITE_Refresh,ButtonEnabled[9]);

        SafeSetActionEnabled(Action_ITE_MoveUp,ButtonEnabled[0] and Action_ITE_MoveUp.Allowed and ButtonEnabled[6]);
        SafeSetActionEnabled(Action_ITE_MoveDown,ButtonEnabled[3] and Action_ITE_MoveDown.Allowed and ButtonEnabled[6]);
        SafeSetActionEnabled(Action_ITE_Replicar,ButtonEnabled[4] and Action_ITE_Replicar.Allowed);
    	MyModule.CFDBGrid_EDI.Visible := not (ITENS.State in [dsInactive,dsInsert]) and (ITENS.RecordCount > 0);

        MyModule.GroupBox_EQP_Filtro.Visible := MyModule.CFDBGrid_EDI.Visible;
        MyModule.CFDBGrid_EQP.Visible := MyModule.CFDBGrid_EDI.Visible;
        MyModule.Action_EDI_DesmarcarTodos.Visible := MyModule.CFDBGrid_EDI.Visible;

 		if PROPOSTAS.RecordCount > 0 then
    	    MyModule.Label_ITE_Info.Caption := 'A proposta ' + PROPOSTASCODIGO.AsString + ' contém ' + IntToStr(ITENS.RecordCount) + ' ítem(ns)'
	    else
		    MyModule.Label_ITE_Info.Caption := 'Ainda não há propostas registradas';

	    MyModule.DBText_ITE_LUCROBRUTO.Hint := '|Valor integral = ' + MyModule.DBText_ITE_LUCROBRUTO.Field.AsString;
    	MyModule.DBText_ITE_TOTAL.Hint := '|Valor integral = ' + MyModule.DBText_ITE_TOTAL.Field.AsString;
	    MyModule.DBEdit_ITE_FL_DESCONTOPERC.Hint := '|Valor integral = ' + MyModule.DBEdit_ITE_FL_DESCONTOPERC.Field.AsString;

        SetLabelDescriptionValue(MyModule.Label_ITE_Info4,MyModule.DBText_ITE_TOTAL);
        SetLabelDescriptionValue(MyModule.Label_ITE_Info5,MyModule.DBText_ITE_LUCROBRUTO);
    end
    else if aSender = DataSource_EDI then
    begin
        SetLabelDescriptionValue(MyModule.Label_ITE_Info2,MyModule.Label_ITE_Equipamentos,IntToStr(EQUIPAMENTOSDOSITENS.RecordCount));

        SafeSetActionEnabled(Action_EDI_Insert,ButtonEnabled[4] and Action_EDI_Insert.Allowed and (MyModule.CFDBGrid_EQP.SelectedRows.Count > 0));
        SafeSetActionEnabled(Action_EDI_Delete,ButtonEnabled[5] and Action_EDI_Delete.Allowed and (MyModule.CFDBGrid_EDI.SelectedRows.Count > 0));
    end
	else if aSender = DataSource_OBR_SCH then
	begin
        DBPButtonsToggle(TDataSource(aSender).DataSet
                        ,FOBR_SCH_CurrentPage
                        ,OBR_SCH_PageCount
                        ,PButtonEnabled[0]
                        ,PButtonEnabled[1]
                        ,PButtonEnabled[2]
                        ,PButtonEnabled[3]);

        SafeSetActionEnabled(MyModule.Action_OBR_SCH_First,ButtonEnabled[0]);
        SafeSetActionEnabled(MyModule.Action_OBR_SCH_Previous,ButtonEnabled[1]);
        SafeSetActionEnabled(MyModule.Action_OBR_SCH_Next,ButtonEnabled[2]);
        SafeSetActionEnabled(MyModule.Action_OBR_SCH_Last,ButtonEnabled[3]);
        SafeSetActionEnabled(MyModule.Action_OBR_SCH_Refresh,ButtonEnabled[9]);

        SafeSetActionEnabled(MyModule.Action_OBR_SCH_FirstPage,PButtonEnabled[0]);
        SafeSetActionEnabled(MyModule.Action_OBR_SCH_PreviousPage,PButtonEnabled[1]);
        SafeSetActionEnabled(MyModule.Action_OBR_SCH_NextPage,PButtonEnabled[2]);
        SafeSetActionEnabled(MyModule.Action_OBR_SCH_LastPage,PButtonEnabled[3]);

        MyModule.BitBtn_OBR_SCH_MaisDetalhes.Enabled := OBRAS_SEARCH.RecordCount > 0;
        MyModule.Label_OBR_SCH_RegistrosValor.Caption := AnsiStrings.Format(CURRENT_TOTAL,[GetRecordNoInSet(FOBR_SCH_CurrentPage,FOBR_SCH_RecordsByPage,DataSource_OBR_SCH.DataSet.RecNo),OBR_SCH_RecordCount]);
        MyModule.Label_OBR_SCH_PaginasValor.Caption := AnsiStrings.Format(CURRENT_TOTAL,[FOBR_SCH_CurrentPage,OBR_SCH_PageCount]);
	end
	else if aSender = DataSource_PRO_SCH then
	begin
        DBPButtonsToggle(TDataSource(aSender).DataSet
                        ,FPRO_SCH_CurrentPage
                        ,PRO_SCH_PageCount
                        ,PButtonEnabled[0]
                        ,PButtonEnabled[1]
                        ,PButtonEnabled[2]
                        ,PButtonEnabled[3]);

        SafeSetActionEnabled(MyModule.Action_PRO_SCH_First,ButtonEnabled[0]);
        SafeSetActionEnabled(MyModule.Action_PRO_SCH_Previous,ButtonEnabled[1]);
        SafeSetActionEnabled(MyModule.Action_PRO_SCH_Next,ButtonEnabled[2]);
        SafeSetActionEnabled(MyModule.Action_PRO_SCH_Last,ButtonEnabled[3]);
        SafeSetActionEnabled(MyModule.Action_PRO_SCH_Refresh,ButtonEnabled[9]);

        SafeSetActionEnabled(MyModule.Action_PRO_SCH_FirstPage,PButtonEnabled[0]);
        SafeSetActionEnabled(MyModule.Action_PRO_SCH_PreviousPage,PButtonEnabled[1]);
        SafeSetActionEnabled(MyModule.Action_PRO_SCH_NextPage,PButtonEnabled[2]);
        SafeSetActionEnabled(MyModule.Action_PRO_SCH_LastPage,PButtonEnabled[3]);

        MyModule.Action_PRO_SCH_Details.Enabled := PROPOSTAS_SEARCH.RecordCount > 0;
        MyModule.Label_PRO_SCH_RegistrosValor.Caption := AnsiStrings.Format(CURRENT_TOTAL,[GetRecordNoInSet(FPRO_SCH_CurrentPage,FPRO_SCH_RecordsByPage,DataSource_PRO_SCH.DataSet.RecNo),PRO_SCH_RecordCount]);
        MyModule.Label_PRO_SCH_PaginasValor.Caption := AnsiStrings.Format(CURRENT_TOTAL,[FPRO_SCH_CurrentPage,PRO_SCH_PageCount]);
	end
	else if aSender = DataSource_EQP_SCH then
	begin
        DBPButtonsToggle(TDataSource(aSender).DataSet
                        ,FEQP_SCH_CurrentPage
                        ,EQP_SCH_PageCount
                        ,PButtonEnabled[0]
                        ,PButtonEnabled[1]
                        ,PButtonEnabled[2]
                        ,PButtonEnabled[3]);

        SafeSetActionEnabled(MyModule.Action_EQP_SCH_First,ButtonEnabled[0]);
        SafeSetActionEnabled(MyModule.Action_EQP_SCH_Previous,ButtonEnabled[1]);
        SafeSetActionEnabled(MyModule.Action_EQP_SCH_Next,ButtonEnabled[2]);
        SafeSetActionEnabled(MyModule.Action_EQP_SCH_Last,ButtonEnabled[3]);
        SafeSetActionEnabled(MyModule.Action_EQP_SCH_Refresh,ButtonEnabled[9]);

        SafeSetActionEnabled(MyModule.Action_EQP_SCH_FirstPage,PButtonEnabled[0]);
        SafeSetActionEnabled(MyModule.Action_EQP_SCH_PreviousPage,PButtonEnabled[1]);
        SafeSetActionEnabled(MyModule.Action_EQP_SCH_NextPage,PButtonEnabled[2]);
        SafeSetActionEnabled(MyModule.Action_EQP_SCH_LastPage,PButtonEnabled[3]);

        MyModule.Action_EQP_SCH_Details.Enabled := EQUIPAMENTOS_SEARCH.RecordCount > 0;
        MyModule.Label_EQP_SCH_RegistrosValor.Caption := AnsiStrings.Format(CURRENT_TOTAL,[GetRecordNoInSet(FEQP_SCH_CurrentPage,FEQP_SCH_RecordsByPage,DataSource_EQP_SCH.DataSet.RecNo),EQP_SCH_RecordCount]);
        MyModule.Label_EQP_SCH_PaginasValor.Caption := AnsiStrings.Format(CURRENT_TOTAL,[FEQP_SCH_CurrentPage,EQP_SCH_PageCount]);
	end;
   
end;

procedure TBDODataModule_Obras.DoNewRecord(aDataSet: TDataSet);
begin
    inherited;
    { Complementa o relacionamento mestre-detalhe }
    if aDataSet = PROPOSTAS then
        PROPOSTASIN_OBRAS_ID.AsInteger := OBRASIN_OBRAS_ID.AsInteger
    else if aDataSet = ITENS then
        ITENSIN_PROPOSTAS_ID.AsInteger := PROPOSTASIN_PROPOSTAS_ID.AsInteger
    else if aDataSet = EQUIPAMENTOSDOSITENS then
        EQUIPAMENTOSDOSITENSIN_ITENS_ID.AsInteger := ITENSIN_ITENS_ID.AsInteger;
end;

procedure TBDODataModule_Obras.DropTemporaryTables;
begin
    { TODO -oCarlos Feitoza -cEXPLICAÇÃO : Os métodos que são chamados em
    eventos de destruição como este precisam de uma proteção, pois quando
    fechamos a aplicação, as coisas são destruídas em uma ordem inesperada }
    if not Application.Terminated then
    begin
        ExecuteQuery(DataModuleMain.ZConnections.ByName['ZConnection_BDO'].Connection,'DROP TEMPORARY TABLE IF EXISTS PROPOSTAS_SEARCH');
        ExecuteQuery(DataModuleMain.ZConnections.ByName['ZConnection_BDO'].Connection,'DROP TEMPORARY TABLE IF EXISTS OBRAS_SEARCH');
        ExecuteQuery(DataModuleMain.ZConnections.ByName['ZConnection_BDO'].Connection,'DROP TEMPORARY TABLE IF EXISTS EQUIPAMENTOS_SEARCH');
    end;
end;

procedure TBDODataModule_Obras.CreateTemporaryTableEquipamentosSearch;
const
    EQUIPAMENTOS_SEARCH =
    'CREATE TEMPORARY TABLE EQUIPAMENTOS_SEARCH (IN_EQUIPAMENTOSDOSITENS_ID INTEGER'#13#10 +
    '                                           ,IN_PROPOSTAS_ID INTEGER'#13#10 +
    '                                           ,VA_MODELO VARCHAR(64)'#13#10 +
    '                                           ,EN_VOLTAGEM VARCHAR(6)'#13#10 +
    '                                           ,IN_ITENS_ID INTEGER'#13#10 +
//    '                                           ,CODIGO VARCHAR(14)'#13#10 +
    '                                           ,NOMEDAOBRA VARCHAR(128)'#13#10 +
//    '                                           ,INSTALADOR VARCHAR(64)'#13#10 +
//    '                                           ,MOEDA VARCHAR(3)'#13#10 +
    '                                           ,BO_PROPOSTAPADRAO BOOLEAN'#13#10 +
    ')';
begin
    ExecuteQuery(DataModuleMain.ZConnections.ByName['ZConnection_BDO'].Connection,EQUIPAMENTOS_SEARCH);
end;

procedure TBDODataModule_Obras.CreateTemporaryTableObrasSearch;
const
    OBRAS_SEARCH =
    'CREATE TEMPORARY TABLE OBRAS_SEARCH (IN_OBRAS_ID INTEGER'#13#10 +
    '                                    ,TI_REGIOES_ID TINYINT'#13#10 +
    '                                    ,TI_SITUACOES_ID TINYINT'#13#10 +
    '                                    ,NOMEDAOBRA VARCHAR(128)'#13#10 +
    '                                    ,LOCALIDADE VARCHAR(70)'#13#10 +
    '                                    ,REGIAO VARCHAR(8)'#13#10 +
    '                                    ,DATAEHORADACRIACAO DATETIME'#13#10 +
    '                                    ,SITUACAO VARCHAR(32)'#13#10 +
    '                                    ,MOEDA VARCHAR(3)'#13#10 +
    ')';
begin
    ExecuteQuery(DataModuleMain.ZConnections.ByName['ZConnection_BDO'].Connection,OBRAS_SEARCH);
end;

procedure TBDODataModule_Obras.CreateTemporaryTablePropostasSearch;
const
    PROPOSTAS_SEARCH =
    'CREATE TEMPORARY TABLE PROPOSTAS_SEARCH (IN_PROPOSTAS_ID INTEGER'#13#10 +
    '                                        ,BO_PROPOSTAPADRAO BOOLEAN'#13#10 +
    '                                        ,MOEDA VARCHAR(3)'#13#10 +
    '                                        ,CODIGO VARCHAR(14)'#13#10 +
    '                                        ,NOMEDAOBRA VARCHAR(128)'#13#10 +
    '                                        ,LOCALIDADE VARCHAR(128)'#13#10 +
    '                                        ,INSTALADOR VARCHAR(64)'#13#10 +
    '                                        ,SITUACAO VARCHAR(32)'#13#10 +
    ')';
begin
    ExecuteQuery(DataModuleMain.ZConnections.ByName['ZConnection_BDO'].Connection,PROPOSTAS_SEARCH);
end;

procedure TBDODataModule_Obras.EDI_Infromation;
begin
    ShowRecordInformationForm(DataModuleMain.ZConnections.ByName['ZConnection_BDO'].Connection,'EQUIPAMENTOSDOSITENS','IN_EQUIPAMENTOSDOSITENS_ID',EQUIPAMENTOSDOSITENSIN_EQUIPAMENTOSDOSITENS_ID.AsInteger);
end;

procedure TBDODataModule_Obras.EQP_Information;
begin
    ShowRecordInformationForm(DataModuleMain.ZConnections.ByName['ZConnection_BDO'].Connection,'EQUIPAMENTOS','IN_EQUIPAMENTOS_ID',EQUIPAMENTOS_LOOKUPIN_EQUIPAMENTOS_ID.AsInteger);
end;

procedure TBDODataModule_Obras.EQP_SCH_Filtrar(const aEQPFilter: TEQPFilter; const aPageNo, aRecordsByPage: Word; const aOrderBy: AnsiString = 'IN_EQUIPAMENTOSDOSITENS_ID');
const
	SQL_CLEAR = 'DELETE FROM EQUIPAMENTOS_SEARCH';
    SQL_INSERT = 'INSERT INTO EQUIPAMENTOS_SEARCH %s';
var
	WhereClause: String;
    SQLFinal: String;
begin
    Screen.Cursor := crSQLWait;
    try
        { LIMPA A TABELA TEMPORÁRIA (VISUALMENTE NÃO ALTERA NADA) }
        ExecuteQuery(DataModuleMain.ZConnections.ByName['ZConnection_BDO'].Connection,SQL_CLEAR);

        { MONTANDO A CLÁUSULA WHERE QUE SERÁ USADA PARA FILTRAR OS DADOS }
        WhereClause := EQP_SCH_WhereClause(aEQPFilter);

        SQLFinal := AnsiStrings.Format(SQL_EQP_SEARCH_SELECT_FILTERED_RECORDS,[WhereClause,aOrderBy,GetRowOffsetByPageNo(aPageNo,aRecordsByPage),aRecordsByPage]);
        SQLFinal := AnsiStrings.Format(SQL_INSERT,[SQLFinal]);

        { PREENCHENDO A TABELA TEMPORÁRIA APENAS COM OS DADOS FILTRADOS }
        ExecuteQuery(DataModuleMain.ZConnections.ByName['ZConnection_BDO'].Connection,SQLFinal);

        { TODO -oCarlos Feitoza -cEXPLICAÇÃO : Para que nenhum erro de bookmark
        aconteça é necessário desativar os controles associados antes de
        executar um refresh }
        EQUIPAMENTOS_SEARCH.DisableControls;

        { FINALMENTE, ATUALIZANDO A QUERY CORRESPONDENTE...}
        EQUIPAMENTOS_SEARCH.Refresh; { Isso pode demorar um pouco }
    finally
        EQUIPAMENTOS_SEARCH.EnableControls;
        Screen.Cursor := crDefault;
    end;
end;

procedure TBDODataModule_Obras.EQP_SCH_GotoPage(const aPageButton: TDBPageButton; aEQPFilter: TEQPFilter; const aOrderBy: AnsiString; const aPage: Word = 0);
begin
    case aPageButton of
        dpbFirst: FEQP_SCH_CurrentPage := 1;
        dpbPrevious: Dec(FEQP_SCH_CurrentPage);
        dpbNext: Inc(FEQP_SCH_CurrentPage);
        dpbLast: FEQP_SCH_CurrentPage := EQP_SCH_PageCount;
        dpbCustom: FEQP_SCH_CurrentPage := aPage;
    end;
    EQP_SCH_Filtrar(aEQPFilter,FEQP_SCH_CurrentPage,FEQP_SCH_RecordsByPage,aOrderBy);
end;

procedure TBDODataModule_Obras.EQP_SCH_Information;
begin
    ShowRecordInformationForm(DataModuleMain.ZConnections.ByName['ZConnection_BDO'].Connection
                             ,'EQUIPAMENTOSDOSITENS','IN_EQUIPAMENTOSDOSITENS_ID',EQUIPAMENTOS_SEARCHIN_EQUIPAMENTOSDOSITENS_ID.AsInteger);
end;

procedure TBDODataModule_Obras.EQP_SCH_SelecionarObra;
begin
    if OBRAS.Active
   and PROPOSTAS.Active
   and ITENS.Active
   and EQUIPAMENTOSDOSITENS.Active
   and EQUIPAMENTOS_SEARCH.Active then
        if RegiaoPermitidaParaOUsuario(Configurations.AuthenticatedUser.Id,RegiaoDaProposta(EQUIPAMENTOS_SEARCHIN_PROPOSTAS_ID.AsInteger)) then
        begin
            if EQUIPAMENTOS_SEARCH.RecordCount > 0 then
            begin
                OBRAS.Refresh; // Garante que todas as obras estejam disponívis
                OBRAS.Locate('IN_OBRAS_ID',ObraDaProposta(EQUIPAMENTOS_SEARCHIN_PROPOSTAS_ID.AsInteger),[]); // Seleciona a obra para exibição
                PROPOSTAS.Refresh;  // Idem
                PROPOSTAS.Locate('IN_PROPOSTAS_ID',EQUIPAMENTOS_SEARCHIN_PROPOSTAS_ID.AsInteger,[]); // Idem
                ITENS.Refresh; // Idem
                ITENS.Locate('IN_ITENS_ID',EQUIPAMENTOS_SEARCHIN_ITENS_ID.AsInteger,[]); //Idem
                EQUIPAMENTOSDOSITENS.Refresh; // Idem
                EQUIPAMENTOSDOSITENS.Locate('IN_EQUIPAMENTOSDOSITENS_ID',EQUIPAMENTOS_SEARCHIN_EQUIPAMENTOSDOSITENS_ID.AsInteger,[]); //Idem
            end
            else
            begin
               Application.MessageBox('A sua última consulta não gerou resultado algum. Não é possível exibir mais detalhes','Detalhes indisponíveis',MB_ICONWARNING);
               Abort;
            end;
        end
        else
        begin
    	    Application.MessageBox('Você não pode exibir mais detalhes para este equipamento pois a obra, proposta e/ou item que o contém não pertencem a nenhuma de suas regiões de atuação','Detalhes adicionais não disponíveis',MB_ICONWARNING);
            Abort;
        end;
end;

procedure TBDODataModule_Obras.EQP_SCH_UpdateMetrics(const aCFDBGrid: TCFDBGrid; const aEQPFilter: TEQPFilter);
begin
    GetPageAndRecordMetrics(aCFDBGrid
                           ,0                      { Ou cálculo para obter o offset... }
                           ,FEQP_SCH_RecordsByPage { Sempre é calculado... }
                           ,EQP_SCH_PageCount      { Sempre é calculado... }
                           ,FEQP_SCH_CurrentPage   { Apenas para validação... }
                           ,EQP_SCH_RecordCount    { Pode ou não ser alterado, desde que haja um SQL de contagem... }
                           ,Format(SQL_EQP_SEARCH_SELECT_COUNT_RECORDS,[EQP_SCH_WhereClause(aEQPFilter)]));
end;

function TBDODataModule_Obras.EQP_SCH_WhereClause(const aEQPFilter: TEQPFilter): AnsiString;
begin
    Result := '';
    with aEQPFilter do
    begin
        if Trim(VA_MODELO) <> '' then
            Result := Result + '     AND UPPER(EQP.VA_MODELO) LIKE UPPER(' + QuotedStr(VA_MODELO) + ')'#13#10;

        if Trim(EN_VOLTAGEM) <> '(TODAS)' then
          	Result := Result + '     AND UPPER(ITE.EN_VOLTAGEM) LIKE UPPER(' + QuotedStr(EN_VOLTAGEM) + ')'#13#10;

        if SM_CODIGO > 0 then
           	Result := Result + '     AND PRO.SM_CODIGO = ' + IntToStr(SM_CODIGO) + #13#10;

        if YR_ANO > 0 then
           	Result := Result + '     AND PRO.YR_ANO = ' + IntToStr(YR_ANO) + #13#10;

        if BO_PROPOSTAPADRAO <> 2 then
            Result := Result + '     AND PRO.BO_PROPOSTAPADRAO = ' + IntToStr(BO_PROPOSTAPADRAO) + #13#10;

        if SM_INSTALADORES_ID > 0 then
           	Result := Result + '     AND PRO.SM_INSTALADORES_ID = ' + IntToStr(SM_INSTALADORES_ID) + #13#10;

      	Result := StringReplace(Result,'*','%',[rfReplaceAll]);
       	Result := StringReplace(Result,'?','_',[rfReplaceAll]);
    end;
end;

procedure TBDODataModule_Obras.ITE_Information;
begin
    ShowRecordInformationForm(DataModuleMain.ZConnections.ByName['ZConnection_BDO'].Connection,'ITENS','IN_ITENS_ID',ITENSIN_ITENS_ID.AsInteger);
end;

procedure TBDODataModule_Obras.LocalizarEquipamento(const aEdit: TEdit;
                                                    const aFieldName: AnsiString);
begin
    LocateFirstRecord(EQUIPAMENTOS_LOOKUP, aEdit, aFieldName);
end;

procedure TBDODataModule_Obras.AtualizarLabelDeDataDeExpiracao(const UsarRefresh: Boolean);
var
    DataAtualServer: TDateTime;
    DataDaExpiracao: TDateTime;
    BS: TBookmark;
begin
    if UsarRefresh then
        try
            OBRAS.DisableControls;
            BS := OBRAS.Bookmark;
            OBRAS.Refresh;
        finally
            OBRAS.Bookmark := BS;
            OBRAS.EnableControls;
        end;

    DataDaExpiracao := OBRASDA_DATADEEXPIRACAO.AsDateTime;
    DataAtualServer := MySQLDBServerDateAndTime(DataModuleMain.ZConnections[0].Connection);

    if OBRAS.RecordCount = 0 then
    begin
        MyModule.Shape_OBR_DA_DATADEEXPIRACAO.Brush.Color := clRed;
        MyModule.Label_OBR_DA_DATADEEXPIRACAO.Font.Color := clWhite;
        if OBRAS.State = dsBrowse then
            MyModule.Label_OBR_DA_DATADEEXPIRACAO.Caption := 'Nenhum registro selecionado'
        else if OBRAS.State = dsInsert then
            MyModule.Label_OBR_DA_DATADEEXPIRACAO.Caption := 'Inserção em andamento';
    end
    else
    begin
        if OBRAS.State = dsBrowse then
        begin
            MyModule.Shape_OBR_DA_DATADEEXPIRACAO.Brush.Color := clGreen;
            MyModule.Label_OBR_DA_DATADEEXPIRACAO.Font.Color := clWhite;

            if DataDaExpiracao = DATA_NAO_EXPIRAVEL then
                MyModule.Label_OBR_DA_DATADEEXPIRACAO.Caption := 'Esta obra não expira!'
            else
            begin
                if DataAtualServer >= DataDaExpiracao then
                // Expirou
                begin
                    MyModule.Shape_OBR_DA_DATADEEXPIRACAO.Brush.Color := clRed;
                    MyModule.Label_OBR_DA_DATADEEXPIRACAO.Caption := FormatDateTime('"Esta obra expirou em "dd/mm/yyyy"', DataDaExpiracao);
                end
                else if (DataDaExpiracao - DataAtualServer) < 1 then
                // Faltam horas para expirar
                begin
                    MyModule.Label_OBR_DA_DATADEEXPIRACAO.Font.Color := clBlack;
                    MyModule.Shape_OBR_DA_DATADEEXPIRACAO.Brush.Color := clYellow;
                    MyModule.Label_OBR_DA_DATADEEXPIRACAO.Caption := FormatDateTime('"Esta obra expira em "h" hora(s)" e contando...', DataDaExpiracao - DataAtualServer);
                end
                else
                    // Faltam dias para expirar
                    MyModule.Label_OBR_DA_DATADEEXPIRACAO.Caption := AnsiStrings.Format('Esta obra expira em %u dia(s) (%s)', [Trunc(DataDaExpiracao - DataAtualServer), FormatDateTime('dd/mm/yyyy', DataDaExpiracao)]);
            end;
        end
        else
        begin
            MyModule.Shape_OBR_DA_DATADEEXPIRACAO.Brush.Color := clYellow;
            MyModule.Label_OBR_DA_DATADEEXPIRACAO.Font.Color := clBlack;
            case OBRAS.State of
                dsInsert: MyModule.Label_OBR_DA_DATADEEXPIRACAO.Caption := 'Inserção em andamento...';
                dsEdit: MyModule.Label_OBR_DA_DATADEEXPIRACAO.Caption := 'Edição em curso...';
                dsInactive: MyModule.Label_OBR_DA_DATADEEXPIRACAO.Caption := 'DataSet inativo!';
            end;
        end;
    end;
end;

function TBDODataModule_Obras.GetNextItem(const aCurrentItem: Cardinal): Cardinal;
begin
	Result := ExecuteDbFunction(DataModuleMain.ZConnections.ByName['ZConnection_BDO'].Connection, 'FNC_GET_NEXT_ITEM(' + IntToStr(aCurrentItem) + ')').AsDWord;
end;

function TBDODataModule_Obras.GetPreviousItem(const aCurrentItem: Cardinal): Cardinal;
begin
	Result := ExecuteDbFunction(DataModuleMain.ZConnections.ByName['ZConnection_BDO'].Connection, 'FNC_GET_PREVIOUS_ITEM(' + IntToStr(aCurrentItem) + ')').AsDWord;
end;

procedure TBDODataModule_Obras.ExchangePositions(const aItem1, aItem2: Cardinal);
begin
	ExecuteDbProcedure(DataModuleMain.ZConnections.ByName['ZConnection_BDO'].Connection,'PRC_EXCHANGE_POSITIONS(' + IntToStr(aItem1) + ',' + IntToStr(aItem2) + ')');
end;

procedure TBDODataModule_Obras.MoveItemToBottom(const aItemID: Cardinal);
var
	NextItem: Cardinal;
begin
    NextItem := GetNextItem(aItemID);
    if NextItem > 0 then
        ExchangePositions(aItemID,NextItem);
end;

procedure TBDODataModule_Obras.MoveItemToTop(const aItemID: Cardinal);
var
	PreviousItem: Cardinal;
begin
    PreviousItem := GetPreviousItem(aItemID);
    if PreviousItem > 0 then
        ExchangePositions(aItemID,PreviousItem);
end;

procedure TBDODataModule_Obras.CopiarItensDaPropostaPadrao(const aObra, aPropostaDeDestino: Cardinal);
begin
    ExecuteDbProcedure(DataModuleMain.ZConnections.ByName['ZConnection_BDO'].Connection,Format('PRC_COPY_ITEMS_FROM_PROPOSAL(FNC_GET_DEFAULT_PROPOSAL(%u),%u)',[aObra,aPropostaDeDestino]));
end;

procedure TBDODataModule_Obras.ExibirObrasSemelhantes(const aVA_NOMEDAOBRA: AnsiString);
const
    SQL =
    'SELECT OBR.IN_OBRAS_ID'#13#10 +
    '     , OBR.VA_NOMEDAOBRA'#13#10 +
    '     , CONCAT(OBR.VA_CIDADE,'' / '',OBR.CH_ESTADO) AS LOCALIDADE'#13#10 +
    '     , REG.VA_REGIAO AS REGIAO'#13#10 +
    '     , DATE_FORMAT(OBR.DT_DATAEHORADACRIACAO,''%%d/%%m/%%Y'') AS DATADEENTRADA'#13#10 +
    '     , OBR.TI_REGIOES_ID'#13#10 +
    '  FROM OBRAS OBR'#13#10 +
    '  JOIN REGIOES REG USING(TI_REGIOES_ID)'#13#10 +
    ' WHERE %s';
var
    BDOForm_ObrasSemelhantes: TBDOForm_ObrasSemelhantes;
	CreateParameters: TDialogCreateParameters;

begin
    ZeroMemory(@CreateParameters,SizeOf(TDialogCreateParameters));
    try
        BDOForm_ObrasSemelhantes := TBDOForm_ObrasSemelhantes.Create(Self
                                                                    ,BDOForm_ObrasSemelhantes
                                                                    ,CreateParameters);

        { Pesquisando pelo primeiro critério }
        OBRAS_SEARCH_PAR.ParamByName('VA_NOMEDAOBRA').AsString := '%' + aVA_NOMEDAOBRA + '%';
        try
            OBRAS_SEARCH_PAR.DisableControls;
            OBRAS_SEARCH_PAR.Refresh;
        finally
            OBRAS_SEARCH_PAR.EnableControls;
        end;

        { Pesquisando pelo segundo critério }
        OBRAS_SEARCH_PAL.Close;
        try
            OBRAS_SEARCH_PAL.SQL.Text := MySQLFormat(SQL,[ClausulaWherePorPalavras(aVA_NOMEDAOBRA)])
        finally
            OBRAS_SEARCH_PAL.Open;
        end;

        if BDOForm_ObrasSemelhantes.ShowModal = mrOk then
            if BDOForm_ObrasSemelhantes.PageControl_ObrasSemelhantes.ActivePage = BDOForm_ObrasSemelhantes.TabSheet_SentencaParcial then
                OBR_SCH_SEM_SelecionarObra(OBRAS_SEARCH_PAR)
            else if BDOForm_ObrasSemelhantes.PageControl_ObrasSemelhantes.ActivePage = BDOForm_ObrasSemelhantes.TabSheet_PalavrasIndividuais then
                OBR_SCH_SEM_SelecionarObra(OBRAS_SEARCH_PAL);
    finally
        if Assigned(BDOForm_ObrasSemelhantes) then
            BDOForm_ObrasSemelhantes.Free;
    end;
end;


end.

