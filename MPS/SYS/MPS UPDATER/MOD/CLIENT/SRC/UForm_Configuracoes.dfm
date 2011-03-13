object Form_Configuracoes: TForm_Configuracoes
  Left = 0
  Top = 0
  BorderStyle = bsDialog
  Caption = 'Configura'#231#245'es'
  ClientHeight = 261
  ClientWidth = 189
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  Position = poScreenCenter
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  DesignSize = (
    189
    261)
  PixelsPerInch = 96
  TextHeight = 13
  object LabeledEdit_Host: TLabeledEdit
    Left = 6
    Top = 17
    Width = 127
    Height = 21
    EditLabel.Width = 40
    EditLabel.Height = 13
    EditLabel.Caption = 'Servidor'
    LabelSpacing = 1
    TabOrder = 0
  end
  object LabeledEdit_Porta: TLabeledEdit
    Left = 139
    Top = 17
    Width = 43
    Height = 21
    EditLabel.Width = 26
    EditLabel.Height = 13
    EditLabel.Caption = 'Porta'
    LabelSpacing = 1
    TabOrder = 1
  end
  object BitBtn_OK: TBitBtn
    Left = 97
    Top = 230
    Width = 85
    Height = 25
    Anchors = [akBottom]
    TabOrder = 2
    Kind = bkOK
  end
  object BitBtn_Cancelar: TBitBtn
    Left = 6
    Top = 230
    Width = 85
    Height = 25
    Anchors = [akBottom]
    Caption = 'Cancelar'
    TabOrder = 3
    Kind = bkCancel
  end
  object LabeledEdit_Usuario: TLabeledEdit
    Left = 6
    Top = 53
    Width = 176
    Height = 21
    EditLabel.Width = 36
    EditLabel.Height = 13
    EditLabel.Caption = 'Usu'#225'rio'
    LabelSpacing = 1
    TabOrder = 4
  end
  object LabeledEdit_Senha: TLabeledEdit
    Left = 6
    Top = 88
    Width = 176
    Height = 21
    EditLabel.Width = 30
    EditLabel.Height = 13
    EditLabel.Caption = 'Senha'
    LabelSpacing = 1
    PasswordChar = #248
    TabOrder = 5
  end
  object PageControl_Opcoes: TPageControl
    Left = 6
    Top = 115
    Width = 176
    Height = 109
    ActivePage = TabSheet_Geral
    TabOrder = 6
    object TabSheet_Geral: TTabSheet
      Caption = 'Geral'
      object Label_Formato: TLabel
        Left = 3
        Top = 43
        Width = 151
        Height = 13
        Caption = 'Formato dos arquivos de dados'
      end
      object ComboBox_Formato: TComboBox
        Left = 3
        Top = 57
        Width = 162
        Height = 21
        Style = csDropDownList
        ItemHeight = 13
        TabOrder = 0
        Items.Strings = (
          'TEXTO (TXT)'
          'BIN'#193'RIO (BIN)')
      end
      object LabeledEdit_Sistema: TLabeledEdit
        Left = 3
        Top = 16
        Width = 162
        Height = 21
        CharCase = ecUpperCase
        EditLabel.Width = 128
        EditLabel.Height = 13
        EditLabel.Caption = 'Sistema(s). Separe com ";"'
        LabelSpacing = 1
        TabOrder = 1
      end
    end
    object TabSheet_Checagem: TTabSheet
      Caption = 'Checagem autom'#225'tica'
      ImageIndex = 1
      object Label1: TLabel
        Left = 3
        Top = 40
        Width = 162
        Height = 41
        Alignment = taCenter
        AutoSize = False
        Caption = 
          'A checagem autom'#225'tica apenas verifica a exist'#234'ncia de uma nova v' +
          'ers'#227'o. Nada '#233' atualizado!'
        WordWrap = True
      end
      object LabeledEdit_AutoCheck: TLabeledEdit
        Left = 3
        Top = 16
        Width = 162
        Height = 21
        EditLabel.Width = 96
        EditLabel.Height = 13
        EditLabel.Caption = 'Checar a cada (min)'
        LabelSpacing = 1
        TabOrder = 0
        OnKeyPress = LabeledEdit_AutoCheckKeyPress
      end
    end
  end
end
