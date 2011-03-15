unit UBDOForm_EquipamentosEFamilias;

interface

uses
  	Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  	Dialogs, ActnList, ExtCtrls, StdCtrls, Buttons, DBCtrls, Mask, Grids, ComCtrls,

  	UXXXForm_ModuleTabbedTemplate, UCFDBGrid, _StdCtrls, _DBCtrls, DBGrids;

type
	TBDOForm_EquipamentosEFamiliaClass = class of TBDOForm_EquipamentosEFamilias;

  	TBDOForm_EquipamentosEFamilias = class(TXXXForm_ModuleTabbedTemplate)
	    Action_EQP_First: TAction;
    	Action_EQP_Previous: TAction;
	    Action_EQP_Next: TAction;
    	Action_EQP_Last: TAction;
	    Action_EQP_Cancel: TAction;
    	Action_EQP_Post: TAction;
	    Action_EQP_Refresh: TAction;
        Action_FAM_First: TAction;
        Action_FAM_Previous: TAction;
        Action_FAM_Next: TAction;
        Action_FAM_Last: TAction;
        Action_FAM_Cancel: TAction;
        Action_FAM_Post: TAction;
        Action_FAM_Refresh: TAction;
        PageControl_EQP_FAM: TPageControl;
        TabSheet_EQP: TTabSheet;
        Shape_EQP_EquipamentosListadosValor: TShape;
        Label_EQP_EquipamentosListados: TLabel;
        Label_EQP_EquipamentosListadosValor: TLabel;
        DBGrid_EQP: TCFDBGrid;
        GroupBox_EQP_Filtro: TGroupBox;
        GroupBox_EQP_OValorEh: TGroupBox;
        ComboBox_EQP_Modo: TComboBox;
        Edit_EQP_ValorEh: TEdit;
        GroupBox_EQP_Dados: TGroupBox;
        Label_EQP_Modelo: TLabel;
    	Label_EQP_FL_VALOR: TLabel;
        Label_EQP_FL_LUCROBRUTO: TLabel;
        Label1: TLabel;
        DBEdit_EQP_VA_MODELO: TDBEdit;
        DBEdit_EQP_FL_VALOR: TDBEdit;
        DBEdit_EQP_FL_LUCROBRUTO: TDBEdit;
        DBRadioGroup_EQP_BO_DISPONIVEL: TDBRadioGroup;
        DBComboBox_EQP_TI_MOEDA: TDBComboBox;
        Panel_EQP_Layer: TPanel;
        SpeedButton_EQP_Primeiro: TSpeedButton;
        SpeedButton_EQP_Anterior: TSpeedButton;
        SpeedButton_EQP_Proximo: TSpeedButton;
        SpeedButton_EQP_Ultimo: TSpeedButton;
        SpeedButton_EQP_Inserir: TSpeedButton;
        SpeedButton_EQP_Excluir: TSpeedButton;
        SpeedButton_EQP_Editar: TSpeedButton;
        SpeedButton_EQP_Salvar: TSpeedButton;
        SpeedButton_EQP_Cancelar: TSpeedButton;
        SpeedButton_EQP_Atualizar: TSpeedButton;
        TabSheet_FAM: TTabSheet;
        Shape_FAM_FamiliasListadasValor: TShape;
        Label_FAM_FamiliasListadasValor: TLabel;
        Label_FAM_FamiliasListadas: TLabel;
        GroupBox_FAM_Filtro: TGroupBox;
        DBGrid_FAM: TCFDBGrid;
        GroupBox_FAM_Dados: TGroupBox;
        Label_FAM_Descricao: TLabel;
        DBEdit_FAM_VA_DESCRICAO: TDBEdit;
        Panel_FAM_Layer: TPanel;
        SpeedButton_FAM_Primeiro: TSpeedButton;
        SpeedButton_FAM_Anterior: TSpeedButton;
        SpeedButton_FAM_Proximo: TSpeedButton;
        SpeedButton_FAM_Ultimo: TSpeedButton;
        SpeedButton_FAM_Inserir: TSpeedButton;
        SpeedButton_FAM_Excluir: TSpeedButton;
        SpeedButton_FAM_Editar: TSpeedButton;
        SpeedButton_FAM_Salvar: TSpeedButton;
        SpeedButton_FAM_Cancelar: TSpeedButton;
        SpeedButton_FAM_Atualizar: TSpeedButton;
        LabeledEdit_EQP_VA_MODELO: TLabeledEdit;
        LabeledEdit_FAM_VA_DESCRICAO: TLabeledEdit;
        SpeedButton_CarregarDados: TBitBtn;
        SpeedButton1: TBitBtn;
        SpeedButton_FAM_Relatorio: TBitBtn;
        Label_EQP_FL_IPI: TLabel;
        DBEdit_EQP_FL_IPI: TDBEdit;
        procedure Action_EQP_CancelExecute(Sender: TObject);
        procedure Action_EQP_FirstExecute(Sender: TObject);
        procedure Action_EQP_LastExecute(Sender: TObject);
        procedure Action_EQP_NextExecute(Sender: TObject);
        procedure Action_EQP_PostExecute(Sender: TObject);
        procedure Action_EQP_PreviousExecute(Sender: TObject);
        procedure Action_EQP_RefreshExecute(Sender: TObject);
    	procedure Action_FAM_FirstExecute(Sender: TObject);
	    procedure Action_FAM_PreviousExecute(Sender: TObject);
    	procedure Action_FAM_NextExecute(Sender: TObject);
	    procedure Action_FAM_LastExecute(Sender: TObject);
    	procedure Action_FAM_CancelExecute(Sender: TObject);
	    procedure Action_FAM_PostExecute(Sender: TObject);
    	procedure Action_FAM_RefreshExecute(Sender: TObject);
        procedure TabSheet_EQPShow(Sender: TObject);
        procedure TabSheet_FAMShow(Sender: TObject);
        procedure DoChange_EQP(Sender: TObject);
        procedure LabeledEdit_FAM_VA_DESCRICAOChange(Sender: TObject);
    procedure DBGrid_EQPDrawColumnCell(Sender: TObject; const Rect: TRect;
      DataCol: Integer; Column: TColumn; State: TGridDrawState);
  	private
    	{ Private declarations }
  	public
    	{ Public declarations }
  	end;

