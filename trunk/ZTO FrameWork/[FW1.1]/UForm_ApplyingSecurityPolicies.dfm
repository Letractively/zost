object Form_ApplyingSecurityPolicies: TForm_ApplyingSecurityPolicies
  Left = 0
  Top = 0
  BorderIcons = []
  BorderStyle = bsToolWindow
  Caption = 'Aplicando diretivas de seguran'#231'a. Aguarde...'
  ClientHeight = 79
  ClientWidth = 386
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  FormStyle = fsStayOnTop
  OldCreateOrder = False
  Position = poScreenCenter
  Visible = True
  OnClose = FormClose
  OnCreate = FormCreate
  DesignSize = (
    386
    79)
  PixelsPerInch = 96
  TextHeight = 13
  object Label_Total: TLabel
    Left = 6
    Top = 6
    Width = 375
    Height = 13
    Alignment = taCenter
    Anchors = [akLeft, akTop, akRight]
    AutoSize = False
    Caption = '???????'
    Color = clBtnFace
    ParentColor = False
  end
  object Label_Current: TLabel
    Left = 6
    Top = 43
    Width = 375
    Height = 13
    Alignment = taCenter
    Anchors = [akLeft, akTop, akRight]
    AutoSize = False
    Caption = '???????'
    Color = clBtnFace
    ParentColor = False
  end
  object ProgressBar_TotalProgress: TProgressBar
    Left = 6
    Top = 20
    Width = 375
    Height = 17
    Anchors = [akLeft, akTop, akRight]
    Step = 1
    TabOrder = 0
  end
  object ProgressBar_CurrentProgress: TProgressBar
    Left = 6
    Top = 57
    Width = 375
    Height = 17
    Anchors = [akLeft, akTop, akRight]
    Step = 1
    TabOrder = 1
  end
end
