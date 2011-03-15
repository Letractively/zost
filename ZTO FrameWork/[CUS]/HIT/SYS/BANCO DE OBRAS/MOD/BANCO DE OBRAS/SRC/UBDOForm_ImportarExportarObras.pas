unit UBDOForm_ImportarExportarObras;

interface

uses
    Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
    Dialogs, UXXXForm_DialogTemplate, ActnList, ExtCtrls, StdCtrls, ComCtrls,
    Buttons, Grids, UCFDBGrid, _StdCtrls, _DBCtrls, DBGrids;

type
    TBDOForm_ImportarExportarObras = class(TXXXForm_DialogTemplate)
        Action_Exportar: TAction;
        Action_Importar: TAction;
        Action_Inverter: TAction;
        Action_Nenhuma: TAction;
        Action_Todas: TAction;
        Action_Validar: TAction;
        PageControlExportarImportar: TPageControl;
        TabSheetExportar: TTabSheet;
        Label1: TLabel;
        Bevel1: TBevel;
        Shape_OBR_FILTRO_RegistrosValor: TShape;
        Label_OBR_FILTRO_RegistrosValor: TLabel;
        Label_OBR_FILTRO_Registros: TLabel;
        LabelPercent: TLabel;
        Label9: TLabel;
        CFDBGridExportar: TCFDBGrid;
        RadioGroupFiltragem: TRadioGroup;
        BitBtnExportar: TBitBtn;
        ProgressBarExportando: TProgressBar;
        GroupBoxSelecao: TGroupBox;
        ButtonTodas: TButton;
        ButtonNenhuma: TButton;
        ButtonInverterSelecao: TButton;
        GroupBox3: TGroupBox;
        Edit_OBR_FILTRO_VA_NOMEDAOBRA: TEdit;
        TabSheetImportar: TTabSheet;
        Label2: TLabel;
        Bevel2: TBevel;
        LabelStatus: TLabel;
        Label3: TLabel;
        Label4: TLabel;
        Label10: TLabel;
        ListViewImportar: TListView;
        ButtonValidarArquivosDeObra: TButton;
        ButtonImportarObrasSelecionadas: TButton;
        RichEditObservacoes: TRichEdit;
        ProgressBarImportacao: TProgressBar;
        GroupBox1: TGroupBox;
        Image2: TImage;
        Image3: TImage;
        Label7: TLabel;
        Label8: TLabel;
        GroupBox2: TGroupBox;
        Image0: TImage;
        Label5: TLabel;
        Image1: TImage;
        Label6: TLabel;
        procedure Edit_OBR_FILTRO_VA_NOMEDAOBRAKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
        procedure RadioGroupFiltragemClick(Sender: TObject);
        procedure Action_ExportarExecute(Sender: TObject);
        procedure FormShow(Sender: TObject);
        procedure Action_TodasExecute(Sender: TObject);
        procedure Action_NenhumaExecute(Sender: TObject);
        procedure Action_InverterExecute(Sender: TObject);
        procedure DoShowTabSheet(Sender: TObject);
        procedure ListViewImportarChange(Sender: TObject; Item: TListItem; Change: TItemChange);
        procedure FormDestroy(Sender: TObject);
        procedure FormCreate(Sender: TObject);
        procedure Action_ValidarExecute(Sender: TObject);
        procedure Action_ImportarExecute(Sender: TObject);
        procedure ListViewImportarCustomDrawItem(Sender: TCustomListView; Item: TListItem; State: TCustomDrawState; var DefaultDraw: Boolean);
    procedure CFDBGridExportarAfterMultiselect(aSender: TObject;
      aMultiSelectEventTrigger: TMultiSelectEventTrigger);
    private
        { Private declarations }
        OriginalLVWndProc: TWndMethod;
        procedure AutoSelection(Mode: Byte);
        procedure ClearListView;
        procedure CustomizedLVWndProc(var Message: TMessage);
    public
        { Public declarations }
    end;

implementation

uses
    UBDODataModule_ImportarExportarObras, DB, UXXXDataModule;

{$R *.dfm}

procedure TBDOForm_ImportarExportarObras.Action_ExportarExecute(Sender: TObject);
var
    i: Cardinal;
    PathToSaveTo: String;
    PosicaoAtual: TBookmark;
