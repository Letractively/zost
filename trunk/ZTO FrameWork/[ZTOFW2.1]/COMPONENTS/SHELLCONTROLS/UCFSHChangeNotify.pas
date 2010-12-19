unit UCFSHChangeNotify;

interface

uses
    Windows, Classes;

type
    TRoot = type string;

    TCFSHChangeThread = class(TThread)
    private
        FMutex: Integer;

        FChangeFileNameHandle: Integer;
        FChangeDirNameHandle: Integer;
        FChangeAttributesHandle: Integer;
        FChangeSizeHandle: Integer;
        FChangeLastWriteHandle: Integer;
        FChangeSecurityHandle: Integer;

        FOnChangeFileName: TThreadMethod;
        FOnChangeDirName: TThreadMethod;
        FOnChangeAttributes: TThreadMethod;
        FOnChangeSize: TThreadMethod;
        FOnChangeLastWrite: TThreadMethod;
        FOnChangeSecurity: TThreadMethod;
        FDirectory: String;
        FWatchSubTree: Boolean;
        FWaitChanged: Boolean;
//        FNotifyOptionFlags: DWORD;
    protected
        procedure Execute; override;
    public
        constructor Create; virtual;
        destructor Destroy; override;

        procedure SetDirectoryOptions(Directory: String; WatchSubTree: Boolean{; NotifyOptionFlags: DWORD});

        property OnChangeFileName: TThreadMethod read FOnChangeFileName write FOnChangeFileName;
        property OnChangeDirName: TThreadMethod read FOnChangeDirName write FOnChangeDirName;
        property OnChangeAttributes: TThreadMethod read FOnChangeAttributes write FOnChangeAttributes;
        property OnChangeSize: TThreadMethod read FOnChangeSize write FOnChangeSize;
        property OnChangeLastWrite: TThreadMethod read FOnChangeLastWrite write FOnChangeLastWrite;
        property OnChangeSecurity: TThreadMethod read FOnChangeSecurity write FOnChangeSecurity;
    end;

    TCustomCFSHChangeNotifier = class(TComponent)
    private
        FWatchSubTree: Boolean;
        FRoot : TRoot;
        FThread: TCFSHChangeThread;
        FOnChangeFileName: TThreadMethod;
        FOnChangeDirName: TThreadMethod;
        FOnChangeAttributes: TThreadMethod;
        FOnChangeSize: TThreadMethod;
        FOnChangeLastWrite: TThreadMethod;
        FOnChangeSecurity: TThreadMethod;
        procedure SetRoot(const Value: TRoot);
        procedure SetWatchSubTree(const Value: Boolean);
//        procedure SetFilters(const Value: TNotifyFilters);
        procedure SetOnChangeFileName(const Value: TThreadMethod);
        procedure SetOnChangeAttributes(const Value: TThreadMethod);
        procedure SetOnChangeDirName(const Value: TThreadMethod);
        procedure SetOnChangeLastWrite(const Value: TThreadMethod);
        procedure SetOnChangeSecurity(const Value: TThreadMethod);
        procedure SetOnChangeSize(const Value: TThreadMethod);
    protected
        procedure Change;
        procedure Start;
    public
        constructor Create(AOwner : TComponent); override;
        destructor Destroy; override;

//        property NotifyFilters: TNotifyFilters read FFilters write SetFilters;
        property Root: TRoot read FRoot write SetRoot;
        property WatchSubTree: Boolean read FWatchSubTree write SetWatchSubTree;
        property OnChangeFileName: TThreadMethod read FOnChangeFileName write SetOnChangeFileName;
        property OnChangeDirName: TThreadMethod read FOnChangeDirName write SetOnChangeDirName;
        property OnChangeAttributes: TThreadMethod read FOnChangeAttributes write SetOnChangeAttributes;
        property OnChangeSize: TThreadMethod read FOnChangeSize write SetOnChangeSize;
        property OnChangeLastWrite: TThreadMethod read FOnChangeLastWrite write SetOnChangeLastWrite;
        property OnChangeSecurity: TThreadMethod read FOnChangeSecurity write SetOnChangeSecurity;
    end;

    TCFSHChangeNotifier = class(TCustomCFSHChangeNotifier)
    published
//        property NotifyFilters;
        property Root;
        property WatchSubTree;
        property OnChangeFileName;
        property OnChangeDirName;
        property OnChangeAttributes;
        property OnChangeSize;
        property OnChangeLastWrite;
        property OnChangeSecurity;
    end;

procedure Register;

implementation

uses
  SysUtils;

var
    CS: TRTLCriticalSection;

procedure Register;
begin
    RegisterComponents('CF Shell Utilities', [TCFSHChangeNotifier]);
