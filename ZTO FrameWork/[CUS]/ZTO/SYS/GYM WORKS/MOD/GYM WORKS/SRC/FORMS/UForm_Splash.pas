unit UForm_Splash;

interface

uses Windows, UBalloonToolTip, Controls, ComCtrls, StdCtrls, pngimage, Classes,
  ExtCtrls, Forms, Messages;

type
  TForm_Splash = class(TForm)
    Image_Splash: TImage;
    Label_Versao: TLabel;
    Label_Compilacao: TLabel;
    Label_StatusInicial: TLabel;
    ProgressBar_Instrucoes: TProgressBar;
    ProgressBar_Blocos: TProgressBar;
    ProgressBar_Decompress: TProgressBar;
    BalloonToolTip: TBalloonToolTip;
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
    procedure FormShow(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormActivate(Sender: TObject);
  private
    { Private declarations }
    procedure DoDelayedHide(var Msg: TMessage);
//    procedure DoDelayedClose(var Msg: TMessage);
  protected
  public
    { Public declarations }
    procedure DelayedHide(const aSeconds: Byte);
//    procedure DelayedClose(const aSeconds: Byte);
    procedure CloseForm(aConfirm: Boolean = True);
  end;

var
  Form_Splash: TForm_Splash;

implementation

uses ZTO.Win32.Rtl.Common.FileUtils
   , ZTO.Win32.Rtl.Sys.Types
   , UDataModule_Principal;

{$R *.dfm}

const
  IDT_DELAYEDHIDE = 1;
  IDT_DELAYEDCLOSE = 2;

{ TForm_Splash }

procedure TForm_Splash.CloseForm(aConfirm: Boolean = True);
begin
  if not aConfirm then
    OnCloseQuery := nil;

  Close;
end;

procedure TForm_Splash.DelayedHide(const aSeconds: Byte);
begin
  SetTimer(Handle,IDT_DELAYEDHIDE,aSeconds * 1000,Classes.MakeObjectInstance(DoDelayedHide));
end;

//procedure TForm_Splash.DelayedClose(const aSeconds: Byte);
//begin
//  SetTimer(Handle,IDT_DELAYEDCLOSE,aSeconds * 1000,Classes.MakeObjectInstance(DoDelayedClose));
//end;

//procedure TForm_Splash.DoDelayedClose(var Msg: TMessage);
//begin
//  KillTimer(Handle,TWMTimer(Msg).TimerID);
//  CloseForm(False);
//end;

procedure TForm_Splash.DoDelayedHide(var Msg: TMessage);
begin
  KillTimer(Handle,TWMTimer(Msg).TimerID);
  Hide;
  DataModule_Principal.TrayIcon_Splash.Visible := True;
  DataModule_Principal.TrayIcon_Splash.ShowBalloonHint;
end;

procedure TForm_Splash.FormActivate(Sender: TObject);
begin
  { Para não mostrar o botão na barra de tarefas }
  ShowWindow(Application.Handle, SW_HIDE);
end;

procedure TForm_Splash.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  Action := caFree;
end;

procedure TForm_Splash.FormCloseQuery(Sender: TObject; var CanClose: Boolean);
begin
  CanClose := MessageBox(Handle,'Tem certeza de que quer fechar o Gym Works?','Por favor confirme',MB_ICONQUESTION or MB_YESNO or MB_DEFBUTTON2) = IDYES;
end;

procedure TForm_Splash.FormShow(Sender: TObject);
begin
  Label_Versao.Caption := FileInformation(Application.ExeName,fiMajorVersion).AsString + '.' +
                          FileInformation(Application.ExeName,fiMinorVersion).AsString + '.' +
                          FileInformation(Application.ExeName,fiRelease).AsString;

  Label_Compilacao.Caption := 'Compilação ' + FileInformation(Application.ExeName,fiBuild).AsString;

  { Para não mostrar o botão na barra de tarefas }
  ShowWindow(Application.Handle, SW_HIDE);
end;

end.
