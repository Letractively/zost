inherited BDODataModule_InformacoesDaProposta: TBDODataModule_InformacoesDaProposta
  Height = 202
  Width = 381
  object DataSource_PRO: TDataSource
    DataSet = PROPOSTAS
    Left = 37
    Top = 117
  end
  object DataSource_ITE: TDataSource
    DataSet = ITENS
    Left = 98
    Top = 134
  end
  object DataSource_EDI: TDataSource
    DataSet = EQUIPAMENTOSDOSITENS
    Left = 184
    Top = 147
  end
  object PROPOSTAS: TZReadOnlyQuery
    AutoCalcFields = False
    SQL.Strings = (
      'SELECT PRO.IN_PROPOSTAS_ID'
      '     , OBR.VA_NOMEDAOBRA'
      
        '     , DATE_FORMAT(PRO.DT_DATAEHORADACRIACAO,'#39'%d/%m/%Y '#224's %H:%i:' +
        '%s'#39') AS DATADAENTRADA'
      '     , CONCAT(PRO.TI_VALIDADE,'#39' DIAS'#39') VALIDADE'
      '     , INS.VA_NOME'
      '     , ELT(PRO.TI_MOEDA,'#39'US$'#39','#39#8364#39','#39'R$'#39','#39#163#39','#39#165#39') AS MOEDAORIGINAL'
      '     , PRO.VA_CONTATO'
      '     , REG.VA_REGIAO'
      '     , CONCAT(OBR.VA_CIDADE,'#39' / '#39',OBR.CH_ESTADO) AS LOCALIDADE'
      '     , SIT.VA_DESCRICAO AS SITUACAO'
      '     , OBR.IN_OBRAS_ID'
      
        '     , CONCAT(ELT(TI_MESPROVAVELDEENTREGA,'#39'Janeiro'#39','#39'Fevereiro'#39',' +
        #39'Mar'#231'o'#39','#39'Abril'#39','#39'Maio'#39','#39'Junho'#39','#39'Julho'#39','#39'Agosto'#39','#39'Setembro'#39','#39'Outu' +
        'bro'#39','#39'Novembro'#39','#39'Dezembro'#39')'
      '             ,'#39' de '#39
      '             ,YR_ANOPROVAVELDEENTREGA) AS DATAPROVAVELDEENTREGA'
      '     , OBR.VA_CONSTRUTORA'
      '     , PRJ.VA_NOME AS PROJETISTA'
      '  FROM PROPOSTAS PRO'
      '  JOIN OBRAS OBR USING(IN_OBRAS_ID)'
      '  JOIN INSTALADORES INS USING (SM_INSTALADORES_ID)'
      '  JOIN REGIOES REG USING (TI_REGIOES_ID)'
      '  JOIN SITUACOES SIT USING (TI_SITUACOES_ID)'
      '  JOIN PROJETISTAS PRJ USING (SM_PROJETISTAS_ID)'
      ' WHERE PRO.IN_PROPOSTAS_ID = :IN_PROPOSTAS_ID')
    Params = <
      item
        DataType = ftUnknown
        Name = 'IN_PROPOSTAS_ID'
        ParamType = ptUnknown
      end>
    Left = 37
    Top = 73
    ParamData = <
      item
        DataType = ftUnknown
        Name = 'IN_PROPOSTAS_ID'
        ParamType = ptUnknown
      end>
    object PROPOSTASIN_PROPOSTAS_ID: TIntegerField
      FieldName = 'IN_PROPOSTAS_ID'
    end
    object PROPOSTASVA_NOMEDAOBRA: TStringField
      FieldName = 'VA_NOMEDAOBRA'
      Size = 128
    end
    object PROPOSTASDATADAENTRADA: TStringField
      FieldName = 'DATADAENTRADA'
      Size = 25
    end
    object PROPOSTASVA_NOME: TStringField
      FieldName = 'VA_NOME'
      Size = 64
    end
    object PROPOSTASVALIDADE: TStringField
      FieldName = 'VALIDADE'
      Size = 8
    end
    object PROPOSTASMOEDAORIGINAL: TStringField
      FieldName = 'MOEDAORIGINAL'
      Size = 4
    end
    object PROPOSTASVA_CONTATO: TStringField
      FieldName = 'VA_CONTATO'
      Size = 64
    end
    object PROPOSTASVA_REGIAO: TStringField
      FieldName = 'VA_REGIAO'
      Size = 8
    end
    object PROPOSTASLOCALIDADE: TStringField
      FieldName = 'LOCALIDADE'
      Size = 66
    end
    object PROPOSTASSITUACAO: TStringField
      FieldName = 'SITUACAO'
      Size = 32
    end
    object PROPOSTASIN_OBRAS_ID: TIntegerField
      FieldName = 'IN_OBRAS_ID'
    end
    object PROPOSTASDATAPROVAVELDEENTREGA: TStringField
      FieldName = 'DATAPROVAVELDEENTREGA'
      Size = 17
    end
    object PROPOSTASVA_CONSTRUTORA: TStringField
      FieldName = 'VA_CONSTRUTORA'
      Size = 64
    end
    object PROPOSTASPROJETISTA: TStringField
      FieldName = 'PROJETISTA'
      Size = 64
    end
  end
  object ITENS: TZReadOnlyQuery
    AutoCalcFields = False
    SQL.Strings = (
      '  SELECT ITE.IN_ITENS_ID'
      '#       , ITE.IN_PROPOSTAS_ID'
      '#       , ITE.TI_FAMILIAS_ID'
      '       , ITE.VA_DESCRICAO'
      '#       , ITE.FL_CAPACIDADE'
      '#       , ITE.TI_UNIDADES_ID'
      '       , ITE.SM_QUANTIDADE'
      '       , ITE.EN_VOLTAGEM'
      '#       , ITE.FL_DESCONTOPERC'
      '#       , ITE.TI_ORDEM'
      '#       , FAM.VA_DESCRICAO AS FAMILIA'
      '#       , FNC_GET_BRUTE_PROFIT(ITE.IN_ITENS_ID) AS LUCROBRUTO'
      
        '       , FNC_GET_FORMATTED_CAPACITY(ITE.FL_CAPACIDADE,UNI.VA_ABR' +
        'EVIATURA) AS CAPACIDADE'
      
        '#       , FNC_GET_FORMATTED_CURRENCY_VALUE(FNC_GET_ITEM_VALUE(IT' +
        'E.IN_ITENS_ID,TRUE,FALSE,NULL,2), ELT(FNC_GET_CURRENCY_CODE(ITE.' +
        'IN_ITENS_ID),'#39'US$'#39','#39#8364#39','#39'R$'#39','#39#163#39','#39#165#39'),FALSE) AS SUBTOTAL'
      
        '#       , FNC_GET_FORMATTED_PERCENTUAL(ITE.FL_DESCONTOPERC,TRUE)' +
        ' AS REAJUSTE'
      
        '#       , FNC_GET_FORMATTED_CURRENCY_VALUE(FNC_GET_ITEM_VALUE(IT' +
        'E.IN_ITENS_ID,FALSE,FALSE,NULL,2),ELT(FNC_GET_CURRENCY_CODE(ITE.' +
        'IN_ITENS_ID),'#39'US$'#39','#39#8364#39','#39'R$'#39','#39#163#39','#39#165#39'),FALSE) AS TOTAL'
      
        '#       , FNC_GET_FORMATTED_PERCENTUAL(FNC_GET_BRUTE_PROFIT(ITE.' +
        'IN_ITENS_ID),FALSE) AS LUCROBRUTOFMT'
      '    FROM ITENS ITE'
      '#    JOIN PROPOSTAS PRO USING (IN_PROPOSTAS_ID)'
      '    JOIN FAMILIAS FAM USING (TI_FAMILIAS_ID)'
      '    JOIN UNIDADES UNI USING (TI_UNIDADES_ID)'
      '   WHERE ITE.IN_PROPOSTAS_ID = :IN_PROPOSTAS_ID'
      'ORDER BY ITE.TI_ORDEM')
    Params = <
      item
        DataType = ftUnknown
        Name = 'IN_PROPOSTAS_ID'
        ParamType = ptUnknown
      end>
    DataSource = DataSource_PRO
    Left = 98
    Top = 89
    ParamData = <
      item
        DataType = ftUnknown
        Name = 'IN_PROPOSTAS_ID'
        ParamType = ptUnknown
      end>
    object ITENSIN_ITENS_ID: TIntegerField
      DisplayWidth = 10
      FieldName = 'IN_ITENS_ID'
    end
    object ITENSVA_DESCRICAO: TStringField
      DisplayWidth = 150
      FieldName = 'VA_DESCRICAO'
      Required = True
      Size = 150
    end
    object ITENSSM_QUANTIDADE: TIntegerField
      Alignment = taCenter
      DisplayWidth = 10
      FieldName = 'SM_QUANTIDADE'
      Required = True
    end
    object ITENSEN_VOLTAGEM: TStringField
      DisplayWidth = 6
      FieldName = 'EN_VOLTAGEM'
      Required = True
      Size = 6
    end
    object ITENSCAPACIDADE: TStringField
      Alignment = taCenter
      DisplayWidth = 20
      FieldName = 'CAPACIDADE'
    end
  end
  object EQUIPAMENTOSDOSITENS: TZReadOnlyQuery
    AutoCalcFields = False
    SQL.Strings = (
      'SELECT EDI.IN_EQUIPAMENTOSDOSITENS_ID'
      '#     , EDI.IN_ITENS_ID'
      '#     , EDI.IN_EQUIPAMENTOS_ID'
      '#     , EDI.FL_LUCROBRUTO'
      '#     , EDI.FL_VALORUNITARIO'
      '#     , EDI.TI_MOEDA'
      '     , EQP.VA_MODELO AS MODELO'
      
        '#     , FNC_GET_FORMATTED_CURRENCY_VALUE((FNC_GET_ICMS_MULTIPLIE' +
        'R(OBR.IN_OBRAS_ID) * EDI.FL_VALORUNITARIO),ELT(EDI.TI_MOEDA,'#39'US$' +
        #39','#39#8364#39','#39'R$'#39','#39#163#39','#39#165#39'),FALSE) AS VALORCOMIMPOSTOS'
      
        '#     , FNC_GET_FORMATTED_PERCENTUAL(EDI.FL_LUCROBRUTO,FALSE) AS' +
        ' LUCROBRUTO'
      '  FROM EQUIPAMENTOSDOSITENS EDI'
      '  JOIN EQUIPAMENTOS EQP USING (IN_EQUIPAMENTOS_ID)'
      '#  JOIN ITENS ITE USING (IN_ITENS_ID)'
      '#  JOIN PROPOSTAS PRO USING (IN_PROPOSTAS_ID)'
      '#  JOIN OBRAS OBR USING (IN_OBRAS_ID)'
      ' WHERE EDI.IN_ITENS_ID = :IN_ITENS_ID;')
    Params = <
      item
        DataType = ftUnknown
        Name = 'IN_ITENS_ID'
        ParamType = ptUnknown
      end>
    DataSource = DataSource_ITE
    Left = 183
    Top = 101
    ParamData = <
      item
        DataType = ftUnknown
        Name = 'IN_ITENS_ID'
        ParamType = ptUnknown
      end>
    object EQUIPAMENTOSDOSITENSIN_EQUIPAMENTOSDOSITENS_ID: TIntegerField
      DisplayWidth = 10
      FieldName = 'IN_EQUIPAMENTOSDOSITENS_ID'
    end
    object EQUIPAMENTOSDOSITENSMODELO: TStringField
      Alignment = taCenter
      DisplayWidth = 64
      FieldName = 'MODELO'
      Size = 64
    end
  end
end
