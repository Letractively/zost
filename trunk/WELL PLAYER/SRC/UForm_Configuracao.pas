unit UForm_Configuracao;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ImgList, ComCtrls, ToolWin, StdCtrls, Buttons, AppEvnts, DsPack,
  ExtCtrls, FileCtrl, UCFSHChangeNotify;

type
  TForm_Configuracao = class(TForm)
    ToolBar_Principal: TToolBar;
    ToolButton_Play: TToolButton;
    ToolButton_Stop: TToolButton;
    ToolButton_Fechar: TToolButton;
    ImageList_ToolBar: TImageList;
    BitBtn_RecarregarScript: TBitBtn;
    ApplicationEvents1: TApplicationEvents;
    edtDirMidia: TLabeledEdit;
    RadioGroup_Monitor: TRadioGroup;
    Label4: TLabel;
    ListBox_Script: TListBox;
    OpenDialog1: TOpenDialog;
    SpeedButton2: TSpeedButton;
    BitBtn_RecriarScript: TBitBtn;
    edtDirLog: TLabeledEdit;
    SpeedButton4: TSpeedButton;
    Panel_Tempo: TPanel;
    CFSHChangeNotifier_Principal: TCFSHChangeNotifier;
    BitBtn_MoverAbaixo: TBitBtn;
    BitBtn_MoverAcima: TBitBtn;
    ToolButton_Pause: TToolButton;
    procedure ToolButton_PlayClick(Sender: TObject);
    procedure ToolButton_StopClick(Sender: TObject);
    procedure ApplicationEvents1Idle(Sender: TObject; var Done: Boolean);
    procedure ToolButton_FecharClick(Sender: TObject);
    procedure SpeedButton2Click(Sender: TObject);
    procedure BitBtn_RecriarScriptClick(Sender: TObject);
    procedure SpeedButton4Click(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure FormActivate(Sender: TObject);
    procedure FormMouseMove(Sender: TObject; Shift: TShiftState; X, Y: Integer);
    procedure RadioGroup_MonitorClick(Sender: TObject);
    procedure Label_StatusClick(Sender: TObject);
    procedure CFSHChangeNotifier_PrincipalChangeAttributes;
    procedure CFSHChangeNotifier_PrincipalChangeDirName;
    procedure CFSHChangeNotifier_PrincipalChangeFileName;
    procedure CFSHChangeNotifier_PrincipalChangeLastWrite;
    procedure CFSHChangeNotifier_PrincipalChangeSecurity;
    procedure CFSHChangeNotifier_PrincipalChangeSize;
    procedure BitBtn_RecarregarScriptClick(Sender: TObject);
    procedure ToolButton_PauseClick(Sender: TObject);
  private
    procedure FinalizarPlaylist;
    procedure IniciarPlaylist;
    procedure PausarPlaylist;
    { Private declarations }
  public
    { Public declarations }
    sLocalConf : string;
    FDiretorioDaAplicacao : String;
    FArquivosDeMidia     : TStringList;

    iCont : Integer;

    procedure ValidarArquivosDeMidia;
    function isFolderEmpty(sPath : String) : Boolean ;

    procedure RecarregarScript;
    procedure ExibirConfiguracoes;
    procedure HabilitaBarraWin;
    procedure ConfigurarJanelaDeReproducao;
  end;

var
  Form_Configuracao: TForm_Configuracao;

implementation

{$R *.dfm}

uses UForm_Player, Inifiles, RTLConsts;

const
  EXTENSOES_SUPORTADAS: array [1..12] of String = ('.BMP','.JPG','.JPEG','.ICO',
                                                   '.GIF','.SWF','.AVI','.FLV',
                                                   '.VOB','.MPG','.MPEG','.WMV');
  EXTENSOES_NORMAIS: array [1..6] of String = ('.BMP','.JPG','.JPEG','.ICO', '.GIF','.SWF');
  EXTENSOES_TEMPORIZADAS: array [1..6] of String = ('.AVI','.FLV','.VOB','.MPG','.MPEG','.WMV');
var
  DirMidia: String;
  DirLog: String;
  MonitorPrincipal: Boolean;

procedure TForm_Configuracao.ToolButton_PlayClick(Sender: TObject);
begin
  IniciarPlaylist;
end;

procedure TForm_Configuracao.IniciarPlaylist;
begin
  if not Assigned(Form_Player) then
    try
      { Valida a exist�ncia de ao menos um arquivo visualiz�vel }
      ValidarArquivosDeMidia;

      Form_Player := TForm_Player.Create(Self);

      { Ajusta o form de reprodu��o segundo configura��es contidas aqui neste form.
      Dentro dele, no onShow, tais configura��es precisam ser usadas }
      ConfigurarJanelaDeReproducao;

      { Exibe o form que internamente deve carregar as configura��es e inicializar
      a reprodu��o }
      Form_Player.Show;
    except
      on E: Exception do
        ShowMessage('N�o foi poss�vel iniciar a reprodu��o.'#13#10 + E.Message);
    end
  else
  begin
    if Form_Player.TipoDeReproducao = tdrPause then
      Form_Player.DespausarPlaylist
    else
      Form_Player.IniciarPlaylist;
  end
end;

procedure TForm_Configuracao.FinalizarPlaylist;
begin
  if Assigned(Form_Player) then
    Form_Player.FinalizarPlaylist;
end;

procedure TForm_Configuracao.PausarPlaylist;
begin
  if Assigned(Form_Player) then
    Form_Player.PausarPlaylist;
end;

procedure TForm_Configuracao.ToolButton_StopClick(Sender: TObject);
begin
  FinalizarPlaylist;
end;

procedure TForm_Configuracao.ApplicationEvents1Idle(Sender: TObject; var Done: Boolean);
begin
  if Assigned(Form_Player) then
  begin
    Panel_Tempo.Caption := Form_Player.TempoFormatado;
    ToolButton_Play.Enabled := Form_Player.TipoDeReproducao in [tdrNenhuma,tdrPause];
    ToolButton_Stop.Enabled := not ToolButton_Play.Enabled;
    ToolButton_Pause.Enabled := Form_Player.TipoDeReproducao in [tdrTimer,tdrTempo];
    ToolButton_Fechar.Enabled := True;
  end
  else
  begin
    Panel_Tempo.Caption := '00:00:00 / 00:00:00 (00:00:00)';
    ToolButton_Play.Enabled := True;
    ToolButton_Stop.Enabled := False;
    ToolButton_Fechar.Enabled := False;
    ToolButton_Pause.Enabled := False;
  end;
end;

procedure TForm_Configuracao.ToolButton_FecharClick(Sender: TObject);
begin
  if Assigned(Form_Player) then
    Form_Player.Close;
end;

procedure TForm_Configuracao.SpeedButton2Click(Sender: TObject);
var
  options : TSelectDirOpts;
  chosenDirectory : string;
begin
  chosenDirectory := 'C:\';
  if SelectDirectory(chosenDirectory, options, 0)  then
  begin
    DirMidia := chosenDirectory;
    edtDirMidia.Text := DirMidia;
    RecarregarScript;
  end;
end;

procedure TForm_Configuracao.BitBtn_RecarregarScriptClick(Sender: TObject);
begin
  RecarregarScript;
end;

procedure TForm_Configuracao.BitBtn_RecriarScriptClick(Sender: TObject);
var
  SearchRec: TSearchRec;
  DosError, ItemIndex: Integer;
  i, j: Word;
begin
  if not DirectoryExists(DirMidia) then
    Application.MessageBox('O diret�rio de m�dia ainda n�o foi configurado ou est� incorreto. N�o � poss�vel recriar o Script de reprodu��o','Imposs�vel criar script de reprodu��o',MB_ICONERROR);

  if FileExists(DirMidia + '\Script.ini') then
    if Application.MessageBox('J� existe um Script de reprodu��o no diret�rio de m�dia. Tem certeza de que quer sobrescrev�-lo?','Tem certeza?',MB_ICONQUESTION or MB_YESNO) = IDYES then
    begin
      { Muda para o diret�rio de m�dias }
    	ChDir(DirMidia);

      with TIniFile.Create(DirMidia + '\Script.ini') do
        try
          { Remove a se��o de arquivos. Ela ser� recriada com arquivos
          posteriormente }
          EraseSection('ARQUIVOSDEMIDIA');

          DosError := FindFirst('*.*', 0, SearchRec);

          ItemIndex := 1;
          while DosError = 0 do
          begin
            for i := 1 to High(EXTENSOES_SUPORTADAS) do
              if AnsiUpperCase(ExtractFileExt(SearchRec.Name)) = EXTENSOES_SUPORTADAS[i] then
              begin
                for j := 1 to High(EXTENSOES_NORMAIS) do
                  if EXTENSOES_SUPORTADAS[i] = EXTENSOES_NORMAIS[j] then
                  begin
                    WriteString('ARQUIVOSDEMIDIA',Format('ARQ%.3d',[ItemIndex]),AnsiUpperCase(SearchRec.Name) + '|10');
                    Inc(ItemIndex);
                    Break;
                  end;

                { Caso n�o tenha achado na lista de extens�es normais tentar as
                extens�es temporizadas }
                if j = Succ(High(EXTENSOES_NORMAIS)) then
                  for j := 1 to High(EXTENSOES_TEMPORIZADAS) do
                    if EXTENSOES_SUPORTADAS[i] = EXTENSOES_TEMPORIZADAS[j] then
                    begin
                      WriteString('ARQUIVOSDEMIDIA',Format('ARQ%.3d',[ItemIndex]),AnsiUpperCase(SearchRec.Name) + '|0');
                      Inc(ItemIndex);
                      Break;
                      Break;
                    end;
              end;
            DosError := FindNext(SearchRec);
          end;
        finally
          FindClose(SearchRec);
          Free;
        end;
  RecarregarScript;
      Application.MessageBox('Script de reprodu��o Atualziado!','Feito!',MB_ICONINFORMATION);
    end;
end;

{ ESTE PROCEDIMENTO EST� OK }
procedure TForm_Configuracao.SpeedButton4Click(Sender: TObject);
var
  options : TSelectDirOpts;
  chosenDirectory : string;
begin
  chosenDirectory := 'C:\';
  if SelectDirectory(chosenDirectory, options, 0)  then
  begin
    DirLog := chosenDirectory;
    edtDirLog.Text := DirLog;
  end;
end;

{ ESTE PROCEDIMENTO EST� OK }
procedure TForm_Configuracao.ValidarArquivosDeMidia;
var
  i, NaoExistentes: Word;
  Arquivo: String;
begin
  NaoExistentes := 0;

  if FArquivosDeMidia.Count = 0 then
    raise Exception.Create('O script de reprodu��o n�o existe ou n�o cont�m arquivos');

  for i := 0 to Pred(FArquivosDeMidia.Count) do
  begin
    Arquivo := FArquivosDeMidia.ValueFromIndex[i];
    Arquivo := Copy(Arquivo,1,Pred(Pos('|',Arquivo)));

    if not FileExists(DirMidia + '\' + Arquivo) then
      Inc(NaoExistentes);
  end;

  if NaoExistentes =  FArquivosDeMidia.Count then
    raise Exception.Create('Nenhum arquivo da lista foi encontrado. N�o � poss�vel inicia a reprodu��o');
end;

{ ESTE PROCEDIMENTO EST� OK }
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

procedure TForm_Configuracao.Label_StatusClick(Sender: TObject);
begin

end;

{ ESTE PROCEDIMENTO EST� OK }
procedure TForm_Configuracao.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  if Assigned(Form_Player) and Assigned(Form_Player.FilterGraph) then
      Form_Player.Close;

  Action := caFree;  
end;

{ ESTE PROCEDIMENTO EST� OK }
procedure TForm_Configuracao.RecarregarScript;
begin

  FArquivosDeMidia.Clear;

  with TIniFile.Create(DirMidia + '\Script.ini') do
    try
      ReadSectionValues('ARQUIVOSDEMIDIA',FArquivosDeMidia);
    finally
      Free;
    end;

  ExibirConfiguracoes;
end;

{ ESTE PROCEDIMENTO EST� OK }
procedure TForm_Configuracao.RadioGroup_MonitorClick(Sender: TObject);
begin
  MonitorPrincipal := not Boolean(RadioGroup_Monitor.ItemIndex);
end;

{ ESTE PROCEDIMENTO EST� OK }
procedure TForm_Configuracao.ExibirConfiguracoes;
var
  i: Word;
  Arquivo, Duracao: String;
begin
  ListBox_Script.Items.Clear;

  if FArquivosDeMidia.Count > 0 then
    for i := 0 to Pred(FArquivosDeMidia.Count) do
    begin
      Arquivo := FArquivosDeMidia.ValueFromIndex[i];
      Duracao := Arquivo;

      Arquivo := Copy(Arquivo,1,Pred(Pos('|',Arquivo)));
      Duracao := Copy(Duracao,Succ(Pos('|',Duracao)),Length(Duracao));

      if Duracao = '0' then
        ListBox_Script.Items.Add(Arquivo)
      else
        ListBox_Script.Items.Add(Arquivo + ' (' + Duracao + ' segundos)');
    end;
end;

procedure TForm_Configuracao.FormCreate(Sender: TObject);
begin
  edtDirMidia.Text := DirMidia;
  edtDirLog.Text := DirLog;

  RadioGroup_Monitor.Enabled := Screen.MonitorCount = 2;

  if not RadioGroup_Monitor.Enabled then
    MonitorPrincipal := True;

  RadioGroup_Monitor.ItemIndex := Integer(not MonitorPrincipal);

  FArquivosDeMidia := TStringList.Create;

  FDiretorioDaAplicacao := ExtractFilePath(Application.ExeName);

  RecarregarScript;

  CFSHChangeNotifier_Principal.Root := DirMidia;

//  if ParamStr(1) = 'autoplay' then
//    btPlayList.Click;
end;

{ ESTE PROCEDIMENTO EST� OK }
procedure TForm_Configuracao.FormDestroy(Sender: TObject);
begin
  FArquivosDeMidia.Free;
  HabilitaBarraWin;
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

procedure TForm_Configuracao.FormMouseMove(Sender: TObject; Shift: TShiftState; X, Y: Integer);
begin
  ShowCursor(True);
end;

{ ESTE PROCEDIMENTO EST� OK }
procedure TForm_Configuracao.ConfigurarJanelaDeReproducao;
begin
  if Assigned(Form_Player) and Assigned(Form_Player.FilterGraph) then
  begin
    Form_Player.DiretorioLog     := DirLog;
    Form_Player.DiretorioMidia   := DirMidia;
    Form_Player.MonitorPrincipal := MonitorPrincipal;
    Form_Player.ArquivosDeMidia  := FArquivosDeMidia;

//    Form_Player.WindowState := wsMaximized;
  end;
end;

procedure CarregarConfiguracoes;
begin
  with TIniFile.Create(ExtractFilePath(Application.ExeName) + 'Config.ini') do
    try
      DirMidia := ReadString('CONFIGURACOES', 'MIDIA', '');
      DirLog := ReadString('CONFIGURACOES', 'LOGS', '');
      MonitorPrincipal := ReadBool('CONFIGURACOES','MONITORPRINCIPAL',True);
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
      WriteBool('CONFIGURACOES','MONITORPRINCIPAL',MonitorPrincipal);
    finally
      Free;
    end;
end;

procedure TForm_Configuracao.CFSHChangeNotifier_PrincipalChangeAttributes;
begin
//
end;

procedure TForm_Configuracao.CFSHChangeNotifier_PrincipalChangeDirName;
begin
//
end;

procedure TForm_Configuracao.CFSHChangeNotifier_PrincipalChangeFileName;
begin
//
end;

procedure TForm_Configuracao.CFSHChangeNotifier_PrincipalChangeLastWrite;
begin
//
end;

procedure TForm_Configuracao.CFSHChangeNotifier_PrincipalChangeSecurity;
begin
//
end;

procedure TForm_Configuracao.CFSHChangeNotifier_PrincipalChangeSize;
begin
//
end;

procedure TForm_Configuracao.ToolButton_PauseClick(Sender: TObject);
begin
  PausarPlaylist;
end;

initialization
  CarregarConfiguracoes;

finalization;
  SalvarConfiguracoes;

end.


