unit UBDOForm_TabelasAuxiliares;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ActnList, ExtCtrls, StdCtrls,

  UXXXForm_ModuleTabbedTemplate, Buttons, DBCtrls, Mask, Grids, UCFDBGrid,
  ComCtrls, _StdCtrls, _DBCtrls, DBGrids;

type
  	TBDOForm_TabelasAuxiliares = class(TXXXForm_ModuleTabbedTemplate)
	    Action_ICM_First: TAction;
    	Action_ICM_Previous: TAction;
	    Action_ICM_Next: TAction;
    	Action_ICM_Last: TAction;
	    Action_ICM_Cancel: TAction;
    	Action_ICM_Post: TAction;
	    Action_ICM_Refresh: TAction;
        Action_UNI_First: TAction;
        Action_UNI_Previous: TAction;
        Action_UNI_Next: TAction;
        Action_UNI_Last: TAction;
        Action_UNI_Cancel: TAction;
        Action_UNI_Post: TAction;
        Action_UNI_Refresh: TAction;
	    PageControl_ICM_UNI: TPageControl;
    	TabSheet_ICM: TTabSheet;
	    Shape_ICM_EquipamentosListadosValor: TShape;
    	Label_ICM_TaxasListadas: TLabel;
	    Label_ICM_TaxasListadasValor: TLabel;
        DBGrid_ICM: TCFDBGrid;
        Panel_ICM_Layer: TPanel;
        SpeedButton_ICM_Primeiro: TSpeedButton;
        SpeedButton_ICM_Anterior: TSpeedButton;
        SpeedButton_ICM_Proximo: TSpeedButton;
        SpeedButton_ICM_Ultimo: TSpeedButton;
        SpeedButton_ICM_Inserir: TSpeedButton;
        SpeedButton_ICM_Excluir: TSpeedButton;
        SpeedButton_ICM_Editar: TSpeedButton;
        SpeedButton_ICM_Salvar: TSpeedButton;
        SpeedButton_ICM_Cancelar: TSpeedButton;
        SpeedButton_ICM_Atualizar: TSpeedButton;
        GroupBox_ICM_Dados: TGroupBox;
        Label_ICM_FL_VALOR: TLabel;
        DBEdit_ICM_FL_VALOR: TDBEdit;
        TabSheet_UNI: TTabSheet;
        Shape_UNI_FamiliasListadasValor: TShape;
        Label_UNI_UnidadesListadasValor: TLabel;
        Label_UNI_UnidadesListadas: TLabel;
        DBGrid_UNI: TCFDBGrid;
        Panel_UNI_Layer: TPanel;
        SpeedButton_UNI_Primeiro: TSpeedButton;
        SpeedButton_UNI_Anterior: TSpeedButton;
        SpeedButton_UNI_Proximo: TSpeedButton;
        SpeedButton_UNI_Ultimo: TSpeedButton;
        SpeedButton_UNI_Inserir: TSpeedButton;
        SpeedButton_UNI_Excluir: TSpeedButton;
        SpeedButton_UNI_Editar: TSpeedButton;
        SpeedButton_UNI_Salvar: TSpeedButton;
        SpeedButton_UNI_Cancelar: TSpeedButton;
        SpeedButton_UNI_Atualizar: TSpeedButton;
        GroupBox_UNI_Dados: TGroupBox;
        Label_UNI_VA_ABREVIATURA: TLabel;
        DBEdit_UNI_VA_ABREVIATURA: TDBEdit;
        Label_UNI_VA_DESCRICAO: TLabel;
        DBEdit_UNI_VA_DESCRICAO: TDBEdit;
        TabSheet_Justificativas: TTabSheet;
        Shape_Justificativas: TShape;
        Label_JUS_JustificativasListadasValor: TLabel;
        Label_JustificativasListadas: TLabel;
        CFDBGrid_JUS: TCFDBGrid;
        GroupBox_Justificativas: TGroupBox;
        Label_JUS_EN_CATEGORIA: TLabel;
        Label_JUS_VA_JUSTIFICATIVA: TLabel;
        DBEdit_JUS_VA_JUSTIFICATIVA: TDBEdit;
        Panel_JUS_Layer: TPanel;
        SpeedButton_JUS_First: TSpeedButton;
        SpeedButton_JUS_Previous: TSpeedButton;
        SpeedButton_JUS_Next: TSpeedButton;
        SpeedButton_JUS_Last: TSpeedButton;
        SpeedButton_JUS_Insert: TSpeedButton;
        SpeedButton_JUS_Delete: TSpeedButton;
        SpeedButton_JUS_Edit: TSpeedButton;
        SpeedButton_JUS_Confirm: TSpeedButton;
        SpeedButton_JUS_Cancel: TSpeedButton;
        SpeedButton_JUS_Refresh: TSpeedButton;
        DBComboBox_JUS_EN_CATEGORIA: TDBComboBox;
        Action_JUS_First: TAction;
        Action_JUS_Previous: TAction;
        Action_JUS_Next: TAction;
        Action_JUS_Last: TAction;
        Action_JUS_Cancel: TAction;
        Action_JUS_Post: TAction;
        Action_JUS_Refresh: TAction;
    	procedure Action_ICM_CancelExecute(Sender: TObject);
	    procedure Action_ICM_FirstExecute(Sender: TObject);
    	procedure Action_ICM_LastExecute(Sender: TObject);
        procedure Action_ICM_NextExecute(Sender: TObject);
        procedure Action_ICM_PostExecute(Sender: TObject);
        procedure Action_ICM_PreviousExecute(Sender: TObject);
        procedure Action_ICM_RefreshExecute(Sender: TObject);
        procedure Action_UNI_CancelExecute(Sender: TObject);
        procedure Action_UNI_FirstExecute(Sender: TObject);
        procedure Action_UNI_LastExecute(Sender: TObject);
        procedure Action_UNI_NextExecute(Sender: TObject);
        procedure Action_UNI_PostExecute(Sender: TObject);
        procedure Action_UNI_PreviousExecute(Sender: TObject);
        procedure Action_UNI_RefreshExecute(Sender: TObject);
    procedure Action_JUS_FirstExecute(Sender: TObject);
    procedure Action_JUS_PreviousExecute(Sender: TObject);
    procedure Action_JUS_NextExecute(Sender: TObject);
    procedure Action_JUS_LastExecute(Sender: TObject);
    procedure Action_JUS_CancelExecute(Sender: TObject);
    procedure Action_JUS_PostExecute(Sender: TObject);
    procedure Action_JUS_RefreshExecute(Sender: TObject);
  	private
    	{ Private declarations }
  	public
    	{ Public declarations }
  	end;

