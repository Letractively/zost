unit UObjectFile;

interface

uses
  	Classes, SysUtils;

type
	{ Main class Object File. All file structures must inherit it }
	{ Cada subclasse na estrutura de arquivo deve ser derivada de }
	{ TPersistent. TCollection e TCollectionItem, p.e., são       }
	TObjectFile = class(TComponent)
    protected
        procedure Clear; virtual; abstract;
    public
        procedure LoadFromBinaryFile(const aFileName: TFileName);
        procedure LoadFromTextualRepresentation(const aTextualRepresentation: String);
        procedure SaveToBinaryFile(const aFileName: TFileName);
        function ToString: String;
        function ToXML: String;
    end;

implementation

uses
	TypInfo, RTLConsts, XMLIntf, XMLDoc;

function ObjectBinaryToXML(Input: TStream): IXMLDocument;
var
	Reader: TReader;
  	ObjectName, PropName: string; //for error reporting

  	procedure ConvertProperty(const Parent: IXMLNode); forward;

  	procedure ConvertValue(Current: IXMLNode; Independence: Boolean);
    	function ConvertBinary: string;
    	const
      		BytesPerLine = 32;
    	var
      		I: Integer;
      		Count: Longint;
      		Buffer: array[0..BytesPerLine - 1] of Char;
      		Text: array[0..BytesPerLine * 2 - 1] of Char;
      		Temp: string;
    	begin
      		Reader.ReadValue;
      		Reader.Read(Count, SizeOf(Count));
            Result := '';
            while Count > 0 do
            begin
	            if Count > BytesPerLine then
                	I := BytesPerLine
                else
                	I := Count;
                Reader.Read(Buffer, I);
                BinToHex(Buffer, Text, I);
                SetString(Temp, Text, I * 2);
                Result := Result + Temp;
                Dec(Count, I);
                if Count > 0 then
                    Result := Result + SLineBreak;
        	end;
    	end;

    	function ConvertSet: string;
    	var
      		S: string;
    	begin
      		Reader.ReadValue;
      		Result := '';
      		while True do
      		begin
                S := Reader.ReadStr;
                if S = '' then
                	Break;
                if Result <> '' then
                	Result := Result + ', ';
                Result := Result + S;
            end;
        end;

        procedure ConvertDate;
        var
        	D: TDateTime;
        begin
            D := Reader.ReadDate;
            Current.Attributes['value'] := FloatToStr(D);
            Current.Attributes['date'] := DateTimeToStr(D);
	    end;

        procedure ConvertCollection;
        var
	        Item: IXMLNode;
        begin
            Reader.ReadValue;
            while not Reader.EndOfList do
            begin
	            Item := Current.AddChild('item');
    	        if Reader.NextValue in [vaInt8, vaInt16, vaInt32] then
		            Item.Attributes['id'] := Reader.ReadInteger;
        	    Reader.CheckValue(vaList);
            	while not Reader.EndOfList do
                	ConvertProperty(Item);
	            Reader.ReadListEnd;
            end;
            Reader.ReadListEnd;
        end;

        procedure SetType(const s: string);
        begin
	        if Independence then
    	    begin
        		if s <> '' then
			        Current := Current.AddChild(s)
		        else
        			Current := Current.AddChild('ident')
		    end
        	else if s <> '' then
		        Current.Attributes['type'] := s;
        end;

  	begin
    	case Reader.NextValue of
  	  		vaList: begin
      			SetType('list');
                Reader.ReadValue;
                while not Reader.EndOfList do
                    ConvertValue(Current, True);
                Reader.ReadListEnd;
            end;
            vaInt8, vaInt16, vaInt32: begin
                SetType('integer');
                Current.Attributes['value'] := IntToStr(Reader.ReadInteger);
            end;
            vaInt64: begin
                SetType('integer');
                Current.Attributes['value'] := IntToStr(Reader.ReadInt64);
            end;
            vaExtended: begin
                SetType('real');
                Current.Attributes['value'] := FloatToStr(Reader.ReadFloat);
            end;
            vaSingle: begin
                SetType('real');
                Current.Attributes['precision'] := 'single';
                Current.Attributes['value'] := FloatToStr(Reader.ReadFloat);
            end;
            vaCurrency: begin
                SetType('real');
                Current.Attributes['precision'] := 'currency';
                Current.Attributes['value'] := CurrToStr(Reader.ReadCurrency);
            end;
            vaDate: begin
                SetType('real');
                Current.Attributes['precision'] := 'date';
                ConvertDate;
            end;
            vaWString, vaUTF8String: begin
                SetType('string');
                Current.Attributes['value'] := Reader.ReadWideString;
            end;
            vaString, vaLString: begin
                SetType('string');
                Current.Attributes['charset'] := 'locale';
                Current.Attributes['value'] := Reader.ReadString;
            end;
            vaIdent, vaFalse, vaTrue, vaNil, vaNull: begin
                SetType('');
                Current.Attributes['value'] := Reader.ReadIdent;
            end;
            vaBinary: begin
                SetType('binary');
                Current.Text := ConvertBinary
            end;
            vaSet: begin
                SetType('set');
                Current.Attributes['value'] := ConvertSet;
            end;
            vaCollection: begin
                SetType('collection');
                ConvertCollection;
            end;
    		else
      			raise EReadError.CreateFmt(sPropertyException, [ObjectName, DotSep, PropName, IntToStr(Ord(Reader.NextValue))]);
        end;
    end;

	procedure ConvertProperty(const Parent: IXMLNode);
  	var
    	Current: IXMLNode;
  	begin
    	PropName := Reader.ReadStr;
    	Current := Parent.AddChild(PropName);
    	ConvertValue(Current, False);
  	end;

  	procedure ConvertObject(const Parent: IXMLNode);
  	var
    	Current: IXMLNode;
    	ClassName: string;
    	Flags: TFilerFlags;
    	Position: Integer;
  	begin
    	Current := Parent.AddChild('object');

        Reader.ReadPrefix(Flags, Position);
        ClassName := Reader.ReadStr;
        ObjectName := Reader.ReadStr;

    	if ObjectName <> '' then
      		Current.Attributes['name'] := ObjectName;

    	Current.Attributes['class'] := ClassName;

    	if ffInherited in Flags then
      		Current.Attributes['kind'] := 'inherited'
    	else if ffInline in Flags then
     	 	Current.Attributes['kind'] := 'inline';

    	if ffChildPos in Flags then
      		Current.Attributes['position'] := IntToStr(Position);

    	while not Reader.EndOfList do
        	ConvertProperty(Current);

        Reader.ReadListEnd;
    	while not Reader.EndOfList do
    		ConvertObject(Current);
    	Reader.ReadListEnd;
  	end;

