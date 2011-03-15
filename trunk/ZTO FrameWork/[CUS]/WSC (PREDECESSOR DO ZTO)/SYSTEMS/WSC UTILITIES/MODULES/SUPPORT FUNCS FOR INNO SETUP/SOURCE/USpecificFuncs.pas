unit USpecificFuncs;

interface

procedure BDOConfig(OutputDir, HostAddr, PortNumb, Protocol, DataBase, UserName, Password, FTPSyncLocation: PChar); stdcall;
procedure SYNCConfig(OutputDir, PortNumb, Protocol, DataBase, UserName, Password, FTPServer, FTPPortNumb, FTPUserName, FTPPassword: PChar); stdcall;

implementation

uses
	Graphics, Windows, SysUtils, UXXXTypesConstantsAndClasses, UBDOTypesConstantsAndClasses, UFSYTypesConstantsAndClasses;

procedure BDOConfig;
var
    BDOConfigs: UBDOTypesConstantsAndClasses.TBDOConfigurations;
begin
    BDOConfigs := nil;
    try
        BDOConfigs := UBDOTypesConstantsAndClasses.TBDOConfigurations.Create(nil);

        BDOConfigs.NeedsGeneralConfiguration := False;
        BDOConfigs.DBPassword := Password;
        BDOConfigs.DBUserName := UserName;
        BDOConfigs.DBProtocol := Protocol;
        BDOConfigs.DBDataBase := DataBase;
        BDOConfigs.DBHostAddr := HostAddr;
        BDOConfigs.DBPortNumb := StrToInt(PortNumb);
        BDOConfigs.FTPSynchronizerLocation := FTPSyncLocation;
        BDOConfigs.ExibirColunaLucroBrutoEmCadastroDeItens := False;
        BDOConfigs.ExpandedLoginDialog := True;
        BDOConfigs.UseBalloonsOnValidationErrors := True;
        BDOConfigs.UseEnterAloneToSearch := True;
        BDOConfigs.PasswordCipherAlgorithm := haMd5;

        BDOConfigs.SaveToBinaryFile(OutputDir + 'Config.dat');
    finally
        BDOConfigs.Free;
    end;


//	ZeroMemory(@BDOConfigs,SizeOf(TBDOConfigs));
//	with BDOConfigs do
//	begin
//		LastLoggedUser := '';
//		DB_ShowConf := False;
//		DB_Password := Password;
//		DB_UserName := UserName;
//		DB_Protocol := Protocol;
//		DB_DataBase := DataBase;
//		DB_HostAddr := HostAddr;
//		DB_PortNumb := StrToInt(PortNumb);
//		DB_SnapShot := 'ORIGINAL';
//		ImagemDeFundo := '';
//		PosicaoDaImagemDeFundo := pCentralizado;
//		ModificadorDaImagemDeFundo := mNormal;
//		BloquearAreaDeTrabalho := True;
//		UsarEstilosPersonalizados := True;
//		CorFundoAplicacao := clAppWorkSpace;
//		CorFundo := clWindow;
//		CorFundoRequerido := clInfoBk;
//		CorFonteRequerido := clInfoText;
//		CorFonte := clWindowText;
//		CorFundoSelecionado := clMenuHighlight;
//		CorFonteSelecionado := clMenu;
//		NomeFonte := 'Tahoma';
//		TamanhoFonte := 8;
//		FonteNegrito := False;
//		FonteItalico := False;
//		FonteSublinhado := False;
//		FonteRiscado := False;
//		ExibirCoresIntercaladasEmListas := True;
//		CorFundoIntercalada := clBtnFace;
//		CorFonteIntercalada := clWindowText;
//		NomeFonteIntercalada := 'Tahoma';
//		TamanhoFonteIntercalada := 8;
//		FonteNegritoIntercalada := False;
//		FonteItalicoIntercalada := False;
//		FonteSublinhadoIntercalada := False;
//		FonteRiscadoIntercalada := False;
//		ExibirColunasEspeciais := True;
//		CorFundoColunasEspeciais := clInfoBk;
//		CorFonteColunasEspeciais := clInfoText;
//		NomeFonteColunasEspeciais := 'Tahoma';
//		TamanhoFonteColunasEspeciais := 8;
//		FonteNegritoColunasEspeciais := False;
//		FonteItalicoColunasEspeciais := False;
//		FonteSublinhadoColunasEspeciais := False;
//		FonteRiscadoColunasEspeciais := False;
//		ExibirCabecalhosEspeciais := True;
//		CorFundoCabecalhosEspeciais := clHighlight;
//		CorFonteCabecalhosEspeciais := clHighlightText;
//		NomeFonteCabecalhosEspeciais := 'Tahoma';
//		TamanhoFonteCabecalhosEspeciais := 8;
//		FonteNegritoCabecalhosEspeciais := False;
//		FonteItalicoCabecalhosEspeciais := False;
//		FonteSublinhadoCabecalhosEspeciais := False;
//		FonteRiscadoCabecalhosEspeciais := False;
//	end;
//
//	try
//		AssignFile(F,OutputDir + 'Config.dat');
//		FileMode := fmOpenWrite;
//		Rewrite(F);
//		Write(F,BDOConfigs);
//	finally
//		CloseFile(f);
//	end;
end;

procedure SYNCConfig;
var
	F: file of UFSYTypesConstantsAndClasses.TConfigurations;
	SYNCConfigs: UFSYTypesConstantsAndClasses.TConfigurations;
begin
	ZeroMemory(@SYNCConfigs,SizeOf(UFSYTypesConstantsAndClasses.TConfigurations));
	with SYNCConfigs do
	begin
		DB_Password := Password;
		DB_UserName := UserName;
		DB_Protocol := Protocol;
		DB_Database := DataBase;
		DB_HostAddr := '127.0.0.1';
		DB_PortNumb := StrToInt(PortNumb);
		FT_UserName := FTPUserName;
		FT_PassWord := FTPPassword;
		FT_HostName := FTPServer;
		FT_PortNumb := StrToInt(FTPPortNumb);
        FT_PassiveMode := True;
        FT_CommandDelay := 1;

        VerboseMode := True;
        CheckMD5 := False;
        UseCompression := True;
	end;

	try
		AssignFile(F,OutputDir + 'FTPSyncConfig.dat');
		FileMode := fmOpenWrite;
		Rewrite(F);
		Write(F,SYNCConfigs);
	finally
		CloseFile(f);
	end;
end;

end.
