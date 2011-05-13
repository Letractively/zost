//"There are only 10 types of people in this world...
//those who understand binary, and those who don't"
unit USyncStructures;

interface

uses
  	Classes, UObjectFile, Contnrs;

type
    ///    apNothing = Nada a ser realizado
	///    apSynKey = Atualizar chave
    ///    apInsert = Inserção
    ///    apUpdate = Atualização
    ///    apDelete = Excluir
    TActionPerformed = (apNothing,apSynKey,apInsert,apUpdate,apDelete);

    TSyncRecord = class;

    TSyncKey = class(TPersistent)
    private
    	FStoredValue: Int64;
        FSyncRecord: TSyncRecord;
    protected
    	function ReferencedValue(aTableName: AnsiString): AnsiString; virtual;
    	property SyncRecord: TSyncRecord read FSyncRecord;
    public
    	constructor Create(aSyncRecord: TSyncRecord);
    published
		property StoredValue: Int64 read FStoredValue write FStoredValue;
    end;

    TSyncTable = class;

	TSyncRecord = class(TCollectionItem)
  private
    FActionPerformed: TActionPerformed;
    FNewPrimaryKeyValue: Int64;
    FOldPrimaryKeyValue: Int64;
    FUpdateDateTime: TDateTime;
    FUpdateUser: Cardinal;
    FCreateDateTime: TDateTime;
    FCreateUser: Cardinal;
	  function GetSyncTable: TSyncTable;
    function GetMySelf: TSyncRecord;
	public
    function InsertClause(const aValues, aUsePrimaryKeyValue: Boolean): AnsiString; virtual; abstract;
    function UpdateClause: AnsiString; virtual; abstract;
	  function PrimaryKeyValue: Int64; virtual; abstract;
    property SyncTable: TSyncTable read GetSyncTable;
    property MySelf: TSyncRecord read GetMySelf;
  published
    property ActionPerformed: TActionPerformed read FActionPerformed write FActionPerformed;
    property NewPrimaryKeyValue: Int64 read FNewPrimaryKeyValue write FNewPrimaryKeyValue;
    property OldPrimaryKeyValue: Int64 read FOldPrimaryKeyValue write FOldPrimaryKeyValue;
    property CreateUser: Cardinal read FCreateUser write FCreateUser;
    property UpdateUser: Cardinal read FUpdateUser write FUpdateUser;
    property CreateDateTime: TDateTime read FCreateDateTime write FCreateDateTime;
    property UpdateDateTime: TDateTime read FUpdateDateTime write FUpdateDateTime;
  end;

    TSyncRecordClass = class of TSyncRecord;

    TSyncedTables = class;

	TSyncTable = class (TCollection)
    private
    	FParentSyncTables: TSyncedTables;
        FTableName: AnsiString;
        FPrimaryKeyName: AnsiString;
        FMasterParentSyncTableIndex: ShortInt;
        FLastPrimaryKeyValue: Int64;
//        procedure QuickSort(L, R: Integer);
//        procedure Sort;
        function GetSyncRecord(i: Cardinal): TSyncRecord;
	    function GetParentSyncTableByName(aTableName: AnsiString): TSyncTable;
	    function GetSyncRecordByPrimaryKey(aPrimaryKey: Int64): TSyncRecord;
        procedure MoveActionToTop(const aActionPerformed: TActionPerformed);
    protected
