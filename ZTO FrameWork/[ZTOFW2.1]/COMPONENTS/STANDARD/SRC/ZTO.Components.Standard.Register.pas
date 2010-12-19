unit ZTO.Components.Standard.Register;

interface

procedure Register;

implementation

uses Classes, ZTO.Components.Standard.HotSpots;

procedure Register;
begin
  RegisterComponents('ZTO Standard',[THotSpotSocket,THotSpotPlug]);
end;

end.
