inherited BDOForm_InformacoesDoEquipamento: TBDOForm_InformacoesDoEquipamento
  Caption = 'Informa'#231#245'es do equipamento'
  ClientHeight = 348
  ClientWidth = 674
  OnShow = FormShow
  ExplicitWidth = 680
  ExplicitHeight = 380
  PixelsPerInch = 96
  TextHeight = 13
  inherited Panel_Header: TPanel
    Width = 674
    ExplicitWidth = 674
    DesignSize = (
      674
      49)
    inherited Shape_BackgroundHeader: TShape
      Width = 674
      ExplicitWidth = 588
    end
    inherited Label_DialogDescription: TLabel
      Width = 628
      Caption = 
        'Nesta tela '#233' poss'#237'vel visualizar algumas informa'#231#245'es sobre o equ' +
        'ipamento selecionado, sua previs'#227'o de entrega e as propostas que' +
        ' o cont'#233'm.'
      ExplicitWidth = 542
    end
    inherited Shape_HeaderLine: TShape
      Width = 666
      ExplicitWidth = 580
    end
    inherited Bevel_Header: TBevel
      Width = 674
      ExplicitWidth = 588
    end
  end
  inherited Panel_Footer: TPanel
    Top = 310
    Width = 674
    ExplicitTop = 310
    ExplicitWidth = 674
    DesignSize = (
      674
      38)
    inherited Shape_FooterBackground: TShape
      Width = 674
      ExplicitWidth = 588
    end
    inherited Shape_FooterLine: TShape
      Width = 666
      ExplicitWidth = 580
    end
    inherited Shape_Organizer: TShape
      Width = 666
      ExplicitWidth = 580
    end
    inherited Bevel_Footer: TBevel
      Width = 674
      ExplicitWidth = 588
    end
  end
  object GroupBox_InformacoesDiretas: TGroupBox [2]
    AlignWithMargins = True
    Left = 6
    Top = 52
    Width = 662
    Height = 93
    Margins.Left = 6
    Margins.Right = 6
    Align = alTop
    Caption = ' Informa'#231#245'es gerais '
    TabOrder = 2
    DesignSize = (
      662
      93)
    object Label_Voltagem: TLabel
      Left = 8
      Top = 36
      Width = 646
      Height = 13
      Anchors = [akLeft, akTop, akRight]
      AutoSize = False
      Caption = 
        'Voltagem .......................................................' +
        '................................................................' +
        '............................................'
      Color = clBackground
      ParentColor = False
      Transparent = True
    end
    object Label_Mes: TLabel
      Left = 8
      Top = 55
      Width = 646
      Height = 13
      Anchors = [akLeft, akTop, akRight]
      AutoSize = False
      Caption = 
        'M'#234's prov'#225'vel de entrega ........................................' +
        '................................................................' +
        '................................................................' +
        '......'
      Color = clBtnShadow
      ParentColor = False
      Transparent = True
    end
    object Label_Equipamento: TLabel
      Left = 8
      Top = 17
      Width = 646
      Height = 13
      Anchors = [akLeft, akTop, akRight]
      AutoSize = False
      Caption = 
        'Equipamento ....................................................' +
        '................................................................' +
        '.......................'
      Color = clActiveCaption
      ParentColor = False
      Transparent = True
    end
    object Label_EquipamentoValor: TLabel
      Left = 514
      Top = 17
      Width = 140
      Height = 13
      Alignment = taRightJustify
      Anchors = [akTop, akRight]
      Caption = 'Label_EquipamentoValor'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clRed
      Font.Height = -11
      Font.Name = 'Tahoma'
      Font.Style = [fsBold]
      ParentFont = False
      Transparent = True
    end
    object Label_Ano: TLabel
      Left = 8
      Top = 74
      Width = 646
      Height = 13
      Anchors = [akLeft, akTop, akRight]
      AutoSize = False
      Caption = 
        'Ano prov'#225'vel de entrega ........................................' +
        '................................................................' +
        '.................................................'
      Color = clActiveCaption
      ParentColor = False
      Transparent = True
    end
    object Label_VoltagemValor: TLabel
      Left = 534
      Top = 36
      Width = 120
      Height = 13
      Alignment = taRightJustify
      Anchors = [akTop, akRight]
      Caption = 'Label_VoltagemValor'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clRed
      Font.Height = -11
      Font.Name = 'Tahoma'
      Font.Style = [fsBold]
      ParentFont = False
      Transparent = True
    end
    object Label_MesValor: TLabel
      Left = 565
      Top = 55
      Width = 89
      Height = 13
      Alignment = taRightJustify
      Anchors = [akTop, akRight]
      Caption = 'Label_MesValor'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clRed
      Font.Height = -11
      Font.Name = 'Tahoma'
      Font.Style = [fsBold]
      ParentFont = False
      Transparent = True
    end
    object Label_AnoValor: TLabel
      Left = 566
      Top = 74
      Width = 88
      Height = 13
      Alignment = taRightJustify
      Anchors = [akTop, akRight]
      Caption = 'Label_AnoValor'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clRed
      Font.Height = -11
      Font.Name = 'Tahoma'
      Font.Style = [fsBold]
      ParentFont = False
      Transparent = True
    end
  end
  object CFDBGrid_PropostasRelacionadas: TCFDBGrid [3]
    AlignWithMargins = True
    Left = 6
    Top = 151
    Width = 662
    Height = 153
    Margins.Left = 6
    Margins.Right = 6
    Margins.Bottom = 6
    Align = alClient
    DataSource = BDODataModule_InformacoesDoEquipamento.DataSource_PRO
    Options = [dgEditing, dgTitles, dgColLines, dgRowLines, dgTabs, dgConfirmDelete, dgCancelOnExit]
    OptionsEx = [dgAllowTitleClick, dgAutomaticColumSizes]
    ReadOnly = True
    TabOrder = 3
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
    VariableWidthColumns = '<NOMEDAOBRA>'
    Columns = <
      item
        Alignment = taCenter
        Expanded = False
        FieldName = 'CODIGO'
        Title.Alignment = taCenter
        Title.Caption = 'Proposta'
        Width = 91
        Visible = True
      end
      item
        Alignment = taCenter
        Expanded = False
        FieldName = 'DATADEENTRADA'
        Title.Alignment = taCenter
        Title.Caption = 'Entrada'
        Width = 70
        Visible = True
      end
      item
        Expanded = False
        FieldName = 'NOMEDAOBRA'
        Title.Caption = 'Obra'
        Width = 319
        Visible = True
      end
      item
        Alignment = taCenter
        Expanded = False
        FieldName = 'SITUACAO'
        Title.Alignment = taCenter
        Title.Caption = 'Situa'#231#227'o'
        Width = 157
        Visible = True
      end>
  end
end
