unit UForm_ConfigureBackgroundImage;

interface

uses
  	Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  	Dialogs, UXXXForm_DialogTemplate, StdCtrls, ExtDlgs, ActnList, ExtCtrls,
    UXXXTypesConstantsAndClasses, Buttons;

type
  	TForm_ConfigureBackgroundImage = class(TXXXForm_DialogTemplate)
        Image_Sample: TImage;
        Label_BackgroundImage: TLabel;
        Label_LinkAddRemoveImage: TLabel;
        Label_LinkAddRemoveImageSombra1: TLabel;
        Label_LinkAddRemoveImageSombra2: TLabel;
        Label_LinkAddRemoveImageSombra3: TLabel;
        Label_LinkAddRemoveImageSombra4: TLabel;
        Label_NoneImage: TLabel;
        Label_Position1: TLabel;
        Label_Position2: TLabel;
        Label_Position3: TLabel;
        Label_Position4: TLabel;
        Label_Position5: TLabel;
        Label_Position: TLabel;
    	OpenPictureDialog_Image: TOpenPictureDialog;
        RadioButton_Zoomed: TRadioButton;
        RadioButton_Normal: TRadioButton;
        RadioButton_Tiled: TRadioButton;
        Shape_BackgroundImage: TShape;
        Shape_Image: TShape;
        Shape_Image2: TShape;
        Shape_Position1: TShape;
        Shape_Position2: TShape;
        Shape_Position3: TShape;
        Shape_Position4: TShape;
        Shape_Position5: TShape;
        Shape_Positions: TShape;
    	BitBtn_Ok: TBitBtn;
    	BitBtn_Cancel: TBitBtn;
    	procedure Shape_Position1MouseDown(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
    	procedure RadioButton_NormalClick(Sender: TObject);
    	procedure Label_LinkAddRemoveImageMouseEnter(Sender: TObject);
    	procedure Label_LinkAddRemoveImageMouseLeave(Sender: TObject);
    	procedure Label_LinkAddRemoveImageClick(Sender: TObject);
    	procedure FormCreate(Sender: TObject);
    	procedure BitBtn_OkClick(Sender: TObject);
  	private
    	{ Private declarations }
        FBackgroundImage: TFileName;
        FBackgroundImagePosition: TBackgroundImagePosition;
        FBackgroundImageModifier: TBackgroundImageModifier;
	public
    	{ Public declarations }
	end;

implementation

{$R *.dfm}

procedure TForm_ConfigureBackgroundImage.BitBtn_OkClick(Sender: TObject);
begin
  inherited;
  with CreateParameters.Configurations do
  begin
	  BackGroundImage := FBackgroundImage;
      BackgroundImagePosition := FBackgroundImagePosition;
      BackgroundImageModifier := FBackgroundImageModifier;
  end;
end;

procedure TForm_ConfigureBackgroundImage.FormCreate(Sender: TObject);
begin
  	inherited;
    FBackgroundImage := '';
    FBackgroundImagePosition := bipCentered;
    FBackgroundImageModifier := bimNormal;
  	with CreateParameters.Configurations do
  	begin
    	if (Trim(BackgroundImage) <> '') and (FileExists(BackgroundImage))then
    	begin
        	FBackgroundImage := BackgroundImage;
            Image_Sample.Picture.LoadFromFile(BackgroundImage);
      		Label_LinkAddRemoveImage.Caption := 'Remover imagem';
      		Label_LinkAddRemoveImageSombra1.Caption := 'Remover imagem';
     	 	Label_LinkAddRemoveImageSombra2.Caption := 'Remover imagem';
      		Label_LinkAddRemoveImageSombra3.Caption := 'Remover imagem';
      		Label_LinkAddRemoveImageSombra4.Caption := 'Remover imagem';
    	end;

        case BackgroundImagePosition of
    		bipTopLeft: Shape_Position1MouseDown(Shape_Position1,mbLeft,[],0,0);
            bipTopRight: Shape_Position1MouseDown(Shape_Position2,mbLeft,[],0,0);
      		bipBottomLeft: Shape_Position1MouseDown(Shape_Position3,mbLeft,[],0,0);
      		bipBottomRight: Shape_Position1MouseDown(Shape_Position4,mbLeft,[],0,0);
      		bipCentered: Shape_Position1MouseDown(Shape_Position5,mbLeft,[],0,0);
    	end;

        case BackgroundImageModifier of
            bimNormal: begin
                RadioButton_NormalClick(RadioButton_Normal);
                RadioButton_Normal.Checked := True;
            end;
            bimZoomed: begin
                RadioButton_NormalClick(RadioButton_Zoomed);
                RadioButton_Zoomed.Checked := True;
            end;
            bimTiled: begin
                RadioButton_NormalClick(RadioButton_Tiled);
                RadioButton_Tiled.Checked := True;
            end;
        end;
  	end;
end;

procedure TForm_ConfigureBackgroundImage.Label_LinkAddRemoveImageClick(Sender: TObject);
begin
  	inherited;
	if TLabel(Sender).Caption = 'Adicionar imagem' then
  	begin
  		if OpenPictureDialog_Image.Execute then
    		if Trim(OpenPictureDialog_Image.FileName) <> '' then
      		begin
		  		TLabel(Sender).Caption := 'Remover imagem';
        		Label_LinkAddRemoveImageSombra1.Caption := 'Remover imagem';
	        	Label_LinkAddRemoveImageSombra2.Caption := 'Remover imagem';
    	    	Label_LinkAddRemoveImageSombra3.Caption := 'Remover imagem';
		        Label_LinkAddRemoveImageSombra4.Caption := 'Remover imagem';
        		Image_Sample.Picture.LoadFromFile(OpenPictureDialog_Image.FileName);
	      		FBackgroundImage := OpenPictureDialog_Image.FileName;
    		end;
    end
  	else
  	begin
		TLabel(Sender).Caption := 'Adicionar imagem';
    	Label_LinkAddRemoveImageSombra1.Caption := 'Adicionar imagem';
    	Label_LinkAddRemoveImageSombra2.Caption := 'Adicionar imagem';
    	Label_LinkAddRemoveImageSombra3.Caption := 'Adicionar imagem';
	    Label_LinkAddRemoveImageSombra4.Caption := 'Adicionar imagem';
	    Image_Sample.Picture := nil;
    	FBackgroundImage := '';
  end;
end;

procedure TForm_ConfigureBackgroundImage.Label_LinkAddRemoveImageMouseEnter(Sender: TObject);
begin
  	inherited;
  	TLabel(Sender).Font.Color := clRed;
  	TLabel(Sender).Cursor := crHandPoint;
end;

procedure TForm_ConfigureBackgroundImage.Label_LinkAddRemoveImageMouseLeave(Sender: TObject);
begin
  	inherited;
	TLabel(Sender).Font.Color := clYellow;
  	TLabel(Sender).Cursor := crDefault;
end;

procedure TForm_ConfigureBackgroundImage.RadioButton_NormalClick(Sender: TObject);
begin
  	inherited;
 	case TRadioButton(Sender).Tag of
	  	0: FBackgroundImageModifier := bimNormal;
    	1: FBackgroundImageModifier := bimZoomed;
	    2: FBackgroundImageModifier := bimTiled;
  	end;
end;

procedure TForm_ConfigureBackgroundImage.Shape_Position1MouseDown(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
    inherited;
    RadioButton_Normal.Enabled := False;
    RadioButton_Zoomed.Enabled := False;
    RadioButton_Tiled.Enabled := False;

  	case TShape(Sender).Tag of
    	0: FBackgroundImagePosition := bipTopLeft;
	    1: FBackgroundImagePosition := bipTopRight;
    	2: FBackgroundImagePosition := bipBottomLeft;
	    3: FBackgroundImagePosition := bipBottomRight;
    	4: begin
	    	FBackgroundImagePosition := bipCentered;

	      RadioButton_Normal.Enabled := True;
    	  RadioButton_Zoomed.Enabled := True;
	      RadioButton_Tiled.Enabled := True;

    	  if RadioButton_Normal.Checked then
	      begin
    	  	RadioButton_NormalClick(RadioButton_Normal);
        	RadioButton_Normal.Checked := True;
	      end
    	  else
      		if RadioButton_Zoomed.Checked then
	      	begin
    	      RadioButton_NormalClick(RadioButton_Zoomed);
        	  RadioButton_Zoomed.Checked := True;
			end
	        else if RadioButton_Tiled.Checked then
          	begin
            	RadioButton_NormalClick(RadioButton_Tiled);
	            RadioButton_Tiled.Checked := True;
    	    end;
    	end;
  	end;

  	Shape_Image.Left := TShape(Sender).Left;
  	Shape_Image.Top := TShape(Sender).Top;
  	Shape_Image2.Left := Shape_Image.Left;
  	Shape_Image2.Top := Shape_Image.Top;
end;

end.
