unit ZTO.Win32.Db.ZeosLib.MySQL.Types;

{$WEAKPACKAGEUNIT ON}

interface

uses Classes
   , ComCtrls
   , StdCtrls
   , ZSQLProcessor;

type
  TScriptPart = class (TCollectionItem)
  private
    FDelimiter: String;
    FScript: String;
  public
    constructor Create(Collection: TCollection); override;
    property Delimiter: String read FDelimiter write FDelimiter;
    property Script: String read FScript write FScript;
  end;

  TScriptParts = class (TCollection)
  private
    function GetScriptPart(i: Cardinal): TScriptPart;
    function GetLast: TScriptPart;
  public
    function Add: TScriptPart;
    property Part[i: Cardinal]: TScriptPart read GetScriptPart; default;
    property Last: TScriptPart read GetLast;
  end;

  TExecuteScriptEvent    = (esePreprocessingScript
                           ,esePostProcessingScript
                           ,eseBeforeExecuteScript
                           ,eseBeforeExecuteScriptPart
                           ,eseAfterExecuteScriptPart
                           ,eseAfterExecuteScript);

  TExecuteScriptCallBack = procedure (const aProcessor            : TZSQLProcessor;
                                      const aExecuteScriptEvent   : TExecuteScriptEvent;
                                      const aScriptParts          : TScriptParts) of object;

  TSplitScriptEvent    = (sseBeforeParse
                         ,sseAfterParse
                         ,sseBeforeSplitOperation
                         ,sseBeforeSplit
                         ,sseAfterSplit
                         ,sseAfterSplitOperation);

  TSplitScriptCallBack = procedure (const aProcessor       : TZSQLProcessor;
                                    const aSplitScriptEvent: TSplitScriptEvent;
                                    const aScriptParts     : TScriptParts) of object;
//  TProcessorEvents = class
//  private
//    FProgressBarCurrent: TProgressBar;
//    FLabelCurrentValue: TLabel;
//    FLabelCurrentDescription: TLabel;
//  public
//    constructor Create(aProgressBarCurrent: TProgressBar; aLabelCurrentValue, aLabelCurrentDescription: TLabel);
//    procedure DoAfterExecute(aProcessor: TZSQLProcessor; aStatementIndex: Integer);
//    procedure DoBeforeExecute(aProcessor: TZSQLProcessor; aStatementIndex: Integer);
//  end;


implementation

{ TScriptPart }

constructor TScriptPart.Create(Collection: TCollection);
begin
  inherited;
  FScript    := '';
  FDelimiter := ';';
end;

{ TScriptParts }

function TScriptParts.Add: TScriptPart;
begin
	Result := TScriptPart(inherited Add);
end;

function TScriptParts.GetLast: TScriptPart;
begin
	if Count = 0 then
    Result := nil
  else
   	Result := GetScriptPart(Pred(Count));
end;

function TScriptParts.GetScriptPart(i: Cardinal): TScriptPart;
begin
	Result := TScriptPart(inherited Items[i]);
end;

{ TProcessorEvents }

//constructor TProcessorEvents.Create(aProgressBarCurrent: TProgressBar; aLabelCurrentValue, aLabelCurrentDescription: TLabel);
//begin
//	FProgressBarCurrent := aProgressBarCurrent;
//  FLabelCurrentValue := aLabelCurrentValue;
//  FLabelCurrentDescription := aLabelCurrentDescription;
//end;
//
//procedure TProcessorEvents.DoAfterExecute(aProcessor: TZSQLProcessor; aStatementIndex: Integer);
//begin
//	if Assigned(FProgressBarCurrent) then
//  begin
//    FProgressBarCurrent.StepIt;
////    Application.ProcessMessages;
//  end;
//end;
//
//procedure TProcessorEvents.DoBeforeExecute(aProcessor: TZSQLProcessor; aStatementIndex: Integer);
//begin
//  if Assigned(FLabelCurrentDescription) and Assigned(FLabelCurrentValue) then
//  begin
////    SetLabelDescriptionValue(FLabelCurrentDescription
////                            ,FLabelCurrentValue
////                            ,IntToStr(Succ(aStatementIndex)) + ' / ' + IntToStr(aProcessor.StatementCount));
////    Application.ProcessMessages;
//  end;
//end;

end.
