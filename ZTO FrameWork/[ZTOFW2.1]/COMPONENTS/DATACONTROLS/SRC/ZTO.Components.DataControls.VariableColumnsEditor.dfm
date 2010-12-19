object Form_VariableColumnsEditor: TForm_VariableColumnsEditor
  Left = 0
  Top = 0
  BorderIcons = [biMinimize, biMaximize]
  BorderStyle = bsDialog
  Caption = 'Colunas de largura vari'#225'vel'
  ClientHeight = 288
  ClientWidth = 359
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
  object CheckListBox_Columns: TCheckListBox
    AlignWithMargins = True
    Left = 6
    Top = 53
    Width = 347
    Height = 198
    Margins.Left = 6
    Margins.Right = 6
    Align = alClient
    ItemHeight = 13
    TabOrder = 1
  end
  object Panel_Top: TPanel
    AlignWithMargins = True
    Left = 6
    Top = 6
    Width = 347
    Height = 41
    Margins.Left = 6
    Margins.Top = 6
    Margins.Right = 6
    Align = alTop
    BevelInner = bvLowered
    Color = clInfoBk
    ParentBackground = False
    TabOrder = 0
    object Label_Top: TLabel
      AlignWithMargins = True
      Left = 8
      Top = 8
      Width = 331
      Height = 25
      Margins.Left = 6
      Margins.Top = 6
      Margins.Right = 6
      Margins.Bottom = 6
      Align = alClient
      Alignment = taCenter
      Caption = 
        'Marque na lista abaixo as colunas que devem ser automaticamente ' +
        'redimensionadas. Colunas n'#227'o marcadas ser'#227'o consideradas fixas.'
      Layout = tlCenter
      WordWrap = True
      ExplicitWidth = 324
      ExplicitHeight = 26
    end
  end
  object Panel_Bottom: TPanel
    AlignWithMargins = True
    Left = 6
    Top = 257
    Width = 347
    Height = 25
    Margins.Left = 6
    Margins.Right = 6
    Margins.Bottom = 6
    Align = alBottom
    BevelOuter = bvNone
    TabOrder = 2
    object BitBtn_Confirmar: TBitBtn
      AlignWithMargins = True
      Left = 262
      Top = 0
      Width = 79
      Height = 25
      Margins.Top = 0
      Margins.Right = 6
      Margins.Bottom = 0
      Align = alRight
      Caption = 'Confirmar'
      DoubleBuffered = True
      Kind = bkOK
      ParentDoubleBuffered = False
      TabOrder = 1
    end
    object BitBtn_Cancelar: TBitBtn
      AlignWithMargins = True
      Left = 177
      Top = 0
      Width = 79
      Height = 25
      Margins.Top = 0
      Margins.Bottom = 0
      Align = alRight
      Caption = 'Cancelar'
      DoubleBuffered = True
      Kind = bkCancel
      ParentDoubleBuffered = False
      TabOrder = 0
    end
  end
end
