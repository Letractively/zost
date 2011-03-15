unit UBDOForm_Regioes;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ActnList, ExtCtrls, StdCtrls, Grids, Buttons, Mask, DBCtrls,

  _StdCtrls, _DBCtrls, UXXXForm_ModuleTabbedTemplate, DBGrids,
  UCFDBGrid;

type
	TBDOForm_RegioesClass = class of TBDOForm_Regioes;

  	TBDOForm_Regioes = class(TXXXForm_ModuleTabbedTemplate)
	    GroupBox_REG_DadosDaRegiao: TGroupBox;
    	Label_REG_Regiao: TLabel;
	    Label1: TLabel;
    	Label_REG_VA_PRIMEIRORODAPE: TLabel;
	    Label_REG_VA_SEGUNDORODAPE: TLabel;
    	DBEdit_REG_VA_REGIAO: TDBEdit;
	    DBEdit_REG_CH_PREFIXODAPROPOSTA: TDBEdit;
    	DBEdit_REG_VA_PRIMEIRORODAPE: TDBEdit;
	    DBEdit_REG_VA_SEGUNDORODAPE: TDBEdit;
    	Panel_REG_Layer: TPanel;
	    SpeedButton_REG_Primeiro: TSpeedButton;
    	SpeedButton_REG_Anterior: TSpeedButton;
	    SpeedButton_REG_Proximo: TSpeedButton;
    	SpeedButton_REG_Ultimo: TSpeedButton;
	    SpeedButton_REG_Inserir: TSpeedButton;
    	SpeedButton_REG_Excluir: TSpeedButton;
	    SpeedButton_REG_Editar: TSpeedButton;
    	SpeedButton_REG_Salvar: TSpeedButton;
	    SpeedButton_REG_Cancelar: TSpeedButton;
    	SpeedButton_REG_Atualizar: TSpeedButton;
	    GroupBox_REG_Filtro: TGroupBox;
    	DBGrid_REG: TCFDBGrid;
    	Action_REG_First: TAction;
		Action_REG_Previous: TAction;
        Action_REG_Next: TAction;
		Action_REG_Last: TAction;
        Action_REG_Cancel: TAction;
		Action_REG_Post: TAction;
		Action_REG_Refresh: TAction;
    LabeledEdit_REG_VA_REGIAO: TLabeledEdit;
    	procedure Action_REG_PostExecute(Sender: TObject);
	    procedure Action_REG_CancelExecute(Sender: TObject);
    	procedure Action_REG_RefreshExecute(Sender: TObject);
	    procedure Action_REG_FirstExecute(Sender: TObject);
    	procedure Action_REG_PreviousExecute(Sender: TObject);
	    procedure Action_REG_NextExecute(Sender: TObject);
    	procedure Action_REG_LastExecute(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure LabeledEdit_REG_VA_REGIAOChange(Sender: TObject);
//    	procedure FormShow(Sender: TObject);
  	private
    	{ Private declarations }
  	public
    	{ Public declarations }
  	end;

implementation

uses
	UBDODataModule_Regioes, UXXXTypesConstantsAndClasses;

{$R *.dfm}

procedure TBDOForm_Regioes.Action_REG_CancelExecute(Sender: TObject);
begin
  	inherited;
	TBDODataModule_Regioes(MyDataModule).DBButtonClick_REG(dbbCancel);
end;

procedure TBDOForm_Regioes.Action_REG_FirstExecute(Sender: TObject);
begin
  	inherited;
  	TBDODataModule_Regioes(MyDataModule).DBButtonClick_REG(dbbFirst);
end;

procedure TBDOForm_Regioes.Action_REG_LastExecute(Sender: TObject);
begin
  	inherited;
    TBDODataModule_Regioes(MyDataModule).DBButtonClick_REG(dbbLast);
end;

procedure TBDOForm_Regioes.Action_REG_NextExecute(Sender: TObject);
begin
  	inherited;
    TBDODataModule_Regioes(MyDataModule).DBButtonClick_REG(dbbNext);
end;

procedure TBDOForm_Regioes.Action_REG_PostExecute(Sender: TObject);
begin
  	inherited;
    TBDODataModule_Regioes(MyDataModule).DBButtonClick_REG(dbbPost);
end;

procedure TBDOForm_Regioes.Action_REG_PreviousExecute(Sender: TObject);
begin
  	inherited;
    TBDODataModule_Regioes(MyDataModule).DBButtonClick_REG(dbbPrevious);
end;

procedure TBDOForm_Regioes.Action_REG_RefreshExecute(Sender: TObject);
begin
  	inherited;
	TBDODataModule_Regioes(MyDataModule).DBButtonClick_REG(dbbRefresh);
end;

procedure TBDOForm_Regioes.FormShow(Sender: TObject);
begin
  	inherited;
  	if DBGrid_REG.Tag = 0 then
  	begin
    	DBGrid_REG.Width := Succ(DBGrid_REG.Width);
    	DBGrid_REG.Width := Pred(DBGrid_REG.Width);
        DBGrid_REG.Tag := 1;
  	end;
end;

procedure TBDOForm_Regioes.LabeledEdit_REG_VA_REGIAOChange(Sender: TObject);
begin
    inherited;
    TBDODataModule_Regioes(MyDataModule).LocalizarRegiaoPorNome(LabeledEdit_REG_VA_REGIAO);
end;

end.
