unit UXXXForm_AddEntity;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ActnList, ExtCtrls, StdCtrls, Buttons,

  UXXXForm_DialogTemplate;
  
type
  	TXXXForm_AddEntity = class(TXXXForm_DialogTemplate)
	    Label_Description: TLabel;
    	Bevel_HorizontalLine: TBevel;
    	ListBox_EntidadesSelecionadas: TListBox;
	    Button_RemoveSelectedEntities: TButton;
    	Button_ClearList: TButton;
	    BitBtn_RegisterActions: TBitBtn;
    	BitBtn_Cancel: TBitBtn;
	    Action_RemoveSelectedEntities: TAction;
    	Action_ClearList: TAction;
	    Action_Register: TAction;
    	Action_Cancel: TAction;
	    procedure Action_RemoveSelectedEntitiesExecute(Sender: TObject);
    	procedure FormCreate(Sender: TObject);
	    procedure Action_RegisterExecute(Sender: TObject);
    	procedure Action_ClearListExecute(Sender: TObject);
	    procedure FormDestroy(Sender: TObject);
    	procedure Action_CancelExecute(Sender: TObject);
  	private
    	{ Private declarations }
  	public
    	{ Public declarations }
  	end;

implementation

uses
	UXXXDataModule_AddEntity;

{$R *.dfm}

procedure TXXXForm_AddEntity.Action_CancelExecute(Sender: TObject);
begin
  	inherited;
    Close;
end;

procedure TXXXForm_AddEntity.Action_ClearListExecute(Sender: TObject);
begin
  	inherited;
	ListBox_EntidadesSelecionadas.Clear;
end;

procedure TXXXForm_AddEntity.Action_RegisterExecute(Sender: TObject);
begin
    TXXXDataModule_AddEntity(CreateParameters.MyDataModule).RegisterEntities(ListBox_EntidadesSelecionadas.Items);
end;

procedure TXXXForm_AddEntity.Action_RemoveSelectedEntitiesExecute(Sender: TObject);
begin
  	inherited;
  	if ListBox_EntidadesSelecionadas.ItemIndex <> -1 then
    	ListBox_EntidadesSelecionadas.DeleteSelected;
end;

procedure TXXXForm_AddEntity.FormCreate(Sender: TObject);
begin
  	inherited;
  	(* Habilita temporariamente os controles para que possa ser possível acessá-los
  	para dar permissões *)
    TXXXDataModule_AddEntity(CreateParameters.MyDataModule).DataModuleMain.ApplicationActionsEnabled := True;
end;

procedure TXXXForm_AddEntity.FormDestroy(Sender: TObject);
begin
	inherited;
    TXXXDataModule_AddEntity(CreateParameters.MyDataModule).ApplySecurityPolicies(CreateParameters.MyDataModule.DataModuleMain.ZConnections[0].Connection);
end;

end.
