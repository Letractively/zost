unit UForm_Player;

interface

uses
  SysUtils, Classes, Controls, Forms, UCFSHChangeNotify, StdCtrls, ShellAPI,
  Messages, Buttons, Menus, DSPack, ImgList, ComCtrls, Dialogs, ExtCtrls,
  UForm_Configuracao, directshow9, OleCtrls, JPEG,
  {$IFDEF VER150}
  DSUtil, ShockwaveFlashObjects_TLB
  {$ELSE}
  DSPackUtil, ShockwaveFlashObjects
  {$ENDIF};

const
  wm_IconMessage = wm_User;

type
  TFileInfo = record
    FileName: String;
    FileType: String;
    FileTime: Int64;//Word;
  end;

  TTipoDeReproducao = (tdrNenhuma, tdrTimer, tdrTempo, tdrPause);

  { Interposer para inserção de novas funcionalidades }
  TFilterGraph = class(DSPack.TFilterGraph)
  private
    function GetCurrentPosition: Integer;
  public
    property CurrentPosition: Integer read GetCurrentPosition;
  end;

  {$IFDEF VER150}
  TShockwaveFlash = class(ShockwaveFlashObjects_TLB.TShockwaveFlash)
  {$ELSE}
  TShockwaveFlash = class(ShockwaveFlashObjects.TShockwaveFlash)
  {$ENDIF}
  public
    procedure CreateWnd; override;
  end;

  TForm_Player = class(TForm)
    FilterGraph: TFilterGraph;
    VideoWindow_VID: TVideoWindow;
    Image_IMG: TImage;
    ShockwaveFlash_SWF: TShockwaveFlash;
    Timer_Estaticos: TTimer;
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure ExibirJanela1Click(Sender: TObject);
    procedure FecharJanela1Click(Sender: TObject);
    procedure Pause2Click(Sender: TObject);
    procedure Play2Click(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormShow(Sender: TObject);
    procedure ShockwaveFlash_SWFProgress(ASender: TObject; percentDone: Integer);
    procedure VideoWindow_VIDMouseMove(Sender: TObject; Shift: TShiftState; X, Y: Integer);
    procedure Image_IMGMouseMove(Sender: TObject; Shift: TShiftState; X, Y: Integer);
    procedure Timer_EstaticosTimer(Sender: TObject);
    procedure FormResize(Sender: TObject);
  private
    { Private declarations }
    { Das configurações }
    FMonitorPrincipal: Boolean;
    FDiretorioMidia: String;
    FDiretorioLog: String;

    FTipoDeReproducao: TTipoDeReproducao;
    FTipoArq: String;
    FArquivo: String;
    FTimeOut: TTime;
    FTimePause: TTime;
    FTimeIn: TTime;
    FReproducaoTotal: Integer; { Em milisegundos }

    FNowPlaying: Word;

    FTempoFormatado: String;
    FArquivosDeMidia   : TStringList;

//    FTocando: Boolean;

//    procedure RecarregarScript;
    procedure IniciarReproducao(aIndex: Word);
    procedure ProximoPlay;
    procedure SalvarItemLog(aArquivo: String);
    procedure ExecutarSWF(aFileInformation: TFileInfo);
    procedure ExecutarIMG(aFileInformation: TFileInfo);
    procedure ExecutarVID(aFileInformation: TFileInfo);
//    procedure DesabilitaBarraWind;
//    procedure HabilitaBarraWin;
//    procedure RefreshVideoWindow;
    function FileInfo(aFileIndex: Word): TFileInfo;
    procedure CalcularReproducaoTotal;
//    procedure ListBoxConf;
  public
    { Public declarations }
    procedure IniciarPlaylist;
    procedure PausarPlaylist;
    procedure DespausarPlaylist;
    procedure FinalizarPlaylist;

    property MonitorPrincipal: Boolean read FMonitorPrincipal write FMonitorPrincipal;
    property DiretorioMidia: String read FDiretorioMidia write FDiretorioMidia;
    property DiretorioLog: String read FDiretorioLog write FDiretorioLog;
    property TempoFormatado: String read FTempoFormatado;
    property TipoArq: String read FTipoArq write FTipoArq;
    property Arquivo: String read FArquivo;
    property TimeOut: TTime read FTimeOut;
    property TimeIn: TTime read FTimeIn;
    property TipoDeReproducao: TTipoDeReproducao read FTipoDeReproducao;
    property ArquivosDeMidia: TStringList read FArquivosDeMidia write FArquivosDeMidia;
  end;

var
  Form_Player: TForm_Player;

implementation
                                                   
{$R *.dfm}

uses windows
   , IniFiles
   , UFuncoes, Math;

//const
//  DIRETORIO_CACHE = 'CACHE';
//  DIRETORIO_MIDIA = 'C:\SlideShow Script Monitor\bin\exe\Cache\Midia';
//  DIRETORIO_SCRIPT = 'C:\SlideShow Script Monitor\bin\exe\Cache';

function IsDirectoryEmpty(const aDirectory: string) : boolean;
var
  SearchRec: TSearchRec;
begin
  try
    Result := (FindFirst(aDirectory + '\*.*', faAnyFile, SearchRec) = 0) and (FindNext(SearchRec) = 0) and (FindNext(SearchRec) <> 0);
  finally
    FindClose(SearchRec.FindHandle) ;
  end;
end;

//procedure GetPaths(aDirectory: ShortString; aStrings: TStrings);
//{ ---------------------------------------------------------------------------- }
//function RelativePath: ShortString;
//begin
//    Result := ExtractRelativePath(IncludeTrailingPathDelimiter(aDirectory),IncludeTrailingPathDelimiter(GetCurrentDir))
////  ExtractShortPathName
//end;
//
//procedure SearchTree;
//var
//  SearchRec: TSearchRec;
//  DosError: integer;
//begin
//  DosError := FindFirst('*.*', 0, SearchRec);
//  while DosError = 0 do
//  begin
//    try
//      aStrings.Add(RelativePath + SearchRec.Name);
//    except
//      on Eoor: EOutOfResources do
//      begin
//        Eoor.Message := Eoor.Message + #13#10'A quantidade de arquivos localizados excede o limite de recursos do seu sistema. Favor limitar seu critério de busca escolhendo diretório(s) de nível mais interno';
//        raise;
//      end;
//    end;
//    DosError := FindNext(SearchRec);
//  end;
//
//  DosError := FindFirst('*.*', faDirectory, SearchRec);
//  while DosError = 0 do
//  begin
//    if ((SearchRec.attr and faDirectory = faDirectory) and (SearchRec.name <> '.') and (SearchRec.name <> '..')) then
//    begin
//      ChDir(SearchRec.Name);
//      SearchTree;
//      ChDir('..');
//      aStrings.Add(RelativePath + SearchRec.Name);
//    end;
//    DosError := FindNext(SearchRec);
//  end;
//end;
//{ ---------------------------------------------------------------------------- }
//begin
//	ChDir(aDirectory);
//	SearchTree;
//end;

procedure TForm_Player.FormCreate(Sender: TObject);
begin
  FTipoDeReproducao := tdrNenhuma;
  Form_Configuracao.ListBox_Playlist.Enabled := False;
  Form_Configuracao.RadioGroup_Monitor.Enabled := False;
  Form_Configuracao.BitBtn_RecarregarScript.Enabled := False;
  Form_Configuracao.BitBtn_RecriarScript.Enabled := False;
  Form_Configuracao.BitBtn_MoverAcima.Enabled := False;
  Form_Configuracao.BitBtn_MoverAbaixo.Enabled := False;
end;

procedure TForm_Player.FormDestroy(Sender: TObject);
begin
  ShowCursor(True);
  FilterGraph.Free;

  Form_Configuracao.ListBox_Playlist.Enabled := True;
  Form_Configuracao.RadioGroup_Monitor.Enabled := Screen.MonitorCount = 2;
  Form_Configuracao.BitBtn_RecarregarScript.Enabled := True;
  Form_Configuracao.BitBtn_RecriarScript.Enabled := True;
  Form_Configuracao.BitBtn_MoverAcima.Enabled := True;
  Form_Configuracao.BitBtn_MoverAbaixo.Enabled := True;
end;

//procedure TForm_Player.RecarregarScript;
//begin
//  { Executa os mesmos procedimentos já existentes no form de configurações }
//  Form_Configuracao.RecarregarScript;
//
//  Timer1.Enabled := False;
//  Timer2.Enabled := False;
//
//  FNowPlaying := 0;
//
//  IniciarReproducao(FNowPlaying);
//
//end;

//procedure TForm_Player.IconTray(var Msg: TMessage);
//var
//  Pt: TPoint;
//begin
//  if (Msg.lParam = wm_rbuttondown) then
//  begin
//    GetCursorPos (Pt);
//  end;
//  if msg.LParam = wm_lbuttondblclk then
//  begin
//    Self.show;
//  end;
//
//end;

procedure TForm_Player.ExibirJanela1Click(Sender: TObject);
begin
 Self.show;
end;

procedure TForm_Player.FecharJanela1Click(Sender: TObject);
begin
  Close;
end;

function TForm_Player.FileInfo(aFileIndex: Word): TFileInfo;
var
  Arquivo: String;
begin
  ZeroMemory(@Result,SizeOf(TFileInfo));

  if aFileIndex <= Pred(FArquivosDeMidia.Count) then
  begin
    Arquivo := FArquivosDeMidia.ValueFromIndex[aFileIndex];

    with Result do
    begin
      FileName := AnsiUpperCase(Copy(Arquivo,1,Pred(Pos('|',Arquivo))));
      FileTime := StrToInt(Copy(Arquivo,Succ(Pos('|',Arquivo)),Length(Arquivo)));
      FileType := AnsiUpperCase(StringReplace(ExtractFileExt(FileName),'.','',[]));
    end;
  end
  else
    raise Exception.Create('O índice "' + IntToStr(aFileIndex) + '" não existe na lista');
end;

procedure TForm_Player.IniciarReproducao(aIndex: Word);
var
  FileInformation: TFileInfo;
begin
  if not FilterGraph.Active then
    FilterGraph.Active := True;

  FileInformation := FileInfo(aIndex);

  { Esconde tudo aqui }
  Image_IMG.Visible          := False;
  ShockwaveFlash_SWF.Visible := False;
  VideoWindow_VID.Visible    := False;


  { Se o arquivo não existir, tenta o próximo }
  { O algorítmo de passar para o próximo deve sair desta funçao }
  { Esta função tem de chamar ela mesma quando o arquivo não existir }
  if FileExists(FDiretorioMidia + '\' + FileInformation.FileName) then
  begin
    FNowPlaying := aIndex;

    { Arquivos estáticos e SWF (não reproduzíveis) }
    if (FileInformation.FileType = 'SWF')
    or (FileInformation.FileType = 'JPG')
    or (FileInformation.FileType = 'BMP')
    or (FileInformation.FileType = 'ICO') then
    begin
      FilterGraph.Active := False;

      { Se for o caso especial SWF... }
      if FileInformation.FileType = 'SWF' then begin
        ExecutarSWF(FileInformation)
      end
      else
      begin
        ExecutarIMG(FileInformation);
      end;
    end
    { Arquivos dinâmicos (reproduzíveis) }
    else
      ExecutarVID(FileInformation);

    SalvarItemLog(FileInformation.FileName);
  end;
end;

procedure TForm_Player.IniciarPlaylist;
begin
  { Recarrega a lista interna de arquivos e atualiza a lista no form de
  configuração }
  Form_Configuracao.RecarregarScript;

  CalcularReproducaoTotal;

  { Caso não esteja no modo de reprodução, o inicia }
  if FTipoDeReproducao = tdrNenhuma then
    IniciarReproducao(0);
end;

procedure TForm_Player.PausarPlaylist;
begin
  { Arquivos estáticos e SWF (não reproduzíveis) }
  if (FTipoArq = 'SWF')
  or (FTipoArq = 'JPG')
  or (FTipoArq = 'BMP')
  or (FTipoArq = 'ICO') then
  begin
    FTipoDeReproducao := tdrPause;
    FTimePause := Now;

    { Se for o caso especial SWF... }
    if FTipoArq = 'SWF' then
      ShockwaveFlash_SWF.Stop;
  end
  { Arquivos dinâmicos (reproduzíveis) }
  else
  begin
    FTipoDeReproducao := tdrPause;
    FTimePause := Now;
    FilterGraph.Pause;
  end;
end;

procedure TForm_Player.DespausarPlaylist;
begin
  { Arquivos estáticos e SWF (não reproduzíveis) }
  if (FTipoArq = 'SWF')
  or (FTipoArq = 'JPG')
  or (FTipoArq = 'BMP')
  or (FTipoArq = 'ICO') then
  begin
    { Se for o caso especial SWF... }
    if FTipoArq = 'SWF' then
      ShockwaveFlash_SWF.Play;

    FTimeIn := FTimeIn + Now - FTimePause;
    FTimeOut := FTimeOut + Now - FTimePause;
    FTipoDeReproducao := tdrTimer;
  end
  { Arquivos dinâmicos (reproduzíveis) }
  else
  begin
    FilterGraph.Play;

    FTimeIn := FTimeIn + Now - FTimePause;
    FTimeOut := FTimeOut + Now - FTimePause;
    FTipoDeReproducao := tdrTempo;
  end;
end;

procedure TForm_Player.FinalizarPlaylist;
begin
  FTipoDeReproducao := tdrNenhuma;
  FilterGraph.Stop;
  FilterGraph.ClearGraph;
  ShockwaveFlash_SWF.Stop;

  Image_IMG.Visible          := False;
  ShockwaveFlash_SWF.Visible := False;
  VideoWindow_VID.Visible    := False;
end;

procedure TForm_Player.ProximoPlay;
begin
  FTipoDeReproducao := tdrNenhuma;
  FilterGraph.Stop;
  FilterGraph.ClearGraph;
  ShockwaveFlash_SWF.Stop;

  if Succ(FNowPlaying) > Pred(FArquivosDeMidia.Count) then
    IniciarReproducao(0)
  else
    IniciarReproducao(Succ(FNowPlaying));
end;

procedure TForm_Player.Pause2Click(Sender: TObject);
begin
  FilterGraph.Pause;
end;

procedure TForm_Player.Play2Click(Sender: TObject);
begin
  FilterGraph.Play;
end;

procedure TForm_Player.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  FilterGraph.ClearGraph;

  Action := caFree;
  Form_Player := nil;
//  HabilitarBarraDeTarefas;
end;

//procedure TForm_Player.ajustaform;
//Const
//  nTamOriginal = 640; // Será o 100% da escala
//Var
//  nEscala : Double; // Vai me dar o percentual de Transformação escalar
//  nPorcento : Integer; // Vai me dar em percentual inteiro o valor
//begin
//  With Form_Player do  begin
//    if nTamOriginal <> Screen.Width then begin
//      nEscala := ((Screen.Width-nTamOriginal)/nTamOriginal);
//      nPorcento := Round((nEscala*100) + 100);
//      Self.Width := Round(Self.Width * (nEscala+1));
//      Self.Height := Round(Self.Height * (nEscala+1));
//      Self.ScaleBy(nPorcento,100);
//    end;
//  end;
//end;

procedure TForm_Player.SalvarItemLog(aArquivo: String);
var
  sDirLog, Arqlog, slocal: string;
  local: TextFile;
begin
  if DirectoryExists(FDiretorioLog) then
  begin
    Arqlog := 'ScripLog_' + (FormatDateTime('ddmmyyyy', now));
    sDirLog := FDiretorioLog;
    sLocal   := sDirLog + '\'+Arqlog+'.txt' ;

    AssignFile(Local, slocal);

    if not FileExists(sLocal) then
    begin
      Rewrite(Local, sLocal);
      Append(Local); //Cria o arquivo
      WriteLn(Local, (FormatDateTime('dd-mm-yyyy hh:mm:ss', now))+' - '+aArquivo );
    end
    else begin
      Append(Local); //Cria o arquivo
      WriteLn(Local, (FormatDateTime('dd-mm-yyyy hh:mm:ss', now))+' - '+aArquivo );
    end;

    CloseFile(Local);
  end;

end;

procedure TForm_Player.ExecutarSWF(aFileInformation: TFileInfo);
begin
  if not FileExists(FDiretorioMidia + '\' + aFileInformation.FileName) then
    ProximoPlay
  else
  begin
    FTipoArq := AnsiUpperCase(aFileInformation.FileType);
    FArquivo := AnsiUpperCase(aFileInformation.FileName);
    FTimeIn  := Now;
    FTimeOut := FTimeIn + aFileInformation.FileTime / 86400;

    ShockwaveFlash_SWF.Base  := FDiretorioMidia + '\' + aFileInformation.FileName;
    ShockwaveFlash_SWF.Movie := FDiretorioMidia + '\' + aFileInformation.FileName;
    ShockwaveFlash_SWF.Stop;
    ShockwaveFlash_SWF.Rewind;
    ShockwaveFlash_SWF.Show;
    ShockwaveFlash_SWF.Play;

    FTipoDeReproducao := tdrTimer;

    Form_Configuracao.ListBox_Playlist.ItemIndex := FNowPlaying;
  end;
end;

procedure TForm_Player.ExecutarIMG(aFileInformation: TFileInfo);
begin
  if not FileExists(FDiretorioMidia + '\' + aFileInformation.FileName) then
    ProximoPlay
  else
  begin
    FTipoArq := AnsiUpperCase(aFileInformation.FileType);
    FArquivo := AnsiUpperCase(aFileInformation.FileName);
    FTimeIn  := Now;
    FTimeOut := FTimeIn + aFileInformation.FileTime / 86400;

    Image_IMG.Picture.LoadFromFile(FDiretorioMidia + '\' + aFileInformation.FileName);
    Image_IMG.Show;

    FTipoDeReproducao := tdrTimer;

    Form_Configuracao.ListBox_Playlist.ItemIndex := FNowPlaying;
  end;
end;

procedure TForm_Player.ExecutarVID(aFileInformation: TFileInfo);
begin
  if not FileExists(FDiretorioMidia + '\' + aFileInformation.FileName) then
    ProximoPlay
  else
  begin
    FTipoArq := AnsiUpperCase(aFileInformation.FileType);
    FArquivo := AnsiUpperCase(aFileInformation.FileName);
    FTimeIn  := Now;
    FTimeOut := 0; { Não será usado }

    FilterGraph.Active := False;
    FilterGraph.ClearGraph;
    FilterGraph.Active := True;
    
    FilterGraph.RenderFile(FDiretorioMidia + '\' + aFileInformation.FileName);
    VideoWindow_VID.Show;

    FilterGraph.Play;

    FTipoDeReproducao := tdrTempo;

    Form_Configuracao.ListBox_Playlist.ItemIndex := FNowPlaying;
  end;
end;

//procedure TForm_Player.DesabilitaBarraWind;
//var
//  wndHandle : THandle;
//  wndClass : array[0..50] of Char;
//begin
//  StrPCopy(@wndClass[0], 'Shell_TrayWnd');
//  wndHandle:= FindWindow(@wndClass[0], nil);
//  ShowWindow(wndHandle, SW_HIDE); // This hides the taskbar
//end;

//procedure TForm_Player.HabilitaBarraWin;
//var
//  wndHandle : THandle;
//  wndClass : array[0..50] of Char;
//begin
//  StrPCopy(@wndClass[0], 'Shell_TrayWnd');
//  wndHandle:= FindWindow(@wndClass[0], nil);
//  ShowWindow(wndHandle, SW_RESTORE); // This restores the taskbar
//end;

procedure TForm_Player.FormShow(Sender: TObject);
begin
  if not FMonitorPrincipal then
    if Screen.MonitorCount > 1 then
      Left := Screen.Monitors[1].Left;

  IniciarPlaylist;

//  DesabilitaBarraWind;
end;

procedure TForm_Player.ShockwaveFlash_SWFProgress(ASender: TObject; percentDone: Integer);
begin
//  ShowCursor(False);
end;

procedure TForm_Player.VideoWindow_VIDMouseMove(Sender: TObject; Shift: TShiftState; X, Y: Integer);
begin
//  ShowCursor(False);
end;

procedure TForm_Player.Image_IMGMouseMove(Sender: TObject; Shift: TShiftState; X, Y: Integer);
begin
//  ShowCursor(False);
end;

//procedure TForm_Player.RefreshVideoWindow;
//begin
//
//end;

procedure TForm_Player.Timer_EstaticosTimer(Sender: TObject);
begin
  case FTipoDeReproducao of
    tdrTimer: begin
      FTempoFormatado := Format('%s / %s (%s)',[TimeToStr(FTimeIn - Now), TimeToStr(FTimeIn - FTimeOut),TimeToStr(FReproducaoTotal / 1000 / 86400)]);

      if Now >= FTimeOut then
        ProximoPlay;
    end;
    tdrTempo: begin
      FTempoFormatado := Format('%s / %s (%s)',[TimeToStr(FTimeIn - Now), TimeToStr(FTimeIn - (FTimeIn + FilterGraph.Duration / 1000 / 86400)),TimeToStr(FReproducaoTotal / 1000 / 86400)]);

      if FilterGraph.CurrentPosition >= FilterGraph.Duration then
        ProximoPlay;
    end;
  end;
end;

{ TFilterGraph }

function TFilterGraph.GetCurrentPosition: Integer;
var
  MediaSeeking: IMediaSeeking;
  RefTime: Int64;
begin
  if Succeeded(QueryInterface(IMediaSeeking, MediaSeeking)) then
  begin
    MediaSeeking.GetCurrentPosition(RefTime);
    Result := RefTimeToMiliSec(RefTime);
    MediaSeeking := nil;
  end
  else
    Result := 0;
end;

procedure TForm_Player.FormResize(Sender: TObject);
begin
  ShockwaveFlash_SWF.CreateWnd;
end;

procedure TForm_Player.CalcularReproducaoTotal;
var
  i: Word;
  FileInformation: TFileInfo;
begin
  FReproducaoTotal := 0;

  for i := 0 to Pred(FArquivosDeMidia.Count) do
  begin
    FileInformation := FileInfo(i);

    if FileExists(FDiretorioMidia + '\' + FileInformation.FileName) then
    begin
      { Arquivos estáticos e SWF (não reproduzíveis) }
      if (FileInformation.FileType = 'SWF')
      or (FileInformation.FileType = 'JPG')
      or (FileInformation.FileType = 'BMP')
      or (FileInformation.FileType = 'ICO') then
        Inc(FReproducaoTotal,FileInformation.FileTime * 1000)
      { Arquivos dinâmicos (reproduzíveis) }
      else
      begin
        FilterGraph.Active := True;
        FilterGraph.RenderFile(FDiretorioMidia + '\' + FileInformation.FileName);
        Inc(FReproducaoTotal,FilterGraph.Duration);
        FilterGraph.ClearGraph;
        FilterGraph.Active := False;
      end;
    end;
  end;
end;

{ TShockwaveFlash }

procedure TShockwaveFlash.CreateWnd;
begin
  inherited;
end;

end.