object DataModule_Principal: TDataModule_Principal
  OldCreateOrder = False
  OnCreate = DataModuleCreate
  Left = 626
  Top = 199
  Height = 291
  Width = 780
  object DATABASE: TZConnection
    Protocol = 'oracle'
    HostName = 'TAMANDARE'
    Database = 'TRF5DSV'
    User = 'ATENAS'
    Password = 'ATENAS'
    Left = 24
    Top = 12
  end
  object ORIGEM: TZReadOnlyQuery
    Connection = DATABASE
    SQL.Strings = (
      'SELECT CODORIG'
      '     , DESCRGERA'
      '     , SGGERA'
      '     , CODTIT'
      '  FROM ORIGEM D'
      ' WHERE D.CODORIG = :CODORIG'
      '   AND D.TIPSITOPER = '#39'A'#39)
    Params = <
      item
        DataType = ftUnknown
        Name = 'CODORIG'
        ParamType = ptUnknown
      end>
    Left = 90
    Top = 12
    ParamData = <
      item
        DataType = ftUnknown
        Name = 'CODORIG'
        ParamType = ptUnknown
      end>
  end
  object TIPODOCUMENTO: TZReadOnlyQuery
    Connection = DATABASE
    SQL.Strings = (
      'SELECT CODTIPDOC, DESCR AS DESCRGERA'
      '  FROM TIPODOCUMENTO D'
      ' WHERE D.TIPSITOPER = '#39'A'#39)
    Params = <>
    Left = 162
    Top = 12
  end
  object RECURSO: TZReadOnlyQuery
    Connection = DATABASE
    SQL.Strings = (
      'SELECT D.CODREC'
      '     , D.SGREC'
      '     , D.DESCR AS DESCREC'
      '  FROM RECURSO D')
    Params = <>
    Left = 24
    Top = 60
  end
  object ORGAOJULGADOR: TZReadOnlyQuery
    Connection = DATABASE
    SQL.Strings = (
      'SELECT O.CODORIG'
      '     , O.CODORGJULG'
      '     , O.NOME AS ORGAOJULG'
      '  FROM ORGAOJULGADOR O')
    Params = <>
    Left = 108
    Top = 60
  end
  object TITULO: TZReadOnlyQuery
    Connection = DATABASE
    SQL.Strings = (
      'SELECT CODTIT'
      '     , DESCRFEM'
      '     , DESCRMAS'
      '  FROM TITULO T'
      ' WHERE T.TIPSITOPER = '#39'A'#39)
    Params = <>
    Left = 186
    Top = 60
  end
  object MAGISTRADO: TZReadOnlyQuery
    Connection = DATABASE
    SQL.Strings = (
      'SELECT CODMAG'
      '     , NOME'
      '     , TIPSEXO'
      '  FROM MAGISTRADO M')
    Params = <>
    Left = 24
    Top = 108
  end
  object MASCARA: TZReadOnlyQuery
    Connection = DATABASE
    SQL.Strings = (
      'SELECT CODMASC'
      '     , DESCRFRMT'
      '  FROM MASCARA M')
    Params = <>
    Left = 96
    Top = 108
  end
  object CODSELECAO: TZReadOnlyQuery
    Connection = DATABASE
    Params = <>
    Left = 162
    Top = 108
  end
  object CONFIGSISTEMA: TZReadOnlyQuery
    Connection = DATABASE
    SQL.Strings = (
      'SELECT CODORIGLEG'
      '     , ANONORMALEG'
      '     , NUMPAG'
      '     , DTPUBL'
      '     , NUMPUBL'
      '     , DTULTGERA'
      '  FROM CONFIGSISTEMA')
    Params = <>
    Left = 246
    Top = 108
  end
  object TIPOREFERENCIA: TZReadOnlyQuery
    Connection = DATABASE
    SQL.Strings = (
      'SELECT CODTIPREF'
      '     , SGTIPREF'
      '  FROM TIPOREFERENCIA')
    Params = <>
    Left = 36
    Top = 156
  end
  object CONFIGINTEGRACAOORIGEM: TZReadOnlyQuery
    Connection = DATABASE
    SQL.Strings = (
      'SELECT DESCRENDCONSWEB'
      '  FROM CONFIGINTEGRACAOORIGEM'
      ' WHERE CODORIG = 1')
    Params = <>
    Left = 168
    Top = 156
  end
  object DOCUMENTO: TZReadOnlyQuery
    Connection = DATABASE
    Params = <>
    Left = 372
    Top = 12
  end
  object DOCPUBLICACAO: TZReadOnlyQuery
    Connection = DATABASE
    Params = <>
    Left = 372
    Top = 60
  end
  object TEXTOEMENTA: TZReadOnlyQuery
    Connection = DATABASE
    Params = <>
    Left = 372
    Top = 108
  end
  object REFERENCIALEGISLATIVA: TZReadOnlyQuery
    Connection = DATABASE
    Params = <>
    Left = 372
    Top = 156
  end
  object TEXTOOBSERVACAO: TZReadOnlyQuery
    Connection = DATABASE
    Params = <>
    Left = 498
    Top = 12
  end
  object TEXTOINDEXACAO: TZReadOnlyQuery
    Connection = DATABASE
    Params = <>
    Left = 498
    Top = 60
  end
  object TEXTODECISAO: TZReadOnlyQuery
    Connection = DATABASE
    Params = <>
    Left = 498
    Top = 60
  end
  object TEXTOREFERENCIA: TZReadOnlyQuery
    Connection = DATABASE
    Params = <>
    Left = 498
    Top = 108
  end
  object TEXTOPRECEDENTE: TZReadOnlyQuery
    Connection = DATABASE
    Params = <>
    Left = 498
    Top = 156
  end
  object TEXTOSUCESSIVO: TZReadOnlyQuery
    Connection = DATABASE
    Params = <>
    Left = 654
    Top = 12
  end
  object DOCUMENTODOUTRINA: TZReadOnlyQuery
    Connection = DATABASE
    Params = <>
    Left = 654
    Top = 60
  end
  object DOCUMENTONUMEROREFERENCIA: TZReadOnlyQuery
    Connection = DATABASE
    Params = <>
    Left = 654
    Top = 108
  end
end
