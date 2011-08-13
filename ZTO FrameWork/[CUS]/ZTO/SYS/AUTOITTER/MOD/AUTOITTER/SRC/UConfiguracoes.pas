unit UConfiguracoes;

interface

uses Classes
   , ZTO.Win32.Rtl.Common.Classes
   , OverbyteIcsHttpProt;

type
  TConfiguracoes = class(TObjectFile)
  private
    FUserID: String;
    FAccessToken: String;
    FAccessTokenSecret: String;
    FProxy: String;
    FProxyAuth: THttpAuthType;
    FProxyConnection: String;
    FProxyPassword: String;
    FProxyPort: String;
    FProxyUsername: String;
    FMensagensAutomaticas: TStrings;
    FIntervaloEntreTweets: Word;
  public
    constructor Create(aOwner: TComponent); override;
    destructor Destroy; override;
  published
    property UserID: String read FUserID write FUserID;
    property AccessToken: String read FAccessToken write FAccessToken;
    property AccessTokenSecret: String read FAccessTokenSecret write FAccessTokenSecret;
    property Proxy: String read FProxy write FProxy;
    property ProxyAuth: THttpAuthType read FProxyAuth write FProxyAuth;
    property ProxyConnection: String read FProxyConnection write FProxyConnection;
    property ProxyPassword: String read FProxyPassword write FProxyPassword;
    property ProxyPort: String read FProxyPort write FProxyPort;
    property ProxyUsername: String read FProxyUsername write FProxyUsername;
    property MensagensAutomaticas: TStrings read FMensagensAutomaticas write FMensagensAutomaticas;
    property IntervaloEntreTweets: Word read FIntervaloEntreTweets write FIntervaloEntreTweets default 60;
  end;

implementation

{ TConfiguracoes }

constructor TConfiguracoes.Create(aOwner: TComponent);
begin
  inherited;
  FProxyPort := '80';
  FIntervaloEntreTweets := 60;
  FMensagensAutomaticas := TStringList.Create;
end;

destructor TConfiguracoes.Destroy;
begin
  FMensagensAutomaticas.Free;
  inherited;
end;

end.
