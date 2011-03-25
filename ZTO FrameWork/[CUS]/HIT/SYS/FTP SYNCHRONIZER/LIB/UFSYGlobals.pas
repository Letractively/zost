unit UFSYGlobals;
{ TODO -oCARLOS FEITOZA -cDICAS : AQUI O PROCEDURE "AddSynchronizableItem" TEM
DE SER ALTERADO PARA INCLUIR AS REFER�NCIAS A NOVOS CAMPOS E TABELAS }

{ TODO : Futuramente isso deve ser fundido com datamodule_basic ou
datamodule_Main ou mesmo DataModule_Zero

As seguintes fun��es j� existem em DatamoduleBasic:

MySQLExecuteSQLScript
MySQLDefragDatabase
SplitSQLScript
SetLabelDescriptionValue

os tipos

TProcessorEvents
TScriptPart
TScriptParts
 }                                                      

interface

uses
    Windows, Classes, SysUtils, StdCtrls, ComCtrls,

	UFSYSyncStructures, USyncStructures, UXXXTypesConstantsAndClasses,
    UFSYTypesConstantsAndClasses,

    ZDataSet, ZConnection, ZSQLProcessor, OverbyteIcsFtpSrv, OverbyteIcsFtpCli;

type
	//PZConnection = ^TZConnection;

    TRetrSessionParameters = record
        VerboseMode: Boolean;
        UseCompression: Boolean;
        {$IFDEF DEVELOPING}
        CustIntParm: Integer;
        {$ENDIF}
    end;

    TSyncCmd = function: Boolean of object;
    
	TFSYGlobals = class
    private
    	FConfigurations: TConfigurations;
        FCurrentDir: TFileName;
        {$IFDEF FTPSYNCCLI}
        FFTPDirectory: TFileName;
        {$ENDIF}

//        {$IFDEF FTPSYNCSER}
//        FVerboseMode: Boolean;
//        {$ENDIF}

	    procedure SplitSQLScript(const aZConnection: TZConnection; aRichEdit: TRichEdit; var aScriptParts: TScriptParts; const aSQLScriptFile: TFileName = ''; const aSQLScriptText: String = ''; const aForeignKeysCheck: Boolean = True);
        procedure AddSynchronizableItem(aSyncFile: TSynchronizationFile; aZConnection: TZConnection; aTableName: String; aPrimaryKeyValue: Cardinal; aActionPerformed: TActionPerformed; aIgnoreUpdateDeletedRecordError: Boolean);
		procedure SaveConfigurations;
        {$IFDEF FTPSYNCSER}
	    function MySQLGetLastPrimaryKeyValue(aZConnection: TZConnection; aPrimaryKeyName, aTableName: String): Cardinal;
        procedure CodigoEAnoDaProposta(const aZConnection: TZConnection; const aIN_PROPOSTAS_ID: Cardinal; out aSM_CODIGO, aYR_ANO: Word);
        {$ENDIF}
    public
    	constructor Create;
        destructor Destroy; override;

        procedure ComprimirArquivo(const aNomeDoArquivo: TFileName;
                                   const aRichEdit: TRichEdit;
                                         OnNotification: TZlibNotification);
        procedure DescomprimirArquivo(const aNomeDoArquivo: TFileName;
                                      const aRichEdit: TRichEdit;
                                            OnNotification: TZlibNotification);

		function ReadConfigurations(const aConfigFile: TFileName = ''): Boolean;

        class procedure SetLabelDescriptionValue(const aLabelDescription, aLabelValue: TLabel; const aValue: String; const aSpacing: Byte = 2);
		class function Hex(aAscii: String): String;
        class function MySQLFormat(const aFormat: String; const aArgs: array of const): String;
        function CmdLineParamValue(const aParamName: String; out aParamValue: String; const aParamStarter: Char = '/'): Boolean;

		procedure ExecuteQuery(aZConnection: TZConnection; aSQLCommand: String);

        {$IFDEF FTPSYNCCLI}
    	procedure SynchronizeByDelta(    aFTPClient: TFtpClient;
                                     var aZConnection: TZConnection;
                                         aProgressBar: TProgressBar;
                                         aLabelPercentDone: TLabel;
                                         aForeignKeyChecks: Boolean;
                                     var aBusy: Boolean;
                                         aSimulation: Boolean;
                                         aRichEdit: TRichEdit;
                                         aDoCommitOnError: Boolean;
                                         aSaveGeneratedScript: Boolean;
                                         aOnZLibNotification: TZLibNotification);
	    procedure SynchronizeFull(    aFTPClient: TFtpClient;
                                  var aZConnection: TZConnection;
                                      aProgressBar: TProgressBar;
                                      aLabelPercentDone: TLabel;
                                      aProgressBarCurrent: TProgressBar;
                                      aProgressBarOverall: TProgressBar;
                                      aLabelCurrentDescription: TLabel;
                                      aLabelOverallDescription: TLabel;
                                      aLabelCurrentValue: TLabel;
                                      aLabelOverallValue: TLabel;
                                  var aBusy: Boolean;
                                      aRichEdit: TRichEdit;
                                      aOnZLibNotification: TZLibNotification);
    	procedure TakeSnapshot(    aFTPClient: TFtpClient;
                                   aZConnection: TZConnection;
                                   aMode: Byte;
                                   aProgressBar: TProgressBar;
                                   aLabelPercentDone: TLabel;
                               var aBusy: Boolean;
                                   aRichEdit: TRichEdit;
                                   aOnZLibNotification: TZLibNotification);
        procedure LocalSnapshot(aProgressBar: TProgressBar; aLabelPercentDone: TLabel; aRichEdit: TRichEdit);
    	function MySQLFullSnapShot(aZConnection: TZConnection;
                                   aProgressBar: TProgressBar;
                                   aLabelPercentDone: TLabel;
                                   aRichEdit: TRichEdit): String;
        function SendRetrSessionParameters(const aRetrSessionParameters: TRetrSessionParameters;
                                           const aFTPClient: TFtpClient;
                                           const aRichEdit: TRichEdit;
                                                 aProgressBar: TProgressBar;
                                                 aLabelPercentDone: TLabel): Boolean;

        {$IFDEF DEVELOPING}
        procedure TimeOutTest(const aFTPClient: TFtpClient;
                                var aZConnection: TZConnection;
                                var aBusy: Boolean;
                              const aRichEdit: TRichEdit;
                                    aProgressBar: TProgressBar;
                                    aLabelPercentDone: TLabel);
        procedure ContentSizeTest(const aFTPClient: TFtpClient;
                                    var aZConnection: TZConnection;
                                    var aBusy: Boolean;
                                  const aRichEdit: TRichEdit;
                                        aProgressBar: TProgressBar;
                                        aLabelPercentDone: TLabel);
        {$ENDIF}
        {$ENDIF}

        {$IFDEF FTPSYNCSER}
    	function GetTempFileNames(const aTempDir: TFileName): String;
        function GenerateRandomText(const aDataSize: Integer): String;
     	{$ENDIF}

        {$IFDEF FTPSYNCSER}
        procedure MySQLSmartSnapShot(aClient: TConnectedClient;
                                     aZConnection: TZConnection;
                                     aUseCompression: Boolean;
                                     aRichEdit: TRichEdit;
                                     aVerboseMode: Boolean;
                                     aOnZLibNotification: TZlibNotification);
    	procedure MySQLFullSnapShot(aClient: TConnectedClient;
                                    aZConnection: TZConnection;
                                    aUseCompression: Boolean;
                                    aRichEdit: TRichEdit;
                                    aVerboseMode: Boolean;
                                    aOnZLibNotification: TZlibNotification);
        procedure SendStatus(aClient: TConnectedClient;
                             aStatus: String);
        procedure ProcessClientDeltaToServerDelta(      aClient: TConnectedClient;
                                                  const aZConnection: TZConnection;
                                                  const aClientDelta
                                                      , aServerDelta: TSynchronizationFile;
                                                        aVerboseMode: Boolean);
        {$ENDIF}

		{$IFDEF FTPSYNCCLI}
        procedure InitializeProgress(aProgressBar: TProgressBar; aLabelPercentDone: TLabel; aMax: Cardinal);
    	procedure IncreaseProgress(aProgressBar: TProgressBar; aLabelPercentDone: TLabel);
    	procedure SetProgressWith(aProgressBar: TProgressBar; aLabelPercentDone: TLabel; aPosition: Cardinal);
        {$ENDIF}

    	function PutLineBreaks(const aText: String; aCharsPerLine: Byte): String;
    	function GetStringCheckSum(const aInputString: String; aHashAlgorithms: THashAlgorithms; aFinalHashAlgorithm: THashAlgorithm = haIgnore): String;
        function GetFileCheckSum(const aFileName: TFileName; aHashAlgorithms: THashAlgorithms; aFinalHashAlgorithm: THashAlgorithm = haIgnore): String;
        function DatabaseCheckSum(const aZConnection: TZConnection; aHomeDir: TFileName; aOnGetChecksum: TOnGetChecksum): String;
    	function MySQLGetUserVariable(const aZConnection: TZConnection; aVariableName: String): TMultiTypedResult;
        procedure MySQLSetDBUserVariable(const aZConnection: TZConnection; aVariableName: String; aVariableValue: Int64); overload;
        procedure MySQLSetDBUserVariable(const aZConnection: TZConnection; aVariableName: String; aVariableValue: Boolean); overload;
        procedure MySQLSetDBUserVariable(const aZConnection: TZConnection; aVariableName, aVariableValue: String); overload;
        procedure MySQLSetVariable(aZConnection: TZConnection; aVariableName: String; aVariableValue: Int64);

		function MySQLDateTimeFormat(aDateTimeValue: TDateTime): String;
//    	function MySQLDatabaseCheckSum(const aZConnection: TZConnection; const aTablesToIgnore, aFieldsToIgnore: array of String; aHomeDir: TFileName{$IFDEF FTPSYNCSER}; aClient: TFtpCtrlSocket{$ENDIF}): String;
        procedure MySQLExecuteSQLScript(aZConnection: TZConnection; aRichEdit: TRichEdit; const aSQLScriptFile: TFileName = ''; const aSQLScriptText: String = ''; const aForeignKeysCheck: Boolean = True; aProgressBarCurrent: TProgressBar = nil; aProgressBarOverall: TProgressBar = nil; aLabelCurrentDescription: TLabel = nil; aLabelOverallDescription: TLabel = nil; aLabelCurrentValue: TLabel = nil; aLabelOverallValue: TLabel = nil);
//        procedure MySQLDefragDatabase(aZConnection: TZConnection; aProgressBar: TProgressBar = nil; aLabelPercentDone: TLabel = nil);
		procedure ExecuteDeltaFile(aZConnection: TZConnection; aRichEdit: TRichEdit; const aUsePrimaryKeyValue: Boolean; const aInputFile: TFileName; const aOutputFile: TFileName; const aForeignKeysCheck: Boolean = True; aProgressBar: TProgressBar = nil; aLabelPercentDone: TLabel = nil);
        procedure GenerateDeltaFile({$IFDEF FTPSYNCSER}aClient: TConnectedClient;{$ENDIF}
                                    aZConnection: TZConnection;
                                    aOutputFile: TFileName;
                                    aRichEdit: TRichEdit;
                                    aVerboseMode: Boolean;
                                    aDeltaFilter: String = '';
                                    aOpenFileIfExists: Boolean = False;
                                    aProgressBar: TProgressBar = nil;
                                    aLabelPercentDone: TLabel = nil);
        procedure LoadDeltaFile(aDeltaFile: TFileName; out aSynchronizationFile: TSynchronizationFile; const aUsePrimaryKeyValue: Boolean);
    	procedure ConfigureConnection(var aZConnection: TZConnection; theProtocol, theHostName, theUserName, thePassword, theDatabase: String; thePortNumber: Word; UseDatabase: Boolean = True); overload;
    	procedure ConfigureConnection(var aZConnection: TZConnection; UseDatabase: Boolean = True); overload;
        procedure ConfigureDataSet(aZConnection: TZConnection; var aDataSet: TZReadOnlyQuery; aSQLCommand: String); overload;
    	procedure ConfigureDataSet(aZConnection: TZConnection; var aDataSet: TZQuery; aSQLCommand: String); overload;
        procedure ShowOnLog(const aText: String; aRichEdit: TRichEdit);
        procedure SaveTextFile(aText: String; const aFileName: TFileName);
        function LoadTextFile(const aFileName: TFileName): String;
        procedure WaitFor(const aSeconds: Byte; const aUseProcessMessages: Boolean = True);
        {$IFDEF FTPSYNCCLI}
    	procedure AddAllUniqueIndexes(aRichEdit: TRichEdit);
        procedure AddUniqueIndex(aConnection: TZConnection; aTableName, aIndexName, aFieldValue: String; aRichEdit: TRichEdit);
        procedure DropAllUniqueIndexes(aRichEdit: TRichEdit);
        procedure DropUniqueIndex(aConnection: TZConnection; aTableName, aIndexName: String; aRichEdit: TRichEdit);


        { TODO : Abaixo algumas coisas podem ser colocadas como private }
        procedure ConnectToServer(aFTPClient: TFtpClient; aHostName: String; aPortNumb: Word; aRichEdit: TRichEdit);
        procedure CheckVersion(aFTPClient: TFtpClient; aRichEdit: TRichEdit);
		procedure Authenticate(aFTPClient: TFtpClient; var aZConnection: TZConnection; aUserName, aPassWord: String; aAutomatic: Boolean; aUseDataBaseName: Boolean; var aBusy: Boolean; aRichEdit: TRichEdit);
        function ExecuteCmd(aFTPClient: TFtpClient; aSyncCmd: TSyncCmd; aRichEdit: TRichEdit; aDescription: String = ''; aProgressBar: TProgressBar = nil; aLabelPercentDone: TLabel = nil): Boolean;
        procedure ClearDirectory(aDirectory: String);
        procedure AbortEverything(aFTPClient: TFtpClient; aErrorMessage: String; var aBusy: Boolean; aRichEdit: TRichEdit);
    	function MD5Get(aFTPClient: TFtpClient; aProgressBar: TProgressBar; aLabelPercentDone: TLabel; aLocalFileName, aRemoteFileName: String; aRichEdit: TRichEdit; aMaxTries: Byte = 5): Boolean;
    	function MD5Put(aFTPClient: TFtpClient; aProgressBar: TProgressBar; aLabelPercentDone: TLabel; aLocalFileName, aRemoteFileName: String; aRichEdit: TRichEdit; aMaxTries: Byte = 5): Boolean;
		function ChecarMd5(aFTPClient: TFTPClient; aFileName: String; aTryNo: Byte; aEraseCopyOn: Char; aRichEdit: TRichEdit): Boolean;
        function DatabaseCheckSumCompare(aFTPClient: TFTPClient; aZConnection: TZConnection; aProgressBar: TProgressBar; aLabelPercentDone: TLabel; aRichEdit: TRichEdit; aOnGetChecksum: TOnGetChecksum): Boolean;
	    procedure CreateLastSynchronizedOnFile(aZConnection: TZConnection);
	    function SendLastSyncDateAndTime(aFTPClient: TFtpClient; aZConnection: TZConnection; aProgressBar: TProgressBar; aLabelPercentDone: TLabel; aRichEdit: TRichEdit): Boolean;
        function ClearDeltaAndSaveLastSyncDateTime(aFTPClient: TFtpClient; aZConnection: TZConnection; aProgressBar: TProgressBar; aLabelPercentDone: TLabel; aSaveLastSyncDateTime: Boolean; aRichEdit: TRichEdit): Boolean;
    	procedure ConfirmEverything(aFTPClient: TFtpClient; aZConnection: TZConnection; aProgressBar: TProgressBar; aLabelPercentDone: TLabel; aSimulation: Boolean; aRichEdit: TRichEdit);
	    procedure GetTemporaryData(aFTPClient: TFtpClient; aZConnection: TZConnection; aProgressBar: TProgressBar; aLabelPercentDone: TLabel; var aBusy: Boolean; aRichEdit: TRichEdit);
		procedure ReplaceLogLastLine(aRichEdit: TRichEdit; aText: String);




        {$ENDIF}
        function FileSize(aFileName: TFileName; aFileSizeIn: TFileSizeUnit = fsuBytes): Double;
	    function GetClientLastSyncDateAndTime(Client: TConnectedClient): TDateTime;

		property Configurations: TConfigurations read FConfigurations;
		property CurrentDir: TFileName read FCurrentDir {$IFDEF BDO}write FCurrentDir{$ENDIF};
        {$IFDEF FTPSYNCCLI}
        property FTPDirectory: TFileName read FFTPDirectory {$IFDEF BDO}write FFTPDirectory{$ENDIF};
        {$ENDIF}

//        {$IFDEF FTPSYNCSER}
//        property VerboseMode: Boolean write FVerboseMode;
//        {$ENDIF}
    end;

implementation

uses
  Forms, Graphics, Messages, Controls, DB, StrUtils, ExtCtrls,

  ZDBCIntfs, ZScriptParser, ZAbstractRoDataSet, DCPsha512, DCPsha256, DCPsha1,
  DCPripemd160, DCPripemd128, DCPmd5, DCPmd4, DCPhaval, DCPtiger, DCPcrypt2, OverbyteIcsWSocket,
  UObjectFile, UXXXDataModule;

{ TFSYGlobals }

class function TFSYGlobals.Hex(aASCII: String): String;
begin
	Result := TXXXDataModule.Hex(aASCII);
    if Result <> '' then
    	Result := 'x' + QuotedStr(Result)
    else
        Result := 'NULL';
end;

function TFSYGlobals.CmdLineParamValue(const aParamName: String; out aParamValue: String; const aParamStarter: Char = '/'): Boolean;
begin
    Result := TXXXDataModule.CmdLineParamValue(aParamName,aParamValue,aParamStarter);
end;

class function TFSYGlobals.MySQLFormat(const aFormat: String; const aArgs: array of const): String;
begin
    Result := TXXXDataModule.MySQLFormat(aFormat,aArgs);
end;

{$IFDEF FTPSYNCCLI}
procedure TFSYGlobals.IncreaseProgress(aProgressBar: TProgressBar; aLabelPercentDone: TLabel);
begin
  	aProgressBar.StepIt;

  	if aProgressBar.Max > 0 then
  		aLabelPercentDone.Caption := Format('%d%%',[Round(aProgressBar.Position / aProgressBar.Max * 100)])
  	else
  		aLabelPercentDone.Caption := '0%';

  	Application.ProcessMessages;
end;{$ENDIF}

{$IFDEF FTPSYNCCLI}
procedure TFSYGlobals.SetProgressWith(aProgressBar: TProgressBar; aLabelPercentDone: TLabel; aPosition: Cardinal);
begin
	aProgressBar.Position := aPosition;

  	if aProgressBar.Max > 0 then
  		aLabelPercentDone.Caption := Format('%d%%',[Round(aProgressBar.Position / aProgressBar.Max * 100)])
  	else
  		aLabelPercentDone.Caption := '0%';

  	Application.ProcessMessages;
end;{$ENDIF}

{$IFDEF FTPSYNCCLI}
procedure TFSYGlobals.InitializeProgress(aProgressBar: TProgressBar; aLabelPercentDone: TLabel; aMax: Cardinal);
begin
	if Assigned(aProgressBar) then
    begin
        aProgressBar.Max := aMax;
        aProgressBar.Position := 0;
        aProgressBar.Step := 1;
    end;

    if Assigned(aLabelPercentDone) then
	  	aLabelPercentDone.Caption := '0%';
end;{$ENDIF}

procedure TFSYGlobals.ExecuteQuery(aZConnection: TZConnection; aSQLCommand: String);
var
	WODataSet: TZQuery;
  	LocalSQLCommand: String;
begin
	LocalSQLCommand := Trim(UpperCase(aSQLCommand));
    WODataSet := nil;

    if Assigned(aZConnection) then
    	try
      		try
        		WODataSet := TZQuery.Create(nil);
		        with WODataSet do
        		begin
		        	Connection := aZConnection;
          			ReadOnly := False;
          			SQL.Text := LocalSQLCommand;
          			ExecSQL;
        		end;
            except
        		on EZSE: EZSQLException do
        		begin
        			EZSE.Message := Format(rs_ezse,['ExecuteQuery',PutLineBreaks(EZSE.Message,80)]);
          			raise;
        		end;
                on E: Exception do
                begin
                    E.Message := Format(rs_exc,['ExecuteQuery',PutLineBreaks(E.Message,80)]);
                    raise;
                end;
      		end;
    	finally
      		if Assigned(WODataSet) then
        		WODataSet.Free;
    	end;
end;

function TFSYGlobals.PutLineBreaks(const aText: String; aCharsPerLine: Byte): String;
var
	BreakPos: Byte;
    LineToAdd: String;
    BreakableText: String;
