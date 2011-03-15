inherited XXXForm_AdminModule: TXXXForm_AdminModule
  Caption = 'Administra'#231#227'o && permiss'#245'es de usu'#225'rios e grupos'
  ClientHeight = 666
  ClientWidth = 1015
  ExplicitWidth = 1015
  ExplicitHeight = 666
  DesignSize = (
    1015
    666)
  PixelsPerInch = 96
  TextHeight = 13
  inherited PanelTitulo: TPanel
    Width = 1015
    ExplicitWidth = 1015
    DesignSize = (
      1015
      26)
    inherited Shape_HeaderBackground: TShape
      Width = 1016
      ExplicitWidth = 1016
    end
    inherited Shape_HeaderLine: TShape
      Width = 988
      ExplicitWidth = 988
    end
    inherited Image_CloseModule: TImage
      Left = 992
      ExplicitLeft = 992
    end
    inherited Shape_HeaderLineVertical: TShape
      Left = 988
      ExplicitLeft = 988
    end
  end
  object PageControl_Administration: TPageControl [1]
    Left = 0
    Top = 26
    Width = 1015
    Height = 640
    ActivePage = TabSheet_Permissions
    Align = alClient
    TabOrder = 1
    OnChanging = DoChanging
    object TabSheet_Permissions: TTabSheet
      Caption = 'Permiss'#245'es'
      DesignSize = (
        1007
        612)
      object GroupBoxPermissoesDoGrupo: TGroupBox
        Left = 5
        Top = 233
        Width = 997
        Height = 375
        Anchors = [akLeft, akTop, akRight, akBottom]
        Caption = ' Entidades e permiss'#245'es do grupo selecionado '
        TabOrder = 2
        Visible = False
        DesignSize = (
          997
          375)
        object CFDBGrid_PDG_Right: TCFDBGrid
          Left = 701
          Top = 76
          Width = 288
          Height = 292
          Anchors = [akTop, akRight, akBottom]
          DataSource = XXXDataModule_Administration.DataSource_PDG
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'Tahoma'
          Font.Style = []
          Options = [dgTitles, dgColLines, dgRowLines, dgTabs, dgRowSelect, dgAlwaysShowSelection, dgConfirmDelete, dgCancelOnExit]
          OptionsEx = [dgHideVerticalScrollBar, dgAutomaticColumSizes]
          ParentFont = False
          ReadOnly = True
          TabOrder = 2
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
          VariableWidthColumns = '<TI_LER><TI_INSERIR><TI_ALTERAR><TI_EXCLUIR>'
          OnCellClick = CFDBGrid_PDG_RightCellClick
          OnDrawColumnCell = DoDrawColumnCell
          OnKeyPress = CFDBGrid_PDG_RightKeyPress
          Columns = <
            item
              Alignment = taCenter
              Color = clInfoBk
              Expanded = False
              FieldName = 'TI_LER'
              Title.Alignment = taCenter
              Title.Caption = 'Acessar'
              Width = 70
              Visible = True
            end
            item
              Alignment = taCenter
              Expanded = False
              FieldName = 'TI_INSERIR'
              Title.Alignment = taCenter
              Title.Caption = 'Inserir'
              Width = 70
              Visible = True
            end
            item
              Alignment = taCenter
              Color = clInfoBk
              Expanded = False
              FieldName = 'TI_ALTERAR'
              Title.Alignment = taCenter
              Title.Caption = 'Alterar'
              Width = 70
              Visible = True
            end
            item
              Alignment = taCenter
              Expanded = False
              FieldName = 'TI_EXCLUIR'
              Title.Alignment = taCenter
              Title.Caption = 'Excluir'
              Width = 70
              Visible = True
            end>
        end
        object GroupBoxGrupoConsultaRapida2: TGroupBox
          Left = 8
          Top = 13
          Width = 720
          Height = 57
          Anchors = [akLeft, akTop, akRight]
          Caption = ' Localiza'#231#227'o r'#225'pida '
          TabOrder = 0
          DesignSize = (
            720
            57)
          object LabelGrupoConsultarTipoDaEntidade: TLabel
            Left = 616
            Top = 13
            Width = 20
            Height = 13
            Anchors = [akTop, akRight]
            Caption = 'Tipo'
          end
          object LabelE2: TLabel
            Left = 603
            Top = 31
            Width = 6
            Height = 13
            Anchors = [akTop, akRight]
            Caption = 'e'
            ExplicitLeft = 313
          end
          object ComboBox_PDG_TI_TIPO: TComboBox
            Left = 616
            Top = 27
            Width = 96
            Height = 21
            Style = csDropDownList
            Anchors = [akTop, akRight]
            ItemHeight = 13
            ItemIndex = 0
            TabOrder = 1
            Text = 'Todos'
            OnChange = DoChange_PDG
            Items.Strings = (
              'Todos'
              'Tabela'
              'A'#231#227'o')
          end
          object LabeledEdit_PDG_VA_NOME: TLabeledEdit
            Left = 8
            Top = 27
            Width = 588
            Height = 21
            Anchors = [akLeft, akTop, akRight]
            CharCase = ecUpperCase
            EditLabel.Width = 137
            EditLabel.Height = 13
            EditLabel.Caption = 'Nome / Identifica'#231#227'o cont'#233'm'
            LabelSpacing = 1
            TabOrder = 0
            OnChange = DoChange_PDG
          end
        end
        object GroupBoxGrupoLegenda: TGroupBox
          Left = 734
          Top = 13
          Width = 255
          Height = 57
          Anchors = [akTop, akRight]
          Caption = ' Legenda '
          TabOrder = 3
          object ImageGrupoSim: TImage
            Left = 8
            Top = 13
            Width = 16
            Height = 16
            AutoSize = True
            Picture.Data = {
              07544269746D6170F6000000424DF60000000000000076000000280000001000
              000010000000010004000000000080000000120B0000120B0000100000000000
              000000000000000080000080000000808000800000008000800080800000C0C0
              C000808080000000FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFF
              FF00333333333333333333334433333333333334224333333333334222243333
              333334222222433333334222A22224333333222A3A2224333333A2A333A22243
              33333A33333A2224333333333333A2224333333333333A2224333333333333A2
              224333333333333A2224333333333333A2243333333333333A22333333333333
              33A3}
            Transparent = True
          end
          object ImageGrupoNao: TImage
            Left = 141
            Top = 13
            Width = 16
            Height = 16
            AutoSize = True
            Picture.Data = {
              07544269746D6170F6000000424DF60000000000000076000000280000001000
              000010000000010004000000000080000000120B0000120B0000100000000000
              000000000000000080000080000000808000800000008000800080800000C0C0
              C000808080000000FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFF
              FF00333338888883333333388111111883333381119999111833391199333311
              1183391133333811118391183333811191189183333811193918918333811193
              3918918338111933391891838111933339189118111933339118391111933333
              9183391118333381118333911188881118333339911111199333333339999993
              3333}
            Transparent = True
          end
          object LabelGrupoSim: TLabel
            Left = 27
            Top = 14
            Width = 99
            Height = 13
            Caption = 'Permiss'#227'o concedida'
          end
          object LabelGrupoNao: TLabel
            Left = 160
            Top = 14
            Width = 87
            Height = 13
            Caption = 'Permiss'#227'o negada'
          end
          object ImageGrupoNaoSeAplica: TImage
            Left = 56
            Top = 34
            Width = 16
            Height = 16
            AutoSize = True
            Picture.Data = {
              07544269746D617036030000424D360300000000000036000000280000001000
              000010000000010018000000000000030000120B0000120B0000000000000000
              0000FF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FF
              FF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00
              FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF
              00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FF
              FF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00
              FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF
              00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FF
              FF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00
              FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF
              00FFFF00FF008080008080008080008080008080008080008080008080008080
              008080008080008080008080008080FF00FF00808000C8C800C8C800C8C800C8
              C800C8C800C8C800C8C800C8C800C8C800C8C800C8C800C8C800C8C800C8C800
              808000FFFF00C8C800C8C800C8C800C8C800C8C800C8C800C8C800C8C800C8C8
              00C8C800C8C800C8C800C8C800C8C800FFFFFF00FF00FFFF00FFFF00FFFF00FF
              FF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFFFF
              00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FF
              FF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00
              FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF
              00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FF
              FF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00
              FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF
              00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FF
              FF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00
              FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF
              00FF}
            Transparent = True
          end
          object LabelGrupoNaoSeAplica: TLabel
            Left = 75
            Top = 36
            Width = 123
            Height = 13
            Caption = 'A permiss'#227'o n'#227'o se aplica'
          end
        end
        object CFDBGrid_PDG_Left: TCFDBGrid
          Left = 8
          Top = 76
          Width = 687
          Height = 292
          Anchors = [akLeft, akTop, akRight, akBottom]
          DataSource = XXXDataModule_Administration.DataSource_PDG
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'Tahoma'
          Font.Style = []
          Options = [dgTitles, dgColLines, dgRowLines, dgTabs, dgRowSelect, dgAlwaysShowSelection, dgConfirmDelete, dgCancelOnExit]
          OptionsEx = [dgAutomaticColumSizes]
          ParentFont = False
          PopupMenu = XXXDataModule_Administration.PopupActionBar_PDG
          ReadOnly = True
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
          VariableWidthColumns = '<NOME>'
          Columns = <
            item
              Expanded = False
              FieldName = 'NOME'
              Title.Caption = 'Identifica'#231#227'o'
              Width = 624
              Visible = True
            end
            item
              Alignment = taCenter
              Expanded = False
              FieldName = 'TIPO'
              Title.Alignment = taCenter
              Title.Caption = 'Tipo'
              Visible = True
            end>
        end
      end
      object GroupBoxPermissoesDoUsuario: TGroupBox
        Left = 5
        Top = 233
        Width = 997
        Height = 375
        Anchors = [akLeft, akTop, akRight, akBottom]
        Caption = ' Entidades e permiss'#245'es do usu'#225'rio selecionado '
        TabOrder = 1
        DesignSize = (
          997
          375)
        object CFDBGrid_PDU_Right: TCFDBGrid
          Left = 701
          Top = 76
          Width = 288
          Height = 292
          Anchors = [akTop, akRight, akBottom]
          DataSource = XXXDataModule_Administration.DataSource_PDU
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'Tahoma'
          Font.Style = []
          Options = [dgTitles, dgColLines, dgRowLines, dgTabs, dgRowSelect, dgAlwaysShowSelection, dgConfirmDelete, dgCancelOnExit]
          OptionsEx = [dgHideVerticalScrollBar, dgAutomaticColumSizes]
          ParentFont = False
          ReadOnly = True
          TabOrder = 2
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
          VariableWidthColumns = '<TI_LER><TI_INSERIR><TI_ALTERAR><TI_EXCLUIR>'
          OnCellClick = CFDBGrid_PDU_RightCellClick
          OnDrawColumnCell = DoDrawColumnCell
          Columns = <
            item
              Alignment = taCenter
              Color = clInfoBk
              Expanded = False
              FieldName = 'TI_LER'
              Title.Alignment = taCenter
              Title.Caption = 'Acessar'
              Width = 70
              Visible = True
            end
            item
              Alignment = taCenter
              Expanded = False
              FieldName = 'TI_INSERIR'
              Title.Alignment = taCenter
              Title.Caption = 'Inserir'
              Width = 70
              Visible = True
            end
            item
              Alignment = taCenter
              Color = clInfoBk
              Expanded = False
              FieldName = 'TI_ALTERAR'
              Title.Alignment = taCenter
              Title.Caption = 'Alterar'
              Width = 70
              Visible = True
            end
            item
              Alignment = taCenter
              Expanded = False
              FieldName = 'TI_EXCLUIR'
              Title.Alignment = taCenter
              Title.Caption = 'Excluir'
              Width = 70
              Visible = True
            end>
        end
        object GroupBoxUsuarioConsultaRapida2: TGroupBox
          Left = 8
          Top = 13
          Width = 720
          Height = 57
          Anchors = [akLeft, akTop, akRight]
          Caption = ' Localiza'#231#227'o r'#225'pida '
          TabOrder = 0
          DesignSize = (
            720
            57)
          object LabelTipo2: TLabel
            Left = 615
            Top = 13
            Width = 20
            Height = 13
            Anchors = [akTop, akRight]
            Caption = 'Tipo'
          end
          object LabelE: TLabel
            Left = 602
            Top = 31
            Width = 6
            Height = 13
            Anchors = [akTop, akRight]
            Caption = 'e'
          end
          object ComboBox_PDU_TI_TIPO: TComboBox
            Left = 615
            Top = 27
            Width = 97
            Height = 21
            Style = csDropDownList
            Anchors = [akTop, akRight]
            ItemHeight = 13
            ItemIndex = 0
            TabOrder = 1
            Text = 'Todos'
            OnChange = DoChange_PDU
            Items.Strings = (
              'Todos'
              'Tabela'
              'A'#231#227'o')
          end
          object LabeledEdit_PDU_VA_NOME: TLabeledEdit
            Left = 8
            Top = 27
            Width = 588
            Height = 21
            Anchors = [akLeft, akTop, akRight]
            CharCase = ecUpperCase
            EditLabel.Width = 137
            EditLabel.Height = 13
            EditLabel.Caption = 'Nome / Identifica'#231#227'o cont'#233'm'
            LabelSpacing = 1
            TabOrder = 0
            OnChange = DoChange_PDU
          end
        end
        object GroupBoxUsuarioLegenda: TGroupBox
          Left = 734
          Top = 13
          Width = 255
          Height = 57
          Anchors = [akTop, akRight]
          Caption = ' Legenda '
          TabOrder = 3
          object ImageUsuarioSim: TImage
            Left = 8
            Top = 13
            Width = 16
            Height = 16
            AutoSize = True
            Picture.Data = {
              07544269746D6170F6000000424DF60000000000000076000000280000001000
              000010000000010004000000000080000000120B0000120B0000100000000000
              000000000000000080000080000000808000800000008000800080800000C0C0
              C000808080000000FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFF
              FF00333333333333333333334433333333333334224333333333334222243333
              333334222222433333334222A22224333333222A3A2224333333A2A333A22243
              33333A33333A2224333333333333A2224333333333333A2224333333333333A2
              224333333333333A2224333333333333A2243333333333333A22333333333333
              33A3}
            Transparent = True
          end
          object LabelUsuarioAutorizado: TLabel
            Left = 27
            Top = 14
            Width = 99
            Height = 13
            Caption = 'Permiss'#227'o concedida'
          end
          object LabelUsuarioDesaltoriza: TLabel
            Left = 160
            Top = 14
            Width = 87
            Height = 13
            Caption = 'Permiss'#227'o negada'
          end
          object ImageUsuarioNaoAplicavel: TImage
            Left = 56
            Top = 34
            Width = 16
            Height = 16
            AutoSize = True
            Picture.Data = {
              07544269746D617036030000424D360300000000000036000000280000001000
              000010000000010018000000000000030000120B0000120B0000000000000000
              0000FF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FF
              FF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00
              FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF
              00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FF
              FF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00
              FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF
              00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FF
              FF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00
              FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF
              00FFFF00FF008080008080008080008080008080008080008080008080008080
              008080008080008080008080008080FF00FF00808000C8C800C8C800C8C800C8
              C800C8C800C8C800C8C800C8C800C8C800C8C800C8C800C8C800C8C800C8C800
              808000FFFF00C8C800C8C800C8C800C8C800C8C800C8C800C8C800C8C800C8C8
              00C8C800C8C800C8C800C8C800C8C800FFFFFF00FF00FFFF00FFFF00FFFF00FF
              FF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFFFF
              00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FF
              FF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00
              FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF
              00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FF
              FF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00
              FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF
              00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FF
              FF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00
              FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF
              00FF}
            Transparent = True
          end
          object LabelUsuarioNaoAplicavel: TLabel
            Left = 75
            Top = 36
            Width = 123
            Height = 13
            Caption = 'A permiss'#227'o n'#227'o se aplica'
          end
          object ImageUsuarioNao: TImage
            Left = 141
            Top = 13
            Width = 16
            Height = 16
            AutoSize = True
            Picture.Data = {
              07544269746D6170F6000000424DF60000000000000076000000280000001000
              000010000000010004000000000080000000120B0000120B0000100000000000
              000000000000000080000080000000808000800000008000800080800000C0C0
              C000808080000000FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFF
              FF00333338888883333333388111111883333381119999111833391199333311
              1183391133333811118391183333811191189183333811193918918333811193
              3918918338111933391891838111933339189118111933339118391111933333
              9183391118333381118333911188881118333339911111199333333339999993
              3333}
            Transparent = True
          end
        end
        object CFDBGrid_PDU_Left: TCFDBGrid
          Left = 8
          Top = 76
          Width = 687
          Height = 292
          Anchors = [akLeft, akTop, akRight, akBottom]
          DataSource = XXXDataModule_Administration.DataSource_PDU
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'Tahoma'
          Font.Style = []
          Options = [dgTitles, dgColLines, dgRowLines, dgTabs, dgRowSelect, dgAlwaysShowSelection, dgConfirmDelete, dgCancelOnExit]
          OptionsEx = [dgAutomaticColumSizes]
          ParentFont = False
          PopupMenu = XXXDataModule_Administration.PopupActionBar_PDU
          ReadOnly = True
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
          VariableWidthColumns = '<NOME>'
          Columns = <
            item
              Expanded = False
              FieldName = 'NOME'
              Title.Caption = 'Identifica'#231#227'o'
              Width = 624
              Visible = True
            end
            item
              Alignment = taCenter
              Expanded = False
              FieldName = 'TIPO'
              Title.Alignment = taCenter
              Title.Caption = 'Tipo'
              Visible = True
            end>
        end
      end
      object GroupBoxEntidadesDoSistema: TGroupBox
        Left = 360
        Top = 2
        Width = 642
        Height = 228
        Anchors = [akLeft, akTop, akRight]
        Caption = ' Entidades do sistema '
        TabOrder = 3
        DesignSize = (
          642
          228)
        object CFDBGrid_EDS: TCFDBGrid
          Left = 8
          Top = 77
          Width = 626
          Height = 112
          Anchors = [akLeft, akTop, akRight]
          DataSource = XXXDataModule_Administration.DataSource_EDS
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'Tahoma'
          Font.Style = []
          Options = [dgTitles, dgIndicator, dgColLines, dgRowLines, dgTabs, dgRowSelect, dgConfirmDelete, dgCancelOnExit, dgMultiSelect]
          OptionsEx = [dgAutomaticColumSizes]
          ParentFont = False
          PopupMenu = XXXDataModule_Administration.PopupActionBar_RecordInformation
          ReadOnly = True
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
          VariableWidthColumns = '<VA_NOME>'
          Columns = <
            item
              Expanded = False
              FieldName = 'VA_NOME'
              Title.Caption = 'Identifica'#231#227'o'
              Width = 521
              Visible = True
            end
            item
              Alignment = taCenter
              Expanded = False
              FieldName = 'TIPO'
              Title.Alignment = taCenter
              Title.Caption = 'Tipo'
              Width = 50
              Visible = True
            end>
        end
        object GroupBoxFiltro: TGroupBox
          Left = 8
          Top = 13
          Width = 626
          Height = 57
          Anchors = [akLeft, akTop, akRight]
          Caption = ' Localiza'#231#227'o r'#225'pida '
          TabOrder = 0
          DesignSize = (
            626
            57)
          object LabelTipo: TLabel
            Left = 522
            Top = 13
            Width = 20
            Height = 13
            Anchors = [akTop, akRight]
            Caption = 'Tipo'
          end
          object Label2: TLabel
            Left = 508
            Top = 31
            Width = 6
            Height = 13
            Anchors = [akTop, akRight]
            Caption = 'e'
          end
          object ComboBox_EDS_TI_TIPO: TComboBox
            Left = 520
            Top = 27
            Width = 98
            Height = 21
            Style = csDropDownList
            Anchors = [akTop, akRight]
            ItemHeight = 13
            ItemIndex = 0
            TabOrder = 1
            Text = 'Todos'
            OnChange = DoChange_EDS
            Items.Strings = (
              'Todos'
              'Tabela'
              'A'#231#227'o')
          end
          object LabeledEdit_EDS_VA_NOME: TLabeledEdit
            Left = 8
            Top = 27
            Width = 494
            Height = 21
            Anchors = [akLeft, akTop, akRight]
            CharCase = ecUpperCase
            EditLabel.Width = 137
            EditLabel.Height = 13
            EditLabel.Caption = 'Nome / Identifica'#231#227'o cont'#233'm'
            LabelSpacing = 1
            TabOrder = 0
            OnChange = DoChange_EDS
          end
        end
        object BitBtn_EDS_Inserir: TBitBtn
          Left = 8
          Top = 195
          Width = 112
          Height = 25
          Action = XXXDataModule_Administration.Action_EDS_Insert
          Caption = 'Nova entidade...'
          TabOrder = 2
          Glyph.Data = {
            36080000424D3608000000000000360000002800000020000000100000000100
            2000000000000008000000000000000000000000000000000000FF00FF00FF00
            FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00
            FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00
            FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00
            FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00CB660100CB66
            0100CB660100CB660100CB660100CB660100CB660100FF00FF00FF00FF00FF00
            FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00787878007878
            78007878780078787800787878007878780078787800FF00FF00FF00FF00FF00
            FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FEFAF500FEF9
            F200FEF4E800FEEEDC00FEEAD300FEE7D300CB660100FF00FF00FF00FF00FF00
            FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00EAEAEA00E9E9
            E900E5E5E500E0E0E000DCDCDC00D8D8D8008C8C8C00FF00FF00FF00FF00FF00
            FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FEFAF500FEFA
            F500FEF6EC00FEF2E300FEECD800FEE7D300CB660100FF00FF00FF00FF00FF00
            FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00EAEAEA00EAEA
            EA00E7E7E700E3E3E300DEDEDE00DBDBDB008C8C8C00FF00FF00FF00FF00FF00
            FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FEFAF500FEFA
            F500FEF8F100FEF4E800FEEEDC00FEEAD300CB660100FF00FF00FF00FF00FF00
            FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00EAEAEA00EAEA
            EA00E9E9E900E5E5E500E1E1E100DCDCDC008C8C8C00FF00FF00FF00FF00FF00
            FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00983500009835
            000098350000983500009835000098350000CB660100FF00FF00FF00FF00FF00
            FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF008C8C8C008C8C
            8C008C8C8C008C8C8C008C8C8C008C8C8C008C8C8C00FF00FF00FF00FF00FF00
            FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00
            FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF0003640000FF00
            FF00CB6601009835000098350000983500009835000098350000FF00FF00FF00
            FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF0064646400FF00
            FF008C8C8C007878780078787800787878007878780078787800FF00FF00FF00
            FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF000364000003640000FF00
            FF00CB660100FEF9F200FEF4E800FEEEDC00FEEAD300FEE7D300FF00FF00FF00
            FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF006464640064646400FF00
            FF008C8C8C00E9E9E900E5E5E500E0E0E000DCDCDC00D8D8D800FF00FF00FF00
            FF00FF00FF00FF00FF00FF00FF00FF00FF0003640000A28B730003640000FF00
            FF00CB660100FEFAF500FEF6EC00FEF2E300FEECD800FEE7D300FF00FF00FF00
            FF00FF00FF00FF00FF00FF00FF00FF00FF0064646400ADADAD0064646400FF00
            FF008C8C8C00EAEAEA00E7E7E700E3E3E300DEDEDE00DBDBDB00FF00FF00FF00
            FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF000364000003640000FF00
            FF00CB660100FEFAF500FEF8F100FEF4E800FEEEDC00FEEAD300FF00FF00FF00
            FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF006464640064646400FF00
            FF008C8C8C00EAEAEA00E9E9E900E5E5E500E1E1E100DCDCDC00FF00FF00FF00
            FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF0003640000FF00
            FF00CB6601009835000098350000983500009835000098350000FF00FF00FF00
            FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF0064646400FF00
            FF008C8C8C007878780078787800787878007878780078787800983500009835
            000098350000983500009835000098350000CB660100FF00FF00FF00FF00FF00
            FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00787878007878
            78007878780078787800787878007878780078787800FF00FF00FF00FF00FF00
            FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FEFAF500FEF9
            F200FEF4E800FEEEDC00FEEAD300FEE7D300CB660100FF00FF00FF00FF00FF00
            FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00EAEAEA00E9E9
            E900E5E5E500E0E0E000DCDCDC00D8D8D8008C8C8C00FF00FF00FF00FF00FF00
            FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FEFAF500FEFA
            F500FEF6EC00FEF2E300FEECD800FEE7D300CB660100FF00FF00FF00FF00FF00
            FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00EAEAEA00EAEA
            EA00E7E7E700E3E3E300DEDEDE00DBDBDB008C8C8C00FF00FF00FF00FF00FF00
            FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FEFAF500FEFA
            F500FEF8F100FEF4E800FEEEDC00FEEAD300CB660100FF00FF00FF00FF00FF00
            FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00EAEAEA00EAEA
            EA00E9E9E900E5E5E500E1E1E100DCDCDC008C8C8C00FF00FF00FF00FF00FF00
            FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00CB660100CB66
            0100CB660100CB660100CB660100CB660100CB660100FF00FF00FF00FF00FF00
            FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF008C8C8C008C8C
            8C008C8C8C008C8C8C008C8C8C008C8C8C008C8C8C00FF00FF00FF00FF00FF00
            FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00}
          Layout = blGlyphRight
          NumGlyphs = 2
          Spacing = 0
        end
        object BitBtn_EDS_Excluir: TBitBtn
          Left = 265
          Top = 195
          Width = 112
          Height = 25
          Action = XXXDataModule_Administration.Action_EDS_Delete
          Anchors = [akTop]
          Caption = 'Excluir entidade'
          TabOrder = 3
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
            FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00CB670300CB67
            0300CB670300CB670300CB670300CB670300CB670300CB670300CB670300FF00
            FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00989898009898
            980098989800989898009898980098989800989898009898980098989800FF00
            FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FEFCF900FEFB
            F800FEF8F000FEF4E800FEF1E100FEEDDA00FEEAD300FDE7CD00CB670300FF00
            FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00EBE9E600EBE9
            E600EBE9E600EBE9E600EBE9E600EBE9E600EBE9E600EBE9E60098989800FF00
            FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FEFCF900FEFC
            F900FEF9F300FEF6ED00FEF2E400FEEEDC00FEEBD400FDE7CD00CB670300FF00
            FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00EBE9E600EBE9
            E600EBE9E600EBE9E600EBE9E600EBE9E600EBE9E600EBE9E60098989800FF00
            FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FEFCF900FEFC
            F900FEFAF600FEF7EE00FEF3E600FEF0DF00FEECD700FDE9D100CB670300FF00
            FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00EBE9E600EBE9
            E600EBE9E600EBE9E600EBE9E600EBE9E600EBE9E600EBE9E60098989800FF00
            FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF009A3400009A34
            00009A3400009A3400009A3400009A3400009A3400009A3400009A3400009A34
            00009A340000CB670300FF00FF0003620300FF00FF00FF00FF007E7E7E007E7E
            7E007E7E7E007E7E7E007E7E7E007E7E7E007E7E7E007E7E7E007E7E7E007E7E
            7E007E7E7E0098989800FF00FF0065656500FF00FF00FF00FF00FEFCF900FEFC
            F900FEFAF600FEF8F000FEF5EA00FEF2E400FEF0DF00FEECD800FEEAD300FDE7
            CD00FCE6CB00CB670300FF00FF000362030003620300FF00FF00EBE9E600EBE9
            E600EBE9E600EBE9E600EBE9E600EBE9E600EBE9E600EBE9E600EBE9E600EBE9
            E600EBE9E60083838300FF00FF006565650065656500FF00FF00FEFCF900FEFC
            F900FEFAF600FEF9F300FEF6ED00FEF3E600FEF1E100FEEDDA00FEEBD400FDE8
            CF00FCE6CB00CB670300FF00FF00036203009A9A9A0003620300EBE9E600EBE9
            E600EBE9E600EBE9E600EBE9E600EBE9E600EBE9E600EBE9E600EBE9E600EBE9
            E600EBE9E60083838300FF00FF0065656500EBE9E60065656500FEFCF900FEFC
            F900FEFBF800FEF9F300FEF7EE00FEF4E800FEF1E100FEEEDC00FEEBD400FDE9
            D100FDE7CD00CB670300FF00FF000362030003620300FF00FF00EBE9E600EBE9
            E600EBE9E600EBE9E600EBE9E600EBE9E600EBE9E600EBE9E600EBE9E600EBE9
            E600EBE9E60083838300FF00FF006565650065656500FF00FF009A3400009A34
            00009A3400009A3400009A3400009A3400009A3400009A3400009A3400009A34
            00009A340000CB670300FF00FF0003620300FF00FF00FF00FF007E7E7E007E7E
            7E007E7E7E007E7E7E007E7E7E007E7E7E007E7E7E007E7E7E007E7E7E007E7E
            7E007E7E7E0098989800FF00FF0065656500FF00FF00FF00FF00FEFCF900FEFC
            F900FEFAF600FEF7EE00FEF2E400FEEEDC00FEEBD400FDE7CD00CB670300FF00
            FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00EBE9E600EBE9
            E600EBE9E600EBE9E600EBE9E600EBE9E600EBE9E600EBE9E60098989800FF00
            FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FEFCF900FEFC
            F900FEFBF800FEF8F000FEF4E800FEF0DF00FEECD700FDE8CF00CB670300FF00
            FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00EBE9E600EBE9
            E600EBE9E600EBE9E600EBE9E600EBE9E600EBE9E600EBE9E60098989800FF00
            FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FEFCF900FEFC
            F900FEFCF900FEFAF600FEF6ED00FEF2E400FEEDDA00FEEBD400CB670300FF00
            FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00EBE9E600EBE9
            E600EBE9E600EBE9E600EBE9E600EBE9E600EBE9E600EBE9E60098989800FF00
            FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00CB670300CB67
            0300CB670300CB670300CB670300CB670300CB670300CB670300CB670300FF00
            FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00989898009898
            980098989800989898009898980098989800989898009898980098989800FF00
            FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00
            FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00
            FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00
            FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00
            FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00}
          Layout = blGlyphRight
          NumGlyphs = 2
          Spacing = 7
        end
        object BitBtn_EDS_AdicionarA: TBitBtn
          Left = 522
          Top = 195
          Width = 112
          Height = 25
          Action = XXXDataModule_Administration.Action_PDU_PDG_Insert
          Anchors = [akTop, akRight]
          Caption = 'Adic. p/ usu'#225'rio'
          TabOrder = 4
          Glyph.Data = {
            36080000424D3608000000000000360000002800000020000000100000000100
            2000000000000008000000000000000000000000000000000000FF00FF00FF00
            FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00
            FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00
            FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00
            FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00
            FF0084614F00BA9C8400C09A7D00C0977800C0937200C0947300895D4E00FF00
            FF00FF00FF00FF00FF00004D0000FF00FF00FF00FF00FF00FF00FF00FF00FF00
            FF005F5F5F009797970095959500919191008D8D8D008E8E8E005C5C5C00FF00
            FF00FF00FF00FF00FF002E2E2E00FF00FF00FF00FF00FF00FF00FF00FF00FF00
            FF008C5C5A00F4E2CE00FFDEC100FFD6B000FFD0A200FFCC9E0090585800FF00
            FF00FF00FF0000500000069C1800005B0100FF00FF00FF00FF00FF00FF00FF00
            FF0060606000DDDDDD00D8D8D800CECECE00C6C6C600C3C3C3005D5D5D00FF00
            FF00FF00FF00303030006565650036363600FF00FF00FF00FF00FF00FF00FF00
            FF008F5F5B00F7EBDD00FFE4CC00FFDDBF00FFD6B000FFD3A90091585800FF00
            FF00004F00001094350012AB3A000999220000580100FF00FF00FF00FF00FF00
            FF0062626200E8E8E800DFDFDF00D7D7D700CECECE00CACACA005D5D5D00FF00
            FF002F2F2F006A6A6A00797979006666660035353500FF00FF00FF00FF00FF00
            FF009F6C6000FAF5EE00FFEDDA00FFE4CC00FFDEC100FFDBB90078564B00004A
            0000004B0000046310001BB1510009761F00004B0000004B0000FF00FF00FF00
            FF006D6D6D00F3F3F300E9E9E900DFDFDF00D8D8D800D4D4D400565656002C2C
            2C002D2D2D004040400085858500515151002D2D2D002D2D2D00906B5300D8B9
            9A00B37D6800FBFCFB00FFF5EB00FFECDA00FFE4CC00FFE2C60091585800FF00
            FF00FF00FF00006202001BB15100006F0400FF00FF00FF00FF0067676700B2B2
            B2007C7C7C00FBFBFB00F3F3F300E8E8E800DFDFDF00DCDCDC005D5D5D00FF00
            FF00FF00FF003B3B3B008585850043434300FF00FF00FF00FF00A06D6100F7E7
            D500CB916E00FDFFFF00FFFFFE00FFF5EB00FFEDDA00F39E950090585800FF00
            FF00FF00FF00005601001BB1510000640200FF00FF00FF00FF006E6E6E00E3E3
            E3008C8C8C00FEFEFE00FEFEFE00F3F3F300E9E9E900A3A3A3005D5D5D00FF00
            FF00FF00FF0033333300858585003C3C3C00FF00FF00FF00FF00AC766600F8F0
            E500DFA27600FFFFFF00FFFFFF00FDFFFF00FBF7EF0092554F00A2745500FF00
            FF00FF00FF00005201001BB15100005B0100FF00FF00FF00FF0076767600EDED
            ED009A9A9A00FFFFFF00FFFFFF00FEFEFE00F5F5F500595959006F6F6F00FF00
            FF00FF00FF00313131008585850036363600FF00FF00FF00FF00B7816A00FAF8
            F200EEAF7B00CF916D00D1936E00D1936E00D1936E00A5775600FF00FF00FF00
            FF00FF00FF00005201001BB1510000520100FF00FF00FF00FF007F7F7F00F6F6
            F600A5A5A5008C8C8C008E8E8E008E8E8E008E8E8E0071717100FF00FF00FF00
            FF00FF00FF00313131008585850031313100FF00FF00FF00FF00C38A6C00FAFC
            FB00FFF9F100FFF2E200FFEAD400FFE6CA0099605600FF00FF00FF00FF00FF00
            FF00FF00FF00004B000021A24700004B0000FF00FF00FF00FF0086868600FBFB
            FB00F7F7F700EEEEEE00E5E5E500E0E0E00062626200FF00FF00FF00FF00FF00
            FF00FF00FF002D2D2D00797979002D2D2D00FF00FF00FF00FF00CF967000FEFF
            FF00FFFFFE00FFF5EB00FFEDDA00F3A398009D635800FF00FF00FF00FF00FF00
            FF00FF00FF00004B000025873400004B0000FF00FF00FF00FF0090909000FEFE
            FE00FEFEFE00F3F3F300E9E9E900A7A7A70065656500FF00FF00FF00FF00FF00
            FF00FF00FF002D2D2D00646464002D2D2D00FF00FF00FF00FF00DA9E7500FFFF
            FF00FFFFFF00FDFFFF00FBF7EF009D5F4E00A87A5500FF00FF00FF00FF00FF00
            FF00FF00FF00004B00000A5D0C00004B0000FF00FF00FF00FF0097979700FFFF
            FF00FFFFFF00FEFEFE00F5F5F5006060600073737300FF00FF00FF00FF00FF00
            FF00FF00FF002D2D2D003C3C3C002D2D2D00FF00FF00FF00FF00E3A67800CF91
            6D00D1936E00D1936E00D1936E00AC7D5700FF00FF00FF00FF00FF00FF00FF00
            FF00FF00FF00004B0000004B0000004B0000FF00FF00FF00FF009E9E9E008C8C
            8C008E8E8E008E8E8E008E8E8E0076767600FF00FF00FF00FF00FF00FF00FF00
            FF00FF00FF002D2D2D002D2D2D002D2D2D00FF00FF00FF00FF00FF00FF00FF00
            FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00
            FF00FF00FF00FF00FF00004B0000FF00FF00FF00FF00FF00FF00FF00FF00FF00
            FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00
            FF00FF00FF00FF00FF002D2D2D00FF00FF00FF00FF00FF00FF00FF00FF00FF00
            FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00
            FF00FF00FF00FF00FF00004B0000FF00FF00FF00FF00FF00FF00FF00FF00FF00
            FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00
            FF00FF00FF00FF00FF002D2D2D00FF00FF00FF00FF00FF00FF00FF00FF00FF00
            FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00
            FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00
            FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00
            FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00}
          Layout = blGlyphRight
          NumGlyphs = 2
          Spacing = 8
        end
      end
      object PageControl_USU_GRU_Consultar: TPageControl
        Left = 5
        Top = 2
        Width = 349
        Height = 228
        ActivePage = TabSheet_USU_Consultar
        TabOrder = 0
        OnChange = PageControl_USU_GRU_ConsultarChange
        object TabSheet_USU_Consultar: TTabSheet
          Caption = 'Usu'#225'rios'
          DesignSize = (
            341
            200)
          object GroupBoxUsuarioConsultaRapida: TGroupBox
            Left = 5
            Top = 3
            Width = 331
            Height = 57
            Anchors = [akLeft, akTop, akRight]
            Caption = ' Localiza'#231#227'o r'#225'pida '
            TabOrder = 0
            DesignSize = (
              331
              57)
            object Label3: TLabel
              Left = 211
              Top = 31
              Width = 12
              Height = 13
              Anchors = [akTop, akRight]
              Caption = 'ou'
            end
            object LabeledEdit_USU_VA_NOME: TLabeledEdit
              Left = 8
              Top = 27
              Width = 197
              Height = 21
              Anchors = [akLeft, akTop, akRight]
              CharCase = ecUpperCase
              EditLabel.Width = 27
              EditLabel.Height = 13
              EditLabel.Caption = 'Nome'
              LabelSpacing = 1
              TabOrder = 0
              OnChange = LabeledEdit_USU_VA_NOMEChange
              OnEnter = LabeledEdit_USU_VA_NOMEEnter
            end
            object LabeledEdit_USU_VA_LOGIN: TLabeledEdit
              Left = 229
              Top = 27
              Width = 94
              Height = 21
              Anchors = [akTop, akRight]
              CharCase = ecUpperCase
              EditLabel.Width = 25
              EditLabel.Height = 13
              EditLabel.Caption = 'Login'
              LabelSpacing = 1
              TabOrder = 1
              OnChange = LabeledEdit_USU_VA_LOGINChange
              OnEnter = LabeledEdit_USU_VA_LOGINEnter
            end
          end
          object DBGrid_USU_Consultar: TCFDBGrid
            Left = 5
            Top = 66
            Width = 331
            Height = 128
            Anchors = [akLeft, akTop, akRight, akBottom]
            DataSource = XXXDataModule_Administration.DataSource_USU
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clWindowText
            Font.Height = -11
            Font.Name = 'Tahoma'
            Font.Style = []
            Options = [dgTitles, dgColLines, dgRowLines, dgTabs, dgRowSelect, dgAlwaysShowSelection, dgConfirmDelete, dgCancelOnExit]
            OptionsEx = [dgAutomaticColumSizes]
            ParentFont = False
            PopupMenu = XXXDataModule_Administration.PopupActionBar_RecordInformation
            ReadOnly = True
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
            VariableWidthColumns = '<VA_NOME>'
            Columns = <
              item
                Expanded = False
                FieldName = 'VA_NOME'
                Title.Caption = 'Nome'
                Width = 228
                Visible = True
              end
              item
                Expanded = False
                FieldName = 'VA_LOGIN'
                Title.Alignment = taCenter
                Title.Caption = 'Login'
                Width = 80
                Visible = True
              end>
          end
        end
        object TabSheet_GRU_Consultar: TTabSheet
          Caption = 'Grupos'
          ImageIndex = 1
          DesignSize = (
            341
            200)
          object GroupBoxGrupoConsultaRapida: TGroupBox
            Left = 5
            Top = 3
            Width = 331
            Height = 57
            Anchors = [akLeft, akTop, akRight]
            Caption = ' Localiza'#231#227'o r'#225'pida '
            TabOrder = 0
            DesignSize = (
              331
              57)
            object LabeledEdit_GRU_VA_NOME: TLabeledEdit
              Left = 8
              Top = 27
              Width = 315
              Height = 21
              Anchors = [akLeft, akTop, akRight]
              CharCase = ecUpperCase
              EditLabel.Width = 27
              EditLabel.Height = 13
              EditLabel.Caption = 'Nome'
              LabelSpacing = 1
              TabOrder = 0
              OnChange = LabeledEdit_GRU_VA_NOMEChange
            end
          end
          object DBGrid_GRU_Consultar: TCFDBGrid
            Left = 5
            Top = 66
            Width = 331
            Height = 128
            Anchors = [akLeft, akTop, akRight, akBottom]
            DataSource = XXXDataModule_Administration.DataSource_GRU
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clWindowText
            Font.Height = -11
            Font.Name = 'Tahoma'
            Font.Style = []
            Options = [dgTitles, dgColLines, dgRowLines, dgTabs, dgRowSelect, dgAlwaysShowSelection, dgConfirmDelete, dgCancelOnExit]
            OptionsEx = [dgAutomaticColumSizes]
            ParentFont = False
            PopupMenu = XXXDataModule_Administration.PopupActionBar_RecordInformation
            ReadOnly = True
            TabOrder = 1
            TitleFont.Charset = DEFAULT_CHARSET
            TitleFont.Color = clWindowText
            TitleFont.Height = -11
            TitleFont.Name = 'Tahoma'
            TitleFont.Style = [fsBold]
            RowColors = <
              item
                BackgroundColor = clBtnFace
                ForegroundColor = clBtnText
              end>
            VariableWidthColumns = '<VA_NOME>'
            Columns = <
              item
                Expanded = False
                FieldName = 'VA_NOME'
                Title.Caption = 'Nome'
                Width = 309
                Visible = True
              end>
          end
        end
      end
    end
    object TabSheet_USU: TTabSheet
      Caption = 'Gerenciamento de usu'#225'rios'
      ImageIndex = 1
      DesignSize = (
        1007
        612)
      object GroupBoxUsuariosConsultar2: TGroupBox
        Left = 5
        Top = 2
        Width = 997
        Height = 57
        Anchors = [akLeft, akTop, akRight]
        Caption = ' Localiza'#231#227'o r'#225'pida '
        TabOrder = 0
        DesignSize = (
          997
          57)
        object LabelE3: TLabel
          Left = 873
          Top = 31
          Width = 12
          Height = 13
          Anchors = [akTop, akRight]
          Caption = 'ou'
        end
        object LabeledEdit_USU_VA_NOME2: TLabeledEdit
          Left = 8
          Top = 27
          Width = 859
          Height = 21
          Anchors = [akLeft, akTop, akRight]
          CharCase = ecUpperCase
          EditLabel.Width = 27
          EditLabel.Height = 13
          EditLabel.Caption = 'Nome'
          LabelSpacing = 1
          TabOrder = 0
          OnChange = LabeledEdit_USU_VA_NOME2Change
          OnEnter = LabeledEdit_USU_VA_NOME2Enter
        end
        object LabeledEdit_USU_VA_LOGIN2: TLabeledEdit
          Left = 891
          Top = 27
          Width = 98
          Height = 21
          Anchors = [akTop, akRight]
          CharCase = ecUpperCase
          EditLabel.Width = 25
          EditLabel.Height = 13
          EditLabel.Caption = 'Login'
          LabelSpacing = 1
          TabOrder = 1
          OnChange = LabeledEdit_USU_VA_LOGIN2Change
          OnEnter = LabeledEdit_USU_VA_LOGIN2Enter
        end
      end
      object Panel_USU_Layer: TPanel
        Left = 721
        Top = 65
        Width = 281
        Height = 22
        Anchors = [akTop, akRight]
        BevelOuter = bvNone
        ParentColor = True
        TabOrder = 2
        DesignSize = (
          281
          22)
        object SpeedButton_USU_Delete: TSpeedButton
          Tag = 5
          Left = 143
          Top = 0
          Width = 22
          Height = 22
          Action = XXXDataModule_Administration.Action_USU_Delete
          Anchors = [akTop]
          Flat = True
          Glyph.Data = {
            36080000424D3608000000000000360000002800000020000000100000000100
            2000000000000008000000000000000000000000000000000000FF00FF000000
            0000000000000000000000000000000000000000000000000000000000000000
            00000000000000000000000000000000000000000000FF00FF00FF00FF000000
            0000000000000000000000000000000000000000000000000000000000000000
            00000000000000000000000000000000000000000000FF00FF00000000000000
            FF000000FF000000FF000000FF000000FF000000FF000000FF000000FF000000
            FF000000FF000000FF000000FF000000FF000000FF0000000000000000004C4C
            4C004C4C4C004C4C4C004C4C4C004C4C4C004C4C4C004C4C4C004C4C4C004C4C
            4C004C4C4C004C4C4C004C4C4C004C4C4C004C4C4C0000000000000000000000
            EF000000EF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
            FF00FFFFFF00FFFFFF00FFFFFF000000EF000000EF0000000000000000004747
            470047474700FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
            FF00FFFFFF00FFFFFF00FFFFFF00474747004747470000000000000000000000
            DF000000DF000000DF000000DF000000DF000000DF000000DF000000DF000000
            DF000000DF000000DF000000DF000000DF000000DF0000000000000000004343
            4300434343004343430043434300434343004343430043434300434343004343
            4300434343004343430043434300434343004343430000000000000000000000
            CF000000CF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
            FF00FFFFFF00FFFFFF00FFFFFF000000CF000000CF0000000000000000003E3E
            3E003E3E3E00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
            FF00FFFFFF00FFFFFF00FFFFFF003E3E3E003E3E3E0000000000000000000000
            C0000000C0000000C0000000C0000000C0000000C0000000C0000000C0000000
            C0000000C0000000C0000000C0000000C0000000C00000000000000000003939
            3900393939003939390039393900393939003939390039393900393939003939
            3900393939003939390039393900393939003939390000000000000000000000
            B0000000B0000000B0000000B0000000B0000000B0000000B0000000B0000000
            B0000000B0000000B0000000B0000000B0000000B00000000000000000003535
            3500353535003535350035353500353535003535350035353500353535003535
            3500353535003535350035353500353535003535350000000000000000000000
            A0000000A0000000A0000000A0000000A0000000A0000000A0000000A0000000
            A0000000A0000000A0000000A0000000A0000000A00000000000000000003030
            3000303030003030300030303000303030003030300030303000303030003030
            3000303030003030300030303000303030003030300000000000000000000000
            A0000000A0000000A0000000A0000000A0000000A0000000A0000000A0000000
            A0000000A0000000A0000000A0000000A0000000A00000000000000000003030
            3000303030003030300030303000303030003030300030303000303030003030
            3000303030003030300030303000303030003030300000000000000000000000
            B0000000B0000000B000FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
            FF00FFFFFF00FFFFFF000000B0000000B0000000B00000000000000000003535
            35003535350035353500FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
            FF00FFFFFF00FFFFFF0035353500353535003535350000000000000000000000
            C0000000C0000000C000FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
            FF00FFFFFF00FFFFFF000000C0000000C0000000C00000000000000000003939
            39003939390039393900FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
            FF00FFFFFF00FFFFFF0039393900393939003939390000000000000000000000
            CF000000CF000000CF000000CF000000CF000000CF000000CF000000CF000000
            CF000000CF000000CF000000CF000000CF000000CF0000000000000000003E3E
            3E003E3E3E003E3E3E003E3E3E003E3E3E003E3E3E003E3E3E003E3E3E003E3E
            3E003E3E3E003E3E3E003E3E3E003E3E3E003E3E3E0000000000000000000000
            DF000000DF000000DF000000DF000000DF000000DF000000DF000000DF000000
            DF000000DF000000DF000000DF000000DF000000DF0000000000000000004343
            4300434343004343430043434300434343004343430043434300434343004343
            4300434343004343430043434300434343004343430000000000000000000000
            EF000000EF000000EF000000EF000000EF000000EF000000EF000000EF000000
            EF000000EF000000EF000000EF000000EF000000EF0000000000000000004747
            4700474747004747470047474700474747004747470047474700474747004747
            4700474747004747470047474700474747004747470000000000000000000000
            FF000000FF000000FF000000FF000000FF000000FF000000FF000000FF000000
            FF000000FF000000FF000000FF000000FF000000FF0000000000000000004C4C
            4C004C4C4C004C4C4C004C4C4C004C4C4C004C4C4C004C4C4C004C4C4C004C4C
            4C004C4C4C004C4C4C004C4C4C004C4C4C004C4C4C0000000000FF00FF000000
            0000000000000000000000000000000000000000000000000000000000000000
            00000000000000000000000000000000000000000000FF00FF00FF00FF000000
            0000000000000000000000000000000000000000000000000000000000000000
            00000000000000000000000000000000000000000000FF00FF00}
          Margin = 2
          NumGlyphs = 2
          Spacing = -2
          ExplicitLeft = 142
        end
        object SpeedButton_USU_Refresh: TSpeedButton
          Tag = 9
          Left = 259
          Top = 0
          Width = 22
          Height = 22
          Action = Action_USU_Refresh
          Anchors = [akTop, akRight]
          Flat = True
          Margin = 2
          NumGlyphs = 2
          Spacing = -2
          ExplicitLeft = 257
        end
        object SpeedButton_USU_Edit: TSpeedButton
          Tag = 6
          Left = 172
          Top = 0
          Width = 22
          Height = 22
          Action = XXXDataModule_Administration.Action_USU_Edit
          Anchors = [akTop]
          Flat = True
          Glyph.Data = {
            36080000424D3608000000000000360000002800000020000000100000000100
            2000000000000008000000000000000000000000000000000000FF00FF000000
            0000000000000000000000000000000000000000000000000000000000000000
            00000000000000000000000000000000000000000000FF00FF00FF00FF000000
            0000000000000000000000000000000000000000000000000000000000000000
            00000000000000000000000000000000000000000000FF00FF0000000000FF00
            0000FF000000FF000000FF000000FF000000FF000000FF000000FF000000FF00
            0000FF000000FF000000FF000000FF000000FF00000000000000000000001919
            1900191919001919190019191900191919001919190019191900191919001919
            190019191900191919001919190019191900191919000000000000000000E700
            0000E7000000FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
            FF00FFFFFF00FFFFFF00FFFFFF00E7000000E700000000000000000000001717
            170017171700FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
            FF00FFFFFF00FFFFFF00FFFFFF0017171700171717000000000000000000CF00
            0000CF000000CF000000CF000000CF000000CF000000CF000000CF000000CF00
            0000CF000000CF000000CF000000CF000000CF00000000000000000000001414
            1400141414001414140014141400141414001414140014141400141414001414
            140014141400141414001414140014141400141414000000000000000000B800
            0000B8000000FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
            FF00FFFFFF00FFFFFF00FFFFFF00B8000000B800000000000000000000001212
            120012121200FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
            FF00FFFFFF00FFFFFF00FFFFFF0012121200121212000000000000000000A000
            0000A0000000A0000000A0000000A0000000A0000000A0000000A0000000A000
            0000A0000000A0000000A0000000A0000000A000000000000000000000001010
            1000101010001010100010101000101010001010100010101000101010001010
            1000101010001010100010101000101010001010100000000000000000008900
            0000890000008900000089000000890000008900000089000000890000008900
            0000890000008900000089000000890000008900000000000000000000000D0D
            0D000D0D0D000D0D0D000D0D0D000D0D0D000D0D0D000D0D0D000D0D0D000D0D
            0D000D0D0D000D0D0D000D0D0D000D0D0D000D0D0D0000000000000000007100
            0000710000007100000071000000710000007100000071000000710000007100
            0000710000007100000071000000710000007100000000000000000000000B0B
            0B000B0B0B000B0B0B000B0B0B000B0B0B000B0B0B000B0B0B000B0B0B000B0B
            0B000B0B0B000B0B0B000B0B0B000B0B0B000B0B0B0000000000000000007100
            00007100000071000000FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
            FF00FFFFFF00FFFFFF0071000000710000007100000000000000000000000B0B
            0B000B0B0B000B0B0B00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
            FF00FFFFFF00FFFFFF000B0B0B000B0B0B000B0B0B0000000000000000008900
            0000890000008900000089000000FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
            FF00FFFFFF008900000089000000890000008900000000000000000000000D0D
            0D000D0D0D000D0D0D000D0D0D00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
            FF00FFFFFF000D0D0D000D0D0D000D0D0D000D0D0D000000000000000000A000
            0000A0000000A0000000A0000000A0000000FFFFFF00FFFFFF00FFFFFF00FFFF
            FF00A0000000A0000000A0000000A0000000A000000000000000000000001010
            100010101000101010001010100010101000FFFFFF00FFFFFF00FFFFFF00FFFF
            FF0010101000101010001010100010101000101010000000000000000000B800
            0000B8000000B8000000B8000000B8000000B8000000FFFFFF00FFFFFF00B800
            0000B8000000B8000000B8000000B8000000B800000000000000000000001212
            12001212120012121200121212001212120012121200FFFFFF00FFFFFF001212
            120012121200121212001212120012121200121212000000000000000000CF00
            0000CF000000CF000000CF000000CF000000CF000000CF000000CF000000CF00
            0000CF000000CF000000CF000000CF000000CF00000000000000000000001414
            1400141414001414140014141400141414001414140014141400141414001414
            140014141400141414001414140014141400141414000000000000000000E700
            0000E7000000E7000000E7000000E7000000E7000000E7000000E7000000E700
            0000E7000000E7000000E7000000E7000000E700000000000000000000001717
            1700171717001717170017171700171717001717170017171700171717001717
            170017171700171717001717170017171700171717000000000000000000FF00
            0000FF000000FF000000FF000000FF000000FF000000FF000000FF000000FF00
            0000FF000000FF000000FF000000FF000000FF00000000000000000000001919
            1900191919001919190019191900191919001919190019191900191919001919
            1900191919001919190019191900191919001919190000000000FF00FF000000
            0000000000000000000000000000000000000000000000000000000000000000
            00000000000000000000000000000000000000000000FF00FF00FF00FF000000
            0000000000000000000000000000000000000000000000000000000000000000
            00000000000000000000000000000000000000000000FF00FF00}
          Margin = 2
          NumGlyphs = 2
          Spacing = -2
          ExplicitLeft = 171
        end
        object SpeedButton_USU_Insert: TSpeedButton
          Tag = 4
          Left = 115
          Top = 0
          Width = 22
          Height = 22
          Action = XXXDataModule_Administration.Action_USU_Insert
          Anchors = [akTop]
          Flat = True
          Glyph.Data = {
            36080000424D3608000000000000360000002800000020000000100000000100
            2000000000000008000000000000000000000000000000000000FF00FF000000
            0000000000000000000000000000000000000000000000000000000000000000
            00000000000000000000000000000000000000000000FF00FF00FF00FF000000
            0000000000000000000000000000000000000000000000000000000000000000
            00000000000000000000000000000000000000000000FF00FF000000000000FF
            000000FF000000FF000000FF000000FF000000FF000000FF000000FF000000FF
            000000FF000000FF000000FF000000FF000000FF000000000000000000009999
            9900999999009999990099999900999999009999990099999900999999009999
            99009999990099999900999999009999990099999900000000000000000000DF
            070000DF0700FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
            FF00FFFFFF00FFFFFF00FFFFFF0000DF070000DF070000000000000000008888
            880088888800FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
            FF00FFFFFF00FFFFFF00FFFFFF008888880088888800000000000000000000C0
            0F0000C00F0000C00F0000C00F0000C00F0000C00F0000C00F0000C00F0000C0
            0F0000C00F0000C00F0000C00F0000C00F0000C00F0000000000000000007878
            7800787878007878780078787800787878007878780078787800787878007878
            78007878780078787800787878007878780078787800000000000000000000A0
            170000A01700FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
            FF00FFFFFF00FFFFFF00FFFFFF0000A0170000A0170000000000000000006767
            670067676700FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
            FF00FFFFFF00FFFFFF00FFFFFF00676767006767670000000000000000000081
            1F0000811F0000811F0000811F0000811F0000811F0000811F0000811F000081
            1F0000811F0000811F0000811F0000811F0000811F0000000000000000005757
            5700575757005757570057575700575757005757570057575700575757005757
            5700575757005757570057575700575757005757570000000000000000000062
            27000062270000622700006227000062270000622700FFFFFF00FFFFFF000062
            2700006227000062270000622700006227000062270000000000000000004646
            46004646460046464600464646004646460046464600FFFFFF00FFFFFF004646
            4600464646004646460046464600464646004646460000000000000000000042
            2F0000422F0000422F0000422F0000422F0000422F00FFFFFF00FFFFFF000042
            2F0000422F0000422F0000422F0000422F0000422F0000000000000000003535
            35003535350035353500353535003535350035353500FFFFFF00FFFFFF003535
            3500353535003535350035353500353535003535350000000000000000000042
            2F0000422F0000422F0000422F0000422F0000422F00FFFFFF00FFFFFF000042
            2F0000422F0000422F0000422F0000422F0000422F0000000000000000003535
            35003535350035353500353535003535350035353500FFFFFF00FFFFFF003535
            3500353535003535350035353500353535003535350000000000000000000062
            27000062270000622700FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
            FF00FFFFFF00FFFFFF0000622700006227000062270000000000000000004646
            46004646460046464600FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
            FF00FFFFFF00FFFFFF0046464600464646004646460000000000000000000081
            1F0000811F0000811F00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
            FF00FFFFFF00FFFFFF0000811F0000811F0000811F0000000000000000005757
            57005757570057575700FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
            FF00FFFFFF00FFFFFF00575757005757570057575700000000000000000000A0
            170000A0170000A0170000A0170000A0170000A01700FFFFFF00FFFFFF0000A0
            170000A0170000A0170000A0170000A0170000A0170000000000000000006767
            67006767670067676700676767006767670067676700FFFFFF00FFFFFF006767
            67006767670067676700676767006767670067676700000000000000000000C0
            0F0000C00F0000C00F0000C00F0000C00F0000C00F00FFFFFF00FFFFFF0000C0
            0F0000C00F0000C00F0000C00F0000C00F0000C00F0000000000000000007878
            78007878780078787800787878007878780078787800FFFFFF00FFFFFF007878
            78007878780078787800787878007878780078787800000000000000000000DF
            070000DF070000DF070000DF070000DF070000DF0700FFFFFF00FFFFFF0000DF
            070000DF070000DF070000DF070000DF070000DF070000000000000000008888
            88008888880088888800888888008888880088888800FFFFFF00FFFFFF008888
            88008888880088888800888888008888880088888800000000000000000000FF
            000000FF000000FF000000FF000000FF000000FF000000FF000000FF000000FF
            000000FF000000FF000000FF000000FF000000FF000000000000000000009999
            9900999999009999990099999900999999009999990099999900999999009999
            9900999999009999990099999900999999009999990000000000FF00FF000000
            0000000000000000000000000000000000000000000000000000000000000000
            00000000000000000000000000000000000000000000FF00FF00FF00FF000000
            0000000000000000000000000000000000000000000000000000000000000000
            00000000000000000000000000000000000000000000FF00FF00}
          Margin = 2
          NumGlyphs = 2
          Spacing = 0
          ExplicitLeft = 114
        end
        object SpeedButton_USU_First: TSpeedButton
          Left = 0
          Top = 0
          Width = 22
          Height = 22
          Action = Action_USU_First
          Flat = True
          Margin = 2
          NumGlyphs = 2
          Spacing = 0
        end
        object SpeedButton_USU_Previous: TSpeedButton
          Tag = 1
          Left = 28
          Top = 0
          Width = 22
          Height = 22
          Action = Action_GRU_Previous
          Anchors = [akTop]
          Flat = True
          Margin = 2
          NumGlyphs = 2
          Spacing = 0
        end
        object SpeedButton_USU_Next: TSpeedButton
          Tag = 2
          Left = 57
          Top = 0
          Width = 22
          Height = 22
          Action = Action_USU_Next
          Anchors = [akTop]
          Flat = True
          Margin = 2
          NumGlyphs = 2
          Spacing = 0
        end
        object SpeedButton_USU_Last: TSpeedButton
          Tag = 3
          Left = 86
          Top = 0
          Width = 22
          Height = 22
          Action = Action_USU_Last
          Anchors = [akTop]
          Flat = True
          Margin = 2
          NumGlyphs = 2
          Spacing = 0
          ExplicitLeft = 85
        end
        object SpeedButton_USU_Post: TSpeedButton
          Tag = 7
          Left = 201
          Top = 0
          Width = 22
          Height = 22
          Action = Action_USU_Post
          Anchors = [akTop]
          Flat = True
          Margin = 2
          NumGlyphs = 2
          Spacing = -2
          ExplicitLeft = 199
        end
        object SpeedButton_USU_Cancel: TSpeedButton
          Tag = 8
          Left = 230
          Top = 0
          Width = 22
          Height = 22
          Action = Action_USU_Cancel
          Anchors = [akTop]
          Flat = True
          Margin = 2
          NumGlyphs = 2
          Spacing = -2
          ExplicitLeft = 228
        end
      end
      object DBGrid_USU: TCFDBGrid
        Left = 5
        Top = 65
        Width = 710
        Height = 542
        Anchors = [akLeft, akTop, akRight, akBottom]
        DataSource = XXXDataModule_Administration.DataSource_USU
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'Tahoma'
        Font.Style = []
        Options = [dgTitles, dgIndicator, dgColLines, dgRowLines, dgTabs, dgRowSelect, dgAlwaysShowSelection, dgConfirmDelete, dgCancelOnExit]
        OptionsEx = [dgAutomaticColumSizes]
        ParentFont = False
        PopupMenu = XXXDataModule_Administration.PopupActionBar_RecordInformation
        ReadOnly = True
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
        SortArrow.Column = '[N/A]'
        VariableWidthColumns = '<VA_NOME>'
        Columns = <
          item
            Expanded = False
            FieldName = 'VA_NOME'
            Title.Caption = 'Nome'
            Width = 434
            Visible = True
          end
          item
            Expanded = False
            FieldName = 'VA_LOGIN'
            Title.Alignment = taCenter
            Title.Caption = 'Nome de login'
            Width = 110
            Visible = True
          end
          item
            Expanded = False
            FieldName = 'DATAEHORADOCADASTRO'
            Title.Alignment = taCenter
            Title.Caption = 'Registrado em'
            Width = 124
            Visible = True
          end>
      end
      object GroupBox_GDU: TGroupBox
        Left = 721
        Top = 235
        Width = 281
        Height = 372
        Anchors = [akTop, akRight, akBottom]
        Caption = ' Grupos aos quais o usu'#225'rio selecionado pertence '
        TabOrder = 4
        DesignSize = (
          281
          372)
        object Panel_GDU_Info: TPanel
          Left = 8
          Top = 15
          Width = 265
          Height = 349
          Anchors = [akLeft, akTop, akRight, akBottom]
          BevelOuter = bvNone
          TabOrder = 1
          object Label_GDU_Info: TLabel
            Left = 0
            Top = 0
            Width = 265
            Height = 349
            Align = alClient
            Alignment = taCenter
            AutoSize = False
            Caption = 
              'N'#227'o ser'#225' poss'#237'vel manipular os grupos do usu'#225'rio at'#233' que este us' +
              'u'#225'rio tenha sido completamente definido (inserido e salvo)'
            Layout = tlCenter
            WordWrap = True
            ExplicitWidth = 263
            ExplicitHeight = 107
          end
        end
        object CFDBGrid_GDU: TCFDBGrid
          Left = 8
          Top = 15
          Width = 265
          Height = 318
          Anchors = [akLeft, akTop, akRight, akBottom]
          DataSource = XXXDataModule_Administration.DataSource_GDU
          Options = [dgTitles, dgIndicator, dgColLines, dgRowLines, dgTabs, dgRowSelect, dgConfirmDelete, dgCancelOnExit, dgMultiSelect]
          OptionsEx = [dgAutomaticColumSizes]
          PopupMenu = XXXDataModule_Administration.PopupActionBar_RecordInformation
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
          VariableWidthColumns = '<NOME>'
          Columns = <
            item
              Alignment = taCenter
              Expanded = False
              FieldName = 'NOME'
              Title.Caption = 'Nome'
              Width = 211
              Visible = True
            end>
        end
        object BitBtn_GDU_Adicionar: TBitBtn
          Left = 27
          Top = 339
          Width = 112
          Height = 25
          Action = XXXDataModule_Administration.Action_GDU_Insert
          Anchors = [akBottom]
          Caption = 'Adicionar grupos'
          TabOrder = 2
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
        end
        object BitBtn_GDU_Remover: TBitBtn
          Left = 141
          Top = 339
          Width = 112
          Height = 25
          Action = XXXDataModule_Administration.Action_GDU_Delete
          Anchors = [akBottom]
          Caption = 'Remover grupos'
          TabOrder = 3
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
          Spacing = 5
        end
      end
      object GroupBoxUsuariosCadastrar: TGroupBox
        Left = 721
        Top = 93
        Width = 281
        Height = 139
        Anchors = [akTop, akRight]
        Caption = ' Dados do usu'#225'rio '
        TabOrder = 3
        DesignSize = (
          281
          139)
        object LabelUsuarioNome: TLabel
          Left = 8
          Top = 13
          Width = 27
          Height = 13
          Caption = 'Nome'
        end
        object LabelUsuarioLogin: TLabel
          Left = 8
          Top = 54
          Width = 67
          Height = 13
          Caption = 'Nome de login'
        end
        object LabelSenha1: TLabel
          Left = 143
          Top = 54
          Width = 30
          Height = 13
          Anchors = [akTop, akRight]
          Caption = 'Senha'
          ExplicitLeft = 142
        end
        object Label_USU_VA_EMAIL: TLabel
          Left = 8
          Top = 95
          Width = 28
          Height = 13
          Caption = 'E-mail'
        end
        object DBEdit_USU_VA_NOME: TDBEdit
          Left = 8
          Top = 27
          Width = 263
          Height = 21
          DataField = 'VA_NOME'
          DataSource = XXXDataModule_Administration.DataSource_USU
          TabOrder = 0
        end
        object DBEdit_USU_VA_LOGIN: TDBEdit
          Left = 8
          Top = 68
          Width = 129
          Height = 21
          DataField = 'VA_LOGIN'
          DataSource = XXXDataModule_Administration.DataSource_USU
          TabOrder = 1
        end
        object DBEdit_USU_TB_SENHA: TDBEdit
          Left = 143
          Top = 68
          Width = 129
          Height = 21
          Anchors = [akTop, akRight]
          DataField = 'TB_SENHA'
          DataSource = XXXDataModule_Administration.DataSource_USU
          Enabled = False
          PasswordChar = #248
          TabOrder = 3
        end
        object DBEdit_USU_VA_EMAIL: TDBEdit
          Left = 8
          Top = 109
          Width = 263
          Height = 21
          Anchors = [akLeft, akTop, akRight]
          DataField = 'VA_EMAIL'
          DataSource = XXXDataModule_Administration.DataSource_USU
          TabOrder = 2
        end
      end
    end
    object TabSheet_GRU: TTabSheet
      Caption = 'Gerenciamento de grupos'
      ImageIndex = 2
      DesignSize = (
        1007
        612)
      object GroupBoxGruposConsultar: TGroupBox
        Left = 5
        Top = 2
        Width = 997
        Height = 57
        Anchors = [akLeft, akTop, akRight]
        Caption = ' Localiza'#231#227'o r'#225'pida '
        TabOrder = 0
        DesignSize = (
          997
          57)
        object LabeledEdit_GRU_VA_NOME2: TLabeledEdit
          Left = 8
          Top = 27
          Width = 981
          Height = 21
          Anchors = [akLeft, akTop, akRight]
          CharCase = ecUpperCase
          EditLabel.Width = 27
          EditLabel.Height = 13
          EditLabel.Caption = 'Nome'
          LabelSpacing = 1
          TabOrder = 0
          OnChange = LabeledEdit_GRU_VA_NOME2Change
        end
      end
      object DBGrid_GRU: TCFDBGrid
        Left = 5
        Top = 66
        Width = 996
        Height = 455
        Anchors = [akLeft, akTop, akRight, akBottom]
        DataSource = XXXDataModule_Administration.DataSource_GRU
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'Tahoma'
        Font.Style = []
        Options = [dgTitles, dgIndicator, dgColLines, dgRowLines, dgTabs, dgRowSelect, dgAlwaysShowSelection, dgConfirmDelete, dgCancelOnExit]
        OptionsEx = [dgAutomaticColumSizes]
        ParentFont = False
        PopupMenu = XXXDataModule_Administration.PopupActionBar_RecordInformation
        ReadOnly = True
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
        VariableWidthColumns = '<VA_DESCRICAO>'
        Columns = <
          item
            Expanded = False
            FieldName = 'VA_NOME'
            Title.Caption = 'Nome'
            Width = 268
            Visible = True
          end
          item
            Expanded = False
            FieldName = 'VA_DESCRICAO'
            Title.Caption = 'Descri'#231#227'o'
            Width = 687
            Visible = True
          end>
      end
      object Panel_GRU_Layer: TPanel
        Left = 5
        Top = 527
        Width = 996
        Height = 22
        Anchors = [akLeft, akRight, akBottom]
        BevelOuter = bvNone
        ParentColor = True
        TabOrder = 2
        DesignSize = (
          996
          22)
        object SpeedButton_GRU_Delete: TSpeedButton
          Tag = 15
          Left = 535
          Top = 0
          Width = 22
          Height = 22
          Action = XXXDataModule_Administration.Action_GRU_Delete
          Anchors = [akTop]
          Flat = True
          Glyph.Data = {
            36080000424D3608000000000000360000002800000020000000100000000100
            2000000000000008000000000000000000000000000000000000FF00FF000000
            0000000000000000000000000000000000000000000000000000000000000000
            00000000000000000000000000000000000000000000FF00FF00FF00FF000000
            0000000000000000000000000000000000000000000000000000000000000000
            00000000000000000000000000000000000000000000FF00FF00000000000000
            FF000000FF000000FF000000FF000000FF000000FF000000FF000000FF000000
            FF000000FF000000FF000000FF000000FF000000FF0000000000000000004C4C
            4C004C4C4C004C4C4C004C4C4C004C4C4C004C4C4C004C4C4C004C4C4C004C4C
            4C004C4C4C004C4C4C004C4C4C004C4C4C004C4C4C0000000000000000000000
            EF000000EF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
            FF00FFFFFF00FFFFFF00FFFFFF000000EF000000EF0000000000000000004747
            470047474700FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
            FF00FFFFFF00FFFFFF00FFFFFF00474747004747470000000000000000000000
            DF000000DF000000DF000000DF000000DF000000DF000000DF000000DF000000
            DF000000DF000000DF000000DF000000DF000000DF0000000000000000004343
            4300434343004343430043434300434343004343430043434300434343004343
            4300434343004343430043434300434343004343430000000000000000000000
            CF000000CF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
            FF00FFFFFF00FFFFFF00FFFFFF000000CF000000CF0000000000000000003E3E
            3E003E3E3E00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
            FF00FFFFFF00FFFFFF00FFFFFF003E3E3E003E3E3E0000000000000000000000
            C0000000C0000000C0000000C0000000C0000000C0000000C0000000C0000000
            C0000000C0000000C0000000C0000000C0000000C00000000000000000003939
            3900393939003939390039393900393939003939390039393900393939003939
            3900393939003939390039393900393939003939390000000000000000000000
            B0000000B0000000B0000000B0000000B0000000B0000000B0000000B0000000
            B0000000B0000000B0000000B0000000B0000000B00000000000000000003535
            3500353535003535350035353500353535003535350035353500353535003535
            3500353535003535350035353500353535003535350000000000000000000000
            A0000000A0000000A0000000A0000000A0000000A0000000A0000000A0000000
            A0000000A0000000A0000000A0000000A0000000A00000000000000000003030
            3000303030003030300030303000303030003030300030303000303030003030
            3000303030003030300030303000303030003030300000000000000000000000
            A0000000A0000000A0000000A0000000A0000000A0000000A0000000A0000000
            A0000000A0000000A0000000A0000000A0000000A00000000000000000003030
            3000303030003030300030303000303030003030300030303000303030003030
            3000303030003030300030303000303030003030300000000000000000000000
            B0000000B0000000B000FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
            FF00FFFFFF00FFFFFF000000B0000000B0000000B00000000000000000003535
            35003535350035353500FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
            FF00FFFFFF00FFFFFF0035353500353535003535350000000000000000000000
            C0000000C0000000C000FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
            FF00FFFFFF00FFFFFF000000C0000000C0000000C00000000000000000003939
            39003939390039393900FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
            FF00FFFFFF00FFFFFF0039393900393939003939390000000000000000000000
            CF000000CF000000CF000000CF000000CF000000CF000000CF000000CF000000
            CF000000CF000000CF000000CF000000CF000000CF0000000000000000003E3E
            3E003E3E3E003E3E3E003E3E3E003E3E3E003E3E3E003E3E3E003E3E3E003E3E
            3E003E3E3E003E3E3E003E3E3E003E3E3E003E3E3E0000000000000000000000
            DF000000DF000000DF000000DF000000DF000000DF000000DF000000DF000000
            DF000000DF000000DF000000DF000000DF000000DF0000000000000000004343
            4300434343004343430043434300434343004343430043434300434343004343
            4300434343004343430043434300434343004343430000000000000000000000
            EF000000EF000000EF000000EF000000EF000000EF000000EF000000EF000000
            EF000000EF000000EF000000EF000000EF000000EF0000000000000000004747
            4700474747004747470047474700474747004747470047474700474747004747
            4700474747004747470047474700474747004747470000000000000000000000
            FF000000FF000000FF000000FF000000FF000000FF000000FF000000FF000000
            FF000000FF000000FF000000FF000000FF000000FF0000000000000000004C4C
            4C004C4C4C004C4C4C004C4C4C004C4C4C004C4C4C004C4C4C004C4C4C004C4C
            4C004C4C4C004C4C4C004C4C4C004C4C4C004C4C4C0000000000FF00FF000000
            0000000000000000000000000000000000000000000000000000000000000000
            00000000000000000000000000000000000000000000FF00FF00FF00FF000000
            0000000000000000000000000000000000000000000000000000000000000000
            00000000000000000000000000000000000000000000FF00FF00}
          Margin = 2
          NumGlyphs = 2
          Spacing = -2
          ExplicitLeft = 376
        end
        object SpeedButton_GRU_Refresh: TSpeedButton
          Tag = 19
          Left = 974
          Top = 0
          Width = 22
          Height = 22
          Action = Action_GRU_Refresh
          Anchors = [akTop, akRight]
          Flat = True
          Margin = 2
          NumGlyphs = 2
          Spacing = -2
          ExplicitLeft = 684
        end
        object SpeedButton_GRU_Edit: TSpeedButton
          Tag = 16
          Left = 639
          Top = 0
          Width = 22
          Height = 22
          Action = XXXDataModule_Administration.Action_GRU_Edit
          Anchors = [akTop]
          Flat = True
          Glyph.Data = {
            36080000424D3608000000000000360000002800000020000000100000000100
            2000000000000008000000000000000000000000000000000000FF00FF000000
            0000000000000000000000000000000000000000000000000000000000000000
            00000000000000000000000000000000000000000000FF00FF00FF00FF000000
            0000000000000000000000000000000000000000000000000000000000000000
            00000000000000000000000000000000000000000000FF00FF0000000000FF00
            0000FF000000FF000000FF000000FF000000FF000000FF000000FF000000FF00
            0000FF000000FF000000FF000000FF000000FF00000000000000000000001919
            1900191919001919190019191900191919001919190019191900191919001919
            190019191900191919001919190019191900191919000000000000000000E700
            0000E7000000FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
            FF00FFFFFF00FFFFFF00FFFFFF00E7000000E700000000000000000000001717
            170017171700FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
            FF00FFFFFF00FFFFFF00FFFFFF0017171700171717000000000000000000CF00
            0000CF000000CF000000CF000000CF000000CF000000CF000000CF000000CF00
            0000CF000000CF000000CF000000CF000000CF00000000000000000000001414
            1400141414001414140014141400141414001414140014141400141414001414
            140014141400141414001414140014141400141414000000000000000000B800
            0000B8000000FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
            FF00FFFFFF00FFFFFF00FFFFFF00B8000000B800000000000000000000001212
            120012121200FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
            FF00FFFFFF00FFFFFF00FFFFFF0012121200121212000000000000000000A000
            0000A0000000A0000000A0000000A0000000A0000000A0000000A0000000A000
            0000A0000000A0000000A0000000A0000000A000000000000000000000001010
            1000101010001010100010101000101010001010100010101000101010001010
            1000101010001010100010101000101010001010100000000000000000008900
            0000890000008900000089000000890000008900000089000000890000008900
            0000890000008900000089000000890000008900000000000000000000000D0D
            0D000D0D0D000D0D0D000D0D0D000D0D0D000D0D0D000D0D0D000D0D0D000D0D
            0D000D0D0D000D0D0D000D0D0D000D0D0D000D0D0D0000000000000000007100
            0000710000007100000071000000710000007100000071000000710000007100
            0000710000007100000071000000710000007100000000000000000000000B0B
            0B000B0B0B000B0B0B000B0B0B000B0B0B000B0B0B000B0B0B000B0B0B000B0B
            0B000B0B0B000B0B0B000B0B0B000B0B0B000B0B0B0000000000000000007100
            00007100000071000000FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
            FF00FFFFFF00FFFFFF0071000000710000007100000000000000000000000B0B
            0B000B0B0B000B0B0B00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
            FF00FFFFFF00FFFFFF000B0B0B000B0B0B000B0B0B0000000000000000008900
            0000890000008900000089000000FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
            FF00FFFFFF008900000089000000890000008900000000000000000000000D0D
            0D000D0D0D000D0D0D000D0D0D00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
            FF00FFFFFF000D0D0D000D0D0D000D0D0D000D0D0D000000000000000000A000
            0000A0000000A0000000A0000000A0000000FFFFFF00FFFFFF00FFFFFF00FFFF
            FF00A0000000A0000000A0000000A0000000A000000000000000000000001010
            100010101000101010001010100010101000FFFFFF00FFFFFF00FFFFFF00FFFF
            FF0010101000101010001010100010101000101010000000000000000000B800
            0000B8000000B8000000B8000000B8000000B8000000FFFFFF00FFFFFF00B800
            0000B8000000B8000000B8000000B8000000B800000000000000000000001212
            12001212120012121200121212001212120012121200FFFFFF00FFFFFF001212
            120012121200121212001212120012121200121212000000000000000000CF00
            0000CF000000CF000000CF000000CF000000CF000000CF000000CF000000CF00
            0000CF000000CF000000CF000000CF000000CF00000000000000000000001414
            1400141414001414140014141400141414001414140014141400141414001414
            140014141400141414001414140014141400141414000000000000000000E700
            0000E7000000E7000000E7000000E7000000E7000000E7000000E7000000E700
            0000E7000000E7000000E7000000E7000000E700000000000000000000001717
            1700171717001717170017171700171717001717170017171700171717001717
            170017171700171717001717170017171700171717000000000000000000FF00
            0000FF000000FF000000FF000000FF000000FF000000FF000000FF000000FF00
            0000FF000000FF000000FF000000FF000000FF00000000000000000000001919
            1900191919001919190019191900191919001919190019191900191919001919
            1900191919001919190019191900191919001919190000000000FF00FF000000
            0000000000000000000000000000000000000000000000000000000000000000
            00000000000000000000000000000000000000000000FF00FF00FF00FF000000
            0000000000000000000000000000000000000000000000000000000000000000
            00000000000000000000000000000000000000000000FF00FF00}
          Margin = 2
          NumGlyphs = 2
          Spacing = -2
          ExplicitLeft = 450
        end
        object SpeedButton_GRU_Insert: TSpeedButton
          Tag = 14
          Left = 435
          Top = 0
          Width = 22
          Height = 22
          Action = XXXDataModule_Administration.Action_GRU_Insert
          Anchors = [akTop]
          Flat = True
          Glyph.Data = {
            36080000424D3608000000000000360000002800000020000000100000000100
            2000000000000008000000000000000000000000000000000000FF00FF000000
            0000000000000000000000000000000000000000000000000000000000000000
            00000000000000000000000000000000000000000000FF00FF00FF00FF000000
            0000000000000000000000000000000000000000000000000000000000000000
            00000000000000000000000000000000000000000000FF00FF000000000000FF
            000000FF000000FF000000FF000000FF000000FF000000FF000000FF000000FF
            000000FF000000FF000000FF000000FF000000FF000000000000000000009999
            9900999999009999990099999900999999009999990099999900999999009999
            99009999990099999900999999009999990099999900000000000000000000DF
            070000DF0700FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
            FF00FFFFFF00FFFFFF00FFFFFF0000DF070000DF070000000000000000008888
            880088888800FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
            FF00FFFFFF00FFFFFF00FFFFFF008888880088888800000000000000000000C0
            0F0000C00F0000C00F0000C00F0000C00F0000C00F0000C00F0000C00F0000C0
            0F0000C00F0000C00F0000C00F0000C00F0000C00F0000000000000000007878
            7800787878007878780078787800787878007878780078787800787878007878
            78007878780078787800787878007878780078787800000000000000000000A0
            170000A01700FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
            FF00FFFFFF00FFFFFF00FFFFFF0000A0170000A0170000000000000000006767
            670067676700FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
            FF00FFFFFF00FFFFFF00FFFFFF00676767006767670000000000000000000081
            1F0000811F0000811F0000811F0000811F0000811F0000811F0000811F000081
            1F0000811F0000811F0000811F0000811F0000811F0000000000000000005757
            5700575757005757570057575700575757005757570057575700575757005757
            5700575757005757570057575700575757005757570000000000000000000062
            27000062270000622700006227000062270000622700FFFFFF00FFFFFF000062
            2700006227000062270000622700006227000062270000000000000000004646
            46004646460046464600464646004646460046464600FFFFFF00FFFFFF004646
            4600464646004646460046464600464646004646460000000000000000000042
            2F0000422F0000422F0000422F0000422F0000422F00FFFFFF00FFFFFF000042
            2F0000422F0000422F0000422F0000422F0000422F0000000000000000003535
            35003535350035353500353535003535350035353500FFFFFF00FFFFFF003535
            3500353535003535350035353500353535003535350000000000000000000042
            2F0000422F0000422F0000422F0000422F0000422F00FFFFFF00FFFFFF000042
            2F0000422F0000422F0000422F0000422F0000422F0000000000000000003535
            35003535350035353500353535003535350035353500FFFFFF00FFFFFF003535
            3500353535003535350035353500353535003535350000000000000000000062
            27000062270000622700FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
            FF00FFFFFF00FFFFFF0000622700006227000062270000000000000000004646
            46004646460046464600FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
            FF00FFFFFF00FFFFFF0046464600464646004646460000000000000000000081
            1F0000811F0000811F00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
            FF00FFFFFF00FFFFFF0000811F0000811F0000811F0000000000000000005757
            57005757570057575700FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
            FF00FFFFFF00FFFFFF00575757005757570057575700000000000000000000A0
            170000A0170000A0170000A0170000A0170000A01700FFFFFF00FFFFFF0000A0
            170000A0170000A0170000A0170000A0170000A0170000000000000000006767
            67006767670067676700676767006767670067676700FFFFFF00FFFFFF006767
            67006767670067676700676767006767670067676700000000000000000000C0
            0F0000C00F0000C00F0000C00F0000C00F0000C00F00FFFFFF00FFFFFF0000C0
            0F0000C00F0000C00F0000C00F0000C00F0000C00F0000000000000000007878
            78007878780078787800787878007878780078787800FFFFFF00FFFFFF007878
            78007878780078787800787878007878780078787800000000000000000000DF
            070000DF070000DF070000DF070000DF070000DF0700FFFFFF00FFFFFF0000DF
            070000DF070000DF070000DF070000DF070000DF070000000000000000008888
            88008888880088888800888888008888880088888800FFFFFF00FFFFFF008888
            88008888880088888800888888008888880088888800000000000000000000FF
            000000FF000000FF000000FF000000FF000000FF000000FF000000FF000000FF
            000000FF000000FF000000FF000000FF000000FF000000000000000000009999
            9900999999009999990099999900999999009999990099999900999999009999
            9900999999009999990099999900999999009999990000000000FF00FF000000
            0000000000000000000000000000000000000000000000000000000000000000
            00000000000000000000000000000000000000000000FF00FF00FF00FF000000
            0000000000000000000000000000000000000000000000000000000000000000
            00000000000000000000000000000000000000000000FF00FF00}
          Margin = 2
          NumGlyphs = 2
          Spacing = 0
          ExplicitLeft = 305
        end
        object SpeedButton_GRU_First: TSpeedButton
          Tag = 10
          Left = 0
          Top = 0
          Width = 22
          Height = 22
          Action = Action_GRU_First
          Flat = True
          Margin = 2
          NumGlyphs = 2
          Spacing = 0
        end
        object SpeedButton_GRU_Previous: TSpeedButton
          Tag = 11
          Left = 129
          Top = 0
          Width = 22
          Height = 22
          Action = Action_GRU_Previous
          Anchors = [akTop]
          Flat = True
          Margin = 2
          NumGlyphs = 2
          Spacing = 0
          ExplicitLeft = 88
        end
        object SpeedButton_GRU_Next: TSpeedButton
          Tag = 12
          Left = 232
          Top = 0
          Width = 22
          Height = 22
          Action = Action_GRU_Next
          Anchors = [akTop]
          Flat = True
          Margin = 2
          NumGlyphs = 2
          Spacing = 0
          ExplicitLeft = 161
        end
        object SpeedButton_GRU_Last: TSpeedButton
          Tag = 13
          Left = 332
          Top = 0
          Width = 22
          Height = 22
          Action = Action_GRU_Last
          Anchors = [akTop]
          Flat = True
          Margin = 2
          NumGlyphs = 2
          Spacing = 0
          ExplicitLeft = 232
        end
        object SpeedButton_GRU_Post: TSpeedButton
          Tag = 17
          Left = 738
          Top = 0
          Width = 22
          Height = 22
          Action = Action_GRU_Post
          Anchors = [akTop]
          Flat = True
          Margin = 2
          NumGlyphs = 2
          Spacing = -2
          ExplicitLeft = 520
        end
        object SpeedButton_GRU_Cancel: TSpeedButton
          Tag = 18
          Left = 843
          Top = 0
          Width = 22
          Height = 22
          Action = Action_GRU_Cancel
          Anchors = [akTop]
          Flat = True
          Margin = 2
          NumGlyphs = 2
          Spacing = -2
          ExplicitLeft = 594
        end
      end
      object GroupBoxGruposCadastrar: TGroupBox
        Left = 5
        Top = 552
        Width = 997
        Height = 56
        Anchors = [akLeft, akRight, akBottom]
        Caption = ' Dados do grupo '
        TabOrder = 3
        DesignSize = (
          997
          56)
        object LabelGrupoNome: TLabel
          Left = 8
          Top = 13
          Width = 73
          Height = 13
          Caption = 'Nome do grupo'
        end
        object LabelGrupoDescricao: TLabel
          Left = 224
          Top = 13
          Width = 92
          Height = 13
          Caption = 'Descri'#231#227'o do grupo'
        end
        object DBEdit_GRU_VA_NOME: TDBEdit
          Left = 8
          Top = 27
          Width = 210
          Height = 21
          DataField = 'VA_NOME'
          DataSource = XXXDataModule_Administration.DataSource_GRU
          TabOrder = 0
        end
        object DBEdit_GRU_VA_DESCRICAO: TDBEdit
          Left = 224
          Top = 27
          Width = 766
          Height = 21
          Anchors = [akLeft, akTop, akRight]
          DataField = 'VA_DESCRICAO'
          DataSource = XXXDataModule_Administration.DataSource_GRU
          TabOrder = 1
        end
      end
    end
  end
  object Panel_FlushPrivileges: TPanel [2]
    Left = 745
    Top = 26
    Width = 272
    Height = 20
    Anchors = [akTop, akRight]
    BevelOuter = bvNone
    ParentColor = True
    TabOrder = 2
    DesignSize = (
      272
      20)
    object Label_FlushPrivileges: TLabel
      Left = 3
      Top = 3
      Width = 264
      Height = 13
      Cursor = crHandPoint
      Hint = 
        'Atualizar privil'#233'gios das a'#231#245'es|Clique para atualizar os privil'#233 +
        'gios de todas as a'#231#245'es imediatamente'
      Alignment = taRightJustify
      Anchors = [akTop, akRight]
      Caption = 'Atualizar privil'#233'gios das a'#231#245'es imediatamente!'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clBlue
      Font.Height = -11
      Font.Name = 'Tahoma'
      Font.Style = [fsBold]
      ParentFont = False
      OnClick = Label_FlushPrivilegesClick
      OnMouseEnter = Label_FlushPrivilegesMouseEnter
      OnMouseLeave = Label_FlushPrivilegesMouseLeave
      ExplicitLeft = -87
    end
  end
  inherited ActionList_LocalActions: TActionList
    object Action_USU_First: TAction
      Category = 'Usuarios'
      Hint = 
        'Primeiro Registro|Vai para o primeiro registro na visualiza'#231'ao a' +
        'tual'
      ImageIndex = 0
      OnExecute = Action_USU_FirstExecute
    end
    object Action_USU_Previous: TAction
      Category = 'Usuarios'
      Hint = 
        'Registro anterior|Vai para o registro anterior na visualiza'#231#227'o a' +
        'tual'
      ImageIndex = 1
      OnExecute = Action_USU_PreviousExecute
    end
    object Action_USU_Next: TAction
      Category = 'Usuarios'
      Hint = 
        'Pr'#243'ximo registro|Vai para o pr'#243'ximo registro na visualiza'#231#227'o atu' +
        'al'
      ImageIndex = 2
      OnExecute = Action_USU_NextExecute
    end
    object Action_USU_Last: TAction
      Category = 'Usuarios'
      Hint = #218'ltimo Registro|Vai para o '#250'ltimo registro na visualiza'#231#227'o atual'
      ImageIndex = 3
      OnExecute = Action_USU_LastExecute
    end
    object Action_USU_Refresh: TAction
      Category = 'Usuarios'
      Hint = 
        'Atualizar|Atualiza a visualiza'#231#227'o atual de forma que os dados ap' +
        'resentados sejam os mais recentes'
      ImageIndex = 9
      OnExecute = Action_USU_RefreshExecute
    end
    object Action_USU_Cancel: TAction
      Category = 'Usuarios'
      Hint = 'Cancelar|Cancela a opera'#231#227'o de inser'#231#227'o ou edi'#231#227'o atual'
      ImageIndex = 8
      OnExecute = Action_USU_CancelExecute
    end
    object Action_USU_Post: TAction
      Category = 'Usuarios'
      Hint = 'Confirmar|Confirma a altera'#231#227'o ou inser'#231#227'o atual'
      ImageIndex = 7
      OnExecute = Action_USU_PostExecute
    end
    object Action_GRU_First: TAction
      Category = 'Grupos'
      Hint = 
        'Primeiro Registro|Vai para o primeiro registro na visualiza'#231'ao a' +
        'tual'
      ImageIndex = 0
      OnExecute = Action_GRU_FirstExecute
    end
    object Action_GRU_Previous: TAction
      Category = 'Grupos'
      Hint = 
        'Registro anterior|Vai para o registro anterior na visualiza'#231#227'o a' +
        'tual'
      ImageIndex = 1
    end
    object Action_GRU_Next: TAction
      Category = 'Grupos'
      Hint = 
        'Pr'#243'ximo registro|Vai para o pr'#243'ximo registro na visualiza'#231#227'o atu' +
        'al'
      ImageIndex = 2
      OnExecute = Action_GRU_NextExecute
    end
    object Action_GRU_Last: TAction
      Category = 'Grupos'
      Hint = #218'ltimo Registro|Vai para o '#250'ltimo registro na visualiza'#231#227'o atual'
      ImageIndex = 3
      OnExecute = Action_GRU_LastExecute
    end
    object Action_GRU_Refresh: TAction
      Category = 'Grupos'
      Hint = 
        'Atualizar|Atualiza a visualiza'#231#227'o atual de forma que os dados ap' +
        'resentados sejam os mais recentes'
      ImageIndex = 9
    end
    object Action_GRU_Cancel: TAction
      Category = 'Grupos'
      Hint = 'Cancelar|Cancela a opera'#231#227'o de inser'#231#227'o ou edi'#231#227'o atual'
      ImageIndex = 8
      OnExecute = Action_GRU_CancelExecute
    end
    object Action_GRU_Post: TAction
      Category = 'Grupos'
      Hint = 'Confirmar|Confirma a altera'#231#227'o ou inser'#231#227'o atual'
      ImageIndex = 7
      OnExecute = Action_GRU_PostExecute
    end
  end
end
