inherited BDODataModule_TiposDeObra: TBDODataModule_TiposDeObra
  inherited ActionList_Buttons: TActionList
    object Action_TIP_Insert: TAction
      Hint = 'Inserir|Inicia o modo de inclus'#227'o de um registro'
      ImageIndex = 4
      OnExecute = Action_TIP_InsertExecute
    end
    object Action_TIP_Edit: TAction
      Hint = 'Editar|Inicia o modo de edi'#231#227'o para o registro selecionado'
      ImageIndex = 6
      OnExecute = Action_TIP_EditExecute
    end
    object Action_TIP_Delete: TAction
      Hint = 'Excluir|Exclui o registro selecionado'
      ImageIndex = 5
      OnExecute = Action_TIP_DeleteExecute
    end
  end
  inherited ActionList_PopUps: TActionList
    inherited Action_RecordInformation: TAction
      OnExecute = Action_RecordInformationExecute
    end
  end
  object TIPOS: TZQuery
    UpdateObject = UpdateSQL_TIP
    SQL.Strings = (
      '  SELECT *'
      '    FROM TIPOS'
      'ORDER BY VA_DESCRICAO')
    Params = <>
    Left = 31
    Top = 53
    object TIPOSTI_TIPOS_ID: TSmallintField
      FieldName = 'TI_TIPOS_ID'
    end
    object TIPOSVA_DESCRICAO: TStringField
      Alignment = taCenter
      FieldName = 'VA_DESCRICAO'
      Required = True
      Size = 50
    end
  end
  object UpdateSQL_TIP: TZUpdateSQL
    DeleteSQL.Strings = (
      'delete from '
      '  tipos'
      'where'
      '  TI_TIPOS_ID = :OLD_TI_TIPOS_ID')
    InsertSQL.Strings = (
      'insert into '
      '  tipos'
      '  ('
      '    VA_DESCRICAO'
      '  )'
      'values'
      '  ('
      '    :VA_DESCRICAO'
      '  )')
    ModifySQL.Strings = (
      'update '
      '  tipos '
      'set'
      '  VA_DESCRICAO = :VA_DESCRICAO'
      'where'
      '  TI_TIPOS_ID = :OLD_TI_TIPOS_ID')
    UseSequenceFieldForRefreshSQL = False
    Left = 31
    Top = 98
    ParamData = <
      item
        DataType = ftUnknown
        Name = 'VA_DESCRICAO'
        ParamType = ptUnknown
      end
      item
        DataType = ftUnknown
        Name = 'OLD_TI_TIPOS_ID'
        ParamType = ptUnknown
      end>
  end
  object DataSource_TIP: TDataSource
    DataSet = TIPOS
    Left = 31
    Top = 143
  end
  object CFDBValidationChecks_TIP: TCFDBValidationChecks
    DataSet = TIPOS
    TableName = 'TIPOS'
    KeyField = 'TI_TIPOS_ID'
    CheckableFields = <
      item
        FieldName = 'TI_TIPOS_ID'
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
        FieldName = 'VA_DESCRICAO'
        FieldDescription = 'Descri'#231#227'o do tipo de obra'
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
      end>
    DependentTables.Strings = (
      'OBRAS')
    Left = 116
    Top = 53
  end
  object PopupActionBar_RecordInformation: TPopupActionBar
    Left = 278
    Top = 53
    object MenuItem_InformacoesSobreORegistro: TMenuItem
      Action = Action_RecordInformation
    end
  end
end
