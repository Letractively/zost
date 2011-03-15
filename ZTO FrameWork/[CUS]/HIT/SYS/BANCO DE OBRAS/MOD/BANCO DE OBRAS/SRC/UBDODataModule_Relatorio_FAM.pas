unit UBDODataModule_Relatorio_FAM;

interface

uses
    Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
    Dialogs, UBDODataModule_GeradorDeRelatorio, ImgList, ActnList, UBDOForm_Relatorio_FAM;

type
    TBDODataModule_Relatorio_FAM = class(TBDODataModule_GeradorDeRelatorio)
        procedure DataModuleCreate(Sender: TObject);
    private
        { Private declarations }
        FVA_COTACOES: ShortString;
        function GerarRelatorioDeFamilias: String;
        function MyModule: TBDOForm_Relatorio_FAM;
        function GetMoeda: Byte;
    public
        { Public declarations }
        procedure GerarRelatorio; override;
        procedure DefinirCotacoes;
    end;

implementation

uses
    ZDataset, UXXXDataModule, DB;

{$R *.dfm}

const
	SQL_REGIOES =
    '  SELECT REG.TI_REGIOES_ID'#13#10 +
    '       , REG.VA_REGIAO'#13#10 +
    '    FROM REGIOES REG'#13#10 +
    '    JOIN REGIOESDOSUSUARIOS RDU USING (TI_REGIOES_ID)'#13#10 +
    '   WHERE RDU.SM_USUARIOS_ID = %d'#13#10 +
    'ORDER BY REG.VA_REGIAO';

  	SQL_REGIAO =
    'SELECT TI_REGIOES_ID'#13#10 +
    '     , VA_REGIAO'#13#10 +
    '  FROM REGIOES'#13#10 +
    ' WHERE TI_REGIOES_ID = %u';

	SQL_SITUACOES =
    '  SELECT TI_SITUACOES_ID'#13#10 +
    '       , VA_DESCRICAO'#13#10 +
    '    FROM SITUACOES'#13#10 +
    'ORDER BY VA_DESCRICAO';

	SQL_FAMILIAS =
    '  SELECT TI_FAMILIAS_ID'#13#10 +
    '       , VA_DESCRICAO'#13#10 +
    '    FROM FAMILIAS'#13#10 +
    'ORDER BY VA_DESCRICAO';

	SQL_PORREGIOES = 'OBR.TI_REGIOES_ID = %u';
	SQL_PORSITUACOES = 'OBR.TI_SITUACOES_ID = %u';         


	SQL_ITENSEVALORES =
    'SELECT FNC_GET_FORMATTED_CURRENCY_VALUE(IF(COUNT(*) > 0,SUM(FNC_GET_ITEM_VALUE(ITE.IN_ITENS_ID,FALSE,FALSE,''%s'',2)),0),ELT(%u,''US$'',''€'',''R$'',''£'',''¥''),FALSE) AS SOMATORIODOSITENS'#13#10 +
    '     , REPLACE(FORMAT(COUNT(*),0),'','',''.'') AS QUANTIDADE'#13#10 +
    '     , IF(COUNT(*) > 0,SUM(FNC_GET_ITEM_VALUE(ITE.IN_ITENS_ID,FALSE,FALSE,''%0:s'',2)),0) AS SOMATORIOINTEGRAL'#13#10 +
    '     , COUNT(*) AS QUANTIDADEINTEGRAL'#13#10 +
    '  FROM ITENS ITE'#13#10 +
    '  JOIN PROPOSTAS PRO USING (IN_PROPOSTAS_ID)'#13#10 +
    '  JOIN OBRAS OBR USING (IN_OBRAS_ID)'#13#10 +
    ' WHERE %2:s'#13#10 +
    '   AND ITE.TI_FAMILIAS_ID = %s';

