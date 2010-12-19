(******************************************************************************
 * Esta unit define uma caixa de diálogo padrão, com todos os seus métodos e  *
 * propriedades. Uma instância desta classe é criada pelo wizard.             *
 ******************************************************************************)
unit ZTO.Wizards.FormTemplates.Dialog;

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
  TZTODialogClass = class of TZTODialog;
  PZTODialog = ^TZTODialog;

  TZTODialog = class (TZTOCustomForm)
  private
    FMyReference: PZTODialog;

    FPanel_Header: TPanel;
    FImage_Dialog: TImage;
    FLabel_DialogDescription: TLabel;
    FShape_HeaderLine: TShape;
    FPanel_Footer: TPanel;
    FShape_FooterLine: TShape;

    FBitBtn_Ok: TBitBtn;
    FBitBtn_Yes: TBitBtn;
    FBitBtn_YesToAll: TBitBtn;
    FBitBtn_No: TBitBtn;
    FBitBtn_Ignore: TBitBtn;
    FBitBtn_Cancel: TBitBtn;
    FBitBtn_Close: TBitBtn;
    FBitBtn_Help: TBitBtn;

    FOnOkButtonClick: TNotifyEvent;
    FOnYesButtonClick: TNotifyEvent;
    FOnYesToAllButtonClick: TNotifyEvent;
    FOnNoButtonClick: TNotifyEvent;
    FOnIgnoreButtonClick: TNotifyEvent;
    FOnCancelButtonClick: TNotifyEvent;
    FOnCloseButtonClick: TNotifyEvent;
    FOnHelpButtonClick: TNotifyEvent;

    FZTODialogProperties: TZTODialogProperties;
//    FSizeConstraints: TSizeConstraints;

    { Propriedades salvas diretamente no DFM, sem interação do usuário }
    procedure WriteBorderStyle(Writer: TWriter);
    procedure ReadBorderStyle(Reader: TReader);
    procedure WriteBorderIcons(Writer: TWriter);
    procedure ReadBorderIcons(Reader: TReader);
//    function GetBorderIcons: TBorderIcons;
//    function GetBorderStyle: TFormBorderStyle ;
//    function GetConstraints: TSizeConstraints;
//    function GetFormStyle: TFormStyle;
  protected
    procedure DoShow; override;
    procedure DoClose(var Action: TCloseAction); override;
    procedure DefineProperties(Filer: TFiler); override;
  public
    constructor Create(aOwner: TComponent); override;
    destructor Destroy; override;

    class function CreateDialog(    aOwner            : TComponent;
                                var aReference;       { não tem tipo! }
                                    aZTODialogClass   : TZTODialogClass;
                                    aShowMode         : TShowMode;
                                    aChangedWDP       : TChangedWDP;
                                    aDialogDescription: TCaption;
                                    aVisibleButtons   : TVisibleButtons;
                                    aDisabledButtons  : TDisabledButtons;
                                    aSelectedButton   : TSelectedButton;
                                    aDialogType       : TDialogType): TModalResult; overload; static;
  published
    property Action;
    property ActiveControl;
    property Align;
    property AlphaBlend default False;
    property AlphaBlendValue default 255;
    property AutoScroll;
    property BiDiMode;
//    property BorderIcons: TBorderIcons read GetBorderIcons;
//    property BorderStyle: TFormBorderStyle read GetBorderStyle;
//    property FormStyle: TFormStyle read GetFormStyle;
    property Caption;
    property ClientHeight;
    property ClientWidth;
    property Color;
