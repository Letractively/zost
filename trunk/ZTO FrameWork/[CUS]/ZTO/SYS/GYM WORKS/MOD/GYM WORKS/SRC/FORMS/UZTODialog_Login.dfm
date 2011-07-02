inherited ZTODialog_Login: TZTODialog_Login
  Caption = 'Acesso restrito!'
  ClientHeight = 310
  ClientWidth = 354
  Position = poScreenCenter
  ZTOProperties.DialogDescription = 
    'Para ter acesso a esta aplica'#231#227'o voc'#234' tem de ser um usu'#225'rio auto' +
    'rizado. Digite ou escolha seu nome de usu'#225'rio e informe sua senh' +
    'a, clicando o bot'#227'o OK em seguida'
  ZTOProperties.VisibleButtons = [vbOk, vbCancel]
  ZTOProperties.DialogType = dtWarning
  ExplicitWidth = 360
  ExplicitHeight = 338
  PixelsPerInch = 96
  TextHeight = 13
  BorderStyle = bsDialog
  BorderIcons = [biSystemMenu, biHelp]
  object Label3: TLabel [0]
    Left = 127
    Top = 197
    Width = 101
    Height = 13
    Caption = 'Nome real do usu'#225'rio'
    Color = clGreen
    ParentColor = False
    Transparent = True
  end
  object DBText_USU_VA_NOME: TDBText [1]
    Left = 6
    Top = 213
    Width = 342
    Height = 17
    Alignment = taCenter
    Color = clGreen
    DataField = 'VA_NOME'
    DataSource = DataSource_USU
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'Tahoma'
    Font.Style = [fsBold]
    ParentColor = False
    ParentFont = False
    Transparent = True
  end
  object ZTODBGrid_Login: TZTODBGrid [2]
    Left = 6
    Top = 96
    Width = 342
    Height = 95
    DataSource = DataSource_USU
    DefaultDrawing = False
    Options = [dgColLines, dgRowLines, dgTabs, dgRowSelect, dgAlwaysShowSelection, dgConfirmDelete, dgCancelOnExit]
    OptionsEx = [dgAutomaticColumSizes]
    ReadOnly = True
    TabOrder = 2
    TitleFont.Charset = DEFAULT_CHARSET
    TitleFont.Color = clWindowText
    TitleFont.Height = -11
    TitleFont.Name = 'Tahoma'
    TitleFont.Style = []
    RowColors = <
      item
        BackgroundColor = clBtnFace
        ForegroundColor = clBtnText
      end>
    VariableWidthColumns = '<VA_LOGIN>'
    Columns = <
      item
        Alignment = taCenter
        Expanded = False
        FieldName = 'VA_LOGIN'
        Width = 320
        Visible = True
      end>
  end
  object LabeledEdit_USU_VA_SENHA: TLabeledEdit [3]
    Left = 6
    Top = 246
    Width = 342
    Height = 21
    Alignment = taCenter
    AutoSize = False
    EditLabel.Width = 30
    EditLabel.Height = 13
    EditLabel.Caption = 'Senha'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'Tahoma'
    Font.Style = [fsBold]
    LabelSpacing = 1
    ParentFont = False
    PasswordChar = #248
    TabOrder = 3
  end
  object LabeledEdit_USU_VA_LOGIN: TLabeledEdit [4]
    Left = 6
    Top = 69
    Width = 342
    Height = 21
    Alignment = taCenter
    EditLabel.Width = 273
    EditLabel.Height = 13
    EditLabel.Caption = 'Digite seu nome de usu'#225'rio ou selecione-o na lista abaixo'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'Tahoma'
    Font.Style = []
    LabelSpacing = 1
    ParentFont = False
    TabOrder = 4
  end
  inherited ActionList: TActionList
    Left = 275
    Top = 2
  end
  object DataSource_USU: TDataSource
    Left = 60
    Top = 144
  end
end
