unit UMBRTypesConstantsAndClasses;

interface

uses
    UXXXTypesConstantsAndClasses, Classes;

type
    TMBRConfigurations = class(TXXXConfigurations)
    private
    public
        constructor Create(aOwner: TComponent); override;
        destructor Destroy; override;
        procedure SalvarConfiguracoes;
    published

    end;

implementation

const
    CONFIG_FILENAME = '\CONFIG.DAT';

{ TMBRConfigurations }

constructor TMBRConfigurations.Create(aOwner: TComponent);
begin
    inherited;
    { Valores padr�o customizados }

    LoadFromBinaryFile(CurrentDir + CONFIG_FILENAME);
end;

destructor TMBRConfigurations.Destroy;
begin
    SaveToBinaryFile(CurrentDir + CONFIG_FILENAME);
    { Destrui��o de coisas aqui }
    inherited;
end;

procedure TMBRConfigurations.SalvarConfiguracoes;
begin
    SaveToBinaryFile(CurrentDir + CONFIG_FILENAME);
end;

end.
