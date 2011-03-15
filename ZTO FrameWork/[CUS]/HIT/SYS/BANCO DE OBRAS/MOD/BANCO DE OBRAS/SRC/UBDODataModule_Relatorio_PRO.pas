unit UBDODataModule_Relatorio_PRO;

interface

uses
    Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
    Dialogs, UBDODataModule_GeradorDeRelatorio, ImgList, ActnList, UBDOForm_Relatorio_PRO;

type
    TBDODataModule_Relatorio_PRO = class(TBDODataModule_GeradorDeRelatorio)
        procedure DataModuleCreate(Sender: TObject);
    private
        { Private declarations }
        FVA_COTACOES: ShortString;
        function GerarRelatorioDePropostas: String;
        function MyModule: TBDOForm_Relatorio_PRO;
        function GetMoeda: Byte;
    public
        { Public declarations }
        procedure DefinirCotacoes;
        procedure ExibirInformacoesDaProposta(const aPropostaID: Cardinal);
        procedure GerarRelatorio; override;
    end;

implementation

uses
    ZDataset, ComCtrls, UXXXDataModule, UBDODataModule;

{$R *.dfm}

const
  	SQL_REGIOES =
    'SELECT REG.TI_REGIOES_ID'#13#10 +
    '     , REG.VA_REGIAO'#13#10 +
    '  FROM REGIOES REG'#13#10 +
    '  JOIN REGIOESDOSUSUARIOS RDU USING (TI_REGIOES_ID)'#13#10 +
    ' WHERE RDU.SM_USUARIOS_ID = %u';

  	SQL_REGIAO =
    'SELECT TI_REGIOES_ID'#13#10 +
    '     , VA_REGIAO'#13#10 +
    '  FROM REGIOES'#13#10 +
    ' WHERE TI_REGIOES_ID = %u';

	SQL_PROPOSTAS =
    '  SELECT PRO.IN_PROPOSTAS_ID'#13#10 +
    '       , FNC_GET_PROPOSAL_CODE(PRO.IN_PROPOSTAS_ID) AS CODIGO'#13#10 +
    '       , OBR.VA_NOMEDAOBRA AS NOMEDAOBRA'#13#10 +
    '       %s, INS.VA_NOME AS INSTALADOR'#13#10 +
    '       %s, SIT.VA_DESCRICAO AS SITUACAO'#13#10 +
    '       , CONCAT(OBR.VA_CIDADE,'' / '',OBR.CH_ESTADO) AS LOCALIDADE'#13#10 +
    '       %s, FNC_GET_FORMATTED_CURRENCY_VALUE(FNC_GET_PROPOSAL_VALUE(PRO.IN_PROPOSTAS_ID,FALSE,FALSE,''%s'',2),ELT(%u,''US$'',''€'',''R$'',''£'',''¥''),FALSE) AS TOTAL'#13#10 +
    '       , FNC_GET_PROPOSAL_VALUE(PRO.IN_PROPOSTAS_ID,FALSE,FALSE,''%3:s'',2) AS VALOR'#13#10 +
    '    FROM OBRAS OBR'#13#10 +
    '    JOIN SITUACOES SIT USING (TI_SITUACOES_ID)'#13#10 +
    '    JOIN PROPOSTAS PRO USING (IN_OBRAS_ID)'#13#10 +
    '    JOIN INSTALADORES INS USING (SM_INSTALADORES_ID)'#13#10 +
    '   WHERE PRO.BO_PROPOSTAPADRAO'#13#10 +
    '     AND PRO.DT_DATAEHORADACRIACAO BETWEEN :DATA1 AND :DATA2'#13#10 +
    '     %5:s'#13#10 +
    'ORDER BY %s';

    SQL_INSTALADORES =
    '  SELECT SM_INSTALADORES_ID'#13#10 +
    '       , VA_NOME'#13#10 +
    '    FROM INSTALADORES'#13#10 +
    '%s' +
    'ORDER BY VA_NOME';

    SQL_SITUACOES =
    'SELECT TI_SITUACOES_ID'#13#10 +
    '     , VA_DESCRICAO'#13#10 +
    '  FROM SITUACOES'#13#10 +
    ' WHERE TI_SITUACOES_ID IN (%s)';

resourcestring
    RS_PRIMEIRORODAPE_RELATORIO = 'HITACHI AR CONDICIONADO DO BRASIL LTDA.';
    RS_SEGUNDORODAPE_RELATORIO = 'http://www.hitachiapb.com.br';

procedure TBDODataModule_Relatorio_PRO.DataModuleCreate(Sender: TObject);
begin
    inherited;
    FVA_COTACOES := '1;1;1;1;1';
end;

procedure TBDODataModule_Relatorio_PRO.DefinirCotacoes;
var
    Cotacoes: ShortString;
begin
    inherited;
    Cotacoes := ShowCurrencyConvertManager(FVA_COTACOES,GetMoeda);

    if Trim(Cotacoes) <> '' then
    begin
        FVA_COTACOES := Cotacoes;
