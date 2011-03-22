//******************************************************************************
//
//
//
//
//
//*****************************************************************************

unit uPrinc;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms,
  Dialogs, XPMan, StdCtrls, CommCtrl, ComCtrls, ExtCtrls, ToolWin, ImgList,
  Menus,  IdServerIOHandler, IdSSLOpenSSL, IdBaseComponent, IdComponent,
  IdTCPConnection, IdTCPClient, IdFTP, IdExplicitTLSClientServerBase,
  IdIOHandler, IdIOHandlerSocket, IdIOHandlerStack, IdSSL,
  Buttons, DB, DBClient, UFuncoes, FileCtrl;

type
  TfrmPrinc = class(TForm)
    Panel2:                         TPanel;
    Memo1:                          TRichEdit;
    Panel3:                         TPanel;
    btnImpLog:                      TSpeedButton;
    Panel4:                         TPanel;
    ListView1:                      TListView;
    Splitter1:                      TSplitter;
    ToolBar1:                       TToolBar;
    btnFechar:                      TToolButton;
    Panel1:                         TPanel;
    XPManifest1:                    TXPManifest;
    ProgressBar1:                   TProgressBar;
    imgLstMenu:                     TImageList;
    PopupMenu1:                     TPopupMenu;
    VerificarAtualizaes1:           TMenuItem;
    N1:                             TMenuItem;
    FinalizarAtualizador1:          TMenuItem;
    imgLista:                       TImageList;
    Abrir1:                         TMenuItem;
    IdFTP1:                         TIdFTP;
    IdSSLIOHandlerSocketOpenSSL1:   TIdSSLIOHandlerSocketOpenSSL;
    Timer1: TTimer;
    PastaLocal: TFileListBox;

    procedure IdFTP1WorkBegin(ASender: TObject; AWorkMode: TWorkMode;  AWorkCountMax: Integer);
    procedure IdFTP1Work(ASender: TObject; AWorkMode: TWorkMode; AWorkCount: Integer);
    procedure ListView1CustomDrawItem(Sender: TCustomListView; Item: TListItem; State: TCustomDrawState; var DefaultDraw: Boolean);
    procedure btnImpLogClick(Sender: TObject);
    procedure Memo1Change(Sender: TObject);
    procedure btnFecharClick(Sender: TObject);
    procedure FinalizarAtualizador1Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure VerificarAtualizaes1Click(Sender: TObject);
    procedure Timer1Timer(Sender: TObject);
  published
    procedure AddSysTrayIcon;
    procedure ShowBalloonTips(TipInfo, TipTitle: string);
    procedure DeleteSysTrayIcon;
    procedure SysTrayIconMsgHandler(var Msg: TMessage);
    procedure SalvarLog;
  private
    IconData: TNewNotifyIconData;
    Diretorios: TStringList;
  public
    procedure VerificaAtualizacoes;
    procedure ProcedeAtualizacoes(lsDirLocal,lsDirRemoto: TStringList);
    procedure LocalizaDeletaArquivosDesnecessarios(lsDirLocal,lsDirRemoto: TStringList);
    procedure ConectarFTP;
    function  LocalizaArquivo(IdFTPLocaliza:TIdFTP; NomeArquivo:String):Boolean;
    procedure AtualizaMPSDistEXE(lsDirLocal,  lsDirRemoto: TStringList);
    //procedure AddListView(CodOper:integer; Arquivo,TamanhoArquivo, DtArq: string);
  end;

var
  frmPrinc: TfrmPrinc;
  bytesToTransfer: integer;
  iArqExcluidos, iArqAtualizados, iArqNovos: integer;
  iArqEnviadosLixeira:String;

implementation

{$R *.DFM}

uses
  ShellAPI;

(*****************************************************************************)
(*                           Eventos do TtrayIcon                            *)
(*****************************************************************************)

