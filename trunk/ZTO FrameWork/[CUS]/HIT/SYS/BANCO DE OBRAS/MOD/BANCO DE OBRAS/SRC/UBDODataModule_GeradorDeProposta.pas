unit UBDODataModule_GeradorDeProposta;

interface

uses
    Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
    Dialogs, UBDODataModule_GeradorDeRelatorio, UBDOForm_GeradorDeProposta, ImgList, ActnList, 
    URtf2Html;

type
    TBDODataModule_GeradorDeProposta = class(TBDODataModule_GeradorDeRelatorio)
        procedure DataModuleCreate(Sender: TObject);
        procedure DataModuleDestroy(Sender: TObject);
    private
        { Private declarations }
        FVA_COTACOES: ShortString;
        FTI_MOEDA: Byte;
        FIN_PROPOSTAS_ID: Cardinal;
        FCodigoDaProposta: ShortString;
        FRodape1, FRodape2: ShortString;
        FRtf2Html: TRtf2Html;
        function GerarProposta: String;
        function MyModule: TBDOForm_GeradorDeProposta;
        procedure SetPropostaID(const Value: Cardinal);
        function ObterValorDaProposta(const aCotacoes
                                          , aIDProposta: ShortString): ShortString;
    public
        { Public declarations }
        procedure GerarRelatorio; override;
        procedure DefinirCotacoes;

//        property Cotacoes: ShortString write FVA_COTACOES;
        property PropostaID: Cardinal write SetPropostaID;
//        property Moeda: Byte write FTI_MOEDA;
    end;

implementation

uses
    ZDataset, UXXXDataModule, DB;

const
	SQL_OBRA =
    'SELECT OBR.VA_NOMEDAOBRA'#13#10 +
    '     , OBR.VA_CONSTRUTORA'#13#10 +
    '     , OBR.VA_PRAZODEENTREGA'#13#10 +
    '     , OBR.TX_CONDICAODEPAGAMENTO'#13#10 +
    '     , OBR.EN_FRETE'#13#10 +
    '     , OBR.FL_ICMS'#13#10 +
    '     , OBR.TX_CONDICOESGERAIS'#13#10 +
    '     , CONCAT(OBR.VA_CIDADE,'' / '',OBR.CH_ESTADO) AS LOCALIDADE'#13#10 +
    '     , REG.VA_REGIAO AS REGIAO'#13#10 +
//    '     , REG.CH_PREFIXODAPROPOSTA AS PREFIXODAPROPOSTA'#13#10 +
    '     , SIT.VA_DESCRICAO AS SITUACAO'#13#10 +
    '     , TIP.VA_DESCRICAO AS TIPO'#13#10 +
    '  FROM OBRAS OBR'#13#10 +
    '  JOIN REGIOES REG USING(TI_REGIOES_ID)'#13#10 +
    '  JOIN SITUACOES SIT USING(TI_SITUACOES_ID)'#13#10 +
    '  JOIN TIPOS TIP USING (TI_TIPOS_ID)'#13#10 +
    ' WHERE OBR.IN_OBRAS_ID = (SELECT IN_OBRAS_ID FROM PROPOSTAS WHERE IN_PROPOSTAS_ID = %u)';

  	SQL_PROPOSTA =
    'SELECT PRO.IN_PROPOSTAS_ID'#13#10 +
    '     , PRO.VA_CONTATO'#13#10 +
    '     , PRO.DT_DATAEHORADACRIACAO'#13#10 +
    '     , PRO.TI_VALIDADE'#13#10 +
    '     , INS.VA_NOME AS INSTALADOR'#13#10 +
    '     , FNC_GET_PROPOSAL_CODE(PRO.IN_PROPOSTAS_ID) AS CODIGO'#13#10 +
    '     , FNC_GET_FORMATTED_PROPOSAL_REAJUST(PRO.IN_PROPOSTAS_ID,ELT(PRO.TI_MOEDA,''US$'',''€'',''R$'',''£'',''¥'')) AS REAJUSTE'#13#10 +
    '     , CONCAT(PRO.TI_VALIDADE,'' dias'') AS VALIDADE'#13#10 +
    { substituivel }
//    '     , FNC_GET_FORMATTED_CURRENCY_VALUE(FNC_GET_PROPOSAL_VALUE(PRO.IN_PROPOSTAS_ID,FALSE,FALSE,''%s'',2),ELT(PRO.TI_MOEDA,''US$'',''€'',''R$'',''£'',''¥''),FALSE) AS TOTAL'#13#10 +
    { substituivel }
    'FROM PROPOSTAS PRO'#13#10 +
    'JOIN INSTALADORES INS USING (SM_INSTALADORES_ID)'#13#10 +
    'WHERE PRO.IN_PROPOSTAS_ID = %u';

//BDO3 (V1)
//  	SQL_PROPOSTA =
//    'SELECT PRO.IN_PROPOSTAS_ID'#13#10 +
//    '     , PRO.VA_CONTATO'#13#10 +
//    '     , PRO.DT_DATAEHORADACRIACAO'#13#10 +
//    '     , PRO.TI_VALIDADE'#13#10 +
//    '     , INS.VA_NOME AS INSTALADOR'#13#10 +
//    '     , FNC_GET_PROPOSAL_CODE(PRO.IN_PROPOSTAS_ID) AS CODIGO'#13#10 +
//    '     , FNC_GET_FORMATTED_PROPOSAL_REAJUST(PRO.IN_PROPOSTAS_ID,ELT(PRO.TI_MOEDA,''US$'',''€'',''R$'',''£'',''¥'')) AS REAJUSTE'#13#10 +
//    '     , CONCAT(PRO.TI_VALIDADE,'' dias'') AS VALIDADE'#13#10 +
//    { substituivel }
//    '     , FNC_GET_FORMATTED_CURRENCY_VALUE(FNC_GET_PROPOSAL_VALUE(PRO.IN_PROPOSTAS_ID,FALSE,FALSE,''%s'',2),ELT(PRO.TI_MOEDA,''US$'',''€'',''R$'',''£'',''¥''),FALSE) AS TOTAL'#13#10 +
//    { substituivel }
//    'FROM PROPOSTAS PRO'#13#10 +
//    'JOIN INSTALADORES INS USING (SM_INSTALADORES_ID)'#13#10 +
//    'WHERE PRO.IN_PROPOSTAS_ID = %u';

