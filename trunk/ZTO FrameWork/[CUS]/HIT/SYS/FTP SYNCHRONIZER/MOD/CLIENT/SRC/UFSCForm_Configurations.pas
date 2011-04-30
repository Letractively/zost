unit UFSCForm_Configurations;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ExtCtrls, Tabs, Buttons, ComCtrls, ZConnection;

type

  TFSCForm_Configurations = class(TForm)
    GroupBox1: TGroupBox;
    LabelProtocolo: TLabel;
    LabelNomeDoBanco: TLabel;
    LabelPortaMySQL: TLabel;
    LabelNomeDeUsuarioMySQL: TLabel;
    LabelSenhaMySQL: TLabel;
    ComboBoxProtocolo: TComboBox;
    EditNomeDoBanco: TEdit;
    EditPortaMySQL: TEdit;
    EditSenhaMySQL: TEdit;
    EditNomeDeUsuarioMySQL: TEdit;
    GroupBox2: TGroupBox;
    LabelEnderecoDoServidor: TLabel;
    LabePortaFTP: TLabel;
    LabelNomeDeUsuarioFTP: TLabel;
    LabelSenhaFTP: TLabel;
    EditEnderecoDoServidor: TEdit;
    EditPortaFTP: TEdit;
    EditSenhaFTP: TEdit;
    EditNomeDeUsuarioFTP: TEdit;
    GroupBox_ConfiguracoesGerais: TGroupBox;
    CheckBox_ModoPassivo: TCheckBox;
    LabeledEdit_DelayDeComandos: TLabeledEdit;
    CheckBox_VerboseMode: TCheckBox;
    CheckBox_ChecarMD5: TCheckBox;
    CheckBox_Compressao: TCheckBox;
    LabeledEdit_TimeOut: TLabeledEdit;
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormShow(Sender: TObject);
    procedure FormCreate(Sender: TObject);
  private
    DirAtual: String;
    procedure ExibirConfiguracoes;
    procedure GuardarConfiguracoes;
    { Private declarations }
  public
    { Public declarations }
  end;

var
  FSCForm_Configurations: TFSCForm_Configurations;

implementation

uses
	UFSCForm_Main, UFSYTypesConstantsAndClasses;

{$R *.dfm}

procedure TFSCForm_Configurations.FormCreate(Sender: TObject);
var
	MyConnection: TZConnection;
  Achou: Boolean;
  i: Byte;
begin
	inherited;
	DirAtual := ExtractFilePath(Application.ExeName);

	MyConnection := nil;
	try
		MyConnection := TZConnection.Create(Self);
		MyConnection.GetProtocolNames(ComboBoxProtocolo.Items);
	finally
		MyConnection.Free;
	end;

  Achou := True;
  while Achou do
  begin
  	Achou := False;
  	for i := 0 to Pred(ComboBoxProtocolo.Items.Count) do
    	if not (Pos('MYSQL',UpperCase(ComboBoxProtocolo.Items[i])) <> 0) then
      begin
	  		ComboBoxProtocolo.Items.Delete(i);
        Achou := True;
        Break;
      end;
  end;
end;

procedure TFSCForm_Configurations.FormShow(Sender: TObject);
begin
  ExibirConfiguracoes;
end;

procedure TFSCForm_Configurations.GuardarConfiguracoes;
begin
	with FSCForm_Main.FSYGlobals.Configurations do
	begin
		DB_Protocol	:= ShortString(ComboBoxProtocolo.Items[ComboBoxProtocolo.ItemIndex]);
		DB_Database	:= ShortString(EditNomeDoBanco.Text);
		DB_PortNumb	:= StrToInt(EditPortaMySQL.Text);
		DB_UserName	:= ShortString(EditNomeDeUsuarioMySQL.Text);
		DB_Password	:= ShortString(EditSenhaMySQL.Text);

    FT_HostName := ShortString(EditEnderecoDoServidor.Text);
    FT_PortNumb := StrToInt(EditPortaFTP.Text);
    FT_UserName := ShortString(EditNomeDeUsuarioFTP.Text);
    FT_PassWord := ShortString(EditSenhaFTP.Text);
    FT_PassiveMode := CheckBox_ModoPassivo.Checked;
    FT_CommandDelay := StrToIntDef(LabeledEdit_DelayDeComandos.Text,0);
    FT_TimeOut := StrToIntDef(LabeledEdit_TimeOut.Text,1200);

    VerboseMode := CheckBox_VerboseMode.Checked;
    CheckMD5 := CheckBox_ChecarMD5.Checked;
    UseCompression := CheckBox_Compressao.Checked;
	end;
end;

procedure TFSCForm_Configurations.ExibirConfiguracoes;
begin
	with FSCForm_Main.FSYGlobals.Configurations do
	begin
		ComboBoxProtocolo.ItemIndex := ComboBoxProtocolo.Items.IndexOf(String(DB_Protocol));
		EditNomeDoBanco.Text := String(DB_Database);
		EditPortaMySQL.Text := IntToStr(DB_PortNumb);
		EditNomeDeUsuarioMySQL.Text := String(DB_UserName);
		EditSenhaMySQL.Text := String(DB_Password);

		EditEnderecoDoServidor.Text := String(FT_HostName);
		EditPortaFTP.Text := IntToStr(FT_PortNumb);
		EditNomeDeUsuarioFTP.Text := String(FT_UserName);
		EditSenhaFTP.Text := String(FT_Password);
    CheckBox_ModoPassivo.Checked := FT_PassiveMode;
    LabeledEdit_DelayDeComandos.Text := IntToStr(FT_CommandDelay);
    LabeledEdit_TimeOut.Text := IntToStr(FT_TimeOut);

    CheckBox_VerboseMode.Checked := VerboseMode;
    CheckBox_ChecarMD5.Checked := CheckMD5;
    CheckBox_Compressao.Checked := UseCompression;
  end;
end;

procedure TFSCForm_Configurations.FormClose(Sender: TObject; var Action: TCloseAction);
begin
	Action := caFree;
	FSCForm_Configurations := nil;
	GuardarConfiguracoes;
end;

end.
