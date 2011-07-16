unit ZTO.Win32.Db.ZeosLib.MySQL.Utils;

{$WEAKPACKAGEUNIT ON}

interface

uses Classes
   , ZConnection
   , ZDataSet
   , ZTO.Win32.Rtl.Common.Classes
   , ZTO.Win32.Db.ZeosLib.MySQL.Types
   , ZTO.Win32.Db.ZeosLib.Types;

procedure MySQLSetUserVariable(aZConnection: TZConnection; aVariableName: String; aValue: Int64); overload;
procedure MySQLSetUserVariable(aZConnection: TZConnection; aVariableName, aValue: String); overload;
procedure MySQLSetUserVariable(aZConnection: TZConnection; aVariableName: String; aValue: Boolean); overload;
procedure MySQLExecuteSQLScript(aZConnection: TZConnection; aSQLScript: String; aExecuteScriptCallBack: TExecuteScriptCallBack = nil; aSplitScriptCallBack: TSplitScriptCallBack   = nil);
procedure MySQLDataSetConfigure(aZConnection: TZConnection; var aDataSet: TZReadOnlyQuery; aSQLCommand: String; const aAutoCreateDataSet: Boolean = True);

implementation

uses SysUtils
   , ZAbstractRODataset
   , ZSQLProcessor
   , ZScriptParser
   , ZDBCIntfs
   , ZTO.Win32.Rtl.Common.FileUtils;

procedure MySQLSetUserVariable(aZConnection: TZConnection; aVariableName: String; aValue: Int64);
const
  VARIABLE_SET = 'SET @%s := %d';
begin
  MySQLExecuteSQLScript(aZConnection,Format(VARIABLE_SET,[aVariableName,aValue]));
end;

procedure MySQLSetUserVariable(aZConnection: TZConnection; aVariableName, aValue: String);
const
  VARIABLE_SET = 'SET @%s := ''%s''';
begin
  MySQLExecuteSQLScript(aZConnection,Format(VARIABLE_SET,[aVariableName,aValue]));
end;

procedure MySQLSetUserVariable(aZConnection: TZConnection; aVariableName: String; aValue: Boolean);
const
  VARIABLE_SET = 'SET @%s := %s';
begin
  MySQLExecuteSQLScript(aZConnection,Format(VARIABLE_SET,[aVariableName,BoolToStr(aValue,True)]));
end;

procedure MySQLDataSetConfigure(aZConnection: TZConnection; var aDataSet: TZReadOnlyQuery; aSQLCommand: String; const aAutoCreateDataSet: Boolean = True);
begin
  aSQLCommand := Trim(UpperCase(aSQLCommand));

  try
    try
      if (Pos('SELECT',aSQLCommand) <> 1) and (Pos('SHOW',aSQLCommand) <> 1) then
        raise EInvalidArgumentData.CreateFmt(RS_INVALID_ARGUMENT_DATA,['aSQLCommand',RS_ONLY_SELECT_ALLOWED]);

      if aAutoCreateDataSet then
      begin
        if Assigned(aDataSet) then
          aDataSet.Free;

        aDataSet := TZReadOnlyQuery.Create(aZConnection);
      end;

      if Assigned(aDataSet) then
        with aDataSet do
        begin
          Close;
          Connection := aZConnection;
          SQL.Text := aSQLCommand;
          Open;
        end;

    except
      on EAV: EAccessViolation do
      begin
        EAV.Message := Format(RS_ACCESS_VIOLATION,['MySQLDataSetConfigure',EAV.Message]);
        raise;
      end;

      on EZSE: EZSQLException do
      begin
        EZSE.Message := Format(RS_EZSE,['MySQLDataSetConfigure',EZSE.Message]);
        raise;
      end;

      on EIAD: EInvalidArgumentData do
      begin
        EIAD.Message := Format(RS_INVALID_ARGUMENT_DATA,['MySQLDataSetConfigure',EIAD.Message]);
        raise;
      end;

      on E: Exception do
      begin
        E.Message := Format(RS_EXCEPTION,['MySQLDataSetConfigure',E.Message]);
        raise;
      end;
    end;
  finally
  	{ N�o adianta ter um dataset constru�do se ele n�o sair deste
    procedimento ativado, por isso aqui n�s destru�mos }
   if Assigned(aDataSet) and not aDataSet.Active then
      FreeAndNil(aDataSet);
  end;
