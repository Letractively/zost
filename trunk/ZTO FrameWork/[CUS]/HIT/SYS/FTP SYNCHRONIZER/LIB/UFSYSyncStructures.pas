unit UFSYSyncStructures;

{ TODO -oCARLOS FEITOZA -cDICAS : PARA INCLUIR TABELAS E REGISTROS MUDE AQUI.
NÃO ESQUEÇA DE ATUALIZAR OS GERADORES DE INSERT E UPDATE E, NO CASO DE CAMPOS
QUE SÃO TID, NÃO ESQUEÇA DE CRIA-LOS E DESTRUÍ-LOS. O CONSTRUTOR DE
TSynchronizationFile TEM DE SER ALTERADO CASO UM CAMPO CHAVE TENHA SIDO INCLUÍDO
OU CASO UMA NOVA TABELA TENHA SIDO INCLUÍDA }

{ TODO : implemtner os destrutores }

//o sql abaixo retorna informações sobre chaves estrangeiras unicas e primarias
//pode ser usado para detectar as chaves de uma tabela sem ser necessário usar o comando Show Create Table
//
//  SELECT TC.TABLE_SCHEMA
//       , TC.TABLE_NAME
//       , TC.CONSTRAINT_TYPE
//       , TC.CONSTRAINT_NAME
//       , GROUP_CONCAT(KCU.COLUMN_NAME ORDER BY KCU.ORDINAL_POSITION SEPARATOR ',') AS COLUMN_NAMES
//       , IF(UPPER(TC.CONSTRAINT_TYPE) = 'FOREIGN KEY',KCU.REFERENCED_TABLE_SCHEMA,'N/A')
//       , IF(UPPER(TC.CONSTRAINT_TYPE) = 'FOREIGN KEY',KCU.REFERENCED_TABLE_NAME,'N/A')
//       , IF(UPPER(TC.CONSTRAINT_TYPE) = 'FOREIGN KEY',KCU.REFERENCED_COLUMN_NAME,'N/A')
//    FROM INFORMATION_SCHEMA.TABLE_CONSTRAINTS TC
//    JOIN INFORMATION_SCHEMA.KEY_COLUMN_USAGE KCU USING(TABLE_SCHEMA,TABLE_NAME,CONSTRAINT_NAME)
//
//   WHERE UPPER(TC.TABLE_SCHEMA) = 'TEST'
//--     AND UPPER(TC.TABLE_NAME) = 'OBRAS'
//--     AND UPPER(TC.CONSTRAINT_TYPE) = 'UNIQUE'
//GROUP BY CONSTRAINT_NAME, TABLE_NAME
//ORDER BY TC.TABLE_SCHEMA
//       , TC.TABLE_NAME;
interface

uses
	Classes, Contnrs, USyncStructures;

