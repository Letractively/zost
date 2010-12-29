program LicGenerator;

uses
  Forms,
  UPrincipal in '..\..\SRC\LIC GENERATOR\UPrincipal.pas' {Form_Principal},
  ZTO.Crypt.Base64 in '..\..\SRC\Crypt\ZTO.Crypt.Base64.pas',
  ZTO.Crypt.Blockciphers in '..\..\SRC\Crypt\ZTO.Crypt.Blockciphers.pas',
  ZTO.Crypt.Common in '..\..\SRC\Crypt\ZTO.Crypt.Common.pas',
  ZTO.Crypt.Consts in '..\..\SRC\Crypt\ZTO.Crypt.Consts.pas',
  ZTO.Crypt.Types in '..\..\SRC\Crypt\ZTO.Crypt.Types.pas',
  ZTO.Crypt.Utilities in '..\..\SRC\Crypt\ZTO.Crypt.Utilities.pas',
  ZTO.Crypt.Hashes.Haval in '..\..\SRC\Crypt\hashes\ZTO.Crypt.Hashes.Haval.pas',
  ZTO.Crypt.Hashes.Md4 in '..\..\SRC\Crypt\hashes\ZTO.Crypt.Hashes.Md4.pas',
  ZTO.Crypt.Hashes.Md5 in '..\..\SRC\Crypt\hashes\ZTO.Crypt.Hashes.Md5.pas',
  ZTO.Crypt.Hashes.Ripemd128 in '..\..\SRC\Crypt\hashes\ZTO.Crypt.Hashes.Ripemd128.pas',
  ZTO.Crypt.Hashes.Ripemd160 in '..\..\SRC\Crypt\hashes\ZTO.Crypt.Hashes.Ripemd160.pas',
  ZTO.Crypt.Hashes.Sha1 in '..\..\SRC\Crypt\hashes\ZTO.Crypt.Hashes.Sha1.pas',
  ZTO.Crypt.Hashes.Sha256 in '..\..\SRC\Crypt\hashes\ZTO.Crypt.Hashes.Sha256.pas',
  ZTO.Crypt.Hashes.Sha512 in '..\..\SRC\Crypt\hashes\ZTO.Crypt.Hashes.Sha512.pas',
  ZTO.Crypt.Hashes.tiger in '..\..\SRC\Crypt\hashes\ZTO.Crypt.Hashes.tiger.pas',
  UHDDInfo in '..\..\SRC\UHDDInfo.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.Title := 'License Generator';
  Application.CreateForm(TForm_Principal, Form_Principal);
  Application.Run;
end.
