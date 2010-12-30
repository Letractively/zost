unit UForm_Principal;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ComCtrls, ExtCtrls, UDataModule_Principal;

type
  TForm_Principal = class(TForm)
    ProgressBar_Documentos: TProgressBar;
    StatusBar_Principal: TStatusBar;
    PageControl_Principal: TPageControl;
    TabSheet_Processamento: TTabSheet;
    TabSheet_Configuracoes: TTabSheet;
    Memo_LogProcessamento: TMemo;
    Panel_ControlesProcessamento: TPanel;
    Button_IniciarProcessamento: TButton;
    Panel_ControlesConfiguracoes: TPanel;
    Button_SalvarConfiguracoes: TButton;
    ProgressBar_Threads: TProgressBar;
    Panel_Threads: TPanel;
    Panel_Records: TPanel;
    Label_Threads: TLabel;
    Label_Registros: TLabel;
    Shape1: TShape;
    Shape2: TShape;
    Label_Informacao: TLabel;
    Label_ThreadsPercent: TLabel;
    Label_RecordsPercent: TLabel;
    procedure Button_IniciarProcessamentoClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure FormShow(Sender: TObject);
  private
    { Private declarations }
    FDataModule: TDataModule_Principal;
  public
    { Public declarations }
  end;

var
  Form_Principal: TForm_Principal;

implementation

uses UConfigurations;

{$R *.dfm}

procedure TForm_Principal.Button_IniciarProcessamentoClick(Sender: TObject);
begin
  try
    FDataModule.IniciarProcessamento;
  finally

  end;
end;

procedure TForm_Principal.FormCreate(Sender: TObject);
begin
  FDataModule := TDataModule_Principal.Create(Self);
  
  if Configurations.PARAMETROSAPPNAME <> '' then
    Caption := Configurations.PARAMETROSAPPNAME + ' - ' + Caption;

  PageControl_Principal.Pages[1].TabVisible := Configurations.PARAMETROSSTANDALONE;
end;

procedure TForm_Principal.FormDestroy(Sender: TObject);
begin
  FDataModule.Free;
end;

procedure TForm_Principal.FormShow(Sender: TObject);
begin
  FDataModule.ProcessarLinhaDeComando;
end;

end.
