unit UBDOForm_Relatorio_EQP;

interface

uses
    Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
    Dialogs, UBDOForm_GeradorDeRelatorio, ActnList, ComCtrls, ExtCtrls, Buttons,
    StdCtrls, CheckLst, DBCtrls, Menus, ActnPopup;

type
    TBDOForm_Relatorio_EQP = class(TBDOForm_GeradorDeRelatorio)
        Label1: TLabel;
        CheckListBox_Opcoes: TCheckListBox;
        Shape2: TShape;
        CheckBox_DA_DATADEENTRADA1: TCheckBox;
        CheckBox_DA_DATADEENTRADA2: TCheckBox;
        DateTimePicker_DA_DATADEENTRADA2: TDateTimePicker;
        DateTimePicker_DA_DATADEENTRADA1: TDateTimePicker;
        CheckBox_ExibirQuantidadesParciais: TCheckBox;
        CheckBox_ExibirQuantidadesTotaisParciais: TCheckBox;
        CheckBox_ExibirQuantidadesTotaisPorSituacao: TCheckBox;
        Bevel2: TBevel;
        CheckBox_ExibirTotalGeral: TCheckBox;
        CheckBox_ExibirPeriodo: TCheckBox;
        RadioButton_LisagemPorSituacao: TRadioButton;
        Action_MarcarTodasAsOpcoes: TAction;
        PopupActionBar_OpcoesDeChecagem: TPopupActionBar;
        MenuItem_ChecarTodas: TMenuItem;
        MenuItem_InverterChecagens: TMenuItem;
        N1: TMenuItem;
        MenuItem_SomenteGanhasPerdidasSuspensas: TMenuItem;
        MenuItem_SomenteGanhas: TMenuItem;
        MenuItem_SomentePerdidas: TMenuItem;
        MenuItem_SomenteSuspensas: TMenuItem;
        Action_InverterMarcas: TAction;
        Action_MarcarGPS: TAction;
        Action_MarcarG: TAction;
        Action_MarcarP: TAction;
        Action_MarcarS: TAction;
        RadioButton_PorPrevisaoDeEntrega: TRadioButton;
        ComboBox_Ano: TComboBox;
        ComboBox_Mes: TComboBox;
        CheckListBox_Voltagens: TCheckListBox;
        Label_VoltagensAExibir: TLabel;
        procedure FormCreate(Sender: TObject);
        procedure CheckBox_DA_DATADEENTRADA1Click(Sender: TObject);
        procedure Action_MarcarTodasAsOpcoesExecute(Sender: TObject);
        procedure Action_InverterMarcasExecute(Sender: TObject);
        procedure Action_MarcarGPSExecute(Sender: TObject);
        procedure Action_MarcarGExecute(Sender: TObject);
        procedure Action_MarcarPExecute(Sender: TObject);
        procedure Action_MarcarSExecute(Sender: TObject);
        procedure DoRecarregar(Sender: TObject);
        procedure PopupActionBar_OpcoesDeChecagemPopup(Sender: TObject);
    private
        { Private declarations }
        FRecarregar: Boolean;
        procedure MarcarTodasAsOpcoes(const aCheckListBox: TCheckListBox);
    protected
        procedure DoBeforeNavigate2(      ASender: TObject;
                                    const pDisp: IDispatch;
                                      var URL
                                        , Flags
                                        , TargetFrameName
                                        , PostData
                                        , Headers: OleVariant;
                                      var Cancel: WordBool); override;
    public
        { Public declarations }
    end;

implementation

uses
    UBDODataModule_Relatorio_EQP, DateUtils;

{$R *.dfm}

procedure TBDOForm_Relatorio_EQP.Action_MarcarGExecute(Sender: TObject);
var
    i: Word;
