unit UMBRDataModule_Main;

interface

uses
    Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
    Dialogs, Menus, ActnList, DB,

    UMBRDataModule, UMBRForm_Main,

    ZConnection, ZAbstractRODataset, ZDataset, ExtCtrls;

type
    TMBRDataModule_Main = class(TMBRDataModule)
        ZConnection_MBR: TZConnection;
        procedure DataModuleCreate(Sender: TObject);
        procedure ZConnection_MBRBeforeConnect(Sender: TObject);
        procedure ZConnection_MBRAfterConnect(Sender: TObject);
    private
        { Private declarations }
//        function MyModule: TMBRForm_Main;
    protected

    public
        { Public declarations }
        procedure ExibirMBAR;
    end;

implementation

uses
     UXXXDataModule, UXXXForm_DialogTemplate, UMBRForm_MySQLBackupAndRestore, 
    ZDBCIntfs;

{$R *.dfm}

//function TMBRDataModule_Main.MyModule: TMBRForm_Main;
//begin
//    Result := TMBRForm_Main(Owner);
//end;

{ TMBRDataModule_Main }

procedure TMBRDataModule_Main.DataModuleCreate(Sender: TObject);
begin
    inherited;
    ZConnection_MBR.Connect;
end;

procedure TMBRDataModule_Main.ExibirMBAR;
var
	MBRForm_MySQLBackupAndRestore: TMBRForm_MySQLBackupAndRestore;
    CreateParameters: TDialogCreateParameters;
begin
    MBRForm_MySQLBackupAndRestore := nil;
    ZeroMemory(@CreateParameters,SizeOf(TDialogCreateParameters));
    with CreateParameters do
    begin
		AutoFree := True;
        AutoShow := True;
        Modal := True;
        Configurations := Self.Configurations;
        MyDataModuleClass := nil;
        MyDataModule := Self;
        DataModuleMain := TXXXDataModule_Main(Self);
    end;
    TXXXForm_DialogTemplate.CreateDialog(Self
                                        ,MBRForm_MySQLBackupAndRestore
                                        ,TMBRForm_MySQLBackupAndRestore
                                        ,CreateParameters);
end;

procedure TMBRDataModule_Main.ZConnection_MBRAfterConnect(Sender: TObject);
begin
    inherited;
    MySQLSetSQLQuoteShowCreate(ZConnection_MBR,False);
end;

procedure TMBRDataModule_Main.ZConnection_MBRBeforeConnect(Sender: TObject);
begin
    inherited;
    ZConnection_MBR.Protocol := Configurations.DBProtocol;
    ZConnection_MBR.HostName := Configurations.DBHostAddr;
    ZConnection_MBR.Port     := Configurations.DBPortNumb;
//    ZConnection_MBR.Database := Configurations.DBDataBase;
    ZConnection_MBR.User     := Configurations.DBUserName;
    ZConnection_MBR.Password := Configurations.DBPassword;
    ZConnection_MBR.TransactIsolationLevel := TZTransactIsolationLevel(Configurations.DBIsoLevel);
end;

end.
