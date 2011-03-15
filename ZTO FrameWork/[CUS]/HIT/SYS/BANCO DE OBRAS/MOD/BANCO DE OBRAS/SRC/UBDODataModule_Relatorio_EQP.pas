unit UBDODataModule_Relatorio_EQP;

interface

uses
    Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
    Dialogs, UBDODataModule_GeradorDeRelatorio, ImgList, ActnList, UBDOForm_Relatorio_EQP;

type
    TBDODataModule_Relatorio_EQP = class(TBDODataModule_GeradorDeRelatorio)
    private
        { Private declarations }
        function GerarRelatorioDeEquipamento: String;
        function MyModule: TBDOForm_Relatorio_EQP;
    public
        { Public declarations }
        procedure GerarRelatorio; override;
        procedure ExibirInformacoesDoEquipamento(const aMes, aAno, aEquipamento, aVoltagem: Cardinal);        
    end;

implementation

uses
    ZDataset, DateUtils, UBDOTypesConstantsAndClasses, CheckLst;

{$R *.dfm}

resourcestring
    rs_primeirorodape_relatorio = 'HITACHI AR CONDICIONADO DO BRASIL LTDA.';
    rs_segundorodape_relatorio = 'http://www.hitachiapb.com.br';

const
	HTML_COMMENT_I = '<!--';
	HTML_COMMENT_F = '-->';
    SQL_POR_SITUACAO =
    '  SELECT SIT.VA_DESCRICAO AS SITUACAO'#13#10 +
    '       , ITE.EN_VOLTAGEM AS VOLTAGEM'#13#10 +
    '       , EQP.VA_MODELO AS MODELO'#13#10 +
    '       , SUM(ITE.SM_QUANTIDADE) AS QUANTIDADE'#13#10 +
    '    FROM EQUIPAMENTOSDOSITENS EDI'#13#10 +
    '    JOIN ITENS ITE USING(IN_ITENS_ID)'#13#10 +
    '    JOIN PROPOSTAS PRO USING (IN_PROPOSTAS_ID)'#13#10 +
    '    JOIN OBRAS OBR USING (IN_OBRAS_ID)'#13#10 +
    '    JOIN SITUACOES SIT USING (TI_SITUACOES_ID)'#13#10 +
    '    JOIN EQUIPAMENTOS EQP USING (IN_EQUIPAMENTOS_ID)'#13#10 +
    '   WHERE SIT.TI_SITUACOES_ID IN (%s)'#13#10 +
    '     AND ITE.EN_VOLTAGEM IN (%s)'#13#10 +
    '     AND OBR.DT_DATAEHORADACRIACAO BETWEEN %s AND %s'#13#10 +
    'GROUP BY SITUACAO, VOLTAGEM, MODELO'#13#10 +
    'ORDER BY SITUACAO, VOLTAGEM, MODELO';

    SQL_POR_PREVISAO_DE_ENTREGA =
    '  SELECT OBR.TI_MESPROVAVELDEENTREGA'#13#10 +
    '       , OBR.YR_ANOPROVAVELDEENTREGA'#13#10 +
    '       , EQP.IN_EQUIPAMENTOS_ID'#13#10 +
    '       , EQP.VA_MODELO AS EQUIPAMENTO'#13#10 +
    '       , ITE.EN_VOLTAGEM AS VOLTAGEM'#13#10 +
    '       , SUM(ITE.SM_QUANTIDADE) AS QUANTIDADE'#13#10 +
    '       , CONCAT (ELT(OBR.TI_MESPROVAVELDEENTREGA,''Janeiro'',''Fevereiro'',''Março'',''Abril'',''Maio'',''Junho'',''Julho'',''Agosto'',''Setembro'',''Outubro'',''Novembro'',''Dezembro''),'' / '',OBR.YR_ANOPROVAVELDEENTREGA) AS MESANO'#13#10 +
    '    FROM EQUIPAMENTOSDOSITENS EDI'#13#10 +
    '    JOIN EQUIPAMENTOS EQP USING (IN_EQUIPAMENTOS_ID)'#13#10 +
    '    JOIN ITENS ITE USING (IN_ITENS_ID)'#13#10 +
    '    JOIN PROPOSTAS PRO USING (IN_PROPOSTAS_ID)'#13#10 +
    '    JOIN OBRAS OBR USING (IN_OBRAS_ID)'#13#10 +
    '   WHERE TRUE'#13#10 +
    '    :FILTRAR_TI_MESPROVAVELDEENTREGA:AND OBR.TI_MESPROVAVELDEENTREGA = :TI_MESPROVAVELDEENTREGA:'#13#10 + //OU TODOS ( RETIRA )
    '    :FILTRAR_YR_ANOPROVAVELDEENTREGA:AND OBR.YR_ANOPROVAVELDEENTREGA = :YR_ANOPROVAVELDEENTREGA:'#13#10 + //OU TODOS ( RETIRA )
    '     AND ITE.EN_VOLTAGEM IN (:EN_VOLTAGEM:)'#13#10 +
    '     AND OBR.TI_SITUACOES_ID IN (:TI_SITUACOES_ID:)'#13#10 +
    'GROUP BY OBR.TI_MESPROVAVELDEENTREGA, OBR.YR_ANOPROVAVELDEENTREGA, EQP.IN_EQUIPAMENTOS_ID, ITE.EN_VOLTAGEM'#13#10 +
    'ORDER BY OBR.YR_ANOPROVAVELDEENTREGA, OBR.TI_MESPROVAVELDEENTREGA, EQP.VA_MODELO, ITE.EN_VOLTAGEM';

    
{ TBDODataModule_Relatorio_EQP }