begin
    inherited;
	if CheckListBox_Opcoes.Count > 0 then
		for i := 0 to Pred(CheckListBox_Opcoes.Count) do
        	CheckListBox_Opcoes.Checked[i] := UpperCase(CheckListBox_Opcoes.Items[i]) = 'GANHA';

	DoRecarregar(Sender);
end;

procedure TBDOForm_Relatorio_EQP.Action_MarcarGPSExecute(Sender: TObject);
var
    i: Word;
begin
    inherited;
	if CheckListBox_Opcoes.Count > 0 then
		for i := 0 to Pred(CheckListBox_Opcoes.Count) do
        	CheckListBox_Opcoes.Checked[i] :=
            (UpperCase(CheckListBox_Opcoes.Items[i]) = 'GANHA') or
            (UpperCase(CheckListBox_Opcoes.Items[i]) = 'PERDIDA') or
            (UpperCase(CheckListBox_Opcoes.Items[i]) = 'SUSPENSA');

	DoRecarregar(Sender);
end;

procedure TBDOForm_Relatorio_EQP.Action_MarcarPExecute(Sender: TObject);
var
    i: Word;
begin
    inherited;
	if CheckListBox_Opcoes.Count > 0 then
		for i := 0 to Pred(CheckListBox_Opcoes.Count) do
        	CheckListBox_Opcoes.Checked[i] := UpperCase(CheckListBox_Opcoes.Items[i]) = 'PERDIDA';

	DoRecarregar(Sender);
end;

procedure TBDOForm_Relatorio_EQP.Action_MarcarSExecute(Sender: TObject);
var
    i: Word;
begin
    inherited;
	if CheckListBox_Opcoes.Count > 0 then
		for i := 0 to Pred(CheckListBox_Opcoes.Count) do
        	CheckListBox_Opcoes.Checked[i] := UpperCase(CheckListBox_Opcoes.Items[i]) = 'SUSPENSA';

	DoRecarregar(Sender);
end;

procedure TBDOForm_Relatorio_EQP.Action_MarcarTodasAsOpcoesExecute(Sender: TObject);
begin
    inherited;
    MarcarTodasAsOpcoes(TCheckListBox(TPopUpActionBar(TMenuItem(Taction(Sender).actioncomponent).GetParentMenu).PopupComponent));
	DoRecarregar(Sender);
end;

procedure TBDOForm_Relatorio_EQP.Action_InverterMarcasExecute(Sender: TObject);
var
    i: Word;
    CLB: TCheckListBox;
begin
    CLB := TCheckListBox(TPopUpActionBar(TMenuItem(Taction(Sender).actioncomponent).GetParentMenu).PopupComponent);
    inherited;
	if CLB.Count > 0 then
		for i := 0 to Pred(CLB.Count) do
        	CLB.Checked[i] := not CLB.Checked[i];

	DoRecarregar(Sender);
end;


procedure TBDOForm_Relatorio_EQP.CheckBox_DA_DATADEENTRADA1Click(Sender: TObject);
begin
    inherited;
    DateTimePicker_DA_DATADEENTRADA1.Enabled := CheckBox_DA_DATADEENTRADA1.Checked;
    DateTimePicker_DA_DATADEENTRADA2.Enabled := CheckBox_DA_DATADEENTRADA2.Checked;

    ComboBox_Ano.Enabled := CheckBox_DA_DATADEENTRADA1.Checked;
    ComboBox_Mes.Enabled := CheckBox_DA_DATADEENTRADA2.Checked;

	DoRecarregar(Sender);
end;

procedure TBDOForm_Relatorio_EQP.DoBeforeNavigate2(      ASender: TObject;
                                                   const pDisp: IDispatch;
                                                     var URL
                                                       , Flags
                                                       , TargetFrameName
                                                       , PostData
                                                       , Headers: OleVariant;
                                                     var Cancel: WordBool);
var
	Ids: String;
    Ano: Word;
    Equipamento: Cardinal;
    Voltagem, Mes: Byte;
