unit ZTO.Win32.Rtl.Sys.Utilities;

{$WEAKPACKAGEUNIT ON}

interface

procedure RaiseOSError(aCode: Cardinal);
procedure ShutdownWindows;
procedure ShowDesktop(aVisible: Boolean);
procedure EnableDesktop(aEnable: Boolean);
procedure ShowTaskBar(aVisible: Boolean);
procedure EnableTaskBar(aEnable: Boolean);
procedure ShowStartButtom(aVisible: Boolean);
procedure EnableStartButtom(aEnable: Boolean);
function WinExit(iFlags: Integer): Boolean;
function ProcessExists(aExeFileName: string): Boolean;
function CTL_CODE(DeviceType, FunctionNo, Method, Access: Integer): Integer;
function IsDesktopVisible: Boolean;
function IsDesktopEnabled: Boolean;
function IsTaskBarVisible: Boolean;
function IsTaskBarEnabled: Boolean;
function IsStartButtomVisible: Boolean;
function IsStartButtomEnabled: Boolean;

implementation

uses Windows
   , SysUtils
   , SysConst
   , ComObj
   , TlHelp32
   , ZTO.Win32.Rtl.Win.Windows;

function CTL_CODE(DeviceType, FunctionNo, Method, Access: Integer): Integer;
begin
  Result := (DeviceType shl 16) or (Access shl 14) or (FunctionNo shl 2) or (Method);
end;

procedure RaiseOSError(aCode: Cardinal);
var
  Error: EOSError;
begin
  Error := EOSError.CreateResFmt(@SOSError, [aCode, SysErrorMessage(aCode)]);
  Error.ErrorCode := aCode;
  raise Error;
end;

procedure ShutdownWindows;
var
  Shell: Variant;
begin
  Shell := CreateOleObject('Shell.Application');
  Shell.ShutdownWindows;
end;

function SetPrivilege(sPrivilegeName: String; bEnabled: Boolean): boolean;
var
  TPPrev, TP: TTokenPrivileges;
  Token: THandle;
  dwRetLen: DWord;
begin
  Result := False;

  OpenProcessToken(GetCurrentProcess,TOKEN_ADJUST_PRIVILEGES or TOKEN_QUERY, Token );

  TP.PrivilegeCount := 1;

  if LookupPrivilegeValue(nil,PChar(sPrivilegeName),TP.Privileges[ 0 ].LUID) then
  begin
    if bEnabled then
    begin
      TP.Privileges[0].Attributes := SE_PRIVILEGE_ENABLED;
    end
    else
    begin
      TP.Privileges[0].Attributes := 0;
    end;

    dwRetLen := 0;
    Result := AdjustTokenPrivileges(Token,False,TP,SizeOf(TPPrev),TPPrev,dwRetLen);
  end;

  CloseHandle( Token );
end;

//
// iFlags:
//
//  one of the following must be
//  specified
//
//   EWX_LOGOFF
//   EWX_REBOOT
//   EWX_SHUTDOWN
//
//  following attributes may be
//  combined with above flags
//
//   EWX_POWEROFF
//   EWX_FORCE    : terminate processes
//
function WinExit(iFlags: Integer): Boolean;
begin
  Result := True;

  if SetPrivilege('SeShutdownPrivilege',True ) then
  begin
    if not ExitWindowsEx(iFlags,0) then
    begin
      // handle errors...
      Result := False;
    end;
    SetPrivilege( 'SeShutdownPrivilege', False )
  end
  else
  begin
    // handle errors...
    Result := False;
  end;
end;

function ProcessExists(aExeFileName: string): Boolean;
var
  ContinueLoop: Boolean;
  FSnapshotHandle: THandle;
  FProcessEntry32: TProcessEntry32;
