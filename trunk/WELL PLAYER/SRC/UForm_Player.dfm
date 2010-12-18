object Form_Player: TForm_Player
  Left = 501
  Top = 253
  Cursor = crAppStart
  VertScrollBar.Tracking = True
  BorderIcons = []
  BorderStyle = bsNone
  Caption = 'Form_Player'
  ClientHeight = 236
  ClientWidth = 660
  Color = clBtnFace
  UseDockManager = True
  DefaultMonitor = dmDesktop
  DockSite = True
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  FormStyle = fsStayOnTop
  OldCreateOrder = True
  Position = poDefault
  Visible = True
  OnClose = FormClose
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object Image2: TImage
    Left = 0
    Top = 0
    Width = 660
    Height = 236
    Align = alClient
    Center = True
    DragCursor = crAppStart
    Proportional = True
    Stretch = True
    Visible = False
    OnMouseMove = Image2MouseMove
    ExplicitWidth = 380
  end
  object BitBtn1: TBitBtn
    Left = 472
    Top = 290
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
  object VideoWindow: TVideoWindow
    Left = 0
    Top = 0
    Width = 660
    Height = 236
    Mode = vmVMR
    FilterGraph = FilterGraph
    VMROptions.Mode = vmrWindowless
    VMROptions.Streams = 16
    VMROptions.Preferences = []
    Color = clBlack
    Align = alClient
    TabStop = False
    OnMouseMove = VideoWindowMouseMove
    ExplicitWidth = 719
    ExplicitHeight = 460
  end
  object StatusBar: TStatusBar
    Left = 16
    Top = 105
    Width = 380
    Height = 19
    Align = alNone
    Panels = <>
    SimplePanel = True
    Visible = False
  end
  object TrackBar: TDSTrackBar
    Left = 16
    Top = 130
    Width = 150
    Height = 45
    TabOrder = 3
    Visible = False
    FilterGraph = FilterGraph
    OnTimer = TrackBarTimer
  end
  object ShockwaveFlash1: TShockwaveFlash
    Left = 0
    Top = 0
    Width = 660
    Height = 236
    Align = alClient
    DragCursor = crArrow
    TabOrder = 4
    Visible = False
    OnProgress = ShockwaveFlash1Progress
    ExplicitWidth = 380
    ControlData = {
      6755665500090000374400006418000008000200000000000800000000000800
      0000000008000E000000570069006E0064006F00770000000800040000003000
      00000800060000002D003100000008000A000000480069006700680000000800
      0200000000000800060000002D00310000000800000000000800020000000000
      080010000000530068006F00770041006C006C00000008000400000030000000
      0800060000002D003100000008000E0000004200460042004600420046000000
      08000000000008000200000000000D0000000000000000000000000000000000
      0800040000003100000008000400000030000000080000000000080004000000
      3000000008000800000061006C006C00000008000C000000660061006C007300
      65000000}
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
    Left = 578
    Top = 4
  end
  object OpenDialog: TOpenDialog
    Left = 586
    Top = 68
  end
  object Timer1: TTimer
    Enabled = False
    OnTimer = Timer1Timer
    Left = 464
    Top = 24
  end
  object Timer2: TTimer
    Enabled = False
    OnTimer = Timer2Timer
    Left = 472
    Top = 64
  end
end