//        GerarRelatorio;
    end;
end;

procedure TBDODataModule_Relatorio_PRO.ExibirInformacoesDaProposta(const aPropostaID: Cardinal);
begin
    inherited ExibirInformacoesDaProposta(aPropostaID);    
end;

procedure TBDODataModule_Relatorio_PRO.GerarRelatorio;
begin
    ClearHTML;
    SaveTextFile(GerarRelatorioDePropostas,ArquivoTemporario);
    inherited;
end;

function TBDODataModule_Relatorio_PRO.GerarRelatorioDePropostas: String;

    function OpcaoDeListagemSelecionada: Word;
    begin
        Result := Word(MyModule.ComboBox_OpcaoDeListagem.Items.Objects[MyModule.ComboBox_OpcaoDeListagem.ItemIndex]);
    end;

    function MountSituationsString: ShortString;
    var
        i: Word;
    begin
    	Result := '';
        if MyModule.CheckListBox_SituacoesAListar.Count > 0 then
        begin
	        for i := 0 to Pred(MyModule.CheckListBox_SituacoesAListar.Count) do
            	if MyModule.CheckListBox_SituacoesAListar.Checked[i] then
                begin
                	Result := Result + IntToStr(Integer(MyModule.CheckListBox_SituacoesAListar.Items.Objects[i])) + ',';
                end;
            Delete(Result,Length(Result),1);
        end;
    end;

    function HasCheckedSituation: Boolean;
    var
        i: Word;
    begin
    	Result := False;
        if MyModule.CheckListBox_SituacoesAListar.Count > 0 then
	        for i := 0 to Pred(MyModule.CheckListBox_SituacoesAListar.Count) do
            	if MyModule.CheckListBox_SituacoesAListar.Checked[i] then
                begin
                	Result := True;
                    Break;
                end;
    end;
