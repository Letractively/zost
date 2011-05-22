unit UAPIWrappers;
{ Esta unit contém componentes que e outras funções que usam a API.
No caso dos componentes eles devem ser postos aqui, caso não se queira usa-los
de forma convencional, isto é, colocando em formulários, a fim de se ter uma
orientação a objetos mais precisa }
interface
{$WARNINGS OFF}
uses
	Windows, ActiveX, ShlObj, Classes;

type
	TRootID = (
    	ridDesktop, ridInternet, ridPrograms, ridControlPanel, ridPrinters, ridPersonal,
	    ridFavorites, ridStartup, ridRecent, ridSendTo, ridRecycleBin, ridStartMenu,
    	ridDesktopDirectory, ridDrives, ridNetwork, ridNetHood, ridFonts, ridTemplates,
	    ridCommonStartMenu, ridCommonPrograms, ridCommonStartup,
    	ridCommonDesktopDirectory, ridAppData, ridPrintHood, ridDesktopExpanded
   	);

  	TBrowseForObjectFlag = (
    	bfDirectoriesOnly, bfDomainOnly, bfAncestors, bfComputers, bfPrinters,
    	bfIncludeFiles, bfEditBox, bfIncludeURLs, bfNewDialogStyle, bfShareable,
    	bfUseNewUI, bfStatusText, bfValidate, bfUAHint, bfNoNewFolderButton
   	);

	TBrowseForObjectFlags = set of TBrowseForObjectFlag;

    TSHBrowseForObject = class(TComponent)
    private
    	FFlags: TBrowseForObjectFlags;
    	FDialogText: String;
        FDialogTitle: String;
        FRootObject: TRootID;
        FCenterDialogOnScreen: Boolean;
        FSelectedObjectImageIndex: Integer;
        FSelectedObject: String;
        FDisplayName: String;
        FSelectedPIDL: PItemIDList;
        FShellMalloc: IMalloc;
        FOwnerHandle: HWND;
        //FSHBFODialogCustomData: Integer;
    	function RootID2CSIDL(Root: TRootID): Integer;
	    function BrowseFlags2BIF(Flags: TBrowseForObjectFlags): Cardinal;
	    function GetShellImageIndex(const AFile: String): Integer;
    	function SHBrowseForObject(const aShellMalloc: IMalloc; const aWndHandle: HWND; const aTitle, aDialogText: String; const aRootObject: TRootID; const aFlags: TBrowseForObjectFlags; out aSelectedObject, aDisplayName: string; out aSelectedObjectPIDL: PItemIDList; out aSelectedObjectImageIndex: Integer): Boolean;
	    function GetDisplayName: String;
    public
        constructor Create(AOwner: TComponent); override;
        destructor Destroy; override;

        function Execute: Boolean;

        property SelectedPIDL: PItemIDList read FSelectedPIDL;
		property DisplayName: String read GetDisplayName;
        property SelectedObjectImageIndex: Integer read FSelectedObjectImageIndex;
        property SelectedObject: String read FSelectedObject;
	published
        property Flags: TBrowseForObjectFlags read FFlags write FFlags;
    	property DialogText: String read FDialogText write FDialogText;
        property DialogTitle: String read FDialogTitle write FDialogTitle;
        property RootObject: TRootID read FRootObject write FRootObject;
        property CenterDialogOnScreen: Boolean read FCenterDialogOnScreen write FCenterDialogOnScreen;
    end;

implementation

uses
  	ShellApi, Messages, SysUtils, Controls, Graphics, Types;

const
	BFFM_INITIALIZED = ShlObj.BFFM_INITIALIZED;
    BFFM_SELCHANGED = ShlObj.BFFM_SELCHANGED;
    BFFM_VALIDATEFAILED = ShlObj.BFFM_VALIDATEFAILED;
	BFFM_SETSTATUSTEXT = ShlObj.BFFM_SETSTATUSTEXT;

var
	OriginalSHBFOWndProc: Pointer;

{ TSHBrowseForObject }

