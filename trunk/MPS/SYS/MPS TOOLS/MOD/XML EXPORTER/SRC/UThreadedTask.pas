unit UThreadedTask;

interface

uses
  SysUtils, Classes, DB, ZAbstractRODataset, ZDataset, ZConnection;

type
  TOnBeforeGenerate = TNotifyEvent;
  TOnAfterGenerateRecord = TNotifyEvent;
  TOnAfterGenerate = TNotifyEvent;
  TOnBeforeGenerateRecord = TNotifyEvent;

  TThreadedTask = class(TDataModule)
    Connection: TZConnection;
    DataSet: TZReadOnlyQuery;
    procedure DataModuleCreate(Sender: TObject);
    procedure DataModuleDestroy(Sender: TObject);
  private
    { Private declarations }
    FPage: Word;
    FOnBeforeGenerate: TOnBeforeGenerate;
    FOnAfterGenerateRecord: TOnAfterGenerateRecord;
    FOnAfterGenerate: TOnAfterGenerate;
    FOnBeforeGenerateRecord: TOnBeforeGenerateRecord;
    FOnAfterConnect: TNotifyEvent;
    FOnAfterDisconnect: TNotifyEvent;
    FOnBeforeConnect: TNotifyEvent;
    FOnBeforeDisconnect: TNotifyEvent;
    FOnBeforeGetData: TDataSetNotifyEvent;
    FOnAfterGetData: TDataSetNotifyEvent;

    procedure SetDatabase(const Value: String);
    procedure SetHostName(const Value: String);
    procedure SetPassword(const Value: String);
    procedure SetPortNumb(const Value: Word);
    procedure SetProtocol(const Value: String);
    procedure SetUserName(const Value: String);
    procedure SetSQL(const Value: String);

    procedure Connect;
    procedure GetData;
    procedure GenerateXML;
  public
    { Public declarations }
    procedure StartTask;

    property SQL: String write SetSQL;
    property Database: String write SetDatabase;
    property HostName: String write SetHostName;
    property Password: String write SetPassword;
    property PortNumb: Word write SetPortNumb;
    property Protocol: String write SetProtocol;
    property UserName: String write SetUserName;
    property Page: Word write FPage;

    property OnBeforeGenerate: TOnBeforeGenerate read FOnBeforeGenerate write FOnBeforeGenerate;
    property OnBeforeGenerateRecord: TOnBeforeGenerateRecord read FOnBeforeGenerateRecord write FOnBeforeGenerateRecord;
    property OnAfterGenerateRecord: TOnAfterGenerateRecord read FOnAfterGenerateRecord write FOnAfterGenerateRecord;
    property OnAfterGenerate: TOnAfterGenerate read FOnAfterGenerate write FOnAfterGenerate;
    property OnBeforeConnect: TNotifyEvent read FOnBeforeConnect write FOnBeforeConnect;
    property OnAfterConnect: TNotifyEvent read FOnAfterConnect write FOnAfterConnect;
    property OnBeforeDisconnect: TNotifyEvent read FOnBeforeDisconnect write FOnBeforeDisconnect;
    property OnAfterDisconnect: TNotifyEvent read FOnAfterDisconnect write FOnAfterDisconnect;
    property OnBeforeGetData: TDataSetNotifyEvent read FOnBeforeGetData write FOnBeforeGetData;
    property OnAfterGetData: TDataSetNotifyEvent read FOnAfterGetData write FOnAfterGetData;
  end;

implementation

uses UConfigurations, StrUtils, Variants, Windows;

{$R *.dfm}

{ TThreadedTask }

procedure TThreadedTask.Connect;
begin
  FOnBeforeConnect(Connection);
  Connection.Connect;
  FOnAfterConnect(Connection);
end;

procedure TThreadedTask.DataModuleCreate(Sender: TObject);
begin
  Connection.BeforeConnect := FOnBeforeConnect;
  Connection.AfterConnect := FOnAfterConnect;
  Connection.BeforeDisconnect := FOnBeforeConnect;
  Connection.AfterDisconnect := FOnAfterDisconnect;

  DataSet.Connection := Connection;
  DataSet.AutoCalcFields := False;
  DataSet.Options := [];
  DataSet.ParamCheck := False;
  DataSet.BeforeOpen := FOnBeforeGetData;
  DataSet.AfterOpen := FOnAfterGetData;
end;

procedure TThreadedTask.DataModuleDestroy(Sender: TObject);
begin
  DataSet.Close;
  FOnBeforeDisconnect(Connection);
  Connection.Disconnect;
  FOnAfterDisconnect(Connection);
end;

procedure TThreadedTask.GenerateXML;
var
  XML: TextFile;
  i: Byte;
  Buffer: array [1..524288] of Char; { Buffer de 512K! }
begin
  { Código para geração do XML }
  FOnBeforeGenerate(Self);

  try
    AssignFile(XML,Configurations.PARAMETROSNOMEDOARQUIVO + DupeString('0',5 - Length(IntToStr(FPage))) + IntToStr(FPage) + '.xml');
    FileMode := fmOpenWrite;
    SetTextBuf(XML, Buffer);
    Rewrite(XML);

    while not DataSet.Eof do
    begin
      FOnBeforeGenerateRecord(Self);

      WriteLn(XML,'<DOCUMENTO>');

      { O primeiro campo é o coddoc, que não usamos }
      for i := 1 to Pred(DataSet.Fields.Count) do
      begin
        if Trim(DataSet.Fields[i].AsString) <> '' then
        begin
          Writeln(XML,'<' + DataSet.Fields[i].FieldName + '>');
          Writeln(XML,DataSet.Fields[i].AsString);
          Writeln(XML,'</' + DataSet.Fields[i].FieldName + '>');
        end
        else
          Writeln(XML,'<' + DataSet.Fields[i].FieldName + '></' + DataSet.Fields[i].FieldName + '>');
      end;

      WriteLn(XML,'</DOCUMENTO>');

      FOnAfterGenerateRecord(Self);
      DataSet.Next;
    end;
  finally
    CloseFile(XML);
    FOnAfterGenerate(Self);
  end;
end;

procedure TThreadedTask.GetData;
begin
  FOnBeforeGetData(DataSet);
  DataSet.Open;
  FOnAfterGetData(DataSet);
end;

procedure TThreadedTask.SetDatabase(const Value: String);
begin
  Connection.Database := Value;
end;

procedure TThreadedTask.SetSQL(const Value: String);
begin
  DataSet.SQL.Text := Value;
end;

procedure TThreadedTask.SetHostName(const Value: String);
begin
  Connection.HostName := Value;
end;

procedure TThreadedTask.SetPassword(const Value: String);
begin
  Connection.Password := Value;
end;

procedure TThreadedTask.SetPortNumb(const Value: Word);
begin
  Connection.Port := Value;
end;

procedure TThreadedTask.SetProtocol(const Value: String);
begin
  Connection.Protocol := Value;
end;

procedure TThreadedTask.SetUserName(const Value: String);
begin
  Connection.User := Value;
end;

procedure TThreadedTask.StartTask;
begin
  { Conecta ao banco de dados }
  Connect;
  { Obtém os dados por meio de uma consulta }
  GetData;
  { Gera um xml baseado na consulta executada anteriormente }
  GenerateXML;
end;

end.
