unit Unit1;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ZConnection, StdCtrls, ZAbstractDataset, ZDataset, DB,
  ZAbstractRODataset, ZSqlUpdate, ComCtrls;

type
  TForm1 = class(TForm)
    TRF5DSV: TZConnection;
    TRF5PRD: TZConnection;
    Button1: TButton;
    SOURCE: TZReadOnlyQuery;
    DESTINATION: TZQuery;
    TRF5DSVUPDATE: TZUpdateSQL;
    ProgressBar1: TProgressBar;
    Label1: TLabel;
    CheckBox1: TCheckBox;
    Label2: TLabel;
    procedure Button1Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form1: TForm1;

implementation

{$R *.dfm}

procedure TForm1.Button1Click(Sender: TObject);
const
  SQL_DESCRIBE =
  '     SELECT COL.COLUMN_NAME'#13#10 +
  '      FROM SYS.ALL_TAB_COLUMNS COL'#13#10 +
  'RIGHT JOIN SYS.ALL_COL_COMMENTS COM ON COM.OWNER = ''ESPARTA2'' AND COM.TABLE_NAME = :TABLE_NAME AND COM.COLUMN_NAME = COL.COLUMN_NAME'#13#10 +
  '     WHERE COL.OWNER = ''ESPARTA2'''#13#10 +
  '       AND COL.TABLE_NAME = :TABLE_NAME'#13#10 +
  '  ORDER BY COL.COLUMN_ID';

  SQL_INSERT = 'INSERT INTO <%TABLE%> (<%COLUMNS%>) VALUES (<%VALUES%>)';
  SQL_SELECT = 'SELECT * FROM ESPARTA2.<%TABLE%>';
var
  Columns: TStringList;
  NomeTabela, Colunas, Valores, Select: String;
  i: Integer;
{ ============================================================================ }
function RecordCount(aSelect: String): Integer;
begin
  with TZReadOnlyQuery.Create(nil) do
    try
      Connection := TRF5PRD;
      SQL.Text := StringReplace(aSelect,'RP.*','COUNT(*)',[]);
      Open;
      Result := Fields[0].AsInteger;
    finally
      Close;
      Free;
    end;
end;
{ ============================================================================ }
begin
  Columns := TStringList.Create;
  Button1.Enabled := False;

  try
    TRF5DSV.StartTransaction;

    { importando REPOSITORIOPREC ============================================= }
    NomeTabela := 'REPOSITORIOPREC';
    Select :=
    'SELECT RP.*'#13#10 +
    '  FROM ESPARTA2.REPOSITORIOPREC RP'#13#10 +
    '  JOIN ESPARTA2.VALIDAPSS VP ON VP.NUMREQ = RP.NUMREQ';
