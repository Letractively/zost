unit UForm_ApplyingSecurityPolicies;

interface

uses
	Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  	Dialogs, ComCtrls, StdCtrls;

type
  	TForm_ApplyingSecurityPolicies = class(TForm)
	    Label_Total: TLabel;
    	ProgressBar_TotalProgress: TProgressBar;
	    Label_Current: TLabel;
    	ProgressBar_CurrentProgress: TProgressBar;
    	procedure FormCreate(Sender: TObject);
    	procedure FormClose(Sender: TObject; var Action: TCloseAction);
  	private
    	{ Private declarations }
  	public
    	{ Public declarations }
  	end;

implementation

{$R *.dfm}

procedure TForm_ApplyingSecurityPolicies.FormClose(Sender: TObject; var Action: TCloseAction);
begin
	Action := caFree;
end;

procedure TForm_ApplyingSecurityPolicies.FormCreate(Sender: TObject);
begin
	Label_Total.Caption := '';
    Label_Current.Caption := '';
end;

end.