//SELECT FNC_GET_ITEM_VALUE(36227,TRUE,FALSE,'1;1;1;1;1',TRUE,FNC_GET_PROPOSAL_REAJUST_MULTIPLIER(5196),2) * FNC_GET_REAJUST_MULTIPLIER(-5)
//UNION
//SELECT FNC_GET_ITEM_VALUE(36228,TRUE,FALSE,'1;1;1;1;1',TRUE,FNC_GET_PROPOSAL_REAJUST_MULTIPLIER(5196),2) * FNC_GET_REAJUST_MULTIPLIER(7.37);

	SQL_ITENS =
    '  SELECT ITE.IN_ITENS_ID'#13#10 +
    '       , ITE.VA_DESCRICAO'#13#10 +
    '       , ITE.SM_QUANTIDADE'#13#10 +
    '       , ITE.FL_DESCONTOPERC'#13#10 +
    '       , FAM.VA_DESCRICAO AS FAMILIA'#13#10 +
    '       , FNC_GET_FORMATTED_CAPACITY(ITE.FL_CAPACIDADE,UNI.VA_ABREVIATURA) AS CAPACIDADE'#13#10 +
    '       , FNC_GET_FORMATTED_PERCENTUAL(ITE.FL_DESCONTOPERC,TRUE) AS REAJUSTE'#13#10 +
    { substituivel }
    '       , @ValorUnitario := ROUND(FNC_GET_ITEM_VALUE(ITE.IN_ITENS_ID,TRUE,FALSE,''%s'',2) * :REAJUSTEDAPROPOSTA:,2)'#13#10 +
    '       , @ValorAjustado := ROUND(@ValorUnitario * FNC_GET_REAJUST_MULTIPLIER(ITE.FL_DESCONTOPERC),2)'#13#10 +
    '       , @ValorTotalPar := @ValorAjustado * ITE.SM_QUANTIDADE'#13#10 +
    '       , FNC_GET_FORMATTED_CURRENCY_VALUE(@ValorUnitario, ELT(FNC_GET_CURRENCY_CODE_FROM_WORK(FNC_GET_WORK_FROM_PROPOSAL(FNC_GET_PROPOSAL_FROM_ITEM(ITE.IN_ITENS_ID))),''US$'',''€'',''R$'',''£'',''¥''),FALSE) AS UNIDADE'#13#10 +
    '       , FNC_GET_FORMATTED_CURRENCY_VALUE(@ValorAjustado, ELT(FNC_GET_CURRENCY_CODE_FROM_WORK(FNC_GET_WORK_FROM_PROPOSAL(FNC_GET_PROPOSAL_FROM_ITEM(ITE.IN_ITENS_ID))),''US$'',''€'',''R$'',''£'',''¥''),FALSE) AS SUBTOTAL'#13#10 +
    '       , FNC_GET_FORMATTED_CURRENCY_VALUE(@ValorTotalPar,ELT(FNC_GET_CURRENCY_CODE_FROM_WORK(FNC_GET_WORK_FROM_PROPOSAL(FNC_GET_PROPOSAL_FROM_ITEM(ITE.IN_ITENS_ID))),''US$'',''€'',''R$'',''£'',''¥''),FALSE) AS TOTAL'#13#10 +
    '       , FNC_GET_FORMATTED_PERCENTUAL(FNC_GET_BRUTE_PROFIT(ITE.IN_ITENS_ID),FALSE) AS LUCROBRUTOFMT'#13#10 +
    { substituivel }
    '    FROM ITENS ITE'#13#10 +
    '    JOIN UNIDADES UNI USING (TI_UNIDADES_ID)'#13#10 +
    '    JOIN FAMILIAS FAM USING (TI_FAMILIAS_ID)'#13#10 +
    '   WHERE ITE.IN_PROPOSTAS_ID = %u'#13#10 +
    'ORDER BY ITE.TI_ORDEM';

    SQL_ITENS_CALC =
    'SELECT FNC_GET_FORMATTED_CURRENCY_VALUE(SUM(T.VALORTOTALPAR) * :REAJUSTEDAPROPOSTA1:,ELT(T.TI_MOEDA,''US$'',''€'',''R$'',''£'',''¥''),FALSE)'#13#10 +
    '  FROM (SELECT ITE.IN_PROPOSTAS_ID'#13#10 +
    '             , PRO.TI_MOEDA'#13#10 +
    '             , @ValorUnitario := ROUND(FNC_GET_ITEM_VALUE(ITE.IN_ITENS_ID,TRUE,FALSE,'':COTACOES:'',2) * :REAJUSTEDAPROPOSTA2:,2)'#13#10 +
    '             , @ValorAjustado := ROUND(@ValorUnitario * FNC_GET_REAJUST_MULTIPLIER(ITE.FL_DESCONTOPERC),2)'#13#10 +
    '             , @ValorTotalPar := @ValorAjustado * ITE.SM_QUANTIDADE AS VALORTOTALPAR'#13#10 +
    '          FROM ITENS ITE'#13#10 +
    '          JOIN PROPOSTAS PRO USING (IN_PROPOSTAS_ID)'#13#10 +
    '         WHERE ITE.IN_PROPOSTAS_ID = :IN_PROPOSTAS_ID:) T';

