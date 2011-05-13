unit UXXXForm_TextsManager;

interface

uses
    Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
    Dialogs, UXXXForm_DialogTemplate, ActnList, ExtCtrls, StdCtrls, ComCtrls,
    Buttons, UXXXTypesConstantsAndClasses, ToolWin, ImgList, XPStyleActnCtrls,
    ActnMan, ActnCtrls, StdActns, ExtActns, URtf2Html, URichEdit2Actions;

type
    TXXXForm_TextsManager = class(TXXXForm_DialogTemplate)
        ListBox_SavedTexts: TListBox;
        LabeledEdit_TextTitle: TLabeledEdit;
        BitBtn_Salvar: TBitBtn;
        BitBtn_RemoverDaLista: TBitBtn;
        BitBtn_Usar: TBitBtn;
        BitBtn_Cancelar: TBitBtn;
        Panel_TextBody: TPanel;
        RichEdit_TextBody: TRichEdit;
        StatusBar_TextBody: TStatusBar;
        ActionManager_Tools: TActionManager;
        ImageList_ToolBar: TImageList;
        RichEditBold_Tool: TRichEditBold;
        RichEditItalic_Tool: TRichEditItalic;
        RichEditUnderline_Tool: TRichEditUnderline;
        RichEditAlignLeft_Tool: TRichEditAlignLeft;
        RichEditAlignRight_Tool: TRichEditAlignRight;
        RichEditAlignCenter_Tool: TRichEditAlignCenter;
        Panel_ToolBar: TPanel;
        ActionToolBar_Tools: TActionToolBar;
        Panel_ToolbarLeft: TPanel;
        RichEditStrikeOut_Tool: TRichEditStrikeOut;
        ComboBox_FontName: TComboBox;
        UpDown_FontSize: TUpDown;
        Edit_FontSize: TEdit;
        ColorBox_FontColor: TColorBox;
        Action_Save: TAction;
        Action_Remove: TAction;
        RichEditAlignFullyJustified_Tool: TRichEditAlignFullyJustified;
        procedure ListBox_SavedTextsClick(Sender: TObject);
//        procedure BitBtn_RemoverDaListaClick(Sender: TObject);
        procedure BitBtn_UsarClick(Sender: TObject);
        procedure FormClose(Sender: TObject; var Action: TCloseAction);
        procedure FormCreate(Sender: TObject);
        procedure FormShow(Sender: TObject);
        procedure DoSelectionChange(Sender: TObject);
        procedure Edit_FontSizeChange(Sender: TObject);
        procedure FormDestroy(Sender: TObject);
        procedure ComboBox_FontNameClick(Sender: TObject);
        procedure ActionList_LocalActionsUpdate(Action: TBasicAction; var Handled: Boolean);
        procedure ColorBox_FontColorClick(Sender: TObject);
        procedure Action_SaveExecute(Sender: TObject);
        procedure Action_RemoveExecute(Sender: TObject);
    procedure LabeledEdit_TextTitleChange(Sender: TObject);
    private
        { Private declarations }
        FRtf2Html: TRtf2Html;
        FUpdating: Boolean;
        FFileName: TFileName;
        FFileOfTexts: TFileOfTexts;
        FSelectedText: AnsiString;
        procedure LoadTextFile(const aFileName: TFileName = '');
        procedure SaveTextFile(const aFileName: TFileName);
        procedure UpdateCursorPosIndicator;
        function SelectedTextAttributes: TTextAttributes;
    public
        { Public declarations }
        property SelectedText: AnsiString read FSelectedText;
        property FileName: TFileName write FFileName;
    end;

implementation

{$R *.dfm}

uses
    RichEdit;