type
	TString150 = {$IFDEF UNICODE}AnsiString{$ELSE}String[150]{$ENDIF};
  TString128 = {$IFDEF UNICODE}AnsiString{$ELSE}String[128]{$ENDIF};
  TString64 = {$IFDEF UNICODE}AnsiString{$ELSE}String[64]{$ENDIF};
  TString40 = {$IFDEF UNICODE}AnsiString{$ELSE}String[40]{$ENDIF};
  TString32 = {$IFDEF UNICODE}AnsiString{$ELSE}String[32]{$ENDIF};
  TString16 = {$IFDEF UNICODE}AnsiString{$ELSE}String[16]{$ENDIF};
  TString8 = {$IFDEF UNICODE}AnsiString{$ELSE}String[8]{$ENDIF};
  TString6 = {$IFDEF UNICODE}AnsiString{$ELSE}String[6]{$ENDIF};
  TString4 = {$IFDEF UNICODE}AnsiString{$ELSE}String[4]{$ENDIF};
  TString3 = {$IFDEF UNICODE}AnsiString{$ELSE}String[3]{$ENDIF};
  TString2 = {$IFDEF UNICODE}AnsiString{$ELSE}String[2]{$ENDIF};

    TID = class(TSyncKey)
    public
    	function ReferencedValue(aTableName: AnsiString): AnsiString; override;
    end;

    TEntidadeDoSistema = class(TSyncRecord)
  	private
    	FIN_ENTIDADESDOSISTEMA_ID: Cardinal;
      FVA_NOME: TString128;
      FTI_TIPO: Byte;
    public
      function PrimaryKeyValue: Int64; override;
      function InsertClause(const aValues, aUsePrimaryKeyValue: Boolean): AnsiString; override;
      function UpdateClause: AnsiString; override;
    published
    	property IN_ENTIDADESDOSISTEMA_ID: Cardinal read FIN_ENTIDADESDOSISTEMA_ID write FIN_ENTIDADESDOSISTEMA_ID;
      property VA_NOME: TString128 read FVA_NOME write FVA_NOME;
      property TI_TIPO: Byte read FTI_TIPO write FTI_TIPO;
    end;

    TEntidadesDoSistema = class(TSyncTable)
  	private
    	function GetEntidadeDoSistema(i: Cardinal): TEntidadeDoSistema;
    public
        function Add: TEntidadeDoSistema;
		property EntidadeDoSistema[i: Cardinal]: TEntidadeDoSistema read GetEntidadeDoSistema; default;
    end;

    TEquipamento = class(TSyncRecord)
  	private
    	FIN_EQUIPAMENTOS_ID: Cardinal;
        FVA_MODELO: TString64;
        FFL_LUCROBRUTO: Double;
        FFL_IPI: Double;
        FFL_VALORUNITARIO: Currency;
        FTI_MOEDA: Byte;
        FBO_DISPONIVEL: Boolean;
    public
        function PrimaryKeyValue: Int64; override;
        function InsertClause(const aValues, aUsePrimaryKeyValue: Boolean): AnsiString; override;
        function UpdateClause: AnsiString; override;
    published
    	property IN_EQUIPAMENTOS_ID: Cardinal read FIN_EQUIPAMENTOS_ID write FIN_EQUIPAMENTOS_ID;
        property VA_MODELO: TString64 read FVA_MODELO write FVA_MODELO;
        property FL_LUCROBRUTO: Double read FFL_LUCROBRUTO write FFL_LUCROBRUTO;
        property FL_IPI: Double read FFL_IPI write FFL_IPI;
        property FL_VALORUNITARIO: Currency read FFL_VALORUNITARIO write FFL_VALORUNITARIO;
        property TI_MOEDA: Byte read FTI_MOEDA write FTI_MOEDA;
        property BO_DISPONIVEL: Boolean read FBO_DISPONIVEL write FBO_DISPONIVEL;
    end;

    TEquipamentos = class(TSyncTable)
  	private
    	function GetEquipamento(i: Cardinal): TEquipamento;
    public
        function Add: TEquipamento;
		property Equipamento[i: Cardinal]: TEquipamento read GetEquipamento; default;
    end;

    TFamilia = class(TSyncRecord)
  	private
    	FTI_FAMILIAS_ID: Byte;
        FVA_DESCRICAO: TString64;
    public
        function PrimaryKeyValue: Int64; override;
        function InsertClause(const aValues, aUsePrimaryKeyValue: Boolean): AnsiString; override;
        function UpdateClause: AnsiString; override;
    published
    	property TI_FAMILIAS_ID: Byte read FTI_FAMILIAS_ID write FTI_FAMILIAS_ID;
        property VA_DESCRICAO: TString64 read FVA_DESCRICAO write FVA_DESCRICAO;
    end;

    TFamilias = class(TSyncTable)
  	private
    	function GetFamilia(i: Cardinal): TFamilia;
    public
        function Add: TFamilia;
		property Familia[i: Cardinal]: TFamilia read GetFamilia; default;
    end;

    TGrupo = class(TSyncRecord)
  	private
    	FTI_GRUPOS_ID: Byte;
        FVA_NOME: TString64;
        FVA_DESCRICAO: TString128;
    public
        function PrimaryKeyValue: Int64; override;
        function InsertClause(const aValues, aUsePrimaryKeyValue: Boolean): AnsiString; override;
        function UpdateClause: AnsiString; override;
    published
    	property TI_GRUPOS_ID: Byte read FTI_GRUPOS_ID write FTI_GRUPOS_ID;
        property VA_NOME: TString64 read FVA_NOME write FVA_NOME;
        property VA_DESCRICAO: TString128 read FVA_DESCRICAO write FVA_DESCRICAO;
    end;

    TGrupos = class(TSyncTable)
  	private
    	function GetGrupo(i: Cardinal): TGrupo;
    public
        function Add: TGrupo;
		property Grupo[i: Cardinal]: TGrupo read GetGrupo; default;
    end;

    TRegiao = class(TSyncRecord)
  	private
  		FTI_REGIOES_ID: Byte;
  		FVA_REGIAO: TString8;
  		FCH_PREFIXODAPROPOSTA: TString4;
  		FVA_PRIMEIRORODAPE: AnsiString;
  		FVA_SEGUNDORODAPE: AnsiString;
    public
        function PrimaryKeyValue: Int64; override;
        function InsertClause(const aValues, aUsePrimaryKeyValue: Boolean): AnsiString; override;
        function UpdateClause: AnsiString; override;
    published
  		property TI_REGIOES_ID: Byte read FTI_REGIOES_ID write FTI_REGIOES_ID;
  		property VA_REGIAO: TString8 read FVA_REGIAO write FVA_REGIAO;
  		property CH_PREFIXODAPROPOSTA: TString4 read FCH_PREFIXODAPROPOSTA write FCH_PREFIXODAPROPOSTA;
  		property VA_PRIMEIRORODAPE: AnsiString read FVA_PRIMEIRORODAPE write FVA_PRIMEIRORODAPE;
  		property VA_SEGUNDORODAPE: AnsiString read FVA_SEGUNDORODAPE write FVA_SEGUNDORODAPE;
    end;

    TRegioes = class(TSyncTable)
  	private
    	function GetRegiao(i: Cardinal): TRegiao;
    public
        function Add: TRegiao;
		property Regiao[i: Cardinal]: TRegiao read GetRegiao; default;
    end;

    TSituacao = class(TSyncRecord)
  	private
  		FTI_SITUACOES_ID: Byte;
        FVA_DESCRICAO: TString32;
        FBO_EXPIRAVEL: Boolean;
        FBO_JUSTIFICAVEL: Boolean;
        FTI_DIASPARAEXPIRACAO: Byte;
    public
        function PrimaryKeyValue: Int64; override;
        function InsertClause(const aValues, aUsePrimaryKeyValue: Boolean): AnsiString; override;
        function UpdateClause: AnsiString; override;
    published
  		property TI_SITUACOES_ID: Byte read FTI_SITUACOES_ID write FTI_SITUACOES_ID;
  		property VA_DESCRICAO: TString32 read FVA_DESCRICAO write FVA_DESCRICAO;
  		property BO_EXPIRAVEL: Boolean read FBO_EXPIRAVEL write FBO_EXPIRAVEL;
  		property BO_JUSTIFICAVEL: Boolean read FBO_JUSTIFICAVEL write FBO_JUSTIFICAVEL;
  		property TI_DIASPARAEXPIRACAO: Byte read FTI_DIASPARAEXPIRACAO write FTI_DIASPARAEXPIRACAO;
    end;

    TSituacoes = class(TSyncTable)
  	private
    	function GetSituacao(i: Cardinal): TSituacao;
    public
        function Add: TSituacao;
		property Situacao[i: Cardinal]: TSituacao read GetSituacao; default;
    end;

    TTipo = class(TSyncRecord)
  	private
        FTI_TIPOS_ID: Byte;
        FVA_DESCRICAO: TString64;
    public
        function PrimaryKeyValue: Int64; override;
        function InsertClause(const aValues, aUsePrimaryKeyValue: Boolean): AnsiString; override;
        function UpdateClause: AnsiString; override;
    published
  		property TI_TIPOS_ID: Byte read FTI_TIPOS_ID write FTI_TIPOS_ID;
  		property VA_DESCRICAO: TString64 read FVA_DESCRICAO write FVA_DESCRICAO;
    end;

    TTipos = class(TSyncTable)
  	private
    	function GetTipo(i: Cardinal): TTipo;
    public
        function Add: TTipo;
		property Tipo[i: Cardinal]: TTipo read GetTipo; default;
    end;

    TProjetista = class(TSyncRecord)
  	private
  		FSM_PROJETISTAS_ID: Word;
  		FVA_NOME: TString64;
    public
        function PrimaryKeyValue: Int64; override;
        function InsertClause(const aValues, aUsePrimaryKeyValue: Boolean): AnsiString; override;
        function UpdateClause: AnsiString; override;
    published
  		property SM_PROJETISTAS_ID: Word read FSM_PROJETISTAS_ID write FSM_PROJETISTAS_ID;
  		property VA_NOME: TString64 read FVA_NOME write FVA_NOME;
    end;

    TProjetistas = class(TSyncTable)
  	private
    	function GetProjetista(i: Cardinal): TProjetista;
    public
        function Add: TProjetista;
		property Projetista[i: Cardinal]: TProjetista read GetProjetista; default;
    end;

    TIcms = class(TSyncRecord)
  	private
  		FTI_ICMS_ID: Byte;
  		FFL_VALOR: Double;
    public
        function PrimaryKeyValue: Int64; override;
        function InsertClause(const aValues, aUsePrimaryKeyValue: Boolean): AnsiString; override;
        function UpdateClause: AnsiString; override;
    published
  		property TI_ICMS_ID: Byte read FTI_ICMS_ID write FTI_ICMS_ID;
  		property FL_VALOR: Double read FFL_VALOR write FFL_VALOR;
    end;

    TIcmss = class(TSyncTable)
  	private
    	function GetIcms(i: Cardinal): TIcms;
    public
        function Add: TIcms;
		property Icms[i: Cardinal]: TIcms read GetIcms; default;
    end;

    TInstalador = class(TSyncRecord)
  	private
  		FSM_INSTALADORES_ID: Word;
        FVA_NOME: TString64;
    public
        function PrimaryKeyValue: Int64; override;
        function InsertClause(const aValues, aUsePrimaryKeyValue: Boolean): AnsiString; override;
        function UpdateClause: AnsiString; override;
    published
  		property SM_INSTALADORES_ID: Word read FSM_INSTALADORES_ID write FSM_INSTALADORES_ID;
  		property VA_NOME: TString64 read FVA_NOME write FVA_NOME;
    end;

    TInstaladores = class(TSyncTable)
  	private
    	function GetInstalador(i: Cardinal): TInstalador;
    public
        function Add: TInstalador;
		property Instalador[i: Cardinal]: TInstalador read GetInstalador; default;
    end;

    TUnidade = class(TSyncRecord)
  	private
    	FTI_UNIDADES_ID: Byte;
  		FVA_ABREVIATURA: TString8;
  		FVA_DESCRICAO: TString64;
    public
		function PrimaryKeyValue: Int64; override;
        function InsertClause(const aValues, aUsePrimaryKeyValue: Boolean): AnsiString; override;
        function UpdateClause: AnsiString; override;
    published
  		property TI_UNIDADES_ID: Byte read FTI_UNIDADES_ID write FTI_UNIDADES_ID;
  		property VA_ABREVIATURA: TString8 read FVA_ABREVIATURA write FVA_ABREVIATURA;
        property VA_DESCRICAO: TString64 read FVA_DESCRICAO write FVA_DESCRICAO;
    end;

    TUnidades = class(TSyncTable)
  	private
    	function GetUnidade(i: Cardinal): TUnidade;
    public
        function Add: TUnidade;
		property Unidade[i: Cardinal]: TUnidade read GetUnidade; default;
    end;

    TUsuario = class(TSyncRecord)
  	private
  		FSM_USUARIOS_ID: Word;
  		FVA_NOME: TString64;
  		FVA_LOGIN: TString16;
  		FTB_SENHA: AnsiString;
        FVA_EMAIL: TString64;
    public
		function PrimaryKeyValue: Int64; override;
        function InsertClause(const aValues, aUsePrimaryKeyValue: Boolean): AnsiString; override;
        function UpdateClause: AnsiString; override;
    published
  		property SM_USUARIOS_ID: Word read FSM_USUARIOS_ID write FSM_USUARIOS_ID;
  		property VA_NOME: TString64 read FVA_NOME write FVA_NOME;
        property VA_LOGIN: TString16 read FVA_LOGIN write FVA_LOGIN;
        property TB_SENHA: AnsiString read FTB_SENHA write FTB_SENHA;
        property VA_EMAIL: TString64 read FVA_EMAIL write FVA_EMAIL;
    end;

    TUsuarios = class(TSyncTable)
  	private
    	function GetUsuario(i: Cardinal): TUsuario;
    public
        function Add: TUsuario;
		property Usuario[i: Cardinal]: TUsuario read GetUsuario; default;
    end;

    TJustificativa = class(TSyncRecord)
  	private
        FTI_JUSTIFICATIVAS_ID: Byte;
        FEN_CATEGORIA: AnsiChar;
        FVA_JUSTIFICATIVA: TString128;
    public
		function PrimaryKeyValue: Int64; override;
        function InsertClause(const aValues, aUsePrimaryKeyValue: Boolean): AnsiString; override;
        function UpdateClause: AnsiString; override;
    published
  		property TI_JUSTIFICATIVAS_ID: Byte read FTI_JUSTIFICATIVAS_ID write FTI_JUSTIFICATIVAS_ID;
  		property EN_CATEGORIA: AnsiChar read FEN_CATEGORIA write FEN_CATEGORIA;
        property VA_JUSTIFICATIVA: TString128 read FVA_JUSTIFICATIVA write FVA_JUSTIFICATIVA;
    end;

    TJustificativas = class(TSyncTable)
  	private
    	function GetJustificativa(i: Cardinal): TJustificativa;
    public
        function Add: TJustificativa;
		property Justificativa[i: Cardinal]: TJustificativa read GetJustificativa; default;
    end;

    TJustificativaDaObra = class(TSyncRecord)
  	private
        FMI_JUSTIFICATIVASDASOBRAS_ID: Cardinal;
        FIN_OBRAS_ID: TID;
        FTI_JUSTIFICATIVAS_ID: TID;
    public
        constructor Create(Collection: TCollection); override;
        destructor Destroy; override;

		function PrimaryKeyValue: Int64; override;
        function InsertClause(const aValues, aUsePrimaryKeyValue: Boolean): AnsiString; override;
        function UpdateClause: AnsiString; override;
    published
  		property MI_JUSTIFICATIVASDASOBRAS_ID: Cardinal read FMI_JUSTIFICATIVASDASOBRAS_ID write FMI_JUSTIFICATIVASDASOBRAS_ID;
  		property IN_OBRAS_ID: TID read FIN_OBRAS_ID write FIN_OBRAS_ID;
        property TI_JUSTIFICATIVAS_ID: TID read FTI_JUSTIFICATIVAS_ID write FTI_JUSTIFICATIVAS_ID;
    end;

    TJustificativasDasObras = class(TSyncTable)
  	private
    	function GetJustificativaDaObra(i: Cardinal): TJustificativaDaObra;
    public
        function Add: TJustificativaDaObra;
		property JustificativaDaObra[i: Cardinal]: TJustificativaDaObra read GetJustificativaDaObra; default;
    end;

    TPermissaoDoGrupo = class(TSyncRecord)
  	private
  		FIN_PERMISSOESDOSGRUPOS_ID: Cardinal;
  		FIN_ENTIDADESDOSISTEMA_ID: TID;
  		FTI_GRUPOS_ID: TID;
  		FTI_LER: Shortint;
  		FTI_INSERIR: ShortInt;
  		FTI_ALTERAR: ShortInt;
  		FTI_EXCLUIR: ShortInt;
    public
        constructor Create(Collection: TCollection); override;
        destructor Destroy; override;

		function PrimaryKeyValue: Int64; override;
        function InsertClause(const aValues, aUsePrimaryKeyValue: Boolean): AnsiString; override;
        function UpdateClause: AnsiString; override;
    published
  		property IN_PERMISSOESDOSGRUPOS_ID: Cardinal read FIN_PERMISSOESDOSGRUPOS_ID write FIN_PERMISSOESDOSGRUPOS_ID;
  		property IN_ENTIDADESDOSISTEMA_ID: TID read FIN_ENTIDADESDOSISTEMA_ID write FIN_ENTIDADESDOSISTEMA_ID;
        property TI_GRUPOS_ID: TID read FTI_GRUPOS_ID write FTI_GRUPOS_ID;
        property TI_LER: Shortint read FTI_LER write FTI_LER;
        property TI_INSERIR: Shortint read FTI_INSERIR write FTI_INSERIR;
        property TI_ALTERAR: Shortint read FTI_ALTERAR write FTI_ALTERAR;
        property TI_EXCLUIR: Shortint read FTI_EXCLUIR write FTI_EXCLUIR;
    end;

    TPermissoesDosGrupos = class(TSyncTable)
  	private
    	function GetPermissaoDoGrupo(i: Cardinal): TPermissaoDoGrupo;
    public
        function Add: TPermissaoDoGrupo;
		property PermissaoDoGrupo[i: Cardinal]: TPermissaoDoGrupo read GetPermissaoDoGrupo; default;
    end;

    TPermissaoDoUsuario = class(TSyncRecord)
  	private
  		FIN_PERMISSOESDOSUSUARIOS_ID: Cardinal;
  		FIN_ENTIDADESDOSISTEMA_ID: TID;
  		FSM_USUARIOS_ID: TID;
  		FTI_LER: Shortint;
  		FTI_INSERIR: ShortInt;
  		FTI_ALTERAR: ShortInt;
  		FTI_EXCLUIR: ShortInt;
    public
        constructor Create(Collection: TCollection); override;
        destructor Destroy; override;

		function PrimaryKeyValue: Int64; override;
        function InsertClause(const aValues, aUsePrimaryKeyValue: Boolean): AnsiString; override;
        function UpdateClause: AnsiString; override;
    published
  		property IN_PERMISSOESDOSUSUARIOS_ID: Cardinal read FIN_PERMISSOESDOSUSUARIOS_ID write FIN_PERMISSOESDOSUSUARIOS_ID;
  		property IN_ENTIDADESDOSISTEMA_ID: TID read FIN_ENTIDADESDOSISTEMA_ID write FIN_ENTIDADESDOSISTEMA_ID;
        property SM_USUARIOS_ID: TID read FSM_USUARIOS_ID write FSM_USUARIOS_ID;
        property TI_LER: Shortint read FTI_LER write FTI_LER;
        property TI_INSERIR: Shortint read FTI_INSERIR write FTI_INSERIR;
        property TI_ALTERAR: Shortint read FTI_ALTERAR write FTI_ALTERAR;
        property TI_EXCLUIR: Shortint read FTI_EXCLUIR write FTI_EXCLUIR;
    end;

    TPermissoesDosUsuarios = class(TSyncTable)
  	private
    	function GetPermissaoDoUsuario(i: Cardinal): TPermissaoDoUsuario;
    public
        function Add: TPermissaoDoUsuario;
		property PermissaoDoUsuario[i: Cardinal]: TPermissaoDoUsuario read GetPermissaoDoUsuario; default;
    end;

    TGrupoDoUsuario = class(TSyncRecord)
  	private
  		FMI_GRUPOSDOSUSUARIOS_ID: Cardinal;
  		FTI_GRUPOS_ID: TID;
  		FSM_USUARIOS_ID: TID;
    public
        constructor Create(Collection: TCollection); override;
        destructor Destroy; override;

		function PrimaryKeyValue: Int64; override;
        function InsertClause(const aValues, aUsePrimaryKeyValue: Boolean): AnsiString; override;
        function UpdateClause: AnsiString; override;
    published
  		property MI_GRUPOSDOSUSUARIOS_ID: Cardinal read FMI_GRUPOSDOSUSUARIOS_ID write FMI_GRUPOSDOSUSUARIOS_ID;
  		property TI_GRUPOS_ID: TID read FTI_GRUPOS_ID write FTI_GRUPOS_ID;
        property SM_USUARIOS_ID: TID read FSM_USUARIOS_ID write FSM_USUARIOS_ID;
    end;

    TGruposDosUsuarios = class(TSyncTable)
  	private
    	function GetGrupoDoUsuario(i: Cardinal): TGrupoDoUsuario;
    public
        function Add: TGrupoDoUsuario;
		property GrupoDoUsuario[i: Cardinal]: TGrupoDoUsuario read GetGrupoDoUsuario; default;
    end;

    TRegiaoDoUsuario = class(TSyncRecord)
  	private
  		FMI_REGIOESDOSUSUARIOS_ID: Cardinal;
  		FTI_REGIOES_ID: TID;
  		FSM_USUARIOS_ID: TID;
    public
        constructor Create(Collection: TCollection); override;
        destructor Destroy; override;

		function PrimaryKeyValue: Int64; override;
        function InsertClause(const aValues, aUsePrimaryKeyValue: Boolean): AnsiString; override;
        function UpdateClause: AnsiString; override;
    published
  		property MI_REGIOESDOSUSUARIOS_ID: Cardinal read FMI_REGIOESDOSUSUARIOS_ID write FMI_REGIOESDOSUSUARIOS_ID;
  		property TI_REGIOES_ID: TID read FTI_REGIOES_ID write FTI_REGIOES_ID;
        property SM_USUARIOS_ID: TID read FSM_USUARIOS_ID write FSM_USUARIOS_ID;
    end;

    TRegioesDosUsuarios = class(TSyncTable)
  	private
    	function GetRegiaoDoUsuario(i: Cardinal): TRegiaoDoUsuario;
    public
        function Add: TRegiaoDoUsuario;
		property RegiaoDoUsuario[i: Cardinal]: TRegiaoDoUsuario read GetRegiaoDoUsuario; default;
    end;

    TEquipamentoDoItem = class(TSyncRecord)
  	private
    	FIN_EQUIPAMENTOSDOSITENS_ID: Cardinal;
        FIN_ITENS_ID: TID;
        FIN_EQUIPAMENTOS_ID: TID;
        FFL_LUCROBRUTO: Double;
        FFL_VALORUNITARIO: Currency;
        FTI_MOEDA: Byte;
    public
        constructor Create(Collection: TCollection); override;
        destructor Destroy; override;

        function PrimaryKeyValue: Int64; override;
        function InsertClause(const aValues, aUsePrimaryKeyValue: Boolean): AnsiString; override;
        function UpdateClause: AnsiString; override;
    published
    	property IN_EQUIPAMENTOSDOSITENS_ID: Cardinal read FIN_EQUIPAMENTOSDOSITENS_ID write FIN_EQUIPAMENTOSDOSITENS_ID;
    	property IN_ITENS_ID: TID read FIN_ITENS_ID write FIN_ITENS_ID;
        property IN_EQUIPAMENTOS_ID: TID read FIN_EQUIPAMENTOS_ID write FIN_EQUIPAMENTOS_ID;
        property FL_LUCROBRUTO: Double	read FFL_LUCROBRUTO write FFL_LUCROBRUTO;
        property FL_VALORUNITARIO: Currency read FFL_VALORUNITARIO write FFL_VALORUNITARIO;
        property TI_MOEDA: Byte read FTI_MOEDA write FTI_MOEDA;
    end;

    TEquipamentosDosItens = class(TSyncTable)
  	private
    	function GetEquipamento(i: Word): TEquipamentoDoItem;
    public
        function Add: TEquipamentoDoItem;
		property Equipamento[i: Word]: TEquipamentoDoItem read GetEquipamento; default;
    end;

    TItem = class(TSyncRecord)
    private
    	FIN_ITENS_ID: Cardinal;
        FIN_PROPOSTAS_ID: TID;
        FTI_FAMILIAS_ID: TID;
        FVA_DESCRICAO: TString150;
        FFL_CAPACIDADE: Double;
        FTI_UNIDADES_ID: TID;
        FSM_QUANTIDADE: Word;
        FEN_VOLTAGEM: TString6;
        FFL_DESCONTOPERC: Double;
        FTI_ORDEM: Byte;
    public
        constructor Create(Collection: TCollection); override;
        destructor Destroy; override;

        function PrimaryKeyValue: Int64; override;
        function InsertClause(const aValues, aUsePrimaryKeyValue: Boolean): AnsiString; override;
        function UpdateClause: AnsiString; override;
    published
	    property IN_ITENS_ID: Cardinal read FIN_ITENS_ID write FIN_ITENS_ID;
    	property IN_PROPOSTAS_ID: TID read FIN_PROPOSTAS_ID write FIN_PROPOSTAS_ID;
        property TI_FAMILIAS_ID: TID read FTI_FAMILIAS_ID write FTI_FAMILIAS_ID;
        property VA_DESCRICAO: TString150 read FVA_DESCRICAO write FVA_DESCRICAO;
        property FL_CAPACIDADE: Double read FFL_CAPACIDADE write FFL_CAPACIDADE;
        property TI_UNIDADES_ID: TID read FTI_UNIDADES_ID write FTI_UNIDADES_ID;
        property SM_QUANTIDADE: Word read FSM_QUANTIDADE write FSM_QUANTIDADE;
        property EN_VOLTAGEM: TString6 read FEN_VOLTAGEM write FEN_VOLTAGEM;
        property FL_DESCONTOPERC: Double read FFL_DESCONTOPERC write FFL_DESCONTOPERC;
        property TI_ORDEM: Byte read FTI_ORDEM write FTI_ORDEM;
    end;

    TItens = class(TSyncTable)
	private
    	function GetItem(i: Word): TItem;
    public
        function Add: TItem;
		property Item[i: Word]: TItem read GetItem; default;
    end;

    TProposta = class(TSyncRecord)
    private
        FIN_PROPOSTAS_ID: Cardinal;
        FIN_OBRAS_ID: TID;
        FSM_CODIGO: Word;
        FYR_ANO: Word;
        FSM_INSTALADORES_ID: TID;
        FVA_CONTATO: TString64;
        FBO_PROPOSTAPADRAO: Boolean;
        FFL_DESCONTOPERC: Double;
        FFL_DESCONTOVAL: Double;
        FTI_MOEDA: Byte;
        FVA_COTACOES: TString40;
        FTI_VALIDADE: Byte;
    public
        constructor Create(Collection: TCollection); override;
        destructor Destroy; override;

        function PrimaryKeyValue: Int64; override;
        function InsertClause(const aValues, aUsePrimaryKeyValue: Boolean): AnsiString; override;
        function UpdateClause: AnsiString; override;
    published
    	property IN_PROPOSTAS_ID: Cardinal read FIN_PROPOSTAS_ID write FIN_PROPOSTAS_ID;
		property IN_OBRAS_ID: TID read FIN_OBRAS_ID write FIN_OBRAS_ID;
        property SM_CODIGO: Word read FSM_CODIGO write FSM_CODIGO;
        property YR_ANO: Word read FYR_ANO write FYR_ANO;
        property SM_INSTALADORES_ID: TID read FSM_INSTALADORES_ID write FSM_INSTALADORES_ID;
        property VA_CONTATO: TString64 read FVA_CONTATO write FVA_CONTATO;
        property BO_PROPOSTAPADRAO: Boolean read FBO_PROPOSTAPADRAO write FBO_PROPOSTAPADRAO;
        property FL_DESCONTOPERC: Double read FFL_DESCONTOPERC write FFL_DESCONTOPERC;
        property FL_DESCONTOVAL: Double read FFL_DESCONTOVAL write FFL_DESCONTOVAL;
        property TI_MOEDA: Byte read FTI_MOEDA write FTI_MOEDA;
        property VA_COTACOES: TString40 read FVA_COTACOES write FVA_COTACOES;
        property TI_VALIDADE: Byte read FTI_VALIDADE write FTI_VALIDADE;
    end;

    TPropostas = class(TSyncTable)
	private
	    function GetProposta(i: Word): TProposta;
    public
        function Add: TProposta;
		property Proposta[i: Word]: TProposta read GetProposta; default;
    end;

    TObra = class(TSyncRecord)
    private
        FIN_OBRAS_ID: Cardinal;
        FTI_REGIOES_ID: TID;
        FVA_NOMEDAOBRA: AnsiString;
        FVA_CIDADE: AnsiString;
        FCH_ESTADO: TString2;
        FTI_SITUACOES_ID: TID;
        FVA_PRAZODEENTREGA: AnsiString;
        FYR_ANOPROVAVELDEENTREGA: Word;
        FTI_MESPROVAVELDEENTREGA: Byte;
        FTX_CONDICAODEPAGAMENTO: AnsiString;
        FFL_ICMS: Double;
        FEN_FRETE: TString3;
        FTX_CONDICOESGERAIS: AnsiString;
        FTX_OBSERVACOES: AnsiString;
        FSM_USUARIOJUSTIFICADOR_ID: TID;
        FVA_CONSTRUTORA: AnsiString;
        FTI_TIPOS_ID: TID;
        FSM_PROJETISTAS_ID: TID;
    	FDA_DATADEEXPIRACAO: TDateTime;
    public
        constructor Create(Collection: TCollection); override;
        destructor Destroy; override;

		function PrimaryKeyValue: Int64; override;
        function InsertClause(const aValues, aUsePrimaryKeyValue: Boolean): AnsiString; override;
        function UpdateClause: AnsiString; override;
    published
    	property IN_OBRAS_ID: Cardinal read FIN_OBRAS_ID write FIN_OBRAS_ID;
        property TI_REGIOES_ID: TID read FTI_REGIOES_ID write FTI_REGIOES_ID;
        property VA_NOMEDAOBRA: AnsiString read FVA_NOMEDAOBRA write FVA_NOMEDAOBRA;
        property VA_CIDADE: AnsiString read FVA_CIDADE write FVA_CIDADE;
        property CH_ESTADO: TString2 read FCH_ESTADO write FCH_ESTADO;
        property TI_SITUACOES_ID: TID read FTI_SITUACOES_ID write FTI_SITUACOES_ID;
        property VA_PRAZODEENTREGA: AnsiString read FVA_PRAZODEENTREGA write FVA_PRAZODEENTREGA;
        property YR_ANOPROVAVELDEENTREGA: Word read FYR_ANOPROVAVELDEENTREGA write FYR_ANOPROVAVELDEENTREGA;
        property TI_MESPROVAVELDEENTREGA: Byte read FTI_MESPROVAVELDEENTREGA write FTI_MESPROVAVELDEENTREGA;
        property TX_CONDICAODEPAGAMENTO: AnsiString read FTX_CONDICAODEPAGAMENTO write FTX_CONDICAODEPAGAMENTO;
        property FL_ICMS: Double read FFL_ICMS write FFL_ICMS;
        property EN_FRETE: TString3 read FEN_FRETE write FEN_FRETE;
        property TX_CONDICOESGERAIS: AnsiString read FTX_CONDICOESGERAIS write FTX_CONDICOESGERAIS;
        property TX_OBSERVACOES: AnsiString read FTX_OBSERVACOES write FTX_OBSERVACOES;
        property SM_USUARIOJUSTIFICADOR_ID: TID read FSM_USUARIOJUSTIFICADOR_ID write FSM_USUARIOJUSTIFICADOR_ID;
        property VA_CONSTRUTORA: AnsiString read FVA_CONSTRUTORA write FVA_CONSTRUTORA;
        property TI_TIPOS_ID: TID read FTI_TIPOS_ID write FTI_TIPOS_ID;
        property SM_PROJETISTAS_ID: TID read FSM_PROJETISTAS_ID write FSM_PROJETISTAS_ID;
        property DA_DATADEEXPIRACAO: TDateTime read FDA_DATADEEXPIRACAO write FDA_DATADEEXPIRACAO;
    end;

    TObras = class(TSyncTable)
	private
	    function GetObra(i: Cardinal): TObra;
    public
        function Add: TObra;
		property Obra[i: Cardinal]: TObra read GetObra; default;
    end;

	TSynchronizationFile = class(TSyncFile)
    private
		FEntidadesDoSistema: TEntidadesDoSistema;
		FEquipamentos: TEquipamentos;
		FFamilias: TFamilias;
		FGrupos: TGrupos;
		FIcmss: TIcmss;
		FInstaladores: TInstaladores;
		FProjetistas: TProjetistas;
		FRegioes: TRegioes;
		FSituacoes: TSituacoes;
		FTipos: TTipos;
		FUnidades: TUnidades;
		FUsuarios: TUsuarios;
        FJustificativas: TJustificativas;

        FJustificativasDasObras: TJustificativasDasObras;
		FPermissoesDosGrupos: TPermissoesDosGrupos;
		FPermissoesDosUsuarios: TPermissoesDosUsuarios;
		FGruposDosUsuarios: TGruposDosUsuarios;
      	FRegioesDosUsuarios: TRegioesDosUsuarios;
		FEquipamentosDosItens: TEquipamentosDosItens;
	   	FItens: TItens;
	   	FPropostas: TPropostas;
		FObras: TObras;
	protected
        procedure Clear; override;
    	function InsertCommand(aSynctable: TSyncTable; aSyncRecord: TSyncRecord; const aUsePrimaryKeyValue: Boolean): AnsiString; override;
    	function UpdateCommand(aSynctable: TSyncTable; aSyncRecord: TSyncRecord): AnsiString; override;
        function DeleteCommand(aSynctable: TSyncTable; aSyncRecord: TSyncRecord): AnsiString; override;
        function SynKeyCommand(aSynctable: TSyncTable; aSyncRecord: TSyncRecord): AnsiString; override;
		function PosDbActnCmds: AnsiString; override;
        {$IFDEF FTPSYNCCLI}
        function PosTbActnCmds(aSynctable: TSyncTable): AnsiString; override;
        {$ENDIF}
    public
    	constructor Create(const aOwner: TComponent; const aUsePrimaryKeyValue: Boolean); override;
        destructor Destroy; override;
    published
    	property EntidadesDoSistema: TEntidadesDoSistema read FEntidadesDoSistema write FEntidadesDoSistema;
		property Equipamentos: TEquipamentos read FEquipamentos write FEquipamentos;
		property Familias: TFamilias read FFamilias write FFamilias;
		property Grupos: TGrupos read FGrupos write FGrupos;
		property Icmss: TIcmss read FIcmss write FIcmss;
		property Instaladores: TInstaladores read FInstaladores write FInstaladores;
		property Projetistas: TProjetistas read FProjetistas write FProjetistas;
		property Regioes: TRegioes read FRegioes write FRegioes;
		property Situacoes: TSituacoes read FSituacoes write FSituacoes;
		property Tipos: TTipos read FTipos write FTipos;
		property Unidades: TUnidades read FUnidades write FUnidades;
		property Usuarios: TUsuarios read FUsuarios write FUsuarios;
		property Justificativas: TJustificativas read FJustificativas write FJustificativas;

		property JustificativasDasObras: TJustificativasDasObras read FJustificativasDasObras write FJustificativasDasObras;
		property PermissoesDosGrupos: TPermissoesDosGrupos read FPermissoesDosGrupos write FPermissoesDosGrupos;
		property PermissoesDosUsuarios: TPermissoesDosUsuarios read FPermissoesDosUsuarios write FPermissoesDosUsuarios;
		property GruposDosUsuarios: TGruposDosUsuarios read FGruposDosUsuarios write FGruposDosUsuarios;
      	property RegioesDosUsuarios: TRegioesDosUsuarios read FRegioesDosUsuarios write FRegioesDosUsuarios;
		property EquipamentosDosItens: TEquipamentosDosItens read FEquipamentosDosItens write FEquipamentosDosItens;
	   	property Itens: TItens read FItens write FItens;
	   	property Propostas: TPropostas read FPropostas write FPropostas;
		property Obras: TObras read FObras write FObras;
    end;