//BDO3 (v3)
//	SQL_ITENS =
//    '  SELECT ITE.IN_ITENS_ID'#13#10 +
//    '       , ITE.VA_DESCRICAO'#13#10 +
//    '       , ITE.SM_QUANTIDADE'#13#10 +
//    '       , ITE.FL_DESCONTOPERC'#13#10 +
//    '       , FAM.VA_DESCRICAO AS FAMILIA'#13#10 +
//    '       , FNC_GET_FORMATTED_CAPACITY(ITE.FL_CAPACIDADE,UNI.VA_ABREVIATURA) AS CAPACIDADE'#13#10 +
//    '       , FNC_GET_FORMATTED_PERCENTUAL(ITE.FL_DESCONTOPERC,TRUE) AS REAJUSTE'#13#10 +
//    { substituivel }
//    '       , @ValorUnitario := ROUND(FNC_GET_ITEM_VALUE(ITE.IN_ITENS_ID,TRUE,FALSE,''%s'',2) * :REAJUSTEDAPROPOSTA:,2)'#13#10 +
//    '       , @ValorAjustado := ROUND(@ValorUnitario * FNC_GET_REAJUST_MULTIPLIER(ITE.FL_DESCONTOPERC),2)'#13#10 +
//    '       , @ValorTotalPar := @ValorAjustado * ITE.SM_QUANTIDADE'#13#10 +
//    '       , FNC_GET_FORMATTED_CURRENCY_VALUE(@ValorUnitario, ELT(FNC_GET_CURRENCY_CODE(ITE.IN_ITENS_ID),''US$'',''€'',''R$'',''£'',''¥''),FALSE) AS UNIDADE'#13#10 +
//    '       , FNC_GET_FORMATTED_CURRENCY_VALUE(@ValorAjustado, ELT(FNC_GET_CURRENCY_CODE(ITE.IN_ITENS_ID),''US$'',''€'',''R$'',''£'',''¥''),FALSE) AS SUBTOTAL'#13#10 +
//    '       , FNC_GET_FORMATTED_CURRENCY_VALUE(@ValorTotalPar,ELT(FNC_GET_CURRENCY_CODE(ITE.IN_ITENS_ID),''US$'',''€'',''R$'',''£'',''¥''),FALSE) AS TOTAL'#13#10 +
//    '       , FNC_GET_FORMATTED_PERCENTUAL(FNC_GET_BRUTE_PROFIT(ITE.IN_ITENS_ID),FALSE) AS LUCROBRUTOFMT'#13#10 +
//    { substituivel }
//    '    FROM ITENS ITE'#13#10 +
//    '    JOIN UNIDADES UNI USING (TI_UNIDADES_ID)'#13#10 +
//    '    JOIN FAMILIAS FAM USING (TI_FAMILIAS_ID)'#13#10 +
//    '   WHERE ITE.IN_PROPOSTAS_ID = %u'#13#10 +
//    'ORDER BY ITE.TI_ORDEM';

//BDO3 (v2)
//	SQL_ITENS =
//    '  SELECT ITE.IN_ITENS_ID'#13#10 +
//    '       , ITE.VA_DESCRICAO'#13#10 +
//    '       , ITE.SM_QUANTIDADE'#13#10 +
//    '       , ITE.FL_DESCONTOPERC'#13#10 +
//    '       , FAM.VA_DESCRICAO AS FAMILIA'#13#10 +
//    '       , FNC_GET_FORMATTED_CAPACITY(ITE.FL_CAPACIDADE,UNI.VA_ABREVIATURA) AS CAPACIDADE'#13#10 +
//    '       , FNC_GET_FORMATTED_PERCENTUAL(ITE.FL_DESCONTOPERC,TRUE) AS REAJUSTE'#13#10 +
//    { substituivel }
//    '       , FNC_GET_FORMATTED_CURRENCY_VALUE(FNC_GET_ITEM_VALUE(ITE.IN_ITENS_ID,TRUE,FALSE,''%s'',:USARDESCONTODAPROPOSTA:,:DESCONTODAPROPOSTA:,2), ELT(FNC_GET_CURRENCY_CODE(ITE.IN_ITENS_ID),''US$'',''€'',''R$'',''£'',''¥''),FALSE) AS UNIDADE'#13#10 +
//    '       , FNC_GET_FORMATTED_CURRENCY_VALUE(FNC_GET_ITEM_VALUE(ITE.IN_ITENS_ID,TRUE,FALSE,''%0:s'',:USARDESCONTODAPROPOSTA:,:DESCONTODAPROPOSTA:,2) ' + '* FNC_GET_REAJUST_MULTIPLIER(ITE.FL_DESCONTOPERC), ELT(FNC_GET_CURRENCY_CODE(ITE.IN_ITENS_ID),''US$'',''€'',''R$'',''£'',''¥''),FALSE) AS SUBTOTAL'#13#10 +
//    '       , FNC_GET_FORMATTED_CURRENCY_VALUE(FNC_GET_ITEM_VALUE(ITE.IN_ITENS_ID,FALSE,FALSE,''%0:s'',:USARDESCONTODAPROPOSTA:,:DESCONTODAPROPOSTA:,2),ELT(FNC_GET_CURRENCY_CODE(ITE.IN_ITENS_ID),''US$'',''€'',''R$'',''£'',''¥''),FALSE) AS TOTAL'#13#10 +
//    '       , FNC_GET_FORMATTED_PERCENTUAL(FNC_GET_BRUTE_PROFIT(ITE.IN_ITENS_ID),FALSE) AS LUCROBRUTOFMT'#13#10 +
//    { substituivel }
//    '    FROM ITENS ITE'#13#10 +
//    '    JOIN PROPOSTAS PRO USING (IN_PROPOSTAS_ID)'#13#10 +
//    '    JOIN UNIDADES UNI USING (TI_UNIDADES_ID)'#13#10 +
//    '    JOIN FAMILIAS FAM USING (TI_FAMILIAS_ID)'#13#10 +
//    '   WHERE ITE.IN_PROPOSTAS_ID = %u'#13#10 +
//    'ORDER BY ITE.TI_ORDEM';

