unit UBDOForm_Projetistas;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, Buttons, Mask, DBCtrls, Grids, StdCtrls, ActnList, ExtCtrls,

  UXXXForm_ModuleTabbedTemplate, _StdCtrls, _DBCtrls,

  UCFDBGrid, DBGrids;

type
	TBDOForm_ProjetistasClass = class of TBDOForm_Projetistas;

  	TBDOForm_Projetistas = class(TXXXForm_ModuleTabbedTemplate)
        GroupBox_PRJ_Filtro: TGroupBox;
    LabeleEdit_PRJ_VA_NOME: TLabeledEdit;
        DBGrid_PRJ: TCFDBGrid;
        GroupBox_PRJ_Dados: TGroupBox;
        Label_PRJ_Nome: TLabel;
        DBEdit_PRJ_VA_NOME: TDBEdit;
        Panel_PRJ_Layer: TPanel;
        SpeedButton_PRJ_Primeiro: TSpeedButton;
        SpeedButton_PRJ_Anterior: TSpeedButton;
        SpeedButton_PRJ_Proximo: TSpeedButton;
        SpeedButton_PRJ_Ultimo: TSpeedButton;
        SpeedButton_PRJ_Inserir: TSpeedButton;
        SpeedButton_PRJ_Excluir: TSpeedButton;
        SpeedButton_PRJ_Editar: TSpeedButton;
        SpeedButton_PRJ_Salvar: TSpeedButton;
        SpeedButton_PRJ_Cancelar: TSpeedButton;
        SpeedButton_PRJ_Atualizar: TSpeedButton;
	    Action_PRJ_First: TAction;
    	Action_PRJ_Previous: TAction;
	    Action_PRJ_Next: TAction;
    	Action_PRJ_Last: TAction;
	    Action_PRJ_Cancel: TAction;
    	Action_PRJ_Post: TAction;
	    Action_PRJ_Refresh: TAction;
//	    procedure FormShow(Sender: TObject);
        procedure Action_PRJ_CancelExecute(Sender: TObject);
	    procedure Action_PRJ_FirstExecute(Sender: TObject);
    	procedure Action_PRJ_PreviousExecute(Sender: TObject);
	    procedure Action_PRJ_NextExecute(Sender: TObject);
    	procedure Action_PRJ_LastExecute(Sender: TObject);
	    procedure Action_PRJ_RefreshExecute(Sender: TObject);
    	procedure Action_PRJ_PostExecute(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure LabeleEdit_PRJ_VA_NOMEChange(Sender: TObject);
    private
    	{ Private declarations }
  	public
    	{ Public declarations }
  	end;

implementation

uses
	UBDODataModule_Projetistas, UXXXTypesConstantsAndClasses;

{$R *.dfm}

procedure TBDOForm_Projetistas.Action_PRJ_CancelExecute(Sender: TObject);
begin
	inherited;
    TBDODataModule_Projetistas(MyDataModule).DBButtonClick_PRJ(dbbCancel);
end;

procedure TBDOForm_Projetistas.Action_PRJ_FirstExecute(Sender: TObject);
begin
	inherited;
    TBDODataModule_Projetistas(MyDataModule).DBButtonClick_PRJ(dbbFirst);
end;

procedure TBDOForm_Projetistas.Action_PRJ_LastExecute(Sender: TObject);
begin
  	inherited;
    TBDODataModule_Projetistas(MyDataModule).DBButtonClick_PRJ(dbbLast);
end;

procedure TBDOForm_Projetistas.Action_PRJ_NextExecute(Sender: TObject);
begin
  	inherited;
    TBDODataModule_Projetistas(MyDataModule).DBButtonClick_PRJ(dbbNext);
end;

procedure TBDOForm_Projetistas.Action_PRJ_PostExecute(Sender: TObject);
begin
  	inherited;
    TBDODataModule_Projetistas(MyDataModule).DBButtonClick_PRJ(dbbPost);
end;

procedure TBDOForm_Projetistas.Action_PRJ_PreviousExecute(Sender: TObject);
begin
  	inherited;
    TBDODataModule_Projetistas(MyDataModule).DBButtonClick_PRJ(dbbPrevious);
end;

procedure TBDOForm_Projetistas.Action_PRJ_RefreshExecute(Sender: TObject);
begin
  	inherited;
    TBDODataModule_Projetistas(MyDataModule).DBButtonClick_PRJ(dbbRefresh);
end;

procedure TBDOForm_Projetistas.LabeleEdit_PRJ_VA_NOMEChange(Sender: TObject);
begin
    inherited;
    TBDODataModule_Projetistas(MyDataModule).LocalizarProjetistaPorNome(LabeleEdit_PRJ_VA_NOME);
end;

procedure TBDOForm_Projetistas.FormShow(Sender: TObject);
begin
  	inherited;
  	if DBGrid_PRJ.Tag = 0 then
  	begin
    	DBGrid_PRJ.Width := Succ(DBGrid_PRJ.Width);
    	DBGrid_PRJ.Width := Pred(DBGrid_PRJ.Width);
        DBGrid_PRJ.Tag := 1;
  	end;
end;

//procedure TForm_Projetistas.FormShow(Sender: TObject);
//begin
//  	inherited;
//    TDataModule_Projetistas(DataModule).DoDataChange(TDataModule_Projetistas(DataModule).DataSource_PRJ,nil);
//end;

end.
