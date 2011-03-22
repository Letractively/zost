unit UDataModule_Principal;

interface

uses
  SysUtils, Classes, ZConnection, ZAbstractDataset, ZDataset, DB,
  ZAbstractRODataset, ActnList, ZSqlUpdate, ExtCtrls, Dialogs,
  CFDBValidationChecks;

type
  TDataModule_Principal = class(TDataModule)
    ZConnection_Principal: TZConnection;
    CODIGOSDACCU: TZReadOnlyQuery;
    CCU: TZQuery;
    DataSource_CCU: TDataSource;
    DataSource_CODIGOSDACCU: TDataSource;
    CCUBI_CCU_ID: TLargeintField;
    CCUTI_CODIGOSDACCU_ID: TSmallintField;
    CCUDT_DATAHORAINICIAL: TDateTimeField;
    CCUDT_DATAHORAFINAL: TDateTimeField;
    CCUTX_DESCRICAO: TMemoField;
    CCUVA_CODIGO: TStringField;
    ActionList_Principal: TActionList;
    Action_IniciarSequencial: TAction;
    Action_FinalizarSequencial: TAction;
    ZUpdateSQL_CCU: TZUpdateSQL;
    CCUVA_DESCRICAO: TStringField;
    Timer_Principal: TTimer;
    CCUTOTAL: TStringField;
    Action_SalvarItemSequencial: TAction;
    CODIGOSDACCUTI_CODIGOSDACCU_ID: TSmallintField;
    CODIGOSDACCUVA_CODIGO: TStringField;
    CODIGOSDACCUVA_DESCRICAO: TStringField;
    Action_CancelarSequencial: TAction;
    Action_ExportarCCU: TAction;
    Action_ConfigurarDataSet: TAction;
    Action_SalvarCCU: TAction;
    SaveDialog_CCU: TSaveDialog;
    CFDBValidationChecks_CCU: TCFDBValidationChecks;
    CCUTOTAL_SEGUNDOS: TLargeintField;
    Action_IniciarLivre: TAction;
    Action_CancelarLivre: TAction;
    procedure ZConnection_PrincipalAfterConnect(Sender: TObject);
    procedure Action_IniciarSequencialExecute(Sender: TObject);
    procedure Action_FinalizarSequencialExecute(Sender: TObject);
    procedure CCUBeforeInsert(DataSet: TDataSet);
    procedure CCUBeforeEdit(DataSet: TDataSet);
    procedure Timer_PrincipalTimer(Sender: TObject);
    procedure Action_SalvarItemSequencialExecute(Sender: TObject);
    procedure CCUNewRecord(DataSet: TDataSet);
    procedure CCUBeforePost(DataSet: TDataSet);
    procedure Action_CancelarSequencialExecute(Sender: TObject);
    procedure Action_ConfigurarDataSetExecute(Sender: TObject);
    procedure Action_ExportarCCUExecute(Sender: TObject);
    procedure Action_SalvarCCUExecute(Sender: TObject);
    procedure DataModuleCreate(Sender: TObject);
    procedure DataSource_CCUStateChange(Sender: TObject);
    procedure CCUAfterDelete(DataSet: TDataSet);
    procedure CODIGOSDACCUAfterOpen(DataSet: TDataSet);
    procedure Action_IniciarLivreExecute(Sender: TObject);
    procedure Action_CancelarLivreExecute(Sender: TObject);
  private
    { Private declarations }
    FInicioDaTarefa: TDateTime;
    procedure DesinicializarControles;
    procedure InicializarControles(aModoSequencial: Boolean);
    procedure CriarSumario;
  public
    { Public declarations }
    procedure Filtrar;
  end;

var
  DataModule_Principal: TDataModule_Principal;

implementation

uses UForm_Principal
   , DateUtils
   , UForm_CCU;

const
  TOTALDEHORASDIARIAS = 8;

{$R *.dfm}

procedure TDataModule_Principal.Action_CancelarLivreExecute(Sender: TObject);
begin
  CCU.Cancel;

  DesinicializarControles;
end;

procedure TDataModule_Principal.Action_CancelarSequencialExecute(Sender: TObject);
begin
  CCU.Cancel;

  DesinicializarControles;
end;

procedure TDataModule_Principal.Action_ConfigurarDataSetExecute(Sender: TObject);
var
  Date: TDateTime;
