unit UBDODataModule_AutoSync;

interface

uses
  	Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  	Dialogs, UBDODataModule, ImgList, ActnList, OverByteIcsFtpCli, ExtCtrls,
  	ComCtrls, StdCtrls, ZConnection, UFSYGlobals, UXXXTypesConstantsAndClasses;

type
//	TSyncCmd = function: Boolean of object;
//
//    TUndoRecord = packed record
//	    EntityName: ShortString;
//    	ActionPerformed: String[3];
//	    KeyName: ShortString;
//    	KeyValue: ShortString;
//    end;
//
//    TUndoInformation = array of TUndoRecord;

//	TFTPConfigurations = packed record
//		DB_Password: ShortString; { N�o usado aqui! }
//		DB_UserName: ShortString; { N�o usado aqui! }
//		DB_Protocol: ShortString; { N�o usado aqui! }
//	    DB_Database: ShortString; { N�o usado aqui! }
//		DB_HostAddr: ShortString; { N�o usado aqui! }
//		DB_PortNumb: Word;        { N�o usado aqui! }
//
//    	FT_UserName: ShortString;
//	    FT_PassWord: ShortString;
//    	FT_HostName: ShortString;
//	    FT_PortNumb: Word;
//  	end;

  	TBDODataModule_AutoSync = class(TBDODataModule)
	    Timer_Execute: TTimer;
    	Timer_Close: TTimer;
	    FtpClient_AutoSync: TFtpClient;
    	ZConnection_FTPSynchronizer: TZConnection;
    	procedure FtpClient_AutoSyncCommand(Sender: TObject; var Cmd: string);
    	procedure FtpClient_AutoSyncResponse(Sender: TObject);
    	procedure FtpClient_AutoSyncRequestDone(Sender: TObject; RqType: TFtpRequest; ErrCode: Word);
    	procedure FtpClient_AutoSyncProgress(Sender: TObject; Count: Integer; var Abort: Boolean);
    	procedure FtpClient_AutoSyncSessionClosed(Sender: TObject; ErrCode: Word);
	    procedure DataModuleCreate(Sender: TObject);
    	procedure FtpClient_AutoSyncDisplay(Sender: TObject; var Msg: string);
    	procedure Timer_CloseTimer(Sender: TObject);
    	procedure Timer_ExecuteTimer(Sender: TObject);
    	procedure DataModuleDestroy(Sender: TObject);
  	private
    	{ Private declarations }
        FGeneralResult: TModalResult;
//        FFTPConfigurations: TFTPConfigurations;
    	FBusy: Boolean;
    	FProcessing: Boolean;
        FFSYGlobals: TFSYGlobals;
//	    procedure Authenticate(aUserName, aPassword: ShortString);
//    	procedure Connect(HostName: ShortString; Port: Word);
//    	procedure ShowOnLog(aText: String);
//	    procedure AbortEverything(const aErrorMessage: String);
	    procedure SetBusy(const Value: Boolean);
//	    procedure SetProcessing(const Value: Boolean);
//    	procedure SendLastSyncDateAndTime;
//    	procedure CreateLastSyncFile;
//    	function MD5Put(aLocalFileName, aRemoteFileName: ShortString; aMaxTries: Byte = 3): Boolean;
//        function ExecuteCmd(aSyncCmd: TSyncCmd; aDescription: ShortString = ''): Boolean;
//        function CheckMD5(aFileName: ShortString; aTry: Byte; aDeleteCopyOn: Char): Boolean;
//    	function PermissionTableWasChanged: Boolean;
//    	function MD5Get(aLocalFileName, aRemoteFileName: ShortString; aMaxTries: Byte = 3): Boolean;
//	    procedure CreateUndoInformation(aUndoInformation: TUndoInformation);
//    	function DatabaseCheckSumCompare: Boolean;
//    	procedure ConfirmEverything;
//    	procedure UndoUnpermittedActions;
//    	procedure Synchronize(aZConnection: TZConnection; aFTPHostName: ShortString; aFTPPortNumb: Word; aFTPUserName, aFTPPassword: ShortString; aProgressBar: TProgressBar = nil; aLabelPercentDone: TLabel = nil);
//    	function ReviewDelta(aZConnection: TZConnection; aProgressBar: TProgressBar = nil; aLabelPercentDone: TLabel = nil): TUndoInformation;
//        function GenerateScript(aZConnection: TZConnection; aProgressBar: TProgressBar = nil; aLabelPercentDone: TLabel = nil): String;
//        function GenerateValuesString(aZConnection: TZConnection; aTableName, aKey: ShortString; aMode: Char; var aFieldsString: String): String; overload;
//        function GenerateValuesString(aZConnection: TZConnection; aTableName, aKey: ShortString; aMode: Char): String; overload;
//        function GenerateValuesString(aZConnection: TZConnection; aTableName, aKeyName, aKeyValue: ShortString; aMode: Char): String; overload;
//        function GetKeyFields(aZConnection: TZConnection; aTableName: ShortString): ShortString;
//	    procedure ClearDeltaAndSaveLastSyncDateTime(aSaveLastSyncDateTime: Boolean);
        procedure DoZlibNotification(aNotificatioType: TZlibNotificationType; aOperation: TZLibOperation; aInputFile, aOutputFile: TFileName);


