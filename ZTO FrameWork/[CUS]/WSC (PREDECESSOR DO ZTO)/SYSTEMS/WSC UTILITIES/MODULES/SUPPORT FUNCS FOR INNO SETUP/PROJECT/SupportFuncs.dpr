library SupportFuncs;

uses
  SysUtils,
  Classes,
  UCommonFuncs in '..\Source\UCommonFuncs.pas',
  USpecificFuncs in '..\Source\USpecificFuncs.pas';

{$R *.res}

exports
	ChangePassword, ChangeRootPassword, CompareVersions2, CompareVersions3,
	CompareVersions4, GetMySQLProtocolNames, BDOConfig, SYNCConfig;

begin
end.
