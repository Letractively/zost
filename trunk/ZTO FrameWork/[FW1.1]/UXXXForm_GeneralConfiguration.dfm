inherited XXXForm_GeneralConfiguration: TXXXForm_GeneralConfiguration
  Caption = 'Configura'#231#245'es gerais'
  ClientHeight = 292
  ClientWidth = 359
  ExplicitWidth = 365
  ExplicitHeight = 324
  DesignSize = (
    359
    292)
  PixelsPerInch = 96
  TextHeight = 13
  inherited Panel_Header: TPanel
    Width = 359
    TabOrder = 1
    ExplicitWidth = 359
    DesignSize = (
      359
      49)
    inherited Shape_BackgroundHeader: TShape
      Width = 359
      ExplicitWidth = 359
    end
    inherited Label_DialogDescription: TLabel
      Width = 313
      Caption = 
        'Por favor preencha os campos a seguir com informa'#231#245'es corretas a' +
        'cerca da aplica'#231#227'o. Aten'#231#227'o: INFORMA'#199#213'ES ERRADAS PODEM CAUSAR MA' +
        'U FUNCIONAMENTO DO PROGRAMA.'
      ExplicitWidth = 304
    end
    inherited Shape_HeaderLine: TShape
      Width = 351
      ExplicitWidth = 351
    end
    inherited Bevel_Header: TBevel
      Width = 359
      ExplicitWidth = 359
    end
  end
  object PageControl_ConfigurationCategories: TPageControl [1]
    Left = 6
    Top = 55
    Width = 347
    Height = 193
    ActivePage = TabSheet_DataBaseOptions
    Anchors = [akLeft, akTop, akRight, akBottom]
    TabOrder = 0
    object TabSheet_DataBaseOptions: TTabSheet
      Caption = 'Op'#231#245'es do banco de dados'
      DesignSize = (
        339
        165)
      object LabelProtocolo: TLabel
        Left = 3
        Top = 0
        Width = 139
        Height = 13
        Caption = 'Protocolo do banco de dados'
        Color = clGreen
        ParentColor = False
        Transparent = True
      end
      object LabelEnderecoDoHost: TLabel
        Left = 3
        Top = 41
        Width = 84
        Height = 13
        Caption = 'Endere'#231'o do host'
        Color = clGreen
        ParentColor = False
        Transparent = True
      end
      object LabelPorta: TLabel
        Left = 284
        Top = 41
        Width = 26
        Height = 13
        Anchors = [akTop, akRight]
        Caption = 'Porta'
      end
      object LabelBancoDeDados: TLabel
        Left = 3
        Top = 82
        Width = 121
        Height = 13
        Caption = 'Nome do banco de dados'
        Color = clGreen
        ParentColor = False
        Transparent = True
      end
      object LabelNomeDeUsuario: TLabel
        Left = 3
        Top = 123
        Width = 80
        Height = 13
        Caption = 'Nome de usu'#225'rio'
        Color = clGreen
        ParentColor = False
        Transparent = True
      end
      object LabelSenha: TLabel
        Left = 173
        Top = 123
        Width = 30
        Height = 13
        Anchors = [akTop, akRight]
        Caption = 'Senha'
      end
      object LabelIsolationLevel: TLabel
        Left = 173
        Top = 0
        Width = 153
        Height = 13
        Caption = 'N'#237'vel de isolamento transacional'
      end
      object EditEnderecoDoHost: TEdit
        Left = 3
        Top = 55
        Width = 275
        Height = 21
        Anchors = [akLeft, akTop, akRight]
        TabOrder = 2
      end
      object EditPorta: TEdit
        Left = 284
        Top = 55
        Width = 52
        Height = 21
        Anchors = [akTop, akRight]
        TabOrder = 3
      end
      object EditBancoDeDados: TEdit
        Left = 3
        Top = 96
        Width = 333
        Height = 21
        Anchors = [akLeft, akTop, akRight]
        TabOrder = 4
      end
      object EditNomeDeUsuario: TEdit
        Left = 3
        Top = 137
        Width = 164
        Height = 21
        TabOrder = 5
      end
      object EditSenha: TEdit
        Left = 173
        Top = 137
        Width = 163
        Height = 21
        Anchors = [akTop, akRight]
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'Tahoma'
        Font.Style = []
        ParentFont = False
        PasswordChar = #248
        TabOrder = 6
      end
      object ComboBoxProtocolo: TComboBox
        Left = 3
        Top = 14
        Width = 164
        Height = 21
        Style = csDropDownList
        ItemHeight = 13
        TabOrder = 0
      end
      object ComboBoxIsolationLevel: TComboBox
        Left = 173
        Top = 14
        Width = 163
        Height = 21
        Style = csDropDownList
        ItemHeight = 13
        TabOrder = 1
      end
    end
    object TabSheet_LoginOptions: TTabSheet
      Caption = 'Op'#231#245'es de login'
      ImageIndex = 1
      DesignSize = (
        339
        165)
      object Label_UserTableName: TLabel
        Left = 3
        Top = 0
        Width = 133
        Height = 13
        Caption = 'Nome da tabela de usu'#225'rios'
      end
      object Label_KeyFieldName: TLabel
        Left = 173
        Top = 0
        Width = 109
        Height = 13
        Caption = 'Nome do campo-chave'
      end
      object Label_RealNameFieldName: TLabel
        Left = 3
        Top = 41
        Width = 141
        Height = 13
        Anchors = [akRight, akBottom]
        Caption = 'Nome do campo de nome real'
      end
      object Label_UserNameFieldName: TLabel
        Left = 173
        Top = 41
        Width = 116
        Height = 13
        Caption = 'Nome do campo de login'
      end
      object Label_PasswordFieldName: TLabel
        Left = 3
        Top = 82
        Width = 123
        Height = 13
        Anchors = [akRight, akBottom]
        Caption = 'Nome do campo de senha'
      end
      object Label_PasswordCipherAlgorithm: TLabel
        Left = 3
        Top = 123
        Width = 118
        Height = 13
        Caption = 'Algor'#237'tmo de criptografia'
      end
      object Label_EmailFieldName: TLabel
        Left = 173
        Top = 82
        Width = 122
        Height = 13
        Anchors = [akRight, akBottom]
        Caption = 'Nome do campo de e-mail'
      end
      object CFEdit_UserTableName: TCFEdit
        Left = 3
        Top = 14
        Width = 164
        Height = 21
        TabOrder = 0
        Text = 'CFEdit_UserTableName'
        Alignment = taCenter
      end
      object CFEdit_KeyFieldName: TCFEdit
        Left = 173
        Top = 14
        Width = 163
        Height = 21
        TabOrder = 1
        Text = 'CFEdit_KeyFieldName'
        Alignment = taCenter
      end
      object CFEdit_RealNameFieldName: TCFEdit
        Left = 3
        Top = 55
        Width = 164
        Height = 21
        TabOrder = 2
        Text = 'CFEdit_RealNameFieldName'
        Alignment = taCenter
      end
      object CFEdit_UserNameFieldName: TCFEdit
        Left = 173
        Top = 55
        Width = 163
        Height = 21
        TabOrder = 3
        Text = 'CFEdit_UserNameFieldName'
        Alignment = taCenter
      end
      object CFEdit_PasswordFieldName: TCFEdit
        Left = 3
        Top = 96
        Width = 164
        Height = 21
        TabOrder = 4
        Text = 'CFEdit_PasswordFieldName'
        Alignment = taCenter
      end
      object ComboBox_PasswordCipherAlgorithm: TComboBox
        Left = 3
        Top = 137
        Width = 164
        Height = 21
        Style = csDropDownList
        ItemHeight = 13
        TabOrder = 6
        Items.Strings = (
          'HAVAL'
          'MD2'
          'MD4'
          'MD5'
          'PANAMA'
          'RadioGat'#250'n'
          'SHA-0'
          'SHA-1'
          'SHA-2'
          'SHA-256/224'
          'SHA-512/384'
          'SHA-3'
          'RIPEMD'
          'RIPEMD-128/256'
          'RIPEMD-160/320'
          'Tiger(2)-192/160/128'
          'WHIRLPOOL')
      end
      object CheckBox_ExpandedLoginDialog: TCheckBox
        Left = 173
        Top = 135
        Width = 163
        Height = 25
        Caption = 'Exibir caixa de di'#225'logo de login em modo expandido'
        TabOrder = 7
        WordWrap = True
      end
      object CFEdit_EmailFieldName: TCFEdit
        Left = 173
        Top = 96
        Width = 163
        Height = 21
        TabOrder = 5
        Text = 'CFEdit_EmailFieldName'
        Alignment = taCenter
      end
    end
    object TabSheet_PermissionOptions: TTabSheet
      Caption = 'Op'#231#245'es de permiss'#227'o'
      ImageIndex = 3
      object Label1: TLabel
        Left = 0
        Top = 0
        Width = 252
        Height = 91
        AutoSize = False
        Caption = 
          'tabelas e campos de permiss'#227'o de usu'#225'rios e grupos nome do compo' +
          'nente zconnection principal (listar todos os que existem em Data' +
          'moduleAlpha e selecionar numa lista o principal. buscar no codig' +
          'o onde existe referencia ao ZConnections[0] do datamodule alpha ' +
          'e parametrizar'
        WordWrap = True
      end
    end
    object TabSheet_OtherOptions: TTabSheet
      Caption = 'Outras Op'#231#245'es'
      ImageIndex = 2
      object PageControl_OtherOptions: TPageControl
        Left = 3
        Top = 3
        Width = 333
        Height = 159
        ActivePage = TabSheet_GeneralBehaviour
        TabOrder = 0
        object TabSheet_GeneralBehaviour: TTabSheet
          Caption = 'Comportamento geral'
          object Label_EnterToTab: TLabel
            Left = 3
            Top = 45
            Width = 258
            Height = 13
            Caption = 'Converter ENTER em TAB para os seguintes controles'
          end
          object CheckBox_UseBalloons: TCheckBox
            Left = 3
            Top = 0
            Width = 249
            Height = 13
            Caption = 'Usar bal'#245'es para indicar erros de preenchimento'
            TabOrder = 0
          end
          object CheckListBox_EnterToTab: TCheckListBox
            Left = 3
            Top = 59
            Width = 319
            Height = 69
            IntegralHeight = True
            ItemHeight = 13
            Items.Strings = (
              'TEdit'
              'TDBEdit'
              'TCheckBox'
              'TDBCheckBox'
              'TComboBox'
              'TDBComboBox'
              'TDBLookupComboBox'
              'TListBox'
              'TDBListBox'
              'TRadioGroup'
              'TDBRadioGroup')
            TabOrder = 1
          end
          object CheckBox_UseENTERToSearch: TCheckBox
            Left = 3
            Top = 19
            Width = 262
            Height = 13
            Caption = 'Usar a tecla "ENTER" sozinha para iniciar pesquisas'
            TabOrder = 2
          end
        end
      end
    end
  end
  inherited Panel_Footer: TPanel
    Top = 254
    Width = 359
    TabOrder = 2
    ExplicitTop = 254
    ExplicitWidth = 359
    DesignSize = (
      359
      38)
    inherited Shape_FooterBackground: TShape
      Width = 359
      ExplicitWidth = 359
    end
    inherited Shape_FooterLine: TShape
      Width = 351
      ExplicitTop = 4
      ExplicitWidth = 351
    end
    inherited Shape_Organizer: TShape
      Width = 351
      ExplicitTop = 9
      ExplicitWidth = 351
    end
    inherited Bevel_Footer: TBevel
      Width = 359
      ExplicitWidth = 359
    end
    object BitBtn_Cancel: TBitBtn
      Left = 199
      Top = 9
      Width = 75
      Height = 25
      Anchors = [akRight, akBottom]
      Caption = 'Cancelar'
      TabOrder = 0
      Kind = bkCancel
      Spacing = 6
    end
    object BitBtn_Ok: TBitBtn
      Left = 280
      Top = 9
      Width = 75
      Height = 25
      Anchors = [akRight, akBottom]
      TabOrder = 1
      Kind = bkOK
    end
  end
end
