unit UForm_Principal;

interface

uses
  Windows, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ComCtrls, StdCtrls, Spin, ExtCtrls, CPortCtl, Messages;

type
  TForm_Principal = class(TForm)
    PageControl_Principal: TPageControl;
    TabSheet_Recebimento: TTabSheet;
    TabSheet_Envio: TTabSheet;
    TabSheet_Configuracoes: TTabSheet;
    SpinEdit_TempoAtualizacao: TSpinEdit;
    GroupBox_ConfigGeral: TGroupBox;
    SpinEdit_PortaCom: TSpinEdit;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    GroupBox_ArquivoImagem: TGroupBox;
    Label4: TLabel;
    Edit_ArquivoImagem: TEdit;
    Label5: TLabel;
    GroupBox_ComandosAT: TGroupBox;
    LabeledEdit_Ressetar: TLabeledEdit;
    LabeledEdit_ModoTexto: TLabeledEdit;
    LabeledEdit_TodasAsMensagens: TLabeledEdit;
    LabeledEdit_AreaArmazenamento: TLabeledEdit;
    LabeledEdit_ExcluirMensagem: TLabeledEdit;
    Label6: TLabel;
    Panel_Recebimento: TPanel;
    Button_AtivaDesativaRecebimento: TButton;
    Label7: TLabel;
    ComLed1: TComLed;
    Label8: TLabel;
    GroupBox_DatabaseConfiguration: TGroupBox;
    LabeledEdit_Host: TLabeledEdit;
    LabeledEdit_Usuario: TLabeledEdit;
    LabeledEdit_Esquema: TLabeledEdit;
    LabeledEdit_Senha: TLabeledEdit;
    LabeledEdit_Porta: TLabeledEdit;
    ComboBox_Protocolo: TComboBox;
    Label9: TLabel;
    Button_SalvarConfiguracoes: TButton;
    GroupBox_ComandosSQL: TGroupBox;
    Panel_Configuracoes: TPanel;
    LabeledEdit_SQLInsert: TLabeledEdit;
    Label10: TLabel;
    Label11: TLabel;
    GroupBox_Recebimento: TGroupBox;
    RadioButton_Lidas: TRadioButton;
    RadioButton_NaoLidas: TRadioButton;
    RadioButton_Ambas: TRadioButton;
    Bevel1: TBevel;
    Bevel2: TBevel;
    TabSheet_Terminal: TTabSheet;
    ComTerminal_Modem: TComTerminal;
    LabeledEdit_Lidas: TLabeledEdit;
    LabeledEdit_NaoLidas: TLabeledEdit;
    LabeledEdit_NaoEnviadas: TLabeledEdit;
    LabeledEdit_Enviadas: TLabeledEdit;
    LabeledEdit_ParametrosFixos: TLabeledEdit;
    ListView_Recebimento: TListView;
    LabeledEdit_FormatoData: TLabeledEdit;
    LabeledEdit_FormatoTempo: TLabeledEdit;
    LabeledEdit_FormatoDataTempo: TLabeledEdit;
    TabSheet_AjudaSobre: TTabSheet;
    Memo1: TMemo;
    procedure FormCreate(Sender: TObject);
    procedure Button_SalvarConfiguracoesClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure Button_AtivaDesativaRecebimentoClick(Sender: TObject);
    procedure ListView_RecebimentoAdvancedCustomDrawItem(
      Sender: TCustomListView; Item: TListItem; State: TCustomDrawState;
      Stage: TCustomDrawStage; var DefaultDraw: Boolean);
    procedure ListView_RecebimentoChange(Sender: TObject; Item: TListItem;
      Change: TItemChange);
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
  private
    { Private declarations }
    procedure ConfigParaAplicacao;
    procedure AplicacaoParaConfig;
  public
    { Public declarations }
  end;

var
  Form_Principal: TForm_Principal;

implementation

uses UDataModule_Principal, UConfiguracoes, CPort;

{$R *.dfm}

