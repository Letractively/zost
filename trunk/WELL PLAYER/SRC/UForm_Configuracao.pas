unit UForm_Configuracao;

interface                

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ImgList, ComCtrls, ToolWin, StdCtrls, Buttons, AppEvnts, DsPack,
  ExtCtrls, FileCtrl, UCFSHChangeNotify, Inifiles;

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
    ListBox_Playlist: TListBox;
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
    Memo_Configuracoes: TMemo;
    PageControl_Principal: TPageControl;
    TabSheet_Playlist: TTabSheet;
    TabSheet_Configuracoes: TTabSheet;
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
    procedure CFSHChangeNotifier_PrincipalChangeAttributes;
    procedure CFSHChangeNotifier_PrincipalChangeDirName;
    procedure CFSHChangeNotifier_PrincipalChangeFileName;
    procedure CFSHChangeNotifier_PrincipalChangeLastWrite;
    procedure CFSHChangeNotifier_PrincipalChangeSecurity;
    procedure CFSHChangeNotifier_PrincipalChangeSize;
    procedure BitBtn_RecarregarScriptClick(Sender: TObject);
    procedure ToolButton_PauseClick(Sender: TObject);
  private
    { Private declarations }
    procedure FinalizarPlaylist;
    procedure IniciarPlaylist;
    procedure PausarPlaylist;
//    procedure WMDropFiles(var Msg: TMessage); message wm_DropFiles;
    procedure ListBoxDropFiles(var Msg: TWMDropFiles); message WM_DROPFILES;
    function ArquivoExiste(aFileName: String; aIniFile: TIniFile): Boolean;
    function ArquivosNoPlaylist(aIniFile: TIniFile): Cardinal;
    function CopiarParaDiretorioDeMidia(aFileName: String): Boolean;

  public
    { Public declarations }
    sLocalConf : string;
    FDiretorioDaAplicacao : String;
    FArquivosDeMidia     : TStringList;

    iCont : Integer;

    FFileName : String;

    procedure ValidarArquivosDeMidia;
    function isFolderEmpty(sPath : String) : Boolean ;

    procedure RecarregarScript;
    procedure ExibirConfiguracoes;
    procedure HabilitaBarraWin;
    procedure ConfigurarJanelaDeReproducao;
    function ExtensaoSuportada(aExtensao: String): Boolean;
    procedure AdicionarArquivo(aFileName: String; aIniFile: TIniFile = nil);
    procedure MemoDropFiles(var Msg: TWMDropFiles);
  end;

var
  Form_Configuracao: TForm_Configuracao;

implementation

{$R *.dfm}

