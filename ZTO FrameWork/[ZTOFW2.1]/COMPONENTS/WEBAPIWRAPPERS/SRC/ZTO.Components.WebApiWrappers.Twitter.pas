unit ZTO.Components.WebApiWrappers.Twitter;

interface

uses Classes
   , ComCtrls
   , OverbyteIcsHttpProt;

type
  TTwitterRequest = (trNone
                    ,trRequestAuthTokens
                    ,trRequestPINNumber
                    ,trRequestAccessData
                    ,trRequestUserDetails
                    ,trPostTweet);

  TStreamToFree = (stfNone, stfRequest, stfResponse, stfBoth);

  TTwitterRequestDone = procedure (aRequest: TTwitterRequest; aHTTPStatus: SmallInt; aReceivedResult, aReceivedHeader: TStringList) of object;

  TTwitter = class(TComponent)
  private
    FConsumerKey: String;       { Para a aplicação }
    FConsumerSecret: String;    { Para a aplicação }
    FOAuthToken: String;        { Para a autenticação }
    FOAuthTokenSecret: String;  { Para a autenticação }
    FAccessToken: String;       { Para o acesso }
    FAccessTokenSecret: String; { Para o acesso }
    FUserID: String;
    FUserScreenName: String;
    FUserName: String;
    FUserImageUrl: String;
    FUserFollowers: String;
    FUserFriends: String;
    FUserLocation: String;
    FPINNumber: String;
    FTimeStamp: String;
    FNonce: String;
    FSignBase: String;
    FSignature: String;
    FExtraHeader: String;
    FHTTPClient: THttpCli;
    FReceivedResult: TStringList;
    FReceivedHeader: TStringList;
    FLastTwitterRequest: TTwitterRequest;
    FLastHTTPStatus: SmallInt;
    FTwitterRequestDone: TTwitterRequestDone;
    procedure InternalTwitterRequestDone;
    procedure FillAuthTokens(const aAuthVariables: String);
    procedure FillAccessData(const aAccessVariables: String);
    procedure FillUserDetails(const aUserXML: String);
    procedure GetSignBase(aMethod, aUrl, aExtraParams: string);
    procedure GetNonce;
    procedure GetTimeStamp;
    procedure GetSignature;
    procedure FreeHTTPStreams(aStreamToFree: TStreamToFree = stfBoth);
    procedure SetProxy(const Value: String);
    procedure SetProxyAuth(const Value: THttpAuthType);
    procedure SetProxyConnection(const Value: String);
    procedure SetProxyPassword(const Value: String);
    procedure SetProxyPort(const Value: String);
    procedure SetProxyUsername(const Value: String);
    function GetProxy: String;
    function GetProxyAuth: THttpAuthType;
    function GetProxyConnection: String;
    function GetProxyPassword: String;
    function GetProxyPort: String;
    function GetProxyUsername: String;
    function GetHasAccessTokens: Boolean;
    procedure ClearReceiveBuffers;
  public
    constructor Create(aOwner: TComponent); override;
    destructor Destroy; override;

    procedure IndentifyApp(aConsumerKey, aConsumerSecret: String);
    procedure IdentifyUser(aToken, aTokenSecret: String);
    procedure RequestToken;
    procedure RequestPINNumber;
    procedure RequestAccessData(const aPIN: String);
    procedure RequestUserDetails(const aUserID: String = '');
    procedure SendTweet(aMessage: String);
    procedure HTTPClientHeaderEnd(Sender: TObject);
    procedure HTTPClientRequestDone(Sender: TObject; RqType: THttpRequest; ErrCode: Word);
    procedure HTTPClientBeforeHeaderSend(Sender: TObject; const Method: string; Headers: TStrings);

    property ConsumerKey: String read FConsumerKey;
    property ConsumerSercret: String read FConsumerSecret;
    property OAuthToken: String read FOAuthToken;
    property OAuthTokenSecret: String read FOAuthTokenSecret;
    property AccessToken: String read FAccessToken;
    property AccessTokenSecret: String read FAccessTokenSecret;
    property HasAccessTokens: Boolean read GetHasAccessTokens;
    property UserID: String read FUserID;
    property UserScreenName: String read FUserScreenName;
    property UserName: String read FUserName;
    property UserLocation: String read FUserLocation;
    property UserImageUrl: String read FUserImageUrl;
    property UserFollowers: String read FUserFollowers;
    property UserFriends: String read FUserFriends;
  published
    property OnTwitterRequestDone: TTwitterRequestDone read FTwitterRequestDone write FTwitterRequestDone;
    property Proxy: String read GetProxy write SetProxy;
    property ProxyAuth: THttpAuthType read GetProxyAuth write SetProxyAuth;
    property ProxyConnection: String read GetProxyConnection write SetProxyConnection;
    property ProxyPassword: String read GetProxyPassword write SetProxyPassword;
    property ProxyPort: String read GetProxyPort write SetProxyPort;
    property ProxyUsername: String read GetProxyUsername write SetProxyUsername;
  end;