implementation

uses
	UXXXTypesConstantsAndClasses, UBDODataModule_TabelasAuxiliares;

{$R *.dfm}

procedure TBDOForm_TabelasAuxiliares.Action_ICM_CancelExecute(Sender: TObject);
begin
  	inherited;
	TBDODataModule_TabelasAuxiliares(MyDataModule).DBButtonClick_ICM(dbbCancel)
end;

procedure TBDOForm_TabelasAuxiliares.Action_ICM_FirstExecute(Sender: TObject);
begin
  	inherited;
    TBDODataModule_TabelasAuxiliares(MyDataModule).DBButtonClick_ICM(dbbFirst);
end;

procedure TBDOForm_TabelasAuxiliares.Action_ICM_LastExecute(Sender: TObject);
begin
  	inherited;
    TBDODataModule_TabelasAuxiliares(MyDataModule).DBButtonClick_ICM(dbbLast);
end;

procedure TBDOForm_TabelasAuxiliares.Action_ICM_NextExecute(Sender: TObject);
begin
  	inherited;
    TBDODataModule_TabelasAuxiliares(MyDataModule).DBButtonClick_ICM(dbbNext);
end;

procedure TBDOForm_TabelasAuxiliares.Action_ICM_PostExecute(Sender: TObject);
begin
  	inherited;
    TBDODataModule_TabelasAuxiliares(MyDataModule).DBButtonClick_ICM(dbbPost);
end;

