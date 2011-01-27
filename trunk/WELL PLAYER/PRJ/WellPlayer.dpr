program WellPlayer;

uses
  Forms, SysUtils, Windows,
  UForm_Configuracao in '..\src\UForm_Configuracao.pas' {Form_Configuracao},
  UFuncoes in '..\src\UFuncoes.pas',
  UForm_Player in '..\src\UForm_Player.pas' {Form_Player},
  UHDDInfo in '..\SRC\UHDDInfo.pas',
  ZTO.Crypt.Utilities in '..\SRC\Crypt\ZTO.Crypt.Utilities.pas',
  ZTO.Crypt.Types in '..\SRC\Crypt\ZTO.Crypt.Types.pas',
  ZTO.Crypt.Hashes.Haval in '..\SRC\Crypt\hashes\ZTO.Crypt.Hashes.Haval.pas',
  ZTO.Crypt.Hashes.Md4 in '..\SRC\Crypt\hashes\ZTO.Crypt.Hashes.Md4.pas',
  ZTO.Crypt.Hashes.Md5 in '..\SRC\Crypt\hashes\ZTO.Crypt.Hashes.Md5.pas',
  ZTO.Crypt.Hashes.Ripemd128 in '..\SRC\Crypt\hashes\ZTO.Crypt.Hashes.Ripemd128.pas',
  ZTO.Crypt.Hashes.Ripemd160 in '..\SRC\Crypt\hashes\ZTO.Crypt.Hashes.Ripemd160.pas',
  ZTO.Crypt.Hashes.Sha1 in '..\SRC\Crypt\hashes\ZTO.Crypt.Hashes.Sha1.pas',
  ZTO.Crypt.Hashes.Sha256 in '..\SRC\Crypt\hashes\ZTO.Crypt.Hashes.Sha256.pas',
  ZTO.Crypt.Hashes.Sha512 in '..\SRC\Crypt\hashes\ZTO.Crypt.Hashes.Sha512.pas',
  ZTO.Crypt.Hashes.tiger in '..\SRC\Crypt\hashes\ZTO.Crypt.Hashes.tiger.pas',
  ZTO.Crypt.Common in '..\SRC\Crypt\ZTO.Crypt.Common.pas',
  ZTO.Crypt.Consts in '..\SRC\Crypt\ZTO.Crypt.Consts.pas',
  ZTO.Crypt.Base64 in '..\SRC\Crypt\ZTO.Crypt.Base64.pas',
  ZTO.Crypt.Blockciphers in '..\SRC\Crypt\ZTO.Crypt.Blockciphers.pas';

{$R *.res}

begin
  try
    Application.Initialize;

    {$IFDEF VER200}
    if DebugHook = 0 then
    {$ENDIF}
      VerificarLicenca;

    Application.Title := 'Well Player';
    Application.CreateForm(TForm_Configuracao, Form_Configuracao);
    Application.Run;
  except
    on E: Exception do
    begin
      Application.MessageBox(PChar(E.Message),'Execução não autorizada',MB_ICONWARNING);
      Application.Terminate;
    end;
  end;
end.