implementation

uses SysUtils
   , Windows
   , OverbyteIcsSha1
   , OverbyteIcsMimeUtils
   , ZTO.Win32.Rtl.Common.StringUtils
   , ShellAPI
   , XMLDoc
   , XMLIntf
   , UrlMon;

const
  REQUESTTOKENURL        = 'http://api.twitter.com/oauth/request_token';
  REQUESTACCESSURL       = 'http://api.twitter.com/oauth/access_token';
  SSLREQUESTACCESSURL    = 'https://api.twitter.com/oauth/access_token';
  REQUESTTWITURL         = 'http://api.twitter.com/1/statuses/update.xml';
  REQUESTUSERDETAILSURL  = 'http://api.twitter.com/1/users/show.xml';

function GetUTCUnixTime: Int64;
var
  UTC: TSystemTime;
  DateTime  : TDateTime;
begin
  GetSystemTime(UTC);
  DateTime := SystemTimeToDateTime(UTC);
  Result := Round((DateTime - 25569) * 86400);
end;

{ TTWitter }

procedure TTwitter.ClearReceiveBuffers;
begin
  FReceivedResult.Clear;
  FReceivedHeader.Clear;
end;

constructor TTWitter.Create(aOwner: TComponent);
begin
  inherited;
  FConsumerKey := '';
  FConsumerSecret := '';
  FExtraHeader := '';

  FReceivedResult := TStringList.Create;
  FReceivedHeader := TStringList.Create;

  FHTTPClient := THttpCli.Create(Self);
  with FHTTPClient do
  begin
    OnHeaderEnd        := HTTPClientHeaderEnd;
    OnRequestDone      := HTTPClientRequestDone;
    OnBeforeHeaderSend := HTTPClientBeforeHeaderSend;
  end;
end;

destructor TTWitter.Destroy;
begin
  FHTTPClient.Free;
  FReceivedHeader.Free;
  FReceivedResult.Free;
  inherited;
end;

procedure TTwitter.SetProxy(const Value: String);
begin
  FHTTPClient.Proxy := Value;
end;

procedure TTwitter.SetProxyAuth(const Value: THttpAuthType);
begin
  FHTTPClient.ProxyAuth := Value;
end;

procedure TTwitter.SetProxyConnection(const Value: String);
begin
  FHTTPClient.ProxyConnection := Value;
end;

procedure TTwitter.SetProxyPassword(const Value: String);
begin
  FHTTPClient.ProxyPassword := Value;
end;

procedure TTwitter.SetProxyPort(const Value: String);
begin
  FHTTPClient.ProxyPort := Value;
end;

procedure TTwitter.SetProxyUsername(const Value: String);
begin
  FHTTPClient.ProxyUsername := Value;
end;

function TTwitter.GetHasAccessTokens: Boolean;
begin
  Result := (FAccessToken <> '') and (FAccessTokenSecret <> '');
end;

