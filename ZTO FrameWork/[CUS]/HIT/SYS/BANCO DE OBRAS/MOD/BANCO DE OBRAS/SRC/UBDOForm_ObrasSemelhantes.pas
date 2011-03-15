unit UBDOForm_ObrasSemelhantes;

interface

uses
    Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
    Dialogs, UXXXForm_DialogTemplate, ActnList, ExtCtrls, StdCtrls, Grids,
    UCFDBGrid, Buttons, ComCtrls, DBGrids;

type
    TBDOForm_ObrasSemelhantes = class(TXXXForm_DialogTemplate)
        BitBtn_Usar: TBitBtn;
        BitBtn_Cancelar: TBitBtn;
        PageControl_ObrasSemelhantes: TPageControl;
        TabSheet_SentencaParcial: TTabSheet;
        TabSheet_PalavrasIndividuais: TTabSheet;
        CFDBGrid_OBR_SentencaParcial: TCFDBGrid;
        CFDBGrid_OBR_PalavrasIndividuais: TCFDBGrid;
        Panel_SentencaParcial: TPanel;
        StaticText_SentencaParcial: TLabel;
        Panel_PalavrasIndividuais: TPanel;
        Label_PalavrasIndividuais: TLabel;
        procedure DoCFDBGridDblClick(Sender: TObject);
        procedure FormShow(Sender: TObject);
    private
        { Private declarations }
    public
        { Public declarations }
    end;

implementation

uses
    UBDODataModule_Obras;

{$R *.dfm}

{ TBDOForm_ObrasSemelhantes }


procedure TBDOForm_ObrasSemelhantes.DoCFDBGridDblClick(Sender: TObject);
begin
    inherited;
    ModalResult := mrOk;
end;

procedure TBDOForm_ObrasSemelhantes.FormShow(Sender: TObject);
begin
    inherited;
    TabSheet_SentencaParcial.Caption := 'Sentença parcial (' + IntToStr(CFDBGrid_OBR_SentencaParcial.DataSource.DataSet.RecordCount) + ' ocorrências)';
    TabSheet_PalavrasIndividuais.Caption := 'Palavras individuais (' + IntToStr(CFDBGrid_OBR_PalavrasIndividuais.DataSource.DataSet.RecordCount) + ' ocorrências)';
end;

end.
