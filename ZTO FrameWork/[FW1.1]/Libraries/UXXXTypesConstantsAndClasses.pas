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

    TMySQLBackupDataBaseNotification = procedure(aMoment: TMySQLBackupDataBaseNotificationMoment; StrParam0, StrParam1: String; IntParam0, IntParam1: Cardinal) of object;

    TMySQLBackupDataBaseParameters = record
        DataBaseName: String;
//        aProgressBar: TProgressBar;
//        aLabelPercentDone: TLabel;
        OnNotification: TMySQLBackupDataBaseNotification;
        { SE PRECISAR INCLUA AQUI UM CALLBACK IDENTICO AO EVENTO }
    end;

    TComparisonOperator = (coNone,coEqual,coLessThan,coLessOrEqualThan,coMoreOrEqualThan,coMoreThan,coLike);

    TOnGetChecksum = procedure (aTableName: String; aTableNo, aTableCount: Word; aTableChecksum: String; const aIgnored: Boolean) of object;

    TZlibNotificationType = (zlntBeforeProcess,zlntAfterProcess,zlntInsideProcess);
    TZLibOperation = (zloCompress,zloDecompress);

    TZlibNotification = procedure (aNotificatioType: TZlibNotificationType; aOperation: TZLibOperation; aInputFile, aOutputFile: TFileName) of object;

    TDBAction = (dbaBeforeInsert, dbaBeforeEdit);

    TSavedText = class(TCollectionItem)
    private
        FTextTitle: String;
        FText: String;
    published
    	property TextTitle: String read FTextTitle write FTextTitle;
		property Text: String read FText write FText;
    end;

    TSavedTexts = class(TCollection)
	private
	    function GetSavedText(i: Word): TSavedText;
    public
        function Add: TSavedText;
        function IndexOfTitle(aTextTile: String): SmallInt;
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

    TAllowedChars = set of Char;
    
    TRecordInformation = record
    	CreatorId: Cardinal;
        CreatorFullName: String;
        CreationDateAndTime: TDateTime;
        LastModifierId: Cardinal;
        LastModifierFullName: String;
        LastModificationDateAndTime: TDateTime;
        RecordStatus: String;
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
        AsChar: Char;
        AsString: String;
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
    ///    O tipo enumerado e o conjunto a seguir s�o usados pelo form de
    ///    configura��es. Cada constante em "TPageToShow" indica uma
    ///    p�gina a ser exibida no form. As constantes nomeadas "ctsCustom"
    ///    servem para indicar p�ginas definidas em uma inst�ncia herdada do
    ///    form de configura��es. Cabe portanto ao desenvolvedor manter a
    ///    correspond�ncia e controle entre as p�ginas e suas constantes
    TPageToShow = (ptsNone, ptsDatabase, ptsLogin, ptsOtherOptions, ptsCustom0, ptsCustom1, ptsCustom2, ptsCustom3, ptsCustom4, ptsCustom5, ptsCustom6, ptsCustom7, ptsCustom8, ptsCustom9, ptsAll);
	TPagesToShow = set of TPageToShow;

	///<author>Carlos Feitoza Filho</author>
    ///    Indica a posi��o da imagem de fundo da aplica��o
	TBackgroundImagePosition = (bipTopLeft,bipTopRight,bipBottomLeft,bipBottomRight,bipCentered);

	///<author>Carlos Feitoza Filho</author>
    ///    Indica o modificador da imagem de fundo da aplica��o quando esta est�
    ///    posicionada no centro da mesma (bipCentered)
	TBackgroundImageModifier = (bimNormal,bimZoomed,bimTiled);

	///<author>Carlos Feitoza Filho</author>
    ///    Argumento  de tipo correto,  por�m sem  as informa��es  requeridas
    ///    para o funcionamento correto do m�todo. Fisicamente correto, mas
    ///    logicamente errado
	EInvalidArgumentData = class(Exception);

	///<author>Carlos Feitoza Filho</author>
    ///    A fun��o n�o lan�ou nenhuma exce��o, mas internamente uma condi��o de
    ///    erro foi verificada e por isso o retorno da fun��o n�o � v�lido
	EUnexpectedInformation = class(Exception);

	///<author>Carlos Feitoza Filho</author>
    ///    Ao validar um registro se algo n�o for coerente com as regras
    ///    especificadas, esta exce��o deve ser lan�ada
