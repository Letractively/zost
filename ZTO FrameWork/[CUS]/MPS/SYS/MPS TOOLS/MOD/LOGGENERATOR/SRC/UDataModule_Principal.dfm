object DataModule_Principal: TDataModule_Principal
  OldCreateOrder = False
  OnCreate = DataModuleCreate
  Left = 928
  Top = 599
  Height = 205
  Width = 352
  object TRF5PRD: TZConnection
    Protocol = 'oracle-9i'
    Left = 18
    Top = 6
  end
  object HISTORICO: TZReadOnlyQuery
    Connection = TRF5PRD
    SQL.Strings = (
      'SELECT ID'
      
        '     , TO_CHAR(DTHRVERIFICACAO,'#39'DD/MM/YYYY "'#224's" HH24:MI:SS'#39') AS ' +
        'DTHRVERIFICACAO'
      '  FROM HISTVERIFICALOG')
    Params = <>
    Left = 84
    Top = 6
  end
  object DS_HISTORICO: TDataSource
    DataSet = HISTORICO
    Left = 84
    Top = 54
  end
  object DETALHES: TZReadOnlyQuery
    Connection = TRF5PRD
    SQL.Strings = (
      '  SELECT ID'
      '       , DONO'
      '       , TABELA'
      
        '       , TO_CHAR(DATACRIACAO,'#39'DD/MM/YYYY "'#224's" HH24:MI:SS'#39') AS DA' +
        'TACRIACAO'
      
        '       , TO_CHAR(DATAMODIFICACAO,'#39'DD/MM/YYYY "'#224's" HH24:MI:SS'#39') A' +
        'S DATAMODIFICACAO'
      '       , TRIGGERS'
      '       , TABELALOG'
      
        '       , TO_CHAR(DATACRIACAOLOG,'#39'DD/MM/YYYY "'#224's" HH24:MI:SS'#39') AS' +
        ' DATACRIACAOLOG'
      
        '       , TO_CHAR(DATAMODIFICACAOLOG,'#39'DD/MM/YYYY "'#224's" HH24:MI:SS'#39 +
        ') AS DATAMODIFICACAOLOG'
      '    FROM HISTVERIFICALOGDET'
      '   WHERE ID = :ID'
      'ORDER BY TABELA')
    Params = <
      item
        DataType = ftUnknown
        Name = 'ID'
        ParamType = ptUnknown
      end>
    DataSource = DS_HISTORICO
    Left = 168
    Top = 6
    ParamData = <
      item
        DataType = ftUnknown
        Name = 'ID'
        ParamType = ptUnknown
      end>
    object DETALHESIDVERIFICACAODET: TLargeintField
      FieldName = 'IDVERIFICACAODET'
    end
    object DETALHESIDVERIFICACAO: TLargeintField
      FieldName = 'IDVERIFICACAO'
      Required = True
    end
    object DETALHESDONO: TStringField
      FieldName = 'DONO'
      Required = True
      Size = 64
    end
    object DETALHESTABELA: TStringField
      FieldName = 'TABELA'
      Required = True
      Size = 64
    end
    object DETALHESDATACRIACAO: TStringField
      FieldName = 'DATACRIACAO'
      ReadOnly = True
      Size = 22
    end
    object DETALHESDATAMODIFICACAO: TStringField
      FieldName = 'DATAMODIFICACAO'
      ReadOnly = True
      Size = 22
    end
    object DETALHESTRIGGERS: TLargeintField
      FieldName = 'TRIGGERS'
      Required = True
    end
    object DETALHESTABELALOG: TStringField
      FieldName = 'TABELALOG'
      Size = 64
    end
    object DETALHESDATACRIACAOLOG: TStringField
      FieldName = 'DATACRIACAOLOG'
      ReadOnly = True
      OnGetText = DETALHESDATACRIACAOLOGGetText
      Size = 22
    end
    object DETALHESDATAMODIFICACAOLOG: TStringField
      FieldName = 'DATAMODIFICACAOLOG'
      ReadOnly = True
      OnGetText = DETALHESDATAMODIFICACAOLOGGetText
      Size = 22
    end
  end
  object DS_DETALHES: TDataSource
    DataSet = DETALHES
    Left = 168
    Top = 54
  end
  object SaveDialog_Script: TSaveDialog
    DefaultExt = '.sql'
    FileName = 'D:\Documents and Settings\t_cbfilho\Desktop\aa.sql'
    Filter = 'Script SQL (*.sql)|*.sql'
    Options = [ofHideReadOnly, ofExtensionDifferent, ofEnableSizing]
    Title = 'Salvar Script como...'
    Left = 84
    Top = 99
  end
  object COLUNAS: TZReadOnlyQuery
    Connection = TRF5PRD
    Params = <>
    DataSource = DS_DETALHES
    Left = 252
    Top = 6
    object COLUNASDONO: TStringField
      FieldName = 'DONO'
      Size = 64
    end
    object COLUNASTABELAORI: TStringField
      FieldName = 'TABELAORI'
      Size = 64
    end
    object COLUNASCOLUNAORI: TStringField
      FieldName = 'COLUNAORI'
      Size = 30
    end
    object COLUNASTIPOORI: TStringField
      FieldName = 'TIPOORI'
      Size = 106
    end
    object COLUNASTAMANHOORI: TLargeintField
      FieldName = 'TAMANHOORI'
    end
    object COLUNASPRECISAOORI: TLargeintField
      FieldName = 'PRECISAOORI'
    end
    object COLUNASESCALAORI: TLargeintField
      FieldName = 'ESCALAORI'
    end
    object COLUNASANULAVELORI: TStringField
      FieldName = 'ANULAVELORI'
      OnGetText = COLUNASANULAVELORIGetText
      Size = 1
    end
    object COLUNASTIPOALTER: TStringField
      FieldName = 'TIPOALTER'
      Size = 6
    end
  end
  object DS_COLUNAS: TDataSource
    DataSet = COLUNAS
    Left = 252
    Top = 54
  end
end
