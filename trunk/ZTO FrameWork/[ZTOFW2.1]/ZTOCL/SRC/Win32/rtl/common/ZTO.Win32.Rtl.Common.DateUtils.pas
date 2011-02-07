unit ZTO.Win32.Rtl.Common.DateUtils;

{$WEAKPACKAGEUNIT ON}

(******************************************************************************
 * Esta unit cont�m sugest�es de melhorias para unit DateUtils.pas, propostas
 * por John Herbster em 21/11/2007. Programadores por todo mundo percebem que as
 * fun��es contidas em DateUtils.pas n�o s�o t�o precisas como deveriam. A
 * solu��o � usar TimeStamp, que � preciso o suficiente. Mais informa��es, bem
 * como links para download da unit completa, podem ser encontradas em
 * http://qc.embarcadero.com/wc/qcmain.aspx?d=56957.
 * Esta unit cont�m todas as fun��es propostas e mais algumas fun��es que eu
 * criei e que fazem uso da alta precis�o.
 ******************************************************************************)

interface

type
  TDecodedDateDiff = record
    Years: Word;
    Weeks: Byte;
    Days: Word;
    Hours: Byte;
    Minutes: Byte;
    Seconds: Byte;
    Milliseconds: Word;
  end;

function DateTimeToMilliseconds(aDateTime: TDateTime): Int64;
function MillisecondsToDateTime(aMilliseconds: Int64): TDateTime;
function MillisecondsBetween(const aNow, aThen: TDateTime): Int64;
function SecondsBetween(const aNow, aThen: TDateTime): Int64;
function MinutesBetween(const aNow, aThen: TDateTime): Int64;
function HoursBetween(const aNow, aThen: TDateTime): Int64;
function DaysBetween(const aNow, aThen: TDateTime): Integer;
function DecodeDateDiff(aStartDateTime, aFinishDateTime: TDateTime): TDecodedDateDiff;

implementation

uses
  SysUtils, Windows, DateUtils;

{ Converts a TDateTime variable to Int64 milliseconds from 0001-01-01.}
function DateTimeToMilliseconds(aDateTime: TDateTime): Int64;
var
  TimeStamp: TTimeStamp;
begin
  { Call DateTimeToTimeStamp to convert DateTime to TimeStamp: }
  TimeStamp := DateTimeToTimeStamp(aDateTime);
  { Multiply and add to complete the conversion: }
  Result := Int64(TimeStamp.Date) * MSecsPerDay + TimeStamp.Time;
end;

{ Converts an Int64 milliseconds from 0001-01-01 to TDateTime variable.}
function MillisecondsToDateTime(aMilliseconds: Int64): TDateTime;
var
  TimeStamp: TTimeStamp;
begin
  { Divide and mod the milliseconds into the TimeStamp record: }
  TimeStamp.Date := aMilliseconds div MSecsPerDay;
  TimeStamp.Time := aMilliseconds mod MSecsPerDay;
  { Call TimeStampToDateTime to complete the conversion: }
  Result := TimeStampToDateTime(TimeStamp);
end;

{ Uses SysUtils.DateTimeToTimeStamp to convert a TDateTime var to integer milliseconds from 0001-01-01. }
function TruncDateTimeToSeconds(aDateTime: TDateTime): Int64;
begin
  Result := DateTimeToMilliseconds(aDateTime) div MSecsPerSec;
end;

{ Truncates a DateTime to minutes from 0001-01-01 }
function TruncDateTimeToMinutes(aDateTime: TDateTime): Int64;
begin
  Result := DateTimeToMilliseconds(aDateTime) div (60 * MSecsPerSec);
end;

{ Truncates a DateTime to seconds from 0001-01-01 }
function TruncDateTimeToHours(aDateTime: TDateTime): Int64;
begin
  Result := DateTimeToMilliseconds(aDateTime) div (60 * 60 * MSecsPerSec);
end;

function TruncDateTimeToDays(aDateTime: TDateTime): Int64;
begin
  Result := DateTimeToMilliseconds(aDateTime) div (24 * 60 * 60 * MSecsPerSec);
end;

{ Uses DateTimeToTimeStamp, TimeStampToMilliseconds, and DateTimeToMilliseconds }
function MillisecondsBetween(const aNow, aThen: TDateTime): Int64;
begin
  if aNow > aThen then
    Result := DateTimeToMilliseconds(aNow) - DateTimeToMilliseconds(aThen)
  else
    Result := DateTimeToMilliseconds(aThen) - DateTimeToMilliseconds(aNow);
end;

function SecondsBetween(const aNow, aThen: TDateTime): Int64;
begin
  if aNow > aThen then
    Result := TruncDateTimeToSeconds(aNow) - TruncDateTimeToSeconds(aThen)
  else
    Result := TruncDateTimeToSeconds(aThen) - TruncDateTimeToSeconds(aNow);
end;

{ Substitutes DateTimeToTimeStamp and TimeStampToMilliseconds, TruncDateTimeToMinutes for use of Trunc function. }
function MinutesBetween(const aNow, aThen: TDateTime): Int64;
begin
  if aNow > aThen then
    Result := TruncDateTimeToMinutes(aNow) - TruncDateTimeToMinutes(aThen)
  else
    Result := TruncDateTimeToMinutes(aThen) - TruncDateTimeToMinutes(aNow);
end;

