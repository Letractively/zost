unit ZTO.Components.DataControls.DBGrid;

interface

uses SysUtils
   , Classes
   , Windows
   , Controls
   , Grids
   , DBGrids
   , Types
   , Messages
   , DB
   , Graphics
   , StdCtrls;

type
    TCustomZTODBGrid = class;

    TRowColor = class(TCollectionItem)
    private
	    FBackgroundColor: TColor;
      FForegroundColor: TColor;
	    procedure SetBackgroundColor(const Value: TColor);
	    procedure SetForegroundColor(const Value: TColor);
    public
    	constructor Create(Collection: TCollection); override;
      procedure Assign(aSource: TPersistent); override;
    published
    	property BackgroundColor: TColor read FBackgroundColor write SetBackgroundColor;
    	property ForegroundColor: TColor read FForegroundColor write SetForegroundColor;
    end;

    TRowColors = class(TCollection)
    private
    	FGrid: TCustomZTODBGrid;
	    function GetRowColor(Index: Integer): TRowColor;
    	procedure SetRowColor(Index: Integer; const Value: TRowColor);
    protected
    	procedure Update(Item: TCollectionItem); override;
    public
	    constructor Create(aGrid: TCustomZTODBGrid);
      function Add: TRowColor;
      property Items[Index: Integer]: TRowColor read GetRowColor write SetRowColor; default;
    end;

    TSortArrowDirection = (sadNone, sadDescending, sadAscending);
    TSortArrowPosition = (sapLeft, sapCenter, sapRight);

    TSortArrow = class(TPersistent)
    private
        FDirection: TSortArrowDirection;
        FColumn: WideString;
        FGrid: TCustomZTODBGrid;
        FPosition: TSortArrowPosition;
        procedure SetDirection(const Value: TSortArrowDirection);
        procedure SetPosition(const Value: TSortArrowPosition);
    public
        constructor Create(aGrid: TCustomZTODBGrid);

        property Grid: TCustomZTODBGrid read FGrid;
    published
        property Column: WideString read FColumn write FColumn;
        property Position: TSortArrowPosition read FPosition write SetPosition default sapRight;
        property Direction: TSortArrowDirection read FDirection write SetDirection default sadNone;
    end;
    { TODO : CFDBGRID }

    { TODO : Mude para TStateInfo e retire Indicators e IndicatorsWidth }
    TPaintInfo = record
        MouseInCol: Integer; // the column that the mouse is in
        ColPressed: Boolean; // a column has been pressed
        ColPressedIdx: Integer; // idx of the pressed column
        ColSizing: Boolean; // currently sizing a column
        ColMoving: Boolean; // currently moving a column
        Indicators: TImageList; // Lista de imagens de indicadores { TODO : CFDBGRID }
        SortArrows: TImageList;
        IndicatorsWidth: Byte; // Largura da coluna de indicadores. Em estado normal � 17 em estado multiselect � 31 { TODO : CFDBGRID }
    end;

    TDBGridOptionEx = (dgAllowTitleClick, dgPersistentSelection, dgAllowAppendAfterEof, dgHideVerticalScrollBar, dgAutomaticColumSizes);
    //rowselect e autoapend tem intera��o
    TDBGridOptionsEx = set of TDBGridOptionEx;

    TMultiSelectEventTrigger = (msetMouseDown,msetKeyDown);

    TBeforeMultiSelectEvent = procedure(aSender: TObject; aMultiSelectEventTrigger: TMultiSelectEventTrigger; var aCanChangeSelection: Boolean) of object;

    TAfterMultiSelectEvent = procedure(aSender: TObject; aMultiSelectEventTrigger: TMultiSelectEventTrigger) of object;

    TCustomZTODBGrid = class(TCustomDBGrid)
    private { -- Private declarations ---------------------------------------- }
        FPaintInfo: TPaintInfo;
        { C�lula atualmente selecionada}
        FCell: TGridCoord;
        { Op��es adicionais do CFDBGrid }
        FOptionsEx: TDBGridOptionsEx;
        { Cole��o de cores alternadas }
        FRowColors: TRowColors;

        FInColExit: Boolean;
        FIsESCKey: Boolean;
		FOnBeforeMultiSelect: TBeforeMultiSelectEvent;
        FOnAfterMultiSelect: TAfterMultiSelectEvent;
        FSortArrow: TSortArrow;
        FVariableWidthColumns: WideString;
        { col offset used for calculations. Is 1 if indicator is being displayed }
        function ColumnOffset: Byte; { TODO : CFDBGRID }
        function TitleOffset: Byte; { TODO : CFDBGRID }
        { Verifica se � uma c�lula v�lida. Basicamente verifica se suas
        coordenadas n�o s�o negativas ou n�o }
        function ValidCell(ACell: TGridCoord): Boolean;

        procedure MoveCol(RawCol, Direction: Integer);
        function AcquireFocus: Boolean;
        procedure UpdateData;
        function PtInExpandButton(X,Y: Integer; var MasterCol: TColumn): Boolean;
        function GetOptions: TDBGridOptions;
        procedure SetOptions(const Value: TDBGridOptions);
        procedure SetOptionsEx(const Value: TDBGridOptionsEx);
        procedure WMSize(var Message: TWMSize); message WM_SIZE;
    protected { -- Protected declarations ------------------------------------ }
        function BeginColumnDrag(var Origin: Integer; var Destination: Integer; const MousePt: TPoint): Boolean; override;
        procedure CMMouseEnter(var Message: TMessage); message CM_MOUSEENTER;
        procedure CMMouseLeave(var Message: TMessage); message CM_MOUSELEAVE;
        procedure ColExit; override;
        procedure ColumnMoved(FromIndex: Integer; ToIndex: Integer); override;
        procedure DrawCell(ACol: Integer; ARow: Integer; ARect: TRect; AState: TGridDrawState); override;
        procedure MouseDown(Button: TMouseButton; Shift: TShiftState; X: Integer; Y: Integer); override;
        procedure MouseMove(Shift: TShiftState; X: Integer; Y: Integer); override;
        procedure MouseUp(Button: TMouseButton; Shift: TShiftState; X: Integer; Y: Integer); override;
        procedure TitleClick(Column: TColumn); override;
        procedure Paint; override;
        procedure DrawColumnCell(const Rect: TRect; DataCol: Integer; Column: TColumn; State: TGridDrawState); override;

        { TODO : CFDBGRID - IN�CIO }
        procedure SetColumnAttributes; override;
        procedure KeyDown(var Key: Word; Shift: TShiftState); override;
        procedure UpdateScrollBar; override;
        procedure LayoutChanged; override;

        property Options: TDBGridOptions read GetOptions write SetOptions default [dgEditing, dgTitles, dgIndicator, dgColumnResize, dgColLines, dgRowLines, dgTabs, dgConfirmDelete, dgCancelOnExit];
        property OptionsEx: TDBGridOptionsEx read FOptionsEx write SetOptionsEx default [dgAllowTitleClick];
        property OnBeforeMultiSelect: TBeforeMultiSelectEvent read FOnBeforeMultiSelect write FOnBeforeMultiSelect;
        property OnAfterMultiSelect: TAfterMultiSelectEvent read FOnAfterMultiSelect write FOnAfterMultiSelect;
        property RowColors: TRowColors read FRowColors write FRowColors;
        property SortArrow: TSortArrow read FSortArrow write FSortArrow;
        property VariableWidthColumns: WideString read FVariableWidthColumns write FVariableWidthColumns;
        { TODO : CFDBGRID - FIM }
    public { -- Public declarations ------------------------------------------ }
        constructor Create(AOwner: TComponent); override;
        destructor Destroy; override;

        procedure AdjustColumns;
    end;

    TZTODBGrid = class (TCustomZTODBGrid)
    public { -- Public declarations ------------------------------------------ }
        property Canvas;
        property SelectedRows;
    published { -- Published declarations ------------------------------------ }
        property Align;
        property Anchors;
        property BiDiMode;
        property BorderStyle;
        property Color;
        property Columns stored False;
        property Constraints;
        property Ctl3D;
        property DataSource;
        property DefaultDrawing;
        property DragCursor;
        property DragKind;
        property DragMode;
        property Enabled;
        property FixedColor;
        property Font;
        property ImeMode;
        property ImeName;
        property Options;
        property OptionsEx;
        property ParentBiDiMode;
        property ParentColor;
        property ParentCtl3D;
        property ParentFont;
        property ParentShowHint;
        property PopupMenu;
        property ReadOnly;
        property ShowHint;
        property TabOrder;
        property TabStop;
        property TitleFont;
        property Visible;
        property RowColors;
        property SortArrow;
        property VariableWidthColumns;
        property OnAfterMultiselect;
        property OnBeforeMultiSelect;
        property OnCellClick;
        property OnColEnter;
        property OnColExit;
        property OnColumnMoved;
        property OnDrawDataCell;  { obsolete }
        property OnDrawColumnCell;
        property OnDblClick;
        property OnDragDrop;
        property OnDragOver;
        property OnEditButtonClick;
        property OnEndDock;
        property OnEndDrag;
        property OnEnter;
        property OnExit;
        property OnKeyDown;
        property OnKeyPress;
        property OnKeyUp;
        property OnMouseActivate;
        property OnMouseDown;
        property OnMouseEnter;
        property OnMouseLeave;
        property OnMouseMove;
        property OnMouseUp;
        property OnMouseWheel;
        property OnMouseWheelDown;
        property OnMouseWheelUp;
        property OnStartDock;
        property OnStartDrag;
        property OnTitleClick;
    end;

