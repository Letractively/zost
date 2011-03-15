inherited BDOForm_Relatorio_JDO: TBDOForm_Relatorio_JDO
  Caption = 'Relat'#243'rio de justificativas das obras'
  PixelsPerInch = 96
  TextHeight = 13
  inherited Panel_Header: TPanel
    inherited Label_DialogDescription: TLabel
      Caption = 
        'Este relat'#243'rio exibe as justificativas das obras. Configure as o' +
        'p'#231#245'es segundo suas necessidades. Clique o bot'#227'o "Configurar" par' +
        'a definir op'#231#245'es espec'#237'ficas da impress'#227'o, como margens e impres' +
        's'#227'o de cores. Para salvar esta proposta como um conjunto de arqu' +
        'ivos, clique o bot'#227'o "Salvar...". Para imprimir imediatamente, c' +
        'lique o bot'#227'o "Imprimir agora!" Dentro do relat'#243'rio, links, quan' +
        'do dispon'#237'veis, podem ser clicados para exibir mais informa'#231#245'es ' +
        'sobre um item.'
    end
  end
  inherited GroupBox_VisualizarImpressao: TGroupBox
    inherited PageControl_OpcoesEFiltragem: TPageControl
      inherited TabSheet_OpcoesDeListagem: TTabSheet
        object Bevel2: TBevel
          Left = 91
          Top = 1
          Width = 2
          Height = 54
          Shape = bsLeftLine
        end
        object RadioButton_PorRegiao: TRadioButton
          Left = 1
          Top = 1
          Width = 76
          Height = 13
          Caption = 'Por regi'#227'o'
          Checked = True
          TabOrder = 0
          TabStop = True
          OnClick = DoRecarregar
        end
        object RadioButton_PorInstalador: TRadioButton
          Left = 1
          Top = 22
          Width = 83
          Height = 13
          Caption = 'Por instalador'
          TabOrder = 1
          OnClick = DoRecarregar
        end
        object RadioButton_PorFamilia: TRadioButton
          Left = 1
          Top = 43
          Width = 66
          Height = 13
          Caption = 'Por fam'#237'lia'
          TabOrder = 2
          OnClick = DoRecarregar
        end
        object RadioButton_ApenasSumario: TRadioButton
          Left = 98
          Top = 1
          Width = 93
          Height = 13
          Caption = 'Apenas sum'#225'rio'
          TabOrder = 3
          OnClick = DoRecarregar
        end
      end
      inherited TabSheet_OpcoesDeFiltragem: TTabSheet
        object Label_OpcoesDisponiveis: TLabel
          Left = 1
          Top = 1
          Width = 68
          Height = 13
          Cursor = crHandPoint
          Caption = 'Regi'#227'o a listar'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clGreen
          Font.Height = -11
          Font.Name = 'Tahoma'
          Font.Style = []
          ParentFont = False
          OnClick = Label_OpcoesDisponiveisClick
        end
        object Bevel3: TBevel
          Left = 429
          Top = 1
          Width = 2
          Height = 54
          Shape = bsLeftLine
        end
        object ComboBox_OpcaoDeListagem: TComboBox
          Left = 1
          Top = 15
          Width = 422
          Height = 21
          Style = csDropDownList
          Anchors = [akLeft, akTop, akRight]
          ItemHeight = 13
          TabOrder = 0
          OnChange = DoRecarregar
        end
        object CheckBox_DT_DATAEHORADACRIACAO1: TCheckBox
          Left = 437
          Top = 8
          Width = 89
          Height = 13
          Alignment = taLeftJustify
          Anchors = [akTop, akRight]
          Caption = 'No per'#237'odo de'
          TabOrder = 1
          OnClick = CheckBox_DT_DATAEHORADACRIACAO1Click
        end
        object CheckBox_DT_DATAEHORADACRIACAO2: TCheckBox
          Left = 491
          Top = 38
          Width = 35
          Height = 13
          Alignment = taLeftJustify
          Anchors = [akTop, akRight]
          Caption = 'at'#233
          TabOrder = 2
          OnClick = CheckBox_DT_DATAEHORADACRIACAO1Click
        end
        object DateTimePicker_DT_DATAEHORADACRIACAO1: TDateTimePicker
          Left = 532
          Top = 4
          Width = 85
          Height = 21
          Anchors = [akTop, akRight]
          Date = 38260.000000000000000000
          Format = 'dd/MM/yyyy'
          Time = 38260.000000000000000000
          Checked = False
          Enabled = False
          TabOrder = 3
          OnChange = DoRecarregar
        end
        object DateTimePicker_DT_DATAEHORADACRIACAO2: TDateTimePicker
          Left = 532
          Top = 34
          Width = 85
          Height = 21
          Anchors = [akTop, akRight]
          BiDiMode = bdLeftToRight
          Date = 38260.000000000000000000
          Format = 'dd/MM/yyyy'
          Time = 38260.000000000000000000
          Checked = False
          Enabled = False
          ParentBiDiMode = False
          TabOrder = 4
          OnChange = DoRecarregar
        end
      end
      inherited TabSheet_OpcoesDeExibicao: TTabSheet
        object Bevel1: TBevel
          Left = 190
          Top = 1
          Width = 2
          Height = 54
          Shape = bsLeftLine
        end
        object CheckBox_ExibirPeriodo: TCheckBox
          Left = 1
          Top = 1
          Width = 82
          Height = 13
          Caption = 'Exibir per'#237'odo'
          Checked = True
          State = cbChecked
          TabOrder = 0
          OnClick = DoRecarregar
        end
        object CheckBox_ExibirSumarioGeral: TCheckBox
          Left = 1
          Top = 22
          Width = 110
          Height = 13
          Caption = 'Exibir sum'#225'rio geral'
          Checked = True
          State = cbChecked
          TabOrder = 1
          OnClick = DoRecarregar
        end
        object CheckBox_QtdParcCom: TCheckBox
          Left = 1
          Top = 43
          Width = 183
          Height = 13
          Caption = 'Exibir quandidade comercial parcial'
          Checked = True
          State = cbChecked
          TabOrder = 2
          OnClick = DoRecarregar
        end
        object CheckBox_QtdParcTec: TCheckBox
          Left = 198
          Top = 1
          Width = 173
          Height = 13
          Caption = 'Exibir quandidade t'#233'cnica parcial'
          Checked = True
          State = cbChecked
          TabOrder = 3
          OnClick = DoRecarregar
        end
        object CheckBox_QtdParcTot: TCheckBox
          Left = 198
          Top = 22
          Width = 161
          Height = 13
          Caption = 'Exibir quandidade parcial total'
          Checked = True
          State = cbChecked
          TabOrder = 4
          OnClick = DoRecarregar
        end
      end
    end
  end
  inherited ActionList_LocalActions: TActionList
    Images = BDODataModule_Relatorio_JDO.ImageList_Local
  end
end
