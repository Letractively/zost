unit UForm_Principal;

interface

uses
  Windows, Messages, SysUtils, Variants, Graphics, Controls, Forms,
  Dialogs, SynEdit, SynEditHighlighter, SynHighlighterPHP, OleCtrls, SHDocVw,
  ToolWin, ComCtrls, ExtCtrls, PHPCommon, php4delphi, ActnList, Classes;

{$I PHP.INC}

type
  TForm1 = class(TForm)
    SynEdit_Codigo: TSynEdit;
    SynPHPSyn_PHP: TSynPHPSyn;
    psvPHP_Executor: TpsvPHP;
    PHPEngine_Engine: TPHPEngine;
    ToolButton_Executar: TToolButton;
    ToolButton_Abrir: TToolButton;
    ActionList_Principal: TActionList;
    Action_Executar: TAction;
    ToolBar_Principal: TToolBar;
    Splitter_Principal: TSplitter;
    Panel_Browser: TPanel;
    WebBrowser_Resultado: TWebBrowser;
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure Action_ExecutarExecute(Sender: TObject);
  private
    procedure DisplayResultInBrowser(aResult: String);
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form1: TForm1;

implementation

uses ActiveX;

{$R *.dfm}

procedure TForm1.Action_ExecutarExecute(Sender: TObject);
begin
  DisplayResultInBrowser(psvPHP_Executor.RunCode(SynEdit_Codigo.Text));
end;

procedure TForm1.FormCreate(Sender: TObject);
var
 Url : OleVariant;
 Doc : string;
begin
  PHPEngine.StartupEngine;

  Url := 'about:blank';
  WebBrowser_Resultado.Navigate2(Url);
  Doc := psvPHP_Executor.RunCode('phpinfo();');

  DisplayResultInBrowser(Doc);
end;

procedure TForm1.FormDestroy(Sender: TObject);
begin
  PHPEngine.ShutdownAndWaitFor;
end;

function StringToOleStream(const aString: string): IStream;
var
  MemHandle: THandle;
begin
  MemHandle := GlobalAlloc(GPTR, Length(aString) + 1);

  if MemHandle <> 0 then
  begin
    Move(aString[1], PChar(MemHandle)^, Length(aString) + 1);
    CreateStreamOnHGlobal(MemHandle, True, Result);
  end
  else
    Result := nil;
end;

procedure TForm1.DisplayResultInBrowser(aResult: String);
var
 Stream: IStream;
 StreamInit: IPersistStreamInit;
begin
  if aResult = '' then
  begin
    WebBrowser_Resultado.Navigate('about: O script não retornou nada');
    Exit;
  end;

  aResult := StringReplace(aResult, 'src="?=PHPE9568F34-D428-11d2-A769-00AA001ACF42"','src="res://' + ParamStr(0) + '/php"', [rfReplaceAll, rfIgnoreCase]);

  {$IFDEF PHP4}
  AStr := StringReplace(AStr, 'src="?=PHPE9568F35-D428-11d2-A769-00AA001ACF42"','src="res://' + ParamStr(0) + '/zend1"', [rfReplaceAll, rfIgnoreCase]);
  {$ELSE}
  aResult := StringReplace(aResult, 'src="?=PHPE9568F35-D428-11d2-A769-00AA001ACF42"','src="res://' + ParamStr(0) + '/zend2"', [rfReplaceAll, rfIgnoreCase]);
  {$ENDIF}

  Stream := StringToOleStream(aResult);
  StreamInit := WebBrowser_Resultado.Document as IPersistStreamInit;
  StreamInit.InitNew;
  StreamInit.Load(Stream);
end;


end.
