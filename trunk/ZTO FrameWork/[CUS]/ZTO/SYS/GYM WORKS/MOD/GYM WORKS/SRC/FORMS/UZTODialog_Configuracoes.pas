unit UZTODialog_Configuracoes;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, Mdl.Lib.ZTODialog_Base, ImgList, DBActns, ActnList, ExtCtrls,
  StdCtrls, CheckLst, CFEdit, ComCtrls, Mdl.Lib.Configuracoes;

type
  TAplicarConfiguracoes = (acNoObjeto,acDoObjeto);

  TZTODialog_Configuracoes = class(TZTODialog_Base)
    PageControl_ConfigurationCategories: TPageControl;
    TabSheet_DataBaseOptions: TTabSheet;
    LabelProtocolo: TLabel;
    LabelIsolationLevel: TLabel;
    LabeledEdit_DBHost: TLabeledEdit;
    LabeledEdit_DBPorta: TLabeledEdit;
    LabeledEdit_DBEsquema: TLabeledEdit;
    LabeledEdit_DBUsuario: TLabeledEdit;
    LabeledEdit_DBSenha: TLabeledEdit;
    ComboBox_Protocolo: TComboBox;
    ComboBox_IsolationLevel: TComboBox;
    TabSheet_LoginOptions: TTabSheet;
    Label_PasswordCipherAlgorithm: TLabel;
    LabeledEdit_TabelaDeUsuarios: TLabeledEdit;
    LabeledEdit_CampoChave: TLabeledEdit;
    LabeledEdit_CampoNomeReal: TLabeledEdit;
    LabeledEdit_CampoNomeDeUsuario: TLabeledEdit;
    LabeledEdit_CampoSenha: TLabeledEdit;
    ComboBox_AlgoritmoDeCriptografia: TComboBox;
    CheckBox_ExpandedLoginDialog: TCheckBox;
    TabSheet_PermissionOptions: TTabSheet;
    Label1: TLabel;
    TabSheet_OtherOptions: TTabSheet;
    PageControl_OtherOptions: TPageControl;
    TabSheet_GeneralBehaviour: TTabSheet;
    Label_EnterToTab: TLabel;
    CheckBox_UseBalloons: TCheckBox;
    CheckListBox_EnterToTab: TCheckListBox;
    CheckBox_UseENTERToSearch: TCheckBox;
    procedure ZTODialogCreate(Sender: TObject);
  private
    { Private declarations }
    FConfiguracoes: TConfiguracoes;
    procedure AplicarConfiguracoes(aAplicarConfiguracoes: TAplicarConfiguracoes);
    procedure PreencherComboProtocolos;
    procedure PreencherComboIsolamentoTransacional;
    procedure PreencherComboAlgoritmoDeCriptografia;
  public
    { Public declarations }
    class function CarregarConfiguracoes(aConfiguracoes: TConfiguracoes; aArquivo: TFileName): TModalResult; static;
  end;

implementation

{$R *.dfm}

uses TypInfo
   , ZConnection
   , ZDbcIntfs
   , ZTO.Win32.Rtl.Common.Classes
   , ZTO.Crypt.Types;

procedure TZTODialog_Configuracoes.ZTODialogCreate(Sender: TObject);
begin
  inherited;
  { Tabs que não devem aparecer para esta aplicação }
  TabSheet_PermissionOptions.TabVisible := False;
  TabSheet_OtherOptions.TabVisible := False;
  PreencherComboProtocolos;
  PreencherComboIsolamentoTransacional;
  PreencherComboAlgoritmoDeCriptografia;
end;

procedure TZTODialog_Configuracoes.PreencherComboProtocolos;
begin
  with TZConnection.Create(nil) do
    try
      GetProtocolNames(ComboBox_Protocolo.Items);
    finally
      Free;
    end;
end;

procedure TZTODialog_Configuracoes.PreencherComboIsolamentoTransacional;
var
	i: TZTransactIsolationLevel;
begin
  ComboBox_IsolationLevel.Clear;

  for i := Low(TZTransactIsolationLevel) to High(TZTransactIsolationLevel) do
   	ComboBox_IsolationLevel.Items.AddObject(GetEnumName(TypeInfo(TZTransactIsolationLevel),Ord(i)),TObject(i));
end;

procedure TZTODialog_Configuracoes.PreencherComboAlgoritmoDeCriptografia;
var
	i: THashAlgorithm;
begin
  ComboBox_AlgoritmoDeCriptografia.Clear;

  for i := Succ(Low(THashAlgorithm)) to High(THashAlgorithm) do
   	ComboBox_AlgoritmoDeCriptografia.Items.AddObject(GetEnumName(TypeInfo(THashAlgorithm),Ord(i)),TObject(i));
end;

