object FForm_Main: TFForm_Main
  Left = 0
  Top = 0
  Caption = 'FForm_Main'
  ClientHeight = 573
  ClientWidth = 543
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  OnCreate = FormCreate
  DesignSize = (
    543
    573)
  PixelsPerInch = 96
  TextHeight = 13
  object Label_Object: TLabel
    Left = 8
    Top = 195
    Width = 33
    Height = 13
    Caption = 'Objeto'
  end
  object Label_Script: TLabel
    Left = 271
    Top = 195
    Width = 27
    Height = 13
    Caption = 'Script'
  end
  object Label_Customers: TLabel
    Left = 8
    Top = 52
    Width = 38
    Height = 13
    Caption = 'Clientes'
  end
  object Shape1: TShape
    Left = 8
    Top = 6
    Width = 527
    Height = 40
    Brush.Color = clInfoBk
  end
  object Bevel1: TBevel
    Left = 8
    Top = 6
    Width = 527
    Height = 40
  end
  object Label1: TLabel
    Left = 8
    Top = 6
    Width = 527
    Height = 40
    Alignment = taCenter
    AutoSize = False
    Caption = 
      'Lembre-se de recompilar este aplicativo antes de execut'#225'-lo caso' +
      ' tenha havido alguma altera'#231#227'o nos c'#243'digos-fonte de sincroniza'#231#227 +
      'o. Tamb'#233'm ser'#225' necess'#225'ria uma recompila'#231#227'o com as diretivas adeq' +
      'uadas para testar certos comportamentos que s'#243' existem em determ' +
      'inados sistemas.'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clRed
    Font.Height = -11
    Font.Name = 'Tahoma'
    Font.Style = []
    ParentFont = False
    Transparent = True
    Layout = tlCenter
    WordWrap = True
  end
  object Button_OpenSyncFile: TButton
    Left = 8
    Top = 126
    Width = 527
    Height = 25
    Anchors = [akLeft, akTop, akRight]
    Caption = 'Abrir arquivo de sincroniza'#231#227'o'
    TabOrder = 0
    OnClick = Button_OpenSyncFileClick
  end
  object Memo_Object: TMemo
    Left = 6
    Top = 210
    Width = 259
    Height = 355
    Anchors = [akLeft, akTop, akBottom]
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'Courier New'
    Font.Style = []
    ParentFont = False
    ReadOnly = True
    ScrollBars = ssBoth
    TabOrder = 1
    OnKeyDown = DoKeyDown
  end
  object Memo_Script: TMemo
    Left = 271
    Top = 210
    Width = 264
    Height = 355
    Anchors = [akLeft, akTop, akBottom]
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'Courier New'
    Font.Style = []
    ParentFont = False
    ReadOnly = True
    ScrollBars = ssBoth
    TabOrder = 2
    OnKeyDown = DoKeyDown
  end
  object ListBox_Customers: TListBox
    Left = 8
    Top = 65
    Width = 527
    Height = 56
    Anchors = [akLeft, akTop, akRight]
    Columns = 3
    IntegralHeight = True
    ItemHeight = 13
    Items.Strings = (
      'Hitachi Ar Condicionado do Brasil')
    TabOrder = 3
    OnClick = ListBox_CustomersClick
  end
  object GroupBox1: TGroupBox
    Left = 8
    Top = 152
    Width = 527
    Height = 37
    Caption = ' Op'#231#245'es diversas '
    TabOrder = 4
    object CheckBox1: TCheckBox
      Left = 7
      Top = 17
      Width = 118
      Height = 13
      Caption = 'Use PrimaryKeyValue'
      TabOrder = 0
    end
    object CheckBox_CompressedFile: TCheckBox
      Left = 131
      Top = 17
      Width = 129
      Height = 13
      Caption = 'O arquivo '#233' comprimido'
      TabOrder = 1
    end
  end
  object OpenDialog_OpenSyncFile: TOpenDialog
    DefaultExt = '*.dat'
    Filter = 'Arquivo de sincroniza'#231#227'o (*.dat)|*.dat'
    Left = 516
  end
end
