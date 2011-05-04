unit UDataModule_Principal;

interface

uses
  SysUtils, Classes, ZConnection, DB, ZAbstractRODataset, ZDataset,
  ZAbstractDataset, Dialogs;

type
  TDataModule_Principal = class(TDataModule)
    TRF5PRD: TZConnection;
    HISTORICO: TZReadOnlyQuery;
    DS_HISTORICO: TDataSource;
    DETALHES: TZReadOnlyQuery;
    DS_DETALHES: TDataSource;
    DETALHESIDVERIFICACAO: TLargeintField;
    DETALHESDONO: TStringField;
    DETALHESTABELA: TStringField;
    DETALHESDATACRIACAO: TStringField;
    DETALHESDATAMODIFICACAO: TStringField;
    DETALHESTRIGGERS: TLargeintField;
    DETALHESTABELALOG: TStringField;
    DETALHESDATACRIACAOLOG: TStringField;
    DETALHESDATAMODIFICACAOLOG: TStringField;
    SaveDialog_Script: TSaveDialog;
    DETALHESIDVERIFICACAODET: TLargeintField;
    COLUNAS: TZReadOnlyQuery;
    DS_COLUNAS: TDataSource;
    COLUNASDONO: TStringField;
    COLUNASTABELAORI: TStringField;
    COLUNASCOLUNAORI: TStringField;
    COLUNASTIPOORI: TStringField;
    COLUNASTAMANHOORI: TLargeintField;
    COLUNASPRECISAOORI: TLargeintField;
    COLUNASESCALAORI: TLargeintField;
    COLUNASANULAVELORI: TStringField;
    COLUNASTIPOALTER: TStringField;
    procedure DataModuleCreate(Sender: TObject);
    procedure DETALHESDATACRIACAOLOGGetText(Sender: TField; var Text: String; DisplayText: Boolean);
    procedure DETALHESDATAMODIFICACAOLOGGetText(Sender: TField; var Text: String; DisplayText: Boolean);
    procedure COLUNASANULAVELORIGetText(Sender: TField; var Text: String;
      DisplayText: Boolean);
  private
    { Private declarations }
  public
    { Public declarations }
    procedure Verificar;
    procedure GerarScript;
  end;

var
  DataModule_Principal: TDataModule_Principal;

implementation

uses UForm_Principal, Forms, Math, StrUtils, UConfiguracoes;

{$R *.dfm}

