unit UTaskThread;

interface

uses
  Classes, ComCtrls, StdCtrls, DB;

type
  TTaskThread = class(TThread)
  private
    { Private declarations }
    FSQL: String;
    FDataBase: String;
    FHostName: String;
    FPassword: String;
    FPortNumb: Word;
    FProtocol: String;
    FUserName: String;
    FPage: Word;

    FLogText: String;
    FMemo: TMemo;
    FProgressBarRecord: TProgressBar;
    FProgressBarThread: TProgressBar;
    FStatusBar: TStatusBar;
    FExecuting: PWord;
    FThreadSeq: Word;
    procedure AddToLog;
    procedure AddProgressRecord;
    procedure AddProgressThread;
    procedure IncExecuting;
    procedure DecExecuting;
    procedure DoBeforeGenerate(aSender: TObject);
    procedure DoBeforeGenerateRecord(aSender: TObject);
    procedure DoAfterGenerateRecord(aSender: TObject);
    procedure DoAfterGenerate(aSender: TObject);
    procedure DoBeforeConnect(aSender: TObject);
    procedure DoAfterConnect(aSender: TObject);
    procedure DoBeforeDisconnect(aSender: TObject);
    procedure DoAfterDisconnect(aSender: TObject);
    procedure DoBeforeGetData(aDataSet: TDataSet);
    procedure DoAfterGetData(aDataSet: TDataSet);

  protected
    procedure Execute; override;
  public
    property Memo: TMemo write FMemo;
    property ProgressBarRecord: TProgressBar write FProgressBarRecord;
    property ProgressBarThread: TProgressBar write FProgressBarThread;
    property StatusBar: TStatusBar write FStatusBar;
    property Executing: PWord write FExecuting;
    property ThreadSeq: Word write FThreadSeq;
    property SQL: String read FSQL write FSQL;
    property Database: String write FDatabase;
    property HostName: String write FHostName;
    property Password: String write FPassword;
    property PortNumb: Word write FPortNumb;
    property Protocol: String write FProtocol;
    property UserName: String write FUserName;
    property Page: Word write FPage;
  end;

implementation

uses SysUtils, Windows, UConfigurations, UThreadedTask;

var
  HSemaphore: THandle;

{ TTaskThread }

procedure TTaskThread.IncExecuting;
begin
  Inc(FExecuting^);
end;

procedure TTaskThread.DecExecuting;
begin
  Dec(FExecuting^);
end;

procedure TTaskThread.AddProgressRecord;
begin
  FProgressBarRecord.StepIt;
  FStatusBar.Panels[1].Text := 'Registros processados: ' + IntToStr(FProgressBarRecord.Position);
end;

procedure TTaskThread.AddProgressThread;
begin
  FProgressBarThread.StepIt;
end;

procedure TTaskThread.AddToLog;
begin
  FMemo.Lines.Add(FLogText);
end;

procedure TTaskThread.DoAfterConnect(aSender: TObject);
begin
  FLogText := '[' + FormatDateTime('hh:nn:ss',Now) + '] Thread #' + IntToStr(FThreadSeq) + ' (ID#' + IntToStr(ThreadID) + '): Conexão estabelecida';
  Synchronize(AddToLog);
end;

procedure TTaskThread.DoAfterDisconnect(aSender: TObject);
begin
  FLogText := '[' + FormatDateTime('hh:nn:ss',Now) + '] Thread #' + IntToStr(FThreadSeq) + ' (ID#' + IntToStr(ThreadID) + '): Conexão encerrada';
  Synchronize(AddToLog);
end;

procedure TTaskThread.DoAfterGenerate(aSender: TObject);
begin
  FLogText := '[' + FormatDateTime('hh:nn:ss',Now) + '] Thread #' + IntToStr(FThreadSeq) + ' (ID#' + IntToStr(ThreadID) + '): XML Gerado';
  Synchronize(AddToLog);
end;

procedure TTaskThread.DoAfterGenerateRecord(aSender: TObject);
begin
  Synchronize(AddProgressRecord);
end;

procedure TTaskThread.DoAfterGetData(aDataSet: TDataSet);
begin
  FLogText := '[' + FormatDateTime('hh:nn:ss',Now) + '] Thread #' + IntToStr(FThreadSeq) + ' (ID#' + IntToStr(ThreadID) + '): Dados obtidos';
  Synchronize(AddToLog);
end;

procedure TTaskThread.DoBeforeConnect(aSender: TObject);
begin
  FLogText := '[' + FormatDateTime('hh:nn:ss',Now) + '] Thread #' + IntToStr(FThreadSeq) + ' (ID#' + IntToStr(ThreadID) + '): Estabelecendo conexão...';
  Synchronize(AddToLog);
end;