begin
  try
    CCU.Close;
    CCU.SQL.Text :=
    'SELECT CCU.*'#13#10 +
    '     , CDC.VA_CODIGO'#13#10 +
    '     , CDC.VA_DESCRICAO'#13#10 +
    '     , TIME_FORMAT(TIMEDIFF(CCU.DT_DATAHORAFINAL,CCU.DT_DATAHORAINICIAL),''%H:%i:%s'') AS TOTAL'#13#10 +
    '     , TIME_TO_SEC(TIME_FORMAT(TIMEDIFF(CCU.DT_DATAHORAFINAL,CCU.DT_DATAHORAINICIAL),''%H:%i:%s'')) AS TOTAL_SEGUNDOS'#13#10 +
    '  FROM WINSTON.CCU CCU'#13#10 +
    '  JOIN WINSTON.CODIGOSDACCU CDC USING (TI_CODIGOSDACCU_ID)';

    if Form_Principal.RadioButton_Completo.Checked then
    begin
      // FAZ NADA
    end
    else if Form_Principal.RadioButton_DoDia.Checked then
    begin
      CCU.SQL.Text := CCU.SQL.Text +
      ' WHERE CCU.DT_DATAHORAINICIAL BETWEEN DATE_FORMAT(NOW(),''%Y%m%d000000'') AND DATE_FORMAT(NOW(),''%Y%m%d235959'')';
    end
    else if Form_Principal.RadioButton_MesEspecifico.Checked then
    begin
      Date := Form_Principal.DateTimePicker_DataEspecifica.Date;
      CCU.SQL.Text := CCU.SQL.Text +
      ' WHERE CCU.DT_DATAHORAINICIAL BETWEEN ' + FormatDateTime('yyyymm01000000',Date) + ' AND ' + FormatDateTime('yyyymmdd235959',EndOfAMonth(YearOf(Date),MonthOf(Date)));
    end
    else if Form_Principal.RadioButton_MesAtual.Checked then
    begin
      Date := Now;
      CCU.SQL.Text := CCU.SQL.Text +
      ' WHERE CCU.DT_DATAHORAINICIAL BETWEEN ' + FormatDateTime('yyyymm01000000',Date) + ' AND ' + FormatDateTime('yyyymmdd235959',EndOfAMonth(YearOf(Date),MonthOf(Date)));
    end;

    CCU.SQL.Text := CCU.SQL.Text +
    ' ORDER BY CCU.BI_CCU_ID';
  finally
    CCU.Open;
  end;
end;

procedure TDataModule_Principal.Action_ExportarCCUExecute(Sender: TObject);
var
  Bms: TBookMarkStr;
  CCUTXT: TStringList;
  Data, Anterior: TDateTime;
