//"There are only 10 types of people in this world...
//those who understand binary, and those who don't"
unit USyncStructures;

interface

uses
  	Classes, UObjectFile, Contnrs;

type
    TActionPerformed = (apInsert,apUpdate,apDelete);

	TSyncRecord = class(TCollectionItem)
    private
    	FActionPerformed: TActionPerformed;
	public
        function InsertClause(aValues: Boolean): String; virtual; abstract;
        function UpdateClause: String; virtual; abstract;
	    function PrimaryKeyValue: Cardinal; virtual; abstract;
    published
        property ActionPerformed: TActionPerformed read FActionPerformed write FActionPerformed;
    end;

//    TSyncRecordClass = class of TSyncRecord;

//    TSyncRecords = class;
//
//    TParentSyncTable = class(TCollectionItem)
//    private
//        FSyncTable: TSyncRecords;
//    public
//    	property SyncTable: TSyncRecords read FSyncTable write FSyncTable;
//    end;
//
//    TParentSyncRecords = class(TCollection)
//  	private
//    	function GetParentSyncTable(i: Byte): TParentSyncTable;
//    	function GetParentSyncTableByReference(aTableName: ShortString; aPrimaryKey: Cardinal): TParentSyncTable;
//    public
//        function Add: TParentSyncTable;
//		property ParentSyncTable[i: Byte]: TParentSyncTable read GetParentSyncTable; default;
//        property ParentSyncTableByReference[TableName: ShortString; PrimaryKey: Cardinal]: TParentSyncTable read GetParentSyncTableByReference;
//    end;

    TSyncRecords = class (TCollection)
    private
	    function GetSyncRecord(i: Cardinal): TSyncRecord;
    protected
        function Add: TSyncRecord;
//    public
//        constructor Create(aSyncRecordClass: TSyncRecordClass; aTableName, aPrimaryKeyName: ShortString; aParentSyncTables: array of TSyncRecords; aMasterParentSyncTableIndex: ShortInt = -1); virtual;
    published
//		property SyncRecord[i: Cardinal]: TSyncRecord read GetSyncRecord; default;
    end;

{
TSyncTables = coleção de TSyncTable = coleção de TSyncRecord
}
    TSyncTables = class;

	TSyncTable = class (TCollectionItem)
    private
//    	FParentSyncTables: TSyncTables;
    	FSyncRecords: TSyncRecords;
        FTableName: ShortString;
        FPrimaryKeyName: ShortString;
        FMasterParentSyncTableIndex: ShortInt;
    protected
  //  	property ParentSyncTables: TSyncTables read FParentSyncTables;
    published
        property MasterParentSyncTableIndex: ShortInt read FMasterParentSyncTableIndex;
        property TableName: ShortString read FTableName;
        property PrimaryKeyName: ShortString read FPrimaryKeyName;
    	property SyncRecords: TSyncRecords read FSyncRecords write FSyncRecords;
    end;

    TSyncTableClass = class of TSyncTable;

    TSyncTables = class (TCollection)
	private
    	function GetSyncTable(i: Cardinal): TSyncTable;
	protected
      	function Add: TSyncTable;
    published
//        property SyncTable[i: Cardinal]: TSyncTable read GetSyncTable; default;
    end;

    TSyncFile = class (TObjectFile)
    private
    	FScript: String;
    	FSyncTables: TSyncTables;
    	function GetScript: String;
    protected
    	function MakeInsertCommand(aSynctable: TSyncRecords; aSyncRecord: TSyncRecord): String; virtual; abstract;
    	function MakeUpdateCommand(aSynctable: TSyncRecords; aSyncRecord: TSyncRecord): String; virtual; abstract;
        function MakeDeleteCommand(aSynctable: TSyncRecords; aSyncRecord: TSyncRecord): String; virtual; abstract;
    public
    	constructor Create(aOwner: TComponent); override;
        destructor Destroy; override;
	    procedure AddSyncTable(aSyncTableClass: TSyncTableClass; var SyncTableInstance; aSyncRecordClass: TSyncRecordClass; aTableName, aPrimaryKeyName: ShortString; aParentSyncTables: array of TSyncRecords; aMasterParentSyncTableIndex: ShortInt = -1);
        property ToScript: String read GetScript;
    published
    	property SyncTables: TSyncTables read FSyncTables write FSyncTables;
    end;

