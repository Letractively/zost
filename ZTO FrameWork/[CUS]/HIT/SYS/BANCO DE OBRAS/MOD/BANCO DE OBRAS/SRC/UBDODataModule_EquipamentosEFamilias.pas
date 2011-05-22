unit UBDODataModule_EquipamentosEFamilias;

interface

uses
  	Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  	Dialogs, ActnList, ImgList, DB, StdCtrls, ExtCtrls 

  	, UBDODataModule,  UXXXTypesConstantsAndClasses, _ActnList,

  	ZSqlUpdate, ZAbstractRODataset, ZAbstractDataset, ZAbstractTable, ZDataset,
  	CFDBValidationChecks, Menus, ActnPopup;

type
  	TBDODataModule_EquipamentosEFamilias = class(TBDODataModule)
	    Action_EQP_Insert: TAction;
    	Action_EQP_Edit: TAction;
	    Action_EQP_Delete: TAction;
    	Action_EQP_LoadDataFile: TAction;
	    Action_FAM_Insert: TAction;
    	Action_FAM_Edit: TAction;
	    Action_FAM_Delete: TAction;
	    EQUIPAMENTOS: TZQuery;
	    EQUIPAMENTOSIN_EQUIPAMENTOS_ID: TIntegerField;
	    EQUIPAMENTOSVA_MODELO: TStringField;
    	EQUIPAMENTOSFL_LUCROBRUTO: TFloatField;
	    EQUIPAMENTOSFL_VALORUNITARIO: TFloatField;
    	EQUIPAMENTOSTI_MOEDA: TSmallintField;
	    EQUIPAMENTOSBO_DISPONIVEL: TSmallintField;
    	FAMILIAS: TZQuery;
	    FAMILIASTI_FAMILIAS_ID: TSmallintField;
    	FAMILIASVA_DESCRICAO: TStringField;
	    UpdateSQL_EQP: TZUpdateSQL;
	    UpdateSQL_FAM: TZUpdateSQL;
    	DataSource_FAM: TDataSource;
	    DataSource_EQP: TDataSource;
    	CFDBValidationChecks_EQP: TCFDBValidationChecks;
	    CFDBValidationChecks_FAM: TCFDBValidationChecks;
    	OpenDialog_EQP_CSV: TOpenDialog;
        Action_EQP_Relatorio: TAction;
        Action_FAM_Relatorio: TAction;
        PopupActionBar_RecordInformation: TPopupActionBar;
        MenuItem_InformacoesSobreORegistro: TMenuItem;
        EQUIPAMENTOSFL_IPI: TFloatField;
        procedure Action_EQP_DeleteExecute(Sender: TObject);
        procedure Action_EQP_EditExecute(Sender: TObject);
        procedure Action_EQP_InsertExecute(Sender: TObject);
	    procedure Action_FAM_InsertExecute(Sender: TObject);
    	procedure Action_FAM_EditExecute(Sender: TObject);
	    procedure Action_FAM_DeleteExecute(Sender: TObject);
	    procedure EQUIPAMENTOSTI_MOEDASetText(Sender: TField; const Text: string);
    	procedure EQUIPAMENTOSTI_MOEDAGetText(Sender: TField; var Text: string; DisplayText: Boolean);
	    procedure Action_EQP_LoadDataFileExecute(Sender: TObject);
    	procedure EQUIPAMENTOSFL_LUCROBRUTOGetText(Sender: TField; var Text: string; DisplayText: Boolean);
    	procedure EQUIPAMENTOSFL_VALORUNITARIOGetText(Sender: TField; var Text: string; DisplayText: Boolean);
    	procedure EQUIPAMENTOSBO_DISPONIVELGetText(Sender: TField; var Text: string; DisplayText: Boolean);
        procedure Action_EQP_RelatorioExecute(Sender: TObject);
        procedure Action_FAM_RelatorioExecute(Sender: TObject);
        procedure Action_RecordInformationExecute(Sender: TObject);
        procedure EQUIPAMENTOSFL_IPIGetText(Sender: TField; var Text: string; DisplayText: Boolean);
 	private
    	{ Private declarations }
	    procedure CSV2SQLEquipamentos(aArquivoCSV: TFileName; var aRegistrosProcessados: Cardinal; var aScript: String; aSalvarScript: Boolean = False);
	protected
        procedure SetRefreshSQL(const aZQuery: TZQuery; const aDBAction: TDBAction; out aRefreshSQL: AnsiString); override;
    	procedure DoBeforeDelete(aDataSet: TDataSet); override;
	    procedure DoBeforePost(aDataSet: TDataSet); override;
  	public
    	{ Public declarations }
        procedure LocalizarFamiliaPorDescricao(const aLabeledEdit: TLabeledEdit);
        procedure LocalizarEquipamentoPorModeloEValor(const aLabeledEdit: TLabeledEdit;
                                                      const aComboBox: TComboBox;
                                                      const aEdit: TEdit);
	    procedure DBButtonClick_EQP(aDBButton: TDBButton; aComponentToFocusOnInsertAndEdit: TWinControl = nil);
    	procedure DBButtonClick_FAM(aDBButton: TDBButton; aComponentToFocusOnInsertAndEdit: TWinControl = nil);
    	procedure DoDataChange(aSender: TObject; aField: TField); override;
  	end;

implementation

uses
	StrUtils,

    UBDOForm_EquipamentosEFamilias, UXXXDataModule, UBDOTypesConstantsAndClasses,
    UCFDBGrid;

{$R *.dfm}