{ AP�S A REMO��O DA DESFRAGMENTA��O, ESTA PROPRIEDADE N�O EST� MAIS SENDO USADA, ASSIM COMO SET PROCESSING } 
//        property Processing: Boolean read FProcessing write SetProcessing;
  	public
    	{ Public declarations }

		procedure ReadFTPConfigurations;
        property Busy: Boolean read FBusy write SetBusy;
        property GeneralResult: TModalResult read FGeneralResult;
        property FSYGlobals: TFSYGlobals read FFSYGlobals;
  	end;

implementation

uses
	UXXXDataModule, StrUtils, UBDOForm_AutoSync, ZDBCIntfs, ZDataset,
  	DB, UBDOTypesConstantsAndClasses;

resourcestring
    rs_tabelasemcampochave = 'A tabela %s n�o possui chaves prim�rias';

{$R *.dfm}

procedure TBDODataModule_AutoSync.DataModuleCreate(Sender: TObject);
begin
	inherited;
	Randomize;
  	FFSYGlobals := TFSYGlobals.Create;
end;

procedure TBDODataModule_AutoSync.DataModuleDestroy(Sender: TObject);
begin
  	inherited;
    FFSYGlobals.Free;
end;

procedure TBDODataModule_AutoSync.DoZlibNotification(aNotificatioType: TZlibNotificationType;
                                                     aOperation: TZLibOperation;
                                                     aInputFile
                                                    ,aOutputFile: TFileName);
begin
    if aOperation = zloDecompress then
        case aNotificatioType of
            zlntBeforeProcess: FFSYGlobals.ShowOnLog('� Descomprimindo arquivo de dados ' + ExtractFileName(aInputFile) + '...',TBDOForm_AutoSync(Owner).RichEdit_Log);
            zlntAfterProcess: FFSYGlobals.ShowOnLog('� Descompress�o conclu�da!',TBDOForm_AutoSync(Owner).RichEdit_Log);
        end
    else if aOperation = zloCompress then
        case aNotificatioType of
            zlntBeforeProcess: FFSYGlobals.ShowOnLog('� Comprimindo arquivo de dados ' + ExtractFileName(aInputFile) + '...',TBDOForm_AutoSync(Owner).RichEdit_Log);

            zlntAfterProcess: FFSYGlobals.ShowOnLog('� Compress�o conclu�da!',TBDOForm_AutoSync(Owner).RichEdit_Log);
        end;
end;

procedure TBDODataModule_AutoSync.FtpClient_AutoSyncCommand(Sender: TObject; var Cmd: string);
var
	Comando: ShortString;
