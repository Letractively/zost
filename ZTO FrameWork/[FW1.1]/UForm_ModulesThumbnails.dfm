inherited Form_ModulesThumbnails: TForm_ModulesThumbnails
  Caption = 'Navegador de m'#243'dulos'
  ClientHeight = 313
  ClientWidth = 504
  ExplicitWidth = 510
  ExplicitHeight = 345
  PixelsPerInch = 96
  TextHeight = 13
  inherited Panel_Header: TPanel
    Width = 504
    TabOrder = 2
    ExplicitWidth = 504
    inherited Shape_BackgroundHeader: TShape
      Width = 504
      ExplicitWidth = 452
    end
    inherited Label_DialogDescription: TLabel
      Width = 458
      Caption = 
        'Esta tela permite visualizar de uma forma natural miniaturas de ' +
        'todos os m'#243'dulos em execu'#231#227'o. Clique na imagem do m'#243'dulo que voc' +
        #234' deseja ativar'
      ExplicitWidth = 406
    end
    inherited Shape_HeaderLine: TShape
      Width = 496
      ExplicitWidth = 444
    end
    inherited Bevel_Header: TBevel
      Width = 504
      ExplicitWidth = 452
    end
  end
  inherited Panel_Footer: TPanel
    Top = 275
    Width = 504
    ExplicitTop = 275
    ExplicitWidth = 504
    inherited Shape_FooterBackground: TShape
      Width = 504
      ExplicitTop = 212
      ExplicitWidth = 452
    end
    inherited Shape_FooterLine: TShape
      Width = 496
      ExplicitTop = 4
      ExplicitWidth = 496
    end
    inherited Shape_Organizer: TShape
      Width = 496
      ExplicitTop = 9
      ExplicitWidth = 496
    end
    inherited Bevel_Footer: TBevel
      Width = 504
      ExplicitTop = 212
      ExplicitWidth = 452
    end
  end
  object ScrollBox_ThumbScroller: TScrollBox [2]
    Left = 6
    Top = 53
    Width = 492
    Height = 218
    Anchors = [akLeft, akTop, akRight, akBottom]
    Color = clMenu
    Ctl3D = False
    ParentColor = False
    ParentCtl3D = False
    TabOrder = 0
    object Shape_Selection: TShape
      Left = 5
      Top = 5
      Width = 25
      Height = 26
      Brush.Color = clHighlight
      Pen.Color = clHighlightText
      Pen.Style = psDot
      Visible = False
    end
  end
end
