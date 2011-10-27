(******************************************************************************
 * Esta unit define um Datamodule padrão, com todos os seus métodos e         *
 * propriedades. Uma instância desta classe é criada pelo wizard.             *
 ******************************************************************************)
unit ZTO.Wizards.FormTemplates.DataModule;

interface

uses Classes
   , DB
   , DBClient
   , ZConnection
   , ZTO.Win32.Rtl.Common.Classes
   , ZTO.Wizards.FormTemplates.CustomForm;

type
  TCreationTime = (ctUndefined, ctDesignTime, ctRunTime);

  { == Coleção de SQLs que são salvas com o DFM ============================== }
  TSQLItem = class (TCollectionItem)
  private
    FSQL: TStrings;
    FID: String;
    FDescription: String;
    procedure SetSQL(const Value: TStrings);
    procedure SetDescription(const Value: String);
    procedure SetID(const Value: String);
  protected
    function GetDisplayName: string; override;
  public
    constructor Create(aCollection: TCollection); override;
    destructor Destroy; override;
  published
    property SQL: TStrings read FSQL write SetSQL;
    property ID: String read FID write SetID;
    property Description: String read FDescription write SetDescription;
  end;

  TSQLCollection = class (TCollection)
  private
    FDataModule: TDataModule;
    function GetSQLItem(aIndex: Word): TSQLItem;
    function GetSQLItemByID(aID: String): TSQLItem;
  protected
   	function Add: TSQLItem;
    constructor Create(aDataModule: TDataModule);
  public
    property SQLItem[aIndex: Word]: TSQLItem read GetSQLItem;
    property SQLItemByID[aID: String]: TSQLItem read GetSQLItemByID; default;
  end;
  { ========================================================================== }

  { TODO : Crie para cada item de cada coleção propriedades para acessar as
  propriedades internas e eventos }
  { == Coleção de DataSets =================================================== }
  TDataSetItem = class (TCollectionItem)
  private
    FCreationTime: TCreationTime;
    FDataSet: TDataSet;
  public
    constructor Create(aCollection: TCollection); override;
    destructor Destroy; override;

    property CreationTime: TCreationTime read FCreationTime default ctUndefined;
    property DataSet: TDataSet read FDataSet;
  end;

  TDataSetCollection = class (TCollection)
  private
    FDataModule: TDataModule;
    function GetDataSetItem(aIndex: Word): TDataSetItem;
    function GetDataSetItemByDataSetName(aDataSetName: String): TDataSetItem;
    function GetItemsBrowsing: String;
    function GetItemsInserting: String;
    function GetItemsUpdating: String;
  protected
   	function Add: TDataSetItem;
    constructor Create(aDataModule: TDataModule);
  public
    function AddDataSet(aDataSetClass: TDataSetClass; aName: String): TDataSetItem;
    procedure OpenAll;
    procedure CloseAll;
    procedure CancelAll;

    property DataSetItem[aIndex: Word]: TDataSetItem read GetDataSetItem;
    property DataSetItemByDataSetName[aDataSetName: String]: TDataSetItem read GetDataSetItemByDataSetName; default;
    property ItemsInserting: String read GetItemsInserting;
    property ItemsUpdating: String read GetItemsUpdating;
    property ItemsBrowsing: String read GetItemsBrowsing;
  end;
  { ========================================================================== }

  { == Coleção de DataSources ================================================ }
  TDataSourceItem = class (TCollectionItem)
  private
    FCreationTime: TCreationTime;
    FDataSource: TDataSource;
  public
    constructor Create(aCollection: TCollection); override;
    destructor Destroy; override;

    property CreationTime: TCreationTime read FCreationTime default ctUndefined;
    property DataSource: TDataSource read FDataSource;
  end;

  TDataSourceClass = class of TDataSource;

  { Aqui foram replicadas as propriedades que verificam os datasets ligados aos
  datasources pois nem sempre um dataset está ligado a um datasource. O
  resultado obtido com as propriedades de TDataSets inclui TODOS os datasets. }
  TDataSourceCollection = class (TCollection)
  private
    FDataModule: TDataModule;
    function GetDataSourceItem(aIndex: Word): TDataSourceItem;
    function GetDataSourceItemByName(aDataSourceName: String): TDataSourceItem;
    function GetItemsBrowsing: String;
    function GetItemsInserting: String;
    function GetItemsUpdating: String;
  protected
   	function Add: TDataSourceItem;
    constructor Create(aDataModule: TDataModule);
  public
    function AddDataSource(aDataSourceClass: TDataSourceClass; aName: String): TDataSourceItem;

    property DataSourceItem[aIndex: Word]: TDataSourceItem read GetDataSourceItem;
    property DataSourceItemByName[aDataSourceName: String]: TDataSourceItem read GetDataSourceItemByName; default;
    property ItemsInserting: String read GetItemsInserting;
    property ItemsUpdating: String read GetItemsUpdating;
    property ItemsBrowsing: String read GetItemsBrowsing;
  end;
  { ========================================================================== }

  { = Coleção de ClientDataSets ============================================== }
  TClientDataSetItem = class (TCollectionItem)
  private
    FCreationTime: TCreationTime;
    FClientDataSet: TClientDataSet;
  public
    constructor Create(aCollection: TCollection); override;
    destructor Destroy; override;

    property CreationTime: TCreationTime read FCreationTime default ctUndefined;
    property ClientDataSet: TClientDataSet read FClientDataSet;
  end;

  TClientDataSetClass = class of TClientDataSet;

  TClientDataSetCollection = class (TCollection)
  private
    FDataModule: TDataModule;
    function GetClientDataSetItem(aIndex: Word): TClientDataSetItem;
    function GetClientDataSetItemByClientDataSetName(aClientDataSetName: String): TClientDataSetItem;
    function GetItemsBrowsing: String;
    function GetItemsInserting: String;
    function GetItemsUpdating: String;
  protected
   	function Add: TClientDataSetItem;
    constructor Create(aDataModule: TDataModule);
  public
    function AddClientDataSet(aClientDataSetClass: TClientDataSetClass; aName: String): TClientDataSetItem;
    procedure CancelAll;

    property ClientDataSetItem[aIndex: Word]: TClientDataSetItem read GetClientDataSetItem;
    property ClientDataSetItemByClientDataSetName[aClientDataSetName: String]: TClientDataSetItem read GetClientDataSetItemByClientDataSetName; default;
    property ItemsInserting: String read GetItemsInserting;
    property ItemsUpdating: String read GetItemsUpdating;
    property ItemsBrowsing: String read GetItemsBrowsing;
  end;
  { ========================================================================== }

  { == Coleção de ZConnections =============================================== }
  TZConnectionItem = class (TCollectionItem)
  private
    FCreationTime: TCreationTime;
    FZConnection: TZConnection;
  public
    constructor Create(aCollection: TCollection); override;
    destructor Destroy; override;

    property CreationTime: TCreationTime read FCreationTime default ctUndefined;
    property ZConnection: TZConnection read FZConnection;
  end;

  TZConnectionClass = class of TZConnection;

  TZConnectionCollection = class (TCollection)
  private
    FDataModule: TDataModule;
    function GetZConnectionItem(aIndex: Word): TZConnectionItem;
    function GetZConnectionItemByZConnectionName(aZConnectionName: String): TZConnectionItem;
  protected
   	function Add: TZConnectionItem;
    constructor Create(aDataModule: TDataModule);
  public
    function AddZConnection(aZConnectionClass: TZConnectionClass; aName: String): TZConnectionItem;

    property ZConnectionItem[aIndex: Word]: TZConnectionItem read GetZConnectionItem;
    property ZConnectionItemByZConnectionName[aZConnectionName: String]: TZConnectionItem read GetZConnectionItemByZConnectionName; default;
  end;
  { ========================================================================== }

  TZTODataModuleClass = class of TZTODataModule;

  PZTODataModule = ^TZTODataModule;

  TZTODataModule = class(TDataModule)
  private
    FMyReference: PZTODataModule;
    FDataSources: TDataSourceCollection;
    FDataSets: TDataSetCollection;
    FClientDataSets: TClientDataSetCollection;
    FZConnections: TZConnectionCollection;
    FSQLs: TSQLCollection;
    FZTODataModuleProperties: TZTODataModuleProperties;
    FMyForm: TZTOCustomForm;
    FMyFormClass: String;
  protected
    property MyForm: TZTOCustomForm read FMyForm;
  public
    constructor Create(aOwner: TComponent); override;
    destructor Destroy; override;

    class procedure CreateMe(    aOwner             : TComponent;
                             var aReference;        { não tem tipo! }
                                 aZTODataModuleClass: TZTODataModuleClass); static;

    property DataSources: TDataSourceCollection read FDataSources;
    property DataSets: TDataSetCollection read FDataSets;
    property ClientDataSets: TClientDataSetCollection read FClientDataSets;
    property ZConnections: TZConnectionCollection read FZConnections;
  published
    property ZTOProperties: TZTODataModuleProperties read FZTODataModuleProperties write FZTODataModuleProperties;
    property SQLs: TSQLCollection read FSQLs write FSQLs;
    property MyFormClass: String read FMyFormClass write FMyFormClass;
  end;

