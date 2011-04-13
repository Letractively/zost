object Form_Principal: TForm_Principal
  Left = 0
  Top = 0
  BorderIcons = [biSystemMenu, biMinimize]
  BorderStyle = bsSingle
  Caption = 'MPS Updater (Client)'
  ClientHeight = 292
  ClientWidth = 814
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  Position = poScreenCenter
  OnCloseQuery = FormCloseQuery
  OnCreate = FormCreate
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object RichEdit_Log: TRichEdit
    AlignWithMargins = True
    Left = 6
    Top = 6
    Width = 802
    Height = 165
    Margins.Left = 6
    Margins.Top = 6
    Margins.Right = 6
    Margins.Bottom = 0
    Align = alClient
    Font.Charset = ANSI_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'Courier New'
    Font.Style = []
    ParentFont = False
    ReadOnly = True
    ScrollBars = ssVertical
    TabOrder = 0
  end
  object StatusBar1: TStatusBar
    Left = 0
    Top = 254
    Width = 814
    Height = 19
    Panels = <
      item
        Alignment = taCenter
        Width = 50
      end>
    SizeGrip = False
  end
  object StatusBar2: TStatusBar
    Left = 0
    Top = 273
    Width = 814
    Height = 19
    Panels = <
      item
        Alignment = taCenter
        Text = 'Autochecagem desligada'
        Width = 140
      end
      item
        Alignment = taCenter
        Text = #218'ltima sincroniza'#231#227'o em dd/mm/yyyy '#224's hh:nn:ss'
        Width = 250
      end>
  end
  object Panel_LayerInferior: TPanel
    AlignWithMargins = True
    Left = 6
    Top = 177
    Width = 802
    Height = 71
    Margins.Left = 6
    Margins.Top = 6
    Margins.Right = 6
    Margins.Bottom = 6
    Align = alBottom
    BevelOuter = bvNone
    TabOrder = 3
    DesignSize = (
      802
      71)
    object Panel_ModoMini: TPanel
      Left = 0
      Top = 46
      Width = 802
      Height = 25
      Anchors = [akLeft, akTop, akRight]
      BevelInner = bvRaised
      BevelOuter = bvLowered
      Color = clInfoBk
      ParentBackground = False
      TabOrder = 1
      DesignSize = (
        802
        25)
      object Label_ModoMini: TLabel
        Left = 6
        Top = 0
        Width = 790
        Height = 23
        Anchors = [akLeft, akTop, akRight]
        AutoSize = False
        Caption = '...'
        EllipsisPosition = epPathEllipsis
        Transparent = True
        Layout = tlCenter
      end
    end
    object Panel_LayerBotoes: TPanel
      Left = 0
      Top = 46
      Width = 802
      Height = 25
      BevelOuter = bvNone
      TabOrder = 0
      DesignSize = (
        802
        25)
      object BitBtn_Configurar: TBitBtn
        Left = 0
        Top = 0
        Width = 190
        Height = 25
        Caption = 'Configura'#231#245'es...'
        TabOrder = 0
        OnClick = BitBtn_ConfigurarClick
      end
      object BitBtn_SalvarLog: TBitBtn
        Left = 204
        Top = 0
        Width = 190
        Height = 25
        Anchors = [akTop]
        Caption = 'Salvar LOG'
        TabOrder = 1
      end
      object Button_ChecarAgora: TButton
        Left = 408
        Top = 0
        Width = 190
        Height = 25
        Action = DataModule_Principal.Action_AtualizarAgora
        Anchors = [akTop]
        TabOrder = 2
      end
      object Button_EsconderNaBarraDeTarefas: TButton
        Left = 612
        Top = 0
        Width = 190
        Height = 25
        Action = DataModule_Principal.Action_EsconderNaBarraDeTarefas
        Anchors = [akTop, akRight, akBottom]
        TabOrder = 3
      end
    end
    object Panel_DoArquivo: TPanel
      AlignWithMargins = True
      Left = 0
      Top = 0
      Width = 802
      Height = 17
      Margins.Left = 0
      Margins.Top = 0
      Margins.Right = 0
      Align = alTop
      BevelOuter = bvNone
      TabOrder = 2
      DesignSize = (
        802
        17)
      object Label_ProgressDoArquivo: TLabel
        Left = 744
        Top = -3
        Width = 59
        Height = 23
        Alignment = taCenter
        Anchors = [akRight, akBottom]
        AutoSize = False
        Caption = '0%'
        Color = clBtnFace
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -19
        Font.Name = 'Tahoma'
        Font.Style = [fsBold]
        ParentColor = False
        ParentFont = False
        ExplicitLeft = 743
      end
      object Label1: TLabel
        Left = 37
        Top = -3
        Width = 109
        Height = 23
        Anchors = [akLeft, akBottom]
        AutoSize = False
        Caption = 'Arquivo atual'
        Color = clBtnFace
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -16
        Font.Name = 'Tahoma'
        Font.Style = [fsBold]
        ParentColor = False
        ParentFont = False
        Layout = tlCenter
        OnClick = Label1Click
      end
      object ProgressBar_Arquivo: TProgressBar
        Left = 152
        Top = 0
        Width = 588
        Height = 17
        Anchors = [akLeft, akTop, akRight]
        Max = 0
        ParentShowHint = False
        Smooth = True
        ShowHint = True
        TabOrder = 0
      end
    end
    object Panel_Geral: TPanel
      AlignWithMargins = True
      Left = 0
      Top = 23
      Width = 802
      Height = 17
      Margins.Left = 0
      Margins.Right = 0
      Align = alTop
      BevelOuter = bvNone
      TabOrder = 3
      DesignSize = (
        802
        17)
      object Label_ProgressGeral: TLabel
        Left = 744
        Top = -3
        Width = 59
        Height = 23
        Alignment = taCenter
        Anchors = [akRight, akBottom]
        AutoSize = False
        Caption = '0%'
        Color = clBtnFace
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -19
        Font.Name = 'Tahoma'
        Font.Style = [fsBold]
        ParentColor = False
        ParentFont = False
        ExplicitLeft = 743
      end
      object Label2: TLabel
        Left = 0
        Top = -3
        Width = 146
        Height = 23
        Anchors = [akLeft, akBottom]
        AutoSize = False
        Caption = 'Todos os arquivos'
        Color = clBtnFace
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -16
        Font.Name = 'Tahoma'
        Font.Style = [fsBold]
        ParentColor = False
        ParentFont = False
        Layout = tlCenter
      end
      object ProgressBar_Geral: TProgressBar
        Left = 152
        Top = 0
        Width = 588
        Height = 17
        Anchors = [akLeft, akTop, akRight]
        Max = 0
        ParentShowHint = False
        Smooth = True
        ShowHint = True
        TabOrder = 0
      end
    end
  end
end
