unit UBDODataModule_ImportarExportarObras;
{ TODO -oCARLOS FEITOZA -cDICAS : CADA NOVA TABELA OU CAMPO TEM DE SER POSTO
AQUI PARA QUE POSSA SER POSSÍVEL EXPORTAR }
interface

uses
    Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
    Dialogs, UBDODataModule, ImgList, ActnList, ExtCtrls, DB,
    ZAbstractRODataset, ZDataset, UBDOForm_ImportarExportarObras, UXXXTypesConstantsAndClasses, UXXXDataModule;

type
	TItemInformation = record
    	FileName: String;
        Observation: String;
    end;

    TItemsInformations = array of TItemInformation;

    TBDODataModule_ImportarExportarObras = class(TBDODataModule)
        OBRAS_SEARCH: TZReadOnlyQuery;
        DS_OBR_FILTRO: TDataSource;
        OpenDialogSelecionarObras: TOpenDialog;
    private
        { Private declarations }
        FItemInformation: TItemsInformations;
        FNomeDaObra: ShortString;
        function ValidarNomeDeArquivoDaObra(aCaminho: TFileName; aNomeDeArquivo: ShortString): TFileName;
        function MyModule: TBDOForm_ImportarExportarObras;
    protected
        procedure DoBeforeOpen(aDataSet: TDataSet); override;
        procedure DoAfterClose(aDataSet: TDataSet); override;
    public
        { Public declarations }
        constructor Create(aOwner: TComponent; aDataModule_BasicCreateParameters: TDataModuleCreateParameters); override;
        procedure ValidarObra(FileName: String);
        procedure ExportarObra(aKey: Cardinal; aFileName, aCaminho: TFileName);
        procedure ImportarObras(const aOutputSQL: Boolean = False);
        procedure OBR_FILTRO_Filtrar;

        property ItemInformation: TItemsInformations read FItemInformation write FItemInformation;
    end;

implementation

{$R *.dfm}

uses
    UObjectFile, StrUtils;

type
    TEquipamentoDoItem = class(TCollectionItem)
  	private
    	FIN_EQUIPAMENTOSDOSITENS_ID: Cardinal;
        FIN_ITENS_ID: Cardinal;
        FIN_EQUIPAMENTOS_ID: Cardinal;
        FFL_LUCROBRUTO: Double;
        FFL_VALORUNITARIO: Currency;
        FTI_MOEDA: Byte;
    published
    	property IN_EQUIPAMENTOSDOSITENS_ID: Cardinal read FIN_EQUIPAMENTOSDOSITENS_ID write FIN_EQUIPAMENTOSDOSITENS_ID;
    	property IN_ITENS_ID: Cardinal read FIN_ITENS_ID write FIN_ITENS_ID;
        property IN_EQUIPAMENTOS_ID: Cardinal read FIN_EQUIPAMENTOS_ID write FIN_EQUIPAMENTOS_ID;
        property FL_LUCROBRUTO: Double	read FFL_LUCROBRUTO write FFL_LUCROBRUTO;
        property FL_VALORUNITARIO: Currency read FFL_VALORUNITARIO write FFL_VALORUNITARIO;
        property TI_MOEDA: Byte read FTI_MOEDA write FTI_MOEDA;
    end;

    TEquipamentosDosItens = class(TCollection)
  	private
    	function GetEquipamento(i: Word): TEquipamentoDoItem;
    public
        function Add: TEquipamentoDoItem;
		property Equipamento[i: Word]: TEquipamentoDoItem read GetEquipamento; default;
    end;

    TItem = class(TCollectionItem)
    private
    	FIN_ITENS_ID: Cardinal;
        FIN_PROPOSTAS_ID: Cardinal;
        FTI_FAMILIAS_ID: Byte;
        FVA_DESCRICAO: ShortString;
        FFL_CAPACIDADE: Double;
        FTI_UNIDADES_ID: Byte;
        FSM_QUANTIDADE: Word;
        FEN_VOLTAGEM: ShortString;
        FFL_DESCONTOPERC: Double;
        FTI_ORDEM: Byte;

	    FEquipamentos: TEquipamentosDosItens;
    public
    	constructor Create(Collection: TCollection); override;
        destructor Destroy; override;
    published
	    property IN_ITENS_ID: Cardinal read FIN_ITENS_ID write FIN_ITENS_ID;
    	property IN_PROPOSTAS_ID: Cardinal read FIN_PROPOSTAS_ID write FIN_PROPOSTAS_ID;
        property TI_FAMILIAS_ID: Byte read FTI_FAMILIAS_ID write FTI_FAMILIAS_ID;
        property VA_DESCRICAO: ShortString read FVA_DESCRICAO write FVA_DESCRICAO;
        property FL_CAPACIDADE: Double read FFL_CAPACIDADE write FFL_CAPACIDADE;
        property TI_UNIDADES_ID: Byte read FTI_UNIDADES_ID write FTI_UNIDADES_ID;
        property SM_QUANTIDADE: Word read FSM_QUANTIDADE write FSM_QUANTIDADE;
        property EN_VOLTAGEM: ShortString read FEN_VOLTAGEM write FEN_VOLTAGEM;
        property FL_DESCONTOPERC: Double read FFL_DESCONTOPERC write FFL_DESCONTOPERC;
        property TI_ORDEM: Byte read FTI_ORDEM write FTI_ORDEM;
        
        property Equipamentos: TEquipamentosDosItens read FEquipamentos write FEquipamentos;
    end;

    TItens = class(TCollection)
	private
    	function GetItem(i: Word): TItem;
    public
        function Add: TItem;
		property Item[i: Word]: TItem read GetItem; default;
    end;

    TProposta = class(TCollectionItem)
    private
        { Ano e codigo não são usados pois ao se importar, os dados serão reinseridos }
        FIN_PROPOSTAS_ID: Cardinal;
        FIN_OBRAS_ID: Cardinal;
        FSM_INSTALADORES_ID: Word;
        FVA_CONTATO: ShortString;
        FBO_PROPOSTAPADRAO: Boolean;
        FFL_DESCONTOPERC: Double;
        FFL_DESCONTOVAL: Double;
        FTI_MOEDA: Byte;
        FVA_COTACOES: ShortString;
        FTI_VALIDADE: Byte;

        FItens: TItens;
    public
    	constructor Create(Collection: TCollection); override;
        destructor Destroy; override;
    published
    	property IN_PROPOSTAS_ID: Cardinal read FIN_PROPOSTAS_ID write FIN_PROPOSTAS_ID;
		property IN_OBRAS_ID: Cardinal read FIN_OBRAS_ID write FIN_OBRAS_ID;
        property SM_INSTALADORES_ID: Word read FSM_INSTALADORES_ID write FSM_INSTALADORES_ID;
        property VA_CONTATO: ShortString read FVA_CONTATO write FVA_CONTATO;
        property BO_PROPOSTAPADRAO: Boolean read FBO_PROPOSTAPADRAO write FBO_PROPOSTAPADRAO;
        property FL_DESCONTOPERC: Double read FFL_DESCONTOPERC write FFL_DESCONTOPERC;
        property FL_DESCONTOVAL: Double read FFL_DESCONTOVAL write FFL_DESCONTOVAL;
        property TI_MOEDA: Byte read FTI_MOEDA write FTI_MOEDA;
        property VA_COTACOES: ShortString read FVA_COTACOES write FVA_COTACOES;
        property TI_VALIDADE: Byte read FTI_VALIDADE write FTI_VALIDADE;

        property Itens: TItens read FItens write FItens;
    end;

    TPropostas = class(TCollection)
	private
	    function GetProposta(i: Word): TProposta;
    public
        function Add: TProposta;
		property Proposta[i: Word]: TProposta read GetProposta; default;
    end;

    TJustificativaDaObra = class(TCollectionItem)
    private
        FMI_JUSTIFICATIVASDASOBRAS_ID: Cardinal;
        FIN_OBRAS_ID: Cardinal;
        FTI_JUSTIFICATIVAS_ID: Word;
    published
    	property MI_JUSTIFICATIVASDASOBRAS_ID: Cardinal read FMI_JUSTIFICATIVASDASOBRAS_ID write FMI_JUSTIFICATIVASDASOBRAS_ID;
		property IN_OBRAS_ID: Cardinal read FIN_OBRAS_ID write FIN_OBRAS_ID;
        property TI_JUSTIFICATIVAS_ID: Word read FTI_JUSTIFICATIVAS_ID write FTI_JUSTIFICATIVAS_ID;
    end;

    TJustificativasDasObras = class(TCollection)
	private
	    function GetJustificativaDaObra(i: Word): TJustificativaDaObra;
    public
        function Add: TJustificativaDaObra;
		property JustificativaDaObra[i: Word]: TJustificativaDaObra read GetJustificativaDaObra; default;
    end;

    TObra = class(TObjectFile)
    private
        FIN_OBRAS_ID: Cardinal;
        FTI_REGIOES_ID: Byte;
        FVA_NOMEDAOBRA: String;
        FVA_CIDADE: String;
        FCH_ESTADO: ShortString;
        FTI_SITUACOES_ID: Byte;
        FVA_PRAZODEENTREGA: String;
        FYR_ANOPROVAVELDEENTREGA: Word;
        FTI_MESPROVAVELDEENTREGA: Byte;
        FTX_CONDICAODEPAGAMENTO: String;
        FFL_ICMS: Double;
        FEN_FRETE: ShortString;
        FTX_CONDICOESGERAIS: String;
        FTX_OBSERVACOES: String;
        FSM_USUARIOJUSTIFICADOR_ID: Word;
        FVA_CONSTRUTORA: String;
        FTI_TIPOS_ID: Byte;
        FSM_PROJETISTAS_ID: Word;
    	FDA_DATADEEXPIRACAO: TDateTime;

        FPropostas: TPropostas;
        FJustificativasDasObras: TJustificativasDasObras;
    public
    	constructor Create(AOwner: TComponent); override;
        destructor Destroy; override;
        procedure Clear; override;
    published
    	property IN_OBRAS_ID: Cardinal read FIN_OBRAS_ID write FIN_OBRAS_ID;
        property TI_REGIOES_ID: Byte read FTI_REGIOES_ID write FTI_REGIOES_ID;
        property VA_NOMEDAOBRA: String read FVA_NOMEDAOBRA write FVA_NOMEDAOBRA;
        property VA_CIDADE: String read FVA_CIDADE write FVA_CIDADE;
        property CH_ESTADO: ShortString read FCH_ESTADO write FCH_ESTADO;
        property TI_SITUACOES_ID: Byte read FTI_SITUACOES_ID write FTI_SITUACOES_ID;
        property VA_PRAZODEENTREGA: String read FVA_PRAZODEENTREGA write FVA_PRAZODEENTREGA;
        property YR_ANOPROVAVELDEENTREGA: Word read FYR_ANOPROVAVELDEENTREGA write FYR_ANOPROVAVELDEENTREGA;
        property TI_MESPROVAVELDEENTREGA: Byte read FTI_MESPROVAVELDEENTREGA write FTI_MESPROVAVELDEENTREGA;
        property TX_CONDICAODEPAGAMENTO: String read FTX_CONDICAODEPAGAMENTO write FTX_CONDICAODEPAGAMENTO;
        property FL_ICMS: Double read FFL_ICMS write FFL_ICMS;
        property EN_FRETE: ShortString read FEN_FRETE write FEN_FRETE;
        property TX_CONDICOESGERAIS: String read FTX_CONDICOESGERAIS write FTX_CONDICOESGERAIS;
        property TX_OBSERVACOES: String read FTX_OBSERVACOES write FTX_OBSERVACOES;
        property SM_USUARIOJUSTIFICADOR_ID: Word read FSM_USUARIOJUSTIFICADOR_ID write FSM_USUARIOJUSTIFICADOR_ID;
        property VA_CONSTRUTORA: String read FVA_CONSTRUTORA write FVA_CONSTRUTORA;
        property TI_TIPOS_ID: Byte read FTI_TIPOS_ID write FTI_TIPOS_ID;
        property SM_PROJETISTAS_ID: Word read FSM_PROJETISTAS_ID write FSM_PROJETISTAS_ID;
        property DA_DATADEEXPIRACAO: TDateTime read FDA_DATADEEXPIRACAO write FDA_DATADEEXPIRACAO;

        property Propostas: TPropostas read FPropostas write FPropostas;
        property JustificativasDasObras: TJustificativasDasObras read FJustificativasDasObras write FJustificativasDasObras;
    end;

