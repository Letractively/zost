unit UBDODataModule_Relatorio_OBR;

interface

uses
    Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
    Dialogs, UBDODataModule_GeradorDeRelatorio, ImgList, ActnList, UBDOForm_Relatorio_OBR;

type
    TBDODataModule_Relatorio_OBR = class(TBDODataModule_GeradorDeRelatorio)
        procedure DataModuleCreate(Sender: TObject);
    private
        { Private declarations }
        FVA_COTACOES: ShortString;
        function GerarRelatorioDeObras: String;
        function MyModule: TBDOForm_Relatorio_OBR;
        function GetMoeda: Byte;
    public
        { Public declarations }
        procedure DefinirCotacoes;
        procedure GerarRelatorio; override;
    end;

implementation

uses
    ZDataset, DBClient, DB, UBDODataModule;

{$R *.dfm}

const
	ESTADOS: array [1..27] of String[2] = ('AC','AM','AL','AP','BA','CE','DF','ES',
    									   'GO','MA','MT','MS','MG','PA','PB','PR',
                                           'PE','PI','RN','RS','RJ','RO','RR','SC',
                                           'SP','SE','TO');
	SQL_TIPOS = 'SELECT TI_TIPOS_ID,VA_DESCRICAO FROM TIPOS';
  	SQL_SITUACOES = 'SELECT SIT.TI_SITUACOES_ID, SIT.VA_DESCRICAO FROM SITUACOES SIT WHERE %s 1';
  	SQL_REGIOES =
    'SELECT REG.TI_REGIOES_ID'#13#10 +
    '     , REG.VA_REGIAO'#13#10 +
    '  FROM REGIOES REG'#13#10 +
    '  JOIN REGIOESDOSUSUARIOS RDU USING (TI_REGIOES_ID)'#13#10 +
    ' WHERE RDU.SM_USUARIOS_ID = %d';

  	SQL_REGIAO =
    'SELECT TI_REGIOES_ID'#13#10 +
    '     , VA_REGIAO'#13#10 +
    '  FROM REGIOES'#13#10 +
    ' WHERE TI_REGIOES_ID = %u';

	(* Complete com o critério adequado mais abaixo ... *)
	SQL_OBRAS =
    'SELECT OBR.IN_OBRAS_ID'#13#10 +
    '  FROM OBRAS OBR'#13#10 +
    '  JOIN SITUACOES SIT USING(TI_SITUACOES_ID)'#13#10 +
    ' WHERE TRUE'#13#10 +
    '   %s'#13#10 + //SIT.VA_DESCRICAO NOT IN ('GANHA','PERDIDA','SUSPENSA')
    '   AND OBR.DT_DATAEHORADACRIACAO BETWEEN :DATA1 AND :DATA2 AND ';
    
    CRITERIO_TIPOS = 'TI_TIPOS_ID = %u';
    CRITERIO_SITUACOES = 'OBR.TI_SITUACOES_ID = %u';
    CRITERIO_ESTADOS = 'CH_ESTADO = ''%.2s''';
    CRITERIO_REGIOES = 'TI_REGIOES_ID = %u';

resourcestring
    RS_PRIMEIRORODAPE_RELATORIO = 'HITACHI AR CONDICIONADO DO BRASIL LTDA.';
    RS_SEGUNDORODAPE_RELATORIO = 'http://www.hitachiapb.com.br';


procedure TBDODataModule_Relatorio_OBR.GerarRelatorio;
begin
    ClearHTML;
    SaveTextFile(GerarRelatorioDeObras,ArquivoTemporario);
    inherited;
end;

procedure TBDODataModule_Relatorio_OBR.DataModuleCreate(Sender: TObject);
begin
    inherited;
    FVA_COTACOES := '1;1;1;1;1';
end;

procedure TBDODataModule_Relatorio_OBR.DefinirCotacoes;
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

