inherited BDOForm_InformacoesDaProposta: TBDOForm_InformacoesDaProposta
  Caption = 'Informa'#231#245'es da proposta'
  ClientHeight = 568
  ClientWidth = 694
  OnShow = FormShow
  ExplicitWidth = 700
  ExplicitHeight = 600
  PixelsPerInch = 96
  TextHeight = 13
  inherited Panel_Header: TPanel
    Width = 694
    ExplicitWidth = 694
    inherited Shape_BackgroundHeader: TShape
      Width = 694
      ExplicitWidth = 598
    end
    inherited Label_DialogDescription: TLabel
      Width = 648
      Caption = 
        'Nesta tela '#233' poss'#237'vel visualizar algumas informa'#231#245'es sobre a pro' +
        'posta selecionada, seus itens e equipamentos. Toda esta informa'#231 +
        #227'o '#233' din'#226'mica e muda mediante altera'#231#245'es nos dados desta propost' +
        'a.'
      ExplicitWidth = 552
    end
    inherited Shape_HeaderLine: TShape
      Width = 686
      ExplicitWidth = 590
    end
    inherited Bevel_Header: TBevel
      Width = 694
      ExplicitWidth = 598
    end
  end
  inherited Panel_Footer: TPanel
    Top = 530
    Width = 694
    ExplicitTop = 530
    ExplicitWidth = 694
    inherited Shape_FooterBackground: TShape
      Width = 694
      ExplicitTop = 544
      ExplicitWidth = 598
    end
    inherited Shape_FooterLine: TShape
      Width = 686
      ExplicitTop = 4
      ExplicitWidth = 773
    end
    inherited Shape_Organizer: TShape
      Width = 686
      ExplicitTop = 9
      ExplicitWidth = 773
    end
    inherited Bevel_Footer: TBevel
      Width = 694
      ExplicitTop = 544
      ExplicitWidth = 598
    end
  end
  object PageControl_InformacoesDaProposta: TPageControl [2]
    AlignWithMargins = True
    Left = 6
    Top = 55
    Width = 682
    Height = 469
    Margins.Left = 6
    Margins.Top = 6
    Margins.Right = 6
    Margins.Bottom = 6
    ActivePage = TabSheet_ItensEEquipamentos
    Align = alClient
    TabOrder = 2
    object TabSheet_ItensEEquipamentos: TTabSheet
      Caption = 'Itens da proposta e seus equipamentos'
      object CFDBGrid_ITE: TCFDBGrid
        Left = 0
        Top = 0
        Width = 674
        Height = 217
        Margins.Left = 6
        Margins.Top = 6
        Margins.Right = 6
        Margins.Bottom = 0
        Align = alClient
        DataSource = BDODataModule_InformacoesDaProposta.DataSource_ITE
        Options = [dgEditing, dgTitles, dgColLines, dgRowLines, dgTabs, dgConfirmDelete, dgCancelOnExit]
        OptionsEx = [dgAllowTitleClick, dgAutomaticColumSizes]
        ReadOnly = True
        TabOrder = 0
        TitleFont.Charset = DEFAULT_CHARSET
        TitleFont.Color = clWindowText
        TitleFont.Height = -11
        TitleFont.Name = 'Tahoma'
        TitleFont.Style = []
        RowColors = <
          item
            BackgroundColor = clBtnFace
            ForegroundColor = clBtnText
          end>
        VariableWidthColumns = '<VA_DESCRICAO>'
        Columns = <
          item
            Expanded = False
            FieldName = 'VA_DESCRICAO'
            Title.Caption = 'Descri'#231#227'o'
            Width = 444
            Visible = True
          end
          item
            Expanded = False
            FieldName = 'CAPACIDADE'
            Title.Alignment = taCenter
            Title.Caption = 'Capacidade'
            Width = 75
            Visible = True
          end
          item
            Alignment = taCenter
            Expanded = False
            FieldName = 'EN_VOLTAGEM'
            Title.Alignment = taCenter
            Title.Caption = 'Voltagem'
            Width = 60
            Visible = True
          end
          item
            Expanded = False
            FieldName = 'SM_QUANTIDADE'
            Title.Alignment = taCenter
            Title.Caption = 'Quantidade'
            Width = 70
            Visible = True
          end>
      end
      object CFDBGrid_EDI: TCFDBGrid
        AlignWithMargins = True
        Left = 0
        Top = 223
        Width = 674
        Height = 218
        Margins.Left = 0
        Margins.Top = 6
        Margins.Right = 0
        Margins.Bottom = 0
        Align = alBottom
        DataSource = BDODataModule_InformacoesDaProposta.DataSource_EDI
        Options = [dgEditing, dgTitles, dgColLines, dgRowLines, dgTabs, dgConfirmDelete, dgCancelOnExit]
        OptionsEx = [dgAllowTitleClick, dgAutomaticColumSizes]
        ReadOnly = True
        TabOrder = 1
        TitleFont.Charset = DEFAULT_CHARSET
        TitleFont.Color = clWindowText
        TitleFont.Height = -11
        TitleFont.Name = 'Tahoma'
        TitleFont.Style = []
        RowColors = <
          item
            BackgroundColor = clBtnFace
            ForegroundColor = clBtnText
          end>
        VariableWidthColumns = '<MODELO>'
        Columns = <
          item
            Expanded = False
            FieldName = 'MODELO'
            Title.Alignment = taCenter
            Title.Caption = 'Equipamentos do item selecionado'
            Width = 652
            Visible = True
          end>
      end
    end
    object TabSheet_DadosDaProposta: TTabSheet
      Caption = 'Dados gerais da proposta e de sua obra'
      ImageIndex = 1
      object GroupBox_Obra: TGroupBox
        AlignWithMargins = True
        Left = 6
        Top = 3
        Width = 662
        Height = 190
        Margins.Left = 6
        Margins.Right = 6
        Align = alTop
        Caption = ' Dados da obra associada '
        TabOrder = 0
        DesignSize = (
          662
          190)
        object Label_Obra: TLabel
          Left = 8
          Top = 17
          Width = 646
          Height = 13
          Anchors = [akLeft, akTop, akRight]
          AutoSize = False
          Caption = 
            'Obra relacionada ...............................................' +
            '................................................................' +
            '............................'
          Color = clActiveCaption
          ParentColor = False
          Transparent = True
        end
        object Label_Validade: TLabel
          Left = 8
          Top = 55
          Width = 646
          Height = 13
          Anchors = [akLeft, akTop, akRight]
          AutoSize = False
          Caption = 
            'Validade .......................................................' +
            '................................................................' +
            '.......................................................'
          Color = clBtnShadow
          ParentColor = False
          Transparent = True
        end
        object Label_DataDeEntrada: TLabel
          Left = 8
          Top = 36
          Width = 646
          Height = 13
          Anchors = [akLeft, akTop, akRight]
          AutoSize = False
          Caption = 
            'Data de entrada ................................................' +
            '................................................................' +
            '...................................................'
          Color = clBackground
          ParentColor = False
          Transparent = True
        end
        object DBText_ObraValor: TDBText
          Left = 550
          Top = 17
          Width = 104
          Height = 13
          Alignment = taRightJustify
          Anchors = [akTop, akRight]
          AutoSize = True
          DataField = 'VA_NOMEDAOBRA'
          DataSource = BDODataModule_InformacoesDaProposta.DataSource_PRO
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clRed
          Font.Height = -11
          Font.Name = 'Tahoma'
          Font.Style = [fsBold]
          ParentFont = False
          Transparent = True
        end
        object DBText_ValidadeValor: TDBText
          Left = 529
          Top = 55
          Width = 125
          Height = 13
          Alignment = taRightJustify
          Anchors = [akTop, akRight]
          AutoSize = True
          DataField = 'VALIDADE'
          DataSource = BDODataModule_InformacoesDaProposta.DataSource_PRO
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clRed
          Font.Height = -11
          Font.Name = 'Tahoma'
          Font.Style = [fsBold]
          ParentFont = False
          Transparent = True
        end
        object DBText_DataDeEntradaValor: TDBText
          Left = 491
          Top = 36
          Width = 163
          Height = 13
          Alignment = taRightJustify
          Anchors = [akTop, akRight]
          AutoSize = True
          DataField = 'DATADAENTRADA'
          DataSource = BDODataModule_InformacoesDaProposta.DataSource_PRO
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clRed
          Font.Height = -11
          Font.Name = 'Tahoma'
          Font.Style = [fsBold]
          ParentFont = False
          Transparent = True
        end
        object Label_Localidade: TLabel
          Left = 8
          Top = 93
          Width = 646
          Height = 13
          Anchors = [akLeft, akTop, akRight]
          AutoSize = False
          Caption = 
            'Localidade .....................................................' +
            '................................................................' +
            '....................................'
          Color = clActiveCaption
          ParentColor = False
          Transparent = True
        end
        object DBText_LocalidadeValor: TDBText
          Left = 517
          Top = 93
          Width = 137
          Height = 13
          Alignment = taRightJustify
          Anchors = [akTop, akRight]
          AutoSize = True
          DataField = 'LOCALIDADE'
          DataSource = BDODataModule_InformacoesDaProposta.DataSource_PRO
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clRed
          Font.Height = -11
          Font.Name = 'Tahoma'
          Font.Style = [fsBold]
          ParentFont = False
          Transparent = True
        end
        object Label_Situacao: TLabel
          Left = 8
          Top = 112
          Width = 646
          Height = 13
          Anchors = [akLeft, akTop, akRight]
          AutoSize = False
          Caption = 
            'Situa'#231#227'o .......................................................' +
            '................................................................' +
            '..................................'
          Color = clActiveCaption
          ParentColor = False
          Transparent = True
        end
        object DBText_SituacaoValor: TDBText
          Left = 528
          Top = 112
          Width = 126
          Height = 13
          Alignment = taRightJustify
          Anchors = [akTop, akRight]
          AutoSize = True
          DataField = 'SITUACAO'
          DataSource = BDODataModule_InformacoesDaProposta.DataSource_PRO
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clRed
          Font.Height = -11
          Font.Name = 'Tahoma'
          Font.Style = [fsBold]
          ParentFont = False
          Transparent = True
        end
        object Label_PrevisaoDeConclusao: TLabel
          Left = 8
          Top = 131
          Width = 646
          Height = 13
          Anchors = [akLeft, akTop, akRight]
          AutoSize = False
          Caption = 
            'Previs'#227'o de conclus'#227'o ..........................................' +
            '................................................................' +
            '...............................................'
          Color = clActiveCaption
          ParentColor = False
          Transparent = True
        end
        object DBText_PrevisaoDeConclusaoValor: TDBText
          Left = 456
          Top = 131
          Width = 198
          Height = 13
          Alignment = taRightJustify
          Anchors = [akTop, akRight]
          AutoSize = True
          DataField = 'DATAPROVAVELDEENTREGA'
          DataSource = BDODataModule_InformacoesDaProposta.DataSource_PRO
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clRed
          Font.Height = -11
          Font.Name = 'Tahoma'
          Font.Style = [fsBold]
          ParentFont = False
          Transparent = True
        end
        object Label_Construtora: TLabel
          Left = 8
          Top = 150
          Width = 646
          Height = 13
          Anchors = [akLeft, akTop, akRight]
          AutoSize = False
          Caption = 
            'Construtora ....................................................' +
            '................................................................' +
            '.....................................'
          Color = clActiveCaption
          ParentColor = False
          Transparent = True
        end
        object DBText_ConstrutoraValor: TDBText
          Left = 509
          Top = 150
          Width = 145
          Height = 13
          Alignment = taRightJustify
          Anchors = [akTop, akRight]
          AutoSize = True
          DataField = 'VA_CONSTRUTORA'
          DataSource = BDODataModule_InformacoesDaProposta.DataSource_PRO
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clRed
          Font.Height = -11
          Font.Name = 'Tahoma'
          Font.Style = [fsBold]
          ParentFont = False
          Transparent = True
        end
        object Label_Projetista: TLabel
          Left = 8
          Top = 169
          Width = 646
          Height = 13
          Anchors = [akLeft, akTop, akRight]
          AutoSize = False
          Caption = 
            'Projetista .....................................................' +
            '................................................................' +
            '....................................'
          Color = clActiveCaption
          ParentColor = False
          Transparent = True
        end
        object DBText_ProjetistaValor: TDBText
          Left = 521
          Top = 169
          Width = 133
          Height = 13
          Alignment = taRightJustify
          Anchors = [akTop, akRight]
          AutoSize = True
          DataField = 'PROJETISTA'
          DataSource = BDODataModule_InformacoesDaProposta.DataSource_PRO
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clRed
          Font.Height = -11
          Font.Name = 'Tahoma'
          Font.Style = [fsBold]
          ParentFont = False
          Transparent = True
        end
        object Label_Regiao: TLabel
          Left = 8
          Top = 74
          Width = 646
          Height = 13
          Anchors = [akLeft, akTop, akRight]
          AutoSize = False
          Caption = 
            'Regi'#227'o .........................................................' +
            '................................................................' +
            '................................'
          Color = clActiveCaption
          ParentColor = False
          Transparent = True
        end
        object DBText_RegiaoValor: TDBText
          Left = 538
          Top = 74
          Width = 116
          Height = 13
          Alignment = taRightJustify
          Anchors = [akTop, akRight]
          AutoSize = True
          DataField = 'VA_REGIAO'
          DataSource = BDODataModule_InformacoesDaProposta.DataSource_PRO
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clRed
          Font.Height = -11
          Font.Name = 'Tahoma'
          Font.Style = [fsBold]
          ParentFont = False
          Transparent = True
        end
      end
      object GroupBox_Proposta: TGroupBox
        AlignWithMargins = True
        Left = 6
        Top = 196
        Width = 662
        Height = 77
        Margins.Left = 6
        Margins.Top = 0
        Margins.Right = 6
        Margins.Bottom = 6
        Align = alTop
        Caption = ' Dados da proposta selecionada '
        TabOrder = 1
        DesignSize = (
          662
          77)
        object Label_Instalador: TLabel
          Left = 8
          Top = 17
          Width = 646
          Height = 13
          Anchors = [akLeft, akTop, akRight]
          AutoSize = False
          Caption = 
            'Instalador .....................................................' +
            '................................................................' +
            '...............................'
          Transparent = True
        end
        object DBText_InstaladorValor: TDBText
          Left = 518
          Top = 17
          Width = 136
          Height = 13
          Alignment = taRightJustify
          Anchors = [akLeft, akTop, akRight]
          AutoSize = True
          DataField = 'VA_NOME'
          DataSource = BDODataModule_InformacoesDaProposta.DataSource_PRO
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clRed
          Font.Height = -11
          Font.Name = 'Tahoma'
          Font.Style = [fsBold]
          ParentFont = False
          Transparent = True
        end
        object Label_MoedaOriginal: TLabel
          Left = 8
          Top = 36
          Width = 646
          Height = 13
          Anchors = [akLeft, akTop, akRight]
          AutoSize = False
          Caption = 
            'Moeda original da proposta .....................................' +
            '................................................................' +
            '....................................................'
          Transparent = True
        end
        object DBText_MoedaOriginalValor: TDBText
          Left = 496
          Top = 36
          Width = 158
          Height = 13
          Alignment = taRightJustify
          Anchors = [akTop, akRight]
          AutoSize = True
          DataField = 'MOEDAORIGINAL'
          DataSource = BDODataModule_InformacoesDaProposta.DataSource_PRO
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clRed
          Font.Height = -11
          Font.Name = 'Tahoma'
          Font.Style = [fsBold]
          ParentFont = False
          Transparent = True
        end
        object Label_Contato: TLabel
          Left = 8
          Top = 55
          Width = 646
          Height = 13
          Anchors = [akLeft, akTop, akRight]
          AutoSize = False
          Caption = 
            'Contato ........................................................' +
            '................................................................' +
            '..........................'
          Transparent = True
        end
        object DBText_ContatoValor: TDBText
          Left = 532
          Top = 55
          Width = 122
          Height = 13
          Alignment = taRightJustify
          Anchors = [akLeft, akTop, akRight]
          AutoSize = True
          DataField = 'VA_CONTATO'
          DataSource = BDODataModule_InformacoesDaProposta.DataSource_PRO
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clRed
          Font.Height = -11
          Font.Name = 'Tahoma'
          Font.Style = [fsBold]
          ParentFont = False
          Transparent = True
        end
      end
    end
    object TabSheet_InformacoesDosRegistros: TTabSheet
      Caption = 'Informa'#231#245'es dos registros (obras e propostas)'
      ImageIndex = 2
      DesignSize = (
        674
        441)
      object GroupBox_InformacoesDoRegistro: TGroupBox
        AlignWithMargins = True
        Left = 6
        Top = 3
        Width = 662
        Height = 152
        Margins.Left = 6
        Margins.Right = 6
        Align = alTop
        Caption = ' Informa'#231#245'es sobre o registro da proposta '
        TabOrder = 0
        DesignSize = (
          662
          152)
        object Label_CreationDateAndTime: TLabel
          Left = 8
          Top = 17
          Width = 646
          Height = 13
          Anchors = [akLeft, akTop, akRight]
          AutoSize = False
          Caption = 
            'Data e hora da cria'#231#227'o do registro .............................' +
            '................................................................' +
            '.........'
          Transparent = True
        end
        object Label_CreationDateAndTimeValor: TLabel
          Left = 502
          Top = 17
          Width = 153
          Height = 13
          Alignment = taRightJustify
          Anchors = [akTop]
          Caption = 'dd/mm/yyyy "'#224's" hh:nn:ss'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clRed
          Font.Height = -11
          Font.Name = 'Tahoma'
          Font.Style = [fsBold]
          ParentFont = False
          Transparent = True
        end
        object Label_CreatorFullName: TLabel
          Left = 8
          Top = 36
          Width = 646
          Height = 13
          Anchors = [akLeft, akTop, akRight]
          AutoSize = False
          Caption = 
            'Usu'#225'rio criador do registro ....................................' +
            '................................................................' +
            '................................'
          Transparent = True
        end
        object Label_CreatorFullNameValor: TLabel
          Left = 606
          Top = 36
          Width = 48
          Height = 13
          Alignment = taRightJustify
          Anchors = [akTop]
          Caption = '????????'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clRed
          Font.Height = -11
          Font.Name = 'Tahoma'
          Font.Style = [fsBold]
          ParentFont = False
          Transparent = True
        end
        object Label_LastModificationDateAndTime: TLabel
          Left = 8
          Top = 74
          Width = 646
          Height = 13
          Anchors = [akLeft, akTop, akRight]
          AutoSize = False
          Caption = 
            'Data e hora da '#250'ltima modifica'#231#227'o do registro ..................' +
            '................................................................' +
            '......'
          Transparent = True
        end
        object Label_LastModificationDateAndTimeValor: TLabel
          Left = 502
          Top = 74
          Width = 153
          Height = 13
          Alignment = taRightJustify
          Anchors = [akTop]
          Caption = 'dd/mm/yyyy "'#224's" hh:nn:ss'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clRed
          Font.Height = -11
          Font.Name = 'Tahoma'
          Font.Style = [fsBold]
          ParentFont = False
          Transparent = True
        end
        object Label_LastModifierFullName: TLabel
          Left = 8
          Top = 93
          Width = 646
          Height = 13
          Anchors = [akLeft, akTop, akRight]
          AutoSize = False
          Caption = 
            'Usu'#225'rio modificador do registro ................................' +
            '................................................................' +
            '..............................'
          Transparent = True
        end
        object Label_LastModifierFullNameValor: TLabel
          Left = 606
          Top = 93
          Width = 48
          Height = 13
          Alignment = taRightJustify
          Anchors = [akTop]
          Caption = '????????'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clRed
          Font.Height = -11
          Font.Name = 'Tahoma'
          Font.Style = [fsBold]
          ParentFont = False
          Transparent = True
        end
        object Label_CreatorId: TLabel
          Left = 8
          Top = 55
          Width = 646
          Height = 13
          Anchors = [akLeft, akTop, akRight]
          AutoSize = False
          Caption = 
            'Identifica'#231#227'o do usu'#225'rio criador do registro ...................' +
            '................................................................' +
            '..............................'
          Transparent = True
        end
        object Label_CreatorIdValor: TLabel
          Left = 606
          Top = 55
          Width = 48
          Height = 13
          Alignment = taRightJustify
          Anchors = [akTop]
          Caption = '????????'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clRed
          Font.Height = -11
          Font.Name = 'Tahoma'
          Font.Style = [fsBold]
          ParentFont = False
          Transparent = True
        end
        object Label_LastModifierId: TLabel
          Left = 8
          Top = 112
          Width = 646
          Height = 13
          Anchors = [akLeft, akTop, akRight]
          AutoSize = False
          Caption = 
            'Identifica'#231#227'o do usu'#225'rio modificador do registro ...............' +
            '................................................................' +
            '............................'
          Transparent = True
        end
        object Label_LastModifierIdValor: TLabel
          Left = 606
          Top = 112
          Width = 48
          Height = 13
          Alignment = taRightJustify
          Anchors = [akTop]
          Caption = '????????'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clRed
          Font.Height = -11
          Font.Name = 'Tahoma'
          Font.Style = [fsBold]
          ParentFont = False
          Transparent = True
        end
        object Label_RecordStatus: TLabel
          Left = 8
          Top = 131
          Width = 646
          Height = 13
          Anchors = [akLeft, akTop, akRight]
          AutoSize = False
          Caption = 
            'Situa'#231#227'o do registro ...........................................' +
            '................................................................' +
            '...............................'
          Transparent = True
        end
        object Label_RecordStatusValor: TLabel
          Left = 606
          Top = 131
          Width = 48
          Height = 13
          Alignment = taRightJustify
          Anchors = [akTop]
          Caption = '????????'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clRed
          Font.Height = -11
          Font.Name = 'Tahoma'
          Font.Style = [fsBold]
          ParentFont = False
          Transparent = True
        end
      end
      object Panel1: TPanel
        Left = 555
        Top = 2
        Width = 108
        Height = 13
        Anchors = [akTop, akRight]
        BevelOuter = bvNone
        TabOrder = 2
        DesignSize = (
          108
          13)
        object Shape1: TShape
          Left = 0
          Top = 0
          Width = 108
          Height = 13
          Align = alClient
          Brush.Color = clActiveCaption
          Pen.Color = clCaptionText
          ExplicitLeft = 24
          ExplicitTop = 6
          ExplicitWidth = 65
          ExplicitHeight = 65
        end
        object DBText_PRO_IN_PROPOSTAS_ID: TDBText
          Left = 2
          Top = -1
          Width = 104
          Height = 13
          Hint = 
            'Identifica'#231#227'o '#250'nica da proposta|Este '#233' o n'#250'mero '#250'nico desta prop' +
            'osta no sistema'
          Alignment = taCenter
          Anchors = [akLeft, akTop, akRight]
          DataField = 'IN_PROPOSTAS_ID'
          DataSource = BDODataModule_InformacoesDaProposta.DataSource_PRO
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clCaptionText
          Font.Height = -12
          Font.Name = 'Tahoma'
          Font.Style = [fsBold]
          ParentFont = False
          Transparent = True
        end
      end
      object GroupBox_InformacoesDoRegistro2: TGroupBox
        AlignWithMargins = True
        Left = 6
        Top = 158
        Width = 662
        Height = 152
        Margins.Left = 6
        Margins.Top = 0
        Margins.Right = 6
        Align = alTop
        Caption = ' Informa'#231#245'es sobre o registro da obra '
        TabOrder = 1
        DesignSize = (
          662
          152)
        object Label_CreationDateAndTime2: TLabel
          Left = 8
          Top = 17
          Width = 646
          Height = 13
          Anchors = [akLeft, akTop, akRight]
          AutoSize = False
          Caption = 
            'Data e hora da cria'#231#227'o do registro .............................' +
            '................................................................' +
            '.........'
          Transparent = True
        end
        object Label_CreationDateAndTime2Valor: TLabel
          Left = 502
          Top = 17
          Width = 153
          Height = 13
          Alignment = taRightJustify
          Anchors = [akTop]
          Caption = 'dd/mm/yyyy "'#224's" hh:nn:ss'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clRed
          Font.Height = -11
          Font.Name = 'Tahoma'
          Font.Style = [fsBold]
          ParentFont = False
          Transparent = True
        end
        object Label_CreatorFullName2: TLabel
          Left = 8
          Top = 36
          Width = 646
          Height = 13
          Anchors = [akLeft, akTop, akRight]
          AutoSize = False
          Caption = 
            'Usu'#225'rio criador do registro ....................................' +
            '................................................................' +
            '................................'
          Transparent = True
        end
        object Label_CreatorFullName2Valor: TLabel
          Left = 606
          Top = 36
          Width = 48
          Height = 13
          Alignment = taRightJustify
          Anchors = [akTop]
          Caption = '????????'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clRed
          Font.Height = -11
          Font.Name = 'Tahoma'
          Font.Style = [fsBold]
          ParentFont = False
          Transparent = True
        end
        object Label_LastModificationDateAndTime2: TLabel
          Left = 8
          Top = 74
          Width = 646
          Height = 13
          Anchors = [akLeft, akTop, akRight]
          AutoSize = False
          Caption = 
            'Data e hora da '#250'ltima modifica'#231#227'o do registro ..................' +
            '................................................................' +
            '......'
          Transparent = True
        end
        object Label_LastModificationDateAndTime2Valor: TLabel
          Left = 502
          Top = 74
          Width = 153
          Height = 13
          Alignment = taRightJustify
          Anchors = [akTop]
          Caption = 'dd/mm/yyyy "'#224's" hh:nn:ss'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clRed
          Font.Height = -11
          Font.Name = 'Tahoma'
          Font.Style = [fsBold]
          ParentFont = False
          Transparent = True
        end
        object Label_LastModifierFullName2: TLabel
          Left = 8
          Top = 93
          Width = 646
          Height = 13
          Anchors = [akLeft, akTop, akRight]
          AutoSize = False
          Caption = 
            'Usu'#225'rio modificador do registro ................................' +
            '................................................................' +
            '..............................'
          Transparent = True
        end
        object Label_LastModifierFullName2Valor: TLabel
          Left = 606
          Top = 93
          Width = 48
          Height = 13
          Alignment = taRightJustify
          Anchors = [akTop]
          Caption = '????????'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clRed
          Font.Height = -11
          Font.Name = 'Tahoma'
          Font.Style = [fsBold]
          ParentFont = False
          Transparent = True
        end
        object Label_CreatorId2: TLabel
          Left = 8
          Top = 55
          Width = 646
          Height = 13
          Anchors = [akLeft, akTop, akRight]
          AutoSize = False
          Caption = 
            'Identifica'#231#227'o do usu'#225'rio criador do registro ...................' +
            '................................................................' +
            '..............................'
          Transparent = True
        end
        object Label_CreatorId2Valor: TLabel
          Left = 606
          Top = 55
          Width = 48
          Height = 13
          Alignment = taRightJustify
          Anchors = [akTop]
          Caption = '????????'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clRed
          Font.Height = -11
          Font.Name = 'Tahoma'
          Font.Style = [fsBold]
          ParentFont = False
          Transparent = True
        end
        object Label_LastModifierId2: TLabel
          Left = 8
          Top = 112
          Width = 646
          Height = 13
          Anchors = [akLeft, akTop, akRight]
          AutoSize = False
          Caption = 
            'Identifica'#231#227'o do usu'#225'rio modificador do registro ...............' +
            '................................................................' +
            '............................'
          Transparent = True
        end
        object Label_LastModifierId2Valor: TLabel
          Left = 606
          Top = 112
          Width = 48
          Height = 13
          Alignment = taRightJustify
          Anchors = [akTop]
          Caption = '????????'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clRed
          Font.Height = -11
          Font.Name = 'Tahoma'
          Font.Style = [fsBold]
          ParentFont = False
          Transparent = True
        end
        object Label_RecordStatus2: TLabel
          Left = 8
          Top = 131
          Width = 646
          Height = 13
          Anchors = [akLeft, akTop, akRight]
          AutoSize = False
          Caption = 
            'Situa'#231#227'o do registro ...........................................' +
            '................................................................' +
            '...............................'
          Transparent = True
        end
        object Label_RecordStatus2Valor: TLabel
          Left = 606
          Top = 131
          Width = 48
          Height = 13
          Alignment = taRightJustify
          Anchors = [akTop]
          Caption = '????????'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clRed
          Font.Height = -11
          Font.Name = 'Tahoma'
          Font.Style = [fsBold]
          ParentFont = False
          Transparent = True
        end
      end
      object Panel_OBR_IN_OBRAS_ID: TPanel
        Left = 555
        Top = 157
        Width = 108
        Height = 13
        Anchors = [akTop, akRight]
        BevelOuter = bvNone
        TabOrder = 3
        DesignSize = (
          108
          13)
        object Shape_OBR_IN_OBRAS_ID: TShape
          Left = 0
          Top = 0
          Width = 108
          Height = 13
          Align = alClient
          Brush.Color = clActiveCaption
          Pen.Color = clCaptionText
          ExplicitLeft = 24
          ExplicitTop = 6
          ExplicitWidth = 65
          ExplicitHeight = 65
        end
        object DBText_OBR_IN_OBRAS_ID: TDBText
          Left = 2
          Top = -1
          Width = 104
          Height = 13
          Hint = 
            'Identifica'#231#227'o '#250'nica da obra|Este '#233' o n'#250'mero '#250'nico desta obra no ' +
            'sistema'
          Alignment = taCenter
          Anchors = [akLeft, akTop, akRight]
          DataField = 'IN_OBRAS_ID'
          DataSource = BDODataModule_InformacoesDaProposta.DataSource_PRO
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clCaptionText
          Font.Height = -12
          Font.Name = 'Tahoma'
          Font.Style = [fsBold]
          ParentFont = False
          Transparent = True
        end
      end
    end
  end
end
