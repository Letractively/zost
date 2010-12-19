unit ZTO.Win32.Rtl.Sys.Types;

{$WEAKPACKAGEUNIT ON}
{ tipos que podem ser usados em mais de uma unit, ou seja, tipos compartilhados }
interface

type
  TResultType = (rtUnknown, rtNull, rtByte, rtWord, rtDWord, rtShortInt,
                 rtSmallInt, rtInteger, rtInt64, rtChar, rtShortString, rtString,
                 rtSingle, rtDouble, rtCurrency, rtDateTime);

	TMultiTypedResult = record
    ResultType   : TResultType;
    AsByte       : Byte;
    AsWord       : Word;
    AsDWord      : Cardinal;
    AsShortInt   : ShortInt;
    AsSmallInt   : SmallInt;
    AsInteger    : Integer;
    AsInt64      : Int64;
    AsChar       : Char;
    AsString     : String;
    AsSingle     : Single;
    AsDouble     : Double;
    AsCurrency   : Currency;
    AsDateTime   : TDateTime;
  end;

  TZlibNotificationMoment = (znmUnknown,znmBeforeProcess,znmAfterProcess,znmInsideProcess);

implementation

end.