end;

{ TShellChangeThread }

constructor TCFSHChangeThread.Create;
begin
    FreeOnTerminate := True;
    FMutex := CreateMutex(nil, True, nil);
    //Mutex is used to wake up the thread as it waits for any change notifications.
    WaitForSingleObject(FMutex, INFINITE); //Grab the mutex.
    FWaitChanged := false;

    inherited Create(True);
end;

destructor TCFSHChangeThread.Destroy;
begin
    if FChangeFileNameHandle <> ERROR_INVALID_HANDLE then
        FindCloseChangeNotification(FChangeFileNameHandle);

    if FChangeDirNameHandle <> ERROR_INVALID_HANDLE then
        FindCloseChangeNotification(FChangeDirNameHandle);

    if FChangeAttributesHandle <> ERROR_INVALID_HANDLE then
        FindCloseChangeNotification(FChangeAttributesHandle);

    if FChangeSizeHandle <> ERROR_INVALID_HANDLE then
        FindCloseChangeNotification(FChangeSizeHandle);

    if FChangeLastWriteHandle <> ERROR_INVALID_HANDLE then
        FindCloseChangeNotification(FChangeLastWriteHandle);

    if FChangeSecurityHandle <> ERROR_INVALID_HANDLE then
        FindCloseChangeNotification(FChangeSecurityHandle);

    CloseHandle(FMutex);
    inherited;
end;

procedure TCFSHChangeThread.Execute;
{ ---------------------------------------------------------------------------- }
procedure FillChangeHandles(aUseCriticalSection: Boolean = True);
begin
    if aUseCriticalSection then
        EnterCriticalSection(CS);

    FChangeFileNameHandle := FindFirstChangeNotification(PChar(FDirectory), LongBool(FWatchSubTree), FILE_NOTIFY_CHANGE_FILE_NAME);
    FChangeDirNameHandle := FindFirstChangeNotification(PChar(FDirectory), LongBool(FWatchSubTree), FILE_NOTIFY_CHANGE_DIR_NAME);
    FChangeAttributesHandle := FindFirstChangeNotification(PChar(FDirectory), LongBool(FWatchSubTree), FILE_NOTIFY_CHANGE_ATTRIBUTES);
    FChangeSizeHandle := FindFirstChangeNotification(PChar(FDirectory), LongBool(FWatchSubTree), FILE_NOTIFY_CHANGE_SIZE);
    FChangeLastWriteHandle := FindFirstChangeNotification(PChar(FDirectory), LongBool(FWatchSubTree), FILE_NOTIFY_CHANGE_LAST_WRITE);
    FChangeSecurityHandle := FindFirstChangeNotification(PChar(FDirectory), LongBool(FWatchSubTree), FILE_NOTIFY_CHANGE_SECURITY);

    if aUseCriticalSection then
        LeaveCriticalSection(CS);
end;
{ ---------------------------------------------------------------------------- }
var
    Obj: DWORD;
    ChangeHandles: array [0..6] of DWord;
begin
    FillChangeHandles;

//    if FWaitHandle = ERROR_INVALID_HANDLE then
//        Exit;

    while not Terminated do
    begin
        ZeroMemory(@ChangeHandles,SizeOf(ChangeHandles));
        
        ChangeHandles[0] := FChangeFileNameHandle;
        ChangeHandles[1] := FChangeDirNameHandle;
        ChangeHandles[2] := FChangeAttributesHandle;
        ChangeHandles[3] := FChangeSizeHandle;
        ChangeHandles[4] := FChangeLastWriteHandle;
        ChangeHandles[5] := FChangeSecurityHandle;
        ChangeHandles[6] := FMutex;

        Obj := WaitForMultipleObjects(7, @ChangeHandles, False, INFINITE);
        
        case Obj of
            0: begin
                if Assigned(FOnChangeFileName) then//FILE_NOTIFY_CHANGE_FILE_NAME and FNotifyOptionFlags = FILE_NOTIFY_CHANGE_FILE_NAME then
                    Synchronize(FOnChangeFileName);
                FindNextChangeNotification(ChangeHandles[0]);
            end;
            1: begin
                if Assigned(FOnChangeDirName) then//FILE_NOTIFY_CHANGE_DIR_NAME and FNotifyOptionFlags = FILE_NOTIFY_CHANGE_DIR_NAME then
                    Synchronize(FOnChangeDirName);
                FindNextChangeNotification(ChangeHandles[1]);
            end;
            2: begin
                if Assigned(FOnChangeAttributes) then//FILE_NOTIFY_CHANGE_ATTRIBUTES and FNotifyOptionFlags = FILE_NOTIFY_CHANGE_ATTRIBUTES then
                    Synchronize(FOnChangeAttributes);
                FindNextChangeNotification(ChangeHandles[2]);
            end;
            3: begin
                if Assigned(FOnChangeSize) then//FILE_NOTIFY_CHANGE_SIZE and FNotifyOptionFlags = FILE_NOTIFY_CHANGE_SIZE then
                    Synchronize(FOnChangeSize);
                FindNextChangeNotification(ChangeHandles[3]);
            end;
            4: begin
                if Assigned(FOnChangeLastWrite) then//FILE_NOTIFY_CHANGE_LAST_WRITE and FNotifyOptionFlags = FILE_NOTIFY_CHANGE_LAST_WRITE then
                    Synchronize(FOnChangeLastWrite);
                FindNextChangeNotification(ChangeHandles[4]);
            end;
            5: begin
                if Assigned(FOnChangeSecurity) then//FILE_NOTIFY_CHANGE_SECURITY and FNotifyOptionFlags = FILE_NOTIFY_CHANGE_SECURITY then
                    Synchronize(FOnChangeSecurity);
                FindNextChangeNotification(ChangeHandles[5]);
            end;
            6:
                ReleaseMutex(FMutex);
            WAIT_FAILED:
                Exit;
        end;

        EnterCriticalSection(CS);
        if FWaitChanged then
        begin
            FillChangeHandles(False);
            FWaitChanged := false;
        end;
        LeaveCriticalSection(CS);
    end;
