program ZTOFWTests;

uses
  Forms,
  UForm_Principal in '..\SRC\UForm_Principal.pas' {Form1},
  Unit3 in '..\SRC\Unit3.pas' {ZTODataModule3: TZTODataModule},
  Unit2 in '..\SRC\Unit2.pas' {ZTODialog2: TZTODialog};

{$R *.res}

begin
  Application.Initialize;
  {$IFNDEF VER180}Application.MainFormOnTaskbar := True{$ENDIF};
  Application.CreateForm(TForm1, Form1);
  Application.CreateForm(TZTODataModule3, ZTODataModule3);
  Application.Run;
end.