function TSHBrowseForObject.RootID2CSIDL(Root: TRootID): Integer;
const
	CSIDL_DESKTOPEXPANDED = $FEFE;

	WinNT_RootValues: array[TRootID] of integer = (CSIDL_DESKTOP, CSIDL_INTERNET,
    	CSIDL_PROGRAMS, CSIDL_CONTROLS, CSIDL_PRINTERS, CSIDL_PERSONAL, CSIDL_FAVORITES,
	    CSIDL_STARTUP, CSIDL_RECENT, CSIDL_SENDTO, CSIDL_BITBUCKET, CSIDL_STARTMENU,
    	CSIDL_DESKTOPDIRECTORY, CSIDL_DRIVES, CSIDL_NETWORK, CSIDL_NETHOOD,
	    CSIDL_FONTS, CSIDL_TEMPLATES, CSIDL_COMMON_STARTMENU, CSIDL_COMMON_PROGRAMS,
    	CSIDL_COMMON_STARTUP, CSIDL_COMMON_DESKTOPDIRECTORY, CSIDL_APPDATA,
	    CSIDL_PRINTHOOD, CSIDL_DESKTOPEXPANDED
  	);

  	Win95_RootValues: array[TRootID] of integer = (
	    CSIDL_DESKTOP, CSIDL_INTERNET, CSIDL_PROGRAMS, CSIDL_CONTROLS, CSIDL_PRINTERS,
        CSIDL_PERSONAL, CSIDL_FAVORITES, CSIDL_STARTUP, CSIDL_RECENT, CSIDL_SENDTO,
        CSIDL_BITBUCKET, CSIDL_STARTMENU, CSIDL_DESKTOPDIRECTORY, CSIDL_DRIVES,
        CSIDL_NETWORK, CSIDL_NETHOOD, CSIDL_FONTS, CSIDL_TEMPLATES,
        CSIDL_STARTMENU, CSIDL_PROGRAMS, CSIDL_STARTUP, CSIDL_DESKTOPDIRECTORY,
        CSIDL_APPDATA, CSIDL_PRINTHOOD, CSIDL_DESKTOPEXPANDED
    );
var
	VerInfo: TOSVersionInfo;
begin
  	VerInfo.dwOSVersionInfoSize := SizeOf(TOSVersionInfo);
    GetVersionEx(VerInfo);

    if VerInfo.dwPlatformId = VER_PLATFORM_WIN32_NT then
    	Result := WinNT_RootValues[Root]
    else
    	Result := Win95_RootValues[Root];
end;

function TSHBrowseForObject.BrowseFlags2BIF(Flags: TBrowseForObjectFlags): Cardinal;
const
  	FlagValues: array[TBrowseForObjectFlag] of UINT = (
    	BIF_RETURNONLYFSDIRS, BIF_DONTGOBELOWDOMAIN, BIF_RETURNFSANCESTORS,
	    BIF_BROWSEFORCOMPUTER, BIF_BROWSEFORPRINTER, BIF_BROWSEINCLUDEFILES,
    	BIF_EDITBOX, BIF_BROWSEINCLUDEURLS, BIF_NEWDIALOGSTYLE, BIF_SHAREABLE,
	    BIF_USENEWUI, BIF_STATUSTEXT, BIF_VALIDATE, BIF_UAHINT, BIF_NONEWFOLDERBUTTON
   	);
var
	Opt: TBrowseForObjectFlag;
begin
  	Result := 0;

    for Opt := Low(TBrowseForObjectFlag) to High(TBrowseForObjectFlag) do
    	if Opt in Flags then
        	Result := Result or FlagValues[Opt];

    { Validações de flags }
    if bfEditBox in Flags then
        Result := Result or BIF_VALIDATE;
end;

constructor TSHBrowseForObject.Create(AOwner: TComponent);
begin
	inherited;
    if not Assigned(AOwner) then
	  	raise Exception.Create('Sinto muito mas não é possível criar uma instância desta classe sem um dono');

    FOwnerHandle := TWinControl(AOwner).Handle;
  	FDialogText := 'Texto explicativo';
    FDialogTitle := 'Procurar por pasta';
    RootObject := ridDesktop;
    CenterDialogOnScreen := True;
    FSelectedObjectImageIndex := -1;
    FSelectedObject := '';
    FDisplayName := '';
    FSelectedPIDL := nil;

    FFlags := [bfDirectoriesOnly, bfStatusText, bfValidate];

    SHGetMalloc(FShellMalloc);
end;

destructor TSHBrowseForObject.Destroy;
begin
	if Assigned(FSelectedPIDL) then
    	FShellMalloc.Free(FSelectedPIDL);

    FShellMalloc._Release;
	inherited;
end;