implementation

uses Themes
   , GraphUtil
   , Forms
   , ImgList
   , UxTheme;

{$R ZTODBGrid.res}

const
    bmArrow = 'CFDBGARROW';
    bmEdit = 'CFDBGEDIT';
    bmInsert = 'CFDBGINSERT';
    bmMultiDot = 'CFDBGMULTIDOT';
    bmMultiArrow = 'CFDBGMULTIARROW';
    bmActive = 'CFDBGACTIVE';
    bmExpanded = 'CFDBGEXPANDED';
    bmColapsed = 'CFDBGCOLAPSED';
    bmSortAsc = 'CFDBGSORTASC';
    bmSortDes = 'CFDBGSORTDES';

{ TCustomZTODBGrid }

{ Hack para acessar membros protegidos e privados }
type
    TBookmarkLst = class(TBookmarkList);
    { Classe "sombra". Ela � exatamente igual � classe original at� o ponto da
    declara��o do campo que queremos acessar. Neste caso, FModified }
    TGridDataLnk = class(TGridDataLink)
    private
        {$HINTS OFF}
        FGrid: TCustomDBGrid;
        FFieldCount: Integer;
        FFieldMap: array of Integer;
        FModified: Boolean;
        {$HINTS ON}
    end;

procedure TCustomZTODBGrid.AdjustColumns;
{ ---------------------------------------------------------------------------- }
function GetBorders: Byte;
begin
    // Result := 0;  --> Quando BorderStyle = bsNone
    // Result := 2;  --> Quando Ctl3D = False
    // Result := 4;  --> Quando BorderStyle = bsSingle
    Result := 4; // Valor m�ximo aceitavel
    if BorderStyle = bsNone then
        Dec(Result,4)
    else
        if not Ctl3D then
            Dec(Result,2);
end;

function IsVariableColumn(aColumn: TColumn): Boolean;
begin
    Result := Pos('<' + aColumn.FieldName  + '>',FVariableWidthColumns) > 0;
end;
{ ---------------------------------------------------------------------------- }
var
	FixedBlockWidth, VariableBlockWidth: Word;
	FixedColumnsCount, VariableColumnsCount, VerticalScrollBarWidth: Byte;
	i, DivisionError: Byte;


begin
    if (Columns.State = csDefault) or (Trim(FVariableWidthColumns) = '') then
        Exit;

    VerticalScrollBarWidth := 0;
    if not (dgHideVerticalScrollBar in FOptionsEx) then
        VerticalScrollBarWidth := GetSystemMetrics(SM_CXVSCROLL);

    VariableColumnsCount := 0;
    FixedBlockWidth := 0;

    for i := 0 to Pred(Columns.Count) do
        if IsVariableColumn(Columns[i]) then
            Inc(VariableColumnsCount)
        else
            Inc(FixedBlockWidth,Columns[i].Width);

    FixedColumnsCount := Columns.Count - VariableColumnsCount;

    VariableBlockWidth := Width - GetBorders - FixedBlockWidth - VerticalScrollBarWidth - FixedColumnsCount;

    if dgIndicator in Options then
    begin
        Dec(VariableBlockWidth,FPaintInfo.IndicatorsWidth);
        if (dgColLines in Options) then
            Dec(VariableBlockWidth)
        else
            Inc(VariableBlockWidth,Columns.Count);
    end
    else if not (dgColLines in Options) then
        Inc(VariableBlockWidth,Succ(Columns.Count));

    DivisionError := VariableBlockWidth mod VariableColumnsCount;

    for i := 0 to Pred(Columns.Count) do
        if IsVariableColumn(Columns[i]) then
        begin
            Columns[i].Width := Pred(VariableBlockWidth div VariableColumnsCount);
            if DivisionError > 0 then
            begin
                Columns[i].Width := Succ(Columns[i].Width);
                Dec(DivisionError);
            end;

        end;
end;

function TCustomZTODBGrid.BeginColumnDrag(var Origin: Integer; var Destination: Integer; const MousePt: TPoint): Boolean;
begin
    Result := inherited BeginColumnDrag(Origin, Destination, MousePt);
    FPaintInfo.ColMoving := result;
end;

procedure TCustomZTODBGrid.CMMouseEnter(var Message: TMessage);
var
    Cell: TGridCoord;
begin
    Cell := MouseCoord(Mouse.CursorPos.X, Mouse.CursorPos.Y);
    if (dgTitles in Options) and (Cell.Y = 0) then
        InvalidateCell(Cell.X, Cell.Y);
end;

procedure TCustomZTODBGrid.CMMouseLeave(var Message: TMessage);
begin
    if ValidCell(FCell) then
        InvalidateCell(FCell.X, FCell.Y);

    FCell.X := -1;
    FCell.Y := -1;
    FPaintInfo.MouseInCol := -1;
    FPaintInfo.ColPressedIdx := -1;
end;

procedure TCustomZTODBGrid.ColExit;
begin
    inherited;
    FPaintInfo.MouseInCol := -1;
    if ValidCell(FCell) then
        InvalidateCell(FCell.X, FCell.Y);
end;

procedure TCustomZTODBGrid.ColumnMoved(FromIndex, ToIndex: Integer);
begin
    inherited;
    FPaintInfo.ColMoving := False;
    Invalidate;
end;

constructor TCustomZTODBGrid.Create(AOwner: TComponent);
var
    Bmp: TBitmap;
