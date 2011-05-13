unit UForm_Processing;

interface

uses
  	Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  	Dialogs, ExtCtrls, StdCtrls, ComCtrls;

type
	TForm_ProcessingClass = class of TForm_Processing;

    PTForm_Processing = ^TForm_Processing;

    TCreateParameters = record
        DialogDescription: AnsiString;
        CommonAnimation: TCommonAVI; { aviNone }
        AnimationFileName: TFileName;
        ShowProgressBar: Boolean;
    end;

  	TForm_Processing = class(TForm)
	    Shape_BackgroundHeader: TShape;
    	Shape_HeaderLine: TShape;
	    Bevel_Header: TBevel;
    	Label_DialogDescription: TLabel;
	    Image_Dialog: TImage;
    	Animate_Animation: TAnimate;
    	ProgressBar_Progress: TProgressBar;
    	procedure FormCreate(Sender: TObject);
	    procedure FormClose(Sender: TObject; var Action: TCloseAction);
  	private
    	{ Private declarations }
        FCreateParameters: TCreateParameters;
        FMyReference: PTForm_Processing;
  	public
    	{ Public declarations }
        constructor Create(aOwner: TComponent; var aReference; aCreateParameters: TCreateParameters); reintroduce; virtual;
        destructor Destroy; override;
		class function CreateDialog(aOwner: TComponent; var aReference; aForm_ProcessingClass: TForm_ProcessingClass; aCreateParameters: TCreateParameters): TModalResult; static;
  	end;

implementation

{$R *.dfm}

constructor TForm_Processing.Create(aOwner: TComponent; var aReference; aCreateParameters: TCreateParameters);
begin
    FMyReference := @aReference;
    FCreateParameters := aCreateParameters;
    inherited Create(aOwner);
end;

class function TForm_Processing.CreateDialog(aOwner: TComponent; var aReference; aForm_ProcessingClass: TForm_ProcessingClass; aCreateParameters: TCreateParameters): TModalResult;
begin
    Result := -1;
    if not Assigned(TForm_Processing(aReference)) then
    begin
        TForm_Processing(aReference) := TForm_ProcessingClass.Create(aOwner,aReference,aCreateParameters);

        TForm_Processing(aReference).FormStyle := fsStayOnTop;
     	TForm_Processing(aReference).Show;
    end;
end;

destructor TForm_Processing.Destroy;
begin
	FMyReference^ := nil;
  	inherited;
end;

procedure TForm_Processing.FormClose(Sender: TObject; var Action: TCloseAction);
begin
	Action := caFree;
end;

procedure TForm_Processing.FormCreate(Sender: TObject);
begin
	if Trim(Label_DialogDescription.Caption) = '' then
	    Label_DialogDescription.Caption := String(FCreateParameters.DialogDescription);

    if FCreateParameters.ShowProgressBar then
    begin
        ProgressBar_Progress.Visible := True;
        Animate_Animation.Height := Animate_Animation.Height - ProgressBar_Progress.Height - 6;
    end;
    
    Animate_Animation.CommonAVI := FCreateParameters.CommonAnimation;
    Animate_Animation.FileName := FCreateParameters.AnimationFileName;
    if (Animate_Animation.CommonAVI <> aviNone) or (Trim(Animate_Animation.FileName) <> '') then
	    Animate_Animation.Active := True;
end;

end.
