unit UFSSForm_Configurations;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ExtCtrls, Tabs, Buttons, ComCtrls, ZConnection, CFEdit;

type

  TFSSForm_Configurations = class(TForm)
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
    LabePortaFTP: TLabel;
    EditPortaFTP: TEdit;
    Label1: TLabel;
    GroupBox3: TGroupBox;
    Label2: TLabel;
    Edit1: TCFEdit;
    procedure Edit1KeyPress(Sender: TObject; var Key: Char);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormShow(Sender: TObject);
    procedure FormCreate(Sender: TObject);
  private
    DirAtual: ShortString;
    procedure ExibirConfiguracoes;
    procedure GuardarConfiguracoes;
    { Private declarations }
  public
    { Public declarations }
  end;

var
  FSSForm_Configurations: TFSSForm_Configurations;

implementation

uses
	UFSSForm_Main, UFSYGlobals;

{$R *.dfm}

procedure TFSSForm_Configurations.FormCreate(Sender: TObject);
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



procedure TFSSForm_Configurations.FormShow(Sender: TObject);
begin
  ExibirConfiguracoes;
end;

procedure TFSSForm_Configurations.GuardarConfiguracoes;
begin
	with FSSForm_Main.FSYGlobals.Configurations do
	begin
		DB_Protocol	:= ComboBoxProtocolo.Items[ComboBoxProtocolo.ItemIndex];
		DB_DataBase	:= EditNomeDoBanco.Text;
		DB_PortNumb	:= StrToInt(EditPortaMySQL.Text);
		DB_UserName	:= EditNomeDeUsuarioMySQL.Text;
		DB_Password	:= EditSenhaMySQL.Text;

		FT_PortNumb	:= StrToInt(EditPortaFTP.Text);

    SalvarLogACada := StrToInt(Edit1.Text);
	end;
end;

procedure TFSSForm_Configurations.ExibirConfiguracoes;
begin
	with FSSForm_Main.FSYGlobals.Configurations do
	begin
		ComboBoxProtocolo.ItemIndex := ComboBoxProtocolo.Items.IndexOf(DB_Protocol);
		EditNomeDoBanco.Text := DB_DataBase;
		EditPortaMySQL.Text := IntToStr(DB_PortNumb);
		EditNomeDeUsuarioMySQL.Text := DB_UserName;
		EditSenhaMySQL.Text := DB_Password;
		EditPortaFTP.Text := IntToStr(FT_PortNumb);
    Edit1.Text := IntToStr(SalvarLogACada);
	end;
end;

procedure TFSSForm_Configurations.FormClose(Sender: TObject; var Action: TCloseAction);
begin
	Action := caFree;
  	FSSForm_Configurations := nil;
	GuardarConfiguracoes;

  	if Edit1.Text = '0' then
  	begin
		MessageBox(Handle,'O salvamento automático de logs está desativado','Salvamento automático desativado',MB_ICONINFORMATION);
    	FSSForm_Main.Timer1.Enabled := False;
  	end
  	else
  	begin
    	FSSForm_Main.Timer1.Enabled := False;
  		FSSForm_Main.Timer1.Interval := FSSForm_Main.FSYGlobals.Configurations.SalvarLogACada * 1000;
	  	FSSForm_Main.Timer1.Enabled := True;
  	end;
end;

procedure TFSSForm_Configurations.Edit1KeyPress(Sender: TObject; var Key: Char);
begin
	if not (Key in ['0'..'9']) then
  	Key := #0; 
end;

end.