implementation

uses
	UBDODataModule_EquipamentosEFamilias, UXXXTypesConstantsAndClasses;

{$R *.dfm}

procedure TBDOForm_EquipamentosEFamilias.Action_EQP_CancelExecute(Sender: TObject);
begin
  	inherited;
    { Isso foi necessário pois caso o foco esteja no DBRadioGroup, não é
    possível cancelar a operação (bug do delphi) }
//   	DBEdit_EQP_VA_DESCRICAO.SetFocus;
	TBDODataModule_EquipamentosEFamilias(MyDataModule).DBButtonClick_EQP(dbbCancel)
end;

procedure TBDOForm_EquipamentosEFamilias.Action_EQP_FirstExecute(Sender: TObject);
begin
  	inherited;
    TBDODataModule_EquipamentosEFamilias(MyDataModule).DBButtonClick_EQP(dbbFirst);
end;

procedure TBDOForm_EquipamentosEFamilias.Action_EQP_LastExecute(Sender: TObject);
begin
  	inherited;
    TBDODataModule_EquipamentosEFamilias(MyDataModule).DBButtonClick_EQP(dbbLast);
end;

procedure TBDOForm_EquipamentosEFamilias.Action_EQP_NextExecute(Sender: TObject);
begin
  	inherited;
    TBDODataModule_EquipamentosEFamilias(MyDataModule).DBButtonClick_EQP(dbbNext);
end;

procedure TBDOForm_EquipamentosEFamilias.Action_EQP_PostExecute(Sender: TObject);
begin
  	inherited;
    TBDODataModule_EquipamentosEFamilias(MyDataModule).DBButtonClick_EQP(dbbPost);
end;

procedure TBDOForm_EquipamentosEFamilias.Action_EQP_PreviousExecute(Sender: TObject);
begin
  	inherited;
    TBDODataModule_EquipamentosEFamilias(MyDataModule).DBButtonClick_EQP(dbbPrevious);
end;

procedure TBDOForm_EquipamentosEFamilias.Action_EQP_RefreshExecute(Sender: TObject);
begin
  	inherited;
    TBDODataModule_EquipamentosEFamilias(MyDataModule).DBButtonClick_EQP(dbbRefresh);
