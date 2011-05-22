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
//	    EntityName: AnsiString;
//    	ActionPerformed: AnsiString[3];
//	    KeyName: AnsiString;
//    	KeyValue: AnsiString;
//    end;
//
//    TUndoInformation = array of TUndoRecord;

//	TFTPConfigurations = packed record
//		DB_Password: AnsiString; { Não usado aqui! }
//		DB_UserName: AnsiString; { Não usado aqui! }
//		DB_Protocol: AnsiString; { Não usado aqui! }
//	    DB_Database: AnsiString; { Não usado aqui! }
//		DB_HostAddr: AnsiString; { Não usado aqui! }
//		DB_PortNumb: Word;        { Não usado aqui! }
//
//    	FT_UserName: AnsiString;
//	    FT_PassWord: AnsiString;
//    	FT_HostName: AnsiString;
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
//	    procedure Authenticate(aUserName, aPassword: AnsiString);
//    	procedure Connect(HostName: AnsiString; Port: Word);
//    	procedure ShowOnLog(aText: AnsiString);
//	    procedure AbortEverything(const aErrorMessage: AnsiString);
	    procedure SetBusy(const Value: Boolean);
//	    procedure SetProcessing(const Value: Boolean);
//    	procedure SendLastSyncDateAndTime;
//    	procedure CreateLastSyncFile;
//    	function MD5Put(aLocalFileName, aRemoteFileName: AnsiString; aMaxTries: Byte = 3): Boolean;
//        function ExecuteCmd(aSyncCmd: TSyncCmd; aDescription: AnsiString = ''): Boolean;
//        function CheckMD5(aFileName: AnsiString; aTry: Byte; aDeleteCopyOn: Char): Boolean;
//    	function PermissionTableWasChanged: Boolean;
//    	function MD5Get(aLocalFileName, aRemoteFileName: AnsiString; aMaxTries: Byte = 3): Boolean;
//	    procedure CreateUndoInformation(aUndoInformation: TUndoInformation);
//    	function DatabaseCheckSumCompare: Boolean;
//    	procedure ConfirmEverything;
//    	procedure UndoUnpermittedActions;
//    	procedure Synchronize(aZConnection: TZConnection; aFTPHostName: AnsiString; aFTPPortNumb: Word; aFTPUserName, aFTPPassword: AnsiString; aProgressBar: TProgressBar = nil; aLabelPercentDone: TLabel = nil);
//    	function ReviewDelta(aZConnection: TZConnection; aProgressBar: TProgressBar = nil; aLabelPercentDone: TLabel = nil): TUndoInformation;
//        function GenerateScript(aZConnection: TZConnection; aProgressBar: TProgressBar = nil; aLabelPercentDone: TLabel = nil): AnsiString;
//        function GenerateValuesString(aZConnection: TZConnection; aTableName, aKey: AnsiString; aMode: Char; var aFieldsString: AnsiString): AnsiString; overload;
//        function GenerateValuesString(aZConnection: TZConnection; aTableName, aKey: AnsiString; aMode: Char): AnsiString; overload;
//        function GenerateValuesString(aZConnection: TZConnection; aTableName, aKeyName, aKeyValue: AnsiString; aMode: Char): AnsiString; overload;
//        function GetKeyFields(aZConnection: TZConnection; aTableName: AnsiString): AnsiString;
//	    procedure ClearDeltaAndSaveLastSyncDateTime(aSaveLastSyncDateTime: Boolean);
        procedure DoZlibNotification(aNotificatioType: TZlibNotificationType; aOperation: TZLibOperation; aInputFile, aOutputFile: TFileName);


{ APÓS A REMOÇÃO DA DESFRAGMENTAÇÃO, ESTA PROPRIEDADE NÃO ESTÁ MAIS SENDO USADA, ASSIM COMO SET PROCESSING } 
//        property Processing: Boolean read FProcessing write SetProcessing;
  	public
    	{ Public declarations }

		procedure ReadFTPConfigurations;
        property Busy: Boolean read FBusy write SetBusy;
        property GeneralResult: TModalResult read FGeneralResult;
        property FSYGlobals: TFSYGlobals read FFSYGlobals;
  	end;