procedure TXXXForm_TextsManager.ActionList_LocalActionsUpdate(Action: TBasicAction; var Handled: Boolean);
begin
    inherited;
    ComboBox_FontName.Enabled := (ActiveControl = RichEdit_TextBody)
                              or (ActiveControl = ComboBox_FontName)
                              or (ActiveControl = Edit_FontSize)
                              or (ActiveControl = UpDown_FontSize)
                              or (ActiveControl = ColorBox_FontColor);

    Edit_FontSize.Enabled := (ActiveControl = RichEdit_TextBody)
                          or (ActiveControl = ComboBox_FontName)
                          or (ActiveControl = Edit_FontSize)
                          or (ActiveControl = UpDown_FontSize)
                          or (ActiveControl = ColorBox_FontColor);

    UpDown_FontSize.Enabled := (ActiveControl = RichEdit_TextBody)
                            or (ActiveControl = ComboBox_FontName)
                            or (ActiveControl = Edit_FontSize)
                            or (ActiveControl = UpDown_FontSize)
                            or (ActiveControl = ColorBox_FontColor);

    ColorBox_FontColor.Enabled := (ActiveControl = RichEdit_TextBody)
                               or (ActiveControl = ComboBox_FontName)
                               or (ActiveControl = Edit_FontSize)
                               or (ActiveControl = UpDown_FontSize)
                               or (ActiveControl = ColorBox_FontColor);

    if not ComboBox_FontName.Enabled then
        ComboBox_FontName.ItemIndex := -1;
    if not Edit_FontSize.Enabled then
        Edit_FontSize.Text := '';

    


    if Odd(GetKeyState(VK_CAPITAL)) then
        StatusBar_TextBody.Panels[1].Text := 'CAPS LOCK'
    else
        StatusBar_TextBody.Panels[1].Text := '';

    if Odd(GetKeyState(VK_NUMLOCK)) then
        StatusBar_TextBody.Panels[2].Text := 'NUM LOCK'
    else
        StatusBar_TextBody.Panels[2].Text := '';
end;

//procedure TXXXForm_TextsManager.BitBtn_InserirNaListaClick(Sender: TObject);
//begin
//    inherited;
//
//    if ListBox_SavedTexts.Items.IndexOf(Trim(LabeledEdit_TextTitle.Text)) = -1 then
//    begin
//        with FFileOfTexts.SavedTexts.Add do
//        begin
//            TextTitle := LabeledEdit_TextTitle.Text;
//            Text := FRtf2Html.GetRtfCode(RichEdit_TextBody);
//        end;
//
//        LoadTextFile; { Apenas recarrega a lista com os itens já existentes no objeto }
//
//		ListBox_SavedTexts.ItemIndex := ListBox_SavedTexts.Items.IndexOf(LabeledEdit_TextTitle.Text);
//        ListBox_SavedTextsClick(Sender);
//    end
//    else
//    	MessageBox(Handle,'Não é possível incluir um item duplicado','Item duplicado não permitido',MB_ICONERROR);
//end;


procedure TXXXForm_TextsManager.Action_RemoveExecute(Sender: TObject);
var
	ItemToRemove: SmallInt;
begin
	inherited;
    if ListBox_SavedTexts.ItemIndex > -1 then
    begin
        ItemToRemove := FFileOfTexts.SavedTexts.IndexOfTitle(AnsiString(ListBox_SavedTexts.Items[ListBox_SavedTexts.ItemIndex]));
        if ItemToRemove > -1 then
        begin
            FFileOfTexts.SavedTexts.Delete(ItemToRemove);
            ItemToRemove := ListBox_SavedTexts.ItemIndex;
            LoadTextFile;

            if ListBox_SavedTexts.Count > 0 then
            begin
            	if ItemToRemove > 0 then
	                ListBox_SavedTexts.ItemIndex := Pred(ItemToRemove)
                else
                    ListBox_SavedTexts.ItemIndex := 0;

                ListBox_SavedTextsClick(Sender);
            end;
        end;
    end
    else if ListBox_SavedTexts.Count > 0 then
    begin
        ListBox_SavedTexts.ItemIndex := 0;
        ListBox_SavedTextsClick(Sender);
    end;
end;