//BDO3 (v1)
//	SQL_ITENS =
//    '  SELECT ITE.IN_ITENS_ID'#13#10 +
//    '       , ITE.VA_DESCRICAO'#13#10 +
//    '       , ITE.SM_QUANTIDADE'#13#10 +
//    '       , ITE.FL_DESCONTOPERC'#13#10 +
//    '       , FAM.VA_DESCRICAO AS FAMILIA'#13#10 +
//    '       , FNC_GET_FORMATTED_CAPACITY(ITE.FL_CAPACIDADE,UNI.VA_ABREVIATURA) AS CAPACIDADE'#13#10 +
//    '       , FNC_GET_FORMATTED_PERCENTUAL(ITE.FL_DESCONTOPERC,TRUE) AS REAJUSTE'#13#10 +
//    { substituivel }
//    '       , FNC_GET_FORMATTED_CURRENCY_VALUE(FNC_GET_ITEM_VALUE(ITE.IN_ITENS_ID,TRUE,FALSE,''%s'',:USARDESCONTODAPROPOSTA:,:DESCONTODAPROPOSTA:), ELT(FNC_GET_CURRENCY_CODE(ITE.IN_ITENS_ID),''US$'',''€'',''R$'',''£'',''¥''),FALSE) AS SUBTOTAL'#13#10 +
//    '       , FNC_GET_FORMATTED_CURRENCY_VALUE(FNC_GET_ITEM_VALUE(ITE.IN_ITENS_ID,FALSE,FALSE,''%0:s'',:USARDESCONTODAPROPOSTA:,:DESCONTODAPROPOSTA:),ELT(FNC_GET_CURRENCY_CODE(ITE.IN_ITENS_ID),''US$'',''€'',''R$'',''£'',''¥''),FALSE) AS TOTAL'#13#10 +
//    '       , FNC_GET_FORMATTED_PERCENTUAL(FNC_GET_BRUTE_PROFIT(ITE.IN_ITENS_ID),FALSE) AS LUCROBRUTOFMT'#13#10 +
//    { substituivel }
//    '    FROM ITENS ITE'#13#10 +
//    '    JOIN PROPOSTAS PRO USING (IN_PROPOSTAS_ID)'#13#10 +
//    '    JOIN UNIDADES UNI USING (TI_UNIDADES_ID)'#13#10 +
//    '    JOIN FAMILIAS FAM USING (TI_FAMILIAS_ID)'#13#10 +
//    '   WHERE ITE.IN_PROPOSTAS_ID = %u'#13#10 +
//    'ORDER BY ITE.TI_ORDEM';

//BDO2
//	SQL_ITENS =
//    '  SELECT ITE.IN_ITENS_ID'#13#10 +
//    '       , ITE.VA_DESCRICAO'#13#10 +
//    '       , ITE.SM_QUANTIDADE'#13#10 +
//    '       , ITE.FL_DESCONTOPERC'#13#10 +
//    '       , FAM.VA_DESCRICAO AS FAMILIA'#13#10 +
//    '       , FNC_GET_FORMATTED_CAPACITY(ITE.FL_CAPACIDADE,UNI.VA_ABREVIATURA) AS CAPACIDADE'#13#10 +
//    '       , FNC_GET_FORMATTED_PERCENTUAL(ITE.FL_DESCONTOPERC,TRUE) AS REAJUSTE'#13#10 +
//    { substituivel }
//    '       , FNC_GET_FORMATTED_CURRENCY_VALUE(FNC_GET_ITEM_VALUE(ITE.IN_ITENS_ID,TRUE,FALSE,''%s'') + '+'ITE.FL_DESCONTOPERC / 100 * FNC_GET_ITEM_VALUE(ITE.IN_ITENS_ID,TRUE,FALSE,''%0:s''),ELT(FNC_GET_CURRENCY_CODE(ITE.IN_ITENS_ID),''US$'',''€'',''R$'',''£'',''¥''),FALSE) AS SUBTOTALREAJUSTADO'#13#10 +
//    '       , FNC_GET_FORMATTED_CURRENCY_VALUE(FNC_GET_ITEM_VALUE(ITE.IN_ITENS_ID,TRUE,FALSE,''%0:s''), ELT(FNC_GET_CURRENCY_CODE(ITE.IN_ITENS_ID),''US$'',''€'',''R$'',''£'',''¥''),FALSE) AS SUBTOTAL'#13#10 +
//    '       , FNC_GET_FORMATTED_CURRENCY_VALUE(FNC_GET_ITEM_VALUE(ITE.IN_ITENS_ID,FALSE,FALSE,''%0:s''),ELT(FNC_GET_CURRENCY_CODE(ITE.IN_ITENS_ID),''US$'',''€'',''R$'',''£'',''¥''),FALSE) AS TOTAL'#13#10 +
//    '       , FNC_GET_FORMATTED_PERCENTUAL(FNC_GET_BRUTE_PROFIT(ITE.IN_ITENS_ID),FALSE) AS LUCROBRUTOFMT'#13#10 +
//    { substituivel }
//    '    FROM ITENS ITE'#13#10 +
//    '    JOIN PROPOSTAS PRO USING (IN_PROPOSTAS_ID)'#13#10 +
//    '    JOIN UNIDADES UNI USING (TI_UNIDADES_ID)'#13#10 +
//    '    JOIN FAMILIAS FAM USING (TI_FAMILIAS_ID)'#13#10 +
//    '   WHERE ITE.IN_PROPOSTAS_ID = %u'#13#10 +
//    'ORDER BY ITE.TI_ORDEM';

	SQL_EQUIPAMENTOSDOITEM = 'SELECT FNC_GET_MODELS_FROM_ITEM(%u) AS MODELOS';

//	SQL_CALCITEM =
//	'SELECT FNC_GET_ITEM_VALUE(%s,TRUE,FALSE,''%s'') AS SOMATORIOCOMIMPOSTOS'#13#10 +
//	'      ,FNC_GET_BRUTE_PROFIT(%0:s) AS LUCROBRUTO';

//	SQL_CALCPROPOSTA = 'SELECT FNC_GET_PROPOSAL_VALUE(%u,FALSE,FALSE,''%s'')';

    SQL_COTACAO_MOEDA =
    'SELECT VA_COTACOES'#13#10 +
    '     , TI_MOEDA'#13#10 +
    '  FROM PROPOSTAS'#13#10 +
    ' WHERE IN_PROPOSTAS_ID = %u';

    SQL_RODAPES =
    'SELECT REG.VA_PRIMEIRORODAPE'#13#10 +
    '     , REG.VA_SEGUNDORODAPE'#13#10 +
    '  FROM REGIOES REG'#13#10 +
    '  JOIN OBRAS OBR USING(TI_REGIOES_ID)'#13#10 +
    '  JOIN PROPOSTAS PRO USING (IN_OBRAS_ID)'#13#10 +
    ' WHERE PRO.IN_PROPOSTAS_ID = %u';

{$R *.dfm}

{ TBDODataModule_GeradorDeProposta }

procedure TBDODataModule_GeradorDeProposta.DataModuleCreate(Sender: TObject);
begin
    inherited;
    FRtf2Html := TRtf2Html.Create;
    FRtf2Html.ImagesDir := Configurations.CurrentDir + '\ReportTemplates\RECURSOS\USERIMAGES'
