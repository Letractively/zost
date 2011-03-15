inherited BDOForm_Relatorio_EQP: TBDOForm_Relatorio_EQP
  Caption = 'Gerador de Relat'#243'rio de equipamentos'
  PixelsPerInch = 96
  TextHeight = 13
  inherited Panel_Header: TPanel
    inherited Label_DialogDescription: TLabel
      Caption = 
        'Este relat'#243'rio exibe os equipamentos encontrados em um determina' +
        'do per'#237'odo segundo crit'#233'rios de listagem. Configure as op'#231#245'es se' +
        'gundo suas necessidades. Clique o bot'#227'o "Configurar" para defini' +
        'r op'#231#245'es espec'#237'ficas da impress'#227'o, como margens e impress'#227'o de c' +
        'ores. Para salvar esta proposta como um conjunto de arquivos, cl' +
        'ique o bot'#227'o "Salvar...". Para imprimir imediatamente, clique o ' +
        'bot'#227'o "Imprimir agora!" Dentro do relat'#243'rio, links, quando dispo' +
        'n'#237'veis, podem ser clicados para exibir mais informa'#231#245'es sobre um' +
        ' item.'
    end
  end
  inherited GroupBox_VisualizarImpressao: TGroupBox
    inherited PageControl_OpcoesEFiltragem: TPageControl
      inherited TabSheet_OpcoesDeListagem: TTabSheet
        object RadioButton_LisagemPorSituacao: TRadioButton
          Left = 1
          Top = 1
          Width = 121
          Height = 13
          Caption = 'Listagem por situa'#231#227'o'
          Checked = True
          TabOrder = 0
          TabStop = True
          OnClick = DoRecarregar
        end
        object RadioButton_PorPrevisaoDeEntrega: TRadioButton
          Left = 1
          Top = 43
          Width = 133
          Height = 13
          Caption = 'Por previs'#227'o de entrega'
          TabOrder = 1
          OnClick = DoRecarregar
        end
      end
      inherited TabSheet_OpcoesDeFiltragem: TTabSheet
        object Label1: TLabel
          Left = 1
          Top = 1
          Width = 46
          Height = 43
          AutoSize = False
          Caption = 'Situa'#231#245'es a exibir'
          Layout = tlCenter
          WordWrap = True
        end
        object Shape2: TShape
          Left = 1
          Top = 46
          Width = 391
          Height = 10
          Brush.Color = clActiveCaption
          Brush.Style = bsBDiagonal
        end
        object Label_VoltagensAExibir: TLabel
          Left = 262
          Top = 1
          Width = 46
          Height = 43
          AutoSize = False
          Caption = 'Voltagens a exibir'
          Layout = tlCenter
          WordWrap = True
        end
        object CheckListBox_Opcoes: TCheckListBox
          Left = 53
          Top = 1
          Width = 203
          Height = 43
          Hint = 'Clique com o bot'#227'o direito do mouse para ver op'#231#245'es de checagem'
          OnClickCheck = DoRecarregar
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'Tahoma'
          Font.Style = []
          ItemHeight = 13
          Items.Strings = (
            'Item1'
            'Item2'
            'Item3')
          ParentFont = False
          ParentShowHint = False
          PopupMenu = PopupActionBar_OpcoesDeChecagem
          ShowHint = True
          TabOrder = 0
        end
        object CheckBox_DA_DATADEENTRADA1: TCheckBox
          Left = 432
          Top = 5
          Width = 89
          Height = 13
          Alignment = taLeftJustify
          Anchors = [akTop, akRight]
          Caption = 'No per'#237'odo de'
          TabOrder = 1
          OnClick = CheckBox_DA_DATADEENTRADA1Click
        end
        object CheckBox_DA_DATADEENTRADA2: TCheckBox
          Left = 483
          Top = 39
          Width = 38
          Height = 13
          Alignment = taLeftJustify
          Anchors = [akTop, akRight]
          Caption = 'at'#233
          TabOrder = 2
          OnClick = CheckBox_DA_DATADEENTRADA1Click
        end
        object DateTimePicker_DA_DATADEENTRADA2: TDateTimePicker
          Left = 527
          Top = 35
          Width = 91
          Height = 21
          Anchors = [akTop, akRight]
          BiDiMode = bdLeftToRight
          Date = 38260.000000000000000000
          Format = 'dd/MM/yyyy'
          Time = 38260.000000000000000000
          Checked = False
          Enabled = False
          ParentBiDiMode = False
          TabOrder = 3
          OnChange = DoRecarregar
        end
        object DateTimePicker_DA_DATADEENTRADA1: TDateTimePicker
          Left = 527
          Top = 1
          Width = 91
          Height = 21
          Anchors = [akTop, akRight]
          Date = 38260.000000000000000000
          Format = 'dd/MM/yyyy'
          Time = 38260.000000000000000000
          Checked = False
          Enabled = False
          TabOrder = 4
          OnChange = DoRecarregar
        end
        object ComboBox_Ano: TComboBox
          Left = 527
          Top = 1
          Width = 91
          Height = 21
          Style = csDropDownList
          Enabled = False
          ItemHeight = 13
          TabOrder = 5
          OnChange = DoRecarregar
        end
        object ComboBox_Mes: TComboBox
          Left = 527
          Top = 35
          Width = 91
          Height = 21
          Style = csDropDownList
          Enabled = False
          ItemHeight = 13
          ItemIndex = 0
          TabOrder = 6
          Text = 'Janeiro'
          OnChange = DoRecarregar
          Items.Strings = (
            'Janeiro'
            'Fevereiro'
            'Mar'#231'o'
            'Abril'
            'Maio'
            'Junho'
            'Julho'
            'Agosto'
            'Setembro'
            'Outubro'
            'Novembro'
            'Dezembro')
        end
        object CheckListBox_Voltagens: TCheckListBox
          Left = 314
          Top = 1
          Width = 78
          Height = 43
          Hint = 'Clique com o bot'#227'o direito do mouse para ver op'#231#245'es de checagem'
          OnClickCheck = DoRecarregar
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'Tahoma'
          Font.Style = []
          ItemHeight = 13
          Items.Strings = (
            '440 / 3O')
          ParentFont = False
          ParentShowHint = False
          PopupMenu = PopupActionBar_OpcoesDeChecagem
          ShowHint = True
          TabOrder = 7
        end
      end
      inherited TabSheet_OpcoesDeExibicao: TTabSheet
        object Bevel2: TBevel
          Left = 204
          Top = 1
          Width = 2
          Height = 55
          Shape = bsLeftLine
        end
        object CheckBox_ExibirQuantidadesParciais: TCheckBox
          Left = 1
          Top = 1
          Width = 197
          Height = 13
          Caption = 'Exibir quantidades parciais'
          Checked = True
          State = cbChecked
          TabOrder = 0
          OnClick = DoRecarregar
        end
        object CheckBox_ExibirQuantidadesTotaisParciais: TCheckBox
          Left = 1
          Top = 22
          Width = 197
          Height = 13
          Caption = 'Exibir quantidades totais parciais'
          Checked = True
          State = cbChecked
          TabOrder = 1
          OnClick = DoRecarregar
        end
        object CheckBox_ExibirQuantidadesTotaisPorSituacao: TCheckBox
          Left = 1
          Top = 43
          Width = 197
          Height = 13
          Caption = 'Exibir quantidades totais por situa'#231#227'o'
          Checked = True
          State = cbChecked
          TabOrder = 2
          OnClick = DoRecarregar
        end
        object CheckBox_ExibirTotalGeral: TCheckBox
          Left = 212
          Top = 1
          Width = 102
          Height = 13
          Caption = 'Exibir total geral'
          Checked = True
          State = cbChecked
          TabOrder = 3
          OnClick = DoRecarregar
        end
        object CheckBox_ExibirPeriodo: TCheckBox
          Left = 212
          Top = 22
          Width = 102
          Height = 13
          Caption = 'Exibir per'#237'odo'
          Checked = True
          State = cbChecked
          TabOrder = 4
          OnClick = DoRecarregar
        end
      end
    end
  end
  inherited ActionList_LocalActions: TActionList
    Images = BDODataModule_Relatorio_EQP.ImageList_Local
    object Action_MarcarTodasAsOpcoes: TAction
      Caption = 'Marcar todas'
      Hint = 
        'Marcar todas as op'#231#245'es|Clique para marcar todas as op'#231#245'es desta ' +
        'lista'
      OnExecute = Action_MarcarTodasAsOpcoesExecute
    end
    object Action_InverterMarcas: TAction
      Caption = 'Inverter marcas'
      Hint = 'Inverter marcas|Clique para inverter as marca'#231#245'es desta lista'
      OnExecute = Action_InverterMarcasExecute
    end
    object Action_MarcarGPS: TAction
      Caption = 'Somente "Ganhas", "Perfidas" e "Suspensas"'
      Hint = 
        'Somente ganhas, perdidas e suspensas|Clique para marcar apenas a' +
        's situa'#231#245'es "Ganha", "Perdida" e "Suspensa"'
      OnExecute = Action_MarcarGPSExecute
    end
    object Action_MarcarG: TAction
      Caption = 'Somente "Ganhas"'
      Hint = 'Somente "Ganhas"|Clique para marcar apenas "Ganhas"'
      OnExecute = Action_MarcarGExecute
    end
    object Action_MarcarP: TAction
      Caption = 'Somente "Perdidas"'
      Hint = 'Somente "Perdidas"|Clique para marcar somente "Perdidas"'
      OnExecute = Action_MarcarPExecute
    end
    object Action_MarcarS: TAction
      Caption = 'Somente "Suspensas"'
      Hint = 'Somente "Suspensas"|Clique para marcar somente "Suspensas"'
      OnExecute = Action_MarcarSExecute
    end
  end
  object PopupActionBar_OpcoesDeChecagem: TPopupActionBar
    OnPopup = PopupActionBar_OpcoesDeChecagemPopup
    Left = 30
    Top = 2
    object MenuItem_ChecarTodas: TMenuItem
      Action = Action_MarcarTodasAsOpcoes
      RadioItem = True
    end
    object MenuItem_InverterChecagens: TMenuItem
      Action = Action_InverterMarcas
      RadioItem = True
    end
    object N1: TMenuItem
      Caption = '-'
    end
    object MenuItem_SomenteGanhasPerdidasSuspensas: TMenuItem
      Action = Action_MarcarGPS
      RadioItem = True
    end
    object MenuItem_SomenteGanhas: TMenuItem
      Action = Action_MarcarG
      RadioItem = True
    end
    object MenuItem_SomentePerdidas: TMenuItem
      Action = Action_MarcarP
      RadioItem = True
    end
    object MenuItem_SomenteSuspensas: TMenuItem
      Action = Action_MarcarS
      RadioItem = True
    end
  end
end
