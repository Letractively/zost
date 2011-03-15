inherited BDOForm_JustificativaSalva: TBDOForm_JustificativaSalva
  Caption = 'Justificativa de situa'#231#227'o'
  ClientHeight = 303
  ClientWidth = 459
  ExplicitWidth = 465
  ExplicitHeight = 335
  PixelsPerInch = 96
  TextHeight = 13
  object Label_UsuarioJustificador: TLabel [0]
    Left = 8
    Top = 55
    Width = 443
    Height = 13
    Alignment = taCenter
    AutoSize = False
    Caption = 'Usu'#225'rio justificador'
  end
  object Label_UsuarioJustificadorValor: TLabel [1]
    Left = 8
    Top = 69
    Width = 443
    Height = 13
    Alignment = taCenter
    AutoSize = False
    Caption = '????'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clRed
    Font.Height = -11
    Font.Name = 'Tahoma'
    Font.Style = [fsBold]
    ParentFont = False
  end
  object Label_Justificativa: TLabel [2]
    Left = 8
    Top = 88
    Width = 443
    Height = 13
    Alignment = taCenter
    AutoSize = False
    Caption = 'Justificativa'
  end
  inherited Panel_Header: TPanel
    Width = 459
    TabOrder = 2
    ExplicitWidth = 459
    inherited Shape_BackgroundHeader: TShape
      Width = 459
      ExplicitWidth = 459
    end
    inherited Label_DialogDescription: TLabel
      Width = 413
      Caption = 
        'Esta janela exibe a '#250'ltima justificativa de situa'#231#227'o registrada ' +
        'para o item selecionado. Caso o item selecionado seja uma obra, ' +
        'ser'#225' exibida a justificativa de sua situa'#231#227'o. Caso seja uma prop' +
        'osta ser'#225' exibida a justificativa da situa'#231#227'o da obra que a cont' +
        #233'm'
      ExplicitWidth = 413
    end
    inherited Shape_HeaderLine: TShape
      Width = 451
      ExplicitWidth = 451
    end
    inherited Bevel_Header: TBevel
      Width = 459
      ExplicitWidth = 459
    end
  end
  inherited Panel_Footer: TPanel
    Top = 265
    Width = 459
    ExplicitTop = 265
    ExplicitWidth = 459
    inherited Shape_FooterBackground: TShape
      Width = 459
      ExplicitTop = 265
      ExplicitWidth = 459
    end
    inherited Shape_FooterLine: TShape
      Width = 451
      ExplicitTop = 4
      ExplicitWidth = 451
    end
    inherited Shape_Organizer: TShape
      Width = 451
      ExplicitTop = 9
      ExplicitWidth = 451
    end
    inherited Bevel_Footer: TBevel
      Width = 459
      ExplicitTop = 265
      ExplicitWidth = 459
    end
  end
  object Memo_Justificativa: TMemo [5]
    Left = 8
    Top = 102
    Width = 443
    Height = 157
    Color = clBtnFace
    ReadOnly = True
    ScrollBars = ssVertical
    TabOrder = 0
  end
end