end;

procedure TBDODataModule_GeradorDeProposta.DataModuleDestroy(Sender: TObject);
begin
    inherited;
    FRtf2Html.Free;
end;

procedure TBDODataModule_GeradorDeProposta.DefinirCotacoes;
var
    Cotacoes: ShortString;
begin
    inherited;
    Cotacoes := ShowCurrencyConvertManager(FVA_COTACOES,FTI_MOEDA);

    if Trim(Cotacoes) <> '' then
    begin
        FVA_COTACOES := Cotacoes;
        GerarRelatorio;
    end;
end;

function TBDODataModule_GeradorDeProposta.GerarProposta: String;
var
    ItemTemplate, ValoresUnitariosHeaderHTML, ValoresUnitariosTemplate,
    TotaisParciaisTemplate, TotaisParciaisHeaderHTML, ReajusteDosItensTemplate,
    ReajusteDosItensHeaderHTML, ItensHTML, ReajusteDosItensHTML, ValoresUnitariosHTML,
    TotaisParciaisHTML, ItemSQL: String;
    Colspan, ItemNo: Byte;
    Itens, EquipamentosDosItens, Obra, Proposta: TZReadOnlyQuery;
begin
    (* Carregando o arquivo de modelo geral que será posto em result *)
    Result := LoadTextFile(Configurations.CurrentDir + '\reporttemplates\PROPOSTA\obra+proposta+itens[1].'{$IFDEF IE}+'ie'+{$ELSE}+'firefox'+{$ENDIF}'.template');
                   
    (* Substituindo os rodapés e o nome do usuário *)
    Result := StringReplace(Result,'<%>PRIMEIRORODAPE<%>',FRodape1,[]);
    Result := StringReplace(Result,'<%>SEGUNDORODAPE<%>',FRodape2,[]);
    Result := StringReplace(Result,'<%>USUARIO<%>',Configurations.AuthenticatedUser.RealName,[]);

    (* Carregando o arquivo com o modelo de uma linha de tabela (replicavel) *)
    ItemTemplate := LoadTextFile(Configurations.CurrentDir + '\reporttemplates\PROPOSTA\obra+proposta+itens[2].template');

    (* Dependendo  do número de  colunas opcionais,  a ultima  linha da tabela
    de itens tem de ter um colspan diferente *)
    Colspan := 7;

    (* Carregando o arquivo com o modelo para as colunas opcionais (ValoresUnitarios) *)
    if MyModule.CheckBox_ExibirValoresUnitarios.Checked then
    begin
        ValoresUnitariosTemplate := LoadTextFile(Configurations.CurrentDir + '\reporttemplates\PROPOSTA\obra+proposta+itens[3].template');
        ValoresUnitariosHeaderHTML := LoadTextFile(Configurations.CurrentDir + '\reporttemplates\PROPOSTA\obra+proposta+itens[4].template');
    end
    else
  	    Dec(Colspan);

    (* Carregando o arquivo com o modelo para as colunas opcionais (TotaisParciais) *)
    if MyModule.CheckBox_ExibirValoresTotaisParciais.Checked then
    begin
        TotaisParciaisTemplate := LoadTextFile(Configurations.CurrentDir + '\reporttemplates\PROPOSTA\obra+proposta+itens[8].template');
        TotaisParciaisHeaderHTML := LoadTextFile(Configurations.CurrentDir + '\reporttemplates\PROPOSTA\obra+proposta+itens[7].template');
    end
    else
  	    Dec(Colspan);

    if MyModule.CheckBox_ExibirReajusteDosItens.Checked then
    begin
        ReajusteDosItensTemplate := LoadTextFile(Configurations.CurrentDir + '\reporttemplates\PROPOSTA\obra+proposta+itens[5].template');
        ReajusteDosItensHeaderHTML := LoadTextFile(Configurations.CurrentDir + '\reporttemplates\PROPOSTA\obra+proposta+itens[6].template');
    end
    else
  	    Dec(Colspan);

    (* Ajustando colspan *)
	Result := StringReplace(Result,'<%>COLSPAN<%>',IntToStr(Colspan),[rfReplaceAll]);

	(* A variável abaixo guardará a união de todos os itens da tabela de itens *)
    ItensHTML := '<!-- Itens da proposta -->';

    (* Incrementado com número do item ... *)
    ItemNo := 0;

	(* gerando a tabela de itens, ou, Substituindo campos de itens *)
    Itens := nil;
	EquipamentosDosItens := nil;

    if MyModule.CheckBox_AplicarReajusteDaPropostaNosItens.Checked then
        ItemSQL := StringReplace(SQL_ITENS
                                ,':REAJUSTEDAPROPOSTA:'
                                ,'FNC_GET_PROPOSAL_REAJUST_MULTIPLIER(ITE.IN_PROPOSTAS_ID)'
                                ,[rfReplaceAll])
    else
        ItemSQL := StringReplace(SQL_ITENS
                                ,':REAJUSTEDAPROPOSTA:'
                                ,'1'
                                ,[rfReplaceAll]);

    try
        ConfigureDataSet(DataModuleMain.ZConnections.ByName['ZConnection_BDO'].Connection
                        ,Itens
                        ,Format(ItemSQL
                               ,[FVA_COTACOES
                                ,FIN_PROPOSTAS_ID]));

        if Itens.IsEmpty then
            raise Exception.Create('A proposta selecionada não possui ítens');

        MyModule.ProgressBar_GeracaoDeRelatorio.Position := 0;
        MyModule.ProgressBar_GeracaoDeRelatorio.Step := 1;
        MyModule.ProgressBar_GeracaoDeRelatorio.Max := Itens.RecordCount;
        MyModule.ProgressBar_GeracaoDeRelatorio.Show;

        (* Cada item será concatenado em ItensHTML *)
        Itens.First;
        while not Itens.Eof do
        begin
            Inc(ItemNo);

            ItensHTML := ItensHTML + #13#10 + ItemTemplate; // Adiciona mais um item com campos substituiveis (ItemTemplate)


            (* Gerando linhas de cores alternadas *)
            if ItemNo mod 2 = 0 then
                ItensHTML := StringReplace(ItensHTML,'<%>TR<%>','<TR CLASS="linhacor">',[])
            else
                ItensHTML := StringReplace(ItensHTML,'<%>TR<%>','<TR>',[]);

            ItensHTML := StringReplace(ItensHTML,'<%>ITEMNO<%>',IntToStr(ItemNo),[]);
            ItensHTML := StringReplace(ItensHTML,'<%>VA_DESCRICAO<%>',Itens.FieldByName('VA_DESCRICAO').AsString,[]);
            ItensHTML := StringReplace(ItensHTML,'<%>CAPACIDADE<%>',Itens.FieldByName('CAPACIDADE').AsString,[]);
            ItensHTML := StringReplace(ItensHTML,'<%>SM_QUANTIDADE<%>',Itens.FieldByName('SM_QUANTIDADE').AsString,[]);

            (* Se optar por exibir os reajustes dos itens ... *)
            if MyModule.CheckBox_ExibirReajusteDosItens.Checked then
            begin
                ReajusteDosItensHTML := ReajusteDosItensTemplate;

                ReajusteDosItensHTML := StringReplace(ReajusteDosItensHTML,'<%>REAJUSTE<%>',Itens.FieldByName('REAJUSTE').AsString,[]);

                ItensHTML := StringReplace(ItensHTML,'<%>REAJUSTEDOSITENS<%>',ReajusteDosItensHTML,[]);
            end
            else
                ItensHTML := StringReplace(ItensHTML,'<%>REAJUSTEDOSITENS<%>','',[]);

            (* Se optar por exibir valores Unitarios ... *)
            if MyModule.CheckBox_ExibirValoresUnitarios.Checked then
            begin
                ValoresUnitariosHTML := ValoresUnitariosTemplate;

                if MyModule.CheckBox_AplicarReajusteNosValoresUnitariosDosItens.Checked then
                    ValoresUnitariosHTML := StringReplace(ValoresUnitariosHTML,'<%>SUBTOTAL<%>',Itens.FieldByName('SUBTOTAL').AsString,[])
                else
	                ValoresUnitariosHTML := StringReplace(ValoresUnitariosHTML,'<%>SUBTOTAL<%>',Itens.FieldByName('UNIDADE').AsString,[]);

                ItensHTML := StringReplace(ItensHTML,'<%>VALORESUNITARIOS<%>',ValoresUnitariosHTML,[]);
            end
            else
                ItensHTML := StringReplace(ItensHTML,'<%>VALORESUNITARIOS<%>','',[]);

            (* Se optar por exibir Totais Parciais ... *)
            if MyModule.CheckBox_ExibirValoresTotaisParciais.Checked then
            begin
                TotaisParciaisHTML := TotaisParciaisTemplate;

                TotaisParciaisHTML := StringReplace(TotaisParciaisHTML,'<%>TOTAL<%>',Itens.FieldByName('TOTAL').AsString,[]);

                ItensHTML := StringReplace(ItensHTML,'<%>TOTAISPARCIAIS<%>',TotaisParciaisHTML,[]);
            end
            else
                ItensHTML := StringReplace(ItensHTML,'<%>TOTAISPARCIAIS<%>','',[]);

            (* Obtendo a lista com equipamentos dos itens *)
            ConfigureDataSet(DataModuleMain.ZConnections.ByName['ZConnection_BDO'].Connection
                            ,EquipamentosDosItens
                            ,Format(SQL_EQUIPAMENTOSDOITEM
                                   ,[Itens.FieldByName('IN_ITENS_ID').AsInteger]));

            if EquipamentosDosItens.IsEmpty then
                raise Exception.Create('Um dos ítens da proposta não possui equipamentos');

            ItensHTML := StringReplace(ItensHTML,'<%>EQUIPAMENTOSDOITEM<%>',EquipamentosDosItens.Fields[0].AsString,[]);

            MyModule.ProgressBar_GeracaoDeRelatorio.StepIt;
		    Itens.Next;
        end;
    finally
        if Assigned(EquipamentosDosItens) then
            EquipamentosDosItens.Free;

        if Assigned(Itens) then
	   	    Itens.Free;

        MyModule.DelayedHideProgressBar;
    end;

    (* Incluido a tabela com todos os itens no modelo geral *)
    Result := StringReplace(Result,'<%>ITENSDAPROPOSTA<%>',ItensHTML,[]);

    (* Substituindo campos de obra no modelo geral*)
    Obra := nil;
    try
        ConfigureDataSet(DataModuleMain.ZConnections.ByName['ZConnection_BDO'].Connection
                        ,Obra
                        ,Format(SQL_OBRA
                               ,[FIN_PROPOSTAS_ID]));

        if Obra.RecordCount <> 1 then
            raise Exception.Create('Proposta inválida. A proposta selecionada não possui uma obra associada, ou está associada a mais de uma obra');

        Result := StringReplace(Result,'<%>VA_NOMEDAOBRA<%>',Obra.FieldByName('VA_NOMEDAOBRA').AsString,[rfReplaceAll]);

        if MyModule.CheckBox_ExibirTipoDaObra.Checked then
        begin
            Result := StringReplace(Result,'<%>TIPO<%>',Obra.FieldByName('TIPO').AsString,[rfReplaceAll]);
            Result := StringReplace(Result,'<%>EXIBIRTIPO_I<%>','',[rfReplaceAll]);
            Result := StringReplace(Result,'<%>EXIBIRTIPO_F<%>','',[rfReplaceAll]);
        end
        else
        begin
            Result := StringReplace(Result,'<%>EXIBIRTIPO_I<%>','<!--',[rfReplaceAll]);
            Result := StringReplace(Result,'<%>EXIBIRTIPO_F<%>','-->',[rfReplaceAll]);
        end;

        if MyModule.CheckBox_ExibirSituacaoDaObra.Checked then
        begin
            Result := StringReplace(Result,'<%>SITUACAO<%>',Obra.FieldByName('SITUACAO').AsString,[rfReplaceAll]);
            Result := StringReplace(Result,'<%>EXIBIRSITUACAO_I<%>','',[rfReplaceAll]);
            Result := StringReplace(Result,'<%>EXIBIRSITUACAO_F<%>','',[rfReplaceAll]);
        end
        else
        begin
            Result := StringReplace(Result,'<%>EXIBIRSITUACAO_I<%>','<!--',[rfReplaceAll]);
            Result := StringReplace(Result,'<%>EXIBIRSITUACAO_F<%>','-->',[rfReplaceAll]);
        end;

        Result := StringReplace(Result,'<%>REGIAO<%>',Obra.FieldByName('REGIAO').AsString,[rfReplaceAll]);
        Result := StringReplace(Result,'<%>LOCALIDADE<%>',Obra.FieldByName('LOCALIDADE').AsString,[rfReplaceAll]);

        if MyModule.CheckBox_ExibirConstrutora.Checked then
        begin
            Result := StringReplace(Result,'<%>VA_CONSTRUTORA<%>',Obra.FieldByName('VA_CONSTRUTORA').AsString,[rfReplaceAll]);
            Result := StringReplace(Result,'<%>EXIBIRCONSTRUTORA_I<%>','',[rfReplaceAll]);
            Result := StringReplace(Result,'<%>EXIBIRCONSTRUTORA_F<%>','',[rfReplaceAll]);
        end
        else
        begin
            Result := StringReplace(Result,'<%>EXIBIRCONSTRUTORA_I<%>','<!--',[rfReplaceAll]);
            Result := StringReplace(Result,'<%>EXIBIRCONSTRUTORA_F<%>','-->',[rfReplaceAll]);
        end;

        Result := StringReplace(Result,'<%>VA_PRAZODEENTREGA<%>',Obra.FieldByName('VA_PRAZODEENTREGA').AsString,[]);

