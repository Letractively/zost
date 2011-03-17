unit UDataModule_Principal;

interface

uses
  SysUtils, Classes, ZConnection, DB, ZAbstractRODataset, ZDataset;

type
  TTask = class (TThread)
  private
    FRecordsPerPage: Integer;
    FPageNo: Integer;
    FConsulta: TZReadOnlyQuery;
    FConexao: TZConnection;
//    procedure SetConexao(const Value: TZConnection);
    procedure SetSQL(const Value: String);
    function GetSQL: String;
    procedure DadosObtidos;
  public
    constructor Create(CreateSuspended: Boolean);
    destructor Destroy; override;
    procedure Execute; override;

    property PageNo: Integer read FPageNo write FPageNo;
    property RecordsPerPage: Integer read FRecordsPerPage write FRecordsPerPage;
//    property Conexao: TZConnection read FConexao write SetConexao;
    property SQL: String read GetSQL write SetSQL;
  end;

  TTaskItem = class (TCollectionItem)
  private
    FTask: TTask;
    FRecordsPerPage: Integer;
    FPageNo: Integer;
//    FConexao: TZConnection;
    FSQLLimitador: String;
    procedure SetPageNo(const Value: Integer);
    procedure SetRecordsPerPage(const Value: Integer);
//    procedure SetConexao(const Value: TZConnection);
    procedure SetSQL(const Value: String);
  public
    constructor Create(aCollection: TCollection); override;
    destructor Destroy; override;

    property Task: TTask read FTask;
    property PageNo: Integer read FPageNo write SetPageNo;
    property RecordsPerPage: Integer read FRecordsPerPage write SetRecordsPerPage;
//    property Conexao: TZConnection read FConexao write SetConexao;
    property SQL: String read FSQLLimitador write SetSQL;
  end;

  TTasks = class (TCollection)
  private
    function GetTaskItem(Index: Integer): TTaskItem;
    procedure SetTaskItem(Index: Integer; const Value: TTaskItem);

  public
    function Add: TTaskItem;
    procedure Iniciar;
    property Items[Index: Integer]: TTaskItem read GetTaskItem write SetTaskItem;
  end;

  TDataModule_Principal = class(TDataModule)
    DATABASE: TZConnection;
    ORIGEM: TZReadOnlyQuery;
    TIPODOCUMENTO: TZReadOnlyQuery;
    RECURSO: TZReadOnlyQuery;
    ORGAOJULGADOR: TZReadOnlyQuery;
    TITULO: TZReadOnlyQuery;
    MAGISTRADO: TZReadOnlyQuery;
    MASCARA: TZReadOnlyQuery;
    CODSELECAO: TZReadOnlyQuery;
    CONFIGSISTEMA: TZReadOnlyQuery;
    TIPOREFERENCIA: TZReadOnlyQuery;
    CONFIGINTEGRACAOORIGEM: TZReadOnlyQuery;
    DOCUMENTO: TZReadOnlyQuery;
    DOCPUBLICACAO: TZReadOnlyQuery;
    TEXTOEMENTA: TZReadOnlyQuery;
    REFERENCIALEGISLATIVA: TZReadOnlyQuery;
    TEXTOOBSERVACAO: TZReadOnlyQuery;
    TEXTOINDEXACAO: TZReadOnlyQuery;
    TEXTODECISAO: TZReadOnlyQuery;
    TEXTOREFERENCIA: TZReadOnlyQuery;
    TEXTOPRECEDENTE: TZReadOnlyQuery;
    TEXTOSUCESSIVO: TZReadOnlyQuery;
    DOCUMENTODOUTRINA: TZReadOnlyQuery;
    DOCUMENTONUMEROREFERENCIA: TZReadOnlyQuery;
    procedure DataModuleCreate(Sender: TObject);
  private
    { Private declarations }
    FTasks: TTasks;
    FSQLLimitador: String;
    FTotalDeProcessos: Integer;
    procedure AddToLog(aLinha: String);
//    procedure CarregarTabelasFixas;
    procedure CarregarDados;
//    procedure CarregarOrigem(aDataSetOrigem: TZReadOnlyQuery; aCodOrigem: Integer);
//    procedure CarregarTipoDocumento(aDataSetTipoDocumento: TZReadOnlyQuery);
//    procedure CarregarRecurso(aDataSetRecurso: TZReadOnlyQuery);
//    procedure CarregarOrgaoJulgador(aDataSetOrgaoJulgador: TZReadOnlyQuery);
//    procedure CarregarTitulos(aDataSetTitulo: TZReadOnlyQuery);
//    procedure CarregarMagistrado(aDataSetMagistrado: TZReadOnlyQuery);
//    procedure CarregarMascara(aDataSetMascara: TZReadOnlyQuery);
    procedure SQLLimitadorETotalDeProcessos;