//    property Constraints: TSizeConstraints read GetConstraints;
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
    property ZTOProperties: TZTODialogProperties read FZTODialogProperties write FZTODialogProperties;

    property OnActivate;
    property OnAlignInsertBefore;
    property OnAlignPosition;
    property OnCancelButtonClick: TNotifyEvent read FOnCancelButtonClick write FOnCancelButtonClick;
    property OnCanResize;
    property OnClick;
    property OnClose;
    property OnCloseButtonClick: TNotifyEvent read FOnCloseButtonClick write FOnCloseButtonClick;
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
    property OnHelpButtonClick: TNotifyEvent read FOnHelpButtonClick write FOnHelpButtonClick;
    property OnIgnoreButtonClick: TNotifyEvent read FOnIgnoreButtonClick write FOnIgnoreButtonClick;
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
    property OnNoButtonClick: TNotifyEvent read FOnNoButtonClick write FOnNoButtonClick;
    property OnOkButtonClick: TNotifyEvent read FOnOkButtonClick write FOnOkButtonClick;
    property OnPaint;
    property OnResize;
    property OnShortCut;
    property OnShow;
    property OnStartDock;
    property OnUnDock;
    property OnYesButtonClick: TNotifyEvent read FOnYesButtonClick write FOnYesButtonClick;
    property OnYesToAllButtonClick: TNotifyEvent read FOnYesToAllButtonClick write FOnYesToAllButtonClick;
  end;

implementation

uses Graphics
   , Windows;

{$R ZTOFormImages.res}

{ TZTODialog }

constructor TZTODialog.Create(aOwner: TComponent);
begin
  { Elementos anulados }
//  FSizeConstraints := TSizeConstraints.Create(Self);

  { Elementos estáticos }
  FPanel_Header := TPanel.Create(nil);

  with FPanel_Header do
  begin
    Left := 0;
    Top := 0;
    Height := 49;
    Align := alTop;
    Name := 'PanelHeader';
    Caption := '';
    ParentBackground := False;
  end;

  FImage_Dialog := TImage.Create(nil);

  with FImage_Dialog do
  begin
    Parent := FPanel_Header;
    Left := 4;
    Top := 6;
    Width := 32;
    Height := 32;
    AutoSize := True;
    Transparent := True;
  end;
  
  FShape_HeaderLine := TShape.Create(nil);

  with FShape_HeaderLine do
  begin
    Parent := FPanel_Header;
    Left := 4;
    Top := 43;
    Width := FPanel_Header.Width - 8;
    Height := 2;
    Pen.Color := clCaptionText;
    Anchors := [akLeft, akTop, akRight];
  end;

  FLabel_DialogDescription := TLabel.Create(nil);

  with FLabel_DialogDescription do
  begin
    Parent := FPanel_Header;
    ParentFont := True;
    Left := 4;
    Top := 1;
//    Font.Color := clCaptionText;
    Width := FPanel_Header.Width - 8;
    Height := FPanel_Header.Height - (FPanel_Header.Height - FShape_HeaderLine.Top) - 1 - 3;
    Anchors := [akLeft, akTop, akRight];
    AutoSize := False;
    Layout := tlCenter;