implementation

uses
  	SysUtils;

{ TSyncFile }

//procedure TSyncFile.AddSyncTable(aSyncTableClass: TSyncTableClass; var SyncTableInstance; aSyncRecordClass: TSyncRecordClass; aTableName, aPrimaryKeyName: ShortString; aParentSyncTables: array of TSyncRecords; aMasterParentSyncTableIndex: ShortInt = -1);
//begin
//    FSyncTables.Add := SyncTableInstance;
//    begin
//
//    end;
//    TSyncTable(SyncTableInstance) := aSyncTableClass.Create(aSyncRecordClass,aTableName,aPrimaryKeyName,aParentSyncTables,aMasterParentSyncTableIndex);
//    { TODO : Aqui é necessário verificar se o item já existe na lista antes de
//    por. Se já tiver substitui o item se nao adiciona }
////    FSyncTables.Add(TSyncTable(SyncTableInstance));
////	FSyncTables.Add; { cria o slot }
////    FSyncTables.Items[Pred(FSyncTables.Count)] := TCollectionItem(TSyncTable(SyncTableInstance));
//end;

constructor TSyncFile.Create(aOwner: TComponent);
begin
  	inherited;
//	FSyncTables := TObjectList.Create(False);
	FSyncTables := TSyncTables.Create(TSyncTable);
end;

destructor TSyncFile.Destroy;
begin
    FSyncTables.Free;
  	inherited;
end;

function TSyncFile.GetScript: String;
//	// IGNORE FOI COLOCADO POIS PODERIA NÃO SER INSERIDO DEVIDO A CAMPOS E CHAVES UNIQUE
//	INSERT_TEMPLATE = 'INSERT IGNORE INTO %s (%s) VALUES (%s);';
//  UPDATE_TEMPLATE = 'UPDATE %s SET %s WHERE (%s) = (%s);';
//  //UPDATE_TEMPLATE = 'INSERT INTO %s VALUES (%s) ON DUPLICATE KEY UPDATE %s;'#13#10;
//  // tem de usar o modo acima para update pois o registro que se está tentando atualizar pode ter sido excluído!
//  DELETE_TEMPLATE = 'DELETE IGNORE FROM %s WHERE (%s) = (%s);'#13#10;
//  DELTA_TEMPLATE = 'INSERT INTO DELTA (VA_NOMEDATABELA,VA_CHAVE,EN_ACAO,SM_USUARIO_ID,DT_DATAEHORADAACAO) VALUES (''%s'',%s,''%s'',%u,NOW());';
//  EXECINS_TEMPLATE =
//  { Inserção }
//  'DO @EXECUTABLE := IF(%s,''%s'',''DO 1'');'#13#10 +
//  'PREPARE EXECUTABLE FROM @EXECUTABLE;'#13#10 +
//  'EXECUTE EXECUTABLE;'#13#10 +
//  'DEALLOCATE PREPARE EXECUTABLE;'#13#10 +
//  { Criação de variavel autoinc }
//  'DO @EXECUTABLE := IF(@EXECUTABLE != ''DO 1'',''%s'',''DO 1'');'#13#10 +
//  'PREPARE EXECUTABLE FROM @EXECUTABLE;'#13#10 +
//  'EXECUTE EXECUTABLE;'#13#10 +
//  'DEALLOCATE PREPARE EXECUTABLE;'#13#10 +
//  { Atualização do delta } // só atualiza o delta se não houve problemas na última instrução e se a ultima variavel autoinc for <> 0
//  'DO @EXECUTABLE := IF(@EXECUTABLE = ''DO 2'' OR %s != 0,''%s'',''DO 1'');'#13#10 +
//  'PREPARE EXECUTABLE FROM @EXECUTABLE;'#13#10 +
//  'EXECUTE EXECUTABLE;'#13#10 +
//  'DEALLOCATE PREPARE EXECUTABLE;'#13#10 +
//  'DO @EXECUTABLE := ''DO 1'';'#13#10#13#10;
//	EXECUPD_TEMPLATE =
//  { Atualização }
//  'DO @EXECUTABLE := IF(%s,''%s'',''DO 1'');'#13#10 +
//  'PREPARE EXECUTABLE FROM @EXECUTABLE;'#13#10 +
//  'EXECUTE EXECUTABLE;'#13#10 +
//  'DEALLOCATE PREPARE EXECUTABLE;'#13#10 +
//  { Atualização do delta }
//  'DO @EXECUTABLE := IF(@EXECUTABLE != ''DO 1'',''%s'',''DO 1'');'#13#10 +
//  'PREPARE EXECUTABLE FROM @EXECUTABLE;'#13#10 +
//  'EXECUTE EXECUTABLE;'#13#10 +
//  'DEALLOCATE PREPARE EXECUTABLE;'#13#10 +
//  'DO @EXECUTABLE := ''DO 1'';'#13#10#13#10;



