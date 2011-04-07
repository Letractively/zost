unit UXXXDataModule;

interface

uses
	{ VCL }
  	SysUtils, Classes, Controls, DB, Contnrs, Forms, ImgList, StdCtrls, ActnList,
    ComCtrls,
    { FRAMEWORK }
    UXXXTypesConstantsAndClasses, UForm_Processing, _ActnList,
    { COMPONENTES }
    ZConnection, ZDataset, ZAbstractRODataset, ZAbstractDataset, ZDBCIntfs,
    UBalloonToolTip, CFDBValidationChecks, UCFDBGrid, DBCtrls;

type
    TXXXDataModuleClass = class of TXXXDataModule;

    TXXXDataModule_Main = class;
    { TODO -oCarlos Feitoza -cMELHORIA : TALVEZ SEJA MELHOR CRIAR UMA PROPRIEDADE DO TIPO TDATAMODULECREATEPARAMETERS E ACESSAR TODAS AS CARACTERISTICAS A PARTIR DE L� }
    TDataModuleCreateParameters = record
        Configurations: TXXXConfigurations;
        DataModuleMain: TXXXDataModule_Main; { nil }
        Description: String; { '' }
        ProgressBarModuleLoad: TProgressBar;
    end;

    TXXXDataModule = class(TDataModule)
        ActionList_Buttons: TActionList;
        ActionList_PopUps: TActionList;
    	procedure DataModuleCreate(Sender: TObject);
    	procedure DataModuleDestroy(Sender: TObject);
	private
    	{ Private declarations }
        FDescription: String;
        FProgressBarModuleLoad: TProgressBar;
        FConfigurations: TXXXConfigurations;
        FZConnections: TZConnections;
    	FDataModuleMain: TXXXDataModule_Main;
        FShowCancelQuestion: Boolean;
//        FShowValidationQuestion: Boolean;
        FShowDeleteQuestion: Boolean;
	    FApplicationActionsEnabled: Boolean;
        Form_Processing: TForm_Processing;

//    	FTotalOfActions: Cardinal;
	    function GetEntityID(aZConnection: TZConnection; aEntityName: String; aEntityType: TEntityType): Cardinal;
        procedure DoBeforeCancel(aDataSet: TDataSet);
	    procedure DoUnhandleException(Sender: TObject; E: Exception);
	    procedure SetApplicationActionsEnabled(const aEnabled: Boolean);
        function GetTotalApplicationActions: Cardinal;
        function GetTotalApplicationDataSets: Word;
        function GetDataSetCount: Byte;
        function GetCFDBValidationChecksCount: Byte;
        function GetDataSourceCount: Byte;
        function GetActionCount: Word;
        function LastModifiedOn(aDataSet: TDataSet): TDateTime;

        procedure SetDefaultEventsToAllDataSets(aOpenDataSet: Boolean);
		procedure SetDefaultEventsToAllCFDBValidationChecks;        
        procedure SetDefaultEventsToAllDataSources;
        function GetAddEntitiesForm: TForm;

        { TODO -oCarlos Feitoza : Removi a op��o de checar chaves estrangeiras. Agora ela sempre ser� ativada }
		procedure SplitSQLScript(const aZConnection: TZConnection;
                                   var aScriptParts: TScriptParts;
                                 const aSQLScriptFile: TFileName;
                                 const aSQLScriptText: String;
//                                 const aForeignKeysCheck: Boolean = True;
                                 const aSplitSQLScriptCallBack: TSplitSQLScriptCallBack = nil);

        { = COMPONENTES ====================================================== }
//        function DBButtonToggle(aDataSet: TDataSet; aDBButton: TDBButton): Boolean;
//        function DBPageButtonToggle(aDataSet: TDataSet; aDBPageButton: TPageButton; aCurrentPage, aTotalPages: Word): Boolean;

        { -------------------------------------------------------------------- }
        property ApplicationActionsEnabled: Boolean read FApplicationActionsEnabled write SetApplicationActionsEnabled;
        property ActionCount: Word read GetActionCount;
//        property ShowValidationQuestion: Boolean write FShowValidationQuestion;
        property TotalApplicationActions: Cardinal read GetTotalApplicationActions;
        property TotalApplicationDataSets: Word read GetTotalApplicationDataSets;
        property ZConnections: TZConnections read FZConnections write FZConnections;
    protected
    	{ Protected declarations }
        procedure InitializeConfigurations(const aZConnection: TZConnection; aFormClass: TFormClass; const aBasicConfigurations: TXXXConfigurations; const aPagesToShow: TPagesToShow = [ptsDatabase]);
    	procedure IncreaseProgress(aProgressBar: TProgressBar; aLabelPercentDone: TLabel);
    	procedure IncreaseProgressWith(aProgressBar: TProgressBar; aLabelPercentDone: TLabel; aPosition: Cardinal);
    	procedure InitializeProgress(aProgressBar: TProgressBar; aLabelPercentDone: TLabel; aMax: Cardinal);

        procedure LoadGeneralConfigurations(const aZConnection: TZConnection; aForm: TForm; const aPagesToShow: TPagesToShow; const aBasicConfigurations: TXXXConfigurations); virtual;
        procedure SaveGeneralConfigurations(const aZConnection: TZConnection; aForm: TForm; const aPagesToShow: TPagesToShow; const aBasicConfigurations: TXXXConfigurations); virtual;

        { = AUDITORIA ======================================================== }
        procedure LogDBActionError(const aZConnection: TZConnection; aDataSet: TDataSet; aEDatabaseError: EDatabaseError);
        function IsSystemTable(const aTableName: String): Boolean; virtual;
		function ReplaceSystemObjectNames(const aText: String): String; overload; virtual;
        procedure ReplaceSystemObjectNames(const aZQuery: TZQuery); overload; virtual;
        function GetUserEmail(aUserID: Word = 0): String;


        { = BANCO DE DADOS =================================================== }
        procedure LocateFirstRecord(const aDataSetToLocateIn: TDataSet;
                                    const aEdit: TEdit;
                                    const aFieldName: String);
        function LocateFirstMatchedRecord(const aZConnection: TZConnection;
                                          const aTableNames: array of String;
                                          const aLinkFields: array of String;
                                          const aSearchFieldNames: array of String;
                                          const aSearchFieldValues: array of const;
                                          const aComparisonOperators: array of TComparisonOperator;
                                          const aOrderByFields: array of String;
                                          const aResultField: String): TMultiTypedResult;
        procedure GetPageAndRecordMetrics(const aCFDBGrid: TCFDBGrid; const aOffset: Byte; out aRecordsByPage, aPageCount: Word; var aPageNo: Word; var aRecordCount: Cardinal; const aCountSQL: String = '');
        function GetRowOffsetByPageNo(const aPageNo, aRecordsByPage: Word): Cardinal;
        function GetRecordNoInSet(const aPageNo, aRecordsByPage, aCurrentRecNo: Word): Cardinal;
        function GetRecordInformation(const aZConnection: TZConnection; aTableName, aRecordIdColumnName: String; aRecordIdColumnValue: Cardinal): TRecordInformation;
        function GetMultiTypedResult(const aField: TField): TMultiTypedResult;
    	function ExecuteDbFunction(const aZConnection: TZConnection; const aCallString: String): TMultiTypedResult;
        procedure ExecuteDbProcedure(const aZConnection: TZConnection; const aCallString: String);

		procedure DBButtonClick(aDataSet: TDataSet; aDBButton: TDBButton; aComponentToFocusOnInsertAndEdit: TWinControl = nil);
        procedure DBButtonsToggle(const aDataSet: TDataSet; out aButtonFirstEnabled, aButtonPreviousEnabled, aButtonNextEnabled, aButtonLastEnabled, aButtonInsertEnabled, aButtonDeleteEnabled, aButtonEditEnabled, aButtonPostEnabled, aButtonCancelEnabled, aButtonRefreshEnabled: Boolean);
        procedure DBPButtonsToggle(const aDataSet: TDataSet; const aPageNo, aPageCount: Word; out aButtonFirstEnabled, aButtonPreviousEnabled, aButtonNextEnabled, aButtonLastEnabled: Boolean);
	    function ThisRecordExists(const aDBConnection: TZConnection; TableName, KeyName: String; KeyValue: Cardinal): Boolean; virtual;

        procedure SetRefreshSQL(const aZQuery: TZQuery; const aDBAction: TDBAction; out aRefreshSQL: String); virtual;
        procedure DoDataChange(aSender: TObject; aField: TField); virtual;
        procedure DoBeforePost(aDataSet: TDataSet); virtual;
        procedure DoAfterPost(aDataSet: TDataSet); virtual;
        procedure DoBeforeInsert(aDataSet: TDataSet); virtual;
        procedure DoBeforeEdit(aDataSet: TDataSet); virtual;
        procedure DoBeforeDelete(aDataSet: TDataSet); virtual;
        procedure DoAfterDelete(aDataSet: TDataSet); virtual;
        procedure DoBeforeOpen(aDataSet: TDataSet); virtual;
        procedure DoAfterClose(aDataSet: TDataSet); virtual;
        procedure DoAfterOpen(aDataSet: TDataSet); virtual;
        procedure DoNewRecord(aDataSet: TDataSet); virtual;
        procedure DoCustomValidate(const aSender: TObject; const aValidateAction: TValidateAction; const aValidateMoment: TValidateMoment); virtual;
        procedure DoStateChange(aSender: TObject); virtual;

   		procedure DoDBActionError(aDataSet: TDataSet; aEDatabaseError: EDatabaseError; var Action: TDataAction); virtual; abstract;
		procedure SetDefaultCFDBValidationChecksEvents(const aCFDBValidationChecks: TCFDBValidationChecks);
		procedure SetDefaultDataSetEvents(aDataSet: TDataset; aOpenDataSet: Boolean);

        procedure SetDefaultDataSourceEvents(aDataSource: TDataSource);
        function MySQLDBServerDateAndTime(const aZConnection: TZConnection): TDateTime;
        function MySQLAffectedRows(const aZConnection: TZConnection): Cardinal;
        procedure MySQLSetForeignKeyCheck(const aDBConnection: TZConnection; const aForeignKeyCheck: Boolean);
        procedure MySQLSetSQLQuoteShowCreate(const aDBConnection: TZConnection; const aSQLQuoteShowCreate: Boolean);
//        procedure MySQLDefragDataBase(const aZConnection: TZConnection; const aDefragDatabaseCallBack: TDefragDatabaseCallBack = nil);
        function MySQLReplaceSearchWildcards(const aSQL: String): String;
		procedure SetAutoCommit(const aZConnection: TZConnection; const aAutoCommit: Boolean);
	    procedure CommitWork(const aZConnection: TZConnection);
    	procedure RollbackWork(const aZConnection: TZConnection);
	    procedure StartTransaction(const aZConnection: TZConnection);
		procedure SetMySQLUserVariable(const aZConnection: TZConnection; aVariableName: String; aVariableValue: Int64); overload;
		procedure SetMySQLUserVariable(const aZConnection: TZConnection; aVariableName, aVariableValue: String); overload;
		procedure SetMySQLUserVariable(const aZConnection: TZConnection; aVariableName: String; aVariableValue: Boolean); overload;
//        function GetMySQLUserVariableAsInteger(const aZConnection: TZConnection; aVariableName: String): Int64;

    	procedure MySQLAddIndex(aZConnection: TZConnection; aTableName, aIndexName, aFieldNames: String; aIndexKind: TMySQLIndexKind = mikIndex);
        procedure MySQLDropIndex(aZConnection: TZConnection; aTableName, aIndexName: String);


        { = EXCE��ES ========================================================= }
        procedure ShowBalloonToolTipValidationFor(aCurrentForm: TForm; aDataSet: TDataSet; aFieldError: TField);

        { = SISTEMA ========================================================== }
        procedure ShowProcessingForm(aDescription: String = ''; aShowProgressBar: Boolean = False);
        procedure HideProcessingForm;

        { = MANIPULA��O DE STRINGS =========================================== }
        class function PutLineBreaks(const aText: String; aLineChars: Byte): String;
        function GetUniqueFileName(aFullPathAndFileName: String): String;
        function ValidateStringForFileName(aFileName: String; aReplaceInvalidCharsWith: Char = '_'; aMaximumFileNameLength: Byte = 0): String;
        function MakeStr(const aArgs: array of const; aSeparator: Char = ','): string;
        function GetElementByIndex(aIndex: Byte; aElements: array of String): String;
//        function GetIndexOfElement(aElement: String; aElements: array of String): String;
		function GetPartFromDelimitedString(const aString: String; const aPart: Cardinal; const aDelimiter: Char = '|'; aTempStringList: TStringList = nil): String;

        { = MANIPULA��ES DE ARQUIVOS ========================================= }
        function LoadTextFile(const aFileName: TFileName): String;
        function FileSize(aFileName: TFileName; aFileSizeIn: TFileSizeUnit = fsuBytes): Double;
        { -------------------------------------------------------------------- }
        property Configurations: TXXXConfigurations read FConfigurations;
        property ProgressBarModuleLoad: TProgressBar read FProgressBarModuleLoad;
        property ShowDeleteQuestion: Boolean write FShowDeleteQuestion;
        property ShowCancelQuestion: Boolean write FShowCancelQuestion;
    public
        class procedure CompressFile(const aInputFile
                                         , aOutputFile: TFileName;
                                           OnNotification: TZlibNotification);
        class procedure DecompressFile(const aInputFile
                                           , aOutputFile: TFileName;
                                             OnNotification: TZlibNotification);

        { TODO -oCarlos Feitoza : Removi a op��o de checar chaves estrangeiras. Agora ela sempre ser� ativada }
        procedure MySQLExecuteSQLScript(const aZConnection: TZConnection;
                                        const aSQLScriptFile: TFileName;
                                        const aSQLScriptText: String;
//                                        const aForeignKeysCheck: Boolean = True;
                                        const aExecuteSQLScriptCallBack: TExecuteSQLScriptCallBack = nil;
                                        const aSplitSQLScriptCallBack: TSplitSQLScriptCallBack = nil);
        class procedure MySQLChangeDatabase(const aZConnection: TZConnection;
                                                           const aDataBaseName: String);

        class function MySQLBackupDataBase(const aZConnection: TZConnection;
                                           const aParameters: TMySQLBackupDataBaseParameters): String;
        class procedure InitializeZConnection(const aZConnection: TZConnection; aProtocol, aHostName, aDatabase, aUser, aPassword: String; aPortNumb: Word; aTransactIsolationLevel: TZTransactIsolationLevel);
	    class function GetStringCheckSum(const aInputString: String; aHashAlgorithms: THashAlgorithms; aFinalHashAlgorithm: THashAlgorithm = haIgnore): String; static;
    	class function Hex(aASCII: AnsiString): AnsiString;
        class function MySQLFormat(const aFormat: String; const aArgs: array of const): String;
        class procedure SetLabelDescriptionValue(const aLabelDescription, aLabelValue: TLabel; const aValue: String; const aSpacing: Byte = 2); overload; static;
        class procedure SetLabelDescriptionValue(const aLabelDescription: TLabel; const aLabelValue: TDBText; const aSpacing: Byte = 2); overload; static;
        class procedure ConfigureDataSet(const aDBConnection: TZConnection; var aDataSet: TZReadOnlyQuery; const aSQLCommand: String; const aAutoCreateDataSet: Boolean = True);
		//function MySQLDatabaseCheckSum(const aZConnection: TZConnection; const aTablesToIgnore, aFieldsToIgnore: array of String): String;
        class function MySQLDatabaseCheckSum(const aZConnection: TZConnection; const aDatabaseName: String; const aTablesToIgnore, aFieldsToIgnore: array of String; aTempDir: TFileName; aOnGetChecksum: TOnGetChecksum): String;
        class procedure SaveTextFile(aText: String; const aFileName: TFileName);
    	class function GetMySQLUserVariable(const aZConnection: TZConnection; aVariableName: String): TMultiTypedResult;
   	    class procedure WaitFor(const aSeconds: Byte; const aUseProcessMessages: Boolean = True);
        class function CmdLineParamValue(const aParamName: String; out aParamValue: String; const aParamStarter: Char = '/'): Boolean;

        {$IFDEF CURRENCY_CONVERT_MANAGER}
        function ShowCurrencyConvertManager(const aCurrenciesTaxs: String; const aDestinationCurrency: Byte): String;
        {$ENDIF}
        function ShowTextsManager(const aFileName: TFileName): String;
        function AllowedChars(const aTypedChar: Char; aAllowedChars: TAllowedChars): Char;
        procedure SaveComboBoxItems(const aComboBox: TCustomComboBox; const aFileName: TFileName);
        procedure LoadComboBoxItems(const aComboBox: TCustomComboBox; const aFileName: TFileName);
		procedure SafeSetActionEnabled(aAction: ActnList.TAction; aEnabled: Boolean);
		procedure ApplySecurityPolicies(aZConnection: TZConnection; aActionList: _ActnList.TActionList = nil);
	    procedure ShowAddEntityForm;
        procedure ShowRecordInformationForm(const aZConnection: TZConnection; const aTableName, aRecordIdColumnName: String; const aRecordIdColumnValue: Cardinal);

    	{ Public declarations }
        procedure ValidateThisAction(aZConnection: TZConnection; Action: ActnList.TAction);
        ///<author>Carlos Feitoza Filho</author>
		constructor Create(aOwner: TComponent; aDataModule_BasicCreateParameters: TDataModuleCreateParameters); reintroduce; virtual;
        destructor Destroy; override;

		function GetUserGroups(UserID: Word = 0): TBytesArray;

        { = BANCO DE DADOS =================================================== }
        function ComparisonOperator(aComparisonOperator: TComparisonOperator): String;
		procedure DoDataChangeForAllDataSources;
        function HasPermission(aZConnection: TZConnection; aEntityName: String; aUserId: SmallInt = 0; aEntityType: TEntityType = etAction; aPermission: TPermission = pRead): Boolean;
        procedure ExecuteQuery(const aDBConnection: TZConnection; const aSQLCommand: String);
        { TODO -oCarlos Feitoza -cDESAFIO : Ao inv�s de usar TFormClass, deveria
        ser usada a classe do form de configura��es, mas isso gerou refer�ncia
        circular das units. O uso de TFormClass e TForm faz necess�rio o uso de
        muitos casts. Para resolver este problema devemos usar as memas
        estruturas do delphi e criar uma unit com nome XXXForms que cont�m a
        defini��o de classes de nossos forms. Isso dever� ser feito para todas
        as classes, isto �, usar a estrutura que o delphi usa. Para complementar
        deveremos usar tamb�m  OTA para criar formularios customizados e alterar
        o repository wizard com nossos forms }
        function ShowGeneralConfigurationForm(const aZConnection: TZConnection; aForm_DialogTemplateClass: TFormClass; const aBasicConfigurations: TXXXConfigurations; const aPagesToShow: TPagesToShow = [ptsDatabase]): Boolean;

        function MakeLogin(const aZConnection: TZConnection; aExpandedMode: Boolean = False): Boolean;

        { = COMPONENTES ====================================================== }
		function IsValidDataWareComponent(aComponent: TComponent; out aDataSet: TDataSet; out aDataField: TField): Boolean;

        { = MISC ============================================================= }
//        procedure MakeSameWidthsAndAdjust(aControls: array of TControl; aLabels: array of TLabel; aSpacing: Byte = 6);
        procedure ClearDirectoryFrom(aDirectory: String; aRemoveEmptySubDirs: Boolean = False; aMask: String = '*.*');

        { = INTERFACE GR�FICA ================================================ }
//        function ShowForm(aForm: TComponentClass; var aReference; aModal: Boolean = True; aFormTitle: String = ''): TModalResult;
		procedure ToggleAnimatedVisibility(aWinControl: TWinControl; aShow: Boolean);
		procedure EqualizeWidthsAndAdjust(const aControls: array of TControl; const aLabels: array of TLabel; const	aSeparation: Byte = 6);

        { = MANIPULA��ES DE ARRAYS =========================================== }
        function ArrayOfByteToString(aArrayOfByte: array of Byte; aSeparator: Char = ','): String;
        ///<author>Carlos Feitoza Filho</author>
		function ArrayOfByteToSet(aArrayOfByte: array of Byte): TSetOfByte;
        { -------------------------------------------------------------------- }
//        property MainZConnections: TZConnections read FMainZConnections write FMainZConnections;
    	property AddEntitiesForm: TForm read GetAddEntitiesForm;
    	property Description: String read FDescription;
        property DataModuleMain: TXXXDataModule_Main read FDataModuleMain;
        property DataSetCount: Byte read GetDataSetCount;
        property DataSourceCount: Byte read GetDataSourceCount;
    end;

    TXXXDataModule_Main = class(TXXXDataModule)
    public
    	property ActionCount; { local e global }
    	property ApplicationActionsEnabled; { global }
        property TotalApplicationActions; { global }
        property TotalApplicationDataSets; { global }
        property ZConnections; { local e global }
    end;
    /// em  TDataModule_Basic coloque todas as propriedades e m�todos que devem
    ///    aparecer no datamodule main, dentro da se��o private e aqui nesta classe
    ///    (TDataModule_Alpha) declare estas propriedades e m�todos como sendo p�blicos

const
	SQL_SELECT_LOGIN =
    'SELECT' + CR_LF +
    '	%S,' + CR_LF + // CAMPO CHAVE
    '	%S,' + CR_LF + // CAMPO NOME REAL
    '	%S,' + CR_LF + // CAMPO LOGIN
    '	%S' + CR_LF +  // CAMPO SENHA
    'FROM' + CR_LF +
    '	%S';           // NOME DA TABELA

	SQL_UPDATE_PASSWORD =
    'UPDATE %S' + CR_LF +      // NOME DA TABELA
    '   SET %S = %S' + CR_LF + // CAMPO SENHA / SENHA
    ' WHERE %S = %U';          // CAMPO CHAVE / CHAVE

resourcestring
	RS_VALIDATE_ERROR_BALLOON_TITLE = 'Erro de valida��o';
    RS_NO_UPDATE_PERMISSION = 'Sinto muito, mas voc� n�o tem permiss�o para editar registros da tabela %s';
    RS_NO_ACTION_PERMISSION = 'Sinto muito, mas voc� n�o tem permiss�o para realizar esta a��o';

implementation

uses
	{ VCL }
	Windows, ExtCtrls, DBGrids, Graphics, Messages, Math, Grids, Themes, StrUtils, ZLib,
    { FRAMEWORK }
	UXXXForm_MainTabbedTemplate, UXXXForm_ModuleTabbedTemplate,
    UXXXForm_GeneralConfiguration, UForm_Login, UXXXForm_AddEntity, UXXXForm_DialogTemplate,
    UForm_ApplyingSecurityPolicies, UXXXDataModule_AddEntity, UXXXForm_RecordInformation,
    UXXXForm_TextsManager, {$IFDEF CURRENCY_CONVERT_MANAGER}UXXXForm_CurrencyConvertManager,{$ENDIF}
    { COMPONENTES }
    ZSQLProcessor, ZScriptParser, DCPsha512, DCPsha256, DCPsha1, DCPripemd160,
    DCPripemd128, DCPmd5, DCPmd4, DCPhaval, DCPtiger, DCPcrypt2, ZSqlUpdate;

{$R *.dfm}

resourcestring
	RS_POSTERROR = 'Erro ao salvar os dados na tabela "%s".';
	RS_UPDATEERROR = 'Erro ao editar um registro na tabela "%s".';
	RS_DELETEERROR = 'Erro ao deletar um registro da tabela "%s".';
    RS_CANCELUPDATES = 'Deseja descartar as altera��es feitas?';
    RS_ARE_YOU_SURE = 'Tem certeza?';
	RS_DELETE_RECORD = 'Tem certeza de que deseja excluir o registro atual?';
	RS_EZDE = 'Erro ao tentar conectar-se com o banco de dados no m�todo %s.' + CR_LF + CR_LF + '%s';
    RS_EZSE = 'Erro ao executar as instru��es SQL com o m�todo %s.' + CR_LF + CR_LF + '%s';
	RS_SELECT_NOT_ALLOWED = 'Comandos SQL do tipo SELECT n�o s�o aceitos neste par�metro.';
    RS_ONLY_SELECT_ALLOWED = 'Apenas comandos SQL do tipo SELECT ou SHOW s�o aceitos neste par�metro.';
    RS_MULTIPLE_RECORD_MATCHES = 'M�ltiplos registros foram encontrados. Into � uma condi��o de erro, pois chaves t�m de ser �nicas dentro de uma tabela.';
    RS_INCORRECT_DB_PARAMETERS = 'N�o foi poss�vel conectar-se com o banco de dados usando os par�metros especificados. Por favor reinicie a aplica��o e revise as op��es de conex�o com o banco de dados';
    RS_INCORRECT_LOGIN_PARAMETERS = 'Os dados informados para a tabela de usu�rios do sistema est�o incorretos. Por favor reinicie a aplica��o e revise as op��es de tabela de usu�rios do sistema';
    RS_EMPTY_DB_PARAMETERS = 'As op��es de conex�o com o banco de dados n�o foram definidas. Por favor reinicie a aplica��o e revise as op��es de conex�o com o banco de dados';
    RS_EMPTY_LOGIN_PARAMETERS = 'As informa��es sobre a tabela de usu�rios do sistema n�o foram definidas. Por favor reinicie a aplica��o e revise as informa��es sobre a tabela de usu�rios do sistema';
    RS_EMPTY_MORE_PARAMETERS = 'As informa��es adicionais est�o em branco. Por favor reinicie a aplica��o e revise as informa��es adicionais';
    RS_CONFIGURATIONS_CANCELLED = 'As configura��es n�o foram completamente definidas. Por favor reinicie a aplica��o e revise cuidadosamente as op��es de configura��o, pressionando OK quando terminar para confirmar';

    RS_VALIDATION_ERROR = 'Erro de valida��o';
    RS_NO_PERMISSION = 'Permiss�o negada';
    RS_NO_INSERT_PERMISSION = 'Sinto muito, mas voc� n�o tem permiss�o para inserir registros na tabela %s';
    RS_NO_DELETE_PERMISSION = 'Sinto muito, mas voc� n�o tem permiss�o para excluir registros da tabela %s';
    RS_NO_OPEN_PERMISSION   = 'Sinto muito, mas voc� n�o tem permiss�o para ver registros da tabela %s';
    RS_NO_MASTER_RECORDS = 'N�o � poss�vel inserir dados na tabelas %s no momento, pois ainda n�o existem registros em sua tabela mestre (%s). '+'Para poder inserir registros na tabela %0:s, primeiro insira ao menos um registro na tabela %s, ou clique o bot�o "atualizar" associado � mesma de forma que registros sejam exibidos.';
    RS_INVALID_SYSTEM_DATETIME = 'A data e/ou hora do sistema foi alterada de form'+
  	'a que a data e hora da �ltima altera��o na tabela %s (%s) � maior do que a d'+
  	'ata e hora atuais (%s). Isto n�o � permitido pois causa inconsist�ncias em '+
  	'sincroniza��es futuras. Por favor corrija o hor�rio do seu computador'#13#10#13#10 +
  	'OBS.: Se a mudan�a de data e hora do sistema foi proposital devido ao t�rmi'+
  	'no do hor�rio de ver�o considere aguardar o tempo igual �quele que o rel�gi'+
  	'o foi alterado para poder voltar a salvar dados nesta tabela.'#13#10#13#10+
  	'ATEN��O! SE O HOR�RIO DO SEU COMPUTADOR ATRASA SOZINHO COM FREQ��NCIA CONSI'+
  	'DERE TROCAR A BATERIA DE 3V INTERNA. CONSULTE SEU SUPORTE T�CNICO.';
    RS_NO_SQL_ASSIGNED = 'N�o h� SQL atribu�do para a query "%s".';


{ TDataModule_Basic }

var
	Form_AddEntity: TXXXForm_AddEntity;

function TXXXDataModule.GetAddEntitiesForm: TForm;
begin
    Result := Form_AddEntity;
end;

function TXXXDataModule.GetUserEmail(aUserID: Word = 0): String;
const
    SQL =
    'SELECT X[USU.VA_EMAIL]X'#13#10 +
    '  FROM X[USU.USUARIOS]X'#13#10 +
    ' WHERE X[USU.SM_USUARIOS_ID]X = %u';
var
    RODataSet: TZReadOnlyQuery;
begin
	if aUserID = 0 then
		aUserID := Configurations.AuthenticatedUser.Id;

    Result := '';
    RODataSet := nil;

    try
        ConfigureDataSet(DataModuleMain.ZConnections[0].Connection
                        ,RODataSet
                        ,MySQLFormat(ReplaceSystemObjectNames(SQL)
                                    ,[aUserID]));

        if Assigned(RODataSet) then
            Result := RODataSet.Fields[0].AsString;
    finally
        if Assigned(RODataSet) then
            RODataSet.Free;
    end;
end;

function TXXXDataModule.GetUserGroups(UserID: Word = 0): TBytesArray;
var
	UserGroups: TZReadOnlyQuery;
	i: Word;
    ZConnection: TZConnection;
begin
	if UserID = 0 then
		UserID := Configurations.AuthenticatedUser.Id;

	Result := nil;

	UserGroups := nil;
	try
//        if Assigned(MainZConnections) then
        	ZConnection := DataModuleMain.ZConnections[0].Connection;
//        else
//        	ZConnection := ZConnections.ByName['ZConnection_BDO'].Connection;

		ConfigureDataSet(ZConnection,UserGroups,'SELECT TI_GRUPOS_ID FROM GRUPOSDOSUSUARIOS WHERE SM_USUARIOS_ID = ' + IntToStr(UserID));

      	with UserGroups do
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
		if Assigned(UserGroups) then
			FreeAndNil(UserGroups);
	end;
end;

function TXXXDataModule.GetElementByIndex(aIndex: Byte; aElements: array of String): String;
begin
	Result := '';
    if aIndex <= High(aElements) then
    	Result := aElements[aIndex];
end;

function TXXXDataModule.GetEntityID(aZConnection: TZConnection; aEntityName: String; aEntityType: TEntityType): Cardinal;
var
	SearchDataSet: TZReadOnlyQuery;
//    ZConnection: TZConnection;
begin
	Result := 0;
	SearchDataSet := nil;
	try
    	// Se isso der pau, detecte se temos um datamodule main primeiro
//       	ZConnection := FDataModuleAlpha.ZConnections.ByName['ZConnection_BDO'].Connection;

			ConfigureDataSet(aZConnection,SearchDataSet,'SELECT IN_ENTIDADESDOSISTEMA_ID FROM ENTIDADESDOSISTEMA WHERE UPPER(VA_NOME) LIKE ' + QuotedStr(UpperCase(aEntityName)) + ' AND TI_TIPO = ' + IntToStr(Byte(aEntityType)));
        if not SearchDataSet.Eof then
        	Result := SearchDataSet.Fields[0].AsInteger;
	finally
		if Assigned(SearchDataSet) then
      		SearchDataSet.Free;
	end;
end;

class function TXXXDataModule.CmdLineParamValue(const aParamName: String; out aParamValue: String; const aParamStarter: Char = '/'): Boolean;

    function CmdLineParamFound(out aParamIndex: SmallInt): Boolean;
    var
        i: Word;
        sTemp: string;
    begin
        Result := False;
        aParamIndex := -1;
        for i := 1 to ParamCount do
        begin
            sTemp := ParamStr(i);
            if aParamStarter = sTemp[1] then
                if (aParamStarter + UpperCase(aParamName)) = UpperCase(sTemp) then
                begin
                    aParamIndex := i;
                    Result := True;
                    Exit;
                end;
        end;
    end;

var
    ParamIndex: SmallInt;
begin
    aParamValue := '';
    Result := CmdLineParamFound(ParamIndex);
    if Result then
        if ParamIndex < ParamCount then
            aParamValue := ParamStr(Succ(ParamIndex));
end;

class function TXXXDataModule.GetMySQLUserVariable(const aZConnection: TZConnection; aVariableName: String): TMultiTypedResult;
var
	RODataSet: TZReadOnlyQuery;
begin
    RODataSet := nil;
	ZeroMemory(@Result,SizeOf(TMultiTypedResult));
	try

		ConfigureDataSet(aZConnection,RODataSet,'SELECT @' + aVariableName);

        if RODataSet.Fields[0].IsNull then
            raise Exception.Create('A vari�vel "' + aVariableName + '" n�o existe!');

            { TODO -oCarlos Feitoza -cCONSERTE : Melhore isso! est� errado! }
        with Result do
        begin
            AsByte := Byte(RODataSet.Fields[0].AsInteger);
            AsWord := Word(RODataSet.Fields[0].AsInteger);
            AsDWord := RODataSet.Fields[0].AsInteger;
            AsShortInt := ShortInt(RODataSet.Fields[0].AsInteger);
            AsSmallInt := SmallInt(RODataSet.Fields[0].AsInteger);
            AsInteger :=  RODataSet.Fields[0].AsInteger;
            AsInt64 := RODataSet.Fields[0].AsInteger;

            AsChar := RODataSet.Fields[0].AsString[1];
            AsString := RODataSet.Fields[0].AsString;

            AsSingle := RODataSet.Fields[0].AsFloat;
            AsDouble := RODataSet.Fields[0].AsFloat;
            AsCurrency := RODataSet.Fields[0].AsCurrency;

            AsDateTime := RODataSet.Fields[0].AsFloat; { N�o provoca erros! }
        end;
    finally
    	RODataSet.Free;
    end;
