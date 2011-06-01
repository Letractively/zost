unit UForm_Principal;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ComCtrls, StdCtrls, ExtCtrls, ZTO.Components.WebApiWrappers.Twitter,
  UConfiguracoes, PngImage, OverbyteIcsHttpProt;

type
  TAplicarConfiguracoes = (acNoObjeto,acDoObjeto);

  TForm_Principal = class(TForm)
    PageControl_Principal: TPageControl;
    TabSheet_MensagensAutomaticas: TTabSheet;
    TabSheet_Configuracoes: TTabSheet;
    ListBox_ListaDeMensagens: TListBox;
    TabSheet_Sobre: TTabSheet;
    Button_CarregarMensagens: TButton;
    Button_AtivarAutoitter: TButton;
    Button_AdicionarMensagem: TButton;
    Edit_AdicionarMensagem: TEdit;
    Label_Info1: TLabel;
    Panel_MensagensAutomaticas: TPanel;
    Panel_BotoesMensagensAutomaticas: TPanel;
    Label_CaracteresRestantesMensagemAutomatica: TLabel;
    GroupBox_InfoUsuario: TGroupBox;
    TabSheet_MensagensAvulsas: TTabSheet;
    Twitter_Acesso: TTwitter;
    Label_UserID: TLabel;
    Label_ScreenName: TLabel;
    Label_UserIDValor: TLabel;
    Label_ScreenNameValor: TLabel;
    Label_UserName: TLabel;
    Label_UserNameValor: TLabel;
    Label_Location: TLabel;
    Label_LocationValor: TLabel;
    Label_Followers: TLabel;
    Label_FollowersValor: TLabel;
    Label_Friends: TLabel;
    Label_FriendsValor: TLabel;
    Bevel1: TBevel;
    Image_UserImage: TImage;
    GroupBox_Proxy: TGroupBox;
    LabeledEdit_Proxy: TLabeledEdit;
    ComboBox_ProxyAuth: TComboBox;
    Label_TipoDeAutenticacao: TLabel;
    LabeledEdit_ProxyPort: TLabeledEdit;
    LabeledEdit_ProxyUsername: TLabeledEdit;
    LabeledEdit_ProxyPassword: TLabeledEdit;
    LabeledEdit_ProxyConnection: TLabeledEdit;
    Button_RemoverMensagem: TButton;
    Button_LimparLista: TButton;
    Button_SalvarConfiguracoes: TButton;
    StatusBar_MensagensAutomaticas: TStatusBar;
    StatusBar1: TStatusBar;
    Panel1: TPanel;
    Panel2: TPanel;
    Edit_MensagemAvulsa: TEdit;
    Button_EnviarMensagem: TButton;
    Label_CaracteresRestantesMensagemAvulsa: TLabel;
    OpenDialog_Mensagens: TOpenDialog;
    GroupBox_Twitter: TGroupBox;
    LabeledEdit_IntervaloEntreTweets: TLabeledEdit;
    Label1: TLabel;
    procedure Edit_AdicionarMensagemChange(Sender: TObject);
    procedure Button_EnviarMensagemClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormShow(Sender: TObject);
    procedure Twitter_AcessoTwitterRequestDone(aRequest: TTwitterRequest; aHTTPStatus: SmallInt; aReceivedResult, aReceivedHeader: TStringList);
    procedure Button_AdicionarMensagemClick(Sender: TObject);
    procedure Edit_AdicionarMensagemKeyPress(Sender: TObject; var Key: Char);
    procedure Button_RemoverMensagemClick(Sender: TObject);
    procedure Button_LimparListaClick(Sender: TObject);
    procedure Button_SalvarConfiguracoesClick(Sender: TObject);
    procedure Edit_MensagemAvulsaChange(Sender: TObject);
    procedure Button_CarregarMensagensClick(Sender: TObject);
    procedure Button_AtivarAutoitterClick(Sender: TObject);
  private
    { Private declarations }
    FConfiguracoes: TConfiguracoes;
    procedure DoEdit_MensagemChange(aEdit: TEdit; aLabelCharacters: TLabel);
    procedure InicializarAPITwitter;
    procedure CarregarConfiguracoes;
    procedure SalvarConfiguracoes;
    procedure AplicarConfiguracoes(aAplicarConfiguracoes: TAplicarConfiguracoes);
    procedure ShowUserDetails;
    procedure PreencherComboTiposAutenticacao;
  public
    { Public declarations }
  end;

var
  Form_Principal: TForm_Principal;

