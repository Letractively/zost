unit UPrincipal;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ExtCtrls, StdCtrls, ComCtrls;

type
  EnvironmentException = class(Exception)
  private
    FErrorCode: Integer;
  public
    constructor Create(const aMsg: String; aErrorCode: Integer); reintroduce;
    property ErrorCode: Integer read FErrorCode;
  end;
  
  TForm_Principal = class(TForm)
    Image_InstalacaoDelphiOK: TImage;
    Image_InstalacaoDelphiNOK: TImage;
    Timer_Checagens: TTimer;
    GroupBox_InstalacaoDelphi: TGroupBox;
    Label_InstalacaoDelphi2006: TLabel;
    GroupBox_InstalacaoEurekaLog: TGroupBox;
    Image_InstalacaoEurekaLogOK: TImage;
    Image_InstalacaoEurekaLogNOK: TImage;
    Label_InstalacaoEurekaLog: TLabel;
    GroupBox_InstalacaoCnPack: TGroupBox;
    Image_InstalacaoCnPackOK: TImage;
    Image_InstalacaoCnPackNOK: TImage;
    Label_InstalacaoCnPack: TLabel;
    GroupBox_InstalacaoGExperts: TGroupBox;
    Image_InstalacaoGExpertsOK: TImage;
    Image_InstalacaoGExpertsNOK: TImage;
    Label_InstalacaoGExperts: TLabel;
    Panel1: TPanel;
    Label1: TLabel;
    GroupBox_InstalacaoDelphiSpeedUp: TGroupBox;
    Image_InstalacaoDelphiSpeedUpOK: TImage;
    Image_InstalacaoDelphiSpeedUpNOK: TImage;
    Label_InstalacaoDelphiSpeedUp: TLabel;
    PageControl_Paginas: TPageControl;
    TabSheet_Verificacao: TTabSheet;
    TabSheet_Configuracoes: TTabSheet;
    GroupBox_ConfiguracoesQuickReportAntiho: TGroupBox;
    Image_ConfiguracoesQuickReportAntigoOK: TImage;
    Image_ConfiguracoesQuickReportAntigoNOK: TImage;
    Label_ConfiguracoesQuickReportAntigo: TLabel;
    Button_ConfiguracoesQuickReportAntigo: TButton;
    GroupBox_ConfiguracoesOracleClient: TGroupBox;
    Image_ConfiguracoesOracleClientOK: TImage;
    Image_ConfiguracoesOracleClientNOK: TImage;
    Label_ConfiguracoesOracleClient: TLabel;
    Button_ConfiguracoesOracleClient: TButton;
    GroupBox_InstalacaoRave: TGroupBox;
    Image_InstalacaoRaveOK: TImage;
    Image_InstalacaoRaveNOK: TImage;
    Label_InstalacaoRave: TLabel;
    Panel2: TPanel;
    Label2: TLabel;
    GroupBox_ConfiguracoesLibraryPathEnvironmentVariables: TGroupBox;
    Image_ConfiguracoesLibraryPathEnvironmentVariablesOK: TImage;
    Image_ConfiguracoesLibraryPathEnvironmentVariablesNOK: TImage;
    Label_ConfiguracoesLibraryPathEnvironmentVariables: TLabel;
    Button_ConfiguracoesLibraryPathEnvironmentVariables: TButton;
    procedure Button_ConfiguracoesLibraryPathEnvironmentVariablesClick(
      Sender: TObject);
    procedure Button_ConfiguracoesOracleClientClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure Button_ConfiguracoesQuickReportAntigoClick(Sender: TObject);
    procedure Timer_ChecagensTimer(Sender: TObject);
  private
    { Private declarations }
    FDelphiRoot: String;
  public
    { Public declarations }
    procedure ChecarInstalacaoDelphi2006;
    procedure ChecarInstalacaoEurekaLog;
    procedure ChecarInstalacaoRaveReports;
    procedure ChecarInstalacaoCnPack;
    procedure ChecarInstalacaoGExperts;
    procedure ChecarInstalacaoDelphiSpeedUp;
    procedure ChecarArquivosPerdidosQuickReport;
    procedure ChecarOracleClient;
    procedure RealizarChecagens;
  end;

var
  Form_Principal: TForm_Principal;

implementation

{$R *.dfm}

uses
  Registry, ShellAPI, ShlObj;

