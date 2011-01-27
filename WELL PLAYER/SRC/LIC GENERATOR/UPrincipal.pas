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
    Label_Serial: TLabel;
    Label1: TLabel;
    procedure Button_GerarClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
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

      Label_Serial.Caption := String(GetHDDInfo(0).SerialNumber);

      License := LabeledEdit_MesExpiracao.Text + GetStringCheckSum(Label_Serial.Caption,[haSha512]) + LabeledEdit_AnoExpiracao.Text;

      if IndexOf(License) = -1 then
        Add(License);

      SaveToFile(FileName);
    finally
      Free;
    end;
    showmessage('Lincença Gerada com sucesso!' + #13#10 +
                'Arquivo gerado com sucesso em: '+ FileName );
end;

procedure TForm_Principal.FormCreate(Sender: TObject);
begin
  Label_Serial.Caption := String(GetHDDInfo(0).SerialNumber);
end;

end.