begin
    inherited;
    ZeroMemory(@FPaintInfo,SizeOf(TPaintInfo)); { TODO : CFDBGRID }

    FPaintInfo.ColPressed := False;
    FPaintInfo.MouseInCol := -1;
    FPaintInfo.ColPressedIdx := -1;
    FPaintInfo.ColMoving := False;
    FPaintInfo.ColSizing := False;
    FPaintInfo.IndicatorsWidth := 17; { TODO : CFDBGRID }

    FRowColors := TRowColors.Create(Self); { TODO : CFDBGRID }
    FSortArrow := TSortArrow.Create(Self); { TODO : CFDBGRID }

    { TODO : CFDBGRID - INICIO }
    // Indicadores
    Bmp := TBitmap.Create;
    try
	    Bmp.LoadFromResourceName(HInstance, bmArrow);
    	FPaintInfo.Indicators := TImageList.CreateSize(Bmp.Width, Bmp.Height);
	    FPaintInfo.Indicators.AddMasked(Bmp, clFuchsia);
    	Bmp.LoadFromResourceName(HInstance, bmEdit);
	    FPaintInfo.Indicators.AddMasked(Bmp, clFuchsia);
    	Bmp.LoadFromResourceName(HInstance, bmInsert);
	    FPaintInfo.Indicators.AddMasked(Bmp, clFuchsia);
    	Bmp.LoadFromResourceName(HInstance, bmMultiDot);
	    FPaintInfo.Indicators.AddMasked(Bmp, clFuchsia);
	    Bmp.LoadFromResourceName(HInstance, bmMultiArrow);
	    FPaintInfo.Indicators.AddMasked(Bmp, clFuchsia);
    	Bmp.LoadFromResourceName(HInstance, bmActive);
	    FPaintInfo.Indicators.AddMasked(Bmp, clFuchsia);
    	Bmp.LoadFromResourceName(HInstance, bmExpanded);
	    FPaintInfo.Indicators.AddMasked(Bmp, clFuchsia);
    	Bmp.LoadFromResourceName(HInstance, bmColapsed);
	    FPaintInfo.Indicators.AddMasked(Bmp, clFuchsia);
    finally
    	Bmp.Free;
    end;

    // Setas de ordena��o
    Bmp := TBitmap.Create;
    try
        Bmp.LoadFromResourceName(HInstance, bmSortAsc);
        FPaintInfo.SortArrows := TImageList.CreateSize(Bmp.Width, Bmp.Height);
        FPaintInfo.SortArrows.AddMasked(Bmp, clFuchsia);
        Bmp.LoadFromResourceName(HInstance, bmSortDes);
        FPaintInfo.SortArrows.AddMasked(Bmp, clFuchsia);
    finally
	    Bmp.Free;
    end;
    { TODO : CFDBGRID - FIM }

    FCell.X := -1;
    FCell.Y := -1;
    FOptionsEx := [dgAllowTitleClick];
end;

destructor TCustomZTODBGrid.Destroy;
begin
    FPaintInfo.Indicators.Free;
    FSortArrow.Free;
    FRowColors.Free;
    inherited;
end;

{ Onde est� a primeira coluna �til? Estar� em 1 se tiver indicadores e em zero
se n�o tiver }
function TCustomZTODBGrid.ColumnOffset: Byte;
begin
    if dgIndicator in Options then
        Result := 1
    else
        Result := 0;
end;

{ Onde est� a primeira linha �til? Estar� em 1 se tiver t�tulos e em zero se n�o
tiver }
function TCustomZTODBGrid.TitleOffset: Byte;
begin
    if dgTitles in Options then
        Result := 1
    else
        Result := 0;
end;

{ TODO : Revise este método. Acho que ele pode ser simplificado na parte de desenho com temas! }
procedure TCustomZTODBGrid.DrawCell(ACol, ARow: Integer; ARect: TRect; AState: TGridDrawState);
{ ---------------------------------------------------------------------------- }
procedure DrawCheckBox(Canvas: TCanvas; TopLeft: TPoint; Checked: Boolean; SubStyle: Byte);
var
  ThemedElementDetails: TThemedElementDetails;
  ThemedCheckBox: TThemedButton;
  CheckBoxProperties: Cardinal;
  DrawRect: TRect;
  CheckBoxWidth, CheckBoxHeight: Byte;
begin
  CheckBoxWidth := GetSystemMetrics(SM_CXMENUCHECK);
  CheckBoxHeight := GetSystemMetrics(SM_CYMENUCHECK);

  if ThemeServices.ThemesEnabled then
  begin
    if Checked then
      case SubStyle of
        0: ThemedCheckBox := tbCheckBoxCheckedNormal;
        1: ThemedCheckBox := tbCheckBoxCheckedHot;
        2: ThemedCheckBox := tbCheckBoxCheckedPressed;
        3: ThemedCheckBox := tbCheckBoxCheckedDisabled;
        else
          ThemedCheckBox := tbCheckBoxCheckedNormal;
      end
    else
      case SubStyle of
        0: ThemedCheckBox := tbCheckBoxUncheckedNormal;
        1: ThemedCheckBox := tbCheckBoxUncheckedHot;
        2: ThemedCheckBox := tbCheckBoxUncheckedPressed;
        3: ThemedCheckBox := tbCheckBoxUncheckedDisabled;
        else
          ThemedCheckBox := tbCheckBoxUncheckedNormal;
      end;

    DrawRect.TopLeft := TopLeft;
    DrawRect.Right := DrawRect.Left + CheckBoxWidth;
    DrawRect.Bottom := DrawRect.Top + CheckBoxHeight;
    ThemedElementDetails := ThemeServices.GetElementDetails(ThemedCheckBox);
    ThemeServices.DrawElement(Canvas.Handle, ThemedElementDetails, DrawRect);
  end
  else
  begin
    { O Windows 7 faz alguns calculos errados com o tamanho do checkbox, por
    isso as dimensões e posições precisam ser ajustadas }
    if Win32MajorVersion = 6 then
    begin
      CheckBoxWidth := CheckBoxWidth - 2;
      CheckBoxHeight := CheckBoxHeight - 2;
      TopLeft.X := TopLeft.X + 1;
      TopLeft.Y := TopLeft.Y + 1;
    end;

    if Checked then
      case SubStyle of
        0: CheckBoxProperties := DFCS_CHECKED;
        1: CheckBoxProperties := DFCS_CHECKED or DFCS_HOT;
        2: CheckBoxProperties := DFCS_CHECKED or DFCS_PUSHED;
        3: CheckBoxProperties := DFCS_CHECKED or DFCS_INACTIVE;
        else
          CheckBoxProperties := DFCS_CHECKED;
      end
    else
      case SubStyle of
        0: CheckBoxProperties := 0;
        1: CheckBoxProperties := DFCS_HOT;
        2: CheckBoxProperties := DFCS_PUSHED;
        3: CheckBoxProperties := DFCS_INACTIVE;
        else
          CheckBoxProperties := 0;
      end;

      DrawRect.TopLeft := TopLeft;
      DrawRect.Right := DrawRect.Left + CheckBoxWidth;
      DrawRect.Bottom := DrawRect.Top + CheckBoxHeight;
      DrawFrameControl(Canvas.Handle, DrawRect, DFC_BUTTON, DFCS_BUTTONCHECK or CheckBoxProperties);
    end;
end;

function RowIsMultiSelected: Boolean;
var
    Index, OldActive: Integer;
begin
    Result := False;

    if Datalink.Active then
    begin
        OldActive := DataLink.ActiveRecord;
        try
            Datalink.ActiveRecord := ARow - TitleOffset;
            Result := (dgMultiSelect in Options)
                      and SelectedRows.Find(Datalink.DataSet.Bookmark, Index);
        finally
            Datalink.ActiveRecord := OldActive;
        end;
    end;
end;

{ A combinação das duas funções abaixo retorna true quando estamos desenhando a
primeira célula do grid quando há titulo (célula morta) }
function DrawingTitle: Boolean;
begin
  Result := (dgTitles in Options) and (ARow = 0);
end;

function DrawingIndicator: Boolean;
begin
  Result := (dgIndicator in Options) and (ACol = 0);
end;

{ Desenha os elementos adicionas da coluna de indicadores }
procedure DrawIndicatorColumnElements;
var
    MultiSelected: Boolean;
    Indicator: Byte;
