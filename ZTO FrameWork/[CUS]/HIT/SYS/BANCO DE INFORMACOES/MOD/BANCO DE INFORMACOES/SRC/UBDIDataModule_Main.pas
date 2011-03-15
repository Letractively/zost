unit UBDIDataModule_Main;

interface

uses
    Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
    Dialogs, UBDIDataModule, ZConnection, ExtCtrls, AppEvnts,
    UBDIForm_Main, Menus, ActnPopup, ActnList, OverbyteIcsHttpSrv,
    OverbyteIcsSmtpProt, DB, ZAbstractRODataset, ZDataset, ComCtrls,
  OverbyteIcsWndControl, PlatformDefaultStyleActnCtrls;

type
    { This component is used for client connection instead of default one.    }
    { This enables adding any data we need to handle our application.         }
    { As this data is located in client component, each connected client has  }
    { his own private data.                                                   }
    TConnectedClient = class(THttpConnection)
    private
        FPostedDataBuffer: PChar; { Will hold dynamically allocated buffer }
        FPostedDataSize: Integer; { Databuffer size                        }
        FDataLen: Integer;        { Keep track of received byte count.     }
        FDataFile: TextFile;      { Used for datafile display              }
    public
        destructor Destroy; override;

        property PostedDataBuffer: PChar read FPostedDataBuffer;
        property PostedDataSize: Integer read FPostedDataSize;
        property DataLen: Integer read FDataLen;
        property DataFile: TextFile read FDataFile;
    end;

    TEnviandoEmail = (eeNenhum, eeObrasOciosas, eeObrasGanhas, eeObrasPerdidas, eeObrasLimitrofes);

    TBDIDataModule_Main = class(TBDIDataModule)
        ZConnection_BDI: TZConnection;
        TrayIcon_BDI: TTrayIcon;
        PopupActionBar_TrayIcon: TPopupActionBar;
        ActionRestaurarDoTray1: TMenuItem;
        ActionFecharAplicacao1: TMenuItem;
        HttpServer_BDI: THttpServer;
        N1: TMenuItem;
        AtivarserviodeinformaesviaHTTP1: TMenuItem;
        AtivarserviodeenviodeemailsviaSMTP1: TMenuItem;
        N2: TMenuItem;
        Timer_EmailsAutomaticos: TTimer;
        ZConnection_BDO: TZConnection;
        SmtpCli_BDI: TSmtpCli;
        procedure DataModuleCreate(Sender: TObject);
        procedure DoAfterConnectBDI(aSender: TObject);
        procedure TrayIcon_BDIDblClick(Sender: TObject);
        procedure Action_MinimizarNoTrayExecute(Sender: TObject);
        procedure ZConnection_BDIBeforeConnect(Sender: TObject);
        procedure Timer_EmailsAutomaticosTimer(Sender: TObject);
        procedure ZConnection_BDOBeforeConnect(Sender: TObject);
        procedure DoRequestDone(Sender: TObject; RqType: TSmtpRequest; ErrorCode: Word);
        procedure DoGetData(Sender: TObject; LineNum: Integer; MsgLine: Pointer; MaxLen: Integer; var More: Boolean);
        procedure DataModuleDestroy(Sender: TObject);
        procedure DoAuthGetType(Sender, Client: TObject);
        procedure DoAuthGetPassword(Sender, Client: TObject; var Password: string);
        procedure DoAuthResult(Sender, Client: TObject; Success: Boolean);
        procedure DoClientConnect(Sender, Client: TObject; Error: Word);
        procedure DoClientDisconnect(Sender, Client: TObject; Error: Word);
        procedure DoGetDocument(Sender, Client: TObject; var Flags: THttpGetFlag);
        procedure DeHeadDocument(Sender, Client: TObject; var Flags: THttpGetFlag);
        procedure DoPostDocument(Sender, Client: TObject; var Flags: THttpGetFlag);
        procedure DoPostedData(Sender, Client: TObject; Error: Word);
        procedure DoServerStarted(Sender: TObject);
        procedure DoServerStopped(Sender: TObject);
        procedure DoAfterConnectBDO(Sender: TObject);
    private
        { Private declarations }
        FCountRequests: Cardinal;
        FCarragandoConfiguracoes: Boolean;

        FEmailAEnviar: TStringList;
        FObrasAProcessar: TStringList;
        FEnviandoEmail: TEnviandoEmail;

        FProximoEnvioParaObrasOciosas: TDateTime;
        FProximoEnvioParaObrasLimitrofes: TDateTime;
        {$IFDEF DEVELOPING}
        x: Integer;
        {$ENDIF}

        procedure HTTPShowOnLog(const aText: String; aRichEdit: TRichEdit);

        function MyModule: TBDIForm_Main;
//        procedure ShowOnLog(const aMessage: ShortString);
        procedure AplicarConfiguracoesSMTP;

        function GerarEEnviarEmailsParaObrasOciosas: Boolean;
        procedure GerarEEnviarEmailsParaObrasGanhas;
        procedure GerarEEnviarEmailsParaObrasPerdidas;
        function GerarEEnviarEmailsParaObrasLimitrofes: Boolean;

        function ObterEmailDoUsuario(const aUsuarioID: Cardinal): ShortString;
        function ObterNomeCompletoDoUsuario(const aUsuarioID: Cardinal): ShortString;
        function ObterRegiao(const aRegiaoID: Byte): ShortString;

        procedure ObrasOciosasAddProgress;
        procedure ObrasGanhasAddProgress;
        procedure ObrasLimitrofesAddProgress;
        procedure ObrasPerdidasAddProgress;

        function ObterEmails(const aListaDeEmails: TStringList;
                             const aRegiaoAssociada: ShortString = ''): String;
        procedure EnviarEmails(const aTo
                                   , aCc
                                   , aSubject: ShortString);
        procedure ObterObrasProcessadas(aSituacao: ShortString);
        procedure ProcessarObras(aSituacao: ShortString);
        function HaEmailsAEnviar(aListaDeEMails: TStringList;
                                 aIDRegiao: Byte;
                                 aIDCriador: Word;
                                 aIDModificador: Word): Boolean;
        function ObterProprietarios(aObraID: Cardinal): ShortString;
        function ObterIdSituacao(aSituacao: ShortString): ShortString;
        function ObterJustificativa(aObraID: Cardinal): String;
    protected

    public
        { Public declarations }
        procedure MinimizarNoTray;
        procedure RestaurarDoTray;
        procedure ObterConfiguracoes;
        procedure GuardarConfiguracoes;
        procedure SalvarArquivoDeConfiguracoes;
        procedure AtivarDesativarServidorHTTP;
        procedure AtivarDesativarEnvioSMTP;
        procedure LimparRegistros(aSituacao: ShortString);
    end;

implementation

uses
    WinSock, UXXXTypesConstantsAndClasses, ZDBCIntfs, UXXXDataModule,
    UBDITypesConstantsAndClasses, OverbyteIcsWSocket, OverbyteIcsWSocketS, StrUtils
    {$IFDEF DEVELOPING},shellapi{$ENDIF};

{$R *.dfm}

const
//    tem de ser resolvido o problema da subconsulta IN que não póde conter muitos ids dentro do parentese

    SQL_OBRAS =
    '  SELECT OBR.IN_OBRAS_ID'#13#10 +
    '       :USUARIOCRIADOR:, OBR.SM_USUARIOCRIADOR_ID'#13#10 +
    '       :USUARIOMODIFICADOR:, OBR.SM_USUARIOMODIFICADOR_ID'#13#10 +
    '       :REGIAO:, OBR.TI_REGIOES_ID'#13#10 +
    '    FROM OBRAS OBR'#13#10 +
    '   WHERE OBR.TI_SITUACOES_ID = :TI_SITUACOES_ID:'#13#10 +
    '     AND OBR.IN_OBRAS_ID NOT IN (SELECT IN_OBRAS_ID FROM OBRASPROCESSADAS)'#13#10 +
    'ORDER BY :ORDER BY:';

//    SQL_OBRAS =
//    '  SELECT OBR.IN_OBRAS_ID'#13#10 +
//    '       :USUARIOCRIADOR:, OBR.SM_USUARIOCRIADOR_ID'#13#10 +
//    '       :USUARIOMODIFICADOR:, OBR.SM_USUARIOMODIFICADOR_ID'#13#10 +
//    '       :REGIAO:, OBR.TI_REGIOES_ID'#13#10 +
//    '    FROM OBRAS OBR'#13#10 +
//    '   WHERE NOT OBR.IN_OBRAS_ID IN (:OBRASPROCESSADAS:)'#13#10 +
//    '     AND OBR.TI_SITUACOES_ID = (SELECT TI_SITUACOES_ID'#13#10 +
//    '                                  FROM SITUACOES'#13#10 +
//    '                                 WHERE UPPER(VA_DESCRICAO) = '':SITUACAO:'')'#13#10 +
//    'ORDER BY :ORDER BY:';

    SQL_PROPOSTAS =
    '   SELECT OBR.VA_NOMEDAOBRA AS NOMEDAOBRA'#13#10 +
    '        , CONCAT(OBR.VA_CIDADE,'' / '',OBR.CH_ESTADO) AS LOCALIDADE'#13#10 +
    '        , FNC_GET_PROPOSAL_CODE(PRO.IN_PROPOSTAS_ID) AS PROPOSTA'#13#10 +
    '        , INS.VA_NOME AS INSTALADOR'#13#10 +
    '        , FNC_GET_FORMATTED_CURRENCY_VALUE(FNC_GET_PROPOSAL_VALUE(PRO.IN_PROPOSTAS_ID,FALSE,TRUE,NULL,2),ELT(PRO.TI_MOEDA,''US$'',''€'',''R$'',''£'',''¥''),FALSE) AS VALOR'#13#10 +
    '        , CONCAT (ELT(OBR.TI_MESPROVAVELDEENTREGA,''Janeiro'',''Fevereiro'',''Março'',''Abril'',''Maio'',''Junho'',''Julho'',''Agosto'',''Setembro'',''Outubro'',''Novembro'',''Dezembro''),'' / '',OBR.YR_ANOPROVAVELDEENTREGA) AS MESANO'#13#10 +
    '        , PRO.BO_PROPOSTAPADRAO AS PROPOSTAPADRAO'#13#10 +
    '     FROM OBRAS OBR'#13#10 +
    'LEFT JOIN PROPOSTAS PRO USING (IN_OBRAS_ID)'#13#10 +
    'LEFT JOIN INSTALADORES INS USING (SM_INSTALADORES_ID)'#13#10 +
    '    WHERE OBR.IN_OBRAS_ID = :IN_OBRAS_ID:'#13#10 +
    ':PROPOSTAPADRAO:     AND PRO.BO_PROPOSTAPADRAO';

{ TBDIDataModule_Main }

procedure TBDIDataModule_Main.DoAuthResult(Sender, Client: TObject; Success: Boolean);
var
    ConnectedClient: TConnectedClient;
const
    SUCESSO_FALHA: array [Boolean] of String = ('Falha', 'Sucesso');
    AUTH_TYPE: array[TAuthenticationType] of String = ('Nenhuma','Básica','"Digest"','"NTLM"');
begin
    inherited;
    ConnectedClient := TConnectedClient(Client);

    HTTPShowOnLog('Iniciando autenticação >>>>>>>>>>>>>>>>>>>>>>>',MyModule.RichEdit_HTTPLog);
    try
        HTTPShowOnLog('§ IP do cliente: ' + ConnectedClient.GetPeerAddr + '\n' +
                      'Tipo.........: ' + AUTH_TYPE[ConnectedClient.AuthType] + '\n' +
                      'Resultado....: ' + SUCESSO_FALHA[Success] + '\n' +
                      'URL requisitado:\n' + ConnectedClient.Path,MyModule.RichEdit_HTTPLog);
    finally
        HTTPShowOnLog('Autenticação finalizada <<<<<<<<<<<<<<<<<<<<<<',MyModule.RichEdit_HTTPLog);
    end;
end;

procedure TBDIDataModule_Main.DoClientConnect(Sender, Client: TObject; Error: Word);
begin
    inherited;
    MyModule.Panel_Status.Caption := 'Clientes conectados: ' + IntToStr(THttpServer(Sender).ClientCount);
end;

procedure TBDIDataModule_Main.DoClientDisconnect(Sender, Client: TObject; Error: Word);
begin
    inherited;
    MyModule.Panel_Status.Caption := 'Clientes conectados: ' + IntToStr(Pred(THttpServer(Sender).ClientCount));
end;

procedure TBDIDataModule_Main.DoPostedData(Sender, Client: TObject; Error: Word);
var
    Tamanho, Concluido: Integer;
    Lixo: array [0..255] of Char;
    ConnectedClient: TConnectedClient;
begin
    inherited;

    ConnectedClient := TConnectedClient(Client);

    { Qual a quantidade de dados que precisamos receber? }
    Concluido := ConnectedClient.RequestContentLength - ConnectedClient.FDataLen;

    if Concluido <= 0 then
    begin
        { Pegamos todos os dados. Descartamos todo o resto colocando um
        caractere NULL no final }
        Tamanho := ConnectedClient.Receive(@Lixo, Pred(SizeOf(Lixo)));
        if Tamanho >= 0 then
            Lixo[Tamanho] := #0;
        Exit;
    end;

    { Recebemos tantos dados quanto precisamos receber. Mas podemos receber
    muito menos dados, pois este é dividido em vários pedaços que precisamos
    montar no nosso buffer }
    Tamanho := ConnectedClient.Receive(ConnectedClient.PostedDataBuffer + ConnectedClient.DataLen, Concluido);

    { Algumas vezes o Winsock não quer dar nenhum dado... }
    if Tamanho <= 0 then
        Exit;

    { Adicionando a quantidade de dados recebidos a nossa contagem }
    Inc(ConnectedClient.FDataLen, Tamanho);

    { Adicionando um byte NULL no final (útil para manipular os dados como string }
    ConnectedClient.FPostedDataBuffer[ConnectedClient.FDataLen] := #0;

    { Display receive data so far }
    HTTPShowOnLog('Data: ' + StrPas(ConnectedClient.FPostedDataBuffer),MyModule.RichEdit_HTTPLog);

    { Quando recebermos a coisa toda poderemos processá-la! }
    if ConnectedClient.FDataLen = ConnectedClient.RequestContentLength then
    begin
        { Primeiramente precisamos informar ao componente que já recebemos todos
        os dados que queríamos }
        ConnectedClient.PostedDataReceived;
        { Baseado em qual script foi chamado, executa o processador de dados }
        if CompareText(ConnectedClient.Path, '/cgi-bin/FormHandler') = 0 then
//            ProcessPostedData_FormHandler(ConnectedClient)
        else
            { Nada mais é aceito }
            ConnectedClient.Answer404;
    end;
end;

//procedure TWebServForm.ProcessPostedData_FormHandler(
//    ClientCnx : TMyHttpConnection);
//var
//    Stream    : TStream;
//    FileName  : String;
//    FirstName : String;
//    LastName  : String;
//    HostName  : String;
//    Buf       : String;
//    Dummy     : THttpGetFlag;
//begin
//    { Extract fields from posted data. }
//    ExtractURLEncodedValue(ClientCnx.FPostedDataBuffer, 'FirstName', FirstName);
//    ExtractURLEncodedValue(ClientCnx.FPostedDataBuffer, 'LastName',  LastName);
//    { Get client IP address. We could to ReverseDnsLookup to get hostname }
//    HostName := ClientCnx.PeerAddr;
//    { Build the record to write to data file }
//    Buf      := FormatDateTime('YYYYMMDD HHNNSS ', Now) +
//                FirstName + '.' + LastName + '@' + HostName + #13#10;
//
//    { Save data to a text file }
//    FileName := ExtractFilePath(Application.ExeName) + 'FormHandler.txt';
//    if FileExists(FileName) then
//        Stream := TFileStream.Create(FileName, fmOpenWrite)
//    else
//        Stream := TFileStream.Create(FileName, fmCreate);
//    Stream.Seek(0, soFromEnd);
//    Stream.Write(Buf[1], Length(Buf));
//    Stream.Destroy;
//
//    { Here is the place to check for valid input data and produce a HTML }
//    { answer according to data validation.                               }
//    { Here for simplicity, we don't check data and always produce the    }
//    { same HTML answer.                                                  }
//    ClientCnx.AnswerString(Dummy,
//        '',           { Default Status '200 OK'         }
//        '',           { Default Content-Type: text/html }
//        '',           { Default header                  }
//        '<HTML>' +
//          '<HEAD>' +
//            '<TITLE>ICS WebServer Form Demo</TITLE>' +
//          '</HEAD>' + #13#10 +
//          '<BODY>' +
//            '<H2>Your data has been recorded:</H2>' + #13#10 +
//            '<P>' + TextToHtmlText(FirstName) + '.' +
//                    TextToHtmlText(LastName)  + '@' +
//                    TextToHtmlText(HostName)  +'</P>' +
//            '<A HREF="/form.html">More data entry</A><BR>' +
//            '<A HREF="/FormData.html">View data file</A><BR>' +
//            '<A HREF="/demo.html">Back to demo menu</A><BR>' +
//          '</BODY>' +
//        '</HTML>');
//end;


procedure TBDIDataModule_Main.HTTPShowOnLog(const aText: String; aRichEdit: TRichEdit);
var
  Linhas: TStringList;
  i: Word;
  LinhaAExibir: ShortString;

  function FirstToken(Line: String): ShortString;
  begin
  	Result := Copy(Line,1,Pred(Pos(' ',Line)));
  end;

//  function FirstAndSecondTokens(Line: String): ShortString;
//  var
//    Idx: Word;
//    TmpStr: String;
//  begin
//  	TmpStr := Line; //RETORNO:> XXX - XXXXXX
//		Idx := Pos(' ',TmpStr);
//    Delete(TmpStr,1,Idx); //XXX - XXXXXX
//    Inc(Idx,Pos(' ',TmpStr));
//  	Result := Copy(Line,1,Pred(Idx));
//  end;

begin
	Linhas := nil;
    MyModule.RichEdit_HTTPLog.Lines.BeginUpdate;    
  	try
        { preservando apenas as 200 primeiras linhas }
        while MyModule.RichEdit_HTTPLog.Lines.Count > 200 do
            MyModule.RichEdit_HTTPLog.Lines.Delete(0);

  		Linhas := TStringList.Create;
		Linhas.Text := StringReplace(aText,'\n',#13#10,[rfReplaceAll]);

    	if (Linhas[0][1] = '!') or (Linhas[0][1] = '§') or (Linhas[0][1] = '@') then
      		for i := 0 to Pred(Linhas.Count) do
      		begin
        		if i = 0 then
        		begin
          			LinhaAExibir := Linhas[0];
          			aRichEdit.Lines.Add(FormatDateTime('dd/mm/yyyy hh:nn:ss',Now()) + ' ] ' + LinhaAExibir);
                end
                else
                begin
      	            LinhaAExibir := FirstToken(Linhas[0]) + ' ' + Linhas[i];
                    aRichEdit.Lines.Add('||||||||||||||||||| ] ' + LinhaAExibir);
                end;

                { A partir daqui, a última linha do RichEdit contém algo como
                dd/mm/yyyy hh:nn:ss ] RETORNO:> ??? - XXXXXXXXXXXX }

                { Tornando negrito e na cor preta a string inteira }
                aRichEdit.SelStart := Length(aRichEdit.Text) - Length(aRichEdit.Lines[Pred(aRichEdit.Lines.Count)]) - 2;
                aRichEdit.SelLength := Length(aRichEdit.Lines[Pred(aRichEdit.Lines.Count)]);
                aRichEdit.SelAttributes.Color := clWindowText;
                aRichEdit.SelAttributes.Style := [fsBold];

                { Removendo o atributo negrito do colchete (]) }
                aRichEdit.SelStart := aRichEdit.SelStart + 20;
                aRichEdit.SelLength := 1;
                aRichEdit.SelAttributes.Style := [];

                { Seleconando a segunda parte do texto }
                aRichEdit.SelStart := Length(aRichEdit.Text) - Length(aRichEdit.Lines[Pred(aRichEdit.Lines.Count)]) + 20;
                aRichEdit.SelLength := Length(LinhaAExibir);

                { Pintando a linha da mensagem de acordo com o texto }
                if LinhaAExibir[1] = '!' then
                  aRichEdit.SelAttributes.Color := clRed
                else if LinhaAExibir[1] = '§' then
                  aRichEdit.SelAttributes.Color := $000080FF
                else if LinhaAExibir[1] = '@' then
                  aRichEdit.SelAttributes.Color := clPurple;

                aRichEdit.SelLength := 0;
            end
        else
            for i := 0 to Pred(Linhas.Count) do
                aRichEdit.Lines.Add('------------------- ] ' + Linhas[i]);
    finally
        MyModule.RichEdit_HTTPLog.Lines.EndUpdate;
  	    Linhas.Free;
        SendMessage(aRichEdit.Handle,EM_SCROLLCARET,0,0);
    end;
end;


procedure TBDIDataModule_Main.LimparRegistros(aSituacao: ShortString);
const
    SQL_DELETE = 'DELETE FROM BANCODEINFORMACOES.OBRASPROCESSADAS WHERE TI_SITUACOES_ID = :TI_SITUACOES_ID:';
begin
    if Application.MessageBox('Ao limpar os registros de obras nesta situação, na próxima geração de e-mails serão gerados e enviados e-mails para TODAS as obras disponíveis nesta situação. Tem certeza?','Tem certeza?',MB_YESNO or MB_ICONQUESTION) = IDYES then
    begin
        ExecuteQuery(ZConnection_BDI
                    ,StringReplace(SQL_DELETE,':TI_SITUACOES_ID:',ObterIdSituacao(aSituacao),[]));

        Application.MessageBox(PChar(IntToStr(MySQLAffectedRows(ZConnection_BDI)) + ' registros excluídos'),'Comando executado com sucesso!',MB_ICONINFORMATION);
    end;