//    EInvalidRecordValue = class(Exception)
//    private
//    	FFieldError: TField;
//    public
//        constructor CreateFmt(const aFieldError: TField; const aMsg: String; const aArgs: array of const);
//        constructor Create(const aFieldError: TField; const aMsg: String);
//    	property FieldError: TField read FFieldError;
//    end;

	///<author>Carlos Feitoza Filho</author>
    ///    Indica a a��o que foi tentada quando ocorreu o erro de banco de dados
	TActionTried = (atInsert, atUpdate, atDelete);

	///<author>Carlos Feitoza Filho</author>
    ///    Esta enumera��o serve para identificar cada um dos bot�es de banco de
    ///    dados
	TDBButton = (dbbFirst,dbbPrevious,dbbNext,dbbLast,dbbInsert,dbbDelete,dbbEdit,dbbPost,dbbCancel,dbbRefresh);

	///<author>Carlos Feitoza Filho</author>
    ///    Esta enumera��o serve para identificar cada um dos bot�es de mudan�a
    ///    de p�gina em um DBgrid. N�o h� uma fun��o espec�fica para uso desta
    ///    enumer��o como � o caso de TDBButton, ela pode ser usada para cria��o
    ///    de fun��es de mudan�a de p�gina em cada m�dulo individualmente
	TDBPageButton = (dpbFirst,dpbPrevious,dpbNext,dpbLast,dpbCustom);

	///<author>Carlos Feitoza Filho</author>
    ///    Esta classe representa um �nico erro de banco de dados e � usada
    ///    dentro da cole��o mais abaixo (TDBActionErrors)
	TDBActionError = class(TCollectionItem)
    private
    	FActionDateTime: TDateTime;
        FActionUserName: String;
        FActionUserId: Word;
        FActionTried: TActionTried;
        FDataBaseError: String;
    published
    	property ActionDateTime: TDateTime read FActionDateTime write FActionDateTime;
		property ActionUserName: String read FActionUserName write FActionUserName;
        property ActionUserId: Word read FActionUserId write FActionUserId;
        property ActionTried: TActionTried read FActionTried write FActionTried; 
        property DataBaseError: String read FDataBaseError write FDataBaseError;
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
		RealName: String;
        Login: String;
        Password: String;
    end;

	TSetOfByte = set of Byte;

	///<author>Carlos Feitoza Filho</author>
    ///    Esta classe representa uma �nica conex�o com um banco de dados. Em um
    ///    DataModule com muitas conex�es distintas � poss�vel acess�-las dentro
    ///    de uma cole��o composta por este item (TDBConnections)
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
        function GetZConnectionByName(s: String): TConnection;
    public
        constructor Create(ItemClass: TZConnectionClass);
        function Add: TConnection;
		property ByIndex[i: Byte]: TConnection read GetZConnectionByIndex; default;
        property ByName[s: String]: TConnection read GetZConnectionByName;
    end;

    TFileInformation = class
    private
    	FFileInfo: TVSFixedFileInfo;
    	FFileName: TFileName;
	    procedure SetFileName(const Value: TFileName);
      function GetFileInfo(const aInfo: String): TMultiTypedResult;
    public
    	class function GetInfo(const aFileName: TFileName; const aInfo: String): TMultiTypedResult;
      class procedure SetVersion(const aFileName: TFileName; const aMajor, aMinor, aRelease, aBuild: Word);
    	property FileName: TFileName read FFileName write SetFileName;
      property FileInfo[const Info: String]: TMultiTypedResult read GetFileInfo;
    end;

	TXXXConfigurations = class(TObjectFile)
	private
		{ Servem para configurar a imagem de fundo da aplica��o }
		FBackGroundImage: TFileName;
		FBackgroundImagePosition: TBackgroundImagePosition;
		FBackgroundImageModifier: TBackgroundImageModifier;

		{ Usada para encripta��o interna. Deve ser setada/modificada em uma
        classe filha desta e N�O deve ser published de forma nenhuma }
		FMasterPassword: String;
        
		FCurrentDir: String;
		{ Usados pelo form de configura��o de banco }
		FNeedsGeneralConfiguration: Boolean;
		FDBProtocol: String;
		FDBHostAddr: String;
		FDBPortNumb: Word;
		FDBDataBase: String;
		FDBUserName: String;
		FDBPassword: String;
        FDBIsoLevel: Byte;

    	{ Usado pelo form de login para preselecionar o �ltimo usu�rio  que  fez
        login corretamente }
        FLastAuthenticatedUser: Word;
		{ Guarda informa��es de login do usu�rio atualmente autenticado }
        FAuthenticatedUser: TAuthenticatedUser;

    	{ Usados pelo form de login.  Devem ser  setadas em uma classe filha que
        indicar� seus valores de acordo com a aplica��o }
        FUserTableTableName: String; { USUARIOS }
        FUserTableKeyFieldName: String;
        FUserTableRealNameFieldName: String;
        FUserTableUserNameFieldName: String;
        FUserTablePasswordFieldName: String;
        FUserTableEmailFieldName: String;
        FExpandedLoginDialog: Boolean;
        FPasswordCipherAlgorithm: THashAlgorithm;

        { Tabelas do m�dulo de administra��o do sistema }
        FEntitiesTableTableName: String; { ENTIDADESDOSISTEMA }
        FEntitiesTableKeyFieldName: String;
        FEntitiesTableNameFieldName: String;
        FEntitiesTableTypeFieldName: String;

        FGroupTableTableName: String; { GRUPOS }
        FGroupTableKeyFieldName: String;
        FGroupTableNameFieldName: String;
        FGroupTableDescriptionFieldName: String;

        { COMPARTILHADO ENTRE AS TABELAS DE PERMISS�O }
        FPermissionTableReadFieldName: String;
        FPermissionTableInsertFieldName: String;
        FPermissionTableUpdateFieldName: String;
        FPermissionTableDeleteFieldName: String;

    	FUserPermissionTableTableName: String; { PERMISSOESDOSUSUARIOS }
        FUserPermissionTableKeyFieldName: String;
        FUserPermissionTableEntityFieldName: String;
        FUserPermissionTableUserFieldName: String;

    	FGroupPermissionTableTableName: String;  { PERMISSOESDOSGRUPOS }
        FGroupPermissionTableKeyFieldName: String;
        FGroupPermissionTableEntityFieldName: String;
        FGroupPermissionTableGroupFieldName: String;

        FUserGroupsTableTableName: String; { GRUPOSDOSUSUARIOS }
        FUserGroupsTableKeyFieldName: String;
        FUserGroupsTableUserFieldName: String;
        FUserGroupsTableGroupFieldName: String;

        FAdministrativeActionName: String;
        FAddEntityActionName: String;
        FAddEntityToUserOrGroupActionName: String;

        FUserCreatorFieldName: String;
        FCreationDateAndTimeFieldName: String;
        FUserModifierFieldName: String;
        FModificationDateAndTimeFieldName: String;
        FRecordStatusFieldName: String;

        { Outras Op��es }
        FUseBalloonsOnValidationErrors: Boolean;
        FUseEnterAloneToSearch: Boolean;
        FConvertEnterToTabList: TStrings;

        { Op��es de e-mail SMTP }

    	function GetConvertEnterToTabFor(ControlClassName: String): Boolean;
	protected
    	procedure Clear; override;
	public
        constructor Create(AOwner: TComponent); override;
        destructor Destroy; override;

        property CurrentDir: String read FCurrentDir;
		property MasterPassword: String read FMasterPassword write FMasterPassword;
		property AuthenticatedUser: TAuthenticatedUser read FAuthenticatedUser write FAuthenticatedUser;
        property ConvertEnterToTabFor[ControlClassName: String]: Boolean read GetConvertEnterToTabFor;
	published
		property BackGroundImage: TFileName read FBackGroundImage write FBackGroundImage;
		property BackgroundImagePosition: TBackgroundImagePosition read FBackgroundImagePosition write FBackgroundImagePosition;
		property BackgroundImageModifier: TBackgroundImageModifier read FBackgroundImageModifier write FBackgroundImageModifier;
		property DBPassword: String read FDBPassword write FDBPassword;
		property DBUserName: String read FDBUserName write FDBUserName;
		property DBProtocol: String read FDBProtocol write FDBProtocol;
		property DBDataBase: String read FDBDataBase write FDBDataBase;
		property DBHostAddr: String read FDBHostAddr write FDBHostAddr;
		property DBPortNumb: Word read FDBPortNumb write FDBPortNumb;
		property DBIsoLevel: Byte read FDBIsoLevel write FDBIsoLevel;

        property UserTableTableName: String read FUserTableTableName write FUserTableTableName;
		property UserTableKeyFieldName: String read FUserTableKeyFieldName write FUserTableKeyFieldName;
		property UserTableRealNameFieldName: String read FUserTableRealNameFieldName write FUserTableRealNameFieldName;
		property UserTableUserNameFieldName: String read FUserTableUserNameFieldName write FUserTableUserNameFieldName;
		property UserTablePasswordFieldName: String read FUserTablePasswordFieldName write FUserTablePasswordFieldName;
        property UserTableEmailFieldName: String read FUserTableEmailFieldName write FUserTableEmailFieldName;

        property GroupTableTableName: String read FGroupTableTableName write FGroupTableTableName; { GRUPOS }
        property GroupTableKeyFieldName: String read FGroupTableKeyFieldName write FGroupTableKeyFieldName;
        property GroupTableNameFieldName: String read FGroupTableNameFieldName write FGroupTableNameFieldName;
        property GroupTableDescriptionFieldName: String read FGroupTableDescriptionFieldName write FGroupTableDescriptionFieldName;

        property EntitiesTableTableName: String read FEntitiesTableTableName write FEntitiesTableTableName; { ENTIDADESDOSISTEMA }
        property EntitiesTableKeyFieldName: String read FEntitiesTableKeyFieldName write FEntitiesTableKeyFieldName;
        property EntitiesTableNameFieldName: String read FEntitiesTableNameFieldName write FEntitiesTableNameFieldName;
        property EntitiesTableTypeFieldName: String read FEntitiesTableTypeFieldName write FEntitiesTableTypeFieldName;

        property PermissionTableReadFieldName: String read FPermissionTableReadFieldName write FPermissionTableReadFieldName;
        property PermissionTableInsertFieldName: String read FPermissionTableInsertFieldName write FPermissionTableInsertFieldName;
        property PermissionTableUpdateFieldName: String read FPermissionTableUpdateFieldName write FPermissionTableUpdateFieldName;
        property PermissionTableDeleteFieldName: String read FPermissionTableDeleteFieldName write FPermissionTableDeleteFieldName;

     	property UserPermissionTableTableName: String read FUserPermissionTableTableName write FUserPermissionTableTableName; { PERMISSOESDOSUSUARIOS }
        property UserPermissionTableKeyFieldName: String read FUserPermissionTableKeyFieldName write FUserPermissionTableKeyFieldName;
        property UserPermissionTableEntityFieldName: String read FUserPermissionTableEntityFieldName write FUserPermissionTableEntityFieldName;
        property UserPermissionTableUserFieldName: String read FUserPermissionTableUserFieldName write FUserPermissionTableUserFieldName;

    	property GroupPermissionTableTableName: String read FGroupPermissionTableTableName write FGroupPermissionTableTableName;  { PERMISSOESDOSGRUPOS }
        property GroupPermissionTableKeyFieldName: String read FGroupPermissionTableKeyFieldName write FGroupPermissionTableKeyFieldName;
        property GroupPermissionTableEntityFieldName: String read FGroupPermissionTableEntityFieldName write FGroupPermissionTableEntityFieldName;
        property GroupPermissionTableGroupFieldName: String read FGroupPermissionTableGroupFieldName write FGroupPermissionTableGroupFieldName;

        property UserGroupsTableTableName: String read FUserGroupsTableTableName write FUserGroupsTableTableName; { GRUPOSDOSUSUARIOS }
        property UserGroupsTableKeyFieldName: String read FUserGroupsTableKeyFieldName write FUserGroupsTableKeyFieldName;
        property UserGroupsTableUserFieldName: String read FUserGroupsTableUserFieldName write FUserGroupsTableUserFieldName;
        property UserGroupsTableGroupFieldName: String read FUserGroupsTableGroupFieldName write FUserGroupsTableGroupFieldName;

        property AdministrativeActionName: String read FAdministrativeActionName write FAdministrativeActionName;
        property AddEntityActionName: String read FAddEntityActionName write FAddEntityActionName;
        property AddEntityToUserOrGroupActionName: String read FAddEntityToUserOrGroupActionName write FAddEntityToUserOrGroupActionName;

        property UserCreatorFieldName: String read FUserCreatorFieldName write FUserCreatorFieldName;
        property CreationDateAndTimeFieldName: String read FCreationDateAndTimeFieldName write FCreationDateAndTimeFieldName;
        property UserModifierFieldName: String read FUserModifierFieldName write FUserModifierFieldName;
        property ModificationDateAndTimeFieldName: String read FModificationDateAndTimeFieldName write FModificationDateAndTimeFieldName;
        property RecordStatusFieldName: String read FRecordStatusFieldName write FRecordStatusFieldName;

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
    	FDelimiter: String;
        FScript: String;
    public
    	constructor Create(Collection: TCollection); override;
    	property Delimiter: String read FDelimiter write FDelimiter;
        property Script: String read FScript write FScript;
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
	HASH_ALGORITHMS: array [Low(THashAlgorithm)..High(THashAlgorithm)] of String = ('NENHUM','SHA-512','SHA-384','SHA-256','SHA-1','RIPMED-160','RIPMED-128','MD5','MD4','HAVAL','TIGER');
    CURRENCY_STRINGS: array [1..5] of String = ('US$','�','R$','�','�');
    MONTH_NAMES: array [1..12] of String = ('Janeiro','Fevereiro','Mar�o','Abril','Maio','Junho','Julho','Agosto','Setembro','Outubro','Novembro','Dezembro');
    CR_LF = #$0D#$0A;

    { ATEN��O: N�O MUDE OS VALORES DAS CONSTANTES ABAIXO. }
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

    { Mensagens de tela: devem ser feitos aliases para elas em cada form padr�o como resourcestrings }
    PAGE_CHANGE_NOT_ALLOWED = 'N�o � poss�vel alternar entre p�ginas enquanto a'+
    ' opera��o de inser��o/edi��o atual n�o tiver sido conclu�da ou cancelada.'+
    ' Termine a opera��o atual ou cancele-a para poder mudar de p�gina';
    ACTION_NOT_ALLOWED_NOW = 'A��o n�o permitida no momento...';