const
	EXPORTEDFILE_EXTENSION = '.oex';

    SELECT_WORK =
    'SELECT OBR.IN_OBRAS_ID'#13#10 +
    '     , OBR.TI_REGIOES_ID'#13#10 +
    '     , OBR.VA_NOMEDAOBRA'#13#10 +
    '     , OBR.VA_CIDADE'#13#10 +
    '     , OBR.CH_ESTADO'#13#10 +
    '     , OBR.TI_SITUACOES_ID'#13#10 +
    '     , OBR.VA_PRAZODEENTREGA'#13#10 +
    '     , OBR.YR_ANOPROVAVELDEENTREGA'#13#10 +
    '     , OBR.TI_MESPROVAVELDEENTREGA'#13#10 +
    '     , OBR.TX_CONDICAODEPAGAMENTO'#13#10 +
    '     , OBR.FL_ICMS'#13#10 +
    '     , OBR.EN_FRETE'#13#10 +
    '     , OBR.TX_CONDICOESGERAIS'#13#10 +
    '     , OBR.TX_OBSERVACOES'#13#10 +
    '     , OBR.SM_USUARIOJUSTIFICADOR_ID'#13#10 +
    '     , OBR.VA_CONSTRUTORA'#13#10 +
    '     , OBR.TI_TIPOS_ID'#13#10 +
    '     , OBR.SM_PROJETISTAS_ID'#13#10 +
    '     , OBR.DA_DATADEEXPIRACAO'#13#10 +
    '  FROM OBRAS OBR'#13#10 +
    ' WHERE OBR.IN_OBRAS_ID = %u';

    SELECT_PROPOSAL_FROM_WORK =
    'SELECT PRO.IN_PROPOSTAS_ID'#13#10 +
    '     , PRO.IN_OBRAS_ID'#13#10 +
    '     , PRO.SM_INSTALADORES_ID'#13#10 +
    '     , PRO.VA_CONTATO'#13#10 +
    '     , PRO.BO_PROPOSTAPADRAO'#13#10 +
    '     , PRO.FL_DESCONTOPERC'#13#10 +
    '     , PRO.FL_DESCONTOVAL'#13#10 +
    '     , PRO.TI_MOEDA'#13#10 +
    '     , PRO.VA_COTACOES'#13#10 +
    '     , PRO.TI_VALIDADE'#13#10 +
    '  FROM PROPOSTAS PRO'#13#10 +
    ' WHERE PRO.IN_OBRAS_ID = %u';

    SELECT_ITEMS_FROM_PROPOSAL =
    '  SELECT ITE.IN_ITENS_ID'#13#10 +
    '       , ITE.IN_PROPOSTAS_ID'#13#10 +
    '       , ITE.TI_FAMILIAS_ID'#13#10 +
    '       , ITE.VA_DESCRICAO'#13#10 +
    '       , ITE.FL_CAPACIDADE'#13#10 +
    '       , ITE.TI_UNIDADES_ID'#13#10 +
    '       , ITE.SM_QUANTIDADE'#13#10 +
    '       , ITE.EN_VOLTAGEM'#13#10 +
    '       , ITE.FL_DESCONTOPERC'#13#10 +
    '       , ITE.TI_ORDEM'#13#10 +
    '    FROM ITENS ITE'#13#10 +
    '   WHERE ITE.IN_PROPOSTAS_ID = %u'#13#10 +
    'ORDER BY ITE.TI_ORDEM';

    SELECT_EQUIPMENTS_FROM_ITEM =
    'SELECT EDI.IN_EQUIPAMENTOSDOSITENS_ID'#13#10 +
    '     , EDI.IN_ITENS_ID'#13#10 +
    '     , EDI.IN_EQUIPAMENTOS_ID'#13#10 +
    '     , EDI.FL_LUCROBRUTO'#13#10 +
    '     , EDI.FL_VALORUNITARIO'#13#10 +
    '     , EDI.TI_MOEDA'#13#10 +
    '  FROM EQUIPAMENTOSDOSITENS EDI'#13#10 +
    ' WHERE EDI.IN_ITENS_ID = %u';

    SELECT_JUSTIFICATIONS_FROM_WORK =    
    'SELECT JDO.MI_JUSTIFICATIVASDASOBRAS_ID'#13#10 +
    '     , JDO.IN_OBRAS_ID'#13#10 +
    '     , JDO.TI_JUSTIFICATIVAS_ID'#13#10 +
    '  FROM JUSTIFICATIVASDASOBRAS JDO'#13#10 +
    ' WHERE JDO.IN_OBRAS_ID = %u';

