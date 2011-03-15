unit UWSCTypesConstantsAndClasses;

interface

uses
    SysUtils;

type
    TWSCCustomer = (wcUnknown,wcWSC,wcHitachi);

procedure DescomprimirArquivo(const aNomeDoArquivo: TFileName);

implementation

uses
    UXXXDataModule, Windows;

procedure DescomprimirArquivo(const aNomeDoArquivo: TFileName);
begin
    { Descomprime em um arquivo tempor�rio }
    TXXXDataModule.DecompressFile(aNomeDoArquivo
                                 ,aNomeDoArquivo + '.D'
                                 ,nil);

    { Copia o arquivo tempor�rio no arquivo original }
    if not CopyFile(PChar(aNomeDoArquivo + '.D')
                           ,PChar(aNomeDoArquivo)
                           ,False) then
        raise Exception.Create('N�o foi poss�vel substituir o arquivo de dados original (' + ExtractFileName(aNomeDoArquivo) + ') por sua vers�o descomprimida')
    else
        SysUtils.DeleteFile(PChar(aNomeDoArquivo + '.D'));
end;

end.
