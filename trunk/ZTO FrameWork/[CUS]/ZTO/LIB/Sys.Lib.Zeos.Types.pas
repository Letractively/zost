unit Sys.Lib.Zeos.Types;

interface

uses ComCtrls
   , StdCtrls
   , ZSQLProcessor
   , Sys.Lib.Types;

//type
//  TExecuteScriptEvent    = (eseBeforeExecuteScript
//                           ,eseBeforeExecuteScriptPart
//                           ,eseAfterExecuteScriptPart
//                           ,eseAfterExecuteScript);
(*
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

  TProcessorEvents = class
  private
    FProgressBarCurrent: TProgressBar;
    FLabelCurrentValue: TLabel;
    FLabelCurrentDescription: TLabel;
  public
    constructor Create(aProgressBarCurrent: TProgressBar; aLabelCurrentValue, aLabelCurrentDescription: TLabel);
    procedure DoAfterExecute(aProcessor: TZSQLProcessor; aStatementIndex: Integer);
    procedure DoBeforeExecute(aProcessor: TZSQLProcessor; aStatementIndex: Integer);
  end;
*)

implementation

uses Forms
   , SysUtils
   , ZTO.Win32.Rtl.Common.ComponentUtils;

{ TProcessorEvents }
(*
constructor TProcessorEvents.Create(aProgressBarCurrent: TProgressBar; aLabelCurrentValue, aLabelCurrentDescription: TLabel);
begin
	FProgressBarCurrent := aProgressBarCurrent;
  FLabelCurrentValue := aLabelCurrentValue;
  FLabelCurrentDescription := aLabelCurrentDescription;
end;

procedure TProcessorEvents.DoAfterExecute(aProcessor: TZSQLProcessor; aStatementIndex: Integer);
begin
	if Assigned(FProgressBarCurrent) then
  begin
    FProgressBarCurrent.StepIt;
    Application.ProcessMessages;
  end;
end;

procedure TProcessorEvents.DoBeforeExecute(aProcessor: TZSQLProcessor; aStatementIndex: Integer);
begin
  if Assigned(FLabelCurrentDescription) and Assigned(FLabelCurrentValue) then
  begin
    SetLabelDescriptionValue(FLabelCurrentDescription
                            ,FLabelCurrentValue
                            ,IntToStr(Succ(aStatementIndex)) + ' / ' + IntToStr(aProcessor.StatementCount));
    Application.ProcessMessages;
  end;
end;
*)
end.
