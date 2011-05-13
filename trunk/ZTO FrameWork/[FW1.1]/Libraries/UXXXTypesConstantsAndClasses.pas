unit UXXXTypesConstantsAndClasses;

interface

uses
  	SysUtils, Classes, DB, ComCtrls, Windows, Forms, StdCtrls,

    ZConnection, ZSqlProcessor,

    UBalloonToolTip, UObjectFile;

type
    TMySQLBackupDataBaseNotificationMoment = (nmStart,
    nmBeforeExtractStoredRoutines,nmBeginExtractStoredRoutine,nmEndExtractStoredRoutine,nmAfterExtractStoredRoutines,
    nmBeforeExtractViews,nmBeginExtractView,nmEndExtractView,nmAfterExtractViews,
    nmBeforeExtractTriggers,nmBeginExtractTrigger,nmEndExtractTrigger,nmAfterExtractTriggers,
    nmBeforeExtractTables,nmBeginExtractTable, nmEndExtractTable, nmAfterExtractTables,
    nmBeforeExtractRecords,nmBeginExtractRecord, nmEndExtractRecord, nmAfterExtractRecords,
    nmFinish);

    TMySQLBackupDataBaseNotification = procedure(aMoment: TMySQLBackupDataBaseNotificationMoment; StrParam0, StrParam1: AnsiString; IntParam0, IntParam1: Cardinal) of object;

    TMySQLBackupDataBaseParameters = record
        DataBaseName: AnsiString;
//        aProgressBar: TProgressBar;
//        aLabelPercentDone: TLabel;
        OnNotification: TMySQLBackupDataBaseNotification;
        { SE PRECISAR INCLUA AQUI UM CALLBACK IDENTICO AO EVENTO }
    end;

    TComparisonOperator = (coNone,coEqual,coLessThan,coLessOrEqualThan,coMoreOrEqualThan,coMoreThan,coLike);

    TOnGetChecksum = procedure (aTableName: AnsiString; aTableNo, aTableCount: Word; aTableChecksum: AnsiString; const aIgnored: Boolean) of object;

    TZlibNotificationType = (zlntBeforeProcess,zlntAfterProcess,zlntInsideProcess);
    TZLibOperation = (zloCompress,zloDecompress);

    TZlibNotification = procedure (aNotificatioType: TZlibNotificationType; aOperation: TZLibOperation; aInputFile, aOutputFile: TFileName) of object;

    TDBAction = (dbaBeforeInsert, dbaBeforeEdit);

    TSavedText = class(TCollectionItem)
    private
        FTextTitle: AnsiString;
        FText: AnsiString;
    published
    	property TextTitle: AnsiString read FTextTitle write FTextTitle;
		property Text: AnsiString read FText write FText;
    end;

    TSavedTexts = class(TCollection)
	private
	    function GetSavedText(i: Word): TSavedText;
    public
        function Add: TSavedText;
        function IndexOfTitle(aTextTile: AnsiString): SmallInt;
		property SavedText[i: Word]: TSavedText read GetSavedText; default;
    end;

	TFileOfTexts = class(TObjectFile)
    private
    	FSavedTexts: TSavedTexts;
    public
    	constructor Create(AOwner: TComponent); override;
        destructor Destroy; override;
        procedure Clear; override;
    published
        property SavedTexts: TSavedTexts read FSavedTexts write FSavedTexts;
    end;

    TAllowedChars = set of AnsiChar;
    
    TRecordInformation = record
    	CreatorId: Cardinal;
        CreatorFullName: AnsiString;
        CreationDateAndTime: TDateTime;
        LastModifierId: Cardinal;
        LastModifierFullName: AnsiString;
        LastModificationDateAndTime: TDateTime;
        RecordStatus: AnsiString;
    end;

	TMultiTypedResult = record
        DataType: TFieldType; 
        IsNull: Boolean;
    	AsByte: Byte;
    	AsWord: Word;
        AsDWord: Cardinal;
        AsShortInt: ShortInt;
        AsSmallInt: SmallInt;
        AsInteger: Integer;
        AsInt64: Int64;
        AsAnsiChar: AnsiChar;
        AsAnsiString: AnsiString;
        AsSingle: Single;
        AsDouble: Double;
        AsCurrency: Currency;
        AsDateTime: TDateTime;
    end;

	TMySQLIndexKind = (mikIndex, mikPrimary, mikUnique, mikFullText, mikSpatial);
    
	TFileSizeUnit = (fsuBytes, fsuKBytes, fsuMBytes, fsuGBytes, fsuTBytes);

    EPermissionException = class(Exception);

	TBytesArray = Array of Byte;
    
	TEntityType = (etTable,etAction);

    TPermission = (pRead,pModify,pDelete,pInsert,pFull,pNone);

	THashAlgorithm = (haIgnore, haSha512, haSha384, haSha256, haSha1, haRipemd160, haRipemd128, haMd5, haMd4, haHaval, haTiger);
    THashAlgorithms = set of THashAlgorithm;

    ///<author>Carlos Feitoza Filho</author>
    ///    O tipo enumerado e o conjunto a seguir são usados pelo form de
    ///    configurações. Cada constante em "TPageToShow" indica uma
    ///    página a ser exibida no form. As constantes nomeadas "ctsCustom"
    ///    servem para indicar páginas definidas em uma instância herdada do
    ///    form de configurações. Cabe portanto ao desenvolvedor manter a
    ///    correspondência e controle entre as páginas e suas constantes
    TPageToShow = (ptsNone, ptsDatabase, ptsLogin, ptsOtherOptions, ptsCustom0, ptsCustom1, ptsCustom2, ptsCustom3, ptsCustom4, ptsCustom5, ptsCustom6, ptsCustom7, ptsCustom8, ptsCustom9, ptsAll);
	TPagesToShow = set of TPageToShow;

	///<author>Carlos Feitoza Filho</author>
    ///    Indica a posição da imagem de fundo da aplicação
	TBackgroundImagePosition = (bipTopLeft,bipTopRight,bipBottomLeft,bipBottomRight,bipCentered);

	///<author>Carlos Feitoza Filho</author>
    ///    Indica o modificador da imagem de fundo da aplicação quando esta está
    ///    posicionada no centro da mesma (bipCentered)
	TBackgroundImageModifier = (bimNormal,bimZoomed,bimTiled);

	///<author>Carlos Feitoza Filho</author>
    ///    Argumento  de tipo correto,  porém sem  as informações  requeridas
    ///    para o funcionamento correto do método. Fisicamente correto, mas
    ///    logicamente errado
	EInvalidArgumentData = class(Exception);

	///<author>Carlos Feitoza Filho</author>
    ///    A função não lançou nenhuma exceção, mas internamente uma condição de
    ///    erro foi verificada e por isso o retorno da função não é válido
	EUnexpectedInformation = class(Exception);

	///<author>Carlos Feitoza Filho</author>
    ///    Ao validar um registro se algo não for coerente com as regras
    ///    especificadas, esta exceção deve ser lançada