//    ' WHERE RP.NUMREQ = ''20108103019505233''';

    Columns.Clear;
    Colunas := '';
    Valores := '';
    Label2.Caption := 'Tabela: ' + NomeTabela;

    { Obtém informações sobre a tabela de origem e coloca-as no stringlist
    de colunas }
    try
      SOURCE.SQL.Text := SQL_DESCRIBE;
      SOURCE.ParamByName('TABLE_NAME').AsString := NomeTabela;
      SOURCE.Open;

      SOURCE.First;
      while not SOURCE.Eof do
      begin
        Columns.Add(SOURCE.FieldByName('COLUMN_NAME').AsString);
        SOURCE.Next;
      end;
    finally
      SOURCE.Close;
    end;

    Colunas := Trim(Columns.Text);
    Colunas := StringReplace(Colunas,#13#10,', ',[rfReplaceAll]);

    Valores := StringReplace(':' + Colunas,', ',', :',[rfReplaceAll]);

    DESTINATION.UpdateObject.InsertSQL.Text := StringReplace(SQL_INSERT
                                                            ,'<%TABLE%>'
                                                            ,NomeTabela
                                                            ,[]);

    DESTINATION.UpdateObject.InsertSQL.Text := StringReplace(DESTINATION.UpdateObject.InsertSQL.Text
                                                            ,'<%COLUMNS%>'
                                                            ,Colunas
                                                            ,[]);

    DESTINATION.UpdateObject.InsertSQL.Text := StringReplace(DESTINATION.UpdateObject.InsertSQL.Text
                                                            ,'<%VALUES%>'
                                                            ,Valores
                                                            ,[]);


    try
      SOURCE.SQL.Text := Select;
      SOURCE.Open;

      DESTINATION.SQL.Text := StringReplace(SQL_SELECT,'<%TABLE%>',NomeTabela,[rfReplaceAll]);
      DESTINATION.Open;

      ProgressBar1.Position := 0;
      ProgressBar1.Step := 1;
      ProgressBar1.Max := RecordCount(SOURCE.SQL.Text);

      Label1.Caption := 'Registros inseridos: 0 / ' + IntToStr(ProgressBar1.Max);
      Application.ProcessMessages;

      SOURCE.First;
      while not SOURCE.Eof do
      begin
        DESTINATION.Insert;

        for i := 0 to Pred(Columns.Count) do
        begin
          { Maiely, veja aqui! }
          if UpperCase(Columns[i]) = 'INDAUTUADO' then
            DESTINATION.FieldByName(Columns[i]).Value := 'N'
          else
            DESTINATION.FieldByName(Columns[i]).Value := SOURCE.FieldByName(Columns[i]).Value;
        end;

        DESTINATION.Post;

        SOURCE.Next;
        ProgressBar1.StepIt;
        Label1.Caption := 'Registros inseridos: ' + IntToStr(ProgressBar1.Position) + ' / ' + IntToStr(ProgressBar1.Max);
        Application.ProcessMessages;
      end;
    finally
      DESTINATION.Close;
      SOURCE.Close;
    end;
    { ======================================================================== }

    { importando REPOSITORIOPARTE ============================================ }
    NomeTabela := 'REPOSITORIOPARTE';
    Select :=
    'SELECT RP.*'#13#10 +
    '  FROM ESPARTA2.REPOSITORIOPARTE RP'#13#10 +
    '  JOIN ESPARTA2.VALIDAPSS VP ON VP.NUMREQ = RP.NUMREQ';
//    ' WHERE RP.NUMREQ = ''20108103019505233''';

    Columns.Clear;
    Colunas := '';
    Valores := '';
    Label2.Caption := 'Tabela: ' + NomeTabela;

    { Obtém informações sobre a tabela de origem e coloca-as no stringlist
    de colunas }
    try
      SOURCE.SQL.Text := SQL_DESCRIBE;
      SOURCE.ParamByName('TABLE_NAME').AsString := NomeTabela;
      SOURCE.Open;

      SOURCE.First;
      while not SOURCE.Eof do
      begin
        Columns.Add(SOURCE.FieldByName('COLUMN_NAME').AsString);
        SOURCE.Next;
      end;
    finally
      SOURCE.Close;
    end;

    Colunas := Trim(Columns.Text);
    Colunas := StringReplace(Colunas,#13#10,', ',[rfReplaceAll]);

    Valores := StringReplace(':' + Colunas,', ',', :',[rfReplaceAll]);

    DESTINATION.UpdateObject.InsertSQL.Text := StringReplace(SQL_INSERT
                                                            ,'<%TABLE%>'
                                                            ,NomeTabela
                                                            ,[]);

    DESTINATION.UpdateObject.InsertSQL.Text := StringReplace(DESTINATION.UpdateObject.InsertSQL.Text
                                                            ,'<%COLUMNS%>'
                                                            ,Colunas
                                                            ,[]);

    DESTINATION.UpdateObject.InsertSQL.Text := StringReplace(DESTINATION.UpdateObject.InsertSQL.Text
                                                            ,'<%VALUES%>'
                                                            ,Valores
                                                            ,[]);


    try
      SOURCE.SQL.Text := Select;
      SOURCE.Open;

      DESTINATION.SQL.Text := StringReplace(SQL_SELECT,'<%TABLE%>',NomeTabela,[rfReplaceAll]);
      DESTINATION.Open;

      ProgressBar1.Position := 0;
      ProgressBar1.Step := 1;
      ProgressBar1.Max := RecordCount(SOURCE.SQL.Text);

      Label1.Caption := 'Registros inseridos: 0 / ' + IntToStr(ProgressBar1.Max);
      Application.ProcessMessages;

      SOURCE.First;
      while not SOURCE.Eof do
      begin
        DESTINATION.Insert;

        for i := 0 to Pred(Columns.Count) do
          DESTINATION.FieldByName(Columns[i]).Value := SOURCE.FieldByName(Columns[i]).Value;

        DESTINATION.Post;

        SOURCE.Next;
        ProgressBar1.StepIt;
        Label1.Caption := 'Registros inseridos: ' + IntToStr(ProgressBar1.Position) + ' / ' + IntToStr(ProgressBar1.Max);
        Application.ProcessMessages;
      end;

    finally
      DESTINATION.Close;
      SOURCE.Close;
    end;
    { ======================================================================== }

    { importando REPOSITORIOPARTEREPR ======================================== }
    NomeTabela := 'REPOSITORIOPARTEREPR';
    Select :=
    'SELECT RP.*'#13#10 +
    '  FROM ESPARTA2.REPOSITORIOPARTEREPR RP'#13#10 +
    '  JOIN ESPARTA2.VALIDAPSS VP ON VP.NUMREQ = RP.NUMREQ';
//    ' WHERE RP.NUMREQ = ''20108103019505233''';

    Columns.Clear;
    Colunas := '';
    Valores := '';
    Label2.Caption := 'Tabela: ' + NomeTabela;

    { Obtém informações sobre a tabela de origem e coloca-as no stringlist
    de colunas }
    try
      SOURCE.SQL.Text := SQL_DESCRIBE;
      SOURCE.ParamByName('TABLE_NAME').AsString := NomeTabela;
      SOURCE.Open;

      SOURCE.First;
      while not SOURCE.Eof do
      begin
        Columns.Add(SOURCE.FieldByName('COLUMN_NAME').AsString);
        SOURCE.Next;
      end;
    finally
      SOURCE.Close;
    end;

    Colunas := Trim(Columns.Text);
    Colunas := StringReplace(Colunas,#13#10,', ',[rfReplaceAll]);

    Valores := StringReplace(':' + Colunas,', ',', :',[rfReplaceAll]);

    DESTINATION.UpdateObject.InsertSQL.Text := StringReplace(SQL_INSERT
                                                            ,'<%TABLE%>'
                                                            ,NomeTabela
                                                            ,[]);

    DESTINATION.UpdateObject.InsertSQL.Text := StringReplace(DESTINATION.UpdateObject.InsertSQL.Text
                                                            ,'<%COLUMNS%>'
                                                            ,Colunas
                                                            ,[]);

    DESTINATION.UpdateObject.InsertSQL.Text := StringReplace(DESTINATION.UpdateObject.InsertSQL.Text
                                                            ,'<%VALUES%>'
                                                            ,Valores
                                                            ,[]);


    try
      SOURCE.SQL.Text := Select;
      SOURCE.Open;

      DESTINATION.SQL.Text := StringReplace(SQL_SELECT,'<%TABLE%>',NomeTabela,[rfReplaceAll]);
      DESTINATION.Open;

      ProgressBar1.Position := 0;
      ProgressBar1.Step := 1;
      ProgressBar1.Max := RecordCount(SOURCE.SQL.Text);

      Label1.Caption := 'Registros inseridos: 0 / ' + IntToStr(ProgressBar1.Max);
      Application.ProcessMessages;

      SOURCE.First;
      while not SOURCE.Eof do
      begin
        DESTINATION.Insert;

        for i := 0 to Pred(Columns.Count) do
          DESTINATION.FieldByName(Columns[i]).Value := SOURCE.FieldByName(Columns[i]).Value;

        DESTINATION.Post;

        SOURCE.Next;
        ProgressBar1.StepIt;
        Label1.Caption := 'Registros inseridos: ' + IntToStr(ProgressBar1.Position) + ' / ' + IntToStr(ProgressBar1.Max);
        Application.ProcessMessages;
      end;

    finally
      DESTINATION.Close;
      SOURCE.Close;
    end;
    { ======================================================================== }
  finally
    Button1.Enabled := True;
    Columns.Free;
    if CheckBox1.Checked then
      TRF5DSV.Rollback
    else
      TRF5DSV.Commit;

    Application.ProcessMessages;
  end;
end;

end.

-- 1. DESVINCULA O NUMREQ DOS PROCESSOS
UPDATE PRECATORIO
   SET NUMREQ = ''
 WHERE CODDOC IN (SELECT CODDOCESPARTA 
                    FROM REPOSITORIOSAIDA
                   WHERE NUMREQ IN (SELECT RP.NUMREQ
                                      FROM ESPARTA2.REPOSITORIOPREC RP
                                      JOIN ESPARTA2.VALIDAPSS VP ON VP.NUMREQ = RP.NUMREQ));

-- 2. EXCLUI DE REPOSITORIOSAIDA
DELETE FROM REPOSITORIOSAIDA WHERE NUMREQ IN (SELECT RP.NUMREQ
                                                FROM ESPARTA2.REPOSITORIOPREC RP
                                                JOIN ESPARTA2.VALIDAPSS VP ON VP.NUMREQ = RP.NUMREQ);
                                                
-- 3. EXCLUI DE REPOSITORIOERRO
DELETE FROM REPOSITORIOERRO WHERE NUMREQ IN (SELECT RP.NUMREQ
                                                FROM ESPARTA2.REPOSITORIOPREC RP
                                                JOIN ESPARTA2.VALIDAPSS VP ON VP.NUMREQ = RP.NUMREQ);

-- 4. ATUALIZANDO INDAUTUADO EM REPOSITORIOPREC
UPDATE REPOSITORIOPREC
   SET INDAUTUADO = 'N'
 WHERE NUMREQ IN (SELECT RP.NUMREQ
                    FROM ESPARTA2.REPOSITORIOPREC RP
                    JOIN ESPARTA2.VALIDAPSS VP ON VP.NUMREQ = RP.NUMREQ);


-- 5. SE QUISER EXCLUIR TUDO PARA REGERAR CENÁRIO, USE
DELETE REPOSITORIOPARTEREPR 
 WHERE NUMREQ IN (SELECT RP.NUMREQ
                    FROM ESPARTA2.REPOSITORIOPREC RP
                    JOIN ESPARTA2.VALIDAPSS VP ON VP.NUMREQ = RP.NUMREQ);

DELETE REPOSITORIOPARTE 
 WHERE NUMREQ IN (SELECT RP.NUMREQ
                    FROM ESPARTA2.REPOSITORIOPREC RP
                    JOIN ESPARTA2.VALIDAPSS VP ON VP.NUMREQ = RP.NUMREQ);
 
DELETE REPOSITORIOPREC
 WHERE NUMREQ IN (SELECT RP.NUMREQ
                    FROM ESPARTA2.REPOSITORIOPREC RP
                    JOIN ESPARTA2.VALIDAPSS VP ON VP.NUMREQ = RP.NUMREQ);