{ TBDODataModule_ImportarExportarObras }

constructor TBDODataModule_ImportarExportarObras.Create(aOwner: TComponent; aDataModule_BasicCreateParameters: TDataModuleCreateParameters);
begin
    FNomeDaObra := QuotedStr(UpperCase(FNomeDaObra));
    inherited;
end;

procedure TBDODataModule_ImportarExportarObras.DoAfterClose(aDataSet: TDataSet);
begin
    inherited;
    if (MyModule.Edit_OBR_FILTRO_VA_NOMEDAOBRA.Text <> '') then
        FNomeDaObra := MyModule.Edit_OBR_FILTRO_VA_NOMEDAOBRA.Text
    else
        FNomeDaObra := '%';

    FNomeDaObra := StringReplace(FNomeDaObra,'*','%',[rfReplaceAll]);
    FNomeDaObra := StringReplace(FNomeDaObra,'?','_',[rfReplaceAll]);
    FNomeDaObra := QuotedStr(UpperCase(FNomeDaObra));
end;

procedure TBDODataModule_ImportarExportarObras.DoBeforeOpen(aDataSet: TDataSet);
const
    SQL_PADRAO =
'   SELECT :DISTINCT:'#13#10 +
'          OBR.IN_OBRAS_ID'#13#10 +
'        , OBR.VA_NOMEDAOBRA'#13#10 +
'        , CONCAT(OBR.VA_CIDADE,'' / '',OBR.CH_ESTADO) AS LOCALIDADE'#13#10 +
'     FROM OBRAS OBR'#13#10 +
':NOTSYNC1:' +
'    WHERE OBR.TI_REGIOES_ID IN (:REGIOES:)'#13#10 +
'      AND UPPER(OBR.VA_NOMEDAOBRA) LIKE :NOMEDAOBRA:' +
':NOTSYNC2:';

    NOTSYNC1 =
'LEFT JOIN PROPOSTAS PRO USING (IN_OBRAS_ID)'#13#10 +
'LEFT JOIN ITENS ITE USING (IN_PROPOSTAS_ID)'#13#10 +
'LEFT JOIN EQUIPAMENTOSDOSITENS EDI USING (IN_ITENS_ID)'#13#10 +
'     JOIN DELTA DEL'#13#10;

    NOTSYNC2 =
#13#10 +
'      AND ((    DEL.VA_NOMEDATABELA = ''OBRAS'' AND DEL.VA_CHAVE = OBR.IN_OBRAS_ID)'#13#10 +
'            OR (DEL.VA_NOMEDATABELA = ''PROPOSTAS'' AND DEL.VA_CHAVE = PRO.IN_PROPOSTAS_ID)'#13#10 +
'            OR (DEL.VA_NOMEDATABELA = ''ITENS'' AND DEL.VA_CHAVE = ITE.IN_ITENS_ID)'#13#10 +
'            OR (DEL.VA_NOMEDATABELA = ''EQUIPAMENTOSDOSITENS'' AND DEL.VA_CHAVE = EDI.IN_EQUIPAMENTOSDOSITENS_ID))';



//	SQL_FULL_DISTINCT =
//    'SELECT DISTINCT'#13#10;
//
//	SQL_FULL_NORMAL =
//    'SELECT'#13#10;
//
//	SQL_FULL =
//    '  OBR.IN_OBRAS_ID,'#13#10 +
//    '  OBR.VA_NOMEDAOBRA,'#13#10 +
//    '  CONCAT(OBR.VA_CIDADE,'' / '',OBR.CH_ESTADO) AS LOCALIDADE'#13#10 +
//    'FROM'#13#10 +
//    '  OBRAS OBR';
//
//	SQL_NOTSYNC_COMPLEMENT =
//    #13#10 +
//    ' LEFT JOIN PROPOSTAS PRO USING (IN_OBRAS_ID)'#13#10 +
//    ' LEFT JOIN ITENS ITE USING (IN_PROPOSTAS_ID)'#13#10 +
//    ' LEFT JOIN EQUIPAMENTOSDOSITENS EDI USING (IN_ITENS_ID)'#13#10 +
//    '     WHERE OBR.IN_OBRAS_ID IN (SELECT VA_CHAVE FROM DELTA WHERE VA_NOMEDATABELA LIKE ''OBRAS'') OR OBR.IN_OBRAS_ID IN (SELECT TRIM(''IN_OBRAS_ID='' FROM VA_MESTRES) FROM DELTA WHERE VA_NOMEDATABELA LIKE ''PROPOSTAS'')'#13#10 +
//    '        OR PRO.IN_PROPOSTAS_ID IN (SELECT VA_CHAVE FROM DELTA WHERE VA_NOMEDATABELA LIKE ''PROPOSTAS'') OR PRO.IN_PROPOSTAS_ID IN (SELECT TRIM(''IN_PROPOSTAS_ID='' FROM VA_MESTRES) FROM DELTA WHERE VA_NOMEDATABELA LIKE ''ITENS'')'#13#10 +
//    '        OR ITE.IN_ITENS_ID IN (SELECT VA_CHAVE FROM DELTA WHERE VA_NOMEDATABELA LIKE ''ITENS'') OR ITE.IN_ITENS_ID IN (SELECT TRIM(''IN_ITENS_ID='' FROM VA_MESTRES) FROM DELTA WHERE VA_NOMEDATABELA LIKE ''EQUIPAMENTOSDOSITENS'')'#13#10 +
//    '        OR EDI.IN_EQUIPAMENTOSDOSITENS_ID IN (SELECT VA_CHAVE FROM DELTA WHERE VA_NOMEDATABELA LIKE ''EQUIPAMENTOSDOSITENS'')';
var
    Opcao: Byte;
    Sql: String;
begin
//    Opcao := 0;
//    if Assigned(MyModule.RadioGroupFiltragem) then
//        Opcao := MyModule.RadioGroupFiltragem.ItemIndex;
//
//    case Opcao of
//        0: OBRAS_SEARCH.SQL.Text := SQL_FULL_NORMAL + SQL_FULL + ' WHERE TI_REGIOES_ID IN (' + ArrayOfByteToString(RegioesDoUsuario(Configurations.AuthenticatedUser.Id)) + ') AND UPPER(VA_NOMEDAOBRA) LIKE ' + FNomeDaObra;
//        1: OBRAS_SEARCH.SQL.Text := SQL_FULL_DISTINCT + SQL_FULL + SQL_NOTSYNC_COMPLEMENT + ' AND TI_REGIOES_ID IN (' + ArrayOfByteToString(RegioesDoUsuario(Configurations.AuthenticatedUser.Id)) + ') AND UPPER(VA_NOMEDAOBRA) LIKE ' + FNomeDaObra;
//    end;

    Opcao := 0;

    if Assigned(MyModule.RadioGroupFiltragem) then
        Opcao := MyModule.RadioGroupFiltragem.ItemIndex;

    case Opcao of
        0: begin
            Sql := StringReplace(SQL_PADRAO,':DISTINCT:','',[]);
            Sql := StringReplace(Sql,':NOTSYNC1:','',[]);
            Sql := StringReplace(Sql,':NOTSYNC2:','',[]);
        end;
        1: begin
            Sql := StringReplace(SQL_PADRAO,':DISTINCT:','DISTINCT',[]);
            Sql := StringReplace(Sql,':NOTSYNC1:',NOTSYNC1,[]);
            Sql := StringReplace(Sql,':NOTSYNC2:',NOTSYNC2,[]);
        end;
    end;

    Sql := StringReplace(Sql,':REGIOES:',ArrayOfByteToString(RegioesDoUsuario(Configurations.AuthenticatedUser.Id)),[]);
    Sql := StringReplace(Sql,':NOMEDAOBRA:',FNomeDaObra,[]);
    OBRAS_SEARCH.SQL.Text := Trim(Sql);
    inherited;
end;

procedure TBDODataModule_ImportarExportarObras.ExportarObra(aKey: Cardinal; aFileName, aCaminho: TFileName);
var
    RODataSetObras, RODataSetPropostas, RODataSetItens,
    RODataSetEquipamentosDosItens, RODataSetJustificativasDasObras: TZReadOnlyQuery;
    FinalSQL: String;
    Obra: TObra;
    Proposta: TProposta;
    Item: TItem;
    EquipamentoDoItem: TEquipamentoDoItem;