implementation

uses SysUtils;

{ TZTODataModule }

constructor TZTODataModule.Create(aOwner: TComponent);
var
  i: Word;
begin
  FZTODataModuleProperties := TZTODataModuleProperties.Create;
  FDataSources             := TDataSourceCollection.Create(Self);
  FDataSets                := TDataSetCollection.Create(Self);
  FClientDataSets          := TClientDataSetCollection.Create(Self);
  FZConnections            := TZConnectionCollection.Create(Self);
  FSQLs                    := TSQLCollection.Create(Self);
  FMyForm                  := nil;

  inherited;

  if ComponentCount > 0 then
    for i := 0 to Pred(ComponentCount) do
      if Components[i] is TDataSource then
        with FDataSources.Add do
        begin
          FDataSource := TDataSource(Components[i]);
          FCreationTime := ctDesignTime;
        end
      else if Components[i] is TDataSet then
        with FDataSets.Add do
        begin
          FDataSet := TDataSet(Components[i]);
          FCreationTime := ctDesignTime;
        end
      else if Components[i] is TClientDataSet then
        with FClientDataSets.Add do
        begin
          FClientDataSet := TClientDataSet(Components[i]);
          FCreationTime := ctDesignTime;
        end
      else if Components[i] is TZConnection then
        with FZConnections.Add do
        begin
          FZConnection := TZConnection(Components[i]);
          FCreationTime := ctDesignTime;
        end;

  if FZTODataModuleProperties.OpenAllDataSets then
    FDataSets.OpenAll;

  if FMyFormClass <> '' then
  begin
    if not Assigned(GetClass(FMyFormClass)) then
      raise Exception.Create('A classe ' + FMyFormClass + ' não foi registrada');

    if not GetClass(FMyFormClass).InheritsFrom(TZTOCustomForm) then
      raise Exception.Create(FMyFormClass + ' não é uma classe descendente de ' + TZTOCustomForm.ClassName);

    FMyForm := TZTOCustomFormClass(GetClass(FMyFormClass)).Create(Self);
  end;
