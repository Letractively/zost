unit ZTO.Win32.Rtl.Common.StringUtils;

{$WEAKPACKAGEUNIT ON}

interface

function CompressString(const aUncompressedString: String): String;
function DecompressString(const aCompressedString: String): String;

implementation

uses ZLib
   , ZTO.Win32.Rtl.Common.Classes.Interposer;

function CompressString(const aUncompressedString: String): String;
begin

end;

function DecompressString(const aCompressedString: String): String;
begin

end;

end.