end;
{ TODO : Caso problemas aconte�am ao executar queries que tenham acentos nos valores, acredito que a solu��o ser� for�ar os par�metros das fun��es de execu��o, bem como de carregamento e salvamento de arquivos como UTF8String }
procedure SplitScript(const aZSQLProcessor         : TZSQLProcessor;
                      const aScriptParts           : TScriptParts;
                      const aSQLScript             : String;
                      const aSplitSQLScriptCallBack: TSplitScriptCallBack = nil);
var
  IsFile: Boolean;
  i: Cardinal;
  Statement: String;
  SpacePostion, ReturnPosition: Word;
begin
  if Pos('.SQL',UpperCase(Trim(aSQLScript))) = (Length(aSQLScript) - 3) then
  begin
    if not FileExists(aSQLScript) then
      raise Exception.Create('O arquivo de script especificado n�o existe');

    IsFile := True;
  end
  else if Trim(aSQLScript) <> '' then
    IsFile := False
  else
    raise Exception.Create('Nenhum arquivo ou texto de script foi informado');

  with aZSQLProcessor do
  begin
    Clear;

    ParamCheck := False;
    DelimiterType := dtSetTerm;
    Delimiter := 'DELIMITER';

    if IsFile then
      LoadFromFile(aSQLScript)
    else
      Script.Text := aSQLScript;

   	Script.Text := 'DELIMITER ;'#13#10 + Script.Text + #13#10'DELIMITER ;';

    if Assigned(aSplitSQLScriptCallBack) then
      aSplitSQLScriptCallBack(aZSQLProcessor,sseBeforeParse,aScriptParts);

   	Parse;

   	if Assigned(aSplitSQLScriptCallBack) then
      aSplitSQLScriptCallBack(aZSQLProcessor,sseAfterParse,aScriptParts);

    if Assigned(aSplitSQLScriptCallBack) then
     aSplitSQLScriptCallBack(aZSQLProcessor,sseBeforeSplitOperation,aScriptParts);

    for i := 0 to Pred(StatementCount) do
    begin
     	if Assigned(aSplitSQLScriptCallBack) then
  			aSplitSQLScriptCallBack(aZSQLProcessor,sseBeforeSplit,aScriptParts);

      Statement      := String(Statements[i]);
      SpacePostion   := Pos(#32,Statement);
      ReturnPosition := Pos(#13,Statement);

      if (SpacePostion <> 0) or (ReturnPosition <> 0) then
        with aScriptParts.Add do
        begin
          if SpacePostion > ReturnPosition then
          begin
            Delimiter := Copy(Statement,1,Pred(ReturnPosition));
            Delete(Statement,1,ReturnPosition);
          end
          else
          begin
            Delimiter := Copy(Statement,1,Pred(SpacePostion));
            Delete(Statement,1,SpacePostion);
          end;

          Script := Trim(Statement);
        end;

      if Assigned(aSplitSQLScriptCallBack) then
        aSplitSQLScriptCallBack(aZSQLProcessor,sseAfterSplit,aScriptParts);
    end;

    if Assigned(aSplitSQLScriptCallBack) then
			aSplitSQLScriptCallBack(aZSQLProcessor,sseAfterSplitOperation,aScriptParts);
  end;
end;

function MESSCallBack(const aSearchRec: TSearchRec; const aIsDirectory: Boolean): Boolean;
begin
  Result := True;

  if aIsDirectory then
    RemoveDir(aSearchRec.Name)
  else
    DeleteFile(aSearchRec.Name);
end;

procedure MySQLExecuteSQLScript(aZConnection: TZConnection; aSQLScript: String; aExecuteScriptCallBack: TExecuteScriptCallBack = nil; aSplitScriptCallBack: TSplitScriptCallBack   = nil);
const
  PARTSPERFILE = 120;
  DIVISIONTAG = '# == A INSTRU��O ACIMA POSSUI';
var
  i, FileNumber, PartNumber: Cardinal;
  TempPath, CurrentLine: String;
  ScriptFileName: TFileName;
  AuxTextFileRead: TStreamReader;
  AuxTextFileWrite: TStreamWriter;
  SearchRec: TSearchRec;
  ScriptParts: TScriptParts;
  Processor: TZSQLProcessor;
begin
  try
    TempPath := GetTemporaryPath + GetTemporaryName('MESS');  { (M)ySQL (E)xecute (S)ql (S)cript }

    { Diret�rio para arquivos tempor�rios }
    if not DirectoryExists(TempPath) then
      CreateDir(TempPath);

    if Pos('.SQL',UpperCase(Trim(aSQLScript))) = (Length(aSQLScript) - 3) then
    begin
      if not FileExists(aSQLScript) then
        raise Exception.Create('O arquivo de script especificado n�o existe');

      ScriptFileName := aSQLScript;
    end
    else if Trim(aSQLScript) <> '' then
    begin
      ScriptFileName := TempPath + '\SCRIPTFILE000000.SQL';
      SaveTextFile(aSQLScript,ScriptFileName);
    end
    else
      raise Exception.Create('Nenhum arquivo ou texto de script foi informado');

    { Aqui, ScriptFileName cont�m o nome do script inicial que ser� dividido }
    AuxTextFileWrite := nil;
    AuxTextFileRead := nil;
    FileNumber := 0;
    try
      if Assigned(aExecuteScriptCallBack) then
        aExecuteScriptCallBack(nil,esePreprocessingScript,nil);

      AuxTextFileRead := TStreamReader.Create(ScriptFileName,TEncoding.UTF8);

      PartNumber := 0;
      while not AuxTextFileRead.EndOfStream do
      begin
        CurrentLine := AuxTextFileRead.ReadLine;

        if Pos(DIVISIONTAG,CurrentLine) = 1 then
          Inc(PartNumber);

        if PartNumber mod PARTSPERFILE = 0 then
        begin
          Inc(PartNumber);
          { Grava a linha inteira que foi encontrada no arquivo atualmente
          aberto e fecha ele em seguida }
          if FileNumber > 0 then
          begin
            AuxTextFileWrite.WriteLine(CurrentLine);
            AuxTextFileWrite.Free;
          end;

          { Obt�m o pr�ximo n�mero de arquivo, cria-o e vai diretamente para o
          in�cio do loop }
          Inc(FileNumber);
          AuxTextFileWrite := TStreamWriter.Create(TempPath + Format('\SCRIPTFILE%.6U.SQL',[FileNumber]));
          AuxTextFileWrite.NewLine := #$0A; { Cria no formato do unix }

          if FileNumber = 1 then
            AuxTextFileWrite.WriteLine(CurrentLine);

          Continue;
        end;

        AuxTextFileWrite.WriteLine(CurrentLine);
      end;

     	if Assigned(aExecuteScriptCallBack) then
        aExecuteScriptCallBack(nil,esePostProcessingScript,nil);
    finally
      AuxTextFileRead.Free;
      AuxTextFileWrite.Free;
    end;

    ScriptParts := nil;
    Processor := nil;

    { Processa arquivos na pasta atual }
    if FindFirst(TempPath + '\SCRIPTFILE??????.SQL', 0, SearchRec) = 0 then
      try
        repeat
          if SearchRec.Name <> 'SCRIPTFILE000000.SQL' then
          { ==================================================================== }
            try
              Processor := TZSQLProcessor.Create(aZConnection);
              Processor.ParamCheck := False;
              Processor.Connection := aZConnection;
              Processor.DelimiterType := dtSetTerm;

              ScriptParts := TScriptParts.Create(TScriptPart);

              SplitScript(Processor,ScriptParts,TempPath + '\' + SearchRec.Name,aSplitScriptCallBack);

              if ScriptParts.Count > 0 then
              begin
                if aZConnection.Connected then
                begin

                  if Assigned(aExecuteScriptCallBack) then
                    aExecuteScriptCallBack(Processor,eseBeforeExecuteScript,ScriptParts);

                  for i := 0 to Pred(ScriptParts.Count) do
                  begin
                    Processor.Clear;
                    Processor.Delimiter := ScriptParts[i].Delimiter;
                    Processor.Script.Text := UTF8ToString(RawByteString(ScriptParts[i].Script));

                    if Assigned(aExecuteScriptCallBack) then
                      aExecuteScriptCallBack(Processor,eseBeforeExecuteScriptPart,ScriptParts);

                    Processor.Execute;

                    if Assigned(aExecuteScriptCallBack) then
                      aExecuteScriptCallBack(Processor,eseAfterExecuteScriptPart,ScriptParts);
                  end;

                  if Assigned(aExecuteScriptCallBack) then
                    aExecuteScriptCallBack(Processor,eseAfterExecuteScript,ScriptParts);
                end;
              end
              else
                raise Exception.Create('O arquivo selecionado n�o cont�m um script v�lido!');
            finally
              if Assigned(ScriptParts) then
                ScriptParts.Free;

              if Assigned(Processor) then
                Processor.Free;
            end;
          { ==================================================================== }
        until FindNext(SearchRec) <> 0;
      finally
        FindClose(SearchRec);
      end;
  finally
    { Limpa o diret�rio tempor�rio e exclui }
    ProcessFiles(TempPath,'*.*',MESSCallBack,True);
    RemoveDir(TempPath);
  end;
end;

end.



//procedure TXXXDataModule.MySQLAddIndex(aZConnection: TZConnection; aTableName, aIndexName, aFieldNames: AnsiString; aIndexKind: TMySQLIndexKind = mikIndex);
//var
//	IndexDef: AnsiString;
//begin
//	case aIndexKind of
//    mikIndex: IndexDef := 'KEY ' + AnsiString(UpperCase(String(aIndexName)));
//    mikPrimary: IndexDef := 'PRIMARY KEY';
//    mikUnique: IndexDef := 'UNIQUE KEY ' + AnsiString(UpperCase(String(aIndexName)));
//    mikFullText: IndexDef := 'FULLTEXT KEY ' + AnsiString(UpperCase(String(aIndexName)));
//    mikSpatial: IndexDef := 'SPATIAL KEY ' + AnsiString(UpperCase(String(aIndexName)));
//  end;
//  ExecuteQuery(aZConnection,AnsiString('ALTER TABLE ' + UpperCase(String(aTableName)) + ' ADD ' + String(IndexDef) + ' (' + String(aFieldNames) + ')'));
//end;
//
//procedure TXXXDataModule.MySQLDropIndex(aZConnection: TZConnection; aTableName, aIndexName: AnsiString);
//begin
//	ExecuteQuery(aZConnection,AnsiString('ALTER TABLE ' + UpperCase(String(aTableName)) + ' DROP KEY ' + UpperCase(String(aIndexName))));
//end;
//
//class function TXXXDataModule.MySQLFormat(const aFormat: AnsiString; const aArgs: array of const): AnsiString;
//var
//	FS: TFormatSettings;
//begin
//  ZeroMemory(@FS,SizeOf(TFormatSettings));
//	GetLocaleFormatSettings(1033,FS); { formato de pontua��o de numeros no padr�o americano }
//	Result := AnsiString(Format(String(aFormat),aArgs,FS));
//
//{ TODO -oCarlos Feitoza -cDESAFIO : Futuramente tente fazer convers�es substituindo tipos de delphi como TDateTime por tipos do MySQL que fazem sentido em uma AnsiString como "00000000000000". Talvez seja imposs�vel detectar os tipos corretamente! }
////    for i := 0 to UltimoElemento do
////    begin
////    	with aArgs[i] do
////        	case VType of
////            	vtInteger:  Result := Result + IntToStr(VInteger);
////                vtBoolean:  Result := Result + BooleanStrings[VBoolean];
////                vtChar:   Result := Result + VChar;
////                vtExtended: Result := Result + FloatToStr(VExtended^);
////                vtString:   Result := Result + VString^;
////                vtPChar:  Result := Result + VPChar;
////                vtObject:   Result := Result + VObject.ClassName;
////                vtClass:  Result := Result + VClass.ClassName;
////                vtAnsiString: Result := Result + AnsiString(VAnsiString);
////                vtCurrency: Result := Result + CurrToStr(VCurrency^);
////                vtVariant:  Result := Result + AnsiString(VVariant^);
////                vtInt64:  Result := Result + IntToStr(VInt64^);
////            end;
////
////    	if i <> UltimoElemento then
////        	Result := Result + aSeparator;
////    end;
//
//end;