procedure TXXXForm_TextsManager.Action_SaveExecute(Sender: TObject);
var
    TextIndex: SmallInt;
begin
    inherited;
       
    TextIndex := FFileOfTexts.SavedTexts.IndexOfTitle(AnsiString(Trim(LabeledEdit_TextTitle.Text)));

    { Adiciona um novo }
    if TextIndex = -1 then
        with FFileOfTexts.SavedTexts.Add do
        begin
            TextTitle := AnsiString(LabeledEdit_TextTitle.Text);
            Text := AnsiString(FRtf2Html.GetRtfCode(RichEdit_TextBody));
        end
    { Substitui }
    else
        FFileOfTexts.SavedTexts[TextIndex].Text := AnsiString(FRtf2Html.GetRtfCode(RichEdit_TextBody));

    LoadTextFile; { Apenas recarrega a lista com os itens já existentes no objeto }

    ListBox_SavedTexts.ItemIndex := ListBox_SavedTexts.Items.IndexOf(LabeledEdit_TextTitle.Text);
    ListBox_SavedTextsClick(Sender);
end;

//procedure TXXXForm_TextsManager.BitBtn_RemoverDaListaClick(Sender: TObject);
//var
//	ItemToRemove: SmallInt;
//begin
//	inherited;
//    if ListBox_SavedTexts.ItemIndex > -1 then
//    begin
//        ItemToRemove := FFileOfTexts.SavedTexts.IndexOfTitle(ListBox_SavedTexts.Items[ListBox_SavedTexts.ItemIndex]);
//        if ItemToRemove > -1 then
//        begin
//            FFileOfTexts.SavedTexts.Delete(ItemToRemove);
//            ItemToRemove := ListBox_SavedTexts.ItemIndex;
//            LoadTextFile;
//
//            if ListBox_SavedTexts.Count > 0 then
//            begin
//            	if ItemToRemove > 0 then
//	                ListBox_SavedTexts.ItemIndex := Pred(ItemToRemove)
//                else
//                    ListBox_SavedTexts.ItemIndex := 0;
//
//                ListBox_SavedTextsClick(Sender);
//            end;
//        end;
//    end
//    else if ListBox_SavedTexts.Count > 0 then
//    begin
//        ListBox_SavedTexts.ItemIndex := 0;
//        ListBox_SavedTextsClick(Sender);
//    end;
//end;

procedure TXXXForm_TextsManager.BitBtn_UsarClick(Sender: TObject);
begin
    inherited;
    FSelectedText := FRtf2Html.GetRtfCode(RichEdit_TextBody);
end;

procedure TXXXForm_TextsManager.ColorBox_FontColorClick(Sender: TObject);
begin
    inherited;
    if not FUpdating then
        SelectedTextAttributes.Color := ColorBox_FontColor.Colors[ColorBox_FontColor.ItemIndex];
end;

procedure TXXXForm_TextsManager.ComboBox_FontNameClick(Sender: TObject);
begin
    inherited;
    if not FUpdating and ComboBox_FontName.Enabled then
        SelectedTextAttributes.Name := ComboBox_FontName.Items[ComboBox_FontName.ItemIndex];
end;

procedure TXXXForm_TextsManager.Edit_FontSizeChange(Sender: TObject);
begin
    inherited;
    if not FUpdating and Edit_FontSize.Enabled then
        SelectedTextAttributes.Size := StrToIntDef(Edit_FontSize.Text,8);
end;

procedure TXXXForm_TextsManager.FormClose(Sender: TObject; var Action: TCloseAction);
begin
    inherited;
    SaveTextFile(FFileName);
end;

procedure TXXXForm_TextsManager.FormCreate(Sender: TObject);
const
    EM_SETTYPOGRAPHYOPTIONS = (WM_USER + 202);
//    EM_GETTYPOGRAPHYOPTIONS = (WM_USER + 203);
    TO_ADVANCEDTYPOGRAPHY = $1;