end;

//function TDataModule_Basic.GetMySQLUserVariableAsInteger(const aZConnection: TZConnection; aVariableName: String): Int64;
//var
//	RODataSet: TZReadOnlyQuery;
//begin
//	Result := 0;
//	try
//		ConfigureDataSet(aZConnection,RODataSet,'SELECT @' + aVariableName);
//
//        if RODataSet.Fields[0].IsNull then
//            raise Exception.Create('A vari�vel "' + aVariableName + '" n�o existe!');
//
//        Result := RODataSet.Fields[0].AsInteger;
//
//    finally
//    	RODataSet.Free;
//    end;
//end;

function TXXXDataModule.GetPartFromDelimitedString(const aString: String; const aPart: Cardinal; const aDelimiter: Char = '|'; aTempStringList: TStringList = nil): String;
var
    NeedsDestroy: Boolean;
begin
	NeedsDestroy := False;

    if not Assigned(aTempStringList) then
    begin
    	aTempStringList := TStringList.Create;
        NeedsDestroy := True;
    end;

    Result := '';

	try
    	aTempStringList.Clear;
//        aTempStringList.Delimiter := aDelimiter;
//        aTempStringList.DelimitedText := aString;
		aTempStringList.Text := StringReplace(aString,';',#13#10,[rfReplaceAll]);
        if aTempStringList.Count > 0 then
	        Result := aTempStringList[aPart];
    finally
    	if NeedsDestroy and Assigned(aTempStringList) then
        	aTempStringList.Free;
    end;
end;

function TXXXDataModule.GetRecordInformation(const aZConnection: TZConnection; aTableName, aRecordIdColumnName: String; aRecordIdColumnValue: Cardinal): TRecordInformation;
const
    SQL_RECORD_INFORMATION =
    'SELECT TABELA.X[SM_USUARIOCRIADOR_ID]X'#13#10 +
    '     , TABELA.X[DT_DATAEHORADACRIACAO]X'#13#10 +
    '     , CRIADOR.X[USU.VA_NOME]X AS USUARIOCRIADOR'#13#10 +
    '     , TABELA.X[SM_USUARIOMODIFICADOR_ID]X'#13#10 +
    '     , TABELA.X[DT_DATAEHORADAMODIFICACAO]X'#13#10 +
    '     , MODIFICADOR.X[USU.VA_NOME]X AS USUARIOMODIFICADOR'#13#10 +
    '     , TABELA.X[EN_SITUACAO]X'#13#10 +
    '  FROM %S TABELA'#13#10 +
    '  JOIN X[USU.USUARIOS]X CRIADOR ON CRIADOR.X[USU.SM_USUARIOS_ID]X = TABELA.X[SM_USUARIOCRIADOR_ID]X'#13#10 +
    '  JOIN X[USU.USUARIOS]X MODIFICADOR ON MODIFICADOR.X[USU.SM_USUARIOS_ID]X = TABELA.X[SM_USUARIOMODIFICADOR_ID]X'#13#10 +
    ' WHERE TABELA.%S = %D';
var
	RODataSet: TZReadOnlyQuery;
begin
	RODataSet := nil;
    ZeroMemory(@Result,SizeOf(TRecordInformation));
    try
    	ConfigureDataSet(aZConnection,RODataSet,Format(ReplaceSystemObjectNames(SQL_RECORD_INFORMATION),[aTableName,aRecordIdColumnName,aRecordIdColumnValue]),True);
        with Result do
        begin
        	CreatorId := RODataSet.FieldByName(FConfigurations.UserCreatorFieldName).AsInteger;
            CreatorFullName := RODataSet.FieldByName('USUARIOCRIADOR').AsString;
            CreationDateAndTime := RODataSet.FieldByName(FConfigurations.CreationDateAndTimeFieldName).AsDateTime;
            LastModifierId := RODataSet.FieldByName(FConfigurations.UserModifierFieldName).AsInteger;
            LastModifierFullName := RODataSet.FieldByName('USUARIOMODIFICADOR').AsString;
            LastModificationDateAndTime := RODataSet.FieldByName(FConfigurations.ModificationDateAndTimeFieldName).AsDateTime;
            RecordStatus := RODataSet.FieldByName(FConfigurations.RecordStatusFieldName).AsString;
        end;
    finally
    	if Assigned(RODataSet) then
        	RODataSet.Free;
    end;
end;

function TXXXDataModule.HasPermission(aZConnection: TZConnection; aEntityName: String; aUserId: SmallInt = 0; aEntityType: TEntityType = etAction; aPermission: TPermission = pRead): Boolean;
var
	UserPermission, GroupPermission: Boolean;
	EntityID: Integer;

	procedure LoadPermissions(aFiedPermission: String);
	var
		GroupsArray: TBytesArray;
		SearchDataSet: TZReadOnlyQuery;
		GroupID: Word;
		SQL: String;
//        ZConnection: TZConnection;
	begin
//            ZConnection := FDataModuleAlpha.ZConnections.ByName['ZConnection_BDO'].Connection;

		(* Lendo as permiss�es do usu�rio *)
        if aUserId = 0 then
        	aUserId := Configurations.AuthenticatedUser.Id;

		SearchDataSet := nil;
		try
			ConfigureDataSet(aZConnection,SearchDataSet,'SELECT ' + aFiedPermission + ' FROM PERMISSOESDOSUSUARIOS WHERE SM_USUARIOS_ID = ' + IntToStr(aUserId) + ' AND IN_ENTIDADESDOSISTEMA_ID = ' + IntToStr(EntityID));

			if (SearchDataSet.RecordCount = 1) and (not SearchDataSet.Fields[0].isNull) then
            	UserPermission := SearchDataSet.Fields[0].AsInteger = 1;
		finally
			if Assigned(SearchDataSet) then
    			FreeAndNil(SearchDataSet);
		end;

		(* Apenas se o usu�rio n�o tiver permiss�o individualmente � que ser�
        verificada a permiss�o de grupo *)

        (* Lendo as permiss�es dos grupos do usu�rio *)
		if not UserPermission then
		begin
        	(* Obtendo grupos do usu�rio logado *)
			GroupsArray := GetUserGroups(aUserId);

			(* Circulando por entre os grupos do usu�rio logado e verificando se algum
			deles tem a permiss�o requisitada para a entidade requerida *)
			if Length(GroupsArray) > 0 then
			begin
				SearchDataSet := nil;
				try
					SQL :=
					'SELECT SUM(' + aFiedPermission + ') AS PERMISSAO'#13#10 +
					'  FROM PERMISSOESDOSGRUPOS'#13#10 +
					' WHERE TI_GRUPOS_ID IN (';

					for GroupID in GroupsArray do
						SQL := SQL + IntToStr(GroupID) + ', ';

                    Delete(SQL,Length(SQL) - 1,2); { Deleta a v�rgula final }

					SQL := SQL + ')'#13#10 +
					'   AND IN_ENTIDADESDOSISTEMA_ID = ' + IntToStr(EntityID);

          			(* Obtendo todas as permiss�es especificadas por "campo" de
                    todos os grupos dispon�veis para a entidade cuja chave �
                    "ChaveDaEntidadeDoSistema". As permiss�es dos grupos ser�o
                    somadas, logo se apenas um grupo der permissao, haver�
                    permiss�o *)
					SearchDataSet := nil;
					ConfigureDataSet(aZConnection,SearchDataSet,SQL);
                    if (SearchDataSet.RecordCount = 1) and (not SearchDataSet.Fields[0].isNull) then
                    	GroupPermission := SearchDataSet.Fields[0].AsInteger > 0;
				finally
					if Assigned(SearchDataSet) then
						FreeAndNil(SearchDataSet);
				end;
			end;
		end;
	end;
begin
	Result := False;

	(* Se for uma permiss�o n�o permitida sai *)
	if aPermission in [pFull,pNone] then
		Exit;
		
	UserPermission := False;
	GroupPermission := False;
	EntityID := GetEntityID(aZConnection,aEntityName,aEntityType);

	if EntityID > 0 then
	begin
		case aPermission of
			pRead: LoadPermissions('TI_LER');
			pInsert: LoadPermissions('TI_INSERIR');
			pModify: LoadPermissions('TI_ALTERAR');
			pDelete: LoadPermissions('TI_EXCLUIR');
		end;
		(* O resultado � sempre uma soma booleana pois prevalece sempre o true, isto
		�, a permiss�o. Significa que se um usuario tem permissao mas os grupos que
		ele pertence n�o d�o permiss�o, prevalecer� a permissao *)
		Result := UserPermission or GroupPermission;
	end;
end;

procedure TXXXDataModule.HideProcessingForm;
begin
	if Assigned(Form_Processing) then
    	Form_Processing.Close;
end;

procedure TXXXDataModule.ValidateThisAction(aZConnection: TZConnection; Action: ActnList.TAction);
var
	EntityName: string;
begin
	EntityName := UpperCase(Action.ActionList.Owner.Name + '.' + Action.Name);

	if GetAddEntitiesForm <> nil then
	begin
		{ Se for um dos controles de marcar listados associados com a a��o os mant�m
    	desmarcados  ap�s os adicionar  a lista.  Isto s� acontece  quando existe um
        componente  associado a  a��o, pois  quando um menu  � clicado,  n�o existem
		a��es associadas (� como uma a��o pura) }
		if Assigned(Action.ActionComponent) then
        begin
            if Action.ActionComponent.ClassNameIs('TCheckBox') then
            	TCheckBox(Action.ActionComponent).Checked := False
            else if Action.ActionComponent.ClassNameIs('TRadioButton') then
				TRadioButton(Action.ActionComponent).Checked := False
			else if Action.ActionComponent.ClassNameIs('TDBRadioGroup') then
			begin
				FShowCancelQuestion := False;
                TDBRadioGroup(Action.ActionComponent).DataSource.DataSet.Cancel
            end
			else if Action.ActionComponent.ClassNameIs('TDBCheckBox') then
            begin
				FShowCancelQuestion := False;
				TDBCheckBox(Action.ActionComponent).DataSource.DataSet.Cancel;
            end;
        end;

		if GetEntityID(aZConnection,EntityName,etAction) > 0 then //A entidade j� est� cadastrada
        	MessageBox(Application.Handle,PChar('A entidade "' + EntityName + '" j� foi registrada. N�o � preciso registr�-la novamente'), 'Entidade j� registrada', MB_ICONWARNING or MB_OK)
        else
        begin
			if Form_AddEntity.ListBox_EntidadesSelecionadas.Items.IndexOf(EntityName) <> -1 then
				Form_AddEntity.ListBox_EntidadesSelecionadas.ItemIndex := Form_AddEntity.ListBox_EntidadesSelecionadas.Items.IndexOf(EntityName)
            else
				Form_AddEntity.ListBox_EntidadesSelecionadas.Items.Add(EntityName);
    	end;

		Abort;
	end
	else
		if not HasPermission(aZConnection,EntityName) then
        begin
			MessageBox(TForm(Owner).Handle,PChar(RS_NO_ACTION_PERMISSION),'Permiss�o negada',MB_ICONWARNING);
			Abort;
		end;
			(* A verifica��o com "AcabouDeCriar" � necess�ria pois alguns  componentes
			chamam as  suas a��es  automaticamente antes mesmo  do formulario ter sido
			criado. Isso  gerava uma mensagem  para componentes  que para os  quais um
			determinado usu�rio n�o tem permiss�o *)
//			if TFModuloPadrao(Action.Owner).AcabouDeCriar and (not ModuloDeDados.PermissaoParaAEntidade(Action.ActionList.Owner.Name + '.' + Action.Name)) then
//			begin
//				MessageBox(Handle,'Sinto muito, mas voc� n�o tem permiss�o para realizar esta a��o','Permiss�o negada',MB_ICONWARNING);
//				Abort;
//			end;

end;

function TXXXDataModule.MakeLogin(const aZConnection: TZConnection; aExpandedMode: Boolean = False): Boolean;
var
	Form_Login: TXXXForm_Login;
    ZReadOnlyQuery: TZReadOnlyQuery;
begin
	{$IFNDEF LOGINBYPASS}
	Result := False;
    {$ELSE}
    Result := True;
    Exit;
    {$ENDIF}

    try
		with FConfigurations do
        	try
            	ZReadOnlyQuery := nil;
                ConfigureDataSet(aZConnection
                                ,ZReadOnlyQuery
                                ,Format(SQL_SELECT_LOGIN
                                       ,[UserTableKeyFieldName
                                        ,UserTableRealNameFieldName
                                        ,UserTableUserNameFieldName
                                        ,UserTablePasswordFieldName
                                        ,UserTableTableName
                                        ]
                                       )
                                );

                Form_Login := TXXXForm_Login.Create(Self,Form_Login,FConfigurations);
                Form_Login.LoginDataSource.DataSet := ZReadOnlyQuery;
                Form_Login.ExpandedMode := aExpandedMode;

                Result := Form_Login.ShowModal = mrOk;
                if Result then
                	SetMySQLUserVariable(aZConnection,'CURRENTLOGGEDUSER',FConfigurations.AuthenticatedUser.Id);
            except
            	{ O �nico erro que pode dar aqui � por nomes de campo incorretos }
            	NeedsGeneralConfiguration := True;
                raise;
            end;
    finally
    	FreeAndNil(ZReadOnlyQuery);
        Form_Login.Free;
    end;
end;

procedure TXXXDataModule.InitializeConfigurations(const aZConnection: TZConnection; aFormClass: TFormClass; const aBasicConfigurations: TXXXConfigurations; const aPagesToShow: TPagesToShow = [ptsDatabase]);
var
    DatabaseOk, LoginOk, MoreOptionsOk: Boolean;
    ZReadOnlyQuery: TZReadOnlyQuery;
begin
    if (not aBasicConfigurations.NeedsGeneralConfiguration) or (aBasicConfigurations.NeedsGeneralConfiguration and ShowGeneralConfigurationForm(aZConnection,aFormClass,aBasicConfigurations,aPagesToShow)) then

		with aBasicConfigurations do
        begin
	        DatabaseOk := False;
            LoginOk := False;
            MoreOptionsOk := False;

            try
                NeedsGeneralConfiguration := True;
                DatabaseOk := True;
                LoginOk := True;
                MoreOptionsOk := True;

                { Checa as op��es de banco de dados }
                if (ptsAll in aPagesToShow) or (ptsDatabase in aPagesToShow) then
                begin
                	DatabaseOk := False;
                    InitializeZConnection(aZConnection,DBProtocol,DBHostAddr,DBDataBase,DBUserName,DBPassword,DBPortNumb,TZTransactIsolationLevel(DBIsoLevel));
                    SetMySQLUserVariable(aZConnection,'SYNCHRONIZING',False);
					SetMySQLUserVariable(aZConnection,'SERVERSIDE',False);
					SetMySQLUserVariable(aZConnection,'ADJUSTINGDB',False);
                    ExecuteQuery(aZConnection,'CREATE TEMPORARY TABLE IF NOT EXISTS ORPHANFIELDS (MI_ORDEM MEDIUMINT)');
                    DatabaseOk := True;
                end;

                { Checa as op��es de login }
                if (ptsAll in aPagesToShow) or ((ptsDatabase in aPagesToShow) and (ptsLogin in aPagesToShow)) then
                begin
                	LoginOk := False;
                    if (Trim(UserTableKeyFieldName) <> '')
                    and (Trim(UserTableRealNameFieldName) <> '')
                    and (Trim(UserTableUserNameFieldName) <> '')
                    and (Trim(UserTablePasswordFieldName) <> '')
                    and (Trim(UserTableTableName) <> '') then
                    begin
                    	try
	                        try
    	                        ZReadOnlyQuery := nil;
        	                    ConfigureDataSet(aZConnection
            	                                ,ZReadOnlyQuery
                	                            ,Format(SQL_SELECT_LOGIN + ' LIMIT 1'
                    	                               ,[UserTableKeyFieldName
                        	                            ,UserTableRealNameFieldName
                            	                        ,UserTableUserNameFieldName
                                	                    ,UserTablePasswordFieldName
                                    	                ,UserTableTableName
                                        	            ]
                                            	       )
	                                            );
    	                        LoginOk := True;
        	                except
            	                on EZSE: EZSQLException do
                	            begin
                    	            EZSE.Message := RS_INCORRECT_LOGIN_PARAMETERS;
                        	        raise;
                            	end;
	                        end;
                        finally
                            if Assigned(ZReadOnlyQuery) then
                            	FreeAndNil(ZReadOnlyQuery)
                        end;
                    end
                    else
                    	raise Exception.Create(RS_EMPTY_LOGIN_PARAMETERS)
                end;

                { Checa as op��es adicionais }
                if (ptsAll in aPagesToShow) or (ptsOtherOptions in aPagesToShow) then
                begin
                	MoreOptionsOk := False;
                	if True then
                        try
                        	{ Verifica��es aqui! }
                            MoreOptionsOk := True;
                        except
                            on EZSE: EZSQLException do
                            begin
                                EZSE.Message := RS_INCORRECT_LOGIN_PARAMETERS;
                                raise;
                            end;
                        end
                    else
                        raise Exception.Create(RS_EMPTY_MORE_PARAMETERS)
                end;
            finally
                NeedsGeneralConfiguration := not (DatabaseOk and LoginOk and MoreOptionsOk);
            end;
        end
    else
        raise Exception.Create(RS_CONFIGURATIONS_CANCELLED);
end;

class procedure TXXXDataModule.InitializeZConnection(const aZConnection: TZConnection; aProtocol, aHostName, aDatabase, aUser, aPassword: String; aPortNumb: Word; aTransactIsolationLevel: TZTransactIsolationLevel);
begin
	{ TODO 5 -oCarlos Feitoza -cINFORMA��O : Ao se colocar um componente
    ZConnection em um Form ou DataModule, o mesmo inicializa sua propriedade
    "AutoCommit" como true, pois este � seu padr�o. Em contrapartida, ao criar o
    componente dinamicamente, esta propriedade � FALSE. Essa diferen�a deve ser
    considerada quando se desejar usar transa��es. Para usar transa��es esta
    propriedade tem de ser configurada como TRUE. Desta forma todo comando SQL
    persisitir� os dados no banco automaticamente, sendo assim para controlar as
    transa��es as fun��es InTransaction, StartTransaction, Commit e Rollback
    dever�o ser usadas obrigatoriamente }

    if (Trim(aHostName) <> '') and (Trim(aProtocol) <> '') and (Trim(aDatabase) <> '') then
    begin
        aZConnection.Protocol := aProtocol;
        aZConnection.HostName := aHostName;
        aZConnection.Port     := aPortNumb;
        aZConnection.Database := aDatabase;
        aZConnection.User     := aUser;
        aZConnection.Password := aPassword;
        aZConnection.TransactIsolationLevel := aTransactIsolationLevel;

        try
            aZConnection.Connect;
        except
            on EZDE: EZDatabaseError do
            begin
                EZDE.Message := RS_INCORRECT_DB_PARAMETERS;
                raise;
            end;
        end;
    end
    else
        raise Exception.Create(RS_EMPTY_DB_PARAMETERS);
end;

procedure TXXXDataModule.DataModuleCreate(Sender: TObject);
var
	i: Word;
begin
    if ComponentCount > 0 then
    begin
        { TODO : Abaixo estamos inicializando todas as cole��es de componentes
        compartilhaveis }
	    FZConnections := nil;

    	for i := 0 to Pred(ComponentCount) do
    		if Components[i] is TZConnection then
            begin
            	if not Assigned(FZConnections) then
	                FZConnections := TZConnections.Create(TConnection);

        		FZConnections.Add.Connection := TZConnection(Components[i]);
            end
//            else if Components[i] is TBalloonToolTip then
//            begin
//            	if not Assigned(FBalloonToolTips) then
//	                FBalloonToolTips := TBalloonToolTips.Create(UXXXTypesConstantsAndClasses.TBalloonToolTip);
//
//        		FBalloonToolTips.Add.BalloonToolTip := TBalloonToolTip(Components[i]);

//        		FBalloonToolTips.Add.BalloonToolTip := TBalloonToolTip.Create(Application);
//            end;
    end;

    if Trim(FDescription) = '' then
		FDescription := Name;

    { TODO -oCarlos Feitoza -cEXPLICA��O : Todo o bloco TRY s� ser� executado se
    houver ao menos um componente de conex�o. Caso haja coisas dentro deste
    bloco que precisem ser executadas mesmo quando n�o h� conex�es, retire este
    IF e verifique a exist�ncia de uma conex�o em outros lugares dentro do bloco
    try }
    if Assigned(FDataModuleMain.ZConnections) then
        try
            if Assigned(FProgressBarModuleLoad) then
            begin
                FProgressBarModuleLoad.Position := 0;
                { TODO -oCarlos Feitoza -cCONTINUAR : "FProgressBarModuleLoad.Max"
                deve ser carregado com um valor que ser� interagido dentro dos m�tos
                mais adiante. Todos eles somados, tal como est� agora, mas dever�
                ser somado mais outras coisas, principalmente aquilo que � feito em
                ApplySecurityPolicies }
                FProgressBarModuleLoad.Max := GetDataSetCount + GetDataSourceCount + GetActionCount + GetCFDBValidationChecksCount;
                FProgressBarModuleLoad.Show;
            end;

            { 1. criar um m�todo que retorne a quantidade de acoes interposed }
            for i := 0 to Pred(ComponentCount) do
                if Components[i] is _ActnList.TActionList then
                    ApplySecurityPolicies(FDataModuleMain.ZConnections[0].Connection,_ActnList.TActionList(Components[i]));

            { TODO -cCORRE��O : Caso haja um zconnection em um datamodule e este
            seja para ser usado com as queries presentes devemos alterar o evento
            before open para usar tal conex�o }

            SetDefaultEventsToAllDataSets(True);
            SetDefaultEventsToAllDataSources;
            SetDefaultEventsToAllCFDBValidationChecks;
        finally
            if Assigned(FProgressBarModuleLoad) then
                { TODO -oCarlos Feitoza -cEXPLICA��O : O Cast � necess�rio para que
                ao chamar os m�todos de FProgressBarModuleLoad, seja executado
                aqueles que est�o na classe interposer }
                UXXXForm_MainTabbedTemplate.TProgressBar(FProgressBarModuleLoad).Hide;
        end;
end;

procedure TXXXDataModule.DataModuleDestroy(Sender: TObject);
begin
    { Caso haja algum ZConnection neste datamodule a lista foi criada e neste
    caso precisa ser destru�da }
	if Assigned(FZConnections) then
    	FZConnections.Free;
end;

procedure TXXXDataModule.ApplySecurityPolicies(aZConnection: TZConnection; aActionList: _ActnList.TActionList = nil);
var
	Form_ApplyingSecurityPolicies: TForm_ApplyingSecurityPolicies;
    i, j, k, TotalAppDataSets: Word;
    TotalAppActions: Cardinal;
	DataModule_Form: TXXXDataModule;
    ActionList: _ActnList.TActionList;
    DataSetName: String;
begin
	(* Aplicar diretivas de seguran�a em todos os formularios abertos *)
	if not Assigned(aActionList) then
	begin
		(* Sem usuario logado: desabilita tudo *)
		if FConfigurations.AuthenticatedUser.Id = 0 then
            FDataModuleMain.ApplicationActionsEnabled := False
		(* H� usu�rio logado: habilita ou desabilita tudo de acordo com suas
        permiss�es *)
		else
		begin
			try
            	TotalAppActions := FDataModuleMain.TotalApplicationActions;
                TotalAppDataSets := FDataModuleMain.TotalApplicationDataSets;

	            Form_ApplyingSecurityPolicies := TForm_ApplyingSecurityPolicies.Create(Application);

				Form_ApplyingSecurityPolicies.ProgressBar_TotalProgress.Position := 0;
				Form_ApplyingSecurityPolicies.ProgressBar_TotalProgress.Max := TotalAppActions + TotalAppDataSets;
                { ------------------------------------------------------------ }

          		(* No datamodule principal: A��es *)
                if FDataModuleMain.ActionCount > 0 then
                begin
	                Form_ApplyingSecurityPolicies.Label_Total.Caption := FDataModuleMain.Description;
    	            Form_ApplyingSecurityPolicies.Label_Current.Caption := '';
					Form_ApplyingSecurityPolicies.Update;
    	      		Form_ApplyingSecurityPolicies.ProgressBar_CurrentProgress.Position := 0;
        	  		Form_ApplyingSecurityPolicies.ProgressBar_CurrentProgress.Max := FDataModuleMain.ActionCount;

                    for i := 0 to Pred(FDataModuleMain.ComponentCount) do
                    	if FDataModuleMain.Components[i] is _ActnList.TActionList then
                        begin
                        	ActionList := _ActnList.TActionList(FDataModuleMain.Components[i]);
                            if ActionList.ActionCount > 0 then { Os actionlists podem estar vazios! }
                                for j := 0 to Pred(ActionList.ActionCount) do
                                begin
                                    Form_ApplyingSecurityPolicies.Label_Current.Caption := FDataModuleMain.Name + '.' + ActionList.Actions[j].Name;
                                    Form_ApplyingSecurityPolicies.Update;
                                    Form_ApplyingSecurityPolicies.ProgressBar_CurrentProgress.StepIt;
                                    Form_ApplyingSecurityPolicies.ProgressBar_TotalProgress.StepIt;
                                    _ActnList.TAction(ActionList.Actions[j]).SetPermission(HasPermission(aZConnection,Form_ApplyingSecurityPolicies.Label_Current.Caption));
                                end;
                    	end;

//                    for i := 0 to Pred(FDataModuleMain.ActionCount) do
//                    begin
//                        Form_ApplyingSecurityPolicies.Label_Current.Caption := FDataModuleMain.Name + '.' + FDataModuleMain.ActionList_Local.Actions[i].Name;
//                        Form_ApplyingSecurityPolicies.Update;
//                        Form_ApplyingSecurityPolicies.ProgressBar_CurrentProgress.StepIt;
//                        Form_ApplyingSecurityPolicies.ProgressBar_TotalProgress.StepIt;
//                        _ActnList.TAction(FDataModuleMain.ActionList_Local.Actions[i]).SetPermission(HasPermission(aZConnection,Form_ApplyingSecurityPolicies.Label_Current.Caption));
//                    end;
                end;

				(* No datamodule principal: Tabelas e Queries *)
                if FDataModuleMain.DataSetCount > 0 then
                begin
                    Form_ApplyingSecurityPolicies.Label_Current.Caption := '';
                    Form_ApplyingSecurityPolicies.Update;
                    Form_ApplyingSecurityPolicies.ProgressBar_CurrentProgress.Position := 0;
                    Form_ApplyingSecurityPolicies.ProgressBar_CurrentProgress.Max := FDataModuleMain.DataSetCount;

                    for i := 0 to Pred(FDataModuleMain.ComponentCount) do
                    begin
                        if FDataModuleMain.Components[i] is TDataSet then
                        begin
                            Form_ApplyingSecurityPolicies.Label_Current.Caption := TDataset(FDataModuleMain.Components[i]).Name;
                            Form_ApplyingSecurityPolicies.Update;

                            DataSetName := TDataset(FDataModuleMain.Components[i]).Name;
                            { TODO -oCarlos Feitoza -cEXPLICA��O : Antes aqui
                            removia apenas os identificadores "_LOOKUP" E
                            "_SEARCH", o �ltimo par�metro era "7", mas como
                            quero usar coisas do tipo "_LOOKUP_xxx" ou
                            "_SEARCHZZZ", coloquei o length }
                            Delete(DataSetName,Pos('_LOOKUP',DataSetName),Length(DataSetName));
                            Delete(DataSetName,Pos('_SEARCH',DataSetName),Length(DataSetName));

                            TDataset(FDataModuleMain.Components[i]).Active := HasPermission(aZConnection,DataSetName,0,etTable);

                            Form_ApplyingSecurityPolicies.ProgressBar_CurrentProgress.StepIt;
                            Form_ApplyingSecurityPolicies.ProgressBar_TotalProgress.StepIt;

                            if Form_ApplyingSecurityPolicies.ProgressBar_CurrentProgress.Max = Form_ApplyingSecurityPolicies.ProgressBar_CurrentProgress.Position then
                                Break;
                        end;
                    end;
                end;

				(* No page control do formul�rio principal, para cada form aberto *)
				if TXXXForm_MainTabbedTemplate(FDataModuleMain.Owner).PageControl_Main.PageCount > 0 then
                	for i := 0 to Pred(TXXXForm_MainTabbedTemplate(FDataModuleMain.Owner).PageControl_Main.PageCount) do
					begin
						DataModule_Form := TXXXForm_ModuleTabbedTemplate(TXXXForm_MainTabbedTemplate(FDataModuleMain.Owner).PageControl_Main.Pages[i].Components[0]).MyDataModule;
                        (* A��es *)
						if DataModule_Form.ActionCount > 0 then
                        begin
			                Form_ApplyingSecurityPolicies.Label_Total.Caption := DataModule_Form.Description;
    	    		        Form_ApplyingSecurityPolicies.Label_Current.Caption := '';
        	            	Form_ApplyingSecurityPolicies.Update;
		    	      		Form_ApplyingSecurityPolicies.ProgressBar_CurrentProgress.Position := 0;
        			  		Form_ApplyingSecurityPolicies.ProgressBar_CurrentProgress.Max := DataModule_Form.ActionCount;

                            for j := 0 to Pred(DataModule_Form.ComponentCount) do
                                if DataModule_Form.Components[j] is _ActnList.TActionList then
                                begin
                                    ActionList := _ActnList.TActionList(DataModule_Form.Components[j]);
                                    if ActionList.ActionCount > 0 then { Os actionlists podem estar vazios! }
                                        for k := 0 to Pred(ActionList.ActionCount) do
                                        begin
                                            Form_ApplyingSecurityPolicies.Label_Current.Caption := DataModule_Form.Name + '.' + ActionList.Actions[k].Name;
                                            Form_ApplyingSecurityPolicies.Update;
                                            Form_ApplyingSecurityPolicies.ProgressBar_CurrentProgress.StepIt;
                                            Form_ApplyingSecurityPolicies.ProgressBar_TotalProgress.StepIt;
                                            _ActnList.TAction(ActionList.Actions[k]).SetPermission(HasPermission(aZConnection,Form_ApplyingSecurityPolicies.Label_Current.Caption));
                                        end;
                                end;
//							for j := 0 to Pred(DataModule_Basic.ActionCount) do
//			                begin
//								Form_ApplyingSecurityPolicies.Label_Current.Caption := DataModule_Basic.Name + '.' + DataModule_Basic.ActionList_Local.Actions[j].Name;
//			                    Form_ApplyingSecurityPolicies.Update;
//		            	        Form_ApplyingSecurityPolicies.ProgressBar_CurrentProgress.StepIt;
//        			            Form_ApplyingSecurityPolicies.ProgressBar_TotalProgress.StepIt;
//
//			                    _ActnList.TAction(DataModule_Basic.ActionList_Local.Actions[j]).SetPermission(HasPermission(aZConnection,Form_ApplyingSecurityPolicies.Label_Current.Caption));
//                			end;
                        end;

                        (* Tabelas e Queries *)
                        if DataModule_Form.DataSetCount > 0 then
                        begin
                            Form_ApplyingSecurityPolicies.Label_Current.Caption := '';
                            Form_ApplyingSecurityPolicies.Update;
                            Form_ApplyingSecurityPolicies.ProgressBar_CurrentProgress.Position := 0;
                            Form_ApplyingSecurityPolicies.ProgressBar_CurrentProgress.Max := DataModule_Form.DataSetCount;

                            for j := 0 to Pred(DataModule_Form.ComponentCount) do
                            begin
                                if DataModule_Form.Components[j] is TDataSet then
                                begin
                                    Form_ApplyingSecurityPolicies.Label_Current.Caption := TDataset(DataModule_Form.Components[j]).Name;
                                    Form_ApplyingSecurityPolicies.Update;

                                    DataSetName := TDataset(DataModule_Form.Components[j]).Name;
                                    { TODO -oCarlos Feitoza -cEXPLICA��O : Antes aqui
                                    removia apenas os identificadores "_LOOKUP" E
                                    "_SEARCH", o �ltimo par�metro era "7", mas como
                                    quero usar coisas do tipo "_LOOKUP_xxx" ou
                                    "_SEARCHZZZ", coloquei o length }
                                    Delete(DataSetName,Pos('_LOOKUP',DataSetName),Length(DataSetName));
                                    Delete(DataSetName,Pos('_SEARCH',DataSetName),Length(DataSetName));

                                    TDataset(DataModule_Form.Components[j]).Active := HasPermission(aZConnection,DataSetName,0,etTable);
                                    Form_ApplyingSecurityPolicies.ProgressBar_CurrentProgress.StepIt;
                                    Form_ApplyingSecurityPolicies.ProgressBar_TotalProgress.StepIt;

                                    if Form_ApplyingSecurityPolicies.ProgressBar_CurrentProgress.Max = Form_ApplyingSecurityPolicies.ProgressBar_CurrentProgress.Position then
                                        Break;
                                end;
                            end;
                        end;
            		end;
			finally
	            Form_ApplyingSecurityPolicies.Close;
				FreeAndNil(Form_ApplyingSecurityPolicies);
			end;
		end;
	end
	(* Aplicar diretivas de seguran�a apenas nas a��es especificadas *)
	else
	begin
		(* N�o h� usuario logado, nesta caso n�o h� alternativa a n�o ser
        desabilitar tudo chamando essa fun��o novamente e sem par�metros desta
        vez *)
		if FConfigurations.AuthenticatedUser.Id = 0 then
			ApplySecurityPolicies(aZConnection)
		(* Aqui sim! H� um usu�rio logado e deseja-se aplicar diretivas em um
		grupo de a��es especificas *)
        else if aActionList.ActionCount > 0 then
       	(* Aplicando limita��es para cada a��o dispon�vel de acordo com
        fUsuarioLogado *)
        { TODO : 
Caso o tactionlist seja normal, nao sobrescrito, um erro ser� lan�ado aqui
trate isso! }          
			aActionList.ToggleEnabledStatus(emSelective,FProgressBarModuleLoad);
	 end;
//  {$IFDEF DEBUG}
//  ShowMessage('Diretivas aplicadas ao usu�rio "' + fUsuarioLogado.Login + '" (ID:' + IntToStr(fUsuarioLogado.id) + ')');
//  {$ENDIF}
end;

procedure TXXXDataModule.SafeSetActionEnabled(aAction: ActnList.TAction; aEnabled: Boolean);
begin
	if Assigned(aAction) and (aAction.Enabled <> aEnabled) then
		aAction.Enabled := aEnabled;
end;

procedure TXXXDataModule.DBButtonClick(aDataSet: TDataSet; aDBButton: TDBButton; aComponentToFocusOnInsertAndEdit: TWinControl = nil);
begin
	{ TODO : Quanto isto for transformado em um componente os parametros
    aComponentToFocusOnInsertAndEdit e aCurrentForm ser�o removidos. O primeiro
    se tranformar� numa propriedade e o segundo ser� o Owner do component }
    if Assigned(aDataSet) and aDataSet.Active then
        case aDBButton of
            dbbFirst:
            	if aDataSet.State = dsBrowse then
	            	aDataSet.First;
            dbbPrevious:
                if aDataSet.State = dsBrowse then
                    aDataSet.Prior;
            dbbNext:
                if aDataSet.State = dsBrowse then
                    aDataSet.Next;
            dbbLast:
                if aDataSet.State = dsBrowse then
                    aDataSet.Last;
            dbbInsert:
                if aDataSet.State = dsBrowse then
                begin
                    aDataSet.Append;
                    if Assigned(aComponentToFocusOnInsertAndEdit) and aComponentToFocusOnInsertAndEdit.CanFocus then
                        aComponentToFocusOnInsertAndEdit.SetFocus;
                end;
            dbbEdit:
                if (aDataSet.State = dsBrowse) and (aDataSet.RecordCount > 0) then
                begin
                    aDataSet.Edit;
                    if Assigned(aComponentToFocusOnInsertAndEdit) and aComponentToFocusOnInsertAndEdit.CanFocus then
                        aComponentToFocusOnInsertAndEdit.SetFocus;
                end;
            dbbDelete:
                if (aDataSet.State = dsBrowse) and (aDataSet.RecordCount > 0) then
                    aDataSet.Delete;
            dbbPost:
                if aDataSet.State in [dsEdit, dsInsert] then
                begin
                    aDataSet.Post;
                end;
            dbbCancel:
                if aDataSet.State in [dsEdit, dsInsert] then
                    aDataSet.Cancel;
            dbbRefresh:
                if aDataSet.State = dsBrowse then
                    aDataSet.Refresh;
        end;
end;

{ TODO : A fun��o a seguir sumir� quando o componente de bot�es for feito }
procedure TXXXDataModule.DBPButtonsToggle(const aDataSet: TDataSet;
                                          const aPageNo
                                              , aPageCount: Word;
                                            out aButtonFirstEnabled
                                              , aButtonPreviousEnabled
                                              , aButtonNextEnabled
                                              , aButtonLastEnabled: Boolean);
begin
	aButtonFirstEnabled := False;
    aButtonPreviousEnabled := False;
    aButtonNextEnabled := False;
    aButtonLastEnabled := False;

	if aDataSet.Active then
    begin
        aButtonFirstEnabled := (aPageCount <> 0) and (aPageNo > 1) and (aDataSet.State = dsBrowse);
        aButtonPreviousEnabled := aButtonFirstEnabled;
        aButtonNextEnabled := (aPageCount <> 0) and (aPageNo < aPageCount) and (aDataSet.State = dsBrowse);
        aButtonLastEnabled := aButtonNextEnabled;
    end;
end;

{ TODO : A fun��o a seguir sumir� quando o componente de bot�es for feito }
procedure TXXXDataModule.DBButtonsToggle(const aDataSet: TDataSet;
                                           out aButtonFirstEnabled
                                             , aButtonPreviousEnabled
                                             , aButtonNextEnabled
                                             , aButtonLastEnabled
                                             , aButtonInsertEnabled
                                             , aButtonDeleteEnabled
                                             , aButtonEditEnabled
                                             , aButtonPostEnabled
                                             , aButtonCancelEnabled
                                             , aButtonRefreshEnabled: Boolean);
begin
	aButtonFirstEnabled := False;
    aButtonPreviousEnabled := False;
    aButtonNextEnabled := False;
    aButtonLastEnabled := False;
    aButtonInsertEnabled := False;
    aButtonDeleteEnabled := False;
    aButtonEditEnabled := False;
    aButtonPostEnabled := False;
    aButtonCancelEnabled := False;
    aButtonRefreshEnabled := False;

	if aDataSet.Active then
    begin
        aButtonFirstEnabled := (aDataSet.RecordCount <> 0) and (aDataSet.RecNo > 1) and (aDataSet.State = dsBrowse);
        aButtonPreviousEnabled := aButtonFirstEnabled;
        aButtonNextEnabled := (aDataSet.RecordCount <> 0) and (aDataSet.RecNo < aDataSet.RecordCount) and (aDataSet.State = dsBrowse);
        aButtonLastEnabled := aButtonNextEnabled;

    	if (Assigned(aDataSet.DataSource)
        and Assigned(aDataSet.DataSource.DataSet)
        and aDataSet.DataSource.DataSet.Active
        and (aDataSet.DataSource.DataSet.RecordCount <> 0))
        or not Assigned(aDataSet.DataSource) then
    	begin
		    aButtonInsertEnabled := aDataSet.State = dsBrowse;
    		aButtonEditEnabled := (aDataSet.State = dsBrowse) and (aDataSet.RecordCount <> 0);
        end;

        aButtonDeleteEnabled := (aDataSet.State = dsBrowse) and (aDataSet.RecordCount <> 0);
	    aButtonPostEnabled := aDataSet.State in [dsEdit,dsInsert];
    	aButtonCancelEnabled := aButtonPostEnabled;
        aButtonRefreshEnabled := aDataSet.State = dsBrowse;
    end;
end;

{ TODO : A fun��o a seguir sumir� quando o componente de bot�es for feito }
//function TXXXDataModule.DBPageButtonToggle(aDataSet: TDataSet; aDBPageButton: TPageButton; aCurrentPage, aTotalPages: Word): Boolean;
//begin
//	Result := False;
//	if aDataSet.Active then
//		with aDataSet do
//		begin
//			case aDBPageButton of
//				pbPrimeira,
//				pbAnterior : case State of
//					dsBrowse: Result := ((aTotalPages <> 0) and (aCurrentPage > 1));
//					dsEdit, dsInsert: Result := False;
//        end;
//				pbProxima,
//				pbUltima   : case State of
//					dsBrowse: Result := ((aTotalPages <> 0) and (aCurrentPage < aTotalPages));
//					dsEdit,dsInsert: Result := False;
//				end;
//			end;
//		end;
//end;

procedure TXXXDataModule.LogDBActionError(const aZConnection: TZConnection; aDataSet: TDataSet; aEDatabaseError: EDatabaseError);
var
	FileOfDBActionErrors: TFileOfDBActionErrors;
begin
	try
    	FileOfDBActionErrors := TFileOfDBActionErrors.Create(Self);
        with FileOfDBActionErrors.DBActionErrors.Add, FConfigurations do
        begin
        	ActionDateTime := MySQLDBServerDateAndTime(aZConnection);
            ActionUserName := AuthenticatedUser.RealName;
            ActionUserId := AuthenticatedUser.Id;

            case aDataSet.State of
                dsBrowse: ActionTried := atDelete;
                dsEdit: ActionTried := atUpdate;
                dsInsert: ActionTried := atInsert;
            end;

            DatabaseError := aEDatabaseError.Message;
        end;

    finally
       	FreeAndNil(FileOfDBActionErrors);
    end;
end;

function TXXXDataModule.MySQLDBServerDateAndTime(const aZConnection: TZConnection): TDateTime;
var
	RODataSet: TZReadOnlyQuery;
begin
	try
    	RODataSet := nil;
    	ConfigureDataSet(aZConnection,RODataSet,'SELECT SYSDATE()');
        Result := RODataSet.Fields[0].AsDateTime;
  	finally
	  	if Assigned(RODataSet) then
	  		FreeAndNil(RODataSet);
	end;
end;

function TXXXDataModule.MySQLAffectedRows(const aZConnection: TZConnection): Cardinal;
var
	RODataSet: TZReadOnlyQuery;
begin
	try
    	RODataSet := nil;
    	ConfigureDataSet(aZConnection,RODataSet,'SELECT ROW_COUNT()');
        Result := RODataSet.Fields[0].AsInteger;
  	finally
	  	if Assigned(RODataSet) then
	  		FreeAndNil(RODataSet);
	end;
end;


class function TXXXDataModule.MySQLDatabaseCheckSum(const aZConnection: TZConnection;
                                                    const aDatabaseName: String;
                                                    const aTablesToIgnore
                                                        , aFieldsToIgnore: array of String;
                                                          aTempDir: TFileName;
                                                          aOnGetChecksum: TOnGetChecksum): String;
var
	TablesList, TableData: TZReadOnlyQuery;
    i: Byte;
	TableRow, TableDataStr: String;
    TableCheckSum: String;
	TF: TextFile;

function IsIgnoredTable(aTableName: String): Boolean;
var
	i: Byte;
begin
	Result := False;
	for i := 0 to High(aTablesToIgnore) do
    	if UpperCase(aTablesToIgnore[i]) = UpperCase(aTableName) then
        begin
        	Result := True;
            Break;
        end;
end;

function IsIgnoredField(aFieldName: String): Boolean;
var
	i: Byte;
begin
	Result := False;
	for i := 0 to High(aFieldsToIgnore) do
    	if UpperCase(aFieldsToIgnore[i]) = UpperCase(aFieldName) then
        begin
        	Result := True;
            Break;
        end;
end;

begin
	Result := '';
    TablesList := nil;
    TableData := nil;
    try
    	{ Obtendo a lista de tabelas }
        ConfigureDataSet(aZConnection,TablesList,'SHOW FULL TABLES WHERE TABLE_TYPE <> ''VIEW''');
        try
            AssignFile(TF,aTempDir + 'TMPDBCRC.DAT');
            FileMode := fmOpenWrite;
            Rewrite(TF);

            TablesList.First;
            while not TablesList.Eof do
            begin
                if not IsIgnoredTable(TablesList.Fields[0].AsString) then
                begin
                    ConfigureDataSet(aZConnection,TableData,'SELECT * FROM ' + aDatabaseName + '.' + TablesList.Fields[0].AsString);

                    TableDataStr := '';
                    TableData.First;
                    while not TableData.Eof do
                    begin
                        TableRow := '';
                        for i := 0 to Pred(TableData.FieldCount) do
                            if not IsIgnoredField(TableData.Fields[i].FieldName) then
                            	case TableData.Fields[i].DataType of
                                	ftDate, ftTime, ftDateTime: TableRow := TableRow + FloatToStr(TableData.Fields[i].AsFloat);
                                	else
                                    	TableRow := TableRow + TableData.Fields[i].AsString;
                                end;

                        TableDataStr := TableDataStr + TableRow;

                        TableData.Next;
                    end;
                    TableCheckSum := GetStringCheckSum(Trim(TableDataStr),[haMd5]);
                    WriteLn(TF,TableCheckSum);
                    if Assigned(aOnGetChecksum) then
                        aOnGetChecksum(TablesList.Fields[0].AsString,TablesList.RecNo,TablesList.RecordCount,TableCheckSum,False);
                end
                else
                    if Assigned(aOnGetChecksum) then
                        aOnGetChecksum(TablesList.Fields[0].AsString,TablesList.RecNo,TablesList.RecordCount,'',True);

                TablesList.Next;
            end;
        finally
        	CloseFile(TF);
        end;
		{ Obtendo o MD5 do arquivo que cont�m os CheckSums da database }
        with TStringList.Create do
            try
            	LoadFromFile(aTempDir + 'TMPDBCRC.DAT');
                Result := GetStringCheckSum(Trim(Text),[haMd5]);
            	DeleteFile(PChar(aTempDir + 'TMPDBCRC.DAT'));
            finally
                Free;
            end;
    finally
		if Assigned(TablesList) then
			TablesList.Free;
		if Assigned(TableData) then
			TableData.Free;
    end;
end;


//function TXXXDataModule.MySQLDatabaseCheckSum(const aZConnection: TZConnection; const aTablesToIgnore, aFieldsToIgnore: array of String): String;
//var
//	TablesList, TableData: TZReadOnlyQuery;
//    i: Byte;
//	TableRow: String;
//	TF: TextFile;
//
//function IsIgnoredTable(aTableName: String): Boolean;
//var
//	i: Byte;
//begin
//	Result := False;
//	for i := 0 to High(aTablesToIgnore) do
//    	if UpperCase(aTablesToIgnore[i]) = UpperCase(aTableName) then
//        begin
//        	Result := True;
//            Break;
//        end;
//end;
//
//function IsIgnoredField(aFieldName: String): Boolean;
//var
//	i: Byte;
//begin
//	Result := False;
//	for i := 0 to High(aFieldsToIgnore) do
//    	if UpperCase(aFieldsToIgnore[i]) = UpperCase(aFieldName) then
//        begin
//        	Result := True;
//            Break;
//        end;
//end;
//
//begin
//	Result := '';
//    TablesList := nil;
//    TableData := nil;
//
//    if not DirectoryExists(FConfigurations.CurrentDir + '\Temp') then
//    	CreateDir(FConfigurations.CurrentDir + '\Temp');
//
//    try
//    	{ Obtendo a lista de tabelas }
//        ConfigureDataSet(aZConnection,TablesList,'SHOW FULL TABLES WHERE TABLE_TYPE <> ''VIEW''');
//        try
//            AssignFile(TF,FConfigurations.CurrentDir + '\Temp\TMPDBCRC.DAT');
//            FileMode := fmOpenWrite;
//            Rewrite(TF);
//
//            TablesList.First;
//            while not TablesList.Eof do
//            begin
//                if not IsIgnoredTable(TablesList.Fields[0].AsString) then
//                begin
//                    ConfigureDataSet(aZConnection,TableData,'SELECT * FROM ' + FConfigurations.DBDataBase + '.' + TablesList.Fields[0].AsString);
//
//                    TableData.First;
//                    while not TableData.Eof do
//                    begin
//                        TableRow := '';
//                        for i := 0 to Pred(TableData.FieldCount) do
//                            if not IsIgnoredField(TableData.Fields[i].FieldName) then
//                            	case TableData.Fields[i].DataType of
//                                	ftDate, ftTime, ftDateTime: TableRow := TableRow + FloatToStr(TableData.Fields[i].AsFloat);
//                                	else
//                                    	TableRow := TableRow + TableData.Fields[i].AsString;
//                                end;
//
//                        WriteLn(TF,TableRow);
//
//                        TableData.Next;
//                    end;
//                end;
//                TablesList.Next;
//            end;
//        finally
//        	CloseFile(TF);
//        end;
//		{ Obtendo o MD5 do arquivo que cont�m os CheckSums da database }
//        with TStringList.Create do
//            try
//            	LoadFromFile(FConfigurations.CurrentDir + '\Temp\TMPDBCRC.DAT');
//                Result := GetStringCheckSum(Trim(Text),[haMd5]);
//            finally
//                Free;
//            end;
//    finally
//		if Assigned(TablesList) then
//			TablesList.Free;
//		if Assigned(TableData) then
//			TableData.Free;
//    end;
//end;


procedure TXXXDataModule.EqualizeWidthsAndAdjust(const aControls: array of TControl; const aLabels: array of TLabel; const aSeparation: Byte);
var
	TotalWidth, CommonWidth: Word;
	i, DivisionError: Byte;
    UseLabels: Boolean;
begin
	if Length(aControls) > 0 then
	begin
      	if (aSeparation mod 2) = 0 then
        begin
            TotalWidth := aControls[High(aControls)].Left - aControls[0].Left + aControls[High(aControls)].Width;
            DivisionError := TotalWidth mod Length(aControls);
            CommonWidth := (TotalWidth div Length(aControls));
            UseLabels := Length(aLabels) = Length(aControls);

            if not (akRight in aControls[High(aControls)].Anchors)
            or     (akLeft  in aControls[High(aControls)].Anchors) then
                aControls[High(aControls)].Anchors := aControls[High(aControls)].Anchors - [akLeft] + [akRight];

            for i := 0 to High(aControls) do
            begin
                aControls[i].Width := CommonWidth;

                if DivisionError > 0 then
                begin
                    aControls[i].Width := aControls[i].Width + 1;
                    Dec(DivisionError);
                end;

                if (i > 0) and (i < High(aControls)) then // Controles do meio
                begin
                    aControls[i].Width := aControls[i].Width - aSeparation;
                    aControls[i].Left := aControls[Pred(i)].Left + aControls[Pred(i)].Width + aSeparation;
                end
                else if i = 0 then //Controle do incioo
                    aControls[i].Width := aControls[i].Width - aSeparation div 2
                else //Controle do fim
                begin
                    aControls[i].Width := aControls[i].Width - aSeparation div 2;
                    aControls[i].Left := aControls[Pred(i)].Left + aControls[Pred(i)].Width + aSeparation;
                end;

                if UseLabels and Assigned(aLabels[i]) then
                begin
                    aLabels[i].Width := aControls[i].Width;
                    aLabels[i].Left := aControls[i].Left;
                end;
            end;
        end
        else
            raise Exception.Create('A separa��o deve obrigatoriamente ser um valor par');
    end;
end;

function TXXXDataModule.GetMultiTypedResult(const aField: TField): TMultiTypedResult;
begin
    ZeroMemory(@Result,SizeOf(TMultiTypedResult));

    with Result do
    begin
        // Nulo?
        if aField.IsNull then
            IsNull := True
        else
        begin
            DataType := aField.DataType;
            IsNull := False;
            // Inteiro?
            if aField.DataType in [ftSmallint,ftInteger,ftWord,ftLargeint] then
            begin
                AsByte := Byte(aField.AsInteger);
                AsWord := Word(aField.AsInteger);
                AsDWord := aField.AsInteger;
                AsShortInt := ShortInt(aField.AsInteger);
                AsSmallInt := SmallInt(aField.AsInteger);
                AsInteger :=  aField.AsInteger;
                AsInt64 := aField.AsInteger;
                AsChar := aField.AsString[1];
                AsString := aField.AsString;
                AsSingle := aField.AsInteger;
                AsDouble := aField.AsInteger;
                AsCurrency := aField.AsInteger; // Float = Currency = Extended
                AsDateTime := aField.AsInteger;
            end
            // Decimal?
            else if aField.DataType in [ftFloat,ftCurrency] then
            begin
                AsByte := Byte(aField.AsInteger);
                AsWord := Word(aField.AsInteger);
                AsDWord := aField.AsInteger;
                AsShortInt := ShortInt(aField.AsInteger);
                AsSmallInt := SmallInt(aField.AsInteger);
                AsInteger :=  aField.AsInteger;
                AsInt64 := aField.AsInteger;
                AsChar := aField.AsString[1];
                AsString := aField.AsString;
                AsSingle := aField.AsFloat;
                AsDouble := aField.AsFloat;
                AsCurrency := aField.AsFloat; // Float = Currency = Extended
                AsDateTime := aField.AsFloat;
            end
            // Data? Tempo? Data + Tempo?
            else if aField.DataType in [ftDate,ftTime,ftDateTime] then
            begin
                AsByte := Byte(aField.AsInteger);
                AsWord := Word(aField.AsInteger);
                AsDWord := aField.AsInteger;
                AsShortInt := ShortInt(aField.AsInteger);
                AsSmallInt := SmallInt(aField.AsInteger);
                AsInteger :=  aField.AsInteger;
                AsInt64 := aField.AsInteger;
                AsChar := aField.AsString[1];
                AsString := aField.AsString;
                AsSingle := aField.AsFloat;
                AsDouble := aField.AsFloat;
                AsCurrency := aField.AsFloat;
                AsDateTime := aField.AsDateTime;
            end
            // Bin�rio, String ou qualquer outra coisa?
            // Interpreta como string
            else
            begin
                AsByte := 0;
                AsWord := 0;
                AsDWord := 0;
                AsShortInt := 0;
                AsSmallInt := 0;
                AsInteger :=  0;
                AsInt64 := 0;
                AsChar := aField.AsString[1];
                AsString := aField.AsString;
                AsSingle := 0;
                AsDouble := 0;
                AsCurrency := 0;
                AsDateTime := 0;
            end
        end;
    end;
end;

function TXXXDataModule.ExecuteDbFunction(const aZConnection: TZConnection;
                                          const aCallString: String): TMultiTypedResult;
var
	RODataSet: TZReadOnlyQuery;
begin
	RODataSet := nil;
	try
        ConfigureDataSet(aZConnection,RODataSet,'SELECT ' + aCallString);
        Result := GetMultiTypedResult(RODataSet.Fields[0]);
    finally
    	if Assigned(RODataSet) then
			RODataSet.Free;
    end;
end;

procedure TXXXDataModule.ExecuteDbProcedure(const aZConnection: TZConnection; const aCallString: String);
var
	RODataSet: TZReadOnlyQuery;
begin
	RODataSet := nil;
	try
        ExecuteQuery(aZConnection, 'CALL ' + aCallString);
    finally
    	if Assigned(RODataSet) then
			RODataSet.Free;
    end;
end;

procedure TXXXDataModule.ExecuteQuery(const aDBConnection: TZConnection; const aSQLCommand: String);
var
	WODataSet: TZQuery;
  	ComandoSQLLocal: String;
begin
	ComandoSQLLocal := Trim(UpperCase(aSQLCommand));
    WODataSet := nil;
    if Assigned(aDBConnection) then
	    try
    		try
                if Pos('SELECT',ComandoSQLLocal) = 1 then
                    raise EInvalidArgumentData.CreateFmt(RS_INVALID_ARGUMENT_DATA,['aSQLCommand',RS_SELECT_NOT_ALLOWED]);

			    WODataSet := TZQuery.Create(Self);
	            if Assigned(WODataSet) then
                    with WODataSet do
                    begin
                        Connection := aDBConnection;
                        ReadOnly := False;
                        SQL.Text := ComandoSQLLocal;
                        ExecSQL;
                    end;
		    except
			    on EZSE: EZSQLException do
			    begin
				    EZSE.Message := Format(RS_EZSE,['ExecuteQuery',EZSE.Message]);
				    raise;
			    end;

                on EIAD: EInvalidArgumentData do
                begin
                    EIAD.Message := Format(RS_EIAD,['ExecuteQuery',EIAD.Message]);
                    raise;
                end;

			    on E: Exception do
			    begin
				    E.Message := Format(RS_EXC,['ExecuteQuery',E.Message]);
				    raise;
			    end;
		    end;
	    finally
    		if Assigned(WODataSet) then
			    WODataSet.Free;
    	end;
end;

function TXXXDataModule.FileSize(aFileName: TFileName; aFileSizeIn: TFileSizeUnit = fsuBytes): Double;
var
	FOB: file of 0..255;
    FOKB: file of 0..1024;
    FOMB: file of 0..1048576;
    FOGB: file of 0..1073741824;
begin
	Result := 0;
    
	case aFileSizeIn of
    	fsuBytes: try
            AssignFile(FOB,aFileName);
            Reset(FOB);
            Result := System.FileSize(FOB);
        finally
            CloseFile(FOB);
        end;
    	fsuKBytes: try
            AssignFile(FOKB,aFileName);
            Reset(FOKB);
            Result := System.FileSize(FOKB);
        finally
            CloseFile(FOKB);
        end;
    	fsuMBytes: try
            AssignFile(FOMB,aFileName);
            Reset(FOMB);
            Result := System.FileSize(FOMB);
        finally
            CloseFile(FOMB);
        end;
    	fsuGBytes: try
            AssignFile(FOGB,aFileName);
            Reset(FOGB);
            Result := System.FileSize(FOGB);
        finally
            CloseFile(FOGB);
        end;
    end;
end;

procedure TXXXDataModule.InitializeProgress(aProgressBar: ComCtrls.TProgressBar; aLabelPercentDone: TLabel; aMax: Cardinal);
begin
  	aProgressBar.Max := aMax;
  	aProgressBar.Position := 0;
  	aProgressBar.Step := 1;
  	aLabelPercentDone.Caption := '0%';

  	Application.ProcessMessages;
end;

procedure TXXXDataModule.IncreaseProgress(aProgressBar: ComCtrls.TProgressBar; aLabelPercentDone: TLabel);
begin
  	aProgressBar.StepIt;

  	if aProgressBar.Max > 0 then
  		aLabelPercentDone.Caption := Format('%d%%',[Round(aProgressBar.Position / aProgressBar.Max * 100)])
  	else
  		aLabelPercentDone.Caption := '0%';

  	Application.ProcessMessages;
end;

procedure TXXXDataModule.IncreaseProgressWith(aProgressBar: ComCtrls.TProgressBar; aLabelPercentDone: TLabel; aPosition: Cardinal);
begin
	aProgressBar.Position := aPosition;

    if aProgressBar.Max > 0 then
	    aLabelPercentDone.Caption := Format('%d%%',[Round(aProgressBar.Position / aProgressBar.Max * 100)])
    else
    	aLabelPercentDone.Caption := '0%';

  Application.ProcessMessages;
end;

procedure TXXXDataModule.ShowAddEntityForm;
var
	DialogCreateParameters: TDialogCreateParameters;
begin
	ZeroMemory(@DialogCreateParameters,SizeOf(TDialogCreateParameters));
    with DialogCreateParameters do
    begin
        AutoFree := True;
        AutoShow := True;
        FormStyle := fsStayOnTop;
        Modal := False;
        Configurations := FConfigurations;
        MyDataModuleClass := TXXXDataModule_AddEntity;
        MyDataModule := nil;
        DataModuleMain := FDataModuleMain;
    end;
	TXXXForm_DialogTemplate.CreateDialog(Owner
                                        ,Form_AddEntity
                                        ,TXXXForm_AddEntity
                                        ,DialogCreateParameters);
//    TDataModule_AddEntity,nil,instancia,True,False,FConfigurations,FMainDataModule
// dm class,dm instancia, form instancia, AutoFree, Modal, Config, Alpha DM
end;

procedure TXXXDataModule.ShowRecordInformationForm(const aZConnection: TZConnection;
                                                   const aTableName
                                                       , aRecordIdColumnName: String;
                                                   const aRecordIdColumnValue: Cardinal);
var
    RI: TRecordInformation;
	Form_DialogTemplateCreateParameters: TDialogCreateParameters;
    XXXForm_RecordInformation: TXXXForm_RecordInformation;
begin
	RI := GetRecordInformation(aZConnection,aTableName,aRecordIdColumnName,aRecordIdColumnValue);

	ZeroMemory(@Form_DialogTemplateCreateParameters,SizeOf(TDialogCreateParameters));
    with Form_DialogTemplateCreateParameters do
    begin
        AutoFree := True;
        Modal := True;
    end;

    XXXForm_RecordInformation := nil;
    XXXForm_RecordInformation := TXXXForm_RecordInformation.Create(Owner,XXXForm_RecordInformation,Form_DialogTemplateCreateParameters);
    with XXXForm_RecordInformation do
    begin
        TableName := aTableName;
        RecordId := aRecordIdColumnValue;
        CreatorId := RI.CreatorId;
        CreatorFullName := RI.CreatorFullName;
        CreationDateAndTime := RI.CreationDateAndTime;
        LastModifierId := RI.LastModifierId;
        LastModifierFullName := RI.LastModifierFullName;
        LastModificationDateAndTime := RI.LastModificationDateAndTime;
        RecordStatus := RI.RecordStatus;
        ShowModal;
    end;
end;

procedure TXXXDataModule.SaveComboBoxItems(const aComboBox: TCustomComboBox; const aFileName: TFileName);
var
	Exists: Boolean;
    Text: String;
begin
    if aComboBox is TDBComboBox then
        Text := TDBComboBox(aComboBox).Text
    else if aComboBox is TComboBox then
    	Text := TComboBox(aComboBox).Text;

	if Trim(Text) <> '' then
    begin
	  	Exists := aComboBox.Items.IndexOf(Text) > -1;

    	if not Exists then
    		aComboBox.Items.Add(Text);

		aComboBox.Items.SaveToFile(aFileName);
    end;
end;

procedure TXXXDataModule.LoadComboBoxItems(const aComboBox: TCustomComboBox; const aFileName: TFileName);
begin
    aComboBox.Clear;

	if aComboBox is TDBComboBox then
    	TDBComboBox(aComboBox).Sorted := True
    else if aComboBox is TComboBox then
    	TComboBox(aComboBox).Sorted := True;

	if FileExists(aFileName) then
		aComboBox.Items.LoadFromFile(aFileName);
end;

procedure TXXXDataModule.SaveGeneralConfigurations(const aZConnection: TZConnection; aForm: TForm; const aPagesToShow: TPagesToShow; const aBasicConfigurations: TXXXConfigurations);
var
    i: Word;
begin
    with aBasicConfigurations, TXXXForm_GeneralConfiguration(aForm) do
    begin
        { Op��es de banco de dados }
        if (ptsAll in aPagesToShow) or (ptsDatabase in aPagesToShow) then
        begin
            DBProtocol := ComboBoxProtocolo.Items[ComboBoxProtocolo.ItemIndex];
            DBHostAddr := EditEnderecoDoHost.Text;
            DBPortNumb := StrToInt(EditPorta.Text);
            DBDataBase := EditBancoDeDados.Text;
            DBUserName := EditNomeDeUsuario.Text;
            DBPassword := EditSenha.Text;
            DBIsoLevel := Integer(ComboBoxIsolationLevel.Items.Objects[ComboBoxIsolationLevel.ItemIndex]);
        end;

        { Op��es de Login }
        if (ptsAll in aPagesToShow) or (ptsLogin in aPagesToShow) then
        begin
            UserTableTableName := CFEdit_UserTableName.Text;
            UserTableKeyFieldName := CFEdit_KeyFieldName.Text;
            UserTableRealNameFieldName := CFEdit_RealNameFieldName.Text;
            UserTableUserNameFieldName := CFEdit_UserNameFieldName.Text;
            UserTablePasswordFieldName := CFEdit_PasswordFieldName.Text;
            UserTableEmailFieldName := CFEdit_EmailFieldName.Text;
            ExpandedLoginDialog := CheckBox_ExpandedLoginDialog.Checked;
            PasswordCipherAlgorithm := THashAlgorithm(ComboBox_PasswordCipherAlgorithm.ItemIndex);
        end;

        { Mais op��es }
        if (ptsAll in aPagesToShow) or (ptsOtherOptions in aPagesToShow) then
        begin
            UseBalloonsOnValidationErrors := CheckBox_UseBalloons.Checked;
            UseEnterAloneToSearch := CheckBox_UseENTERToSearch.Checked;

            ConvertEnterToTabList.Clear;
            for i := 0 to Pred(CheckListBox_EnterToTab.Count) do
                if CheckListBox_EnterToTab.Checked[i] then
                    ConvertEnterToTabList.Add(CheckListBox_EnterToTab.Items[i]);
        end;
    end;
end;

function TXXXDataModule.LastModifiedOn(aDataSet: TDataSet): TDateTime;
const
	SQL_LASTINSERTEDDATEANDTIME = 'SELECT MAX(DT_DATAEHORADAMODIFICACAO) FROM %s';
var
	RODataSet: TZReadOnlyQuery;
begin
    Result := 0;
    RODataSet := nil;
    try
	    ConfigureDataSet(TZAbstractRODataset(aDataSet).Connection,RODataSet,Format(SQL_LASTINSERTEDDATEANDTIME,[aDataSet.Name]));
        if Assigned(RODataSet) then
	        Result := RODataSet.Fields[0].AsDateTime;
    finally
        if Assigned(RODataSet) then
        	RODataSet.Free;
    end;
end;

procedure TXXXDataModule.LoadGeneralConfigurations(const aZConnection: TZConnection; aForm: TForm; const aPagesToShow: TPagesToShow; const aBasicConfigurations: TXXXConfigurations);
var
    i: Word;
begin
    with aBasicConfigurations, TXXXForm_GeneralConfiguration(aForm) do
    begin
        { Op��es de banco de dados }
        if (ptsAll in aPagesToShow) or (ptsDatabase in aPagesToShow) then
        begin
            TabSheet_DataBaseOptions.TabVisible := True;
            aZConnection.GetProtocolNames(ComboBoxProtocolo.Items);
            ComboBoxProtocolo.ItemIndex := ComboBoxProtocolo.Items.IndexOf(DBProtocol);

            { TODO 5 -oCARLOS -cMELHORIA : Aqui, baseado no protocolo
            devemos implementar uma interface com fun��es espec�ficas de
            banco... Assim poderemos abstrair o que usar e simplesmente
            chamar as fun��es que existirem. Se for MySQL as fun��es de
            MySQL ser�o usadas, etc.! }

            ComboBoxIsolationLevel.Items.AddObject('tiNone',TObject(tiNone));
            ComboBoxIsolationLevel.Items.AddObject('tiReadCommitted',TObject(tiReadCommitted));
            ComboBoxIsolationLevel.Items.AddObject('tiReadUncommitted',TObject(tiReadUncommitted));
            ComboBoxIsolationLevel.Items.AddObject('tiRepeatableRead',TObject(tiRepeatableRead));
            ComboBoxIsolationLevel.Items.AddObject('tiSerializable',TObject(tiSerializable));
            ComboBoxIsolationLevel.ItemIndex := ComboBoxIsolationLevel.Items.IndexOfObject(TObject(DBIsoLevel));

            EditEnderecoDoHost.Text := DBHostAddr;
            EditPorta.Text := IntToStr(DBPortNumb);
            EditBancoDeDados.Text := DBDataBase;
            EditNomeDeUsuario.Text := DBUserName;
            EditSenha.Text := DBPassword;
        end
        else
            TabSheet_DataBaseOptions.TabVisible := False;

        { Op��es de login }
        if (ptsAll in aPagesToShow) or (ptsLogin in aPagesToShow) then
        begin
            TabSheet_LoginOptions.TabVisible := True;
            CFEdit_UserTableName.Text := UserTableTableName;
            CFEdit_KeyFieldName.Text := UserTableKeyFieldName;
            CFEdit_RealNameFieldName.Text := UserTableRealNameFieldName;
            CFEdit_UserNameFieldName.Text := UserTableUserNameFieldName;
            CFEdit_PasswordFieldName.Text := UserTablePasswordFieldName;
            CFEdit_EmailFieldName.Text := UserTableEmailFieldName;
            ComboBox_PasswordCipherAlgorithm.ItemIndex := Byte(PasswordCipherAlgorithm);
            CheckBox_ExpandedLoginDialog.Checked := ExpandedLoginDialog;
        end
        else
            TabSheet_LoginOptions.TabVisible := False;

        { Mais op��es }
        if (ptsAll in aPagesToShow) or (ptsOtherOptions in aPagesToShow) then
        begin
            TabSheet_OtherOptions.TabVisible := True;

            { Pagina 1 }
            CheckBox_UseBalloons.Checked := UseBalloonsOnValidationErrors;
            CheckBox_UseENTERToSearch.Checked := UseEnterAloneToSearch;

            for i := 0 to Pred(CheckListBox_EnterToTab.Count) do
                if ConvertEnterToTabList.IndexOf(CheckListBox_EnterToTab.Items[i]) > -1  then
                    CheckListBox_EnterToTab.Checked[i] := True;
        end
        else
            TabSheet_OtherOptions.TabVisible := False;
    end;
end;

{ TODO : Se este form for chamado a partir da aplica��o dever� haver diferen�a
entre clicar OK ou CANCELAR. Na inicializa�ao do programa o cancelar significa
apenas n�o continuar o carregamento e dentro do programa seu significado � outro }
function TXXXDataModule.ShowGeneralConfigurationForm(const aZConnection: TZConnection; aForm_DialogTemplateClass: TFormClass; const aBasicConfigurations: TXXXConfigurations; const aPagesToShow: TPagesToShow = [ptsDatabase]): Boolean;
var
	Form_GeneralConfiguration: TXXXForm_GeneralConfiguration;
    DialogCreateParameters: TDialogCreateParameters;
begin
	Result := False;
    Form_GeneralConfiguration := nil;
    ZeroMemory(@DialogCreateParameters,SizeOf(TDialogCreateParameters));
    DialogCreateParameters.Modal := True;
    
    try
    	TXXXForm_DialogTemplate.CreateDialog(Self
                                            ,Form_GeneralConfiguration
                                            ,TXXXForm_DialogTemplateClass(aForm_DialogTemplateClass)
                                            ,DialogCreateParameters);

        LoadGeneralConfigurations(aZConnection,Form_GeneralConfiguration,aPagesToShow,aBasicConfigurations);

		Result := Form_GeneralConfiguration.ShowModal = mrOk;

    finally
    	{ Se eu j� tiver conseguido entrar na aplica��o
        NeedsGeneralConfiguration ser� false e o salvamento dos dados depender�
        apenas do result }
    	if Result or FConfigurations.NeedsGeneralConfiguration then
			SaveGeneralConfigurations(aZConnection,Form_GeneralConfiguration,aPagesToShow,aBasicConfigurations);

        Form_GeneralConfiguration.Free;
    end;
end;

//function TXXXDataModule.ShowGeneralConfigurationForm(const aZConnection: TZConnection; aFormClass: TFormClass; const aBasicConfigurations: TXXXConfigurations; const aPagesToShow: TPagesToShow = [ptsDatabase]): Boolean;
//var
//	Form_GeneralConfiguration: TXXXForm_GeneralConfiguration;
//begin
//	Result := False;
//    Form_GeneralConfiguration := nil;
//    try
//    	Form_GeneralConfiguration := TXXXForm_GeneralConfigurationClass(aFormClass).Create(Self,Form_GeneralConfiguration);
//
//        LoadGeneralConfigurations(aZConnection,Form_GeneralConfiguration,aPagesToShow,aBasicConfigurations);
//
//		Result := Form_GeneralConfiguration.ShowModal = mrOk;
//
//    finally
//    	{ Se eu j� tiver conseguido entrar na aplica��o
//        NeedsGeneralConfiguration ser� false e o salvamento dos dados depender�
//        apenas do result }
//    	if Result or FConfigurations.NeedsGeneralConfiguration then
//			SaveGeneralConfigurations(aZConnection,Form_GeneralConfiguration,aPagesToShow,aBasicConfigurations);
//
//        Form_GeneralConfiguration.Free;
//    end;
//end;

procedure TXXXDataModule.ShowProcessingForm(aDescription: String = ''; aShowProgressBar: Boolean = False);
var
	CreateParameters: UForm_Processing.TCreateParameters;
begin
	ZeroMemory(@CreateParameters,SizeOf(UForm_Processing.TCreateParameters));

    with CreateParameters do
    begin
        DialogDescription := aDescription;
        //CommonAnimation: TCommonAVI; { aviNone }
        //AnimationFileName: TFileName;
        ShowProgressBar := aShowProgressBar;
    end;
	TForm_Processing.CreateDialog(Owner,Form_Processing,TForm_Processing,CreateParameters);
end;

function TXXXDataModule.ShowTextsManager(const aFileName: TFileName): String;
var
    XXXForm_TextsManager: TXXXForm_TextsManager;
	CreateParameters: TDialogCreateParameters;
begin
    ZeroMemory(@CreateParameters,SizeOf(TDialogCreateParameters));
    Result := '';

    try
        XXXForm_TextsManager := TXXXForm_TextsManager.Create(Self,XXXForm_TextsManager,CreateParameters);

        XXXForm_TextsManager.FileName := aFileName;

        if XXXForm_TextsManager.ShowModal = mrOk then
            Result := XXXForm_TextsManager.SelectedText;
    finally
        if Assigned(XXXForm_TextsManager) then
            XXXForm_TextsManager.Free;
    end;
end;
{$IFDEF CURRENCY_CONVERT_MANAGER}
function TXXXDataModule.ShowCurrencyConvertManager(const aCurrenciesTaxs: String; const aDestinationCurrency: Byte): String;
var
    XXXForm_CurrencyConvertManager: TXXXForm_CurrencyConvertManager;
	CreateParameters: TDialogCreateParameters;
begin
    ZeroMemory(@CreateParameters,SizeOf(TDialogCreateParameters));
    CreateParameters.MyDataModule := Self;
    Result := '';

    try
        XXXForm_CurrencyConvertManager := TXXXForm_CurrencyConvertManager.Create(Self,XXXForm_CurrencyConvertManager,CreateParameters);

        XXXForm_CurrencyConvertManager.Cotacoes := aCurrenciesTaxs;
        XXXForm_CurrencyConvertManager.DestinationCurrency := aDestinationCurrency;

        if XXXForm_CurrencyConvertManager.ShowModal = mrOk then
            Result := XXXForm_CurrencyConvertManager.Cotacoes;
    finally
        if Assigned(XXXForm_CurrencyConvertManager) then
            XXXForm_CurrencyConvertManager.Free;
    end;
end;{$ENDIF}

procedure TXXXDataModule.ClearDirectoryFrom(aDirectory: String; aRemoveEmptySubDirs: Boolean = False; aMask: String = '*.*');
{ ---------------------------------------------------------------------------- }
procedure SearchTree;
var
    SearchRec: TSearchRec;
    DosError: integer;
begin
    DosError := FindFirst(aMask, 0, SearchRec);
    while DosError = 0 do
    begin
        try
            DeleteFile(PChar(SearchRec.Name));
        except
            on EOOR: EOutOfResources do
            begin
                EOOR.Message := 'A quantidade de arquivos localizados excede o limite de recursos do seu sistema. Favor limitar seu crit�rio de busca escolhendo diret�rio(s) de n�vel mais interno';
                raise;
            end;
        end;
        DosError := FindNext(SearchRec);
    end;

    DosError := FindFirst('*.*', faDirectory, SearchRec);
    while DosError = 0 do
    begin
        if ((SearchRec.attr and faDirectory = faDirectory) and (SearchRec.name <> '.') and (SearchRec.name <> '..')) then
        begin
            ChDir(SearchRec.Name);
            SearchTree;
            ChDir('..');
            if aRemoveEmptySubDirs then
                RemoveDir(SearchRec.Name);
        end;
        DosError := FindNext(SearchRec);
    end;
end;
{ ---------------------------------------------------------------------------- }
begin
	ChDir(aDirectory);
	SearchTree;
end;

class procedure TXXXDataModule.ConfigureDataSet(const aDBConnection: TZConnection; var aDataSet: TZReadOnlyQuery; const aSQLCommand: String; const aAutoCreateDataSet: Boolean = True);
var
	ComandoSQLLocal: String;
begin
	ComandoSQLLocal := Trim(UpperCase(aSQLCommand));

    { Colocando em min�sculo aquilo que tem de ser min�sculo }
    ComandoSQLLocal := StringReplace(ComandoSQLLocal,'\R','\r',[rfReplaceAll]);
    ComandoSQLLocal := StringReplace(ComandoSQLLocal,'\N','\n',[rfReplaceAll]);

    try
        try
            if (Pos('SELECT',ComandoSQLLocal) <> 1)
               and (Pos('SHOW',ComandoSQLLocal) <> 1) then
            	raise EInvalidArgumentData.CreateFmt(RS_INVALID_ARGUMENT_DATA,['aSQLCommand',RS_ONLY_SELECT_ALLOWED]);

            if aAutoCreateDataSet then
            begin
                if Assigned(aDataSet) then
                    aDataSet.Free;

                aDataSet := nil;
                aDataSet := TZReadOnlyQuery.Create(aDBConnection);
            end;

            if Assigned(aDataSet) then
                with aDataSet do
                begin
                	Close;
                    Connection := aDBConnection;
                    SQL.Text := aSQLCommand;
                    Open;
                end;

        except
	        on EAV: EAccessViolation do
    	    begin
        		EAV.Message := Format(RS_EAV,['ConfigureDataSet',EAV.Message]);
		        raise;
        	end;

        	on EZSE: EZSQLException do
	        begin
    		    EZSE.Message := Format(RS_EZSE,['ConfigureDataSet',EZSE.Message]);
		        raise;
	        end;

            on EIAD: EInvalidArgumentData do
            begin
    		    EIAD.Message := Format(RS_EIAD,['ConfigureDataSet',EIAD.Message]);
		        raise;
            end;

    	    on E: Exception do
        	begin
		        E.Message := Format(RS_EXC,['ConfigureDataSet',E.Message]);
		        raise;
        	end;
        end;
    finally
    	{ N�o adianta ter um dataset constru�do se ele n�o sair deste
        procedimento ativado, por isso aqui n�s destru�mos }
	    if Assigned(aDataSet) and not aDataSet.Active then
		    FreeAndNil(aDataSet);
    end;
end;

function TXXXDataModule.ThisRecordExists(const aDBConnection: TZConnection; TableName, KeyName: String; KeyValue: Cardinal): Boolean;
var
    RODataSet: TZReadOnlyQuery;
begin
    RODataSet := nil;
    Result := False;
    try
        ConfigureDataSet(aDBConnection,RODataSet,'SELECT COUNT(*) FROM ' + TableName + ' WHERE ' + KeyName + ' = ' + IntToStr(KeyValue));
        if RODataSet.Fields[0].AsInteger > 1 then
        	raise EUnexpectedInformation.CreateFmt(RS_UNEXPECTED_INFORMATION,[RS_MULTIPLE_RECORD_MATCHES]);

        Result := RODataSet.Fields[0].AsInteger = 1;
    finally
        if Assigned(RODataSet) then
            RODataSet.Free;
    end;
end;

function TXXXDataModule.GetDataSetCount: Byte;
var
	i: Word;
begin
	Result := 0;
	for i := 0 to Pred(ComponentCount) do
        if Components[i] is TDataSet then
        	Inc(Result);
end;

function TXXXDataModule.GetCFDBValidationChecksCount: Byte;
var
	i: Word;
begin
	Result := 0;
	for i := 0 to Pred(ComponentCount) do
        if Components[i] is TCFDBValidationChecks then
        	Inc(Result);
end;

function TXXXDataModule.GetDataSourceCount: Byte;
var
	i: Word;
begin
	Result := 0;
	for i := 0 to Pred(ComponentCount) do
        if Components[i] is TDataSource then
        	Inc(Result);
end;

function TXXXDataModule.GetActionCount: Word;
var
	i: Word;
begin
	Result := 0;
	for i := 0 to Pred(ComponentCount) do
        if Components[i] is _ActnList.TActionList then
        	Inc(Result,_ActnList.TActionList(Components[i]).ActionCount);
end;

{ TODO : Futuramente esta fun��o tem de ser alterada para manipular a�oes em
outros modelos de aplica��o. Atualmente ela considera apenas aplica��es com
m�dulos em TabSheets }
function TXXXDataModule.GetTotalApplicationActions: Cardinal;
var
	i: Word;
    Form_MainTabbedTemplate: TXXXForm_MainTabbedTemplate;
begin
	{ TODO : Como esta fun��o � chamada numa propriedade que � acess�vel apenas
    dentro de TBDODataModule_Connection, podemos considerar aqui que estamos dentro do
    DataModule principal da aplica��o }
	Result := GetActionCount;

    Form_MainTabbedTemplate := TXXXForm_MainTabbedTemplate(Owner);

	if Form_MainTabbedTemplate.PageControl_Main.PageCount > 0 then
		for i := 0 to Pred(Form_MainTabbedTemplate.PageControl_Main.PageCount) do
        	Inc(Result,TXXXForm_ModuleTabbedTemplate(Form_MainTabbedTemplate.PageControl_Main.Pages[i].Components[0]).MyDataModule.ActionCount);
end;

function TXXXDataModule.GetTotalApplicationDataSets: Word;
var
	i: Word;
    Form_MainTabbedTemplate: TXXXForm_MainTabbedTemplate;
begin
	{ TODO : Como esta fun��o � chamada numa propriedade que � acess�vel apenas
    dentro de TBDODataModule_Connection, podemos considerar aqui que estamos dentro do
    DataModule principal da aplica��o }
	Result := GetDataSetCount;

    Form_MainTabbedTemplate := TXXXForm_MainTabbedTemplate(Owner);

	if Form_MainTabbedTemplate.PageControl_Main.PageCount > 0 then
		for i := 0 to Pred(Form_MainTabbedTemplate.PageControl_Main.PageCount) do
        	Inc(Result,TXXXForm_ModuleTabbedTemplate(Form_MainTabbedTemplate.PageControl_Main.Pages[i].Components[0]).MyDataModule.DataSetCount);
end;


procedure TXXXDataModule.SetApplicationActionsEnabled(const aEnabled: Boolean);
var
	i,j: Word;
    EnabledMode: TEnableMode;
    PageControl_Main: TPageControl;
    XXXForm_ModuleTabbedTemplate: TXXXForm_ModuleTabbedTemplate;
begin
	FApplicationActionsEnabled := aEnabled;

    if aEnabled then
    	EnabledMode := emEnable
    else
    	EnabledMode := emDisable;


	(* No Datamodule principal (este datamodule) *)
    for i := 0 to Pred(ComponentCount) do
    	if Components[i] is _ActnList.TActionList then
        	_ActnList.TActionList(Components[i]).ToggleEnabledStatus(EnabledMode);


    PageControl_Main := nil;

    if Owner is TXXXForm_MainTabbedTemplate then
        PageControl_Main := TXXXForm_MainTabbedTemplate(Owner).PageControl_Main;

	(* No page control, para cada form aberto *)
	if Assigned(PageControl_Main) and (PageControl_Main.PageCount > 0) then
		for i := 0 to Pred(PageControl_Main.PageCount) do
        begin
        	XXXForm_ModuleTabbedTemplate := TXXXForm_ModuleTabbedTemplate(PageControl_Main.Pages[i].Components[0]);
        	(* Para cada componente ActionList *)
            for j := 0 to Pred(XXXForm_ModuleTabbedTemplate.MyDataModule.ComponentCount) do
            	if XXXForm_ModuleTabbedTemplate.MyDataModule.Components[j] is _ActnList.TActionList then
                	_ActnList.TActionList(XXXForm_ModuleTabbedTemplate.MyDataModule.Components[j]).ToggleEnabledStatus(EnabledMode);
        end;
//ActionList_Local.ToggleEnabledStatus(EnabledMode);
end;

procedure TXXXDataModule.SetAutoCommit(const aZConnection: TZConnection; const aAutoCommit: Boolean);
begin
	aZConnection.AutoCommit := aAutoCommit;
end;

procedure TXXXDataModule.StartTransaction(const aZConnection: TZConnection);
begin
	if not aZConnection.InTransaction then
		aZConnection.StartTransaction;
end;

procedure TXXXDataModule.RollbackWork(const aZConnection: TZConnection);
begin
	if aZConnection.InTransaction then
		aZConnection.Rollback;
end;

procedure TXXXDataModule.CommitWork(const aZConnection: TZConnection);
begin
	if aZConnection.InTransaction then
		aZConnection.Commit;
end;

procedure TXXXDataModule.SplitSQLScript(const aZConnection: TZConnection;
                                        var aScriptParts: TScriptParts;
                                        const aSQLScriptFile: TFileName;
                                        const aSQLScriptText: String;
//                                        const aForeignKeysCheck: Boolean = True;
                                        const aSplitSQLScriptCallBack: TSplitSQLScriptCallBack = nil);
var
    i: Cardinal;
    Processor: TZSQLProcessor;
    Statement: String;
    SpacePostion, ReturnPosition: Byte;
begin
    if Assigned(aScriptParts) then
    	FreeAndNil(aScriptParts);

    if Trim(aSQLScriptFile) <> '' then
    begin
		if not FileExists(aSQLScriptFile) then
    		raise Exception.Create('O arquivo especificado n�o existe fisicamente');
    end
    else if Trim(aSQLScriptText) = '' then
        raise Exception.Create('Nenhum arquivo ou texto de script foi informado');


    Processor := nil;
    try
    	Screen.Cursor := crHourGlass;
		aScriptParts := TScriptParts.Create(TScriptPart);

        Processor := TZSQLProcessor.Create(nil);
        with Processor do
        begin
        	if Assigned(aSplitSQLScriptCallBack) then
	        	aSplitSQLScriptCallBack(ssseBeforeParse,aScriptParts,Processor);
//            if Assigned(aRichEdit) then
//	            ShowOnLog('� Preprocessando script. Isso pode demorar um pouco...',aRichEdit);

            ParamCheck := False;
    	    DelimiterType := dtSetTerm;
            Delimiter := 'DELIMITER';

            if Trim(aSQLScriptFile) <> '' then
	            LoadFromFile(aSQLScriptFile)
            else
            	Script.Text := aSQLScriptText;

//            if not aForeignKeysCheck then
//            	Script.Text := 'DELIMITER ;'#13#10' SET FOREIGN_KEY_CHECKS = 0;'#13#10 + Processor.Script.Text + #13#10'DELIMITER ;'#13#10'SET FOREIGN_KEY_CHECKS = 1;'
//            else
              Script.Text := 'DELIMITER ;'#13#10 + Script.Text + #13#10'DELIMITER ;';

	        Connection := aZConnection;

        	Parse;

        	if Assigned(aSplitSQLScriptCallBack) then
	            aSplitSQLScriptCallBack(ssseAfterParse,aScriptParts,Processor);
//            if Assigned(aRichEdit) then
//            begin
//	            ShowOnLog('� ' + IntToStr(StatementCount) + ' parte(s) detectada(s)',aRichEdit);
//    	        ShowOnLog('� Iniciando a carga do objeto de manipula��o do script com ' + IntToStr(StatementCount) + ' parte(s)...',aRichEdit);
//            end;

        	if Assigned(aSplitSQLScriptCallBack) then
	        	aSplitSQLScriptCallBack(ssseBeforeSplitOperation,aScriptParts,Processor);

            for i := 0 to Pred(StatementCount) do
            begin
	        	if Assigned(aSplitSQLScriptCallBack) then
					aSplitSQLScriptCallBack(ssseBeforeSplit,aScriptParts,Processor);

                Statement := Statements[i];
                SpacePostion := Pos(#32,Statement);
                ReturnPosition := Pos(#13,Statement);

                if (SpacePostion <> 0) or (ReturnPosition <> 0) then
                    with aScriptParts.Add do
                    begin
                        if SpacePostion > ReturnPosition then
                        begin
                            Delimiter := Copy(Statement,1,Pred(ReturnPosition));
                            Delete(Statement,1,ReturnPosition);
                        end
                        else
                        begin
                            Delimiter := Copy(Statement,1,Pred(SpacePostion));
                            Delete(Statement,1,SpacePostion);
                        end;

                        Script := Trim(Statement);
                    end;

    	    	if Assigned(aSplitSQLScriptCallBack) then
					aSplitSQLScriptCallBack(ssseAfterSplit,aScriptParts,Processor);
            end;

        	if Assigned(aSplitSQLScriptCallBack) then
				aSplitSQLScriptCallBack(ssseAfterSplitOperation,aScriptParts,Processor);
//            if Assigned(aRichEdit) then
//	            ShowOnLog('� O objeto de manipula��o foi carregado com ' + IntToStr(aScriptParts.Count) + ' bloco(s) �til(eis)',aRichEdit);
        end;
    finally
    	if Assigned(Processor) then
        	FreeAndNil(Processor);

        Screen.Cursor := crDefault;
    end;
end;

{ TODO 5 -oCarlos Feitoza -cMELHORIA : O procedure abaixo est� defasado use a
vers�o do FTP Synchronizer }
//procedure TXXXDataModule.MySQLExecuteSQLScript(const aDBConnection: TZConnection; const aFileName: TFileName; const aSQLScript: String = ''; const aParamCheck: Boolean = True; const aForeigKeyCheck: Boolean = True);
//var
//	Processor: TZSQLProcessor;
//begin
//	Processor := nil;
//	try
//	    Processor := TZSQLProcessor.Create(aDBConnection);
//    	Processor.Connection := aDBConnection;
//
//    	Processor.ParamCheck := aParamCheck;
//
//        if not aForeigKeyCheck then
//        	MySQLSetForeignKeyCheck(aDBConnection,False);
//
//        if Trim(aSQLScript) <> '' then
//            Processor.Script.Text := aSQLScript
//        else
//            Processor.Script.LoadFromFile(aFileName);
//
//        SetAutoCommit(aDBConnection,False);
//    	try
//      		Processor.Execute;
//            aDBConnection.Commit;
//    	except
//        	on EZDE: EZDatabaseError do
//            begin
//	            aDBConnection.Rollback;
//            	EZDE.Message := Format(RS_EZDE,['ExecuteSQLScript',EZDE.Message]);
//                raise;
//            end;
//
//            on EZSE: EZSQLException do
//            begin
//            	aDBConnection.Rollback;
//            	EZSE.Message := Format(RS_EZSE,['ExecuteSQLScript',EZSE.Message]);
//                raise;
//            end;
//
//            on E: Exception do
//            begin
//            	aDBConnection.Rollback;
//            	E.Message := Format(RS_EXC,['ExecuteSQLScript',E.Message]);
//                raise;
//            end;
//    	end;
//  	finally
//    	if not aForeigKeyCheck then
//	    	MySQLSetForeignKeyCheck(aDBConnection,True);
//
//    	SetAutoCommit(aDBConnection,True);
//
//        if Assigned(Processor) then
//        	Processor.Free;
//  	end;
//end;

procedure TXXXDataModule.MySQLExecuteSQLScript(const aZConnection: TZConnection;
                                               const aSQLScriptFile: TFileName;
                                               const aSQLScriptText: String;
//                                               const aForeignKeysCheck: Boolean = True;
                                               const aExecuteSQLScriptCallBack: TExecuteSQLScriptCallBack = nil;
                                               const aSplitSQLScriptCallBack: TSplitSQLScriptCallBack = nil);
var
    i: Cardinal;
    Processor: TZSQLProcessor;
    ScriptParts: TScriptParts;
begin
    if Trim(aSQLScriptFile) <> '' then
    begin
		if not FileExists(aSQLScriptFile) then
    		raise Exception.Create('O arquivo especificado n�o existe fisicamente');
    end
    else if Trim(aSQLScriptText) = '' then
    	raise Exception.Create('Nenhum arquivo ou texto de script foi informado');

    try
	    { PASSO 1:  Dividindo o script de acordo com seus delimitadores }
    	ScriptParts := nil;
	    SplitSQLScript(aZConnection
                      ,ScriptParts
                      ,aSQLScriptFile
                      ,aSQLScriptText
//                      ,aForeignKeysCheck
                      ,aSplitSQLScriptCallBack);

    	{ PASSO 2: Executando cada uma das partes do script dividido }
		if ScriptParts.Count > 0 then
        begin
            if aZConnection.Connected then
            begin
                Processor := nil;
                try

                    Processor := TZSQLProcessor.Create(aZConnection);
                    Processor.ParamCheck := False;
                    Processor.Connection := aZConnection;
                    Processor.DelimiterType := dtSetTerm;

                    { TODO -oCarlos Feitoza -cCORRE��O : em ultimo caso passe processorevents como parametro na fun��o callback (eu prefiro que n�o seja assim...) }
		        	if Assigned(aExecuteSQLScriptCallBack) then
	                    aExecuteSQLScriptCallBack(esseBeforeExecuteScript,ScriptParts,Processor);

                    for i := 0 to Pred(ScriptParts.Count) do
                    begin
                        Processor.Clear;
                        Processor.Delimiter := ScriptParts[i].Delimiter;
                        Processor.Script.Text := ScriptParts[i].Script;

			        	if Assigned(aExecuteSQLScriptCallBack) then
  		            		aExecuteSQLScriptCallBack(esseBeforeExecuteScriptPart,ScriptParts,Processor);

                        Processor.Execute;

			        	if Assigned(aExecuteSQLScriptCallBack) then
							aExecuteSQLScriptCallBack(esseAfterExecuteScriptPart,ScriptParts,Processor);
                    end;

		        	if Assigned(aExecuteSQLScriptCallBack) then
	                    aExecuteSQLScriptCallBack(esseAfterExecuteScript,ScriptParts,Processor);
                finally
                    if Assigned(Processor) then
	                    Processor.Free;
                end;
            end;
        end
        else
            raise Exception.Create('O script selecionado n�o � um script v�lido!');
    finally
    	if Assigned(ScriptParts) then
        	ScriptParts.Free
    end;
end;

//procedure TXXXDataModule.MySQLDefragDataBase(const aDBConnection: TZConnection; aProgressBar: TProgressBar = nil; aLabelPercent: TLabel = nil);
//var
//	RODataSet: TZReadOnlyQuery;
//begin
//	RODataSet := nil;
//  	try
//        ConfigureDataSet(aDBConnection,RODataSet,'SHOW FULL TABLES WHERE TABLE_TYPE <> ''VIEW''');
//
//        if Assigned(aProgressBar) then
//        begin
//            aProgressBar.Max := RODataSet.RecordCount;
//            aProgressBar.Position := 0;
//            aProgressBar.Step := 1;
//            if Assigned(aLabelPercent) then
//                aLabelPercent.Caption := '0%';
//        end;
//
//        RODataSet.First;
//
//        while not RODataSet.Eof do
//        begin
//            MySQLExecuteSQLScript(aDBConnection,'','ALTER TABLE ' + RODataSet.Fields[0].AsString + ' ENGINE = InnoDB;');
//
//            if Assigned(aProgressBar) then
//            begin
//                aProgressBar.StepIt;
//                if Assigned(aLabelPercent) then
//                begin
//                    if aProgressBar.Max > 0 then
//                        aLabelPercent.Caption := Format('%d%%',[Round(aProgressBar.Position / aProgressBar.Max * 100)])
//                    else
//                        aLabelPercent.Caption := '0%';
//                end;
//            end;
//            Application.ProcessMessages;
//            RODataSet.Next;
//        end;
//  	finally
//  		if Assigned(RODataSet) then
//    		RODataSet.Free;
// 	end;
//end;

function TXXXDataModule.MySQLReplaceSearchWildcards(const aSQL: String): String;
begin
    Result := StringReplace(aSQL,'_','\_',[rfReplaceAll]);
    Result := StringReplace(Result,'%','\%',[rfReplaceAll]);
    Result := StringReplace(Result,'*','%',[rfReplaceAll]);
    Result := StringReplace(Result,'?','_',[rfReplaceAll]);
end;

{ FOI REMOVIDA POR QUE N�O ESTAVA SENDO USADA E PORQUE GERAVA ERROS DE SINCRONIZA��O
S� PODE SER USADA QUANDO SE TIVER CERTEZA DE QUE N�O HAVER� SINCRONIZA��ES
CONSIDERANDO DADOS ANTIGOS, DO CONTR�RIO PROVOCA PROBLEMAS }

//procedure TXXXDataModule.MySQLDefragDatabase(const aZConnection: TZConnection;
//                                             const aDefragDatabaseCallBack: TDefragDatabaseCallBack = nil);
//var
//	RODataSet: TZReadOnlyQuery;
//begin
//	RODataSet := nil;
//  	try
//        ConfigureDataSet(aZConnection,RODataSet,'SHOW FULL TABLES WHERE TABLE_TYPE <> ''VIEW''');
//
//    	if Assigned(aDefragDatabaseCallBack) then
//	        aDefragDatabaseCallBack(ddeBeforeDefragOperation,RODataSet);
////        if Assigned(aProgressBar) then
////        begin
////            aProgressBar.Position := 0;
////            aProgressBar.Max := RODataSet.RecordCount;
////            aProgressBar.Step := 1;
////        end;
////        if Assigned(aLabelPercentDone) then
////            aLabelPercentDone.Caption := '0%';
//
//        RODataSet.First;
//        while not RODataSet.Eof do
//        begin
//	    	if Assigned(aDefragDatabaseCallBack) then
//    	    	aDefragDatabaseCallBack(ddeBeforeDefrag,RODataSet);
//
//            MySQLExecuteSQLScript(aZConnection,'','ALTER TABLE ' + RODataSet.Fields[0].AsString + ' ENGINE = InnoDB;');
//
//	    	if Assigned(aDefragDatabaseCallBack) then
//				aDefragDatabaseCallBack(ddeAfterDefrag,RODataSet);
////            if Assigned(aProgressBar) then
////                aProgressBar.StepIt;
////
////            if Assigned(aLabelPercentDone) then
////                aLabelPercentDone.Caption := Format('%d%%',[Round(RODataSet.RecNo / RODataSet.RecordCount * 100)]);
////
////            if aUseProcessMessages then
////	            Application.ProcessMessages;
//            RODataSet.Next;
//        end;
//
//    	if Assigned(aDefragDatabaseCallBack) then
//	        aDefragDatabaseCallBack(ddeAfterDefragOperation,RODataSet);
//	finally
//  		if Assigned(RODataSet) then
//    		RODataSet.Free;
//  	end;
//end;

procedure TXXXDataModule.MySQLSetForeignKeyCheck(const aDBConnection: TZConnection; const aForeignKeyCheck: Boolean);
begin
	if aForeignKeyCheck then
		ExecuteQuery(aDBConnection,'SET FOREIGN_KEY_CHECKS = 1;')
    else
  		ExecuteQuery(aDBConnection,'SET FOREIGN_KEY_CHECKS = 0;');
end;

procedure TXXXDataModule.MySQLSetSQLQuoteShowCreate(const aDBConnection: TZConnection; const aSQLQuoteShowCreate: Boolean);
begin
	if aSQLQuoteShowCreate then
		ExecuteQuery(aDBConnection,'SET SQL_QUOTE_SHOW_CREATE = 1;')
    else
  		ExecuteQuery(aDBConnection,'SET SQL_QUOTE_SHOW_CREATE = 0;');
end;

procedure TXXXDataModule.SetDefaultCFDBValidationChecksEvents(const aCFDBValidationChecks: TCFDBValidationChecks);
begin
	aCFDBValidationChecks.OnCustomValidate := DoCustomValidate;
end;

procedure TXXXDataModule.SetDefaultDataSetEvents(aDataSet: TDataset; aOpenDataSet: Boolean);
begin
    aDataSet.BeforeOpen := DoBeforeOpen;
    aDataSet.AfterOpen := DoAfterOpen;
	aDataSet.BeforeEdit := DoBeforeEdit;
	aDataSet.BeforeInsert := DoBeforeInsert;
    aDataSet.AfterClose := DoAfterClose;

    aDataSet.OnNewRecord := DoNewRecord;

	aDataSet.BeforePost := DoBeforePost; { Inserindo ou Atualizando... }
    aDataSet.AfterPost := DoAfterPost; { Inserindo ou Atualizando... }
    aDataSet.BeforeDelete := DoBeforeDelete;
    aDataSet.AfterDelete := DoAfterDelete;
  	aDataSet.BeforeCancel := DoBeforeCancel;

    { Erros de baixo n�vel retornados pelo banco }
	aDataSet.OnPostError := DoDBActionError;
	aDataSet.OnEditError := DoDBActionError;
	aDataSet.OnDeleteError := DoDBActionError;

	if aOpenDataSet and (not aDataSet.Active) then
		aDataSet.Open;
end;

procedure TXXXDataModule.SetDefaultDataSourceEvents(aDataSource: TDataSource);
begin
    aDataSource.OnDataChange := DoDataChange;
    aDataSource.OnStateChange := DoStateChange;
end;

procedure TXXXDataModule.SetDefaultEventsToAllDataSources;
var
    i: Word;
begin
    for i := 0 to Pred(ComponentCount) do
        if Components[i] is TDataSource then
	        try
      	        SetDefaultDataSourceEvents(TDataSource(Components[i]));
        	finally
            	if Assigned(FProgressBarModuleLoad) then
                	FProgressBarModuleLoad.StepIt;
	        end;
end;

procedure TXXXDataModule.SetDefaultEventsToAllDataSets(aOpenDataSet: Boolean);
var
    i: Word;
begin
    for i := 0 to Pred(ComponentCount) do
        if Components[i] is TDataSet then
            try
            	{ TODO -oCarlos Feitoza -cEXPLICA��O : SetDefaultDataSetEvents
                pode gerar uma exce��o que ocorre quando n�o se consegue abrir a
                tabela (EPermissionException). Neste caso deve-se ignorar tal
                exce��o, j� que aqui estamos abrindo as tabelas automaticamente.
                Para outras exce��es o comportamento � o de exibir a mensagem de
                erro }
                try
	                SetDefaultDataSetEvents(TDataSet(Components[i]),aOpenDataSet);
                except
                	on Epe: EPermissionException do
	                	Application.ProcessMessages;
                    else
                    	raise;
                end;
            finally
                if Assigned(FProgressBarModuleLoad) then
                    FProgressBarModuleLoad.StepIt;
            end;
end;

procedure TXXXDataModule.SetDefaultEventsToAllCFDBValidationChecks;
var
    i: Word;
begin
    for i := 0 to Pred(ComponentCount) do
        if Components[i] is TCFDBValidationChecks then
            try
                SetDefaultCFDBValidationChecksEvents(TCFDBValidationChecks(Components[i]));
            finally
                if Assigned(FProgressBarModuleLoad) then
                    FProgressBarModuleLoad.StepIt;
            end;
end;

class procedure TXXXDataModule.SetLabelDescriptionValue(const aLabelDescription, aLabelValue: TLabel; const aValue: String; const aSpacing: Byte = 2);
begin
	aLabelValue.Alignment := taRightJustify;
    aLabelValue.Caption := aValue;
//	aLabelValue.Top := aLabelDescription.Top;
//	aLabelValue.Left := aLabelDescription.Left + aLabelDescription.Width - aLabelValue.Width;
    aLabelDescription.Width := aLabelValue.Left - aLabelDescription.Left - aSpacing;
end;

class procedure TXXXDataModule.SetLabelDescriptionValue(const aLabelDescription: TLabel; const aLabelValue: TDBText; const aSpacing: Byte = 2);
begin
	aLabelValue.Alignment := taRightJustify;
//	aLabelValue.Top := aLabelDescription.Top;
//	aLabelValue.Left := aLabelDescription.Left + aLabelDescription.Width - aLabelValue.Width;
    aLabelDescription.Width := aLabelValue.Left - aLabelDescription.Left - aSpacing;
end;


function TXXXDataModule.GetRowOffsetByPageNo(const aPageNo, aRecordsByPage: Word): Cardinal;
begin
{
    1    |    2    |    3
 ---------------------------
 00   01 | 10   11 | 20   21
 01   02 | 11   12 | 21   22
 02   03 | 12   13 | 22   23
 03   04 | 13   14 | 23   24
 04   05 | 14   15 | 24   25
 05   06 | 15   16 | 25   26
 06   07 | 16   17 | 26   27
 07   08 | 17   18 | 27   28
 08   09 | 18   19 | 28   29
 09   10 | 19   20 | 29   30
}
    Result := Pred(aPageNo) * aRecordsByPage;
end;

function TXXXDataModule.GetRecordNoInSet(const aPageNo, aRecordsByPage, aCurrentRecNo: Word): Cardinal;
begin
    Result := GetRowOffsetByPageNo(aPageNo,aRecordsByPage) + aCurrentRecNo;
end;

procedure TXXXDataModule.GetPageAndRecordMetrics(const aCFDBGrid: TCFDBGrid;
                                                 const aOffset: Byte;
                                                   out aRecordsByPage
                                                     , aPageCount: Word;
                                                   var aPageNo: Word;
                                                   var aRecordCount: Cardinal;
                                                 const aCountSQL: String = '');
var
    RODataSet: TZReadOnlyQuery;
    Remainder: Word;
begin
    aRecordsByPage := Floor((aCFDBGrid.Height - aOffset) / Succ(TDrawGrid(aCFDBGrid).DefaultRowHeight));

    if dgTitles in aCFDBGrid.Options then
    	Dec(aRecordsByPage,TDrawGrid(aCFDBGrid).RowHeights[0] div TDrawGrid(aCFDBGrid).DefaultRowHeight);

    { Ajusta aRecordCount apenas se um SQL de contagem tiver sido informado }
    if Trim(aCountSQL) <> '' then
    begin
        RODataSet := nil;
        Screen.Cursor := crSQLWait;
        try
            ConfigureDataSet(DataModuleMain.ZConnections[0].Connection,RODataSet,UpperCase(Trim(aCountSQL)));
            aRecordCount := RODataSet.Fields[0].AsInteger;
        finally
            Screen.Cursor := crDefault;
            if Assigned(RODataSet) then
                RODataSet.Free;

        end;
    end;

    DivMod(aRecordCount,aRecordsByPage,aPageCount,Remainder);

    if Remainder > 0 then
        Inc(aPageCount);

//    if aPageCount = 0 then
//        aPageCount := 1;

    { Ajusta aPageNo caso esta tenha assumido um valor inv�lido ap�s os c�lculos }
    if aPageNo > aPageCount then
        aPageNo := aPageCount;
end;


procedure TXXXDataModule.DoBeforeCancel(aDataSet: TDataSet);
begin
	try
    	if aDataSet.State in [dsEdit,dsInsert] then
        	if FShowCancelQuestion and (MessageBox(Application.Handle,PChar(RS_CANCELUPDATES),PChar(RS_ARE_YOU_SURE),MB_ICONQUESTION or MB_YESNO) = idNo) then
				Abort;
	finally
		FShowCancelQuestion := True;
	end;
end;

procedure TXXXDataModule.DoBeforeDelete(aDataSet: TDataSet);
begin
	{ TZAbstractRODataset est� acima de todos os TZQuery, TZReadOnlyQuery e
    TZTable }
	if not HasPermission(TZAbstractRODataset(aDataSet).Connection,aDataSet.Name,0,etTable,pDelete) then
    	raise EPermissionException.Create(Format(RS_NO_DELETE_PERMISSION,[aDataSet.Name]));

	try
        if aDataSet.State = dsBrowse then
            if FShowDeleteQuestion and (MessageBox(Application.Handle,PChar(RS_DELETE_RECORD),PChar(RS_ARE_YOU_SURE),MB_ICONQUESTION or MB_YESNO or MB_DEFBUTTON2) = idNo) then
                Abort;
    finally
    	FShowDeleteQuestion := True;
    end;
end;

procedure TXXXDataModule.DoAfterDelete(aDataSet: TDataSet);
begin
	{ Coloque aqui a��es que devem ser realizadas SEMPRE para todo e qualuqer
    DataSet quando o evento AfterDelete for executado }
end;

procedure TXXXDataModule.DoBeforeEdit(aDataSet: TDataSet);
var
    RefreshSQL: String;
begin
    if (aDataSet is TZQuery) and Assigned(TZQuery(aDataSet).UpdateObject) then
    begin
        SetRefreshSQL(TZQuery(aDataSet),dbaBeforeEdit,RefreshSQL);
        TZQuery(aDataSet).UpdateObject.RefreshSQL.Text := RefreshSQL;
    end;

	if not HasPermission(TZAbstractRODataset(aDataSet).Connection,aDataSet.Name,0,etTable,pModify) then
		raise EPermissionException.Create(Format(RS_NO_UPDATE_PERMISSION,[aDataSet.Name]));
end;

procedure TXXXDataModule.SetRefreshSQL(const aZQuery: TZQuery; const aDBAction: TDBAction; out aRefreshSQL: String);
begin
    { Quando necess�rio, em datamodules herdados, configure o refreshsql aqui,
    baseado no dataset. Devemos informar SQLs que retornem todos os campos que
    s�o de alguma forma calculados e que precisem de um refresh imediato ap�s a
    postagem dos dados que podem ter mudado em caso de edi��o e que efetivamente
    mudaram em caso de inser��o. Em modo insert deve-se obter o registro por
    meio de LAST_INSERT_ID ou outra forma de obter tal registro. Em modo edit
    devemos usar o par�metro correspondente � chave prim�ria prefixado por
    "OLD_" a fim de atualizar as informa��es apenas do registro que acabamos de
    editar }
end;

procedure TXXXDataModule.DoBeforeInsert(aDataSet: TDataSet);
var
	LastModifiedDateTime, ActualDateTime: TDateTime;
    RefreshSQL: String;
begin
    if (aDataSet is TZQuery) and Assigned(TZQuery(aDataSet).UpdateObject) then
    begin
        SetRefreshSQL(TZQuery(aDataSet),dbaBeforeInsert,RefreshSQL);
        TZQuery(aDataSet).UpdateObject.RefreshSQL.Text := RefreshSQL;
    end;

    LastModifiedDateTime := LastModifiedOn(aDataSet);
    ActualDateTime := Now;
    
	if not HasPermission(TZAbstractRODataset(aDataSet).Connection,aDataSet.Name,0,etTable,pInsert) then
    	raise EPermissionException.CreateFmt(RS_NO_INSERT_PERMISSION,[aDataSet.Name])
    else if Assigned(aDataSet.DataSource) and (aDataSet.DataSource.DataSet.RecordCount = 0) then
    	raise Exception.CreateFmt(RS_NO_MASTER_RECORDS,[aDataSet.Name,aDataSet.DataSource.DataSet.Name])
    else if LastModifiedDateTime > ActualDateTime then
    	raise Exception.CreateFmt(RS_INVALID_SYSTEM_DATETIME,[aDataSet.Name,FormatDateTime('dd/mm/yyyy hh:nn:ss',LastModifiedDateTime),FormatDateTime('dd/mm/yyyy hh:nn:ss',ActualDateTime)]);
end;

procedure TXXXDataModule.DoDataChange(aSender: TObject; aField: TField);
begin
	{ Coloque aqui a��es que devem ser realizadas SEMPRE para todo e qualquer
    DataSource quando o evento OnDataChange for executado }
end;

function TXXXDataModule.ComparisonOperator(aComparisonOperator: TComparisonOperator): String;
begin
    case aComparisonOperator of
        coNone: Result := '';
        coEqual: Result := '=';
        coLessThan: Result := '<';
        coLessOrEqualThan: Result := '<=';
        coMoreOrEqualThan: Result := '>=';
        coMoreThan: Result := '>';
        coLike: Result := 'LIKE';
    end;
end;

procedure TXXXDataModule.LocateFirstRecord(const aDataSetToLocateIn: TDataSet;
                                           const aEdit: TEdit;
                                           const aFieldName: String);
var
    Achou: Boolean;
begin
    Achou := aDataSetToLocateIn.Locate(aFieldName,aEdit.Text,[loPartialKey,loCaseInsensitive]);

    if not Achou then
    begin
        MessageBeep(MB_OK);
        aEdit.Color := clRed;
        aEdit.Font.Color := clWhite;
    end
    else
    begin
        aEdit.Color := clWindow;
        aEdit.Font.Color := clWindowText;
    end;
end;

function TXXXDataModule.LocateFirstMatchedRecord(const aZConnection: TZConnection;
                                                 const aTableNames: array of String;
                                                 const aLinkFields: array of String;
                                                 const aSearchFieldNames: array of String;
                                                 const aSearchFieldValues: array of const;
                                                 const aComparisonOperators: array of TComparisonOperator;
                                                 const aOrderByFields: array of String;
                                                 const aResultField: String): TMultiTypedResult;
const
	BOOLEAN_STRINGS: array[Boolean] of String = ('False', 'True');
    SQL_FIND =
    '  SELECT %s'#13#10 +
    '    FROM %s' +
    '   WHERE TRUE'#13#10 +
    '%s'+
    'ORDER BY %s'#13#10 +
    '   LIMIT 1';
var
    RODataSet: TZReadOnlyQuery;
    ClausulaWhere: String;
    ClausulaOrderBy, ClausulaFrom: String;
    i: Byte;
begin
    if Length(aTableNames) = 0 then
        raise Exception.Create('N�o � poss�vel realizar uma consulta sem tabelas');

    if Length(aLinkFields) < (Length(aTableNames) - 1) then
        raise Exception.Create('N�o foram informados campos de liga��o suficientes para as tabelas especificadas');

    if Length(aSearchFieldValues) = 0 then
        raise Exception.Create('N�o � poss�vel realizar uma consulta sem um filtro');

	if (Length(aSearchFieldValues) <> Length(aSearchFieldNames))
    or (Length(aSearchFieldValues) <> Length(aComparisonOperators))
    or (Length(aSearchFieldNames) <> Length(aComparisonOperators)) then
    	raise Exception.Create('A quantidade de registros a usar � diferente da quantidade de valores fornecidos ou da quantidade de operadores de compara��o');


    RODataSet := nil;
    ZeroMemory(@Result,SizeOf(TMultiTypedResult));
    ClausulaWhere := '';
    ClausulaOrderBy := '';
    ClausulaFrom := '';

    try
        { Criando a cl�usula FROM }
        ClausulaFrom := aTableNames[0];

        if Length(aTableNames) > 1 then
            for i := 1 to High(aTableNames) do
                ClausulaFrom := ClausulaFrom + #13#10 + '    JOIN ' + aTableNames[i] + ' USING (' + aLinkFields[Pred(i)] + ')';

        ClausulaFrom := ClausulaFrom + #13#10;

        { Criando cl�usula WHERE }
        for i := 0 to High(aSearchFieldValues) do
        begin
            with aSearchFieldValues[i] do
                case VType of
                    vtInteger   : ClausulaWhere := ClausulaWhere + '     AND ' + aSearchFieldNames[i] + ' ' + ComparisonOperator(aComparisonOperators[i]) + ' ' + IntToStr(VInteger);
                    vtBoolean   : ClausulaWhere := ClausulaWhere + '     AND ' + aSearchFieldNames[i] + ' ' + ComparisonOperator(aComparisonOperators[i]) + ' ' + BOOLEAN_STRINGS[VBoolean];
                    vtChar      : ClausulaWhere := ClausulaWhere + '     AND ' + aSearchFieldNames[i] + ' ' + ComparisonOperator(aComparisonOperators[i]) + ' ' + QuotedStr(MySQLReplaceSearchWildcards(VChar));
                    vtExtended  : ClausulaWhere := ClausulaWhere + '     AND ' + aSearchFieldNames[i] + ' ' + ComparisonOperator(aComparisonOperators[i]) + ' ' + MySQLFormat('%g',[VExtended^]);
                    vtString    : ClausulaWhere := ClausulaWhere + '     AND ' + aSearchFieldNames[i] + ' ' + ComparisonOperator(aComparisonOperators[i]) + ' ' + QuotedStr(MySQLReplaceSearchWildcards(VString^));
                    vtPChar     : ClausulaWhere := ClausulaWhere + '     AND ' + aSearchFieldNames[i] + ' ' + ComparisonOperator(aComparisonOperators[i]) + ' ' + QuotedStr(MySQLReplaceSearchWildcards(VPChar));
                    vtObject    : ClausulaWhere := ClausulaWhere + '     AND ' + aSearchFieldNames[i] + ' ' + ComparisonOperator(aComparisonOperators[i]) + ' ' + QuotedStr(MySQLReplaceSearchWildcards(VObject.ClassName));
                    vtClass     : ClausulaWhere := ClausulaWhere + '     AND ' + aSearchFieldNames[i] + ' ' + ComparisonOperator(aComparisonOperators[i]) + ' ' + QuotedStr(MySQLReplaceSearchWildcards(VClass.ClassName));
                    vtAnsiString: ClausulaWhere := ClausulaWhere + '     AND ' + aSearchFieldNames[i] + ' ' + ComparisonOperator(aComparisonOperators[i]) + ' ' + QuotedStr(MySQLReplaceSearchWildcards(String(VAnsiString)));
                    vtCurrency  : ClausulaWhere := ClausulaWhere + '     AND ' + aSearchFieldNames[i] + ' ' + ComparisonOperator(aComparisonOperators[i]) + ' ' + MySQLFormat('%g',[VCurrency^]);
                    vtVariant   : ClausulaWhere := ClausulaWhere + '     AND ' + aSearchFieldNames[i] + ' ' + ComparisonOperator(aComparisonOperators[i]) + ' ' + String(VVariant^); { problem�tico! }
                    vtInt64     : ClausulaWhere := ClausulaWhere + '     AND ' + aSearchFieldNames[i] + ' ' + ComparisonOperator(aComparisonOperators[i]) + ' ' + IntToStr(VInt64^);
                end;

            ClausulaWhere := ClausulaWhere + #13#10;
        end;

        { Criando a cl�usula ORDER BY }
        if Length(aOrderByFields) > 0 then
            for i := 0 to High(aOrderByFields) do
            begin
                ClausulaOrderBy := ClausulaOrderBy + aOrderByFields[i];
                if i < High(aOrderByFields) then
                    ClausulaOrderBy := ClausulaOrderBy + ',';
            end;

        ConfigureDataSet(aZConnection,RODataSet,Format(SQL_FIND,[aResultField,ClausulaFrom,ClausulaWhere,ClausulaOrderBy]));
        if not RODataSet.IsEmpty then
            { TODO -oCarlos Feitoza -cCONSERTE : Melhore isso! est� errado! }
            with Result do
            begin
                AsByte := Byte(RODataSet.Fields[0].AsInteger);
                AsWord := Word(RODataSet.Fields[0].AsInteger);
                AsDWord := RODataSet.Fields[0].AsInteger;
                AsShortInt := ShortInt(RODataSet.Fields[0].AsInteger);
                AsSmallInt := SmallInt(RODataSet.Fields[0].AsInteger);
                AsInteger :=  RODataSet.Fields[0].AsInteger;
                AsInt64 := RODataSet.Fields[0].AsInteger;

                AsChar := RODataSet.Fields[0].AsString[1];
                AsString := RODataSet.Fields[0].AsString;

                AsSingle := RODataSet.Fields[0].AsFloat;
                AsDouble := RODataSet.Fields[0].AsFloat;
                AsCurrency := RODataSet.Fields[0].AsCurrency;

                AsDateTime := RODataSet.Fields[0].AsFloat; { N�o provoca erros! }
            end;
    finally
        if Assigned(RODataSet) then
            RODataSet.Free;
    end;
end;

procedure TXXXDataModule.DoDataChangeForAllDataSources;
var
	i: Word;
begin
    for i := 0 to Pred(ComponentCount) do
        if Components[i] is TDataSource then
            try
            	DoDataChange(TDataSource(Components[i]),nil);
            except
                Application.ProcessMessages;
            end;
end;

procedure TXXXDataModule.DoStateChange(aSender: TObject);
begin
	{ Coloque aqui a��es que devem ser realizadas SEMPRE para todo e qualuqer
    DataSource quando o evento OnStateChange for executado }
end;

procedure TXXXDataModule.DoAfterOpen(aDataSet: TDataSet);
begin
	{ Coloque aqui a��es que devem ser realizadas SEMPRE para todo e qualquer
    DataSet quando o evento AfterOpen for executado }
end;

procedure TXXXDataModule.DoNewRecord(aDataSet: TDataSet);
begin
	{ Coloque aqui a��es que devem ser realizadas SEMPRE para todo e qualquer
    DataSet quando o evento OnNewRecord for executado }
end;

procedure TXXXDataModule.DoAfterClose(aDataSet: TDataSet);
begin
	{ Coloque aqui a��es que devem ser realizadas SEMPRE para todo e qualquer
    DataSet quando o evento AfterClose for executado }
end;

{ TODO -oCarlos Feitoza : Esse m�todo deve ser sobrescrito nos datamodules que
precisem usar ZConnections customizados do contr�rio o componente ZConnection
utilizado ser� o ZConnection principal de DataModule_Alpha }
procedure TXXXDataModule.DoBeforeOpen(aDataSet: TDataSet);
var
	SQL: String;
    DataSetName: String;
begin
	TZAbstractRODataset(aDataSet).Connection := FDataModuleMain.ZConnections[0].Connection;

    { Verificando a exist�ncia de um SQL }
    if aDataSet is TZReadOnlyQuery then
	    SQL := Trim(TZReadOnlyQuery(aDataSet).SQL.Text)
    else if aDataSet is TZQuery then
    	SQL := Trim(TZQuery(aDataSet).SQL.Text);

    if SQL = '' then
    	raise Exception.CreateFmt(RS_NO_SQL_ASSIGNED,[aDataSet.Name]);

    { Substituindo nomes das tabelas e campos do sistema }
    { TODO -oCarlos Feitoza : Os validadores n�o est�o sendo alterados aqui.
    Isso pode causar problemas }
    if aDataSet is TZReadOnlyQuery then
    	TZReadOnlyQuery(aDataSet).SQL.Text := ReplaceSystemObjectNames(SQL)
    else if aDataSet is TZQuery then
    begin
    	TZQuery(aDataSet).SQL.Text := ReplaceSystemObjectNames(SQL);
        ReplaceSystemObjectNames(TZQuery(aDataSet));
        if Assigned(TZQuery(aDataSet).UpdateObject) then
        	with TZQuery(aDataSet).UpdateObject do
            begin
        		InsertSQL.Text := ReplaceSystemObjectNames(InsertSQL.Text);
        		ModifySQL.Text := ReplaceSystemObjectNames(ModifySQL.Text);
        		DeleteSQL.Text := ReplaceSystemObjectNames(DeleteSQL.Text);
                RefreshSQL.Text := ReplaceSystemObjectNames(RefreshSQL.Text);
        	end;
    end;
    
    { � necess�rio comparar o nome do dataset com os poss�veis nomes que
    correspondem a tabelas f�sicas. Estes nomes s�o LOOKUP e SEARCH. O primeiro
    � um ZReadOnlyQuery usado em LookUps e o segundo � usado para consultas. O
    formato usado para nomear deve ser XXX_LOOKUP e XXX_SEARCH, onde XXX deve
    ser o nome de uma tabela f�sica para qual as permiss�es foram atribu�das.
    Deve-se portanto remover do nome do datasert a refer�ncia a estes tipos
    especiais, sobrando apenas o nome real do dataset para ser comparado }
    DataSetName := aDataSet.Name;
    { TODO -oCarlos Feitoza -cEXPLICA��O : Antes aqui removia apenas os
    identificadores "_LOOKUP" E "_SEARCH", o �ltimo par�metro era "7", mas como
    quero usar coisas do tipo "_LOOKUP_xxx" ou "_SEARCHZZZ", coloquei o length }
    Delete(DataSetName,Pos('_LOOKUP',DataSetName),Length(DataSetName));
    Delete(DataSetName,Pos('_SEARCH',DataSetName),Length(DataSetName));

    { A verifica��o de permiss�o tem de ficar aqui pois, mesmo que n�o se tenha
    permiss�o para visualizar os dados de uma tabela suas propriedades tem de
    ser preenchidas. Isso � necess�rio para o caso de haver uma tabela extra que
    precise ser aberta manualmente }
	if not HasPermission(FDataModuleMain.ZConnections[0].Connection,DataSetName,0,etTable,pRead) then
    	//Abort; { TODO : Aqui tava abort, mas eu acho que o correto � o codigo atual, que estava comentado }
        { acho que tinha colocado abort para que eu pudesse colocar qualquer tabela de forma que eu pudesse abrir manualmente }
        raise EPermissionException.Create(Format(RS_NO_OPEN_PERMISSION,[aDataSet.Name]));
end;

procedure TXXXDataModule.DoBeforePost(aDataSet: TDataSet);
begin
    case aDataSet.State of
    	dsInsert: if not HasPermission(TZAbstractRODataset(aDataSet).Connection,aDataSet.Name,0,etTable,pInsert) then
        	raise EPermissionException.Create(Format(RS_NO_INSERT_PERMISSION,[aDataSet.Name]));
        dsEdit  : if not HasPermission(TZAbstractRODataset(aDataSet).Connection,aDataSet.Name,0,etTable,pModify) then
			raise EPermissionException.Create(Format(RS_NO_UPDATE_PERMISSION,[aDataSet.Name]));
    end;
end;

procedure TXXXDataModule.DoAfterPost(aDataSet: TDataSet);
begin
    { Coloque aqui coisas que tem de ser feitas SEMPRE que se consegue postar os
    dados }
end;

procedure TXXXDataModule.DoCustomValidate(const aSender: TObject; const aValidateAction: TValidateAction; const aValidateMoment: TValidateMoment);
var
	i: Byte;
begin
    TCFDBValidationChecks(aSender).TableName := ReplaceSystemObjectNames(TCFDBValidationChecks(aSender).TableName);
    TCFDBValidationChecks(aSender).KeyField := ReplaceSystemObjectNames(TCFDBValidationChecks(aSender).KeyField);
	TCFDBValidationChecks(aSender).DependentTables.Text := ReplaceSystemObjectNames(TCFDBValidationChecks(aSender).DependentTables.Text);
    for i := 0 to Pred(TCFDBValidationChecks(aSender).CheckableFields.Count) do
    	TCFDBValidationChecks(aSender).CheckableFields[i].FieldName := ReplaceSystemObjectNames(TCFDBValidationChecks(aSender).CheckableFields[i].FieldName);
end;

function TXXXDataModule.IsValidDataWareComponent(aComponent: TComponent; out aDataSet: TDataSet; out aDataField: TField): Boolean;
begin
	aDataSet := nil;
	aDataField := nil;
	Result := False;

	if aComponent is TDBEdit then
	begin
		Result := Assigned(TDBEdit(aComponent).DataSource)
                  and Assigned(TDBEdit(aComponent).DataSource.DataSet)
                  and Assigned(TDBEdit(aComponent).Field);

		if Result then
		begin
			aDataSet := TDBEdit(aComponent).DataSource.DataSet;
			aDataField := TDBEdit(aComponent).Field;
		end;
	end
	else if aComponent is TDBMemo then
	begin
		Result := Assigned(TDBMemo(aComponent).DataSource)
                  and Assigned(TDBMemo(aComponent).DataSource.DataSet)
                  and Assigned(TDBMemo(aComponent).Field);

		if Result then
		begin
			aDataSet := TDBMemo(aComponent).DataSource.DataSet;
			aDataField := TDBMemo(aComponent).Field;
		end;
	end
	else if aComponent is TDBImage then
	begin
		Result := Assigned(TDBImage(aComponent).DataSource)
                  and Assigned(TDBImage(aComponent).DataSource.DataSet)
                  and Assigned(TDBImage(aComponent).Field);

		if Result then
		begin
			aDataSet := TDBImage(aComponent).DataSource.DataSet;
			aDataField := TDBImage(aComponent).Field;
		end;
	end
	else if aComponent is TDBListBox then
	begin
		Result := Assigned(TDBListBox(aComponent).DataSource)
                  and Assigned(TDBListBox(aComponent).DataSource.DataSet)
                  and Assigned(TDBListBox(aComponent).Field);

		if Result then
		begin
			aDataSet := TDBListBox(aComponent).DataSource.DataSet;
			aDataField := TDBListBox(aComponent).Field;
		end;
	end
	else if aComponent is TDBComboBox then
	begin
		Result := Assigned(TDBComboBox(aComponent).DataSource)
                  and Assigned(TDBComboBox(aComponent).DataSource.DataSet)
                  and Assigned(TDBComboBox(aComponent).Field);

		if Result then
		begin
			aDataSet := TDBComboBox(aComponent).DataSource.DataSet;
			aDataField := TDBComboBox(aComponent).Field;
		end;
	end
	else if aComponent is TDBCheckBox then
	begin
		Result := Assigned(TDBCheckBox(aComponent).DataSource)
                  and Assigned(TDBCheckBox(aComponent).DataSource.DataSet)
                  and Assigned(TDBCheckBox(aComponent).Field);

		if Result then
		begin
			aDataSet := TDBCheckBox(aComponent).DataSource.DataSet;
			aDataField := TDBCheckBox(aComponent).Field;
		end;
	end
	else if aComponent is TDBRadioGroup then
	begin
		Result := Assigned(TDBRadioGroup(aComponent).DataSource)
                  and Assigned(TDBRadioGroup(aComponent).DataSource.DataSet)
                  and Assigned(TDBRadioGroup(aComponent).Field);

		if Result then
		begin
			aDataSet := TDBRadioGroup(aComponent).DataSource.DataSet;
			aDataField := TDBRadioGroup(aComponent).Field;
		end;
	end
	else if aComponent is TDBLookupListBox then
	begin
		Result := Assigned(TDBLookupListBox(aComponent).DataSource)
                  and Assigned(TDBLookupListBox(aComponent).DataSource.DataSet)
                  and Assigned(TDBLookupListBox(aComponent).Field);

		if Result then
		begin
			aDataSet := TDBLookupListBox(aComponent).DataSource.DataSet;
			aDataField := TDBLookupListBox(aComponent).Field;
		end;
	end
	else if aComponent is TDBLookupComboBox then
	begin
		Result := Assigned(TDBLookupComboBox(aComponent).DataSource)
                  and Assigned(TDBLookupComboBox(aComponent).DataSource.DataSet)
                  and Assigned(TDBLookupComboBox(aComponent).Field);

		if Result then
		begin
			aDataSet := TDBLookupComboBox(aComponent).DataSource.DataSet;
			aDataField := TDBLookupComboBox(aComponent).Field;
		end;
	end
	else if aComponent is TDBRichEdit then
	begin
		Result := Assigned(TDBRichEdit(aComponent).DataSource)
                  and Assigned(TDBRichEdit(aComponent).DataSource.DataSet)
                  and Assigned(TDBRichEdit(aComponent).Field);

		if Result then
		begin
			aDataSet := TDBRichEdit(aComponent).DataSource.DataSet;
			aDataField := TDBRichEdit(aComponent).Field;
    	end;
	end
	else if aComponent is TDBGrid then
	begin
		Result := Assigned(TDBGrid(aComponent).DataSource)
                  and Assigned(TDBGrid(aComponent).DataSource.DataSet);
		if Result then
			aDataSet := TDBGrid(aComponent).DataSource.DataSet;
	end;
end;

procedure TXXXDataModule.ShowBalloonToolTipValidationFor(aCurrentForm: TForm; aDataSet: TDataSet; aFieldError: TField);
var
	i: Word;
	Componente: TComponent;
	DataSet: TDataSet;
	DataField: TField;
    BTT: TBalloonToolTip;
begin
	BTT := TXXXForm_MainTabbedTemplate(FDataModuleMain.Owner).BalloonToolTip_Validation;

	for i := 0 to Pred(aCurrentForm.ComponentCount) do
	begin
		Componente := aCurrentForm.Components[i];

		if not IsValidDataWareComponent(Componente,DataSet,DataField) then
        	Continue;

        if (DataSet <> aDataSet) or (DataField <> aFieldError) then
        	Continue;

        if Componente is TDBEdit then
        begin
	        BTT.AssociatedWinControl := TDBEdit(Componente);
    	    BTT.Show;
            Break;
        end
        else if Componente is TDBMemo then
        begin
  	        BTT.AssociatedWinControl := TDBMemo(Componente);
            BTT.Show;
            Break;
        end
        else if Componente is TDBImage then
        begin
            BTT.AssociatedWinControl := TDBImage(Componente);
            BTT.Show;
            Break;
        end
        else if Componente is TDBListBox then
        begin
            BTT.AssociatedWinControl := TDBListBox(Componente);
            BTT.Show;
            Break;
        end
        else if Componente is TDBComboBox then
        begin
            BTT.AssociatedWinControl := TDBComboBox(Componente);
            BTT.Show;
            Break;
        end
        else if Componente is TDBCheckBox then
        begin
            BTT.AssociatedWinControl := TDBCheckBox(Componente);
            BTT.Show;
            Break;
        end
        else if Componente is TDBRadioGroup then
        begin
            BTT.AssociatedWinControl := TDBRadioGroup(Componente);
            BTT.Show;
            Break;
        end
        else if Componente is TDBLookupListBox then
        begin
            BTT.AssociatedWinControl := TDBLookupListBox(Componente);
            BTT.Show;
            Break;
        end
        else if Componente is TDBLookupComboBox then
        begin
            BTT.AssociatedWinControl := TDBLookupComboBox(Componente);
            BTT.Show;
            Break;
        end
        else if Componente is TDBRichEdit then
        begin
            BTT.AssociatedWinControl := TDBRichEdit(Componente);
            BTT.Show;
            Break;
        end;
	end;
end;

function TXXXDataModule.ArrayOfByteToSet(aArrayOfByte: array of Byte): TSetOfByte;
var
	i: Word;
begin
    Result := [];
	if Length(aArrayOfByte) > 0 then
	    for i := 0 to High(aArrayOfByte) do
        	Include(Result,aArrayOfByte[i]);
end;

function TXXXDataModule.ArrayOfByteToString(aArrayOfByte: array of Byte;
                                              aSeparator: Char = ','): String;
var
	i, UltimoElemento: Word;
begin
	Result := '';
    if Length(aArrayOfByte) > 0 then
    begin
        UltimoElemento := High(aArrayOfByte);
        for i := 0 to UltimoElemento do
            if i <> UltimoElemento then
                Result := Result + IntToStr(aArrayOfByte[i]) + aSeparator
            else
                Result := Result + IntToStr(aArrayOfByte[i]);
    end;
end;

constructor TXXXDataModule.Create(aOwner: TComponent; aDataModule_BasicCreateParameters: TDataModuleCreateParameters);
begin
	{ TODO : Antes de chamar o construtor do pai devemos preencher as variaveis
    locais a fim de torna-las disponiveis em eventos dos filhos. Falei bonito!
    Mas nao tenho certeza se este � o motivo certo... S� sei que funciona }
    FConfigurations := aDataModule_BasicCreateParameters.Configurations;
    FProgressBarModuleLoad := aDataModule_BasicCreateParameters.ProgressBarModuleLoad;
    Application.OnException := DoUnhandleException;

    Form_AddEntity := nil;
    Form_Processing := nil;

	FDescription := aDataModule_BasicCreateParameters.Description;
    FShowDeleteQuestion := True;
    FShowCancelQuestion := True;

	{ TODO : Com a simples atribui��o a seguir podemos ter acesso ao datamodule
    principal a partir de qualquer lugar da aplica��o, sem gambiarras :) caso
    seja passado NIL ou o par�metro DataModuleMain n�o tenha sido informado,
    estamos atribuindo este pr�rio DataModule como sendo o Main. Isso precisa
    ser feito por que quando criamos o form principal passamos apenas a classe
    do DataModule principal que � criado com o par�metro aMainDataModule =
    nil... }
    if Assigned(aDataModule_BasicCreateParameters.DataModuleMain) then
	    FDataModuleMain := aDataModule_BasicCreateParameters.DataModuleMain
    else
    	FDataModuleMain := TXXXDataModule_Main(Self);

    //    FTotalOfActions := 0;
  	inherited Create(aOwner);
end;

destructor TXXXDataModule.Destroy;
begin

	inherited;
end;

procedure TXXXDataModule.DoUnhandleException(Sender: TObject; E: Exception);
begin
	{ TODO : Ainda n�o faz nada... mas far�! }
    { Se for um erro de valida��o, lan�ado por um componente de valida��o, exibe
    o erro adequadamente de acordo com as op��es da aplica��o }
	if E is EInvalidFieldValue then
    begin
        if not assigned(FConfigurations) then
	    	MessageBox(Application.Handle,'vai dar pau porque FConfigurations = nil',':(',MB_ICONERROR);

        if FConfigurations.UseBalloonsOnValidationErrors then
        begin
	        TXXXForm_MainTabbedTemplate(FDataModuleMain.Owner).BalloonToolTip_Validation.TipText := E.Message;
			ShowBalloonToolTipValidationFor(TForm(TXXXDataModule(EInvalidFieldValue(E).FieldError.Owner).Owner),EInvalidFieldValue(E).FieldError.DataSet,EInvalidFieldValue(E).FieldError)
        end
        else
        begin
	    	MessageBox(Application.Handle,PChar(E.Message),PChar(RS_VALIDATION_ERROR),MB_ICONERROR);
        	{ usar uma fun��o parecida com ShowBalloonToolTipValidationFor para
            mostrar a tela e setar o foco }
        end;
    end
    else if E is EInvalidExclusionOperation then
    	MessageBox(Application.Handle,PChar(E.Message),PChar(RS_VALIDATION_ERROR),MB_ICONERROR)
    else if E is EPermissionException then
    	MessageBox(Application.Handle,PChar(E.Message),PChar(RS_NO_PERMISSION),MB_ICONWARNING)
    else
    	Application.ShowException(E);
end;

class function TXXXDataModule.GetStringCheckSum(const aInputString: String; aHashAlgorithms: THashAlgorithms; aFinalHashAlgorithm: THashAlgorithm = haIgnore): String;
var
    HashDigest: array of Byte;
    TempString: String;
    i: Word;
begin
	TempString := aInputString;

    if haIgnore in aHashAlgorithms then
    	Result := TempString;

	if haSha512 in aHashAlgorithms then
   		with TDCP_sha512.Create(nil) do
            try
            	SetLength(HashDigest,0);
                Init;
                Update(TempString[1],Length(TempString));
                SetLength(HashDigest,HashSize div 8);
                Final(HashDigest[0]);

      			Result := '';
      			for i := 0 to Pred(Length(HashDigest)) do  // convert it into a hex string
        			Result := Result + IntToHex(HashDigest[i],2);

                TempString := Result;
            finally
            	Free;
            end;

	if haSha384 in aHashAlgorithms then
   		with TDCP_sha384.Create(nil) do
            try
            	SetLength(HashDigest,0);
                Init;
                Update(TempString[1],Length(TempString));
                SetLength(HashDigest,HashSize div 8);
                Final(HashDigest[0]);

      			Result := '';
      			for i := 0 to Pred(Length(HashDigest)) do  // convert it into a hex string
        			Result := Result + IntToHex(HashDigest[i],2);

                TempString := Result;
            finally
            	Free;
            end;

	if haSha256 in aHashAlgorithms then
   		with TDCP_sha256.Create(nil) do
            try
            	SetLength(HashDigest,0);
                Init;
                Update(TempString[1],Length(TempString));
                SetLength(HashDigest,HashSize div 8);
                Final(HashDigest[0]);

      			Result := '';
      			for i := 0 to Pred(Length(HashDigest)) do  // convert it into a hex string
        			Result := Result + IntToHex(HashDigest[i],2);

                TempString := Result;
            finally
            	Free;
            end;

	if haSha1 in aHashAlgorithms then
   		with TDCP_sha1.Create(nil) do
            try
            	SetLength(HashDigest,0);
                Init;
                Update(TempString[1],Length(TempString));
                SetLength(HashDigest,HashSize div 8);
                Final(HashDigest[0]);

      			Result := '';
      			for i := 0 to Pred(Length(HashDigest)) do  // convert it into a hex string
        			Result := Result + IntToHex(HashDigest[i],2);

                TempString := Result;
            finally
            	Free;
            end;

	if haRipemd160 in aHashAlgorithms then
   		with TDCP_ripemd160.Create(nil) do
            try
            	SetLength(HashDigest,0);
                Init;
                Update(TempString[1],Length(TempString));
                SetLength(HashDigest,HashSize div 8);
                Final(HashDigest[0]);

      			Result := '';
      			for i := 0 to Pred(Length(HashDigest)) do  // convert it into a hex string
        			Result := Result + IntToHex(HashDigest[i],2);

                TempString := Result;
            finally
            	Free;
            end;

	if haRipemd128 in aHashAlgorithms then
   		with TDCP_ripemd128.Create(nil) do
            try
            	SetLength(HashDigest,0);
                Init;
                Update(TempString[1],Length(TempString));
                SetLength(HashDigest,HashSize div 8);
                Final(HashDigest[0]);

      			Result := '';
      			for i := 0 to Pred(Length(HashDigest)) do  // convert it into a hex string
        			Result := Result + IntToHex(HashDigest[i],2);

                TempString := Result;
            finally
            	Free;
            end;

	if haMd5 in aHashAlgorithms then
   		with TDCP_md5.Create(nil) do
            try
            	SetLength(HashDigest,0);
                Init;
                Update(TempString[1],Length(TempString));
                SetLength(HashDigest,HashSize div 8);
                Final(HashDigest[0]);

      			Result := '';
      			for i := 0 to Pred(Length(HashDigest)) do  // convert it into a hex string
        			Result := Result + IntToHex(HashDigest[i],2);

                TempString := Result;
            finally
            	Free;
            end;

	if haMd4 in aHashAlgorithms then
   		with TDCP_md4.Create(nil) do
            try
            	SetLength(HashDigest,0);
                Init;
                Update(TempString[1],Length(TempString));
                SetLength(HashDigest,HashSize div 8);
                Final(HashDigest[0]);

      			Result := '';
      			for i := 0 to Pred(Length(HashDigest)) do  // convert it into a hex string
        			Result := Result + IntToHex(HashDigest[i],2);

                TempString := Result;
            finally
            	Free;
            end;

	if haHaval in aHashAlgorithms then
   		with TDCP_haval.Create(nil) do
            try
            	SetLength(HashDigest,0);
                Init;
                Update(TempString[1],Length(TempString));
                SetLength(HashDigest,HashSize div 8);
                Final(HashDigest[0]);

      			Result := '';
      			for i := 0 to Pred(Length(HashDigest)) do  // convert it into a hex string
        			Result := Result + IntToHex(HashDigest[i],2);

                TempString := Result;
            finally
            	Free;
            end;

	if haTiger in aHashAlgorithms then
   		with TDCP_tiger.Create(nil) do
            try
            	SetLength(HashDigest,0);
                Init;
                Update(TempString[1],Length(TempString));
                SetLength(HashDigest,HashSize div 8);
                Final(HashDigest[0]);

      			Result := '';
      			for i := 0 to Pred(Length(HashDigest)) do  // convert it into a hex string
        			Result := Result + IntToHex(HashDigest[i],2);

                TempString := Result;
            finally
            	Free;
            end;

	if (SizeOf(aHashAlgorithms) > 1) and (aFinalHashAlgorithm <> haIgnore) then
    	Result := GetStringCheckSum(Result,[aFinalHashAlgorithm]);
end;

function TXXXDataModule.GetUniqueFileName(aFullPathAndFileName: String): String;
var
	Count: Word;
	FilePath: String;
    FileName: String;
    Extension: String;
begin
   	Result := aFullPathAndFileName;
    Count := 1;
  	while FileExists(Result) do
    begin
	   	inc(Count);
        FilePath := ExtractFilePath(aFullPathAndFileName);
        FileName := ExtractFileName(aFullPathAndFileName);
        Extension := ExtractFileExt(FileName);
        FileName := Copy(FileName,1,Length(FileName) - Length(Extension));
      	Result := FilePath + FileName + InttoStr(count) + Extension;
    end;
end;

class function TXXXDataModule.Hex(aAscii: AnsiString): AnsiString;
var
	i, StrLength: Cardinal;
  ConvertedStr: String;
begin
	Result := '';
  ConvertedStr := '';

 	StrLength := Length(aAscii);
  if StrLength > 0 then
  begin
    for i := 1 to StrLength do
   		ConvertedStr := ConvertedStr + UpperCase(IntToHex(Ord(aAscii[i]),2));
    Result := ConvertedStr;
  end;
end;

function TXXXDataModule.MakeStr(const aArgs: array of const; aSeparator: Char = ','): string;
const
	BooleanStrings: array[Boolean] of String = ('False', 'True');
var
  	i, UltimoElemento: Word;
begin
	if Length(aArgs) < 2 then
    	raise Exception.Create('N�o � poss�vel usar esta fun��o com menos de dois elementos no array.');

	UltimoElemento := High(aArgs);
    Result := '';
    for i := 0 to UltimoElemento do
    begin
    	with aArgs[i] do
        	case VType of
            	vtInteger:  Result := Result + IntToStr(VInteger);
                vtBoolean:  Result := Result + BooleanStrings[VBoolean];
                vtChar:   Result := Result + VChar;
                vtExtended: Result := Result + FloatToStr(VExtended^);
                vtString:   Result := Result + VString^;
                vtPChar:  Result := Result + VPChar;
                vtObject:   Result := Result + VObject.ClassName;
                vtClass:  Result := Result + VClass.ClassName;
                vtAnsiString: Result := Result + String(VAnsiString);
                vtCurrency: Result := Result + CurrToStr(VCurrency^);
                vtVariant:  Result := Result + String(VVariant^);
                vtInt64:  Result := Result + IntToStr(VInt64^);
            end;

    	if i <> UltimoElemento then
        	Result := Result + aSeparator;
    end;
end;
{ Quebra uma linha de texto em v�rias linhas de forma que cada linha contenha no
m�ximo aLineChars caracteres. Este m�todo quebra a string apenas dentro dos
espa�os }
class function TXXXDataModule.PutLineBreaks(const aText: String; aLineChars: Byte): String;
var
	BreakPos: Byte;
    LineToAdd: String;
    BreakableText: String;
begin
    if Length(aText) > aLineChars then
        with TStringList.Create do
        begin
        	BreakableText := Trim(AText) + #0;

            while BreakableText <> '' do
            begin
            	if Pred(Length(BreakableText)) > aLineChars then
	            	BreakPos := aLineChars
                else
                	BreakPos := Length(BreakableText);

            	while (BreakableText[BreakPos] <> #32) and (BreakableText[BreakPos] <> #0) do
                	Dec(BreakPos);

                LineToAdd := Trim(Copy(BreakableText,1,BreakPos));

	            Add(LineToAdd);
    	        System.Delete(BreakableText,1,BreakPos);
            end;
            Result := Text;
            Free;
        end
    else
    	Result := AText;
end;

{ Escreve uma string inteira dentro de um arquivo, sobrescrevendo-o ou criando-o
se necess�rio for }
class procedure TXXXDataModule.SaveTextFile(aText: String; const aFileName: TFileName);
{$IFDEF UNICODE}
var
  TempStr: AnsiString;
{$ENDIF}
begin
	with TFileStream.Create(aFileName, fmCreate) do
  try
    {$IFDEF UNICODE}
    TempStr := aText;
    Write(Pointer(TempStr)^, Length(TempStr) * SizeOf(AnsiChar));
    {$ELSE}
    Write(Pointer(aText)^, Length(aText));
    {$ENDIF}
  finally
    Free;
  end;
end;

function TXXXDataModule.LoadTextFile(const aFileName: TFileName): String;
begin
	Result := '';

	with TFileStream.Create(aFileName, fmOpenRead or fmShareDenyWrite) do
        try
    		try
      			SetLength(Result, Size);
                Read(Pointer(Result)^, Size);
            except
            	Result := ''; { Desaloca a mem�ria };
      			raise;
            end;
        finally
            Free;
        end;
end;

//function TXXXDataModule.ShowForm(aForm: TComponentClass; var aReference; aModal: Boolean = True; aFormTitle: String = ''): TModalResult;
//begin
//    Result := -1;
//    if not Assigned(TForm(aReference)) then
//	    Application.CreateForm(TFormClass(aForm),aReference);
//
//    TForm(aReference).Hide;
//
//    if Trim(aFormTitle) <> '' then
//    	TForm(aReference).Caption := aFormTitle;
//
//    if aModal then
//    begin
//    	TForm(aReference).FormStyle := fsNormal;
//	    Result := TForm(aReference).ShowModal;
//    end
//    else
//    begin
//        TForm(aReference).FormStyle := fsStayOnTop;
//        TForm(aReference).AlphaBlend := True;
//        TForm(aReference).AlphaBlendValue := 254;
//        TForm(aReference).Show;
//        TForm(aReference).Hide;
//        TForm(aReference).AlphaBlend := False;
//        AnimateWindow(TForm(aReference).Handle,500,AW_BLEND);
//
//        TForm(aReference).Show;
//    end;
//end;

procedure TXXXDataModule.ToggleAnimatedVisibility(aWinControl: TWinControl; aShow: Boolean);
begin
	if aShow then
    	AnimateWindow(aWinControl.Handle,200,AW_CENTER)
    else
      	AnimateWindow(aWinControl.Handle,200,AW_CENTER + AW_HIDE);

    aWinControl.Visible := aShow;
    aWinControl.Repaint;
end;

{ Aqui n�s devemos passar APENAS o nome do arquivo pretendido sem extens�o! }
function TXXXDataModule.ValidateStringForFileName(aFileName: String; aReplaceInvalidCharsWith: Char = '_'; aMaximumFileNameLength: Byte = 0): String;
begin
    { Passo 1: Deixando o nome do arquivo do tamanho especificado }
    if (aMaximumFileNameLength > 0) and (Length(aFileName) > aMaximumFileNameLength) then
    	aFileName := Copy(aFileName,1,aMaximumFileNameLength);

	{ Passo 2: Retirando caracteres especiais }
    aFileName := StringReplace(aFileName,'\',aReplaceInvalidCharsWith,[rfReplaceAll]);
    aFileName := StringReplace(aFileName,'/',aReplaceInvalidCharsWith,[rfReplaceAll]);
    aFileName := StringReplace(aFileName,':',aReplaceInvalidCharsWith,[rfReplaceAll]);
    aFileName := StringReplace(aFileName,'*',aReplaceInvalidCharsWith,[rfReplaceAll]);
    aFileName := StringReplace(aFileName,'?',aReplaceInvalidCharsWith,[rfReplaceAll]);
    aFileName := StringReplace(aFileName,'"',aReplaceInvalidCharsWith,[rfReplaceAll]);
    aFileName := StringReplace(aFileName,'<',aReplaceInvalidCharsWith,[rfReplaceAll]);
    aFileName := StringReplace(aFileName,'>',aReplaceInvalidCharsWith,[rfReplaceAll]);
    aFileName := StringReplace(aFileName,'|',aReplaceInvalidCharsWith,[rfReplaceAll]);

    Result := aFileName;
//   	Result := GetUniqueFileName(FilePath + '\' + FileName + FileExtension);
end;

function TXXXDataModule.AllowedChars(const aTypedChar: Char; aAllowedChars: TAllowedChars): Char;
var
	AcceptedChars: set of Char;
begin
    Result := aTypedChar;
	AcceptedChars := aAllowedChars + [#8,#127]; //Backspace & Delete
	if not (aTypedChar in AcceptedChars) then
		Result := #0;
end;

class procedure TXXXDataModule.WaitFor(const aSeconds: Byte; const aUseProcessMessages: Boolean = True);
var
	TimeOut: TTime;
begin
 	TimeOut := GetTickCount + aSeconds * 1000;
    if aUseProcessMessages then
        while TimeOut > GetTickCount do
  		    Application.ProcessMessages
    else
        while TimeOut > GetTickCount do
        begin
            { Nada mesmo! }
        end;
end;

//procedure TXXXDataModule.MakeSameWidthsAndAdjust(aControls: array of TControl; aLabels: array of TLabel; aSpacing: Byte = 6);
//var
//	TotalWidth, CommonWidth: Word;
//	i, Remainder: Byte;
//  	UseLabels: Boolean;
//begin
//	if Length(aControls) > 0 then
//	begin
//  		if (aSpacing mod 2) = 0 then
//	    begin
//    		TotalWidth := aControls[High(aControls)].Left - aControls[0].Left + aControls[High(aControls)].Width;
//
//      		Remainder := TotalWidth mod Length(aControls);
//      		CommonWidth := (TotalWidth div Length(aControls));
//      		UseLabels := Length(aLabels) = Length(aControls);
//
//      		if not (akRight in aControls[High(aControls)].Anchors) or (akLeft in aControls[High(aControls)].Anchors) then
//      			aControls[High(aControls)].Anchors := aControls[High(aControls)].Anchors - [akLeft] + [akRight];
//
//      		for i := 0 to High(aControls) do
//      		begin
//        		aControls[i].Width := CommonWidth;
//
//        		if Remainder > 0 then
//                begin
//	                aControls[i].Width := aControls[i].Width + 1;
//    	            Dec(Remainder);
//                end;
//
//        		if (i > 0) and (i < High(aControls)) then // aControls do meio
//		        begin
//                  aControls[i].Width := aControls[i].Width - aSpacing;
//                  aControls[i].Left := aControls[Pred(i)].Left + aControls[Pred(i)].Width + aSpacing;
//		        end
//        		else if i = 0 then //Controle do incioo
//		          aControls[i].Width := aControls[i].Width - aSpacing div 2
//		        else // Controle do fim
//        		begin
//        			aControls[i].Width := aControls[i].Width - aSpacing div 2;
//          			aControls[i].Left := aControls[Pred(i)].Left + aControls[Pred(i)].Width + aSpacing;
//        		end;
//
//                if UseLabels and Assigned(aLabels[i]) then
//                begin
//	                aLabels[i].Width := aControls[i].Width;
//    	            aLabels[i].Left := aControls[i].Left;
//                end;
//      		end;
//        end
//        else
//			raise Exception.Create('A separa��o deve obrigatoriamente ser um valor par');
//	end;
//end;

procedure TXXXDataModule.SetMySQLUserVariable(const aZConnection: TZConnection; aVariableName: String; aVariableValue: Int64);
const
    VARIABLE_SET = 'SET @%s := %d;';
begin
   	ExecuteQuery(aZConnection,Format(VARIABLE_SET,[aVariableName,aVariableValue]));
end;

procedure TXXXDataModule.SetMySQLUserVariable(const aZConnection: TZConnection; aVariableName, aVariableValue: String);
const
    VARIABLE_SET = 'SET @%s := ''%s'';';
begin
   	ExecuteQuery(aZConnection,Format(VARIABLE_SET,[aVariableName,aVariableValue]));
end;

procedure TXXXDataModule.SetMySQLUserVariable(const aZConnection: TZConnection; aVariableName: String; aVariableValue: Boolean);
const
    VARIABLE_SET = 'SET @%s := %s;';
begin
   	ExecuteQuery(aZConnection,Format(VARIABLE_SET,[aVariableName,BoolToStr(aVariableValue,True)]));
end;

procedure TXXXDataModule.MySQLAddIndex(aZConnection: TZConnection; aTableName, aIndexName, aFieldNames: String; aIndexKind: TMySQLIndexKind = mikIndex);
var
	IndexDef: String;
begin
	case aIndexKind of
	    mikIndex: IndexDef := 'KEY ' + UpperCase(aIndexName);
        mikPrimary: IndexDef := 'PRIMARY KEY';
        mikUnique: IndexDef := 'UNIQUE KEY ' + UpperCase(aIndexName);
        mikFullText: IndexDef := 'FULLTEXT KEY ' + UpperCase(aIndexName);
        mikSpatial: IndexDef := 'SPATIAL KEY ' + UpperCase(aIndexName);

    end;
    ExecuteQuery(aZConnection,'ALTER TABLE ' + UpperCase(aTableName) + ' ADD ' + IndexDef + ' (' + aFieldNames + ')');
end;

procedure TXXXDataModule.MySQLDropIndex(aZConnection: TZConnection; aTableName, aIndexName: String);
begin
	ExecuteQuery(aZConnection,'ALTER TABLE ' + UpperCase(aTableName) + ' DROP KEY ' + UpperCase(aIndexName));
end;

class function TXXXDataModule.MySQLFormat(const aFormat: String; const aArgs: array of const): String;
var
	FS: TFormatSettings;
begin
    ZeroMemory(@FS,SizeOf(TFormatSettings));
	GetLocaleFormatSettings(1033,FS); { formato de pontua��o de numeros no padr�o americano }
	Result := Format(aFormat,aArgs,FS);

{ TODO -oCarlos Feitoza -cDESAFIO : Futuramente tente fazer convers�es substituindo tipos de delphi como TDateTime por tipos do MySQL que fazem sentido em uma string como "00000000000000". Talvez seja imposs�vel detectar os tipos corretamente! }
//    for i := 0 to UltimoElemento do
//    begin
//    	with aArgs[i] do
//        	case VType of
//            	vtInteger:  Result := Result + IntToStr(VInteger);
//                vtBoolean:  Result := Result + BooleanStrings[VBoolean];
//                vtChar:   Result := Result + VChar;
//                vtExtended: Result := Result + FloatToStr(VExtended^);
//                vtString:   Result := Result + VString^;
//                vtPChar:  Result := Result + VPChar;
//                vtObject:   Result := Result + VObject.ClassName;
//                vtClass:  Result := Result + VClass.ClassName;
//                vtAnsiString: Result := Result + String(VAnsiString);
//                vtCurrency: Result := Result + CurrToStr(VCurrency^);
//                vtVariant:  Result := Result + String(VVariant^);
//                vtInt64:  Result := Result + IntToStr(VInt64^);
//            end;
//
//    	if i <> UltimoElemento then
//        	Result := Result + aSeparator;
//    end;

end;

function TXXXDataModule.IsSystemTable(const aTableName: String): Boolean;
begin
	Result := (aTableName = FConfigurations.UserTableTableName)
           or (aTableName = FConfigurations.GroupTableTableName)
           or (aTableName = FConfigurations.UserPermissionTableTableName)
           or (aTableName = FConfigurations.GroupPermissionTableTableName)
           or (aTableName = FConfigurations.UserGroupsTableTableName)
           or (aTableName = FConfigurations.EntitiesTableTableName);
end;

{ Nesta fun��o e em suas herdeiras use sempre as constantes! }
function TXXXDataModule.ReplaceSystemObjectNames(const aText: String): String;
begin
	Result := aText;
    { Os par�metros com "X" representam aqueles que s�o configur�veis e
    substitu�dos por vari�veis de configura��o }
    Result := StringReplace(Result,'X[USU.' + DEFAULT_USERTABLE_TABLENAME + ']X',FConfigurations.UserTableTableName,[rfReplaceAll,rfIgnoreCase]);
    Result := StringReplace(Result,'X[USU.' + DEFAULT_USERTABLE_KEYFIELDNAME + ']X',FConfigurations.UserTableKeyFieldName,[rfReplaceAll,rfIgnoreCase]);
    Result := StringReplace(Result,'X[USU.' + DEFAULT_USERTABLE_REALNAMEFIELDNAME + ']X',FConfigurations.UserTableRealNameFieldName,[rfReplaceAll,rfIgnoreCase]);
    Result := StringReplace(Result,'X[USU.' + DEFAULT_USERTABLE_USERNAMEFIELDNAME + ']X',FConfigurations.UserTableUserNameFieldName,[rfReplaceAll,rfIgnoreCase]);
    Result := StringReplace(Result,'X[USU.' + DEFAULT_USERTABLE_PASSWORDFIELDNAME + ']X',FConfigurations.UserTablePasswordFieldName,[rfReplaceAll,rfIgnoreCase]);
    Result := StringReplace(Result,'X[USU.' + DEFAULT_USERTABLE_EMAILFIELDNAME + ']X',FConfigurations.UserTableEmailFieldName,[rfReplaceAll,rfIgnoreCase]);

    Result := StringReplace(Result,'X[GRU.' + DEFAULT_GROUPTABLE_TABLENAME + ']X',FConfigurations.GroupTableTableName,[rfReplaceAll,rfIgnoreCase]);
    Result := StringReplace(Result,'X[GRU.' + DEFAULT_GROUPTABLE_KEYFIELDNAME + ']X',FConfigurations.GroupTableKeyFieldName,[rfReplaceAll,rfIgnoreCase]);
    Result := StringReplace(Result,'X[GRU.' + DEFAULT_GROUPTABLE_NAMEFIELDNAME + ']X',FConfigurations.GroupTableNameFieldName,[rfReplaceAll,rfIgnoreCase]);
    Result := StringReplace(Result,'X[GRU.' + DEFAULT_GROUPTABLE_DESCRIPTIONFIELDNAME + ']X',FConfigurations.GroupTableDescriptionFieldName,[rfReplaceAll,rfIgnoreCase]);

    Result := StringReplace(Result,'X[' + DEFAULT_PERMISSIONTABLE_READFIELDNAME + ']X',FConfigurations.PermissionTableReadFieldName,[rfReplaceAll,rfIgnoreCase]);
    Result := StringReplace(Result,'X[' + DEFAULT_PERMISSIONTABLE_INSERTFIELDNAME + ']X',FConfigurations.PermissionTableInsertFieldName,[rfReplaceAll,rfIgnoreCase]);
    Result := StringReplace(Result,'X[' + DEFAULT_PERMISSIONTABLE_UPDATEFIELDNAME + ']X',FConfigurations.PermissionTableUpdateFieldName,[rfReplaceAll,rfIgnoreCase]);
    Result := StringReplace(Result,'X[' + DEFAULT_PERMISSIONTABLE_DELETEFIELDNAME + ']X',FConfigurations.PermissionTableDeleteFieldName,[rfReplaceAll,rfIgnoreCase]);

    Result := StringReplace(Result,'X[PDU.' + DEFAULT_USERPERMISSIONTABLE_TABLENAME + ']X',FConfigurations.UserPermissionTableTableName,[rfReplaceAll,rfIgnoreCase]);
    Result := StringReplace(Result,'X[PDU.' + DEFAULT_USERPERMISSIONTABLE_KEYFIELDNAME + ']X',FConfigurations.UserPermissionTableKeyFieldName,[rfReplaceAll,rfIgnoreCase]);
    Result := StringReplace(Result,'X[PDU.' + DEFAULT_USERPERMISSIONTABLE_ENTITYFIELDNAME + ']X',FConfigurations.UserPermissionTableEntityFieldName,[rfReplaceAll,rfIgnoreCase]);
    Result := StringReplace(Result,'X[PDU.' + DEFAULT_USERPERMISSIONTABLE_USERFIELDNAME + ']X',FConfigurations.UserPermissionTableUserFieldName,[rfReplaceAll,rfIgnoreCase]);

    Result := StringReplace(Result,'X[PDG.' + DEFAULT_GROUPPERMISSIONTABLE_TABLENAME + ']X',FConfigurations.GroupPermissionTableTableName,[rfReplaceAll,rfIgnoreCase]);
    Result := StringReplace(Result,'X[PDG.' + DEFAULT_GROUPPERMISSIONTABLE_KEYFIELDNAME + ']X',FConfigurations.GroupPermissionTableKeyFieldName,[rfReplaceAll,rfIgnoreCase]);
    Result := StringReplace(Result,'X[PDG.' + DEFAULT_GROUPPERMISSIONTABLE_ENTITYFIELDNAME + ']X',FConfigurations.GroupPermissionTableEntityFieldName,[rfReplaceAll,rfIgnoreCase]);
    Result := StringReplace(Result,'X[PDG.' + DEFAULT_GROUPPERMISSIONTABLE_GROUPFIELDNAME + ']X',FConfigurations.GroupPermissionTableGroupFieldName,[rfReplaceAll,rfIgnoreCase]);

    Result := StringReplace(Result,'X[EDS.' + DEFAULT_ENTITIESTABLE_TABLENAME + ']X',FConfigurations.EntitiesTableTableName,[rfReplaceAll,rfIgnoreCase]);
    Result := StringReplace(Result,'X[EDS.' + DEFAULT_ENTITIESTABLE_KEYFIELDNAME + ']X',FConfigurations.EntitiesTableKeyFieldName,[rfReplaceAll,rfIgnoreCase]);
    Result := StringReplace(Result,'X[EDS.' + DEFAULT_ENTITIESTABLE_NAMEFIELDNAME + ']X',FConfigurations.EntitiesTableNameFieldName,[rfReplaceAll,rfIgnoreCase]);
    Result := StringReplace(Result,'X[EDS.' + DEFAULT_ENTITIESTABLE_TYPEFIELDNAME + ']X',FConfigurations.EntitiesTableTypeFieldName,[rfReplaceAll,rfIgnoreCase]);

    Result := StringReplace(Result,'X[GDU.' + DEFAULT_USERGROUPSTABLE_TABLENAME + ']X',FConfigurations.UserGroupsTableTableName,[rfReplaceAll,rfIgnoreCase]);
    Result := StringReplace(Result,'X[GDU.' + DEFAULT_USERGROUPSTABLE_KEYFIELDNAME + ']X',FConfigurations.UserGroupsTableKeyFieldName,[rfReplaceAll,rfIgnoreCase]);
    Result := StringReplace(Result,'X[GDU.' + DEFAULT_USERGROUPSTABLE_USERFIELDNAME + ']X',FConfigurations.UserGroupsTableUserFieldName,[rfReplaceAll,rfIgnoreCase]);
    Result := StringReplace(Result,'X[GDU.' + DEFAULT_USERGROUPSTABLE_GROUPFIELDNAME + ']X',FConfigurations.UserGroupsTableGroupFieldName,[rfReplaceAll,rfIgnoreCase]);

    Result := StringReplace(Result,'X[' + DEFAULT_USERCREATORFIELDNAME + ']X',FConfigurations.UserCreatorFieldName,[rfReplaceAll,rfIgnoreCase]);
    Result := StringReplace(Result,'X[' + DEFAULT_CREATIONDATEANDTIMEFIELDNAME + ']X',FConfigurations.CreationDateAndTimeFieldName,[rfReplaceAll,rfIgnoreCase]);
    Result := StringReplace(Result,'X[' + DEFAULT_USERMODIFIERFIELDNAME + ']X',FConfigurations.UserModifierFieldName,[rfReplaceAll,rfIgnoreCase]);
    Result := StringReplace(Result,'X[' + DEFAULT_MODIFICATIONDATEANDTIMEFIELDNAME + ']X',FConfigurations.ModificationDateAndTimeFieldName,[rfReplaceAll,rfIgnoreCase]);
    Result := StringReplace(Result,'X[' + DEFAULT_RECORDSTATUSFIELDNAME + ']X',FConfigurations.RecordStatusFieldName,[rfReplaceAll,rfIgnoreCase]);
end;

procedure TXXXDataModule.ReplaceSystemObjectNames(const aZQuery: TZQuery);
var
	i: Byte;
begin
	for i := 0 to Pred(aZQuery.FieldCount) do
    begin
        aZQuery.Fields[i].FieldName := StringReplace(aZQuery.Fields[i].FieldName,'X[USU.' + DEFAULT_USERTABLE_TABLENAME + ']X',FConfigurations.UserTableTableName,[rfReplaceAll,rfIgnoreCase]);
        aZQuery.Fields[i].FieldName := StringReplace(aZQuery.Fields[i].FieldName,'X[USU.' + DEFAULT_USERTABLE_KEYFIELDNAME + ']X',FConfigurations.UserTableKeyFieldName,[rfReplaceAll,rfIgnoreCase]);
        aZQuery.Fields[i].FieldName := StringReplace(aZQuery.Fields[i].FieldName,'X[USU.' + DEFAULT_USERTABLE_REALNAMEFIELDNAME + ']X',FConfigurations.UserTableRealNameFieldName,[rfReplaceAll,rfIgnoreCase]);
        aZQuery.Fields[i].FieldName := StringReplace(aZQuery.Fields[i].FieldName,'X[USU.' + DEFAULT_USERTABLE_USERNAMEFIELDNAME + ']X',FConfigurations.UserTableUserNameFieldName,[rfReplaceAll,rfIgnoreCase]);
        aZQuery.Fields[i].FieldName := StringReplace(aZQuery.Fields[i].FieldName,'X[USU.' + DEFAULT_USERTABLE_PASSWORDFIELDNAME + ']X',FConfigurations.UserTablePasswordFieldName,[rfReplaceAll,rfIgnoreCase]);
        aZQuery.Fields[i].FieldName := StringReplace(aZQuery.Fields[i].FieldName,'X[USU.' + DEFAULT_USERTABLE_EMAILFIELDNAME + ']X',FConfigurations.UserTableEmailFieldName,[rfReplaceAll,rfIgnoreCase]);

        aZQuery.Fields[i].FieldName := StringReplace(aZQuery.Fields[i].FieldName,'X[GRU.' + DEFAULT_GROUPTABLE_TABLENAME + ']X',FConfigurations.GroupTableTableName,[rfReplaceAll,rfIgnoreCase]);
        aZQuery.Fields[i].FieldName := StringReplace(aZQuery.Fields[i].FieldName,'X[GRU.' + DEFAULT_GROUPTABLE_KEYFIELDNAME + ']X',FConfigurations.GroupTableKeyFieldName,[rfReplaceAll,rfIgnoreCase]);
        aZQuery.Fields[i].FieldName := StringReplace(aZQuery.Fields[i].FieldName,'X[GRU.' + DEFAULT_GROUPTABLE_NAMEFIELDNAME + ']X',FConfigurations.GroupTableNameFieldName,[rfReplaceAll,rfIgnoreCase]);
        aZQuery.Fields[i].FieldName := StringReplace(aZQuery.Fields[i].FieldName,'X[GRU.' + DEFAULT_GROUPTABLE_DESCRIPTIONFIELDNAME + ']X',FConfigurations.GroupTableDescriptionFieldName,[rfReplaceAll,rfIgnoreCase]);

        aZQuery.Fields[i].FieldName := StringReplace(aZQuery.Fields[i].FieldName,'X[' + DEFAULT_PERMISSIONTABLE_READFIELDNAME + ']X',FConfigurations.PermissionTableReadFieldName,[rfReplaceAll,rfIgnoreCase]);
        aZQuery.Fields[i].FieldName := StringReplace(aZQuery.Fields[i].FieldName,'X[' + DEFAULT_PERMISSIONTABLE_INSERTFIELDNAME + ']X',FConfigurations.PermissionTableInsertFieldName,[rfReplaceAll,rfIgnoreCase]);
        aZQuery.Fields[i].FieldName := StringReplace(aZQuery.Fields[i].FieldName,'X[' + DEFAULT_PERMISSIONTABLE_UPDATEFIELDNAME + ']X',FConfigurations.PermissionTableUpdateFieldName,[rfReplaceAll,rfIgnoreCase]);
        aZQuery.Fields[i].FieldName := StringReplace(aZQuery.Fields[i].FieldName,'X[' + DEFAULT_PERMISSIONTABLE_DELETEFIELDNAME + ']X',FConfigurations.PermissionTableDeleteFieldName,[rfReplaceAll,rfIgnoreCase]);

        aZQuery.Fields[i].FieldName := StringReplace(aZQuery.Fields[i].FieldName,'X[PDU.' + DEFAULT_USERPERMISSIONTABLE_TABLENAME + ']X',FConfigurations.UserPermissionTableTableName,[rfReplaceAll,rfIgnoreCase]);
        aZQuery.Fields[i].FieldName := StringReplace(aZQuery.Fields[i].FieldName,'X[PDU.' + DEFAULT_USERPERMISSIONTABLE_KEYFIELDNAME + ']X',FConfigurations.UserPermissionTableKeyFieldName,[rfReplaceAll,rfIgnoreCase]);
        aZQuery.Fields[i].FieldName := StringReplace(aZQuery.Fields[i].FieldName,'X[PDU.' + DEFAULT_USERPERMISSIONTABLE_ENTITYFIELDNAME + ']X',FConfigurations.UserPermissionTableEntityFieldName,[rfReplaceAll,rfIgnoreCase]);
        aZQuery.Fields[i].FieldName := StringReplace(aZQuery.Fields[i].FieldName,'X[PDU.' + DEFAULT_USERPERMISSIONTABLE_USERFIELDNAME + ']X',FConfigurations.UserPermissionTableUserFieldName,[rfReplaceAll,rfIgnoreCase]);

        aZQuery.Fields[i].FieldName := StringReplace(aZQuery.Fields[i].FieldName,'X[PDG.' + DEFAULT_GROUPPERMISSIONTABLE_TABLENAME + ']X',FConfigurations.GroupPermissionTableTableName,[rfReplaceAll,rfIgnoreCase]);
        aZQuery.Fields[i].FieldName := StringReplace(aZQuery.Fields[i].FieldName,'X[PDG.' + DEFAULT_GROUPPERMISSIONTABLE_KEYFIELDNAME + ']X',FConfigurations.GroupPermissionTableKeyFieldName,[rfReplaceAll,rfIgnoreCase]);
        aZQuery.Fields[i].FieldName := StringReplace(aZQuery.Fields[i].FieldName,'X[PDG.' + DEFAULT_GROUPPERMISSIONTABLE_ENTITYFIELDNAME + ']X',FConfigurations.GroupPermissionTableEntityFieldName,[rfReplaceAll,rfIgnoreCase]);
        aZQuery.Fields[i].FieldName := StringReplace(aZQuery.Fields[i].FieldName,'X[PDG.' + DEFAULT_GROUPPERMISSIONTABLE_GROUPFIELDNAME + ']X',FConfigurations.GroupPermissionTableGroupFieldName,[rfReplaceAll,rfIgnoreCase]);

        aZQuery.Fields[i].FieldName := StringReplace(aZQuery.Fields[i].FieldName,'X[EDS.' + DEFAULT_ENTITIESTABLE_TABLENAME + ']X',FConfigurations.EntitiesTableTableName,[rfReplaceAll,rfIgnoreCase]);
        aZQuery.Fields[i].FieldName := StringReplace(aZQuery.Fields[i].FieldName,'X[EDS.' + DEFAULT_ENTITIESTABLE_KEYFIELDNAME + ']X',FConfigurations.EntitiesTableKeyFieldName,[rfReplaceAll,rfIgnoreCase]);
        aZQuery.Fields[i].FieldName := StringReplace(aZQuery.Fields[i].FieldName,'X[EDS.' + DEFAULT_ENTITIESTABLE_NAMEFIELDNAME + ']X',FConfigurations.EntitiesTableNameFieldName,[rfReplaceAll,rfIgnoreCase]);
        aZQuery.Fields[i].FieldName := StringReplace(aZQuery.Fields[i].FieldName,'X[EDS.' + DEFAULT_ENTITIESTABLE_TYPEFIELDNAME + ']X',FConfigurations.EntitiesTableTypeFieldName,[rfReplaceAll,rfIgnoreCase]);

        aZQuery.Fields[i].FieldName := StringReplace(aZQuery.Fields[i].FieldName,'X[GDU.' + DEFAULT_USERGROUPSTABLE_TABLENAME + ']X',FConfigurations.UserGroupsTableTableName,[rfReplaceAll,rfIgnoreCase]);
        aZQuery.Fields[i].FieldName := StringReplace(aZQuery.Fields[i].FieldName,'X[GDU.' + DEFAULT_USERGROUPSTABLE_KEYFIELDNAME + ']X',FConfigurations.UserGroupsTableKeyFieldName,[rfReplaceAll,rfIgnoreCase]);
        aZQuery.Fields[i].FieldName := StringReplace(aZQuery.Fields[i].FieldName,'X[GDU.' + DEFAULT_USERGROUPSTABLE_USERFIELDNAME + ']X',FConfigurations.UserGroupsTableUserFieldName,[rfReplaceAll,rfIgnoreCase]);
        aZQuery.Fields[i].FieldName := StringReplace(aZQuery.Fields[i].FieldName,'X[GDU.' + DEFAULT_USERGROUPSTABLE_GROUPFIELDNAME + ']X',FConfigurations.UserGroupsTableGroupFieldName,[rfReplaceAll,rfIgnoreCase]);

        aZQuery.Fields[i].FieldName := StringReplace(aZQuery.Fields[i].FieldName,'X[' + DEFAULT_USERCREATORFIELDNAME + ']X',FConfigurations.UserCreatorFieldName,[rfReplaceAll,rfIgnoreCase]);
        aZQuery.Fields[i].FieldName := StringReplace(aZQuery.Fields[i].FieldName,'X[' + DEFAULT_CREATIONDATEANDTIMEFIELDNAME + ']X',FConfigurations.CreationDateAndTimeFieldName,[rfReplaceAll,rfIgnoreCase]);
        aZQuery.Fields[i].FieldName := StringReplace(aZQuery.Fields[i].FieldName,'X[' + DEFAULT_USERMODIFIERFIELDNAME + ']X',FConfigurations.UserModifierFieldName,[rfReplaceAll,rfIgnoreCase]);
        aZQuery.Fields[i].FieldName := StringReplace(aZQuery.Fields[i].FieldName,'X[' + DEFAULT_MODIFICATIONDATEANDTIMEFIELDNAME + ']X',FConfigurations.ModificationDateAndTimeFieldName,[rfReplaceAll,rfIgnoreCase]);
        aZQuery.Fields[i].FieldName := StringReplace(aZQuery.Fields[i].FieldName,'X[' + DEFAULT_RECORDSTATUSFIELDNAME + ']X',FConfigurations.RecordStatusFieldName,[rfReplaceAll,rfIgnoreCase]);
    end;
end;

class procedure TXXXDataModule.MySQLChangeDatabase(const aZConnection: TZConnection;
                                                   const aDataBaseName: String);
var
    Processor: TZSQLProcessor;
begin
    if Trim(aDataBaseName) = '' then
        raise Exception.Create('O nome do banco de dados n�o foi especificado!');

    if aZConnection.Connected then
    begin
        Processor := nil;
        try

            Processor := TZSQLProcessor.Create(aZConnection);
            Processor.ParamCheck := False;
            Processor.Connection := aZConnection;
            Processor.DelimiterType := dtSetTerm;
            Processor.Delimiter := ';';
            Processor.Script.Text := 'USE ' + aDataBaseName + ';';
            Processor.Execute;
        finally
            if Assigned(Processor) then
                Processor.Free;
        end;
    end;
end;

class function TXXXDataModule.MySQLBackupDataBase(const aZConnection: TZConnection;
                                                  const aParameters: TMySQLBackupDataBaseParameters): String;
const
	{ FUTURAMENTE DETECTE PONTOS DESTE PROCEDURE ONDE PODEMOS COLOCAR EVENTOS E
    TORNE ESTA FUN��O GENERICA. CUIDADO COM OS PROCESSMESSAGES CASO PRETENDA
    USA-LA NO FTP SINCRONIZER }
	MAX_QUERY_SIZE = High(SmallInt);
	DELIMITER = '�';
  	SQLScript =
    '# ============================================================================ #'#13#10 +
    '# BACKUP GERADO EM [%]CURRENTDATEANDTIME[%]                                    #'#13#10 +
    '# ============================================================================ #'#13#10#13#10 +
    'DROP DATABASE IF EXISTS [%]DATABASENAME[%];'#13#10#13#10 +
    'CREATE DATABASE [%]DATABASENAME[%] DEFAULT CHARACTER SET LATIN1 COLLATE LATIN1_BIN;'#13#10#13#10 +
    'USE [%]DATABASENAME[%];'#13#10#13#10 +

  	'# ============================================================================ #'#13#10 +
  	'# DEFINI��O DE ROTINAS - IN�CIO                                                #'#13#10 +
  	'# ============================================================================ #'#13#10 +
  	'[%]DBROUTINES[%]' +
  	'# ============================================================================ #'#13#10 +
  	'# DEFINI��O DE ROTINAS - FIM                                                   #'#13#10 +
  	'# ============================================================================ #'#13#10#13#10 +

  	'# ============================================================================ #'#13#10 +
    '# DEFINI��O DE TABELAS - IN�CIO                                                #'#13#10 +
    '# ============================================================================ #'#13#10 +
  	'[%]TABLEDEFINITIONS[%]' +
    '# ============================================================================ #'#13#10 +
    '# DEFINI��O DE TABELAS - FIM                                                   #'#13#10 +
    '# ============================================================================ #'#13#10#13#10 +

  	'# ============================================================================ #'#13#10 +
  	'# DEFINI��O DE TRIGGERS - IN�CIO                                               #'#13#10 +
  	'# ============================================================================ #'#13#10 +
  	'[%]DBTRIGGERS[%]' +
  	'# ============================================================================ #'#13#10 +
  	'# DEFINI��O DE TRIGGERS - FIM                                                  #'#13#10 +
  	'# ============================================================================ #'#13#10#13#10 +

    '# ============================================================================ #'#13#10 +
    '# ADI��O DE CONSTRAINTS - IN�CIO                                               #'#13#10 +
    '# ============================================================================ #'#13#10 +
  	'[%]TABLECONSTRAINTS[%]' +
    '# ============================================================================ #'#13#10 +
    '# ADI��O DE CONSTRAINTS - FIM                                                  #'#13#10 +
    '# ============================================================================ #'#13#10#13#10 +

  	'# ============================================================================ #'#13#10 +
  	'# DEFINI��O DE VIEWS - IN�CIO                                                  #'#13#10 +
  	'# ============================================================================ #'#13#10 +
    '[%]DBVIEWS[%]' +
  	'# ============================================================================ #'#13#10 +
  	'# DEFINI��O DE VIEWS - FIM                                                     #'#13#10 +
  	'# ============================================================================ #';

  	INSHEADER =
  	'# == INSER��ES PARA A TABELA %s'#13#10#13#10;

  	INSERT_SCHEMA =
    'INSERT INTO %s'#13#10 +
    'VALUES'#13#10;

  	QUERY_SIZE =
  	'# == A INSTRU��O ACIMA POSSUI %u INSER��ES (%u BYTES)';

    TRIGGER_TEMPLATE =
    'CREATE TRIGGER %s %s %s'#13#10 +
    'ON %s FOR EACH ROW'#13#10 +
    '%s; ' + DELIMITER;

    ROUTINE_TEMPLATE =
    '%s; ' + DELIMITER;

function MySQLHexStr(aASCII: String): String;
begin
	Result := Hex(aASCII);
    if Result <> '' then
    	Result := 'x' + QuotedStr(Result)
    else
        Result := 'NULL';
end;

{ TODO -oCarlos Feitoza -cOTIMIZA��O : Existem algumas partes dessa rotina que
est�o realizando coisas muito for�adamente (gambiarras) tente otimizar,
principalmente a parte de extra��o de constraints. Acho que deve ter uma forma
de obte-las pelo dicionario de dados }
var
	DatabasePart, CurrentPart, AvailableTables, CurrentTableDefinition,
    TableInsertions: TZReadOnlyQuery;
    DBRoutines, DBViews, DBTriggers,
  	TableDefinitions, CurrentDefinition, TableConstraints, CurrentConstraint, ValuesPart, CurrentQuery: String;
  	i, QuerySize: Word;
  	CurrentRow: Cardinal;
begin
    Result := StringReplace(SQLScript,'[%]CURRENTDATEANDTIME[%]',FormatDateTime('dd/mm/yyyy "�s" hh:nn:ss',Now) + '  ',[]);
    Result := StringReplace(Result,'[%]DATABASENAME[%]',aParameters.DataBaseName,[rfReplaceAll]);

    if Assigned(aParameters.OnNotification) then
        aParameters.OnNotification(nmStart
                                  ,aParameters.DataBaseName
                                  ,''
                                  ,0
                                  ,0);

    try
        DatabasePart := TZReadOnlyQuery.Create(nil);
        CurrentPart := TZReadOnlyQuery.Create(nil);

        { Antes de qualquer coisa precisamos mudar a database para aquela que
        est� configurada na tela de configura��es }
        MySQLChangeDatabase(aZConnection
                           ,aParameters.DataBaseName);

  	    { == Extra��o de stored routines ===================================== }
        DBRoutines := '';
        ConfigureDataSet(aZConnection
                        ,DatabasePart
                        ,'SELECT SPECIFIC_NAME, ROUTINE_TYPE FROM information_schema.ROUTINES WHERE UPPER(ROUTINE_SCHEMA) = UPPER(' + QuotedStr(aParameters.DataBaseName) + ')'
                         ,False);

        if Assigned(aParameters.OnNotification) then
            aParameters.OnNotification(nmBeforeExtractStoredRoutines
                                      ,'EXTRACTING STORED ROUTINES STARTED'
                                      ,''
                                      ,DatabasePart.RecordCount // QTD DE STORED ROUTINES
                                      ,0);

        if DatabasePart.RecordCount > 0 then
        begin
            while not DatabasePart.Eof do
            begin
                if UpperCase(DatabasePart.Fields[1].AsString) = 'FUNCTION' then
                    ConfigureDataSet(aZConnection,CurrentPart,'SHOW CREATE FUNCTION ' + UpperCase(aParameters.DataBaseName) + '.' + DatabasePart.Fields[0].AsString,False)
                else if UpperCase(DatabasePart.Fields[1].AsString) = 'PROCEDURE' then
                    ConfigureDataSet(aZConnection,CurrentPart,'SHOW CREATE PROCEDURE ' + UpperCase(aParameters.DataBaseName) + '.' + DatabasePart.Fields[0].AsString,False);

                if Assigned(aParameters.OnNotification) then
                    aParameters.OnNotification(nmBeginExtractStoredRoutine
                                              ,DatabasePart.Fields[0].AsString  // NOME DA STORED ROUTINE
                                              ,UpperCase(DatabasePart.Fields[1].AsString) // TIPO DA STORED ROUTINE
                                              ,DatabasePart.RecordCount // QTD DE STORED ROUTINES
                                              ,DatabasePart.RecNo); // NUMERO DA STORED ROUTINE ATUAL

                DBRoutines := DBRoutines + Format(ROUTINE_TEMPLATE,[CurrentPart.Fields[2].AsString]);

                if DatabasePart.RecNo < DatabasePart.RecordCount then
	                DBRoutines := DBRoutines + #13#10#13#10
                else
                	DBRoutines := DBRoutines + #13#10;

                if Assigned(aParameters.OnNotification) then
                    aParameters.OnNotification(nmEndExtractStoredRoutine
                                              ,DatabasePart.Fields[0].AsString  // NOME DA STORED ROUTINE
                                              ,UpperCase(DatabasePart.Fields[1].AsString) // TIPO DA STORED ROUTINE
                                              ,DatabasePart.RecordCount // QTD DE STORED ROUTINES
                                              ,DatabasePart.RecNo); // NUMERO DA STORED ROUTINE ATUAL

                DatabasePart.Next;
            end;
            DBRoutines := 'DELIMITER ' + DELIMITER + #13#10#13#10 + DBRoutines + #13#10'DELIMITER ;'#13#10;
        end
        else
            DBRoutines := #13#10'# A base de dados ' + UpperCase(aParameters.DataBaseName) + ' n�o possui stored routines!'#13#10#13#10;

        if Assigned(aParameters.OnNotification) then
            aParameters.OnNotification(nmAfterExtractStoredRoutines
                                      ,'EXTRACTING STORED ROUTINES FINISHED'
                                      ,''
                                      ,DatabasePart.RecordCount // QTD DE STORED ROUTINES
                                      ,0);
  	    { ==================================================================== }

  	    { == Extra��o de vis�es ============================================== }
        DBViews := '';
        ConfigureDataSet(aZConnection
                        ,DatabasePart
                        ,'SELECT TABLE_NAME FROM INFORMATION_SCHEMA.TABLES WHERE UPPER(TABLE_SCHEMA) = UPPER(' + QuotedStr(aParameters.DataBaseName) + ') AND TABLE_TYPE = ''VIEW'''
                        ,False);

        if Assigned(aParameters.OnNotification) then
            aParameters.OnNotification(nmBeforeExtractViews
                                      ,'EXTRACTING VIEWS STARTED'
                                      ,''
                                      ,DatabasePart.RecordCount // QTD DE VIEWS
                                      ,0);

        if DatabasePart.RecordCount > 0 then
            while not DatabasePart.Eof do
            begin
                if Assigned(aParameters.OnNotification) then
                    aParameters.OnNotification(nmBeginExtractView
                                              ,DatabasePart.Fields[0].AsString  // NOME DA VIEW
                                              ,''
                                              ,DatabasePart.RecordCount // QTD DE VIEWS
                                              ,DatabasePart.RecNo); // NUMERO DA VIEW ATUAL;

                ConfigureDataSet(aZConnection
                                ,CurrentPart
                                ,'SHOW CREATE VIEW ' + UpperCase(aParameters.DataBaseName) + '.' + DatabasePart.Fields[0].AsString
                                ,False);

                DBViews := DBViews + CurrentPart.Fields[1].AsString + ';';

                if DatabasePart.RecNo < DatabasePart.RecordCount then
	                DBViews := DBViews + #13#10#13#10
                else
                	DBViews := DBViews + #13#10;

                if Assigned(aParameters.OnNotification) then
                    aParameters.OnNotification(nmEndExtractView
                                              ,DatabasePart.Fields[0].AsString  // NOME DA VIEW
                                              ,''
                                              ,DatabasePart.RecordCount // QTD DE VIEWS
                                              ,DatabasePart.RecNo); // NUMERO DA VIEW ATUAL;

                DatabasePart.Next;
            end
        else
            DBViews := #13#10'# A base de dados ' + UpperCase(aParameters.DataBaseName) + ' n�o possui views!'#13#10#13#10;

        if Assigned(aParameters.OnNotification) then
            aParameters.OnNotification(nmAfterExtractViews
                                      ,'EXTRACTING VIEWS FINISHED'
                                      ,''
                                      ,DatabasePart.RecordCount // QTD DE VIEWS
                                      ,0);
  	    { ==================================================================== }

        { == Extra��o de triggers ============================================ }
        DBTriggers := '';
	    ConfigureDataSet(aZConnection
                        ,DatabasePart
                        ,'SELECT TRIGGER_NAME, EVENT_MANIPULATION, EVENT_OBJECT_TABLE, ACTION_STATEMENT, ACTION_TIMING FROM INFORMATION_SCHEMA.TRIGGERS WHERE UPPER(TRIGGER_SCHEMA) = UPPER(' + QuotedStr(aParameters.DataBaseName) + ')'
                        ,False);

        if Assigned(aParameters.OnNotification) then
            aParameters.OnNotification(nmBeforeExtractTriggers
                                      ,'EXTRACTING TRIGGERS STARTED'
                                      ,''
                                      ,DatabasePart.RecordCount // QTD DE TRIGGERS
                                      ,0);

	    if DatabasePart.RecordCount > 0 then
        begin
            while not DatabasePart.Eof do
            begin
                if Assigned(aParameters.OnNotification) then
                    aParameters.OnNotification(nmBeginExtractTrigger
                                              ,UpperCase(DatabasePart.Fields[0].AsString)  // NOME DO TRIGGER
                                              ,UpperCase(DatabasePart.Fields[2].AsString)  // TABELA RELACIONADA
                                              ,DatabasePart.RecordCount // QTD DE TRIGGERS
                                              ,DatabasePart.RecNo);

                DBTriggers := DBTriggers + Format(TRIGGER_TEMPLATE,[DatabasePart.Fields[0].AsString
                                                                   ,DatabasePart.Fields[4].AsString
                                                                   ,DatabasePart.Fields[1].AsString
                                                                   ,DatabasePart.Fields[2].AsString
                                                                   ,DatabasePart.Fields[3].AsString]);

                if DatabasePart.RecNo < DatabasePart.RecordCount then
	                DBTriggers := DBTriggers + #13#10#13#10
                else
                	DBTriggers := DBTriggers + #13#10;

                if Assigned(aParameters.OnNotification) then
                    aParameters.OnNotification(nmEndExtractTrigger
                                              ,UpperCase(DatabasePart.Fields[0].AsString)  // NOME DO TRIGGER
                                              ,UpperCase(DatabasePart.Fields[2].AsString)  // TABELA RELACIONADA
                                              ,DatabasePart.RecordCount // QTD DE TRIGGERS
                                              ,DatabasePart.RecNo);

                DatabasePart.Next;
            end;
            DBTriggers := 'DELIMITER ' + DELIMITER + #13#10#13#10 + DBTriggers + #13#10'DELIMITER ;'#13#10;
        end
    	else
        	DBTriggers := #13#10'# A base de dados ' + UpperCase(aParameters.DataBaseName) + ' n�o possui triggers!'#13#10#13#10;

        if Assigned(aParameters.OnNotification) then
            aParameters.OnNotification(nmAfterExtractTriggers
                                      ,'EXTRACTING TRIGGERS FINISHED'
                                      ,''
                                      ,DatabasePart.RecordCount // QTD DE TRIGGERS
                                      ,0);
        { ==================================================================== }
    finally
    	if Assigned(CurrentPart) then
        	CurrentPart.Free;

        if Assigned(DatabasePart) then
            DatabasePart.Free;
    end;

    try
        AvailableTables := nil;
        CurrentTableDefinition := TZReadOnlyQuery.Create(nil);
        TableInsertions := TZReadOnlyQuery.Create(nil);

        ConfigureDataSet(aZConnection
                        ,AvailableTables
                        ,'SELECT TABLE_NAME FROM INFORMATION_SCHEMA.TABLES WHERE UPPER(TABLE_SCHEMA) = UPPER(' + QuotedStr(aParameters.DataBaseName) + ') AND TABLE_TYPE = ''BASE TABLE''');

        if Assigned(aParameters.OnNotification) then
            aParameters.OnNotification(nmBeforeExtractTables
                                      ,'EXTRACTING TABLES STARTED'
                                      ,''
                                      ,AvailableTables.RecordCount // QTD DE TABELAS
                                      ,0);

        with AvailableTables do
        begin
            TableDefinitions := '';
            TableConstraints := '';

            First;

            while not Eof do
            begin
                if Assigned(aParameters.OnNotification) then
                    aParameters.OnNotification(nmBeginExtractTable
                                              ,UpperCase(Fields[0].AsString)  // NOME DA TABELA
                                              ,''
                                              ,RecordCount // QTD DE TABELAS
                                              ,RecNo); // NUMERO DA TABELA DA VEZ

                ConfigureDataSet(aZConnection
                                ,CurrentTableDefinition
                                ,'SHOW CREATE TABLE ' + UpperCase(aParameters.DataBaseName) + '.' + UpperCase(Fields[0].AsString)
                                ,False);

                CurrentDefinition := UpperCase(StringReplace(CurrentTableDefinition.Fields[1].AsString,#$0A,#$0D#$0A,[rfReplaceAll]));

                if Pos('  CONSTRAINT',CurrentDefinition) > 0 then
                begin
                    CurrentConstraint := 'ALTER TABLE ' + UpperCase(Fields[0].AsString) + #13#10;

                    repeat
                        i := Pos('  CONSTRAINT',CurrentDefinition);
                        if i > 0 then
                        begin
                            CurrentConstraint := CurrentConstraint + StringReplace(Copy(CurrentDefinition,i,PosEx(#13#10,CurrentDefinition,i) - i + 2),'  CONSTRAINT','  ADD CONSTRAINT',[]);
                            System.Delete(CurrentDefinition,i,PosEx(#13#10,CurrentDefinition,i) - i + 2);
                        end;
                    until i = 0;

                    System.Insert(';',CurrentConstraint,Length(CurrentConstraint) - 1);
                    TableConstraints := TableConstraints + CurrentConstraint + #13#10;
                end;

                // Insere ";" no final da defini��o
                System.Insert(';',CurrentDefinition,Length(CurrentDefinition) + 1);

                // Retira os coment�rios
                i := Pos(' COMMENT=''',CurrentDefinition);
                if i > 0 then
                    System.Delete(CurrentDefinition,i,PosEx(';',CurrentDefinition,i) - i);

                TableDefinitions := TableDefinitions + StringReplace(CurrentDefinition,','#13#10')',#13#10')',[]) + #13#10#13#10;

                TableDefinitions := TableDefinitions + Format(INSHEADER,[UpperCase(Fields[0].AsString)]);

                ConfigureDataSet(aZConnection
                                ,TableInsertions
                                ,'SELECT * FROM ' + UpperCase(aParameters.DataBaseName) + '.' + Fields[0].AsString
                                ,False);

                if Assigned(aParameters.OnNotification) then
                    aParameters.OnNotification(nmBeforeExtractRecords
                                              ,'EXTRACT RECORD STARTED'
                                              ,UpperCase(Fields[0].AsString) // NOME DA TABELA
                                              ,TableInsertions.RecordCount // QTD DE REGISTROS
                                              ,0);

                if TableInsertions.RecordCount > 0 then
                begin

                    { QuerySize ser� acumulado at� que ele contenha um valor de
                    no m�ximo MAX_QUERY_SIZE, quando CurrentQuery � conclu�do e
                    juntado � TableDefinitions }
                    QuerySize := 0;
                    CurrentRow := 0;

                    while not TableInsertions.Eof do
                    begin
                        if Assigned(aParameters.OnNotification) then
                            aParameters.OnNotification(nmBeginExtractRecord
                                                      ,UpperCase(Fields[0].AsString) // NOME DA TABELA
                                                      ,''
                                                      ,TableInsertions.RecordCount // QTD DE REGISTROS
                                                      ,TableInsertions.RecNo); // REGISTRO ATUAL
                        Inc(CurrentRow);
                        Application.ProcessMessages;

                        ValuesPart := '  (';
                        for i := 0 to Pred(TableInsertions.FieldCount) do
                        begin
                            // Nulo?
                            if TableInsertions.Fields[i].IsNull then
                                ValuesPart := ValuesPart + 'NULL'
                            // Inteiro?
                            else if TableInsertions.Fields[i].DataType in [ftSmallint,ftInteger,ftWord,ftLargeint] then
                                ValuesPart := ValuesPart + TableInsertions.Fields[i].AsString
                            // Decimal?
                            else if TableInsertions.Fields[i].DataType in [ftFloat,ftCurrency] then
                                ValuesPart := ValuesPart + StringReplace(TableInsertions.Fields[i].AsString,',','.',[])
                            // Data?
                            else if (TableInsertions.Fields[i].DataType = ftDate) then
                                ValuesPart := ValuesPart + FormatDateTime('yyyymmdd',TableInsertions.Fields[i].AsDateTime)
                            // Tempo?
                            else if (TableInsertions.Fields[i].DataType = ftTime) then
                                ValuesPart := ValuesPart + FormatDateTime('hhnnss',TableInsertions.Fields[i].AsDateTime)
                            // Data + Tempo?
                            else if (TableInsertions.Fields[i].DataType = ftDateTime) then
                                ValuesPart := ValuesPart + FormatDateTime('yyyymmddhhnnss',TableInsertions.Fields[i].AsDateTime)
                            // Bin�rio, String ou qualquer outra coisa?
                            else
                                ValuesPart := ValuesPart + MySQLHexStr(TableInsertions.Fields[i].AsString);

                            if i < Pred(TableInsertions.FieldCount) then
                                ValuesPart := ValuesPart + ','
                            else
                                ValuesPart := ValuesPart + ')'
                        end;

                        if CurrentRow = 1 then
                            CurrentQuery := Format(INSERT_SCHEMA,[UpperCase(Fields[0].AsString)]) + ValuesPart
                        else
                        begin
                            CurrentQuery := ValuesPart;
                            if (QuerySize + Length(ValuesPart)) > MAX_QUERY_SIZE then
                            begin
                                TableDefinitions := TableDefinitions + ';'#13#10 + Format(QUERY_SIZE,[CurrentRow,QuerySize]) + #13#10;
                                QuerySize := 0;
                                CurrentRow := 1;
                                CurrentQuery := Format(INSERT_SCHEMA,[UpperCase(Fields[0].AsString)]) + ValuesPart;
                            end;
                        end;

                        Inc(QuerySize,Length(CurrentQuery));

                        if CurrentRow = 1 then
                            TableDefinitions := TableDefinitions + CurrentQuery
                        else
                            TableDefinitions := TableDefinitions + ','#13#10 + CurrentQuery;

                        if Assigned(aParameters.OnNotification) then
                            aParameters.OnNotification(nmEndExtractRecord
                                                      ,UpperCase(Fields[0].AsString) // NOME DA TABELA
                                                      ,''
                                                      ,TableInsertions.RecordCount // QTD DE REGISTROS
                                                      ,TableInsertions.RecNo); // REGISTRO ATUAL

                        TableInsertions.Next;
                    end;

                    if CurrentRow > 0 then
                        TableDefinitions := TableDefinitions + ';'#13#10 + Format(QUERY_SIZE,[CurrentRow,QuerySize]) + #13#10#13#10;
                end
                else
                    TableDefinitions := TableDefinitions + '# A tabela ' + UpperCase(Fields[0].AsString) + ' est� vazia!'#13#10#13#10;

                if Assigned(aParameters.OnNotification) then
                    aParameters.OnNotification(nmAfterExtractRecords
                                              ,'EXTRACT RECORD FINISHED'
                                              ,UpperCase(Fields[0].AsString) // NOME DA TABELA
                                              ,TableInsertions.RecordCount // QTD DE REGISTROS
                                              ,0);

                TableInsertions.Close;

                if Assigned(aParameters.OnNotification) then
                    aParameters.OnNotification(nmEndExtractTable
                                              ,UpperCase(Fields[0].AsString)  // NOME DA TABELA
                                              ,''
                                              ,RecordCount // QTD DE TABELAS
                                              ,RecNo); // NUMERO DA TABELA DA VEZ

//                aParameters.aProgressBar.StepIt;
//                if aParameters.aProgressBar.Max > 0 then
//                    aParameters.aLabelPercentDone.Caption := Format('%d%%',[Round(aParameters.aProgressBar.Position / aParameters.aProgressBar.Max * 100)])
//                else
//                    aParameters.aLabelPercentDone.Caption := '0%';

                Next;
            end;

            if Assigned(aParameters.OnNotification) then
                aParameters.OnNotification(nmAfterExtractTables
                                          ,'EXTRACTING TABLES FINISHED'
                                          ,''
                                          ,RecordCount // QTD DE TABELAS
                                          ,0);

            Result := StringReplace(Result,'[%]DBROUTINES[%]',DBRoutines,[]);
            Result := StringReplace(Result,'[%]TABLEDEFINITIONS[%]',TableDefinitions,[]);
            Result := StringReplace(Result,'[%]DBTRIGGERS[%]',DBTriggers,[]);
            Result := StringReplace(Result,'[%]TABLECONSTRAINTS[%]',TableConstraints,[]);
            Result := StringReplace(Result,'[%]DBVIEWS[%]',StringReplace(DBViews,UpperCase(aParameters.DataBaseName) + '.','',[rfReplaceAll,rfIgnoreCase]),[]);
        end;

    finally
        if Assigned(TableInsertions) then
            TableInsertions.Free;

        if Assigned(CurrentTableDefinition) then
            CurrentTableDefinition.Free;

        if Assigned(AvailableTables) then
            AvailableTables.Free;
    end;

    if Assigned(aParameters.OnNotification) then
        aParameters.OnNotification(nmFinish
                                  ,aParameters.DataBaseName
                                  ,''
                                  ,0
                                  ,0);
end;

//class function TXXXDataModule.MySQLBackupDataBase(const aZConnection: TZConnection;
//                                                  const aParameters: TMySQLBackupDataBaseParameters): String;
//const
//	{ FUTURAMENTE DETECTE PONTOS DESTE PROCEDURE ONDE PODEMOS COLOCAR EVENTOS E
//    TORNE ESTA FUN��O GENERICA. CUIDADO COM OS PROCESSMESSAGES CASO PRETENDA
//    USA-LA NO FTP SINCRONIZER }
//	MAX_QUERY_SIZE = High(SmallInt);
//	DELIMITER = '�';
//  	SQLScript =
//    '# ============================================================================ #'#13#10 +
//    '# BACKUP GERADO EM [%]CURRENTDATEANDTIME[%]                                    #'#13#10 +
//    '# ============================================================================ #'#13#10#13#10 +
//    'DROP DATABASE IF EXISTS [%]DATABASENAME[%];'#13#10#13#10 +
//    'CREATE DATABASE [%]DATABASENAME[%] DEFAULT CHARACTER SET LATIN1 COLLATE LATIN1_BIN;'#13#10#13#10 +
//    'USE [%]DATABASENAME[%];'#13#10#13#10 +
//
//  	'# ============================================================================ #'#13#10 +
//  	'# DEFINI��O DE ROTINAS - IN�CIO                                                #'#13#10 +
//  	'# ============================================================================ #'#13#10 +
//  	'[%]DBROUTINES[%]' +
//  	'# ============================================================================ #'#13#10 +
//  	'# DEFINI��O DE ROTINAS - FIM                                                   #'#13#10 +
//  	'# ============================================================================ #'#13#10#13#10 +
//
//  	'# ============================================================================ #'#13#10 +
//    '# DEFINI��O DE TABELAS - IN�CIO                                                #'#13#10 +
//    '# ============================================================================ #'#13#10 +
//  	'[%]TABLEDEFINITIONS[%]' +
//    '# ============================================================================ #'#13#10 +
//    '# DEFINI��O DE TABELAS - FIM                                                   #'#13#10 +
//    '# ============================================================================ #'#13#10#13#10 +
//
//  	'# ============================================================================ #'#13#10 +
//  	'# DEFINI��O DE TRIGGERS - IN�CIO                                               #'#13#10 +
//  	'# ============================================================================ #'#13#10 +
//  	'[%]DBTRIGGERS[%]' +
//  	'# ============================================================================ #'#13#10 +
//  	'# DEFINI��O DE TRIGGERS - FIM                                                  #'#13#10 +
//  	'# ============================================================================ #'#13#10#13#10 +
//
//    '# ============================================================================ #'#13#10 +
//    '# ADI��O DE CONSTRAINTS - IN�CIO                                               #'#13#10 +
//    '# ============================================================================ #'#13#10 +
//  	'[%]TABLECONSTRAINTS[%]' +
//    '# ============================================================================ #'#13#10 +
//    '# ADI��O DE CONSTRAINTS - FIM                                                  #'#13#10 +
//    '# ============================================================================ #'#13#10#13#10 +
//
//  	'# ============================================================================ #'#13#10 +
//  	'# DEFINI��O DE VIEWS - IN�CIO                                                  #'#13#10 +
//  	'# ============================================================================ #'#13#10 +
//    '[%]DBVIEWS[%]' +
//  	'# ============================================================================ #'#13#10 +
//  	'# DEFINI��O DE VIEWS - FIM                                                     #'#13#10 +
//  	'# ============================================================================ #';
//
//  	INSHEADER =
//  	'# == INSER��ES PARA A TABELA %s'#13#10#13#10;
//
//  	INSERT_SCHEMA =
//    'INSERT INTO %s'#13#10 +
//    'VALUES'#13#10;
//
//  	QUERY_SIZE =
//  	'# == A INSTRU��O ACIMA POSSUI %u INSER��ES (%u BYTES)';
//
//    TRIGGER_TEMPLATE =
//    'DELIMITER %s'#13#10 +
//    'CREATE TRIGGER %s %s %s'#13#10 +
//    'ON %s FOR EACH ROW'#13#10 +
//    '%s; %0:s'#13#10 +
//    'DELIMITER ;';
//
//    ROUTINE_TEMPLATE =
//    'DELIMITER %s'#13#10 +
//    '%s; %0:s'#13#10 +
//    'DELIMITER ;';
//
//function MySQLHexStr(aASCII: String): String;
//begin
//	Result := Hex(aASCII);
//    if Result <> '' then
//    	Result := 'x' + QuotedStr(Result)
//    else
//        Result := 'NULL';
//end;
//
//{ TODO -oCarlos Feitoza -cOTIMIZA��O : Existem algumas partes dessa rotina que
//est�o realizando coisas muito for�adamente (gambiarras) tente otimizar,
//principalmente a parte de extra��o de constraints. Acho que deve ter uma forma
//de obte-las pelo dicionario de dados }
//var
//	DatabasePart, CurrentPart, AvailableTables, CurrentTableDefinition,
//    TableInsertions: TZReadOnlyQuery;
//    DBRoutines, DBViews, DBTriggers,
//  	TableDefinitions, CurrentDefinition, TableConstraints, CurrentConstraint, ValuesPart, CurrentQuery: String;
//  	i, QuerySize: Word;
//  	CurrentRow: Cardinal;
//begin
//    Result := StringReplace(SQLScript,'[%]CURRENTDATEANDTIME[%]',FormatDateTime('dd/mm/yyyy "�s" hh:nn:ss',Now) + '  ',[]);
//    Result := StringReplace(Result,'[%]DATABASENAME[%]',aParameters.DataBaseName,[rfReplaceAll]);
//
//    if Assigned(aParameters.OnNotification) then
//        aParameters.OnNotification(nmStart
//                                  ,aParameters.DataBaseName
//                                  ,''
//                                  ,0
//                                  ,0);
//
//    try
//        DatabasePart := TZReadOnlyQuery.Create(nil);
//        CurrentPart := TZReadOnlyQuery.Create(nil);
//
//  	    { == Extra��o de stored routines ===================================== }
//        DBRoutines := '';
//        ConfigureDataSet(aZConnection
//                        ,DatabasePart
//                        ,'SELECT SPECIFIC_NAME, ROUTINE_TYPE FROM information_schema.ROUTINES WHERE UPPER(ROUTINE_SCHEMA) = UPPER(' + QuotedStr(aParameters.DataBaseName) + ')'
//                        ,False);
//
//        if Assigned(aParameters.OnNotification) then
//            aParameters.OnNotification(nmBeforeExtractStoredRoutines
//                                      ,'EXTRACTING STORED ROUTINES STARTED'
//                                      ,''
//                                      ,DatabasePart.RecordCount // QTD DE STORED ROUTINES
//                                      ,0);
//
//        if DatabasePart.RecordCount > 0 then
//            while not DatabasePart.Eof do
//            begin
//                if UpperCase(DatabasePart.Fields[1].AsString) = 'FUNCTION' then
//                    ConfigureDataSet(aZConnection,CurrentPart,'SHOW CREATE FUNCTION ' + UpperCase(aParameters.DataBaseName) + '.' + DatabasePart.Fields[0].AsString,False)
//                else if UpperCase(DatabasePart.Fields[1].AsString) = 'PROCEDURE' then
//                    ConfigureDataSet(aZConnection,CurrentPart,'SHOW CREATE PROCEDURE ' + UpperCase(aParameters.DataBaseName) + '.' + DatabasePart.Fields[0].AsString,False);
//
//                if Assigned(aParameters.OnNotification) then
//                    aParameters.OnNotification(nmBeginExtractStoredRoutine
//                                              ,DatabasePart.Fields[0].AsString  // NOME DA STORED ROUTINE
//                                              ,UpperCase(DatabasePart.Fields[1].AsString) // TIPO DA STORED ROUTINE
//                                              ,DatabasePart.RecordCount // QTD DE STORED ROUTINES
//                                              ,DatabasePart.RecNo); // NUMERO DA STORED ROUTINE ATUAL
//
//                DBRoutines := DBRoutines + Format(ROUTINE_TEMPLATE,[DELIMITER,CurrentPart.Fields[2].AsString]);
//
//                if DatabasePart.RecNo < DatabasePart.RecordCount then
//	                DBRoutines := DBRoutines + #13#10#13#10
//                else
//                	DBRoutines := DBRoutines + #13#10;
//
//                if Assigned(aParameters.OnNotification) then
//                    aParameters.OnNotification(nmEndExtractStoredRoutine
//                                              ,DatabasePart.Fields[0].AsString  // NOME DA STORED ROUTINE
//                                              ,UpperCase(DatabasePart.Fields[1].AsString) // TIPO DA STORED ROUTINE
//                                              ,DatabasePart.RecordCount // QTD DE STORED ROUTINES
//                                              ,DatabasePart.RecNo); // NUMERO DA STORED ROUTINE ATUAL
//
//                DatabasePart.Next;
//            end
//        else
//            DBRoutines := #13#10'# A base de dados ' + UpperCase(aParameters.DataBaseName) + ' n�o possui stored routines!'#13#10#13#10;
//
//        if Assigned(aParameters.OnNotification) then
//            aParameters.OnNotification(nmAfterExtractStoredRoutines
//                                      ,'EXTRACTING STORED ROUTINES FINISHED'
//                                      ,''
//                                      ,DatabasePart.RecordCount // QTD DE STORED ROUTINES
//                                      ,0);
//  	    { ==================================================================== }
//
//  	    { == Extra��o de vis�es ============================================== }
//        DBViews := '';
//        ConfigureDataSet(aZConnection
//                        ,DatabasePart
//                        ,'SELECT TABLE_NAME FROM INFORMATION_SCHEMA.TABLES WHERE UPPER(TABLE_SCHEMA) = UPPER(' + QuotedStr(aParameters.DataBaseName) + ') AND TABLE_TYPE = ''VIEW'''
//                        ,False);
//
//        if Assigned(aParameters.OnNotification) then
//            aParameters.OnNotification(nmBeforeExtractViews
//                                      ,'EXTRACTING VIEWS STARTED'
//                                      ,''
//                                      ,DatabasePart.RecordCount // QTD DE VIEWS
//                                      ,0);
//
//        if DatabasePart.RecordCount > 0 then
//            while not DatabasePart.Eof do
//            begin
//                if Assigned(aParameters.OnNotification) then
//                    aParameters.OnNotification(nmBeginExtractView
//                                              ,DatabasePart.Fields[0].AsString  // NOME DA VIEW
//                                              ,''
//                                              ,DatabasePart.RecordCount // QTD DE VIEWS
//                                              ,DatabasePart.RecNo); // NUMERO DA VIEW ATUAL;
//
//                ConfigureDataSet(aZConnection
//                                ,CurrentPart
//                                ,'SHOW CREATE VIEW ' + UpperCase(aParameters.DataBaseName) + '.' + DatabasePart.Fields[0].AsString
//                                ,False);
//
//                DBViews := DBViews + CurrentPart.Fields[1].AsString + ';';
//
//                if DatabasePart.RecNo < DatabasePart.RecordCount then
//	                DBViews := DBViews + #13#10#13#10
//                else
//                	DBViews := DBViews + #13#10;
//
//                if Assigned(aParameters.OnNotification) then
//                    aParameters.OnNotification(nmEndExtractView
//                                              ,DatabasePart.Fields[0].AsString  // NOME DA VIEW
//                                              ,''
//                                              ,DatabasePart.RecordCount // QTD DE VIEWS
//                                              ,DatabasePart.RecNo); // NUMERO DA VIEW ATUAL;
//
//                DatabasePart.Next;
//            end
//        else
//            DBViews := #13#10'# A base de dados ' + UpperCase(aParameters.DataBaseName) + ' n�o possui views!'#13#10#13#10;
//
//        if Assigned(aParameters.OnNotification) then
//            aParameters.OnNotification(nmAfterExtractViews
//                                      ,'EXTRACTING VIEWS FINISHED'
//                                      ,''
//                                      ,DatabasePart.RecordCount // QTD DE VIEWS
//                                      ,0);
//  	    { ==================================================================== }
//
//        { == Extra��o de triggers ============================================ }
//        DBTriggers := '';
//	    ConfigureDataSet(aZConnection
//                        ,DatabasePart
//                        ,'SELECT TRIGGER_NAME, EVENT_MANIPULATION, EVENT_OBJECT_TABLE, ACTION_STATEMENT, ACTION_TIMING FROM INFORMATION_SCHEMA.TRIGGERS WHERE UPPER(TRIGGER_SCHEMA) = UPPER(' + QuotedStr(aParameters.DataBaseName) + ')'
//                        ,False);
//
//        if Assigned(aParameters.OnNotification) then
//            aParameters.OnNotification(nmBeforeExtractTriggers
//                                      ,'EXTRACTING TRIGGERS STARTED'
//                                      ,''
//                                      ,DatabasePart.RecordCount // QTD DE TRIGGERS
//                                      ,0);
//
//	    if DatabasePart.RecordCount > 0 then
//            while not DatabasePart.Eof do
//            begin
//                if Assigned(aParameters.OnNotification) then
//                    aParameters.OnNotification(nmBeginExtractTrigger
//                                              ,UpperCase(DatabasePart.Fields[0].AsString)  // NOME DO TRIGGER
//                                              ,UpperCase(DatabasePart.Fields[2].AsString)  // TABELA RELACIONADA
//                                              ,DatabasePart.RecordCount // QTD DE TRIGGERS
//                                              ,DatabasePart.RecNo);
//
//                DBTriggers := DBTriggers + Format(TRIGGER_TEMPLATE,[
//                    DELIMITER,
//                    DatabasePart.Fields[0].AsString,
//                    DatabasePart.Fields[4].AsString,
//                    DatabasePart.Fields[1].AsString,
//                    DatabasePart.Fields[2].AsString,
//                    DatabasePart.Fields[3].AsString
//                ]);
//
//                if DatabasePart.RecNo < DatabasePart.RecordCount then
//	                DBTriggers := DBTriggers + #13#10#13#10
//                else
//                	DBTriggers := DBTriggers + #13#10;
//
//                if Assigned(aParameters.OnNotification) then
//                    aParameters.OnNotification(nmEndExtractTrigger
//                                              ,UpperCase(DatabasePart.Fields[0].AsString)  // NOME DO TRIGGER
//                                              ,UpperCase(DatabasePart.Fields[2].AsString)  // TABELA RELACIONADA
//                                              ,DatabasePart.RecordCount // QTD DE TRIGGERS
//                                              ,DatabasePart.RecNo);
//
//                DatabasePart.Next;
//            end
//    	else
//        	DBTriggers := #13#10'# A base de dados ' + UpperCase(aParameters.DataBaseName) + ' n�o possui triggers!'#13#10#13#10;
//
//        if Assigned(aParameters.OnNotification) then
//            aParameters.OnNotification(nmAfterExtractTriggers
//                                      ,'EXTRACTING TRIGGERS FINISHED'
//                                      ,''
//                                      ,DatabasePart.RecordCount // QTD DE TRIGGERS
//                                      ,0);
//        { ==================================================================== }
//    finally
//    	if Assigned(CurrentPart) then
//        	CurrentPart.Free;
//
//        if Assigned(DatabasePart) then
//            DatabasePart.Free;
//    end;
//
//    try
//        AvailableTables := nil;
//        CurrentTableDefinition := TZReadOnlyQuery.Create(nil);
//        TableInsertions := TZReadOnlyQuery.Create(nil);
//
//        ConfigureDataSet(aZConnection
//                        ,AvailableTables
//                        ,'SELECT TABLE_NAME FROM INFORMATION_SCHEMA.TABLES WHERE UPPER(TABLE_SCHEMA) = UPPER(' + QuotedStr(aParameters.DataBaseName) + ') AND TABLE_TYPE = ''BASE TABLE''');
//
//        if Assigned(aParameters.OnNotification) then
//            aParameters.OnNotification(nmBeforeExtractTables
//                                      ,'EXTRACTING TABLES STARTED'
//                                      ,''
//                                      ,AvailableTables.RecordCount // QTD DE TABELAS
//                                      ,0);
//
//        with AvailableTables do
//        begin
//            TableDefinitions := '';
//            TableConstraints := '';
//
//            First;
//
//            while not Eof do
//            begin
//                if Assigned(aParameters.OnNotification) then
//                    aParameters.OnNotification(nmBeginExtractTable
//                                              ,UpperCase(Fields[0].AsString)  // NOME DA TABELA
//                                              ,''
//                                              ,RecordCount // QTD DE TABELAS
//                                              ,RecNo); // NUMERO DA TABELA DA VEZ
//
//                ConfigureDataSet(aZConnection
//                                ,CurrentTableDefinition
//                                ,'SHOW CREATE TABLE ' + UpperCase(aParameters.DataBaseName) + '.' + UpperCase(Fields[0].AsString)
//                                ,False);
//
//                CurrentDefinition := UpperCase(StringReplace(CurrentTableDefinition.Fields[1].AsString,#$0A,#$0D#$0A,[rfReplaceAll]));
//
//                if Pos('  CONSTRAINT',CurrentDefinition) > 0 then
//                begin
//                    CurrentConstraint := 'ALTER TABLE ' + UpperCase(Fields[0].AsString) + #13#10;
//
//                    repeat
//                        i := Pos('  CONSTRAINT',CurrentDefinition);
//                        if i > 0 then
//                        begin
//                            CurrentConstraint := CurrentConstraint + StringReplace(Copy(CurrentDefinition,i,PosEx(#13#10,CurrentDefinition,i) - i + 2),'  CONSTRAINT','  ADD CONSTRAINT',[]);
//                            System.Delete(CurrentDefinition,i,PosEx(#13#10,CurrentDefinition,i) - i + 2);
//                        end;
//                    until i = 0;
//
//                    System.Insert(';',CurrentConstraint,Length(CurrentConstraint) - 1);
//                    TableConstraints := TableConstraints + CurrentConstraint + #13#10;
//                end;
//
//                // Insere ";" no final da defini��o
//                System.Insert(';',CurrentDefinition,Length(CurrentDefinition) + 1);
//
//                // Retira os coment�rios
//                i := Pos(' COMMENT=''',CurrentDefinition);
//                if i > 0 then
//                    System.Delete(CurrentDefinition,i,PosEx(';',CurrentDefinition,i) - i);
//
//                TableDefinitions := TableDefinitions + StringReplace(CurrentDefinition,','#13#10')',#13#10')',[]) + #13#10#13#10;
//
//                TableDefinitions := TableDefinitions + Format(INSHEADER,[UpperCase(Fields[0].AsString)]);
//
//                ConfigureDataSet(aZConnection
//                                ,TableInsertions
//                                ,'SELECT * FROM ' + UpperCase(aParameters.DataBaseName) + '.' + Fields[0].AsString
//                                ,False);
//
//                if Assigned(aParameters.OnNotification) then
//                    aParameters.OnNotification(nmBeforeExtractRecords
//                                              ,'EXTRACT RECORD STARTED'
//                                              ,UpperCase(Fields[0].AsString) // NOME DA TABELA
//                                              ,TableInsertions.RecordCount // QTD DE REGISTROS
//                                              ,0);
//
//                if TableInsertions.RecordCount > 0 then
//                begin
//
//                    { QuerySize ser� acumulado at� que ele contenha um valor de
//                    no m�ximo MAX_QUERY_SIZE, quando CurrentQuery � conclu�do e
//                    juntado � TableDefinitions }
//                    QuerySize := 0;
//                    CurrentRow := 0;
//
//                    while not TableInsertions.Eof do
//                    begin
//                        if Assigned(aParameters.OnNotification) then
//                            aParameters.OnNotification(nmBeginExtractRecord
//                                                      ,UpperCase(Fields[0].AsString) // NOME DA TABELA
//                                                      ,''
//                                                      ,TableInsertions.RecordCount // QTD DE REGISTROS
//                                                      ,TableInsertions.RecNo); // REGISTRO ATUAL
//                        Inc(CurrentRow);
//                        Application.ProcessMessages;
//
//                        ValuesPart := '  (';
//                        for i := 0 to Pred(TableInsertions.FieldCount) do
//                        begin
//                            // Nulo?
//                            if TableInsertions.Fields[i].IsNull then
//                                ValuesPart := ValuesPart + 'NULL'
//                            // Inteiro?
//                            else if TableInsertions.Fields[i].DataType in [ftSmallint,ftInteger,ftWord,ftLargeint] then
//                                ValuesPart := ValuesPart + TableInsertions.Fields[i].AsString
//                            // Decimal?
//                            else if TableInsertions.Fields[i].DataType in [ftFloat,ftCurrency] then
//                                ValuesPart := ValuesPart + StringReplace(TableInsertions.Fields[i].AsString,',','.',[])
//                            // Data?
//                            else if (TableInsertions.Fields[i].DataType = ftDate) then
//                                ValuesPart := ValuesPart + FormatDateTime('yyyymmdd',TableInsertions.Fields[i].AsDateTime)
//                            // Tempo?
//                            else if (TableInsertions.Fields[i].DataType = ftTime) then
//                                ValuesPart := ValuesPart + FormatDateTime('hhnnss',TableInsertions.Fields[i].AsDateTime)
//                            // Data + Tempo?
//                            else if (TableInsertions.Fields[i].DataType = ftDateTime) then
//                                ValuesPart := ValuesPart + FormatDateTime('yyyymmddhhnnss',TableInsertions.Fields[i].AsDateTime)
//                            // Bin�rio, String ou qualquer outra coisa?
//                            else
//                                ValuesPart := ValuesPart + MySQLHexStr(TableInsertions.Fields[i].AsString);
//
//                            if i < Pred(TableInsertions.FieldCount) then
//                                ValuesPart := ValuesPart + ','
//                            else
//                                ValuesPart := ValuesPart + ')'
//                        end;
//
//                        if CurrentRow = 1 then
//                            CurrentQuery := Format(INSERT_SCHEMA,[UpperCase(Fields[0].AsString)]) + ValuesPart
//                        else
//                        begin
//                            CurrentQuery := ValuesPart;
//                            if (QuerySize + Length(ValuesPart)) > MAX_QUERY_SIZE then
//                            begin
//                                TableDefinitions := TableDefinitions + ';'#13#10 + Format(QUERY_SIZE,[CurrentRow,QuerySize]) + #13#10;
//                                QuerySize := 0;
//                                CurrentRow := 1;
//                                CurrentQuery := Format(INSERT_SCHEMA,[UpperCase(Fields[0].AsString)]) + ValuesPart;
//                            end;
//                        end;
//
//                        Inc(QuerySize,Length(CurrentQuery));
//
//                        if CurrentRow = 1 then
//                            TableDefinitions := TableDefinitions + CurrentQuery
//                        else
//                            TableDefinitions := TableDefinitions + ','#13#10 + CurrentQuery;
//
//                        if Assigned(aParameters.OnNotification) then
//                            aParameters.OnNotification(nmEndExtractRecord
//                                                      ,UpperCase(Fields[0].AsString) // NOME DA TABELA
//                                                      ,''
//                                                      ,TableInsertions.RecordCount // QTD DE REGISTROS
//                                                      ,TableInsertions.RecNo); // REGISTRO ATUAL
//
//                        TableInsertions.Next;
//                    end;
//
//                    if CurrentRow > 0 then
//                        TableDefinitions := TableDefinitions + ';'#13#10 + Format(QUERY_SIZE,[CurrentRow,QuerySize]) + #13#10#13#10;
//                end
//                else
//                    TableDefinitions := TableDefinitions + '# A tabela ' + UpperCase(Fields[0].AsString) + ' est� vazia!'#13#10#13#10;
//
//                if Assigned(aParameters.OnNotification) then
//                    aParameters.OnNotification(nmAfterExtractRecords
//                                              ,'EXTRACT RECORD FINISHED'
//                                              ,UpperCase(Fields[0].AsString) // NOME DA TABELA
//                                              ,TableInsertions.RecordCount // QTD DE REGISTROS
//                                              ,0);
//
//                TableInsertions.Close;
//
//                if Assigned(aParameters.OnNotification) then
//                    aParameters.OnNotification(nmEndExtractTable
//                                              ,UpperCase(Fields[0].AsString)  // NOME DA TABELA
//                                              ,''
//                                              ,RecordCount // QTD DE TABELAS
//                                              ,RecNo); // NUMERO DA TABELA DA VEZ
//
////                aParameters.aProgressBar.StepIt;
////                if aParameters.aProgressBar.Max > 0 then
////                    aParameters.aLabelPercentDone.Caption := Format('%d%%',[Round(aParameters.aProgressBar.Position / aParameters.aProgressBar.Max * 100)])
////                else
////                    aParameters.aLabelPercentDone.Caption := '0%';
//
//                Next;
//            end;
//
//            if Assigned(aParameters.OnNotification) then
//                aParameters.OnNotification(nmAfterExtractTables
//                                      ,'EXTRACTING TABLES FINISHED'
//                                      ,''
//                                      ,DatabasePart.RecordCount // QTD DE TABELAS
//                                      ,0);
//
//            Result := StringReplace(Result,'[%]DBROUTINES[%]',DBRoutines,[]);
//            Result := StringReplace(Result,'[%]TABLEDEFINITIONS[%]',TableDefinitions,[]);
//            Result := StringReplace(Result,'[%]DBTRIGGERS[%]',DBTriggers,[]);
//            Result := StringReplace(Result,'[%]TABLECONSTRAINTS[%]',TableConstraints,[]);
//            Result := StringReplace(Result,'[%]DBVIEWS[%]',StringReplace(DBViews,UpperCase(aParameters.DataBaseName) + '.','',[rfReplaceAll,rfIgnoreCase]),[]);
//        end;
//
//    finally
//        if Assigned(TableInsertions) then
//            TableInsertions.Free;
//
//        if Assigned(CurrentTableDefinition) then
//            CurrentTableDefinition.Free;
//
//        if Assigned(AvailableTables) then
//            AvailableTables.Free;
//    end;
//
//    if Assigned(aParameters.OnNotification) then
//        aParameters.OnNotification(nmFinish
//                                  ,aParameters.DataBaseName
//                                  ,''
//                                  ,0
//                                  ,0);
//end;

class procedure TXXXDataModule.CompressFile(const aInputFile
                                                , aOutputFile: TFileName;
                                                  OnNotification: TZlibNotification);
var
    InputFile, OutputFile: TFileStream;
    CompressionStream: TCompressionStream;
begin
    InputFile := nil;
    OutputFile := nil;
    CompressionStream := nil;
    try
        InputFile := TFileStream.Create(aInputFile, fmOpenRead and fmShareExclusive);
        OutputFile := TFileStream.Create(aOutputFile, fmCreate or fmShareExclusive);
        CompressionStream := TCompressionStream.Create(clMax, OutputFile);
//        CompressionStream.OnProgress :=
        if Assigned(OnNotification) then
            OnNotification(zlntBeforeProcess,zloCompress,aInputFile,aOutputFile);

        CompressionStream.CopyFrom(InputFile,InputFile.Size);

        if Assigned(OnNotification) then
            OnNotification(zlntAfterProcess,zloCompress,aInputFile,aOutputFile);
    finally
        CompressionStream.Free;
        OutputFile.Free;
        InputFile.Free;
    end;
end;

class procedure TXXXDataModule.DecompressFile(const aInputFile
                                                  , aOutputFile: TFileName;
                                                    OnNotification: TZlibNotification);
var
    InputFile, OutputFile: TFileStream;
    DecompressionStream: TDecompressionStream;
    i: Integer;
    Buffer: array [0..1023] of Byte;
begin
    InputFile := nil;
    OutputFile := nil;
    DecompressionStream := nil;
    try
        InputFile := TFileStream.Create(aInputFile, fmOpenRead and fmShareExclusive);
        OutputFile := TFileStream.Create(aOutputFile, fmCreate or fmShareExclusive);
        DecompressionStream := TDecompressionStream.Create(InputFile);
//        DecompressionStream.OnProgress :=
        if Assigned(OnNotification) then
            OnNotification(zlntBeforeProcess,zloDecompress,aInputFile,aOutputFile);

        repeat
            i := DecompressionStream.Read(Buffer, SizeOf(Buffer));
            if i <> 0 then
                OutputFile.Write(Buffer, i);
        until i <= 0;

        if Assigned(OnNotification) then
            OnNotification(zlntAfterProcess,zloDecompress,aInputFile,aOutputFile);
    finally
        DecompressionStream.Free;
        OutputFile.Free;
        InputFile.Free;
    end;
end;

end.
