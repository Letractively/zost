unit Mdl.Lib.Configuracoes;

interface

uses Classes
   , ZTO.Win32.Rtl.Common.Classes
   , ZTO.Crypt.Types
   , ZDbcIntfs;

type
  TConfiguracoes = class(TObjectFile)
  private
    FBancoConfigurado: Boolean;
    FAcessoConfigurado: Boolean;
    FDBProtocolo:  String;
    FDBIsolamentoTransacional: TZTransactIsolationLevel;
    FDBHost: String;
    FDBPorta: Word;
    FDBEsquema: String;
    FDBSenha: String;
    FDBUsuario: String;
    FTabelaDeUsuarios: String;
    FCampoChave: String;
    FCampoNomeReal: String;
    FCampoNomeDeUsuario: String;
    FCampoSenha: String;
    FAlgoritmoDeCriptografia: THashAlgorithm;
    FUltimoLogin: String;
    FUltimoID: Cardinal;
  public
    constructor Create(aOwner: TComponent); override;
  published
    property BancoConfigurado: Boolean read FBancoConfigurado write FBancoConfigurado default False;
    property AcessoConfigurado: Boolean read FAcessoConfigurado write FAcessoConfigurado default False;
    property UltimoLogin: String read FUltimoLogin write FUltimoLogin;
    property UltimoID: Cardinal read FUltimoID write FUltimoID;
    property DBProtocolo: String read FDBProtocolo write FDBProtocolo;
    property DBIsolamentoTransacional: TZTransactIsolationLevel read FDBIsolamentoTransacional write FDBIsolamentoTransacional default tiReadCommitted;
    property DBHost: String read FDBHost write FDBHost;
    property DBPorta: Word read FDBPorta write FDBPorta;
    property DBEsquema: String read FDBEsquema write FDBEsquema;
    property DBUsuario: String read FDBUsuario write FDBUsuario;
    property DBSenha: String read FDBSenha write FDBSenha;
    property TabelaDeUsuarios: String read FTabelaDeUsuarios write FTabelaDeUsuarios;
    property CampoChave: String read FCampoChave write FCampoChave;
    property CampoNomeReal: String read FCampoNomeReal write FCampoNomeReal;
    property CampoNomeDeUsuario: String read FCampoNomeDeUsuario write FCampoNomeDeUsuario;
    property CampoSenha: String read FCampoSenha write FCampoSenha;
    property AlgoritmoDeCriptografia: THashAlgorithm read FAlgoritmoDeCriptografia write FAlgoritmoDeCriptografia default haMd5;
  end;

implementation

{ TConfiguracoes }

constructor TConfiguracoes.Create(aOwner: TComponent);
begin
  inherited;
  FBancoConfigurado := False;
  FAcessoConfigurado := False;
  FDBProtocolo := 'mysql-5';
  FDBIsolamentoTransacional := tiReadCommitted;
  FTabelaDeUsuarios := 'USUARIOS';
  FCampoChave := 'BI_USUARIOS_ID';
  FCampoNomeReal := 'VA_NOME';
  FCampoNomeDeUsuario := 'VA_LOGIN';
  FCampoSenha := 'VA_SENHA';
  FAlgoritmoDeCriptografia := haMd5;
end;

end.