implementation

uses
  	SysUtils, UFSYGlobals, StrUtils;

const
	INFO_INSERT_TEMPLATE_COLUMNS = ',SM_USUARIOCRIADOR_ID,DT_DATAEHORADACRIACAO,SM_USUARIOMODIFICADOR_ID,DT_DATAEHORADAMODIFICACAO,EN_SITUACAO';
    INFO_INSERT_TEMPLATE_VALUES = ',%u,%s,%u,%s,''SINCRONIZADO''';
    INFO_UPDATE_TEMPLATE = #13#10'     , SM_USUARIOCRIADOR_ID = %u'#13#10 +
                                 '     , DT_DATAEHORADACRIACAO = %s'#13#10 +
                                 '     , SM_USUARIOMODIFICADOR_ID = %u'#13#10 +
                                 '     , DT_DATAEHORADAMODIFICACAO = %s'#13#10 +
                                 '     , EN_SITUACAO = ''SINCRONIZADO''';

{ TSyncronizationFile }

procedure TSynchronizationFile.Clear;
begin
	inherited;
    { Tabelas independentes }
    FEntidadesDoSistema.Clear;
	FEquipamentos.Clear;
	FFamilias.Clear;
	FGrupos.Clear;
  	FIcmss.Clear;
	FInstaladores.Clear;
    FProjetistas.Clear;
	FRegioes.Clear;
	FSituacoes.Clear;
	FTipos.Clear;
	FUnidades.Clear;
	FUsuarios.Clear;
    { Tabelas dependentes }
	FPermissoesDosGrupos.Clear;
	FPermissoesDosUsuarios.Clear;
	FGruposDosUsuarios.Clear;
	FRegioesDosUsuarios.Clear;
	FEquipamentosDosItens.Clear;
	FItens.Clear;
	FPropostas.Clear;
    FObras.Clear;
end;

constructor TSynchronizationFile.Create(const aOwner: TComponent; const aUsePrimaryKeyValue: Boolean);
begin
  	inherited;
    { A oderm de colocação das tabelas aqui é importante por que ao se gerar o
    script as inserções tem de ser feitas nesta ordem. Um dia tente alterar
    AddSyncTable de forma que ele organize automaticamente as tabelas. A ordem
    tem de ser respeitada também porque AddSyncTable instancia as variáveis de
    tabelas, logo, se uma tabela tem como pai uma outra, o AddSyncTable desta
    outra tem de ser posto antes  }
    { Tabelas independentes }
    AddSyncTable(TEntidadesDoSistema,TEntidadeDoSistema,FEntidadesDoSistema,'ENTIDADESDOSISTEMA','IN_ENTIDADESDOSISTEMA_ID',[]);
	AddSyncTable(TEquipamentos,TEquipamento,FEquipamentos,'EQUIPAMENTOS','IN_EQUIPAMENTOS_ID',[]);
	AddSyncTable(TFamilias,TFamilia,FFamilias,'FAMILIAS','TI_FAMILIAS_ID',[]);
	AddSyncTable(TGrupos,TGrupo,FGrupos,'GRUPOS','TI_GRUPOS_ID',[]);
    AddSyncTable(TIcmss,TIcms,FIcmss,'ICMS','TI_ICMS_ID',[]);
	AddSyncTable(TInstaladores,TInstalador,FInstaladores,'INSTALADORES','SM_INSTALADORES_ID',[]);
    AddSyncTable(TProjetistas,TProjetista,FProjetistas,'PROJETISTAS','SM_PROJETISTAS_ID',[]);
	AddSyncTable(TRegioes,TRegiao,FRegioes,'REGIOES','TI_REGIOES_ID',[]);
	AddSyncTable(TSituacoes,TSituacao,FSituacoes,'SITUACOES','TI_SITUACOES_ID',[]);
	AddSyncTable(TTipos,TTipo,FTipos,'TIPOS','TI_TIPOS_ID',[]);
	AddSyncTable(TUnidades,TUnidade,FUnidades,'UNIDADES','TI_UNIDADES_ID',[]);
	AddSyncTable(TUsuarios,TUsuario,FUsuarios,'USUARIOS','SM_USUARIOS_ID',[]);
	AddSyncTable(TJustificativas,TJustificativa,FJustificativas,'JUSTIFICATIVAS','TI_JUSTIFICATIVAS_ID',[]);

    { Tabelas dependentes }
	AddSyncTable(TPermissoesDosGrupos,TPermissaoDoGrupo,FPermissoesDosGrupos,'PERMISSOESDOSGRUPOS','IN_PERMISSOESDOSGRUPOS_ID',[FEntidadesDoSistema,FGrupos],1);
	AddSyncTable(TPermissoesDosUsuarios,TPermissaoDoUsuario,FPermissoesDosUsuarios,'PERMISSOESDOSUSUARIOS','IN_PERMISSOESDOSUSUARIOS_ID',[FEntidadesDoSistema,FUsuarios],1);
	AddSyncTable(TGruposDosUsuarios,TGrupoDoUsuario,FGruposDosUsuarios,'GRUPOSDOSUSUARIOS','MI_GRUPOSDOSUSUARIOS_ID',[FGrupos,FUsuarios],1);
	AddSyncTable(TRegioesDosUsuarios,TRegiaoDoUsuario,FRegioesDosUsuarios,'REGIOESDOSUSUARIOS','MI_REGIOESDOSUSUARIOS_ID',[FRegioes,FUsuarios],1);
    AddSyncTable(TObras,TObra,FObras,'OBRAS','IN_OBRAS_ID',[FRegioes,FSituacoes,FTipos,FProjetistas,FUsuarios]);
	AddSyncTable(TPropostas,TProposta,FPropostas,'PROPOSTAS','IN_PROPOSTAS_ID',[FObras,FInstaladores],0);
	AddSyncTable(TItens,TItem,FItens,'ITENS','IN_ITENS_ID',[FPropostas,FFamilias,FUnidades],0);
	AddSyncTable(TEquipamentosDosItens,TEquipamentoDoItem,FEquipamentosDosItens,'EQUIPAMENTOSDOSITENS','IN_EQUIPAMENTOSDOSITENS_ID',[FItens,FEquipamentos],0);
	AddSyncTable(TJustificativasDasObras,TJustificativaDaObra,FJustificativasDasObras,'JUSTIFICATIVASDASOBRAS','MI_JUSTIFICATIVASDASOBRAS_ID',[FJustificativas,FObras],1);
end;

destructor TSynchronizationFile.Destroy;
begin
    { Tabelas independentes }
    FEntidadesDoSistema.Free;
	FEquipamentos.Free;
	FFamilias.Free;
	FGrupos.Free;
  	FIcmss.Free;
	FInstaladores.Free;
    FProjetistas.Free;
	FRegioes.Free;
	FSituacoes.Free;
	FTipos.Free;
	FUnidades.Free;
	FUsuarios.Free;
    FJustificativas.Free;

    { Tabelas dependentes - tem de ser destruídas em ordem inversa }
	FJustificativasDasObras.Free;
	FEquipamentosDosItens.Free;
	FItens.Free;
	FPropostas.Free;
    FObras.Free;
	FRegioesDosUsuarios.Free;
	FGruposDosUsuarios.Free;
	FPermissoesDosUsuarios.Free;
	FPermissoesDosGrupos.Free;
  	inherited;
