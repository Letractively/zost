inherited BDOForm_Relatorio_OBR: TBDOForm_Relatorio_OBR
  Caption = 'Gerador de relat'#243'rio de Obras'
  PixelsPerInch = 96
  TextHeight = 13
  inherited Panel_Header: TPanel
    inherited Label_DialogDescription: TLabel
      Caption = 
        'Este relat'#243'rio exibe as obras encontradas por tipo, situa'#231#227'o, es' +
        'tado ou regi'#227'o. Configure as op'#231#245'es segundo suas necessidades. C' +
        'lique o bot'#227'o "Configurar" para definir op'#231#245'es espec'#237'ficas da im' +
        'press'#227'o, como margens e impress'#227'o de cores. Para salvar esta pro' +
        'posta como um conjunto de arquivos, clique o bot'#227'o "Salvar...". ' +
        'Para imprimir imediatamente, clique o bot'#227'o "Imprimir agora!" De' +
        'ntro do relat'#243'rio, links, quando dispon'#237'veis, podem ser clicados' +
        ' para exibir mais informa'#231#245'es sobre um item.'
    end
  end
  inherited GroupBox_VisualizarImpressao: TGroupBox
    inherited PageControl_OpcoesEFiltragem: TPageControl
      inherited TabSheet_OpcoesDeListagem: TTabSheet
        object Bevel1: TBevel
          Left = 83
          Top = 1
          Width = 2
          Height = 55
          Shape = bsLeftLine
        end
        object Label_RegioesDisponiveis: TLabel
          Left = 91
          Top = 1
          Width = 68
          Height = 13
          Cursor = crHandPoint
          Caption = 'Regi'#227'o a listar'
          Enabled = False
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clGreen
          Font.Height = -11
          Font.Name = 'Tahoma'
          Font.Style = []
          ParentFont = False
          OnClick = Label_RegioesDisponiveisClick
        end
        object RadioButtonPorTipo: TRadioButton
          Left = 1
          Top = 1
          Width = 76
          Height = 13
          Caption = 'Por tipo'
          Checked = True
          TabOrder = 0
          TabStop = True
          OnClick = DoRecarregar
        end
        object RadioButtonPorSituacao: TRadioButton
          Left = 1
          Top = 15
          Width = 76
          Height = 13
          Caption = 'Por situa'#231#227'o'
          TabOrder = 1
          OnClick = DoRecarregar
        end
        object RadioButtonPorEstado: TRadioButton
          Left = 1
          Top = 29
          Width = 76
          Height = 13
          Caption = 'Por estado'
          TabOrder = 2
          OnClick = DoRecarregar
        end
        object RadioButtonPorRegiao: TRadioButton
          Left = 1
          Top = 43
          Width = 66
          Height = 13
          Caption = 'Por regi'#227'o'
          TabOrder = 3
          OnClick = DoRecarregar
        end
        object ComboBox_RegiosDisponiveis: TComboBox
          Left = 91
          Top = 15
          Width = 68
          Height = 21
          Style = csDropDownList
          Enabled = False
          ItemHeight = 13
          TabOrder = 4
          OnChange = DoRecarregar
        end
      end
      inherited TabSheet_OpcoesDeFiltragem: TTabSheet
        object CheckBoxContarComGanhas: TCheckBox
          Left = 1
          Top = 1
          Width = 115
          Height = 13
          Caption = 'Com obras ganhas'
          Checked = True
          State = cbChecked
          TabOrder = 0
          OnClick = DoRecarregar
        end
        object CheckBoxContarComPerdidas: TCheckBox
          Left = 1
          Top = 22
          Width = 115
          Height = 13
          Caption = 'Com obras perdidas'
          Checked = True
          State = cbChecked
          TabOrder = 1
          OnClick = DoRecarregar
        end
        object CheckBoxContarComSuspensas: TCheckBox
          Left = 1
          Top = 43
          Width = 115
          Height = 13
          Caption = 'Com obras suspensas'
          Checked = True
          State = cbChecked
          TabOrder = 2
          OnClick = DoRecarregar
        end
        object CheckBox_DA_DATADEENTRADA1: TCheckBox
          Left = 440
          Top = 5
          Width = 87
          Height = 13
          Alignment = taLeftJustify
          Anchors = [akTop, akRight]
          Caption = 'No per'#237'odo de'
          TabOrder = 3
          OnClick = CheckBox_DA_DATADEENTRADA1Click
        end
        object CheckBox_DA_DATADEENTRADA2: TCheckBox
          Left = 491
          Top = 39
          Width = 36
          Height = 13
          Alignment = taLeftJustify
          Anchors = [akTop, akRight]
          Caption = 'at'#233
          TabOrder = 4
          OnClick = CheckBox_DA_DATADEENTRADA1Click
        end
        object DateTimePicker_DA_DATADEENTRADA1: TDateTimePicker
          Left = 533
          Top = 1
          Width = 85
          Height = 21
          Anchors = [akTop, akRight]
          Date = 38260.000000000000000000
          Format = 'dd/MM/yyyy'
          Time = 38260.000000000000000000
          Checked = False
          Enabled = False
          TabOrder = 5
          OnChange = DoRecarregar
        end
        object DateTimePicker_DA_DATADEENTRADA2: TDateTimePicker
          Left = 533
          Top = 35
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
          TabOrder = 6
          OnChange = DoRecarregar
        end
      end
      inherited TabSheet_OpcoesDeExibicao: TTabSheet
        object Bevel3: TBevel
          Left = 98
          Top = 4
          Width = 2
          Height = 49
          Shape = bsLeftLine
        end
        object Bevel4: TBevel
          Left = 194
          Top = 4
          Width = 2
          Height = 49
          Shape = bsLeftLine
        end
        object Label_PRO_VA_COTACOES: TLabel
          Left = 202
          Top = 1
          Width = 81
          Height = 13
          Anchors = [akTop, akRight]
          Caption = 'Moeda/Cota'#231#245'es'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'Tahoma'
          Font.Style = []
          ParentFont = False
        end
        object CheckBoxExibirSituacoes: TCheckBox
          Left = 1
          Top = 1
          Width = 91
          Height = 13
          Caption = 'Exibir situa'#231#245'es'
          TabOrder = 0
          OnClick = DoRecarregar
        end
        object CheckBoxExibirPeriodo: TCheckBox
          Left = 1
          Top = 22
          Width = 91
          Height = 13
          Caption = 'Exibir per'#237'odo'
          Checked = True
          State = cbChecked
          TabOrder = 1
          OnClick = DoRecarregar
        end
        object CheckBoxExibirQuantidades: TCheckBox
          Left = 1
          Top = 43
          Width = 91
          Height = 13
          Caption = 'Exibir qtds.'
          TabOrder = 2
          OnClick = DoRecarregar
        end
        object CheckBoxExibirValores: TCheckBox
          Left = 106
          Top = 1
          Width = 82
          Height = 13
          Caption = 'Exibir valores'
          Checked = True
          State = cbChecked
          TabOrder = 3
          OnClick = DoRecarregar
        end
        object CheckBoxExibirTotais: TCheckBox
          Left = 106
          Top = 22
          Width = 82
          Height = 13
          Caption = 'Exibir totais'
          Checked = True
          State = cbChecked
          TabOrder = 4
          OnClick = DoRecarregar
        end
        object Panel_PRO_TI_MOEDA_VA_COTACOES: TPanel
          Left = 202
          Top = 15
          Width = 81
          Height = 21
          Anchors = [akTop, akRight]
          BevelOuter = bvNone
          TabOrder = 5
          object SpeedButton_PRO_VA_COTACOES: TSpeedButton
            Left = 60
            Top = 0
            Width = 21
            Height = 21
            Cursor = crHandPoint
            Action = Action_DefinirCotacoes
            Flat = True
            Glyph.Data = {
              36080000424D3608000000000000360000002800000020000000100000000100
              2000000000000008000000000000000000000000000000000000FF00FF00FF00
              FF00FF00FF008E471E0087441E0080411F0087441E00FF00FF00FF00FF00005E
              C100005DBE000052AF000057B100FF00FF00FF00FF00FF00FF00FF00FF00FF00
              FF00FF00FF0077777700727272006F6F6F0072727200FF00FF00FF00FF00A7A7
              A700A6A6A6009D9D9D00A0A0A000FF00FF00FF00FF00FF00FF00FF00FF009852
              260098522600D16B0000CC6E0B00C5670600A04E0A00633C24001879D4003793
              E40067AEF0003991E700549AE0000563C1000056AF00FF00FF00FF00FF008282
              8200828282008E8E8E00939393008C8C8C007777770068686800B8B8B800C4C4
              C400D2D2D200C4C4C400C8C8C800AAAAAA009F9F9F00FF00FF00FF00FF00D47D
              2800E18F3A00E18F3A00FFFFFF00FFFFFF00E4B78A004F6B85002DA3FC00FFFF
              FF00EBF5FF00FFFFFF00FFFFFF0055A2EB00005EC500FF00FF00FF00FF00A4A4
              A400B1B1B100B1B1B100FFFFFF00FFFFFF00CBCBCB00A6A6A600CDCDCD00FFFF
              FF00F9F9F900FFFFFF00FFFFFF00CCCCCC00A9A9A900FF00FF00CC782C00EBA8
              6200EBA86200FFFFFF00E0954A00E0954A00A35E1A004B95CB0046B6FF0031A2
              F500FFFFFF00077FEC00077FEC002089EC000172E2000054AB00A1A1A100C1C1
              C100C1C1C100FFFFFF00B6B6B600B6B6B60088888800C2C2C200D5D5D500CBCB
              CB00FFFFFF00BDBDBD00BDBDBD00C1C1C100B6B6B6009D9D9D00D5853700FAD0
              A500FFFFFF00FFFFFF00FFFFFF00FFFFFF00CCAF940063B6E80053C0FF0054B8
              F900FFFFFF00FFFFFF007EBEF6000A81EC000C7FEF00005BBA00ABABAB00DADA
              DA00FFFFFF00FFFFFF00FFFFFF00FFFFFF00C9C9C900D3D3D300D9D9D900D5D5
              D500FFFFFF00FFFFFF00DADADA00BDBDBD00BDBDBD00A4A4A400D68F4B00FAD0
              A500FCD9B700FFFFFF00EBAA6900EBAA6900B681510093BFE00079D6FF0054BF
              FF00FFFFFF0061B5F60061B5F6002391F000188AF0000165CA00B3B3B300DADA
              DA00E0E0E000FFFFFF00C3C3C300C3C3C300ACACAC00D7D7D700E4E4E400D8D8
              D800FFFFFF00D4D4D400D4D4D400C4C4C400C2C2C200ACACAC00D68F4B00F1C7
              9E00FAD3AA00FCD9B700FFFFFF00DBE4DB00BCB8A1003C6247003E7968002F7F
              8D006EB1CE00FFFFFF00FFFFFF0069B9F8001988E7000565C600B3B3B300D4D4
              D400DBDBDB00E0E0E000FFFFFF00E9E9E900CDCDCD008E8E8E00A4A4A400AEAE
              AE00CDCDCD00FFFFFF00FFFFFF00D7D7D700C0C0C000ACACAC00FF00FF00D995
              5400F9DEC500FCD9B700B9AB860046642D000F710A0003830700007706000967
              1700195C4600619EAE0082CBFD003AA3F2001879D300FF00FF00FF00FF00B7B7
              B700E4E4E400E0E0E000C4C4C400878787007C7C7C00878787007D7D7D007979
              790085858500C2C2C200E0E0E000CCCCCC00B7B7B700FF00FF00FF00FF00D995
              5400D37A2A00C28A4E00436B3100079A200004B71C00D6F4D900BCECC10012B2
              1E001B8B1F000B5536001B72AD00116FCC00116FCC00FF00FF00FF00FF00B7B7
              B700A3A3A300B0B0B0008D8D8D009D9D9D00AAAAAA00EFEFEF00E5E5E500A9A9
              A9009696960078787800AEAEAE00B2B2B200B2B2B200FF00FF00FF00FF00FF00
              FF00FF00FF0009631200148A2E0018C14300FFFFFF00FFFFFF00FFFFFF0076D5
              830000AF110004770D0004480A00FF00FF00FF00FF00FF00FF00FF00FF00FF00
              FF00FF00FF007474740099999900B7B7B700FFFFFF00FFFFFF00FFFFFF00CDCD
              CD00A3A3A3008181810056565600FF00FF00FF00FF00FF00FF00FF00FF00FF00
              FF00FF00FF0000650E002BC1640029C05B0046C86A0060CE7700C2ECC600FFFF
              FF0005B2150008A6170004480A00FF00FF00FF00FF00FF00FF00FF00FF00FF00
              FF00FF00FF0072727200BEBEBE00BCBCBC00C3C3C300C8C8C800E6E6E600FFFF
              FF00A6A6A600A1A1A10056565600FF00FF00FF00FF00FF00FF00FF00FF00FF00
              FF00FF00FF0014851D004ACA7C0026C062004CCB7800FFFFFF00FFFFFF0036C1
              4B0005B1160009B01800044F0700FF00FF00FF00FF00FF00FF00FF00FF00FF00
              FF00FF00FF0091919100C6C6C600BDBDBD00C6C6C600FFFFFF00FFFFFF00BABA
              BA00A6A6A600A6A6A6005B5B5B00FF00FF00FF00FF00FF00FF00FF00FF00FF00
              FF00FF00FF0042B152006BCE88003DC87400FFFFFF00CFF1DD0098E0AC003EC5
              5E000FB92B000A951700044F0700FF00FF00FF00FF00FF00FF00FF00FF00FF00
              FF00FF00FF00B7B7B700CBCBCB00C4C4C400FFFFFF00EEEEEE00DADADA00BFBF
              BF00AFAFAF00989898005B5B5B00FF00FF00FF00FF00FF00FF00FF00FF00FF00
              FF00FF00FF00FF00FF0042B15200A1E7BF0079DAA000FFFFFF00FFFFFF00FFFF
              FF0018BF420009631200FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00
              FF00FF00FF00FF00FF00B7B7B700E0E0E000D4D4D400FFFFFF00FFFFFF00FFFF
              FF00B6B6B60074747400FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00
              FF00FF00FF00FF00FF0042B1520054BD66008EDCA500E0F7E900AAE7C10029B4
              55001284280009631200FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00
              FF00FF00FF00FF00FF00B7B7B700BFBFBF00D7D7D700F4F4F400E2E2E200B7B7
              B7009494940074747400FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00
              FF00FF00FF00FF00FF00FF00FF00FF00FF00159E25001E9E3300139429000871
              1000FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00
              FF00FF00FF00FF00FF00FF00FF00FF00FF00A2A2A200A6A6A6009E9E9E007D7D
              7D00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00}
            NumGlyphs = 2
          end
          object ComboBox_PRO_TI_MOEDA: TComboBox
            Left = 0
            Top = 0
            Width = 59
            Height = 21
            Style = csDropDownList
            CharCase = ecUpperCase
            ItemHeight = 13
            ItemIndex = 2
            TabOrder = 0
            Text = 'R$'
            OnChange = ComboBox_PRO_TI_MOEDAChange
            Items.Strings = (
              'US$'
              #8364
              'R$'
              #163
              #165)
          end
        end
      end
    end
  end
  inherited ActionList_LocalActions: TActionList
    Images = BDODataModule_Relatorio_OBR.ImageList_Local
    object Action_DefinirCotacoes: TAction
      Hint = 
        'Definir cota'#231#245'es|Clique para definar os valores de cota'#231#227'o para ' +
        'cada moeda'
      ImageIndex = 16
      OnExecute = Action_DefinirCotacoesExecute
    end
  end
end
