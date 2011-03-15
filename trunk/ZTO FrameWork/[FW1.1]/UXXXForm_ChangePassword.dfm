inherited XXXForm_ChangePassword: TXXXForm_ChangePassword
  Caption = 'Alterar senha'
  ClientHeight = 209
  ClientWidth = 359
  OnShow = FormShow
  ExplicitWidth = 365
  ExplicitHeight = 241
  PixelsPerInch = 96
  TextHeight = 13
  object Label1: TLabel [0]
    Left = 6
    Top = 55
    Width = 75
    Height = 13
    Caption = 'Usu'#225'rio logado:'
  end
  object Label_LoggedUser: TLabel [1]
    Left = 84
    Top = 55
    Width = 270
    Height = 13
    Anchors = [akLeft, akTop, akRight]
    AutoSize = False
    Caption = 'Label_LoggedUser'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'Tahoma'
    Font.Style = [fsBold]
    ParentFont = False
    ExplicitWidth = 242
  end
  object Label6: TLabel [2]
    Left = 31
    Top = 69
    Width = 50
    Height = 13
    Alignment = taRightJustify
    AutoSize = False
    Caption = '............:'
  end
  object Label_Login: TLabel [3]
    Left = 84
    Top = 69
    Width = 270
    Height = 13
    Anchors = [akLeft, akTop, akRight]
    AutoSize = False
    Caption = 'Label_Login'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'Tahoma'
    Font.Style = [fsBold]
    ParentFont = False
    ExplicitWidth = 242
  end
  object Bevel1: TBevel [4]
    Left = 6
    Top = 86
    Width = 348
    Height = 11
    Anchors = [akLeft, akTop, akRight]
    Shape = bsTopLine
    ExplicitWidth = 320
  end
  object Label3: TLabel [5]
    Left = 6
    Top = 96
    Width = 57
    Height = 13
    Caption = 'Senha atual'
  end
  object Label7: TLabel [6]
    Left = 64
    Top = 96
    Width = 101
    Height = 13
    Alignment = taRightJustify
    AutoSize = False
    Caption = '.............................:'
  end
  object Label4: TLabel [7]
    Left = 6
    Top = 122
    Width = 57
    Height = 13
    Caption = 'Nova senha'
  end
  object Label8: TLabel [8]
    Left = 65
    Top = 122
    Width = 100
    Height = 13
    Alignment = taRightJustify
    AutoSize = False
    Caption = '.............................:'
  end
  object Label5: TLabel [9]
    Left = 6
    Top = 149
    Width = 106
    Height = 13
    Caption = 'Confirmar nova senha'
  end
  object Label9: TLabel [10]
    Left = 113
    Top = 149
    Width = 52
    Height = 13
    Alignment = taRightJustify
    AutoSize = False
    Caption = '.............................:'
  end
  object Label2: TLabel [11]
    Left = 6
    Top = 69
    Width = 25
    Height = 13
    Caption = 'Login'
  end
  inherited Panel_Header: TPanel
    Width = 359
    TabOrder = 5
    ExplicitWidth = 359
    inherited Shape_BackgroundHeader: TShape
      Width = 359
      ExplicitWidth = 331
    end
    inherited Label_DialogDescription: TLabel
      Width = 313
      Caption = 
        'Digite as informa'#231#245'es requisitadas e pressione o bot'#227'o "Alterar"' +
        ' para alterar sua senha atual pela nova senha'
      ExplicitWidth = 285
    end
    inherited Shape_HeaderLine: TShape
      Width = 351
      ExplicitWidth = 323
    end
    inherited Bevel_Header: TBevel
      Width = 359
      ExplicitWidth = 331
    end
  end
  inherited Panel_Footer: TPanel
    Top = 171
    Width = 359
    TabOrder = 6
    ExplicitTop = 171
    ExplicitWidth = 359
    inherited Shape_FooterBackground: TShape
      Width = 359
      ExplicitTop = 171
      ExplicitWidth = 331
    end
    inherited Shape_FooterLine: TShape
      Width = 351
      ExplicitTop = 4
      ExplicitWidth = 351
    end
    inherited Shape_Organizer: TShape
      Width = 351
      ExplicitTop = 9
      ExplicitWidth = 351
    end
    inherited Bevel_Footer: TBevel
      Width = 359
      ExplicitTop = 171
      ExplicitWidth = 331
    end
  end
  object Edit_CurrentPassword: TEdit [14]
    Left = 171
    Top = 92
    Width = 183
    Height = 21
    Anchors = [akLeft, akTop, akRight]
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'Tahoma'
    Font.Style = [fsBold]
    ParentFont = False
    PasswordChar = #248
    TabOrder = 0
  end
  object Edit_NewPassword: TEdit [15]
    Left = 171
    Top = 118
    Width = 183
    Height = 21
    Anchors = [akLeft, akTop, akRight]
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'Tahoma'
    Font.Style = [fsBold]
    ParentFont = False
    PasswordChar = #248
    TabOrder = 1
  end
  object Edit_ConfirmPassword: TEdit [16]
    Left = 171
    Top = 145
    Width = 183
    Height = 21
    Anchors = [akLeft, akTop, akRight]
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'Tahoma'
    Font.Style = [fsBold]
    ParentFont = False
    PasswordChar = #248
    TabOrder = 2
  end
  object BitBtn_ChangePassword: TBitBtn [17]
    Left = 187
    Top = 180
    Width = 81
    Height = 25
    Anchors = [akRight, akBottom]
    Caption = 'Alterar'
    Default = True
    TabOrder = 3
    OnClick = BitBtn_ChangePasswordClick
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
    Layout = blGlyphRight
    NumGlyphs = 2
    Spacing = 18
  end
  object BitBtn_Cancel: TBitBtn [18]
    Left = 274
    Top = 180
    Width = 81
    Height = 25
    Anchors = [akRight, akBottom]
    Cancel = True
    Caption = 'Cancelar'
    ModalResult = 2
    TabOrder = 4
    Glyph.Data = {
      DE010000424DDE01000000000000760000002800000024000000120000000100
      0400000000006801000000000000000000001000000000000000000000000000
      80000080000000808000800000008000800080800000C0C0C000808080000000
      FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFFFF00333333333333
      333333333333333333333333000033338833333333333333333F333333333333
      0000333911833333983333333388F333333F3333000033391118333911833333
      38F38F333F88F33300003339111183911118333338F338F3F8338F3300003333
      911118111118333338F3338F833338F3000033333911111111833333338F3338
      3333F8330000333333911111183333333338F333333F83330000333333311111
      8333333333338F3333383333000033333339111183333333333338F333833333
      00003333339111118333333333333833338F3333000033333911181118333333
      33338333338F333300003333911183911183333333383338F338F33300003333
      9118333911183333338F33838F338F33000033333913333391113333338FF833
      38F338F300003333333333333919333333388333338FFF830000333333333333
      3333333333333333333888330000333333333333333333333333333333333333
      0000}
    Layout = blGlyphRight
    NumGlyphs = 2
    Spacing = 8
  end
end