implementation

uses TypInfo
   , ZTO.Win32.Rtl.Common.NetworkUtils;

{$R *.dfm}

const
  CONSUMERKEY = 'Qnd51hKXrsIaOGCr3RPKwQ';
  CONSUMERSECRET = 'qwiMjrwcSwBAgQMg6cWLkiIvgDDnl36JLCkVtcJY';
  TIMERID = 1;

procedure TForm_Principal.AplicarConfiguracoes(aAplicarConfiguracoes: TAplicarConfiguracoes);
begin
  case aAplicarConfiguracoes of
    acNoObjeto: begin
      if Twitter_Acesso.UserID <> '' then
        FConfiguracoes.UserID := Twitter_Acesso.UserID;
      FConfiguracoes.AccessToken := Twitter_Acesso.AccessToken;
      FConfiguracoes.AccessTokenSecret := Twitter_Acesso.AccessTokenSecret;

      Twitter_Acesso.Proxy := LabeledEdit_Proxy.Text;
      FConfiguracoes.Proxy := Twitter_Acesso.Proxy;

      Twitter_Acesso.ProxyAuth := THttpAuthType(ComboBox_ProxyAuth.Items.Objects[ComboBox_ProxyAuth.ItemIndex]);
      FConfiguracoes.ProxyAuth := Twitter_Acesso.ProxyAuth;

      Twitter_Acesso.ProxyConnection := LabeledEdit_ProxyConnection.Text;
      FConfiguracoes.ProxyConnection := Twitter_Acesso.ProxyConnection;

      Twitter_Acesso.ProxyPassword := LabeledEdit_ProxyPassword.Text;
      FConfiguracoes.ProxyPassword := Twitter_Acesso.ProxyPassword;

      Twitter_Acesso.ProxyPort := LabeledEdit_ProxyPort.Text;
      FConfiguracoes.ProxyPort := Twitter_Acesso.ProxyPort;

      Twitter_Acesso.ProxyUsername := LabeledEdit_ProxyUsername.Text;
      FConfiguracoes.ProxyUsername := Twitter_Acesso.ProxyUsername;

      FConfiguracoes.MensagensAutomaticas.Assign(ListBox_ListaDeMensagens.Items);

      FConfiguracoes.IntervaloEntreTweets := StrToInt(LabeledEdit_IntervaloEntreTweets.Text);
    end;
    acDoObjeto: begin
      Twitter_Acesso.IdentifyUser(FConfiguracoes.AccessToken,FConfiguracoes.AccessTokenSecret);

      Twitter_Acesso.Proxy := FConfiguracoes.Proxy;
      LabeledEdit_Proxy.Text := Twitter_Acesso.Proxy;

      Twitter_Acesso.ProxyAuth := FConfiguracoes.ProxyAuth;
      ComboBox_ProxyAuth.ItemIndex := ComboBox_ProxyAuth.Items.IndexOfObject(TObject(Twitter_Acesso.ProxyAuth));

      Twitter_Acesso.ProxyConnection := FConfiguracoes.ProxyConnection;
      LabeledEdit_ProxyConnection.Text := Twitter_Acesso.ProxyConnection;

      Twitter_Acesso.ProxyPassword := FConfiguracoes.ProxyPassword;
      LabeledEdit_ProxyPassword.Text := Twitter_Acesso.ProxyPassword;

      Twitter_Acesso.ProxyPort := FConfiguracoes.ProxyPort;
      LabeledEdit_ProxyPort.Text := Twitter_Acesso.ProxyPort;

      Twitter_Acesso.ProxyUsername := FConfiguracoes.ProxyUsername;
      LabeledEdit_ProxyUsername.Text := Twitter_Acesso.ProxyUsername;

      ListBox_ListaDeMensagens.Items.Assign(FConfiguracoes.MensagensAutomaticas);

      LabeledEdit_IntervaloEntreTweets.Text := IntToStr(FConfiguracoes.IntervaloEntreTweets);
    end;
  end;
end;

procedure TForm_Principal.Button_EnviarMensagemClick(Sender: TObject);
begin
  Twitter_Acesso.SendTweet(Edit_MensagemAvulsa.Text);
end;

procedure TForm_Principal.Button_AdicionarMensagemClick(Sender: TObject);
var
  i: Integer;
