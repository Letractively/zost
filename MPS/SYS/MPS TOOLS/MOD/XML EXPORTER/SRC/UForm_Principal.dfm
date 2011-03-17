object Form_Principal: TForm_Principal
  Left = 359
  Top = 293
  BorderIcons = [biSystemMenu, biMinimize]
  BorderStyle = bsSingle
  Caption = 'XML Exporter'
  ClientHeight = 320
  ClientWidth = 600
  Color = clBtnFace
  Constraints.MaxHeight = 354
  Constraints.MaxWidth = 608
  Constraints.MinHeight = 348
  Constraints.MinWidth = 606
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  Position = poScreenCenter
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object StatusBar_Principal: TStatusBar
    Left = 0
    Top = 301
    Width = 600
    Height = 19
    Panels = <
      item
        Alignment = taCenter
        Text = 'Registros a processar: 0'
        Width = 165
      end
      item
        Alignment = taCenter
        Text = 'Registros processados: 0'
        Width = 173
      end
      item
        Alignment = taCenter
        Text = 'Threads executando: 0'
        Width = 155
      end
      item
        Alignment = taCenter
        Text = 'Decorrido: 00:00:00'
        Width = 50
      end>
    SizeGrip = False
  end
  object PageControl_Principal: TPageControl
    Left = 0
    Top = 0
    Width = 600
    Height = 301
    ActivePage = TabSheet_Processamento
    Align = alClient
    TabOrder = 1
    object TabSheet_Processamento: TTabSheet
      Caption = 'Processamento'
      object Memo_LogProcessamento: TMemo
        Left = 0
        Top = 0
        Width = 592
        Height = 202
        Align = alClient
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'Courier New'
        Font.Style = []
        ParentFont = False
        ScrollBars = ssVertical
        TabOrder = 0
      end
      object Panel_ControlesProcessamento: TPanel
        Left = 0
        Top = 202
        Width = 592
        Height = 37
        Align = alBottom
        BevelInner = bvLowered
        Color = clInfoBk
        ParentBackground = False
        TabOrder = 1
        object Shape1: TShape
          Left = 2
          Top = 2
          Width = 588
          Height = 33
          Align = alClient
          Brush.Color = clInfoBk
          Pen.Style = psClear
        end
        object Label_Informacao: TLabel
          Left = 12
          Top = 12
          Width = 468
          Height = 13
          Caption = 
            'Este procedimento pode levar cerca de 1 hora em computadores len' +
            'tos. Por favor, seja paciente.'
        end
        object Button_IniciarProcessamento: TButton
          Left = 512
          Top = 6
          Width = 75
          Height = 25
          Caption = 'Iniciar'
          TabOrder = 0
          OnClick = Button_IniciarProcessamentoClick
        end
      end
      object Panel_Records: TPanel
        Left = 0
        Top = 256
        Width = 592
        Height = 17
        Align = alBottom
        BevelOuter = bvNone
        TabOrder = 2
        DesignSize = (
          592
          17)
        object Label_Registros: TLabel
          Left = 0
          Top = 0
          Width = 108
          Height = 17
          Align = alLeft
          Alignment = taRightJustify
          AutoSize = False
          Caption = 'Registros processados'
          Layout = tlCenter
        end
        object Label_RecordsPercent: TLabel
          Left = 563
          Top = 2
          Width = 29
          Height = 13
          Alignment = taCenter
          Anchors = [akTop, akRight]
          AutoSize = False
          Caption = '0%'
        end
        object ProgressBar_Documentos: TProgressBar
          Left = 111
          Top = 0
          Width = 450
          Height = 17
          Anchors = [akLeft, akTop, akRight, akBottom]
          TabOrder = 0
        end
      end
      object Panel_Threads: TPanel
        Left = 0
        Top = 239
        Width = 592
        Height = 17
        Align = alBottom
        BevelOuter = bvNone
        TabOrder = 3
        DesignSize = (
          592
          17)
        object Label_Threads: TLabel
          Left = 0
          Top = 0
          Width = 108
          Height = 17
          Align = alLeft
          Alignment = taRightJustify
          AutoSize = False
          Caption = 'Threads executadas'
          Layout = tlCenter
        end
        object Label_ThreadsPercent: TLabel
          Left = 563
          Top = 2
          Width = 29
          Height = 13
          Alignment = taCenter
          Anchors = [akTop, akRight]
          AutoSize = False
          Caption = '0%'
        end
        object ProgressBar_Threads: TProgressBar
          Left = 111
          Top = 0
          Width = 450
          Height = 17
          Anchors = [akLeft, akRight, akBottom]
          TabOrder = 0
        end
      end
    end
    object TabSheet_Configuracoes: TTabSheet
      Caption = 'Configura'#231#245'es'
      ImageIndex = 1
      object Panel_ControlesConfiguracoes: TPanel
        Left = 0
        Top = 236
        Width = 592
        Height = 37
        Align = alBottom
        BevelInner = bvLowered
        Color = clInfoBk
        TabOrder = 0
        object Shape2: TShape
          Left = 2
          Top = 2
          Width = 588
          Height = 33
          Align = alClient
          Brush.Color = clInfoBk
          Pen.Style = psClear
        end
        object Button_SalvarConfiguracoes: TButton
          Left = 6
          Top = 6
          Width = 75
          Height = 25
          Caption = 'Salvar'
          TabOrder = 0
        end
      end
    end
  end
end
