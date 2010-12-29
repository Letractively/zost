object Form_Principal: TForm_Principal
  Left = 413
  Top = 280
  BorderIcons = [biSystemMenu, biMinimize]
  BorderStyle = bsSingle
  Caption = 'License Generator - Licen'#231'a gerada para o HD na posi'#231#227'o 0:0'
  ClientHeight = 76
  ClientWidth = 259
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  Position = poScreenCenter
  PixelsPerInch = 96
  TextHeight = 13
  object Button_Gerar: TButton
    Left = 6
    Top = 44
    Width = 248
    Height = 25
    Caption = 'Gerar'
    TabOrder = 0
    OnClick = Button_GerarClick
  end
  object LabeledEdit_MesExpiracao: TLabeledEdit
    Left = 6
    Top = 17
    Width = 121
    Height = 21
    EditLabel.Width = 111
    EditLabel.Height = 13
    EditLabel.Caption = 'M'#234's de expira'#231#227'o (MM)'
    LabelSpacing = 1
    MaxLength = 2
    TabOrder = 1
  end
  object LabeledEdit_AnoExpiracao: TLabeledEdit
    Left = 132
    Top = 17
    Width = 122
    Height = 21
    EditLabel.Width = 123
    EditLabel.Height = 13
    EditLabel.Caption = 'Ano de expira'#231#227'o (AAAA)'
    LabelSpacing = 1
    MaxLength = 4
    TabOrder = 2
  end
end
