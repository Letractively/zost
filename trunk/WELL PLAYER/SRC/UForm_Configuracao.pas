unit UForm_Configuracao;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ImgList, ComCtrls, ToolWin, StdCtrls, Buttons, AppEvnts, DsPack,
  ExtCtrls, FileCtrl;

type
  TForm_Configuracao = class(TForm)
    ToolBar: TToolBar;
    btPlay: TToolButton;
    btPause: TToolButton;
    btStop: TToolButton;
    ToolButton1: TToolButton;
    btFullScreen: TToolButton;
    ToolButton2: TToolButton;
    SoundLevel: TTrackBar;
    ImageList: TImageList;
    btPlayList: TBitBtn;
    lbMusica: TLabel;
    ApplicationEvents1: TApplicationEvents;
    edtDirMidia: TLabeledEdit;
    rgMidia: TRadioGroup;
    Label4: TLabel;
    ListBox1: TListBox;
    OpenDialog1: TOpenDialog;
    SpeedButton2: TSpeedButton;
    SpeedButton3: TSpeedButton;
    edtDirLog: TLabeledEdit;
    SpeedButton4: TSpeedButton;
    ToolButton3: TToolButton;
    procedure btPlayClick(Sender: TObject);
    procedure btPlayListClick(Sender: TObject);
    procedure btPauseClick(Sender: TObject);
    procedure btStopClick(Sender: TObject);
    procedure ApplicationEvents1Idle(Sender: TObject; var Done: Boolean);
    procedure btFullScreenClick(Sender: TObject);
    procedure SpeedButton2Click(Sender: TObject);
    procedure SpeedButton3Click(Sender: TObject);
    procedure SpeedButton4Click(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure FormActivate(Sender: TObject);
    procedure FormMouseMove(Sender: TObject; Shift: TShiftState; X, Y: Integer);
    procedure ToolButton2Click(Sender: TObject);
    procedure ToolButton3Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
    sLocalConf : string;
    FDiretorioDaAplicacao : String;
    FArquivosDeMidias     : TStringList;

    iCont : Integer;

    procedure p_ValidaArquivosConf;
    function isFolderEmpty(sPath : String) : Boolean ;

    procedure RecarregarScript;
    procedure CarregarItemConfiguracao ;
    procedure DesabilitaBarraWind;
    procedure HabilitaBarraWin;
    procedure p_AjustaMonitor;

  end;

var
  Form_Configuracao: TForm_Configuracao;

implementation

uses UForm_Player, Inifiles, RTLConsts;

var
  DirMidia: String;
  DirLog: String;

{$R *.dfm}

procedure TForm_Configuracao.btPlayClick(Sender: TObject);
begin

   if Form_Player = nil then exit;

   if Form_Player.FilterGraph <> nil then begin
     if Form_Player.FilterGraph.State = gsUninitialized then
       btPlayListClick(self)
     else
       Form_Player.FilterGraph.Play
   end
   else
     btPlayListClick(self);
end;

procedure TForm_Configuracao.btPlayListClick(Sender: TObject);
//var
//    i, j : integer;
//    sTexto : String;
begin

// j := 0;

 {
 if ListBox1.Count = 1 then
   ListBox1.Items[0].clear
 else begin
   for j:=0 to ListBox1.Count - 1 then
     ListBox1.Items[j].clear;
 end;
  }
  ListBox1.Items.Clear;

  p_ValidaArquivosConf;

  try
    if Form_Player <> nil then
      if (Form_Player.FilterGraph <> nil) and
         (Form_Player.FilterGraph.State <> gsUninitialized) then Exit;

    Application.Createform(TForm_Player,Form_Player);

    p_AjustaMonitor; 
    {
    for i:=0 to Principal.FArquivosDeMidia.Count - 1 do begin
      sTExto := Principal.PlayFiles[i,0];
      ListBox1.Items.Add(sTexto);
    end;
    }

  except on
       E:Exception do ShowMessage('Não foi possível iniciar o SlideShow.'+#13+#10+E.Message);
  end;
end;

procedure TForm_Configuracao.btPauseClick(Sender: TObject);
begin
   if Form_Player = nil then exit;
   if Form_Player.FilterGraph <> nil then
     Form_Player.FilterGraph.Pause;
end;

procedure TForm_Configuracao.btStopClick(Sender: TObject);
begin
   if Form_Player = nil then exit;
   if Form_Player.FilterGraph <> nil then
     Form_Player.FilterGraph.Stop;
end;

procedure TForm_Configuracao.ApplicationEvents1Idle(Sender: TObject;
var Done: Boolean);
var
  S : Array[0..255] of Char;
begin
  if Form_Player <> nil then begin

    if Form_Player.FilterGraph = nil then begin
      lbMusica.Caption := '';
       //ListBox1.Clear;
    end
    else
    begin
       if Form_Player.FilterGraph.State = gsUninitialized then begin

         lbMusica.Caption := '    '+ Form_Player.sTempo ;
         StrPCopy(S, Form_Player.sMusica);
         with ListBox1 do
           ItemIndex := Perform(LB_SELECTSTRING, 0, LongInt(@S));
         exit;

       end;

      if (Form_Player.FilterGraph.State = gsStopped) or
         (Form_Player.FilterGraph.State = gsPaused) or
         (Form_Player.FilterGraph.State = gsPlaying)  then begin
        lbMusica.Caption := '    '+ Form_Player.sTempo ;

        StrPCopy(S, Form_Player.sMusica);
        with ListBox1 do
          ItemIndex := Perform(LB_SELECTSTRING, 0, LongInt(@S));
        end;

      end;
    end
    else begin
      lbMusica.Caption := '';
    end;
end;

procedure TForm_Configuracao.btFullScreenClick(Sender: TObject);
begin
  if Form_Player <> nil then
    if Form_Player.FilterGraph <> nil then
       Form_Player.Close;
  HabilitaBarraWin;       
end;

procedure TForm_Configuracao.SpeedButton2Click(Sender: TObject);
var
  options : TSelectDirOpts;
  chosenDirectory : string;
begin
  chosenDirectory := 'C:\';
  if SelectDirectory(chosenDirectory, options, 0)  then
    edtDirMidia.Text := chosenDirectory;
end;

procedure TForm_Configuracao.SpeedButton3Click(Sender: TObject);
var
  sDirMidia, sDirLog : String;
  ArqIni, ArqMidia, ArqLog : string;
  LocalIni,  local: TextFile;
begin

  if Trim(edtDirMidia.Text) = '' then
    raise Exception.Create('Informe o local dos Arquivos de Mídia.');
  if Trim(edtDirLog.Text) = '' then
    raise Exception.Create('Informe o local do Arquivo de Log.');

  if not DirectoryExists(Trim(edtDirMidia.Text)) then
    raise Exception.Create('O diretório informado nãoe existe: ' +Trim(edtDirMidia.Text));
  if not DirectoryExists(Trim(edtDirLog.Text)) then
    raise Exception.Create('O diretório informado nãoe existe: ' +Trim(edtDirLog.Text));

  sDirMidia := edtDirMidia.Text;
  sDirLog   := edtDirLog.Text;

  ArqMidia := sDirMidia;
  ArqLog   := sDirLog;


  sLocalConf := FDiretorioDaAplicacao + '\Config.ini';

  if FileExists(sLocalConf) then  //Verifica se existe o arquivo, deletando se existir
    DeleteFile(sLocalConf);

  AssignFile(Local, ArqIni);

  if not FileExists(sLocalConf) then
  begin
    Rewrite(Local, sLocalConf);
    Append(Local); //Cria o arquivo
    WriteLn(Local, '[INI]');
    WriteLn(Local, 'arq000='+aRQIni);

    WriteLn(Local, '[MIDIA]');
    WriteLn(Local, 'arq001='+aRQmidia);

    WriteLn(Local, '[LOG]');
    WriteLn(Local, 'arq002='+arqlog);

  end;

  CloseFile(Local);

  // cria arquivo INI
  if  Trim(ArqIni) <> '' then
    if not FileExists(ArqIni+'\Script.ini') then  //Verifica se existe o arquivo, abrindo se existir
    begin
      AssignFile(LocalIni, ArqIni+'\Script.ini');
      Rewrite(LocalIni);
      WriteLn(LocalIni, '[ARQUIVOSDEMIDIA]');
      WriteLn(LocalIni, 'ARQ000=nome do arquivo, com a extenção, seguido de |9. Ex: som_do_ceu.flv|9 ');
      WriteLn(LocalIni, 'ARQ001=nome do arquivo, com a extenção, seguido de |9. Ex: outro_som.flv|9 ');
      CloseFile(LocalIni);
    end;

end;

procedure TForm_Configuracao.SpeedButton4Click(Sender: TObject);
var
  options : TSelectDirOpts;
  chosenDirectory : string;
begin
  chosenDirectory := 'C:\';
  if SelectDirectory(chosenDirectory, options, 0)  then
    edtDirLog.Text := chosenDirectory;
end;

procedure TForm_Configuracao.p_ValidaArquivosConf;
var
   icont, i : integer;
   iPos1, iPos2 : integer;
   sAux, sAux1 : string;
begin
  iCont := 0;

  ListBox1.Items.Clear;

  if isFolderEmpty(edtDirMidia.Text) then
    raise Exception.Create('Não existem arquivos em: '+ edtDirMidia.Text );

  for i := 0 to FArquivosDeMidias.Count - 1 do
  begin
    // localizar o parametro
    sAux := FArquivosDeMidias[i];
    iPos1 := Pos('=',sAux);
    iPos2 := Pos('|',sAux);

    // Ex: ARQ001=\ARQUIVO1.FLV|0
    sAux1 := Trim(Copy(sAux,iPos1+1,iPos2-1));
    ListBox1.Items.Add(copy(sAux1,1,pos('|',saux1)-1));

    if not FileExists(edtDirMidia.Text+'\'+copy(sAux1,1,pos('|',saux1)-1)) then
      inc(icont);
  end;

  if Icont =  FArquivosDeMidias.Count then
    raise Exception.Create('Nenhum arquivo da lista foi encontrado.');

end;

function TForm_Configuracao.isFolderEmpty(sPath: String): Boolean;
var
  res: TSearchRec;
begin
  Result := False;

  if sPath = '' then
    exit;

  sPath := IncludeTrailingBackslash(sPath);
  Result := (FindFirst(sPath + '*.*', faAnyFile - faDirectory, res) <> 0);
  FindClose(res);
end;

procedure TForm_Configuracao.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  if Form_Player <> nil then
    if Form_Player.FilterGraph <> nil then
      Form_Player.Close;

  Action := caFree;  
end;

procedure TForm_Configuracao.RecarregarScript;
begin

  FArquivosDeMidias.Clear;

  with TIniFile.Create(edtDirMidia.Text + '\Script.ini') do
    try
     ReadSectionValues('ARQUIVOSDEMIDIA',FArquivosDeMidias);
    finally
      Free;
    end;

  CarregarItemConfiguracao;
end;

procedure TForm_Configuracao.CarregarItemConfiguracao;
var
  i, iPos1, iPos2 : integer;
  sAux, sAux1 : string;
begin
  ListBox1.Items.Clear;
  
  for i := 0 to FArquivosDeMidias.Count - 1 do
  begin
    // localizar o parametro
    sAux := FArquivosDeMidias[i];
    iPos1 := Pos('=',sAux);
    iPos2 := Pos('|',sAux);

    // Ex: ARQ001=\ARQUIVO1.FLV|0
    sAux1 := Trim(Copy(sAux,iPos1+1,iPos2-1));
    ListBox1.Items.Add(copy(sAux1,1,pos('|',saux1)-1));
  end;

end;

procedure TForm_Configuracao.FormCreate(Sender: TObject);
begin
  Form_Configuracao.edtDirMidia.Text := DirMidia;
  Form_Configuracao.edtDirLog.Text := DirLog;

  FArquivosDeMidias := TStringList.Create;

  FDiretorioDaAplicacao := ExtractFilePath(Application.ExeName);

  RecarregarScript;
  DesabilitaBarraWind;
end;

procedure TForm_Configuracao.FormDestroy(Sender: TObject);
begin
  DirMidia := Form_Configuracao.edtDirMidia.Text;
  DirLog := Form_Configuracao.edtDirLog.Text;

  FArquivosDeMidias.Free;
  HabilitaBarraWin;
  ShowCursor(True);
end;

procedure TForm_Configuracao.DesabilitaBarraWind;
begin
end;

procedure TForm_Configuracao.HabilitaBarraWin;
var
  wndHandle : THandle;
  wndClass : array[0..50] of Char;
begin
  StrPCopy(@wndClass[0], 'Shell_TrayWnd');
  wndHandle:= FindWindow(@wndClass[0], nil);
  ShowWindow(wndHandle, SW_RESTORE); // This restores the taskbar
end;

procedure TForm_Configuracao.FormActivate(Sender: TObject);
begin
  ShowCursor(True);
end;

procedure TForm_Configuracao.FormMouseMove(Sender: TObject; Shift: TShiftState; X,
  Y: Integer);
begin
  ShowCursor(True);
end;

procedure TForm_Configuracao.ToolButton2Click(Sender: TObject);
begin 
  if Form_Player <> nil then
     if Form_Player.FilterGraph <> nil then
       if Form_Player.FormStyle <> fsNormal then begin
         Form_Player.FormStyle := fsNormal;
       end;

end;

procedure TForm_Configuracao.ToolButton3Click(Sender: TObject);
begin
   if Form_Player <> nil then
     if Form_Player.FilterGraph <> nil then
       if Form_Player.FormStyle <> fsStayOnTop then
         Form_Player.FormStyle := fsStayOnTop;
end;

procedure TForm_Configuracao.p_AjustaMonitor;
begin
  if rgMidia.ItemIndex = 0 then begin
    if Form_Player <> nil then
       if Form_Player.FilterGraph <> nil then
         Form_Player.bMonitorPrincipal := True;
  end
  else begin
    if Form_Player <> nil then
       if Form_Player.FilterGraph <> nil then
         Form_Player.bMonitorPrincipal := False;
  end;

end;

procedure CarregarConfiguracoes;
begin
  with TIniFile.Create(ExtractFilePath(Application.ExeName) + 'Config.ini') do
    try
      DirMidia := ReadString('CONFIGURACOES', 'MIDIA', '');
      DirLog := ReadString('CONFIGURACOES', 'LOGS', '');
    finally
      Free;
    end;
end;

procedure SalvarConfiguracoes;
begin
  with TIniFile.Create(ExtractFilePath(Application.ExeName) + 'Config.ini') do
    try
      WriteString('CONFIGURACOES', 'MIDIA', DirMidia);
      WriteString('CONFIGURACOES', 'LOGS', DirLog);
    finally
      Free;
    end;
end;

initialization
  CarregarConfiguracoes;

finalization;
  SalvarConfiguracoes;

end.


