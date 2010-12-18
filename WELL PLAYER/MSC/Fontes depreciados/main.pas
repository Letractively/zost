unit main;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms,
  Dialogs, Menus, DSPack, StdCtrls, ComCtrls, dsutil, Buttons, ToolWin,
  ImgList, ExtCtrls;

const
 REFERENCE_TIME = 100;

type
  TFormPlayWin = class(TForm)
    FilterGraph: TFilterGraph;
    MainMenu: TMainMenu;
    OpenDialog: TOpenDialog;
    FileMenu: TMenuItem;
    OpenMenu: TMenuItem;
    OpenURLMenu: TMenuItem;
    ExitMenu: TMenuItem;
    TrackBar: TDSTrackBar;
    ImageList: TImageList;
    StatusBar: TStatusBar;
    ToolBar: TToolBar;
    btPlay: TToolButton;
    btPause: TToolButton;
    btStop: TToolButton;
    ToolButton1: TToolButton;
    SoundLevel: TTrackBar;
    btFullScreen: TToolButton;
    PopupMenu: TPopupMenu;
    Play1: TMenuItem;
    Pause1: TMenuItem;
    Stop1: TMenuItem;
    FullScreen1: TMenuItem;
    log: TMemo;
    ToolButton2: TToolButton;
    Timer1: TTimer;
    VideoWindow: TVideoWindow;
    procedure OpenMenuClick(Sender: TObject);
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
    procedure btPlayClick(Sender: TObject);
    procedure btPauseClick(Sender: TObject);
    procedure btStopClick(Sender: TObject);
    procedure TrackBarTimer(sender: TObject; CurrentPos,
      StopPos: Cardinal);
    procedure SoundLevelChange(Sender: TObject);
    procedure ExitMenuClick(Sender: TObject);
    procedure btFullScreenClick(Sender: TObject);
    procedure FilterGraphDSEvent(sender: TComponent; Event, Param1,
      Param2: Integer);
    procedure FormShow(Sender: TObject);


  private
    { Déclarations privées }


  public
    { Déclarations publiques }
     FNomeArquivo : string;
     FListaParametro : TStringList;
     PlayFiles : array[0..10,0..1] of String;
     iMJ, iAux : integer;

     FArquivosDeMidia_     : TStringList;
     FDiretorioDaAplicacao_,
     FDiretorioCache_        : ShortString;


     procedure f_LerArquivoIni;
     procedure CarregarItemConfiguracao ;
     procedure ExecutarPlay;
     procedure CarregaLista(ListaPlay:TStringList;
                            DiretorioDaAplicacao: ShortString;
                            DiretorioCache: ShortString);
  end;

var
  FormPlayWin: TFormPlayWin;

implementation
uses DirectShow9 ;

{$R *.dfm}

procedure TFormPlayWin.OpenMenuClick(Sender: TObject);
begin
  {if OpenDialog.Execute then
  begin
    if not FilterGraph.Active then
      FilterGraph.Active := true;
    FilterGraph.ClearGraph;
    FilterGraph.RenderFile(OpenDialog.FileName);
    VideoWindow.PopupMenu := PopupMenu;
    SoundLevel.Position := FilterGraph.Volume;
    FilterGraph.Play;
  end;
  }
end;

procedure TFormPlayWin.FormCloseQuery(Sender: TObject;
  var CanClose: Boolean);
begin
  FilterGraph.ClearGraph;
end;

procedure TFormPlayWin.btPlayClick(Sender: TObject);
begin
  if not FilterGraph.Active then
   OpenMenuClick(nil)
  else
   FilterGraph.play;
end;

procedure TFormPlayWin.btPauseClick(Sender: TObject);
begin
  FilterGraph.Pause;
end;

procedure TFormPlayWin.btStopClick(Sender: TObject);
begin
  FilterGraph.Stop;
end;

procedure TFormPlayWin.TrackBarTimer(sender: TObject; CurrentPos,
  StopPos: Cardinal);
begin
  StatusBar.SimpleText := format('Position: %s Duration: %s',
    [TimeToStr(CurrentPos / MiliSecPerDay), TimeToStr(StopPos / MiliSecPerDay)]);

  if CurrentPos = StopPos then
  //  ExecutarPlay;
end;

procedure TFormPlayWin.SoundLevelChange(Sender: TObject);
begin
  FilterGraph.Volume := SoundLevel.Position;
end;

procedure TFormPlayWin.ExitMenuClick(Sender: TObject);
begin
  FormPlayWin.Close;
end;

procedure TFormPlayWin.btFullScreenClick(Sender: TObject);
begin
  VideoWindow.FullScreen := not VideoWindow.FullScreen;
  btFullScreen.Down := VideoWindow.FullScreen;
end;

procedure TFormPlayWin.FilterGraphDSEvent(sender: TComponent; Event,
  Param1, Param2: Integer);
begin
  log.Lines.Add(GetEventCodeDef(event))
end;

procedure TFormPlayWin.FormShow(Sender: TObject);
begin
  FNomeArquivo        := FDiretorioDaAplicacao_;
  IMJ := 0;
  f_LerArquivoIni;
end;


procedure TFormPlayWin.f_LerArquivoIni;
begin

  if FListaParametro = nil then
    FListaParametro := TStringList.Create;

  try

    FListaParametro := FArquivosDeMidia_;

    CarregarItemConfiguracao;
  except
    on e:exception do
    begin
      MessageDlg('Ocorreu um erro na carga da configuração.' + #13 + #13 +
                 'O aplicativo não será executado até que ' + #13 +
                 'o erro seja corrigido.' + #13 + #13 +
                 e.message, mtError, [mbOK], 0);
      Application.Terminate;
    end;
  end;

{  FListaParametro.Clear;
  FListaParametro.Free;
  FListaParametro := nil;
 }
  ExecutarPlay;

end;

Procedure TFormPlayWin.CarregarItemConfiguracao;
var
  i, iPos1, iPos2 : integer;
  sAux, sAux1 : string;
begin
  iAux := FListaParametro.Count;

  for i := 0 to FListaParametro.Count - 1 do
  begin
    // localizar o parametro
    sAux := FListaParametro[i];
    iPos1 := Pos('=',sAux);
    iPos2 := Pos('|',sAux);

    // Ex: ARQ000=\ARQUIVO1.FLV|0
    sAux1 := Trim(Copy(sAux,iPos1+1,iPos2-1));                  // Caminho do arquivo

    PlayFiles[i,0] := copy(sAux1,1,pos('|',saux1)-1);
    PlayFiles[i,1] := copy(sAux1,pos('|',saux1)+1,length(saux1)-1);       // Tempo do arquivo, se  for 0 (zero) é o tempo dele mesmo, sen~eo, será o tempo informado
  end;

end;

procedure TFormPlayWin.ExecutarPlay;
var sNomePlay : String;
begin

    if not FilterGraph.Active then
      FilterGraph.Active := True;

    FilterGraph.ClearGraph;

    if  iMJ = iAux then
    begin
      iMJ := 0;
      //FListaParametro.Free;
      f_LerArquivoIni;
    end;

    sNomePlay := PlayFiles[iMJ,0];

    if sNomePlay = '' then Exit;

    FilterGraph.RenderFile(FDiretorioCache_+sNomePlay);
    iMJ := iMJ + 1;

   VideoWindow.PopupMenu := PopupMenu;
   SoundLevel.Position := FilterGraph.Volume;
   FilterGraph.Play;
end;

procedure TFormPlayWin.CarregaLista(ListaPlay: TStringList;
  DiretorioDaAplicacao, DiretorioCache: ShortString);
begin
end;

end.

