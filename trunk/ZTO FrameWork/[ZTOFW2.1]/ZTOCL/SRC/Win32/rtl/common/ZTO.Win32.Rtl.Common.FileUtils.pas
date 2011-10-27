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

  TProcessFilesCallBack = function(const aSearchRec: TSearchRec; const aIsDirectory: Boolean): Boolean;

function FileSize(aFileName    : TFileName;
                  aFileSizeUnit: TFileSizeUnit = fsuBytes): Double;

{ As funções abaixo apenas carregam e salvam de e para arquivos com codificação UTF8 }
function LoadTextFile(aFileName: TFileName): String;
procedure SaveTextFile(aText: String; aFileName: TFileName);

function FileInformation(const aFileName       : TFileName;
                         const aFileInformation: TFileInformation): TMultiTypedResult;

function LoadZLibCompressedTextFile(const aFileName         : TFileName;
                                          OnZlibNotification: TNotifyEvent): String;

procedure ZLibCompressFile(const aInputFile
                               , aOutputFile       : TFileName;
                                 OnZlibNotification: TNotifyEvent);

procedure SelfZLibCompressFile(const aFileName         : TFileName;
                                     OnZlibNotification: TNotifyEvent);

procedure ZLibDecompressFile(const aInputFile
                             , aOutputFile: TFileName;
                               OnZlibNotification: TNotifyEvent);

procedure SelfZLibDecompressFile(const aFileName     : TFileName;
                                       OnNotification: TNotifyEvent);

function GetTemporaryPath: String;

function GetTemporaryName(aPrefix: String; aExtension: String = ''): String;

function IsZLibCompressedFile(aFileName: TFileName): Boolean;

procedure ProcessFiles(aRootDir             : TFileName;
                       aFileMask            : String;
                       aProcessFilesCallBack: TProcessFilesCallBack;
                       aIncludeSubdirs      : Boolean = True);

function IsValidFileName(const aFileName: String): Boolean;

implementation

uses ZLib
   , ZTO.Win32.Rtl.Common.Classes.Interposer;

function IsValidFileName(const aFileName: String): Boolean;
begin
  Result := LastDelimiter('\/:*?"<>|',aFileName) = 0;
end;

function IsZLibCompressedFile(aFileName: TFileName): Boolean;
var
  FileToCheck: file of Byte;
  MagicNumber: Byte;
begin
  Result := False;
  try
    AssignFile(FileToCheck,aFileName);
    FileMode := fmOpenRead;
    Reset(FileToCheck);
    Read(FileToCheck,MagicNumber);

    if MagicNumber = $78 then
    begin
      Read(FileToCheck,MagicNumber);
      if MagicNumber = $DA then
        Result := True;
    end;
  finally
    CloseFile(FileToCheck);
  end;
end;