//    Color := clSilver;
    WordWrap := True;
  end;

  FPanel_Footer := TPanel.Create(nil);

  with FPanel_Footer do
  begin
    Left := 0;
    Top := 187;
    Height := 38;
    Align := alBottom;
    Name := 'PanelFooter';
    Caption := '';
    ParentBackground := False;
  end;

  FShape_FooterLine := TShape.Create(nil);

  with FShape_FooterLine do
  begin
    Parent := FPanel_Footer;
    Left := 4;
    Top := 4;
    Width := FPanel_Footer.Width - 8;
    Height := 2;
    Pen.Color := clCaptionText;
    Anchors := [akLeft, akRight, akBottom];
  end;

  { Botões }
  FBitBtn_Ok := TBitBtn.Create(nil);

  with FBitBtn_Ok do
  begin
    Parent := FPanel_Footer;
    Visible := False;
    Top := 9;
    Height := 25;
    Width := 80;
    Glyph.LoadFromResourceName(hInstance, 'OK_BUTTON');
    Caption := 'OK';
    NumGlyphs := 2;
    Spacing := 35;
    Anchors := [akRight, akBottom];
  end;

  FBitBtn_Yes := TBitBtn.Create(nil);

  with FBitBtn_Yes do
  begin
    Parent := FPanel_Footer;
    Visible := False;
    Top := 9;
    Height := 25;
    Width := 80;
    Glyph.LoadFromResourceName(hInstance, 'YES_BUTTON');
    Caption := 'Sim';
    NumGlyphs := 2;
    Spacing := 33;
    Anchors := [akRight, akBottom];
  end;

  FBitBtn_YesToAll := TBitBtn.Create(nil);

  with FBitBtn_YesToAll do
  begin
    Parent := FPanel_Footer;
    Visible := False;
    Top := 9;
    Height := 25;
    Width := 103;
    Glyph.LoadFromResourceName(hInstance, 'YESTOALL_BUTTON');
    Caption := 'Sim para todos';
    NumGlyphs := 2;
    Spacing := 4;
    Anchors := [akRight, akBottom];
  end;

  FBitBtn_No := TBitBtn.Create(nil);

  with FBitBtn_No do
  begin
    Parent := FPanel_Footer;
    Visible := False;
    Top := 9;
    Height := 25;
    Width := 80;
    Glyph.LoadFromResourceName(hInstance, 'NO_BUTTON');
    Caption := 'Não';
    NumGlyphs := 2;
    Spacing := 33;
    Anchors := [akRight, akBottom];
  end;

  FBitBtn_Ignore := TBitBtn.Create(nil);

  with FBitBtn_Ignore do
  begin
    Parent := FPanel_Footer;
    Visible := False;
    Top := 9;
    Height := 25;
    Width := 80;
    Glyph.LoadFromResourceName(hInstance, 'IGNORE_BUTTON');
    Caption := 'Ignorar';
    NumGlyphs := 2;
    Spacing := 16;
    Anchors := [akRight, akBottom];
  end;

  FBitBtn_Cancel := TBitBtn.Create(nil);

  with FBitBtn_Cancel do
  begin
    Parent := FPanel_Footer;
    Visible := False;
    Top := 9;
    Height := 25;
    Width := 80;
    Glyph.LoadFromResourceName(hInstance, 'CANCEL_BUTTON');
    Caption := 'Cancelar';
    NumGlyphs := 2;
    Spacing := 10;
    Anchors := [akRight, akBottom];
  end;

  FBitBtn_Close := TBitBtn.Create(nil);

  with FBitBtn_Close do
  begin
    Parent := FPanel_Footer;
    Visible := False;
    Top := 9;
    Height := 25;
    Width := 80;
    Glyph.LoadFromResourceName(hInstance, 'CLOSE_BUTTON');
    Caption := 'Fechar';
    NumGlyphs := 2;
    Spacing := 18;
    Anchors := [akRight, akBottom];
  end;

  FBitBtn_Help := TBitBtn.Create(nil);

  with FBitBtn_Help do
  begin
    Parent := FPanel_Footer;
    Visible := False;
    Top := 9;
    Height := 25;
    Width := 80;
    Glyph.LoadFromResourceName(hInstance, 'HELP_BUTTON');
    Caption := 'Ajuda';
    NumGlyphs := 2;
    Spacing := 23;
    Anchors := [akRight, akBottom];
  end;

  { Todas as propriedades customizadas PUBLISHED tem de ser criadas ANTES da
  chamada ao construtor inherited }
  FZTODialogProperties := TZTODialogProperties.Create(FPanel_Header
                                                     ,FPanel_Footer
                                                     ,FImage_Dialog
                                                     ,FLabel_DialogDescription
                                                     ,FBitBtn_Ok
                                                     ,FBitBtn_Yes
                                                     ,FBitBtn_YesToAll
                                                     ,FBitBtn_No
                                                     ,FBitBtn_Ignore
                                                     ,FBitBtn_Cancel
                                                     ,FBitBtn_Close
                                                     ,FBitBtn_Help);


  inherited;

