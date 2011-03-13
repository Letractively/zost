unit UClasses;

interface

uses
  Windows, SysUtils;

type
  TResultType = (rtUnknown, rtByte, rtWord, rtDWord, rtShortInt, rtSmallInt,
                rtInteger, rtInt64, rtChar, rtShortString, rtString, rtSingle,
                rtDouble, rtCurrency, rtDateTime);

  TMultiTypedResult = record
    DataType: TResultType;
    IsNull: Boolean;
    AsByte: Byte;
    AsWord: Word;
    AsDWord: Cardinal;
    AsShortInt: ShortInt;
    AsSmallInt: SmallInt;
    AsInteger: Integer;
    AsInt64: Int64;
    AsChar: Char;
    AsShortString: ShortString;
    AsString: String;
    AsSingle: Single;
    AsDouble: Double;
    AsCurrency: Currency;
    AsDateTime: TDateTime;
  end;

  TFileInformation = class
  private
    FFileInfo: TVSFixedFileInfo;
    FFileName: TFileName;
    procedure SetFileName(const Value: TFileName);
    function GetFileVersion(const aInfo: ShortString): TMultiTypedResult;
  public
    class function GetInfo(const aFileName: TFileName; const aInfo: ShortString): TMultiTypedResult;
    class procedure SetVersion(const aFileName: TFileName; const aFileMajor, aFileMinor, aFileRelease, aFileBuild, aProductMajor, aProductMinor, aProductRelease, aProductBuild: Word; aChangeFileVersion, aChangeProductVersion: Boolean);
    property FileName: TFileName read FFileName write SetFileName;
    property FileInfo[const Info: ShortString]: TMultiTypedResult read GetFileVersion;
  end;

implementation

type
  TVersionInformation = packed record { VS_VERSIONINFO }
    wLength     : Word;
    wValueLength: Word;
    wType       : Word;
    szKey       : array [0..15] of WChar;
    Padding1    : Word;
    Value       : VS_FIXEDFILEINFO;
    Padding2    : Word;
    Children    : Word;
  end;
  PVersionInformation = ^TVersionInformation;

{ TFileInformation }

function TFileInformation.GetFileVersion(const aInfo: ShortString): TMultiTypedResult;
begin
  ZeroMemory(@Result,SizeOf(TMultiTypedResult));
  with Result do
  begin
    { File Version }
    if aInfo = 'MAJORFILEVERSION' then
    begin
      AsWord := HiWord(FFileInfo.dwFileVersionMS);
      AsShortString := IntToStr(AsWord);
    end
    else if aInfo = 'MINORFILEVERSION' then
    begin
      AsWord := LoWord(FFileInfo.dwFileVersionMS);
      AsShortString := IntToStr(AsWord);
    end
    else if aInfo = 'FILERELEASE' then
    begin
      AsWord := HiWord(FFileInfo.dwFileVersionLS);
      AsShortString := IntToStr(AsWord);
    end
    else if aInfo = 'FILEBUILD' then
    begin
      AsWord := LoWord(FFileInfo.dwFileVersionLS);
      AsShortString := IntToStr(AsWord);
    end
    else if aInfo = 'FULLFILEVERSION' then
    begin
      AsShortString := GetFileVersion('MAJORFILEVERSION').AsShortString + '.' + GetFileVersion('MINORFILEVERSION').AsShortString + '.' + GetFileVersion('FILERELEASE').AsShortString + '.' + GetFileVersion('FILEBUILD').AsShortString;
      AsInt64 := StrToInt64(GetFileVersion('MAJORFILEVERSION').AsShortString + GetFileVersion('MINORFILEVERSION').AsShortString + GetFileVersion('FILERELEASE').AsShortString + GetFileVersion('FILEBUILD').AsShortString);
    end
    { Product Version }
    else if aInfo = 'MAJORPRODUCTVERSION' then
    begin
      AsWord := HiWord(FFileInfo.dwProductVersionMS);
      AsShortString := IntToStr(AsWord);
    end
    else if aInfo = 'MINORPRODUCTVERSION' then
    begin
      AsWord := LoWord(FFileInfo.dwProductVersionMS);
      AsShortString := IntToStr(AsWord);
    end
    else if aInfo = 'PRODUCTRELEASE' then
    begin
      AsWord := HiWord(FFileInfo.dwProductVersionLS);
      AsShortString := IntToStr(AsWord);
    end
    else if aInfo = 'PRODUCTBUILD' then
    begin
      AsWord := LoWord(FFileInfo.dwProductVersionLS);
      AsShortString := IntToStr(AsWord);
    end
    else if aInfo = 'FULLPRODUCTVERSION' then
    begin
      AsShortString := GetFileVersion('MAJORPRODUCTVERSION').AsShortString + '.' + GetFileVersion('MINORPRODUCTVERSION').AsShortString + '.' + GetFileVersion('PRODUCTRELEASE').AsShortString + '.' + GetFileVersion('PRODUCTBUILD').AsShortString;
      AsInt64 := StrToInt64(GetFileVersion('MAJORPRODUCTVERSION').AsShortString + GetFileVersion('MINORPRODUCTVERSION').AsShortString + GetFileVersion('PRODUCTRELEASE').AsShortString + GetFileVersion('PRODUCTBUILD').AsShortString);
    end
  end;
