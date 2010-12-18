program WellPlayer;

uses
  Forms,
  UForm_Configuracao in '..\src\UForm_Configuracao.pas' {Form_Configuracao},
  UFuncoes in '..\src\UFuncoes.pas',
  UForm_Player in '..\src\UForm_Player.pas' {Form_Player};

{$R *.res}

begin
  Application.Initialize;
  Application.Title := 'Well Player';
  Application.CreateForm(TForm_Configuracao, Form_Configuracao);
  Application.Run;
end.

