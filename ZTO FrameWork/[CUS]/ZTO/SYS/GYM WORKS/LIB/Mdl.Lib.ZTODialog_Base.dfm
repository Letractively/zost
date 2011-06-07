object ZTODialog_Base: TZTODialog_Base
  Left = 0
  Top = 0
  Caption = 'ZTODialog_Base'
  ClientHeight = 208
  ClientWidth = 314
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  ZTOProperties.SelectedButton = sbClose
  ZTOProperties.InfoPanel.Font.Charset = DEFAULT_CHARSET
  ZTOProperties.InfoPanel.Font.Color = clCaptionText
  ZTOProperties.InfoPanel.Font.Height = -11
  ZTOProperties.InfoPanel.Font.Name = 'Tahoma'
  ZTOProperties.InfoPanel.Font.Style = []
  OnCancelButtonClick = ZTODialogCancelButtonClick
  OnClose = ZTODialogClose
  OnCloseButtonClick = ZTODialogCloseButtonClick
  OnCloseQuery = ZTODialogCloseQuery
  OnOkButtonClick = ZTODialogOkButtonClick
  PixelsPerInch = 96
  TextHeight = 13
  BorderStyle = bsDialog
  BorderIcons = [biSystemMenu, biHelp]
  object ActionList: TActionList
    Left = 272
    Top = 8
    object Action_Fechar: TAction
      Caption = 'Fechar'
      OnExecute = Action_FecharExecute
    end
    object Action_Ok: TAction
      Caption = 'OK'
      OnExecute = Action_OkExecute
    end
    object Action_Cancelar: TAction
      Caption = 'Cancelar'
      OnExecute = Action_CancelarExecute
    end
  end
end
