unit UZTODataModule_Clientes;

interface

uses Classes
   , Forms
   , DB
   , ZDataset
   , CFDBValidationChecks
   , ZAbstractRODataset
   , ZAbstractDataset
   , ZSqlUpdate
   , Mdl.Lib.ZTODataModule_Base
   , Sys.Lib.Types;

type
  TZTODataModule_Clientes = class(TZTODataModule_Base)
    CLIENTES: TZQuery;
    DataSource_CLI: TDataSource;
    procedure ZTODataModuleCreate(Sender: TObject);
  protected
    procedure DoQueryEvent(const aZQuery: TZQuery; const aQueryEvent: TQueryEvent); override;
  private
    { Private declarations }
  public
    { Public declarations }
    procedure CreateGUI; override;
  end;

implementation

uses ZTO.Win32.Rtl.Common.Classes
   , UZTOSDIForm_Clientes, UDataModule_Principal;

{$R *.dfm}

procedure TZTODataModule_Clientes.CreateGUI;
begin
  inherited;
  TZTOSDIForm_Clientes.CreateSDIForm(Self
                                    ,MyGUI
                                    ,TZTOSDIForm_Clientes
                                    ,smShowAutoFree);
end;

procedure TZTODataModule_Clientes.DoQueryEvent(const aZQuery: TZQuery;
                                               const aQueryEvent: TQueryEvent);
begin
  inherited;
//  if aZQuery = REGIOES then
//    case aQueryEvent of
//      qeBeforeInsert: UpdateSQL_REG.RefreshSQL.Text := 'SELECT TI_REGIOES_ID FROM ACW.REGIOES WHERE TI_REGIOES_ID = LAST_INSERT_ID()';
//      qeBeforeEdit  : UpdateSQL_REG.RefreshSQL.Text := '';
//    end;
end;

//procedure TZTODataModule_Clientes.REGIOESBeforeDelete(DataSet: TDataSet);
//begin
//  inherited;
//  CFDBValidationChecks_REG.ValidateBeforeDelete;
//end;

//procedure TZTODataModule_Clientes.REGIOESBeforePost(DataSet: TDataSet);
//begin
//  inherited;
//  CFDBValidationChecks_REG.ValidateBeforePost;
//end;

procedure TZTODataModule_Clientes.ZTODataModuleCreate(Sender: TObject);
begin
  inherited;
//  CFDBValidationChecks_REG.Form := MyGUI
end;

end.
