unit UXXXForm_MySQLBackupAndRestore;

interface

uses
    Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
    Dialogs, UXXXForm_DialogTemplate, ActnList, ExtCtrls, StdCtrls, Tabs, Buttons,
    ComCtrls, UXXXTypesConstantsAndClasses, ZSQLProcessor, _StdCtrls;

type
    TXXXForm_MySQLBackupAndRestore = class(TXXXForm_DialogTemplate)
        PageControl_Main: TPageControl;
        TabSheet_Backup: TTabSheet;
        Label_Overall: TLabel;
        Label_Current: TLabel;
        Label7: TLabel;
        Bevel1: TBevel;
        ProgressBar_Overall: TProgressBar;
        ProgressBar_Current: TProgressBar;
        BitBtn_Backup: TBitBtn;
        GroupBoxBackupInfo: TGroupBox;
        Label1: TLabel;
        Label_BackupFileName: TLabel;
        Label3: TLabel;
        Label_BackupDirectory: TLabel;
        TabSheet_Restore: TTabSheet;
        LabelInstrucoes: TLabel;
        Label6: TLabel;
        Bevel2: TBevel;
        LabelBlocos: TLabel;
        Memo2: TMemo;
        ListBox_BackupFiles: TListBox;
        BitBtnRestore: TBitBtn;
        ProgressBarInstrucoes: TProgressBar;
        TabSet1: TTabSet;
        ProgressBarBlocos: TProgressBar;
        TabSheet_Advanced: TTabSheet;
        Label5: TLabel;
        Label8: TLabel;
        Bevel3: TBevel;
        Memo3: TMemo;
        Memo1: TMemo;
        BitBtnExecuteComandoCustom: TBitBtn;
        ProgressBar1: TProgressBar;
        TabSet2: TTabSet;
        TabSheet_Configurations: TTabSheet;
        LabelProtocolo: TLabel;
        Label9: TLabel;
        Bevel4: TBevel;
        ComboBox_Protocol: TComboBox;
        TabSheet_About: TTabSheet;
        Image1: TImage;
        StaticText1: TStaticText;
        Timer_BackupFileName: TTimer;
        Label_IsolationLevel: TLabel;
        ComboBox_IsolationLevel: TComboBox;
        LabeledEdit_HostAddress: TLabeledEdit;
        LabeledEdit_Port: TLabeledEdit;
        LabeledEdit_DatabaseName: TLabeledEdit;
        LabeledEdit_Password: TLabeledEdit;
        LabeledEdit_UserName: TLabeledEdit;
        Action_Backup: TAction;
        Label_BlocosValor: TLabel;
        Label_InstrucoesValor: TLabel;
        Action_Restore: TAction;
        procedure FormCreate(Sender: TObject);
        procedure Timer_BackupFileNameTimer(Sender: TObject);
        procedure TabSheet_RestoreShow(Sender: TObject);
        procedure Action_BackupExecute(Sender: TObject);
        procedure FormShow(Sender: TObject);
        procedure PageControl_MainChanging(Sender: TObject; var AllowChange: Boolean);
        procedure FormClose(Sender: TObject; var Action: TCloseAction);
        procedure Action_RestoreExecute(Sender: TObject);
    private
        { Private declarations }
        FProcessorEvents: TProcessorEvents;
        procedure GetBackupFiles(const aStrings: TStrings);
        function Backup: AnsiString;
        procedure Restore(const aScriptFile: TFileName);
        procedure DoMBDBN(aMoment: TMySQLBackupDataBaseNotificationMoment; StrParam0, StrParam1: AnsiString; IntParam0, IntParam1: Cardinal);
        procedure DoExecuteSQLScript(const aExecuteSQLScriptEvent: TExecuteSQLScriptEvent; const aScriptParts: TScriptParts; const aProcessor: TZSQLProcessor);
        procedure DoSplitSQLScript(const aSplitSQLScriptEvent: TSplitSQLScriptEvent; const aScriptParts: TScriptParts; const aProcessor: TZSQLProcessor);
    public
        { Public declarations }
    end;