resourcestring
    RS_INVALID_ARGUMENT_DATA = 'O par�metro "%s" est� correto quanto ao tipo, mas seus dados n�o s�o compat�veis com o m�todo. %s';
	RS_EIAD = 'Erro nos dados de um dos par�metros do m�todo %s.' + CR_LF + CR_LF + '%s';
    RS_EXC = 'Erro desconhecido no m�todo %s. � preciso uma depura��o mais detalhada.' + CR_LF + CR_LF + '%s';
	RS_EAV = 'Houve um erro de viola��o de acesso no m�todo %s.' + CR_LF + CR_LF + '%s';
    RS_UNEXPECTED_INFORMATION = 'O m�todo obteve internamente uma informa��o inesperada. %s';
	RS_PAGECHANGENOTALLOWEDNOW = 'N�o � poss�vel alternar entre p�ginas enquanto a opera��o de inser��o/edi��o atual n�o tiver sido conclu�da ou cancelada. Termine a opera��o atual ou cancele-a para poder mudar de p�gina';
	RS_ACTIONNOTALLOWEDNOW = 'A��o n�o permitida no momento';

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
//constructor EInvalidRecordValue.CreateFmt(const aFieldError: TField; const aMsg: String; const aArgs: array of const);
//begin
//	inherited CreateFmt(aMsg,aArgs);
//    FFieldError := aFieldError;
//end;
//
//constructor EInvalidRecordValue.Create(const aFieldError: TField; const aMsg: String);
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

