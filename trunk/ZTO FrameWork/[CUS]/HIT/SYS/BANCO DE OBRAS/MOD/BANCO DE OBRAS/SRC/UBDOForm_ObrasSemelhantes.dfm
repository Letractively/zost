inherited BDOForm_ObrasSemelhantes: TBDOForm_ObrasSemelhantes
  Caption = 'Lista de obras semelhantes'
  ClientHeight = 426
  ClientWidth = 766
  OnShow = FormShow
  ExplicitWidth = 772
  ExplicitHeight = 458
  DesignSize = (
    766
    426)
  PixelsPerInch = 96
  TextHeight = 13
  inherited Panel_Header: TPanel
    Width = 766
    ExplicitWidth = 766
    inherited Shape_BackgroundHeader: TShape
      Width = 766
      ExplicitWidth = 797
    end
    inherited Label_DialogDescription: TLabel
      Width = 720
      Caption = 
        'Esta tela lista todas as obras cujo nome '#233', de alguma forma, sem' +
        'elhante ao nome da obra atualmente sendo inserida. Para abrir um' +
        'a das obras aqui listadas, selecione-a e clique o bot'#227'o "Abrir o' +
        'bra" ou execute um duplo-clique sobre a mesma. OBS.: APENAS OBRA' +
        'S DE SUAS REGI'#213'ES DE ATUA'#199#195'O PODEM SER ABERTAS. PARA EXIBIR INFO' +
        'RMA'#199#213'ES ADICIONAIS SOBRE UMA OBRA, CLIQUE COM O BOT'#195'O DIREITO DO' +
        ' MOUSE SOBRE A MESMA.'
      ExplicitWidth = 751
    end
    inherited Shape_HeaderLine: TShape
      Width = 758
      ExplicitWidth = 789
    end
    inherited Bevel_Header: TBevel
      Width = 766
      ExplicitWidth = 797
    end
  end
  inherited Panel_Footer: TPanel
    Top = 388
    Width = 766
    ExplicitTop = 388
    ExplicitWidth = 766
    inherited Shape_FooterBackground: TShape
      Width = 766
      ExplicitTop = 277
      ExplicitWidth = 797
    end
    inherited Shape_FooterLine: TShape
      Width = 758
      ExplicitTop = 4
      ExplicitWidth = 789
    end
    inherited Shape_Organizer: TShape
      Width = 758
      ExplicitTop = 9
      ExplicitWidth = 789
    end
    inherited Bevel_Footer: TBevel
      Width = 766
      ExplicitTop = 277
      ExplicitWidth = 797
    end
  end
  object BitBtn_Usar: TBitBtn [2]
    Left = 594
    Top = 397
    Width = 81
    Height = 25
    Anchors = [akRight, akBottom]
    Caption = 'Abrir obra'
    Default = True
    ModalResult = 1
    TabOrder = 3
    Glyph.Data = {
      DE010000424DDE01000000000000760000002800000024000000120000000100
      0400000000006801000000000000000000001000000000000000000000000000
      80000080000000808000800000008000800080800000C0C0C000808080000000
      FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFFFF00333333333333
      3333333333333333333333330000333333333333333333333333F33333333333
      00003333344333333333333333388F3333333333000033334224333333333333
      338338F3333333330000333422224333333333333833338F3333333300003342
      222224333333333383333338F3333333000034222A22224333333338F338F333
      8F33333300003222A3A2224333333338F3838F338F33333300003A2A333A2224
      33333338F83338F338F33333000033A33333A222433333338333338F338F3333
      0000333333333A222433333333333338F338F33300003333333333A222433333
      333333338F338F33000033333333333A222433333333333338F338F300003333
      33333333A222433333333333338F338F00003333333333333A22433333333333
      3338F38F000033333333333333A223333333333333338F830000333333333333
      333A333333333333333338330000333333333333333333333333333333333333
      0000}
    Layout = blGlyphRight
    NumGlyphs = 2
    Spacing = 3
  end
  object BitBtn_Cancelar: TBitBtn [3]
    Left = 681
    Top = 397
    Width = 81
    Height = 25
    Anchors = [akRight, akBottom]
    Caption = 'Cancelar'
    TabOrder = 4
    Kind = bkCancel
    Layout = blGlyphRight
    Spacing = 8
  end
  object PageControl_ObrasSemelhantes: TPageControl [4]
    AlignWithMargins = True
    Left = 6
    Top = 55
    Width = 754
    Height = 327
    Margins.Left = 6
    Margins.Top = 6
    Margins.Right = 6
    Margins.Bottom = 6
    ActivePage = TabSheet_SentencaParcial
    Align = alClient
    TabOrder = 2
    object TabSheet_SentencaParcial: TTabSheet
      Caption = 'Senten'#231'a parcial (??)'
      object CFDBGrid_OBR_SentencaParcial: TCFDBGrid
        Left = 0
        Top = 43
        Width = 746
        Height = 256
        Align = alClient
        Ctl3D = True
        DataSource = BDODataModule_Obras.DataSource_OBR_SCH_PAR
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'Tahoma'
        Font.Style = []
        Options = [dgEditing, dgTitles, dgColLines, dgRowLines, dgTabs, dgConfirmDelete, dgCancelOnExit]
        OptionsEx = [dgAllowTitleClick, dgAutomaticColumSizes]
        ParentCtl3D = False
        ParentFont = False
        PopupMenu = BDODataModule_Obras.PopupActionBar_RecordInformation
        TabOrder = 1
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
        VariableWidthColumns = '<VA_NOMEDAOBRA>'
        OnDblClick = DoCFDBGridDblClick
        Columns = <
          item
            Color = clInfoBk
            Expanded = False
            FieldName = 'VA_NOMEDAOBRA'
            Title.Caption = 'Obra'
            Width = 360
            Visible = True
          end
          item
            Alignment = taCenter
            Expanded = False
            FieldName = 'LOCALIDADE'
            Title.Alignment = taCenter
            Title.Caption = 'Localidade'
            Width = 201
            Visible = True
          end
          item
            Alignment = taCenter
            Expanded = False
            FieldName = 'REGIAO'
            Title.Alignment = taCenter
            Title.Caption = 'Regi'#227'o'
            Width = 80
            Visible = True
          end
          item
            Alignment = taCenter
            Expanded = False
            FieldName = 'DATADEENTRADA'
            Title.Alignment = taCenter
            Title.Caption = 'Entrada'
            Width = 80
            Visible = True
          end>
      end
      object Panel_SentencaParcial: TPanel
        Left = 0
        Top = 0
        Width = 746
        Height = 43
        Align = alTop
        BevelOuter = bvNone
        TabOrder = 0
        object StaticText_SentencaParcial: TLabel
          Left = 0
          Top = 0
          Width = 746
          Height = 43
          Align = alClient
          Alignment = taCenter
          Caption = 
            'Esta p'#225'gina exibe todas as OBRAS CUJO NOME CONT'#201'M A SENTEN'#199'A QUE' +
            ' VOC'#202' DIGITOU. A senten'#231'a completa '#233' comparada, ou seja, tudo qu' +
            'e foi digitado, na ordem em que voc'#234' digitou ser'#225' procurado NO I' +
            'N'#205'CIO, NO MEIO ou NO FIM do nome de cada obra existente.'
          Transparent = True
          Layout = tlCenter
          WordWrap = True
          ExplicitWidth = 720
          ExplicitHeight = 26
        end
      end
    end
    object TabSheet_PalavrasIndividuais: TTabSheet
      Caption = 'Palavras individuais (??)'
      ImageIndex = 2
      object CFDBGrid_OBR_PalavrasIndividuais: TCFDBGrid
        Left = 0
        Top = 43
        Width = 746
        Height = 256
        Align = alClient
        Ctl3D = True
        DataSource = BDODataModule_Obras.DataSource_OBR_SCH_PAL
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'Tahoma'
        Font.Style = []
        Options = [dgEditing, dgTitles, dgColLines, dgRowLines, dgTabs, dgConfirmDelete, dgCancelOnExit]
        OptionsEx = [dgAllowTitleClick, dgAutomaticColumSizes]
        ParentCtl3D = False
        ParentFont = False
        PopupMenu = BDODataModule_Obras.PopupActionBar_RecordInformation
        TabOrder = 1
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
        VariableWidthColumns = '<VA_NOMEDAOBRA>'
        OnDblClick = DoCFDBGridDblClick
        Columns = <
          item
            Color = clInfoBk
            Expanded = False
            FieldName = 'VA_NOMEDAOBRA'
            Title.Caption = 'Obra'
            Width = 360
            Visible = True
          end
          item
            Alignment = taCenter
            Expanded = False
            FieldName = 'LOCALIDADE'
            Title.Alignment = taCenter
            Title.Caption = 'Localidade'
            Width = 201
            Visible = True
          end
          item
            Alignment = taCenter
            Expanded = False
            FieldName = 'REGIAO'
            Title.Alignment = taCenter
            Title.Caption = 'Regi'#227'o'
            Width = 80
            Visible = True
          end
          item
            Alignment = taCenter
            Expanded = False
            FieldName = 'DATADEENTRADA'
            Title.Alignment = taCenter
            Title.Caption = 'Entrada'
            Width = 80
            Visible = True
          end>
      end
      object Panel_PalavrasIndividuais: TPanel
        Left = 0
        Top = 0
        Width = 746
        Height = 43
        Align = alTop
        BevelOuter = bvNone
        TabOrder = 0
        object Label_PalavrasIndividuais: TLabel
          Left = 0
          Top = 0
          Width = 746
          Height = 43
          Align = alClient
          Alignment = taCenter
          Caption = 
            'Esta p'#225'gina exibe todas as OBRAS CUJO NOME CONT'#201'M CADA UMA DAS P' +
            'ALAVRAS DA SENTEN'#199'A QUE VOC'#202' DIGITOU, INDIVIDUALMENTE. Cada uma ' +
            'das palavras '#233' comparada com o nome de cada obra existente e aqu' +
            'i ser'#227'o listadas todas as obras cujo nome atende a este crit'#233'rio' +
            '. '
          Transparent = True
          Layout = tlCenter
          WordWrap = True
          ExplicitWidth = 734
          ExplicitHeight = 26
        end
      end
    end
  end
end
