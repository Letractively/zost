{ TODO -oCARLOS FEITOZA -cCORREÇÃO : POR QUE CERTOS TIPOS DE ALTERAÇÃO NA PASTA DE MONITORAMENTO NÃO GERAM EVENTO DE MODIFICAÇÃO. CRIEI UMA PASTA DENTRO DA PASTA DE MONITORAMENTO. NAO DETECTOU. MOVI TODOS OS ARQUIVOS PARA DENTRO DESTA PASTA. NÃO DETECTOU }
unit UForm_Principal;

interface

uses
  Classes, Controls, Forms,
  ActnMenus, ToolWin, ActnMan, ActnCtrls, XPStyleActnCtrls, ActnList, ComCtrls,
  ExtCtrls, StdCtrls, Buttons, Messages, Grids, DBGrids, ZTO.Components.DataControls.ZTODBGrid, Mask,
  DBCtrls, UBalloonToolTip, Tabs, Graphics, Types;

type
  TForm_Principal = class(TForm)
    ActionMainMenuBar_Principal: TActionMainMenuBar;
    ActionManager_Principal: TActionManager;
    PageContro_Principal: TPageControl;
    TabSheet_Log: TTabSheet;
    Panel_Log: TPanel;
    BitBtn_SalvarELimparLog: TBitBtn;
    TabSheet_Sistemas: TTabSheet;
    Panel_Projetos: TPanel;
    Label_ProjetosInfo: TLabel;
    ZTODBGrid_Sistemas: TZTODBGrid;
    Panel_Sistemas: TPanel;
    Label_SIS_VA_NOME: TLabel;
    DBEdit_SIS_VA_NOME: TDBEdit;
    Label_SIS_VA_DIRETORIO: TLabel;
    DBEdit_SIS_VA_DIRETORIO: TDBEdit;
    Label_SIS_VA_DESCRICAO: TLabel;
    DBEdit_SIS_VA_DESCRICAO: TDBEdit;
    RichEdit_LogFTP: TRichEdit;
    SpeedButton_DiretorioDeMonitoramento: TSpeedButton;
    DBNavigator_Sistemas: TDBNavigator;
    BalloonToolTip_Principal: TBalloonToolTip;
    TabSheet_Arquivos: TTabSheet;
    Panel_Arquivos: TPanel;
    Label_Arquivos: TLabel;
    ZTODBGrid_ArquivosSistemas: TZTODBGrid;
    Panel_ArquivosInfo: TPanel;
    Panel_ArquivosCaminho: TPanel;
    DBText_CaminhoDoSistema: TDBText;
    TabSet_Arquivos: TTabSet;
    Panel_ArquivosLista: TPanel;
    ZTODBGrid_Arquivos: TZTODBGrid;
    DBNavigator_Arquivos: TDBNavigator;
    StatusBar_Arquivos: TStatusBar;
    Image_Green: TImage;
    Image_Red: TImage;
    Label_ClientCount: TLabel;
    TabSheet_Usuarios: TTabSheet;
    Panel_Usuarios: TPanel;
    Label_Usuarios: TLabel;
    Image_Yellow: TImage;
    Panel1: TPanel;
    Label_USU_VA_NOME: TLabel;
    Label_USU_VA_LOGIN: TLabel;
    Label_USU_VA_EMAIL: TLabel;
    DBEdit_USU_VA_NOME: TDBEdit;
    DBEdit_USU_VA_LOGIN: TDBEdit;
    DBEdit_USU_VA_EMAIL: TDBEdit;
    Panel_UsuariosDosSistemas: TPanel;
    ZTODBGrid_Usuarios: TZTODBGrid;
    ZTODBGrid_SistemasDosUsuarios: TZTODBGrid;
    Panel_UsuariosNavigators: TPanel;
    DBNavigator_Usuarios: TDBNavigator;
    DBEdit_USU_VA_SENHA: TDBEdit;
    Label_USU_VA_SENHA: TLabel;
    BitBtn_Adicionar: TBitBtn;
    BitBtn_Remover: TBitBtn;
    RichEdit_LogMonitoramento: TRichEdit;
    TabSet_Log: TTabSet;
    DBCheckBox_USU_BO_ADMINISTRADOR: TDBCheckBox;
    Panel_Exclusoes: TPanel;
    Panel_LegendasEConstantes: TPanel;
    RichEdit_Constantes: TRichEdit;
    ZTODBGrid_Exclusoes: TZTODBGrid;
    DBEdit_SIS_VA_CHAVEDEINSTALACAO: TDBEdit;
    Label_SIS_VA_CHAVEDEINSTALACAO: TLabel;
    DBNavigator_EXC_Exclusoes: TDBNavigator;
    StatusBar_Exclusoes: TStatusBar;
    Action_SalvarELimparLog: TAction;
    procedure FormShow(Sender: TObject);
    procedure DBNavigator_SistemasClick(Sender: TObject; Button: TNavigateBtn);
    procedure FormCreate(Sender: TObject);
    procedure TabSet_ArquivosChange(Sender: TObject; NewTab: Integer; var AllowChange: Boolean);
    procedure Button_1Click(Sender: TObject);
    procedure DBNavigator_UsuariosDosSistemasClick(Sender: TObject; Button: TNavigateBtn);
    procedure ZTODBGrid_SistemasDosUsuariosAfterMultiselect(aSender: TObject; aMultiSelectEventTrigger: TMultiSelectEventTrigger);
    procedure TabSet_LogChange(Sender: TObject; NewTab: Integer; var AllowChange: Boolean);
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
    procedure Action_SalvarELimparLogExecute(Sender: TObject);
  private
    { Private declarations }
    procedure DelayedAction;
    procedure DoDelayedAction(var Msg: TMessage);
  public
    { Public declarations }
  end;

