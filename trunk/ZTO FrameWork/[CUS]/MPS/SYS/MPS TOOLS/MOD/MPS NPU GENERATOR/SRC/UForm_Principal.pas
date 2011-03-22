unit UForm_Principal;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ExtCtrls, Buttons;

type
  TForm_Principal = class(TForm)
    SpeedButton_GerarDigito: TSpeedButton;
    SpeedButton_Validar: TSpeedButton;
    SpeedButton_Formatar: TSpeedButton;
    SpeedButton_ObterDigitoVerificador: TSpeedButton;
    SpeedButton_RemoverDelimitadores: TSpeedButton;
    GroupBox_Parametros: TGroupBox;
    LabeledEdit_Sequencial: TLabeledEdit;
    LabeledEdit_Ano: TLabeledEdit;
    LabeledEdit_Justica: TLabeledEdit;
    LabeledEdit_Origem: TLabeledEdit;
    LabeledEdit_Tribunal: TLabeledEdit;
    LabeledEdit_NumProcesso: TLabeledEdit;
    procedure SpeedButton_ValidarClick(Sender: TObject);
    procedure SpeedButton_FormatarClick(Sender: TObject);
    procedure SpeedButton_GerarDigitoClick(Sender: TObject);
    procedure SpeedButton_ObterDigitoVerificadorClick(Sender: TObject);
    procedure SpeedButton_RemoverDelimitadoresClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure LabeledEdit_SequencialKeyPress(Sender: TObject; var Key: Char);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form_Principal: TForm_Principal;

implementation

uses UMPSNPU
   , IniFiles;

{$R *.dfm}

procedure TForm_Principal.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  with TIniFile.Create(ChangeFileExt(Application.ExeName,'.ini')) do
    try
      WriteString('NPU','NUMSEQUENCIAL',LabeledEdit_Sequencial.Text);
      WriteString('NPU','NUMANO',LabeledEdit_Ano.Text);
      WriteString('NPU','CODJUSTICA',LabeledEdit_Justica.Text);
      WriteString('NPU','TRIBUNAL',LabeledEdit_Tribunal.Text);
      WriteString('NPU','ORIGEM',LabeledEdit_Origem.Text);
    finally
      Free;
    end;
end;

procedure TForm_Principal.FormCreate(Sender: TObject);
begin
  with TIniFile.Create(ChangeFileExt(Application.ExeName,'.ini')) do
    try
      LabeledEdit_Sequencial.Text := ReadString('NPU','NUMSEQUENCIAL','1000000');
      LabeledEdit_Ano.Text := ReadString('NPU','NUMANO',FormatDateTime('yyyy',Now));
      LabeledEdit_Tribunal.Text := ReadString('NPU','TRIBUNAL','05');
      LabeledEdit_Justica.Text := ReadString('NPU','CODJUSTICA','4');
      LabeledEdit_Origem.Text := ReadString('NPU','ORIGEM','0000');
    finally
      Free;
    end;

  SpeedButton_GerarDigito.Click;
  SpeedButton_Formatar.Click;
end;

procedure TForm_Principal.LabeledEdit_SequencialKeyPress(Sender: TObject; var Key: Char);
begin
  if Key = #13 then
  begin
    SpeedButton_GerarDigito.Click;
    SpeedButton_Formatar.Click;
  end;
end;

procedure TForm_Principal.SpeedButton_FormatarClick(Sender: TObject);
begin
  LabeledEdit_NumProcesso.Text := FormatarProcessoCNJ(LabeledEdit_NumProcesso.Text);
end;

procedure TForm_Principal.SpeedButton_GerarDigitoClick(Sender: TObject);
var
  Resultado: ShortString;
begin
  Resultado := GerarDigitoVerificadorCNJValido(StrToIntDef(LabeledEdit_Sequencial.Text,0)
                                              ,StrToIntDef(LabeledEdit_Ano.Text,0)
                                              ,StrToIntDef(LabeledEdit_Justica.Text,0)
                                              ,StrToIntDef(LabeledEdit_Tribunal.Text,0)
                                              ,StrToIntDef(LabeledEdit_Origem.Text,0));

  LabeledEdit_NumProcesso.Text := Resultado;

  with TIniFile.Create(ChangeFileExt(Application.ExeName,'.ini')) do
    try
      WriteString('NPU','NUMSEQUENCIAL',LabeledEdit_Sequencial.Text);
      WriteString('NPU','NUMANO',LabeledEdit_Ano.Text);
      WriteString('NPU','CODJUSTICA',LabeledEdit_Justica.Text);
      WriteString('NPU','TRIBUNAL',LabeledEdit_Tribunal.Text);
      WriteString('NPU','ORIGEM',LabeledEdit_Origem.Text);
    finally
      Free;
    end;
end;

procedure TForm_Principal.SpeedButton_ObterDigitoVerificadorClick(Sender: TObject);
var
  Sequencial: Cardinal;
  DigitoVerificador, J, TR: Byte;
  Ano, Origem: Word;
begin
  NPUObterComponentes(LabeledEdit_NumProcesso.Text
                     ,Sequencial
                     ,DigitoVerificador
                     ,Ano
                     ,J
                     ,TR
                     ,Origem);

  MessageBox(Handle,PChar('Sequencial: ' + IntToStr(Sequencial) + #13#10 +
                          'DV: ' + IntToStr(DigitoVerificador) + #13#10 +
                          'Ano: ' + IntToStr(Ano) + #13#10 +
                          'Justiça: ' + IntToStr(J) + #13#10 +
                          'Tribunal: ' + IntToStr(TR) + #13#10 +
                          'Origem: ' + IntToStr(Origem)), 'Componentes do NPU',MB_ICONINFORMATION);
end;

procedure TForm_Principal.SpeedButton_RemoverDelimitadoresClick(Sender: TObject);
var
  Processo: String;
begin
  Processo := LabeledEdit_NumProcesso.Text;
  NPURemoverDelimitadores(Processo);
  LabeledEdit_NumProcesso.Text := Processo;
end;

procedure TForm_Principal.SpeedButton_ValidarClick(Sender: TObject);
var
  Resultado: ShortString;
begin
  Resultado := ValidarProcessoCNJ(LabeledEdit_NumProcesso.Text
                                 ,LabeledEdit_Ano.Text
                                 ,LabeledEdit_Justica.Text
                                 ,LabeledEdit_Tribunal.Text
                                 ,LabeledEdit_Origem.Text);
  if Resultado <> '' then
  begin
    MessageBox(Handle
              ,PChar('Valor digitado: ' + LabeledEdit_NumProcesso.Text + #13#10'Valor formatado: ' + Resultado)
              ,'Processo válido!', MB_ICONINFORMATION);
  end
  else
    MessageBox(Handle
              ,PChar('O processo informado (' + LabeledEdit_NumProcesso.Text +' ) não é válido!')
              ,'Processo inválido...'
              ,MB_ICONWARNING);
end;

end.