//BDO3
//	SQL_ITENSEVALORES =
//    'SELECT FNC_GET_FORMATTED_CURRENCY_VALUE(IF(COUNT(*) > 0,SUM(ROUND(FNC_GET_ITEM_VALUE(ITE.IN_ITENS_ID,FALSE,FALSE,''%s'',FALSE,NULL),2)),0),ELT(%u,''US$'',''€'',''R$'',''£'',''¥''),FALSE) AS SOMATORIODOSITENS'#13#10 +
//    '     , REPLACE(FORMAT(COUNT(*),0),'','',''.'') AS QUANTIDADE'#13#10 +
//    '     , IF(COUNT(*) > 0,SUM(ROUND(FNC_GET_ITEM_VALUE(ITE.IN_ITENS_ID,FALSE,FALSE,''%0:s'',FALSE,NULL),2)),0) AS SOMATORIOINTEGRAL'#13#10 +
//    '     , COUNT(*) AS QUANTIDADEINTEGRAL'#13#10 +
//    '  FROM ITENS ITE'#13#10 +
//    '  JOIN PROPOSTAS PRO USING (IN_PROPOSTAS_ID)'#13#10 +
//    '  JOIN OBRAS OBR USING (IN_OBRAS_ID)'#13#10 +
//    ' WHERE %2:s'#13#10 +
//    '   AND ITE.TI_FAMILIAS_ID = %s';

// BDO2
//	SQL_ITENSEVALORES =
//    'SELECT FNC_GET_ITEM_VALUE(ITE.IN_ITENS_ID,FALSE,FALSE,''%s'') AS VALORDOITEN'#13#10 +
//    '  FROM ITENS ITE'#13#10 +
//    '  JOIN PROPOSTAS PRO USING (IN_PROPOSTAS_ID)'#13#10 +
//    '  JOIN OBRAS OBR USING (IN_OBRAS_ID)'#13#10 +
//    ' WHERE %s'#13#10 +
//    '   AND ITE.TI_FAMILIAS_ID = %s';

resourcestring
    RS_PRIMEIRORODAPE_RELATORIO = 'HITACHI AR CONDICIONADO DO BRASIL LTDA.';
    RS_SEGUNDORODAPE_RELATORIO = 'http://www.hitachiapb.com.br';

{ TBDODataModule_Relatorio_FAM }

function TBDODataModule_Relatorio_FAM.MyModule: TBDOForm_Relatorio_FAM;
begin
    Result := TBDOForm_Relatorio_FAM(Owner);
end;

procedure TBDODataModule_Relatorio_FAM.DataModuleCreate(Sender: TObject);
begin
    inherited;
    FVA_COTACOES := '1;1;1;1;1';
end;

procedure TBDODataModule_Relatorio_FAM.DefinirCotacoes;
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

procedure TBDODataModule_Relatorio_FAM.GerarRelatorio;
begin
    ClearHTML;
    SaveTextFile(GerarRelatorioDeFamilias,ArquivoTemporario);
    inherited;
end;

function TBDODataModule_Relatorio_FAM.GerarRelatorioDeFamilias: String;
    function RegiaoAListar: Byte;
    begin
        Result := Byte(MyModule.ComboBox_RegiosDisponiveis.Items.Objects[MyModule.ComboBox_RegiosDisponiveis.ItemIndex]);
    end;

var
	Regioes, Situacoes, Familias, ItensCalculados: TZReadOnlyQuery;
  	Template2, Template3, Template4, Template5, ItensAExibir, FamiliasAExibir, SQLRegiao: String;
    Descricao1, Descricao2: ShortString;
  	ValorTotalParcial, ValorTotalGeral: Double;
    QuantidadeTotalParcial, QuantidadeTotalGeral: Cardinal;
