object Form_Principal: TForm_Principal
  Left = 0
  Top = 0
  BorderIcons = [biSystemMenu, biMinimize, biHelp]
  BorderStyle = bsSingle
  Caption = 'Autoitter'
  ClientHeight = 364
  ClientWidth = 794
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  Position = poMainFormCenter
  OnClose = FormClose
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object PageControl_Principal: TPageControl
    Left = 0
    Top = 0
    Width = 794
    Height = 364
    ActivePage = TabSheet_MensagensAutomaticas
    Align = alClient
    TabOrder = 0
    object TabSheet_MensagensAutomaticas: TTabSheet
      Caption = 'Mensagens Autom'#225'ticas'
      DesignSize = (
        786
        336)
      object Label_Info1: TLabel
        Left = 192
        Top = 223
        Width = 452
        Height = 13
        Anchors = [akRight, akBottom]
        Caption = 
          'Mensagens adicionadas ser'#227'o automaticamente salvas na lista quan' +
          'do o Autoitter for fechado'
      end
      object Label_CaracteresRestantesMensagemAutomatica: TLabel
        Left = 6
        Top = 223
        Width = 132
        Height = 13
        Alignment = taCenter
        Anchors = [akLeft, akBottom]
        Caption = 'Restam 140 caracteres'
        Color = clInfoBk
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clGreen
        Font.Height = -11
        Font.Name = 'Tahoma'
        Font.Style = [fsBold]
        ParentColor = False
        ParentFont = False
        Transparent = True
      end
      object Button_AdicionarMensagem: TButton
        Left = 650
        Top = 198
        Width = 130
        Height = 25
        Anchors = [akRight, akBottom]
        Caption = 'Adicionar mensagem'
        TabOrder = 0
        OnClick = Button_AdicionarMensagemClick
      end
      object Edit_AdicionarMensagem: TEdit
        Left = 6
        Top = 198
        Width = 638
        Height = 25
        Anchors = [akLeft, akRight, akBottom]
        AutoSize = False
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -15
        Font.Name = 'Tahoma'
        Font.Style = []
        MaxLength = 140
        ParentFont = False
        TabOrder = 1
        OnChange = Edit_AdicionarMensagemChange
        OnKeyPress = Edit_AdicionarMensagemKeyPress
      end
      object Panel_MensagensAutomaticas: TPanel
        AlignWithMargins = True
        Left = 6
        Top = 6
        Width = 774
        Height = 186
        Margins.Left = 6
        Margins.Top = 6
        Margins.Right = 6
        Align = alTop
        Anchors = [akLeft, akTop, akRight, akBottom]
        BevelOuter = bvNone
        TabOrder = 2
        object ListBox_ListaDeMensagens: TListBox
          AlignWithMargins = True
          Left = 0
          Top = 0
          Width = 638
          Height = 186
          Margins.Left = 0
          Margins.Top = 0
          Margins.Right = 6
          Margins.Bottom = 0
          Align = alClient
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'Tahoma'
          Font.Style = []
          IntegralHeight = True
          ItemHeight = 13
          MultiSelect = True
          ParentFont = False
          TabOrder = 0
        end
        object Panel_BotoesMensagensAutomaticas: TPanel
          Left = 644
          Top = 0
          Width = 130
          Height = 186
          Align = alRight
          BevelOuter = bvNone
          TabOrder = 1
          object Button_AtivarAutoitter: TButton
            Left = 0
            Top = 161
            Width = 130
            Height = 25
            Align = alBottom
            Caption = 'Ativar Autoitter'
            TabOrder = 0
            OnClick = Button_AtivarAutoitterClick
          end
          object Button_CarregarMensagens: TButton
            Left = 0
            Top = 0
            Width = 130
            Height = 25
            Align = alTop
            Caption = 'Carregar mensagens...'
            TabOrder = 1
            OnClick = Button_CarregarMensagensClick
          end
          object Button_RemoverMensagem: TButton
            Left = 0
            Top = 25
            Width = 130
            Height = 25
            Align = alTop
            Caption = 'Remover Mensagens'
            TabOrder = 2
            OnClick = Button_RemoverMensagemClick
          end
          object Button_LimparLista: TButton
            Left = 0
            Top = 50
            Width = 130
            Height = 25
            Align = alTop
            Caption = 'Limpar lista'
            TabOrder = 3
            OnClick = Button_LimparListaClick
          end
        end
      end
      object GroupBox_InfoUsuario: TGroupBox
        AlignWithMargins = True
        Left = 6
        Top = 242
        Width = 774
        Height = 69
        Margins.Left = 6
        Margins.Right = 6
        Margins.Bottom = 6
        Align = alBottom
        Caption = 
          ' Informa'#231#245'es do usu'#225'rio (Mensagens ser'#227'o enviadas por meio deste' +
          ' usu'#225'rio) '
        TabOrder = 3
        object Bevel1: TBevel
          Left = 324
          Top = 14
          Width = 17
          Height = 48
          Shape = bsLeftLine
        end
        object Label_UserID: TLabel
          Left = 58
          Top = 14
          Width = 91
          Height = 16
          Caption = 'ID do usu'#225'rio:'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -13
          Font.Name = 'Tahoma'
          Font.Style = [fsBold]
          ParentFont = False
        end
        object Label_ScreenName: TLabel
          Left = 58
          Top = 30
          Width = 116
          Height = 16
          Caption = 'Nome de exibi'#231#227'o:'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -13
          Font.Name = 'Tahoma'
          Font.Style = [fsBold]
          ParentFont = False
        end
        object Label_UserIDValor: TLabel
          Left = 152
          Top = 14
          Width = 28
          Height = 16
          Caption = '????'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clRed
          Font.Height = -13
          Font.Name = 'Tahoma'
          Font.Style = [fsBold]
          ParentFont = False
        end
        object Label_ScreenNameValor: TLabel
          Left = 177
          Top = 30
          Width = 28
          Height = 16
          Caption = '????'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clRed
          Font.Height = -13
          Font.Name = 'Tahoma'
          Font.Style = [fsBold]
          ParentFont = False
        end
        object Label_UserName: TLabel
          Left = 58
          Top = 46
          Width = 69
          Height = 16
          Caption = 'Nome real:'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -13
          Font.Name = 'Tahoma'
          Font.Style = [fsBold]
          ParentFont = False
        end
        object Label_UserNameValor: TLabel
          Left = 130
          Top = 46
          Width = 28
          Height = 16
          Caption = '????'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clRed
          Font.Height = -13
          Font.Name = 'Tahoma'
          Font.Style = [fsBold]
          ParentFont = False
        end
        object Label_Location: TLabel
          Left = 331
          Top = 14
          Width = 79
          Height = 16
          Caption = 'Localiza'#231#227'o:'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -13
          Font.Name = 'Tahoma'
          Font.Style = [fsBold]
          ParentFont = False
        end
        object Label_LocationValor: TLabel
          Left = 413
          Top = 14
          Width = 28
          Height = 16
          Caption = '????'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clRed
          Font.Height = -13
          Font.Name = 'Tahoma'
          Font.Style = [fsBold]
          ParentFont = False
        end
        object Label_Followers: TLabel
          Left = 331
          Top = 30
          Width = 77
          Height = 16
          Caption = 'Seguidores:'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -13
          Font.Name = 'Tahoma'
          Font.Style = [fsBold]
          ParentFont = False
        end
        object Label_FollowersValor: TLabel
          Left = 411
          Top = 30
          Width = 28
          Height = 16
          Caption = '????'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clRed
          Font.Height = -13
          Font.Name = 'Tahoma'
          Font.Style = [fsBold]
          ParentFont = False
        end
        object Label_Friends: TLabel
          Left = 331
          Top = 46
          Width = 64
          Height = 16
          Caption = 'Seguindo:'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -13
          Font.Name = 'Tahoma'
          Font.Style = [fsBold]
          ParentFont = False
        end
        object Label_FriendsValor: TLabel
          Left = 398
          Top = 46
          Width = 28
          Height = 16
          Caption = '????'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clRed
          Font.Height = -13
          Font.Name = 'Tahoma'
          Font.Style = [fsBold]
          ParentFont = False
        end
        object Image_UserImage: TImage
          Left = 7
          Top = 14
          Width = 48
          Height = 48
          Center = True
          Proportional = True
        end
      end
      object StatusBar_MensagensAutomaticas: TStatusBar
        Left = 0
        Top = 317
        Width = 786
        Height = 19
        Panels = <>
      end
    end
    object TabSheet_MensagensAvulsas: TTabSheet
      Caption = 'Mensagens avulsas'
      ImageIndex = 3
      object Label_CaracteresRestantesMensagemAvulsa: TLabel
        Left = 6
        Top = 31
        Width = 132
        Height = 13
        Alignment = taCenter
        Caption = 'Restam 140 caracteres'
        Color = clInfoBk
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clGreen
        Font.Height = -11
        Font.Name = 'Tahoma'
        Font.Style = [fsBold]
        ParentColor = False
        ParentFont = False
        Transparent = True
      end
      object StatusBar1: TStatusBar
        Left = 0
        Top = 317
        Width = 786
        Height = 19
        Panels = <>
      end
      object Panel1: TPanel
        AlignWithMargins = True
        Left = 6
        Top = 6
        Width = 774
        Height = 25
        Margins.Left = 6
        Margins.Top = 6
        Margins.Right = 6
        Align = alTop
        Anchors = [akLeft, akTop, akRight, akBottom]
        BevelOuter = bvNone
        TabOrder = 1
        object Panel2: TPanel
          Left = 644
          Top = 0
          Width = 130
          Height = 25
          Align = alRight
          BevelOuter = bvNone
          TabOrder = 0
          object Button_EnviarMensagem: TButton
            Left = 0
            Top = 0
            Width = 130
            Height = 25
            Align = alTop
            Caption = 'Enviar'
            TabOrder = 0
            OnClick = Button_EnviarMensagemClick
          end
        end
        object Edit_MensagemAvulsa: TEdit
          AlignWithMargins = True
          Left = 0
          Top = 0
          Width = 638
          Height = 25
          Margins.Left = 0
          Margins.Top = 0
          Margins.Right = 6
          Margins.Bottom = 0
          Align = alClient
          AutoSize = False
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -15
          Font.Name = 'Tahoma'
          Font.Style = []
          MaxLength = 140
          ParentFont = False
          TabOrder = 1
          OnChange = Edit_MensagemAvulsaChange
          OnKeyPress = Edit_AdicionarMensagemKeyPress
        end
      end
    end
    object TabSheet_Configuracoes: TTabSheet
      Caption = 'Configura'#231#245'es'
      ImageIndex = 1
      object GroupBox_Proxy: TGroupBox
        AlignWithMargins = True
        Left = 4
        Top = 0
        Width = 776
        Height = 57
        Margins.Left = 4
        Margins.Top = 0
        Margins.Right = 6
        Margins.Bottom = 1
        Align = alTop
        Caption = ' Proxy '
        TabOrder = 0
        object Label_TipoDeAutenticacao: TLabel
          Left = 226
          Top = 13
          Width = 100
          Height = 13
          Caption = 'Tipo de autentica'#231#227'o'
        end
        object LabeledEdit_Proxy: TLabeledEdit
          Left = 8
          Top = 27
          Width = 154
          Height = 21
          EditLabel.Width = 40
          EditLabel.Height = 13
          EditLabel.Caption = 'Servidor'
          LabelSpacing = 1
          TabOrder = 0
        end
        object ComboBox_ProxyAuth: TComboBox
          Left = 226
          Top = 27
          Width = 144
          Height = 21
          Style = csDropDownList
          ItemHeight = 13
          TabOrder = 1
        end
        object LabeledEdit_ProxyPort: TLabeledEdit
          Left = 168
          Top = 27
          Width = 52
          Height = 21
          EditLabel.Width = 26
          EditLabel.Height = 13
          EditLabel.Caption = 'Porta'
          LabelSpacing = 1
          TabOrder = 2
        end
        object LabeledEdit_ProxyUsername: TLabeledEdit
          Left = 509
          Top = 27
          Width = 127
          Height = 21
          EditLabel.Width = 36
          EditLabel.Height = 13
          EditLabel.Caption = 'Usu'#225'rio'
          LabelSpacing = 1
          TabOrder = 3
        end
        object LabeledEdit_ProxyPassword: TLabeledEdit
          Left = 642
          Top = 27
          Width = 127
          Height = 21
          EditLabel.Width = 30
          EditLabel.Height = 13
          EditLabel.Caption = 'Senha'
          LabelSpacing = 1
          TabOrder = 4
        end
        object LabeledEdit_ProxyConnection: TLabeledEdit
          Left = 376
          Top = 27
          Width = 127
          Height = 21
          EditLabel.Width = 43
          EditLabel.Height = 13
          EditLabel.Caption = 'Conex'#227'o'
          LabelSpacing = 1
          TabOrder = 5
        end
      end
      object Button_SalvarConfiguracoes: TButton
        Left = 4
        Top = 121
        Width = 126
        Height = 25
        Caption = 'Salvar Configura'#231#245'es'
        TabOrder = 1
        OnClick = Button_SalvarConfiguracoesClick
      end
      object GroupBox_Twitter: TGroupBox
        AlignWithMargins = True
        Left = 4
        Top = 58
        Width = 776
        Height = 57
        Margins.Left = 4
        Margins.Top = 0
        Margins.Right = 6
        Align = alTop
        Caption = ' Autoitter '
        TabOrder = 2
        object LabeledEdit_IntervaloEntreTweets: TLabeledEdit
          Left = 8
          Top = 27
          Width = 127
          Height = 21
          EditLabel.Width = 127
          EditLabel.Height = 13
          EditLabel.Caption = 'Intervalo entre Tweets (s)'
          LabelSpacing = 1
          NumbersOnly = True
          TabOrder = 0
        end
      end
    end
    object TabSheet_Sobre: TTabSheet
      Caption = 'Sobre o Autoitter'
      ImageIndex = 2
      object Label1: TLabel
        Left = 0
        Top = 0
        Width = 786
        Height = 26
        Align = alTop
        Alignment = taCenter
        Caption = 
          'Desenvolvido por Carlos Barreto Feitoza Filho em maio de 2011. '#201 +
          ' claro que eu tenho os fontes. Caso voc'#234' queira, vai ter que imp' +
          'lorar. N'#227'o forne'#231'o fontes a programadores Java e ponto final.'
        WordWrap = True
        ExplicitWidth = 758
      end
    end
  end
  object Twitter_Acesso: TTwitter
    OnTwitterRequestDone = Twitter_AcessoTwitterRequestDone
    ProxyAuth = httpAuthNone
    ProxyPort = '80'
    Left = 176
    Top = 192
  end
  object OpenDialog_Mensagens: TOpenDialog
    DefaultExt = 'txt'
    Filter = 'Arquivo de mensagens (*.txt)|*.txt'
    Options = [ofReadOnly, ofHideReadOnly, ofExtensionDifferent, ofPathMustExist, ofFileMustExist, ofEnableSizing]
    Left = 224
    Top = 192
  end
end
