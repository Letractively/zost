object DataModule_Principal: TDataModule_Principal
  OldCreateOrder = False
  OnCreate = DataModuleCreate
  Left = 264
  Top = 211
  Height = 150
  Width = 298
  object ApplicationEvents_Monitorador: TApplicationEvents
    OnIdle = ApplicationEvents_MonitoradorIdle
    Left = 72
    Top = 54
  end
end
