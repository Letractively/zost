object Form2: TForm2
  Left = 0
  Top = 0
  BorderIcons = [biSystemMenu, biMinimize]
  BorderStyle = bsSingle
  Caption = 'ZLIB File (De)Compressor'
  ClientHeight = 60
  ClientWidth = 260
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  Position = poScreenCenter
  PixelsPerInch = 96
  TextHeight = 13
  object Button_Comprimir: TButton
    Left = 6
    Top = 6
    Width = 121
    Height = 25
    Caption = 'Comprimir...'
    TabOrder = 0
    OnClick = Button_ComprimirClick
  end
  object Button_Descomprimir: TButton
    Left = 133
    Top = 6
    Width = 121
    Height = 25
    Caption = 'Descomprimir...'
    TabOrder = 1
    OnClick = Button_DescomprimirClick
  end
  object ProgressBar_Progresso: TProgressBar
    Left = 6
    Top = 37
    Width = 248
    Height = 17
    TabOrder = 2
  end
  object OpenDialog_Abrir: TOpenDialog
    DefaultExt = '*.*'
    Filter = 'Todos os arquivos (*.*)|*.*'
    Left = 6
    Top = 6
  end
end