end;


function TSynchronizationFile.DeleteCommand(aSynctable: TSyncTable; aSyncRecord: TSyncRecord): AnsiString;
const
	DELETE_TEMPLATE = 'DELETE IGNORE FROM %s'#13#10 +
                      ' WHERE %s = %d;'#13#10;
begin
	Result := TFSYGlobals.MySQLFormat(DELETE_TEMPLATE,[aSynctable.TableName
                                     ,aSynctable.PrimaryKeyName
                                     ,aSyncRecord.PrimaryKeyValue]);
end;

function TSynchronizationFile.InsertCommand(      aSynctable: TSyncTable;
                                                  aSyncRecord: TSyncRecord;
                                            const aUsePrimaryKeyValue: Boolean): AnsiString;
const
	{ No servidor INSERT IGNORE impede que erros sejam lançandos quando há a
    tentativa de inserir um registro que viola uma chave única. Neste caso a
    inserção não será realizada e a variável associada com a inserção conterá
    zero. Esta situaçao apenas deve acontecer quando dois clientes distintos
    inserem a mesma informação de acordo com chaves únicas. Se um deles
    conseguir sincronizar, o outro, ao realizar sua sincronização,
    não conseguirá inserir o registro que já existe! O sistema deve então buscar
    o registro já existente e incluir sua chave para uso com SynKeyCommand.

    No cliente as chaves únicas são todas removidas pois no final do
    processamento o Cliente e o servidor ficarão idênticos e corretos. A remoção
    das chaves únicas servirá apenas para impedir que no meio do processo erros
    ocorram, pois no final tudo fucará ajustado (cliente = servidor)

    Não consegui uma forma de achar o registro segundo a chave única por que não
    há como saber qual das muitas chaves únicas está sendo violada. Uma solução
    aproximada seria caso um registro não tiver sido inserido por causa de
    violação destas chaves, criar uma tabela temporária onde cada linha desta
    tabela conteria duas colunas: uma com a chave e a outra com um hash do
    restante das colunas. Bastaria entao buscar pelas informações (hash) e
    retornar a chave. Como este problema é muito específico não vou implementar
    isso agora }

	{ O TEXTO ABAIXO ESTÁ CONSIDERANDO QUE EU TENHO CHAVES UNICAS, MAS DURANTE
    AS SINCRONIZAÇÕES AS CHAVES UNICAS SÃO REMOVIDAS, NESTE CASO, SERÁ QUE
    PRECISAREI ME PREOCUPAR COM A SITUAÇÃO DESCRITA ABAIXO? SERÁ QUE A MELHOR
    SOLUÇÃO SERIA MANTER AS CHAVES UNICAS?

    Usar "insert ignore" impede que erros decorrentes de chaves unicas
    duplicas apareçam. Mas causa um problema, se duas pessoas inserirem o mesmo
    registro com a mesma chave única como isso deve ser manipulado? Supondo que
    eu inseri um registro eu tenho de retornar sua chave criada para atualização,
    mas nesse caso eu deveria usar a chave de um registro já existente no
    servidor porque o registro que eu tentei inserir não foi inserido.

    Vi que last insert id retorna zero quando a ultima iserção não foi bem
    sucedida, logo, caso o valor de NewPrimaryKeyValue no servidor for zero,
    devemos buscar lá o registro que já existe com relação à chave unica.
    Para isso devemos executar uma tentativa de inserção sem ignore e detectar
    na mensagem de erro retornada quem foi duplicado e o que foi duplicado
    fazendo em seguinda um select para obter o valor da chave primária que será
    NewPrimaryKeyValue  }
    INSERT_TEMPLATE = '%s INTO %s (%s)'#13#10 +
                      '%sVALUES (%s);'#13#10 +
                      'DO @%1:s_KEY_%5:u := %s;'#13#10;
begin
    { Se for para usar chave primária significa que o registro TEM DE SER INSERIDO
    com aquela chave, substituindo o registro existente, logo, usa um replace,
    do contrário usa-se um INSERT IGNORE }
    Result := TFSYGlobals.MySQLFormat(INSERT_TEMPLATE,[IfThen(aUsePrimaryKeyValue,'REPLACE','INSERT IGNORE')
                                                      ,aSynctable.TableName
                                                      ,aSyncRecord.InsertClause(False,aUsePrimaryKeyValue)
                                                      ,IfThen(aUsePrimaryKeyValue,' ','') { Pefumaria extrema! }
                                                      ,aSyncRecord.InsertClause(True,aUsePrimaryKeyValue)
                                                      ,aSyncRecord.PrimaryKeyValue
                                                      ,ifThen(aUsePrimaryKeyValue,IntToStr(aSyncRecord.PrimaryKeyValue),'LAST_INSERT_ID()')]);
end;

function TSynchronizationFile.PosDbActnCmds: AnsiString;
const
  DELETE_TEMPLATE = 'DELETE FROM %s'#13#10 +
                    ' WHERE %s > %d;'#13#10;
var
	ST: Word;
  SyncTable: TSyncTable;
begin
	Result := '';

  for ST := 0 to Pred(SyncedTables.Count) do
  begin
    SyncTable := SyncedTables[ST].SyncedTable;

    if SyncTable.Count > 0 then
    begin
	    Result := Result + '# EXCLUINDO REGISTROS SOBRANTES NA TABELA ' + SyncTable.TableName + #13#10;
    	Result := Result + TFSYGlobals.MySQLFormat(DELETE_TEMPLATE,[SyncTable.TableName
    		                   						  ,SyncTable.PrimaryKeyName
                                                      ,SyncTable.LastPrimaryKeyValue]);
    end;
  end;
end;

{$IFDEF FTPSYNCCLI}
function TSynchronizationFile.PosTbActnCmds(aSynctable: TSyncTable): AnsiString;
const
    UPDATE_TEMPLATE =
    'UPDATE %s'#13#10 +
    '   SET %s = -%1:s'#13#10 +
    ' WHERE %1:s < 0;'#13#10;
begin
    Result := inherited PosTbActnCmds(aSynctable) +
    { Este comando é responsável por colocar todas as chaves positivas }
    TFSYGlobals.MySQLFormat(UPDATE_TEMPLATE,[aSynctable.TableName
                                            ,aSynctable.PrimaryKeyName]);
end;{$ENDIF}

function TSynchronizationFile.UpdateCommand(aSynctable: TSyncTable; aSyncRecord: TSyncRecord): AnsiString;
const
    UPDATE_TEMPLATE = 'UPDATE %s'#13#10 +
                      '   SET %s'#13#10 +
                      ' WHERE %s = %d;'#13#10;
{ O modo abaixo estava sendo usado pois poderia haver a situação em que o
registro que estamos tentando atualizar não existe mais, mas acho que isso não
deve ser feito dessa forma }
// UPDATE_TEMPLATE = 'INSERT INTO %s VALUES (%s) ON DUPLICATE KEY UPDATE %s;'#13#10;
begin
	Result := TFSYGlobals.MySQLFormat(UPDATE_TEMPLATE,[aSynctable.TableName
                                     ,aSyncRecord.UpdateClause
                                     ,aSynctable.PrimaryKeyName
                                     ,aSyncRecord.PrimaryKeyValue]);
end;

{ SynKeyCommand só está sendo usado quando script é executado no cliente, como
volta do servidor, logo tudo que for gerado aqui será executado no cliente! }
function TSynchronizationFile.SynKeyCommand(aSynctable: TSyncTable; aSyncRecord: TSyncRecord): AnsiString;
const
    UPDATE_KEY_TEMPLATE1 = 'UPDATE %s'#13#10 +
                           '   SET %s = %d'#13#10 +
                           '     , EN_SITUACAO = ''SINCRONIZADO'''#13#10 +
                           ' WHERE %1:s = %3:u;'#13#10;

    UPDATE_KEY_TEMPLATE2 = 'UPDATE %s'#13#10 +
                           '   SET EN_SITUACAO = ''SINCRONIZADO'''#13#10 +
                           ' WHERE %s = %u;'#13#10;

    { Abaixo estão os dois casos especiais para propostas onde devemos atualizar
    os campos SM_CODIGO e YR_ANO}
    UPDATE_KEY_TEMPLATE3 = 'UPDATE PROPOSTAS'#13#10 +
                           '   SET %s = %d'#13#10 +
                           '     , SM_CODIGO = %u'#13#10 +
                           '     , YR_ANO = %u'#13#10 +
                           '     , EN_SITUACAO = ''SINCRONIZADO'''#13#10 +
                           ' WHERE %0:s = %4:u;'#13#10;

    UPDATE_KEY_TEMPLATE4 = 'UPDATE PROPOSTAS'#13#10 +
                           '   SET SM_CODIGO = %u'#13#10 +
                           '     , YR_ANO = %u'#13#10 +
                           '     , EN_SITUACAO = ''SINCRONIZADO'''#13#10 +
                           ' WHERE %s = %u;'#13#10;

begin
	{ Se as chaves primárias forem diferentes significa que devemos igualá-las }

    if Abs(aSyncRecord.NewPrimaryKeyValue) <> Abs(aSyncRecord.OldPrimaryKeyValue) then
    begin
        if aSynctable.TableName = 'PROPOSTAS' then
		    Result := TFSYGlobals.MySQLFormat(UPDATE_KEY_TEMPLATE3,[aSynctable.PrimaryKeyName
        	                                                       ,aSyncRecord.NewPrimaryKeyValue
                                                                   ,TProposta(aSyncRecord).SM_CODIGO
                                                                   ,TProposta(aSyncRecord).YR_ANO
                                                                   ,aSyncRecord.OldPrimaryKeyValue])
        else
		    Result := TFSYGlobals.MySQLFormat(UPDATE_KEY_TEMPLATE1,[aSynctable.TableName
    	                                                           ,aSynctable.PrimaryKeyName
        	                                                       ,aSyncRecord.NewPrimaryKeyValue
                                                                   ,aSyncRecord.OldPrimaryKeyValue]);
    end
    { Por outro lado se as chaves forem iguais devemos apenas atualizar a
    situação do registro de forma que a mesma seja "SINCRONIZADO" }
    else
    begin
        if (aSynctable.TableName = 'PROPOSTAS') and (TProposta(aSyncRecord).SM_CODIGO > 0) and (TProposta(aSyncRecord).YR_ANO > 0) then
    		Result := TFSYGlobals.MySQLFormat(UPDATE_KEY_TEMPLATE4,[TProposta(aSyncRecord).SM_CODIGO
                                                                   ,TProposta(aSyncRecord).YR_ANO
                                                                   ,aSynctable.PrimaryKeyName
        	                                                       ,aSyncRecord.OldPrimaryKeyValue])
        else
    		Result := TFSYGlobals.MySQLFormat(UPDATE_KEY_TEMPLATE2,[aSynctable.TableName
                                                                   ,aSynctable.PrimaryKeyName
        	                                                       ,aSyncRecord.OldPrimaryKeyValue]);
    end;
end;

{ ---------------------------------------------------------------------------- }

//function RegraDeOrdenacao(Item1, Item2: TSyncRecord): ShortInt;
//begin
//    { Apenas haverá comparação se ao menos uma das ações de um dos itens for a
//    ação de sincronismo de chaves, pois as ações de sincronismo tem de ser
//    executadas antes de qualquer outra ação. As demais ações devem ser
//    executadas na ordem em que elas tiverem sido salvas.
//    As ações de sincronismo tem de ser executadas antes das demais para proteger
//    os registros locais de serem errôneamente substituídos. É! Não sei explicar!
//    Mas acredite, os comandos de sincronismo de chaves tem de ser feitos antes
//    de qualquer coisa }
//
//    Result := 0; { Não precisa ordenar, mantém no mesmo lugar (Rimou! heehe) }
//    if ((Item1.ActionPerformed = apSynKey) and (Item2.ActionPerformed <> apSynKey))
//    or ((Item1.ActionPerformed <> apSynKey) and (Item2.ActionPerformed = apSynKey)) then
//        if Item1.ActionPerformed > Item2.ActionPerformed then
//            Result := 1
//        else if Item1.ActionPerformed < Item2.ActionPerformed then
//            Result := -1;
//end;

{ TJustificativasDasObras }

function TJustificativasDasObras.Add: TJustificativaDaObra;
begin
    Result := TJustificativaDaObra(inherited Add);
end;

function TJustificativasDasObras.GetJustificativaDaObra(i: Cardinal): TJustificativaDaObra;
begin
    Result := TJustificativaDaObra(inherited Items[i]);
end;

{ TJustificativas }

function TJustificativas.Add: TJustificativa;
begin
	Result := TJustificativa(inherited Add);
end;

function TJustificativas.GetJustificativa(i: Cardinal): TJustificativa;
begin
	Result := TJustificativa(inherited Items[i]);
end;

{ TEntidadesDoSistema }

function TEntidadesDoSistema.Add: TEntidadeDoSistema;
begin
	Result := TEntidadeDoSistema(inherited Add);
end;

function TEntidadesDoSistema.GetEntidadeDoSistema(i: Cardinal): TEntidadeDoSistema;
begin
	Result := TEntidadeDoSistema(inherited Items[i]);
end;

{ TEquipamentos }

function TEquipamentos.Add: TEquipamento;
begin
	Result := TEquipamento(inherited Add);
end;

function TEquipamentos.GetEquipamento(i: Cardinal): TEquipamento;
begin
	Result := TEquipamento(inherited Items[i]);
end;

{ TFamilias }

function TFamilias.Add: TFamilia;
begin
	Result := TFamilia(inherited Add);
end;

function TFamilias.GetFamilia(i: Cardinal): TFamilia;
begin
	Result := TFamilia(inherited Items[i]);
end;

{ TGrupos }

function TGrupos.Add: TGrupo;
begin
	Result := TGrupo(inherited Add);
end;

function TGrupos.GetGrupo(i: Cardinal): TGrupo;
begin
	Result := TGrupo(inherited Items[i]);
end;

{ TRegioes }

function TRegioes.Add: TRegiao;
begin
	Result := TRegiao(inherited Add);
end;

function TRegioes.GetRegiao(i: Cardinal): TRegiao;
begin
	Result := TRegiao(inherited Items[i]);
end;

{ TSituacoes }

function TSituacoes.Add: TSituacao;
begin
	Result := TSituacao(inherited Add);
end;

function TSituacoes.GetSituacao(i: Cardinal): TSituacao;
begin
	Result := TSituacao(inherited Items[i]);
end;

{ TTipos }

function TTipos.Add: TTipo;
begin
	Result := TTipo(inherited Add);
end;

function TTipos.GetTipo(i: Cardinal): TTipo;
begin
	Result := TTipo(inherited Items[i]);
end;

{ TProjetistas }

function TProjetistas.Add: TProjetista;
begin
	Result := TProjetista(inherited Add);
end;

function TProjetistas.GetProjetista(i: Cardinal): TProjetista;
begin
	Result := TProjetista(inherited Items[i]);
end;

{ TIcmss }

function TIcmss.Add: TIcms;
begin
	Result := TIcms(inherited Add);
end;

function TIcmss.GetIcms(i: Cardinal): TIcms;
begin
	Result := TIcms(inherited Items[i]);
end;

{ TInstaladores }

function TInstaladores.Add: TInstalador;
begin
	Result := TInstalador(inherited Add);
end;

function TInstaladores.GetInstalador(i: Cardinal): TInstalador;
begin
	Result := TInstalador(inherited Items[i]);
end;

