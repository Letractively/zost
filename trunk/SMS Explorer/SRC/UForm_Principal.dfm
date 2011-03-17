object Form_Principal: TForm_Principal
  Left = 0
  Top = 0
  Caption = 'SMS Explorer'
  ClientHeight = 454
  ClientWidth = 715
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  Position = poScreenCenter
  OnClose = FormClose
  OnCloseQuery = FormCloseQuery
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 13
  object PageControl_Principal: TPageControl
    Left = 0
    Top = 0
    Width = 715
    Height = 454
    ActivePage = TabSheet_Recebimento
    Align = alClient
    TabOrder = 0
    object TabSheet_Recebimento: TTabSheet
      Caption = 'Recebimento'
      object Panel_Recebimento: TPanel
        Left = 0
        Top = 303
        Width = 707
        Height = 123
        Align = alBottom
        BevelOuter = bvNone
        Color = clInfoBk
        ParentBackground = False
        TabOrder = 0
        DesignSize = (
          707
          123)
        object Label7: TLabel
          Left = 6
          Top = 79
          Width = 695
          Height = 39
          Anchors = [akLeft, akTop, akRight]
          AutoSize = False
          Caption = 
            'OBS.: Ao ativar o recebimento, o arquivo de imagem ser'#225' recriado' +
            '. Tamb'#233'm '#233' verificada a presen'#231'a de mensagens que correspondem '#224 +
            's op'#231#245'es de processamento dentro da '#225'rea de armazenagem. Caso ha' +
            'ja mensagens, estas ser'#227'o processadas normalmente, isto '#233', salva' +
            's no arquivo de imagem, salvas no banco e, caso o salvamento ten' +
            'ha sido bem sucedido, as mensagens ser'#227'o exclu'#237'das da '#225'rea de ar' +
            'mazenagem'
          WordWrap = True
          ExplicitWidth = 587
        end
        object Label8: TLabel
          Left = 6
          Top = 50
          Width = 695
          Height = 19
          Alignment = taCenter
          Anchors = [akLeft, akTop, akRight]
          AutoSize = False
          Caption = 'At'#233' agora 0 mensagens foram processadas...'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -16
          Font.Name = 'Tahoma'
          Font.Style = [fsBold]
          ParentFont = False
          ExplicitWidth = 587
        end
        object ComLed1: TComLed
          Left = 685
          Top = 11
          Width = 16
          Height = 16
          ComPort = DataModule_Principal.ComPort_Modem
          LedSignal = lsConn
          Kind = lkGreenLight
          Anchors = [akTop, akRight]
          ExplicitLeft = 577
        end
        object Bevel1: TBevel
          Left = 6
          Top = 66
          Width = 695
          Height = 13
          Anchors = [akLeft, akTop, akRight]
          Shape = bsBottomLine
          ExplicitWidth = 587
        end
        object Bevel2: TBevel
          Left = 6
          Top = 40
          Width = 695
          Height = 13
          Anchors = [akLeft, akTop, akRight]
          Shape = bsTopLine
          ExplicitWidth = 587
        end
        object Button_AtivaDesativaRecebimento: TButton
          Left = 607
          Top = 6
          Width = 75
          Height = 25
          Anchors = [akTop, akRight]
          Caption = 'Ativar'
          TabOrder = 0
          OnClick = Button_AtivaDesativaRecebimentoClick
        end
        object GroupBox_Recebimento: TGroupBox
          Left = 6
          Top = 1
          Width = 283
          Height = 33
          Caption = ' Op'#231#245'es de processamento '
          TabOrder = 1
          object RadioButton_Lidas: TRadioButton
            Left = 7
            Top = 13
            Width = 93
            Height = 13
            Caption = 'Mensagens lidas'
            TabOrder = 0
          end
          object RadioButton_NaoLidas: TRadioButton
            Left = 106
            Top = 13
            Width = 115
            Height = 13
            Caption = 'Mensagens n'#227'o lidas'
            Checked = True
            TabOrder = 1
            TabStop = True
          end
          object RadioButton_Ambas: TRadioButton
            Left = 227
            Top = 13
            Width = 50
            Height = 13
            Caption = 'Ambas'
            TabOrder = 2
          end
        end
      end
      object ListView_Recebimento: TListView
        Left = 0
        Top = 0
        Width = 707
        Height = 303
        Align = alClient
        Columns = <
          item
            Caption = #205'ndice original'
            Width = -2
            WidthType = (
              -2)
          end
          item
            Alignment = taCenter
            Caption = 'N'#250'mero de origem'
            Width = 100
          end
          item
            Alignment = taCenter
            Caption = 'Data de recebimento'
            Width = 120
          end
          item
            Caption = 'Mensagem'
            Width = 385
          end>
        ReadOnly = True
        RowSelect = True
        TabOrder = 1
        ViewStyle = vsReport
        OnAdvancedCustomDrawItem = ListView_RecebimentoAdvancedCustomDrawItem
        OnChange = ListView_RecebimentoChange
      end
    end
    object TabSheet_Envio: TTabSheet
      Caption = 'Envio'
      ImageIndex = 1
      ExplicitLeft = 0
      ExplicitTop = 0
      ExplicitWidth = 0
      ExplicitHeight = 0
    end
    object TabSheet_Terminal: TTabSheet
      Caption = 'Terminal (avan'#231'ado)'
      ImageIndex = 3
      ExplicitLeft = 0
      ExplicitTop = 0
      ExplicitWidth = 0
      ExplicitHeight = 0
      object ComTerminal_Modem: TComTerminal
        Left = 0
        Top = 0
        Width = 707
        Height = 426
        Align = alClient
        Color = clBlack
        Columns = 160
        ComPort = DataModule_Principal.ComPort_Modem
        Emulation = teVT100orANSI
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWhite
        Font.Height = -12
        Font.Name = 'Fixedsys'
        Font.Style = []
        Rows = 100
        ScrollBars = ssBoth
        TabOrder = 0
      end
    end
    object TabSheet_Configuracoes: TTabSheet
      Caption = 'Configura'#231#245'es'
      ImageIndex = 2
      DesignSize = (
        707
        426)
      object GroupBox_ConfigGeral: TGroupBox
        Left = 0
        Top = 0
        Width = 145
        Height = 99
        Align = alCustom
        Caption = ' Geral '
        TabOrder = 0
        object Label1: TLabel
          Left = 6
          Top = 13
          Width = 85
          Height = 13
          Caption = 'Interv. de verific.'
        end
        object Label2: TLabel
          Left = 94
          Top = 30
          Width = 46
          Height = 13
          Caption = 'segundos'
        end
        object Label3: TLabel
          Left = 6
          Top = 55
          Width = 52
          Height = 13
          Caption = 'Porta COM'
        end
        object SpinEdit_TempoAtualizacao: TSpinEdit
          Left = 6
          Top = 27
          Width = 85
          Height = 22
          MaxValue = 60
          MinValue = 1
          TabOrder = 0
          Value = 1
        end
        object SpinEdit_PortaCom: TSpinEdit
          Left = 6
          Top = 69
          Width = 85
          Height = 22
          MaxValue = 255
          MinValue = 1
          TabOrder = 1
          Value = 4
        end
      end
      object GroupBox_ArquivoImagem: TGroupBox
        Left = 151
        Top = 0
        Width = 553
        Height = 99
        Anchors = [akLeft, akTop, akRight]
        Caption = ' Arquivo de imagem '
        TabOrder = 1
        DesignSize = (
          553
          99)
        object Label4: TLabel
          Left = 6
          Top = 13
          Width = 540
          Height = 39
          Alignment = taCenter
          Anchors = [akLeft, akTop, akRight]
          AutoSize = False
          Caption = 
            'Nome de um arquivo CSV que ser'#225' preenchido com com as mensagens ' +
            'que chegam. Este arquivo '#233' recriado toda vez que o recebimento '#233 +
            ' (re)inicializado (primeira aba). O formato CSV '#233' bastante port'#225 +
            'vel e pode ser aberto em um editor de planilhas qualquer'
          WordWrap = True
          ExplicitWidth = 276
        end
        object Label5: TLabel
          Left = 6
          Top = 80
          Width = 239
          Height = 13
          Caption = 'Obs.: Pode ser especificado um caminho completo'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'Tahoma'
          Font.Style = []
          ParentFont = False
        end
        object Edit_ArquivoImagem: TEdit
          Left = 6
          Top = 58
          Width = 540
          Height = 21
          Anchors = [akLeft, akTop, akRight]
          TabOrder = 0
          Text = 'SMSEXPLORER.CSV'
        end
      end
      object GroupBox_ComandosAT: TGroupBox
        Left = 0
        Top = 99
        Width = 704
        Height = 110
        Anchors = [akLeft, akTop, akRight]
        Caption = ' Comandos AT '
        TabOrder = 2
        DesignSize = (
          704
          110)
        object Label6: TLabel
          Left = 6
          Top = 91
          Width = 330
          Height = 13
          Caption = '<:IXMS:> = '#205'ndice da mensagem dentro da '#225'rea de armazenamento'
        end
        object LabeledEdit_Ressetar: TLabeledEdit
          Left = 6
          Top = 27
          Width = 75
          Height = 21
          Alignment = taCenter
          EditLabel.Width = 75
          EditLabel.Height = 13
          EditLabel.Caption = 'Reconfigura'#231#227'o'
          LabelSpacing = 1
          TabOrder = 0
          Text = 'ATZ'
        end
        object LabeledEdit_ModoTexto: TLabeledEdit
          Left = 87
          Top = 27
          Width = 109
          Height = 21
          Alignment = taCenter
          EditLabel.Width = 109
          EditLabel.Height = 13
          EditLabel.Caption = 'Formato de mensagem'
          LabelSpacing = 1
          TabOrder = 1
          Text = 'AT+CMGF=1'
        end
        object LabeledEdit_TodasAsMensagens: TLabeledEdit
          Left = 202
          Top = 27
          Width = 120
          Height = 21
          Alignment = taCenter
          EditLabel.Width = 121
          EditLabel.Height = 13
          EditLabel.Caption = 'Listar mensagens (todas)'
          LabelSpacing = 1
          TabOrder = 2
          Text = 'AT+CMGL="ALL"'
        end
        object LabeledEdit_AreaArmazenamento: TLabeledEdit
          Left = 367
          Top = 69
          Width = 156
          Height = 21
          Alignment = taCenter
          EditLabel.Width = 138
          EditLabel.Height = 13
          EditLabel.Caption = 'Armazenamento preferencial'
          LabelSpacing = 1
          TabOrder = 3
          Text = 'AT+CPMS="ME","ME","ME"'
        end
        object LabeledEdit_ExcluirMensagem: TLabeledEdit
          Left = 529
          Top = 69
          Width = 168
          Height = 21
          Alignment = taCenter
          Anchors = [akTop, akRight]
          EditLabel.Width = 85
          EditLabel.Height = 13
          EditLabel.Caption = 'Excluir mensagem'
          LabelSpacing = 1
          TabOrder = 4
          Text = 'AT+CMGD=<:IXMS:>'
        end
        object LabeledEdit_Lidas: TLabeledEdit
          Left = 328
          Top = 27
          Width = 182
          Height = 21
          Alignment = taCenter
          EditLabel.Width = 143
          EditLabel.Height = 13
          EditLabel.BiDiMode = bdLeftToRight
          EditLabel.Caption = 'Listar mensagens (s'#243' as lidas)'
          EditLabel.ParentBiDiMode = False
          LabelSpacing = 1
          TabOrder = 5
          Text = 'AT+CMGL="REC READ"'
        end
        object LabeledEdit_NaoLidas: TLabeledEdit
          Left = 516
          Top = 27
          Width = 181
          Height = 21
          Alignment = taCenter
          EditLabel.Width = 164
          EditLabel.Height = 13
          EditLabel.BiDiMode = bdLeftToRight
          EditLabel.Caption = 'Listar mensagens (s'#243' as n'#227'o lidas)'
          EditLabel.ParentBiDiMode = False
          LabelSpacing = 1
          TabOrder = 6
          Text = 'AT+CMGL="REC UNREAD"'
        end
        object LabeledEdit_NaoEnviadas: TLabeledEdit
          Left = 176
          Top = 69
          Width = 185
          Height = 21
          Alignment = taCenter
          EditLabel.Width = 186
          EditLabel.Height = 13
          EditLabel.BiDiMode = bdLeftToRight
          EditLabel.Caption = 'Listar mensagens (s'#243' as n'#227'o enviadas)'
          EditLabel.ParentBiDiMode = False
          LabelSpacing = 1
          TabOrder = 7
          Text = 'AT+CMGL="STO UNSENT"'
        end
        object LabeledEdit_Enviadas: TLabeledEdit
          Left = 6
          Top = 69
          Width = 164
          Height = 21
          Alignment = taCenter
          EditLabel.Width = 165
          EditLabel.Height = 13
          EditLabel.BiDiMode = bdLeftToRight
          EditLabel.Caption = 'Listar mensagens (s'#243' as enviadas)'
          EditLabel.ParentBiDiMode = False
          LabelSpacing = 1
          TabOrder = 8
          Text = 'AT+CMGL="STO SENT"'
        end
      end
      object GroupBox_DatabaseConfiguration: TGroupBox
        Left = 0
        Top = 212
        Width = 704
        Height = 57
        Anchors = [akLeft, akTop, akRight]
        Caption = ' Configura'#231#245'es de banco de dados '
        TabOrder = 3
        DesignSize = (
          704
          57)
        object Label9: TLabel
          Left = 6
          Top = 13
          Width = 45
          Height = 13
          Caption = 'Protocolo'
        end
        object LabeledEdit_Host: TLabeledEdit
          Left = 97
          Top = 27
          Width = 229
          Height = 21
          Anchors = [akLeft, akTop, akRight]
          EditLabel.Width = 94
          EditLabel.Height = 13
          EditLabel.Caption = 'Nome do host ou IP'
          LabelSpacing = 1
          TabOrder = 0
          Text = '127.0.0.1'
        end
        object LabeledEdit_Usuario: TLabeledEdit
          Left = 372
          Top = 27
          Width = 103
          Height = 21
          Anchors = [akTop, akRight]
          EditLabel.Width = 36
          EditLabel.Height = 13
          EditLabel.Caption = 'Usu'#225'rio'
          LabelSpacing = 1
          TabOrder = 1
          Text = 'root'
        end
        object LabeledEdit_Esquema: TLabeledEdit
          Left = 590
          Top = 27
          Width = 107
          Height = 21
          Anchors = [akTop, akRight]
          EditLabel.Width = 43
          EditLabel.Height = 13
          EditLabel.Caption = 'Esquema'
          LabelSpacing = 1
          TabOrder = 2
          Text = 'SMSEXPLORER'
        end
        object LabeledEdit_Senha: TLabeledEdit
          Left = 481
          Top = 27
          Width = 103
          Height = 21
          Anchors = [akTop, akRight]
          EditLabel.Width = 30
          EditLabel.Height = 13
          EditLabel.Caption = 'Senha'
          LabelSpacing = 1
          PasswordChar = '*'
          TabOrder = 3
          Text = '123456'
        end
        object LabeledEdit_Porta: TLabeledEdit
          Left = 332
          Top = 27
          Width = 34
          Height = 21
          Anchors = [akTop, akRight]
          EditLabel.Width = 26
          EditLabel.Height = 13
          EditLabel.Caption = 'Porta'
          LabelSpacing = 1
          TabOrder = 4
          Text = '3306'
        end
        object ComboBox_Protocolo: TComboBox
          Left = 6
          Top = 27
          Width = 85
          Height = 21
          Style = csDropDownList
          ItemHeight = 13
          TabOrder = 5
        end
      end
      object GroupBox_ComandosSQL: TGroupBox
        Left = 0
        Top = 272
        Width = 704
        Height = 110
        Anchors = [akLeft, akTop, akRight, akBottom]
        Caption = ' Comandos SQL '
        TabOrder = 4
        DesignSize = (
          704
          110)
        object Label10: TLabel
          Left = 6
          Top = 91
          Width = 665
          Height = 13
          Caption = 
            '<:RCDT:> = Data/Hora do recebimento; <:SDNU:> = N'#250'mero do remete' +
            'nte; <:MECO:> = Mensagem; <:FXPn:> = Par'#226'metro fixo [0~9]'
        end
        object LabeledEdit_SQLInsert: TLabeledEdit
          Left = 6
          Top = 27
          Width = 691
          Height = 21
          Anchors = [akLeft, akTop, akRight]
          EditLabel.Width = 103
          EditLabel.Height = 13
          EditLabel.Caption = 'Comando de inser'#231#227'o'
          LabelSpacing = 1
          TabOrder = 0
          Text = 
            'INSERT INTO TBNAREME (RCDT, SDNU, MECO) VALUES (<:RCDT:>,<:SDNU:' +
            '>,<:MECO:>)'
        end
        object LabeledEdit_ParametrosFixos: TLabeledEdit
          Left = 6
          Top = 69
          Width = 384
          Height = 21
          EditLabel.Width = 199
          EditLabel.Height = 13
          EditLabel.Caption = 'Par'#226'metros fixos (0~9 separados por ";")'
          LabelSpacing = 1
          TabOrder = 1
          Text = #39'texto'#39';1;'#39'13/12/1978'#39';1.9'
        end
        object LabeledEdit_FormatoData: TLabeledEdit
          Left = 396
          Top = 69
          Width = 79
          Height = 21
          Alignment = taCenter
          EditLabel.Width = 80
          EditLabel.Height = 13
          EditLabel.Caption = 'Formato de data'
          LabelSpacing = 1
          TabOrder = 2
          Text = 'YYYY-MM-DD'
        end
        object LabeledEdit_FormatoTempo: TLabeledEdit
          Left = 481
          Top = 69
          Width = 87
          Height = 21
          Alignment = taCenter
          EditLabel.Width = 88
          EditLabel.Height = 13
          EditLabel.Caption = 'Formato de tempo'
          LabelSpacing = 1
          TabOrder = 3
          Text = 'HH:NN:SS'
        end
        object LabeledEdit_FormatoDataTempo: TLabeledEdit
          Left = 574
          Top = 69
          Width = 123
          Height = 21
          Alignment = taCenter
          EditLabel.Width = 124
          EditLabel.Height = 13
          EditLabel.Caption = 'Formato de data + tempo'
          LabelSpacing = 1
          TabOrder = 4
          Text = 'YYYY-MM-DD HH:NN:SS'
        end
      end
      object Panel_Configuracoes: TPanel
        Left = 0
        Top = 388
        Width = 707
        Height = 38
        Align = alBottom
        BevelOuter = bvNone
        Color = clInfoBk
        ParentBackground = False
        TabOrder = 5
        DesignSize = (
          707
          38)
        object Label11: TLabel
          Left = 128
          Top = 6
          Width = 569
          Height = 26
          Anchors = [akLeft, akTop, akRight]
          AutoSize = False
          Caption = 
            'Para que as op'#231#245'es entrem em vigor imediatamente, '#233' necess'#225'rio c' +
            'licar o bot'#227'o ao lado. '#13#10'As configura'#231#245'es tamb'#233'm s'#227'o salvas auto' +
            'maticamente quando a aplica'#231#227'o '#233' finalizada.'
          WordWrap = True
          ExplicitWidth = 461
        end
        object Button_SalvarConfiguracoes: TButton
          Left = 6
          Top = 6
          Width = 116
          Height = 26
          Caption = 'Salvar configura'#231#245'es'
          TabOrder = 0
          OnClick = Button_SalvarConfiguracoesClick
        end
      end
    end
    object TabSheet_AjudaSobre: TTabSheet
      Caption = 'Ajuda / Sobre'
      ImageIndex = 4
      object Memo1: TMemo
        Left = 0
        Top = 0
        Width = 707
        Height = 426
        Align = alClient
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'Courier New'
        Font.Style = []
        Lines.Strings = (
          'Considera'#231#245'es importantes'
          '-------------------------'
          ''
          
            '1. Ao desativar o monitoramento, '#233' obrigat'#243'ria a reinicializa'#231#227'o' +
            ' do modem. Desligue-o, aguarde 5 '
          
            'segundos, ligue-o novamente e depois aguarde 1 (um) minuto antes' +
            ' de iniciar o monitoramento '
          
            'novamente. Ao clicar o bot'#227'o de desativar monitoramento (aba Rec' +
            'ebimento) uma mensagem informando '
          'isso vai aparecer. '
          ''
          
            '2. Caso desconfie que de que algo est'#225' errado, v'#225' at'#233' a aba "Ter' +
            'minal", role at'#233' ver a '#250'ltima linha '
          
            'de texto e verifique se h'#225' atividade. Caso voc'#234' desconfie de que' +
            ' n'#227'o h'#225' atividade, desative o '
          
            'monitoramento, desligue o modem, aguarde 5 segundos, ligue o mod' +
            'em novamente e depois aguarde 1 (um) '
          'minuto antes de iniciar o monitoramento outra vez.')
        ParentFont = False
        ReadOnly = True
        TabOrder = 0
      end
    end
  end
end
