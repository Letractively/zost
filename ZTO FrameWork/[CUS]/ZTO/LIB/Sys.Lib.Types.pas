unit Sys.Lib.Types;

interface

uses Classes;

type
  TScriptPart = class (TCollectionItem)
  private
    FDelimiter: String;
    FScript: String;
  public
    constructor Create(Collection: TCollection); override;
    property Delimiter: String read FDelimiter write FDelimiter;
    property Script: String read FScript write FScript;
  end;

  TScriptParts = class (TCollection)
  private
    function GetScriptPart(i: Cardinal): TScriptPart;
    function GetLast: TScriptPart;
  public
    function Add: TScriptPart;
    property Part[i: Cardinal]: TScriptPart read GetScriptPart; default;
    property Last: TScriptPart read GetLast;
  end;

  TQueryEvent = (qeUnknown, qeBeforeCancel, qeBeforeClose, qeBeforeDelete,
                 qeBeforeEdit, qeBeforeInsert, qeBeforeOpen, qeBeforePost,
                 qeBeforeRefresh, qeBeforeScroll, qeAfterCancel, qeAfterClose,
                 qeAfterDelete, qeAfterEdit, qeAfterInsert, qeAfterOpen,
                 qeAfterPost, qeAfterRefresh, qeAfterScroll);

implementation

{ TScriptPart }

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

end.
