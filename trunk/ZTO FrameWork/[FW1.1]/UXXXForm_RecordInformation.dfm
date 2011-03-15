inherited XXXForm_RecordInformation: TXXXForm_RecordInformation
  Caption = 'Informa'#231#245'es do registro selecionado...'
  ClientHeight = 264
  ClientWidth = 442
  ExplicitWidth = 448
  ExplicitHeight = 296
  PixelsPerInch = 96
  TextHeight = 13
  object Label_CreationDateAndTime: TLabel [0]
    Left = 6
    Top = 93
    Width = 430
    Height = 13
    Anchors = [akLeft, akTop, akRight]
    AutoSize = False
    Caption = 
      'Data e hora da cria'#231#227'o do registro..............................' +
      '...................................'
  end
  object Label_CreationDateAndTimeValor: TLabel [1]
    Left = 287
    Top = 93
    Width = 149
    Height = 13
    Alignment = taRightJustify
    Anchors = [akTop]
    Caption = 'dd/mm/aaaa '#224's hh:mm:ss'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clRed
    Font.Height = -11
    Font.Name = 'Tahoma'
    Font.Style = [fsBold]
    ParentFont = False
  end
  object Label_TableName: TLabel [2]
    Left = 6
    Top = 55
    Width = 430
    Height = 13
    Anchors = [akLeft, akTop, akRight]
    AutoSize = False
    Caption = 
      'Tabela..........................................................' +
      '........................................'
  end
  object Label_TableNameValor: TLabel [3]
    Left = 388
    Top = 55
    Width = 48
    Height = 13
    Alignment = taRightJustify
    Anchors = [akTop]
    Caption = '????????'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clRed
    Font.Height = -11
    Font.Name = 'Tahoma'
    Font.Style = [fsBold]
    ParentFont = False
  end
  object Label_RecordId: TLabel [4]
    Left = 6
    Top = 74
    Width = 430
    Height = 13
    Anchors = [akLeft, akTop, akRight]
    AutoSize = False
    Caption = 
      'Identifica'#231#227'o do registro.......................................' +
      '.....................................'
  end
  object Label_RecordIdValor: TLabel [5]
    Left = 388
    Top = 74
    Width = 48
    Height = 13
    Alignment = taRightJustify
    Anchors = [akTop]
    Caption = '????????'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clRed
    Font.Height = -11
    Font.Name = 'Tahoma'
    Font.Style = [fsBold]
    ParentFont = False
  end
  object Label_CreatorFullName: TLabel [6]
    Left = 6
    Top = 112
    Width = 430
    Height = 13
    Anchors = [akLeft, akTop, akRight]
    AutoSize = False
    Caption = 
      'Usu'#225'rio criador do registro.....................................' +
      '.....................................'
  end
  object Label_CreatorFullNameValor: TLabel [7]
    Left = 388
    Top = 112
    Width = 48
    Height = 13
    Alignment = taRightJustify
    Anchors = [akTop]
    Caption = '????????'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clRed
    Font.Height = -11
    Font.Name = 'Tahoma'
    Font.Style = [fsBold]
    ParentFont = False
  end
  object Label_LastModificationDateAndTime: TLabel [8]
    Left = 6
    Top = 150
    Width = 430
    Height = 13
    Anchors = [akLeft, akTop, akRight]
    AutoSize = False
    Caption = 
      'Data e hora da '#250'ltima modifica'#231#227'o do registro...................' +
      '..............................................'
  end
  object Label_LastModificationDateAndTimeValor: TLabel [9]
    Left = 287
    Top = 150
    Width = 149
    Height = 13
    Alignment = taRightJustify
    Anchors = [akTop]
    Caption = 'dd/mm/aaaa '#224's hh:mm:ss'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clRed
    Font.Height = -11
    Font.Name = 'Tahoma'
    Font.Style = [fsBold]
    ParentFont = False
  end
  object Label_LastModifierFullName: TLabel [10]
    Left = 6
    Top = 169
    Width = 430
    Height = 13
    Anchors = [akLeft, akTop, akRight]
    AutoSize = False
    Caption = 
      'Usu'#225'rio modificador do registro.................................' +
      '.........................................'
  end
  object Label_LastModifierFullNameValor: TLabel [11]
    Left = 388
    Top = 169
    Width = 48
    Height = 13
    Alignment = taRightJustify
    Anchors = [akTop]
    Caption = '????????'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clRed
    Font.Height = -11
    Font.Name = 'Tahoma'
    Font.Style = [fsBold]
    ParentFont = False
  end
  object Label_CreatorId: TLabel [12]
    Left = 6
    Top = 131
    Width = 430
    Height = 13
    Anchors = [akLeft, akTop, akRight]
    AutoSize = False
    Caption = 
      'Identifica'#231#227'o do usu'#225'rio criador do registro....................' +
      '......................................................'
  end
  object Label_CreatorIdValor: TLabel [13]
    Left = 388
    Top = 131
    Width = 48
    Height = 13
    Alignment = taRightJustify
    Anchors = [akTop]
    Caption = '????????'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clRed
    Font.Height = -11
    Font.Name = 'Tahoma'
    Font.Style = [fsBold]
    ParentFont = False
  end
  object Label_LastModifierId: TLabel [14]
    Left = 6
    Top = 188
    Width = 430
    Height = 13
    Anchors = [akLeft, akTop, akRight]
    AutoSize = False
    Caption = 
      'Identifica'#231#227'o do usu'#225'rio modificador do registro................' +
      '..........................................................'
  end
  object Label_LastModifierIdValor: TLabel [15]
    Left = 388
    Top = 188
    Width = 48
    Height = 13
    Alignment = taRightJustify
    Anchors = [akTop]
    Caption = '????????'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clRed
    Font.Height = -11
    Font.Name = 'Tahoma'
    Font.Style = [fsBold]
    ParentFont = False
  end
  object Label_RecordStatus: TLabel [16]
    Left = 6
    Top = 207
    Width = 430
    Height = 13
    Anchors = [akLeft, akTop, akRight]
    AutoSize = False
    Caption = 
      'Situa'#231#227'o do registro............................................' +
      '......................................'
  end
  object Label_RecordStatusValor: TLabel [17]
    Left = 388
    Top = 207
    Width = 48
    Height = 13
    Alignment = taRightJustify
    Anchors = [akTop]
    Caption = '????????'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clRed
    Font.Height = -11
    Font.Name = 'Tahoma'
    Font.Style = [fsBold]
    ParentFont = False
  end
  inherited Panel_Header: TPanel
    Width = 442
    ExplicitWidth = 442
    inherited Shape_BackgroundHeader: TShape
      Width = 442
      ExplicitWidth = 442
    end
    inherited Label_DialogDescription: TLabel
      Width = 396
      Caption = 
        'Esta tela mostra informa'#231#245'es acerca de um determinado registro. ' +
        'De posse destas informa'#231#245'es '#233' possivel saber por exemplo quando ' +
        'e por quem um registro foi modificado pela '#250'ltima vez'
      ExplicitWidth = 396
    end
    inherited Shape_HeaderLine: TShape
      Width = 434
      ExplicitWidth = 434
    end
    inherited Bevel_Header: TBevel
      Width = 442
      ExplicitWidth = 442
    end
  end
  inherited Panel_Footer: TPanel
    Top = 226
    Width = 442
    ExplicitTop = 226
    ExplicitWidth = 442
    inherited Shape_FooterBackground: TShape
      Width = 442
      ExplicitTop = 226
      ExplicitWidth = 442
    end
    inherited Shape_FooterLine: TShape
      Width = 434
      ExplicitTop = 4
      ExplicitWidth = 434
    end
    inherited Shape_Organizer: TShape
      Width = 434
      ExplicitTop = 9
      ExplicitWidth = 434
    end
    inherited Bevel_Footer: TBevel
      Width = 442
      ExplicitTop = 226
      ExplicitWidth = 442
    end
  end
end
