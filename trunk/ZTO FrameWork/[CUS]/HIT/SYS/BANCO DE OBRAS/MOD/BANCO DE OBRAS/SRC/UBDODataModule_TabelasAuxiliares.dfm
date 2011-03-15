inherited BDODataModule_TabelasAuxiliares: TBDODataModule_TabelasAuxiliares
  Height = 459
  inherited ActionList_Buttons: TActionList
    object Action_ICM_Insert: TAction
      Category = 'ICMS'
      Hint = 'Inserir|Inicia o modo de inclus'#227'o de um registro'
      ImageIndex = 4
      OnExecute = Action_ICM_InsertExecute
    end
    object Action_ICM_Edit: TAction
      Category = 'ICMS'
      Hint = 'Editar|Inicia o modo de edi'#231#227'o para o registro selecionado'
      ImageIndex = 6
      OnExecute = Action_ICM_EditExecute
    end
    object Action_ICM_Delete: TAction
      Category = 'ICMS'
      Hint = 'Excluir|Exclui o registro selecionado'
      ImageIndex = 5
      OnExecute = Action_ICM_DeleteExecute
    end
    object Action_UNI_Insert: TAction
      Category = 'UNIDADES '
      Hint = 'Inserir|Inicia o modo de inclus'#227'o de um registro'
      ImageIndex = 4
      OnExecute = Action_UNI_InsertExecute
    end
    object Action_UNI_Edit: TAction
      Category = 'UNIDADES '
      Hint = 'Editar|Inicia o modo de edi'#231#227'o para o registro selecionado'
      ImageIndex = 6
      OnExecute = Action_UNI_EditExecute
    end
    object Action_UNI_Delete: TAction
      Category = 'UNIDADES '
      Hint = 'Excluir|Exclui o registro selecionado'
      ImageIndex = 5
      OnExecute = Action_UNI_DeleteExecute
    end
    object Action_JUS_Insert: TAction
      Category = 'JUSTIFICATIVAS'
      Hint = 'Inserir|Inicia o modo de inclus'#227'o de um registro'
      ImageIndex = 4
      OnExecute = Action_JUS_InsertExecute
    end
    object Action_JUS_Edit: TAction
      Category = 'JUSTIFICATIVAS'
      Hint = 'Editar|Inicia o modo de edi'#231#227'o para o registro selecionado'
      ImageIndex = 6
      OnExecute = Action_JUS_EditExecute
    end
    object Action_JUS_Delete: TAction
      Category = 'JUSTIFICATIVAS'
      Hint = 'Excluir|Exclui o registro selecionado'
      ImageIndex = 5
      OnExecute = Action_JUS_DeleteExecute
    end
  end
  inherited ActionList_PopUps: TActionList
    inherited Action_RecordInformation: TAction
      OnExecute = Action_RecordInformationExecute
    end
  end
  inherited ImageList_Local: TImageList
    Left = 127
  end
  object ICMS: TZQuery
    AutoCalcFields = False
    UpdateObject = UpdateSQL_ICM
    SQL.Strings = (
      'SELECT TI_ICMS_ID'
      '     , FL_VALOR'
      '  FROM ICMS')
    Params = <>
    Left = 31
    Top = 57
    object ICMSTI_ICMS_ID: TSmallintField
      FieldName = 'TI_ICMS_ID'
    end
    object ICMSFL_VALOR: TFloatField
      FieldName = 'FL_VALOR'
      OnGetText = ICMSFL_VALORGetText
    end
  end
  object UpdateSQL_ICM: TZUpdateSQL
    DeleteSQL.Strings = (
      'DELETE FROM'
      '       ICMS'
      ' WHERE TI_ICMS_ID = :OLD_TI_ICMS_ID')
    InsertSQL.Strings = (
      'INSERT INTO'
      '       ICMS (FL_VALOR)'
      'VALUES (:FL_VALOR)')
    ModifySQL.Strings = (
      'UPDATE ICMS'
      '   SET FL_VALOR = :FL_VALOR'
      ' WHERE TI_ICMS_ID = :OLD_TI_ICMS_ID')
    UseSequenceFieldForRefreshSQL = False
    Left = 31
    Top = 102
    ParamData = <
      item
        DataType = ftUnknown
        Name = 'FL_VALOR'
        ParamType = ptUnknown
      end
      item
        DataType = ftUnknown
        Name = 'OLD_TI_ICMS_ID'
        ParamType = ptUnknown
      end>
  end
  object DataSource_ICM: TDataSource
    DataSet = ICMS
    Left = 31
    Top = 147
  end
  object UNIDADES: TZQuery
    AutoCalcFields = False
    UpdateObject = UpdateSQL_UNI
    SQL.Strings = (
      'SELECT TI_UNIDADES_ID'
      '     , VA_ABREVIATURA'
      '     , VA_DESCRICAO'
      '  FROM UNIDADES')
    Params = <>
    Left = 31
    Top = 195
    object UNIDADESTI_UNIDADES_ID: TSmallintField
      FieldName = 'TI_UNIDADES_ID'
    end
    object UNIDADESVA_ABREVIATURA: TStringField
      FieldName = 'VA_ABREVIATURA'
      Size = 8
    end
    object UNIDADESVA_DESCRICAO: TStringField
      FieldName = 'VA_DESCRICAO'
      Size = 64
    end
  end
  object UpdateSQL_UNI: TZUpdateSQL
    DeleteSQL.Strings = (
      'DELETE FROM'
      '       UNIDADES'
      ' WHERE TI_UNIDADES_ID = :OLD_TI_UNIDADES_ID')
    InsertSQL.Strings = (
      'INSERT INTO'
      '       UNIDADES (VA_ABREVIATURA'
      '                ,VA_DESCRICAO)'
      'VALUES (:VA_ABREVIATURA'
      '       ,:VA_DESCRICAO)')
    ModifySQL.Strings = (
      'UPDATE UNIDADES'
      '   SET VA_ABREVIATURA = :VA_ABREVIATURA'
      '     , VA_DESCRICAO = :VA_DESCRICAO'
      ' WHERE TI_UNIDADES_ID = :OLD_TI_UNIDADES_ID')
    UseSequenceFieldForRefreshSQL = False
    Left = 31
    Top = 240
    ParamData = <
      item
        DataType = ftUnknown
        Name = 'VA_ABREVIATURA'
        ParamType = ptUnknown
      end
      item
        DataType = ftUnknown
        Name = 'VA_DESCRICAO'
        ParamType = ptUnknown
      end
      item
        DataType = ftUnknown
        Name = 'OLD_TI_UNIDADES_ID'
        ParamType = ptUnknown
      end>
  end
  object DataSource_UNI: TDataSource
    DataSet = UNIDADES
    Left = 31
    Top = 285
  end
  object CFDBValidationChecks_ICM: TCFDBValidationChecks
    DataSet = ICMS
    TableName = 'ICMS'
    KeyField = 'TI_ICMS_ID'
    CheckableFields = <
      item
        FieldName = 'TI_ICMS_ID'
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
        FieldName = 'FL_VALOR'
        FieldDescription = 'Taxa de I.C.M.S.'
        CheckBlank.Active = True
        CheckDuplicates.Active = True
        CheckDuplicates.NumericComparision = True
        CheckNumber.Active = True
        CheckNumber.CustomValidationMessage = 'O valor do I.C.M.S. deve estar compreendido entre 0 e 100%'
        CheckNumber.MaximumValue = 100.000000000000000000
        CheckNumber.CheckNumberMode = cnmRange
        CheckTextLength.Active = False
        CheckTextLength.MinimumTextLength = 0
        CheckTextLength.MaximumTextLength = 0
        CheckTextLength.CheckTextLengthMode = ctmMinimum
        CheckNumberSet.Active = False
        CheckTextSet.Active = False
      end>
    Left = 127
    Top = 57
  end
  object CFDBValidationChecks_UNI: TCFDBValidationChecks
    DataSet = UNIDADES
    TableName = 'UNIDADES'
    KeyField = 'TI_UNIDADES_ID'
    CheckableFields = <
      item
        FieldName = 'TI_UNIDADES_ID'
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
        FieldName = 'VA_ABREVIATURA'
        FieldDescription = 'Abreviatura da unidade'
        CheckBlank.Active = True
        CheckDuplicates.Active = True
        CheckDuplicates.NumericComparision = False
        CheckNumber.Active = False
        CheckNumber.CheckNumberMode = cnmMinimum
        CheckTextLength.Active = False
        CheckTextLength.MinimumTextLength = 0
        CheckTextLength.MaximumTextLength = 0
        CheckTextLength.CheckTextLengthMode = ctmMaximum
        CheckNumberSet.Active = False
        CheckTextSet.Active = False
      end
      item
        FieldName = 'VA_DESCRICAO'
        FieldDescription = 'Descri'#231#227'o da unidade'
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
      'ITENS')
    Left = 129
    Top = 195
  end
  object PopupActionBar_RecordInformation: TPopupActionBar
    Left = 284
    Top = 57
    object MenuItem_InformacoesSobreORegistro: TMenuItem
      Action = Action_RecordInformation
    end
  end
  object JUSTIFICATIVAS: TZQuery
    AutoCalcFields = False
    UpdateObject = UpdateSQL_JUS
    SQL.Strings = (
      '  SELECT TI_JUSTIFICATIVAS_ID'
      '       , EN_CATEGORIA'
      '       , VA_JUSTIFICATIVA'
      
        '       , CASE EN_CATEGORIA WHEN '#39'C'#39' THEN '#39'COMERCIAL'#39' WHEN '#39'T'#39' TH' +
        'EN '#39'T'#201'CNICA'#39' ELSE '#39'N/A'#39' END AS CATEGORIA'
      '    FROM JUSTIFICATIVAS'
      'ORDER BY EN_CATEGORIA')
    Params = <>
    Left = 145
    Top = 297
    object JUSTIFICATIVASTI_JUSTIFICATIVAS_ID: TSmallintField
      FieldName = 'TI_JUSTIFICATIVAS_ID'
    end
    object JUSTIFICATIVASEN_CATEGORIA: TStringField
      FieldName = 'EN_CATEGORIA'
      OnGetText = JUSTIFICATIVASEN_CATEGORIAGetText
      OnSetText = JUSTIFICATIVASEN_CATEGORIASetText
      Size = 1
    end
    object JUSTIFICATIVASVA_JUSTIFICATIVA: TStringField
      FieldName = 'VA_JUSTIFICATIVA'
      Size = 128
    end
    object JUSTIFICATIVASCATEGORIA: TStringField
      FieldName = 'CATEGORIA'
    end
  end
  object UpdateSQL_JUS: TZUpdateSQL
    DeleteSQL.Strings = (
      'DELETE FROM JUSTIFICATIVAS'
      ' WHERE TI_JUSTIFICATIVAS_ID = :OLD_TI_JUSTIFICATIVAS_ID')
    InsertSQL.Strings = (
      'INSERT INTO'
      '       JUSTIFICATIVAS (EN_CATEGORIA'
      '                      ,VA_JUSTIFICATIVA)'
      'VALUES (:EN_CATEGORIA'
      '       ,:VA_JUSTIFICATIVA)')
    ModifySQL.Strings = (
      'UPDATE JUSTIFICATIVAS'
      '   SET EN_CATEGORIA = :EN_CATEGORIA'
      '     , VA_JUSTIFICATIVA = :VA_JUSTIFICATIVA'
      ' WHERE TI_JUSTIFICATIVAS_ID = :TI_JUSTIFICATIVAS_ID')
    UseSequenceFieldForRefreshSQL = False
    Left = 145
    Top = 342
    ParamData = <
      item
        DataType = ftUnknown
        Name = 'EN_CATEGORIA'
        ParamType = ptUnknown
      end
      item
        DataType = ftUnknown
        Name = 'VA_JUSTIFICATIVA'
        ParamType = ptUnknown
      end
      item
        DataType = ftUnknown
        Name = 'TI_JUSTIFICATIVAS_ID'
        ParamType = ptUnknown
      end
      item
        DataType = ftUnknown
        Name = 'OLD_TI_JUSTIFICATIVAS_ID'
        ParamType = ptUnknown
      end>
  end
  object DataSource_JUS: TDataSource
    DataSet = JUSTIFICATIVAS
    Left = 145
    Top = 387
  end
  object CFDBValidationChecks_JUS: TCFDBValidationChecks
    DataSet = JUSTIFICATIVAS
    TableName = 'JUSTIFICATIVAS'
    KeyField = 'TI_JUSTIFICATIVAS_ID'
    CheckableFields = <
      item
        FieldName = 'TI_JUSTIFICATIVAS_ID'
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
        FieldName = 'EN_CATEGORIA'
        FieldDescription = 'Categoria da justificativa'
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
        CheckTextSet.Active = True
        CheckTextSet.CustomValidationMessage = 
          'A categoria da justificativa deve ser selecionada e precisa ser ' +
          '"COMERCIAL" (C) ou "T'#201'CNICA" (T)'
        CheckTextSet.Strings.Strings = (
          'C'
          'T')
      end
      item
        FieldName = 'VA_JUSTIFICATIVA'
        FieldDescription = 'Texto de justificativa'
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
        FieldName = 'CATEGORIA'
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
      end>
    DependentTables.Strings = (
      'JUSTIFICATIVASDASOBRAS')
    Left = 258
    Top = 297
  end
end
