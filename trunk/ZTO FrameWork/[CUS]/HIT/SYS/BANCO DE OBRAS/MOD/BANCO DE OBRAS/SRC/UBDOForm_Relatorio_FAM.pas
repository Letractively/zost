unit UBDOForm_Relatorio_FAM;

interface

uses
    Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
    Dialogs, UBDOForm_GeradorDeRelatorio, ActnList, ComCtrls, ExtCtrls, Buttons,
    StdCtrls, DBCtrls;

type
    TBDOForm_Relatorio_FAM = class(TBDOForm_GeradorDeRelatorio)
        ComboBox_RegiosDisponiveis: TComboBox;
        Label_RegioesDisponiveis: TLabel;
        Bevel2: TBevel;
        RadioButtonPorRegiao: TRadioButton;
        RadioButtonPorSituacao: TRadioButton;
        Bevel1: TBevel;
        CheckBox_ExibirQuantidades: TCheckBox;
        Panel_PRO_TI_MOEDA_VA_COTACOES: TPanel;
        SpeedButton_PRO_VA_COTACOES: TSpeedButton;
        Label_PRO_VA_COTACOES: TLabel;
        Action_DefinirCotacoes: TAction;
        ComboBox_PRO_TI_MOEDA: TComboBox;
        CheckBox_ExibirTotalGeral: TCheckBox;
        CheckBox_ExibirTotaisParciais: TCheckBox;
        procedure Action_DefinirCotacoesExecute(Sender: TObject);
        procedure DoRecarregar(aSender: TObject);
        procedure Label_RegioesDisponiveisClick(Sender: TObject);
        procedure ComboBox_PRO_TI_MOEDAChange(Sender: TObject);
        procedure FormCreate(Sender: TObject);
    private
        { Private declarations }
    public
        { Public declarations }
    end;


implementation

uses
    UBDODataModule_Relatorio_FAM;

{$R *.dfm}

procedure TBDOForm_Relatorio_FAM.Action_DefinirCotacoesExecute(Sender: TObject);
begin
    inherited;
    TBDODataModule_Relatorio_FAM(CreateParameters.MyDataModule).DefinirCotacoes;
end;

procedure TBDOForm_Relatorio_FAM.ComboBox_PRO_TI_MOEDAChange(Sender: TObject);
begin
    inherited;
    DoRecarregar(Sender);
    MessageBox(Handle,'A moeda de de exibição foi alterada. Ajustes na tabela de cotações podem ser necessários.','Moeda de exibição alterada...',MB_ICONWARNING);
end;

procedure TBDOForm_Relatorio_FAM.DoRecarregar(aSender: TObject);
begin
    ComboBox_RegiosDisponiveis.Enabled := RadioButtonPorRegiao.Checked;
    Label_RegioesDisponiveis.Enabled := ComboBox_RegiosDisponiveis.Enabled;

//    Action_Regerar.Execute;
end;

procedure TBDOForm_Relatorio_FAM.FormCreate(Sender: TObject);
begin
    inherited;
    TBDODataModule_Relatorio_FAM(CreateParameters.MyDataModule).ObterRegioes(ComboBox_RegiosDisponiveis.Items);
    ComboBox_RegiosDisponiveis.ItemIndex := 0;
end;

procedure TBDOForm_Relatorio_FAM.Label_RegioesDisponiveisClick(Sender: TObject);
begin
    inherited;
    TBDODataModule_Relatorio_FAM(CreateParameters.MyDataModule).ObterRegioes(ComboBox_RegiosDisponiveis.Items);
    ComboBox_RegiosDisponiveis.ItemIndex := 0;
    DoRecarregar(Sender);
end;

end.
