{ TODO -oCARLOS FEITOZA -cMELHORIA : Trocar todas as strings constantes por
aquelas que estão configuradas. VerIfique que estão sendo usadas strings
incompletas, por exemplo, [AT+CMGL="] como indicador de inicio de um packet, mas
na verdade deveriamos usar de alguma forma a string que está configurada no INI
pois este comando pode ser usado com 4 parametros distintos. Ao usar [AT+CMGL="]
de qual comando estamos falando? e além disso, quem garante que o comando é
sempre este? }
unit UDataModule_Principal;

interface

uses
  SysUtils, Classes, ExtCtrls, DB, ZAbstractRODataset, ZDataset, ZConnection,
  CPort;

type
  TDataModule_Principal = class(TDataModule)
    CONNECTION: TZConnection;
    QUERY: TZReadOnlyQuery;
    ComPort_Modem: TComPort;
    ComDataPacket_REC: TComDataPacket;
    ComDataPacket_REC2: TComDataPacket;
    Timer_Verificacoes: TTimer;
    procedure ComDataPacket_RECPacket(Sender: TObject; const Str: string);
    procedure ComDataPacket_RECCustomStart(Sender: TObject; const Str: string; var Pos: Integer);
    procedure ComDataPacket_RECCustomStop(Sender: TObject; const Str: string; var Pos: Integer);
    procedure ComDataPacket_REC2CustomStart(Sender: TObject; const Str: string; var Pos: Integer);
    procedure ComDataPacket_REC2CustomStop(Sender: TObject; const Str: string; var Pos: Integer);
    procedure ComDataPacket_REC2Packet(Sender: TObject; const Str: string);
    procedure Timer_VerificacoesTimer(Sender: TObject);
  private
    { Private declarations }
    procedure ProcessarMensagens(aMensagens: String);
    procedure SalvarLogDeErro(aMetodo, aErro: String);
  public
    { Public declarations }
    procedure CarregarComboDeProtocolos;
    procedure ObterMensagens(aAguardar: Byte);
    procedure WriteString(aComando: String);
  end;

var
  DataModule_Principal: TDataModule_Principal;

implementation

{$R *.dfm}

uses UForm_Principal, ZDbcIntfs, ZClasses, Types, Messages, Windows, Masks,
     StrUtils, UConfiguracoes, ComCtrls, Forms;

type
  TMessage = record
    Index: Word;
    From: String;
    Date: String;
    Message: String;
  end;

procedure TDataModule_Principal.CarregarComboDeProtocolos;
var
  i, j: Integer;
  Drivers: IZCollection;
  Protocols: TStringDynArray;
begin
  Form_Principal.ComboBox_Protocolo.Clear;
  Drivers := DriverManager.GetDrivers;

  for i := 0 to Pred(Drivers.Count) do
  begin
    Protocols := (Drivers.Items[i] as IZDriver).GetSupportedProtocols;
    for j := 0 to High(Protocols) do
      Form_Principal.ComboBox_Protocolo.Items.Add(Protocols[j]);
  end;
  Form_Principal.ComboBox_Protocolo.Sorted := True;
end;
{ Os 3 eventos a seguir buscam por uma sequencia de caracteres de obtenção de
mensagens seguida de um OK, o que significaria que não existem mensagens, e
neste caso, ao achar o comando completo, devemos novamente chamar o método de
obtenção de mensagens }
procedure TDataModule_Principal.ComDataPacket_REC2CustomStart(Sender: TObject; const Str: string; var Pos: Integer);
begin
  Pos := System.Pos('AT+CMGL="',Str);
end;

procedure TDataModule_Principal.ComDataPacket_REC2CustomStop(Sender: TObject; const Str: string; var Pos: Integer);
begin
  Pos := System.Pos(#$D#$D#$A'OK'#$D#$A,Str);
  { De forma a não incluir nenhum caractere da condição final }
  if Pos > 0 then
    Dec(Pos);
end;

procedure TDataModule_Principal.ComDataPacket_REC2Packet(Sender: TObject; const Str: string);
begin
  { Limpa o buffer, pois depois deste comando não tem mais nada a fazer com ele }
  ComDataPacket_REC.ResetBuffer;
  { Obtém mais mensagens }
  ObterMensagens(Configuracoes.GENERALGECFREIN);
end;
{ Os 3 eventos a seguir buscam por uma sequencia de caracteres de mensagem
recebida seguida de um OK, o que significaria existem mensagens, e neste caso,
ao achar o comando completo, devemos processar tais mensagens e novamente chamar
o método de obtenção de mensagens }
procedure TDataModule_Principal.ComDataPacket_RECCustomStart(Sender: TObject; const Str: string; var Pos: Integer);
begin
  Pos := System.Pos('+CMGL:',Str);
end;

procedure TDataModule_Principal.ComDataPacket_RECCustomStop(Sender: TObject; const Str: string; var Pos: Integer);
begin
  Pos := System.Pos(#$D#$A#$D#$A'OK'#$D#$A,Str);
  { De forma a não incluir nenhum caractere da condição final }
  if Pos > 0 then
    Dec(Pos);
end;

procedure TDataModule_Principal.ComDataPacket_RECPacket(Sender: TObject; const Str: string);
begin
  { Porocessa todas as mensagens }
  ProcessarMensagens(Str);
  { Limpa o buffer, pois depois deste comando não tem mais nada a fazer com ele }
  ComDataPacket_REC.ResetBuffer;
  { Obtém mais mensagens }
  ObterMensagens(Configuracoes.GENERALGECFREIN);
end;

procedure TDataModule_Principal.ObterMensagens(aAguardar: Byte);
begin
  Timer_Verificacoes.Interval := aAguardar * 1000;
  Timer_Verificacoes.Enabled := True;
end;


procedure TDataModule_Principal.SalvarLogDeErro(aMetodo, aErro: String);
var
  Arquivo: TextFile;
begin
  try
    FileMode := fmOpenWrite;
    AssignFile(Arquivo,ChangeFileExt(Application.ExeName,'.log'));
    { O arquivo precisa existir. Ele deve ter sido criado anteriormente }
    Append(Arquivo);
    WriteLn(Arquivo,'Método: ' + aMetodo + #13#10 + 'Erro..: ' + aErro + #13#10'===============================================================================');
  finally
    CloseFile(Arquivo);
  end;
end;

{
+CMGL: 0,"REC READ","+558181828229",,"11/02/13,09:43:55-12"
Web: sdhasjkdh kjdhasjdhask jdhasjkdhjk adhasjkdh kajdhaskjdh askjdhas (carlos)
13.02.11 10:11:38
+CMGL: 1,"REC READ","+558181828229",,"11/02/13,09:55:52-12"
Web: mais uma mensagem para fins de teste. desta vez escrevi legivel!! (carlos)
13.02.11 10:23:35
+CMGL: 2,"REC READ","2004",,"11/02/13,10:38:51-12"
Vivo: Numero do protocolo: 2011625607050 - 13/02/2011 as 10:37 - Informacao - Servico. Para detalhes voce pode acessar vivo.com.br/meuvivo
+CMGL: 3,"REC READ","2004",,"11/02/13,10:48:57-12"
Vivo: Numero do protocolo: 2011625615863 - 13/02/2011 as 10:48 - Informacao - Servico. Para detalhes voce pode acessar vivo.com.br/meuvivo
+CMGL: 4,"REC READ","2004",,"11/02/13,11:00:54-12"
Vivo: Numero do protocolo: 2011625624946 - 13/02/2011 as 10:59 - Informacao - Servico. Para detalhes voce pode acessar vivo.com.br/meuvivo
}
procedure TDataModule_Principal.ProcessarMensagens(aMensagens: String);
{ ---------------------------------------------------------------------------- }
function MensagemRecebida(aMensagem: TMessage): Boolean;
begin
  { O mínimo de informações necessárias que identificam uma mensagem completa.
  Perceba que Data está no cabeçalho e Mensagem está abaixo do cabeçalho. Para
  que o processamento de mensagens funcione é preciso que haja ao menos um item
  do cabeçalho }
  Result := (aMensagem.Date <> '') and (aMensagem.Message <> '');
end;

function ObterPedaco(aLinha: String; aPedaco: Byte): String;
begin
  with TStringList.Create do
    try
      Text := StringReplace(aLinha,',',#13#10,[rfReplaceAll]);
      if (aPedaco = 4) or (aPedaco = 5) then
      begin
        Result := Copy(Strings[4],8,2) + '/' + Copy(Strings[4],5,2) + '/' +Copy(Strings[4],2,2) + ' ' + Copy(Strings[5],1,8);
      end
      else
      begin
        Result := Strings[aPedaco];
      end;
    finally
      Free;
    end;
end;

function HeaderEncontrado(aLinha: String; aTipo: Byte): Boolean;
begin
  Result := False;
  case aTipo of
    0: Result := MatchesMask(aLinha,'+CMGL: *,"REC READ",*,*,*') or MatchesMask(aLinha,'+CMGL: *,"REC UNREAD",*,*,*');
    1: Result := MatchesMask(aLinha,'+CMGL: *,"REC READ",*,*,*');
    2: Result := MatchesMask(aLinha,'+CMGL: *,"REC UNREAD",*,*,*');
  end;
end;

procedure IncluirNaImagem(aMensagem: TMessage);
var
  Arquivo: TextFile;
begin
  try
    FileMode := fmOpenWrite;
    AssignFile(Arquivo,Configuracoes.IMAGEFILEIFCFFINA);
    { O arquivo precisa existir. Ele deve ter sido criado anteriormente }
    Append(Arquivo);
    WriteLn(Arquivo,aMensagem.Index,';',aMensagem.From,';',aMensagem.Date,';',aMensagem.Message);
  finally
    CloseFile(Arquivo);
  end;
end;

procedure ExibirNaTela(aMensagem: TMessage);
begin
  with Form_Principal.ListView_Recebimento.Items.Add do
  begin
    Caption := IntToStr(aMensagem.Index);
    SubItems.Add(aMensagem.From);
    SubItems.Add(aMensagem.Date);
    SubItems.Add(aMensagem.Message);
    Form_Principal.ListView_Recebimento.Scroll(0,DisplayRect(drBounds).Top);
  end;
end;

function ObterParametro(aNumParam: Byte): String;
begin
  Result := '';
  with TStringList.Create do
    try
      Text := StringReplace(Configuracoes.SQLCOMMANDSSQCFFXPA,';',#13#10,[rfReplaceAll]);
      if aNumParam <= Pred(Count) then
        Result := Strings[aNumParam];
    finally
      Free;
    end;
end;

function GravarNoBanco(aMensagem: TMessage): Boolean;
var
  i: Byte;
begin
  Result := False;
  with Query do
  begin
    ParamCheck := False;
    SQL.Text := Configuracoes.SQLCOMMANDSSQCMINME;

    { Substituindo parâmetros }
    SQL.Text := StringReplace(SQL.Text,'<:RCDT:>',FormatDateTime(Configuracoes.SQLCOMMANDSSQCFDTFO,StrToDateTime(aMensagem.Date)),[rfReplaceAll]);
    SQL.Text := StringReplace(SQL.Text,'<:SDNU:>',aMensagem.From,[rfReplaceAll]);
    SQL.Text := StringReplace(SQL.Text,'<:MECO:>',aMensagem.Message,[rfReplaceAll]);

    for i := 0 to 9 do
      SQL.Text := StringReplace(SQL.Text,'<:FXP' + IntToStr(i) + ':>',ObterParametro(i),[rfReplaceAll]);

    try
      ExecSQL;
      Result := True;
    except
      on E: Exception do
        SalvarLogDeErro('GravarNoBanco',E.Message);
      { Ao executar o comando acima, ocorre um efeito em cascata que leva a
      conectar o componente connection. Caso haja qualquer tipo de problema ao
      tentar inserir no banco, incluindo o fato de não conseguir conectar ao
      mesmo não devemos fazer nada para permitir que o processamento de
      mensagens continue. Caso nao tenha sido possível salvar no banco, a função
      vai retornar false }
    end;
  end;
end;

procedure ExcluirDaMemoria(aMensagem: TMessage);
begin
  WriteString(StringReplace(Configuracoes.ATCOMMANDSATCMDEME,'<:IXMS:>',IntToStr(aMensagem.Index),[]) + #13);
end;

procedure ProcessarMensagemRecebida(aMensagem: TMessage);
begin
  { Neste ponto temos todas as informações necessárias. Devemos
  processá-las e limpar o registro que possui a mensagem }
  IncluirNaImagem(aMensagem);
  ExibirNaTela(aMensagem);
  { Tenta gravar no banco e se conseguir exclui a mensagem do modem }
  if GravarNoBanco(aMensagem) and Configuracoes.GENERALGECFDEME then
    ExcluirDaMemoria(aMensagem);
end;
{ ---------------------------------------------------------------------------- }
var
  Mensagem: TMessage;
  StrAux: String;
  i: Word;
begin
  ZeroMemory(@Mensagem,SizeOf(TMessage));

  with TStringList.Create do
    try
      Text := aMensagens;
      { só existem mensagens ou lidas ou não lidas }
      for i := 0 to Pred(Count) do
      begin
        StrAux := '';
        if HeaderEncontrado(Strings[i],0) then
        begin
          if MensagemRecebida(Mensagem) then
          begin
            ProcessarMensagemRecebida(Mensagem);
            ZeroMemory(@Mensagem,SizeOf(TMessage));
          end;

          StrAux := ObterPedaco(Strings[i],0);
          Mensagem.Index := StrToInt(Copy(StrAux,8,Length(StrAux) - 7));

          StrAux := ObterPedaco(Strings[i],2);
          if StrAux <> '' then
            Mensagem.From := Copy(StrAux,2,Length(StrAux) - 2);

          StrAux := ObterPedaco(Strings[i],4);
          if StrAux <> '' then
            Mensagem.Date := FormatDateTime('dd/mm/yyyy hh:nn:ss',StrToDateTime(Copy(StrAux,2,Length(StrAux) - 2)));
        end
        else
        begin
          if Mensagem.Message <> '' then
            Mensagem.Message := Mensagem.Message + '<br />' + Strings[i]
          else
            Mensagem.Message := Strings[i];
        end;
      end;

      { Processa a última mensagem }
      if MensagemRecebida(Mensagem) then
      begin
        ProcessarMensagemRecebida(Mensagem);
        ZeroMemory(@Mensagem,SizeOf(TMessage));
      end;

    finally
      Free;
    end;
end;

procedure TDataModule_Principal.Timer_VerificacoesTimer(Sender: TObject);
begin
  Timer_Verificacoes.Enabled := False;

  if ComPort_Modem.Connected then
  begin
    if Form_Principal.RadioButton_Ambas.Checked then
      WriteString(Configuracoes.ATCOMMANDSATCMALME + #13)
    else if Form_Principal.RadioButton_Lidas.Checked then
      WriteString(Configuracoes.ATCOMMANDSATCMRDME + #13)
    else if Form_Principal.RadioButton_NaoLidas.Checked then
      WriteString(Configuracoes.ATCOMMANDSATCMURME + #13);
  end;
end;

procedure TDataModule_Principal.WriteString(aComando: String);
begin
  try
    ComPort_Modem.WriteStr(aComando);
  except
    { O comando WriteStr acima só pode ser executado quando o monitoramento está
    ativado, logo, se algo acontecer errado, clicando o botão do form principal
    vai DESATIVAR o monitoramento }
    Form_Principal.Button_AtivaDesativaRecebimento.Click;
    Application.MessageBox('Houve um problema de comunicação. Por favor, verifique o modem. Desligue-o e ligue-o novamente, aguarde 1 minuto, e reinicie o monitoramento','Probelam na comunicação com o modem',MB_ICONWARNING);
  end;
end;

end.
