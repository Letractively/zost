unit UBDOForm_Relatorio_OBR;

interface

uses
    Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
    Dialogs, UBDOForm_GeradorDeRelatorio, ActnList, ComCtrls, Buttons, StdCtrls,
    ExtCtrls;

type
    TBDOForm_Relatorio_OBR = class(TBDOForm_GeradorDeRelatorio)
        RadioButtonPorTipo: TRadioButton;
        RadioButtonPorSituacao: TRadioButton;
        RadioButtonPorEstado: TRadioButton;
        Bevel1: TBevel;
        RadioButtonPorRegiao: TRadioButton;
        Label_RegioesDisponiveis: TLabel;
        ComboBox_RegiosDisponiveis: TComboBox;
        CheckBoxContarComGanhas: TCheckBox;
        CheckBoxContarComPerdidas: TCheckBox;
        CheckBoxContarComSuspensas: TCheckBox;
        CheckBox_DA_DATADEENTRADA1: TCheckBox;
        CheckBox_DA_DATADEENTRADA2: TCheckBox;
        DateTimePicker_DA_DATADEENTRADA1: TDateTimePicker;
        DateTimePicker_DA_DATADEENTRADA2: TDateTimePicker;
        CheckBoxExibirSituacoes: TCheckBox;
        CheckBoxExibirPeriodo: TCheckBox;
        CheckBoxExibirQuantidades: TCheckBox;
        Bevel3: TBevel;
        CheckBoxExibirValores: TCheckBox;
        CheckBoxExibirTotais: TCheckBox;
        Bevel4: TBevel;
        Panel_PRO_TI_MOEDA_VA_COTACOES: TPanel;
        SpeedButton_PRO_VA_COTACOES: TSpeedButton;
        ComboBox_PRO_TI_MOEDA: TComboBox;
        Label_PRO_VA_COTACOES: TLabel;
        Action_DefinirCotacoes: TAction;
        procedure Action_DefinirCotacoesExecute(Sender: TObject);
        procedure ComboBox_PRO_TI_MOEDAChange(Sender: TObject);
        procedure DoRecarregar(aSender: TObject);
        procedure FormCreate(Sender: TObject);
        procedure Label_RegioesDisponiveisClick(Sender: TObject);
        procedure CheckBox_DA_DATADEENTRADA1Click(Sender: TObject);
    private
        { Private declarations }
    public
        { Public declarations }
    end;

implementation

uses
    UBDODataModule_Relatorio_OBR, DateUtils;

{$R *.dfm}

procedure TBDOForm_Relatorio_OBR.Action_DefinirCotacoesExecute(Sender: TObject);
begin
    inherited;
    TBDODataModule_Relatorio_OBR(CreateParameters.MyDataModule).DefinirCotacoes;
end;

procedure TBDOForm_Relatorio_OBR.CheckBox_DA_DATADEENTRADA1Click(Sender: TObject);
begin
    inherited;
    DateTimePicker_DA_DATADEENTRADA1.Enabled := CheckBox_DA_DATADEENTRADA1.Checked;
    DateTimePicker_DA_DATADEENTRADA2.Enabled := CheckBox_DA_DATADEENTRADA2.Checked;

	DoRecarregar(Sender);
end;

procedure TBDOForm_Relatorio_OBR.ComboBox_PRO_TI_MOEDAChange(Sender: TObject);
begin
    inherited;
    DoRecarregar(Sender);
    MessageBox(Handle,'A moeda de de exibição foi alterada. Ajustes na tabela de cotações podem ser necessários.','Moeda de exibição alterada...',MB_ICONWARNING);
end;

procedure TBDOForm_Relatorio_OBR.DoRecarregar(aSender: TObject);
begin
    ComboBox_RegiosDisponiveis.Enabled := RadioButtonPorRegiao.Checked;
    Label_RegioesDisponiveis.Enabled := ComboBox_RegiosDisponiveis.Enabled;

    { Ao menos uma opção tem de permanecer ativa, por isso estes ifs }
    if aSender = CheckBoxExibirQuantidades then
    begin
        if not CheckBoxExibirQuantidades.Checked and not CheckBoxExibirValores.Checked then
            CheckBoxExibirQuantidades.Checked := True;
    end
    else if aSender = CheckBoxExibirValores then
    begin
        if not CheckBoxExibirValores.Checked and not CheckBoxExibirQuantidades.Checked then
          	CheckBoxExibirValores.Checked := True;
    end;

//    Action_Recarregar.Execute;
end;

procedure TBDOForm_Relatorio_OBR.FormCreate(Sender: TObject);
begin
    inherited;
    TBDODataModule_Relatorio_OBR(CreateParameters.MyDataModule).ObterRegioes(ComboBox_RegiosDisponiveis.Items);
    ComboBox_RegiosDisponiveis.ItemIndex := 0;

    DateTimePicker_DA_DATADEENTRADA1.Date := StartOfAYear(YearOf(Now));
    DateTimePicker_DA_DATADEENTRADA2.Date := EndOfTheDay(Now);
end;

procedure TBDOForm_Relatorio_OBR.Label_RegioesDisponiveisClick(Sender: TObject);
begin
    inherited;
    TBDODataModule_Relatorio_OBR(CreateParameters.MyDataModule).ObterRegioes(ComboBox_RegiosDisponiveis.Items);
    ComboBox_RegiosDisponiveis.ItemIndex := 0;
    DoRecarregar(Sender);
end;

end.