implementation

uses
    ZDBCIntfs;

{$R *.dfm}

const
    BACKUP_SUBDIR = 'DBBackups\';
    BACKUP_FILENAME_TEMPLATE = '"MySQLBackup [%s@%s] ["dd"."mm"."yyyy "às" hh"."nn"."ss"].sql"';


procedure TXXXForm_MySQLBackupAndRestore.GetBackupFiles(const aStrings: TStrings);
    procedure SearchTree;
    var
        SearchRec: TSearchRec;
        DosError: integer;
    begin
        try
            try
                DosError := FindFirst('*.sql', 0, SearchRec);

                while DosError = 0 do
                begin
                    aStrings.Add(SearchRec.Name);
                    DosError := FindNext(SearchRec);
                end;
            except
                on EOutOfResources do
                    MessageBox(Handle,'A quantidade de arquivos localizados excede o limite de recursos do seu sistema. Favor limitar seu critério de busca escolhendo diretório(s) de nível mais interno.','Recursos do sitema esgotados',MB_ICONERROR);
            end;
        finally
            FindClose(SearchRec);
        end;

        try
            try
                DosError := FindFirst('*.*', faDirectory, SearchRec);

                while DosError = 0 do
                begin
                    if ((SearchRec.attr and faDirectory = faDirectory) and (SearchRec.name <> '.') and (SearchRec.name <> '..')) then
                    begin
                        ChDir(SearchRec.Name);
                        SearchTree;
                        ChDir('..');
                    end;
                    DosError := FindNext(SearchRec);
                end;
            except
                on EOutOfResources do
                    MessageBox(Handle,'A quantidade de diretórios localizados excede o limite de recursos do seu sistema. Favor limitar seu critério de busca escolhendo diretório(s) de nível mais interno.','Recursos do sitema esgotados',MB_ICONERROR);
            end;
        finally
            FindClose(SearchRec)
        end;

    end;

