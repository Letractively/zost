program MPSDist;

uses
  Forms,
  uPrinc in 'uPrinc.pas' {frmPrinc},
  uFuncoes in 'uFuncoes.pas';

{$R *.res}

begin
  Application.Initialize;
  Funcoes  := TFuncoes.Create;
  Funcoes.LerIniFile;
  frmPrinc := TfrmPrinc.Create(Application);
  frmPrinc.AddSysTrayIcon;
  frmPrinc.ConectarFTP;
  Application.Run;
  while not Application.Terminated do
    Application.HandleMessage;
  frmPrinc.SalvarLog;
  frmPrinc.DeleteSysTrayIcon;
end.
