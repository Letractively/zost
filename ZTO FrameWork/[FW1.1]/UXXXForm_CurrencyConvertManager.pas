unit UXXXForm_CurrencyConvertManager;

interface

uses
    Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
    Dialogs, UXXXForm_DialogTemplate, ActnList, ExtCtrls, StdCtrls, Buttons, Grids,
    UXXXTypesConstantsAndClasses, OverByteIcsHttpProt, ImgList, CurrencyConvertor;

type
    TXXXForm_CurrencyConvertManager = class(TXXXForm_DialogTemplate)
        StringGridCotacoes: TStringGrid;
        BitBtn_Confirmar: TBitBtn;
        BitBtn_Cancelar: TBitBtn;
        PanelMoedaDeDestino: TPanel;
        SpeedButton_WS_CopiarDolar: TSpeedButton;
        SpeedButton_WS_CopiarEuro: TSpeedButton;
        SpeedButton_WS_CopiarLibra: TSpeedButton;
        SpeedButton_WS_CopiarReal: TSpeedButton;
        SpeedButton_WS_CopiarIene: TSpeedButton;
        Action_WS_CopiarDolar: TAction;
        Action_WS_CopiarEuro: TAction;
        Action_WS_CopiarReal: TAction;
        Action_WS_CopiarLibra: TAction;
        Action_WS_CopiarIene: TAction;
        ImageList1: TImageList;
        Label_WS_Dolar: TLabel;
        Label_WS_Euro: TLabel;
        Label_WS_Real: TLabel;
        Label_WS_Libra: TLabel;
        Label_WS_Iene: TLabel;
        SpeedButton1: TSpeedButton;
        SpeedButton2: TSpeedButton;
        SpeedButton3: TSpeedButton;
        SpeedButton4: TSpeedButton;
        SpeedButton5: TSpeedButton;
        Action_WS_ObterDolar: TAction;
        Action_WS_ObterEuro: TAction;
        Action_WS_ObterReal: TAction;
        Action_WS_ObterLibra: TAction;
        Action_WS_ObterIene: TAction;
        procedure BitBtn_ConfirmarClick(Sender: TObject);
        procedure FormShow(Sender: TObject);
        procedure StringGridCotacoesKeyPress(Sender: TObject; var Key: Char);
        procedure PanelMoedaDeDestinoClick(Sender: TObject);
        procedure Action_WS_ObterDolarExecute(Sender: TObject);
        procedure Action_WS_ObterEuroExecute(Sender: TObject);
        procedure Action_WS_ObterRealExecute(Sender: TObject);
        procedure Action_WS_ObterLibraExecute(Sender: TObject);
        procedure Action_WS_ObterIeneExecute(Sender: TObject);
        procedure Action_WS_CopiarDolarExecute(Sender: TObject);
        procedure Action_WS_CopiarEuroExecute(Sender: TObject);
        procedure Action_WS_CopiarRealExecute(Sender: TObject);
        procedure Action_WS_CopiarLibraExecute(Sender: TObject);
        procedure Action_WS_CopiarIeneExecute(Sender: TObject);
    private
        { Private declarations }
        FDestinationCurrencyID: CurrencyID;
        procedure LoadStringGrid;
        function GetCotacoes: AnsiString;
        procedure SetCotacoes(const Value: AnsiString);
        procedure SetDestinationCurrency(const Value: Byte);
    public
        { Public declarations }
        property Cotacoes: AnsiString read GetCotacoes write SetCotacoes;
        property DestinationCurrency: Byte write SetDestinationCurrency;
    end;

implementation

uses
  AnsiStrings;

const
    CURRENCY_IDS: array [1..5] of CurrencyID = (USD,EUR,BRL,GBP,JPY);

{$R *.dfm}

procedure TXXXForm_CurrencyConvertManager.Action_WS_CopiarDolarExecute(Sender: TObject);
begin
    inherited;
    StringGridCotacoes.Cells[2,0] := Label_WS_Dolar.Caption;
end;

procedure TXXXForm_CurrencyConvertManager.Action_WS_CopiarEuroExecute(Sender: TObject);
begin
    inherited;
    StringGridCotacoes.Cells[2,1] := Label_WS_Euro.Caption;
end;

procedure TXXXForm_CurrencyConvertManager.Action_WS_CopiarIeneExecute(Sender: TObject);
begin
    inherited;
    StringGridCotacoes.Cells[2,4] := Label_WS_Iene.Caption;
end;

procedure TXXXForm_CurrencyConvertManager.Action_WS_CopiarLibraExecute(Sender: TObject);
begin
    inherited;
    StringGridCotacoes.Cells[2,3] := Label_WS_Libra.Caption;
end;

procedure TXXXForm_CurrencyConvertManager.Action_WS_CopiarRealExecute(Sender: TObject);
begin
    inherited;
    StringGridCotacoes.Cells[2,2] := Label_WS_Real.Caption;
end;

procedure TXXXForm_CurrencyConvertManager.Action_WS_ObterDolarExecute(Sender: TObject);
begin
    inherited;
    Label_WS_Dolar.Caption := FormatFloat('##0.0000',GetCurrencyConvertorSoap.ConversionRate(USD,FDestinationCurrencyID));
    Action_WS_CopiarDolar.Enabled := StrToFloat(Label_WS_Dolar.Caption) > 0;
end;

procedure TXXXForm_CurrencyConvertManager.Action_WS_ObterEuroExecute(Sender: TObject);
begin
    inherited;
    Label_WS_Euro.Caption := FormatFloat('##0.0000',GetCurrencyConvertorSoap.ConversionRate(EUR,FDestinationCurrencyID));
    Action_WS_CopiarEuro.Enabled := StrToFloat(Label_WS_Euro.Caption) > 0;
