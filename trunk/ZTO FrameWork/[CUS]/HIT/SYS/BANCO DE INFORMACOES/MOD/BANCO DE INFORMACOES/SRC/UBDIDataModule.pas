unit UBDIDataModule;

interface

uses
    Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
    Dialogs, UXXXDataModule, ActnList, UBDITypesConstantsAndClasses;

type
    TBDIDataModule = class(TXXXDataModule)
    private
        { Private declarations }
        function GetConfigurations: TBDIConfigurations;
    protected
        property Configurations: TBDIConfigurations read GetConfigurations;
    public
        { Public declarations }
    end;

implementation

{$R *.dfm}

{ TBDIDataModule }

function TBDIDataModule.GetConfigurations: TBDIConfigurations;
begin
    Result := TBDIConfigurations(inherited Configurations);
end;

end.
