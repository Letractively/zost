(*******************************************************************************
Autor.......: Carlos Feitoza - RT#????? - 10/10/2009

Objetivo....: Disponibilizar de uma forma centralizada as fun��es exportadas
              pela biblioteca MPSProcessoCNJ.dll.
--------------------------------------------------------------------------------
Atualiza��o.: dd/mm/yyyy - Seu Nome - RT#????: Descri��o. Favor manter este
              formato quando alterar esta unit...
*******************************************************************************)
unit UMPSNPU;

interface

{ Fun��es exportadas }
function ValidarProcessoCNJ(aProcesso
                           ,aAno
                           ,aJ
                           ,aTR
                           ,aOrigem: String): String;

function GerarDigitoVerificadorCNJValido(aNumeroSequencial
                                        ,aAno
                                        ,aJustica
                                        ,aTribunal
                                        ,aOrigem: Cardinal): String;

function FormatarProcessoCNJ(aProcesso: String;
                             aCompletarZerosEsquerda: Boolean = True): String;
{ Fun��es adicionais }
procedure NPUObterComponentes(      aProcesso: String;
                                out aSequencial: Cardinal;
                                out aDigitoVerificador: Byte;
                                out aAno: Word;
                                out aJustica
                                  , aTribunal: Byte;
                                out aOrigem: Word);

procedure NPURemoverDelimitadores(var aProcesso: String);

implementation

uses
  Windows, SysUtils;

type
  TValidarProcesso = function (aProcesso
                              ,aAno
                              ,aJ
                              ,aTR
                              ,aOrigem: PChar): PChar; stdcall;

  TGerarDigitoVerificadorValido = function (aNumeroSequencial
                                           ,aAno
                                           ,aJustica
                                           ,aTribunal
                                           ,aOrigem: Integer): PChar; stdcall;

  TFormatarProcesso = function (aProcesso: PChar;
                                aCompletarZerosEsquerda: Boolean = True): PChar; stdcall;

const
  { Localiza��o e nome da DLL }
  DLLNAME = 'MPSProcessoCNJ.dll';
  DLLPATH = DLLNAME; { Apenas usado quando a DLL estiver em um local espec�fico }

  { Nomes das fun��es exportadas pela DLL }
  VALIDAR_PROCESSO = 'validarProcessoCNJ';
  FORMATAR_PROCESS0 = 'formatarProcesso';
  GERAR_DIGITO_VERIFICADOR = 'gerarDigitoVerificadorCNJValido';

  { Delimitadores do NPU}
  NPU_DELIMITADORES: array [0..1] of Char = ('.','-');

  { Posicionamento dos componentes do NPU: NNNNNNN�DD.AAAA.J.TR.OOOO }
  SEQ_INDEX = 1;
  SEQ_COUNT = 7;
  DIG_INDEX = 9;
  DIG_COUNT = 2;
  ANO_INDEX = 12;
  ANO_COUNT = 4;
  JUS_INDEX = 17;
  JUS_COUNT = 1;
  TRB_INDEX = 19;
  TRB_COUNT = 2;
  ORI_INDEX = 22;
  ORI_COUNT = 4;

function ValidarProcessoCNJ(aProcesso
                           ,aAno
                           ,aJ
                           ,aTR
                           ,aOrigem: String): String;
var
  Handle: THandle;
  ValidarProcesso: TValidarProcesso;
