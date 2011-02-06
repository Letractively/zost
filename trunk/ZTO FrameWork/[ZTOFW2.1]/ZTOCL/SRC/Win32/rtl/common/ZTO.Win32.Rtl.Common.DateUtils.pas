unit ZTO.Win32.Rtl.Common.DateUtils;

{$WEAKPACKAGEUNIT ON}

(******************************************************************************
 * Esta unit contém sugestões de melhorias para unit DateUtils.pas, propostas
 * por John Herbster em 21/11/2007. Programadores por todo mundo percebem que as
 * funções contidas em DateUtils.pas não são tão precisas como deveriam. A
 * solução é usar TimeStamp, que é preciso o suficiente. Mais informações, bem
 * como links para download da unit completa, podem ser encontradas em
 * http://qc.embarcadero.com/wc/qcmain.aspx?d=56957.
 * Atualmente nesta unit coloquei apenas as funções que julguei necessárias no
 * framework. Outras funções podem ser encontradas na unit original.
 ******************************************************************************)

interface

function MillisecondsBetween(const aNow, aThen: TDateTime): Int64;
function MinutesBetween(const aNow, aThen: TDateTime): Integer;
function DateTimeToMilliseconds(aDateTime: TDateTime): Int64;
function MillisecondsToDateTime(aMilliseconds: Int64): TDateTime;

implementation

uses
  SysUtils;

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

{ Truncates a DateTime to minutes from 0001-01-01. }
function TruncDateTimeToMinutes(aDateTime: TDateTime): LongInt;
begin
  Result := DateTimeToMilliseconds(aDateTime) div (60 * MSecsPerSec);
end;

{ Truncates a DateTime to seconds from 0001-01-01. }
function TruncDateTimeToHours(aDateTime: TDateTime): Integer;
begin
  Result := DateTimeToMilliseconds(aDateTime) div (24 * 60 * MSecsPerSec);
end;

{ Uses DateTimeToTimeStamp, TimeStampToMilliseconds, and DateTimeToMilliseconds. }
function MillisecondsBetween(const aNow, aThen: TDateTime): Int64;
begin
  Result := DateTimeToMilliseconds(aNow) - DateTimeToMilliseconds(aThen);
end;

{ Substitutes DateTimeToTimeStamp and TimeStampToMilliseconds, TruncDateTimeToMinutes for use of Trunc function. }
function MinutesBetween(const aNow, aThen: TDateTime): Integer;
begin
  Result := TruncDateTimeToMinutes(aNow) - TruncDateTimeToMinutes(aThen);
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

end.
