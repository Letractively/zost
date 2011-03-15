unit UForm_ModulesThumbnails;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ActnList, ExtCtrls, StdCtrls, ComCtrls,

  UXXXForm_DialogTemplate, UXXXForm_MainTabbedTemplate;

type
  	TForm_ModulesThumbnails = class(TXXXForm_DialogTemplate)
    	ScrollBox_ThumbScroller: TScrollBox;
	    Shape_Selection: TShape;
  	private
    	FForm_MainTabbedTemplate: TXXXForm_MainTabbedTemplate;
	    function CreateTImage(const PageModule: TTabSheet): TImage;
    	procedure DoImageClick(Sender: TObject);
    	procedure GetModuleImages;
    	procedure DoMouseEnter(Sender: TObject);
    	procedure DoMouseLeave(Sender: TObject);
    	{ Private declarations }
  	public
    	{ Public declarations }
	    class function Execute(const aForm_MainTabbedTemplate: TXXXForm_MainTabbedTemplate): TModalResult;
  	end;

implementation

uses
	ImageResample;

{$R *.dfm}

class function TForm_ModulesThumbnails.Execute(const aForm_MainTabbedTemplate: TXXXForm_MainTabbedTemplate): TModalResult;
var
	ThisFormReference: TForm_ModulesThumbnails;
    DialogCreateParameters: TDialogCreateParameters;
begin
	ZeroMemory(@DialogCreateParameters,SizeOf(TDialogCreateParameters));
    
  	with Self.Create(aForm_MainTabbedTemplate,ThisFormReference,DialogCreateParameters) do
    begin
        FForm_MainTabbedTemplate := aForm_MainTabbedTemplate;
        GetModuleImages;
        Result := ShowModal;
	end;
end;
//  	with Self.Create(Application,ThisFormReference,DialogCreateParameters) do
//    begin
//        FForm_MainTabbedTemplate := aForm_MainTabbedTemplate;
//        GetModuleImages;
//        Result := ShowModal;
//	end;

procedure TForm_ModulesThumbnails.GetModuleImages;
var
	i: Word;
  	ModulePage: TTabSheet;
  	ModuleImage, ResampledImage: TBitmap;
    CreatedImage: TImage;
begin
    for i := 0 to Pred(FForm_MainTabbedTemplate.PageControl_Main.PageCount) do
    begin
    	{ TODO : O cast é necessário por causa da classe TTabSheet Interposer }
        ModulePage := TTabSheet(FForm_MainTabbedTemplate.PageControl_Main.Pages[i]);

        //skip the active MDI child (as it is currently "active")
        if i = FForm_MainTabbedTemplate.PageControl_Main.ActivePageIndex then
            Continue;

        ResampledImage := nil;
        ModuleImage := nil;
        try
	        //get form image and place it on the scroll box
    	    ModuleImage := TForm(ModulePage.Controls[0]).GetFormImage; { Origem }
            CreatedImage := CreateTImage(ModulePage); { Final }
            ResampledImage := TBitmap.Create; { Destino }
            ResampledImage.Width := CreatedImage.Width;
            ResampledImage.Height := CreatedImage.Height;
            Strecth(ModuleImage,ResampledImage,Lanczos3Filter,ResampledImage.Width);
            CreatedImage.Picture.Assign(ResampledImage);
        finally
        	ResampledImage.Free;
            ModuleImage.Free;
        end;
    end;
end;

procedure TForm_ModulesThumbnails.DoImageClick(Sender: TObject);
begin
	FForm_MainTabbedTemplate.PageControl_Main.ActivePageIndex := TImage(Sender).Tag;
    FForm_MainTabbedTemplate.PageControl_Main.OnChange(Sender);
	ModalResult := mrOk;
end;

function TForm_ModulesThumbnails.CreateTImage(const PageModule: TTabSheet): TImage;
begin
	Result := TImage.Create(ScrollBox_ThumbScroller);

  	with Result do
  	begin
    	Tag := PageModule.PageIndex; //used to activate upon "click"
        Parent := ScrollBox_ThumbScroller;

    	Cursor := crHandPoint;
    	Margins.Left := 8;
    	Margins.Right := 8;
    	Margins.Top := 8;
    	Margins.Bottom := 8;
    	AlignWithMargins := true;
    	Width := 4 * ScrollBox_ThumbScroller.Height div 3;
    	Align := alLeft;

//    	Stretch := true;
//    	Proportional := true;
    	Center := true;

    	OnClick := DoImageClick;
    	OnMouseEnter := DoMouseEnter;
    	OnMouseLeave := DoMouseLeave;

    	ShowHint := true;
    	Hint := Format('Clique para ativar o módulo "%s"',[PageModule.Caption]) ;
  	end;


end;

procedure TForm_ModulesThumbnails.DoMouseEnter(Sender: TObject);
var
  	ModuleImage : TImage;
begin
  	ModuleImage := TImage(Sender);

  	Shape_Selection.Left := ModuleImage.Left - 4;
  	Shape_Selection.Top := ModuleImage.Top - 4;
  	Shape_Selection.Width := ModuleImage.Width + 8;
  	Shape_Selection.Height := ModuleImage.Height + 8;

  	Shape_Selection.Visible := True;
end;

procedure TForm_ModulesThumbnails.DoMouseLeave(Sender: TObject);
begin
	Shape_Selection.Visible := False;
end;


end.