//        Result := StringReplace(Result,'<%>TX_CONDICAODEPAGAMENTO<%>',StringReplace(Obra.FieldByName('TX_CONDICAODEPAGAMENTO').AsString,#13#10,'<BR>'#13#10,[rfReplaceAll]),[]);
        FRtf2Html.RichText := Obra.FieldByName('TX_CONDICAODEPAGAMENTO').AsString;
        Result := StringReplace(Result,'<%>TX_CONDICAODEPAGAMENTO<%>',FRtf2Html.HyperText,[]);

        Result := StringReplace(Result,'<%>EN_FRETE<%>',Obra.FieldByName('EN_FRETE').AsString,[rfReplaceAll]);
        Result := StringReplace(Result,'<%>FL_ICMS<%>',Obra.FieldByName('FL_ICMS').AsString,[rfReplaceAll]);

//        Result := StringReplace(Result,'<%>TX_CONDICOESGERAIS<%>',StringReplace(Obra.FieldByName('TX_CONDICOESGERAIS').AsString,#13#10,'<BR>'#10#10,[rfReplaceAll]),[]);
        FRtf2Html.RichText := Obra.FieldByName('TX_CONDICOESGERAIS').AsString;
        Result := StringReplace(Result,'<%>TX_CONDICOESGERAIS<%>',FRtf2Html.HyperText,[]);

        (* Se optar por exibir reajustes dos itens ... *)
        if MyModule.CheckBox_ExibirReajusteDosItens.Checked then
        begin
            Result := StringReplace(Result,'<%>REAJUSTEDOSITENSHEADER<%>',ReajusteDosItensHeaderHTML,[]);
        end
        else
            Result := StringReplace(Result,'<%>REAJUSTEDOSITENSHEADER<%>','',[]);

        (* Se optar por exibir Valores Unitarios ... *)
        if MyModule.CheckBox_ExibirValoresUnitarios.Checked then
            Result := StringReplace(Result,'<%>VALORESUNITARIOSHEADER<%>',ValoresUnitariosHeaderHTML,[])
        else
            Result := StringReplace(Result,'<%>VALORESUNITARIOSHEADER<%>','',[]);

        (* Se optar por exibir Totais Parciis ... *)
        if MyModule.CheckBox_ExibirValoresTotaisParciais.Checked then
            Result := StringReplace(Result,'<%>TOTAISPARCIAISHEADER<%>',TotaisParciaisHeaderHTML,[])
        else
            Result := StringReplace(Result,'<%>TOTAISPARCIAISHEADER<%>','',[]);
    finally
  	    if Assigned(Obra) then
	   	    Obra.Free;
    end;

    (* Substituindo campos de proposta no modelo geral *)
    Proposta := nil;
    try
        ConfigureDataSet(DataModuleMain.ZConnections.ByName['ZConnection_BDO'].Connection
                        ,Proposta
                        ,Format(SQL_PROPOSTA
                               ,[FIN_PROPOSTAS_ID]));

        Result := StringReplace(Result,'<%>VA_CONTATO<%>',Proposta.FieldByName('VA_CONTATO').AsString,[rfReplaceAll]);

        if Proposta.IsEmpty then
            raise Exception.Create('A proposta selecionada não existe');

        Result := StringReplace(Result,'<%>SM_CODIGO<%>',Proposta.FieldByName('CODIGO').AsString,[rfReplaceAll]);

        Result := StringReplace(Result,'<%>VALIDADE<%>',Proposta.FieldByName('VALIDADE').AsString + ' (' + FormatDateTime('dd/mm/yyyy',Proposta.FieldByName('DT_DATAEHORADACRIACAO').AsDateTime + Proposta.FieldByName('TI_VALIDADE').AsInteger) + ')',[rfReplaceAll]);
        Result := StringReplace(Result,'<%>DA_DATADEENTRADA<%>',FormatDateTime('dd/mm/yyyy',Proposta.FieldByName('DT_DATAEHORADACRIACAO').AsDateTime),[rfReplaceAll]);

        if MyModule.CheckBox_ExibirInstalador.Checked then
        begin
            Result := StringReplace(Result,'<%>INSTALADOR<%>',Proposta.FieldByName('INSTALADOR').AsString,[rfReplaceAll]);
            Result := StringReplace(Result,'<%>EXIBIRINSTALADOR_I<%>','',[rfReplaceAll]);
            Result := StringReplace(Result,'<%>EXIBIRINSTALADOR_F<%>','',[rfReplaceAll]);
        end
        else
        begin
            Result := StringReplace(Result,'<%>EXIBIRINSTALADOR_I<%>','<!--',[rfReplaceAll]);
            Result := StringReplace(Result,'<%>EXIBIRINSTALADOR_F<%>','-->',[rfReplaceAll]);
        end;

        if MyModule.CheckBoxExibirReajusteDaProposta.Checked then
            Result := StringReplace(Result,'<%>REAJUSTEDAPROPOSTA<%>',' (' + Proposta.FieldByName('REAJUSTE').AsString + ')',[rfReplaceAll])
        else
            Result := StringReplace(Result,'<%>REAJUSTEDAPROPOSTA<%>','',[rfReplaceAll]);

        Result := StringReplace(Result,'<%>TOTAL<%>',ObterValorDaProposta(FVA_COTACOES,IntToStr(FIN_PROPOSTAS_ID)),[rfReplaceAll]);
    finally
        if Assigned(Proposta) then
            Proposta.Free;
    end;
