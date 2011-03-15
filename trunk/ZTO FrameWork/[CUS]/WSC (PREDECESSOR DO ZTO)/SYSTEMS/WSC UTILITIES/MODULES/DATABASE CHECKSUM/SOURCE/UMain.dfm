object Form1: TForm1
  Left = 0
  Top = 0
  Caption = 'Form1'
  ClientHeight = 580
  ClientWidth = 543
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  OnCreate = FormCreate
  DesignSize = (
    543
    580)
  PixelsPerInch = 96
  TextHeight = 13
  object Label_Customers: TLabel
    Left = 8
    Top = 6
    Width = 38
    Height = 13
    Caption = 'Clientes'
  end
  object Label1: TLabel
    Left = 8
    Top = 551
    Width = 527
    Height = 21
    Alignment = taCenter
    Anchors = [akLeft, akRight, akBottom]
    AutoSize = False
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -16
    Font.Name = 'Tahoma'
    Font.Style = [fsBold]
    ParentFont = False
    ExplicitTop = 406
  end
  object ListBox_Customers: TListBox
    Left = 8
    Top = 19
    Width = 527
    Height = 56
    Anchors = [akLeft, akTop, akRight]
    Columns = 3
    IntegralHeight = True
    ItemHeight = 13
    Items.Strings = (
      'Hitachi Ar Condicionado do Brasil')
    TabOrder = 0
    OnClick = ListBox_CustomersClick
  end
  object GroupBox1: TGroupBox
    Left = 8
    Top = 78
    Width = 527
    Height = 56
    Caption = ' Par'#226'metros de conex'#227'o '
    TabOrder = 1
    object LabeledEdit_BancoDeDados: TLabeledEdit
      Left = 8
      Top = 27
      Width = 116
      Height = 21
      EditLabel.Width = 76
      EditLabel.Height = 13
      EditLabel.Caption = 'Banco de dados'
      LabelSpacing = 1
      TabOrder = 0
    end
    object LabeledEdit_HostName: TLabeledEdit
      Left = 130
      Top = 27
      Width = 110
      Height = 21
      EditLabel.Width = 22
      EditLabel.Height = 13
      EditLabel.Caption = 'Host'
      LabelSpacing = 1
      TabOrder = 1
    end
    object LabeledEdit_Login: TLabeledEdit
      Left = 374
      Top = 27
      Width = 70
      Height = 21
      EditLabel.Width = 25
      EditLabel.Height = 13
      EditLabel.Caption = 'Login'
      LabelSpacing = 1
      TabOrder = 2
    end
    object LabeledEdit_Password: TLabeledEdit
      Left = 450
      Top = 27
      Width = 70
      Height = 21
      EditLabel.Width = 30
      EditLabel.Height = 13
      EditLabel.Caption = 'Senha'
      LabelSpacing = 1
      TabOrder = 3
    end
    object LabeledEdit_Port: TLabeledEdit
      Left = 246
      Top = 27
      Width = 42
      Height = 21
      EditLabel.Width = 26
      EditLabel.Height = 13
      EditLabel.Caption = 'Porta'
      LabelSpacing = 1
      TabOrder = 4
    end
    object LabeledEdit_Protocol: TLabeledEdit
      Left = 294
      Top = 27
      Width = 74
      Height = 21
      EditLabel.Width = 45
      EditLabel.Height = 13
      EditLabel.Caption = 'Protocolo'
      LabelSpacing = 1
      TabOrder = 5
    end
  end
  object Button_GetChecksum: TButton
    Left = 8
    Top = 140
    Width = 527
    Height = 25
    Anchors = [akLeft, akTop, akRight]
    Caption = 'Obter checksum das tabelas do banco de dados'
    TabOrder = 2
    OnClick = Button_GetChecksumClick
  end
  object Memo1: TMemo
    Left = 8
    Top = 171
    Width = 527
    Height = 374
    Anchors = [akLeft, akTop, akRight, akBottom]
    ReadOnly = True
    ScrollBars = ssVertical
    TabOrder = 3
  end
end
