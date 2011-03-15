object FSSForm_Main: TFSSForm_Main
  Left = 0
  Top = 0
  BorderIcons = [biSystemMenu, biMinimize]
  BorderStyle = bsSingle
  Caption = 'FTP Synchronizer - Edi'#231#227'o exclusiva para ????'
  ClientHeight = 448
  ClientWidth = 843
  Color = clBtnFace
  Constraints.MaxHeight = 480
  Constraints.MaxWidth = 849
  Constraints.MinHeight = 474
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
  PixelsPerInch = 96
  TextHeight = 13
  object ActionMainMenuBar1: TActionMainMenuBar
    Left = 0
    Top = 0
    Width = 843
    Height = 25
    UseSystemFont = False
    ActionManager = ActionManager
    Caption = 'ActionMainMenuBar1'
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
  object StatusBar1: TStatusBar
    Left = 0
    Top = 429
    Width = 843
    Height = 19
    AutoHint = True
    Panels = <>
    SizeGrip = False
  end
  object Panel1: TPanel
    Left = 0
    Top = 397
    Width = 843
    Height = 32
    Align = alBottom
    TabOrder = 2
    DesignSize = (
      843
      32)
    object GreenImage: TImage
      Left = 9
      Top = 9
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
    object RedImage: TImage
      Left = 9
      Top = 9
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
    object ClientCountLabel: TLabel
      Left = 24
      Top = 10
      Width = 75
      Height = 13
      Caption = 'Servidor inativo'
    end
    object Button1: TButton
      Left = 739
      Top = 3
      Width = 101
      Height = 25
      Anchors = [akTop, akRight]
      Caption = 'Salvar e limpar log'
      TabOrder = 0
      OnClick = Button1Click
    end
    object Button2: TButton
      Left = 639
      Top = 3
      Width = 99
      Height = 25
      Anchors = [akTop, akRight]
      Caption = 'Salvar log como...'
      TabOrder = 1
      OnClick = Button2Click
    end
  end
  object RichEditLog: TRichEdit
    Left = 0
    Top = 48
    Width = 843
    Height = 349
    Align = alClient
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'Courier New'
    Font.Style = []
    ParentFont = False
    ReadOnly = True
    ScrollBars = ssVertical
    TabOrder = 3
    WordWrap = False
  end
  object ActionToolBar1: TActionToolBar
    Left = 0
    Top = 25
    Width = 843
    Height = 23
    ActionManager = ActionManager
    Caption = 'ActionToolBar1'
    ColorMap.HighlightColor = 15660791
    ColorMap.BtnSelectedColor = clBtnFace
    ColorMap.UnusedColor = 15660791
    Spacing = 0
  end
  object ActionManager: TActionManager
    ActionBars = <
      item
        Items = <
          item
            Items = <
              item
                Action = ActionLigarServidor
                Caption = '&Ativar'
              end
              item
                Action = ActionDesligarServidor
                Caption = '&Desativar'
              end>
            Caption = '&Servidor'
          end
          item
            Items = <
              item
                Action = ActionConfiguracoes
              end>
            Caption = '&Configura'#231#245'es'
          end
          item
            Items = <
              item
                Action = ActionSobre
              end>
            Caption = '&Ajuda'
          end>
        ActionBar = ActionMainMenuBar1
      end
      item
        Items = <
          item
            Action = ActionLigarServidor
            Caption = '&Ativar'
          end
          item
            Action = ActionDesligarServidor
            Caption = '&Desativar'
          end>
        ActionBar = ActionToolBar1
      end>
    Left = 583
    Top = 29
    StyleName = 'XP Style'
    object ActionLigarServidor: TAction
      Category = 'Servidor'
      Caption = 'Ativar'
      Hint = 'Ativa o servidor'
      OnExecute = ActionLigarServidorExecute
    end
    object ActionDesligarServidor: TAction
      Category = 'Servidor'
      Caption = 'Desativar'
      Enabled = False
      Hint = 'Desativa o servidor'
      OnExecute = ActionDesligarServidorExecute
    end
    object ActionSobre: TAction
      Category = 'Ajuda'
      Caption = 'Sobre o FTP Syncronizer...'
      OnExecute = ActionSobreExecute
    end
    object ActionConfiguracoes: TAction
      Category = 'Configura'#231#245'es'
      Caption = 'Configura'#231#245'es gerais...'
      OnExecute = ActionConfiguracoesExecute
    end
  end
  object FTPServer: TFtpServer
    Addr = '0.0.0.0'
    Port = 'ftp'
    Banner = '220 - FTP Syncronizer'
    UserData = 0
    MaxClients = 2
    PasvPortRangeStart = 0
    PasvPortRangeSize = 0
    Options = []
    OnStart = DoStart
    OnStop = DoStop
    OnAuthenticate = DoAuthenticate
    OnClientDisconnect = DoClientDisconnect
    OnClientConnect = DoClientConnect
    OnClientCommand = DoClientCommand
    OnAnswerToClient = DoAnswerToClient
    OnChangeDirectory = DoChangeDirectory
    OnMakeDirectory = DoMakeDirectory
    OnStorSessionConnected = DoStorSessionConnected
    OnRetrSessionConnected = DoRetrSessionConnected
    OnStorSessionClosed = DoStorSessionClosed
    OnRetrSessionClosed = DoRetrSessionClosed
    OnRetrDataSent = DoRetrDataSent
    OnValidatePut = DoValidatePut
    OnValidateSize = DoValidateSize
    OnValidateDele = DoValidateDele
    OnValidateRmd = DoValidateRmd
    OnValidateRnFr = DoValidateRnFr
    OnValidateRnTo = DoValidateRnTo
    OnValidateGet = DoValidateGet
    OnGetProcessing = DoGetProcessing
    OnCalculateMd5 = DoCalculateMd5
    Left = 611
    Top = 29
  end
  object SaveDialog1: TSaveDialog
    DefaultExt = 'rtf'
    Filter = 'Rich Text Format (*.rtf)|*.rtf'
    Options = [ofHideReadOnly]
    Title = 'Selecione o local e nome do arquivo de log a ser salvo'
    Left = 639
    Top = 29
  end
  object Timer1: TTimer
    Enabled = False
    OnTimer = Timer1Timer
    Left = 667
    Top = 29
  end
end