resourcestring
	RS_IMPORTACAO_ETAPA1 = 'Etapa 1: Pré-sincronização automática'#13#10 +
    'A intenção desta etapa é garantir que o conjunto de dados local seja idên'+
    'tico ao existente no servidor, evitando problemas de inconsistência no fi'+
    'nal da importação do arquivo de dados. Esse procedimento pode levar algun'+
    's mintos, dependendo da quantidade de dados sendo sincronizados.';
    RS_IMPORTACAO_ETAPA2 = 'Etapa 2: Importando arquivo de dados...'#13#10'Est'+
    'e processo pode demorar alguns minutos dependendo da velocidade do seu co'+
    'mputador. Por favor, queira aguardar...';
    RS_IMPORTACAO_ETAPA3 = 'Etapa 3: Pós-sincronização automática'#13#10 +
    'De forma semelhante ao que acontece na primeira etapa, aqui está sendo re'+
    'alizada uma sincroniza por difereças. O objetivo desta sincronização pós '+
    'importação é enviar ao servidor a nova lista de equipamentos, a qual foi '+
    'carregada na etapa anterior.';

procedure TBDODataModule_EquipamentosEFamilias.Action_EQP_DeleteExecute(Sender: TObject);
begin
  	inherited;
    DBButtonClick_EQP(dbbDelete);
end;

procedure TBDODataModule_EquipamentosEFamilias.Action_EQP_InsertExecute(Sender: TObject);
begin
	inherited;
    DBButtonClick_EQP(dbbInsert,TBDOForm_EquipamentosEFamilias(Owner).DBEdit_EQP_VA_MODELO);
end;

procedure TBDODataModule_EquipamentosEFamilias.CSV2SQLEquipamentos(aArquivoCSV: TFileName; var aRegistrosProcessados: Cardinal; var aScript: String; aSalvarScript: Boolean = False);
const
	IMPORT_TEMPLATE =
//    'INSERT INTO EQUIPAMENTOS (VA_MODELO, FL_LUCROBRUTO, FL_VALORUNITARIO, BO_DISPONIVEL, TI_MOEDA)'#13#10 +
//    'VALUES %s' + // ('MODELO',1.01,1.0010,TRUE,1)#13#10
//    'ON DUPLICATE KEY'#13#10 +
//    'UPDATE FL_LUCROBRUTO = VALUES(FL_LUCROBRUTO)'#13#10 +
//    '     , FL_VALORUNITARIO = VALUES(FL_VALORUNITARIO)'#13#10 +
//    '     , BO_DISPONIVEL = TRUE'#13#10 +
//    '     , TI_MOEDA = VALUES(TI_MOEDA)';

'# EXCLUI A CÓPIA DA TABELA TEMPORÁRIA DA TABELA "EQUIPAMENTOS", SE ESTA EXISTIR'#13#10 +
'DROP TEMPORARY TABLE IF EXISTS _EQUIPAMENTOS;'#13#10#13#10 +

'# CRIA A CÓPIA TEMPORÁRIA DA TABELA "EQUIPAMENTOS"'#13#10 +
'CREATE TEMPORARY TABLE _EQUIPAMENTOS ('#13#10 +
'	IN_EQUIPAMENTOS_ID INTEGER UNSIGNED,'#13#10 +
'	VA_MODELO VARCHAR(64),'#13#10 +
'	INDEX (IN_EQUIPAMENTOS_ID)'#13#10 +
') SELECT IN_EQUIPAMENTOS_ID'#13#10 +
'       , VA_MODELO'#13#10 +
'    FROM EQUIPAMENTOS;'#13#10#13#10 +

'# EXCLUI A TABELA TEMPORÁRIA DE ARQUIVO DE DADOS IMPORTADOS'#13#10 +
'DROP TEMPORARY TABLE IF EXISTS _DATAFILE;'#13#10#13#10 +

'# CRIA A TABELA TEMPORÁRIA DE ARQUIVO DE DADOS IMPORTADOS'#13#10 +
'CREATE TEMPORARY TABLE _DATAFILE ('#13#10 +
'	VA_MODELO VARCHAR(64),'#13#10 +
'	FL_LUCROBRUTO FLOAT(12,4),'#13#10 +
'	FL_IPI FLOAT(12,4),'#13#10 +
'	FL_VALORUNITARIO FLOAT(12,4),'#13#10 +
'	TI_MOEDA TINYINT,'#13#10 +
'	INDEX(VA_MODELO)'#13#10 +
');'#13#10#13#10 +

'# INSERE OS DADOS NA TABELA DE ARQUIVO DE DADOS IMPORTADOS'#13#10 +
'INSERT INTO _DATAFILE (VA_MODELO, FL_LUCROBRUTO, FL_IPI, FL_VALORUNITARIO, TI_MOEDA)'#13#10 +
'VALUES %s;'#13#10#13#10 +

'# CONFIGURA BO_DISPONIVEL = FALSE NA TABELA REAL PARA TODOS OS REGISTROS QUE'#13#10 +
'# EXISTEM NA TABELA REAL MAS NÃO NA TABELA TEMPORÁRIA E APENAS PARA AQUELES EM'#13#10 +
'# QUE BO_DISPONIVEL = TRUE'#13#10 +
'UPDATE EQUIPAMENTOS EQP'#13#10 +
'   SET EQP.BO_DISPONIVEL = FALSE'#13#10 +
' WHERE EQP.BO_DISPONIVEL'#13#10 +
'   AND EQP.IN_EQUIPAMENTOS_ID IN (SELECT _EQP.IN_EQUIPAMENTOS_ID'#13#10 +
'                                    FROM _EQUIPAMENTOS _EQP'#13#10 +
'                                   WHERE _EQP.VA_MODELO NOT IN (SELECT _DAT.VA_MODELO'#13#10 +
'                                                                  FROM _DATAFILE _DAT));'#13#10#13#10 +