//    procedure CarregarConfigSistema(aDataConfigSistema: TZReadOnlyQuery);
//    procedure CarregarTipoReferencia(aDataSetTipoReferencia: TZReadOnlyQuery);
//    procedure CarregarConfigIntegracaoOrigem(aDataSetConfigIntegracaoOrigem: TZReadOnlyQuery);
//    procedure CarregarDocumentos;
//    procedure CarregarDocPublicacao(aDocPublicacao: TZReadOnlyQuery);
//    procedure CarregarTextoEmenta(aTextoEmenta: TZReadOnlyQuery);
//    procedure CarregarReferenciaLegislativa(aReferenciaLegislativa: TZReadOnlyQuery);
//    procedure CarregarTextoObservacao(aTextoObservacao: TZReadOnlyQuery);
//    procedure CarregarTextoIndexacao(aTextoIndexacao: TZReadOnlyQuery);
//    procedure CarregarTextoDecisao(aTextoDecisao: TZReadOnlyQuery);
//    procedure CarregarTextoReferencia(aTextoReferencia: TZReadOnlyQuery);
//    procedure CarregarTextoPrecedente(aTextoPrecedente: TZReadOnlyQuery);
//    procedure CarregarTextoSucessivo(aTextoSucessivo: TZReadOnlyQuery);
//    procedure CarregarDocumentoDoutrina(aDocumentoDoutrina: TZReadOnlyQuery);
//    procedure CarregarDocumentoNumeroReferencia(aDocumentoNumeroReferencia: TZReadOnlyQuery);

    procedure AtualizarDataGeracao;
    procedure CriarThreads(aQuantidade: Word);
  public
    { Public declarations }
    constructor Create(aOwner: TComponent); override;
    destructor Destroy; override;
    procedure IniciarGeracaoCJF;
  end;

var
  DataModule_Principal: TDataModule_Principal;

implementation

{$R *.dfm}

uses DateUtils, UConfigurations, UForm_Principal;

const
  QTD_THREADS = 50;

  SQL_FINAL = '  SELECT (SELECT SGGERA FROM ORIGEM WHERE CODORIG = D.CODORIG AND D.TIPSITOPER = ''A'') || LPAD(D.CODDOC,8,''0'') AS ID_DOCUMENTO'#13#10 +
              '       , (SELECT DESCRGERA FROM ORIGEM WHERE CODORIG = D.CODORIG AND D.TIPSITOPER = ''A'') AS ORIGEM'#13#10 +
              '       , (SELECT DESCR FROM TIPODOCUMENTO WHERE TIPSITOPER = ''A'' AND CODTIPDOC = D.CODTIPDOC) AS TIPO_DOCUMENTO'#13#10 +
              '       , D.NUMPROC AS PROCESSO'#13#10 +
              '       , FORMATAPROCESSO_2(D.CODDOC) AS PROCESSO_FORMATADO'#13#10 +
              '       , (SELECT SGREC || '' - '' || DESCR FROM RECURSO WHERE CODREC = D.CODREC) || '' - '' || D.NUMCLASS AS CLASSE'#13#10 +
              '       , D.SGUF AS UF'#13#10 +
              '       , TO_CHAR(D.DTHRMOV,''DD/MM/YYYY'') AS DATA_DECISAO'#13#10 +
              '       , TO_CHAR(D.DTHRMOV,''YYYYMMDD'') AS DATA_DECISAO_PESQ'#13#10 +
              '       , (SELECT NOME FROM ORGAOJULGADOR WHERE CODORGJULG = D.CODORGJULG AND CODORIG = D.CODORIG) AS ORGAO_JULGADOR'#13#10 +
              '       , (SELECT TRIM(DECODE(CODFONTEPUBL,NULL,'''',CODFONTEPUBL || '' '') || DECODE(DTPUBL,NULL,'''',(SELECT DTPUBL FROM CONFIGSISTEMA) || '':'' || TO_CHAR(DTPUBL,''DD/MM/YYYY'') || '' '') || DECODE(NUMPAG,NULL,'''',(SELECT NUMPAG FROM '+'CONFIGSISTEMA) || '':'' || NUMPAG || '' '') || DECODE(NUMPUBL,NULL,'''',(SELECT NUMPUBL FROM CONFIGSISTEMA) || '':'' || NUMPUBL)) FROM DOCUMENTOPUBLICACAO WHERE SQPUBL = 1 AND CODDOC = D.CODDOC) AS FONTE_PUBLICACAO'#13#10 +
              '       , TO_CHAR((SELECT DTPUBL FROM DOCUMENTOPUBLICACAO WHERE SQPUBL = 1 AND CODDOC = D.CODDOC),''YYYYMMDD'') AS DATA_PUBLICACAO_PESQ'#13#10 +
              '       , '''' AS OUTRAS_FONTES -- REALMENTE NÃO EXISTE. TALVEZ UM DIA, QUEM SABE!'#13#10 +
              '       , TRIM((SELECT TXTEMENTA FROM TEXTOEMENTA WHERE CODDOC = D.CODDOC)) AS EMENTA'#13#10 +
              '       , (SELECT DECODE(TIPSEXO,''F'',(SELECT TIT.DESCRFEM FROM TITULO TIT JOIN ORIGEM ORI USING (CODTIT) WHERE TIT.TIPSITOPER = ''A'' AND ORI.CODORIG = D.CODORIG),(SELECT TIT.DESCRMAS FROM '+'TITULO TIT JOIN ORIGEM ORI USING (CODTIT) WHERE TIT.TIPSITOPER = ''A'' AND ORI.CODORIG = D.CODORIG)) || '' '' || NOME'#13#10 +
              '            FROM MAGISTRADO'#13#10 +
              '           WHERE CODMAG = D.CODMAGREL) AS RELATOR'#13#10 +
              '       , (SELECT DECODE(TIPSEXO,''F'',(SELECT TIT.DESCRFEM FROM TITULO TIT JOIN ORIGEM ORI USING (CODTIT) WHERE TIT.TIPSITOPER = ''A'' AND ORI.CODORIG = D.CODORIG),(SELECT TIT.DESCRMAS FROM '+'TITULO TIT JOIN ORIGEM ORI USING (CODTIT) WHERE TIT.TIPSITOPER = ''A'' AND ORI.CODORIG = D.CODORIG)) || '' '' || NOME'#13#10 +
              '            FROM MAGISTRADO'#13#10 +
              '           WHERE CODMAG = D.CODMAGREV) AS REVISOR'#13#10 +
              '       , (SELECT DECODE(TIPSEXO,''F'',(SELECT TIT.DESCRFEM FROM TITULO TIT JOIN ORIGEM ORI USING (CODTIT) WHERE TIT.TIPSITOPER = ''A'' AND ORI.CODORIG = D.CODORIG),(SELECT TIT.DESCRMAS FROM '+'TITULO TIT JOIN ORIGEM ORI USING (CODTIT) WHERE TIT.TIPSITOPER = ''A'' AND ORI.CODORIG = D.CODORIG)) || '' '' || NOME'#13#10 +
              '            FROM MAGISTRADO'#13#10 +
              '           WHERE CODMAG = D.CODMAGRELDESIG) AS RELATOR_ACORDAO'#13#10 +
              '       , TRIM((SELECT TXTOBSERVACAO FROM TEXTOOBSERVACAO WHERE CODDOC = D.CODDOC)) AS OBSERVACOES'#13#10 +
              '       , '''' AS REF_LEGISLATIVA -- PRECISA DE UMA FUNCTION NO BANCO PARA GERAR UM CLOB A PARTIR DE MULTIPLAS LINHAS'#13#10 +
              '       , '''' AS PRECEDENTES -- PRECISA DE UMA FUNCTION NO BANCO PARA GERAR UM CLOB A PARTIR DE MULTIPLAS LINHAS'#13#10 +
              '       , '''' AS SUCESSIVOS -- PRECISA DE UMA FUNCTION NO BANCO PARA GERAR UM CLOB A PARTIR DE MULTIPLAS LINHAS'#13#10 +
              '       , '''' AS DOUTRINA -- PRECISA DE UMA FUNCTION NO BANCO PARA GERAR UM CLOB A PARTIR DE MULTIPLAS LINHAS'#13#10 +
              '       , TRIM((SELECT TXTINDEXACAO FROM TEXTOINDEXACAO WHERE CODDOC = D.CODDOC)) AS INDEXACAO'#13#10 +
              '       , '''' AS CATALOGO -- REALMENTE NÃO EXISTE. TALVEZ UM DIA, QUEM SABE!'#13#10 +
              '       , TRIM((SELECT TXTDECISAO FROM TEXTODECISAO T WHERE CODDOC = D.CODDOC)) AS DECISAO'#13#10 +
              '       , TRIM((SELECT TXTREFERENCIA FROM TEXTOREFERENCIA WHERE CODDOC = D.CODDOC)) AS OUTRAS_REFERENCIAS'#13#10 +
              '       , '''' AS PERCENT_TXT -- REALMENTE NÃO EXISTE. TALVEZ UM DIA, QUEM SABE!'#13#10 +
              '       , '''' AS TXT_ORIGEM -- REALMENTE NÃO EXISTE. TALVEZ UM DIA, QUEM SABE!'#13#10 +
              '       , TO_CHAR(D.DTHRALT,''YYYYMMDD'') AS DATA_ALTERACAO_PESQ'#13#10 +
              '       , DECODE(D.DTHRINCL,NULL,''INCLUSÃO:30/12/1899-OPER:'',''INCLUSÃO:'' || TO_CHAR(D.DTHRINCL,''DD/MM/YYYY'') || ''-OPER:'') || NVL(D.IDINCL,'''') || '+'DECODE(D.DTHRALT,NULL,'''','' ALTERAÇÃO:'' || TO_CHAR(D.DTHRALT,''DD/MM/YYYY'') || ''-OPER:'') || NVL(D.IDALT,'''') AS HIST_ALTERACAO'#13#10 +
              '       , '''' AS ITEOR -- PRECISA DE UMA FUNCTION NO BANCO PARA GERAR UM RESULTADO. AINDA PRECISA SER IDENTIFICADO'#13#10 +
              '    FROM DOCUMENTO D'#13#10 +
              '   WHERE D.CODDOC IN (<:CODDOCS:>)'#13#10 +
              'ORDER BY 1';