var
	ST: Word;
    SR: Cardinal;
    CurrentSyncTable: TSyncRecords;
    CurrentSyncRecord: TSyncRecord;
begin
//	FScript := '';
//    { Tem algo a sincronizar ? }
//    if FSyncTables.Count > 0 then
//        for ST := 0 to Pred(FSyncTables.Count) do
//        begin
//            CurrentSyncTable := TSyncTable(FSyncTables[ST]);
//            { Tem registros ? }
//            if CurrentSyncTable.Count > 0 then
//                for SR := 0 to Pred(CurrentSyncTable.Count) do
//                begin
//                	CurrentSyncRecord := CurrentSyncTable[SR];
//                    case CurrentSyncRecord.ActionPerformed of
//                    	apInsert: FScript := FScript + MakeInsertCommand(CurrentSyncTable,CurrentSyncRecord);
//                        apUpdate: FScript := FScript + MakeUpdateCommand(CurrentSyncTable,CurrentSyncRecord);
//                        apDelete: FScript := FScript + MakeDeleteCommand(CurrentSyncTable,CurrentSyncRecord);
//                    end;
//                end;
//        end;
end;

{ TSyncTable }

//constructor TSyncRecords.Create(aSyncRecordClass: TSyncRecordClass; aTableName, aPrimaryKeyName: ShortString; aParentSyncTables: array of TSyncRecords; aMasterParentSyncTableIndex: ShortInt);
//var
//	i: Byte;
//begin
//    inherited Create(aSyncRecordClass);
//	FParentSyncTables := TParentSyncRecords.Create(TParentSyncTable);
//    FTableName := aTableName;
//    FPrimaryKeyName := aPrimaryKeyName;
//    FMasterParentSyncRecordIndex := aMasterParentSyncTableIndex;
//    for i := 0 to High(aParentSyncTables) do
//        FParentSyncTables.Add.SyncTable := aParentSyncTables[i];
//end;

function TSyncRecords.GetSyncRecord(i: Cardinal): TSyncRecord;
begin
	Result := TSyncRecord(inherited Items[i]);
end;

function TSyncRecords.Add: TSyncRecord;
begin
	Result := TSyncRecord(inherited Add);
end;

{ TParentSyncTables }

//function TParentSyncRecords.Add: TParentSyncTable;
//begin
//	Result := TParentSyncTable(inherited Add);
//end;
//
//function TParentSyncRecords.GetParentSyncTable(i: Byte): TParentSyncTable;
//begin
//	Result := TParentSyncTable(inherited Items[i]);
//end;
//
//function TParentSyncRecords.GetParentSyncTableByReference(aTableName: ShortString; aPrimaryKey: Cardinal): TParentSyncTable;
//var
//	RC: Byte; { Record Collection }
//    RI: Cardinal; { Record Item }
//begin
//	Result := nil;
//	{ Para cada coleção de registros }
//	for RC := 0 to Pred(Count) do
//    	if TParentSyncTable(Items[RC]).SyncTable.TableName = aTableName then
//        begin
//        	{ Para cada registro da coleção }
//        	for RI := 0 to Pred(TParentSyncTable(Items[RC]).SyncTable.Count) do
//            	if TSyncRecord(TParentSyncTable(Items[RC]).SyncTable.Items[RI]).PrimaryKeyValue = aPrimaryKey then
//                begin
//                	Result := TParentSyncTable(Items[RC]);
//                    Break;
//                end;
//        	Break;
//        end;
//end;

{ TSyncTables }

function TSyncTables.Add: TSyncTable;
begin
	Result := TSyncTable(inherited Add);
end;

function TSyncTables.GetSyncTable(i: Cardinal): TSyncTable;
begin
	Result := TSyncTable(inherited Items[i]);
end;

end.