function TSHBrowseForObject.Execute: Boolean;
begin
    Result := SHBrowseForObject(FShellMalloc, FOwnerHandle, FDialogTitle, FDialogText,
    	FRootObject, FFlags, FSelectedObject, FDisplayName, FSelectedPIDL, FSelectedObjectImageIndex);

  	if not Result then
    begin
    	FSelectedObject := '';
        FSelectedPIDL := nil;
	end;
end;

function TSHBrowseForObject.GetDisplayName: String;
var
	ShellFolder: IShellFolder;
  	Str: TStrRet;
begin
	Result := '';
  	if Assigned(FSelectedPIDL) then
    begin
    	if SHGetDesktopFolder(ShellFolder) = NO_ERROR then
        begin
        	try
            	if ShellFolder.GetDisplayNameOf(FSelectedPIDL, SHGDN_FORPARSING, Str) = NOERROR then
                begin
                	case Str.uType of
                    	STRRET_WSTR: Result := WideCharToString(Str.pOleStr);
                        STRRET_OFFSET: Result := PChar(LongWord(FSelectedPIDL) + Str.uOffset);
                        STRRET_CSTR: Result := Str.cStr;
                    end;
                end;
            finally
        		ShellFolder._Release;
            end;
        end;
    end;

	if Result = '' then
	   	Result := FDisplayName;

  	if Result = '' then
  		Result := FSelectedObject;
end;

function TSHBrowseForObject.GetShellImageIndex(const AFile: String): Integer;
var
  	SFI: TSHFileInfo;
begin
  	SHGetFileInfo(PChar(AFile), 0, SFI, SizeOf(TSHFileInfo), SHGFI_SYSICONINDEX);
  	Result := SFI.iIcon;
end;
const
    OUTER_PADDING = 11;

var
    StatusTextHandle: HWND;
    TreeviewHandle: HWND;

function CustomizedSHBFOWndProc(Wnd: HWND; uMsg: UINT; wParam: WPARAM; lParam: LPARAM): LRESULT; stdcall;

    procedure AdjustStatusArea;
    var
        Wi: TWindowInfo;
        Wt: array[0..159] of Char;
    begin
	   	GetWindowInfo(Wnd,Wi);
       	SetWindowPos(StatusTextHandle,0,0,0,Wi.rcClient.Right - Wi.rcClient.Left - 2 * OUTER_PADDING,17,SWP_NOZORDER or SWP_NOMOVE);
        GetWindowText(StatusTextHandle,Wt,160);
    	SetWindowText(StatusTextHandle,'');
    	SetWindowText(StatusTextHandle,Wt);
    end;

    procedure AdjustTreeView;
    var
        Wi: TWindowInfo;
//        Wt: array[0..159] of Char;
        Rect: TRect;

        function GetHeightOfWindow(Wnd: Cardinal): Word;
        var
            Wi: TWindowInfo;
        begin
            GetWindowInfo(Wnd,Wi);
            Result := Wi.rcWindow.Bottom - Wi.rcWindow.Top;
        end;

    begin
	   	GetWindowInfo(Wnd,Wi);
       	SetWindowPos(TreeviewHandle,0,0,0,Wi.rcClient.Right - Wi.rcClient.Left - 2 * OUTER_PADDING,GetHeightOfWindow(TreeviewHandle),SWP_NOZORDER or SWP_NOMOVE);

    	{ Mega Gambiarra!! O treeview ficava sem barra de rolagem quando se reduzia o tamanho da janela e se reabria e pra aparecer eu precisava forçar um redimensionamento. É isto que eu faço aqui! }
        Rect := Wi.rcWindow;
        InflateRect(Rect,1,0);
        SetWindowPos(Wnd,0,0,0,Rect.Right - Rect.Left,Rect.Bottom - Rect.Top,SWP_NOZORDER or SWP_NOMOVE);
        InflateRect(Rect,-1,0);
        SetWindowPos(Wnd,0,0,0,Rect.Right - Rect.Left,Rect.Bottom - Rect.Top,SWP_NOZORDER or SWP_NOMOVE);
    end;

begin
	case uMsg of
    	WM_SIZING: AdjustStatusArea;
    	WM_SHOWWINDOW: begin
        	AdjustStatusArea;
            AdjustTreeView;
        end;
    end;
	Result := CallWindowProc(OriginalSHBFOWndProc,Wnd,uMsg,wParam,lParam);
end;

