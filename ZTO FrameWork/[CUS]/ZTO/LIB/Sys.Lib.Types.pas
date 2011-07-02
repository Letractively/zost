unit Sys.Lib.Types;

interface

uses Classes
   , DBActns;

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

//  TScriptPart = class (TCollectionItem)
//  private
//    FDelimiter: String;
//    FScript: String;
//  public
//    constructor Create(Collection: TCollection); override;
//    property Delimiter: String read FDelimiter write FDelimiter;
//    property Script: String read FScript write FScript;
//  end;

//  TScriptParts = class (TCollection)
//  private
//    function GetScriptPart(i: Cardinal): TScriptPart;
//    function GetLast: TScriptPart;
//  public
//    function Add: TScriptPart;
//    property Part[i: Cardinal]: TScriptPart read GetScriptPart; default;
//    property Last: TScriptPart read GetLast;
//  end;

  TQueryEvent = (qeUnknown, qeBeforeCancel, qeBeforeClose, qeBeforeDelete,
                 qeBeforeEdit, qeBeforeInsert, qeBeforeOpen, qeBeforePost,
                 qeBeforeRefresh, qeBeforeScroll, qeAfterCancel, qeAfterClose,
                 qeAfterDelete, qeAfterEdit, qeAfterInsert, qeAfterOpen,
                 qeAfterPost, qeAfterRefresh, qeAfterScroll);

implementation

uses DB
   , ZTO.Wizards.FormTemplates.Dialog;

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
  if Assigned(TZTODialog(Owner).ZTOProperties.FocusControlOnInsert) then
    TZTODialog(Owner).ZTOProperties.FocusControlOnInsert.SetFocus;

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
  if Assigned(TZTODialog(Owner).ZTOProperties.FocusControlOnEdit) then
    TZTODialog(Owner).ZTOProperties.FocusControlOnEdit.SetFocus;

  inherited;
end;

{ TDataSetPost }

procedure TDataSetPost.ExecuteTarget(Target: TObject);
begin
  inherited;
  DataSource.Tag := GetDataSet(Target).RecordCount;
end;

{ TScriptPart }
(*
constructor TScriptPart.Create(Collection: TCollection);
begin
  inherited;
  FScript    := '';
  FDelimiter := ';';
end;

{ TScriptParts }

function TScriptParts.Add: TScriptPart;
begin
	Result := TScriptPart(inherited Add);
end;

function TScriptParts.GetLast: TScriptPart;
begin
	if Count = 0 then
    Result := nil
  else
   	Result := GetScriptPart(Pred(Count));
end;

function TScriptParts.GetScriptPart(i: Cardinal): TScriptPart;
begin
	Result := TScriptPart(inherited Items[i]);
end;
*)
end.
