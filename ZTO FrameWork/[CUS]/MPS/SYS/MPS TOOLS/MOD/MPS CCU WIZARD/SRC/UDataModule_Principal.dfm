object DataModule_Principal: TDataModule_Principal
  OldCreateOrder = False
  Height = 326
  Width = 451
  object SslHttpCli_CCU: TSslHttpCli
    LocalAddr = '0.0.0.0'
    ProxyPort = '80'
    Agent = 'Mozilla/4.0 (compatible; ICS)'
    Accept = 'image/gif, image/x-xbitmap, image/jpeg, image/pjpeg, */*'
    NoCache = False
    ContentTypePost = 'application/x-www-form-urlencoded'
    MultiThreaded = False
    RequestVer = '1.0'
    FollowRelocation = True
    LocationChangeMaxCount = 5
    ServerAuth = httpAuthNone
    ProxyAuth = httpAuthNone
    BandwidthLimit = 10000
    BandwidthSampling = 1000
    Options = []
    OnDocBegin = SslHttpCli_CCUDocBegin
    OnDocData = SslHttpCli_CCUDocData
    OnDocEnd = SslHttpCli_CCUDocEnd
    OnRequestDone = SslHttpCli_CCURequestDone
    SocksAuthentication = socksNoAuthentication
    SslContext = SslContext_CCU
    Left = 24
    Top = 12
  end
  object SslContext_CCU: TSslContext
    SslVerifyPeer = False
    SslVerifyDepth = 9
    SslOptions = []
    SslVerifyPeerModes = [SslVerifyMode_PEER]
    SslSessionCacheModes = []
    SslCipherList = 'ALL:!ADH:RC4+RSA:+SSLv2:@STRENGTH'
    SslVersionMethod = sslV23
    SslSessionTimeout = 0
    SslSessionCacheSize = 20480
    Left = 96
    Top = 12
  end
end
