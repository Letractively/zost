unit Mdl.Lib.ZTODialog_Base;

{ Caixa de diálogo comum. Copyright 2010 / 2011 ZTO Soluções Tecnológicas Ltda. }

interface

uses Classes
   , Controls
   , Forms
   , ZTO.Wizards.FormTemplates.Dialog
   , ExtCtrls
   , ActnList
   , DBActns
   , ImgList;

type
  TDataSetFirst = class(DBActns.TDataSetFirst)
  public
    procedure UpdateTarget(Target: TObject); override;
  end;

  TDataSetPrior = class(DBActns.TDataSetPrior)
  public
    procedure UpdateTarget(Target: TObject); override;
  end;

  TDataSetNext = class(DBActns.TDataSetNext)
  public
    procedure UpdateTarget(Target: TObject); override;
  end;

  TDataSetLast = class(DBActns.TDataSetLast)
  public
    procedure UpdateTarget(Target: TObject); override;
  end;

  TDataSetInsert = class(DBActns.TDataSetInsert)
  public
    procedure ExecuteTarget(Target: TObject); override;
    procedure UpdateTarget(Target: TObject); override;
  end;

  TDataSetDelete = class(DBActns.TDataSetDelete)
  public
    procedure ExecuteTarget(Target: TObject); override;
    procedure UpdateTarget(Target: TObject); override;
  end;

  TDataSetEdit = class(DBActns.TDataSetEdit)
  public
    procedure ExecuteTarget(Target: TObject); override;
  end;

  TDataSetRefresh = class(DBActns.TDataSetRefresh)
  public
    procedure UpdateTarget(Target: TObject); override;
    procedure ExecuteTarget(Target: TObject); override;
  end;

  TDataSetPost = class(DBActns.TDataSetPost)
  public
    procedure ExecuteTarget(Target: TObject); override;
  end;

  TZTODialog_Base = class(TZTODialog)
    Panel_Layer: TPanel;
    ActionList_Dialog: TActionList;
    Action_Fechar: TAction;
    DataSetFirst_Action: TDataSetFirst;
    DataSetPrior_Action: TDataSetPrior;
    DataSetNext_Action: TDataSetNext;
    DataSetLast_Action: TDataSetLast;
    DataSetInsert_Action: TDataSetInsert;
    DataSetDelete_Action: TDataSetDelete;
    DataSetEdit_Action: TDataSetEdit;
    DataSetPost_Action: TDataSetPost;
    DataSetCancel_Action: TDataSetCancel;
    DataSetRefresh_Action: TDataSetRefresh;
    ImageList_Actions: TImageList;
    procedure ZTODialogCloseButtonClick(Sender: TObject);
    procedure Action_FecharExecute(Sender: TObject);
    procedure ZTODialogCloseQuery(Sender: TObject; var CanClose: Boolean);
    procedure ZTODialogClose(Sender: TObject; var Action: TCloseAction);
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

procedure TZTODialog_Base.Action_FecharExecute(Sender: TObject);
begin
  Close;
end;

procedure TZTODialog_Base.ZTODialogClose(Sender: TObject; var Action: TCloseAction);
begin
  TZTODataModule_Base(Owner).DelayedClose;
end;

procedure TZTODialog_Base.ZTODialogCloseButtonClick(Sender: TObject);
begin
  Action_Fechar.Execute;
end;

procedure TZTODialog_Base.ZTODialogCloseQuery(Sender: TObject; var CanClose: Boolean);
begin
  TZTODataModule_Base(Owner).ValidateClose(CanClose);
end;

{ TDataSetFirst }

procedure TDataSetFirst.UpdateTarget(Target: TObject);
begin
  inherited;
  Enabled := (GetDataSet(Target).RecNo > 1) and (GetDataSet(Target).State = dsBrowse);
end;

{ TDataSetPrior }

procedure TDataSetPrior.UpdateTarget(Target: TObject);
begin
  inherited;
  Enabled := (GetDataSet(Target).RecNo > 1) and (GetDataSet(Target).State = dsBrowse);
end;

{ TDataSetNext }

procedure TDataSetNext.UpdateTarget(Target: TObject);
begin
  inherited;
  Enabled := (GetDataSet(Target).RecNo < DataSource.Tag) and (GetDataSet(Target).State = dsBrowse);
end;

{ TDataSetLast }

procedure TDataSetLast.UpdateTarget(Target: TObject);
begin
  inherited;
  Enabled := (GetDataSet(Target).RecNo < DataSource.Tag) and (GetDataSet(Target).State = dsBrowse);
end;

{ TDataSetRefresh }

procedure TDataSetRefresh.ExecuteTarget(Target: TObject);
begin
  inherited;
  DataSource.Tag := GetDataSet(Target).RecordCount;
end;

procedure TDataSetRefresh.UpdateTarget(Target: TObject);
begin
  inherited;
  Enabled := GetDataSet(Target).State = dsBrowse;

  if Tag = 0 then
  begin
    DataSource.Tag := GetDataSet(Target).RecordCount;
    Tag := 1;
  end;
end;

{ TDataSetInsert }

procedure TDataSetInsert.ExecuteTarget(Target: TObject);
begin
  if Assigned(TZTODialog_Base(Owner).ZTOProperties.FocusControlOnInsert) then
    TZTODialog_Base(Owner).ZTOProperties.FocusControlOnInsert.SetFocus;

  inherited;
end;

procedure TDataSetInsert.UpdateTarget(Target: TObject);
begin
  inherited;
  Enabled := GetDataSet(Target).State = dsBrowse;
end;

{ TDataSetDelete }

procedure TDataSetDelete.ExecuteTarget(Target: TObject);
begin
  inherited;
  DataSource.Tag := GetDataSet(Target).RecordCount;
end;

procedure TDataSetDelete.UpdateTarget(Target: TObject);
begin
  inherited;
  Enabled := GetDataSet(Target).State = dsBrowse;
end;

{ TDataSetEdit }

procedure TDataSetEdit.ExecuteTarget(Target: TObject);
begin
  if Assigned(TZTODialog_Base(Owner).ZTOProperties.FocusControlOnEdit) then
    TZTODialog_Base(Owner).ZTOProperties.FocusControlOnEdit.SetFocus;

  inherited;
end;

{ TDataSetPost }

procedure TDataSetPost.ExecuteTarget(Target: TObject);
begin
  inherited;
  DataSource.Tag := GetDataSet(Target).RecordCount;
end;

end.