//  if not (csDesigning in ComponentState) then
//  begin
//    Width := Width + 2;
//    Height := Height + 2;
//  end;

  FBitBtn_Ok.OnClick := FOnOkButtonClick;
  FBitBtn_Yes.OnClick := FOnYesButtonClick;
  FBitBtn_YesToAll.OnClick := FOnYesToAllButtonClick;
  FBitBtn_No.OnClick := FOnNoButtonClick;
  FBitBtn_Ignore.OnClick := FOnIgnoreButtonClick;
  FBitBtn_Cancel.OnClick := FOnCancelButtonClick;
  FBitBtn_Close.OnClick := FOnCloseButtonClick;
  FBitBtn_Help.OnClick := FOnHelpButtonClick;

  with Constraints do
  begin
    MinHeight := 240;
    MinWidth := 320;
    MaxHeight := 0;
    MaxWidth := 0;
  end;

  BorderIcons := [biSystemMenu, biHelp];
  BorderStyle := bsDialog;
  FormStyle := fsNormal;

  FPanel_Header.Parent := Self;
  FPanel_Footer.Parent := Self;
end;

procedure TZTODialog.DefineProperties(Filer: TFiler);
begin
  inherited;
  Filer.DefineProperty('BorderStyle',ReadBorderStyle,WriteBorderStyle, True);
  Filer.DefineProperty('BorderIcons',ReadBorderIcons,WriteBorderIcons, True);
end;

destructor TZTODialog.Destroy;
begin
  if ShowMode in [smShowAutoFree,smShowModalAutoFree] then
		FMyReference^ := nil;

  FZTODialogProperties.Free;

  FBitBtn_Help.Free;
  FBitBtn_Close.Free;
  FBitBtn_Cancel.Free;
  FBitBtn_Ignore.Free;
  FBitBtn_No.Free;
  FBitBtn_YesToAll.Free;
  FBitBtn_Yes.Free;
  FBitBtn_Ok.Free;

  FShape_FooterLine.Free;
  FPanel_Footer.Free;
  FLabel_DialogDescription.Free;
  FShape_HeaderLine.Free;
  FImage_Dialog.Free;
  FPanel_Header.Free;

//  FSizeConstraints.Free;
  inherited;
end;

procedure TZTODialog.DoClose(var Action: TCloseAction);
begin
  inherited;
	{ Ao fechar este form, seja com Close ou retornando um ModalResult, sua
  referência será liberada da memória }
  if ShowMode in [smShowAutoFree,smShowModalAutoFree] then
	  Action := caFree;
end;

{ Para não dar erro em tempo de projeto temos de selecionar o botão aqui }
procedure TZTODialog.DoShow;
begin
  case FZTODialogProperties.SelectedButton of
    sbOk: if FBitBtn_Ok.Enabled and FBitBtn_Ok.Visible then FBitBtn_Ok.SetFocus;
    sbYes: if FBitBtn_Yes.Enabled and FBitBtn_Yes.Visible then FBitBtn_Yes.SetFocus;
    sbYesToAll: if FBitBtn_YesToAll.Enabled and FBitBtn_YesToAll.Visible then FBitBtn_YesToAll.SetFocus;
    sbNo: if FBitBtn_No.Enabled and FBitBtn_No.Visible then FBitBtn_No.SetFocus;
    sbIgnore: if FBitBtn_Ignore.Enabled and FBitBtn_Ignore.Visible then FBitBtn_Ignore.SetFocus;
    sbCancel: if FBitBtn_Cancel.Enabled and FBitBtn_Cancel.Visible then FBitBtn_Cancel.SetFocus;
    sbClose: if FBitBtn_Close.Enabled and FBitBtn_Close.Visible then FBitBtn_Close.SetFocus;
    sbHelp: if FBitBtn_Help.Enabled and FBitBtn_Help.Visible then FBitBtn_Help.SetFocus;
  end;
  inherited;
