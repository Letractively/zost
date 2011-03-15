inherited BDODataModule_Projetistas: TBDODataModule_Projetistas
  inherited ActionList_Buttons: TActionList
    object Action_PRJ_Insert: TAction
      Hint = 'Inserir|Inicia o modo de inclus'#227'o de um registro'
      ImageIndex = 4
      OnExecute = Action_PRJ_InsertExecute
    end
    object Action_PRJ_Edit: TAction
      Hint = 'Editar|Inicia o modo de edi'#231#227'o para o registro selecionado'
      ImageIndex = 6
      OnExecute = Action_PRJ_EditExecute
    end
    object Action_PRJ_Delete: TAction
      Hint = 'Excluir|Exclui o registro selecionado'
      ImageIndex = 5
      OnExecute = Action_PRJ_DeleteExecute
    end
  end
  inherited ActionList_PopUps: TActionList
    inherited Action_RecordInformation: TAction
      OnExecute = Action_RecordInformationExecute
    end
  end
  inherited ImageList_Local: TImageList
    Left = 125
  end
  object PROJETISTAS: TZQuery
    AutoCalcFields = False
    UpdateObject = UpdateSQL_PRJ
    SQL.Strings = (
      '  SELECT SM_PROJETISTAS_ID'
      '       , VA_NOME'
      '    FROM PROJETISTAS'
      'ORDER BY VA_NOME')
    Params = <>
    Left = 30
    Top = 50
    object PROJETISTASSM_PROJETISTAS_ID: TIntegerField
      FieldName = 'SM_PROJETISTAS_ID'
    end
    object PROJETISTASVA_NOME: TStringField
      Alignment = taCenter
      FieldName = 'VA_NOME'
      Required = True
      Size = 60
    end
  end
  object UpdateSQL_PRJ: TZUpdateSQL
    DeleteSQL.Strings = (
      'delete from '
      '  projetistas'
      'where'
      '  SM_PROJETISTAS_ID = :OLD_SM_PROJETISTAS_ID')
    InsertSQL.Strings = (
      'insert into '
      '  projetistas'
      '  ('
      '    VA_NOME'
      '  )'
      'values'
      '  ('
      '    :VA_NOME'
      '  )')
    ModifySQL.Strings = (
      'update '
      '  projetistas '
      'set'
      '  VA_NOME = :VA_NOME'
      'where'
      '  SM_PROJETISTAS_ID = :OLD_SM_PROJETISTAS_ID')
    UseSequenceFieldForRefreshSQL = False
    Left = 30
    Top = 95
    ParamData = <
      item
        DataType = ftUnknown
        Name = 'VA_NOME'
        ParamType = ptUnknown
      end
      item
        DataType = ftUnknown
        Name = 'OLD_SM_PROJETISTAS_ID'
        ParamType = ptUnknown
      end>
  end
  object DataSource_PRJ: TDataSource
    DataSet = PROJETISTAS
    Left = 30
    Top = 140
  end
  object CFDBValidationChecks_PRJ: TCFDBValidationChecks
    DataSet = PROJETISTAS
    TableName = 'PROJETISTAS'
    KeyField = 'SM_PROJETISTAS_ID'
    CheckableFields = <
      item
        FieldName = 'SM_PROJETISTAS_ID'
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
        FieldName = 'VA_NOME'
        FieldDescription = 'Nome do projetista'
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
    Left = 132
    Top = 50
  end
  object PopupActionBar_RecordInformation: TPopupActionBar
    Left = 288
    Top = 50
    object MenuItem_InformacoesSobreORegistro: TMenuItem
      Action = Action_RecordInformation
    end
  end
end
