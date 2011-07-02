object FSCForm_Main: TFSCForm_Main
  Left = 0
  Top = 0
  BorderIcons = [biSystemMenu, biMinimize]
  BorderStyle = bsSingle
  Caption = 'FTP Synchronizer'
  ClientHeight = 453
  ClientWidth = 843
  Color = clBtnFace
  Constraints.MaxHeight = 485
  Constraints.MaxWidth = 849
  Constraints.MinHeight = 478
  Constraints.MinWidth = 849
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  Position = poScreenCenter
  OnCloseQuery = FormCloseQuery
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  DesignSize = (
    843
    453)
  PixelsPerInch = 96
  TextHeight = 13
  object Bevel1: TBevel
    Left = 3
    Top = 408
    Width = 836
    Height = 13
    Anchors = [akLeft, akRight, akBottom]
    Shape = bsBottomLine
  end
  object Label3: TLabel
    Left = 669
    Top = 425
    Width = 63
    Height = 24
    Alignment = taCenter
    Anchors = [akRight, akBottom]
    AutoSize = False
    Caption = '0%'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -20
    Font.Name = 'Tahoma'
    Font.Style = [fsBold]
    ParentFont = False
  end
  object ProgressBar1: TProgressBar
    Left = 3
    Top = 425
    Width = 662
    Height = 25
    Anchors = [akLeft, akRight, akBottom]
    Step = 1
    TabOrder = 4
  end
  object PageControl1: TPageControl
    Left = 0
    Top = 25
    Width = 843
    Height = 172
    ActivePage = TabSheet2
    TabOrder = 0
    OnChanging = PageControl1Changing
    object TabSheet1: TTabSheet
      Caption = 'Sincroniza'#231#227'o por diferen'#231'as'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'Tahoma'
      Font.Style = []
      ParentFont = False
      object Label2: TLabel
        Left = 6
        Top = 6
        Width = 822
        Height = 56
        Alignment = taCenter
        AutoSize = False
        Caption = 
          'Este '#233' o tipo mais simples e edequado de sincroniza'#231#227'o. Primeira' +
          'mente '#233' verificado se existem altera'#231#245'es locais a serem sincroni' +
          'zadas com o servidor. Se existem tais informa'#231#245'es, primeiramente' +
          ' '#233' verificado se outros usu'#225'rios fizeram altera'#231#245'es, aplicando e' +
          'stas localmente. Em seguida nossas altera'#231#245'es ser'#227'o enviadas ao ' +
          'servidor e, no final, seu banco de dados local ser'#225' exatamente i' +
          'gual ao banco de dados remoto. Se n'#227'o existem altera'#231#245'es locais ' +
          'ser'#225' verificado se existem altera'#231#245'es no servidor. Se existirem,' +
          ' tais informa'#231#245'es ser'#227'o aplicadas localmente e tal como no caso ' +
          'anterior, o banco de dados local ser'#225' exatamente igual ao banco ' +
          'de dados remoto.'
        WordWrap = True
      end
      object PanelDiferencasA: TPanel
        Left = 6
        Top = 76
        Width = 822
        Height = 61
        BevelInner = bvLowered
        TabOrder = 0
        object SincronizarD_A: TButton
          Left = 193
          Top = 18
          Width = 435
          Height = 25
          Caption = 
            'Clique aqui para sincronizar o banco dedados local com o banco d' +
            'e dados remoto'
          TabOrder = 0
          OnClick = SincronizarD_AClick
        end
        object ButtonStop1: TButton
          Left = 726
          Top = 32
          Width = 92
          Height = 25
          Caption = 'Interromper'
          TabOrder = 1
          Visible = False
        end
      end
    end
    object TabSheet_SincronizacaoDeCache: TTabSheet
      Caption = 'Sincroniza'#231#227'o de cache'
      ImageIndex = 3
    end
    object TabSheet2: TTabSheet
      Caption = 'Sincroniza'#231#227'o completa'
      ImageIndex = 1
      object Label1: TLabel
        Left = 6
        Top = 6
        Width = 822
        Height = 71
        Alignment = taCenter
        AutoSize = False
        Caption = 
          'A sincroniza'#231#227'o completa '#233' adequada para realizar a sincroniza'#231#227 +
          'o inicial entre o banco de dados local e o banco de dados remoto' +
          '. Este tipo de sincroniza'#231#227'o n'#227'o verifica diferen'#231'as. Uma c'#243'pia ' +
          'completa em texto do banco de dados remoto '#233' feita no computador' +
          ' remoto transferida para o computador local. Em seguida essa c'#243'p' +
          'ia '#233' executada localmente. ATEN'#199#195'O! Essa opera'#231#227'o DESTR'#211'I comple' +
          'tamente o banco de dados local e o recria de forma que ele se to' +
          'rne exatamente igual ao banco de dados remoto. N'#195'O REALIZE ESTA ' +
          'OPERA'#199#195'O A N'#195'O SER QUE ESTEJA CIENTE DE QUE TODOS OS SEUS DADOS ' +
          'LOCAIS QUE N'#195'O FORAM SINCRONIZADOS COM O SERVIDOR  -- EM UMA OPE' +
          'RA'#199#195'O DE SINCRONIZA'#199#195'O POR DIFEREN'#199'AS -- SER'#195'O PERMANENTEMENTE P' +
          'ERDIDOS.'
        WordWrap = True
      end
      object Label5: TLabel
        Left = 91
        Top = 45
        Width = 725
        Height = 13
        Caption = 
          'N'#195'O REALIZE ESTA OPERA'#199#195'O A N'#195'O SER QUE ESTEJA CIENTE DE QUE TOD' +
          'OS OS SEUS DADOS LOCAIS QUE N'#195'O FORAM SINCRONIZADOS COM O'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clRed
        Font.Height = -11
        Font.Name = 'Tahoma'
        Font.Style = []
        ParentFont = False
        Transparent = True
      end
      object Label6: TLabel
        Left = 133
        Top = 58
        Width = 564
        Height = 13
        Caption = 
          'SERVIDOR  -- EM UMA OPERA'#199#195'O DE SINCRONIZA'#199#195'O POR DIFEREN'#199'AS -- ' +
          'SER'#195'O PERMANENTEMENTE PERDIDOS'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clRed
        Font.Height = -11
        Font.Name = 'Tahoma'
        Font.Style = []
        ParentFont = False
        Transparent = True
      end
      object PanelInicialA: TPanel
        Left = 6
        Top = 76
        Width = 822
        Height = 61
        BevelInner = bvLowered
        TabOrder = 0
        object SincronizarC_A: TButton
          Left = 5
          Top = 5
          Width = 405
          Height = 25
          Caption = 
            'Clique aqui para sincronizar o banco dedados local com o banco d' +
            'e dados remoto'
          TabOrder = 0
          OnClick = SincronizarC_AClick
        end
        object Button_SalvarArquivoDeDados: TButton
          Left = 413
          Top = 32
          Width = 405
          Height = 25
          Caption = 'Exportar arquivo de dados'
          TabOrder = 1
          OnClick = Button_SalvarArquivoDeDadosClick
        end
        object Button_ContinuarSincronizacaoCompleta: TButton
          Left = 413
          Top = 5
          Width = 405
          Height = 25
          Caption = 
            'Clique aqui para continuar uma sincroniza'#231#227'o completa interrompi' +
            'da'
          TabOrder = 2
          OnClick = Button_ContinuarSincronizacaoCompletaClick
        end
        object Button_CarregarArquivoDeDados: TButton
          Left = 5
          Top = 32
          Width = 405
          Height = 25
          Caption = 'Importar arquivo de dados'
          TabOrder = 3
          OnClick = Button_CarregarArquivoDeDadosClick
        end
      end
    end
    object TabSheet3: TTabSheet
      Caption = 'Gerador de snapshots'
      ImageIndex = 2
      object Label4: TLabel
        Left = 6
        Top = 6
        Width = 822
        Height = 26
        Alignment = taCenter
        AutoSize = False
        Caption = 
          'Snapshots s'#227'o como "fotografias instant'#226'neas" do banco de dados.' +
          ' De posse dos snapshots remoto (servidor) e local, o desenvolved' +
          'or pode fazer uma simula'#231#227'o a fim de auxili'#225'-lo na resolu'#231#227'o de ' +
          'v'#225'rios problemas. Snapshots s'#227'o salvos dentro da pasta do FTPSyn' +
          'cronizer em uma pasta de nome "Snapshots"'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'Tahoma'
        Font.Style = []
        ParentFont = False
        WordWrap = True
      end
      object PanelSnapshotA: TPanel
        Left = 6
        Top = 76
        Width = 822
        Height = 61
        BevelInner = bvLowered
        TabOrder = 1
        object MakeSnapshot_A: TButton
          Left = 193
          Top = 18
          Width = 435
          Height = 25
          Caption = 
            'Clique aqui para gerar o(s) snapshot(s) de acordo com a op'#231#227'o se' +
            'lecionada acima'
          TabOrder = 0
          OnClick = MakeSnapshot_AClick
        end
        object ButtonStop3: TButton
          Left = 726
          Top = 32
          Width = 92
          Height = 25
          Caption = 'Interromper'
          TabOrder = 1
          Visible = False
        end
      end
      object GroupBox1: TGroupBox
        Left = 6
        Top = 33
        Width = 822
        Height = 37
        Caption = ' Gerar snapshot... '
        TabOrder = 0
        DesignSize = (
          822
          37)
        object RadioButtonRemoto: TRadioButton
          Left = 385
          Top = 15
          Width = 54
          Height = 13
          Anchors = [akTop]
          Caption = 'Remoto'
          TabOrder = 0
        end
        object RadioButtonLocal: TRadioButton
          Left = 9
          Top = 15
          Width = 41
          Height = 13
          Caption = 'Local'
          Checked = True
          TabOrder = 1
          TabStop = True
        end
        object RadioButtonAmbos: TRadioButton
          Left = 762
          Top = 15
          Width = 49
          Height = 13
          Anchors = [akTop, akRight]
          Caption = 'Ambos'
          TabOrder = 2
        end
      end
    end
  end
  object MenuPrincipal: TActionMainMenuBar
    Left = 0
    Top = 0
    Width = 843
    Height = 25
    UseSystemFont = False
    ActionManager = ActionManager1
    Caption = 'MenuPrincipal'
    ColorMap.HighlightColor = clWhite
    ColorMap.BtnSelectedColor = clBtnFace
    ColorMap.UnusedColor = clWhite
    EdgeBorders = [ebBottom]
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'Tahoma'
    Font.Style = []
    Spacing = 0
  end
  object RichEditLog: TRichEdit
    Left = 0
    Top = 197
    Width = 843
    Height = 218
    Font.Charset = ANSI_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'Courier New'
    Font.Style = []
    ParentFont = False
    ReadOnly = True
    ScrollBars = ssVertical
    TabOrder = 1
    WordWrap = False
  end
  object SalvarLog: TButton
    Left = 736
    Top = 425
    Width = 104
    Height = 25
    Anchors = [akRight, akBottom]
    Caption = 'Salvar log como...'
    TabOrder = 5
    OnClick = SalvarLogClick
  end
  object PanelExecutandoSQL: TPanel
    Left = 3
    Top = 424
    Width = 729
    Height = 26
    AutoSize = True
    BevelOuter = bvNone
    ParentBackground = False
    TabOrder = 2
    Visible = False
    object LabelInstrucoes: TLabel
      Left = 284
      Top = 12
      Width = 139
      Height = 13
      AutoSize = False
      Caption = 'Instru'#231#245'es...............................'
    end
    object LabelBlocos: TLabel
      Left = 284
      Top = 0
      Width = 139
      Height = 13
      AutoSize = False
      Caption = 'Blocos..................................'
      FocusControl = ButtonStop1
    end
    object LabelInstrucoesValor: TLabel
      Left = 426
      Top = 12
      Width = 19
      Height = 13
      Alignment = taRightJustify
      Caption = '0/?'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'Tahoma'
      Font.Style = [fsBold]
      ParentFont = False
    end
    object LabelBlocosValor: TLabel
      Left = 426
      Top = 0
      Width = 19
      Height = 13
      Alignment = taRightJustify
      Caption = '0/?'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'Tahoma'
      Font.Style = [fsBold]
      ParentFont = False
    end
    object ProgressBarBlocos: TProgressBar
      Left = 0
      Top = 1
      Width = 278
      Height = 25
      TabOrder = 0
    end
    object ProgressBarInstrucoes: TProgressBar
      Left = 451
      Top = 1
      Width = 278
      Height = 25
      TabOrder = 1
    end
  end
  object FTPClient: TFtpClient
    Timeout = 1200
    MultiThreaded = False
    Port = 'ftp'
    CodePage = 0
    DataPortRangeStart = 0
    DataPortRangeEnd = 0
    LocalAddr = '0.0.0.0'
    DisplayFileFlag = False
    Binary = True
    ShareMode = ftpShareExclusive
    Options = [ftpAcceptLF, ftpWaitUsingSleep]
    ConnectionType = ftpDirect
    Language = 'EN'
    OnDisplay = FTPClientDisplay
    OnCommand = FTPClientCommand
    OnResponse = FTPClientResponse
    OnProgress64 = FTPClientProgress64
    OnSessionClosed = DoSessionClosed
    OnRequestDone = FTPClientRequestDone
    BandwidthLimit = 10000
    BandwidthSampling = 1000
    Left = 758
    Top = 199
  end
  object ActionManager1: TActionManager
    ActionBars = <
      item
        Items = <
          item
            Items = <
              item
                Action = ActionConfig
                Caption = '&Configura'#231#245'es gerais...'
              end
              item
                Items = <
                  item
                    Action = ActionObterDadosTemporariosEmCasoDeErro
                    Caption = '&Obter dados tempor'#225'rios em caso de erro'
                  end>
                Caption = 'C&onfigura'#231#245'es avan'#231'adas'
                UsageCount = 1
              end>
            Caption = '&Configura'#231#245'es'
          end
          item
            Items = <
              item
                Action = Action1
                Caption = '&Sobre o FTP Syncronizer...'
              end>
            Caption = '&Ajuda'
          end
          item
            Items = <
              item
                Action = ActionChecarChavesEstrangeiras
                Caption = '&Checar chaves estrangeiras (Experimental, n'#227'o altere!)'
              end
              item
                Action = Action_DiffSimulationMode
                Caption = '&Modo simulado'
              end
              item
                Action = Action_ConfirmarMesmoEmCasoDeErro
                Caption = 'C&onfirmar mesmo em caso de erro'
              end
              item
                Action = Action_SalvarScriptGerado
                Caption = '&Salvar script gerado'
              end
              item
                Action = Action_TesteDeTamanhoDeConteudo
                Caption = 'T&este de tamanho de conte'#250'do'
              end
              item
                Action = Action_TesteDeTimeout
                Caption = '&Teste de "timeout"'
              end>
            Visible = False
            Caption = '&Desenvolvimento'
          end>
        ActionBar = MenuPrincipal
      end>
    Left = 786
    Top = 199
    StyleName = 'XP Style'
    object ActionConfig: TAction
      Category = 'Configura'#231#245'es'
      Caption = 'Configura'#231#245'es gerais...'
      OnExecute = ActionConfigExecute
    end
    object Action1: TAction
      Category = 'Ajuda'
      Caption = 'Sobre o FTP Syncronizer...'
      OnExecute = Action1Execute
    end
    object ActionChecarChavesEstrangeiras: TAction
      Category = 'Desenvolvimento'
      AutoCheck = True
      Caption = 'Checar chaves estrangeiras (Experimental, n'#227'o altere!)'
      Checked = True
      OnExecute = ActionChecarChavesEstrangeirasExecute
    end
    object ActionObterDadosTemporariosEmCasoDeErro: TAction
      Category = 'Configura'#231#245'es avan'#231'adas'
      AutoCheck = True
      Caption = 'Obter dados tempor'#225'rios em caso de erro'
      OnExecute = ActionObterDadosTemporariosEmCasoDeErroExecute
    end
    object Action_DiffSimulationMode: TAction
      Category = 'Desenvolvimento'
      AutoCheck = True
      Caption = 'Modo simulado'
      Hint = 
        'Executa todas as opera'#231#245'es de uma sincroniza'#231#227'o por diferen'#231'as m' +
        'as incondicionalmente desfaz tais opera'#231#245'es ao final do processo'
      OnExecute = Action_DiffSimulationModeExecute
    end
    object Action_ConfirmarMesmoEmCasoDeErro: TAction
      Category = 'Desenvolvimento'
      AutoCheck = True
      Caption = 'Confirmar mesmo em caso de erro'
      OnExecute = Action_ConfirmarMesmoEmCasoDeErroExecute
    end
    object Action_SalvarScriptGerado: TAction
      Category = 'Desenvolvimento'
      AutoCheck = True
      Caption = 'Salvar script gerado'
      OnExecute = Action_SalvarScriptGeradoExecute
    end
    object Action_TesteDeTimeout: TAction
      Category = 'Desenvolvimento'
      Caption = 'Teste de "timeout"'
      OnExecute = Action_TesteDeTimeoutExecute
    end
    object Action_TesteDeTamanhoDeConteudo: TAction
      Category = 'Desenvolvimento'
      Caption = 'Teste de tamanho de conte'#250'do'
      OnExecute = Action_TesteDeTamanhoDeConteudoExecute
    end
  end
  object SaveDialog1: TSaveDialog
    DefaultExt = 'rtf'
    Filter = 'Arquivos de log RTF (*.rtf)|*.rtf'
    Options = [ofOverwritePrompt, ofHideReadOnly, ofNoChangeDir, ofShowHelp, ofPathMustExist, ofEnableSizing]
    Title = 'Indique o local e nome do arquivo de log a ser salvo'
    Left = 814
    Top = 199
  end
  object TimerGetTemporaryData: TTimer
    Enabled = False
    Interval = 7500
    OnTimer = TimerGetTemporaryDataTimer
    Left = 730
    Top = 199
  end
end