begin
	FinalSQL := '';
    RODataSetObras := nil;
    RODataSetPropostas := nil;
    Obra := nil;

	try
        { Selecionando todos os campos do registro identificado por AKey na Obra }
        ConfigureDataSet(DataModuleMain.ZConnections.ByName['ZConnection_BDO'].Connection
                        ,RODataSetObras
                        ,MySQLFormat(SELECT_WORK,[aKey]));

        Obra := TObra.Create(nil);
        with Obra do
        begin
        	IN_OBRAS_ID := RODataSetObras.FieldByName('IN_OBRAS_ID').AsInteger; // USADO APENAS NA NOMEAÇÃO DE VARIAVEIS SQL
	        TI_REGIOES_ID := RODataSetObras.FieldByName('TI_REGIOES_ID').AsInteger;
    	    VA_NOMEDAOBRA := RODataSetObras.FieldByName('VA_NOMEDAOBRA').AsString;
            VA_CIDADE := RODataSetObras.FieldByName('VA_CIDADE').AsString;
            CH_ESTADO := RODataSetObras.FieldByName('CH_ESTADO').AsString;
            TI_SITUACOES_ID := RODataSetObras.FieldByName('TI_SITUACOES_ID').AsInteger;
            VA_PRAZODEENTREGA := RODataSetObras.FieldByName('VA_PRAZODEENTREGA').AsString;
            YR_ANOPROVAVELDEENTREGA := RODataSetObras.FieldByName('YR_ANOPROVAVELDEENTREGA').AsInteger;
            TI_MESPROVAVELDEENTREGA := RODataSetObras.FieldByName('TI_MESPROVAVELDEENTREGA').AsInteger;
            TX_CONDICAODEPAGAMENTO := RODataSetObras.FieldByName('TX_CONDICAODEPAGAMENTO').AsString;
            FL_ICMS := RODataSetObras.FieldByName('FL_ICMS').AsFloat;
            EN_FRETE := RODataSetObras.FieldByName('EN_FRETE').AsString;
            TX_CONDICOESGERAIS := RODataSetObras.FieldByName('TX_CONDICOESGERAIS').AsString;
            TX_OBSERVACOES := RODataSetObras.FieldByName('TX_OBSERVACOES').AsString;
            SM_USUARIOJUSTIFICADOR_ID := RODataSetObras.FieldByName('SM_USUARIOJUSTIFICADOR_ID').AsInteger;
            VA_CONSTRUTORA := RODataSetObras.FieldByName('VA_CONSTRUTORA').AsString;
            TI_TIPOS_ID := RODataSetObras.FieldByName('TI_TIPOS_ID').AsInteger;
            SM_PROJETISTAS_ID := RODataSetObras.FieldByName('SM_PROJETISTAS_ID').AsInteger;
            DA_DATADEEXPIRACAO := RODataSetObras.FieldByName('DA_DATADEEXPIRACAO').AsDateTime;
        end;

        { Obtendo cada uma das possíveis justificativas }
        ConfigureDataSet(DataModuleMain.ZConnections.ByName['ZConnection_BDO'].Connection
                        ,RODataSetJustificativasDasObras
                        ,MySQLFormat(SELECT_JUSTIFICATIONS_FROM_WORK,[aKey]));

        while not RODataSetJustificativasDasObras.Eof do
        begin
            with Obra.JustificativasDasObras.Add do
            begin
                MI_JUSTIFICATIVASDASOBRAS_ID := RODataSetJustificativasDasObras.FieldByName('MI_JUSTIFICATIVASDASOBRAS_ID').AsInteger;
                IN_OBRAS_ID := RODataSetJustificativasDasObras.FieldByName('IN_OBRAS_ID').AsInteger;
                TI_JUSTIFICATIVAS_ID := RODataSetJustificativasDasObras.FieldByName('TI_JUSTIFICATIVAS_ID').AsInteger;
            end;
            RODataSetJustificativasDasObras.Next;
        end;

    	{Criando datasets que serão usados em loops. Eles são criados apenas uma
        vez. Dentro de cada loop eles são configurados. }
        RODataSetItens := TZReadOnlyQuery.Create(Self);
        RODataSetEquipamentosDosItens := TZReadOnlyQuery.Create(Self);

	    { Obtendo cada uma das possíveis propostas registradas }
        ConfigureDataSet(DataModuleMain.ZConnections.ByName['ZConnection_BDO'].Connection
                        ,RODataSetPropostas
                        ,MySQLFormat(SELECT_PROPOSAL_FROM_WORK,[aKey]));
                        
        while not RODataSetPropostas.Eof do
        begin
            Proposta := Obra.Propostas.Add;
            with Proposta do
            begin
            	IN_PROPOSTAS_ID := RODataSetPropostas.FieldByName('IN_PROPOSTAS_ID').AsInteger; // USADO APENAS NA NOMEAÇÃO DE VARIAVEIS SQL
            	IN_OBRAS_ID := RODataSetPropostas.FieldByName('IN_OBRAS_ID').AsInteger; // USADO APENAS NA NOMEAÇÃO DE VARIAVEIS SQL
                SM_INSTALADORES_ID := RODataSetPropostas.FieldByName('SM_INSTALADORES_ID').AsInteger;
	            VA_CONTATO := RODataSetPropostas.FieldByName('VA_CONTATO').AsString;
                BO_PROPOSTAPADRAO := RODataSetPropostas.FieldByName('BO_PROPOSTAPADRAO').AsInteger = 1;
                FL_DESCONTOPERC := RODataSetPropostas.FieldByName('FL_DESCONTOPERC').AsFloat;
                FL_DESCONTOVAL := RODataSetPropostas.FieldByName('FL_DESCONTOVAL').AsFloat;
                TI_MOEDA := RODataSetPropostas.FieldByName('TI_MOEDA').AsInteger;
                VA_COTACOES := RODataSetPropostas.FieldByName('VA_COTACOES').AsString;
                TI_VALIDADE := RODataSetPropostas.FieldByName('TI_VALIDADE').AsInteger;
            end;

            { Obtendo cada um dos ítens da proposta }
            ConfigureDataSet(DataModuleMain.ZConnections.ByName['ZConnection_BDO'].Connection
                            ,RODataSetItens
                            ,MySQLFormat(SELECT_ITEMS_FROM_PROPOSAL,[RODataSetPropostas.FieldByName('IN_PROPOSTAS_ID').AsInteger])
                            ,False);

            while not RODataSetItens.Eof do
            begin
            	Item := Proposta.Itens.Add;
                with Item do
                begin
                	IN_ITENS_ID := RODataSetItens.FieldByName('IN_ITENS_ID').AsInteger; // USADO APENAS NA NOMEAÇÃO DE VARIAVEIS SQL
                	IN_PROPOSTAS_ID := RODataSetItens.FieldByName('IN_PROPOSTAS_ID').AsInteger; // USADO APENAS NA NOMEAÇÃO DE VARIAVEIS SQL
                    TI_FAMILIAS_ID := RODataSetItens.FieldByName('TI_FAMILIAS_ID').AsInteger;
                    VA_DESCRICAO := RODataSetItens.FieldByName('VA_DESCRICAO').AsString;
                    FL_CAPACIDADE := RODataSetItens.FieldByName('FL_CAPACIDADE').AsFloat;
                    TI_UNIDADES_ID := RODataSetItens.FieldByName('TI_UNIDADES_ID').AsInteger;
                    SM_QUANTIDADE := RODataSetItens.FieldByName('SM_QUANTIDADE').AsInteger;
                    EN_VOLTAGEM := RODataSetItens.FieldByName('EN_VOLTAGEM').AsString;
                    FL_DESCONTOPERC := RODataSetItens.FieldByName('FL_DESCONTOPERC').AsFloat;
                    TI_ORDEM := RODataSetItens.FieldByName('TI_ORDEM').AsInteger;
                end;

                { Obtendo cada um dos equipamentos dos ítens da proposta }
                ConfigureDataSet(DataModuleMain.ZConnections.ByName['ZConnection_BDO'].Connection
                                ,RODataSetEquipamentosDosItens
                                ,MySQLFormat(SELECT_EQUIPMENTS_FROM_ITEM,[RODataSetItens.FieldByName('IN_ITENS_ID').AsInteger])
                                ,False);
                                
                while not RODataSetEquipamentosDosItens.Eof do
                begin
                	EquipamentoDoItem := Item.Equipamentos.Add;
                    with EquipamentoDoItem do
                    begin
                    	IN_EQUIPAMENTOSDOSITENS_ID := RODataSetEquipamentosDosItens.FieldByName('IN_EQUIPAMENTOSDOSITENS_ID').AsInteger; // USADO APENAS NA NOMEAÇÃO DE VARIAVEIS SQL
                    	IN_ITENS_ID := RODataSetEquipamentosDosItens.FieldByName('IN_ITENS_ID').AsInteger; // USADO APENAS NA NOMEAÇÃO DE VARIAVEIS SQL
                        IN_EQUIPAMENTOS_ID := RODataSetEquipamentosDosItens.FieldByName('IN_EQUIPAMENTOS_ID').AsInteger;
                        FL_LUCROBRUTO := RODataSetEquipamentosDosItens.FieldByName('FL_LUCROBRUTO').AsFloat;
                        FL_VALORUNITARIO := RODataSetEquipamentosDosItens.FieldByName('FL_VALORUNITARIO').AsFloat;
                        TI_MOEDA := RODataSetEquipamentosDosItens.FieldByName('TI_MOEDA').AsInteger;
                    end;
                	RODataSetEquipamentosDosItens.Next;
                end;
            	RODataSetItens.Next;
            end;
        	RODataSetPropostas.Next;
        end;
    finally
    	if Assigned(Obra) then
        begin
        	Obra.SaveToBinaryFile(ValidarNomeDeArquivoDaObra(aCaminho,aFileName));
        	Obra.Free;
        end;
    	if Assigned(RODataSetObras) then
        	RODataSetObras.Free;
    	if Assigned(RODataSetPropostas) then
        	RODataSetPropostas.Free;
    	if Assigned(RODataSetItens) then
        	RODataSetItens.Free;
    	if Assigned(RODataSetEquipamentosDosItens) then
        	RODataSetEquipamentosDosItens.Free;
	end;
