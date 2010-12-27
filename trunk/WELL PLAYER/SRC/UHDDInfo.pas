unit UHDDInfo;

{$WEAKPACKAGEUNIT ON}

interface

type
  TDriveType = (dtUnknown, dtRemovable, dtFixed);

  THDDInfo = packed record
    DriveType     : TDriveType;
    SerialNumber  : AnsiString;
    RevisionNumber: AnsiString;
    Model         : AnsiString;
    BufferSize    : Cardinal;
    Size          : Int64;
    WinDriveIndex : Byte;
  end;


function GetHDDInfo(aDriveIndex: Byte): THDDInfo;
function GetHDDCount: Byte;

implementation

uses Windows
   , Types
   , SysUtils;

type
  TInit = function (sUser: PAnsiChar; sRegCode: PAnsiChar): Integer; stdcall;
  TGetPhysicInfo = function (idiskIndex: Integer; iInfoType: Integer;  pHddInfo_OUT: PAnsiChar): Integer; stdcall;

const
  DLLNAME = 'HDDPhysic.dll';

function GetHDDCount: Byte;
var
  HDDPhysic: HMODULE;
  Init: Tinit;
begin
  Result := 0;

  HDDPhysic := LoadLibrary(DLLNAME);

  if HDDPhysic <> 0 then
    try
      Init := GetProcAddress(HDDPhysic,'Init');

      if Assigned(Init) then
        Result := Init('XXXX','XXXX-XXXX-XXXX');
    finally
      FreeLibrary(HDDPhysic);
    end
  else
    raise Exception.Create('Não foi possível carregar o DLL ' + DLLNAME);
end;

function GetHDDInfo(aDriveIndex: Byte): THDDInfo;
var
  HDDPhysic: HMODULE;
  Init: Tinit;
  GetPhysicInfo: TGetPhysicInfo;
  HDDcount: Byte;
  Information: PAnsiChar;
begin
  HDDPhysic := LoadLibrary(DLLNAME);

  ZeroMemory(@Result,SizeOf(THDDInfo));

  if HDDPhysic <> 0 then
    try
      Init := GetProcAddress(HDDPhysic,'Init');
      GetPhysicInfo := GetProcAddress(HDDPhysic,'GetPhysicInfo');


      if Assigned(Init) and Assigned(GetPhysicInfo) then
      begin
        HDDcount := Init('XXXX','XXXX-XXXX-XXXX');
        Information := nil;

        if HDDcount > 0 then
          if aDriveIndex < HDDcount then
            try
              GetMem(Information,512);
              GetPhysicInfo(aDriveIndex, 0, Information); { 0 = serial number }
              Result.SerialNumber := Information;

              GetPhysicInfo(aDriveIndex, 1, Information); { 1 = hdd model }
              Result.Model := Information;

              GetPhysicInfo(aDriveIndex, 2, Information); { 2 = hdd revision }
              Result.RevisionNumber := Information;

              GetPhysicInfo(aDriveIndex, 3, Information); { 3 = hdd type }

              if Information = 'Removable' then
                Result.DriveType := dtRemovable
              else if Information = 'Fixed' then
                Result.DriveType := dtFixed
              else
                Result.DriveType := dtUnknown;

              GetPhysicInfo(aDriveIndex, 4, Information); { 4 = hdd size }
              Result.Size := StrToInt64Def(String(Information),0);

              GetPhysicInfo(aDriveIndex, 5, Information); { 5 = hdd buffer size }
              Result.BufferSize := StrToIntDef(String(Information),0);

              Result.WinDriveIndex := GetPhysicInfo(aDriveIndex, 6, nil); { 6 = Windows Drive Index }
            finally
              FreeMem(Information,512);
            end
          else
            raise Exception.Create('Foi informado um identificador de drive fora do limite. Existe(m) ' + IntToStr(HDDcount) + '. Identificadores válidos variam de 0 a ' + IntToStr(Pred(HDDcount)));
      end;
    finally
      FreeLibrary(HDDPhysic);
    end
  else
    raise Exception.Create('Não foi possível carregar o DLL ' + DLLNAME);
end;

end.
