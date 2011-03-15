inherited BDODataModule_Instaladores: TBDODataModule_Instaladores
  inherited ActionList_Buttons: TActionList
    object Action_INS_Insert: TAction
      Hint = 'Inserir|Inicia o modo de inclus'#227'o de um registro'
      ImageIndex = 4
      OnExecute = Action_INS_InsertExecute
    end
    object Action_INS_Edit: TAction
      Hint = 'Editar|Inicia o modo de edi'#231#227'o para o registro selecionado'
      ImageIndex = 6
      OnExecute = Action_INS_EditExecute
    end
    object Action_INS_Delete: TAction
      Hint = 'Excluir|Exclui o registro selecionado'
      ImageIndex = 5
      OnExecute = Action_INS_DeleteExecute
    end
  end
  inherited ActionList_PopUps: TActionList
    inherited Action_RecordInformation: TAction
      OnExecute = Action_RecordInformationExecute
    end
  end
  object INSTALADORES: TZQuery
    AutoCalcFields = False
    UpdateObject = UpdateSQL_INS
    SQL.Strings = (
      '  SELECT SM_INSTALADORES_ID'
      '       , VA_NOME'
      '    FROM INSTALADORES'
      'ORDER BY VA_NOME;'
      '')
    Params = <>
    Left = 30
    Top = 51
    object INSTALADORESSM_INSTALADORES_ID: TIntegerField
      FieldName = 'SM_INSTALADORES_ID'
    end
    object INSTALADORESVA_NOME: TStringField
      Alignment = taCenter
      FieldName = 'VA_NOME'
      Required = True
      Size = 60
    end
  end
  object UpdateSQL_INS: TZUpdateSQL
    DeleteSQL.Strings = (
      'delete from '
      '  instaladores'
      'where'
      '  SM_INSTALADORES_ID = :OLD_SM_INSTALADORES_ID')
    InsertSQL.Strings = (
      'insert into '
      '  instaladores'
      '  ('
      '    VA_NOME'
      '  )'
      'values'
      '  ('
      '    :VA_NOME'
      '  )')
    ModifySQL.Strings = (
      'update '
      '  instaladores '
      'set'
      '  VA_NOME = :VA_NOME'
      'where'
      '  SM_INSTALADORES_ID = :OLD_SM_INSTALADORES_ID')
    UseSequenceFieldForRefreshSQL = False
    Left = 30
    Top = 96
    ParamData = <
      item
        DataType = ftUnknown
        Name = 'VA_NOME'
        ParamType = ptUnknown
      end
      item
        DataType = ftUnknown
        Name = 'OLD_SM_INSTALADORES_ID'
        ParamType = ptUnknown
      end>
  end
  object DataSource_INS: TDataSource
    DataSet = INSTALADORES
    Left = 30
    Top = 141
  end
  object CFDBValidationChecks_INS: TCFDBValidationChecks
    DataSet = INSTALADORES
    TableName = 'INSTALADORES'
    KeyField = 'SM_INSTALADORES_ID'
    CheckableFields = <
      item
        FieldName = 'SM_INSTALADORES_ID'
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
        FieldDescription = 'Nome do instalador'
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
      'PROPOSTAS')
    Left = 137
    Top = 51
  end
  object PopupActionBar_RecordInformation: TPopupActionBar
    Left = 293
    Top = 51
    object MenuItem_InformacoesSobreORegistro: TMenuItem
      Action = Action_RecordInformation
    end
  end
end
