unit UForm_Player;

interface

uses
  SysUtils, Classes, Controls, Forms,
  UCFSHChangeNotify, StdCtrls,
  ShellAPI,  Messages, Buttons, Menus, DSPack, ImgList, ComCtrls, Dialogs,
  ExtCtrls, DSUTIL, UForm_Configuracao,directshow9, OleCtrls,JPEG,
  ShockwaveFlashObjects_TLB ;

const
  wm_IconMessage = wm_User;

type
  TForm_Player = class(TForm)
    CFSHChangeNotifier_Principal: TCFSHChangeNotifier;
    BitBtn1: TBitBtn;
    FilterGraph: TFilterGraph;
    OpenDialog: TOpenDialog;
    VideoWindow: TVideoWindow;
    Timer1: TTimer;
    StatusBar: TStatusBar;
    TrackBar: TDSTrackBar;
    Timer2: TTimer;
    Image2: TImage;
    ShockwaveFlash1: TShockwaveFlash;
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
    procedure TrackBarTimer(sender: TObject; CurrentPos,
      StopPos: Cardinal);
    procedure Pause2Click(Sender: TObject);
    procedure Play2Click(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure Timer1Timer(Sender: TObject);
    procedure Timer2Timer(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure ShockwaveFlash1Progress(ASender: TObject;
      percentDone: Integer);
    procedure VideoWindowMouseMove(Sender: TObject; Shift: TShiftState; X,
      Y: Integer);
    procedure Image2MouseMove(Sender: TObject; Shift: TShiftState; X,
      Y: Integer);
  private
    { Private declarations }
    FMonitorPrincipal: Boolean;
    FDiretorioMidia,
    FDiretorioLog    :String;

    FTipoArq : String;

    FTempo: String;
    FArquivo: String;
    FArquivosDeMidia   : TStringList;
    FDiretorioDaAplicacao :  WideString;
//    FDiretorioCache       :  WideString;
    nid                   : TNotifyIconData;
    iAux, iMJ             : integer;
    PlayFiles             : array[0..100,0..3] of String;

    bTocando : boolean;

//    sDIRETORIO_CACHE,
    sDIRETORIO_MIDIA,
    sDIRETORIO_SCRIPT,
    sDIRETORIO_LOG : string;

    procedure RecarregarScript;
    procedure IconTray (var Msg: TMessage); message wm_IconMessage;
    procedure CarregarItemConfiguracao ;
    procedure ExecutarPlay(iIndex : Integer);
    procedure ExecutarArqTemp;
    procedure ProximoPlay;
//    procedure ajustaform;
    procedure p_GravaLog(sMusica :String);
    procedure f_Tocarswf(sNome : String);
    procedure f_Imagem(sNome : String);
//    procedure DesabilitaBarraWind;
//    procedure HabilitaBarraWin;
//    procedure RefreshVideoWindow;

  public
    { Public declarations }

    iCont, iCont1 : Cardinal;

    property MonitorPrincipal: Boolean read FMonitorPrincipal write FMonitorPrincipal;

    property DiretorioMidia: String read FDiretorioMidia write FDiretorioMidia;
    property DiretorioLog: String read FDiretorioLog write FDiretorioLog;

    property Tempo: String read FTempo write FTempo;
    property Arquivo: String read FArquivo;

    property TipoArq: String read FTipoArq write FTipoArq;
  end;

var
  Form_Player: TForm_Player;

implementation

{$R *.dfm}

uses  windows
     , IniFiles
     , UFuncoes;

const
  DIRETORIO_CACHE = 'CACHE';
  DIRETORIO_MIDIA = 'C:\SlideShow Script Monitor\bin\exe\Cache\Midia';
  DIRETORIO_SCRIPT = 'C:\SlideShow Script Monitor\bin\exe\Cache';

function IsDirectoryEmpty(const aDirectory: string) : boolean;
var
  SearchRec :TSearchRec;
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
  Exit;
  //RecarregarScript;
end;

procedure TForm_Player.CFSHChangeNotifier_PrincipalChangeDirName;
begin
  Exit;
  //RecarregarScript;
end;

procedure TForm_Player.CFSHChangeNotifier_PrincipalChangeFileName;
begin
  Exit;
  //RecarregarScript;
end;

procedure TForm_Player.CFSHChangeNotifier_PrincipalChangeLastWrite;
begin
//  RecarregarScript;
end;

procedure TForm_Player.CFSHChangeNotifier_PrincipalChangeSecurity;
begin
  Exit;
  //RecarregarScript;
end;

procedure TForm_Player.CFSHChangeNotifier_PrincipalChangeSize;
begin
  Exit;
  //RecarregarScript;
end;

procedure TForm_Player.FormCreate(Sender: TObject);
var
   sini, smidia, slog : TStringList;
   ipos :integer;
   sAux1,sAux2,sAux3 : String;
begin
  bTocando := False;
  FArquivosDeMidia    := TStringList.Create;

  sini   := TStringList.Create;
  smidia := TStringList.Create;
  slog   := TStringList.Create;

  FDiretorioDaAplicacao := GetCurrentDir;
end;

procedure TForm_Player.FormDestroy(Sender: TObject);
begin
  ShowCursor(True);
  FArquivosDeMidia.Free;
  FilterGraph.Free;
  Self.Close;
end;

procedure TForm_Player.RecarregarScript;
begin

  FArquivosDeMidia.Clear;

  with TIniFile.Create(FDiretorioMidia + '\Script.ini') do
    try
     ReadSectionValues('ARQUIVOSDEMIDIA',FArquivosDeMidia);
    finally
      Free;
    end;

  CarregarItemConfiguracao;

  Timer1.Enabled := False;
  Timer2.Enabled := False;

  iMJ := 0;

  ExecutarPlay(iMj);

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

procedure TForm_Player.IconTray(var Msg: TMessage);
var
  Pt: TPoint;
begin
  if (Msg.lParam = wm_rbuttondown) then
  begin
    GetCursorPos (Pt);
  end;
  if msg.LParam = wm_lbuttondblclk then
  begin
    Self.show;
  end;

end;

procedure TForm_Player.ExibirJanela1Click(Sender: TObject);
begin
 Self.show;
end;

procedure TForm_Player.FecharJanela1Click(Sender: TObject);
begin
  close;
end;

procedure TForm_Player.CarregarItemConfiguracao;
var
  i, iPos1, iPos2 : integer;
  sAux, sAux1 : string;
begin
  iAux := FArquivosDeMidia.Count;

  Form_Configuracao.ListBox_Script.Clear;

  for i := 0 to FArquivosDeMidia.Count - 1 do
  begin
    // localizar o parametro
    sAux := FArquivosDeMidia[i];
    iPos1 := Pos('=',sAux);
    iPos2 := Pos('|',sAux);

    // Ex: ARQ001=\ARQUIVO1.FLV|0
    sAux1 := Trim(Copy(sAux,iPos1+1,iPos2-1));
    PlayFiles[i,0] := copy(sAux1,1,pos('|',saux1)-1);
    PlayFiles[i,1] := copy(sAux1,pos('|',saux1)+1,length(saux1)-1);
    PlayFiles[i,2] := copy(sAux1,pos('|',saux1)-3,3); // Extensão do arquivo

    Form_Configuracao.ListBox_Script.Items.Add(PlayFiles[i,0]);
  end;

end;

procedure TForm_Player.ExecutarPlay(iIndex : Integer);
var sNomePlay :  WideString;
begin

    if not FilterGraph.Active then
      FilterGraph.Active := True;

    FilterGraph.ClearGraph;

    sNomePlay := PlayFiles[iIndex,0];

    if sNomePlay = '' then Exit;

    if  FArquivosDeMidia.Count = 0 then Exit;

    if not(FileExists(FDiretorioMidia+'\'+sNomePlay)) then begin

        FilterGraph.Stop;

        if iMj + 1 = FArquivosDeMidia.Count then
        begin
          iMj := 0;
          RecarregarScript
        end
        else begin
          iMj := iMj +1;
          ProximoPlay;
        end;

    end
    else begin

      FTipoArq := UpperCase(PlayFiles[iIndex,2]);

      if (UpperCase(PlayFiles[iIndex,2]) = 'SWF') or
         (UpperCase(PlayFiles[iIndex,2]) = 'JPG') or
         (UpperCase(PlayFiles[iIndex,2]) = 'BMP') or
         (UpperCase(PlayFiles[iIndex,2]) = 'ICO') or
         (UpperCase(PlayFiles[iIndex,2]) = 'PNG') then begin
        FilterGraph.Active := False;

        if UpperCase(PlayFiles[iIndex,2]) = 'SWF' then
          f_Tocarswf(sNomePlay)
        else
          f_Imagem(sNomePlay);
      end
      else
        FilterGraph.RenderFile(FDiretorioMidia+'\'+sNomePlay);

      FArquivo := sNomePlay;
      p_GravaLog(sNomePlay);
    end;

   VideoWindow.PopupMenu := PopupMenu;
   bTocando := True;

   Image2.Visible          := False;
   ShockwaveFlash1.Visible := False;
   VideoWindow.Visible     := True;
 
   FilterGraph.Play;
end;

procedure TForm_Player.ExecutarArqTemp;
begin

  ChDir(FDiretorioDaAplicacao);

  FArquivosDeMidia.Clear;

  with TIniFile.Create(FDiretorioMidia + '\Script.ini') do
    try
     ReadSectionValues('ARQUIVOSDEMIDIA',FArquivosDeMidia);
    finally
      Free;
    end;

    CarregarItemConfiguracao;

    if not bTocando then
      ExecutarPlay(0);

    bTocando := True;

    VideoWindow.Align := alClient;
    FilterGraph.Play;

    bTocando := False;

end;

procedure TForm_Player.TrackBarTimer(sender: TObject; CurrentPos, StopPos: Cardinal);
begin

   StopPos := StopPos + StrToInt64(PlayFiles[iMJ,1]);

   StatusBar.SimpleText := format('Position: %s Duration: %s',
    [TimeToStr(CurrentPos / MiliSecPerDay), TimeToStr(StopPos / MiliSecPerDay)]);

   FTempo := StatusBar.SimpleText;

    if TimeToStr(CurrentPos / MiliSecPerDay) =  TimeToStr(StopPos / MiliSecPerDay) then
    begin
        FTempo := '';
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
  ExecutarPlay(iMJ);
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

procedure TForm_Player.p_GravaLog(sMusica: String);
var
  sDirLog, Arqlog, slocal: string;
  local: TextFile;
begin
  Arqlog := 'ScripLog_' + (FormatDateTime('ddmmyyyy', now));
  sDirLog := FDiretorioLog;
  sLocal   := sDirLog + '\'+Arqlog+'.txt' ;

  AssignFile(Local, slocal);

  if not FileExists(sLocal) then
  begin
    Rewrite(Local, sLocal);
    Append(Local); //Cria o arquivo
    WriteLn(Local, (FormatDateTime('dd-mm-yyyy hh:mm:ss', now))+' - '+smusica );
  end
  else begin
    Append(Local); //Cria o arquivo
    WriteLn(Local, (FormatDateTime('dd-mm-yyyy hh:mm:ss', now))+' - '+smusica );
  end;

  CloseFile(Local);

end;

procedure TForm_Player.f_Tocarswf(sNome: String);
begin
  ShockwaveFlash1.Base  := FDiretorioMidia + '\'+sNome;
  ShockwaveFlash1.Movie := FDiretorioMidia +'\'+ sNome;

  ShockwaveFlash1.Visible := True;
  Image2.Visible          := False;
  VideoWindow.Visible     := False;

  ShockwaveFlash1.Align   := alClient;
  ShockwaveFlash1.Playing := False;
  ShockwaveFlash1.Play;
  Timer1.Enabled := True;
  Timer2.Enabled := False;
  iCont := Timer1.Interval;
end;

procedure TForm_Player.Timer1Timer(Sender: TObject);
begin
  inc(iCont);
  iCont := iCont;

  if iCont = Timer1.Interval + (StrToInt64(PlayFiles[iMJ,1]){*60}) then begin
    ShockwaveFlash1.Visible := False;
    ShockwaveFlash1.Playing := False;
    Timer1.Enabled := False;
    iMj := iMj +1;
    iCont := 0;

    FTempo := '';

    if iMJ = FArquivosDeMidia.Count then
      RecarregarScript
    else
      ProximoPlay;
  end
  else begin
    ShockwaveFlash1.Visible := True;
    ShockwaveFlash1.Playing := True;

    if (iCont - Timer2.Interval) < 60 then
      FTempo := IntToStr(iCont - Timer1.Interval) + ' ' + 'Segundos de ' +(PlayFiles[iMJ,1]) + ' Segundos.'
    else
      FTempo := IntToStr(iCont - Timer1.Interval) + ' ' + 'Minutos de ' +(PlayFiles[iMJ,1]) + ' Segundos.';
  end;
end;

procedure TForm_Player.f_Imagem(sNome: String);
begin
  Image2.Picture.LoadFromFile(FDiretorioMidia+'\'+sNome);
  Image2.Align            := alClient;

  Image2.Visible          := True;
  ShockwaveFlash1.Visible := False;
  VideoWindow.Visible     := False;

  Timer2.Enabled          := True;
  Timer1.Enabled          := False;
  iCont1 := Timer2.Interval;
end;

procedure TForm_Player.Timer2Timer(Sender: TObject);
begin
  inc(iCont1);
  iCont1 := iCont1;

  if iCont1 = Timer2.Interval + (StrToInt64(PlayFiles[iMJ,1]){*60}) then begin
    Image2.Visible := False;
    Timer2.Enabled := False;
    iMj := iMj +1;
    iCont1 := 0;

    FTempo := '';

    if iMJ = FArquivosDeMidia.Count then
      RecarregarScript
    else
      ProximoPlay;
  end
  else begin
    if (iCont1 - Timer2.Interval) < 60 then
      FTempo := IntToStr(iCont1 - Timer2.Interval) + ' ' + 'Segundos de ' +(PlayFiles[iMJ,1]) + ' Segundos'
    else
      FTempo := IntToStr(iCont1 - Timer2.Interval) + ' ' + 'Minutos de ' +(PlayFiles[iMJ,1]) + ' Segundos';
    ShockwaveFlash1.Visible := False;
    VideoWindow.Visible     := False;
    Image2.Visible := True;
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
  ExecutarArqTemp;

//  DesabilitaBarraWind;
end;

procedure TForm_Player.ShockwaveFlash1Progress(ASender: TObject;
  percentDone: Integer);
begin
  ShowCursor(False);
end;

procedure TForm_Player.VideoWindowMouseMove(Sender: TObject;
  Shift: TShiftState; X, Y: Integer);
begin
  ShowCursor(False);
end;

procedure TForm_Player.Image2MouseMove(Sender: TObject; Shift: TShiftState;
  X, Y: Integer);
begin
  ShowCursor(False);
end;

//procedure TForm_Player.RefreshVideoWindow;
//begin
//
//end;

end.
