object Form_Principal: TForm_Principal
  Left = 0
  Top = 0
  Caption = 'CCU Wizard'
  ClientHeight = 456
  ClientWidth = 728
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  PixelsPerInch = 96
  TextHeight = 13
  object PageControl_Principal: TPageControl
    Left = 0
    Top = 0
    Width = 728
    Height = 456
    ActivePage = TabSheet_CCU
    Align = alClient
    TabOrder = 0
    ExplicitWidth = 480
    ExplicitHeight = 247
    object TabSheet_CCU: TTabSheet
      Caption = 'CCU'
      ExplicitWidth = 281
      ExplicitHeight = 165
      object PageControl_CCU: TPageControl
        Left = 0
        Top = 0
        Width = 720
        Height = 391
        ActivePage = TabSheet_Texto
        Align = alClient
        TabOrder = 0
        ExplicitHeight = 387
        object TabSheet_Texto: TTabSheet
          Caption = 'Somente Texto'
          ExplicitWidth = 464
          ExplicitHeight = 191
          object RichEdit_CCU: TRichEdit
            Left = 0
            Top = 0
            Width = 712
            Height = 363
            Align = alClient
            Font.Charset = ANSI_CHARSET
            Font.Color = clWindowText
            Font.Height = -11
            Font.Name = 'Courier New'
            Font.Style = []
            ParentFont = False
            ScrollBars = ssBoth
            TabOrder = 0
          end
        end
        object TabSheet_Grid: TTabSheet
          Caption = 'Wizard'
          ImageIndex = 1
          ExplicitWidth = 464
          ExplicitHeight = 191
        end
      end
      object Panel_Botoes: TPanel
        Left = 0
        Top = 391
        Width = 720
        Height = 37
        Align = alBottom
        BevelOuter = bvNone
        TabOrder = 1
        ExplicitTop = 390
        DesignSize = (
          720
          37)
        object BitBtn_Obter: TBitBtn
          Left = 560
          Top = 6
          Width = 75
          Height = 25
          Anchors = [akRight, akBottom]
          Caption = 'BitBtn_Obter'
          DoubleBuffered = True
          ParentDoubleBuffered = False
          TabOrder = 0
          OnClick = BitBtn_ObterClick
        end
        object BitBtn_Salvar: TBitBtn
          Left = 641
          Top = 6
          Width = 75
          Height = 25
          Anchors = [akRight, akBottom]
          Caption = 'BitBtn_Salvar'
          DoubleBuffered = True
          ParentDoubleBuffered = False
          TabOrder = 1
        end
      end
    end
    object TabSheet_Conexao: TTabSheet
      Caption = 'Op'#231#245'es de Conex'#227'o'
      ImageIndex = 1
      ExplicitWidth = 281
      ExplicitHeight = 165
      object LabeledEdit_Matricula: TLabeledEdit
        Left = 3
        Top = 66
        Width = 121
        Height = 21
        Alignment = taCenter
        EditLabel.Width = 43
        EditLabel.Height = 13
        EditLabel.Caption = 'Matr'#237'cula'
        LabelSpacing = 1
        TabOrder = 0
        Text = '729'
      end
      object LabeledEdit_Senha: TLabeledEdit
        Left = 130
        Top = 66
        Width = 121
        Height = 21
        Alignment = taCenter
        EditLabel.Width = 30
        EditLabel.Height = 13
        EditLabel.Caption = 'Senha'
        LabelSpacing = 1
        PasswordChar = '*'
        TabOrder = 1
        Text = 'MPS'
      end
      object LabeledEdit_Periodo: TLabeledEdit
        Left = 257
        Top = 66
        Width = 121
        Height = 21
        Alignment = taCenter
        EditLabel.Width = 36
        EditLabel.Height = 13
        EditLabel.Caption = 'Per'#237'odo'
        LabelSpacing = 1
        TabOrder = 2
        Text = '11/2010'
      end
      object LabeledEdit_UsuarioIntranet: TLabeledEdit
        Left = 3
        Top = 12
        Width = 121
        Height = 21
        Alignment = taCenter
        EditLabel.Width = 87
        EditLabel.Height = 13
        EditLabel.Caption = 'Usu'#225'rio (Intranet)'
        LabelSpacing = 1
        TabOrder = 3
        Text = 'carlosbarreto'
      end
      object LabeledEdit_SenhaIntranet: TLabeledEdit
        Left = 130
        Top = 12
        Width = 121
        Height = 21
        Alignment = taCenter
        EditLabel.Width = 81
        EditLabel.Height = 13
        EditLabel.Caption = 'Senha (Intranet)'
        LabelSpacing = 1
        TabOrder = 4
        Text = 'mps2010'
      end
    end
  end
end