begin
  FSnapshotHandle := CreateToolhelp32Snapshot(TH32CS_SNAPPROCESS, 0);
  FProcessEntry32.dwSize := SizeOf(FProcessEntry32);
  ContinueLoop := Process32First(FSnapshotHandle, FProcessEntry32);
  Result := False;
  while Integer(ContinueLoop) <> 0 do
  begin
    if ((UpperCase(ExtractFileName(FProcessEntry32.szExeFile)) = UpperCase(aExeFileName))
    or (UpperCase(FProcessEntry32.szExeFile) = UpperCase(aExeFileName))) then
      Result := True;
    ContinueLoop := Process32Next(FSnapshotHandle, FProcessEntry32);
  end;
  CloseHandle(FSnapshotHandle);
end;

procedure ShowDesktop(aVisible: Boolean);
begin
  if aVisible then
    ShowWindow(GetWindow(FindWindow('ProgMan', nil),GW_CHILD), SW_SHOW)
  else
    ShowWindow(GetWindow(FindWindow('ProgMan', nil),GW_CHILD), SW_HIDE);
end;

function IsDesktopVisible: Boolean;
begin
  Result := GetWindowLongPtr(FindWindow('ProgMan', nil),GWL_STYLE) and WS_VISIBLE = WS_VISIBLE;
end;

procedure EnableDesktop(aEnable: Boolean);
begin
  if aEnable then
    EnableWindow(FindWindow('ProgMan', nil), True)
  else
    EnableWindow(FindWindow('ProgMan', nil), False);
end;

function IsDesktopEnabled: Boolean;
begin
  Result := not (GetWindowLongPtr(FindWindow('ProgMan', nil),GWL_STYLE) and WS_DISABLED = WS_DISABLED);
end;

procedure ShowTaskBar(aVisible: Boolean);
begin
  if aVisible then
    ShowWindow(FindWindow('Shell_TrayWnd', nil), SW_SHOW)
  else
    ShowWindow(FindWindow('Shell_TrayWnd', nil), SW_HIDE);
end;

function IsTaskBarVisible: Boolean;
begin
  Result := GetWindowLongPtr(FindWindow('Shell_TrayWnd', nil),GWL_STYLE) and WS_VISIBLE = WS_VISIBLE;
end;

procedure EnableTaskBar(aEnable: Boolean);
begin
  if aEnable then
    EnableWindow(FindWindow('Shell_TrayWnd', nil), True)
  else
    EnableWindow(FindWindow('Shell_TrayWnd', nil), False);
end;

function IsTaskBarEnabled: Boolean;
begin
  Result := not (GetWindowLongPtr(FindWindow('Shell_TrayWnd', nil),GWL_STYLE) and WS_DISABLED = WS_DISABLED);
end;

procedure ShowStartButtom(aVisible: Boolean);
begin
  if aVisible then
    ShowWindow(FindWindowEx(FindWindow('Shell_TrayWnd', nil),0,'Button',nil), SW_SHOW)
  else
    ShowWindow(FindWindowEx(FindWindow('Shell_TrayWnd', nil),0,'Button',nil), SW_HIDE);
end;

function IsStartButtomVisible: Boolean;
begin
  Result := GetWindowLongPtr(FindWindowEx(FindWindow('Shell_TrayWnd', nil),0,'Button',nil),GWL_STYLE) and WS_VISIBLE = WS_VISIBLE;
end;

procedure EnableStartButtom(aEnable: Boolean);
begin
  if aEnable then
    EnableWindow(FindWindowEx(FindWindow('Shell_TrayWnd', nil),0,'Button',nil), True)
  else
    EnableWindow(FindWindowEx(FindWindow('Shell_TrayWnd', nil),0,'Button',nil), False);
end;

function IsStartButtomEnabled: Boolean;
begin
  Result := not (GetWindowLongPtr(FindWindowEx(FindWindow('Shell_TrayWnd', nil),0,'Button',nil),GWL_STYLE) and WS_DISABLED = WS_DISABLED);
end;

end.
