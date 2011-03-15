inherited BDODataModule_EmailsAutomaticos: TBDODataModule_EmailsAutomaticos
  Height = 222
  object USUARIOS_LOOKUP: TZReadOnlyQuery
    SQL.Strings = (
      '  SELECT X[USU.SM_USUARIOS_ID]X AS SM_USUARIOS_ID'
      '       , X[USU.VA_NOME]X AS VA_NOME'
      '       , X[USU.VA_LOGIN]X AS VA_LOGIN'
      '       , X[USU.VA_EMAIL]X AS VA_EMAIL'
      '    FROM X[USU.USUARIOS]X'
      'ORDER BY X[USU.VA_NOME]X'
      '')
    Params = <>
    Left = 39
    Top = 63
    object USUARIOS_LOOKUPSM_USUARIOS_ID: TSmallintField
      FieldName = 'SM_USUARIOS_ID'
    end
    object USUARIOS_LOOKUPVA_NOME: TStringField
      FieldName = 'VA_NOME'
      Size = 64
    end
    object USUARIOS_LOOKUPVA_LOGIN: TStringField
      FieldName = 'VA_LOGIN'
      Size = 16
    end
    object USUARIOS_LOOKUPVA_EMAIL: TStringField
      FieldName = 'VA_EMAIL'
      Size = 64
    end
  end
  object DataSource_USU_LKP: TDataSource
    DataSet = USUARIOS_LOOKUP
    Left = 39
    Top = 113
  end
end
