unit Mdl.Lib.ZTODialog_Base;

{ Caixa de diálogo comum. Copyright 2010 / 2011 ZTO Soluções Tecnológicas Ltda. }

interface

uses Classes
   , Controls
   , Forms
   , ZTO.Wizards.FormTemplates.Dialog
   , ExtCtrls
   , ActnList
   , ImgList;

type
  TZTODialog_Base = class(TZTODialog)
    ActionList: TActionList;
    Action_Fechar: TAction;
    Action_Ok: TAction;
    Action_Cancelar: TAction;
    procedure ZTODialogCloseButtonClick(Sender: TObject);
    procedure Action_FecharExecute(Sender: TObject);
    procedure ZTODialogCloseQuery(Sender: TObject; var CanClose: Boolean);
    procedure ZTODialogClose(Sender: TObject; var Action: TCloseAction);
    procedure ZTODialogOkButtonClick(Sender: TObject);
    procedure ZTODialogCancelButtonClick(Sender: TObject);
    procedure Action_OkExecute(Sender: TObject);
    procedure Action_CancelarExecute(Sender: TObject);
  private
    { Declarações privadas }
  protected
    { Declarações protegidas }
  public
    { Declarações públicas }
  end;

implementation

uses Mdl.Lib.ZTODataModule_Base
   , DB;

{$R *.dfm}

procedure TZTODialog_Base.Action_CancelarExecute(Sender: TObject);
begin
  ModalResult := mrCancel;
end;

procedure TZTODialog_Base.Action_FecharExecute(Sender: TObject);
begin
  if fsModal in FormState then
    ModalResult := mrClose
  else
    Close;
end;

procedure TZTODialog_Base.Action_OkExecute(Sender: TObject);
begin
  if fsModal in FormState then
    ModalResult := mrOk
  else
    Close;
end;

procedure TZTODialog_Base.ZTODialogCancelButtonClick(Sender: TObject);
begin
  Action_Cancelar.Execute;
end;

procedure TZTODialog_Base.ZTODialogClose(Sender: TObject; var Action: TCloseAction);
begin
  if Assigned(Owner) then
    TZTODataModule_Base(Owner).DelayedClose;
end;

procedure TZTODialog_Base.ZTODialogCloseButtonClick(Sender: TObject);
begin
  Action_Fechar.Execute;
end;

procedure TZTODialog_Base.ZTODialogCloseQuery(Sender: TObject; var CanClose: Boolean);
begin
  if Assigned(Owner) then
    TZTODataModule_Base(Owner).ValidateClose(CanClose);
end;

procedure TZTODialog_Base.ZTODialogOkButtonClick(Sender: TObject);
begin
  Action_Ok.Execute;
end;

end.