{ TUnidades }

function TUnidades.Add: TUnidade;
begin
	Result := TUnidade(inherited Add);
end;

function TUnidades.GetUnidade(i: Cardinal): TUnidade;
begin
	Result := TUnidade(inherited Items[i]);
end;

{ TUsuarios }

function TUsuarios.Add: TUsuario;
begin
	Result := TUsuario(inherited Add);
end;

function TUsuarios.GetUsuario(i: Cardinal): TUsuario;
begin
	Result := TUsuario(inherited Items[i]);
end;

{ TPermissoesDosGrupos }

function TPermissoesDosGrupos.Add: TPermissaoDoGrupo;
begin
	Result := TPermissaoDoGrupo(inherited Add);
end;

function TPermissoesDosGrupos.GetPermissaoDoGrupo(i: Cardinal): TPermissaoDoGrupo;
begin
    Result := TPermissaoDoGrupo(inherited Items[i]);
end;

{ TPermissoesDosUsuarios }

function TPermissoesDosUsuarios.Add: TPermissaoDoUsuario;
begin
	Result := TPermissaoDoUsuario(inherited Add);
end;

function TPermissoesDosUsuarios.GetPermissaoDoUsuario(i: Cardinal): TPermissaoDoUsuario;
begin
	Result := TPermissaoDoUsuario(inherited Items[i]);
end;

{ TGruposDosUsuarios }

function TGruposDosUsuarios.Add: TGrupoDoUsuario;
begin
	Result := TGrupoDoUsuario(inherited Add);
end;

function TGruposDosUsuarios.GetGrupoDoUsuario(i: Cardinal): TGrupoDoUsuario;
begin
	Result := TGrupoDoUsuario(inherited Items[i]);
end;

{ TRegioesDosUsuarios }

function TRegioesDosUsuarios.Add: TRegiaoDoUsuario;
begin
	Result := TRegiaoDoUsuario(inherited Add);
end;

function TRegioesDosUsuarios.GetRegiaoDoUsuario(i: Cardinal): TRegiaoDoUsuario;
begin
	Result := TRegiaoDoUsuario(inherited Items[i]);
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

{ TItens }

function TItens.Add: TItem;
begin
	Result := TItem(inherited Add);
end;

function TItens.GetItem(i: Word): TItem;
begin
    Result := TItem(inherited Items[i]);
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

{ TObras }

function TObras.Add: TObra;
begin
	Result := TObra(inherited Add);
end;

function TObras.GetObra(i: Cardinal): TObra;
begin
	Result := TObra(inherited Items[i]);
end;

{ ---------------------------------------------------------------------------- }

{ TJustificativaDaObra }

function TJustificativaDaObra.PrimaryKeyValue: Int64;
begin
    Result := FMI_JUSTIFICATIVASDASOBRAS_ID;
end;

constructor TJustificativaDaObra.Create(Collection: TCollection);
begin
    inherited;
    FIN_OBRAS_ID := TID.Create(Self);
    FTI_JUSTIFICATIVAS_ID := TID.Create(Self);
end;

destructor TJustificativaDaObra.Destroy;
begin
    FTI_JUSTIFICATIVAS_ID.Free;
    FIN_OBRAS_ID.Free;
    inherited;
end;

function TJustificativaDaObra.InsertClause(const aValues, aUsePrimaryKeyValue: Boolean): AnsiString;
const
	INSERT_TEMPLATE = '%s,%s,%s' + INFO_INSERT_TEMPLATE_VALUES;
begin
	Result := '';
	if aValues then
        Result := TFSYGlobals.MySQLFormat(INSERT_TEMPLATE,[IfThen(aUsePrimaryKeyValue,IntToStr(PrimaryKeyValue),'NULL')
                                                          ,FIN_OBRAS_ID.ReferencedValue('OBRAS')
                                                          ,FTI_JUSTIFICATIVAS_ID.ReferencedValue('JUSTIFICATIVAS')
                                                          ,CreateUser
                                                          ,FormatDateTime('yyyymmddhhnnss',CreateDateTime)
                                                          ,UpdateUser
                                                          ,FormatDateTime('yyyymmddhhnnss',UpdateDateTime)])
    else
    	Result := 'MI_JUSTIFICATIVASDASOBRAS_ID,IN_OBRAS_ID,TI_JUSTIFICATIVAS_ID' + INFO_INSERT_TEMPLATE_COLUMNS;
end;

function TJustificativaDaObra.UpdateClause: AnsiString;
const
	UPDATE_TEMPLATE = 'IN_OBRAS_ID = %s'#13#10 +
               '     , TI_JUSTIFICATIVAS_ID = %s' + INFO_UPDATE_TEMPLATE;
begin
	Result := TFSYGlobals.MySQLFormat(UPDATE_TEMPLATE,[FIN_OBRAS_ID.ReferencedValue('OBRAS')
                                                      ,FTI_JUSTIFICATIVAS_ID.ReferencedValue('JUSTIFICATIVAS')
                                                      ,CreateUser
                                                      ,FormatDateTime('yyyymmddhhnnss',CreateDateTime)
                                                      ,UpdateUser
                                                      ,FormatDateTime('yyyymmddhhnnss',UpdateDateTime)]);
end;

{ TJustificativa }

function TJustificativa.PrimaryKeyValue: Int64;
begin
    Result := FTI_JUSTIFICATIVAS_ID;
end;

function TJustificativa.InsertClause(const aValues, aUsePrimaryKeyValue: Boolean): AnsiString;
const
	INSERT_TEMPLATE = '%s,%s,%s' + INFO_INSERT_TEMPLATE_VALUES;
begin
	Result := '';
	if aValues then
        Result := TFSYGlobals.MySQLFormat(INSERT_TEMPLATE,[IfThen(aUsePrimaryKeyValue,IntToStr(PrimaryKeyValue),'NULL')
                                                          ,TFSYGlobals.Hex(FEN_CATEGORIA)
                                                          ,TFSYGlobals.Hex(FVA_JUSTIFICATIVA)
                                                          ,CreateUser
                                                          ,FormatDateTime('yyyymmddhhnnss',CreateDateTime)
                                                          ,UpdateUser
                                                          ,FormatDateTime('yyyymmddhhnnss',UpdateDateTime)])
    else
    	Result := 'TI_JUSTIFICATIVAS_ID,EN_CATEGORIA,VA_JUSTIFICATIVA' + INFO_INSERT_TEMPLATE_COLUMNS;
end;

function TJustificativa.UpdateClause: AnsiString;
const
	UPDATE_TEMPLATE = 'EN_CATEGORIA = %s'#13#10 +
               '     , VA_JUSTIFICATIVA = %s' + INFO_UPDATE_TEMPLATE;
begin
	Result := TFSYGlobals.MySQLFormat(UPDATE_TEMPLATE,[TFSYGlobals.Hex(FEN_CATEGORIA)
                                                      ,TFSYGlobals.Hex(FVA_JUSTIFICATIVA)
                                                      ,CreateUser
                                                      ,FormatDateTime('yyyymmddhhnnss',CreateDateTime)
                                                      ,UpdateUser
                                                      ,FormatDateTime('yyyymmddhhnnss',UpdateDateTime)]);
end;

{ TEntidadeDoSistema }

function TEntidadeDoSistema.InsertClause(const aValues, aUsePrimaryKeyValue: Boolean): AnsiString;
const
	INSERT_TEMPLATE = '%s,%s,%u' + INFO_INSERT_TEMPLATE_VALUES;
begin
	Result := '';
	if aValues then
        Result := TFSYGlobals.MySQLFormat(INSERT_TEMPLATE,[IfThen(aUsePrimaryKeyValue,IntToStr(PrimaryKeyValue),'NULL')
                                                          ,TFSYGlobals.Hex(FVA_NOME)
                                                          ,FTI_TIPO
                                                          ,CreateUser
                                                          ,FormatDateTime('yyyymmddhhnnss',CreateDateTime)
                                                          ,UpdateUser
                                                          ,FormatDateTime('yyyymmddhhnnss',UpdateDateTime)])
    else
    	Result := 'IN_ENTIDADESDOSISTEMA_ID,VA_NOME,TI_TIPO' + INFO_INSERT_TEMPLATE_COLUMNS;
end;

function TEntidadeDoSistema.PrimaryKeyValue: Int64;
begin
	Result := FIN_ENTIDADESDOSISTEMA_ID;
end;

function TEntidadeDoSistema.UpdateClause: AnsiString;
const
	UPDATE_TEMPLATE = 'VA_NOME = %s'#13#10 +
               '     , TI_TIPO = %u' + INFO_UPDATE_TEMPLATE;
begin
	Result := TFSYGlobals.MySQLFormat(UPDATE_TEMPLATE,[TFSYGlobals.Hex(FVA_NOME)
                                                      ,FTI_TIPO
                                                      ,CreateUser
                                                      ,FormatDateTime('yyyymmddhhnnss',CreateDateTime)
                                                      ,UpdateUser
                                                      ,FormatDateTime('yyyymmddhhnnss',UpdateDateTime)]);
end;

{ TEquipamento }

function TEquipamento.InsertClause(const aValues, aUsePrimaryKeyValue: Boolean): AnsiString;
const
	INSERT_TEMPLATE = '%s,%s,%.4f,%.4f,%.4f,%u,%s' + INFO_INSERT_TEMPLATE_VALUES;
begin
	Result := '';
	if aValues then
        Result := TFSYGlobals.MySQLFormat(INSERT_TEMPLATE,[IfThen(aUsePrimaryKeyValue,IntToStr(PrimaryKeyValue),'NULL')
                                                          ,TFSYGlobals.Hex(FVA_MODELO)
                                                          ,FFL_LUCROBRUTO
                                                          ,FFL_IPI
                                                          ,FFL_VALORUNITARIO
                                                          ,FTI_MOEDA
                                                          ,BoolToStr(FBO_DISPONIVEL,True)
                                                          ,CreateUser
                                                          ,FormatDateTime('yyyymmddhhnnss',CreateDateTime)
                                                          ,UpdateUser
                                                          ,FormatDateTime('yyyymmddhhnnss',UpdateDateTime)])
    else
    	Result := 'IN_EQUIPAMENTOS_ID,VA_MODELO,FL_LUCROBRUTO,FL_IPI,FL_VALORUNITARIO,TI_MOEDA,BO_DISPONIVEL' + INFO_INSERT_TEMPLATE_COLUMNS;
end;

function TEquipamento.PrimaryKeyValue: Int64;
begin
	Result := FIN_EQUIPAMENTOS_ID;
end;

function TEquipamento.UpdateClause: AnsiString;
const
	UPDATE_TEMPLATE = 'VA_MODELO = %s'#13#10 +
               '     , FL_LUCROBRUTO = %.4f'#13#10 +
               '     , FL_IPI = %.4f'#13#10 +
               '     , FL_VALORUNITARIO = %.4f'#13#10 +
               '     , TI_MOEDA = %u'#13#10 +
               '     , BO_DISPONIVEL = %s' + INFO_UPDATE_TEMPLATE;
begin
	Result := TFSYGlobals.MySQLFormat(UPDATE_TEMPLATE,[TFSYGlobals.Hex(FVA_MODELO)
                                                      ,FFL_LUCROBRUTO
                                                      ,FFL_IPI
                                                      ,FFL_VALORUNITARIO
                                                      ,FTI_MOEDA
                                                      ,BoolToStr(FBO_DISPONIVEL,True)
                                                      ,CreateUser
                                                      ,FormatDateTime('yyyymmddhhnnss',CreateDateTime)
                                                      ,UpdateUser
                                                      ,FormatDateTime('yyyymmddhhnnss',UpdateDateTime)]);
end;

{ TFamilia }

function TFamilia.InsertClause(const aValues, aUsePrimaryKeyValue: Boolean): AnsiString;
const
	INSERT_TEMPLATE = '%s,%s' + INFO_INSERT_TEMPLATE_VALUES;
begin
	Result := '';
	if aValues then
        Result := TFSYGlobals.MySQLFormat(INSERT_TEMPLATE,[IfThen(aUsePrimaryKeyValue,IntToStr(PrimaryKeyValue),'NULL')
                                                          ,TFSYGlobals.Hex(FVA_DESCRICAO)
                                                          ,CreateUser
                                                          ,FormatDateTime('yyyymmddhhnnss',CreateDateTime)
                                                          ,UpdateUser
                                                          ,FormatDateTime('yyyymmddhhnnss',UpdateDateTime)])
    else
    	Result := 'TI_FAMILIAS_ID,VA_DESCRICAO' + INFO_INSERT_TEMPLATE_COLUMNS;
end;

function TFamilia.PrimaryKeyValue: Int64;
begin
	Result := FTI_FAMILIAS_ID;
end;

function TFamilia.UpdateClause: AnsiString;
const
	UPDATE_TEMPLATE = 'VA_DESCRICAO = %s' + INFO_UPDATE_TEMPLATE;
begin
	Result := TFSYGlobals.MySQLFormat(UPDATE_TEMPLATE,[TFSYGlobals.Hex(FVA_DESCRICAO)
                                                      ,CreateUser
                                                      ,FormatDateTime('yyyymmddhhnnss',CreateDateTime)
                                                      ,UpdateUser
                                                      ,FormatDateTime('yyyymmddhhnnss',UpdateDateTime)]);
end;

{ TGrupo }

function TGrupo.InsertClause(const aValues, aUsePrimaryKeyValue: Boolean): AnsiString;
const
	INSERT_TEMPLATE = '%s,%s,%s' + INFO_INSERT_TEMPLATE_VALUES;
begin
	Result := '';
	if aValues then
        Result := TFSYGlobals.MySQLFormat(INSERT_TEMPLATE,[IfThen(aUsePrimaryKeyValue,IntToStr(PrimaryKeyValue),'NULL')
                                                          ,TFSYGlobals.Hex(FVA_NOME)
                                                          ,TFSYGlobals.Hex(FVA_DESCRICAO)
                                                          ,CreateUser
                                                          ,FormatDateTime('yyyymmddhhnnss',CreateDateTime)
                                                          ,UpdateUser
                                                          ,FormatDateTime('yyyymmddhhnnss',UpdateDateTime)])
    else
    	Result := 'TI_GRUPOS_ID,VA_NOME,VA_DESCRICAO' + INFO_INSERT_TEMPLATE_COLUMNS;
end;

function TGrupo.PrimaryKeyValue: Int64;
begin
	Result := FTI_GRUPOS_ID;
end;

function TGrupo.UpdateClause: AnsiString;
const
	UPDATE_TEMPLATE = 'VA_NOME = %s'#13#10 +
               '     , VA_DESCRICAO = %s' + INFO_UPDATE_TEMPLATE;
begin
	Result := TFSYGlobals.MySQLFormat(UPDATE_TEMPLATE,[TFSYGlobals.Hex(FVA_NOME)
                                                      ,TFSYGlobals.Hex(FVA_DESCRICAO)
                                                      ,CreateUser
                                                      ,FormatDateTime('yyyymmddhhnnss',CreateDateTime)
                                                      ,UpdateUser
                                                      ,FormatDateTime('yyyymmddhhnnss',UpdateDateTime)]);
end;

{ TRegiao }

function TRegiao.InsertClause(const aValues, aUsePrimaryKeyValue: Boolean): AnsiString;
const
	INSERT_TEMPLATE = '%s,%s,%s,%s,%s' + INFO_INSERT_TEMPLATE_VALUES;
