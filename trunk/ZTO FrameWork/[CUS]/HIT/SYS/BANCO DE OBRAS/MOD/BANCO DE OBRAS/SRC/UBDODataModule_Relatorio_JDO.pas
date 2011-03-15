unit UBDODataModule_Relatorio_JDO;

interface

uses
    Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
    Dialogs, UBDODataModule_GeradorDeRelatorio, ImgList, ActnList, UBDOForm_Relatorio_JDO;

type
    TBDODataModule_Relatorio_JDO = class(TBDODataModule_GeradorDeRelatorio)
    private
        { Private declarations }
        function MyModule: TBDOForm_Relatorio_JDO;
        function GerarRelatorioDeJustificativasDasObras: String;
    public
        { Public declarations }
        procedure GerarRelatorio; override;
    end;

implementation

uses
    ZDataset, UXXXDataModule, StdCtrls, DateUtils, StrUtils;

{$R *.dfm}

const
	SQL_REGIOES =
    '  SELECT REG.TI_REGIOES_ID'#13#10 +
    '       , REG.VA_REGIAO'#13#10 +
    '    FROM REGIOES REG'#13#10 +
    '    JOIN REGIOESDOSUSUARIOS RDU USING (TI_REGIOES_ID)'#13#10 +
    '   WHERE RDU.SM_USUARIOS_ID = %d'#13#10 +
    '%s' +
    'ORDER BY REG.VA_REGIAO';

	SQL_FAMILIAS =
    '  SELECT TI_FAMILIAS_ID'#13#10 +
    '       , VA_DESCRICAO'#13#10 +
    '    FROM FAMILIAS'#13#10 +
    '%s' +
    'ORDER BY VA_DESCRICAO';

    SQL_INSTALADORES =
    '  SELECT SM_INSTALADORES_ID'#13#10 +
    '       , VA_NOME'#13#10 +
    '    FROM INSTALADORES'#13#10 +
    '%s' +
    'ORDER BY VA_NOME';

    // SUMARIO (TODAS AS OBRAS COM JUSTIFICATIVA)
    SQL_SUMARIO =
    'SELECT (SELECT COUNT(iJDO.IN_OBRAS_ID)'#13#10 +
    '          FROM JUSTIFICATIVASDASOBRAS iJDO'#13#10 +
    '          JOIN OBRAS iOBR USING (IN_OBRAS_ID)'#13#10 +
    '         WHERE iJDO.TI_JUSTIFICATIVAS_ID = JUS.TI_JUSTIFICATIVAS_ID'#13#10 +
    '           AND iOBR.DT_DATAEHORADACRIACAO BETWEEN %s AND %s ) AS QTDOBRAS'#13#10 +
    '     , JUS.EN_CATEGORIA'#13#10 +
    '     , JUS.VA_JUSTIFICATIVA'#13#10 +
    '  FROM JUSTIFICATIVAS JUS';

    // POR CRITÉRIO (USANDO CRITÉRIOS ESPECÍFICOS)
    SQL_POR_CRITERIO =
    'SELECT (SELECT COUNT(JDO.IN_OBRAS_ID)'#13#10 +
    '          FROM JUSTIFICATIVASDASOBRAS JDO'#13#10 +
    '         WHERE JDO.TI_JUSTIFICATIVAS_ID = JUS.TI_JUSTIFICATIVAS_ID'#13#10 +
    '           AND JDO.IN_OBRAS_ID IN (%s)) AS QTDOBRAS'#13#10 +
    '     , JUS.EN_CATEGORIA'#13#10 +
    '     , JUS.VA_JUSTIFICATIVA'#13#10 +
    '  FROM JUSTIFICATIVAS JUS';

    // TODAS AS OBRAS DA FAMILIA ESPECIFICADA
    SQL_POR_FAMILIA =
    '  SELECT iOBR.IN_OBRAS_ID'#13#10 +
    '    FROM ITENS iITE'#13#10 +
    '    JOIN PROPOSTAS iPRO USING (IN_PROPOSTAS_ID)'#13#10 +
    '    JOIN OBRAS iOBR USING (IN_OBRAS_ID)'#13#10 +
    '    JOIN SITUACOES iSIT USING (TI_SITUACOES_ID)'#13#10 +
    '   WHERE iSIT.BO_JUSTIFICAVEL'#13#10 +
    '     AND iITE.TI_FAMILIAS_ID = %u'#13#10 +
    '     AND iOBR.DT_DATAEHORADACRIACAO BETWEEN %s AND %s'#13#10 +
    'GROUP BY 1';

    // TODAS AS OBRAS DA REGIAO ESPECIFICADA
    SQL_POR_REGIAO =
    '  SELECT iOBR.IN_OBRAS_ID'#13#10 +
    '    FROM OBRAS iOBR'#13#10 +
    '    JOIN SITUACOES iSIT USING (TI_SITUACOES_ID)'#13#10 +
    '   WHERE iSIT.BO_JUSTIFICAVEL'#13#10 +
    '     AND iOBR.TI_REGIOES_ID = %u'#13#10 +
    '     AND iOBR.DT_DATAEHORADACRIACAO BETWEEN %s AND %s';

    // TODAS AS OBRAS DO INSTALADOR ESPECIFICADO
    SQL_POR_INSTALADOR =
    '  SELECT iOBR.IN_OBRAS_ID'#13#10 +
    '    FROM PROPOSTAS iPRO'#13#10 +
    '    JOIN OBRAS iOBR USING (IN_OBRAS_ID)'#13#10 +
    '    JOIN SITUACOES iSIT USING (TI_SITUACOES_ID)'#13#10 +
    '   WHERE iSIT.BO_JUSTIFICAVEL'#13#10 +
    '     AND iPRO.SM_INSTALADORES_ID = %u'#13#10 +
    '     AND iOBR.DT_DATAEHORADACRIACAO BETWEEN %s AND %s'#13#10 +
    'GROUP BY 1';