begin
    if (dgIndicator in Options) and (ACol = 0) then
    begin
        MultiSelected := False;

        { Verificando se esta linha est� marcada }
        if ARow >= TitleOffset then
            MultiSelected := RowIsMultiselected;

        { Checkboxes }
        if Datalink.Active and (ARow >= TitleOffset) then
            DrawCheckBox(Canvas,Point(2,ARect.Top + 2),MultiSelected,0);

        { Indicadores }
        { Caso eu tenha um dataset ativo e, eu esteja pintando o registro ativo
        ou esteja e modo de multisele��o }
        if (Datalink.Active) and ((ARow - TitleOffset = Datalink.ActiveRecord) or MultiSelected) then
        begin
            Indicator := 0;

            case Byte(DataLink.DataSet.State) of
                2: begin // dsEdit
                    if ARow - TitleOffset = Datalink.ActiveRecord  then
                        Indicator := 1
                    else
                        Indicator := 3;
                end;
                3: begin // dsInsert
                    if ARow - TitleOffset = Datalink.ActiveRecord then
                        Indicator := 2
                    else
                        Indicator := 3;
                end;
                1:  // dsBrowse
                    if MultiSelected then
                        if ARow - TitleOffset <> Datalink.ActiveRecord then
                            Indicator := 3
                        else
                            Indicator := 4;  // multiselected and current row
            end;

            FPaintInfo.Indicators.BkColor := FixedColor;
            FPaintInfo.Indicators.Draw(Canvas, ARect.Left + 2 + GetSystemMetrics(SM_CXMENUCHECK) + 1, ARect.Top + 2, Indicator, dsTransparent, itImage, True);
        end;
    end;
end;


procedure WriteText(      aCanvas: TCanvas;
                          aRect: TRect;
                          aDX
                        , aDY: Integer;
                    const aText: String;
                          aAlignment: TAlignment;
                          aRightToLeft: Boolean);
var
    LeftPosition: SmallInt;
begin
    { In BiDi, because we changed the window origin, the text that does not
    change alignment, actually gets its alignment changed. }
    if (aCanvas.CanvasOrientation = coRightToLeft) and (not ARightToLeft) then
        ChangeBiDiModeAlignment(aAlignment);

    case aAlignment of
        taLeftJustify: LeftPosition := aRect.Left + aDX;
        taRightJustify: LeftPosition := aRect.Right - aCanvas.TextWidth(aText) - aDX;
    else { taCenter }
        LeftPosition := aRect.Left + (aRect.Right - aRect.Left) shr 1 - (aCanvas.TextWidth(aText) shr 1);
    end;

    aCanvas.Brush.Style := bsClear;
    aCanvas.Font.Assign(TitleFont);
    aCanvas.TextRect(aRect, LeftPosition, aRect.Top + aDY, aText);
end;

procedure DrawIndicatorsAndMore(out aMultiSelected: Boolean);
var
  Indicator: Integer;
begin
  aMultiSelected := False;

  { Verificando se esta linha est� marcada em modo de multisele��o }
  if (ARow >= TitleOffset) and (dgMultiselect in Options) then
  begin
    aMultiSelected := RowIsMultiselected;
    { Checkboxes }
    case Win32MajorVersion of
      5: DrawCheckBox(Canvas,Point(2,ARect.Top + 2),aMultiSelected,0); // Windows 2000, Windows XP or Windows Server 2003
      6: DrawCheckBox(Canvas,Point(1,ARect.Top + 1),aMultiSelected,0); // Windows Vista or Windows 7
    end;
  end;

  { Indicadores }
  { Caso eu tenha um dataset ativo e, eu esteja pintando o registro ativo ou
  esteja em um registro selecionado (marcado) }
  if (Datalink.Active) and ((ARow - TitleOffset = Datalink.ActiveRecord) or aMultiSelected) then
  begin
    Indicator := 0;

    case Byte(DataLink.DataSet.State) of
      2: // dsEdit
        if ARow - TitleOffset = Datalink.ActiveRecord  then
          Indicator := 1
        else
                  Indicator := 3;
      3: // dsInsert
        if ARow - TitleOffset = Datalink.ActiveRecord then
          Indicator := 2
        else
          Indicator := 3;
      1: // dsBrowse
        if aMultiSelected then
          if ARow - TitleOffset <> Datalink.ActiveRecord then
            Indicator := 3
          else
            Indicator := 4;  // multiselected and current row
    end;

    FPaintInfo.Indicators.BkColor := FixedColor;

    if dgMultiselect in Options then
      case Win32MajorVersion of
        5: FPaintInfo.Indicators.Draw(Canvas, ARect.Left + 2 + GetSystemMetrics(SM_CXMENUCHECK) + 1, ARect.Top + 2, Indicator, dsTransparent, itImage, True);
        6: FPaintInfo.Indicators.Draw(Canvas, ARect.Left + 0 + GetSystemMetrics(SM_CXMENUCHECK) + 1, ARect.Top + 2, Indicator, dsTransparent, itImage, True);
      end
    else
      FPaintInfo.Indicators.Draw(Canvas, ARect.Left + 2, ARect.Top + 2, Indicator, dsTransparent, itImage, True);
  end;
end;

const
    TEXTYOFFSET = 2;
    TEXTXOFFSET = 2;
    ARROWYOFFSET = 2;
    ARROWXOFFSET = 2;

procedure DrawTitleCellText(aRow: Integer; aColumn: TColumn);
var
    MasterCol: TColumn;
    TitleRect: TRect;
    XPos, YPos: Word;
begin
    TitleRect := CalcTitleRect(aColumn, aRow, MasterCol);

    if Assigned(MasterCol) then
    begin
        XPos := TEXTXOFFSET;
        YPos := TEXTYOFFSET;

        { Se vou desehar o t�tulo em uma coluna que tem seta de ordena��o
        vis�vel tenho de considerar certos aspectos }
        if (FSortArrow.Direction in [sadDescending, sadAscending]) and (FSortArrow.Column = aColumn.FieldName) then
        begin
            if FSortArrow.Position <> sapCenter then
            begin
                if ((FSortArrow.Position = sapLeft) and (MasterCol.Title.Alignment = taLeftJustify))
                or ((FSortArrow.Position = sapRight) and (MasterCol.Title.Alignment = taRightJustify)) then
                    case FSortArrow.Position of
                        sapLeft,
                        sapRight: XPos := ARROWXOFFSET + FPaintInfo.SortArrows.Width + TEXTXOFFSET;
                    end;

                with MasterCol.Title do
                    WriteText(Canvas, TitleRect, XPos, YPos, Caption, Alignment, IsRightToLeft);
            end;
        end
        else
            with MasterCol.Title do
                WriteText(Canvas, TitleRect, XPos, YPos, Caption, Alignment, IsRightToLeft);
    end;
end;

procedure DrawSortArrow(aRow: Integer; aColumn: TColumn);
var
    MasterCol: TColumn;
    TitleRect: TRect;
    XPos, YPos: Word;
begin
    if (FSortArrow.Column = aColumn.FieldName) and (FSortArrow.Direction in [sadDescending, sadAscending]) then
    begin
        TitleRect := CalcTitleRect(aColumn, aRow, MasterCol);

        if Assigned(MasterCol) then
        begin
            case FSortArrow.Position of
                sapLeft: XPos := TitleRect.Left + ARROWXOFFSET;
                sapCenter: XPos := TitleRect.Left + (TitleRect.Right - TitleRect.Left) shr 1 - FPaintInfo.SortArrows.Width shr 1;
                else // sapRight
                    XPos := TitleRect.Right - FPaintInfo.SortArrows.Width - ARROWXOFFSET;
            end;
            YPos := TitleRect.Top + ARROWYOFFSET;

            FPaintInfo.SortArrows.Draw(Canvas,XPos,YPos,Pred(Byte(FSortArrow.Direction)));
        end;

    end;
