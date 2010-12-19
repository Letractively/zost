(******************************************************************************
 * Esta unit define uma form SDI padrão, com todos os seus métodos e          *
 * propriedades. Uma instância desta classe é criada pelo wizard.             *
 ******************************************************************************)
unit ZTO.Wizards.FormTemplates.SDIForm;

interface

uses Classes
   , Forms
   , ExtCtrls
   , StdCtrls
   , Buttons
   , Controls
   , ZTO.Wizards.FormTemplates.CustomForm
   , ZTO.Win32.Rtl.Common.Classes
   , ZTO.Wizards.FormTemplates.DataModule;

type
  TZTOSDIFormClass = class of TZTOSDIForm;
  PZTOSDIForm = ^TZTOSDIForm;

  TZTOSDIForm = class (TZTOCustomForm)
  private
    FMyReference: PZTOSDIForm;

    FZTOSDIFormProperties: TZTOSDIFormProperties;
  protected
    procedure DoClose(var Action: TCloseAction); override;
  public
    constructor Create(aOwner: TComponent); override;
    destructor Destroy; override;

    class function CreateSDIForm(    aOwner             : TComponent;
                                 var aReference;        { não tem tipo! }
                                     aZTOSDIFormClass    : TZTOSDIFormClass;
                                     aShowMode          : TShowMode): TModalResult; overload; static;
  published
    property Action;
    property ActiveControl;
    property Align;
    property AlphaBlend default False;
    property AlphaBlendValue default 255;
    property AutoScroll;
    property BiDiMode;
    property Caption;
    property ClientHeight;
    property ClientWidth;
    property Color;
    property TransparentColor default False;
    property TransparentColorValue default 0;
    property Ctl3D;
    property UseDockManager;
    property DefaultMonitor;
    property DockSite;
    property DragKind;
    property DragMode;
    property Enabled;
    property ParentFont default False;
    property Font;
    property Height;
    property HelpFile;
    property HorzScrollBar;
    property Icon;
    property KeyPreview;
    property Padding;
    property Menu;
    property OldCreateOrder;
    property ObjectMenuItem;
    property ParentBiDiMode;
    property PixelsPerInch;
    property PopupMenu;
    property PopupMode;
    property PopupParent;
    property Position;
    property PrintScale;
    property Scaled;
    property ScreenSnap default False;
    property ShowHint;
    property SnapBuffer default 10;
    property VertScrollBar;
    property Visible default False;
    property Width;
    property WindowMenu;
    property ZTOProperties: TZTOSDIFormProperties read FZTOSDIFormProperties write FZTOSDIFormProperties;

    property OnActivate;
    property OnAlignInsertBefore;
    property OnAlignPosition;
    property OnCanResize;
    property OnClick;
    property OnClose;
    property OnCloseQuery;
    property OnConstrainedResize;
    property OnContextPopup;
    property OnCreate;
    property OnDblClick;
    property OnDestroy;
    property OnDeactivate;
    property OnDockDrop;
    property OnDockOver;
    property OnDragDrop;
    property OnDragOver;
    property OnEndDock;
    property OnGetSiteInfo;
    property OnHide;
    property OnHelp;
    property OnKeyDown;
    property OnKeyPress;
    property OnKeyUp;
    property OnMouseActivate;
    property OnMouseDown;
    property OnMouseEnter;
    property OnMouseLeave;
    property OnMouseMove;
    property OnMouseUp;
    property OnMouseWheel;
    property OnMouseWheelDown;
    property OnMouseWheelUp;
    property OnPaint;
    property OnResize;
    property OnShortCut;
    property OnShow;
    property OnStartDock;
    property OnUnDock;
  end;

implementation

uses Graphics
   , Windows;

{ TZTOSDIForm }

constructor TZTOSDIForm.Create(aOwner: TComponent);
begin
  { Todas as propriedades customizadas PUBLISHED tem de ser criadas ANTES da
  chamada ao construtor inherited }
  FZTOSDIFormProperties := TZTOSDIFormProperties.Create();

  inherited;

  with Constraints do
  begin
    MinHeight := 240;
    MinWidth := 320;
  end;
end;

destructor TZTOSDIForm.Destroy;
begin
  if ShowMode in [smShowAutoFree,smShowModalAutoFree] then
		FMyReference^ := nil;

  FZTOSDIFormProperties.Free;

  inherited;
end;

procedure TZTOSDIForm.DoClose(var Action: TCloseAction);
begin
  inherited;
	{ Ao fechar este form, seja com Close ou retornando um ModalResult, sua
  referência será liberada da memória }
  if ShowMode in [smShowAutoFree,smShowModalAutoFree] then
	  Action := caFree;
end;

class function TZTOSDIForm.CreateSDIForm(    aOwner             : TComponent;
                                         var aReference;        { não tem tipo! }
                                             aZTOSDIFormClass   : TZTOSDIFormClass;
                                             aShowMode          : TShowMode): TModalResult;
begin
  Result := -1;
  if not Assigned(TZTOSDIForm(aReference)) then
  begin
    TZTOSDIForm(aReference) := aZTOSDIFormClass.Create(aOwner);
  end;

  with TZTOSDIForm(aReference) do
  begin
    FMyReference := @aReference;
    ShowMode     := aShowMode;
  end;

  if aShowMode <> smNone then
  begin
    if TZTOSDIForm(aReference).ShowMode in [smShowModal,smShowModalAutoFree] then
      Result := TZTOSDIForm(aReference).ShowModal
    else if TZTOSDIForm(aReference).ShowMode in [smShow,smShowAutoFree] then
      TZTOSDIForm(aReference).Show;
  end;
end;

end.
