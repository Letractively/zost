object Form_Sistemas: TForm_Sistemas
  Left = 0
  Top = 0
  BorderIcons = [biMinimize, biMaximize]
  BorderStyle = bsDialog
  Caption = 'Sistemas dispon'#237'veis'
  ClientHeight = 222
  ClientWidth = 250
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
  object ZTODBGrid_SIS: TZTODBGrid
    AlignWithMargins = True
    Left = 6
    Top = 6
    Width = 238
    Height = 179
    Margins.Left = 6
    Margins.Top = 6
    Margins.Right = 6
    Align = alClient
    DataSource = DataModule_Principal.DataSource_SIS
    Options = [dgIndicator, dgColLines, dgRowLines, dgTabs, dgRowSelect, dgAlwaysShowSelection, dgConfirmDelete, dgCancelOnExit, dgMultiSelect]
    OptionsEx = [dgAllowTitleClick, dgPersistentSelection]
    TabOrder = 0
    TitleFont.Charset = DEFAULT_CHARSET
    TitleFont.Color = clWindowText
    TitleFont.Height = -11
    TitleFont.Name = 'Tahoma'
    TitleFont.Style = []
    RowColors = <>
    OnAfterMultiselect = ZTODBGrid_SISAfterMultiselect
    Columns = <
      item
        Expanded = False
        FieldName = 'VA_NOME'
        Visible = True
      end>
  end
  object Panel_SIS: TPanel
    AlignWithMargins = True
    Left = 6
    Top = 191
    Width = 238
    Height = 25
    Margins.Left = 6
    Margins.Right = 6
    Margins.Bottom = 6
    Align = alBottom
    BevelOuter = bvNone
    TabOrder = 1
    object BitBtn_Cancelar: TBitBtn
      AlignWithMargins = True
      Left = 82
      Top = 0
      Width = 75
      Height = 25
      Margins.Left = 0
      Margins.Top = 0
      Margins.Bottom = 0
      Align = alRight
      Caption = 'Cancelar'
      TabOrder = 0
      Kind = bkCancel
    end
    object BitBtn_Confirmar: TBitBtn
      AlignWithMargins = True
      Left = 163
      Top = 0
      Width = 75
      Height = 25
      Margins.Top = 0
      Margins.Right = 0
      Margins.Bottom = 0
      Align = alRight
      Enabled = False
      TabOrder = 1
      Kind = bkOK
    end
  end
end
