unit UBDOTypesConstantsAndClasses;

interface

uses
	Classes, SysUtils,

    UXXXTypesConstantsAndClasses;

type
	TOBRFilter = record
        VA_NOMEDAOBRA, VA_CIDADE, CH_ESTADO, VA_CONSTRUTORA: AnsiString;
        TI_REGIOES_ID, TI_TIPOS_ID, TI_SITUACOES_ID: Byte;
        DA_DATADEENTRADA_I, DA_DATADEENTRADA_F: TDateTime;
        SM_PROJETISTAS_ID: Word;
        ComPropostas: Char;
    end;

    TPROFilter = record
    	VA_CONTATO, VA_NOMEDAOBRA: AnsiString;
        SM_CODIGO, YR_ANO: Word;
        BO_PROPOSTAPADRAO: 0..2; { 0 = Não, 1 = Sim, 2 = Ambas }
        SM_INSTALADORES_ID: Word;
    end;

    TEQPFilter = record
        VA_MODELO, EN_VOLTAGEM: AnsiString;
        SM_CODIGO, YR_ANO: Word;
        BO_PROPOSTAPADRAO: 0..2; { 0 = Não, 1 = Sim, 2 = Ambas }
        SM_INSTALADORES_ID: Word;
    end;

	TBDOConfigurations = class(TXXXConfigurations)
    private
    	FFTPSynchronizerLocation: TFileName;

        FUserRegionsTableTableName: AnsiString; { REGIOESDOSUSUARIOS }
        FUserRegionsTableKeyFieldName: AnsiString;
        FUserRegionsTableUserFieldName: AnsiString;
        FUserRegionsTableRegionFieldName: AnsiString;

        FExibirColunaLucroBrutoEmCadastroDeItens: Boolean;
    public { Public declarations }
        constructor Create(AOwner: TComponent); override;
        destructor Destroy; override;
    published { Published declarations }
    	property FTPSynchronizerLocation: TFileName read FFTPSynchronizerLocation write FFTPSynchronizerLocation;
        property UserRegionsTableTableName: AnsiString read FUserRegionsTableTableName write FUserRegionsTableTableName;
        property UserRegionsTableKeyFieldName: AnsiString read FUserRegionsTableKeyFieldName write FUserRegionsTableKeyFieldName;
        property UserRegionsTableUserFieldName: AnsiString read FUserRegionsTableUserFieldName write FUserRegionsTableUserFieldName;
        property UserRegionsTableRegionFieldName: AnsiString read FUserRegionsTableRegionFieldName write FUserRegionsTableRegionFieldName;

        property ExibirColunaLucroBrutoEmCadastroDeItens: Boolean read FExibirColunaLucroBrutoEmCadastroDeItens write FExibirColunaLucroBrutoEmCadastroDeItens;
    end;

const
    DEFAULT_USERREGIONS_TABLENAME: AnsiString = 'REGIOESDOSUSUARIOS';
    DEFAULT_USERREGIONS_KEYFIELDNAME: AnsiString = 'MI_REGIOESDOSUSUARIOS_ID';
    DEFAULT_USERREGIONS_USERFIELDNAME: AnsiString = 'SM_USUARIOS_ID';
    DEFAULT_USERREGIONS_REGIONFIELDNAME: AnsiString = 'TI_REGIOES_ID';
    VOLTAGENS: array [1..5] of AnsiString = ('N/A','220/1Ø','220/3Ø','380/3Ø','440/3Ø');

resourcestring
    RS_PAGE_CHANGE_NOT_ALLOWED = PAGE_CHANGE_NOT_ALLOWED;
    RS_ACTION_NOT_ALLOWED_NOW = ACTION_NOT_ALLOWED_NOW;

implementation

const
	CONFIG_FILENAME = '\CONFIG.DAT';
    DEFAULT_FTPSYNCHRONIZER_LOCATION = 'C:\ARQUIVOS DE PROGRAMAS\HITACHI TOOLS\BANCO DE OBRAS 3\FTP SYNCHRONIZER';
	ADMIN_ACTION = 'BDODATAMODULE_MAIN.ACTION_SECURITYANDPERMISSIONS';
    ADDENTITY_ACTION = 'BDODATAMODULE_ADMINISTRATION.ACTION_EDS_INSERT';
    ADDENTITYTOUSERORGROUP_ACTION = 'BDODATAMODULE_ADMINISTRATION.ACTION_PDU_PDG_INSERT';

//    APPLICATION_MASTER_PASSWORD = '¡HMCR2005Soft!';

//    APPLICATION_USERTABLE_TABLENAME = 'USUARIOS';
//    APPLICATION_USERTABLE_KEYFIELDNAME = 'SM_USUARIOS_PK';
//    APPLICATION_USERTABLE_REALNAMEFIELDNAME = 'VA_NOME';
//    APPLICATION_USERTABLE_USERNAMEFIELDNAME = 'VA_LOGIN';
//    APPLICATION_USERTABLE_PASSWORDFIELDNAME = 'TB_SENHA';
//
//    EXPORTEDFILE_EXTENSION = '.oex';

{ TApplicationConfigurations }

constructor TBDOConfigurations.Create(AOwner: TComponent);
begin
	inherited;
    FFTPSynchronizerLocation := DEFAULT_FTPSYNCHRONIZER_LOCATION;
    AdministrativeActionName := ADMIN_ACTION;
    AddEntityActionName := ADDENTITY_ACTION;
    AddEntityToUserOrGroupActionName := ADDENTITYTOUSERORGROUP_ACTION;

    FUserRegionsTableTableName := DEFAULT_USERREGIONS_TABLENAME;
    FUserRegionsTableKeyFieldName := DEFAULT_USERREGIONS_KEYFIELDNAME;
    FUserRegionsTableUserFieldName := DEFAULT_USERREGIONS_USERFIELDNAME;
    FUserRegionsTableRegionFieldName := DEFAULT_USERREGIONS_REGIONFIELDNAME;

    FExibirColunaLucroBrutoEmCadastroDeItens := False;

	{ Aqui não precisamos nos preocupar com o banco de dados pois a classe base
    ja se preocupa. aqui apenas colocamos os nossos valores padrao
    sobrescrevendo aqueles da classe base }

//    MasterPassword := APPLICATION_MASTER_PASSWORD;
//    UserTableTableName := APPLICATION_USERTABLE_TABLENAME;
//    UserTableKeyFieldName := APPLICATION_USERTABLE_KEYFIELDNAME;
//    UserTableRealNameFieldName := APPLICATION_USERTABLE_REALNAMEFIELDNAME;
//    UserTableUserNameFieldName := APPLICATION_USERTABLE_USERNAMEFIELDNAME;
//    UserTablePasswordFieldName := APPLICATION_USERTABLE_PASSWORDFIELDNAME;

    { Se tiver, carrega. Se não, mantém o padrão acima }
    LoadFromBinaryFile(String(CurrentDir) + CONFIG_FILENAME);
end;

destructor TBDOConfigurations.Destroy;
begin
    SaveToBinaryFile(String(CurrentDir) + CONFIG_FILENAME);
  	inherited;
end;

end.
