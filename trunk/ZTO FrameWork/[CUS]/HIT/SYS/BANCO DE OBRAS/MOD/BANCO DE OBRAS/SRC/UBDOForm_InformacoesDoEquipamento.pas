unit UBDOForm_InformacoesDoEquipamento;

interface

uses
    Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
    Dialogs, UXXXForm_DialogTemplate, ActnList, ExtCtrls, StdCtrls, Grids,
    DBGrids, UCFDBGrid, DBCtrls;

type
    TBDOForm_InformacoesDoEquipamento = class(TXXXForm_DialogTemplate)
        GroupBox_InformacoesDiretas: TGroupBox;
        CFDBGrid_PropostasRelacionadas: TCFDBGrid;
        Label_Equipamento: TLabel;
        Label_Voltagem: TLabel;
        Label_Mes: TLabel;
        Label_EquipamentoValor: TLabel;
        Label_Ano: TLabel;
        Label_VoltagemValor: TLabel;
        Label_MesValor: TLabel;
        Label_AnoValor: TLabel;
        procedure FormShow(Sender: TObject);
        procedure FormCreate(Sender: TObject);
    private
        { Private declarations }
        FEquipamento: Cardinal;
        FVoltagem: Byte;
        FMes: Byte;
        FAno: Word;
        FLarguraTotal: Word;
    public
        { Public declarations }
        property Mes: Byte write FMes;
        property Ano: Word write FAno;
        property Equipamento: Cardinal write FEquipamento;
        property Voltagem: Byte write FVoltagem;
        property LarguraTotal: Word read FLarguraTotal;
    end;

implementation

uses
    UBDODataModule_InformacoesDoEquipamento;

{$R *.dfm}

procedure TBDOForm_InformacoesDoEquipamento.FormCreate(Sender: TObject);
begin
    inherited;
    FLarguraTotal := GroupBox_InformacoesDiretas.Width - 16;
end;

procedure TBDOForm_InformacoesDoEquipamento.FormShow(Sender: TObject);
begin
    inherited;
    TBDODataModule_InformacoesDoEquipamento(CreateParameters.MyDataModule).Mes := FMes;
    TBDODataModule_InformacoesDoEquipamento(CreateParameters.MyDataModule).Ano := FAno;
    TBDODataModule_InformacoesDoEquipamento(CreateParameters.MyDataModule).EquipamentoId := FEquipamento;
    TBDODataModule_InformacoesDoEquipamento(CreateParameters.MyDataModule).Voltagem := FVoltagem;
    TBDODataModule_InformacoesDoEquipamento(CreateParameters.MyDataModule).ApplyParameters;
end;

end.