var
    LinhaTemplate, PropostasHTML, TempLinhas, TemplateGrupo, MinhasRegioes: String;
    Situacoes: ShortString;
    RODataSet, RODataSetRegioes, RODataSetInstaladores, RODataSetSituacoes: TZReadOnlyQuery;
    ItemNo: Cardinal;
    ValorTotal, ValorTotalGeral: Currency;

    { A função abaixo retorna apenas TDs, nada de <TABLE> ou </TABLE> }
    function ResultSetPropostas(out oValorTotal: Currency; aCondicao: ShortString = ''): String;
    var
        ExibirValores, ExibirInstaladores, ExibirSituacoes: Char;
        OrdenarPor: ShortString;
    begin
    	Result := '';
	    ItemNo := 0;
    	oValorTotal := 0;
	    RODataSet := nil;

        if MyModule.CheckBoxExibirValores.Checked then
        	ExibirValores := ' '
        else
			ExibirValores := '#';

        if MyModule.CheckBoxExibirInstaladores.Checked and not MyModule.RadioButton_PorInstalador.Checked then
        	ExibirInstaladores := ' '
        else
        	ExibirInstaladores := '#';

        ExibirSituacoes := ' ';
        if MyModule.RadioButton_PorSituacao.Checked then
            ExibirSituacoes := '#';

        if MyModule.RadioButton_OrdenarPorCodigo.Checked then
            OrdenarPor := 'CODIGO'
        else if MyModule.RadioButton_OrdenarPorValor.Checked then
            OrdenarPor := 'VALOR'
        else if MyModule.RadioButton_OrdenarPorSituacao.Checked then
            OrdenarPor := 'SITUACAO';

    	try
		    ConfigureDataSet(DataModuleMain.ZConnections.ByName['ZConnection_BDO'].Connection
                            ,RODataSet,MySQLFormat(SQL_PROPOSTAS
                                                  ,[ExibirInstaladores
                                                   ,ExibirSituacoes
                                                   ,ExibirValores
                                                   ,FVA_COTACOES
                                                   ,GetMoeda
                                                   ,aCondicao
                                                   ,OrdenarPor]));

            RODataSet.ParamByName('DATA1').AsDate := MyModule.DateTimePicker_DA_DATADEENTRADA1.DateTime;
            RODataSet.ParamByName('DATA2').AsDate := MyModule.DateTimePicker_DA_DATADEENTRADA2.DateTime;
            RODataSet.Refresh;

            if MyModule.RadioButton_Normal.Checked then
            begin
                MyModule.ProgressBar_GeracaoDeRelatorio.Position := 0;
                MyModule.ProgressBar_GeracaoDeRelatorio.Step := 1;
                MyModule.ProgressBar_GeracaoDeRelatorio.Max := RODataSet.RecordCount;
                MyModule.ProgressBar_GeracaoDeRelatorio.Show;
            end;

            RODataSet.First;
            with RODataSet do
                while not Eof do
                begin
                    { Haverá pulo das situções apenas se não estivermos listando
                    por situações }
                    if not MyModule.RadioButton_PorSituacao.Checked then
                    begin
                        if not MyModule.CheckBoxContarComGanhas.Checked and (FieldByName('SITUACAO').AsString = 'GANHA') then
                        begin
                            Next;
                            Continue;
                        end;

                        if not MyModule.CheckBoxContarComPerdidas.Checked and (FieldByName('SITUACAO').AsString = 'PERDIDA') then
                        begin
                            Next;
                            Continue;
                        end;

                        if not MyModule.CheckBoxContarComSuspensas.Checked and (FieldByName('SITUACAO').AsString = 'SUSPENSA') then
                        begin
                            Next;
                            Continue;
                        end;
                    end;

                    (* Primeira substituição *)
                    Result := Result + #13#10 + StringReplace(LinhaTemplate,'<%>CODIGO<%>',FieldByName('CODIGO').AsString,[]);
                    Inc(ItemNo);

                    (* Incluindo o código da proposta *)
                    Result := StringReplace(Result,'[%]IN_PROPOSTAS_ID[%]',FieldByName('IN_PROPOSTAS_ID').AsString,[]);

                    (* Gerando linhas de cores alternadas *)
                    if Odd(ItemNo) then
                        Result := StringReplace(Result,'<%>LINHACOR<%>','CLASS="linhacor"',[])
                    else
                        Result := StringReplace(Result,'<%>LINHACOR<%>','',[]);

                    (* Restante das substituições ... *)
                    (* Exibir valores? *)
                    if MyModule.CheckBoxExibirValores.Checked then
                        Result := StringReplace(Result,'<%>VALOR<%>',FieldByName('TOTAL').AsString,[]);

                    (* Exibir instaladores? *)
                    if MyModule.CheckBoxExibirInstaladores.Checked and not MyModule.RadioButton_PorInstalador.Checked then
                        Result := StringReplace(Result,'<%>INSTALADOR<%>',FieldByName('INSTALADOR').AsString,[]);

                    Result := StringReplace(Result,'<%>OBRA<%>',FieldByName('NOMEDAOBRA').AsString,[]);

                    if not MyModule.RadioButton_PorSituacao.Checked then
                        Result := StringReplace(Result,'<%>SITUACAO<%>',FieldByName('SITUACAO').AsString,[]);

                    Result := StringReplace(Result,'<%>LOCALIDADE<%>',FieldByName('LOCALIDADE').AsString,[]);

                    (* Acumulando o valor total para posterior exibição *)
                    if MyModule.CheckBoxExibirTotais.Checked then
                        oValorTotal := oValorTotal + FieldByName('VALOR').AsCurrency;

                    if MyModule.RadioButton_Normal.Checked then
                        MyModule.ProgressBar_GeracaoDeRelatorio.StepIt;
                    Next;
                end;
		finally
    		if Assigned(RODataSet) then
				RODataSet.Free;

            if MyModule.RadioButton_Normal.Checked then
                MyModule.DelayedHideProgressBar;
        end;
	end;
