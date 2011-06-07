inherited ZTODialog_Configuracoes: TZTODialog_Configuracoes
  Caption = 'Configura'#231#245'es gerais'
  ClientHeight = 439
  ClientWidth = 616
  Position = poScreenCenter
  ZTOProperties.DialogDescription = 
    'Esta caixa de di'#225'logo permite a configura'#231#227'o de diversos aspecto' +
    's da aplica'#231#227'o. Estas configura'#231#245'es somente devem ser alteradas ' +
    'por pessoal autorizado e que entenda para que cada uma delas ser' +
    've. A altera'#231#227'o incorreta das configura'#231#245'es pode levar a comport' +
    'amentos n'#227'o esperados na aplica'#231#227'o, ou mesmo perda permanente de' +
    ' dados'
  ZTOProperties.VisibleButtons = [vbOk, vbCancel]
  ZTOProperties.DialogType = dtInformation
  OnCreate = ZTODialogCreate
  ExplicitWidth = 622
  ExplicitHeight = 467
  PixelsPerInch = 96
  TextHeight = 13
  BorderStyle = bsDialog
  BorderIcons = [biSystemMenu, biHelp]
  object PageControl_ConfigurationCategories: TPageControl [0]
    AlignWithMargins = True
    Left = 6
    Top = 55
    Width = 604
    Height = 340
    Margins.Left = 6
    Margins.Top = 6
    Margins.Right = 6
    Margins.Bottom = 6
    ActivePage = TabSheet_DataBaseOptions
    Align = alClient
    TabOrder = 2
    object TabSheet_DataBaseOptions: TTabSheet
      Caption = 'Op'#231#245'es do banco de dados'
      DesignSize = (
        596
        312)
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
      object LabelIsolationLevel: TLabel
        Left = 428
        Top = 0
        Width = 153
        Height = 13
        Anchors = [akTop, akRight]
        Caption = 'N'#237'vel de isolamento transacional'
        ExplicitLeft = 419
      end
      object LabeledEdit_DBHost: TLabeledEdit
        Left = 3
        Top = 55
        Width = 530
        Height = 21
        Anchors = [akLeft, akTop, akRight]
        EditLabel.Width = 84
        EditLabel.Height = 13
        EditLabel.Caption = 'Endere'#231'o do host'
        LabelSpacing = 1
        TabOrder = 2
      end
      object LabeledEdit_DBPorta: TLabeledEdit
        Left = 539
        Top = 55
        Width = 52
        Height = 21
        Anchors = [akTop, akRight]
        EditLabel.Width = 26
        EditLabel.Height = 13
        EditLabel.Caption = 'Porta'
        LabelSpacing = 1
        TabOrder = 3
      end
      object LabeledEdit_DBEsquema: TLabeledEdit
        Left = 3
        Top = 96
        Width = 588
        Height = 21
        Anchors = [akLeft, akTop, akRight]
        EditLabel.Width = 121
        EditLabel.Height = 13
        EditLabel.Caption = 'Nome do banco de dados'
        LabelSpacing = 1
        TabOrder = 4
      end
      object LabeledEdit_DBUsuario: TLabeledEdit
        Left = 3
        Top = 137
        Width = 291
        Height = 21
        EditLabel.Width = 80
        EditLabel.Height = 13
        EditLabel.Caption = 'Nome de usu'#225'rio'
        LabelSpacing = 1
        TabOrder = 5
      end
      object LabeledEdit_DBSenha: TLabeledEdit
        Left = 300
        Top = 137
        Width = 291
        Height = 21
        Anchors = [akTop, akRight]
        EditLabel.Width = 30
        EditLabel.Height = 13
        EditLabel.Caption = 'Senha'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'Tahoma'
        Font.Style = []
        LabelSpacing = 1
        ParentFont = False
        PasswordChar = #248
        TabOrder = 6
      end
      object ComboBox_Protocolo: TComboBox
        Left = 3
        Top = 14
        Width = 164
        Height = 21
        Style = csDropDownList
        ItemHeight = 13
        TabOrder = 0
      end
      object ComboBox_IsolationLevel: TComboBox
        Left = 428
        Top = 14
        Width = 163
        Height = 21
        Style = csDropDownList
        Anchors = [akTop, akRight]
        ItemHeight = 13
        TabOrder = 1
      end
    end
    object TabSheet_LoginOptions: TTabSheet
      Caption = 'Op'#231#245'es de login'
      ImageIndex = 1
      ExplicitLeft = 0
      ExplicitTop = 0
      ExplicitWidth = 0
      ExplicitHeight = 0
      DesignSize = (
        596
        312)
      object Label_PasswordCipherAlgorithm: TLabel
        Left = 300
        Top = 82
        Width = 118
        Height = 13
        Caption = 'Algor'#237'tmo de criptografia'
      end
      object LabeledEdit_TabelaDeUsuarios: TLabeledEdit
        Left = 3
        Top = 14
        Width = 291
        Height = 21
        EditLabel.Width = 90
        EditLabel.Height = 13
        EditLabel.Caption = 'Tabela de usu'#225'rios'
        LabelSpacing = 1
        TabOrder = 0
        Text = 'LabeledEdit_TabelaDeUsuarios'
      end
      object LabeledEdit_CampoChave: TLabeledEdit
        Left = 300
        Top = 14
        Width = 291
        Height = 21
        Anchors = [akTop, akRight]
        EditLabel.Width = 171
        EditLabel.Height = 13
        EditLabel.Caption = 'Campo chave da tabela de usu'#225'rios'
        LabelSpacing = 1
        TabOrder = 1
        Text = 'LabeledEdit_CampoChave'
      end
      object LabeledEdit_CampoNomeReal: TLabeledEdit
        Left = 3
        Top = 55
        Width = 291
        Height = 21
        EditLabel.Width = 92
        EditLabel.Height = 13
        EditLabel.Caption = 'Campo "Nome real"'
        LabelSpacing = 1
        TabOrder = 2
        Text = 'LabeledEdit_CampoNomeReal'
      end
      object LabeledEdit_CampoNomeDeUsuario: TLabeledEdit
        Left = 300
        Top = 55
        Width = 291
        Height = 21
        Anchors = [akTop, akRight]
        EditLabel.Width = 124
        EditLabel.Height = 13
        EditLabel.Caption = 'Campo "Nome de usu'#225'rio"'
        LabelSpacing = 1
        TabOrder = 3
        Text = 'LabeledEdit_CampoNomeDeUsuario'
      end
      object LabeledEdit_CampoSenha: TLabeledEdit
        Left = 3
        Top = 96
        Width = 291
        Height = 21
        EditLabel.Width = 74
        EditLabel.Height = 13
        EditLabel.Caption = 'Campo "Senha"'
        LabelSpacing = 1
        TabOrder = 4
        Text = 'LabeledEdit_CampoSenha'
      end
      object ComboBox_AlgoritmoDeCriptografia: TComboBox
        Left = 300
        Top = 96
        Width = 291
        Height = 21
        Style = csDropDownList
        ItemHeight = 0
        TabOrder = 5
      end
      object CheckBox_ExpandedLoginDialog: TCheckBox
        Left = 3
        Top = 123
        Width = 163
        Height = 25
        Caption = 'Exibir caixa de di'#225'logo de login em modo expandido'
        TabOrder = 6
        Visible = False
        WordWrap = True
      end
    end
    object TabSheet_PermissionOptions: TTabSheet
      Caption = 'Op'#231#245'es de permiss'#227'o'
      ImageIndex = 3
      ExplicitLeft = 0
      ExplicitTop = 0
      ExplicitWidth = 0
      ExplicitHeight = 0
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
      ExplicitLeft = 0
      ExplicitTop = 0
      ExplicitWidth = 0
      ExplicitHeight = 0
      object PageControl_OtherOptions: TPageControl
        Left = 3
        Top = 3
        Width = 333
        Height = 159
        ActivePage = TabSheet_GeneralBehaviour
        TabOrder = 0
        object TabSheet_GeneralBehaviour: TTabSheet
          Caption = 'Comportamento geral'
          ExplicitLeft = 0
          ExplicitTop = 0
          ExplicitWidth = 0
          ExplicitHeight = 0
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
  inherited ActionList: TActionList
    Left = 656
  end
end
