object DataModule_Principal: TDataModule_Principal
  OldCreateOrder = False
  OnCreate = DataModuleCreate
  Left = 703
  Top = 399
  Height = 150
  Width = 298
  object ApplicationEvents_Monitorador: TApplicationEvents
    OnIdle = ApplicationEvents_MonitoradorIdle
    Left = 72
    Top = 54
  end
  object ZipMaster_Compressor: TZipMaster
    Verbose = False
    Trace = False
    AddCompLevel = 9
    AddOptions = []
    ExtrOptions = []
    Unattended = False
    SFXPath = 'ZipSFX.bin'
    SFXOverWriteMode = OvrConfirm
    SFXCaption = 'Self-extracting Archive'
    KeepFreeOnDisk1 = 0
    VersionInfo = '1.60 L'
    AddStoreSuffixes = [assGIF, assPNG, assZ, assZIP, assZOO, assARC, assLZH, assARJ, assTAZ, assTGZ, assLHA]
    OnProgress = ZipMaster_CompressorProgress
    OnMessage = ZipMaster_CompressorMessage
    Left = 180
    Top = 6
  end
  object FtpClient_Envio: TFtpClient
    Timeout = 15
    MultiThreaded = False
    Port = 'ftp'
    CodePage = 0
    DataPortRangeStart = 0
    DataPortRangeEnd = 0
    LocalAddr = '0.0.0.0'
    DisplayFileFlag = False
    Binary = True
    ShareMode = ftpShareExclusive
    Options = [ftpAcceptLF]
    ConnectionType = ftpDirect
    Language = 'EN'
    OnDisplay = FtpClient_EnvioDisplay
    OnProgress64 = FtpClient_EnvioProgress64
    OnSessionConnected = FtpClient_EnvioSessionConnected
    OnSessionClosed = FtpClient_EnvioSessionClosed
    OnRequestDone = FtpClient_EnvioRequestDone
    BandwidthLimit = 10000
    BandwidthSampling = 1000
    Left = 24
    Top = 6
  end
end
