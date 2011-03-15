inherited BDODataModule_Situacoes: TBDODataModule_Situacoes
  inherited ActionList_Buttons: TActionList
    object Action_SIT_Insert: TAction
      Hint = 'Inserir|Inicia o modo de inclus'#227'o de um registro'
      ImageIndex = 4
      OnExecute = Action_SIT_InsertExecute
    end
    object Action_SIT_Edit: TAction
      Hint = 'Editar|Inicia o modo de edi'#231#227'o para o registro selecionado'
      ImageIndex = 6
      OnExecute = Action_SIT_EditExecute
    end
    object Action_SIT_Delete: TAction
      Hint = 'Excluir|Exclui o registro selecionado'
      ImageIndex = 5
      OnExecute = Action_SIT_DeleteExecute
    end
  end
  inherited ActionList_PopUps: TActionList
    inherited Action_RecordInformation: TAction
      OnExecute = Action_RecordInformationExecute
    end
  end
  inherited ImageList_Local: TImageList
    Left = 123
  end
  object SITUACOES: TZQuery
    AutoCalcFields = False
    UpdateObject = UpdateSQL_SIT
    SQL.Strings = (
      '  SELECT TI_SITUACOES_ID'
      '       , VA_DESCRICAO'
      '       , BO_EXPIRAVEL'
      '       , BO_JUSTIFICAVEL'
      '       , TI_DIASPARAEXPIRACAO'
      '    FROM SITUACOES'
      'ORDER BY VA_DESCRICAO')
    Params = <>
    Left = 30
    Top = 51
    object SITUACOESTI_SITUACOES_ID: TSmallintField
      FieldName = 'TI_SITUACOES_ID'
    end
    object SITUACOESVA_DESCRICAO: TStringField
      Alignment = taCenter
      FieldName = 'VA_DESCRICAO'
      Required = True
      Size = 32
    end
    object SITUACOESBO_EXPIRAVEL: TSmallintField
      Alignment = taCenter
      FieldName = 'BO_EXPIRAVEL'
      Required = True
      OnGetText = SITUACOESBO_EXPIRAVELGetText
    end
    object SITUACOESBO_JUSTIFICAVEL: TSmallintField
      FieldName = 'BO_JUSTIFICAVEL'
      OnGetText = SITUACOESBO_JUSTIFICAVELGetText
    end
    object SITUACOESTI_DIASPARAEXPIRACAO: TSmallintField
      Alignment = taCenter
      FieldName = 'TI_DIASPARAEXPIRACAO'
      OnGetText = SITUACOESTI_DIASPARAEXPIRACAOGetText
    end
  end
  object UpdateSQL_SIT: TZUpdateSQL
    DeleteSQL.Strings = (
      'DELETE FROM SITUACOES'
      ' WHERE TI_SITUACOES_ID = :OLD_TI_SITUACOES_ID')
    InsertSQL.Strings = (
      'INSERT INTO SITUACOES ('
      '                      VA_DESCRICAO'
      '                    , BO_EXPIRAVEL'
      '                    , BO_JUSTIFICAVEL'
      '                    , TI_DIASPARAEXPIRACAO'
      '                      )'
      'VALUES ('
      '       :VA_DESCRICAO'
      '     , :BO_EXPIRAVEL'
      '     , :BO_JUSTIFICAVEL'
      '     , :TI_DIASPARAEXPIRACAO'
      '       )')
    ModifySQL.Strings = (
      'UPDATE SITUACOES'
      '   SET VA_DESCRICAO = :VA_DESCRICAO'
      '     , BO_EXPIRAVEL = :BO_EXPIRAVEL'
      '     , BO_JUSTIFICAVEL = :BO_JUSTIFICAVEL     '
      '     , TI_DIASPARAEXPIRACAO = :TI_DIASPARAEXPIRACAO'
      ' WHERE TI_SITUACOES_ID = :OLD_TI_SITUACOES_ID')
    UseSequenceFieldForRefreshSQL = False
    Left = 30
    Top = 96
    ParamData = <
      item
        DataType = ftUnknown
        Name = 'VA_DESCRICAO'
        ParamType = ptUnknown
      end
      item
        DataType = ftUnknown
        Name = 'BO_EXPIRAVEL'
        ParamType = ptUnknown
      end
      item
        DataType = ftUnknown
        Name = 'BO_JUSTIFICAVEL'
        ParamType = ptUnknown
      end
      item
        DataType = ftUnknown
        Name = 'TI_DIASPARAEXPIRACAO'
        ParamType = ptUnknown
      end
      item
        DataType = ftUnknown
        Name = 'OLD_TI_SITUACOES_ID'
        ParamType = ptUnknown
      end>
  end
  object DataSource_SIT: TDataSource
    DataSet = SITUACOES
    Left = 30
    Top = 141
  end
  object CFDBValidationChecks_SIT: TCFDBValidationChecks
    DataSet = SITUACOES
    TableName = 'SITUACOES'
    KeyField = 'TI_SITUACOES_ID'
    CheckableFields = <
      item
        FieldName = 'TI_SITUACOES_ID'
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
        FieldDescription = 'Descri'#231#227'o da situa'#231#227'o'
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
        FieldName = 'BO_EXPIRAVEL'
        FieldDescription = 'Expirabilidade da situa'#231#227'o'
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
        FieldName = 'BO_JUSTIFICAVEL'
        FieldDescription = 'Justificabilidade da situa'#231#227'o'
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
        FieldName = 'TI_DIASPARAEXPIRACAO'
        FieldDescription = 'Quantidade de dias at'#233' a expira'#231#227'o de obras com esta situa'#231#227'o'
        CheckBlank.Active = False
        CheckDuplicates.Active = False
        CheckDuplicates.NumericComparision = False
        CheckNumber.Active = True
        CheckNumber.CustomValidationMessage = 
          'Por favor indique a quantidade de dias que uma obra poder'#225' perma' +
          'necer nesta situa'#231#227'o antes de expirar. O valor m'#225'ximo aceitavel ' +
          #233' 255 dias'
        CheckNumber.MaximumValue = 255.000000000000000000
        CheckNumber.CheckNumberMode = cnmRange
        CheckTextLength.Active = False
        CheckTextLength.MinimumTextLength = 0
        CheckTextLength.MaximumTextLength = 0
        CheckTextLength.CheckTextLengthMode = ctmMinimum
        CheckNumberSet.Active = False
        CheckTextSet.Active = False
      end>
    DependentTables.Strings = (
      'OBRAS')
    Left = 127
    Top = 51
  end
  object PopupActionBar_RecordInformation: TPopupActionBar
    Left = 284
    Top = 51
    object MenuItem_InformacoesSobreORegistro: TMenuItem
      Action = Action_RecordInformation
    end
  end
end
