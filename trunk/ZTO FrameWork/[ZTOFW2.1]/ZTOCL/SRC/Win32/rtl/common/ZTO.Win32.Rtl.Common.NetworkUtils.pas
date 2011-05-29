unit ZTO.Win32.Rtl.Common.NetworkUtils;

{$WEAKPACKAGEUNIT ON}

interface

uses SysUtils;

function GetLocalHostName: AnsiString;
function GetIPAddress(aHostName, aPort: AnsiString): AnsiString;
function DownloadFile(aRemoteFile, aLocaFile: TFileName): Boolean;

implementation

uses WinSock
   , Windows
   , URLMon;

type
  Paddrinfo = ^Taddrinfo;
  PPaddrinfo = ^Paddrinfo;
  Taddrinfo = packed record
    ai_flags: integer;
    ai_family: integer;
    ai_socktype: integer;
    ai_protocol: integer;
    ai_addrlen: cardinal;
    ai_canonname: pchar;
    ai_addr: psockaddr;
    ai_next: paddrinfo;
  end;

  TGetAddrInfo = function (NodeName: PAnsiChar; ServName: PAnsiChar; Hints: PAddrInfo; Res: PPAddrInfo): Integer; stdcall;

const
  WSHIP6_DLL = 'WSHIP6.DLL';

function GetLocalHostName: AnsiString;
var
  WSAData: TWSAData;
  HostName: PAnsiChar;
begin
  Result := '';
  HostName := nil;
  ZeroMemory(@WSAData,SizeOf(TWSAData));

  if WSAStartup($101, WSAData) = 0 then
    try
      GetMem(HostName,128);

      if GetHostName(HostName, 128) = 0 then
        Result := HostName;

      { Outras informações podem ser obtidas lendo-se o record WSAData }
    finally
      FreeMem(HostName);
      WSACleanup;
    end;
end;

function GetIPAddress(aHostName, aPort: AnsiString): AnsiString;
var
  Hints: PAddrInfo;
  Res: PPAddrInfo;
  WSAData: TWSAData;
  GetAddrInfo: TGetAddrInfo;
  WSHIP: Cardinal;
begin
  Result := '';

  GetMem(Hints,SizeOf(TAddrInfo));
  GetMem(Res,SizeOf(TAddrInfo));

  ZeroMemory(Hints,SizeOf(TAddrInfo));
  ZeroMemory(Res,SizeOf(TAddrInfo));

  Hints.ai_family   := AF_INET; //AF_INET6 para usar IPv6
  Hints.ai_socktype := SOCK_STREAM;
  Hints.ai_protocol := IPPROTO_TCP;

  if WSAStartup($101, WSAData) = 0 then
    try
      WSHIP := LoadLibrary(WSHIP6_DLL);
      if WSHIP > 0 then
        try
          GetAddrInfo := GetProcAddress(WSHIP,'getaddrinfo');
          if GetAddrInfo(@aHostName[1],@aPort[1],Hints,Res) = 0 then
            Result := inet_ntoa(Res^.ai_addr.sin_addr);
        finally
          FreeLibrary(WSHIP);
        end;
    finally
      WSACleanup;
    end;
end;

function DownloadFile(aRemoteFile, aLocaFile: TFileName): Boolean;
begin
  try
    Result :=  UrlDownloadToFile(nil, PChar(aRemoteFile), PChar(aLocaFile), 0, nil) = 0;
  except
    Result := False;
  end;
end;


end.