begin
  Result := '';

  Handle := SafeLoadLibrary(DLLPATH);

  if Handle <> 0 then
    try
      ValidarProcesso := GetProcAddress(Handle, VALIDAR_PROCESSO);

      if @ValidarProcesso <> nil then
        try
          Result := ValidarProcesso(PChar(aProcesso)
                                   ,PChar(aAno)
                                   ,PChar(aJ)
                                   ,PChar(aTR)
                                   ,PChar(aOrigem));
        except
          on E: Exception do
            raise Exception.CreateFmt('Erro: %s'#13#10'Motivo: %s',[E.ClassName,E.Message]);
        end
      else
        raise Exception.Create('GetProcAddress: N�o foi poss�vel obter o endere�o da fun��o validarProcessoCNJ');
    finally
      FreeLibrary(Handle);
    end
  else
    raise Exception.CreateFmt('SafeLoadLibrary: N�o foi poss�vel carregar a biblioteca %s',[DLLPATH]);
end;

function GerarDigitoVerificadorCNJValido(aNumeroSequencial
                                        ,aAno
                                        ,aJustica
                                        ,aTribunal
                                        ,aOrigem: Cardinal): String;
var
  Handle: THandle;
  GerarDigitoVerificadorValido: TGerarDigitoVerificadorValido;
begin
  Result := '';

  Handle := SafeLoadLibrary(DLLPATH);

  if Handle <> 0 then
    try
      GerarDigitoVerificadorValido := GetProcAddress(Handle, GERAR_DIGITO_VERIFICADOR);

      if @GerarDigitoVerificadorValido <> nil then
        try
          Result := GerarDigitoVerificadorValido(aNumeroSequencial
                                                ,aAno
                                                ,aJustica
                                                ,aTribunal
                                                ,aOrigem);
        except
          on E: Exception do
            raise Exception.CreateFmt('Erro: %s'#13#10'Motivo: %s',[E.ClassName,E.Message]);
        end
      else
        raise Exception.Create('GetProcAddress: N�o foi poss�vel obter o endere�o da fun��o gerarDigitoVerificadorCNJValido');
    finally
      FreeLibrary(Handle);
    end

  else
    raise Exception.Create('SafeLoadLibrary: N�o foi poss�vel carregar a biblioteca ' + DLLPATH);
end;

function FormatarProcessoCNJ(aProcesso: String;
                             aCompletarZerosEsquerda: Boolean = True): String;
var
  Handle: THandle;
  FormatarProcesso: TFormatarProcesso;
begin
  Result := '';

  Handle := SafeLoadLibrary(DLLPATH);

  if Handle <> 0 then
    try
      FormatarProcesso := GetProcAddress(Handle, FORMATAR_PROCESS0);

      if @FormatarProcesso <> nil then
        try
          Result := FormatarProcesso(PChar(aProcesso)
                                    ,aCompletarZerosEsquerda);
        except
          on E: Exception do
            raise Exception.CreateFmt('Erro: %s'#13#10'Motivo: %s',[E.ClassName,E.Message]);
        end
      else
        raise Exception.Create('GetProcAddress: N�o foi poss�vel obter o endere�o da fun��o formatarProcessoCNJ');
    finally
      FreeLibrary(Handle);
    end
  else
    raise Exception.Create('SafeLoadLibrary: N�o foi poss�vel carregar a biblioteca ' + DLLPATH);
end;

(*******************************************************************************
 * Objetivo....> Obt�m cada um dos componentes do n�mero do processo passado no
 *               par�metro "aProcesso"
 * Par�metros..> aProcesso: Processo formatado segundo o padr�o ou completo sem
 *               os caracteres separadores. O procedure se encarrega de formatar
 *               internamente o processo, caso ele tenha sido informado sem seus
 *               delimitadores.
 *
 *               aSequencial, aDigitoVerificador, aAno, aJustica, aTribunal e
 *               aOrigem: Par�metros de sa�da que conter�o os componentes do
 *               primeiro par�metro caso o processo informado seja v�lido, ou
 *               zero em cada um deles caso o procedure falhe
 * Cria��o.....> 06/10/2009 - Carlos Feitoza - RT#?????
 * Observa��es.>
 * Atualiza��o.>
 ******************************************************************************)
procedure NPUObterComponentes(      aProcesso: String;
                                out aSequencial: Cardinal;
                                out aDigitoVerificador: Byte;
                                out aAno: Word;
                                out aJustica
                                  , aTribunal: Byte;
                                out aOrigem: Word);
begin
  aSequencial        := 0;
  aDigitoVerificador := 0;
  aAno               := 0;
  aJustica           := 0;
  aTribunal          := 0;
  aOrigem            := 0;
  { Esta fun��o tamb�m aceita a forma sem os zeros � esquerda }

  { NNNNNNN�DD.AAAA.J.TR.OOOO ou NNNNNNNDDAAAAJTROOOO }

  { 1. Remove os caracteres delimitadores caso existam }
  NPURemoverDelimitadores(aProcesso);

  { NNNNNNNDDAAAAJTROOOO }
  { 2. Reformata o processo }
  aProcesso := FormatarProcessoCNJ(aProcesso);

  { 3. Valida o processo formatado. Se for v�lido passa, do contr�rio critica }
  if ValidarProcessoCNJ(aProcesso,EmptyStr,EmptyStr,EmptyStr,EmptyStr) = '' then
    raise Exception.Create('NPUObterComponentes: O processo informado (' + aProcesso + ') � inv�lido');

  { NNNNNNN�DD.AAAA.J.TR.OOOO }
  { 4. Obt�m os componentes }
  aSequencial        := StrToInt(Copy(aProcesso,SEQ_INDEX,SEQ_COUNT));
  aDigitoVerificador := StrToInt(Copy(aProcesso,DIG_INDEX,DIG_COUNT));
  aAno               := StrToInt(Copy(aProcesso,ANO_INDEX,ANO_COUNT));
  aJustica           := StrToInt(Copy(aProcesso,JUS_INDEX,JUS_COUNT));
  aTribunal          := StrToInt(Copy(aProcesso,TRB_INDEX,TRB_COUNT));
  aOrigem            := StrToInt(Copy(aProcesso,ORI_INDEX,ORI_COUNT));
end;

(*******************************************************************************
 * Objetivo....> Remove todos os caracteres delimitadores do n�mero do processo
 *               passado por par�metro
 * Par�metros..> aProcesso: Processo formatado com caracteres delimitadores
 * Cria��o.....> 06/10/2009 - Carlos Feitoza - RT#?????
 * Observa��es.>
 * Atualiza��o.>
 ******************************************************************************)
procedure NPURemoverDelimitadores(var aProcesso: String);
var
  i: Byte;
begin
  for i := 0 to High(NPU_DELIMITADORES) do
    aProcesso := StringReplace(aProcesso,NPU_DELIMITADORES[i],'',[rfReplaceAll]);
end;

end.