procedure TBDOForm_TabelasAuxiliares.Action_ICM_PreviousExecute(Sender: TObject);
begin
  	inherited;
    TBDODataModule_TabelasAuxiliares(MyDataModule).DBButtonClick_ICM(dbbPrevious);
end;

procedure TBDOForm_TabelasAuxiliares.Action_ICM_RefreshExecute(Sender: TObject);
begin
  	inherited;
    TBDODataModule_TabelasAuxiliares(MyDataModule).DBButtonClick_ICM(dbbRefresh);
end;

procedure TBDOForm_TabelasAuxiliares.Action_JUS_CancelExecute(Sender: TObject);
begin
    inherited;
    TBDODataModule_TabelasAuxiliares(MyDataModule).DBButtonClick_JUS(dbbCancel)
end;

procedure TBDOForm_TabelasAuxiliares.Action_JUS_FirstExecute(Sender: TObject);
begin
    inherited;
    TBDODataModule_TabelasAuxiliares(MyDataModule).DBButtonClick_JUS(dbbFirst)
end;

procedure TBDOForm_TabelasAuxiliares.Action_JUS_LastExecute(Sender: TObject);
begin
    inherited;
    TBDODataModule_TabelasAuxiliares(MyDataModule).DBButtonClick_JUS(dbbLast)
end;

procedure TBDOForm_TabelasAuxiliares.Action_JUS_NextExecute(Sender: TObject);
begin
    inherited;
    TBDODataModule_TabelasAuxiliares(MyDataModule).DBButtonClick_JUS(dbbNext)
end;

procedure TBDOForm_TabelasAuxiliares.Action_JUS_PostExecute(Sender: TObject);
begin
    inherited;
    TBDODataModule_TabelasAuxiliares(MyDataModule).DBButtonClick_JUS(dbbPost)
end;

procedure TBDOForm_TabelasAuxiliares.Action_JUS_PreviousExecute(Sender: TObject);
begin
    inherited;
    TBDODataModule_TabelasAuxiliares(MyDataModule).DBButtonClick_JUS(dbbPrevious)
end;

procedure TBDOForm_TabelasAuxiliares.Action_JUS_RefreshExecute(Sender: TObject);
begin
    inherited;
    TBDODataModule_TabelasAuxiliares(MyDataModule).DBButtonClick_JUS(dbbRefresh)
end;

procedure TBDOForm_TabelasAuxiliares.Action_UNI_CancelExecute(Sender: TObject);
begin
  	inherited;
    TBDODataModule_TabelasAuxiliares(MyDataModule).DBButtonClick_UNI(dbbCancel)
end;

procedure TBDOForm_TabelasAuxiliares.Action_UNI_FirstExecute(Sender: TObject);
begin
  	inherited;
    TBDODataModule_TabelasAuxiliares(MyDataModule).DBButtonClick_UNI(dbbFirst);
end;

procedure TBDOForm_TabelasAuxiliares.Action_UNI_LastExecute(Sender: TObject);
begin
  	inherited;
    TBDODataModule_TabelasAuxiliares(MyDataModule).DBButtonClick_UNI(dbbLast);
end;

procedure TBDOForm_TabelasAuxiliares.Action_UNI_NextExecute(Sender: TObject);
begin
  	inherited;
    TBDODataModule_TabelasAuxiliares(MyDataModule).DBButtonClick_UNI(dbbNext);
end;

procedure TBDOForm_TabelasAuxiliares.Action_UNI_PostExecute(Sender: TObject);
begin
  	inherited;
    TBDODataModule_TabelasAuxiliares(MyDataModule).DBButtonClick_UNI(dbbPost);
end;

procedure TBDOForm_TabelasAuxiliares.Action_UNI_PreviousExecute(Sender: TObject);
begin
  	inherited;
    TBDODataModule_TabelasAuxiliares(MyDataModule).DBButtonClick_UNI(dbbPrevious);
end;

procedure TBDOForm_TabelasAuxiliares.Action_UNI_RefreshExecute(Sender: TObject);
begin
  	inherited;
    TBDODataModule_TabelasAuxiliares(MyDataModule).DBButtonClick_UNI(dbbRefresh);
end;

end.