begin { ====================================================================== }
    (* Carregando o arquivo de modelo geral que será posto em result *)

    if MyModule.RadioButton_PorRegiao.Checked
    or MyModule.RadioButton_PorInstalador.Checked
    or MyModule.RadioButton_PorSituacao.Checked then 
        Result := LoadTextFile(Configurations.CurrentDir + '\reporttemplates\PROPOSTAS\propostasnoperiodo[8].'{$IFDEF IE}+'ie'+{$ELSE}+'firefox'+{$ENDIF}'.template')
    else { modo normal }
        Result := LoadTextFile(Configurations.CurrentDir + '\reporttemplates\PROPOSTAS\propostasnoperiodo[1].'{$IFDEF IE}+'ie'+{$ELSE}+'firefox'+{$ENDIF}'.template');

    (* Se o modo de listagem for por regiões ou por instaladores ou por situações,
    temos de carregar o modelo para uma região ou instalador ou situação, que
    será repetido para cada região ou instalador ou situação *)
    if MyModule.RadioButton_PorRegiao.Checked
    or MyModule.RadioButton_PorInstalador.Checked
    or MyModule.RadioButton_PorSituacao.Checked then
        TemplateGrupo := LoadTextFile(Configurations.CurrentDir + '\reporttemplates\PROPOSTAS\propostasnoperiodo[9].template');

    Result := StringReplace(Result,'<%>PRIMEIRORODAPE<%>',RS_PRIMEIRORODAPE_RELATORIO,[]);
    Result := StringReplace(Result,'<%>SEGUNDORODAPE<%>',RS_SEGUNDORODAPE_RELATORIO,[]);

    (* Exibir período? *)
    if MyModule.CheckBoxExibirPeriodo.Checked then
	    Result := StringReplace(Result,'<%>PERIODO<%>','(no período de ' + FormatDateTime('dd/mm/yyyy',MyModule.DateTimePicker_DA_DATADEENTRADA1.DateTime) + ' a ' + FormatDateTime('dd/mm/yyyy',MyModule.DateTimePicker_DA_DATADEENTRADA2.DateTime) + ')',[])
    else
    	Result := StringReplace(Result,'<%>PERIODO<%>','',[]);

    (* Exibir valores parciais (cabeçalho)? *)
    if MyModule.CheckBoxExibirValores.Checked then
    begin
        if MyModule.RadioButton_PorRegiao.Checked
        or MyModule.RadioButton_PorInstalador.Checked
        or MyModule.RadioButton_PorSituacao.Checked then
            TemplateGrupo := StringReplace(TemplateGrupo,'<%>EXIBIRVALOR<%>',LoadTextFile(Configurations.CurrentDir + '\reporttemplates\PROPOSTAS\propostasnoperiodo[2].template'),[])
        else { MODO NORMAL }
            Result := StringReplace(Result,'<%>EXIBIRVALOR<%>',LoadTextFile(Configurations.CurrentDir + '\reporttemplates\PROPOSTAS\propostasnoperiodo[2].template'),[]);
    end
    else
	    if MyModule.RadioButton_PorRegiao.Checked
        or MyModule.RadioButton_PorInstalador.Checked
        or MyModule.RadioButton_PorSituacao.Checked then
    		TemplateGrupo := StringReplace(TemplateGrupo,'<%>EXIBIRVALOR<%>','',[])
	    else  { MODO NORMAL }
    		Result := StringReplace(Result,'<%>EXIBIRVALOR<%>','',[]);

    (* Exibir total geral (tabela)? *)
    if MyModule.CheckBoxExibirTotais.Checked then
    begin
        if MyModule.RadioButton_PorRegiao.Checked
        or MyModule.RadioButton_PorInstalador.Checked
        or MyModule.RadioButton_PorSituacao.Checked then
        begin
            TemplateGrupo := StringReplace(TemplateGrupo,'<%>TOTALGERAL<%>',LoadTextFile(Configurations.CurrentDir + '\reporttemplates\PROPOSTAS\propostasnoperiodo[5].template'),[]);
            Result := StringReplace(Result,'<%>VALORTOTALGERAL<%>',LoadTextFile(Configurations.CurrentDir + '\reporttemplates\PROPOSTAS\propostasnoperiodo[10].template'),[]);
        end
        else { MODO NORMAL }
            Result := StringReplace(Result,'<%>TOTALGERAL<%>',LoadTextFile(Configurations.CurrentDir + '\reporttemplates\PROPOSTAS\propostasnoperiodo[5].template'),[])
    end
    else
	    if MyModule.RadioButton_PorRegiao.Checked
        or MyModule.RadioButton_PorInstalador.Checked
        or MyModule.RadioButton_PorSituacao.Checked then
        begin
	        TemplateGrupo := StringReplace(TemplateGrupo,'<%>TOTALGERAL<%>','',[]);
    	    Result := StringReplace(Result,'<%>VALORTOTALGERAL<%>','',[]);
        end
        else { MODO NORMAL }
        	Result := StringReplace(Result,'<%>TOTALGERAL<%>','',[]);

    (* Exibir instaladores? *)
    if MyModule.CheckBoxExibirInstaladores.Checked and not MyModule.RadioButton_PorInstalador.Checked then
    begin
        if MyModule.RadioButton_PorRegiao.Checked
        or MyModule.RadioButton_PorSituacao.Checked then
            TemplateGrupo := StringReplace(TemplateGrupo,'[%]EXIBIRINSTALADOR[%]',LoadTextFile(Configurations.CurrentDir + '\reporttemplates\PROPOSTAS\propostasnoperiodo[6].template'),[])
        else { MODO NORMAL }
            Result := StringReplace(Result,'[%]EXIBIRINSTALADOR[%]',LoadTextFile(Configurations.CurrentDir + '\reporttemplates\PROPOSTAS\propostasnoperiodo[6].template'),[]);
    end
    else
	    if MyModule.RadioButton_PorRegiao.Checked
        or MyModule.RadioButton_PorInstalador.Checked
        or MyModule.RadioButton_PorSituacao.Checked then
    		TemplateGrupo := StringReplace(TemplateGrupo,'[%]EXIBIRINSTALADOR[%]','',[])
	    else { MODO NORMAL }
    		Result := StringReplace(Result,'[%]EXIBIRINSTALADOR[%]','',[]);


    { TODO : Aparentemente o modo abaixo de fazer as coisas é o mais correto e limpo }
    { Exibir situações? }
    if not MyModule.RadioButton_PorSituacao.Checked then
    begin
        if MyModule.RadioButton_Normal.Checked then
            Result := StringReplace(Result,'[%]EXIBIRSITUACAO[%]',LoadTextFile(Configurations.CurrentDir + '\reporttemplates\PROPOSTAS\propostasnoperiodo[11].template'),[])
        else { por região / por instalador }
            TemplateGrupo := StringReplace(TemplateGrupo,'[%]EXIBIRSITUACAO[%]',LoadTextFile(Configurations.CurrentDir + '\reporttemplates\PROPOSTAS\propostasnoperiodo[11].template'),[])
    end
    else { por situação }
    	TemplateGrupo := StringReplace(TemplateGrupo,'[%]EXIBIRSITUACAO[%]','',[]);

    (* Carregando o arquivo com o modelo de uma linha de tabela (replicavel) *)
    LinhaTemplate := LoadTextFile(Configurations.CurrentDir + '\reporttemplates\PROPOSTAS\propostasnoperiodo[3].template');
    
    if MyModule.CheckBoxExibirValores.Checked then
        LinhaTemplate := StringReplace(LinhaTemplate,'<%>EXIBIRVALOR<%>',LoadTextFile(Configurations.CurrentDir + '\reporttemplates\PROPOSTAS\propostasnoperiodo[4].template'),[])
    else
        LinhaTemplate := StringReplace(LinhaTemplate,'<%>EXIBIRVALOR<%>','',[]);

    if MyModule.CheckBoxExibirInstaladores.Checked and not MyModule.RadioButton_PorInstalador.Checked then
        LinhaTemplate := StringReplace(LinhaTemplate,'[%]EXIBIRINSTALADOR[%]',LoadTextFile(Configurations.CurrentDir + '\reporttemplates\PROPOSTAS\propostasnoperiodo[7].template'),[])
    else
        LinhaTemplate := StringReplace(LinhaTemplate,'[%]EXIBIRINSTALADOR[%]','',[]);

    if not MyModule.RadioButton_PorSituacao.Checked then
        LinhaTemplate := StringReplace(LinhaTemplate,'[%]EXIBIRSITUACAO[%]',LoadTextFile(Configurations.CurrentDir + '\reporttemplates\PROPOSTAS\propostasnoperiodo[12].template'),[])
    else
        LinhaTemplate := StringReplace(LinhaTemplate,'[%]EXIBIRSITUACAO[%]','',[]);

    (* Início da iteração nos campos *)
    { Por regiao }
    if MyModule.RadioButton_PorRegiao.Checked then
    begin
	    RODataSetRegioes := nil;
    	try
        	{ Lista todas as regiões do usuário }
            if OpcaoDeListagemSelecionada = 0 then
            begin
                ConfigureDataSet(DataModuleMain.ZConnections.ByName['ZConnection_BDO'].Connection
                                ,RODataSetRegioes
                                ,MySQLFormat(SQL_REGIOES
                                            ,[Configurations.AuthenticatedUser.Id]));

                PropostasHTML := '<!-- Conteúdo variável -->';
                ValorTotalGeral := 0;

                MyModule.ProgressBar_GeracaoDeRelatorio.Position := 0;
                MyModule.ProgressBar_GeracaoDeRelatorio.Step := 1;
                MyModule.ProgressBar_GeracaoDeRelatorio.Max := RODataSetRegioes.RecordCount;
                MyModule.ProgressBar_GeracaoDeRelatorio.Show;

                with RODataSetRegioes do
                    while not Eof do { Para cada região... }
                    begin
                        (* Preenche as linhas das propostas ao mesmo tempo que obtém o
                        somatório dos valores das mesmas *)
                        TempLinhas := ''; // Para o caso de algum erro acontecer em ResultSetPropostas
                        TempLinhas := ResultSetPropostas(ValorTotal,'AND OBR.TI_REGIOES_ID = ' + Fields[0].AsString);

                        if TempLinhas <> '' then
                        begin
                            (* Primeira substituição: Mais um bloco com uma região e o cabeçalho         
                            das propostas da mesma *)
                            PropostasHTML := PropostasHTML + #13#10 + StringReplace(TemplateGrupo,'[%]REG_INS_SIT[%]','Na região ' + Fields[1].AsString,[]);
                            PropostasHTML := StringReplace(PropostasHTML,'<%>CONTEUDO<%>',TempLinhas,[])
                        end
                        else
                        begin
                            MyModule.ProgressBar_GeracaoDeRelatorio.StepIt;
                            Next;
                            Continue;
                        end;

                        (* Substituindo o valor total *)
                        if MyModule.CheckBoxExibirTotais.Checked then
