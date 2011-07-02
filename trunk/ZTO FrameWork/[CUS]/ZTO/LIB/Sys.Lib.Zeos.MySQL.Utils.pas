unit Sys.Lib.Zeos.MySQL.Utils;

interface

uses SysUtils
   , ZTO.Win32.Rtl.Common.Classes
   , ZTO.Win32.Rtl.Common.FileUtils
   , Sys.Lib.Zeos.Types
   , Sys.Lib.Types
   , ZConnection
   , ZSQLProcessor
   , ZDataset;

//procedure MySQLExecuteScriptFile(const aZConnection          : TZConnection;
//                                 const aSQLScriptFile        : TFileName;
//                                 const aExecuteScriptCallBack: TExecuteScriptCallBack = nil;
//                                 const aSplitScriptCallBack  : TSplitScriptCallBack   = nil);

//procedure MySQLExecuteScriptText(const aZConnection          : TZConnection;
//                                 const aSQLScriptText        : String;
//                                 const aExecuteScriptCallBack: TExecuteScriptCallBack = nil;
//                                 const aSplitScriptCallBack  : TSplitScriptCallBack   = nil);

//procedure MySQLDataSetConfigure(const aZConnection      : TZConnection;
//                                var   aDataSet          : TZReadOnlyQuery;
//                                      aSQLCommand       : String;
//                                const aAutoCreateDataSet: Boolean = True);

implementation

uses Forms
   , Controls
   , ZScriptParser
   , ZDBCIntfs;

//resourcestring
//  RS_EZDE = 'Erro ao tentar conectar-se com o banco de dados no método %s.'#13#10#13#10'%s';
//  RS_EZSE = 'Erro ao executar as instruções SQL com o método %s.'#13#10#13#10'%s';

//procedure SplitScript(const aZSQLProcessor         : TZSQLProcessor;
//                      const aScriptParts           : TScriptParts;
//                      const aSQLScriptText         : String;
//                      const aSplitSQLScriptCallBack: TSplitScriptCallBack = nil);
//var
//  i: Cardinal;
//  Statement: String;
//  SpacePostion, ReturnPosition: Byte;
//begin
//  try
//    Screen.Cursor := crHourGlass;
//
//    with aZSQLProcessor do
//    begin
//      Clear;
//
//      if Assigned(aSplitSQLScriptCallBack) then
//	      aSplitSQLScriptCallBack(aZSQLProcessor
//                               ,sseBeforeParse
//                               ,aScriptParts);
//
//      ParamCheck := False;
// 	    DelimiterType := dtSetTerm;
//      Delimiter := 'DELIMITER';
//     	Script.Text := 'DELIMITER ;'#13#10 + aSQLScriptText + #13#10'DELIMITER ;';
//
//     	Parse;
//
//     	if Assigned(aSplitSQLScriptCallBack) then
//        aSplitSQLScriptCallBack(aZSQLProcessor
//                               ,sseAfterParse
//                               ,aScriptParts);
//
//      if Assigned(aSplitSQLScriptCallBack) then
//	      aSplitSQLScriptCallBack(aZSQLProcessor
//                               ,sseBeforeSplitOperation
//                               ,aScriptParts);
//
//      for i := 0 to Pred(StatementCount) do
//      begin
//       	if Assigned(aSplitSQLScriptCallBack) then
//					aSplitSQLScriptCallBack(aZSQLProcessor
//                                 ,sseBeforeSplit
//                                 ,aScriptParts);
//
//        Statement      := String(Statements[i]);
//        SpacePostion   := Pos(#32,Statement);
//        ReturnPosition := Pos(#13,Statement);
//
//        if (SpacePostion <> 0) or (ReturnPosition <> 0) then
//          with aScriptParts.Add do
//          begin
//            if SpacePostion > ReturnPosition then
//            begin
//              Delimiter := Copy(Statement,1,Pred(ReturnPosition));
//              Delete(Statement,1,ReturnPosition);
//            end
//            else
//            begin
//              Delimiter := Copy(Statement,1,Pred(SpacePostion));
//              Delete(Statement,1,SpacePostion);
//            end;
//
//            Script := Trim(Statement);
//          end;
//
//        if Assigned(aSplitSQLScriptCallBack) then
//          aSplitSQLScriptCallBack(aZSQLProcessor
//                                 ,sseAfterSplit
//                                 ,aScriptParts);
//      end;
//
//      if Assigned(aSplitSQLScriptCallBack) then
//  			aSplitSQLScriptCallBack(aZSQLProcessor
//                               ,sseAfterSplitOperation
//                               ,aScriptParts);
//    end;
//  finally
//    Screen.Cursor := crDefault;
//  end;
//end;

