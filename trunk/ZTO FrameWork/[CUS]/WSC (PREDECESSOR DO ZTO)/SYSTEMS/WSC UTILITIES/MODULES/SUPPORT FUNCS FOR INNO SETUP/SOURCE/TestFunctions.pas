unit TestFunctions;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls;

type
  TForm1 = class(TForm)
    Button1: TButton;
    Button2: TButton;
    ComboBox1: TComboBox;
    Button3: TButton;
    procedure Button3Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure Button1Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form1: TForm1;

function CompareVersions4(VersionA, VersionB: ShortString): ShortInt; stdcall; external '.\Release\SupportFuncs.dll';
function CompareVersions3(VersionA, VersionB: ShortString): ShortInt; stdcall; external '.\Release\SupportFuncs.dll';
procedure ChangeRootPassword(OldPass, NewPass: PChar); stdcall; external '.\Release\SupportFuncs.dll';
function GetMySQLProtocolNames: PChar; stdcall; external '.\Release\SupportFuncs.dll';

implementation

{$R *.dfm}

procedure TForm1.Button1Click(Sender: TObject);
begin
	CompareVersions3('2.2.3','1.2.3');
end;

procedure TForm1.Button2Click(Sender: TObject);
begin
	ChangeRootPassword('','xxx');
end;

procedure TForm1.Button3Click(Sender: TObject);
var
    x: String;
begin
	x := GetMySQLProtocolNames;
end;

end.
