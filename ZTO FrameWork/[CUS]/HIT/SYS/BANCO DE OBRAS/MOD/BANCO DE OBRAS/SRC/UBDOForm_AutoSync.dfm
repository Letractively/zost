inherited BDOForm_AutoSync: TBDOForm_AutoSync
  BorderIcons = [biHelp]
  Caption = 'Sincroniza'#231#227'o autom'#225'tica em andamento...'
  ClientHeight = 309
  ClientWidth = 855
  ExplicitWidth = 861
  ExplicitHeight = 341
  DesignSize = (
    855
    309)
  PixelsPerInch = 96
  TextHeight = 13
  inherited Panel_Header: TPanel
    Width = 855
    TabOrder = 2
    ExplicitWidth = 855
    inherited Shape_BackgroundHeader: TShape
      Width = 855
      ExplicitWidth = 853
    end
    inherited Label_DialogDescription: TLabel
      Width = 809
      Caption = ''
      ExplicitWidth = 807
    end
    inherited Shape_HeaderLine: TShape
      Width = 847
      ExplicitWidth = 845
    end
    inherited Bevel_Header: TBevel
      Width = 855
      ExplicitWidth = 853
    end
  end
  inherited Panel_Footer: TPanel
    Top = 271
    Width = 855
    TabOrder = 3
    ExplicitTop = 271
    ExplicitWidth = 855
    inherited Shape_FooterBackground: TShape
      Width = 855
      ExplicitTop = 271
      ExplicitWidth = 853
    end
    inherited Shape_FooterLine: TShape
      Width = 847
      ExplicitTop = 4
      ExplicitWidth = 847
    end
    inherited Shape_Organizer: TShape
      Width = 847
      ExplicitTop = 9
      ExplicitWidth = 847
    end
    inherited Bevel_Footer: TBevel
      Width = 855
      ExplicitTop = 271
      ExplicitWidth = 853
    end
    object Label_Percent: TLabel
      Left = 788
      Top = 9
      Width = 63
      Height = 25
      Alignment = taCenter
      Anchors = [akRight, akBottom]
      AutoSize = False
      Caption = '0%'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clCaptionText
      Font.Height = -20
      Font.Name = 'Tahoma'
      Font.Style = [fsBold]
      ParentFont = False
      Transparent = True
      ExplicitLeft = 786
      ExplicitTop = 343
    end
  end
  object RichEdit_Log: TRichEdit [2]
    AlignWithMargins = True
    Left = 6
    Top = 55
    Width = 843
    Height = 210
    Margins.Left = 6
    Margins.Top = 6
    Margins.Right = 6
    Margins.Bottom = 6
    Align = alClient
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'Courier New'
    Font.Style = []
    ParentFont = False
    ReadOnly = True
    ScrollBars = ssVertical
    TabOrder = 0
    WordWrap = False
  end
  object ProgressBar_Progress: TProgressBar [3]
    Left = 4
    Top = 280
    Width = 778
    Height = 25
    Anchors = [akLeft, akRight, akBottom]
    TabOrder = 1
  end
end
