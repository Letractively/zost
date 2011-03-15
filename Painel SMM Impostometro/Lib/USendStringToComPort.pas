unit USendStringToComPort;

interface

	function SendStringToComPort(aStringToSend: String; aComPort: ShortString; aBaudRate, aBits: Integer; aParity: Char; aStopBits: Integer; aUseSoftwareControlFlow, aUseHardwareControlFlow: Boolean): Boolean;

implementation

uses
	synaser;

function SendStringToComPort(aStringToSend: String; aComPort: ShortString; aBaudRate, aBits: Integer; aParity: Char; aStopBits: Integer; aUseSoftwareControlFlow, aUseHardwareControlFlow: Boolean): Boolean;
begin
	with TBlockSerial.Create do
        try
        	Connect(aComPort);
            Config(aBaudRate,aBits,aParity,aStopBits,aUseSoftwareControlFlow,aUseHardwareControlFlow);
            SendString(aStringToSend);
            Result := LastError = 0;
        finally
        	Free;
        end;
end;

end.
