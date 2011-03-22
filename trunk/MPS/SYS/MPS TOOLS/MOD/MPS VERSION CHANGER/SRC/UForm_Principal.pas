unit UForm_Principal;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ComCtrls, StdCtrls, ExtCtrls, ActnList, Buttons, ImgList, Tabs,
  DockTabSet;

type
  TForm_Principal = class(TForm)
    ListView_Arquivos: TListView;
    GroupBox_Path: TGroupBox;
    Button_UsarAtual: TButton;
    Button_Pesquisar: TButton;
    Edit_Path: TEdit;
    ActionList_Principal: TActionList;
    Action_UsarAtual: TAction;
    Action_BuscarDiretorio: TAction;
    GroupBox_Arquivo: TGroupBox;
    GroupBox_Produto: TGroupBox;
    UpDown_FileMajor: TUpDown;
    LabeledEdit_FileMajor: TLabeledEdit;
    LabeledEdit_FileMinor: TLabeledEdit;
    UpDown_FileMinor: TUpDown;
    LabeledEdit_FileRelease: TLabeledEdit;
    UpDown_FileRelease: TUpDown;
    LabeledEdit_FileBuild: TLabeledEdit;
    UpDown_FileBuild: TUpDown;
    Panel_Subdiretorios: TPanel;
    CheckBox_IncludeSubDirs: TCheckBox;
    Action_ParaVersaoDoArquivo: TAction;
    Action_ParaVersaoDoProduto: TAction;
    BitBtn_ParaVersaoDoArquivo: TBitBtn;
    ImageList_Acoes: TImageList;
    BitBtn_ParaVersaoDoProduto: TBitBtn;
    LabeledEdit_ProductMajor: TLabeledEdit;
    UpDown_ProductMajor: TUpDown;
    LabeledEdit_ProductMinor: TLabeledEdit;
    UpDown_ProductMinor: TUpDown;
    LabeledEdit_ProductRelease: TLabeledEdit;
    UpDown_ProductRelease: TUpDown;
    LabeledEdit_ProductBuild: TLabeledEdit;
    UpDown_ProductBuild: TUpDown;
    CheckBox_VersaoDoArquivo: TCheckBox;
    CheckBox_VersaoDoProduto: TCheckBox;
    Action_ProductVersion: TAction;
    Action_FileVersion: TAction;
    StatusBar_Principal: TStatusBar;
    BitBtn_AplicarVersao: TBitBtn;
    Action_AplicarVersao: TAction;
    CheckBox_Todos: TCheckBox;
    Action_Todos: TAction;
    Action_Exe: TAction;
    Action_Dll: TAction;
    Action_Bpl: TAction;
    CheckBox_Exe: TCheckBox;
    CheckBox_Dll: TCheckBox;
    CheckBox_Bpl: TCheckBox;
    ProgressBar_Andamento: TProgressBar;
    GroupBox_Simples: TGroupBox;
    GroupBox_Data: TGroupBox;
    RadioButton_VersionamentoSimples: TRadioButton;
    RadioButton_VersionamentoPorData: TRadioButton;
    GroupBox_ArquivoData: TGroupBox;
    LabeledEdit_FileDateMajor: TLabeledEdit;
    LabeledEdit_FileDateMinor: TLabeledEdit;
    LabeledEdit_FileDateRelease: TLabeledEdit;
    LabeledEdit_FileDateBuild: TLabeledEdit;
    CheckBox_VersaoDoArquivoData: TCheckBox;
    GroupBox_ProdutoData: TGroupBox;
    LabeledEdit_ProductDateMajor: TLabeledEdit;
    LabeledEdit_ProductDateMinor: TLabeledEdit;
    LabeledEdit_ProductDateRelease: TLabeledEdit;
    LabeledEdit_ProductDateBuild: TLabeledEdit;
    CheckBox_VersaoDoProdutoData: TCheckBox;
    BitBtn_ParaArquivo: TBitBtn;
    BitBtn_ParaProduto: TBitBtn;
    DockTabSet_Seletor: TDockTabSet;
    Action_TipoDeVersionamento: TAction;
    Action_FileVersionDate: TAction;
    Action_ProductVersionDate: TAction;
    Action_ParaVersaoDoArquivoDate: TAction;
    Action_ParaVersaoDoProdutoDate: TAction;
    procedure FormCreate(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure CheckBox_IncludeSubDirsClick(Sender: TObject);
    procedure Action_UsarAtualExecute(Sender: TObject);
    procedure Action_FileVersionExecute(Sender: TObject);
    procedure Action_ProductVersionExecute(Sender: TObject);
    procedure ActionList_PrincipalUpdate(Action: TBasicAction; var Handled: Boolean);
    procedure Action_ParaVersaoDoArquivoExecute(Sender: TObject);
    procedure Action_ParaVersaoDoProdutoExecute(Sender: TObject);
    procedure ListView_ArquivosChange(Sender: TObject; Item: TListItem; Change: TItemChange);
    procedure Action_AplicarVersaoExecute(Sender: TObject);
    procedure Action_TodosExecute(Sender: TObject);
    procedure Action_ExeExecute(Sender: TObject);
    procedure Action_DllExecute(Sender: TObject);
    procedure Action_BplExecute(Sender: TObject);
    procedure DockTabSet_SeletorChange(Sender: TObject; NewTab: Integer;
      var AllowChange: Boolean);
    procedure Action_BuscarDiretorioExecute(Sender: TObject);
    procedure Edit_PathChange(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure Action_TipoDeVersionamentoExecute(Sender: TObject);
    procedure Action_FileVersionDateExecute(Sender: TObject);
    procedure Action_ProductVersionDateExecute(Sender: TObject);
    procedure Action_ParaVersaoDoArquivoDateExecute(Sender: TObject);
    procedure Action_ParaVersaoDoProdutoDateExecute(Sender: TObject);
  private
    { Private declarations }
    FCurrentDir: TFileName;
    OriginalLVWndProc: TWndMethod;
    procedure CustomizedLVWndProc(var Message: TMessage);
    procedure PreencherLista(aTabIndex: Byte);
    procedure SumarioDaLista(aTabIndex: Byte);
    procedure CarregarConfiguracoes;
    procedure AplicarVersao;
    function ItensChecados: Cardinal;
    function AddEndSlash(const aPath: TFileName): String;
  public
    { Public declarations }
  end;

var
  Form_Principal: TForm_Principal;

implementation

uses UFuncoes
   , UClasses
   , IniFiles;

{$R *.dfm}

{ Variáveis locais par uso dentro da função de callback }
var
  ListView: TListView;
  CurrentDir: TFileName;

function PFCallBackPostCompiled(const aSearchRec: TSearchRec; const aIsDirectory: Boolean): Boolean;
var
  RelativePath: TFileName;
begin
  Result := True; { Um dia, retornar false indica parar a recursividade, mas como fazer isso? }

  if (UpperCase(ExpandFileName(aSearchRec.Name)) <> UpperCase(Application.ExeName)) and (not aIsDirectory) then
    with ListView.Items.Add do
    begin
      Caption := aSearchRec.Name;
      RelativePath := ExtractFilePath(ExtractRelativePath(CurrentDir + '\',ExpandFileName(aSearchRec.Name)));
      RelativePath := Copy(RelativePath,1,Length(RelativePath)-1);

      SubItems.Add('\' + RelativePath);
      SubItems.Add(TFileInformation.GetInfo(ExpandFileName(aSearchRec.Name),'FULLFILEVERSION').AsShortString);
      SubItems.Add(TFileInformation.GetInfo(ExpandFileName(aSearchRec.Name),'FULLPRODUCTVERSION').AsShortString);
    end;
end;

function PFCallBackPreCompiled(const aSearchRec: TSearchRec; const aIsDirectory: Boolean): Boolean;
{ ---------------------------------------------------------------------------- }
procedure GetVersions(const aDofFile: TFileName; var aFileVersion, aProductVersion: ShortString);
begin
  with TIniFile.Create(aDofFile) do
    try
      aFileVersion := ReadString('Version Info Keys','FileVersion','0.0.0.0');
      aProductVersion := ReadString('Version Info Keys','ProductVersion','0.0.0.0');
    finally
      Free;
    end;
end;
{ ---------------------------------------------------------------------------- }
var
  RelativePath: TFileName;
  FV, PV: ShortString;
begin
  Result := True; { Um dia, retornar false indica parar a recursividade, mas como fazer isso? }

  if (UpperCase(ExpandFileName(aSearchRec.Name)) <> UpperCase(Application.ExeName)) and (not aIsDirectory) then
    with ListView.Items.Add do
    begin
      Caption := aSearchRec.Name;
      RelativePath := ExtractFilePath(ExtractRelativePath(CurrentDir + '\',ExpandFileName(aSearchRec.Name)));
      RelativePath := Copy(RelativePath,1,Length(RelativePath)-1);
      SubItems.Add('\' + RelativePath);

      GetVersions(ExpandFileName(aSearchRec.Name),FV,PV);
      SubItems.Add(FV);
      SubItems.Add(PV);
    end;
end;

procedure TForm_Principal.ActionList_PrincipalUpdate(Action: TBasicAction; var Handled: Boolean);
begin
  { Estados gerais devem ser configurados aqui, pois este evento é chamado
  sempre que algo muda }
  Action_ParaVersaoDoArquivo.Enabled := Action_ProductVersion.Checked and Action_FileVersion.Checked;
  Action_ParaVersaoDoProduto.Enabled := Action_ParaVersaoDoArquivo.Enabled;

  Action_ParaVersaoDoArquivoDate.Enabled := Action_ProductVersionDate.Checked and Action_FileVersionDate.Checked;
  Action_ParaVersaoDoProdutoDate.Enabled := Action_ParaVersaoDoArquivoDate.Enabled;


  if RadioButton_VersionamentoSimples.Checked then
    Action_AplicarVersao.Enabled := (ItensChecados > 0) and (Action_ProductVersion.Checked or Action_FileVersion.Checked)
  else if RadioButton_VersionamentoPorData.Checked then
    Action_AplicarVersao.Enabled := (ItensChecados > 0) and (Action_ProductVersionDate.Checked or Action_FileVersionDate.Checked);

  Handled := True;
end;

procedure TForm_Principal.Action_AplicarVersaoExecute(Sender: TObject);
begin
  AplicarVersao;
end;

procedure TForm_Principal.Action_BplExecute(Sender: TObject);
var
  i: Cardinal;
begin
  if ListView_Arquivos.Items.Count > 0 then
  begin
    for i := 0 to Pred(ListView_Arquivos.Items.Count) do
      if Pos('.BPL',UpperCase(ListView_Arquivos.Items[i].Caption)) > 0 then
        ListView_Arquivos.Items[i].Checked := True;

    for i := 0 to Pred(ListView_Arquivos.Items.Count) do
      if Pos('.BPL',UpperCase(ListView_Arquivos.Items[i].Caption)) > 0 then
        ListView_Arquivos.Items[i].Checked := Action_Bpl.Checked;
  end;
  Action_Todos.Checked := Action_Exe.Checked and Action_Dll.Checked and Action_Bpl.Checked;
end;

procedure TForm_Principal.Action_BuscarDiretorioExecute(Sender: TObject);
var
  Selection: String;
begin
  if SHBrowseForObject(Self,'Selecione um diretório','Selecione o diretório a partir do qual a pesquisa por arquivos deve ser realizada. Caso o checkbox "Incluir subdiretórios" esteja marcado, a pesquisa será recursiva tendo como diretório raiz o diretório selecionado',Selection) then
  begin
    Edit_Path.Text := Selection;
    PreencherLista(DockTabSet_Seletor.TabIndex);
  end;
end;

procedure TForm_Principal.Action_DllExecute(Sender: TObject);
var
  i: Cardinal;
begin
  if ListView_Arquivos.Items.Count > 0 then
  begin
    for i := 0 to Pred(ListView_Arquivos.Items.Count) do
      if Pos('.DLL',UpperCase(ListView_Arquivos.Items[i].Caption)) > 0 then
        ListView_Arquivos.Items[i].Checked := True;

    for i := 0 to Pred(ListView_Arquivos.Items.Count) do
      if Pos('.DLL',UpperCase(ListView_Arquivos.Items[i].Caption)) > 0 then
        ListView_Arquivos.Items[i].Checked := Action_Dll.Checked;
  end;
  Action_Todos.Checked := Action_Exe.Checked and Action_Dll.Checked and Action_Bpl.Checked;
end;

procedure TForm_Principal.Action_ExeExecute(Sender: TObject);
var
  i: Cardinal;
begin
  if ListView_Arquivos.Items.Count > 0 then
  begin
    for i := 0 to Pred(ListView_Arquivos.Items.Count) do
      if Pos('.EXE',UpperCase(ListView_Arquivos.Items[i].Caption)) > 0 then
        ListView_Arquivos.Items[i].Checked := True;

    for i := 0 to Pred(ListView_Arquivos.Items.Count) do
      if Pos('.EXE',UpperCase(ListView_Arquivos.Items[i].Caption)) > 0 then
        ListView_Arquivos.Items[i].Checked := Action_Exe.Checked;
  end;
  Action_Todos.Checked := Action_Exe.Checked and Action_Dll.Checked and Action_Bpl.Checked;
end;

procedure TForm_Principal.Action_FileVersionDateExecute(Sender: TObject);
var
  i: Byte;
begin
  for i := 0 to Pred(GroupBox_ArquivoData.ControlCount) do
    if GroupBox_ArquivoData.Controls[i] <> CheckBox_VersaoDoArquivoData then
      GroupBox_ArquivoData.Controls[i].Enabled := Action_FileVersionDate.Checked;
end;

procedure TForm_Principal.Action_FileVersionExecute(Sender: TObject);
var
  i: Byte;
begin
  for i := 0 to Pred(GroupBox_Arquivo.ControlCount) do
    if GroupBox_Arquivo.Controls[i] <> CheckBox_VersaoDoArquivo then
      GroupBox_Arquivo.Controls[i].Enabled := Action_FileVersion.Checked;
end;

procedure TForm_Principal.Action_ParaVersaoDoArquivoDateExecute(Sender: TObject);
begin
  LabeledEdit_FileDateMajor.Text := LabeledEdit_ProductDateMajor.Text;
  LabeledEdit_FileDateMinor.Text := LabeledEdit_ProductDateMinor.Text;
  LabeledEdit_FileDateRelease.Text := LabeledEdit_ProductDateRelease.Text;
  LabeledEdit_FileDateBuild.Text := LabeledEdit_ProductDateBuild.Text;
end;

procedure TForm_Principal.Action_ParaVersaoDoArquivoExecute(Sender: TObject);
begin
  LabeledEdit_FileMajor.Text := LabeledEdit_ProductMajor.Text;
  LabeledEdit_FileMinor.Text := LabeledEdit_ProductMinor.Text;
  LabeledEdit_FileRelease.Text := LabeledEdit_ProductRelease.Text;
  LabeledEdit_FileBuild.Text := LabeledEdit_ProductBuild.Text;
end;

procedure TForm_Principal.Action_ParaVersaoDoProdutoDateExecute(Sender: TObject);
begin
  LabeledEdit_ProductDateMajor.Text := LabeledEdit_FileDateMajor.Text;
  LabeledEdit_ProductDateMinor.Text := LabeledEdit_FileDateMinor.Text;
  LabeledEdit_ProductDateRelease.Text := LabeledEdit_FileDateRelease.Text;
  LabeledEdit_ProductDateBuild.Text := LabeledEdit_FileDateBuild.Text;
end;

procedure TForm_Principal.Action_ParaVersaoDoProdutoExecute(Sender: TObject);
begin
  LabeledEdit_ProductMajor.Text := LabeledEdit_FileMajor.Text;
  LabeledEdit_ProductMinor.Text := LabeledEdit_FileMinor.Text;
  LabeledEdit_ProductRelease.Text := LabeledEdit_FileRelease.Text;
  LabeledEdit_ProductBuild.Text := LabeledEdit_FileBuild.Text;
end;

procedure TForm_Principal.Action_ProductVersionDateExecute(Sender: TObject);
var
  i: Byte;
begin
  for i := 0 to Pred(GroupBox_ProdutoData.ControlCount) do
    if GroupBox_ProdutoData.Controls[i] <> CheckBox_VersaoDoProdutoData then
      GroupBox_ProdutoData.Controls[i].Enabled := Action_ProductVersionDate.Checked;
end;

procedure TForm_Principal.Action_ProductVersionExecute(Sender: TObject);
var
  i: Byte;
begin
  for i := 0 to Pred(GroupBox_Produto.ControlCount) do
    if GroupBox_Produto.Controls[i] <> CheckBox_VersaoDoProduto then
      GroupBox_Produto.Controls[i].Enabled := Action_ProductVersion.Checked;
end;

procedure TForm_Principal.Action_TipoDeVersionamentoExecute(Sender: TObject);
begin
  GroupBox_Simples.Enabled := RadioButton_VersionamentoSimples.Checked;
  GroupBox_Data.Enabled := RadioButton_VersionamentoPorData.Checked;
end;

procedure TForm_Principal.Action_TodosExecute(Sender: TObject);
var
  i: Cardinal;
begin
  if ListView_Arquivos.Items.Count > 0 then
  begin
    for i := 0 to Pred(ListView_Arquivos.Items.Count) do
      ListView_Arquivos.Items[i].Checked := True;

    for i := 0 to Pred(ListView_Arquivos.Items.Count) do
      ListView_Arquivos.Items[i].Checked := Action_Todos.Checked;
  end;
  Action_Exe.Checked := Action_Todos.Checked;
  Action_Dll.Checked := Action_Todos.Checked;
  Action_Bpl.Checked := Action_Todos.Checked;
end;

procedure TForm_Principal.Action_UsarAtualExecute(Sender: TObject);
begin
  Edit_Path.Text := FCurrentDir;
  PreencherLista(DockTabSet_Seletor.TabIndex)
end;

function TForm_Principal.AddEndSlash(const aPath: TFileName): ShortString;
begin
  Result := aPath;

  if (Length(aPath) > 0) and (aPath[Length(aPath)] <> '\') then
    Result := Result + '\';

end;

procedure TForm_Principal.AplicarVersao;
{ ---------------------------------------------------------------------------- }
procedure SetVersion(const aDofFile: TFileName; const aFileVersion, aProductVersion: ShortString; aSetFileVersion, aSetProductVersion: Boolean);
begin
  with TIniFile.Create(aDofFile) do
    try
      if aSetFileVersion then
        WriteString('Version Info Keys','FileVersion',aFileVersion);

      if aSetProductVersion then
        WriteString('Version Info Keys','ProductVersion',aProductVersion);
    finally
      Free;
    end;
end;

function GetFormatedValue(const aFormat: ShortString; const aDateTime: TDateTime): ShortString;
begin
  Result := FormatDateTime(aFormat,aDateTime);
end;
{ ---------------------------------------------------------------------------- }
var
  i: Cardinal;
  FileName: ShortString;
  Agora: TDateTime;
begin
  try
    Agora := Now;
    Action_AplicarVersao.Enabled := False;
    GroupBox_Arquivo.Enabled := False;
    GroupBox_Produto.Enabled := False;
    ProgressBar_Andamento.Max := ItensChecados;
    ProgressBar_Andamento.Position := 0;
    ProgressBar_Andamento.Step := 1;
    Screen.Cursor := crHourGlass;

    for i := 0 to Pred(ListView_Arquivos.Items.Count) do
    begin
      if ListView_Arquivos.Items[i].Checked then
      begin
        FileName := Edit_Path.Text + AddEndSlash(ListView_Arquivos.Items[i].SubItems[0]) + ListView_Arquivos.Items[i].Caption;

        case DockTabSet_Seletor.TabIndex of
          0: begin
            if RadioButton_VersionamentoSimples.Checked then
              TFileInformation.SetVersion(FileName
                                         ,StrToIntDef(LabeledEdit_FileMajor.Text,0)
                                         ,StrToIntDef(LabeledEdit_FileMinor.Text,0)
                                         ,StrToIntDef(LabeledEdit_FileRelease.Text,0)
                                         ,StrToIntDef(LabeledEdit_FileBuild.Text,0)
                                         ,StrToIntDef(LabeledEdit_ProductMajor.Text,0)
                                         ,StrToIntDef(LabeledEdit_ProductMinor.Text,0)
                                         ,StrToIntDef(LabeledEdit_ProductRelease.Text,0)
                                         ,StrToIntDef(LabeledEdit_ProductBuild.Text,0)
                                         ,CheckBox_VersaoDoArquivo.Checked
                                         ,CheckBox_VersaoDoProduto.Checked)
            else if RadioButton_VersionamentoPorData.Checked then
              TFileInformation.SetVersion(FileName
                                         ,StrToIntDef(GetFormatedValue(LabeledEdit_FileDateMajor.Text,Agora),0)
                                         ,StrToIntDef(GetFormatedValue(LabeledEdit_FileDateMinor.Text,Agora),0)
                                         ,StrToIntDef(GetFormatedValue(LabeledEdit_FileDateRelease.Text,Agora),0)
                                         ,StrToIntDef(GetFormatedValue(LabeledEdit_FileDateBuild.Text,Agora),0)
                                         ,StrToIntDef(GetFormatedValue(LabeledEdit_ProductDateMajor.Text,Agora),0)
                                         ,StrToIntDef(GetFormatedValue(LabeledEdit_ProductDateMinor.Text,Agora),0)
                                         ,StrToIntDef(GetFormatedValue(LabeledEdit_ProductDateRelease.Text,Agora),0)
                                         ,StrToIntDef(GetFormatedValue(LabeledEdit_ProductDateBuild.Text,Agora),0)
                                         ,CheckBox_VersaoDoArquivoData.Checked
                                         ,CheckBox_VersaoDoProdutoData.Checked)
          end;
          1: begin
            if RadioButton_VersionamentoSimples.Checked then
              SetVersion(FileName
                        ,LabeledEdit_FileMajor.Text + '.' + LabeledEdit_FileMinor.Text + '.' + LabeledEdit_FileRelease.Text + '.' + LabeledEdit_FileBuild.Text
                        ,LabeledEdit_ProductMajor.Text + '.' + LabeledEdit_ProductMinor.Text + '.' + LabeledEdit_ProductRelease.Text + '.' + LabeledEdit_ProductBuild.Text
                        ,CheckBox_VersaoDoArquivo.Checked
                        ,CheckBox_VersaoDoProduto.Checked)
            else if RadioButton_VersionamentoPorData.Checked then
              SetVersion(FileName
                        ,GetFormatedValue(LabeledEdit_FileDateMajor.Text,Agora) + '.' + GetFormatedValue(LabeledEdit_FileDateMinor.Text,Agora) + '.' + GetFormatedValue(LabeledEdit_FileDateRelease.Text,Agora) + '.' + GetFormatedValue(LabeledEdit_FileDateBuild.Text,Agora)
                        ,GetFormatedValue(LabeledEdit_ProductDateMajor.Text,Agora) + '.' + GetFormatedValue(LabeledEdit_ProductDateMinor.Text,Agora) + '.' + GetFormatedValue(LabeledEdit_ProductDateRelease.Text,Agora) + '.' + GetFormatedValue(LabeledEdit_ProductDateBuild.Text,Agora)
                        ,CheckBox_VersaoDoArquivoData.Checked
                        ,CheckBox_VersaoDoProdutoData.Checked)
          end;
        end;
        ProgressBar_Andamento.StepIt;
      end;
    end;
  finally
    PreencherLista(DockTabSet_Seletor.TabIndex);

    GroupBox_Produto.Enabled := True;
    GroupBox_Arquivo.Enabled := True;
    Action_AplicarVersao.Enabled := True;
    Screen.Cursor := crDefault;
  end;
end;

procedure TForm_Principal.CarregarConfiguracoes;
begin
  FCurrentDir := GetCurrentDir;
  Edit_Path.Text := FCurrentDir;
  Action_FileVersion.Checked := not True;
  Action_ProductVersion.Checked := not False;
  Action_FileVersion.Execute;
  Action_ProductVersion.Execute;

  { Usadas pela função de callback }
  CurrentDir := FCurrentDir;
  listView := ListView_Arquivos;

  with TIniFile.Create(FCurrentDir + '\' + ChangeFileExt(ExtractFileName(Application.ExeName),'.ini')) do
    try
      Edit_Path.Text := ReadString('CONFIGURACOES','EXEDIR',FCurrentDir);
      CheckBox_IncludeSubDirs.Checked := ReadBool('CONFIGURACOES','RECURSIVE',False)
    finally
      Free;
    end;
end;

procedure TForm_Principal.CheckBox_IncludeSubDirsClick(Sender: TObject);
begin
  PreencherLista(DockTabSet_Seletor.TabIndex);
end;

procedure TForm_Principal.SumarioDaLista(aTabIndex: Byte);
var
  i, Checked: Cardinal;
  Texto: ShortString;
begin
  case aTabIndex of
    0: Texto := 'módulos';
    1: Texto := 'configuradores';
  end;

  StatusBar_Principal.Panels[1].Text := Format('%.0n ' + Texto + ' listados',[ListView_Arquivos.Items.Count/1]);

  Checked := 0;
  for i := 0 to Pred(ListView_Arquivos.Items.Count) do
    if ListView_Arquivos.Items[i].Checked then
      Inc(Checked);

  StatusBar_Principal.Panels[2].Text := Format('%.0n ' + Texto + ' selecionados',[Checked/1]);
end;

procedure TForm_Principal.CustomizedLVWndProc(var Message: TMessage);
const
	HDN_FIRST = -300;
    HDN_BEGINTRACKA = HDN_FIRST - 6;
    HDN_BEGINTRACKW = HDN_FIRST - 26;
//    HDN_ENDTRACKA = HDN_FIRST - 7;
//    HDN_ENDTRACKW = HDN_FIRST - 27;
//    HDN_TRACKA = HDN_FIRST - 8;
//    HDN_TRACKW = HDN_FIRST - 28;
begin
  if Message.Msg = WM_NOTIFY then
  begin
    case PNMHdr(Message.LParam).Code of
      HDN_BEGINTRACKW, HDN_BEGINTRACKA: begin
        Message.Result := 1;
        Exit;
      end;
    end
  end;

  OriginalLVWndProc(Message);
end;

procedure TForm_Principal.DockTabSet_SeletorChange(Sender: TObject; NewTab: Integer; var AllowChange: Boolean);
begin
//  CheckBox_Todos.Visible := NewTab = 0;
  CheckBox_Exe.Visible := NewTab = 0;
  CheckBox_Dll.Visible := NewTab = 0;
  CheckBox_Bpl.Visible := NewTab = 0;
  PreencherLista(NewTab);
  SumarioDaLista(NewTab);
end;

procedure TForm_Principal.Edit_PathChange(Sender: TObject);
begin
  CurrentDir := Edit_Path.Text;
end;

procedure TForm_Principal.FormCreate(Sender: TObject);
begin
  ListView_Arquivos.Columns[1].Width := ListView_Arquivos.ClientWidth -
                                        ListView_Arquivos.Columns[0].Width -
                                        ListView_Arquivos.Columns[2].Width -
                                        ListView_Arquivos.Columns[3].Width -
                                        GetSystemMetrics(SM_CXVSCROLL );

  OriginalLVWndProc := ListView_Arquivos.WindowProc;
  ListView_Arquivos.WindowProc := CustomizedLVWndProc;
  CarregarConfiguracoes;
end;

procedure TForm_Principal.FormDestroy(Sender: TObject);
begin
  with TIniFile.Create(FCurrentDir + '\' + ChangeFileExt(ExtractFileName(Application.ExeName),'.ini')) do
    try
      WriteString('CONFIGURACOES','EXEDIR',CurrentDir);
      WriteBool('CONFIGURACOES','RECURSIVE',CheckBox_IncludeSubDirs.Checked);
    finally
      Free;
    end;
end;

procedure TForm_Principal.FormShow(Sender: TObject);
begin
  PreencherLista(DockTabSet_Seletor.TabIndex);
end;

function TForm_Principal.ItensChecados: Cardinal;
var
  i: Cardinal;
begin
  Result := 0;
  if ListView_Arquivos.Items.Count > 0 then
    for i := 0 to Pred(ListView_Arquivos.Items.Count) do
      if ListView_Arquivos.Items[i].Checked then
        Inc(Result);
end;

procedure TForm_Principal.ListView_ArquivosChange(Sender: TObject; Item: TListItem; Change: TItemChange);
begin
  SumarioDaLista(DockTabSet_Seletor.TabIndex);
end;

procedure TForm_Principal.PreencherLista(aTabIndex: Byte);
begin
  ListView_Arquivos.Clear;
  try
    ListView_Arquivos.Items.BeginUpdate;

    case aTabIndex of
      0: begin
        ProcessFiles(Edit_Path.Text,'*.exe',PFCallBackPostCompiled,CheckBox_IncludeSubDirs.Checked);
        ProcessFiles(Edit_Path.Text,'*.dll',PFCallBackPostCompiled,CheckBox_IncludeSubDirs.Checked);
        ProcessFiles(Edit_Path.Text,'*.bpl',PFCallBackPostCompiled,CheckBox_IncludeSubDirs.Checked);
      end;
      1: begin
        ProcessFiles(Edit_Path.Text,'*.dof',PFCallBackPreCompiled,CheckBox_IncludeSubDirs.Checked);
      end;
    end;

    Action_Todos.Checked := False;
    Action_Exe.Checked := False;
    Action_Dll.Checked := False;
    Action_Bpl.Checked := False;

  finally
    ListView_Arquivos.Items.EndUpdate;
  end;



//  Action_Todos.Execute;
//  Action_Exe.Execute;
//  Action_Dll.Execute;
//  Action_Bpl.Execute;
end;

{
VS_VERSION_INFO VERSIONINFO
FILEVERSION     %MajorVer%,%MinorVer%,%MaintVer%,%SVNRevision%
PRODUCTVERSION  %MajorVer%,%MinorVer%,%MaintVer%,%SVNRevision%
FILEFLAGSMASK   VS_FFI_FILEFLAGSMASK
FILEFLAGS       %VerFileFlags%
#ifdef LINUX
FILEOS          VOS_UNKNOWN
#else
FILEOS          VOS_NT_WINDOWS32
#endif
FILETYPE        VFT_APP
FILESUBTYPE     VFT2_UNKNOWN
BEGIN
     BLOCK "StringFileInfo"
     BEGIN
         BLOCK "040904E4"
         BEGIN
             VALUE "CompanyName",         "Scooter Software\0"
             VALUE "FileDescription",     "%VerInfoProductName%\0"
             VALUE "FileVersion",         "%MajorVer%.%MinorVer%.%MaintVer%.%SVNRevision%\0"
             VALUE "LegalCopyright",      "Copyright © %Year% Scooter Software, Inc.\0"
             VALUE "LegalTrademarks",     "Beyond Compare ® is a registered trademark of Scooter Software, Inc.\0"
             VALUE "OriginalFilename",    "%VerInfoOriginalFilename%\0"
             VALUE "ProductName",         "%VerInfoProductName%\0"
             VALUE "ProductVersion",      "%MajorVer%.%MinorVer%\0"
             VALUE "Comments",            "Beyond Compare 3\0"
             VALUE "Subversion Revision", "%SVNRevision%\0"
             VALUE "CompileDate",         "%CompileDate%\0"
         END
     END
     BLOCK "VarFileInfo"
     BEGIN
         VALUE "Translation", 0x0409, 1252
     END
END


}
end.
