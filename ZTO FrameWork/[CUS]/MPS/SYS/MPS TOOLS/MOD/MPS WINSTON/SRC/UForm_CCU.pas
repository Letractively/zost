unit UForm_CCU;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ToolWin, ComCtrls, ExtCtrls, Buttons;

type
  TForm_CCU = class(TForm)
    Memo_CCU: TMemo;
    Panel_Opcoes: TPanel;
    BitBtn_SalvarCCU: TBitBtn;
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form_CCU: TForm_CCU;

implementation

uses UDataModule_Principal;

{$R *.dfm}

procedure TForm_CCU.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  Action := caFree;
  Form_CCU := nil;
end;

end.
