inherited ZTODataModule_Regioes: TZTODataModule_Regioes
  OldCreateOrder = True
  ZTOProperties.OpenAllDataSets = True
  Height = 214
  Width = 281
  object REGIOES: TZQuery
    Connection = DataModule_Principal.ACW
    AutoCalcFields = False
    UpdateObject = UpdateSQL_REG
    BeforePost = REGIOESBeforePost
    BeforeDelete = REGIOESBeforeDelete
    SQL.Strings = (
      '  SELECT TI_REGIOES_ID'
      '       , VA_REGIAO'
      '       , CH_PREFIXODAPROPOSTA'
      '       , VA_PRIMEIRORODAPE'
      '       , VA_SEGUNDORODAPE'
      '    FROM ACW.REGIOES'
      'ORDER BY VA_REGIAO')
    Params = <>
    Left = 42
    Top = 51
    object REGIOESTI_REGIOES_ID: TSmallintField
      FieldName = 'TI_REGIOES_ID'
    end
    object REGIOESVA_REGIAO: TWideStringField
      Alignment = taCenter
      FieldName = 'VA_REGIAO'
      Required = True
      Size = 8
    end
    object REGIOESCH_PREFIXODAPROPOSTA: TWideStringField
      Alignment = taCenter
      DisplayWidth = 4
      FieldName = 'CH_PREFIXODAPROPOSTA'
      Required = True
      Size = 4
    end
    object REGIOESVA_PRIMEIRORODAPE: TWideStringField
      Alignment = taCenter
      FieldName = 'VA_PRIMEIRORODAPE'
      Required = True
      Size = 255
    end
    object REGIOESVA_SEGUNDORODAPE: TWideStringField
      Alignment = taCenter
      FieldName = 'VA_SEGUNDORODAPE'
      Required = True
      Size = 255
    end
  end
  object UpdateSQL_REG: TZUpdateSQL
    DeleteSQL.Strings = (
      'DELETE FROM ACW.REGIOES'
      '      WHERE TI_REGIOES_ID = :OLD_TI_REGIOES_ID')
    InsertSQL.Strings = (
      'INSERT INTO ACW.REGIOES (VA_REGIAO'
      '                        ,CH_PREFIXODAPROPOSTA'
      '                        ,VA_PRIMEIRORODAPE'
      '                        ,VA_SEGUNDORODAPE)'
      '                 VALUES (:VA_REGIAO'
      '                        ,:CH_PREFIXODAPROPOSTA'
      '                        ,:VA_PRIMEIRORODAPE'
      '                        ,:VA_SEGUNDORODAPE)')
    ModifySQL.Strings = (
      'UPDATE ACW.REGIOES'
      '   SET VA_REGIAO = :VA_REGIAO'
      '     , CH_PREFIXODAPROPOSTA = :CH_PREFIXODAPROPOSTA'
      '     , VA_PRIMEIRORODAPE = :VA_PRIMEIRORODAPE'
      '     , VA_SEGUNDORODAPE = :VA_SEGUNDORODAPE'
      ' WHERE TI_REGIOES_ID = :OLD_TI_REGIOES_ID')
    UseSequenceFieldForRefreshSQL = False
    Left = 42
    Top = 96
    ParamData = <
      item
        DataType = ftUnknown
        Name = 'VA_REGIAO'
        ParamType = ptUnknown
      end
      item
        DataType = ftUnknown
        Name = 'CH_PREFIXODAPROPOSTA'
        ParamType = ptUnknown
      end
      item
        DataType = ftUnknown
        Name = 'VA_PRIMEIRORODAPE'
        ParamType = ptUnknown
      end
      item
        DataType = ftUnknown
        Name = 'VA_SEGUNDORODAPE'
        ParamType = ptUnknown
      end
      item
        DataType = ftUnknown
        Name = 'OLD_TI_REGIOES_ID'
        ParamType = ptUnknown
      end>
  end
  object DataSource_REG: TDataSource
    DataSet = REGIOES
    Left = 42
    Top = 141
  end
  object CFDBValidationChecks_REG: TCFDBValidationChecks
    DataSet = REGIOES
    TableName = 'ACW.REGIOES'
    KeyField = 'TI_REGIOES_ID'
    CheckableFields = <
      item
        FieldName = 'TI_REGIOES_ID'
        CheckBlank.Active = False
        CheckDuplicates.Active = False
        CheckDuplicates.NumericComparision = False
        CheckNumber.Active = False
        CheckNumber.CheckNumberMode = cnmMinimum
        CheckTextLength.Active = False
        CheckTextLength.MinimumTextLength = 0
        CheckTextLength.MaximumTextLength = 0
        CheckTextLength.CheckTextLengthMode = ctmMinimum
        CheckNumberSet.Active = False
        CheckTextSet.Active = False
      end
      item
        FieldName = 'VA_PRIMEIRORODAPE'
        FieldDescription = 'Primeiro rodap'#233
        CheckBlank.Active = True
        CheckDuplicates.Active = False
        CheckDuplicates.NumericComparision = False
        CheckNumber.Active = False
        CheckNumber.CheckNumberMode = cnmMinimum
        CheckTextLength.Active = False
        CheckTextLength.MinimumTextLength = 0
        CheckTextLength.MaximumTextLength = 0
        CheckTextLength.CheckTextLengthMode = ctmMinimum
        CheckNumberSet.Active = False
        CheckTextSet.Active = False
      end
      item
        FieldName = 'VA_SEGUNDORODAPE'
        FieldDescription = 'Segundo rodap'#233
        CheckBlank.Active = True
        CheckDuplicates.Active = False
        CheckDuplicates.NumericComparision = False
        CheckNumber.Active = False
        CheckNumber.CheckNumberMode = cnmMinimum
        CheckTextLength.Active = False
        CheckTextLength.MinimumTextLength = 0
        CheckTextLength.MaximumTextLength = 0
        CheckTextLength.CheckTextLengthMode = ctmMinimum
        CheckNumberSet.Active = False
        CheckTextSet.Active = False
      end
      item
        FieldName = 'VA_REGIAO'
        FieldDescription = 'Regi'#227'o'
        CheckBlank.Active = True
        CheckDuplicates.Active = True
        CheckDuplicates.NumericComparision = False
        CheckNumber.Active = False
        CheckNumber.CheckNumberMode = cnmMinimum
        CheckTextLength.Active = False
        CheckTextLength.MinimumTextLength = 0
        CheckTextLength.MaximumTextLength = 0
        CheckTextLength.CheckTextLengthMode = ctmMinimum
        CheckNumberSet.Active = False
        CheckTextSet.Active = False
      end
      item
        FieldName = 'CH_PREFIXODAPROPOSTA'
        FieldDescription = 'Prefixo das propostas'
        CheckBlank.Active = True
        CheckDuplicates.Active = True
        CheckDuplicates.NumericComparision = False
        CheckNumber.Active = False
        CheckNumber.CheckNumberMode = cnmMinimum
        CheckTextLength.Active = True
        CheckTextLength.CustomValidationMessage = 'Os prefixos tem de ter sempre 4 caracteres alfanum'#233'ricos'
        CheckTextLength.MinimumTextLength = 4
        CheckTextLength.MaximumTextLength = 4
        CheckTextLength.CheckTextLengthMode = ctmEqual
        CheckNumberSet.Active = False
        CheckTextSet.Active = False
      end>
    DependentTables.Strings = (
      'ACW.TRABALHOS')
    Left = 149
    Top = 51
  end
end