end;

procedure TBDODataModule_ImportarExportarObras.ImportarObras(const aOutputSQL: Boolean = False);

    function HexStr(aAscii: String): String;
    begin
        Result := Hex(aASCII);
        if Result <> '' then
            Result := 'x' + QuotedStr(Result)
        else
            Result := 'NULL';
    end;

const
    { TODO : Como nas tabelas envolvidas não existem campos únicos consideráveis,
    toda informação inserida é duplicacável, e consequentemente nenhuma verifição
    precisa ser feita pois tudo irá acontecer corretamente e se não acontecer
    será feito rollback de tudo. Estratégia do tudo ou nada }

    SQL_INSERIR_OBRA =
    '# IMPORTANDO OBRA "%s"'#13#10 +
    'INSERT INTO OBRAS (TI_REGIOES_ID'#13#10 +
    '                  ,VA_NOMEDAOBRA'#13#10 +
    '                  ,VA_CIDADE'#13#10 +
    '                  ,CH_ESTADO'#13#10 +
    '                  ,TI_SITUACOES_ID'#13#10 +
    '                  ,VA_PRAZODEENTREGA'#13#10 +
    '                  ,YR_ANOPROVAVELDEENTREGA'#13#10 +
    '                  ,TI_MESPROVAVELDEENTREGA'#13#10 +
    '                  ,TX_CONDICAODEPAGAMENTO'#13#10 +
    '                  ,FL_ICMS'#13#10 +
    '                  ,EN_FRETE'#13#10 +
    '                  ,TX_CONDICOESGERAIS'#13#10 +
    '                  ,TX_OBSERVACOES'#13#10 +
    '                  ,SM_USUARIOJUSTIFICADOR_ID'#13#10 +
    '                  ,VA_CONSTRUTORA'#13#10 +
    '                  ,TI_TIPOS_ID'#13#10 +
    '                  ,SM_PROJETISTAS_ID'#13#10 +
    '                  ,DA_DATADEEXPIRACAO)'#13#10 +
    'VALUES (%u,%s,%s,%s,%u,%s,%u,%u,%s,%.4f,%s,%s,%s,%s,%s,%u,%u,%s);'#13#10 +
    'DO @OBRA%u := LAST_INSERT_ID();'#13#10;

    SQL_INSERIR_JUSTIFICATIVASDASOBRAS =
    'INSERT INTO JUSTIFICATIVASDASOBRAS (IN_OBRAS_ID'#13#10 +
    '                                   ,TI_JUSTIFICATIVAS_ID)'#13#10 +
    'VALUES (@OBRA%u,%u);'#13#10 +
    'DO @JUSTIFICATIVASDASOBRAS%u := LAST_INSERT_ID();'#13#10;

    SQL_INSERIR_PROPOSTA =
    'INSERT INTO PROPOSTAS (IN_OBRAS_ID'#13#10 +
    '                      ,SM_INSTALADORES_ID'#13#10 +
    '                      ,VA_CONTATO'#13#10 +
    '                      ,BO_PROPOSTAPADRAO'#13#10 +
    '                      ,FL_DESCONTOPERC'#13#10 +
    '                      ,FL_DESCONTOVAL'#13#10 +
    '                      ,TI_MOEDA'#13#10 +
    '                      ,TI_VALIDADE'#13#10 +
    '                      ,VA_COTACOES)'#13#10 +
    'VALUES (@OBRA%u,%u,%s,%s,%s,%s,%u,%u,%s);'#13#10 +
    'DO @PROPOSTA%u := LAST_INSERT_ID();'#13#10 +
    '%s';

    SQL_PROPOSTA_PADRAO = 'CALL PRC_SET_DEFAULT_PROPOSAL(@PROPOSTA%u);'#13#10;

//BDO3 (V1)
//    SQL_INSERIR_PROPOSTA =
//    'INSERT INTO PROPOSTAS (IN_OBRAS_ID'#13#10 +
//    '                      ,SM_INSTALADORES_ID'#13#10 +
//    '                      ,VA_CONTATO'#13#10 +
//    '                      ,BO_PROPOSTAPADRAO'#13#10 +
//    '                      ,FL_DESCONTOPERC'#13#10 +
//    '                      ,FL_DESCONTOVAL'#13#10 +
//    '                      ,TI_MOEDA'#13#10 +
//    '                      ,TI_VALIDADE'#13#10 +
//    '                      ,VA_COTACOES)'#13#10 +
//    'VALUES (@OBRA%u,%u,%s,%s,%s,%s,%u,%u,%s);'#13#10 +
//    'DO @PROPOSTA%u := LAST_INSERT_ID();'#13#10;

    SQL_INSERIR_ITEM =
    'INSERT INTO ITENS (IN_PROPOSTAS_ID'#13#10 +
    '                  ,TI_FAMILIAS_ID'#13#10 +
    '                  ,VA_DESCRICAO'#13#10 +
    '                  ,FL_CAPACIDADE'#13#10 +
    '                  ,TI_UNIDADES_ID'#13#10 +
    '                  ,SM_QUANTIDADE'#13#10 +
    '                  ,EN_VOLTAGEM'#13#10 +
    '                  ,FL_DESCONTOPERC'#13#10 +
    '                  ,TI_ORDEM)'#13#10 +
    'VALUES (@PROPOSTA%u,%u,%s,%.4f,%u,%u,%s,%.4f,%u);'#13#10 +
    'DO @ITEM%u := LAST_INSERT_ID();'#13#10;

    SQL_INSERIR_EQUIPAMENTOSDOSITENS =
    'INSERT INTO EQUIPAMENTOSDOSITENS (IN_ITENS_ID'#13#10 +
    '                                 ,IN_EQUIPAMENTOS_ID'#13#10 +
    '                                 ,FL_LUCROBRUTO'#13#10 +
    '                                 ,FL_VALORUNITARIO'#13#10 +
    '                                 ,TI_MOEDA)'#13#10 +
    'VALUES (@ITEM%u,%u,%.4f,%.4f,%u);'#13#10 +
    'DO @EQUIPAMENTODOITEM%u := LAST_INSERT_ID();'#13#10;

var
	i: Byte;
	Obra: TObra;
    Proposta, Item, Equipamento, JustificativaDaObra: Word;
    ObrasImportadas, ObrasNaoImportadas, ObrasIgnoradas: Byte;
    ScriptDeInsercao: String;
