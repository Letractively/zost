unit Mdl.Lib.ZTOSDIForm_TaskBar;

interface

uses
  Windows, Classes, Controls, Forms,
  Mdl.Lib.ZTOSDIForm_Base, ImgList, DBActns, ActnList;

type
  TZTOSDIForm_TaskBar = class(TZTOSDIForm_Base)
  private
    { Private declarations }
  protected
    procedure CreateParams(var Params: TCreateParams); override;
  public
    { Public declarations }
  end;

implementation

{$R *.dfm}

procedure TZTOSDIForm_TaskBar.CreateParams(var Params: TCreateParams);
begin
  inherited;
  Params.ExStyle := Params.ExStyle or WS_EX_APPWINDOW;
  // Talvez a linha de baixo seja necessaria para impedir que todos os outros forms apareçam quando eu clico no botão desta janela apenas
  // Params.WndParent := GetDesktopWindow;
end;

end.