end;

destructor TZTODataModule.Destroy;
begin
  { Só é preciso destruir as coisas se realmente uma instância deste DM foi
  criada e isso só não é feito caso exceções sejam lançadas dentro do construtor }
  if Assigned(FMyReference) then
  begin
    FMyReference^ := nil;

    { Todo Form criado automaticamente com um datamodule é sempre destruído junto
    com ele. Isso é apenas uma segurança, pois normalmente o Form de um DataModule
    é quem lança o comando para que o seu datamodule seja destruído e nesta
    situação, a variável FMyForm já estará NIL }
    if Assigned(FMyForm) then
      FMyForm.Free;

    FSQLs.Free;
    FZConnections.Free;
    FClientDataSets.Free;
    FDataSets.Free;
    FDataSources.Free;

    FZTODataModuleProperties.Free;
  end;

  inherited;
end;

class procedure TZTODataModule.CreateMe(    aOwner             : TComponent;
                                        var aReference;        { não tem tipo! }
                                            aZTODataModuleClass: TZTODataModuleClass);
begin
  if Assigned(TZTODataModule(aReference)) then
    raise Exception.Create('O parâmetro aReference contém uma variável não vazia');

  TZTODataModule(aReference) := aZTODataModuleClass.Create(aOwner);
  TZTODataModule(aReference).FMyReference := @aReference;
