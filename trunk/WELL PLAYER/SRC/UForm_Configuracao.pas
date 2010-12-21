unit UForm_Configuracao;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ImgList, ComCtrls, ToolWin, StdCtrls, Buttons, AppEvnts, DsPack,
  ExtCtrls, FileCtrl;

type
  TForm_Configuracao = class(TForm)
    ToolBar_Principal: TToolBar;
    ToolButton_Play: TToolButton;
    ToolButton_Pause: TToolButton;
    ToolButton_Stop: TToolButton;
    ToolButton_Separador1: TToolButton;
    ToolButton_Fechar: TToolButton;
    ImageList_ToolBar: TImageList;
    btPlayList: TBitBtn;
    ApplicationEvents1: TApplicationEvents;
    edtDirMidia: TLabeledEdit;
    rgMidia: TRadioGroup;
    Label4: TLabel;
    ListBox_Script: TListBox;
    OpenDialog1: TOpenDialog;
    SpeedButton2: TSpeedButton;
    BitBtn_RecriarScript: TBitBtn;
    edtDirLog: TLabeledEdit;
    SpeedButton4: TSpeedButton;
    Label_Status: TLabel;
    Label1: TLabel;
    procedure ToolButton_PlayClick(Sender: TObject);
    procedure btPlayListClick(Sender: TObject);
    procedure ToolButton_PauseClick(Sender: TObject);
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
    procedure rgMidiaClick(Sender: TObject);
    procedure Label_StatusClick(Sender: TObject);
  private
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

uses UForm_Player, Inifiles, RTLConsts;

var
  DirMidia: String;
  DirLog: String;
  MonitorPrincipal: Boolean;

{$R *.dfm}

procedure TForm_Configuracao.ToolButton_PlayClick(Sender: TObject);
begin

   if Form_Player = nil then exit;

   if Form_Player.FilterGraph <> nil then begin

     with Form_Player do begin
         if (TipoArq = 'BMP') or
            (TipoArq = 'JPG') or
            (TipoArq = 'ICO')  then begin
             Timer2.Enabled := True
         end
         else begin
           if (TipoArq = 'SWF') then begin
             Timer1.Enabled := True;
             if ShockwaveFlash_SWF.Playing = False then begin
               ShockwaveFlash_SWF.Playing;
               ShockwaveFlash_SWF.Play;
             end;
           end
           else begin
             if FilterGraph.State = gsUninitialized then
               btPlayListClick(self)
             else
               FilterGraph.Play;
           end;  //if (TipoArq = 'SWF')
         end; //if (TipoArq = 'BMP' or ...)
     end; //with Form_Player do begin
   end
   else
     btPlayListClick(self);
end;