function SHBFOCallBack(Wnd: HWND; uMsg: UINT; lParam, lpData: LPARAM): Integer stdcall;
type
	PHWND = ^HWND;
    TArray260OfChar = array[0..259] of Char;
const
	WINDOW_TEXT_ID = 14146;
    STATUS_TEXT_ID = 14145;
    TREEVIEW_ID = 0;
    EDIT_OBJECT_ID = 14148;
    BUTTON_NEW_FOLDER_ID = 14150;
    BUTTON_CANCEL_ID = 2;
    BUTTON_OK_ID = 1;
    INNER_PADDING = 6;
var
    SHBrowseForObject: TSHBrowseForObject;
    StatusText: TArray260OfChar;
	DialogClientRect: TRect;
    DialogClientWidth: Word;
    DialogClientHeight: Word;

    function FindWindowText(Child: HWND; Data: LongInt): BOOL; stdcall;
    begin
    	FindWindowText := True;
    	if GetWindowLong(Child, GWL_ID) = WINDOW_TEXT_ID then
        begin
	        PHWND(Data)^ := Child;
            FindWindowText := False;
        end;
    end;

    function FindStatusText(Child: HWND; Data: LongInt): BOOL; stdcall;
    begin
    	FindStatusText := True;
    	if GetWindowLong(Child, GWL_ID) = STATUS_TEXT_ID then
        begin
	        PHWND(Data)^ := Child;
            FindStatusText := False;
        end;
    end;

    function FindTreeView(Child: HWND; Data: LongInt): BOOL; stdcall;
    begin
    	FindTreeView := True;
    	if GetWindowLong(Child, GWL_ID) = TREEVIEW_ID then
        begin
	        PHWND(Data)^ := Child;
            FindTreeView := False;
        end;
    end;

    function FindButtonNewFolder(Child: HWND; Data: LongInt): BOOL; stdcall;
    begin
    	FindButtonNewFolder := True;
    	if GetWindowLong(Child, GWL_ID) = BUTTON_NEW_FOLDER_ID then
        begin
	        PHWND(Data)^ := Child;
            FindButtonNewFolder := False;
        end;
    end;

    function FindButtonCancel(Child: HWND; Data: LongInt): BOOL; stdcall;
    begin
    	FindButtonCancel := True;
    	if GetWindowLong(Child, GWL_ID) = BUTTON_CANCEL_ID then
        begin
	        PHWND(Data)^ := Child;
            FindButtonCancel := False;
        end;
    end;

    function FindButtonOk(Child: HWND; Data: LongInt): BOOL; stdcall;
    begin
    	FindButtonOk := True;
    	if GetWindowLong(Child, GWL_ID) = BUTTON_OK_ID then
        begin
	        PHWND(Data)^ := Child;
            FindButtonOk := False;
        end;
    end;

    function GetWindowTextHandle: Cardinal;
    var
    	ChildWnd: HWND;
    begin
        GetWindowTextHandle := 0;
    	{ Se os flags problemáticos estiverem ligados... }
    	if [bfNewDialogStyle, bfUseNewUI] * SHBrowseForObject.FFlags <> [] then
        begin
            if Wnd <> 0 then
            begin
	            ChildWnd := 0;
                EnumChildWindows(Wnd, @FindWindowText, LongInt(@ChildWnd));
                GetWindowTextHandle := ChildWnd;
            end;
        end
    end;

    function GetStatusTextHandle: Cardinal;
    var
    	ChildWnd: HWND;
    begin
    	GetStatusTextHandle := 0;
    	{ Se os flags problemáticos estiverem ligados... }
    	if [bfNewDialogStyle, bfUseNewUI] * SHBrowseForObject.FFlags <> [] then
        begin
            if Wnd <> 0 then
            begin
                ChildWnd := 0;
                EnumChildWindows(Wnd, @FindStatusText, LongInt(@ChildWnd));
                GetStatusTextHandle := ChildWnd;
            end;
        end
    end;

    function GetTreeViewHandle: Cardinal;
    var
    	ChildWnd: HWND;
    begin
	    GetTreeViewHandle := 0;
    	{ Se os flags problemáticos estiverem ligados... }
    	if [bfNewDialogStyle, bfUseNewUI] * SHBrowseForObject.FFlags <> [] then
        begin
            if Wnd <> 0 then
            begin
                ChildWnd := 0;
                EnumChildWindows(Wnd, @FindTreeView, LongInt(@ChildWnd));
                GetTreeViewHandle := ChildWnd;
            end;
        end
    end;

    function GetNewFolderButtonHandle: Cardinal;
    var
    	ChildWnd: HWND;
    begin
    	GetNewFolderButtonHandle := 0;
    	{ Se os flags problemáticos estiverem ligados... }
    	if [bfNewDialogStyle, bfUseNewUI] * SHBrowseForObject.FFlags <> [] then
        begin
            if Wnd <> 0 then
            begin
                ChildWnd := 0;
                EnumChildWindows(Wnd, @FindButtonNewFolder, LongInt(@ChildWnd));
                GetNewFolderButtonHandle := ChildWnd;
            end;
        end
    end;

    function GetCancelButtonHandle: Cardinal;
    var
    	ChildWnd: HWND;
    begin
    	GetCancelButtonHandle := 0;
    	{ Se os flags problemáticos estiverem ligados... }
    	if [bfNewDialogStyle, bfUseNewUI] * SHBrowseForObject.FFlags <> [] then
        begin
            if Wnd <> 0 then
            begin
                ChildWnd := 0;
                EnumChildWindows(Wnd, @FindButtonCancel, LongInt(@ChildWnd));
                GetCancelButtonHandle := ChildWnd;
            end;
        end
    end;

    function GetOkButtonHandle: Cardinal;
    var
    	ChildWnd: HWND;
    begin
    	GetOkButtonHandle := 0;
    	{ Se os flags problemáticos estiverem ligados... }
    	if [bfNewDialogStyle, bfUseNewUI] * SHBrowseForObject.FFlags <> [] then
        begin
            if Wnd <> 0 then
            begin
                ChildWnd := 0;
                EnumChildWindows(Wnd, @FindButtonOk, LongInt(@ChildWnd));
                GetOkButtonHandle := ChildWnd;
            end;
        end
    end;

    function GetWidthOfWindow(Wnd: Cardinal): Word;
    var
    	Wi: TWindowInfo;
    begin
    	GetWindowInfo(Wnd,Wi);
        Result := Wi.rcWindow.Right - Wi.rcWindow.Left;
    end;

    function GetHeightOfWindow(Wnd: Cardinal): Word;
    var
    	Wi: TWindowInfo;
    begin
    	GetWindowInfo(Wnd,Wi);
        Result := Wi.rcWindow.Bottom - Wi.rcWindow.Top;
    end;

    function GetTopOfWindow(ThisWnd: Cardinal): Word;
    var
    	Wi: TWindowInfo;
        Point: TPoint;
    begin
    	GetWindowInfo(ThisWnd,Wi);
        Point := Wi.rcWindow.TopLeft;
        ScreenToClient(Wnd, Point);
        Result := Point.Y;
    end;

    function GetLeftOfWindow(ThisWnd: Cardinal): Word;
    var
    	Wi: TWindowInfo;
        Point: TPoint;
    begin
    	GetWindowInfo(ThisWnd,Wi);
        Point := Wi.rcWindow.TopLeft;
        ScreenToClient(Wnd, Point);
        Result := Point.X;
    end; 

	procedure AdjustDialog;
    var
    	DialogRect: TRect;
        Wi: TWindowInfo;
    begin
    	GetWindowRect(Wnd, DialogRect);

        if SHBrowseForObject.FCenterDialogOnScreen then
            SetWindowPos(Wnd, 0, (GetSystemMetrics(SM_CXSCREEN) - DialogRect.Right + DialogRect.Left) div 2, (GetSystemMetrics(SM_CYSCREEN) - DialogRect.Bottom + DialogRect.Top) div 2, 0, 0,SWP_NOSIZE or SWP_NOZORDER);

        if SHBrowseForObject.FDialogTitle <> '' then
            SendMessage(Wnd, WM_SETTEXT, 0, LongInt(SHBrowseForObject.FDialogTitle));


        { Salvando na variável o novo tamanho da área-cliente }
        GetWindowInfo(Wnd,Wi);
        DialogClientRect := Wi.rcClient;
        DialogClientWidth := DialogClientRect.Right - DialogClientRect.Left;
        DialogClientHeight := DialogClientRect.Bottom - DialogClientRect.Top;

