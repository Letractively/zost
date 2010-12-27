object Form_Principal: TForm_Principal
  Left = 413
  Top = 280
  BorderIcons = [biSystemMenu, biMinimize]
  BorderStyle = bsSingle
  Caption = 'License Generator'
  ClientHeight = 114
  ClientWidth = 822
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  Position = poScreenCenter
  DesignSize = (
    822
    114)
  PixelsPerInch = 96
  TextHeight = 13
  object LabeledEdit_Origem: TLabeledEdit
    Left = 6
    Top = 18
    Width = 810
    Height = 21
    Anchors = [akLeft, akTop, akRight]
    EditLabel.Width = 63
    EditLabel.Height = 13
    EditLabel.Caption = 'Serial original'
    LabelSpacing = 1
    TabOrder = 0
  end
  object LabeledEdit_Destino: TLabeledEdit
    Left = 6
    Top = 54
    Width = 810
    Height = 21
    Anchors = [akLeft, akTop, akRight]
    EditLabel.Width = 76
    EditLabel.Height = 13
    EditLabel.Caption = 'Serial da licen'#231'a'
    LabelSpacing = 1
    TabOrder = 1
  end
  object Button_Gerar: TButton
    Left = 6
    Top = 81
    Width = 75
    Height = 27
    Caption = 'Gerar'
    TabOrder = 2
    OnClick = Button_GerarClick
  end
end
