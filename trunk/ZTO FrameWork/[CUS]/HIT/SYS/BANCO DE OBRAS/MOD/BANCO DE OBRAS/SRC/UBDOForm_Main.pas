unit UBDOForm_Main;

interface

uses
    Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
    Dialogs, ActnList, ActnMenus, ToolWin, ActnMan, ActnCtrls, ComCtrls, ExtCtrls,
    XPStyleActnCtrls, ImgList, ActnColorMaps,

    UXXXForm_MainTabbedTemplate, UBalloonToolTip;

type
  	TBDOForm_Main = class(TXXXForm_MainTabbedTemplate)
    	ActionManager_Main: TActionManager;
        Action_ImportarExportar: TAction;
        Action_HelpHelp: TAction;
        Action_HelpAbout: TAction;
    	procedure Action_FullScreenApplicationExecute(Sender: TObject);
        procedure Action_ImportarExportarExecute(Sender: TObject);
        procedure Action_HelpAboutExecute(Sender: TObject);
  	private
    	{ Private declarations }
  	public
    	{ Public declarations }
  	end;

implementation

uses
	UBDODataModule_Main, UXXXForm_GeneralConfiguration, UXXXTypesConstantsAndClasses;

{$R *.dfm}

procedure TBDOForm_Main.Action_FullScreenApplicationExecute(Sender: TObject);
begin
  	inherited;
    case TAction(Sender).Tag of
        0: begin
        	TAction(Sender).ImageIndex := 6;
            TAction(Sender).Tag := 1
        end;
        1: begin
	        TAction(Sender).ImageIndex := 7;
            TAction(Sender).Tag := 0
        end;
    end;
end;

procedure TBDOForm_Main.Action_HelpAboutExecute(Sender: TObject);
begin
    inherited;
    TBDODataModule_Main(MyDataModule).ShowSplash;
end;

procedure TBDOForm_Main.Action_ImportarExportarExecute(Sender: TObject);
begin
    inherited;
    TBDODataModule_Main(MyDataModule).ExibirExportadorImportador
end;

end.
