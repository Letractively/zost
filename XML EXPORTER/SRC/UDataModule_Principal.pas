unit UDataModule_Principal;

interface

uses
  SysUtils, Classes, ExtCtrls, AppEvnts, ZipMstr, OverbyteIcsWndControl,
  OverbyteIcsFtpCli;

type
  TSyncCmd = function: Boolean of object;
  TAsyncCmd = procedure of object;

  TDataModule_Principal = class(TDataModule)
    ApplicationEvents_Monitorador: TApplicationEvents;
    ZipMaster_Compressor: TZipMaster;
    FtpClient_Envio: TFtpClient;
    procedure ApplicationEvents_MonitoradorIdle(Sender: TObject; var Done: Boolean);
    procedure DataModuleCreate(Sender: TObject);
    procedure ZipMaster_CompressorMessage(Sender: TObject; ErrCode: Integer; Message: String);
    procedure ZipMaster_CompressorProgress(Sender: TObject; ProgrType: ProgressType; Filename: String; FileSize: Integer);
    procedure FtpClient_EnvioDisplay(Sender: TObject; var Msg: String);
    procedure FtpClient_EnvioRequestDone(Sender: TObject; RqType: TFtpRequest; ErrCode: Word);
    procedure FtpClient_EnvioSessionClosed(Sender: TObject; ErrCode: Word);
    procedure FtpClient_EnvioSessionConnected(Sender: TObject; ErrCode: Word);
    procedure FtpClient_EnvioProgress64(Sender: TObject; Count: Int64; var Abort: Boolean);
  private
    { Private declarations }
    FSQLLimitador: String;
    FTotalDeProcessos: Cardinal;
    FInicio: TDateTime;
    FEmExecucao: Word;
    FEmGeracao: Word;
    FAtivado: Boolean;
    procedure SQLLimitadorETotalDeProcessos;
    procedure AddToLog(aLinha: String);
    procedure ZiparArquivo;
    procedure ExecuteCmd(SyncCmd: TSyncCmd; ASyncCmd: TAsyncCmd);
    function FileSize(aFileName: TFileName): Int64;
    procedure TransmitirArquivo;
    procedure CompilarXMLFinal;
    function ParametroBooleanoPresente(aParamStr: String): Boolean;
  public
    { Public declarations }
    procedure IniciarProcessamento;
    procedure ProcessarLinhaDeComando;
    property ThreadsExecutando: Word read FEmExecucao write FEmExecucao;
    property ThreadsGerando: Word read FEmGeracao write FEmGeracao;
  end;

implementation

uses Windows, Messages, UConfigurations, UForm_Principal, UTaskThread, ZConnection,
     ZDataSet, Math, StrUtils;

{$R *.dfm}

{$R ZipMsgBR.res}

