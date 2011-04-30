object FSSForm_Configurations: TFSSForm_Configurations
  Left = 0
  Top = 0
  BorderStyle = bsDialog
  Caption = 'Dados para acesso'
  ClientHeight = 269
  ClientWidth = 522
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
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object GroupBox1: TGroupBox
    AlignWithMargins = True
    Left = 6
    Top = 3
    Width = 510
    Height = 97
    Margins.Left = 6
    Margins.Right = 6
    Margins.Bottom = 18
    Align = alTop
    Caption = ' MySQL Local (mysql@localhost) '
    TabOrder = 0
    ExplicitWidth = 440
    object LabelProtocolo: TLabel
      Left = 6
      Top = 14
      Width = 139
      Height = 13
      Caption = 'Protocolo do banco de dados'
      Color = clGreen
      ParentColor = False
      Transparent = True
    end
    object LabelNomeDoBanco: TLabel
      Left = 151
      Top = 14
      Width = 121
      Height = 13
      Caption = 'Nome do banco de dados'
      Color = clGreen
      ParentColor = False
      Transparent = True
    end
    object LabelPortaMySQL: TLabel
      Left = 383
      Top = 14
      Width = 26
      Height = 13
      Caption = 'Porta'
    end
    object LabelNomeDeUsuarioMySQL: TLabel
      Left = 6
      Top = 55
      Width = 80
      Height = 13
      Caption = 'Nome do usu'#225'rio'
      Color = clGreen
      ParentColor = False
      Transparent = True
    end
    object LabelSenhaMySQL: TLabel
      Left = 223
      Top = 55
      Width = 30
      Height = 13
      Caption = 'Senha'
    end
    object ComboBoxProtocolo: TComboBox
      Left = 6
      Top = 28
      Width = 139
      Height = 21
      Style = csDropDownList
      ItemHeight = 13
      TabOrder = 0
      Items.Strings = (
        'ado'
        'firebird-1.0'
        'firebird-1.5'
        'interbase-5'
        'interbase-6'
        'mssql'
        'mysql'
        'mysql-3.20'
        'mysql-3.23'
        'mysql-4.0'
        'postgresql'
        'postgresql-6.5'
        'postgresql-7.2'
        'postgresql-7.3'
        'sybase')
    end
    object EditNomeDoBanco: TEdit
      Left = 151
      Top = 28
      Width = 297
      Height = 21
      TabOrder = 1
    end
    object EditPortaMySQL: TEdit
      Left = 454
      Top = 28
      Width = 50
      Height = 21
      TabOrder = 2
    end
    object EditSenhaMySQL: TEdit
      Left = 258
      Top = 69
      Width = 246
      Height = 21
      PasswordChar = #248
      TabOrder = 3
    end
    object EditNomeDeUsuarioMySQL: TEdit
      Left = 6
      Top = 69
      Width = 246
      Height = 21
      TabOrder = 4
    end
  end
  object GroupBox2: TGroupBox
    AlignWithMargins = True
    Left = 6
    Top = 118
    Width = 510
    Height = 69
    Margins.Left = 6
    Margins.Top = 0
    Margins.Right = 6
    Margins.Bottom = 18
    Align = alTop
    Caption = ' Servidor de FTP '
    TabOrder = 1
    ExplicitLeft = 1
    ExplicitTop = 106
    object LabePortaFTP: TLabel
      Left = 6
      Top = 14
      Width = 26
      Height = 13
      Caption = 'Porta'
    end
    object Label1: TLabel
      Left = 6
      Top = 50
      Width = 297
      Height = 13
      Alignment = taCenter
      Caption = 'Para que estas altera'#231#245'es entrem em vigor, reinicie o servidor'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'Tahoma'
      Font.Style = []
      ParentFont = False
      WordWrap = True
    end
    object EditPortaFTP: TEdit
      Left = 6
      Top = 28
      Width = 50
      Height = 21
      TabOrder = 0
    end
    object LabeledEdit_TimeOut: TLabeledEdit
      Left = 62
      Top = 28
      Width = 88
      Height = 21
      EditLabel.Width = 88
      EditLabel.Height = 13
      EditLabel.Caption = 'Espera m'#225'xima (s)'
      LabelSpacing = 1
      TabOrder = 1
    end
  end
  object GroupBox3: TGroupBox
    AlignWithMargins = True
    Left = 6
    Top = 205
    Width = 510
    Height = 57
    Margins.Left = 6
    Margins.Top = 0
    Margins.Right = 6
    Align = alTop
    Caption = ' Arquivos de log '
    TabOrder = 2
    ExplicitLeft = 8
    ExplicitTop = 204
    ExplicitWidth = 440
    object Label2: TLabel
      Left = 102
      Top = 14
      Width = 237
      Height = 13
      Caption = 'Salvar log automaticamente a cada (s) [0 a 9999]'
    end
    object Edit1: TCFEdit
      Left = 195
      Top = 28
      Width = 50
      Height = 21
      Alignment = taCenter
      MaxLength = 4
      TabOrder = 0
      OnKeyPress = Edit1KeyPress
    end
  end
end
