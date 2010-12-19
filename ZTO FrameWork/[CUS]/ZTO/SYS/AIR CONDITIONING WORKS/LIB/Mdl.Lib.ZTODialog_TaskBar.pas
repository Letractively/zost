unit Mdl.Lib.ZTODialog_TaskBar;

interface

uses Windows
   , Classes
   , Controls
   , Forms
   , Mdl.Lib.ZTODialog_Base
   , ImgList, DBActns, ActnList, ExtCtrls;

type
  TZTODialog_TaskBar = class(TZTODialog_Base)
  private
    { Private declarations }
  protected
    procedure CreateParams(var Params: TCreateParams); override;
  public
    { Public declarations }
  end;


implementation

{$R *.dfm}

procedure TZTODialog_TaskBar.CreateParams(var Params: TCreateParams);
begin
  inherited;
  Params.ExStyle := Params.ExStyle or WS_EX_APPWINDOW;
end;


end.
