unit ZTO.Win32.Rtl.Win.ShellAPI;

{$WEAKPACKAGEUNIT ON}

interface

uses Windows;

function ShellFileOperation(aHandle: HWND; aFrom, aTo: String; aFunc: Cardinal; aFlags: Word; out aAnyOperationsAborted: Boolean; aProgressTitle: String): boolean;
function ShellBrowseForFolder(const aHandle: HWND; out aDisplayName: String; const aTitle: String; const aFlags: Cardinal; out aSelectedPath: String): Boolean;

implementation

uses ShellAPI
   , ShlObj;

//function CopiaDirs(DirFonte,DirDest: String) : Boolean;
//var
//  ShFileOpStruct : TShFileOpStruct;
//begin
//  Result := False;
//  if DirFonte = '' then
//    raise Exception.Create(
//      'Diretório fonte não pode ficar em branco');
//  if DirDest = '' then
//    raise Exception.Create(
//      'Diretório destino não pode ficar em branco');
//  if not DirectoryExists(DirFonte) then
//    raise Exception.Create('Diretório fonte inexistente');
//  DirFonte := DirFonte+#0;
//  DirDest := DirDest+#0;
//  FillChar(ShFileOpStruct,Sizeof(TShFileOpStruct),0);
//  with ShFileOpStruct do begin
//    Wnd := Application.Handle;
//    wFunc := FO_COPY;
//    pFrom := PChar(DirFonte);
//    pTo := PChar(DirDest);
//    fFlags := FOF_ALLOWUNDO or FOF_SIMPLEPROGRESS or 
//       FOF_NOCONFIRMATION;
//  end;
//  ShFileOperation(ShFileOpStruct);
//end;


  {
  wFunc
Valor que indica qual operação será realizada. Pode ter um dos seguintes valores
FO_COPY
 Copia o(s) arquivo(s) especificado(s) no parâmetro pFrom para o local especificado no parâmetro pTo.
FO_DELETE
 Delete o(s) arquivo(s) especificado no parâmetro pFrom.
FO_MOVE
 Move o(s) arquivo(s) especificado(s) no parâmetro pFrom para o local especificado no parâmetro pTo.
FO_RENAME
 Renomeia os arquivo especificado no parâmetro pFrom para o nome especificado no parâmetro pTo. Usando essa função, não pode ser utilizado o flag de multiplos arquivos.
  }

{
 fFlag
Este parâmetro pode ser utilizado um ou diversos valores ao mesmo tempo, porém alguns não funcionam em conjunto, utilize OR para ligar mais de um flag.
FOF_ALLOWUNDO
 Permite desfazer a operação chamada.
FOF_CONFIRMMOUSE
 Não utilizada.
FOF_FILESONLY
 A operação será realizada apenas em arquivos quando utilizar o coringa (*.*), irá ignorar pastas.
FOF_MULTIDESTFILES
 Permite operação em multiplos arquivos, se o parâmetro pTo for uma pasta ele ira entender utilizar o nome do arquivo de pFrom com a pasta de pTo.
FOF_NOCONFIRMATION
 Assume como padrão “Sim para todos” para qualquer tela de confirmação para sobreescrever arquivo.
FOF_NOCONFIRMMKDIR
 Não cria automaticamente a pasta de destino caso ela não exista.
FOF_NO_CONNECTED_ELEMENTS
 Versão 5.0. Não move arquivos conectados de grupo, somente arquivos especificados.
FOF_NOCOPYSECURITYATTRIBS
 Versão 4.71. Não copia atributos de segurança para o novo arquivo.
FOF_NOERRORUI
 Não mostra tela de erro se algum ocorrer.
FOF_NORECURSION
 Somente executa em diretório local, não executa nos subdiretórios.
FOF_NORECURSEREPARSE

FOF_RENAMEONCOLLISION
 Em o arquivo pTo já existir, dá um novo nome para o arquivo no destino.
FOF_SILENT
 Não mostra tela de progresso da cópia do arquivo.
FOF_SIMPLEPROGRESS
 Mostra tela de progresso, porém não mostra o(s) nome(S) do(S) arquivo(s).
}


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
  DisplayName, SelectedPath: {$IFDEF VER220}PWideChar{$ELSE}PAnsiChar{$ENDIF};
begin
  Result := False;

  ZeroMemory(@SHBrowseInfo,SizeOf(TBrowseInfo));

  GetMem(DisplayName,MAX_PATH);
  GetMem(SelectedPath,MAX_PATH);

  try
    SHBrowseInfo.hwndOwner      := aHandle;
    SHBrowseInfo.pidlRoot       := nil; { Um dia exponha um parâmetro }
    SHBrowseInfo.pszDisplayName := DisplayName;
    SHBrowseInfo.lpszTitle      := {$IFDEF VER220}PWideChar{$ELSE}PAnsiChar{$ENDIF}(aTitle);
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

end.
