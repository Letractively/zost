object Form_Principal: TForm_Principal
  Left = 0
  Top = 0
  BorderIcons = [biSystemMenu, biMinimize]
  BorderStyle = bsSingle
  Caption = 'MPS Winston, a seu dispor!'
  ClientHeight = 458
  ClientWidth = 748
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  OnCloseQuery = FormCloseQuery
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 13
  object Label_Sumario: TLabel
    Left = 648
    Top = 179
    Width = 94
    Height = 16
    Alignment = taRightJustify
    Caption = 'Label_Sumario'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -13
    Font.Name = 'Tahoma'
    Font.Style = [fsBold]
    ParentFont = False
  end
  object StatusBar_Principal: TStatusBar
    Left = 0
    Top = 428
    Width = 748
    Height = 30
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clBtnText
    Font.Height = -16
    Font.Name = 'Tahoma'
    Font.Style = [fsBold]
    Panels = <
      item
        Alignment = taCenter
        Text = 'dd/mm/yyyy'
        Width = 120
      end
      item
        Alignment = taCenter
        Text = 'asdasd'
        Width = 90
      end
      item
        Width = 50
      end>
    SizeGrip = False
    UseSystemFont = False
  end
  object Panel_Principal: TPanel
    AlignWithMargins = True
    Left = 6
    Top = 267
    Width = 736
    Height = 45
    Margins.Left = 6
    Margins.Right = 6
    Align = alBottom
    TabOrder = 2
    DesignSize = (
      736
      45)
    object Shape_Principal: TShape
      Left = 141
      Top = 7
      Width = 588
      Height = 31
      Anchors = [akLeft, akTop, akRight]
      Brush.Color = clActiveCaption
      Pen.Color = clWhite
    end
    object DBText_VA_CODIGO: TDBText
      Left = 141
      Top = 7
      Width = 588
      Height = 31
      Alignment = taCenter
      Anchors = [akLeft, akTop, akRight]
      Color = clActiveCaption
      DataField = 'VA_DESCRICAO'
      DataSource = DataModule_Principal.DataSource_CODIGOSDACCU
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clCaptionText
      Font.Height = -11
      Font.Name = 'Tahoma'
      Font.Style = []
      ParentColor = False
      ParentFont = False
      Transparent = True
      WordWrap = True
    end
    object DBLookupComboBox_TI_CODIGOSDACCU_ID: TDBLookupComboBox
      Left = 6
      Top = 7
      Width = 129
      Height = 31
      DataField = 'TI_CODIGOSDACCU_ID'
      DataSource = DataModule_Principal.DataSource_CCU
      DropDownRows = 8
      DropDownWidth = 721
      Enabled = False
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -19
      Font.Name = 'Tahoma'
      Font.Style = []
      KeyField = 'TI_CODIGOSDACCU_ID'
      ListField = 'VA_CODIGO;VA_DESCRICAO'
      ListSource = DataModule_Principal.DataSource_CODIGOSDACCU
      ParentFont = False
      TabOrder = 0
    end
  end
  object GroupBox_DataSet: TGroupBox
    Left = 277
    Top = 4
    Width = 465
    Height = 37
    BiDiMode = bdLeftToRight
    Caption = ' Conjunto de dados '
    ParentBiDiMode = False
    TabOrder = 0
    DesignSize = (
      465
      37)
    object RadioButton_Completo: TRadioButton
      Left = 6
      Top = 16
      Width = 62
      Height = 13
      Caption = 'Completo'
      Checked = True
      TabOrder = 0
      TabStop = True
      OnClick = DConfigurarDataSet
    end
    object RadioButton_DoDia: TRadioButton
      Left = 78
      Top = 16
      Width = 59
      Height = 13
      Caption = 'Dia atual'
      TabOrder = 1
      OnClick = DConfigurarDataSet
    end
    object RadioButton_MesEspecifico: TRadioButton
      Left = 220
      Top = 16
      Width = 90
      Height = 13
      Caption = 'M'#234's espec'#237'fico'
      TabOrder = 2
      OnClick = DConfigurarDataSet
    end
    object DateTimePicker_DataEspecifica: TDateTimePicker
      Left = 310
      Top = 11
      Width = 65
      Height = 21
      Date = 40158.000000000000000000
      Format = 'MM/yyyy'
      Time = 40158.000000000000000000
      Enabled = False
      TabOrder = 4
      OnChange = DateTimePicker_DataEspecificaChange
    end
    object BitBtn_Exportar: TBitBtn
      Left = 381
      Top = 11
      Width = 78
      Height = 21
      Action = DataModule_Principal.Action_ExportarCCU
      Anchors = [akTop, akRight]
      Caption = 'Exportar CCU'
      TabOrder = 5
    end
    object RadioButton_MesAtual: TRadioButton
      Left = 147
      Top = 16
      Width = 63
      Height = 13
      Caption = 'M'#234's atual'
      TabOrder = 3
      OnClick = DConfigurarDataSet
    end
  end
  object Panel_Informacao: TPanel
    AlignWithMargins = True
    Left = 6
    Top = 399
    Width = 736
    Height = 23
    Margins.Left = 6
    Margins.Right = 6
    Margins.Bottom = 6
    Align = alBottom
    BevelInner = bvLowered
    Caption = 'Para confirmar a informa'#231#227'o acima, utilize CTRL + ENTER'
    Color = clInfoBk
    ParentBackground = False
    TabOrder = 4
  end
  object GroupBox_Filtro: TGroupBox
    Left = 6
    Top = 4
    Width = 265
    Height = 191
    Caption = ' Filtro '
    TabOrder = 5
    object Shape_bg: TShape
      Left = 6
      Top = 94
      Width = 253
      Height = 90
      Brush.Color = clInfoBk
    end
    object Label_CDC_VA_CODIGO: TLabel
      Left = 6
      Top = 53
      Width = 81
      Height = 13
      Caption = 'C'#243'digo da CCU '#233
    end
    object Label_CDC_VA_DESCRICAO: TLabel
      Left = 9
      Top = 97
      Width = 247
      Height = 84
      Alignment = taCenter
      AutoSize = False
      Caption = 'Label_CDC_VA_DESCRICAO'
      Color = clInfoBk
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'Tahoma'
      Font.Style = []
      ParentColor = False
      ParentFont = False
      Transparent = True
      Layout = tlCenter
      WordWrap = True
    end
    object LabeledEdit_CCU_TX_DESCRICAO: TLabeledEdit
      Left = 6
      Top = 26
      Width = 253
      Height = 21
      EditLabel.Width = 123
      EditLabel.Height = 13
      EditLabel.Caption = 'Descri'#231#227'o da CCU cont'#233'm'
      LabelSpacing = 1
      TabOrder = 0
      Text = '*'
      OnChange = LabeledEdit_CCU_TX_DESCRICAOChange
    end
    object ComboBox_CDC_VA_CODIGO: TComboBox
      Left = 6
      Top = 67
      Width = 85
      Height = 21
      Style = csDropDownList
      ItemHeight = 13
      TabOrder = 1
      OnChange = ComboBox_CDC_VA_CODIGOChange
    end
  end
  object DBMemo_TX_DESCRICAO: TDBMemo
    AlignWithMargins = True
    Left = 6
    Top = 318
    Width = 736
    Height = 75
    Margins.Left = 6
    Margins.Right = 6
    Align = alBottom
    DataField = 'TX_DESCRICAO'
    DataSource = DataModule_Principal.DataSource_CCU
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'Courier New'
    Font.Style = []
    ParentFont = False
    ReadOnly = True
    TabOrder = 3
    OnKeyDown = DBMemo_TX_DESCRICAOKeyDown
  end
  object CFDBGrid_CCU: TCFDBGrid
    Left = 275
    Top = 47
    Width = 465
    Height = 130
    DataSource = DataModule_Principal.DataSource_CCU
    Options = [dgTitles, dgIndicator, dgColLines, dgRowLines, dgTabs, dgRowSelect, dgAlwaysShowSelection, dgConfirmDelete]
    OptionsEx = [dgAutomaticColumSizes]
    TabOrder = 6
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
    VariableWidthColumns = '<DT_DATAHORAINICIAL><DT_DATAHORAFINAL>'
    Columns = <
      item
        Alignment = taCenter
        Expanded = False
        FieldName = 'BI_CCU_ID'
        ReadOnly = True
        Title.Alignment = taCenter
        Title.Caption = 'ID'
        Width = 75
        Visible = True
      end
      item
        Alignment = taCenter
        Expanded = False
        FieldName = 'VA_CODIGO'
        ReadOnly = True
        Title.Alignment = taCenter
        Title.Caption = 'C'#243'digo'
        Width = 65
        Visible = True
      end
      item
        Alignment = taCenter
        Expanded = False
        FieldName = 'DT_DATAHORAINICIAL'
        Title.Alignment = taCenter
        Title.Caption = 'In'#237'cio'
        Width = 116
        Visible = True
      end
      item
        Alignment = taCenter
        Expanded = False
        FieldName = 'DT_DATAHORAFINAL'
        Title.Alignment = taCenter
        Title.Caption = 'Fim'
        Width = 115
        Visible = True
      end
      item
        Alignment = taCenter
        Expanded = False
        FieldName = 'TOTAL'
        ReadOnly = True
        Title.Alignment = taCenter
        Title.Caption = 'Total'
        Width = 50
        Visible = True
      end>
  end
  object PageControl_Principal: TPageControl
    AlignWithMargins = True
    Left = 6
    Top = 201
    Width = 736
    Height = 60
    Margins.Left = 6
    Margins.Right = 6
    ActivePage = TabSheet_TimeSheet
    Align = alBottom
    TabOrder = 7
    OnChange = PageControl_PrincipalChange
    object TabSheet_TimeSheet: TTabSheet
      Caption = 'Modo de edi'#231#227'o sequencial'
      object BitBtn_IniciarSequencial: TBitBtn
        Left = 3
        Top = 3
        Width = 87
        Height = 25
        Action = DataModule_Principal.Action_IniciarSequencial
        Caption = 'Iniciar'
        TabOrder = 0
      end
      object BitBtn_Parar: TBitBtn
        Left = 189
        Top = 3
        Width = 87
        Height = 25
        Action = DataModule_Principal.Action_FinalizarSequencial
        Caption = 'Finalizar'
        TabOrder = 2
      end
      object BitBtn_Cancelar: TBitBtn
        Left = 96
        Top = 3
        Width = 87
        Height = 25
        Action = DataModule_Principal.Action_CancelarSequencial
        Caption = 'Cancelar'
        TabOrder = 1
      end
    end
    object TabSheet_Livre: TTabSheet
      Caption = 'Modo de edi'#231#227'o livre'
      ImageIndex = 1
      ExplicitLeft = 0
      ExplicitTop = 0
      ExplicitWidth = 0
      ExplicitHeight = 0
      object BitBtn_IniciarLivre: TBitBtn
        Left = 3
        Top = 3
        Width = 87
        Height = 25
        Action = DataModule_Principal.Action_IniciarLivre
        Caption = 'Iniciar'
        TabOrder = 0
      end
      object BitBtn_CancelarLivre: TBitBtn
        Left = 96
        Top = 3
        Width = 87
        Height = 25
        Action = DataModule_Principal.Action_CancelarLivre
        Caption = 'Cancelar'
        TabOrder = 1
      end
    end
  end
end
