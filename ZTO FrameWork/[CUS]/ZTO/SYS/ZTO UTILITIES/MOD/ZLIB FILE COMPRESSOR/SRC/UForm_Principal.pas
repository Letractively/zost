unit UForm_Principal;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ComCtrls, ZTO.Win32.Rtl.Sys.Types;

type
  TForm2 = class(TForm)
    OpenDialog_Abrir: TOpenDialog;
    Button_Comprimir: TButton;
    Button_Descomprimir: TButton;
    ProgressBar_Progresso: TProgressBar;
    procedure Button_ComprimirClick(Sender: TObject);
    procedure Button_DescomprimirClick(Sender: TObject);
  private
    { Private declarations }
    procedure DoZLibCompress(aSender: TObject);
    procedure DoZLibDecompress(aSender: TObject);
  public
    { Public declarations }
  end;

var
  Form2: TForm2;

implementation

{$R *.dfm}

uses ZLib
   , ZTO.Win32.Rtl.Common.Classes.Interposer
   , ZTO.Win32.Rtl.Common.FileUtils;

procedure TForm2.Button_ComprimirClick(Sender: TObject);
begin
  if OpenDialog_Abrir.Execute then
    try
      Button_Comprimir.Enabled := False;
      Button_Descomprimir.Enabled := False;

      SelfZLibCompressFile(OpenDialog_Abrir.FileName,DoZLibCompress);
      MessageBox(Handle,'Operação de compressão concluída','Pronto!',MB_ICONINFORMATION);
    finally
      Button_Comprimir.Enabled := True;
      Button_Descomprimir.Enabled := True;
    end;
end;

procedure TForm2.Button_DescomprimirClick(Sender: TObject);
begin
  if OpenDialog_Abrir.Execute then
    try
      Button_Comprimir.Enabled := False;
      Button_Descomprimir.Enabled := False;

      SelfZLibDecompressFile(OpenDialog_Abrir.FileName,DoZLibDecompress);
      MessageBox(Handle,'Operação de descompressão concluída','Pronto!',MB_ICONINFORMATION);
    finally
      Button_Comprimir.Enabled := True;
      Button_Descomprimir.Enabled := True;
    end;
end;

procedure TForm2.DoZLibDecompress(aSender: TObject);
begin
  case TDecompressionStream(aSender).Moment of
    znmBeforeProcess: begin
      ProgressBar_Progresso.Position := 0;
      ProgressBar_Progresso.Max := TDecompressionStream(aSender).FileSize;
      ProgressBar_Progresso.Step := 1;
      Application.ProcessMessages;
    end;
    znmInsideProcess: begin
      ProgressBar_Progresso.Position := TDecompressionStream(aSender).Position;
      Application.ProcessMessages;
    end;
  end;
end;

procedure TForm2.DoZLibCompress(aSender: TObject);
begin
  case TDecompressionStream(aSender).Moment of
    znmBeforeProcess: begin
      ProgressBar_Progresso.Position := 0;
      ProgressBar_Progresso.Max := TDecompressionStream(aSender).FileSize;
      ProgressBar_Progresso.Step := 1;
      Application.ProcessMessages;
    end;
    znmInsideProcess: begin
      ProgressBar_Progresso.Position := TCompressionStream(aSender).Position;
      Application.ProcessMessages;
    end;
  end;
end;

end.