implementation

uses AnsiStrings,
	UXXXDataModule, StrUtils, UBDOForm_AutoSync, ZDBCIntfs, ZDataset,
  	DB, UBDOTypesConstantsAndClasses;

resourcestring
    rs_tabelasemcampochave = 'A tabela %s não possui chaves primárias';

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
            zlntBeforeProcess: FFSYGlobals.ShowOnLog('§ Descomprimindo arquivo de dados ' + AnsiString(ExtractFileName(aInputFile)) + '...',TBDOForm_AutoSync(Owner).RichEdit_Log);
            zlntAfterProcess: FFSYGlobals.ShowOnLog('§ Descompressão concluída!',TBDOForm_AutoSync(Owner).RichEdit_Log);
        end
    else if aOperation = zloCompress then
        case aNotificatioType of
            zlntBeforeProcess: FFSYGlobals.ShowOnLog('§ Comprimindo arquivo de dados ' + AnsiString(ExtractFileName(aInputFile)) + '...',TBDOForm_AutoSync(Owner).RichEdit_Log);

            zlntAfterProcess: FFSYGlobals.ShowOnLog('§ Compressão concluída!',TBDOForm_AutoSync(Owner).RichEdit_Log);
        end;
end;

procedure TBDODataModule_AutoSync.FtpClient_AutoSyncCommand(Sender: TObject; var Cmd: string);
var
	Comando: AnsiString;