function HoursBetween(const aNow, aThen: TDateTime): Int64;
begin
  if aNow > aThen then
    Result := TruncDateTimeToHours(aNow) - TruncDateTimeToHours(aThen)
  else
    Result := TruncDateTimeToHours(aThen) - TruncDateTimeToHours(aNow);
end;

function DaysBetween(const aNow, aThen: TDateTime): Integer;
begin
  if aNow > aThen then
    Result := TruncDateTimeToDays(aNow) - TruncDateTimeToDays(aThen)
  else
    Result := TruncDateTimeToDays(aThen) - TruncDateTimeToDays(aNow);
end;

{ Rounds a TDateTime value to the nearest to the millisecond and then converts back to the closest possible TDateTime representation to that millisecond value. }
function NormalizeDateTime(aDateTime: TDateTime): TDateTime;
var
  TimeStamp: TTimeStamp;
begin
  TimeStamp := DateTimeToTimeStamp(aDateTime);
  Result := TimeStampToDateTime(TimeStamp);
{ My testing indicates that these SysUtils.DateTimeToTimeStamp and SysUtils.TimeStampToDateTime are perfect. }
end;

{ The following function works properly, but should be used with caution, else it creates another type of hidden value problem. }
{ Rounds, rather than truncates, a DateTime to seconds from 0001-01-01. }
function RoundDateTimeToSeconds(DateTime: TDateTime): Int64;
begin
  Result := Round(DateTimeToMilliseconds(DateTime) / MSecsPerSec);
end;

{ Retorna a quantidade exata de anos, semanas, dias, horas, minutos, segundos e
milissegundos entre duas datas informadas }
function DecodeDateDiff(aStartDateTime, aFinishDateTime: TDateTime): TDecodedDateDiff;
var
  MilliSeconds: Int64;
  WholeStartDate, WholeEndDate: TDateTime;
  Days: Cardinal;
  Years: Word;
begin
  { Validando as datas, que devem ser passadas corretamente para fun��o, isto �,
  a data final tem de ser maior ou igual � data final. Qualquer outro caso �
  inv�lido e lan�a a exce��o }
  if aStartDateTime > aFinishDateTime then
    raise Exception.Create('A data final � menor que a data inicial');

  { Zerando as vari�veis que ser�o usadas no decorrer da fun��o }
  ZeroMemory(@Result,SizeOf(TDecodedDateDiff));
  Years := 0;

  { Obtendo a quantidade exata de millissegundos entre as datas. A fun��o
  MilliSecondsBetween deve ser aquela alterada para retornar a quantidade exata
  de milissegundos e n�o aquela existente em DateUtils }
  MilliSeconds := MilliSecondsBetween(aStartDateTime,aFinishDateTime);

  { A partir da quantidade exata de millissegundos, podemos obter a quantidade
  exata de dias, j� que sabemos quantos millissegundos h�o exatamente em um
  dia }
  Days := MilliSeconds div MSecsPerDay;

  { Abaixo estamos normalizando as datas, de forma que a data inicial come�e
  exatamente no in�cio do ano subsequente a ela, e a data final termine
  exatamente no final do ano anterior a ela }
  WholeStartDate := IncMilliSecond(EndOfTheYear(aStartDateTime));
  WholeEndDate := IncMilliSecond(StartOfTheYear(aFinishDateTime),-1);

  { O loop abaixo vai realizar duas a��es: Decrementar a quantidade de dias
  obtida anteriormente da quantidade de dias no ano sendo verificado no momento
  e incrementar a vari�vel Years, de forma a obter a quantidade de anos. }
  while WholeStartDate < WholeEndDate do
  begin
    Dec(Days,DaysInYear(WholeStartDate));

    Inc(Years);

    WholeStartDate := IncDay(WholeStartDate,DaysInYear(WholeStartDate));
  end;

  { Caso a quantidade de dias seja maior ou igual a quantidade de dias no ano
  final, precisamos realizar um �ltimo ajuste para incrementar anos e
  decrementar dias de acordo com a quantidade de dias no ano da data final }
  if Days >= DaysInYear(aFinishDateTime) then
  begin
    Inc(Years);
    Dec(Days,DaysInYear(aFinishDateTime));
  end;

  { Neste ponto, a vari�vel Years cont�m a quantidade de anos inteiros entre as
  datas inicial final ... }

  Result.Years := Years;

  { ... E a vari�vel Days cont�m a quantidade de dias que sobraram. Obtemos
  portanto a quantidade de semanas, que � um valor exato }

  Result.Weeks := Days div 7;
  Result.Days := Days mod 7;

  { A partir daqui a verifica��o � simples matem�tica, extraindo horas, minutos
  e segundos dos millisegundos }
  MilliSeconds   := MilliSeconds mod MSecsPerDay;

  Result.Hours   := MilliSeconds div (SecsPerHour * MSecsPerSec);
  MilliSeconds   := MilliSeconds mod (SecsPerHour * MSecsPerSec);

  Result.Minutes := MilliSeconds div (SecsPerMin * MSecsPerSec);
  MilliSeconds   := MilliSeconds mod (SecsPerMin * MSecsPerSec);

  Result.Seconds := MilliSeconds div MSecsPerSec;
  MilliSeconds   := MilliSeconds mod MSecsPerSec;

  { O que sobrar no final, ser� apenas milissegundos! }
  Result.Milliseconds := MilliSeconds;
end;


end.
