unit UBDOForm_JustificativaParaObra;

interface

uses
    Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
    Dialogs, UXXXForm_DialogTemplate, ActnList, ExtCtrls, StdCtrls, Buttons,
    ComCtrls;

type
    TBDOForm_JustificativaParaObra = class(TXXXForm_DialogTemplate)
        Label_JustificativasSelecionadas: TLabel;
        BitBtn_Justificar: TBitBtn;
        BitBtn1: TBitBtn;
        Label_JustificativasDisponveis: TLabel;
        ListView_JustificativasDisponiveis: TListView;
        ListView_JustificativasSelecionadas: TListView;
        SpeedButton_Adicionar: TSpeedButton;
        SpeedButton_Remover: TSpeedButton;
        Action_Adicionar: TAction;
        Action_Remover: TAction;
        Action_Justificar: TAction;
        procedure FormCreate(Sender: TObject);
        procedure DoCustomDrawItem(Sender: TCustomListView; Item: TListItem; State: TCustomDrawState; var DefaultDraw: Boolean);
        procedure ListView_JustificativasDisponiveisDblClick(Sender: TObject);
        procedure Action_AdicionarExecute(Sender: TObject);
        procedure Action_RemoverExecute(Sender: TObject);
        procedure ListView_JustificativasSelecionadasDblClick(Sender: TObject);
        procedure DoChange(Sender: TObject; Item: TListItem; Change: TItemChange);
        procedure Action_JustificarExecute(Sender: TObject);
    private
        { Private declarations }
        OriginalLVWndProc1, OriginalLVWndProc2: TWndMethod;
        procedure CarregarJustificativas;
        procedure AdicionarJustificativas;
        procedure CustomizedLVWndProc1(var Message: TMessage);
        procedure CustomizedLVWndProc2(var Message: TMessage);
        procedure RemoverJustificativas;
    public
        { Public declarations }
    end;

implementation

uses
    UBDODataModule_Obras;

{$R *.dfm}

{ TBDOForm_JustificativaParaObra }

procedure TBDOForm_JustificativaParaObra.Action_AdicionarExecute(Sender: TObject);
begin
    inherited;
    AdicionarJustificativas;
end;

procedure TBDOForm_JustificativaParaObra.Action_JustificarExecute(Sender: TObject);
begin
    inherited;
    if ListView_JustificativasSelecionadas.Items.Count = 0 then
    begin
        MessageBox(Handle,'Justificativas tem de ser selecionadas. Caso queira cancelar a operação, clique o botão "Cancelar"','Nenhuma justificativa informada',MB_ICONWARNING);
        ModalResult := mrNone
    end
    else
        ModalResult := mrOk;
end;

procedure TBDOForm_JustificativaParaObra.Action_RemoverExecute(Sender: TObject);
begin
    inherited;
    RemoverJustificativas;
end;

procedure TBDOForm_JustificativaParaObra.AdicionarJustificativas;
var
    i: Word;
    SelectedCount: Word;
begin
    if ListView_JustificativasDisponiveis.SelCount > 0 then
    begin
        SelectedCount := ListView_JustificativasDisponiveis.SelCount;
        
        for i := 0 to Pred(ListView_JustificativasDisponiveis.Items.Count) do
            if ListView_JustificativasDisponiveis.Items[i].Selected then
            begin
                Dec(SelectedCount);

                with ListView_JustificativasSelecionadas.Items.Add do
                begin
                    Data := ListView_JustificativasDisponiveis.Items[i].Data;
                    Caption := ListView_JustificativasDisponiveis.Items[i].Caption;
                    SubItems.Add(ListView_JustificativasDisponiveis.Items[i].SubItems[0]);
                end;

                if SelectedCount = 0 then
                    Break;
            end;

        ListView_JustificativasDisponiveis.DeleteSelected;
    end;
end;

procedure TBDOForm_JustificativaParaObra.RemoverJustificativas;
var
    i: Word;
    SelectedCount: Word;
