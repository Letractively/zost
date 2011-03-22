unit UFuncoes;

interface

uses SysUtils
   , Classes;

type
  TPFCallBack = function(const aSearchRec: TSearchRec; const aIsDirectory: Boolean): Boolean;

procedure ProcessFiles(aRootDir: TFileName;
                       aFileMask: ShortString;
                       aPFCallBack: TPFCallBack;
                       aIncludeSubdirs: Boolean = True);

function SHBrowseForObject(const aOwner: TComponent;
                           const aDialogTitle: ShortString;
                           const aDialogText: String;
                             out aSelection: String): Boolean;

implementation

uses UAPIWrappers;

procedure ProcessFiles(aRootDir: TFileName;
                       aFileMask: ShortString;
                       aPFCallBack: TPFCallBack;
                       aIncludeSubdirs: Boolean = True);
{ ---------------------------------------------------------------------------- }
procedure SearchTree;
var
  SearchRec: TSearchRec;
  DosError: integer;
begin
  if not Assigned(aPFCallBack) then
    raise Exception.Create('O procedure "SearchTree" não pode ser executado sem uma função de callback');
    
  DosError := FindFirst(aFileMask, 0, SearchRec);
  while DosError = 0 do
  begin
    try
      aPFCallBack(SearchRec, False);
    except
      on Eoor: EOutOfResources do
      begin
        Eoor.Message := Eoor.Message + #13#10'A quantidade de arquivos localizados excede o limite de recursos do seu sistema. Favor limitar seu critério de busca escolhendo diretório(s) de nível mais interno';
        raise;
      end;
    end;
    
    DosError := FindNext(SearchRec);
  end;

  if aIncludeSubdirs then
  begin
    DosError := FindFirst('*.*', faDirectory, SearchRec);

    while DosError = 0 do
    begin
      if ((SearchRec.attr and faDirectory = faDirectory) and (SearchRec.name <> '.') and (SearchRec.name <> '..')) then
      begin
        ChDir(SearchRec.Name);
        SearchTree;
        ChDir('..');
        aPFCallBack(SearchRec, True);
      end;

      DosError := FindNext(SearchRec);
    end;
  end;
end;
{ ---------------------------------------------------------------------------- }
begin
	ChDir(aRootDir);
	SearchTree;
end;


function SHBrowseForObject(const aOwner: TComponent;
                           const aDialogTitle: ShortString;
                           const aDialogText: String;
                             out aSelection: String): Boolean;
var
	SHBFO: TSHBrowseForObject;
begin
	SHBFO := nil;
	try
    SHBFO := TSHBrowseForObject.Create(aOwner);
    with SHBFO do
    begin
      DialogTitle := aDialogTitle;
      DialogText := aDialogText;
      RootObject := ridDesktop;
      { TODO -oCarlos Feitoza -cMELHORIA : Para tornar mais genérico, use
      um parâmetro para indicar os flags }
      Flags := [bfDirectoriesOnly,bfStatusText,bfNewDialogStyle,bfNoNewFolderButton];
    end;
      Result := SHBFO.Execute;

    aSelection := SHBFO.SelectedObject;

  finally
   	if Assigned(SHBFO) then
     	SHBFO.Free;
  end;
end;

end.
