object Form1: TForm1
  Left = 0
  Top = 0
  Caption = 'Form1'
  ClientHeight = 334
  ClientWidth = 688
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  FormStyle = fsStayOnTop
  OldCreateOrder = False
  PixelsPerInch = 96
  TextHeight = 13
  object PageControl_Principal: TPageControl
    Left = 0
    Top = 0
    Width = 688
    Height = 334
    ActivePage = TabSheet_FormTemplates
    Align = alClient
    TabOrder = 0
    object TabSheet_FormTemplates: TTabSheet
      Caption = 'Form Templates'
      object Label1: TLabel
        Left = 8
        Top = 232
        Width = 31
        Height = 13
        Caption = 'Label1'
      end
      object Label2: TLabel
        Left = 8
        Top = 248
        Width = 31
        Height = 13
        Caption = 'Label2'
      end
      object Button1: TButton
        Left = 19
        Top = 20
        Width = 75
        Height = 25
        Caption = 'Button1'
        TabOrder = 0
        OnClick = Button1Click
      end
      object Button14: TButton
        Left = 100
        Top = 20
        Width = 75
        Height = 25
        Caption = 'Button14'
        TabOrder = 1
        OnClick = Button14Click
      end
    end
    object TabSheet_ZTOWin32Rtl: TTabSheet
      Caption = 'ZTOWin32Rtl'
      ImageIndex = 1
      object PageControl_ZTOWin32Rtl: TPageControl
        Left = 0
        Top = 0
        Width = 680
        Height = 306
        ActivePage = TabSheet_Common
        Align = alClient
        TabOrder = 0
        object TabSheet_Common: TTabSheet
          Caption = 'Common'
        end
        object TabSheet_Sys: TTabSheet
          Caption = 'Sys'
          ImageIndex = 1
          ExplicitLeft = 0
          ExplicitTop = 0
          ExplicitWidth = 0
          ExplicitHeight = 0
          object Button2: TButton
            Left = 3
            Top = 3
            Width = 162
            Height = 25
            Caption = 'Utilities.ShowDesktop'
            TabOrder = 0
            OnClick = Button2Click
          end
          object Button3: TButton
            Left = 171
            Top = 3
            Width = 162
            Height = 25
            Caption = 'Utilities.EnableDesktop'
            TabOrder = 1
            OnClick = Button3Click
          end
          object Button4: TButton
            Left = 339
            Top = 3
            Width = 162
            Height = 25
            Caption = 'Utilities.IsDesktopVisible'
            TabOrder = 2
            OnClick = Button4Click
          end
          object Button5: TButton
            Left = 507
            Top = 3
            Width = 162
            Height = 25
            Caption = 'Utilities.IsDesktopEnabled'
            TabOrder = 3
            OnClick = Button5Click
          end
          object Button6: TButton
            Left = 3
            Top = 34
            Width = 162
            Height = 25
            Caption = 'Utilities.ShowTaskBar'
            TabOrder = 4
            OnClick = Button6Click
          end
          object Button7: TButton
            Left = 171
            Top = 34
            Width = 162
            Height = 25
            Caption = 'Utilities.EnableTaskBar'
            TabOrder = 5
            OnClick = Button7Click
          end
          object Button8: TButton
            Left = 339
            Top = 34
            Width = 162
            Height = 25
            Caption = 'Utilities.IsTaskBarVisible'
            TabOrder = 6
            OnClick = Button8Click
          end
          object Button9: TButton
            Left = 507
            Top = 34
            Width = 162
            Height = 25
            Caption = 'Utilities.IsTaskBarEnabled'
            TabOrder = 7
            OnClick = Button9Click
          end
          object Button10: TButton
            Left = 3
            Top = 65
            Width = 162
            Height = 25
            Caption = 'Utilities.ShowStartButtom'
            TabOrder = 8
            OnClick = Button10Click
          end
          object Button11: TButton
            Left = 171
            Top = 65
            Width = 162
            Height = 25
            Caption = 'Utilities.EnableStartButtom'
            TabOrder = 9
            OnClick = Button11Click
          end
          object Button12: TButton
            Left = 339
            Top = 65
            Width = 162
            Height = 25
            Caption = 'Utilities.IsStartButtomVisible'
            TabOrder = 10
            OnClick = Button12Click
          end
          object Button13: TButton
            Left = 507
            Top = 65
            Width = 162
            Height = 25
            Caption = 'Utilities.IsStartButtomEnabled'
            TabOrder = 11
            OnClick = Button13Click
          end
        end
      end
    end
  end
  object Timer1: TTimer
    Interval = 100
    OnTimer = Timer1Timer
    Left = 24
    Top = 80
  end
end