begin
	Comando := AnsiString(Cmd);
  	if Pos('PASS',String(Comando)) = 1 then
  		Comando := 'PASS ' + AnsiStrings.DupeString(#248,Random(15));

  	FFSYGlobals.ShowOnLog('COMANDO:> ' + Comando,TBDOForm_AutoSync(Owner).RichEdit_Log);
end;

procedure TBDODataModule_AutoSync.FtpClient_AutoSyncDisplay(Sender: TObject; var Msg: string);
begin
	inherited;
	if Pos('>',Msg) <> 1 then
  	begin
		Msg := StringReplace(Msg,'< ','',[]);
 		Msg := StringReplace(Msg,'! ','',[]);
  		FFSYGlobals.ShowOnLog('RETORNO:> ' + AnsiString(Msg),TBDOForm_AutoSync(Owner).RichEdit_Log);
  	end
end;

procedure TBDODataModule_AutoSync.FtpClient_AutoSyncProgress(Sender: TObject; Count: Integer; var Abort: Boolean);
begin
  	inherited;
	FFSYGlobals.SetProgressWith(TBDOForm_AutoSync(Owner).ProgressBar_Progress,TBDOForm_AutoSync(Owner).Label_Percent,Count);
end;

procedure TBDODataModule_AutoSync.FtpClient_AutoSyncRequestDone(Sender: TObject; RqType: TFtpRequest; ErrCode: Word);
var
  Comando, Texto: AnsiString;
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
    Texto := '@ Comando "' + Comando + '" concluído (Código de retorno = ' + AnsiString(IntToStr(ErrCode)) + ') ';
    Texto := Texto + AnsiStrings.DupeString('<',95 - Length(Texto));
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

	FFSYGlobals.ShowOnLog('§ A conexão com o servidor foi encerrada...',TBDOForm_AutoSync(Owner).RichEdit_Log);

    if ZConnection_FTPSynchronizer.Connected then
    begin
//        UseDefrag := False;
        { Se há algum transação ativa deveremos confirmar ou descartar as alterações feitas }
        if ZConnection_FTPSynchronizer.InTransaction then
        begin
            { Se o flag de erro estiver habilitado então executa um rollback... }
            if ZConnection_FTPSynchronizer.Tag <> 0 then
            begin
                FFSYGlobals.ShowOnLog('§ Revertendo banco de dados a seu estado pré-sincronização...',TBDOForm_AutoSync(Owner).RichEdit_Log);
                ZConnection_FTPSynchronizer.Rollback; //use defrag já está false
            end
            { ...do contrário commit }
            else
            begin
                FFSYGlobals.ShowOnLog('§ Confirmando alterações realizadas no banco de dados...',TBDOForm_AutoSync(Owner).RichEdit_Log);
                ZConnection_FTPSynchronizer.Commit;
//                UseDefrag := True;
            end;
        end;

        Application.ProcessMessages;
        { A DESFRAGMENTAÇÃO CAUSAVA ERROS DE SINCRONIZAÇÃO }
        { A desfragmentação só ocorre quando a sincronização for bem-sucedida }
//        if UseDefrag then
//            try
//                Busy := True;
//                Processing := True;
//
//                FFSYGlobals.ShowOnLog('§ Desfragmentando tabelas. Favor aguardar...',TBDOForm_AutoSync(Owner).RichEdit_Log);
//                Application.ProcessMessages;
//                FFSYGlobals.MySQLDefragDatabase(ZConnection_FTPSynchronizer,TBDOForm_AutoSync(Owner).ProgressBar_Progress,TBDOForm_AutoSync(Owner).Label_Percent);
//                FFSYGlobals.ShowOnLog('§ Desfragmentação concluída',TBDOForm_AutoSync(Owner).RichEdit_Log);
//            finally
//                Busy := False;
//            end;
        ZConnection_FTPSynchronizer.Disconnect;
    end;
end;

procedure TBDODataModule_AutoSync.ReadFTPConfigurations;
begin
    { Devemos incondicionalmente configurar os diretórios corretos! }
  	FFSYGlobals.CurrentDir := TBDOConfigurations(Configurations).FTPSynchronizerLocation + '\';
   	FFSYGlobals.FTPDirectory := FFSYGlobals.CurrentDir + 'FTPSync';

    if not DirectoryExists(FFSYGlobals.FTPDirectory) then
        CreateDir(FFSYGlobals.FTPDirectory);

    if not FFSYGlobals.ReadConfigurations(TBDOConfigurations(Configurations).FTPSynchronizerLocation + '\FTPSyncConfig.dat') then
    begin
    	FFSYGlobals.ShowOnLog(FFSYGlobals.PutLineBreaks('! O arquivo de configuração do FTP Syncronizer não existe. Por favor, feche o Banco De Obras, abra o FTP Syncronizer e configure-o',93),TBDOForm_AutoSync(Owner).RichEdit_Log);
        MessageBox(Application.Handle,'O arquivo de configuração do FTP Syncronizer não existe. Por favor, feche o Banco De Obras, abra o FTP Syncronizer e configure-o','Não é possível conectar',MB_ICONERROR);
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
                                          ,False//True { SIMULAÇÃO }
                                          ,TBDOForm_AutoSync(Owner).RichEdit_Log
                                          ,False
                                          ,False
                                          ,DoZlibNotification);
            { Se chegar aqui significa que após a execução do comando anterior,
            o banco de dados local e o banco de dados remoto são idênticos. Caso
            isso não seja verdade, a instrução anterior lançará uma exceção e o
            fluxo será passado para o "Exception" logo abaixo }
            FGeneralResult := mrOk;
		except
			on E: Exception do
            begin
            	FGeneralResult := mrAbort;
				FFSYGlobals.AbortEverything(FtpClient_AutoSync,AnsiString(E.Message),TempBusy,TBDOForm_AutoSync(Owner).RichEdit_Log);
    			Application.MessageBox('Não foi possível sincronizar, contate o desenvolvedor imediatamente! Ao clicar o botão "OK" nesta mensagem, um arquivo de nome "AutoSyncLog.rtf" será criado no diretório raiz do Banco De Obras. Envie-o ao desenvolvedor para análise.','Não foi possível sincronizar',MB_ICONERROR);
				TBDOForm_AutoSync(Owner).RichEdit_Log.Lines.SaveToFile(String(Configurations.CurrentDir) + '\AutoSyncLog.rtf');
            end;
		end;
	finally
    	FFSYGlobals.AddAllUniqueIndexes(TBDOForm_AutoSync(Owner).RichEdit_Log);
		Busy := False;
        Timer_Close.Enabled := True;
	end;
end;

end.
