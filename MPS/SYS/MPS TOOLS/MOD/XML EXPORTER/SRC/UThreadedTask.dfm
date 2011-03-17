object ThreadedTask: TThreadedTask
  OldCreateOrder = False
  OnCreate = DataModuleCreate
  OnDestroy = DataModuleDestroy
  Left = 361
  Top = 330
  Height = 140
  Width = 123
  object Connection: TZConnection
    Protocol = 'oracle-9i'
    ReadOnly = True
    Left = 16
    Top = 8
  end
  object DataSet: TZReadOnlyQuery
    Connection = Connection
    Params = <>
    Left = 16
    Top = 56
  end
end
