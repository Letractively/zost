inherited BDODataModule_InformacoesDoEquipamento: TBDODataModule_InformacoesDoEquipamento
  object PROPOSTAS: TZReadOnlyQuery
    SQL.Strings = (
      '  SELECT OBR.VA_NOMEDAOBRA AS NOMEDAOBRA'
      '       , SIT.VA_DESCRICAO AS SITUACAO'
      
        '       , DATE_FORMAT(PRO.DT_DATAEHORADACRIACAO,'#39'%d/%m/%Y'#39') AS DA' +
        'TADEENTRADA'
      '       , FNC_GET_PROPOSAL_CODE(PRO.IN_PROPOSTAS_ID) AS CODIGO'
      '    FROM OBRAS OBR'
      '    JOIN PROPOSTAS PRO USING (IN_OBRAS_ID)'
      '    JOIN ITENS ITE USING (IN_PROPOSTAS_ID)'
      '    JOIN EQUIPAMENTOSDOSITENS EDI USING (IN_ITENS_ID)'
      '    JOIN SITUACOES SIT USING (TI_SITUACOES_ID)'
      '   WHERE EDI.IN_EQUIPAMENTOS_ID = :IN_EQUIPAMENTOS_ID'
      '     AND OBR.TI_MESPROVAVELDEENTREGA = :TI_MESPROVAVELDEENTREGA'
      '     AND OBR.YR_ANOPROVAVELDEENTREGA = :YR_ANOPROVAVELDEENTREGA'
      '     AND ITE.EN_VOLTAGEM = :EN_VOLTAGEM'
      'ORDER BY OBR.IN_OBRAS_ID'
      '       , PRO.IN_PROPOSTAS_ID'
      '       , ITE.IN_ITENS_ID'
      '       , EDI.IN_EQUIPAMENTOSDOSITENS_ID;')
    Params = <
      item
        DataType = ftUnknown
        Name = 'IN_EQUIPAMENTOS_ID'
        ParamType = ptUnknown
      end
      item
        DataType = ftUnknown
        Name = 'TI_MESPROVAVELDEENTREGA'
        ParamType = ptUnknown
      end
      item
        DataType = ftUnknown
        Name = 'YR_ANOPROVAVELDEENTREGA'
        ParamType = ptUnknown
      end
      item
        DataType = ftUnknown
        Name = 'EN_VOLTAGEM'
        ParamType = ptUnknown
      end>
    Left = 36
    Top = 78
    ParamData = <
      item
        DataType = ftUnknown
        Name = 'IN_EQUIPAMENTOS_ID'
        ParamType = ptUnknown
      end
      item
        DataType = ftUnknown
        Name = 'TI_MESPROVAVELDEENTREGA'
        ParamType = ptUnknown
      end
      item
        DataType = ftUnknown
        Name = 'YR_ANOPROVAVELDEENTREGA'
        ParamType = ptUnknown
      end
      item
        DataType = ftUnknown
        Name = 'EN_VOLTAGEM'
        ParamType = ptUnknown
      end>
  end
  object DataSource_PRO: TDataSource
    DataSet = PROPOSTAS
    Left = 36
    Top = 126
  end
end