procedure TBDODataModule_Relatorio_EQP.ExibirInformacoesDoEquipamento(const aMes, aAno, aEquipamento, aVoltagem: Cardinal);
begin
    inherited; { Mesmo método na classe pai com os mesmos parâmetros passados }
end;

procedure TBDODataModule_Relatorio_EQP.GerarRelatorio;
begin
    ClearHTML;
    SaveTextFile(GerarRelatorioDeEquipamento,ArquivoTemporario);
    inherited;
end;
{$WARNINGS OFF}
function TBDODataModule_Relatorio_EQP.GerarRelatorioDeEquipamento: String;
    function MountSituationsString: ShortString;
    var
        i: Word;
    begin
    	Result := '';
        if MyModule.CheckListBox_Opcoes.Count > 0 then
        begin
	        for i := 0 to Pred(MyModule.CheckListBox_Opcoes.Count) do
            	if MyModule.CheckListBox_Opcoes.Checked[i] then
                begin
                	Result := Result + IntToStr(Integer(MyModule.CheckListBox_Opcoes.Items.Objects[i])) + ',';
                end;
            Delete(Result,Length(Result),1);
        end;
    end;

    function MountVoltagesString: ShortString;
    var
        i: Word;
    begin
    	Result := '';
        if MyModule.CheckListBox_Voltagens.Count > 0 then
        begin
	        for i := 0 to Pred(MyModule.CheckListBox_Voltagens.Count) do
            	if MyModule.CheckListBox_Voltagens.Checked[i] then
                begin
                	Result := Result + QuotedStr(MyModule.CheckListBox_Voltagens.Items[i]) + ',';
                end;
            Delete(Result,Length(Result),1);
        end;
    end;

    function HasCheckedOption(const aCheckListBox: TCheckListBox): Boolean;
    var
        i: Word;
    begin
    	Result := False;
        if aCheckListBox.Count > 0 then
	        for i := 0 to Pred(aCheckListBox.Count) do
            	if aCheckListBox.Checked[i] then
                begin
                	Result := True;
                    Break;
                end;
    end;

