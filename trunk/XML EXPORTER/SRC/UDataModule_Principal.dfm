object DataModule_Principal: TDataModule_Principal
  OldCreateOrder = False
  OnCreate = DataModuleCreate
  Left = 819
  Top = 530
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
end