end;


{ TDataSetItem }

constructor TDataSetItem.Create(aCollection: TCollection);
begin
  inherited;
  FCreationTime := ctUndefined;
end;

destructor TDataSetItem.Destroy;
begin
  if FCreationTime = ctRunTime then
    FDataSet.Free;
  inherited;
end;

{ TDataSets }

procedure TDataSetCollection.OpenAll;
var
  i: Word;
begin
  if Count > 0 then
    for i := 0 to Pred(Count) do
      TDataSetItem(Items[i]).DataSet.Open;
end;

function TDataSetCollection.Add: TDataSetItem;
begin
	Result := TDataSetItem(inherited Add);
end;

function TDataSetCollection.AddDataSet(aDataSetClass: TDataSetClass; aName: String): TDataSetItem;
begin
  Result := DataSetItemByDataSetName[aName];

  if not Assigned(Result) then
  begin
    Result := Add;
    with Result do
    begin
      FDataSet := aDataSetClass.Create(FDataModule);
      FDataSet.Name := aName;
      FCreationTime := ctRunTime;
    end;
  end;
end;

constructor TDataSetCollection.Create(aDataModule: TDataModule);
begin
  inherited Create(TDataSetItem);
  FDataModule := aDataModule;
end;

procedure TDataSetCollection.CancelAll;
var
  i: Word;
begin
  if Count > 0 then
    for i := 0 to Pred(Count) do
      TDataSetItem(Items[i]).DataSet.Cancel;
end;

procedure TDataSetCollection.CloseAll;
var
  i: Word;
begin
  if Count > 0 then
    for i := 0 to Pred(Count) do
      TDataSetItem(Items[i]).DataSet.Close;
end;

function TDataSetCollection.GetDataSetItem(aIndex: Word): TDataSetItem;
begin
	Result := TDataSetItem(inherited Items[aIndex]);
end;

function TDataSetCollection.GetDataSetItemByDataSetName(aDataSetName: String): TDataSetItem;
var
	DSI: Byte;
begin
	Result := nil;

  if Count > 0 then
    for DSI := 0 to Pred(Count) do
      if UpperCase(TDataSetItem(Items[DSI]).DataSet.Name) = UpperCase(aDataSetName) then
      begin
        Result := TDataSetItem(Items[DSI]);
        Break;
      end;
end;

function TDataSetCollection.GetItemsBrowsing: String;
var
	DSB: Byte;
begin
	Result := '';

  if Count > 0 then
    for DSB := 0 to Pred(Count) do
      if TDataSetItem(Items[DSB]).DataSet.State = dsBrowse then
      begin
        if DSB > 0 then
          Result := Result + ';' + TDataSetItem(Items[DSB]).DataSet.Name
        else
          Result := Result + TDataSetItem(Items[DSB]).DataSet.Name;
      end;
end;

function TDataSetCollection.GetItemsInserting: String;
var
	DSI: Byte;
