unit UBDOForm_GeneralConfigurations;

interface

uses
  	Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  	Dialogs, ActnList, StdCtrls, CheckLst, CFEdit,
  	ComCtrls, Buttons, ExtCtrls,

 	UAPIWrappers, UXXXForm_GeneralConfiguration, _StdCtrls, _DBCtrls;

type
  	TBDOForm_GeneralConfigurations = class(TXXXForm_GeneralConfiguration)

    TabSheet_FTPSynchronizer: TTabSheet;
	    Label_FTPSynchronizerLocation: TLabel;
    	Button_FTPSynchronizerLocation: TButton;
	    Panel_FTPSynchronizerLocationValue: TPanel;
    	Label_FTPSynchronizerLocationValue: TLabel;
	    Shape_FTPSynchronizerLocationValue: TShape;
        TabSheet_ExibirOcultar: TTabSheet;
        CheckBox_ITE_LucroBruto: TCheckBox;
    	procedure Button_FTPSynchronizerLocationClick(Sender: TObject);
        procedure FormCreate(Sender: TObject);
  	private
    	{ Private declarations }
  	public
    	{ Public declarations }
  	end;

implementation

{$R *.dfm}

procedure TBDOForm_GeneralConfigurations.Button_FTPSynchronizerLocationClick(Sender: TObject);
begin
  	inherited;
    with TSHBrowseForObject.Create(Self) do
    	try
            Flags := [bfDirectoriesOnly];
            RootObject := ridDrives;
            DialogText := 'Selecione a pasta onde o FTP Synchronizer está instalado. Normalmente em "C:\Arquivos de Programas\Hitachi Tools\Banco De Obras X\FTP Synchronizer" onde "X" é o número da versão atual do BDO';
            DialogTitle := 'Onde está o FTP Synchronizer?';
            if Execute then
            begin
            	Label_FTPSynchronizerLocationValue.Caption := SelectedObject;
                Label_FTPSynchronizerLocationValue.Hint := SelectedObject; 
            end;
        finally
            Free;
        end;

end;

procedure TBDOForm_GeneralConfigurations.FormCreate(Sender: TObject);
begin
    inherited;
    TabSheet_PermissionOptions.TabVisible := False;
    PageControl_ConfigurationCategories.TabIndex := 0;
end;

end.
