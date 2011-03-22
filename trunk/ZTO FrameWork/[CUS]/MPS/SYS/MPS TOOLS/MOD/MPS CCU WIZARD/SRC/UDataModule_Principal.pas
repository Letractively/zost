unit UDataModule_Principal;

interface

uses
  SysUtils, Classes, OverbyteIcsWndControl, OverbyteIcsHttpProt,
  OverbyteIcsWSocket;

type
  TDataModule_Principal = class(TDataModule)
    SslHttpCli_CCU: TSslHttpCli;
    SslContext_CCU: TSslContext;
    procedure SslHttpCli_CCUDocBegin(Sender: TObject);
    procedure SslHttpCli_CCUDocData(Sender: TObject; Buffer: Pointer;
      Len: Integer);
    procedure SslHttpCli_CCUDocEnd(Sender: TObject);
    procedure SslHttpCli_CCURequestDone(Sender: TObject; RqType: THttpRequest;
      ErrCode: Word);
  private
    { Private declarations }
    FByteCount: Cardinal;
  public
    { Public declarations }
    procedure GetCCU;
    procedure ParseCCU;
  end;

var
  DataModule_Principal: TDataModule_Principal;

implementation

uses
  UForm_Principal, OverbyteIcsUrl, HTTPApp;

{$R *.dfm}

{ TDataModule_Principal }

procedure TDataModule_Principal.GetCCU;
const
  STRING_CONEXAO = 'Matricula=%s&Senha=%s&MesAno=%s';
var
  Data: AnsiString;
begin
  Data := Format(STRING_CONEXAO,[UrlEncode(Form_Principal.LabeledEdit_Matricula.Text)
                                ,UrlEncode(Form_Principal.LabeledEdit_Senha.Text)
                                ,UrlEncode(Form_Principal.LabeledEdit_Periodo.Text)]);

  SslHttpCli_CCU.SendStream := TMemoryStream.Create;
  SslHttpCli_CCU.SendStream.Write(Data[1], Length(Data));
  SslHttpCli_CCU.SendStream.Seek(0, 0);
  SslHttpCli_CCU.RcvdStream := TMemoryStream.Create;
  SslHttpCli_CCU.URL := 'https://intranet.mpsinf.com.br/CCU/Buscar';
  SslHttpCli_CCU.Reference := 'https://intranet.mpsinf.com.br/';
  SslHttpCli_CCU.Username := Form_Principal.LabeledEdit_UsuarioIntranet.Text;
  SslHttpCli_CCU.Password := Form_Principal.LabeledEdit_SenhaIntranet.Text;
  SslHttpCli_CCU.PostAsync;
end;

procedure TDataModule_Principal.ParseCCU;
const
  TEXTAREA1 = '<TEXTAREA COLS="20" ID="LANCAMENTOS" NAME="LANCAMENTOS" ROWS="2">';
  TEXTAREA2 = '</TEXTAREA>';
var
  InicioCCU, FimCCU: Integer;
begin
  InicioCCU := Pos(TEXTAREA1,UpperCase(Form_Principal.RichEdit_CCU.text)) + Length(TEXTAREA1);
  FimCCU := Pos(TEXTAREA2,UpperCase(Form_Principal.RichEdit_CCU.text));
  Form_Principal.RichEdit_CCU.Text := Trim(htmlDecode(Copy(Form_Principal.RichEdit_CCU.text,InicioCCU,FimCCU - InicioCCU)));
end;

procedure TDataModule_Principal.SslHttpCli_CCUDocBegin(Sender: TObject);
var
  HttpCli : TSslHttpCli;
  DocFileName: String;
begin
  FByteCount := 0;
  HttpCli := Sender as TSslHttpCli;
//  Memo_1.Lines.Add(HttpCli.ContentType + ' => ' + HttpCli.DocName);
//  Memo_1.Lines.Add('Document = ' + HttpCli.DocName);

  DocFileName := HttpCli.DocName;

  if HttpCli.ContentType = 'image/gif' then
    ReplaceExt(DocFileName, 'gif')
  else if HttpCli.ContentType = 'image/jpeg' then
    ReplaceExt(DocFileName, 'jpg')
  else if HttpCli.ContentType = 'image/bmp' then
    ReplaceExt(DocFileName, 'bmp');

  if DocFileName = '' then
    DocFileName := GetCurrentDir + '\HttpTst.htm'
  else
    DocFileName := GetCurrentDir + '\' + DocFileName;

  try
    HttpCli.RcvdStream := TFileStream.Create(DocFileName, fmCreate);
  except
    on E:Exception do
    begin
//      Memo_1.Lines.Add('Error opening file: ' + E.Message);
      DocFileName := 'HttpTst.htm';
//      Memo_1.Lines.Add('Using default file name: ' + FDocFileName);
      HttpCli.RcvdStream := TFileStream.Create(DocFileName, fmCreate);
    end;
  end;
end;

procedure TDataModule_Principal.SslHttpCli_CCUDocData(Sender: TObject; Buffer: Pointer; Len: Integer);
begin
  Inc(FByteCount, Len);
end;

procedure TDataModule_Principal.SslHttpCli_CCUDocEnd(Sender: TObject);
var
  HttpCli : TSslHttpCli;
begin
//    TransfertStats;
  HttpCli := Sender as TSslHttpCli;
  if Assigned(HttpCli.RcvdStream) then
  begin
    HttpCli.RcvdStream.Free;
    HttpCli.RcvdStream := nil;
  end;
end;

procedure TDataModule_Principal.SslHttpCli_CCURequestDone(Sender: TObject; RqType: THttpRequest; ErrCode: Word);
var
  DataIn  : TStream;
  i       : Integer;
begin
  if ErrCode <> 0 then
  begin
//    Memo_1.Lines.Add('Request done, error #' + IntToStr(ErrCode));
    Exit;
  end;

//  Memo_1.Lines.Add('Request done, StatusCode #' + IntToStr(SslHttpCli_Acesso.StatusCode));

//  for i := 0 to Pred(SslHttpCli_CCU.RcvdHeader.Count) do
//    Memo_1.Lines.Add('hdr>' + SslHttpCli_Acesso.RcvdHeader.Strings[I]);

  if SslHttpCli_CCU.DocName = '' then
    Form_Principal.RichEdit_CCU.Lines.Add('*** NO DOCUMENT FILE NAME ***')
  else
  begin
    if not FileExists(SslHttpCli_CCU.DocName) then
      Form_Principal.RichEdit_CCU.Lines.Add('*** NO DOCUMENT FILE ***')
    else
    begin
      DataIn := TFileStream.Create(SslHttpCli_CCU.DocName, fmOpenRead);
      try
        if Copy(SslHttpCli_CCU.ContentType, 1, 5) = 'text/' then
        begin
          Form_Principal.RichEdit_CCU.Lines.LoadFromStream(DataIn);
          ParseCCU;
        end
        else
        begin
          Form_Principal.RichEdit_CCU.Lines.Add('Content type is ' + SslHttpCli_CCU.ContentType);
          Form_Principal.RichEdit_CCU.Lines.Add('Document stored in "' + SslHttpCli_CCU.DocName + '" Size=' + IntToStr(DataIn.Size));
        end;
      finally
        DataIn.Free;
      end;
    end;
  end;
end;

end.