procedure TForm_Configuracao.btPlayListClick(Sender: TObject);
begin
  ValidarArquivosDeMidia;

  try
    if Assigned(Form_Player) then
      if Assigned(Form_Player.FilterGraph) and (Form_Player.FilterGraph.State <> gsUninitialized) then
        Exit;

    Form_Player := TForm_Player.Create(Self);

    { Ajusta o form de reprodução segundo configurações contidas aqui neste form.
    Dentro dele, no onShow, tais configurações precisam ser usadas }
    ConfigurarJanelaDeReproducao;

    { Exibe o form que internamente deve carregar as configurações e inicializar
    a reprodução }
    Form_Player.Show;

  except
    on E: Exception do
      ShowMessage('Não foi possível iniciar o SlideShow.'#13#10 + E.Message);
  end;
end;

procedure TForm_Configuracao.ToolButton_PauseClick(Sender: TObject);
begin
  if Assigned(Form_Player) and Assigned(Form_Player.FilterGraph) then begin
     with Form_Player do begin
         if (TipoArq = 'BMP') or
            (TipoArq = 'JPG') or
            (TipoArq = 'ICO') or
            (TipoArq = 'GIF') or
            (TipoArq = 'PNG') then begin
           Timer2.Enabled := False
         end
         else begin
           if (TipoArq = 'SWF') then begin
             Timer1.Enabled := False;
             if ShockwaveFlash_SWF.Playing = True then begin
               ShockwaveFlash_SWF.Playing := False;
               ShockwaveFlash_SWF.StopPlay;
               ShockwaveFlash_SWF.Stop;
             end;
           end
           else begin
             if FilterGraph.State = gsUninitialized then
               btPlayListClick(self)
             else
               FilterGraph.Pause;
           end;  //if (TipoArq = 'SWF')
         end; //if (TipoArq = 'BMP' or ...)
     end; //with Form_Player do begin

    {Form_Player.FilterGraph.Pause;
    if Form_Player.ShockwaveFlash1.Playing = True then
      Form_Player.ShockwaveFlash1.Playing := False;
     }
  end;
end;

procedure TForm_Configuracao.ToolButton_StopClick(Sender: TObject);
begin
  if Assigned(Form_Player) and Assigned(Form_Player.FilterGraph) then
    Form_Player.FilterGraph.Stop;
end;

procedure TForm_Configuracao.ApplicationEvents1Idle(Sender: TObject; var Done: Boolean);
var
  S : Array[0..255] of Char;
begin
  if Form_Player <> nil then begin

     Label_Status.Caption := '    '+ Form_Player.Tempo ;
{     StrPCopy(S, Form_Player.Arquivo);
     with ListBox_Script do
       ItemIndex := Perform(LB_SELECTSTRING, 0, LongInt(@S));
     exit;
 }

    {
    if Form_Player.FilterGraph = nil then begin
      Label_Status.Caption := '';
       //ListBox1.Clear;
    end
    else
    begin

       if Form_Player.ShockwaveFlash1.Playing then begin

       end;

       if (Form_Player.FilterGraph.State = gsUninitialized) then begin
         Label_Status.Caption := '    '+ Form_Player.Tempo ;
         StrPCopy(S, Form_Player.Arquivo);
         with ListBox_Script do
           ItemIndex := Perform(LB_SELECTSTRING, 0, LongInt(@S));
         exit;
       end;

      if (Form_Player.FilterGraph.State = gsStopped) or
         (Form_Player.FilterGraph.State = gsPaused) or
         (Form_Player.FilterGraph.State = gsPlaying)  then begin
        Label_Status.Caption := '    '+ Form_Player.Tempo ;

        StrPCopy(S, Form_Player.Arquivo);
        with ListBox_Script do
          ItemIndex := Perform(LB_SELECTSTRING, 0, LongInt(@S));
        end;

      end;
       }
    end
    else begin
//      Label_Status.Caption := '';
    end;

end;

procedure TForm_Configuracao.ToolButton_FecharClick(Sender: TObject);
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
  begin
    DirMidia := chosenDirectory;
    edtDirMidia.Text := DirMidia;
    RecarregarScript;
  end;
end;

procedure TForm_Configuracao.BitBtn_RecriarScriptClick(Sender: TObject);
//var
//  sDirMidia, sDirLog : String;
//  ArqIni, ArqMidia, ArqLog : string;
//  LocalIni,  local: TextFile;
begin
  if not DirectoryExists(DirMidia) then
    Application.MessageBox('O diretório de mídia ainda não foi configurado. Não é possível recriar o Script de reprodução','Impossível criar script de reprodução',MB_ICONERROR);

{  if FileExists(DirMidia + '\Script.ini') then
    if Application.MessageBox('Já existe um Script de reprodução no diretório de mídia. Tem certeza de que quer sobrescrevê-lo?','Tem certeza?',MB_ICONQUESTION or MB_YESNO) = IDNO then
     Exit;
     }
//  if Trim(edtDirMidia.Text) = '' then
//    raise Exception.Create('Informe o local dos Arquivos de Mídia.');
//  if Trim(edtDirLog.Text) = '' then
//    raise Exception.Create('Informe o local do Arquivo de Log.');
//
//  if not DirectoryExists(Trim(edtDirMidia.Text)) then
//    raise Exception.Create('O diretório informado nãoe existe: ' +Trim(edtDirMidia.Text));
//  if not DirectoryExists(Trim(edtDirLog.Text)) then
//    raise Exception.Create('O diretório informado nãoe existe: ' +Trim(edtDirLog.Text));
//
//  sDirMidia := edtDirMidia.Text;
//  sDirLog   := edtDirLog.Text;
//
//  ArqMidia := sDirMidia;
//  ArqLog   := sDirLog;
//
//
//  sLocalConf := FDiretorioDaAplicacao + '\Config.ini';
//
//  if FileExists(sLocalConf) then  //Verifica se existe o arquivo, deletando se existir
//    DeleteFile(sLocalConf);
//
//  AssignFile(Local, ArqIni);
//
//  if not FileExists(sLocalConf) then
//  begin
//    Rewrite(Local, sLocalConf);
//    Append(Local); //Cria o arquivo
//    WriteLn(Local, '[INI]');
//    WriteLn(Local, 'arq000='+aRQIni);
//
//    WriteLn(Local, '[MIDIA]');
//    WriteLn(Local, 'arq001='+aRQmidia);
//
//    WriteLn(Local, '[LOG]');
//    WriteLn(Local, 'arq002='+arqlog);
//
//  end;
//
//  CloseFile(Local);
//
//  // cria arquivo INI
//  if  Trim(ArqIni) <> '' then
//    if not FileExists(ArqIni+'\Script.ini') then  //Verifica se existe o arquivo, abrindo se existir
//    begin
//      AssignFile(LocalIni, ArqIni+'\Script.ini');
//      Rewrite(LocalIni);
//      WriteLn(LocalIni, '[ARQUIVOSDEMIDIA]');
//      WriteLn(LocalIni, 'ARQ000=nome do arquivo, com a extenção, seguido de |9. Ex: som_do_ceu.flv|9 ');
//      WriteLn(LocalIni, 'ARQ001=nome do arquivo, com a extenção, seguido de |9. Ex: outro_som.flv|9 ');
//      CloseFile(LocalIni);
//    end;
//
  RecarregarScript;
  Application.MessageBox('Script de reprodução Atualizado!','Feito!',MB_ICONINFORMATION);
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

procedure TForm_Configuracao.Label_StatusClick(Sender: TObject);
begin

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
procedure TForm_Configuracao.rgMidiaClick(Sender: TObject);
begin
  MonitorPrincipal := not Boolean(rgMidia.ItemIndex);
end;

{ ESTE PROCEDIMENTO ESTÁ OK }
procedure TForm_Configuracao.ExibirConfiguracoes;
var
  i: Word;
  Arquivo, sTempo: String;
begin
  ListBox_Script.Items.Clear;

  if FArquivosDeMidia.Count > 0 then
    for i := 0 to Pred(FArquivosDeMidia.Count) do
    begin
      Arquivo := Copy(FArquivosDeMidia[i],Succ(Pos('=',FArquivosDeMidia[i])), Length(FArquivosDeMidia[i]));
      sTempo   := Arquivo;

      Arquivo := Copy(Arquivo,1,Pred(Pos('|',Arquivo)));
      sTempo := Copy(sTempo,Succ(Pos('|',sTempo)),Length(sTempo));

      if sTempo = '0' then
        ListBox_Script.Items.Add(Arquivo)
      else
        ListBox_Script.Items.Add(Arquivo);// + ' (' + sTempo + ' segundos)');
    end;
end;

procedure TForm_Configuracao.FormCreate(Sender: TObject);
begin
  edtDirMidia.Text := DirMidia;
  edtDirLog.Text := DirLog;

  rgMidia.Enabled := Screen.MonitorCount = 2;

  if not rgMidia.Enabled then
    MonitorPrincipal := True;

  rgMidia.ItemIndex := Integer(not MonitorPrincipal);

  FArquivosDeMidia := TStringList.Create;

  FDiretorioDaAplicacao := ExtractFilePath(Application.ExeName);

  RecarregarScript;
end;

{ ESTE PROCEDIMENTO ESTÁ OK }
procedure TForm_Configuracao.FormDestroy(Sender: TObject);
begin
  // Não é necessário fazer isso aqui porque as variáveis são manipuladas sempre
  // e os campos visuais (Edits) apenas as seguem
//  DirMidia := Form_Configuracao.edtDirMidia.Text;
//  DirLog := Form_Configuracao.edtDirLog.Text;

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

{ ESTE PROCEDIMENTO ESTÁ OK }
procedure TForm_Configuracao.ConfigurarJanelaDeReproducao;
begin
  if Assigned(Form_Player) and Assigned(Form_Player.FilterGraph) then
  begin
    Form_Player.DiretorioLog     := DirLog;
    Form_Player.DiretorioMidia   := DirMidia;
    Form_Player.MonitorPrincipal := MonitorPrincipal;
    Form_Player.ArquivosDeMidia  := FArquivosDeMidia;
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

initialization
  CarregarConfiguracoes;

finalization;
  SalvarConfiguracoes;

end.


