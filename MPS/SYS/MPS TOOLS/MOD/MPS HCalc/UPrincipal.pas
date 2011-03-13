unit UPrincipal;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ExtCtrls;

type
  TForm1 = class(TForm)
    LabeledEdit_HoraDeEntrada1: TLabeledEdit;
    LabeledEdit_HoraDeSaida1: TLabeledEdit;
    LabeledEdit_HoraDeEntrada2: TLabeledEdit;
    LabeledEdit_HoraDeSaida2: TLabeledEdit;
    LabeledEdit_Meta: TLabeledEdit;
    LabeledEdit_Somatorio: TLabeledEdit;
    procedure LabeledEdit_HoraDeEntrada1Change(Sender: TObject);
  private
    { Private declarations }
    function Calcular: TTime;
  public
    { Public declarations }
  end;

var
  Form1: TForm1;

implementation

{$R *.dfm}

function TForm1.Calcular: TTime;
var
  Entrada1, Saida1, Entrada2, Saida2: TTime;
begin
  Entrada1 := StrToTime(LabeledEdit_HoraDeEntrada1.Text);
  Saida1 := StrToTime(LabeledEdit_HoraDeSaida1.Text);
  Entrada2 := StrToTime(LabeledEdit_HoraDeEntrada2.Text);
  Saida2 :=  StrToTime(LabeledEdit_HoraDeSaida2.Text);

  Result := 0;
  if (Saida1 > Entrada1) and (Saida2 > Entrada2) then
    Result := Saida1 - Entrada1 + Saida2 - Entrada2;
end;

procedure TForm1.LabeledEdit_HoraDeEntrada1Change(Sender: TObject);
begin
  LabeledEdit_Somatorio.Text := FormatDateTime('hh:nn',Calcular)
end;

end.