//                            PropostasHTML := StringReplace(PropostasHTML,'<%>VALORTOTAL<%>',FormatFloat(rs_formatovalormonetarioreal,ValorTotal),[]);
                            PropostasHTML := StringReplace(PropostasHTML,'<%>VALORTOTAL<%>',FormatFloat('"' + SimboloMonetario(GetMoeda) + '" ###,###,###,##0.00',ValorTotal),[]);

                        (* Acumula o valor total de todas as propostas juntas *)
                        ValorTotalGeral := ValorTotalGeral + ValorTotal;

                        MyModule.ProgressBar_GeracaoDeRelatorio.StepIt;
                        Next;
                    end;
            end
            else { Lista apenas a região escolhida }
            begin
                ConfigureDataSet(DataModuleMain.ZConnections.ByName['ZConnection_BDO'].Connection
                                ,RODataSetRegioes
                                ,MySQLFormat(SQL_REGIAO
                                            ,[OpcaoDeListagemSelecionada]));

                PropostasHTML := '<!-- Conteúdo variável -->';
                ValorTotalGeral := 0;

                with RODataSetRegioes do
                begin
                    (* Preenche as linhas das propostas ao mesmo tempo que obtém o
                    somatório dos valores das mesmas *)
                    TempLinhas := ''; // Para o caso de algum erro acontecer em ResultSetPropostas
                    TempLinhas := ResultSetPropostas(ValorTotal,'AND OBR.TI_REGIOES_ID = ' + Fields[0].AsString);

                    if TempLinhas <> '' then
                    begin
                        (* Primeira substituição: Mais um bloco com uma região e o cabeçalho
                        das propostas da mesma *)
                        PropostasHTML := PropostasHTML + #13#10 + StringReplace(TemplateGrupo,'[%]REG_INS_SIT[%]','Na região ' + Fields[1].AsString,[]);
                        PropostasHTML := StringReplace(PropostasHTML,'<%>CONTEUDO<%>',TempLinhas,[])
                    end;

                    (* Substituindo o valor total *)
                    if MyModule.CheckBoxExibirTotais.Checked then
                        PropostasHTML := StringReplace(PropostasHTML,'<%>VALORTOTAL<%>',FormatFloat('"' + SimboloMonetario(GetMoeda) + '" ###,###,###,##0.00',ValorTotal),[]);
                    //                                PropostasHTML := StringReplace(PropostasHTML,'<%>VALORTOTAL<%>',FormatFloat(rs_formatovalormonetarioreal,ValorTotal),[]);


                    (* Acumula o valor total de todas as propostas juntas *)
                    ValorTotalGeral := ValorTotalGeral + ValorTotal;
                end;
            end;

            (* Incluindo o conjunto de blocos de regiao no resultado final (Template
            principal) *)
            Result := StringReplace(Result,'<%>CONTEUDO<%>',PropostasHTML,[]);

            (* Substituindo o valor total *)
            if MyModule.CheckBoxExibirTotais.Checked then
	            Result := StringReplace(Result,'<%>VALORTOTAL<%>',FormatFloat('"' + SimboloMonetario(GetMoeda) + '" ###,###,###,##0.00',ValorTotalGeral),[]);