begin

    { Carregando o template principal (#1) }
    Result := LoadTextFile(Configurations.CurrentDir + '\reporttemplates\FAMILIAS\familiasporcriterio[1].'{$IFDEF IE}+'ie'+{$ELSE}+'firefox'+{$ENDIF}'.template');

    Result := StringReplace(Result,'<%>PRIMEIRORODAPE<%>',RS_PRIMEIRORODAPE_RELATORIO,[]);
    Result := StringReplace(Result,'<%>SEGUNDORODAPE<%>',RS_SEGUNDORODAPE_RELATORIO,[]);

    { Carregando template #2 }
    Template2 := LoadTextFile(Configurations.CurrentDir + '\reporttemplates\FAMILIAS\familiasporcriterio[2].template');
    if MyModule.CheckBox_ExibirQuantidades.Checked then
    begin
        Template2 := StringReplace(Template2,'<%>EXIBIRQUANTIDADE1<%>','',[rfReplaceAll]);
        Template2 := StringReplace(Template2,'<%>EXIBIRQUANTIDADE2<%>','',[rfReplaceAll]);
    end
    else
    begin
        Template2 := StringReplace(Template2,'<%>EXIBIRQUANTIDADE1<%>','<!--',[rfReplaceAll]);
        Template2 := StringReplace(Template2,'<%>EXIBIRQUANTIDADE2<%>','-->',[rfReplaceAll]);
    end;

    { Carregando template #5 (Complemento do Template #2) }
    Template5 := '';
    if MyModule.CheckBox_ExibirTotaisParciais.Checked then
    begin
        Template5 := LoadTextFile(Configurations.CurrentDir + '\reporttemplates\FAMILIAS\familiasporcriterio[5].template');

        if MyModule.CheckBox_ExibirQuantidades.Checked then
        begin
            Template5 := StringReplace(Template5,'<%>EXIBIRQUANTIDADE1<%>','',[]);
            Template5 := StringReplace(Template5,'<%>EXIBIRQUANTIDADE2<%>','',[]);
            Template5 := StringReplace(Template5,'[%]COLSPAN[%]','',[rfReplaceAll]);
        end
        else
        begin
            Template5 := StringReplace(Template5,'<%>EXIBIRQUANTIDADE1<%>','<!--',[]);
            Template5 := StringReplace(Template5,'<%>EXIBIRQUANTIDADE2<%>','-->',[]);
            Template5 := StringReplace(Template5,'[%]COLSPAN[%]','COLSPAN="1"',[rfReplaceAll]);
        end;
    end;
    Template2 := StringReplace(Template2,'[%]SUMARIO[%]',Template5,[rfReplaceAll]);

    { Carregando template #3 }
    Template3 := LoadTextFile(Configurations.CurrentDir + '\reporttemplates\FAMILIAS\familiasporcriterio[3].template');
    if MyModule.CheckBox_ExibirQuantidades.Checked then
    begin
        Template3 := StringReplace(Template3,'<%>EXIBIRQUANTIDADE1<%>','',[]);
        Template3 := StringReplace(Template3,'<%>EXIBIRQUANTIDADE2<%>','',[]);
    end
    else
    begin
        Template3 := StringReplace(Template3,'<%>EXIBIRQUANTIDADE1<%>','<!--',[]);
        Template3 := StringReplace(Template3,'<%>EXIBIRQUANTIDADE2<%>','-->',[]);
    end;

    { Carregando template #4 }
    Template4 := '';
    if MyModule.CheckBox_ExibirTotalGeral.Checked then
    begin
        Template4 := LoadTextFile(Configurations.CurrentDir + '\reporttemplates\FAMILIAS\familiasporcriterio[4].template');

        if MyModule.CheckBox_ExibirQuantidades.Checked then
        begin
            Template4 := StringReplace(Template4,'<%>EXIBIRQUANTIDADE1<%>','',[rfReplaceAll]);
            Template4 := StringReplace(Template4,'<%>EXIBIRQUANTIDADE2<%>','',[rfReplaceAll]);
            Template4 := StringReplace(Template4,'[%]COLSPAN[%]','',[rfReplaceAll]);
        end
        else
        begin
            Template4 := StringReplace(Template4,'<%>EXIBIRQUANTIDADE1<%>','<!--',[rfReplaceAll]);
            Template4 := StringReplace(Template4,'<%>EXIBIRQUANTIDADE2<%>','-->',[rfReplaceAll]);
            Template4 := StringReplace(Template4,'[%]COLSPAN[%]','COLSPAN="1"',[rfReplaceAll]);
        end;
    end;
    Result := StringReplace(Result,'[%]SUMARIO[%]',Template4,[]);

    QuantidadeTotalGeral := 0;
    ValorTotalGeral := 0.0;
    Familias := nil;
    try

        if MyModule.CheckBox_ExibirQuantidades.Checked then
        begin
            Descricao1 := 'Totais parciais';
            Descricao2 := 'Totais gerais';
        end
        else
        begin
            Descricao1 := 'Total parcial';
            Descricao2 := 'Total geral';
        end;

        ConfigureDataSet(DataModuleMain.ZConnections.ByName['ZConnection_BDO'].Connection
                        ,Familias
                        ,SQL_FAMILIAS);

        { Cria uma vez só evitando que se crie várias vezes para cada chamada a
        ConfigureDataSet }
        ItensCalculados := TZReadOnlyQuery.Create(Self);

        if MyModule.RadioButtonPorRegiao.Checked then
            try
                Regioes := nil;
                
                Result := StringReplace(Result,'<%>CRITERIO<%>','região',[rfReplaceAll]);

                if RegiaoAListar = 0 then
                    SQLRegiao := Format(SQL_REGIOES,[Configurations.AuthenticatedUser.Id])
                else
                    SQLRegiao := Format(SQL_REGIAO,[RegiaoAListar]);

                ConfigureDataSet(DataModuleMain.ZConnections.ByName['ZConnection_BDO'].Connection
                                ,Regioes
                                ,SQLRegiao);

                ItensAExibir := '';


                MyModule.ProgressBar_GeracaoDeRelatorio.Position := 0;
                MyModule.ProgressBar_GeracaoDeRelatorio.Step := 1;
                MyModule.ProgressBar_GeracaoDeRelatorio.Max := Regioes.RecordCount;
                MyModule.ProgressBar_GeracaoDeRelatorio.Show;
                Screen.Cursor := crHourGlass;

                Regioes.First;
                { Em cada região ... }
                while not Regioes.Eof do
                begin
                    ItensAExibir := ItensAExibir + StringReplace(Template2,'<%>CRITERIONOME<%>','Famílias / ' + Regioes.Fields[1].AsString,[rfReplaceAll]);
                    FamiliasAExibir := '';
                    QuantidadeTotalParcial := 0;
                    ValorTotalParcial := 0.0;

                    Familias.First;
                    { Para cada família ... }
                    while not Familias.Eof do
                    begin
                        FamiliasAExibir := FamiliasAExibir + StringReplace(Template3,'<%>FAMILIA<%>',Familias.Fields[1].AsString,[rfReplaceAll]);

                        if Odd(Familias.RecNo) then
                            FamiliasAExibir := StringReplace(FamiliasAExibir,'<%>TR<%>','<TR CLASS="linhacor">',[])
                        else
                            FamiliasAExibir := StringReplace(FamiliasAExibir,'<%>TR<%>','<TR>',[]);

                        { Obtendo  o valor  de cada  ítem que  contém a  família  atual na
                        região atual }
                        ConfigureDataSet(DataModuleMain.ZConnections.ByName['ZConnection_BDO'].Connection
                                        ,ItensCalculados
                                        ,MySQLFormat(MySQLFormat(SQL_ITENSEVALORES
                                                                ,[FVA_COTACOES
                                                                 ,GetMoeda
                                                                 ,SQL_PORREGIOES
                                                                 ,'%u'])
                                                    ,[Regioes.Fields[0].AsInteger
                                                     ,Familias.Fields[0].AsInteger])
                                        ,False);

//                        ConfigureDataSet(DataModuleMain.ZConnections.ByName['ZConnection_BDO'].Connection
//                                        ,ItensCalculados
//                                        ,MySQLFormat(MySQLFormat(SQL_ITENSEVALORES
//                                                                ,[FVA_COTACOES
//                                                                 ,SQL_PORREGIOES
//                                                                 ,'%u'])
//                                                    ,[Regioes.Fields[0].AsInteger
//                                                     ,Familias.Fields[0].AsInteger])
//                                                    ,False);

                        if MyModule.CheckBox_ExibirQuantidades.Checked then
                            FamiliasAExibir := StringReplace(FamiliasAExibir,'<%>QUANTIDADE<%>',ItensCalculados.FieldByName('QUANTIDADE').AsString,[]);
//                            FamiliasAExibir := StringReplace(FamiliasAExibir,'<%>QUANTIDADE<%>',FormatFloat('###,###,###,###',ItensCalculados.RecordCount),[]);

//                        Somatorio := 0;
//                        while not ItensCalculados.Eof do
//                        begin
//                            Somatorio := Somatorio + ItensCalculados.Fields[0].AsCurrency;
//                            ItensCalculados.Next;
//                        end;

                        FamiliasAExibir := StringReplace(FamiliasAExibir,'<%>VALOR<%>',ItensCalculados.FieldByName('SOMATORIODOSITENS').AsString,[]);
//                        FamiliasAExibir := StringReplace(FamiliasAExibir,'<%>VALOR<%>',FormatFloat(Format(rs_formatovalormonetario,['"' + aMoedaFinal + '" ']),Somatorio),[]);

                        Inc(QuantidadeTotalParcial, ItensCalculados.FieldByName('QUANTIDADEINTEGRAL').AsInteger);
                        ValorTotalParcial := ValorTotalParcial + ItensCalculados.FieldByName('SOMATORIOINTEGRAL').AsCurrency;

                        Familias.Next;
                    end;

                    Inc(QuantidadeTotalGeral,QuantidadeTotalParcial);
                    ValorTotalGeral := ValorTotalGeral + ValorTotalParcial;
                                                                       
                    ItensAExibir := StringReplace(ItensAExibir,'<%>FAMILIAS<%>',FamiliasAExibir,[]);
                    ItensAExibir := StringReplace(ItensAExibir,'[%]DESCRICAOTOTAISPARCIAIS[%]',Descricao1,[]);
                    ItensAExibir := StringReplace(ItensAExibir,'[%]SOMATORIOQUANTIDADES[%]',FormatFloat('###,###,###,###',QuantidadeTotalParcial),[]);
                    ItensAExibir := StringReplace(ItensAExibir,'[%]SOMATORIOVALORES[%]',FormatFloat('"' + SimboloMonetario(GetMoeda) + '" ###,###,###,##0.00',ValorTotalParcial),[]);

                    MyModule.ProgressBar_GeracaoDeRelatorio.StepIt;
                    Regioes.Next;
                end;
            finally
                if Assigned(Regioes) then
                    Regioes.Free;

                MyModule.DelayedHideProgressBar;
                Screen.Cursor := crDefault;
            end
        else if MyModule.RadioButtonPorSituacao.Checked then
            try
                Result := StringReplace(Result,'<%>CRITERIO<%>','situação',[rfReplaceAll]);

                Situacoes := nil;
                ConfigureDataSet(DataModuleMain.ZConnections.ByName['ZConnection_BDO'].Connection
                                ,Situacoes
                                ,SQL_SITUACOES);

                ItensAExibir := '';

                MyModule.ProgressBar_GeracaoDeRelatorio.Position := 0;
                MyModule.ProgressBar_GeracaoDeRelatorio.Step := 1;
                MyModule.ProgressBar_GeracaoDeRelatorio.Max := Situacoes.RecordCount;
                MyModule.ProgressBar_GeracaoDeRelatorio.Show;
                Screen.Cursor := crHourGlass;

                Situacoes.First;
                { Em cada situação ... }
                while not Situacoes.Eof do
                begin
                    ItensAExibir := ItensAExibir + StringReplace(Template2,'<%>CRITERIONOME<%>','Famílias / ' + Situacoes.Fields[1].AsString,[rfReplaceAll]);
                    FamiliasAExibir := '';
                    QuantidadeTotalParcial := 0;
                    ValorTotalParcial := 0.0;
                    
                    Familias.First;
                    { Para cada família ... }
                    while not Familias.Eof do
                    begin
                        FamiliasAExibir := FamiliasAExibir + StringReplace(Template3,'<%>FAMILIA<%>',Familias.Fields[1].AsString,[rfReplaceAll]);

                        if Odd(Familias.RecNo) then
                            FamiliasAExibir := StringReplace(FamiliasAExibir,'<%>TR<%>','<TR CLASS="linhacor">',[])
                        else
                            FamiliasAExibir := StringReplace(FamiliasAExibir,'<%>TR<%>','<TR>',[]);

                        { Obtendo  o valor  de cada  ítem que  contém a  família  atual na
                        situação atual }
                        ConfigureDataSet(DataModuleMain.ZConnections.ByName['ZConnection_BDO'].Connection
                                        ,ItensCalculados
                                        ,MySQLFormat(MySQLFormat(SQL_ITENSEVALORES
                                                                ,[FVA_COTACOES
                                                                 ,GetMoeda
                                                                 ,SQL_PORSITUACOES
                                                                 ,'%u'])
                                                                ,[Situacoes.Fields[0].AsInteger
                                                                 ,Familias.Fields[0].AsInteger])
                                        ,False);

//                        ConfigureDataSet(DBConnection,ItensCalculados,Format(Format(SQL_ITENSEVALORES,[aCotacoes,SQL_PORSITUACOES,'%u']),[Situacoes.Fields[0].AsInteger,Familias.Fields[0].AsInteger]),False);

                        if MyModule.CheckBox_ExibirQuantidades.Checked then
                            FamiliasAExibir := StringReplace(FamiliasAExibir,'<%>QUANTIDADE<%>',ItensCalculados.FieldByName('QUANTIDADE').AsString,[]);
//                            FamiliasAExibir := StringReplace(FamiliasAExibir,'<%>QUANTIDADE<%>',FormatFloat(rs_formatovalorinteiro,ItensCalculados.RecordCount),[]);

//                        Somatorio := 0;
//                        while not ItensCalculados.Eof do
//                        begin
//                            Somatorio := Somatorio + ItensCalculados.Fields[0].AsCurrency;
//                            ItensCalculados.Next;
//                        end;

                        FamiliasAExibir := StringReplace(FamiliasAExibir,'<%>VALOR<%>',ItensCalculados.FieldByName('SOMATORIODOSITENS').AsString,[]);
//                        FamiliasAExibir := StringReplace(FamiliasAExibir,'<%>VALOR<%>',FormatFloat(Format(rs_formatovalormonetario,['"' + aMoedaFinal + '" ']),Somatorio),[]);

                        Inc(QuantidadeTotalParcial, ItensCalculados.FieldByName('QUANTIDADEINTEGRAL').AsInteger);
                        ValorTotalParcial := ValorTotalParcial + ItensCalculados.FieldByName('SOMATORIOINTEGRAL').AsCurrency;

                        Familias.Next;
                    end;

                    Inc(QuantidadeTotalGeral,QuantidadeTotalParcial);
                    ValorTotalGeral := ValorTotalGeral + ValorTotalParcial;

                    ItensAExibir := StringReplace(ItensAExibir,'<%>FAMILIAS<%>',FamiliasAExibir,[]);
                    ItensAExibir := StringReplace(ItensAExibir,'[%]DESCRICAOTOTAISPARCIAIS[%]',Descricao1,[]);
                    ItensAExibir := StringReplace(ItensAExibir,'[%]SOMATORIOQUANTIDADES[%]',FormatFloat('###,###,###,###',QuantidadeTotalParcial),[]);
                    ItensAExibir := StringReplace(ItensAExibir,'[%]SOMATORIOVALORES[%]',FormatFloat('"' + SimboloMonetario(GetMoeda) + '" ###,###,###,##0.00',ValorTotalParcial),[]);

                    MyModule.ProgressBar_GeracaoDeRelatorio.StepIt;
                    Situacoes.Next;
                end;
            finally
                if Assigned(Situacoes) then
                    Situacoes.Free;

                MyModule.DelayedHideProgressBar;
                Screen.Cursor := crDefault;
            end;
            
        finally
            if Assigned(Familias) then
                Familias.Free;

            if Assigned(ItensCalculados) then
                ItensCalculados.Free;

            Result := StringReplace(Result,'<%>ITENS<%>',ItensAExibir,[]);
            Result := StringReplace(Result,'[%]DESCRICAOTOTAISGERAIS[%]',Descricao2,[]);
            Result := StringReplace(Result,'[%]SOMATORIOTOTALQUANTIDADES[%]',FormatFloat('###,###,###,###',QuantidadeTotalGeral),[]);
            Result := StringReplace(Result,'[%]SOMATORIOTOTALVALORES[%]',FormatFloat('"' + SimboloMonetario(GetMoeda) + '" ###,###,###,##0.00',ValorTotalGeral),[]);
        end;
end;

function TBDODataModule_Relatorio_FAM.GetMoeda: Byte;
begin
    Result := Byte(Succ(MyModule.ComboBox_PRO_TI_MOEDA.ItemIndex));
end;

end.
