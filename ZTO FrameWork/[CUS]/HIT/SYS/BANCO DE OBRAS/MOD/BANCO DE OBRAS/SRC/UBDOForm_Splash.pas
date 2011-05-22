unit UBDOForm_Splash;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ComCtrls, ExtCtrls;

type
    TBDOForm_Splash = class(TForm)
        LabelVersion: TLabel;
        Image1: TImage;
        Label1: TLabel;
        procedure LabelVersionDblClick(Sender: TObject);
        procedure Image1Click(Sender: TObject);
        procedure FormClose(Sender: TObject; var Action: TCloseAction);
        procedure FormShow(Sender: TObject);
        procedure FormCreate(Sender: TObject);
    private
       { Private declarations }
       FCanClose: Boolean;
       procedure CloseHForm(Sender: TObject);
       procedure ShowHForm(Sender: TObject);
       procedure DoCloseDelayed(var Msg: TMessage);
    public
        { Public declarations }
        procedure CloseDelayed(const aSeconds: Byte);
        property CanClose: Boolean write FCanClose;
    end;

var
	HForm1, HForm2: TForm;

implementation

uses
    UXXXTypesConstantsAndClasses;

const
    IDT_DELAYEDCLOSE = 1;

{$R *.dfm}

procedure TBDOForm_Splash.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  	AnimateWindow(Handle,200,AW_CENTER or AW_HIDE);
	Action := caFree;
end;

procedure TBDOForm_Splash.FormCreate(Sender: TObject);
begin
    FCanClose := True;
end;

procedure TBDOForm_Splash.FormShow(Sender: TObject);
begin
    LabelVersion.Caption := TFileInformation.GetInfo(Application.ExeName,'FULLVERSION').AsAnsiString;
end;

procedure TBDOForm_Splash.Image1Click(Sender: TObject);
begin
    if FCanClose then
    	Close;
end;

procedure TBDOForm_Splash.CloseDelayed(const aSeconds: Byte);
begin
    SetTimer(Handle,IDT_DELAYEDCLOSE,aSeconds * 1000,Classes.MakeObjectInstance(DoCloseDelayed));
end;

procedure TBDOForm_Splash.DoCloseDelayed;
begin
    KillTimer(Handle,TWMTimer(Msg).TimerID);
    Close;
end;

procedure TBDOForm_Splash.CloseHForm(Sender: TObject);
begin
    HForm2.Close;
	HForm1.Close;
end;

procedure TBDOForm_Splash.ShowHForm(Sender: TObject);
const
	Frase = 'Aqui vai um nome para ser lembrado'#13#10#13#10'Carlos Barreto Feitoza Filho'#13#10#13#10'Delphi Developer';
var
  Info1, Info2, Info3, Info4, Info5: TLabel;
begin
  Info2 := TLabel.Create(HForm2);
  with Info2 do
  begin
    Parent := HForm2;
    OnClick := CloseHForm;
    AutoSize := False;
    Alignment := taCenter;
    Layout := tlCenter;
    Transparent := True;
    Font.Color := clRed;
    Font.Size := 40;
    Caption := Frase;
    Width := HForm2.Width;
    Height := HForm2.Height;
    Top := -2;
    Left := 2;
  end;

  Info3 := TLabel.Create(HForm2);
  with Info3 do
  begin
    Parent := HForm2;
    OnClick := CloseHForm;
    AutoSize := False;
    Alignment := taCenter;
    Layout := tlCenter;
    Transparent := True;
    Font.Color := clRed;
    Font.Size := 40;
    Caption := Frase;
    Width := HForm2.Width;
    Height := HForm2.Height;
    Top := 2;
    Left := 2;
  end;

  Info4 := TLabel.Create(HForm2);
  with Info4 do
  begin
    Parent := HForm2;
    OnClick := CloseHForm;
    AutoSize := False;
    Alignment := taCenter;
    Layout := tlCenter;
    Transparent := True;
    Font.Color := clRed;
    Font.Size := 40;
    Caption := Frase;
    Width := HForm2.Width;
    Height := HForm2.Height;
    Top := 2;
    Left := -2;
  end;

  Info5 := TLabel.Create(HForm2);
  with Info5 do
  begin
    Parent := HForm2;
    OnClick := CloseHForm;
    AutoSize := False;
    Alignment := taCenter;
    Layout := tlCenter;
    Transparent := True;
    Font.Color := clRed;
    Font.Size := 40;
    Caption := Frase;
    Width := HForm2.Width;
    Height := HForm2.Height;
    Top := -2;
    Left := -2;
  end;

  Info1 := TLabel.Create(HForm2);
  with Info1 do
  begin
    Parent := HForm2;
    OnClick := CloseHForm;
    AutoSize := False;
    Alignment := taCenter;
    Layout := tlCenter;
    Transparent := True;
    Font.Color := clYellow;
    Font.Size := 40;
    Caption := Frase;
    Width := HForm2.Width;
    Height := HForm2.Height;
    Top := 0;
    Left := 0;
  end;
end;

procedure TBDOForm_Splash.LabelVersionDblClick(Sender: TObject);
begin
  if not (GetAsyncKeyState(VK_LCONTROL) = -32767)  then
  	Exit;
  try
    HForm1 := TForm.Create(Self);
    with HForm1 do
    begin
      WindowState := wsMaximized;
      FormStyle := fsStayOnTop;
      BorderIcons := [];
      BorderStyle := bsNone;
      Color := clBlack;
      AlphaBlend := True;
      AlphaBlendValue := 128;
      Show;
    end;

    HForm2 := TForm.Create(Self);
    with HForm2 do
    begin
      WindowState := wsMaximized;
      FormStyle := fsStayOnTop;
      BorderIcons := [];
      BorderStyle := bsNone;
      Color := $000000FE;
      TransparentColorValue := $000000FE;
      TransparentColor := True;
      OnShow := ShowHForm;
      ShowModal;
    end;

  finally
    if Assigned(HForm2) then
      HForm2.Free;

    if Assigned(HForm1) then
      HForm1.Free;
  end;
end;

end.