//        function Compare(SyncRecord1, SyncRecord2: TSyncRecord): Integer; virtual;
  	public
	    constructor Create(aSyncRecordClass: TSyncRecordClass; aTableName, aPrimaryKeyName: AnsiString; aParentSyncTables: array of TSyncTable; aMasterParentSyncTableIndex: ShortInt = -1); virtual;
    	function Add: TSyncRecord;
        property SyncRecord[i: Cardinal]: TSyncRecord read GetSyncRecord; default;
        property SyncRecordByPrimaryKey[aPrimaryKey: Int64]: TSyncRecord read GetSyncRecordByPrimaryKey;
        property ParentSyncTableByName[aTableName: AnsiString]: TSyncTable read GetParentSyncTableByName;
    published
        property LastPrimaryKeyValue: Int64 read FLastPrimaryKeyValue write FLastPrimaryKeyValue;
        property MasterParentSyncTableIndex: ShortInt read FMasterParentSyncTableIndex;
        property TableName: AnsiString read FTableName;
        property PrimaryKeyName: AnsiString read FPrimaryKeyName;
    end;

    TSyncTableClass = class of TSyncTable;

    TSyncedTable = class (TCollectionItem)
    private
	    FSyncedTable: TSyncTable;
    public
    	property SyncedTable: TSyncTable read FSyncedTable write FSyncedTable;
    end;

    TSyncedTables = class (TCollection)
	private
    	function GetSyncedTable(i: Cardinal): TSyncedTable;
    public
     	function Add: TSyncedTable;
        function FindSyncedTable(aTableName: AnsiString; out aFoundIndex: Word): Boolean;
        property SyncedTable[i: Cardinal]: TSyncedTable read GetSyncedTable; default;
    end;

    { TODO -oCarlos Feitoza -cMelhoria : 
crie uma propriedade protected para FUsePrimaryKeyValue e use nas classes filhas
isso evita ter que passar por parâmetro em InsertCommand pois no create ela já é atribuída }
    TSyncFile = class (TObjectFile)
    private
    	FSyncedTables: TSyncedTables;
        FUsePrimaryKeyValue: Boolean;
    	function GetScript: AnsiString;
    protected
    	function InsertCommand(aSynctable: TSyncTable; aSyncRecord: TSyncRecord; const aUsePrimaryKeyValue: Boolean): AnsiString; virtual; abstract;
    	function UpdateCommand(aSynctable: TSyncTable; aSyncRecord: TSyncRecord): AnsiString; virtual; abstract;
        function DeleteCommand(aSynctable: TSyncTable; aSyncRecord: TSyncRecord): AnsiString; virtual; abstract;
        function SynKeyCommand(aSynctable: TSyncTable; aSyncRecord: TSyncRecord): AnsiString; virtual; abstract;
		function PreTbActnCmds(aSynctable: TSyncTable): AnsiString; virtual;
		function PosTbActnCmds(aSynctable: TSyncTable): AnsiString; virtual;
		function PreDbActnCmds: AnsiString; virtual;
		function PosDbActnCmds: AnsiString; virtual;
    public
    	constructor Create(const aOwner: TComponent; const aUsePrimaryKeyValue: Boolean); reintroduce; virtual;
        destructor Destroy; override;
        { Se precisar sobreponha este método para detectar nomes de tabela,
        nomes de chave primária, tableas mestre, etc. }
	    procedure AddSyncTable(aSyncTableClass: TSyncTableClass; aSyncRecordClass: TSyncRecordClass; var aSyncTableInstance; aTableName, aPrimaryKeyName: AnsiString; aParentSyncTables: array of TSyncTable; aMasterParentSyncTableIndex: ShortInt = -1); virtual;
        property ToScript: AnsiString read GetScript;
    	property SyncedTables: TSyncedTables read FSyncedTables write FSyncedTables;
    end;

implementation

uses
  	SysUtils, StrUtils;

{$HINTS OFF}
type
    THelperCollection = class(TPersistent)
    private
        FItemClass: TCollectionItemClass;
        FItems: TList;
    end;
{$HINTS ON}

{ TSyncFile }

procedure TSyncFile.AddSyncTable(aSyncTableClass: TSyncTableClass; aSyncRecordClass: TSyncRecordClass; var aSyncTableInstance; aTableName, aPrimaryKeyName: AnsiString; aParentSyncTables: array of TSyncTable; aMasterParentSyncTableIndex: ShortInt = -1);
var
    FoundIndex: Word;
