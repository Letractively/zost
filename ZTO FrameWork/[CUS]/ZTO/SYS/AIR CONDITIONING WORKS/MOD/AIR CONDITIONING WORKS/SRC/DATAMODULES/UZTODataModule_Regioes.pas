unit UZTODataModule_Regioes;

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
  TZTODataModule_Regioes = class(TZTODataModule_Base)
    REGIOES: TZQuery;
    REGIOESTI_REGIOES_ID: TSmallintField;
    REGIOESVA_REGIAO: TWideStringField;
    REGIOESCH_PREFIXODAPROPOSTA: TWideStringField;
    REGIOESVA_PRIMEIRORODAPE: TWideStringField;
    REGIOESVA_SEGUNDORODAPE: TWideStringField;
    UpdateSQL_REG: TZUpdateSQL;
    DataSource_REG: TDataSource;
    CFDBValidationChecks_REG: TCFDBValidationChecks;
    procedure REGIOESBeforePost(DataSet: TDataSet);
    procedure REGIOESBeforeDelete(DataSet: TDataSet);
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
   , UZTODialog_Regioes;

{$R *.dfm}

procedure TZTODataModule_Regioes.CreateGUI;
begin
  inherited;
  TZTODialog_Regioes.CreateDialog(Self
                                 ,MyGUI
                                 ,TZTODialog_Regioes
                                 ,smShowAutoFree
                                 ,[]
                                 ,''
                                 ,[]
                                 ,[]
                                 ,sbNone
                                 ,dtNone);
end;

procedure TZTODataModule_Regioes.DoQueryEvent(const aZQuery: TZQuery;
                                              const aQueryEvent: TQueryEvent);
begin
  inherited;
  if aZQuery = REGIOES then
    case aQueryEvent of
      qeBeforeInsert: UpdateSQL_REG.RefreshSQL.Text := 'SELECT TI_REGIOES_ID FROM ACW.REGIOES WHERE TI_REGIOES_ID = LAST_INSERT_ID()';
      qeBeforeEdit  : UpdateSQL_REG.RefreshSQL.Text := '';
    end;
end;

procedure TZTODataModule_Regioes.REGIOESBeforeDelete(DataSet: TDataSet);
begin
  inherited;
  CFDBValidationChecks_REG.ValidateBeforeDelete;
end;

procedure TZTODataModule_Regioes.REGIOESBeforePost(DataSet: TDataSet);
begin
  inherited;
  CFDBValidationChecks_REG.ValidateBeforePost;
end;

procedure TZTODataModule_Regioes.ZTODataModuleCreate(Sender: TObject);
begin
  inherited;
  CFDBValidationChecks_REG.Form := MyGUI
end;

end.


