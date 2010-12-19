unit ZTO.Win32.Rtl.Common.Classes.Interposer;

{$WEAKPACKAGEUNIT ON}

interface

uses SysUtils
   , Classes
   , ZLib
   , ZTO.Win32.Rtl.Sys.Types;

type
  { Interposer para inclusão de novas propriedades}
  TCompressionStream = class(ZLib.TCompressionStream)
  private
    FMoment: TZlibNotificationMoment;
    FSourceFileName: TFileName;
    FDestinationFileName: TFileName;
    FFileSize: Int64;
  public
    constructor Create(CompressionLevel: TCompressionLevel;
                       Dest            : TStream);

    property Moment: TZlibNotificationMoment read FMoment write FMoment;
    property SourceFileName: TFileName read FSourceFileName write FSourceFileName;
    property DestinationFileName: TFileName read FDestinationFileName write FDestinationFileName;
    property FileSize: Int64 read FFileSize write FFileSize;
  end;

  { Interposer para inclusão de novas propriedades}
  TDecompressionStream = class(ZLib.TDecompressionStream)
  private
    FMoment: TZlibNotificationMoment;
    FSourceFileName: TFileName;
    FDestinationFileName: TFileName;
    FFileSize: Int64;
  public
    constructor Create(Source: TStream);

    property Moment: TZlibNotificationMoment read FMoment write FMoment;
    property SourceFileName: TFileName read FSourceFileName write FSourceFileName;
    property DestinationFileName: TFileName read FDestinationFileName write FDestinationFileName;
    property FileSize: Int64 read FFileSize write FFileSize;
  end;

implementation

{ TCompressionStream }

constructor TCompressionStream.Create(CompressionLevel: TCompressionLevel;
                                      Dest            : TStream);
begin
  inherited;
  FMoment              := znmUnknown;
  FSourceFileName      := '';
  FDestinationFileName := '';
end;

{ TDecompressionStream }
constructor TDecompressionStream.Create(Source: TStream);
begin
  inherited;
  FMoment              := znmUnknown;
  FSourceFileName      := '';
  FDestinationFileName := '';
end;


end.
