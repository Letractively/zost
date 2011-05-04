object Form_Principal: TForm_Principal
  Left = 403
  Top = 235
  BorderIcons = [biSystemMenu, biMinimize]
  BorderStyle = bsSingle
  Caption = 'Log Generator'
  ClientHeight = 415
  ClientWidth = 938
  Color = clBtnFace
  DefaultMonitor = dmPrimary
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  PixelsPerInch = 96
  TextHeight = 13
  object PageControl_Principal: TPageControl
    Left = 0
    Top = 0
    Width = 938
    Height = 415
    ActivePage = TabSheet_Relatorio
    Align = alClient
    TabOrder = 0
    object TabSheet_Relatorio: TTabSheet
      Caption = 'Relat'#243'rio,  Hist'#243'rico && Verifica'#231#227'o'
      object Panel_Relatorio: TPanel
        Left = 0
        Top = 346
        Width = 930
        Height = 41
        Align = alBottom
        BevelInner = bvLowered
        Color = clInfoBk
        ParentBackground = False
        TabOrder = 0
        object Shape_Relatorio: TShape
          Left = 2
          Top = 2
          Width = 926
          Height = 37
          Align = alClient
          Brush.Color = clInfoBk
          Pen.Style = psClear
        end
        object BitBtn_Verificar: TBitBtn
          Left = 8
          Top = 8
          Width = 75
          Height = 25
          Caption = 'Verificar'
          TabOrder = 0
          OnClick = BitBtn_VerificarClick
        end
      end
      object Panel_Detalhes: TPanel
        Left = 210
        Top = 0
        Width = 720
        Height = 346
        Align = alRight
        BevelOuter = bvNone
        TabOrder = 1
        object DBGrid_Detalhes: TDBGrid
          Left = 0
          Top = 0
          Width = 720
          Height = 148
          Align = alTop
          DataSource = DataModule_Principal.DS_DETALHES
          Options = [dgTitles, dgIndicator, dgColLines, dgRowLines, dgTabs, dgRowSelect, dgAlwaysShowSelection, dgConfirmDelete, dgCancelOnExit]
          ReadOnly = True
          TabOrder = 0
          TitleFont.Charset = DEFAULT_CHARSET
          TitleFont.Color = clWindowText
          TitleFont.Height = -11
          TitleFont.Name = 'MS Sans Serif'
          TitleFont.Style = []
          OnDrawColumnCell = DoDrawColumnCell
          Columns = <
            item
              Expanded = False
              FieldName = 'DONO'
              Title.Caption = 'Propriet'#225'rio'
              Width = 110
              Visible = True
            end
            item
              Expanded = False
              FieldName = 'TABELA'
              Title.Caption = 'Tabela'
              Width = 249
              Visible = True
            end
            item
              Alignment = taCenter
              Expanded = False
              FieldName = 'TRIGGERS'
              Title.Alignment = taCenter
              Title.Caption = 'Qtd. Triggers'
              Width = 75
              Visible = True
            end
            item
              Expanded = False
              FieldName = 'TABELALOG'
              Title.Caption = 'Tabela de LOG'
              Width = 249
              Visible = True
            end>
        end
        object Panel_Informacoes: TPanel
          Left = 0
          Top = 148
          Width = 720
          Height = 50
          Align = alTop
          BevelOuter = bvNone
          TabOrder = 1
          object DBText_DATACRIACAO: TDBText
            Left = 77
            Top = 4
            Width = 118
            Height = 13
            AutoSize = True
            DataField = 'DATACRIACAO'
            DataSource = DataModule_Principal.DS_DETALHES
          end
          object DBText_DATAMODIFICACAO: TDBText
            Left = 77
            Top = 33
            Width = 144
            Height = 13
            AutoSize = True
            DataField = 'DATAMODIFICACAO'
            DataSource = DataModule_Principal.DS_DETALHES
          end
          object DBText_DATACRIACAOLOG: TDBText
            Left = 296
            Top = 4
            Width = 140
            Height = 13
            AutoSize = True
            DataField = 'DATACRIACAOLOG'
            DataSource = DataModule_Principal.DS_DETALHES
          end
          object DBText_DATAMODIFICACAOLOG: TDBText
            Left = 296
            Top = 33
            Width = 166
            Height = 13
            AutoSize = True
            DataField = 'DATAMODIFICACAOLOG'
            DataSource = DataModule_Principal.DS_DETALHES
          end
          object Label_DataCriacao: TLabel
            Left = 3
            Top = 4
            Width = 50
            Height = 13
            Caption = 'Criada em:'
          end
          object Label_DataModificacao: TLabel
            Left = 3
            Top = 33
            Width = 72
            Height = 13
            Caption = 'Modificada em:'
          end
          object Label_DataCriacaoLog: TLabel
            Left = 201
            Top = 4
            Width = 71
            Height = 13
            Caption = 'Log Criado em:'
          end
          object Label_DataModificacaoLog: TLabel
            Left = 201
            Top = 33
            Width = 93
            Height = 13
            Caption = 'Log Modificado em:'
          end
        end
        object DBGrid_COLUNAS: TDBGrid
          Left = 0
          Top = 234
          Width = 720
          Height = 112
          Align = alClient
          DataSource = DataModule_Principal.DS_COLUNAS
          Options = [dgTitles, dgIndicator, dgColLines, dgRowLines, dgTabs, dgRowSelect, dgAlwaysShowSelection, dgConfirmDelete, dgCancelOnExit]
          TabOrder = 2
          TitleFont.Charset = DEFAULT_CHARSET
          TitleFont.Color = clWindowText
          TitleFont.Height = -11
          TitleFont.Name = 'MS Sans Serif'
          TitleFont.Style = []
          OnDrawColumnCell = DoDrawColumnCell
          Columns = <
            item
              Alignment = taCenter
              Expanded = False
              FieldName = 'TIPOALTER'
              Title.Alignment = taCenter
              Title.Caption = 'Tipo de modifica'#231#227'o'
              Width = 110
              Visible = True
            end
            item
              Expanded = False
              FieldName = 'COLUNAORI'
              Title.Caption = 'Coluna'
              Width = 230
              Visible = True
            end
            item
              Alignment = taCenter
              Expanded = False
              FieldName = 'TIPOORI'
              Title.Alignment = taCenter
              Title.Caption = 'Tipo'
              Width = 100
              Visible = True
            end
            item
              Alignment = taCenter
              Expanded = False
              FieldName = 'TAMANHOORI'
              Title.Alignment = taCenter
              Title.Caption = 'Tamanho'
              Width = 60
              Visible = True
            end
            item
              Alignment = taCenter
              Expanded = False
              FieldName = 'PRECISAOORI'
              Title.Alignment = taCenter
              Title.Caption = 'Precis'#227'o'
              Width = 60
              Visible = True
            end
            item
              Alignment = taCenter
              Expanded = False
              FieldName = 'ESCALAORI'
              Title.Alignment = taCenter
              Title.Caption = 'Escala'
              Width = 60
              Visible = True
            end
            item
              Alignment = taCenter
              Expanded = False
              FieldName = 'ANULAVELORI'
              Title.Alignment = taCenter
              Title.Caption = 'Anul'#225'vel?'
              Width = 60
              Visible = True
            end>
        end
        object Panel_Info: TPanel
          Left = 0
          Top = 198
          Width = 720
          Height = 36
          Align = alTop
          BevelInner = bvLowered
          Color = clInfoBk
          TabOrder = 3
          object Shape_Info: TShape
            Left = 2
            Top = 2
            Width = 716
            Height = 32
            Align = alClient
            Brush.Color = clInfoBk
            Pen.Style = psClear
          end
          object Label_Info: TLabel
            Left = 2
            Top = 2
            Width = 716
            Height = 32
            Align = alClient
            Alignment = taCenter
            Caption = 
              'As modifica'#231#245'es a seguir precisam ser aplicadas na tabela de log' +
              '. Se esta lista estiver vazia, a tabela de log j'#225' est'#225' correta!'
            Layout = tlCenter
          end
        end
      end
      object DBGrid_Historico: TDBGrid
        Left = 0
        Top = 0
        Width = 209
        Height = 346
        Align = alLeft
        DataSource = DataModule_Principal.DS_HISTORICO
        Options = [dgTitles, dgIndicator, dgColLines, dgRowLines, dgTabs, dgRowSelect, dgAlwaysShowSelection, dgConfirmDelete, dgCancelOnExit]
        ReadOnly = True
        TabOrder = 2
        TitleFont.Charset = DEFAULT_CHARSET
        TitleFont.Color = clWindowText
        TitleFont.Height = -11
        TitleFont.Name = 'MS Sans Serif'
        TitleFont.Style = []
        OnDrawColumnCell = DBGrid_HistoricoDrawColumnCell
        Columns = <
          item
            Alignment = taCenter
            Expanded = False
            FieldName = 'IDVERIFICACAO'
            Title.Alignment = taCenter
            Title.Caption = 'ID'
            Width = 50
            Visible = True
          end
          item
            Alignment = taCenter
            Expanded = False
            FieldName = 'DTHRVERIFICACAO'
            Title.Alignment = taCenter
            Title.Caption = 'Data da Verifica'#231#227'o'
            Width = 124
            Visible = True
          end>
      end
    end
    object TabSheet_Script: TTabSheet
      Caption = 'Script'
      ImageIndex = 1
      object Memo_Script: TMemo
        Left = 0
        Top = 0
        Width = 930
        Height = 346
        Align = alClient
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'Courier New'
        Font.Style = []
        Lines.Strings = (
          '')
        ParentFont = False
        ReadOnly = True
        ScrollBars = ssVertical
        TabOrder = 0
        WordWrap = False
      end
      object Panel_Script: TPanel
        Left = 0
        Top = 346
        Width = 930
        Height = 41
        Align = alBottom
        BevelInner = bvLowered
        Color = clInfoBk
        TabOrder = 1
        object Gauge_Script: TGauge
          Left = 500
          Top = 8
          Width = 423
          Height = 27
          BackColor = clWindow
          ForeColor = clHighlight
          Progress = 0
        end
        object BitBtn_Gerar: TBitBtn
          Left = 8
          Top = 8
          Width = 75
          Height = 25
          Caption = 'Gerar'
          TabOrder = 0
          OnClick = BitBtn_GerarClick
        end
        object BitBtn_SalvarScript: TBitBtn
          Left = 89
          Top = 8
          Width = 75
          Height = 25
          Caption = 'Salvar script'
          TabOrder = 1
          OnClick = BitBtn_SalvarScriptClick
        end
        object GroupBox_Opcoes: TGroupBox
          Left = 170
          Top = 2
          Width = 326
          Height = 33
          BiDiMode = bdLeftToRight
          Caption = ' Op'#231#245'es de gera'#231#227'o '
          ParentBiDiMode = False
          TabOrder = 2
          object CheckBox_GerarAlter: TCheckBox
            Left = 204
            Top = 16
            Width = 117
            Height = 13
            Caption = 'Alterar tabelas de log'
            Checked = True
            State = cbChecked
            TabOrder = 0
            OnClick = CheckBox_GerarCreateClick
          end
          object CheckBox_GerarTriggers: TCheckBox
            Left = 118
            Top = 16
            Width = 80
            Height = 13
            Caption = 'Criar Triggers'
            Checked = True
            State = cbChecked
            TabOrder = 1
            OnClick = CheckBox_GerarCreateClick
          end
          object CheckBox_GerarCreate: TCheckBox
            Left = 5
            Top = 16
            Width = 108
            Height = 13
            Caption = 'Criar tabelas de log'
            Checked = True
            State = cbChecked
            TabOrder = 2
            OnClick = CheckBox_GerarCreateClick
          end
        end
      end
    end
  end
end