procedure TTwitter.HTTPClientBeforeHeaderSend(Sender: TObject; const Method: string; Headers: TStrings);
begin
  { Adiciona o header extra à solicitação imediatamente antes do envio do header }
  if FExtraHeader <> '' then
  begin
    Headers.Add(FExtraHeader);
    FExtraHeader := '';
  end;
end;

procedure TTwitter.HTTPClientHeaderEnd(Sender: TObject);
begin
  FReceivedHeader.Assign(THttpCli(Sender).RcvdHeader);
  THttpCli(Sender).RcvdHeader.Clear; { carlos }
end;

procedure TTwitter.HTTPClientRequestDone(Sender: TObject; RqType: THttpRequest; ErrCode: Word);
begin
  if (RqType = httpGET) or (RqType = httpPOST) then
  begin
    FLastHTTPStatus := FHTTPClient.StatusCode;

    { Salva o resultado em FResultStrings }
    THttpCli(Sender).RcvdStream.Seek(0,soFromBeginning);
    FReceivedResult.LoadFromStream(THttpCli(Sender).RcvdStream);
    FreeHTTPStreams;
    InternalTwitterRequestDone;
  end;
end;

procedure TTwitter.InternalTwitterRequestDone;
begin
  if FLastHTTPStatus = 200 then
  begin
    case FLastTwitterRequest of
      trNone: ;
      trRequestAuthTokens: FillAuthTokens(FReceivedResult.Text);
      trRequestPINNumber: { Não usado por enquanto };
      trRequestAccessData: FillAccessData(FReceivedResult.Text);
      trRequestUserDetails: FillUserDetails(FReceivedResult.Text);
      trPostTweet: { Não usado por enquanto };
    end;
  end;

  if Assigned(FTwitterRequestDone) then
    FTwitterRequestDone(FLastTwitterRequest,FLastHTTPStatus,FReceivedResult,FReceivedHeader);
end;

procedure TTwitter.IdentifyUser(aToken, aTokenSecret: String);
begin
  FAccessToken       := aToken;
  FAccessTokenSecret := aTokenSecret;
  FOAuthToken        := FAccessToken;
  FOAuthTokenSecret  := FAccessTokenSecret;
end;

{ Indentifica a aplicação de forma que o twitter saiba que é uma aplicação
registrada para uso de sua API }
procedure TTWitter.IndentifyApp(aConsumerKey, aConsumerSecret: String);
begin
  FConsumerKey := aConsumerKey;
  FConsumerSecret := aConsumerSecret;
end;

procedure TTwitter.GetTimeStamp;
begin
  FTimeStamp := {$IFDEF VER180}IntToStr{$ELSE}UIntToStr{$ENDIF}(GetUTCUnixTime);
end;

procedure TTwitter.GetNonce;
var
  i: Integer;
begin
  FNonce := '';

  for i := 1 to 20 do
    FNonce := FNonce + Chr(Random(26)+65);
end;

procedure TTwitter.GetSignBase(aMethod, aUrl, aExtraParams: string);
var
  OAuthVerifier, OAuthToken, OAuthCallBack: string;
begin
  if FPINNumber  <> '' then
    OAuthVerifier := 'oauth_verifier=' + FPINNumber + '&'
  else
    OAuthVerifier := '';

  OAuthToken := 'oauth_token=' + FOAuthToken + '&';

  if FLastTwitterRequest <> trPostTweet then
    OAuthCallBack := 'oauth_callback=oob&';

  FSignBase := aMethod + '&'
             + URLEncode(aUrl) + '&'
             + URLEncode(OAuthCallBack
                        +'oauth_consumer_key=' + FConsumerKey + '&'
                        +'oauth_nonce=' + FNonce + '&'
                        +'oauth_signature_method=HMAC-SHA1' + '&'
                        +'oauth_timestamp=' + FTimeStamp + '&'
                        +OAuthToken
                        +OAuthVerifier // access PIN if any
                        +'oauth_version=1.0'
                        +aExtraParams);
end;

procedure TTwitter.GetSignature;
var
  SignKey: string;
