inherited Form_ConfigureBackgroundImage: TForm_ConfigureBackgroundImage
  BorderIcons = []
  Caption = 'Configurar Imagem de Fundo da Aplica'#231#227'o'
  ClientHeight = 344
  ClientWidth = 658
  ExplicitWidth = 664
  ExplicitHeight = 376
  PixelsPerInch = 96
  TextHeight = 13
  object Label_NoneImage: TLabel [0]
    Left = 67
    Top = 187
    Width = 199
    Height = 26
    Alignment = taCenter
    AutoSize = False
    Caption = 
      'Nenhuma imagem definida. Clique no link "Adicionar imagem" para ' +
      'escolher uma.'
    WordWrap = True
  end
  object Shape_Positions: TShape [1]
    Left = 332
    Top = 100
    Width = 320
    Height = 200
    Brush.Color = clAppWorkSpace
  end
  object Label_Position4: TLabel [2]
    Left = 563
    Top = 262
    Width = 77
    Height = 13
    Caption = 'Inferior - Direito'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWhite
    Font.Height = -11
    Font.Name = 'Tahoma'
    Font.Style = []
    ParentFont = False
    Transparent = True
  end
  object Label_Position2: TLabel [3]
    Left = 561
    Top = 126
    Width = 81
    Height = 13
    Caption = 'Superior - Direito'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWhite
    Font.Height = -11
    Font.Name = 'Tahoma'
    Font.Style = []
    ParentFont = False
    Transparent = True
  end
  object Label_Position5: TLabel [4]
    Left = 461
    Top = 193
    Width = 60
    Height = 13
    Caption = 'Centralizada'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWhite
    Font.Height = -11
    Font.Name = 'Tahoma'
    Font.Style = []
    ParentFont = False
    Transparent = True
  end
  object Label_Position3: TLabel [5]
    Left = 338
    Top = 262
    Width = 91
    Height = 13
    Caption = 'Inferior - Esquerdo'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWhite
    Font.Height = -11
    Font.Name = 'Tahoma'
    Font.Style = []
    ParentFont = False
    Transparent = True
  end
  object Label_Position1: TLabel [6]
    Left = 336
    Top = 126
    Width = 95
    Height = 13
    Caption = 'Superior - Esquerdo'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWhite
    Font.Height = -11
    Font.Name = 'Tahoma'
    Font.Style = []
    ParentFont = False
    Transparent = True
  end
  object Label_BackgroundImage: TLabel [7]
    Left = 6
    Top = 55
    Width = 320
    Height = 39
    Alignment = taCenter
    AutoSize = False
    Caption = 
      'Clique no link "Abrir imagem" para selecionar a imagem que ser'#225' ' +
      'usada no fundo. Clique no link "Remover imagem" para remover a i' +
      'magem de fundo da aplica'#231#227'o. Clique "OK" quando terminar.'
    WordWrap = True
  end
  object Label_Position: TLabel [8]
    Left = 332
    Top = 55
    Width = 320
    Height = 39
    Alignment = taCenter
    AutoSize = False
    Caption = 
      'Indique a localiza'#231#227'o da sua imagem de fundo. Al'#233'm de Normal, a ' +
      'imagem central pode ser de dois tipos: "Ampliada", se ajustando ' +
      'a tela ou "Repetida",  preenchendo a tela com v'#225'rias c'#243'pias.'
    WordWrap = True
  end
  object Shape_BackgroundImage: TShape [9]
    Left = 6
    Top = 100
    Width = 320
    Height = 200
    Brush.Style = bsClear
  end
  object Shape_Image2: TShape [10]
    Left = 333
    Top = 101
    Width = 100
    Height = 62
  end
  object Shape_Position1: TShape [11]
    Left = 333
    Top = 101
    Width = 100
    Height = 62
    Brush.Style = bsClear
    Pen.Color = clWhite
    Pen.Style = psDot
    OnMouseDown = Shape_Position1MouseDown
  end
  object Shape_Position2: TShape [12]
    Tag = 1
    Left = 551
    Top = 101
    Width = 100
    Height = 62
    Brush.Style = bsClear
    Pen.Color = clWhite
    Pen.Style = psDot
    OnMouseDown = Shape_Position1MouseDown
  end
  object Shape_Position3: TShape [13]
    Tag = 2
    Left = 333
    Top = 237
    Width = 100
    Height = 62
    Brush.Style = bsClear
    Pen.Color = clWhite
    Pen.Style = psDot
    OnMouseDown = Shape_Position1MouseDown
  end
  object Shape_Position4: TShape [14]
    Tag = 3
    Left = 551
    Top = 237
    Width = 100
    Height = 62
    Brush.Style = bsClear
    Pen.Color = clWhite
    Pen.Style = psDot
    OnMouseDown = Shape_Position1MouseDown
  end
  object Shape_Position5: TShape [15]
    Tag = 4
    Left = 442
    Top = 169
    Width = 100
    Height = 62
    Brush.Style = bsClear
    Pen.Color = clWhite
    Pen.Style = psDot
    OnMouseDown = Shape_Position1MouseDown
  end
  object Shape_Image: TShape [16]
    Left = 333
    Top = 101
    Width = 100
    Height = 62
    Brush.Color = clRed
    Brush.Style = bsDiagCross
    Pen.Width = 4
  end
  object Image_Sample: TImage [17]
    Left = 6
    Top = 100
    Width = 320
    Height = 200
    Center = True
    IncrementalDisplay = True
    Stretch = True
  end
  object Label_LinkAddRemoveImageSombra1: TLabel [18]
    Left = 218
    Top = 282
    Width = 102
    Height = 13
    Alignment = taRightJustify
    Caption = 'Adicionar imagem'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'Tahoma'
    Font.Style = [fsBold]
    ParentFont = False
    Transparent = True
  end
  object Label_LinkAddRemoveImageSombra2: TLabel [19]
    Left = 218
    Top = 280
    Width = 102
    Height = 13
    Alignment = taRightJustify
    Caption = 'Adicionar imagem'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clBlack
    Font.Height = -11
    Font.Name = 'Tahoma'
    Font.Style = [fsBold]
    ParentFont = False
    Transparent = True
  end
  object Label_LinkAddRemoveImageSombra3: TLabel [20]
    Left = 216
    Top = 280
    Width = 102
    Height = 13
    Alignment = taRightJustify
    Caption = 'Adicionar imagem'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clBlack
    Font.Height = -11
    Font.Name = 'Tahoma'
    Font.Style = [fsBold]
    ParentFont = False
    Transparent = True
  end
  object Label_LinkAddRemoveImageSombra4: TLabel [21]
    Left = 216
    Top = 282
    Width = 102
    Height = 13
    Alignment = taRightJustify
    Caption = 'Adicionar imagem'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clBlack
    Font.Height = -11
    Font.Name = 'Tahoma'
    Font.Style = [fsBold]
    ParentFont = False
    Transparent = True
  end
  object Label_LinkAddRemoveImage: TLabel [22]
    Left = 217
    Top = 281
    Width = 102
    Height = 13
    Cursor = crHandPoint
    Alignment = taRightJustify
    Caption = 'Adicionar imagem'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clYellow
    Font.Height = -11
    Font.Name = 'Tahoma'
    Font.Style = [fsBold]
    ParentFont = False
    Transparent = True
    OnClick = Label_LinkAddRemoveImageClick
    OnMouseEnter = Label_LinkAddRemoveImageMouseEnter
    OnMouseLeave = Label_LinkAddRemoveImageMouseLeave
  end
  inherited Panel_Header: TPanel
    Width = 658
    TabOrder = 5
    ExplicitWidth = 658
    inherited Shape_BackgroundHeader: TShape
      Width = 658
      ExplicitWidth = 658
    end
    inherited Label_DialogDescription: TLabel
      Width = 612
      Caption = 
        'Com esta tela '#233' poss'#237'vel configurar a imagem de fundo da aplica'#231 +
        #227'o, que '#233' exibida quando nenhum m'#243'dulo est'#225' em execu'#231#227'o. Siga as' +
        ' instru'#231#245'es abaixo para configurar a imagem de fundo'
      ExplicitWidth = 612
    end
    inherited Shape_HeaderLine: TShape
      Width = 650
      ExplicitWidth = 650
    end
    inherited Bevel_Header: TBevel
      Width = 658
      ExplicitWidth = 658
    end
  end
  inherited Panel_Footer: TPanel
    Top = 306
    Width = 658
    TabOrder = 6
    ExplicitTop = 306
    ExplicitWidth = 658
    inherited Shape_FooterBackground: TShape
      Width = 658
      ExplicitTop = 306
      ExplicitWidth = 658
    end
    inherited Shape_FooterLine: TShape
      Width = 650
      ExplicitTop = 4
      ExplicitWidth = 650
    end
    inherited Shape_Organizer: TShape
      Width = 650
      ExplicitTop = 9
      ExplicitWidth = 650
    end
    inherited Bevel_Footer: TBevel
      Width = 658
      ExplicitTop = 306
      ExplicitWidth = 658
    end
  end
  object RadioButton_Zoomed: TRadioButton [25]
    Tag = 1
    Left = 441
    Top = 262
    Width = 60
    Height = 13
    Caption = 'Ampliada'
    Checked = True
    Color = clAppWorkSpace
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWhite
    Font.Height = -11
    Font.Name = 'Tahoma'
    Font.Style = []
    ParentColor = False
    ParentFont = False
    TabOrder = 0
    TabStop = True
    OnClick = RadioButton_NormalClick
  end
  object RadioButton_Normal: TRadioButton [26]
    Left = 441
    Top = 242
    Width = 50
    Height = 13
    Caption = 'Normal'
    Color = clAppWorkSpace
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWhite
    Font.Height = -11
    Font.Name = 'Tahoma'
    Font.Style = []
    ParentColor = False
    ParentFont = False
    TabOrder = 1
    OnClick = RadioButton_NormalClick
  end
  object RadioButton_Tiled: TRadioButton [27]
    Tag = 2
    Left = 441
    Top = 281
    Width = 60
    Height = 13
    Caption = 'Repetida'
    Color = clAppWorkSpace
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWhite
    Font.Height = -11
    Font.Name = 'Tahoma'
    Font.Style = []
    ParentColor = False
    ParentFont = False
    TabOrder = 2
    OnClick = RadioButton_NormalClick
  end
  object BitBtn_Ok: TBitBtn [28]
    Left = 579
    Top = 315
    Width = 75
    Height = 25
    Caption = 'Aplicar'
    ModalResult = 1
    TabOrder = 3
    OnClick = BitBtn_OkClick
    Glyph.Data = {
      36030000424D3603000000000000360000002800000010000000100000000100
      18000000000000030000120B0000120B00000000000000000000FF00FFFF00FF
      FF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00
      FFFF00FFFF00FFFF00FFFF00FFFF00FF006600006600B59A9BB59A9BB59A9BB5
      9A9BB59A9BB59A9BB59A9B006600006600FF00FFFF00FFFF00FFFF00FF006600
      009900009900E5DEDF006600006600E4E7E7E0E3E6D9DFE0CCC9CC006600037D
      03006600FF00FFFF00FFFF00FF006600009900009900E9E2E2006600006600E2
      E1E3E2E6E8DDE2E4CFCCCF006600037D03006600FF00FFFF00FFFF00FF006600
      009900009900ECE4E4006600006600DFDDDFE1E6E8E0E5E7D3D0D2006600037D
      03006600FF00FFFF00FFFF00FF006600009900009900EFE6E6EDE5E5E5DEDFE0
      DDDFDFE0E2E0E1E3D6D0D2006600037D03006600FF00FFFF00FFFF00FF006600
      0099000099000099000099000099000099000099000099000099000099000099
      00006600FF00FFFF00FFFF00FF006600009900B1D0B1B1D0B1B1D0B1B1D0B1B1
      D0B1B1D0B1B1D0B1B1D0B1B1D0B1009900006600FF00FFFF00FFFF00FF006600
      009900F9F9F9F9F9F9F9F9F9F9F9F9F9F9F9F9F9F9F9F9F9F9F9F9F9F9F90099
      00006600FF00FFFF00FFFF00FF006600009900F9F9F9F9F9F9F9F9F9F9F9F9F9
      F9F9F9F9F9F9F9F9F9F9F9F9F9F9009900006600FF00FFFF00FFFF00FF006600
      009900F9F9F9CDCDCDCDCDCDCDCDCDCDCDCDCDCDCDCDCDCDCDCDCDF9F9F90099
      00006600FF00FFFF00FFFF00FF006600009900F9F9F9F9F9F9F9F9F9F9F9F9F9
      F9F9F9F9F9F9F9F9F9F9F9F9F9F9009900006600FF00FFFF00FFFF00FF006600
      009900F9F9F9CDCDCDCDCDCDCDCDCDCDCDCDCDCDCDCDCDCDCDCDCDF9F9F90099
      00006600FF00FFFF00FFFF00FF006600009900F9F9F9F9F9F9F9F9F9F9F9F9F9
      F9F9F9F9F9F9F9F9F9F9F9F9F9F9009900006600FF00FFFF00FFFF00FFFF00FF
      006600F9F9F9F9F9F9F9F9F9F9F9F9F9F9F9F9F9F9F9F9F9F9F9F9F9F9F90066
      00FF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF
      00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FF}
  end
  object BitBtn_Cancel: TBitBtn [29]
    Left = 498
    Top = 315
    Width = 75
    Height = 25
    Caption = 'Cancelar'
    TabOrder = 4
    Kind = bkCancel
  end
  object OpenPictureDialog_Image: TOpenPictureDialog
    Options = [ofReadOnly, ofOverwritePrompt, ofHideReadOnly]
    Left = 30
    Top = 2
  end
end
