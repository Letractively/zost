unit UForm_Principal;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ComCtrls, StdCtrls, ExtCtrls;

type
  TForm_Principal = class(TForm)
    PageControl_Principal: TPageControl;
    TabSheet_MensagensAutomaticas: TTabSheet;
    TabSheet_Configuracoes: TTabSheet;
    ListBox_ListaDeMensagens: TListBox;
    TabSheet_Sobre: TTabSheet;
    Button_CarregarMensagens: TButton;
    Button_AtivarAutoitter: TButton;
    Button_AdicionarMensagem: TButton;
    Edit_AdicionarMensagem: TEdit;
    Label_Info1: TLabel;
    Panel_MensagensAutomaticas: TPanel;
    Panel_BotoesMensagensAutomaticas: TPanel;
    Label_CaracteresRestantes: TLabel;
    GroupBox_InfoUsuario: TGroupBox;
    TabSheet_MensagensAvulsas: TTabSheet;
    procedure Edit_AdicionarMensagemChange(Sender: TObject);
  private
    { Private declarations }
    procedure DoEdit_MensagemAvulsaChange(aEdit: TEdit);
  public
    { Public declarations }
  end;

var
  Form_Principal: TForm_Principal;

implementation

{$R *.dfm}

procedure TForm_Principal.DoEdit_MensagemAvulsaChange(aEdit: TEdit);
var
  Restantes: Byte;
begin
  Restantes := 140 - Length(aEdit.Text);

  if Restantes < 16 then
    Label_CaracteresRestantes.Font.Color := clRed
  else if Restantes < 71 then
    Label_CaracteresRestantes.Font.Color := $000080FF
  else
    Label_CaracteresRestantes.Font.Color := clGreen;

  Label_CaracteresRestantes.Caption := 'Restam ' + IntToStr(Restantes) + ' caracteres';
end;

procedure TForm_Principal.Edit_AdicionarMensagemChange(Sender: TObject);
begin
  DoEdit_MensagemAvulsaChange(Sender as TEdit);
end;

end.