'# ATUALIZA OS REGITROS DA TABELA REAL COM OS DADOS EXISTENTES NA TABELA'#13#10 +
'# TEMPORÁRIA PARA OS REGISTROS QUE EXISTEM EM AMBAS AS TABELAS'#13#10 +
'UPDATE EQUIPAMENTOS EQP'#13#10 +
'  JOIN _DATAFILE _DAT USING(VA_MODELO)'#13#10 +
'   SET EQP.FL_LUCROBRUTO = _DAT.FL_LUCROBRUTO'#13#10 +
'     , EQP.FL_IPI = _DAT.FL_IPI'#13#10 +
'     , EQP.FL_VALORUNITARIO = _DAT.FL_VALORUNITARIO'#13#10 +
'     , EQP.TI_MOEDA = _DAT.TI_MOEDA'#13#10 +
'     , EQP.BO_DISPONIVEL = TRUE;'#13#10#13#10 +

//'UPDATE EQUIPAMENTOS EQP'#13#10 +
//'     , _DATAFILE _DAT'#13#10 +
//'   SET EQP.FL_LUCROBRUTO = _DAT.FL_LUCROBRUTO'#13#10 +
//'     , EQP.FL_VALORUNITARIO = _DAT.FL_VALORUNITARIO'#13#10 +
//'     , EQP.TI_MOEDA = _DAT.TI_MOEDA'#13#10 +
//'     , EQP.BO_DISPONIVEL = TRUE'#13#10 +
//' WHERE EQP.VA_MODELO = _DAT.VA_MODELO;'#13#10#13#10 +


'# INSERE OS NOVOS REGISTROS EXISTENTES NA TABELA TEMPORÁRIA NA TABELA REAL'#13#10 +
'INSERT INTO EQUIPAMENTOS (VA_MODELO, FL_LUCROBRUTO, FL_IPI, FL_VALORUNITARIO, TI_MOEDA, BO_DISPONIVEL)'#13#10 +
'SELECT *'#13#10 +
'     , TRUE AS BO_DISPONIVEL'#13#10 +
'  FROM _DATAFILE'#13#10 +
' WHERE VA_MODELO NOT IN (SELECT VA_MODELO'#13#10 +
'                           FROM EQUIPAMENTOS);';

	VALUES_TEMPLATE = '(%s,%.4f,%.4f,%.4f,%u)';//'(%s,%.4f,%.4f,TRUE,%u)';
var
    ArquivoCSV: TextFile;
    Linha, Modelo, StrLucro, StrIpi, StrValor, StrMoeda: ShortString;
    Values: String;
    Lucro, Ipi, Valor: Single;
    Moeda: Byte;
    TempStringList: TStringList;
    FirstIteration: Boolean;
begin
	TempStringList := nil;

    try
	    AssignFile(ArquivoCSV,aArquivoCSV);
	    FileMode := fmOpenRead;
    	Reset(ArquivoCSV);

    	aRegistrosProcessados := 0;
        aScript := '';
        Values := '';
        FirstIteration := True;
        TempStringList := TStringList.Create;

//        GetLocaleFormatSettings(1033,FormatSettings);

	    while not Eof(ArquivoCSV) do
    	begin
		    Modelo := '';
//		    Lucro := 0;
//			Valor := 0;
//            Moeda := 3;

		    ReadLn(ArquivoCSV,Linha);

            // Modelo
            Modelo := Trim(GetPartFromDelimitedString(Linha,0,';',TempStringList));
//            Modelo := Copy(Linha,1,Pred(Pos(';',Linha)));
//            Delete(Linha,1,Pos(';',Linha));

            // Lucro (invariavelmente troca o separador de decimal do sistema por um ponto, padrão no MySQL
            StrLucro := Trim(StringReplace(GetPartFromDelimitedString(Linha,1,';',TempStringList),DecimalSeparator,'.',[]));
//            Lucro := StringReplace(Copy(Linha,1,Pred(Pos(';',Linha))),DecimalSeparator,'.',[]);
//            Delete(Linha,1,Pos(';',Linha));

            // IPI
            StrIpi := Trim(StringReplace(GetPartFromDelimitedString(Linha,2,';',TempStringList),DecimalSeparator,'.',[]));

            // Valor
            StrValor := Trim(StringReplace(GetPartFromDelimitedString(Linha,3,';',TempStringList),DecimalSeparator,'.',[]));
//            Valor := StringReplace(Copy(Linha,1,Pred(Pos(';',Linha))),DecimalSeparator,'.',[]);
//            Delete(Linha,1,Pos(';',Linha));

            // Moeda

            StrMoeda := Trim(GetPartFromDelimitedString(Linha,4,';',TempStringList));
//            Moeda := Linha;

		    if (Modelo <> '') and (StrLucro <> '') and (StrIpi <> '') and (StrValor <> '') and (StrMoeda <> '') then
			    try
				    Lucro := StrToFloat(StringReplace(StrLucro,'.',DecimalSeparator,[])) * 100;
				    Ipi   := StrToFloat(StringReplace(StrIpi,'.',DecimalSeparator,[])) * 100;
                	Valor := StrToFloat(StringReplace(StrValor,'.',DecimalSeparator,[]));
                    Moeda := StrToInt(StrMoeda);

                    if not FirstIteration then
                    	Values := Values + '     , ' + MySQLFormat(VALUES_TEMPLATE,['x' + QuotedStr(Hex(Modelo))
                                                                                   ,Lucro
                                                                                   ,Ipi
                                                                                   ,Valor
                                                                                   ,Moeda]) + #13#10
                    else
                    	Values := MySQLFormat(VALUES_TEMPLATE,['x' + QuotedStr(Hex(Modelo))
                                                              ,Lucro
                                                              ,Ipi
                                                              ,Valor
                                                              ,Moeda]) + #13#10;

    				Inc(aRegistrosProcessados);
					FirstIteration := False;
				except
                	on EConvertError do
                    	Continue;
                end
    	end;
    finally
    	TempStringList.Free;
	    CloseFile(ArquivoCSV);
    end;

    if aRegistrosProcessados > 0 then
    begin
        { Juntando Tudo }
        aScript := Format(IMPORT_TEMPLATE,[Values]);

	    if aSalvarScript then
			SaveTextFile(aScript, ChangeFileExt(aArquivoCSV,'.sql'));
    end;