end;

procedure TCFSHChangeThread.SetDirectoryOptions(Directory: String; WatchSubTree: Boolean{; NotifyOptionFlags: DWORD});
begin
    EnterCriticalSection(CS);
    FDirectory := Directory;
    FWatchSubTree := WatchSubTree;
//    FNotifyOptionFlags := NotifyOptionFlags;

    // Release the current notification handles
    FindCloseChangeNotification(FChangeFileNameHandle);
    FindCloseChangeNotification(FChangeDirNameHandle);
    FindCloseChangeNotification(FChangeAttributesHandle);
    FindCloseChangeNotification(FChangeSizeHandle);
    FindCloseChangeNotification(FChangeLastWriteHandle);
    FindCloseChangeNotification(FChangeSecurityHandle);

//    FChangeFileNameHandle := 0;
//    FChangeDirNameHandle := 0;
//    FChangeAttributesHandle := 0;
//    FChangeSizeHandle := 0;
//    FChangeLastWriteHandle := 0;
//    FChangeSecurityHandle := 0;

    FWaitChanged := True;
    LeaveCriticalSection(CS);
end;

{ TCustomShellChangeNotifier }

procedure TCustomCFSHChangeNotifier.Change;
{ ---------------------------------------------------------------------------- }
procedure NotifyOptionFlags;
begin
//    Result := 0;
    if Assigned(FOnChangeFileName) then
    begin
        FThread.OnChangeFileName := FOnChangeFileName;
//        Result := Result or FILE_NOTIFY_CHANGE_FILE_NAME;
    end;

    if Assigned(FOnChangeDirName) then
    begin
        FThread.OnChangeDirName := FOnChangeDirName;
//        Result := Result or FILE_NOTIFY_CHANGE_DIR_NAME;
    end;

    if Assigned(FOnChangeSize) then
    begin
        FThread.OnChangeSize := FOnChangeSize;
//        Result := Result or FILE_NOTIFY_CHANGE_SIZE;
    end;

    if Assigned(FOnChangeAttributes) then
    begin
        FThread.OnChangeAttributes := FOnChangeAttributes;
//        Result := Result or FILE_NOTIFY_CHANGE_ATTRIBUTES;
    end;

    if Assigned(FOnChangeLastWrite) then
    begin
        FThread.OnChangeLastWrite := FOnChangeLastWrite;
//        Result := Result or FILE_NOTIFY_CHANGE_LAST_WRITE;
    end;

    if Assigned(FOnChangeSecurity) then
    begin
        FThread.OnChangeSecurity := FOnChangeSecurity;
//        Result := Result or FILE_NOTIFY_CHANGE_SECURITY;
    end;
end;

{ ---------------------------------------------------------------------------- }
begin
    if Assigned(FThread) then
    begin
        NotifyOptionFlags;
        FThread.SetDirectoryOptions(Root, LongBool(FWatchSubTree));
    end;
end;

constructor TCustomCFSHChangeNotifier.Create(AOwner: TComponent);
begin
    inherited;
    FRoot := 'C:\';      { Do not localize }
    FWatchSubTree := True;
    Start;
end;