begin
    TSyncTable(aSyncTableInstance) := aSyncTableClass.Create(aSyncRecordClass,aTableName,aPrimaryKeyName,aParentSyncTables,aMasterParentSyncTableIndex);

	if FSyncedTables.FindSyncedTable(aTableName,FoundIndex) then
    	FSyncedTables.Delete(FoundIndex);

	with FSyncedTables.Add do
   		SyncedTable := TSyncTable(aSyncTableInstance);
end;

constructor TSyncFile.Create(const aOwner: TComponent; const aUsePrimaryKeyValue: Boolean);
begin
  	inherited Create(aOwner);
    FSyncedTables := TSyncedTables.Create(TSyncedTable);
    FUsePrimaryKeyValue := aUsePrimaryKeyValue;
end;

destructor TSyncFile.Destroy;
begin
    FSyncedTables.Free;
  	inherited;
end;

function TSyncFile.GetScript: AnsiString;
var
	ST: Word;
    SR: Cardinal;
    CurrentSyncTable: TSyncTable;
    CurrentSyncRecord: TSyncRecord;
begin
	Result := '';
    Result := Result + PreDbActnCmds;
    { Tem algo a sincronizar ? }
    if FSyncedTables.Count > 0 then
    begin
        for ST := 0 to Pred(FSyncedTables.Count) do
        begin
            CurrentSyncTable := FSyncedTables[ST].SyncedTable;

            Result := Result + PreTbActnCmds(CurrentSyncTable);
            { Tem registros ? }
            if CurrentSyncTable.Count > 0 then
            begin
                { Coloca os comandos de sincronização de chaves no topo da lista,
                pois eles tem de ser executados primeiro }
                CurrentSyncTable.MoveActionToTop(apSynKey);
                for SR := 0 to Pred(CurrentSyncTable.Count) do
                begin
                	CurrentSyncRecord := CurrentSyncTable[SR];
                    case CurrentSyncRecord.ActionPerformed of
                    	apInsert: Result := Result + InsertCommand(CurrentSyncTable,CurrentSyncRecord,FUsePrimaryKeyValue);
                        apUpdate: Result := Result + UpdateCommand(CurrentSyncTable,CurrentSyncRecord);
                        apDelete: Result := Result + DeleteCommand(CurrentSyncTable,CurrentSyncRecord);
                        apSynKey: Result := Result + SynKeyCommand(CurrentSyncTable,CurrentSyncRecord);
                    end;
                end;
            end;
            Result := Result + PosTbActnCmds(CurrentSyncTable);
        end;
    end;
	Result := Result + PosDbActnCmds;
end;

function TSyncFile.PosDbActnCmds: AnsiString;
begin
	Result := '# COMANDOS "PÓS AÇÕES" NO BANCO DE DADOS'#13#10;
end;

function TSyncFile.PosTbActnCmds(aSynctable: TSyncTable): AnsiString;
begin
	Result := '# COMANDOS "PÓS AÇÕES" PARA A TABELA ' + aSynctable.TableName + #13#10;
end;

function TSyncFile.PreDbActnCmds: AnsiString;
begin
	Result := '# COMANDOS "PRÉ AÇÕES" NO BANCO DE DADOS'#13#10;
end;

function TSyncFile.PreTbActnCmds(aSynctable: TSyncTable): AnsiString;
begin
	Result := '# COMANDOS "PRE AÇÕES" PARA A TABELA ' + aSynctable.TableName + #13#10;
end;

{ TSyncTable }

