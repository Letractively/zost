unit UBDOForm_TiposDeObra;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ActnList, ExtCtrls, StdCtrls, Buttons, Mask, DBCtrls, Grids,

  UXXXForm_ModuleTabbedTemplate, _StdCtrls, _DBCtrls,

  UCFDBGrid, DBGrids;

type
	TBDOForm_TiposDeObraClass = class of TBDOForm_TiposDeObra;

 	TBDOForm_TiposDeObra = class(TXXXForm_ModuleTabbedTemplate)
    	GroupBox_TIP_Filtro: TGroupBox;
	    CFDBGrid_TIP: TCFDBGrid;
    	GroupBox_TIP_Dados: TGroupBox;
	    Label_TIP_VA_DESCRICAO: TLabel;
    	DBEdit_TIP_VA_DESCRICAO: TDBEdit;
	    Panel_TIP_Layer: TPanel;
    	SpeedButton_TIP_Primeiro: TSpeedButton;
	    SpeedButton_TIP_Anterior: TSpeedButton;
    	SpeedButton_TIP_Proximo: TSpeedButton;
        SpeedButton_TIP_Inserir: TSpeedButton;
        SpeedButton_TIP_Excluir: TSpeedButton;
        SpeedButton_TIP_Editar: TSpeedButton;
        SpeedButton_TIP_Salvar: TSpeedButton;
        SpeedButton_TIP_Cancelar: TSpeedButton;
        SpeedButton_TIP_Atualizar: TSpeedButton;
        Action_SIT_First: TAction;
        Action_SIT_Previous: TAction;
        Action_SIT_Next: TAction;
        Action_SIT_Last: TAction;
        Action_SIT_Cancel: TAction;
        Action_SIT_Post: TAction;
        Action_SIT_Refresh: TAction;
	    SpeedButton_TIP_Ultimo: TSpeedButton;
    LabeledEdit_TIP_VA_DESCRICAO: TLabeledEdit;
//    	procedure FormShow(Sender: TObject);
	    procedure Action_SIT_FirstExecute(Sender: TObject);
	    procedure Action_SIT_PreviousExecute(Sender: TObject);
	    procedure Action_SIT_LastExecute(Sender: TObject);
	    procedure Action_SIT_NextExecute(Sender: TObject);
	    procedure Action_SIT_CancelExecute(Sender: TObject);
	    procedure Action_SIT_PostExecute(Sender: TObject);
    	procedure Action_SIT_RefreshExecute(Sender: TObject);
    procedure LabeledEdit_TIP_VA_DESCRICAOChange(Sender: TObject);
  	private
    	{ Private declarations }
  	public
    	{ Public declarations }
  	end;

implementation

uses
	UBDODataModule_TiposDeObra, UXXXTypesConstantsAndClasses;

{$R *.dfm}

procedure TBDOForm_TiposDeObra.Action_SIT_CancelExecute(Sender: TObject);
begin
  	inherited;
    TBDODataModule_TiposDeObra(MyDataModule).DBButtonClick_TIP(dbbCancel);
end;

procedure TBDOForm_TiposDeObra.Action_SIT_FirstExecute(Sender: TObject);
begin
  	inherited;
    TBDODataModule_TiposDeObra(MyDataModule).DBButtonClick_TIP(dbbFirst);
end;

procedure TBDOForm_TiposDeObra.Action_SIT_LastExecute(Sender: TObject);
begin
  	inherited;
    TBDODataModule_TiposDeObra(MyDataModule).DBButtonClick_TIP(dbbLast);
end;

procedure TBDOForm_TiposDeObra.Action_SIT_NextExecute(Sender: TObject);
begin
  	inherited;
    TBDODataModule_TiposDeObra(MyDataModule).DBButtonClick_TIP(dbbNext);
end;

procedure TBDOForm_TiposDeObra.Action_SIT_PostExecute(Sender: TObject);
begin
  	inherited;
    TBDODataModule_TiposDeObra(MyDataModule).DBButtonClick_TIP(dbbPost);
end;

procedure TBDOForm_TiposDeObra.Action_SIT_PreviousExecute(Sender: TObject);
begin
  	inherited;
    TBDODataModule_TiposDeObra(MyDataModule).DBButtonClick_TIP(dbbPrevious);
end;

procedure TBDOForm_TiposDeObra.Action_SIT_RefreshExecute(Sender: TObject);
begin
  	inherited;
    TBDODataModule_TiposDeObra(MyDataModule).DBButtonClick_TIP(dbbRefresh);
end;

procedure TBDOForm_TiposDeObra.LabeledEdit_TIP_VA_DESCRICAOChange(Sender: TObject);
begin
    inherited;
    TBDODataModule_TiposDeObra(MyDataModule).LocalizarTipoPorDescricao(LabeledEdit_TIP_VA_DESCRICAO);
end;

end.