end;

procedure TBDOForm_EquipamentosEFamilias.Action_FAM_CancelExecute(Sender: TObject);
begin
  	inherited;
    TBDODataModule_EquipamentosEFamilias(MyDataModule).DBButtonClick_FAM(dbbCancel)
end;

procedure TBDOForm_EquipamentosEFamilias.Action_FAM_FirstExecute(Sender: TObject);
begin
  	inherited;
    TBDODataModule_EquipamentosEFamilias(MyDataModule).DBButtonClick_FAM(dbbFirst);
end;

procedure TBDOForm_EquipamentosEFamilias.Action_FAM_LastExecute(Sender: TObject);
begin
  	inherited;
    TBDODataModule_EquipamentosEFamilias(MyDataModule).DBButtonClick_FAM(dbbLast);
end;

procedure TBDOForm_EquipamentosEFamilias.Action_FAM_NextExecute(Sender: TObject);
begin
  	inherited;
    TBDODataModule_EquipamentosEFamilias(MyDataModule).DBButtonClick_FAM(dbbNext);
end;

procedure TBDOForm_EquipamentosEFamilias.Action_FAM_PostExecute(Sender: TObject);
begin
  	inherited;
    TBDODataModule_EquipamentosEFamilias(MyDataModule).DBButtonClick_FAM(dbbPost);
end;

procedure TBDOForm_EquipamentosEFamilias.Action_FAM_PreviousExecute(Sender: TObject);
begin
  	inherited;
    TBDODataModule_EquipamentosEFamilias(MyDataModule).DBButtonClick_FAM(dbbPrevious);
end;

procedure TBDOForm_EquipamentosEFamilias.Action_FAM_RefreshExecute(Sender: TObject);
begin
  	inherited;
    TBDODataModule_EquipamentosEFamilias(MyDataModule).DBButtonClick_FAM(dbbRefresh);
end;

procedure TBDOForm_EquipamentosEFamilias.DBGrid_EQPDrawColumnCell(Sender: TObject; const Rect: TRect; DataCol: Integer; Column: TColumn; State: TGridDrawState);
begin
    inherited;
    if (DataCol = 4) and not (gdSelected in State) then
        if (TCFDBGrid(Sender).DataSource.DataSet.FieldByName('BO_DISPONIVEL').AsInteger = 1) then
            TCFDBGrid(Sender).Canvas.Font.Color := clGreen
        else
            TCFDBGrid(Sender).Canvas.Font.Color := clRed;

    TCFDBGrid(Sender).DefaultDrawColumnCell(Rect, DataCol, Column, State);
end;

procedure TBDOForm_EquipamentosEFamilias.DoChange_EQP(Sender: TObject);
begin
    inherited;
    TBDODataModule_EquipamentosEFamilias(MyDataModule).LocalizarEquipamentoPorModeloEValor(LabeledEdit_EQP_VA_MODELO
                                                                                          ,ComboBox_EQP_Modo
                                                                                          ,Edit_EQP_ValorEh);
end;

procedure TBDOForm_EquipamentosEFamilias.LabeledEdit_FAM_VA_DESCRICAOChange(Sender: TObject);
begin
    inherited;
    TBDODataModule_EquipamentosEFamilias(MyDataModule).LocalizarFamiliaPorDescricao(LabeledEdit_FAM_VA_DESCRICAO);
end;

procedure TBDOForm_EquipamentosEFamilias.TabSheet_EQPShow(Sender: TObject);
begin
  	inherited;
  	if DBGrid_EQP.Tag = 0 then
  	begin
    	DBGrid_EQP.Width := Succ(DBGrid_EQP.Width);
    	DBGrid_EQP.Width := Pred(DBGrid_EQP.Width);
        DBGrid_EQP.Tag := 1;
  	end;
end;

procedure TBDOForm_EquipamentosEFamilias.TabSheet_FAMShow(Sender: TObject);
begin
  	inherited;
  	if DBGrid_FAM.Tag = 0 then
  	begin
    	DBGrid_FAM.Width := Succ(DBGrid_FAM.Width);
    	DBGrid_FAM.Width := Pred(DBGrid_FAM.Width);
        DBGrid_FAM.Tag := 1;
  	end;
end;

end.
