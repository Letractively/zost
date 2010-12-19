unit ZTO.Win32.Rtl.Common.FileUtils;

{$WEAKPACKAGEUNIT ON}

{ Ainda não entendi bem por que usar a diretiva acima, só sei que ao fazer isso
os problemas com instalação de componentes que usavam funções desta unit foram
resolvidos. VEJA O AVISO ABAIXO }

// Unit files containing the {$WEAKPACKAGEUNIT ON} directive must not have
// global variables, initialization sections, or finalization sections.

interface

uses Windows
   , SysUtils
   , Classes
   , ZTO.Win32.Rtl.Sys.Types;

type
	TFileSizeUnit = (fsuBytes, fsuKBytes, fsuMBytes, fsuGBytes, fsuTBytes);

  TFileInformation = (fiUnknown, fiMajorVersion, fiMinorVersion, fiRelease, fiBuild, fiFullVersion);


function FileSize(aFileName    : TFileName;
                  aFileSizeUnit: TFileSizeUnit = fsuBytes): Double;

function LoadTextFile(const aFileName: TFileName): String;

procedure SaveTextFile(aText: String; const aFileName: TFileName);

function FileInformation(const aFileName       : TFileName;
                         const aFileInformation: TFileInformation): TMultiTypedResult;

function LoadCompressedTextFile(const aFileName         : TFileName;
                                      OnZlibNotification: TNotifyEvent): String;

procedure CompressFile(const aInputFile
                           , aOutputFile       : TFileName;
                             OnZlibNotification: TNotifyEvent);

procedure SelfCompressFile(const aFileName         : TFileName;
                                 OnZlibNotification: TNotifyEvent);

procedure DecompressFile(const aInputFile
                             , aOutputFile: TFileName;
                               OnZlibNotification: TNotifyEvent);

procedure SelfDecompressFile(const aFileName     : TFileName;
                                   OnNotification: TNotifyEvent);



implementation

uses ZLib
   , ZTO.Win32.Rtl.Common.Classes.Interposer;

procedure CompressFile(const aInputFile
                           , aOutputFile       : TFileName;
                             OnZlibNotification: TNotifyEvent);
var
  InputFile, OutputFile: TFileStream;
  CompressionStream: TCompressionStream;
begin
  InputFile := nil;
  OutputFile := nil;
  CompressionStream := nil;

  try
    InputFile := TFileStream.Create(aInputFile, fmOpenRead and fmShareExclusive);
    OutputFile := TFileStream.Create(aOutputFile, fmCreate or fmShareExclusive);
    CompressionStream := TCompressionStream.Create(clMax, OutputFile);

    CompressionStream.SourceFileName := aInputFile;
    CompressionStream.DestinationFileName := aOutputFile;
    CompressionStream.FileSize := InputFile.Size;
    CompressionStream.OnProgress := OnZlibNotification;

    CompressionStream.Moment := znmBeforeProcess;
    if Assigned(OnZlibNotification) then
      OnZlibNotification(CompressionStream);

    CompressionStream.Moment := znmInsideProcess;
    CompressionStream.CopyFrom(InputFile,InputFile.Size);

    CompressionStream.Moment := znmAfterProcess;
    if Assigned(OnZlibNotification) then
      OnZlibNotification(CompressionStream);

  finally
    CompressionStream.Free;
    OutputFile.Free;
    InputFile.Free;
  end;
end;

procedure SelfCompressFile(const aFileName         : TFileName;
                                 OnZlibNotification: TNotifyEvent);
begin
  { Comprime em um arquivo temporário }
  CompressFile(aFileName
              ,aFileName + '.C'
              ,OnZlibNotification);

  { Copia o arquivo temporário no arquivo original }
  if not CopyFile(PChar(aFileName + '.C')
                 ,PChar(aFileName)
                 ,False) then
    raise Exception.Create('Não foi possível substituir o arquivo original (' + ExtractFileName(aFileName) + ') por sua versão comprimida')
  else
    DeleteFile(aFileName + '.C');
end;

procedure DecompressFile(const aInputFile
                             , aOutputFile: TFileName;
                               OnZlibNotification: TNotifyEvent);
var
  InputFile, OutputFile: TFileStream;
  DecompressionStream: TDecompressionStream;
  i: Integer;
  Buffer: array [0..1023] of Byte;
