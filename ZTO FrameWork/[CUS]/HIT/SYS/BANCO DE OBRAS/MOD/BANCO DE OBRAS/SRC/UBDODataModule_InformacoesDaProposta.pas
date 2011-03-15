unit UBDODataModule_InformacoesDaProposta;

interface

uses
    Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
    Dialogs, UBDODataModule, ImgList, ActnList, UBDOForm_InformacoesDaProposta,
  DB, ZAbstractRODataset, ZAbstractDataset, ZDataset, Menus, ActnPopup;

type
    TBDODataModule_InformacoesDaProposta = class(TBDODataModule)
        DataSource_PRO: TDataSource;
        DataSource_ITE: TDataSource;
        DataSource_EDI: TDataSource;
        PROPOSTAS: TZReadOnlyQuery;
        ITENS: TZReadOnlyQuery;
        ITENSIN_ITENS_ID: TIntegerField;
        ITENSVA_DESCRICAO: TStringField;
        ITENSSM_QUANTIDADE: TIntegerField;
        ITENSEN_VOLTAGEM: TStringField;
        ITENSCAPACIDADE: TStringField;
        EQUIPAMENTOSDOSITENS: TZReadOnlyQuery;
        EQUIPAMENTOSDOSITENSIN_EQUIPAMENTOSDOSITENS_ID: TIntegerField;
        EQUIPAMENTOSDOSITENSMODELO: TStringField;
        PROPOSTASVA_NOMEDAOBRA: TStringField;
        PROPOSTASVA_NOME: TStringField;
        PROPOSTASMOEDAORIGINAL: TStringField;
        PROPOSTASVA_CONTATO: TStringField;
        PROPOSTASIN_PROPOSTAS_ID: TIntegerField;
        PROPOSTASDATADAENTRADA: TStringField;
        PROPOSTASVALIDADE: TStringField;
        PROPOSTASVA_REGIAO: TStringField;
        PROPOSTASLOCALIDADE: TStringField;
        PROPOSTASSITUACAO: TStringField;
        PROPOSTASIN_OBRAS_ID: TIntegerField;
        PROPOSTASDATAPROVAVELDEENTREGA: TStringField;
        PROPOSTASVA_CONSTRUTORA: TStringField;
        PROPOSTASPROJETISTA: TStringField;
    private
        { Private declarations }
        FCodigoDaProposta: ShortString;
        FIN_PROPOSTAS_ID: Cardinal;
        procedure SetPropostaID(const Value: Cardinal);
        function MyModule: TBDOForm_InformacoesDaProposta;
    public
        { Public declarations }
        property PropostaID: Cardinal write SetPropostaID;
    end;

implementation

uses
    UXXXTypesConstantsAndClasses;

{$R *.dfm}

{ TBDODataModule_InformacoesDaProposta }

function TBDODataModule_InformacoesDaProposta.MyModule: TBDOForm_InformacoesDaProposta;
begin
    Result := TBDOForm_InformacoesDaProposta(Owner);
end;

procedure TBDODataModule_InformacoesDaProposta.SetPropostaID(const Value: Cardinal);
var
    RI: TRecordInformation;
    LarguraTotal: Word;
