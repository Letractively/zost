unit UForm_Player;

interface

uses
  SysUtils, Classes, Controls, Forms,
  UCFSHChangeNotify, StdCtrls,
  ShellAPI,  Messages, Buttons, Menus, DSPack, ImgList, ComCtrls, Dialogs,
  ExtCtrls, UForm_Configuracao, directshow9, OleCtrls,JPEG,
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

  TForm_Player = class(TForm)
    CFSHChangeNotifier_Principal: TCFSHChangeNotifier;
    BitBtn1: TBitBtn;
    FilterGraph: TFilterGraph;
    OpenDialog: TOpenDialog;
    VideoWindow_VID: TVideoWindow;
    Timer1: TTimer;
    StatusBar: TStatusBar;
    TrackBar: TDSTrackBar;
    Timer2: TTimer;
    Image_IMG: TImage;
    ShockwaveFlash_SWF: TShockwaveFlash;
    procedure FormCreate(Sender: TObject);
    procedure CFSHChangeNotifier_PrincipalChangeSize;
    procedure CFSHChangeNotifier_PrincipalChangeAttributes;
    procedure CFSHChangeNotifier_PrincipalChangeDirName;
    procedure CFSHChangeNotifier_PrincipalChangeFileName;
    procedure CFSHChangeNotifier_PrincipalChangeLastWrite;
    procedure CFSHChangeNotifier_PrincipalChangeSecurity;
    procedure FormDestroy(Sender: TObject);
    procedure BitBtn1Click(Sender: TObject);
    procedure ExibirJanela1Click(Sender: TObject);
    procedure FecharJanela1Click(Sender: TObject);
    procedure TrackBarTimer(sender: TObject; CurrentPos, StopPos: Cardinal);
    procedure Pause2Click(Sender: TObject);
    procedure Play2Click(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure Timer1Timer(Sender: TObject);
    procedure Timer2Timer(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure ShockwaveFlash_SWFProgress(ASender: TObject; percentDone: Integer);
    procedure VideoWindow_VIDMouseMove(Sender: TObject; Shift: TShiftState; X, Y: Integer);
    procedure Image_IMGMouseMove(Sender: TObject; Shift: TShiftState; X, Y: Integer);
  private
    { Private declarations }
    FMonitorPrincipal: Boolean;
    FDiretorioMidia,
    FDiretorioLog    :String;

    FTipoArq : String;

    FTempo: String;
    FArquivo: String;
    FArquivosDeMidia   : TStringList;
//    FDiretorioDaAplicacao :  WideString;
//    FDiretorioCache       :  WideString;
    nid                   : TNotifyIconData;
    {iAux,} iMJ             : integer;
//    PlayFiles             : array[0..100,0..3] of String;

    FTocando: Boolean;

//    sDIRETORIO_CACHE,
//    sDIRETORIO_MIDIA,
//    sDIRETORIO_SCRIPT,
//    sDIRETORIO_LOG : string;

    procedure RecarregarScript;
//    procedure IconTray (var Msg: TMessage); message wm_IconMessage;
//    procedure CarregarItemConfiguracao ;
    procedure ExecutarItem(iIndex: Word);
    procedure IniciarReproducao;
    procedure ProximoPlay;
//    procedure ajustaform;
    procedure SalvarItemLog(aArquivo: String);
    procedure ExecutarSWF(aArquivo: String);
    procedure ExecutarIMG(sArquivo: String);
    procedure ExecutarVID(aArquivo:String);
//    procedure DesabilitaBarraWind;
//    procedure HabilitaBarraWin;
//    procedure RefreshVideoWindow;
    function FileInfo(aFileIndex: Word): TFileInfo;
    procedure ListBoxConf;
  public
    { Public declarations }

    iCont, iCont1 : Cardinal;

    property MonitorPrincipal: Boolean read FMonitorPrincipal write FMonitorPrincipal;
    property DiretorioMidia: String read FDiretorioMidia write FDiretorioMidia;
    property DiretorioLog: String read FDiretorioLog write FDiretorioLog;
    property Tempo: String read FTempo write FTempo;
    property TipoArq: String read FTipoArq write FTipoArq;
    property ArquivosDeMidia: TStringList read FArquivosDeMidia write FArquivosDeMidia;
    property Arquivo: String read FArquivo;
  end;

var
  Form_Player: TForm_Player;

implementation

{$R *.dfm}

uses windows
   , IniFiles
   , UFuncoes;

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

procedure TForm_Player.CFSHChangeNotifier_PrincipalChangeAttributes;
begin
//  Exit;
  //RecarregarScript;
end;

procedure TForm_Player.CFSHChangeNotifier_PrincipalChangeDirName;
begin
//  Exit;
  //RecarregarScript;
end;

procedure TForm_Player.CFSHChangeNotifier_PrincipalChangeFileName;
begin
//  Exit;
  //RecarregarScript;
end;

procedure TForm_Player.CFSHChangeNotifier_PrincipalChangeLastWrite;
begin
//  RecarregarScript;
end;

procedure TForm_Player.CFSHChangeNotifier_PrincipalChangeSecurity;
begin
//  Exit;
  //RecarregarScript;
end;

procedure TForm_Player.CFSHChangeNotifier_PrincipalChangeSize;
begin
//  Exit;
  //RecarregarScript;
end;

procedure TForm_Player.FormCreate(Sender: TObject);
begin
  FTocando := False;
//  FArquivosDeMidia    := TStringList.Create;

//  FDiretorioDaAplicacao := GetCurrentDir;
end;

procedure TForm_Player.FormDestroy(Sender: TObject);
begin
  ShowCursor(True);
//  FArquivosDeMidia.Free;
  FilterGraph.Free;
  Self.Close;
end;

procedure TForm_Player.RecarregarScript;
begin
  { Executa os mesmos procedimentos já existentes no form de configurações }
  Form_Configuracao.RecarregarScript;

  Timer1.Enabled := False;
  Timer2.Enabled := False;

  iMJ := 0;

  ExecutarItem(iMj);

end;

procedure TForm_Player.BitBtn1Click(Sender: TObject);
begin
  Icon.Handle := LoadIcon(HInstance, 'MAINICON');
  // preenche os dados da estrutura NotifyIcon
  nid.cbSize := sizeof (nid);
  nid.wnd := Handle;
  nid.uID := 1; // Identificador do ícone
  nid.uCallBAckMessage := wm_IconMessage;
  nid.hIcon := Icon.Handle;
  // Exibe como hint no ícone do Tray a senha do dia.
  nid.szTip := '';
  nid.uFlags := nif_Message or
                nif_Icon    or
                nif_Tip;
  Shell_NotifyIcon (NIM_ADD, @nid);
  // esconde o form
  Self.Hide;

end;

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
      FileName := Copy(Arquivo,1,Pred(Pos('|',Arquivo)));
      FileTime := StrToInt(Copy(Arquivo,Succ(Pos('|',Arquivo)),Length(Arquivo)));
      FileType := StringReplace(ExtractFileExt(FileName),'.','',[]);
    end;
  end
  else
    raise Exception.Create('O índice "' + IntToStr(aFileIndex) + '" não existe na lista');
end;

procedure TForm_Player.ExecutarVID(aArquivo :String);
begin
  FilterGraph.RenderFile(FDiretorioMidia + '\' + aArquivo);
  FilterGraph.Play;
  VideoWindow_VID.Show;
end;

//procedure TForm_Player.CarregarItemConfiguracao;
//var
//  i, iPos1, iPos2 : integer;
//  sAux, sAux1 : string;
//begin
//  iAux := FArquivosDeMidia.Count;
//
//  Form_Configuracao.ListBox_Script.Clear;
//
//  for i := 0 to FArquivosDeMidia.Count - 1 do
//  begin
//    // localizar o parametro
//    sAux := FArquivosDeMidia[i];
//    iPos1 := Pos('=',sAux);
//    iPos2 := Pos('|',sAux);
//
//    // Ex: ARQ001=\ARQUIVO1.FLV|0
//    sAux1 := Trim(Copy(sAux,iPos1+1,iPos2-1));
//    PlayFiles[i,0] := copy(sAux1,1,pos('|',saux1)-1);
//    PlayFiles[i,1] := copy(sAux1,pos('|',saux1)+1,length(saux1)-1);
//    PlayFiles[i,2] := copy(sAux1,pos('|',saux1)-3,3); // Extensão do arquivo
//
//    Form_Configuracao.ListBox_Script.Items.Add(PlayFiles[i,0]);
//  end;
//
//end;

procedure TForm_Player.ExecutarItem(iIndex: Word);
var
  FileInformation: TFileInfo;
begin
   if not FilterGraph.Active then
     FilterGraph.Active := True;

   FilterGraph.ClearGraph;

  FileInformation := FileInfo(iIndex);

  FTipoArq := UpperCase(FileInformation.FileType);
  FArquivo := UpperCase(FileInformation.FileName);

  { Esconde tudo aqui }
  Image_IMG.Visible          := False;
  ShockwaveFlash_SWF.Visible := False;
  VideoWindow_VID.Visible    := False;

  ListBoxConf;

  { Se o arquivo não existir, tenta o próximo }
  { O algorítmo de passar para o próximo deve sair desta funçao }
  { Esta função tem de chamar ela mesma quando o arquivo não existir }
  if not FileExists(FDiretorioMidia + '\' + FileInformation.FileName) then
  begin
    if iMj + 1 = FArquivosDeMidia.Count then
    begin
      iMj := 0;
      RecarregarScript
    end
    else
    begin
      iMj := iMj +1;
      ProximoPlay;
    end;
  end
  { Se existir, exibe! }
  else
  begin
    { Arquivos estáticos e SWF (não reproduzíveis) }
    if (FTipoArq = 'SWF') or (FTipoArq = 'JPG') or (FTipoArq = 'BMP') or
       (FTipoArq = 'ICO') or (FTipoArq = 'PNG') then
    begin
      FilterGraph.Active := False;

      { Se for o caso especial SWF... }
      if FTipoArq = 'SWF' then begin
        ExecutarSWF(FArquivo)
      end
      else begin
        ExecutarIMG(FArquivo);
      end;
    end
    { Arquivos dinâmicos (reproduzíveis) }
    else begin
      ExecutarVID(FArquivo);
    end;

    SalvarItemLog(FArquivo);
  end;
{ O flag abaixo so deve existir dentro das funções de reprodução e deve ser
ressetado quando a reprodução for parada manualmente para parar timers }
  FTocando := True;

//  VideoWindow.PopupMenu := PopupMenu;
end;

procedure TForm_Player.IniciarReproducao;
begin

//  ChDir(FDiretorioDaAplicacao);
  { Recarrega a lista interna de arquivos e atualiza a lista no form de
  configuração }
  Form_Configuracao.RecarregarScript;

  { Caso não esteja no modo de reprodução, o inicia }
  if not FTocando then
    ExecutarItem(0);
{ O flag abaixo so deve existir dentro das funções de reprodução e deve ser
ressetado quando a reprodução for parada manualmente para parar timers }

//  FTocando := True;

//  VideoWindow_VID.Align := alClient;
//  FilterGraph.Play;

//  FTocando := False;
end;

procedure TForm_Player.TrackBarTimer(sender: TObject; CurrentPos, StopPos: Cardinal);
begin

    StopPos := StopPos + 9;//FileInfo(iMJ).FileTime;

    StatusBar.SimpleText := format('Position: %s Duration: %s',
     [TimeToStr(CurrentPos / MiliSecPerDay), TimeToStr(StopPos / MiliSecPerDay)]);

    FTempo := StatusBar.SimpleText;

    FTocando := True;

    if TimeToStr(CurrentPos / MiliSecPerDay) =  TimeToStr(StopPos / MiliSecPerDay) then
    begin
        FTempo := '';

        FTocando := False;
        FilterGraph.ClearGraph;
        FilterGraph.Active := False;

        if iMj + 1 = FArquivosDeMidia.Count then
        begin
          iMj := 0;
          RecarregarScript
        end
        else begin
          iMj := iMj +1;
          ProximoPlay;
        end;
    end;
end;

procedure TForm_Player.ProximoPlay;
begin
  ExecutarItem(iMJ);
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
  if Assigned(FilterGraph) then
    FilterGraph.ClearGraph;

  Action := caFree;
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

procedure TForm_Player.ExecutarSWF(aArquivo: String);
begin
  ShockwaveFlash_SWF.Base  := FDiretorioMidia + '\' + aArquivo;
  ShockwaveFlash_SWF.Movie := FDiretorioMidia + '\' + aArquivo;

  ShockwaveFlash_SWF.Stop;
  ShockwaveFlash_SWF.Rewind;

  ShockwaveFlash_SWF.Show;

  ShockwaveFlash_SWF.Align   := alClient;
//  ShockwaveFlash_SWF.Playing := False;
  ShockwaveFlash_SWF.Play;
  Timer1.Enabled := True;
  Timer2.Enabled := False;
  iCont := Timer1.Interval;
end;

procedure TForm_Player.Timer1Timer(Sender: TObject);
var
  FileInformation: TFileInfo;
begin
  inc(iCont);
  iCont := iCont;

  FileInformation := FileInfo(iMJ);

  if iCont = Timer1.Interval + FileInformation.FileTime then
  begin
    ShockwaveFlash_SWF.Visible := False;
    ShockwaveFlash_SWF.Playing := False;
    Timer1.Enabled := False;
    iMj := iMj +1;
    iCont := 0;

    FTempo := '';

    if iMJ = FArquivosDeMidia.Count then
      RecarregarScript
    else
      ProximoPlay;
  end
  else
  begin
    ShockwaveFlash_SWF.Visible := True;
    ShockwaveFlash_SWF.Playing := True;

    if (iCont - Timer2.Interval) < 60 then
      FTempo := IntToStr(iCont - Timer1.Interval) + ' ' + 'Segundos de ' + IntToStr(FileInformation.FileTime) + ' Segundos.'
    else
      FTempo := IntToStr(iCont - Timer1.Interval) + ' ' + 'Minutos de ' + IntToStr(FileInformation.FileTime) + ' Segundos.';
  end;
end;

procedure TForm_Player.ExecutarIMG(sArquivo: String);
begin
  Image_IMG.Picture.LoadFromFile(FDiretorioMidia + '\' + sArquivo);
  Image_IMG.Align         := alClient;

  Image_IMG.Show;

  Timer2.Enabled          := True;
  Timer1.Enabled          := False;
  iCont1                  := Timer2.Interval;
end;

procedure TForm_Player.Timer2Timer(Sender: TObject);
var
  FileInformation: TFileInfo;
begin
  inc(iCont1);
  iCont1 := iCont1;

  FileInformation := FileInfo(iMJ);

  if iCont1 = Timer2.Interval + FileInformation.FileTime then
  begin
    Image_IMG.Visible := False;
    Timer2.Enabled := False;
    iMj := iMj +1;
    iCont1 := 0;

    FTempo := '';

    if iMJ = FArquivosDeMidia.Count then
      RecarregarScript
    else
      ProximoPlay;
  end
  else
  begin
    if (iCont1 - Timer2.Interval) < 60 then
      FTempo := IntToStr(iCont1 - Timer2.Interval) + ' ' + 'Segundos de ' + IntToStr(FileInformation.FileTime) + ' Segundos'
    else
      FTempo := IntToStr(iCont1 - Timer2.Interval) + ' ' + 'Minutos de ' + IntToStr(FileInformation.FileTime) + ' Segundos';

    ShockwaveFlash_SWF.Visible := False;
    VideoWindow_VID.Visible     := False;
    Image_IMG.Visible := True;
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

  CFSHChangeNotifier_Principal.Root := FDiretorioMidia;

  IniciarReproducao;

//  DesabilitaBarraWind;
end;

procedure TForm_Player.ShockwaveFlash_SWFProgress(ASender: TObject; percentDone: Integer);
begin
  ShowCursor(False);
end;

procedure TForm_Player.VideoWindow_VIDMouseMove(Sender: TObject; Shift: TShiftState; X, Y: Integer);
begin
  ShowCursor(False);
end;

procedure TForm_Player.Image_IMGMouseMove(Sender: TObject; Shift: TShiftState; X, Y: Integer);
begin
  ShowCursor(False);
end;

//procedure TForm_Player.RefreshVideoWindow;
//begin
//
//end;

procedure TForm_Player.ListBoxConf;
var
  S : Array[0..255] of Char;
begin
     StrPCopy(S, Form_Player.Arquivo);
     with Form_Configuracao.ListBox_Script do
       ItemIndex := Perform(LB_SELECTSTRING, 0, LongInt(@S));
     exit;

end;

end.