end;

//procedure TBDODataModule_EquipamentosEFamilias.Action_EQP_LoadDataFileExecute(Sender: TObject);
//var
//	QtdRegistros: Cardinal;
//  	Script, ErrorMsg, SuccessMsg: String;
//  	TudoOK: Boolean;
//begin
//	inherited;
//    TudoOK := False;
//    if MessageBox(Application.Handle,'O processo de importação de arquivo de dados necessita de uma conexão ativa com ' + 'o servidor central pois serão realizadas duas sincronizações automáticas, uma antes e outra após a importação de dados. Você tem certeza de que está conectado à rede com acesso ao servidor central e está ciente destas duas sincronizações?','Uma conexão ativa é requerida!',MB_ICONWARNING or MB_YESNO) = idYes then
//        if OpenDialog_EQP_CSV.Execute then
//        begin
//        	CSV2SQLEquipamentos(OpenDialog_EQP_CSV.FileName,QtdRegistros,Script,True);
//    	    if QtdRegistros > 0 then
//        	begin
//		        if MessageBox(Application.Handle,PChar('O arquivo CSV foi carregado com sucesso! ' +
//		        IntToStr(QtdRegistros) + ' registros válidos* foram corretamente sel' +
//        		'ecionados para inclusão ou atualização. Nenhuma verificação de dupl' +
//		        'icidade foi feita no arquivo CSV, o que siginifica que na inclusão ' +
//        		'ou atualização valerá sempre o último registro inserido/atualizado,' +
//		        ' sendo descartados valores repetidos anteriores. Deseja mesclar as i' +
//		        'nformações obtidas do arquivo CSV, com o banco de dados?'#13#10 +
//		        #13#10'* Um registro é considerado válido quando as quatro informações' +
//        		' que ele detém (Modelo, L.B., Valor e Moeda) não são nulas e quando tais i' +
//		        'nformações são válidas individualmente'),'Deseja mesclar as informações?',MB_ICONQUESTION or MB_YESNO) = idYes then
//                	try
//                        ErrorMsg := 'Não foi possível realizar a sincronização pré-importação. A importação não foi realizada.';
//                        SuccessMsg := 'Todos os registros foram carregados com sucesso!';
//                        QtdRegistros := MB_ICONINFORMATION;
//
//                        { 1. sincronização cega, se sucesso, passa! }
//                        if ShowAutoSyncForm(RS_IMPORTACAO_ETAPA1) = mrOk then
//                        begin
//                        	{ 2. Importação de equipamentos, se sucesso, passa! }
//                            try
//                            	try
//                                	StartTransaction(DataModuleAlpha.ZConnections[0].Connection);
//
//                                	ShowProcessingForm(RS_IMPORTACAO_ETAPA2);
//    	                        	ErrorMsg := 'Ocorreram erros durante a importação dos dos dados. A importação não foi realizada.';
//                                    { Primeiramente configuramos todos os equipamentos como INDISPONIVEIS. Isso gera muitas entradas do tipo UPD no delta }
//                                    ExecuteQuery(DataModuleAlpha.ZConnections[0].Connection,'UPDATE EQUIPAMENTOS SET BO_DISPONIVEL = 0');
//                                    Application.ProcessMessages;
//            	                    { Em seguida aplicamos o Script }
//                                    ExecuteQuery(DataModuleAlpha.ZConnections[0].Connection,Script);
//
//                                    { TODO -oCarlos Feitoza -cDÚVIDA : Pode ser que esse commit não seja aqui... }
//                                    CommitWork(DataModuleAlpha.ZConnections[0].Connection);
//                                finally
//    	                            HideProcessingForm;
//                                end;
//
//                                { 3. Sincronização cega. Mesmo não sendo bem
//                                sucedida, a importação foi cocluída mas não é
//                                recomendável usar o programa até que ele tenha
//                                sido sincronizado }
//                                if ShowAutoSyncForm(RS_IMPORTACAO_ETAPA3) <> mrOk then
//                                begin
//                                    SuccessMsg := SuccessMsg + ' Apesar disso, não foi possível realizar a sincronização pós-importação. Não é recomendável utilizar o programa até que os dados sejam sincronizados. Por favor envie os snapshots (local e remoto) e a lista de preços (' + ExtractFileName(OpenDialog_EQP_CSV.FileName) + ') para o desenvolvedor imediatamente para análise, informando-o desta mensagem.';
//                                    QtdRegistros := MB_ICONWARNING;
//                                end;
//                                TudoOk := True;
//                            except
//                            	on E: Exception do
//                                begin
//                                    RollbackWork(DataModuleAlpha.ZConnections[0].Connection);
//                                	ErrorMsg := ErrorMsg + ' A mensagem de erro foi: '#13#10#13#10 + E.Message;
//									SaveTextFile(ErrorMsg,ExtractFilePath(OpenDialog_EQP_CSV.FileName) + 'Erros.log');
//                                    ErrorMsg := ErrorMsg + #13#10#13#10'Esta mensagem de erro foi salva no mesmo diretório onde a lista de equipamentos está com o nome de "Erros.log". Envie este arquivo, juntamente com os snapshots (local e remoto) e a lista de preços (' + ExtractFileName(OpenDialog_EQP_CSV.FileName) + ') para o desenvolvedor imediatamente para análise.';
//                                end;
//                            end;
//                        end;
//                    finally
//                    	if TudoOk then
//                        	MessageBox(Application.Handle,PChar(SuccessMsg),'Mesclagem concluída',QtdRegistros)
//                        else
//                        	MessageBox(Application.Handle,PChar(ErrorMsg),'Erros durante a mesclagem',MB_ICONERROR);
//
//                    	TBDOForm_EquipamentosEFamilias(Owner).Action_EQP_Refresh.Execute;
//                    end;
//        	end
//        	else
//        		MessageBox(Application.Handle,'O arquivo CSV está vazio, não é válido ou está corrompido. Nada foi feito.','Arquivo CSV inválido',MB_ICONERROR);
//        end;
//end;