procedure TfrmPrinc.SysTrayIconMsgHandler(var Msg: TMessage);
begin
  case Msg.lParam of
    WM_MOUSEMOVE:;
    WM_LBUTTONDOWN:;
    WM_LBUTTONUP:;
    WM_LBUTTONDBLCLK: frmPrinc.Show; // DuploClique (Show)
    WM_RBUTTONDOWN:;
    WM_RBUTTONUP: PopupMenu1.Popup(Mouse.CursorPos.X,Mouse.CursorPos.Y) ;
    WM_RBUTTONDBLCLK: ;
    NIN_BALLOONSHOW:;
    NIN_BALLOONHIDE:;
    NIN_BALLOONTIMEOUT:;
    NIN_BALLOONUSERCLICK:Self.Show;
  end;
end;

procedure TfrmPrinc.ShowBalloonTips(TipInfo, TipTitle: string);
begin
  IconData.cbSize := SizeOf(IconData);
  IconData.uFlags := NIF_INFO;
  strPLCopy(IconData.szInfo, TipInfo, SizeOf(IconData.szInfo) - 1);
  IconData.DUMMYUNIONNAME.uTimeout := 3000;
  strPLCopy(IconData.szInfoTitle, TipTitle, SizeOf(IconData.szInfoTitle) - 1);
  IconData.dwInfoFlags := NIIF_INFO;
  Shell_NotifyIcon(NIM_MODIFY, @IconData);
  IconData.DUMMYUNIONNAME.uVersion := NOTIFYICON_VERSION;
  Shell_NotifyIcon(NIM_SETVERSION, @IconData)
end;



procedure TfrmPrinc.AddSysTrayIcon;
begin
  IconData.cbSize := SizeOf(IconData);
  IconData.Wnd := AllocateHWnd(SysTrayIconMsgHandler);
  IconData.uID := 0;
  IconData.uFlags := NIF_ICON or NIF_MESSAGE or NIF_TIP;
  IconData.uCallbackMessage := TRAY_CALLBACK;
  IconData.hIcon := Application.Icon.Handle;
  IconData.szTip := 'Distribuidor de Aplicativos';
  Shell_NotifyIcon(NIM_ADD, @IconData);
end;

procedure TfrmPrinc.DeleteSysTrayIcon;
begin
  DeallocateHWnd(IconData.Wnd);
  Shell_NotifyIcon(NIM_DELETE, @IconData)
end;

procedure TfrmPrinc.btnFecharClick(Sender: TObject);
begin
  if MessageDlg('Tem certeza que deseja Finalizar o Aplicativo?', mtConfirmation, [mbYes, mbNo],0) = mrYes then
    Application.Terminate;
end;


procedure TfrmPrinc.ListView1CustomDrawItem(Sender: TCustomListView;  Item: TListItem; State: TCustomDrawState; var DefaultDraw: Boolean);
begin
 with ListView1.Canvas.Brush do
 begin
   if (Item.Index mod 2) = 0 then
     Color := $00DCFCDF // Verde Claro
   else
     Color := clWhite;
  end;
end;

procedure TfrmPrinc.Memo1Change(Sender: TObject);
begin
  btnImpLog.Enabled := Memo1.Lines.Count > 0;
end;

(******************************************************************************)
(*                                                                            *)
(******************************************************************************)

procedure TfrmPrinc.btnImpLogClick(Sender: TObject);
begin
  Memo1.Print('MPS Distribuidor de Aplicativos');
end;

procedure TfrmPrinc.FinalizarAtualizador1Click(Sender: TObject);
begin
  if MessageDlg('Tem certeza que deseja Finalizar o Aplicativo?', mtConfirmation, [mbYes, mbNo],0) = mrYes then
    Application.Terminate;
end;

procedure TfrmPrinc.VerificaAtualizacoes;

var
  i,s,a: integer;
  dtArq,
  TamanhoArquivoRemoto, TamanhoArquivoLocal,
  LinhaCaption: string;
  // Novas Variáveis
  NomeAplicativo: string;
  lsDirLocal,
  lsDirRemoto: TStringList;