const
  HISTVERIFICALOG_INSERT =
  'INSERT INTO <:OWNER:>.HISTVERIFICALOG'#13#10 +
  '     VALUES (<:OWNER:>.HVL_SQ.NEXTVAL,SYSDATE)';


  HISTVERIFICALOGDET_INSERT =
  'INSERT INTO <:OWNER:>.HISTVERIFICALOGDET'#13#10 +
  '     SELECT ROWNUM + <:NEXTVAL:> IDVERIFICACAODET'#13#10 +
  '          , <:CURRVAL:> AS IDVERIFICACAO'#13#10 +
  '          , AON.OWNER AS DONO'#13#10 +
  '          , AON.OBJECT_NAME AS TABELA'#13#10 +
  '          , AON.CREATED AS DATACRIACAO'#13#10 +
  '          , AON.LAST_DDL_TIME AS DATAMODIFICACAO'#13#10 +
  '          , (SELECT COUNT(*)'#13#10 +
  '               FROM SYS.ALL_TRIGGERS'#13#10 +
  '              WHERE TABLE_NAME = AON.OBJECT_NAME'#13#10 +
  '                AND TABLE_OWNER = ''<:OWNER:>'') AS TRIGGERS'#13#10 +
  '          , AOL.TABELALOG'#13#10 +
  '          , AOL.DATACRIACAOLOG'#13#10 +
  '          , AOL.DATAMODIFICACAOLOG'#13#10 +
  '       FROM SYS.ALL_OBJECTS AON'#13#10 +
  '       LEFT JOIN (SELECT OBJECT_NAME AS TABELALOG'#13#10 +
  '                       , CREATED AS DATACRIACAOLOG'#13#10 +
  '                       , LAST_DDL_TIME AS DATAMODIFICACAOLOG'#13#10 +
  '                    FROM SYS.ALL_OBJECTS'#13#10 +
  '                   WHERE OBJECT_TYPE = ''TABLE'''#13#10 +
  '                     AND OBJECT_NAME NOT LIKE ''%$%'''#13#10 +
  '                     AND OBJECT_NAME LIKE ''LOG%'''#13#10 +
  '                     AND SUBOBJECT_NAME IS NULL'#13#10 +
  '                     AND TEMPORARY = ''N'''#13#10 +
  '                     AND (OWNER = ''<:OWNER:>'')) AOL ON ''LOG'' || AON.OBJECT_NAME = AOL.TABELALOG'#13#10 +
  '      WHERE OBJECT_TYPE = ''TABLE'''#13#10 +
  '        AND OBJECT_NAME NOT LIKE ''%$%'''#13#10 +
  '        AND OBJECT_NAME NOT LIKE ''LOG%'''#13#10 +
  '        AND OBJECT_NAME NOT IN (''HISTVERIFICALOG'',''HISTVERIFICALOGDET'')'#13#10 +
  '        AND SUBOBJECT_NAME IS NULL'#13#10 +
  '        AND TEMPORARY = ''N'''#13#10 +
  '        AND (OWNER = ''<:OWNER:>'')';

  HISTVERIFICALOGCOL_INSERT =
  'INSERT INTO <:OWNER:>.HISTVERIFICALOGCOL'#13#10 +
  '     SELECT ROWNUM + <:NEXTVAL:> IDVERIFICACAOCOL'#13#10 +
  '          , <:CURRVAL:> AS IDVERIFICACAO'#13#10 +
  '          , ORI.OWNER AS DONO'#13#10 +
  '          , ORI.TABLE_NAME AS TABELAORI'#13#10 +
  '          , ORI.COLUMN_NAME AS COLUNAORI'#13#10 +
  '          , ORI.DATA_TYPE AS TIPOORI'#13#10 +
  '          , ORI.DATA_LENGTH AS TAMANHOORI'#13#10 +
  '          , ORI.DATA_PRECISION AS PRECISAOORI'#13#10 +
  '          , ORI.DATA_SCALE AS ESCALAORI'#13#10 +
  '          , ORI.NULLABLE AS ANULAVELORI'#13#10 +
  '          , DECODE(LOG.TABLE_NAME,NULL,''ADD'',''MODIFY'') AS ALTERTYPE'#13#10 +
  '          , LOG.TABLE_NAME AS TABELALOG'#13#10 +
  '          , LOG.COLUMN_NAME AS COLUNALOG'#13#10 +
  '          , LOG.DATA_TYPE AS TIPOLOG'#13#10 +
  '          , LOG.DATA_LENGTH AS TAMANHOLOG'#13#10 +
  '          , LOG.DATA_PRECISION AS PRECISAOLOG'#13#10 +
  '          , LOG.DATA_SCALE AS ESCALALOG'#13#10 +
  '          , LOG.NULLABLE AS ANULAVELLOG'#13#10 +
  '       FROM SYS.ALL_TAB_COLUMNS ORI'#13#10 +
  '       JOIN HISTVERIFICALOGDET HVD ON HVD.TABELA = ORI.TABLE_NAME'#13#10 +
  '  LEFT JOIN (SELECT LOG.OWNER'#13#10 +
  '                  , LOG.TABLE_NAME'#13#10 +
  '                  , LOG.COLUMN_NAME'#13#10 +
  '                  , LOG.DATA_TYPE'#13#10 +
  '                  , LOG.DATA_LENGTH'#13#10 +
  '                  , LOG.DATA_PRECISION'#13#10 +
  '                  , LOG.DATA_SCALE'#13#10 +
  '                  , LOG.NULLABLE'#13#10 +
  '               FROM SYS.ALL_TAB_COLUMNS LOG'#13#10 +
  '               JOIN HISTVERIFICALOGDET HVD ON HVD.TABELALOG = LOG.TABLE_NAME'#13#10 +
  '              WHERE HVD.IDVERIFICACAO = <:CURRVAL:>'#13#10 +
  '                AND LOG.OWNER = ''<:OWNER:>'') LOG ON LOG.TABLE_NAME = ''LOG'' || ORI.TABLE_NAME AND LOG.COLUMN_NAME = ORI.COLUMN_NAME'#13#10 +
  '      WHERE HVD.IDVERIFICACAO = <:CURRVAL:>'#13#10 +
  '        AND ORI.OWNER = ''<:OWNER:>'''#13#10 +
  '        AND (   LOG.TABLE_NAME     IS NULL'#13#10 +
  '             OR LOG.DATA_TYPE      <> ORI.DATA_TYPE'#13#10 +
  '             OR LOG.DATA_LENGTH    <> ORI.DATA_LENGTH'#13#10 +
  '             OR LOG.DATA_PRECISION <> ORI.DATA_PRECISION'#13#10 +
  '             OR LOG.DATA_SCALE     <> ORI.DATA_SCALE'#13#10 +
  '             OR LOG.NULLABLE       <> ''Y'')';

  TABELAS_SELECTCLAUSE =
  '  SELECT AON.OBJECT_NAME AS TABELA'#13#10 +
  '       , (SELECT COUNT(*)'#13#10 +
  '            FROM SYS.ALL_TRIGGERS'#13#10 +
  '           WHERE TABLE_NAME = AON.OBJECT_NAME'#13#10 +
  '             AND TABLE_OWNER = ''<:OWNER:>'') AS TRIGGERS'#13#10 +
  '       , AOL.TABELALOG';

  TABELAS_SELECT =
  '<:SELECT:>'#13#10 +
  '    FROM SYS.ALL_OBJECTS AON'#13#10 +
  '    LEFT JOIN (SELECT OBJECT_NAME AS TABELALOG'#13#10 +
  '                    , CREATED AS DATACRIACAOLOG'#13#10 +
  '                    , LAST_DDL_TIME AS DATAMODIFICACAOLOG'#13#10 +
  '                 FROM SYS.ALL_OBJECTS'#13#10 +
  '                WHERE OBJECT_TYPE = ''TABLE'''#13#10 +
  '                  AND OBJECT_NAME NOT LIKE ''%$%'''#13#10 +
  '                  AND OBJECT_NAME LIKE ''LOG%'''#13#10 +
  '                  AND SUBOBJECT_NAME IS NULL'#13#10 +
  '                  AND TEMPORARY = ''N'''#13#10 +
  '                  AND (OWNER = ''<:OWNER:>'')) AOL ON ''LOG'' || AON.OBJECT_NAME = AOL.TABELALOG'#13#10 +
  '   WHERE OBJECT_TYPE = ''TABLE'''#13#10 +
  '     AND OBJECT_NAME NOT LIKE ''%$%'''#13#10 +
  '     AND OBJECT_NAME NOT LIKE ''LOG%'''#13#10 +
  '     AND OBJECT_NAME NOT IN (''HISTVERIFICALOG'',''HISTVERIFICALOGDET'')'#13#10 +
  '     AND SUBOBJECT_NAME IS NULL'#13#10 +
  '     AND TEMPORARY = ''N'''#13#10 +
  '     AND (OWNER = ''<:OWNER:>'')'#13#10 +
  'ORDER BY OBJECT_NAME';

  COLUNAS_SELECT =
  '  SELECT COL.COLUMN_NAME'#13#10 +
  '       , COL.DATA_TYPE'#13#10 +
  '       , COL.DATA_LENGTH'#13#10 +
  '       , COL.DATA_PRECISION'#13#10 +
  '       , COL.DATA_SCALE'#13#10 +
  '       , COL.NULLABLE'#13#10 +
  '    FROM SYS.ALL_TAB_COLUMNS COL'#13#10 +
  '   WHERE COL.OWNER = ''<:OWNER:>'''#13#10 +
  '     AND COL.TABLE_NAME = ''<:TABELA:>'''#13#10 +
  'ORDER BY COL.COLUMN_ID';

  TRIGGER_TEMPLATE =
  'CREATE OR REPLACE TRIGGER <:TABELA:>_LOG AFTER UPDATE OR INSERT OR DELETE ON <:TABELA:> FOR EACH ROW'#13#10 +
  'DECLARE'#13#10 +
  '  vTIPOPER CHAR(1);'#13#10 +
  'BEGIN'#13#10 +
  '  IF INSERTING THEN'#13#10 +
  '    vTIPOPER := ''I'';'#13#10 +
  '  ELSIF UPDATING THEN'#13#10 +
  '    vTIPOPER := ''A'';'#13#10 +
  '  ELSIF DELETING THEN'#13#10 +
  '    vTIPOPER := ''E'';'#13#10 +
  '  END IF;'#13#10 +
  ''#13#10 +
  '  INSERT INTO LOG<:TABELA:>'#13#10 +
  '       VALUES (SYSDATE'#13#10 +
  '              ,UPPER(USER)'#13#10 +
  '              ,vTIPOPER'#13#10 +
  '<:CAMPOS:>);'#13#10 +
  'END;';

  CAMPOTRIGGER_TEMPLATE =
  '              ,DECODE(vTIPOPER,''I'',:NEW.<:CAMPO:>,''U'',:NEW.<:CAMPO:>,:OLD.<:CAMPO:>)';

  LOG_TEMPLATE =
  'CREATE TABLE LOG<:TABELA:>'#13#10 +
  '            (DTHRALT DATE NOT NULL'#13#10 +
  '            ,USUALT VARCHAR2(30) NOT NULL'#13#10 +
  '            ,TIPOPER CHAR(1) NOT NULL'#13#10 +
  '<:CAMPOS:>);'#13#10 +
  ''#13#10 +
  'GRANT SELECT, INSERT, UPDATE, DELETE, ALTER ON LOG<:TABELA:> TO ESPARTA_ROLE;'#13#10 +
  'GRANT SELECT, INSERT, UPDATE, DELETE, ALTER ON LOG<:TABELA:> TO ESPARTA2_ROLE;';

  CAMPOLOG_TEMPLATE =
  '            ,<:CAMPO:> <:TIPO:>'#13#10; //TODOS OS CAMPOS DAS TABELAS DE LOG ACEITAM NULO

  LOGALTER_TEMPLATE =
  'ALTER TABLE LOG<:TABELA:> <:ACAO:> <:CAMPO:> <:TIPO:>;'#13#10;

