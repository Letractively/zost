object Form_Principal: TForm_Principal
  Left = 669
  Top = 317
  Width = 551
  Height = 349
  Caption = 'Form_Principal'
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  PixelsPerInch = 96
  TextHeight = 13
  object Button_IniciarGeracao: TButton
    Left = 12
    Top = 12
    Width = 121
    Height = 25
    Caption = 'Button_IniciarGeracao'
    TabOrder = 0
    OnClick = Button_IniciarGeracaoClick
  end
  object Memo_Log: TMemo
    Left = 0
    Top = 48
    Width = 543
    Height = 250
    Align = alBottom
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'Courier New'
    Font.Style = []
    ParentFont = False
    ScrollBars = ssVertical
    TabOrder = 1
  end
  object ProgressBar_Principal: TProgressBar
    Left = 0
    Top = 298
    Width = 543
    Height = 17
    Align = alBottom
    TabOrder = 2
  end
end