const
  SQL_TEMPLATE = '  SELECT D.CODDOC'#13#10 +
                 '       , RELCJF_ID_DOCUMENTO(D.CODORIG,D.CODDOC) AS ID_DOCUMENTO'#13#10 +
                 '       , RELCJF_ORIGEM(D.CODORIG) AS ORIGEM'#13#10 +
                 '       , RELCJF_TIPO_DOCUMENTO(D.CODTIPDOC) AS TIPO_DOCUMENTO'#13#10 +
                 '       , D.NUMPROC AS PROCESSO'#13#10 +
                 '       , RELCJF_PROCESSO_FORMATADO(D.NUMPROC) AS PROCESSO_FORMATADO'#13#10 +
                 '       , RELCJF_CLASSE(D.CODREC,D.NUMCLASS) AS CLASSE'#13#10 +
                 '       , D.SGUF AS UF'#13#10 +
                 '       , RELCJF_DATA_DECISAO(D.DTHRMOV) AS DATA_DECISAO'#13#10 +
                 '       , RELCJF_DATA_DECISAO_PESQ(D.DTHRMOV) AS DATA_DECISAO_PESQ'#13#10 +
                 '       , RELCJF_ORGAO_JULGADOR(D.CODORGJULG,D.CODORIG) AS ORGAO_JULGADOR'#13#10 +
                 '       , RELCJF_FONTE_PUBLICACAO(D.CODDOC) AS FONTE_PUBLICACAO'#13#10 +    //////////////
                 '       , RELCJF_DATA_PUBLICACAO_PESQ(D.CODDOC) AS DATA_PUBLICACAO_PESQ'#13#10 + ///////////////
                 '       , NULL AS OUTRAS_FONTES'#13#10 + // -- REALMENTE NÃO EXISTE. TALVEZ UM DIA, QUEM SABE!
                 '       , RELCJF_EMENTA(D.CODDOC) AS EMENTA'#13#10 +
                 '       , RELCJF_MAGISTRADO(D.CODORIG,D.CODMAGREL) AS RELATOR'#13#10 +
                 '       , RELCJF_MAGISTRADO(D.CODORIG,D.CODMAGREV) AS REVISOR'#13#10 +
                 '       , RELCJF_MAGISTRADO(D.CODORIG,D.CODMAGRELDESIG) AS RELATOR_ACORDAO'#13#10 +
                 '       , RELCJF_OBSERVACOES(D.CODDOC) AS OBSERVACOES'#13#10 +
                 '       , RELCJF_REF_LEGISLATIVA(D.CODDOC) AS REF_LEGISLATIVA'#13#10 +
                 '       , RELCJF_TEXTO(D.CODDOC,''P'') AS PRECEDENTES'#13#10 +
                 '       , RELCJF_TEXTO(D.CODDOC,''S'') AS SUCESSIVOS'#13#10 +
                 '       , RELCJF_DOUTRINA(D.CODDOC) AS DOUTRINA'#13#10 +
                 '       , RELCJF_INDEXACAO(D.CODDOC) AS INDEXACAO'#13#10 +
                 '       , NULL AS CATALOGO'#13#10 + //  -- REALMENTE NÃO EXISTE. TALVEZ UM DIA, QUEM SABE!
                 '       , RELCJF_DECISAO(D.CODDOC) AS DECISAO'#13#10 +
                 '       , RELCJF_OUTRAS_REFERENCIAS(D.CODDOC) AS OUTRAS_REFERENCIAS'#13#10 +
                 '       , NULL AS PERCENT_TXT'#13#10 + //  -- REALMENTE NÃO EXISTE. TALVEZ UM DIA, QUEM SABE!
                 '       , NULL AS TXT_ORIGEM'#13#10 + // -- REALMENTE NÃO EXISTE. TALVEZ UM DIA, QUEM SABE!
                 '       , RELCJF_DATA_ALTERACAO_PESQ(D.DTHRALT) AS DATA_ALTERACAO_PESQ'#13#10 +
                 '       , RELCJF_HIST_ALTERACAO(D.DTHRINCL,IDINCL,D.DTHRALT,D.IDALT) AS HIST_ALTERACAO'#13#10 +
                 '       , RELCJF_ITEOR(D.NUMPROC,D.DTHRMOV) AS ITEOR'#13#10 +
                 '    FROM DOCUMENTO D'#13#10 +
                 '   WHERE D.CODDOC IN (<:CODDOCS:>)';

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
         '                        FROM (<:SELECAO:>) SEL'#13#10 +
         '                       WHERE SEL.RN BETWEEN (%U-1) * %U + 1 AND %U * %U';

  SQL1 = '                              SELECT ROW_NUMBER() OVER (ORDER BY CODDOC) AS RN'#13#10 +
         '                                   , CODDOC'#13#10 +
         '                                FROM DOCUMENTO'#13#10 +
         '                               WHERE CODORIG = <:CODORIG:>'#13#10 +
         '                                 AND TIPSITOPER = ''A'''#13#10;

  SQL2 = '                                 AND CODTIPDOC = <:CODTIPDOC:>'#13#10;

  { TODO : A constução das datas abaixo pode precisar de ajustes para usar o dia inteiro }
  SQL3 = '                                 AND (DTHRINCL BETWEEN TO_DATE(''<:DATAINICIAL:>'', ''DD/MM/YYYY'') AND TO_DATE(''<:DATAFINAL:>'', ''DD/MM/YYYY'') OR DTHRALT BETWEEN TO_DATE(''<:DATAINICIAL:>'', ''DD/MM/YYYY'') AND TO_DATE(''<:DATAFINAL:>'', ''DD/MM/YYYY''))'#13#10;