begin
	inherited;
    if CFDBGridExportar.SelectedRows.Count = 0 then
    	MessageBox(Handle,'Não é possível exportar, nenhuma obra foi selecionada','Impossível exportar...',MB_ICONWARNING)
    else
    begin
    	if TBDODataModule_ImportarExportarObras(CreateParameters.MyDataModule).SHBrowseForObject(Self,'Selecione um local para salvamento das obras',
        'Os arquivos de obras serão colocados na pasta especificada aqui. Apenas os 25 primeiros caracteres do nome de cada obra serão us' +
        'ados na geração dos nomes de arquivos respectivos. Arquivos existetentes serão substituídos.',PathToSaveTo) then
        begin
            PosicaoAtual := TBDODataModule_ImportarExportarObras(CreateParameters.MyDataModule).OBRAS_SEARCH.Bookmark;
            TBDODataModule_ImportarExportarObras(CreateParameters.MyDataModule).OBRAS_SEARCH.DisableControls;

            ProgressBarExportando.Min := 0;
            ProgressBarExportando.Max := CFDBGridExportar.SelectedRows.Count;
            LabelPercent.Caption := '0%';
            ProgressBarExportando.Position := 0;

            try
                for i := 0 to Pred(ProgressBarExportando.Max) do
                begin
                    TBDODataModule_ImportarExportarObras(CreateParameters.MyDataModule).OBRAS_SEARCH.Bookmark := CFDBGridExportar.SelectedRows[i];
                    TBDODataModule_ImportarExportarObras(CreateParameters.MyDataModule).ExportarObra(TBDODataModule_ImportarExportarObras(CreateParameters.MyDataModule).OBRAS_SEARCH.Fields[0].AsInteger,TBDODataModule_ImportarExportarObras(CreateParameters.MyDataModule).OBRAS_SEARCH.Fields[1].AsString,PathToSaveTo);
                    ProgressBarExportando.StepIt;
                    LabelPercent.Caption := Format('%d%%',[Round(ProgressBarExportando.Position / ProgressBarExportando.Max * 100)]);
                    Application.ProcessMessages;
                end;
                MessageBox(Handle,PChar(IntToStr(ProgressBarExportando.Max) + ' obra(s) foi(foram) exportada(s) pra a pasta "' + PathToSaveTo + '"'),'Exportação concluída',MB_ICONINFORMATION);
            finally
                TBDODataModule_ImportarExportarObras(CreateParameters.MyDataModule).OBRAS_SEARCH.Bookmark := PosicaoAtual;
                TBDODataModule_ImportarExportarObras(CreateParameters.MyDataModule).OBRAS_SEARCH.EnableControls;
            end;
        end;
    end;
end;

procedure TBDOForm_ImportarExportarObras.DoShowTabSheet(Sender: TObject);
begin
    inherited;
    if TTabSheet(Sender).Name = 'TabSheetImportar' then
    begin
    	if ListViewImportar.Tag = 0 then
        begin
            ListViewImportar.Columns[0].Width := ListViewImportar.Width - GetSystemMetrics(SM_CXVSCROLL) - ListViewImportar.Columns[1].Width - 4 - 1;
            ListViewImportar.Columns[0].MaxWidth := ListViewImportar.Columns[0].Width;
            ListViewImportar.Columns[0].MinWidth := ListViewImportar.Columns[0].MaxWidth;
            ListViewImportar.Columns[1].MaxWidth := ListViewImportar.Columns[1].Width;
            ListViewImportar.Columns[1].MinWidth := ListViewImportar.Columns[1].MaxWidth;
            ListViewImportar.Tag := 1;
        end;
    end
end;

procedure TBDOForm_ImportarExportarObras.Edit_OBR_FILTRO_VA_NOMEDAOBRAKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
begin
    inherited;
	if ([ssCtrl] = Shift) and (Key = 13) then
		TBDODataModule_ImportarExportarObras(CreateParameters.MyDataModule).OBR_FILTRO_Filtrar;
end;


procedure TBDOForm_ImportarExportarObras.FormCreate(Sender: TObject);
var
	Img: TBitmap;
