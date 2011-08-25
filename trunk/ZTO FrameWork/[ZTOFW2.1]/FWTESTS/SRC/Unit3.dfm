object ZTODataModule3: TZTODataModule3
  OldCreateOrder = False
  SQLs = <>
  Height = 247
  Width = 311
  object ZConnection1: TZConnection
    Protocol = 'mysql-5'
    HostName = '127.0.0.1'
    Database = 'ACDM'
    User = 'root'
    Password = '123456'
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
    SQL.Strings = (
      'SELECT * FROM USUARIO')
    Params = <>
    Left = 24
    Top = 80
  end
  object ZQuery1: TZQuery
    Connection = ZConnection1
    SQL.Strings = (
      'SELECT * FROM USUARIO')
    Params = <>
    Left = 114
    Top = 78
  end
  object DataSource2: TDataSource
    DataSet = ZQuery1
    Left = 168
    Top = 84
  end
end
