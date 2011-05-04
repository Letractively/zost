object Form_Principal: TForm_Principal
  Left = 0
  Top = 0
  BorderIcons = [biSystemMenu, biMinimize]
  BorderStyle = bsSingle
  Caption = 'MPS Updater'
  ClientHeight = 368
  ClientWidth = 794
  Color = clBtnFace
  Constraints.MaxHeight = 400
  Constraints.MaxWidth = 800
  Constraints.MinHeight = 400
  Constraints.MinWidth = 800
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  Position = poScreenCenter
  OnCloseQuery = FormCloseQuery
  OnCreate = FormCreate
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object ActionMainMenuBar_Principal: TActionMainMenuBar
    Left = 0
    Top = 0
    Width = 794
    Height = 25
    UseSystemFont = False
    ActionManager = ActionManager_Principal
    Caption = 'ActionMainMenuBar_Principal'
    ColorMap.HighlightColor = 15660791
    ColorMap.BtnSelectedColor = clBtnFace
    ColorMap.UnusedColor = 15660791
    EdgeBorders = [ebBottom]
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'Tahoma'
    Font.Style = []
    Spacing = 0
  end
  object PageContro_Principal: TPageControl
    Left = 0
    Top = 25
    Width = 794
    Height = 343
    ActivePage = TabSheet_Log
    Align = alClient
    TabOrder = 1
    object TabSheet_Log: TTabSheet
      Caption = 'Log de atividade'
      object RichEdit_LogFTP: TRichEdit
        AlignWithMargins = True
        Left = 6
        Top = 6
        Width = 774
        Height = 234
        Margins.Left = 6
        Margins.Top = 6
        Margins.Right = 6
        Margins.Bottom = 0
        Align = alClient
        Font.Charset = ANSI_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'Courier New'
        Font.Style = []
        ParentFont = False
        ReadOnly = True
        ScrollBars = ssVertical
        TabOrder = 1
      end
      object RichEdit_LogMonitoramento: TRichEdit
        AlignWithMargins = True
        Left = 6
        Top = 6
        Width = 774
        Height = 234
        Margins.Left = 6
        Margins.Top = 6
        Margins.Right = 6
        Margins.Bottom = 0
        Align = alClient
        Font.Charset = ANSI_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'Courier New'
        Font.Style = []
        ParentFont = False
        ReadOnly = True
        ScrollBars = ssVertical
        TabOrder = 2
      end
      object Panel_Log: TPanel
        AlignWithMargins = True
        Left = 6
        Top = 268
        Width = 774
        Height = 41
        Margins.Left = 6
        Margins.Right = 6
        Margins.Bottom = 6
        Align = alBottom
        BevelInner = bvLowered
        TabOrder = 0
        object Image_Green: TImage
          Left = 12
          Top = 13
          Width = 9
          Height = 15
          Picture.Data = {
            07544269746D6170EE000000424DEE0000000000000076000000280000000900
            00000F0000000100040000000000780000000000000000000000100000001000
            000000000000000080000080000000808000800000008000800080800000C0C0
            C000808080000000FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFF
            FF003A00000A3000000007A000A700000000070AAA07000000000A0AAA0A0000
            0000070AAA070000000007A000A7000000000A07770A000000000707B7070000
            0000070777070000000007700077000000000707770700000000070797070000
            0000070777070000000007700077000000003000000030000000}
        end
        object Image_Red: TImage
          Left = 12
          Top = 13
          Width = 9
          Height = 15
          Picture.Data = {
            07544269746D6170EE000000424DEE0000000000000076000000280000000900
            00000F0000000100040000000000780000000000000000000000100000001000
            000000000000000080000080000000808000800000008000800080800000C0C0
            C000808080000000FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFF
            FF003000000030000000077000770000000007077707000000000707A7070000
            00000707770700000000077000770000000007077707000000000707B7070000
            0000090777090000000007900097000000000709990700000000090999090000
            0000070999070000000007900097000000003900000930000000}
        end
        object Label_ClientCount: TLabel
          Left = 27
          Top = 14
          Width = 75
          Height = 13
          Caption = 'Servidor inativo'
        end
        object Image_Yellow: TImage
          Left = 12
          Top = 13
          Width = 9
          Height = 15
          Picture.Data = {
            07544269746D6170EA040000424DEA0400000000000036040000280000000900
            00000F0000000100080000000000B4000000C40E0000C40E0000000100000001
            00000000000000FF00000000FF000080800000FFFF00C0C0C000000000000000
            0000000000000000000000000000000000000000000000000000000000000000
            0000000000000000000000000000000000000000000000000000000000000000
            0000000000000000000000000000000000000000000000000000000000000000
            0000000000000000000000000000000000000000000000000000000000000000
            0000000000000000000000000000000000000000000000000000000000000000
            0000000000000000000000000000000000000000000000000000000000000000
            0000000000000000000000000000000000000000000000000000000000000000
            0000000000000000000000000000000000000000000000000000000000000000
            0000000000000000000000000000000000000000000000000000000000000000
            0000000000000000000000000000000000000000000000000000000000000000
            0000000000000000000000000000000000000000000000000000000000000000
            0000000000000000000000000000000000000000000000000000000000000000
            0000000000000000000000000000000000000000000000000000000000000000
            0000000000000000000000000000000000000000000000000000000000000000
            0000000000000000000000000000000000000000000000000000000000000000
            0000000000000000000000000000000000000000000000000000000000000000
            0000000000000000000000000000000000000000000000000000000000000000
            0000000000000000000000000000000000000000000000000000000000000000
            0000000000000000000000000000000000000000000000000000000000000000
            0000000000000000000000000000000000000000000000000000000000000000
            0000000000000000000000000000000000000000000000000000000000000000
            0000000000000000000000000000000000000000000000000000000000000000
            0000000000000000000000000000000000000000000000000000000000000000
            0000000000000000000000000000000000000000000000000000000000000000
            0000000000000000000000000000000000000000000000000000000000000000
            0000000000000000000000000000000000000000000000000000000000000000
            0000000000000000000000000000000000000000000000000000000000000000
            0000000000000000000000000000000000000000000000000000000000000000
            0000000000000000000000000000000000000000000000000000000000000000
            0000000000000000000000000000000000000000000000000000000000000000
            0000000000000000000000000000000000000000000000000000000000000000
            0000030000000000000003000000000505000000050500000000000500050505
            0005000000000005000501050005000000000004000505050004000000000005
            0400000004050000000000050004040400050000000000040004040400040000
            0000000500040404000500000000000504000000040500000000000400050505
            0004000000000005000502050005000000000005000505050005000000000005
            05000000050500000000030000000000000003000000}
        end
        object BitBtn_SalvarELimparLog: TBitBtn
          AlignWithMargins = True
          Left = 636
          Top = 8
          Width = 130
          Height = 25
          Margins.Top = 6
          Margins.Right = 6
          Margins.Bottom = 6
          Action = Action_SalvarELimparLog
          Align = alRight
          Caption = 'Salvar e limpar este log'
          TabOrder = 0
        end
      end
      object TabSet_Log: TTabSet
        AlignWithMargins = True
        Left = 6
        Top = 241
        Width = 774
        Height = 21
        Margins.Left = 6
        Margins.Top = 1
        Margins.Right = 6
        Align = alBottom
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'Tahoma'
        Font.Style = []
        Tabs.Strings = (
          'Monitorador de arquivos'
          'FTP')
        TabIndex = 0
        OnChange = TabSet_LogChange
      end
    end
    object TabSheet_Sistemas: TTabSheet
      Caption = 'Sistemas'
      ImageIndex = 1
      object Panel_Projetos: TPanel
        AlignWithMargins = True
        Left = 6
        Top = 6
        Width = 774
        Height = 41
        Margins.Left = 6
        Margins.Top = 6
        Margins.Right = 6
        Align = alTop
        BevelInner = bvLowered
        Color = clInfoBk
        ParentBackground = False
        TabOrder = 0
        object Label_ProjetosInfo: TLabel
          AlignWithMargins = True
          Left = 8
          Top = 2
          Width = 758
          Height = 37
          Margins.Left = 6
          Margins.Top = 0
          Margins.Right = 6
          Margins.Bottom = 0
          Align = alClient
          Alignment = taCenter
          Caption = 
            'Para cada sistema que se que quer monitorar, uma entrada tem de ' +
            'ser colocada aqui. Fisicamente, sistemas s'#227'o na realidade diret'#243 +
            'rios monitorados pelo MPS Updater. Cada vez que h'#225' alguma altera' +
            #231#227'o no conte'#250'do dos diret'#243'rios monitorados, entradas s'#227'o inserid' +
            'as, exclu'#237'das ou atualizadas na tabela de arquivos'
          Transparent = True
          Layout = tlCenter
          WordWrap = True
          ExplicitWidth = 756
          ExplicitHeight = 26
        end
      end
      object ZTODBGrid_Sistemas: TZTODBGrid
        AlignWithMargins = True
        Left = 6
        Top = 53
        Width = 774
        Height = 132
        Margins.Left = 6
        Margins.Right = 6
        Align = alClient
        DataSource = DataModule_Principal.DataSource_SIS
        Options = [dgTitles, dgIndicator, dgColLines, dgRowLines, dgRowSelect, dgAlwaysShowSelection, dgConfirmDelete, dgCancelOnExit]
        OptionsEx = []
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
        SortArrow.Column = 'BI_SISTEMAS_ID'
        Columns = <
          item
            Alignment = taCenter
            Expanded = False
            FieldName = 'BI_SISTEMAS_ID'
            Title.Alignment = taCenter
            Title.Caption = 'ID'
            Width = 104
            Visible = True
          end
          item
            Alignment = taCenter
            Expanded = False
            FieldName = 'VA_NOME'
            Title.Alignment = taCenter
            Title.Caption = 'Sistema'
            Width = 202
            Visible = True
          end
          item
            Expanded = False
            FieldName = 'VA_DIRETORIO'
            Title.Caption = 'Diret'#243'rio de monitoramento'
            Width = 426
            Visible = True
          end>
      end
      object Panel_Sistemas: TPanel
        AlignWithMargins = True
        Left = 6
        Top = 220
        Width = 774
        Height = 89
        Margins.Left = 6
        Margins.Right = 6
        Margins.Bottom = 6
        Align = alBottom
        BevelInner = bvLowered
        TabOrder = 2
        DesignSize = (
          774
          89)
        object Label_SIS_VA_NOME: TLabel
          Left = 8
          Top = 6
          Width = 37
          Height = 13
          Anchors = [akLeft, akBottom]
          Caption = 'Sistema'
          Color = clAppWorkSpace
          FocusControl = DBEdit_SIS_VA_NOME
          ParentColor = False
          Transparent = True
        end
        object Label_SIS_VA_DIRETORIO: TLabel
          Left = 285
          Top = 6
          Width = 131
          Height = 13
          Anchors = [akLeft, akBottom]
          Caption = 'Diret'#243'rio de monitoramento'
          Color = clAppWorkSpace
          FocusControl = DBEdit_SIS_VA_DIRETORIO
          ParentColor = False
          Transparent = True
        end
        object Label_SIS_VA_DESCRICAO: TLabel
          Left = 8
          Top = 47
          Width = 46
          Height = 13
          Anchors = [akLeft, akBottom]
          Caption = 'Descri'#231#227'o'
          Color = clMedGray
          FocusControl = DBEdit_SIS_VA_DESCRICAO
          ParentColor = False
          Transparent = True
        end
        object SpeedButton_DiretorioDeMonitoramento: TSpeedButton
          Left = 685
          Top = 20
          Width = 81
          Height = 21
          Action = DataModule_Principal.Action_DiretorioDeMonitoramento
          Flat = True
          Glyph.Data = {
            36040000424D3604000000000000360000002800000010000000100000000100
            2000000000000004000000000000000000000000000000000000FF00FF00FF00
            FF0046819A0046819A0046819A0046819A0046819A0046819A003B6F8800305E
            7700305E7700305E7700305E7700305E7700305E7700FF00FF00FF00FF004681
            9A0072BEDB006FBAD7006FBAD7006FBAD7006FBAD70072BEDB0046819A004C9E
            C5004D9FC6004D9FC6004D9FC6004D9FC6004D9FC600305E7700FF00FF004883
            9B0071BEDA006FBAD6006FBAD6006FBAD6006FBAD60071BEDA0046819A00BFBF
            BF00BFBFBF00BFBFBF00BFBFBF00BFBFBF00BFBFBF0033607900FF00FF004D85
            9E0074C2DD0072BED90072BED90072BED90072BED90074C2DD0046819A00F6F6
            F600F6F6F600F6F6F600F5F5F500F5F5F500BFBFBF0039657E00FF00FF00538B
            A10077C6E00075C2DC0075C2DC0075C2DC0075C2DC0077C5E00046819A00E9D0
            BA00E9D0BA00E9D0BA00E9D0BA00E9D0BA00BFBFBF00406C8300FF00FF005A8F
            A4007ACAE30078C6DF0078C6DF0078C6DF0078C6DF0079C9E3004A849C00F9F9
            F900F9F9F900F8F8F800F8F8F800F7F7F700BFBFBF0049728900FF00FF006294
            A8007CCEE6007BCAE2007BCAE2007BCAE2007BCAE2007CCEE60050889F00D3C4
            B400E9D0BA00E9D0BA00E9D0BA00E9D0BA00BFBFBF00517A9000FF00FF006A9B
            AD007FD2E9007ECEE5007ECEE5007ECEE5007ECEE5007FD0E7007BC4DA00558B
            A200F4F6F600FBFBFB00FAFAFA00FAFAFA00BFBFBF00FF00FF00FF00FF0073A0
            B10082D6EC0081D2E80081D2E80081D2E80081D2E80081D2E80082D4EA0080CD
            E3005A8FA400E9D0BA00E9D0BA00E9D0BA00BFBFBF00FF00FF00FF00FF007CA6
            B50085D9EF0084D6EB0084D6EB0084D6EB0084D6EB0084D6EB0084D6EB0085DC
            F1006294A900FCFCFC00FCFCFC00FCFCFC00BFBFBF00FF00FF00FF00FF0083AC
            BA0087DDF20087DAEE0087DAEE0087DAEE0087DAEE0087DAEE0087DAEE0087DE
            F2006A9AAD00BFBFBF00BFBFBF00BFBFBF00BFBFBF00FF00FF00FF00FF008BB2
            BE008AE1F5008ADEF1008ADEF1008ADEF1008ADEF1008ADEF1008ADEF1008AE2
            F50072A0B100BFBFBF00EAEAEA00D9D9D900BFBFBF00FF00FF00FF00FF0091B6
            C1008CE5F8008CE2F4008CE2F4008CE2F4008CE2F4008CE2F4008CE2F4008CE6
            F8007BA6B500BFBFBF00D9D9D900BFBFBF00FF00FF00FF00FF00FF00FF0098BA
            C50090E9FB0090E6F70090E6F70090E6F70090E6F70090E6F70090E6F70090E9
            FB0084ACBA00BFBFBF00BFBFBF0096B4C200FF00FF00FF00FF00FF00FF009CBD
            C60091F2FF0092EEFE0092EEFE0092EEFE0092EEFE0092EEFE0092EEFE0091F2
            FF008BB1BE00A2DFF900A1DFF9009EBBC700FF00FF00FF00FF00FF00FF00FF00
            FF009DBEC7009DBEC7009DBEC70099BCC50097BAC40097BAC30095B8C30094B7
            C2009BBBC600A3BFCB00A3BFCC00FF00FF00FF00FF00FF00FF00}
        end
        object Label_SIS_VA_CHAVEDEINSTALACAO: TLabel
          Left = 285
          Top = 47
          Width = 166
          Height = 13
          Caption = 'Chave de instala'#231#227'o deste sistema'
        end
        object DBEdit_SIS_VA_NOME: TDBEdit
          Left = 8
          Top = 20
          Width = 271
          Height = 21
          Anchors = [akLeft, akBottom]
          CharCase = ecUpperCase
          DataField = 'VA_NOME'
          DataSource = DataModule_Principal.DataSource_SIS
          TabOrder = 0
        end
        object DBEdit_SIS_VA_DIRETORIO: TDBEdit
          Left = 285
          Top = 20
          Width = 394
          Height = 21
          Anchors = [akLeft, akBottom]
          CharCase = ecUpperCase
          DataField = 'VA_DIRETORIO'
          DataSource = DataModule_Principal.DataSource_SIS
          TabOrder = 1
        end
        object DBEdit_SIS_VA_DESCRICAO: TDBEdit
          Left = 8
          Top = 61
          Width = 271
          Height = 21
          Anchors = [akLeft, akBottom]
          CharCase = ecUpperCase
          DataField = 'VA_DESCRICAO'
          DataSource = DataModule_Principal.DataSource_SIS
          TabOrder = 2
        end
        object DBEdit_SIS_VA_CHAVEDEINSTALACAO: TDBEdit
          Left = 285
          Top = 61
          Width = 481
          Height = 21
          CharCase = ecUpperCase
          DataField = 'VA_CHAVEDEINSTALACAO'
          DataSource = DataModule_Principal.DataSource_SIS
          TabOrder = 3
        end
      end
      object DBNavigator_Sistemas: TDBNavigator
        AlignWithMargins = True
        Left = 6
        Top = 191
        Width = 774
        Height = 23
        Margins.Left = 6
        Margins.Right = 6
        DataSource = DataModule_Principal.DataSource_SIS
        Align = alBottom
        Hints.Strings = (
          'Primeiro registro'
          'Registro anterior'
          'Pr'#243'ximo registro'
          #218'ltimo registro'
          'Inserir registro'
          'Excluir registro'
          'Editar registro'
          'Confirmar opera'#231#227'o'
          'Cancelar opera'#231#227'o'
          'Atualizar')
        TabOrder = 3
        OnClick = DBNavigator_SistemasClick
      end
    end
    object TabSheet_Arquivos: TTabSheet
      Caption = 'Arquivos'
      ImageIndex = 2
      object Panel_Arquivos: TPanel
        AlignWithMargins = True
        Left = 6
        Top = 6
        Width = 774
        Height = 41
        Margins.Left = 6
        Margins.Top = 6
        Margins.Right = 6
        Align = alTop
        BevelInner = bvLowered
        Color = clInfoBk
        ParentBackground = False
        TabOrder = 0
        object Label_Arquivos: TLabel
          AlignWithMargins = True
          Left = 8
          Top = 2
          Width = 758
          Height = 37
          Margins.Left = 6
          Margins.Top = 0
          Margins.Right = 6
          Margins.Bottom = 0
          Align = alClient
          Alignment = taCenter
          Caption = 
            'Para cada sistema sendo monitorado arquivos s'#227'o detectados dentr' +
            'o do diret'#243'rio de monitormento. Os arquivos de cada sistema s'#227'o ' +
            'vistos com caminhos completos que ser'#227'o criados ou usados nas m'#225 +
            'quinas clientes. Os caminhos podem conter constantes que ser'#227'o s' +
            'ubstitu'#237'das nas m'#225'quinas clientes.'
          Transparent = True
          Layout = tlCenter
          WordWrap = True
          ExplicitWidth = 741
          ExplicitHeight = 26
        end
      end
      object ZTODBGrid_ArquivosSistemas: TZTODBGrid
        AlignWithMargins = True
        Left = 6
        Top = 53
        Width = 242
        Height = 256
        Margins.Left = 6
        Margins.Bottom = 6
        Align = alLeft
        DataSource = DataModule_Principal.DataSource_SIS
        Options = [dgTitles, dgColLines, dgRowLines, dgRowSelect, dgAlwaysShowSelection, dgConfirmDelete, dgCancelOnExit]
        OptionsEx = []
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
        SortArrow.Column = 'BI_SISTEMAS_ID'
        Columns = <
          item
            Alignment = taCenter
            Expanded = False
            FieldName = 'VA_NOME'
            Title.Alignment = taCenter
            Title.Caption = 'Sistema'
            Width = 220
            Visible = True
          end>
      end
      object Panel_ArquivosInfo: TPanel
        AlignWithMargins = True
        Left = 254
        Top = 53
        Width = 526
        Height = 256
        Margins.Right = 6
        Margins.Bottom = 6
        Align = alClient
        BevelOuter = bvNone
        TabOrder = 2
        object Panel_Exclusoes: TPanel
          AlignWithMargins = True
          Left = 0
          Top = 35
          Width = 526
          Height = 199
          Margins.Left = 0
          Margins.Right = 0
          Margins.Bottom = 1
          Align = alClient
          BevelOuter = bvNone
          TabOrder = 2
          Visible = False
          object ZTODBGrid_Exclusoes: TZTODBGrid
            AlignWithMargins = True
            Left = 0
            Top = 31
            Width = 526
            Height = 148
            Margins.Left = 0
            Margins.Right = 0
            Margins.Bottom = 0
            Align = alClient
            DataSource = DataModule_Principal.DataSource_EXC
            Options = [dgTitles, dgIndicator, dgColLines, dgRowLines, dgTabs, dgRowSelect, dgAlwaysShowSelection, dgCancelOnExit]
            OptionsEx = [dgAllowTitleClick, dgAutomaticColumSizes]
            ReadOnly = True
            TabOrder = 0
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
            VariableWidthColumns = '<VA_CAMINHOCOMPLETO>'
            Columns = <
              item
                Expanded = False
                FieldName = 'VA_CAMINHOCOMPLETO'
                Width = 486
                Visible = True
              end>
          end
          object DBNavigator_EXC_Exclusoes: TDBNavigator
            AlignWithMargins = True
            Left = 0
            Top = 0
            Width = 526
            Height = 25
            Margins.Left = 0
            Margins.Top = 0
            Margins.Right = 0
            DataSource = DataModule_Principal.DataSource_EXC
            VisibleButtons = [nbFirst, nbPrior, nbNext, nbLast, nbInsert, nbDelete, nbCancel]
            Align = alTop
            Hints.Strings = (
              'Primeiro registro'
              'Registro anterior'
              'Pr'#243'ximo registro'
              #218'ltimo registro'
              'Inserir registro'
              'Excluir registro'
              'Editar registro'
              'Confirmar opera'#231#227'o'
              'Cancelar opera'#231#227'o'
              'Atualizar')
            ConfirmDelete = False
            TabOrder = 1
          end
          object StatusBar_Exclusoes: TStatusBar
            AlignWithMargins = True
            Left = 0
            Top = 179
            Width = 526
            Height = 19
            Margins.Left = 0
            Margins.Top = 0
            Margins.Right = 0
            Margins.Bottom = 1
            Panels = <
              item
                Width = 50
              end>
            SimplePanel = True
            SizeGrip = False
          end
        end
        object Panel_LegendasEConstantes: TPanel
          AlignWithMargins = True
          Left = 0
          Top = 35
          Width = 526
          Height = 199
          Margins.Left = 0
          Margins.Right = 0
          Margins.Bottom = 1
          Align = alClient
          BevelOuter = bvNone
          TabOrder = 4
          Visible = False
          object RichEdit_Constantes: TRichEdit
            Left = 0
            Top = 0
            Width = 526
            Height = 199
            Margins.Left = 0
            Margins.Right = 0
            Margins.Bottom = 1
            Align = alClient
            ReadOnly = True
            ScrollBars = ssVertical
            TabOrder = 0
          end
        end
        object Panel_ArquivosLista: TPanel
          AlignWithMargins = True
          Left = 0
          Top = 35
          Width = 526
          Height = 199
          Margins.Left = 0
          Margins.Right = 0
          Margins.Bottom = 1
          Align = alClient
          BevelOuter = bvNone
          Caption = 'Panel_ArquivosLista'
          TabOrder = 1
          object ZTODBGrid_Arquivos: TZTODBGrid
            AlignWithMargins = True
            Left = 0
            Top = 31
            Width = 526
            Height = 148
            Margins.Left = 0
            Margins.Right = 0
            Margins.Bottom = 0
            Align = alClient
            DataSource = DataModule_Principal.DataSource_ARQ
            Options = [dgTitles, dgIndicator, dgColLines, dgRowLines, dgRowSelect, dgAlwaysShowSelection, dgCancelOnExit, dgMultiSelect]
            OptionsEx = [dgPersistentSelection, dgAutomaticColumSizes]
            ReadOnly = True
            TabOrder = 0
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
            SortArrow.Column = 'BI_SISTEMAS_ID'
            VariableWidthColumns = '<VA_CAMINHOCOMPLETO>'
            Columns = <
              item
                Expanded = False
                FieldName = 'VA_CAMINHOCOMPLETO'
                Title.Caption = 'Caminho completo do arquivo na m'#225'quina cliente'
                Width = 321
                Visible = True
              end
              item
                Expanded = False
                FieldName = 'DT_DATAEHORA'
                Title.Alignment = taCenter
                Title.Caption = 'Modificado em'
                Width = 150
                Visible = True
              end>
          end
          object DBNavigator_Arquivos: TDBNavigator
            AlignWithMargins = True
            Left = 0
            Top = 0
            Width = 526
            Height = 25
            Margins.Left = 0
            Margins.Top = 0
            Margins.Right = 0
            DataSource = DataModule_Principal.DataSource_ARQ
            VisibleButtons = [nbFirst, nbPrior, nbNext, nbLast, nbDelete, nbRefresh]
            Align = alTop
            Hints.Strings = (
              'Primeiro registro'
              'Registro anterior'
              'Pr'#243'ximo registro'
              #218'ltimo registro'
              'Inserir registro'
              'Excluir registro'
              'Editar registro'
              'Confirmar opera'#231#227'o'
              'Cancelar opera'#231#227'o'
              'Atualizar')
            ConfirmDelete = False
            TabOrder = 1
          end
          object StatusBar_Arquivos: TStatusBar
            AlignWithMargins = True
            Left = 0
            Top = 179
            Width = 526
            Height = 19
            Margins.Left = 0
            Margins.Top = 0
            Margins.Right = 0
            Margins.Bottom = 1
            Panels = <
              item
                Width = 50
              end>
            SimplePanel = True
            SizeGrip = False
          end
        end
        object Panel_ArquivosCaminho: TPanel
          AlignWithMargins = True
          Left = 0
          Top = 0
          Width = 526
          Height = 29
          Margins.Left = 0
          Margins.Top = 0
          Margins.Right = 0
          Align = alTop
          BevelInner = bvLowered
          Color = clInfoBk
          ParentBackground = False
          TabOrder = 0
          object DBText_CaminhoDoSistema: TDBText
            Left = 2
            Top = 2
            Width = 522
            Height = 25
            Hint = 'Este '#233' o diret'#243'rio sendo monitorado para o sistema selecionado'
            Align = alClient
            Alignment = taCenter
            DataField = 'VA_DIRETORIO'
            DataSource = DataModule_Principal.DataSource_SIS
            ParentShowHint = False
            ShowHint = True
            WordWrap = True
            ExplicitLeft = 180
            ExplicitTop = 12
            ExplicitWidth = 65
            ExplicitHeight = 17
          end
        end
        object TabSet_Arquivos: TTabSet
          Left = 0
          Top = 235
          Width = 526
          Height = 21
          Align = alBottom
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'Tahoma'
          Font.Style = []
          SoftTop = True
          Style = tsSoftTabs
          Tabs.Strings = (
            'Arquivos && Caminhos'
            'Exclus'#245'es'
            'Legenda de constantes')
          TabIndex = 0
          OnChange = TabSet_ArquivosChange
        end
      end
    end
    object TabSheet_Usuarios: TTabSheet
      Caption = 'Usu'#225'rios'
      ImageIndex = 3
      object Panel_Usuarios: TPanel
        AlignWithMargins = True
        Left = 6
        Top = 6
        Width = 774
        Height = 41
        Margins.Left = 6
        Margins.Top = 6
        Margins.Right = 6
        Align = alTop
        BevelInner = bvLowered
        Color = clInfoBk
        ParentBackground = False
        TabOrder = 0
        object Label_Usuarios: TLabel
          AlignWithMargins = True
          Left = 8
          Top = 2
          Width = 758
          Height = 37
          Margins.Left = 6
          Margins.Top = 0
          Margins.Right = 6
          Margins.Bottom = 0
          Align = alClient
          Alignment = taCenter
          Caption = 
            'Apenas usu'#225'rios autorizados podem acessar este servidor FTP. Al'#233 +
            'm disso, cada usu'#225'rio possui direitos de acesso a diret'#243'rios esp' +
            'ec'#237'ficos dentro do servidor, de acordo com cada sistema sendo mo' +
            'nitorado'
          Transparent = True
          Layout = tlCenter
          WordWrap = True
          ExplicitHeight = 26
        end
      end
      object Panel1: TPanel
        AlignWithMargins = True
        Left = 6
        Top = 220
        Width = 774
        Height = 89
        Margins.Left = 6
        Margins.Right = 6
        Margins.Bottom = 6
        Align = alBottom
        BevelInner = bvLowered
        TabOrder = 1
        DesignSize = (
          774
          89)
        object Label_USU_VA_NOME: TLabel
          Left = 8
          Top = 6
          Width = 27
          Height = 13
          Anchors = [akLeft, akBottom]
          Caption = 'Nome'
          Color = clAppWorkSpace
          FocusControl = DBEdit_USU_VA_NOME
          ParentColor = False
          Transparent = True
        end
        object Label_USU_VA_LOGIN: TLabel
          Left = 263
          Top = 6
          Width = 25
          Height = 13
          Anchors = [akLeft, akBottom]
          Caption = 'Login'
          Color = clAppWorkSpace
          FocusControl = DBEdit_USU_VA_LOGIN
          ParentColor = False
          Transparent = True
        end
        object Label_USU_VA_EMAIL: TLabel
          Left = 8
          Top = 47
          Width = 24
          Height = 13
          Anchors = [akLeft, akBottom]
          Caption = 'Email'
          Color = clMedGray
          FocusControl = DBEdit_USU_VA_EMAIL
          ParentColor = False
          Transparent = True
        end
        object Label_USU_VA_SENHA: TLabel
          Left = 518
          Top = 6
          Width = 30
          Height = 13
          Anchors = [akLeft, akBottom]
          Caption = 'Senha'
          Color = clAppWorkSpace
          FocusControl = DBEdit_USU_VA_SENHA
          ParentColor = False
          Transparent = True
        end
        object DBEdit_USU_VA_NOME: TDBEdit
          Left = 8
          Top = 20
          Width = 249
          Height = 21
          Anchors = [akLeft, akBottom]
          CharCase = ecUpperCase
          DataField = 'VA_NOME'
          DataSource = DataModule_Principal.DataSource_USU
          TabOrder = 0
        end
        object DBEdit_USU_VA_LOGIN: TDBEdit
          Left = 263
          Top = 20
          Width = 249
          Height = 21
          Anchors = [akLeft, akBottom]
          CharCase = ecUpperCase
          DataField = 'VA_LOGIN'
          DataSource = DataModule_Principal.DataSource_USU
          TabOrder = 1
        end
        object DBEdit_USU_VA_EMAIL: TDBEdit
          Left = 8
          Top = 61
          Width = 663
          Height = 21
          Anchors = [akLeft, akBottom]
          DataField = 'VA_EMAIL'
          DataSource = DataModule_Principal.DataSource_USU
          TabOrder = 3
        end
        object DBEdit_USU_VA_SENHA: TDBEdit
          Left = 518
          Top = 20
          Width = 248
          Height = 21
          Anchors = [akLeft, akBottom]
          DataField = 'VA_SENHA'
          DataSource = DataModule_Principal.DataSource_USU
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'Tahoma'
          Font.Style = [fsBold]
          ParentFont = False
          PasswordChar = #248
          TabOrder = 2
        end
        object DBCheckBox_USU_BO_ADMINISTRADOR: TDBCheckBox
          Left = 677
          Top = 65
          Width = 89
          Height = 13
          Caption = #201' superusu'#225'rio'
          DataField = 'BO_ADMINISTRADOR'
          DataSource = DataModule_Principal.DataSource_USU
          TabOrder = 4
          ValueChecked = '1'
          ValueUnchecked = '0'
        end
      end
      object Panel_UsuariosDosSistemas: TPanel
        AlignWithMargins = True
        Left = 6
        Top = 53
        Width = 774
        Height = 130
        Margins.Left = 6
        Margins.Right = 6
        Align = alClient
        BevelOuter = bvNone
        Caption = 'Panel_UsuariosDosSistemas'
        TabOrder = 2
        object ZTODBGrid_Usuarios: TZTODBGrid
          AlignWithMargins = True
          Left = 0
          Top = 0
          Width = 526
          Height = 130
          Margins.Left = 0
          Margins.Top = 0
          Margins.Bottom = 0
          Align = alClient
          DataSource = DataModule_Principal.DataSource_USU
          Options = [dgTitles, dgIndicator, dgColLines, dgRowLines, dgRowSelect, dgAlwaysShowSelection, dgConfirmDelete, dgCancelOnExit]
          OptionsEx = []
          TabOrder = 0
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
          SortArrow.Column = 'BI_SISTEMAS_ID'
          Columns = <
            item
              Expanded = False
              FieldName = 'VA_NOME'
              Title.Caption = 'Nome'
              Width = 307
              Visible = True
            end
            item
              Alignment = taCenter
              Expanded = False
              FieldName = 'VA_LOGIN'
              Title.Alignment = taCenter
              Title.Caption = 'Login'
              Width = 178
              Visible = True
            end>
        end
        object ZTODBGrid_SistemasDosUsuarios: TZTODBGrid
          AlignWithMargins = True
          Left = 532
          Top = 0
          Width = 242
          Height = 130
          Margins.Top = 0
          Margins.Right = 0
          Margins.Bottom = 0
          Align = alRight
          DataSource = DataModule_Principal.DataSource_SDU
          Options = [dgTitles, dgIndicator, dgColLines, dgRowLines, dgRowSelect, dgAlwaysShowSelection, dgConfirmDelete, dgCancelOnExit, dgMultiSelect]
          OptionsEx = [dgPersistentSelection]
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
          SortArrow.Column = 'BI_SISTEMAS_ID'
          OnAfterMultiselect = ZTODBGrid_SistemasDosUsuariosAfterMultiselect
          Columns = <
            item
              Alignment = taCenter
              Expanded = False
              FieldName = 'VA_NOME'
              Title.Alignment = taCenter
              Title.Caption = 'Sistemas autorizados'
              Width = 187
              Visible = True
            end>
        end
      end
      object Panel_UsuariosNavigators: TPanel
        AlignWithMargins = True
        Left = 6
        Top = 189
        Width = 774
        Height = 25
        Margins.Left = 6
        Margins.Right = 6
        Align = alBottom
        BevelOuter = bvNone
        TabOrder = 3
        object DBNavigator_Usuarios: TDBNavigator
          AlignWithMargins = True
          Left = 0
          Top = 0
          Width = 526
          Height = 25
          Margins.Left = 0
          Margins.Top = 0
          Margins.Bottom = 0
          DataSource = DataModule_Principal.DataSource_USU
          Align = alClient
          Hints.Strings = (
            'Primeiro registro'
            'Registro anterior'
            'Pr'#243'ximo registro'
            #218'ltimo registro'
            'Inserir registro'
            'Excluir registro'
            'Editar registro'
            'Confirmar opera'#231#227'o'
            'Cancelar opera'#231#227'o'
            'Atualizar')
          ParentShowHint = False
          ShowHint = True
          TabOrder = 0
        end
        object BitBtn_Adicionar: TBitBtn
          AlignWithMargins = True
          Left = 532
          Top = 0
          Width = 118
          Height = 25
          Margins.Top = 0
          Margins.Bottom = 0
          Action = DataModule_Principal.Action_SDU_Adicionar
          Align = alRight
          Caption = 'Adicionar'
          TabOrder = 1
          Glyph.Data = {
            36080000424D3608000000000000360000002800000020000000100000000100
            2000000000000008000000000000000000000000000000000000FF00FF00FF00
            FF00FF00FF00FF00FF00FF00FF00FF00FF00015B0200015B0200015B0200015B
            0200FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00
            FF00FF00FF00FF00FF00FF00FF00FF00FF003737370037373700373737003737
            3700FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00
            FF00FF00FF00FF00FF00FF00FF00FF00FF00015B020004E00A0003E30900015B
            0200FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00
            FF00FF00FF00FF00FF00FF00FF00FF00FF0037373700898989008B8B8B003737
            3700FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00
            FF00FF00FF00FF00FF00FF00FF00FF00FF00015B020004DC0B0004E00A00015B
            0200FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00
            FF00FF00FF00FF00FF00FF00FF00FF00FF003737370087878700898989003737
            3700FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00
            FF00FF00FF00FF00FF00FF00FF00FF00FF00015B020005D80C0004DC0B00015B
            0200FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00
            FF00FF00FF00FF00FF00FF00FF00FF00FF003737370085858500878787003737
            3700FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00
            FF00FF00FF00FF00FF00FF00FF00FF00FF000155020005D50E0005D80C00015B
            0200FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00
            FF00FF00FF00FF00FF00FF00FF00FF00FF003333330084848400858585003737
            3700FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00
            FF00FF00FF00FF00FF00FF00FF00FF00FF000155020005D10F0005D50E00015B
            0200FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00
            FF00FF00FF00FF00FF00FF00FF00FF00FF003333330082828200848484003737
            3700FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00015B0200015B
            0200015B0200015B0200015B0200015502000155020006CD100005D10F000155
            0200015B0200015B0200015B0200015B0200015B0200015B0200373737003737
            3700373737003737370037373700333333003333330080808000828282003333
            3300373737003737370037373700373737003737370037373700015B020009B5
            190009B8170008BC160008BF150007C3140007C6130006CA110006CD100005D1
            0F0005D50E0005D80C0004DC0B0004E00A0003E30900015B0200373737007575
            75007676760078787800797979007B7B7B007D7D7D007E7E7E00808080008282
            8200848484008585850087878700898989008B8B8B0037373700015B02000AB1
            1A0009B5190009B8170008BC160008BF150007C3140007C6130006CA110006CD
            100005D10F0005D50E0005D80C0004DC0B0004E00A00015B0200373737007373
            7300757575007676760078787800797979007B7B7B007D7D7D007E7E7E008080
            8000828282008484840085858500878787008989890037373700015B0200015B
            0200015B0200015B0200015B0200015B0200015B020007C3140007C61300015B
            0200015B0200015B0200015B0200015B0200015B0200015B0200373737003737
            370037373700373737003737370037373700373737007B7B7B007D7D7D003737
            3700373737003737370037373700373737003737370037373700FF00FF00FF00
            FF00FF00FF00FF00FF00FF00FF00FF00FF00015B020008BF150007C31400015B
            0200FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00
            FF00FF00FF00FF00FF00FF00FF00FF00FF0037373700797979007B7B7B003737
            3700FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00
            FF00FF00FF00FF00FF00FF00FF00FF00FF00015B020008BC160008BF1500015B
            0200FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00
            FF00FF00FF00FF00FF00FF00FF00FF00FF003737370078787800797979003737
            3700FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00
            FF00FF00FF00FF00FF00FF00FF00FF00FF00015B020009B8170008BC1600015B
            0200FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00
            FF00FF00FF00FF00FF00FF00FF00FF00FF003737370076767600787878003737
            3700FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00
            FF00FF00FF00FF00FF00FF00FF00FF00FF00015B020009B5190009B81700015B
            0200FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00
            FF00FF00FF00FF00FF00FF00FF00FF00FF003737370075757500767676003737
            3700FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00
            FF00FF00FF00FF00FF00FF00FF00FF00FF00015B02000AB11A0009B51900015B
            0200FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00
            FF00FF00FF00FF00FF00FF00FF00FF00FF003737370073737300757575003737
            3700FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00
            FF00FF00FF00FF00FF00FF00FF00FF00FF00015B0200015B0200015B0200015B
            0200FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00
            FF00FF00FF00FF00FF00FF00FF00FF00FF003737370037373700373737003737
            3700FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00}
          Layout = blGlyphRight
          NumGlyphs = 2
          Spacing = 45
        end
        object BitBtn_Remover: TBitBtn
          AlignWithMargins = True
          Left = 656
          Top = 0
          Width = 118
          Height = 25
          Margins.Top = 0
          Margins.Right = 0
          Margins.Bottom = 0
          Action = DataModule_Principal.Action_SDU_Remover
          Align = alRight
          Caption = 'Remover'
          TabOrder = 2
          Glyph.Data = {
            36080000424D3608000000000000360000002800000020000000100000000100
            2000000000000008000000000000000000000000000000000000FF00FF00FF00
            FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00
            FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00
            FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00
            FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00
            FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00
            FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00
            FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00
            FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00
            FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00
            FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00
            FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00
            FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00
            FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00
            FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00
            FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00
            FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00
            FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00
            FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00
            FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00
            FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00
            FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00
            FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00
            FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00
            FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00015B0200015B
            0200015B0200015B0200015B0200015B0200015B0200015B0200015B0200015B
            0200015B0200015B0200015B0200015B0200015B0200015B0200373737003737
            3700373737003737370037373700373737003737370037373700373737003737
            3700373737003737370037373700373737003737370037373700015B020009B5
            190009B8170008BC160008BF150007C3140007C6130006CA110006CD100005D1
            0F0005D50E0005D80C0004DC0B0004E00A0003E30900015B0200373737007575
            75007676760078787800797979007B7B7B007D7D7D007E7E7E00808080008282
            8200848484008585850087878700898989008B8B8B0037373700015B02000AB1
            1A0009B5190009B8170008BC160008BF150007C3140007C6130006CA110006CD
            100005D10F0005D50E0005D80C0004DC0B0004E00A00015B0200373737007373
            7300757575007676760078787800797979007B7B7B007D7D7D007D7E7E008080
            8000828282008484840085858500878787008989890037373700015B0200015B
            0200015B0200015B0200015B0200015B0200015B0200015B0200015B0200015B
            0200015B0200015B0200015B0200015B0200015B0200015B0200373737003737
            3700373737003737370037373700373737003737370037373700373737003737
            3700373737003737370037373700373737003737370037373700FF00FF00FF00
            FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00
            FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00
            FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00
            FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00
            FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00
            FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00
            FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00
            FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00
            FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00
            FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00
            FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00
            FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00
            FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00
            FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00
            FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00
            FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00
            FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00
            FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00
            FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00
            FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00
            FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00
            FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00
            FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00
            FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00}
          Layout = blGlyphRight
          NumGlyphs = 2
          Spacing = 47
        end
      end
    end
  end
  object ActionManager_Principal: TActionManager
    ActionBars = <
      item
        Items = <
          item
            Items = <
              item
                Action = DataModule_Principal.Action_DesativarServidor
              end
              item
                Action = DataModule_Principal.Action_AtivarServidor
              end
              item
                Caption = '-'
              end
              item
                Action = DataModule_Principal.Action_MinimizeToTray
              end>
            Caption = '&Servidor'
          end
          item
            Items = <
              item
                Action = DataModule_Principal.Action_ConfigurarServidor
              end>
            Caption = '&Configura'#231#245'es'
          end
          item
            Items = <
              item
                Action = DataModule_Principal.Action_Sobre
              end>
            Caption = '&Ajuda'
          end>
        ActionBar = ActionMainMenuBar_Principal
      end>
    LinkedActionLists = <
      item
        ActionList = DataModule_Principal.ActionList_Principal
        Caption = 'ActionList_Principal'
      end>
    Left = 738
    StyleName = 'XP Style'
    object Action_SalvarELimparLog: TAction
      Caption = 'Salvar e limpar este log'
      OnExecute = Action_SalvarELimparLogExecute
    end
  end
  object BalloonToolTip_Principal: TBalloonToolTip
    ParseLinks = False
    AutoGetTexts = False
    MaxWidth = 320
    BackColor = 14811135
    ForeColor = clBlack
    VisibleTime = 3000
    DelayTime = 1000
    TipTitle = 'Erro de valida'#231#227'o...'
    TipText = 
      'Voc'#234' esqueceu de por um texto. Configure a propriedade TipText c' +
      'orretamente'
    TipIcon = tiError
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
    Left = 766
  end
end
