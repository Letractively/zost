unit UBDODataModule_GeradorDeRelatorio;

interface

uses
    Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
    Dialogs, UBDODataModule, ImgList, ActnList,

    UBDOForm_GeradorDeRelatorio, UXXXDataModule;

type
    TBDODataModule_GeradorDeRelatorio = class(TBDODataModule)
    private
        { Private declarations }
        FArquivoTemporario: OleVariant;
        function MyModule: TBDOForm_GeradorDeRelatorio;
        procedure OpenHTMLFile(aHTMLFile: AnsiString);
    protected
        { Protected declarations }
        property ArquivoTemporario: OleVariant read FArquivoTemporario;
        function CharReplace(var S: AnsiString; const Search, Replace: AnsiChar): Integer;
    public
        { Public declarations }
        procedure ObterVoltagens(const aStrings: TStrings);
        procedure ObterRegioes(const aStrings: TStrings);
        procedure ObterFamilias(const aStrings: TStrings);
        procedure ObterInstaladores(const aStrings: TStrings);
        procedure ObterSituacoes(const aStrings: TStrings);
        procedure GerarRelatorio; virtual;
        procedure ClearHTML;
        procedure InitializeHTML;
		constructor Create(aOwner: TComponent; aDataModule_BasicCreateParameters: TDataModuleCreateParameters); override;
        procedure ConfigurarPagina;
        procedure Imprimir;
        procedure SalvarComo;
        procedure Previsualizar;
    end;

implementation

uses
    ZDataset, {$IFDEF IE}SHDocVw{$ELSE}MOZILLACONTROLLib_TLB{$ENDIF}, UBDOTypesConstantsAndClasses;


{$R *.dfm}

//Boa tarde!
//
//A demora é esperada devido a quantidade de dados que atualmente existem.
//
//O comportamento do relatório será mudado para gerar apenas quando do pressionamento de um botão (gerar)

{ TBDODataModule_PrevisualizarImpressao }

procedure TBDODataModule_GeradorDeRelatorio.ObterSituacoes(const aStrings: TStrings);
const
  	SQL_SITUACOES =
    '  SELECT TI_SITUACOES_ID'#13#10 +
    '       , VA_DESCRICAO'#13#10 +
    '    FROM SITUACOES'#13#10 +
    'ORDER BY VA_DESCRICAO';
var
	RODataSet: TZReadOnlyQuery;
begin
	RODataSet := nil;
    aStrings.Clear;
    try
    	ConfigureDataSet(DataModuleMain.ZConnections.ByName['ZConnection_BDO'].Connection
                        ,RODataSet,SQL_SITUACOES);

        RODataSet.First;
        while not RODataSet.Eof do
        begin
            aStrings.AddObject(RODataSet.Fields[1].AsString,TObject(RODataSet.Fields[0].AsInteger));
            RODataSet.Next;
        end;

    finally
    	if Assigned(RODataSet) then
        	FreeAndNil(RODataSet);
    end;
end;

procedure TBDODataModule_GeradorDeRelatorio.ObterVoltagens(const aStrings: TStrings);
var
    Voltagem: ShortString;
begin
    aStrings.Clear;
    for Voltagem in VOLTAGENS do
        aStrings.Add(Voltagem);
end;

procedure TBDODataModule_GeradorDeRelatorio.ObterInstaladores(const aStrings: TStrings);
const
    SQL_INSTALADORES =
    '  SELECT SM_INSTALADORES_ID'#13#10 +
    '       , VA_NOME'#13#10 +
    '    FROM INSTALADORES'#13#10 +
    'ORDER BY VA_NOME';
var
	RODataSet: TZReadOnlyQuery;
begin
    aStrings.Clear;
    try
		RODataSet := nil;
    	ConfigureDataSet(DataModuleMain.ZConnections.ByName['ZConnection_BDO'].Connection
                        ,RODataSet
                        ,SQL_INSTALADORES);

        aStrings.AddObject('TODOS',TObject(0));

        RODataSet.First;
        while not RODataSet.Eof do
        begin
            aStrings.AddObject(RODataSet.Fields[1].AsString,TObject(RODataSet.Fields[0].AsInteger));
            RODataSet.Next;
        end;

    finally
    	if Assigned(RODataSet) then
        	FreeAndNil(RODataSet);
    end;
end;

procedure TBDODataModule_GeradorDeRelatorio.ObterFamilias(const aStrings: TStrings);
const
	SQL_FAMILIAS =
    '  SELECT TI_FAMILIAS_ID'#13#10 +
    '       , VA_DESCRICAO'#13#10 +
    '    FROM FAMILIAS'#13#10 +
    'ORDER BY VA_DESCRICAO';