//        SetWindowLong(Wnd,GWL_STYLE,GetWindowLong(Wnd,GWL_STYLE) xor WS_THICKFRAME xor WS_SIZEBOX);

    	{ Redirecionando o WndProc a fim de interceptar mensagens }
		OriginalSHBFOWndProc := Pointer(SetWindowLong(Wnd,GWL_WNDPROC,LongInt(@CustomizedSHBFOWndProc)));
    end;

    procedure AdjustWindowText;
    begin
	    if [bfNewDialogStyle, bfUseNewUI] * SHBrowseForObject.FFlags <> [] then
        begin
        	SetWindowPos(GetWindowTextHandle,HWND_TOP,OUTER_PADDING,OUTER_PADDING,DialogClientWidth - 2 * OUTER_PADDING,52,0);
        end;
    end;

    procedure AdjustStatusText;
    begin
	    if [bfNewDialogStyle, bfUseNewUI] * SHBrowseForObject.FFlags <> [] then
        begin
        	StatusTextHandle := GetStatusTextHandle;
			SetWindowLong(StatusTextHandle,GWL_STYLE,GetWindowLong(StatusTextHandle,GWL_STYLE) or WS_BORDER or SS_CENTER or SS_PATHELLIPSIS);
        	SetWindowPos(StatusTextHandle,HWND_TOP,OUTER_PADDING,GetTopOfWindow(GetWindowTextHandle) + GetHeightOfWindow(GetWindowTextHandle) + INNER_PADDING,DialogClientWidth - 2 * OUTER_PADDING,17,SWP_SHOWWINDOW);
            EnableWindow(StatusTextHandle,True);
        end;
    end;

    procedure AdjustTreeView;
    begin
	    if [bfNewDialogStyle, bfUseNewUI] * SHBrowseForObject.FFlags <> [] then
        begin
        	TreeviewHandle := GetTreeViewHandle;
        	SetWindowPos(TreeviewHandle,HWND_TOP,OUTER_PADDING,GetTopOfWindow(GetStatusTextHandle) + GetHeightOfWindow(GetStatusTextHandle) + INNER_PADDING,DialogClientWidth - 2 * OUTER_PADDING,DialogClientHeight - (GetTopOfWindow(GetStatusTextHandle) + GetHeightOfWindow(GetStatusTextHandle) + INNER_PADDING) - INNER_PADDING - GetHeightOfWindow(GetOkButtonHandle) - OUTER_PADDING,0);
        end;
    end;

    procedure AdjustNewFolderButton;
    begin
	    if not (bfNoNewFolderButton in SHBrowseForObject.FFlags) and ([bfNewDialogStyle, bfUseNewUI] * SHBrowseForObject.FFlags <> []) then
        begin
        	SetWindowPos(GetNewFolderButtonHandle,HWND_TOP,OUTER_PADDING,GetTopOfWindow(GetTreeViewHandle) + GetHeightOfWindow(GetTreeViewHandle) + INNER_PADDING,0,0,SWP_NOSIZE);
        end;
    end;

    procedure AdjustCancelButton;
    begin
	    if [bfNewDialogStyle, bfUseNewUI] * SHBrowseForObject.FFlags <> [] then
        begin
        	SetWindowPos(GetCancelButtonHandle,HWND_TOP,DialogClientWidth - GetWidthOfWindow(GetCancelButtonHandle) - OUTER_PADDING - GetWidthOfWindow(GetOkButtonHandle) - INNER_PADDING,GetTopOfWindow(GetTreeViewHandle) + GetHeightOfWindow(GetTreeViewHandle) + INNER_PADDING,0,0,SWP_NOSIZE);
        end;
    end;

    procedure AdjustOkButton;
    begin
	    if [bfNewDialogStyle, bfUseNewUI] * SHBrowseForObject.FFlags <> [] then
        begin
        	SetWindowPos(GetOkButtonHandle,HWND_TOP,DialogClientWidth - GetWidthOfWindow(GetOkButtonHandle) - OUTER_PADDING,GetTopOfWindow(GetTreeViewHandle) + GetHeightOfWindow(GetTreeViewHandle) + INNER_PADDING,0,0,SWP_NOSIZE);
        end;
    end;

    procedure SetStatusText(aStatusText: TArray260OfChar);
    begin
    	if [bfNewDialogStyle, bfUseNewUI] * SHBrowseForObject.FFlags <> [] then
        	SetWindowText(GetStatusTextHandle,aStatusText)
        else
	    	SendMessage(Wnd, BFFM_SETSTATUSTEXT, 0, LongInt(@aStatusText));
    end;

