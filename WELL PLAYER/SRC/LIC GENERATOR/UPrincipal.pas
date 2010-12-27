unit UPrincipal;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ExtCtrls;

type
  TForm_Principal = class(TForm)
    LabeledEdit_Origem: TLabeledEdit;
    LabeledEdit_Destino: TLabeledEdit;
    Button_Gerar: TButton;
    procedure Button_GerarClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form_Principal: TForm_Principal;

implementation

{$R *.dfm}

uses ZTO.Crypt.Utilities, ZTO.Crypt.Types;

procedure TForm_Principal.Button_GerarClick(Sender: TObject);
begin
  LabeledEdit_Destino.Text := GetStringCheckSum(LabeledEdit_Origem.Text,[haTiger,haSha512,haHaval,haSha384,haRipemd128,haSha256,haRipemd160,haSha1],haSha512);
end;

end.
