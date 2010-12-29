unit UPrincipal;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ExtCtrls;

type
  TForm_Principal = class(TForm)
    Button_Gerar: TButton;
    LabeledEdit_MesExpiracao: TLabeledEdit;
    LabeledEdit_AnoExpiracao: TLabeledEdit;
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

uses ZTO.Crypt.Utilities, ZTO.Crypt.Types, UHDDInfo;

procedure TForm_Principal.Button_GerarClick(Sender: TObject);
var
  FileName: String;
  License: String;
begin
  FileName := ChangeFileExt(Application.ExeName,'.lic');

  with TStringList.Create do
    try
      if FileExists(FileName) then
        LoadFromFile(FileName);

      License := LabeledEdit_MesExpiracao.Text + GetStringCheckSum(GetHDDInfo(0).SerialNumber,[haSha512]) + LabeledEdit_AnoExpiracao.Text;

      if IndexOf(License) = -1 then
        Add(License);

      SaveToFile(FileName);
    finally
      Free;
    end;
end;

end.
