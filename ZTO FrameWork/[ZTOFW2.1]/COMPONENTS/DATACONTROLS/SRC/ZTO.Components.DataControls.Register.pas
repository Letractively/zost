unit ZTO.Components.DataControls.Register;

interface

uses Classes
   , DesignEditors
   , DesignIntf
   , ZTO.Components.DataControls.DBGrid;

type
  TSortedColumnProperty = class(TStringProperty)
  private
    FGrid: TCustomZTODBGrid;
  public
    procedure Initialize; override;
    function GetAttributes: TPropertyAttributes; override;
    procedure GetValues(Proc: TGetStrProc); override;
    procedure SetValue(const Value: string); override;
  end;

  TVariableWidthColumnsProperty = class(TStringProperty)
  private
    FGrid: TCustomZTODBGrid;
  public
    procedure Initialize; override;
    function GetAttributes: TPropertyAttributes; override;
    procedure Edit; override;
    procedure SetValue(const Value: string); override;
  end;

procedure Register;

implementation

uses DBGrids
   , Forms
   , ZTO.Components.DataControls.LabeledDBEdit
   , ZTO.Components.DataControls.VariableColumnsEditor;

procedure Register;
begin
  RegisterComponents('ZTO Data Controls',[TZTOLabeledDBEdit,TZTODBGrid]);
  RegisterPropertyEditor(TypeInfo(WideString),TSortArrow,'Column',TSortedColumnProperty);
  RegisterPropertyEditor(TypeInfo(WideString),TCustomZTODBGrid,'VariableWidthColumns',TVariableWidthColumnsProperty);
end;

{ TSortedColumnProperty }

function TSortedColumnProperty.GetAttributes: TPropertyAttributes;
begin
  Result := [paValueList,paReadOnly,paSortList,paValueEditable];
end;

{ Obtendo dados protegidos }
type
  TCZTODBG = class(TCustomZTODBGrid);

procedure TSortedColumnProperty.GetValues(Proc: TGetStrProc);
var
  i: Byte;
begin
  inherited;
  Proc('[N/A]');
  if (TCZTODBG(FGrid).Columns.State = csCustomized) then
    for i := 0 to Pred(TCZTODBG(FGrid).Columns.Count) do
      Proc(TCZTODBG(FGrid).Columns[i].FieldName);
end;


procedure TSortedColumnProperty.Initialize;
begin
  inherited;
  FGrid := TSortArrow(GetComponent(0)).Grid;
end;

procedure TSortedColumnProperty.SetValue(const Value: string);
begin
  inherited;
  TCZTODBG(FGrid).InvalidateTitles;
end;

{ TVariableWidthColumns }

procedure TVariableWidthColumnsProperty.Edit;
var
  i: Word;
  CheckedColumns: String;
begin
  inherited;
  if TCZTODBG(FGrid).Columns.State = csCustomized then
    with TForm_VariableColumnsEditor.Create(nil) do
      try
        { Carrega a lista com as colunas dispon�veis }
        CheckListBox_Columns.Clear;

        for i := 0 to Pred(TCZTODBG(FGrid).Columns.Count) do
          CheckListBox_Columns.Items.Add(TCZTODBG(FGrid).Columns[i].FieldName);

        { Marca na lista as colunas de largura autom�tica }
        CheckedColumns := GetValue;
        for i := 0 to Pred(CheckListBox_Columns.Count) do
          CheckListBox_Columns.Checked[i] := Pos('<' + CheckListBox_Columns.Items[i] + '>',CheckedColumns) > 0;

        if ShowModal = 1 then { mrOk }
        begin
          { Salva apenas as colunas marcadas }
          CheckedColumns := '';
          for i := 0 to Pred(CheckListBox_Columns.Count) do
            if CheckListBox_Columns.Checked[i] then
                CheckedColumns := CheckedColumns + '<' + CheckListBox_Columns.Items[i] + '>';

          SetValue(CheckedColumns);
        end;
      finally
        Free;
      end
  else
    Application.MessageBox('N�o � poss�vel indicar colunas de largura autom�tica quando n�o existem colunas customizadas no grid. Favor alterar a propriedade "Columns" do grid','N�o existem colunas customizadas',$00000030);
end;

function TVariableWidthColumnsProperty.GetAttributes: TPropertyAttributes;
begin
  Result := [paDialog];
end;

procedure TVariableWidthColumnsProperty.Initialize;
begin
  inherited;
  FGrid := TCustomZTODBGrid(GetComponent(0));
end;

procedure TVariableWidthColumnsProperty.SetValue(const Value: string);
begin
  if TCZTODBG(FGrid).Columns.State = csCustomized then
  begin
    inherited;
    { For�a o ajuste das colunas quando a propriedade muda de valor }
    FGrid.AdjustColumns;
  end;
end;

end.
