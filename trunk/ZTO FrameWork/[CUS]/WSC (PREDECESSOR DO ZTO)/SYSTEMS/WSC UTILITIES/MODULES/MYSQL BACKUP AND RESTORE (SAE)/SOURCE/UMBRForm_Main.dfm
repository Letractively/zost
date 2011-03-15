inherited MBRForm_Main: TMBRForm_Main
  BorderIcons = [biSystemMenu, biMinimize, biHelp]
  BorderStyle = bsSingle
  Caption = 'MySQL Backup And Restore (Stand Alone Edition)'
  ClientHeight = 124
  ClientWidth = 463
  ParentBiDiMode = False
  Visible = True
  ExplicitWidth = 469
  ExplicitHeight = 156
  PixelsPerInch = 96
  TextHeight = 13
  inherited Panel_Header: TPanel
    Width = 463
    ExplicitWidth = 532
    DesignSize = (
      463
      49)
    inherited Shape_BackgroundHeader: TShape
      Width = 463
      ExplicitWidth = 548
    end
    inherited Label_DialogDescription: TLabel
      Width = 417
      Caption = 
        'Esta '#233' uma aplica'#231#227'o assistente para incializa'#231#227'o independente d' +
        'o m'#243'dulo MySQL Backup And Restore. Clique o bot'#227'o para inicar a ' +
        'aplica'#231#227'o.'
      ParentColor = True
      ExplicitWidth = 502
    end
    inherited Shape_HeaderLine: TShape
      Width = 455
      ExplicitWidth = 540
    end
    inherited Bevel_Header: TBevel
      Width = 463
      ExplicitWidth = 548
    end
  end
  inherited Panel_Footer: TPanel
    Top = 86
    Width = 463
    ExplicitTop = 321
    ExplicitWidth = 532
    DesignSize = (
      463
      38)
    inherited Shape_FooterBackground: TShape
      Width = 463
      ExplicitWidth = 548
    end
    inherited Shape_FooterLine: TShape
      Width = 455
      ExplicitWidth = 540
    end
    inherited Shape_Organizer: TShape
      Width = 455
      ExplicitWidth = 540
    end
    inherited Bevel_Footer: TBevel
      Width = 463
      ExplicitWidth = 548
    end
  end
  object Button_IniciarMBR: TButton [2]
    Left = 8
    Top = 55
    Width = 447
    Height = 25
    Action = Action_ExibirMBAR
    TabOrder = 2
  end
  inherited ActionList_LocalActions: TActionList
    object Action_SalvarConfiguracoes: TAction
      Caption = 'Salvar Configura'#231#245'es'
    end
    object Action_ExibirMBAR: TAction
      Caption = 'Iniciar o MySQL Backup And Restore'
      OnExecute = Action_ExibirMBARExecute
    end
  end
end