begin
  	inherited;
    Ids := ExtractFileName(StringReplace(URL,'/','\',[rfReplaceAll]));
    if Pos('@',Ids) = 1 then
    begin
        { Remove o @ inicial }
        Delete(Ids,1,1);

        { Carrega cada parte da string em uma linha do stringlist e depois
        coloca cada linha em uma variável separada }
        with TStringList.Create do
            try
                CommaText := Ids;
                Mes := StrToInt(Strings[0]);
                Ano := StrToInt(Strings[1]);
                Equipamento := StrToInt(Strings[2]);
                Voltagem := StrToInt(Strings[3]);
            finally
                Free;
            end;

    	TBDODataModule_Relatorio_EQP(CreateParameters.MyDataModule).ExibirInformacoesDoEquipamento(Mes,Ano,Equipamento,Voltagem);
        Cancel := True;
    end;
end;

procedure TBDOForm_Relatorio_EQP.DoRecarregar(Sender: TObject);
begin
    inherited;

    DateTimePicker_DA_DATADEENTRADA1.Visible := RadioButton_LisagemPorSituacao.Checked;
    ComboBox_Ano.Visible := not DateTimePicker_DA_DATADEENTRADA1.Visible;

    DateTimePicker_DA_DATADEENTRADA2.Visible := RadioButton_LisagemPorSituacao.Checked;
    ComboBox_Mes.Visible := not DateTimePicker_DA_DATADEENTRADA2.Visible;

    CheckBox_ExibirQuantidadesParciais.Enabled := RadioButton_LisagemPorSituacao.Checked;
    CheckBox_ExibirQuantidadesTotaisPorSituacao.Enabled := RadioButton_LisagemPorSituacao.Checked;
    CheckBox_ExibirPeriodo.Enabled := RadioButton_LisagemPorSituacao.Checked;

    if RadioButton_LisagemPorSituacao.Checked then
    begin
        CheckBox_DA_DATADEENTRADA1.Caption := 'No período de';
        CheckBox_DA_DATADEENTRADA1.Width := 89;
        CheckBox_DA_DATADEENTRADA1.Left := 432;
        CheckBox_DA_DATADEENTRADA2.Caption := 'até';

        Label1.Caption := 'Situações a exibir';
        if Sender = RadioButton_LisagemPorSituacao then
        begin
            DateTimePicker_DA_DATADEENTRADA1.Date := StartOfAYear(YearOf(Now));
            DateTimePicker_DA_DATADEENTRADA2.Date := EndOfTheDay(Now);
            try
                CheckBox_DA_DATADEENTRADA1.OnClick := nil;
                CheckBox_DA_DATADEENTRADA2.OnClick := nil;
                CheckBox_DA_DATADEENTRADA1.Checked := False;
                CheckBox_DA_DATADEENTRADA2.Checked := False;
                DateTimePicker_DA_DATADEENTRADA1.Enabled := False;
                DateTimePicker_DA_DATADEENTRADA2.Enabled := False;
            finally
                CheckBox_DA_DATADEENTRADA1.OnClick := CheckBox_DA_DATADEENTRADA1Click;
                CheckBox_DA_DATADEENTRADA2.OnClick := CheckBox_DA_DATADEENTRADA1Click;
            end;
            TBDODataModule_Relatorio_EQP(CreateParameters.MyDataModule).ObterSituacoes(CheckListBox_Opcoes.Items);
        end;

    end
    else if RadioButton_PorPrevisaoDeEntrega.Checked then
    begin
        CheckBox_DA_DATADEENTRADA1.Caption := 'Ano';
        CheckBox_DA_DATADEENTRADA1.Width := 38;
        CheckBox_DA_DATADEENTRADA1.Left := 483;
        CheckBox_DA_DATADEENTRADA2.Caption := 'Mês';

        if Sender = RadioButton_PorPrevisaoDeEntrega then
        begin
            ComboBox_Ano.ItemIndex := ComboBox_Ano.Items.IndexOf(IntToStr(YearOf(Now)));
            ComboBox_Mes.ItemIndex := Pred(MonthOf(Now));
            try
                CheckBox_DA_DATADEENTRADA1.OnClick := nil;
                CheckBox_DA_DATADEENTRADA2.OnClick := nil;
                CheckBox_DA_DATADEENTRADA1.Checked := False;
                CheckBox_DA_DATADEENTRADA2.Checked := False;
                ComboBox_Ano.Enabled := False;
                ComboBox_Mes.Enabled := False;
            finally
                CheckBox_DA_DATADEENTRADA1.OnClick := CheckBox_DA_DATADEENTRADA1Click;
                CheckBox_DA_DATADEENTRADA2.OnClick := CheckBox_DA_DATADEENTRADA1Click;
            end;
            TBDODataModule_Relatorio_EQP(CreateParameters.MyDataModule).ObterVoltagens(CheckListBox_Voltagens.Items);
        end;
    end;

    if (Sender = RadioButton_LisagemPorSituacao) or (Sender = RadioButton_PorPrevisaoDeEntrega) then
    begin
        MarcarTodasAsOpcoes(CheckListBox_Opcoes);
        MarcarTodasAsOpcoes(CheckListBox_Voltagens);
    end;

//    if FRecarregar then
//        Action_Regerar.Execute;
end;

procedure TBDOForm_Relatorio_EQP.MarcarTodasAsOpcoes(const aCheckListBox: TCheckListBox);
var
    i: Word;
begin
    if aCheckListBox.Count > 0 then
        for i := 0 to Pred(aCheckListBox.Count) do
            aCheckListBox.Checked[i] := True;
end;

procedure TBDOForm_Relatorio_EQP.PopupActionBar_OpcoesDeChecagemPopup(Sender: TObject);
begin
    inherited;
    MenuItem_SomenteGanhasPerdidasSuspensas.Visible := PopupActionBar_OpcoesDeChecagem.PopupComponent = CheckListBox_Opcoes;
    MenuItem_SomenteGanhas.Visible := PopupActionBar_OpcoesDeChecagem.PopupComponent = CheckListBox_Opcoes;
    MenuItem_SomentePerdidas.Visible := PopupActionBar_OpcoesDeChecagem.PopupComponent = CheckListBox_Opcoes;
    MenuItem_SomenteSuspensas.Visible := PopupActionBar_OpcoesDeChecagem.PopupComponent = CheckListBox_Opcoes;
end;

procedure TBDOForm_Relatorio_EQP.FormCreate(Sender: TObject);
var
    i: Word;
begin
    inherited;

    ComboBox_Ano.Items.Clear;
    for i := 2005 to YearOf(Now) + 1 do
        ComboBox_Ano.Items.Add(IntToStr(i));

//    ComboBox_Ano.ItemIndex := ComboBox_Ano.Items.IndexOf(IntToStr(YearOf(Now)));
//    ComboBox_Mes.ItemIndex := Pred(MonthOf(Now));

    try
        FRecarregar := False;
        { É preciso inicializar aqui por que ao terminar o evento create o
        Framework irá gerar o relatório com estas opções }
        DateTimePicker_DA_DATADEENTRADA1.Date := StartOfAYear(YearOf(Now));
        DateTimePicker_DA_DATADEENTRADA2.Date := EndOfTheDay(Now);
        TBDODataModule_Relatorio_EQP(CreateParameters.MyDataModule).ObterSituacoes(CheckListBox_Opcoes.Items);
        TBDODataModule_Relatorio_EQP(CreateParameters.MyDataModule).ObterVoltagens(CheckListBox_Voltagens.Items);

        MarcarTodasAsOpcoes(CheckListBox_Opcoes);
        MarcarTodasAsOpcoes(CheckListBox_Voltagens);
        DoRecarregar(Sender);
    finally
        FRecarregar := True;
    end;
end;

end.