//  alter table LOGACORDAOPROCESSO modify USUALT VARCHAR2(40);
//alter table LOGACORDAOPROCESSO modify CODDOC varchar2(50);
//alter table LOGACORDAOPROCESSO add XXX blob;

  LOG_VERIFICACAO =
  'SELECT ORI.COLUMN_NAME'#13#10 +
  '     , ORI.DATA_TYPE'#13#10 +
  '     , ORI.DATA_LENGTH'#13#10 +
  '     , ORI.DATA_PRECISION'#13#10 +
  '     , ORI.DATA_SCALE'#13#10 +
  '     , DECODE(LOG.COLUMN_NAME,NULL,''ADD'',''MODIFY'') AS ALTERTYPE'#13#10 +
  '  FROM SYS.ALL_TAB_COLUMNS ORI'#13#10 +
  '  LEFT JOIN (SELECT COL.COLUMN_NAME'#13#10 +
  '                  , COL.DATA_TYPE'#13#10 +
  '                  , COL.DATA_LENGTH'#13#10 +
  '                  , COL.DATA_PRECISION'#13#10 +
  '                  , COL.DATA_SCALE'#13#10 +
  '                  , COL.NULLABLE'#13#10 +
  '               FROM SYS.ALL_TAB_COLUMNS COL'#13#10 +
  '              WHERE COL.OWNER = ''<:OWNER:>'''#13#10 +
  '                AND COL.TABLE_NAME = ''LOG<:TABELA:>'') LOG ON LOG.COLUMN_NAME = ORI.COLUMN_NAME'#13#10 +
  ' WHERE ORI.OWNER = ''<:OWNER:>'''#13#10 +
  '   AND ORI.TABLE_NAME = ''<:TABELA:>'''#13#10 +
  '   AND (   LOG.COLUMN_NAME    IS NULL'#13#10 +
  '        OR LOG.DATA_TYPE      <> ORI.DATA_TYPE'#13#10 +
  '        OR LOG.DATA_LENGTH    <> ORI.DATA_LENGTH'#13#10 +
  '        OR LOG.DATA_PRECISION <> ORI.DATA_PRECISION'#13#10 +
  '        OR LOG.DATA_SCALE     <> ORI.DATA_SCALE'#13#10 +
  '        OR LOG.NULLABLE       <> ''Y'')';