end;

procedure TBDODataModule_GeradorDeProposta.GerarRelatorio;
begin
    ClearHTML;
    SaveTextFile(GerarProposta,ArquivoTemporario);
    inherited;
end;

function TBDODataModule_GeradorDeProposta.MyModule: TBDOForm_GeradorDeProposta;
begin
    Result := TBDOForm_GeradorDeProposta(Owner);
end;

function TBDODataModule_GeradorDeProposta.ObterValorDaProposta(const aCotacoes
                                                                   , aIDProposta: ShortString): ShortString;
var
    Sql: String;
    RODataSet: TZReadOnlyQuery;
begin
    Result := 'S/ PRO. OU S/ EQP.';
    RODataSet := nil;

    if MyModule.CheckBox_AplicarReajusteDaPropostaNosItens.Checked then
    begin
        Sql := StringReplace(SQL_ITENS_CALC
                            ,':REAJUSTEDAPROPOSTA1:'
                            ,'1'
                            ,[rfReplaceAll]);

        Sql := StringReplace(Sql
                            ,':REAJUSTEDAPROPOSTA2:'
                            ,'FNC_GET_PROPOSAL_REAJUST_MULTIPLIER(ITE.IN_PROPOSTAS_ID)'
                            ,[rfReplaceAll]);

    end
    else
    begin
        Sql := StringReplace(SQL_ITENS_CALC
                            ,':REAJUSTEDAPROPOSTA1:'
                            ,'FNC_GET_PROPOSAL_REAJUST_MULTIPLIER(T.IN_PROPOSTAS_ID)'
                            ,[rfReplaceAll]);

        Sql := StringReplace(Sql
                            ,':REAJUSTEDAPROPOSTA2:'
                            ,'1'
                            ,[rfReplaceAll]);
    end;

    Sql := StringReplace(Sql
                        ,':COTACOES:'
                        ,aCotacoes
                        ,[rfReplaceAll]);

    Sql := StringReplace(Sql
                        ,':IN_PROPOSTAS_ID:'
                        ,aIDProposta
                        ,[rfReplaceAll]);

    try
        ConfigureDataSet(DataModuleMain.ZConnections.ByName['ZConnection_BDO'].Connection
                        ,RODataSet
                        ,Sql);

        if Assigned(RODataSet) then
            Result := RODataSet.Fields[0].AsString;

    finally
        RODataSet.Free;
    end;