function TBDODataModule_Relatorio_OBR.GerarRelatorioDeObras: String;

    function RegiaoAListar: Byte;
    begin
        Result := Byte(MyModule.ComboBox_RegiosDisponiveis.Items.Objects[MyModule.ComboBox_RegiosDisponiveis.ItemIndex]);
    end;

    procedure InicializarCDS(out CDSSituacoes: TClientDataSet; const SituacoesStr: ShortString);
    const
        SQL_SITUACOES = 'SELECT SIT.TI_SITUACOES_ID, SIT.VA_DESCRICAO FROM SITUACOES SIT WHERE %s 1';
    var
        RODataSet: TZReadOnlyQuery;
    begin
        with CDSSituacoes do
        begin
            Close;
            with FieldDefs do
            begin
                Clear;
                Add('TI_SITUACOES_ID',ftSmallint);
                Add('VA_DESCRICAO',ftString,20);
                Add('IN_QUANTIDADE',ftInteger);
                Add('FL_TOTAL',ftCurrency);
            end;

            with IndexDefs do
            begin
                Clear;
                Add('PRIMARYKEY','TI_SITUACOES_ID',[ixPrimary]);
                Add('UNIQUEKEY','VA_DESCRICAO',[ixUnique]);
            end;
            CreateDataSet;
        end;

        RODataSet := nil;
        try
            ConfigureDataSet(DataModuleMain.ZConnections.ByName['ZConnection_BDO'].Connection
                            ,RODataSet
                            ,MySQLFormat(SQL_SITUACOES
                                        ,[SituacoesStr]));

            with RODataSet do
            begin
                First;
                while not Eof do
                begin
                    CDSSituacoes.InsertRecord([Fields[0].AsInteger,Fields[1].AsString,0,0]);
                    Next;
                end;
            end;
        finally
            if Assigned(RODataSet) then
                RODataSet.Free;
        end;
    end;

    procedure AtualizarCDS(out CDSSituacoes: TClientDataSet; IN_OBRAS_ID: Integer; Valor: Currency);
    const
        SQL_SITUACAO =
        'SELECT SIT.TI_SITUACOES_ID'#13#10 +
        '  FROM SITUACOES SIT'#13#10 +
        '  JOIN OBRAS OBR USING (TI_SITUACOES_ID)'#13#10 +
        'WHERE OBR.IN_OBRAS_ID = %u';

    var
        RODataSet: TZReadOnlyQuery;
    begin
        RODataSet := nil;

        try
            ConfigureDataSet(DataModuleMain.ZConnections.ByName['ZConnection_BDO'].Connection
                            ,RODataSet
                            ,MySQLFormat(SQL_SITUACAO
                                        ,[IN_OBRAS_ID]));

            with RODataSet do
            begin
                if RecordCount = 1 then
                    with CDSSituacoes do
                        if Locate('TI_SITUACOES_ID',RODataSet.Fields[0].AsInteger,[]) then
                        begin
                            Edit;
                            Fields[2].AsInteger := Fields[2].AsInteger + 1;
                            Fields[3].AsCurrency := Fields[3].AsCurrency + Valor;
                            Post;
                        end;
            end;
        finally
            if Assigned(RODataSet) then
                RODataSet.Free;
        end;
    end;

var
	CDSSituacoes: TClientDataSet;
	Obras, CriterioSendoVerificado: TZReadOnlyQuery;
    LinhaTemplate, LinhaSituacao, TotaisTemplate, ItensHTML, SituacoesHTML, Sql_TodosOsItensDoCriterio: String;
    CriterioStr, PeriodoStr, SituacoesStr: ShortString;
    QtdTotal: Cardinal;
    ItemNo, ColSpan: Word;
    ValTotal, ValorTotalDoCriterio, ValorPadraoDaObra: Currency;
    FraseDeErro, Sql_CriterioSendoVerificado: ShortString;
