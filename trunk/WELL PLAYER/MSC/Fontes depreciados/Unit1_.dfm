object Principal: TPrincipal
  Left = 501
  Top = 167
  Cursor = crAppStart
  VertScrollBar.Tracking = True
  BorderIcons = []
  BorderStyle = bsNone
  Caption = 'Principal'
  ClientHeight = 322
  ClientWidth = 697
  Color = 10930928
  UseDockManager = True
  DefaultMonitor = dmDesktop
  DockSite = True
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  FormStyle = fsStayOnTop
  OldCreateOrder = False
  Position = poDefault
  Visible = True
  OnClose = FormClose
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object BitBtn1: TBitBtn
    Left = 472
    Top = 290
    Width = 55
    Height = 16
    Cursor = crHandPoint
    Caption = 'Esconde'
    DragCursor = crHandPoint
    TabOrder = 0
    Visible = False
    OnClick = BitBtn1Click
    Layout = blGlyphTop
  end
  object VideoWindow: TVideoWindow
    Left = 450
    Top = 8
    Width = 225
    Height = 177
    Mode = vmVMR
    FilterGraph = FilterGraph
    VMROptions.Mode = vmrWindowless
    VMROptions.Streams = 16
    VMROptions.Preferences = [vpForceOffscreen, vpForceOverlays, vpForceMixer]
    Color = clBlack
    TabStop = False
    OnMouseMove = VideoWindowMouseMove
    object Image2: TImage
      Left = 320
      Top = 0
      Width = 377
      Height = 303
      Center = True
      DragCursor = crAppStart
      Proportional = True
      Stretch = True
      Visible = False
      OnMouseMove = Image2MouseMove
    end
  end
  object StatusBar: TStatusBar
    Left = 0
    Top = 303
    Width = 697
    Height = 19
    Panels = <>
    SimplePanel = True
    Visible = False
  end
  object TrackBar: TDSTrackBar
    Left = 96
    Top = 328
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
    Width = 281
    Height = 303
    DragCursor = crArrow
    TabOrder = 4
    Visible = False
    OnProgress = ShockwaveFlash1Progress
    ControlData = {
      67556655000900000B1D0000511F000008000200000000000800000000000800
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
    Left = 6
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