end;

procedure DrawIndicatorCellBackground;
begin
  if ThemeServices.ThemesEnabled then
    Canvas.Pen.Color := clBtnShadow
  else
    Canvas.Pen.Color := FixedColor;

  Canvas.Pen.Style := psSolid;
  Canvas.Pen.Width := 1;
  Canvas.Brush.Color := FixedColor;
  Canvas.Rectangle(ARect);
end;
{ ---------------------------------------------------------------------------- }
const
    ArrowDirection: array [TCanvasOrientation] of TScrollDirection = (sdRight, sdLeft);

var
    Details: TThemedElementDetails;
    CaptionRect: TRect;
    CellRect: TRect;
    MultiSelected: Boolean;
    OldDefaultDrawing: Boolean;
begin
    if ThemeServices.ThemesEnabled then
    begin
        CellRect := aRect;

        { Linha de títulos }
        if DrawingTitle then
        begin
            CaptionRect := ARect;
            CellRect.Right := CellRect.Right + 1;
            CellRect.Bottom := CellRect.Bottom + 1;

            { Coluna de indicadores }
            if DrawingIndicator then
            begin
              Details := ThemeServices.GetElementDetails(thHeaderItemNormal);
              ThemeServices.DrawElement(Canvas.Handle, Details, CellRect);
            end
            { Colunas de campos }
            else
            begin
                { Coluna normal (n�o pressionada) }
                if (not FPaintInfo.ColPressed) or (FPaintInfo.ColPressedIdx <> ACol) then
                begin
                    if (FPaintInfo.MouseInCol = -1) or (FPaintInfo.MouseInCol <> ACol) or (csDesigning in ComponentState) then
                        Details := ThemeServices.GetElementDetails(thHeaderItemNormal)
                    else
                        Details := ThemeServices.GetElementDetails(thHeaderItemHot);
                end
                { Coluna pressionada }
                else if dgAllowTitleClick in FOptionsEx then
                begin
                  Details := ThemeServices.GetElementDetails(thHeaderItemPressed);
                  InflateRect(CaptionRect, -1, 1);
                end
                { Coluna normal (n�o pressionada) }
                else
                begin
                    if FPaintInfo.MouseInCol = ACol then
                        Details := ThemeServices.GetElementDetails(thHeaderItemHot)
                    else
                        Details := ThemeServices.GetElementDetails(thHeaderItemNormal);
                end;

                ThemeServices.DrawElement(Canvas.Handle, Details, CellRect);
                DrawTitleCellText(ARow,Columns[ACol - ColumnOffset]);
                DrawSortArrow(ARow,Columns[ACol - ColumnOffset]);
            end;
        end
        { Linhas normais, isto é, que não são o título. Este bloco será
        executado inclusive para colunas fixas (de indicadores) }
        else
        begin
          { Aqui não estamos na linha de título, mas precisamos saber se estamos
          tentando pintar uma coluna fixa (de indicadores). Se não estivermos
          tentanto pintar uma coluna de indicadores, executamos o procedimento
          normal, atravéz de inherited }
          if not DrawingIndicator then
          begin
            OldDefaultDrawing := DefaultDrawing;
            try
              DefaultDrawing := True;
              inherited
            finally
              DefaultDrawing := OldDefaultDrawing;
            end;
          end
          { Aqui, estamos verdadeiramente na coluna de indicadores, e por este
          motivo, precisamos pintar o fundo da mesma. Veja a definição do método
          DrawCellBackground em Grids.pas para saber como pintar de 3 formas
          diferentes: Com temas, sem temas e com gradientes }
          else
            DrawIndicatorCellBackground;
        end;

        { Caso eu esteja pintando a coluna de indicadores eu tenho de pintar os
        meus indicadores personalizados }
        if DrawingIndicator then
          DrawIndicatorsAndMore(MultiSelected);
    end
    { Se os temas não estiverem habilitados... }
    else
    begin
      if DrawingIndicator and not (DrawingIndicator and DrawingTitle) then
      begin
        DrawIndicatorCellBackground;
        DrawIndicatorsAndMore(MultiSelected);
      end
      else
      begin
        OldDefaultDrawing := DefaultDrawing;
        try
          DefaultDrawing := True;
          inherited
        finally
          DefaultDrawing := OldDefaultDrawing;
        end;
      end;
    end;
end;

{ Este método pinta célula por célula. Qundo uma seleção seleciona todas as
células de uma linha sem separação, quer dizer que os rects de cada célula foram
expandidos para que as separações sumissem }
procedure TCustomZTODBGrid.DrawColumnCell(const Rect: TRect; DataCol: Integer; Column: TColumn; State: TGridDrawState);
{ ---------------------------------------------------------------------------- }
function RecordNumber: Int64;
begin
  if (Column.Field.DataSet.RecNo = -1) and Assigned(DataSource.DataSet.FindField('RECNO')) then
    Result := DataSource.DataSet.FieldByName('RECNO').AsInteger
  else
    Result := Column.Field.DataSet.RecNo;
end;

procedure DrawCellHighlightOnColoredRow;
var
  LRect: TRect;
  LTheme: Cardinal;
  LColor: TColorRef;
begin
  if dgRowSelect in Options then
    Include(State, gdRowSelected);

  if ThemeServices.ThemesEnabled and (Win32MajorVersion >= 6) then
  begin
    Canvas.Brush.Style := bsSolid;
    Canvas.FillRect(Rect);
    LTheme := ThemeServices.Theme[teMenu];
    LRect := Rect;

    { o bloco IF abaixo serve para ajustar o RECT quando a opção RowSelect
    estiver ativada, de forma a exibir um único highlight. Comente isso para ver
    um efeito interessante }
    if (gdRowSelected in State) then
    begin
      if (DataCol + IndicatorOffset >= FixedCols + 1) and ((DataCol + IndicatorOffset) < ColCount - 1) then
        InflateRect(LRect, 4, 0)
      else if (DataCol + IndicatorOffset) = FixedCols then
        Inc(LRect.Right, 4)
      else if (DataCol + IndicatorOffset) = (ColCount - 1) then
        Dec(LRect.Left, 4);
    end;

    DrawThemeBackground(LTheme, Canvas.Handle, MENU_POPUPITEM, MPI_HOT, LRect, {$IFNDEF CLR}@{$ENDIF}Rect);
    GetThemeColor(LTheme, MENU_POPUPITEM, MPI_HOT, TMT_TEXTCOLOR, LColor);
    Canvas.Font.Color := LColor;
    Canvas.Brush.Style := bsClear;
  end
  else
  begin
    Canvas.Brush.Color := clHighlight;
    Canvas.Font.Color := clHighlightText;
  end;
end;
{ ---------------------------------------------------------------------------- }
var
  IsColoredRow: Boolean;
  Index: -1..255;
begin
	IsColoredRow := False;

  { Se tiver cores para pintar linhas, então usa... }
	if (FRowColors.Count > 0) and Assigned(Column.Field) and Assigned(Column.Field.DataSet) then
  begin
    Index := Pred(Pred(RecordNumber) mod Succ(FRowColors.Count));

    if Index > -1 then
    begin
      Canvas.Brush.Color := FRowColors.Items[Index].BackgroundColor;

      { Caso a cor clNone tenha sido atribuída para ForegroundColor, não devemos
      mudar a cor da fonte. Isso serve para que tenhamos colunas específicas com
      cores de fonte específicas. }
      if FRowColors.Items[Index].ForegroundColor <> clNone then
        Canvas.Font.Color := FRowColors.Items[Index].ForegroundColor;

      { Pinta o retângulo de seleção se a linha for a linha selecionada e se for
      para mostrar sempre a seleção ou se o nosso grid tiver o foco }
      if (gdSelected in State) and ((dgAlwaysShowSelection in Options) or Focused) then
        DrawCellHighlightOnColoredRow;

      { Se aqui mudamos o fundo, indica que precisamos escrever o texto}
      IsColoredRow := True;
    end;
  end;

	// aqui deve-se pintar as colunas especiais inteiras, sobrescrevendo sempre a cor colocada pela linha
  // if FColumnColors.Count > 0 then

  { Isso foi colocado aqui, separadamente, pois algum dia, se fizermos algo para
  as colunas, precisamos fazer isso apenas no final, ao pintar linhas e colunas.
  O efeito é aplicar as alterações feitas na coluna em questão, pintando seu
  fundo e seu texto }
  if IsColoredRow then
    DefaultDrawColumnCell(Rect, DataCol, Column, State);

  inherited;