begin
	Result := '';

  if Count > 0 then
    for DSI := 0 to Pred(Count) do
      if TDataSetItem(Items[DSI]).DataSet.State = dsInsert then
      begin
        if DSI > 0 then
          Result := Result + ';' + TDataSetItem(Items[DSI]).DataSet.Name
        else
          Result := Result + TDataSetItem(Items[DSI]).DataSet.Name;
      end;
end;

function TDataSetCollection.GetItemsUpdating: String;
var
	DSU: Byte;
begin
	Result := '';

  if Count > 0 then
    for DSU := 0 to Pred(Count) do
      if TDataSetItem(Items[DSU]).DataSet.State = dsEdit then
      begin
        if DSU > 0 then
          Result := Result + ';' + TDataSetItem(Items[DSU]).DataSet.Name
        else
          Result := Result + TDataSetItem(Items[DSU]).DataSet.Name;
      end;
end;

{ TDataSourceItem }

constructor TDataSourceItem.Create(aCollection: TCollection);
begin
  inherited;
  FCreationTime := ctUndefined;
end;

destructor TDataSourceItem.Destroy;
begin
  if FCreationTime = ctRunTime then
    FDataSource.Free;

  inherited;
end;

{ TDataSources }

function TDataSourceCollection.Add: TDataSourceItem;
begin
	Result := TDataSourceItem(inherited Add);
end;

function TDataSourceCollection.AddDataSource(aDataSourceClass: TDataSourceClass; aName: String): TDataSourceItem;
begin
  Result := DataSourceItemByName[aName];

  if not Assigned(Result) then
  begin
    Result := Add;
    with Result do
    begin
      FDataSource := aDataSourceClass.Create(FDataModule);
      FDataSource.Name := aName;
      FCreationTime := ctRunTime;
    end;
  end;
end;

constructor TDataSourceCollection.Create(aDataModule: TDataModule);
begin
  inherited Create(TDataSourceItem);
  FDataModule := aDataModule;
end;

function TDataSourceCollection.GetDataSourceItemByName(aDataSourceName: String): TDataSourceItem;
var
	DSI: Byte;
begin
	Result := nil;

  if Count > 0 then
    for DSI := 0 to Pred(Count) do
      if UpperCase(TDataSourceItem(Items[DSI]).DataSource.Name) = UpperCase(aDataSourceName) then
      begin
        Result := TDataSourceItem(Items[DSI]);
        Break;
      end;
end;

function TDataSourceCollection.GetItemsBrowsing: String;
var
	DSB: Byte;
begin
	Result := '';

  if Count > 0 then
    for DSB := 0 to Pred(Count) do
      if TDataSourceItem(Items[DSB]).DataSource.DataSet.State = dsBrowse then
      begin
        if DSB > 0 then
          Result := Result + ';' + TDataSourceItem(Items[DSB]).DataSource.DataSet.Name
        else
          Result := Result + TDataSourceItem(Items[DSB]).DataSource.DataSet.Name;
      end;
end;

function TDataSourceCollection.GetItemsInserting: String;
var
	DSI: Byte;
begin
	Result := '';

  if Count > 0 then
    for DSI := 0 to Pred(Count) do
      if TDataSourceItem(Items[DSI]).DataSource.DataSet.State = dsInsert then
      begin
        if DSI > 0 then
          Result := Result + ';' + TDataSourceItem(Items[DSI]).DataSource.DataSet.Name
        else
          Result := Result + TDataSourceItem(Items[DSI]).DataSource.DataSet.Name;
      end;
end;

function TDataSourceCollection.GetItemsUpdating: String;
var
	DSU: Byte;
begin
	Result := '';

  if Count > 0 then
    for DSU := 0 to Pred(Count) do
      if TDataSourceItem(Items[DSU]).DataSource.DataSet.State = dsEdit then
      begin
        if DSU > 0 then
          Result := Result + ';' + TDataSourceItem(Items[DSU]).DataSource.DataSet.Name
        else
          Result := Result + TDataSourceItem(Items[DSU]).DataSource.DataSet.Name;
      end;
end;