//    EInvalidRecordValue = class(Exception)
//    private
//    	FFieldError: TField;
//    public
//        constructor CreateFmt(const aFieldError: TField; const aMsg: AnsiString; const aArgs: array of const);
//        constructor Create(const aFieldError: TField; const aMsg: AnsiString);
//    	property FieldError: TField read FFieldError;
//    end;

	///<author>Carlos Feitoza Filho</author>
    ///    Indica a ação que foi tentada quando ocorreu o erro de banco de dados
	TActionTried = (atInsert, atUpdate, atDelete);

	///<author>Carlos Feitoza Filho</author>
    ///    Esta enumeração serve para identificar cada um dos botões de banco de
    ///    dados
	TDBButton = (dbbFirst,dbbPrevious,dbbNext,dbbLast,dbbInsert,dbbDelete,dbbEdit,dbbPost,dbbCancel,dbbRefresh);

	///<author>Carlos Feitoza Filho</author>
    ///    Esta enumeração serve para identificar cada um dos botões de mudança
    ///    de página em um DBgrid. Não há uma função específica para uso desta
    ///    enumerção como é o caso de TDBButton, ela pode ser usada para criação
    ///    de funções de mudança de página em cada módulo individualmente
	TDBPageButton = (dpbFirst,dpbPrevious,dpbNext,dpbLast,dpbCustom);

	///<author>Carlos Feitoza Filho</author>
    ///    Esta classe representa um único erro de banco de dados e é usada
    ///    dentro da coleção mais abaixo (TDBActionErrors)
	TDBActionError = class(TCollectionItem)
    private
    	FActionDateTime: TDateTime;
        FActionUserName: AnsiString;
        FActionUserId: Word;
        FActionTried: TActionTried;
        FDataBaseError: AnsiString;
    published
    	property ActionDateTime: TDateTime read FActionDateTime write FActionDateTime;
		property ActionUserName: AnsiString read FActionUserName write FActionUserName;
        property ActionUserId: Word read FActionUserId write FActionUserId;
        property ActionTried: TActionTried read FActionTried write FActionTried; 
        property DataBaseError: AnsiString read FDataBaseError write FDataBaseError;
    end;

	TDBActionErrorClass = class of TDBActionError;

    TDBActionErrors = class(TCollection)
	private
	    function GetDBActionError(i: Cardinal): TDBActionError;
    public
        constructor Create(ItemClass: TDBActionErrorClass);
        function Add: TDBActionError;
		property DBActionError[i: Cardinal]: TDBActionError read GetDBActionError; default;
    end;

	///<author>Carlos Feitoza Filho</author>
	TFileOfDBActionErrors = class(TObjectFile)
    private
    	FDBActionErrors: TDBActionErrors;
    public
    	constructor Create(AOwner: TComponent); override;
        destructor Destroy; override;
        procedure Clear; override;
    published
        property DBActionErrors: TDBActionErrors read FDBActionErrors write FDBActionErrors;
    end;

	///<author>Carlos Feitoza Filho</author>
	TAuthenticatedUser = record
        Id: Cardinal;
		RealName: AnsiString;
        Login: AnsiString;
        Password: AnsiString;
    end;

	TSetOfByte = set of Byte;

	///<author>Carlos Feitoza Filho</author>
    ///    Esta classe representa uma única conexão com um banco de dados. Em um
    ///    DataModule com muitas conexões distintas é possível acessá-las dentro
    ///    de uma coleção composta por este item (TDBConnections)
    TConnection = class(TCollectionItem)
    private
    	FConnection: TZConnection;
    public
    	property Connection: TZConnection read FConnection write FConnection;
    end;

    TZConnectionClass = class of TConnection;

    TZConnections = class(TCollection)
	private
	    function GetZConnectionByIndex(i: Byte): TConnection;
        function GetZConnectionByName(s: AnsiString): TConnection;
    public
        constructor Create(ItemClass: TZConnectionClass);
        function Add: TConnection;
		property ByIndex[i: Byte]: TConnection read GetZConnectionByIndex; default;
        property ByName[s: AnsiString]: TConnection read GetZConnectionByName;
    end;

    TFileInformation = class
    private
    	FFileInfo: TVSFixedFileInfo;
    	FFileName: TFileName;
	    procedure SetFileName(const Value: TFileName);
      function GetFileInfo(const aInfo: AnsiString): TMultiTypedResult;
    public
    	class function GetInfo(const aFileName: TFileName; const aInfo: AnsiString): TMultiTypedResult;
      class procedure SetVersion(const aFileName: TFileName; const aMajor, aMinor, aRelease, aBuild: Word);
    	property FileName: TFileName read FFileName write SetFileName;
      property FileInfo[const Info: AnsiString]: TMultiTypedResult read GetFileInfo;
    end;

	TXXXConfigurations = class(TObjectFile)
	private
		{ Servem para configurar a imagem de fundo da aplicação }
		FBackGroundImage: TFileName;
		FBackgroundImagePosition: TBackgroundImagePosition;
		FBackgroundImageModifier: TBackgroundImageModifier;

		{ Usada para encriptação interna. Deve ser setada/modificada em uma
        classe filha desta e NÃO deve ser published de forma nenhuma }
		FMasterPassword: AnsiString;
        
		FCurrentDir: AnsiString;
		{ Usados pelo form de configuração de banco }
		FNeedsGeneralConfiguration: Boolean;
		FDBProtocol: AnsiString;
		FDBHostAddr: AnsiString;
		FDBPortNumb: Word;
		FDBDataBase: AnsiString;
		FDBUserName: AnsiString;
		FDBPassword: AnsiString;
        FDBIsoLevel: Byte;

    	{ Usado pelo form de login para preselecionar o último usuário  que  fez
        login corretamente }
        FLastAuthenticatedUser: Word;
		{ Guarda informações de login do usuário atualmente autenticado }
        FAuthenticatedUser: TAuthenticatedUser;

    	{ Usados pelo form de login.  Devem ser  setadas em uma classe filha que
        indicará seus valores de acordo com a aplicação }
        FUserTableTableName: AnsiString; { USUARIOS }
        FUserTableKeyFieldName: AnsiString;
        FUserTableRealNameFieldName: AnsiString;
        FUserTableUserNameFieldName: AnsiString;
        FUserTablePasswordFieldName: AnsiString;
        FUserTableEmailFieldName: AnsiString;
        FExpandedLoginDialog: Boolean;
        FPasswordCipherAlgorithm: THashAlgorithm;

        { Tabelas do módulo de administração do sistema }
        FEntitiesTableTableName: AnsiString; { ENTIDADESDOSISTEMA }
        FEntitiesTableKeyFieldName: AnsiString;
        FEntitiesTableNameFieldName: AnsiString;
        FEntitiesTableTypeFieldName: AnsiString;

        FGroupTableTableName: AnsiString; { GRUPOS }
        FGroupTableKeyFieldName: AnsiString;
        FGroupTableNameFieldName: AnsiString;
        FGroupTableDescriptionFieldName: AnsiString;

        { COMPARTILHADO ENTRE AS TABELAS DE PERMISSÃO }
        FPermissionTableReadFieldName: AnsiString;
        FPermissionTableInsertFieldName: AnsiString;
        FPermissionTableUpdateFieldName: AnsiString;
        FPermissionTableDeleteFieldName: AnsiString;

    	FUserPermissionTableTableName: AnsiString; { PERMISSOESDOSUSUARIOS }
        FUserPermissionTableKeyFieldName: AnsiString;
        FUserPermissionTableEntityFieldName: AnsiString;
        FUserPermissionTableUserFieldName: AnsiString;

    	FGroupPermissionTableTableName: AnsiString;  { PERMISSOESDOSGRUPOS }
        FGroupPermissionTableKeyFieldName: AnsiString;
        FGroupPermissionTableEntityFieldName: AnsiString;
        FGroupPermissionTableGroupFieldName: AnsiString;

        FUserGroupsTableTableName: AnsiString; { GRUPOSDOSUSUARIOS }
        FUserGroupsTableKeyFieldName: AnsiString;
        FUserGroupsTableUserFieldName: AnsiString;
        FUserGroupsTableGroupFieldName: AnsiString;

        FAdministrativeActionName: AnsiString;
        FAddEntityActionName: AnsiString;
        FAddEntityToUserOrGroupActionName: AnsiString;

        FUserCreatorFieldName: AnsiString;
        FCreationDateAndTimeFieldName: AnsiString;
        FUserModifierFieldName: AnsiString;
        FModificationDateAndTimeFieldName: AnsiString;
        FRecordStatusFieldName: AnsiString;

        { Outras Opções }
        FUseBalloonsOnValidationErrors: Boolean;
        FUseEnterAloneToSearch: Boolean;
        FConvertEnterToTabList: TStrings;

        { Opções de e-mail SMTP }

    	function GetConvertEnterToTabFor(ControlClassName: AnsiString): Boolean;
	protected
    	procedure Clear; override;
	public
        constructor Create(AOwner: TComponent); override;
        destructor Destroy; override;

        property CurrentDir: AnsiString read FCurrentDir;
		property MasterPassword: AnsiString read FMasterPassword write FMasterPassword;
		property AuthenticatedUser: TAuthenticatedUser read FAuthenticatedUser write FAuthenticatedUser;
        property ConvertEnterToTabFor[ControlClassName: AnsiString]: Boolean read GetConvertEnterToTabFor;
	published
		property BackGroundImage: TFileName read FBackGroundImage write FBackGroundImage;
		property BackgroundImagePosition: TBackgroundImagePosition read FBackgroundImagePosition write FBackgroundImagePosition;
		property BackgroundImageModifier: TBackgroundImageModifier read FBackgroundImageModifier write FBackgroundImageModifier;
		property DBPassword: AnsiString read FDBPassword write FDBPassword;
		property DBUserName: AnsiString read FDBUserName write FDBUserName;
		property DBProtocol: AnsiString read FDBProtocol write FDBProtocol;
		property DBDataBase: AnsiString read FDBDataBase write FDBDataBase;
		property DBHostAddr: AnsiString read FDBHostAddr write FDBHostAddr;
		property DBPortNumb: Word read FDBPortNumb write FDBPortNumb;
		property DBIsoLevel: Byte read FDBIsoLevel write FDBIsoLevel;

        property UserTableTableName: AnsiString read FUserTableTableName write FUserTableTableName;
		property UserTableKeyFieldName: AnsiString read FUserTableKeyFieldName write FUserTableKeyFieldName;
		property UserTableRealNameFieldName: AnsiString read FUserTableRealNameFieldName write FUserTableRealNameFieldName;
		property UserTableUserNameFieldName: AnsiString read FUserTableUserNameFieldName write FUserTableUserNameFieldName;
		property UserTablePasswordFieldName: AnsiString read FUserTablePasswordFieldName write FUserTablePasswordFieldName;
        property UserTableEmailFieldName: AnsiString read FUserTableEmailFieldName write FUserTableEmailFieldName;

        property GroupTableTableName: AnsiString read FGroupTableTableName write FGroupTableTableName; { GRUPOS }
        property GroupTableKeyFieldName: AnsiString read FGroupTableKeyFieldName write FGroupTableKeyFieldName;
        property GroupTableNameFieldName: AnsiString read FGroupTableNameFieldName write FGroupTableNameFieldName;
        property GroupTableDescriptionFieldName: AnsiString read FGroupTableDescriptionFieldName write FGroupTableDescriptionFieldName;

        property EntitiesTableTableName: AnsiString read FEntitiesTableTableName write FEntitiesTableTableName; { ENTIDADESDOSISTEMA }
        property EntitiesTableKeyFieldName: AnsiString read FEntitiesTableKeyFieldName write FEntitiesTableKeyFieldName;
        property EntitiesTableNameFieldName: AnsiString read FEntitiesTableNameFieldName write FEntitiesTableNameFieldName;
        property EntitiesTableTypeFieldName: AnsiString read FEntitiesTableTypeFieldName write FEntitiesTableTypeFieldName;

        property PermissionTableReadFieldName: AnsiString read FPermissionTableReadFieldName write FPermissionTableReadFieldName;
        property PermissionTableInsertFieldName: AnsiString read FPermissionTableInsertFieldName write FPermissionTableInsertFieldName;
        property PermissionTableUpdateFieldName: AnsiString read FPermissionTableUpdateFieldName write FPermissionTableUpdateFieldName;
        property PermissionTableDeleteFieldName: AnsiString read FPermissionTableDeleteFieldName write FPermissionTableDeleteFieldName;

     	property UserPermissionTableTableName: AnsiString read FUserPermissionTableTableName write FUserPermissionTableTableName; { PERMISSOESDOSUSUARIOS }
        property UserPermissionTableKeyFieldName: AnsiString read FUserPermissionTableKeyFieldName write FUserPermissionTableKeyFieldName;
        property UserPermissionTableEntityFieldName: AnsiString read FUserPermissionTableEntityFieldName write FUserPermissionTableEntityFieldName;
        property UserPermissionTableUserFieldName: AnsiString read FUserPermissionTableUserFieldName write FUserPermissionTableUserFieldName;

    	property GroupPermissionTableTableName: AnsiString read FGroupPermissionTableTableName write FGroupPermissionTableTableName;  { PERMISSOESDOSGRUPOS }
        property GroupPermissionTableKeyFieldName: AnsiString read FGroupPermissionTableKeyFieldName write FGroupPermissionTableKeyFieldName;
        property GroupPermissionTableEntityFieldName: AnsiString read FGroupPermissionTableEntityFieldName write FGroupPermissionTableEntityFieldName;
        property GroupPermissionTableGroupFieldName: AnsiString read FGroupPermissionTableGroupFieldName write FGroupPermissionTableGroupFieldName;

        property UserGroupsTableTableName: AnsiString read FUserGroupsTableTableName write FUserGroupsTableTableName; { GRUPOSDOSUSUARIOS }
        property UserGroupsTableKeyFieldName: AnsiString read FUserGroupsTableKeyFieldName write FUserGroupsTableKeyFieldName;
        property UserGroupsTableUserFieldName: AnsiString read FUserGroupsTableUserFieldName write FUserGroupsTableUserFieldName;
        property UserGroupsTableGroupFieldName: AnsiString read FUserGroupsTableGroupFieldName write FUserGroupsTableGroupFieldName;

        property AdministrativeActionName: AnsiString read FAdministrativeActionName write FAdministrativeActionName;
        property AddEntityActionName: AnsiString read FAddEntityActionName write FAddEntityActionName;
        property AddEntityToUserOrGroupActionName: AnsiString read FAddEntityToUserOrGroupActionName write FAddEntityToUserOrGroupActionName;

        property UserCreatorFieldName: AnsiString read FUserCreatorFieldName write FUserCreatorFieldName;
        property CreationDateAndTimeFieldName: AnsiString read FCreationDateAndTimeFieldName write FCreationDateAndTimeFieldName;
        property UserModifierFieldName: AnsiString read FUserModifierFieldName write FUserModifierFieldName;
        property ModificationDateAndTimeFieldName: AnsiString read FModificationDateAndTimeFieldName write FModificationDateAndTimeFieldName;
        property RecordStatusFieldName: AnsiString read FRecordStatusFieldName write FRecordStatusFieldName;

        property ExpandedLoginDialog: Boolean read FExpandedLoginDialog write FExpandedLoginDialog;
        property PasswordCipherAlgorithm: THashAlgorithm read FPasswordCipherAlgorithm write FPasswordCipherAlgorithm;
		property LastAuthenticatedUser: Word read FLastAuthenticatedUser write FLastAuthenticatedUser;
		property NeedsGeneralConfiguration: Boolean read FNeedsGeneralConfiguration write FNeedsGeneralConfiguration;
        property ConvertEnterToTabList: TStrings read FConvertEnterToTabList write FConvertEnterToTabList;
        property UseBalloonsOnValidationErrors: Boolean read FUseBalloonsOnValidationErrors write FUseBalloonsOnValidationErrors;
        property UseEnterAloneToSearch: Boolean read FUseEnterAloneToSearch write FUseEnterAloneToSearch;
    end;

    TProcessorEvents = class
    private
    	FProgressBarCurrent: TProgressBar;
        FLabelCurrentValue: TLabel;
        FLabelCurrentDescription: TLabel;
    public
    	constructor Create(aProgressBarCurrent: TProgressBar; aLabelCurrentValue, aLabelCurrentDescription: TLabel);
    	procedure DoAfterExecute(Processor: TZSQLProcessor; StatementIndex: Integer);
    	procedure DoBeforeExecute(Processor: TZSQLProcessor; StatementIndex: Integer);
    end;

    TScriptPart = class (TCollectionItem)
    private
    	FDelimiter: AnsiString;
        FScript: AnsiString;
    public
    	constructor Create(Collection: TCollection); override;
    	property Delimiter: AnsiString read FDelimiter write FDelimiter;
        property Script: AnsiString read FScript write FScript;
    end;

    TScriptParts = class (TCollection)
    private
	    function GetScriptPart(i: Cardinal): TScriptPart;
	    function GetLast: TScriptPart;
	public
	    function Add: TScriptPart;
		property Part[i: Cardinal]: TScriptPart read GetScriptPart; default;
        property Last: TScriptPart read GetLast;
    end;

    TExecuteSQLScriptEvent = (esseBeforeExecuteScript,esseBeforeExecuteScriptPart,esseAfterExecuteScriptPart,esseAfterExecuteScript);
    TExecuteSQLScriptCallBack = procedure (const aExecuteSQLScriptEvent: TExecuteSQLScriptEvent; const aScriptParts: TScriptParts; const aProcessor: TZSQLProcessor) of object;

    TSplitSQLScriptEvent = (ssseBeforeParse,ssseAfterParse,ssseBeforeSplitOperation,ssseBeforeSplit,ssseAfterSplit,ssseAfterSplitOperation);
    TSplitSQLScriptCallBack = procedure (const aSplitSQLScriptEvent: TSplitSQLScriptEvent; const aScriptParts: TScriptParts; const aProcessor: TZSQLProcessor) of object;