procedure TTaskThread.DoBeforeDisconnect(aSender: TObject);
begin
  FLogText := '[' + FormatDateTime('hh:nn:ss',Now) + '] Thread #' + IntToStr(FThreadSeq) + ' (ID#' + IntToStr(ThreadID) + '): Encerrando conexão...';
  Synchronize(AddToLog);
end;

procedure TTaskThread.DoBeforeGenerate(aSender: TObject);
begin
  FLogText := '[' + FormatDateTime('hh:nn:ss',Now) + '] Thread #' + IntToStr(FThreadSeq) + ' (ID#' + IntToStr(ThreadID) + '): Gerando XML...';
  Synchronize(AddToLog);
end;

procedure TTaskThread.DoBeforeGenerateRecord(aSender: TObject);
begin
  { Não é usado }
end;

procedure TTaskThread.DoBeforeGetData(aDataSet: TDataSet);
begin
  FLogText := '[' + FormatDateTime('hh:nn:ss',Now) + '] Thread #' + IntToStr(FThreadSeq) + ' (ID#' + IntToStr(ThreadID) + '): Obtendo dados...';
  Synchronize(AddToLog);
end;

procedure TTaskThread.Execute;
var
  ThreadedTask: TThreadedTask;
begin
  FLogText := '[' + FormatDateTime('hh:nn:ss',Now) + '] Thread #' + IntToStr(FThreadSeq) + ' (ID#' + IntToStr(ThreadID) + '): Iniciada';
  Synchronize (AddToLog);

  ThreadedTask := TThreadedTask.Create(nil);
  try
    try
      ThreadedTask.SQL      := FSQL;
      ThreadedTask.Database := FDatabase;
      ThreadedTask.HostName := FHostName;
      ThreadedTask.Password := FPassword;
      ThreadedTask.PortNumb := FPortNumb;
      ThreadedTask.Protocol := FProtocol;
      ThreadedTask.UserName := FUserName;
      ThreadedTask.Page     := FPage;

      ThreadedTask.OnBeforeGenerate := DoBeforeGenerate;
      ThreadedTask.OnBeforeGenerateRecord := DoBeforeGenerateRecord;
      ThreadedTask.OnAfterGenerateRecord := DoAfterGenerateRecord;
      ThreadedTask.OnAfterGenerate := DoAfterGenerate;
      ThreadedTask.OnBeforeConnect := DoBeforeConnect;
      ThreadedTask.OnAfterConnect := DoAfterConnect;
      ThreadedTask.OnBeforeDisconnect := DoBeforeDisconnect;
      ThreadedTask.OnAfterDisconnect := DoAfterDisconnect;
      ThreadedTask.OnBeforeGetData := DoBeforeGetData;
      ThreadedTask.OnAfterGetData := DoAfterGetData;

      { Aguarda até que haja um semáforo disponível }
      WaitForSingleobject (HSemaphore,INFINITE);

      Synchronize(IncExecuting);

      { Inicia o a tarefa pesada }
      ThreadedTask.StartTask;
    except
      on E: Exception do
      begin
        FLogText := '[' + FormatDateTime('hh:nn:ss',Now) + '] Thread #' + IntToStr(FThreadSeq) + ' (ID#' + IntToStr(ThreadID) + '): (ERRO) ' + E.Message;
        Synchronize(AddToLog);
      end;
    end;
  finally
    ThreadedTask.Free;
    FLogText := '[' + FormatDateTime('hh:nn:ss',Now) + '] Thread #' + IntToStr(FThreadSeq) + ' (ID#' + IntToStr(ThreadID) + '): Finalizada';
    Synchronize(AddToLog);
    Synchronize(AddProgressThread);
    ReleaseSemaphore (HSemaphore, 1, nil);
    Synchronize(DecExecuting);
  end;
end;

initialization
  { Cria um semáforo com o nome especificado, e com a capacidade máxima de 10
  (terceiro parâmetro). Inicialmente 10 semáforos estão disponíveis (segundo
  parâmetro). Na ordem de leitura dos parâmetros, pode se dizer que 10 de 10
  semáforos estão disponíveis. WaitForSingleObject, quando retorna, decrementa o
  primeiro contador em 1. Cada chamada subsequente a WaitForSingleObject fará
  isso até que o primeiro contador se torne zero. Neste momento, qualquer
  chamada a WaitForSingleObject vai fazer com que a Thread em que ele foi
  chamado fique parada, até que um novo semáforo seja liberado, incrementando
  assim o primeiro contador. Para liberar um semáforo, incrementando o primeiro
  contador a função ReleaseSemaphore deve ser executada }
  HSemaphore := CreateSemaphore(nil, Configurations.PARAMETROSCONCURRENTTHREADS, Configurations.PARAMETROSCONCURRENTTHREADS, 'UTASKTHREAD_SEMAPHORE');

end.