begin
    if Length(aText) > aCharsPerLine then
        with TStringList.Create do
        begin
        	BreakableText := Trim(aText) + #0;

            while BreakableText <> '' do
            begin
            	if Pred(Length(BreakableText)) > aCharsPerLine then
	            	BreakPos := aCharsPerLine
                else
                	BreakPos := Length(BreakableText);

            	while (BreakableText[BreakPos] <> #32) and (BreakableText[BreakPos] <> #0) do
                	Dec(BreakPos);

                LineToAdd := Trim(Copy(BreakableText,1,BreakPos));

	            Add(LineToAdd);
    	        System.Delete(BreakableText,1,BreakPos);
            end;
            Result := StringReplace(Trim(Text),#$0D#$0A,'\n',[rfReplaceAll]);
            Free;
        end
    else
    	Result := aText;
end;

function TFSYGlobals.MySQLGetUserVariable(const aZConnection: TZConnection;
                                                aVariableName: String): TMultiTypedResult;
begin
    Result := TXXXDataModule.GetMySQLUserVariable(aZConnection,aVariableName);
end;

//function TFSYGlobals.MySQLGetUserVariable(const aZConnection: TZConnection; aVariableName: String): TMultiTypedResult;
//var
//	RODataSet: TZReadOnlyQuery;
//begin
//	ZeroMemory(@Result,SizeOf(TMultiTypedResult));
//    RODataSet := nil;
//	try
//		ConfigureDataSet(aZConnection,RODataSet,'SELECT @' + aVariableName);
//
//        if RODataSet.Fields[0].IsNull then
//            raise Exception.Create('A vari�vel "' + aVariableName + '" n�o existe!');
//
//
//        { TODO : Isto precisa ser refeito. N�o est� completo e nem correto }
//        with Result do
//        begin
//    		AsByte := Byte(RODataSet.Fields[0].AsInteger);
//            AsWord := Word(RODataSet.Fields[0].AsInteger);
//            AsDWord := RODataSet.Fields[0].AsInteger;
//            AsShortInt := ShortInt(RODataSet.Fields[0].AsInteger);
//            AsSmallInt := SmallInt(RODataSet.Fields[0].AsInteger);
//        	AsInteger :=  RODataSet.Fields[0].AsInteger;
//            AsInt64 := RODataSet.Fields[0].AsInteger;
//	        AsChar := RODataSet.Fields[0].AsString[1];
//            AsString := String(RODataSet.Fields[0].AsString);
//            AsString := RODataSet.Fields[0].AsString;
//            AsSingle := RODataSet.Fields[0].AsFloat;
//            AsDouble := RODataSet.Fields[0].AsFloat;
//            AsCurrency := RODataSet.Fields[0].AsCurrency;
//            AsDateTime := RODataSet.Fields[0].AsFloat;
//        end;
//
//    finally
//    	RODataSet.Free;
//    end;
//end;


function TFSYGlobals.MySQLDateTimeFormat(aDateTimeValue: TDateTime): String;
begin
	Result := FormatDateTime('yyyymmddhhnnss',aDateTimeValue);
end;

{ TODO -oCarlos Feitoza -cATUALIZA��O : Acho que este procedimento deveria estar na unit de sync structures ou mesmo em seu pai imediato... acho que deve haver outras nesta mesma situa��o }
{ TODO -oCARLOS FEITOZA -cDESCRI��O : Este procedure adiciona um �tem sincroniz�vel dentro do objeto de sincroniza��o (TSynchronizationFile) passado como par�metro }
procedure TFSYGlobals.AddSynchronizableItem(aSyncFile: TSynchronizationFile;
                                            aZConnection: TZConnection;
                                            aTableName: String;
                                            aPrimaryKeyValue: Cardinal;
                                            aActionPerformed: TActionPerformed;
                                            aIgnoreUpdateDeletedRecordError: Boolean);
const
	SQL = 'SELECT * FROM %s WHERE %s = %u';
var
    RODataSet: TZReadOnlyQuery;
begin
    RODataSet := nil;
	try
        RODataSet := TZReadOnlyQuery.Create(aZConnection);
        RODataSet.Connection := aZConnection;

	    if aTableName = 'ENTIDADESDOSISTEMA' then
            RODataSet.SQL.Text := Format(SQL,[aTableName,aSyncFile.EntidadesDoSistema.PrimaryKeyName,aPrimaryKeyValue])
        else if aTableName = 'EQUIPAMENTOS' then
            RODataSet.SQL.Text := Format(SQL,[aTableName,aSyncFile.Equipamentos.PrimaryKeyName,aPrimaryKeyValue])
        else if aTableName = 'FAMILIAS' then
            RODataSet.SQL.Text := Format(SQL,[aTableName,aSyncFile.Familias.PrimaryKeyName,aPrimaryKeyValue])
        else if aTableName = 'GRUPOS' then
            RODataSet.SQL.Text := Format(SQL,[aTableName,aSyncFile.Grupos.PrimaryKeyName,aPrimaryKeyValue])
        else if aTableName = 'ICMS' then
            RODataSet.SQL.Text := Format(SQL,[aTableName,aSyncFile.Icmss.PrimaryKeyName,aPrimaryKeyValue])
        else if aTableName = 'INSTALADORES' then
            RODataSet.SQL.Text := Format(SQL,[aTableName,aSyncFile.Instaladores.PrimaryKeyName,aPrimaryKeyValue])
        else if aTableName = 'PROJETISTAS' then
            RODataSet.SQL.Text := Format(SQL,[aTableName,aSyncFile.Projetistas.PrimaryKeyName,aPrimaryKeyValue])
        else if aTableName = 'REGIOES' then
            RODataSet.SQL.Text := Format(SQL,[aTableName,aSyncFile.Regioes.PrimaryKeyName,aPrimaryKeyValue])
        else if aTableName = 'SITUACOES' then
            RODataSet.SQL.Text := Format(SQL,[aTableName,aSyncFile.Situacoes.PrimaryKeyName,aPrimaryKeyValue])
        else if aTableName = 'TIPOS' then
            RODataSet.SQL.Text := Format(SQL,[aTableName,aSyncFile.Tipos.PrimaryKeyName,aPrimaryKeyValue])
        else if aTableName = 'UNIDADES' then
            RODataSet.SQL.Text := Format(SQL,[aTableName,aSyncFile.Unidades.PrimaryKeyName,aPrimaryKeyValue])
        else if aTableName = 'USUARIOS' then
            RODataSet.SQL.Text := Format(SQL,[aTableName,aSyncFile.Usuarios.PrimaryKeyName,aPrimaryKeyValue])
        else if aTableName = 'JUSTIFICATIVAS' then
            RODataSet.SQL.Text := Format(SQL,[aTableName,aSyncFile.Justificativas.PrimaryKeyName,aPrimaryKeyValue])
        else if aTableName = 'JUSTIFICATIVASDASOBRAS' then
            RODataSet.SQL.Text := Format(SQL,[aTableName,aSyncFile.JustificativasDasObras.PrimaryKeyName,aPrimaryKeyValue])
        else if aTableName = 'PERMISSOESDOSGRUPOS' then
            RODataSet.SQL.Text := Format(SQL,[aTableName,aSyncFile.PermissoesDosGrupos.PrimaryKeyName,aPrimaryKeyValue])
        else if aTableName = 'PERMISSOESDOSUSUARIOS' then
            RODataSet.SQL.Text := Format(SQL,[aTableName,aSyncFile.PermissoesDosUsuarios.PrimaryKeyName,aPrimaryKeyValue])
        else if aTableName = 'GRUPOSDOSUSUARIOS' then
            RODataSet.SQL.Text := Format(SQL,[aTableName,aSyncFile.GruposDosUsuarios.PrimaryKeyName,aPrimaryKeyValue])
        else if aTableName = 'REGIOESDOSUSUARIOS' then
            RODataSet.SQL.Text := Format(SQL,[aTableName,aSyncFile.RegioesDosUsuarios.PrimaryKeyName,aPrimaryKeyValue])
        else if aTableName = 'EQUIPAMENTOSDOSITENS' then
            RODataSet.SQL.Text := Format(SQL,[aTableName,aSyncFile.EquipamentosDosItens.PrimaryKeyName,aPrimaryKeyValue])
        else if aTableName = 'ITENS' then
            RODataSet.SQL.Text := Format(SQL,[aTableName,aSyncFile.Itens.PrimaryKeyName,aPrimaryKeyValue])
        else if aTableName = 'PROPOSTAS' then
            RODataSet.SQL.Text := Format(SQL,[aTableName,aSyncFile.Propostas.PrimaryKeyName,aPrimaryKeyValue])
        else if aTableName = 'OBRAS' then
            RODataSet.SQL.Text := Format(SQL,[aTableName,aSyncFile.Obras.PrimaryKeyName,aPrimaryKeyValue])
        else
        	raise Exception.Create('A tabela "' + aTableName + '" n�o est� prevista para uso com o sistema de sincroniza��o');

		RODataSet.Open;

        if aActionPerformed in [apInsert,apUpdate] then
        begin
            if not aIgnoreUpdateDeletedRecordError then
                { Acontece caso estivermos tentando atualizar um registro
                que j� foi exclu�do }
                if RODataSet.IsEmpty then
                    raise EAddSynchronizableItem.CreateFmt(aTableName
                                                          ,aPrimaryKeyValue
                                                          ,Byte(aActionPerformed)
                                                          ,'Esta entrada do DELTA (%s/%u) n�o possui seu registro correspondente'
                                                          ,[aTableName
                                                           ,aPrimaryKeyValue]);
            { Nunca deveria acontecer! }
            if RODataSet.RecordCount > 1 then
                raise EAddSynchronizableItem.CreateFmt(aTableName
                                                      ,aPrimaryKeyValue
                                                      ,Byte(aActionPerformed)
                                                      ,'Esta entrada do DELTA (%s/%u) possui mais de uma correspond�ncia f�sica'
                                                      ,[aTableName
                                                       ,aPrimaryKeyValue]);
        end
        else if aActionPerformed = apDelete then
        begin
            { Improv�vel de acontecer... Significaria que a a��o de exclus�o
            foi conclu�da, mas o registro n�o tivesse sido exclu�do
            fisicamente, talvez algum rollback em local inadequado possa
            provocar este erro }
            if not RODataSet.IsEmpty then
                raise EAddSynchronizableItem.CreateFmt(aTableName
                                                      ,aPrimaryKeyValue
                                                      ,Byte(aActionPerformed)
                                                      ,'Esta entrada do DELTA (%s/%u) refere-se a um registro exclu�do, mas o mesmo ainda existe'
                                                      ,[aTableName
                                                       ,aPrimaryKeyValue]);
        end;

	    if aTableName = 'ENTIDADESDOSISTEMA' then
            with aSyncFile.EntidadesDoSistema.Add, RODataSet do
            begin
                ActionPerformed := aActionPerformed;
        		CreateUser := FieldByName('SM_USUARIOCRIADOR_ID').AsInteger;
                UpdateUser := FieldByName('SM_USUARIOMODIFICADOR_ID').AsInteger;
                CreateDateTime := FieldByName('DT_DATAEHORADACRIACAO').AsDateTime;
        		UpdateDateTime := FieldByName('DT_DATAEHORADAMODIFICACAO').AsDateTime;
                { ------------------------------------------------------------ }
	            IN_ENTIDADESDOSISTEMA_ID := aPrimaryKeyValue;//FieldByName('IN_ENTIDADESDOSISTEMA_ID').AsInteger;
    	        VA_NOME := FieldByName('VA_NOME').AsString;
        	    TI_TIPO := FieldByName('TI_TIPO').AsInteger;
            end
        else if aTableName = 'EQUIPAMENTOS' then
            with aSyncFile.Equipamentos.Add, RODataSet do
            begin
                ActionPerformed := aActionPerformed;
        		CreateUser := FieldByName('SM_USUARIOCRIADOR_ID').AsInteger;
                UpdateUser := FieldByName('SM_USUARIOMODIFICADOR_ID').AsInteger;
                CreateDateTime := FieldByName('DT_DATAEHORADACRIACAO').AsDateTime;
        		UpdateDateTime := FieldByName('DT_DATAEHORADAMODIFICACAO').AsDateTime;
                { ------------------------------------------------------------ }
	            IN_EQUIPAMENTOS_ID := aPrimaryKeyValue;//FieldByName('IN_EQUIPAMENTOS_ID').AsInteger;
    	        VA_MODELO := FieldByName('VA_MODELO').AsString;
                FL_LUCROBRUTO := FieldByName('FL_LUCROBRUTO').AsFloat;
                FL_IPI := FieldByName('FL_IPI').AsFloat;
                FL_VALORUNITARIO := FieldByName('FL_VALORUNITARIO').AsCurrency;
                TI_MOEDA := FieldByName('TI_MOEDA').AsInteger;
                BO_DISPONIVEL := FieldByName('BO_DISPONIVEL').AsInteger = 1;
            end
        else if aTableName = 'FAMILIAS' then
            with aSyncFile.Familias.Add, RODataSet do
            begin
                ActionPerformed := aActionPerformed;
        		CreateUser := FieldByName('SM_USUARIOCRIADOR_ID').AsInteger;
                UpdateUser := FieldByName('SM_USUARIOMODIFICADOR_ID').AsInteger;
                CreateDateTime := FieldByName('DT_DATAEHORADACRIACAO').AsDateTime;
        		UpdateDateTime := FieldByName('DT_DATAEHORADAMODIFICACAO').AsDateTime;
                { ------------------------------------------------------------ }
	            TI_FAMILIAS_ID := aPrimaryKeyValue;//FieldByName('TI_FAMILIAS_ID').AsInteger;
    	        VA_DESCRICAO := FieldByName('VA_DESCRICAO').AsString;
            end
        else if aTableName = 'GRUPOS' then
            with aSyncFile.Grupos.Add, RODataSet do
            begin
                ActionPerformed := aActionPerformed;
        		CreateUser := FieldByName('SM_USUARIOCRIADOR_ID').AsInteger;
                UpdateUser := FieldByName('SM_USUARIOMODIFICADOR_ID').AsInteger;
                CreateDateTime := FieldByName('DT_DATAEHORADACRIACAO').AsDateTime;
        		UpdateDateTime := FieldByName('DT_DATAEHORADAMODIFICACAO').AsDateTime;
                { ------------------------------------------------------------ }
	            TI_GRUPOS_ID := aPrimaryKeyValue;//FieldByName('TI_GRUPOS_ID').AsInteger;
    	        VA_NOME := FieldByName('VA_NOME').AsString;
    	        VA_DESCRICAO := FieldByName('VA_DESCRICAO').AsString;
            end
        else if aTableName = 'ICMS' then
            with aSyncFile.Icmss.Add, RODataSet do
            begin
                ActionPerformed := aActionPerformed;
        		CreateUser := FieldByName('SM_USUARIOCRIADOR_ID').AsInteger;
                UpdateUser := FieldByName('SM_USUARIOMODIFICADOR_ID').AsInteger;
                CreateDateTime := FieldByName('DT_DATAEHORADACRIACAO').AsDateTime;
        		UpdateDateTime := FieldByName('DT_DATAEHORADAMODIFICACAO').AsDateTime;
                { ------------------------------------------------------------ }
	            TI_ICMS_ID := aPrimaryKeyValue;//FieldByName('TI_ICMS_ID').AsInteger;
    	        FL_VALOR := FieldByName('FL_VALOR').AsFloat;
            end
        else if aTableName = 'INSTALADORES' then
            with aSyncFile.Instaladores.Add, RODataSet do
            begin
                ActionPerformed := aActionPerformed;
        		CreateUser := FieldByName('SM_USUARIOCRIADOR_ID').AsInteger;
                UpdateUser := FieldByName('SM_USUARIOMODIFICADOR_ID').AsInteger;
                CreateDateTime := FieldByName('DT_DATAEHORADACRIACAO').AsDateTime;
        		UpdateDateTime := FieldByName('DT_DATAEHORADAMODIFICACAO').AsDateTime;
                { ------------------------------------------------------------ }
	            SM_INSTALADORES_ID := aPrimaryKeyValue;//FieldByName('SM_INSTALADORES_ID').AsInteger;
    	        VA_NOME := FieldByName('VA_NOME').AsString;
            end
        else if aTableName = 'PROJETISTAS' then
            with aSyncFile.Projetistas.Add, RODataSet do
            begin
                ActionPerformed := aActionPerformed;
        		CreateUser := FieldByName('SM_USUARIOCRIADOR_ID').AsInteger;
                UpdateUser := FieldByName('SM_USUARIOMODIFICADOR_ID').AsInteger;
                CreateDateTime := FieldByName('DT_DATAEHORADACRIACAO').AsDateTime;
        		UpdateDateTime := FieldByName('DT_DATAEHORADAMODIFICACAO').AsDateTime;
                { ------------------------------------------------------------ }
	            SM_PROJETISTAS_ID := aPrimaryKeyValue;//FieldByName('SM_PROJETISTAS_ID').AsInteger;
    	        VA_NOME := FieldByName('VA_NOME').AsString;
            end
        else if aTableName = 'REGIOES' then
            with aSyncFile.Regioes.Add, RODataSet do
            begin
                ActionPerformed := aActionPerformed;
        		CreateUser := FieldByName('SM_USUARIOCRIADOR_ID').AsInteger;
                UpdateUser := FieldByName('SM_USUARIOMODIFICADOR_ID').AsInteger;
                CreateDateTime := FieldByName('DT_DATAEHORADACRIACAO').AsDateTime;
        		UpdateDateTime := FieldByName('DT_DATAEHORADAMODIFICACAO').AsDateTime;
                { ------------------------------------------------------------ }
	            TI_REGIOES_ID:= aPrimaryKeyValue;//FieldByName('TI_REGIOES_ID').AsInteger;
    	        VA_REGIAO := FieldByName('VA_REGIAO').AsString;
    	        CH_PREFIXODAPROPOSTA := FieldByName('CH_PREFIXODAPROPOSTA').AsString;
    	        VA_PRIMEIRORODAPE := FieldByName('VA_PRIMEIRORODAPE').AsString;
    	        VA_SEGUNDORODAPE := FieldByName('VA_SEGUNDORODAPE').AsString;
            end
        else if aTableName = 'SITUACOES' then
            with aSyncFile.Situacoes.Add, RODataSet do
            begin
                ActionPerformed := aActionPerformed;
        		CreateUser := FieldByName('SM_USUARIOCRIADOR_ID').AsInteger;
                UpdateUser := FieldByName('SM_USUARIOMODIFICADOR_ID').AsInteger;
                CreateDateTime := FieldByName('DT_DATAEHORADACRIACAO').AsDateTime;
        		UpdateDateTime := FieldByName('DT_DATAEHORADAMODIFICACAO').AsDateTime;
                { ------------------------------------------------------------ }
	            TI_SITUACOES_ID := aPrimaryKeyValue;//FieldByName('TI_SITUACOES_ID').AsInteger;
    	        VA_DESCRICAO := FieldByName('VA_DESCRICAO').AsString;
    	        BO_EXPIRAVEL := FieldByName('BO_EXPIRAVEL').AsInteger = 1;
                BO_JUSTIFICAVEL := FieldByName('BO_JUSTIFICAVEL').AsInteger = 1;;
    	        TI_DIASPARAEXPIRACAO := FieldByName('TI_DIASPARAEXPIRACAO').AsInteger;
            end
        else if aTableName = 'TIPOS' then
            with aSyncFile.Tipos.Add, RODataSet do
            begin
                ActionPerformed := aActionPerformed;
        		CreateUser := FieldByName('SM_USUARIOCRIADOR_ID').AsInteger;
                UpdateUser := FieldByName('SM_USUARIOMODIFICADOR_ID').AsInteger;
                CreateDateTime := FieldByName('DT_DATAEHORADACRIACAO').AsDateTime;
        		UpdateDateTime := FieldByName('DT_DATAEHORADAMODIFICACAO').AsDateTime;
                { ------------------------------------------------------------ }
	            TI_TIPOS_ID := aPrimaryKeyValue;//FieldByName('TI_TIPOS_ID').AsInteger;
    	        VA_DESCRICAO := FieldByName('VA_DESCRICAO').AsString;
            end
        else if aTableName = 'UNIDADES' then
            with aSyncFile.Unidades.Add, RODataSet do
            begin
                ActionPerformed := aActionPerformed;
        		CreateUser := FieldByName('SM_USUARIOCRIADOR_ID').AsInteger;
                UpdateUser := FieldByName('SM_USUARIOMODIFICADOR_ID').AsInteger;
                CreateDateTime := FieldByName('DT_DATAEHORADACRIACAO').AsDateTime;
        		UpdateDateTime := FieldByName('DT_DATAEHORADAMODIFICACAO').AsDateTime;
                { ------------------------------------------------------------ }
	            TI_UNIDADES_ID := aPrimaryKeyValue;//FieldByName('TI_UNIDADES_ID').AsInteger;
    	        VA_ABREVIATURA := FieldByName('VA_ABREVIATURA').AsString;
    	        VA_DESCRICAO := FieldByName('VA_DESCRICAO').AsString;
            end
        else if aTableName = 'USUARIOS' then
            with aSyncFile.Usuarios.Add, RODataSet do
            begin
                ActionPerformed := aActionPerformed;
        		CreateUser := FieldByName('SM_USUARIOCRIADOR_ID').AsInteger;
                UpdateUser := FieldByName('SM_USUARIOMODIFICADOR_ID').AsInteger;
                CreateDateTime := FieldByName('DT_DATAEHORADACRIACAO').AsDateTime;
        		UpdateDateTime := FieldByName('DT_DATAEHORADAMODIFICACAO').AsDateTime;
                { ------------------------------------------------------------ }
	            SM_USUARIOS_ID := aPrimaryKeyValue;//FieldByName('SM_USUARIOS_ID').AsInteger;
    	        VA_NOME := FieldByName('VA_NOME').AsString;
    	        VA_LOGIN := FieldByName('VA_LOGIN').AsString;
    	        TB_SENHA := FieldByName('TB_SENHA').AsString;
    	        VA_EMAIL := FieldByName('VA_EMAIL').AsString;
            end
        else if aTableName = 'JUSTIFICATIVAS' then
            with aSyncFile.Justificativas.Add, RODataSet do
            begin
                ActionPerformed := aActionPerformed;
        		CreateUser := FieldByName('SM_USUARIOCRIADOR_ID').AsInteger;
                UpdateUser := FieldByName('SM_USUARIOMODIFICADOR_ID').AsInteger;
                CreateDateTime := FieldByName('DT_DATAEHORADACRIACAO').AsDateTime;
        		UpdateDateTime := FieldByName('DT_DATAEHORADAMODIFICACAO').AsDateTime;
                { ------------------------------------------------------------ }
	            TI_JUSTIFICATIVAS_ID := aPrimaryKeyValue;//FieldByName('TI_JUSTIFICATIVAS_ID').AsInteger;
    	        EN_CATEGORIA := FieldByName('EN_CATEGORIA').AsString[1];
    	        VA_JUSTIFICATIVA := FieldByName('VA_JUSTIFICATIVA').AsString;
            end
        else if aTableName = 'JUSTIFICATIVASDASOBRAS' then
            with aSyncFile.JustificativasDasObras.Add, RODataSet do
            begin
                ActionPerformed := aActionPerformed;
        		CreateUser := FieldByName('SM_USUARIOCRIADOR_ID').AsInteger;
                UpdateUser := FieldByName('SM_USUARIOMODIFICADOR_ID').AsInteger;
                CreateDateTime := FieldByName('DT_DATAEHORADACRIACAO').AsDateTime;
        		UpdateDateTime := FieldByName('DT_DATAEHORADAMODIFICACAO').AsDateTime;
                { ------------------------------------------------------------ }
	            MI_JUSTIFICATIVASDASOBRAS_ID := aPrimaryKeyValue;//FieldByName('MI_JUSTIFICATIVASDASOBRAS_ID').AsInteger;
    	        IN_OBRAS_ID.StoredValue := FieldByName('IN_OBRAS_ID').AsInteger;
    	        TI_JUSTIFICATIVAS_ID.StoredValue := FieldByName('TI_JUSTIFICATIVAS_ID').AsInteger;
            end
        else if aTableName = 'PERMISSOESDOSGRUPOS' then
            with aSyncFile.PermissoesDosGrupos.Add, RODataSet do
            begin
                ActionPerformed := aActionPerformed;
        		CreateUser := FieldByName('SM_USUARIOCRIADOR_ID').AsInteger;
                UpdateUser := FieldByName('SM_USUARIOMODIFICADOR_ID').AsInteger;
                CreateDateTime := FieldByName('DT_DATAEHORADACRIACAO').AsDateTime;
        		UpdateDateTime := FieldByName('DT_DATAEHORADAMODIFICACAO').AsDateTime;
                { ------------------------------------------------------------ }
	            IN_PERMISSOESDOSGRUPOS_ID := aPrimaryKeyValue;//FieldByName('IN_PERMISSOESDOSGRUPOS_ID').AsInteger;
    	        IN_ENTIDADESDOSISTEMA_ID.StoredValue := FieldByName('IN_ENTIDADESDOSISTEMA_ID').AsInteger;
    	        TI_GRUPOS_ID.StoredValue := FieldByName('TI_GRUPOS_ID').AsInteger;
    	        TI_LER := FieldByName('TI_LER').AsInteger;
    	        TI_INSERIR := FieldByName('TI_INSERIR').AsInteger;
    	        TI_ALTERAR := FieldByName('TI_ALTERAR').AsInteger;
    	        TI_EXCLUIR := FieldByName('TI_EXCLUIR').AsInteger;
            end
        else if aTableName = 'PERMISSOESDOSUSUARIOS' then
            with aSyncFile.PermissoesDosUsuarios.Add, RODataSet do
            begin
                ActionPerformed := aActionPerformed;
        		CreateUser := FieldByName('SM_USUARIOCRIADOR_ID').AsInteger;
                UpdateUser := FieldByName('SM_USUARIOMODIFICADOR_ID').AsInteger;
                CreateDateTime := FieldByName('DT_DATAEHORADACRIACAO').AsDateTime;
        		UpdateDateTime := FieldByName('DT_DATAEHORADAMODIFICACAO').AsDateTime;
                { ------------------------------------------------------------ }
	            IN_PERMISSOESDOSUSUARIOS_ID := aPrimaryKeyValue;//FieldByName('IN_PERMISSOESDOSUSUARIOS_ID').AsInteger;
    	        IN_ENTIDADESDOSISTEMA_ID.StoredValue := FieldByName('IN_ENTIDADESDOSISTEMA_ID').AsInteger;
    	        SM_USUARIOS_ID.StoredValue := FieldByName('SM_USUARIOS_ID').AsInteger;
    	        TI_LER := FieldByName('TI_LER').AsInteger;
    	        TI_INSERIR := FieldByName('TI_INSERIR').AsInteger;
    	        TI_ALTERAR := FieldByName('TI_ALTERAR').AsInteger;
    	        TI_EXCLUIR := FieldByName('TI_EXCLUIR').AsInteger;
            end
        else if aTableName = 'GRUPOSDOSUSUARIOS' then
            with aSyncFile.GruposDosUsuarios.Add, RODataSet do
            begin
                ActionPerformed := aActionPerformed;
        		CreateUser := FieldByName('SM_USUARIOCRIADOR_ID').AsInteger;
                UpdateUser := FieldByName('SM_USUARIOMODIFICADOR_ID').AsInteger;
                CreateDateTime := FieldByName('DT_DATAEHORADACRIACAO').AsDateTime;
        		UpdateDateTime := FieldByName('DT_DATAEHORADAMODIFICACAO').AsDateTime;
                { ------------------------------------------------------------ }
	            MI_GRUPOSDOSUSUARIOS_ID := aPrimaryKeyValue;//FieldByName('MI_GRUPOSDOSUSUARIOS_ID').AsInteger;
    	        TI_GRUPOS_ID.StoredValue := FieldByName('TI_GRUPOS_ID').AsInteger;
    	        SM_USUARIOS_ID.StoredValue := FieldByName('SM_USUARIOS_ID').AsInteger;
            end
        else if aTableName = 'REGIOESDOSUSUARIOS' then
            with aSyncFile.RegioesDosUsuarios.Add, RODataSet do
            begin
                ActionPerformed := aActionPerformed;
        		CreateUser := FieldByName('SM_USUARIOCRIADOR_ID').AsInteger;
                UpdateUser := FieldByName('SM_USUARIOMODIFICADOR_ID').AsInteger;
                CreateDateTime := FieldByName('DT_DATAEHORADACRIACAO').AsDateTime;
        		UpdateDateTime := FieldByName('DT_DATAEHORADAMODIFICACAO').AsDateTime;
                { ------------------------------------------------------------ }
	            MI_REGIOESDOSUSUARIOS_ID := aPrimaryKeyValue;//FieldByName('MI_REGIOESDOSUSUARIOS_ID').AsInteger;
    	        TI_REGIOES_ID.StoredValue := FieldByName('TI_REGIOES_ID').AsInteger;
    	        SM_USUARIOS_ID.StoredValue := FieldByName('SM_USUARIOS_ID').AsInteger;
            end
        else if aTableName = 'EQUIPAMENTOSDOSITENS' then
            with aSyncFile.EquipamentosDosItens.Add, RODataSet do
            begin
                ActionPerformed := aActionPerformed;
        		CreateUser := FieldByName('SM_USUARIOCRIADOR_ID').AsInteger;
                UpdateUser := FieldByName('SM_USUARIOMODIFICADOR_ID').AsInteger;
                CreateDateTime := FieldByName('DT_DATAEHORADACRIACAO').AsDateTime;
        		UpdateDateTime := FieldByName('DT_DATAEHORADAMODIFICACAO').AsDateTime;
                { ------------------------------------------------------------ }
	            IN_EQUIPAMENTOSDOSITENS_ID := aPrimaryKeyValue;//FieldByName('IN_EQUIPAMENTOSDOSITENS_ID').AsInteger;
    	        IN_ITENS_ID.StoredValue:= FieldByName('IN_ITENS_ID').AsInteger;
    	        IN_EQUIPAMENTOS_ID.StoredValue := FieldByName('IN_EQUIPAMENTOS_ID').AsInteger;
    	        FL_LUCROBRUTO := FieldByName('FL_LUCROBRUTO').AsFloat;
    	        FL_VALORUNITARIO := FieldByName('FL_VALORUNITARIO').AsCurrency;
    	        TI_MOEDA := FieldByName('TI_MOEDA').AsInteger;
            end
        else if aTableName = 'ITENS' then
            with aSyncFile.Itens.Add, RODataSet do
            begin
                ActionPerformed := aActionPerformed;
        		CreateUser := FieldByName('SM_USUARIOCRIADOR_ID').AsInteger;
                UpdateUser := FieldByName('SM_USUARIOMODIFICADOR_ID').AsInteger;
                CreateDateTime := FieldByName('DT_DATAEHORADACRIACAO').AsDateTime;
        		UpdateDateTime := FieldByName('DT_DATAEHORADAMODIFICACAO').AsDateTime;
                { ------------------------------------------------------------ }
	            IN_ITENS_ID := aPrimaryKeyValue;//FieldByName('IN_ITENS_ID').AsInteger;
    	        IN_PROPOSTAS_ID.StoredValue := FieldByName('IN_PROPOSTAS_ID').AsInteger;
    	        TI_FAMILIAS_ID.StoredValue := FieldByName('TI_FAMILIAS_ID').AsInteger;
    	        VA_DESCRICAO := FieldByName('VA_DESCRICAO').AsString;
    	        FL_CAPACIDADE := FieldByName('FL_CAPACIDADE').AsFloat;
    	        TI_UNIDADES_ID.StoredValue := FieldByName('TI_UNIDADES_ID').AsInteger;
    	        SM_QUANTIDADE := FieldByName('SM_QUANTIDADE').AsInteger;
    	        EN_VOLTAGEM := FieldByName('EN_VOLTAGEM').AsString;
    	        FL_DESCONTOPERC := FieldByName('FL_DESCONTOPERC').AsFloat;
    	        TI_ORDEM := FieldByName('TI_ORDEM').AsInteger;
            end
        else if aTableName = 'PROPOSTAS' then
            with aSyncFile.Propostas.Add, RODataSet do
            begin
                ActionPerformed := aActionPerformed;
        		CreateUser := FieldByName('SM_USUARIOCRIADOR_ID').AsInteger;
                UpdateUser := FieldByName('SM_USUARIOMODIFICADOR_ID').AsInteger;
                CreateDateTime := FieldByName('DT_DATAEHORADACRIACAO').AsDateTime;
                UpdateDateTime := FieldByName('DT_DATAEHORADAMODIFICACAO').AsDateTime;
                { ------------------------------------------------------------ }
	            IN_PROPOSTAS_ID := aPrimaryKeyValue;//FieldByName('IN_PROPOSTAS_ID').AsInteger;
    	        IN_OBRAS_ID.StoredValue := FieldByName('IN_OBRAS_ID').AsInteger;
    	        SM_CODIGO := FieldByName('SM_CODIGO').AsInteger;
    	        YR_ANO := FieldByName('YR_ANO').AsInteger;
    	        SM_INSTALADORES_ID.StoredValue := FieldByName('SM_INSTALADORES_ID').AsInteger;
    	        VA_CONTATO := FieldByName('VA_CONTATO').AsString;
    	        BO_PROPOSTAPADRAO := FieldByName('BO_PROPOSTAPADRAO').AsInteger = 1;
    	        FL_DESCONTOPERC := FieldByName('FL_DESCONTOPERC').AsFloat;
    	        FL_DESCONTOVAL := FieldByName('FL_DESCONTOVAL').AsFloat;
    	        TI_MOEDA := FieldByName('TI_MOEDA').AsInteger;
                VA_COTACOES := FieldByName('VA_COTACOES').AsString;
                TI_VALIDADE := FieldByName('TI_VALIDADE').AsInteger;
            end
        else if aTableName = 'OBRAS' then
            with aSyncFile.Obras.Add, RODataSet do
            begin
                ActionPerformed := aActionPerformed;
        		CreateUser := FieldByName('SM_USUARIOCRIADOR_ID').AsInteger;
                UpdateUser := FieldByName('SM_USUARIOMODIFICADOR_ID').AsInteger;
                CreateDateTime := FieldByName('DT_DATAEHORADACRIACAO').AsDateTime;
                UpdateDateTime := FieldByName('DT_DATAEHORADAMODIFICACAO').AsDateTime;
                { ------------------------------------------------------------ }
	            IN_OBRAS_ID := aPrimaryKeyValue;//FieldByName('IN_PROPOSTAS_ID').AsInteger;
    	        TI_REGIOES_ID.StoredValue := FieldByName('TI_REGIOES_ID').AsInteger;
    	        VA_NOMEDAOBRA := FieldByName('VA_NOMEDAOBRA').AsString;
    	        VA_CIDADE := FieldByName('VA_CIDADE').AsString;
    	        CH_ESTADO := FieldByName('CH_ESTADO').AsString;
    	        TI_SITUACOES_ID.StoredValue := FieldByName('TI_SITUACOES_ID').AsInteger;
    	        VA_PRAZODEENTREGA := FieldByName('VA_PRAZODEENTREGA').AsString;
                YR_ANOPROVAVELDEENTREGA := FieldByName('YR_ANOPROVAVELDEENTREGA').AsInteger;
                TI_MESPROVAVELDEENTREGA := FieldByName('TI_MESPROVAVELDEENTREGA').AsInteger;
    	        TX_CONDICAODEPAGAMENTO := FieldByName('TX_CONDICAODEPAGAMENTO').AsString;
    	        FL_ICMS := FieldByName('FL_ICMS').AsFloat;
    	        EN_FRETE := FieldByName('EN_FRETE').AsString;
                TX_CONDICOESGERAIS := FieldByName('TX_CONDICOESGERAIS').AsString;
                TX_OBSERVACOES := FieldByName('TX_OBSERVACOES').AsString;
                SM_USUARIOJUSTIFICADOR_ID.StoredValue := FieldByName('SM_USUARIOJUSTIFICADOR_ID').AsInteger;
                VA_CONSTRUTORA := FieldByName('VA_CONSTRUTORA').AsString;
                TI_TIPOS_ID.StoredValue := FieldByName('TI_TIPOS_ID').AsInteger;
                SM_PROJETISTAS_ID.StoredValue := FieldByName('SM_PROJETISTAS_ID').AsInteger;
                DA_DATADEEXPIRACAO := FieldByName('DA_DATADEEXPIRACAO').AsDateTime;
            end;
    finally
        if Assigned(RODataSet) then
        begin
            RODataSet.Close;
            RODataSet.Free;
        end;
    end;
end;

procedure TFSYGlobals.ConfigureDataSet(aZConnection: TZConnection; var aDataSet: TZReadOnlyQuery; aSQLCommand: String);
begin
	try
    	try
	    	if Assigned(aDataSet) then
  	    		aDataSet.Free;

            aDataSet := nil;
            aDataSet := TZReadOnlyQuery.Create(nil);

      		if Assigned(aDataSet) then
      		begin
        		with aDataSet do
        		begin
		        	Connection := aZConnection;
          			SQL.Text := aSQLCommand;
         		 	Open;
        		end;
            end;
        except
    		on EAV: EAccessViolation do
      		begin
      			EAV.Message := Format(rs_eav,['ConfigureDataSet',EAV.Message]);
       			raise;
      		end;
      		on EZSE: EZSQLException do
      		begin
      			EZSE.Message := Format(rs_ezse,['ConfigureDataSet',EZSE.Message]);
      			raise;
      		end;
     		on E: Exception do
      		begin
      			E.Message := Format(rs_exc,['ConfigureDataSet',E.Message]);
      			raise;
      		end;
    	end;
  	finally
    	if Assigned(aDataSet) and not aDataSet.Active then
    	begin
      		aDataSet.Free;
        	aDataSet := nil;
        end;
  	end;
end;

procedure TFSYGlobals.ConfigureConnection(var aZConnection: TZConnection; theProtocol, theHostName, theUserName, thePassword, theDatabase: String; thePortNumber: Word; UseDatabase: Boolean);
begin
	try
  		try
      		if Assigned(aZConnection) then
        		aZConnection.Free;

      		aZConnection := nil;
      		aZConnection := TZConnection.Create(nil);

            if Assigned(aZConnection) then
                with aZConnection do
                begin
                    Protocol := theProtocol;
                    HostName := theHostName;
                    Port := thePortNumber;

                    if UseDataBase then
                    	Database := theDatabase;
                        
	                User := theUserName;
                    Password := thePassword;

                    TransactIsolationLevel := tiRepeatableRead; // Padr�o InnoDB
                    { Para usar transa��es AutoCommit tem de ser true de forma a
                    nos obrigar a usar transa��es }
                    AutoCommit := True;
                    Connect;
                end;
    	except
            on EAV: EAccessViolation do
            begin
                EAV.Message := Format(rs_eav,['ConfigureConnection.',PutLineBreaks(EAV.Message,80)]);
                raise;
            end;
            on EZDE: EZDatabaseError do
            begin
                EZDE.Message := Format(rs_ezde,['ConfigureConnection',PutLineBreaks(EZDE.Message,80)]);
                raise;
            end;
            on EZSE: EZSQLException do
            begin
                EZSE.Message := Format(rs_ezse,['ConfigureConnection',PutLineBreaks(EZSE.Message,80)]);
                raise;
            end;
            on E: Exception do
            begin
                E.Message := Format(rs_exc,['ConfigureConnection',PutLineBreaks(E.Message,80)]);
                raise;
            end;
    	end;
    finally
    	if Assigned(aZConnection) and not aZConnection.Connected then
    	begin
      		aZConnection.Free;
      		aZConnection := nil;
    	end;
  	end;
end;

{$IFDEF FTPSYNCCLI}
function TFSYGlobals.ChecarMd5(aFTPClient: TFTPClient; aFileName: String; aTryNo: Byte; aEraseCopyOn: Char; aRichEdit: TRichEdit): Boolean;
var
	Comando, TempStr: String;
  	MD5Local, MD5Remoto: String;
begin
	MD5Local := 'a';
	MD5Remoto := 'Z';

	ShowOnLog('� Checando MD5 (' + IntToStr(aTryNo) + '� tentativa)', aRichEdit);

  	{ Quando estamos executando um script, aquele "arquivo" usado pelo comando get
 	n�o existe fisicamente portando n�o podemos  usa-lo para calcular o MD5.  Se o
  	script  retorna  algum  arquivo,  este  arquivo  �  criado no  servidor,  para
  	proposito de checagem MD5. No servidor,  os arquivos gerados para este fim tem
  	o mesmo nome do script SEM A EXTENS�O PHPS E SEM O IDENTIFICADOR DE A��O }
  	Comando := '';
  	if ExtractFileExt(aFTPClient.HostFileName) = '.PHPS' then
  	begin
		{ o formato do nome do script � <acao>.<nome_do_script>.phps. Temos de
        remover a extens�o e a parte que indica a a��o }
        Comando := aFTPClient.HostFileName; { Salva para recuperar posteriormente }
        TempStr := Comando;
        Delete(TempStr,1,Pos('.',TempStr)); { remove a a��o }
		Delete(TempStr,Pos('.PHPS',TempStr),5); { remove a extens�o final }
    	aFTPClient.HostFileName := TempStr;
  	end;

	if ExecuteCmd(aFTPClient,aFTPClient.Md5,aRichEdit,'MD5') then
	begin
        MD5Local := GetFileCheckSum(aFileName,[haMd5]);;
		MD5Remoto := UpperCase(aFTPClient.Md5Result);
	end;

  	Result := (MD5Local = MD5Remoto);
  	if Result then
    	ShowOnLog('� O MD5 dos arquivos checados � id�ntico!',aRichEdit)
  	else
  	begin
  		ShowOnLog('� O MD5 dos arquivos � diferente. Tente enviar/receber o arquivo novamente.',aRichEdit);
    	case aEraseCopyOn of
      		'S': begin
        		if ExecuteCmd(aFTPClient,aFTPClient.Delete,aRichEdit,'DELETE') then
		 	    	ShowOnLog('� O Arquivo remoto foi exclu�do!',aRichEdit);
      		end;
      		'C': begin
        		if DeleteFile(aFileName) then
		 	    	ShowOnLog('� O Arquivo local foi exclu�do!',aRichEdit);
      		end;
    	end;
  	end;

  	// Se era um comando, restaura HostFileName
  	if Comando <> '' then
		aFTPClient.HostFileName := Comando;
end;{$ENDIF}

{$IFDEF FTPSYNCCLI}
function TFSYGlobals.ClearDeltaAndSaveLastSyncDateTime(aFTPClient: TFtpClient;
                                                       aZConnection: TZConnection;
                                                       aProgressBar: TProgressBar;
                                                       aLabelPercentDone: TLabel;
                                                       aSaveLastSyncDateTime: Boolean;
                                                       aRichEdit: TRichEdit): Boolean;
var
  	LastSyncDateTime: TDateTime;
begin
	Result := False;

    if aSaveLastSyncDateTime then
    begin
        DeleteFile(FFTPDirectory + '\' + FTPFIL_SERVERINFO);
        { Obtendo a data e a hora no servidor }
        if MD5Get(aFTPClient,aProgressBar,aLabelPercentDone,FFTPDirectory + '\' + FTPFIL_SERVERINFO,FTPSCR_SERVERINFO,aRichEdit,5) then
            if FileExists(FFTPDirectory + '\' + FTPFIL_SERVERINFO) and (Trunc(FileSize(FFTPDirectory + '\' + FTPFIL_SERVERINFO)) > 0) then
            begin
                { Lendo a data e a hora do arquivo }
                with TServerInformation.Create(nil) do
                    try
                        LoadFromBinaryFile(FFTPDirectory + '\' + FTPFIL_SERVERINFO);
                        LastSyncDateTime := DateAndTime;
                    finally
                        Free;
                    end;

                ExecuteQuery(aZConnection,'INSERT INTO SINCRONIZACOES VALUES (' + MySQLDateTimeFormat(LastSyncDateTime) + ')');
                ExecuteQuery(aZConnection,'DELETE FROM DELTA');
                Result := True;
            end;
    end
    { Havia um problema que fazia com que o delta contivesse dados, mesmo
    quando os dois databases eram iguais. Agora, quando os dois s�o iguais o
    delta � completamente limpo. Aqui n�o foi usado um Truncate pois ele mapeia
    para uma sequ�ncia de Drop + Create, que apesar de ser r�pido e ter o mesmo
    efeito tamb�m termina qualquer transa��o sendo executada e isso �
    inaceit�vel }
    else
    begin
        ExecuteQuery(aZConnection,'DELETE FROM DELTA');
        Result := True;
    end;
end;{$ENDIF}

{$IFDEF FTPSYNCCLI}
procedure TFSYGlobals.ClearDirectory(aDirectory: String);
	{Procedures e fun��es locais}
    procedure SearchTree;
    var
	    SearchRec: TSearchRec;
    	DosError: integer;
    begin
	    DosError := FindFirst('*.*', 0, SearchRec);
    	while DosError = 0 do
	    begin
		    try
			    DeleteFile(SearchRec.Name);
		    except
			    on Eoor: EOutOfResources do
			    begin
				    Eoor.Message := Eoor.Message + #13#10'A quantidade de arquivos localizados excede o limite de recursos do seu sistema. Favor limitar seu crit�rio de busca escolhendo diret�rio(s) de n�vel mais interno';
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
		        RemoveDir(SearchRec.Name);
        	end;
	        DosError := FindNext(SearchRec);
        end;
    end;
begin
	ChDir(aDirectory);
	SearchTree;
end;{$ENDIF}

procedure TFSYGlobals.ConfigureConnection(var aZConnection: TZConnection; UseDatabase: Boolean = True);
begin
	with FConfigurations do
  		ConfigureConnection(aZConnection,DB_Protocol,DB_HostAddr,DB_UserName,DB_Password,DB_Database,DB_PortNumb,UseDatabase);
end;

procedure TFSYGlobals.ConfigureDataSet(aZConnection: TZConnection; var aDataSet: TZQuery; aSQLCommand: String);
begin
  	try
  		try
      		if Assigned(aDataSet) then
        		aDataSet.Free;

      		aDataSet := nil;
      		aDataSet := TZQuery.Create(nil);

      		if Assigned(aDataSet) then
      		begin
        		with aDataSet do
        		begin
          			ReadOnly := False;
          			Connection := aZConnection;
          			SQL.Text := aSQLCommand;
          			Open;
        		end;
      		end;
    	except
    		on EAV: EAccessViolation do
      		begin
      			EAV.Message := Format(rs_eav,['ConfigureDataSet',EAV.Message]);
       			raise;
      		end;
      		on EZSE: EZSQLException do
      		begin
      			EZSE.Message := Format(rs_ezse,['ConfigureDataSet',EZSE.Message]);
      			raise;
      		end;
     		on E: Exception do
      		begin
      			E.Message := Format(rs_exc,['ConfigureDataSet',E.Message]);
      			raise;
      		end;
    	end;
  	finally
    	if Assigned(aDataSet) and not aDataSet.Active then
    	begin
      		aDataSet.Free;
      		aDataSet := nil;
    	end;
  	end;
end;

{$IFDEF FTPSYNCCLI}
procedure TFSYGlobals.ConfirmEverything(aFTPClient: TFtpClient;
                                        aZConnection: TZConnection;
                                        aProgressBar: TProgressBar;
                                        aLabelPercentDone: TLabel;
                                        aSimulation: Boolean;
                                        aRichEdit: TRichEdit);
begin
  	{ Executando um script no servidor que altera o valor da propriedade Tag da
  	conex�o remota de forma que quando o cliente desconectar, tudo seja confirmado }
    if not aSimulation then
    begin
	  	MD5Get(aFTPClient,aProgressBar,aLabelPercentDone,FFTPDirectory + '\' + FTPFIL_CONFIRMEVERYTHING,FTPSCR_CONFIRMEVERYTHING,aRichEdit,5);
  		aZConnection.Tag := 0; //Confirma tudo localmente ao desconectar!
    end;
  	ExecuteCmd(aFTPClient,aFTPClient.Quit,aRichEdit,'QUIT',aProgressBar,aLabelPercentDone);
end;{$ENDIF}

{$IFDEF FTPSYNCCLI}
procedure TFSYGlobals.ConnectToServer(aFTPClient: TFtpClient; aHostName: String; aPortNumb: Word; aRichEdit: TRichEdit);
begin
    aFtpClient.HostName := aHostName;
    aFtpClient.Port := IntToStr(aPortNumb);

    if not ExecuteCmd(aFTPClient,aFtpClient.Open,aRichEdit,'OPEN') then
	    raise Exception.Create('N�o foi poss�vel conectar-se ao servidor.');
end;{$ENDIF}

{$IFDEF FTPSYNCCLI}
procedure TFSYGlobals.CheckVersion(aFTPClient: TFtpClient; aRichEdit: TRichEdit);
const
    VERSION_ERROR = 'A vers�o do seu FTP Synchronizer n�o � aceita pelo servid'+
                    'or em execu��o. Atualize o seu FTP Synchronizer para pode'+
                    'r realizar suas sincroniza��es. Atualmente o servidor ace'+
                    'ita apenas conex�es vindas de clientes com vers�o %s ou s'+
                    'uperior. A ver�o atualmente executada por voc� � %s. Por '+
                    'favor entre em contato com o HelpDesk para informa��es so'+
                    'bre como realizar a atualiza��o.';
var
    CurrentVersion: TVersion;
    VersionIsValid: Boolean;
    RetrSessionParameters: TRetrSessionParameters;
begin
    ShowOnLog('� Verificando vers�o aceita pelo servidor...',aRichEdit);

    DeleteFile(FFTPDirectory + '\' + FTPFIL_SERVERINFO);
    CurrentVersion := nil;

    ZeroMemory(@RetrSessionParameters,SizeOf(TRetrSessionParameters));
    RetrSessionParameters.VerboseMode := True;
    RetrSessionParameters.UseCompression := False;

    SendRetrSessionParameters(RetrSessionParameters,aFTPClient,aRichEdit,nil,nil);

    { Informa��es do servidor }
    if MD5Get(aFTPClient,nil,nil,FFTPDirectory + '\' + FTPFIL_SERVERINFO,FTPSCR_SERVERINFO,aRichEdit,5) then
    begin
        if FileExists(FFTPDirectory + '\' + FTPFIL_SERVERINFO) then
        begin
            { Lendo vers�o m�nima aceita pelo servidor }
            with TServerInformation.Create(nil) do
                try
                    LoadFromBinaryFile(FFTPDirectory + '\' + FTPFIL_SERVERINFO);

                    CurrentVersion := TVersion.Create;
                    { Bastaria a instancia��o de TVersion para obter a vers�o
                    completa do execut�vel atual, mas este n�o � o caso quando
                    estamos rodando esta fun��o a partir do BDO. L� eu tenho de
                    obter a vers�o do FTP Synchronizer instalado e n�o do
                    pr�prio BDO, por isso a codifica�ao abaixo � necess�ria.
                    Estou considerando que a instala��o foi feita corretamente e
                    que existe uma pasta FTP Synchronizer abaixo da pasta atual }
                    {$IFDEF BDO}
                    CurrentVersion.Minor := TFileInformation.GetInfo(FCurrentDir + 'FTPSyncCli.exe','MINORVERSION').AsWord;
                   	CurrentVersion.Major := TFileInformation.GetInfo(FCurrentDir + 'FTPSyncCli.exe','MAJORVERSION').AsWord;
                    CurrentVersion.Release := TFileInformation.GetInfo(FCurrentDir + 'FTPSyncCli.exe','RELEASE').AsWord;
                   	CurrentVersion.Build := TFileInformation.GetInfo(FCurrentDir + 'FTPSyncCli.exe','BUILD').AsWord;
                    {$ENDIF}

                    with CurrentVersion do
                    begin
                        { Checando a vers�o "Major" }
                        if Major > MinimumClientVersion.Major then
                            VersionIsValid := True
                        else if Major < MinimumClientVersion.Major then
                            VersionIsValid := False
                        else
                        begin
                            { Vers�o "Major" � igual, checando vers�o "Minor" }
                            if Minor > MinimumClientVersion.Minor then
                                VersionIsValid := True
                            else if Minor < MinimumClientVersion.Minor then
                                VersionIsValid := False
                            else
                            begin
                                { Vers�o "Minor" � igual, checando "Release" }
                                if Release > MinimumClientVersion.Release then
                                    VersionIsValid := True
                                else if Release < MinimumClientVersion.Release then
                                    VersionIsValid := False
                                else
                                begin
                                    { "Release" � igual, checando "Build" }
                                    if Build < MinimumClientVersion.Build then
                                        VersionIsValid := False
                                    else
                                        VersionIsValid := True
                                end;
                            end;
                        end;

                        if not VersionIsValid then
                        begin
                            Application.MessageBox(PChar(Format(VERSION_ERROR,[MinimumClientVersion.FullVersionString,CurrentVersion.FullVersionString])),'Vers�o incompat�vel',MB_ICONERROR);
                            raise Exception.CreateFmt(VERSION_ERROR,[MinimumClientVersion.FullVersionString,CurrentVersion.FullVersionString]);
                        end;
                    end;
                finally
                    if Assigned(CurrentVersion) then
                        CurrentVersion.Free;
                    
                    Free;
                end;
        end
        else
            raise Exception.Create('O arquivo com informa��es de vers�o n�o existe.');

    end
    else
        raise Exception.Create('N�o foi poss�vel obter as informa��es de vers�o do servidor.');
end;{$ENDIF}

constructor TFSYGlobals.Create;
begin
	FCurrentDir := UpperCase(ExtractFilePath(Application.ExeName));

    {$IFDEF FTPSYNCCLI}{$IFNDEF BDO}
  	FFTPDirectory := FCurrentDir + 'FTPSync';

  	if not DirectoryExists(FFTPDirectory) then
    	CreateDir(FFTPDirectory);
    {$ENDIF}{$ENDIF}

//    {$IFDEF FTPSYNCSER}
//    FVerboseMode := True;
//    {$ENDIF}

	ReadConfigurations;
end;

{$IFDEF FTPSYNCCLI}
procedure TFSYGlobals.CreateLastSynchronizedOnFile(aZConnection: TZConnection);
var
	RODataSet: TZReadOnlyQuery;
	f: file of TDateTime;
  	UltimaSincronizacao: TDateTime;
begin
	RODataSet := nil;
	try
        ConfigureDataSet(aZConnection,RODataSet,'SELECT DT_DATAEHORADAULTIMA FROM SINCRONIZACOES ORDER BY DT_DATAEHORADAULTIMA DESC LIMIT 1');

      	if RODataSet.RecordCount = 1 then
        	UltimaSincronizacao := RODataSet.Fields[0].AsDateTime
      	else
        	UltimaSincronizacao := 0;

      	AssignFile(f,FFTPDirectory + '\'+ FTPFIL_LASTSYNCHRONIZEDON);
      	FileMode := fmOpenWrite; //Abrir para escrever apenas
      	Rewrite(f);
      	Write(f,UltimaSincronizacao);
  	finally
		CloseFile(f);
    	if Assigned(RODataSet) then
      		RODataSet.Free;
  	end;
end;{$ENDIF}

{$IFDEF FTPSYNCCLI}
function TFSYGlobals.SendLastSyncDateAndTime(aFTPClient: TFtpClient;
                                             aZConnection: TZConnection;
                                             aProgressBar: TProgressBar;
                                             aLabelPercentDone: TLabel;
                                             aRichEdit: TRichEdit): Boolean;
begin
    CreateLastSynchronizedOnFile(aZConnection);
    Result := MD5Put(aFTPClient,aProgressBar,aLabelPercentDone,FFTPDirectory + '\' + FTPFIL_LASTSYNCHRONIZEDON,FTPFIL_LASTSYNCHRONIZEDON,aRichEdit,5);
end;{$ENDIF}

destructor TFSYGlobals.Destroy;
begin
	SaveConfigurations;
    inherited;
end;

{$IFDEF FTPSYNCCLI}
function TFSYGlobals.ExecuteCmd(aFTPClient: TFtpClient; aSyncCmd: TSyncCmd; aRichEdit: TRichEdit; aDescription: String = ''; aProgressBar: TProgressBar = nil; aLabelPercentDone: TLabel = nil): Boolean;
var
	Text: String;
begin
    Text := '@ Executando comando "' + aDescription + '"... ';
    Text := Text + DupeString('>',95 - Length(Text));
    ShowOnLog(Text,aRichEdit);

    InitializeProgress(aProgressBar,aLabelPercentDone,0);

    if @aSyncCmd = @TFtpClient.Put then
	    InitializeProgress(aProgressBar,aLabelPercentDone,Trunc(FileSize(aFtpClient.LocalFileName)));

    Result := aSyncCmd;

    if FConfigurations.FT_CommandDelay > 0 then
    begin
        ShowOnLog('~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~',aRichEdit);
        ShowOnLog('Aguardando ' + IntToStr(FConfigurations.FT_CommandDelay) + ' segundo(s) antes da pr�xima a��o...',aRichEdit);
        ShowOnLog('~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~',aRichEdit);
        WaitFor(FConfigurations.FT_CommandDelay);
    end;
end;{$ENDIF}

procedure TFSYGlobals.ExecuteDeltaFile(      aZConnection: TZConnection;
                                             aRichEdit: TRichEdit;
                                       const aUsePrimaryKeyValue: Boolean;
                                       const aInputFile: TFileName;
                                       const aOutputFile: TFileName;
                                       const aForeignKeysCheck: Boolean = True;
                                             aProgressBar: TProgressBar = nil;
                                             aLabelPercentDone: TLabel = nil);
var
    SyncFile: TSynchronizationFile;
begin
    SyncFile := nil;
	try
    	SyncFile := TSynchronizationFile.Create(aZConnection,aUsePrimaryKeyValue);
        SyncFile.LoadFromBinaryFile(aInputFile);

        if Trim(aOutputFile) <> '' then
            SaveTextFile(SyncFile.ToScript,aOutputFile);

        MySQLExecuteSQLScript(aZConnection,aRichEdit,'',SyncFile.ToScript,aForeignKeysCheck);

    finally
    	SyncFile.Free;
    end;
end;

function TFSYGlobals.FileSize(aFileName: TFileName; aFileSizeIn: TFileSizeUnit = fsuBytes): Double;
var
	FOB: file of 0..255;
    FOKB: file of 0..1024;
    FOMB: file of 0..1048576;
    FOGB: file of 0..1073741824;
begin
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
        else
        	Result := 0;
    end;
end;

procedure TFSYGlobals.ShowOnLog(const aText: String; aRichEdit: TRichEdit);
var
  Linhas: TStringList;
  i: Word;
  LinhaAExibir: String;

  function FirstToken(Line: String): String;
  begin
  	Result := Copy(Line,1,Pred(Pos(' ',Line)));
  end;

  function FirstAndSecondTokens(Line: String): String;
  var
    Idx: Word;
    TmpStr: String;
  begin
  	TmpStr := Line; //RETORNO:> XXX - XXXXXX
		Idx := Pos(' ',TmpStr);
    Delete(TmpStr,1,Idx); //XXX - XXXXXX
    Inc(Idx,Pos(' ',TmpStr));
  	Result := Copy(Line,1,Pred(Idx));
  end;

  procedure AddText(aLine: String; aColor: TColor; aFontName: TFontName; aFontSize: Byte; aFontStyle: TFontStyles);
  begin
    aRichEdit.SelAttributes.Color := aColor;
    aRichEdit.SelAttributes.Name  := aFontName;
    aRichEdit.SelAttributes.Size  := aFontSize;
    aRichEdit.SelAttributes.Style := aFontStyle;
    aRichEdit.SelText             := aLine;
  end;

begin
	Linhas := nil;

  try
    Linhas := TStringList.Create;
		Linhas.Text := StringReplace(aText,'\n',#13#10,[rfReplaceAll]);

    if (Pos('RETORNO:>',Linhas[0]) = 1) or (Pos('COMANDO:>',Linhas[0]) = 1) or (Linhas[0][1] = '!') or (Linhas[0][1] = '�') or (Linhas[0][1] = '@') then
      for i := 0 to Pred(Linhas.Count) do
      begin
        { Este IF e seu ELSE escrevem no log apenas a parte inicial da linha,
        que consiste, da data mais o colchete ou das linhas verticais, mais o
        colchete no caso de um comando ou resposta com mais de uma linha }
        if i = 0 then
        begin
          LinhaAExibir := Linhas[0];

          aRichEdit.SelStart := aRichEdit.GetTextLen;
          { dd/mm/yyyy hh:nn:ss ] RETORNO:> ??? - XXXXXXXXXXXX }

          { dd/mm/yyyy hh:nn:ss }
          AddText(FormatDateTime('dd/mm/yyyy hh:nn:ss',Now())
                 ,clWindowText
                 ,aRichEdit.Font.Name
                 ,aRichEdit.Font.Size
                 ,[fsBold]);

          { ] }
          AddText(' ] '
                 ,clWindowText
                 ,aRichEdit.Font.Name
                 ,aRichEdit.Font.Size
                 ,[]);
        end
        else
        begin
          // 24/08/2010 09:08:26 ] � XXXX LINHA xxxx
          // ||||||||||||||||||| ] � XXXX LINHA xxxx
          if (Linhas[0][1] <> '!') and (Linhas[0][1] <> '�') and (Linhas[0][1] <> '@') then
            LinhaAExibir := FirstAndSecondTokens(Linhas[0]) + ' - ' + Linhas[i]
          else
            LinhaAExibir := FirstToken(Linhas[0]) + ' ' + Linhas[i];

          aRichEdit.SelStart := aRichEdit.GetTextLen;

          { ||||||||||||||||||| }
          AddText('|||||||||||||||||||'
                 ,clWindowText
                 ,aRichEdit.Font.Name
                 ,aRichEdit.Font.Size
                 ,[fsBold]);

          { ] }
          AddText(' ] '
                 ,clWindowText
                 ,aRichEdit.Font.Name
                 ,aRichEdit.Font.Size
                 ,[]);
        end;

        { A partir daqui ser� inserida a parte da linha que tem a informa��o }

        { RETORNO:> ??? - XXXXXXXXXXXX }

        {$IFDEF FTPSYNCCLI}
        { Pintando erros de vermelho }
        if Pos('RETORNO:> 666 - ',LinhaAExibir) = 1 then
        begin
          AddText('RETORNO:> '
                 ,clBlue
                 ,aRichEdit.Font.Name
                 ,aRichEdit.Font.Size
                 ,[fsBold]);

          AddText(Copy(LinhaAExibir,Pos('666',LinhaAExibir),Length(LinhaAExibir)) + #13#10
                 ,clRed
                 ,aRichEdit.Font.Name
                 ,aRichEdit.Font.Size
                 ,[fsBold]);
        end
        else
        {$ENDIF}
        if Pos('RETORNO:>',LinhaAExibir) = 1 then
          AddText(LinhaAExibir + #13#10
                 ,clBlue
                 ,aRichEdit.Font.Name
                 ,aRichEdit.Font.Size
                 ,[fsBold])
        else if Pos('COMANDO:>',LinhaAExibir) = 1 then
          AddText(LinhaAExibir + #13#10
                 ,clGreen
                 ,aRichEdit.Font.Name
                 ,aRichEdit.Font.Size
                 ,[fsBold])
        else if LinhaAExibir[1] = '!' then
          AddText(LinhaAExibir + #13#10
                 ,clRed
                 ,aRichEdit.Font.Name
                 ,aRichEdit.Font.Size
                 ,[fsBold])
        else if LinhaAExibir[1] = '�' then
          AddText(LinhaAExibir + #13#10
                 ,$000080FF
                 ,aRichEdit.Font.Name
                 ,aRichEdit.Font.Size
                 ,[fsBold])
        else if LinhaAExibir[1] = '@' then
          AddText(LinhaAExibir + #13#10
                 ,clPurple
                 ,aRichEdit.Font.Name
                 ,aRichEdit.Font.Size
                 ,[fsBold]);
      end
    else
      for i := 0 to Pred(Linhas.Count) do
      begin
        aRichEdit.SelStart := aRichEdit.GetTextLen;
        AddText('------------------- ] ' + Linhas[i] + #13#10
               ,clWindowText
               ,aRichEdit.Font.Name
               ,aRichEdit.Font.Size
               ,[]);
      end;
  finally
    Linhas.Free;
    SendMessage(aRichEdit.Handle,WM_VSCROLL,SB_BOTTOM,0);
  end;
end;

//procedure TFSYGlobals.ShowOnLog(const aText: String; aRichEdit: TRichEdit);
//var
//  Linhas: TStringList;
//  i{, Idx}: Word;
//  LinhaAExibir: String;
//
//  function FirstToken(Line: String): String;
//  begin
//  	Result := Copy(Line,1,Pred(Pos(' ',Line)));
//  end;
//
//  function FirstAndSecondTokens(Line: String): String;
//  var
//    Idx: Word;
//    TmpStr: String;
//  begin
//  	TmpStr := Line; //RETORNO:> XXX - XXXXXX
//		Idx := Pos(' ',TmpStr);
//    Delete(TmpStr,1,Idx); //XXX - XXXXXX
//    Inc(Idx,Pos(' ',TmpStr));
//  	Result := Copy(Line,1,Pred(Idx));
//  end;
//
//begin
//  Linhas := nil;
//  try
//    Linhas := TStringList.Create;
//    Linhas.Text := StringReplace(aText,'\n',#13#10,[rfReplaceAll]);
//
//    if (Pos('RETORNO:>',Linhas[0]) = 1) or (Pos('COMANDO:>',Linhas[0]) = 1) or (Linhas[0][1] = '!') or (Linhas[0][1] = '�') or (Linhas[0][1] = '@') then
//      for i := 0 to Pred(Linhas.Count) do
//      begin
//        if i = 0 then
//        begin
//          LinhaAExibir := Linhas[0];
//          aRichEdit.Lines.Add(FormatDateTime('dd/mm/yyyy hh:nn:ss',Now()) + ' ] ' + LinhaAExibir);
//        end
//        else
//        begin
//          if (Linhas[0][1] <> '!') and  (Linhas[0][1] <> '�') and (Linhas[0][1] <> '@') then
//            LinhaAExibir := FirstAndSecondTokens(Linhas[0]) + ' - ' + Linhas[i]
//          else
//            LinhaAExibir := FirstToken(Linhas[0]) + ' ' + Linhas[i];
//
//          aRichEdit.Lines.Add('||||||||||||||||||| ] ' + LinhaAExibir);
//        end;
//
//        { A partir daqui, a �ltima linha do RichEdit cont�m algo como
//        dd/mm/yyyy hh:nn:ss ] RETORNO:> ??? - XXXXXXXXXXXX }
//
//        { Tornando negrito e na cor preta a string inteira }
//        aRichEdit.SelStart := Length(aRichEdit.Text) - Length(aRichEdit.Lines[Pred(aRichEdit.Lines.Count)]) - 2;
//        aRichEdit.SelLength := Length(aRichEdit.Lines[Pred(aRichEdit.Lines.Count)]);
//        aRichEdit.SelAttributes.Color := clWindowText;
//        aRichEdit.SelAttributes.Style := [fsBold];
//
//        { Removendo o atributo negrito do colchete (]) }
//        aRichEdit.SelStart := aRichEdit.SelStart + 20;
//        aRichEdit.SelLength := 1;
//        aRichEdit.SelAttributes.Style := [];
//
//        { Seleconando a segunda parte do texto }
//        aRichEdit.SelStart := Length(aRichEdit.Text) - Length(aRichEdit.Lines[Pred(aRichEdit.Lines.Count)]) + 20;
//        aRichEdit.SelLength := Length(LinhaAExibir);
//
//        { Pintando a linha da mensagem de acordo com o texto }
//        if Pos('RETORNO:>',LinhaAExibir) = 1 then
//          aRichEdit.SelAttributes.Color := clBlue
//        else if Pos('COMANDO:>',LinhaAExibir) = 1 then
//          aRichEdit.SelAttributes.Color := clGreen
//        else if LinhaAExibir[1] = '!' then
//          aRichEdit.SelAttributes.Color := clRed
//        else if LinhaAExibir[1] = '�' then
//          aRichEdit.SelAttributes.Color := $000080FF
//        else if LinhaAExibir[1] = '@' then
//          aRichEdit.SelAttributes.Color := clPurple;
//
//        {$IFDEF FTPSYNCCLI}
//        { Pintando erros de vermelho }
//        if Pos('RETORNO:> 666 - ',LinhaAExibir) = 1 then
//        begin
//          aRichEdit.SelStart := aRichEdit.SelStart + 10;
//          aRichEdit.SelLength := Length(LinhaAExibir) - 10;
//          aRichEdit.SelAttributes.Color := clRed;
//        end;
//        {$ENDIF}
//
//        aRichEdit.SelLength := 0;
//      end
//    else
//      for i := 0 to Pred(Linhas.Count) do
//        aRichEdit.Lines.Add('------------------- ] ' + Linhas[i]);
//  finally
//    Linhas.Free;
//    SendMessage(aRichEdit.Handle,EM_SCROLLCARET,0,0);
//  end;
//end;


{$IFDEF FTPSYNCSER}
function TFSYGlobals.MySQLGetLastPrimaryKeyValue(aZConnection: TZConnection; aPrimaryKeyName, aTableName: String): Cardinal;
var
	RODataSet: TZReadOnlyQuery;
begin
	RODataSet := nil;
	try
    	ConfigureDataSet(aZConnection,RODataSet,'SELECT MAX(' + aPrimaryKeyName + ') FROM ' + aTableName);
        Result := RODataSet.Fields[0].AsInteger;
    finally
    	RODataSet.Free;
    end;
end;{$ENDIF}

{$IFDEF FTPSYNCSER}
procedure TFSYGlobals.CodigoEAnoDaProposta(const aZConnection: TZConnection;
                                           const aIN_PROPOSTAS_ID: Cardinal;
                                             out aSM_CODIGO
                                               , aYR_ANO: Word);
var
	RODataSet: TZReadOnlyQuery;
begin
	RODataSet := nil;
	try
    	ConfigureDataSet(aZConnection,RODataSet,'SELECT SM_CODIGO, YR_ANO FROM PROPOSTAS WHERE IN_PROPOSTAS_ID = ' + IntToStr(aIN_PROPOSTAS_ID));
        aSM_CODIGO := RODataSet.Fields[0].AsInteger;
        aYR_ANO := RODataSet.Fields[1].AsInteger;
    finally
    	RODataSet.Free;
    end;
end;{$ENDIF}

{$IFDEF FTPSYNCSER}

{ TODO -oCARLOS FEITOZA -cMELHORIA : Se aClient for do tipo TConnectedClient,
o par�metro de conex�o seria desnecess�rio. Veja a possibilidade de isso ser
usado }
procedure TFSYGlobals.ProcessClientDeltaToServerDelta(      aClient: TConnectedClient;
                                                      const aZConnection: TZConnection;
                                                      const aClientDelta
                                                          , aServerDelta: TSynchronizationFile;
                                                            aVerboseMode: Boolean);
var
	ST, ServerDeltaSyncTableIndex,
    Codigo, Ano: Word;
    SR: Cardinal;
    ClientSyncTable, ServerSyncTable: TSyncTable;
    ClientSyncRecord: TSyncRecord;
begin
    if aVerboseMode then
    	SendStatus(aClient,'Complementando o Delta do servidor com ajustes gerados a partir do delta do cliente...');

	{ Se temos tabelas a sincronizar, para cada tabela achada... }
	if aClientDelta.SyncedTables.Count > 0 then
    	for ST := 0 to Pred(aClientDelta.SyncedTables.Count) do
        begin
        	ClientSyncTable := aClientDelta.SyncedTables[ST].SyncedTable;
            { Se tem registros devemos process�-los... }
            if ClientSyncTable.Count > 0 then
            begin
                { Obtendo o indice da tabela sendo processada e a tabela correspondente em aServerDelta }
                aServerDelta.SyncedTables.FindSyncedTable(ClientSyncTable.TableName,ServerDeltaSyncTableIndex);
                ServerSyncTable := aServerDelta.SyncedTables[ServerDeltaSyncTableIndex].SyncedTable;

                { Obt�m a �ltima chave prim�ria para a tabela atual a fim de no
                cliente gerar um script que exclui registros sobrantes }
                ServerSyncTable.LastPrimaryKeyValue := MySQLGetLastPrimaryKeyValue(aZConnection,ClientSyncTable.PrimaryKeyName,ClientSyncTable.TableName);

            	for SR := 0 to Pred(ClientSyncTable.Count) do
                begin
                	ClientSyncRecord := ClientSyncTable[SR];
                    case ClientSyncRecord.ActionPerformed of
                        { Cada uma das inser��es encontradas em ClientSyncTable
                        ser� transferida para ServerSyncTable tendo como
                        ActionPerformed apSynKey de forma que o cliente atualize
                        as chaves }
                    	apInsert: with ServerSyncTable.Add do { Insere um novo registro na tabela }
                        begin
                            ActionPerformed := apSynKey;
{ TODO -oCarlos Feitoza -cEXPLICA��O : Nos clientes, OldPrimaryKeyValue e
NewPrimaryKeyValue s�o usados para criar um comando update que corrije as chaves
que foram geradas de forma diferente no servidor. Este update simples trocava
OldPrimaryKeyValue por NewPrimaryKeyValue contudo h� dois problemas nesse m�todo.
O primeiro deles � que ao trocar uma chave por outra, esta outra pode j� existir
e gera uma viola��o de chave prim�ria. A solu��o simples seria destativar as
chaves temporariamente, mas isso geraria um segundo problema. Ao fazer um update
dois registros ter�o a mesma chave prim�ria, depois precisar�amos colocar as
chaves corretas usando mais um update, mas qual dos dois registros precisaremos
realmente alterar para a chave correta? Diante destes problemas resolvi alterar
as chaves do banco para que elas aceitassem valores negativos. Assim � necess�rio
apenas fazer um update trocando as chaves antigas pelas chaves novas COM SINAL
NEGATIVO que nunca ser�o iguais a nenhuma existente. Depois disso, no final � s�
executar um update que troca o sinal das chaves e tudo ficar� correto! }
                            OldPrimaryKeyValue := ClientSyncRecord.PrimaryKeyValue;
                            NewPrimaryKeyValue := -MySQLGetUserVariable(aZConnection
                                                                       ,ClientSyncTable.TableName +  '_KEY_' + IntToStr(OldPrimaryKeyValue)).AsInt64;
                            { Caso seja uma proposta devemos retornar para o
                            cliente o c�digo e o ano da proposta que foram
                            gerados no servidor }
                            if ServerSyncTable is TPropostas then
                            begin
                                CodigoEAnoDaProposta(aZConnection
                                                    ,Abs(NewPrimaryKeyValue)
                                                    ,Codigo
                                                    ,Ano);

                                TProposta(MySelf).SM_CODIGO := Codigo;
                                TProposta(MySelf).YR_ANO := Ano;
                            end;
                        end;
                        { Pode parecer desnecess�rio atualizar no cliente todos
                        os campos de um registro que acabamos de atualizar, mas
                        h� um caso especial que ocorre quando no servidor h� uma
                        altera��o para este mesmo registro. Se n�o fizermos esta
                        atualiza��o aqui, prevalecer� no cliente aquilo que est�
                        no servidor, mas na verdade, como n�s o atualizamos pela
                        ultima vez, as nossas altera��es tem de ser mantidas.
                        Logo, para cada altera��o do cliente deveremos realizar
                        a mesma coisa na volta para garantir! }
                        apUpdate: AddSynchronizableItem(aServerDelta
                                                       ,aZConnection
                                                       ,ServerSyncTable.TableName
                                                       ,ClientSyncRecord.PrimaryKeyValue
                                                       ,apUpdate
                                                       ,True);
                    end;
                end;
            end;
        end;
end;{$ENDIF}

procedure TFSYGlobals.GenerateDeltaFile({$IFDEF FTPSYNCSER}aClient: TConnectedClient;{$ENDIF}
                                        aZConnection: TZConnection; 
                                        aOutputFile: TFileName; 
                                        aRichEdit: TRichEdit;
                                        aVerboseMode: Boolean;
                                        aDeltaFilter: String = '';
                                        aOpenFileIfExists: Boolean = False;
                                        aProgressBar: TProgressBar = nil;
                                        aLabelPercentDone: TLabel = nil);
var
    SyncFile: TSynchronizationFile;
    Delta: TZReadOnlyQuery;
    ActionPerformed: TActionPerformed;
    Mensagem: String;
begin
	Delta := nil;
    SyncFile := nil;

	try
    	SyncFile := TSynchronizationFile.Create(aZConnection,False);

        if aOpenFileIfExists then
        	SyncFile.LoadFromBinaryFile(aOutputFile);

        if Trim(aDeltaFilter) <> '' then
			ConfigureDataSet(aZConnection,Delta,'SELECT * FROM DELTA WHERE ' + aDeltaFilter + ' ORDER BY MI_ORDEM')
        else
        	ConfigureDataSet(aZConnection,Delta,'SELECT * FROM DELTA ORDER BY MI_ORDEM');

        if Assigned(aProgressBar) then
        begin
        	aProgressBar.Position := 0;
            aProgressBar.Max := Delta.RecordCount;
  			aProgressBar.Step := 1;
        end;

        if Assigned(aLabelPercentDone) then
        	aLabelPercentDone.Caption := '0%';

    	if Delta.RecordCount > 0 then
        begin
            Mensagem := 'Gerando/Atualizando objeto de sincroniza��o a partir de ' + IntToStr(Delta.RecordCount)  + ' entradas de DELTA. Favor aguardar...';
            ShowOnLog('� ' + Mensagem,aRichEdit);
            {$IFDEF FTPSYNCSER}
            if aVerboseMode then
                SendStatus(aClient,Mensagem);
            {$ENDIF}
        end;

        Delta.First;
        while not Delta.Eof do
        begin
            { ---------------------------------------------------------------- }
            { Se por alguma raz�o nenhuma a��o conhecida for especificada,
            devemos instruir a n�o fazer nada com os dados }
            ActionPerformed := apNothing;
            if Delta.FieldByName('EN_ACAO').AsString = 'INS' then
                ActionPerformed := apInsert
            else if Delta.FieldByName('EN_ACAO').AsString = 'UPD' then
                ActionPerformed := apUpdate
            else if Delta.FieldByName('EN_ACAO').AsString = 'DEL' then
                ActionPerformed := apDelete;

            {$IFDEF FTPSYNCSER}
            try
                AddSynchronizableItem(SyncFile
                                     ,aZConnection
                                     ,Delta.FieldByName('VA_NOMEDATABELA').AsString
                                     ,Delta.FieldByName('VA_CHAVE').AsInteger
                                     ,ActionPerformed
                                     ,False); // Ignorar erros de refer�ncia n�o encontrada?
            except
                on E: EAddSynchronizableItem do
                begin
                    if aVerboseMode then
                        SendStatus(aClient,'AVISO: ' + E.Message);
                end
                else
                    raise; // Qualquer outro erro � enviado para frente
            end;
            {$ELSE}
            AddSynchronizableItem(SyncFile
                                 ,aZConnection
                                 ,Delta.FieldByName('VA_NOMEDATABELA').AsString
                                 ,Delta.FieldByName('VA_CHAVE').AsInteger
                                 ,ActionPerformed
                                 ,False); // Ignorar erros de refer�ncia n�o encontrada?
            {$ENDIF}

            { ---------------------------------------------------------------- }
            if Assigned(aProgressBar) then
                aProgressBar.StepIt;

            if Assigned(aLabelPercentDone) then
                aLabelPercentDone.Caption := Format('%d%%',[Round(Delta.RecNo / Delta.RecordCount * 100)]);

            { TODO -oCarlos Feitoza -cEXPLICA��O : N�o insista! N�o se pode usar
            processmessages ou qualquer fun��o deste tipo quando estamos
            trabalhando com FTP S�ncrono, pois isso causa MUITOS problemas }
//  			Application.ProcessMessages;

            Delta.Next;
        end;

       	SyncFile.SaveToBinaryFile(aOutputFile);
    finally
        if Assigned(SyncFile) then
        	SyncFile.Free;
    end;
end;

{$IFDEF FTPSYNCSER}
function TFSYGlobals.GenerateRandomText(const aDataSize: Integer): String;
var
    i: Cardinal;
begin
    randomize;
    i := aDataSize;
    Result := '';
    while i > 0 do
        if Random(100) > 90 then
        begin
            if i > 1 then
            begin
                Result := Result + #13#10;
                Dec(i,2)
            end
            else
            begin
                Result := Result + #13;
                Dec(i);
            end;
        end
        else
        begin
            Result := Result + Chr(Round(Random(255)));
            Dec(i);
        end;
end;{$ENDIF}

function TFSYGlobals.ReadConfigurations(const aConfigFile: TFileName = ''): Boolean;
var
	FOFC: file of TConfigurations;
begin
	Result := False;

	(* Colocando valores padr�o (caso de nao haver arquivo de configura��o) *)
    FConfigurations.DB_Password := DB_PASSWORD;
    FConfigurations.DB_UserName := DB_USERNAME;
    FConfigurations.DB_Protocol := DB_PROTOCOL;
    FConfigurations.DB_DataBase := DB_DATABASE;
    FConfigurations.DB_HostAddr := DB_HOSTADDR;
    FConfigurations.DB_PortNumb := DB_PORTNUMB;
    FConfigurations.FT_PortNumb := FTP_PORTNUMB;
    {$IFDEF FTPSYNCSER}
    FConfigurations.SalvarLogACada := SALVAR_LOG;
    {$ENDIF}

    {$IFDEF FTPSYNCCLI}
   	FConfigurations.FT_UserName := FTP_USERNAME;
    FConfigurations.FT_PassWord := FTP_PASSWORD;
    FConfigurations.FT_HostName := FTP_HOSTNAME;
    FConfigurations.FT_PassiveMode := FTP_PASSIVEMODE;
    FConfigurations.FT_CommandDelay := FTP_COMMANDDELAY;
    FConfigurations.VerboseMode := VERBOSEMODE;
    FConfigurations.CheckMD5 := CHECKMD5;
    FConfigurations.UseCompression := USE_COMPRESSION;
    {$ENDIF}

    if aConfigFile = '' then
    begin
		if FileExists(FCurrentDir + ARQUIVO_DE_CONFIGURACOES) then
	        try
  				AssignFile(FOFC,FCurrentDir + ARQUIVO_DE_CONFIGURACOES);
	    		FileMode := fmOpenRead; //Abrir para leitura apenas
    			reset(FOFC);
				Read(FOFC,FConfigurations);
		    	Result := True;
	        finally
		    	CloseFile(FOFC);
	        end;
    end
    else
		if FileExists(aConfigFile) then
	        try
				AssignFile(FOFC,aConfigFile);
  	    	  	FileMode := fmOpenRead; //Abrir para leitura apenas
    	    	Reset(FOFC);
				Read(FOFC,FConfigurations);
		    	Result := True;
    	    finally
	    	    CloseFile(FOFC);
	        end;
end;

{$IFDEF FTPSYNCCLI}
procedure TFSYGlobals.ReplaceLogLastLine(aRichEdit: TRichEdit; aText: String);
begin
	{ Remontando a linha }
	aRichEdit.Lines[Pred(aRichEdit.Lines.Count)] := Copy(aRichEdit.Lines[Pred(aRichEdit.Lines.Count)],1,22) + aText;

  { Tornando negrito e na cor preta a string inteira }
  aRichEdit.SelStart := Length(aRichEdit.Text) - Length(aRichEdit.Lines[Pred(aRichEdit.Lines.Count)]) - 2;
  aRichEdit.SelLength := Length(aRichEdit.Lines[Pred(aRichEdit.Lines.Count)]);
  aRichEdit.SelAttributes.Color := clWindowText;
  aRichEdit.SelAttributes.Style := [fsBold];

  { Removendo o atributo negrito do colchete (]) }
  aRichEdit.SelStart := aRichEdit.SelStart + 20;
  aRichEdit.SelLength := 1;
  aRichEdit.SelAttributes.Style := [];

  { Seleconando a segunda parte do texto }
  aRichEdit.SelStart := Length(aRichEdit.Text) - Length(aRichEdit.Lines[Pred(aRichEdit.Lines.Count)]) + 20;
  aRichEdit.SelLength := Length(aText);

  { Pintando a linha da mensagem de acordo com o texto }
  if Pos('RETORNO:>',aText) = 1 then
    aRichEdit.SelAttributes.Color := clBlue
  else if Pos('COMANDO:>',aText) = 1 then
    aRichEdit.SelAttributes.Color := clGreen
  else if aText[1] = '!' then
    aRichEdit.SelAttributes.Color := clRed
  else if aText[1] = '�' then
    aRichEdit.SelAttributes.Color := $000080FF
  else if aText[1] = '@' then
    aRichEdit.SelAttributes.Color := clPurple;

  aRichEdit.SelLength := 0;
end;{$ENDIF}

{ ERROS DE SINCRONIZA��O PODE OCORRER DEVIDO A DESFRAGMENTA��O }

//procedure TFSYGlobals.MySQLDefragDatabase(aZConnection: TZConnection; aProgressBar: TProgressBar = nil; aLabelPercentDone: TLabel = nil);
//var
//	RODataSet: TZReadOnlyQuery;
//begin
//	RODataSet := nil;
//  	try
//        ConfigureDataSet(aZConnection,RODataSet,'SHOW FULL TABLES WHERE TABLE_TYPE <> ''VIEW''');
//
//        if Assigned(aProgressBar) then
//        begin
//            aProgressBar.Position := 0;
//            aProgressBar.Max := RODataSet.RecordCount;
//            aProgressBar.Step := 1;
//        end;
//
//        if Assigned(aLabelPercentDone) then
//            aLabelPercentDone.Caption := '0%';
//
//        RODataSet.First;
//        while not RODataSet.Eof do
//        begin
//            MySQLExecuteSQLScript(aZConnection,nil,'','OPTIMIZE TABLE ' + RODataSet.Fields[0].AsString);
//            { TODO -oCarlos Feitoza -cEXPLICA��O : O modo abaixo � antigo e n�o
//            ajusta os autoincrementos }
//            //MySQLExecuteSQLScript(aZConnection,nil,'','ALTER TABLE ' + RODataSet.Fields[0].AsString + ' ENGINE = InnoDB;');
//
//            if Assigned(aProgressBar) then
//                aProgressBar.StepIt;
//
//            if Assigned(aLabelPercentDone) then
//                aLabelPercentDone.Caption := Format('%d%%',[Round(RODataSet.RecNo / RODataSet.RecordCount * 100)]);
//
//            {$IFDEF FTPSYNCCLI}
//            Application.ProcessMessages;
//            {$ENDIF}
//            RODataSet.Next;
//        end;
//
//	finally
//  		if Assigned(RODataSet) then
//    		RODataSet.Free;
//  	end;
//end;

procedure TFSYGlobals.MySQLExecuteSQLScript(aZConnection: TZConnection; aRichEdit: TRichEdit; const aSQLScriptFile: TFileName = ''; const aSQLScriptText: String = ''; const aForeignKeysCheck: Boolean = True; aProgressBarCurrent: TProgressBar = nil; aProgressBarOverall: TProgressBar = nil; aLabelCurrentDescription: TLabel = nil; aLabelOverallDescription: TLabel = nil; aLabelCurrentValue: TLabel = nil; aLabelOverallValue: TLabel = nil);
var
    i: Cardinal;
    Processor: TZSQLProcessor;
    ProcessorEvents: TProcessorEvents;
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
	    SplitSQLScript(aZConnection,aRichEdit,ScriptParts,aSQLScriptFile,aSQLScriptText,aForeignKeysCheck);

    	{ PASSO 2: Executando cada uma das partes do script dividido }
		if ScriptParts.Count > 0 then
        begin
            if aZConnection.Connected then
            begin
                if Assigned(aProgressBarOverall) then
                begin
                    aProgressBarOverall.Max := ScriptParts.Count;
                    aProgressBarOverall.Position := 0;
                    aProgressBarOverall.Step := 1;
                end;

                if Assigned(aLabelCurrentDescription) and Assigned(aLabelCurrentValue) then
                    SetLabelDescriptionValue(aLabelCurrentDescription,aLabelCurrentValue,'0 / ' + IntToStr(aProgressBarCurrent.Max));

                Processor := nil;
                ProcessorEvents := nil;
                try
                    ProcessorEvents := TProcessorEvents.Create(aProgressBarCurrent,aLabelCurrentValue,aLabelCurrentDescription);

                    Processor := TZSQLProcessor.Create(aZConnection);
                    Processor.ParamCheck := False;
                    Processor.Connection := aZConnection;
                    Processor.DelimiterType := dtSetTerm;

                    Processor.AfterExecute := ProcessorEvents.DoAfterExecute;
                    Processor.BeforeExecute := ProcessorEvents.DoBeforeExecute;

		            if Assigned(aRichEdit) then
        	            ShowOnLog('� Executando script. Favor aguardar...',aRichEdit);

                    for i := 0 to Pred(ScriptParts.Count) do
                    begin
                        Processor.Clear;
                        Processor.Delimiter := ScriptParts[i].Delimiter;
                        Processor.Script.Text := ScriptParts[i].Script;

                        if Assigned(aProgressBarCurrent) then
                        begin
	                        Processor.Parse;
                            aProgressBarCurrent.Max := Processor.StatementCount;
                            aProgressBarCurrent.Position := 0;
                            aProgressBarCurrent.Step := 1;
                        end;

                        Processor.Execute;

                        if Assigned(aLabelOverallDescription) and Assigned(aLabelOverallValue) then
		                    SetLabelDescriptionValue(aLabelOverallDescription,aLabelOverallValue,IntToStr(Succ(i)) + ' / ' + IntToStr(ScriptParts.Count));
                        if Assigned(aProgressBarOverall) then
                            aProgressBarOverall.StepIt;

                        {$IFDEF FTPSYNCCLI}
                        Application.ProcessMessages;
                        {$ENDIF}
                    end;

                    if Assigned(aRichEdit) then
				        ShowOnLog('� Execu��o do script finalizada!',aRichEdit);
                finally
  	                if Assigned(ProcessorEvents) then
                    	ProcessorEvents.Free;
                    if Assigned(Processor) then
	                    Processor.Free;
                end;
            end;
        end
        else
            raise Exception.Create('O arquivo selecionado n�o cont�m um script v�lido!');
    finally
    	if Assigned(ScriptParts) then
        	ScriptParts.Free
    end;
end;

//procedure TNewGlobals.ExecuteSQLScript(theConnection: TZConnection; FileName: TFileName; Script: String = '');
//var
//  Processor: TZSQLProcessor;
//begin
//	Processor := nil;
//	try
//    Processor := TZSQLProcessor.Create(theConnection);
//    Processor.Connection := theConnection;
//    try
//      { Os novos processors  usam  par�metros, o que  nos impede de usar ":"  em
//      coment�rios e  outros lugares.  A  linha abaixo  desliga a  verifica��o de
//      par�metros, o  que possibilita o  uso  normal  de ":". Se um dia o  uso de
//      par�mtros for necess�rio considere estas informa��es na hora de  construir
//      seu script }
//      Processor.ParamCheck := False;
//      if Trim(Script) <> '' then
//      	Processor.Script.Text := Script
//      else
//	      Processor.Script.LoadFromFile(FileName);
//      Processor.Execute;
//    except
//    	on EZDE: EZDatabaseError do
//      begin
//      	EZDE.Message := Format(rs_ezde,['ExecuteSQLScript',PutLineBreaks(EZDE.Message,80)]);
//        raise;
//      end;
//      on EZSE: EZSQLException do
//      begin
//      	EZSE.Message := Format(rs_ezse,['ExecuteSQLScript',PutLineBreaks(EZSE.Message,80)]);
//        raise;
//      end;
//      on E: Exception do
//      begin
//      	E.Message := Format(rs_exc,['ExecuteSQLScript',PutLineBreaks(E.Message,80)]);
//        raise;
//      end;
//    end;
//  finally
//  	if Assigned(Processor) then
//    	Processor.Free;
//  end;
//end;

procedure TFSYGlobals.MySQLSetDBUserVariable(const aZConnection: TZConnection; aVariableName: String; aVariableValue: Int64);
const
    VARIABLE_SET = 'SET @%s = %d;';
begin
   	ExecuteQuery(aZConnection,Format(VARIABLE_SET,[aVariableName,aVariableValue]));
end;

procedure TFSYGlobals.MySQLSetDBUserVariable(const aZConnection: TZConnection; aVariableName: String; aVariableValue: Boolean);
const
    VARIABLE_SET = 'SET @%s = %s;';
begin
   	ExecuteQuery(aZConnection,Format(VARIABLE_SET,[aVariableName,BoolToStr(aVariableValue,True)]));
end;

procedure TFSYGlobals.MySQLSetDBUserVariable(const aZConnection: TZConnection; aVariableName, aVariableValue: String);
const
    VARIABLE_SET = 'SET @%s = ''%s'';';
begin
   	ExecuteQuery(aZConnection,Format(VARIABLE_SET,[aVariableName,aVariableValue]));
end;

{ O procedure abaixo atribui valores a vari�veis do MySQL e n�o a vari�veis de usu�rio }
procedure TFSYGlobals.MySQLSetVariable(aZConnection: TZConnection; aVariableName: String; aVariableValue: Int64);
const
    VARIABLE_SET = 'SET %s = %d;';
begin
   	ExecuteQuery(aZConnection,Format(VARIABLE_SET,[aVariableName,aVariableValue]));
end;

{$IFDEF FTPSYNCSER}{$WARNINGS OFF}
procedure TFSYGlobals.MySQLFullSnapShot(aClient: TConnectedClient;
                                        aZConnection: TZConnection;
                                        aUseCompression: Boolean;
                                        aRichEdit: TRichEdit;
                                        aVerboseMode: Boolean;
                                        aOnZLibNotification: TZlibNotification);
const
	DELIMITER = '�';
  	SQLScript =
  	'# ============================================================================ #'#13#10 +
  	'# SCRIPT DE DEPURA��O REMOTO GERADO EM <%>CURRENTDATEANDTIME<%>                #'#13#10 +
  	'# FTP SYNCRONIZER / SERVER - VERS�O <%>SYNCRONIZERVERSION<%>                   #'#13#10 +
  	'# ============================================================================ #'#13#10#13#10 +
  	'DROP DATABASE IF EXISTS BANCODEOBRAS_REMOTEDBG;'#13#10#13#10 +
  	'CREATE DATABASE BANCODEOBRAS_REMOTEDBG DEFAULT CHARACTER SET LATIN1 COLLATE LATIN1_BIN;'#13#10#13#10 +
  	'USE BANCODEOBRAS_REMOTEDBG;'#13#10#13#10 +

  	'# ============================================================================ #'#13#10 +
  	'# DEFINI��O DE ROTINAS - IN�CIO                                                #'#13#10 +
  	'# ============================================================================ #'#13#10 +
  	'<%>DBROUTINES<%>' +
  	'# ============================================================================ #'#13#10 +
  	'# DEFINI��O DE ROTINAS - FIM                                                   #'#13#10 +
  	'# ============================================================================ #'#13#10#13#10 +

  	'# ============================================================================ #'#13#10 +
    '# DEFINI��O DE TABELAS - IN�CIO                                                #'#13#10 +
    '# ============================================================================ #'#13#10 +
  	'<%>TABLEDEFINITIONS<%>' +
    '# ============================================================================ #'#13#10 +
    '# DEFINI��O DE TABELAS - FIM                                                   #'#13#10 +
    '# ============================================================================ #'#13#10#13#10 +

  	'# ============================================================================ #'#13#10 +
  	'# DEFINI��O DE TRIGGERS - IN�CIO                                               #'#13#10 +
  	'# ============================================================================ #'#13#10 +
  	'<%>DBTRIGGERS<%>' +
  	'# ============================================================================ #'#13#10 +
  	'# DEFINI��O DE TRIGGERS - FIM                                                  #'#13#10 +
  	'# ============================================================================ #'#13#10#13#10 +

    '# ============================================================================ #'#13#10 +
    '# ADI��O DE CONSTRAINTS - IN�CIO                                               #'#13#10 +
    '# ============================================================================ #'#13#10 +
  	'<%>TABLECONSTRAINTS<%>' +
    '# ============================================================================ #'#13#10 +
    '# ADI��O DE CONSTRAINTS - FIM                                                  #'#13#10 +
    '# ============================================================================ #'#13#10#13#10 +

  	'# ============================================================================ #'#13#10 +
  	'# DEFINI��O DE VIEWS - IN�CIO                                                  #'#13#10 +
  	'# ============================================================================ #'#13#10 +
    '<%>DBVIEWS<%>' +
  	'# ============================================================================ #'#13#10 +
  	'# DEFINI��O DE VIEWS - FIM                                                     #'#13#10 +
  	'# ============================================================================ #';

  	INSHEADER =
  	'# == INSER��ES PARA A TABELA %s'#13#10#13#10;

  	INSERT_SCHEMA = 'INSERT INTO '#13#10'  %s'#13#10'VALUES'#13#10;

  	QUERY_SIZE =
  	'# == A INSTRU��O ACIMA POSSUI %u INSER��ES (%u BYTES)';

    TRIGGER_TEMPLATE =
    'DELIMITER %s'#13#10 +
    'CREATE TRIGGER %s %s %s'#13#10 +
    'ON %s FOR EACH ROW'#13#10 +
    '%s; %0:s'#13#10 +
    'DELIMITER ;';

    ROUTINE_TEMPLATE =
    'DELIMITER %s'#13#10 +
    '%s; %0:s'#13#10 +
    'DELIMITER ;';

var
	DatabaseRoutines, CurrentRoutine, DatabaseViews, CurrentView, DatabaseTriggers, CurrentTrigger,
	AvailableTables, CurrentTableDefinition, TableInsertions: TZReadOnlyQuery;
    DBRoutines, DBViews, DBTriggers,
  	TableDefinitions, CurrentDefinition, TableConstraints, CurrentConstraint, ValuesPart, CurrentQuery, ScriptFinal: String;
  	i{, AvailableTablesQtd}, QuerySize: Word;
  	CurrentRow: Cardinal;
  	Version: String;
begin
	ScriptFinal := StringReplace(SQLScript,'<%>CURRENTDATEANDTIME<%>',FormatDateTime('dd/mm/yyyy "�s" hh:nn:ss',Now) + '  ',[]);

	SendStatus(aClient,'== MySQLFullSnapShot: Iniciando gera��o de conte�do... ============================');
    SendStatus(aClient,'-----------------------------------------------------------------------------------');

    Version := TFileInformation.GetInfo(Application.ExeName,'FULLVERSION').AsString;

	ScriptFinal := StringReplace(ScriptFinal,'<%>SYNCRONIZERVERSION<%>',Version + DupeString(' ',24 - Length(Version)),[]);

  	{ == Extra��o de stored routines ========================================= }
    try
    	DatabaseRoutines := nil;
        CurrentRoutine := nil;
        DBRoutines := '';
        ConfigureDataSet(aZConnection,DatabaseRoutines,'SELECT SPECIFIC_NAME, ROUTINE_TYPE FROM information_schema.ROUTINES WHERE ROUTINE_SCHEMA = ' + QuotedStr(FConfigurations.DB_DataBase));
        if DatabaseRoutines.RecordCount > 0 then
        begin
            if aVerboseMode then
               	SendStatus(aClient,'Extraindo ' + IntToStr(DatabaseRoutines.RecordCount) + ' "Stored Routines"...');
            while not DatabaseRoutines.Eof do
            begin
            	if DatabaseRoutines.RecNo < DatabaseRoutines.RecordCount then
                begin
                    if aVerboseMode then
    					SendStatus(aClient,' |- ' + DatabaseRoutines.Fields[0].AsString);
                end
                else
                begin
                    if aVerboseMode then
    					SendStatus(aClient,' \- ' + DatabaseRoutines.Fields[0].AsString);
                end;

                if UpperCase(DatabaseRoutines.Fields[1].AsString) = 'FUNCTION' then
                    ConfigureDataSet(aZConnection,CurrentRoutine,'SHOW CREATE FUNCTION ' + DatabaseRoutines.Fields[0].AsString)
                else if UpperCase(DatabaseRoutines.Fields[1].AsString) = 'PROCEDURE' then
                    ConfigureDataSet(aZConnection,CurrentRoutine,'SHOW CREATE PROCEDURE ' + DatabaseRoutines.Fields[0].AsString);

                DBRoutines := DBRoutines + Format(ROUTINE_TEMPLATE,[DELIMITER,CurrentRoutine.Fields[2].AsString]);

                if DatabaseRoutines.RecNo < DatabaseRoutines.RecordCount then
	                DBRoutines := DBRoutines + #13#10#13#10
                else
                	DBRoutines := DBRoutines + #13#10;

                DatabaseRoutines.Next;
            end;
        end
        else
            DBRoutines := #13#10'# A base de dados ' + UpperCase(FConfigurations.DB_DataBase) + ' n�o possui stored routines!'#13#10#13#10;
    finally
    	if Assigned(CurrentRoutine) then
        	FreeAndNil(CurrentRoutine);

       	FreeAndNil(DatabaseRoutines);
    end;
  	{ ======================================================================== }

  	{ == Extra��o de vis�es ================================================== }
    try
    	DatabaseViews := nil;
        CurrentView := nil;
        DBViews := '';
        ConfigureDataSet(aZConnection,DatabaseViews,'SHOW FULL TABLES WHERE TABLE_TYPE = ''VIEW''');
        if DatabaseViews.RecordCount > 0 then
        begin
            if aVerboseMode then
            	SendStatus(aClient,'Extraindo ' + IntToStr(DatabaseViews.RecordCount) + ' "Views"...');
            while not DatabaseViews.Eof do
            begin
            	if DatabaseViews.RecNo < DatabaseViews.RecordCount then
                begin
                    if aVerboseMode then
    					SendStatus(aClient,' |- ' + DatabaseViews.Fields[0].AsString);
                end
                else
                begin
                    if aVerboseMode then
    					SendStatus(aClient,' \- ' + DatabaseViews.Fields[0].AsString);
                end;

                ConfigureDataSet(aZConnection,CurrentView,'SHOW CREATE VIEW ' + DatabaseViews.Fields[0].AsString);

                DBViews := DBViews + CurrentView.Fields[1].AsString + ';';

                if DatabaseViews.RecNo < DatabaseViews.RecordCount then
	                DBViews := DBViews + #13#10#13#10
                else
                	DBViews := DBViews + #13#10;

                DatabaseViews.Next;
            end;
        end
        else
            DBViews := #13#10'# A base de dados ' + UpperCase(FConfigurations.DB_DataBase) + ' n�o possui views!'#13#10#13#10;
    finally
    	if Assigned(CurrentView) then
        	FreeAndNil(CurrentView);

        FreeAndNil(DatabaseViews);
    end;
  	{ ======================================================================== }

    { == Extra��o de triggers ================================================ }
    try
    	DatabaseTriggers := nil;
        CurrentTrigger := nil;
        DBTriggers := '';
	    ConfigureDataSet(aZConnection,DatabaseTriggers,'SHOW TRIGGERS');
	    if DatabaseTriggers.RecordCount > 0 then
        begin
            if aVerboseMode then
    	     	SendStatus(aClient,'Extraindo ' + IntToStr(DatabaseTriggers.RecordCount) + ' "Triggers"...');
            while not DatabaseTriggers.Eof do
            begin
            	if DatabaseTriggers.RecNo < DatabaseTriggers.RecordCount then
                begin
                    if aVerboseMode then
    					SendStatus(aClient,' |- ' + DatabaseTriggers.Fields[0].AsString);
                end
                else
                begin
                    if aVerboseMode then
    					SendStatus(aClient,' \- ' + DatabaseTriggers.Fields[0].AsString);
                end;

                DBTriggers := DBTriggers + Format(TRIGGER_TEMPLATE,[
                    DELIMITER,
                    DatabaseTriggers.Fields[0].AsString,
                    DatabaseTriggers.Fields[4].AsString,
                    DatabaseTriggers.Fields[1].AsString,
                    DatabaseTriggers.Fields[2].AsString,
                    DatabaseTriggers.Fields[3].AsString
                ]);

                if DatabaseTriggers.RecNo < DatabaseTriggers.RecordCount then
	                DBTriggers := DBTriggers + #13#10#13#10
                else
                	DBTriggers := DBTriggers + #13#10;

                DatabaseTriggers.Next;
            end;
        end
    	else
        	DBTriggers := #13#10'# A base de dados ' + UpperCase(FConfigurations.DB_DataBase) + ' n�o possui triggers!'#13#10#13#10;
    finally
    	if Assigned(CurrentTrigger) then
        	FreeAndNil(CurrentTrigger);

        FreeAndNil(DatabaseTriggers);
    end;
    { ======================================================================== }

  	try
        AvailableTables := nil;
        CurrentTableDefinition := nil;
        TableInsertions := nil;
        ConfigureDataSet(aZConnection,AvailableTables,'SHOW FULL TABLES WHERE TABLE_TYPE <> ''VIEW''');

        with AvailableTables do
        begin
            TableDefinitions := '';
            TableConstraints := '';

            First;

            if aVerboseMode then
                SendStatus(aClient,'Extraindo ' + IntToStr(AvailableTables.RecordCount) + ' Tabelas...');

            while not Eof do
            begin
                if RecNo < RecordCount then
                begin
                    if aVerboseMode then
                    begin
                        SendStatus(aClient,' |- ' + Fields[0].AsString);
                        SendStatus(aClient,' |   |- DDL (Comando de cria��o)...');
                    end;
                end
                else
                begin
                    if aVerboseMode then
                    begin
                        SendStatus(aClient,' \- ' + Fields[0].AsString);
                        SendStatus(aClient,'     |- DDL (Comando de cria��o)...');
                    end;
                end;

                ConfigureDataSet(aZConnection,CurrentTableDefinition,'SHOW CREATE TABLE ' + FConfigurations.DB_DataBase + '.' + UpperCase(Fields[0].AsString));

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
                begin
                    System.Delete(CurrentDefinition,i,PosEx(';',CurrentDefinition,i) - i);
                end;

                TableDefinitions := TableDefinitions + StringReplace(CurrentDefinition,','#13#10')',#13#10')',[]) + #13#10#13#10;

                TableDefinitions := TableDefinitions + Format(INSHEADER,[UpperCase(Fields[0].AsString)]);

                ConfigureDataSet(aZConnection,TableInsertions,'SELECT * FROM ' + Fields[0].AsString);

                if TableInsertions.RecordCount > 0 then
                begin
                    if RecNo < RecordCount then
                    begin
                        if aVerboseMode then
                            SendStatus(aClient,' |   \- DML (' + IntToStr(TableInsertions.RecordCount) + ' registros)...');
                    end
                    else
                    begin
                        if aVerboseMode then
                            SendStatus(aClient,'     \- DML (' + IntToStr(TableInsertions.RecordCount) + ' registros)...');
                    end;

                    { QuerySize ser� acumulado at� que ele contenha um
                    valor de no m�ximo MAX_QUERY_SIZE, quando
                    CurrentQuery � conclu�do e juntado � TableDefinitions }
                    QuerySize := 0;
                    CurrentRow := 0;

                    while not TableInsertions.Eof do
                    begin
                        Inc(CurrentRow);

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
                                ValuesPart := ValuesPart + Hex(TableInsertions.Fields[i].AsString);

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

                        TableInsertions.Next;
                    end;

                    if CurrentRow > 0 then
                        TableDefinitions := TableDefinitions + ';'#13#10 + Format(QUERY_SIZE,[CurrentRow,QuerySize]) + #13#10#13#10;
                end
                else
                    TableDefinitions := TableDefinitions + '# A tabela ' + UpperCase(Fields[0].AsString) + ' est� vazia!'#13#10#13#10;

                TableInsertions.Close;

                Next;
            end;

            ScriptFinal := StringReplace(ScriptFinal,'<%>DBROUTINES<%>',DBRoutines,[]);
            ScriptFinal := StringReplace(ScriptFinal,'<%>TABLEDEFINITIONS<%>',TableDefinitions,[]);
            ScriptFinal := StringReplace(ScriptFinal,'<%>DBTRIGGERS<%>',DBTriggers,[]);
            ScriptFinal := StringReplace(ScriptFinal,'<%>TABLECONSTRAINTS<%>',TableConstraints,[]);
            ScriptFinal := StringReplace(ScriptFinal,'<%>DBVIEWS<%>',DBViews,[]);
        end;

        SaveTextFile(ScriptFinal,aClient.HomeDir + FTPFIL_REMOTESNAPSHOT);

        { Comprimindo caso seja necess�rio }
        if aUseCompression then
            ComprimirArquivo(aClient.HomeDir + FTPFIL_REMOTESNAPSHOT
                            ,aRichEdit
                            ,aOnZLibNotification);

        SendStatus(aClient,'-----------------------------------------------------------------------------------');
        SendStatus(aClient,'SOC: ' + IntToStr(Trunc(FileSize(aClient.HomeDir + FTPFIL_REMOTESNAPSHOT))));
        SendStatus(aClient,'== MySQLFullSnapShot: Conte�do gerado com sucesso =================================');
    finally
    	if Assigned(TableInsertions) then
    		FreeAndNil(TableInsertions);
        if Assigned(CurrentTableDefinition) then
            FreeAndNil(CurrentTableDefinition);
        if Assigned(AvailableTables) then
            FreeAndNil(AvailableTables);
	end;
end;{$WARNINGS ON}

procedure TFSYGlobals.SendStatus(aClient: TConnectedClient;
                                 aStatus: String);
begin
	if Assigned(aClient) then
        aClient.SendAnswer('# ' + aStatus);
end;

{$WARNINGS OFF}
procedure TFSYGlobals.MySQLSmartSnapShot(aClient: TConnectedClient;
                                         aZConnection: TZConnection;
                                         aUseCompression: Boolean;
                                         aRichEdit: TRichEdit;
                                         aVerboseMode: Boolean;
                                         aOnZLibNotification: TZlibNotification);
const
	DELIMITER = '�';
  	SQLScript =
  	'# ============================================================================ #'#13#10 +
  	'# SCRIPT GERADO EM <%>CURRENTDATEANDTIME<%>                                    #'#13#10 +
  	'# FTP SYNCRONIZER / SERVER - VERS�O <%>SYNCRONIZERVERSION<%>                   #'#13#10 +
  	'# ============================================================================ #'#13#10#13#10 +
  	'DROP DATABASE IF EXISTS <%>DATABASENAME<%>;'#13#10#13#10 +
  	'CREATE DATABASE <%>DATABASENAME<%> DEFAULT CHARACTER SET LATIN1 COLLATE LATIN1_BIN;'#13#10#13#10 +
  	'USE <%>DATABASENAME<%>;'#13#10#13#10 +

  	'# ============================================================================ #'#13#10 +
  	'# DEFINI��O DE ROTINAS - IN�CIO                                                #'#13#10 +
  	'# ============================================================================ #'#13#10 +
  	'<%>DBROUTINES<%>' +
  	'# ============================================================================ #'#13#10 +
  	'# DEFINI��O DE ROTINAS - FIM                                                   #'#13#10 +
  	'# ============================================================================ #'#13#10#13#10 +

//    'SET @SYNCHRONIZING := True;'#13#10#13#10 +
//    'SET @SERVERSIDE := False;'#13#10#13#10 +

  	'# ============================================================================ #'#13#10 +
    '# DEFINI��O DE TABELAS - IN�CIO                                                #'#13#10 +
    '# ============================================================================ #'#13#10 +
  	'<%>TABLEDEFINITIONS<%>' +
    '# ============================================================================ #'#13#10 +
    '# DEFINI��O DE TABELAS - FIM                                                   #'#13#10 +
    '# ============================================================================ #'#13#10#13#10 +

  	'# ============================================================================ #'#13#10 +
  	'# DEFINI��O DE TRIGGERS - IN�CIO                                               #'#13#10 +
  	'# ============================================================================ #'#13#10 +
  	'<%>DBTRIGGERS<%>' +
  	'# ============================================================================ #'#13#10 +
  	'# DEFINI��O DE TRIGGERS - FIM                                                  #'#13#10 +
  	'# ============================================================================ #'#13#10#13#10 +

    '# ============================================================================ #'#13#10 +
    '# ADI��O DE CONSTRAINTS - IN�CIO                                               #'#13#10 +
    '# ============================================================================ #'#13#10 +
  	'<%>TABLECONSTRAINTS<%>' +
    '# ============================================================================ #'#13#10 +
    '# ADI��O DE CONSTRAINTS - FIM                                                  #'#13#10 +
    '# ============================================================================ #'#13#10#13#10 +

  	'# ============================================================================ #'#13#10 +
  	'# DEFINI��O DE VIEWS - IN�CIO                                                  #'#13#10 +
  	'# ============================================================================ #'#13#10 +
    '<%>DBVIEWS<%>' +
  	'# ============================================================================ #'#13#10 +
  	'# DEFINI��O DE VIEWS - FIM                                                     #'#13#10 +
  	'# ============================================================================ #';

    INSHEADER =
    '# == INSER��ES PARA A TABELA %s'#13#10#13#10;

    ADJUSTHEADER =
    '# == AJUSTES ESTRUTURAIS PARA A TABELA %s'#13#10#13#10;

    COMPLEMENTARY_TABLES =
    'CREATE TABLE SINCRONIZACOES ('#13#10 +
    '  DT_DATAEHORADAULTIMA Datetime NOT NULL,'#13#10 +
    '  Primary Key (DT_DATAEHORADAULTIMA)'#13#10 +
    ')'#13#10 +
    'ENGINE = INNODB'#13#10 +
    'DEFAULT CHARACTER SET latin1 COLLATE latin1_bin;'#13#10#13#10 +

    '# == INSER��ES PARA A TABELA SINCRONIZACOES'#13#10#13#10 +

    'INSERT INTO SINCRONIZACOES VALUES (SYSDATE());'#13#10#13#10;

	INSERT_SCHEMA = 'INSERT INTO '#13#10'  %s'#13#10'VALUES'#13#10;

    QUERY_SIZE =
    '# == A INSTRU��O ACIMA POSSUI %u INSER��ES (%u BYTES)';

    TRIGGER_TEMPLATE =
    'DELIMITER %s'#13#10 +
    'CREATE TRIGGER %s %s %s'#13#10 +
    'ON %s FOR EACH ROW'#13#10 +
    '%s; %0:s'#13#10 +
    'DELIMITER ;';

    ROUTINE_TEMPLATE =
    'DELIMITER %s'#13#10 +
    '%s; %0:s'#13#10 +
    'DELIMITER ;';

var
	AvailableTables, CurrentTableDefinition, TableInsertions,
    DatabaseRoutines, DatabaseViews, CurrentRoutine, CurrentView, DatabaseTriggers, CurrentTrigger: TZReadOnlyQuery;
  	TableDefinitions, CurrentDefinition, TableConstraints, CurrentConstraint,
    CurrentQuery, ValuesPart, DBRoutines, DBViews, DBTriggers, ScriptFinal: String;
  	i, QuerySize: Word;
  	CurrentRow: Cardinal;
  	Version: String;

begin
	ScriptFinal := StringReplace(SQLScript,'<%>CURRENTDATEANDTIME<%>',FormatDateTime('dd/mm/yyyy "�s" hh:nn:ss',Now) + '  ',[]);

	SendStatus(aClient,'== MySQLSmartSnapShot: Iniciando gera��o de conte�do... ===========================');
    SendStatus(aClient,'-----------------------------------------------------------------------------------');

    Version := TFileInformation.GetInfo(Application.ExeName,'FULLVERSION').AsString;

	ScriptFinal := StringReplace(ScriptFinal,'<%>SYNCRONIZERVERSION<%>',Version + DupeString(' ',24 - Length(Version)),[]);

  	{ == Extra��o de stored routines ========================================= }
    try
    	DatabaseRoutines := nil;
        CurrentRoutine := nil;
        DBRoutines := '';
        ConfigureDataSet(aZConnection,DatabaseRoutines,'SELECT SPECIFIC_NAME, ROUTINE_TYPE FROM information_schema.ROUTINES WHERE ROUTINE_SCHEMA = ' + QuotedStr(FConfigurations.DB_DataBase));
        if DatabaseRoutines.RecordCount > 0 then
        begin
            if aVerboseMode then
            	SendStatus(aClient,'Extraindo ' + IntToStr(DatabaseRoutines.RecordCount) + ' "Stored Routines"...');
            while not DatabaseRoutines.Eof do
            begin
            	if DatabaseRoutines.RecNo < DatabaseRoutines.RecordCount then
                begin
                    if aVerboseMode then
    					SendStatus(aClient,' |- ' + DatabaseRoutines.Fields[0].AsString);
                end
                else
                begin
                    if aVerboseMode then
    					SendStatus(aClient,' \- ' + DatabaseRoutines.Fields[0].AsString);
                end;

                if UpperCase(DatabaseRoutines.Fields[1].AsString) = 'FUNCTION' then
                    ConfigureDataSet(aZConnection,CurrentRoutine,'SHOW CREATE FUNCTION ' + DatabaseRoutines.Fields[0].AsString)
                else if UpperCase(DatabaseRoutines.Fields[1].AsString) = 'PROCEDURE' then
                    ConfigureDataSet(aZConnection,CurrentRoutine,'SHOW CREATE PROCEDURE ' + DatabaseRoutines.Fields[0].AsString);

                DBRoutines := DBRoutines + Format(ROUTINE_TEMPLATE,[DELIMITER,CurrentRoutine.Fields[2].AsString]);

                if DatabaseRoutines.RecNo < DatabaseRoutines.RecordCount then
	                DBRoutines := DBRoutines + #13#10#13#10
                else
                	DBRoutines := DBRoutines + #13#10;

                DatabaseRoutines.Next;
            end;
        end
        else
            DBRoutines := #13#10'# A base de dados ' + UpperCase(FConfigurations.DB_DataBase) + ' n�o possui stored procedures ou fun��es!'#13#10#13#10;
    finally
    	if Assigned(CurrentRoutine) then
        	FreeAndNil(CurrentRoutine);

       	FreeAndNil(DatabaseRoutines);
    end;
  	{ ======================================================================== }

  	{ == Extra��o de vis�es ================================================== }
    try
    	DatabaseViews := nil;
        CurrentView := nil;
        DBViews := '';
        ConfigureDataSet(aZConnection,DatabaseViews,'SHOW FULL TABLES WHERE TABLE_TYPE = ''VIEW''');
        if DatabaseViews.RecordCount > 0 then
        begin
            if aVerboseMode then
            	SendStatus(aClient,'Extraindo ' + IntToStr(DatabaseViews.RecordCount) + ' "Views"...');
            while not DatabaseViews.Eof do
            begin
            	if DatabaseViews.RecNo < DatabaseViews.RecordCount then
                begin
                    if aVerboseMode then
    					SendStatus(aClient,' |- ' + DatabaseViews.Fields[0].AsString);
                end
                else
                begin
                    if aVerboseMode then
    					SendStatus(aClient,' \- ' + DatabaseViews.Fields[0].AsString);
                end;

                ConfigureDataSet(aZConnection,CurrentView,'SHOW CREATE VIEW ' + DatabaseViews.Fields[0].AsString);

                DBViews := DBViews + CurrentView.Fields[1].AsString + ';';

                if DatabaseViews.RecNo < DatabaseViews.RecordCount then
	                DBViews := DBViews + #13#10#13#10
                else
                	DBViews := DBViews + #13#10;

                DatabaseViews.Next;
            end;
        end
        else
            DBViews := #13#10'# A base de dados ' + UpperCase(FConfigurations.DB_DataBase) + ' n�o possui vis�es!'#13#10#13#10;
    finally
    	if Assigned(CurrentView) then
        	FreeAndNil(CurrentView);

        FreeAndNil(DatabaseViews);
    end;
  	{ ======================================================================== }

    { == Extra��o de triggers ================================================ }
    try
    	DatabaseTriggers := nil;
        CurrentTrigger := nil;
        DBTriggers := '';
	    ConfigureDataSet(aZConnection,DatabaseTriggers,'SHOW TRIGGERS');
	    if DatabaseTriggers.RecordCount > 0 then
        begin
            if aVerboseMode then
            	SendStatus(aClient,'Extraindo ' + IntToStr(DatabaseTriggers.RecordCount) + ' "Triggers"...');
            while not DatabaseTriggers.Eof do
            begin
            	if DatabaseTriggers.RecNo < DatabaseTriggers.RecordCount then
                begin
                    if aVerboseMode then
    					SendStatus(aClient,' |- ' + DatabaseTriggers.Fields[0].AsString);
                end
                else
                begin
                    if aVerboseMode then
					SendStatus(aClient,' \- ' + DatabaseTriggers.Fields[0].AsString);
                end;

                DBTriggers := DBTriggers + Format(TRIGGER_TEMPLATE,[
                    DELIMITER,
                    DatabaseTriggers.Fields[0].AsString,
                    DatabaseTriggers.Fields[4].AsString,
                    DatabaseTriggers.Fields[1].AsString,
                    DatabaseTriggers.Fields[2].AsString,
                    DatabaseTriggers.Fields[3].AsString
                ]);

                if DatabaseTriggers.RecNo < DatabaseTriggers.RecordCount then
	                DBTriggers := DBTriggers + #13#10#13#10
                else
                	DBTriggers := DBTriggers + #13#10;

                DatabaseTriggers.Next;
            end;
        end
    	else
        	DBTriggers := #13#10'# A base de dados ' + UpperCase(FConfigurations.DB_DataBase) + ' n�o possui triggers!'#13#10#13#10;
    finally
    	if Assigned(CurrentTrigger) then
        	FreeAndNil(CurrentTrigger);

        FreeAndNil(DatabaseTriggers);
    end;
    { ======================================================================== }

	try
        AvailableTables := nil;
        CurrentTableDefinition := nil;
        TableInsertions := nil;

        ConfigureDataSet(aZConnection,AvailableTables,'SHOW FULL TABLES WHERE TABLE_TYPE <> ''VIEW''');

        with AvailableTables do
        begin
            TableDefinitions := '';
            TableConstraints := '';
            First;

            if aVerboseMode then
                SendStatus(aClient,'Extraindo ' + IntToStr(AvailableTables.RecordCount) + ' Tabelas...');

            while not Eof do
            begin
                if RecNo < RecordCount then
                begin
                    if aVerboseMode then
                        SendStatus(aClient,' |- ' + Fields[0].AsString);
                end
                else
                begin
                    if aVerboseMode then
                        SendStatus(aClient,' \- ' + Fields[0].AsString);
                end;

                { As tabelas abaixo n�o devem ser criadas no cliente }
                if UpperCase(Fields[0].AsString) = 'SEQUENCIAS' then
                begin
                    Next;
                    Continue;
                end;

                if RecNo < RecordCount then
                begin
                	if UpperCase(Fields[0].AsString) = 'DELTA' then
                    begin
                        if aVerboseMode then
    		                SendStatus(aClient,' |   \- DDL (Comando de cria��o)...');
                    end
                    else
                    begin
                        if aVerboseMode then
    		                SendStatus(aClient,' |   |- DDL (Comando de cria��o)...');
                    end;
                end
                else
                begin
                	if UpperCase(Fields[0].AsString) = 'DELTA' then
                    begin
                        if aVerboseMode then
    	                	SendStatus(aClient,'     \- DDL (Comando de cria��o)...');
                    end
                    else
                    begin
                        if aVerboseMode then
    	                	SendStatus(aClient,'     |- DDL (Comando de cria��o)...');
                    end;
                end;

                ConfigureDataSet(aZConnection,CurrentTableDefinition,'SHOW CREATE TABLE ' + FConfigurations.DB_DataBase + '.' + UpperCase(Fields[0].AsString));

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
                begin
                    System.Delete(CurrentDefinition,i,PosEx(';',CurrentDefinition,i) - i);
                end;

                TableDefinitions := TableDefinitions + StringReplace(CurrentDefinition,','#13#10')',#13#10')',[]) + #13#10#13#10;

                { Algumas tabelas tem diferen�as estruturais entre a vers�o do
                servidor e a vers�o dos clientes. Aqui as altera��es estruturais s�o
                feitas para tais tabelas }
                TableDefinitions := TableDefinitions + Format(ADJUSTHEADER,[UpperCase(Fields[0].AsString)]);

                if UpperCase(Fields[0].AsString) = 'DELTA' then
                begin
//                    TableDefinitions := TableDefinitions +
//                    'ALTER TABLE DELTA '#13#10 +
//                    '  CHANGE DT_DATAEHORADAACAO DT_DATAEHORADAACAO DATETIME;'#13#10#13#10;
                	{ Tabela DELTA n�o tem mais diferen�as entre o servidor e
                    o cliente. Nada precisa ser feito. A estrutura foi deixada aqui como refer�ncia }
                    TableDefinitions := TableDefinitions + '# A tabela ' + UpperCase(Fields[0].AsString) + ' n�o precisa de ajustes estruturais!'#13#10#13#10;
                end
                else
                    TableDefinitions := TableDefinitions + '# A tabela ' + UpperCase(Fields[0].AsString) + ' n�o precisa de ajustes estruturais!'#13#10#13#10;

                TableDefinitions := TableDefinitions + Format(INSHEADER,[UpperCase(Fields[0].AsString)]);

                { As tabelas abaixo n�o devem ter seus dados inseridos no cliente }
                if (UpperCase(Fields[0].AsString) <> 'DELTA') and
                (UpperCase(Fields[0].AsString) <> 'ACOESDOSUSUARIOS') then
                begin

                    ConfigureDataSet(aZConnection,TableInsertions,'SELECT * FROM ' + Fields[0].AsString);

                    if TableInsertions.RecordCount > 0 then
                    begin
                        if RecNo < RecordCount then
                        begin
                            if aVerboseMode then
    			                SendStatus(aClient,' |   \- DML (' + IntToStr(TableInsertions.RecordCount) + ' registros)...');
                        end
                        else
                        begin
                            if aVerboseMode then
                            	SendStatus(aClient,'     \- DML (' + IntToStr(TableInsertions.RecordCount) + ' registros)...');
                        end;
                        { QuerySize ser� acumulado at� que ele contenha um
                        valor de no m�ximo MAX_QUERY_SIZE, quando
                        CurrentQuery � conclu�do e juntado � TableDefinitions }
                        QuerySize := 0;
                        CurrentRow := 0;

                        while not TableInsertions.Eof do
                        begin
                            Inc(CurrentRow);

                            ValuesPart := '  (';
                            for i := 0 to Pred(TableInsertions.FieldCount) do
                            begin
                                { Se for o campo de situa��o do registro
                                deveremos colocar em seu lugar a palavra
                                SINCRONIZADO, j� que ser� este o estado dos
                                registros ap�s uma sincroniza��o completa }
                                if TableInsertions.Fields[i].FieldName = 'EN_SITUACAO' then
                                    ValuesPart := ValuesPart + Hex('SINCRONIZADO')
                                else
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
                                        ValuesPart := ValuesPart + Hex(TableInsertions.Fields[i].AsString);
                                end;


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

                            TableInsertions.Next;
                        end;

                        if CurrentRow > 0 then
                            TableDefinitions := TableDefinitions + ';'#13#10 + Format(QUERY_SIZE,[CurrentRow,QuerySize]) + #13#10#13#10;
                    end
                    else
                        TableDefinitions := TableDefinitions + '# A tabela ' + UpperCase(Fields[0].AsString) + ' est� vazia!'#13#10#13#10;

                    TableInsertions.Close;
                end;
                Next;
            end;
            { Complementando o  script com a  cria��o  de tabelas  adicionais
            que n�o existem no servidor }

            TableDefinitions := TableDefinitions + COMPLEMENTARY_TABLES;

            ScriptFinal := StringReplace(ScriptFinal,'<%>DBROUTINES<%>',DBRoutines,[]);
            ScriptFinal := StringReplace(ScriptFinal,'<%>TABLEDEFINITIONS<%>',TableDefinitions,[]);
            ScriptFinal := StringReplace(ScriptFinal,'<%>DBTRIGGERS<%>',DBTriggers,[]);
            ScriptFinal := StringReplace(ScriptFinal,'<%>TABLECONSTRAINTS<%>',TableConstraints,[]);
            ScriptFinal := StringReplace(ScriptFinal,'<%>DBVIEWS<%>',DBViews,[]);
        end;

        SaveTextFile(ScriptFinal,aClient.HomeDir + FTPFIL_SERVER_DATABASE);

        { Comprimindo caso seja necess�rio }
        if aUseCompression then
            ComprimirArquivo(aClient.HomeDir + FTPFIL_SERVER_DATABASE
                            ,aRichEdit
                            ,aOnZLibNotification);

        SendStatus(aClient,'-----------------------------------------------------------------------------------');
        SendStatus(aClient,'SOC: ' + IntToStr(Trunc(FileSize(aClient.HomeDir + FTPFIL_SERVER_DATABASE))));
        SendStatus(aClient,'== MySQLSmartSnapShot: Conte�do gerado com sucesso ================================');
        
    finally
		if Assigned(TableInsertions) then
			TableInsertions.Free;
		if Assigned(CurrentTableDefinition) then
			CurrentTableDefinition.Free;
		if Assigned(AvailableTables) then
			AvailableTables.Free;
	end;
end;{$WARNINGS ON}
{$ENDIF}

{$IFDEF FTPSYNCCLI}
function TFSYGlobals.MD5Get(aFTPClient: TFtpClient; aProgressBar: TProgressBar; aLabelPercentDone: TLabel; aLocalFileName, aRemoteFileName: String; aRichEdit: TRichEdit; aMaxTries: Byte = 5): Boolean;
var
	Count: Byte;
begin
    aFtpClient.LocalFileName := aLocalFileName;
    aFtpClient.HostFileName := aRemoteFileName;
    Count := 0;

    repeat
	    Inc(Count);
    until (ExecuteCmd(aFTPClient,aFtpClient.Get,aRichEdit,'GET',aProgressBar,aLabelPercentDone) and ((not FConfigurations.CheckMD5) or ChecarMd5(aFtpClient,aFtpClient.LocalFileName,Count,'C',aRichEdit))) or not aFTPClient.Connected or (Count > aMaxTries);

    Result := (Count <= aMaxTries);
end;{$ENDIF}

{$IFDEF FTPSYNCCLI}
function TFSYGlobals.MD5Put(aFTPClient: TFtpClient; aProgressBar: TProgressBar; aLabelPercentDone: TLabel; aLocalFileName, aRemoteFileName: String; aRichEdit: TRichEdit; aMaxTries: Byte = 5): Boolean;
var
	Count: Byte;
begin
    aFtpClient.LocalFileName := aLocalFileName;
    aFtpClient.HostFileName := aRemoteFileName;
    Count := 0;

    repeat
	    Inc(Count);
    until (ExecuteCmd(aFTPClient,aFtpClient.Put,aRichEdit,'PUT',aProgressBar,aLabelPercentDone) and ((not FConfigurations.CheckMD5) or ChecarMd5(aFtpClient,aFtpClient.LocalFileName,Count,'S',aRichEdit))) or not aFTPClient.Connected or (Count > aMaxTries);

    Result := (Count <= aMaxTries);
end;{$ENDIF}

{$IFDEF FTPSYNCCLI}
procedure TFSYGlobals.LocalSnapshot(aProgressBar: TProgressBar; aLabelPercentDone: TLabel; aRichEdit: TRichEdit);
var
	Text: String;
  	Connection: TZConnection;
begin
  	Connection := nil;
	try
        ConfigureConnection(Connection,True);
        Text := MySQLFullSnapShot(Connection,aProgressBar,aLabelPercentDone,aRichEdit);

        if not DirectoryExists(FCurrentDir + 'Snapshots') then
            CreateDir(FCurrentDir + 'Snapshots');

        SaveTextFile(Text,FCurrentDir + 'Snapshots\LOCALSNAPSHOT.SQL');
  	finally
  		if Assigned(Connection) then
    		FreeAndNil(Connection);
  	end;
end;{$ENDIF}

{$IFDEF FTPSYNCCLI}{$WARNINGS OFF}
function TFSYGlobals.MySQLFullSnapShot(aZConnection: TZConnection; aProgressBar: TProgressBar; aLabelPercentDone: TLabel; aRichEdit: TRichEdit): String;
const
	DELIMITER = '�';
  	SQLScript =
    '# ============================================================================ #'#13#10 +
    '# SCRIPT DE DEPURA��O LOCAL GERADO EM <%>CURRENTDATEANDTIME<%>                 #'#13#10 +
    '# FTP SYNCRONIZER / CLIENT - VERS�O <%>SYNCRONIZERVERSION<%>                   #'#13#10 +
    '# ============================================================================ #'#13#10#13#10 +
    'DROP DATABASE IF EXISTS BANCODEOBRAS_LOCALDBG;'#13#10#13#10 +
    'CREATE DATABASE BANCODEOBRAS_LOCALDBG DEFAULT CHARACTER SET LATIN1 COLLATE LATIN1_BIN;'#13#10#13#10 +
    'USE BANCODEOBRAS_LOCALDBG;'#13#10#13#10 +

  	'# ============================================================================ #'#13#10 +
  	'# DEFINI��O DE ROTINAS - IN�CIO                                                #'#13#10 +
  	'# ============================================================================ #'#13#10 +
  	'<%>DBROUTINES<%>' +
  	'# ============================================================================ #'#13#10 +
  	'# DEFINI��O DE ROTINAS - FIM                                                   #'#13#10 +
  	'# ============================================================================ #'#13#10#13#10 +

  	'# ============================================================================ #'#13#10 +
    '# DEFINI��O DE TABELAS - IN�CIO                                                #'#13#10 +
    '# ============================================================================ #'#13#10 +
  	'<%>TABLEDEFINITIONS<%>' +
    '# ============================================================================ #'#13#10 +
    '# DEFINI��O DE TABELAS - FIM                                                   #'#13#10 +
    '# ============================================================================ #'#13#10#13#10 +

  	'# ============================================================================ #'#13#10 +
  	'# DEFINI��O DE TRIGGERS - IN�CIO                                               #'#13#10 +
  	'# ============================================================================ #'#13#10 +
  	'<%>DBTRIGGERS<%>' +
  	'# ============================================================================ #'#13#10 +
  	'# DEFINI��O DE TRIGGERS - FIM                                                  #'#13#10 +
  	'# ============================================================================ #'#13#10#13#10 +

    '# ============================================================================ #'#13#10 +
    '# ADI��O DE CONSTRAINTS - IN�CIO                                               #'#13#10 +
    '# ============================================================================ #'#13#10 +
  	'<%>TABLECONSTRAINTS<%>' +
    '# ============================================================================ #'#13#10 +
    '# ADI��O DE CONSTRAINTS - FIM                                                  #'#13#10 +
    '# ============================================================================ #'#13#10#13#10 +

  	'# ============================================================================ #'#13#10 +
  	'# DEFINI��O DE VIEWS - IN�CIO                                                  #'#13#10 +
  	'# ============================================================================ #'#13#10 +
    '<%>DBVIEWS<%>' +
  	'# ============================================================================ #'#13#10 +
  	'# DEFINI��O DE VIEWS - FIM                                                     #'#13#10 +
  	'# ============================================================================ #';

  	INSHEADER =
  	'# == INSER��ES PARA A TABELA %s'#13#10#13#10;

  	INSERT_SCHEMA = 'INSERT INTO '#13#10'  %s'#13#10'VALUES'#13#10;

  	QUERY_SIZE =
  	'# == A INSTRU��O ACIMA POSSUI %u INSER��ES (%u BYTES)';

    TRIGGER_TEMPLATE =
    'DELIMITER %s'#13#10 +
    'CREATE TRIGGER %s %s %s'#13#10 +
    'ON %s FOR EACH ROW'#13#10 +
    '%s; %0:s'#13#10 +
    'DELIMITER ;';

    ROUTINE_TEMPLATE =
    'DELIMITER %s'#13#10 +
    '%s; %0:s'#13#10 +
    'DELIMITER ;';

var
	DatabaseRoutines, CurrentRoutine, DatabaseViews, CurrentView, DatabaseTriggers, CurrentTrigger,
	AvailableTables, CurrentTableDefinition, TableInsertions: TZReadOnlyQuery;
    DBRoutines, DBViews, DBTriggers,
  	TableDefinitions, CurrentDefinition, TableConstraints, CurrentConstraint, ValuesPart, CurrentQuery: String;
  	i, AvailableTablesQtd, QuerySize: Word;
  	CurrentRow, AvailableInsertionsQtd: Cardinal;
  	Version: String;
begin
    Result := StringReplace(SQLScript,'<%>CURRENTDATEANDTIME<%>',FormatDateTime('dd/mm/yyyy "�s" hh:nn:ss',Now) + '  ',[]);

  	Version := TFileInformation.GetInfo(Application.ExeName,'FULLVERSION').AsString;

  	Result := StringReplace(Result,'<%>SYNCRONIZERVERSION<%>',Version + DupeString(' ',24 - Length(Version)),[]);

  	{ == Extra��o de stored routines ========================================= }
    try
    	DatabaseRoutines := nil;
        CurrentRoutine := nil;
        DBRoutines := '';
        ConfigureDataSet(aZConnection,DatabaseRoutines,'SELECT SPECIFIC_NAME, ROUTINE_TYPE FROM information_schema.ROUTINES WHERE ROUTINE_SCHEMA = ' + QuotedStr(FConfigurations.DB_DataBase));
        ShowOnLog('@ Extraindo "stored routines"...',aRichEdit);
        if DatabaseRoutines.RecordCount > 0 then
            while not DatabaseRoutines.Eof do
            begin
            	if DatabaseRoutines.RecNo > 1 then
	                ReplaceLogLastLine(aRichEdit,'@   Extraindo stored routine ' + IntToStr(DatabaseRoutines.RecNo) + '/' + IntToStr(DatabaseRoutines.RecordCount) + '...')
                else
	                ShowOnLog('@   Extraindo stored routine ' + IntToStr(DatabaseRoutines.RecNo) + '/' + IntToStr(DatabaseRoutines.RecordCount) + '...',aRichEdit);

                if UpperCase(DatabaseRoutines.Fields[1].AsString) = 'FUNCTION' then
                    ConfigureDataSet(aZConnection,CurrentRoutine,'SHOW CREATE FUNCTION ' + DatabaseRoutines.Fields[0].AsString)
                else if UpperCase(DatabaseRoutines.Fields[1].AsString) = 'PROCEDURE' then
                    ConfigureDataSet(aZConnection,CurrentRoutine,'SHOW CREATE PROCEDURE ' + DatabaseRoutines.Fields[0].AsString);

                DBRoutines := DBRoutines + Format(ROUTINE_TEMPLATE,[DELIMITER,CurrentRoutine.Fields[2].AsString]);

                if DatabaseRoutines.RecNo < DatabaseRoutines.RecordCount then
	                DBRoutines := DBRoutines + #13#10#13#10
                else
                	DBRoutines := DBRoutines + #13#10;

				ReplaceLogLastLine(aRichEdit,'@   Extraindo stored routine ' + IntToStr(DatabaseRoutines.RecNo) + '/' + IntToStr(DatabaseRoutines.RecordCount) + '... OK!');
                DatabaseRoutines.Next;
            end
        else
        begin
            DBRoutines := #13#10'# A base de dados ' + UpperCase(FConfigurations.DB_DataBase) + ' n�o possui stored routines!'#13#10#13#10;
            ShowOnLog('�   A base de dados n�o possui "stored routines"!',aRichEdit);
        end;
    finally
    	if Assigned(CurrentRoutine) then
        	FreeAndNil(CurrentRoutine);

       	FreeAndNil(DatabaseRoutines);
    end;
  	{ ======================================================================== }

  	{ == Extra��o de vis�es ================================================== }
    try
    	DatabaseViews := nil;
        CurrentView := nil;
        DBViews := '';
        ConfigureDataSet(aZConnection,DatabaseViews,'SHOW FULL TABLES WHERE TABLE_TYPE = ''VIEW''');
        ShowOnLog('@ Extraindo "views"...',aRichEdit);
        if DatabaseViews.RecordCount > 0 then
            while not DatabaseViews.Eof do
            begin
            	if DatabaseViews.RecNo > 1 then
                	ReplaceLogLastLine(aRichEdit,'@   Extraindo view ' + IntToStr(DatabaseViews.RecNo) + '/' + IntToStr(DatabaseViews.RecordCount) + '...')
                else
                	ShowOnLog('@   Extraindo view ' + IntToStr(DatabaseViews.RecNo) + '/' + IntToStr(DatabaseViews.RecordCount) + '...',aRichEdit);

                ConfigureDataSet(aZConnection,CurrentView,'SHOW CREATE VIEW ' + DatabaseViews.Fields[0].AsString);

                DBViews := DBViews + CurrentView.Fields[1].AsString + ';';

                if DatabaseViews.RecNo < DatabaseViews.RecordCount then
	                DBViews := DBViews + #13#10#13#10
                else
                	DBViews := DBViews + #13#10;

                ReplaceLogLastLine(aRichEdit,'@   Extraindo view ' + IntToStr(DatabaseViews.RecNo) + '/' + IntToStr(DatabaseViews.RecordCount) + '... OK!');

                DatabaseViews.Next;
            end
        else
        begin
            DBViews := #13#10'# A base de dados ' + UpperCase(FConfigurations.DB_DataBase) + ' n�o possui views!'#13#10#13#10;
			ShowOnLog('�   A base de dados n�o possui "views"!',aRichEdit);
        end;
    finally
    	if Assigned(CurrentView) then
        	FreeAndNil(CurrentView);

        FreeAndNil(DatabaseViews);
    end;
  	{ ======================================================================== }

    { == Extra��o de triggers ================================================ }
    try
    	DatabaseTriggers := nil;
        CurrentTrigger := nil;
        DBTriggers := '';
	    ConfigureDataSet(aZConnection,DatabaseTriggers,'SHOW TRIGGERS');
		ShowOnLog('@ Extraindo "triggers"...',aRichEdit);
	    if DatabaseTriggers.RecordCount > 0 then
            while not DatabaseTriggers.Eof do
            begin
            	if DatabaseTriggers.RecNo > 1 then
					ReplaceLogLastLine(aRichEdit,'@   Extraindo trigger ' + IntToStr(DatabaseTriggers.RecNo) + '/' + IntToStr(DatabaseTriggers.RecordCount) + '...')
                else
                	ShowOnLog('@   Extraindo trigger ' + IntToStr(DatabaseTriggers.RecNo) + '/' + IntToStr(DatabaseTriggers.RecordCount) + '...',aRichEdit);

                DBTriggers := DBTriggers + Format(TRIGGER_TEMPLATE,[
                    DELIMITER,
                    DatabaseTriggers.Fields[0].AsString,
                    DatabaseTriggers.Fields[4].AsString,
                    DatabaseTriggers.Fields[1].AsString,
                    DatabaseTriggers.Fields[2].AsString,
                    DatabaseTriggers.Fields[3].AsString
                ]);

                if DatabaseTriggers.RecNo < DatabaseTriggers.RecordCount then
	                DBTriggers := DBTriggers + #13#10#13#10
                else
                	DBTriggers := DBTriggers + #13#10;

                ReplaceLogLastLine(aRichEdit,'@   Extraindo trigger ' + IntToStr(DatabaseTriggers.RecNo) + '/' + IntToStr(DatabaseTriggers.RecordCount) + '... OK!');
                DatabaseTriggers.Next;
            end
    	else
        begin
        	DBTriggers := #13#10'# A base de dados ' + UpperCase(FConfigurations.DB_DataBase) + ' n�o possui triggers!'#13#10#13#10;
            ShowOnLog('�   A base de dados n�o possui "triggers"!',aRichEdit);
        end
    finally
    	if Assigned(CurrentTrigger) then
        	FreeAndNil(CurrentTrigger);

        FreeAndNil(DatabaseTriggers);
    end;
    { ======================================================================== }

  	try
  		try
        	AvailableTables := nil;
  			CurrentTableDefinition := nil;
		  	TableInsertions := nil;
    		ConfigureDataSet(aZConnection,AvailableTables,'SHOW FULL TABLES WHERE TABLE_TYPE <> ''VIEW''');

      		with AvailableTables do
      		begin
        		TableDefinitions := '';
        		TableConstraints := '';

                InitializeProgress(aProgressbar,aLabelPercentDone,RecordCount);

        		First;

                AvailableTablesQtd := RecordCount;
                while not Eof do
                begin
                	Application.ProcessMessages;

                    ConfigureDataSet(aZConnection,CurrentTableDefinition,'SHOW CREATE TABLE ' + FConfigurations.DB_DataBase + '.' + UpperCase(Fields[0].AsString));

                    ShowOnLog('@ Extraindo a defini��o e as chaves de "' + UpperCase(Fields[0].AsString) + '" (' + IntToStr(RecNo) + '/' + IntToStr(AvailableTablesQtd) + ') ' + Format('%d%%',[Round(RecNo / AvailableTablesQtd * 100)]),aRichEdit);

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
                    begin
        	            System.Delete(CurrentDefinition,i,PosEx(';',CurrentDefinition,i) - i);
                    end;

                    TableDefinitions := TableDefinitions + StringReplace(CurrentDefinition,','#13#10')',#13#10')',[]) + #13#10#13#10;

                    TableDefinitions := TableDefinitions + Format(INSHEADER,[UpperCase(Fields[0].AsString)]);

                    ConfigureDataSet(aZConnection,TableInsertions,'SELECT * FROM ' + Fields[0].AsString);

                    if TableInsertions.RecordCount > 0 then
                    begin
                        { QuerySize ser� acumulado at� que ele contenha um
                        valor de no m�ximo MAX_QUERY_SIZE, quando
                        CurrentQuery � conclu�do e juntado � TableDefinitions }
                        QuerySize := 0;
                        CurrentRow := 0;
                        AvailableInsertionsQtd := TableInsertions.RecordCount;

                        while not TableInsertions.Eof do
                        begin
                        	Inc(CurrentRow);
                        	Application.ProcessMessages;

                            if TableInsertions.Recno = 1 then
	                            ShowOnLog('@   Extraindo as inser��es para "' + UpperCase(Fields[0].AsString) + '" (' + IntToStr(TableInsertions.RecNo) + '/' + IntToStr(AvailableInsertionsQtd) + ') ' + Format('%d%%',[Round(TableInsertions.RecNo / AvailableInsertionsQtd * 100)]),aRichEdit)
                            else
    	                        ReplaceLogLastLine(aRichEdit,'@   Extraindo as inser��es para "' + UpperCase(Fields[0].AsString) + '" (' + IntToStr(TableInsertions.RecNo) + '/' + IntToStr(AvailableInsertionsQtd) + ') ' + Format('%d%%',[Round(TableInsertions.RecNo / AvailableInsertionsQtd * 100)]));

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
                			        ValuesPart := ValuesPart + QuotedStr(FormatDateTime('yyyy-mm-dd',TableInsertions.Fields[i].AsDateTime))
		                        // Tempo?
        		                else if (TableInsertions.Fields[i].DataType = ftTime) then
                			        ValuesPart := ValuesPart + QuotedStr(FormatDateTime('hh:nn:ss',TableInsertions.Fields[i].AsDateTime))
		                        // Data + Tempo?
		                        else if (TableInsertions.Fields[i].DataType = ftDateTime) then
        			                ValuesPart := ValuesPart + QuotedStr(FormatDateTime('yyyy-mm-dd hh:nn:ss',TableInsertions.Fields[i].AsDateTime))
                        		// Bin�rio, String ou qualquer outra coisa?
		                        else
        			                ValuesPart := ValuesPart + Hex(TableInsertions.Fields[i].AsString);

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

                            TableInsertions.Next;
                        end;

                        if CurrentRow > 0 then
                        	TableDefinitions := TableDefinitions + ';'#13#10 + Format(QUERY_SIZE,[CurrentRow,QuerySize]) + #13#10#13#10;
                    end
                    else
                    begin
                    	TableDefinitions := TableDefinitions + '# A tabela ' + UpperCase(Fields[0].AsString) + ' est� vazia!'#13#10#13#10;
                        ShowOnLog('�   A tabela ' + UpperCase(Fields[0].AsString) + ' est� vazia. N�o h� nada a ser extra�do...',aRichEdit);
                    end;

                    TableInsertions.Close;

                    IncreaseProgress(aProgressbar,aLabelPercentDone);

                    Next;
                end;

        		Result := StringReplace(Result,'<%>DBROUTINES<%>',DBRoutines,[]);
				Result := StringReplace(Result,'<%>TABLEDEFINITIONS<%>',TableDefinitions,[]);
                Result := StringReplace(Result,'<%>DBTRIGGERS<%>',DBTriggers,[]);
				Result := StringReplace(Result,'<%>TABLECONSTRAINTS<%>',TableConstraints,[]);
                Result := StringReplace(Result,'<%>DBVIEWS<%>',DBViews,[]);
            end;
        except
        	raise; { Passando a vez...}
        end;
    finally
    	if Assigned(TableInsertions) then
    		FreeAndNil(TableInsertions);
        if Assigned(CurrentTableDefinition) then
            FreeAndNil(CurrentTableDefinition);
        if Assigned(AvailableTables) then
            FreeAndNil(AvailableTables);
	end;
end;{$WARNINGS ON}{$ENDIF}

procedure TFSYGlobals.SaveConfigurations;
var
	f: file of TConfigurations;
  	FileHandle: Integer;
begin
  if not FileExists(FCurrentDir + ARQUIVO_DE_CONFIGURACOES) then
  begin
    FileHandle := FileCreate(FCurrentDir + ARQUIVO_DE_CONFIGURACOES); //Cria um novo arquivo
    FileClose(FileHandle); //Fecha o arquivo para que seja poss�vel usa-lo mais abaixo
  end;

  AssignFile(F,FCurrentDir + ARQUIVO_DE_CONFIGURACOES);
  FileMode := fmOpenWrite; //Abrir para leitura apenas
  reset(f);
  Write(f,FConfigurations);
  CloseFile(f);
end;

procedure TFSYGlobals.SaveTextFile(aText: String; const aFileName: TFileName);
begin
    TXXXDataModule.SaveTextFile(aText,aFileName);
end;

function TFSYGlobals.LoadTextFile(const aFileName: TFileName): String;
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

class procedure TFSYGlobals.SetLabelDescriptionValue(const aLabelDescription, aLabelValue: TLabel; const aValue: String; const aSpacing: Byte = 2);
begin
	aLabelValue.Alignment := taRightJustify;
    aLabelValue.Caption := aValue;
//    aLabelValue.Top := aLabelDescription.Top;
  //  aLabelValue.Left := aLabelDescription.Left + aLabelDescription.Width - aLabelValue.Width;
    aLabelDescription.Width := aLabelValue.Left - aLabelDescription.Left - aSpacing;
end;

procedure TFSYGlobals.SplitSQLScript(const aZConnection: TZConnection; aRichEdit: TRichEdit; var aScriptParts: TScriptParts; const aSQLScriptFile: TFileName = ''; const aSQLScriptText: String = ''; const aForeignKeysCheck: Boolean = True);
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
            if Assigned(aRichEdit) then
	            ShowOnLog('� Preprocessando script. Isso pode demorar um pouco...',aRichEdit);

            ParamCheck := False;
    	    DelimiterType := dtSetTerm;
            Delimiter := 'DELIMITER';

            if Trim(aSQLScriptFile) <> '' then
	            LoadFromFile(aSQLScriptFile)
            else
            	Script.Text := aSQLScriptText;

            if not aForeignKeysCheck then
            	Script.Text := 'DELIMITER ;'#13#10' SET FOREIGN_KEY_CHECKS = 0;'#13#10 + Processor.Script.Text + #13#10'DELIMITER ;'#13#10'SET FOREIGN_KEY_CHECKS = 1;'
            else
	            Script.Text := 'DELIMITER ;'#13#10 + Script.Text + #13#10'DELIMITER ;';

	        Connection := aZConnection;

        	Parse;

            if Assigned(aRichEdit) then
            begin
	            ShowOnLog('� ' + IntToStr(StatementCount) + ' parte(s) detectada(s)',aRichEdit);
    	        ShowOnLog('� Iniciando a carga do objeto de manipula��o do script com ' + IntToStr(StatementCount) + ' parte(s)...',aRichEdit);
            end;

            for i := 0 to Pred(StatementCount) do
            begin
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
            end;

            if Assigned(aRichEdit) then
	            ShowOnLog('� O objeto de manipula��o foi carregado com ' + IntToStr(aScriptParts.Count) + ' bloco(s) �til(eis)',aRichEdit);

        end;
    finally
    	if Assigned(Processor) then
        	FreeAndNil(Processor);

        Screen.Cursor := crDefault;
    end;
end;

function TFSYGlobals.DatabaseCheckSum(const aZConnection: TZConnection;
                                            aHomeDir: TFileName;
                                            aOnGetChecksum: TOnGetChecksum): String;
begin
    Result := TXXXDataModule.MySQLDatabaseCheckSum(aZConnection
                                                  ,FConfigurations.DB_Database
                                                  ,['DELTA' { ambos}
                                                   ,'SEQUENCIAS' { servidor }
                                                   ,'SINCRONIZACOES' { cliente }
                                                   ,'REGISTROSEXCLUIDOS'] { cliente - depreciada }
                                                   ,['EN_SITUACAO']
                                                  ,aHomeDir
                                                  ,aOnGetChecksum);
end;

{$IFDEF FTPSYNCCLI}
function TFSYGlobals.DatabaseCheckSumCompare(aFTPClient: TFTPClient;
                                             aZConnection: TZConnection;
                                             aProgressBar: TProgressBar;
                                             aLabelPercentDone: TLabel;
                                             aRichEdit: TRichEdit;
                                             aOnGetChecksum: TOnGetChecksum): Boolean;
begin
    Result := False;
    ShowOnLog('� Comparando os bancos de dados local e remoto.',aRichEdit);
    ShowOnLog('� Gerando checksum remoto. Isto leva menos de 1 minuto. Queira aguardar...',aRichEdit);
    if MD5Get(aFTPClient,aProgressBar,aLabelPercentDone,FFTPDirectory + '\' + FTPFIL_DBCHECKSUM,FTPSCR_DBCHECKSUM,aRichEdit,5) then
        if FileExists(FFTPDirectory + '\' + FTPFIL_DBCHECKSUM) and (Trunc(FileSize(FFTPDirectory + '\' + FTPFIL_DBCHECKSUM)) > 0) then
        begin
            ShowOnLog('� Gerando checksum local. Isto leva menos de 1 minuto. Queira aguardar...',aRichEdit);
            { TODO -oCarlos Feitoza -cD�VIDA : Ser� que posso por isso aqui? }
            //Application.ProcessMessages;
	        Result := DatabaseCheckSum(aZConnection,FFTPDirectory,aOnGetChecksum) = LoadTextFile(FFTPDirectory + '\' + FTPFIL_DBCHECKSUM);
        end;
end;{$ENDIF}

//function TFSYGlobals.MySQLDatabaseCheckSum(const aZConnection: TZConnection;
//                                           const aTablesToIgnore
//                                               , aFieldsToIgnore: array of String;
//                                                 aHomeDir: TFileName{$IFDEF FTPSYNCSER}; aClient: TFtpCtrlSocket{$ENDIF}): String;
//var
//	TablesList, TableData: TZReadOnlyQuery;
//    i: Byte;
//	TableRow, TableDataStr: String;
//    TableCheckSum: String;
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
//    try
//    	{ Obtendo a lista de tabelas }
//        ConfigureDataSet(aZConnection,TablesList,'SHOW FULL TABLES WHERE TABLE_TYPE <> ''VIEW''');
//        try
//            AssignFile(TF,aHomeDir + 'TMPDBCRC.DAT');
//            FileMode := fmOpenWrite;
//            Rewrite(TF);
//
//            TablesList.First;
//            while not TablesList.Eof do
//            begin
//                if not IsIgnoredTable(TablesList.Fields[0].AsString) then
//                begin
//                    ConfigureDataSet(aZConnection,TableData,'SELECT * FROM ' + FConfigurations.DB_Database + '.' + TablesList.Fields[0].AsString);
//
//                    TableDataStr := '';
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
//                        TableDataStr := TableDataStr + TableRow;
//
//                        TableData.Next;
//                    end;
//                    TableCheckSum := GetStringCheckSum(Trim(TableDataStr),[haMd5]);
//                    WriteLn(TF,TableCheckSum);
//                    {$IFDEF FTPSYNCSER}
//                    SendStatus(aClient,'Tabela: "' + TablesList.Fields[0].AsString + '" (' + IntToStr(TablesList.RecNo) + '/' + IntToStr(TablesList.RecordCount) + ') | MD5: ' + TableCheckSum);
//                    {$ENDIF}
//                end
//                {$IFDEF FTPSYNCSER}
//                else
//	                SendStatus(aClient,'Tabela: "' + TablesList.Fields[0].AsString + '" (' + IntToStr(TablesList.RecNo) + '/' + IntToStr(TablesList.RecordCount) + ') | IGNORADA...');
//                {$ELSE}
//                ;
//                {$ENDIF}
//
//                TablesList.Next;
//            end;
//        finally
//        	CloseFile(TF);
//        end;
//		{ Obtendo o MD5 do arquivo que cont�m os CheckSums da database }
//        with TStringList.Create do
//            try
//            	LoadFromFile(aHomeDir + 'TMPDBCRC.DAT');
//                Result := GetStringCheckSum(Trim(Text),[haMd5]);
//            	DeleteFile(PChar(aHomeDir + 'TMPDBCRC.DAT'));
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

function TFSYGlobals.GetClientLastSyncDateAndTime(Client: TConnectedClient): TDateTime;
var
	FOTDT: file of TDateTime;
  	LastSync: TDateTime;
begin
  	LastSync := 0;
  	{ Se  n�o  houver  arquivo  subtende-se  que  a ultima  sincroniza��o  nunca
  	ocorreu }
  	if FileExists(Client.HomeDir + FTPFIL_LASTSYNCHRONIZEDON) then
    	try
      		AssignFile(FOTDT,Client.HomeDir + FTPFIL_LASTSYNCHRONIZEDON);
      		FileMode := fmOpenRead;
      		Reset(FOTDT);
      		Read(FOTDT,LastSync);
    	finally
      		CloseFile(FOTDT);
    	end;
  	Result := LastSync;
end;

//procedure TNewGlobals.GetFileVersionInformation(aFileName: TFileName; out aVersionIformation: TVSFixedFileInfo);
//const
//	DEFAULT_LANG_ID = $0409;
//  TRANSLATION_INFO = '\VarFileInfo\Translation';
//type
//  TTranslationPair = packed record
//    Lang,
//    CharSet: word;
//  end;
//  PTranslationIDList = ^TTranslationIDList;
//  TTranslationIDList = array[0..MAXINT div SizeOf(TTranslationPair) - 1] of TTranslationPair;
//
//var
//  InternalFileName: array [0..255] of Char;
//  VersionInfoSize, Dummy: Cardinal;
//  VersionInfo: PChar;
//  FixedInfoData: PVSFixedFileInfo;
//  QueryLen: Cardinal;
//begin
//	ZeroMemory(@InternalFileName,256);
//  ZeroMemory(@aVersionIformation,SizeOf(TVSFixedFileInfo));
//	StrPCopy(InternalFileName,aFileName);
//
// 	VersionInfoSize := GetFileVersionInfoSize(InternalFileName, Dummy);
//  if VersionInfoSize > 0 then
//  begin
//    GetMem(VersionInfo, VersionInfoSize);
//    GetFileVersionInfo(InternalFileName, Dummy, VersionInfoSize, VersionInfo);
//
//    VerQueryValue(VersionInfo, '\', Pointer(FixedInfoData), QueryLen);
//    aVersionIformation.dwSignature := FixedInfoData^.dwSignature;
//    aVersionIformation.dwStrucVersion := FixedInfoData^.dwStrucVersion;
//    aVersionIformation.dwFileVersionMS := FixedInfoData^.dwFileVersionMS;
//    aVersionIformation.dwFileVersionLS := FixedInfoData^.dwFileVersionLS;
//    aVersionIformation.dwProductVersionMS := FixedInfoData^.dwProductVersionMS;
//    aVersionIformation.dwProductVersionLS := FixedInfoData^.dwProductVersionLS;
//    aVersionIformation.dwFileFlagsMask := FixedInfoData^.dwFileFlagsMask;
//    aVersionIformation.dwFileFlags := FixedInfoData^.dwFileFlags;
//    aVersionIformation.dwFileOS := FixedInfoData^.dwFileOS;
//    aVersionIformation.dwFileType := FixedInfoData^.dwFileType;
//    aVersionIformation.dwFileSubtype := FixedInfoData^.dwFileSubtype;
//    aVersionIformation.dwFileDateMS := FixedInfoData^.dwFileDateMS;
//    aVersionIformation.dwFileDateLS := FixedInfoData^.dwFileDateLS;
//  end;
//end;

function TFSYGlobals.GetFileCheckSum(const aFileName: TFileName; aHashAlgorithms: THashAlgorithms; aFinalHashAlgorithm: THashAlgorithm = haIgnore): String;
begin
	Result := GetStringCheckSum(LoadTextFile(aFileName),aHashAlgorithms,aFinalHashAlgorithm);
end;

function TFSYGlobals.GetStringCheckSum(const aInputString: String;
                                             aHashAlgorithms: THashAlgorithms;
                                             aFinalHashAlgorithm: THashAlgorithm = haIgnore): String;
begin
    Result := TXXXDataModule.GetStringCheckSum(aInputString,aHashAlgorithms,aFinalHashAlgorithm);
end;

//function TFSYGlobals.GetStringCheckSum(const aInputString: String; aHashAlgorithms: THashAlgorithms; aFinalHashAlgorithm: THashAlgorithm = haIgnore): String;
//var
//    HashDigest: array of Byte;
//    TempString: String;
//    i: Word;
//begin
//	TempString := aInputString;
//
//	if haSha512 in aHashAlgorithms then
//   		with TDCP_sha512.Create(nil) do
//            try
//            	SetLength(HashDigest,0);
//                Init;
//                Update(TempString[1],Length(TempString));
//                SetLength(HashDigest,HashSize div 8);
//                Final(HashDigest[0]);
//
//      			Result := '';
//      			for i := 0 to Pred(Length(HashDigest)) do  // convert it into a hex string
//        			Result := Result + IntToHex(HashDigest[i],2);
//
//                TempString := Result;
//            finally
//            	Free;
//            end;
//
//	if haSha384 in aHashAlgorithms then
//   		with TDCP_sha384.Create(nil) do
//            try
//            	SetLength(HashDigest,0);
//                Init;
//                Update(TempString[1],Length(TempString));
//                SetLength(HashDigest,HashSize div 8);
//                Final(HashDigest[0]);
//
//      			Result := '';
//      			for i := 0 to Pred(Length(HashDigest)) do  // convert it into a hex string
//        			Result := Result + IntToHex(HashDigest[i],2);
//
//                TempString := Result;
//            finally
//            	Free;
//            end;
//
//	if haSha256 in aHashAlgorithms then
//   		with TDCP_sha256.Create(nil) do
//            try
//            	SetLength(HashDigest,0);
//                Init;
//                Update(TempString[1],Length(TempString));
//                SetLength(HashDigest,HashSize div 8);
//                Final(HashDigest[0]);
//
//      			Result := '';
//      			for i := 0 to Pred(Length(HashDigest)) do  // convert it into a hex string
//        			Result := Result + IntToHex(HashDigest[i],2);
//
//                TempString := Result;
//            finally
//            	Free;
//            end;
//
//	if haSha1 in aHashAlgorithms then
//   		with TDCP_sha1.Create(nil) do
//            try
//            	SetLength(HashDigest,0);
//                Init;
//                Update(TempString[1],Length(TempString));
//                SetLength(HashDigest,HashSize div 8);
//                Final(HashDigest[0]);
//
//      			Result := '';
//      			for i := 0 to Pred(Length(HashDigest)) do  // convert it into a hex string
//        			Result := Result + IntToHex(HashDigest[i],2);
//
//                TempString := Result;
//            finally
//            	Free;
//            end;
//
//	if haRipemd160 in aHashAlgorithms then
//   		with TDCP_ripemd160.Create(nil) do
//            try
//            	SetLength(HashDigest,0);
//                Init;
//                Update(TempString[1],Length(TempString));
//                SetLength(HashDigest,HashSize div 8);
//                Final(HashDigest[0]);
//
//      			Result := '';
//      			for i := 0 to Pred(Length(HashDigest)) do  // convert it into a hex string
//        			Result := Result + IntToHex(HashDigest[i],2);
//
//                TempString := Result;
//            finally
//            	Free;
//            end;
//
//	if haRipemd128 in aHashAlgorithms then
//   		with TDCP_ripemd128.Create(nil) do
//            try
//            	SetLength(HashDigest,0);
//                Init;
//                Update(TempString[1],Length(TempString));
//                SetLength(HashDigest,HashSize div 8);
//                Final(HashDigest[0]);
//
//      			Result := '';
//      			for i := 0 to Pred(Length(HashDigest)) do  // convert it into a hex string
//        			Result := Result + IntToHex(HashDigest[i],2);
//
//                TempString := Result;
//            finally
//            	Free;
//            end;
//
//	if haMd5 in aHashAlgorithms then
//   		with TDCP_md5.Create(nil) do
//            try
//            	SetLength(HashDigest,0);
//                Init;
//                Update(TempString[1],Length(TempString));
//                SetLength(HashDigest,HashSize div 8);
//                Final(HashDigest[0]);
//
//      			Result := '';
//      			for i := 0 to Pred(Length(HashDigest)) do  // convert it into a hex string
//        			Result := Result + IntToHex(HashDigest[i],2);
//
//                TempString := Result;
//            finally
//            	Free;
//            end;
//
//	if haMd4 in aHashAlgorithms then
//   		with TDCP_md4.Create(nil) do
//            try
//            	SetLength(HashDigest,0);
//                Init;
//                Update(TempString[1],Length(TempString));
//                SetLength(HashDigest,HashSize div 8);
//                Final(HashDigest[0]);
//
//      			Result := '';
//      			for i := 0 to Pred(Length(HashDigest)) do  // convert it into a hex string
//        			Result := Result + IntToHex(HashDigest[i],2);
//
//                TempString := Result;
//            finally
//            	Free;
//            end;
//
//	if haHaval in aHashAlgorithms then
//   		with TDCP_haval.Create(nil) do
//            try
//            	SetLength(HashDigest,0);
//                Init;
//                Update(TempString[1],Length(TempString));
//                SetLength(HashDigest,HashSize div 8);
//                Final(HashDigest[0]);
//
//      			Result := '';
//      			for i := 0 to Pred(Length(HashDigest)) do  // convert it into a hex string
//        			Result := Result + IntToHex(HashDigest[i],2);
//
//                TempString := Result;
//            finally
//            	Free;
//            end;
//
//	if haTiger in aHashAlgorithms then
//   		with TDCP_tiger.Create(nil) do
//            try
//            	SetLength(HashDigest,0);
//                Init;
//                Update(TempString[1],Length(TempString));
//                SetLength(HashDigest,HashSize div 8);
//                Final(HashDigest[0]);
//
//      			Result := '';
//      			for i := 0 to Pred(Length(HashDigest)) do  // convert it into a hex string
//        			Result := Result + IntToHex(HashDigest[i],2);
//
//                TempString := Result;
//            finally
//            	Free;
//            end;
//
//	if (SizeOf(aHashAlgorithms) > 1) and (aFinalHashAlgorithm <> haIgnore) then
//    	Result := GetStringCheckSum(Result,[aFinalHashAlgorithm]);
//end;

{$IFDEF FTPSYNCCLI}
procedure TFSYGlobals.GetTemporaryData(aFTPClient: TFtpClient; aZConnection: TZConnection; aProgressBar: TProgressBar; aLabelPercentDone: TLabel; var aBusy: Boolean; aRichEdit: TRichEdit);
var
	i: Byte;
    Success: Boolean;
    SessionClosedEvent: TSessionClosed;
begin
    SessionClosedEvent := nil;
    Success := False;
	try
		aBusy := True;
		try
            { Definindo eventos e outras propriedades do componente ====== }
            SessionClosedEvent := aFTPClient.OnSessionClosed;
            aFTPClient.OnSessionClosed := nil;

            { ============================================================ }
            { Conectando-se... =========================================== }
            ConnectToServer(aFTPClient,Configurations.FT_HostName,Configurations.FT_PortNumb,aRichEdit);
            { ============================================================ }
            { Autenticando-se... ========================================= }
            Authenticate(aFTPClient,aZConnection,'RobotNoDB' + Configurations.FT_UserName,'My Name Is DO, BDO!' + Configurations.FT_PassWord,True,True,aBusy,aRichEdit);
            { ============================================================ }
            { Obtendo a lista de arquivos tempor�rios... ================= }
            ShowOnLog('� Obtendo lista de arquivos tempor�rios...',aRichEdit);
            aFTPClient.LocalFileName := FFTPDirectory + '\' + FTPFIL_TEMPFILENAMES;
            aFTPClient.HostFileName := FTPSCR_TEMPFILENAMES;


            if not ExecuteCmd(aFTPClient,aFTPClient.Get,aRichEdit,'GET',aProgressBar,aLabelPercentDone) then
                raise Exception.Create('N�o foi poss�vel obter a lista de arquivos tempor�rios do servidor');
            { ============================================================ }
            { Obtendo os arquivos tempor�rios... ========================= }
            ShowOnLog('� Obtendo os arquivos tempor�rios...',aRichEdit);
            with TStringList.Create do
                try
                    LoadFromFile(aFTPClient.LocalFileName);
                    CommaText := Trim(Text);

                    if not DirectoryExists(FFTPDirectory + '\REMOTETEMP') then
                        CreateDir(FFTPDirectory + '\REMOTETEMP');

                    for i := 0 to Pred(Count) do
                    begin
                        ShowOnLog('� Obtendo arquivo "' + Strings[i] + '"...',aRichEdit);
                        aFTPClient.LocalFileName := FFTPDirectory + '\REMOTETEMP\' + Strings[i];
                        aFTPClient.HostFileName := Strings[i];

                        if not ExecuteCmd(aFTPClient,aFTPClient.Get,aRichEdit,'GET',aProgressBar,aLabelPercentDone) then
                            raise Exception.Create('N�o foi poss�vel obter o arquivo "' + Strings[i] + '" a partir do servidor');
                    end;
                finally
                    Free;
                end;
            { ============================================================ }
            { Se chegar aqui tudo deu certo }
            Success := True;

		except
			on E: Exception do
				AbortEverything(aFTPClient,E.Message,aBusy,aRichEdit);
		end;
	finally
    	ExecuteCmd(aFTPClient,aFTPClient.Quit,aRichEdit,'QUIT',aProgressBar,aLabelPercentDone);
        aFTPClient.OnSessionClosed := SessionClosedEvent;

        if Success then
	        MessageBox(Application.Handle,PChar('Todos os dados remotos foram obtidos e salvos localmente na pasta "' + FFTPDirectory + '\REMOTETEMP"'),'Dados remotos obidos',MB_ICONWARNING);

		aBusy := False;
    end;

end;{$ENDIF}

procedure TFSYGlobals.LoadDeltaFile(aDeltaFile: TFileName; out aSynchronizationFile: TSynchronizationFile; const aUsePrimaryKeyValue: Boolean);
begin
	if not FileExists(aDeltaFile) then
    	raise Exception.Create('O arquivo "' + aDeltaFile + '" n�o existe');

  	aSynchronizationFile := TSynchronizationFile.Create(nil,aUsePrimaryKeyValue);

	aSynchronizationFile.LoadFromBinaryFile(aDeltaFile);
end;

procedure TFSYGlobals.ComprimirArquivo(const aNomeDoArquivo: TFileName;
                                       const aRichEdit: TRichEdit;
                                             OnNotification: TZlibNotification);
begin
    { Comprime em um arquivo tempor�rio }
    TXXXDataModule.CompressFile(aNomeDoArquivo
                               ,aNomeDoArquivo + '.C'
                               ,OnNotification);

    { Copia o arquivo tempor�rio no arquivo original }
    if not CopyFile(PChar(aNomeDoArquivo + '.C')
                   ,PChar(aNomeDoArquivo)
                   ,False) then
        raise Exception.Create('N�o foi poss�vel substituir o arquivo de dados original (' + ExtractFileName(aNomeDoArquivo) + ') por sua vers�o comprimida')
    else
        DeleteFile(aNomeDoArquivo + '.C');
end;

procedure TFSYGlobals.DescomprimirArquivo(const aNomeDoArquivo: TFileName;
                                          const aRichEdit: TRichEdit;
                                                OnNotification: TZlibNotification);
begin
    { Descomprime em um arquivo tempor�rio }
    TXXXDataModule.DecompressFile(aNomeDoArquivo
                                 ,aNomeDoArquivo + '.D'
                                 ,OnNotification);

    { Copia o arquivo tempor�rio no arquivo original }
    if not CopyFile(PChar(aNomeDoArquivo + '.D')
                   ,PChar(aNomeDoArquivo)
                   ,False) then
        raise Exception.Create('N�o foi poss�vel substituir o arquivo de dados original (' + ExtractFileName(aNomeDoArquivo) + ') por sua vers�o descomprimida')
    else
        DeleteFile(aNomeDoArquivo + '.D');
end;

{$IFDEF FTPSYNCCLI}
procedure TFSYGlobals.SynchronizeByDelta(    aFTPClient: TFtpClient;
                                         var aZConnection: TZConnection;
                                             aProgressBar: TProgressBar;
                                             aLabelPercentDone: TLabel;
                                             aForeignKeyChecks: Boolean;
                                         var aBusy: Boolean;
                                             aSimulation: Boolean;
                                             aRichEdit: TRichEdit;
                                             aDoCommitOnError: Boolean;
                                             aSaveGeneratedScript: Boolean;
                                             aOnZLibNotification: TZLibNotification);
var
    DBCheckSumOK: Boolean;
    RetrSessionParameters: TRetrSessionParameters;
begin
    aFTPClient.Passive := FConfigurations.FT_PassiveMode;
    ConnectToServer(aFTPClient,FConfigurations.FT_HostName,FConfigurations.FT_PortNumb,aRichEdit);
    Authenticate(aFTPClient,aZConnection,FConfigurations.FT_UserName,FConfigurations.FT_Password,False,True,aBusy,aRichEdit);

    ZeroMemory(@RetrSessionParameters,SizeOf(TRetrSessionParameters));
    RetrSessionParameters.VerboseMode := FConfigurations.VerboseMode;
    RetrSessionParameters.UseCompression := FConfigurations.UseCompression;

    if SendRetrSessionParameters(RetrSessionParameters,aFTPClient,aRichEdit,aProgressBar,aLabelPercentDone) then
    begin
        if not DatabaseCheckSumCompare(aFTPClient,aZConnection,aProgressBar,aLabelPercentDone,aRichEdit,nil) then
        begin
            if SendLastSyncDateAndTime(aFTPClient,aZConnection,aProgressBar,aLabelPercentDone,aRichEdit) then
            begin
                DeleteFile(PChar(FFTPDirectory + '\' + FTPFIL_CLIENT_DELTA));
                { TODO -oCarlos Feitoza -cESCLARECIMENTO : A opera��o abaixo
                nunca gera um arquivo vazio propriamente dito, mas sim um
                arquivo de delta sem dados, mas com a estrutura correta }
                GenerateDeltaFile(aZConnection
                                 ,FFTPDirectory + '\' + FTPFIL_CLIENT_DELTA
                                 ,aRichEdit
                                 ,True
                                 ,'TRUE'
                                 ,False
                                 ,aProgressBar
                                 ,aLabelPercentDone);

                { Comprimindo o arquivo de dados caso esta op��o esteja ativa }
                if FConfigurations.UseCompression then
                    ComprimirArquivo(FFTPDirectory + '\' + FTPFIL_CLIENT_DELTA
                                    ,aRichEdit
                                    ,aOnZLibNotification);

                { TODO -oCarlos Feitoza -cEXPLICA��O : Agora, um arquivo sempre ser�
                gerado, mesmo n�o tendo informa��es �teis. Isso ser� corretamente
                processado no servidor }
    //            { Se houver dados a serem enviados... }
    //            if FileExists(FFTPDirectory + '\' + FTPFIL_CLIENT_DELTA) then
    //            begin
                    { Se conseguiu enviar o script para o servidor ... }
                    if MD5Put(aFTPClient,aProgressBar,aLabelPercentDone,FFTPDirectory + '\' + FTPFIL_CLIENT_DELTA,FTPFIL_CLIENT_DELTA,aRichEdit,5) then
                    begin
                        { Se e conseguir executar o script no servidor retornar�
                        SERVER_DELTA.DAT }
                        if MD5Get(aFTPClient,aProgressBar,aLabelPercentDone,FFTPDirectory + '\' + FTPFIL_SERVER_DELTA,FTPSCR_SERVER_DELTA,aRichEdit,5) then
                        begin
                            { Se obtiver como resposta um arquivo (vazio ou n�o) ... }
                            if FileExists(FFTPDirectory + '\' + FTPFIL_SERVER_DELTA) then
                            begin
                                { Se houver dados no arquivo, processa-os! }
                                if FileSize(FFTPDirectory + '\' + FTPFIL_SERVER_DELTA) > 0 then
                                begin
                                    { Descomprimindo o arquivo de dados caso esta op��o esteja ativa }
                                    if FConfigurations.UseCompression then
                                        DescomprimirArquivo(FFTPDirectory + '\' + FTPFIL_SERVER_DELTA
                                                           ,aRichEdit
                                                           ,aOnZLibNotification);

                                    { Se executar o script recebido com sucesso ... }
    //                                ExecuteDeltaFile(aZConnection^,FFTPDirectory + '\' + FTPFIL_SERVER_DELTA,aForeignKeyChecks);
                                    ExecuteDeltaFile(aZConnection
                                                    ,aRichEdit
                                                    ,True
                                                    ,FFTPDirectory + '\' + FTPFIL_SERVER_DELTA
                                                    ,IfThen(aSaveGeneratedScript
                                                           ,FFTPDirectory + '\' + ChangeFileExt(FTPFIL_SERVER_DELTA,'.sql')
                                                           ,'')
                                                    ,aForeignKeyChecks);

                                    { Se nosso banco de dados local for exatamente
                                    igual ao do servidor ... }
                                    DBCheckSumOK := DatabaseCheckSumCompare(aFTPClient,aZConnection,aProgressBar,aLabelPercentDone,aRichEdit,nil);
                                    if aDoCommitOnError or DBCheckSumOK then
                                    begin
                                        { Se conseguir limpar todas as informa��es
                                        de delta e se consegue receber a data e hora
                                        atuais do servidor }
                                        if ClearDeltaAndSaveLastSyncDateTime(aFTPClient,aZConnection,aProgressBar,aLabelPercentDone,True,aRichEdit) then
                                        begin
                                            ShowOnLog('� A data e a hora da sincroniza��o foram salvas e o delta local foi limpo',aRichEdit);
                                            ShowOnLog('� Desconectando...',aRichEdit);
                                            ConfirmEverything(aFTPClient,aZConnection,aProgressBar,aLabelPercentDone,aSimulation,aRichEdit);

                                            if not DBCheckSumOK then
                                                MessageBox(Application.Handle,'A data e a hora da sincroniza��o foram salvas e o delta local foi limpo, mas os bancos continuam diferentes. Favor verificar!','Sincroniza��o conclu�da...',MB_ICONERROR)
                                            else
                                                MessageBox(Application.Handle,'A data e a hora da sincroniza��o foram salvas e o delta local foi limpo. Agora, o banco de dados local e o banco de dados remoto s�o id�nticos.','Sincroniza��o conclu�dca com sucesso!',MB_ICONINFORMATION);
                                        end
                                        else
                                            raise Exception.Create('N�o foi poss�vel limpar o delta e/ou salvar a data e a hora da �ltima sincroniza��o');
                                    end
                                    else
                                        raise Exception.Create('Ainda existem diferen�as entre o banco de dados local e o remoto. A sincroniza��o falhou');
                                end
                                { Se n�o houver dados no arquivo, continua! }
                                else
                                begin
                                    ShowOnLog('� O arquivo ' + FTPFIL_SERVER_DELTA + ' est� vazio. Verificando diferen�as...',aRichEdit);
                                    { Se nosso banco de dados local for
                                    exatamente igual ao do servidor ... }
                                    DBCheckSumOK := DatabaseCheckSumCompare(aFTPClient,aZConnection,aProgressBar,aLabelPercentDone,aRichEdit,nil);
                                    if aDoCommitOnError or DBCheckSumOK then
                                    begin
                                        { Se  conseguir  limpar todas  as
                                        informa��es  de  delta  e  se consegue
                                        receber a data e hora atuais do servidor }
                                        if ClearDeltaAndSaveLastSyncDateTime(aFTPClient,aZConnection,aProgressBar,aLabelPercentDone,True,aRichEdit) then
                                        begin
                                            ShowOnLog('� A data e a hora da sincroniza��o foram salvas e o delta local foi limpo',aRichEdit);
                                            ShowOnLog('� Desconectando...',aRichEdit);
                                            ConfirmEverything(aFTPClient,aZConnection,aProgressBar,aLabelPercentDone,aSimulation,aRichEdit);

                                            if not DBCheckSumOK then
                                                MessageBox(Application.Handle,'A data e a hora da sincroniza��o foram salvas e o delta local foi limpo, mas os bancos continuam diferentes. Favor verificar!','Sincroniza��o conclu�da...',MB_ICONERROR)
                                            else
                                                MessageBox(Application.Handle,'A data e a hora da sincroniza��o foram salvas e o delta local foi limpo. Agora, o banco de dados local e o banco de dados remoto s�o id�nticos.','Sincroniza��o conclu�dca com sucesso!',MB_ICONINFORMATION);
                                        end
                                        else
                                            raise Exception.Create('N�o foi poss�vel limpar o delta e/ou salvar a data e a hora da �ltima sincroniza��o');
                                    end
                                    else
                                        raise Exception.Create('Ainda existem diferen�as entre o banco de dados local e o remoto. A sincroniza��o falhou');
                                end;
                            end
                            else
                                raise Exception.Create('O arquivo de sincroniza��o (' + FTPFIL_SERVER_DELTA + ') n�o foi obtido do servidor');
                        end
                        else
                            raise Exception.Create('N�o foi poss�vel obter o script de sincroniza��o ' + FTPFIL_SERVER_DELTA + ' do servidor');
                    end
                    else
                        raise Exception.Create('N�o foi poss�vel enviar o script de sincroniza��o ' + FTPFIL_CLIENT_DELTA + ' ao servidor');
    //            end
    //            { Se n�o houver dados a serem enviados apenas sincroniza obtendo
    //            as altera��es de outros usu�rios }
    //            else
    //            begin
    //                { N�o � necess�rio verificar a tabela de auditoria pois n�s n�o
    //                alteramos os dados e portanto n�o fizemos nada de errado }
    //
    //                { Se e conseguir executar o script no servidor ... }
    //                if MD5Get(aFTPClient,aProgressBar,aLabelPercentDone,FFTPDirectory + '\' + FTPFIL_NEWACTIONS,FTPSCR_NEWACTIONS,aRichEdit) then
    //                begin
    //                    { Se obtiver como resposta um arquivo vazio ou n�o ... }
    //                    if FileExists(FFTPDirectory + '\' + FTPFIL_NEWACTIONS) then
    //                    begin
    //                        { Se houver algo no arquivo a ser processado, processa! }
    //                        if FileSize(FFTPDirectory + '\' + FTPFIL_NEWACTIONS) > 0 then
    //                        begin
    //                            { Se executar o script recebido com sucesso ... }
    //                            ExecuteDeltaFile(aZConnection,aRichEdit,True,FFTPDirectory + '\' + FTPFIL_NEWACTIONS);
    //
    //                            { Se nosso banco de dados local for exatamente
    //                            igual ao do servidor ... }
    //                            if DatabaseCheckSumCompare(aFTPClient,aZConnection,aProgressBar,aLabelPercentDone,aRichEdit) then
    //                            begin
    //                                { Se  conseguir  limpar todas  as
    //                                informa��es  de  delta  e  se consegue
    //                                receber a data e hora atuais do servidor }
    //                                if ClearDeltaAndSaveLastSyncDateTime(aFTPClient,aZConnection,aProgressBar,aLabelPercentDone,True,aRichEdit) then
    //                                begin
    //                                    ShowOnLog('� A data e a hora da sincroniza��o foram salvas e o delta local foi limpo',aRichEdit);
    //                                    ShowOnLog('� Desconectando...',aRichEdit);
    //                                    ConfirmEverything(aFTPClient,aZConnection,aProgressBar,aLabelPercentDone,aSimulation,aRichEdit);
    //                                    MessageBox(Application.Handle,'A data e a hora da sincroniza��o foram salvas e o delta local foi limpo. Agora, o banco de dados local e o banco de dados remoto s�o id�nticos.','Sincroniza��o conclu�dca com sucesso!',MB_ICONINFORMATION);
    //                                end
    //                                else
    //                                    raise Exception.Create('N�o foi poss�vel limpar o delta e/ou salvar a data e a hora da �ltima sincroniza��o');
    //                            end
    //                            else
    //                                raise Exception.Create('Ainda existem diferen�as entre o banco de dados local e o remoto. A sincroniza��o falhou');
    //                        end
    //                        { Se o arquivo estiver vazio, pode ser que a
    //                        sincroniza��o tenha sido realizada nas tabelas de
    //                        auditoria. Neste caso verifica os bancos e termina}
    //                        else
    //                        begin
    //                            ShowOnLog('� O arquivo ' + FTPFIL_SERVER_DELTA + ' est� vazio. Verificando diferen�as...',aRichEdit);
    //                            { Se nosso banco de dados local for exatamente
    //                            igual ao do servidor ... }
    //                            if DatabaseCheckSumCompare(aFTPClient,aZConnection,aProgressBar,aLabelPercentDone,aRichEdit) then
    //                            begin
    //                                { Se  conseguir  limpar todas  as
    //                                informa��es  de  delta  e  se consegue
    //                                receber a data e hora atuais do servidor }
    //                                if ClearDeltaAndSaveLastSyncDateTime(aFTPClient,aZConnection,aProgressBar,aLabelPercentDone,True,aRichEdit) then
    //                                begin
    //                                    ShowOnLog('� A data e a hora da sincroniza��o foram salvas e o delta local foi limpo',aRichEdit);
    //                                    ShowOnLog('� Desconectando...',aRichEdit);
    //                                    ConfirmEverything(aFTPClient,aZConnection,aProgressBar,aLabelPercentDone,aSimulation,aRichEdit);
    //                                    MessageBox(Application.Handle,'A data e a hora da sincroniza��o foram salvas e o delta local foi limpo. Agora, o banco de dados local e o banco de dados remoto s�o id�nticos.','Sincroniza��o conclu�dca com sucesso!',MB_ICONINFORMATION);
    //                                end
    //                                else
    //                                    raise Exception.Create('N�o foi poss�vel limpar o delta e/ou salvar a data e a hora da �ltima sincroniza��o');
    //                            end
    //                            else
    //                                raise Exception.Create('Ainda existem diferen�as entre o banco de dados local e o remoto. A sincroniza��o falhou');
    //                        end;
    //                    end
    //                    else
    //                        raise Exception.Create('O arquivo de sincroniza��o (' + FTPFIL_NEWACTIONS + ') n�o foi obtido do servidor');
    //                end
    //                else
    //                    raise Exception.Create('N�o foi poss�vel obter o script de sincroniza��o ' + FTPFIL_NEWACTIONS + ' do servidor.');
    //            end;
            end
            else
                raise Exception.Create('N�o foi poss�vel enviar a data da �ltima sincroniza��o');
        end
        else
        begin
            { Neste ponto os dois bancos de dados s�o id�nticos e nada foi feito em
            nenhum deles, por isso devemos finalizar aqui a transa��o de forma que
            ao executar o procedure "ClearDeltaAndSaveLastSyncDateTime" as opera��es
            sejam realizadas. Usamos RollBack para garantir que nada foi realizado }
            aZConnection.Rollback;
            ClearDeltaAndSaveLastSyncDateTime(aFTPClient,aZConnection,aProgressBar,aLabelPercentDone,False,aRichEdit);
            ShowOnLog('� O banco de dados local e o banco de dados remoto s�o id�nticos',aRichEdit);
            ShowOnLog('� A sincroniza��o n�o � necess�ria',aRichEdit);
            ShowOnLog('� O DELTA local foi limpo para garantir a consist�ncia das sincroniza��es futuras',aRichEdit);
            ShowOnLog('� Desconectando...',aRichEdit);
            ExecuteCmd(aFTPClient,aFTPClient.Quit,aRichEdit,'QUIT');
            MessageBox(Application.Handle,'A sincroniza��o n�o � necess�ria. O banco de dados local e o banco de dados remoto s�o id�nticos.','Sincroniza��o desnecess�ria',MB_ICONINFORMATION);
        end;
    end
    else
        raise Exception.Create('N�o foi poss�vel enviar os par�metros da sess�o de dados');
end;
{$ENDIF}

procedure TFSYGlobals.WaitFor(const aSeconds: Byte; const aUseProcessMessages: Boolean = True);
begin
    TXXXDataModule.WaitFor(aSeconds,aUseProcessMessages);
end;

{$IFDEF FTPSYNCSER}
function TFSYGlobals.GetTempFileNames(const aTempDir: TFileName): String;
var
    CurrentDirectory: String;
    SearchRec: TSearchRec;
   	DosError: integer;
begin
	try
    	Result := '';
        CurrentDirectory := GetCurrentDir;
        ChDir(aTempDir);

	    DosError := FindFirst('*.*', 0, SearchRec);
	    while DosError = 0 do
    	begin
        	try
            	if (SearchRec.name <> '.') and (SearchRec.name <> '..') then
                begin
                    if Result = '' then
                        Result := SearchRec.Name
                    else
                        Result := Result + ',' + SearchRec.Name;
                end;
            except
            	on EOutOfResources do
                	raise Exception.Create('A quantidade de arquivos localizados excede o limite de recursos do seu sistema. Favor limitar seu crit�rio de busca escolhendo diret�rio(s) de n�vel mais interno.');
            end;
            DosError := FindNext(SearchRec);
        end;
    finally
    	ChDir(CurrentDirectory);
    end;
end;{$ENDIF}

{$IFDEF FTPSYNCCLI}
procedure TFSYGlobals.AddUniqueIndex(aConnection: TZConnection; aTableName, aIndexName, aFieldValue: String; aRichEdit: TRichEdit);
begin
	ShowOnLog('�   "' + UpperCase(aIndexName) + '" � tabela "' + UpperCase(aTableName) + '"...',aRichEdit);
	ExecuteQuery(aConnection,'ALTER TABLE ' + UpperCase(aTableName) + ' ADD UNIQUE INDEX ' + UpperCase(aIndexName) + '(' + aFieldValue + ')');
    Application.ProcessMessages;
end;{$ENDIF}

{$IFDEF FTPSYNCCLI}
procedure TFSYGlobals.Authenticate(aFTPClient: TFtpClient; var aZConnection: TZConnection; aUserName, aPassWord: String; aAutomatic: Boolean; aUseDataBaseName: Boolean; var aBusy: Boolean; aRichEdit: TRichEdit);
var
	ErrorText: String;
begin
	if aAutomatic then
    	ErrorText := 'N�o foi poss�vel autenticar a conex�o autom�tica. Favor entrar em contato com o desenvolvedor informando este erro.'
    else
    	ErrorText := 'N�o foi poss�vel autenticar sua conex�o. Verifique suas informa��es de logon nas configura��es.';

    aFtpClient.UserName := aUserName;
    aFtpClient.PassWord := aPassWord;

    if not ExecuteCmd(aFTPClient,aFTPClient.User,aRichEdit,'USER') then
        raise Exception.Create(ErrorText);

    if not ExecuteCmd(aFTPClient,aFTPClient.Pass,aRichEdit,'PASS') then
        raise Exception.Create(ErrorText);

    CheckVersion(aFTPClient,aRichEdit);

    { Chegando aqui, conseguiu! }
    ClearDirectory(FFTPDirectory);

	try
 		ShowOnLog('� Iniciando conex�o transacional com o banco de dados...',aRichEdit);
		aZConnection := nil;
		ConfigureConnection(aZConnection,aUseDataBaseName);
        { Configura outros par�metros }
        if aZConnection.Connected then
        begin
//            veja o efeito do autocommit e use em outros locais
            aZConnection.Tag := 1; // O status inicial � para dar RollBack
            aZConnection.AutoCommit := True;
            aZConnection.StartTransaction;
	        MySQLSetVariable(aZConnection ,'SQL_QUOTE_SHOW_CREATE',0);
            MySQLSetDBUserVariable(aZConnection,'SYNCHRONIZING',True);
            MySQLSetDBUserVariable(aZConnection,'SERVERSIDE',False);
            MySQLSetDBUserVariable(aZConnection,'ADJUSTINGDB',False);
        end;
	except
		on E: Exception do
        	AbortEverything(aFTPClient,E.Message,aBusy,aRichEdit);
	end;
end;{$ENDIF}

{$IFDEF FTPSYNCCLI}
procedure TFSYGlobals.DropUniqueIndex(aConnection: TZConnection; aTableName, aIndexName: String; aRichEdit: TRichEdit);
begin
	ShowOnLog('�   "' + UpperCase(aIndexName) + '" da tabela "' + UpperCase(aTableName) + '"...',aRichEdit);
	ExecuteQuery(aConnection,'ALTER TABLE ' + UpperCase(aTableName) + ' DROP INDEX ' + UpperCase(aIndexName));
    Application.ProcessMessages;
end;{$ENDIF}

{$IFDEF FTPSYNCCLI}
procedure TFSYGlobals.DropAllUniqueIndexes(aRichEdit: TRichEdit);
var
	AdjustConnection: TZConnection;
begin
	AdjustConnection := nil;
	try
       	ConfigureConnection(AdjustConnection,FConfigurations.DB_Protocol,FConfigurations.DB_HostAddr,FConfigurations.DB_UserName,FConfigurations.DB_Password,FConfigurations.DB_Database,FConfigurations.DB_PortNumb);
        ShowOnLog('� Removendo chaves �nicas...',aRichEdit);
        DropUniqueIndex(AdjustConnection,'EQUIPAMENTOS','EQP_VA_MODELO_UI',aRichEdit);
        DropUniqueIndex(AdjustConnection,'SITUACOES','SIT_VA_DESCRICAO_UI',aRichEdit);
        DropUniqueIndex(AdjustConnection,'TIPOS','TIP_VA_DESCRICAO_UI',aRichEdit);
        DropUniqueIndex(AdjustConnection,'INSTALADORES','INS_VA_NOME_UI',aRichEdit);
        DropUniqueIndex(AdjustConnection,'REGIOES','REG_VA_REGIAO_UI',aRichEdit);
        DropUniqueIndex(AdjustConnection,'REGIOES','REG_CH_PREFIXODAPROPOSTA_UI',aRichEdit);
        DropUniqueIndex(AdjustConnection,'PROJETISTAS','PRJ_VA_NOME_UI',aRichEdit);
        DropUniqueIndex(AdjustConnection,'ENTIDADESDOSISTEMA','EDS_VA_NOME_UI',aRichEdit);
        DropUniqueIndex(AdjustConnection,'USUARIOS','USU_VA_LOGIN_UI',aRichEdit);
        DropUniqueIndex(AdjustConnection,'USUARIOS','USU_VA_EMAIL_UI',aRichEdit);
        DropUniqueIndex(AdjustConnection,'UNIDADES','UNI_VA_ABREVIATURA_UI',aRichEdit);
        DropUniqueIndex(AdjustConnection,'UNIDADES','UNI_VA_DESCRICAO_UI',aRichEdit);
        DropUniqueIndex(AdjustConnection,'GRUPOS','GRU_VA_NOME_UI',aRichEdit);
        DropUniqueIndex(AdjustConnection,'FAMILIAS','FAM_VA_DESCRICAO_UI',aRichEdit);
        DropUniqueIndex(AdjustConnection,'REGIOESDOSUSUARIOS','RDU_SM_USUARIOS_ID_TI_REGIOES_ID_UI',aRichEdit);
        DropUniqueIndex(AdjustConnection,'GRUPOSDOSUSUARIOS','GDU_TI_GRUPOS_ID_SM_USUARIOS_ID_UI',aRichEdit);
        DropUniqueIndex(AdjustConnection,'PERMISSOESDOSGRUPOS','PDG_IN_ENTIDADESDOSISTEMA_ID_TI_GRUPOS_UI',aRichEdit);
        DropUniqueIndex(AdjustConnection,'PERMISSOESDOSUSUARIOS','PDU_IN_ENTIDADESDOSISTEMA_ID_SM_USUARIOS_ID_UI',aRichEdit);
        DropUniqueIndex(AdjustConnection,'PROPOSTAS','PRO_SM_CODIGO_YR_ANO_UI',aRichEdit);
        DropUniqueIndex(AdjustConnection,'JUSTIFICATIVASDASOBRAS','JDO_IN_OBRAS_ID_TI_JUSTIFICATIVAS_ID_UI',aRichEdit);

        if FConfigurations.FT_CommandDelay > 0 then
        begin
            ShowOnLog('~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~',aRichEdit);
            ShowOnLog('Aguardando ' + IntToStr(FConfigurations.FT_CommandDelay) + ' segundo(s) antes da pr�xima a��o...',aRichEdit);
            ShowOnLog('~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~',aRichEdit);
            WaitFor(FConfigurations.FT_CommandDelay);
        end;
    finally
    	if Assigned(AdjustConnection) then
	        AdjustConnection.Free;
    end;
end;{$ENDIF}

{$IFDEF FTPSYNCCLI}
procedure TFSYGlobals.AbortEverything(aFTPClient: TFtpClient; aErrorMessage: String; var aBusy: Boolean; aRichEdit: TRichEdit);
begin
	{ Chamar Quit aqui desconecta do servidor enquanto tanto l� como aqui a
  	propriedade Tag est� configurada como 1, o que consequentemente instrui o
  	programa a executar um rollback na conex�o ativa }
    if Pos('---',aErrorMessage) = 1 then
    	ShowOnLog('! ' + aErrorMessage,aRichEdit)
    else
    	ShowOnLog('! ' + PutLineBreaks(aErrorMessage,93),aRichEdit);

    aBusy := False;

    if aFTPClient.Connected then
    	ExecuteCmd(aFTPClient,aFTPClient.Quit,aRichEdit,'QUIT');
end;{$ENDIF}

{$IFDEF FTPSYNCCLI}
procedure TFSYGlobals.AddAllUniqueIndexes(aRichEdit: TRichEdit);
var
	AdjustConnection: TZConnection;
begin
	AdjustConnection := nil;
	try
       	ConfigureConnection(AdjustConnection,FConfigurations.DB_Protocol,FConfigurations.DB_HostAddr,FConfigurations.DB_UserName,FConfigurations.DB_Password,FConfigurations.DB_Database,FConfigurations.DB_PortNumb);
        ShowOnLog('� Adicionando chaves �nicas...',aRichEdit);
        AddUniqueIndex(AdjustConnection,'EQUIPAMENTOS','EQP_VA_MODELO_UI','VA_MODELO',aRichEdit);
        AddUniqueIndex(AdjustConnection,'SITUACOES','SIT_VA_DESCRICAO_UI','VA_DESCRICAO',aRichEdit);
        AddUniqueIndex(AdjustConnection,'TIPOS','TIP_VA_DESCRICAO_UI','VA_DESCRICAO',aRichEdit);
        AddUniqueIndex(AdjustConnection,'INSTALADORES','INS_VA_NOME_UI','VA_NOME',aRichEdit);
        AddUniqueIndex(AdjustConnection,'REGIOES','REG_VA_REGIAO_UI','VA_REGIAO',aRichEdit);
        AddUniqueIndex(AdjustConnection,'REGIOES','REG_CH_PREFIXODAPROPOSTA_UI','CH_PREFIXODAPROPOSTA',aRichEdit);
        AddUniqueIndex(AdjustConnection,'PROJETISTAS','PRJ_VA_NOME_UI','VA_NOME',aRichEdit);
        AddUniqueIndex(AdjustConnection,'ENTIDADESDOSISTEMA','EDS_VA_NOME_UI','VA_NOME',aRichEdit);
        AddUniqueIndex(AdjustConnection,'USUARIOS','USU_VA_LOGIN_UI','VA_LOGIN',aRichEdit);
        AddUniqueIndex(AdjustConnection,'USUARIOS','USU_VA_EMAIL_UI','VA_EMAIL',aRichEdit);
        AddUniqueIndex(AdjustConnection,'UNIDADES','UNI_VA_ABREVIATURA_UI','VA_ABREVIATURA',aRichEdit);
        AddUniqueIndex(AdjustConnection,'UNIDADES','UNI_VA_DESCRICAO_UI','VA_DESCRICAO',aRichEdit);
        AddUniqueIndex(AdjustConnection,'GRUPOS','GRU_VA_NOME_UI','VA_NOME',aRichEdit);
        AddUniqueIndex(AdjustConnection,'FAMILIAS','FAM_VA_DESCRICAO_UI','VA_DESCRICAO',aRichEdit);
        AddUniqueIndex(AdjustConnection,'REGIOESDOSUSUARIOS','RDU_SM_USUARIOS_ID_TI_REGIOES_ID_UI','SM_USUARIOS_ID,TI_REGIOES_ID',aRichEdit);
        AddUniqueIndex(AdjustConnection,'GRUPOSDOSUSUARIOS','GDU_TI_GRUPOS_ID_SM_USUARIOS_ID_UI','TI_GRUPOS_ID, SM_USUARIOS_ID',aRichEdit);
        AddUniqueIndex(AdjustConnection,'PERMISSOESDOSGRUPOS','PDG_IN_ENTIDADESDOSISTEMA_ID_TI_GRUPOS_UI','IN_ENTIDADESDOSISTEMA_ID, TI_GRUPOS_ID',aRichEdit);
        AddUniqueIndex(AdjustConnection,'PERMISSOESDOSUSUARIOS','PDU_IN_ENTIDADESDOSISTEMA_ID_SM_USUARIOS_ID_UI','IN_ENTIDADESDOSISTEMA_ID, SM_USUARIOS_ID',aRichEdit);
        AddUniqueIndex(AdjustConnection,'PROPOSTAS','PRO_SM_CODIGO_YR_ANO_UI','SM_CODIGO, YR_ANO',aRichEdit);
        AddUniqueIndex(AdjustConnection,'JUSTIFICATIVASDASOBRAS','JDO_IN_OBRAS_ID_TI_JUSTIFICATIVAS_ID_UI','IN_OBRAS_ID, TI_JUSTIFICATIVAS_ID',aRichEdit);
    finally
    	if Assigned(AdjustConnection) then
	        AdjustConnection.Free;
    end;

end;{$ENDIF}

{$IFDEF FTPSYNCCLI}
function TFSYGlobals.SendRetrSessionParameters(const aRetrSessionParameters: TRetrSessionParameters;
                                               const aFTPClient: TFtpClient;
                                               const aRichEdit: TRichEdit;
                                                     aProgressBar: TProgressBar;
                                                     aLabelPercentDone: TLabel): Boolean;
var
	f: file of TRetrSessionParameters;
begin
	try
        ShowOnLog('� Enviando par�metros de transfer�ncia de dados...',aRichEdit);
      	AssignFile(f,FFTPDirectory + '\'+ FTPFIL_PARAMETERS);
      	FileMode := fmOpenWrite;
      	Rewrite(f);

      	Write(f,aRetrSessionParameters);
  	finally
		CloseFile(f);
        Result := MD5Put(aFTPClient,aProgressBar,aLabelPercentDone,FFTPDirectory + '\' + FTPFIL_PARAMETERS,FTPFIL_PARAMETERS,aRichEdit,5)
  	end;
end;{$ENDIF}

{$IFDEF FTPSYNCCLI}{$IFDEF DEVELOPING}
procedure TFSYGlobals.TimeOutTest(const aFTPClient: TFtpClient;
                                    var aZConnection: TZConnection;
                                    var aBusy: Boolean;
                                  const aRichEdit: TRichEdit;
                                        aProgressBar: TProgressBar;
                                        aLabelPercentDone: TLabel);
var
    RetrSessionParameters: TRetrSessionParameters;
    TimeOut: String;
begin
    aFTPClient.Passive := FConfigurations.FT_PassiveMode;

	ConnectToServer(aFTPClient,FConfigurations.FT_HostName,FConfigurations.FT_PortNumb,aRichEdit);
	Authenticate(aFTPClient,aZConnection,FConfigurations.FT_UserName,FConfigurations.FT_Password,False,False,aBusy,aRichEdit);

    CmdLineParamValue('TT',TimeOut);
    ZeroMemory(@RetrSessionParameters,SizeOf(TRetrSessionParameters));
    RetrSessionParameters.CustIntParm := StrToIntDef(TimeOut,20);

    if SendRetrSessionParameters(RetrSessionParameters,aFTPClient,aRichEdit,aProgressBar,aLabelPercentDone) then
    begin
        if MD5Get(aFTPClient,aProgressBar,aLabelPercentDone,FFTPDirectory + '\' + FTPFIL_TIMEOUTTEST,FTPSCR_TIMEOUTTEST,aRichEdit,5) then
        begin
            if FileExists(FFTPDirectory + '\' + FTPFIL_TIMEOUTTEST) and (Trunc(FileSize(fFTPDirectory + '\' + FTPFIL_TIMEOUTTEST)) > 0) then
            begin
                ShowOnLog('� Teste conclu�do!',aRichEdit);
                ShowOnLog('� Desconectando...',aRichEdit);

                if aFTPClient.Connected then
                    ExecuteCmd(aFTPClient,aFTPClient.Quit,aRichEdit,'QUIT');

                MessageBox(Application.Handle,'Teste de Timeout conclu�do','Teste conclu�do!',MB_ICONINFORMATION);
            end
            else
                raise Exception.Create('O arquivo de teste (' + FTPFIL_TIMEOUTTEST + ') n�o foi obtido do servidor, ou ele est� vazio');
        end
        else
          raise Exception.Create('N�o foi poss�vel obter o arquivo de teste ' + FTPFIL_TIMEOUTTEST + ' do servidor');
    end
    else
        raise Exception.Create('N�o foi poss�vel enviar os par�metros do script de teste ' + FTPFIL_TIMEOUTTEST + ' do servidor');
end;{$ENDIF}{$ENDIF}

{$IFDEF FTPSYNCCLI}{$IFDEF DEVELOPING}
procedure TFSYGlobals.ContentSizeTest(const aFTPClient: TFtpClient;
                                        var aZConnection: TZConnection;
                                        var aBusy: Boolean;
                                      const aRichEdit: TRichEdit;
                                            aProgressBar: TProgressBar;
                                            aLabelPercentDone: TLabel);
var
    RetrSessionParameters: TRetrSessionParameters;
    ContentSize: String;
begin
    aFTPClient.Passive := FConfigurations.FT_PassiveMode;

	ConnectToServer(aFTPClient,FConfigurations.FT_HostName,FConfigurations.FT_PortNumb,aRichEdit);
	Authenticate(aFTPClient,aZConnection,FConfigurations.FT_UserName,FConfigurations.FT_Password,False,False,aBusy,aRichEdit);

    CmdLineParamValue('CS',ContentSize);
    ZeroMemory(@RetrSessionParameters,SizeOf(TRetrSessionParameters));
    RetrSessionParameters.CustIntParm := StrToIntDef(ContentSize,32768);

    if SendRetrSessionParameters(RetrSessionParameters,aFTPClient,aRichEdit,aProgressBar,aLabelPercentDone) then
    begin
        if MD5Get(aFTPClient,aProgressBar,aLabelPercentDone,FFTPDirectory + '\' + FTPFIL_CONTENTSIZETEST,FTPSCR_CONTENTSIZETEST,aRichEdit,5) then
        begin
            if FileExists(FFTPDirectory + '\' + FTPFIL_CONTENTSIZETEST) and (Trunc(FileSize(fFTPDirectory + '\' + FTPFIL_CONTENTSIZETEST)) > 0) then
            begin
                ShowOnLog('� Teste conclu�do!',aRichEdit);
                ShowOnLog('� Desconectando...',aRichEdit);

                if aFTPClient.Connected then
                    ExecuteCmd(aFTPClient,aFTPClient.Quit,aRichEdit,'QUIT');

                MessageBox(Application.Handle,'Teste de tamanho de conte�do conclu�do','Teste conclu�do!',MB_ICONINFORMATION);
            end
            else
                raise Exception.Create('O arquivo de teste (' + FTPFIL_CONTENTSIZETEST + ') n�o foi obtido do servidor, ou ele est� vazio');
        end
        else
          raise Exception.Create('N�o foi poss�vel obter o arquivo de teste ' + FTPFIL_CONTENTSIZETEST + ' do servidor');
    end
    else
        raise Exception.Create('N�o foi poss�vel enviar os par�metros do script de teste ' + FTPFIL_CONTENTSIZETEST + ' do servidor');
end;{$ENDIF}{$ENDIF}

{$IFDEF FTPSYNCCLI}
procedure TFSYGlobals.SynchronizeFull(    aFTPClient: TFtpClient;
                                      var aZConnection: TZConnection;
                                          aProgressBar: TProgressBar;
                                          aLabelPercentDone: TLabel;
                                          aProgressBarCurrent: TProgressBar;
                                          aProgressBarOverall: TProgressBar;
                                          aLabelCurrentDescription: TLabel;
                                          aLabelOverallDescription: TLabel;
                                          aLabelCurrentValue: TLabel;
                                          aLabelOverallValue: TLabel;
                                      var aBusy: Boolean;
                                          aRichEdit: TRichEdit;
                                          aOnZLibNotification: TZLibNotification);

procedure ReplaceIntoFile(Filename: TFileName; OldPattern, NewPattern: String);
begin
	with TStringList.Create do
    	try
        	LoadFromFile(Filename);
            Text := StringReplace(Text,OldPattern,NewPattern,[rfReplaceAll]);
            SaveToFile(FileName);
        finally
        	Free;
        end;
end;

var
    RetrSessionParameters: TRetrSessionParameters;
begin
    aFTPClient.Passive := FConfigurations.FT_PassiveMode;

	ConnectToServer(aFTPClient,FConfigurations.FT_HostName,FConfigurations.FT_PortNumb,aRichEdit);
	Authenticate(aFTPClient,aZConnection,FConfigurations.FT_UserName,FConfigurations.FT_Password,False,False,aBusy,aRichEdit);

    ZeroMemory(@RetrSessionParameters,SizeOf(TRetrSessionParameters));
    RetrSessionParameters.VerboseMode := FConfigurations.VerboseMode;
    RetrSessionParameters.UseCompression := FConfigurations.UseCompression;

    if SendRetrSessionParameters(RetrSessionParameters,aFTPClient,aRichEdit,aProgressBar,aLabelPercentDone) then
    begin
        { Se e conseguir executar o script no servidor ... }
        if MD5Get(aFTPClient,aProgressBar,aLabelPercentDone,FFTPDirectory + '\' + FTPFIL_SERVER_DATABASE,FTPSCR_SERVER_DATABASE,aRichEdit,5) then
        begin
            { Se obtiver como resposta um arquivo n�o vazio ... }
            if FileExists(FFTPDirectory + '\' + FTPFIL_SERVER_DATABASE) and (Trunc(FileSize(fFTPDirectory + '\' + FTPFIL_SERVER_DATABASE)) > 0) then
            begin
                { Descomprimindo o arquivo de dados caso esta op��o esteja ativa }
                if FConfigurations.UseCompression then
                    DescomprimirArquivo(FFTPDirectory + '\' + FTPFIL_SERVER_DATABASE
                                       ,aRichEdit
                                       ,aOnZLibNotification);

                { Substituindo o nome do banco de dados }
                ReplaceIntoFile(FFTPDirectory + '\' + FTPFIL_SERVER_DATABASE,'<%>DATABASENAME<%>',UpperCase(FConfigurations.DB_DataBase));

                try
                    TPanel(aProgressBarCurrent.Parent).Show;
                    Application.ProcessMessages;
                    MySQLExecuteSQLScript(aZConnection
                                         ,aRichEdit
                                         ,FFTPDirectory + '\' + FTPFIL_SERVER_DATABASE
                                         ,''
                                         ,True
                                         ,aProgressBarCurrent
                                         ,aProgressBarOverall
                                         ,aLabelCurrentDescription
                                         ,aLabelOverallDescription
                                         ,aLabelCurrentValue
                                         ,aLabelOverallValue);
                finally
                    WaitFor(1);
                    TPanel(aProgressBarCurrent.Parent).Hide;
                end;

                { Se nosso banco de dados local for exatamente igual ao do servidor ... }
                if DatabaseCheckSumCompare(aFTPClient,aZConnection,aProgressBar,aLabelPercentDone,aRichEdit,nil) then
                begin
                    ClearDeltaAndSaveLastSyncDateTime(aFTPClient,aZConnection,aProgressBar,aLabelPercentDone,True,aRichEdit);
                    ShowOnLog('� A data e a hora da sincroniza��o foram salvas e o delta local foi limpo',aRichEdit);
                    ShowOnLog('� Desconectando...',aRichEdit);
                    ConfirmEverything(aFTPClient,aZConnection,aProgressBar,aLabelPercentDone,False,aRichEdit);
                    MessageBox(Application.Handle,'A data e a hora da sincroniza��o foram salvas e o delta local foi limpo. Agora, o banco de dados local e o banco de dados remoto s�o id�nticos.','Sincroniza��o conclu�dca com sucesso!',MB_ICONINFORMATION);
                end
                else
                    raise Exception.Create('Ainda existem diferen�as entre o banco de dados local e o remoto. A sincroniza��o falhou');
            end
            else
                raise Exception.Create('O arquivo de sincroniza��o (' + FTPFIL_SERVER_DATABASE + ') n�o foi obtido do servidor, ou ele est� vazio');
        end
        else
          raise Exception.Create('N�o foi poss�vel obter o script de sincroniza��o ' + FTPFIL_SERVER_DATABASE + ' do servidor');
    end
    else
        raise Exception.Create('N�o foi poss�vel enviar os par�metros da sess�o de dados');
end;{$ENDIF}

{$IFDEF FTPSYNCCLI}
procedure TFSYGlobals.TakeSnapshot(    aFTPClient: TFtpClient;
                                       aZConnection: TZConnection;
                                       aMode: Byte;
                                       aProgressBar: TProgressBar;
                                       aLabelPercentDone: TLabel;
                                   var aBusy: Boolean;
                                       aRichEdit: TRichEdit;
                                       aOnZLibNotification: TZLibNotification);
var
    RetrSessionParameters: TRetrSessionParameters;
begin
    aFTPClient.Passive := FConfigurations.FT_PassiveMode;

    case aMode of
        0,3: begin
            ShowOnLog('� Iniciando gera��o do snapshot local...',aRichEdit);
            LocalSnapshot(aProgressBar,aLabelPercentDone,aRichEdit);
            ShowOnLog('� Snapshot local gerado com sucesso!',aRichEdit);
            if aMode = 0 then
                MessageBox(Application.Handle,'O snapshot local foi gerado com sucesso!','Snapshot conclu�do',MB_ICONINFORMATION);
        end;
        1,4: begin
            ShowOnLog('� Iniciando gera��o do snapshot remoto...',aRichEdit);

            aFTPClient.Passive := FConfigurations.FT_PassiveMode;
            
            ConnectToServer(aFTPClient,FConfigurations.FT_HostName,FConfigurations.FT_PortNumb,aRichEdit);
            Authenticate(aFTPClient,aZConnection,FConfigurations.FT_UserName,FConfigurations.FT_Password,False,True,aBusy,aRichEdit);

            ZeroMemory(@RetrSessionParameters,SizeOf(TRetrSessionParameters));
            RetrSessionParameters.VerboseMode := FConfigurations.VerboseMode;
            RetrSessionParameters.UseCompression := FConfigurations.UseCompression;

            if SendRetrSessionParameters(RetrSessionParameters,aFTPClient,aRichEdit,aProgressBar,aLabelPercentDone) then
            begin
                { Se e conseguir executar o script no servidor ... }
                if MD5Get(aFTPClient,aProgressBar,aLabelPercentDone,FFTPDirectory + '\' + FTPFIL_REMOTESNAPSHOT,FTPSCR_REMOTESNAPSHOT,aRichEdit,5) then
                begin
                    { Se obtiver como resposta um arquivo n�o vazio ... }
                    if FileExists(FFTPDirectory + '\' + FTPFIL_REMOTESNAPSHOT) and (FileSize(FFTPDirectory + '\' + FTPFIL_REMOTESNAPSHOT) > 0) then
                    begin

                        if FConfigurations.UseCompression then
                            DescomprimirArquivo(FFTPDirectory + '\' + FTPFIL_REMOTESNAPSHOT
                                               ,aRichEdit
                                               ,aOnZLibNotification);

                        if not DirectoryExists(FCurrentDir + 'Snapshots') then
                            CreateDir(FCurrentDir + 'Snapshots');

                        { Salvando o script recebido no diret�rio correto }
                        CopyFile(PChar(FFTPDirectory + '\' + FTPFIL_REMOTESNAPSHOT),PChar(FCurrentDir + 'Snapshots\REMOTESNAPSHOT.SQL'),False);
                        DeleteFile(PChar(FFTPDirectory + '\' + FTPFIL_REMOTESNAPSHOT));

                        ShowOnLog('� Snapshot remoto gerado e salvo localmente com sucesso!',aRichEdit);
                        if aMode = 1 then
                            MessageBox(Application.Handle,'Snapshot remoto gerado e salvo localmente com sucesso!','Snapshot conclu�do',MB_ICONINFORMATION);
                    end
                    else
                        raise Exception.Create('O arquivo de snapshot (' + FTPFIL_REMOTESNAPSHOT + ') est� vazio');
                end
                else
                    raise Exception.Create('N�o foi poss�vel obter o snapshot do servidor (' + FTPFIL_REMOTESNAPSHOT + ')');
            end
            else
                raise Exception.Create('N�o foi poss�vel enviar os par�metros da sess�o de dados');

        end;
        2: begin
            TakeSnapshot(aFTPClient,aZConnection,3,aProgressBar,aLabelPercentDone,aBusy,aRichEdit,aOnZLibNotification);
            TakeSnapshot(aFTPClient,aZConnection,4,aProgressBar,aLabelPercentDone,aBusy,aRichEdit,aOnZLibNotification);
        end;
    end;
end;{$ENDIF}

end.

    