//function TSyncTable.Compare(SyncRecord1, SyncRecord2: TSyncRecord): Integer;
//begin
    { Classes descendentes devem sobrescrever este método e realizar typecasts
    necessários em Item1 e Item2 para o tipo adequado usando o exemplo a seguir
    para comparação

    if SyncRecord1.MyField < SyncRecord2.MyField
        Result := -1
    else if SyncRecord1.MyField > SyncRecord2.MyField
        Result := 1
    else
        Result = 0 // Não ordena nada!
    }

    { TODO -oCarlos Feitoza -cEXPLICAÇÃO : Definitivamente explicado! O retorno
    desta função não é tão complicado de entender, basta apenas ter em mente que
    esta função serve apenas para indicar ao algorítmo de ordenação quem é maior
    ou menor ou se ambos os itens sendo comparados são iguais, veja. O erro mais
    comum de interpretação é aquele em que se acha que se deve retornar um
    número para forçar o algorítmo a trocar a posição dos itens. O algorítmo
    sempre ordena de forma crescente, o retorno da função indica apenas se a
    ordenação deve ser feita ou não.

    Caso o Item1 seja menor que o Item2, segundo seus critérios, informe isto ao
    algorítmo de ordenação retornando -1

    Caso o Item1 seja maior que o Item2, segundo seus critérios, informe isto ao
    algorítmo de ordenação retornando 1

    Caso o Item1 seja igual ao Item2, segundo seus critérios, informe isto ao
    algorítmo de ordenação retornando 0 (zero)
    }

//    Result := 0;
//end;

//procedure TSyncTable.QuickSort(L, R: Integer);
//var
//    I, J, P: Integer;
//    CompareI, CompareJ: -1..1;
//
//procedure ExchangeItems(Index1, Index2: Integer);
//var
//    SortList: TList;
//    Temp: TSyncRecord;
//begin
//    { Este cast nos permite obter elementos privados na classe base }
//    SortList := THelperCollection(Self).FItems;
//
//    Temp := SortList.Items[Index1];
//    SortList.Items[Index1] := SortList.Items[Index2];
//    SortList.Items[Index2] := Temp;
//end;
//
//begin
//    repeat
//        I := L;
//        J := R;
//        P := (L + R) shr 1;
//        repeat
//
//            repeat
//                CompareI := Compare(Self[I], Self[P]);
//                if CompareI < 0 then
//                    Inc(I);
//            until CompareI >= 0;
//
//            repeat
//                CompareJ := Compare(Self[J], Self[P]);
//                if CompareJ > 0 then
//                    Dec(J);
//            until CompareJ <= 0;
//
////            while Compare(Self[I], Self[P]) < 0 do
////                Inc(I);
////
////            while Compare(Self[J], Self[P]) > 0 do
////                Dec(J);
//
//            if I <= J then
//            begin
//                { Tudo acontece como no algorítmo original exceto a troca dos
//                itens. No algorítmo original a troca de dois itens iguais sempre
//                era feita pois se dois itens são iguais não há problema em
//                trocá-los de lugar. Nesta implementação a troca dos ítens só
//                será feita se o retorno da função Compare tiver sido diferente
//                de zero em uma das chamadas acima, o que indica que precisamos
//                trocar a posição dos itens }
//                if (CompareI <> 0) or (CompareJ <> 0) then
//                    ExchangeItems(I, J);
//
//                if P = I then
//                    P := J
//                else if P = J then
//                    P := I;
//
//                Inc(I);
//                Dec(J);
//            end;
//        until I > J;
//
//        if L < J then
//            QuickSort(L, J);
//        L := I;
//    until I >= R;
//end;


//procedure TSyncTable.Sort;
//begin
//    if Count > 1 then
//        QuickSort(0, pred(Count));
//end;

constructor TSyncTable.Create(aSyncRecordClass: TSyncRecordClass; aTableName, aPrimaryKeyName: AnsiString; aParentSyncTables: array of TSyncTable; aMasterParentSyncTableIndex: ShortInt = -1);
var
	i: Byte;