end;

function TCustomZTODBGrid.GetOptions: TDBGridOptions;
begin
  Result := inherited Options;
end;

procedure TCustomZTODBGrid.KeyDown(var Key: Word; Shift: TShiftState);
{ ---------------------------------------------------------------------------- }
procedure ClearSelection;
begin
  if dgMultiSelect in Options then
  begin
    if not (dgPersistentSelection in FOptionsEx) then
      SelectedRows.Clear;
  end;
end;

procedure DoSelection(Select: Boolean; Direction: Integer);
var
    CanChangeSelection: Boolean;
begin
    BeginUpdate;
    try
        if (dgMultiSelect in Options) and Datalink.Active then
            if Select and (ssShift in Shift) then
            begin
                CanChangeSelection := True; { Por padr�o sempre pode mudar a sele��o }
                if Assigned(FOnBeforeMultiSelect) then
                    FOnBeforeMultiSelect(Self,msetKeyDown,CanChangeSelection);

                if CanChangeSelection then
                begin
                    SelectedRows.CurrentRowSelected := not SelectedRows.CurrentRowSelected;

                    if Assigned(FOnAfterMultiSelect) then
                        FOnAfterMultiSelect(Self,msetKeyDown);
                end;
            end
            else
                ClearSelection;

        if Direction <> 0 then
            Datalink.DataSet.MoveBy(Direction);
    finally
        EndUpdate;
    end;
end;

procedure NextRow(Select: Boolean);
begin
    with Datalink.Dataset do
    begin
        if (State = dsInsert) and not Modified and not TGridDataLnk(Datalink).FModified then
            if DataLink.EOF then
                Exit
            else
                Cancel
        else
            DoSelection(Select, 1);

        if (dgAllowAppendAfterEof in FOptionsEx) and DataLink.EOF and CanModify and (not ReadOnly) and (dgEditing in Options) then
            Append;
    end;
end;

procedure PriorRow(Select: Boolean);
begin
    with Datalink.Dataset do
        if (State = dsInsert) and not Modified and DataLink.EOF and not TGridDataLnk(Datalink).FModified then
            Cancel
        else
            DoSelection(Select, -1);
end;

procedure Tab(GoForward: Boolean);
var
    ACol, Original: Integer;
begin
    ACol := Col;
    Original := ACol;
    BeginUpdate;
    try
        while True do
        begin
            if GoForward then
                Inc(ACol)
            else
                Dec(ACol);

            if ACol >= ColCount then
            begin
                NextRow(False);
                ACol := IndicatorOffset;
            end
            else if ACol < IndicatorOffset then
            begin
                PriorRow(False);
                ACol := ColCount - IndicatorOffset;
            end;

            if ACol = Original then
                Exit;
            if TabStops[ACol] then
            begin
                MoveCol(ACol, 0);
                Exit;
            end;
        end;
    finally
        EndUpdate;
    end;
end;

function DeletePrompt: Boolean;
var
  S: String;
begin
  if (SelectedRows.Count > 1) then
    S := 'Deseja excluir todos os registros selecionados?'
  else
    S := 'Deseja excluir este registro?';

  Result := not (dgConfirmDelete in Options) or (MessageBox(Handle,{$IFDEF VER180}PAnsiChar{$ELSE}PWideChar{$ENDIF}(S),'Por favor confirme...', MB_ICONQUESTION or MB_YESNO or MB_DEFBUTTON2) = IDYES);
end;
{ ---------------------------------------------------------------------------- }
const
    RowMovementKeys = [VK_UP, VK_PRIOR, VK_DOWN, VK_NEXT, VK_HOME, VK_END];
var
    KeyDownEvent: TKeyEvent;
begin
    KeyDownEvent := OnKeyDown;

    if Assigned(KeyDownEvent) then
    	KeyDownEvent(Self, Key, Shift);

    if not Datalink.Active or not CanGridAcceptKey(Key, Shift) then
    	Exit;

    if UseRightToLeftAlignment then
	    if Key = VK_LEFT then
        	Key := VK_RIGHT
        else if Key = VK_RIGHT then
        	Key := VK_LEFT;

    with Datalink.DataSet do
	    if ssCtrl in Shift then
    	begin
            if (Key in RowMovementKeys) then
                ClearSelection;

            case Key of
                VK_UP, VK_PRIOR: DataLink.DataSet.MoveBy(-Datalink.ActiveRecord);
                VK_DOWN, VK_NEXT: DataLink.DataSet.MoveBy(Datalink.BufferCount - Datalink.ActiveRecord - 1);
                VK_LEFT: MoveCol(IndicatorOffset, 1);
                VK_RIGHT: MoveCol(ColCount - 1, -1);
                VK_HOME: First;
                VK_END: Last;
                VK_DELETE:
                	if (not ReadOnly) and not IsEmpty and CanModify and DeletePrompt then
                    	if SelectedRows.Count > 0 then
                        	SelectedRows.Delete
	                    else
    	                    Delete;
            end;
        end
	    else
            case Key of
	            VK_UP: PriorRow(True);
    	        VK_DOWN: NextRow(True);
        	    VK_LEFT:
                    if ssShift in Shift then  { TODO : CFDBGRID }
                    	DoSelection(True,0)
                	else if dgRowSelect in Options then
                		PriorRow(False)
	                else
                    	MoveCol(Col - 1, -1);
                VK_RIGHT:
                    if ssShift in Shift then  { TODO : CFDBGRID }
                    	DoSelection(True,0)
                	else if dgRowSelect in Options then
                    	NextRow(False)
                    else
                    	MoveCol(Col + 1, 1);
                VK_HOME:
                	if (ColCount = Succ(IndicatorOffset)) or (dgRowSelect in Options) then
                    begin
                        ClearSelection;
			            First
                    end
		            else
                    	MoveCol(IndicatorOffset, 1);
                VK_END:
                	if (ColCount = Succ(IndicatorOffset)) or (dgRowSelect in Options) then
                    begin
                        ClearSelection;
                    	Last;
                    end
                    else
                    	MoveCol(ColCount - 1, -1);
	            VK_NEXT: begin
                    ClearSelection;
                    DataLink.DataSet.MoveBy(VisibleRowCount);
                end;
                VK_PRIOR: begin
                    ClearSelection;
                    DataLink.DataSet.MoveBy(-VisibleRowCount);
                end;
	            VK_INSERT:
                	if CanModify and (not ReadOnly) and (dgEditing in Options) then
                    begin
                        ClearSelection;
			            Insert;
                    end;
            	VK_TAB:
                	if not (ssAlt in Shift) then
                    	Tab(not (ssShift in Shift));
                VK_ESCAPE: begin
                	if SysLocale.PriLangID = LANG_KOREAN then
                    	FIsESCKey := True;

                    Datalink.Reset;
                    ClearSelection;
					if not (dgAlwaysShowEditor in Options) then
                    	HideEditor;
	            end;
                VK_F2: EditorMode := True;
            end;
end;

procedure TCustomZTODBGrid.LayoutChanged;
begin
    inherited;
    if dgAutomaticColumSizes in FOptionsEx then
        AdjustColumns;
