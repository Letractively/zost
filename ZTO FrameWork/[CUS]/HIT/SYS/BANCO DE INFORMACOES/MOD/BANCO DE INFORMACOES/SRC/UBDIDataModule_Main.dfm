inherited BDIDataModule_Main: TBDIDataModule_Main
  Height = 122
  Width = 523
  object ZConnection_BDI: TZConnection
    Properties.Strings = (
      'compress=yes'
      'dbless=no'
      'useresult=no'
      'timeout=30'
      'ServerArgument1=--basedir=./MySQL'
      'ServerArgument2=--datadir=./MySQL/data'
      'ServerArgument3=--character-sets-dir=./MySQL/share/charsets'
      'ServerArgument4=--language=./MySQL/share/portuguese'
      'ServerArgument5=--skip-innodb'
      'ServerArgument6=--key_buffer_size=32M')
    BeforeConnect = ZConnection_BDIBeforeConnect
    AfterConnect = DoAfterConnectBDI
    Left = 36
    Top = 60
  end
  object TrayIcon_BDI: TTrayIcon
    BalloonFlags = bfInfo
    Icon.Data = {
      0000010001001010000001001800680300001600000028000000100000002000
      0000010018000000000040030000000000000000000000000000000000000000
      00FFCCCCFFCCCCFFCCCCFFCCCCFFCCCC000000000000000000000000FFCCCCFF
      CCCCFFCCCCFFCCCCFFCCCC000000000000FFCCCC000000000000000000FFCCCC
      000033000033000033000033FFCCCC000000000000000000FFCCCC0000000000
      00FFCCCC000000000000000000FFCCCC000066000066000066000066FFCCCC00
      0000000000000000FFCCCC000000000000FFCCCC000000000000000000FFCCCC
      000099000099000099000099FFCCCC000000000000000000FFCCCC0000000000
      00FFCCCC000000000000000000FFCCCC0000CC0000CC0000CC0000CCFFCCCC00
      0000000000000000FFCCCC000000000000FFCCCC000000000000000000FFCCCC
      0000FF0000FF0000FF0000FFFFCCCC000000000000000000FFCCCC0000000000
      00FFCCCC000000000000000000FFCCCCFFCCCCFFCCCCFFCCCCFFCCCCFFCCCC00
      0000000000000000FFCCCC000000000000FFCCCC000000000000000000000000
      000000000000000000000000000000000000000000000000FFCCCC0000000000
      00FFCCCC00000000000000000000000000000000000000000000000000000000
      0000000000000000FFCCCC000000000000FFCCCC000000000000000000000000
      000000000000000000000000000000000000000000000000FFCCCC0000000000
      00FFCCCC000000000000000000FFCCCCFFCCCCFFCCCCFFCCCCFFCCCCFFCCCC00
      0000000000000000FFCCCC000000000000FFCCCC000000000000000000FFCCCC
      0000FF0000FF0000FF0000FFFFCCCC000000000000000000FFCCCC0000000000
      00FFCCCC000000000000000000FFCCCC0000BF0000BF0000BF0000BFFFCCCC00
      0000000000000000FFCCCC000000000000FFCCCC000000000000000000FFCCCC
      00007F00007F00007F00007FFFCCCC000000000000000000FFCCCC0000000000
      00FFCCCC000000000000000000FFCCCC00003F00003F00003F00003FFFCCCC00
      0000000000000000FFCCCC000000000000FFCCCCFFCCCCFFCCCCFFCCCCFFCCCC
      000000000000000000000000FFCCCCFFCCCCFFCCCCFFCCCCFFCCCC0000008001
      0000800100008001000080010000800100008001000080010000800100008001
      000080010000800100008001000080010000800100008001000080010000}
    IconIndex = 4
    PopupMenu = PopupActionBar_TrayIcon
    OnDblClick = TrayIcon_BDIDblClick
    Left = 349
    Top = 5
  end
  object PopupActionBar_TrayIcon: TPopupActionBar
    Left = 246
    Top = 5
    object AtivarserviodeinformaesviaHTTP1: TMenuItem
      Action = BDIForm_Main.Action_HTTPAtivarDesativar
    end
    object AtivarserviodeenviodeemailsviaSMTP1: TMenuItem
      Action = BDIForm_Main.Action_SMTPAtivarDesativar
    end
    object N2: TMenuItem
      Caption = '-'
    end
    object ActionRestaurarDoTray1: TMenuItem
      Action = BDIForm_Main.Action_RestaurarDoTray
    end
    object N1: TMenuItem
      Caption = '-'
    end
    object ActionFecharAplicacao1: TMenuItem
      Action = BDIForm_Main.Action_FecharAplicacao
    end
  end
  object HttpServer_BDI: THttpServer
    ListenBacklog = 5
    Port = '80'
    Addr = '0.0.0.0'
    MaxClients = 0
    DocDir = 'c:\wwwroot'
    TemplateDir = 'c:\wwwroot\templates'
    DefaultDoc = 'index.html'
    LingerOnOff = wsLingerNoSet
    LingerTimeout = 0
    Options = []
    KeepAliveTimeSec = 10
    MaxRequestsKeepAlive = 100
    SizeCompressMin = 5000
    SizeCompressMax = 5000000
    OnServerStarted = DoServerStarted
    OnServerStopped = DoServerStopped
    OnClientConnect = DoClientConnect
    OnClientDisconnect = DoClientDisconnect
    OnGetDocument = DoGetDocument
    OnHeadDocument = DeHeadDocument
    OnPostDocument = DoPostDocument
    OnPostedData = DoPostedData
    OnAuthGetPassword = DoAuthGetPassword
    OnAuthResult = DoAuthResult
    OnAuthGetType = DoAuthGetType
    AuthTypes = []
    AuthRealm = 'BancoDeInformacoes'
    Left = 426
    Top = 5
  end
  object Timer_EmailsAutomaticos: TTimer
    Enabled = False
    OnTimer = Timer_EmailsAutomaticosTimer
    Left = 241
    Top = 60
  end
  object ZConnection_BDO: TZConnection
    Properties.Strings = (
      'compress=yes'
      'dbless=no'
      'useresult=no'
      'timeout=30'
      'ServerArgument1=--basedir=./MySQL'
      'ServerArgument2=--datadir=./MySQL/data'
      'ServerArgument3=--character-sets-dir=./MySQL/share/charsets'
      'ServerArgument4=--language=./MySQL/share/portuguese'
      'ServerArgument5=--skip-innodb'
      'ServerArgument6=--key_buffer_size=32M')
    ReadOnly = True
    BeforeConnect = ZConnection_BDOBeforeConnect
    AfterConnect = DoAfterConnectBDO
    Left = 130
    Top = 60
  end
  object SmtpCli_BDI: TSmtpCli
    Tag = 0
    ShareMode = smtpShareDenyWrite
    LocalAddr = '0.0.0.0'
    Port = 'smtp'
    AuthType = smtpAuthNone
    ConfirmReceipt = False
    HdrPriority = smtpPriorityNone
    CharSet = 'iso-8859-1'
    ConvertToCharset = True
    WrapMsgMaxLineLen = 76
    SendMode = smtpToSocket
    DefaultEncoding = smtpEnc7bit
    Allow8bitChars = True
    FoldHeaders = False
    WrapMessageText = False
    ContentType = smtpPlainText
    OwnHeaders = False
    OnGetData = DoGetData
    OnRequestDone = DoRequestDone
    XMailer = 'ICS SMTP Component V%VER%'
    Left = 427
    Top = 60
  end
end
