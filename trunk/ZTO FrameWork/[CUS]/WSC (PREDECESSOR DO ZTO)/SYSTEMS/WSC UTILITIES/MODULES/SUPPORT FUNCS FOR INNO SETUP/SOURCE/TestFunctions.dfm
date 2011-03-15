object Form1: TForm1
  Left = 0
  Top = 0
  Width = 347
  Height = 240
  Caption = 'Form1'
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  PixelsPerInch = 96
  TextHeight = 13
  object Button1: TButton
    Left = 6
    Top = 6
    Width = 103
    Height = 25
    Caption = 'Compare version 3'
    TabOrder = 0
    OnClick = Button1Click
  end
  object Button2: TButton
    Left = 114
    Top = 6
    Width = 127
    Height = 25
    Caption = 'change root password'
    TabOrder = 1
    OnClick = Button2Click
  end
  object ComboBox1: TComboBox
    Left = 6
    Top = 48
    Width = 145
    Height = 21
    ItemHeight = 13
    TabOrder = 2
    Text = 'ComboBox1'
  end
  object Button3: TButton
    Left = 156
    Top = 42
    Width = 75
    Height = 25
    Caption = 'Button3'
    TabOrder = 3
    OnClick = Button3Click
  end
end
