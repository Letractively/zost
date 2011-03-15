inherited XXXForm_AddEntity: TXXXForm_AddEntity
  Caption = 'Adicionar Entidades'
  ClientHeight = 304
  ClientWidth = 415
  ExplicitWidth = 421
  ExplicitHeight = 336
  PixelsPerInch = 96
  TextHeight = 13
  object Label_Description: TLabel [0]
    Left = 6
    Top = 55
    Width = 403
    Height = 65
    Alignment = taCenter
    Anchors = [akLeft, akTop, akRight]
    AutoSize = False
    Caption = 
      'Certifique-se de que todos os m'#243'dulos que cont'#233'm as entidades ca' +
      'ndidatas a registro estejam abertos, em seguida navegue por entr' +
      'e eles e clique nas entidades de sua escolha. Ao adicionar todas' +
      ' as a'#231#245'es (entidades) clique em "Registrar". Clique em "Remover"' +
      ' para retirar as entidades selecionadas da lista de registro. Cl' +
      'ique em "Cancelar" para desistir e fechar esta caixa de di'#225'logo.'
    Color = clBtnFace
    ParentColor = False
    WordWrap = True
    ExplicitWidth = 402
  end
  object Bevel_HorizontalLine: TBevel [1]
    Left = 6
    Top = 118
    Width = 403
    Height = 10
    Anchors = [akLeft, akTop, akRight]
    Shape = bsBottomLine
    ExplicitWidth = 402
  end
  inherited Panel_Header: TPanel
    Width = 415
    TabOrder = 5
    ExplicitWidth = 415
    inherited Shape_BackgroundHeader: TShape
      Width = 415
      ExplicitWidth = 415
    end
    inherited Label_DialogDescription: TLabel
      Width = 369
      Caption = 
        'Esta caixa de di'#225'logo permite selecionar as entidades que ser'#227'o ' +
        'registradas para que seja poss'#237'vel posteriormente a aplica'#231#227'o de' +
        ' permiss'#245'es de usu'#225'rios e grupos nas mesmas'
      ExplicitWidth = 369
    end
    inherited Shape_HeaderLine: TShape
      Width = 407
      ExplicitWidth = 407
    end
    inherited Bevel_Header: TBevel
      Width = 415
      ExplicitWidth = 415
    end
  end
  inherited Panel_Footer: TPanel
    Top = 266
    Width = 415
    TabOrder = 6
    ExplicitTop = 266
    ExplicitWidth = 415
    inherited Shape_FooterBackground: TShape
      Width = 415
      ExplicitTop = 266
      ExplicitWidth = 415
    end
    inherited Shape_FooterLine: TShape
      Width = 407
      ExplicitTop = 4
      ExplicitWidth = 407
    end
    inherited Shape_Organizer: TShape
      Width = 407
      ExplicitTop = 9
      ExplicitWidth = 407
    end
    inherited Bevel_Footer: TBevel
      Width = 415
      ExplicitTop = 266
      ExplicitWidth = 415
    end
  end
  object ListBox_EntidadesSelecionadas: TListBox [4]
    Left = 6
    Top = 134
    Width = 403
    Height = 95
    Anchors = [akLeft, akTop, akRight]
    IntegralHeight = True
    ItemHeight = 13
    MultiSelect = True
    TabOrder = 0
  end
  object Button_RemoveSelectedEntities: TButton [5]
    Left = 6
    Top = 235
    Width = 201
    Height = 25
    Action = Action_RemoveSelectedEntities
    TabOrder = 1
  end
  object Button_ClearList: TButton [6]
    Left = 208
    Top = 235
    Width = 201
    Height = 25
    Action = Action_ClearList
    Anchors = [akTop, akRight]
    TabOrder = 2
  end
  object BitBtn_RegisterActions: TBitBtn [7]
    Left = 243
    Top = 275
    Width = 81
    Height = 25
    Action = Action_Register
    Anchors = [akRight, akBottom]
    Caption = 'Registrar'
    TabOrder = 3
    Glyph.Data = {
      F2010000424DF201000000000000760000002800000024000000130000000100
      0400000000007C01000000000000000000001000000000000000000000000000
      80000080000000808000800000008000800080800000C0C0C000808080000000
      FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFFFF00333334433333
      3333333333388F3333333333000033334224333333333333338338F333333333
      0000333422224333333333333833338F33333333000033422222243333333333
      83333338F3333333000034222A22224333333338F33F33338F33333300003222
      A2A2224333333338F383F3338F33333300003A2A222A222433333338F8333F33
      38F33333000034A22222A22243333338833333F3338F333300004222A2222A22
      2433338F338F333F3338F3330000222A3A2224A22243338F3838F338F3338F33
      0000A2A333A2224A2224338F83338F338F3338F300003A33333A2224A2224338
      333338F338F3338F000033333333A2224A2243333333338F338F338F00003333
      33333A2224A2233333333338F338F83300003333333333A2224A333333333333
      8F338F33000033333333333A222433333333333338F338F30000333333333333
      A224333333333333338F38F300003333333333333A223333333333333338F8F3
      000033333333333333A3333333333333333383330000}
    Layout = blGlyphRight
    NumGlyphs = 2
    Spacing = 6
  end
  object BitBtn_Cancel: TBitBtn [8]
    Left = 330
    Top = 275
    Width = 81
    Height = 25
    Action = Action_Cancel
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
  inherited ActionList_LocalActions: TActionList
    object Action_RemoveSelectedEntities: TAction
      Caption = 'Remover entidades selecionadas'
      OnExecute = Action_RemoveSelectedEntitiesExecute
    end
    object Action_ClearList: TAction
      Caption = 'Limpar a lista'
      OnExecute = Action_ClearListExecute
    end
    object Action_Register: TAction
      Caption = 'Registrar'
      OnExecute = Action_RegisterExecute
    end
    object Action_Cancel: TAction
      Caption = 'Cancelar'
      OnExecute = Action_CancelExecute
    end
  end
end