begin
    if ListView_JustificativasSelecionadas.SelCount > 0 then
    begin
        SelectedCount := ListView_JustificativasSelecionadas.SelCount;
    
        for i := 0 to Pred(ListView_JustificativasSelecionadas.Items.Count) do
            if ListView_JustificativasSelecionadas.Items[i].Selected then
            begin
                Dec(SelectedCount);

                with ListView_JustificativasDisponiveis.Items.Add do
                begin
                    Data := ListView_JustificativasSelecionadas.Items[i].Data;
                    Caption := ListView_JustificativasSelecionadas.Items[i].Caption;
                    SubItems.Add(ListView_JustificativasSelecionadas.Items[i].SubItems[0]);
                end;
                
                if SelectedCount = 0 then
                    Break;
            end;
            
        ListView_JustificativasSelecionadas.DeleteSelected;
    end;
end;

procedure TBDOForm_JustificativaParaObra.CarregarJustificativas;
var
    Justificativas: TStringList;
    i: Word;
begin
    Justificativas := nil;
    try
        Justificativas := TStringList.Create;
        TBDODataModule_Obras(CreateParameters.MyDataModule).ObterJustificativas(Justificativas);

        if Justificativas.Count > 0 then
            for i := 0 to Pred(Justificativas.Count) do
                with ListView_JustificativasDisponiveis.Items.Add do
                begin
                    Data := Justificativas.Objects[i];
                    Caption := Copy(Justificativas[i],1,Pred(Pos('|',Justificativas[i])));
                    SubItems.Add(Copy(Justificativas[i],Succ(Pos('|',Justificativas[i])),Length(Justificativas[i])));
                end;
    finally
        if Assigned(Justificativas) then
            Justificativas.Free;
    end;
end;

procedure TBDOForm_JustificativaParaObra.FormCreate(Sender: TObject);
begin
    inherited;
    CarregarJustificativas;
    OriginalLVWndProc1 := ListView_JustificativasDisponiveis.WindowProc;
    ListView_JustificativasDisponiveis.WindowProc := CustomizedLVWndProc1;

    OriginalLVWndProc2 := ListView_JustificativasSelecionadas.WindowProc;
    ListView_JustificativasSelecionadas.WindowProc := CustomizedLVWndProc2;
end;

procedure TBDOForm_JustificativaParaObra.ListView_JustificativasDisponiveisDblClick(Sender: TObject);
begin
    inherited;
    Action_Adicionar.Execute;
end;

procedure TBDOForm_JustificativaParaObra.ListView_JustificativasSelecionadasDblClick(Sender: TObject);
begin
    inherited;
    Action_Remover.Execute;
end;

procedure TBDOForm_JustificativaParaObra.CustomizedLVWndProc1(var Message: TMessage);
const
	HDN_FIRST = -300;
    HDN_BEGINTRACKA = HDN_FIRST - 6;
    HDN_BEGINTRACKW = HDN_FIRST - 26;
begin
    if Message.Msg = WM_NOTIFY then
    begin
        case PNMHdr(Message.LParam).Code of
            HDN_BEGINTRACKW, HDN_BEGINTRACKA: begin
            	Message.Result := 1;
                Exit;
            end;
        end
    end;
	OriginalLVWndProc1(Message);
end;

procedure TBDOForm_JustificativaParaObra.CustomizedLVWndProc2(var Message: TMessage);
const
	HDN_FIRST = -300;
    HDN_BEGINTRACKA = HDN_FIRST - 6;
    HDN_BEGINTRACKW = HDN_FIRST - 26;
begin
    if Message.Msg = WM_NOTIFY then
    begin
        case PNMHdr(Message.LParam).Code of
            HDN_BEGINTRACKW, HDN_BEGINTRACKA: begin
            	Message.Result := 1;
                Exit;
            end;
        end
    end;
	OriginalLVWndProc2(Message);
end;

procedure TBDOForm_JustificativaParaObra.DoChange(Sender: TObject; Item: TListItem; Change: TItemChange);
begin
    inherited;
    Action_Adicionar.Enabled := ListView_JustificativasDisponiveis.SelCount > 0;
    Action_Remover.Enabled := ListView_JustificativasSelecionadas.SelCount > 0;
end;

procedure TBDOForm_JustificativaParaObra.DoCustomDrawItem(Sender: TCustomListView; Item: TListItem; State: TCustomDrawState; var DefaultDraw: Boolean);
begin
    inherited;
    if Odd(Item.Index) then
        Sender.Canvas.Brush.Color := clWindow
    else
        Sender.Canvas.Brush.Color := clBtnFace;
end;

end.