var
	RODataSet: TZReadOnlyQuery;
    QuantidadeTotal, QuantidadePorVoltagem, QuantidadePorSituacao, LineNumber,
    QuantidadePorMesAno: Cardinal;
    i: Word;
    CabecalhoSituacao, CabecalhoVoltagem, CabecalhoEquipamento, LinhaEquipamento,
    LinhaSumarioParcial, LinhaSeparadoraSumarioParcialTotal, LinhaSumarioParcialTotal,
    LinhaSumarioTotal, LinhaSeparadora, ConteudoDaListagem, SumarioParcialDaVez,
    SumarioParcialTotalDaVez, CabecalhoEquipamentoDaVez, EquipamentoDaVez,
    CabecalhoMesAno, SQL: String;
    Periodo, SituacoesMarcadas, VoltagensMarcadas, SituacaoAtual, VoltagemAtual,
    MesAnoAtual: ShortString;
    DataFinal, DataInicial: TDateTime;
    MesProvavelDeEntrega, AnoProvavelDeEntrega: Char;
begin
    inherited;

    Result := LoadTextFile(Configurations.CurrentDir + '\reporttemplates\EQUIPAMENTOS\principal.template.html');

    DataInicial := StartOfAYear(YearOf(Now));
    DataFinal := EndOfTheDay(Now);

    if (not MyModule.RadioButton_PorPrevisaoDeEntrega.Checked) and (MyModule.CheckBox_DA_DATADEENTRADA1.Checked or MyModule.CheckBox_DA_DATADEENTRADA2.Checked) then
    begin
        if MyModule.CheckBox_DA_DATADEENTRADA1.Checked then
	        DataInicial := MyModule.DateTimePicker_DA_DATADEENTRADA1.DateTime;

        if MyModule.CheckBox_DA_DATADEENTRADA2.Checked then
	        DataFinal := MyModule.DateTimePicker_DA_DATADEENTRADA2.DateTime;

        if DataInicial > DataFinal then
            raise Exception.Create('A data de entrada final é menor que a data de entrada inicial. Por favor corrija as datas.');
    end;

  	SituacoesMarcadas := '0';
    if HasCheckedOption(MyModule.CheckListBox_Opcoes) then
        SituacoesMarcadas := MountSituationsString;

    VoltagensMarcadas := '0';
    if HasCheckedOption(MyModule.CheckListBox_Voltagens) then
        VoltagensMarcadas := MountVoltagesString;

    Periodo := '';
    if (not MyModule.RadioButton_PorPrevisaoDeEntrega.Checked) and MyModule.CheckBox_ExibirPeriodo.Checked then
    	Periodo := '(no período de ' + FormatDateTime('dd/mm/yyyy',DataInicial) + ' a ' + FormatDateTime('dd/mm/yyyy',DataFinal) + ')';

    Result := StringReplace(Result,'[%]PERIODO[%]',Periodo,[]);

    Result := StringReplace(Result,'[%]PRIMEIRORODAPE[%]',rs_primeirorodape_relatorio,[]);
    Result := StringReplace(Result,'[%]SEGUNDORODAPE[%]',rs_segundorodape_relatorio,[]);

    try
        if MyModule.RadioButton_LisagemPorSituacao.Checked then
        begin
            Result := StringReplace(Result,'[%]CRITERIO[%]','situação',[rfReplaceAll]);

            { Carregando cada um dos templates que serão usados }

            CabecalhoSituacao := LoadTextFile(Configurations.CurrentDir + '\reporttemplates\EQUIPAMENTOS\X_SITUACOES\cabecalhosituacao.template.html');
            CabecalhoVoltagem := LoadTextFile(Configurations.CurrentDir + '\reporttemplates\EQUIPAMENTOS\X_SITUACOES\cabecalhovoltagem.template.html');
            CabecalhoEquipamento := LoadTextFile(Configurations.CurrentDir + '\reporttemplates\EQUIPAMENTOS\X_SITUACOES\cabecalhoequipamento.template.html');
            LinhaEquipamento := LoadTextFile(Configurations.CurrentDir + '\reporttemplates\EQUIPAMENTOS\X_SITUACOES\linhaequipamento.template.html');
            LinhaSumarioParcial := LoadTextFile(Configurations.CurrentDir + '\reporttemplates\EQUIPAMENTOS\X_SITUACOES\linhasumarioparcial.template.html');
            LinhaSeparadoraSumarioParcialTotal := LoadTextFile(Configurations.CurrentDir + '\reporttemplates\EQUIPAMENTOS\X_SITUACOES\linhaseparadorasumarioparcialtotal.template.html');
            LinhaSumarioParcialTotal := LoadTextFile(Configurations.CurrentDir + '\reporttemplates\EQUIPAMENTOS\X_SITUACOES\linhasumarioparcialtotal.template.html');
            LinhaSeparadora := LoadTextFile(Configurations.CurrentDir + '\reporttemplates\EQUIPAMENTOS\X_SITUACOES\linhaseparadora.template.html');
            LinhaSumarioTotal := LoadTextFile(Configurations.CurrentDir + '\reporttemplates\EQUIPAMENTOS\X_SITUACOES\linhasumariototal.template.html');

            RODataSet := nil;

            ConfigureDataSet(DataModuleMain.ZConnections.ByName['ZConnection_BDO'].Connection
                            ,RODataSet
                            ,MySQLFormat(SQL_POR_SITUACAO
                                   ,[SituacoesMarcadas
                                    ,VoltagensMarcadas
                                    ,FormatDateTime('yyyymmddhhnnss',DataInicial)
                                    ,FormatDateTime('yyyymmddhhnnss',DataFinal)]));

            SituacaoAtual := '';
            VoltagemAtual := '';
            ConteudoDaListagem := '';
            QuantidadeTotal := 0;
            QuantidadePorVoltagem := 0;
            QuantidadePorSituacao := 0;
            LineNumber := 0;

            MyModule.ProgressBar_GeracaoDeRelatorio.Position := 0;
            MyModule.ProgressBar_GeracaoDeRelatorio.Step := 1;
            MyModule.ProgressBar_GeracaoDeRelatorio.Max := RODataSet.RecordCount;
            MyModule.ProgressBar_GeracaoDeRelatorio.Show;

            RODataSet.First;
            while not RODataSet.Eof do
            begin
                if RODataSet.FieldByName('SITUACAO').AsString <> SituacaoAtual then
                begin
                    if MyModule.CheckBox_ExibirQuantidadesTotaisParciais.Checked and (QuantidadePorVoltagem > 0) then
                    begin
                        SumarioParcialDaVez := StringReplace(LinhaSumarioParcial,'[%]VOLTAGEM[%]',VoltagemAtual,[]);
                        SumarioParcialDaVez := StringReplace(SumarioParcialDaVez,'[%]QUANTIDADE[%]',IntToStr(QuantidadePorVoltagem),[]);
                        ConteudoDaListagem := ConteudoDaListagem + SumarioParcialDaVez;
                    end;


                    if MyModule.CheckBox_ExibirQuantidadesTotaisPorSituacao.Checked and (QuantidadePorSituacao > 0) then
                    begin
                        SumarioParcialTotalDaVez := StringReplace(LinhaSumarioParcialTotal,'[%]QUANTIDADE[%]',IntToStr(QuantidadePorSituacao),[]);
                        SumarioParcialTotalDaVez := StringReplace(SumarioParcialTotalDaVez,'[%]SITUACAO[%]',SituacaoAtual,[]);
                        ConteudoDaListagem := ConteudoDaListagem + LinhaSeparadoraSumarioParcialTotal + SumarioParcialTotalDaVez;
                    end;

                    if RODataSet.RecNo <> 1 then
                        ConteudoDaListagem := ConteudoDaListagem + LinhaSeparadora;

                    VoltagemAtual := '';
                    SituacaoAtual := RODataSet.FieldByName('SITUACAO').AsString;

                    ConteudoDaListagem := ConteudoDaListagem + StringReplace(CabecalhoSituacao,'[%]SITUACAO[%]',SituacaoAtual,[]);

                    QuantidadePorSituacao := 0;
                    QuantidadePorVoltagem := 0;
                end;

                if RODataSet.FieldByName('VOLTAGEM').AsString <> VoltagemAtual then
                begin
                    LineNumber := 0;

                    if MyModule.CheckBox_ExibirQuantidadesTotaisParciais.Checked and (QuantidadePorVoltagem > 0) then
                    begin
                        SumarioParcialDaVez := StringReplace(LinhaSumarioParcial,'[%]VOLTAGEM[%]',VoltagemAtual,[]);
                        SumarioParcialDaVez := StringReplace(SumarioParcialDaVez,'[%]QUANTIDADE[%]',IntToStr(QuantidadePorVoltagem),[]);
                        ConteudoDaListagem := ConteudoDaListagem + SumarioParcialDaVez;
                    end;

                    VoltagemAtual := RODataSet.FieldByName('VOLTAGEM').AsString;

                    ConteudoDaListagem := ConteudoDaListagem + StringReplace(CabecalhoVoltagem,'[%]VOLTAGEM[%]',VoltagemAtual,[]);

                    CabecalhoEquipamentoDaVez := CabecalhoEquipamento;

                    if MyModule.CheckBox_ExibirQuantidadesParciais.Checked then
                    begin
                        CabecalhoEquipamentoDaVez := StringReplace(CabecalhoEquipamentoDaVez,'[%]COLSPAN[%]','',[]);
                        CabecalhoEquipamentoDaVez := StringReplace(CabecalhoEquipamentoDaVez,'[%]MOSTRAR1[%]','',[]);
                        CabecalhoEquipamentoDaVez := StringReplace(CabecalhoEquipamentoDaVez,'[%]MOSTRAR2[%]','',[]);
                    end
                    else
                    begin
                        CabecalhoEquipamentoDaVez := StringReplace(CabecalhoEquipamentoDaVez,'[%]COLSPAN[%]','COLSPAN="2"',[]);
                        CabecalhoEquipamentoDaVez := StringReplace(CabecalhoEquipamentoDaVez,'[%]MOSTRAR1[%]',HTML_COMMENT_I,[]);
                        CabecalhoEquipamentoDaVez := StringReplace(CabecalhoEquipamentoDaVez,'[%]MOSTRAR2[%]',HTML_COMMENT_F,[]);
                    end;

                    ConteudoDaListagem := ConteudoDaListagem + CabecalhoEquipamentoDaVez;

                    QuantidadePorVoltagem := 0;
                end;

                if Odd(LineNumber) then
                    EquipamentoDaVez := StringReplace(LinhaEquipamento,'[%]LINHADECOR[%]','CLASS="linhacor"',[])
                else
                    EquipamentoDaVez := StringReplace(LinhaEquipamento,'[%]LINHADECOR[%]','',[]);

                if MyModule.CheckBox_ExibirQuantidadesParciais.Checked then
                begin
                    EquipamentoDaVez := StringReplace(EquipamentoDaVez,'[%]COLSPAN[%]','',[]);
                    EquipamentoDaVez := StringReplace(EquipamentoDaVez,'[%]MOSTRAR1[%]','',[]);
                    EquipamentoDaVez := StringReplace(EquipamentoDaVez,'[%]MOSTRAR2[%]','',[]);
                    EquipamentoDaVez := StringReplace(EquipamentoDaVez,'[%]QUANTIDADE[%]',RODataSet.FieldByName('QUANTIDADE').AsString,[]);
                end
                else
                begin
                    EquipamentoDaVez := StringReplace(EquipamentoDaVez,'[%]COLSPAN[%]','COLSPAN="2"',[]);
                    EquipamentoDaVez := StringReplace(EquipamentoDaVez,'[%]MOSTRAR1[%]',HTML_COMMENT_I,[]);
                    EquipamentoDaVez := StringReplace(EquipamentoDaVez,'[%]MOSTRAR2[%]',HTML_COMMENT_F,[]);
                end;

                EquipamentoDaVez := StringReplace(EquipamentoDaVez,'[%]EQUIPAMENTO[%]',RODataSet.FieldByName('MODELO').AsString,[]);

                ConteudoDaListagem := ConteudoDaListagem + EquipamentoDaVez;

                Inc(LineNumber);
                Inc(QuantidadePorVoltagem,RODataSet.FieldByName('QUANTIDADE').AsInteger);

                if MyModule.CheckBox_ExibirQuantidadesTotaisPorSituacao.Checked then
                    Inc(QuantidadePorSituacao,RODataSet.FieldByName('QUANTIDADE').AsInteger);

                if MyModule.CheckBox_ExibirTotalGeral.Checked then
                    Inc(QuantidadeTotal,RODataSet.FieldByName('QUANTIDADE').AsInteger);

                MyModule.ProgressBar_GeracaoDeRelatorio.StepIt;
                RODataSet.Next;
            end;

            { Isso é necessário para se colocar os sumários no fim de tudo }
            if MyModule.CheckBox_ExibirQuantidadesTotaisParciais.Checked and (QuantidadePorVoltagem > 0) then
            begin
                SumarioParcialDaVez := StringReplace(LinhaSumarioParcial,'[%]VOLTAGEM[%]',VoltagemAtual,[]);
                SumarioParcialDaVez := StringReplace(SumarioParcialDaVez,'[%]QUANTIDADE[%]',IntToStr(QuantidadePorVoltagem),[]);
                ConteudoDaListagem := ConteudoDaListagem + SumarioParcialDaVez;
            end;

            if MyModule.CheckBox_ExibirQuantidadesTotaisPorSituacao.Checked and (QuantidadePorSituacao > 0) then
            begin
                SumarioParcialTotalDaVez := StringReplace(LinhaSumarioParcialTotal,'[%]QUANTIDADE[%]',IntToStr(QuantidadePorSituacao),[]);
                SumarioParcialTotalDaVez := StringReplace(SumarioParcialTotalDaVez,'[%]SITUACAO[%]',SituacaoAtual,[]);
                ConteudoDaListagem := ConteudoDaListagem + LinhaSeparadoraSumarioParcialTotal + SumarioParcialTotalDaVez;
            end;

            if MyModule.CheckBox_ExibirTotalGeral.Checked then
                ConteudoDaListagem := ConteudoDaListagem + LinhaSeparadoraSumarioParcialTotal + StringReplace(LinhaSumarioTotal,'[%]QUANTIDADE[%]',IntToStr(QuantidadeTotal),[]);

            Result := StringReplace(Result,'[%]CONTEUDODALISTAGEM[%]',ConteudoDaListagem,[]);
            Result := StringReplace(Result,'[%]COLS[%]','COLS="2"',[]);

    //        Result := Result + 'OBS.: SITUAÇÕES OU VOLTAGENS NÃO APRESENTADAS SIGNIFICAM QUE NÃO HÁ EQUIPAMENTO NA SITUAÇÃO E/OU VOLTAGEM SEGUNDO SEUS CRITÉRIOS DE FILTRAGEM<BR>'#13#10;


        end
        else if MyModule.RadioButton_PorPrevisaoDeEntrega.Checked then
        begin
            Result := StringReplace(Result,'[%]CRITERIO[%]','PREVISÃO DE ENTREGA (MÊS / ANO)',[rfReplaceAll]);

            { Carregando cada um dos templates que serão usados }
            CabecalhoMesAno := LoadTextFile(Configurations.CurrentDir + '\reporttemplates\EQUIPAMENTOS\X_PREVISAODEENTREGA\cabecalhomesano.template.html');
            CabecalhoEquipamento := LoadTextFile(Configurations.CurrentDir + '\reporttemplates\EQUIPAMENTOS\X_PREVISAODEENTREGA\cabecalhoequipamento.template.html');
            LinhaEquipamento := LoadTextFile(Configurations.CurrentDir + '\reporttemplates\EQUIPAMENTOS\X_PREVISAODEENTREGA\linhaequipamento.template.html');
            LinhaSumarioParcialTotal := LoadTextFile(Configurations.CurrentDir + '\reporttemplates\EQUIPAMENTOS\X_PREVISAODEENTREGA\linhasumarioparcialtotal.template.html');
            LinhaSeparadoraSumarioParcialTotal := LoadTextFile(Configurations.CurrentDir + '\reporttemplates\EQUIPAMENTOS\X_PREVISAODEENTREGA\linhaseparadorasumarioparcialtotal.template.html');
            LinhaSeparadora := LoadTextFile(Configurations.CurrentDir + '\reporttemplates\EQUIPAMENTOS\X_PREVISAODEENTREGA\linhaseparadora.template.html');
            LinhaSumarioTotal := LoadTextFile(Configurations.CurrentDir + '\reporttemplates\EQUIPAMENTOS\X_PREVISAODEENTREGA\linhasumariototal.template.html');

            RODataSet := nil;

            SQL := SQL_POR_PREVISAO_DE_ENTREGA;
            
            AnoProvavelDeEntrega := '#';
            if MyModule.CheckBox_DA_DATADEENTRADA1.Checked then
            begin
                AnoProvavelDeEntrega := ' ';
                SQL := StringReplace(SQL,':YR_ANOPROVAVELDEENTREGA:',MyModule.ComboBox_Ano.Text,[rfReplaceAll]);
            end;

            MesProvavelDeEntrega := '#';
            if MyModule.CheckBox_DA_DATADEENTRADA2.Checked then
            begin
                MesProvavelDeEntrega := ' ';
                SQL := StringReplace(SQL,':TI_MESPROVAVELDEENTREGA:',IntToStr(Succ(MyModule.ComboBox_Mes.ItemIndex)),[rfReplaceAll]);
            end;

            SQL := StringReplace(SQL,':FILTRAR_TI_MESPROVAVELDEENTREGA:',MesProvavelDeEntrega,[rfReplaceAll]);
            SQL := StringReplace(SQL,':FILTRAR_YR_ANOPROVAVELDEENTREGA:',AnoProvavelDeEntrega,[rfReplaceAll]);
            SQL := StringReplace(SQL,':EN_VOLTAGEM:',VoltagensMarcadas,[rfReplaceAll]);
            SQL := StringReplace(SQL,':TI_SITUACOES_ID:',SituacoesMarcadas,[rfReplaceAll]);

            ConfigureDataSet(DataModuleMain.ZConnections.ByName['ZConnection_BDO'].Connection
                            ,RODataSet
                            ,SQL);

            MesAnoAtual := '';
            ConteudoDaListagem := '';
            QuantidadeTotal := 0;
            QuantidadePorMesAno := 0;
            LineNumber := 0;

            MyModule.ProgressBar_GeracaoDeRelatorio.Position := 0;
            MyModule.ProgressBar_GeracaoDeRelatorio.Step := 1;
            MyModule.ProgressBar_GeracaoDeRelatorio.Max := RODataSet.RecordCount;
            MyModule.ProgressBar_GeracaoDeRelatorio.Show;

            RODataSet.First;
            while not RODataSet.Eof do
            begin
                if RODataSet.FieldByName('MESANO').AsString <> MesAnoAtual then
                begin
                    if MyModule.CheckBox_ExibirQuantidadesTotaisParciais.Checked and (QuantidadePorMesAno > 0) then              
                    begin
                        SumarioParcialTotalDaVez := StringReplace(LinhaSumarioParcialTotal,'[%]QUANTIDADE[%]',IntToStr(QuantidadePorMesAno),[]);
                        SumarioParcialTotalDaVez := StringReplace(SumarioParcialTotalDaVez,'[%]MESANO[%]',AnsiUpperCase(MesAnoAtual),[]);
                        ConteudoDaListagem := ConteudoDaListagem + LinhaSeparadoraSumarioParcialTotal + SumarioParcialTotalDaVez;
                    end;

                    if RODataSet.RecNo <> 1 then
                        ConteudoDaListagem := ConteudoDaListagem + LinhaSeparadora;

                    MesAnoAtual := RODataSet.FieldByName('MESANO').AsString;

                    ConteudoDaListagem := ConteudoDaListagem + StringReplace(CabecalhoMesAno,'[%]MESANO[%]',MesAnoAtual,[]);

                    ConteudoDaListagem := ConteudoDaListagem + CabecalhoEquipamento;

                    QuantidadePorMesAno := 0;
                    LineNumber := 0;
                end;

                if Odd(LineNumber) then
                    EquipamentoDaVez := StringReplace(LinhaEquipamento,'[%]LINHADECOR[%]','CLASS="linhacor"',[])
                else
                    EquipamentoDaVez := StringReplace(LinhaEquipamento,'[%]LINHADECOR[%]','',[]);

                { Parte que monta o link }
                EquipamentoDaVez := StringReplace(EquipamentoDaVez,'[%]TI_MESPROVAVELDEENTREGA[%]',RODataSet.FieldByName('TI_MESPROVAVELDEENTREGA').AsString,[]);
                EquipamentoDaVez := StringReplace(EquipamentoDaVez,'[%]YR_ANOPROVAVELDEENTREGA[%]',RODataSet.FieldByName('YR_ANOPROVAVELDEENTREGA').AsString,[]);
                EquipamentoDaVez := StringReplace(EquipamentoDaVez,'[%]IN_EQUIPAMENTOS_ID[%]',RODataSet.FieldByName('IN_EQUIPAMENTOS_ID').AsString,[]);

                for i := 1 to High(VOLTAGENS) do
                    if RODataSet.FieldByName('VOLTAGEM').AsString = VOLTAGENS[i] then
                    begin
                        EquipamentoDaVez := StringReplace(EquipamentoDaVez,'[%]VOLTAGEM[%]',IntToStr(i),[]);
                        Break;
                    end;

                { Substituições restantes }
                EquipamentoDaVez := StringReplace(EquipamentoDaVez,'[%]QUANTIDADE[%]',RODataSet.FieldByName('QUANTIDADE').AsString,[]);
                EquipamentoDaVez := StringReplace(EquipamentoDaVez,'[%]EQUIPAMENTO[%]',RODataSet.FieldByName('EQUIPAMENTO').AsString,[]);
                EquipamentoDaVez := StringReplace(EquipamentoDaVez,'[%]VOLTAGEM[%]',RODataSet.FieldByName('VOLTAGEM').AsString,[]);

                ConteudoDaListagem := ConteudoDaListagem + EquipamentoDaVez;

                Inc(LineNumber);

                Inc(QuantidadePorMesAno,RODataSet.FieldByName('QUANTIDADE').AsInteger);

                if MyModule.CheckBox_ExibirTotalGeral.Checked then
                    Inc(QuantidadeTotal,RODataSet.FieldByName('QUANTIDADE').AsInteger);

                MyModule.ProgressBar_GeracaoDeRelatorio.StepIt;
                RODataSet.Next;
            end;

            { Isso é necessário para se colocar os sumários no fim de tudo }
            if MyModule.CheckBox_ExibirQuantidadesTotaisParciais.Checked and (QuantidadePorMesAno > 0) then
            begin
                SumarioParcialTotalDaVez := StringReplace(LinhaSumarioParcialTotal,'[%]QUANTIDADE[%]',IntToStr(QuantidadePorMesAno),[]);
                SumarioParcialTotalDaVez := StringReplace(SumarioParcialTotalDaVez,'[%]MESANO[%]',AnsiUpperCase(MesAnoAtual),[]);
                ConteudoDaListagem := ConteudoDaListagem + LinhaSeparadoraSumarioParcialTotal + SumarioParcialTotalDaVez;
            end;

            if MyModule.CheckBox_ExibirTotalGeral.Checked then
                ConteudoDaListagem := ConteudoDaListagem + LinhaSeparadoraSumarioParcialTotal + StringReplace(LinhaSumarioTotal,'[%]QUANTIDADE[%]',IntToStr(QuantidadeTotal),[]);

            Result := StringReplace(Result,'[%]CONTEUDODALISTAGEM[%]',ConteudoDaListagem,[]);
            { TODO -oCarlos Feitoza -cEXPLICAÇÃO : Na porcaria do internet explorer é preciso informar a quantidade de colunas máximas para que ao se usar colspan não dê problemas }
            Result := StringReplace(Result,'[%]COLS[%]','COLS="3"',[]);
        end;


    finally
        if Assigned(RODataSet) then
            RODataSet.Free;

        MyModule.ProgressBar_GeracaoDeRelatorio.Hide;
    end;
end;{$WARNINGS ON}

function TBDODataModule_Relatorio_EQP.MyModule: TBDOForm_Relatorio_EQP;
begin
    Result := TBDOForm_Relatorio_EQP(Owner);
end;

end.
