unit UBDOForm_Relatorio_PRO;

interface

uses
    Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
    Dialogs, UBDOForm_GeradorDeRelatorio, ActnList, ComCtrls, Buttons, StdCtrls,
    ExtCtrls, CheckLst, Menus, ActnPopup;

type
    TBDOForm_Relatorio_PRO = class(TBDOForm_GeradorDeRelatorio)
        Action_DefinirCotacoes: TAction;
        Bevel1: TBevel;
        RadioButton_Normal: TRadioButton;
        RadioButton_PorRegiao: TRadioButton;
        Panel1: TPanel;
        RadioButton_OrdenarPorCodigo: TRadioButton;
        RadioButton_OrdenarPorValor: TRadioButton;
        RadioButton_OrdenarPorSituacao: TRadioButton;
        CheckBoxContarComGanhas: TCheckBox;
        CheckBoxContarComPerdidas: TCheckBox;
        CheckBoxContarComSuspensas: TCheckBox;
        CheckBox_DA_DATADEENTRADA1: TCheckBox;
        CheckBox_DA_DATADEENTRADA2: TCheckBox;
        DateTimePicker_DA_DATADEENTRADA1: TDateTimePicker;
        DateTimePicker_DA_DATADEENTRADA2: TDateTimePicker;
        Bevel3: TBevel;
        Bevel4: TBevel;
        CheckBoxExibirPeriodo: TCheckBox;
        CheckBoxExibirValores: TCheckBox;
        CheckBoxExibirTotais: TCheckBox;
        CheckBoxExibirInstaladores: TCheckBox;
        Panel_PRO_TI_MOEDA_VA_COTACOES: TPanel;
        SpeedButton_PRO_VA_COTACOES: TSpeedButton;
        ComboBox_PRO_TI_MOEDA: TComboBox;
        Label_PRO_VA_COTACOES: TLabel;
        Bevel5: TBevel;
        Label_OpcoesDisponiveis: TLabel;
        ComboBox_OpcaoDeListagem: TComboBox;
        RadioButton_PorInstalador: TRadioButton;
        Bevel2: TBevel;
        RadioButton_PorSituacao: TRadioButton;
        Label_SituacoesAExibir: TLabel;
        CheckListBox_SituacoesAListar: TCheckListBox;
        Shape_SituacoesAExibir: TShape;
        Action_MarcarTodas: TAction;
        Action_InverterMarcas: TAction;
        Action_SomenteGPS: TAction;
        Action_SomenteG: TAction;
        Action_SomenteP: TAction;
        Action_SomenteS: TAction;
        PopupActionBar_OpcoesDeChecagem: TPopupActionBar;
        MenuItem_ChecarTodas: TMenuItem;
        MenuItem_InverterChecagens: TMenuItem;
        N1: TMenuItem;
        MenuItem_SomenteGanhasPerdidasSuspensas: TMenuItem;
        MenuItem_SomenteGanhas: TMenuItem;
        MenuItem_SomentePerdidas: TMenuItem;
        MenuItem_SomenteSuspensas: TMenuItem;
        procedure Action_DefinirCotacoesExecute(Sender: TObject);
        procedure CheckBox_DA_DATADEENTRADA1Click(Sender: TObject);
        procedure ComboBox_PRO_TI_MOEDAChange(Sender: TObject);
        procedure DoRecarregar(aSender: TObject);
        procedure FormCreate(Sender: TObject);
        procedure Label_OpcoesDisponiveisClick(Sender: TObject);
        procedure Action_MarcarTodasExecute(Sender: TObject);
        procedure Action_InverterMarcasExecute(Sender: TObject);
        procedure Action_SomenteGPSExecute(Sender: TObject);
        procedure Action_SomenteGExecute(Sender: TObject);
        procedure Action_SomentePExecute(Sender: TObject);
        procedure Action_SomenteSExecute(Sender: TObject);
    private
        { Private declarations }
        FRecarregar: Boolean;
        procedure CarregarOpcoesDisponiveis;
    protected
        procedure DoBeforeNavigate2(      ASender: TObject;
                                    const pDisp: IDispatch;
                                      var URL
                                        , Flags
                                        , TargetFrameName
                                        , PostData
                                        , Headers: OleVariant;
                                      var Cancel: WordBool); override;
    public
        { Public declarations }
    end;

implementation

uses
    UBDODataModule_Relatorio_PRO, DateUtils;

{$R *.dfm}

