object ZTODialog2: TZTODialog2
  Left = 0
  Top = 0
  Caption = 'ZTODialog2'
  ClientHeight = 288
  ClientWidth = 713
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  ZTOProperties.DialogDescription = 'A descri'#231#227'o geral fica aqui!'
  ZTOProperties.VisibleButtons = [vbOk, vbYes, vbYesToAll, vbNo, vbIgnore, vbCancel, vbClose, vbHelp]
  ZTOProperties.DialogType = dtWarning
  ZTOProperties.InfoPanel.Font.Charset = DEFAULT_CHARSET
  ZTOProperties.InfoPanel.Font.Color = clCaptionText
  ZTOProperties.InfoPanel.Font.Height = -11
  ZTOProperties.InfoPanel.Font.Name = 'Tahoma'
  ZTOProperties.InfoPanel.Font.Style = []
  PixelsPerInch = 96
  TextHeight = 13
  BorderStyle = bsDialog
  BorderIcons = [biSystemMenu, biHelp]
  object ZTODBGrid1: TZTODBGrid
    Left = 0
    Top = 49
    Width = 713
    Height = 201
    Align = alClient
    DataSource = ZTODataModule3.DataSource1
    DefaultDrawing = False
    Options = [dgEditing, dgTitles, dgIndicator, dgColLines, dgRowLines, dgTabs, dgConfirmDelete, dgCancelOnExit]
    OptionsEx = [dgAllowTitleClick, dgAutomaticColumSizes]
    ParentShowHint = False
    ShowHint = False
    TabOrder = 2
    TitleFont.Charset = DEFAULT_CHARSET
    TitleFont.Color = clWindowText
    TitleFont.Height = -11
    TitleFont.Name = 'Tahoma'
    TitleFont.Style = []
    RowColors = <
      item
        BackgroundColor = clInfoBk
        ForegroundColor = clBtnText
      end>
    SortArrow.Column = 'IN_OBRAS_PK'
    SortArrow.Direction = sadDescending
    VariableWidthColumns = '<VA_NOMEDAOBRA>'
    Columns = <
      item
        Expanded = False
        FieldName = 'BI_USUARIO_ID'
        Width = 147
        Visible = True
      end
      item
        Expanded = False
        FieldName = 'VA_NOME'
        Width = 525
        Visible = True
      end>
  end
end