begin
	Result := '';
	if aValues then
        Result := TFSYGlobals.MySQLFormat(INSERT_TEMPLATE,[IfThen(aUsePrimaryKeyValue,IntToStr(PrimaryKeyValue),'NULL')
                                                          ,TFSYGlobals.Hex(FVA_REGIAO)
                                                          ,TFSYGlobals.Hex(FCH_PREFIXODAPROPOSTA)
                                                          ,TFSYGlobals.Hex(FVA_PRIMEIRORODAPE)
                                                          ,TFSYGlobals.Hex(FVA_SEGUNDORODAPE)
                                                          ,CreateUser
                                                          ,FormatDateTime('yyyymmddhhnnss',CreateDateTime)
                                                          ,UpdateUser
                                                          ,FormatDateTime('yyyymmddhhnnss',UpdateDateTime)])
    else
    	Result := 'TI_REGIOES_ID,VA_REGIAO,CH_PREFIXODAPROPOSTA,VA_PRIMEIRORODAPE,VA_SEGUNDORODAPE' + INFO_INSERT_TEMPLATE_COLUMNS;
end;

function TRegiao.PrimaryKeyValue: Int64;
begin
	Result := FTI_REGIOES_ID;
end;

function TRegiao.UpdateClause: AnsiString;
const
	UPDATE_TEMPLATE = 'VA_REGIAO = %s'#13#10 +
               '     , CH_PREFIXODAPROPOSTA = %s'#13#10 +
               '     , VA_PRIMEIRORODAPE = %s'#13#10 +
               '     , VA_SEGUNDORODAPE = %s' + INFO_UPDATE_TEMPLATE;
begin
	Result := TFSYGlobals.MySQLFormat(UPDATE_TEMPLATE,[TFSYGlobals.Hex(FVA_REGIAO)
                                                      ,TFSYGlobals.Hex(FCH_PREFIXODAPROPOSTA)
                                                      ,TFSYGlobals.Hex(FVA_PRIMEIRORODAPE)
                                                      ,TFSYGlobals.Hex(FVA_SEGUNDORODAPE)
                                                      ,CreateUser
                                                      ,FormatDateTime('yyyymmddhhnnss',CreateDateTime)
                                                      ,UpdateUser
                                                      ,FormatDateTime('yyyymmddhhnnss',UpdateDateTime)]);
end;

{ TSituacao }

function TSituacao.InsertClause(const aValues, aUsePrimaryKeyValue: Boolean): AnsiString;
const
	INSERT_TEMPLATE = '%s,%s,%s,%s,%u' + INFO_INSERT_TEMPLATE_VALUES;
begin
	Result := '';
	if aValues then
        Result := TFSYGlobals.MySQLFormat(INSERT_TEMPLATE,[IfThen(aUsePrimaryKeyValue,IntToStr(PrimaryKeyValue),'NULL')
                                                          ,TFSYGlobals.Hex(FVA_DESCRICAO)
                                                          ,UpperCase(BoolToStr(FBO_EXPIRAVEL,True))
                                                          ,UpperCase(BoolToStr(FBO_JUSTIFICAVEL,True))
                                                          ,FTI_DIASPARAEXPIRACAO
                                                          ,CreateUser
                                                          ,FormatDateTime('yyyymmddhhnnss',CreateDateTime)
                                                          ,UpdateUser
                                                          ,FormatDateTime('yyyymmddhhnnss',UpdateDateTime)])
    else
    	Result := 'TI_SITUACOES_ID,VA_DESCRICAO,BO_EXPIRAVEL,BO_JUSTIFICAVEL,TI_DIASPARAEXPIRACAO' + INFO_INSERT_TEMPLATE_COLUMNS;
end;

function TSituacao.PrimaryKeyValue: Int64;
begin
	Result := FTI_SITUACOES_ID;
end;

function TSituacao.UpdateClause: AnsiString;
const
	UPDATE_TEMPLATE = 'VA_DESCRICAO = %s'#13#10 +
               '     , BO_EXPIRAVEL = %s'#13#10 +
               '     , BO_JUSTIFICAVEL = %s'#13#10 +
               '     , TI_DIASPARAEXPIRACAO = %u' + INFO_UPDATE_TEMPLATE;
begin
	Result := TFSYGlobals.MySQLFormat(UPDATE_TEMPLATE,[TFSYGlobals.Hex(FVA_DESCRICAO)
                                                      ,UpperCase(BoolToStr(FBO_EXPIRAVEL,True))
                                                      ,UpperCase(BoolToStr(FBO_JUSTIFICAVEL,True))
                                                      ,FTI_DIASPARAEXPIRACAO
                                                      ,CreateUser
                                                      ,FormatDateTime('yyyymmddhhnnss',CreateDateTime)
                                                      ,UpdateUser
                                                      ,FormatDateTime('yyyymmddhhnnss',UpdateDateTime)]);
end;

{ TTipo }

function TTipo.InsertClause(const aValues, aUsePrimaryKeyValue: Boolean): AnsiString;
const
	INSERT_TEMPLATE = '%s,%s' + INFO_INSERT_TEMPLATE_VALUES;
begin
	Result := '';
	if aValues then
        Result := TFSYGlobals.MySQLFormat(INSERT_TEMPLATE,[IfThen(aUsePrimaryKeyValue,IntToStr(PrimaryKeyValue),'NULL')
                                                          ,TFSYGlobals.Hex(FVA_DESCRICAO)
                                                          ,CreateUser
                                                          ,FormatDateTime('yyyymmddhhnnss',CreateDateTime)
                                                          ,UpdateUser
                                                          ,FormatDateTime('yyyymmddhhnnss',UpdateDateTime)])
    else
    	Result := 'TI_TIPOS_ID,VA_DESCRICAO' + INFO_INSERT_TEMPLATE_COLUMNS;
end;

function TTipo.PrimaryKeyValue: Int64;
begin
	Result := FTI_TIPOS_ID;
end;

function TTipo.UpdateClause: AnsiString;
const
	UPDATE_TEMPLATE = 'VA_DESCRICAO = %s' + INFO_UPDATE_TEMPLATE;
begin
	Result := TFSYGlobals.MySQLFormat(UPDATE_TEMPLATE,[TFSYGlobals.Hex(FVA_DESCRICAO)
                                                      ,CreateUser
                                                      ,FormatDateTime('yyyymmddhhnnss',CreateDateTime)
                                                      ,UpdateUser
                                                      ,FormatDateTime('yyyymmddhhnnss',UpdateDateTime)]);
end;

{ TProjetista }

function TProjetista.InsertClause(const aValues, aUsePrimaryKeyValue: Boolean): AnsiString;
const
	INSERT_TEMPLATE = '%s,%s' + INFO_INSERT_TEMPLATE_VALUES;
begin
	Result := '';
	if aValues then
        Result := TFSYGlobals.MySQLFormat(INSERT_TEMPLATE,[IfThen(aUsePrimaryKeyValue,IntToStr(PrimaryKeyValue),'NULL')
                                                          ,TFSYGlobals.Hex(FVA_NOME)
                                                          ,CreateUser
                                                          ,FormatDateTime('yyyymmddhhnnss',CreateDateTime)
                                                          ,UpdateUser
                                                          ,FormatDateTime('yyyymmddhhnnss',UpdateDateTime)])
    else
    	Result := 'SM_PROJETISTAS_ID,VA_NOME' + INFO_INSERT_TEMPLATE_COLUMNS;
end;

function TProjetista.PrimaryKeyValue: Int64;
begin
	Result := FSM_PROJETISTAS_ID;
end;

function TProjetista.UpdateClause: AnsiString;
const
	UPDATE_TEMPLATE = 'VA_NOME = %s' + INFO_UPDATE_TEMPLATE;
begin
	Result := TFSYGlobals.MySQLFormat(UPDATE_TEMPLATE,[TFSYGlobals.Hex(FVA_NOME)
                                                      ,CreateUser
                                                      ,FormatDateTime('yyyymmddhhnnss',CreateDateTime)
                                                      ,UpdateUser
                                                      ,FormatDateTime('yyyymmddhhnnss',UpdateDateTime)]);
end;

{ TIcms }

function TIcms.InsertClause(const aValues, aUsePrimaryKeyValue: Boolean): AnsiString;
const
	INSERT_TEMPLATE = '%s,%.4f' + INFO_INSERT_TEMPLATE_VALUES;
begin
	Result := '';
	if aValues then
        Result := TFSYGlobals.MySQLFormat(INSERT_TEMPLATE,[IfThen(aUsePrimaryKeyValue,IntToStr(PrimaryKeyValue),'NULL')
                                                          ,FFL_VALOR
                                                          ,CreateUser
                                                          ,FormatDateTime('yyyymmddhhnnss',CreateDateTime)
                                                          ,UpdateUser
                                                          ,FormatDateTime('yyyymmddhhnnss',UpdateDateTime)])
    else
    	Result := 'TI_ICMS_ID,FL_VALOR' + INFO_INSERT_TEMPLATE_COLUMNS;
end;

function TIcms.PrimaryKeyValue: Int64;
begin
	Result := FTI_ICMS_ID;
end;

function TIcms.UpdateClause: AnsiString;
const
	UPDATE_TEMPLATE = 'FL_VALOR = %.4f' + INFO_UPDATE_TEMPLATE;
begin
	Result := TFSYGlobals.MySQLFormat(UPDATE_TEMPLATE,[FFL_VALOR
                                                      ,CreateUser
                                                      ,FormatDateTime('yyyymmddhhnnss',CreateDateTime)
                                                      ,UpdateUser
                                                      ,FormatDateTime('yyyymmddhhnnss',UpdateDateTime)]);
end;

{ TInstalador }

function TInstalador.InsertClause(const aValues, aUsePrimaryKeyValue: Boolean): AnsiString;
const
	INSERT_TEMPLATE = '%s,%s' + INFO_INSERT_TEMPLATE_VALUES;
begin
	Result := '';
	if aValues then
        Result := TFSYGlobals.MySQLFormat(INSERT_TEMPLATE,[IfThen(aUsePrimaryKeyValue,IntToStr(PrimaryKeyValue),'NULL')
                                                          ,TFSYGlobals.Hex(FVA_NOME)
                                                          ,CreateUser
                                                          ,FormatDateTime('yyyymmddhhnnss',CreateDateTime)
                                                          ,UpdateUser
                                                          ,FormatDateTime('yyyymmddhhnnss',UpdateDateTime)])
    else
    	Result := 'SM_INSTALADORES_ID, VA_NOME' + INFO_INSERT_TEMPLATE_COLUMNS;
end;

function TInstalador.PrimaryKeyValue: Int64;
begin
	Result := FSM_INSTALADORES_ID;
end;

function TInstalador.UpdateClause: AnsiString;
const
	UPDATE_TEMPLATE = 'VA_NOME = %s' + INFO_UPDATE_TEMPLATE;
begin
	Result := TFSYGlobals.MySQLFormat(UPDATE_TEMPLATE,[TFSYGlobals.Hex(FVA_NOME)
                                                      ,CreateUser
                                                      ,FormatDateTime('yyyymmddhhnnss',CreateDateTime)
                                                      ,UpdateUser
                                                      ,FormatDateTime('yyyymmddhhnnss',UpdateDateTime)]);
end;

{ TUnidade }

function TUnidade.InsertClause(const aValues, aUsePrimaryKeyValue: Boolean): AnsiString;
const
	INSERT_TEMPLATE = '%s,%s,%s' + INFO_INSERT_TEMPLATE_VALUES;
begin
	Result := '';
	if aValues then
        Result := TFSYGlobals.MySQLFormat(INSERT_TEMPLATE,[IfThen(aUsePrimaryKeyValue,IntToStr(PrimaryKeyValue),'NULL')
                                                          ,TFSYGlobals.Hex(FVA_ABREVIATURA),TFSYGlobals.Hex(FVA_DESCRICAO)
                                                          ,CreateUser
                                                          ,FormatDateTime('yyyymmddhhnnss',CreateDateTime)
                                                          ,UpdateUser
                                                          ,FormatDateTime('yyyymmddhhnnss',UpdateDateTime)])
    else
    	Result := 'TI_UNIDADES_ID,VA_ABREVIATURA,VA_DESCRICAO' + INFO_INSERT_TEMPLATE_COLUMNS;
end;

function TUnidade.PrimaryKeyValue: Int64;
begin
	Result := FTI_UNIDADES_ID;
end;

function TUnidade.UpdateClause: AnsiString;
const
	UPDATE_TEMPLATE = 'VA_ABREVIATURA = %s'#13#10 +
               '     , VA_DESCRICAO = %s' + INFO_UPDATE_TEMPLATE;
begin
	Result := TFSYGlobals.MySQLFormat(UPDATE_TEMPLATE,[TFSYGlobals.Hex(FVA_ABREVIATURA),TFSYGlobals.Hex(FVA_DESCRICAO)
                                                      ,CreateUser
                                                      ,FormatDateTime('yyyymmddhhnnss',CreateDateTime)
                                                      ,UpdateUser
                                                      ,FormatDateTime('yyyymmddhhnnss',UpdateDateTime)]);
end;

{ TUsuario }

function TUsuario.InsertClause(const aValues, aUsePrimaryKeyValue: Boolean): AnsiString;
const
	INSERT_TEMPLATE = '%s,%s,%s,%s,%s' + INFO_INSERT_TEMPLATE_VALUES;
begin
	Result := '';          

	if aValues then
        Result := TFSYGlobals.MySQLFormat(INSERT_TEMPLATE,[IfThen(aUsePrimaryKeyValue,IntToStr(PrimaryKeyValue),'NULL')
                                                          ,TFSYGlobals.Hex(FVA_NOME)
                                                          ,TFSYGlobals.Hex(FVA_LOGIN)
                                                          ,TFSYGlobals.Hex(FTB_SENHA)
                                                          ,TFSYGlobals.Hex(FVA_EMAIL)
                                                          ,CreateUser
                                                          ,FormatDateTime('yyyymmddhhnnss',CreateDateTime)
                                                          ,UpdateUser
                                                          ,FormatDateTime('yyyymmddhhnnss',UpdateDateTime)])
    else
    	Result := 'SM_USUARIOS_ID,VA_NOME,VA_LOGIN,TB_SENHA,VA_EMAIL' + INFO_INSERT_TEMPLATE_COLUMNS;
end;

function TUsuario.PrimaryKeyValue: Int64;
begin
	Result := FSM_USUARIOS_ID;
end;

function TUsuario.UpdateClause: AnsiString;
const
	UPDATE_TEMPLATE = 'VA_NOME = %s'#13#10 +
               '     , VA_LOGIN = %s'#13#10 +
               '     , TB_SENHA = %s'#13#10 +
               '     , VA_EMAIL = %s' + INFO_UPDATE_TEMPLATE;
begin
	Result := TFSYGlobals.MySQLFormat(UPDATE_TEMPLATE,[TFSYGlobals.Hex(FVA_NOME)
                                                      ,TFSYGlobals.Hex(FVA_LOGIN)
                                                      ,TFSYGlobals.Hex(FTB_SENHA)
                                                      ,TFSYGlobals.Hex(FVA_EMAIL)
                                                      ,CreateUser
                                                      ,FormatDateTime('yyyymmddhhnnss',CreateDateTime)
                                                      ,UpdateUser
                                                      ,FormatDateTime('yyyymmddhhnnss',UpdateDateTime)]);
end;

{ TPermissaoDoGrupo }

constructor TPermissaoDoGrupo.Create(Collection: TCollection);
begin
	inherited;
    FIN_ENTIDADESDOSISTEMA_ID := TID.Create(Self);
    FTI_GRUPOS_ID := TID.Create(Self);
end;

destructor TPermissaoDoGrupo.Destroy;
begin
    FIN_ENTIDADESDOSISTEMA_ID.Free;
    FTI_GRUPOS_ID.Free;
  	inherited;
