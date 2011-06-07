unit Mdl.Lib.ZTOSDIForm_Cadastro1;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, Mdl.Lib.ZTOSDIForm_TaskBar, ComCtrls, StdCtrls, Grids, DBGrids,
  ZTO.Components.DataControls.DBGrid, PNGImage, ImgList, ToolWin, ActnMan, ActnCtrls,
  ActnList, DBActns;

type
  TZTOSDIForm_Cadastro1 = class(TZTOSDIForm_TaskBar)
    PageControl_Cadastro: TPageControl;
    TabSheet_Pesquisa: TTabSheet;
    TabSheet_Cadastro: TTabSheet;
    GroupBox_Filtro: TGroupBox;
    ZTODBGrid_Filtro: TZTODBGrid;
    ToolBar_Filtro: TToolBar;
    ToolButton1: TToolButton;
    ToolButton2: TToolButton;
    ToolButton3: TToolButton;
    ToolButton4: TToolButton;
    StatusBar1: TStatusBar;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

implementation

{$R *.dfm}

end.
