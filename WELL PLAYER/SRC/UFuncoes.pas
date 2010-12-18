unit UFuncoes;

interface

function CopyFile(aOrign, aDestiny: String; aFailOnExists: Boolean = False): boolean;
procedure ClearDirectory(aDirectory: String);

implementation

uses Windows, ShellApi, SysUtils, Classes;

function CopyFile(aOrign, aDestiny: String; aFailOnExists: Boolean = False): boolean;
var
  Dados: TSHFileOpStruct;
begin
  ZeroMemory(@Dados, SizeOf(TSHFileOpStruct));

  {
  wFunc
Valor que indica qual operação será realizada. Pode ter um dos seguintes valores
FO_COPY
 Copia o(s) arquivo(s) especificado(s) no parâmetro pFrom para o local especificado no parâmetro pTo.
FO_DELETE
 Delete o(s) arquivo(s) especificado no parâmetro pFrom.
FO_MOVE
 Move o(s) arquivo(s) especificado(s) no parâmetro pFrom para o local especificado no parâmetro pTo.
FO_RENAME
 Renomeia os arquivo especificado no parâmetro pFrom para o nome especificado no parâmetro pTo. Usando essa função, não pode ser utilizado o flag de multiplos arquivos.
  }
  Dados.lpszProgressTitle := 'Obtendo arquivos. Queira aguardar...';
  Dados.wFunc  := FO_COPY;
  Dados.pFrom  := PChar(aOrign + #0#0);
  Dados.pTo    := PChar(aDestiny + #0#0);

{
 fFlag
Este parâmetro pode ser utilizado um ou diversos valores ao mesmo tempo, porém alguns não funcionam em conjunto, utilize OR para ligar mais de um flag.
FOF_ALLOWUNDO
 Permite desfazer a operação chamada.
FOF_CONFIRMMOUSE
 Não utilizada.
FOF_FILESONLY
 A operação será realizada apenas em arquivos quando utilizar o coringa (*.*), irá ignorar pastas.
FOF_MULTIDESTFILES
 Permite operação em multiplos arquivos, se o parâmetro pTo for uma pasta ele ira entender utilizar o nome do arquivo de pFrom com a pasta de pTo.
FOF_NOCONFIRMATION
 Assume como padrão “Sim para todos” para qualquer tela de confirmação para sobreescrever arquivo.
FOF_NOCONFIRMMKDIR
 Não cria automaticamente a pasta de destino caso ela não exista.
FOF_NO_CONNECTED_ELEMENTS
 Versão 5.0. Não move arquivos conectados de grupo, somente arquivos especificados.
FOF_NOCOPYSECURITYATTRIBS
 Versão 4.71. Não copia atributos de segurança para o novo arquivo.
FOF_NOERRORUI
 Não mostra tela de erro se algum ocorrer.
FOF_NORECURSION
 Somente executa em diretório local, não executa nos subdiretórios.
FOF_NORECURSEREPARSE
 
FOF_RENAMEONCOLLISION
 Em o arquivo pTo já existir, dá um novo nome para o arquivo no destino.
FOF_SILENT
 Não mostra tela de progresso da cópia do arquivo.
FOF_SIMPLEPROGRESS
 Mostra tela de progresso, porém não mostra o(s) nome(S) do(S) arquivo(s).
}
  Dados.fFlags := FOF_ALLOWUNDO;

  if not aFailOnExists then
    Dados.fFlags := Dados.fFlags or FOF_NOCONFIRMATION;

  Result := SHFileOperation(Dados) = 0;
end;

procedure ClearDirectory(aDirectory: String);
	{Procedures e funções locais}
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
				    Eoor.Message := Eoor.Message + #13#10'A quantidade de arquivos localizados excede o limite de recursos do seu sistema. Favor limitar seu critério de busca escolhendo diretório(s) de nível mais interno';
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