begin
  InputFile := nil;
  OutputFile := nil;
  DecompressionStream := nil;

  try
    InputFile := TFileStream.Create(aInputFile, fmOpenRead and fmShareExclusive);
    OutputFile := TFileStream.Create(aOutputFile, fmCreate or fmShareExclusive);
    DecompressionStream := TDecompressionStream.Create(InputFile);

    DecompressionStream.SourceFileName := aInputFile;
    DecompressionStream.DestinationFileName := aOutputFile;
    DecompressionStream.FileSize := InputFile.Size;
    DecompressionStream.OnProgress := OnZlibNotification;

    DecompressionStream.Moment := znmBeforeProcess;
    if Assigned(OnZlibNotification) then
      OnZlibNotification(DecompressionStream);

    DecompressionStream.Moment := znmInsideProcess;
    repeat
      i := DecompressionStream.Read(Buffer, SizeOf(Buffer));
      if i <> 0 then
        OutputFile.Write(Buffer, i);
    until i <= 0;

    DecompressionStream.Moment := znmAfterProcess;
    if Assigned(OnZlibNotification) then
      OnZlibNotification(DecompressionStream);

  finally
    DecompressionStream.Free;
    OutputFile.Free;
    InputFile.Free;
  end;
end;

procedure SelfDecompressFile(const aFileName     : TFileName;
                                   OnNotification: TNotifyEvent);
begin
  { Descomprime em um arquivo temporário }
  DecompressFile(aFileName
                ,aFileName + '.D'
                ,OnNotification);

  { Copia o arquivo temporário no arquivo original }
  if not CopyFile(PChar(aFileName + '.D')
                 ,PChar(aFileName)
                 ,False) then
    raise Exception.Create('Não foi possível substituir o arquivo original (' + ExtractFileName(aFileName) + ') por sua versão descomprimida')
  else
    DeleteFile(aFileName + '.D');
end;

function LoadCompressedTextFile(const aFileName         : TFileName;
                                      OnZlibNotification: TNotifyEvent): String;
var
  InputFile: TFileStream;
  OutputStream: TMemoryStream;
  DecompressionStream: TDecompressionStream;
  i: Integer;
  Buffer: array [0..1023] of Byte;
begin
  Result := '';
  InputFile := nil;
  DecompressionStream := nil;

  try
    InputFile := TFileStream.Create(aFileName, fmOpenRead and fmShareExclusive);
    OutputStream := TMemoryStream.Create;
    DecompressionStream := TDecompressionStream.Create(InputFile);

    DecompressionStream.SourceFileName := aFileName;
    DecompressionStream.FileSize := InputFile.Size;
    DecompressionStream.OnProgress := OnZlibNotification;

    DecompressionStream.Moment := znmBeforeProcess;
    if Assigned(OnZlibNotification) then
      OnZlibNotification(DecompressionStream);

    DecompressionStream.Moment := znmInsideProcess;
    repeat
      i := DecompressionStream.Read(Buffer, SizeOf(Buffer));
      if i <> 0 then
//        Result := Result + Buffer[0];
//        OutputFile.Write(Buffer, i);
        OutputStream.Write(Buffer, i);
    until i <= 0;

    DecompressionStream.Moment := znmAfterProcess;
    if Assigned(OnZlibNotification) then
      OnZlibNotification(DecompressionStream);

    try
      OutputStream.Seek(0,soFromBeginning);
      SetLength(Result, OutputStream.Size);
      OutputStream.Read(Pointer(Result)^, OutputStream.Size);
    except
      Result := ''; { Desaloca a memória };
      raise;
    end;
    
  finally
    DecompressionStream.Free;
    InputFile.Free;
  end;
end;

function LoadTextFile(const aFileName: TFileName): String;
begin
	Result := '';

	with TFileStream.Create(aFileName, fmOpenRead or fmShareDenyWrite) do
    try
    	try
        SetLength(Result, Size);
        Read(Pointer(Result)^, Size);
      except
        Result := ''; { Desaloca a memória };
        raise;
      end;
    finally
      Free;
    end;
end;

procedure SaveTextFile(aText: String; const aFileName: TFileName);
begin
  with TFileStream.Create(aFileName, fmCreate) do
    try
      Write(Pointer(aText)^, Length(aText));
    finally
     	Free;
    end;
end;

{ TODO -oCarlos Feitoza : Esta função está incompleta. Ela só está retornando as
informações de versão. Por favor complete-a! }
function FileInformation(const aFileName: TFileName; const aFileInformation: TFileInformation): TMultiTypedResult;
var
  FileInfo: TVSFixedFileInfo;
  FileName: array [0..255] of Char;
 	VersionInfoSize, Dummy, QueryLen: Cardinal;
 	VersionInfo: PChar;
 	FixedInfoData: PVSFixedFileInfo;