end;

function TCustomZTODBGrid.AcquireFocus: Boolean;
begin
    Result := True;
    if CanFocus and not (csDesigning in ComponentState) then
    begin
	    SetFocus;
    	Result := Focused or (InplaceEditor <> nil) and InplaceEditor.Focused;
    end;
end;

{ Esta fun��o era privada na classe pai, por isso tive de redeclara-la aqui. S�
n�o pude testar seu funcionamento pois n�o sei como ela � chamada! }
procedure TCustomZTODBGrid.UpdateData;
var
  	Field: TField;
begin
  	Field := SelectedField;

  	if Assigned(Field) then
    	Field.Text := GetEditText(Col,Row); //FEditText
end;

procedure TCustomZTODBGrid.UpdateScrollBar;
begin
    if not (dgHideVerticalScrollBar in FOptionsEx) then
        inherited;
end;

procedure TCustomZTODBGrid.MouseDown(Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
{ ---------------------------------------------------------------------------- }
function ClickedOnCheckBox(MousePosition: TPoint): Boolean;
var
    CheckBoxRect: TRect;
begin
    CheckBoxRect.Left := 2;

    CheckBoxRect.Right := CheckBoxRect.Left + GetSystemMetrics(SM_CXMENUCHECK);

    if dgRowLines in Options then
        CheckBoxRect.Top := Succ(RowHeights[0]) + Pred(Row) * Succ(DefaultRowHeight)
    else
        CheckBoxRect.Top := RowHeights[0] + Pred(Row) * DefaultRowHeight;

    CheckBoxRect.Top := CheckBoxRect.Top + (DefaultRowHeight - GetSystemMetrics(SM_CYMENUCHECK)) div 2;
    CheckBoxRect.Bottom := CheckBoxRect.Top + GetSystemMetrics(SM_CYMENUCHECK);
    Result := PtInRect(CheckBoxRect,MousePosition);
end;
{ ---------------------------------------------------------------------------- }
var
    GridCoord: TGridCoord;
    MousePos: TPoint;
    OldCol, OldRow: Integer;
    MasterCol: TColumn;
    CanChangeSelection: Boolean;
begin
    { Theme DB Grid }
    if not (csDesigning in ComponentState) then
    begin
        FPaintInfo.ColSizing := Sizing(X, Y);
        if not FPaintInfo.ColSizing then
        begin
            FPaintInfo.ColPressedIdx := -1;
            FPaintInfo.ColPressed := False;

            if dgAllowTitleClick in FOptionsEx then
                FPaintInfo.MouseInCol := -1;

            GridCoord := MouseCoord(X,Y);

            if (Button = mbLeft) and (GridCoord.X >= IndicatorOffset) and (GridCoord.Y >= 0) and (dgAllowTitleClick in FOptionsEx) then
            begin
                FPaintInfo.ColPressed := GridCoord.Y < TitleOffset;
                if FPaintInfo.ColPressed then
                begin
                    FPaintInfo.ColPressedIdx := Columns[RawToDataColumn(GridCoord.X)].Index + ColumnOffset;
                end;

                if ValidCell(FCell) then
                    InvalidateCell(FCell.X, FCell.Y);

                FCell := GridCoord;
            end;
        end;
    end;

    { CFDBGrid }
	if not AcquireFocus then
    	Exit;

	if (ssDouble in Shift) and (Button = mbLeft) then
	begin
		DblClick;
		Exit;
	end;

	if Sizing(X, Y) then
	begin
		TGridDataLnk(Datalink).UpdateData;
        inherited MouseDown(Button, Shift, X, Y);
		Exit;
	end;

	GridCoord := MouseCoord(X, Y);

	if (GridCoord.X < 0) and (GridCoord.Y < 0) then
	begin
		if (DataLink <> nil) and (DataLink.Editing) then
			UpdateData;

		inherited MouseDown(Button, Shift, X, Y);
		Exit;
	end;

	if (DragKind = dkDock) and (GridCoord.X < IndicatorOffset) and (GridCoord.Y < TitleOffset) and (not (csDesigning in ComponentState)) then
	begin
		BeginDrag(false);
		Exit;
	end;

	if PtInExpandButton(X,Y, MasterCol) then
	begin
		MasterCol.Expanded := not MasterCol.Expanded;
		ReleaseCapture;
		UpdateDesigner;
		Exit;
	end;

	MousePos.x := X;
	MousePos.y := Y;

	if ((csDesigning in ComponentState) or (dgColumnResize in Options)) and (GridCoord.Y < TitleOffset) then
	begin
		TGridDataLnk(DataLink).UpdateData;
		inherited MouseDown(Button, Shift, X, Y);
		Exit;
	end;

	if Datalink.Active then
		with GridCoord do
		begin
			BeginUpdate;	 { eliminates highlight flicker when selection moves }
			try
				TGridDataLnk(DataLink).UpdateData; // validate before moving
				HideEditor;
				OldCol := Col;
				OldRow := Row;
				if (Y >= TitleOffset) and (Y - Row <> 0) then
					TGridDataLnk(DataLink).MoveBy(Y - Row);

				if X >= IndicatorOffset then
					MoveCol(X, 0);

				if (Button = mbLeft) and (dgMultiSelect in Options) and Datalink.Active then
                    if ClickedOnCheckBox(MousePos) then
                    begin
                        CanChangeSelection := True; { Por padr�o sempre pode mudar a sele��o }
                        if Assigned(FOnBeforeMultiSelect) then
                            FOnBeforeMultiSelect(Self,msetMouseDown,CanChangeSelection);

                        if CanChangeSelection then
                        begin
                            SelectedRows.CurrentRowSelected := not SelectedRows.CurrentRowSelected;

                            if Assigned(FOnAfterMultiSelect) then
                                FOnAfterMultiSelect(Self,msetMouseDown);
                        end;
                    end
                    else
                        if not (dgPersistentSelection in FOptionsEx) then
                            SelectedRows.Clear;

				if (Button = mbLeft) and (((X = OldCol) and (Y = OldRow)) or (dgAlwaysShowEditor in Options)) then
					ShowEditor				 { put grid in edit mode }
				else
					InvalidateEditor;	{ draw editor, if needed }
			finally
				EndUpdate;
			end;
		end;
end;

procedure TCustomZTODBGrid.MouseMove(Shift: TShiftState; X, Y: Integer);
var
    lCell: TGridCoord;
    lMouseInCol: Integer;
begin
    if not (csDesigning in ComponentState) then
    begin
        if (not FPaintInfo.ColSizing) and (not FPaintInfo.ColMoving) then
        begin
            FPaintInfo.MouseInCol := -1;
            lCell := MouseCoord(X,Y);

            if (lCell.X >= IndicatorOffset) and (lCell.Y >= 0) then
            begin
                if (lCell.Y < TitleOffset) then
                begin
                    lMouseInCol := Columns[RawToDataColumn(lCell.X)].Index + ColumnOffset;

                    if lMouseInCol <> FPaintInfo.MouseInCol then
                    begin
                        InvalidateCell(lCell.X, lCell.Y);
                        FPaintInfo.MouseInCol := lMouseInCol;
                    end;
                end;
            end;

            if ValidCell(FCell) then
                InvalidateCell(FCell.X, FCell.Y);

            FCell := lCell;
        end;
    end;

    inherited;
end;

procedure TCustomZTODBGrid.MouseUp(Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
    inherited;
    FPaintInfo.ColSizing := False;
    FPaintInfo.ColMoving := False;
    FPaintInfo.ColPressedIdx := -1;
    Invalidate;
end;

procedure TCustomZTODBGrid.MoveCol(RawCol, Direction: Integer);
var
  	OldCol: Integer;
begin
  	TGridDataLnk(Datalink).UpdateData;

  	if RawCol >= ColCount then
    	RawCol := ColCount - 1;

  	if RawCol < IndicatorOffset then
    	RawCol := IndicatorOffset;

  	if Direction <> 0 then
  	begin
    	while (RawCol < ColCount) and (RawCol >= IndicatorOffset) and (ColWidths[RawCol] <= 0) do
      		Inc(RawCol, Direction);

        if (RawCol >= ColCount) or (RawCol < IndicatorOffset) then
        	Exit;
    end;

    OldCol := Col;

    if RawCol <> OldCol then
    begin
    	if not FInColExit then
        begin
        	FInColExit := True;
            try
            	ColExit;
            finally
            	FInColExit := False;
            end;

        	if Col <> OldCol then
            	Exit;
        end;

        if not (dgAlwaysShowEditor in Options) then
        	HideEditor;

        Col := RawCol;
        ColEnter;
    end;
end;

procedure TCustomZTODBGrid.Paint;
begin
    if ThemeServices.ThemesEnabled then
    begin
        { Quando os temas est�o habilitados removemos as linhas verticais pretas
        existentes em volta das celulas }
        TStringGrid(Self).Options := TStringGrid(Self).Options - [goFixedVertLine];
        TStringGrid(Self).Options := TStringGrid(Self).Options - [goFixedHorzLine];
    end;
    inherited;
end;

function TCustomZTODBGrid.PtInExpandButton(X, Y: Integer; var MasterCol: TColumn): Boolean;
var
    Cell: TGridCoord;
    R: TRect;
begin
    MasterCol := nil;
    Result := False;
    Cell := MouseCoord(X,Y);
    if (Cell.Y < TitleOffset) and Datalink.Active and (Cell.X >= IndicatorOffset) and (RawToDataColumn(Cell.X) < Columns.Count) then
    begin
        R := CalcTitleRect(Columns[RawToDataColumn(Cell.X)], Cell.Y, MasterCol);
        if not UseRightToLeftAlignment then
            R.Left := R.Right - GetSystemMetrics(SM_CXHSCROLL)
        else
            R.Right := R.Left + GetSystemMetrics(SM_CXHSCROLL);
        Result := MasterCol.Expandable and PtInRect(R, Point(X,Y));
    end;
end;

procedure TCustomZTODBGrid.SetColumnAttributes;
begin
    inherited;
  	if (dgIndicator in Options) then
    	ColWidths[0] := FPaintInfo.IndicatorsWidth;
end;

procedure TCustomZTODBGrid.SetOptions(const Value: TDBGridOptions);
const
	{ Estas são as opções que necessitam de refresh no layout }
	LayoutOptions = [dgEditing, dgAlwaysShowEditor, dgTitles, dgIndicator, dgColLines, dgRowLines, dgRowSelect, dgAlwaysShowSelection, dgMultiSelect];
var
  NewOptions, ChangedOptions, OldOptions: TDBGridOptions;
begin
    OldOptions := inherited Options;
    NewOptions := Value;

    if NewOptions <> OldOptions then
    begin
        { Diferen�as entre as opções antigas e as novas op��es }
        ChangedOptions := (OldOptions + NewOptions) - (OldOptions * NewOptions);

        if dgMultiSelect in NewOptions then
        begin
            FPaintInfo.IndicatorsWidth := 31;
            { Agora, quando é multiselect, são necessários os indicadores }
            Include(NewOptions,dgIndicator);
        end
        else
            FPaintInfo.IndicatorsWidth := 17;

        if (dgAutomaticColumSizes in FOptionsEx) and (dgColumnResize in NewOptions) then
        begin
          	Exclude(NewOptions,dgColumnResize);
            MessageBox(Handle,'Não é possível usar colunas redimensionáveis quando o modo de tamanho automático de colunas está ativado','Opção inválida',MB_ICONWARNING);
        end;

        inherited Options := NewOptions;
        { Se houve mudan�a em alguma das op��es de layout que geram refresh,
        devemos indicar isso chamando LayoutChanged }
        if ChangedOptions * LayoutOptions <> [] then
        	LayoutChanged;
    end;
end;

procedure TCustomZTODBGrid.SetOptionsEx(const Value: TDBGridOptionsEx);
const
	{ Estas s�o as op��es que necessitam de refresh no layout }
	LayoutOptions = [dgHideVerticalScrollBar, dgAutomaticColumSizes];
var
    NewOptions, ChangedOptions, OldOptions: TDBGridOptionsEx;
begin
    OldOptions := FOptionsEx;
    NewOptions := Value;

    if NewOptions <> OldOptions then
    begin
        { Diferen�as entre as op��es antigas e as novas op��es }
        ChangedOptions := (OldOptions + NewOptions) - (OldOptions * NewOptions);

        ShowScrollBar(Handle,SB_VERT,not (dgHideVerticalScrollBar in NewOptions));

        if dgAutomaticColumSizes in NewOptions then
          	Options := Options - [dgColumnResize];
        
        FOptionsEx := NewOptions;
        { Se houve mudan�a em alguma das op��es de layout que geram refresh,
        devemos indicar isso chamando LayoutChanged }
        if ChangedOptions * LayoutOptions <> [] then
        	LayoutChanged;
    end;
end;

procedure TCustomZTODBGrid.TitleClick(Column: TColumn);
begin
    if dgAllowTitleClick in FOptionsEx then
    begin
        inherited;

        FPaintInfo.ColPressed := False;
        FPaintInfo.ColPressedIdx := -1;

        if ValidCell(FCell) then
            InvalidateCell(FCell.X, FCell.Y);
    end;
end;

function TCustomZTODBGrid.ValidCell(ACell: TGridCoord): Boolean;
begin
    Result := (ACell.X <> -1) and (ACell.Y <> -1);
end;

procedure TCustomZTODBGrid.WMSize(var Message: TWMSize);
begin
    inherited;
    if dgAutomaticColumSizes in FOptionsEx then
		AdjustColumns;
end;

{ TRowColor }

procedure TRowColor.Assign(aSource: TPersistent);
begin
	FBackgroundColor := TRowColor(aSource).BackgroundColor;
  FForegroundColor := TRowColor(aSource).ForegroundColor;
end;

constructor TRowColor.Create(Collection: TCollection);
begin
  inherited;
  FBackgroundColor := clBtnFace;
  FForegroundColor := clNone;
end;

procedure TRowColor.SetBackgroundColor(const Value: TColor);
begin
	FBackgroundColor := Value;
  Changed(False);
end;

procedure TRowColor.SetForegroundColor(const Value: TColor);
begin
	FForegroundColor := Value;
  Changed(False);
end;

{ TRowColors }

function TRowColors.Add: TRowColor;
begin
	Result := TRowColor(inherited Add);
end;

constructor TRowColors.Create(aGrid: TCustomZTODBGrid);
begin
	inherited Create(TRowColor);
	FGrid := aGrid;
end;

function TRowColors.GetRowColor(Index: Integer): TRowColor;
begin
	Result := TRowColor(inherited Items[Index]);
end;

procedure TRowColors.SetRowColor(Index: Integer; const Value: TRowColor);
begin
	Items[Index].Assign(Value);
end;

procedure TRowColors.Update(Item: TCollectionItem);
begin
  inherited;
	FGrid.Invalidate;
end;

{ TSortArrow }

constructor TSortArrow.Create(aGrid: TCustomZTODBGrid);
begin
    FGrid := aGrid;
    FColumn := '';
    FPosition := sapRight;
    FDirection := sadNone;
end;

procedure TSortArrow.SetDirection(const Value: TSortArrowDirection);
begin
    FDirection := Value;
    FGrid.InvalidateTitles;
end;

procedure TSortArrow.SetPosition(const Value: TSortArrowPosition);
begin
    FPosition := Value;
    FGrid.InvalidateTitles;
end;

end.