procedure TBDODataModule_EquipamentosEFamilias.Action_EQP_LoadDataFileExecute(Sender: TObject);
var
	QtdRegistros, FinalMessageType: Cardinal;
  	Script, FinalMessage: String;
begin
	inherited;
    FinalMessage := '';
    FinalMessageType := 0;

    if MessageBox(Application.Handle,'O processo de importação de arquivo de dados necessita de uma conexão ativa com ' + 'o servidor central pois serão realizadas duas sincronizações automáticas, uma antes e outra após a importação de dados. Você tem certeza de que está conectado à rede com acesso ao servidor central e está ciente destas duas sincronizações?','Uma conexão ativa é requerida!',MB_ICONWARNING or MB_YESNO) = idYes then
        if OpenDialog_EQP_CSV.Execute then
        begin
        	CSV2SQLEquipamentos(OpenDialog_EQP_CSV.FileName,QtdRegistros,Script,True);
    	    if QtdRegistros > 0 then
        	begin
		        if MessageBox(Application.Handle,PChar('O arquivo CSV foi carregado com sucesso! ' +
		        IntToStr(QtdRegistros) + ' registros válidos* foram corretamente sel' +
        		'ecionados para inclusão ou atualização. Nenhuma verificação de dupl' +
		        'icidade foi feita no arquivo CSV, o que siginifica que na inclusão ' +
        		'ou atualização valerá sempre o último registro inserido/atualizado,' +
		        ' sendo descartados valores repetidos anteriores. Deseja mesclar as i' +
		        'nformações obtidas do arquivo CSV, com o banco de dados?'#13#10 +
		        #13#10'* Um registro é considerado válido quando as cinco informações' +
        		' que ele detém (Modelo, L.B., I.P.I., Valor e Moeda) não são nulas e quando tais i' +
		        'nformações são válidas individualmente'),'Deseja mesclar as informações?',MB_ICONQUESTION or MB_YESNO) = idYes then
                	try
                        try
                            FinalMessage := 'Não foi possível realizar a sincronização pré-importação. A importação não foi realizada.';
                            FinalMessageType := MB_ICONERROR;
	                        { 1.0 sincronização automática... }
    	                    if ShowAutoSyncForm(RS_IMPORTACAO_ETAPA1) = mrOk then
        	                begin
	                        	{ 2.0 Importação de Equipamentos... }

                                { 2.1 Iniciando a transação... }
    	                        StartTransaction(DataModuleMain.ZConnections[0].Connection);

                                { 2.2 Exibindo o form de processamento demorado
                                e configurando a mensagem padrão de erro para
                                esta etapa }
                              	ShowProcessingForm(RS_IMPORTACAO_ETAPA2);
  	                        	FinalMessage := 'Ocorreram erros durante a imp'+
                                'ortação dos dos dados. A importação não foi r'+
                                'ealizada.';

                                {2.3 Executamos o script de importação de dados.
                                Intermamente tudo já é realizado para
                                atualização de todas as tabelas envolvidas no
                                processo, inclusive o Delta }
                                MySQLExecuteSQLScript(DataModuleMain.ZConnections[0].Connection
                                                     ,''
                                                     ,Script);

                                { 2.4 Se chegar aqui confirma os dados
                                importados, o que significa que a importação foi
                                bem-sucedida, mas não que o processo inteiro foi
                                bem sucedido. O commit tem de ser feito aqui por
                                que a sincronização que vai ocorrer depois
                                precisa dos dados no banco de dados pois usa uma
                                conexão distinta }
                                CommitWork(DataModuleMain.ZConnections[0].Connection);

                            	{ 2.5 Ocultamos o form de processamento e
                                setamos o tipo de mensagem padrão e a mensagem
                                que deve ser exibida no final }
								HideProcessingForm;
                                Application.ProcessMessages;
                                FinalMessage := 'Todos os registros foram carregados com sucesso!';
                                FinalMessageType := MB_ICONINFORMATION;
                                
                                { 3.0 Sincronização automática... Tudo estará OK
                                apenas se esta última sincronização for
                                bem-sucedida, do contrário apenas os dados terão
                                sido importados, mas não sincronizados! A função
                                ShowAutoSyncForm não deve levantar exceções, por
                                isso é seguro manter a mensagem de sucesso antes
                                de sua chamada }
                                if ShowAutoSyncForm(RS_IMPORTACAO_ETAPA3) <> mrOk then
                                begin
                                    FinalMessage := FinalMessage + ' Apesar disso,'+
                                    ' não foi possível realizar a sincronizaçã'+
                                    'o pós-importação. Não é recomendável util'+
                                    'izar o programa até que os dados sejam si'+
                                    'ncronizados. Por favor tente realizar uma'+
                                    ' sincronização por diferenças usando o FT'+
                                    'P Synchronizer. Caso esta sincronização t'+
                                    'ambém não seja bem-sucedida, envie os sna'+
                                    'pshots (local e remoto) e a lista de preç'+
                                    'os (' + ExtractFileName(OpenDialog_EQP_CSV.FileName) +
                                    ') para o desenvolvedor imediatamente para'+
                                    ' análise, informando-o desta mensagem.';
                                    FinalMessageType := MB_ICONWARNING;
                                end;
                            end;
                        except
                            on E: Exception do
                            begin
                            	HideProcessingForm;
                                RollbackWork(DataModuleMain.ZConnections[0].Connection);
                                FinalMessage := FinalMessage + ' A mensagem de'+
                                ' erro foi: '#13#10#13#10 + E.Message;
                                SaveTextFile(FinalMessage,ExtractFilePath(OpenDialog_EQP_CSV.FileName) + 'Erros.log');
                                FinalMessage := FinalMessage + #13#10#13#10'Es'+
                                'ta mensagem de erro foi salva no mesmo diretó'+
                                'rio onde a lista de equipamentos está com o n'+
                                'ome de "Erros.log". Envie este arquivo, junta'+
                                'mente com os snapshots (local e remoto) e a l'+
                                'ista de preços (' + ExtractFileName(OpenDialog_EQP_CSV.FileName) +
                                ') para o desenvolvedor imediatamente para aná'+
                                'lise.';
                            end;
                        end;

                    finally
						MessageBox(Application.Handle,PChar(FinalMessage),'Importação de arquivo de dados',FinalMessageType);
                    	TBDOForm_EquipamentosEFamilias(Owner).Action_EQP_Refresh.Execute;
                    end;
        	end
        	else
        		MessageBox(Application.Handle,'O arquivo CSV está vazio, não é válido ou está corrompido. Nada foi feito.','Arquivo CSV inválido',MB_ICONERROR);
        end;
