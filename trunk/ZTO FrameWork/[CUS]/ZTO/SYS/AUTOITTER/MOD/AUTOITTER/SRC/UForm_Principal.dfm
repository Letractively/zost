object Form_Principal: TForm_Principal
  Left = 0
  Top = 0
  Caption = 'Autoitter'
  ClientHeight = 282
  ClientWidth = 784
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  Position = poMainFormCenter
  PixelsPerInch = 96
  TextHeight = 13
  object PageControl_Principal: TPageControl
    Left = 0
    Top = 0
    Width = 784
    Height = 282
    ActivePage = TabSheet_MensagensAutomaticas
    Align = alClient
    TabOrder = 0
    object TabSheet_MensagensAutomaticas: TTabSheet
      Caption = 'Mensagens Autom'#225'ticas'
      ExplicitLeft = 8
      ExplicitTop = 28
      DesignSize = (
        776
        254)
      object Label_Info1: TLabel
        Left = 182
        Top = 134
        Width = 452
        Height = 13
        Anchors = [akTop, akRight]
        Caption = 
          'Mensagens adicionadas ser'#227'o automaticamente salvas na lista quan' +
          'do o Autoitter for fechado'
        ExplicitLeft = 204
      end
      object Label_CaracteresRestantes: TLabel
        Left = 6
        Top = 134
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
      object Button_AdicionarMensagem: TButton
        Left = 640
        Top = 109
        Width = 130
        Height = 25
        Anchors = [akTop, akRight]
        Caption = 'Adicionar mensagem'
        TabOrder = 0
      end
      object Edit_AdicionarMensagem: TEdit
        Left = 6
        Top = 109
        Width = 628
        Height = 25
        Anchors = [akLeft, akTop, akRight]
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
      end
      object Panel_MensagensAutomaticas: TPanel
        AlignWithMargins = True
        Left = 6
        Top = 6
        Width = 764
        Height = 97
        Margins.Left = 6
        Margins.Top = 6
        Margins.Right = 6
        Align = alTop
        BevelOuter = bvNone
        TabOrder = 2
        object ListBox_ListaDeMensagens: TListBox
          AlignWithMargins = True
          Left = 0
          Top = 0
          Width = 628
          Height = 97
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
          ItemHeight = 13
          ParentFont = False
          TabOrder = 0
          ExplicitLeft = 31
          ExplicitTop = 6
          ExplicitWidth = 90
          ExplicitHeight = 32
        end
        object Panel_BotoesMensagensAutomaticas: TPanel
          Left = 634
          Top = 0
          Width = 130
          Height = 97
          Align = alRight
          BevelOuter = bvNone
          TabOrder = 1
          ExplicitLeft = 637
          object Button_AtivarAutoitter: TButton
            Left = 0
            Top = 72
            Width = 130
            Height = 25
            Align = alBottom
            Caption = 'Ativar Autoitter'
            TabOrder = 0
            ExplicitTop = 0
          end
          object Button_CarregarMensagens: TButton
            Left = 0
            Top = 0
            Width = 130
            Height = 25
            Align = alTop
            Caption = 'Carregar mensagens...'
            TabOrder = 1
          end
        end
      end
      object GroupBox_InfoUsuario: TGroupBox
        Left = 6
        Top = 153
        Width = 763
        Height = 95
        Caption = 
          ' Informa'#231#245'es do usu'#225'rio (Mensagens ser'#227'o enviadas por meio deste' +
          ' usu'#225'rio) '
        TabOrder = 3
      end
    end
    object TabSheet_MensagensAvulsas: TTabSheet
      Caption = 'Mensagens avulsas'
      ImageIndex = 3
      ExplicitLeft = -36
      ExplicitTop = 28
    end
    object TabSheet_Configuracoes: TTabSheet
      Caption = 'Configura'#231#245'es'
      ImageIndex = 1
    end
    object TabSheet_Sobre: TTabSheet
      Caption = 'Sobre o Autoitter'
      ImageIndex = 2
    end
  end
end
