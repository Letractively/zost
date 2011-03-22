object DataModule_Principal: TDataModule_Principal
  OldCreateOrder = False
  OnCreate = DataModuleCreate
  Height = 270
  Width = 340
  object ZConnection_Principal: TZConnection
    Protocol = 'mysqld-5'
    Database = 'WINSTON'
    Properties.Strings = (
      'compress=yes'
      'dbless=no'
      'useresult=no'
      'timeout=30'
      'ServerArgument1=--basedir=./MySQL'
      'ServerArgument2=--datadir=./MySQL/data'
      'ServerArgument3=--character-sets-dir=./MySQL/share/charsets'
      'ServerArgument4=--language=./MySQL/share/portuguese'
      'ServerArgument6=--key_buffer_size=32M')
    AfterConnect = ZConnection_PrincipalAfterConnect
    Left = 58
    Top = 18
  end
  object CODIGOSDACCU: TZReadOnlyQuery
    Connection = ZConnection_Principal
    AfterOpen = CODIGOSDACCUAfterOpen
    SQL.Strings = (
      'SELECT * '
      '  FROM WINSTON.CODIGOSDACCU')
    Params = <>
    Left = 58
    Top = 66
    object CODIGOSDACCUTI_CODIGOSDACCU_ID: TSmallintField
      FieldName = 'TI_CODIGOSDACCU_ID'
    end
    object CODIGOSDACCUVA_CODIGO: TStringField
      FieldName = 'VA_CODIGO'
      Size = 10
    end
    object CODIGOSDACCUVA_DESCRICAO: TStringField
      FieldName = 'VA_DESCRICAO'
      Size = 164
    end
  end
  object CCU: TZQuery
    Connection = ZConnection_Principal
    Filter = 'TX_DESCRICAO LIKE  '#39'*'#39
    Filtered = True
    UpdateObject = ZUpdateSQL_CCU
    BeforeInsert = CCUBeforeInsert
    BeforeEdit = CCUBeforeEdit
    BeforePost = CCUBeforePost
    AfterDelete = CCUAfterDelete
    OnNewRecord = CCUNewRecord
    SQL.Strings = (
      '  SELECT CCU.*'
      '       , CDC.VA_CODIGO '
      '       , CDC.VA_DESCRICAO'
      
        '       , TIME_FORMAT(TIMEDIFF(CCU.DT_DATAHORAFINAL,CCU.DT_DATAHO' +
        'RAINICIAL),'#39'%H:%i:%s'#39') AS TOTAL'
      
        '       , TIME_TO_SEC(TIME_FORMAT(TIMEDIFF(CCU.DT_DATAHORAFINAL,C' +
        'CU.DT_DATAHORAINICIAL),'#39'%H:%i:%s'#39')) AS TOTAL_SEGUNDOS'
      '    FROM WINSTON.CCU CCU'
      '    JOIN WINSTON.CODIGOSDACCU CDC USING (TI_CODIGOSDACCU_ID)'
      'ORDER BY CCU.BI_CCU_ID')
    Params = <>
    Left = 58
    Top = 114
    object CCUBI_CCU_ID: TLargeintField
      FieldName = 'BI_CCU_ID'
    end
    object CCUTI_CODIGOSDACCU_ID: TSmallintField
      Tag = 1
      FieldName = 'TI_CODIGOSDACCU_ID'
    end
    object CCUTX_DESCRICAO: TMemoField
      FieldName = 'TX_DESCRICAO'
      BlobType = ftMemo
      Size = 65535
    end
    object CCUDT_DATAHORAINICIAL: TDateTimeField
      FieldName = 'DT_DATAHORAINICIAL'
    end
    object CCUDT_DATAHORAFINAL: TDateTimeField
      FieldName = 'DT_DATAHORAFINAL'
    end
    object CCUVA_CODIGO: TStringField
      FieldName = 'VA_CODIGO'
      Size = 10
    end
    object CCUVA_DESCRICAO: TStringField
      FieldName = 'VA_DESCRICAO'
      Size = 164
    end
    object CCUTOTAL: TStringField
      FieldName = 'TOTAL'
    end
    object CCUTOTAL_SEGUNDOS: TLargeintField
      FieldName = 'TOTAL_SEGUNDOS'
    end
  end
  object DataSource_CCU: TDataSource
    DataSet = CCU
    OnStateChange = DataSource_CCUStateChange
    Left = 181
    Top = 114
  end
  object DataSource_CODIGOSDACCU: TDataSource
    DataSet = CODIGOSDACCU
    Left = 180
    Top = 66
  end
  object ActionList_Principal: TActionList
    Left = 180
    Top = 18
    object Action_IniciarSequencial: TAction
      Caption = 'Iniciar'
      OnExecute = Action_IniciarSequencialExecute
    end
    object Action_FinalizarSequencial: TAction
      Caption = 'Finalizar'
      Enabled = False
      OnExecute = Action_FinalizarSequencialExecute
    end
    object Action_SalvarItemSequencial: TAction
      Caption = 'Action_SalvarItemSequencial'
      OnExecute = Action_SalvarItemSequencialExecute
    end
    object Action_CancelarSequencial: TAction
      Caption = 'Cancelar'
      Enabled = False
      OnExecute = Action_CancelarSequencialExecute
    end
    object Action_ExportarCCU: TAction
      Caption = 'Exportar CCU'
      OnExecute = Action_ExportarCCUExecute
    end
    object Action_ConfigurarDataSet: TAction
      Caption = 'Action_ConfigurarDataSet'
      OnExecute = Action_ConfigurarDataSetExecute
    end
    object Action_SalvarCCU: TAction
      OnExecute = Action_SalvarCCUExecute
    end
    object Action_IniciarLivre: TAction
      Caption = 'Iniciar'
      OnExecute = Action_IniciarLivreExecute
    end
    object Action_CancelarLivre: TAction
      Caption = 'Cancelar'
      Enabled = False
      OnExecute = Action_CancelarLivreExecute
    end
  end
  object ZUpdateSQL_CCU: TZUpdateSQL
    DeleteSQL.Strings = (
      'DELETE FROM WINSTON.CCU WHERE BI_CCU_ID = :OLD_BI_CCU_ID')
    InsertSQL.Strings = (
      'INSERT INTO WINSTON.CCU (TI_CODIGOSDACCU_ID'
      '                        ,TX_DESCRICAO'
      '                        ,DT_DATAHORAINICIAL'
      '                        ,DT_DATAHORAFINAL)'
      '     VALUES (:TI_CODIGOSDACCU_ID'
      '            ,:TX_DESCRICAO'
      '            ,:DT_DATAHORAINICIAL'
      '            ,:DT_DATAHORAFINAL) ')
    UseSequenceFieldForRefreshSQL = False
    Left = 275
    Top = 114
    ParamData = <
      item
        DataType = ftUnknown
        Name = 'TI_CODIGOSDACCU_ID'
        ParamType = ptUnknown
      end
      item
        DataType = ftUnknown
        Name = 'TX_DESCRICAO'
        ParamType = ptUnknown
      end
      item
        DataType = ftUnknown
        Name = 'DT_DATAHORAINICIAL'
        ParamType = ptUnknown
      end
      item
        DataType = ftUnknown
        Name = 'DT_DATAHORAFINAL'
        ParamType = ptUnknown
      end
      item
        DataType = ftUnknown
        Name = 'OLD_BI_CCU_ID'
        ParamType = ptUnknown
      end>
  end
  object Timer_Principal: TTimer
    OnTimer = Timer_PrincipalTimer
    Left = 58
    Top = 168
  end
  object SaveDialog_CCU: TSaveDialog
    DefaultExt = '.txt'
    Filter = 'Arquivos de texto (*.txt)|*.txt'
    Options = [ofOverwritePrompt, ofHideReadOnly, ofNoChangeDir, ofPathMustExist]
    Title = 'Indique o local e um nome de arquivo para a CCU'
    Left = 180
    Top = 168
  end
  object CFDBValidationChecks_CCU: TCFDBValidationChecks
    DataSet = CCU
    TableName = 'CCU'
    KeyField = 'BI_CCU_ID'
    CheckableFields = <
      item
        FieldName = 'BI_CCU_ID'
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
        FieldName = 'TI_CODIGOSDACCU_ID'
        FieldDescription = 'C'#211'DIGO DA CCU'
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
        FieldName = 'TX_DESCRICAO'
        FieldDescription = 'DESCRI'#199#195'O DA CCU'
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
        FieldName = 'DT_DATAHORAINICIAL'
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
        FieldName = 'DT_DATAHORAFINAL'
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
        FieldName = 'VA_CODIGO'
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
        FieldName = 'TOTAL'
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
        FieldName = 'DT_TOTAL'
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
        FieldName = 'TOTAL_SEGUNDOS'
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
    Left = 58
    Top = 216
  end
end
