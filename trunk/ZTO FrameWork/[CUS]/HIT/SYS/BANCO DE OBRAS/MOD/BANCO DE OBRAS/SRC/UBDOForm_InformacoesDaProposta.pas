unit UBDOForm_InformacoesDaProposta;

interface

uses
    Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
    Dialogs, UXXXForm_DialogTemplate, ActnList, ExtCtrls, StdCtrls, Grids,
    UCFDBGrid, DBCtrls, ComCtrls, DBGrids;

type
    TBDOForm_InformacoesDaProposta = class(TXXXForm_DialogTemplate)
        PageControl_InformacoesDaProposta: TPageControl;
        TabSheet_ItensEEquipamentos: TTabSheet;
        TabSheet_DadosDaProposta: TTabSheet;
        CFDBGrid_ITE: TCFDBGrid;
        CFDBGrid_EDI: TCFDBGrid;
        TabSheet_InformacoesDosRegistros: TTabSheet;
        GroupBox_InformacoesDoRegistro: TGroupBox;
        Label_CreationDateAndTime: TLabel;
        Label_CreationDateAndTimeValor: TLabel;
        Label_CreatorFullName: TLabel;
        Label_CreatorFullNameValor: TLabel;
        Label_LastModificationDateAndTime: TLabel;
        Label_LastModificationDateAndTimeValor: TLabel;
        Label_LastModifierFullName: TLabel;
        Label_LastModifierFullNameValor: TLabel;
        Label_CreatorId: TLabel;
        Label_CreatorIdValor: TLabel;
        Label_LastModifierId: TLabel;
        Label_LastModifierIdValor: TLabel;
        Label_RecordStatus: TLabel;
        Label_RecordStatusValor: TLabel;
        Panel1: TPanel;
        Shape1: TShape;
        DBText_PRO_IN_PROPOSTAS_ID: TDBText;
        Panel_OBR_IN_OBRAS_ID: TPanel;
        Shape_OBR_IN_OBRAS_ID: TShape;
        DBText_OBR_IN_OBRAS_ID: TDBText;
        GroupBox_Obra: TGroupBox;
        Label_Obra: TLabel;
        Label_Validade: TLabel;
        Label_DataDeEntrada: TLabel;
        DBText_ObraValor: TDBText;
        DBText_ValidadeValor: TDBText;
        DBText_DataDeEntradaValor: TDBText;
        Label_Localidade: TLabel;
        DBText_LocalidadeValor: TDBText;
        Label_Situacao: TLabel;
        DBText_SituacaoValor: TDBText;
        Label_PrevisaoDeConclusao: TLabel;
        DBText_PrevisaoDeConclusaoValor: TDBText;
        Label_Construtora: TLabel;
        DBText_ConstrutoraValor: TDBText;
        Label_Projetista: TLabel;
        DBText_ProjetistaValor: TDBText;
        GroupBox_Proposta: TGroupBox;
        Label_Instalador: TLabel;
        DBText_InstaladorValor: TDBText;
        Label_MoedaOriginal: TLabel;
        DBText_MoedaOriginalValor: TDBText;
        Label_Contato: TLabel;
        DBText_ContatoValor: TDBText;
        GroupBox_InformacoesDoRegistro2: TGroupBox;
        Label_CreationDateAndTime2: TLabel;
        Label_CreationDateAndTime2Valor: TLabel;
        Label_CreatorFullName2: TLabel;
        Label_CreatorFullName2Valor: TLabel;
        Label_LastModificationDateAndTime2: TLabel;
        Label_LastModificationDateAndTime2Valor: TLabel;
        Label_LastModifierFullName2: TLabel;
        Label_LastModifierFullName2Valor: TLabel;
        Label_CreatorId2: TLabel;
        Label_CreatorId2Valor: TLabel;
        Label_LastModifierId2: TLabel;
        Label_LastModifierId2Valor: TLabel;
        Label_RecordStatus2: TLabel;
        Label_RecordStatus2Valor: TLabel;
        Label_Regiao: TLabel;
        DBText_RegiaoValor: TDBText;
        procedure FormShow(Sender: TObject);
        procedure FormCreate(Sender: TObject);
    private
        { Private declarations }
        FPropostaID: Cardinal;
        FLarguraTotal: Word;
    public
        { Public declarations }
        property PropostaID: Cardinal write FPropostaID;
        property LarguraTotal: Word read FLarguraTotal;
    end;

implementation

uses
    UBDODataModule_InformacoesDaProposta;

{$R *.dfm}

procedure TBDOForm_InformacoesDaProposta.FormCreate(Sender: TObject);
begin
    inherited;
    FLarguraTotal := GroupBox_Obra.Width - 16;
end;

procedure TBDOForm_InformacoesDaProposta.FormShow(Sender: TObject);
begin
    inherited;
    { Neste instante toda informação necessária é obtida e atualizada na tela
    pelo manipulador "Setter" da propriedade PropostaID }
    TBDODataModule_InformacoesDaProposta(CreateParameters.MyDataModule).PropostaID := FPropostaID;
end;

end.
