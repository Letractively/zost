inherited XXXForm_Login: TXXXForm_Login
  Caption = '???? - Login'
  ClientHeight = 308
  ClientWidth = 357
  Constraints.MaxHeight = 340
  Constraints.MinHeight = 206
  OnShow = FormShow
  ExplicitWidth = 363
  ExplicitHeight = 340
  PixelsPerInch = 96
  TextHeight = 13
  object Label2: TLabel [0]
    Left = 10
    Top = 53
    Width = 338
    Height = 13
    Alignment = taCenter
    Anchors = [akTop]
    AutoSize = False
    Caption = 'Digite seu login completo ou selecione-o na lista abaixo:'
    Color = clBtnFace
    ParentColor = False
    ExplicitLeft = 6
  end
  object Label3: TLabel [1]
    Left = 127
    Top = 195
    Width = 105
    Height = 13
    Anchors = [akTop]
    Caption = 'Nome real do usu'#225'rio:'
    Color = clGreen
    ParentColor = False
    Transparent = True
    ExplicitLeft = 115
  end
  object DBTextNomeDoUsuario: TDBText [2]
    Left = 6
    Top = 209
    Width = 345
    Height = 13
    Alignment = taCenter
    Anchors = [akLeft, akTop, akRight]
    Color = clGreen
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'Tahoma'
    Font.Style = [fsBold]
    ParentColor = False
    ParentFont = False
    Transparent = True
    ExplicitWidth = 322
  end
  object Label4: TLabel [3]
    Left = 6
    Top = 228
    Width = 345
    Height = 13
    Alignment = taCenter
    Anchors = [akLeft, akRight, akBottom]
    AutoSize = False
    Caption = 'Senha:'
    Color = clGreen
    ParentColor = False
    Transparent = True
    ExplicitWidth = 338
  end
  inherited Panel_Header: TPanel
    Width = 357
    ExplicitWidth = 357
    inherited Shape_BackgroundHeader: TShape
      Width = 357
      ExplicitWidth = 400
    end
    inherited Label_DialogDescription: TLabel
      Width = 311
      Caption = 
        'Toda tentativa de login '#233' salva para posterior an'#225'lise caso seja' +
        ' necess'#225'rio. Ao errar o login 3 vezes a aplica'#231#227'o se fechar'#225' e u' +
        'm log adicional ser'#225' criado'
      ExplicitWidth = 311
    end
    inherited Shape_HeaderLine: TShape
      Width = 349
      ExplicitWidth = 349
    end
    inherited Bevel_Header: TBevel
      Width = 357
      ExplicitWidth = 357
    end
  end
  object DBGridUsuarios: TCFDBGrid [5]
    Left = 6
    Top = 94
    Width = 345
    Height = 95
    Anchors = [akLeft, akTop, akRight, akBottom]
    Options = [dgEditing, dgTitles, dgColLines, dgRowLines, dgTabs, dgConfirmDelete, dgCancelOnExit]
    OptionsEx = [dgAutomaticColumSizes]
    ReadOnly = True
    TabOrder = 3
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
    OnEnter = DBGridUsuariosEnter
  end
  object EditSenha: TCFEdit [6]
    Left = 6
    Top = 242
    Width = 345
    Height = 21
    Anchors = [akLeft, akRight, akBottom]
    AutoSize = False
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'Tahoma'
    Font.Style = [fsBold]
    ParentFont = False
    PasswordChar = #248
    TabOrder = 4
    Alignment = taCenter
  end
  object EditLogin: TCFEdit [7]
    Left = 6
    Top = 67
    Width = 345
    Height = 21
    Anchors = [akLeft, akTop, akRight]
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'Tahoma'
    Font.Style = []
    ParentFont = False
    TabOrder = 2
    OnChange = EditLoginChange
    Alignment = taCenter
  end
  inherited Panel_Footer: TPanel
    Top = 270
    Width = 357
    ExplicitTop = 270
    ExplicitWidth = 357
    inherited Shape_FooterBackground: TShape
      Width = 357
      ExplicitWidth = 357
    end
    inherited Shape_FooterLine: TShape
      Width = 349
      ExplicitTop = 4
      ExplicitWidth = 349
    end
    inherited Shape_Organizer: TShape
      Width = 349
      ExplicitTop = 9
      ExplicitWidth = 349
    end
    inherited Bevel_Footer: TBevel
      Width = 357
      ExplicitWidth = 357
    end
    object BitBtn_Cancel: TBitBtn
      Left = 197
      Top = 9
      Width = 75
      Height = 25
      Anchors = [akRight, akBottom]
      Caption = 'Cancelar'
      TabOrder = 0
      Kind = bkCancel
      Spacing = 6
    end
    object BitBtn_Ok: TBitBtn
      Left = 278
      Top = 9
      Width = 75
      Height = 25
      Anchors = [akRight, akBottom]
      Caption = 'OK'
      Default = True
      TabOrder = 1
      OnClick = BitBtn_OkClick
      Glyph.Data = {
        DE010000424DDE01000000000000760000002800000024000000120000000100
        0400000000006801000000000000000000001000000000000000000000000000
        80000080000000808000800000008000800080800000C0C0C000808080000000
        FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFFFF00333333333333
        3333333333333333333333330000333333333333333333333333F33333333333
        00003333344333333333333333388F3333333333000033334224333333333333
        338338F3333333330000333422224333333333333833338F3333333300003342
        222224333333333383333338F3333333000034222A22224333333338F338F333
        8F33333300003222A3A2224333333338F3838F338F33333300003A2A333A2224
        33333338F83338F338F33333000033A33333A222433333338333338F338F3333
        0000333333333A222433333333333338F338F33300003333333333A222433333
        333333338F338F33000033333333333A222433333333333338F338F300003333
        33333333A222433333333333338F338F00003333333333333A22433333333333
        3338F38F000033333333333333A223333333333333338F830000333333333333
        333A333333333333333338330000333333333333333333333333333333333333
        0000}
      NumGlyphs = 2
    end
  end
end