function TDataSourceCollection.GetDataSourceItem(aIndex: Word): TDataSourceItem;
begin
	Result := TDataSourceItem(inherited Items[aIndex]);
end;

{ TClientDataSetItem }

constructor TClientDataSetItem.Create(aCollection: TCollection);
begin
  inherited;
  FCreationTime := ctUndefined;
end;

destructor TClientDataSetItem.Destroy;
begin
  if FCreationTime = ctRunTime then
    FClientDataSet.Free;

  inherited;
end;

{ TClientDataSets }

function TClientDataSetCollection.Add: TClientDataSetItem;
begin
	Result := TClientDataSetItem(inherited Add);
end;

function TClientDataSetCollection.AddClientDataSet(aClientDataSetClass: TClientDataSetClass; aName: String): TClientDataSetItem;
begin
  Result := ClientDataSetItemByClientDataSetName[aName];

  if not Assigned(Result) then
  begin
    Result := Add;
    with Result do
    begin
      FClientDataSet := aClientDataSetClass.Create(FDataModule);
      FClientDataSet.Name := aName;
      FCreationTime := ctRunTime;
    end;
  end;
end;

procedure TClientDataSetCollection.CancelAll;
var
  i: Word;
begin
  if Count > 0 then
    for i := 0 to Pred(Count) do
      TClientDataSetItem(Items[i]).ClientDataSet.Cancel;
end;

constructor TClientDataSetCollection.Create(aDataModule: TDataModule);
begin
  inherited Create(TClientDataSetItem);
  FDataModule := aDataModule;
end;

function TClientDataSetCollection.GetClientDataSetItem(aIndex: Word): TClientDataSetItem;
begin
	Result := TClientDataSetItem(inherited Items[aIndex]);
end;

function TClientDataSetCollection.GetClientDataSetItemByClientDataSetName(aClientDataSetName: String): TClientDataSetItem;
var
	CDI: Byte;
begin
	Result := nil;

  if Count > 0 then
    for CDI := 0 to Pred(Count) do
      if UpperCase(TClientDataSetItem(Items[CDI]).ClientDataSet.Name) = UpperCase(aClientDataSetName) then
      begin
        Result := TClientDataSetItem(Items[CDI]);
        Break;
      end;
end;

function TClientDataSetCollection.GetItemsBrowsing: String;
var
	DSB: Byte;
begin
	Result := '';

  if Count > 0 then
    for DSB := 0 to Pred(Count) do
      if TClientDataSetItem(Items[DSB]).ClientDataSet.State = dsBrowse then
      begin
        if DSB > 0 then
          Result := Result + ';' + TClientDataSetItem(Items[DSB]).ClientDataSet.Name
        else
          Result := Result + TClientDataSetItem(Items[DSB]).ClientDataSet.Name;
      end;
end;

function TClientDataSetCollection.GetItemsInserting: String;
var
	DSI: Byte;
begin
	Result := '';

  if Count > 0 then
    for DSI := 0 to Pred(Count) do
      if TClientDataSetItem(Items[DSI]).ClientDataSet.State = dsInsert then
      begin
        if DSI > 0 then
          Result := Result + ';' + TClientDataSetItem(Items[DSI]).ClientDataSet.Name
        else
          Result := Result + TClientDataSetItem(Items[DSI]).ClientDataSet.Name;
      end;
end;

function TClientDataSetCollection.GetItemsUpdating: String;
var
	DSU: Byte;
begin
	Result := '';

  if Count > 0 then
    for DSU := 0 to Pred(Count) do
      if TClientDataSetItem(Items[DSU]).ClientDataSet.State = dsEdit then
      begin
        if DSU > 0 then
          Result := Result + ';' + TClientDataSetItem(Items[DSU]).ClientDataSet.Name
        else
          Result := Result + TClientDataSetItem(Items[DSU]).ClientDataSet.Name;
      end;
end;

{ TZConnectionItem }

constructor TZConnectionItem.Create(aCollection: TCollection);
begin
  inherited;
  FCreationTime := ctUndefined;