procedure TDataModule_Principal.AddToLog(aLinha: String);
begin
  Form_Principal.Memo_Log.Lines.Add(aLinha);
end;

procedure TDataModule_Principal.AtualizarDataGeracao;
begin
  with TZReadOnlyQuery.Create(nil) do
    try
      Connection := DATABASE;
      SQL.Text := 'UPDATE CONFIGSISTEMA'#13#10 +
                  '   SET DTULTGERA = SYSDATE';
    finally
      Close;
      Free;
    end;
end;

procedure TDataModule_Principal.SQLLimitadorETotalDeProcessos;
const
  // (PAG - 1) * REGPORPAG + 1
  // até
  // PAG * REGPORPAG
  // ex.: 100 registros, 10 por página
  //      (1 - 1) * 10 + 1 até 1 * 10 = 0 * 10 + 1 até 10 = 1 até 10
  //      (2 - 1) * 10 + 1 até 2 * 10 = 1 * 10 + 1 até 20 = 11 até 20
  //      ...
  //      (10 - 1) * 10 + 1 até 10 * 10 = 9 * 10 + 1 até 100 = 91 até 100
  SQL0 = 'SELECT SEL.CODDOC'#13#10 +
         '  FROM (<:SELECAO:>) SEL'#13#10 +
         ' WHERE SEL.RN BETWEEN (%U-1) * %U + 1 AND %0:U * %1:U';

  SQL1 =         'SELECT ROW_NUMBER() OVER (ORDER BY CODDOC) AS RN'#13#10 +
         '             , CODDOC'#13#10 +
         '          FROM DOCUMENTO'#13#10 +
         '         WHERE CODORIG = <:CODORIG:>'#13#10 +
         '           AND TIPSITOPER = ''A'''#13#10;

  SQL2 = '           AND CODTIPDOC = <:CODTIPDOC:>'#13#10;
  
  { TODO : A constução das datas abaixo pode precisar de ajustes para usar o dia inteiro }
  SQL3 = '           AND (DTHRINCL BETWEEN TO_DATE(<:DATAINICIAL:>, ''DD/MM/YYYY'') AND TO_DATE(<:DATAFINAL:>, ''DD/MM/YYYY'') OR DTHRALT BETWEEN TO_DATE(<:DATAINICIAL:>, ''DD/MM/YYYY'') AND TO_DATE(<:DATAFINAL:>, ''DD/MM/YYYY''))'#13#10;
