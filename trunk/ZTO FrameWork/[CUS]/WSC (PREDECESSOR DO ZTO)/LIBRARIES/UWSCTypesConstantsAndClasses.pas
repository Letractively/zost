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
    { Descomprime em um arquivo temporário }
    TXXXDataModule.DecompressFile(aNomeDoArquivo
                                 ,aNomeDoArquivo + '.D'
                                 ,nil);

    { Copia o arquivo temporário no arquivo original }
    if not CopyFile(PChar(aNomeDoArquivo + '.D')
                           ,PChar(aNomeDoArquivo)
                           ,False) then
        raise Exception.Create('Não foi possível substituir o arquivo de dados original (' + ExtractFileName(aNomeDoArquivo) + ') por sua versão descomprimida')
    else
        SysUtils.DeleteFile(PChar(aNomeDoArquivo + '.D'));
end;

end.
