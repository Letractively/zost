object Form1: TForm1
  Left = 527
  Top = 282
  BorderIcons = [biSystemMenu, biMinimize]
  BorderStyle = bsSingle
  Caption = 'Gerador de Cen'#225'rio para Autua'#231#227'o Autom'#225'tica'
  ClientHeight = 91
  ClientWidth = 383
  Color = clBtnFace
  DefaultMonitor = dmPrimary
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  Position = poScreenCenter
  DesignSize = (
    383
    91)
  PixelsPerInch = 96
  TextHeight = 13
  object Label1: TLabel
    Left = 347
    Top = 18
    Width = 29
    Height = 13
    Alignment = taRightJustify
    Anchors = [akTop, akRight]
    Caption = '??/??'
  end
  object Label2: TLabel
    Left = 6
    Top = 54
    Width = 63
    Height = 13
    Caption = 'Tabela: ????'
  end
  object Button1: TButton
    Left = 6
    Top = 6
    Width = 75
    Height = 25
    Caption = 'Iniciar'
    TabOrder = 0
    OnClick = Button1Click
  end
  object ProgressBar1: TProgressBar
    Left = 6
    Top = 36
    Width = 370
    Height = 17
    Anchors = [akLeft, akTop, akRight]
    TabOrder = 1
  end
  object CheckBox1: TCheckBox
    Left = 6
    Top = 72
    Width = 179
    Height = 13
    Caption = 'Modo Simulado (Rollback no final)'
    Checked = True
    State = cbChecked
    TabOrder = 2
  end
  object TRF5DSV: TZConnection
    Protocol = 'oracle'
    HostName = 'TRF5DSV'
    Database = 'TRF5DSV'
    User = 'ESPARTA2'
    Password = 'ESPARTA2'
    Connected = True
    Left = 84
    Top = 6
  end
  object TRF5PRD: TZConnection
    Protocol = 'oracle'
    HostName = 'TRF5PRD'
    Database = 'TRF5PRD'
    User = 'mps'
    Password = 'anal'
    AutoCommit = False
    ReadOnly = True
    Connected = True
    Left = 120
    Top = 6
  end
  object SOURCE: TZReadOnlyQuery
    Connection = TRF5PRD
    Params = <>
    Left = 156
    Top = 6
  end
  object DESTINATION: TZQuery
    Connection = TRF5DSV
    AutoCalcFields = False
    UpdateObject = TRF5DSVUPDATE
    Params = <>
    UpdateMode = umUpdateAll
    WhereMode = wmWhereAll
    Left = 192
    Top = 6
  end
  object TRF5DSVUPDATE: TZUpdateSQL
    UseSequenceFieldForRefreshSQL = False
    MultiStatements = False
    Left = 228
    Top = 6
  end
end
