object Form_Player: TForm_Player
  Left = 501
  Top = 253
  Cursor = crAppStart
  VertScrollBar.Tracking = True
  BorderIcons = []
  BorderStyle = bsNone
  Caption = 'Form_Player'
  ClientHeight = 535
  ClientWidth = 688
  Color = clBlack
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
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object Image_IMG: TImage
    Left = 0
    Top = 0
    Width = 688
    Height = 516
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
    Width = 688
    Height = 516
    Mode = vmVMR
    FilterGraph = FilterGraph
    VMROptions.Mode = vmrWindowless
    VMROptions.Streams = 16
    VMROptions.Preferences = []
    Color = clBlack
    Align = alClient
    TabStop = False
    OnMouseMove = VideoWindow_VIDMouseMove
  end
  object StatusBar: TStatusBar
    Left = 0
    Top = 516
    Width = 688
    Height = 19
    Panels = <>
    SimplePanel = True
    Visible = False
  end
  object ShockwaveFlash_SWF: TShockwaveFlash
    Left = 0
    Top = 0
    Width = 688
    Height = 516
    Align = alClient
    DragCursor = crArrow
    TabOrder = 4
    Visible = False
    OnProgress = ShockwaveFlash_SWFProgress
    ControlData = {
      67556655000900001B4700005535000008000200000000000800000000000800
      0000000008000E000000570069006E0064006F00770000000800040000003000
      00000800060000002D00310000000800100000004100750074006F004C006F00
      7700000008000200000000000800060000002D00310000000800000000000800
      020000000000080010000000530068006F00770041006C006C00000008000400
      0000300000000800040000003000000008000E00000030003000300030003000
      3000000008000000000008000200000000000D00000000000000000000000000
      0000000008000400000031000000080004000000300000000800000000000800
      040000003000000008000800000061006C006C00000008000C00000066006100
      6C00730065000000}
  end
  object BitBtn1: TBitBtn
    Left = 164
    Top = 494
    Width = 55
    Height = 16
    Cursor = crHandPoint
    Caption = 'Esconde'
    DoubleBuffered = True
    DragCursor = crHandPoint
    Layout = blGlyphTop
    ParentDoubleBuffered = False
    TabOrder = 0
    Visible = False
    OnClick = BitBtn1Click
  end
  object TrackBar: TDSTrackBar
    Left = 8
    Top = 465
    Width = 150
    Height = 45
    TabOrder = 3
    Visible = False
    FilterGraph = FilterGraph
    OnTimer = TrackBarTimer
  end
  object CFSHChangeNotifier_Principal: TCFSHChangeNotifier
    Root = 'C:\'
    WatchSubTree = True
    OnChangeFileName = CFSHChangeNotifier_PrincipalChangeFileName
    OnChangeDirName = CFSHChangeNotifier_PrincipalChangeDirName
    OnChangeAttributes = CFSHChangeNotifier_PrincipalChangeAttributes
    OnChangeSize = CFSHChangeNotifier_PrincipalChangeSize
    OnChangeLastWrite = CFSHChangeNotifier_PrincipalChangeLastWrite
    OnChangeSecurity = CFSHChangeNotifier_PrincipalChangeSecurity
    Left = 62
    Top = 6
  end
  object FilterGraph: TFilterGraph
    AutoCreate = True
    Mode = gmDVD
    GraphEdit = True
    Left = 314
    Top = 4
  end
  object OpenDialog: TOpenDialog
    Left = 364
    Top = 8
  end
  object Timer1: TTimer
    Enabled = False
    OnTimer = Timer1Timer
    Left = 182
    Top = 6
  end
  object Timer2: TTimer
    Enabled = False
    OnTimer = Timer2Timer
    Left = 262
    Top = 10
  end
end