end;

class function TFileInformation.GetInfo(const aFileName: TFileName; const aInfo: ShortString): TMultiTypedResult;
begin
  with TFileInformation.Create do
    try
      FileName := aFileName;
      Result := FileInfo[aInfo];
    finally
      Free;
    end;
end;

procedure TFileInformation.SetFileName(const Value: TFileName);
var
  InternalFileName: array [0..255] of Char;
  VersionInfoSize, Dummy: Cardinal;
  VersionInfo: PChar;
  FixedInfoData: PVSFixedFileInfo;
  QueryLen: Cardinal;
begin
  FFileName := Value;

  ZeroMemory(@InternalFileName,256);
  ZeroMemory(@FFileInfo,SizeOf(TVSFixedFileInfo));
  StrPCopy(InternalFileName,FFileName);

  VersionInfoSize := GetFileVersionInfoSize(InternalFileName, Dummy);

  if VersionInfoSize > 0 then
  begin
    GetMem(VersionInfo, VersionInfoSize);
    GetFileVersionInfo(InternalFileName, Dummy, VersionInfoSize, VersionInfo);

    VerQueryValue(VersionInfo, '\', Pointer(FixedInfoData), QueryLen);

    FFileInfo.dwSignature := FixedInfoData^.dwSignature;
    FFileInfo.dwStrucVersion := FixedInfoData^.dwStrucVersion;
    FFileInfo.dwFileVersionMS := FixedInfoData^.dwFileVersionMS;
    FFileInfo.dwFileVersionLS := FixedInfoData^.dwFileVersionLS;
    FFileInfo.dwProductVersionMS := FixedInfoData^.dwProductVersionMS;
    FFileInfo.dwProductVersionLS := FixedInfoData^.dwProductVersionLS;
    FFileInfo.dwFileFlagsMask := FixedInfoData^.dwFileFlagsMask;
    FFileInfo.dwFileFlags := FixedInfoData^.dwFileFlags;
    FFileInfo.dwFileOS := FixedInfoData^.dwFileOS;
    FFileInfo.dwFileType := FixedInfoData^.dwFileType;
    FFileInfo.dwFileSubtype := FixedInfoData^.dwFileSubtype;
    FFileInfo.dwFileDateMS := FixedInfoData^.dwFileDateMS;
    FFileInfo.dwFileDateLS := FixedInfoData^.dwFileDateLS;
  end;
end;

class procedure TFileInformation.SetVersion(const aFileName: TFileName; const aFileMajor, aFileMinor, aFileRelease, aFileBuild, aProductMajor, aProductMinor, aProductRelease, aProductBuild: Word; aChangeFileVersion, aChangeProductVersion: Boolean);
var
  ModuleHandle: HMODULE;
  ResourceInformationHandle, ResourceHandle: HRSRC;
  ResourceSize: Cardinal;
  ReadOnlyResource, EditableResource: PVersionInformation;
  DiscardChanges: Boolean;
begin
  EditableResource := nil;
  ResourceSize := 0;

  if FileExists(aFileName) then
  begin
    { Carrega o módulo. Pode ser uma DLL ou executável }
    ModuleHandle := LoadLibrary(PAnsiChar(aFileName));

    if ModuleHandle <> 0 then
    begin
      try
        { Obtém o handle para o recurso de versão raiz, que contém mais
        informações do que necessitamos }
        ResourceInformationHandle := FindResource(ModuleHandle
                                                 ,MakeIntResource(VS_VERSION_INFO)
                                                 ,RT_VERSION);

        if ResourceInformationHandle <> 0 then
        begin
          { Obtém o handle para o recurso de versão específicamente. Com este
          handle podemos acessar apenas o que é necessário para nós. Aqui também
          obtemos o tamanho da informação de versão }
          ResourceHandle := LoadResource(ModuleHandle, ResourceInformationHandle);
          ResourceSize   := SizeofResource(ModuleHandle,ResourceInformationHandle);

          if ResourceHandle <> 0 then
          begin
            { Obtém um ponteiro para as informações de versão. Este ponteiro não
            pode ser alterado diretamente, por isso, mais adiante estamos
            copiando suas informações para um segundo ponteiro em outro local de
            memória. Este segundo ponteiro será usado para atualizar as
            informações de versão }
            ReadOnlyResource := LockResource(ResourceHandle);

            if Assigned(ReadOnlyResource) then
            begin
              GetMem(EditableResource,ResourceSize);
              Move(ReadOnlyResource^,EditableResource^,ResourceSize);
            end
            else
              raise Exception.CreateFmt('Não foi possível obter acesso exclusivo ao recurso de versão do módulo "%s"',[aFileName]);
          end
          else
            raise Exception.CreateFmt('Não foi possível carregar o recurso de versão contido no módulo "%s"',[aFileName]);
        end
        else
          raise Exception.CreateFmt('Não foi possível encontrar o recurso de versão no módulo "%s"',[aFileName]);
      finally
        FreeLibrary(ModuleHandle);
      end;

      try
        { Aqui realizamos as alterações necessárias }
        with EditableResource^.Value do
        begin
          if aChangeFileVersion then
          begin
            dwFileVersionMS := MakeLong(aFileMinor,aFileMajor);
            dwFileVersionLS := MakeLong(aFileBuild,aFileRelease);
          end;

          if aChangeProductVersion then
          begin
            dwProductVersionMS := MakeLong(aProductMinor,aProductMajor);
            dwProductVersionLS := MakeLong(aProductBuild,aProductRelease);
          end;
        end;

        { Iniciamos a alteração do recurso, obtendo um handle para o módulo em
        questão, mas desta vez, ao invés de usar LoadLibrary (somente leitura
        ) usaremos uma função especializada para edição de recursos:
        BeginUpdateResource }
        ModuleHandle := BeginUpdateResource(PAnsiChar(aFileName), False);

        if ModuleHandle <> 0 then
        begin
          DiscardChanges := True;

          try
            { Aqui estamos realizando a alteração do recurso de versão usando em
            seu lugar a nossa versão modificada do ponteiro (EditableResource).
            O resultado desta função é true, caso tudo tenha ocorrido bem e
            neste caso nós devemos preencher a variável DiscardChanges com o
            valor invertido (not) pois só devemos descartar alterações se esta
            função retornar false  }
            DiscardChanges := not UpdateResource(ModuleHandle
                                                ,RT_VERSION
                                                ,MakeIntResource(VS_VERSION_INFO)
                                                ,(SUBLANG_PORTUGUESE_BRAZILIAN shl 10) or LANG_PORTUGUESE
                                                ,EditableResource
                                                ,ResourceSize);


            if DiscardChanges then
              raise Exception.CreateFmt('Não foi possível adicionar o recurso de versão no arquivo "%s"',[aFileName]);

          finally
            { Tenta efetivar a alteração realizada. Isso só será feito se
            DiscardChanges for False }
            EndUpdateResource( ModuleHandle, DiscardChanges );
          end;
        end
        else
          raise Exception.CreateFmt('Não foi abrir o módulo "%s" para gravação',[aFileName]);
      finally
        FreeMem(EditableResource);
      end;
    end
    else
      raise Exception.CreateFmt('Não foi possível carregar o módulo "%s"',[aFileName]);
  end;
end;

end.
