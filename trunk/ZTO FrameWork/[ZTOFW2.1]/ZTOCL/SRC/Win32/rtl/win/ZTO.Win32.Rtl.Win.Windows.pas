unit ZTO.Win32.Rtl.Win.Windows;

interface

uses
  Windows;

{$IFDEF VER180}
type
  LONG_PTR = Int64;

const
  GWLP_WNDPROC = -4;
  GWLP_HINSTANCE = -6;
  GWLP_HWNDPARENT = -8;
  GWLP_USERDATA = -21;
  GWLP_ID = -12;

function GetWindowLongPtr(aWnd: HWND; nIndex: Integer): LONG_PTR; stdcall;
function GetWindowLongPtrA(aWnd: HWND; nIndex: Integer): LONG_PTR; stdcall;
function GetWindowLongPtrW(aWnd: HWND; nIndex: Integer): LONG_PTR; stdcall;
function SetWindowLongPtr(aWnd: HWND; nIndex: Integer; dwNewLong: LONG_PTR): LONG_PTR; stdcall;
function SetWindowLongPtrA(aWnd: HWND; nIndex: Integer; dwNewLong: LONG_PTR): LONG_PTR; stdcall;
function SetWindowLongPtrW(aWnd: HWND; nIndex: Integer; dwNewLong: LONG_PTR): LONG_PTR; stdcall;
{$ENDIF}

implementation

{$IFDEF VER180}
{$IFNDEF _WIN64}
// In a 32-bit build, these are simply aliases for the non-Ptr versions.
// (WinUser.h uses macros, e.g.: #define GetWindowLongPtrA GetWindowLongA)
function GetWindowLongPtr; external user32 name 'GetWindowLongA';
function GetWindowLongPtrA; external user32 name 'GetWindowLongA';
function GetWindowLongPtrW; external user32 name 'GetWindowLongW';
function SetWindowLongPtr; external user32 name 'SetWindowLongA';
function SetWindowLongPtrA; external user32 name 'SetWindowLongA';
function SetWindowLongPtrW; external user32 name 'SetWindowLongW';
{$ELSE}
// In a 64-bit build, use the real Ptr functions.
function GetWindowLongPtr; external user32 name 'GetWindowLongPtrA';
function GetWindowLongPtrA; external user32 name 'GetWindowLongPtrA';
function GetWindowLongPtrW; external user32 name 'GetWindowLongPtrW';
function SetWindowLongPtr; external user32 name 'SetWindowLongPtrA';
function SetWindowLongPtrA; external user32 name 'SetWindowLongPtrA';
function SetWindowLongPtrW; external user32 name 'SetWindowLongPtrW';
{$ENDIF}
{$ENDIF}
end.