begin

  // Varre todos os aplicativos
  for s:=0 to (Funcoes.iQtdeSistemas-1) do
  begin

    // Inicializa as variáveis de Contadores;
    iArqAtualizados := 0;
    iArqNovos       := 0;
    iArqExcluidos   := 0;
    iArqEnviadosLixeira:='';

    // Pega no Arquivo INI a Lista de Diretórios para atualizar
    lsDirLocal  := TStringList.Create;
    lsDirRemoto := TStringList.Create;
    Funcoes.ListaDir(IntToStr(s), NomeAplicativo,lsDirLocal,lsDirRemoto);

    if Funcoes.iAtualizaMPSDist = 'nao' then
       begin
       funcoes.TerminarProcesso('MPSDistC.exe');
       ProcedeAtualizacoes(lsDirLocal,lsDirRemoto)
       end
      else
      if Funcoes.ExecutavelRodando('MPSDistC.exe') then
       begin
       funcoes.TerminarProcesso('MPSDist.exe');
       AtualizaMPSDistEXE(lsDirLocal,lsDirRemoto);
       end;

    LocalizaDeletaArquivosDesnecessarios(lsDirLocal,lsDirRemoto);
    NomeAplicativo:=funcoes.Sistema[s+1];
    if iArqAtualizados > 0 then
       Memo1.Lines.Add('(' + DateTimeToStr(Now)+') '+IntToStr(iArqAtualizados) + ' arquivo(s) atualizados do ' + LowerCase(NomeAplicativo));
    if iArqNovos > 0 then
       Memo1.Lines.Add('(' + DateTimeToStr(Now)+') '+IntToStr(iArqNovos) + ' arquivo(s) foram adicionados ao sistema ' + LowerCase(NomeAplicativo));
    if iArqExcluidos > 0 then
       if iArqExcluidos = 1 then
          Memo1.Lines.Add('(' + DateTimeToStr(Now)+') '+ 'O arquivo : ' + (iArqEnviadosLixeira) + ' presente no sistema ' + LowerCase(NomeAplicativo) + ' foi enviado para a Lixeira.' )
       else
          Memo1.Lines.Add('(' + DateTimeToStr(Now)+') '+ 'Os arquivos : ' + (iArqEnviadosLixeira) + ' presentes no sistema ' + LowerCase(NomeAplicativo) + ' foram enviados para a Lixeira.' );
  end;


  ProgressBar1.Max := 0;

end;

