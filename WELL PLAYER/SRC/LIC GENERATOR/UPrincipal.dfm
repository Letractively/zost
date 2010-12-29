object Form_Principal: TForm_Principal
  Left = 413
  Top = 280
  BorderIcons = [biSystemMenu, biMinimize]
  BorderStyle = bsSingle
  Caption = 'Gerador de Licen'#231'as'
  ClientHeight = 126
  ClientWidth = 259
  Color = clSilver
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  Position = poScreenCenter
  OnCreate = FormCreate
  DesignSize = (
    259
    126)
  PixelsPerInch = 96
  TextHeight = 13
  object Label_Serial: TLabel
    Left = 6
    Top = 64
    Width = 247
    Height = 17
    Alignment = taCenter
    Anchors = [akLeft, akTop, akRight, akBottom]
    AutoSize = False
    Caption = '?????'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -17
    Font.Name = 'Tahoma'
    Font.Style = [fsBold]
    ParentFont = False
    Layout = tlCenter
    WordWrap = True
  end
  object Label1: TLabel
    Left = 8
    Top = 40
    Width = 249
    Height = 16
    Alignment = taCenter
    AutoSize = False
    Caption = 'Serial - HD 0 (Principal)'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -13
    Font.Name = 'Tahoma'
    Font.Style = []
    ParentFont = False
  end
  object Button_Gerar: TButton
    Left = 6
    Top = 94
    Width = 248
    Height = 25
    Anchors = [akLeft, akRight, akBottom]
    Caption = 'Gerar Licen'#231'a'
    TabOrder = 0
    OnClick = Button_GerarClick
  end
  object LabeledEdit_MesExpiracao: TLabeledEdit
    Left = 10
    Top = 17
    Width = 85
    Height = 21
    EditLabel.Width = 111
    EditLabel.Height = 13
    EditLabel.Caption = 'M'#234's de expira'#231#227'o (MM)'
    LabelSpacing = 1
    MaxLength = 2
    TabOrder = 1
  end
  object LabeledEdit_AnoExpiracao: TLabeledEdit
    Left = 133
    Top = 17
    Width = 84
    Height = 21
    EditLabel.Width = 123
    EditLabel.Height = 13
    EditLabel.Caption = 'Ano de expira'#231#227'o (AAAA)'
    LabelSpacing = 1
    MaxLength = 4
    TabOrder = 2
  end
end