//	            Result := StringReplace(Result,'<%>VALORTOTAL<%>',FormatFloat(rs_formatovalormonetarioreal,ValorTotalGeral),[]);
    	finally
		    if Assigned(RODataSetRegioes) then
			    RODataSetRegioes.Free;

            MyModule.DelayedHideProgressBar;
        end;
    end
    { Por situação (apenas as regioes do usuario) }
    else if MyModule.RadioButton_PorSituacao.Checked then
    begin
      	Situacoes := '0';
        if HasCheckedSituation then
            Situacoes := MountSituationsString;

	    RODataSetSituacoes := nil;
    	try
            MinhasRegioes := ArrayOfByteToString(RegioesDoUsuario(Configurations.AuthenticatedUser.Id));

            ConfigureDataSet(DataModuleMain.ZConnections.ByName['ZConnection_BDO'].Connection
                            ,RODataSetSituacoes
                            ,MySQLFormat(SQL_SITUACOES
                                        ,[Situacoes]));

            PropostasHTML := '<!-- Conteúdo variável -->';
            ValorTotalGeral := 0;

            MyModule.ProgressBar_GeracaoDeRelatorio.Position := 0;
            MyModule.ProgressBar_GeracaoDeRelatorio.Step := 1;
            MyModule.ProgressBar_GeracaoDeRelatorio.Max := RODataSetSituacoes.RecordCount;
            MyModule.ProgressBar_GeracaoDeRelatorio.Show;

            with RODataSetSituacoes do
                while not Eof do { Para cada situação... }
                begin
                    (* Preenche as linhas das propostas ao mesmo tempo que obtém o
                    somatório dos valores das mesmas *)
                    TempLinhas := ''; // Para o caso de algum erro acontecer em ResultSetPropostas

                    TempLinhas := ResultSetPropostas(ValorTotal
                                                    ,'AND OBR.TI_REGIOES_ID IN (' + MinhasRegioes + ')' + #13#10 +
                                                     'AND OBR.TI_SITUACOES_ID = ' + Fields[0].AsString);

                    if TempLinhas <> '' then
                    begin
                        (* Primeira substituição: Mais um bloco com uma
                        situação e o cabeçalho das propostas da mesma *)
                        PropostasHTML := PropostasHTML + #13#10 + StringReplace(TemplateGrupo,'[%]REG_INS_SIT[%]','Na situação ' + Fields[1].AsString,[]);
                        PropostasHTML := StringReplace(PropostasHTML,'<%>CONTEUDO<%>',TempLinhas,[])
                    end
                    else
                    begin
                        MyModule.ProgressBar_GeracaoDeRelatorio.StepIt;
                        Next;
                        Continue;
                    end;

                    (* Substituindo o valor total *)
                    if MyModule.CheckBoxExibirTotais.Checked then
                        PropostasHTML := StringReplace(PropostasHTML,'<%>VALORTOTAL<%>',FormatFloat('"' + SimboloMonetario(GetMoeda) + '" ###,###,###,##0.00',ValorTotal),[]);

                    (* Acumula o valor total de todas as propostas juntas *)
                    ValorTotalGeral := ValorTotalGeral + ValorTotal;

                    MyModule.ProgressBar_GeracaoDeRelatorio.StepIt;
                    Next;
                end;


            (* Incluindo o conjunto de blocos de situações no resultado final
            
            (Template principal) *)
            Result := StringReplace(Result,'<%>CONTEUDO<%>',PropostasHTML,[]);

            (* Substituindo o valor total *)
            if MyModule.CheckBoxExibirTotais.Checked then
	            Result := StringReplace(Result,'<%>VALORTOTAL<%>',FormatFloat('"' + SimboloMonetario(GetMoeda) + '" ###,###,###,##0.00',ValorTotalGeral),[]);
    	finally
		    if Assigned(RODataSetSituacoes) then
			    RODataSetSituacoes.Free;

            MyModule.DelayedHideProgressBar;
        end;

    end
    { Modo normal (apenas as regioes do usuario) }
    else if MyModule.RadioButton_Normal.Checked then
    begin
    	{ Gerando lista de regioes do usuário atual }
    	ConfigureDataSet(DataModuleMain.ZConnections.ByName['ZConnection_BDO'].Connection
                        ,RODataSetRegioes
                        ,MySQLFormat(SQL_REGIOES
                                    ,[Configurations.AuthenticatedUser.Id]));

        MinhasRegioes := '';

        RODataSetRegioes.First;
        while not RODataSetRegioes.Eof do
        begin
            MinhasRegioes := MinhasRegioes + RODataSetRegioes.Fields[0].AsString;

            if RODataSetRegioes.RecNo <> RODataSetRegioes.RecordCount then
                MinhasRegioes := MinhasRegioes + ',';

            RODataSetRegioes.Next;
        end;

        (* Incluindo o conteúdo *)
        Result := StringReplace(Result,'<%>CONTEUDO<%>',ResultSetPropostas(ValorTotal,'AND OBR.TI_REGIOES_ID IN (' + MinhasRegioes + ')'),[]);

        (* Substituindo o valor total *)
        if MyModule.CheckBoxExibirTotais.Checked then
            Result := StringReplace(Result,'<%>VALORTOTAL<%>',FormatFloat('"' + SimboloMonetario(GetMoeda) + '" ###,###,###,##0.00',ValorTotal),[]);
    end
    { Por instalador (apenas as regioes do usuario) }
    else if MyModule.RadioButton_PorInstalador.Checked then
    begin
	    RODataSetInstaladores := nil;
    	try
            MinhasRegioes := ArrayOfByteToString(RegioesDoUsuario(Configurations.AuthenticatedUser.Id));

        	{ Lista todos os instaladores }
            if OpcaoDeListagemSelecionada = 0 then
            begin
                ConfigureDataSet(DataModuleMain.ZConnections.ByName['ZConnection_BDO'].Connection
                                ,RODataSetInstaladores
                                ,MySQLFormat(SQL_INSTALADORES
                                            ,['']));

                PropostasHTML := '<!-- Conteúdo variável -->';
                ValorTotalGeral := 0;

                MyModule.ProgressBar_GeracaoDeRelatorio.Position := 0;
                MyModule.ProgressBar_GeracaoDeRelatorio.Step := 1;
                MyModule.ProgressBar_GeracaoDeRelatorio.Max := RODataSetInstaladores.RecordCount;
                MyModule.ProgressBar_GeracaoDeRelatorio.Show;

                with RODataSetInstaladores do
                    while not Eof do { Para cada instalador... }
                    begin
                        (* Preenche as linhas das propostas ao mesmo tempo que obtém o
                        somatório dos valores das mesmas *)
                        TempLinhas := ''; // Para o caso de algum erro acontecer em ResultSetPropostas

                        TempLinhas := ResultSetPropostas(ValorTotal
                                                        ,'AND OBR.TI_REGIOES_ID IN (' + MinhasRegioes + ')' + #13#10 +
                                                         'AND PRO.SM_INSTALADORES_ID = ' + Fields[0].AsString);

                        if TempLinhas <> '' then
                        begin
                            (* Primeira substituição: Mais um bloco com um
                            instalador e o cabeçalho das propostas do mesmo *)
                            PropostasHTML := PropostasHTML + #13#10 + StringReplace(TemplateGrupo,'[%]REG_INS_SIT[%]','Para o instalador ' + Fields[1].AsString,[]);
                            PropostasHTML := StringReplace(PropostasHTML,'<%>CONTEUDO<%>',TempLinhas,[])
                        end
                        else
                        begin
                            MyModule.ProgressBar_GeracaoDeRelatorio.StepIt;
                            Next;
                            Continue;
                        end;

                        (* Substituindo o valor total *)
                        if MyModule.CheckBoxExibirTotais.Checked then
