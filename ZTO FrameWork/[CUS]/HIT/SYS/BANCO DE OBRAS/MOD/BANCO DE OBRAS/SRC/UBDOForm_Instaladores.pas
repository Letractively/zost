unit UBDOForm_Instaladores;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, Buttons, Mask, DBCtrls, Grids, StdCtrls, ActnList, ExtCtrls,

  UXXXForm_ModuleTabbedTemplate, _StdCtrls, _DBCtrls,

  UCFDBGrid, DBGrids;

type
	TBDOForm_InstaladoresClass = class of TBDOForm_Instaladores;

  	TBDOForm_Instaladores = class(TXXXForm_ModuleTabbedTemplate)
        GroupBox_INS_Filtro: TGroupBox;
        DBGrid_INS: TCFDBGrid;
        GroupBox_INS_Dados: TGroupBox;
        Label_INS_Nome: TLabel;
        DBEdit_INS_VA_NOME: TDBEdit;
        Panel_INS_Layer: TPanel;
        SpeedButton_INS_Primeiro: TSpeedButton;
        SpeedButton_INS_Anterior: TSpeedButton;
        SpeedButton_INS_Proximo: TSpeedButton;
        SpeedButton_INS_Ultimo: TSpeedButton;
        SpeedButton_INS_Inserir: TSpeedButton;
        SpeedButton_INS_Excluir: TSpeedButton;
        SpeedButton_INS_Editar: TSpeedButton;
        SpeedButton_INS_Salvar: TSpeedButton;
        SpeedButton_INS_Cancelar: TSpeedButton;
        SpeedButton_INS_Atualizar: TSpeedButton;
        Action_INS_First: TAction;
        Action_INS_Previous: TAction;
        Action_INS_Next: TAction;
        Action_INS_Last: TAction;
        Action_INS_Refresh: TAction;
        Action_INS_Cancel: TAction;
        Action_INS_Post: TAction;
    LabeledEdit_INS_VA_NOME: TLabeledEdit;
        procedure Action_INS_FirstExecute(Sender: TObject);
        procedure Action_INS_PreviousExecute(Sender: TObject);
        procedure Action_INS_NextExecute(Sender: TObject);
        procedure Action_INS_LastExecute(Sender: TObject);
        procedure Action_INS_RefreshExecute(Sender: TObject);
        procedure Action_INS_CancelExecute(Sender: TObject);
        procedure Action_INS_PostExecute(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure LabeledEdit_INS_VA_NOMEChange(Sender: TObject);
  	private
    	{ Private declarations }
  	public
    	{ Public declarations }
  	end;

implementation

uses
	UBDODataModule_Instaladores, UXXXTypesConstantsAndClasses;

{$R *.dfm}

procedure TBDOForm_Instaladores.Action_INS_CancelExecute(Sender: TObject);
begin
	inherited;
    TBDODataModule_Instaladores(MyDataModule).DBButtonClick_INS(dbbCancel);
end;

procedure TBDOForm_Instaladores.Action_INS_FirstExecute(Sender: TObject);
begin
	inherited;
    TBDODataModule_Instaladores(MyDataModule).DBButtonClick_INS(dbbFirst);
end;

procedure TBDOForm_Instaladores.Action_INS_LastExecute(Sender: TObject);
begin
  	inherited;
    TBDODataModule_Instaladores(MyDataModule).DBButtonClick_INS(dbbLast);
end;

procedure TBDOForm_Instaladores.Action_INS_NextExecute(Sender: TObject);
begin
  	inherited;
    TBDODataModule_Instaladores(MyDataModule).DBButtonClick_INS(dbbNext);
end;

procedure TBDOForm_Instaladores.Action_INS_PostExecute(Sender: TObject);
begin
  	inherited;
    TBDODataModule_Instaladores(MyDataModule).DBButtonClick_INS(dbbPost);
end;

procedure TBDOForm_Instaladores.Action_INS_PreviousExecute(Sender: TObject);
begin
  	inherited;
    TBDODataModule_Instaladores(MyDataModule).DBButtonClick_INS(dbbPrevious);
end;

procedure TBDOForm_Instaladores.Action_INS_RefreshExecute(Sender: TObject);
begin
  	inherited;
    TBDODataModule_Instaladores(MyDataModule).DBButtonClick_INS(dbbRefresh);
end;

procedure TBDOForm_Instaladores.FormShow(Sender: TObject);
begin
  	inherited;
  	if DBGrid_INS.Tag = 0 then
  	begin
    	DBGrid_INS.Width := Succ(DBGrid_INS.Width);
    	DBGrid_INS.Width := Pred(DBGrid_INS.Width);
        DBGrid_INS.Tag := 1;
  	end;
end;

procedure TBDOForm_Instaladores.LabeledEdit_INS_VA_NOMEChange(Sender: TObject);
begin
    inherited;
    TBDODataModule_Instaladores(MyDataModule).LocalizarInstaladorPorNome(LabeledEdit_INS_VA_NOME);
end;

end.
