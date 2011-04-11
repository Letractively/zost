{ TODO -oCARLOS FEITOZA -cCORRE플O : POR QUE A TRANSFERENCIA P핾A EM ALGUNS ARQUIVOS ALEATORIOAMENTE? }
{ TODO -oCARLOS FEITOZA -cCORRE플O : AO FECHAR A APLICA플O ACREDITO QUE A THREAD DE VERIFICA플O TENHA DE SER PARADA, POR EST� DANDO ERRO NISSO }
unit UForm_Principal;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ComCtrls, Buttons, Gauges, ExtCtrls, Menus;

type
  TForm_Principal = class(TForm)
    RichEdit_Log: TRichEdit;
    StatusBar1: TStatusBar;
    Panel_LayerInferior: TPanel;
    Panel_LayerBotoes: TPanel;
    BitBtn_Configurar: TBitBtn;
    BitBtn_SalvarLog: TBitBtn;
    Button_ChecarAgora: TButton;
    Button_EsconderNaBarraDeTarefas: TButton;
    Panel_ModoMini: TPanel;
    Label_ModoMini: TLabel;
    Panel_DoArquivo: TPanel;
    ProgressBar_Arquivo: TProgressBar;
    Label_ProgressDoArquivo: TLabel;
    Panel_Geral: TPanel;
    ProgressBar_Geral: TProgressBar;
    Label_ProgressGeral: TLabel;
    Label1: TLabel;
    Label2: TLabel;
    StatusBar2: TStatusBar;
    procedure BitBtn_ConfigurarClick(Sender: TObject);
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
    procedure FormShow(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure Label1Click(Sender: TObject);
  private
    { Private declarations }
    procedure DelayedAction;
    procedure DoDelayedAction(var Msg: TMessage);
    procedure ModoMini(aLigado: Boolean);
  public
    { Public declarations }
  end;

var
  Form_Principal: TForm_Principal;

implementation

uses UDataModule_Principal, UForm_Configuracoes, UGlobalFunctions;

{$R *.dfm}

procedure TForm_Principal.BitBtn_ConfigurarClick(Sender: TObject);
begin
  with TForm_Configuracoes.Create(Self) do
    try
      ShowModal;
    finally
      Free;
    end;
end;

procedure TForm_Principal.DelayedAction;
begin
  SetTimer(Handle,1,64,Classes.MakeObjectInstance(DoDelayedAction));
end;

procedure TForm_Principal.DoDelayedAction(var Msg: TMessage);
begin
  KillTimer(Handle,TWMTimer(Msg).TimerID);

  if ParamIsPresent('/updateonstart') then
    DataModule_Principal.RealizarAtualizacao;

  DataModule_Principal.AutoChecagem.Resume;

  DataModule_Principal.Action_EsconderNaBarraDeTarefas.Execute;
  ModoMini(False);
end;

procedure TForm_Principal.ModoMini(aLigado: Boolean);
begin
  if aLigado then
  begin
    AutoSize := True;
    StatusBar1.Hide;
    StatusBar2.Hide;
    Panel_LayerBotoes.Hide;
    RichEdit_Log.Hide;
    Panel_ModoMini.Show;
    Panel_LayerInferior.Align := alNone;
    Panel_LayerInferior.Width := 600;
    Position := poDesktopCenter;
    Position := poScreenCenter;
  end
  else
  begin
    AutoSize := False;
    StatusBar1.Show;
    StatusBar2.Show;
    Panel_LayerBotoes.Show;
    RichEdit_Log.Show;
    Width := 820;
    Height := 324;
    Panel_ModoMini.Hide;
    Panel_LayerInferior.Align := alBottom;
    Position := poDesktopCenter;
    Position := poScreenCenter;
  end;
end;

procedure TForm_Principal.FormCloseQuery(Sender: TObject; var CanClose: Boolean);
begin
  CanClose := DataModule_Principal.PodeFechar(1);
end;

procedure TForm_Principal.FormCreate(Sender: TObject);
begin
  if ParamIsPresent('/updateonstart') and ParamIsPresent('/modomini') then
    ModoMini(True);
end;

procedure TForm_Principal.FormShow(Sender: TObject);
begin
  DelayedAction;
  OnShow := nil;
end;

procedure TForm_Principal.Label1Click(Sender: TObject);
begin
  showmessage(inttostr(ProgressBar_Arquivo.position))


end;

end.
