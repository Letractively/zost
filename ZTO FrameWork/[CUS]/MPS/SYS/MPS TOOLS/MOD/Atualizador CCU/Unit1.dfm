object Form1: TForm1
  Left = 0
  Top = 0
  Caption = 'Form1'
  ClientHeight = 457
  ClientWidth = 480
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  PixelsPerInch = 96
  TextHeight = 13
  object Button1: TButton
    Left = 42
    Top = 8
    Width = 75
    Height = 25
    Caption = 'Button1'
    TabOrder = 0
    OnClick = Button1Click
  end
  object Memo_1: TMemo
    Left = 0
    Top = 40
    Width = 480
    Height = 110
    Align = alBottom
    Lines.Strings = (
      'Memo_1')
    ScrollBars = ssVertical
    TabOrder = 1
    ExplicitTop = 84
  end
  object DocumentMemo: TMemo
    Left = 0
    Top = 150
    Width = 480
    Height = 102
    Align = alBottom
    Lines.Strings = (
      'DocumentMemo')
    ScrollBars = ssVertical
    TabOrder = 2
    ExplicitTop = 246
  end
  object CCUMemo: TMemo
    Left = 0
    Top = 252
    Width = 480
    Height = 205
    Align = alBottom
    Lines.Strings = (
      'CCUMemo')
    TabOrder = 3
  end
  object SslHttpCli_Acesso: TSslHttpCli
    LocalAddr = '0.0.0.0'
    ProxyPort = '80'
    Agent = 'Mozilla/5.0 (compatible; ICS)'
    Accept = 'image/gif, image/x-xbitmap, image/jpeg, image/pjpeg, */*'
    Reference = 'https://intranet.mpsinf.com.br/'
    Username = 'mps\carlosbarreto'
    Password = 'mps2010'
    NoCache = False
    ContentTypePost = 'application/x-www-form-urlencoded'
    MultiThreaded = False
    RequestVer = '1.1'
    FollowRelocation = True
    LocationChangeMaxCount = 5
    ServerAuth = httpAuthNtlm
    ProxyAuth = httpAuthNone
    BandwidthLimit = 10000
    BandwidthSampling = 1000
    Options = []
    IcsLogger = IcsLogger_1
    OnDocBegin = SslHttpCli_AcessoDocBegin
    OnDocData = SslHttpCli_AcessoDocData
    OnDocEnd = SslHttpCli_AcessoDocEnd
    OnRequestDone = HttpCli_AcessoRequestDone
    SocksAuthentication = socksAuthenticateUsercode
    SslContext = SslContext1
    Left = 174
    Top = 6
  end
  object IcsLogger_1: TIcsLogger
    TimeStampFormatString = 'hh:nn:ss:zzz'
    TimeStampSeparator = ' '
    LogFileOption = lfoOverwrite
    LogFileName = 'd:\https.log'
    LogOptions = [loDestEvent, loDestFile, loDestOutDebug, loAddStamp, loWsockErr, loWsockInfo, loWsockDump, loSslErr, loSslInfo, loSslDump, loProtSpecErr, loProtSpecInfo, loProtSpecDump]
    OnIcsLogEvent = IcsLogger_1IcsLogEvent
    Left = 222
    Top = 6
  end
  object SslContext1: TSslContext
    IcsLogger = IcsLogger_1
    SslVerifyPeer = False
    SslVerifyDepth = 9
    SslOptions = []
    SslVerifyPeerModes = [SslVerifyMode_PEER]
    SslSessionCacheModes = []
    SslCipherList = 'ALL:!ADH:RC4+RSA:+SSLv2:@STRENGTH'
    SslVersionMethod = sslV23
    SslSessionTimeout = 0
    SslSessionCacheSize = 20480
    Left = 294
    Top = 6
  end
end
