object XXXForm_MainTabbedTemplate: TXXXForm_MainTabbedTemplate
  Left = 0
  Top = 0
  Caption = 'Meu t'#237'tulo n'#227'o foi setado!'
  ClientHeight = 463
  ClientWidth = 702
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  WindowState = wsMaximized
  OnCloseQuery = DoCloseQuery
  OnCreate = DoCreate
  OnShow = DoShow
  DesignSize = (
    702
    463)
  PixelsPerInch = 96
  TextHeight = 13
  object StatusBar_Main: TStatusBar
    Left = 0
    Top = 444
    Width = 702
    Height = 19
    AutoHint = True
    Panels = <
      item
        Alignment = taCenter
        Bevel = pbRaised
        Text = 'Nenhum m'#243'dulo em execu'#231#227'o'
        Width = 180
      end
      item
        Width = 50
      end>
    OnMouseDown = StatusBar_MainMouseDown
  end
  object ProgressBar_ModuleLoad: TProgressBar
    Left = 3
    Top = 448
    Width = 174
    Height = 13
    Anchors = [akLeft, akBottom]
    Position = 50
    Step = 1
    TabOrder = 1
    Visible = False
  end
  object Panel_MainBackground: TPanel
    Left = 0
    Top = 52
    Width = 702
    Height = 392
    Align = alClient
    BevelOuter = bvNone
    Color = clAppWorkSpace
    TabOrder = 2
    OnResize = DoPanel_MainBackgroundResize
    DesignSize = (
      702
      392)
    object Shape_MainBackground: TShape
      Left = 0
      Top = 0
      Width = 702
      Height = 392
      Align = alClient
      Brush.Color = clAppWorkSpace
      Pen.Style = psClear
      ExplicitLeft = 2
      ExplicitTop = 2
      ExplicitWidth = 700
      ExplicitHeight = 390
    end
    object Image_MainBackground: TImage
      Left = 0
      Top = 0
      Width = 702
      Height = 392
      Align = alClient
      Center = True
      ExplicitTop = 1
      ExplicitWidth = 700
      ExplicitHeight = 390
    end
    object PageControl_Main: TPageControl
      Left = -4
      Top = -27
      Width = 710
      Height = 423
      Anchors = [akLeft, akTop, akRight, akBottom]
      Style = tsButtons
      TabOrder = 0
      Visible = False
    end
  end
  object Panel_LayerToolBar: TPanel
    Left = 0
    Top = 24
    Width = 702
    Height = 28
    Align = alTop
    BevelOuter = bvNone
    Constraints.MaxHeight = 30
    Constraints.MinHeight = 28
    TabOrder = 3
    object ActionToolBar_Main: TActionToolBar
      Left = 0
      Top = 0
      Width = 702
      Height = 28
      Align = alClient
      Caption = 'ActionToolBar_Main'
      Color = clMenuBar
      ColorMap.HighlightColor = 15660791
      ColorMap.BtnSelectedColor = clBtnFace
      ColorMap.UnusedColor = 15660791
      Constraints.MaxHeight = 28
      Constraints.MinHeight = 28
      EdgeBorders = [ebTop, ebBottom]
      EdgeInner = esNone
      EdgeOuter = esRaised
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clBlack
      Font.Height = -11
      Font.Name = 'Tahoma'
      Font.Style = []
      ParentFont = False
      Spacing = 0
    end
  end
  object Panel_LayerMainMenu: TPanel
    Left = 0
    Top = 0
    Width = 702
    Height = 24
    Align = alTop
    BevelOuter = bvNone
    Constraints.MaxHeight = 24
    Constraints.MinHeight = 24
    TabOrder = 4
    object ActionMainMenuBar_Main: TActionMainMenuBar
      Left = 0
      Top = 0
      Width = 702
      Height = 24
      UseSystemFont = False
      Caption = 'ActionMainMenuBar_Main'
      Color = clMenuBar
      ColorMap.HighlightColor = 15660791
      ColorMap.BtnSelectedColor = clBtnFace
      ColorMap.UnusedColor = 15660791
      Constraints.MaxHeight = 24
      Constraints.MinHeight = 24
      EdgeBorders = [ebBottom]
      EdgeInner = esNone
      EdgeOuter = esRaised
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clMenuText
      Font.Height = -11
      Font.Name = 'Tahoma'
      Font.Style = []
      Spacing = 0
    end
  end
  object ActionList_Tabs: TActionList
    Left = 1
    Top = 53
    object Action_PreviousModule: TAction
      Category = 'Navega'#231#227'o'
      Caption = 'Voltar ao m'#243'dulo anterior'
      Enabled = False
      Hint = 
        'M'#243'dulo anterior|Clique neste bot'#227'o para retornar ao m'#243'dulo anter' +
        'ior na lista de m'#243'dulos abertos'
      ImageIndex = 9
      ShortCut = 16421
      OnExecute = Action_PreviousModuleExecute
    end
    object Action_NextModule: TAction
      Category = 'Navega'#231#227'o'
      Caption = 'Ir ao m'#243'dulo seguinte'
      Enabled = False
      Hint = 
        'M'#243'dulo seguinte|Clique neste bot'#227'o para avan'#231'ar ao pr'#243'ximo m'#243'dul' +
        'o na lista de m'#243'dulos abertos'
      ImageIndex = 8
      ShortCut = 16423
      OnExecute = Action_NextModuleExecute
    end
    object Action_CloseApplication: TAction
      Caption = 'Fechar aplica'#231#227'o'
      Hint = 'Fechar aplica'#231#227'o|Clique para fechar a aplica'#231#227'o'
      ImageIndex = 2
      OnExecute = Action_CloseApplicationExecute
    end
    object Action_FullScreenApplication: TAction
      Tag = 1
      Caption = 'Modo em tela cheia'
      Hint = 
        'Ampliar / Reduzir|Clique este bot'#227'o ampliar a aplica'#231#227'o em tela ' +
        'cheia ou voltar ao modo maximizado normal'
      ImageIndex = 1
      OnExecute = Action_FullScreenApplicationExecute
    end
    object Action_ModuleNavigator: TAction
      Category = 'M'#243'dulos'
      Caption = 'Exibir o navegador de m'#243'dulos'
      Hint = 
        'Exibir o navegador de m'#243'dulos|Clique neste bot'#227'o para exibir uma' +
        ' tela onde '#233' poss'#237'vel visualizar todos os m'#243'dulos em execu'#231#227'o'
      OnExecute = Action_ModuleNavigatorExecute
    end
    object Action_CloseAllModules: TAction
      Category = 'M'#243'dulos'
      Caption = 'Fechar todos os m'#243'dulos abertos'
      Hint = 
        'Fechar todos os m'#243'dulos abertos|Clique para fechar todos os m'#243'du' +
        'los abertos'
      OnExecute = Action_CloseAllModulesExecute
    end
    object Action_BackgroundImage: TAction
      Category = 'Avan'#231'ado'
      Caption = 'Imagem de fundo...'
      Hint = 
        'Imagem de fundo|Permite definir uma imagem para o fundo da aplic' +
        'a'#231#227'o inativa'
      ImageIndex = 7
      OnExecute = Action_BackgroundImageExecute
    end
    object Action_ChangePassword: TAction
      Caption = 'Alterar senha'
      OnExecute = Action_ChangePasswordExecute
    end
    object Action_MySQLBackupAdRestore: TAction
      Category = 'Avan'#231'ado'
      Caption = 'Backup / Restaura'#231#227'o do banco de dados...'
      OnExecute = Action_MySQLBackupAdRestoreExecute
    end
  end
  object BalloonToolTip_Validation: TBalloonToolTip
    ParseLinks = False
    AutoGetTexts = False
    MaxWidth = 320
    BackColor = 14811135
    ForeColor = clBlack
    VisibleTime = 3000
    DelayTime = 1000
    TipTitle = 'Bal'#227'o sem t'#237'tulo'
    TipText = 
      'Voc'#234' esqueceu de por um texto. Configure a propriedade TipText c' +
      'orretamente'
    TipIcon = tiInfo
    TipAlignment = taCustom
    XPosition = 0
    YPosition = 0
    ShowWhenRequested = True
    Centered = False
    ForwardMessages = False
    AbsolutePosition = False
    ShowCloseButton = False
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'Tahoma'
    Font.Style = []
    BalloonTipOptions = [bttoActivateOnShow, bttoSetFocusToAssociatedWinContronOnDeactivate, bttoHideOnDeactivate, bttoHideWithEnter, bttoHideWithEsc, bttoSelectAllOnFocus]
    Left = 31
    Top = 53
  end
end