procedure TBDOForm_Relatorio_PRO.Action_DefinirCotacoesExecute(Sender: TObject);
begin
    inherited;
    TBDODataModule_Relatorio_PRO(CreateParameters.MyDataModule).DefinirCotacoes;
end;

procedure TBDOForm_Relatorio_PRO.Action_InverterMarcasExecute(Sender: TObject);
var
    i: Word;
begin
    inherited;
	if CheckListBox_SituacoesAListar.Count > 0 then
		for i := 0 to Pred(CheckListBox_SituacoesAListar.Count) do
        	CheckListBox_SituacoesAListar.Checked[i] := not CheckListBox_SituacoesAListar.Checked[i];

	DoRecarregar(Sender);
end;

procedure TBDOForm_Relatorio_PRO.Action_MarcarTodasExecute(Sender: TObject);
var
    i: Word;
begin
    inherited;
	if CheckListBox_SituacoesAListar.Count > 0 then
		for i := 0 to Pred(CheckListBox_SituacoesAListar.Count) do
        	CheckListBox_SituacoesAListar.Checked[i] := True;

	DoRecarregar(Sender);
end;

procedure TBDOForm_Relatorio_PRO.Action_SomenteGExecute(Sender: TObject);
var
    i: Word;
begin
    inherited;
	if CheckListBox_SituacoesAListar.Count > 0 then
		for i := 0 to Pred(CheckListBox_SituacoesAListar.Count) do
        	CheckListBox_SituacoesAListar.Checked[i] := UpperCase(CheckListBox_SituacoesAListar.Items[i]) = 'GANHA';

	DoRecarregar(Sender);
end;

procedure TBDOForm_Relatorio_PRO.Action_SomenteGPSExecute(Sender: TObject);
var
    i: Word;
begin
    inherited;
	if CheckListBox_SituacoesAListar.Count > 0 then
		for i := 0 to Pred(CheckListBox_SituacoesAListar.Count) do
        	CheckListBox_SituacoesAListar.Checked[i] :=
            (UpperCase(CheckListBox_SituacoesAListar.Items[i]) = 'GANHA') or
            (UpperCase(CheckListBox_SituacoesAListar.Items[i]) = 'PERDIDA') or
            (UpperCase(CheckListBox_SituacoesAListar.Items[i]) = 'SUSPENSA');

	DoRecarregar(Sender);
end;

procedure TBDOForm_Relatorio_PRO.Action_SomentePExecute(Sender: TObject);
var
    i: Word;
begin
    inherited;
	if CheckListBox_SituacoesAListar.Count > 0 then
		for i := 0 to Pred(CheckListBox_SituacoesAListar.Count) do
        	CheckListBox_SituacoesAListar.Checked[i] := UpperCase(CheckListBox_SituacoesAListar.Items[i]) = 'PERDIDA';

	DoRecarregar(Sender);
end;

procedure TBDOForm_Relatorio_PRO.Action_SomenteSExecute(Sender: TObject);
var
    i: Word;
begin
    inherited;
	if CheckListBox_SituacoesAListar.Count > 0 then
		for i := 0 to Pred(CheckListBox_SituacoesAListar.Count) do
        	CheckListBox_SituacoesAListar.Checked[i] := UpperCase(CheckListBox_SituacoesAListar.Items[i]) = 'SUSPENSA';

	DoRecarregar(Sender);
end;

procedure TBDOForm_Relatorio_PRO.CarregarOpcoesDisponiveis;
begin
    if RadioButton_PorRegiao.Checked then
    begin
        TBDODataModule_Relatorio_PRO(CreateParameters.MyDataModule).ObterRegioes(ComboBox_OpcaoDeListagem.Items);
        ComboBox_OpcaoDeListagem.ItemIndex := 0;
    end
    else if RadioButton_PorInstalador.Checked then
    begin
        TBDODataModule_Relatorio_PRO(CreateParameters.MyDataModule).ObterInstaladores(ComboBox_OpcaoDeListagem.Items);
        ComboBox_OpcaoDeListagem.ItemIndex := 0;
    end
    else if RadioButton_PorSituacao.Checked then
    begin
        TBDODataModule_Relatorio_PRO(CreateParameters.MyDataModule).ObterSituacoes(CheckListBox_SituacoesAListar.Items);
        try
            FRecarregar := False;
            { Ao chamar isso, automaticamente o método DoRecarregar é chamado e
            este último por sua vez chama este método (CarregarOpcoesDisponiveis)
            o que geraria recursividade infinita, mas isso não ocorre pois ao
            executar "Action_MarcarTodas.Execute" o Sender não será mais nenhum
            daqueles listado }
            Action_MarcarTodas.Execute;
        finally
            FRecarregar := True;
        end;
    end;
