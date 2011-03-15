unit UMBRDataModule;

interface

uses
    Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
    Dialogs, ActnList,

    UXXXDataModule,

    UMBRTypesConstantsAndClasses;

type
    TMBRDataModule = class(TXXXDataModule)
    private
        { Private declarations }
        function GetConfigurations: TMBRConfigurations;
    protected
        property Configurations: TMBRConfigurations read GetConfigurations;
    public
        { Public declarations }
    end;

implementation

{$R *.dfm}

{ TBDIDataModule }

function TMBRDataModule.GetConfigurations: TMBRConfigurations;
begin
    Result := TMBRConfigurations(inherited Configurations);
end;

end.