procedure ZLibCompressFile(const aInputFile
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

procedure SelfZLibCompressFile(const aFileName         : TFileName;
                                     OnZlibNotification: TNotifyEvent);
begin
  { Comprime em um arquivo temporário }
  ZLibCompressFile(aFileName
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

procedure ZLibDecompressFile(const aInputFile
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

procedure SelfZLibDecompressFile(const aFileName     : TFileName;
                                       OnNotification: TNotifyEvent);
begin
  { Descomprime em um arquivo temporário }
  ZLibDecompressFile(aFileName
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

function LoadZLibCompressedTextFile(const aFileName         : TFileName;
                                          OnZlibNotification: TNotifyEvent): String;
var
  InputFile: TFileStream;
  OutputStream: TStringStream;
  DecompressionStream: TDecompressionStream;
  i: Integer;
  Buffer: array [0..1023] of Byte;
begin
  Result := '';
  InputFile := nil;
  DecompressionStream := nil;
  OutputStream := nil;

  try
    InputFile := TFileStream.Create(aFileName, fmOpenRead and fmShareExclusive);
    { Por padrão TStringStream é criada com codificação ANSI. Ao criar forçando
    UTF8 garantimos que tudos será carregado corretamente, mas fará com que esta
    função precise descomprimir um arquivo codificado em UTF8, do contrário,
    coisas estranhas podem acontecer }
    OutputStream := TStringStream.Create(''{$IFNDEF VER180},TEncoding.UTF8{$ENDIF});
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
      Result := OutputStream.DataString; { Está codificada como UTF8, ao atribuir para string, nada deve ser perdido, pois unicode tem mais espaço que utf8 }
    except
      Result := ''; { Desaloca a memória };
      raise;
    end;
    
  finally
    OutputStream.Free;
    DecompressionStream.Free;
    InputFile.Free;
  end;
end;

function LoadTextFile(aFileName: TFileName): String;
begin
	Result := '';

{$IFDEF VER180}
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
{$ELSE}
  { Usando o construtor abaixo faz com que ele tente abrir um arquivo UTF8 sem
  tentar detectar o BOM. Isso carrega os arquivos corretamente }
	with TStreamReader.Create(aFileName,TEncoding.UTF8) do
    try
      if not EndOfStream then
        Result := ReadToEnd;
    finally
      Free;
    end;
{$ENDIF}
end;

procedure SaveTextFile(aText: String; aFileName: TFileName);
begin
{$IFDEF VER180}
  with TFileStream.Create(aFileName, fmCreate) do
    try
      Write(Pointer(aText)^, Length(aText));
    finally
     	Free;
    end;
{$ELSE}
  { Por padrão vai criar em UTF8 sem o BOM, porque ao chamar o construtor desta
  forma o preâmbulo não será gravado no stream final }
  with TStreamWriter.Create(aFileName) do
    try
      Write(aText);
    finally
     	Free;
    end;
{$ENDIF}
end;


(*
procedure TMainForm.btLoadClick(Sender: TObject);
var
  Reader: TStreamReader;
  Size: Int64;
  Line: String;
  Ch: Char;
begin
  { Create a file stream and open a text writer for it. }
  Reader := TStreamReader.Create(
    TFileStream.Create('local_file.txt', fmOpenRead),
    TEncoding.UTF8
  );

  mmText.Clear();

  { Check for the end of the stream and exit if necessary. }
  if Reader.EndOfStream then
  begin
    MessageDlg('Nothing to read!', mtInformation, [mbOK], 0);

    Reader.BaseStream.Free();
    Reader.Free();
  end;

  { Peek at each iteration to see whether there are characters
    to read from the reader. Peek is identical in its effect as
    EndOfStream property.
  }
  Line := '';

  while Reader.Peek() >= 0 do
  begin
    { Read the next character. }
    Ch := Char(Reader.Read());

    { Check for line termination (Unix-style). }
    if Ch = #$0A then
    begin
      mmText.Lines.Add(Line);
      Line := '';
    end
    else
      Line := Line + Ch;
  end;

  { Obtain the size of the data. }
  Size := Reader.BaseStream.Size;

  { Free the reader and underlying stream. }
  Reader.Close();
  Reader.BaseStream.Free;
  Reader.Free();

  MessageDlg(Format('%d bytes read from the stream using the %s encoding!',
    [Size, Reader.CurrentEncoding.ClassName]), mtInformation, [mbOK], 0);
end;

procedure TMainForm.btStoreClick(Sender: TObject);
var
  Writer: TStreamWriter;
  I, J: Integer;
  Size: Int64;
  Line: String;
begin
  { Create a file stream and open a text writer for it. }
  Writer := TStreamWriter.Create(
    TFileStream.Create('local_file.txt', fmCreate),
    TEncoding.UTF8
  );

  { Do not flush after each writing, it is done automatically. }
  Writer.AutoFlush := false;

  { Set the custom new-line to be Unix-compatible. }
  Writer.NewLine := #$0A;

  { Start storing all the lines in the memo. }
  for I := 0 to mmText.Lines.Count - 1 do
  begin
    { Obtain the line. }
    Line := mmText.Lines[I];

    { Write char-by-char. }
    for J := 1 to Length(Line) do
      Writer.Write(Line[J]);

    { Add a line terminator. }
    Writer.WriteLine();
  end;

  { Flush the contents of the writer to the stream. }
  Writer.Flush();

  { Close the writer. }
  Writer.Close();

  { Obtain the size of the data. }
  Size := Writer.BaseStream.Size;

  { Free the writer and underlying stream. }
  Writer.BaseStream.Free;
  Writer.Free();

  MessageDlg(Format('%d bytes written to the stream using the %s encoding!',
    [Size, Writer.Encoding.ClassName]), mtInformation, [mbOK], 0);
end;
*)

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
	FOB : file of 0..255;
  FOKB: file of 0..1023;
  FOMB: file of 0..1048575;
  FOGB: file of 0..1073741823;
  FOTB: file of 0..1099511627775;
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
    fsuTBytes: try
      AssignFile(FOTB,aFileName);
      Reset(FOTB);
      Result := System.FileSize(FOTB);
    finally
      CloseFile(FOTB);
    end;
  end;
end;

function GetTemporaryPath: String;
var
  TempPath: {$IFDEF VER180}PAnsiChar{$ELSE}PWideChar{$ENDIF};
begin
  Result := '';
  TempPath := nil;
  try
    TempPath := AllocMem(Succ(MAX_PATH));

    if GetTempPath(MAX_PATH,TempPath) > MAX_PATH then
      raise Exception.Create('Erro ao obter o diretório temporário');

    Result := TempPath;
  finally
    FreeMem(TempPath);
  end;
end;

function GetTemporaryName(aPrefix: String; aExtension: String = ''): String;
begin
  Result := '';

  if Trim(aPrefix) = '' then
    raise Exception.Create('É necessário informar um prefixo para o nome');

  if (Trim(aExtension) <> '') and (Pos('.',aExtension) <> 1) then
    raise Exception.Create('A extensão, quando usada, tem de começar com um ponto');

  Result := aPrefix + IntToHex(GetTickCount,2) + aExtension;
end;
{ TODO -oCarlos Feitoza -cMELHORIA : A função de callback é retorna um valor
true ou false, isso futuramente pode ser usado para interromper o processamento.
Isso não está sendo feito abaixo, mas a função de callback dá esta possibilidade }
procedure ProcessFiles(aRootDir             : TFileName;
                       aFileMask            : String;
                       aProcessFilesCallBack: TProcessFilesCallBack;
                       aIncludeSubdirs      : Boolean = True);
{ ---------------------------------------------------------------------------- }
procedure SearchTree;
var
  SearchRec: TSearchRec;
  DosError: integer;
begin
  if not Assigned(aProcessFilesCallBack) then
    raise Exception.Create('O procedure "SearchTree" não pode ser executado sem uma função de callback');

  DosError := FindFirst(aFileMask, 0, SearchRec);
  while DosError = 0 do
  begin
    try
      aProcessFilesCallBack(SearchRec, False);
    except
      on Eoor: EOutOfResources do
      begin
        Eoor.Message := Eoor.Message + #13#10'A quantidade de arquivos localizados excede o limite de recursos do seu sistema. Favor limitar seu critério de busca escolhendo diretório(s) de nível mais interno';
        raise;
      end;
    end;

    DosError := FindNext(SearchRec);
  end;

  if aIncludeSubdirs then
  begin
    DosError := FindFirst('*.*', faDirectory, SearchRec);

    while DosError = 0 do
    begin
      if ((SearchRec.attr and faDirectory = faDirectory) and (SearchRec.name <> '.') and (SearchRec.name <> '..')) then
      begin
        ChDir(SearchRec.Name);
        SearchTree;
        ChDir('..');
        { A colocação da chamada da função de callback aqui tem um comportamento
        diferente de como seria caso ela fosse chamada antes do primeiro ChDir
        dentro deste bloco. Aqui, caso estejamos excluindo arquivos, garante que
        ao ser chamada com o segundo parâmetro = true, indicando que é um
        diretório, tenhamos o diretório vazio e possamos assim, excluí-lo também.
        Este comportamento pode não ser útil em outras situações e por isso você
        deve considerar futuramente executar este callback no início deste bloco
        também, identificando isso no callback }
        aProcessFilesCallBack(SearchRec, True);
      end;

      DosError := FindNext(SearchRec);
    end;
  end;
end;
{ ---------------------------------------------------------------------------- }
begin
	ChDir(aRootDir);
	SearchTree;
end;

end.
