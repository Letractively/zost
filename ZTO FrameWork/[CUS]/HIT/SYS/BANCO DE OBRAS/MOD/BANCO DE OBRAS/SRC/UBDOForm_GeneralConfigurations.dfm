inherited BDOForm_GeneralConfigurations: TBDOForm_GeneralConfigurations
  Caption = 'Configura'#231#245'es gerais do Banco De Obras'
  PixelsPerInch = 96
  TextHeight = 13
  inherited PageControl_ConfigurationCategories: TPageControl
    inherited TabSheet_OtherOptions: TTabSheet
      inherited PageControl_OtherOptions: TPageControl
        object TabSheet_ExibirOcultar: TTabSheet
          Caption = 'Exibir / Ocultar'
          ImageIndex = 1
          object CheckBox_ITE_LucroBruto: TCheckBox
            Left = 3
            Top = 0
            Width = 241
            Height = 13
            Caption = 'Exibir coluna "Lucro Bruto" na listagem de itens'
            TabOrder = 0
          end
        end
      end
    end
    object TabSheet_FTPSynchronizer: TTabSheet
      Caption = 'FTP Synchronizer'#8482
      ImageIndex = 4
      object Label_FTPSynchronizerLocation: TLabel
        Left = 3
        Top = 0
        Width = 191
        Height = 13
        Caption = 'Local de instala'#231#227'o do FTP Synchronizer'
      end
      object Button_FTPSynchronizerLocation: TButton
        Left = 314
        Top = 13
        Width = 21
        Height = 21
        Caption = '...'
        TabOrder = 0
        OnClick = Button_FTPSynchronizerLocationClick
      end
      object Panel_FTPSynchronizerLocationValue: TPanel
        Left = 1
        Top = 13
        Width = 310
        Height = 21
        BevelOuter = bvLowered
        Caption = 'Panel_FTPSynchronizerLocationValue'
        Color = clActiveCaption
        TabOrder = 1
        DesignSize = (
          310
          21)
        object Shape_FTPSynchronizerLocationValue: TShape
          Left = 1
          Top = 1
          Width = 308
          Height = 19
          Align = alClient
          Brush.Color = clActiveCaption
          Pen.Style = psClear
          ExplicitLeft = 216
          ExplicitTop = 12
          ExplicitWidth = 65
          ExplicitHeight = 65
        end
        object Label_FTPSynchronizerLocationValue: TLabel
          Left = 3
          Top = 1
          Width = 304
          Height = 19
          Anchors = [akLeft, akTop, akRight]
          AutoSize = False
          Caption = 
            'C:\Documents and Settings\'#208'erek Wildstar\Menu Iniciar\Programas\' +
            'Ferramentas para multim'#237'dia\Videos\Pinnacle Studio 12'
          Color = clActiveCaption
          EllipsisPosition = epPathEllipsis
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clCaptionText
          Font.Height = -11
          Font.Name = 'Tahoma'
          Font.Style = [fsBold]
          ParentColor = False
          ParentFont = False
          ParentShowHint = False
          ShowHint = True
          Layout = tlCenter
        end
      end
    end
  end
end