uses UForm_Player, RTLConsts, shellapi;

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
      { Valida a existência de ao menos um arquivo visualizável }
      ValidarArquivosDeMidia;

      Form_Player := TForm_Player.Create(Self);

      { Ajusta o form de reprodução segundo configurações contidas aqui neste form.
      Dentro dele, no onShow, tais configurações precisam ser usadas }
      ConfigurarJanelaDeReproducao;

      { Exibe o form que internamente deve carregar as configurações e inicializar
      a reprodução }
      Form_Player.Show;
    except
      on E: Exception do
        ShowMessage('Não foi possível iniciar a reprodução.'#13#10 + E.Message);
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
  DosError: Integer;
  Ini: TIniFile;
begin
  if not DirectoryExists(DirMidia) then
    Application.MessageBox('O diretório de mídia ainda não foi configurado ou está incorreto. Não é possível recriar o Script de reprodução','Impossível criar script de reprodução',MB_ICONERROR);

  if FileExists(DirMidia + '\Script.ini') then
    if Application.MessageBox('Já existe um Script de reprodução no diretório de mídia. Tem certeza de que quer sobrescrevê-lo?','Tem certeza?',MB_ICONQUESTION or MB_YESNO) = IDYES then
    begin
      { Muda para o diretório de mídias }
    	ChDir(DirMidia);

      Ini := TIniFile.Create(DirMidia + '\Script.ini');
      try
        { Remove a seção de arquivos. Ela será recriada com arquivos
        posteriormente }
        Ini.EraseSection('ARQUIVOSDEMIDIA');

        DosError := FindFirst('*.*', 0, SearchRec);

        while DosError = 0 do
        begin
          AdicionarArquivo(SearchRec.Name, Ini);
          DosError := FindNext(SearchRec);
        end;
      finally
        FindClose(SearchRec);
        Ini.Free;
      end;

      RecarregarScript;
      Application.MessageBox('Script de reprodução Atualiaado!','Feito!',MB_ICONINFORMATION);
    end;
end;

{ ESTE PROCEDIMENTO ESTÁ OK }
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

{ ESTE PROCEDIMENTO ESTÁ OK }
procedure TForm_Configuracao.ValidarArquivosDeMidia;
var
  i, NaoExistentes: Word;
  Arquivo: String;
begin
  NaoExistentes := 0;

  if FArquivosDeMidia.Count = 0 then
    raise Exception.Create('O script de reprodução não existe ou não contém arquivos');

  for i := 0 to Pred(FArquivosDeMidia.Count) do
  begin
    Arquivo := FArquivosDeMidia.ValueFromIndex[i];
    Arquivo := Copy(Arquivo,1,Pred(Pos('|',Arquivo)));

    if not FileExists(DirMidia + '\' + Arquivo) then
      Inc(NaoExistentes);
  end;

  if NaoExistentes =  FArquivosDeMidia.Count then
    raise Exception.Create('Nenhum arquivo da lista foi encontrado. Não é possível inicia a reprodução');
end;

{ ESTE PROCEDIMENTO ESTÁ OK }
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

{ ESTE PROCEDIMENTO ESTÁ OK }
procedure TForm_Configuracao.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  if Assigned(Form_Player) and Assigned(Form_Player.FilterGraph) then
      Form_Player.Close;

  Action := caFree;  
end;

{ ESTE PROCEDIMENTO ESTÁ OK }
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

{ ESTE PROCEDIMENTO ESTÁ OK }
procedure TForm_Configuracao.RadioGroup_MonitorClick(Sender: TObject);
begin
  MonitorPrincipal := not Boolean(RadioGroup_Monitor.ItemIndex);
end;

{ ESTE PROCEDIMENTO ESTÁ OK }
procedure TForm_Configuracao.ExibirConfiguracoes;
var
  i: Word;
  Arquivo, Duracao: String;
begin
  ListBox_Playlist.Items.Clear;

  if FArquivosDeMidia.Count > 0 then
    for i := 0 to Pred(FArquivosDeMidia.Count) do
    begin
      Arquivo := FArquivosDeMidia.ValueFromIndex[i];
      Duracao := Arquivo;

      Arquivo := Copy(Arquivo,1,Pred(Pos('|',Arquivo)));
      Duracao := Copy(Duracao,Succ(Pos('|',Duracao)),Length(Duracao));

      if Duracao = '0' then
        ListBox_Playlist.Items.Add(Arquivo)
      else
        ListBox_Playlist.Items.Add(Arquivo + ' (' + Duracao + ' segundos)');
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

  DragAcceptFiles(Handle, true);

//  if ParamStr(1) = 'autoplay' then
//    btPlayList.Click;

  { TODO -oWELLINGTON : A aba que mostra o código do INI permanecerá oculta até
  você começar a implementar o seu uso e o arrasto sobre ela. Quando acabar,
  remova a linha abaixo }
//  TabSheet_Configuracoes.TabVisible := False;
end;

{ ESTE PROCEDIMENTO ESTÁ OK }
procedure TForm_Configuracao.FormDestroy(Sender: TObject);
begin
  FArquivosDeMidia.Free;
  HabilitaBarraWin;
  DragAcceptFiles(Handle, false);
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

{ ESTE PROCEDIMENTO ESTÁ OK }
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

function TForm_Configuracao.CopiarParaDiretorioDeMidia(aFileName: String): Boolean;
var
  Dados: TSHFileOpStruct;
  origem, destino: String;
begin
  { TODO -oWELLINGTON : Implementa aqui a lógica para copiar o arquivo cujo
  caminho completo é passado no parâmetro, para o diretório de mídias do
  WellPlayer. O diretório de mídias é DirMidia. Caso consiga copiar com sucesso
  retorna True, do contrario False. Esta função não deve lançar exceções. }

      origem  := aFileName;
      destino := DirMidia;

      If (origem <> '') and (destino <> '') then
      begin
        FillChar(Dados,SizeOf(Dados), 0);
        with Dados do
        begin
          wFunc := FO_COPY;
          pFrom := PChar(origem);
          pTo   := PChar(destino);
          fFlags:= FOF_ALLOWUNDO;
        end;
        SHFileOperation(Dados);
        Result := True;
      end
      else
        Result := False;
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

procedure TForm_Configuracao.ListBoxDropFiles(var Msg: TWMDropFiles);
var
  i, PathLength, FileCount : Cardinal;
  Buffer, FullFileName : string;
  JaPerguntou, ConseguiuCopiar: Boolean;
  Msg_m: TWMDropFiles;
begin
  { TODO -oWELLINGTON : Como se pode ver, este procedure funciona apenas para o
  listbox. Cria um novo procedure exatamente igual a este, mas com o nome
  "MemoDropFiles" e altera ali onde tem "ListBox_Playlist". A maior parte da
  lógica, se não for toda ela mesmo, deve ser colocada entre os delimitadores
  mais adiante (O que fazer com FullFileName? INICIO e FINAL) }

  if WindowFromPoint(Mouse.CursorPos) = Memo_Configuracoes.Handle then
    MemoDropFiles(Msg);
 
  if WindowFromPoint(Mouse.CursorPos) = ListBox_Playlist.Handle then
    begin

      FileCount := DragQueryFile(Msg.Drop, $FFFFFFFF, nil, MAX_PATH);

      if FileCount = 0 then
        raise Exception.Create('Nenhum arquivo selecionado!');

      SetLength(Buffer, MAX_PATH * 2);

      JaPerguntou := False;

      for i := 0 to Pred(FileCount) do
      begin
        PathLength := DragQueryFile(Msg.Drop, i, nil, MAX_PATH * 2);

        if (PathLength > 0) and (PathLength < MAX_PATH * 2) then
        begin
          if DragQueryFile(Msg.Drop, i, @Buffer[1], Succ(PathLength)) = PathLength then
          begin
            FullFileName := Copy(Buffer, 1, PathLength);
            { -- O que fazer com FullFileName? INICIO -------------------------- }

            if ExtensaoSuportada(ExtractFileExt(FullFileName)) then
            begin
              ConseguiuCopiar := True;

              if (ExtractFilePath(FullFileName) <> DirMidia) then
              begin
                if not JaPerguntou then
                begin
                  if Application.MessageBox('Os arquivos selecionados não estão no diretório de mídias do Well Player. Se você continuar, estes arquivos serão copiados neste diretório de mídias. Tem certeza?','Tem certeza?',MB_ICONQUESTION or MB_YESNO) = IDNO then
                    Abort;

                  JaPerguntou := True;
                end;

                ConseguiuCopiar := CopiarParaDiretorioDeMidia(FullFileName);
              end;

              if ConseguiuCopiar then
                AdicionarArquivo(ExtractFileName(FullFileName));
            end;

            { -- O que fazer com FullFileName? FINAL --------------------------- }
          end;
        end;
      end;
      RecarregarScript;
    end;

    DragFinish(Msg.Drop);
    Msg.Result := 0;
end;


{ TODO -oWELLINGTON : O Código antigo está embaixo. Mantive ele comentado pra
que você pudesse aproveitar algo relacionado ao memo. Recria o mesmo procedure
acima, com um nome diferente, e que vai manipular os drops no memo apenas. veja
o comentário que eu coloquei no primeiro IF do procedure acima }

//procedure TForm_Configuracao.WMDropFiles(var Msg: TMessage);
//var
//  I, FileCount, BufferSize: word;
//  Drop: HDROP;
//  FileName: string;
//  Pt: TPoint;
//  RctListBox, RctMemo: TRect;
//  sAux : String;
//begin
//  { Pega o manipulador (handle) da operação
//    "arrastar e soltar" (drag-and-drop) }
//  Drop := Msg.wParam;
//
//  { Pega a quantidade de arquivos soltos (dropped) }
//  FileCount := DragQueryFile(Drop, $FFFFFFFF, nil, 0);
//
//  { Se nenhum arquivo... }
//  if FileCount = 0 then begin
//    ShowMessage('Nenhum arquivo.');
//    Exit;
//  end;
//
//  { Pega o retângulo do ListBox }
//  RctListBox := ListBox_Script.BoundsRect;
//
//  { Pega o retângulo do Memo }
//  RctMemo := Memo_Configuracoes.BoundsRect;
//
//  { Se soltou fora da área cliente do form... }
//  if not DragQueryPoint(Drop, Pt) then
//    ShowMessage('Arquivos soltos fora da área cliente do form')
//  { Se soltou na área do ListBox... }
//  else if PtInRect(RctListBox, Pt) then begin
//    { Pega todos os nomes de arquivos e coloca no ListBox }
//    for I := 0 to FileCount -1 do begin
//      { Obtém o comprimento necessário para o nome do arquivo,
//        sem contar o caractere nulo do fim da string. }
//      BufferSize := DragQueryFile(Drop, I, nil, 0);
//      SetLength(FileName, BufferSize +1); { O +1 é p/ nulo do fim da string }
//      if DragQueryFile(Drop, I, PChar(FileName), BufferSize+1) = BufferSize then
//      begin
//        sAux := ExtractFileExt(string(PChar(FileName)));
//
//        p_ValidaExtensao(UpperCase(sAux));
//        // se passou, insere em FArquivosDeMidia
//        FArquivosDeMidia.Add(ExtractFileName(string(PChar(FileName))));
//        // se passou, insere no arquivo
//        p_InsereArquivoIni(ExtractFileName(string(PChar(FileName))),UpperCase(sAux));
//
//        ListBox_Script.Items.Add(ExtractFileName(string(PChar(FileName))));
//      end
//      else
//        ShowMessage('Erro ao obter nome do arquivo.');
//    end;
//  { Se soltou na área do Memo... }
//  end else if PtInRect(RctMemo, Pt) then begin
//    if FileCount > 1 then
//      ShowMessage('Será mostrado apenas o conteúdo do primeiro arquivo.');
//
//    { Obtém o comprimento necessário para o nome do arquivo,
//      sem contar o caractere nulo do fim da string.
//      O segundo parâmetro (zero) indica o primeiro arquivo da lista }
//    BufferSize := DragQueryFile(Drop, 0, nil, 0);
//    SetLength(FileName, BufferSize +1); { O +1 é p/ nulo do fim da string }
//    if DragQueryFile(Drop, 0, PChar(FileName), BufferSize+1) = BufferSize then
//      Memo_Configuracoes.Lines.LoadFromFile(string(PChar(FileName)))
//    else
//      ShowMessage('Erro ao obter nome do arquivo.');
//  end;
//
//  Msg.Result := 0;
//
//end;

function TForm_Configuracao.ExtensaoSuportada(aExtensao: String): Boolean;
var
  i: Integer;
begin
  Result := False;

  for i := 1 to High(EXTENSOES_SUPORTADAS) do
  begin
    if UpperCase(aExtensao) = EXTENSOES_SUPORTADAS[i] then
    begin
      Result := True;
      Break;
    end;
  end;
end;

function TForm_Configuracao.ArquivoExiste(aFileName: String; aIniFile: TIniFile): Boolean;
var
  SectionValues: TStringList;
begin
  SectionValues := TStringList.Create;
  try
    aIniFile.ReadSectionValues('ARQUIVOSDEMIDIA',SectionValues);

    SectionValues.Text := AnsiUpperCase(SectionValues.Text);

    Result := Pos('=' + AnsiUpperCase(aFileName) + '|',SectionValues.Text) > 0;
  finally
    SectionValues.Free;
  end;
end;

function TForm_Configuracao.ArquivosNoPlaylist(aIniFile: TIniFile): Cardinal;
var
  SectionValues: TStringList;
begin
  SectionValues := TStringList.Create;
  try
    aIniFile.ReadSectionValues('ARQUIVOSDEMIDIA',SectionValues);

    Result := SectionValues.Count;

  finally
    SectionValues.Free;
  end;
end;

procedure TForm_Configuracao.AdicionarArquivo(aFileName: String; aIniFile: TIniFile = nil);
var
  i, j: Word;
  PrecisaDestruir: Boolean;
begin
  PrecisaDestruir := False;

  if not Assigned(aIniFile) then
  begin
    aIniFile := TIniFile.Create(DirMidia + '\Script.ini');
    PrecisaDestruir := True;
  end;

  { Verifica se já existe a entrada no ini }
  if ArquivoExiste(aFileName,aIniFile) then
    Exit;

  for i := 1 to High(EXTENSOES_SUPORTADAS) do
    if AnsiUpperCase(ExtractFileExt(aFileName)) = EXTENSOES_SUPORTADAS[i] then
    begin
      { Se for uma extensão estática... }
      for j := 1 to High(EXTENSOES_NORMAIS) do
        if EXTENSOES_SUPORTADAS[i] = EXTENSOES_NORMAIS[j] then
        begin
          aIniFile.WriteString('ARQUIVOSDEMIDIA',Format('ARQ%.3d',[Succ(ArquivosNoPlaylist(aIniFile))]),AnsiUpperCase(aFileName) + '|10');
          Break;
        end;

      { Caso não tenha achado na lista de extensões estáticas tentar as
      extensões temporizadas }
      if j = Succ(High(EXTENSOES_NORMAIS)) then
        for j := 1 to High(EXTENSOES_TEMPORIZADAS) do
          if EXTENSOES_SUPORTADAS[i] = EXTENSOES_TEMPORIZADAS[j] then
          begin
            aIniFile.WriteString('ARQUIVOSDEMIDIA',Format('ARQ%.3d',[Succ(ArquivosNoPlaylist(aIniFile))]),AnsiUpperCase(aFileName) + '|0');
            Break;
          end;

      { Ao encontrar a extensão suportada, não faz mais nada }
      Break;
    end;

  if PrecisaDestruir then
    aIniFile.Free;
end;


procedure TForm_Configuracao.MemoDropFiles(var Msg: TWMDropFiles);
var
  i, PathLength, FileCount : Cardinal;
  Buffer, FullFileName : string;
  JaPerguntou, ConseguiuCopiar: Boolean;
begin
  { TODO -oWELLINGTON : Como se pode ver, este procedure funciona apenas para o
  listbox. Cria um novo procedure exatamente igual a este, mas com o nome
  "MemoDropFiles" e altera ali onde tem "ListBox_Playlist". A maior parte da
  lógica, se não for toda ela mesmo, deve ser colocada entre os delimitadores
  mais adiante (O que fazer com FullFileName? INICIO e FINAL) }

  if WindowFromPoint(Mouse.CursorPos) = Memo_Configuracoes.Handle then
  begin

    FileCount := DragQueryFile(Msg.Drop, $FFFFFFFF, nil, MAX_PATH);

    if FileCount = 0 then
      raise Exception.Create('Nenhum arquivo selecionado!');

    SetLength(Buffer, MAX_PATH * 2);

    JaPerguntou := False;

    for i := 0 to Pred(FileCount) do
    begin
      PathLength := DragQueryFile(Msg.Drop, i, nil, MAX_PATH * 2);

      if (PathLength > 0) and (PathLength < MAX_PATH * 2) then
      begin
        if DragQueryFile(Msg.Drop, i, @Buffer[1], Succ(PathLength)) = PathLength then
        begin
          FullFileName := Copy(Buffer, 1, PathLength);
          { -- O que fazer com FullFileName? INICIO -------------------------- }

           if UpperCase(ExtractFileName(string(PChar(FullFileName)))) <> 'SCRIPT.INI' then exit;

           Memo_Configuracoes.Lines.LoadFromFile(string(PChar(FullFileName)))
          { -- O que fazer com FullFileName? FINAL --------------------------- }
        end;
      end;
    end;
    RecarregarScript;
  end;

  DragFinish(Msg.Drop);
  Msg.Result := 0;

end;

initialization
  CarregarConfiguracoes;

finalization;
  SalvarConfiguracoes;

end.