var
	RODataSet: TZReadOnlyQuery;
begin
    aStrings.Clear;
    try
		RODataSet := nil;
    	ConfigureDataSet(DataModuleMain.ZConnections.ByName['ZConnection_BDO'].Connection
                        ,RODataSet
                        ,SQL_FAMILIAS);

        aStrings.AddObject('TODAS',TObject(0));

        RODataSet.First;
        while not RODataSet.Eof do
        begin
            aStrings.AddObject(RODataSet.Fields[1].AsString,TObject(RODataSet.Fields[0].AsInteger));
            RODataSet.Next;
        end;

    finally
    	if Assigned(RODataSet) then
        	FreeAndNil(RODataSet);
    end;
end;

procedure TBDODataModule_GeradorDeRelatorio.ObterRegioes(const aStrings: TStrings);
const
  	SQL_REGIOES =
    'SELECT REG.TI_REGIOES_ID'#13#10 +
    '     , REG.VA_REGIAO'#13#10 +
    '  FROM REGIOES REG'#13#10 +
    '  JOIN REGIOESDOSUSUARIOS RDU USING (TI_REGIOES_ID)'#13#10 +
    ' WHERE RDU.SM_USUARIOS_ID = %u';
var
	RODataSet: TZReadOnlyQuery;
begin
    aStrings.Clear;
    try
		RODataSet := nil;
    	ConfigureDataSet(DataModuleMain.ZConnections.ByName['ZConnection_BDO'].Connection
                        ,RODataSet
                        ,MySQLFormat(SQL_REGIOES,[Configurations.AuthenticatedUser.Id]));

        aStrings.AddObject('TODAS',TObject(0));

        RODataSet.First;
        while not RODataSet.Eof do
        begin
            aStrings.AddObject(RODataSet.Fields[1].AsString,TObject(RODataSet.Fields[0].AsInteger));
            RODataSet.Next;
        end;

    finally
    	if Assigned(RODataSet) then
        	FreeAndNil(RODataSet);
    end;
end;


function TBDODataModule_GeradorDeRelatorio.CharReplace(var S: AnsiString; const Search, Replace: AnsiChar): Integer;
var
    P: PAnsiChar;
begin
    Result := 0;
    if Search <> Replace then
    begin
        UniqueString(S);
        P := PAnsiChar(S);
        while P^ <> #0 do
        begin
            if P^ = Search then
            begin
                P^ := Replace;
                Inc(Result);
            end;
            Inc(P);
        end;
    end;
end;

procedure TBDODataModule_GeradorDeRelatorio.ClearHTML;
begin
    OpenHTMLFile(Configurations.CurrentDir + '\reporttemplates\GeneratingReport.html');
    Application.ProcessMessages;
end;

procedure TBDODataModule_GeradorDeRelatorio.InitializeHTML;
begin
    OpenHTMLFile(Configurations.CurrentDir + '\reporttemplates\home.html');
    Application.ProcessMessages;
end;


