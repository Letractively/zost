inherited BDOForm_ImportarExportarObras: TBDOForm_ImportarExportarObras
  Caption = 'Importador / Exportador de dados da Obra'
  ClientHeight = 574
  ClientWidth = 707
  OnShow = FormShow
  ExplicitWidth = 713
  ExplicitHeight = 606
  PixelsPerInch = 96
  TextHeight = 13
  inherited Panel_Header: TPanel
    Width = 707
    ExplicitWidth = 707
    inherited Shape_BackgroundHeader: TShape
      Width = 707
      ExplicitWidth = 707
    end
    inherited Label_DialogDescription: TLabel
      Width = 661
      Caption = 
        'Neste tela '#233' poss'#237'vel importar a partir de ou exportar para um '#250 +
        'nico arquivo o conjuto de obras, propostas, itens e seus equipam' +
        'entos.'
      ExplicitWidth = 661
    end
    inherited Shape_HeaderLine: TShape
      Width = 699
      ExplicitWidth = 699
    end
    inherited Bevel_Header: TBevel
      Width = 707
      ExplicitWidth = 707
    end
  end
  inherited Panel_Footer: TPanel
    Top = 536
    Width = 707
    ExplicitTop = 536
    ExplicitWidth = 707
    inherited Shape_FooterBackground: TShape
      Width = 707
      ExplicitTop = 536
      ExplicitWidth = 707
    end
    inherited Shape_FooterLine: TShape
      Width = 699
      ExplicitTop = 4
      ExplicitWidth = 699
    end
    inherited Shape_Organizer: TShape
      Width = 699
      ExplicitTop = 9
      ExplicitWidth = 699
    end
    inherited Bevel_Footer: TBevel
      Width = 707
      ExplicitTop = 536
      ExplicitWidth = 707
    end
  end
  object PageControlExportarImportar: TPageControl [2]
    AlignWithMargins = True
    Left = 6
    Top = 55
    Width = 695
    Height = 475
    Margins.Left = 6
    Margins.Top = 6
    Margins.Right = 6
    Margins.Bottom = 6
    ActivePage = TabSheetExportar
    Align = alClient
    TabOrder = 2
    object TabSheetExportar: TTabSheet
      Caption = 'Exportar'
      ImageIndex = 1
      OnShow = DoShowTabSheet
      DesignSize = (
        687
        447)
      object Label1: TLabel
        Left = 4
        Top = 1
        Width = 679
        Height = 65
        Alignment = taCenter
        Anchors = [akLeft, akTop, akRight]
        AutoSize = False
        Caption = 
          'Para exportar Obras, Propostas e seus itens, primeiramente selec' +
          'ione na lista abaixo as Obras que deseja exportar, em seguida cl' +
          'ique o bot'#227'o "Exportar". Ao ser perguntado, informe o diret'#243'rio ' +
          'onde as obras exportadas ser'#227'o salvas. Por padr'#227'o os arquivos se' +
          'r'#227'o nomeados segundo o nome da obra que cada um deles cont'#233'm. Ap' +
          'enas os 25 primeiros caracteres do nome de cada Obra ser'#227'o usado' +
          's para gerar os nomes dos arquivos correspondentes. Caso a gera'#231 +
          #227'o de nomes gere arquivos de nomes iguais ou se no diret'#243'rio de ' +
          'destino j'#225' existir arquivos com nomes que est'#227'o sendo gerados, u' +
          'm sufixo num'#233'rico ser'#225' adicionado a cada c'#243'pia.'
        WordWrap = True
      end
      object Bevel1: TBevel
        Left = 4
        Top = 61
        Width = 679
        Height = 13
        Anchors = [akLeft, akTop, akRight]
        Shape = bsBottomLine
      end
      object Shape_OBR_FILTRO_RegistrosValor: TShape
        Left = 420
        Top = 406
        Width = 151
        Height = 16
        Anchors = [akLeft, akBottom]
        Brush.Color = clActiveCaption
        Pen.Color = clCaptionText
      end
      object Label_OBR_FILTRO_RegistrosValor: TLabel
        Left = 420
        Top = 407
        Width = 150
        Height = 13
        Alignment = taCenter
        Anchors = [akLeft, akBottom]
        AutoSize = False
        Caption = '000000 / 000000'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clCaptionText
        Font.Height = -11
        Font.Name = 'Tahoma'
        Font.Style = [fsBold]
        ParentFont = False
        Transparent = True
      end
      object Label_OBR_FILTRO_Registros: TLabel
        Left = 449
        Top = 392
        Width = 93
        Height = 13
        Alignment = taCenter
        Anchors = [akLeft, akBottom]
        Caption = 'Obras selecionadas'
        Transparent = True
      end
      object LabelPercent: TLabel
        Left = 537
        Top = 428
        Width = 34
        Height = 13
        Alignment = taCenter
        Anchors = [akLeft, akBottom]
        AutoSize = False
        Caption = '0%'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'Tahoma'
        Font.Style = [fsBold]
        ParentFont = False
      end
      object Label9: TLabel
        Left = 28
        Top = 373
        Width = 630
        Height = 13
        Caption = 
          'Obs.: Apenas obras das suas regi'#245'es de atua'#231#227'o est'#227'o sendo visua' +
          'lizadas acima, pois apenas elas podem ser exportadas por voc'#234
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'Tahoma'
        Font.Style = []
        ParentFont = False
      end
      object CFDBGridExportar: TCFDBGrid
        Left = 4
        Top = 125
        Width = 679
        Height = 242
        Anchors = [akLeft, akTop, akRight, akBottom]
        DataSource = BDODataModule_ImportarExportarObras.DS_OBR_FILTRO
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'Tahoma'
        Font.Style = []
        Options = [dgTitles, dgIndicator, dgColLines, dgRowLines, dgTabs, dgRowSelect, dgConfirmDelete, dgCancelOnExit, dgMultiSelect]
        OptionsEx = [dgAutomaticColumSizes]
        ParentFont = False
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
        VariableWidthColumns = '<VA_NOMEDAOBRA>'
        OnAfterMultiselect = CFDBGridExportarAfterMultiselect
        Columns = <
          item
            Expanded = False
            FieldName = 'VA_NOMEDAOBRA'
            Title.Caption = 'Obra'
            Width = 423
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
          end>
      end
      object RadioGroupFiltragem: TRadioGroup
        Left = 4
        Top = 392
        Width = 151
        Height = 51
        Anchors = [akLeft, akBottom]
        Caption = ' Conjunto de Obras '
        ItemIndex = 0
        Items.Strings = (
          'Todas as Obras'
          'Obras n'#227'o sincronizadas')
        TabOrder = 2
        OnClick = RadioGroupFiltragemClick
      end
      object BitBtnExportar: TBitBtn
        Left = 577
        Top = 395
        Width = 106
        Height = 48
        Action = Action_Exportar
        Anchors = [akLeft, akBottom]
        Caption = 'Exportar obras marcadas...'
        TabOrder = 5
        WordWrap = True
      end
      object ProgressBarExportando: TProgressBar
        Left = 420
        Top = 428
        Width = 112
        Height = 15
        Anchors = [akLeft, akBottom]
        Step = 1
        TabOrder = 4
      end
      object GroupBoxSelecao: TGroupBox
        Left = 160
        Top = 392
        Width = 254
        Height = 51
        Anchors = [akLeft, akBottom]
        Caption = ' Selecionar '
        TabOrder = 3
        object ButtonTodas: TButton
          Left = 7
          Top = 14
          Width = 75
          Height = 28
          Action = Action_Todas
          TabOrder = 0
        end
        object ButtonNenhuma: TButton
          Left = 89
          Top = 14
          Width = 75
          Height = 28
          Action = Action_Nenhuma
          TabOrder = 1
        end
        object ButtonInverterSelecao: TButton
          Left = 171
          Top = 14
          Width = 75
          Height = 28
          Action = Action_Inverter
          TabOrder = 2
        end
      end
      object GroupBox3: TGroupBox
        Left = 4
        Top = 77
        Width = 679
        Height = 42
        Anchors = [akLeft, akTop, akRight]
        Caption = 
          ' O nome da obra cont'#233'm (use os caracteres curinga * e ? para faz' +
          'er pesquisas parciais) '
        TabOrder = 0
        object Edit_OBR_FILTRO_VA_NOMEDAOBRA: TEdit
          Left = 8
          Top = 13
          Width = 663
          Height = 21
          TabOrder = 0
          OnKeyDown = Edit_OBR_FILTRO_VA_NOMEDAOBRAKeyDown
        end
      end
    end
    object TabSheetImportar: TTabSheet
      Caption = 'Importar'
      OnShow = DoShowTabSheet
      DesignSize = (
        687
        447)
      object Label2: TLabel
        Left = 4
        Top = 1
        Width = 679
        Height = 65
        Alignment = taCenter
        Anchors = [akLeft, akTop, akRight]
        AutoSize = False
        Caption = 
          'Primeiramente, clique o bot'#227'o "Validar Arquivos de Obra...". A c' +
          'aixa de di'#225'logo "Selecionar Obras" aparecer'#225'. Selecione o(s) arq' +
          'uivo(s) que deseja importar e clique OK. Os arquivos de obra sel' +
          'ecionados ser'#227'o validados para saber se todos os dados requerido' +
          's est'#227'o presentes nas tabelas auxiliares. Al'#233'm desta verifica'#231#227'o' +
          ' tamb'#233'm ser'#225' realizada uma valida'#231#227'o quanto '#224's permiss'#245'es do usu' +
          #225'rio que est'#225' realizando a importa'#231#227'o. Caso tal usu'#225'rio n'#227'o poss' +
          'ua permiss'#245'es para inser'#231#227'o em uma das tabelas envolvidas, ou se' +
          ' tal usu'#225'rio n'#227'o tiver permiss'#227'o pra criar obras na regi'#227'o da ob' +
          'ra sendo importada, tal obra n'#227'o ser'#225' importada. Apenas obras v'#225 +
          'lidas e marcadas ser'#227'o importadas.'
        WordWrap = True
      end
      object Bevel2: TBevel
        Left = 4
        Top = 61
        Width = 679
        Height = 13
        Anchors = [akLeft, akTop, akRight]
        Shape = bsBottomLine
      end
      object LabelStatus: TLabel
        Left = 338
        Top = 77
        Width = 345
        Height = 13
        Alignment = taCenter
        AutoSize = False
        Caption = 'Validando obras... 100%'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'Tahoma'
        Font.Style = [fsBold]
        ParentFont = False
      end
      object Label3: TLabel
        Left = 403
        Top = 53
        Width = 250
        Height = 13
        Caption = 'Apenas obras v'#225'lidas e marcadas ser'#227'o importadas.'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clRed
        Font.Height = -11
        Font.Name = 'Tahoma'
        Font.Style = [fsUnderline]
        ParentFont = False
      end
      object Label4: TLabel
        Left = 4
        Top = 258
        Width = 679
        Height = 13
        Alignment = taCenter
        AutoSize = False
        Caption = 
          'Clique em uma das obras acima para ver seu status atual na lista' +
          ' abaixo'
        Color = clGreen
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'Tahoma'
        Font.Style = [fsBold]
        ParentColor = False
        ParentFont = False
        Transparent = True
      end
      object Label10: TLabel
        Left = 118
        Top = 109
        Width = 450
        Height = 13
        Caption = 
          'Obs.: Apenas obras pertencentes '#224's suas regi'#245'es de atua'#231#227'o ser'#227'o' +
          ' efetivamente importadas'
      end
      object ListViewImportar: TListView
        Left = 4
        Top = 128
        Width = 679
        Height = 125
        Checkboxes = True
        Columns = <
          item
            Caption = 'Obra'
            Width = 443
          end
          item
            Alignment = taCenter
            Caption = 'Localidade'
            Width = 202
          end>
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'Tahoma'
        Font.Style = []
        GridLines = True
        HideSelection = False
        ReadOnly = True
        RowSelect = True
        ParentFont = False
        SmallImages = BDODataModule_ImportarExportarObras.ImageList_Local
        TabOrder = 1
        ViewStyle = vsReport
        OnChange = ListViewImportarChange
        OnCustomDrawItem = ListViewImportarCustomDrawItem
      end
      object ButtonValidarArquivosDeObra: TButton
        Left = 4
        Top = 80
        Width = 161
        Height = 25
        Action = Action_Validar
        TabOrder = 0
      end
      object ButtonImportarObrasSelecionadas: TButton
        Left = 171
        Top = 80
        Width = 161
        Height = 25
        Action = Action_Importar
        TabOrder = 4
      end
      object RichEditObservacoes: TRichEdit
        Left = 4
        Top = 272
        Width = 679
        Height = 130
        Anchors = [akLeft, akTop, akRight, akBottom]
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'Courier New'
        Font.Style = [fsBold]
        ParentFont = False
        ReadOnly = True
        ScrollBars = ssVertical
        TabOrder = 2
      end
      object ProgressBarImportacao: TProgressBar
        Left = 338
        Top = 94
        Width = 345
        Height = 11
        Smooth = True
        Step = 1
        TabOrder = 5
      end
      object GroupBox1: TGroupBox
        Left = 380
        Top = 405
        Width = 303
        Height = 37
        Caption = ' Legenda de importa'#231#227'o '
        TabOrder = 6
        object Image2: TImage
          Left = 7
          Top = 14
          Width = 16
          Height = 16
        end
        object Image3: TImage
          Left = 137
          Top = 14
          Width = 16
          Height = 16
        end
        object Label7: TLabel
          Left = 29
          Top = 15
          Width = 91
          Height = 13
          Caption = 'Erro de importa'#231#227'o'
        end
        object Label8: TLabel
          Left = 158
          Top = 15
          Width = 138
          Height = 13
          Caption = 'Obra importada com sucesso'
        end
      end
      object GroupBox2: TGroupBox
        Left = 4
        Top = 405
        Width = 371
        Height = 37
        Caption = ' Legenda de valida'#231#227'o '
        TabOrder = 3
        object Image0: TImage
          Left = 7
          Top = 14
          Width = 16
          Height = 16
        end
        object Label5: TLabel
          Left = 28
          Top = 15
          Width = 155
          Height = 13
          Caption = 'Obra INV'#193'LIDA para importa'#231#227'o'
        end
        object Image1: TImage
          Left = 199
          Top = 14
          Width = 16
          Height = 16
        end
        object Label6: TLabel
          Left = 220
          Top = 15
          Width = 144
          Height = 13
          Caption = 'Obra V'#193'LIDA para importa'#231#227'o'
        end
      end
    end
  end
  inherited ActionList_LocalActions: TActionList
    object Action_Exportar: TAction
      Caption = 'Exportar obras marcadas...'
      Hint = 
        'Exportar obras marcadas|Clique para informar o local onde as obr' +
        'as marcadas ser'#227'o salvas ap'#243's a exporta'#231#227'o'
      OnExecute = Action_ExportarExecute
    end
    object Action_Importar: TAction
      Caption = 'Importar Obras marcadas'
      Hint = 
        'Importar Obras marcadas|Clique para iniciar o processo de import' +
        'a'#231#227'o das obras marcadas'
      OnExecute = Action_ImportarExecute
    end
    object Action_Inverter: TAction
      Caption = 'Inverter'
      Hint = 'Inverter|Clique para inverter as marcas em cada obra'
      OnExecute = Action_InverterExecute
    end
    object Action_Nenhuma: TAction
      Caption = 'Nenhuma'
      Hint = 'Nenhuma|Clique para desmarcar todas as obras exibidas'
      OnExecute = Action_NenhumaExecute
    end
    object Action_Todas: TAction
      Caption = 'Todas'
      Hint = 'Todas|Clique para marcar todas as obras exibidas'
      OnExecute = Action_TodasExecute
    end
    object Action_Validar: TAction
      Caption = 'Validar arquivos de Obra...'
      Hint = 
        'Validar arquivos de Obra|Clique para selecionar e validar arquiv' +
        'os de obra para importa'#231#227'o'
      OnExecute = Action_ValidarExecute
    end
  end
end
