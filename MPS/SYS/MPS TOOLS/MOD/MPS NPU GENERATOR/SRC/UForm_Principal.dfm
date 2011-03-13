object Form_Principal: TForm_Principal
  Left = 0
  Top = 0
  BorderIcons = [biSystemMenu, biMinimize]
  BorderStyle = bsSingle
  Caption = 'NPU Generator'
  ClientHeight = 303
  ClientWidth = 278
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  Position = poScreenCenter
  OnClose = FormClose
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 13
  object SpeedButton_GerarDigito: TSpeedButton
    Left = 6
    Top = 148
    Width = 266
    Height = 25
    Caption = 'Gerar n'#250'mero de processo v'#225'lido'
    OnClick = SpeedButton_GerarDigitoClick
  end
  object SpeedButton_Validar: TSpeedButton
    Left = 6
    Top = 210
    Width = 266
    Height = 25
    Caption = 'Validar o processo segundo os par'#226'metros'
    OnClick = SpeedButton_ValidarClick
  end
  object SpeedButton_Formatar: TSpeedButton
    Left = 6
    Top = 179
    Width = 266
    Height = 25
    Caption = 'Formatar processo'
    OnClick = SpeedButton_FormatarClick
  end
  object SpeedButton_ObterDigitoVerificador: TSpeedButton
    Left = 6
    Top = 241
    Width = 266
    Height = 25
    Caption = 'Extrair componentes do NPU'
    OnClick = SpeedButton_ObterDigitoVerificadorClick
  end
  object SpeedButton_RemoverDelimitadores: TSpeedButton
    Left = 6
    Top = 272
    Width = 266
    Height = 25
    Caption = 'Remover caracteres delimitadores'
    OnClick = SpeedButton_RemoverDelimitadoresClick
  end
  object GroupBox_Parametros: TGroupBox
    AlignWithMargins = True
    Left = 6
    Top = 3
    Width = 266
    Height = 99
    Margins.Left = 6
    Margins.Right = 6
    Align = alTop
    Caption = ' Par'#226'metros fornecidos '#224' DLL '
    TabOrder = 0
    object LabeledEdit_Sequencial: TLabeledEdit
      Left = 8
      Top = 29
      Width = 121
      Height = 21
      EditLabel.Width = 51
      EditLabel.Height = 13
      EditLabel.Caption = 'Sequencial'
      LabelSpacing = 1
      MaxLength = 7
      TabOrder = 0
      Text = '1000000'
      OnKeyPress = LabeledEdit_SequencialKeyPress
    end
    object LabeledEdit_Ano: TLabeledEdit
      Left = 135
      Top = 29
      Width = 123
      Height = 21
      EditLabel.Width = 19
      EditLabel.Height = 13
      EditLabel.Caption = 'Ano'
      LabelSpacing = 1
      MaxLength = 4
      TabOrder = 1
      Text = '2010'
      OnKeyPress = LabeledEdit_SequencialKeyPress
    end
    object LabeledEdit_Justica: TLabeledEdit
      Left = 8
      Top = 69
      Width = 57
      Height = 21
      EditLabel.Width = 33
      EditLabel.Height = 13
      EditLabel.Caption = 'Justi'#231'a'
      LabelSpacing = 1
      MaxLength = 1
      TabOrder = 2
      Text = '4'
      OnKeyPress = LabeledEdit_SequencialKeyPress
    end
    object LabeledEdit_Origem: TLabeledEdit
      Left = 136
      Top = 69
      Width = 122
      Height = 21
      EditLabel.Width = 93
      EditLabel.Height = 13
      EditLabel.Caption = 'Origem (REG+LOC)'
      LabelSpacing = 1
      MaxLength = 4
      TabOrder = 4
      Text = '0000'
      OnKeyPress = LabeledEdit_SequencialKeyPress
    end
    object LabeledEdit_Tribunal: TLabeledEdit
      Left = 71
      Top = 69
      Width = 58
      Height = 21
      EditLabel.Width = 38
      EditLabel.Height = 13
      EditLabel.Caption = 'Tribunal'
      LabelSpacing = 1
      MaxLength = 2
      TabOrder = 3
      Text = '5'
      OnKeyPress = LabeledEdit_SequencialKeyPress
    end
  end
  object LabeledEdit_NumProcesso: TLabeledEdit
    Left = 6
    Top = 120
    Width = 266
    Height = 21
    EditLabel.Width = 43
    EditLabel.Height = 13
    EditLabel.Caption = 'Processo'
    LabelSpacing = 1
    TabOrder = 1
    Text = '0000100-02.2009.4.00.0000'
  end
end
