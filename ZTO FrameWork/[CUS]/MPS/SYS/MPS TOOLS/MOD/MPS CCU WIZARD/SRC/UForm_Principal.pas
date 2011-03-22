unit UForm_Principal;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ComCtrls, ExtCtrls, StdCtrls, Buttons;

type
  TForm_Principal = class(TForm)
    PageControl_Principal: TPageControl;
    TabSheet_CCU: TTabSheet;
    TabSheet_Conexao: TTabSheet;
    PageControl_CCU: TPageControl;
    TabSheet_Texto: TTabSheet;
    TabSheet_Grid: TTabSheet;
    Panel_Botoes: TPanel;
    BitBtn_Obter: TBitBtn;
    BitBtn_Salvar: TBitBtn;
    LabeledEdit_Matricula: TLabeledEdit;
    LabeledEdit_Senha: TLabeledEdit;
    LabeledEdit_Periodo: TLabeledEdit;
    LabeledEdit_UsuarioIntranet: TLabeledEdit;
    LabeledEdit_SenhaIntranet: TLabeledEdit;
    RichEdit_CCU: TRichEdit;
    procedure BitBtn_ObterClick(Sender: TObject);
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

procedure TForm_Principal.BitBtn_ObterClick(Sender: TObject);
begin
  DataModule_Principal.GetCCU;
end;

end.
