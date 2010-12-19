unit ZTO.Win32.Rtl.Sys.WMI;

interface

uses ZTO.Win32.Rtl.Sys.WMI.Tlb;

type
  TWMIGetInfoResult = array of array of string;

  TWMIGetInfoResultSize = record
    Properties: Word; { Linhas no array }
    Instances: Word; { Colunas no array }
  end;

function WMIGetInfoByObjectSet(aSWbemObjectSet: ISWbemObjectSet; out aResult: TWMIGetInfoResult): TWMIGetInfoResultSize;
function WMIGetInfoByClass(aComputer, aNamespace, aUserName, aPassword, aClass: String; out aResult: TWMIGetInfoResult): TWMIGetInfoResultSize;
function WMIGetInfoByQuery(aComputer, aNamespace, aUserName, aPassword: String; aQuery: String; out aResult: TWMIGetInfoResult): TWMIGetInfoResultSize;

implementation

uses Variants
   , ActiveX
   , Windows
   , SysUtils;

function WMIGetInfoByObjectSet(aSWbemObjectSet: ISWbemObjectSet; out aResult: TWMIGetInfoResult): TWMIGetInfoResultSize;
{ ---------------------------------------------------------------------------- }
function GetStringValue(aSWbemProperty: ISWbemProperty): String;
var
  i: Cardinal;
begin
  Result := '';

  if VarIsArray(aSWbemProperty.Get_Value) then
    for i := 0 to VarArrayHighBound(aSWbemProperty.Get_Value, 1) do
    begin
      if i > 0 then
        Result := Result + '¬' ;

      Result := Result + VarToStrDef(aSWbemProperty.Get_Value[i],'NULL');
    end
  else if aSWbemProperty.CIMType = wbemCimtypeChar16 then
    Result := '<16-BIT CHARACTER>'
  else if aSWbemProperty.CIMType = wbemCimtypeObject then
    Result := '<CIM OBJECT>'
  else
    Result := VarToStrDef(aSWbemProperty.Get_Value,'NULL');
end;
{ ---------------------------------------------------------------------------- }
var
  WMIObjectSetEnum, WMIPropertySetEnum: IEnumVariant;
  rgVar: OleVariant;
  pCeltFetched: Cardinal;
  WMIObject: ISWbemObject;
  WMIProperty: ISWbemProperty;
  WMIPropertySet: ISWbemPropertySet;
  SetLengthToResult: Boolean;
  InstanceIndex, PropertyIndex: Word;
begin
  rgVar             := Unassigned;
  pCeltFetched      := 0;
  SetLengthToResult := True;
  InstanceIndex     := 0;

  ZeroMemory(@Result,SizeOf(TWMIGetInfoResultSize));

  Result.Instances := aSWbemObjectSet.Count;
  if Result.Instances = 0 then
    Exit;

  { Obtém uma enumeração de objetos }
  WMIObjectSetEnum := (aSWbemObjectSet._NewEnum) as IEnumVariant;

  while WMIObjectSetEnum.Next(1, rgVar, pCeltFetched) = S_OK do
  begin
    { Obtém o objeto genérico (item) da enumeração }
    WMIObject      := IUnknown(rgVar) as ISWBemObject;
    { Obtém as propriedades do objeto genérico obtido anteriormente }
    WMIPropertySet := WMIObject.Properties_;

    if SetLengthToResult then
    begin
      Result.Properties := WMIPropertySet.Count;

      SetLength (aResult, Succ(Result.Instances), Succ(Result.Properties));
      aResult[0,0] := 'Instance';

      SetLengthToResult := False;
    end;

    Inc(InstanceIndex);
    PropertyIndex := 1 ;
    aResult[InstanceIndex, 0] := IntToStr (InstanceIndex) ;

    { Obtém uma enumeração de propriedades do objeto atual }
    WMIPropertySetEnum := (WMIPropertySet._NewEnum) as IEnumVariant;

    while WMIPropertySetEnum.Next(1, rgVar, pCeltFetched) = S_OK do
    begin
      { Obtém a propriedade (item) da enumeração }
      WMIProperty := IUnknown(rgVar) as ISWbemProperty;

      if InstanceIndex = 1 then
        aResult [0, PropertyIndex] := WMIProperty.Name ;

      aResult[InstanceIndex, PropertyIndex] := GetStringValue(WMIProperty);
      Inc(PropertyIndex);
    end;
  end;
end;

function WMIGetInfoByClass(aComputer, aNamespace, aUserName, aPassword, aClass: String; out aResult: TWMIGetInfoResult): TWMIGetInfoResultSize;
var
  SWbemLocator : TSWbemLocator;
  SWbemServices: ISWbemServices;
begin
  SWbemLocator  := TSWbemLocator.Create (nil);

  try
    SWbemServices := SWbemLocator.ConnectServer (aComputer
                                                ,aNamespace
                                                ,aUserName
                                                ,aPassword
                                                ,''
                                                ,''
                                                ,0
                                                ,nil);

    Result := WMIGetInfoByObjectSet(SWbemServices.InstancesOf(aClass
                                                             ,wbemFlagReturnImmediately or wbemQueryFlagShallow
                                                             ,nil)
                                   ,aResult);
  finally
    SWbemLocator.Free;
  end;



end;

function WMIGetInfoByQuery(aComputer, aNamespace, aUserName, aPassword: String; aQuery: String; out aResult: TWMIGetInfoResult): TWMIGetInfoResultSize;
var
  SWbemLocator : TSWbemLocator;
  SWbemServices: ISWbemServices;
begin
  SWbemLocator  := TSWbemLocator.Create (nil);

  try
    SWbemServices := SWbemLocator.ConnectServer (aComputer
                                                ,aNamespace
                                                ,aUserName
                                                ,aPassword
                                                ,''
                                                ,''
                                                ,0
                                                ,nil);

    Result := WMIGetInfoByObjectSet(SWbemServices.ExecQuery(aQuery
                                                           ,'WQL'
                                                           ,wbemFlagReturnImmediately
                                                           ,nil
                                                           )
                                   ,aResult);
  finally
    SWbemLocator.Free;
  end;
end;


end.
