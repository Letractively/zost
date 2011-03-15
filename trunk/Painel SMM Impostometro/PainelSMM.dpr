program PainelSMM;

uses
  Forms,
  UConfiguracoes1 in 'UConfiguracoes1.pas' {FRConfiguracoesGerais},
  synafpc in 'Lib\synafpc.pas',
  synaser in 'Lib\synaser.pas',
  synautil in 'Lib\synautil.pas',
  UGetURLResponse in 'Lib\UGetURLResponse.pas',
  USendStringToComPort in 'Lib\USendStringToComPort.pas',
  NotifyIcon in 'NotifyIcon.pas',
  HttpProt in 'Lib\HttpProt.pas',
  IcsNtlmMsgs in 'Lib\IcsNtlmMsgs.pas',
  IcsDES in 'Lib\IcsDES.pas',
  IcsMD4 in 'Lib\IcsMD4.pas',
  MimeUtil in 'Lib\MimeUtil.pas',
  IcsUrl in 'Lib\IcsUrl.pas',
  WSocket in 'Lib\WSocket.pas',
  WSockBuf in 'Lib\WSockBuf.pas',
  IcsLogger in 'Lib\IcsLogger.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.ShowMainForm := False;
  Application.Title := 'Painel SMM versão 2.0';
  Application.CreateForm(TFRConfiguracoesGerais, FRConfiguracoesGerais);
  Application.Run;
end.
