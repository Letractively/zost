unit ZTO.Crypt.Utilities;

{$WEAKPACKAGEUNIT ON}

interface

uses ZTO.Crypt.Types;

function GetStringCheckSum(const aInputString       : String;
                                 aHashAlgorithms    : THashAlgorithms;
                                 aFinalHashAlgorithm: THashAlgorithm = haIgnore): String;

implementation

uses ZTO.Crypt.Hashes.Haval
   , ZTO.Crypt.Hashes.Md4
   , ZTO.Crypt.Hashes.Md5
   , ZTO.Crypt.Hashes.Ripemd128
   , ZTO.Crypt.Hashes.Ripemd160
   , ZTO.Crypt.Hashes.Sha1
   , ZTO.Crypt.Hashes.Sha256
   , ZTO.Crypt.Hashes.Sha512
   , ZTO.Crypt.Hashes.tiger
   , SysUtils;

function GetStringCheckSum(const aInputString       : String;
                                 aHashAlgorithms    : THashAlgorithms;
                                 aFinalHashAlgorithm: THashAlgorithm = haIgnore): String;
var
  HashDigest: array of Byte;
  TempString: String;
  i: Word;
begin
	TempString := aInputString;

  if haIgnore in aHashAlgorithms then
    Result := TempString;

  if haSha512 in aHashAlgorithms then
    with TDCP_sha512.Create(nil) do
      try
        SetLength(HashDigest,0);
        Init;
        Update(TempString[1],Length(TempString));
        SetLength(HashDigest,HashSize div 8);
        Final(HashDigest[0]);

        Result := '';
        for i := 0 to Pred(Length(HashDigest)) do  // convert it into a hex string
          Result := Result + IntToHex(HashDigest[i],2);

        TempString := Result;
      finally
        Free;
      end;

  if haSha384 in aHashAlgorithms then
    with TDCP_sha384.Create(nil) do
      try
        SetLength(HashDigest,0);
        Init;
        Update(TempString[1],Length(TempString));
        SetLength(HashDigest,HashSize div 8);
        Final(HashDigest[0]);

        Result := '';
        for i := 0 to Pred(Length(HashDigest)) do  // convert it into a hex string
          Result := Result + IntToHex(HashDigest[i],2);

        TempString := Result;
      finally
        Free;
      end;

  if haSha256 in aHashAlgorithms then
    with TDCP_sha256.Create(nil) do
      try
        SetLength(HashDigest,0);
        Init;
        Update(TempString[1],Length(TempString));
        SetLength(HashDigest,HashSize div 8);
        Final(HashDigest[0]);

        Result := '';
        for i := 0 to Pred(Length(HashDigest)) do  // convert it into a hex string
          Result := Result + IntToHex(HashDigest[i],2);

        TempString := Result;
      finally
        Free;
      end;

  if haSha1 in aHashAlgorithms then
    with TDCP_sha1.Create(nil) do
      try
        SetLength(HashDigest,0);
        Init;
        Update(TempString[1],Length(TempString));
        SetLength(HashDigest,HashSize div 8);
        Final(HashDigest[0]);

        Result := '';
        for i := 0 to Pred(Length(HashDigest)) do  // convert it into a hex string
          Result := Result + IntToHex(HashDigest[i],2);

        TempString := Result;
      finally
        Free;
      end;

  if haRipemd160 in aHashAlgorithms then
    with TDCP_ripemd160.Create(nil) do
      try
        SetLength(HashDigest,0);
        Init;
        Update(TempString[1],Length(TempString));
        SetLength(HashDigest,HashSize div 8);
        Final(HashDigest[0]);

        Result := '';
        for i := 0 to Pred(Length(HashDigest)) do  // convert it into a hex string
          Result := Result + IntToHex(HashDigest[i],2);

        TempString := Result;
      finally
        Free;
      end;

  if haRipemd128 in aHashAlgorithms then
    with TDCP_ripemd128.Create(nil) do
      try
        SetLength(HashDigest,0);
        Init;
        Update(TempString[1],Length(TempString));
        SetLength(HashDigest,HashSize div 8);
        Final(HashDigest[0]);

        Result := '';
        for i := 0 to Pred(Length(HashDigest)) do  // convert it into a hex string
          Result := Result + IntToHex(HashDigest[i],2);

        TempString := Result;
      finally
        Free;
      end;

  if haMd5 in aHashAlgorithms then
    with TDCP_md5.Create(nil) do
      try
        SetLength(HashDigest,0);
        Init;
        Update(TempString[1],Length(TempString));
        SetLength(HashDigest,HashSize div 8);
        Final(HashDigest[0]);

        Result := '';
        for i := 0 to Pred(Length(HashDigest)) do  // convert it into a hex string
          Result := Result + IntToHex(HashDigest[i],2);

        TempString := Result;
      finally
        Free;
      end;

  if haMd4 in aHashAlgorithms then
    with TDCP_md4.Create(nil) do
      try
        SetLength(HashDigest,0);
        Init;
        Update(TempString[1],Length(TempString));
        SetLength(HashDigest,HashSize div 8);
        Final(HashDigest[0]);

        Result := '';
        for i := 0 to Pred(Length(HashDigest)) do  // convert it into a hex string
          Result := Result + IntToHex(HashDigest[i],2);

        TempString := Result;
      finally
        Free;
      end;

  if haHaval in aHashAlgorithms then
    with TDCP_haval.Create(nil) do
      try
        SetLength(HashDigest,0);
        Init;
        Update(TempString[1],Length(TempString));
        SetLength(HashDigest,HashSize div 8);
        Final(HashDigest[0]);

        Result := '';
        for i := 0 to Pred(Length(HashDigest)) do  // convert it into a hex string
          Result := Result + IntToHex(HashDigest[i],2);

        TempString := Result;
      finally
        Free;
      end;

  if haTiger in aHashAlgorithms then
    with TDCP_tiger.Create(nil) do
      try
        SetLength(HashDigest,0);
        Init;
        Update(TempString[1],Length(TempString));
        SetLength(HashDigest,HashSize div 8);
        Final(HashDigest[0]);

        Result := '';
        for i := 0 to Pred(Length(HashDigest)) do  // convert it into a hex string
          Result := Result + IntToHex(HashDigest[i],2);

        TempString := Result;
      finally
        Free;
      end;

  if (SizeOf(aHashAlgorithms) > 1) and (aFinalHashAlgorithm <> haIgnore) then
    Result := GetStringCheckSum(Result,[aFinalHashAlgorithm]);
end;

end.
