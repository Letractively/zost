unit ZTO.Win32.Rtl.Common.Registry;

{$WEAKPACKAGEUNIT ON}

interface

uses Windows
   , Classes;

type
  TRegDataInfo = record
    DataType: Cardinal;
    DataSize: Cardinal;
  end;

procedure ReadRegMultiSz(aRootKey: HKEY; aSubKey, aName: String; aValue: TStrings);
procedure WriteRegMultiSz(aRootKey: HKEY; aSubKey, aName: String; aValue: TStrings);
{ Desabilita o acesso ao Gerenciador e tarefas para o usuário atualmente logado }
procedure DisableTaskMgr(aDisable: Boolean);

implementation

uses SysUtils
   , Registry
   , ZTO.Win32.Rtl.Sys.Utilities;

function GetRegDataInfo(aCurrentKey: HKEY; aName: {$IFDEF VER180}PAnsiChar{$ELSE}PWideChar{$ENDIF}): TRegDataInfo;
var
  Res: Integer;
begin
  ZeroMemory(@Result,SizeOf(TRegDataInfo));

  Res := RegQueryValueEx(aCurrentKey
                        ,aName
                        ,nil
                        ,@Result.DataType
                        ,nil
                        ,@Result.DataSize);

  if Res <> ERROR_SUCCESS then
      RaiseOSError(Res);
end;

procedure ReadRegMultiSz(aRootKey: HKEY; aSubKey, aName: String; aValue: TStrings);
var
  RegDataInfo: TRegDataInfo;
  ValueP: PString;
  ValueS: String;
  i: Cardinal;
begin
  with TRegistry.Create do
    try
      RootKey := aRootKey;
      OpenKeyReadOnly(aSubKey);
      RegDataInfo := GetRegDataInfo(CurrentKey,{$IFDEF VER180}PAnsiChar{$ELSE}PWideChar{$ENDIF}(aName));

      if RegDataInfo.DataType <> REG_MULTI_SZ then
        raise Exception.Create('O tipo de dados é incompatível');

      ValueP := AllocMem(RegDataInfo.DataSize);
      ReadBinaryData(aName,ValueP^,RegDataInfo.DataSize);

      for i := 1 to RegDataInfo.DataSize do
        if String(ValueP)[i] = #0 then
          ValueS := ValueS + #13#10
        else
          ValueS := ValueS + String(ValueP)[i];

      aValue.Text := Trim(ValueS);

    finally
      CloseKey;
      Free;
    end;
end;

procedure WriteRegMultiSz(aRootKey: HKEY; aSubKey, aName: String; aValue: TStrings);
var
  Res: Integer;
  Value: String;
begin
  with TRegistry.Create do
    try
      RootKey := aRootKey;

      if not OpenKey(aSubKey, True) then
        raise Exception.Create('Não foi possível abrir a chave');

      Value := StringReplace(aValue.Text,#13#10,#0,[rfReplaceAll]) + #0;

      { Aparentemente o tamanho precisa ser * 2 porque o tipo string é unicode e tem 2 bytes por caractere }
      Res := RegSetValueEx(CurrentKey
                          ,{$IFDEF VER180}PAnsiChar{$ELSE}PWideChar{$ENDIF}(aName)
                          ,0
                          ,REG_MULTI_SZ
                          ,{$IFDEF VER180}PAnsiChar{$ELSE}PWideChar{$ENDIF}(Value)
                          ,Length(Value) * 2);

      if Res <> ERROR_SUCCESS then
        RaiseOSError(Res);
    finally
      CloseKey;
      Free;
    end;
end;

procedure DisableTaskMgr(aDisable: Boolean);
begin
  with TRegistry.Create do
    try
      RootKey := HKEY_CURRENT_USER;
      OpenKey('Software', True);
      OpenKey('Microsoft', True);
      OpenKey('Windows', True);
      OpenKey('CurrentVersion', True);
      OpenKey('Policies', True);
      OpenKey('System', True);

      if aDisable then
        WriteString('DisableTaskMgr', '1')
      else
        DeleteValue('DisableTaskMgr');
    finally
      CloseKey
    end;
end;


end.
