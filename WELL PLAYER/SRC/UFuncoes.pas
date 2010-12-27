unit UFuncoes;

interface

function CopyFile(aOrign, aDestiny: String; aFailOnExists: Boolean = False): boolean;
procedure ClearDirectory(aDirectory: String);
procedure VerificarLicenca;

implementation

uses Forms, Windows, ShellApi, SysUtils, Classes, UHDDInfo, ZTO.Crypt.Utilities, ZTO.Crypt.Types;

{ Caso a fun��o termine sem nenhum raise, significa que a licen�a � v�lida }
procedure VerificarLicenca;
var
  i: Byte;
  HDDCount: Byte;
begin
  { Carregando arquivo de licen�as }
  if FileExists(ChangeFileExt(Application.ExeName,'.lic')) then
    with TStringList.Create do
      try
        LoadFromFile(ChangeFileExt(Application.ExeName,'.lic'));

        HDDCount := GetHDDCount;
        
        for i := 0 to Pred(GetHDDCount) do
          if IndexOf(GetStringCheckSum(GetHDDInfo(i).SerialNumber,[haTiger,haSha512,haHaval,haSha384,haRipemd128,haSha256,haRipemd160,haSha1],haSha512)) > -1 then
            Break;

        { Se nenhuma licen�a foi encontrada, sai! }
        if i = HDDCount then
          raise Exception.Create('Nenhuma licen�a v�lida foi encontrada. Hardware n�o autorizado');

      finally
        Free;
      end
  else
    raise Exception.Create('Arquivo de licen�a n�o encontrado. Voc� n�o pode executar esta aplica��o!');
end;

function CopyFile(aOrign, aDestiny: String; aFailOnExists: Boolean = False): boolean;
var
  Dados: TSHFileOpStruct;
begin
  ZeroMemory(@Dados, SizeOf(TSHFileOpStruct));

  {
  wFunc
Valor que indica qual opera��o ser� realizada. Pode ter um dos seguintes valores
FO_COPY
 Copia o(s) arquivo(s) especificado(s) no par�metro pFrom para o local especificado no par�metro pTo.
FO_DELETE
 Delete o(s) arquivo(s) especificado no par�metro pFrom.
FO_MOVE
 Move o(s) arquivo(s) especificado(s) no par�metro pFrom para o local especificado no par�metro pTo.
FO_RENAME
 Renomeia os arquivo especificado no par�metro pFrom para o nome especificado no par�metro pTo. Usando essa fun��o, n�o pode ser utilizado o flag de multiplos arquivos.
  }
  Dados.lpszProgressTitle := 'Obtendo arquivos. Queira aguardar...';
  Dados.wFunc  := FO_COPY;
  Dados.pFrom  := PChar(aOrign + #0#0);
  Dados.pTo    := PChar(aDestiny + #0#0);

{
 fFlag
Este par�metro pode ser utilizado um ou diversos valores ao mesmo tempo, por�m alguns n�o funcionam em conjunto, utilize OR para ligar mais de um flag.
FOF_ALLOWUNDO
 Permite desfazer a opera��o chamada.
FOF_CONFIRMMOUSE
 N�o utilizada.
FOF_FILESONLY
 A opera��o ser� realizada apenas em arquivos quando utilizar o coringa (*.*), ir� ignorar pastas.
FOF_MULTIDESTFILES
 Permite opera��o em multiplos arquivos, se o par�metro pTo for uma pasta ele ira entender utilizar o nome do arquivo de pFrom com a pasta de pTo.
FOF_NOCONFIRMATION
 Assume como padr�o �Sim para todos� para qualquer tela de confirma��o para sobreescrever arquivo.
FOF_NOCONFIRMMKDIR
 N�o cria automaticamente a pasta de destino caso ela n�o exista.
FOF_NO_CONNECTED_ELEMENTS
 Vers�o 5.0. N�o move arquivos conectados de grupo, somente arquivos especificados.
FOF_NOCOPYSECURITYATTRIBS
 Vers�o 4.71. N�o copia atributos de seguran�a para o novo arquivo.
FOF_NOERRORUI
 N�o mostra tela de erro se algum ocorrer.
FOF_NORECURSION
 Somente executa em diret�rio local, n�o executa nos subdiret�rios.
FOF_NORECURSEREPARSE
 
FOF_RENAMEONCOLLISION
 Em o arquivo pTo j� existir, d� um novo nome para o arquivo no destino.
FOF_SILENT
 N�o mostra tela de progresso da c�pia do arquivo.
FOF_SIMPLEPROGRESS
 Mostra tela de progresso, por�m n�o mostra o(s) nome(S) do(S) arquivo(s).
}
  Dados.fFlags := FOF_ALLOWUNDO;

  if not aFailOnExists then
    Dados.fFlags := Dados.fFlags or FOF_NOCONFIRMATION;

  Result := SHFileOperation(Dados) = 0;
end;

procedure ClearDirectory(aDirectory: String);
	{Procedures e fun��es locais}
    procedure SearchTree;
    var
	    SearchRec: TSearchRec;
    	DosError: integer;
    begin
	    DosError := FindFirst('*.*', 0, SearchRec);
    	while DosError = 0 do
	    begin
		    try
			    DeleteFile(SearchRec.Name);
		    except
			    on Eoor: EOutOfResources do
			    begin
				    Eoor.Message := Eoor.Message + #13#10'A quantidade de arquivos localizados excede o limite de recursos do seu sistema. Favor limitar seu crit�rio de busca escolhendo diret�rio(s) de n�vel mais interno';
				    raise;
			    end;
		    end;
		    DosError := FindNext(SearchRec);
        end;

        DosError := FindFirst('*.*', faDirectory, SearchRec);
        while DosError = 0 do
        begin
	        if ((SearchRec.attr and faDirectory = faDirectory) and (SearchRec.name <> '.') and (SearchRec.name <> '..')) then
    	    begin
        		ChDir(SearchRec.Name);
		        SearchTree;
		        RemoveDir(SearchRec.Name);
            ChDir('..');
        	end;
	        DosError := FindNext(SearchRec);
        end;
    end;
begin
	ChDir(aDirectory);
	SearchTree;
end;



end.
