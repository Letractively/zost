unit UGetURLResponse;

interface

function GetURLResponse(const aUrl: ShortString): String;

implementation

uses
	HttpProt, Classes;

type
    THttpCli = class(HttpProt.THttpCli)
    private
    	FURLResponse: String;
	    procedure DoDocData(Sender: TObject; Buffer: Pointer; Len: Integer);
    public
        property URLResponse: String read FURLResponse;
        constructor Create(aOwner: TComponent); override;
    end;

function GetURLResponse(const aUrl: ShortString): String;
begin
    with THttpCli.Create(nil) do
	    try
        	URL := aUrl;
            Get;
            Result := URLResponse;
        finally
        	Abort;
            Close;
            Free;
        end;
end;

{ THttpCli }

constructor THttpCli.Create(aOwner: TComponent);
begin
  	inherited;
    OnDocData := DoDocData;
end;

procedure THttpCli.DoDocData(Sender: TObject; Buffer: Pointer; Len: Integer);
begin
	FURLResponse := PChar(Buffer);
end;

end.