//SELECT *
//  FROM HISTVERIFICALOGDET
// WHERE TABELALOG IS NOT NULL

{

O SQL ABAIXO RETORNA TODAS AS DIFERENÇAS EXISTENTES

  SELECT ORI.TABLE_NAME
       , ORI.COLUMN_NAME
       , ORI.DATA_TYPE
       , ORI.DATA_LENGTH
       , ORI.DATA_PRECISION
       , ORI.DATA_SCALE
       , DECODE(LOG.COLUMN_NAME,NULL,'ADD','ALTER') AS FUNCAO
    FROM SYS.ALL_TAB_COLUMNS ORI
    LEFT JOIN (SELECT COL.TABLE_NAME
                    , COL.COLUMN_NAME
                    , COL.DATA_TYPE
                    , COL.DATA_LENGTH
                    , COL.DATA_PRECISION
                    , COL.DATA_SCALE
                    , COL.NULLABLE
                 FROM SYS.ALL_TAB_COLUMNS COL
                WHERE COL.OWNER = 'ESPARTA2') LOG ON LOG.COLUMN_NAME = ORI.COLUMN_NAME AND LOG.TABLE_NAME = 'LOG' || ORI.TABLE_NAME
   WHERE ORI.OWNER = 'ESPARTA2'
     AND (   LOG.COLUMN_NAME    IS NULL 
          OR LOG.DATA_TYPE      <> ORI.DATA_TYPE 
          OR LOG.DATA_LENGTH    <> ORI.DATA_LENGTH 
          OR LOG.DATA_PRECISION <> ORI.DATA_PRECISION 
          OR LOG.DATA_SCALE     <> ORI.DATA_SCALE
          OR LOG.NULLABLE       <> 'Y')
ORDER BY ORI.COLUMN_ID;
}
{ TDataModule_Principal }

