unit Mdl.Lib.ZTOSDIForm_Base;

{ Formulário SDI comum. Copyright 2010 / 2011 ZTO Soluções Tecnológicas Ltda. }

interface

uses
  Classes, Controls, Forms,
  ZTO.Wizards.FormTemplates.SDIForm, ActnList, DBActns, ImgList;

type
  TZTOSDIForm_Base = class(TZTOSDIForm)
    ActionList_SDIForm: TActionList;
    Action_Fechar: TAction;
    ImageList_SDIForm: TImageList;
    DataSetFirst: TDataSetFirst;
    DataSetPrior: TDataSetPrior;
    DataSetNext: TDataSetNext;
    DataSetLast: TDataSetLast;
    DataSetInsert: TDataSetInsert;
    DataSetDelete: TDataSetDelete;
    DataSetEdit: TDataSetEdit;
    DataSetPost: TDataSetPost;
    DataSetCancel: TDataSetCancel;
    DataSetRefresh: TDataSetRefresh;
    procedure ZTOSDIFormClose(Sender: TObject; var Action: TCloseAction);
    procedure Action_FecharExecute(Sender: TObject);
    procedure ZTOSDIFormCloseQuery(Sender: TObject; var CanClose: Boolean);
  private
    { Declarações privadas }
  protected
    { Declarações protegidas }
  public
    { Declarações públicas }
  end;

implementation

{$R *.dfm}

uses Mdl.Lib.ZTODataModule_Base;

procedure TZTOSDIForm_Base.Action_FecharExecute(Sender: TObject);
begin
  Close;
end;

procedure TZTOSDIForm_Base.ZTOSDIFormClose(Sender: TObject; var Action: TCloseAction);
begin
  if Assigned(Owner) then
    TZTODataModule_Base(Owner).DelayedClose;

  Action := caFree;
end;

procedure TZTOSDIForm_Base.ZTOSDIFormCloseQuery(Sender: TObject; var CanClose: Boolean);
begin
  if Assigned(Owner) then
    TZTODataModule_Base(Owner).ValidateClose(CanClose);
end;

end.