begin
  for i := 0 to Pred(ListBox_ListaDeMensagens.Count) do
    if ListBox_ListaDeMensagens.Items[i] = Edit_AdicionarMensagem.Text then
    begin
      Application.MessageBox('A mensagem já existe na lista!','Item duplicado',MB_ICONWARNING);
      Break;
    end;

  if i = ListBox_ListaDeMensagens.Count then
  begin
    ListBox_ListaDeMensagens.Items.Add(Edit_AdicionarMensagem.Text);
    Edit_AdicionarMensagem.Clear;
  end;
end;

var
  MessageIndex: Integer;

procedure SendTweet;
begin
  if Form_Principal.ListBox_ListaDeMensagens.Count = 0 then
    Exit;

  Form_Principal.ListBox_ListaDeMensagens.ItemIndex := MessageIndex;

  Form_Principal.Twitter_Acesso.SendTweet(Form_Principal.ListBox_ListaDeMensagens.Items[MessageIndex]);

  Inc(MessageIndex);

  if MessageIndex > Pred(Form_Principal.ListBox_ListaDeMensagens.Count) then
    MessageIndex := 0;
end;

procedure DoTimer(var Msg: TMessage);
begin
  SendTweet;
end;

procedure TForm_Principal.Button_AtivarAutoitterClick(Sender: TObject);
begin
  if TButton(Sender).Caption = 'Ativar Autoitter' then
  begin
    TButton(Sender).Caption := 'Desativar Autoitter';
    MessageIndex := 0;
    SendTweet;
    SetTimer(Handle,TIMERID,FConfiguracoes.IntervaloEntreTweets * 1000,@DoTimer)
  end
  else
  begin
    TButton(Sender).Caption := 'Ativar Autoitter';
    KillTimer(Handle,TIMERID);
  end;

  Edit_AdicionarMensagem.Enabled := TButton(Sender).Caption = 'Ativar Autoitter';
  Button_AdicionarMensagem.Enabled := TButton(Sender).Caption = 'Ativar Autoitter';
  ListBox_ListaDeMensagens.Enabled := TButton(Sender).Caption = 'Ativar Autoitter';
  TabSheet_MensagensAvulsas.TabVisible := TButton(Sender).Caption = 'Ativar Autoitter';
  TabSheet_Configuracoes.TabVisible := TButton(Sender).Caption = 'Ativar Autoitter';
end;

procedure TForm_Principal.Button_CarregarMensagensClick(Sender: TObject);
begin
  if Application.MessageBox('Se você carregar uma lista, a lista existente será perdida. Tem certeza?','Tem certeza?',MB_ICONWARNING or MB_YESNO) = IDYES then
    if OpenDialog_Mensagens.Execute then
      ListBox_ListaDeMensagens.Items.LoadFromFile(OpenDialog_Mensagens.FileName);
end;

procedure TForm_Principal.Button_LimparListaClick(Sender: TObject);
begin
  if ListBox_ListaDeMensagens.Count = 0 then
    Application.MessageBox('A lista está vazia','Nada precisa ser limpo',MB_ICONWARNING)
  else if Application.MessageBox('Tem certeza?','Tem certeza?',MB_ICONQUESTION or MB_YESNO) = IDYES then
    ListBox_ListaDeMensagens.Clear;
end;

procedure TForm_Principal.Button_RemoverMensagemClick(Sender: TObject);
begin
  if ListBox_ListaDeMensagens.Count = 0 then
    Application.MessageBox('A lista está vazia','Nada a excluir',MB_ICONWARNING)
  else if ListBox_ListaDeMensagens.SelCount = 0 then
    Application.MessageBox('Não existem itens selecionados','Nada a excluir',MB_ICONWARNING)
  else if Application.MessageBox('Tem certeza?','Tem certeza?',MB_ICONQUESTION or MB_YESNO) = IDYES then
    ListBox_ListaDeMensagens.DeleteSelected
end;

procedure TForm_Principal.Button_SalvarConfiguracoesClick(Sender: TObject);
begin
  SalvarConfiguracoes;
end;

procedure TForm_Principal.CarregarConfiguracoes;
begin
  FConfiguracoes.LoadFromBinaryFile(ExtractFilePath(Application.ExeName) + 'config.dat');
  AplicarConfiguracoes(acDoObjeto);
end;

procedure TForm_Principal.SalvarConfiguracoes;
begin
  AplicarConfiguracoes(acNoObjeto);
  FConfiguracoes.SaveToBinaryFile(ExtractFilePath(Application.ExeName) + 'config.dat');
end;

