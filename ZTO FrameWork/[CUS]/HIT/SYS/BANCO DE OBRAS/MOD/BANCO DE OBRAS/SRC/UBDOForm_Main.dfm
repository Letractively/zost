inherited BDOForm_Main: TBDOForm_Main
  Caption = 'Banco De Obras'
  ClientHeight = 734
  ClientWidth = 1016
  Constraints.MinHeight = 768
  Constraints.MinWidth = 1024
  WindowState = wsMinimized
  ExplicitWidth = 1024
  ExplicitHeight = 768
  PixelsPerInch = 96
  TextHeight = 13
  inherited StatusBar_Main: TStatusBar
    Top = 715
    Width = 1016
    ExplicitTop = 715
    ExplicitWidth = 1016
  end
  inherited ProgressBar_ModuleLoad: TProgressBar
    Top = 719
    ExplicitTop = 719
  end
  inherited Panel_MainBackground: TPanel
    Width = 1016
    Height = 663
    ExplicitWidth = 1016
    ExplicitHeight = 663
    inherited Shape_MainBackground: TShape
      Width = 1016
      Height = 663
      ExplicitWidth = 1016
      ExplicitHeight = 663
    end
    inherited Image_MainBackground: TImage
      Width = 1016
      Height = 663
      ExplicitWidth = 1016
      ExplicitHeight = 663
    end
    inherited PageControl_Main: TPageControl
      Width = 1024
      Height = 694
      ExplicitWidth = 1024
      ExplicitHeight = 694
    end
  end
  inherited Panel_LayerToolBar: TPanel
    Width = 1016
    ExplicitWidth = 1016
    inherited ActionToolBar_Main: TActionToolBar
      Width = 1016
      ActionManager = ActionManager_Main
      ParentFont = False
      ExplicitWidth = 1016
    end
  end
  inherited Panel_LayerMainMenu: TPanel
    Width = 1016
    ExplicitWidth = 1016
    inherited ActionMainMenuBar_Main: TActionMainMenuBar
      Width = 1016
      UseSystemFont = False
      ActionManager = ActionManager_Main
      Font.Color = clWindowText
      ExplicitWidth = 1016
    end
  end
  object ActionManager_Main: TActionManager [5]
    ActionBars = <
      item
        Items = <
          item
            Items = <
              item
                Action = BDODataModule_Main.Action_Obras
              end
              item
                Action = BDODataModule_Main.Action_Regioes
              end
              item
                Action = BDODataModule_Main.Action_Situacoes
              end
              item
                Action = BDODataModule_Main.Action_TiposDeObra
              end
              item
                Action = BDODataModule_Main.Action_Projetistas
              end
              item
                Action = BDODataModule_Main.Action_Instaladores
              end
              item
                Action = BDODataModule_Main.Action_EquipamentosEFamilias
              end
              item
                Action = BDODataModule_Main.Action_TabelasAuxiliares
              end
              item
                Caption = '-'
              end
              item
                Action = Action_ImportarExportar
                Caption = 'I&mportar / Exportar dados das Obras...'
                ImageIndex = 17
              end>
            Caption = '&Gerenciamento'
          end
          item
            Items = <
              item
                Action = BDODataModule_Main.Action_RelatorioObras
                ImageIndex = 14
              end
              item
                Action = BDODataModule_Main.Action_RelatorioPropostas
                ImageIndex = 14
              end
              item
                Action = BDODataModule_Main.Action_RelatorioFamilias
                ImageIndex = 14
              end
              item
                Action = BDODataModule_Main.Action_RelatorioEquipamentosPorSituacao
                ImageIndex = 14
              end
              item
                Action = BDODataModule_Main.Action_RelatorioJustificativasDasObras
                ImageIndex = 14
              end>
            Caption = '&Relat'#243'rios'
          end
          item
            Items = <
              item
                Action = BDODataModule_Main.Action_GeneralConfigurations
                ImageIndex = 12
              end
              item
                Action = BDODataModule_Main.Action_SecurityAndPermissions
                ImageIndex = 13
              end
              item
                Action = Action_BackgroundImage
                Caption = '&Imagem de fundo...'
                ImageIndex = 8
              end
              item
                Action = Action_MySQLBackupAdRestore
                Caption = '&Backup / Restaura'#231#227'o do banco de dados...'
                ImageIndex = 15
              end>
            Caption = 'A&van'#231'ado'
          end
          item
            Items = <
              item
                Action = Action_PreviousModule
                Caption = '&Voltar ao m'#243'dulo anterior'
                ImageIndex = 0
                ShortCut = 16421
              end
              item
                Action = Action_NextModule
                Caption = '&Ir ao m'#243'dulo seguinte'
                ImageIndex = 1
                ShortCut = 16423
              end
              item
                Items = <
                  item
                    Action = Action_ModuleNavigator
                    Caption = '&Exibir o navegador de m'#243'dulos'
                  end
                  item
                    Action = Action_CloseAllModules
                    Caption = '&Fechar todos os m'#243'dulos abertos'
                  end>
                Caption = '&M'#243'dulos'
                UsageCount = 1
              end>
            Caption = '&Navega'#231#227'o'
          end
          item
            Items = <
              item
                Action = Action_HelpHelp
                Caption = '&Ajuda'
                ImageIndex = 5
              end
              item
                Action = Action_HelpAbout
                Caption = '&Sobre'
                ImageIndex = 4
              end>
            Caption = '&Ajuda'
          end>
        ActionBar = ActionMainMenuBar_Main
      end
      item
        Items.CaptionOptions = coNone
        Items = <
          item
            Visible = False
            Action = Action_FullScreenApplication
            Caption = '&Modo em tela cheia'
            ImageIndex = 6
          end
          item
            Visible = False
            Action = Action_CloseApplication
            Caption = '&Fechar aplica'#231#227'o'
            ImageIndex = 2
          end
          item
            Visible = False
            Caption = '-'
          end
          item
            Action = Action_PreviousModule
            Caption = '&Voltar ao m'#243'dulo anterior'
            ImageIndex = 0
            ShortCut = 16421
          end
          item
            Action = Action_NextModule
            Caption = '&Ir ao m'#243'dulo seguinte'
            ImageIndex = 1
            ShortCut = 16423
          end
          item
            Caption = '-'
          end
          item
            Action = Action_ChangePassword
            Caption = 'A&lterar senha'
            ImageIndex = 9
          end>
        ActionBar = ActionToolBar_Main
      end>
    LinkedActionLists = <
      item
        ActionList = BDODataModule_Main.ActionList_Buttons
        Caption = 'ActionList_Main'
      end
      item
        ActionList = ActionList_Tabs
        Caption = 'ActionList_Tabs'
      end>
    Images = BDODataModule_Main.ImageList_Main
    Left = 31
    Top = 53
    StyleName = 'XP Style'
  end
  inherited ActionList_Tabs: TActionList
    Images = BDODataModule_Main.ImageList_Main
    inherited Action_PreviousModule: TAction
      ImageIndex = 0
    end
    inherited Action_NextModule: TAction
      ImageIndex = 1
    end
    inherited Action_CloseApplication: TAction
      Visible = False
    end
    inherited Action_FullScreenApplication: TAction
      ImageIndex = 6
      Visible = False
    end
    inherited Action_BackgroundImage: TAction
      ImageIndex = 8
    end
    inherited Action_ChangePassword: TAction
      ImageIndex = 9
    end
    inherited Action_MySQLBackupAdRestore: TAction
      ImageIndex = 15
    end
    object Action_ImportarExportar: TAction
      Caption = 'Importar / Exportar dados das Obras...'
      Hint = 
        'Importar / Exportar dados das Obras|Clique para exibir o importa' +
        'dor / exportador de dados das obras'
      ImageIndex = 17
      OnExecute = Action_ImportarExportarExecute
    end
    object Action_HelpHelp: TAction
      Category = 'Ajuda'
      Caption = 'Ajuda'
      Hint = 'Ajuda|Acessa a ajuda do programa'
      ImageIndex = 5
    end
    object Action_HelpAbout: TAction
      Category = 'Ajuda'
      Caption = 'Sobre'
      Hint = 'Sobre|Sobre este programa ...'
      ImageIndex = 4
      OnExecute = Action_HelpAboutExecute
    end
  end
  inherited BalloonToolTip_Validation: TBalloonToolTip
    TipAlignment = taLeftMiddle
    Left = 61
  end
end
