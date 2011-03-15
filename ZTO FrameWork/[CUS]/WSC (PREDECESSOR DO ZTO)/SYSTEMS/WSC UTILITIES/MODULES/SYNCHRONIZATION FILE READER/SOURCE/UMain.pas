unit UMain;

interface

uses
  	Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  	Dialogs, StdCtrls, ExtCtrls, UWSCTypesConstantsAndClasses;

type
  	TFForm_Main = class(TForm)
    	OpenDialog_OpenSyncFile: TOpenDialog;
    	Button_OpenSyncFile: TButton;
    	Memo_Object: TMemo;
    	Memo_Script: TMemo;
    	ListBox_Customers: TListBox;
        Label_Object: TLabel;
        Label_Script: TLabel;
        Label_Customers: TLabel;
        Shape1: TShape;
        Bevel1: TBevel;
        Label1: TLabel;
        GroupBox1: TGroupBox;
        CheckBox1: TCheckBox;
        CheckBox_CompressedFile: TCheckBox;
    	procedure Button_OpenSyncFileClick(Sender: TObject);
    	procedure FormCreate(Sender: TObject);
    	procedure ListBox_CustomersClick(Sender: TObject);
        procedure DoKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
  	private
    	{ Private declarations }
    	SelectedWSCCustomer: TWSCCustomer;
    	procedure OpenSyncFile;
  	public
    	{ Public declarations }
  	end;


var
    FForm_Main: TFForm_Main;

implementation
{ TODO : futuramente deverá ser atribuido um nome diferente para cada unit de
sincronização ou deverá ser inventada uma forma diferente de uso }
uses
	UFSYSyncStructures, UObjectFile;

{$R *.dfm}

procedure TFForm_Main.OpenSyncFile;
begin
	case SelectedWSCCustomer of
        wcUnknown: raise Exception.Create('O cliente selecionado é desconhecido...');
        wcWSC: Application.ProcessMessages;
        wcHitachi: begin { == HITACHI ======================================== }

    	with TSynchronizationFile.Create(Self,CheckBox1.Checked) do
            try
                if CheckBox_CompressedFile.Checked then
                    DescomprimirArquivo(OpenDialog_OpenSyncFile.FileName);

              	LoadFromBinaryFile(OpenDialog_OpenSyncFile.FileName);

                Memo_Object.Text := ToString;
                Memo_Script.Text := ToScript;
            finally
            	Free;
            end;

        end; { ==================================================== HITACHI == }
    end;
end;

procedure TFForm_Main.Button_OpenSyncFileClick(Sender: TObject);
begin
    if ListBox_Customers.ItemIndex = -1 then
    begin
        MessageBox(Handle,'Por favor selecione um cliente na lista','Selecione um cliente primeiro',MB_ICONWARNING);
        ListBox_Customers.SetFocus;
        Exit;
    end;

    if OpenDialog_OpenSyncFile.Execute then
    begin
    	Button_OpenSyncFile.Caption := 'Abrir arquivo de sincronização (' + ExtractFileName(OpenDialog_OpenSyncFile.FileName) + ')';
        OpenSyncFile;
    end;
end;

procedure TFForm_Main.FormCreate(Sender: TObject);
begin
	{ sUBSTITUIR POR CONSULTA A BASE INTERNA DA EMPRESA COM DADOS DO CLIENTE!}
    ListBox_Customers.Clear;
    ListBox_Customers.AddItem('WSC',TObject(0));
	ListBox_Customers.AddItem('Hitachi Ar Condicionado do Brasil',TObject(1));

    Caption := 'DIRETIVAS: ';
    {$IFDEF FTPSYNCCLI}
    Caption := Caption + 'FTPSYNCCLI ';
    {$ENDIF}
    {$IFDEF FTPSYNCSER}
    Caption := Caption + 'FTPSYNCSER ';
    {$ENDIF}
end;

procedure TFForm_Main.ListBox_CustomersClick(Sender: TObject);
begin
    case Integer(ListBox_Customers.Items.Objects[ListBox_Customers.ItemIndex]) of
        0: SelectedWSCCustomer := wcWSC;
        1: SelectedWSCCustomer := wcHitachi;
        else
            SelectedWSCCustomer := wcUnknown;
    end;
end;

procedure TFForm_Main.DoKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
begin
    if (Key = Ord('A')) and (Shift = [ssCtrl]) then
    	TMemo(Sender).SelectAll;
end;

end.
