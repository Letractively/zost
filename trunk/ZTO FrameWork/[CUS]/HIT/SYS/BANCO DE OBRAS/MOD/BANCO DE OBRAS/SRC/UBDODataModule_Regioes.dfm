inherited BDODataModule_Regioes: TBDODataModule_Regioes
  inherited ActionList_Buttons: TActionList
    object Action_REG_Insert: TAction
      Hint = 'Inserir|Inicia o modo de inclus'#227'o de um registro'
      ImageIndex = 4
      OnExecute = Action_REG_InsertExecute
    end
    object Action_REG_Edit: TAction
      Hint = 'Editar|Inicia o modo de edi'#231#227'o para o registro selecionado'
      ImageIndex = 6
      OnExecute = Action_REG_EditExecute
    end
    object Action_REG_Delete: TAction
      Hint = 'Excluir|Exclui o registro selecionado'
      ImageIndex = 5
      OnExecute = Action_REG_DeleteExecute
    end
  end
  inherited ActionList_PopUps: TActionList
    inherited Action_RecordInformation: TAction
      OnExecute = Action_RecordInformationExecute
    end
  end
  object REGIOES: TZQuery
    AutoCalcFields = False
    UpdateObject = UpdateSQL_REG
    SQL.Strings = (
      '  SELECT TI_REGIOES_ID'
      '       , VA_REGIAO'
      '       , CH_PREFIXODAPROPOSTA'
      '       , VA_PRIMEIRORODAPE'
      '       , VA_SEGUNDORODAPE'
      '    FROM REGIOES'
      'ORDER BY VA_REGIAO')
    Params = <>
    Left = 30
    Top = 51
    object REGIOESTI_REGIOES_ID: TSmallintField
      FieldName = 'TI_REGIOES_ID'
    end
    object REGIOESVA_REGIAO: TStringField
      Alignment = taCenter
      FieldName = 'VA_REGIAO'
      Required = True
      Size = 8
    end
    object REGIOESCH_PREFIXODAPROPOSTA: TStringField
      Alignment = taCenter
      DisplayWidth = 4
      FieldName = 'CH_PREFIXODAPROPOSTA'
      Required = True
      Size = 4
    end
    object REGIOESVA_PRIMEIRORODAPE: TStringField
      Alignment = taCenter
      FieldName = 'VA_PRIMEIRORODAPE'
      Required = True
      Size = 255
    end
    object REGIOESVA_SEGUNDORODAPE: TStringField
      Alignment = taCenter
      FieldName = 'VA_SEGUNDORODAPE'
      Required = True
      Size = 255
    end
  end
  object UpdateSQL_REG: TZUpdateSQL
    DeleteSQL.Strings = (
      'delete from '
      '  regioes'
      'where'
      '  TI_REGIOES_ID = :OLD_TI_REGIOES_ID')
    InsertSQL.Strings = (
      'insert into '
      '  regioes'
      '  ('
      '    VA_REGIAO,'
      '    CH_PREFIXODAPROPOSTA,'
      '    VA_PRIMEIRORODAPE,'
      '    VA_SEGUNDORODAPE'
      '  )'
      'values'
      '  ('
      '    :VA_REGIAO,'
      '    :CH_PREFIXODAPROPOSTA,'
      '    :VA_PRIMEIRORODAPE,'
      '    :VA_SEGUNDORODAPE'
      '  )')
    ModifySQL.Strings = (
      'update '
      '  regioes '
      'set'
      '  VA_REGIAO = :VA_REGIAO,'
      '  CH_PREFIXODAPROPOSTA = :CH_PREFIXODAPROPOSTA,'
      '  VA_PRIMEIRORODAPE = :VA_PRIMEIRORODAPE,'
      '  VA_SEGUNDORODAPE = :VA_SEGUNDORODAPE'
      'where'
      '  TI_REGIOES_ID = :OLD_TI_REGIOES_ID')
    UseSequenceFieldForRefreshSQL = False
    Left = 30
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
    Left = 30
    Top = 141
  end
  object CFDBValidationChecks_REG: TCFDBValidationChecks
    DataSet = REGIOES
    TableName = 'REGIOES'
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
        FieldName = 'VA_REGIAO'
        FieldDescription = 'Descri'#231#227'o da regi'#227'o'
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
        FieldDescription = 'Prefixo usado nos c'#243'digos das propostas desta regi'#227'o'
        CheckBlank.Active = True
        CheckDuplicates.Active = True
        CheckDuplicates.NumericComparision = False
        CheckNumber.Active = False
        CheckNumber.CheckNumberMode = cnmMinimum
        CheckTextLength.Active = True
        CheckTextLength.CustomValidationMessage = 'Os prefixos tem de ter 4 caracteres alfanum'#233'ricos'
        CheckTextLength.MinimumTextLength = 4
        CheckTextLength.MaximumTextLength = 4
        CheckTextLength.CheckTextLengthMode = ctmEqual
        CheckNumberSet.Active = False
        CheckTextSet.Active = False
      end
      item
        FieldName = 'VA_PRIMEIRORODAPE'
        FieldDescription = 'Texto do primeiro rodap'#233' dos relat'#243'rios desta regi'#227'o'
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
        FieldDescription = 'Texto do segundo rodap'#233' dos relat'#243'rios desta regi'#227'o'
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
      end>
    DependentTables.Strings = (
      'OBRAS')
    Left = 126
    Top = 51
  end
  object PopupActionBar_RecordInformation: TPopupActionBar
    Left = 283
    Top = 51
    object MenuItem_InformacoesSobreORegistro: TMenuItem
      Action = Action_RecordInformation
    end
  end
end