begin
  ZeroMemory(@Result,SizeOf(TMultiTypedResult));

  if aFileInformation in [fiMajorVersion, fiMinorVersion, fiRelease, fiBuild, fiFullVersion] then
  begin
    ZeroMemory(@FileName,256);
    ZeroMemory(@FileInfo,SizeOf(TVSFixedFileInfo));
    StrPCopy(FileName,aFileName);

    VersionInfoSize := GetFileVersionInfoSize(FileName, Dummy);

  	if VersionInfoSize > 0 then
    begin
    	GetMem(VersionInfo, VersionInfoSize);
    	GetFileVersionInfo(FileName, Dummy, VersionInfoSize, VersionInfo);

    	VerQueryValue(VersionInfo, '\', Pointer(FixedInfoData), QueryLen);

      FileInfo.dwSignature := FixedInfoData^.dwSignature;
    	FileInfo.dwStrucVersion := FixedInfoData^.dwStrucVersion;
    	FileInfo.dwFileVersionMS := FixedInfoData^.dwFileVersionMS;
    	FileInfo.dwFileVersionLS := FixedInfoData^.dwFileVersionLS;
    	FileInfo.dwProductVersionMS := FixedInfoData^.dwProductVersionMS;
    	FileInfo.dwProductVersionLS := FixedInfoData^.dwProductVersionLS;
    	FileInfo.dwFileFlagsMask := FixedInfoData^.dwFileFlagsMask;
    	FileInfo.dwFileFlags := FixedInfoData^.dwFileFlags;
    	FileInfo.dwFileOS := FixedInfoData^.dwFileOS;
    	FileInfo.dwFileType := FixedInfoData^.dwFileType;
    	FileInfo.dwFileSubtype := FixedInfoData^.dwFileSubtype;
    	FileInfo.dwFileDateMS := FixedInfoData^.dwFileDateMS;
    	FileInfo.dwFileDateLS := FixedInfoData^.dwFileDateLS;
  	end;

    with Result do
      case aFileInformation of
        fiMajorVersion: begin
          ResultType    := rtWord;
          AsWord        := HiWord(FileInfo.dwFileVersionMS);
          AsString      := IntToStr(AsWord);
        end;
        fiMinorVersion: begin
          ResultType    := rtWord;
          AsWord        := LoWord(FileInfo.dwFileVersionMS);
          AsString      := IntToStr(AsWord);
        end;
        fiRelease: begin
          ResultType    := rtWord;
          AsWord        := HiWord(FileInfo.dwFileVersionLS);
          AsString      := IntToStr(AsWord);
        end;
        fiBuild: begin
          ResultType    := rtWord;
          AsWord        := LoWord(FileInfo.dwFileVersionLS);
          AsString      := IntToStr(AsWord);
        end;
        fiFullVersion: begin
          ResultType    := rtShortString;
          AsString      := FileInformation(aFileName,fiMajorVersion).AsString + '.' + FileInformation(aFileName,fiMinorVersion).AsString + '.' + FileInformation(aFileName,fiRelease).AsString + '.' + FileInformation(aFileName,fiBuild).AsString;
        end;
      end;
  end;
end;

function FileSize(aFileName    : TFileName;
                  aFileSizeUnit: TFileSizeUnit = fsuBytes): Double;
var
	FOB: file of 0..255;
    FOKB: file of 0..1024;
    FOMB: file of 0..1048576;
    FOGB: file of 0..1073741824;
begin
	Result := 0;
    
	case aFileSizeUnit of
    	fsuBytes: try
            AssignFile(FOB,aFileName);
            Reset(FOB);
            Result := System.FileSize(FOB);
        finally
            CloseFile(FOB);
        end;
    	fsuKBytes: try
            AssignFile(FOKB,aFileName);
            Reset(FOKB);
            Result := System.FileSize(FOKB);
        finally
            CloseFile(FOKB);
        end;
    	fsuMBytes: try
            AssignFile(FOMB,aFileName);
            Reset(FOMB);
            Result := System.FileSize(FOMB);
        finally
            CloseFile(FOMB);
        end;
    	fsuGBytes: try
            AssignFile(FOGB,aFileName);
            Reset(FOGB);
            Result := System.FileSize(FOGB);
        finally
            CloseFile(FOGB);
        end;
    end;
end;


end.