resourcestring
    RS_PRIMEIRORODAPE_RELATORIO = 'HITACHI AR CONDICIONADO DO BRASIL LTDA.';
    RS_SEGUNDORODAPE_RELATORIO = 'http://www.hitachiapb.com.br';


{ TBDODataModule_Relatorio_JDO }

procedure TBDODataModule_Relatorio_JDO.GerarRelatorio;
begin
    ClearHTML;
    SaveTextFile(GerarRelatorioDeJustificativasDasObras,ArquivoTemporario);
    inherited;
end;

function TBDODataModule_Relatorio_JDO.GerarRelatorioDeJustificativasDasObras: String;
var
    SQLItemDoCriterio, TemplateItemDeListagem, TemplateItem, TemplateSumarioGeral,
    Itens, ItensDeListagem, SumarioGeral: String;
    RODataSetCriterio, RODataSetItemDoCriterio: TZReadOnlyQuery;
    OpcaoDeListagem: ShortString;
    SomatorioComercialCriterio, SomatorioComercialGeral: Cardinal;
    SomatorioTecnicoCriterio, SomatorioTecnicoGeral: Cardinal;
    DataInicial, DataFinal: TDateTime;

    procedure IncrementaSomatorio(const aGeral: Boolean; const aCategoria: Char = #0; const aQuantidade: Cardinal = 0);
    begin
        if aGeral then
        begin
            Inc(SomatorioComercialGeral,SomatorioComercialCriterio);
            Inc(SomatorioTecnicoGeral,SomatorioTecnicoCriterio);
        end
        else
            case aCategoria of
                'C': Inc(SomatorioComercialCriterio,aQuantidade);
                'T': Inc(SomatorioTecnicoCriterio,aQuantidade);
            end;
    end;

    function DecodificarCategoria(const aCategoria: Char): ShortString;
    begin
        Result := 'N/A';
        case aCategoria of
            'C': Result := 'COMERCIAL';
            'T': Result := 'TÉCNICA';
        end;
    end;
begin
    Result := LoadTextFile(Configurations.CurrentDir + '\reporttemplates\JUSTIFICATIVASDASOBRAS\principal.template.html');
    TemplateItem := LoadTextFile(Configurations.CurrentDir + '\reporttemplates\JUSTIFICATIVASDASOBRAS\item.template.html');
    TemplateItemDeListagem := LoadTextFile(Configurations.CurrentDir + '\reporttemplates\JUSTIFICATIVASDASOBRAS\itemdelistagem.template.html');
    TemplateSumarioGeral := LoadTextFile(Configurations.CurrentDir + '\reporttemplates\JUSTIFICATIVASDASOBRAS\sumariogeral.template.html');

    RODataSetCriterio := nil;
    RODataSetItemDoCriterio := nil;

    DataInicial := StartOfAYear(YearOf(Now));
    DataFinal := EndOfTheDay(Now);

    if MyModule.CheckBox_DT_DATAEHORADACRIACAO1.Checked or MyModule.CheckBox_DT_DATAEHORADACRIACAO2.Checked then
    begin
        if MyModule.CheckBox_DT_DATAEHORADACRIACAO1.Checked then
	        DataInicial := StartOfTheDay(MyModule.DateTimePicker_DT_DATAEHORADACRIACAO1.DateTime);

        if MyModule.CheckBox_DT_DATAEHORADACRIACAO2.Checked then
	        DataFinal := EndOfTheDay(MyModule.DateTimePicker_DT_DATAEHORADACRIACAO2.DateTime);

        if DataInicial > DataFinal then
            raise Exception.Create('A data de entrada final é menor que a data de entrada inicial. Por favor corrija as datas.');
    end;

    if MyModule.CheckBox_ExibirPeriodo.Checked then
        Result := StringReplace(Result,'[%]PERIODO[%]','(no período de ' + FormatDateTime('dd/mm/yyyy',DataInicial) + ' a ' + FormatDateTime('dd/mm/yyyy',DataFinal) + ')',[])
    else
        Result := StringReplace(Result,'[%]PERIODO[%]','',[]);

    Result := StringReplace(Result,'[%]PRIMEIRORODAPE[%]',RS_PRIMEIRORODAPE_RELATORIO,[]);
    Result := StringReplace(Result,'[%]SEGUNDORODAPE[%]',RS_SEGUNDORODAPE_RELATORIO,[]);

    try
        { Apenas um relatório é especial. Os demais seguem uma mesma regra }
        if MyModule.RadioButton_ApenasSumario.Checked then
        begin
            Result := StringReplace(Result,'[%]CRITERIO1[%]','RELATÓRIO DE JUSTIFICATIVAS DAS OBRAS (SUMÁRIO GERAL)',[]);
            Result := StringReplace(Result,'[%]CRITERIO2[%]','RELATÓRIO DE JUSTIFICATIVAS DAS OBRAS (SUMÁRIO GERAL)',[]);

            ConfigureDataSet(DataModuleMain.ZConnections.ByName['ZConnection_BDO'].Connection
                            ,RODataSetCriterio
                            ,MySQLFormat(SQL_SUMARIO
                                        ,[FormatDateTime('yyyymmddhhnnss',DataInicial)
                                         ,FormatDateTime('yyyymmddhhnnss',DataFinal)]));

            SomatorioComercialCriterio := 0;
            SomatorioTecnicoCriterio := 0;

            MyModule.ProgressBar_GeracaoDeRelatorio.Position := 0;
            MyModule.ProgressBar_GeracaoDeRelatorio.Step := 1;
            MyModule.ProgressBar_GeracaoDeRelatorio.Max := RODataSetCriterio.RecordCount;
            MyModule.ProgressBar_GeracaoDeRelatorio.Show;

            Itens := '';
            
            { Circulando por todos os itens do critério }
            while not RODataSetCriterio.Eof do
            begin
                { Adiciona mais um template }
                Itens := Itens + TemplateItem;

                { Substitui o que for substituivel }
                Itens := StringReplace(Itens,'[%]LINHADECOR[%]',IfThen(not Odd(RODataSetCriterio.RecNo),' CLASS="COR"',''),[]);
                Itens := StringReplace(Itens,'[%]CAT[%]',DecodificarCategoria(RODataSetCriterio.Fields[1].AsString[1]),[]);
                Itens := StringReplace(Itens,'[%]JUSTIFICATIVA[%]',RODataSetCriterio.Fields[2].AsString,[]);
                Itens := StringReplace(Itens,'[%]QTD[%]',RODataSetCriterio.Fields[0].AsString,[]);

                { Incrementando o somatório do critério }
                IncrementaSomatorio(False,RODataSetCriterio.Fields[1].AsString[1],RODataSetCriterio.Fields[0].AsInteger);

                MyModule.ProgressBar_GeracaoDeRelatorio.StepIt;
                RODataSetCriterio.Next;
            end;

            { Neste ponto "Itens" contém uma string com cada uma das linhas que
            devem ser colocadas em "TemplateItemDeListagem". Agora é só fazer as
            substituições necessárias em "TemplateItemDeListagem" }

            ItensDeListagem := TemplateItemDeListagem;

            ItensDeListagem := StringReplace(ItensDeListagem,'[%]NAOTEMCRITERIO1[%]','<!--',[]);
            ItensDeListagem := StringReplace(ItensDeListagem,'[%]NAOTEMCRITERIO2[%]','-->',[]);
            ItensDeListagem := StringReplace(ItensDeListagem,'[%]ITEMDALISTAGEM[%]',Itens,[]);

            ItensDeListagem := StringReplace(ItensDeListagem,'[%]NAOTEMSUMARIO1[%]','<!--',[]);
            ItensDeListagem := StringReplace(ItensDeListagem,'[%]NAOTEMSUMARIO2[%]','-->',[]);

            ItensDeListagem := StringReplace(ItensDeListagem,'[%]NAOTEMQTDPARCOM1[%]','<!--',[]);
            ItensDeListagem := StringReplace(ItensDeListagem,'[%]NAOTEMQTDPARCOM2[%]','-->',[]);

            ItensDeListagem := StringReplace(ItensDeListagem,'[%]NAOTEMQTDPARCTEC1[%]','<!--',[]);
            ItensDeListagem := StringReplace(ItensDeListagem,'[%]NAOTEMQTDPARCTEC2[%]','-->',[]);

            ItensDeListagem := StringReplace(ItensDeListagem,'[%]NAOTEMQTDPARCTOT1[%]','<!--',[]);
            ItensDeListagem := StringReplace(ItensDeListagem,'[%]NAOTEMQTDPARCTOT2[%]','-->',[]);

            { Incluindo ou não o sumário geral }
            SumarioGeral := '';
            if MyModule.CheckBox_ExibirSumarioGeral.Checked then
            begin
                SumarioGeral := TemplateSumarioGeral;
                SumarioGeral := StringReplace(SumarioGeral,'[%]QTDTOTCOM[%]',IntToStr(SomatorioComercialCriterio),[]);
                SumarioGeral := StringReplace(SumarioGeral,'[%]QTDTOTTEC[%]',IntToStr(SomatorioTecnicoCriterio),[]);
            end;

            { Realizando as substituições obrigatórias no template principal }
            Result := StringReplace(Result,'[%]LISTAGEM[%]',ItensDeListagem,[]);
            Result := StringReplace(Result,'[%]SUMARIOGERAL[%]',SumarioGeral,[]);
        end
        else
        begin
            { Cria apenas uma vez pois será utilizada a cada ciclo de critério }
            RODataSetItemDoCriterio := TZReadOnlyQuery.Create(nil);

            if MyModule.RadioButton_PorRegiao.Checked then
            begin
                Result := StringReplace(Result,'[%]CRITERIO1[%]','RELATÓRIO DE JUSTIFICATIVAS DAS OBRAS POR "REGIÃO"',[]);
                Result := StringReplace(Result,'[%]CRITERIO2[%]','RELATÓRIO DE JUSTIFICATIVAS DAS OBRAS POR "<I STYLE="TEXT-TRANSFORM: uppercase"><B>REGIÃO</B></I>"',[]);

                SQLItemDoCriterio := MySQLFormat(SQL_POR_CRITERIO,[SQL_POR_REGIAO]);

                OpcaoDeListagem := '';
                if MyModule.ComboBox_OpcaoDeListagem.ItemIndex > 0 then
                    OpcaoDeListagem := '     AND TI_REGIOES_ID = ' + IntToStr(Byte(MyModule.ComboBox_OpcaoDeListagem.Items.Objects[MyModule.ComboBox_OpcaoDeListagem.ItemIndex])) + #13#10;

                ConfigureDataSet(DataModuleMain.ZConnections.ByName['ZConnection_BDO'].Connection
                                ,RODataSetCriterio
                                ,MySQLFormat(SQL_REGIOES
                                            ,[Configurations.AuthenticatedUser.Id
                                             ,OpcaoDeListagem]));
            end
            else if MyModule.RadioButton_PorInstalador.Checked then
            begin
                Result := StringReplace(Result,'[%]CRITERIO1[%]','RELATÓRIO DE JUSTIFICATIVAS DAS OBRAS POR "INSTALADOR"',[]);
                Result := StringReplace(Result,'[%]CRITERIO2[%]','RELATÓRIO DE JUSTIFICATIVAS DAS OBRAS POR "<I STYLE="TEXT-TRANSFORM: uppercase"><B>INSTALADOR</B></I>"',[]);

                SQLItemDoCriterio := MySQLFormat(SQL_POR_CRITERIO,[SQL_POR_INSTALADOR]);

                OpcaoDeListagem := '';
                if MyModule.ComboBox_OpcaoDeListagem.ItemIndex > 0 then
                    OpcaoDeListagem := '   WHERE SM_INSTALADORES_ID = ' + IntToStr(Word(MyModule.ComboBox_OpcaoDeListagem.Items.Objects[MyModule.ComboBox_OpcaoDeListagem.ItemIndex])) + #13#10;

                ConfigureDataSet(DataModuleMain.ZConnections.ByName['ZConnection_BDO'].Connection
                                ,RODataSetCriterio
                                ,MySQLFormat(SQL_INSTALADORES
                                            ,[OpcaoDeListagem]));
            end
            else if MyModule.RadioButton_PorFamilia.Checked then
            begin
                Result := StringReplace(Result,'[%]CRITERIO1[%]','RELATÓRIO DE JUSTIFICATIVAS DAS OBRAS POR "FAMÍLIA"',[]);
                Result := StringReplace(Result,'[%]CRITERIO2[%]','RELATÓRIO DE JUSTIFICATIVAS DAS OBRAS POR "<I STYLE="TEXT-TRANSFORM: uppercase"><B>FAMÍLIA</B></I>"',[]);

                SQLItemDoCriterio := MySQLFormat(SQL_POR_CRITERIO,[SQL_POR_FAMILIA]);

                OpcaoDeListagem := '';
                if MyModule.ComboBox_OpcaoDeListagem.ItemIndex > 0 then
                    OpcaoDeListagem := '   WHERE TI_FAMILIAS_ID = ' + IntToStr(Byte(MyModule.ComboBox_OpcaoDeListagem.Items.Objects[MyModule.ComboBox_OpcaoDeListagem.ItemIndex])) + #13#10;

                ConfigureDataSet(DataModuleMain.ZConnections.ByName['ZConnection_BDO'].Connection
                                ,RODataSetCriterio
                                ,MySQLFormat(SQL_FAMILIAS
                                            ,[OpcaoDeListagem]));
            end;

            SomatorioComercialGeral := 0;
            SomatorioTecnicoGeral := 0;

            MyModule.ProgressBar_GeracaoDeRelatorio.Position := 0;
            MyModule.ProgressBar_GeracaoDeRelatorio.Step := 1;
            MyModule.ProgressBar_GeracaoDeRelatorio.Max := RODataSetCriterio.RecordCount;
            MyModule.ProgressBar_GeracaoDeRelatorio.Show;

            ItensDeListagem := '';

            { Circulando por todos os itens do critério }
            while not RODataSetCriterio.Eof do
            begin
//                Result := Result + RODataSetCriterio.Fields[1].AsString + '<br>'#13#10;


                ConfigureDataSet(DataModuleMain.ZConnections.ByName['ZConnection_BDO'].Connection
                                ,RODataSetItemDoCriterio
                                ,MySQLFormat(SQLItemDoCriterio
                                            ,[RODataSetCriterio.Fields[0].AsInteger
                                             ,FormatDateTime('yyyymmddhhnnss',DataInicial)
                                             ,FormatDateTime('yyyymmddhhnnss',DataFinal)])
                                ,False);

                SomatorioComercialCriterio := 0;
                SomatorioTecnicoCriterio := 0;

                Itens := '';

                while not RODataSetItemDoCriterio.Eof do
                begin
//                    Result := Result + RODataSetItemDoCriterio.Fields[0].AsString + '|' + RODataSetItemDoCriterio.Fields[1].AsString + '|' + RODataSetItemDoCriterio.Fields[2].AsString + '<br>'#13#10;
                    { Adiciona mais um template }
                    Itens := Itens + TemplateItem;

                    { Substitui o que for substituivel }
                    Itens := StringReplace(Itens,'[%]LINHADECOR[%]',IfThen(not Odd(RODataSetItemDoCriterio.RecNo),' CLASS="COR"',''),[]);
                    Itens := StringReplace(Itens,'[%]CAT[%]',DecodificarCategoria(RODataSetItemDoCriterio.Fields[1].AsString[1]),[]);
                    Itens := StringReplace(Itens,'[%]JUSTIFICATIVA[%]',RODataSetItemDoCriterio.Fields[2].AsString,[]);
                    Itens := StringReplace(Itens,'[%]QTD[%]',RODataSetItemDoCriterio.Fields[0].AsString,[]);

                    { Incrementando o somatório do critério }
                    IncrementaSomatorio(False,RODataSetItemDoCriterio.Fields[1].AsString[1],RODataSetItemDoCriterio.Fields[0].AsInteger);

                    RODataSetItemDoCriterio.Next;
                end;

                { Neste ponto "Itens" contém uma string com cada uma das linhas
                que devem ser colocadas em "TemplateItemDeListagem". Agora é só
                fazer as substituições necessárias em "TemplateItemDeListagem" }
                ItensDeListagem := ItensDeListagem + TemplateItemDeListagem;                
                
                ItensDeListagem := StringReplace(ItensDeListagem,'[%]NAOTEMCRITERIO1[%]','',[]);
                ItensDeListagem := StringReplace(ItensDeListagem,'[%]NAOTEMCRITERIO2[%]','',[]);
                ItensDeListagem := StringReplace(ItensDeListagem,'[%]CRITERIO_DA_VEZ[%]',RODataSetCriterio.Fields[1].AsString,[]);
                ItensDeListagem := StringReplace(ItensDeListagem,'[%]ITEMDALISTAGEM[%]',Itens,[]);

                { Se algum item de sumário estiver ativo devemo colocar a linha
                separadora inicial }
                if MyModule.CheckBox_QtdParcCom.Checked or MyModule.CheckBox_QtdParcTec.Checked or MyModule.CheckBox_QtdParcTot.Checked then
                begin
                    ItensDeListagem := StringReplace(ItensDeListagem,'[%]NAOTEMSUMARIO1[%]','',[]);
                    ItensDeListagem := StringReplace(ItensDeListagem,'[%]NAOTEMSUMARIO2[%]','',[]);
                end
                else
                begin
                    ItensDeListagem := StringReplace(ItensDeListagem,'[%]NAOTEMSUMARIO1[%]','<!--',[]);
                    ItensDeListagem := StringReplace(ItensDeListagem,'[%]NAOTEMSUMARIO2[%]','-->',[]);
                end;

                if MyModule.CheckBox_QtdParcCom.Checked then
                begin
                    ItensDeListagem := StringReplace(ItensDeListagem,'[%]NAOTEMQTDPARCOM1[%]','',[]);
                    ItensDeListagem := StringReplace(ItensDeListagem,'[%]NAOTEMQTDPARCOM2[%]','',[]);
                    ItensDeListagem := StringReplace(ItensDeListagem,'[%]QTDPARCOM[%]',IntToStr(SomatorioComercialCriterio),[]);
                end
                else
                begin
                    ItensDeListagem := StringReplace(ItensDeListagem,'[%]NAOTEMQTDPARCOM1[%]','<!--',[]);
                    ItensDeListagem := StringReplace(ItensDeListagem,'[%]NAOTEMQTDPARCOM2[%]','-->',[]);
                end;

                if MyModule.CheckBox_QtdParcTec.Checked then
                begin
                    ItensDeListagem := StringReplace(ItensDeListagem,'[%]NAOTEMQTDPARCTEC1[%]','',[]);
                    ItensDeListagem := StringReplace(ItensDeListagem,'[%]NAOTEMQTDPARCTEC2[%]','',[]);
                    ItensDeListagem := StringReplace(ItensDeListagem,'[%]QTDPARCTEC[%]',IntToStr(SomatorioTecnicoCriterio),[]);
                end
                else
                begin
                    ItensDeListagem := StringReplace(ItensDeListagem,'[%]NAOTEMQTDPARCTEC1[%]','<!--',[]);
                    ItensDeListagem := StringReplace(ItensDeListagem,'[%]NAOTEMQTDPARCTEC2[%]','-->',[]);
                end;

                if MyModule.CheckBox_QtdParcTot.Checked then
                begin
                    ItensDeListagem := StringReplace(ItensDeListagem,'[%]NAOTEMQTDPARCTOT1[%]','',[]);
                    ItensDeListagem := StringReplace(ItensDeListagem,'[%]NAOTEMQTDPARCTOT2[%]','',[]);
                    ItensDeListagem := StringReplace(ItensDeListagem,'[%]QTDPARCTOT[%]',IntToStr(SomatorioComercialCriterio + SomatorioTecnicoCriterio),[]);
                end
                else
                begin
                    ItensDeListagem := StringReplace(ItensDeListagem,'[%]NAOTEMQTDPARCTOT1[%]','<!--',[]);
                    ItensDeListagem := StringReplace(ItensDeListagem,'[%]NAOTEMQTDPARCTOT2[%]','-->',[]);
                end;

                { Incrementando o somatório geral }
                IncrementaSomatorio(True);

                MyModule.ProgressBar_GeracaoDeRelatorio.StepIt;
                RODataSetCriterio.Next;
            end;

            { Incluindo ou não o sumário geral }
            SumarioGeral := '';
            if MyModule.CheckBox_ExibirSumarioGeral.Checked then
            begin
                SumarioGeral := TemplateSumarioGeral;
                SumarioGeral := StringReplace(SumarioGeral,'[%]QTDTOTCOM[%]',IntToStr(SomatorioComercialGeral),[]);
                SumarioGeral := StringReplace(SumarioGeral,'[%]QTDTOTTEC[%]',IntToStr(SomatorioTecnicoGeral),[]);
            end;

            { Realizando as substituições obrigatórias no template principal }
            Result := StringReplace(Result,'[%]LISTAGEM[%]',ItensDeListagem,[]);
            Result := StringReplace(Result,'[%]SUMARIOGERAL[%]',SumarioGeral,[]);
        end;

    finally
        if Assigned(RODataSetItemDoCriterio) then
            RODataSetItemDoCriterio.Free;

        if Assigned(RODataSetCriterio) then
            RODataSetCriterio.Free;

        MyModule.DelayedHideProgressBar;
    end;
end;

function TBDODataModule_Relatorio_JDO.MyModule: TBDOForm_Relatorio_JDO;
begin
    Result := TBDOForm_Relatorio_JDO(Owner);
end;

end.