end;

procedure TBDOForm_Relatorio_PRO.CheckBox_DA_DATADEENTRADA1Click(Sender: TObject);
begin
    inherited;
    DateTimePicker_DA_DATADEENTRADA1.Enabled := CheckBox_DA_DATADEENTRADA1.Checked;
    DateTimePicker_DA_DATADEENTRADA2.Enabled := CheckBox_DA_DATADEENTRADA2.Checked;

	DoRecarregar(Sender);
end;

procedure TBDOForm_Relatorio_PRO.ComboBox_PRO_TI_MOEDAChange(Sender: TObject);
begin
    inherited;
    DoRecarregar(Sender);
    MessageBox(Handle,'A moeda de de exibição foi alterada. Ajustes na tabela de cotações podem ser necessários.','Moeda de exibição alterada...',MB_ICONWARNING);
end;

procedure TBDOForm_Relatorio_PRO.DoRecarregar(aSender: TObject);
begin
    ComboBox_OpcaoDeListagem.Enabled := RadioButton_PorRegiao.Checked or RadioButton_PorInstalador.Checked;
    Label_OpcoesDisponiveis.Enabled := ComboBox_OpcaoDeListagem.Enabled;

    CheckBoxExibirInstaladores.Enabled := not RadioButton_PorInstalador.Checked;

    CheckBoxContarComGanhas.Visible := not RadioButton_PorSituacao.Checked;
    CheckBoxContarComPerdidas.Visible := CheckBoxContarComGanhas.Visible;
    CheckBoxContarComSuspensas.Visible := CheckBoxContarComGanhas.Visible;
    Bevel5.Visible := CheckBoxContarComGanhas.Visible;
    Label_OpcoesDisponiveis.Visible := CheckBoxContarComGanhas.Visible;
    ComboBox_OpcaoDeListagem.Visible := CheckBoxContarComGanhas.Visible;
    Bevel2.Visible := CheckBoxContarComGanhas.Visible;

    Label_SituacoesAExibir.Visible := RadioButton_PorSituacao.Checked;
    CheckListBox_SituacoesAListar.Visible := Label_SituacoesAExibir.Visible;
    Shape_SituacoesAExibir.Visible := Label_SituacoesAExibir.Visible;

    if RadioButton_Normal.Checked then
    begin
        Label_OpcoesDisponiveis.Caption := 'Sem opções adicionais de filtragem para a opção selecionada';
        ComboBox_OpcaoDeListagem.Clear;
    end
    else if RadioButton_PorRegiao.Checked then
        Label_OpcoesDisponiveis.Caption := 'Região a listar'
    else if RadioButton_PorInstalador.Checked then
        Label_OpcoesDisponiveis.Caption := 'Instalador a listar';

    if (aSender = RadioButton_Normal) or (aSender = RadioButton_PorRegiao)
    or (aSender = RadioButton_PorInstalador) or (aSender = RadioButton_PorSituacao) then
        CarregarOpcoesDisponiveis;

//    if FRecarregar then
//        Action_Regerar.Execute;
end;


procedure TBDOForm_Relatorio_PRO.FormCreate(Sender: TObject);
begin
    inherited;
    DateTimePicker_DA_DATADEENTRADA1.Date := StartOfAYear(YearOf(Now));
    DateTimePicker_DA_DATADEENTRADA2.Date := EndOfTheDay(Now);

    FRecarregar := True;
    
    CarregarOpcoesDisponiveis;
end;

procedure TBDOForm_Relatorio_PRO.Label_OpcoesDisponiveisClick(Sender: TObject);
begin
    inherited;
    CarregarOpcoesDisponiveis;
    DoRecarregar(Sender);
end;

procedure TBDOForm_Relatorio_PRO.DoBeforeNavigate2(      ASender: TObject;
                                                   const pDisp: IDispatch;
                                                     var URL
                                                       , Flags
                                                       , TargetFrameName
                                                       , PostData
                                                       , Headers: OleVariant;
                                                     var Cancel: WordBool);
var
	Id: String;
begin
  	inherited;
    Id := ExtractFileName(StringReplace(URL,'/','\',[rfReplaceAll]));
    if Pos('@',Id) = 1 then
    begin
        Delete(Id,1,1);
    	TBDODataModule_Relatorio_PRO(CreateParameters.MyDataModule).ExibirInformacoesDaProposta(StrToInt(Id));
        Cancel := True;
    end;
end;


end.