//SQL_ITENS
//
//    if MyModule.CheckBox_AplicarReajusteDaPropostaNosItens.Checked then
//        ItemSQL := StringReplace(SQL_ITENS
//                                ,':REAJUSTEDAPROPOSTA:'
//                                ,'FNC_GET_PROPOSAL_REAJUST_MULTIPLIER(ITE.IN_PROPOSTAS_ID)'
//                                ,[rfReplaceAll])
//    else
//        ItemSQL := StringReplace(SQL_ITENS
//                                ,':REAJUSTEDAPROPOSTA:'
//                                ,'1'
//                                ,[rfReplaceAll]);
//
//    try
//        ConfigureDataSet(DataModuleMain.ZConnections.ByName['ZConnection_BDO'].Connection
//                        ,Itens
//                        ,Format(ItemSQL
//                               ,[FVA_COTACOES
//                                ,FIN_PROPOSTAS_ID]));
//
//
//    'SELECT SUM(T.VALORTOTALPAR) * :REAJUSTEDAPROPOSTA1:'#13#10 +
//    '  FROM (SELECT ITE.IN_PROPOSTAS_ID'#13#10 +
//    '             , @ValorAjustado := ROUND(FNC_GET_ITEM_VALUE(ITE.IN_ITENS_ID,TRUE,FALSE,'':COTACOES:'',2) * FNC_GET_REAJUST_MULTIPLIER(ITE.FL_DESCONTOPERC) * :REAJUSTEDAPROPOSTA2:,2)'#13#10 +
//    '             , @ValorTotalPar := @ValorAjustado * ITE.SM_QUANTIDADE AS VALORTOTALPAR'#13#10 +
//    '          FROM ITENS ITE'#13#10 +
//    '         WHERE ITE.IN_PROPOSTAS_ID = :IN_PROPOSTAS_ID:) T';
end;

procedure TBDODataModule_GeradorDeProposta.SetPropostaID(const Value: Cardinal);
var
    RODataSet: TZReadOnlyQuery;
begin
    inherited;
    FIN_PROPOSTAS_ID := Value;
    
    { Obtendo as cotações e a moeda da proposta }
    RODataSet := nil;
    try
        ConfigureDataSet(DataModuleMain.ZConnections.ByName['ZConnection_BDO'].Connection
                        ,RODataSet
                        ,Format(SQL_COTACAO_MOEDA,[FIN_PROPOSTAS_ID]));

        if not RODataSet.IsEmpty then
        begin
            FVA_COTACOES := RODataSet.Fields[0].AsString;
            FTI_MOEDA := RODataSet.Fields[1].AsInteger;
        end;
        FCodigoDaProposta := CodigoDaProposta(FIN_PROPOSTAS_ID);

        ConfigureDataSet(DataModuleMain.ZConnections.ByName['ZConnection_BDO'].Connection
                        ,RODataSet
                        ,Format(SQL_RODAPES,[FIN_PROPOSTAS_ID]));

        if not RODataSet.IsEmpty then
        begin
            FRodape1 := RODataSet.Fields[0].AsString;
            FRodape2 := RODataSet.Fields[1].AsString;
        end;

    finally
        if Assigned(RODataSet) then
            RODataSet.Free;
    end;
end;

end.
