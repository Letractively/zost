object Form1: TForm1
  Left = 0
  Top = 0
  Caption = 'Form1'
  ClientHeight = 448
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
    Height = 448
    ActivePage = TabSheet_Components
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
      object Memo1: TMemo
        Left = 0
        Top = 165
        Width = 680
        Height = 255
        Align = alBottom
        Lines.Strings = (
          'Memo1')
        TabOrder = 2
      end
    end
    object TabSheet_ZTOWin32Rtl: TTabSheet
      Caption = 'ZTOWin32Rtl'
      ImageIndex = 1
      object PageControl_ZTOWin32Rtl: TPageControl
        Left = 0
        Top = 0
        Width = 680
        Height = 420
        ActivePage = TabSheet_Sys
        Align = alClient
        TabOrder = 0
        object TabSheet_Common: TTabSheet
          Caption = 'Common'
        end
        object TabSheet_Sys: TTabSheet
          Caption = 'Sys'
          ImageIndex = 1
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
    object TabSheet_ZTOWin32Db: TTabSheet
      Caption = 'ZTOWin32Db'
      ImageIndex = 2
    end
    object TabSheet_Components: TTabSheet
      Caption = 'Components'
      ImageIndex = 3
      object PageControl_Components: TPageControl
        Left = 0
        Top = 0
        Width = 680
        Height = 420
        ActivePage = TabSheet_DataControls
        Align = alClient
        TabOrder = 0
        object TabSheet_DataControls: TTabSheet
          Caption = 'DataControls'
          object ZTODBGrid1: TZTODBGrid
            Left = 0
            Top = 0
            Width = 672
            Height = 193
            Align = alTop
            DataSource = DataSource1
            DefaultDrawing = False
            Options = [dgTitles, dgIndicator, dgColumnResize, dgColLines, dgRowLines, dgTabs, dgConfirmDelete, dgCancelOnExit, dgMultiSelect, dgTitleClick]
            TabOrder = 0
            TitleFont.Charset = DEFAULT_CHARSET
            TitleFont.Color = clWindowText
            TitleFont.Height = -11
            TitleFont.Name = 'Tahoma'
            TitleFont.Style = []
            RowColors = <>
            Columns = <
              item
                Expanded = False
                FieldName = 'help_topic_id'
                Visible = True
              end
              item
                Expanded = False
                FieldName = 'name'
                Visible = True
              end
              item
                Expanded = False
                FieldName = 'help_category_id'
                Font.Charset = DEFAULT_CHARSET
                Font.Color = clRed
                Font.Height = -11
                Font.Name = 'Tahoma'
                Font.Style = []
                Visible = True
              end
              item
                Expanded = False
                FieldName = 'description'
                Visible = True
              end
              item
                Expanded = False
                FieldName = 'example'
                Visible = True
              end
              item
                Expanded = False
                FieldName = 'url'
                Visible = True
              end>
          end
          object DBGrid1: TDBGrid
            Left = 0
            Top = 193
            Width = 672
            Height = 199
            Align = alClient
            Ctl3D = True
            DataSource = DataSource1
            GradientEndColor = clRed
            GradientStartColor = clBlack
            Options = [dgTitles, dgIndicator, dgColumnResize, dgColLines, dgRowLines, dgTabs, dgConfirmDelete, dgCancelOnExit, dgMultiSelect, dgTitleClick, dgTitleHotTrack]
            ParentCtl3D = False
            TabOrder = 1
            TitleFont.Charset = DEFAULT_CHARSET
            TitleFont.Color = clWindowText
            TitleFont.Height = -11
            TitleFont.Name = 'Tahoma'
            TitleFont.Style = []
            Columns = <
              item
                Expanded = False
                FieldName = 'help_topic_id'
                Visible = True
              end
              item
                Expanded = False
                FieldName = 'name'
                Visible = True
              end
              item
                Color = clInfoBk
                Expanded = False
                FieldName = 'help_category_id'
                Font.Charset = DEFAULT_CHARSET
                Font.Color = clRed
                Font.Height = -11
                Font.Name = 'Tahoma'
                Font.Style = []
                Visible = True
              end
              item
                Expanded = False
                FieldName = 'description'
                Visible = True
              end
              item
                Expanded = False
                FieldName = 'example'
                Visible = True
              end
              item
                Expanded = False
                FieldName = 'url'
                Visible = True
              end>
          end
        end
      end
    end
  end
  object Timer1: TTimer
    Interval = 100
    OnTimer = Timer1Timer
    Left = 6
    Top = 266
  end
  object DataSource1: TDataSource
    DataSet = ZQuery1
    Left = 416
    Top = 192
  end
  object ZQuery1: TZQuery
    Connection = ZConnection1
    Active = True
    SQL.Strings = (
      'SELECT * FROM help_topic'
      '')
    Params = <>
    Left = 344
    Top = 232
  end
  object ZConnection1: TZConnection
    Connected = True
    Protocol = 'mysql-5'
    HostName = '127.0.0.1'
    Database = 'mysql'
    User = 'root'
    Password = '123456'
    Left = 264
    Top = 224
  end
end