{show Page Setup dialog}
{Control <= v1.6: OLECMDEXECOPT_PROMPTUSER causes EOleException due to bug in
flag tests, use OLECMDEXECOPT_DODEFAULT instead + get 'not implemented' dialog;
Bugzilla 2250454.

Control v1.7: Flag tests fixed so can use OLECMDEXECOPT_PROMPTUSER and Page
Setup has been implemented; Bugzilla 2250454 fixed.}
procedure TBDODataModule_GeradorDeRelatorio.ConfigurarPagina;
begin
    try
        { ensure not busy or printing before showing dialog }
        if not(MyModule.HTMLViewer.Busy) and (MyModule.HTMLViewer.QueryStatusWB(OLECMDID_PAGESETUP) > 0) then
            { Show page setup dialog}
            MyModule.HTMLViewer.ExecWB(OLECMDID_PAGESETUP, OLECMDEXECOPT_PROMPTUSER {OLECMDEXECOPT_DODEFAULT});
    except
        { handle exceptions }
        on E: Exception do
            raise Exception.Create('Erro: Não foi possível exibir a caixa de diálogo "Configurar página".' + #13#10 + E.ClassName + ': ' + E.Message + '.');
    end;
end;

constructor TBDODataModule_GeradorDeRelatorio.Create(aOwner: TComponent; aDataModule_BasicCreateParameters: TDataModuleCreateParameters);
begin
    inherited;
    FArquivoTemporario := Configurations.CurrentDir + '\reporttemplates\' + StringReplace(MyModule.Classname,'TBDOForm_','Report_',[]) + '.html';
end;

function TBDODataModule_GeradorDeRelatorio.MyModule: TBDOForm_GeradorDeRelatorio;
begin
	Result := TBDOForm_GeradorDeRelatorio(Owner);
end;

{open web page from URL or file}
procedure TBDODataModule_GeradorDeRelatorio.OpenHTMLFile(aHTMLFile: AnsiString);
begin
    { retrieve address}
    if not (Trim(aHTMLFile) = '') and FileExists(aHTMLFile) then
    begin
        { navigate to address }
        CharReplace(aHTMLFile, '\', '/'); {correct bug with relative links + images}
        MyModule.HTMLViewer.Navigate(WideString(aHTMLFile));
    end;
end;

{show Print Preview window}
{ TODO -oCarlos Feitoza -cEXPLICAÇÃO : Esta caixa de diálogo tem um inconveniente.
Ela não é modal e toda vez que é movida ou se clica na janela de tras, todas as
janelas somem e a aplicação fica parecendo congelada, obrigando o usuário a
pressionar ESC para que a janela de preview feche e as outras apareçam }

{OLECMDID_PRINTPREVIEW not currently supported in Mozilla Control although
QueryStatusWB returns OLECMDF_SUPPORTED so disable menu item.
OLECMDID_PRINTPREVIEW not defined in MozillaBrowser.h; Bugzilla 214884.}
procedure TBDODataModule_GeradorDeRelatorio.Previsualizar;
begin
    try
        { ensure not busy or printing before showing dialog }
        if not(MyModule.HTMLViewer.Busy) and (MyModule.HTMLViewer.QueryStatusWB(OLECMDID_PRINTPREVIEW) > 0) then
            {show Print Preview window}
            MyModule.HTMLViewer.ExecWB(OLECMDID_PRINTPREVIEW, OLECMDEXECOPT_PROMPTUSER);
    except
        { handle exceptions }
        on E: Exception do
            raise Exception.Create('Erro: Não foi possível exibir a caixa de diálogo "Previsualizar impressão".' + #13#10 + E.ClassName + ': ' + E.Message + '.');
    end;
end;

{ show Save As dialog }
{Control <= v1.6: OLECMDEXECOPT_PROMPTUSER causes EOleException due to bug in
flag tests, use OLECMDEXECOPT_DODEFAULT instead; Bugzilla 2250454.
Control v1.7: Flag tests fixed so can use OLECMDEXECOPT_PROMPTUSER; Bugzilla 2250454 }
procedure TBDODataModule_GeradorDeRelatorio.SalvarComo;
var
    PageFilename: OleVariant;
begin
    try
        { ensure not busy }
        if not (MyModule.HTMLViewer.Busy) then
        begin
            PageFilename := MyModule.HTMLViewer.LocationName + '.html';
            { show save as dialog }
            MyModule.HTMLViewer.ExecWB(OLECMDID_SAVEAS, OLECMDEXECOPT_PROMPTUSER {OLECMDEXECOPT_DODEFAULT}, PageFilename);
        end;
    except
        { handle exceptions }
        on E: Exception do
            raise Exception.Create('Erro: Não foi possível exibir a caixa de diálogo "Salvar como".' + #13#10 + E.ClassName + ': ' + E.Message + '.');
    end;
end;

procedure TBDODataModule_GeradorDeRelatorio.GerarRelatorio;
begin
    { Nos filhos devemos sobrescrever este método, salvando no arquivo contido
    em "ArquivoTemporario" e chamar inherited }
    OpenHTMLFile(FArquivoTemporario)
end;

{ print current page }
procedure TBDODataModule_GeradorDeRelatorio.Imprimir;
begin
    try
        { ensure not busy or printing before showing dialog }
        if not(MyModule.HTMLViewer.Busy) and (MyModule.HTMLViewer.QueryStatusWB(OLECMDID_PRINT) > 0) then
            {show Print dialog}
            MyModule.HTMLViewer.ExecWB(OLECMDID_PRINT, OLECMDEXECOPT_PROMPTUSER);
    except
        { handle exceptions }
        on E: Exception do
            raise Exception.Create('Erro: Não foi possível exibir a caixa de diálogo "Imprimir".' + #13#10 + E.ClassName + ': ' + E.Message + '.');
    end;
end;

end.