begin
	Result := 0;
    
	SHBrowseForObject := TSHBrowseForObject(lpData);
    case uMsg of
        BFFM_INITIALIZED: begin
            AdjustDialog;
            AdjustWindowText;
            AdjustStatusText;
          	AdjustTreeView;
            AdjustNewFolderButton;
            AdjustCancelButton;
            AdjustOkButton;





//  SendMessage(FDlgWnd, BFFM_ENABLEOK, 0, LPARAM(FEnableOKButton));
//  if (FSelection <> '') or (FSelectionPIDL <> NIL) then
//    SendSelectionMessage;
//  if assigned(FOnCreate) then
//    FOnCreate(Self);
//



        end;
        BFFM_SELCHANGED: begin
        	if bfStatusText in SHBrowseForObject.FFlags then
            begin
                StatusText := '';
                SHGetPathFromIDList(PItemIDList(lParam),StatusText);
			    SetStatusText(StatusText);
            end;

        end;
        BFFM_VALIDATEFAILED: begin

        end;
    end;
end;

function TSHBrowseForObject.SHBrowseForObject(const aShellMalloc: IMalloc; const aWndHandle: HWND; const aTitle, aDialogText: String; const aRootObject: TRootID; const aFlags: TBrowseForObjectFlags; out aSelectedObject, aDisplayName: string; out aSelectedObjectPIDL: PItemIDList; out aSelectedObjectImageIndex: Integer): Boolean;
var
	DisplayNameBuffer: array[0..Pred(MAX_PATH)] of Char;
  	BrowseInfo: TBrowseInfo;
    idlRoot, idlSelected: PItemIDList;
    OldErrorMode: Word;