//procedure MySQLExecuteScriptText(const aZConnection           : TZConnection;
//                                 const aSQLScriptText         : String;
//                                 const aExecuteScriptCallBack : TExecuteScriptCallBack = nil;
//                                 const aSplitScriptCallBack   : TSplitScriptCallBack   = nil);
//var
//  i          : Cardinal;
//  Processor  : TZSQLProcessor;
//  ScriptParts: TScriptParts;
//begin
//  if Trim(aSQLScriptText) = '' then
//    raise EInvalidParameter.Create('MySQLExecuteScriptText'
//                                  ,'aSQLScriptText'
//                                  ,'Script foi informado');
//  Processor := nil;
//  ScriptParts := nil;
//
//  try
//    Processor            := TZSQLProcessor.Create(nil);
//    Processor.Connection := aZConnection;
//  	ScriptParts          := TScriptParts.Create(TScriptPart);
//    { PASSO 1:  Dividindo o script de acordo com seus delimitadores }

//    SplitScript(Processor
//               ,ScriptParts
//               ,aSQLScriptText
//               ,aSplitScriptCallBack);

//  	{ PASSO 2: Executando cada uma das partes do script dividido }
//		if ScriptParts.Count > 0 then
//    begin
//      if aZConnection.Connected then
//      begin
//        Processor.ParamCheck := False;
//        Processor.DelimiterType := dtSetTerm;
//
//        if Assigned(aExecuteScriptCallBack) then
//          aExecuteScriptCallBack(Processor
//                                ,eseBeforeExecuteScript
//                                ,ScriptParts);

//        for i := 0 to Pred(ScriptParts.Count) do
//        begin
//          Processor.Clear;
//          Processor.Delimiter := ScriptParts[i].Delimiter;
//          Processor.Script.Text := ScriptParts[i].Script;

//         	if Assigned(aExecuteScriptCallBack) then
//         		aExecuteScriptCallBack(Processor
//                                  ,eseBeforeExecuteScriptPart
//                                  ,ScriptParts);

//          Processor.Execute;

//         	if Assigned(aExecuteScriptCallBack) then
//  					aExecuteScriptCallBack(Processor
//                                  ,eseAfterExecuteScriptPart
//                                  ,ScriptParts);
//        end;

//       	if Assigned(aExecuteScriptCallBack) then
//          aExecuteScriptCallBack(Processor
//                                ,eseAfterExecuteScript
//                                ,ScriptParts);
//      end;
//    end
//    else
//      raise Exception.Create('O script selecionado não é um script válido ou está vazio!');
      
//  finally
//    if Assigned(ScriptParts) then
//      ScriptParts.Free;
//
//    if Assigned(Processor) then
//      Processor.Free;
//  end;
//end;

//procedure MySQLExecuteScriptFile(const aZConnection           : TZConnection;
//                                 const aSQLScriptFile         : TFileName;
//                                 const aExecuteScriptCallBack : TExecuteScriptCallBack = nil;
//                                 const aSplitScriptCallBack   : TSplitScriptCallBack   = nil);
//begin
//  if Trim(aSQLScriptFile) = '' then
//    raise EInvalidParameter.Create('MySQLExecuteScriptFile'
//                                  ,'aSQLScriptFile'
//                                  ,'Nenhum arquivo de script foi informado');
//
//  if not FileExists(aSQLScriptFile) then
//    raise EInvalidParameter.Create('MySQLExecuteScriptFile'
//                                  ,'aSQLScriptFile'
//                                  ,'O arquivo especificado não existe');
//
//  MySQLExecuteScriptText(aZConnection
//                        ,LoadTextFile(aSQLScriptFile)
//                        ,aExecuteScriptCallBack
//                        ,aSplitScriptCallBack);
//end;

//procedure MySQLDataSetConfigure(const aZConnection      : TZConnection;
//                                var   aDataSet          : TZReadOnlyQuery;
//                                      aSQLCommand       : String;
//                                const aAutoCreateDataSet: Boolean = True);
//begin
//  aSQLCommand := Trim(UpperCase(aSQLCommand));

//  { Colocando em minúsculo aquilo que tem de ser minúsculo }
//  aSQLCommand := StringReplace(aSQLCommand,'\R','\r',[rfReplaceAll]);
//  aSQLCommand := StringReplace(aSQLCommand,'\N','\n',[rfReplaceAll]);