end;

//procedure TBDIDataModule_Main.ShowOnLog(const aMessage: ShortString);
//begin
//    MyModule.Memo_HTTPLog.Lines.BeginUpdate;
//    try
//        { We preserve only 200 lines }
//        while MyModule.Memo_HTTPLog.Lines.Count > 200 do
//            MyModule.Memo_HTTPLog.Lines.Delete(0);
//
//        MyModule.Memo_HTTPLog.Lines.Add(aMessage);
//    finally
//        MyModule.Memo_HTTPLog.Lines.EndUpdate;
//        { Makes last line visible }
//        SendMessage(MyModule.Memo_HTTPLog.Handle, EM_SCROLLCARET, 0, 0);
//    end;
//end;

procedure TBDIDataModule_Main.Action_MinimizarNoTrayExecute(Sender: TObject);
begin
    inherited;
    MinimizarNoTray;
end;

procedure TBDIDataModule_Main.ObterConfiguracoes;
begin
    try
        FCarragandoConfiguracoes := True;

        MyModule.Label_DocumentRootValor.Caption := Configurations.CurrentDir + '\wwwroot';
        MyModule.Label_HTTPTemplateDirValor.Caption := Configurations.CurrentDir + '\wwwroot\responsetemplates';
        MyModule.Label_HTTPDocumentoPadraoValor.Caption := HttpServer_BDI.DefaultDoc;

        ZConnection_BDI.GetProtocolNames(MyModule.ComboBoxProtocolo.Items);
        MyModule.ComboBoxProtocolo.ItemIndex := MyModule.ComboBoxProtocolo.Items.IndexOf(Configurations.DBProtocol);
        MyModule.ComboBoxIsolationLevel.Clear;
        MyModule.ComboBoxIsolationLevel.Items.AddObject('tiNone',TObject(tiNone));
        MyModule.ComboBoxIsolationLevel.Items.AddObject('tiReadCommitted',TObject(tiReadCommitted));
        MyModule.ComboBoxIsolationLevel.Items.AddObject('tiReadUncommitted',TObject(tiReadUncommitted));
        MyModule.ComboBoxIsolationLevel.Items.AddObject('tiRepeatableRead',TObject(tiRepeatableRead));
        MyModule.ComboBoxIsolationLevel.Items.AddObject('tiSerializable',TObject(tiSerializable));
        MyModule.ComboBoxIsolationLevel.ItemIndex := MyModule.ComboBoxIsolationLevel.Items.IndexOfObject(TObject(Configurations.DBIsoLevel));
        MyModule.EditEnderecoDoHost.Text := Configurations.DBHostAddr;
        MyModule.EditPorta.Text := IntToStr(Configurations.DBPortNumb);
        MyModule.EditBancoDeDados.Text := Configurations.DBDataBase;
        MyModule.EditNomeDeUsuario.Text := Configurations.DBUserName;
        MyModule.EditSenha.Text := Configurations.DBPassword;

        MyModule.ComboBox_Priority.ItemIndex := Configurations.SMTPPrio;
        MyModule.ComboBox_ContentType.ItemIndex := Configurations.SMTPCoTy;
        MyModule.ComboBox_SendMode.ItemIndex := Configurations.SMTPSeMo;
        MyModule.ComboBox_ShareMode.ItemIndex := Configurations.SMTPShMo;
        MyModule.CheckBox_Confirm.Checked := Configurations.SMTPConf;
        MyModule.CheckBox_WrapMessageText.Checked := Configurations.SMTPWrMT;
        MyModule.LabeledEdit_SMTPLogin.Text := Configurations.SMTPUsNa;
        MyModule.LabeledEdit_SMTPSenha.Text := Configurations.SMTPUsPa;
        MyModule.LabeledEdit_SMTPHost.Text := Configurations.SMTPHost;
        MyModule.LabeledEdit_SMTPFrom.Text := Configurations.SMTPFrom;
        MyModule.LabeledEdit_SMTPAssinatura.Text := Configurations.SMTPSign;
        MyModule.ComboBox_SMTPAutenticacao.ItemIndex := Configurations.SMTPAuth;
        MyModule.CheckBox_SMTPAllow8bitChars.Checked := Configurations.SMTPA8bC;
        MyModule.LabeledEdit_SMTPCharSet.Text := Configurations.SMTPChSe;
        MyModule.ComboBox_SMTPDefaultEncoding.ItemIndex := Configurations.SMTPDeEn;

        MyModule.LabeledEdit_PortaHTTP.Text := IntToStr(Configurations.HTTPPort);

        MyModule.UpDown_IntervaloDeChecagemGeral.Position := Configurations.IntervaloDeChecagemGeral;

        MyModule.Memo_ObrasOciosas.Text := Configurations.EmailsParaObrasOciosas.Text;
        MyModule.UpDown_ObrasOciosasIntervalo.Position := Configurations.IntervaloDeChecagemDeOciosas;
        MyModule.UpDown_ObrasOciosasDias.Position := Configurations.DiasDeOciosidade;

        MyModule.Memo_ObrasGanhas.Text := Configurations.EmailsParaObrasGanhas.Text;

        MyModule.Memo_ObrasPerdidas.Text := Configurations.EmailsParaObrasPerdidas.Text;

        MyModule.Memo_ObrasLimitrofes.Text := Configurations.EmailsParaObrasLimitrofes.Text;
        MyModule.UpDown_ObrasLimitrofesIntervalo.Position := Configurations.IntervaloDeChecagemDeLimitrofes;
        MyModule.UpDown_ObrasLimitrofesDias.Position := Configurations.DiasParaAviso;
    finally
        MyModule.BitBtn_SalvarConfiguracoes.Enabled := False;
        FCarragandoConfiguracoes := False;
    end;
end;

function TBDIDataModule_Main.ObterNomeCompletoDoUsuario(const aUsuarioID: Cardinal): ShortString;
var
	Usuarios: TZReadOnlyQuery;
begin
    Result := '';

	Usuarios := nil;
    try
	    ConfigureDataSet(ZConnection_BDO
                        ,Usuarios
                        ,'SELECT VA_NOME FROM USUARIOS WHERE SM_USUARIOS_ID = ' + IntToStr(aUsuarioID));

	    if Usuarios.RecordCount = 1 then
            Result := Usuarios.Fields[0].AsString;
    finally
	    if Assigned(Usuarios) then
    		Usuarios.Free;
    end;
end;


function TBDIDataModule_Main.ObterJustificativa(aObraID: Cardinal): String;
var
	JustificativasDaObra: TZReadOnlyQuery;
begin
    Result := 'N/A';

	JustificativasDaObra := nil;
    try
	    ConfigureDataSet(ZConnection_BDO
                        ,JustificativasDaObra
                        ,'SELECT FNC_GET_JUSTIFICATIVE_FROM_WORK(' + IntToStr(aObraID) + ')');

	    if (JustificativasDaObra.RecordCount = 1) and (JustificativasDaObra.Fields[0].AsString <> '') then
            Result := JustificativasDaObra.Fields[0].AsString;
    finally
	    if Assigned(JustificativasDaObra) then
    		JustificativasDaObra.Free;
    end;
end;

function TBDIDataModule_Main.ObterProprietarios(aObraID: Cardinal): ShortString;
var
	Proprietarios: TZReadOnlyQuery;
    Criador, Modificador: ShortString;
begin
    Result := '';
    
	Proprietarios := nil;
    try
	    ConfigureDataSet(ZConnection_BDO
                        ,Proprietarios
                        ,'SELECT SM_USUARIOCRIADOR_ID,SM_USUARIOMODIFICADOR_ID FROM OBRAS WHERE IN_OBRAS_ID = ' + IntToStr(aObraID));

	    if Proprietarios.RecordCount = 1 then
        begin
            Criador := ObterNomeCompletoDoUsuario(Proprietarios.Fields[0].AsInteger);
            Modificador := ObterNomeCompletoDoUsuario(Proprietarios.Fields[1].AsInteger);

            if Criador <> '' then
                Result := '<b>' + Criador + '</b>';

            if (Modificador <> '') and (Criador <> Modificador) then
                if Result <> '' then
                    Result := Result + ' &amp; ' + '<b>' + Modificador + '</b>'
                else
                    Result := '<b>' + Modificador + '</b>';
        end;
        if Result = '' then
            Result := 'N/A';
    finally
	    if Assigned(Proprietarios) then
    		Proprietarios.Free;
    end;
end;

function TBDIDataModule_Main.ObterRegiao(const aRegiaoID: Byte): ShortString;
var
	Regioes: TZReadOnlyQuery;
begin
    Result := '';

	Regioes := nil;
    try
	    ConfigureDataSet(ZConnection_BDO
                        ,Regioes
                        ,'SELECT VA_REGIAO FROM REGIOES WHERE TI_REGIOES_ID = ' + IntToStr(aRegiaoID));

	    if Regioes.RecordCount = 1 then
            Result := Regioes.Fields[0].AsString;
    finally
	    if Assigned(Regioes) then
    		Regioes.Free;
    end;
end;

procedure TBDIDataModule_Main.ProcessarObras(aSituacao: ShortString);
const
    SQL_SUBSTITUIR =
    'REPLACE INTO BANCODEINFORMACOES.OBRASPROCESSADAS (IN_OBRAS_ID'#13#10 +
    '                                                 ,TI_SITUACOES_ID)'#13#10 +
    '      VALUES :VALUES:';
    SQL_VALUE =
    '           , (:IN_OBRAS_ID:,:TI_SITUACOES_ID:)'#13#10;

var
    ObraId: ShortString;
    Values: String;
begin
    aSituacao := ObterIdSituacao(aSituacao);
    Values := '';

    for ObraId in FObrasAProcessar do
    begin
        if Values = '' then
            Values := '(' + ObraId + ',' + aSituacao + ')'#13#10
        else
        begin
            Values := Values + StringReplace(SQL_VALUE,':IN_OBRAS_ID:',ObraId,[]);
            Values := StringReplace(Values,':TI_SITUACOES_ID:',aSituacao,[]);
        end;
    end;
    ExecuteQuery(ZConnection_BDI,StringReplace(SQL_SUBSTITUIR,':VALUES:',Values,[]));
end;

{ Este procedure preenche uma tabela temporária na base do BDO com os IDs das
obras já processadas.  }
procedure TBDIDataModule_Main.ObterObrasProcessadas(aSituacao: ShortString);
const
    SQL_OBRAS_PROCESSADAS =
    'INSERT INTO OBRASPROCESSADAS (IN_OBRAS_ID) VALUES :VALUES:';

var
    RODataSet: TZReadOnlyQuery;
    SituacaoID: ShortString;
    Values: String;
