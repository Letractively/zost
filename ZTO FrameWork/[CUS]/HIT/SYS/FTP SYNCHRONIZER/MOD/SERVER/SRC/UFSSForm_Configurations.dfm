object FSSForm_Configurations: TFSSForm_Configurations
  Left = 0
  Top = 0
  BorderStyle = bsDialog
  Caption = 'Dados para acesso'
  ClientHeight = 225
  ClientWidth = 451
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
    Left = 6
    Top = 3
    Width = 440
    Height = 97
    Caption = ' MySQL Local (mysql@localhost) '
    TabOrder = 0
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
      Width = 226
      Height = 21
      TabOrder = 1
    end
    object EditPortaMySQL: TEdit
      Left = 383
      Top = 28
      Width = 50
      Height = 21
      TabOrder = 2
    end
    object EditSenhaMySQL: TEdit
      Left = 223
      Top = 69
      Width = 210
      Height = 21
      PasswordChar = #248
      TabOrder = 3
    end
    object EditNomeDeUsuarioMySQL: TEdit
      Left = 6
      Top = 69
      Width = 209
      Height = 21
      TabOrder = 4
    end
  end
  object GroupBox2: TGroupBox
    Left = 6
    Top = 103
    Width = 440
    Height = 57
    Caption = ' Servidor de FTP '
    TabOrder = 1
    object LabePortaFTP: TLabel
      Left = 6
      Top = 14
      Width = 26
      Height = 13
      Caption = 'Porta'
    end
    object Label1: TLabel
      Left = 108
      Top = 17
      Width = 300
      Height = 31
      Alignment = taCenter
      AutoSize = False
      Caption = 
        'Para que a altera'#231#227'o da porta tenha efeito, reinicie o servidor ' +
        '(menu Servidor/Desativar e depois menu Servidor/Ativar)'
      WordWrap = True
    end
    object EditPortaFTP: TEdit
      Left = 6
      Top = 28
      Width = 50
      Height = 21
      TabOrder = 0
    end
  end
  object GroupBox3: TGroupBox
    Left = 6
    Top = 163
    Width = 440
    Height = 57
    Caption = ' Arquivos de log '
    TabOrder = 2
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
      MaxLength = 4
      TabOrder = 0
      OnKeyPress = Edit1KeyPress
      Alignment = taCenter
    end
  end
end
