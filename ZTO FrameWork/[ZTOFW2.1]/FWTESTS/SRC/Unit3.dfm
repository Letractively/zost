object ZTODataModule3: TZTODataModule3
  OldCreateOrder = False
  SQLs = <>
  Height = 247
  Width = 311
  object ZConnection1: TZConnection
    Protocol = 'mysql-5'
    HostName = '127.0.0.1'
    Database = 'BANCODEOBRAS'
    User = 'root'
    Password = '123456'
    Connected = True
    Left = 24
    Top = 24
  end
  object DataSource1: TDataSource
    DataSet = ZReadOnlyQuery1
    Left = 96
    Top = 24
  end
  object ZReadOnlyQuery1: TZReadOnlyQuery
    Connection = ZConnection1
    Active = True
    SQL.Strings = (
      'SELECT * FROM OBRAS')
    Params = <>
    Left = 24
    Top = 80
  end
end