begin
  SignKey   := URLEncode(FConsumerSecret) + '&' + URLEncode(FOAuthTokenSecret);
  FSignature := String(Base64Encode(HMAC_SHA1_EX(AnsiString(FSignBase),AnsiString(SignKey))));
end;

procedure TTwitter.FillAuthTokens(const aAuthVariables: String);
begin
  if (aAuthVariables <> '') and (Pos('oauth_callback_confirmed=true',aAuthVariables) <> 0) then
  begin
    with TStringList.Create do
      try
        Text := StringReplace(aAuthVariables,'&',#13#10,[rfReplaceAll]);

        FOAuthToken := Values['oauth_token'];
        FOAuthTokenSecret := Values['oauth_token_secret'];

        if (FOAuthToken = '') or (FOAuthTokenSecret = '') then
        begin
          FOAuthToken := '';
          FOAuthTokenSecret := '';
        end;

      finally
        Free;
      end;
  end;
end;

procedure TTwitter.FillUserDetails(const aUserXML: String);
var
  XMLDocument: TXMLDocument;
begin
  XMLDocument := nil;
  try
    XMLDocument := TXMLDocument.Create(Self);
    XMLDocument.LoadFromXML(AnsiString(aUserXML));

    FUserID := XMLDocument.DocumentElement.ChildNodes['id'].Text;
    FUserName := XMLDocument.DocumentElement.ChildNodes['name'].Text;
    FUserScreenName := XMLDocument.DocumentElement.ChildNodes['screen_name'].Text;
    FUserLocation := XMLDocument.DocumentElement.ChildNodes['location'].Text;
    FUserImageUrl := XMLDocument.DocumentElement.ChildNodes['profile_image_url'].Text;
    FUserFollowers := XMLDocument.DocumentElement.ChildNodes['followers_count'].Text;
    FUserFriends := XMLDocument.DocumentElement.ChildNodes['friends_count'].Text;
  finally
    XMLDocument.Free;
  end;
end;

procedure TTwitter.FillAccessData(const aAccessVariables: String);
begin
  if (aAccessVariables <> '') and (Pos('user_id',aAccessVariables) <> 0) then
  begin
    with TStringList.Create do
      try
        Text := StringReplace(aAccessVariables,'&',#13#10,[rfReplaceAll]);

        { Quando estamos decodificando os dados de acesso, não precisamos mais
        de um PIN }
        FPINNumber         := '';
        FAccessToken       := Values['oauth_token'];
        FAccessTokenSecret := Values['oauth_token_secret'];
        FUserID            := Values['user_id'];

        if (FAccessToken = '') or (FAccessTokenSecret = ''){ or (FAccessUserID = '') or (FAccessScreenName = '')} then
        begin
          FAccessToken := '';
          FAccessTokenSecret := '';
        end
        else
        begin
          FOAuthToken := FAccessToken;
          FOAuthTokenSecret := FAccessTokenSecret;
        end;

      finally
        Free;
      end;
  end;
end;

procedure TTwitter.FreeHTTPStreams(aStreamToFree: TStreamToFree = stfBoth);
begin
  case aStreamToFree of
    stfNone: { Não faz nada };
    stfRequest: if Assigned(FHTTPClient) and Assigned(FHTTPClient.SendStream) then
    begin
      FHTTPClient.SendStream.Free;
      FHTTPClient.SendStream := nil;
    end;
    stfResponse: if Assigned(FHTTPClient) and Assigned(FHTTPClient.RcvdStream) then
    begin
      FHTTPClient.RcvdStream.Free;
      FHTTPClient.RcvdStream := nil;
    end;
    stfBoth: begin
      FreeHTTPStreams(stfRequest);
      FreeHTTPStreams(stfResponse);
    end;
  end;
end;

procedure TTwitter.RequestToken;
begin
  FLastTwitterRequest := trRequestAuthTokens;

  FOAuthToken        := '';
  FOAuthTokenSecret  := '';
  FAccessToken       := '';
  FAccessTokenSecret := '';

  { A partir deste ponto a meta é montar a variável FExtraHeader, que será usada
  no manipulador do evento OnBeforeHeaderSend de FHTTPClient }

  GetNonce;                              { Preenche FNonce }
  GetTimeStamp;                          { Preenche FTimeStamp}
  GetSignBase('GET',REQUESTTOKENURL,''); { Preenche FSignBase }
  GetSignature;                          { Preenche FSignature }

  { Após obter o valor de todas as variáveis acima, usa-se estas para compor o
  header que será processado no manipulador do evento OnBeforeHeaderSend de
  FHTTPClient }
  FExtraHeader := 'Authorization: OAuth oauth_nonce="' + FNonce + '"' +
                  ', oauth_callback="oob"' +
                  ', oauth_token="' + FOAuthToken + '"' +
                  ', oauth_signature_method="HMAC-SHA1"' +
                  ', oauth_timestamp="' + FTimeStamp + '"' +
                  ', oauth_consumer_key="' + FConsumerKey + '"' +
                  ', oauth_signature="' + URLEncode(FSignature) + '"' +
                  ', oauth_version="1.0"';

  with FHTTPClient do
  begin
    RcvdStream := TMemoryStream.Create;
    SendStream := TMemoryStream.Create;

    Accept     := '*/*';
    URL        := REQUESTTOKENURL;

    ClearReceiveBuffers;

    try
      GetAsync;
    except
      on E: Exception do
      begin
        FreeHTTPStreams; { originalmente era apenas o stream de recebimento }
        FReceivedResult.Text := 'ERRO: '+ E.Message;
        FLastHttpStatus := StatusCode;
        InternalTwitterRequestDone;
      end;
    end; // try
  end; // with
end;

{ Não precisa de autenticação. O extra header está intacto }
procedure TTwitter.RequestUserDetails(const aUserID: String = '');
var
  UserID: String;
begin
  FLastTwitterRequest := trRequestUserDetails;

  GetNonce;                                    { Preenche FNonce }
  GetTimeStamp;                                { Preenche FTimeStamp}
  GetSignBase('GET',REQUESTUSERDETAILSURL,''); { Preenche FSignBase }
  GetSignature;                                { Preenche FSignature }

  if aUserID = '' then
    UserID := '?user_id=' + FUserID
  else
    UserID := '?user_id=' + aUserID;

  FExtraHeader := 'Authorization: OAuth oauth_nonce="' + FNonce + '"' +
                  ', oauth_token="' + FAccessToken + '"' +
                  ', oauth_signature_method="HMAC-SHA1"' +
                  ', oauth_timestamp="' + FTimeStamp + '"' +
                  ', oauth_consumer_key="' + FConsumerKey + '"' +
                  ', oauth_signature="' + URLEncode(FSignature) + '"' +
                  ', oauth_version="1.0"';

  with FHTTPClient do
  begin
    RcvdStream := TMemoryStream.Create;
    SendStream := TMemoryStream.Create;

    URL        := REQUESTUSERDETAILSURL + UserID;

    ClearReceiveBuffers;

    try
      GetAsync;
    except
      on E: Exception do
      begin
        FreeHTTPStreams;
        FReceivedResult.Text := 'ERRO: '+ E.Message;
        FLastHttpStatus := StatusCode;
        InternalTwitterRequestDone;
      end;
    end;
  end;
end;

{ Precisa de autenticação. Note que ao gerar SignBase estamos passando os
parâmetros que devem fazer parte da assinatura, já que a autorização é requerida }
procedure TTwitter.SendTweet(aMessage: String);
var
  Tweet: AnsiString;
begin
  FLastTwitterRequest := trPostTweet;

  GetNonce;                                                            { Preenche FNonce }
  GetTimeStamp;                                                        { Preenche FTimeStamp}
  GetSignBase('POST',REQUESTTWITURL,'&status=' + URLEncode(aMessage)); { Preenche FSignBase }
  GetSignature;                                                        { Preenche FSignature }

  Tweet := 'status=' + AnsiString(URLEncode(aMessage));

  FExtraHeader := 'Authorization: OAuth oauth_nonce="' + FNonce + '"' +
                  ', oauth_token="' + FAccessToken + '"' +
                  ', oauth_signature_method="HMAC-SHA1"' +
                  ', oauth_timestamp="' + FTimeStamp + '"' +
                  ', oauth_consumer_key="' + FConsumerKey + '"' +
                  ', oauth_signature="' + URLEncode(FSignature) + '"' +
                  ', oauth_version="1.0"';


  with FHTTPClient do
  begin
    RcvdStream := TMemoryStream.Create;
    SendStream := TMemoryStream.Create;

    SendStream.Write(Tweet[1], Length(Tweet));
    SendStream.Seek(0, soFromBeginning);
    URL        := REQUESTTWITURL;

    ClearReceiveBuffers;

    try
      PostAsync;
    except
      on E: Exception do
      begin
        FreeHTTPStreams;
        FReceivedResult.Text := 'ERRO: '+ E.Message;
        FLastHttpStatus := StatusCode;
        InternalTwitterRequestDone;
      end;
    end;
  end;
end;

function TTwitter.GetProxy: String;
begin
  Result := FHTTPClient.Proxy;
end;

function TTwitter.GetProxyAuth: THttpAuthType;
begin
  Result := FHTTPClient.ProxyAuth;
end;

function TTwitter.GetProxyConnection: String;
begin
  Result := FHTTPClient.ProxyConnection;
end;

function TTwitter.GetProxyPassword: String;
begin
  Result := FHTTPClient.ProxyPassword;
end;

function TTwitter.GetProxyPort: String;
begin
  Result := FHTTPClient.ProxyPort;
end;

function TTwitter.GetProxyUsername: String;
begin
  Result := FHTTPClient.ProxyUsername;
end;

procedure TTwitter.RequestPINNumber;
begin
  FLastTwitterRequest := trRequestPINNumber;

  ShellExecute(0,nil,PChar('https://twitter.com/oauth/authorize?oauth_token=' + FOAuthToken),'','',SW_SHOWNORMAL);
  { A chamada abaixo não deve estar aqui, caso este método se torne um método
  que retorne o PIN sem interação do usuário. Se for assim, este método deve ser
  parecido com os outros Requests com InternalTwitterRequestDone no except e no
  OnRequestDone de FHTTPClient }
  InternalTwitterRequestDone;
end;

procedure TTwitter.RequestAccessData(const aPIN: String);
begin
  FLastTwitterRequest := trRequestAccessData;
  FPINNumber := aPIN;

  GetNonce;                               { Preenche FNonce }
  GetTimeStamp;                           { Preenche FTimeStamp}
  GetSignBase('GET',REQUESTACCESSURL,''); { Preenche FSignBase }
  GetSignature;                           { Preenche FSignature }

  FExtraHeader := 'Authorization: OAuth oauth_nonce="' + FNonce + '"'+
                  ', oauth_callback="oob"' +
                  ', oauth_token="' + FOAuthToken + '"' +
                  ', oauth_verifier="' + FPINNumber + '"' +
                  ', oauth_signature_method="HMAC-SHA1"' +
                  ', oauth_timestamp="' + FTimeStamp + '"' +
                  ', oauth_consumer_key="' + FConsumerKey + '"' +
                  ', oauth_signature="' + URLEncode(FSignature) + '"' +
                  ', oauth_version="1.0"';

  with FHTTPClient do
  begin
    RcvdStream := TMemoryStream.Create;
    SendStream := TMemoryStream.Create;

    URL        := REQUESTACCESSURL;

    ClearReceiveBuffers;

    try
      GetAsync;
    except
      on E: Exception do
      begin
        FreeHTTPStreams; { originalmente era apenas o stream de recebimento }
        FReceivedResult.Text := 'ERRO: '+ E.Message;
        FLastHttpStatus := StatusCode;
        InternalTwitterRequestDone;
      end;
    end;
  end;
end;

end.
