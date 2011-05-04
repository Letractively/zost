unit UForm_Principal;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ComCtrls, ExtCtrls, Grids, DBGrids, StdCtrls, DBCtrls, Buttons,
  Gauges;

type
  TForm_Principal = class(TForm)
    PageControl_Principal: TPageControl;
    TabSheet_Relatorio: TTabSheet;
    Panel_Relatorio: TPanel;
    Panel_Detalhes: TPanel;
    DBGrid_Detalhes: TDBGrid;
    Panel_Informacoes: TPanel;
    DBText_DATACRIACAO: TDBText;
    DBText_DATAMODIFICACAO: TDBText;
    DBText_DATACRIACAOLOG: TDBText;
    DBText_DATAMODIFICACAOLOG: TDBText;
    Label_DataCriacao: TLabel;
    Label_DataModificacao: TLabel;
    Label_DataCriacaoLog: TLabel;
    Label_DataModificacaoLog: TLabel;
    BitBtn_Verificar: TBitBtn;
    DBGrid_Historico: TDBGrid;
    TabSheet_Script: TTabSheet;
    Memo_Script: TMemo;
    Panel_Script: TPanel;
    BitBtn_Gerar: TBitBtn;
    BitBtn_SalvarScript: TBitBtn;
    Gauge_Script: TGauge;
    CheckBox_GerarCreate: TCheckBox;
    CheckBox_GerarTriggers: TCheckBox;
    CheckBox_GerarAlter: TCheckBox;
    GroupBox_Opcoes: TGroupBox;
    DBGrid_COLUNAS: TDBGrid;
    Panel_Info: TPanel;
    Shape_Info: TShape;
    Label_Info: TLabel;
    Shape_Relatorio: TShape;
    procedure BitBtn_VerificarClick(Sender: TObject);
    procedure DoDrawColumnCell(Sender: TObject;
      const Rect: TRect; DataCol: Integer; Column: TColumn;
      State: TGridDrawState);
    procedure DBGrid_HistoricoDrawColumnCell(Sender: TObject;
      const Rect: TRect; DataCol: Integer; Column: TColumn;
      State: TGridDrawState);
    procedure BitBtn_GerarClick(Sender: TObject);
    procedure BitBtn_SalvarScriptClick(Sender: TObject);
    procedure CheckBox_GerarCreateClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form_Principal: TForm_Principal;

implementation

uses UDataModule_Principal;

{$R *.dfm}

procedure TForm_Principal.BitBtn_VerificarClick(Sender: TObject);
begin
  DataModule_Principal.Verificar;
end;

procedure TForm_Principal.DoDrawColumnCell(Sender: TObject; const Rect: TRect; DataCol: Integer; Column: TColumn; State: TGridDrawState);
var
  grid: TDBGrid;
  row: integer;
begin
  grid := sender as TDBGrid;

  row := grid.DataSource.DataSet.RecNo;

  if Odd(row) then
    grid.Canvas.Brush.Color := clInfoBk
  else
    grid.Canvas.Brush.Color := clWindow;

  if (gdSelected in State) then
  begin
    with grid.Canvas do
    begin
      Brush.Color := clHighlight;
      Font.Color := clHighlightText;
    end;
  end;

  grid.DefaultDrawColumnCell(Rect, DataCol, Column, State) ;
end;

procedure TForm_Principal.DBGrid_HistoricoDrawColumnCell(Sender: TObject; const Rect: TRect; DataCol: Integer; Column: TColumn;
  State: TGridDrawState);
var
  grid: TDBGrid;
  row: integer;
begin
  grid := sender as TDBGrid;

  row := grid.DataSource.DataSet.RecNo;

  if Odd(row) then
    grid.Canvas.Brush.Color := clInfoBk
  else
    grid.Canvas.Brush.Color := clWindow;

  if (gdSelected in State) then
  begin
    with grid.Canvas do
    begin
      Brush.Color := clHighlight;
      Font.Color := clHighlightText;
    end;
  end;

  grid.DefaultDrawColumnCell(Rect, DataCol, Column, State) ;
end;

procedure TForm_Principal.BitBtn_GerarClick(Sender: TObject);
begin
  DataModule_Principal.GerarScript;
end;

procedure TForm_Principal.BitBtn_SalvarScriptClick(Sender: TObject);
begin
  if Trim(Memo_Script.Text) <> '' then
    if DataModule_Principal.SaveDialog_Script.Execute then
      Memo_Script.Lines.SaveToFile(DataModule_Principal.SaveDialog_Script.FileName);
end;

procedure TForm_Principal.CheckBox_GerarCreateClick(Sender: TObject);
begin
  if (not CheckBox_GerarCreate.Checked) and (not CheckBox_GerarTriggers.Checked) and (not CheckBox_GerarAlter.Checked) then
  begin
    TCheckBox(Sender).Checked := True;
    raise Exception.Create('Ao menos uma opção deve permanecer marcada');
  end;
end;

end.