var
  Form_Principal: TForm_Principal;

implementation

uses
  Windows, UDataModule_Principal, SysUtils;

{$R *.dfm}

procedure TForm_Principal.Action_SalvarELimparLogExecute(Sender: TObject);
var
  i: Cardinal;
  FileName: TFileName;
  RichEdit: TRichEdit;
begin
  if DataModule_Principal.SaveDialog_Log.Execute then
    with TStringList.Create do
      try
        RichEdit := nil;
        case TabSet_Log.TabIndex of
          0: begin
            FileName := ExtractFilePath(Application.ExeName) + 'AutoSaveMon.log';
            RichEdit := RichEdit_LogMonitoramento;
          end;
          1: begin
            FileName := ExtractFilePath(Application.ExeName) + 'AutoSaveFTP.log';
            RichEdit := RichEdit_LogFTP;
          end;
        end;

        { Carrega o log automático caso ele exista }
        if FileExists(FileName) then
          LoadFromFile(FileName);

        { Adiciona as linhas atuais do log }
        for i := 0 to Pred(RichEdit.Lines.Count) do
          Add(RichEdit.Lines[i]);

        SaveToFile(DataModule_Principal.SaveDialog_Log.FileName);
        RichEdit.Clear;
      finally
        Free;
      end;
end;

procedure TForm_Principal.Button_1Click(Sender: TObject);
begin
  DataModule_Principal.ARQUIVOS.Refresh;
end;

procedure TForm_Principal.ZTODBGrid_SistemasDosUsuariosAfterMultiselect(aSender: TObject; aMultiSelectEventTrigger: TMultiSelectEventTrigger);
begin
  DataModule_Principal.Action_SDU_Remover.Enabled := ZTODBGrid_SistemasDosUsuarios.SelectedRows.Count > 0;
end;

procedure TForm_Principal.DBNavigator_SistemasClick(Sender: TObject; Button: TNavigateBtn);
begin
  if Button in [nbInsert,nbEdit] then
    DBEdit_SIS_VA_NOME.SetFocus;
end;

procedure TForm_Principal.DBNavigator_UsuariosDosSistemasClick(Sender: TObject; Button: TNavigateBtn);
begin
  case Button of
    nbInsert: DataModule_Principal.Action_SDU_Adicionar.Execute;
    nbDelete: DataModule_Principal.Action_SDU_Remover.Execute;
  end;
end;

procedure TForm_Principal.DelayedAction;
begin
  SetTimer(Handle,1,1000,Classes.MakeObjectInstance(DoDelayedAction));
end;

procedure TForm_Principal.DoDelayedAction(var Msg: TMessage);
begin
  KillTimer(Handle,TWMTimer(Msg).TimerID);
  DataModule_Principal := TDataModule_Principal.Create(Self);
end;

procedure TForm_Principal.FormCloseQuery(Sender: TObject; var CanClose: Boolean);
begin
  CanClose := Application.MessageBox('Se você fechar o MPS Updater, os softwares da MPS não poderão ser automaticamente atualizados. Tem certeza?','Tem certeza?',MB_ICONQUESTION or MB_YESNO) = ID_YES;
end;

procedure TForm_Principal.FormCreate(Sender: TObject);
begin
  TabSheet_Sistemas.TabVisible := False;
  TabSheet_Arquivos.TabVisible := False;
  TabSheet_Usuarios.TabVisible := False;
  RichEdit_Constantes.Lines.LoadFromFile('.\Constantes.rtf');
  TLabel(DBText_CaminhoDoSistema).Layout := tlCenter; 
end;

procedure TForm_Principal.FormShow(Sender: TObject);
begin
  DelayedAction;
end;

procedure TForm_Principal.TabSet_ArquivosChange(Sender: TObject; NewTab: Integer; var AllowChange: Boolean);
begin
  Panel_ArquivosLista.Visible := NewTab = 0;
  Panel_Exclusoes.Visible := NewTab = 1;
  Panel_LegendasEConstantes.Visible := NewTab = 2;
end;

procedure TForm_Principal.TabSet_LogChange(Sender: TObject; NewTab: Integer; var AllowChange: Boolean);
begin
  case NewTab of
    0: begin
      RichEdit_LogMonitoramento.Show;
      RichEdit_LogFTP.Hide;
    end;
    1: begin
      RichEdit_LogMonitoramento.Hide;
      RichEdit_LogFTP.Show;
    end;
  end;
end;

end.
