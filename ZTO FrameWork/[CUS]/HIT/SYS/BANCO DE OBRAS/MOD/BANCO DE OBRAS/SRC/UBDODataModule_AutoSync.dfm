inherited BDODataModule_AutoSync: TBDODataModule_AutoSync
  object Timer_Execute: TTimer
    Enabled = False
    Interval = 500
    OnTimer = Timer_ExecuteTimer
    Left = 194
    Top = 56
  end
  object Timer_Close: TTimer
    Enabled = False
    Interval = 500
    OnTimer = Timer_CloseTimer
    Left = 124
    Top = 56
  end
  object FtpClient_AutoSync: TFtpClient
    Timeout = 180
    MultiThreaded = False
    Port = 'ftp'
    DataPortRangeStart = 0
    DataPortRangeEnd = 0
    LocalAddr = '0.0.0.0'
    DisplayFileFlag = False
    Binary = True
    ShareMode = ftpShareExclusive
    Options = [ftpAcceptLF, ftpWaitUsingSleep]
    ConnectionType = ftpDirect
    OnDisplay = FtpClient_AutoSyncDisplay
    OnCommand = FtpClient_AutoSyncCommand
    OnResponse = FtpClient_AutoSyncResponse
    OnProgress = FtpClient_AutoSyncProgress
    OnSessionClosed = FtpClient_AutoSyncSessionClosed
    OnRequestDone = FtpClient_AutoSyncRequestDone
    BandwidthLimit = 10000
    BandwidthSampling = 1000
    Left = 42
    Top = 56
  end
  object ZConnection_FTPSynchronizer: TZConnection
    Left = 67
    Top = 108
  end
end