begin
	if MyModule.ListViewImportar.Items.Count = 0 then
    begin
    	MessageBox(MyModule.Handle,'A lista de importação está vazia. Por favor clique o botão "Validar Arquivos de Obra" para adicionar algumas obras à lista','Não é possível importar',MB_ICONERROR);
        Exit;
    end;

	for i := 0 to Pred(MyModule.ListViewImportar.Items.Count) do
    	if MyModule.ListViewImportar.Items[i].Checked then
        	Break;

	if i <> MyModule.ListViewImportar.Items.Count then
    begin
        ObrasImportadas := 0;
        ObrasIgnoradas := 0;
        ObrasNaoImportadas := 0;

        Obra := TObra.Create(Self);
        try
            MyModule.ProgressBarImportacao.Min := 0;
            MyModule.ProgressBarImportacao.Max := MyModule.ListViewImportar.Items.Count;
            MyModule.LabelStatus.Caption := 'Importando obras... 0%';
            MyModule.ProgressBarImportacao.Position := 0;

            for i := 0 to Pred(MyModule.ListViewImportar.Items.Count) do
            begin
	            if MyModule.ListViewImportar.Items[i].Checked and (MyModule.ListViewImportar.Items[i].ImageIndex = 1) then
    	        begin
	                ScriptDeInsercao := '';
                    try
                        Obra.LoadFromBinaryFile(ItemInformation[i].FileName);
		                { Criando o Script de inserção da obra completa... }
                        { 1. Dados da obra }
                        ScriptDeInsercao := MySQLFormat(SQL_INSERIR_OBRA
                                                       ,[Obra.VA_NOMEDAOBRA
                                                        ,Obra.TI_REGIOES_ID
                                                        ,HexStr(Obra.VA_NOMEDAOBRA)
                                                        ,HexStr(Obra.VA_CIDADE)
                                                        ,HexStr(Obra.CH_ESTADO)
                                                        ,Obra.TI_SITUACOES_ID
                                                        ,HexStr(Obra.VA_PRAZODEENTREGA)
                                                        ,Obra.YR_ANOPROVAVELDEENTREGA
                                                        ,Obra.TI_MESPROVAVELDEENTREGA
                                                        ,HexStr(Obra.TX_CONDICAODEPAGAMENTO)
                                                        ,Obra.FL_ICMS
                                                        ,HexStr(Obra.EN_FRETE)
                                                        ,HexStr(Obra.TX_CONDICOESGERAIS)
                                                        ,HexStr(Obra.TX_OBSERVACOES)
                                                        ,IfThen(Obra.SM_USUARIOJUSTIFICADOR_ID = 0,'NULL',IntToStr(Obra.SM_USUARIOJUSTIFICADOR_ID))
                                                        ,HexStr(Obra.VA_CONSTRUTORA)
                                                        ,Obra.TI_TIPOS_ID
                                                        ,Obra.SM_PROJETISTAS_ID
                                                        ,IfThen(Obra.DA_DATADEEXPIRACAO > 0,FormatDateTime('yyyymmdd',Obra.DA_DATADEEXPIRACAO),'NULL')
                                                        ,Obra.IN_OBRAS_ID]);

                        { 1.1 Dados das justificativas }
                        if Obra.JustificativasDasObras.Count > 0 then
                            for JustificativaDaObra := 0 to Pred(Obra.JustificativasDasObras.Count) do
                            begin
                                ScriptDeInsercao := ScriptDeInsercao + MySQLFormat(SQL_INSERIR_JUSTIFICATIVASDASOBRAS,[Obra.JustificativasDasObras[JustificativaDaObra].IN_OBRAS_ID
                                                                                                                      ,Obra.JustificativasDasObras[JustificativaDaObra].TI_JUSTIFICATIVAS_ID
                                                                                                                      ,Obra.JustificativasDasObras[JustificativaDaObra].MI_JUSTIFICATIVASDASOBRAS_ID]);
                            end;


                        { 2. Dados de cada uma das propostas da obra }
                        if Obra.Propostas.Count > 0 then
                            for Proposta := 0 to Pred(Obra.Propostas.Count) do
                            begin
                                ScriptDeInsercao := ScriptDeInsercao + MySQLFormat(SQL_INSERIR_PROPOSTA,[Obra.Propostas[Proposta].IN_OBRAS_ID
                                                                                                        ,Obra.Propostas[Proposta].SM_INSTALADORES_ID
                                                                                                        ,HexStr(Obra.Propostas[Proposta].VA_CONTATO)
                                                                                                        ,UpperCase(BoolToStr(Obra.Propostas[Proposta].BO_PROPOSTAPADRAO,True))
                                                                                                        ,IfThen(Obra.Propostas[Proposta].FL_DESCONTOPERC <> 0,MySQLFormat('%.4f',[Obra.Propostas[Proposta].FL_DESCONTOPERC]),'NULL')
                                                                                                        ,IfThen(Obra.Propostas[Proposta].FL_DESCONTOVAL <> 0,MySQLFormat('%.4f',[Obra.Propostas[Proposta].FL_DESCONTOVAL]),'NULL')
                                                                                                        ,Obra.Propostas[Proposta].TI_MOEDA
                                                                                                        ,Obra.Propostas[Proposta].TI_VALIDADE
                                                                                                        ,HexStr(Obra.Propostas[Proposta].VA_COTACOES)
                                                                                                        ,Obra.Propostas[Proposta].IN_PROPOSTAS_ID
                                                                                                        ,IfThen(Obra.Propostas[Proposta].BO_PROPOSTAPADRAO
                                                                                                               ,MySQLFormat(SQL_PROPOSTA_PADRAO,[Obra.Propostas[Proposta].IN_PROPOSTAS_ID])
                                                                                                               ,'')
                                                                                                        ]); //Aqui colocamos a proposta como padrão, caso ela seja, padrão realmente

                                { 3. Dados de cada uma dos itens da proposta }
                                if Obra.Propostas[Proposta].Itens.Count > 0 then
                                    for Item := 0 to Pred(Obra.Propostas[Proposta].Itens.Count) do
                                    begin
                                        ScriptDeInsercao := ScriptDeInsercao + MySQLFormat(SQL_INSERIR_ITEM,[Obra.Propostas[Proposta].Itens[Item].IN_PROPOSTAS_ID
                                                                                                            ,Obra.Propostas[Proposta].Itens[Item].TI_FAMILIAS_ID
                                                                                                            ,HexStr(Obra.Propostas[Proposta].Itens[Item].VA_DESCRICAO)
                                                                                                            ,Obra.Propostas[Proposta].Itens[Item].FL_CAPACIDADE
                                                                                                            ,Obra.Propostas[Proposta].Itens[Item].TI_UNIDADES_ID
                                                                                                            ,Obra.Propostas[Proposta].Itens[Item].SM_QUANTIDADE
                                                                                                            ,HexStr(Obra.Propostas[Proposta].Itens[Item].EN_VOLTAGEM)
                                                                                                            ,Obra.Propostas[Proposta].Itens[Item].FL_DESCONTOPERC
                                                                                                            ,Obra.Propostas[Proposta].Itens[Item].TI_ORDEM
                                                                                                            ,Obra.Propostas[Proposta].Itens[Item].IN_ITENS_ID]);

                                        { 4. Dados de cada um dos equipamentos do item }
                                        if Obra.Propostas[Proposta].Itens[Item].Equipamentos.Count > 0 then
                                            for Equipamento := 0 to Pred(Obra.Propostas[Proposta].Itens[Item].Equipamentos.Count) do
                                            begin
                                                ScriptDeInsercao := ScriptDeInsercao + MySQLFormat(SQL_INSERIR_EQUIPAMENTOSDOSITENS,[Obra.Propostas[Proposta].Itens[Item].Equipamentos[Equipamento].IN_ITENS_ID
                                                                                                                                    ,Obra.Propostas[Proposta].Itens[Item].Equipamentos[Equipamento].IN_EQUIPAMENTOS_ID
                                                                                                                                    ,Obra.Propostas[Proposta].Itens[Item].Equipamentos[Equipamento].FL_LUCROBRUTO
                                                                                                                                    ,Obra.Propostas[Proposta].Itens[Item].Equipamentos[Equipamento].FL_VALORUNITARIO
                                                                                                                                    ,Obra.Propostas[Proposta].Itens[Item].Equipamentos[Equipamento].TI_MOEDA
                                                                                                                                    ,Obra.Propostas[Proposta].Itens[Item].Equipamentos[Equipamento].IN_EQUIPAMENTOSDOSITENS_ID]);
                                            end;
                                    end;
                            end;

                        if aOutputSQL then
                        	SaveTextFile(ScriptDeInsercao,ChangeFileExt(ItemInformation[i].FileName,'.sql'));

                        { Se houver alguma transação aberta, este comportamento
                        é errado, logo os dados provavelmente estão errados.
                        Devemos, portanto, executar um rollback antes de iniciar
                        a nova transação, já que ao iniciar uma nova, transações
                        antigas são confirmadas... }
                        RollbackWork(DataModuleMain.ZConnections.ByName['ZConnection_BDO'].Connection);
                        StartTransaction(DataModuleMain.ZConnections.ByName['ZConnection_BDO'].Connection);
                        MySQLExecuteSQLScript(DataModuleMain.ZConnections.ByName['ZConnection_BDO'].Connection
                                             ,''
                                             ,ScriptDeInsercao);
                        { Se chegar neste ponto é porque tudo ocorreu bem. Confirma tudo! }
                        CommitWork(DataModuleMain.ZConnections.ByName['ZConnection_BDO'].Connection);

                        MyModule.ListViewImportar.Items[i].ImageIndex := 3;
                        ItemInformation[i].Observation := 'Obra importada com sucesso';
	        	        Inc(ObrasImportadas);
                    except
                    	on E: Exception do
                        begin
                        	RollbackWork(DataModuleMain.ZConnections.ByName['ZConnection_BDO'].Connection);
                            MyModule.ListViewImportar.Items[i].ImageIndex := 2;
		                    ItemInformation[i].Observation := 'Erro ao importar a obra contida no arquivo "' + ExtractFileName(ItemInformation[i].FileName) + '".'#13#10'A mensagem de erro detalhada encontra-se abaixo:'#13#10#13#10 + E.Message + #13#10#13#10'Por favor copie esta mensagem de erro, juntamente com o arquivo de obra, e envie-os ao desenvolvedor para análise';
	                        Inc(ObrasNaoImportadas);
                        end;
                    end;
    			end
    	        else
        	        Inc(ObrasIgnoradas);

                MyModule.ProgressBarImportacao.StepIt;
                MyModule.LabelStatus.Caption := Format('Importando obras... %d%%',[Round(MyModule.ProgressBarImportacao.Position / MyModule.ProgressBarImportacao.Max * 100)]);
                Application.ProcessMessages;
            end;
        finally
        	if Assigned(Obra) then
	        	Obra.Free;
        end;
    	MessageBox(MyModule.Handle,PChar('Obras importadas com sucesso: ' + IntToStr(ObrasImportadas) + #13#10'Obras não importadas: ' + IntToStr(ObrasNaoImportadas) + #13#10'Obras ignoradas: ' + IntToStr(ObrasIgnoradas) + #13#10#13#10'Obs. 1: Obras ignoradas compreendem obras não selecionadas e obras inválidas para importação.'#13#10'Obs. 2: Obras não importadas são'+' aquelas que não puderam ser importadas devido a algum erro de banco de dados. Tais obras encontram-se destacadas na listagem anterior e mais detalhes podem ser encontrados clicando-se nela.'),'Sumário de importação',MB_ICONINFORMATION);

        if aOutputSQL then
	        MessageBox(MyModule.Handle,'Os SQLs referentes às inserções das obras foram salvos no mesmo diretório dos arquivos .oex com nomes iguais a estes, mas com a extensão trocada por .sql','Informação de Debug',MB_ICONINFORMATION);
    end
    else
        MessageBox(MyModule.Handle,'Não é possível importar, pois nenhuma obra foi selecionada, o porque a lista não possui nenhuma obra válida para importação','Nenhuma obra selecionada pra importação',MB_ICONWARNING);
end;

function TBDODataModule_ImportarExportarObras.ValidarNomeDeArquivoDaObra(aCaminho: TFileName; aNomeDeArquivo: ShortString): TFileName;
begin
	{ Passo 1: Validando o  nome  de arquivo  quando a existência  de caracteres
    inválidos não permitidos em nomes-de-arquivo }
    Result := ValidateStringForFileName(aNomeDeArquivo,'_',25);

    { Passo 2: Validando quanto à duplicidade no diretório especificado }
    Result := GetUniqueFileName(aCaminho + '\' + Result + EXPORTEDFILE_EXTENSION);
end;

function TBDODataModule_ImportarExportarObras.MyModule: TBDOForm_ImportarExportarObras;
begin
    Result := TBDOForm_ImportarExportarObras(Owner);
end;

procedure TBDODataModule_ImportarExportarObras.OBR_FILTRO_Filtrar;
begin
    with OBRAS_SEARCH do
    begin
    	Close;

//        if (MyModule.Edit_OBR_FILTRO_VA_NOMEDAOBRA.Text <> '') then
//        	FNomeDaObra := MyModule.Edit_OBR_FILTRO_VA_NOMEDAOBRA.Text
//        else
//        	FNomeDaObra := '%';
//
//        FNomeDaObra := StringReplace(FNomeDaObra,'*','%',[rfReplaceAll]);
//        FNomeDaObra := StringReplace(FNomeDaObra,'?','_',[rfReplaceAll]);
//        FNomeDaObra := QuotedStr(UpperCase(FNomeDaObra));

//        case MyModule.RadioGroupFiltragem.ItemIndex of
//        	0: OBRAS_SEARCH.SQL.Text := SQL_FULL_NORMAL + SQL_FULL + ' WHERE TI_REGIOES_ID IN (' + RegioesDeAtuacao + ') AND UPPER(VA_NOMEDAOBRA) LIKE ' + NomeDaObra;
//            1: OBRAS_SEARCH.SQL.Text := SQL_FULL_DISTINCT + SQL_FULL + SQL_NOTSYNC_COMPLEMENT + ' AND TI_REGIOES_ID IN (' + RegioesDeAtuacao + ') AND UPPER(VA_NOMEDAOBRA) LIKE ' + NomeDaObra;
//        end;
        Open;
    end;
    MyModule.Label_OBR_FILTRO_RegistrosValor.Caption := '0 / ' + IntToStr(OBRAS_SEARCH.RecordCount);
end;

procedure TBDODataModule_ImportarExportarObras.ValidarObra(FileName: String);
var
	Obra: TObra;
    ObraValida: Boolean;
    ErrosEncontrados: String;
    Proposta, Item, Equipamento, JustificativaDaObra: Cardinal;

    function ThisKeyExists(TableName, KeyName: ShortString; KeyValue: Cardinal): Boolean;
    var
    	RODataSet: TZReadOnlyQuery;
    begin
        RODataSet := nil;
    	try
        	ConfigureDataSet(DataModuleMain.ZConnections.ByName['ZConnection_BDO'].Connection
                            ,RODataSet,'SELECT COUNT(*) FROM ' + TableName + ' WHERE ' + KeyName + ' = ' + IntToStr(KeyValue));
            Result := RODataSet.Fields[0].AsInteger = 1;
        finally
            if Assigned(RODataSet) then
                RODataSet.Free;
        end;
    end;
begin
	{ TODO : Não está verificando se pode ou não pode inserir nas tabelas
    envolvidas. Adicione isso! A verificação de permissão de inserção pode ser
    feita toda aqui no inicio }
    ObraValida := True;
    ErrosEncontrados := 'Obra inválida para importação. Os problemas encontrados foram'#13#10#13#10;

	Obra := TObra.Create(nil);
	try
    	Obra.LoadFromBinaryFile(FileName);

        { 1. Validando dados da tabela OBRAS }
        if not ThisKeyExists('REGIOES','TI_REGIOES_ID',Obra.TI_REGIOES_ID) then
        begin
        	ObraValida := False;
        	ErrosEncontrados := ErrosEncontrados + '- A região (' + IntToStr(Obra.TI_REGIOES_ID) + ') da obra não existe localmente'#13#10;
        end;

        if not (Obra.TI_REGIOES_ID in ArrayOfByteToSet(RegioesDoUsuario(Configurations.AuthenticatedUser.Id))) then
        begin
        	ObraValida := False;
        	ErrosEncontrados := ErrosEncontrados + '- A região da obra não pertence às suas regiões de atuação. Esta obra não poderá ser importada por você'#13#10;
        end;

        if not ThisKeyExists('SITUACOES','TI_SITUACOES_ID',Obra.TI_SITUACOES_ID) then
        begin
        	ObraValida := False;
        	ErrosEncontrados := ErrosEncontrados + '- A situação (' + IntToStr(Obra.TI_SITUACOES_ID) + ') da obra não existe localmente'#13#10;
        end;

        if not ThisKeyExists('TIPOS','TI_TIPOS_ID',Obra.TI_TIPOS_ID) then
        begin
        	ObraValida := False;
        	ErrosEncontrados := ErrosEncontrados + '- O tipo (' + IntToStr(Obra.TI_TIPOS_ID) + ') da obra não existe localmente'#13#10;
        end;

        if not ThisKeyExists('PROJETISTAS','SM_PROJETISTAS_ID',Obra.SM_PROJETISTAS_ID) then
        begin
        	ObraValida := False;
        	ErrosEncontrados := ErrosEncontrados + '- O projetista (' + IntToStr(Obra.SM_PROJETISTAS_ID) + ') da obra não existe localmente'#13#10;
        end;

        { 1.1 Validando dados das justificativas }
        if Obra.JustificativasDasObras.Count > 0 then
        begin
            for JustificativaDaObra := 0 to Pred(Obra.JustificativasDasObras.Count) do
                if not ThisKeyExists('JUSTIFICATIVAS','TI_JUSTIFICATIVAS_ID',Obra.JustificativasDasObras[JustificativaDaObra].TI_JUSTIFICATIVAS_ID) then
                begin
                	ObraValida := False;
                    ErrosEncontrados := ErrosEncontrados + '-- A justificativa (' + IntToStr(Obra.JustificativasDasObras[JustificativaDaObra].TI_JUSTIFICATIVAS_ID) + ') da obra não existe localmente'#13#10;
                    Break;
                end;
        end;

        { 2. Validando dados de cada uma das PROPOSTAS da obra }
        if ObraValida and (Obra.Propostas.Count > 0) then
            for Proposta := 0 to Pred(Obra.Propostas.Count) do
            begin
                if not ThisKeyExists('INSTALADORES','SM_INSTALADORES_ID',Obra.Propostas[Proposta].SM_INSTALADORES_ID) then
                begin
                	ObraValida := False;
                    ErrosEncontrados := ErrosEncontrados + '-- O instalador (' + IntToStr(Obra.Propostas[Proposta].SM_INSTALADORES_ID) + ') da proposta não existe localmente'#13#10;
                    Break;
                end;

                { 3. Validando dados de cada um dos ITENS da proposta }
                if Obra.Propostas[Proposta].Itens.Count > 0 then
                    for Item := 0 to Pred(Obra.Propostas[Proposta].Itens.Count) do
                    begin
                        if not ThisKeyExists('FAMILIAS','TI_FAMILIAS_ID',Obra.Propostas[Proposta].Itens[Item].TI_FAMILIAS_ID) then
                        begin
                        	ObraValida := False;
                            ErrosEncontrados := ErrosEncontrados + '--- A família (' + IntToStr(Obra.Propostas[Proposta].Itens[Item].TI_FAMILIAS_ID) + ') do item não existe localmente'#13#10;
                            Break;
                        end;

                        if not ThisKeyExists('UNIDADES','TI_UNIDADES_ID',Obra.Propostas[Proposta].Itens[Item].TI_UNIDADES_ID) then
                        begin
                        	ObraValida := False;
                            ErrosEncontrados := ErrosEncontrados + '--- A unidade (' + IntToStr(Obra.Propostas[Proposta].Itens[Item].TI_UNIDADES_ID) + ') do item não existe localmente'#13#10;
                            Break;
                        end;

                        { 4. Validando dados de cada um dos EQUIPAMENTOS do item }
                        if Obra.Propostas[Proposta].Itens[Item].Equipamentos.Count > 0 then
                            for Equipamento := 0 to Pred(Obra.Propostas[Proposta].Itens[Item].Equipamentos.Count) do
                            begin
                                if not ThisKeyExists('EQUIPAMENTOS','IN_EQUIPAMENTOS_ID',Obra.Propostas[Proposta].Itens[Item].Equipamentos[Equipamento].IN_EQUIPAMENTOS_ID) then
                                begin
                                	ObraValida := False;
                                    ErrosEncontrados := ErrosEncontrados + '---- O equipamento (' + IntToStr(Obra.Propostas[Proposta].Itens[Item].Equipamentos[Equipamento].IN_EQUIPAMENTOS_ID) + ') não existe localmente'#13#10;
                                    Break;
                                end;
                            end;

	                    if not ObraValida then
    		            	Break;
                    end;

                if not ObraValida then
                	Break;
            end;

        if ObraValida then
        	ErrosEncontrados := 'Obra validada com sucesso!'
        else
        	ErrosEncontrados := ErrosEncontrados + #13#10 + 'Os erros de validação podem ser corrigidos realizando-se uma sincronização por diferenças antes da importação de obras. Se você ainda não fez uma sincronização hoje, é recomendável que a faça se quiser tentar carregar esta obra.';

	    SetLength(FItemInformation,Succ(Length(FItemInformation)));
    	FItemInformation[High(FItemInformation)].FileName := FileName;
	    FItemInformation[High(FItemInformation)].Observation := ErrosEncontrados;

        with MyModule.ListViewImportar.Items.Add do
        begin
            Caption := Obra.VA_NOMEDAOBRA;
            SubItems.Add(Obra.VA_CIDADE + ' / ' + Obra.CH_ESTADO);
            if ErrosEncontrados = 'Obra validada com sucesso!' then
            begin
            	ImageIndex := 1;
                Checked := True;
            end;
        end;

    finally
    	if Assigned(Obra) then
	    	Obra.Free;
    end;
end;


{ TObra }

procedure TObra.Clear;
begin
    inherited;
    IN_OBRAS_ID := 0;
    TI_REGIOES_ID := 0;
    VA_NOMEDAOBRA := '';
    VA_CIDADE := '';
    CH_ESTADO := '';
    TI_SITUACOES_ID := 0;
    VA_PRAZODEENTREGA := '';
    TX_CONDICAODEPAGAMENTO := '';
    FL_ICMS := 0;
    EN_FRETE := '';
    TX_CONDICOESGERAIS := '';
    TX_OBSERVACOES := '';
    SM_USUARIOJUSTIFICADOR_ID := 0;
    VA_CONSTRUTORA := '';
    TI_TIPOS_ID := 0;
    SM_PROJETISTAS_ID := 0;
    DA_DATADEEXPIRACAO := 0;
end;

constructor TObra.Create(AOwner: TComponent);
begin
    inherited;
    FPropostas := TPropostas.Create(TProposta);
    FJustificativasDasObras := TJustificativasDasObras.Create(TJustificativaDaObra); 
end;

destructor TObra.Destroy;
begin
    FJustificativasDasObras.Free; 
    FPropostas.Free;
    inherited;
end;

{ TPropostas }

function TPropostas.Add: TProposta;
begin
	Result := TProposta(inherited Add);
end;

function TPropostas.GetProposta(i: Word): TProposta;
begin
	Result := TProposta(inherited Items[i]);
end;

{ TProposta }

constructor TProposta.Create(Collection: TCollection);
begin
    inherited;
    FItens := TItens.Create(TItem);
end;

destructor TProposta.Destroy;
begin
    FItens.Free;
    inherited;
end;

{ TItem }

constructor TItem.Create(Collection: TCollection);
begin
    inherited;
    FEquipamentos := TEquipamentosDosItens.Create(TEquipamentoDoItem);
end;

destructor TItem.Destroy;
begin
    FEquipamentos.Free;
    inherited;
end;

{ TItens }

function TItens.Add: TItem;
begin
    Result := TItem(inherited Add);
end;

function TItens.GetItem(i: Word): TItem;
begin
    Result := TItem(inherited Items[i]);
end;

{ TEquipamentosDosItens }

function TEquipamentosDosItens.Add: TEquipamentoDoItem;
begin
	Result := TEquipamentoDoItem(inherited Add);
end;

function TEquipamentosDosItens.GetEquipamento(i: Word): TEquipamentoDoItem;
begin
    Result := TEquipamentoDoItem(inherited Items[i]);
end;

{ TJustificativasDasObras }

function TJustificativasDasObras.Add: TJustificativaDaObra;
begin
	Result := TJustificativaDaObra(inherited Add);
end;

function TJustificativasDasObras.GetJustificativaDaObra(i: Word): TJustificativaDaObra;
begin
    Result := TJustificativaDaObra(inherited Items[i]);
end;

end.