begin
  CCUTXT := nil;
  try
    Bms := CCU.Bookmark;
    Data := 0;

    CCUTXT := TStringList.Create;
    CCU.DisableControls;

    CCU.First;
    Anterior := CCUDT_DATAHORAINICIAL.AsDateTime;
    while not CCU.Eof do
    begin

      { Um novo dia! }
      if DayOfTheYear(Data) <> DayOfTheYear(CCUDT_DATAHORAINICIAL.AsDateTime) then
      begin
        if Data <> 0 then
          CCUTXT.Add('');

        CCUTXT.Add(FormatDateTime('* dd/mm',CCUDT_DATAHORAINICIAL.AsDateTime));
        Data := CCUDT_DATAHORAINICIAL.AsDateTime;
      end;

      if True then
      begin
        if MinutesBetween(CCUDT_DATAHORAINICIAL.AsDateTime,Anterior) > 0 then
          CCUTXT.Add(FormatDateTime('hhnn',Anterior) + '-' + FormatDateTime('hhnn',CCUDT_DATAHORAINICIAL.AsDateTime) + ' TRE0000050 NADISMO');

        Anterior := CCUDT_DATAHORAFINAL.AsDateTime;
      end;


      CCUTXT.Add(FormatDateTime('hhnn',CCUDT_DATAHORAINICIAL.AsDateTime) + '-' + FormatDateTime('hhnn',CCUDT_DATAHORAFINAL.AsDateTime) + ' ' + CCUVA_CODIGO.AsString + ' ' + StringReplace(Trim(CCUTX_DESCRICAO.AsString),#13#10,' ',[rfReplaceAll]));
      CCU.Next;
    end;
  finally
    CCU.Bookmark := Bms;
    CCU.EnableControls;

    Form_CCU := TForm_CCU.Create(Self);
    with Form_CCU do
    begin
        Memo_CCU.Text := CCUTXT.Text;
        ShowModal; { ele se autodestroi }
    end;

    CCUTXT.Free;
  end;
end;

procedure TDataModule_Principal.Action_IniciarLivreExecute(Sender: TObject);
begin
  Form_Principal.LabeledEdit_CCU_TX_DESCRICAO.Text := '*';
  Form_Principal.ComboBox_CDC_VA_CODIGO.ItemIndex := 0;
  Form_Principal.ComboBox_CDC_VA_CODIGOChange(nil);
  CCU.Filtered := False;

  InicializarControles(False);
end;

procedure TDataModule_Principal.Action_IniciarSequencialExecute(Sender: TObject);
begin
  Form_Principal.RadioButton_DoDia.Checked := True;
  Form_Principal.LabeledEdit_CCU_TX_DESCRICAO.Text := '*';
  Form_Principal.ComboBox_CDC_VA_CODIGO.ItemIndex := 0;
  Form_Principal.ComboBox_CDC_VA_CODIGOChange(nil);
  CCU.Filtered := False;

  CCU.Append;

  InicializarControles(True);
end;

procedure TDataModule_Principal.Action_FinalizarSequencialExecute(Sender: TObject);
begin
  CCU.Post;

  CCU.Filtered := True;

  DesinicializarControles;
end;

procedure TDataModule_Principal.Action_SalvarCCUExecute(Sender: TObject);
begin
  if SaveDialog_CCU.Execute then
    Form_CCU.Memo_CCU.Lines.SaveToFile(SaveDialog_CCU.FileName);
end;

procedure TDataModule_Principal.Action_SalvarItemSequencialExecute(Sender: TObject);
begin
  CCU.Post;
  
  CCU.Append;

  InicializarControles(True);
end;

procedure TDataModule_Principal.CCUAfterDelete(DataSet: TDataSet);
begin
  CriarSumario;
end;

procedure TDataModule_Principal.CCUBeforeEdit(DataSet: TDataSet);
begin
  ZUpdateSQL_CCU.RefreshSQL.Text := '';
end;

procedure TDataModule_Principal.CCUBeforeInsert(DataSet: TDataSet);
begin
  ZUpdateSQL_CCU.RefreshSQL.Text :=
  'SELECT CCU.BI_CCU_ID'#13#10 +
  '     , CDC.VA_CODIGO'#13#10 +
  '     , CDC.VA_DESCRICAO'#13#10 +
  '     , TIME_FORMAT(TIMEDIFF(CCU.DT_DATAHORAFINAL,CCU.DT_DATAHORAINICIAL),''%H:%i:%s'') AS TOTAL'#13#10 +
  '     , TIME_TO_SEC(TIME_FORMAT(TIMEDIFF(CCU.DT_DATAHORAFINAL,CCU.DT_DATAHORAINICIAL),''%H:%i:%s'')) AS TOTAL_SEGUNDOS'#13#10 +
  '  FROM WINSTON.CCU CCU'#13#10 +
  '  JOIN WINSTON.CODIGOSDACCU CDC USING (TI_CODIGOSDACCU_ID)'#13#10 +
  ' WHERE CCU.BI_CCU_ID = LAST_INSERT_ID()';
end;

procedure TDataModule_Principal.CCUBeforePost(DataSet: TDataSet);
begin
  if DataSet.State = dsInsert then
  begin
    CCUDT_DATAHORAFINAL.AsDateTime := Now;
    CCUTI_CODIGOSDACCU_ID.Tag := CCUTI_CODIGOSDACCU_ID.AsInteger;
  end;

  CFDBValidationChecks_CCU.ValidateBeforePost;

end;

procedure TDataModule_Principal.CCUNewRecord(DataSet: TDataSet);
begin
  CCUDT_DATAHORAINICIAL.AsDateTime := Now;
  CCUTI_CODIGOSDACCU_ID.AsInteger := CCUTI_CODIGOSDACCU_ID.Tag;
end;

procedure TDataModule_Principal.CODIGOSDACCUAfterOpen(DataSet: TDataSet);
begin
  { Preenchendo o combo com os códigos da CCU }
  Form_Principal.ComboBox_CDC_VA_CODIGO.Clear;

  CODIGOSDACCU.First;
  Form_Principal.ComboBox_CDC_VA_CODIGO.AddItem('QUALQUER  |Para usar filtrar por código da CCU, selecione um dos códigos na lista. Atualmente este filtro está configurado para exibir registros com qualquer código',TObject(0));
  while not CODIGOSDACCU.Eof do
  begin
    Form_Principal.ComboBox_CDC_VA_CODIGO.AddItem(CODIGOSDACCUVA_CODIGO.AsString + '|' + CODIGOSDACCUVA_DESCRICAO.AsString,TObject(CODIGOSDACCUTI_CODIGOSDACCU_ID.AsInteger));
    CODIGOSDACCU.Next;
  end;
  Form_Principal.ComboBox_CDC_VA_CODIGO.ItemIndex := 0;
  Form_Principal.ComboBox_CDC_VA_CODIGOChange(nil);
end;

procedure TDataModule_Principal.CriarSumario;
const
  TEXTO_SUMARIO = 'Devidas: %sh %sm %ss | Trabalhadas: %sh %sm %ss | Extras: %sh %sm %ss';
var
  Bms: TBookMarkStr;
  SegundosTrabalhados, SegundosDevidos, SegundosExtras: Integer;
{ ---------------------------------------------------------------------------- }
function TotalDeSegundos: Integer;
var
  i, DiaDaSemana: Byte;
  DataBase: TDateTime;
begin
  Result := 0;
  if Form_Principal.RadioButton_DoDia.Checked then
    Result := TOTALDEHORASDIARIAS * 60 * 60
  else if Form_Principal.RadioButton_MesAtual.Checked then
  begin
    DataBase := Now;

    for i := DayOf(StartOfAMonth(YearOf(DataBase),MonthOf(DataBase))) to DayOf(EndOfAMonth(YearOf(DataBase),MonthOf(DataBase))) do
    begin
      DiaDaSemana := DayOfWeek(EncodeDate(YearOf(DataBase),MonthOf(DataBase),i));

      { Se for dia útil... }
      if (DiaDaSemana > 1) and (DiaDaSemana < 7) then
        Inc(Result);
    end;

    { Aqui Result tem o total de dias uteis. Devemos multiplica-lo pelo total de
    segundos por dia }
    Result := Result * TOTALDEHORASDIARIAS * 60 * 60;
  end
  else if Form_Principal.RadioButton_MesEspecifico.Checked then
  begin
    DataBase := Form_Principal.DateTimePicker_DataEspecifica.Date;

    for i := DayOf(StartOfAMonth(YearOf(DataBase),MonthOf(DataBase))) to DayOf(EndOfAMonth(YearOf(DataBase),MonthOf(DataBase))) do
    begin
      DiaDaSemana := DayOfWeek(EncodeDate(YearOf(DataBase),MonthOf(DataBase),i));

      { Se for dia útil... }
      if (DiaDaSemana > 1) and (DiaDaSemana < 7) then
        Inc(Result);
    end;

    { Aqui Result tem o total de dias uteis. Devemos multiplica-lo pelo total de
    segundos por dia }
    Result := Result * TOTALDEHORASDIARIAS * 60 * 60;
  end;
end;
{ ---------------------------------------------------------------------------- }
begin
  { Condições impeditivas a geração de sumário }
  if Form_Principal.RadioButton_Completo.Checked then
  begin
    Form_Principal.Label_Sumario.Caption := 'Sumário indisponível: Conjunto de dados inválido';
    Exit;
  end;

  if not CCU.Active then
  begin
    Form_Principal.Label_Sumario.Caption := 'Sumário indisponível: CCU indisponível';
    Exit;
  end;

  if not (CCU.State in [dsBrowse]) then
  begin
    Form_Principal.Label_Sumario.Caption := 'Sumário indisponível: Atividade em execução';
    Exit;
  end;

  { Aqui temos um dataset em estado browse que representa o dia atual }
  try
    Bms := CCU.Bookmark;
    CCU.DisableControls;
    SegundosTrabalhados := 0;
    CCU.First;

    { Calculando horas trabalhadas }
    while not CCU.Eof do
    begin
      SegundosTrabalhados := SegundosTrabalhados + CCUTOTAL_SEGUNDOS.AsInteger; // vem em segundos
      CCU.Next;
    end;

    { Calculando segundos devidos }
    SegundosDevidos := TotalDeSegundos - SegundosTrabalhados;

    if SegundosDevidos < 0 then
      SegundosDevidos := 0;

    { Calculando segundos extras}
    SegundosExtras := SegundosTrabalhados - TotalDeSegundos;
    if SegundosExtras < 0 then
      SegundosExtras := 0;

    Form_Principal.Label_Sumario.Caption := Format(TEXTO_SUMARIO,[IntToStr(SegundosDevidos div 60 div 60)
                                                                 ,IntToStr(SegundosDevidos div 60 mod 60)
                                                                 ,IntToStr(SegundosDevidos mod 60 mod 60)

                                                                 ,IntToStr(SegundosTrabalhados div 60 div 60)
                                                                 ,IntToStr(SegundosTrabalhados div 60 mod 60)
                                                                 ,IntToStr(SegundosTrabalhados mod 60 mod 60)

                                                                 ,IntToStr(SegundosExtras div 60 div 60)
                                                                 ,IntToStr(SegundosExtras div 60 mod 60)
                                                                 ,IntToStr(SegundosExtras mod 60 mod 60)]);
  finally
    CCU.Bookmark := Bms;
    CCU.EnableControls;
  end;
end;

procedure TDataModule_Principal.DataModuleCreate(Sender: TObject);
begin
  FInicioDaTarefa := 0;
end;

procedure TDataModule_Principal.DataSource_CCUStateChange(Sender: TObject);
begin
  CriarSumario;
end;

procedure TDataModule_Principal.DesinicializarControles;
begin
  Action_IniciarSequencial.Enabled := True;
  Action_CancelarSequencial.Enabled := False;
  Action_FinalizarSequencial.Enabled := False;

  Action_IniciarLivre.Enabled := True;
  Action_CancelarLivre.Enabled := False;
//  Action_FinalizarLivre.Enabled := False;

  Form_Principal.CFDBGrid_CCU.Enabled := True;
  Form_Principal.DBMemo_TX_DESCRICAO.ReadOnly := True;
  Form_Principal.DBLookupComboBox_TI_CODIGOSDACCU_ID.Enabled := False;
  Form_Principal.GroupBox_DataSet.Enabled := True;
  Form_Principal.LabeledEdit_CCU_TX_DESCRICAO.Enabled := True;
  Form_Principal.ComboBox_CDC_VA_CODIGO.Enabled := True;
  Form_Principal.TabSheet_TimeSheet.TabVisible := True;
  Form_Principal.TabSheet_Livre.TabVisible := True;

  FInicioDaTarefa := 0;
end;

procedure TDataModule_Principal.InicializarControles(aModoSequencial: Boolean);
begin
  Action_IniciarSequencial.Enabled := False;
  Action_CancelarSequencial.Enabled := True;
  Action_FinalizarSequencial.Enabled := True;

  Action_IniciarLivre.Enabled := False;
  Action_CancelarLivre.Enabled := True;
//  Action_FinalizarLivre.Enabled := True;

  Form_Principal.CFDBGrid_CCU.Enabled := not aModoSequencial;
  Form_Principal.DBMemo_TX_DESCRICAO.ReadOnly := False;
  Form_Principal.DBLookupComboBox_TI_CODIGOSDACCU_ID.Enabled := True;
  Form_Principal.GroupBox_DataSet.Enabled := False;
  Form_Principal.LabeledEdit_CCU_TX_DESCRICAO.Enabled := False;
  Form_Principal.ComboBox_CDC_VA_CODIGO.Enabled := False;

  Form_Principal.TabSheet_TimeSheet.TabVisible := aModoSequencial;
  Form_Principal.TabSheet_Livre.TabVisible := not aModoSequencial;

  Form_Principal.DBLookupComboBox_TI_CODIGOSDACCU_ID.SetFocus;

  if aModoSequencial then
    FInicioDaTarefa := Now;
end;

procedure TDataModule_Principal.Filtrar;
begin
  try
    CCU.Filtered := False;

    CCU.FilterOptions := [foCaseInsensitive];
    CCU.Filter := 'TX_DESCRICAO LIKE ' + QuotedStr(Form_Principal.LabeledEdit_CCU_TX_DESCRICAO.Text);

    if Form_Principal.ComboBox_CDC_VA_CODIGO.ItemIndex > 0 then
      CCU.Filter := CCU.Filter + ' AND TI_CODIGOSDACCU_ID = ' + IntToStr(Form_Principal.ComboBox_CDC_VA_CODIGO.ItemIndex);

  finally
    DataModule_Principal.CCU.Filtered := True;
  end;
end;

procedure TDataModule_Principal.Timer_PrincipalTimer(Sender: TObject);
begin
  if FInicioDaTarefa > 0 then
    Form_Principal.StatusBar_Principal.Panels[2].Text := 'A  atividade atual já consumiu ' + FormatDateTime('hh:nn:ss',Now - FInicioDaTarefa) + ' até agora'
  else
    Form_Principal.StatusBar_Principal.Panels[2].Text := 'Nenhuma atividade em execução';

  Form_Principal.StatusBar_Principal.Panels[1].Text := FormatDateTime('hh:nn:ss',Now);
end;

procedure TDataModule_Principal.ZConnection_PrincipalAfterConnect(Sender: TObject);
begin
  CODIGOSDACCU.Open;
  CCU.Open;
end;

end.
