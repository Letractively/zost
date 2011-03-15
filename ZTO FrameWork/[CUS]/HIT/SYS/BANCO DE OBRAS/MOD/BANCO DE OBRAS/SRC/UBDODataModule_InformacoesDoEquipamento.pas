unit UBDODataModule_InformacoesDoEquipamento;

interface

uses
    Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
    Dialogs, UBDODataModule, ImgList, ActnList, DB, ZAbstractRODataset, ZDataset, 
    UBDOForm_InformacoesDoEquipamento;

type
    TBDODataModule_InformacoesDoEquipamento = class(TBDODataModule)
        PROPOSTAS: TZReadOnlyQuery;
        DataSource_PRO: TDataSource;
    private
        { Private declarations }
        FEquipamentoId: Cardinal;
        FVoltagem: Byte;
        FMes: Byte;
        FAno: Word;
        function MyModule: TBDOForm_InformacoesDoEquipamento;
    public
        { Public declarations }
        procedure ApplyParameters;

        property Mes: Byte write FMes;
        property Ano: Word write FAno;
        property EquipamentoId: Cardinal write FEquipamentoId;
        property Voltagem: Byte write FVoltagem;
    end;

implementation

uses
    UBDOTypesConstantsAndClasses;

{$R *.dfm}


{ TBDODataModule_InformacoesDoEquipamento }

function TBDODataModule_InformacoesDoEquipamento.MyModule: TBDOForm_InformacoesDoEquipamento;
begin
    Result := TBDOForm_InformacoesDoEquipamento(Owner);
end;

procedure TBDODataModule_InformacoesDoEquipamento.ApplyParameters;
begin
    PROPOSTAS.ParamByName('IN_EQUIPAMENTOS_ID').AsInteger := FEquipamentoId;
    PROPOSTAS.ParamByName('TI_MESPROVAVELDEENTREGA').AsInteger := FMes;
    PROPOSTAS.ParamByName('YR_ANOPROVAVELDEENTREGA').AsInteger := FAno;
    PROPOSTAS.ParamByName('EN_VOLTAGEM').AsString := VOLTAGENS[FVoltagem];
    PROPOSTAS.Refresh;

    MyModule.Label_EquipamentoValor.Caption := inherited Equipamento(FEquipamentoId);
 	MyModule.Label_Equipamento.Width := MyModule.LarguraTotal - MyModule.Label_EquipamentoValor.Width - 6;

    MyModule.Label_VoltagemValor.Caption := VOLTAGENS[FVoltagem];
 	MyModule.Label_Voltagem.Width := MyModule.LarguraTotal - MyModule.Label_VoltagemValor.Width - 6;

    MyModule.Label_MesValor.Caption := FormatDateTime('mmmm',EncodeDate(1978,FMes,1));
 	MyModule.Label_Mes.Width := MyModule.LarguraTotal - MyModule.Label_MesValor.Width - 6;

    MyModule.Label_AnoValor.Caption := IntToStr(FAno);
 	MyModule.Label_Ano.Width := MyModule.LarguraTotal - MyModule.Label_AnoValor.Width - 6;
end;

end.