//    TDefragDatabaseEvent = (ddeBeforeDefragOperation,ddeBeforeDefrag,ddeAfterDefrag,ddeAfterDefragOperation);
//	TDefragDatabaseCallBack = procedure (const aDefragDatabaseEvent: TDefragDatabaseEvent; const aDataSet: TDataSet);

const
	HASH_ALGORITHMS: array [Low(THashAlgorithm)..High(THashAlgorithm)] of AnsiString = ('NENHUM','SHA-512','SHA-384','SHA-256','SHA-1','RIPMED-160','RIPMED-128','MD5','MD4','HAVAL','TIGER');
    CURRENCY_STRINGS: array [1..5] of AnsiString = ('US$','€','R$','£','¥');
    MONTH_NAMES: array [1..12] of AnsiString = ('Janeiro','Fevereiro','Março','Abril','Maio','Junho','Julho','Agosto','Setembro','Outubro','Novembro','Dezembro');
    CR_LF = #$0D#$0A;

    { ATENÇÃO: NÃO MUDE OS VALORES DAS CONSTANTES ABAIXO. }
    DEFAULT_USERTABLE_TABLENAME = 'USUARIOS';
    DEFAULT_USERTABLE_KEYFIELDNAME = 'SM_USUARIOS_ID';
    DEFAULT_USERTABLE_REALNAMEFIELDNAME = 'VA_NOME';
    DEFAULT_USERTABLE_USERNAMEFIELDNAME = 'VA_LOGIN';
    DEFAULT_USERTABLE_PASSWORDFIELDNAME = 'TB_SENHA';
    DEFAULT_USERTABLE_EMAILFIELDNAME = 'VA_EMAIL';    

	DEFAULT_GROUPTABLE_TABLENAME = 'GRUPOS';
    DEFAULT_GROUPTABLE_KEYFIELDNAME = 'TI_GRUPOS_ID';
    DEFAULT_GROUPTABLE_NAMEFIELDNAME = 'VA_NOME';
    DEFAULT_GROUPTABLE_DESCRIPTIONFIELDNAME = 'VA_DESCRICAO';

    DEFAULT_ENTITIESTABLE_TABLENAME = 'ENTIDADESDOSISTEMA';
    DEFAULT_ENTITIESTABLE_KEYFIELDNAME = 'IN_ENTIDADESDOSISTEMA_ID';
    DEFAULT_ENTITIESTABLE_NAMEFIELDNAME = 'VA_NOME';
    DEFAULT_ENTITIESTABLE_TYPEFIELDNAME = 'TI_TIPO';

    DEFAULT_PERMISSIONTABLE_READFIELDNAME = 'TI_LER';
    DEFAULT_PERMISSIONTABLE_INSERTFIELDNAME = 'TI_INSERIR';
    DEFAULT_PERMISSIONTABLE_UPDATEFIELDNAME = 'TI_ALTERAR';
    DEFAULT_PERMISSIONTABLE_DELETEFIELDNAME = 'TI_EXCLUIR';

    DEFAULT_USERPERMISSIONTABLE_TABLENAME = 'PERMISSOESDOSUSUARIOS';
    DEFAULT_USERPERMISSIONTABLE_KEYFIELDNAME = 'IN_PERMISSOESDOSUSUARIOS_ID';
    DEFAULT_USERPERMISSIONTABLE_ENTITYFIELDNAME = 'IN_ENTIDADESDOSISTEMA_ID';
    DEFAULT_USERPERMISSIONTABLE_USERFIELDNAME = 'SM_USUARIOS_ID';

    DEFAULT_GROUPPERMISSIONTABLE_TABLENAME = 'PERMISSOESDOSGRUPOS';
    DEFAULT_GROUPPERMISSIONTABLE_KEYFIELDNAME = 'IN_PERMISSOESDOSGRUPOS_ID';
    DEFAULT_GROUPPERMISSIONTABLE_ENTITYFIELDNAME = 'IN_ENTIDADESDOSISTEMA_ID';
    DEFAULT_GROUPPERMISSIONTABLE_GROUPFIELDNAME = 'TI_GRUPOS_ID';

    DEFAULT_USERGROUPSTABLE_TABLENAME = 'GRUPOSDOSUSUARIOS';
    DEFAULT_USERGROUPSTABLE_KEYFIELDNAME = 'MI_GRUPOSDOSUSUARIOS_ID';
    DEFAULT_USERGROUPSTABLE_USERFIELDNAME = 'SM_USUARIOS_ID';
    DEFAULT_USERGROUPSTABLE_GROUPFIELDNAME = 'TI_GRUPOS_ID';

    DEFAULT_USERCREATORFIELDNAME = 'SM_USUARIOCRIADOR_ID';
    DEFAULT_CREATIONDATEANDTIMEFIELDNAME = 'DT_DATAEHORADACRIACAO';
    DEFAULT_USERMODIFIERFIELDNAME = 'SM_USUARIOMODIFICADOR_ID';
    DEFAULT_MODIFICATIONDATEANDTIMEFIELDNAME = 'DT_DATAEHORADAMODIFICACAO';
    DEFAULT_RECORDSTATUSFIELDNAME = 'EN_SITUACAO';

    { Mensagens de tela: devem ser feitos aliases para elas em cada form padrão como resourcestrings }
    PAGE_CHANGE_NOT_ALLOWED = 'Não é possível alternar entre páginas enquanto a'+
    ' operação de inserção/edição atual não tiver sido concluída ou cancelada.'+
    ' Termine a operação atual ou cancele-a para poder mudar de página';
    ACTION_NOT_ALLOWED_NOW = 'Ação não permitida no momento...';