var
  DataIni, DataFim: TDateTime;
begin
  FSQLLimitador := SQL1;
  FTotalDeProcessos := 0;
  
  // No código original a linha abaixo estava comentada
  // Result := StringReplace(Result,'<:CODORIG:>',IntToStr(Configurations.PARAMETROSORIGEM),[]);
  FSQLLimitador := StringReplace(FSQLLimitador,'<:CODORIG:>','1',[]);

  if not Configurations.PARAMETROSTODOSOSDOCUMENTOS then
  begin
    FSQLLimitador := FSQLLimitador + SQL2;
    // No código original a linha abaixo estava comentada
    // Result := StringReplace(Result,'<:CODTIPDOC:>',IntToStr(Configurations.PARAMETROSTIPODOCUMENTO),[]);;
    FSQLLimitador := StringReplace(FSQLLimitador,'<:CODTIPDOC:>','1',[]);
  end;

  case Configurations.PARAMETROSOPCAODATA of
    2: begin
      AddToLog('Entre ' + FormatDateTime('dd/mm/yyyy',Configurations.PARAMETROSDATAINICIAL) + ' e ' + FormatDateTime('dd/mm/yyyy',Configurations.PARAMETROSDATAFINAL));
      FSQLLimitador := FSQLLimitador + SQL3;
      FSQLLimitador := StringReplace(FSQLLimitador,'<:DATAINICIAL:>',FormatDateTime('dd/mm/yyyy',Configurations.PARAMETROSDATAINICIAL),[]);
      FSQLLimitador := StringReplace(FSQLLimitador,'<:DATAFINAL:>',FormatDateTime('dd/mm/yyyy',Configurations.PARAMETROSDATAFINAL),[]);
    end;
    3: begin
      AddToLog('Número de meses no intervalo: ' + IntToStr(Configurations.PARAMETROSNUMEROMESES));
      FSQLLimitador := FSQLLimitador + SQL3;

      DataFim := Now;
      DataIni := IncMonth(DataFim,-Configurations.PARAMETROSNUMEROMESES);

      FSQLLimitador := StringReplace(FSQLLimitador,'<:DATAINICIAL:>',FormatDateTime('dd/mm/yyyy',DataIni),[]);
      FSQLLimitador := StringReplace(FSQLLimitador,'<:DATAFINAL:>',FormatDateTime('dd/mm/yyyy',DataFim),[]);

      AddToLog('Data inicial: ' + FormatDateTime('dd/mm/yyyy',DataIni));
      AddToLog('Data final: ' + FormatDateTime('dd/mm/yyyy',DataFim));
    end;
  end;

  with TZReadOnlyQuery.Create(nil) do
    try
      Connection := DATABASE;
      SQL.Text := StringReplace(FSQLLimitador,'SELECT ROW_NUMBER() OVER (ORDER BY CODDOC) AS RN'#13#10'             , CODDOC'#13#10,'  SELECT COUNT(CODDOC)'#13#10,[]);
      Open;

      FTotalDeProcessos := Fields[0].AsInteger;

      AddToLog('Número de documentos a processar: ' + IntToStr(FTotalDeProcessos));
      Form_Principal.ProgressBar_Principal.Max := FTotalDeProcessos;
      Form_Principal.ProgressBar_Principal.Step := 1;
      Form_Principal.ProgressBar_Principal.Position := 0;
    finally
      Close;
      Free;
    end;
  FSQLLimitador := StringReplace(SQL0,'<:SELECAO:>',Trim(FSQLLimitador),[]);
end;

//procedure TDataModule_Principal.CarregarConfigIntegracaoOrigem(aDataSetConfigIntegracaoOrigem: TZReadOnlyQuery);
//begin
//  with aDataSetConfigIntegracaoOrigem do
//  begin
//    Close;
//    Open;
//  end;
//end;

//procedure TDataModule_Principal.CarregarConfigSistema(aDataConfigSistema: TZReadOnlyQuery);
//begin
//  with aDataConfigSistema do
//  begin
//    Close;
//    Open;
//  end;
//end;

//procedure TDataModule_Principal.CarregarMagistrado(aDataSetMagistrado: TZReadOnlyQuery);
//begin
//  with aDataSetMagistrado do
//  begin
//    Close;
//    Open;
//  end;
//end;

//procedure TDataModule_Principal.CarregarMascara(aDataSetMascara: TZReadOnlyQuery);
//begin
//  with aDataSetMascara do
//  begin
//    Close;
//    Open;
//  end;
//end;

//procedure TDataModule_Principal.CarregarOrgaoJulgador(aDataSetOrgaoJulgador: TZReadOnlyQuery);
//begin
//  with aDataSetOrgaoJulgador do
//  begin
//    Close;
//    Open;
//  end;
//end;

//procedure TDataModule_Principal.CarregarOrigem(aDataSetOrigem: TZReadOnlyQuery; aCodOrigem: Integer);
//begin
//  with aDataSetOrigem do
//  begin
//    Close;
//    ParamByName('CODORIG').AsInteger := aCodOrigem;
//    Open;
//  end;
//end;

//procedure TDataModule_Principal.CarregarRecurso(aDataSetRecurso: TZReadOnlyQuery);
//begin
//  with aDataSetRecurso do
//  begin
//    Close;
//    Open;
//  end;
//end;

//procedure TDataModule_Principal.CarregarTabelasFixas;
//begin
//  CarregarOrigem(ORIGEM, Configurations.PARAMETROSORIGEM);
//  CarregarTipoDocumento(TIPODOCUMENTO);
//  CarregarRecurso(RECURSO);
//  CarregarOrgaoJulgador(ORGAOJULGADOR);
//  CarregarTitulos(TITULO);
//  CarregarMagistrado(MAGISTRADO);
//  CarregarMascara(MASCARA);
//  CarregarConfigSistema(CONFIGSISTEMA);
//  CarregarTipoReferencia(TIPOREFERENCIA);
//  CarregarConfigIntegracaoOrigem(CONFIGINTEGRACAOORIGEM);
//end;

//procedure TDataModule_Principal.CarregarTipoDocumento(aDataSetTipoDocumento: TZReadOnlyQuery);
//begin
//  with aDataSetTipoDocumento do
//  begin
//    Close;
//    Open;
//  end;
//end;

//procedure TDataModule_Principal.CarregarTipoReferencia(aDataSetTipoReferencia: TZReadOnlyQuery);
//begin
//  with aDataSetTipoReferencia do
//  begin
//    Close;
//    Open;
//  end;
//end;

//procedure TDataModule_Principal.CarregarTitulos(aDataSetTitulo: TZReadOnlyQuery);
//begin
//  with aDataSetTitulo do
//  begin
//    Close;
//    Open;
//  end;
//end;

procedure TDataModule_Principal.DataModuleCreate(Sender: TObject);
begin
  Configurations.LoadFromFile(GetCurrentDir + '\Config.ini');

  if DATABASE.Connected then
    DATABASE.Disconnect;

  DATABASE.Database := Configurations.PARAMETROSDATABASE;
  DATABASE.HostName := Configurations.PARAMETROSHOSTNAME;
  DATABASE.Password := Configurations.PARAMETROSPASSWORD;
  DATABASE.Protocol := 'oracle'; { Configurável um dia... }
  DATABASE.User     := Configurations.PARAMETROSUSERNAME;
  DATABASE.Connect;
end;

procedure TDataModule_Principal.IniciarGeracaoCJF;
var
  RelatorioCJF: TextFile;
begin
  try
    AssignFile(RelatorioCJF,Configurations.PARAMETROSNOMEDOARQUIVO);
    FileMode := fmOpenWrite;
    Rewrite(RelatorioCJF);
    
    try
      Form_Principal.Memo_Log.Clear;

      AddToLog('***** Sistema Geração de Relatorio CJF (Atenas) *****');
      AddToLog('');
      AddToLog('GeraçãoCJF Iniciada ...');
      AddToLog('Inicio: ' + FormatDateTime('dd/mm/yyyy "às" hh:nn:ss',Now));
      AddToLog('');
      AddToLog('-----------------------------------------------------');
      AddToLog('Obtendo total de documentos a processar...');
      SQLLimitadorETotalDeProcessos;
      AddToLog('');
      AddToLog('Carregando dados... (' + FormatDateTime('hh:nn:ss',Now) + ')');

      CarregarDados;
      FTasks.Iniciar;

      AddToLog('Dados carregados! (' + FormatDateTime('hh:nn:ss',Now) + ')');
      AddToLog('');
      AddToLog('Manipulando XML... (' + FormatDateTime('hh:nn:ss',Now) + ')');
//      EscreveXml(RelatorioCJF);
      AddToLog('XML manipulado! (' + FormatDateTime('hh:nn:ss',Now) + ')');

      AddToLog('-----------------------------------------------------');
      AddToLog('');
      AddToLog('Fim: ' + FormatDateTime('dd/mm/yyyy "às" hh:nn:ss',Now));
      AddToLog('GeraçãoCJF concluída!');
      AddToLog('');
      AddToLog('*****************************************************');
      AtualizarDataGeracao;
    except

//      catch (Exception e) {
//        Log.WriteLine(DateTime.Now + " - Exceção:");
//        Log.WriteLine(e.Message);
//        Log.WriteLine(e.StackTrace);
//        Log.WriteLine("GeraçãoCJF falhou");
//        Log.Dispose();
//        Console.WriteLine("Erro na geração, verifique o log para mais detalhes.");
//        Console.ReadLine();
    end;
  finally
    CloseFile(RelatorioCJF);
  end;
end;

procedure TDataModule_Principal.CarregarDados;
begin
  { Cria uma coleção de Threads que serão usadas para seleções múltiplas }
  CriarThreads(QTD_THREADS);

//  FTasks.Iniciar;
  { Baseado nos CodDocs obtidos por SQLDocumentosAProcessar, o DataSet DOCUMENTO
  contém o conjunto de dados básicos que será circulado para geração do XML final }
//  CarregarDocumentos;

//  CarregarDocPublicacao(DOCPUBLICACAO);
//  CarregarTextoEmenta(TEXTOEMENTA);
//  CarregarReferenciaLegislativa(REFERENCIALEGISLATIVA);
//  CarregarTextoObservacao(TEXTOOBSERVACAO);
//  CarregarTextoIndexacao(TEXTOINDEXACAO);
//  CarregarTextoDecisao(TEXTODECISAO);
//  CarregarTextoReferencia(TEXTOREFERENCIA);
//  CarregarTextoPrecedente(TEXTOPRECEDENTE);
//  CarregarTextoSucessivo(TEXTOSUCESSIVO);
//  CarregarDocumentoDoutrina(DOCUMENTODOUTRINA);
//  CarregarDocumentoNumeroReferencia(DOCUMENTONUMEROREFERENCIA);
end;

//procedure TDataModule_Principal.CarregarDocumentos;
//const
//  SQL1 = '  SELECT D.IDINCL'#13#10 +
//         '       , D.CODMASCNUMPROC'#13#10 +
//         '       , D.CODDOC'#13#10 +
//         '       , D.CODMAGRELDESIG'#13#10 +
//         '       , D.CODORIG'#13#10 +
//         '       , D.CODTIPDOC'#13#10 +
//         '       , D.NUMPROC'#13#10 +
//         '       , D.CODREC'#13#10 +
//         '       , D.NUMCLASS'#13#10 +
//         '       , D.SGUF'#13#10 +
//         '       , D.DTHRMOV'#13#10 +
//         '       , D.DTHRINCL'#13#10 +
//         '       , D.DTHRALT'#13#10 +
//         '       , D.IDALT'#13#10 +
//         '       , D.CODMASCNUMPROC'#13#10 +
//         '       , D.CODORGJULG'#13#10 +
//         '       , D.CODMAGREL'#13#10 +
//         '       , D.CODMAGREV'#13#10 +
//         '    FROM DOCUMENTO D'#13#10 +
//         '   WHERE CODDOC IN (<:CODDOCS:>)'#13#10 +
//         'ORDER BY D.CODDOC';
//begin
//  with aDocumentos do
//begin
//    Close;
//    SQL.Text := StringReplace(SQL1,'<:CODDOCS:>',FDocumentosAProcessar,[]);
//    Open;
//end;
//end;

//procedure TDataModule_Principal.CarregarDocPublicacao(aDocPublicacao: TZReadOnlyQuery);
//const
//  SQL1 = '  SELECT CODDOC'#13#10 +
//         '       , SQPUBL'#13#10 +
//         '       , DTPUBL'#13#10 +
//         '       , CODFONTEPUBL'#13#10 +
//         '       , NUMPUBL'#13#10 +
//         '       , NUMPAG'#13#10 +
//         '    FROM DOCUMENTOPUBLICACAO D'#13#10 +
//         '   WHERE D.SQPUBL = 1'#13#10 +
//         '     AND D.CODDOC IN (<:CODDOCS:>)'#13#10 +
//         'ORDER BY D.CODDOC';
//begin
//  with aDocPublicacao do
//  begin
//    Close;
//    SQL.Text := StringReplace(SQL1,'<:CODDOCS:>',FDocumentosAProcessar,[]);
//    Open;
//  end;
//end;

//procedure TDataModule_Principal.CarregarTextoEmenta(aTextoEmenta: TZReadOnlyQuery);
//const
//  SQL1 = '  SELECT T.CODDOC'#13#10 +
//         '       , T.TXTEMENTA'#13#10 +
//         '    FROM TEXTOEMENTA T'#13#10 +
//         '   WHERE CODDOC IN (<:CODDOCS:>)'#13#10 +
//         'ORDER BY T.CODDOC';
//begin
//  with aTextoEmenta do
//  begin
//    Close;
//    SQL.Text := StringReplace(SQL1,'<:CODDOCS:>',FDocumentosAProcessar,[]);
//    Open;
//  end;
//end;

//procedure TDataModule_Principal.CarregarReferenciaLegislativa(aReferenciaLegislativa: TZReadOnlyQuery);
//const
//  SQL1 = '  SELECT D.CODDOC'#13#10 +
//         '       , D.SGCODLEI'#13#10 +
//         '       , S.INDSIST AS INDSISTLEI'#13#10 +
//         '       , S.DESCR AS DESCRLEI'#13#10 +
//         '       , S.ANONORMALEG AS ANONORMALEG'#13#10 +
//         '       , S.CODORIGLEG AS CODORIGLEG'#13#10 +
//         '       , S.CODNORMALEG AS CODNORMALEG'#13#10 +
//         '       , DECODE(D.NUMNORMALEG, NULL, S.NUMNORMALEG, D.NUMNORMALEG) AS NUMNORMALEG'#13#10 +
//         '       , D.OBS'#13#10 +
//         '       , D.SQREFLEG'#13#10 +
//         '       , (SELECT O.SGORIGLEG'#13#10 +
//         '            FROM ORIGEMLEGISLATIVA O'#13#10 +
//         '           WHERE O.CODORIGLEG = S.CODORIGLEG) AS SGORIGLEG'#13#10 +
//         '    FROM DOCUMENTOREFERENCIALEGISLATIVA D'#13#10 +
//         '       , SIGLACODIGOLEI S'#13#10 +
//         '   WHERE D.SGCODLEI = S.SGCODLEI'#13#10 +
//         '     AND D.CODDOC IN (<:CODDOCS:>)'#13#10 +
//         'ORDER BY D.CODDOC';
//begin
//  with aReferenciaLegislativa do
//  begin
//    Close;
//    SQL.Text := StringReplace(SQL1,'<:CODDOCS:>',FDocumentosAProcessar,[]);
//    Open;
//  end;
//end;

//procedure TDataModule_Principal.CarregarTextoObservacao(aTextoObservacao: TZReadOnlyQuery);
//const
//  SQL1 = '  SELECT T.CODDOC'#13#10 +
//         '       , T.TXTOBSERVACAO'#13#10 +
//         '    FROM TEXTOOBSERVACAO T'#13#10 +
//         '   WHERE CODDOC IN (<:CODDOCS:>)'#13#10 +
//         'ORDER BY T.CODDOC';
//begin
//  with aTextoObservacao do
//  begin
//    Close;
//    SQL.Text := StringReplace(SQL1,'<:CODDOCS:>',FDocumentosAProcessar,[]);
//    Open;
//  end;
//end;

//procedure TDataModule_Principal.CarregarTextoIndexacao(aTextoIndexacao: TZReadOnlyQuery);
//const
//  SQL1 = '  SELECT T.CODDOC'#13#10 +
//         '       , T.TXTINDEXACAO'#13#10 +
//         '    FROM TEXTOINDEXACAO T'#13#10 +
//         '   WHERE CODDOC IN (<:CODDOCS:>)'#13#10 +
//         'ORDER BY T.CODDOC';
//begin
//  with aTextoIndexacao do
//  begin
//    Close;
//    SQL.Text := StringReplace(SQL1,'<:CODDOCS:>',FDocumentosAProcessar,[]);
//    Open;
//  end;
//end;

//procedure TDataModule_Principal.CarregarTextoDecisao(aTextoDecisao: TZReadOnlyQuery);
//const
//  SQL1 = '  SELECT T.CODDOC'#13#10 +
//         '       , T.TXTDECISAO'#13#10 +
//         '    FROM TEXTODECISAO T'#13#10 +
//         '   WHERE T.CODDOC IN (<:CODDOCS:>)'#13#10 +
//         'ORDER BY T.CODDOC';
//begin
//  with aTextoDecisao do
//  begin
//    Close;
//    SQL.Text := StringReplace(SQL1,'<:CODDOCS:>',FDocumentosAProcessar,[]);
//    Open;
//  end;
//end;

//procedure TDataModule_Principal.CarregarTextoReferencia(aTextoReferencia: TZReadOnlyQuery);
//const
//  SQL1 = '  SELECT T.CODDOC'#13#10 +
//         '       , T.TXTREFERENCIA'#13#10 +
//         '    FROM TEXTOREFERENCIA T'#13#10 +
//         '   WHERE CODDOC IN (<:CODDOCS:>)'#13#10 +
//         'ORDER BY T.CODDOC';
//begin
//  with aTextoReferencia do
//  begin
//    Close;
//    SQL.Text := StringReplace(SQL1,'<:CODDOCS:>',FDocumentosAProcessar,[]);
//    Open;
//  end;
//end;

//procedure TDataModule_Principal.CarregarTextoPrecedente(aTextoPrecedente: TZReadOnlyQuery);
//const
//  SQL1 = '  SELECT CODDOC'#13#10 +
//         '       , SQDOCRELAC'#13#10 +
//         '       , TXTDOCRELAC'#13#10 +
//         '    FROM TEXTODOCRELAC T'#13#10 +
//         '   WHERE (SELECT TIPRELAC'#13#10 +
//         '          FROM DOCUMENTORELACIONADO'#13#10 +
//         '         WHERE CODDOC = T.CODDOC'#13#10 +
//         '           AND SQDOCRELAC = T.SQDOCRELAC) = ''P'''#13#10 +
//         '           AND T.CODDOC IN (<:CODDOCS:>)'#13#10 +
//         'ORDER BY T.CODDOC';
//begin
//  with aTextoPrecedente do
//  begin
//    Close;
//    SQL.Text := StringReplace(SQL1,'<:CODDOCS:>',FDocumentosAProcessar,[]);
//    Open;
//  end;
//end;

//procedure TDataModule_Principal.CarregarTextoSucessivo(aTextoSucessivo: TZReadOnlyQuery);
//const
//  SQL1 = '  SELECT CODDOC'#13#10 +
//         '       , SQDOCRELAC'#13#10 +
//         '       , TXTDOCRELAC'#13#10 +
//         '    FROM TEXTODOCRELAC T'#13#10 +
//         '   WHERE (SELECT TIPRELAC'#13#10 +
//         '          FROM DOCUMENTORELACIONADO'#13#10 +
//         '         WHERE CODDOC = T.CODDOC'#13#10 +
//         '           AND SQDOCRELAC = T.SQDOCRELAC) = ''S'''#13#10 +
//         '           AND T.CODDOC IN (<:CODDOCS:>)'#13#10 +
//         'ORDER BY T.CODDOC';
//begin
//  with aTextoSucessivo do
//  begin
//    Close;
//    SQL.Text := StringReplace(SQL1,'<:CODDOCS:>',FDocumentosAProcessar,[]);
//    Open;
//  end;
//end;

//procedure TDataModule_Principal.CarregarDocumentoDoutrina(aDocumentoDoutrina: TZReadOnlyQuery);
//const
//  SQL1 = '  SELECT CODDOC'#13#10 +
//         '       , SQDOUT'#13#10 +
//         '       , NOMEAUTOR'#13#10 +
//         '       , NOMEOBRA'#13#10 +
//         '    FROM DOCUMENTODOUTRINA'#13#10 +
//         '   WHERE CODDOC IN (<:CODDOCS:>)'#13#10 +
//         'ORDER BY CODDOC';
//begin
//  with aDocumentoDoutrina do
//  begin
//    Close;
//    SQL.Text := StringReplace(SQL1,'<:CODDOCS:>',FDocumentosAProcessar,[]);
//    Open;
//  end;
//end;

//procedure TDataModule_Principal.CarregarDocumentoNumeroReferencia(aDocumentoNumeroReferencia: TZReadOnlyQuery);
//const
//  SQL1 = '  SELECT CODDOC'#13#10 +
//         '       , SQREFLEG'#13#10 +
//         '       , SQTIPREF'#13#10 +
//         '       , NUMTIPREF'#13#10 +
//         '       , CODTIPREF'#13#10 +
//         '    FROM DOCUMENTONUMEROREFERENCIA'#13#10 +
//         '   WHERE CODDOC IN (<:CODDOCS:>)'#13#10 +
//         'ORDER BY SQTIPREF';
//begin
//  with aDocumentoNumeroReferencia do
//  begin
//    Close;
//    SQL.Text := StringReplace(SQL1,'<:CODDOCS:>',FDocumentosAProcessar,[]);
//    Open;
//  end;
//end;

procedure TDataModule_Principal.CriarThreads(aQuantidade: Word);
var
  i: Integer;
  RegistrosPorPagina: Integer;
begin
  FTasks.Clear;

  RegistrosPorPagina := FTotalDeProcessos div aQuantidade;

  for i := 1 to aQuantidade do
    with FTasks.Add do
    begin
      PageNo := i;
      RecordsPerPage := RegistrosPorPagina;
//      Conexao := DATABASE;
      SQL := Self.FSQLLimitador;
    end;
end;

{ TTaskItem }

constructor TTaskItem.Create(aCollection: TCollection);
begin
  inherited;
  FTask := TTask.Create(True);
  FTask.FreeOnTerminate := True;
end;

destructor TTaskItem.Destroy;
begin
  FTask.Terminate;
  inherited;
end;

constructor TDataModule_Principal.Create(aOwner: TComponent);
begin
  inherited;
  FTasks := TTasks.Create(TTaskItem);
end;

destructor TDataModule_Principal.Destroy;
begin
  FTasks.Free;
  inherited;
end;

//procedure TTaskItem.SetConexao(const Value: TZConnection);
//begin
//  FConexao := Value;
//  FTask.Conexao := Value;
//end;

procedure TTaskItem.SetPageNo(const Value: Integer);
begin
  FPageNo := Value;
  FTask.PageNo := Value;
end;

procedure TTaskItem.SetRecordsPerPage(const Value: Integer);
begin
  FRecordsPerPage := Value;
  FTask.RecordsPerPage := Value;
end;

procedure TTaskItem.SetSQL(const Value: String);
begin
  FSQLLimitador := Value;
  FTask.SQL := Value;
end;

{ TTask }

constructor TTask.Create(CreateSuspended: Boolean);
begin
  inherited;
  FConexao := TZConnection.Create(nil);

  Configurations.LoadFromFile(GetCurrentDir + '\Config.ini');

  if FConexao.Connected then
    FConexao.Disconnect;

  FConexao.Database := Configurations.PARAMETROSDATABASE;
  FConexao.HostName := Configurations.PARAMETROSHOSTNAME;
  FConexao.Password := Configurations.PARAMETROSPASSWORD;
  FConexao.Protocol := 'oracle'; { Configurável um dia... }
  FConexao.User     := Configurations.PARAMETROSUSERNAME;
  FConexao.Connect;

  FConsulta := TZReadOnlyQuery.Create(nil);
  FConsulta.AutoCalcFields := False;
  FConsulta.Connection := FConexao;
end;

procedure TTask.DadosObtidos;
begin
  Form_Principal.Memo_Log.Lines.Add('Thread ID#' + IntToStr(ThreadID) + ' concluída!');
end;

destructor TTask.Destroy;
begin
  FConsulta.Free;
  FConexao.Free;
  inherited;
end;

procedure TTask.Execute;
begin
  inherited;
  with FConsulta do
    try
      Open;
      Synchronize(DadosObtidos);
    finally
      Close;
    end;
end;

function TTask.GetSQL: String;
begin
  Result := FConsulta.SQL.Text;
end;

//procedure TTask.SetConexao(const Value: TZConnection);
//begin
//  FConexao := Value;
//  FConsulta.Connection := FConexao;
//end;

procedure TTask.SetSQL(const Value: String);
begin
  FConsulta.SQL.Text := StringReplace(SQL_FINAL,'<:CODDOCS:>',Format(Value,[FPageNo,FRecordsPerPage]),[]);
end;

{ TTasks }

function TTasks.Add: TTaskItem;
begin
  Result := TTaskItem(inherited Add);
end;

function TTasks.GetTaskItem(Index: Integer): TTaskItem;
begin
  Result := TTaskItem(inherited Items[Index]);
end;

procedure TTasks.Iniciar;
var
  i: Word;
begin
  for i := 0 to Pred(Count) do
    Items[i].Task.Resume;
end;

procedure TTasks.SetTaskItem(Index: Integer; const Value: TTaskItem);
begin
  TTaskItem(inherited Items[Index]).Assign(Value);
end;

end.