end;

procedure TZTODialog.ReadBorderIcons(Reader: TReader);
begin
  inherited BorderIcons := [biSystemMenu, biHelp];
  Reader.SkipValue; // Não precisa ler o valor
end;

//function TZTODialog.GetBorderIcons: TBorderIcons;
//begin
//  Result := [biSystemMenu, biHelp];
//end;

procedure TZTODialog.ReadBorderStyle(Reader: TReader);
begin
  inherited BorderStyle := bsDialog;
  Reader.SkipValue; // Não precisa ler o valor
end;

//function TZTODialog.GetBorderStyle: TFormBorderStyle ;
//begin
//  Result := bsDialog;
//end;

//function TZTODialog.GetConstraints: TSizeConstraints;
//begin
//  with FSizeConstraints do
//  begin
//    MinHeight := 240;
//    MinWidth := 320;
//    MaxHeight := 0;
//    MaxWidth := 0;
//  end;
//  Result := FSizeConstraints;
//end;

//function TZTODialog.GetFormStyle: TFormStyle;
//begin
//  Result := fsNormal;
//end;

procedure TZTODialog.WriteBorderIcons(Writer: TWriter);
begin
  Writer.WriteIdent('[biSystemMenu, biHelp]');
end;

procedure TZTODialog.WriteBorderStyle(Writer: TWriter);
begin
  Writer.WriteIdent('bsDialog');
end;

class function TZTODialog.CreateDialog(    aOwner            : TComponent;
                                       var aReference;       { não tem tipo! }
                                           aZTODialogClass   : TZTODialogClass;
                                           aShowMode         : TShowMode;
                                           aChangedWDP       : TChangedWDP;
                                           aDialogDescription: TCaption;
                                           aVisibleButtons   : TVisibleButtons;
                                           aDisabledButtons  : TDisabledButtons;
                                           aSelectedButton   : TSelectedButton;
                                           aDialogType       : TDialogType): TModalResult;
begin
  Result := -1;
  if not Assigned(TZTODialog(aReference)) then
  begin
    TZTODialog(aReference) := aZTODialogClass.Create(aOwner);
  end;

  with TZTODialog(aReference) do
  begin
    FMyReference := @aReference;
    ShowMode    := aShowMode;

    if (wdpDialogDecription in aChangedWDP) or (wdpAll in aChangedWDP) then
      ZTOProperties.DialogDescription := aDialogDescription;

    if (wdpVisibleButtons in aChangedWDP) or (wdpAll in aChangedWDP) then
      ZTOProperties.VisibleButtons := aVisibleButtons;

    if (wdpDisabledButtons in aChangedWDP) or (wdpAll in aChangedWDP) then
      ZTOProperties.DisabledButtons := aDisabledButtons;

    if (wdpSelectedButtons in aChangedWDP) or (wdpAll in aChangedWDP) then
      ZTOProperties.SelectedButton := aSelectedButton;

    if (wdpDialogType in aChangedWDP) or (wdpAll in aChangedWDP) then
      ZTOProperties.DialogType := aDialogType;
  end;

  if aShowMode <> smNone then
  begin
    if TZTODialog(aReference).ShowMode in [smShowModal,smShowModalAutoFree] then
      Result := TZTODialog(aReference).ShowModal
    else if TZTODialog(aReference).ShowMode in [smShow,smShowAutoFree] then
      TZTODialog(aReference).Show;
  end;
  
end;

{ TSizeConstraints }

//function TSizeConstraints.GetMaxHeight: Integer;
//begin
//  Result := 0;
//end;
//
//function TSizeConstraints.GetMaxWidth: Integer;
//begin
//  Result := 0;
//end;
//
//function TSizeConstraints.GetMinHeight: Integer;
//begin
//  Result := 240;
//end;
//
//function TSizeConstraints.GetMinWidth: Integer;
//begin
//  Result := 320;
//end;

end.