procedure TDataModule_Principal.Verificar;
var
  IDVerificacao, NextValue: String;
begin
  with TZReadOnlyQuery.Create(Self) do
    try
      Connection := TRF5PRD;
      ParamCheck := False;

      { Insere a informação inicial }
      SQL.Text := HISTVERIFICALOG_INSERT;
      SQL.Text := StringReplace(HISTVERIFICALOG_INSERT,'<:OWNER:>',Configuracoes.CONFIGURACOESOBJOWNER,[rfReplaceAll]);
      ExecSQL;

      { Obtém o valor atual da sequencia HVL que é a chave gerada na inserção
      anterior. A chave representa ligação mestre detalhe }
      Close;
      SQL.Text := 'SELECT ESPARTA2.HVL_SQ.CURRVAL FROM DUAL';
      Open;
      IDVerificacao := Fields[0].AsString;

      { Obtém a próxima chave gerada para a tabela HISTVERIFICALOGDET.
      Infelizmente não é possível usar as sequencias }
      Close;
      SQL.Text := 'SELECT NVL(MAX(IDVERIFICACAODET),0) + 1 FROM HISTVERIFICALOGDET';
      Open;
      NextValue := Fields[0].AsString;

      { Executa a inserção de todos os registros "detalhe" de acordo com as
      chaves previamente encontradas }
      Close;
      SQL.Text := StringReplace(HISTVERIFICALOGDET_INSERT,'<:OWNER:>',Configuracoes.CONFIGURACOESOBJOWNER,[rfReplaceAll]);
      SQL.Text := StringReplace(SQL.Text,'<:CURRVAL:>',IDVerificacao,[rfReplaceAll]);
      SQL.Text := StringReplace(SQL.Text,'<:NEXTVAL:>',NextValue,[rfReplaceAll]);
      ExecSQL;

      { Obtém a próxima chave gerada para a tabela HISTVERIFICALOGCOL.
      Infelizmente não é possível usar as sequencias }
      Close;
      SQL.Text := 'SELECT NVL(MAX(IDVERIFICACAOCOL),0) + 1 FROM HISTVERIFICALOGCOL';
      Open;
      NextValue := Fields[0].AsString;

      { Baseado na tabela de detalhe, preenchida anteriormente, cria-se uma
      tabela detalhe da tabela de detalhe, mas apenas para, registros que
      indicam a existência de tabelas de log }
      Close;
      SQL.Text := StringReplace(HISTVERIFICALOGCOL_INSERT,'<:OWNER:>',Configuracoes.CONFIGURACOESOBJOWNER,[rfReplaceAll]);
      SQL.Text := StringReplace(SQL.Text,'<:CURRVAL:>',IDVerificacao,[rfReplaceAll]);
      SQL.Text := StringReplace(SQL.Text,'<:NEXTVAL:>',NextValue,[rfReplaceAll]);
      ExecSQL;

    finally
      Close;
      HISTORICO.Refresh;
      HISTORICO.First;
      Free;
    end;
end;

