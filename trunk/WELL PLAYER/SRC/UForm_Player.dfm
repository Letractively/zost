object Form_Player: TForm_Player
  Left = 458
  Top = 240
  VertScrollBar.Tracking = True
  BorderIcons = []
  BorderStyle = bsNone
  Caption = 'Form_Player'
  ClientHeight = 326
  ClientWidth = 632
  Color = clBlack
  Constraints.MaxHeight = 360
  Constraints.MaxWidth = 640
  Constraints.MinHeight = 360
  Constraints.MinWidth = 640
  UseDockManager = True
  DefaultMonitor = dmDesktop
  DockSite = True
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = True
  Position = poDefault
  OnClose = FormClose
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  OnResize = FormResize
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object Image_IMG: TImage
    Left = 0
    Top = 0
    Width = 632
    Height = 326
    Align = alClient
    Center = True
    DragCursor = crAppStart
    Proportional = True
    Stretch = True
    Visible = False
    OnMouseMove = Image_IMGMouseMove
  end
  object VideoWindow_VID: TVideoWindow
    Left = 0
    Top = 0
    Width = 632
    Height = 326
    Mode = vmVMR
    FilterGraph = FilterGraph
    VMROptions.Mode = vmrWindowless
    VMROptions.Streams = 16
    VMROptions.Preferences = [vpRestrictToInitialMonitor]
    Color = clBlack
    Align = alClient
    TabStop = False
    OnMouseMove = VideoWindow_VIDMouseMove
  end
  object ShockwaveFlash_SWF: TShockwaveFlash
    Left = 0
    Top = 0
    Width = 632
    Height = 326
    Align = alClient
    DragCursor = crArrow
    TabOrder = 1
    Visible = False
    OnProgress = ShockwaveFlash_SWFProgress
    ControlData = {
      675566550009000052410000B121000008000200000000000800000000000800
      0000000008000E000000570069006E0064006F00770000000800040000003000
      00000800060000002D00310000000800120000004100750074006F0048006900
      67006800000008000A0000004C00540052004200000008000400000030000000
      0800000000000800020000000000080010000000530068006F00770041006C00
      6C00000008000400000030000000080004000000300000000800020000000000
      08000000000008000200000000000D0000000000000000000000000000000000
      0800040000003100000008000400000030000000080000000000080004000000
      3000000008000800000061006C006C00000008000C000000660061006C007300
      65000000}
  end
  object FilterGraph: TFilterGraph
    Mode = gmDVD
    GraphEdit = False
    Left = 4
    Top = 4
  end
  object Timer_Estaticos: TTimer
    Interval = 500
    OnTimer = Timer_EstaticosTimer
    Left = 32
    Top = 4
  end
end