procedure  TfrmPrinc.ConectarFTP;
var Teste:String;
begin
  try
    // Teste:=Funcoes.Cripto('mps$2008');
    IdSSLIOHandlerSocketOpenSSL1.SSLOptions.Method := sslvSSLv3;
    IdSSLIOHandlerSocketOpenSSL1.SSLOptions.Mode   := sslmBoth;
    IdSSLIOHandlerSocketOpenSSL1.Port := 21;
    idFTP1.IOHandler := IdSSLIOHandlerSocketOpenSSL1;
    idFTP1.UseTLS    := utUseExplicitTLS;
    idFTP1.Passive   := True;
    idFTP1.Host      := Funcoes.iIP;
    idFTP1.Username  := Funcoes.DesCripto(Funcoes.iLogin);
    idFTP1.Password  := Funcoes.DesCripto(Funcoes.iSenha);
    idFTP1.Connect;
    IdFTP1.List('*',True);
    IdSSLIOHandlerSocketOpenSSL1.StartSSL;
    MessageBeep(MB_ICONINFORMATION);
    if not idFTP1.Connected  then
       showmessage('Não conectado');
    ShowBalloonTips('Conectado ao IP ' + Funcoes.iIP, 'Distribuidor de Aplicativos');
    Memo1.Lines.Add('(' + TimeToStr(Now)+') Conectado ao IP ' + Funcoes.iIP);
    // Verifica se há Atualizações
    VerificaAtualizacoes;
  except
    on E: Exception do
      Memo1.Lines.Add('(' + TimeToStr(Now)+') Erro ao conectar o IP: ' + Funcoes.iIP + #13#10+E.Message);
  end;
end;

procedure TfrmPrinc.IdFTP1WorkBegin(ASender: TObject; AWorkMode: TWorkMode;
  AWorkCountMax: Integer);
begin
  //limpa a barra de progresso
  ProgressBar1.Position := 0;
  //define o tamanho máximo para o Gauge
  if AWorkCountMax > 0 then
    ProgressBar1.Max := AWorkCountMax
  else
    ProgressBar1.Max := bytesToTransfer;
end;

procedure TfrmPrinc.IdFTP1Work(ASender: TObject; AWorkMode: TWorkMode;  AWorkCount: Integer);
begin
  ProgressBar1.Position := AWorkCount;
end;

procedure TfrmPrinc.FormCreate(Sender: TObject);
begin
  // Cria a lista de Diretórios
{
  if fileExists(ExtractFilePath(Application.ExeName)+'MPSDistC.exe') then
     deletefile(ExtractFilePath(Application.ExeName)+'MPSDistC.exe');
}     
  Diretorios := TStringList.Create;
end;

procedure AddListView(CodOper:integer; Arquivo,TamanhoArquivo, DtArq: string);
  var
    ListItem : TListItem;
begin
    ListItem := frmPrinc.ListView1.Items.Add;
    ListItem.ImageIndex := CodOper;  // Imagem da Linha
    ListItem.Caption := Arquivo;
    ListItem.SubItems.Add( TamanhoArquivo + ' KB'); // Tamanho do Arquivo
    ListItem.SubItems.Add(DtArq); // Data do Arquivo
end;

procedure TfrmPrinc.ProcedeAtualizacoes(lsDirLocal,
  lsDirRemoto: TStringList);
Var
  i,s,a: integer;
  dtArq,
  LinhaCaption: string;
  // Novas Variáveis
  NomeAplicativo,   TamanhoArquivoRemoto, TamanhoArquivoLocal: string;
  ArquivoLocal: string;
begin

    for a:=0 to Pred(lsDirRemoto.Count) do
    begin
      IdFTP1.ChangeDir(lsDirRemoto[a]);
      IdFTP1.List('*.*',False);
      if not DirectoryExists(lsDirLocal[a]) then
        if not ForceDirectories(lsDirLocal[a]) then
        begin
          Memo1.Lines.Add( '(' + DateTimeToStr(Now) + ') Falha ao criar o Diretório "' + lsDirLocal[a] +'"');
          Exit;
        end;

      for i:=0 to pred(IdFTP1.ListResult.Count) do
      begin
        if ( idFTP1.Size(IdFTP1.ListResult.Strings[i]) < 1024 )and(idFTP1.Size(IdFTP1.ListResult.Strings[i]) > 0) then
             TamanhoArquivoRemoto:='1' else
             if idFTP1.Size(IdFTP1.ListResult.Strings[i]) = 0 then TamanhoArquivoRemoto:='0' else
                TamanhoArquivoRemoto := FormatFloat('###,###,##', idFTP1.Size(IdFTP1.ListResult.Strings[i]) div 1024);


        DateTimeToString(DtArq,'dd/mm/yyyy hh:mm', IdFTP1.FileDate(IdFTP1.ListResult.Strings[i]));

        if FileExists(lsDirLocal[a]+'\'+IdFTP1.ListResult.Strings[i]) then
        begin
            ArquivoLocal:= lsDirLocal[a]+'\'+IdFTP1.ListResult.Strings[i];


          if ( Funcoes.TamanhoArquivo(ArquivoLocal) < 1024 )and(Funcoes.TamanhoArquivo(ArquivoLocal) > 0) then
              TamanhoArquivoLocal:='1' else
              if Funcoes.TamanhoArquivo(ArquivoLocal) = 0 then TamanhoArquivoLocal:='0' else
                 TamanhoArquivoLocal := FormatFloat('###,###,##', Funcoes.TamanhoArquivo(ArquivoLocal) div 1024);

          // Compara a data do arquivo
          if Funcoes.DataArquivo(lsDirLocal[a]+'\'+IdFTP1.ListResult.Strings[i]) <> DtArq then
          begin
            bytesToTransfer := IdFTP1.Size(IdFTP1.ListResult.Strings[i]);
            try
               if not Funcoes.ExecutavelRodando(IdFTP1.ListResult.Strings[i]) then
                  begin
                   IdFTP1.Get(IdFTP1.ListResult.Strings[i], lsDirLocal[a]+'\'+IdFTP1.ListResult.Strings[i],True, False);
                   AddListView(1,lsDirLocal[a]+'\'+IdFTP1.ListResult.Strings[i],TamanhoArquivoRemoto,DtArq);
                   Funcoes.DefineDataHoraArq(lsDirLocal[a]+'\'+IdFTP1.ListResult.Strings[i],StrToDateTime(DtArq));
                   Inc(iArqAtualizados);
                  end
                 else
                   if  ( IdFTP1.ListResult.Strings[i] = 'MPSDist.exe') then begin
                         //IdFTP1.Get(IdFTP1.ListResult.Strings[i], lsDirLocal[a]+'\'+'MPSDistC.exe',True, False);
                         if not fileexists(lsDirLocal[a]+'\'+'MPSDistC.exe') then
                             IdFTP1.Get(IdFTP1.ListResult.Strings[i], lsDirLocal[a]+'\'+'MPSDistC.exe',True, False);
                         Funcoes.DefineDataHoraArq(lsDirLocal[a]+'\'+'MPSDistC.exe',StrToDateTime(DtArq));
                         Funcoes.SetaIniFile('opcoes','atualizampsdist','sim');
                         WinExec('MPSDistC.exe', SW_SHOW);
                         Application.Terminate;
                       end
                  else
                   Begin
                    ShowBalloonTips('Existem atualizações pendentes. Feche todos os módulos. '+ Funcoes.iIP, 'Distribuidor de Aplicativos');
                    showmessage('Existem atualizações pendentes. Feche todos os módulos. ');
                   end;
            except
              AddListView(4,lsDirLocal[a]+'\'+IdFTP1.ListResult.Strings[i],TamanhoArquivoRemoto,DtArq);
            end;
          end
         else
          if ( TamanhoArquivoLocal <> TamanhoArquivoRemoto ) then
             begin
               if not Funcoes.ExecutavelRodando(IdFTP1.ListResult.Strings[i]) then
                  begin
                   IdFTP1.Get(IdFTP1.ListResult.Strings[i], lsDirLocal[a]+'\'+IdFTP1.ListResult.Strings[i],True, False);
                   AddListView(1,lsDirLocal[a]+'\'+IdFTP1.ListResult.Strings[i],TamanhoArquivoRemoto,DtArq);
                   Funcoes.DefineDataHoraArq(lsDirLocal[a]+'\'+IdFTP1.ListResult.Strings[i],StrToDateTime(DtArq));
                   Inc(iArqAtualizados);
                  end
                 else
                   if  IdFTP1.ListResult.Strings[i] = 'MPSDist.exe'  then begin
                         //IdFTP1.Get(IdFTP1.ListResult.Strings[i], lsDirLocal[a]+'\'+'MPSDistC.exe',True, False);
                         if not fileexists(lsDirLocal[a]+'\'+'MPSDistC.exe') then
                             IdFTP1.Get(IdFTP1.ListResult.Strings[i], lsDirLocal[a]+'\'+'MPSDistC.exe',True, False);
                         Funcoes.DefineDataHoraArq(lsDirLocal[a]+'\'+'MPSDistC.exe',StrToDateTime(DtArq));
                         Funcoes.SetaIniFile('opcoes','atualizampsdist','sim');
                         WinExec('MPSDistC.exe', SW_SHOW);
                         Application.Terminate;
                      end
                  else
                   Begin
                    ShowBalloonTips('Existem atualizações pendentes. Feche todos os módulos. '+ Funcoes.iIP, 'Distribuidor de Aplicativos');
                    showmessage('Existem atualizações pendentes. Feche todos os módulos. ');
                   end;
             End;
          // comparar o tamanho dos arquivos
        end
        else //-> Se o Arquivo não Existir, cria.
        begin
         if  trim(IdFTP1.ListResult.Strings[i]) <> '' then begin
          bytesToTransfer := IdFTP1.Size(IdFTP1.ListResult.Strings[i]);
          try
            IdFTP1.Get(IdFTP1.ListResult.Strings[i],lsDirLocal[a]+'\'+IdFTP1.ListResult.Strings[i],True,False);
            Funcoes.DefineDataHoraArq(lsDirLocal[a]+'\'+IdFTP1.ListResult.Strings[i],StrToDateTime(DtArq));
            AddListView(1,lsDirLocal[a]+'\'+IdFTP1.ListResult.Strings[i],TamanhoArquivoRemoto,DtArq);
            inc(iArqNovos);
          except
            AddListView(4,lsDirLocal[a]+'\'+IdFTP1.ListResult.Strings[i],TamanhoArquivoRemoto,DtArq);
          end;
         end;
        end;
      end; // For i:=0 to pred(IdFTP1.ListResult.Count)
      if IdFTP1.RetrieveCurrentDir <> '/' then
        IdFTP1.ChangeDir('/');
    end; // for a:=0 to Pred(lsDirRemoto.Count)
  //
end;

procedure TfrmPrinc.AtualizaMPSDistEXE(lsDirLocal,
  lsDirRemoto: TStringList);
Var
  i,s,a: integer;
  dtArq,
  LinhaCaption: string;
  // Novas Variáveis
  NomeAplicativo,   TamanhoArquivoRemoto, TamanhoArquivoLocal: string;
  ArquivoLocal: string;
begin
    for a:=0 to Pred(lsDirRemoto.Count) do
    begin
      IdFTP1.ChangeDir(lsDirRemoto[a]);
      IdFTP1.List('*.*',False);

      if not DirectoryExists(lsDirLocal[a]) then
        if not ForceDirectories(lsDirLocal[a]) then
        begin
          Memo1.Lines.Add( '(' + DateTimeToStr(Now) + ') Falha ao criar o Diretório "' + lsDirLocal[a] +'"');
          Exit;
        end;
      
      for i:=0 to pred(IdFTP1.ListResult.Count) do
      begin
        if ( idFTP1.Size(IdFTP1.ListResult.Strings[i]) < 1024 )and(idFTP1.Size(IdFTP1.ListResult.Strings[i]) > 0) then
             TamanhoArquivoRemoto:='1' else
             if idFTP1.Size(IdFTP1.ListResult.Strings[i]) = 0 then TamanhoArquivoRemoto:='0' else
                TamanhoArquivoRemoto := FormatFloat('###,###,##', idFTP1.Size(IdFTP1.ListResult.Strings[i]) div 1024);


        DateTimeToString(DtArq,'dd/mm/yyyy hh:mm', IdFTP1.FileDate(IdFTP1.ListResult.Strings[i]));

        if FileExists(lsDirLocal[a]+'\'+IdFTP1.ListResult.Strings[i]) then
        begin
            ArquivoLocal:= lsDirLocal[a]+'\'+IdFTP1.ListResult.Strings[i];


          if ( Funcoes.TamanhoArquivo(ArquivoLocal) < 1024 )and(Funcoes.TamanhoArquivo(ArquivoLocal) > 0) then
              TamanhoArquivoLocal:='1' else
              if Funcoes.TamanhoArquivo(ArquivoLocal) = 0 then TamanhoArquivoLocal:='0' else
                 TamanhoArquivoLocal := FormatFloat('###,###,##', Funcoes.TamanhoArquivo(ArquivoLocal) div 1024);



          if  ( IdFTP1.ListResult.Strings[i] = 'MPSDist.exe') then begin
                //showmessage('teste MPSDist.exe');
                try
                  IdFTP1.Get(IdFTP1.ListResult.Strings[i], lsDirLocal[a]+'\'+IdFTP1.ListResult.Strings[i],True, False);
                except
                  //Funcoes.TerminarProcesso('MPSDist.exe');
                  IdFTP1.Get(IdFTP1.ListResult.Strings[i], lsDirLocal[a]+'\'+IdFTP1.ListResult.Strings[i],True, False);
                end;
                AddListView(1,lsDirLocal[a]+'\'+IdFTP1.ListResult.Strings[i],TamanhoArquivoRemoto,DtArq);
                Funcoes.DefineDataHoraArq(lsDirLocal[a]+'\'+IdFTP1.ListResult.Strings[i],StrToDateTime(DtArq));
                Funcoes.SetaIniFile('opcoes','atualizampsdist','nao');
                WinExec('MPSDist.exe', SW_SHOW);
                Application.Terminate;
           end;
         end;
      end; // For i:=0 to pred(IdFTP1.ListResult.Count)
      if IdFTP1.RetrieveCurrentDir <> '/' then
        IdFTP1.ChangeDir('/');
    end; // for a:=0 to Pred(lsDirRemoto.Count)
  //
end;

function TfrmPrinc.LocalizaArquivo(IdFTPLocaliza:TIdFTP; NomeArquivo:String):Boolean;
Var contador:integer;
    Retorno:Boolean;
Begin
  Retorno:=False;
  Contador:=0;
  While (Contador <= pred(IdFTPLocaliza.ListResult.Count) ) do
    Begin
      if  Uppercase(Trim(IdFTPLocaliza.ListResult.Strings[Contador])) = Uppercase(Trim(NomeArquivo)) Then
         Begin
          Retorno:=True;
          Break;
          exit;
         End;
      Contador:=Contador+1;
    End;
  Result:=Retorno;
End;


procedure TfrmPrinc.LocalizaDeletaArquivosDesnecessarios(lsDirLocal,lsDirRemoto: TStringList);
Var
  Cont, i,s,a: integer;
  dtArq,
  TamanhoArquivo,
  LinhaCaption: string;
  NomeAplicativo: string;
  Arquivo:String;
  Drive:String;
  //PastaLocal :TFileListBox;
begin

  // Cria a Lista
  //PastaLocal := TFileListBox.Create(owner);

  for a:=0 to Pred(lsDirRemoto.Count) do
  begin

    IdFTP1.ChangeDir(lsDirRemoto[a]);
    IdFTP1.List('*.*',False);

    Drive:=Copy(lsDirLocal[a],0,1);
    PastaLocal.Drive := Drive[1];
    PastaLocal.Directory := lsDirLocal[a];
    PastaLocal.Count;

    for Cont:=0 to (PastaLocal.Count-1) Do
    begin
      Arquivo:=PastaLocal.Items.Strings[Cont];
      if not LocalizaArquivo(IdFTP1, Arquivo) then
      begin
        // Verifica se o arquivo é do tipo ".ini"
        if ( LowerCase( Trim(Copy(Arquivo, length(Arquivo)-2,3)) ) <> 'ini' ) and
           ( LowerCase( Trim(Copy(Arquivo, length(Arquivo)-2,3)) ) <> 'log' ) then
           Begin
            //showmessage('teste arquivo' + arquivo);
            if Funcoes.ArquivoLixeira(lsDirLocal[a] +'\'+ Arquivo) then
                 Begin
                   inc(iArqExcluidos);
                   if trim(iArqEnviadosLixeira) <> '' then
                      iArqEnviadosLixeira:= iArqEnviadosLixeira + ' , ' + Arquivo
                     else
                      iArqEnviadosLixeira:=  Arquivo;
                  End
                else begin
                 //DeleteFile(lsDirLocal[a] +'\'+ Arquivo);
                 if (iArqExcluidos > 0) then
                   dec(iArqExcluidos);
                End; 
           End;
      end;
    end;
    if IdFTP1.RetrieveCurrentDir <> '/' then
     try
      IdFTP1.ChangeDir('/');
     except

     end;
  end; // for a:=0 to Pred(lsDirRemoto.Count)
  // Limpa a memória 
  //PastaLocal.Destroy;

end;

procedure TfrmPrinc.VerificarAtualizaes1Click(Sender: TObject);
begin

if not idFTP1.Connected then
    ConectarFTP
   else
    VerificaAtualizacoes;

end;

procedure TfrmPrinc.Timer1Timer(Sender: TObject);
begin

if not idFTP1.Connected then
    ConectarFTP
   else
    VerificaAtualizacoes;
    
end;

procedure TfrmPrinc.SalvarLog;
function  retirabarras(date:string):String;
var cont:integer;
    dateTemp:String;
begin
  dateTemp:=date;
  for cont:=1 to length(dateTemp)  do
      if (dateTemp[cont] = '/')or(dateTemp[cont] = '\') then
          delete(dateTemp,cont,1);

  date:=datetemp;
  retirabarras:=date;
end;
var
  NomeArrLog: string;
  I:integer;
  Linha:TStringList;
begin
  Linha:=TStringList.Create;
  Linha.Clear;
    NomeArrLog := ExtractFilePath(Application.ExeName) + 'mps '+ retirabarras( DateToStr(date) ) + '.log';
  try
    for I:= 0 to Memo1.Lines.Count do
        Linha.Add( Memo1.Lines.ValueFromIndex[I]);

    Linha.SaveToFile(NomeArrLog);
  except
   ;
  end;
end;

end.