resourcestring
    RS_INVALID_ARGUMENT_DATA = 'O parâmetro "%s" está correto quanto ao tipo, mas seus dados não são compatíveis com o método. %s';
	RS_EIAD = 'Erro nos dados de um dos parâmetros do método %s.' + CR_LF + CR_LF + '%s';
    RS_EXC = 'Erro desconhecido no método %s. É preciso uma depuração mais detalhada.' + CR_LF + CR_LF + '%s';
	RS_EAV = 'Houve um erro de violação de acesso no método %s.' + CR_LF + CR_LF + '%s';
    RS_UNEXPECTED_INFORMATION = 'O método obteve internamente uma informação inesperada. %s';
	RS_PAGECHANGENOTALLOWEDNOW = 'Não é possível alternar entre páginas enquanto a operação de inserção/edição atual não tiver sido concluída ou cancelada. Termine a operação atual ou cancele-a para poder mudar de página';
	RS_ACTIONNOTALLOWEDNOW = 'Ação não permitida no momento';

implementation

uses
  	Dialogs, UXXXDataModule;

type
  TVersionInformation = packed record { VS_VERSIONINFO }
    wLength     : Word;
    wValueLength: Word;
    wType       : Word;
    szKey       : array [0..15] of WChar;
    Padding1    : Word;
    Value       : VS_FIXEDFILEINFO;
    Padding2    : Word;
    Children    : Word;
  end;
  PVersionInformation = ^TVersionInformation;