begin
  	inherited;
    Img := TBitmap.Create;
    try
        TBDODataModule_ImportarExportarObras(CreateParameters.MyDataModule).ImageList_Local.GetBitmap(0,Img);
        Image0.Picture.Bitmap.Assign(Img);

    	Img.Width := 0; //Força a limpeza da imagem anterior
        TBDODataModule_ImportarExportarObras(CreateParameters.MyDataModule).ImageList_Local.GetBitmap(1,Img);
        Image1.Picture.Bitmap.Assign(Img);

        Img.Width := 0; //Força a limpeza da imagem anterior
        TBDODataModule_ImportarExportarObras(CreateParameters.MyDataModule).ImageList_Local.GetBitmap(2,Img);
        Image2.Picture.Bitmap.Assign(Img);

        Img.Width := 0; //Força a limpeza da imagem anterior
        TBDODataModule_ImportarExportarObras(CreateParameters.MyDataModule).ImageList_Local.GetBitmap(3,Img);
        Image3.Picture.Bitmap.Assign(Img);
    finally
    	if Assigned(Img) then
        	Img.Free;
    end;

    OriginalLVWndProc := ListViewImportar.WindowProc;
    ListViewImportar.WindowProc := CustomizedLVWndProc;
end;

procedure TBDOForm_ImportarExportarObras.FormDestroy(Sender: TObject);
begin
    inherited;
    ClearListView;
end;

procedure TBDOForm_ImportarExportarObras.FormShow(Sender: TObject);
begin
    inherited;
	RadioGroupFiltragemClick(RadioGroupFiltragem);
end;

procedure TBDOForm_ImportarExportarObras.ListViewImportarChange(Sender: TObject; Item: TListItem; Change: TItemChange);
begin
    inherited;
    if Assigned(Item) then
        if Item.Selected and (Change = ctState) and not ((csDestroying in ComponentState) or (csLoading in ComponentState)) then
        begin
            RichEditObservacoes.Clear;
            RichEditObservacoes.Font.Style := [fsBold];
            case Item.ImageIndex of
                0,2: RichEditObservacoes.Font.Color := clRed;
                1,3: RichEditObservacoes.Font.Color := clGreen;
            end;
            RichEditObservacoes.Text := TBDODataModule_ImportarExportarObras(CreateParameters.MyDataModule).ItemInformation[Item.Index].Observation;
        end;
end;

procedure TBDOForm_ImportarExportarObras.ListViewImportarCustomDrawItem(Sender: TCustomListView; Item: TListItem; State: TCustomDrawState; var DefaultDraw: Boolean);
begin
  inherited;
    if Odd(Item.Index) then
	    Sender.Canvas.Brush.Color := clWindow
    else
    	Sender.Canvas.Brush.Color := CFDBGridExportar.RowColors[0].BackgroundColor;
end;

procedure TBDOForm_ImportarExportarObras.RadioGroupFiltragemClick(Sender: TObject);
begin
    inherited;
    TBDODataModule_ImportarExportarObras(CreateParameters.MyDataModule).OBR_FILTRO_Filtrar;
end;

procedure TBDOForm_ImportarExportarObras.Action_ImportarExecute(Sender: TObject);
var
	LControlState: SmallInt;
begin
  	inherited;
    { Aparentemente a tecla control tem um estado toggle, por isso temos de
    testar se o resuiltado da função é -128 ou -127, pois um deles (-128) está
    com o flag toggle ligado }
    LControlState := GetKeyState(VK_LCONTROL);

	TBDODataModule_ImportarExportarObras(CreateParameters.MyDataModule).ImportarObras((LControlState = -127) or (LControlState = -128));
end;

procedure TBDOForm_ImportarExportarObras.Action_InverterExecute(Sender: TObject);
begin
    inherited;
    AutoSelection(3);
end;

procedure TBDOForm_ImportarExportarObras.Action_NenhumaExecute(Sender: TObject);
begin
    inherited;
    AutoSelection(2);
end;

procedure TBDOForm_ImportarExportarObras.Action_TodasExecute(Sender: TObject);
begin
    inherited;
    AutoSelection(1);
end;

procedure TBDOForm_ImportarExportarObras.Action_ValidarExecute(Sender: TObject);
var
	i: Byte;
