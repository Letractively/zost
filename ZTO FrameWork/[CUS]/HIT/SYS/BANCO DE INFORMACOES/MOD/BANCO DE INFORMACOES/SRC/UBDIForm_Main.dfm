inherited BDIForm_Main: TBDIForm_Main
  BorderIcons = [biSystemMenu, biMinimize, biHelp]
  BorderStyle = bsSingle
  Caption = 'Banco de Informa'#231#245'es'
  ClientHeight = 359
  ClientWidth = 532
  ParentBiDiMode = False
  Visible = True
  OnCreate = FormCreate
  ExplicitWidth = 538
  ExplicitHeight = 391
  PixelsPerInch = 96
  TextHeight = 13
  inherited Panel_Header: TPanel
    Width = 532
    ExplicitWidth = 532
    DesignSize = (
      532
      49)
    inherited Shape_BackgroundHeader: TShape
      Width = 532
      ExplicitWidth = 548
    end
    inherited Label_DialogDescription: TLabel
      Width = 486
      Caption = 
        'O Banco De Informa'#231#245'es (BDI) '#233' um programa aut'#244'nomo que prov'#234' v'#225 +
        'rios servi'#231'os de informa'#231#227'o para, e sobre, o Banco De Obras (BDO' +
        '). A aplica'#231#227'o pode ser colocada na '#225'rea de notifica'#231#227'o (System ' +
        'Tray). O BDI tamb'#233'm prov'#234' controle sobre os servi'#231'os do BDO exec' +
        'utando no servidor.'
      ParentColor = True
      ExplicitWidth = 502
    end
    inherited Shape_HeaderLine: TShape
      Width = 524
      ExplicitWidth = 540
    end
    inherited Bevel_Header: TBevel
      Width = 532
      ExplicitWidth = 548
    end
  end
  inherited Panel_Footer: TPanel
    Top = 321
    Width = 532
    ExplicitTop = 321
    ExplicitWidth = 532
    DesignSize = (
      532
      38)
    inherited Shape_FooterBackground: TShape
      Width = 532
      ExplicitWidth = 548
    end
    inherited Shape_FooterLine: TShape
      Width = 524
      ExplicitWidth = 540
    end
    inherited Shape_Organizer: TShape
      Width = 524
      ExplicitWidth = 540
    end
    inherited Bevel_Footer: TBevel
      Width = 532
      ExplicitWidth = 548
    end
    object BitBtn_MinimizarNoTray: TBitBtn
      Left = 360
      Top = 9
      Width = 168
      Height = 25
      Action = Action_MinimizarNoTray
      Caption = 'Colocar na '#225'rea de notifica'#231#227'o'
      TabOrder = 0
    end
    object BitBtn_SalvarConfiguracoes: TBitBtn
      Left = 228
      Top = 9
      Width = 126
      Height = 25
      Action = Action_SalvarConfiguracoes
      Caption = 'Salvar Configura'#231#245'es'
      TabOrder = 1
    end
  end
  object PageControl_Principal: TPageControl [2]
    AlignWithMargins = True
    Left = 6
    Top = 55
    Width = 520
    Height = 260
    Margins.Left = 6
    Margins.Top = 6
    Margins.Right = 6
    Margins.Bottom = 6
    ActivePage = TabSheet_InformacoesGerais
    Align = alClient
    TabOrder = 2
    object TabSheet_InformacoesGerais: TTabSheet
      Caption = 'Informa'#231#245'es gerais'
      ImageIndex = 3
      object GroupBox_SMTP: TGroupBox
        AlignWithMargins = True
        Left = 6
        Top = 6
        Width = 500
        Height = 84
        Margins.Left = 6
        Margins.Top = 6
        Margins.Right = 6
        Align = alTop
        Caption = ' E-mails autom'#225'ticos '
        TabOrder = 0
        object Label_EmailParaObrasOciosas: TLabel
          Left = 11
          Top = 14
          Width = 67
          Height = 13
          Caption = 'Obras ociosas'
        end
        object Label_EmailsParaObrasOciosasProximoEnvio: TLabel
          Left = 11
          Top = 28
          Width = 216
          Height = 13
          Caption = 'Pr'#243'xima checagem em: ??/??/???? '#224's ??:??:??'
        end
        object Label_EmailParaObrasGanhas: TLabel
          Left = 11
          Top = 47
          Width = 67
          Height = 13
          Caption = 'Obras ganhas'
        end
        object Label_EmailsParaObrasPerdidas: TLabel
          Left = 258
          Top = 14
          Width = 73
          Height = 13
          Caption = 'Obras perdidas'
        end
        object Label_EmailsParaObrasLimitrofes: TLabel
          Left = 258
          Top = 47
          Width = 75
          Height = 13
          Caption = 'Obras lim'#237'trofes'
        end
        object Label_EmailsParaObrasPerdidasProximoEnvio: TLabel
          Left = 258
          Top = 28
          Width = 216
          Height = 13
          Caption = 'Pr'#243'xima checagem em: ??/??/???? '#224's ??:??:??'
        end
        object Bevel_LinhaVertical1: TBevel
          Left = 250
          Top = 14
          Width = 2
          Height = 60
          Shape = bsLeftLine
        end
        object Label_EmailsParaObrasGanhasProximoEnvio: TLabel
          Left = 11
          Top = 61
          Width = 216
          Height = 13
          Caption = 'Pr'#243'xima checagem em: ??/??/???? '#224's ??:??:??'
        end
        object Label_EmailsParaObrasGanhasValor: TLabel
          Left = 186
          Top = 61
          Width = 58
          Height = 13
          Alignment = taCenter
          AutoSize = False
          Caption = '? / ?'
          Visible = False
        end
        object Label_EmailsParaObrasLimitrofesProximoEnvio: TLabel
          Left = 258
          Top = 61
          Width = 216
          Height = 13
          Caption = 'Pr'#243'xima checagem em: ??/??/???? '#224's ??:??:??'
        end
        object Label_EmailsParaObrasLimitrofesValor: TLabel
          Left = 433
          Top = 61
          Width = 58
          Height = 13
          Alignment = taCenter
          AutoSize = False
          Caption = '? / ?'
          Visible = False
        end
        object Label_EmailsParaObrasOciosasValor: TLabel
          Left = 186
          Top = 28
          Width = 58
          Height = 13
          Alignment = taCenter
          AutoSize = False
          Caption = '? / ?'
          Visible = False
        end
        object Label_EmailsParaObrasPerdidasValor: TLabel
          Left = 433
          Top = 28
          Width = 58
          Height = 13
          Alignment = taCenter
          AutoSize = False
          Caption = '? / ?'
          Visible = False
        end
        object ProgressBar_EmailsParaObrasOciosas: TProgressBar
          Left = 11
          Top = 28
          Width = 169
          Height = 13
          Position = 50
          Step = 1
          TabOrder = 0
          Visible = False
        end
        object ProgressBar_EmailsParaObrasPerdidas: TProgressBar
          Left = 258
          Top = 28
          Width = 169
          Height = 13
          Position = 50
          Step = 1
          TabOrder = 1
          Visible = False
        end
        object ProgressBar_EmailsParaObrasGanhas: TProgressBar
          Left = 11
          Top = 61
          Width = 169
          Height = 13
          Position = 50
          Step = 1
          TabOrder = 2
          Visible = False
        end
        object ProgressBar_EmailsParaObrasLimitrofes: TProgressBar
          Left = 258
          Top = 61
          Width = 169
          Height = 13
          Position = 50
          Step = 1
          TabOrder = 3
          Visible = False
        end
        object Panel_EmailsAutomaticos: TPanel
          Left = 11
          Top = 77
          Width = 480
          Height = 60
          BevelOuter = bvLowered
          Caption = 
            'O servi'#231'o de envio de e-mails autom'#225'ticos est'#225' inativo. N'#227'o h'#225' i' +
            'nforma'#231#245'es adicionais a exibir'
          Color = clInfoBk
          ParentBackground = False
          TabOrder = 4
        end
      end
      object GroupBox_HTTP: TGroupBox
        AlignWithMargins = True
        Left = 6
        Top = 93
        Width = 500
        Height = 67
        Margins.Left = 6
        Margins.Top = 0
        Margins.Right = 6
        Align = alTop
        Caption = ' Servi'#231'o de informa'#231#245'es '
        TabOrder = 1
      end
    end
    object TabSheet_EmailsAutomaticos: TTabSheet
      Caption = 'E-mails autom'#225'ticos'
      ImageIndex = 1
      object PageControl_EmailsAutomaticos: TPageControl
        AlignWithMargins = True
        Left = 6
        Top = 40
        Width = 500
        Height = 186
        Margins.Left = 6
        Margins.Top = 6
        Margins.Right = 6
        Margins.Bottom = 6
        ActivePage = TabSheet_ObrasOciosas
        Align = alClient
        TabOrder = 0
        object TabSheet_ObrasOciosas: TTabSheet
          Caption = 'Obras ociosas'
          object PageControl_ObrasOciosas: TPageControl
            AlignWithMargins = True
            Left = 6
            Top = 6
            Width = 480
            Height = 146
            Margins.Left = 6
            Margins.Top = 6
            Margins.Right = 6
            Margins.Bottom = 6
            ActivePage = TabSheet_ObrasOciosasEmails
            Align = alClient
            TabOrder = 0
            object TabSheet_ObrasOciosasEmails: TTabSheet
              Caption = 'E-mails'
              object Memo_ObrasOciosas: TMemo
                AlignWithMargins = True
                Left = 6
                Top = 16
                Width = 460
                Height = 96
                Margins.Left = 6
                Margins.Right = 6
                Margins.Bottom = 6
                Align = alClient
                Lines.Strings = (
                  'Memo_ObrasOciosas')
                TabOrder = 0
                OnChange = DoGuardarConfiguracoes
              end
              object Panel_ObrasOciosas: TPanel
                Left = 0
                Top = 0
                Width = 472
                Height = 13
                Margins.Bottom = 0
                Align = alTop
                BevelOuter = bvNone
                Caption = 'Por favor, coloque um e-mail por linha'
                TabOrder = 1
              end
            end
            object TabSheet_ObrasOciosasConfiguracoes: TTabSheet
              Caption = 'Defini'#231#245'es'
              ImageIndex = 1
              object Label_ObrasOciosasIntervalo: TLabel
                Left = 250
                Top = 10
                Width = 19
                Height = 13
                Caption = 'dias'
              end
              object Label_ObrasOciosasDias: TLabel
                Left = 192
                Top = 37
                Width = 126
                Height = 13
                Caption = 'dias ou mais de ociosidade'
              end
              object LabeledEdit_ObrasOciosasIntervalo: TLabeledEdit
                Left = 209
                Top = 6
                Width = 19
                Height = 21
                EditLabel.Width = 197
                EditLabel.Height = 13
                EditLabel.Caption = 'Gerar estat'#237'sticas e enviar e-mails a cada'
                LabelPosition = lpLeft
                LabelSpacing = 6
                ReadOnly = True
                TabOrder = 0
                Text = '15'
                OnChange = DoGuardarConfiguracoes
              end
              object UpDown_ObrasOciosasIntervalo: TUpDown
                Left = 228
                Top = 6
                Width = 16
                Height = 21
                Associate = LabeledEdit_ObrasOciosasIntervalo
                Min = 1
                Max = 30
                Position = 15
                TabOrder = 1
              end
              object LabeledEdit_ObrasOciosasDias: TLabeledEdit
                Left = 151
                Top = 33
                Width = 19
                Height = 21
                EditLabel.Width = 139
                EditLabel.Height = 13
                EditLabel.Caption = 'Selecionar apenas obras com'
                LabelPosition = lpLeft
                LabelSpacing = 6
                ReadOnly = True
                TabOrder = 2
                Text = '30'
                OnChange = DoGuardarConfiguracoes
              end
              object UpDown_ObrasOciosasDias: TUpDown
                Left = 170
                Top = 33
                Width = 16
                Height = 21
                Associate = LabeledEdit_ObrasOciosasDias
                Min = 30
                Max = 99
                Position = 30
                TabOrder = 3
              end
            end
          end
        end
        object TabSheet_ObrasGanhas: TTabSheet
          Caption = 'Obras ganhas'
          ImageIndex = 1
          object PageControl_ObrasGanhas: TPageControl
            AlignWithMargins = True
            Left = 6
            Top = 6
            Width = 480
            Height = 146
            Margins.Left = 6
            Margins.Top = 6
            Margins.Right = 6
            Margins.Bottom = 6
            ActivePage = TabSheet_ObrasGanhasEmails
            Align = alClient
            TabOrder = 0
            object TabSheet_ObrasGanhasEmails: TTabSheet
              Caption = 'E-mails'
              object Panel_ObrasGanhas: TPanel
                Left = 0
                Top = 0
                Width = 472
                Height = 13
                Margins.Bottom = 0
                Align = alTop
                BevelOuter = bvNone
                Caption = 'Por favor, coloque um e-mail por linha'
                TabOrder = 0
              end
              object Memo_ObrasGanhas: TMemo
                AlignWithMargins = True
                Left = 6
                Top = 16
                Width = 460
                Height = 96
                Margins.Left = 6
                Margins.Right = 6
                Margins.Bottom = 6
                Align = alClient
                Lines.Strings = (
                  'Memo_ObrasOciosas')
                TabOrder = 1
                OnChange = DoGuardarConfiguracoes
              end
            end
            object TabSheet_ObrasGanhasDefinicoes: TTabSheet
              Caption = 'Defini'#231#245'es'
              ImageIndex = 1
              object Button_ObrasGanhasLimparRegistros: TButton
                Left = 6
                Top = 6
                Width = 97
                Height = 25
                Action = Action_ObrasGanhasLimparRegistros
                TabOrder = 0
              end
            end
          end
        end
        object TabSheet_ObrasPerdidas: TTabSheet
          Caption = 'Obras perdidas'
          ImageIndex = 2
          object PageControl_ObrasPerdidas: TPageControl
            AlignWithMargins = True
            Left = 6
            Top = 6
            Width = 480
            Height = 146
            Margins.Left = 6
            Margins.Top = 6
            Margins.Right = 6
            Margins.Bottom = 6
            ActivePage = TabSheet_ObrasPerdidasEmails
            Align = alClient
            TabOrder = 0
            object TabSheet_ObrasPerdidasEmails: TTabSheet
              Caption = 'E-mails'
              object Panel_ObrasPerdidas: TPanel
                Left = 0
                Top = 0
                Width = 472
                Height = 13
                Margins.Bottom = 0
                Align = alTop
                BevelOuter = bvNone
                Caption = 'Por favor, coloque um e-mail por linha'
                TabOrder = 0
              end
              object Memo_ObrasPerdidas: TMemo
                AlignWithMargins = True
                Left = 6
                Top = 16
                Width = 460
                Height = 96
                Margins.Left = 6
                Margins.Right = 6
                Margins.Bottom = 6
                Align = alClient
                Lines.Strings = (
                  'Memo_ObrasOciosas')
                TabOrder = 1
                OnChange = DoGuardarConfiguracoes
              end
            end
            object TabSheet_ObrasPerdidasDefinicoes: TTabSheet
              Caption = 'Defini'#231#245'es'
              ImageIndex = 1
              object Button_ObrasPerdidasLimparRegistros: TButton
                Left = 6
                Top = 6
                Width = 97
                Height = 25
                Action = Action_ObrasPerdidasLimparRegistros
                TabOrder = 0
              end
            end
          end
        end
        object TabSheet_ObrasExpirando: TTabSheet
          Caption = 'Obras lim'#237'trofes'
          ImageIndex = 3
          object PageControl_ObrasExpirando: TPageControl
            AlignWithMargins = True
            Left = 6
            Top = 6
            Width = 480
            Height = 146
            Margins.Left = 6
            Margins.Top = 6
            Margins.Right = 6
            Margins.Bottom = 6
            ActivePage = TabSheet_ObrasExpirandoEmails
            Align = alClient
            TabOrder = 0
            object TabSheet_ObrasExpirandoEmails: TTabSheet
              Caption = 'E-mails'
              object Panel_ObrasLimitrofes: TPanel
                Left = 0
                Top = 0
                Width = 472
                Height = 13
                Margins.Bottom = 0
                Align = alTop
                BevelOuter = bvNone
                Caption = 'Por favor, coloque um e-mail por linha'
                TabOrder = 0
              end
              object Memo_ObrasLimitrofes: TMemo
                AlignWithMargins = True
                Left = 6
                Top = 16
                Width = 460
                Height = 96
                Margins.Left = 6
                Margins.Right = 6
                Margins.Bottom = 6
                Align = alClient
                Lines.Strings = (
                  'Memo_ObrasOciosas')
                TabOrder = 1
                OnChange = DoGuardarConfiguracoes
              end
            end
            object TabSheet_ObrasExpirandoConfiguracoes: TTabSheet
              Caption = 'Defini'#231#245'es'
              ImageIndex = 1
              object Label_ObrasLimitrofes: TLabel
                Left = 250
                Top = 10
                Width = 19
                Height = 13
                Caption = 'dias'
              end
              object Label_ObrasLimitrofesDias: TLabel
                Left = 192
                Top = 37
                Width = 230
                Height = 13
                Caption = 'dias ou menos para o prazo previsto de entrega'
              end
              object LabeledEdit_ObrasLimitrofes: TLabeledEdit
                Left = 209
                Top = 6
                Width = 19
                Height = 21
                EditLabel.Width = 197
                EditLabel.Height = 13
                EditLabel.Caption = 'Gerar estat'#237'sticas e enviar e-mails a cada'
                LabelPosition = lpLeft
                LabelSpacing = 6
                ReadOnly = True
                TabOrder = 0
                Text = '5'
                OnChange = DoGuardarConfiguracoes
              end
              object UpDown_ObrasLimitrofesIntervalo: TUpDown
                Left = 228
                Top = 6
                Width = 16
                Height = 21
                Associate = LabeledEdit_ObrasLimitrofes
                Min = 1
                Max = 30
                Position = 5
                TabOrder = 1
              end
              object LabeledEdit_ObrasLimitrofesDias: TLabeledEdit
                Left = 151
                Top = 33
                Width = 19
                Height = 21
                EditLabel.Width = 139
                EditLabel.Height = 13
                EditLabel.Caption = 'Selecionar apenas obras com'
                LabelPosition = lpLeft
                LabelSpacing = 6
                ReadOnly = True
                TabOrder = 2
                Text = '30'
                OnChange = DoGuardarConfiguracoes
              end
              object UpDown_ObrasLimitrofesDias: TUpDown
                Left = 170
                Top = 33
                Width = 16
                Height = 21
                Associate = LabeledEdit_ObrasLimitrofesDias
                Min = 30
                Max = 99
                Position = 30
                TabOrder = 3
              end
            end
          end
        end
      end
      object BitBtn_SMTPAtivarDesativar: TBitBtn
        AlignWithMargins = True
        Left = 6
        Top = 6
        Width = 500
        Height = 25
        Margins.Left = 6
        Margins.Top = 6
        Margins.Right = 6
        Action = Action_SMTPAtivarDesativar
        Align = alTop
        Caption = 'Ativar servi'#231'o de envio de e-mails via SMTP'
        TabOrder = 1
      end
    end
    object TabSheet_ServicoDeInformacoes: TTabSheet
      Caption = 'Servi'#231'o de informa'#231#245'es'
      ImageIndex = 2
      object BitBtn_HTTPAtivarDesativar: TBitBtn
        AlignWithMargins = True
        Left = 6
        Top = 6
        Width = 500
        Height = 25
        Margins.Left = 6
        Margins.Top = 6
        Margins.Right = 6
        Action = Action_HTTPAtivarDesativar
        Align = alTop
        Caption = 'Ativar servi'#231'o de informa'#231#245'es via HTTP'
        TabOrder = 0
      end
      object RichEdit_HTTPLog: TRichEdit
        AlignWithMargins = True
        Left = 6
        Top = 37
        Width = 500
        Height = 166
        Margins.Left = 6
        Margins.Right = 6
        Align = alClient
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'Courier New'
        Font.Style = []
        ParentFont = False
        ReadOnly = True
        ScrollBars = ssVertical
        TabOrder = 1
      end
      object Panel_Status: TPanel
        AlignWithMargins = True
        Left = 6
        Top = 209
        Width = 503
        Height = 17
        Margins.Left = 6
        Margins.Bottom = 6
        Align = alBottom
        BevelOuter = bvLowered
        Caption = 'Clientes conectados: ???'
        Color = clInfoBk
        ParentBackground = False
        TabOrder = 2
      end
    end
    object TabSheet_Configuracoes: TTabSheet
      Caption = 'Configura'#231#245'es'
      object PageControl_TiposDeConfiguracao: TPageControl
        AlignWithMargins = True
        Left = 6
        Top = 6
        Width = 500
        Height = 220
        Margins.Left = 6
        Margins.Top = 6
        Margins.Right = 6
        Margins.Bottom = 6
        ActivePage = TabSheet_ConfiguracoesEmailsAutomaticos
        Align = alClient
        TabOrder = 0
        object TabSheet_ConfiguracoesEmailsAutomaticos: TTabSheet
          Caption = 'E-mails autom'#225'ticos'
          ImageIndex = 1
          object Label_ConfiguracoesGerais: TLabel
            AlignWithMargins = True
            Left = 6
            Top = 0
            Width = 480
            Height = 39
            Margins.Left = 6
            Margins.Top = 0
            Margins.Right = 6
            Margins.Bottom = 0
            Align = alTop
            Alignment = taCenter
            AutoSize = False
            Caption = 
              'Estas configura'#231#245'es afetam o comportamento de envio de e-mails a' +
              'utom'#225'ticos e s'#227'o usadas juntamente com as configura'#231#245'es individu' +
              'ais presentes em cada uma das p'#225'ginas de e-mails autom'#225'ticos par' +
              'a a gera'#231#227'o e envio destes. Para alrer'#225'-las, primeiro desative o' +
              ' envio de e-mails.'
            WordWrap = True
          end
          object Bevel_ConfiguracoesGerais: TBevel
            AlignWithMargins = True
            Left = 6
            Top = 45
            Width = 480
            Height = 2
            Margins.Left = 6
            Margins.Top = 6
            Margins.Right = 6
            Align = alTop
            Shape = bsTopLine
            ExplicitLeft = -8
            ExplicitTop = 48
            ExplicitWidth = 500
          end
          object Label_IntervaloDeChecagemGeral: TLabel
            Left = 255
            Top = 57
            Width = 37
            Height = 13
            Caption = 'minutos'
          end
          object LabeledEdit_IntervaloDeChecagemGeral: TLabeledEdit
            Left = 214
            Top = 53
            Width = 19
            Height = 21
            EditLabel.Width = 203
            EditLabel.Height = 13
            EditLabel.Caption = 'Realizar consultas '#224' base de dados a cada'
            LabelPosition = lpLeft
            LabelSpacing = 6
            ReadOnly = True
            TabOrder = 0
            Text = '60'
            OnChange = DoGuardarConfiguracoes
          end
          object UpDown_IntervaloDeChecagemGeral: TUpDown
            Left = 233
            Top = 53
            Width = 16
            Height = 21
            Associate = LabeledEdit_IntervaloDeChecagemGeral
            Min = 5
            Max = 60
            Position = 60
            TabOrder = 1
          end
        end
        object TabSheet_ConfiguracoesSMTP: TTabSheet
          Caption = 'SMTP (E-mails autom'#225'ticos)'
          DesignSize = (
            492
            192)
          object Label_ConfiguracoesSMTP: TLabel
            AlignWithMargins = True
            Left = 6
            Top = 0
            Width = 480
            Height = 39
            Margins.Left = 6
            Margins.Top = 0
            Margins.Right = 6
            Margins.Bottom = 0
            Align = alTop
            Alignment = taCenter
            AutoSize = False
            Caption = 
              'Estas configura'#231#245'es afetam o envio de todos os e-mails configura' +
              'dos na p'#225'gina"E-mails autom'#225'ticos". As configura'#231#245'es s'#243' podem se' +
              'r alteradas enquanto o envio de e-mails autom'#225'ticos estiver desa' +
              'bilitado. Desative-o, se necess'#225'rio, na p'#225'gina "E-mails autom'#225'ti' +
              'cos"'
            WordWrap = True
          end
          object Bevel_Linha2: TBevel
            AlignWithMargins = True
            Left = 6
            Top = 45
            Width = 480
            Height = 2
            Margins.Left = 6
            Margins.Top = 6
            Margins.Right = 6
            Align = alTop
            Shape = bsTopLine
            ExplicitLeft = -8
            ExplicitTop = 48
            ExplicitWidth = 500
          end
          object Label_Priority: TLabel
            Left = 6
            Top = 53
            Width = 48
            Height = 13
            Caption = 'Prioridade'
          end
          object Label_ContentType: TLabel
            Left = 92
            Top = 53
            Width = 83
            Height = 13
            Caption = 'Tipo de conte'#250'do'
          end
          object Label_SendMode: TLabel
            Left = 181
            Top = 53
            Width = 70
            Height = 13
            Caption = 'Modo de envio'
          end
          object Label_ShareMode: TLabel
            Left = 292
            Top = 53
            Width = 87
            Height = 13
            Caption = 'Compartilhamento'
          end
          object Label_SMTPDefaultEncoding: TLabel
            Left = 6
            Top = 92
            Width = 92
            Height = 13
            Caption = 'Codifica'#231#227'o padr'#227'o'
          end
          object Label_SMTPAutenticacao: TLabel
            Left = 122
            Top = 92
            Width = 63
            Height = 13
            Caption = 'Autentica'#231#227'o'
          end
          object ComboBox_Priority: TComboBox
            Left = 6
            Top = 67
            Width = 80
            Height = 21
            Style = csDropDownList
            ItemHeight = 13
            ItemIndex = 5
            TabOrder = 0
            Text = 'Muito baixa'
            OnChange = DoGuardarConfiguracoes
            Items.Strings = (
              'Nenhuma'
              'Muito alta'
              'Alta'
              'Normal'
              'Baixa'
              'Muito baixa')
          end
          object ComboBox_ContentType: TComboBox
            Left = 92
            Top = 67
            Width = 83
            Height = 21
            Style = csDropDownList
            ItemHeight = 13
            ItemIndex = 1
            TabOrder = 1
            Text = 'Texto plano'
            OnChange = DoGuardarConfiguracoes
            Items.Strings = (
              'HTML'
              'Texto plano')
          end
          object ComboBox_SendMode: TComboBox
            Left = 181
            Top = 67
            Width = 105
            Height = 21
            Style = csDropDownList
            ItemHeight = 13
            ItemIndex = 2
            TabOrder = 2
            Text = 'C'#243'pia via stream'
            OnChange = DoGuardarConfiguracoes
            Items.Strings = (
              'Via socket'
              'Via stream'
              'C'#243'pia via stream')
          end
          object CheckBox_Confirm: TCheckBox
            Left = 360
            Top = 172
            Width = 126
            Height = 13
            Caption = 'Confirmar recebimento'
            TabOrder = 14
            OnClick = DoGuardarConfiguracoes
          end
          object CheckBox_WrapMessageText: TCheckBox
            Left = 183
            Top = 172
            Width = 155
            Height = 13
            Caption = 'Quebrar texto da mensagem'
            TabOrder = 13
            OnClick = DoGuardarConfiguracoes
          end
          object ComboBox_ShareMode: TComboBox
            Left = 292
            Top = 67
            Width = 102
            Height = 21
            Style = csDropDownList
            ItemHeight = 13
            ItemIndex = 4
            TabOrder = 3
            Text = 'N'#227'o negar nada'
            OnChange = DoGuardarConfiguracoes
            Items.Strings = (
              'Compat'#237'vel'
              'Exclusivo'
              'Negar grava'#231#227'o'
              'Negar leitura'
              'N'#227'o negar nada')
          end
          object LabeledEdit_SMTPLogin: TLabeledEdit
            Left = 168
            Top = 145
            Width = 156
            Height = 21
            Anchors = [akLeft, akTop, akRight]
            EditLabel.Width = 25
            EditLabel.Height = 13
            EditLabel.Caption = 'Login'
            LabelSpacing = 1
            TabOrder = 10
            OnChange = DoGuardarConfiguracoes
          end
          object LabeledEdit_SMTPSenha: TLabeledEdit
            Left = 330
            Top = 145
            Width = 156
            Height = 21
            EditLabel.Width = 30
            EditLabel.Height = 13
            EditLabel.Caption = 'Senha'
            LabelSpacing = 1
            PasswordChar = #248
            TabOrder = 11
            OnChange = DoGuardarConfiguracoes
          end
          object LabeledEdit_SMTPHost: TLabeledEdit
            Left = 6
            Top = 145
            Width = 156
            Height = 21
            Anchors = [akLeft, akTop, akRight]
            EditLabel.Width = 84
            EditLabel.Height = 13
            EditLabel.Caption = 'Endere'#231'o do host'
            LabelSpacing = 1
            TabOrder = 9
            OnChange = DoGuardarConfiguracoes
          end
          object LabeledEdit_SMTPFrom: TLabeledEdit
            Left = 207
            Top = 106
            Width = 154
            Height = 21
            Anchors = [akLeft, akTop, akRight]
            EditLabel.Width = 108
            EditLabel.Height = 13
            EditLabel.Caption = 'E-mail da conta (From)'
            LabelSpacing = 1
            TabOrder = 7
            OnChange = DoGuardarConfiguracoes
          end
          object LabeledEdit_SMTPAssinatura: TLabeledEdit
            Left = 367
            Top = 106
            Width = 119
            Height = 21
            Anchors = [akLeft, akTop, akRight]
            EditLabel.Width = 51
            EditLabel.Height = 13
            EditLabel.Caption = 'Assinatura'
            LabelSpacing = 1
            TabOrder = 8
            OnChange = DoGuardarConfiguracoes
          end
          object LabeledEdit_SMTPCharSet: TLabeledEdit
            Left = 400
            Top = 67
            Width = 86
            Height = 21
            Anchors = [akLeft, akTop, akRight]
            EditLabel.Width = 76
            EditLabel.Height = 13
            EditLabel.Caption = 'Conj. de Carac.'
            LabelSpacing = 1
            TabOrder = 4
            OnChange = DoGuardarConfiguracoes
          end
          object ComboBox_SMTPDefaultEncoding: TComboBox
            Left = 6
            Top = 106
            Width = 110
            Height = 21
            Style = csDropDownList
            ItemHeight = 13
            ItemIndex = 2
            TabOrder = 5
            Text = 'Cita'#231#227'o imprim'#237'vel'
            OnChange = DoGuardarConfiguracoes
            Items.Strings = (
              '7 bits'
              '8 bits'
              'Cita'#231#227'o imprim'#237'vel'
              'Base 64')
          end
          object CheckBox_SMTPAllow8bitChars: TCheckBox
            Left = 6
            Top = 172
            Width = 151
            Height = 13
            Caption = 'Permitir caracteres de 8 bits'
            TabOrder = 12
            OnClick = DoGuardarConfiguracoes
          end
          object ComboBox_SMTPAutenticacao: TComboBox
            Left = 122
            Top = 106
            Width = 79
            Height = 21
            Style = csDropDownList
            ItemHeight = 13
            ItemIndex = 5
            TabOrder = 6
            Text = 'Autom'#225'tica'
            OnChange = DoGuardarConfiguracoes
            Items.Strings = (
              'Nenhuma'
              'Plana'
              'Simples'
              'CramMD5'
              'CramSHA1'
              'Autom'#225'tica')
          end
        end
        object TabSheet_ConfiguracoesBD: TTabSheet
          Caption = 'Banco de dados'
          ImageIndex = 2
          DesignSize = (
            492
            192)
          object Label_BancoDeDados: TLabel
            AlignWithMargins = True
            Left = 6
            Top = 0
            Width = 480
            Height = 39
            Margins.Left = 6
            Margins.Top = 0
            Margins.Right = 6
            Margins.Bottom = 0
            Align = alTop
            Alignment = taCenter
            AutoSize = False
            Caption = 
              'Nesta p'#225'gina devem ser informados os dados para conex'#227'o com o ba' +
              'nco de dados do Banco De Obras. O n'#227'o preenchimento correto pode' +
              ' ocasionar mal funcionamento desta aplica'#231#227'o. Altera'#231#245'es nesta p' +
              #225'gina s'#243' ter'#227'o efeito quando a aplica'#231#227'o for reiniciada.'
            WordWrap = True
          end
          object Bevel_BancoDeDados: TBevel
            AlignWithMargins = True
            Left = 6
            Top = 45
            Width = 480
            Height = 2
            Margins.Left = 6
            Margins.Top = 6
            Margins.Right = 6
            Align = alTop
            Shape = bsTopLine
            ExplicitLeft = -8
            ExplicitTop = 48
            ExplicitWidth = 500
          end
          object LabelProtocolo: TLabel
            Left = 6
            Top = 53
            Width = 139
            Height = 13
            Caption = 'Protocolo do banco de dados'
            Color = clGreen
            ParentColor = False
            Transparent = True
          end
          object LabelIsolationLevel: TLabel
            Left = 151
            Top = 53
            Width = 153
            Height = 13
            Caption = 'N'#237'vel de isolamento transacional'
          end
          object ComboBoxProtocolo: TComboBox
            Left = 6
            Top = 67
            Width = 139
            Height = 21
            Style = csDropDownList
            ItemHeight = 13
            TabOrder = 0
            OnChange = DoGuardarConfiguracoes
          end
          object ComboBoxIsolationLevel: TComboBox
            Left = 151
            Top = 67
            Width = 153
            Height = 21
            Style = csDropDownList
            ItemHeight = 13
            TabOrder = 1
            OnChange = DoGuardarConfiguracoes
          end
          object EditEnderecoDoHost: TLabeledEdit
            Left = 310
            Top = 67
            Width = 118
            Height = 21
            Anchors = [akLeft, akTop, akRight]
            EditLabel.Width = 84
            EditLabel.Height = 13
            EditLabel.Caption = 'Endere'#231'o do host'
            LabelSpacing = 1
            TabOrder = 2
            OnChange = DoGuardarConfiguracoes
          end
          object EditPorta: TLabeledEdit
            Left = 434
            Top = 67
            Width = 52
            Height = 21
            Anchors = [akTop, akRight]
            EditLabel.Width = 26
            EditLabel.Height = 13
            EditLabel.Caption = 'Porta'
            LabelSpacing = 1
            TabOrder = 3
            OnChange = DoGuardarConfiguracoes
            OnKeyPress = DoKeyPresss
          end
          object EditBancoDeDados: TLabeledEdit
            Left = 6
            Top = 106
            Width = 156
            Height = 21
            Anchors = [akLeft, akTop, akRight]
            EditLabel.Width = 121
            EditLabel.Height = 13
            EditLabel.Caption = 'Nome do banco de dados'
            LabelSpacing = 1
            TabOrder = 4
            OnChange = DoGuardarConfiguracoes
          end
          object EditNomeDeUsuario: TLabeledEdit
            Left = 168
            Top = 106
            Width = 156
            Height = 21
            EditLabel.Width = 80
            EditLabel.Height = 13
            EditLabel.Caption = 'Nome de usu'#225'rio'
            LabelSpacing = 1
            TabOrder = 5
            OnChange = DoGuardarConfiguracoes
          end
          object EditSenha: TLabeledEdit
            Left = 330
            Top = 106
            Width = 156
            Height = 21
            Anchors = [akTop, akRight]
            EditLabel.Width = 30
            EditLabel.Height = 13
            EditLabel.Caption = 'Senha'
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clWindowText
            Font.Height = -11
            Font.Name = 'Tahoma'
            Font.Style = []
            LabelSpacing = 1
            ParentFont = False
            PasswordChar = #248
            TabOrder = 6
            OnChange = DoGuardarConfiguracoes
          end
        end
        object TabSheet_ConfiguracoesHTTP: TTabSheet
          Caption = 'HTTP (Servi'#231'o de informa'#231#245'es)'
          ImageIndex = 3
          object Shape_HTTPDocumentRoot: TShape
            Left = 6
            Top = 93
            Width = 480
            Height = 17
            Brush.Color = clActiveCaption
            Pen.Color = clCaptionText
          end
          object Shape_HTTPDefaultDocument: TShape
            Left = 6
            Top = 166
            Width = 480
            Height = 17
            Brush.Color = clActiveCaption
            Pen.Color = clCaptionText
          end
          object Shape_HTTPTemplatesDir: TShape
            Left = 6
            Top = 129
            Width = 480
            Height = 17
            Brush.Color = clActiveCaption
            Pen.Color = clCaptionText
          end
          object Label_DocumentRootValor: TLabel
            Left = 8
            Top = 95
            Width = 476
            Height = 13
            Alignment = taCenter
            AutoSize = False
            Caption = '...'
            Color = clRed
            EllipsisPosition = epPathEllipsis
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clCaptionText
            Font.Height = -11
            Font.Name = 'Tahoma'
            Font.Style = [fsBold]
            ParentColor = False
            ParentFont = False
            Transparent = True
          end
          object Label_ConfiguracoesHTTP: TLabel
            AlignWithMargins = True
            Left = 6
            Top = 0
            Width = 480
            Height = 39
            Margins.Left = 6
            Margins.Top = 0
            Margins.Right = 6
            Margins.Bottom = 0
            Align = alTop
            Alignment = taCenter
            AutoSize = False
            Caption = 
              'Todas as configura'#231#245'es do servi'#231'o de informa'#231#245'es s'#227'o autom'#225'ticas' +
              ', com exce'#231#227'o da porta do servidor HTTP, que deve ser informada ' +
              'aqui. Para alterar a porta, primeiro desative o servi'#231'o de infor' +
              'ma'#231#227'o em sua p'#225'gina correspondente para s'#243' assim poder editar o ' +
              'valor.'
            WordWrap = True
          end
          object Bevel_ConfiguracoesHTTP: TBevel
            AlignWithMargins = True
            Left = 6
            Top = 45
            Width = 480
            Height = 2
            Margins.Left = 6
            Margins.Top = 6
            Margins.Right = 6
            Align = alTop
            Shape = bsTopLine
            ExplicitLeft = -8
            ExplicitTop = 48
            ExplicitWidth = 500
          end
          object Label_HTTPDocumentRoot: TLabel
            Left = 6
            Top = 80
            Width = 480
            Height = 13
            Alignment = taCenter
            AutoSize = False
            Caption = 'Diret'#243'rio raiz do servidor'
          end
          object Label_HTTPTemplateDir: TLabel
            Left = 6
            Top = 116
            Width = 480
            Height = 13
            Alignment = taCenter
            AutoSize = False
            Caption = 'Diret'#243'rio de templates do servidor'
          end
          object Label_HTTPDocumentoPadrao: TLabel
            Left = 6
            Top = 152
            Width = 480
            Height = 13
            Alignment = taCenter
            AutoSize = False
            Caption = 'Documento padr'#227'o'
          end
          object Label_HTTPTemplateDirValor: TLabel
            Left = 8
            Top = 131
            Width = 476
            Height = 13
            Alignment = taCenter
            AutoSize = False
            Caption = '...'
            Color = clRed
            EllipsisPosition = epPathEllipsis
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clCaptionText
            Font.Height = -11
            Font.Name = 'Tahoma'
            Font.Style = [fsBold]
            ParentColor = False
            ParentFont = False
            Transparent = True
          end
          object Label_HTTPDocumentoPadraoValor: TLabel
            Left = 8
            Top = 168
            Width = 476
            Height = 13
            Alignment = taCenter
            AutoSize = False
            Caption = '...'
            Color = clRed
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clCaptionText
            Font.Height = -11
            Font.Name = 'Tahoma'
            Font.Style = [fsBold]
            ParentColor = False
            ParentFont = False
            Transparent = True
          end
          object LabeledEdit_PortaHTTP: TLabeledEdit
            Left = 188
            Top = 53
            Width = 30
            Height = 21
            EditLabel.Width = 176
            EditLabel.Height = 13
            EditLabel.Caption = 'Atender a requisi'#231#245'es HTTP na porta'
            LabelPosition = lpLeft
            LabelSpacing = 6
            TabOrder = 0
            Text = '8888'
            OnChange = DoGuardarConfiguracoes
            OnKeyPress = DoKeyPresss
          end
        end
      end
    end
  end
  inherited ActionList_LocalActions: TActionList
    object Action_MinimizarNoTray: TAction
      Caption = 'Minimizar na '#225'rea de notifica'#231#227'o do sistema'
      OnExecute = Action_MinimizarNoTrayExecute
    end
    object Action_RestaurarDoTray: TAction
      Caption = 'Restaurar aplica'#231#227'o'
      OnExecute = Action_RestaurarDoTrayExecute
    end
    object Action_FecharAplicacao: TAction
      Caption = 'Fechar Aplica'#231#227'o'
      OnExecute = Action_FecharAplicacaoExecute
    end
    object Action_SalvarConfiguracoes: TAction
      Caption = 'Salvar Configura'#231#245'es'
      OnExecute = Action_SalvarConfiguracoesExecute
    end
    object Action_HTTPAtivarDesativar: TAction
      Caption = 'Ativar servi'#231'o de informa'#231#245'es via HTTP'
      OnExecute = Action_HTTPAtivarDesativarExecute
    end
    object Action_SMTPAtivarDesativar: TAction
      Caption = 'Ativar servi'#231'o de envio de e-mails via SMTP'
      OnExecute = Action_SMTPAtivarDesativarExecute
    end
    object Action_ObrasPerdidasLimparRegistros: TAction
      Category = 'Obras Perdidas'
      Caption = 'Limpar registros'
      OnExecute = Action_ObrasPerdidasLimparRegistrosExecute
    end
    object Action_ObrasGanhasLimparRegistros: TAction
      Category = 'Obras Ganhas'
      Caption = 'Limpar registros'
      OnExecute = Action_ObrasGanhasLimparRegistrosExecute
    end
  end
end