function TZConnections.GetZConnectionByName(s: String): TConnection;
var
	i: Byte;
begin
	Result := nil;
    if Count > 0 then
        for i := 0 to Pred(Count) do
            if TConnection(inherited Items[i]).Connection.Name = s then
            begin
                Result := TConnection(inherited Items[i]);
                Break;
            end;
end;

{ TFileInformation }

{ TODO -oCarlos Feitoza : Esta fun��o est� incompleta. Ela s� est� retornando as
informa��es de vers�o. Por favor complete-a! }
function TFileInformation.GetFileInfo(const aInfo: String): TMultiTypedResult;
begin
    ZeroMemory(@Result,SizeOf(TMultiTypedResult));
    with Result do
    begin
        if aInfo = 'MAJORVERSION' then
        begin
    	    AsWord := HiWord(FFileInfo.dwFileVersionMS);
	        AsString := IntToStr(AsWord);
        end
        else if aInfo = 'MINORVERSION' then
        begin
    	    AsWord := LoWord(FFileInfo.dwFileVersionMS);
	        AsString := IntToStr(AsWord);
        end
        else if aInfo = 'RELEASE' then
        begin
    	    AsWord := HiWord(FFileInfo.dwFileVersionLS);
	        AsString := IntToStr(AsWord);
        end
        else if aInfo = 'BUILD' then
        begin
    	    AsWord := LoWord(FFileInfo.dwFileVersionLS);
	        AsString := IntToStr(AsWord);
        end
        else if aInfo = 'FULLVERSION' then
        begin
	        AsString := GetFileInfo('MAJORVERSION').AsString + '.' + GetFileInfo('MINORVERSION').AsString + '.' + GetFileInfo('RELEASE').AsString + '.' + GetFileInfo('BUILD').AsString;
            AsInt64 := StrToInt64(GetFileInfo('MAJORVERSION').AsString + GetFileInfo('MINORVERSION').AsString + GetFileInfo('RELEASE').AsString + GetFileInfo('BUILD').AsString);
        end
    end;