var
  	SaveSeparator: Char;
begin
	Reader := TReader.Create(Input, 4096);
    SaveSeparator := DecimalSeparator;
    DecimalSeparator := '.';
    try
    	Result := NewXMLDocument;
    	Result.Encoding := 'UTF-8';
    	Reader.ReadSignature;
//   	ConvertObject(Result.AddChild('dfm'));
    	ConvertObject(Result.AddChild('ObjectFile'));
	finally
    	DecimalSeparator := SaveSeparator;
    	Reader.Free;
  	end;
end;

{ TObjectFile }

{$HINTS OFF}
procedure TObjectFile.LoadFromBinaryFile(const aFileName: TFileName);
begin
	if FileExists(aFileName) then
    begin
    	Clear;
		Self := TObjectFile(ReadComponentResFile(aFileName, Self));
    end;
end;{$HINTS ON}

procedure TObjectFile.SaveToBinaryFile(const aFileName: TFileName);
begin
	WriteComponentResFile(aFileName,Self);
end;
{$HINTS OFF}
procedure TObjectFile.LoadFromTextualRepresentation(const aTextualRepresentation: String);
var
	BinStream:TMemoryStream;
  	StrStream: TStringStream;
begin
    StrStream := TStringStream.Create(aTextualRepresentation);
    try
	    BinStream := TMemoryStream.Create;
    	try
		    Strstream.Seek(0, sofrombeginning);
		    ObjectTextToBinary(strStream,binStream);
            BinStream.Seek(0, soFromBeginning);
            Self := BinStream.ReadComponent(Self) as TObjectFile;
	    finally
    		BinStream.Free
	    end;
    finally
    	StrStream.Free;
    end;
end;{$HINTS ON}

function TObjectFile.ToString: String;
var
    BinStream: TMemoryStream;
    StrStream: TStringStream;
    s: string;
begin
    BinStream := TMemoryStream.Create;
    try
	    StrStream := TStringStream.Create(s);
        try
            BinStream.WriteComponent(Self);
            BinStream.Seek(0, soFromBeginning);
            ObjectBinaryToText(BinStream, StrStream);
            StrStream.Seek(0, soFromBeginning);
            Result:= StrStream.DataString;
        finally
            StrStream.Free;
        end;
    finally
	    BinStream.Free
    end;
end;

function TObjectFile.ToXML: String;
var
    BinStream: TMemoryStream;
    XML: IXMLDocument;
begin
    BinStream := TMemoryStream.Create;
    try
        BinStream.WriteComponent(Self);
        BinStream.Seek(0, soFromBeginning);
        XML := ObjectBinaryToXML(BinStream);
        Result:= XML.XML.Text;
    finally
	    BinStream.Free
    end;
end;

end.
