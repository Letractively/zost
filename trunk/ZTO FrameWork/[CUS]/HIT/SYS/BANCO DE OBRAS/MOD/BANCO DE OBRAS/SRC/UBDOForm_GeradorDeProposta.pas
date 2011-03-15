unit UBDOForm_GeradorDeProposta;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, UBDOForm_GeradorDeRelatorio, ActnList, OleCtrls, ExtCtrls,
  ComCtrls, Buttons, StdCtrls;

type
    TBDOForm_GeradorDeProposta = class(TBDOForm_GeradorDeRelatorio)
        CheckBox_ExibirValoresUnitarios: TCheckBox;
        CheckBox_ExibirValoresTotaisParciais: TCheckBox;
        CheckBoxExibirReajusteDaProposta: TCheckBox;
        CheckBox_ExibirReajusteDosItens: TCheckBox;
        CheckBox_ExibirSituacaoDaObra: TCheckBox;
        CheckBox_ExibirTipoDaObra: TCheckBox;
        CheckBox_ExibirConstrutora: TCheckBox;
        CheckBox_ExibirInstalador: TCheckBox;
        Bevel2: TBevel;
        Action_DefinirCotacoes: TAction;
        CheckBox_AplicarReajusteNosValoresUnitariosDosItens: TCheckBox;
        CheckBox_AplicarReajusteDaPropostaNosItens: TCheckBox;
        SpeedButton_PRO_VA_COTACOES: TSpeedButton;
        procedure Action_DefinirCotacoesExecute(Sender: TObject);
        procedure FormShow(Sender: TObject);
        procedure DoRecarregar(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    private
        { Private declarations }
        FPropostaID: Cardinal;
    public
        { Public declarations }
        property PropostaID: Cardinal write FPropostaID;
    end;

implementation

uses
    UBDODataModule_GeradorDeProposta;

{$R *.dfm}

procedure TBDOForm_GeradorDeProposta.Action_DefinirCotacoesExecute(Sender: TObject);
begin
    inherited;
    TBDODataModule_GeradorDeProposta(CreateParameters.MyDataModule).DefinirCotacoes;
end;

procedure TBDOForm_GeradorDeProposta.DoRecarregar(Sender: TObject);
begin
    inherited;
    Action_Regerar.Execute;
end;

procedure TBDOForm_GeradorDeProposta.FormCreate(Sender: TObject);
begin
    inherited;
    InitialGeneration := True;
end;

procedure TBDOForm_GeradorDeProposta.FormShow(Sender: TObject);
begin
    TBDODataModule_GeradorDeProposta(CreateParameters.MyDataModule).PropostaID := FPropostaID;
    inherited;
end;

end.