begin
	inherited;
    if MessageBox(Handle,'Isso vai limpar a lista de importação. Tem certeza?','Tem certeza?',MB_ICONQUESTION or MB_YESNO) = IdYes then
        if TBDODataModule_ImportarExportarObras(CreateParameters.MyDataModule).OpenDialogSelecionarObras.Execute then
            if TBDODataModule_ImportarExportarObras(CreateParameters.MyDataModule).OpenDialogSelecionarObras.Files.Count > 128 then
                MessageBox(Handle,'Não é possível validar mais que 128 obras de cada vez. Isso é uma limitação proposital de segurança. Por favor escolha um conjunto menor de obras para validar','Muitas obras selecionadas',MB_ICONWARNING)
            else
            begin
                ClearListView;
                ProgressBarImportacao.Min := 0;
                ProgressBarImportacao.Max := TBDODataModule_ImportarExportarObras(CreateParameters.MyDataModule).OpenDialogSelecionarObras.Files.Count;
                LabelStatus.Caption := 'Validando obras... 0%';
                ProgressBarImportacao.Position := 0;


                for i := 0 to Pred(TBDODataModule_ImportarExportarObras(CreateParameters.MyDataModule).OpenDialogSelecionarObras.Files.Count) do
                begin
                    TBDODataModule_ImportarExportarObras(CreateParameters.MyDataModule).ValidarObra(TBDODataModule_ImportarExportarObras(CreateParameters.MyDataModule).OpenDialogSelecionarObras.Files[i]);
                    ProgressBarImportacao.StepIt;
                    LabelStatus.Caption := Format('Validando obras... %d%%',[Round(ProgressBarImportacao.Position / ProgressBarImportacao.Max * 100)]);
                    Application.ProcessMessages;
                end;
            end;
end;

procedure TBDOForm_ImportarExportarObras.AutoSelection(Mode: Byte);
var
    PosicaoAtual: TBookmark;
begin
    PosicaoAtual := TBDODataModule_ImportarExportarObras(CreateParameters.MyDataModule).OBRAS_SEARCH.Bookmark;
  	TBDODataModule_ImportarExportarObras(CreateParameters.MyDataModule).OBRAS_SEARCH.DisableControls;
	try
        TBDODataModule_ImportarExportarObras(CreateParameters.MyDataModule).OBRAS_SEARCH.First;
        while not TBDODataModule_ImportarExportarObras(CreateParameters.MyDataModule).OBRAS_SEARCH.Eof do
        begin
        	case Mode of
            	1: if not CFDBGridExportar.SelectedRows.CurrentRowSelected then
                	CFDBGridExportar.SelectedRows.CurrentRowSelected := True;
                2: if CFDBGridExportar.SelectedRows.CurrentRowSelected then
		            CFDBGridExportar.SelectedRows.CurrentRowSelected := False;
                3: CFDBGridExportar.SelectedRows.CurrentRowSelected := not CFDBGridExportar.SelectedRows.CurrentRowSelected;
            end;
            TBDODataModule_ImportarExportarObras(CreateParameters.MyDataModule).OBRAS_SEARCH.Next;
        end;
    finally
    	TBDODataModule_ImportarExportarObras(CreateParameters.MyDataModule).OBRAS_SEARCH.Bookmark := PosicaoAtual;
        TBDODataModule_ImportarExportarObras(CreateParameters.MyDataModule).OBRAS_SEARCH.EnableControls;
    end;
end;

procedure TBDOForm_ImportarExportarObras.CFDBGridExportarAfterMultiselect(aSender: TObject; aMultiSelectEventTrigger: TMultiSelectEventTrigger);
begin
    inherited;
    Label_OBR_FILTRO_RegistrosValor.Caption := IntToStr(TCFDBGrid(aSender).SelectedRows.Count) + ' / ' + IntToStr(TBDODataModule_ImportarExportarObras(CreateParameters.MyDataModule).OBRAS_SEARCH.RecordCount);
end;

procedure TBDOForm_ImportarExportarObras.ClearListView;
begin
	ListViewImportar.Clear;
	TBDODataModule_ImportarExportarObras(CreateParameters.MyDataModule).ItemInformation := nil;
end;

procedure TBDOForm_ImportarExportarObras.CustomizedLVWndProc(var Message: TMessage);
const
	HDN_FIRST = -300;
    HDN_BEGINTRACKA = HDN_FIRST - 6;
    HDN_BEGINTRACKW = HDN_FIRST - 26;
//    HDN_ENDTRACKA = HDN_FIRST - 7;
//    HDN_ENDTRACKW = HDN_FIRST - 27;
//    HDN_TRACKA = HDN_FIRST - 8;
//    HDN_TRACKW = HDN_FIRST - 28;
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
	OriginalLVWndProc(Message);
end;


end.
