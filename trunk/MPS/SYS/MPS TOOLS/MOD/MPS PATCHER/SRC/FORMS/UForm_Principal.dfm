object Form1: TForm1
  Left = 0
  Top = 0
  Caption = 'Form1'
  ClientHeight = 437
  ClientWidth = 724
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  PixelsPerInch = 96
  TextHeight = 13
  object Splitter_Principal: TSplitter
    AlignWithMargins = True
    Left = 6
    Top = 193
    Width = 712
    Height = 8
    Cursor = crVSplit
    Margins.Left = 6
    Margins.Right = 6
    Align = alTop
    Beveled = True
    ResizeStyle = rsUpdate
    ExplicitLeft = 11
    ExplicitTop = 207
  end
  object SynEdit_Codigo: TSynEdit
    AlignWithMargins = True
    Left = 6
    Top = 37
    Width = 712
    Height = 150
    Margins.Left = 6
    Margins.Right = 6
    Align = alTop
    Color = clWhite
    ActiveLineColor = clInfoBk
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -13
    Font.Name = 'Courier New'
    Font.Style = []
    TabOrder = 0
    Gutter.AutoSize = True
    Gutter.Font.Charset = DEFAULT_CHARSET
    Gutter.Font.Color = clWindowText
    Gutter.Font.Height = -11
    Gutter.Font.Name = 'Courier New'
    Gutter.Font.Style = []
    Gutter.ShowLineNumbers = True
    Gutter.Gradient = True
    Highlighter = SynPHPSyn_PHP
    Lines.Strings = (
      'phpinfo();'
      'echo('#39'carlos'#39');'
      '$variavel = 0;'
      '// coment'#225'rio')
    ExplicitLeft = 1
    ExplicitTop = -105
  end
  object ToolBar_Principal: TToolBar
    AlignWithMargins = True
    Left = 6
    Top = 6
    Width = 712
    Height = 25
    Margins.Left = 6
    Margins.Top = 6
    Margins.Right = 6
    AutoSize = True
    ButtonHeight = 25
    ButtonWidth = 25
    Caption = 'ToolBar_Principal'
    TabOrder = 1
    object ToolButton_Executar: TToolButton
      Left = 0
      Top = 0
      Action = Action_Executar
    end
    object ToolButton_Abrir: TToolButton
      Left = 25
      Top = 0
      Caption = 'ToolButton_Abrir'
      ImageIndex = 1
    end
  end
  object Panel_Browser: TPanel
    Left = 0
    Top = 204
    Width = 724
    Height = 233
    Align = alClient
    Caption = 'Panel_Browser'
    TabOrder = 2
    ExplicitLeft = 156
    ExplicitTop = 228
    ExplicitWidth = 185
    ExplicitHeight = 175
    object WebBrowser_Resultado: TWebBrowser
      Left = 1
      Top = 1
      Width = 722
      Height = 231
      Margins.Left = 6
      Margins.Right = 6
      Margins.Bottom = 6
      Align = alClient
      TabOrder = 0
      ExplicitLeft = 0
      ExplicitWidth = 183
      ExplicitHeight = 173
      ControlData = {
        4C00000096490000271700000000000000000000000000000000000000000000
        000000004C000000000000000000000001000000E0D057007335CF11AE690800
        2B2E126208000000000000004C0000000114020000000000C000000000000046
        8000000000000000000000000000000000000000000000000000000000000000
        00000000000000000100000000000000000000000000000000000000}
    end
  end
  object SynPHPSyn_PHP: TSynPHPSyn
    CommentAttri.Foreground = clGreen
    IdentifierAttri.Foreground = clBlue
    IdentifierAttri.Style = [fsBold]
    KeyAttri.Foreground = clRed
    NumberAttri.Foreground = clPurple
    NumberAttri.Style = [fsBold]
    StringAttri.Foreground = clSilver
    SymbolAttri.Style = [fsBold]
    VariableAttri.Foreground = 33023
    VariableAttri.Style = [fsBold]
    Left = 666
    Top = 42
  end
  object psvPHP_Executor: TpsvPHP
    Variables = <>
    Left = 630
    Top = 42
  end
  object PHPEngine_Engine: TPHPEngine
    Constants = <>
    ReportDLLError = False
    Left = 594
    Top = 42
  end
  object ActionList_Principal: TActionList
    Left = 558
    Top = 42
    object Action_Executar: TAction
      Caption = 'Action_Executar'
      OnExecute = Action_ExecutarExecute
    end
  end
end
