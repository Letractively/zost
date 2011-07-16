unit ZTO.Components.WebApiWrappers.Register;

interface

procedure Register;

implementation

uses Classes, ZTO.Components.WebApiWrappers.Twitter;

procedure Register;
begin
  RegisterComponents('ZTO Web API Wrappers',[TTwitter]);
end;

end.