procedure TDataModule_Principal.DataModuleCreate(Sender: TObject);
begin
  TRF5PRD.Database := Configuracoes.CONFIGURACOESDATABASE;
  TRF5PRD.HostName := Configuracoes.CONFIGURACOESHOSTNAME;
  TRF5PRD.Password := Configuracoes.CONFIGURACOESPASSWORD;
  TRF5PRD.Protocol := Configuracoes.CONFIGURACOESPROTOCOL;
  TRF5PRD.User     := Configuracoes.CONFIGURACOESUSERNAME;
  
  TRF5PRD.Connect;

  if TRF5PRD.Connected then
  begin
    HISTORICO.ParamCheck := False;
    HISTORICO.SQL.TEXT :=
    '  SELECT IDVERIFICACAO'#13#10 +
    '       , TO_CHAR(DTHRVERIFICACAO,''DD/MM/YYYY "às" HH24:MI:SS'') AS DTHRVERIFICACAO'#13#10 +
    '       , DTHRVERIFICACAO AS DATAPURA'#13#10 +
    '    FROM <:OWNER:>.HISTVERIFICALOG'#13#10 +
    'ORDER BY 3 DESC';
    HISTORICO.SQL.Text := StringReplace(HISTORICO.SQL.Text,'<:OWNER:>',Configuracoes.CONFIGURACOESOBJOWNER,[rfReplaceAll]);
    DETALHES.ParamCheck := True;
    HISTORICO.Open;

    DETALHES.ParamCheck := False;
    DETALHES.SQL.Text :=
    '  SELECT IDVERIFICACAODET'#13#10 +
    '       , IDVERIFICACAO'#13#10 +
    '       , DONO'#13#10 +
    '       , TABELA'#13#10 +
    '       , TO_CHAR(DATACRIACAO,''DD/MM/YYYY "às" HH24:MI:SS'') AS DATACRIACAO'#13#10 +
    '       , TO_CHAR(DATAMODIFICACAO,''DD/MM/YYYY "às" HH24:MI:SS'') AS DATAMODIFICACAO'#13#10 +
    '       , TRIGGERS'#13#10 +
    '       , TABELALOG'#13#10 +
    '       , TO_CHAR(DATACRIACAOLOG,''DD/MM/YYYY "às" HH24:MI:SS'') AS DATACRIACAOLOG'#13#10 +
    '       , TO_CHAR(DATAMODIFICACAOLOG,''DD/MM/YYYY "às" HH24:MI:SS'') AS DATAMODIFICACAOLOG'#13#10 +
    '    FROM <:OWNER:>.HISTVERIFICALOGDET'#13#10 +
    '   WHERE IDVERIFICACAO = :IDVERIFICACAO'#13#10 +
    'ORDER BY TABELA';
    DETALHES.SQL.Text := StringReplace(DETALHES.SQL.Text,'<:OWNER:>',Configuracoes.CONFIGURACOESOBJOWNER,[rfReplaceAll]);
    DETALHES.ParamCheck := True;
    DETALHES.Open;

    COLUNAS.ParamCheck := False;
    COLUNAS.SQL.Text :=
    'SELECT DONO'#13#10 +
    '     , TABELAORI'#13#10 +
    '     , COLUNAORI'#13#10 +
    '     , TIPOORI'#13#10 +
    '     , TAMANHOORI'#13#10 +
    '     , PRECISAOORI'#13#10 +
    '     , ESCALAORI'#13#10 +
    '     , ''S'' AS ANULAVELORI'#13#10 +
    '     , TIPOALTER'#13#10 +
    '  FROM <:OWNER:>.HISTVERIFICALOGCOL'#13#10 +
    ' WHERE IDVERIFICACAO = :IDVERIFICACAO'#13#10 +
    '   AND TABELAORI = :TABELA';
    COLUNAS.SQL.Text := StringReplace(COLUNAS.SQL.Text,'<:OWNER:>',Configuracoes.CONFIGURACOESOBJOWNER,[rfReplaceAll]);
    COLUNAS.ParamCheck := True;
    COLUNAS.Open;
  end;
end;

procedure TDataModule_Principal.DETALHESDATACRIACAOLOGGetText(Sender: TField; var Text: String; DisplayText: Boolean);
begin
  if Sender.isNull then
    Text := 'N/A'
  else
    Text := Sender.AsString;
end;

procedure TDataModule_Principal.DETALHESDATAMODIFICACAOLOGGetText(Sender: TField; var Text: String; DisplayText: Boolean);
begin
  if Sender.isNull then
    Text := 'N/A'
  else
    Text := Sender.AsString;
end;

procedure TDataModule_Principal.GerarScript;
var
  Triggers, TabelasDeLog: TStringList;
  Colunas, Modificacoes: TZReadOnlyQuery;
  Trigger, Log, Campos: String;
  QtdTriggers, QtdTabelasCriadas, QtdTabelasModificadas: Cardinal;