procedure TForm_Principal.Button_AtivaDesativaRecebimentoClick(Sender: TObject);
var
  Arquivo: TextFile;
begin
  DataModule_Principal.ComPort_Modem.Connected := not DataModule_Principal.ComPort_Modem.Connected;

  if DataModule_Principal.ComPort_Modem.Connected then
  begin
    Button_AtivaDesativaRecebimento.Caption := 'Desativar';

    ComTerminal_Modem.ClearScreen;
    DataModule_Principal.WriteString(Configuracoes.ATCOMMANDSATCMREMO + #13);
    // desabilita as mensagens de status do modem Huaway. Estas mensagens
    // reportam várias informações que sujam o buffer
    DataModule_Principal.WriteString('AT^CURC=0'#13);
    DataModule_Principal.WriteString(Configuracoes.ATCOMMANDSATCMTXFM + #13);
    DataModule_Principal.WriteString(Configuracoes.ATCOMMANDSATCMSTAR + #13);

    try
      FileMode := fmOpenWrite;
      AssignFile(Arquivo,Configuracoes.IMAGEFILEIFCFFINA);
      Rewrite(Arquivo);
      WriteLn(Arquivo,'Monitoramento iniciado às ',FormatDateTime('hh:nn:ss "do dia" dd/mm/yyyy',Now));
      WriteLn(Arquivo,'----------------------------------------------------');
    finally
      CloseFile(Arquivo);
    end;

    Label8.Caption := 'Até agora 0 mensagens foram processadas...';

    DataModule_Principal.ObterMensagens(1);
    ListView_Recebimento.Clear;
  end
  else
  begin
    Button_AtivaDesativaRecebimento.Caption := 'Ativar';
    Application.MessageBox('Por gentileza, desligue o modem, aguarde 5 segundos, ligue o modem novamente e depois aguarde 1 (um) minuto antes de iniciar o monitoramento outra vez','Ação requerida',MB_ICONWARNING);
  end;

  GroupBox_Recebimento.Enabled := not DataModule_Principal.ComPort_Modem.Connected;
end;

procedure TForm_Principal.Button_SalvarConfiguracoesClick(Sender: TObject);
begin
  if DataModule_Principal.ComPort_Modem.Connected then
  begin
    Application.MessageBox('Não é possível salvar as configurações enquanto existem monitoramentos e operações em andamento. Por favor finalize qualquer operação pendente e tente novamente','Não é possível salvar configurações no momento',MB_ICONWARNING);
    Exit;
  end;

  AplicacaoParaConfig;
  Configuracoes.SaveToFile;
end;

procedure TForm_Principal.ConfigParaAplicacao;
begin
  SpinEdit_TempoAtualizacao.Value := Configuracoes.GENERALGECFREIN;

  DataModule_Principal.ComPort_Modem.BaudRate := TBaudRate(Configuracoes.GENERALGECFBARA);
  DataModule_Principal.ComPort_Modem.DataBits := TDataBits(Configuracoes.GENERALGECFDABI);
  DataModule_Principal.ComPort_Modem.FlowControl.FlowControl := TFlowControl(Configuracoes.GENERALGECFFLCO);
  DataModule_Principal.ComPort_Modem.Parity.Bits := TParityBits(Configuracoes.GENERALGECFPARI);
  DataModule_Principal.ComPort_Modem.StopBits := TStopBits(Configuracoes.GENERALGECFSTBI);

  SpinEdit_PortaCom.Value := StrToInt(Copy(Configuracoes.GENERALGECFCOPO,4,3));
  DataModule_Principal.ComPort_Modem.Port := Configuracoes.GENERALGECFCOPO;

  Edit_ArquivoImagem.Text := Configuracoes.IMAGEFILEIFCFFINA;

  LabeledEdit_Ressetar.Text := Configuracoes.ATCOMMANDSATCMREMO;

  LabeledEdit_ModoTexto.Text := Configuracoes.ATCOMMANDSATCMTXFM;

  LabeledEdit_TodasAsMensagens.Text := Configuracoes.ATCOMMANDSATCMALME;

  LabeledEdit_Lidas.Text := Configuracoes.ATCOMMANDSATCMRDME;

  LabeledEdit_NaoLidas.Text := Configuracoes.ATCOMMANDSATCMURME;

  LabeledEdit_Enviadas.Text := Configuracoes.ATCOMMANDSATCMSTME;

  LabeledEdit_NaoEnviadas.Text := Configuracoes.ATCOMMANDSATCMUSME;

  LabeledEdit_ExcluirMensagem.Text := Configuracoes.ATCOMMANDSATCMDEME;

  LabeledEdit_AreaArmazenamento.Text := Configuracoes.ATCOMMANDSATCMSTAR;

  ComboBox_Protocolo.ItemIndex := ComboBox_Protocolo.Items.IndexOf(Configuracoes.DATABASEDBCFDBPR);
  DataModule_Principal.CONNECTION.Protocol := Configuracoes.DATABASEDBCFDBPR;

  LabeledEdit_Host.Text := Configuracoes.DATABASEDBCFHONA;
  DataModule_Principal.CONNECTION.HostName := Configuracoes.DATABASEDBCFHONA;

  LabeledEdit_Porta.Text := IntToStr(Configuracoes.DATABASEDBCFPONU);
  DataModule_Principal.CONNECTION.Port := Configuracoes.DATABASEDBCFPONU;

  LabeledEdit_Usuario.Text := Configuracoes.DATABASEDBCFUSNA;
  DataModule_Principal.CONNECTION.User := Configuracoes.DATABASEDBCFUSNA;

  LabeledEdit_Senha.Text := Configuracoes.DATABASEDBCFUSPA;
  DataModule_Principal.CONNECTION.Password := Configuracoes.DATABASEDBCFUSPA;

  LabeledEdit_Esquema.Text := Configuracoes.DATABASEDBCFSCNA;
  DataModule_Principal.CONNECTION.Database := Configuracoes.DATABASEDBCFSCNA;

  LabeledEdit_SQLInsert.Text := Configuracoes.SQLCOMMANDSSQCMINME;

  LabeledEdit_ParametrosFixos.Text := Configuracoes.SQLCOMMANDSSQCFFXPA;

  LabeledEdit_FormatoData.Text := Configuracoes.SQLCOMMANDSSQCFDAFO;

  LabeledEdit_FormatoTempo.Text := Configuracoes.SQLCOMMANDSSQCFTIFO;

  LabeledEdit_FormatoDataTempo.Text := Configuracoes.SQLCOMMANDSSQCFDTFO;
end;

procedure TForm_Principal.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  AplicacaoParaConfig;
end;

procedure TForm_Principal.FormCloseQuery(Sender: TObject; var CanClose: Boolean);
begin
  CanClose := not DataModule_Principal.ComPort_Modem.Connected;

  if not CanClose then
    Application.MessageBox('Não é possível fechar a aplicação enquanto existem monitoramentos e operações em andamento. Por favor finalize qualquer operação pendente e tente novamente','Não é possível fechar a aplicação no momento',MB_ICONWARNING);
end;

procedure TForm_Principal.FormCreate(Sender: TObject);
begin
  DataModule_Principal.CarregarComboDeProtocolos;
  ConfigParaAplicacao;

  { Customizações desta versão }
  TabSheet_Envio.TabVisible := False;
  Label10.Caption := '<:RCDT:> = Data/Hora do recebimento; <:SDNU:> = Número do remetente; <:MECO:> = Mensagem; <:FXPn:> = Identificação do painel';
  LabeledEdit_ParametrosFixos.EditLabel.Caption := 'Identificação do painel';
end;

procedure TForm_Principal.ListView_RecebimentoAdvancedCustomDrawItem(Sender: TCustomListView; Item: TListItem; State: TCustomDrawState; Stage: TCustomDrawStage; var DefaultDraw: Boolean);
begin
  if Odd(Item.Index) then
    ListView_Recebimento.Canvas.Brush.Color := clInfoBk
  else
    ListView_Recebimento.Canvas.Brush.Color := clWindow;
end;

procedure TForm_Principal.ListView_RecebimentoChange(Sender: TObject; Item: TListItem; Change: TItemChange);
begin
  Label8.Caption := FormatFloat('"Até agora "###,###,###,###,###,###,##0" mensagens foram processadas..."',ListView_Recebimento.Items.Count);
end;

procedure TForm_Principal.AplicacaoParaConfig;
begin
  Configuracoes.GENERALGECFREIN := SpinEdit_TempoAtualizacao.Value;
  Configuracoes.GENERALGECFCOPO := 'COM' + IntToStr(SpinEdit_PortaCom.Value);
  Configuracoes.IMAGEFILEIFCFFINA := Edit_ArquivoImagem.Text;
  Configuracoes.ATCOMMANDSATCMREMO := LabeledEdit_Ressetar.Text;
  Configuracoes.ATCOMMANDSATCMTXFM := LabeledEdit_ModoTexto.Text;
  Configuracoes.ATCOMMANDSATCMALME := LabeledEdit_TodasAsMensagens.Text;
  Configuracoes.ATCOMMANDSATCMRDME := LabeledEdit_Lidas.Text;
  Configuracoes.ATCOMMANDSATCMURME := LabeledEdit_NaoLidas.Text;
  Configuracoes.ATCOMMANDSATCMSTME := LabeledEdit_Enviadas.Text;
  Configuracoes.ATCOMMANDSATCMUSME := LabeledEdit_NaoEnviadas.Text;
  Configuracoes.ATCOMMANDSATCMDEME := LabeledEdit_ExcluirMensagem.Text;
  Configuracoes.ATCOMMANDSATCMSTAR := LabeledEdit_AreaArmazenamento.Text;
  Configuracoes.DATABASEDBCFDBPR := ComboBox_Protocolo.Items[ComboBox_Protocolo.ItemIndex];
  Configuracoes.DATABASEDBCFHONA := LabeledEdit_Host.Text;
  Configuracoes.DATABASEDBCFPONU := StrToInt(LabeledEdit_Porta.Text);
  Configuracoes.DATABASEDBCFUSNA := LabeledEdit_Usuario.Text;
  Configuracoes.DATABASEDBCFUSPA := LabeledEdit_Senha.Text;
  Configuracoes.DATABASEDBCFSCNA := LabeledEdit_Esquema.Text;
  Configuracoes.SQLCOMMANDSSQCMINME := LabeledEdit_SQLInsert.Text;
  Configuracoes.SQLCOMMANDSSQCFFXPA := LabeledEdit_ParametrosFixos.Text;
  Configuracoes.SQLCOMMANDSSQCFDAFO := LabeledEdit_FormatoData.Text;
  Configuracoes.SQLCOMMANDSSQCFTIFO := LabeledEdit_FormatoTempo.Text;
  Configuracoes.SQLCOMMANDSSQCFDTFO := LabeledEdit_FormatoDataTempo.Text;
  ConfigParaAplicacao;


  //  em filecontrol
//  if SelectDirectory(Dir, [sdAllowCreate, sdPerformCreate, sdPrompt], 0) then
//    Label1.Caption := Dir;

////////////////////////////////////////////////////////////////////////////////

//Regex r = new Regex(@"\+CMGL: (\d+),""(.+)"",""(.+)"",(.*),""(.+)""\r\n(.+)\r\n");
//Match m = r.Match(input);
//while (m.Success)
{
ShortMessage msg = new ShortMessage();
msg.Index = int.Parse(m.Groups[1].Value);
msg.Status = m.Groups[2].Value;
msg.Sender = m.Groups[3].Value;
msg.Alphabet = m.Groups[4].Value;
msg.Sent = m.Groups[5].Value;
msg.Message = m.Groups[6].Value;
messages.Add(msg);

m = m.NextMatch();
}
end;

end.




