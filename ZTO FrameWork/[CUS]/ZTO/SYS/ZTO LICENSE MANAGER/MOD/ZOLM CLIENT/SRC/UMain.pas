unit UMain;

interface

function GetAuthorizationFile(aSoftwareId: PChar): PChar;

implementation

uses SysUtils
   , Messages
   , Windows
   , HttpProt;

const
  ZOLM_ROOT = 'http://zolm.zettaomnis.co.cc';

type
  THTTPGetData = class
  protected
    FHttpCli: THttpCli;
    FReturnedData: String;
    procedure HttpRequestDone(Sender   : TObject;
                              RqType   : THttpRequest;
                              ErrorCode: Word);

    procedure HttpDocData(Sender: TObject;
                          Buffer: Pointer;
                          Len   : Integer);
  public
    constructor Create(aUrl: ShortString);
    destructor Destroy; override;
    function Execute: String;
  end;


function GetAuthorizationFile(aSoftwareId: PChar): PChar;
begin
  with THTTPGetData.Create(ZOLM_ROOT + '/GetAuthorizations.php?SID=' + UpperCase(aSoftwareId)) do
    try
      Result := PChar(Execute);
    finally
      Free;
    end;
end;

{ THTTPGetData }

constructor THTTPGetData.Create(aUrl: ShortString);
begin
  FHttpCli               := THttpCli.Create(nil);
  FHttpCli.OnRequestDone := HttpRequestDone;
  FHttpCli.OnDocData     := HttpDocData;
  FHttpCli.URL           := aUrl;
end;

destructor THTTPGetData.Destroy;
begin
  if Assigned(FHttpCli) then
    FreeAndNil(FHttpCli);

  inherited;
end;

function THTTPGetData.Execute: String;
begin
  FReturnedData := '';
  FHttpCli.GetASync;
  FHttpCli.CtrlSocket.MessageLoop;
  Result := FReturnedData;
end;

procedure THTTPGetData.HttpDocData(Sender: TObject; Buffer: Pointer; Len: Integer);
begin
  while Len > 0 do                 { While we have bytes...   }
  begin
    FReturnedData := FReturnedData + PChar(Buffer)^;
    Buffer := PChar(Buffer) + 1;   { Skip to next byte        }
    Len    := Len - 1;             { Count down the byte      }
  end;
end;

procedure THTTPGetData.HttpRequestDone(Sender: TObject; RqType: THttpRequest; ErrorCode: Word);
begin
  { Check status }
  if ErrorCode <> 0 then
    FReturnedData := 'Falhou. Erro #' + IntToStr(ErrorCode);
    
  { Break message loop we called from the execute method }
  PostMessage(FHttpCli.CtrlSocket.Handle, WM_QUIT, 0, 0);
end;

end.