const
    DBACTION_ERROR_FILE = 'DBActionErrors.daef';
    DEFAULT_MASTER_PASSWORD = 'wildstarcorporationlimited2007!';

	DEFAULT_LAST_AUTHENTICATED_USER = 0;
    DEFAULT_SHOW_DB_CONFIGFORM = True;
	DEFAULT_DB_PASSWORD = '';
	DEFAULT_DB_USERNAME = '';
	DEFAULT_DB_PROTOCOL = 'mysql-5';
	DEFAULT_DB_DATABASE = '';
	DEFAULT_DB_HOSTADDR = '';
	DEFAULT_DB_PORTNUMB = 0;
    DEFAULT_DB_ISOLEVEL = 2; // tiReadCommitted

{ TDBActionErrors }

function TDBActionErrors.Add: TDBActionError;
begin
	Result := TDBActionError(inherited Add);
end;

constructor TDBActionErrors.Create(ItemClass: TDBActionErrorClass);
begin
	inherited Create(ItemClass);
end;

function TDBActionErrors.GetDBActionError(i: Cardinal): TDBActionError;
begin
	Result := TDBActionError(inherited Items[i]);
end;

{ TFileOfDBActionErrors }

procedure TFileOfDBActionErrors.Clear;
begin
  	inherited;
  	FDBActionErrors.Clear;
end;

constructor TFileOfDBActionErrors.Create(AOwner: TComponent);
begin
  	inherited;
    FDBActionErrors := TDBActionErrors.Create(TDBActionError);
    LoadFromBinaryFile(ExtractFilePath(ParamStr(0)) + DBACTION_ERROR_FILE);
end;

destructor TFileOfDBActionErrors.Destroy;
begin
	SaveToBinaryFile(ExtractFilePath(ParamStr(0)) + DBACTION_ERROR_FILE);
    FDBActionErrors.Free;
  	inherited;
end;

{ EInvalidRecordValue }
//constructor EInvalidRecordValue.CreateFmt(const aFieldError: TField; const aMsg: AnsiString; const aArgs: array of const);
//begin
//	inherited CreateFmt(aMsg,aArgs);
//    FFieldError := aFieldError;
//end;
//
//constructor EInvalidRecordValue.Create(const aFieldError: TField; const aMsg: AnsiString);
//begin
//	inherited Create(aMsg);
//    FFieldError := aFieldError;
//end;

{ TZConnections }

function TZConnections.Add: TConnection;
begin
	Result := TConnection(inherited Add);
end;

constructor TZConnections.Create(ItemClass: TZConnectionClass);
begin
	inherited Create(ItemClass);
end;

function TZConnections.GetZConnectionByIndex(i: Byte): TConnection;
begin
	Result := TConnection(inherited Items[i]);
end;

function TZConnections.GetZConnectionByName(s: AnsiString): TConnection;
var
	i: Byte;
begin
	Result := nil;
  if Count > 0 then
    for i := 0 to Pred(Count) do
      if AnsiString((TConnection(inherited Items[i]).Connection.Name)) = s then
      begin
        Result := TConnection(inherited Items[i]);
        Break;
      end;
end;

{ TFileInformation }

