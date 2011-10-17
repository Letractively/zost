unit UForm_Principal;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, Grids, DBGrids, ComCtrls, ExtCtrls, Buttons,
  ZTO.Components.DataControls.DBGrid, DB, DBClient, ZAbstractConnection,
  ZConnection, ZAbstractRODataset, ZDataset, ZAbstractDataset;

type
  TForm1 = class(TForm)
    PageControl_Principal: TPageControl;
    TabSheet_FormTemplates: TTabSheet;
    Button1: TButton;
    TabSheet_ZTOWin32Rtl: TTabSheet;
    PageControl_ZTOWin32Rtl: TPageControl;
    TabSheet_Common: TTabSheet;
    TabSheet_Sys: TTabSheet;
    Button2: TButton;
    Button3: TButton;
    Button4: TButton;
    Button5: TButton;
    Button6: TButton;
    Button7: TButton;
    Button8: TButton;
    Button9: TButton;
    Button10: TButton;
    Button11: TButton;
    Button12: TButton;
    Button13: TButton;
    Label1: TLabel;
    Label2: TLabel;
    Timer1: TTimer;
    Button14: TButton;
    TabSheet_ZTOWin32Db: TTabSheet;
    TabSheet_Components: TTabSheet;
    PageControl_Components: TPageControl;
    TabSheet_DataControls: TTabSheet;
    ZTODBGrid1: TZTODBGrid;
    Memo1: TMemo;
    DataSource1: TDataSource;
    DBGrid1: TDBGrid;
    ZQuery1: TZQuery;
    ZConnection1: TZConnection;
    procedure Button1Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure Button3Click(Sender: TObject);
    procedure Button4Click(Sender: TObject);
    procedure Button5Click(Sender: TObject);
    procedure Button6Click(Sender: TObject);
    procedure Button7Click(Sender: TObject);
    procedure Button8Click(Sender: TObject);
    procedure Button9Click(Sender: TObject);
    procedure Button10Click(Sender: TObject);
    procedure Button11Click(Sender: TObject);
    procedure Button12Click(Sender: TObject);
    procedure Button13Click(Sender: TObject);
    procedure Timer1Timer(Sender: TObject);
    procedure Button14Click(Sender: TObject);
    procedure CheckBox1Click(Sender: TObject);
  private
    procedure ShowHwndAndClassName(CrPos: TPoint);
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form1: TForm1;

implementation

uses Unit2
   , Unit3
   , ZTO.Wizards.FormTemplates.Dialog
   , ZTO.Win32.Rtl.Common.Classes
   , ZTO.Win32.Rtl.Sys.Utilities;

{$R *.dfm}

procedure TForm1.ShowHwndAndClassName(CrPos: TPoint);
var
  hWnd: THandle;
  aName: array [0..255] of Char;
begin
  hWnd := WindowFromPoint(CrPos);
  Label1.Caption := 'Handle :  ' + IntToStr(hWnd);
  if Boolean(GetClassName(hWnd, aName, 256)) then
    Label2.Caption := 'ClassName :  ' + string(aName)
  else
    Label2.Caption := 'ClassName :  not found';
end;

procedure TForm1.Timer1Timer(Sender: TObject);
var
  rPos: TPoint;
begin
  if Boolean(GetCursorPos(rPos)) then ShowHwndAndClassName(rPos);
end;

procedure TForm1.Button10Click(Sender: TObject);
begin
  ShowStartButtom(not IsStartButtomVisible);
end;

procedure TForm1.Button11Click(Sender: TObject);
begin
  EnableStartButtom(not IsStartButtomEnabled);
end;

procedure TForm1.Button12Click(Sender: TObject);
begin
  ShowMessage(BoolToStr(IsStartButtomVisible,True))
end;

procedure TForm1.Button13Click(Sender: TObject);
begin
  ShowMessage(BoolToStr(IsStartButtomEnabled,True))
end;

procedure TForm1.Button14Click(Sender: TObject);
var
  i: integer;
  x: Pointer;
begin
//  ShowWindow(65658,SW_hide);
for i := 0 to 4096 do
  try
    x := Pointer(Integer(@ZTODBGrid1) + i);
    Memo1.Lines.Add(TObject(x^).Classname + ' em ' + inttostr(i));
  except
    //Memo1.Lines.Add('Nada em ' + inttostr(i));
  end;
end;

procedure TForm1.Button1Click(Sender: TObject);
var
  x: TZTODialog2;
begin
  x := nil;
  TZTODialog.CreateDialog(Self,x,TZTODialog2,smShow,[],'',[],[],sbNone,dtNone);
end;

procedure TForm1.Button2Click(Sender: TObject);
begin
  ShowDesktop(not IsDesktopVisible);
end;

procedure TForm1.Button3Click(Sender: TObject);
begin
  EnableDesktop(not IsDesktopEnabled);
end;

procedure TForm1.Button4Click(Sender: TObject);
begin
  ShowMessage(BoolToStr(IsDesktopVisible,True))
end;

procedure TForm1.Button5Click(Sender: TObject);
begin
  ShowMessage(BoolToStr(IsDesktopEnabled,True))
end;

procedure TForm1.Button6Click(Sender: TObject);
begin
  ShowTaskBar(not IsTaskBarVisible);
end;

procedure TForm1.Button7Click(Sender: TObject);
begin
  EnableTaskBar(not IsTaskBarEnabled);
end;

procedure TForm1.Button8Click(Sender: TObject);
begin
  ShowMessage(BoolToStr(IsTaskBarVisible,True))
end;

procedure TForm1.Button9Click(Sender: TObject);
begin
  ShowMessage(BoolToStr(IsTaskBarEnabled,True))
end;

procedure TForm1.CheckBox1Click(Sender: TObject);
begin
  ShowMessage(Inttostr(GetSystemMetrics(SM_CXMENUCHECK)));
end;

end.