procedure TForm_Principal.ShowUserDetails;
begin
  Label_UserIDValor.Caption := Twitter_Acesso.UserID;
  Label_ScreenNameValor.Caption := '@' + Twitter_Acesso.UserScreenName;
  Label_UserNameValor.Caption := Twitter_Acesso.UserName;
  Label_LocationValor.Caption := Twitter_Acesso.UserLocation;
  Label_FollowersValor.Caption := Twitter_Acesso.UserFollowers;
  Label_FriendsValor.Caption := Twitter_Acesso.UserFriends;

  if DownloadFile(Twitter_Acesso.UserImageUrl,ExtractFilePath(Application.ExeName) + 'userimage' + ExtractFileExt(Twitter_Acesso.UserImageUrl)) then
    Image_UserImage.Picture.LoadFromFile(ExtractFilePath(Application.ExeName) + 'userimage' + ExtractFileExt(Twitter_Acesso.UserImageUrl));
end;

procedure TForm_Principal.Twitter_AcessoTwitterRequestDone(aRequest: TTwitterRequest; aHTTPStatus: SmallInt; aReceivedResult, aReceivedHeader: TStringList);
var
  PIN: String;
begin
  if aHTTPStatus = 200 then
    case aRequest of
      trNone: ;
      trRequestAuthTokens: begin
        Twitter_Acesso.RequestPINNumber;

        if InputQuery('Informe o PIN de autorização','Após autenticar-se na janela do browser que apareceu, você receberá um número (PIN). Por favor, digite este número no espaço abaixo e clique OK para continuar',PIN) and (PIN <> '') then
          Twitter_Acesso.RequestAccessData(PIN);
      end;
      trRequestPINNumber: { Não utilizado };
      trRequestAccessData: begin
        SalvarConfiguracoes;
        Twitter_Acesso.RequestUserDetails(FConfiguracoes.UserID);
      end;
      trRequestUserDetails: ShowUserDetails;
      trPostTweet: ;
    end;
end;

procedure TForm_Principal.DoEdit_MensagemChange(aEdit: TEdit; aLabelCharacters: TLabel);
var
  Restantes: Byte;
begin
  Restantes := 140 - Length(aEdit.Text);

  if Restantes < 16 then
    aLabelCharacters.Font.Color := clRed
  else if Restantes < 71 then
    aLabelCharacters.Font.Color := $000080FF
  else
    aLabelCharacters.Font.Color := clGreen;

  aLabelCharacters.Caption := 'Restam ' + IntToStr(Restantes) + ' caracteres';
end;

procedure TForm_Principal.Edit_MensagemAvulsaChange(Sender: TObject);
begin
  DoEdit_MensagemChange(Sender as TEdit,Label_CaracteresRestantesMensagemAvulsa);
end;

procedure TForm_Principal.Edit_AdicionarMensagemChange(Sender: TObject);
begin
  DoEdit_MensagemChange(Sender as TEdit,Label_CaracteresRestantesMensagemAutomatica);
end;

procedure TForm_Principal.Edit_AdicionarMensagemKeyPress(Sender: TObject; var Key: Char);
begin
  if Key = #13 then
  begin
    Key := #0;
    Button_AdicionarMensagem.Click;
  end;
end;

procedure TForm_Principal.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  SalvarConfiguracoes;
end;

procedure TForm_Principal.FormCreate(Sender: TObject);
begin
  FConfiguracoes := TConfiguracoes.Create(Self);
end;

procedure TForm_Principal.FormDestroy(Sender: TObject);
begin
  FConfiguracoes.Free;
end;

procedure TForm_Principal.FormShow(Sender: TObject);
begin
  PreencherComboTiposAutenticacao;
  CarregarConfiguracoes;
  InicializarAPITwitter;
end;

procedure TForm_Principal.InicializarAPITwitter;
begin
  Twitter_Acesso.IndentifyApp(CONSUMERKEY,CONSUMERSECRET);
  { perguntar aqui se ja salvou o login. Se sim, nada mais precisa ser feito,
  apenas atribuir o login, como abaixo }
  if not Twitter_Acesso.HasAccessTokens then
    Twitter_Acesso.RequestToken
  else
    Twitter_Acesso.RequestUserDetails(FConfiguracoes.UserID);
end;

procedure TForm_Principal.PreencherComboTiposAutenticacao;
var
	i: THttpAuthType;
begin
  ComboBox_ProxyAuth.Clear;

  for i := Low(THttpAuthType) to High(THttpAuthType) do
   	ComboBox_ProxyAuth.Items.AddObject(GetEnumName(TypeInfo(THttpAuthType),Ord(i)),TObject(i));
end;
end.