{ TODO -oCarlos Feitoza : Esta função está incompleta. Ela só está retornando as
informações de versão. Por favor complete-a! }
function TFileInformation.GetFileInfo(const aInfo: AnsiString): TMultiTypedResult;
begin
    ZeroMemory(@Result,SizeOf(TMultiTypedResult));
    with Result do
    begin
        if aInfo = 'MAJORVERSION' then
        begin
    	    AsWord := HiWord(FFileInfo.dwFileVersionMS);
	        AsAnsiString := AnsiString(IntToStr(AsWord));
        end
        else if aInfo = 'MINORVERSION' then
        begin
    	    AsWord := LoWord(FFileInfo.dwFileVersionMS);
	        AsAnsiString := AnsiString(IntToStr(AsWord));
        end
        else if aInfo = 'RELEASE' then
        begin
    	    AsWord := HiWord(FFileInfo.dwFileVersionLS);
	        AsAnsiString := AnsiString(IntToStr(AsWord));
        end
        else if aInfo = 'BUILD' then
        begin
    	    AsWord := LoWord(FFileInfo.dwFileVersionLS);
	        AsAnsiString := AnsiString(IntToStr(AsWord));
        end
        else if aInfo = 'FULLVERSION' then
        begin
	        AsAnsiString := GetFileInfo('MAJORVERSION').AsAnsiString + '.' + GetFileInfo('MINORVERSION').AsAnsiString + '.' + GetFileInfo('RELEASE').AsAnsiString + '.' + GetFileInfo('BUILD').AsAnsiString;
          AsInt64 := StrToInt64(String(GetFileInfo('MAJORVERSION').AsAnsiString) + String(GetFileInfo('MINORVERSION').AsAnsiString) + String(GetFileInfo('RELEASE').AsAnsiString) + String(GetFileInfo('BUILD').AsAnsiString));
        end
    end;
end;

class function TFileInformation.GetInfo(const aFileName: TFileName; const aInfo: AnsiString): TMultiTypedResult;
begin
  with TFileInformation.Create do
    try
      FileName := aFileName;
      Result := FileInfo[aInfo];
    finally
      Free;
    end;
end;

procedure TFileInformation.SetFileName(const Value: TFileName);
var
  	InternalFileName: array [0..255] of Char;
  	VersionInfoSize, Dummy: Cardinal;
  	VersionInfo: PChar;
  	FixedInfoData: PVSFixedFileInfo;
  	QueryLen: Cardinal;
