unit UZTODialog_Regioes;

interface

uses Classes
   , Controls
   , Forms
   , Mdl.Lib.ZTODialog_TaskBar
   , StdCtrls
   , UCFDBGrid
   , ExtCtrls
   , ZTO.Components.DataControls.LabeledDBEdit
   , ComCtrls
   , ToolWin, Grids, DBGrids, Mask, DBCtrls, ImgList, DBActns, ActnList;

type
  TZTODialog_Regioes = class(TZTODialog_TaskBar)
    GroupBox_REG_Filtro: TGroupBox;
    LabeledEdit_REG_VA_REGIAO: TLabeledEdit;
    GroupBox_REG_DadosDaRegiao: TGroupBox;
    LabeledDBEdit_REG_VA_REGIAO: TZTOLabeledDBEdit;
    LabeledDBEdit_REG_CH_PREFIXODAPROPOSTA: TZTOLabeledDBEdit;
    LabeledDBEdit_REG_VA_PRIMEIRORODAPE: TZTOLabeledDBEdit;
    LabeledDBEdit_REG_VA_SEGUNDORODAPE: TZTOLabeledDBEdit;
    CFDBGrid_REG: TCFDBGrid;
    ToolBar_DBNavigator: TToolBar;
    ToolButton_First: TToolButton;
    ToolButton_Previous: TToolButton;
    ToolButton_Next: TToolButton;
    ToolButton_Last: TToolButton;
    ToolButton_Insert: TToolButton;
    ToolButton_Delete: TToolButton;
    ToolButton_Edit: TToolButton;
    ToolButton_Post: TToolButton;
    ToolButton_Cancel: TToolButton;
    ToolButton_Refresh: TToolButton;
    ToolButton_Separador1: TToolButton;
    ToolButton_Separador2: TToolButton;
    ToolButton_Separador3: TToolButton;
  private
    { Private declarations }
  protected

  public
    { Public declarations }
  end;

implementation

{$R *.dfm}

end.