const
  OCX32DRIVE = 'D:\';
  OCX32FOLDER    = 'OCX32';
  OCX32LOCATION      = OCX32DRIVE + OCX32FOLDER;
  NLS_LANG = 'BRAZILIAN PORTUGUESE_BRAZIL.WE8MSWIN1252';

{ TForm_Principal }

function ShellFileOperation(aHandle: HWND; aFrom, aTo: String; aFunc: Cardinal; aFlags: Word; out aAnyOperationsAborted: Boolean; aProgressTitle: String): boolean;
var
  SHFileOpStruct: TSHFileOpStruct;
begin
  ZeroMemory(@SHFileOpStruct, SizeOf(TSHFileOpStruct));

  SHFileOpStruct.Wnd               := aHandle;
  SHFileOpStruct.wFunc             := aFunc;
  SHFileOpStruct.pFrom             := PChar(aFrom + #0#0);
  SHFileOpStruct.pTo               := PChar(aTo + #0#0);
  SHFileOpStruct.fFlags            := aFlags;
  aAnyOperationsAborted            := SHFileOpStruct.fAnyOperationsAborted;
  SHFileOpStruct.lpszProgressTitle := PChar(aProgressTitle);

  Result := SHFileOperation(SHFileOpStruct) = 0;
end;


{
 ulFlags
Flags specifying the options for the dialog box. This member can include zero or a combination of the following values.
BIF_BROWSEFORCOMPUTER
Only return computers. If the user selects anything other than a computer, the OK button is grayed.
BIF_BROWSEFORPRINTER
Only return printers. If the user selects anything other than a printer, the OK button is grayed.
BIF_BROWSEINCLUDEFILES
Version 4.71. The browse dialog box will display files as well as folders.
BIF_BROWSEINCLUDEURLS
Version 5.0. The browse dialog box can display URLs. The BIF_USENEWUI and BIF_BROWSEINCLUDEFILES flags must also be set. If these three flags are not set, the browser dialog box will reject URLs. Even when these flags are set, the browse dialog box will only display URLs if the folder that contains the selected item supports them. When the folder's IShellFolder::GetAttributesOf method is called to request the selected item's attributes, the folder must set the SFGAO_FOLDER attribute flag. Otherwise, the browse dialog box will not display the URL.
BIF_DONTGOBELOWDOMAIN
Do not include network folders below the domain level in the dialog box's tree view control.
BIF_EDITBOX
Version 4.71. Include an edit control in the browse dialog box that allows the user to type the name of an item.
BIF_NEWDIALOGSTYLE
Version 5.0. Use the new user interface. Setting this flag provides the user with a larger dialog box that can be resized. The dialog box has several new capabilities including: drag and drop capability within the dialog box, reordering, shortcut menus, new folders, delete, and other shortcut menu commands. To use this flag, you must call OleInitialize or CoInitialize before calling SHBrowseForFolder.
BIF_NONEWFOLDERBUTTON
Version 6.0. Do not include the New Folder button in the browse dialog box.
BIF_NOTRANSLATETARGETS
Version 6.0. When the selected item is a shortcut, return the PIDL of the shortcut itself rather than its target.
BIF_RETURNFSANCESTORS
Only return file system ancestors. An ancestor is a subfolder that is beneath the root folder in the namespace hierarchy. If the user selects an ancestor of the root folder that is not part of the file system, the OK button is grayed.
BIF_RETURNONLYFSDIRS
Only return file system directories. If the user selects folders that are not part of the file system, the OK button is grayed.
BIF_SHAREABLE
Version 5.0. The browse dialog box can display shareable resources on remote systems. It is intended for applications that want to expose remote shares on a local system. The BIF_NEWDIALOGSTYLE flag must also be set.
BIF_STATUSTEXT
Include a status area in the dialog box. The callback function can set the status text by sending messages to the dialog box.
BIF_UAHINT
Version 6.0. When combined with BIF_NEWDIALOGSTYLE, adds a usage hint to the dialog box in place of the edit box. BIF_EDITBOX overrides this flag.
BIF_USENEWUI
Version 5.0. Use the new user interface, including an edit box. This flag is equivalent to BIF_EDITBOX | BIF_NEWDIALOGSTYLE. To use BIF_USENEWUI, you must call OleInitialize or CoInitialize before calling SHBrowseForFolder.
BIF_VALIDATE
Version 4.71. If the user types an invalid name into the edit box, the browse dialog box will call the application's BrowseCallbackProc with the BFFM_VALIDATEFAILED message. This flag is ignored if BIF_EDITBOX is not specified.
}

function ShellBrowseForFolder(const aHandle: HWND; out aDisplayName: String; const aTitle: String; const aFlags: Cardinal; out aSelectedPath: String): Boolean;
var
  SHBrowseInfo: TBrowseInfo;
  ItemIdList: PItemIDList;
  DisplayName, SelectedPath: PAnsiChar;
begin
  Result := False;

  ZeroMemory(@SHBrowseInfo,SizeOf(TBrowseInfo));

  GetMem(DisplayName,MAX_PATH);
  GetMem(SelectedPath,MAX_PATH);

  try
    SHBrowseInfo.hwndOwner      := aHandle;
    SHBrowseInfo.pidlRoot       := nil; { Um dia exponha um parâmetro }
    SHBrowseInfo.pszDisplayName := DisplayName;
    SHBrowseInfo.lpszTitle      := PAnsiChar(aTitle);
    SHBrowseInfo.ulFlags        := aFlags;
    SHBrowseInfo.lpfn           := nil; { Um dia exponha um parâmetro }
    SHBrowseInfo.lParam         := 0; { Um dia exponha um parâmetro }
    SHBrowseInfo.iImage         := 0; { Um dia exponha um parâmetro }

    ItemIdList := SHBrowseForFolder(SHBrowseInfo);

    if Assigned(ItemIdList) then
      try
        SHGetPathFromIDList(ItemIdList,SelectedPath);
        aDisplayName := DisplayName;
        aSelectedPath := SelectedPath;
        Result := True;
      finally
        GlobalFreePtr(ItemIdList);
      end;
  finally
    FreeMem(SelectedPath);
    FreeMem(DisplayName);
  end;
end;

procedure TForm_Principal.Button_ConfiguracoesLibraryPathEnvironmentVariablesClick(
  Sender: TObject);
begin
  -VER SE EXISTE
  -SE EXISTE VER SE ESTÁ CERTO OU CONTÉM
  -SE NAO EXISTE CRIA COM O CORRETO
  -CRIAR O ARQUIVO COM O LIBRARY E ENV. VARUABLES
  CRIA O APLICADOR DE ARQUIVO REG
end;

procedure TForm_Principal.Button_ConfiguracoesOracleClientClick(Sender: TObject);
var
  BoolAux: Boolean;
  StringAux1, StringAux2: String;
begin
  case TButton(Sender).Tag of
    0: begin { == Colocar no Path o caminho para o Oracle Client ============= }
      with TRegistry.Create do
        try
          Access := KEY_ALL_ACCESS;

          RootKey := HKEY_LOCAL_MACHINE;
          OpenKey('SYSTEM', False);
          OpenKey('CurrentControlSet', False);
          OpenKey('Control', False);
          OpenKey('Session Manager', False);
          OpenKey('Environment', False);

          WriteString('PATH',ReadString('PATH') + ';' + OCX32LOCATION);
        finally
          Free;
        end;
    end; { =================================================================== }
    1,2: begin { == Criar/Alterar a variável de ambiente ORACLE_BASE ========= }
      with TRegistry.Create do
        try
          Access := KEY_ALL_ACCESS;

          RootKey := HKEY_LOCAL_MACHINE;
          OpenKey('SYSTEM', False);
          OpenKey('CurrentControlSet', False);
          OpenKey('Control', False);
          OpenKey('Session Manager', False);
          OpenKey('Environment', False);

          WriteString('ORACLE_BASE',OCX32LOCATION);
        finally
          Free;
        end;
    end; { =================================================================== }
    3: begin { == Criar o diretorio OCX32 e copia tudo dentro dele =========== }
      if ShellBrowseForFolder(Handle,StringAux1,'Selecione a pasta que contém ' +
         'o Oracle Client 11g. Todos os arquivos e pastas existentes neste di' +
         'retório serão copiados no diretório padrão de destino (' + OCX32LOCATION + ')',BIF_NEWDIALOGSTYLE or BIF_NONEWFOLDERBUTTON or BIF_RETURNONLYFSDIRS or BIF_EDITBOX,StringAux2) then
      begin
        if not FileExists(StringAux2 + '\OCI.DLL') then
          raise Exception.Create('A pasta de origem do Oracle Client não é correta. Por favor escolha a pasta correta que contém os arquivos do Oracle Client');

        if not ShellFileOperation(Handle,StringAux2 + '\*.*',OCX32LOCATION,FO_COPY,FOF_NOCONFIRMATION or FOF_NOCONFIRMMKDIR,BoolAux,'Copiando arquivos do Oracle Client 11g') then
          raise Exception.Create('Não foi possível realizar a cópia dos arquivos. Verifique se você tem permissões para criar/gravar o/no diretório "' + OCX32LOCATION + '" e tente novamente');
      end
    end; { =================================================================== }
    4,5: begin { == Criar/Alterar a variável de ambiente ORACLE_HOME ========= }
      with TRegistry.Create do
        try
          Access := KEY_ALL_ACCESS;

          RootKey := HKEY_LOCAL_MACHINE;
          OpenKey('SYSTEM', False);
          OpenKey('CurrentControlSet', False);
          OpenKey('Control', False);
          OpenKey('Session Manager', False);
          OpenKey('Environment', False);

          WriteString('ORACLE_HOME',OCX32LOCATION);
        finally
          Free;
        end;
    end; { =================================================================== }
    6,7: begin { == Criar/Alterar a variável de ambiente TNS_ADMIN =========== }
      with TRegistry.Create do
        try
          Access := KEY_ALL_ACCESS;

          RootKey := HKEY_LOCAL_MACHINE;
          OpenKey('SYSTEM', False);
          OpenKey('CurrentControlSet', False);
          OpenKey('Control', False);
          OpenKey('Session Manager', False);
          OpenKey('Environment', False);

          WriteString('TNS_ADMIN',OCX32LOCATION);
        finally
          Free;
        end;
    end; { =================================================================== }
    8: begin { == Copia o arquivo sqlnet.ora para o local correto ========== }
      if ShellBrowseForFolder(Handle,StringAux1,'Selecione a pasta que contém ' +
         'o arquivo "SqlNet.ora". Este arquivo será copiado no diretório padr' +
         'ão de destino (' + OCX32LOCATION + ')',BIF_NEWDIALOGSTYLE or BIF_NONEWFOLDERBUTTON or BIF_RETURNONLYFSDIRS or BIF_EDITBOX,StringAux2) then
      begin
        if not FileExists(StringAux2 + 'SqlNet.ora') then
          raise Exception.Create('A pasta de origem não é correta. Por favor escolha a pasta que contém o arquivo "SqlNet.ora"');

        if not ShellFileOperation(Handle,StringAux2 + 'SqlNet.ora',OCX32LOCATION,FO_COPY,FOF_NOCONFIRMATION or FOF_NOCONFIRMMKDIR,BoolAux,'Copiando arquivos do Oracle Client 11g') then
          raise Exception.Create('Não foi possível realizar a cópia do arquivo. Verifique se você tem permissões para criar/gravar o/no diretório "' + OCX32LOCATION + '" e tente novamente');
      end
    end; { =================================================================== }
    9: begin { == Copia o arquivo tnsnames.ora para o local correto ========== }
      if ShellBrowseForFolder(Handle,StringAux1,'Selecione a pasta que contém ' +
         'o arquivo "TnsNames.ora". Este arquivo será copiado no diretório padr' +
         'ão de destino (' + OCX32LOCATION + ')',BIF_NEWDIALOGSTYLE or BIF_NONEWFOLDERBUTTON or BIF_RETURNONLYFSDIRS or BIF_EDITBOX,StringAux2) then
      begin
        if not FileExists(StringAux2 + 'TnsNames.ora') then
          raise Exception.Create('A pasta de origem não é correta. Por favor escolha a pasta que contém o arquivo "TnsNames.ora"');

        if not ShellFileOperation(Handle,StringAux2 + 'TnsNames.ora',OCX32LOCATION,FO_COPY,FOF_NOCONFIRMATION or FOF_NOCONFIRMMKDIR,BoolAux,'Copiando arquivos do Oracle Client 11g') then
          raise Exception.Create('Não foi possível realizar a cópia do arquivo. Verifique se você tem permissões para criar/gravar o/no diretório "' + OCX32LOCATION + '" e tente novamente');
      end
    end; { =================================================================== }
    10: begin { == Criar/Alterar a variável de ambiente NLS_LANG =========== }
      with TRegistry.Create do
        try
          Access := KEY_ALL_ACCESS;

          RootKey := HKEY_LOCAL_MACHINE;
          OpenKey('SYSTEM', False);
          OpenKey('CurrentControlSet', False);
          OpenKey('Control', False);
          OpenKey('Session Manager', False);
          OpenKey('Environment', False);

          WriteString('NLS_LANG',NLS_LANG);
        finally
          Free;
        end;
    end; { =================================================================== }
  end;
end;

procedure TForm_Principal.Button_ConfiguracoesQuickReportAntigoClick(Sender: TObject);
begin
  DeleteFile(FDelphiRoot + 'lib\QuickRpt.dcu');
  DeleteFile(FDelphiRoot + 'lib\quickrpt.res');
end;

procedure TForm_Principal.ChecarArquivosPerdidosQuickReport;
begin
  with TRegistry.Create do
    try
      Access := KEY_READ;

      { Procura pela chave de registro em HKCU }
      FDelphiRoot := '';
      RootKey := HKEY_CURRENT_USER;

      OpenKey('Software', False);
      OpenKey('Borland', False);
      OpenKey('BDS', False);
      OpenKey('4.0', False);

      FDelphiRoot := ReadString('RootDir');

      if (FDelphiRoot = '') or (not DirectoryExists(FDelphiRoot)) then
        raise EnvironmentException.Create('O Delphi 2006 parece não estar instalado ou sua instalação está corrompida. Por favor reinstale o Delphi 2006 e execute este teste novamente',0);

      if FileExists(FDelphiRoot + 'lib\QuickRpt.dcu') or FileExists(FDelphiRoot + 'lib\quickrpt.res') then
        raise EnvironmentException.Create('Os arquivos de uma versão antiga do Quick Report foram encontrados na pasta lib do Delphi 2006. Pressione o botão "Excluir" para resolver este problema',1);
    finally
      Free;
    end;
end;

procedure TForm_Principal.ChecarInstalacaoCnPack;
var
  CnPackDLL: String;
begin
  with TRegistry.Create do
    try
      Access := KEY_READ;

      { Procura pela chave de registro em HKCU }
      CnPackDLL := '';
      RootKey := HKEY_CURRENT_USER;

      OpenKey('Software', False);
      OpenKey('Borland', False);
      OpenKey('BDS', False);
      OpenKey('4.0', False);
      OpenKey('Experts', False);

      CnPackDLL := ReadString('CnWizards_D10');

      if (CnPackDLL = '') or (not FileExists(CnPackDLL)) then
        raise EnvironmentException.Create('O CnPack parece não estar instalado no Delphi 2006 ou não foi instalado. Tente abrir o Delphi 2006 uma vez e execute o teste novamente',0);
    finally
      Free;
    end;
end;

procedure TForm_Principal.ChecarInstalacaoDelphi2006;
var
  DelphiLocation: String;
begin
  with TRegistry.Create do
    try
      Access := KEY_READ;

      { Procura pela chave de registro em HKLM }
      DelphiLocation := '';
      RootKey := HKEY_LOCAL_MACHINE;

      OpenKey('Software', False);
      OpenKey('Wow6432Node', False);
      OpenKey('Borland', False);
      OpenKey('BDS', False);
      OpenKey('4.0', False);

      DelphiLocation := ReadString('App');

      if (DelphiLocation = '') or (not FileExists(DelphiLocation)) then
        raise EnvironmentException.Create('O Delphi 2006 não está instalado ou está instalado incorretamente. Por favor instale o Delphi 2006 e execute o teste novamente',0);

      CloseKey;

      { Procura pela chave de registro em HKCU }
      DelphiLocation := '';
      RootKey := HKEY_CURRENT_USER;

      OpenKey('Software', False);
      OpenKey('Borland', False);
      OpenKey('BDS', False);
      OpenKey('4.0', False);

      DelphiLocation := ReadString('App');

      if DelphiLocation = '' then
        raise EnvironmentException.Create('O Delphi 2006 parece estar instalado, mas a entrada de registro para o usuário atual não foi encontrada ou está incompleta. Por favor, execute o Delphi 2006 ao menos uma vez e execute o teste novamente',0);
    finally
      Free;
    end;
end;

procedure TForm_Principal.ChecarInstalacaoDelphiSpeedUp;
var
  DelphiSpeedUpDLL: String;
begin
  with TRegistry.Create do
    try
      Access := KEY_READ;

      { Procura pela chave de registro em HKCU }
      DelphiSpeedUpDLL := '';
      RootKey := HKEY_CURRENT_USER;

      OpenKey('Software', False);
      OpenKey('Borland', False);
      OpenKey('BDS', False);
      OpenKey('4.0', False);
      OpenKey('Experts', False);

      DelphiSpeedUpDLL := ReadString('DelphiSpeedUp');

      if (DelphiSpeedUpDLL = '') or (not FileExists(DelphiSpeedUpDLL)) then
        raise EnvironmentException.Create('O Delphi Speed Up parece não estar instalado no Delphi 2006 ou não foi instalado. Tente abrir o Delphi 2006 uma vez e execute o teste novamente',0);
    finally
      Free;
    end;
end;

procedure TForm_Principal.ChecarInstalacaoEurekaLog;
var
  EurekaLocation: String;
begin
  with TRegistry.Create do
    try
      Access := KEY_READ;

      { Procura pela chave de registro em HKLM }
      EurekaLocation := '';
      RootKey := HKEY_LOCAL_MACHINE;

      OpenKey('Software', False);
      OpenKey('Wow6432Node', False);
      OpenKey('EurekaLog', False);

      EurekaLocation := ReadString('AppDir');

      if (EurekaLocation = '') or (not DirectoryExists(EurekaLocation + '\Delphi10')) then
        raise EnvironmentException.Create('O Eureka Log não está instalado para o Delphi 2006 ou está instalado incorretamente. Por favor instale o Eureka Log para o Delphi 2006 e execute o teste novamente',0);

      CloseKey;

      { Procura pela chave de registro em HKCU }
      EurekaLocation := '';
      RootKey := HKEY_CURRENT_USER;

      OpenKey('Software', False);
      OpenKey('EurekaLog', False);

      EurekaLocation := ReadString('AppDir');

      if EurekaLocation = '' then
        raise EnvironmentException.Create('O Eureka Log parece estar instalado, mas a entrada de registro para o usuário atual não foi encontrada ou está incompleta. Por favor, execute o Delphi 2006 ao menos uma vez e execute o teste novamente',0);
    finally
      Free;
    end;
end;

procedure TForm_Principal.ChecarInstalacaoGExperts;
var
  GExpertsDLL: String;
begin
  with TRegistry.Create do
    try
      Access := KEY_READ;

      { Procura pela chave de registro em HKCU }
      GExpertsDLL := '';
      RootKey := HKEY_CURRENT_USER;

      OpenKey('Software', False);
      OpenKey('Borland', False);
      OpenKey('BDS', False);
      OpenKey('4.0', False);
      OpenKey('Experts', False);

      GExpertsDLL := ReadString('GExperts');

      if (GExpertsDLL = '') or (not FileExists(GExpertsDLL)) then
        raise EnvironmentException.Create('O GExperts parece não estar instalado no Delphi 2006 ou não foi instalado. Tente abrir o Delphi 2006 uma vez e execute o teste novamente',0);
    finally
      Free;
    end;
end;

procedure TForm_Principal.ChecarInstalacaoRaveReports;
var
  RaveLocation: String;
begin
  with TRegistry.Create do
    try
      Access := KEY_READ;

      RaveLocation := '';
      RootKey := HKEY_LOCAL_MACHINE;

      OpenKey('SOFTWARE', False);
      OpenKey('Wow6432Node', False);
      OpenKey('Nevrona Designs', False);
      OpenKey('Rave65BE', False);

      RaveLocation := ReadString('DesignerPath');

      if (RaveLocation = '') or (not FileExists(RaveLocation + '\Rave.exe')) then
        raise EnvironmentException.Create('O Rave Reports não está instalado para o Delphi 2006 ou está instalado incorretamente. Por favor instale o Rave Reports para o Delphi 2006 e execute o teste novamente',0);
    finally
      Free;
    end;
   // HKEY_LOCAL_MACHINE\SOFTWARE\Wow6432Node\Nevrona Designs\Rave65BE
end;

procedure TForm_Principal.ChecarOracleClient;
begin
  with TRegistry.Create do
    try
      Access := KEY_READ;

      { Procura por uma referência no PATH }
      RootKey := HKEY_LOCAL_MACHINE;

      OpenKey('SYSTEM', False);
      OpenKey('CurrentControlSet', False);
      OpenKey('Control', False);
      OpenKey('Session Manager', False);
      OpenKey('Environment', False);

      with TStringList.Create do
        try
          Text := StringReplace(UpperCase(ReadString('PATH')),';',#13#10,[rfReplaceAll]);

          if IndexOf(OCX32LOCATION) = -1 then
            raise EnvironmentException.Create('O Oracle Client 11g (' + OCX32LOCATION + ') não consta no path',0);
        finally
          Free;
        end;

      if ReadString('ORACLE_BASE') = '' then
        raise EnvironmentException.Create('A variável de ambiente ORACLE_BASE não foi definida',1);

      if ReadString('ORACLE_BASE') <> OCX32LOCATION then
        raise EnvironmentException.Create('A variável de ambiente ORACLE_BASE não está apontando para o local padrão (' + OCX32LOCATION + ')',2);

      if not FileExists(ReadString('ORACLE_BASE') + '\OCI.DLL') then
        raise EnvironmentException.Create('O Oracle Client 11g não está instalado no local definido na variável de ambiente "ORACLE_BASE" ou está corrompido',3);

      if ReadString('ORACLE_HOME') = '' then
        raise EnvironmentException.Create('A variável de ambiente ORACLE_HOME não foi definida',4);

      if ReadString('ORACLE_HOME') <> OCX32LOCATION then
        raise EnvironmentException.Create('A variável de ambiente ORACLE_HOME não está apontando para o local padrão (' + OCX32LOCATION + ')',5);

      if ReadString('TNS_ADMIN') = '' then
        raise EnvironmentException.Create('A variável de ambiente TNS_ADMIN não foi definida',6);

      if ReadString('TNS_ADMIN') <> OCX32LOCATION then
        raise EnvironmentException.Create('A variável de ambiente TNS_ADMIN não está apontando para o local padrão (' + OCX32LOCATION + ')',7);

      if not FileExists(ReadString('TNS_ADMIN') + '\sqlnet.ora') then
        raise EnvironmentException.Create('O arquivo SqlNet.ora não foi encontrado em ' + ReadString('TNS_ADMIN'),8);

      if not FileExists(ReadString('TNS_ADMIN') + '\tnsnames.ora') then
        raise EnvironmentException.Create('O arquivo TNSNames.ora não foi encontrado em ' + ReadString('TNS_ADMIN'),9);

      if ReadString('NLS_LANG') = '' then
        raise EnvironmentException.Create('A variável de ambiente NLS_LANG não foi definida. Isto não impede a conexão, no entanto pode afetar o retorno das consultas exibindo caracteres estranhos',10);
    finally
      Free;
    end;
end;

procedure TForm_Principal.FormCreate(Sender: TObject);
begin
  FDelphiRoot := '';
  GroupBox_ConfiguracoesOracleClient.Caption := ' Instalação do Oracle Client 11g (' + OCX32LOCATION + ') ';
end;

procedure TForm_Principal.RealizarChecagens;
begin
  { Delphi 2006 }
  try
    Image_InstalacaoDelphiOK.Visible := False;
    Image_InstalacaoDelphiNOK.Visible := True;

    ChecarInstalacaoDelphi2006;

    Image_InstalacaoDelphiNOK.Visible := False;
    Image_InstalacaoDelphiOK.Visible := True;
    Label_InstalacaoDelphi2006.Caption := 'Instalado corretamente!';
  except
    on E: EnvironmentException do
      Label_InstalacaoDelphi2006.Caption := E.Message;
  end;

  { Eureka Log para Delphi 2006 }
  try
    Image_InstalacaoEurekaLogOK.Visible := False;
    Image_InstalacaoEurekaLogNOK.Visible := True;

    ChecarInstalacaoEurekaLog;

    Image_InstalacaoEurekaLogNOK.Visible := False;
    Image_InstalacaoEurekaLogOK.Visible := True;
    Label_InstalacaoEurekaLog.Caption := 'Instalado corretamente!';
  except
    on E: EnvironmentException do
      Label_InstalacaoEurekaLog.Caption := E.Message;
  end;

  { CnPack para Delphi 2006 }
  try
    Image_InstalacaoCnPackOK.Visible := False;
    Image_InstalacaoCnPackNOK.Visible := True;

    ChecarInstalacaoCnPack;

    Image_InstalacaoCnPackNOK.Visible := False;
    Image_InstalacaoCnPackOK.Visible := True;
    Label_InstalacaoCnPack.Caption := 'Instalado corretamente!';
  except
    on E: EnvironmentException do
      Label_InstalacaoCnPack.Caption := E.Message;
  end;

  { GExperts para Delphi 2006 }
  try
    Image_InstalacaoGExpertsOK.Visible := False;
    Image_InstalacaoGExpertsNOK.Visible := True;

    ChecarInstalacaoGExperts;

    Image_InstalacaoGExpertsNOK.Visible := False;
    Image_InstalacaoGExpertsOK.Visible := True;
    Label_InstalacaoGExperts.Caption := 'Instalado corretamente!';
  except
    on E: EnvironmentException do
      Label_InstalacaoGExperts.Caption := E.Message;
  end;

  { DelphiSpeedUp para Delphi 2006 }
  try
    Image_InstalacaoDelphiSpeedUpOK.Visible := False;
    Image_InstalacaoDelphiSpeedUpNOK.Visible := True;

    ChecarInstalacaoDelphiSpeedUp;

    Image_InstalacaoDelphiSpeedUpNOK.Visible := False;
    Image_InstalacaoDelphiSpeedUpOK.Visible := True;
    Label_InstalacaoDelphiSpeedUp.Caption := 'Instalado corretamente!';
  except
    on E: EnvironmentException do
      Label_InstalacaoDelphiSpeedUp.Caption := E.Message;
  end;

  { QuickReport Obsoleto }
  try
    Image_ConfiguracoesQuickReportAntigoOK.Visible := False;
    Image_ConfiguracoesQuickReportAntigoNOK.Visible := True;
    Button_ConfiguracoesQuickReportAntigo.Enabled := False;

    ChecarArquivosPerdidosQuickReport;

    Image_ConfiguracoesQuickReportAntigoNOK.Visible := False;
    Image_ConfiguracoesQuickReportAntigoOK.Visible := True;
    Label_ConfiguracoesQuickReportAntigo.Caption := 'Nenhuma versão antiga do Quick Report foi encontrada!';
  except
    on E: EnvironmentException do
    begin
      Label_ConfiguracoesQuickReportAntigo.Caption := E.Message;

      if E.ErrorCode = 1 then
        Button_ConfiguracoesQuickReportAntigo.Enabled := True;
    end;
  end;

  { Rave Reports para Delphi 2006 }
  try
    Image_InstalacaoRaveOK.Visible := False;
    Image_InstalacaoRaveNOK.Visible := True;

    ChecarInstalacaoRaveReports;

    Image_InstalacaoRaveNOK.Visible := False;
    Image_InstalacaoRaveOK.Visible := True;
    Label_InstalacaoRave.Caption := 'Instalado corretamente!';
  except
    on E: EnvironmentException do
      Label_InstalacaoRave.Caption := E.Message;
  end;

  { OracleClient }
  try
    Image_ConfiguracoesOracleClientOK.Visible := False;
    Image_ConfiguracoesOracleClientNOK.Visible := True;
    Button_ConfiguracoesOracleClient.Enabled := False;

    ChecarOracleClient;

    Image_ConfiguracoesOracleClientNOK.Visible := False;
    Image_ConfiguracoesOracleClientOK.Visible := True;
    Label_ConfiguracoesOracleClient.Caption := 'Oracle Client 11g corretamente instalado!';
  except
    on E: EnvironmentException do
    begin
      Label_ConfiguracoesOracleClient.Caption := E.Message;
      Button_ConfiguracoesOracleClient.Tag := E.ErrorCode;
      Button_ConfiguracoesOracleClient.Enabled := True;
    end;
  end;
end;

procedure TForm_Principal.Timer_ChecagensTimer(Sender: TObject);
begin
  RealizarChecagens;
end;

{ EnvironmentException }

constructor EnvironmentException.Create(const aMsg: String; aErrorCode: Integer);
begin
  inherited Create(aMsg);
  FErrorCode := aErrorCode;
end;

end.