begin
	FFileName := Value;

	ZeroMemory(@InternalFileName,256);
    ZeroMemory(@FFileInfo,SizeOf(TVSFixedFileInfo));
	StrPCopy(InternalFileName,FFileName);

 	VersionInfoSize := GetFileVersionInfoSize(InternalFileName, Dummy);

  	if VersionInfoSize > 0 then
    begin
    	GetMem(VersionInfo, VersionInfoSize);
    	GetFileVersionInfo(InternalFileName, Dummy, VersionInfoSize, VersionInfo);

    	VerQueryValue(VersionInfo, '\', Pointer(FixedInfoData), QueryLen);

      FFileInfo.dwSignature := FixedInfoData^.dwSignature;
    	FFileInfo.dwStrucVersion := FixedInfoData^.dwStrucVersion;
    	FFileInfo.dwFileVersionMS := FixedInfoData^.dwFileVersionMS;
    	FFileInfo.dwFileVersionLS := FixedInfoData^.dwFileVersionLS;
    	FFileInfo.dwProductVersionMS := FixedInfoData^.dwProductVersionMS;
    	FFileInfo.dwProductVersionLS := FixedInfoData^.dwProductVersionLS;
    	FFileInfo.dwFileFlagsMask := FixedInfoData^.dwFileFlagsMask;
    	FFileInfo.dwFileFlags := FixedInfoData^.dwFileFlags;
    	FFileInfo.dwFileOS := FixedInfoData^.dwFileOS;
    	FFileInfo.dwFileType := FixedInfoData^.dwFileType;
    	FFileInfo.dwFileSubtype := FixedInfoData^.dwFileSubtype;
    	FFileInfo.dwFileDateMS := FixedInfoData^.dwFileDateMS;
    	FFileInfo.dwFileDateLS := FixedInfoData^.dwFileDateLS;
  	end;
end;

class procedure TFileInformation.SetVersion(const aFileName: TFileName;
                                            const aMajor
                                                , aMinor
                                                , aRelease
                                                , aBuild: Word);
var
  ModuleHandle: HMODULE;
  ResourceInformationHandle, ResourceHandle: HRSRC;
  ResourceSize: Cardinal;
  ReadOnlyResource, EditableResource: PVersionInformation;
  DiscardChanges: Boolean;
begin
  EditableResource := nil;
  ResourceSize := 0;

  if FileExists(aFileName) then
  begin
    { Carrega o módulo. Pode ser uma DLL ou executável }
    ModuleHandle := LoadLibrary(PChar(aFileName));

    if ModuleHandle <> 0 then
    begin
      try
        { Obtém o handle para o recurso de versão raiz, que contém mais
        informações do que necessitamos }
        ResourceInformationHandle := FindResource(ModuleHandle
                                                 ,MakeIntResource(VS_VERSION_INFO)
                                                 ,RT_VERSION);

        if ResourceInformationHandle <> 0 then
        begin
          { Obtém o handle para o recurso de versão específicamente. Com este
          handle podemos acessar apenas o que é necessário para nós. Aqui também
          obtemos o tamanho da informação de versão }
          ResourceHandle := LoadResource(ModuleHandle, ResourceInformationHandle);
          ResourceSize   := SizeofResource(ModuleHandle,ResourceInformationHandle);

          if ResourceHandle <> 0 then
          begin
            { Obtém um ponteiro para as informações de versão. Este ponteiro não
            pode ser alterado diretamente, por isso, mais adiante estamos
            copiando suas informações para um segundo ponteiro em outro local de
            memória. Este segundo ponteiro será usado para atualizar as
            informações de versão }
            ReadOnlyResource := LockResource(ResourceHandle);

            if Assigned(ReadOnlyResource) then
            begin
              GetMem(EditableResource,ResourceSize);
              Move(ReadOnlyResource^,EditableResource^,ResourceSize);
            end
            else
              raise Exception.CreateFmt('Não foi possível obter acesso exclusivo ao recurso de versão do módulo "%s"',[aFileName]);
          end
          else
            raise Exception.CreateFmt('Não foi possível carregar o recurso de versão contido no módulo "%s"',[aFileName]);
        end
        else
          raise Exception.CreateFmt('Não foi possível encontrar o recurso de versão no módulo "%s"',[aFileName]);
      finally
        FreeLibrary(ModuleHandle);
      end;

      try
        { Aqui realizamos as alterações necessárias }
        with EditableResource^.Value do
        begin
          dwFileVersionMS := MakeLong(aMinor,aMajor);
          dwFileVersionLS := MakeLong(aBuild,aRelease);
          dwProductVersionMS := dwFileVersionMS;
          dwProductVersionLS := dwFileVersionLS;
        end;

        { Iniciamos a alteração do recurso, obtendo um handle para o módulo em
        questão, mas desta vez, ao invés de usar LoadLibrary (somente leitura
        ) usaremos uma função especializada para edição de recursos:
        BeginUpdateResource }
        ModuleHandle := BeginUpdateResource(PChar(aFileName), False);

        if ModuleHandle <> 0 then
        begin
          DiscardChanges := True;

          try
            { Aqui estamos realizando a alteração do recurso de versão usando em
            seu lugar a nossa versão modificada do ponteiro (EditableResource).
            O resultado desta função é true, caso tudo tenha ocorrido bem e
            neste caso nós devemos preencher a variável DiscardChanges com o
            valor invertido (not) pois só devemos descartar alterações se esta
            função retornar false  }
            DiscardChanges := not UpdateResource(ModuleHandle
                                                ,RT_VERSION
                                                ,MakeIntResource(VS_VERSION_INFO)
                                                ,(SUBLANG_PORTUGUESE_BRAZILIAN shl 10) or LANG_PORTUGUESE
                                                ,EditableResource
                                                ,ResourceSize);


            if DiscardChanges then
              raise Exception.CreateFmt('Não foi possível adicionar o recurso de versão no arquivo "%s"',[aFileName]);

          finally
            { Tenta efetivar a alteração realizada. Isso só será feito se
            DiscardChanges for False }
            EndUpdateResource( ModuleHandle, DiscardChanges );
          end;
        end
        else
          raise Exception.CreateFmt('Não foi abrir o módulo "%s" para gravação',[aFileName]);
      finally
        FreeMem(EditableResource);
      end;
    end
    else
      raise Exception.CreateFmt('Não foi possível carregar o módulo "%s"',[aFileName]);
  end;
end;

//inclua isso!
//
//TVersionNumber = record
//   MSHigh : Word;
//   MSLow : Word;
//   LSHigh : Word;
//   LSLow : Word;
// end;
//
// TVersionDescription = record
//   CompanyName : AnsiString;
//   FileDescription : AnsiString;
//   InternalName : AnsiString;
//   LegalCopyright : AnsiString;
//   LegalTrademarks : AnsiString;
//   OriginalFileName : AnsiString;
//   ProductVersion : AnsiString;
//   Comments : AnsiString;
// end; 
//
//procedure FileVersionDigits(filename:AnsiString; var VersionNr:TVersionNumber);
//var sz,len:dword;
//    l:dword;
//    buf:pointer;
//    zKeyPath : array[0..255] of Char;
//    VerInfo : PVerInfo;
//begin
//  sz:=GetFileVersionInfoSize(pchar(filename),l);
//  getmem(buf,sz);
//  GetFileVersionInfo(pchar(filename), 0, Sz, Buf);
//  VersionNr.MSHigh:=0;
//  VersionNr.MSLow:=0;
//  VersionNr.LSHigh:=0;
//  VersionNr.LSLow:=0;
//  if (sz>0) and (VerQueryValue(Buf, StrPCopy(zKeyPath, '\'),
//pointer(VerInfo), Len)) then
//  begin
//     VersionNr.MSHigh:=HIWORD(VerInfo.dwFileVersionMS);
//     VersionNr.MSLow:=LOWORD(VerInfo.dwFileVersionMS);
//     VersionNr.LSHigh:=HIWORD(VerInfo.dwFileVersionLS);
//     VersionNr.LSLow:=LOWORD(VerInfo.dwFileVersionLS);
//  end;
//  FreeMem(buf,sz);
//end;
//
//procedure FileVersionDescription(filename:AnsiString; var
//VersionD:TVersionDescription);
//function SwapLong(L : longint): longint;
//assembler;
//asm
//      rol eax, 16;
//end;
//var sz,l,len:dword;
//    buf,p:pointer;
//    zKeyPath : array[0..255] of Char;
//    language:AnsiString;
//begin
//  sz:=GetFileVersionInfoSize(pchar(filename),l);
//  getmem(buf,sz);
//  GetFileVersionInfo(pchar(filename), 0, Sz, Buf);
//  if (sz>0) and (VerQueryValue(Buf,
//StrPCopy(zKeyPath,'\\VarFileInfo\\Translation'), P, Len)) then
//         Language := format('%.8x', [SwapLong(Longint(P^))]);
//  VersionD.FileDescription:='';
//  VersionD.CompanyName:='';
//  VersionD.InternalName:='';
//  VersionD.LegalCopyright:='';
//  VersionD.LegalTrademarks:='';
//  VersionD.OriginalFileName:='';
//  VersionD.ProductVersion:='';
//  VersionD.Comments:='';
//  if (sz>0) and (VerQueryValue(Buf, StrPCopy(zKeyPath,
//'\\StringFileInfo\\040904E4\\FileDescription'), P, Len)) then
//    VersionD.FileDescription:=(pchar(p));
//  if (sz>0) and (VerQueryValue(Buf, StrPCopy(zKeyPath,
//'\\StringFileInfo\\\040904E4\\CompanyName'), P, Len)) then
//    VersionD.CompanyName:=(pchar(p));
//  if (sz>0) and (VerQueryValue(Buf, StrPCopy(zKeyPath,
//'\\StringFileInfo\\\040904E4\\InternalName'), P, Len)) then
//    VersionD.InternalName:=(pchar(p));
//  if (sz>0) and (VerQueryValue(Buf, StrPCopy(zKeyPath,
//'\\StringFileInfo\\040904E4\\LegalCopyright'), P, Len)) then
//    VersionD.LegalCopyright:=(pchar(p));
//  if (sz>0) and (VerQueryValue(Buf, StrPCopy(zKeyPath,
//'\\StringFileInfo\\040904E4\\LegalTrademarks'), P, Len)) then
//    VersionD.LegalTrademarks:=(pchar(p));
//  if (sz>0) and (VerQueryValue(Buf, StrPCopy(zKeyPath,
//'\\StringFileInfo\\040904E4\\OriginalFileName'), P, Len)) then
//    VersionD.OriginalFileName:=(pchar(p));
//  if (sz>0) and (VerQueryValue(Buf, StrPCopy(zKeyPath,
//'\\StringFileInfo\\\040904E4\\ProductVersion'), P, Len)) then
//    VersionD.ProductVersion:=(pchar(p));
//  if (sz>0) and (VerQueryValue(Buf, StrPCopy(zKeyPath,
//'\\StringFileInfo\\040904E4\\Comments'), P, Len)) then
//    VersionD.Comments:=(pchar(p));
//end; 
{ TXXXConfigurations }

{ O método Clear limpa apenas as variáveis published }
procedure TXXXConfigurations.Clear;
begin
  	inherited;
    FNeedsGeneralConfiguration := False;
    FLastAuthenticatedUser := 0;

    FDBPassword := '';
    FDBUserName := '';
    FDBProtocol := '';
    FDBDataBase := '';
    FDBHostAddr := '';
    FDBPortNumb := 0;
    FDBIsoLevel := 2;
end;

{ Nada é carregado no create, classes filhas devem usar o método LoadFromFile }
constructor TXXXConfigurations.Create(AOwner: TComponent);
begin
	inherited;
    FMasterPassword := DEFAULT_MASTER_PASSWORD;

    FCurrentDir := AnsiString(GetCurrentDir);

    FNeedsGeneralConfiguration := DEFAULT_SHOW_DB_CONFIGFORM;
    FLastAuthenticatedUser := DEFAULT_LAST_AUTHENTICATED_USER;

    FDBPassword := DEFAULT_DB_PASSWORD;
    FDBUserName := DEFAULT_DB_USERNAME;
    FDBProtocol := DEFAULT_DB_PROTOCOL;
    FDBDataBase := DEFAULT_DB_DATABASE;
    FDBHostAddr := DEFAULT_DB_HOSTADDR;
    FDBPortNumb := DEFAULT_DB_PORTNUMB;
    FDBIsoLevel := DEFAULT_DB_ISOLEVEL;

    FUserTableTableName := DEFAULT_USERTABLE_TABLENAME;
    FUserTableKeyFieldName := DEFAULT_USERTABLE_KEYFIELDNAME;
    FUserTableRealNameFieldName := DEFAULT_USERTABLE_REALNAMEFIELDNAME;
    FUserTableUserNameFieldName := DEFAULT_USERTABLE_USERNAMEFIELDNAME;
    FUserTablePasswordFieldName := DEFAULT_USERTABLE_PASSWORDFIELDNAME;
    FUserTableEmailFieldName := DEFAULT_USERTABLE_EMAILFIELDNAME;

    FGroupTableTableName := DEFAULT_GROUPTABLE_TABLENAME;
    FGroupTableKeyFieldName := DEFAULT_GROUPTABLE_KEYFIELDNAME;
    FGroupTableNameFieldName := DEFAULT_GROUPTABLE_NAMEFIELDNAME;
    FGroupTableDescriptionFieldName := DEFAULT_GROUPTABLE_DESCRIPTIONFIELDNAME;

    FEntitiesTableTableName := DEFAULT_ENTITIESTABLE_TABLENAME;
    FEntitiesTableKeyFieldName := DEFAULT_ENTITIESTABLE_KEYFIELDNAME;
    FEntitiesTableNameFieldName := DEFAULT_ENTITIESTABLE_NAMEFIELDNAME;
    FEntitiesTableTypeFieldName := DEFAULT_ENTITIESTABLE_TYPEFIELDNAME;

	FPermissionTableReadFieldName := DEFAULT_PERMISSIONTABLE_READFIELDNAME;
	FPermissionTableInsertFieldName := DEFAULT_PERMISSIONTABLE_INSERTFIELDNAME;
	FPermissionTableUpdateFieldName := DEFAULT_PERMISSIONTABLE_UPDATEFIELDNAME;
	FPermissionTableDeleteFieldName := DEFAULT_PERMISSIONTABLE_DELETEFIELDNAME;

    FUserPermissionTableTableName := DEFAULT_USERPERMISSIONTABLE_TABLENAME;
    FUserPermissionTableKeyFieldName := DEFAULT_USERPERMISSIONTABLE_KEYFIELDNAME;
    FUserPermissionTableEntityFieldName := DEFAULT_USERPERMISSIONTABLE_ENTITYFIELDNAME;
    FUserPermissionTableUserFieldName := DEFAULT_USERPERMISSIONTABLE_USERFIELDNAME;

    FGroupPermissionTableTableName := DEFAULT_GROUPPERMISSIONTABLE_TABLENAME;
    FGroupPermissionTableKeyFieldName := DEFAULT_GROUPPERMISSIONTABLE_KEYFIELDNAME;
    FGroupPermissionTableEntityFieldName := DEFAULT_GROUPPERMISSIONTABLE_ENTITYFIELDNAME;
    FGroupPermissionTableGroupFieldName := DEFAULT_GROUPPERMISSIONTABLE_GROUPFIELDNAME;

    FUserGroupsTableTableName := DEFAULT_USERGROUPSTABLE_TABLENAME;
    FUserGroupsTableKeyFieldName := DEFAULT_USERGROUPSTABLE_KEYFIELDNAME;
    FUserGroupsTableUserFieldName := DEFAULT_USERGROUPSTABLE_USERFIELDNAME;
    FUserGroupsTableGroupFieldName := DEFAULT_USERGROUPSTABLE_GROUPFIELDNAME;

    FAdministrativeActionName := 'NULL';
    FAddEntityActionName := 'NULL';
    FAddEntityToUserOrGroupActionName := 'NULL';

    FUserCreatorFieldName := DEFAULT_USERCREATORFIELDNAME;
    FCreationDateAndTimeFieldName := DEFAULT_CREATIONDATEANDTIMEFIELDNAME;
    FUserModifierFieldName := DEFAULT_USERMODIFIERFIELDNAME;
    FModificationDateAndTimeFieldName := DEFAULT_MODIFICATIONDATEANDTIMEFIELDNAME;
    FRecordStatusFieldName := DEFAULT_RECORDSTATUSFIELDNAME;
    
    FPasswordCipherAlgorithm := haMd5;
    FExpandedLoginDialog := True;

    FUseBalloonsOnValidationErrors := True;
    FUseEnterAloneToSearch := True;

    FConvertEnterToTabList := TStringList.Create;
end;

destructor TXXXConfigurations.Destroy;
begin
    { Coisas a destruir }
    FConvertEnterToTabList.Free;
	inherited;
end;

function TXXXConfigurations.GetConvertEnterToTabFor(ControlClassName: AnsiString): Boolean;
begin
	Result := FConvertEnterToTabList.IndexOf(String(ControlClassName)) > -1;
end;

{ TProcessorEvents }

constructor TProcessorEvents.Create(aProgressBarCurrent: TProgressBar; aLabelCurrentValue, aLabelCurrentDescription: TLabel);
begin
	FProgressBarCurrent := aProgressBarCurrent;
    FLabelCurrentValue := aLabelCurrentValue;
    FLabelCurrentDescription := aLabelCurrentDescription;
end;

procedure TProcessorEvents.DoAfterExecute(Processor: TZSQLProcessor; StatementIndex: Integer);
begin
	if Assigned(FProgressBarCurrent) then
    begin
		FProgressBarCurrent.StepIt;
    	Application.ProcessMessages;
    end;
end;

procedure TProcessorEvents.DoBeforeExecute(Processor: TZSQLProcessor; StatementIndex: Integer);
begin
	if Assigned(FLabelCurrentDescription) and Assigned(FLabelCurrentValue) then
    begin
	    TXXXDataModule.SetLabelDescriptionValue(FLabelCurrentDescription
                                               ,FLabelCurrentValue
                                               ,AnsiString(IntToStr(Succ(StatementIndex)) + ' / ' + IntToStr(Processor.StatementCount)));
    	Application.ProcessMessages;
    end;
end;

{ TScriptPart }

constructor TScriptPart.Create(Collection: TCollection);
begin
  	inherited;
    FScript := '';
    FDelimiter := ';';
end;

{ TScriptParts }

function TScriptParts.Add: TScriptPart;
begin
	Result := TScriptPart(inherited Add);
end;

function TScriptParts.GetLast: TScriptPart;
begin
	if Count = 0 then
    	Result := nil
    else
    	Result := GetScriptPart(Pred(Count));
end;

function TScriptParts.GetScriptPart(i: Cardinal): TScriptPart;
begin
	Result := TScriptPart(inherited Items[i]);
end;

{ TFileOfTexts }

procedure TFileOfTexts.Clear;
begin
    inherited;
    FSavedTexts.Clear;
end;

constructor TFileOfTexts.Create(AOwner: TComponent);
begin
    inherited;
    FSavedTexts := TSavedTexts.Create(TSavedText);
end;

destructor TFileOfTexts.Destroy;
begin
    FSavedTexts.Free;
    inherited;
end;

{ TSavedTexts }

function TSavedTexts.Add: TSavedText;
begin
	Result := TSavedText(inherited Add);
end;

function TSavedTexts.GetSavedText(i: Word): TSavedText;
begin
	Result := TSavedText(inherited Items[i]);
end;

function TSavedTexts.IndexOfTitle(aTextTile: AnsiString): SmallInt;
var
	i: Word;
begin
	Result := -1;
    if Count > 0 then
	    for i := 0 to Pred(Count) do
    	    if TSavedText(Items[i]).TextTitle = aTextTile then
            begin
            	Result := i;
                Break;
            end;
end;

end.


