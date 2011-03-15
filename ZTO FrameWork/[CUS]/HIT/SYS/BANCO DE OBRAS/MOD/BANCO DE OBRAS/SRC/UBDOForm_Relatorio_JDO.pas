unit UBDOForm_Relatorio_JDO;

interface

uses
    Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
    Dialogs, UBDOForm_GeradorDeRelatorio, ActnList, ComCtrls, Buttons, StdCtrls,
    ExtCtrls;

type
    TBDOForm_Relatorio_JDO = class(TBDOForm_GeradorDeRelatorio)
        RadioButton_PorRegiao: TRadioButton;
        RadioButton_PorInstalador: TRadioButton;
        RadioButton_PorFamilia: TRadioButton;
        RadioButton_ApenasSumario: TRadioButton;
        Bevel2: TBevel;
        Label_OpcoesDisponiveis: TLabel;
        ComboBox_OpcaoDeListagem: TComboBox;
        CheckBox_DT_DATAEHORADACRIACAO1: TCheckBox;
        CheckBox_DT_DATAEHORADACRIACAO2: TCheckBox;
        DateTimePicker_DT_DATAEHORADACRIACAO1: TDateTimePicker;
        DateTimePicker_DT_DATAEHORADACRIACAO2: TDateTimePicker;
        CheckBox_ExibirPeriodo: TCheckBox;
        CheckBox_ExibirSumarioGeral: TCheckBox;
        CheckBox_QtdParcCom: TCheckBox;
        Bevel1: TBevel;
        CheckBox_QtdParcTec: TCheckBox;
        CheckBox_QtdParcTot: TCheckBox;
        Bevel3: TBevel;
        procedure DoRecarregar(Sender: TObject);
        procedure Label_OpcoesDisponiveisClick(Sender: TObject);
        procedure FormCreate(Sender: TObject);
        procedure CheckBox_DT_DATAEHORADACRIACAO1Click(Sender: TObject);
    private
        { Private declarations }
        procedure CarregarOpcoesDisponiveis;
    public
        { Public declarations }
    end;


implementation

uses
    UBDODataModule_Relatorio_JDO, DateUtils;

{$R *.dfm}

procedure TBDOForm_Relatorio_JDO.CheckBox_DT_DATAEHORADACRIACAO1Click(Sender: TObject);
begin
    inherited;
    DateTimePicker_DT_DATAEHORADACRIACAO1.Enabled := CheckBox_DT_DATAEHORADACRIACAO1.Checked;
    DateTimePicker_DT_DATAEHORADACRIACAO2.Enabled := CheckBox_DT_DATAEHORADACRIACAO2.Checked;

    if not DateTimePicker_DT_DATAEHORADACRIACAO1.Enabled then
        DateTimePicker_DT_DATAEHORADACRIACAO1.DateTime := StartOfAYear(YearOf(Now));

    if not DateTimePicker_DT_DATAEHORADACRIACAO2.Enabled then
        DateTimePicker_DT_DATAEHORADACRIACAO2.DateTime := EndOfTheDay(Now);

	DoRecarregar(Sender);
end;

procedure TBDOForm_Relatorio_JDO.DoRecarregar(Sender: TObject);
begin
    inherited;
    ComboBox_OpcaoDeListagem.Enabled := not RadioButton_ApenasSumario.Checked;
    Label_OpcoesDisponiveis.Enabled := ComboBox_OpcaoDeListagem.Enabled;

    CheckBox_QtdParcTec.Enabled := not RadioButton_ApenasSumario.Checked;
    CheckBox_QtdParcTot.Enabled := CheckBox_QtdParcTec.Enabled;
    CheckBox_QtdParcCom.Enabled := CheckBox_QtdParcTec.Enabled;

    if RadioButton_ApenasSumario.Checked then
    begin
        Label_OpcoesDisponiveis.Caption := 'Sem opções adicionais de listagem para a opção selecionada';
        ComboBox_OpcaoDeListagem.Clear;
    end
    else if RadioButton_PorRegiao.Checked then
        Label_OpcoesDisponiveis.Caption := 'Região a listar'
    else if RadioButton_PorInstalador.Checked then
        Label_OpcoesDisponiveis.Caption := 'Instalador a listar'
    else if RadioButton_PorFamilia.Checked then
        Label_OpcoesDisponiveis.Caption := 'Família a listar';

    if (Sender = RadioButton_ApenasSumario) or (Sender = RadioButton_PorRegiao)
    or (Sender = RadioButton_PorInstalador) or (Sender = RadioButton_PorFamilia) then
        CarregarOpcoesDisponiveis;

//    Action_Regerar.Execute;
end;

procedure TBDOForm_Relatorio_JDO.FormCreate(Sender: TObject);
begin
    inherited;
    DateTimePicker_DT_DATAEHORADACRIACAO1.Date := StartOfAYear(YearOf(Now));
    DateTimePicker_DT_DATAEHORADACRIACAO2.Date := EndOfTheDay(Now);

    CarregarOpcoesDisponiveis;
end;

procedure TBDOForm_Relatorio_JDO.Label_OpcoesDisponiveisClick(Sender: TObject);
begin
    inherited;
    CarregarOpcoesDisponiveis;
    DoRecarregar(Sender);
end;

procedure TBDOForm_Relatorio_JDO.CarregarOpcoesDisponiveis;
begin
    if RadioButton_PorRegiao.Checked then
        TBDODataModule_Relatorio_JDO(CreateParameters.MyDataModule).ObterRegioes(ComboBox_OpcaoDeListagem.Items)
    else if RadioButton_PorInstalador.Checked then
        TBDODataModule_Relatorio_JDO(CreateParameters.MyDataModule).ObterInstaladores(ComboBox_OpcaoDeListagem.Items)
    else if RadioButton_PorFamilia.Checked then
        TBDODataModule_Relatorio_JDO(CreateParameters.MyDataModule).ObterFamilias(ComboBox_OpcaoDeListagem.Items);
    ComboBox_OpcaoDeListagem.ItemIndex := 0;
end;

end.