begin
	Result := False;
    { Zerando estruturas coisas }
    aSelectedObject := '';
    aDisplayName := '';
    idlRoot := nil;
    SetLength(aSelectedObject,MAX_PATH);
    ZeroMemory(@BrowseInfo,SizeOf(TBrowseInfo));
    ZeroMemory(@DisplayNameBuffer,Length(DisplayNameBuffer));

    CoInitialize(nil);

    try
        { Obtendo a localização física da pasta raíz sa ser exibida inicialmente }
        SHGetSpecialFolderLocation(aWndHandle, RootID2CSIDL(aRootObject), idlRoot);

        try
            with BrowseInfo do
            begin
                hwndOwner := aWndHandle;
                pidlRoot := idlRoot;
                pszDisplayName := DisplayNameBuffer;
                lpszTitle := PChar(aDialogText);
                ulFlags := BrowseFlags2BIF(aFlags);
                lpfn := SHBFOCallBack;
                lParam := LongInt(Self);
            end;

	        OldErrorMode := SetErrorMode(SEM_FAILCRITICALERRORS);
            try
                { Exibindo a seleção }
                idlSelected := SHBrowseForFolder(BrowseInfo);
            finally
            	SetErrorMode(OldErrorMode);
            end;

            aSelectedObjectPIDL := idlSelected;

            { Se houve uma seleção... }
            if Assigned(idlSelected) then
            begin
                { Tentando converter para um caminho real caso seja um caminho de rede }
                if (bfComputers in aFlags) then
                begin
                    { Guardando o original... }
                    aSelectedObject := '\\' + DisplayNameBuffer;
                    Result := SHGetPathFromIDList(idlSelected, DisplayNameBuffer);

                    { Is it a valid path? }
                    if Result then
                        aSelectedObject := DisplayNameBuffer // Put it in user's variable.
                    else
                        { do nothing, the copy we made above is set to go };
                        Result:= True;
                end
                else
                begin
                    Result := SHGetPathFromIDList(idlSelected, DisplayNameBuffer);
                    aSelectedObject := DisplayNameBuffer; // Put it in user's variable.
                end;

                // Stupid thing won't return the index if the user typed it in.
                if Result and (BrowseInfo.iImage = -1) then
                    aSelectedObjectImageIndex := GetShellImageIndex(aSelectedObject)
                else
                    aSelectedObjectImageIndex := BrowseInfo.iImage; // Update the image index.

            end;

            if not Result then
                Result := Assigned(aSelectedObjectPIDL);
            if Result then
            	aDisplayName := BrowseInfo.pszDisplayName;

        finally
        	aShellMalloc.Free(idlRoot);
        end;

    finally
    	CoUninitialize;
    end;
end;
{$WARNINGS ON}
end.