end;

procedure TBDODataModule_EquipamentosEFamilias.Action_EQP_RelatorioExecute(Sender: TObject);
begin
    inherited;
    ExibirGeradorDeRelatorioDeEquipamentos;
end;

procedure TBDODataModule_EquipamentosEFamilias.Action_FAM_DeleteExecute(Sender: TObject);
begin
  	inherited;
    DBButtonClick_FAM(dbbDelete);
end;

procedure TBDODataModule_EquipamentosEFamilias.Action_FAM_EditExecute(Sender: TObject);
begin
  	inherited;
    DBButtonClick_FAM(dbbEdit,TBDOForm_EquipamentosEFamilias(Owner).DBEdit_FAM_VA_DESCRICAO);
end;

procedure TBDODataModule_EquipamentosEFamilias.Action_FAM_InsertExecute(Sender: TObject);
begin
  	inherited;
    DBButtonClick_FAM(dbbInsert,TBDOForm_EquipamentosEFamilias(Owner).DBEdit_FAM_VA_DESCRICAO);
end;

procedure TBDODataModule_EquipamentosEFamilias.Action_FAM_RelatorioExecute(Sender: TObject);
begin
    inherited;
    ExibirGeradorDeRelatorioDeFamilias;
end;

procedure TBDODataModule_EquipamentosEFamilias.Action_RecordInformationExecute(Sender: TObject);
begin
    inherited;
    if TCFDBGrid(PopupActionBar_RecordInformation.PopupComponent).DataSource.DataSet = EQUIPAMENTOS then
        ShowRecordInformationForm(DataModuleMain.ZConnections.ByName['ZConnection_BDO'].Connection
                                 ,'EQUIPAMENTOS'
                                 ,'IN_EQUIPAMENTOS_ID'
                                 ,EQUIPAMENTOSIN_EQUIPAMENTOS_ID.AsInteger)
    else if TCFDBGrid(PopupActionBar_RecordInformation.PopupComponent).DataSource.DataSet = FAMILIAS then
        ShowRecordInformationForm(DataModuleMain.ZConnections.ByName['ZConnection_BDO'].Connection
                                 ,'FAMILIAS'
                                 ,'TI_FAMILIAS_ID'
                                 ,FAMILIASTI_FAMILIAS_ID.AsInteger);
end;

procedure TBDODataModule_EquipamentosEFamilias.Action_EQP_EditExecute(Sender: TObject);
begin
  	inherited;
    DBButtonClick_EQP(dbbEdit,TBDOForm_EquipamentosEFamilias(Owner).DBEdit_EQP_VA_MODELO);
end;

procedure TBDODataModule_EquipamentosEFamilias.DBButtonClick_EQP(aDBButton: TDBButton; aComponentToFocusOnInsertAndEdit: TWinControl = nil);
begin
	DBButtonClick(EQUIPAMENTOS,aDBButton,aComponentToFocusOnInsertAndEdit);
end;

procedure TBDODataModule_EquipamentosEFamilias.DBButtonClick_FAM(aDBButton: TDBButton; aComponentToFocusOnInsertAndEdit: TWinControl = nil);
begin
	DBButtonClick(FAMILIAS,aDBButton,aComponentToFocusOnInsertAndEdit);
end;

procedure TBDODataModule_EquipamentosEFamilias.DoBeforeDelete(aDataSet: TDataSet);
begin
	if aDataSet = EQUIPAMENTOS then
    	CFDBValidationChecks_EQP.ValidateBeforeDelete
    else if aDataSet = FAMILIAS then
    	CFDBValidationChecks_FAM.ValidateBeforeDelete;

  	inherited;