begin
    (* Carregando o arquivo de modelo geral que será posto em result *)

    Result := LoadTextFile(Configurations.CurrentDir + '\reporttemplates\OBRAS\obrasporcriterio[1].'{$IFDEF IE}+'ie'+{$ELSE}+'firefox'+{$ENDIF}'.template');

    Result := StringReplace(Result,'<%>PRIMEIRORODAPE<%>',RS_PRIMEIRORODAPE_RELATORIO,[]);
    Result := StringReplace(Result,'<%>SEGUNDORODAPE<%>',RS_SEGUNDORODAPE_RELATORIO,[]);

    (* Carregando o arquivo com o modelo de uma linha de tabela (replicavel) *)
    LinhaTemplate := LoadTextFile(Configurations.CurrentDir + '\reporttemplates\OBRAS\obrasporcriterio[2].template');

    (* Ao menos  uma das opções de visualização tem de ser usada. Quando ambas não
    forem setadas a correção usa a informação padrão que é grooValores. De   forma
    análoga, apenas pode-se exibir situações se não estivermos exibindo  relatório
    de obras por situações *)
    if not MyModule.CheckBoxExibirValores.Checked and not MyModule.CheckBoxExibirQuantidades.Checked then
	    MyModule.CheckBoxExibirValores.Checked := True;

    if MyModule.RadioButtonPorSituacao.Checked then
    	MyModule.CheckBoxExibirSituacoes.Checked := False;

    PeriodoStr := '';
    if MyModule.CheckBoxExibirPeriodo.Checked then
	    PeriodoStr := '(no período de ' + FormatDateTime('dd/mm/yyyy',MyModule.DateTimePicker_DA_DATADEENTRADA1.DateTime) + ' a ' + FormatDateTime('dd/mm/yyyy',MyModule.DateTimePicker_DA_DATADEENTRADA2.DateTime) + ')';

    (* Opcional - Quantidades *)
    if MyModule.CheckBoxExibirQuantidades.Checked then
    begin
        LinhaTemplate := StringReplace(LinhaTemplate,'<%>QUANTIDADE<%>',LoadTextFile(Configurations.CurrentDir + '\reporttemplates\OBRAS\obrasporcriterio[8].template'),[]);
        Result := StringReplace(Result,'<%>EXIBIRQUANTIDADE<%>',LoadTextFile(Configurations.CurrentDir + '\reporttemplates\OBRAS\obrasporcriterio[3].template'),[]);
    end
    else
    begin
	    Result := StringReplace(Result,'<%>EXIBIRQUANTIDADE<%>','',[]);
    	LinhaTemplate := StringReplace(LinhaTemplate,'<%>QUANTIDADE<%>','',[]);
    end;

    (* Opcional - Valores *)
    if MyModule.CheckBoxExibirValores.Checked then
    begin
        LinhaTemplate := StringReplace(LinhaTemplate,'<%>VALOR<%>',LoadTextFile(Configurations.CurrentDir + '\reporttemplates\OBRAS\obrasporcriterio[9].template'),[]);
        Result := StringReplace(Result,'<%>EXIBIRVALOR<%>',LoadTextFile(Configurations.CurrentDir + '\reporttemplates\OBRAS\obrasporcriterio[4].template'),[]);
    end
    else
    begin
    	Result := StringReplace(Result,'<%>EXIBIRVALOR<%>','',[]);
	    LinhaTemplate := StringReplace(LinhaTemplate,'<%>VALOR<%>','',[]);
    end;

    (* Opcional - Totais *)
    if MyModule.CheckBoxExibirTotais.Checked then
    begin
        TotaisTemplate := LoadTextFile(Configurations.CurrentDir + '\reporttemplates\OBRAS\obrasporcriterio[7].template');

        if MyModule.CheckBoxExibirQuantidades.Checked then
            TotaisTemplate := StringReplace(TotaisTemplate,'<%>QUANTIDADETOTAL<%>',LoadTextFile(Configurations.CurrentDir + '\reporttemplates\OBRAS\obrasporcriterio[5].template'),[])
        else
            TotaisTemplate := StringReplace(TotaisTemplate,'<%>QUANTIDADETOTAL<%>','',[]);

        if MyModule.CheckBoxExibirValores.Checked then
            TotaisTemplate := StringReplace(TotaisTemplate,'<%>VALORTOTAL<%>',LoadTextFile(Configurations.CurrentDir + '\reporttemplates\OBRAS\obrasporcriterio[6].template'),[])
        else
            TotaisTemplate := StringReplace(TotaisTemplate,'<%>VALORTOTAL<%>','',[]);

        Result := StringReplace(Result,'<%>TOTALGERAL<%>',TotaisTemplate,[]);
    end
    else
    	Result := StringReplace(Result,'<%>TOTALGERAL<%>','',[]);

    if MyModule.CheckBoxExibirSituacoes.Checked then
    begin
        LinhaSituacao := LoadTextFile(Configurations.CurrentDir + '\reporttemplates\OBRAS\obrasporcriterio[11].template');

        ColSpan := 1;
        if MyModule.CheckBoxExibirValores.Checked then
        begin
            LinhaSituacao := StringReplace(LinhaSituacao,'<%>VALSITUACAO<%>',LoadTextFile(Configurations.CurrentDir + '\reporttemplates\OBRAS\obrasporcriterio[13].template'),[]);
            Inc(ColSpan);
        end
        else
            LinhaSituacao := StringReplace(LinhaSituacao,'<%>VALSITUACAO<%>','',[]);

        if MyModule.CheckBoxExibirQuantidades.Checked then
        begin
            LinhaSituacao := StringReplace(LinhaSituacao,'<%>QTDSITUACAO<%>',LoadTextFile(Configurations.CurrentDir + '\reporttemplates\OBRAS\obrasporcriterio[12].template'),[]);
            Inc(ColSpan);
        end
        else
            LinhaSituacao := StringReplace(LinhaSituacao,'<%>QTDSITUACAO<%>','',[]);

        LinhaTemplate := StringReplace(LinhaTemplate,'<%>SITUACOES<%>',LoadTextFile(Configurations.CurrentDir + '\reporttemplates\OBRAS\obrasporcriterio[10].template'),[]);
        LinhaTemplate := StringReplace(LinhaTemplate,'<%>COLSPAN<%>',IntToStr(ColSpan),[rfReplaceAll]);
    end
    else
    	LinhaTemplate := StringReplace(LinhaTemplate,'<%>SITUACOES<%>','',[]);

    (* Formatando o SQL de obras de forma que ele só conte com situações específicas *)
    SituacoesStr := '';
    if not MyModule.CheckBoxContarComGanhas.Checked then
	    SituacoesStr := QuotedStr('GANHA');

    if not MyModule.CheckBoxContarComPerdidas.Checked then
    begin
        if SituacoesStr <> '' then
	        SituacoesStr := SituacoesStr + ', ' + QuotedStr('PERDIDA')
        else
    	    SituacoesStr := QuotedStr('PERDIDA');
    end;

    if not MyModule.CheckBoxContarComSuspensas.Checked then
    begin
        if SituacoesStr <> '' then
            SituacoesStr := SituacoesStr + ', ' + QuotedStr('SUSPENSA')
        else
            SituacoesStr := QuotedStr('SUSPENSA');
    end;

    if SituacoesStr <> '' then
	    SituacoesStr := 'AND SIT.VA_DESCRICAO NOT IN (' + SituacoesStr + ')';

    if MyModule.RadioButtonPorTipo.Checked then
    begin (* = POR TIPO ===================================== *)
        CriterioStr := 'Tipo da obra';
        Sql_TodosOsItensDoCriterio := SQL_TIPOS;
        FraseDeErro := 'Não existe nenhum tipo registrado. Não é possível gerar relatórios por tipo de obra';
        Sql_CriterioSendoVerificado := CRITERIO_TIPOS;
    end
    else if MyModule.RadioButtonPorSituacao.Checked then
    begin (* = POR SITUAÇÃO ============================= *)
        CriterioStr := 'Situação da obra';
        Sql_TodosOsItensDoCriterio := Format(SQL_SITUACOES,[SituacoesStr]);
        FraseDeErro := 'Não existe nenhuma situação registrada. Não é possível gerar relatórios pela situação da obra';
        Sql_CriterioSendoVerificado := CRITERIO_SITUACOES;
    end
    else if MyModule.RadioButtonPorEstado.Checked then
    begin (* = POR ESTADO ================================= *)
        CriterioStr := 'Estado';
        Sql_TodosOsItensDoCriterio := 'ESTE SQL NÃO É USADO QUANDO O CRITÉRIO É "POR ESTADO"';
        FraseDeErro := 'Sempre haverá uma lista de estados válida, logo esta mensagem de erro nunca deveria ser vista!';
        Sql_CriterioSendoVerificado := CRITERIO_ESTADOS;
    end
    else if MyModule.RadioButtonPorRegiao.Checked then
    begin (* = POR REGIÃO ================================= *)
        CriterioStr := 'Região da obra';

        if RegiaoAListar = 0 then
            Sql_TodosOsItensDoCriterio := Format(SQL_REGIOES,[Configurations.AuthenticatedUser.Id])
        else
            Sql_TodosOsItensDoCriterio := Format(SQL_REGIAO,[RegiaoAListar]);

        FraseDeErro := 'Não existe nenhuma região registrada. Não é possível gerar relatórios pela região da obra';
        Sql_CriterioSendoVerificado := CRITERIO_REGIOES;
    end;

	(* A variável abaixo guardará a união de todos os itens a serem exibidos *)
    ItensHTML := '<!-- Itens da proposta -->';

    QtdTotal := 0;
    ValTotal := 0;
    ItemNo := 0;

	try
        CriterioSendoVerificado := nil;
        if not MyModule.RadioButtonPorEstado.Checked then
        begin
    	    ConfigureDataSet(DataModuleMain.ZConnections.ByName['ZConnection_BDO'].Connection
                            ,CriterioSendoVerificado
                            ,Sql_TodosOsItensDoCriterio);

            if CriterioSendoVerificado.RecordCount = 0 then
        		raise Exception.Create(FraseDeErro);

		    CriterioSendoVerificado.First;
        end;

        (* Criando e configurando o dataset temporário *)
  	    CDSSituacoes := nil;
        if MyModule.CheckBoxExibirSituacoes.Checked then
	        CDSSituacoes := TClientDataSet.Create(Self);

    	Obras := nil;

		if MyModule.RadioButtonPorEstado.Checked then
            try
                MyModule.ProgressBar_GeracaoDeRelatorio.Position := 0;
                MyModule.ProgressBar_GeracaoDeRelatorio.Step := 1;
                MyModule.ProgressBar_GeracaoDeRelatorio.Max := High(ESTADOS);
                MyModule.ProgressBar_GeracaoDeRelatorio.Show;
                
                for ItemNo := 1 to High(ESTADOS) do
                begin
                    ValorTotalDoCriterio := 0;

                    if MyModule.CheckBoxExibirSituacoes.Checked then
                        InicializarCDS(CDSSituacoes,SituacoesStr);

                    ItensHTML := ItensHTML + #13#10 + StringReplace(LinhaTemplate,'<%>DADODOCRITERIO<%>',ESTADOS[ItemNo],[rfReplaceAll]);

                    (* Gerando linhas de cores alternadas *)
                    if not Odd(ItemNo) then
                        ItensHTML := StringReplace(ItensHTML,'<%>TR<%>',#9#9#9'<TR CLASS="linhacor">',[])
                    else
                        ItensHTML := StringReplace(ItensHTML,'<%>TR<%>',#9#9#9'<TR>',[]);

                    ConfigureDataSet(DataModuleMain.ZConnections.ByName['ZConnection_BDO'].Connection
                                    ,Obras
                                    ,MySQLFormat(SQL_OBRAS
                                                ,[SituacoesStr])
                                     + MySQLFormat(Sql_CriterioSendoVerificado
                                                  ,[ESTADOS[ItemNo]]));

                    Obras.ParamByName('DATA1').AsDate := MyModule.DateTimePicker_DA_DATADEENTRADA1.DateTime;
                    Obras.ParamByName('DATA2').AsDate := MyModule.DateTimePicker_DA_DATADEENTRADA2.DateTime;
                    Obras.Refresh;

                    (* Obtendo a quantidade *)
                    if MyModule.CheckBoxExibirQuantidades.Checked then
                    begin
                        ItensHTML := StringReplace(ItensHTML,'<%>QTD<%>',IntToStr(Obras.RecordCount),[]);
                        Inc(QtdTotal,Obras.RecordCount);
                    end;

                    (* Obtendo os valores e as quantidades para cada situação *)
                    if MyModule.CheckBoxExibirValores.Checked or MyModule.CheckBoxExibirQuantidades.Checked then
                    begin
                        Obras.First;
                        while not Obras.Eof do
                        begin
                            ValorPadraoDaObra := ValorDaObra(Obras.Fields[0].AsInteger,False,FVA_COTACOES);

                            if MyModule.CheckBoxExibirValores.Checked then
                                ValorTotalDoCriterio := ValorTotalDoCriterio + ValorPadraoDaObra;

                            if MyModule.CheckBoxExibirSituacoes.Checked then
                                AtualizarCDS(CDSSituacoes,Obras.Fields[0].AsInteger,ValorPadraoDaObra);

                            Obras.Next;
                        end;

                        if MyModule.CheckBoxExibirValores.Checked then
                        begin
                            ItensHTML := StringReplace(ItensHTML,'<%>VAL<%>',FormatFloat('"' + SimboloMonetario(GetMoeda) + '" ###,###,###,##0.00',ValorTotalDoCriterio),[]);
                            ValTotal := ValTotal + ValorTotalDoCriterio;
                        end;
                    end;

                    if MyModule.CheckBoxExibirSituacoes.Checked then
                    begin
                        SituacoesHTML := '<!-- Situações do critério -->';

                        CDSSituacoes.First;
                        while not CDSSituacoes.Eof do
                        begin
                            SituacoesHTML := SituacoesHTML + #13#10 + StringReplace(LinhaSituacao,'<%>SITUACAO<%>',CDSSituacoes.Fields[1].AsString,[]);

                            if MyModule.CheckBoxExibirValores.Checked then
//                                SituacoesHTML := StringReplace(SituacoesHTML,'<%>VALSIT<%>',FormatFloat(rs_formatovalormonetarioreal,CDSSituacoes.Fields[3].asCurrency),[]);
                                SituacoesHTML := StringReplace(SituacoesHTML,'<%>VALSIT<%>',FormatFloat('"' + SimboloMonetario(GetMoeda) + '" ###,###,###,##0.00',CDSSituacoes.Fields[3].asCurrency),[]);

                            if MyModule.CheckBoxExibirQuantidades.Checked then
                                SituacoesHTML := StringReplace(SituacoesHTML,'<%>QTDSIT<%>',CDSSituacoes.Fields[2].asString,[]);

                            CDSSituacoes.Next;
                        end;

                        ItensHTML := StringReplace(ItensHTML,'<%>DADODASITUACAO<%>',SituacoesHTML,[]);

                    end
                    else
                        ItensHTML := StringReplace(ItensHTML,'<%>DADODASITUACAO<%>','',[]);

                    MyModule.ProgressBar_GeracaoDeRelatorio.StepIt;
                end
            finally
                MyModule.DelayedHideProgressBar;
            end
        else
            try
                MyModule.ProgressBar_GeracaoDeRelatorio.Position := 0;
                MyModule.ProgressBar_GeracaoDeRelatorio.Step := 1;
                MyModule.ProgressBar_GeracaoDeRelatorio.Max := CriterioSendoVerificado.RecordCount;
                MyModule.ProgressBar_GeracaoDeRelatorio.Show;

                while not CriterioSendoVerificado.Eof do
                begin
                    ValorTotalDoCriterio := 0;

                    if MyModule.CheckBoxExibirSituacoes.Checked then
                        InicializarCDS(CDSSituacoes,SituacoesStr);

                    ItensHTML := ItensHTML + #13#10 + StringReplace(LinhaTemplate,'<%>DADODOCRITERIO<%>',CriterioSendoVerificado.Fields[1].AsString,[rfReplaceAll]);
                    Inc(ItemNo);

                    (* Gerando linhas de cores alternadas *)
                    if not Odd(ItemNo) then
                        ItensHTML := StringReplace(ItensHTML,'<%>TR<%>',#9#9#9'<TR CLASS="linhacor">',[])
                    else
                        ItensHTML := StringReplace(ItensHTML,'<%>TR<%>',#9#9#9'<TR>',[]);

                    ConfigureDataSet(DataModuleMain.ZConnections.ByName['ZConnection_BDO'].Connection
                                    ,Obras
                                    ,MySQLFormat(SQL_OBRAS
                                                ,[SituacoesStr])
                                     + MySQLFormat(Sql_CriterioSendoVerificado
                                                  ,[CriterioSendoVerificado.Fields[0].AsInteger]));

                    Obras.ParamByName('DATA1').AsDate := MyModule.DateTimePicker_DA_DATADEENTRADA1.DateTime;
                    Obras.ParamByName('DATA2').AsDate := MyModule.DateTimePicker_DA_DATADEENTRADA2.DateTime;
                    Obras.Refresh;

                    (* Obtendo a quantidade *)
                    if MyModule.CheckBoxExibirQuantidades.Checked then
                    begin
                        ItensHTML := StringReplace(ItensHTML,'<%>QTD<%>',IntToStr(Obras.RecordCount),[]);
                        Inc(QtdTotal,Obras.RecordCount);
                    end;

                    // =====================================================
                    (* Obtendo os valores e as quantidades para cada situação *)
                    if MyModule.CheckBoxExibirValores.Checked or MyModule.CheckBoxExibirQuantidades.Checked then
                    begin
                        Obras.First;
                        while not Obras.Eof do
                        begin
                            ValorPadraoDaObra := ValorDaObra(Obras.Fields[0].AsInteger,False,FVA_COTACOES);

                            if MyModule.CheckBoxExibirValores.Checked then
                                ValorTotalDoCriterio := ValorTotalDoCriterio + ValorPadraoDaObra;

                            if MyModule.CheckBoxExibirSituacoes.Checked then
                                AtualizarCDS(CDSSituacoes,Obras.Fields[0].AsInteger,ValorPadraoDaObra);

                            Obras.Next;
                        end;

                        if MyModule.CheckBoxExibirValores.Checked then
                        begin
                            ItensHTML := StringReplace(ItensHTML,'<%>VAL<%>',FormatFloat('"' + SimboloMonetario(GetMoeda) + '" ###,###,###,##0.00',ValorTotalDoCriterio),[]);
                            ValTotal := ValTotal + ValorTotalDoCriterio;
                        end;
                    end;

                    if MyModule.CheckBoxExibirSituacoes.Checked then
                    begin
                        SituacoesHTML := '<!-- Situações do critério -->';

                        CDSSituacoes.First;
                        while not CDSSituacoes.Eof do
                        begin
                            SituacoesHTML := SituacoesHTML + #13#10 + StringReplace(LinhaSituacao,'<%>SITUACAO<%>',CDSSituacoes.Fields[1].AsString,[]);

                            if MyModule.CheckBoxExibirValores.Checked then
//      		                SituacoesHTML := StringReplace(SituacoesHTML,'<%>VALSIT<%>',FormatFloat(rs_formatovalormonetarioreal,CDSSituacoes.Fields[3].asCurrency),[]);
                                SituacoesHTML := StringReplace(SituacoesHTML,'<%>VALSIT<%>',FormatFloat('"' + SimboloMonetario(GetMoeda) + '" ###,###,###,##0.00',CDSSituacoes.Fields[3].asCurrency),[]);

                            if MyModule.CheckBoxExibirQuantidades.Checked then
                                SituacoesHTML := StringReplace(SituacoesHTML,'<%>QTDSIT<%>',CDSSituacoes.Fields[2].asString,[]);

                            CDSSituacoes.Next;
                        end;

                        ItensHTML := StringReplace(ItensHTML,'<%>DADODASITUACAO<%>',SituacoesHTML,[]);

                    end
                    else
                        ItensHTML := StringReplace(ItensHTML,'<%>DADODASITUACAO<%>','',[]);

                    MyModule.ProgressBar_GeracaoDeRelatorio.StepIt;
                    CriterioSendoVerificado.Next;
                end;
            finally
                MyModule.DelayedHideProgressBar;
            end;
	finally
    	if Assigned(CriterioSendoVerificado) then
			CriterioSendoVerificado.Free;

    	if Assigned(Obras) then
      		Obras.Free;

    	if Assigned(CDSSituacoes) then
    		CDSSituacoes.Free;
	end;

    (* Finalmente substituindo os dados gerais no relatório final *)
    Result := StringReplace(Result,'<%>CRITERIO<%>',CriterioStr,[rfReplaceAll]);
    Result := StringReplace(Result,'<%>PERIODO<%>',PeriodoStr,[rfReplaceAll]);
    Result := StringReplace(Result,'<%>CONTEUDO<%>',ItensHTML,[]);
    Result := StringReplace(Result,'<%>QTDTOTAL<%>',IntToStr(QtdTotal),[rfReplaceAll]);
    Result := StringReplace(Result,'<%>VALTOTAL<%>',FormatFloat('"' + SimboloMonetario(GetMoeda) + '" ###,###,###,##0.00',ValTotal),[rfReplaceAll]);
end;

function TBDODataModule_Relatorio_OBR.GetMoeda: Byte;
begin
    Result := Byte(Succ(MyModule.ComboBox_PRO_TI_MOEDA.ItemIndex));
end;

function TBDODataModule_Relatorio_OBR.MyModule: TBDOForm_Relatorio_OBR;
begin
    Result := TBDOForm_Relatorio_OBR(Owner);
end;

end.