begin
    inherited;
    FIN_PROPOSTAS_ID := Value;

    PROPOSTAS.ParamByName('IN_PROPOSTAS_ID').AsInteger := FIN_PROPOSTAS_ID;

    PROPOSTAS.Refresh;

    MyModule.Label_DataDeEntrada.Width := MyModule.LarguraTotal - MyModule.DBText_DataDeEntradaValor.Width;
    MyModule.Label_Validade.Width := MyModule.LarguraTotal - MyModule.DBText_ValidadeValor.Width;
    MyModule.Label_MoedaOriginal.Width := MyModule.LarguraTotal - MyModule.DBText_MoedaOriginalValor.Width;
    MyModule.Label_Regiao.Width := MyModule.LarguraTotal - MyModule.DBText_RegiaoValor.Width;
    MyModule.Label_Obra.Width := MyModule.LarguraTotal - MyModule.DBText_ObraValor.Width;
    MyModule.Label_Localidade.Width := MyModule.LarguraTotal - MyModule.DBText_LocalidadeValor.Width;
    MyModule.Label_Situacao.Width := MyModule.LarguraTotal - MyModule.DBText_SituacaoValor.Width;
    MyModule.Label_PrevisaoDeConclusao.Width := MyModule.LarguraTotal - MyModule.DBText_PrevisaoDeConclusaoValor.Width;
    MyModule.Label_Construtora.Width := MyModule.LarguraTotal - MyModule.DBText_ConstrutoraValor.Width;
    MyModule.Label_Projetista.Width := MyModule.LarguraTotal - MyModule.DBText_ProjetistaValor.Width;

    MyModule.Label_Instalador.Width := MyModule.LarguraTotal - MyModule.DBText_InstaladorValor.Width;
    MyModule.Label_MoedaOriginal.Width := MyModule.LarguraTotal - MyModule.DBText_MoedaOriginalValor.Width;
    MyModule.Label_Contato.Width := MyModule.LarguraTotal - MyModule.DBText_ContatoValor.Width;

    FCodigoDaProposta := CodigoDaProposta(FIN_PROPOSTAS_ID);
    MyModule.Caption := 'Exibindo informações da proposta ' + FCodigoDaProposta;

    LarguraTotal := MyModule.GroupBox_InformacoesDoRegistro.Width - 16;

    RI := GetRecordInformation(DataModuleMain.ZConnections.ByName['ZConnection_BDO'].Connection
                              ,'PROPOSTAS'
                              ,'IN_PROPOSTAS_ID'
                              ,FIN_PROPOSTAS_ID);

    MyModule.Label_CreationDateAndTimeValor.Caption := FormatDateTime(MyModule.Label_CreationDateAndTimeValor.Caption,RI.CreationDateAndTime);
 	MyModule.Label_CreationDateAndTime.Width := LarguraTotal - MyModule.Label_CreationDateAndTimeValor.Width;
    MyModule.Label_CreatorFullNameValor.Caption := RI.CreatorFullName;
 	MyModule.Label_CreatorFullName.Width := LarguraTotal - MyModule.Label_CreatorFullNameValor.Width;
    MyModule.Label_CreatorIdValor.Caption := IntToStr(RI.CreatorId);
 	MyModule.Label_CreatorId.Width := LarguraTotal - MyModule.Label_CreatorIdValor.Width;
    MyModule.Label_LastModificationDateAndTimeValor.Caption := FormatDateTime(MyModule.Label_LastModificationDateAndTimeValor.Caption,RI.LastModificationDateAndTime);
 	MyModule.Label_LastModificationDateAndTime.Width := LarguraTotal - MyModule.Label_LastModificationDateAndTimeValor.Width;
    MyModule.Label_LastModifierFullNameValor.Caption :=  RI.LastModifierFullName;
 	MyModule.Label_LastModifierFullName.Width := LarguraTotal - MyModule.Label_LastModifierFullNameValor.Width;
    MyModule.Label_LastModifierIdValor.Caption := IntToStr(RI.LastModifierId);
 	MyModule.Label_LastModifierId.Width := LarguraTotal - MyModule.Label_LastModifierIdValor.Width;
    MyModule.Label_RecordStatusValor.Caption := ri.RecordStatus;
 	MyModule.Label_RecordStatus.Width := LarguraTotal - MyModule.Label_RecordStatusValor.Width;

    RI := GetRecordInformation(DataModuleMain.ZConnections.ByName['ZConnection_BDO'].Connection
                              ,'OBRAS'
                              ,'IN_OBRAS_ID'
                              ,PROPOSTASIN_OBRAS_ID.AsInteger);

    MyModule.Label_CreationDateAndTime2Valor.Caption := FormatDateTime(MyModule.Label_CreationDateAndTime2Valor.Caption,RI.CreationDateAndTime);
 	MyModule.Label_CreationDateAndTime2.Width := LarguraTotal - MyModule.Label_CreationDateAndTime2Valor.Width;
    MyModule.Label_CreatorFullName2Valor.Caption := RI.CreatorFullName;
 	MyModule.Label_CreatorFullName2.Width := LarguraTotal - MyModule.Label_CreatorFullName2Valor.Width;
    MyModule.Label_CreatorId2Valor.Caption := IntToStr(RI.CreatorId);
 	MyModule.Label_CreatorId2.Width := LarguraTotal - MyModule.Label_CreatorId2Valor.Width;
    MyModule.Label_LastModificationDateAndTime2Valor.Caption := FormatDateTime(MyModule.Label_LastModificationDateAndTime2Valor.Caption,RI.LastModificationDateAndTime);
 	MyModule.Label_LastModificationDateAndTime2.Width := LarguraTotal - MyModule.Label_LastModificationDateAndTime2Valor.Width;
    MyModule.Label_LastModifierFullName2Valor.Caption :=  RI.LastModifierFullName;
 	MyModule.Label_LastModifierFullName2.Width := LarguraTotal - MyModule.Label_LastModifierFullName2Valor.Width;
    MyModule.Label_LastModifierId2Valor.Caption := IntToStr(RI.LastModifierId);
 	MyModule.Label_LastModifierId2.Width := LarguraTotal - MyModule.Label_LastModifierId2Valor.Width;
    MyModule.Label_RecordStatus2Valor.Caption := ri.RecordStatus;
 	MyModule.Label_RecordStatus2.Width := LarguraTotal - MyModule.Label_RecordStatus2Valor.Width;
end;

end.