end;

procedure TBDODataModule_EquipamentosEFamilias.DoBeforePost(aDataSet: TDataSet);
begin
	inherited; { Verifica permissão }

	if aDataSet = EQUIPAMENTOS then
    	CFDBValidationChecks_EQP.ValidateBeforePost
    else if aDataSet = FAMILIAS then
    	CFDBValidationChecks_FAM.ValidateBeforePost;
    { Outras validações específicas de negócio}
end;

procedure TBDODataModule_EquipamentosEFamilias.DoDataChange(aSender: TObject; aField: TField);
var
	ButtonEnabled: array [0..9] of Boolean;
begin
  	inherited;

	DBButtonsToggle(TDataSource(aSender).DataSet
                   ,ButtonEnabled[0]
                   ,ButtonEnabled[1]
                   ,ButtonEnabled[2]
                   ,ButtonEnabled[3]
                   ,ButtonEnabled[4]
                   ,ButtonEnabled[5]
                   ,ButtonEnabled[6]
                   ,ButtonEnabled[7]
                   ,ButtonEnabled[8]
                   ,ButtonEnabled[9]);

    if aSender = DataSource_EQP then
    begin
        SafeSetActionEnabled(TBDOForm_EquipamentosEFamilias(Owner).Action_EQP_First,ButtonEnabled[0]);
        SafeSetActionEnabled(TBDOForm_EquipamentosEFamilias(Owner).Action_EQP_Previous,ButtonEnabled[1]);
        SafeSetActionEnabled(TBDOForm_EquipamentosEFamilias(Owner).Action_EQP_Next,ButtonEnabled[2]);
        SafeSetActionEnabled(TBDOForm_EquipamentosEFamilias(Owner).Action_EQP_Last,ButtonEnabled[3]);
        SafeSetActionEnabled(Action_EQP_Insert,ButtonEnabled[4] and Action_EQP_Insert.Allowed);
        SafeSetActionEnabled(Action_EQP_Delete,ButtonEnabled[5] and Action_EQP_Delete.Allowed);
        SafeSetActionEnabled(Action_EQP_Edit,ButtonEnabled[6] and Action_EQP_Edit.Allowed);
        SafeSetActionEnabled(TBDOForm_EquipamentosEFamilias(Owner).Action_EQP_Post,ButtonEnabled[7]);
        SafeSetActionEnabled(TBDOForm_EquipamentosEFamilias(Owner).Action_EQP_Cancel,ButtonEnabled[8]);
        SafeSetActionEnabled(TBDOForm_EquipamentosEFamilias(Owner).Action_EQP_Refresh,ButtonEnabled[9]);

		TBDOForm_EquipamentosEFamilias(Owner).Label_EQP_EquipamentosListadosValor.Caption := FormatFloat('###,###,##0',DataSource_EQP.DataSet.RecordCount);
    end
    else if aSender = DataSource_FAM then
    begin
        SafeSetActionEnabled(TBDOForm_EquipamentosEFamilias(Owner).Action_FAM_First,ButtonEnabled[0]);
        SafeSetActionEnabled(TBDOForm_EquipamentosEFamilias(Owner).Action_FAM_Previous,ButtonEnabled[1]);
        SafeSetActionEnabled(TBDOForm_EquipamentosEFamilias(Owner).Action_FAM_Next,ButtonEnabled[2]);
        SafeSetActionEnabled(TBDOForm_EquipamentosEFamilias(Owner).Action_FAM_Last,ButtonEnabled[3]);
        SafeSetActionEnabled(Action_FAM_Insert,ButtonEnabled[4] and Action_FAM_Insert.Allowed);
        SafeSetActionEnabled(Action_FAM_Delete,ButtonEnabled[5] and Action_FAM_Delete.Allowed);
        SafeSetActionEnabled(Action_FAM_Edit,ButtonEnabled[6] and Action_FAM_Edit.Allowed);
        SafeSetActionEnabled(TBDOForm_EquipamentosEFamilias(Owner).Action_FAM_Post,ButtonEnabled[7]);
        SafeSetActionEnabled(TBDOForm_EquipamentosEFamilias(Owner).Action_FAM_Cancel,ButtonEnabled[8]);
        SafeSetActionEnabled(TBDOForm_EquipamentosEFamilias(Owner).Action_FAM_Refresh,ButtonEnabled[9]);

		TBDOForm_EquipamentosEFamilias(Owner).Label_FAM_FamiliasListadasValor.Caption := FormatFloat('###,###,##0',DataSource_FAM.DataSet.RecordCount);
    end;
end;

procedure TBDODataModule_EquipamentosEFamilias.EQUIPAMENTOSBO_DISPONIVELGetText(Sender: TField; var Text: string; DisplayText: Boolean);
begin
  	inherited;
    Text := IfThen(DisplayText,GetElementByIndex(Sender.AsInteger,['Não','Sim']),Sender.AsString);
end;

procedure TBDODataModule_EquipamentosEFamilias.EQUIPAMENTOSFL_IPIGetText(Sender: TField; var Text: string; DisplayText: Boolean);
begin
    inherited;
    Text := IfThen(DisplayText,FormatFloat('##0.00 %',Sender.AsFloat),Sender.AsString);
end;

procedure TBDODataModule_EquipamentosEFamilias.EQUIPAMENTOSFL_LUCROBRUTOGetText(Sender: TField; var Text: string; DisplayText: Boolean);
begin
  	inherited;
    Text := IfThen(DisplayText,FormatFloat('##0.00 %',Sender.AsFloat),Sender.AsString);