end;

class function TFileInformation.GetInfo(const aFileName: TFileName; const aInfo: String): TMultiTypedResult;
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
    { Carrega o m�dulo. Pode ser uma DLL ou execut�vel }
    ModuleHandle := LoadLibrary(PChar(aFileName));

    if ModuleHandle <> 0 then
    begin
      try
        { Obt�m o handle para o recurso de vers�o raiz, que cont�m mais
        informa��es do que necessitamos }
        ResourceInformationHandle := FindResource(ModuleHandle
                                                 ,MakeIntResource(VS_VERSION_INFO)
                                                 ,RT_VERSION);

        if ResourceInformationHandle <> 0 then
        begin
          { Obt�m o handle para o recurso de vers�o espec�ficamente. Com este
          handle podemos acessar apenas o que � necess�rio para n�s. Aqui tamb�m
          obtemos o tamanho da informa��o de vers�o }
          ResourceHandle := LoadResource(ModuleHandle, ResourceInformationHandle);
          ResourceSize   := SizeofResource(ModuleHandle,ResourceInformationHandle);

          if ResourceHandle <> 0 then
          begin
            { Obt�m um ponteiro para as informa��es de vers�o. Este ponteiro n�o
            pode ser alterado diretamente, por isso, mais adiante estamos
            copiando suas informa��es para um segundo ponteiro em outro local de
            mem�ria. Este segundo ponteiro ser� usado para atualizar as
            informa��es de vers�o }
            ReadOnlyResource := LockResource(ResourceHandle);

            if Assigned(ReadOnlyResource) then
            begin
              GetMem(EditableResource,ResourceSize);
              Move(ReadOnlyResource^,EditableResource^,ResourceSize);
            end
            else
              raise Exception.CreateFmt('N�o foi poss�vel obter acesso exclusivo ao recurso de vers�o do m�dulo "%s"',[aFileName]);
          end
          else
            raise Exception.CreateFmt('N�o foi poss�vel carregar o recurso de vers�o contido no m�dulo "%s"',[aFileName]);
        end
        else
          raise Exception.CreateFmt('N�o foi poss�vel encontrar o recurso de vers�o no m�dulo "%s"',[aFileName]);
      finally
        FreeLibrary(ModuleHandle);
      end;

      try
        { Aqui realizamos as altera��es necess�rias }
        with EditableResource^.Value do
        begin
          dwFileVersionMS := MakeLong(aMinor,aMajor);
          dwFileVersionLS := MakeLong(aBuild,aRelease);
          dwProductVersionMS := dwFileVersionMS;
          dwProductVersionLS := dwFileVersionLS;
        end;

        { Iniciamos a altera��o do recurso, obtendo um handle para o m�dulo em
        quest�o, mas desta vez, ao inv�s de usar LoadLibrary (somente leitura
        ) usaremos uma fun��o especializada para edi��o de recursos:
        BeginUpdateResource }
        ModuleHandle := BeginUpdateResource(PChar(aFileName), False);

        if ModuleHandle <> 0 then
        begin
          DiscardChanges := True;

          try
            { Aqui estamos realizando a altera��o do recurso de vers�o usando em
            seu lugar a nossa vers�o modificada do ponteiro (EditableResource).
            O resultado desta fun��o � true, caso tudo tenha ocorrido bem e
            neste caso n�s devemos preencher a vari�vel DiscardChanges com o
            valor invertido (not) pois s� devemos descartar altera��es se esta
            fun��o retornar false  }
            DiscardChanges := not UpdateResource(ModuleHandle
                                                ,RT_VERSION
                                                ,MakeIntResource(VS_VERSION_INFO)
                                                ,(SUBLANG_PORTUGUESE_BRAZILIAN shl 10) or LANG_PORTUGUESE
                                                ,EditableResource
                                                ,ResourceSize);


            if DiscardChanges then
              raise Exception.CreateFmt('N�o foi poss�vel adicionar o recurso de vers�o no arquivo "%s"',[aFileName]);

          finally
            { Tenta efetivar a altera��o realizada. Isso s� ser� feito se
            DiscardChanges for False }
            EndUpdateResource( ModuleHandle, DiscardChanges );
          end;
        end
        else
          raise Exception.CreateFmt('N�o foi abrir o m�dulo "%s" para grava��o',[aFileName]);
      finally
        FreeMem(EditableResource);
      end;
    end
    else
      raise Exception.CreateFmt('N�o foi poss�vel carregar o m�dulo "%s"',[aFileName]);
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
//   CompanyName : string;
//   FileDescription : string;
//   InternalName : string;
//   LegalCopyright : string;
//   LegalTrademarks : string;
//   OriginalFileName : string;
//   ProductVersion : string;
//   Comments : string;
// end; 
//
//procedure FileVersionDigits(filename:string; var VersionNr:TVersionNumber);
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
//procedure FileVersionDescription(filename:string; var
//VersionD:TVersionDescription);
//function SwapLong(L : longint): longint;
//assembler;
//asm
//      rol eax, 16;
//end;
//var sz,l,len:dword;
//    buf,p:pointer;
//    zKeyPath : array[0..255] of Char;
//    language:string;
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

{ O m�todo Clear limpa apenas as vari�veis published }
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

{ Nada � carregado no create, classes filhas devem usar o m�todo LoadFromFile }
constructor TXXXConfigurations.Create(AOwner: TComponent);
begin
	inherited;
    FMasterPassword := DEFAULT_MASTER_PASSWORD;

    FCurrentDir := GetCurrentDir;

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

function TXXXConfigurations.GetConvertEnterToTabFor(ControlClassName: String): Boolean;
begin
	Result := FConvertEnterToTabList.IndexOf(ControlClassName) > -1;
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
                                               ,IntToStr(Succ(StatementIndex)) + ' / ' + IntToStr(Processor.StatementCount));
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

function TSavedTexts.IndexOfTitle(aTextTile: String): SmallInt;
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