begin
    { Limpando a tabela temporária }
    ExecuteQuery(ZConnection_BDO,'TRUNCATE TABLE OBRASPROCESSADAS');

    Values := '';

	RODataSet := nil;
    try
        { Obtendo o ID da situação a verificar }
        SituacaoID := ObterIdSituacao(aSituacao);
        if SituacaoID = '0' then
            Exit;

        { Obtendo os IDs das obras processadas }
	    ConfigureDataSet(ZConnection_BDI
                        ,RODataSet
                        ,'SELECT IN_OBRAS_ID FROM BANCODEINFORMACOES.OBRASPROCESSADAS WHERE TI_SITUACOES_ID = ' + SituacaoID);

	    if RODataSet.RecordCount > 0 then
        begin
            { Criando o script de inserção na tabela temporária }
            RODataSet.First;
            while not RODataSet.Eof do
            begin
                if Values <> '' then
                    Values := Values + ',(' + RODataSet.Fields[0].AsString + ')'
                else
                    Values := '(' + RODataSet.Fields[0].AsString + ')';

                RODataSet.Next;
            end;


            { Preenchendo a tabela temporária com os IDs das obras processadas }
            ExecuteQuery(ZConnection_BDO,StringReplace(SQL_OBRAS_PROCESSADAS,':VALUES:',Values,[]));
        end;

        {$IFDEF DEVELOPING}
        with TStringList.Create do
            try
                ConfigureDataSet(ZConnection_BDO,RODataSet,'SELECT IN_OBRAS_ID FROM OBRASPROCESSADAS');
                while not RODataSet.Eof do
                begin
                    Add(RODataSet.Fields[0].AsString);
                    RODataSet.Next;
                end;
                SaveToFile('c:\' + aSituacao + '_PROCESSADAS.txt');
            finally
                Free;
            end;
        {$ENDIF}

    finally
	    if Assigned(RODataSet) then
    		RODataSet.Free;
    end;
end;

function TBDIDataModule_Main.ObterEmailDoUsuario(const aUsuarioID: Cardinal): ShortString;
var
	Usuarios: TZReadOnlyQuery;
begin
    Result := '';

	Usuarios := nil;
    try
	    ConfigureDataSet(ZConnection_BDO
                        ,Usuarios
                        ,'SELECT VA_EMAIL FROM USUARIOS WHERE SM_USUARIOS_ID = ' + IntToStr(aUsuarioID));

	    if Usuarios.RecordCount = 1 then
            Result := Usuarios.Fields[0].AsString;
    finally
	    if Assigned(Usuarios) then
    		Usuarios.Free;
    end;
end;

procedure TBDIDataModule_Main.SalvarArquivoDeConfiguracoes;
begin
    TBDIConfigurations(Configurations).SalvarConfiguracoes;
    MyModule.BitBtn_SalvarConfiguracoes.Enabled := False;
    MessageBox(MyModule.Handle,'Todas as configurações foram salvas!'#13#10#13#10'Obs.: As configurações também são automaticamente salvas quando a aplicação é finalizada','Configurações salvas!',MB_ICONINFORMATION);
end;

procedure TBDIDataModule_Main.GerarEEnviarEmailsParaObrasGanhas;
{$REGION 'PROCEDIMENTOS LOCAIS'}
function EmailsAEnviarPorProprietario(aSQLOriginal: String): Word;
var
    RODataSet: TZReadOnlyQuery;
begin
    RODataSet := nil;
    try
        ConfigureDataSet(ZConnection_BDO
                        ,RODataSet
                        ,'SELECT * FROM (' + aSQLOriginal + ') T GROUP BY 2,3');

        Result := RODataSet.RecordCount;
    finally
        RODataSet.Free;
    end;
end;

function EmailsAEnviarPorRegiao(aSQLOriginal: String): Word;
var
    RODataSet: TZReadOnlyQuery;
begin
    RODataSet := nil;
    try
        ConfigureDataSet(ZConnection_BDO
                        ,RODataSet
                        ,'SELECT * FROM (' + aSQLOriginal + ') T GROUP BY 2');

        Result := RODataSet.RecordCount;
    finally
        RODataSet.Free;
    end;
end;

procedure GerarEmailPorRegiao(const aObrasGanhas: TStringList;
                              const aPrincipalTemplate
                                  , aObraTemplate
                                  , aPropostaTemplate
                                  , aResponsaveisTemplate: String;
                              const aRegiao: ShortString);
var
    RODataSet: TZReadOnlyQuery;
    ObrasGanhas, Propostas, SQL: String;
    ObraId: ShortString;
begin
    ObrasGanhas := '';
    RODataSet := nil;
    try
        for ObraId in aObrasGanhas do
        begin
            if not Assigned(RODataSet) then
                RODataSet := TZReadOnlyQuery.Create(ZConnection_BDO);
                
            ObrasGanhas := ObrasGanhas + aObraTemplate;

            { Obtendo a proposta padrão da obra }
            SQL := StringReplace(SQL_PROPOSTAS,':IN_OBRAS_ID:',ObraId,[]);
            SQL := StringReplace(SQL,':PROPOSTAPADRAO:',' ',[]);
            ConfigureDataSet(ZConnection_BDO
                            ,RODataSet
                            ,SQL
                            ,False);

            ObrasGanhas := StringReplace(ObrasGanhas,'[%]NOMEDAOBRA[%]',RODataSet.FieldByName('NOMEDAOBRA').AsString,[]);
            ObrasGanhas := StringReplace(ObrasGanhas,'[%]LOCALIDADE[%]',RODataSet.FieldByName('LOCALIDADE').AsString,[]);
            ObrasGanhas := StringReplace(ObrasGanhas,'[%]RESPONSAVEIS[%]',aResponsaveisTemplate,[]);
            ObrasGanhas := StringReplace(ObrasGanhas,'[%]PROPRIETARIOS[%]',ObterProprietarios(StrToInt(ObraId)),[]);
            ObrasGanhas := StringReplace(ObrasGanhas,'[%]BORDERBOTTOMRESPONSAVEIS[%]','#000000',[]);

            Propostas := '<tr><td colspan="3" style="text-align: center">ESTA OBRA NÃO POSSUI PROPOSTAS OU NÃO POSSUI PROPOSTA PADRÃO</td><tr>';

            { Pode ser nulo, caso a obra não tenha propostas }
            if not RODataSet.FieldByName('PROPOSTA').IsNull then
            begin
                Propostas := '<tr><td colspan="3" style="text-align: center">ESTA OBRA POSSUI MAIS DE UMA PROPOSTA PADRÃO. CONTATE O SUPORTE TÉCNICO</td><tr>';

                if RODataSet.RecordCount = 1 then
                begin
                    Propostas := aPropostaTemplate;

                    if RODataSet.RecNo mod 2 = 0 then
                        Propostas := StringReplace(Propostas,'[%]LINHADECOR[%]',' style="background-color: #C0C0C0"',[])
                    else
                        Propostas := StringReplace(Propostas,'[%]LINHADECOR[%]','',[]);

                    Propostas := StringReplace(Propostas,'[%]PROPOSTA[%]',RODataSet.FieldByName('PROPOSTA').AsString,[]);
                    Propostas := StringReplace(Propostas,'[%]INSTALADOR[%]',RODataSet.FieldByName('INSTALADOR').AsString,[]);
                    Propostas := StringReplace(Propostas,'[%]VALOR[%]',IfThen(RODataSet.FieldByName('VALOR').AsString <> '',RODataSet.FieldByName('VALOR').AsString,'N/A'),[]);
                end;
            end;
            Application.ProcessMessages;
            ObrasGanhas := StringReplace(ObrasGanhas,'[%]PROPOSTAS[%]',Propostas,[]);
        end;
        FEmailAEnviar.Text := StringReplace(aPrincipalTemplate,'[%]OBRASGANHAS[%]',ObrasGanhas,[]);
        FEmailAEnviar.Text := StringReplace(FEmailAEnviar.Text,'[%]REGIAO[%]',aRegiao,[rfReplaceAll]);
        FEmailAEnviar.Text := StringReplace(FEmailAEnviar.Text,'[%]DATAHORAGERACAO[%]',FormatDateTime('dd/mm/yyyy "às" hh:nn:ss',Now),[]);
    finally
        if Assigned(RODataSet) then
            RODataSet.Free;
    end;
end;

procedure GerarEmailPorProprietario(const aObrasGanhas: TStringList;
                                    const aPrincipalTemplate
                                        , aObraTemplate
                                        , aPropostaTemplate: String;
                                    const aUsuarioCriador
                                        , aUsuarioModificador: ShortString);
var
    RODataSet: TZReadOnlyQuery;
    ObrasGanhas, Propostas, SQL: String;
    ObraId: ShortString;
begin
    ObrasGanhas := '';
    RODataSet := nil;
    try
        for ObraId in aObrasGanhas do
        begin
            if not Assigned(RODataSet) then
                RODataSet := TZReadOnlyQuery.Create(ZConnection_BDO);
                
            ObrasGanhas := ObrasGanhas + aObraTemplate;

            { Obtendo a proposta padrão da obra }
            SQL := StringReplace(SQL_PROPOSTAS,':IN_OBRAS_ID:',ObraId,[]);
            SQL := StringReplace(SQL,':PROPOSTAPADRAO:',' ',[]);
            ConfigureDataSet(ZConnection_BDO
                            ,RODataSet
                            ,SQL
                            ,False);

            ObrasGanhas := StringReplace(ObrasGanhas,'[%]NOMEDAOBRA[%]',RODataSet.FieldByName('NOMEDAOBRA').AsString,[]);
            ObrasGanhas := StringReplace(ObrasGanhas,'[%]LOCALIDADE[%]',RODataSet.FieldByName('LOCALIDADE').AsString,[]);
            ObrasGanhas := StringReplace(ObrasGanhas,'[%]RESPONSAVEIS[%]','',[]);

            Propostas := '<tr><td colspan="3" style="text-align: center">ESTA OBRA NÃO POSSUI PROPOSTAS</td><tr>';

            { Pode ser nulo, caso a obra não tenha propostas }
            if not RODataSet.FieldByName('PROPOSTA').IsNull then
            begin
                Propostas := '<tr><td colspan="3" style="text-align: center">ESTA OBRA POSSUI MAIS DE UMA PROPOSTA PADRÃO. CONTATE O SUPORTE TÉCNICO</td><tr>';

                if RODataSet.RecordCount = 1 then
                begin
                    Propostas := aPropostaTemplate;

                    if RODataSet.RecNo mod 2 = 0 then
                        Propostas := StringReplace(Propostas,'[%]LINHADECOR[%]',' style="background-color: #C0C0C0"',[])
                    else
                        Propostas := StringReplace(Propostas,'[%]LINHADECOR[%]','',[]);

                    Propostas := StringReplace(Propostas,'[%]PROPOSTA[%]',RODataSet.FieldByName('PROPOSTA').AsString,[]);
                    Propostas := StringReplace(Propostas,'[%]INSTALADOR[%]',RODataSet.FieldByName('INSTALADOR').AsString,[]);
                    Propostas := StringReplace(Propostas,'[%]VALOR[%]',IfThen(RODataSet.FieldByName('VALOR').AsString <> '',RODataSet.FieldByName('VALOR').AsString,'N/A'),[]);
                end;
            end;
            Application.ProcessMessages;
            ObrasGanhas := StringReplace(ObrasGanhas,'[%]PROPOSTAS[%]',Propostas,[]);
        end;
        FEmailAEnviar.Text := StringReplace(aPrincipalTemplate,'[%]OBRASGANHAS[%]',ObrasGanhas,[]);
        FEmailAEnviar.Text := StringReplace(FEmailAEnviar.Text,'[%]DATAHORAGERACAO[%]',FormatDateTime('dd/mm/yyyy "às" hh:nn:ss',Now),[]);

        if aUsuarioCriador = '' then
            FEmailAEnviar.Text := StringReplace(FEmailAEnviar.Text,'[%]USUARIOCRIADOR[%]','<span style="color: #FF0000">Não encontrado no sistema. O usuário foi excluído!</span>',[])
        else
            FEmailAEnviar.Text := StringReplace(FEmailAEnviar.Text,'[%]USUARIOCRIADOR[%]',aUsuarioCriador,[]);

        if aUsuarioModificador = '' then
            FEmailAEnviar.Text := StringReplace(FEmailAEnviar.Text,'[%]USUARIOMODIFICADOR[%]','<span style="color: #FF0000">Não encontrado no sistema. O usuário foi excluído!</span>',[])
        else
            FEmailAEnviar.Text := StringReplace(FEmailAEnviar.Text,'[%]USUARIOMODIFICADOR[%]',aUsuarioModificador,[])
    finally
        if Assigned(RODataSet) then
            RODataSet.Free;
    end;
end;

procedure EnviarEmailsPorRegiao(const aRegiao: ShortString);
var
    EmailsPara: ShortString;
begin
    { Obtem os e-mails que estão associados a regiões }
    EmailsPara := ObterEmails(Configurations.EmailsParaObrasGanhas,aRegiao);

    { Caso não haja e-mail a enviar, não envia nada! }
    if EmailsPara = '' then
        Exit;

    { Configura e inicia o processo de envio de e-mails }
    EnviarEmails(EmailsPara,'','BDI Informa: Obras Ganhas');
end;

procedure EnviarEmailsPorProprietario(const aEmailCriador, aEmailModificador: ShortString);
var
    EmailsPara, EmailsCc: String;
begin
    EmailsPara := '';

    if Trim(aEmailCriador) <> '' then
        EmailsPara := Trim(aEmailCriador);

    if (Trim(aEmailModificador) <> '') and (Trim(aEmailModificador) <> Trim(aEmailCriador)) then
    begin
        if EmailsPara <> '' then
            EmailsPara := EmailsPara + ',' + Trim(aEmailModificador)
        else
            EmailsPara := Trim(aEmailModificador)
    end;

    { Obtem os e-mails que não estão associados a regiões, que não contém "|" }
    EmailsCc := ObterEmails(Configurations.EmailsParaObrasGanhas);

    { Caso não haja e-mail para enviar, envia apenas para os e-mails configurados }
    if EmailsPara = '' then
    begin
        EmailsPara := EmailsCc;
        EmailsCc := '';
    end;

    { Caso não haja e-mail a enviar, não envia nada! }
    if EmailsPara = '' then
        Exit;

    { Configura e inicia o processo de envio de e-mails }
    EnviarEmails(EmailsPara,EmailsCc,'BDI Informa: Obras Ganhas');
end;
{$ENDREGION}
var
    RODataSet: TZReadOnlyQuery;
    CriadorID, ModificadorID: Word;
    {ListaDeObrasGanhas: TStringList;}
    RegiaoID: Byte;
    PrincipalTemplate, ObraTemplate, PropostaTemplate, ResponsaveisTemplate, SQL: String;
    EmailsAEnviar: Boolean;
begin
    {$IFDEF DEVELOPING}
    X := 0;
    {$ENDIF}

    FObrasAProcessar.Clear;{ListaDeObrasGanhas := nil;}
    RODataSet := nil;

    try
        FEnviandoEmail := eeObrasGanhas;
        MyModule.ProgressBar_EmailsParaObrasGanhas.Position := 0;
        MyModule.ProgressBar_EmailsParaObrasGanhas.Show;
        MyModule.Label_EmailsParaObrasGanhasValor.Caption := '? / ?';
        MyModule.Label_EmailsParaObrasGanhasValor.Show;
        MyModule.Label_EmailsParaObrasGanhasProximoEnvio.Hide;

        { Carregando template para uma obra }
        ObraTemplate := LoadTextFile(Configurations.CurrentDir + '\EmailTemplates\OBRASGANHAS\obra.template.html');

        { Carregando template para uma proposta }
        PropostaTemplate := LoadTextFile(Configurations.CurrentDir + '\EmailTemplates\OBRASGANHAS\proposta.template.html');

        { Carregando template principal por proprietário }
        PrincipalTemplate := LoadTextFile(Configurations.CurrentDir + '\EmailTemplates\OBRASGANHAS\principal_proprietario.template.html');
        PrincipalTemplate := StringReplace(PrincipalTemplate,'[%]HTTPHOST[%]',LowerCase(LocalHostName) + IfThen(Configurations.HTTPPort <> 80,':' + IntToStr(Configurations.HTTPPort),''),[rfReplaceAll]);
        PrincipalTemplate := StringReplace(PrincipalTemplate,'[%]INTERVALODECHECAGEMGERAL[%]',IntToStr(Configurations.IntervaloDeChecagemGeral),[rfReplaceAll]);
        PrincipalTemplate := StringReplace(PrincipalTemplate,'[%]RESPONSAVEIS[%]','',[]);


        { A partir deste ponto será configurada e executada uma consulta que
        retornará as obras ordenadas por responsáveis, em seguida e-mails serão
        enviados para os responsáveis e para a lista de e-mails que não tem
        especificidade com relação á região }
        {ListaDeObrasGanhas := TStringList.Create;}
        RODataSet := TZReadOnlyQuery.Create(nil);

        ObterObrasProcessadas('GANHA');

        SQL := StringReplace(SQL_OBRAS,':USUARIOCRIADOR:',' ',[rfReplaceAll]);
        SQL := StringReplace(SQL,':USUARIOMODIFICADOR:',' ',[rfReplaceAll]);
        SQL := StringReplace(SQL,':REGIAO:','#',[rfReplaceAll]);
//        SQL := StringReplace(SQL,':OBRASPROCESSADAS:',ObrasProcessadas,[rfReplaceAll]);
        SQL := StringReplace(SQL,':TI_SITUACOES_ID:',ObterIdSituacao('GANHA'),[]);
        SQL := StringReplace(SQL,':ORDER BY:','OBR.SM_USUARIOCRIADOR_ID, OBR.SM_USUARIOMODIFICADOR_ID',[rfReplaceAll]);

        ConfigureDataSet(ZConnection_BDO
                        ,RODataSet
                        ,SQL
                        ,False);

        { RODataSet conterá neste ponto uma lista com todas as obras ganhas não
        processadas ou zero, caso não haja nenhuma obra ganha não processada }
        if RODataSet.RecordCount > 0 then
        begin
            MyModule.ProgressBar_EmailsParaObrasGanhas.Max := EmailsAEnviarPorProprietario(RODataSet.SQL.Text);

            CriadorID := RODataSet.FieldByName('SM_USUARIOCRIADOR_ID').AsInteger;
            ModificadorID := RODataSet.FieldByName('SM_USUARIOMODIFICADOR_ID').AsInteger;
            EmailsAEnviar := HaEmailsAEnviar(Configurations.EmailsParaObrasGanhas
                                            ,0
                                            ,CriadorID
                                            ,ModificadorID);

            while not RODataSet.Eof do
            begin
                { Caso os proprietários mudem, devemos gerar e enviar o e-mail
                final para todos os recipientes obtidos até então }
                if (RODataSet.FieldByName('SM_USUARIOCRIADOR_ID').AsInteger <> CriadorID)
                or (RODataSet.FieldByName('SM_USUARIOMODIFICADOR_ID').AsInteger <> ModificadorID) then
                begin
                    if EmailsAEnviar then
                    begin
                        GerarEmailPorProprietario(FObrasAProcessar{ListaDeObrasGanhas}
                                                 ,PrincipalTemplate
                                                 ,ObraTemplate
                                                 ,PropostaTemplate
                                                 ,ObterNomeCompletoDoUsuario(CriadorID)
                                                 ,ObterNomeCompletoDoUsuario(ModificadorID));

                        EnviarEmailsPorProprietario(ObterEmailDoUsuario(CriadorID)
                                                   ,ObterEmailDoUsuario(ModificadorID));
                    end;

                    CriadorID := RODataSet.FieldByName('SM_USUARIOCRIADOR_ID').AsInteger;
                    ModificadorID := RODataSet.FieldByName('SM_USUARIOMODIFICADOR_ID').AsInteger;
                    EmailsAEnviar := HaEmailsAEnviar(Configurations.EmailsParaObrasGanhas
                                                    ,0
                                                    ,CriadorID
                                                    ,ModificadorID);

                    {ListaDeObrasGanhas.Clear;}
                    FObrasAProcessar.Clear;
                end;

                { Adicionando a obra da vez na lista obras ociosas para os
                proprietários atuais }
                if EmailsAEnviar then
                    {ListaDeObrasGanhas}FObrasAProcessar.Add(RODataSet.FieldByName('IN_OBRAS_ID').AsString);



                RODataSet.Next;

                { Caso eu tenha chegado ao fim eu devo enviar o restante dos
                e-mails }
                if RODataSet.Eof and EmailsAEnviar then
                begin
                    GerarEmailPorProprietario(FObrasAProcessar{ListaDeObrasGanhas}
                                             ,PrincipalTemplate
                                             ,ObraTemplate
                                             ,PropostaTemplate
                                             ,ObterNomeCompletoDoUsuario(CriadorID)
                                             ,ObterNomeCompletoDoUsuario(ModificadorID));

                    EnviarEmailsPorProprietario(ObterEmailDoUsuario(CriadorID)
                                               ,ObterEmailDoUsuario(ModificadorID));
                end;

                Application.ProcessMessages;
            end;

            { ================================================================ }
            { A partir deste ponto será configurada e executada uma consulta que
            retornará as obras ordenadas por regiões, em seguida e-mails serão
            enviados para a lista de e-mails referentes a cada uma das regiões }

            { Carregando template principal por região }
            PrincipalTemplate := LoadTextFile(Configurations.CurrentDir + '\EmailTemplates\OBRASGANHAS\principal_regiao.template.html');
            PrincipalTemplate := StringReplace(PrincipalTemplate,'[%]HTTPHOST[%]',LowerCase(LocalHostName) + IfThen(Configurations.HTTPPort <> 80,':' + IntToStr(Configurations.HTTPPort),''),[rfReplaceAll]);
            PrincipalTemplate := StringReplace(PrincipalTemplate,'[%]INTERVALODECHECAGEMGERAL[%]',IntToStr(Configurations.IntervaloDeChecagemGeral),[rfReplaceAll]);

            ResponsaveisTemplate := LoadTextFile(Configurations.CurrentDir + '\EmailTemplates\responsaveis.template.html');

            {ListaDeObrasGanhas}FObrasAProcessar.Clear;
            RODataSet.Close;

            SQL := StringReplace(SQL_OBRAS,':USUARIOCRIADOR:','#',[rfReplaceAll]);
            SQL := StringReplace(SQL,':USUARIOMODIFICADOR:','#',[rfReplaceAll]);
            SQL := StringReplace(SQL,':REGIAO:',' ',[rfReplaceAll]);
//            SQL := StringReplace(SQL,':OBRASPROCESSADAS:',ObrasProcessadas,[rfReplaceAll]);
            SQL := StringReplace(SQL,':TI_SITUACOES_ID:',ObterIdSituacao('GANHA'),[]);
            SQL := StringReplace(SQL,':ORDER BY:','OBR.TI_REGIOES_ID',[rfReplaceAll]);

            ConfigureDataSet(ZConnection_BDO
                            ,RODataSet
                            ,SQL
                            ,False);

            { Reconfigura a barra de progresso com o novo máximo }
            MyModule.ProgressBar_EmailsParaObrasGanhas.Max := MyModule.ProgressBar_EmailsParaObrasGanhas.Max + EmailsAEnviarPorRegiao(RODataSet.SQL.Text);

            RegiaoID := RODataSet.FieldByName('TI_REGIOES_ID').AsInteger;
            EmailsAEnviar := HaEmailsAEnviar(Configurations.EmailsParaObrasGanhas
                                            ,RegiaoID
                                            ,0
                                            ,0);

            while not RODataSet.Eof do
            begin
                { Caso as regiões mudem, devemos gerar e enviar o e-mail final
                para todos os recipientes obtidos até então }
                if RODataSet.FieldByName('TI_REGIOES_ID').AsInteger <> RegiaoID then
                begin
                    if EmailsAEnviar then
                    begin
                        GerarEmailPorRegiao(FObrasAProcessar{ListaDeObrasGanhas}
                                           ,PrincipalTemplate
                                           ,ObraTemplate
                                           ,PropostaTemplate
                                           ,ResponsaveisTemplate
                                           ,ObterRegiao(RegiaoID));

                        EnviarEmailsPorRegiao(ObterRegiao(RegiaoID));
                    end;

                    RegiaoID := RODataSet.FieldByName('TI_REGIOES_ID').AsInteger;
                    EmailsAEnviar := HaEmailsAEnviar(Configurations.EmailsParaObrasGanhas
                                                    ,RegiaoID
                                                    ,0
                                                    ,0);

                    {ListaDeObrasGanhas}FObrasAProcessar.Clear;
                end;

                { Adicionando a obra da vez na lista obras ociosas para os
                proprietários atuais }
                if EmailsAEnviar then
                    {ListaDeObrasGanhas}FObrasAProcessar.Add(RODataSet.FieldByName('IN_OBRAS_ID').AsString);

                RODataSet.Next;

                { Caso eu tenha chegado ao fim eu devo enviar o restante dos
                e-mails }
                if RODataSet.Eof and EmailsAEnviar then
                begin
                    GerarEmailPorRegiao(FObrasAProcessar{ListaDeObrasGanhas}
                                       ,PrincipalTemplate
                                       ,ObraTemplate
                                       ,PropostaTemplate
                                       ,ResponsaveisTemplate
                                       ,ObterRegiao(RegiaoID));

                    EnviarEmailsPorRegiao(ObterRegiao(RegiaoID));
                end;

                Application.ProcessMessages;
            end;
        end;
    finally
        MyModule.Label_EmailsParaObrasGanhasProximoEnvio.Caption := 'Próxima checagem em: --/--/---- às --:--:--';

        MyModule.ProgressBar_EmailsParaObrasGanhas.Hide;
        MyModule.Label_EmailsParaObrasGanhasValor.Hide;
        MyModule.Label_EmailsParaObrasGanhasProximoEnvio.Show;
        FEnviandoEmail := eeNenhum;

        RODataSet.Free;
        {ListaDeObrasGanhas.Free;}
    end;
end;

function TBDIDataModule_Main.GerarEEnviarEmailsParaObrasLimitrofes: Boolean;
{$REGION 'PROCEDIMENTOS LOCAIS'}
function EmailsAEnviarPorProprietario(aSQLOriginal: String): Word;
var
    RODataSet: TZReadOnlyQuery;
begin
    RODataSet := nil;
    try
        ConfigureDataSet(ZConnection_BDO
                        ,RODataSet
                        ,'SELECT * FROM (' + aSQLOriginal + ') T GROUP BY 2,3');

        Result := RODataSet.RecordCount;
    finally
        RODataSet.Free;
    end;
end;

function EmailsAEnviarPorRegiao(aSQLOriginal: String): Word;
var
    RODataSet: TZReadOnlyQuery;
begin
    RODataSet := nil;
    try
        ConfigureDataSet(ZConnection_BDO
                        ,RODataSet
                        ,'SELECT * FROM (' + aSQLOriginal + ') T GROUP BY 2');

        Result := RODataSet.RecordCount;
    finally
        RODataSet.Free;
    end;
end;

procedure GerarEmailPorRegiao(const aObrasLimitrofes: TStringList;
                              const aPrincipalTemplate
                                  , aObraTemplate
                                  , aPropostaTemplate
                                  , aResponsaveisTemplate: String;
                              const aRegiao: ShortString);
var
    RODataSet: TZReadOnlyQuery;
    ObrasLimitrofes, Propostas, SQL: String;
    ObraId: ShortString;
begin
    ObrasLimitrofes := '';
    RODataSet := nil;
    try
        for ObraId in aObrasLimitrofes do
        begin
            if not Assigned(RODataSet) then
                RODataSet := TZReadOnlyQuery.Create(ZConnection_BDO);
                
            ObrasLimitrofes := ObrasLimitrofes + aObraTemplate;

            { Obtendo lista de propostas da obra }
            SQL := StringReplace(SQL_PROPOSTAS,':IN_OBRAS_ID:',ObraId,[]);
            SQL := StringReplace(SQL,':PROPOSTAPADRAO:','#',[]);
            ConfigureDataSet(ZConnection_BDO
                            ,RODataSet
                            ,SQL
                            ,False);

            ObrasLimitrofes := StringReplace(ObrasLimitrofes,'[%]NOMEDAOBRA[%]',RODataSet.FieldByName('NOMEDAOBRA').AsString,[]);
            ObrasLimitrofes := StringReplace(ObrasLimitrofes,'[%]LOCALIDADE[%]',RODataSet.FieldByName('LOCALIDADE').AsString,[]);
            ObrasLimitrofes := StringReplace(ObrasLimitrofes,'[%]MESANO[%]',RODataSet.FieldByName('MESANO').AsString,[]);
            ObrasLimitrofes := StringReplace(ObrasLimitrofes,'[%]RESPONSAVEIS[%]',aResponsaveisTemplate,[]);
            ObrasLimitrofes := StringReplace(ObrasLimitrofes,'[%]PROPRIETARIOS[%]',ObterProprietarios(StrToInt(ObraId)),[]);
            ObrasLimitrofes := StringReplace(ObrasLimitrofes,'[%]BORDERBOTTOMRESPONSAVEIS[%]','#000000',[]);

            Propostas := '<tr><td colspan="3" style="text-align: center">ESTA OBRA NÃO POSSUI PROPOSTAS</td><tr>';

            { Pode ser nulo, caso a obra não tenha propostas }
            if not RODataSet.FieldByName('PROPOSTA').IsNull then
            begin
                Propostas := '';
                { Correndo a lista de propostas da obra }
                while not RODataSet.Eof do
                begin
                    Propostas := Propostas + aPropostaTemplate;

                    if RODataSet.RecNo mod 2 = 0 then
                    begin
                        if RODataSet.FieldByName('PROPOSTAPADRAO').AsInteger = 1 then
                            Propostas := StringReplace(Propostas,'[%]LINHADECOR[%]',' style="background-color: #C0C0C0; font-weight: bold; color: #FF0000"',[])
                        else
                            Propostas := StringReplace(Propostas,'[%]LINHADECOR[%]',' style="background-color: #C0C0C0"',[]);
                    end
                    else
                    begin
                        if RODataSet.FieldByName('PROPOSTAPADRAO').AsInteger = 1 then
                            Propostas := StringReplace(Propostas,'[%]LINHADECOR[%]',' style="font-weight: bold; color: #FF0000"',[])
                        else
                            Propostas := StringReplace(Propostas,'[%]LINHADECOR[%]','',[])
                    end;

                    Propostas := StringReplace(Propostas,'[%]PROPOSTA[%]',RODataSet.FieldByName('PROPOSTA').AsString,[]);
                    Propostas := StringReplace(Propostas,'[%]INSTALADOR[%]',RODataSet.FieldByName('INSTALADOR').AsString,[]);
                    Propostas := StringReplace(Propostas,'[%]VALOR[%]',IfThen(RODataSet.FieldByName('VALOR').AsString <> '',RODataSet.FieldByName('VALOR').AsString,'N/A'),[]);

                    RODataSet.Next;
                end;
            end;
            Application.ProcessMessages;
            ObrasLimitrofes := StringReplace(ObrasLimitrofes,'[%]PROPOSTAS[%]',Propostas,[]);
        end;
        FEmailAEnviar.Text := StringReplace(aPrincipalTemplate,'[%]OBRASLIMITROFES[%]',ObrasLimitrofes,[]);
        FEmailAEnviar.Text := StringReplace(FEmailAEnviar.Text,'[%]REGIAO[%]',aRegiao,[rfReplaceAll]);
        FEmailAEnviar.Text := StringReplace(FEmailAEnviar.Text,'[%]DATAHORAGERACAO[%]',FormatDateTime('dd/mm/yyyy "às" hh:nn:ss',Now),[]);
    finally
        if Assigned(RODataSet) then
            RODataSet.Free;
    end;
end;

procedure GerarEmailPorProprietario(const aObrasLimitrofes: TStringList;
                                    const aPrincipalTemplate
                                        , aObraTemplate
                                        , aPropostaTemplate: String;
                                    const aUsuarioCriador
                                        , aUsuarioModificador: ShortString);
var
    RODataSet: TZReadOnlyQuery;
    ObrasLimitrofes, Propostas, SQL: String;
    ObraId: ShortString;
begin
    ObrasLimitrofes := '';
    RODataSet := nil;
    try
        for ObraId in aObrasLimitrofes do
        begin
            if not Assigned(RODataSet) then
                RODataSet := TZReadOnlyQuery.Create(ZConnection_BDO);
                
            ObrasLimitrofes := ObrasLimitrofes + aObraTemplate;

            { Obtendo lista de propostas da obra }
            SQL := StringReplace(SQL_PROPOSTAS,':IN_OBRAS_ID:',ObraId,[]);
            SQL := StringReplace(SQL,':PROPOSTAPADRAO:','#',[]);
            ConfigureDataSet(ZConnection_BDO
                            ,RODataSet
                            ,SQL
                            ,False);

            ObrasLimitrofes := StringReplace(ObrasLimitrofes,'[%]NOMEDAOBRA[%]',RODataSet.FieldByName('NOMEDAOBRA').AsString,[]);
            ObrasLimitrofes := StringReplace(ObrasLimitrofes,'[%]LOCALIDADE[%]',RODataSet.FieldByName('LOCALIDADE').AsString,[]);
            ObrasLimitrofes := StringReplace(ObrasLimitrofes,'[%]MESANO[%]',RODataSet.FieldByName('MESANO').AsString,[]);
            ObrasLimitrofes := StringReplace(ObrasLimitrofes,'[%]RESPONSAVEIS[%]','',[]);

            Propostas := '<tr><td colspan="3" style="text-align: center">ESTA OBRA NÃO POSSUI PROPOSTAS</td><tr>';

            { Pode ser nulo, caso a obra não tenha propostas }
            if not RODataSet.FieldByName('PROPOSTA').IsNull then
            begin
                Propostas := '';
                { Correndo a lista de propostas da obra }
                while not RODataSet.Eof do
                begin
                    Propostas := Propostas + aPropostaTemplate;

                    if RODataSet.RecNo mod 2 = 0 then
                    begin
                        if RODataSet.FieldByName('PROPOSTAPADRAO').AsInteger = 1 then
                            Propostas := StringReplace(Propostas,'[%]LINHADECOR[%]',' style="background-color: #C0C0C0; font-weight: bold; color: #FF0000"',[])
                        else
                            Propostas := StringReplace(Propostas,'[%]LINHADECOR[%]',' style="background-color: #C0C0C0"',[]);
                    end
                    else
                    begin
                        if RODataSet.FieldByName('PROPOSTAPADRAO').AsInteger = 1 then
                            Propostas := StringReplace(Propostas,'[%]LINHADECOR[%]',' style="font-weight: bold; color: #FF0000"',[])
                        else
                            Propostas := StringReplace(Propostas,'[%]LINHADECOR[%]','',[])
                    end;

                    Propostas := StringReplace(Propostas,'[%]PROPOSTA[%]',RODataSet.FieldByName('PROPOSTA').AsString,[]);
                    Propostas := StringReplace(Propostas,'[%]INSTALADOR[%]',RODataSet.FieldByName('INSTALADOR').AsString,[]);
                    Propostas := StringReplace(Propostas,'[%]VALOR[%]',IfThen(RODataSet.FieldByName('VALOR').AsString <> '',RODataSet.FieldByName('VALOR').AsString,'N/A'),[]);

                    RODataSet.Next;
                end;
            end;
            Application.ProcessMessages;
            ObrasLimitrofes := StringReplace(ObrasLimitrofes,'[%]PROPOSTAS[%]',Propostas,[]);
        end;
        FEmailAEnviar.Text := StringReplace(aPrincipalTemplate,'[%]OBRASLIMITROFES[%]',ObrasLimitrofes,[]);
        FEmailAEnviar.Text := StringReplace(FEmailAEnviar.Text,'[%]DATAHORAGERACAO[%]',FormatDateTime('dd/mm/yyyy "às" hh:nn:ss',Now),[]);

        if aUsuarioCriador = '' then
            FEmailAEnviar.Text := StringReplace(FEmailAEnviar.Text,'[%]USUARIOCRIADOR[%]','<span style="color: #FF0000">Não encontrado no sistema. O usuário foi excluído!</span>',[])
        else
            FEmailAEnviar.Text := StringReplace(FEmailAEnviar.Text,'[%]USUARIOCRIADOR[%]',aUsuarioCriador,[]);

        if aUsuarioModificador = '' then
            FEmailAEnviar.Text := StringReplace(FEmailAEnviar.Text,'[%]USUARIOMODIFICADOR[%]','<span style="color: #FF0000">Não encontrado no sistema. O usuário foi excluído!</span>',[])
        else
            FEmailAEnviar.Text := StringReplace(FEmailAEnviar.Text,'[%]USUARIOMODIFICADOR[%]',aUsuarioModificador,[])
    finally
        if Assigned(RODataSet) then
            RODataSet.Free;
    end;
end;

procedure EnviarEmailsPorRegiao(const aRegiao: ShortString);
var
    EmailsPara: ShortString;
begin
    { Obtem os e-mails que não estão associados a regiões, que não contém "|" }
    EmailsPara := ObterEmails(Configurations.EmailsParaObrasLimitrofes,aRegiao);

    { Caso não haja e-mail a enviar, não envia nada! }
    if EmailsPara = '' then
        Exit;

    { Configura e inicia o processo de envio de e-mails }
    EnviarEmails(EmailsPara,'','BDI Informa: Obras Limítrofes');
end;

procedure EnviarEmailsPorProprietario(const aEmailCriador, aEmailModificador: ShortString);
var
    EmailsPara, EmailsCc: String;
begin
    EmailsPara := '';

    if Trim(aEmailCriador) <> '' then
        EmailsPara := Trim(aEmailCriador);

    if (Trim(aEmailModificador) <> '') and (Trim(aEmailModificador) <> Trim(aEmailCriador)) then
    begin
        if EmailsPara <> '' then
            EmailsPara := EmailsPara + ',' + Trim(aEmailModificador)
        else
            EmailsPara := Trim(aEmailModificador)
    end;

    { Obtem os e-mails que não estão associados a regiões, que não contém "|" }
    EmailsCc := ObterEmails(Configurations.EmailsParaObrasLimitrofes);

    { Caso não haja e-mail para enviar, envia apenas para os e-mails configurados }
    if EmailsPara = '' then
    begin
        EmailsPara := EmailsCc;
        EmailsCc := '';
    end;

    { Caso não haja e-mail a enviar, não envia nada! }
    if EmailsPara = '' then
        Exit;

    { Configura e inicia o processo de envio de e-mails }
    EnviarEmails(EmailsPara,EmailsCc,'BDI Informa: Obras Limítrofes');
end;
{$ENDREGION}
const
    SQL_OBRAS_LIMITROFES =
    '  SELECT OBR.IN_OBRAS_ID'#13#10 +
    '       :USUARIOCRIADOR:, OBR.SM_USUARIOCRIADOR_ID'#13#10 +
    '       :USUARIOMODIFICADOR:, OBR.SM_USUARIOMODIFICADOR_ID'#13#10 +
    '       :REGIAO:, OBR.TI_REGIOES_ID'#13#10 +
    '    FROM OBRAS OBR'#13#10 +
    '   WHERE OBR.TI_SITUACOES_ID IN (SELECT * FROM VIW_ACTIVE_SITUATIONS)'#13#10 +
    '     AND DATEDIFF(STR_TO_DATE(CONCAT(OBR.YR_ANOPROVAVELDEENTREGA,''-'',OBR.TI_MESPROVAVELDEENTREGA,''-'',''01 00:00:00''),''%Y-%m-%d %T''),NOW()) <= :DIASLIMITROFES:'#13#10 +
    'ORDER BY :ORDER BY:';
var
    RODataSet: TZReadOnlyQuery;
    CriadorID, ModificadorID: Word;
    {ListaDeObrasLimitrofes: TStringList;}
    PrincipalTemplate, ObraTemplate, PropostaTemplate, ResponsaveisTemplate, SQL: String;
    RegiaoID: Byte;
    EmailsAEnviar: Boolean;
begin
    {$IFDEF DEVELOPING}
    X := 0;
    {$ENDIF}
    Result := False;

    if Now <= FProximoEnvioParaObrasLimitrofes then
        Exit;

    FObrasAProcessar.Clear;{ListaDeObrasLimitrofes := nil;}
    RODataSet := nil;
    try
        FEnviandoEmail := eeObrasLimitrofes;

        { Carregando template para uma obra }
        ObraTemplate := LoadTextFile(Configurations.CurrentDir + '\EmailTemplates\OBRASLIMITROFES\obra.template.html');

        { Carregando template para uma proposta }
        PropostaTemplate := LoadTextFile(Configurations.CurrentDir + '\EmailTemplates\OBRASLIMITROFES\proposta.template.html');

        { Carregando template principal por proprietarios }
        PrincipalTemplate := LoadTextFile(Configurations.CurrentDir + '\EmailTemplates\OBRASLIMITROFES\principal_proprietario.template.html');
        PrincipalTemplate := StringReplace(PrincipalTemplate,'[%]HTTPHOST[%]',LowerCase(LocalHostName) + IfThen(Configurations.HTTPPort <> 80,':' + IntToStr(Configurations.HTTPPort),''),[rfReplaceAll]);
        PrincipalTemplate := StringReplace(PrincipalTemplate,'[%]DIASPARAAVISO[%]',IntToStr(Configurations.DiasParaAviso),[]);
        PrincipalTemplate := StringReplace(PrincipalTemplate,'[%]INTERVALODECHECAGEMDELIMITROFES[%]',IntToStr(Configurations.IntervaloDeChecagemDeLimitrofes),[]);
        PrincipalTemplate := StringReplace(PrincipalTemplate,'[%]RESPONSAVEIS[%]','',[]);


        { A partir deste ponto será configurada e executada uma consulta que
        retornará as obras ordenadas por responsáveis, em seguida e-mails serão
        enviados para os responsáveis e para a lista de e-mails que não tem
        especificidade com relação á região }
        {ListaDeObrasLimitrofes := TStringList.Create;}
        RODataSet := TZReadOnlyQuery.Create(nil);

        SQL := StringReplace(SQL_OBRAS_LIMITROFES,':USUARIOCRIADOR:',' ',[rfReplaceAll]);
        SQL := StringReplace(SQL,':USUARIOMODIFICADOR:',' ',[rfReplaceAll]);
        SQL := StringReplace(SQL,':REGIAO:','#',[rfReplaceAll]);
        SQL := StringReplace(SQL,':DIASLIMITROFES:',IntToStr(Configurations.DiasParaAviso),[rfReplaceAll]);
        SQL := StringReplace(SQL,':ORDER BY:','OBR.SM_USUARIOCRIADOR_ID, OBR.SM_USUARIOMODIFICADOR_ID',[rfReplaceAll]);

        ConfigureDataSet(ZConnection_BDO
                        ,RODataSet
                        ,SQL
                        ,False);

        { RODataSet conterá neste ponto uma lista com todas as obras ociosas ou
        zero, caso não haja nenhuma obra ociosa }
        if RODataSet.RecordCount > 0 then
        begin
            MyModule.ProgressBar_EmailsParaObrasLimitrofes.Position := 0;
            MyModule.ProgressBar_EmailsParaObrasLimitrofes.Max := EmailsAEnviarPorProprietario(RODataSet.SQL.Text);
            MyModule.ProgressBar_EmailsParaObrasLimitrofes.Show;
            MyModule.Label_EmailsParaObrasLimitrofesValor.Show;
            MyModule.Label_EmailsParaObrasLimitrofesProximoEnvio.Hide;

            CriadorID := RODataSet.FieldByName('SM_USUARIOCRIADOR_ID').AsInteger;
            ModificadorID := RODataSet.FieldByName('SM_USUARIOMODIFICADOR_ID').AsInteger;
            EmailsAEnviar := HaEmailsAEnviar(Configurations.EmailsParaObrasLimitrofes
                                            ,0
                                            ,CriadorID
                                            ,ModificadorID);

            while not RODataSet.Eof do
            begin
                { Caso os proprietários mudem, devemos gerar e enviar o e-mail
                final para todos os recipientes obtidos até então }
                if (RODataSet.FieldByName('SM_USUARIOCRIADOR_ID').AsInteger <> CriadorID)
                or (RODataSet.FieldByName('SM_USUARIOMODIFICADOR_ID').AsInteger <> ModificadorID) then
                begin
                    if EmailsAEnviar then
                    begin
                        GerarEmailPorProprietario(FObrasAProcessar{ListaDeObrasLimitrofes}
                                                 ,PrincipalTemplate
                                                 ,ObraTemplate
                                                 ,PropostaTemplate
                                                 ,ObterNomeCompletoDoUsuario(CriadorID)
                                                 ,ObterNomeCompletoDoUsuario(ModificadorID));

                        EnviarEmailsPorProprietario(ObterEmailDoUsuario(CriadorID)
                                                   ,ObterEmailDoUsuario(ModificadorID));
                    end;

                    CriadorID := RODataSet.FieldByName('SM_USUARIOCRIADOR_ID').AsInteger;
                    ModificadorID := RODataSet.FieldByName('SM_USUARIOMODIFICADOR_ID').AsInteger;
                    EmailsAEnviar := HaEmailsAEnviar(Configurations.EmailsParaObrasLimitrofes
                                                    ,0
                                                    ,CriadorID
                                                    ,ModificadorID);

                    FObrasAProcessar{ListaDeObrasLimitrofes}.Clear;
                end;
                { Adicionando a obra da vez na lista obras ociosas para os
                proprietários atuais }
                if EmailsAEnviar then
                    {ListaDeObrasLimitrofes}FObrasAProcessar.Add(RODataSet.FieldByName('IN_OBRAS_ID').AsString);

                RODataSet.Next;

                { Caso eu tenha chegado ao fim eu devo enviar o restante dos
                e-mails }
                if RODataSet.Eof and EmailsAEnviar then
                begin
                    GerarEmailPorProprietario(FObrasAProcessar{ListaDeObrasLimitrofes}
                                             ,PrincipalTemplate
                                             ,ObraTemplate
                                             ,PropostaTemplate
                                             ,ObterNomeCompletoDoUsuario(CriadorID)
                                             ,ObterNomeCompletoDoUsuario(ModificadorID));

                    EnviarEmailsPorProprietario(ObterEmailDoUsuario(CriadorID)
                                               ,ObterEmailDoUsuario(ModificadorID));
                end;

                Application.ProcessMessages;
            end;

            { ================================================================ }
            { A partir deste ponto será configurada e executada uma consulta que
            retornará as obras ordenadas por regiões, em seguida e-mails serão
            enviados para a lista de e-mails de acordo com cada região }

            { Carregando template principal por região }
            PrincipalTemplate := LoadTextFile(Configurations.CurrentDir + '\EmailTemplates\OBRASLIMITROFES\principal_regiao.template.html');
            PrincipalTemplate := StringReplace(PrincipalTemplate,'[%]HTTPHOST[%]',LowerCase(LocalHostName) + IfThen(Configurations.HTTPPort <> 80,':' + IntToStr(Configurations.HTTPPort),''),[rfReplaceAll]);
            PrincipalTemplate := StringReplace(PrincipalTemplate,'[%]DIASPARAAVISO[%]',IntToStr(Configurations.DiasParaAviso),[]);
            PrincipalTemplate := StringReplace(PrincipalTemplate,'[%]INTERVALODECHECAGEMDELIMITROFES[%]',IntToStr(Configurations.IntervaloDeChecagemDeLimitrofes),[]);

            ResponsaveisTemplate := LoadTextFile(Configurations.CurrentDir + '\EmailTemplates\responsaveis.template.html');

            {ListaDeObrasLimitrofes}FObrasAProcessar.Clear;
            RODataSet.Close;

            SQL := StringReplace(SQL_OBRAS_LIMITROFES,':USUARIOCRIADOR:','#',[rfReplaceAll]);
            SQL := StringReplace(SQL,':USUARIOMODIFICADOR:','#',[rfReplaceAll]);
            SQL := StringReplace(SQL,':REGIAO:',' ',[rfReplaceAll]);
            SQL := StringReplace(SQL,':DIASLIMITROFES:',IntToStr(Configurations.DiasParaAviso),[rfReplaceAll]);
            SQL := StringReplace(SQL,':ORDER BY:','OBR.TI_REGIOES_ID',[rfReplaceAll]);

            ConfigureDataSet(ZConnection_BDO
                            ,RODataSet
                            ,SQL
                            ,False);

            MyModule.ProgressBar_EmailsParaObrasLimitrofes.Max := MyModule.ProgressBar_EmailsParaObrasLimitrofes.Max + EmailsAEnviarPorRegiao(RODataSet.SQL.Text);

            RegiaoID := RODataSet.FieldByName('TI_REGIOES_ID').AsInteger;
            EmailsAEnviar := HaEmailsAEnviar(Configurations.EmailsParaObrasLimitrofes
                                            ,RegiaoID
                                            ,0
                                            ,0);

            while not RODataSet.Eof do
            begin
                { Caso as regiões mudem, devemos gerar e enviar o e-mail final
                para todos os recipientes obtidos até então }
                if RODataSet.FieldByName('TI_REGIOES_ID').AsInteger <> RegiaoID then
                begin
                    if EmailsAEnviar then
                    begin
                        GerarEmailPorRegiao(FObrasAProcessar{ListaDeObrasLimitrofes}
                                           ,PrincipalTemplate
                                           ,ObraTemplate
                                           ,PropostaTemplate
                                           ,ResponsaveisTemplate
                                           ,ObterRegiao(RegiaoID));

                        EnviarEmailsPorRegiao(ObterRegiao(RegiaoID));
                    end;

                    RegiaoID := RODataSet.FieldByName('TI_REGIOES_ID').AsInteger;
                    EmailsAEnviar := HaEmailsAEnviar(Configurations.EmailsParaObrasLimitrofes
                                                    ,RegiaoID
                                                    ,0
                                                    ,0);

                    {ListaDeObrasLimitrofes}FObrasAProcessar.Clear;
                end;
                { Adicionando a obra da vez na lista obras ociosas para os
                proprietários atuais }
                if EmailsAEnviar then
                    {ListaDeObrasLimitrofes}FObrasAProcessar.Add(RODataSet.FieldByName('IN_OBRAS_ID').AsString);

                RODataSet.Next;

                { Caso eu tenha chegado ao fim eu devo enviar o restante dos
                e-mails }
                if RODataSet.Eof and EmailsAEnviar then
                begin
                    GerarEmailPorRegiao(FObrasAProcessar{ListaDeObrasLimitrofes}
                                       ,PrincipalTemplate
                                       ,ObraTemplate
                                       ,PropostaTemplate
                                       ,ResponsaveisTemplate
                                       ,ObterRegiao(RegiaoID));

                    EnviarEmailsPorRegiao(ObterRegiao(RegiaoID));
                end;

                Application.ProcessMessages;
            end;
        end;
    finally
        Result := True;
        MyModule.Label_EmailsParaObrasLimitrofesProximoEnvio.Caption := 'Próxima checagem em: --/--/---- às --:--:--';
        MyModule.ProgressBar_EmailsParaObrasLimitrofes.Hide;
        MyModule.Label_EmailsParaObrasLimitrofesValor.Hide;
        MyModule.Label_EmailsParaObrasLimitrofesProximoEnvio.Show;
        FEnviandoEmail := eeNenhum;

        RODataSet.Free;
        {ListaDeObrasLimitrofes.Free;}
    end;
end;

procedure TBDIDataModule_Main.ObrasOciosasAddProgress;
begin
    MyModule.ProgressBar_EmailsParaObrasOciosas.StepIt;
    MyModule.Label_EmailsParaObrasOciosasValor.Caption := Format('%u / %u',[MyModule.ProgressBar_EmailsParaObrasOciosas.Position,MyModule.ProgressBar_EmailsParaObrasOciosas.Max]);
    Application.ProcessMessages;
end;

procedure TBDIDataModule_Main.ObrasPerdidasAddProgress;
begin
    ProcessarObras('PERDIDA');
    MyModule.ProgressBar_EmailsParaObrasPerdidas.StepIt;
    MyModule.Label_EmailsParaObrasPerdidasValor.Caption := Format('%u / %u',[MyModule.ProgressBar_EmailsParaObrasPerdidas.Position,MyModule.ProgressBar_EmailsParaObrasPerdidas.Max]);
    Application.ProcessMessages;
end;

procedure TBDIDataModule_Main.ObrasGanhasAddProgress;
begin
    ProcessarObras('GANHA');
    MyModule.ProgressBar_EmailsParaObrasGanhas.StepIt;
    MyModule.Label_EmailsParaObrasGanhasValor.Caption := Format('%u / %u',[MyModule.ProgressBar_EmailsParaObrasGanhas.Position,MyModule.ProgressBar_EmailsParaObrasGanhas.Max]);
    Application.ProcessMessages;
end;

procedure TBDIDataModule_Main.ObrasLimitrofesAddProgress;
begin
    MyModule.ProgressBar_EmailsParaObrasLimitrofes.StepIt;
    MyModule.Label_EmailsParaObrasLimitrofesValor.Caption := Format('%u / %u',[MyModule.ProgressBar_EmailsParaObrasLimitrofes.Position,MyModule.ProgressBar_EmailsParaObrasLimitrofes.Max]);
    Application.ProcessMessages;
end;

function TBDIDataModule_Main.HaEmailsAEnviar(aListaDeEMails: TStringList;
                                             aIDRegiao: Byte;
                                             aIDCriador: Word;
                                             aIDModificador: Word): Boolean;
begin
    if aIDRegiao <> 0 then
    begin
        Result := ObterEmails(aListaDeEMails,ObterRegiao(aIDRegiao)) <> '';
    end
    else
    begin
        Result := (ObterEmailDoUsuario(aIDCriador) <> '')
               or (ObterEmailDoUsuario(aIDModificador) <> '')
               or (ObterEmails(aListaDeEMails) <> '');
    end;
end;

function TBDIDataModule_Main.ObterEmails(const aListaDeEmails: TStringList;
                                         const aRegiaoAssociada: ShortString = ''): String;
var
    Linha, Email: ShortString;
begin
    {
      Formato:
        [[<REGIAO1>][<REGIAO2>][<REGIAO3>][<REGIAOn>]|]EMAIL
      Exemplos:
        FPE|xyz@host.com
        FPE - BA,FPE|abc@host.com
        FSP,FSP - SF,FPE - SF|xyz@host.com
    }
    Result := '';
    for Linha in aListaDeEmails do
    begin
        { Se achou um e-mail especial (com PIPE)... }
        if Pos('|',Linha) > 0 then
        begin
            { ...processa apenas caso "aRegiaoAssociada" tenha sido informada e
            se esta está presente na linha }
            if (aRegiaoAssociada <> '') and (Pos('<' + UpperCase(aRegiaoAssociada) + '>',UpperCase(Linha)) > 0) then
            begin
                if Result <> '' then
                    Result := Result + ',';

                { Só inclui o e-mail caso ele realmente exista... }
                Email := Trim(Copy(Linha,Pos('|',Linha) + 1,Length(Linha)));
                if Email <> '' then
                    Result := Result + Email;
            end;
        end
        { Se achou um e-mail comum (sem PIPE)... }
        else
        begin
            { ...processa apenas caso "aRegiaoAssociada" não tenha sido
            informada }
            if aRegiaoAssociada = '' then
            begin
                if Result <> '' then
                    Result := Result + ',';

                { Só inclui o e-mail caso ele realmente exista... }
                if Trim(Linha) <> '' then
                    Result := Result + Linha;
            end;
        end;
    end;
    Result := Trim(Result);
end;

function TBDIDataModule_Main.ObterIdSituacao(aSituacao: ShortString): ShortString;
var
	Situacoes: TZReadOnlyQuery;
begin
    Result := '0';

	Situacoes := nil;
    try
	    ConfigureDataSet(ZConnection_BDO
                        ,Situacoes
                        ,'SELECT TI_SITUACOES_ID FROM SITUACOES WHERE UPPER(VA_DESCRICAO) = UPPER(' + QuotedStr(aSituacao) + ')');

	    if Situacoes.RecordCount = 1 then
            Result := Situacoes.Fields[0].AsString;
    finally
	    if Assigned(Situacoes) then
    		Situacoes.Free;
    end;
end;

procedure TBDIDataModule_Main.EnviarEmails(const aTo
                                               , aCc
                                               , aSubject: ShortString);

begin
    { Configurando propriedades específicas para este e-mail }
    with SmtpCli_BDI do
    begin
        RcptName.Clear;
        RcptNameAdd(aTo
                   ,aCc
                   ,'');
        HdrTo := aTo;
        HdrCc := aCc;
        HdrSubject := aSubject;
        {$IFNDEF DEVELOPING}
        Connect;
        {$ENDIF}
        { A partir deste ponto o restante se dará dentro do evento OnRequestDone }
    end;

    {$IFDEF DEVELOPING}
    Inc(x);

    FEmailAEnviar.Text := 'Para: <b>' + aTo + '</b>'#13#10'<br>CC: <b>' + aCc + '</b>'#13#10'<br>Assunto: <b>' + aSubject + '</b><br>' + FEmailAEnviar.Text;

    if Pos('OCIOSAS',UpperCase(aSubject)) > 0 then
    begin
        SaveTextFile(FEmailAEnviar.Text,Configurations.CurrentDir + '\EmailTemplates\_EMAILSGERADOS\ObrasOciosas' + IntToStr(x) + '.html');
        ObrasOciosasAddProgress;
    end
    else if Pos('LIMÍTROFES',AnsiUpperCase(aSubject)) > 0 then
    begin
        SaveTextFile(FEmailAEnviar.Text,Configurations.CurrentDir + '\EmailTemplates\_EMAILSGERADOS\ObrasLimitrofes' + IntToStr(x) + '.html');
        ObrasLimitrofesAddProgress;
    end
    else if Pos('GANHAS',AnsiUpperCase(aSubject)) > 0 then
    begin
        SaveTextFile(FEmailAEnviar.Text,Configurations.CurrentDir + '\EmailTemplates\_EMAILSGERADOS\ObrasGanhas' + IntToStr(x) + '.html');
        ObrasGanhasAddProgress;
    end
    else if Pos('PERDIDAS',AnsiUpperCase(aSubject)) > 0 then
    begin
        SaveTextFile(FEmailAEnviar.Text,Configurations.CurrentDir + '\EmailTemplates\_EMAILSGERADOS\ObrasPerdidas' + IntToStr(x) + '.html');
        ObrasPerdidasAddProgress;
    end;
    {$ENDIF}
end;

function TBDIDataModule_Main.GerarEEnviarEmailsParaObrasOciosas: Boolean;
{$REGION 'PROCEDIMENTOS LOCAIS'}
function EmailsAEnviarPorProprietario(aSQLOriginal: String): Word;
var
    RODataSet: TZReadOnlyQuery;
begin
    RODataSet := nil;
    try
        ConfigureDataSet(ZConnection_BDO
                        ,RODataSet
                        ,'SELECT * FROM (' + aSQLOriginal + ') T GROUP BY 2,3');

        Result := RODataSet.RecordCount;
    finally
        RODataSet.Free;
    end;
end;

function EmailsAEnviarPorRegiao(aSQLOriginal: String): Word;
var
    RODataSet: TZReadOnlyQuery;
begin
    RODataSet := nil;
    try
        ConfigureDataSet(ZConnection_BDO
                        ,RODataSet
                        ,'SELECT * FROM (' + aSQLOriginal + ') T GROUP BY 2');

        Result := RODataSet.RecordCount;
    finally
        RODataSet.Free;
    end;
end;

procedure GerarEmailPorRegiao(const aObrasOciosas: TStringList;
                              const aPrincipalTemplate
                                  , aObraTemplate
                                  , aPropostaTemplate
                                  , aResponsaveisTemplate: String;
                              const aRegiao: ShortString);
var
    RODataSet: TZReadOnlyQuery;
    ObrasOciosas, Propostas, SQL: String;
    ObraId: ShortString;
begin
    ObrasOciosas := '';
    RODataSet := nil;
    try
        for ObraId in aObrasOciosas do
        begin
            if not Assigned(RODataSet) then
                RODataSet := TZReadOnlyQuery.Create(ZConnection_BDO);
                
            ObrasOciosas := ObrasOciosas + aObraTemplate;

            { Obtendo lista de propostas da obra }
            SQL := StringReplace(SQL_PROPOSTAS,':IN_OBRAS_ID:',ObraId,[]);
            SQL := StringReplace(SQL,':PROPOSTAPADRAO:','#',[]);
            ConfigureDataSet(ZConnection_BDO
                            ,RODataSet
                            ,SQL
                            ,False);

            ObrasOciosas := StringReplace(ObrasOciosas,'[%]NOMEDAOBRA[%]',RODataSet.FieldByName('NOMEDAOBRA').AsString,[]);
            ObrasOciosas := StringReplace(ObrasOciosas,'[%]LOCALIDADE[%]',RODataSet.FieldByName('LOCALIDADE').AsString,[]);
            ObrasOciosas := StringReplace(ObrasOciosas,'[%]RESPONSAVEIS[%]',aResponsaveisTemplate,[]);
            ObrasOciosas := StringReplace(ObrasOciosas,'[%]PROPRIETARIOS[%]',ObterProprietarios(StrToInt(ObraId)),[]);
            ObrasOciosas := StringReplace(ObrasOciosas,'[%]BORDERBOTTOMRESPONSAVEIS[%]','#000000',[]);

            Propostas := '<tr><td colspan="3" style="text-align: center">ESTA OBRA NÃO POSSUI PROPOSTAS</td><tr>';

            { Pode ser nulo, caso a obra não tenha propostas }
            if not RODataSet.FieldByName('PROPOSTA').IsNull then
            begin
                Propostas := '';
                { Correndo a lista de propostas da obra }
                while not RODataSet.Eof do
                begin
                    Propostas := Propostas + aPropostaTemplate;

                    if RODataSet.RecNo mod 2 = 0 then
                    begin
                        if RODataSet.FieldByName('PROPOSTAPADRAO').AsInteger = 1 then
                            Propostas := StringReplace(Propostas,'[%]LINHADECOR[%]',' style="background-color: #C0C0C0; font-weight: bold; color: #FF0000"',[])
                        else
                            Propostas := StringReplace(Propostas,'[%]LINHADECOR[%]',' style="background-color: #C0C0C0"',[]);
                    end
                    else
                    begin
                        if RODataSet.FieldByName('PROPOSTAPADRAO').AsInteger = 1 then
                            Propostas := StringReplace(Propostas,'[%]LINHADECOR[%]',' style="font-weight: bold; color: #FF0000"',[])
                        else
                            Propostas := StringReplace(Propostas,'[%]LINHADECOR[%]','',[])
                    end;

                    Propostas := StringReplace(Propostas,'[%]PROPOSTA[%]',RODataSet.FieldByName('PROPOSTA').AsString,[]);
                    Propostas := StringReplace(Propostas,'[%]INSTALADOR[%]',RODataSet.FieldByName('INSTALADOR').AsString,[]);
                    Propostas := StringReplace(Propostas,'[%]VALOR[%]',IfThen(RODataSet.FieldByName('VALOR').AsString <> '',RODataSet.FieldByName('VALOR').AsString,'N/A'),[]);

                    RODataSet.Next;
                end;
            end;
            Application.ProcessMessages;
            ObrasOciosas := StringReplace(ObrasOciosas,'[%]PROPOSTAS[%]',Propostas,[]);
        end;
        FEmailAEnviar.Text := StringReplace(aPrincipalTemplate,'[%]OBRASOCIOSAS[%]',ObrasOciosas,[]);
        FEmailAEnviar.Text := StringReplace(FEmailAEnviar.Text,'[%]REGIAO[%]',aRegiao,[rfReplaceAll]);
        FEmailAEnviar.Text := StringReplace(FEmailAEnviar.Text,'[%]DATAHORAGERACAO[%]',FormatDateTime('dd/mm/yyyy "às" hh:nn:ss',Now),[]);
    finally
        if Assigned(RODataSet) then
            RODataSet.Free;
    end;
end;

procedure GerarEmailPorProprietario(const aObrasOciosas: TStringList;
                                    const aPrincipalTemplate
                                        , aObraTemplate
                                        , aPropostaTemplate: String;
                                    const aUsuarioCriador
                                        , aUsuarioModificador: ShortString);
var
    RODataSet: TZReadOnlyQuery;
    ObrasOciosas, Propostas, SQL: String;
    ObraId: ShortString;
begin
    ObrasOciosas := '';
    RODataSet := nil;
    try
        for ObraId in aObrasOciosas do
        begin
            if not Assigned(RODataSet) then
                RODataSet := TZReadOnlyQuery.Create(ZConnection_BDO);
                
            ObrasOciosas := ObrasOciosas + aObraTemplate;

            { Obtendo lista de propostas da obra }
            SQL := StringReplace(SQL_PROPOSTAS,':IN_OBRAS_ID:',ObraId,[]);
            SQL := StringReplace(SQL,':PROPOSTAPADRAO:','#',[]);
            ConfigureDataSet(ZConnection_BDO
                            ,RODataSet
                            ,SQL
                            ,False);

            ObrasOciosas := StringReplace(ObrasOciosas,'[%]NOMEDAOBRA[%]',RODataSet.FieldByName('NOMEDAOBRA').AsString,[]);
            ObrasOciosas := StringReplace(ObrasOciosas,'[%]LOCALIDADE[%]',RODataSet.FieldByName('LOCALIDADE').AsString,[]);
            ObrasOciosas := StringReplace(ObrasOciosas,'[%]RESPONSAVEIS[%]','',[]);


            Propostas := '<tr><td colspan="3" style="text-align: center">ESTA OBRA NÃO POSSUI PROPOSTAS</td><tr>';

            { Pode ser nulo, caso a obra não tenha propostas }
            if not RODataSet.FieldByName('PROPOSTA').IsNull then
            begin
                Propostas := '';
                { Correndo a lista de propostas da obra }
                while not RODataSet.Eof do
                begin
                    Propostas := Propostas + aPropostaTemplate;

                    if RODataSet.RecNo mod 2 = 0 then
                    begin
                        if RODataSet.FieldByName('PROPOSTAPADRAO').AsInteger = 1 then
                            Propostas := StringReplace(Propostas,'[%]LINHADECOR[%]',' style="background-color: #C0C0C0; font-weight: bold; color: #FF0000"',[])
                        else
                            Propostas := StringReplace(Propostas,'[%]LINHADECOR[%]',' style="background-color: #C0C0C0"',[]);
                    end
                    else
                    begin
                        if RODataSet.FieldByName('PROPOSTAPADRAO').AsInteger = 1 then
                            Propostas := StringReplace(Propostas,'[%]LINHADECOR[%]',' style="font-weight: bold; color: #FF0000"',[])
                        else
                            Propostas := StringReplace(Propostas,'[%]LINHADECOR[%]','',[])
                    end;

                    Propostas := StringReplace(Propostas,'[%]PROPOSTA[%]',RODataSet.FieldByName('PROPOSTA').AsString,[]);
                    Propostas := StringReplace(Propostas,'[%]INSTALADOR[%]',RODataSet.FieldByName('INSTALADOR').AsString,[]);
                    Propostas := StringReplace(Propostas,'[%]VALOR[%]',IfThen(RODataSet.FieldByName('VALOR').AsString <> '',RODataSet.FieldByName('VALOR').AsString,'N/A'),[]);

                    RODataSet.Next;
                end;
            end;
            Application.ProcessMessages;
            ObrasOciosas := StringReplace(ObrasOciosas,'[%]PROPOSTAS[%]',Propostas,[]);
        end;
        FEmailAEnviar.Text := StringReplace(aPrincipalTemplate,'[%]OBRASOCIOSAS[%]',ObrasOciosas,[]);
        FEmailAEnviar.Text := StringReplace(FEmailAEnviar.Text,'[%]DATAHORAGERACAO[%]',FormatDateTime('dd/mm/yyyy "às" hh:nn:ss',Now),[]);

        if aUsuarioCriador = '' then
            FEmailAEnviar.Text := StringReplace(FEmailAEnviar.Text,'[%]USUARIOCRIADOR[%]','<span style="color: #FF0000">Não encontrado no sistema. O usuário foi excluído!</span>',[])
        else
            FEmailAEnviar.Text := StringReplace(FEmailAEnviar.Text,'[%]USUARIOCRIADOR[%]',aUsuarioCriador,[]);

        if aUsuarioModificador = '' then
            FEmailAEnviar.Text := StringReplace(FEmailAEnviar.Text,'[%]USUARIOMODIFICADOR[%]','<span style="color: #FF0000">Não encontrado no sistema. O usuário foi excluído!</span>',[])
        else
            FEmailAEnviar.Text := StringReplace(FEmailAEnviar.Text,'[%]USUARIOMODIFICADOR[%]',aUsuarioModificador,[])
    finally
        if Assigned(RODataSet) then
            RODataSet.Free;
    end;
end;

procedure EnviarEmailsPorRegiao(const aRegiao: ShortString);
var
    EmailsPara: ShortString;
begin
    { Obtem os e-mails que não estão associados a regiões, que não contém "|" }
    EmailsPara := ObterEmails(Configurations.EmailsParaObrasOciosas,aRegiao);

    { Caso não haja e-mail a enviar, não envia nada! }
    if EmailsPara = '' then
        Exit;

    { Configura e inicia o processo de envio de e-mails }
    EnviarEmails(EmailsPara,'','BDI Informa: Obras Ociosas');
end;

procedure EnviarEmailsPorProprietario(const aEmailCriador, aEmailModificador: ShortString);
var
    EmailsPara, EmailsCc: String;
begin
    EmailsPara := '';

    if Trim(aEmailCriador) <> '' then
        EmailsPara := Trim(aEmailCriador);

    if (Trim(aEmailModificador) <> '') and (Trim(aEmailModificador) <> Trim(aEmailCriador)) then
    begin
        if EmailsPara <> '' then
            EmailsPara := EmailsPara + ',' + Trim(aEmailModificador)
        else
            EmailsPara := Trim(aEmailModificador)
    end;

    { Obtem os e-mails que não estão associados a regiões, que não contém "|" }
    EmailsCc := ObterEmails(Configurations.EmailsParaObrasOciosas);

    { Caso não haja e-mail para enviar, envia apenas para os e-mails configurados }
    if EmailsPara = '' then
    begin
        EmailsPara := EmailsCc;
        EmailsCc := '';
    end;

    { Caso não haja e-mail a enviar, não envia nada! }
    if EmailsPara = '' then
        Exit;

    { Configura e inicia o processo de envio de e-mails }
    EnviarEmails(EmailsPara,EmailsCc,'BDI Informa: Obras Ociosas');
end;
{$ENDREGION}
const
    SQL_OBRAS_OCIOSAS =
    '   SELECT OBR.IN_OBRAS_ID'#13#10 +
    '        :USUARIOCRIADOR:, OBR.SM_USUARIOCRIADOR_ID'#13#10 +
    '        :USUARIOMODIFICADOR:, OBR.SM_USUARIOMODIFICADOR_ID'#13#10 +
    '        :REGIAO:, OBR.TI_REGIOES_ID'#13#10 +
    '     FROM OBRAS OBR'#13#10 +
    'LEFT JOIN PROPOSTAS PRO USING (IN_OBRAS_ID)'#13#10 +
    'LEFT JOIN ITENS ITE USING (IN_PROPOSTAS_ID)'#13#10 +
    'LEFT JOIN EQUIPAMENTOSDOSITENS EDI USING (IN_ITENS_ID)'#13#10 +
    '    WHERE NOT OBR.TI_SITUACOES_ID IN (SELECT * FROM VIW_FINISHED_SITUATIONS)'#13#10 +
    ' GROUP BY OBR.IN_OBRAS_ID'#13#10 +
    '   HAVING (SUM(NOW() > ADDDATE(OBR.DT_DATAEHORADAMODIFICACAO,:DIASDEOCIOSIDADE:))'#13#10 +
    '          +SUM(NOW() > ADDDATE(PRO.DT_DATAEHORADAMODIFICACAO,:DIASDEOCIOSIDADE:))'#13#10 +
    '          +SUM(NOW() > ADDDATE(ITE.DT_DATAEHORADAMODIFICACAO,:DIASDEOCIOSIDADE:))'#13#10 +
    '          +SUM(NOW() > ADDDATE(EDI.DT_DATAEHORADAMODIFICACAO,:DIASDEOCIOSIDADE:))) = (COUNT(*) * 4)'#13#10 +
    ' ORDER BY :ORDER BY:';
var
    RODataSet: TZReadOnlyQuery;
    CriadorID, ModificadorID: Word;
    {ListaDeObrasOciosas: TStringList;}
    RegiaoID: Byte;
    PrincipalTemplate, ObraTemplate, PropostaTemplate, ResponsaveisTemplate, SQL: String;
    EmailsAEnviar: Boolean;
begin
    {$IFDEF DEVELOPING}
    X := 0;
    {$ENDIF}
    Result := False;

    if Now <= FProximoEnvioParaObrasOciosas then
        Exit;

    FObrasAProcessar.Clear;{ListaDeObrasOciosas := nil;}
    RODataSet := nil;
    try
        FEnviandoEmail := eeObrasOciosas;

        { Carregando template para uma obra }
        ObraTemplate := LoadTextFile(Configurations.CurrentDir + '\EmailTemplates\OBRASOCIOSAS\obra.template.html');

        { Carregando template para uma proposta }
        PropostaTemplate := LoadTextFile(Configurations.CurrentDir + '\EmailTemplates\OBRASOCIOSAS\proposta.template.html');

        { Carregando template principal por proprietário }
        PrincipalTemplate := LoadTextFile(Configurations.CurrentDir + '\EmailTemplates\OBRASOCIOSAS\principal_proprietario.template.html');
        PrincipalTemplate := StringReplace(PrincipalTemplate,'[%]HTTPHOST[%]',LowerCase(LocalHostName) + IfThen(Configurations.HTTPPort <> 80,':' + IntToStr(Configurations.HTTPPort),''),[rfReplaceAll]);
        PrincipalTemplate := StringReplace(PrincipalTemplate,'[%]DIASDEOCIOSIDADE[%]',IntToStr(Configurations.DiasDeOciosidade),[]);
        PrincipalTemplate := StringReplace(PrincipalTemplate,'[%]INTERVALODECHECAGEMDEOCIOSAS[%]',IntToStr(Configurations.IntervaloDeChecagemDeOciosas),[]);

        { A partir deste ponto será configurada e executada uma consulta que
        retornará as obras ordenadas por responsáveis, em seguida e-mails serão
        enviados para os responsáveis e para a lista de e-mails que não tem
        especificidade com relação á região }
        {ListaDeObrasOciosas := TStringList.Create;}
        RODataSet := TZReadOnlyQuery.Create(nil);

        SQL := StringReplace(SQL_OBRAS_OCIOSAS,':USUARIOCRIADOR:',' ',[rfReplaceAll]);
        SQL := StringReplace(SQL,':USUARIOMODIFICADOR:',' ',[rfReplaceAll]);
        SQL := StringReplace(SQL,':REGIAO:','#',[rfReplaceAll]);
        SQL := StringReplace(SQL,':DIASDEOCIOSIDADE:',IntToStr(Configurations.DiasDeOciosidade),[rfReplaceAll]);
        SQL := StringReplace(SQL,':ORDER BY:','OBR.SM_USUARIOCRIADOR_ID, OBR.SM_USUARIOMODIFICADOR_ID',[rfReplaceAll]);

        ConfigureDataSet(ZConnection_BDO
                        ,RODataSet
                        ,SQL
                        ,False);

        { RODataSet conterá neste ponto uma lista com todas as obras ociosas ou
        zero, caso não haja nenhuma obra ociosa }
        if RODataSet.RecordCount > 0 then
        begin
            MyModule.ProgressBar_EmailsParaObrasOciosas.Position := 0;
            MyModule.ProgressBar_EmailsParaObrasOciosas.Max := EmailsAEnviarPorProprietario(RODataSet.SQL.Text);
            MyModule.ProgressBar_EmailsParaObrasOciosas.Show;
            MyModule.Label_EmailsParaObrasOciosasValor.Show;
            MyModule.Label_EmailsParaObrasOciosasProximoEnvio.Hide;

            CriadorID := RODataSet.FieldByName('SM_USUARIOCRIADOR_ID').AsInteger;
            ModificadorID := RODataSet.FieldByName('SM_USUARIOMODIFICADOR_ID').AsInteger;
            EmailsAEnviar := HaEmailsAEnviar(Configurations.EmailsParaObrasOciosas
                                            ,0
                                            ,CriadorID
                                            ,ModificadorID);


            while not RODataSet.Eof do
            begin
                { Caso os proprietários mudem, devemos gerar e enviar o e-mail
                final para todos os recipientes obtidos até então }
                if (RODataSet.FieldByName('SM_USUARIOCRIADOR_ID').AsInteger <> CriadorID)
                or (RODataSet.FieldByName('SM_USUARIOMODIFICADOR_ID').AsInteger <> ModificadorID) then
                begin
                    if EmailsAEnviar then
                    begin
                        GerarEmailPorProprietario(FObrasAProcessar{ListaDeObrasOciosas}
                                                 ,PrincipalTemplate
                                                 ,ObraTemplate
                                                 ,PropostaTemplate
                                                 ,ObterNomeCompletoDoUsuario(CriadorID)
                                                 ,ObterNomeCompletoDoUsuario(ModificadorID));

                        EnviarEmailsPorProprietario(ObterEmailDoUsuario(CriadorID)
                                                   ,ObterEmailDoUsuario(ModificadorID));
                    end;

                    CriadorID := RODataSet.FieldByName('SM_USUARIOCRIADOR_ID').AsInteger;
                    ModificadorID := RODataSet.FieldByName('SM_USUARIOMODIFICADOR_ID').AsInteger;
                    EmailsAEnviar := HaEmailsAEnviar(Configurations.EmailsParaObrasOciosas
                                                    ,0
                                                    ,CriadorID
                                                    ,ModificadorID);

                    {ListaDeObrasOciosas}FObrasAProcessar.Clear;
                end;

                { Adicionando a obra da vez na lista obras ociosas para os
                proprietários atuais }
                if EmailsAEnviar then
                    {ListaDeObrasOciosas}FObrasAProcessar.Add(RODataSet.FieldByName('IN_OBRAS_ID').AsString);

                RODataSet.Next;

                { Caso eu tenha chegado ao fim eu devo enviar o restante dos
                e-mails }
                if RODataSet.Eof and EmailsAEnviar then
                begin
                    GerarEmailPorProprietario(FObrasAProcessar{ListaDeObrasOciosas}
                                             ,PrincipalTemplate
                                             ,ObraTemplate
                                             ,PropostaTemplate
                                             ,ObterNomeCompletoDoUsuario(CriadorID)
                                             ,ObterNomeCompletoDoUsuario(ModificadorID));

                    EnviarEmailsPorProprietario(ObterEmailDoUsuario(CriadorID)
                                               ,ObterEmailDoUsuario(ModificadorID));
                end;

                Application.ProcessMessages;
            end;

            { ================================================================ } 
            { A partir deste ponto será configurada e executada uma consulta que
            retornará as obras ordenadas por regiões, em seguida e-mails serão
            enviados para a lista de e-mails referentes a cada uma das regiões }

            { Carregando template principal por região }
            PrincipalTemplate := LoadTextFile(Configurations.CurrentDir + '\EmailTemplates\OBRASOCIOSAS\principal_regiao.template.html');
            PrincipalTemplate := StringReplace(PrincipalTemplate,'[%]HTTPHOST[%]',LowerCase(LocalHostName) + IfThen(Configurations.HTTPPort <> 80,':' + IntToStr(Configurations.HTTPPort),''),[rfReplaceAll]);
            PrincipalTemplate := StringReplace(PrincipalTemplate,'[%]DIASDEOCIOSIDADE[%]',IntToStr(Configurations.DiasDeOciosidade),[]);
            PrincipalTemplate := StringReplace(PrincipalTemplate,'[%]INTERVALODECHECAGEMDEOCIOSAS[%]',IntToStr(Configurations.IntervaloDeChecagemDeOciosas),[]);

            ResponsaveisTemplate := LoadTextFile(Configurations.CurrentDir + '\EmailTemplates\responsaveis.template.html');

            {ListaDeObrasOciosas}FObrasAProcessar.Clear;
            RODataSet.Close;

            SQL := StringReplace(SQL_OBRAS_OCIOSAS,':USUARIOCRIADOR:','#',[rfReplaceAll]);
            SQL := StringReplace(SQL,':USUARIOMODIFICADOR:','#',[rfReplaceAll]);
            SQL := StringReplace(SQL,':REGIAO:',' ',[rfReplaceAll]);
            SQL := StringReplace(SQL,':DIASDEOCIOSIDADE:',IntToStr(Configurations.DiasDeOciosidade),[rfReplaceAll]);
            SQL := StringReplace(SQL,':ORDER BY:','OBR.TI_REGIOES_ID',[rfReplaceAll]);

            ConfigureDataSet(ZConnection_BDO
                            ,RODataSet
                            ,SQL
                            ,False);

            { Reconfigura a barra de progresso com o novo máximo }
            MyModule.ProgressBar_EmailsParaObrasOciosas.Max := MyModule.ProgressBar_EmailsParaObrasOciosas.Max + EmailsAEnviarPorRegiao(RODataSet.SQL.Text);

            RegiaoID := RODataSet.FieldByName('TI_REGIOES_ID').AsInteger;
            EmailsAEnviar := HaEmailsAEnviar(Configurations.EmailsParaObrasOciosas
                                            ,RegiaoID
                                            ,0
                                            ,0);

            while not RODataSet.Eof do
            begin
                { Caso as regiões mudem, devemos gerar e enviar o e-mail final
                para todos os recipientes obtidos até então }
                if RODataSet.FieldByName('TI_REGIOES_ID').AsInteger <> RegiaoID then
                begin
                    if EmailsAEnviar then
                    begin
                        GerarEmailPorRegiao(FObrasAProcessar{ListaDeObrasOciosas}
                                           ,PrincipalTemplate
                                           ,ObraTemplate
                                           ,PropostaTemplate
                                           ,ResponsaveisTemplate
                                           ,ObterRegiao(RegiaoID));

                        EnviarEmailsPorRegiao(ObterRegiao(RegiaoID));
                    end;

                    RegiaoID := RODataSet.FieldByName('TI_REGIOES_ID').AsInteger;
                    EmailsAEnviar := HaEmailsAEnviar(Configurations.EmailsParaObrasOciosas
                                                    ,RegiaoID
                                                    ,0
                                                    ,0);
                    {ListaDeObrasOciosas}FObrasAProcessar.Clear;
                end;
                { Adicionando a obra da vez na lista obras ociosas para os
                proprietários atuais }
                if EmailsAEnviar then
                    {ListaDeObrasOciosas}FObrasAProcessar.Add(RODataSet.FieldByName('IN_OBRAS_ID').AsString);

                RODataSet.Next;

                { Caso eu tenha chegado ao fim eu devo enviar o restante dos
                e-mails }
                if RODataSet.Eof and EmailsAEnviar then
                begin
                    GerarEmailPorRegiao(FObrasAProcessar{ListaDeObrasOciosas}
                                       ,PrincipalTemplate
                                       ,ObraTemplate
                                       ,PropostaTemplate
                                       ,ResponsaveisTemplate
                                       ,ObterRegiao(RegiaoID));

                    EnviarEmailsPorRegiao(ObterRegiao(RegiaoID));
                end;

                Application.ProcessMessages;
            end;
        end;
    finally
        Result := True;
        MyModule.Label_EmailsParaObrasOciosasProximoEnvio.Caption := 'Próxima checagem em: --/--/---- às --:--:--';

        MyModule.ProgressBar_EmailsParaObrasOciosas.Hide;
        MyModule.Label_EmailsParaObrasOciosasValor.Hide;
        MyModule.Label_EmailsParaObrasOciosasProximoEnvio.Show;
        
        FEnviandoEmail := eeNenhum;
        RODataSet.Free;
        {ListaDeObrasOciosas.Free;}
    end;
end;

procedure TBDIDataModule_Main.GerarEEnviarEmailsParaObrasPerdidas;
{$REGION 'PROCEDIMENTOS LOCAIS'}
function EmailsAEnviarPorProprietario(aSQLOriginal: String): Word;
var
    RODataSet: TZReadOnlyQuery;
begin
    RODataSet := nil;
    try
        ConfigureDataSet(ZConnection_BDO
                        ,RODataSet
                        ,'SELECT * FROM (' + aSQLOriginal + ') T GROUP BY 2,3');

        Result := RODataSet.RecordCount;
    finally
        RODataSet.Free;
    end;
end;

function EmailsAEnviarPorRegiao(aSQLOriginal: String): Word;
var
    RODataSet: TZReadOnlyQuery;
begin
    RODataSet := nil;
    try
        ConfigureDataSet(ZConnection_BDO
                        ,RODataSet
                        ,'SELECT * FROM (' + aSQLOriginal + ') T GROUP BY 2');

        Result := RODataSet.RecordCount;
    finally
        RODataSet.Free;
    end;
end;

procedure GerarEmailPorRegiao(const aObrasPerdidas: TStringList;
                              const aPrincipalTemplate
                                  , aObraTemplate
                                  , aPropostaTemplate
                                  , aResponsaveisTemplate: String;
                              const aRegiao: ShortString);
var
    RODataSet: TZReadOnlyQuery;
    ObrasPerdidas, Propostas, SQL: String;
    ObraId: ShortString;
begin
    ObrasPerdidas := '';
    RODataSet := nil;
    try
        for ObraId in aObrasPerdidas do
        begin
            if not Assigned(RODataSet) then
                RODataSet := TZReadOnlyQuery.Create(ZConnection_BDO);
                
            ObrasPerdidas := ObrasPerdidas + aObraTemplate;

            { Obtendo a proposta padrão da obra }
            SQL := StringReplace(SQL_PROPOSTAS,':IN_OBRAS_ID:',ObraId,[]);
            SQL := StringReplace(SQL,':PROPOSTAPADRAO:','#',[]);
            ConfigureDataSet(ZConnection_BDO
                            ,RODataSet
                            ,SQL
                            ,False);

            ObrasPerdidas := StringReplace(ObrasPerdidas,'[%]NOMEDAOBRA[%]',RODataSet.FieldByName('NOMEDAOBRA').AsString,[]);
            ObrasPerdidas := StringReplace(ObrasPerdidas,'[%]LOCALIDADE[%]',RODataSet.FieldByName('LOCALIDADE').AsString,[]);
            ObrasPerdidas := StringReplace(ObrasPerdidas,'[%]RESPONSAVEIS[%]',aResponsaveisTemplate,[]);
            ObrasPerdidas := StringReplace(ObrasPerdidas,'[%]PROPRIETARIOS[%]',ObterProprietarios(StrToInt(ObraId)),[]);
            ObrasPerdidas := StringReplace(ObrasPerdidas,'[%]JUSTIFICATIVA[%]',ObterJustificativa(StrToInt(ObraId)),[]);
            ObrasPerdidas := StringReplace(ObrasPerdidas,'[%]BORDERBOTTOMRESPONSAVEIS[%]','#FFFFFF',[]);

            Propostas := '<tr><td colspan="3" style="text-align: center">ESTA OBRA NÃO POSSUI PROPOSTAS</td><tr>';

            { Pode ser nulo, caso a obra não tenha propostas }
            if not RODataSet.FieldByName('PROPOSTA').IsNull then
            begin
                Propostas := '';
                { Correndo a lista de propostas da obra }
                while not RODataSet.Eof do
                begin
                    Propostas := Propostas + aPropostaTemplate;

                    if RODataSet.RecNo mod 2 = 0 then
                    begin
                        if RODataSet.FieldByName('PROPOSTAPADRAO').AsInteger = 1 then
                            Propostas := StringReplace(Propostas,'[%]LINHADECOR[%]',' style="background-color: #C0C0C0; font-weight: bold; color: #FF0000"',[])
                        else
                            Propostas := StringReplace(Propostas,'[%]LINHADECOR[%]',' style="background-color: #C0C0C0"',[]);
                    end
                    else
                    begin
                        if RODataSet.FieldByName('PROPOSTAPADRAO').AsInteger = 1 then
                            Propostas := StringReplace(Propostas,'[%]LINHADECOR[%]',' style="font-weight: bold; color: #FF0000"',[])
                        else
                            Propostas := StringReplace(Propostas,'[%]LINHADECOR[%]','',[])
                    end;

                    Propostas := StringReplace(Propostas,'[%]PROPOSTA[%]',RODataSet.FieldByName('PROPOSTA').AsString,[]);
                    Propostas := StringReplace(Propostas,'[%]INSTALADOR[%]',RODataSet.FieldByName('INSTALADOR').AsString,[]);
                    Propostas := StringReplace(Propostas,'[%]VALOR[%]',IfThen(RODataSet.FieldByName('VALOR').AsString <> '',RODataSet.FieldByName('VALOR').AsString,'N/A'),[]);

                    RODataSet.Next;
                end;
            end;
            Application.ProcessMessages;
            ObrasPerdidas := StringReplace(ObrasPerdidas,'[%]PROPOSTAS[%]',Propostas,[]);
        end;
        FEmailAEnviar.Text := StringReplace(aPrincipalTemplate,'[%]OBRASPERDIDAS[%]',ObrasPerdidas,[]);
        FEmailAEnviar.Text := StringReplace(FEmailAEnviar.Text,'[%]REGIAO[%]',aRegiao,[rfReplaceAll]);
        FEmailAEnviar.Text := StringReplace(FEmailAEnviar.Text,'[%]DATAHORAGERACAO[%]',FormatDateTime('dd/mm/yyyy "às" hh:nn:ss',Now),[]);
    finally
        if Assigned(RODataSet) then
            RODataSet.Free;
    end;
end;

procedure GerarEmailPorProprietario(const aObrasPerdidas: TStringList;
                                    const aPrincipalTemplate
                                        , aObraTemplate
                                        , aPropostaTemplate: String;
                                    const aUsuarioCriador
                                        , aUsuarioModificador: ShortString);
var
    RODataSet: TZReadOnlyQuery;
    ObrasPerdidas, Propostas, SQL: String;
    ObraId: ShortString;
begin
    ObrasPerdidas := '';
    RODataSet := nil;
    try
        for ObraId in aObrasPerdidas do
        begin
            if not Assigned(RODataSet) then
                RODataSet := TZReadOnlyQuery.Create(ZConnection_BDO);
                
            ObrasPerdidas := ObrasPerdidas + aObraTemplate;

            { Obtendo a proposta padrão da obra }
            SQL := StringReplace(SQL_PROPOSTAS,':IN_OBRAS_ID:',ObraId,[]);
            SQL := StringReplace(SQL,':PROPOSTAPADRAO:','#',[]);
            ConfigureDataSet(ZConnection_BDO
                            ,RODataSet
                            ,SQL
                            ,False);

            ObrasPerdidas := StringReplace(ObrasPerdidas,'[%]NOMEDAOBRA[%]',RODataSet.FieldByName('NOMEDAOBRA').AsString,[]);
            ObrasPerdidas := StringReplace(ObrasPerdidas,'[%]LOCALIDADE[%]',RODataSet.FieldByName('LOCALIDADE').AsString,[]);
            ObrasPerdidas := StringReplace(ObrasPerdidas,'[%]RESPONSAVEIS[%]','',[]);
            ObrasPerdidas := StringReplace(ObrasPerdidas,'[%]JUSTIFICATIVA[%]',ObterJustificativa(StrToInt(ObraId)),[]);

            Propostas := '<tr><td colspan="3" style="text-align: center">ESTA OBRA NÃO POSSUI PROPOSTAS</td><tr>';

            { Pode ser nulo, caso a obra não tenha propostas }
            if not RODataSet.FieldByName('PROPOSTA').IsNull then
            begin
                Propostas := '';
                { Correndo a lista de propostas da obra }
                while not RODataSet.Eof do
                begin
                    Propostas := Propostas + aPropostaTemplate;

                    if RODataSet.RecNo mod 2 = 0 then
                    begin
                        if RODataSet.FieldByName('PROPOSTAPADRAO').AsInteger = 1 then
                            Propostas := StringReplace(Propostas,'[%]LINHADECOR[%]',' style="background-color: #C0C0C0; font-weight: bold; color: #FF0000"',[])
                        else
                            Propostas := StringReplace(Propostas,'[%]LINHADECOR[%]',' style="background-color: #C0C0C0"',[]);
                    end
                    else
                    begin
                        if RODataSet.FieldByName('PROPOSTAPADRAO').AsInteger = 1 then
                            Propostas := StringReplace(Propostas,'[%]LINHADECOR[%]',' style="font-weight: bold; color: #FF0000"',[])
                        else
                            Propostas := StringReplace(Propostas,'[%]LINHADECOR[%]','',[])
                    end;

                    Propostas := StringReplace(Propostas,'[%]PROPOSTA[%]',RODataSet.FieldByName('PROPOSTA').AsString,[]);
                    Propostas := StringReplace(Propostas,'[%]INSTALADOR[%]',RODataSet.FieldByName('INSTALADOR').AsString,[]);
                    Propostas := StringReplace(Propostas,'[%]VALOR[%]',IfThen(RODataSet.FieldByName('VALOR').AsString <> '',RODataSet.FieldByName('VALOR').AsString,'N/A'),[]);

                    RODataSet.Next;
                end;
            end;
            Application.ProcessMessages;
            ObrasPerdidas := StringReplace(ObrasPerdidas,'[%]PROPOSTAS[%]',Propostas,[]);
        end;
        FEmailAEnviar.Text := StringReplace(aPrincipalTemplate,'[%]OBRASPERDIDAS[%]',ObrasPerdidas,[]);
        FEmailAEnviar.Text := StringReplace(FEmailAEnviar.Text,'[%]DATAHORAGERACAO[%]',FormatDateTime('dd/mm/yyyy "às" hh:nn:ss',Now),[]);

        if aUsuarioCriador = '' then
            FEmailAEnviar.Text := StringReplace(FEmailAEnviar.Text,'[%]USUARIOCRIADOR[%]','<span style="color: #FF0000">Não encontrado no sistema. O usuário foi excluído!</span>',[])
        else
            FEmailAEnviar.Text := StringReplace(FEmailAEnviar.Text,'[%]USUARIOCRIADOR[%]',aUsuarioCriador,[]);

        if aUsuarioModificador = '' then
            FEmailAEnviar.Text := StringReplace(FEmailAEnviar.Text,'[%]USUARIOMODIFICADOR[%]','<span style="color: #FF0000">Não encontrado no sistema. O usuário foi excluído!</span>',[])
        else
            FEmailAEnviar.Text := StringReplace(FEmailAEnviar.Text,'[%]USUARIOMODIFICADOR[%]',aUsuarioModificador,[])
    finally
        if Assigned(RODataSet) then
            RODataSet.Free;
    end;
end;

procedure EnviarEmailsPorRegiao(const aRegiao: ShortString);
var
    EmailsPara: ShortString;
begin
    { Obtem os e-mails que estão associados a regiões }
    EmailsPara := ObterEmails(Configurations.EmailsParaObrasPerdidas,aRegiao);

    { Caso não haja e-mail a enviar, não envia nada! }
    if EmailsPara = '' then
        Exit;

    { Configura e inicia o processo de envio de e-mails }
    EnviarEmails(EmailsPara,'','BDI Informa: Obras Perdidas');
end;

procedure EnviarEmailsPorProprietario(const aEmailCriador, aEmailModificador: ShortString);
var
    EmailsPara, EmailsCc: String;
begin
    EmailsPara := '';

    if Trim(aEmailCriador) <> '' then
        EmailsPara := Trim(aEmailCriador);

    if (Trim(aEmailModificador) <> '') and (Trim(aEmailModificador) <> Trim(aEmailCriador)) then
    begin
        if EmailsPara <> '' then
            EmailsPara := EmailsPara + ',' + Trim(aEmailModificador)
        else
            EmailsPara := Trim(aEmailModificador)
    end;

    { Obtem os e-mails que não estão associados a regiões, que não contém "|" }
    EmailsCc := ObterEmails(Configurations.EmailsParaObrasPerdidas);

    { Caso não haja e-mail para enviar, envia apenas para os e-mails configurados }
    if EmailsPara = '' then
    begin
        EmailsPara := EmailsCc;
        EmailsCc := '';
    end;

    { Caso não haja e-mail a enviar, não envia nada! }
    if EmailsPara = '' then
        Exit;

    { Configura e inicia o processo de envio de e-mails }
    EnviarEmails(EmailsPara,EmailsCc,'BDI Informa: Obras Perdidas');
end;
{$ENDREGION}
var
    RODataSet: TZReadOnlyQuery;
    CriadorID, ModificadorID: Word;
    {ListaDeObrasGanhas: TStringList;}
    RegiaoID: Byte;
    PrincipalTemplate, ObraTemplate, PropostaTemplate, ResponsaveisTemplate, SQL: String;
    EmailsAEnviar: Boolean;
begin
    {$IFDEF DEVELOPING}
    X := 0;
    {$ENDIF}

    FObrasAProcessar.Clear;
    RODataSet := nil;
    
    try
        FEnviandoEmail := eeObrasPerdidas;
        MyModule.ProgressBar_EmailsParaObrasPerdidas.Position := 0;
        MyModule.ProgressBar_EmailsParaObrasPerdidas.Show;
        MyModule.Label_EmailsParaObrasPerdidasValor.Caption := '? / ?';;
        MyModule.Label_EmailsParaObrasPerdidasValor.Show;
        MyModule.Label_EmailsParaObrasPerdidasProximoEnvio.Hide;

        { Carregando template para uma obra }
        ObraTemplate := LoadTextFile(Configurations.CurrentDir + '\EmailTemplates\OBRASPERDIDAS\obra.template.html');

        { Carregando template para uma proposta }
        PropostaTemplate := LoadTextFile(Configurations.CurrentDir + '\EmailTemplates\OBRASPERDIDAS\proposta.template.html');

        { Carregando template principal por proprietário }
        PrincipalTemplate := LoadTextFile(Configurations.CurrentDir + '\EmailTemplates\OBRASPERDIDAS\principal_proprietario.template.html');
        PrincipalTemplate := StringReplace(PrincipalTemplate,'[%]HTTPHOST[%]',LowerCase(LocalHostName) + IfThen(Configurations.HTTPPort <> 80,':' + IntToStr(Configurations.HTTPPort),''),[rfReplaceAll]);
        PrincipalTemplate := StringReplace(PrincipalTemplate,'[%]INTERVALODECHECAGEMGERAL[%]',IntToStr(Configurations.IntervaloDeChecagemGeral),[rfReplaceAll]);
        PrincipalTemplate := StringReplace(PrincipalTemplate,'[%]RESPONSAVEIS[%]','',[]);


        { A partir deste ponto será configurada e executada uma consulta que
        retornará as obras ordenadas por responsáveis, em seguida e-mails serão
        enviados para os responsáveis e para a lista de e-mails que não tem
        especificidade com relação á região }
        {ListaDeObrasGanhas := TStringList.Create;}
        RODataSet := TZReadOnlyQuery.Create(nil);

        { Preenchendo a tabela temporária com obras já processadas }
        ObterObrasProcessadas('PERDIDA');

        SQL := StringReplace(SQL_OBRAS,':USUARIOCRIADOR:',' ',[rfReplaceAll]);
        SQL := StringReplace(SQL,':USUARIOMODIFICADOR:',' ',[rfReplaceAll]);
        SQL := StringReplace(SQL,':REGIAO:','#',[rfReplaceAll]);
//        SQL := StringReplace(SQL,':OBRASPROCESSADAS:',ObrasProcessadas,[rfReplaceAll]);
        SQL := StringReplace(SQL,':TI_SITUACOES_ID:',ObterIdSituacao('PERDIDA'),[]);
        SQL := StringReplace(SQL,':ORDER BY:','OBR.SM_USUARIOCRIADOR_ID, OBR.SM_USUARIOMODIFICADOR_ID',[rfReplaceAll]);

        ConfigureDataSet(ZConnection_BDO
                        ,RODataSet
                        ,SQL
                        ,False);

        { RODataSet conterá neste ponto uma lista com todas as obras ganhas não
        processadas ou zero, caso não haja nenhuma obra ganha não processada }
        if RODataSet.RecordCount > 0 then
        begin
            MyModule.ProgressBar_EmailsParaObrasPerdidas.Max := EmailsAEnviarPorProprietario(RODataSet.SQL.Text);

            CriadorID := RODataSet.FieldByName('SM_USUARIOCRIADOR_ID').AsInteger;
            ModificadorID := RODataSet.FieldByName('SM_USUARIOMODIFICADOR_ID').AsInteger;
            EmailsAEnviar := HaEmailsAEnviar(Configurations.EmailsParaObrasPerdidas
                                            ,0
                                            ,CriadorID
                                            ,ModificadorID);

            while not RODataSet.Eof do
            begin
                { Caso os proprietários mudem, devemos gerar e enviar o e-mail
                final para todos os recipientes obtidos até então }
                if (RODataSet.FieldByName('SM_USUARIOCRIADOR_ID').AsInteger <> CriadorID)
                or (RODataSet.FieldByName('SM_USUARIOMODIFICADOR_ID').AsInteger <> ModificadorID) then
                begin
                    if EmailsAEnviar then
                    begin
                        GerarEmailPorProprietario(FObrasAProcessar
                                                 ,PrincipalTemplate
                                                 ,ObraTemplate
                                                 ,PropostaTemplate
                                                 ,ObterNomeCompletoDoUsuario(CriadorID)
                                                 ,ObterNomeCompletoDoUsuario(ModificadorID));

                        EnviarEmailsPorProprietario(ObterEmailDoUsuario(CriadorID)
                                                   ,ObterEmailDoUsuario(ModificadorID));
                    end;

                    CriadorID := RODataSet.FieldByName('SM_USUARIOCRIADOR_ID').AsInteger;
                    ModificadorID := RODataSet.FieldByName('SM_USUARIOMODIFICADOR_ID').AsInteger;
                    EmailsAEnviar := HaEmailsAEnviar(Configurations.EmailsParaObrasPerdidas
                                                    ,0
                                                    ,CriadorID
                                                    ,ModificadorID);

                    FObrasAProcessar.Clear;
                end;

                { Adicionando a obra da vez na lista obras PERDIDAS para os
                proprietários atuais }
                if EmailsAEnviar then
                    FObrasAProcessar.Add(RODataSet.FieldByName('IN_OBRAS_ID').AsString);

                RODataSet.Next;

                { Caso eu tenha chegado ao fim eu devo enviar o restante dos
                e-mails }
                if RODataSet.Eof and EmailsAEnviar then
                begin
                    GerarEmailPorProprietario(FObrasAProcessar
                                             ,PrincipalTemplate
                                             ,ObraTemplate
                                             ,PropostaTemplate
                                             ,ObterNomeCompletoDoUsuario(CriadorID)
                                             ,ObterNomeCompletoDoUsuario(ModificadorID));

                    EnviarEmailsPorProprietario(ObterEmailDoUsuario(CriadorID)
                                               ,ObterEmailDoUsuario(ModificadorID));
                end;

                Application.ProcessMessages;
            end;

            { ================================================================ }
            { A partir deste ponto será configurada e executada uma consulta que
            retornará as obras ordenadas por regiões, em seguida e-mails serão
            enviados para a lista de e-mails referentes a cada uma das regiões }

            { Carregando template principal por região }
            PrincipalTemplate := LoadTextFile(Configurations.CurrentDir + '\EmailTemplates\OBRASPERDIDAS\principal_regiao.template.html');
            PrincipalTemplate := StringReplace(PrincipalTemplate,'[%]HTTPHOST[%]',LowerCase(LocalHostName) + IfThen(Configurations.HTTPPort <> 80,':' + IntToStr(Configurations.HTTPPort),''),[rfReplaceAll]);
            PrincipalTemplate := StringReplace(PrincipalTemplate,'[%]INTERVALODECHECAGEMGERAL[%]',IntToStr(Configurations.IntervaloDeChecagemGeral),[rfReplaceAll]);

            ResponsaveisTemplate := LoadTextFile(Configurations.CurrentDir + '\EmailTemplates\responsaveis.template.html');

            FObrasAProcessar.Clear;
            RODataSet.Close;

            SQL := StringReplace(SQL_OBRAS,':USUARIOCRIADOR:','#',[rfReplaceAll]);
            SQL := StringReplace(SQL,':USUARIOMODIFICADOR:','#',[rfReplaceAll]);
            SQL := StringReplace(SQL,':REGIAO:',' ',[rfReplaceAll]);
//            SQL := StringReplace(SQL,':OBRASPROCESSADAS:',ObrasProcessadas,[rfReplaceAll]);
            SQL := StringReplace(SQL,':TI_SITUACOES_ID:',ObterIdSituacao('PERDIDA'),[]);
            SQL := StringReplace(SQL,':ORDER BY:','OBR.TI_REGIOES_ID',[rfReplaceAll]);

            ConfigureDataSet(ZConnection_BDO
                            ,RODataSet
                            ,SQL
                            ,False);

            { Reconfigura a barra de progresso com o novo máximo }
            MyModule.ProgressBar_EmailsParaObrasPerdidas.Max := MyModule.ProgressBar_EmailsParaObrasPerdidas.Max + EmailsAEnviarPorRegiao(RODataSet.SQL.Text);

            RegiaoID := RODataSet.FieldByName('TI_REGIOES_ID').AsInteger;
            EmailsAEnviar := HaEmailsAEnviar(Configurations.EmailsParaObrasPerdidas
                                            ,RegiaoID
                                            ,0
                                            ,0);

            while not RODataSet.Eof do
            begin
                { Caso as regiões mudem, devemos gerar e enviar o e-mail final
                para todos os recipientes obtidos até então }
                if RODataSet.FieldByName('TI_REGIOES_ID').AsInteger <> RegiaoID then
                begin
                    if EmailsAEnviar then
                    begin
                        GerarEmailPorRegiao(FObrasAProcessar
                                           ,PrincipalTemplate
                                           ,ObraTemplate
                                           ,PropostaTemplate
                                           ,ResponsaveisTemplate
                                           ,ObterRegiao(RegiaoID));

                        EnviarEmailsPorRegiao(ObterRegiao(RegiaoID));
                    end;

                    RegiaoID := RODataSet.FieldByName('TI_REGIOES_ID').AsInteger;
                    EmailsAEnviar := HaEmailsAEnviar(Configurations.EmailsParaObrasPerdidas
                                                    ,RegiaoID
                                                    ,0
                                                    ,0);

                    FObrasAProcessar.Clear;
                end;

                { Adicionando a obra da vez na lista obras ociosas para os
                proprietários atuais }
                if EmailsAEnviar then
                    FObrasAProcessar.Add(RODataSet.FieldByName('IN_OBRAS_ID').AsString);

                RODataSet.Next;

                { Caso eu tenha chegado ao fim eu devo enviar o restante dos
                e-mails }
                if RODataSet.Eof and EmailsAEnviar then
                begin
                    GerarEmailPorRegiao(FObrasAProcessar{ListaDeObrasGanhas}
                                       ,PrincipalTemplate
                                       ,ObraTemplate
                                       ,PropostaTemplate
                                       ,ResponsaveisTemplate
                                       ,ObterRegiao(RegiaoID));

                    EnviarEmailsPorRegiao(ObterRegiao(RegiaoID));
                end;

                Application.ProcessMessages;
            end;
        end;
    finally
        MyModule.Label_EmailsParaObrasPerdidasProximoEnvio.Caption := 'Próxima checagem em: --/--/---- às --:--:--';
        MyModule.ProgressBar_EmailsParaObrasPerdidas.Hide;
        MyModule.Label_EmailsParaObrasPerdidasValor.Hide;
        MyModule.Label_EmailsParaObrasPerdidasProximoEnvio.Show;
        FEnviandoEmail := eeNenhum;
        RODataSet.Free;
    end;
end;

procedure TBDIDataModule_Main.GuardarConfiguracoes;
var
    AlterouConfiguracao: Boolean;
begin
    AlterouConfiguracao := False;
    if not FCarragandoConfiguracoes then
    begin
        AlterouConfiguracao := (Configurations.DBProtocol <> MyModule.ComboBoxProtocolo.Items[MyModule.ComboBoxProtocolo.ItemIndex])
                            or (Configurations.DBHostAddr <> MyModule.EditEnderecoDoHost.Text)
                            or (Configurations.DBPortNumb <> StrToInt(MyModule.EditPorta.Text))
                            or (Configurations.DBDataBase <> MyModule.EditBancoDeDados.Text)
                            or (Configurations.DBUserName <> MyModule.EditNomeDeUsuario.Text)
                            or (Configurations.DBPassword <> MyModule.EditSenha.Text)
                            or (Configurations.DBIsoLevel <> Integer(MyModule.ComboBoxIsolationLevel.Items.Objects[MyModule.ComboBoxIsolationLevel.ItemIndex]))

                            or (Configurations.SMTPPrio <> MyModule.ComboBox_Priority.ItemIndex)
                            or (Configurations.SMTPCoTy <> MyModule.ComboBox_ContentType.ItemIndex)
                            or (Configurations.SMTPSeMo <> MyModule.ComboBox_SendMode.ItemIndex)
                            or (Configurations.SMTPShMo <> MyModule.ComboBox_ShareMode.ItemIndex)
                            or (Configurations.SMTPConf <> MyModule.CheckBox_Confirm.Checked)
                            or (Configurations.SMTPWrMT <> MyModule.CheckBox_WrapMessageText.Checked)
                            or (Configurations.SMTPUsNa <> MyModule.LabeledEdit_SMTPLogin.Text)
                            or (Configurations.SMTPUsPa <> MyModule.LabeledEdit_SMTPSenha.Text)
                            or (Configurations.SMTPHost <> MyModule.LabeledEdit_SMTPHost.Text)
                            or (Configurations.SMTPFrom <> MyModule.LabeledEdit_SMTPFrom.Text)
                            or (Configurations.SMTPSign <> MyModule.LabeledEdit_SMTPAssinatura.Text)
                            or (Configurations.SMTPAuth <> MyModule.ComboBox_SMTPAutenticacao.ItemIndex)
                            or (Configurations.SMTPA8bC <> MyModule.CheckBox_SMTPAllow8bitChars.Checked)
                            or (Configurations.SMTPChSe <> MyModule.LabeledEdit_SMTPCharSet.Text)
                            or (Configurations.SMTPDeEn <> MyModule.ComboBox_SMTPDefaultEncoding.ItemIndex)

                            or (Configurations.IntervaloDeChecagemGeral <> Word(MyModule.UpDown_IntervaloDeChecagemGeral.Position))

                            or (Configurations.EmailsParaObrasOciosas.Text <> MyModule.Memo_ObrasOciosas.Text)
                            or (Configurations.IntervaloDeChecagemDeOciosas <> Word(MyModule.UpDown_ObrasOciosasIntervalo.Position))
                            or (Configurations.DiasDeOciosidade <> Word(MyModule.UpDown_ObrasOciosasDias.Position))

                            or (Configurations.EmailsParaObrasGanhas.Text <> MyModule.Memo_ObrasGanhas.Text)

                            or (Configurations.EmailsParaObrasPerdidas.Text <> MyModule.Memo_ObrasPerdidas.Text)

                            or (Configurations.EmailsParaObrasLimitrofes.Text <> MyModule.Memo_ObrasLimitrofes.Text)
                            or (Configurations.IntervaloDeChecagemDeLimitrofes <> Word(MyModule.UpDown_ObrasLimitrofesIntervalo.Position))
                            or (Configurations.DiasParaAviso <> Word(MyModule.UpDown_ObrasLimitrofesDias.Position))

                            or (Configurations.HTTPPort <> StrToInt(MyModule.LabeledEdit_PortaHTTP.Text));

        Configurations.DBProtocol := MyModule.ComboBoxProtocolo.Items[MyModule.ComboBoxProtocolo.ItemIndex];
        Configurations.DBHostAddr := MyModule.EditEnderecoDoHost.Text;
        Configurations.DBPortNumb := StrToInt(MyModule.EditPorta.Text);
        Configurations.DBDataBase := MyModule.EditBancoDeDados.Text;
        Configurations.DBUserName := MyModule.EditNomeDeUsuario.Text;
        Configurations.DBPassword := MyModule.EditSenha.Text;
        Configurations.DBIsoLevel := Integer(MyModule.ComboBoxIsolationLevel.Items.Objects[MyModule.ComboBoxIsolationLevel.ItemIndex]);


        Configurations.SMTPPrio := MyModule.ComboBox_Priority.ItemIndex;
        Configurations.SMTPCoTy := MyModule.ComboBox_ContentType.ItemIndex;
        Configurations.SMTPSeMo := MyModule.ComboBox_SendMode.ItemIndex;
        Configurations.SMTPShMo := MyModule.ComboBox_ShareMode.ItemIndex;
        Configurations.SMTPConf := MyModule.CheckBox_Confirm.Checked;
        Configurations.SMTPWrMT := MyModule.CheckBox_WrapMessageText.Checked;
        Configurations.SMTPUsNa := MyModule.LabeledEdit_SMTPLogin.Text;
        Configurations.SMTPUsPa := MyModule.LabeledEdit_SMTPSenha.Text;
        Configurations.SMTPHost := MyModule.LabeledEdit_SMTPHost.Text;
        Configurations.SMTPFrom := MyModule.LabeledEdit_SMTPFrom.Text;
        Configurations.SMTPSign := MyModule.LabeledEdit_SMTPAssinatura.Text;
        Configurations.SMTPAuth := MyModule.ComboBox_SMTPAutenticacao.ItemIndex;
        Configurations.SMTPA8bC := MyModule.CheckBox_SMTPAllow8bitChars.Checked;
        Configurations.SMTPChSe := MyModule.LabeledEdit_SMTPCharSet.Text;
        Configurations.SMTPDeEn := MyModule.ComboBox_SMTPDefaultEncoding.ItemIndex;

        Configurations.HTTPPort := StrToInt(MyModule.LabeledEdit_PortaHTTP.Text);

        Configurations.IntervaloDeChecagemGeral := MyModule.UpDown_IntervaloDeChecagemGeral.Position;

        Configurations.EmailsParaObrasOciosas.Text := MyModule.Memo_ObrasOciosas.Text;
        Configurations.IntervaloDeChecagemDeOciosas := MyModule.UpDown_ObrasOciosasIntervalo.Position;
        Configurations.DiasDeOciosidade := MyModule.UpDown_ObrasOciosasDias.Position;

        Configurations.EmailsParaObrasGanhas.Text := MyModule.Memo_ObrasGanhas.Text;

        Configurations.EmailsParaObrasPerdidas.Text := MyModule.Memo_ObrasPerdidas.Text;

        Configurations.EmailsParaObrasLimitrofes.Text := MyModule.Memo_ObrasLimitrofes.Text;
        Configurations.IntervaloDeChecagemDeLimitrofes := MyModule.UpDown_ObrasLimitrofesIntervalo.Position;
        Configurations.DiasParaAviso := MyModule.UpDown_ObrasLimitrofesDias.Position; 
    end;
    MyModule.BitBtn_SalvarConfiguracoes.Enabled := AlterouConfiguracao;
end;

procedure TBDIDataModule_Main.AplicarConfiguracoesSMTP;
begin
    { Reinicializa as variáveis de envio de e-mails }
    FProximoEnvioParaObrasOciosas := 0;
    FProximoEnvioParaObrasLimitrofes := 0;

    {$IFDEF DEVELOPING}
    Timer_EmailsAutomaticos.Interval := Configurations.IntervaloDeChecagemGeral;
    {$ELSE}
    Timer_EmailsAutomaticos.Interval := Configurations.IntervaloDeChecagemGeral * 1000 * 60; { MINUTOS }
    {$ENDIF}

    if SmtpCli_BDI.Connected then
    begin
        SmtpCli_BDI.Abort;
        SmtpCli_BDI.Quit;
    end;

    with SmtpCli_BDI do
    begin
        HdrPriority := TSMTPPriority(Configurations.SMTPPrio);
        ContentType := TSMTPContentType(Configurations.SMTPCoTy);
        SendMode := TSMTPSendMode(Configurations.SMTPSeMo);
        ShareMode := TSMTPShareMode(Configurations.SMTPShMo);
        ConfirmReceipt := Configurations.SMTPConf;
        WrapMessageText := Configurations.SMTPWrMT;
        Username := Configurations.SMTPUsNa;
        Password := Configurations.SMTPUsPa;
        Host := Configurations.SMTPHost;
        Port := 'smtp';
        HdrFrom := Configurations.SMTPFrom;
        FromName := Configurations.SMTPFrom; // qual a diferença?
        SignOn := Configurations.SMTPSign;
        AuthType := TSMTPAuthType(Configurations.SMTPAuth);
        Allow8bitChars := Configurations.SMTPA8bC;
        CharSet := Configurations.SMTPChSe;
        DefaultEncoding := TSMTPDefaultEncoding(Configurations.SMTPDeEn);
    end;
end;

procedure TBDIDataModule_Main.AtivarDesativarEnvioSMTP;
begin
    if MyModule.Action_SMTPAtivarDesativar.Checked then
    begin
        MyModule.Action_SMTPAtivarDesativar.Checked := False;
        MyModule.Action_SMTPAtivarDesativar.Caption := 'Ativar serviço de envio de e-mails via SMTP';
    end
    else
    begin
        MyModule.Action_SMTPAtivarDesativar.Checked := True;
        MyModule.Action_SMTPAtivarDesativar.Caption := 'Desativar serviço de envio de e-mails via SMTP';
        AplicarConfiguracoesSMTP;
    end;

    MyModule.LabeledEdit_IntervaloDeChecagemGeral.Enabled := not MyModule.Action_SMTPAtivarDesativar.Checked;
    MyModule.ComboBox_Priority.Enabled := MyModule.LabeledEdit_IntervaloDeChecagemGeral.Enabled;
    MyModule.ComboBox_ContentType.Enabled := MyModule.LabeledEdit_IntervaloDeChecagemGeral.Enabled;
    MyModule.ComboBox_SendMode.Enabled := MyModule.LabeledEdit_IntervaloDeChecagemGeral.Enabled;
    MyModule.ComboBox_ShareMode.Enabled := MyModule.LabeledEdit_IntervaloDeChecagemGeral.Enabled;
    MyModule.LabeledEdit_SMTPCharSet.Enabled := MyModule.LabeledEdit_IntervaloDeChecagemGeral.Enabled;
    MyModule.LabeledEdit_SMTPAssinatura.Enabled := MyModule.LabeledEdit_IntervaloDeChecagemGeral.Enabled;
    MyModule.LabeledEdit_SMTPFrom.Enabled := MyModule.LabeledEdit_IntervaloDeChecagemGeral.Enabled;
    MyModule.ComboBox_SMTPAutenticacao.Enabled := MyModule.LabeledEdit_IntervaloDeChecagemGeral.Enabled;
    MyModule.ComboBox_SMTPDefaultEncoding.Enabled := MyModule.LabeledEdit_IntervaloDeChecagemGeral.Enabled;
    MyModule.LabeledEdit_SMTPHost.Enabled := MyModule.LabeledEdit_IntervaloDeChecagemGeral.Enabled;
    MyModule.LabeledEdit_SMTPLogin.Enabled := MyModule.LabeledEdit_IntervaloDeChecagemGeral.Enabled;
    MyModule.LabeledEdit_SMTPSenha.Enabled := MyModule.LabeledEdit_IntervaloDeChecagemGeral.Enabled;
    MyModule.CheckBox_Confirm.Enabled := MyModule.LabeledEdit_IntervaloDeChecagemGeral.Enabled;
    MyModule.CheckBox_WrapMessageText.Enabled := MyModule.LabeledEdit_IntervaloDeChecagemGeral.Enabled;
    MyModule.CheckBox_SMTPAllow8bitChars.Enabled := MyModule.LabeledEdit_IntervaloDeChecagemGeral.Enabled;

    MyModule.Panel_EmailsAutomaticos.Visible := not MyModule.Action_SMTPAtivarDesativar.Checked;

    { Se estivermos ativando, executa imediatamente a primeira geração, que
    internamente já liga o timer, fazendo com que tudo aconteça novamente em
    intervalos predefinidos do timer. Se estivermos desativando, simplesmente
    desabilita o timer }
    if MyModule.Action_SMTPAtivarDesativar.Checked then
        Timer_EmailsAutomaticosTimer(MyModule.Action_SMTPAtivarDesativar)
    else
        Timer_EmailsAutomaticos.Enabled := False;
end;

procedure TBDIDataModule_Main.AtivarDesativarServidorHTTP;
var
    Erro: String;
begin
    if not MyModule.Action_HTTPAtivarDesativar.Checked then
    begin
        HttpServer_BDI.DocDir := Configurations.CurrentDir + '\wwwroot';
        HttpServer_BDI.TemplateDir := Configurations.CurrentDir + '\wwwroot\responsetemplates';
        HttpServer_BDI.Port := IntToStr(Configurations.HTTPPort);
        HttpServer_BDI.ClientClass := TConnectedClient;

        try
            HttpServer_BDI.Start;
        except
            on E: Exception do
            begin
                Erro := '! Não foi possível iniciar o servidor\n';

                if HttpServer_BDI.WSocketServer.LastError = WSAEADDRINUSE then
                    Erro := Erro + 'A porta ' + HttpServer_BDI.Port + ' já está sendo usada por\noutra aplicação'
                else
                    Erro := Erro + E.ClassName + ': ' + E.Message;

                HTTPShowOnLog(Erro,MyModule.RichEdit_HTTPLog);
            end;
        end;
    end
    else
        HttpServer_BDI.Stop;
end;

procedure TBDIDataModule_Main.DataModuleCreate(Sender: TObject);
begin
    { As configurações são feitas no beforeconnect }
    ZConnection_BDI.Connect;
    ZConnection_BDO.Connect;

    FCountRequests := 0;

    if not DirectoryExists(Configurations.CurrentDir + '\wwwroot') then
        CreateDir(Configurations.CurrentDir + '\wwwroot');

    if not DirectoryExists(Configurations.CurrentDir + '\wwwroot\responsetemplates') then
        CreateDir(Configurations.CurrentDir + '\wwwroot\responsetemplates');

    FEmailAEnviar := TStringList.Create;
    FObrasAProcessar := TStringList.Create;

    inherited;
end;

procedure TBDIDataModule_Main.DataModuleDestroy(Sender: TObject);
begin
    inherited;
    FObrasAProcessar.Free;
    FEmailAEnviar.Free;
end;

procedure TBDIDataModule_Main.DeHeadDocument(Sender, Client: TObject; var Flags: THttpGetFlag);
var
    ConnectedClient: TConnectedClient;
begin
    inherited;
    { Não consegui ativar este evento durante o uso normal da aplicação }
    ConnectedClient := TConnectedClient(Client);
    Inc(FCountRequests);
    HTTPShowOnLog('§ ' + ConnectedClient.GetPeerAddr + IntToStr(FCountRequests) + ': ' + ConnectedClient.Version + ' HEAD ' + ConnectedClient.Path,MyModule.RichEdit_HTTPLog);
end;

procedure TBDIDataModule_Main.MinimizarNoTray;
begin
    TrayIcon_BDI.Visible := True;
    TrayIcon_BDI.BalloonHint := 'Banco De Informações';
    TrayIcon_BDI.BalloonTitle := 'Banco De Informações';
    TrayIcon_BDI.BalloonTimeout := 3;
    TrayIcon_BDI.BalloonFlags := bfInfo;
    TrayIcon_BDI.ShowBalloonHint;
    Application.MainForm.Hide;
end;

procedure TBDIDataModule_Main.RestaurarDoTray;
begin
    TrayIcon_BDI.Visible := False;
    Application.MainForm.Show;
end;

function TBDIDataModule_Main.MyModule: TBDIForm_Main;
begin
    Result := TBDIForm_Main(Owner);
end;

procedure TBDIDataModule_Main.Timer_EmailsAutomaticosTimer(Sender: TObject);
var
    EnviouEmailParaOciosas, EnviouEmailParaLimitrofes: Boolean;
{$IFDEF DEVELOPING}
    fo: TSHFileOpStruct;
{$ENDIF}
begin
    inherited;
    { Desabilita o timer de forma que os métodos contidos aqui possam demorar
    qualquer intervalo de tempo. Ao final, o timer será religado e aguardará
    intervalodechecagemgeral até executar este evento outra vez }
    Timer_EmailsAutomaticos.Enabled := False;

    {$IFDEF DEVELOPING}
    // Em modo de depuração exclui todos os e-mails gerados
    ZeroMemory(@fo,SizeOf(TSHFileOpStruct));

    fo.Wnd := Application.Handle;
    fo.wFunc := FO_DELETE;
    fo.pFrom := PChar(Configurations.CurrentDir + '\EmailTemplates\_EMAILSGERADOS\*.*'#0#0);
    fo.fFlags := FOF_FILESONLY;

    SHFileOperation(fo);
    {$ENDIF}

    EnviouEmailParaOciosas := GerarEEnviarEmailsParaObrasOciosas;
    GerarEEnviarEmailsParaObrasGanhas;
    GerarEEnviarEmailsParaObrasPerdidas;
    EnviouEmailParaLimitrofes := GerarEEnviarEmailsParaObrasLimitrofes;

    if EnviouEmailParaOciosas then
    begin
        FProximoEnvioParaObrasOciosas := Now + Configurations.IntervaloDeChecagemDeOciosas;
        MyModule.Label_EmailsParaObrasOciosasProximoEnvio.Caption := FormatDateTime('"Próxima checagem em: "dd/mm/yyyy" às "hh:nn:ss',FProximoEnvioParaObrasOciosas);
    end;

    MyModule.Label_EmailsParaObrasGanhasProximoEnvio.Caption := FormatDateTime('"Próxima checagem em: "dd/mm/yyyy" às "hh:nn:ss',Now + (Configurations.IntervaloDeChecagemGeral / 60 / 24));

    MyModule.Label_EmailsParaObrasPerdidasProximoEnvio.Caption := FormatDateTime('"Próxima checagem em: "dd/mm/yyyy" às "hh:nn:ss',Now + (Configurations.IntervaloDeChecagemGeral / 60 / 24));

    if EnviouEmailParaLimitrofes then
    begin
        FProximoEnvioParaObrasLimitrofes := Now + Configurations.IntervaloDeChecagemDeLimitrofes;
        MyModule.Label_EmailsParaObrasLimitrofesProximoEnvio.Caption := FormatDateTime('"Próxima checagem em: "dd/mm/yyyy" às "hh:nn:ss',FProximoEnvioParaObrasLimitrofes);
    end;

    {$IFNDEF DEVELOPING}
    Timer_EmailsAutomaticos.Enabled := True;
    {$ENDIF}
end;

procedure TBDIDataModule_Main.TrayIcon_BDIDblClick(Sender: TObject);
begin
    inherited;
    RestaurarDoTray;
end;

procedure TBDIDataModule_Main.DoAfterConnectBDI(aSender: TObject);
const
    SQL_CREATE_DATABASE_BANCODEINFORMACOES = 'CREATE DATABASE IF NOT EXISTS BANCODEINFORMACOES DEFAULT CHARACTER SET LATIN1 COLLATE LATIN1_BIN';
    SQL_CREATE_TABLE_OBRASPROCESSADAS =
    'CREATE TABLE IF NOT EXISTS BANCODEINFORMACOES.OBRASPROCESSADAS (IN_OBRAS_ID INTEGER UNSIGNED NOT NULL'#13#10 +
    '                                                               ,TI_SITUACOES_ID TINYINT UNSIGNED DEFAULT NULL'#13#10 +
    '                                                               ,PRIMARY KEY (IN_OBRAS_ID))';
begin
    inherited;
    { Cria o banco de dados se ele não existe }
    ExecuteQuery(ZConnection_BDI,SQL_CREATE_DATABASE_BANCODEINFORMACOES);
    { Cria a tabela OBRASPROCESSADAS se ela não existir }
    ExecuteQuery(ZConnection_BDI,SQL_CREATE_TABLE_OBRASPROCESSADAS);
end;

procedure TBDIDataModule_Main.DoAfterConnectBDO(Sender: TObject);
const
    SQL_CREATE_TEMPTABLE_OBRASPROCESSADAS =
    'CREATE TEMPORARY TABLE OBRASPROCESSADAS (IN_OBRAS_ID INTEGER UNSIGNED NOT NULL)';
begin
    inherited;
    { Cria a tabela OBRASPROCESSADAS se ela não existir }
    ExecuteQuery(ZConnection_BDO,SQL_CREATE_TEMPTABLE_OBRASPROCESSADAS);
end;

{ Aqui configure as senhas permitidas de acordo com os tipos de autenticação e
de acordo com as páginas que podem ser obtidas com "ConnectedClient.Path" }
procedure TBDIDataModule_Main.DoAuthGetPassword(Sender, Client: TObject; var Password: string);
var
    ConnectedClient  : TConnectedClient;
begin
    inherited;
    {  }
    ConnectedClient := TConnectedClient(Client);
    if (ConnectedClient.AuthType = atDigest) and (ConnectedClient.AuthUserName = 'master') then
        Password := 'master';
end;

{ Aqui proteja páginas específicas indicando o tipo de autenticação }
procedure TBDIDataModule_Main.DoAuthGetType(Sender, Client: TObject);
var
    ConnectedClient: TConnectedClient;
begin
    inherited;

    ConnectedClient := TConnectedClient(Client);
    { Aqui pode ser usado MatchesMask para proteger uma série de páginas }
    if CompareText(ConnectedClient.Path, '/GeraRelatorioDeObras.html') = 0 then 
    begin
        ConnectedClient.AuthTypes  := [atDigest];
        ConnectedClient.AuthRealm := 'GeraRelatorioDeObras';
    end
    else if CompareText(ConnectedClient.Path, '/GeraRelatorioDePropostas.html') = 0 then
    begin
        ConnectedClient.AuthTypes  := [atDigest];
        ConnectedClient.AuthRealm := 'GeraRelatorioDePropostas';
    end;

end;

procedure TBDIDataModule_Main.DoGetData(Sender: TObject; LineNum: Integer; MsgLine: Pointer; MaxLen: Integer; var More: Boolean);
var
    Tamanho: Integer;
begin
    inherited;

    if LineNum > FEmailAEnviar.Count then
        More := False
    else
    begin
        Tamanho := Length(FEmailAEnviar[Pred(LineNum)]);

        { Truncate the line if too long (should wrap to next line) }
        if Tamanho >= MaxLen then
            StrPCopy(MsgLine,Copy(FEmailAEnviar[Pred(LineNum)],1,Pred(MaxLen)))
        else
            StrPCopy(MsgLine, FEmailAEnviar[Pred(LineNum)]);
    end;
end;

//procedure TWebServForm.DisplayHeader(ClientCnx : TMyHttpConnection);
//var
//    I : Integer;
//begin
//    if not DisplayHeaderCheckBox.Checked then
//        Exit;
//    for I := 0 to ClientCnx.RequestHeader.Count - 1 do
//        Display('HDR' + IntToStr(I + 1) + ') ' +
//                ClientCnx.RequestHeader.Strings[I]);
//end;

{ Documentos acessados via método HTTP GET }
procedure TBDIDataModule_Main.DoGetDocument(Sender, Client: TObject; var Flags: THttpGetFlag);
var
    ConnectedClient: TConnectedClient;
begin
    inherited;
    if Flags = hg401 then
        Exit;

    ConnectedClient := TConnectedClient(Client);
    Inc(FCountRequests);
    HTTPShowOnLog('Iniciando requisição >>>>>>>>>>>>>>>>>>>>>>>>>',MyModule.RichEdit_HTTPLog);
    try
//    DisplayHeader(ConnectedClient);
        HTTPShowOnLog('§ IP do cliente: ' + ConnectedClient.GetPeerAddr + '\n' +
                      'Requisição ..: #' + IntToStr(FCountRequests) + '\n' +
                      'Versão.......: ' + ConnectedClient.Version + ' (GET) \n' + 
                      'URL requisitado:\n' + ConnectedClient.Path,MyModule.RichEdit_HTTPLog);
    
        if CompareText(ConnectedClient.Path, '/DocumentoVirtualObtidoPorGet.html') = 0 then
    //        CreateVirtualDocument_DocumentoVirtualObtidoPorGet(Sender, ConnectedClient, Flags)

    finally
        HTTPShowOnLog('Requisição finalizada <<<<<<<<<<<<<<<<<<<<<<<<',MyModule.RichEdit_HTTPLog);
    end;    
end;

{ Documentos acessados via método HTTP POST }
procedure TBDIDataModule_Main.DoPostDocument(Sender, Client: TObject; var Flags: THttpGetFlag);
var
    ConnectedClient: TConnectedClient;
begin
    inherited;

    ConnectedClient := TConnectedClient(Client);
    Inc(FCountRequests);
    HTTPShowOnLog('Iniciando requisição >>>>>>>>>>>>>>>>>>>>>>>>>',MyModule.RichEdit_HTTPLog);

    try
//        DisplayHeader(ConnectedClient);
        HTTPShowOnLog('§ IP do cliente: ' + ConnectedClient.GetPeerAddr + '\n' +
                      'Requisição ..: #' + IntToStr(FCountRequests) + '\n' +
                      'Versão.......: ' + ConnectedClient.Version + ' (POST) \n' +
                      'URL requisitado:\n' + ConnectedClient.Path,MyModule.RichEdit_HTTPLog);

        { Originalmente o exemplo limitava a apenas um caminho
        (/cgi-bin/FormHandler) as requisições via POST, dessa forma apenas
        formulários que tinham o action apontando para este caminho é que seriam
        processados. Para um servidor genérico devemos configurar apenas o
        posted data buffer. É exatamente isso que estamos fazendo abaixo }

        { Dizendo ao servidor HTTP que aceitaremos dados via POST. Com isso o
        evento OnPostedData será executado quando os dados chegarem }
        Flags := hgAcceptData;

        { Queremos receber qualquer tipo de dados, então desligamos o modo de
        linhas na conexão do cliente }
        ConnectedClient.LineMode := FALSE;

        { Precisamos de um buffer para guardar os dados postados. Devemos alocar
        tanto espaço quanto o tamanho dos dados postados mais um byte para o
        caractere terminador NULL. Deveremos verificar se ContentLength = 0 e
        manipular esta situação }

        ReallocMem(ConnectedClient.FPostedDataBuffer
                  ,Succ(ConnectedClient.RequestContentLength));

        { Limpando o tamanho recebido }
        ConnectedClient.FDataLen := 0;
    finally
        HTTPShowOnLog('Requisição finalizada <<<<<<<<<<<<<<<<<<<<<<<<',MyModule.RichEdit_HTTPLog);
    end;
end;

procedure TBDIDataModule_Main.DoRequestDone(Sender: TObject; RqType: TSmtpRequest; ErrorCode: Word);
begin
    inherited;
    { For every operation, we display the status }
//    if (ErrorCode > 0) and (ErrorCode < 10000) then
//        Display('RequestDone Rq=' + IntToStr(Ord(RqType)) + ' Error='+ SmtpClient.ErrorMessage)
//    else
//        Display('RequestDone Rq=' + IntToStr(Ord(RqType)) + ' Error='+ IntToStr(Error));


    { But first check if previous one was OK            }
    if ErrorCode <> 0 then
    begin
//        Display('Error, stoped All-In-One demo');
        Exit;
    end;

    case RqType of
        smtpConnect: begin
            if SmtpCli_BDI.AuthType = smtpAuthNone then
                SmtpCli_BDI.Helo
            else
                SmtpCli_BDI.Ehlo;
        end;
        smtpHelo: SmtpCli_BDI.MailFrom;
        smtpEhlo: SmtpCli_BDI.Auth;
        smtpAuth: SmtpCli_BDI.MailFrom;
        smtpMailFrom: SmtpCli_BDI.RcptTo;
        smtpRcptTo: SmtpCli_BDI.Data;
        smtpData: SmtpCli_BDI.Quit;
        smtpQuit: begin
            case FEnviandoEmail of
                eeObrasOciosas: ObrasOciosasAddProgress;
                eeObrasGanhas: ObrasGanhasAddProgress;
                eeObrasPerdidas: ObrasPerdidasAddProgress;
                eeObrasLimitrofes: ObrasLimitrofesAddProgress;
            end;
    //        Display('All-In-One done !')
        end;
    end;
end;

procedure TBDIDataModule_Main.DoServerStarted(Sender: TObject);
var
	WSI: TWSAData;
begin
    Inherited;
    WSI := WinsockInfo;

    if MyModule.RichEdit_HTTPLog.Tag = 0 then
    begin
        HTTPShowOnLog('Usando:',MyModule.RichEdit_HTTPLog);
        HTTPShowOnLog('  ' + Trim(OverbyteIcsWSocket.CopyRight),MyModule.RichEdit_HTTPLog);
        HTTPShowOnLog('  ' + Trim(OverbyteIcsWSocketS.CopyRight),MyModule.RichEdit_HTTPLog);
        HTTPShowOnLog('  ' + Trim(OverbyteIcsHttpSrv.CopyRight),MyModule.RichEdit_HTTPLog);
        HTTPShowOnLog('  Informações sobre o Winsock...',MyModule.RichEdit_HTTPLog);
        HTTPShowOnLog('    Versão .....: ' + Format('%d.%d', [WSI.wHighVersion shr 8,WSI.wHighVersion and 15]),MyModule.RichEdit_HTTPLog);
        HTTPShowOnLog('    Descrição ..: ' + StrPas(WSI.szDescription),MyModule.RichEdit_HTTPLog);
        HTTPShowOnLog('    Status .....: ' + StrPas(WSI.szSystemStatus),MyModule.RichEdit_HTTPLog);

        if Assigned(WSI.lpVendorInfo) then
            HTTPShowOnLog('    ' + StrPas(WSI.lpVendorInfo),MyModule.RichEdit_HTTPLog);

        MyModule.RichEdit_HTTPLog.Tag := 1;
    end;

    MyModule.Action_HTTPAtivarDesativar.Checked := True;
    MyModule.Action_HTTPAtivarDesativar.Caption := 'Desativar serviço de informações via HTTP';
    MyModule.LabeledEdit_PortaHTTP.Enabled := not MyModule.Action_HTTPAtivarDesativar.Checked;

    HTTPShowOnLog('§ O servidor está ativo e aguardando\nconexões na porta ' + HttpServer_BDI.Port,MyModule.RichEdit_HTTPLog);
  	HTTPShowOnLog('Aponte seu browser para o seguinte endereço:',MyModule.RichEdit_HTTPLog);
  	HTTPShowOnLog('http://' + LowerCase(LocalHostName) + IfThen(Configurations.HTTPPort <> 80,':' + IntToStr(Configurations.HTTPPort),''),MyModule.RichEdit_HTTPLog);
  	HTTPShowOnLog('---------------------------------------------',MyModule.RichEdit_HTTPLog);
    MyModule.Panel_Status.Caption := 'Clientes conectados: 0';
end;

procedure TBDIDataModule_Main.DoServerStopped(Sender: TObject);
begin
    inherited;
    MyModule.Action_HTTPAtivarDesativar.Checked := False;
    MyModule.Action_HTTPAtivarDesativar.Caption := 'Ativar serviço de informações via HTTP';
    MyModule.LabeledEdit_PortaHTTP.Enabled := not MyModule.Action_HTTPAtivarDesativar.Checked;

  	HTTPShowOnLog('§ Servidor desativado',MyModule.RichEdit_HTTPLog);
  	HTTPShowOnLog('---------------------------------------------',MyModule.RichEdit_HTTPLog);
    MyModule.Panel_Status.Caption := 'Clientes conectados: 0';
end;

procedure TBDIDataModule_Main.ZConnection_BDIBeforeConnect(Sender: TObject);
begin
    inherited;
    { Configurando o MySQL Embedded }
    ZConnection_BDI.Protocol   := 'mysqld-5';
    ZConnection_BDI.HostName   := '';
    ZConnection_BDI.Port       := 0;
    ZConnection_BDI.Database   := '';
    ZConnection_BDI.User       := '';
    ZConnection_BDI.Password   := '';
    ZConnection_BDI.TransactIsolationLevel := tiReadCommitted;
end;

procedure TBDIDataModule_Main.ZConnection_BDOBeforeConnect(Sender: TObject);
begin
    inherited;
    ZConnection_BDO.Protocol := Configurations.DBProtocol;
    ZConnection_BDO.HostName := Configurations.DBHostAddr;
    ZConnection_BDO.Port     := Configurations.DBPortNumb;
    ZConnection_BDO.Database := Configurations.DBDataBase;
    ZConnection_BDO.User     := Configurations.DBUserName;
    ZConnection_BDO.Password := Configurations.DBPassword;
    ZConnection_BDO.TransactIsolationLevel := TZTransactIsolationLevel(Configurations.DBIsoLevel);
end;

{ TMyHttpConnection }

destructor TConnectedClient.Destroy;
begin
    if Assigned(FPostedDataBuffer) then
    begin
        FreeMem(FPostedDataBuffer, FPostedDataSize);
        FPostedDataBuffer := nil;
        FPostedDataSize := 0;
    end;

    inherited;
end;

end.