begin
    inherited;
    FFileOfTexts := TFileOfTexts.Create(Self);
    ComboBox_FontName.Items.Assign(Screen.Fonts);

    FRtf2Html := TRtf2Html.Create;

    SendMessage(RichEdit_TextBody.Handle,EM_SETTYPOGRAPHYOPTIONS, TO_ADVANCEDTYPOGRAPHY,TO_ADVANCEDTYPOGRAPHY);
end;

procedure TXXXForm_TextsManager.FormDestroy(Sender: TObject);
begin
    inherited;
    FRtf2Html.Free;
end;

procedure TXXXForm_TextsManager.FormShow(Sender: TObject);
begin
    inherited;
    LoadTextFile(FFileName);

    if ListBox_SavedTexts.Count > 0 then
    begin
        ListBox_SavedTexts.ItemIndex := 0;
        ListBox_SavedTextsClick(Sender);
    end;

    UpdateCursorPosIndicator;
end;

procedure TXXXForm_TextsManager.LabeledEdit_TextTitleChange(Sender: TObject);
begin
    inherited;
    Action_Save.Enabled := Trim(LabeledEdit_TextTitle.Text) <> '';
end;

procedure TXXXForm_TextsManager.ListBox_SavedTextsClick(Sender: TObject);
begin
  inherited;
    if ListBox_SavedTexts.ItemIndex > -1 then
    begin
	    RichEdit_TextBody.Text := String(ListBox_SavedTexts.Items.Objects[ListBox_SavedTexts.ItemIndex]);
    	LabeledEdit_TextTitle.Text := ListBox_SavedTexts.Items[ListBox_SavedTexts.ItemIndex];
    end;
end;

procedure TXXXForm_TextsManager.LoadTextFile(const aFileName: TFileName = '');
var
	i: Word;
begin
	if Trim(aFileName) <> '' then                               
		FFileOfTexts.LoadFromBinaryFile(aFileName);

    ListBox_SavedTexts.Clear;
    if FFileOfTexts.SavedTexts.Count > 0 then
    	for i := 0 to Pred(FFileOfTexts.SavedTexts.Count) do
            ListBox_SavedTexts.AddItem(String(FFileOfTexts.SavedTexts[i].TextTitle),TObject(FFileOfTexts.SavedTexts[i].Text));
end;

procedure TXXXForm_TextsManager.DoSelectionChange(Sender: TObject);
begin
    inherited;
    try
        FUpdating := True;

        Edit_FontSize.Text := IntToStr(RichEdit_TextBody.SelAttributes.Size);
        ComboBox_FontName.ItemIndex := ComboBox_FontName.Items.IndexOf(RichEdit_TextBody.SelAttributes.Name);
        UpdateCursorPosIndicator;
    finally
        FUpdating := False;
    end;
end;

procedure TXXXForm_TextsManager.SaveTextFile(const aFileName: TFileName);
begin
	FFileOfTexts.SaveToBinaryFile(aFileName);
end;

procedure TXXXForm_TextsManager.UpdateCursorPosIndicator;
var
    CharPos: TPoint;
begin
    CharPos.Y := SendMessage(RichEdit_TextBody.Handle
                            ,EM_EXLINEFROMCHAR
                            ,0
                            ,RichEdit_TextBody.SelStart);
    CharPos.X := (RichEdit_TextBody.SelStart - SendMessage(RichEdit_TextBody.Handle, EM_LINEINDEX, CharPos.Y, 0));
    Inc(CharPos.Y);
    Inc(CharPos.X);
    StatusBar_TextBody.Panels[0].Text := Format('%u:%u', [CharPos.Y, CharPos.X]);
end;

function TXXXForm_TextsManager.SelectedTextAttributes: TTextAttributes;
begin
    Result := RichEdit_TextBody.DefAttributes;
    if RichEdit_TextBody.SelLength > 0 then
        Result := RichEdit_TextBody.SelAttributes;
end;


end.
