unit UMBRForm_Main;

interface

uses
    Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
    Dialogs, UXXXForm_MainDialogTemplate, ActnList, ExtCtrls, StdCtrls, ComCtrls,
    Buttons, Tabs;

type
    TMBRForm_Main = class(TXXXForm_MainDialogTemplate)
        Action_SalvarConfiguracoes: TAction;
        Button_IniciarMBR: TButton;
        Action_ExibirMBAR: TAction;
        procedure Action_FecharAplicacaoExecute(Sender: TObject);
        procedure Action_ExibirMBARExecute(Sender: TObject);
    private
        { Private declarations }
    public
        { Public declarations }
    end;

implementation

uses
    UMBRDataModule_Main;

{$R *.dfm}

procedure TMBRForm_Main.Action_ExibirMBARExecute(Sender: TObject);
begin
    inherited;
    TMBRDataModule_Main(CreateParameters.MyDataModule).ExibirMBAR;
end;

procedure TMBRForm_Main.Action_FecharAplicacaoExecute(Sender: TObject);
begin
    inherited;
    Close;
end;

end.