begin
	Comando := Cmd;
  	if Pos('PASS',Comando) = 1 then
  		Comando := 'PASS ' + DupeString(#248,Random(15));

  	FFSYGlobals.ShowOnLog('COMANDO:> ' + Comando,TBDOForm_AutoSync(Owner).RichEdit_Log);
end;

procedure TBDODataModule_AutoSync.FtpClient_AutoSyncDisplay(Sender: TObject; var Msg: string);
begin
	inherited;
	if Pos('>',Msg) <> 1 then
  	begin
		Msg := StringReplace(Msg,'< ','',[]);
 		Msg := StringReplace(Msg,'! ','',[]);
  		FFSYGlobals.ShowOnLog('RETORNO:> ' + Msg,TBDOForm_AutoSync(Owner).RichEdit_Log);
  	end
end;

procedure TBDODataModule_AutoSync.FtpClient_AutoSyncProgress(Sender: TObject; Count: Integer; var Abort: Boolean);
begin
  	inherited;
	FFSYGlobals.SetProgressWith(TBDOForm_AutoSync(Owner).ProgressBar_Progress,TBDOForm_AutoSync(Owner).Label_Percent,Count);
end;

procedure TBDODataModule_AutoSync.FtpClient_AutoSyncRequestDone(Sender: TObject; RqType: TFtpRequest; ErrCode: Word);
var
    Comando, Texto: ShortString;
begin
  	inherited;
    case RqType of
    	ftpOpenAsync: Comando := 'OPEN';
        ftpGetAsync: Comando := 'GET';
        ftpPutAsync: Comando := 'PUT';
        ftpMd5Async: Comando := 'MD5';
        ftpPassAsync: Comando := 'PASS';
        ftpUserAsync: Comando := 'USER';
        ftpQuitAsync: Comando := 'QUIT';
        else
        	Comando := 'Desconhecido';
    end;
    Texto := '@ Comando "' + Comando + '" conclu�do (C�digo de retorno = ' + IntToStr(ErrCode) + ') ';
    Texto := Texto + DupeString('<',95 - Length(Texto));
    FFSYGlobals.ShowOnLog(Texto,TBDOForm_AutoSync(Owner).RichEdit_Log);
end;

procedure TBDODataModule_AutoSync.FtpClient_AutoSyncResponse(Sender: TObject);
begin
    inherited;
	if Pos('# SOC: ',FtpClient_AutoSync.LastResponse) = 1 then
    	FFSYGlobals.InitializeProgress(TBDOForm_AutoSync(Owner).ProgressBar_Progress,TBDOForm_AutoSync(Owner).Label_Percent,StrToInt(Copy(FtpClient_AutoSync.LastResponse,Pos(':',FtpClient_AutoSync.LastResponse) + 2,Length(FtpClient_AutoSync.LastResponse))));
end;

procedure TBDODataModule_AutoSync.FtpClient_AutoSyncSessionClosed(Sender: TObject; ErrCode: Word);
//var
//	UseDefrag: Boolean;
begin
	inherited;

	FFSYGlobals.ShowOnLog('� A conex�o com o servidor foi encerrada...',TBDOForm_AutoSync(Owner).RichEdit_Log);

    if ZConnection_FTPSynchronizer.Connected then
    begin
//        UseDefrag := False;
        { Se h� algum transa��o ativa deveremos confirmar ou descartar as altera��es feitas }
        if ZConnection_FTPSynchronizer.InTransaction then
        begin
            { Se o flag de erro estiver habilitado ent�o executa um rollback... }
            if ZConnection_FTPSynchronizer.Tag <> 0 then
            begin
                FFSYGlobals.ShowOnLog('� Revertendo banco de dados a seu estado pr�-sincroniza��o...',TBDOForm_AutoSync(Owner).RichEdit_Log);
                ZConnection_FTPSynchronizer.Rollback; //use defrag j� est� false
            end
            { ...do contr�rio commit }
            else
            begin
                FFSYGlobals.ShowOnLog('� Confirmando altera��es realizadas no banco de dados...',TBDOForm_AutoSync(Owner).RichEdit_Log);
                ZConnection_FTPSynchronizer.Commit;
//                UseDefrag := True;
            end;
        end;

        Application.ProcessMessages;
        { A DESFRAGMENTA��O CAUSAVA ERROS DE SINCRONIZA��O }
        { A desfragmenta��o s� ocorre quando a sincroniza��o for bem-sucedida }
//        if UseDefrag then
//            try
//                Busy := True;
//                Processing := True;
//
//                FFSYGlobals.ShowOnLog('� Desfragmentando tabelas. Favor aguardar...',TBDOForm_AutoSync(Owner).RichEdit_Log);
//                Application.ProcessMessages;
//                FFSYGlobals.MySQLDefragDatabase(ZConnection_FTPSynchronizer,TBDOForm_AutoSync(Owner).ProgressBar_Progress,TBDOForm_AutoSync(Owner).Label_Percent);
//                FFSYGlobals.ShowOnLog('� Desfragmenta��o conclu�da',TBDOForm_AutoSync(Owner).RichEdit_Log);
//            finally
//                Busy := False;
//            end;
        ZConnection_FTPSynchronizer.Disconnect;
    end;
end;

procedure TBDODataModule_AutoSync.ReadFTPConfigurations;
begin
    { Devemos incondicionalmente configurar os diret�rios corretos! }
  	FFSYGlobals.CurrentDir := TBDOConfigurations(Configurations).FTPSynchronizerLocation + '\';
   	FFSYGlobals.FTPDirectory := FFSYGlobals.CurrentDir + 'FTPSync';

    if not DirectoryExists(FFSYGlobals.FTPDirectory) then
        CreateDir(FFSYGlobals.FTPDirectory);

    if not FFSYGlobals.ReadConfigurations(TBDOConfigurations(Configurations).FTPSynchronizerLocation + '\FTPSyncConfig.dat') then
    begin
    	FFSYGlobals.ShowOnLog(FFSYGlobals.PutLineBreaks('! O arquivo de configura��o do FTP Syncronizer n�o existe. Por favor, feche o Banco De Obras, abra o FTP Syncronizer e configure-o',93),TBDOForm_AutoSync(Owner).RichEdit_Log);
        MessageBox(Application.Handle,'O arquivo de configura��o do FTP Syncronizer n�o existe. Por favor, feche o Banco De Obras, abra o FTP Syncronizer e configure-o','N�o � poss�vel conectar',MB_ICONERROR);
	   	FGeneralResult := mrAbort;
        Timer_Close.Enabled := True;
    end;
end;

procedure TBDODataModule_AutoSync.SetBusy(const Value: Boolean);
begin
	if Value <> FBusy then
  	begin
    	FBusy := Value;
    	FProcessing := False;
	end;
end;

//procedure TBDODataModule_AutoSync.SetProcessing(const Value: Boolean);
//begin
//	if (Value <> FProcessing) and FBusy then
//		FProcessing := Value;
//end;

procedure TBDODataModule_AutoSync.Timer_CloseTimer(Sender: TObject);
begin
  	inherited;
    Timer_Close.Enabled := False;
    TBDOForm_AutoSync(Owner).ModalResult := FGeneralResult;
end;

procedure TBDODataModule_AutoSync.Timer_ExecuteTimer(Sender: TObject);
var
	TempBusy: Boolean;
begin
  	inherited;
    Timer_Execute.Enabled := False;
	try
		Busy := True;
        TempBusy := Busy;
		try
			TBDOForm_AutoSync(Owner).RichEdit_Log.Clear;
            FFSYGlobals.DropAllUniqueIndexes(TBDOForm_AutoSync(Owner).RichEdit_Log);
			FFSYGlobals.SynchronizeByDelta(FtpClient_AutoSync
                                          ,ZConnection_FTPSynchronizer
                                          ,TBDOForm_AutoSync(Owner).ProgressBar_Progress
                                          ,TBDOForm_AutoSync(Owner).Label_Percent
                                          ,True
                                          ,TempBusy
                                          ,False//True { SIMULA��O }
                                          ,TBDOForm_AutoSync(Owner).RichEdit_Log
                                          ,False
                                          ,False
                                          ,DoZlibNotification);
            { Se chegar aqui significa que ap�s a execu��o do comando anterior,
            o banco de dados local e o banco de dados remoto s�o id�nticos. Caso
            isso n�o seja verdade, a instru��o anterior lan�ar� uma exce��o e o
            fluxo ser� passado para o "Exception" logo abaixo }
            FGeneralResult := mrOk;
		except
			on E: Exception do
            begin
            	FGeneralResult := mrAbort;
				FFSYGlobals.AbortEverything(FtpClient_AutoSync,E.Message,TempBusy,TBDOForm_AutoSync(Owner).RichEdit_Log);
    			Application.MessageBox('N�o foi poss�vel sincronizar, contate o desenvolvedor imediatamente! Ao clicar o bot�o "OK" nesta mensagem, um arquivo de nome "AutoSyncLog.rtf" ser� criado no diret�rio raiz do Banco De Obras. Envie-o ao desenvolvedor para an�lise.','N�o foi poss�vel sincronizar',MB_ICONERROR);
				TBDOForm_AutoSync(Owner).RichEdit_Log.Lines.SaveToFile(Configurations.CurrentDir + '\AutoSyncLog.rtf');
            end;
		end;
	finally
    	FFSYGlobals.AddAllUniqueIndexes(TBDOForm_AutoSync(Owner).RichEdit_Log);
		Busy := False;
        Timer_Close.Enabled := True;
	end;
end;

end.
