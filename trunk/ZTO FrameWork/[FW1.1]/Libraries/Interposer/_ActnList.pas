unit _ActnList;

interface

uses
	ActnList, ComCtrls;

type
    TEnableMode = (emEnable, emDisable, emSelective);

	///<author>Carlos Feitoza Filho</author>
    ///    Esta classe mediadora introduz um comportamento padrão no método
    ///    "Execute" de qualquer TAction criado abaixo desta unit
    TAction = class (ActnList.TAction)
    private
    	FAllowed: Boolean;
        function GetFullyQualifiedName: String;
    public
		function Execute: Boolean; override;
        procedure SetPermission(aAllow: Boolean);
        property Allowed: Boolean read FAllowed;
        property FullyQualifiedName: String read GetFullyQualifiedName;
    end;

	///<author>Carlos Feitoza Filho</author>
    ///    Esta classe mediadora introduz procedures adicionais na classe
    ///    TActionList
    TActionList = class (ActnList.TActionList)
    public
    	procedure ToggleEnabledStatus(aEnabledMode: TEnableMode; const aProgressBar: TProgressBar = nil);
    end;

implementation

uses
	UXXXDataModule, Dialogs, SysUtils;

{ TAction }

function TAction.Execute: Boolean;
begin
	if Owner is TXXXDataModule then
		TXXXDataModule(Owner).ValidateThisAction(TXXXDataModule(Owner).DataModuleMain.ZConnections[0].Connection, Self);
    Result := inherited Execute;
end;

function TAction.GetFullyQualifiedName: String;
begin
    Result := Owner.Name + '.' + Self.Name;
end;

procedure TAction.SetPermission(aAllow: Boolean);
begin
    inherited Enabled := aAllow;
    FAllowed := aAllow;
end;

{ TActionList }

procedure TActionList.ToggleEnabledStatus(aEnabledMode: TEnableMode; const aProgressBar: TProgressBar = nil);
var
  	i: Integer;
begin
	for i := 0 to Pred(ActionCount) do
    	try
	        case aEnabledMode of
    	        emEnable: TAction(Actions[i]).Enabled := True;
        	    emDisable: TAction(Actions[i]).Enabled := False;
            	emSelective: TAction(Actions[i]).SetPermission(TXXXDataModule(Owner).HasPermission(TXXXDataModule(Owner).DataModuleMain.ZConnections[0].Connection,AnsiString(UpperCase(Owner.Name + '.' + Actions[i].Name))));
	        end;
        finally
            if Assigned(aProgressBar) then
                aProgressBar.StepIt;
        end;
end;

end.
