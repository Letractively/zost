unit UBDOForm_AutoSync;

interface

uses
  	Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  	Dialogs, UXXXForm_DialogTemplate, StdCtrls, ActnList, ExtCtrls, Buttons,
    ComCtrls;

type
    TBDOForm_AutoSync = class(TXXXForm_DialogTemplate)
	    RichEdit_Log: TRichEdit;
    	ProgressBar_Progress: TProgressBar;
	    Label_Percent: TLabel;
    	procedure FormClose(Sender: TObject; var Action: TCloseAction);
    	procedure FormCreate(Sender: TObject);
    private
        { Private declarations }
    public
        { Public declarations }
    end;

implementation

uses
	UBDODataModule_AutoSync;
    
{$R *.dfm}

procedure TBDOForm_AutoSync.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  	inherited;
    CreateParameters.MyDataModule.WaitFor(2);
end;

procedure TBDOForm_AutoSync.FormCreate(Sender: TObject);
begin
  	inherited;
//    TDataModule_AutoSync(DataModule).ReadFTPConfigurations;

//  	if not DirectoryExists(TDataModule_AutoSync(DataModule).FTPDirectory) then
//    	CreateDir(TDataModule_AutoSync(DataModule).FTPDirectory);

//    TDataModule_AutoSync(DataModule).FtpClient_AutoSync.LocalFileName := TDataModule_AutoSync(DataModule).FTPDirectory + 'fakefile.sql';

//    TDataModule_AutoSync(DataModule).Busy := True;
//    TDataModule_AutoSync(DataModule).Busy := False;

//	if TDataModule_AutoSync(DataModule).GeneralResult = mrAbort then
//        TDataModule_AutoSync(DataModule).Timer_Close.Enabled := True
//    else
//     	TDataModule_AutoSync(DataModule).Timer_Execute.Enabled := True;


    { TFSYGlobals.Create interna e automaticamente carrega as configura��es,
    mas neste caso espec�fico o arquivo de configura��o n�o se encontra no local
    padr�o por isso devemos executar novamente o m�todo "ReadConfigurations"
    passando como par�metro o caminho para o arquivo de configura��o }
    TBDODataModule_AutoSync(CreateParameters.MyDataModule).ReadFTPConfigurations;

  	TBDODataModule_AutoSync(CreateParameters.MyDataModule).FtpClient_AutoSync.LocalFileName := TBDODataModule_AutoSync(CreateParameters.MyDataModule).FSYGlobals.FTPDirectory + '\fakefile.sql';

  	TBDODataModule_AutoSync(CreateParameters.MyDataModule).Busy := True;
  	TBDODataModule_AutoSync(CreateParameters.MyDataModule).Busy := False;

	if TBDODataModule_AutoSync(CreateParameters.MyDataModule).GeneralResult <> mrAbort then
     	TBDODataModule_AutoSync(CreateParameters.MyDataModule).Timer_Execute.Enabled := True;
end;

end.
