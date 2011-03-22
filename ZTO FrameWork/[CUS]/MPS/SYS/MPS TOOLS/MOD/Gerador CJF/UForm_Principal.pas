unit UForm_Principal;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ComCtrls;

type
  TForm_Principal = class(TForm)
    Button_IniciarGeracao: TButton;
    Memo_Log: TMemo;
    ProgressBar_Principal: TProgressBar;
    procedure Button_IniciarGeracaoClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form_Principal: TForm_Principal;

implementation

uses UDataModule_Principal;

{$R *.dfm}

procedure TForm_Principal.Button_IniciarGeracaoClick(Sender: TObject);
begin
  DataModule_Principal.IniciarGeracaoCJF;
end;

end.