//                            PropostasHTML := StringReplace(PropostasHTML,'<%>VALORTOTAL<%>',FormatFloat(rs_formatovalormonetarioreal,ValorTotal),[]);
                            PropostasHTML := StringReplace(PropostasHTML,'<%>VALORTOTAL<%>',FormatFloat('"' + SimboloMonetario(GetMoeda) + '" ###,###,###,##0.00',ValorTotal),[]);

                        (* Acumula o valor total de todas as propostas juntas *)
                        ValorTotalGeral := ValorTotalGeral + ValorTotal;

                        MyModule.ProgressBar_GeracaoDeRelatorio.StepIt;
                        Next;
                    end;
            end
            else { Lista apenas o instalador escolhido }
            begin
                ConfigureDataSet(DataModuleMain.ZConnections.ByName['ZConnection_BDO'].Connection
                                ,RODataSetInstaladores
                                ,MySQLFormat(SQL_INSTALADORES
                                            ,['   WHERE SM_INSTALADORES_ID = ' + IntToStr(OpcaoDeListagemSelecionada) + #13#10]));


                PropostasHTML := '<!-- Conteúdo variável -->';
                ValorTotalGeral := 0;

                with RODataSetInstaladores do
                begin
                    (* Preenche as linhas das propostas ao mesmo tempo que obtém o
                    somatório dos valores das mesmas *)
                    TempLinhas := ''; // Para o caso de algum erro acontecer em ResultSetPropostas
                    TempLinhas := ResultSetPropostas(ValorTotal
                                                    ,'AND OBR.TI_REGIOES_ID IN (' + MinhasRegioes + ')' + #13#10 +
                                                     'AND PRO.SM_INSTALADORES_ID = ' + Fields[0].AsString);


                    if TempLinhas <> '' then
                    begin
                        (* Primeira substituição: Mais um bloco com uma região e o cabeçalho
                        das propostas da mesma *)
                        PropostasHTML := PropostasHTML + #13#10 + StringReplace(TemplateGrupo,'[%]REG_INS_SIT[%]','Para o instalador ' + Fields[1].AsString,[]);
                        PropostasHTML := StringReplace(PropostasHTML,'<%>CONTEUDO<%>',TempLinhas,[])
                    end;

                    (* Substituindo o valor total *)
                    if MyModule.CheckBoxExibirTotais.Checked then
                        PropostasHTML := StringReplace(PropostasHTML,'<%>VALORTOTAL<%>',FormatFloat('"' + SimboloMonetario(GetMoeda) + '" ###,###,###,##0.00',ValorTotal),[]);
                    //                                PropostasHTML := StringReplace(PropostasHTML,'<%>VALORTOTAL<%>',FormatFloat(rs_formatovalormonetarioreal,ValorTotal),[]);


                    (* Acumula o valor total de todas as propostas juntas *)
                    ValorTotalGeral := ValorTotalGeral + ValorTotal;
                end;
            end;

            (* Incluindo o conjunto de blocos de instaladores no resultado final
            (Template principal) *)
            Result := StringReplace(Result,'<%>CONTEUDO<%>',PropostasHTML,[]);

            (* Substituindo o valor total *)
            if MyModule.CheckBoxExibirTotais.Checked then
	            Result := StringReplace(Result,'<%>VALORTOTAL<%>',FormatFloat('"' + SimboloMonetario(GetMoeda) + '" ###,###,###,##0.00',ValorTotalGeral),[]);
//	            Result := StringReplace(Result,'<%>VALORTOTAL<%>',FormatFloat(rs_formatovalormonetarioreal,ValorTotalGeral),[]);
    	finally
		    if Assigned(RODataSetInstaladores) then
			    RODataSetInstaladores.Free;

            MyModule.DelayedHideProgressBar;
        end;
    end;
end;

function TBDODataModule_Relatorio_PRO.GetMoeda: Byte;
begin
    Result := Byte(Succ(MyModule.ComboBox_PRO_TI_MOEDA.ItemIndex));
end;

function TBDODataModule_Relatorio_PRO.MyModule: TBDOForm_Relatorio_PRO;
begin
    Result := TBDOForm_Relatorio_PRO(Owner);
end;

end.