//  try
//    try
//      if (Pos('SELECT',aSQLCommand) <> 1) and (Pos('SHOW',aSQLCommand) <> 1) then
//        raise EInvalidArgumentData.CreateFmt(RS_INVALID_ARGUMENT_DATA,['aSQLCommand',RS_ONLY_SELECT_ALLOWED]);

//      if aAutoCreateDataSet then
//      begin
//        if Assigned(aDataSet) then
//          aDataSet.Free;

//        aDataSet := TZReadOnlyQuery.Create(aZConnection);
//      end;

//      if Assigned(aDataSet) then
//        with aDataSet do
//        begin
//          Close;
//          Connection := aZConnection;
//          SQL.Text := aSQLCommand;
//          Open;
//        end;

//    except
//      on EAV: EAccessViolation do
//      begin
//        EAV.Message := Format(RS_ACCESS_VIOLATION,['MySQLDataSetConfigure',EAV.Message]);
//        raise;
//      end;

//      on EZSE: EZSQLException do
//      begin
//        EZSE.Message := Format(RS_EZSE,['MySQLDataSetConfigure',EZSE.Message]);
//        raise;
//      end;

//      on EIAD: EInvalidArgumentData do
//      begin
//        EIAD.Message := Format(RS_INVALID_ARGUMENT_DATA,['MySQLDataSetConfigure',EIAD.Message]);
//        raise;
//      end;

//      on E: Exception do
//      begin
//        E.Message := Format(RS_EXCEPTION,['MySQLDataSetConfigure',E.Message]);
//        raise;
//      end;
//    end;
//  finally
//  	{ Não adianta ter um dataset construído se ele não sair deste
//    procedimento ativado, por isso aqui nós destruímos }
//   if Assigned(aDataSet) and not aDataSet.Active then
//      FreeAndNil(aDataSet);
//  end;
//end;


end.


//    if Trim(aSQLScriptFile) <> '' then
//    begin
//		if not FileExists(aSQLScriptFile) then
//    		raise Exception.Create('O arquivo especificado não existe fisicamente');
//    end
//    else if Trim(aSQLScriptText) = '' then
//    	raise Exception.Create('Nenhum arquivo ou texto de script foi informado');
//
//    try
//	    { PASSO 1:  Dividindo o script de acordo com seus delimitadores }
//    	ScriptParts := nil;
//	    SplitSQLScript(aZConnection
//                      ,ScriptParts
//                      ,aSQLScriptFile
//                      ,aSQLScriptText
////                      ,aForeignKeysCheck
//                      ,aSplitSQLScriptCallBack);
//
//    	{ PASSO 2: Executando cada uma das partes do script dividido }
//		if ScriptParts.Count > 0 then
//        begin
//            if aZConnection.Connected then
//            begin
//                Processor := nil;
//                try
//
//                    Processor := TZSQLProcessor.Create(aZConnection);
//                    Processor.ParamCheck := False;
//                    Processor.Connection := aZConnection;
//                    Processor.DelimiterType := dtSetTerm;
//
//                    { TODO -oCarlos Feitoza -cCORREÇÃO : em ultimo caso passe processorevents como parametro na função callback (eu prefiro que não seja assim...) }
//		        	if Assigned(aExecuteSQLScriptCallBack) then
//	                    aExecuteSQLScriptCallBack(esseBeforeExecuteScript,ScriptParts,Processor);
//
//                    for i := 0 to Pred(ScriptParts.Count) do
//                    begin
//                        Processor.Clear;
//                        Processor.Delimiter := ScriptParts[i].Delimiter;
//                        Processor.Script.Text := ScriptParts[i].Script;
//
//			        	if Assigned(aExecuteSQLScriptCallBack) then
//  		            		aExecuteSQLScriptCallBack(esseBeforeExecuteScriptPart,ScriptParts,Processor);
//
//                        Processor.Execute;
//
//			        	if Assigned(aExecuteSQLScriptCallBack) then
//							aExecuteSQLScriptCallBack(esseAfterExecuteScriptPart,ScriptParts,Processor);
//                    end;
//
//		        	if Assigned(aExecuteSQLScriptCallBack) then
//	                    aExecuteSQLScriptCallBack(esseAfterExecuteScript,ScriptParts,Processor);
//                finally
//                    if Assigned(Processor) then
//	                    Processor.Free;
//                end;
//            end;
//        end
//        else
//            raise Exception.Create('O script selecionado não é um script válido!');
//    finally
//    	if Assigned(ScriptParts) then
//        	ScriptParts.Free
//    end;
