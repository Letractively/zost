unit UBDODataModule_EmailsAutomaticos;

interface

uses
    Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
    Dialogs, UBDODataModule, ImgList, ActnList, DB, ZAbstractRODataset, ZDataset, 
    UBDOForm_EmailsAutomaticos;

type
    TBDODataModule_EmailsAutomaticos = class(TBDODataModule)
        USUARIOS_LOOKUP: TZReadOnlyQuery;
        DataSource_USU_LKP: TDataSource;
        USUARIOS_LOOKUPSM_USUARIOS_ID: TSmallintField;
        USUARIOS_LOOKUPVA_NOME: TStringField;
        USUARIOS_LOOKUPVA_LOGIN: TStringField;
        USUARIOS_LOOKUPVA_EMAIL: TStringField;
    private
        { Private declarations }
        function MyModule: TBDOForm_EmailsAutomaticos;
    public
        { Public declarations }
        procedure PreencherComUsuarios(aStrings: TStrings);
        procedure CarregarConfiguracoes;
        procedure SalvarConfiguracoes;
        function GetUserEmail(aUserID: Word = 0): ShortString;
    end;

implementation

uses
    UBDOTypesConstantsAndClasses, UXXXDataModule;

{$R *.dfm}

{ TBDODataModule_EmailsAutomaticos }

procedure TBDODataModule_EmailsAutomaticos.CarregarConfiguracoes;
begin
    MyModule.Panel_EmailPrincipal.Caption := TBDOConfigurations(Configurations).EmailPrincipal;
//    isso está errado!
//    alem disso você tem de fazer como foi feito para abri o form de configurações e carregar e salvar as configurações fora
//    pois isso teré de ser feito nas configuracoes globais e nao em suas copias
    MyModule.ComboBox_UsuarioPrincipal.ItemIndex := MyModule.ComboBox_UsuarioPrincipal.Items.IndexOfObject(MyModule.ComboBox_UsuarioPrincipal.Items.Objects[MyModule.ComboBox_UsuarioPrincipal.ItemIndex]);
end;

function TBDODataModule_EmailsAutomaticos.GetUserEmail(aUserID: Word): ShortString;
begin
    Result := inherited GetUserEmail(aUserID);
end;

function TBDODataModule_EmailsAutomaticos.MyModule: TBDOForm_EmailsAutomaticos;
begin
    Result := TBDOForm_EmailsAutomaticos(Owner);
end;

procedure TBDODataModule_EmailsAutomaticos.PreencherComUsuarios(aStrings: TStrings);
begin
    aStrings.Clear;

    USUARIOS_LOOKUP.First;
    while not USUARIOS_LOOKUP.Eof do
    begin
        aStrings.AddObject(USUARIOS_LOOKUPVA_NOME.AsString + ' (' + USUARIOS_LOOKUPVA_LOGIN.AsString + ')',TObject(USUARIOS_LOOKUPSM_USUARIOS_ID.AsInteger));
        USUARIOS_LOOKUP.Next;
    end;
end;

procedure TBDODataModule_EmailsAutomaticos.SalvarConfiguracoes;
begin
    TBDOConfigurations(Configurations).EmailPrincipal := MyModule.Panel_EmailPrincipal.Caption;

end;

end.