end;

function TPermissaoDoGrupo.InsertClause(const aValues, aUsePrimaryKeyValue: Boolean): AnsiString;
const
	INSERT_TEMPLATE = '%s,%s,%s,%d,%d,%d,%d' + INFO_INSERT_TEMPLATE_VALUES;
begin
	Result := '';
	if aValues then
        Result := TFSYGlobals.MySQLFormat(INSERT_TEMPLATE,[IfThen(aUsePrimaryKeyValue,IntToStr(PrimaryKeyValue),'NULL')
                                                          ,FIN_ENTIDADESDOSISTEMA_ID.ReferencedValue('ENTIDADESDOSISTEMA')
                                                          ,FTI_GRUPOS_ID.ReferencedValue('GRUPOS')
                                                          ,FTI_LER
                                                          ,FTI_INSERIR
                                                          ,FTI_ALTERAR
                                                          ,FTI_EXCLUIR
                                                          ,CreateUser
                                                          ,FormatDateTime('yyyymmddhhnnss',CreateDateTime)
                                                          ,UpdateUser
                                                          ,FormatDateTime('yyyymmddhhnnss',UpdateDateTime)])
    else
    	Result := 'IN_PERMISSOESDOSGRUPOS_ID,IN_ENTIDADESDOSISTEMA_ID,TI_GRUPOS_ID,TI_LER,TI_INSERIR,TI_ALTERAR,TI_EXCLUIR' + INFO_INSERT_TEMPLATE_COLUMNS;
end;

function TPermissaoDoGrupo.PrimaryKeyValue: Int64;
begin
	Result := FIN_PERMISSOESDOSGRUPOS_ID;
end;

function TPermissaoDoGrupo.UpdateClause: AnsiString;
const
	UPDATE_TEMPLATE = 'IN_ENTIDADESDOSISTEMA_ID = %s'#13#10 +
               '     , TI_GRUPOS_ID = %s'#13#10 +
               '     , TI_LER = %u'#13#10 +
               '     , TI_INSERIR = %d'#13#10 +
               '     , TI_ALTERAR = %d'#13#10 +
               '     , TI_EXCLUIR = %d' + INFO_UPDATE_TEMPLATE;
begin
	Result := TFSYGlobals.MySQLFormat(UPDATE_TEMPLATE,[FIN_ENTIDADESDOSISTEMA_ID.ReferencedValue('ENTIDADESDOSISTEMA')
                                                      ,FTI_GRUPOS_ID.ReferencedValue('GRUPOS')
                                                      ,FTI_LER
                                                      ,FTI_INSERIR
                                                      ,FTI_ALTERAR
                                                      ,FTI_EXCLUIR
                                                      ,CreateUser
                                                      ,FormatDateTime('yyyymmddhhnnss',CreateDateTime)
                                                      ,UpdateUser
                                                      ,FormatDateTime('yyyymmddhhnnss',UpdateDateTime)]);
end;

{ TPermissaoDoUsuario }

constructor TPermissaoDoUsuario.Create(Collection: TCollection);
begin
	inherited;
    FIN_ENTIDADESDOSISTEMA_ID := TID.Create(Self);
    FSM_USUARIOS_ID := TID.Create(Self);
end;

destructor TPermissaoDoUsuario.Destroy;
begin
    FIN_ENTIDADESDOSISTEMA_ID.Free;
    FSM_USUARIOS_ID.Free;
  	inherited;
end;

function TPermissaoDoUsuario.InsertClause(const aValues, aUsePrimaryKeyValue: Boolean): AnsiString;
const
	INSERT_TEMPLATE = '%s,%s,%s,%d,%d,%d,%d' + INFO_INSERT_TEMPLATE_VALUES;
begin
	Result := '';
	if aValues then
        Result := TFSYGlobals.MySQLFormat(INSERT_TEMPLATE,[IfThen(aUsePrimaryKeyValue,IntToStr(PrimaryKeyValue),'NULL')
                                                          ,FIN_ENTIDADESDOSISTEMA_ID.ReferencedValue('ENTIDADESDOSISTEMA')
                                                          ,FSM_USUARIOS_ID.ReferencedValue('USUARIOS')
                                                          ,FTI_LER
                                                          ,FTI_INSERIR
                                                          ,FTI_ALTERAR
                                                          ,FTI_EXCLUIR
                                                          ,CreateUser
                                                          ,FormatDateTime('yyyymmddhhnnss',CreateDateTime)
                                                          ,UpdateUser
                                                          ,FormatDateTime('yyyymmddhhnnss',UpdateDateTime)])
    else
    	Result := 'IN_PERMISSOESDOSUSUARIOS_ID,IN_ENTIDADESDOSISTEMA_ID,SM_USUARIOS_ID,TI_LER,TI_INSERIR,TI_ALTERAR,TI_EXCLUIR' + INFO_INSERT_TEMPLATE_COLUMNS;
end;

function TPermissaoDoUsuario.PrimaryKeyValue: Int64;
begin
	Result := FIN_PERMISSOESDOSUSUARIOS_ID;
end;

function TPermissaoDoUsuario.UpdateClause: AnsiString;
const
	UPDATE_TEMPLATE = 'IN_ENTIDADESDOSISTEMA_ID = %s'#13#10 +
               '     , SM_USUARIOS_ID = %s'#13#10 +
               '     , TI_LER = %u'#13#10 +
               '     , TI_INSERIR = %d'#13#10 +
               '     , TI_ALTERAR = %d'#13#10 +
               '     , TI_EXCLUIR = %d' + INFO_UPDATE_TEMPLATE;
begin
	Result := TFSYGlobals.MySQLFormat(UPDATE_TEMPLATE,[FIN_ENTIDADESDOSISTEMA_ID.ReferencedValue('ENTIDADESDOSISTEMA')
                                                      ,FSM_USUARIOS_ID.ReferencedValue('USUARIOS')
                                                      ,FTI_LER
                                                      ,FTI_INSERIR
                                                      ,FTI_ALTERAR
                                                      ,FTI_EXCLUIR
                                                      ,CreateUser
                                                      ,FormatDateTime('yyyymmddhhnnss',CreateDateTime)
                                                      ,UpdateUser
                                                      ,FormatDateTime('yyyymmddhhnnss',UpdateDateTime)]);
end;

{ TGrupoDoUsuario }

constructor TGrupoDoUsuario.Create(Collection: TCollection);
begin
	inherited;
    FTI_GRUPOS_ID := TID.Create(Self);
    FSM_USUARIOS_ID := TID.Create(Self);
end;

destructor TGrupoDoUsuario.Destroy;
begin
    FTI_GRUPOS_ID.Free;
    FSM_USUARIOS_ID.Free;
  	inherited;
end;

function TGrupoDoUsuario.InsertClause(const aValues, aUsePrimaryKeyValue: Boolean): AnsiString;
const
	INSERT_TEMPLATE = '%s,%s,%s' + INFO_INSERT_TEMPLATE_VALUES;
begin
	Result := '';
	if aValues then
        Result := TFSYGlobals.MySQLFormat(INSERT_TEMPLATE,[IfThen(aUsePrimaryKeyValue,IntToStr(PrimaryKeyValue),'NULL')
                                                          ,FTI_GRUPOS_ID.ReferencedValue('GRUPOS')
                                                          ,FSM_USUARIOS_ID.ReferencedValue('USUARIOS')
                                                          ,CreateUser
                                                          ,FormatDateTime('yyyymmddhhnnss',CreateDateTime)
                                                          ,UpdateUser
                                                          ,FormatDateTime('yyyymmddhhnnss',UpdateDateTime)])
    else
    	Result := 'MI_GRUPOSDOSUSUARIOS_ID,TI_GRUPOS_ID,SM_USUARIOS_ID' + INFO_INSERT_TEMPLATE_COLUMNS;
end;

function TGrupoDoUsuario.PrimaryKeyValue: Int64;
begin
	Result := FMI_GRUPOSDOSUSUARIOS_ID;
end;

function TGrupoDoUsuario.UpdateClause: AnsiString;
const
	UPDATE_TEMPLATE = 'TI_GRUPOS_ID = %s'#13#10 +
               '     , SM_USUARIOS_ID = %s' + INFO_UPDATE_TEMPLATE;
begin
	Result := TFSYGlobals.MySQLFormat(UPDATE_TEMPLATE,[FTI_GRUPOS_ID.ReferencedValue('GRUPOS')
                                                      ,FSM_USUARIOS_ID.ReferencedValue('USUARIOS')
                                                      ,CreateUser
                                                      ,FormatDateTime('yyyymmddhhnnss',CreateDateTime)
                                                      ,UpdateUser
                                                      ,FormatDateTime('yyyymmddhhnnss',UpdateDateTime)]);
end;

{ TRegiaoDoUsuario }

constructor TRegiaoDoUsuario.Create(Collection: TCollection);
begin
	inherited;
    FTI_REGIOES_ID := TID.Create(Self);
    FSM_USUARIOS_ID := TID.Create(Self);
end;

destructor TRegiaoDoUsuario.Destroy;
begin
    FTI_REGIOES_ID.Free;
    FSM_USUARIOS_ID.Free;
  	inherited;
end;

function TRegiaoDoUsuario.InsertClause(const aValues, aUsePrimaryKeyValue: Boolean): AnsiString;
const
	INSERT_TEMPLATE = '%s,%s,%s' + INFO_INSERT_TEMPLATE_VALUES;
begin
	Result := '';
	if aValues then
        Result := TFSYGlobals.MySQLFormat(INSERT_TEMPLATE,[IfThen(aUsePrimaryKeyValue,IntToStr(PrimaryKeyValue),'NULL')
                                                          ,FTI_REGIOES_ID.ReferencedValue('REGIOES')
                                                          ,FSM_USUARIOS_ID.ReferencedValue('USUARIOS')
                                                          ,CreateUser
                                                          ,FormatDateTime('yyyymmddhhnnss',CreateDateTime)
                                                          ,UpdateUser
                                                          ,FormatDateTime('yyyymmddhhnnss',UpdateDateTime)])
    else
    	Result := 'MI_REGIOESDOSUSUARIOS_ID,TI_REGIOES_ID,SM_USUARIOS_ID' + INFO_INSERT_TEMPLATE_COLUMNS;
end;

function TRegiaoDoUsuario.PrimaryKeyValue: Int64;
begin
	Result := FMI_REGIOESDOSUSUARIOS_ID;
end;

function TRegiaoDoUsuario.UpdateClause: AnsiString;
const
	UPDATE_TEMPLATE = 'TI_REGIOES_ID = %s'#13#10 +
               '     , SM_USUARIOS_ID = %s' + INFO_UPDATE_TEMPLATE;
begin
	Result := TFSYGlobals.MySQLFormat(UPDATE_TEMPLATE,[FTI_REGIOES_ID.ReferencedValue('REGIOES')
                                                      ,FSM_USUARIOS_ID.ReferencedValue('USUARIOS')
                                                      ,CreateUser
                                                      ,FormatDateTime('yyyymmddhhnnss',CreateDateTime)
                                                      ,UpdateUser
                                                      ,FormatDateTime('yyyymmddhhnnss',UpdateDateTime)]);
end;

{ TObra }

constructor TObra.Create(Collection: TCollection);
begin
	inherited;
    FTI_REGIOES_ID := TID.Create(Self);
    FTI_SITUACOES_ID := TID.Create(Self);
    FTI_TIPOS_ID := TID.Create(Self);
    FSM_PROJETISTAS_ID := TID.Create(Self);
    FSM_USUARIOJUSTIFICADOR_ID := TID.Create(Self);
end;

destructor TObra.Destroy;
begin
    FSM_USUARIOJUSTIFICADOR_ID.Free;
    FSM_PROJETISTAS_ID.Free;
    FTI_TIPOS_ID.Free;
    FTI_SITUACOES_ID.Free;
    FTI_REGIOES_ID.Free;
  	inherited;
end;

function TObra.InsertClause(const aValues, aUsePrimaryKeyValue: Boolean): AnsiString;
const
	INSERT_TEMPLATE = '%s,%s,%s,%s,%s,%s,%s,%u,%u,%s,%.4f,%s,%s,%s,%s,%s,%s,%s,%s' + INFO_INSERT_TEMPLATE_VALUES;
begin
	Result := '';
	if aValues then
        Result := TFSYGlobals.MySQLFormat(INSERT_TEMPLATE,[IfThen(aUsePrimaryKeyValue,IntToStr(PrimaryKeyValue),'NULL')
                                                          ,FTI_REGIOES_ID.ReferencedValue('REGIOES')
                                                          ,TFSYGlobals.Hex(FVA_NOMEDAOBRA)
                                                          ,TFSYGlobals.Hex(FVA_CIDADE)
                                                          ,TFSYGlobals.Hex(FCH_ESTADO)
                                                          ,FTI_SITUACOES_ID.ReferencedValue('SITUACOES')
                                                          ,TFSYGlobals.Hex(FVA_PRAZODEENTREGA)
                                                          ,FYR_ANOPROVAVELDEENTREGA
                                                          ,FTI_MESPROVAVELDEENTREGA
                                                          ,TFSYGlobals.Hex(FTX_CONDICAODEPAGAMENTO)
                                                          ,FFL_ICMS
                                                          ,TFSYGlobals.Hex(FEN_FRETE)
                                                          ,TFSYGlobals.Hex(FTX_CONDICOESGERAIS)
                                                          ,TFSYGlobals.Hex(FTX_OBSERVACOES)
                                                          ,FSM_USUARIOJUSTIFICADOR_ID.ReferencedValue('USUARIOS')
                                                          ,TFSYGlobals.Hex(FVA_CONSTRUTORA)
                                                          ,FTI_TIPOS_ID.ReferencedValue('TIPOS')
                                                          ,FSM_PROJETISTAS_ID.ReferencedValue('PROJETISTAS')
                                                          ,IfThen(FDA_DATADEEXPIRACAO > 0,FormatDateTime('yyyymmdd',FDA_DATADEEXPIRACAO),'NULL')
                                                          ,CreateUser
                                                          ,FormatDateTime('yyyymmddhhnnss',CreateDateTime)
                                                          ,UpdateUser
                                                          ,FormatDateTime('yyyymmddhhnnss',UpdateDateTime)])
    else
    	Result := 'IN_OBRAS_ID,TI_REGIOES_ID,VA_NOMEDAOBRA,VA_CIDADE,CH_ESTADO,'+'TI_SITUACOES_ID,VA_PRAZODEENTREGA,YR_ANOPROVAVELDEENTREGA,TI_MESPROVAVELDEENTREGA,TX_CONDICAODEPAGAMENTO,FL_ICMS,EN_FRETE,TX_CONDICOESGERAIS,TX_OBSERVACOES,SM_USUARIOJUSTIFICADOR_ID,VA_CONSTRUTORA,TI_TIPOS_ID,SM_PROJETISTAS_ID,DA_DATADEEXPIRACAO' + INFO_INSERT_TEMPLATE_COLUMNS;
end;

function TObra.PrimaryKeyValue: Int64;
begin
	Result := FIN_OBRAS_ID;
end;