procedure TZTODialog_Configuracoes.AplicarConfiguracoes(aAplicarConfiguracoes: TAplicarConfiguracoes);
begin
  case aAplicarConfiguracoes of
    acNoObjeto: begin
      FConfiguracoes.DBProtocolo := ComboBox_Protocolo.Text;
      FConfiguracoes.DBIsolamentoTransacional := TZTransactIsolationLevel(ComboBox_IsolationLevel.Items.Objects[ComboBox_IsolationLevel.ItemIndex]);
      FConfiguracoes.DBHost := LabeledEdit_DBHost.Text;
      FConfiguracoes.DBPorta := StrToInt(LabeledEdit_DBPorta.Text);
      FConfiguracoes.DBEsquema := LabeledEdit_DBEsquema.Text;
      FConfiguracoes.DBUsuario := LabeledEdit_DBUsuario.Text;
      FConfiguracoes.DBSenha := LabeledEdit_DBSenha.Text;
      FConfiguracoes.TabelaDeUsuarios := LabeledEdit_TabelaDeUsuarios.Text;
      FConfiguracoes.CampoNomeReal := LabeledEdit_CampoNomeReal.Text;
      FConfiguracoes.CampoSenha := LabeledEdit_CampoSenha.Text;
      FConfiguracoes.CampoChave := LabeledEdit_CampoChave.Text;
      FConfiguracoes.CampoNomeDeUsuario := LabeledEdit_CampoNomeDeUsuario.Text;
      FConfiguracoes.AlgoritmoDeCriptografia := THashAlgorithm(ComboBox_AlgoritmoDeCriptografia.Items.Objects[ComboBox_AlgoritmoDeCriptografia.ItemIndex]);
    end;
    acDoObjeto: begin
      ComboBox_Protocolo.ItemIndex := ComboBox_Protocolo.Items.IndexOf(FConfiguracoes.DBProtocolo);
      ComboBox_IsolationLevel.ItemIndex := ComboBox_IsolationLevel.Items.IndexOfObject(TObject(FConfiguracoes.DBIsolamentoTransacional));
      LabeledEdit_DBHost.Text := FConfiguracoes.DBHost;
      LabeledEdit_DBPorta.Text := IntToStr(FConfiguracoes.DBPorta);
      LabeledEdit_DBEsquema.Text := FConfiguracoes.DBEsquema;
      LabeledEdit_DBUsuario.Text := FConfiguracoes.DBUsuario;
      LabeledEdit_DBSenha.Text := FConfiguracoes.DBSenha;
      LabeledEdit_TabelaDeUsuarios.Text := FConfiguracoes.TabelaDeUsuarios;
      LabeledEdit_CampoNomeReal.Text := FConfiguracoes.CampoNomeReal;
      LabeledEdit_CampoSenha.Text := FConfiguracoes.CampoSenha;
      LabeledEdit_CampoChave.Text := FConfiguracoes.CampoChave;
      LabeledEdit_CampoNomeDeUsuario.Text := FConfiguracoes.CampoNomeDeUsuario;
      ComboBox_AlgoritmoDeCriptografia.ItemIndex := ComboBox_AlgoritmoDeCriptografia.Items.IndexOfObject(TObject(FConfiguracoes.AlgoritmoDeCriptografia));
    end;
  end;
end;

class function TZTODialog_Configuracoes.CarregarConfiguracoes(aConfiguracoes: TConfiguracoes; aArquivo: TFileName): TModalResult;
var
  ZTODialog_Configuracoes: TZTODialog_Configuracoes;
begin
  Result := mrNone;
  ZTODialog_Configuracoes := nil;

  aConfiguracoes.LoadFromBinaryFile(aArquivo);

  if (not aConfiguracoes.BancoConfigurado) or (not aConfiguracoes.AcessoConfigurado) then
    try
      CreateDialog(nil
                  ,ZTODialog_Configuracoes
                  ,TZTODialog_Configuracoes
                  ,smNone
                  ,[]
                  ,''
                  ,[]
                  ,[]
                  ,sbNone
                  ,dtNone);

      { Abre a aba que tem configurações incorretas }
      if not aConfiguracoes.BancoConfigurado then
        ZTODialog_Configuracoes.PageControl_ConfigurationCategories.ActivePageIndex := 0
      else if not aConfiguracoes.AcessoConfigurado then
        ZTODialog_Configuracoes.PageControl_ConfigurationCategories.ActivePageIndex := 1;

      ZTODialog_Configuracoes.FConfiguracoes := aConfiguracoes;

      ZTODialog_Configuracoes.AplicarConfiguracoes(acDoObjeto);

      Result := ZTODialog_Configuracoes.ShowModal;

      if Result = mrOk then
      begin
        ZTODialog_Configuracoes.AplicarConfiguracoes(acNoObjeto);
        aConfiguracoes.SaveToBinaryFile(aArquivo);
      end;

    finally
      ZTODialog_Configuracoes.Close;
      ZTODialog_Configuracoes := nil;
    end;
end;

end.
