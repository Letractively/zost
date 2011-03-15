unit UBDOForm_Situacoes;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ActnList, ExtCtrls, StdCtrls, Buttons, DBCtrls, Mask, Grids,

  UXXXForm_ModuleTabbedTemplate, UCFDBGrid, _StdCtrls, _DBCtrls, DBGrids;

type
	TBDOForm_SituacoesClass = class of TBDOForm_Situacoes;

  	TBDOForm_Situacoes = class(TXXXForm_ModuleTabbedTemplate)
        DBGrid_SIT: TCFDBGrid;
        GroupBox_SIT_DadosDaSituacao: TGroupBox;
        Label_SIT_Descricao: TLabel;
        DBEdit_SIT_VA_DESCRICAO: TDBEdit;
        DBRadioGroup_SIT_BO_EXPIRAVEL: TDBRadioGroup;
        Panel_SIT_Layer: TPanel;
        SpeedButton_SIT_Primeiro: TSpeedButton;
        SpeedButton_SIT_Anterior: TSpeedButton;
        SpeedButton_SIT_Proximo: TSpeedButton;
        SpeedButton_SIT_Ultimo: TSpeedButton;
        SpeedButton_SIT_Inserir: TSpeedButton;
        SpeedButton_SIT_Excluir: TSpeedButton;
        SpeedButton_SIT_Editar: TSpeedButton;
        SpeedButton_SIT_Salvar: TSpeedButton;
        SpeedButton_SIT_Cancelar: TSpeedButton;
        SpeedButton_SIT_Atualizar: TSpeedButton;
        GroupBox_SIT_Filtro: TGroupBox;
        Action_SIT_Previous: TAction;
        Action_SIT_First: TAction;
        Action_SIT_Next: TAction;
        Action_SIT_Last: TAction;
        Action_SIT_Cancel: TAction;
        Action_SIT_Post: TAction;
        Action_SIT_Refresh: TAction;
    	DBEdit_SIT_TI_DIASPARAEXPIRACAO: TDBEdit;
	    Label_SIT_TI_DIASPARAEXPIRACAO: TLabel;
        LabeledEdit_SIT_VA_DESCRICAO: TLabeledEdit;
        DBRadioGroup_SIT_BO_JUSTIFICAVEL: TDBRadioGroup;
        procedure Action_SIT_FirstExecute(Sender: TObject);
        procedure Action_SIT_PreviousExecute(Sender: TObject);
        procedure Action_SIT_NextExecute(Sender: TObject);
        procedure Action_SIT_LastExecute(Sender: TObject);
        procedure Action_SIT_CancelExecute(Sender: TObject);
        procedure Action_SIT_PostExecute(Sender: TObject);
        procedure Action_SIT_RefreshExecute(Sender: TObject);
    	procedure DBRadioGroup_SIT_BO_EXPIRAVELChange(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure LabeledEdit_SIT_VA_DESCRICAOChange(Sender: TObject);
  	private

    	{ Private declarations }
  	public
    	{ Public declarations }
  	end;

implementation

uses
	UBDODataModule_Situacoes, UXXXTypesConstantsAndClasses;

{$R *.dfm}

procedure TBDOForm_Situacoes.Action_SIT_CancelExecute(Sender: TObject);
begin
  	inherited;
    { Isso foi necessário pois caso o foco esteja no DBRadioGroup, não é
    possível cancelar a operação (bug do delphi) }
   	DBEdit_SIT_VA_DESCRICAO.SetFocus;
	TBDODataModule_Situacoes(MyDataModule).DBButtonClick_SIT(dbbCancel)
end;

procedure TBDOForm_Situacoes.Action_SIT_FirstExecute(Sender: TObject);
begin
  	inherited;
    TBDODataModule_Situacoes(MyDataModule).DBButtonClick_SIT(dbbFirst);
end;

procedure TBDOForm_Situacoes.Action_SIT_LastExecute(Sender: TObject);
begin
  	inherited;
    TBDODataModule_Situacoes(MyDataModule).DBButtonClick_SIT(dbbLast);
end;

procedure TBDOForm_Situacoes.Action_SIT_NextExecute(Sender: TObject);
begin
  	inherited;
    TBDODataModule_Situacoes(MyDataModule).DBButtonClick_SIT(dbbNext);
end;

procedure TBDOForm_Situacoes.Action_SIT_PostExecute(Sender: TObject);
begin
  	inherited;
    TBDODataModule_Situacoes(MyDataModule).DBButtonClick_SIT(dbbPost);
end;

procedure TBDOForm_Situacoes.Action_SIT_PreviousExecute(Sender: TObject);
begin
  	inherited;
    TBDODataModule_Situacoes(MyDataModule).DBButtonClick_SIT(dbbPrevious);
end;

procedure TBDOForm_Situacoes.Action_SIT_RefreshExecute(Sender: TObject);
begin
  	inherited;
    TBDODataModule_Situacoes(MyDataModule).DBButtonClick_SIT(dbbRefresh);
end;

procedure TBDOForm_Situacoes.DBRadioGroup_SIT_BO_EXPIRAVELChange(Sender: TObject);
begin
  	inherited;
  	DBEdit_SIT_TI_DIASPARAEXPIRACAO.Enabled := DBRadioGroup_SIT_BO_EXPIRAVEL.ItemIndex = 0;
end;

procedure TBDOForm_Situacoes.FormShow(Sender: TObject);
begin
  	inherited;
  	if DBGrid_SIT.Tag = 0 then
  	begin
    	DBGrid_SIT.Width := Succ(DBGrid_SIT.Width);
    	DBGrid_SIT.Width := Pred(DBGrid_SIT.Width);
        DBGrid_SIT.Tag := 1;
  	end;
end;

procedure TBDOForm_Situacoes.LabeledEdit_SIT_VA_DESCRICAOChange(Sender: TObject);
begin
    inherited;
    TBDODataModule_Situacoes(MyDataModule).LocalizarSituacaoPorDescricao(LabeledEdit_SIT_VA_DESCRICAO);
end;

end.
