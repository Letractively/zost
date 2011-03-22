unit UForm_Configuracoes;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ExtCtrls, Buttons, ComCtrls;

type
  TForm_Configuracoes = class(TForm)
    LabeledEdit_Host: TLabeledEdit;
    LabeledEdit_Porta: TLabeledEdit;
    BitBtn_OK: TBitBtn;
    BitBtn_Cancelar: TBitBtn;
    LabeledEdit_Usuario: TLabeledEdit;
    LabeledEdit_Senha: TLabeledEdit;
    PageControl_Opcoes: TPageControl;
    TabSheet_Geral: TTabSheet;
    ComboBox_Formato: TComboBox;
    LabeledEdit_Sistema: TLabeledEdit;
    Label_Formato: TLabel;
    TabSheet_Checagem: TTabSheet;
    LabeledEdit_AutoCheck: TLabeledEdit;
    Label1: TLabel;
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure LabeledEdit_AutoCheckKeyPress(Sender: TObject; var Key: Char);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

implementation

uses
  IniFiles, UGlobalFunctions, USingleEncrypt;

{$R *.dfm}

procedure TForm_Configuracoes.FormCreate(Sender: TObject);
begin
  ComboBox_Formato.Clear;
  ComboBox_Formato.Items.AddObject('SOMENTE TEXTO',TObject(0));
  ComboBox_Formato.Items.AddObject('BINÁRIO',TObject(1));

  with TIniFile.Create(ChangeFileExt(Application.ExeName,'.ini')) do
  begin
    LabeledEdit_Host.Text      := ReadString('CONEXAO','HOST','127.0.0.1');
    LabeledEdit_Porta.Text     := ReadString('CONEXAO','PORT','21');
    LabeledEdit_Usuario.Text   := ReadString('AUTENTICACAO','USER','');
    LabeledEdit_Senha.Text     := Decrypt(ReadString('AUTENTICACAO','PASS',''),12985);
    LabeledEdit_Sistema.Text   := ReadString('CONFIGURACOES','SISTEMA','');
    ComboBox_Formato.ItemIndex := ComboBox_Formato.Items.IndexOfObject(TObject(ReadInteger('CONFIGURACOES','FORMATO',TXT)));
    LabeledEdit_AutoCheck.Text := IntToStr(ReadInteger('AUTOCHECAGEM','INTERVALO',0));
  end;
end;

procedure TForm_Configuracoes.FormDestroy(Sender: TObject);
begin
  if ModalResult = mrOk then
  begin
    with TIniFile.Create(ChangeFileExt(Application.ExeName,'.ini')) do
    begin
      WriteString('CONEXAO','HOST',LabeledEdit_Host.Text);
      WriteString('CONEXAO','PORT',LabeledEdit_Porta.Text);
      WriteString('AUTENTICACAO','USER',LabeledEdit_Usuario.Text);
      WriteString('AUTENTICACAO','PASS',Encrypt(LabeledEdit_Senha.Text,12985));
      WriteString('CONFIGURACOES','SISTEMA',LabeledEdit_Sistema.Text);
      WriteInteger('CONFIGURACOES','FORMATO',Byte(ComboBox_Formato.Items.Objects[ComboBox_Formato.ItemIndex]));
      WriteInteger('AUTOCHECAGEM','INTERVALO',StrToIntDef(LabeledEdit_AutoCheck.Text,0));
    end;
    Application.MessageBox('Algumas configurações só terão efeito após a reinicialização do MPS Updater','Configurações salvas!',MB_ICONINFORMATION);
  end;
end;

procedure TForm_Configuracoes.LabeledEdit_AutoCheckKeyPress(Sender: TObject; var Key: Char);
begin
  if not (Key in ['0'..'9']) then
    Key := #0;
end;

end.