var
  DataIni, DataFim: TDateTime;
  ZConnection: TZConnection;
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
      AddToLog('Intervalo.......................: De ' + FormatDateTime('dd/mm/yyyy',Configurations.PARAMETROSDATAINICIAL) + ' até ' + FormatDateTime('dd/mm/yyyy',Configurations.PARAMETROSDATAFINAL));
      FSQLLimitador := FSQLLimitador + SQL3;
      FSQLLimitador := StringReplace(FSQLLimitador,'<:DATAINICIAL:>',FormatDateTime('dd/mm/yyyy',Configurations.PARAMETROSDATAINICIAL),[rfReplaceAll]);
      FSQLLimitador := StringReplace(FSQLLimitador,'<:DATAFINAL:>',FormatDateTime('dd/mm/yyyy',Configurations.PARAMETROSDATAFINAL),[rfReplaceAll]);
    end;
    3: begin
      AddToLog('Número de meses no intervalo....: ' + IntToStr(Configurations.PARAMETROSNUMEROMESES));
      FSQLLimitador := FSQLLimitador + SQL3;

      DataFim := Now;
      DataIni := IncMonth(DataFim,-Configurations.PARAMETROSNUMEROMESES);

      FSQLLimitador := StringReplace(FSQLLimitador,'<:DATAINICIAL:>',FormatDateTime('dd/mm/yyyy',DataIni),[rfReplaceAll]);
      FSQLLimitador := StringReplace(FSQLLimitador,'<:DATAFINAL:>',FormatDateTime('dd/mm/yyyy',DataFim),[rfReplaceAll]);

      AddToLog('Data inicial....................: ' + FormatDateTime('dd/mm/yyyy',DataIni));
      AddToLog('Data final......................: ' + FormatDateTime('dd/mm/yyyy',DataFim));
    end;
  end;

  ZConnection := TZConnection.Create(Self);
  with ZConnection do
    try
      Database := Configurations.PARAMETROSDATABASE;
      HostName := Configurations.PARAMETROSHOSTNAME;
      Password := Configurations.PARAMETROSPASSWORD;
      Port     := Configurations.PARAMETROSPORTNUMB;
      Protocol := Configurations.PARAMETROSPROTOCOL;
      User     := Configurations.PARAMETROSUSERNAME;
      Connect;

      with TZReadOnlyQuery.Create(Self) do
        try
          Connection := ZConnection;
          SQL.Text := StringReplace(FSQLLimitador,'                              SELECT ROW_NUMBER() OVER (ORDER BY CODDOC) AS RN'#13#10'                                   , CODDOC'#13#10,'  SELECT COUNT(CODDOC)'#13#10,[]);
          Open;

          FTotalDeProcessos := Fields[0].AsInteger;

          AddToLog('Número de documentos a processar: ' + IntToStr(FTotalDeProcessos));
        finally
          Close;
          Free;
        end;

    finally
      Disconnect;
      Free;
    end;

  FSQLLimitador := StringReplace(SQL0,'<:SELECAO:>',Trim(FSQLLimitador),[]);
end;

{$WARNINGS OFF}
procedure TDataModule_Principal.IniciarProcessamento;
var
  i: Integer;
  RegistrosPorPagina: Cardinal;
  RegistrosFaltantes: Cardinal;
begin
  Form_Principal.Button_IniciarProcessamento.Enabled := False;

  Form_Principal.StatusBar_Principal.Panels[0].Text := 'Registros a processar: 0';
  Form_Principal.StatusBar_Principal.Panels[1].Text := 'Registros processados: 0';
  Form_Principal.StatusBar_Principal.Panels[2].Text := 'Threads executando: 0';
  Form_Principal.StatusBar_Principal.Panels[3].Text := 'Decorrido: 00:00:00';

  Form_Principal.Label_ThreadsPercent.Caption := '0%';
  Form_Principal.Label_RecordsPercent.Caption := '0%';

  Form_Principal.Memo_LogProcessamento.Clear;

  AddToLog('***** Sistema Geração de Relatorio CJF (Atenas) *****');
  AddToLog('');
  AddToLog('Geração CJF Iniciada ...');
  AddToLog('Inicio: ' + FormatDateTime('dd/mm/yyyy "às" hh:nn:ss',Now));
  AddToLog('');
  AddToLog('---------------------------------------------------------------------------------');
  AddToLog('Propriedades de geração:');

  { Obtém a contagem de registros e gera o SQL limitador }
  SQLLimitadorETotalDeProcessos;
  
  AddToLog('Origem..........................: ' + IntToStr(Configurations.PARAMETROSORIGEM));
  AddToLog('Tipo de Documento...............: ' + IntToStr(Configurations.PARAMETROSTIPODOCUMENTO));
  AddToLog('Total de páginas (Threads)......: ' + IntToStr(Configurations.PARAMETROSTOTALTHREADS));
  AddToLog('Operações simultâneas...........: ' + IntToStr(Configurations.PARAMETROSCONCURRENTTHREADS));
  AddToLog('---------------------------------------------------------------------------------');

  { Configura o progressbars }
  Form_Principal.ProgressBar_Threads.Position := 0;
  Form_Principal.ProgressBar_Threads.Step := 1;
  Form_Principal.ProgressBar_Threads.Max := Configurations.PARAMETROSTOTALTHREADS; //das configurações

  Form_Principal.ProgressBar_Documentos.Position := 0;
  Form_Principal.ProgressBar_Documentos.Step := 1;
  Form_Principal.ProgressBar_Documentos.Max := FTotalDeProcessos;

  Form_Principal.StatusBar_Principal.Panels[0].Text := 'Registros a processar: ' + IntToStr(Form_Principal.ProgressBar_Documentos.Max);

  RegistrosPorPagina := FTotalDeProcessos div Configurations.PARAMETROSTOTALTHREADS;
  RegistrosFaltantes := FTotalDeProcessos mod Configurations.PARAMETROSTOTALTHREADS;

  FInicio := Now;

  FAtivado := True;

  for i := 1 to Configurations.PARAMETROSTOTALTHREADS do
  begin
    with TTaskThread.Create(True) do
    begin
      FreeOnTerminate := True;
      Priority := tpLower;
      Memo := Form_Principal.Memo_LogProcessamento;
      ProgressBarRecord := Form_Principal.ProgressBar_Documentos;
      LabelRecordPercent := Form_Principal.Label_ThreadsPercent;
      ProgressBarThread := Form_Principal.ProgressBar_Threads;
      LabelThreadPercent := Form_Principal.Label_RecordsPercent;

      StatusBar := Form_Principal.StatusBar_Principal;
      Executing := @FEmExecucao;
      Generating := @FEmGeracao;
      ThreadSeq := i;

      if i = Configurations.PARAMETROSTOTALTHREADS then
        SQL := Format(StringReplace(SQL_TEMPLATE,'<:CODDOCS:>',FSQLLimitador,[]),[i,RegistrosPorPagina,i,RegistrosPorPagina + RegistrosFaltantes])
      else
        SQL := Format(StringReplace(SQL_TEMPLATE,'<:CODDOCS:>',FSQLLimitador,[]),[i,RegistrosPorPagina,i,RegistrosPorPagina]);

      if Configurations.PARAMETROSORDENARDADOS then
        SQL := SQL + #13#10'ORDER BY 1';

      Page := i;
      Database := Configurations.PARAMETROSDATABASE;
      HostName := Configurations.PARAMETROSHOSTNAME;
      Password := Configurations.PARAMETROSPASSWORD;
      PortNumb := Configurations.PARAMETROSPORTNUMB;
      Protocol := Configurations.PARAMETROSPROTOCOL;
      UserName := Configurations.PARAMETROSUSERNAME;
      Resume; { inicia a thread }
    end;
  end;
end;
{$WARNINGS ON}

procedure TDataModule_Principal.AddToLog(aLinha: String);
begin
  Form_Principal.Memo_LogProcessamento.Lines.Append(aLinha);
  PostMessage(Form_Principal.Memo_LogProcessamento.Handle, EM_SCROLLCARET, 0, 0);
end;

procedure TDataModule_Principal.CompilarXMLFinal;
var
  i: Word;
  XMLFinal, XMLPedaco: TextFile;
  Linha, Arquivo: String;
  Buffer: array [1..524288] of Char; { Buffer de 512K! }
begin

  try
    AddToLog('---------------------------------------------------------------------------------');

    AssignFile(XMLFinal,Configurations.PARAMETROSNOMEDOARQUIVO + '.xml');
    SetTextBuf(XMLFinal, Buffer);
    Rewrite(XMLFinal);

    AddToLog('Compilando XML Final...');
    for i := 1 to Configurations.PARAMETROSTOTALTHREADS do
      try
        Arquivo := Configurations.PARAMETROSNOMEDOARQUIVO + DupeString('0',5 - Length(IntToStr(i))) + IntToStr(i) + '.xml';

        AddToLog('Combinando ' + ExtractFileName(Arquivo) + '...');

        AssignFile(XMLPedaco,Arquivo);
        Reset(XMLPedaco);

        while not Eof(XMLPedaco) do
        begin
          ReadLn(XMLPedaco,Linha);
          WriteLn(XMLFinal,Linha);
        end;
      finally
        CloseFile(XMLPedaco);
        SysUtils.DeleteFile(Configurations.PARAMETROSNOMEDOARQUIVO + DupeString('0',5 - Length(IntToStr(i))) + IntToStr(i) + '.xml');
        AddToLog(ExtractFileName(Arquivo) + ' Combinado e excluído!');
      end;
  finally
    CloseFile(XMLFinal);
    AddToLog('XML Final compilado. Geração concluída!');
    AddToLog('---------------------------------------------------------------------------------');
  end;
end;

procedure TDataModule_Principal.ApplicationEvents_MonitoradorIdle(Sender: TObject; var Done: Boolean);
begin
  if FAtivado then
  begin
    Form_Principal.StatusBar_Principal.Panels[3].Text := FormatDateTime('"Decorrido: "hh:nn:ss',Now - FInicio);
    Form_Principal.StatusBar_Principal.Panels[2].Text := 'Threads executando: ' + IntToStr(FEmGeracao) + '/' + IntToStr(FEmExecucao);

    if Form_Principal.ProgressBar_Threads.Position = Form_Principal.ProgressBar_Threads.Max then
    begin
      FAtivado := False;

      AddToLog('---------------------------------------------------------------------------------');
      AddToLog('');
      AddToLog('Fim: ' + FormatDateTime('dd/mm/yyyy "às" hh:nn:ss',Now));
      AddToLog('Geração CJF concluída!');
      AddToLog('');
      AddToLog('*********************************************************************************');

      CompilarXMLFinal;
      ZiparArquivo;

      if ParametroBooleanoPresente('/AUTOMATICO') then
      begin
        TransmitirArquivo;
        Form_Principal.Close;
      end
      else
      begin
        if MessageBox(Form_Principal.Handle,'Deseja transmitir o arquivo agora?','Transmitir?',MB_ICONQUESTION or MB_YESNO) = IDYES then
          TransmitirArquivo;

        Form_Principal.Button_IniciarProcessamento.Enabled := True;
      end;
    end;
  end;
end;

procedure TDataModule_Principal.DataModuleCreate(Sender: TObject);
begin
  FAtivado := False;
end;

procedure TDataModule_Principal.ZiparArquivo;
var
  TmpStr: String;
begin
  AddToLog('---------------------------------------------------------------------------------');

  with ZipMaster_Compressor do
  begin
    ZipFilename := Configurations.PARAMETROSNOMEDOARQUIVO + '.zip';

    { Colocar mensagem no log }
    ZipMaster_CompressorMessage(Self, 0, 'Criando arquivo ' + ZipMaster_Compressor.ZipFileName + '...');

    { Atribuindo lista de arquivos. No caso apenas um arquivo fixo }
    FSpecArgs.Add(Configurations.PARAMETROSNOMEDOARQUIVO + '.xml');

    AddOptions := [];

    try
      Add;

      TmpStr := 'Arquivo Criado! ';

      if SuccessCnt = 1 then
        TmpStr := TmpStr + '(' + IntToStr(SuccessCnt) + ' arquivo comprimido)'
      else
        TmpStr := TmpStr + '(' + IntToStr(SuccessCnt) + ' arquivos comprimidos)';

      ZipMaster_CompressorMessage(Self, 0, TmpStr);

      ZipMaster_CompressorMessage(Self, 0, 'Excluindo arquivo original...');

      if FileExists(ZipFilename) then
        SysUtils.DeleteFile(Configurations.PARAMETROSNOMEDOARQUIVO + '.xml');

      ZipMaster_CompressorMessage(Self, 0, 'Arquivo original excluído!');
    except
      MessageBox(Form_Principal.Handle,'Erro ao comprimir','Exceção fatal no DLL',MB_ICONERROR);
    end;
  end;

  AddToLog('---------------------------------------------------------------------------------');
end;

procedure TDataModule_Principal.ZipMaster_CompressorMessage(Sender: TObject; ErrCode: Integer; Message: String);
begin
  if (ErrCode > 0) and not ZipMaster_Compressor.Unattended then
    AddToLog('[' + FormatDateTime('hh:nn:ss',Now) + '] ZIP (ERRO): ' + Trim(Message))
  else
    AddToLog('[' + FormatDateTime('hh:nn:ss',Now) + '] ZIP: ' + Trim(Message));
end;

procedure TDataModule_Principal.ZipMaster_CompressorProgress(Sender: TObject; ProgrType: ProgressType; Filename: String; FileSize: Integer);
begin
  case ProgrType of
    TotalSize2Process: begin
      Form_Principal.Label_Registros.Caption := 'Percentual do arquivo';
      Form_Principal.ProgressBar_Documentos.Position := 0;
      Form_Principal.ProgressBar_Documentos.Max := FileSize;
      Form_Principal.Label_RecordsPercent.Caption := '0%';
    end;
    TotalFiles2Process: begin
      Form_Principal.Label_Threads.Caption := 'Percentual total';
      Form_Principal.ProgressBar_Threads.Position := 0;
      Form_Principal.ProgressBar_Threads.Max := FileSize;
      Form_Principal.ProgressBar_Threads.Step := 1;

      Form_Principal.Label_ThreadsPercent.Caption := '0%';
    end;
    NewFile: begin
      Form_Principal.ProgressBar_Documentos.Position := 0;
      Form_Principal.ProgressBar_Documentos.Max := FileSize;
      Form_Principal.Label_RecordsPercent.Caption := '0%';

      Form_Principal.ProgressBar_Threads.StepIt;
      Form_Principal.Label_ThreadsPercent.Caption := IntToStr(Round(Form_Principal.ProgressBar_Threads.Position / Form_Principal.ProgressBar_Threads.Max * 100)) + '%';
    end;
    ProgressUpdate: begin
      Form_Principal.ProgressBar_Documentos.Position := Form_Principal.ProgressBar_Documentos.Position + FileSize;
      Form_Principal.Label_RecordsPercent.Caption := IntToStr(Round(Form_Principal.ProgressBar_Documentos.Position / Form_Principal.ProgressBar_Documentos.Max * 100)) + '%';
    end;
    EndOfBatch: begin
      Form_Principal.Label_Registros.Caption := 'Registros processados';
      Form_Principal.Label_Threads.Caption := 'Threads executadas';
    end;
  end;
end;

procedure TDataModule_Principal.TransmitirArquivo;
begin
  try
    AddToLog('---------------------------------------------------------------------------------');
    Form_Principal.Label_Registros.Caption := 'Percentual do arquivo';
    Form_Principal.Label_Threads.Caption := 'Percentual total';
    Form_Principal.Label_ThreadsPercent.Caption := '0%';
    Form_Principal.Label_RecordsPercent.Caption := '0%';

    Form_Principal.ProgressBar_Threads.Position := 0;
    Form_Principal.ProgressBar_Threads.Max := 1;
    Form_Principal.ProgressBar_Threads.Step := 1;

    Form_Principal.ProgressBar_Documentos.Position := 0;
    Form_Principal.ProgressBar_Documentos.Max := FileSize(Configurations.PARAMETROSNOMEDOARQUIVO + '.zip');

    FtpClient_Envio.HostName      := Configurations.ENVIOSERIVIDOR;
    FtpClient_Envio.Port          := '21';
    FtpClient_Envio.UserName      := Configurations.ENVIOUSERNAME;
    FtpClient_Envio.PassWord      := Configurations.ENVIOPASSWORD;
    FtpClient_Envio.HostDirName   := Configurations.ENVIOREMOTEDIR;
    FtpClient_Envio.HostFileName  := ExtractFileName(Configurations.PARAMETROSNOMEDOARQUIVO + '.zip');
    FtpClient_Envio.LocalFileName := Configurations.PARAMETROSNOMEDOARQUIVO + '.zip';
    FtpClient_Envio.Binary        := True;
    FtpClient_Envio.Passive       := True;
    FtpClient_Envio.Options       := FtpClient_Envio.Options - [ftpBandwidthControl];
    ExecuteCmd(FtpClient_Envio.Transmit, FtpClient_Envio.TransmitAsync);
  finally
    Form_Principal.Label_Registros.Caption := 'Registros processados';
    Form_Principal.Label_Threads.Caption := 'Threads executadas';
    AddToLog('---------------------------------------------------------------------------------');
  end;
end;

procedure TDataModule_Principal.FtpClient_EnvioDisplay(Sender: TObject; var Msg: String);
begin
  AddToLog('[' + FormatDateTime('hh:nn:ss',Now) + '] FTP: ' + Msg);
end;

procedure TDataModule_Principal.ExecuteCmd(SyncCmd: TSyncCmd; ASyncCmd: TAsyncCmd);
begin
  AddToLog('[' + FormatDateTime('hh:nn:ss',Now) + '] FTP: Executando comando');

  { Initialize progress stuff }
    //FLastProgress  := 0;
//    FProgressCount := 0;

  if Configurations.ENVIOSINCRONO then
  begin
    if SyncCmd then
      AddToLog('[' + FormatDateTime('hh:nn:ss',Now) + '] FTP: Comando bem sucedido')
    else
      AddToLog('[' + FormatDateTime('hh:nn:ss',Now) + '] FTP: Comando mal sucedido');
  end
  else
    ASyncCmd;
end;

procedure TDataModule_Principal.FtpClient_EnvioRequestDone(Sender: TObject; RqType: TFtpRequest; ErrCode: Word);
begin
  AddToLog('[' + FormatDateTime('hh:nn:ss',Now) + '] FTP: Requisição ' + LookupFTPReq(RqType) + ' conlcuída!');
  AddToLog('[' + FormatDateTime('hh:nn:ss',Now) + '] FTP: StatusCode = ' + IntToStr(FtpClient_Envio.StatusCode));
  AddToLog('[' + FormatDateTime('hh:nn:ss',Now) + '] FTP: Última resposta = ' + FtpClient_Envio.LastResponse);

  if ErrCode = 0 then
    AddToLog('[' + FormatDateTime('hh:nn:ss',Now) + '] FTP: Sem erros')
  else
    AddToLog('[' + FormatDateTime('hh:nn:ss',Now) + '] FTP: Erro = ' + IntToStr(ErrCode) + ' (' + FtpClient_Envio.ErrorMessage + ')');
end;

procedure TDataModule_Principal.FtpClient_EnvioSessionClosed(Sender: TObject; ErrCode: Word);
begin
  AddToLog('[' + FormatDateTime('hh:nn:ss',Now) + '] FTP: Sessão finalizada, erro = ' + IntToStr(ErrCode));
end;

procedure TDataModule_Principal.FtpClient_EnvioSessionConnected(Sender: TObject; ErrCode: Word);
begin
  AddToLog('[' + FormatDateTime('hh:nn:ss',Now) + '] FTP: Sessão conectada, erro = ' + IntToStr(ErrCode));
end;

procedure TDataModule_Principal.FtpClient_EnvioProgress64(Sender: TObject; Count: Int64; var Abort: Boolean);
begin
  Form_Principal.ProgressBar_Documentos.Position := Count;

  if Count >= Form_Principal.ProgressBar_Documentos.Max then
    Form_Principal.ProgressBar_Threads.StepIt;

  Form_Principal.Label_ThreadsPercent.Caption := IntToStr(Round(Form_Principal.ProgressBar_Threads.Position / Form_Principal.ProgressBar_Threads.Max * 100)) + '%';
  Form_Principal.Label_RecordsPercent.Caption := IntToStr(Round(Form_Principal.ProgressBar_Documentos.Position / Form_Principal.ProgressBar_Documentos.Max * 100)) + '%';
end;

function TDataModule_Principal.FileSize(aFileName: TFileName): Int64;
var
	FOB: file of 0..255;
begin
  try
    AssignFile(FOB,aFileName);
    Reset(FOB);
    Result := System.FileSize(FOB);
  finally
    CloseFile(FOB);
  end;
end;

function TDataModule_Principal.ParametroBooleanoPresente(aParamStr: String): Boolean;
var
  i: Byte;
begin
  Result := False;
  
  if ParamCount > 0 then
    for i := 1 to ParamCount do
      if AnsiUpperCase(ParamStr(i)) = AnsiUpperCase(aParamStr) then
      begin
        Result := True;
        Break;
      end;
end;

procedure TDataModule_Principal.ProcessarLinhaDeComando;
begin
  if ParametroBooleanoPresente('/AUTOMATICO') then
  begin
    Form_Principal.Button_IniciarProcessamento.Click;
    Form_Principal.Button_IniciarProcessamento.Enabled := False;
  end;
end;

end.