end;

destructor TZConnectionItem.Destroy;
begin
  if FCreationTime = ctRunTime then
    FZConnection.Free;

  inherited;
end;

{ TZConnections }

function TZConnectionCollection.Add: TZConnectionItem;
begin
	Result := TZConnectionItem(inherited Add);
end;

function TZConnectionCollection.AddZConnection(aZConnectionClass: TZConnectionClass; aName: String): TZConnectionItem;
begin
  Result := ZConnectionItemByZConnectionName[aName];

  if not Assigned(Result) then
  begin
    Result := Add;
    with Result do
    begin
      FZConnection := aZConnectionClass.Create(FDataModule);
      FZConnection.Name := aName;
      FCreationTime := ctRunTime;
    end;
  end;
end;

constructor TZConnectionCollection.Create(aDataModule: TDataModule);
begin
  inherited Create(TZConnectionItem);
  FDataModule := aDataModule;
end;

function TZConnectionCollection.GetZConnectionItem(aIndex: Word): TZConnectionItem;
begin
  Result := TZConnectionItem(inherited Items[aIndex]);
end;

function TZConnectionCollection.GetZConnectionItemByZConnectionName(aZConnectionName: String): TZConnectionItem;
var
	ZCI: Byte;
begin
	Result := nil;

  if Count > 0 then
    for ZCI := 0 to Pred(Count) do
      if UpperCase(TZConnectionItem(Items[ZCI]).ZConnection.Name) = UpperCase(aZConnectionName) then
      begin
        Result := TZConnectionItem(Items[ZCI]);
        Break;
      end;
end;

{ TSQLs }

function TSQLCollection.Add: TSQLItem;
begin
	Result := TSQLItem(inherited Add);
end;

constructor TSQLCollection.Create(aDataModule: TDataModule);
begin
  inherited Create(TSQLItem);
  FDataModule := aDataModule;
end;

function TSQLCollection.GetSQLItem(aIndex: Word): TSQLItem;
begin
  Result := TSQLItem(inherited Items[aIndex]);
end;

function TSQLCollection.GetSQLItemByID(aID: String): TSQLItem;
var
	SI: Byte;
begin
	Result := nil;

  if Count > 0 then
    for SI := 0 to Pred(Count) do
      if UpperCase(TSQLItem(Items[SI]).ID) = UpperCase(aID) then
      begin
        Result := TSQLItem(Items[SI]);
        Break;
      end;
end;

{ TSQLItem }

constructor TSQLItem.Create(aCollection: TCollection);
begin
  inherited;
  FSQL := TStringList.Create;
end;

destructor TSQLItem.Destroy;
begin
  FSQL.Free;
  inherited;
end;

function TSQLItem.GetDisplayName: string;
begin
  Result := FID;
end;

procedure TSQLItem.SetDescription(const Value: String);
var
	SI: Byte;
begin
  if Collection.Count > 0 then
    for SI := 0 to Pred(Collection.Count) do
      if UpperCase(TSQLItem(Collection.Items[SI]).Description) = UpperCase(Value) then
        raise Exception.Create('A descrição escolhida já consta na lista de SQLs. Por favor escolha outra descrição');

  FDescription := UpperCase(Value);
end;

procedure TSQLItem.SetID(const Value: String);
var
	SI: Byte;
begin
  if Collection.Count > 0 then
    for SI := 0 to Pred(Collection.Count) do
      if UpperCase(TSQLItem(Collection.Items[SI]).ID) = UpperCase(Value) then
        raise Exception.Create('O nome escolhido já consta na lista de SQLs. Por favor escolha outro nome');


  if IsValidIdent(Value,True)  then
    raise Exception.Create('O nome deve seguir a mesma convenção de nomes das units');

  FID := UpperCase(Value);
end;

procedure TSQLItem.SetSQL(const Value: TStrings);
begin
  FSQL.Assign(Value);
end;

end.