begin
    inherited Create(aSyncRecordClass);
	FParentSyncTables := TSyncedTables.Create(TSyncedTable);
    FTableName := aTableName;
    FPrimaryKeyName := aPrimaryKeyName;
    FLastPrimaryKeyValue := High(Int64);
    FMasterParentSyncTableIndex := aMasterParentSyncTableIndex;
    if Length(aParentSyncTables) > 0 then
	    for i := 0 to High(aParentSyncTables) do
    		FParentSyncTables.Add.SyncedTable := aParentSyncTables[i];
end;

function TSyncTable.GetParentSyncTableByName(aTableName: AnsiString): TSyncTable;
var
	PST: Byte; { Parent SyncTable }
begin
	Result := nil;

    if FParentSyncTables.Count > 0 then
    	for PST := 0 to Pred(FParentSyncTables.Count) do
        	if FParentSyncTables[PST].SyncedTable.TableName = aTableName then
            begin
                Result := FParentSyncTables[PST].SyncedTable;
            	Break;
            end;
end;

function TSyncTable.GetSyncRecordByPrimaryKey(aPrimaryKey: Int64): TSyncRecord;
var
	SR: Cardinal; { SyncRecord }
begin
	Result := nil;

	if Count > 0 then
    	for SR := 0 to Pred(Count) do
	      	if GetSyncRecord(SR).PrimaryKeyValue = aPrimaryKey then
            begin
            	Result := GetSyncRecord(SR);
                Break;
            end;
end;

procedure TSyncTable.MoveActionToTop(const aActionPerformed: TActionPerformed);
var
    i: Integer;
    CollectionList, ActionList: TList;
begin
    ActionList := nil;
    CollectionList := THelperCollection(Self).FItems;

    try
        ActionList := TList.Create;

        i := 0;
        while i < CollectionList.Count do
        begin
            if TSyncRecord(CollectionList[i]).ActionPerformed = aActionPerformed then
            begin
                ActionList.Add(CollectionList[i]);
                CollectionList.Delete(i);
                Continue;
            end;

            Inc(i);
        end;


        if ActionList.Count > 0 then
            for i := Pred(ActionList.Count) downto 0 do
                CollectionList.Insert(0,ActionList[i]);

    finally
        if Assigned(ActionList) then
            ActionList.Free;
    end;
end;

function TSyncTable.GetSyncRecord(i: Cardinal): TSyncRecord;
begin
	Result := TSyncRecord(inherited Items[i]);
end;

function TSyncTable.Add: TSyncRecord;
begin
	Result := TSyncRecord(inherited Add);
end;

{ TSyncedTables }

function TSyncedTables.Add: TSyncedTable;
begin
	Result := TSyncedTable(inherited Add);
end;

function TSyncedTables.FindSyncedTable(aTableName: AnsiString; out aFoundIndex: Word): Boolean;
var
    i: Word;
begin
	Result := False;
    if Count > 0 then
    	for i := 0 to Pred(Count) do
        	if SyncedTable[i].SyncedTable.TableName = aTableName then
            begin
                Result := True;
                aFoundIndex := i;
                Break;
            end;
end;

function TSyncedTables.GetSyncedTable(i: Cardinal): TSyncedTable;
begin
	Result := TSyncedTable(inherited Items[i]);
end;

{ TSyncKey }

constructor TSyncKey.Create(aSyncRecord: TSyncRecord);
begin
    FSyncRecord := aSyncRecord;
end;

function TSyncKey.ReferencedValue(aTableName: AnsiString): AnsiString;
begin
  { TODO -oCarlos Feitoza -cEXPLICAÇÃO : Se o valor armazenado na chave for
  zero, significa que é um valor inválido para uma chave, logo usa-se NULL }
	Result := AnsiString(IfThen(FStoredValue > 0,IntToStr(FStoredValue),'NULL'));
end;

{ TSyncRecord }

function TSyncRecord.GetMySelf: TSyncRecord;
begin
    Result := Self;
end;

function TSyncRecord.GetSyncTable: TSyncTable;
begin
	Result := TSyncTable(Collection);
end;

end.