end;

procedure TXXXForm_CurrencyConvertManager.Action_WS_ObterIeneExecute(Sender: TObject);
begin
    inherited;
    Label_WS_Iene.Caption := FormatFloat('##0.0000',GetCurrencyConvertorSoap.ConversionRate(JPY,FDestinationCurrencyID));
    Action_WS_CopiarIene.Enabled := StrToFloat(Label_WS_Iene.Caption) > 0;
end;

procedure TXXXForm_CurrencyConvertManager.Action_WS_ObterLibraExecute(Sender: TObject);
begin
    inherited;
    Label_WS_Libra.Caption := FormatFloat('##0.0000',GetCurrencyConvertorSoap.ConversionRate(GBP,FDestinationCurrencyID));
    Action_WS_CopiarLibra.Enabled := StrToFloat(Label_WS_Libra.Caption) > 0;
end;

procedure TXXXForm_CurrencyConvertManager.Action_WS_ObterRealExecute(Sender: TObject);
begin
    inherited;
    Label_WS_Real.Caption := FormatFloat('##0.0000',GetCurrencyConvertorSoap.ConversionRate(BRL,FDestinationCurrencyID));
    Action_WS_CopiarReal.Enabled := StrToFloat(Label_WS_Real.Caption) > 0;
end;

procedure TXXXForm_CurrencyConvertManager.BitBtn_ConfirmarClick(Sender: TObject);
    function ValidateValues: Boolean;
    var
        i: Byte;
    begin
        Result := False;
        for i := 0 to Pred(StringGridCotacoes.RowCount) do
        begin
            try
            	if StringGridCotacoes.Cells[2,i] = '' then
	                StringGridCotacoes.Cells[2,i] := '1,0000';

                StrToFloat(StringGridCotacoes.Cells[2,i]);
				Result := True;
            except
    	      	on EConvertError do
        	    begin
        			MessageBox(Handle,'O valor especificado é inválido. Por favor corrija-o','Valor inválido',MB_ICONERROR);
	                StringGridCotacoes.Col := 2;
    	            StringGridCotacoes.Row := i;
                    Result := False;
                    Break;
        	    end;
    		end;
        end;

    end;
begin
  	inherited;
	if ValidateValues then
    	ModalResult := mrOk;
end;

procedure TXXXForm_CurrencyConvertManager.FormShow(Sender: TObject);
begin
    inherited;
    StringGridCotacoes.ColWidths[0] := 110;
    StringGridCotacoes.ColWidths[1] := 50;
    StringGridCotacoes.ColWidths[2] := 73;
    PanelMoedaDeDestino.Left := StringGridCotacoes.Left + StringGridCotacoes.ColWidths[0] + 3;
    LoadStringGrid;
end;

function TXXXForm_CurrencyConvertManager.GetCotacoes: AnsiString;
var
	i: Byte;
    FormatSettings: TFormatSettings;
begin
	Result := '';
    GetLocaleFormatSettings(((SORT_DEFAULT shl 16) or (SUBLANG_ENGLISH_US shl 10) or LANG_ENGLISH),FormatSettings);

	for i := 0 to Pred(StringGridCotacoes.RowCount) do
    begin
    	if StringGridCotacoes.Cells[2,i] = '' then
	        Result := Result + '1.0000'
        else
			Result := Result + AnsiString(FormatFloat('#0.0000',StrToFloat(StringGridCotacoes.Cells[2,i]),FormatSettings));

        if i < Pred(StringGridCotacoes.RowCount) then
	        Result := Result + ';'
    end;
end;

procedure TXXXForm_CurrencyConvertManager.LoadStringGrid;
var
  i: Byte;
begin
  for i := 1 to High(CURRENCY_STRINGS) do
    StringGridCotacoes.Cells[0,Pred(i)] := String(CURRENCY_STRINGS[i]) + ' 1,00 =';
end;


procedure TXXXForm_CurrencyConvertManager.PanelMoedaDeDestinoClick(Sender: TObject);
begin
  inherited;
{
u can use MSSOAP.SoapClient ole object to run the webservice

SoapClient := CreateOleObject('MSSOAP.SoapClient');
SoapClient.mssoapinit('https://localhost/service/cal?wsdl','calc','calcSoap');
showmessage(SoapClient.GetResult);
}

end;

procedure TXXXForm_CurrencyConvertManager.SetCotacoes(const Value: AnsiString);
var
	i: Byte;
    FormatSettings: TFormatSettings;
begin
    with TStringList.Create do
        try
        	GetLocaleFormatSettings(((SORT_DEFAULT shl 16) or (SUBLANG_ENGLISH_US shl 10) or LANG_ENGLISH),FormatSettings);
        	Delimiter := ';';

            if Value = '' then
                DelimitedText := '1;1;1;1;1'
            else
                DelimitedText := String(Value);

            for i := 0 to Pred(Count) do
				StringGridCotacoes.Cells[2,i] := FormatFloat('#0.0000',StrToFloat(Strings[i],FormatSettings));
        finally
           Free;
        end;
end;

procedure TXXXForm_CurrencyConvertManager.SetDestinationCurrency(const Value: Byte);
begin
    PanelMoedaDeDestino.Caption := String(CURRENCY_STRINGS[Value]);
    FDestinationCurrencyID := CURRENCY_IDS[Value];
end;

procedure TXXXForm_CurrencyConvertManager.StringGridCotacoesKeyPress(Sender: TObject; var Key: Char);
begin
    inherited;
    Key := Char(CreateParameters.MyDataModule.AllowedChars(AnsiChar(Key),['0'..'9',#8,DecimalSeparator]));
end;

end.
