inherited BDOForm_EmailsAutomaticos: TBDOForm_EmailsAutomaticos
  Caption = 'Defini'#231#245'es de e-mails autom'#225'ticos'
  ClientHeight = 359
  ClientWidth = 532
  ExplicitWidth = 538
  ExplicitHeight = 391
  PixelsPerInch = 96
  TextHeight = 13
  inherited Panel_Header: TPanel
    Width = 532
    TabOrder = 2
    ExplicitWidth = 532
    inherited Shape_BackgroundHeader: TShape
      Width = 532
      ExplicitWidth = 314
    end
    inherited Label_DialogDescription: TLabel
      Width = 486
      Caption = 
        'Nesta tela '#233' poss'#237'vel configurar o envio de e-mails autom'#225'ticos ' +
        'para v'#225'rios eventos ocorridos no sistema. Emails autom'#225'ticos s'#227'o' +
        ' enviados apenas enquanto o BDO estiver sendo executado. Nesta t' +
        'ela tamb'#233'm '#233' poss'#237'vel definir recipientes adicionais para os qua' +
        'is se deve enviar e-mails'
      ExplicitWidth = 268
    end
    inherited Shape_HeaderLine: TShape
      Width = 524
      ExplicitWidth = 306
    end
    inherited Bevel_Header: TBevel
      Width = 532
      ExplicitWidth = 314
    end
  end
  inherited Panel_Footer: TPanel
    Top = 321
    Width = 532
    ExplicitTop = 321
    ExplicitWidth = 532
    inherited Shape_FooterBackground: TShape
      Width = 532
      ExplicitTop = 170
      ExplicitWidth = 314
    end
    inherited Bevel_Footer: TBevel [1]
      Width = 532
      ExplicitTop = 170
      ExplicitWidth = 314
    end
    inherited Shape_FooterLine: TShape [2]
      Width = 524
      ExplicitTop = 4
      ExplicitWidth = 499
    end
    inherited Shape_Organizer: TShape [3]
      Width = 524
      ExplicitTop = 9
      ExplicitWidth = 499
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
    ActivePage = TabSheet_EmailsAutomaticos
    Align = alClient
    TabOrder = 0
    object TabSheet_EmailsAutomaticos: TTabSheet
      Caption = 'Emails autom'#225'ticos'
      ImageIndex = 1
      DesignSize = (
        512
        232)
      object Label_UsuarioPrincipal: TLabel
        Left = 6
        Top = 3
        Width = 500
        Height = 39
        Alignment = taCenter
        AutoSize = False
        Caption = 
          'Informe o usu'#225'rio principal deste sistema. Todos os e-mails gera' +
          'dos por eventos neste sistema ser'#227'o enviados para este usu'#225'rio p' +
          'rimariamente. Outros recipientes poder'#227'o ser informados dentro d' +
          'e cada uma das p'#225'ginas abaixo'
        WordWrap = True
      end
      object Bevel_Linha1: TBevel
        Left = 6
        Top = 48
        Width = 500
        Height = 2
        Shape = bsTopLine
      end
      object PageControl_EmailsAutomaticos: TPageControl
        AlignWithMargins = True
        Left = 6
        Top = 104
        Width = 500
        Height = 122
        Margins.Left = 6
        Margins.Top = 0
        Margins.Right = 6
        Margins.Bottom = 6
        ActivePage = TabSheet_ObrasOciosas
        Align = alBottom
        TabOrder = 0
        object TabSheet_ObrasOciosas: TTabSheet
          Caption = 'Obras ociosas'
        end
        object TabSheet_ObrasGanhas: TTabSheet
          Caption = 'Obras ganhas'
          ImageIndex = 1
          ExplicitLeft = 0
          ExplicitTop = 0
          ExplicitWidth = 0
          ExplicitHeight = 0
        end
        object TabSheet_ObrasPerdidas: TTabSheet
          Caption = 'Obras perdidas'
          ImageIndex = 2
          ExplicitLeft = 0
          ExplicitTop = 0
          ExplicitWidth = 0
          ExplicitHeight = 0
        end
        object TabSheet_ObrasExpirando: TTabSheet
          Caption = 'Obras com data de previs'#227'o de conclus'#227'o pr'#243'xima'
          ImageIndex = 3
          ExplicitLeft = 0
          ExplicitTop = 0
          ExplicitWidth = 0
          ExplicitHeight = 0
        end
      end
      object ComboBox_UsuarioPrincipal: TComboBox
        Left = 6
        Top = 56
        Width = 500
        Height = 21
        Style = csDropDownList
        Anchors = [akLeft, akTop, akRight]
        ItemHeight = 13
        TabOrder = 1
        OnClick = ComboBox_UsuarioPrincipalClick
      end
      object Panel_EmailPrincipal: TPanel
        Left = 6
        Top = 80
        Width = 500
        Height = 20
        Anchors = [akLeft, akTop, akRight]
        BevelInner = bvLowered
        Caption = 'Panel_EmailPrincipal'
        TabOrder = 2
      end
    end
    object TabSheet_InformacoesAdicionais: TTabSheet
      Caption = 'TabSheet_InformacoesAdicionais'
      ImageIndex = 2
    end
    object TabSheet_ConfiguracoesSMTP: TTabSheet
      Caption = 'Configura'#231#245'es SMTP'
      object Label_ConfiguracoesSMTP: TLabel
        Left = 6
        Top = 3
        Width = 500
        Height = 39
        Alignment = taCenter
        AutoSize = False
        Caption = 
          'Estas configura'#231#245'es afetam o envio de todos os e-mails configura' +
          'dos na p'#225'gina"E-mails autom'#225'ticos". Outras configura'#231#245'es s'#227'o exi' +
          'bidas aqui apenas a t'#237'tulo de visualiza'#231#227'o e n'#227'o podem ser modif' +
          'icadas nesta tela. Apenas administradores podem alterar tais con' +
          'figura'#231#245'es na tela de configura'#231#245'es gerais.'
        WordWrap = True
      end
      object Bevel_Linha2: TBevel
        Left = 6
        Top = 48
        Width = 500
        Height = 2
        Shape = bsTopLine
      end
      object Label_Priority: TLabel
        Left = 6
        Top = 56
        Width = 48
        Height = 13
        Caption = 'Prioridade'
      end
      object Label_ContentType: TLabel
        Left = 132
        Top = 56
        Width = 83
        Height = 13
        Caption = 'Tipo de conte'#250'do'
      end
      object Label_SendMode: TLabel
        Left = 232
        Top = 56
        Width = 70
        Height = 13
        Caption = 'Modo de envio'
      end
      object Label_ShareMode: TLabel
        Left = 358
        Top = 56
        Width = 129
        Height = 13
        Caption = 'Modo de compartilhamento'
      end
      object ComboBox_Priority: TComboBox
        Left = 6
        Top = 70
        Width = 120
        Height = 21
        Style = csDropDownList
        ItemHeight = 13
        ItemIndex = 1
        TabOrder = 0
        Text = 'smtpPriorityHighest'
        Items.Strings = (
          'smtpPriorityNone'
          'smtpPriorityHighest'
          'smtpPriorityHigh'
          'smtpPriorityNormal'
          'smtpPriorityLow'
          'smtpPriorityLowest')
      end
      object ComboBox_ContentType: TComboBox
        Left = 132
        Top = 70
        Width = 94
        Height = 21
        Style = csDropDownList
        ItemHeight = 13
        ItemIndex = 1
        TabOrder = 1
        Text = 'smtpPlainText'
        Items.Strings = (
          'smtpHtml'
          'smtpPlainText')
      end
      object ComboBox_SendMode: TComboBox
        Left = 232
        Top = 70
        Width = 120
        Height = 21
        Style = csDropDownList
        ItemHeight = 13
        ItemIndex = 2
        TabOrder = 2
        Text = 'smtpCopyToStream'
        Items.Strings = (
          'smtpToSocket'
          'smtpToStream'
          'smtpCopyToStream')
      end
      object CheckBox_Confirm: TCheckBox
        Left = 6
        Top = 97
        Width = 126
        Height = 13
        Caption = 'Confirmar recebimento'
        Enabled = False
        TabOrder = 3
      end
      object CheckBox_WrapMessageText: TCheckBox
        Left = 138
        Top = 97
        Width = 155
        Height = 13
        Caption = 'Quebrar texto da mensagem'
        Enabled = False
        TabOrder = 4
      end
      object ComboBox_ShareMode: TComboBox
        Left = 358
        Top = 70
        Width = 148
        Height = 21
        Style = csDropDownList
        ItemHeight = 13
        ItemIndex = 2
        TabOrder = 5
        Text = 'smtpShareDenyWrite'
        Items.Strings = (
          'smtpShareCompat'
          'smtpShareExclusive'
          'smtpShareDenyWrite'
          'smtpShareDenyRead'
          'smtpShareDenyNone')
      end
    end
  end
end