destructor TCustomCFSHChangeNotifier.Destroy;
var
    Temp: TCFSHChangeThread;
begin
    if Assigned(FThread) then
    begin
        Temp := FThread;
        FThread := nil;
        Temp.Terminate;
        ReleaseMutex(Temp.FMutex);
    end;
    inherited;
end;

//procedure TCustomCFSHChangeNotifier.SetFilters(const Value: TNotifyFilters);
//begin
//    FFilters := Value;
//    Change;
//end;

procedure TCustomCFSHChangeNotifier.SetOnChangeAttributes(const Value: TThreadMethod);
begin
    FOnChangeAttributes := Value;
    if Assigned(FThread) then
        FThread.OnChangeAttributes := FOnChangeAttributes
    else
        Start;
end;

procedure TCustomCFSHChangeNotifier.SetOnChangeDirName(const Value: TThreadMethod);
begin
    FOnChangeDirName := Value;
    if Assigned(FThread) then
        FThread.OnChangeDirName := FOnChangeDirName
    else
        Start;
end;

procedure TCustomCFSHChangeNotifier.SetOnChangeFileName(const Value: TThreadMethod);
begin
    FOnChangeFileName := Value;
    if Assigned(FThread) then
        FThread.OnChangeFileName := FOnChangeFileName
    else
        Start;
end;

procedure TCustomCFSHChangeNotifier.SetOnChangeLastWrite(const Value: TThreadMethod);
begin
    FOnChangeLastWrite := Value;
    if Assigned(FThread) then
        FThread.OnChangeLastWrite := FOnChangeLastWrite
    else
        Start;
end;

procedure TCustomCFSHChangeNotifier.SetOnChangeSecurity(const Value: TThreadMethod);
begin
    FOnChangeSecurity := Value;
    if Assigned(FThread) then
        FThread.OnChangeSecurity := FOnChangeSecurity
    else
        Start;
end;

procedure TCustomCFSHChangeNotifier.SetOnChangeSize(const Value: TThreadMethod);
begin
    FOnChangeSize := Value;
    if Assigned(FThread) then
        FThread.OnChangeSize := FOnChangeSize
    else
        Start;
end;

procedure TCustomCFSHChangeNotifier.SetRoot(const Value: TRoot);
begin
    if not SameText(FRoot, Value) then
    begin
        FRoot := Value;
        Change;
    end;
end;

procedure TCustomCFSHChangeNotifier.SetWatchSubTree(const Value: Boolean);
begin
    FWatchSubTree := Value;
    Change;
end;

procedure TCustomCFSHChangeNotifier.Start;
{ ---------------------------------------------------------------------------- }
procedure NotifyOptionFlags;
begin
//    Result := 0;
    if Assigned(FOnChangeFileName) then
    begin
        FThread.OnChangeFileName := FOnChangeFileName;
//        Result := Result or FILE_NOTIFY_CHANGE_FILE_NAME;
    end;

    if Assigned(FOnChangeDirName) then
    begin
        FThread.OnChangeDirName := FOnChangeDirName;
//        Result := Result or FILE_NOTIFY_CHANGE_DIR_NAME;
    end;

    if Assigned(FOnChangeSize) then
    begin
        FThread.OnChangeSize := FOnChangeSize;
//        Result := Result or FILE_NOTIFY_CHANGE_SIZE;
    end;

    if Assigned(FOnChangeAttributes) then
    begin
        FThread.OnChangeAttributes := FOnChangeAttributes;
//        Result := Result or FILE_NOTIFY_CHANGE_ATTRIBUTES;
    end;

    if Assigned(FOnChangeLastWrite) then
    begin
        FThread.OnChangeLastWrite := FOnChangeLastWrite;
//        Result := Result or FILE_NOTIFY_CHANGE_LAST_WRITE;
    end;

    if Assigned(FOnChangeSecurity) then
    begin
        FThread.OnChangeSecurity := FOnChangeSecurity;
//        Result := Result or FILE_NOTIFY_CHANGE_SECURITY;
    end;
end;
{ ---------------------------------------------------------------------------- }
begin
    if Assigned(FOnChangeFileName)
    or Assigned(FOnChangeDirName)
    or Assigned(FOnChangeSize)
    or Assigned(FOnChangeAttributes)
    or Assigned(FOnChangeLastWrite)
    or Assigned(FOnChangeSecurity) then
    begin
        FThread := TCFSHChangeThread.Create;
        NotifyOptionFlags;
        FThread.SetDirectoryOptions(FRoot,LongBool(FWatchSubTree));
        FThread.Resume;
    end;
end;

initialization
    InitializeCriticalSection(CS);

finalization
    DeleteCriticalSection(CS);

end.
