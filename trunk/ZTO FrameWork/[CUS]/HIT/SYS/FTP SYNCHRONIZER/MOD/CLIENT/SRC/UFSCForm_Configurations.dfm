object FSCForm_Configurations: TFSCForm_Configurations
  Left = 0
  Top = 0
  BorderStyle = bsDialog
  Caption = 'Dados para acesso'
  ClientHeight = 264
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
      TabOrder = 4
    end
    object EditNomeDeUsuarioMySQL: TEdit
      Left = 6
      Top = 69
      Width = 209
      Height = 21
      TabOrder = 3
    end
  end
  object GroupBox2: TGroupBox
    Left = 6
    Top = 103
    Width = 440
    Height = 97
    Caption = ' Servidor de FTP '
    TabOrder = 1
    object LabelEnderecoDoServidor: TLabel
      Left = 6
      Top = 14
      Width = 102
      Height = 13
      Caption = 'Endere'#231'o do servidor'
      Color = clGreen
      ParentColor = False
      Transparent = True
    end
    object LabePortaFTP: TLabel
      Left = 383
      Top = 14
      Width = 26
      Height = 13
      Caption = 'Porta'
    end
    object LabelNomeDeUsuarioFTP: TLabel
      Left = 6
      Top = 55
      Width = 80
      Height = 13
      Caption = 'Nome do usu'#225'rio'
      Color = clGreen
      ParentColor = False
      Transparent = True
    end
    object LabelSenhaFTP: TLabel
      Left = 223
      Top = 55
      Width = 30
      Height = 13
      Caption = 'Senha'
    end
    object EditEnderecoDoServidor: TEdit
      Left = 6
      Top = 28
      Width = 372
      Height = 21
      TabOrder = 0
    end
    object EditPortaFTP: TEdit
      Left = 383
      Top = 28
      Width = 50
      Height = 21
      TabOrder = 1
    end
    object EditSenhaFTP: TEdit
      Left = 223
      Top = 69
      Width = 210
      Height = 21
      PasswordChar = #248
      TabOrder = 3
    end
    object EditNomeDeUsuarioFTP: TEdit
      Left = 6
      Top = 69
      Width = 209
      Height = 21
      TabOrder = 2
    end
  end
  object GroupBox_ConfiguracoesGerais: TGroupBox
    Left = 6
    Top = 203
    Width = 440
    Height = 56
    Caption = ' Cliente de FTP '
    TabOrder = 2
    object CheckBox_ModoPassivo: TCheckBox
      Left = 194
      Top = 36
      Width = 82
      Height = 13
      Caption = 'Modo passivo'
      TabOrder = 3
    end
    object LabeledEdit_DelayDeComandos: TLabeledEdit
      Left = 6
      Top = 28
      Width = 182
      Height = 21
      EditLabel.Width = 182
      EditLabel.Height = 13
      EditLabel.Caption = 'Atraso de comandos (0 = sem atraso)'
      LabelSpacing = 1
      TabOrder = 0
    end
    object CheckBox_VerboseMode: TCheckBox
      Left = 194
      Top = 13
      Width = 94
      Height = 17
      Caption = 'Modo detalhado'
      TabOrder = 1
    end
    object CheckBox_ChecarMD5: TCheckBox
      Left = 294
      Top = 13
      Width = 108
      Height = 13
      Caption = 'Verifica'#231#227'o de MD5'
      TabOrder = 2
    end
    object CheckBox_Compressao: TCheckBox
      Left = 294
      Top = 36
      Width = 99
      Height = 13
      Caption = 'Usar compress'#227'o'
      TabOrder = 4
    end
  end
end