function TObra.UpdateClause: AnsiString;
const
	UPDATE_TEMPLATE = 'TI_REGIOES_ID = %s'#13#10 +
               '     , VA_NOMEDAOBRA = %s'#13#10 +
               '     , VA_CIDADE = %s'#13#10 +
               '     , CH_ESTADO = %s'#13#10 +
               '     , TI_SITUACOES_ID = %s'#13#10 +
               '     , VA_PRAZODEENTREGA = %s'#13#10 +
               '     , YR_ANOPROVAVELDEENTREGA = %u'#13#10 +
               '     , TI_MESPROVAVELDEENTREGA = %u'#13#10 +
               '     , TX_CONDICAODEPAGAMENTO = %s'#13#10 +
               '     , FL_ICMS = %.4f'#13#10 +
               '     , EN_FRETE = %s'#13#10 +
               '     , TX_CONDICOESGERAIS = %s'#13#10 +
               '     , TX_OBSERVACOES = %s'#13#10 +
               '     , SM_USUARIOJUSTIFICADOR_ID = %s'#13#10 +
               '     , VA_CONSTRUTORA = %s'#13#10 +
               '     , TI_TIPOS_ID = %s'#13#10 +
               '     , SM_PROJETISTAS_ID = %s'#13#10 +
               '     , DA_DATADEEXPIRACAO = %s' + INFO_UPDATE_TEMPLATE;
begin
	Result := TFSYGlobals.MySQLFormat(UPDATE_TEMPLATE,[FTI_REGIOES_ID.ReferencedValue('REGIOES')
                                                      ,TFSYGlobals.Hex(FVA_NOMEDAOBRA)
                                                      ,TFSYGlobals.Hex(FVA_CIDADE)
                                                      ,TFSYGlobals.Hex(FCH_ESTADO)
                                                      ,FTI_SITUACOES_ID.ReferencedValue('SITUACOES')
                                                      ,TFSYGlobals.Hex(FVA_PRAZODEENTREGA)
                                                      ,FYR_ANOPROVAVELDEENTREGA
                                                      ,FTI_MESPROVAVELDEENTREGA
                                                      ,TFSYGlobals.Hex(FTX_CONDICAODEPAGAMENTO)
                                                      ,FFL_ICMS
                                                      ,TFSYGlobals.Hex(FEN_FRETE)
                                                      ,TFSYGlobals.Hex(FTX_CONDICOESGERAIS)
                                                      ,TFSYGlobals.Hex(FTX_OBSERVACOES)
                                                      ,FSM_USUARIOJUSTIFICADOR_ID.ReferencedValue('USUARIOS')
                                                      ,TFSYGlobals.Hex(FVA_CONSTRUTORA)
                                                      ,FTI_TIPOS_ID.ReferencedValue('TIPOS')
                                                      ,FSM_PROJETISTAS_ID.ReferencedValue('PROJETISTAS')
                                                      ,IfThen(FDA_DATADEEXPIRACAO > 0,FormatDateTime('yyyymmdd',FDA_DATADEEXPIRACAO),'NULL')
                                                      ,CreateUser
                                                      ,FormatDateTime('yyyymmddhhnnss',CreateDateTime)
                                                      ,UpdateUser
                                                      ,FormatDateTime('yyyymmddhhnnss',UpdateDateTime)]);
end;

{ TProposta }

constructor TProposta.Create(Collection: TCollection);
begin
	inherited;
    FIN_OBRAS_ID := TID.Create(Self);
    FSM_INSTALADORES_ID := TID.Create(Self);
end;

destructor TProposta.Destroy;
begin
    FIN_OBRAS_ID.Free;
    FSM_INSTALADORES_ID.Free;
  	inherited;
end;

function TProposta.InsertClause(const aValues, aUsePrimaryKeyValue: Boolean): AnsiString;
const
	INSERT_TEMPLATE = '%s,%s,%s,%s,%s,%s,%s,%s,%s,%u,%s,%u' + INFO_INSERT_TEMPLATE_VALUES;
begin
	Result := '';
	if aValues then
        Result := TFSYGlobals.MySQLFormat(INSERT_TEMPLATE,[IfThen(aUsePrimaryKeyValue,IntToStr(PrimaryKeyValue),'NULL')
                                                          ,FIN_OBRAS_ID.ReferencedValue('OBRAS')
                                                          ,IfThen(FSM_CODIGO = 0,'NULL',IntToStr(FSM_CODIGO))
                                                          ,IfThen(FYR_ANO = 0,'NULL',IntToStr(FYR_ANO))
                                                          ,FSM_INSTALADORES_ID.ReferencedValue('INSTALADORES')
                                                          ,TFSYGlobals.Hex(FVA_CONTATO)
                                                          ,BoolToStr(FBO_PROPOSTAPADRAO,True)
                                                          ,IfThen(FFL_DESCONTOPERC <> 0,String(TFSYGlobals.MySQLFormat('%.4f',[FFL_DESCONTOPERC])),'NULL')
                                                          ,IfThen(FFL_DESCONTOVAL <> 0,String(TFSYGlobals.MySQLFormat('%.4f',[FFL_DESCONTOVAL])),'NULL')
                                                          ,FTI_MOEDA
                                                          ,TFSYGlobals.Hex(FVA_COTACOES)
                                                          ,FTI_VALIDADE
                                                          ,CreateUser
                                                          ,FormatDateTime('yyyymmddhhnnss',CreateDateTime)
                                                          ,UpdateUser
                                                          ,FormatDateTime('yyyymmddhhnnss',UpdateDateTime)])
    else
    	Result := 'IN_PROPOSTAS_ID,IN_OBRAS_ID,SM_CODIGO,YR_ANO,SM_INSTALADORES_ID,VA_CONTATO,BO_PROPOSTAPADRAO,FL_DESCONTOPERC,FL_DESCONTOVAL,TI_MOEDA,VA_COTACOES,TI_VALIDADE' + INFO_INSERT_TEMPLATE_COLUMNS;
end;

function TProposta.PrimaryKeyValue: Int64;
begin
	Result := FIN_PROPOSTAS_ID;
end;

function TProposta.UpdateClause: AnsiString;
const
	UPDATE_TEMPLATE = 'IN_OBRAS_ID = %s'#13#10 +
               '     , SM_CODIGO = %u'#13#10 +
               '     , YR_ANO = %u'#13#10 +
               '     , SM_INSTALADORES_ID = %s'#13#10 +
               '     , VA_CONTATO = %s'#13#10 +
               '     , BO_PROPOSTAPADRAO = %s'#13#10 +
               '     , FL_DESCONTOPERC = %s'#13#10 +
               '     , FL_DESCONTOVAL = %s'#13#10 +
               '     , TI_MOEDA = %u'#13#10 +
               '     , VA_COTACOES = %s'#13#10 +
               '     , TI_VALIDADE = %u' + INFO_UPDATE_TEMPLATE;
begin
	Result := TFSYGlobals.MySQLFormat(UPDATE_TEMPLATE,[FIN_OBRAS_ID.ReferencedValue('OBRAS')
                                                      ,FSM_CODIGO
                                                      ,FYR_ANO
                                                      ,FSM_INSTALADORES_ID.ReferencedValue('INSTALADORES')
                                                      ,TFSYGlobals.Hex(FVA_CONTATO)
                                                      ,BoolToStr(FBO_PROPOSTAPADRAO,True)
                                                      ,IfThen(FFL_DESCONTOPERC <> 0,String(TFSYGlobals.MySQLFormat('%.4f',[FFL_DESCONTOPERC])),'NULL')
                                                      ,IfThen(FFL_DESCONTOVAL <> 0,String(TFSYGlobals.MySQLFormat('%.4f',[FFL_DESCONTOVAL])),'NULL')
                                                      ,FTI_MOEDA
                                                      ,TFSYGlobals.Hex(FVA_COTACOES)
                                                      ,FTI_VALIDADE
                                                      ,CreateUser
                                                      ,FormatDateTime('yyyymmddhhnnss',CreateDateTime)
                                                      ,UpdateUser
                                                      ,FormatDateTime('yyyymmddhhnnss',UpdateDateTime)]);
end;

{ TItem }

constructor TItem.Create(Collection: TCollection);
begin
	inherited;
    FIN_PROPOSTAS_ID := TID.Create(Self);
    FTI_FAMILIAS_ID := TID.Create(Self);
    FTI_UNIDADES_ID := TID.Create(Self);
end;

destructor TItem.Destroy;
begin
    FIN_PROPOSTAS_ID.Free;
    FTI_FAMILIAS_ID.Free;
    FTI_UNIDADES_ID.Free;
  	inherited;
end;

function TItem.InsertClause(const aValues, aUsePrimaryKeyValue: Boolean): AnsiString;
const
	INSERT_TEMPLATE = '%s,%s,%s,%s,%.4f,%s,%u,%s,%.4f,%u' + INFO_INSERT_TEMPLATE_VALUES;
begin
	Result := '';
	if aValues then
        Result := TFSYGlobals.MySQLFormat(INSERT_TEMPLATE,[IfThen(aUsePrimaryKeyValue,IntToStr(PrimaryKeyValue),'NULL')
                                                          ,FIN_PROPOSTAS_ID.ReferencedValue('PROPOSTAS')
                                                          ,FTI_FAMILIAS_ID.ReferencedValue('FAMILIAS')
                                                          ,TFSYGlobals.Hex(FVA_DESCRICAO)
                                                          ,FFL_CAPACIDADE
                                                          ,FTI_UNIDADES_ID.ReferencedValue('UNIDADE')
                                                          ,FSM_QUANTIDADE
                                                          ,TFSYGlobals.Hex(FEN_VOLTAGEM)
                                                          ,FFL_DESCONTOPERC
                                                          ,FTI_ORDEM
                                                          ,CreateUser
                                                          ,FormatDateTime('yyyymmddhhnnss',CreateDateTime)
                                                          ,UpdateUser
                                                          ,FormatDateTime('yyyymmddhhnnss',UpdateDateTime)])
    else
    	Result := 'IN_ITENS_ID,IN_PROPOSTAS_ID,TI_FAMILIAS_ID,VA_DESCRICAO,FL_CAPACIDADE,TI_UNIDADES_ID,SM_QUANTIDADE,EN_VOLTAGEM,FL_DESCONTOPERC,TI_ORDEM' + INFO_INSERT_TEMPLATE_COLUMNS;
end;

function TItem.PrimaryKeyValue: Int64;
begin
	Result := FIN_ITENS_ID;
end;

function TItem.UpdateClause: AnsiString;
const
	UPDATE_TEMPLATE = 'IN_PROPOSTAS_ID = %s'#13#10 +
               '     , TI_FAMILIAS_ID = %s'#13#10 +
               '     , VA_DESCRICAO = %s'#13#10 +
               '     , FL_CAPACIDADE = %.4f'#13#10 +
               '     , TI_UNIDADES_ID = %s'#13#10 +
               '     , SM_QUANTIDADE = %u'#13#10 +
               '     , EN_VOLTAGEM = %s'#13#10 +
               '     , FL_DESCONTOPERC = %.4f'#13#10 +
               '     , TI_ORDEM = %u' + INFO_UPDATE_TEMPLATE;
begin
	Result := TFSYGlobals.MySQLFormat(UPDATE_TEMPLATE,[FIN_PROPOSTAS_ID.ReferencedValue('PROPOSTAS')
                                                      ,FTI_FAMILIAS_ID.ReferencedValue('FAMILIAS')
                                                      ,TFSYGlobals.Hex(FVA_DESCRICAO)
                                                      ,FFL_CAPACIDADE
                                                      ,FTI_UNIDADES_ID.ReferencedValue('UNIDADE')
                                                      ,FSM_QUANTIDADE
                                                      ,TFSYGlobals.Hex(FEN_VOLTAGEM)
                                                      ,FFL_DESCONTOPERC
                                                      ,FTI_ORDEM
                                                      ,CreateUser
                                                      ,FormatDateTime('yyyymmddhhnnss',CreateDateTime)
                                                      ,UpdateUser
                                                      ,FormatDateTime('yyyymmddhhnnss',UpdateDateTime)]);
end;

{ TEquipamentoDoItem }

constructor TEquipamentoDoItem.Create(Collection: TCollection);
begin
	inherited;
    FIN_ITENS_ID := TID.Create(Self);
    FIN_EQUIPAMENTOS_ID := TID.Create(Self);
end;

destructor TEquipamentoDoItem.Destroy;
begin
    FIN_ITENS_ID.Free;
    FIN_EQUIPAMENTOS_ID.Free;
  	inherited;
end;

function TEquipamentoDoItem.InsertClause(const aValues, aUsePrimaryKeyValue: Boolean): AnsiString;
const
	INSERT_TEMPLATE = '%s,%s,%s,%.4f,%.4f,%u' + INFO_INSERT_TEMPLATE_VALUES;
begin
	Result := '';
	if aValues then
        Result := TFSYGlobals.MySQLFormat(INSERT_TEMPLATE,[IfThen(aUsePrimaryKeyValue,IntToStr(PrimaryKeyValue),'NULL')
                                                          ,FIN_ITENS_ID.ReferencedValue('ITENS')
                                                          ,FIN_EQUIPAMENTOS_ID.ReferencedValue('EQUIPAMENTOS')
                                                          ,FFL_LUCROBRUTO,FFL_VALORUNITARIO,FTI_MOEDA
                                                          ,CreateUser
                                                          ,FormatDateTime('yyyymmddhhnnss',CreateDateTime)
                                                          ,UpdateUser
                                                          ,FormatDateTime('yyyymmddhhnnss',UpdateDateTime)])
    else
    	Result := 'IN_EQUIPAMENTOSDOSITENS_ID,IN_ITENS_ID,IN_EQUIPAMENTOS_ID,FL_LUCROBRUTO,FL_VALORUNITARIO,TI_MOEDA' + INFO_INSERT_TEMPLATE_COLUMNS;
end;

function TEquipamentoDoItem.PrimaryKeyValue: Int64;
begin
	Result := FIN_EQUIPAMENTOSDOSITENS_ID;
end;

function TEquipamentoDoItem.UpdateClause: AnsiString;
const
	UPDATE_TEMPLATE = 'IN_ITENS_ID = %s'#13#10 +
               '     , IN_EQUIPAMENTOS_ID = %s'#13#10 +
               '     , FL_LUCROBRUTO = %.4f'#13#10 +
               '     , FL_VALORUNITARIO = %.4f'#13#10 +
               '     , TI_MOEDA = %u' + INFO_UPDATE_TEMPLATE;
begin
	Result := TFSYGlobals.MySQLFormat(UPDATE_TEMPLATE,[FIN_ITENS_ID.ReferencedValue('ITENS')
                                                      ,FIN_EQUIPAMENTOS_ID.ReferencedValue('EQUIPAMENTOS')
                                                      ,FFL_LUCROBRUTO,FFL_VALORUNITARIO,FTI_MOEDA
                                                      ,CreateUser
                                                      ,FormatDateTime('yyyymmddhhnnss',CreateDateTime)
                                                      ,UpdateUser
                                                      ,FormatDateTime('yyyymmddhhnnss',UpdateDateTime)]);
end;

{ TID }

function TID.ReferencedValue(aTableName: AnsiString): AnsiString;
var
  ParentSyncTable: TSyncTable;
  ParentSyncRecord: TSyncRecord;
begin
	Result := inherited ReferencedValue(aTableName);

	{ Obtendo a tabela pai... }
  ParentSyncTable := SyncRecord.SyncTable.ParentSyncTableByName[aTableName];
  { Se há uma tabela pai... }
  if Assigned(ParentSyncTable) then
	begin
    { Obtendo o registro na tabela pai que corresponde à chave especificada}
    ParentSyncRecord := ParentSyncTable.SyncRecordByPrimaryKey[StoredValue];
    { Se há o registro identificado pela chave e se este registro tiver sido
    inserido devemos formatar o retorno da função }
    if Assigned(ParentSyncRecord) and (ParentSyncRecord.ActionPerformed = apInsert) then
      Result := TFSYGlobals.MySQLFormat('@%S_KEY_%U',[aTableName,StoredValue]);
  end;
end;

end.
