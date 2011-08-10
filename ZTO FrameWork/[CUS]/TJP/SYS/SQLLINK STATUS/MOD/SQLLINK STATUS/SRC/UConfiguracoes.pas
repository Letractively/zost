unit UConfiguracoes;

interface

uses Classes
   , ZTO.Win32.Rtl.Common.Classes;

type
  TDBOption = class(TCollectionItem)
  private
    FIDConexao: String;
  published
    property IDConexao: String read FIDConexao write FIDConexao;
  end;

  TOracleOption = class(TDBOption)
  private
    FUsuario: String;
    FSenha: String;
    FTNS: String;
    FDataBase: String;
  published
    property Usuario: String read FUsuario write FUsuario;
    property Senha: String read FSenha write FSenha;
    property TNS: String read FTNS write FTNS;
    property Database: String read FDataBase write FDataBase;
  end;

  TSybaseOption = class(TDBOption)
  private
    FSenha: String;
    FDataBase: String;
    FUsuario: String;
    FServerName: String;
  published
    property Usuario: String read FUsuario write FUsuario;
    property Senha: String read FSenha write FSenha;
    property ServerName: String read FServerName write FServerName;
    property Database: String read FDataBase write FDataBase;
  end;

  TOracleOptions = class(TCollection);

  TSybaseOptions = class(TCollection);

  TConfiguracoes = class(TObjectFile)
  private
    FOracleOptions: TOracleOptions;
    FSybaseOptions: TSybaseOptions;
  public
    constructor Create(aOwner: TComponent); override;
    destructor Destroy; override;
  published
    property OracleOptions: TOracleOptions read FOracleOptions write FOracleOptions;
    property SybaseOptions: TSybaseOptions read FSybaseOptions write FSybaseOptions;
  end;

implementation

{ TConfiguracoes }

constructor TConfiguracoes.Create;
begin
  inherited;
  FOracleOptions := TOracleOptions.Create(TOracleOption);
  FSybaseOptions := TSybaseOptions.Create(TSybaseOption);
end;

destructor TConfiguracoes.Destroy;
begin
  FSybaseOptions.Free;
  FOracleOptions.Free;
  inherited;
end;

end.