begin
  Triggers     := TStringList.Create;
  TabelasDeLog := TStringList.Create;
  Colunas      := nil;

  with TZReadOnlyQuery.Create(Self) do
    try
      Form_Principal.BitBtn_Gerar.Enabled := False;
      Form_Principal.BitBtn_SalvarScript.Enabled := False;
      Form_Principal.CheckBox_GerarCreate.Enabled := False;
      Form_Principal.CheckBox_GerarTriggers.Enabled := False;
      Form_Principal.CheckBox_GerarAlter.Enabled := False;
      Form_Principal.Gauge_Script.Progress := 0;

      QtdTriggers := 0;
      QtdTabelasCriadas := 0;
      QtdTabelasModificadas := 0;

      { Abaixo, não usei recordcount para evitar alguns problemas detectados em
      implementações anteriores }
      Connection := TRF5PRD;
      ParamCheck := False;

      SQL.Text := StringReplace(TABELAS_SELECT,'<:OWNER:>',Configuracoes.CONFIGURACOESOBJOWNER,[rfReplaceAll]);
      SQL.Text := StringReplace(SQL.Text,'<:SELECT:>','SELECT COUNT(*)',[rfReplaceAll]);
      Open;

      Form_Principal.Gauge_Script.MaxValue := Fields[0].AsInteger;

      Close;
      SQL.Text := StringReplace(TABELAS_SELECT,'<:OWNER:>',Configuracoes.CONFIGURACOESOBJOWNER,[rfReplaceAll]);
      SQL.Text := StringReplace(SQL.Text,'<:SELECT:>',TABELAS_SELECTCLAUSE,[rfReplaceAll]);
      SQL.Text := StringReplace(SQL.Text,'<:OWNER:>',Configuracoes.CONFIGURACOESOBJOWNER,[rfReplaceAll]);
      Open;


      Colunas := TZReadOnlyQuery.Create(Self);
      Colunas.Connection := TRF5PRD;

      Form_Principal.Memo_Script.Clear;
      

      while not Eof do
      begin
        { Colunas da tabela }
        Colunas.SQL.Text := StringReplace(COLUNAS_SELECT,'<:OWNER:>',Configuracoes.CONFIGURACOESOBJOWNER,[rfReplaceAll]);
        Colunas.SQL.Text := StringReplace(Colunas.SQL.Text,'<:TABELA:>',Fields[0].AsString,[rfReplaceAll]);
        Colunas.Open;

        { == Gerando tabela de LOG =========================================== }
        if Form_Principal.CheckBox_GerarCreate.Checked or Form_Principal.CheckBox_GerarAlter.Checked then
          Form_Principal.Memo_Script.Lines.Add('/* TABELA DE LOG PARA A TABELA "' + Fields[0].AsString + '" */');

        { Se não tem tabela de log, cria! }
        if Form_Principal.CheckBox_GerarCreate.Checked and Fields[2].isNull then
        begin
          Log := StringReplace(LOG_TEMPLATE,'<:TABELA:>',Fields[0].AsString,[rfReplaceAll]);

          Campos := '';
          while not Colunas.Eof do
          begin
            if Colunas.Fields[1].AsString = 'NUMBER' then
            begin
              Campos := Campos + StringReplace(CAMPOLOG_TEMPLATE,'<:CAMPO:>',Colunas.Fields[0].AsString,[]);

              if Colunas.Fields[4].AsInteger > 0 then
                Campos := StringReplace(Campos,'<:TIPO:>',Colunas.Fields[1].AsString + '(' + Colunas.Fields[3].AsString + ',' + Colunas.Fields[4].AsString + ')',[])
              else
                Campos := StringReplace(Campos,'<:TIPO:>',Colunas.Fields[1].AsString + '(' + Colunas.Fields[3].AsString + ')',[]);
            end
            else if (Colunas.Fields[1].AsString = 'CHAR')
                 or (Colunas.Fields[1].AsString = 'VARCHAR2') then
            begin
              Campos := Campos + StringReplace(CAMPOLOG_TEMPLATE,'<:CAMPO:>',Colunas.Fields[0].AsString,[]);
              Campos := StringReplace(Campos,'<:TIPO:>',Colunas.Fields[1].AsString + '(' + Colunas.Fields[2].AsString + ')',[]);
            end
            else
            begin
              Campos := Campos + StringReplace(CAMPOLOG_TEMPLATE,'<:CAMPO:>',Colunas.Fields[0].AsString,[]);
              Campos := StringReplace(Campos,'<:TIPO:>',Colunas.Fields[1].AsString,[]);
            end;
            Colunas.Next;
          end;

          Log := StringReplace(Log,'<:CAMPOS:>',TrimRight(Campos),[]);
          Inc(QtdTabelasCriadas);
        end
        { Se tem tabela de log, então verifica a necessidade de alteração dela }
        else if Form_Principal.CheckBox_GerarAlter.Checked then
        begin
          Modificacoes := TZReadOnlyQuery.Create(Self);
          try
            Modificacoes.Connection := TRF5PRD;
            Modificacoes.ParamCheck := False;
            Modificacoes.SQL.Text := StringReplace(LOG_VERIFICACAO,'<:OWNER:>',Configuracoes.CONFIGURACOESOBJOWNER,[rfReplaceAll]);
            Modificacoes.SQL.Text := StringReplace(Modificacoes.SQL.Text,'<:TABELA:>',Fields[0].AsString,[rfReplaceAll]);
            Modificacoes.Open;

            Log := '';
            if Modificacoes.Eof then
              Log := '-- A TABELA DE LOG ESTÁ TOTALMENTE CONSISTENTE COM A TABELA ORIGINAL!'
            else
              while not Modificacoes.Eof do
              begin
                Log := Log + StringReplace(LOGALTER_TEMPLATE,'<:TABELA:>',Fields[0].AsString,[rfReplaceAll]);
                Log := StringReplace(Log,'<:ACAO:>',Modificacoes.Fields[5].AsString,[rfReplaceAll]);
                Log := StringReplace(Log,'<:CAMPO:>',Modificacoes.Fields[0].AsString,[rfReplaceAll]);

                if Modificacoes.Fields[1].AsString = 'NUMBER' then
                begin
                  if Modificacoes.Fields[4].AsInteger > 0 then
                    Log := StringReplace(Log,'<:TIPO:>',Modificacoes.Fields[1].AsString + '(' + Modificacoes.Fields[3].AsString + ',' + Modificacoes.Fields[4].AsString + ')',[])
                  else
                    Log := StringReplace(Log,'<:TIPO:>',Modificacoes.Fields[1].AsString + '(' + Modificacoes.Fields[3].AsString + ')',[]);
                end
                else if (Modificacoes.Fields[1].AsString = 'CHAR')
                     or (Modificacoes.Fields[1].AsString = 'VARCHAR2') then
                begin
                  Log := StringReplace(Log,'<:TIPO:>',Modificacoes.Fields[1].AsString + '(' + Modificacoes.Fields[2].AsString + ')',[]);
                end
                else
                begin
                  Log := StringReplace(Log,'<:TIPO:>',Modificacoes.Fields[1].AsString,[]);
                end;

                Modificacoes.Next;
              end;
          finally
            Modificacoes.Free;
          end;

          Log := Trim(Log);
          Inc(QtdTabelasModificadas);
        end;

        if Form_Principal.CheckBox_GerarCreate.Checked or Form_Principal.CheckBox_GerarAlter.Checked then
        begin
          Form_Principal.Memo_Script.Lines.Add(Log);
          Form_Principal.Memo_Script.Lines.Add('---------------------------------------------------------------------------------------------------------------------------------');
        end;        
        { ==================================================================== }

        { Voltando ao iníco da lista de colunas }
        Colunas.First;

        { == Gerando trigger ================================================= }
        if Form_Principal.CheckBox_GerarTriggers.Checked then
        begin
          Form_Principal.Memo_Script.Lines.Add('/* TRIGGER DE LOG PARA A TABELA "' + Fields[0].AsString + '" */');

          Trigger := StringReplace(TRIGGER_TEMPLATE,'<:TABELA:>',Fields[0].AsString,[rfReplaceAll]);

          Campos := '';
          while not Colunas.Eof do
          begin
            Campos := Campos + StringReplace(CAMPOTRIGGER_TEMPLATE,'<:CAMPO:>',Colunas.Fields[0].AsString,[rfReplaceAll]) + #13#10;
            Colunas.Next;
          end;

          Trigger := StringReplace(Trigger,'<:CAMPOS:>',TrimRight(Campos),[]);

          Inc(QtdTriggers);
          Form_Principal.Memo_Script.Lines.Add(Trigger);
          Form_Principal.Memo_Script.Lines.Add('---------------------------------------------------------------------------------------------------------------------------------');
        end;
        { ==================================================================== }

        Next;
        Application.ProcessMessages;
        Form_Principal.Gauge_Script.AddProgress(1);
      end;
      Form_Principal.Memo_Script.Lines.Add('-- Triggers Criados: ' + IntToStr(QtdTriggers) + ', Tabelas criadas: ' + IntToStr(QtdTabelasCriadas) + ', ' + 'Tabelas modificadas: ' + IntToStr(QtdTabelasModificadas));

      Close;
    finally
      Colunas.Free;
      TabelasDeLog.Free;
      Triggers.Free;
      Free;
      Form_Principal.BitBtn_Gerar.Enabled := True;
      Form_Principal.BitBtn_SalvarScript.Enabled := True;
      Form_Principal.CheckBox_GerarCreate.Enabled := True;
      Form_Principal.CheckBox_GerarTriggers.Enabled := True;
      Form_Principal.CheckBox_GerarAlter.Enabled := True;
    end;
end;

procedure TDataModule_Principal.COLUNASANULAVELORIGetText(Sender: TField;
  var Text: String; DisplayText: Boolean);
begin
  if Sender.AsString = 'S' then
    Text := 'SIM'
  else
    Text := 'NÃO';
end;

initialization
  Configuracoes.LoadFromFile(ChangeFileExt(Application.ExeName,'.ini'));

finalization
  Configuracoes.SaveToFile(ChangeFileExt(Application.ExeName,'.ini'));
end.
