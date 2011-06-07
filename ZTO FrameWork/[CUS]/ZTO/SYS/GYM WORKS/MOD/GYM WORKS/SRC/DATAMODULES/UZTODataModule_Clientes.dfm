inherited ZTODataModule_Clientes: TZTODataModule_Clientes
  OldCreateOrder = True
  ZTOProperties.Description = 'DataModule/Clientes'
  object CLIENTES: TZQuery
    Connection = DataModule_Principal.GYMWORKS
    Params = <>
    Left = 30
    Top = 8
  end
  object DataSource_CLI: TDataSource
    DataSet = CLIENTES
    Left = 30
    Top = 56
  end
end