begin
	aStrings.Clear;
	ChDir(String(CreateParameters.Configurations.CurrentDir) + '\' + BACKUP_SUBDIR);
	SearchTree;
end;

procedure TXXXForm_MySQLBackupAndRestore.PageControl_MainChanging(Sender: TObject; var AllowChange: Boolean);
begin
    inherited;
    AllowChange := Action_Backup.Enabled;
end;

procedure TXXXForm_MySQLBackupAndRestore.Action_BackupExecute(Sender: TObject);
var
  BackupFileName: AnsiString;
begin
  inherited;
  try
    Action_Backup.Enabled := False;
    BackupFileName := AnsiString(Label_BackupDirectory.Caption + Label_BackupFileName.Caption);
    CreateParameters.MyDataModule.SaveTextFile(Backup,TFileName(BackupFileName));
    MessageBox(Handle,'O processo de backup foi concluído com sucesso!','Backup concluído',MB_ICONINFORMATION);
  finally
    Action_Backup.Enabled := True;
  end;
end;

procedure TXXXForm_MySQLBackupAndRestore.Action_RestoreExecute(Sender: TObject);
var
    BackupFileName: TFileName;
begin
    inherited;
    try
        Action_Restore.Enabled := False;
        BackupFileName := Label_BackupDirectory.Caption + ListBox_BackupFiles.Items[ListBox_BackupFiles.ItemIndex];
        Restore(BackupFileName);
        MessageBox(Handle,'O processo de restauração de backup foi concluído com sucesso!','Restauração concluída',MB_ICONINFORMATION);
    finally
        Action_Restore.Enabled := True;
    end;
end;

function TXXXForm_MySQLBackupAndRestore.Backup: AnsiString;
var
   MBP: TMySQLBackupDataBaseParameters;
begin
  ZeroMemory(@MBP,SizeOf(TMySQLBackupDataBaseParameters));
  with MBP do
  begin
    DataBaseName := AnsiString(LabeledEdit_DatabaseName.Text);
    OnNotification := DoMBDBN;
  end;

  Result := CreateParameters.MyDataModule.MySQLBackupDataBase(CreateParameters.MyDataModule.DataModuleMain.ZConnections[0].Connection
                                                             ,MBP);
end;

procedure TXXXForm_MySQLBackupAndRestore.DoExecuteSQLScript(const aExecuteSQLScriptEvent: TExecuteSQLScriptEvent;
                                                            const aScriptParts: TScriptParts;
                                                            const aProcessor: TZSQLProcessor);
begin
    case aExecuteSQLScriptEvent of
        esseBeforeExecuteScript: begin
            FProcessorEvents := TProcessorEvents.Create(ProgressBarInstrucoes,Label_InstrucoesValor,LabelInstrucoes);
            aProcessor.AfterExecute := FProcessorEvents.DoAfterExecute;
            aProcessor.BeforeExecute := FProcessorEvents.DoBeforeExecute;

            ProgressBarBlocos.Max := aScriptParts.Count;
            ProgressBarBlocos.Position := 0;
            ProgressBarBlocos.Step := 1;

            CreateParameters.MyDataModule.SetLabelDescriptionValue(LabelInstrucoes,Label_InstrucoesValor,'0 / ' + AnsiString(IntToStr(ProgressBarInstrucoes.Max)));
        end;
        esseBeforeExecuteScriptPart: begin
            aProcessor.Parse;
            ProgressBarInstrucoes.Max := aProcessor.StatementCount;
            ProgressBarInstrucoes.Position := 0;
            ProgressBarInstrucoes.Step := 1;
        end;
        esseAfterExecuteScriptPart: begin
            CreateParameters.MyDataModule.SetLabelDescriptionValue(LabelBlocos,Label_BlocosValor,AnsiString(IntToStr(Succ(ProgressBarBlocos.Position))) + ' / ' + AnsiString(IntToStr(aScriptParts.Count)));
            ProgressBarBlocos.StepIt;
            Application.ProcessMessages;
        end;
        esseAfterExecuteScript: begin
            if Assigned(FProcessorEvents) then
                FProcessorEvents.Free;
        end;
    end;
end;

procedure TXXXForm_MySQLBackupAndRestore.DoSplitSQLScript(const aSplitSQLScriptEvent: TSplitSQLScriptEvent;
                                                          const aScriptParts: TScriptParts;
                                                          const aProcessor: TZSQLProcessor);
begin
    { Nenhum destes eventos foi usado }
    case aSplitSQLScriptEvent of
        ssseBeforeParse: ;
        ssseAfterParse: ;
        ssseBeforeSplitOperation: ;
        ssseBeforeSplit: ;
        ssseAfterSplit: ;
        ssseAfterSplitOperation: ;
    end;
end;

procedure TXXXForm_MySQLBackupAndRestore.Restore(const aScriptFile: TFileName);
begin
    CreateParameters.MyDataModule.MySQLExecuteSQLScript(CreateParameters.MyDataModule.DataModuleMain.ZConnections[0].Connection
                                                       ,aScriptFile
                                                       ,''
                                                       ,DoExecuteSQLScript
                                                       ,DoSplitSQLScript);
end;


procedure TXXXForm_MySQLBackupAndRestore.DoMBDBN(aMoment: TMySQLBackupDataBaseNotificationMoment;
                                                 StrParam0
                                                ,StrParam1: AnsiString;
                                                 IntParam0
                                                ,IntParam1: Cardinal);
begin
    case aMoment of
        nmBeforeExtractStoredRoutines: begin
            ProgressBar_Overall.Max := IntParam0;
            ProgressBar_Overall.Position := 0;
            ProgressBar_Overall.Step := 1;
        end;
        nmBeginExtractStoredRoutine: begin
            ProgressBar_Current.Max := 1;
            ProgressBar_Current.Position := 0;
            ProgressBar_Current.Step := 1;

            if StrParam1 = 'FUNCTION' then
                Label_Overall.Caption := String('Extraindo stored function "' + StrParam0 + '" (' + AnsiString(IntToStr(IntParam1)) + '/' + AnsiString(IntToStr(IntParam0)) + ')')
            else
                Label_Overall.Caption := String('Extraindo stored procedure "' + StrParam0 + '" (' + AnsiString(IntToStr(IntParam1)) + '/' + AnsiString(IntToStr(IntParam0)) + ')');

            Label_Current.Caption := String('Salvando a definição de "' + StrParam0 + '"...');
                
            ProgressBar_Overall.StepIt;
            ProgressBar_Current.StepIt;
        end;
        { ==================================================================== }
        nmBeforeExtractViews: begin
            ProgressBar_Overall.Max := IntParam0;
            ProgressBar_Overall.Position := 0;
            ProgressBar_Overall.Step := 1;
        end;
        nmBeginExtractView: begin
            ProgressBar_Current.Max := 1;
            ProgressBar_Current.Position := 0;
            ProgressBar_Current.Step := 1;

            Label_Overall.Caption := String('Extraindo view "' + StrParam0 + '" (' + AnsiString(IntToStr(IntParam1)) + '/' + AnsiString(IntToStr(IntParam0)) + ')');

            Label_Current.Caption := String('Salvando a definição de "' + StrParam0 + '"...');
            
            ProgressBar_Overall.StepIt;
            ProgressBar_Current.StepIt;
        end;
        { ==================================================================== }
        nmBeforeExtractTriggers: begin
            ProgressBar_Overall.Max := IntParam0;
            ProgressBar_Overall.Position := 0;
            ProgressBar_Overall.Step := 1;
        end;
        nmBeginExtractTrigger: begin
            ProgressBar_Current.Max := 1;
            ProgressBar_Current.Position := 0;
            ProgressBar_Current.Step := 1;

            Label_Overall.Caption := 'Extraindo trigger "' + String(StrParam0) + '" (' + IntToStr(IntParam1) + '/' + IntToStr(IntParam0) + ')';

            Label_Current.Caption := 'Salvando a definição de "' + String(StrParam0) + '"...';
            
            ProgressBar_Overall.StepIt;
            ProgressBar_Current.StepIt;
        end;
        { ==================================================================== }
        nmBeforeExtractTables: begin
            ProgressBar_Overall.Max := IntParam0;
            ProgressBar_Overall.Position := 0;
            ProgressBar_Overall.Step := 1;
        end;
        nmBeginExtractTable: begin
            Label_Overall.Caption := 'Extraindo a definição e as chaves de "' + String(StrParam0) + '" (' + IntToStr(IntParam1) + '/' + IntToStr(IntParam0) + ')';
            ProgressBar_Overall.StepIt;
        end;
        nmBeforeExtractRecords: begin
            ProgressBar_Current.Max := IntParam0;
            ProgressBar_Current.Position := 0;
            ProgressBar_Current.Step := 1;
        end;
        nmBeginExtractRecord: begin
            Label_Current.Caption := 'Extraindo as inserções para "' + String(StrParam0) + '" (' + IntToStr(IntParam1) + '/' + IntToStr(IntParam0) + ')';
            ProgressBar_Current.StepIt;
        end;
    end;
end;

procedure TXXXForm_MySQLBackupAndRestore.FormClose(Sender: TObject; var Action: TCloseAction);
begin
    inherited;
    { Se estivermos no modo Stand Alone devemos copiar as configurações da tela
    para o objeto de configuração }
    {$IFDEF STANDALONE}
    CreateParameters.Configurations.DBProtocol := ComboBox_Protocol.Items[ComboBox_Protocol.ItemIndex];
    CreateParameters.Configurations.DBIsoLevel := Byte(ComboBox_IsolationLevel.Items.Objects[ComboBox_IsolationLevel.ItemIndex]);
    CreateParameters.Configurations.DBHostAddr := LabeledEdit_HostAddress.Text;
    CreateParameters.Configurations.DBPortNumb := StrToIntDef(LabeledEdit_Port.Text,0);
    CreateParameters.Configurations.DBDataBase := LabeledEdit_DatabaseName.Text;
    CreateParameters.Configurations.DBUserName := LabeledEdit_UserName.Text;
    CreateParameters.Configurations.DBPassword := LabeledEdit_Password.Text;
    {$ENDIF}
end;

procedure TXXXForm_MySQLBackupAndRestore.FormCreate(Sender: TObject);
begin
    inherited;
    TabSheet_Advanced.TabVisible := False;

    Label_BackupDirectory.Caption := String(CreateParameters.Configurations.CurrentDir) + '\' + BACKUP_SUBDIR;

  	if not DirectoryExists(String(CreateParameters.Configurations.CurrentDir) + '\' + BACKUP_SUBDIR) then
	  	CreateDir(String(CreateParameters.Configurations.CurrentDir) + '\' + BACKUP_SUBDIR);

    CreateParameters.MyDataModule.DataModuleMain.ZConnections[0].Connection.GetProtocolNames(ComboBox_Protocol.Items);
    ComboBox_IsolationLevel.Items.AddObject('tiNone',TObject(tiNone));
    ComboBox_IsolationLevel.Items.AddObject('tiReadCommitted',TObject(tiReadCommitted));
    ComboBox_IsolationLevel.Items.AddObject('tiReadUncommitted',TObject(tiReadUncommitted));
    ComboBox_IsolationLevel.Items.AddObject('tiRepeatableRead',TObject(tiRepeatableRead));
    ComboBox_IsolationLevel.Items.AddObject('tiSerializable',TObject(tiSerializable));

    { Quando for stand alone devemos carregar as configurações da mesma forma, a
    diferença é que a página de configurações modifica estas configurações }
    ComboBox_Protocol.ItemIndex := ComboBox_Protocol.Items.IndexOf(String(CreateParameters.Configurations.DBProtocol));
    ComboBox_IsolationLevel.ItemIndex := ComboBox_IsolationLevel.Items.IndexOfObject(TObject(CreateParameters.Configurations.DBIsoLevel));
    LabeledEdit_HostAddress.Text := String(CreateParameters.Configurations.DBHostAddr);
    LabeledEdit_Port.Text := IntToStr(CreateParameters.Configurations.DBPortNumb);
    LabeledEdit_DatabaseName.Text := String(CreateParameters.Configurations.DBDataBase);
    LabeledEdit_UserName.Text := String(CreateParameters.Configurations.DBUserName);
    LabeledEdit_Password.Text := String(CreateParameters.Configurations.DBPassword);

    {$IFNDEF STANDALONE}
    TabSheet_Configurations.Enabled := False;
    {$ENDIF}
end;

procedure TXXXForm_MySQLBackupAndRestore.FormShow(Sender: TObject);
begin
    inherited;
    Label_BackupFileName.Caption := Format(FormatDateTime(BACKUP_FILENAME_TEMPLATE,Now),[LabeledEdit_DatabaseName.Text,LabeledEdit_HostAddress.Text]);
end;

procedure TXXXForm_MySQLBackupAndRestore.TabSheet_RestoreShow(Sender: TObject);
begin
    inherited;
    GetBackupFiles(ListBox_BackupFiles.Items);
end;

procedure TXXXForm_MySQLBackupAndRestore.Timer_BackupFileNameTimer(Sender: TObject);
begin
    inherited;
  	Label_BackupFileName.Caption := Format(FormatDateTime(BACKUP_FILENAME_TEMPLATE,Now),[LabeledEdit_DatabaseName.Text,LabeledEdit_HostAddress.Text]);
end;

end.