end;

procedure TBDODataModule_EquipamentosEFamilias.EQUIPAMENTOSFL_VALORUNITARIOGetText(Sender: TField; var Text: string; DisplayText: Boolean);
begin
  	inherited;
    Text := IfThen(DisplayText,FormatFloat(GetElementByIndex(Pred(EQUIPAMENTOSTI_MOEDA.AsInteger),CURRENCY_STRINGS) + ' ###,###,##0.00',Sender.AsFloat),Sender.AsString);
end;

procedure TBDODataModule_EquipamentosEFamilias.EQUIPAMENTOSTI_MOEDAGetText(Sender: TField; var Text: string; DisplayText: Boolean);
begin
	inherited;
    Text := CURRENCY_STRINGS[Sender.AsInteger];
end;

procedure TBDODataModule_EquipamentosEFamilias.EQUIPAMENTOSTI_MOEDASetText(Sender: TField; const Text: string);
var
	i: Byte;
begin
	inherited;
    for i := 1 to High(CURRENCY_STRINGS) do
    	if Text = CURRENCY_STRINGS[i] then
        begin
	        Sender.AsInteger := i;
            Break;
        end;
end;

procedure TBDODataModule_EquipamentosEFamilias.LocalizarEquipamentoPorModeloEValor(const aLabeledEdit: TLabeledEdit;
                                                                                   const aComboBox: TComboBox;
                                                                                   const aEdit: TEdit);
var
    PrimaryKey: Cardinal;
    VA_MODELO: ShortString;
    FL_VALORUNITARIO: Currency;
begin
    VA_MODELO := '*' + aLabeledEdit.Text + '*';
    if Trim(aEdit.Text) <> '' then
    begin
        FL_VALORUNITARIO := StrToFloatDef(aEdit.Text,0);

        PrimaryKey := LocateFirstMatchedRecord(DataModuleMain.ZConnections[0].Connection
                                              ,['EQUIPAMENTOS']
                                              ,[]
                                              ,['VA_MODELO','FL_VALORUNITARIO']
                                              ,[VA_MODELO,FL_VALORUNITARIO]
                                              ,[coLike,TComparisonOperator(Succ(aComboBox.ItemIndex))]
                                              ,['IN_EQUIPAMENTOS_ID']
                                              ,'IN_EQUIPAMENTOS_ID').AsDWord;
    end
    else
    begin
        PrimaryKey := LocateFirstMatchedRecord(DataModuleMain.ZConnections[0].Connection
                                              ,['EQUIPAMENTOS']
                                              ,[]
                                              ,['VA_MODELO']
                                              ,[VA_MODELO]
                                              ,[coLike]
                                              ,['IN_EQUIPAMENTOS_ID']
                                              ,'IN_EQUIPAMENTOS_ID').AsDWord;
    end;

    if PrimaryKey = 0 then
    begin
        MessageBeep(MB_OK);
        aLabeledEdit.Color := clRed;
        aLabeledEdit.Font.Color := clWhite;
        aComboBox.Color := clRed;
        aComboBox.Font.Color := clWhite;
        aEdit.Color := clRed;
        aEdit.Font.Color := clWhite;
    end
    else
    begin
        aLabeledEdit.Color := clWindow;
        aLabeledEdit.Font.Color := clWindowText;
        aComboBox.Color := clWindow;
        aComboBox.Font.Color := clWindowText;
        aEdit.Color := clWindow;
        aEdit.Font.Color := clWindowText;
        EQUIPAMENTOS.Locate('IN_EQUIPAMENTOS_ID',PrimaryKey,[]);
    end;
end;

procedure TBDODataModule_EquipamentosEFamilias.LocalizarFamiliaPorDescricao(const aLabeledEdit: TLabeledEdit);
begin
    LocateFirstRecord(FAMILIAS,TEdit(aLabeledEdit),'VA_DESCRICAO');
end;

procedure TBDODataModule_EquipamentosEFamilias.SetRefreshSQL(const aZQuery: TZQuery; const aDBAction: TDBAction; out aRefreshSQL: AnsiString);
begin
    inherited;
    if aZQuery = EQUIPAMENTOS then
        case aDBAction of
            dbaBeforeInsert: aRefreshSQL := 'SELECT IN_EQUIPAMENTOS_ID FROM EQUIPAMENTOS WHERE IN_EQUIPAMENTOS_ID = LAST_INSERT_ID()';
            dbaBeforeEdit: aRefreshSQL := '';
        end
    else if aZQuery = FAMILIAS then
        case aDBAction of
            dbaBeforeInsert: aRefreshSQL := 'SELECT TI_FAMILIAS_ID FROM FAMILIAS WHERE TI_FAMILIAS_ID = LAST_INSERT_ID()';
            dbaBeforeEdit: aRefreshSQL := '';
        end;
end;

{
  SELECT IN_EQUIPAMENTOS_ID
       , VA_MODELO
       , FL_LUCROBRUTO
       , FL_VALORUNITARIO
       , TI_MOEDA
       , BO_DISPONIVEL
       , FNC_GET_FORMATTED_PERCENTUAL(FL_LUCROBRUTO,FALSE) AS LUCROBRUTO
       , FNC_GET_FORMATTED_CURRENCY_VALUE(FL_VALORUNITARIO,ELT(TI_MOEDA,'US$','€','R$','£','¥'),FALSE) AS VALORUNITARIO
       , ELT(BO_DISPONIVEL + 1,'Não','Sim') AS DISPONIVEL
    FROM EQUIPAMENTOS
ORDER BY VA_MODELO;
}

end.
