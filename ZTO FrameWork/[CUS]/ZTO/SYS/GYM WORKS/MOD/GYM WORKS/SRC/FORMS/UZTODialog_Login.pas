unit UZTODialog_Login;

interface

uses Windows, Mdl.Lib.ZTODialog_Base, StdCtrls, ExtCtrls, Controls, Grids,
  DBGrids, ZTO.Components.DataControls.DBGrid, DBCtrls, Classes, ActnList, DB,
  ZAbstractRODataset, ZDataset, ZConnection, Mdl.Lib.Configuracoes;

type
  TZTODialog_Login = class(TZTODialog_Base)
    Label3: TLabel;
    DBText_USU_VA_NOME: TDBText;
    ZTODBGrid_Login: TZTODBGrid;
    LabeledEdit_USU_VA_SENHA: TLabeledEdit;
    LabeledEdit_USU_VA_LOGIN: TLabeledEdit;
    DataSource_USU: TDataSource;
    procedure ZTODialogOkButtonClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
    class function FazerLogin(aConexao: TZConnection; aConfiguracoes: TConfiguracoes): TModalResult; static;
  end;

implementation

{$R *.dfm}

uses SysUtils
   , ZTO.Win32.Rtl.Common.Classes
   , ZTO.Win32.Db.ZeosLib.MySQL.Utils;

const
	SQL_SELECT_LOGIN =
    'SELECT %S'#13#10 + // CAMPO CHAVE
    '     , %S'#13#10 + // CAMPO NOME REAL
    '     , %S'#13#10 + // CAMPO LOGIN
    '     , %S'#13#10 + // CAMPO SENHA
    '  FROM %S';        // NOME DA TABELA

class function TZTODialog_Login.FazerLogin(aConexao: TZConnection; aConfiguracoes: TConfiguracoes): TModalResult;
var
  ZTODialog_Login: TZTODialog_Login;
  USUARIOS: TZReadOnlyQuery;
begin
  Result := mrNone;
  ZTODialog_Login := nil;

  try
    CreateDialog(nil
                ,ZTODialog_Login
                ,TZTODialog_Login
                ,smNone
                ,[]
                ,''
                ,[]
                ,[]
                ,sbNone
                ,dtNone);

    USUARIOS := nil;

    MySQLDataSetConfigure(aConexao
                         ,USUARIOS
                         ,Format(SQL_SELECT_LOGIN
                                ,[aConfiguracoes.CampoChave
                                 ,aConfiguracoes.CampoNomeReal
                                 ,aConfiguracoes.CampoNomeDeUsuario
                                 ,aConfiguracoes.CampoSenha
                                 ,aConfiguracoes.TabelaDeUsuarios]));

    ZTODialog_Login.DataSource_USU.DataSet := USUARIOS;

    Result := ZTODialog_Login.ShowModal;

    if Result = mrOk then
     	MySQLSetUserVariable(aConexao,'CURRENTLOGGEDUSER',aConfiguracoes.UltimoID);

  finally
    ZTODialog_Login.Close;
    ZTODialog_Login := nil;
  end;
end;


procedure TZTODialog_Login.ZTODialogOkButtonClick(Sender: TObject);
begin
 // inherited;
// inherited chama OK
// se o login for bem sucedido, chama inherited do contrario chama cancel ou outra coisa


end;

end.
