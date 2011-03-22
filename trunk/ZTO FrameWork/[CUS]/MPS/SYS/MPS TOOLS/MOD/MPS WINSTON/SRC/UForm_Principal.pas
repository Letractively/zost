unit UForm_Principal;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, Grids, DBGrids, UCFDBGrid, StdCtrls, DBCtrls, Buttons, ComCtrls,
  ExtCtrls, Mask;

type
  TForm_Principal = class(TForm)
    StatusBar_Principal: TStatusBar;
    Panel_Principal: TPanel;
    DBLookupComboBox_TI_CODIGOSDACCU_ID: TDBLookupComboBox;
    DBText_VA_CODIGO: TDBText;
    Shape_Principal: TShape;
    GroupBox_DataSet: TGroupBox;
    RadioButton_Completo: TRadioButton;
    RadioButton_DoDia: TRadioButton;
    RadioButton_MesEspecifico: TRadioButton;
    DateTimePicker_DataEspecifica: TDateTimePicker;
    Panel_Informacao: TPanel;
    BitBtn_Exportar: TBitBtn;
    GroupBox_Filtro: TGroupBox;
    Label_Sumario: TLabel;
    DBMemo_TX_DESCRICAO: TDBMemo;
    CFDBGrid_CCU: TCFDBGrid;
    RadioButton_MesAtual: TRadioButton;
    LabeledEdit_CCU_TX_DESCRICAO: TLabeledEdit;
    ComboBox_CDC_VA_CODIGO: TComboBox;
    Label_CDC_VA_CODIGO: TLabel;
    Label_CDC_VA_DESCRICAO: TLabel;
    Shape_bg: TShape;
    PageControl_Principal: TPageControl;
    TabSheet_TimeSheet: TTabSheet;
    TabSheet_Livre: TTabSheet;
    BitBtn_IniciarSequencial: TBitBtn;
    BitBtn_Parar: TBitBtn;
    BitBtn_Cancelar: TBitBtn;
    BitBtn_IniciarLivre: TBitBtn;
    BitBtn_CancelarLivre: TBitBtn;
    procedure FormCreate(Sender: TObject);
    procedure DBMemo_TX_DESCRICAOKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure DConfigurarDataSet(Sender: TObject);
    procedure DateTimePicker_DataEspecificaChange(Sender: TObject);
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
    procedure LabeledEdit_CCU_TX_DESCRICAOChange(Sender: TObject);
    procedure ComboBox_CDC_VA_CODIGOChange(Sender: TObject);
    procedure PageControl_PrincipalChange(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form_Principal: TForm_Principal;

implementation

uses UDataModule_Principal, DB;

{$R *.dfm}

procedure TForm_Principal.ComboBox_CDC_VA_CODIGOChange(Sender: TObject);
begin
  Label_CDC_VA_DESCRICAO.Caption := Copy(ComboBox_CDC_VA_CODIGO.Text,Pos('|',ComboBox_CDC_VA_CODIGO.Text) + 1,Length(ComboBox_CDC_VA_CODIGO.Text));
  DataModule_Principal.Filtrar;
end;

procedure TForm_Principal.DateTimePicker_DataEspecificaChange(Sender: TObject);
begin
  DConfigurarDataSet(Sender);
end;

procedure TForm_Principal.DBMemo_TX_DESCRICAOKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
begin
  if (Key = VK_RETURN) and ([ssCtrl] = Shift) then
    DataModule_Principal.Action_SalvarItemSequencial.Execute;
end;

procedure TForm_Principal.FormCloseQuery(Sender: TObject; var CanClose: Boolean);
begin
  CanClose := not (DataModule_Principal.CCU.State in [dsEdit,dsInsert]);

  if not CanClose then
    MessageBox(Handle,'Não é possível fechar a aplicação porque existe uma atividade em execução. Finalize-a ou cancele-a para poder sair','Não é possível sair. Atividade em execução!',MB_ICONWARNING);
end;

procedure TForm_Principal.FormCreate(Sender: TObject);
begin
  DataModule_Principal.ZConnection_Principal.Connect;
  StatusBar_Principal.Panels[0].Text := FormatDateTime(StatusBar_Principal.Panels[0].Text,Now);
  TLabel(DBText_VA_CODIGO).Layout := tlCenter;
  DateTimePicker_DataEspecifica.Date := Now;
end;

procedure TForm_Principal.LabeledEdit_CCU_TX_DESCRICAOChange(Sender: TObject);
begin
  DataModule_Principal.Filtrar;
end;

procedure TForm_Principal.PageControl_PrincipalChange(Sender: TObject);
begin
  if PageControl_Principal.ActivePage = TabSheet_TimeSheet then
  begin
    CFDBGrid_CCU.Options := CFDBGrid_CCU.Options + [dgRowSelect];
    CFDBGrid_CCU.Options := CFDBGrid_CCU.Options - [dgEditing];
//    CFDBGrid_CCU.Options := CFDBGrid_CCU.Options - [dgAlwaysShowEditor];
  end
  else if PageControl_Principal.ActivePage = TabSheet_Livre then
  begin
    CFDBGrid_CCU.Options := CFDBGrid_CCU.Options - [dgRowSelect];
    CFDBGrid_CCU.Options := CFDBGrid_CCU.Options + [dgEditing];
//    CFDBGrid_CCU.Options := CFDBGrid_CCU.Options + [dgAlwaysShowEditor];
  end;
  CFDBGrid_CCU.Refresh;
end;

procedure TForm_Principal.DConfigurarDataSet(Sender: TObject);
begin
  DateTimePicker_DataEspecifica.Enabled := RadioButton_MesEspecifico.Checked;
  DataModule_Principal.Action_ConfigurarDataSet.Execute;
end;

end.
