unit UXXXForm_AdminModule;

interface

uses
  	Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  	Dialogs, ActnList, ExtCtrls, StdCtrls, Mask, DBCtrls, Buttons, Grids,
    ComCtrls,

    UXXXTypesConstantsAndClasses, UXXXForm_ModuleTabbedTemplate,
    _StdCtrls, _DBCtrls,

    DBGrids, UCFDBGrid;

type
  	TXXXForm_AdminModule = class(TXXXForm_ModuleTabbedTemplate)
        PageControl_Administration: TPageControl;
        TabSheet_Permissions: TTabSheet;
        GroupBoxPermissoesDoGrupo: TGroupBox;
        CFDBGrid_PDG_Right: TCFDBGrid;
        GroupBoxGrupoConsultaRapida2: TGroupBox;
        LabelGrupoConsultarTipoDaEntidade: TLabel;
        LabelE2: TLabel;
        ComboBox_PDG_TI_TIPO: TComboBox;
        GroupBoxGrupoLegenda: TGroupBox;
        ImageGrupoSim: TImage;
        ImageGrupoNao: TImage;
        LabelGrupoSim: TLabel;
        LabelGrupoNao: TLabel;
        ImageGrupoNaoSeAplica: TImage;
        LabelGrupoNaoSeAplica: TLabel;
        GroupBoxPermissoesDoUsuario: TGroupBox;
        CFDBGrid_PDU_Right: TCFDBGrid;
        GroupBoxUsuarioConsultaRapida2: TGroupBox;
        LabelTipo2: TLabel;
        LabelE: TLabel;
        ComboBox_PDU_TI_TIPO: TComboBox;
        GroupBoxUsuarioLegenda: TGroupBox;
        ImageUsuarioSim: TImage;
        ImageUsuarioNao: TImage;
        LabelUsuarioAutorizado: TLabel;
        LabelUsuarioDesaltoriza: TLabel;
        ImageUsuarioNaoAplicavel: TImage;
        LabelUsuarioNaoAplicavel: TLabel;
        GroupBoxEntidadesDoSistema: TGroupBox;
    	CFDBGrid_EDS: TCFDBGrid;
        GroupBoxFiltro: TGroupBox;
        LabelTipo: TLabel;
        Label2: TLabel;
        ComboBox_EDS_TI_TIPO: TComboBox;
        BitBtn_EDS_Inserir: TBitBtn;
    BitBtn_EDS_Excluir: TBitBtn;
        BitBtn_EDS_AdicionarA: TBitBtn;
        PageControl_USU_GRU_Consultar: TPageControl;
        TabSheet_USU_Consultar: TTabSheet;
        GroupBoxUsuarioConsultaRapida: TGroupBox;
        Label3: TLabel;
        DBGrid_USU_Consultar: TCFDBGrid;
        TabSheet_GRU_Consultar: TTabSheet;
        GroupBoxGrupoConsultaRapida: TGroupBox;
        DBGrid_GRU_Consultar: TCFDBGrid;
        TabSheet_USU: TTabSheet;
        GroupBoxUsuariosConsultar2: TGroupBox;
        LabelE3: TLabel;
        Panel_USU_Layer: TPanel;
    SpeedButton_USU_Delete: TSpeedButton;
        SpeedButton_USU_Refresh: TSpeedButton;
    SpeedButton_USU_Edit: TSpeedButton;
    SpeedButton_USU_Insert: TSpeedButton;
        SpeedButton_USU_First: TSpeedButton;
        SpeedButton_USU_Previous: TSpeedButton;
        SpeedButton_USU_Next: TSpeedButton;
        SpeedButton_USU_Last: TSpeedButton;
        SpeedButton_USU_Post: TSpeedButton;
        SpeedButton_USU_Cancel: TSpeedButton;
        DBGrid_USU: TCFDBGrid;
        GroupBox_GDU: TGroupBox;
        Panel_GDU_Info: TPanel;
        Label_GDU_Info: TLabel;
    	CFDBGrid_GDU: TCFDBGrid;
        BitBtn_GDU_Adicionar: TBitBtn;
        BitBtn_GDU_Remover: TBitBtn;
        GroupBoxUsuariosCadastrar: TGroupBox;
        LabelUsuarioNome: TLabel;
        LabelUsuarioLogin: TLabel;
        LabelSenha1: TLabel;
        DBEdit_USU_VA_NOME: TDBEdit;
        DBEdit_USU_VA_LOGIN: TDBEdit;
        DBEdit_USU_TB_SENHA: TDBEdit;
        TabSheet_GRU: TTabSheet;
        GroupBoxGruposConsultar: TGroupBox;
        DBGrid_GRU: TCFDBGrid;
        Panel_GRU_Layer: TPanel;
    SpeedButton_GRU_Delete: TSpeedButton;
        SpeedButton_GRU_Refresh: TSpeedButton;
    SpeedButton_GRU_Edit: TSpeedButton;
    SpeedButton_GRU_Insert: TSpeedButton;
        SpeedButton_GRU_First: TSpeedButton;
        SpeedButton_GRU_Previous: TSpeedButton;
        SpeedButton_GRU_Next: TSpeedButton;
        SpeedButton_GRU_Last: TSpeedButton;
        SpeedButton_GRU_Post: TSpeedButton;
        SpeedButton_GRU_Cancel: TSpeedButton;
        GroupBoxGruposCadastrar: TGroupBox;
        LabelGrupoNome: TLabel;
        LabelGrupoDescricao: TLabel;
        DBEdit_GRU_VA_NOME: TDBEdit;
        DBEdit_GRU_VA_DESCRICAO: TDBEdit;
        CFDBGrid_PDU_Left: TCFDBGrid;
        CFDBGrid_PDG_Left: TCFDBGrid;
        Action_USU_First: TAction;
        Action_USU_Previous: TAction;
        Action_USU_Next: TAction;
        Action_USU_Last: TAction;
        Action_USU_Refresh: TAction;
        Action_USU_Cancel: TAction;
        Action_USU_Post: TAction;
        Action_GRU_First: TAction;
        Action_GRU_Previous: TAction;
        Action_GRU_Next: TAction;
        Action_GRU_Last: TAction;
        Action_GRU_Refresh: TAction;
        Action_GRU_Cancel: TAction;
        Action_GRU_Post: TAction;
	    Panel_FlushPrivileges: TPanel;
    	Label_FlushPrivileges: TLabel;
        LabeledEdit_USU_VA_NOME: TLabeledEdit;
        LabeledEdit_USU_VA_LOGIN: TLabeledEdit;
        LabeledEdit_GRU_VA_NOME: TLabeledEdit;
        LabeledEdit_USU_VA_NOME2: TLabeledEdit;
        LabeledEdit_USU_VA_LOGIN2: TLabeledEdit;
        LabeledEdit_GRU_VA_NOME2: TLabeledEdit;
        LabeledEdit_EDS_VA_NOME: TLabeledEdit;
        LabeledEdit_PDU_VA_NOME: TLabeledEdit;
        LabeledEdit_PDG_VA_NOME: TLabeledEdit;
        DBEdit_USU_VA_EMAIL: TDBEdit;
        Label_USU_VA_EMAIL: TLabel;
        procedure PageControl_USU_GRU_ConsultarChange(Sender: TObject);
        procedure DoChanging(Sender: TObject; var AllowChange: Boolean);
        procedure CFDBGrid_PDG_RightKeyPress(Sender: TObject; var Key: Char);
        procedure Action_USU_FirstExecute(Sender: TObject);
        procedure Action_USU_PreviousExecute(Sender: TObject);
        procedure Action_USU_NextExecute(Sender: TObject);
        procedure Action_USU_RefreshExecute(Sender: TObject);
        procedure Action_USU_LastExecute(Sender: TObject);
        procedure Action_USU_CancelExecute(Sender: TObject);
        procedure Action_USU_PostExecute(Sender: TObject);
        procedure Action_GRU_FirstExecute(Sender: TObject);
        procedure Action_GRU_NextExecute(Sender: TObject);
        procedure Action_GRU_LastExecute(Sender: TObject);
        procedure Action_GRU_CancelExecute(Sender: TObject);
        procedure Action_GRU_PostExecute(Sender: TObject);
	    procedure CFDBGrid_EDSMultiSelect(Sender: TObject);
    	procedure CFDBGrid_GDUMultiSelect(Sender: TObject);
	    procedure Label_FlushPrivilegesClick(Sender: TObject);
    	procedure Label_FlushPrivilegesMouseEnter(Sender: TObject);
	    procedure Label_FlushPrivilegesMouseLeave(Sender: TObject);
        procedure LabeledEdit_USU_VA_NOMEEnter(Sender: TObject);
        procedure LabeledEdit_USU_VA_LOGINEnter(Sender: TObject);
        procedure LabeledEdit_USU_VA_NOMEChange(Sender: TObject);
        procedure LabeledEdit_USU_VA_LOGINChange(Sender: TObject);
        procedure LabeledEdit_GRU_VA_NOMEChange(Sender: TObject);
        procedure LabeledEdit_USU_VA_NOME2Enter(Sender: TObject);
        procedure LabeledEdit_USU_VA_LOGIN2Enter(Sender: TObject);
        procedure LabeledEdit_USU_VA_NOME2Change(Sender: TObject);
        procedure LabeledEdit_USU_VA_LOGIN2Change(Sender: TObject);
        procedure LabeledEdit_GRU_VA_NOME2Change(Sender: TObject);
        procedure DoChange_EDS(Sender: TObject);
        procedure DoChange_PDU(Sender: TObject);
        procedure DoChange_PDG(Sender: TObject);
        procedure CFDBGrid_PDU_RightCellClick(Column: TColumn);
        procedure CFDBGrid_PDG_RightCellClick(Column: TColumn);
        procedure DoDrawColumnCell(Sender: TObject; const Rect: TRect; DataCol: Integer; Column: TColumn; State: TGridDrawState);
  	private
    	{ Private declarations }
  	public
    	{ Public declarations }
  	end;

implementation

uses
	DB, UXXXDataModule_Administration;

{$R *.dfm}

procedure TXXXForm_AdminModule.Action_GRU_CancelExecute(Sender: TObject);
begin
  	inherited;
    TXXXDataModule_Administration(MyDataModule).DBButtonClick_GRU(dbbCancel);
end;

procedure TXXXForm_AdminModule.Action_GRU_FirstExecute(Sender: TObject);
begin
  	inherited;
    TXXXDataModule_Administration(MyDataModule).DBButtonClick_GRU(dbbFirst);
end;

procedure TXXXForm_AdminModule.Action_GRU_LastExecute(Sender: TObject);
begin
  	inherited;
    TXXXDataModule_Administration(MyDataModule).DBButtonClick_GRU(dbbLast);
end;

procedure TXXXForm_AdminModule.Action_GRU_NextExecute(Sender: TObject);
begin
  	inherited;
    TXXXDataModule_Administration(MyDataModule).DBButtonClick_GRU(dbbNext);
end;

procedure TXXXForm_AdminModule.Action_GRU_PostExecute(Sender: TObject);
begin
  	inherited;
    TXXXDataModule_Administration(MyDataModule).DBButtonClick_GRU(dbbPost);
end;

procedure TXXXForm_AdminModule.Action_USU_CancelExecute(Sender: TObject);
begin
  	inherited;
    TXXXDataModule_Administration(MyDataModule).DBButtonClick_USU(dbbCancel);
end;

procedure TXXXForm_AdminModule.Action_USU_FirstExecute(Sender: TObject);
begin
  	inherited;
    TXXXDataModule_Administration(MyDataModule).DBButtonClick_USU(dbbFirst);
end;

procedure TXXXForm_AdminModule.Action_USU_LastExecute(Sender: TObject);
begin
  	inherited;
    TXXXDataModule_Administration(MyDataModule).DBButtonClick_USU(dbbLast);
end;

procedure TXXXForm_AdminModule.Action_USU_NextExecute(Sender: TObject);
begin
  	inherited;
    TXXXDataModule_Administration(MyDataModule).DBButtonClick_USU(dbbNext);
end;

procedure TXXXForm_AdminModule.Action_USU_PostExecute(Sender: TObject);
begin
  	inherited;
    TXXXDataModule_Administration(MyDataModule).DBButtonClick_USU(dbbPost);
end;

procedure TXXXForm_AdminModule.Action_USU_PreviousExecute(Sender: TObject);
begin
  	inherited;
    TXXXDataModule_Administration(MyDataModule).DBButtonClick_USU(dbbPrevious);
end;

procedure TXXXForm_AdminModule.Action_USU_RefreshExecute(Sender: TObject);
begin
  	inherited;
    TXXXDataModule_Administration(MyDataModule).DBButtonClick_USU(dbbRefresh);
end;

procedure TXXXForm_AdminModule.CFDBGrid_PDG_RightCellClick(Column: TColumn);
begin
    inherited;
    if Column.FieldName = Configurations.PermissionTableReadFieldName then
    	TXXXDataModule_Administration(MyDataModule).ToggleGroupReadPermission
    else if (Column.FieldName = Configurations.PermissionTableInsertFieldName) then
		TXXXDataModule_Administration(MyDataModule).ToggleGroupModifyPermission(mmInsert)
    else if (Column.FieldName = Configurations.PermissionTableUpdateFieldName) then
		TXXXDataModule_Administration(MyDataModule).ToggleGroupModifyPermission(mmUpdate)
    else if (Column.FieldName = Configurations.PermissionTableDeleteFieldName) then
		TXXXDataModule_Administration(MyDataModule).ToggleGroupModifyPermission(mmDelete);
end;

procedure TXXXForm_AdminModule.DoDrawColumnCell(Sender: TObject; const Rect: TRect; DataCol: Integer; Column: TColumn; State: TGridDrawState);
var
	OffsetLeft: Byte;
    OldPenStyle: TPenStyle;
begin
	inherited;
	{ Pinta a linha de seleção na linha selecionada em todas as colunas }
	TCFDBGrid(Sender).DefaultDrawColumnCell(Rect, DataCol, Column, State);
    if (Column.FieldName = 'TI_LER') or (Column.FieldName = 'TI_INSERIR') or (Column.FieldName = 'TI_ALTERAR') or (Column.FieldName = 'TI_EXCLUIR') then
    begin
        OffsetLeft := ((Rect.Right - Rect.Left) div 2) - 8;
        OldPenStyle := TCFDBGrid(Sender).Canvas.Pen.Style;
        TCFDBGrid(Sender).Canvas.Pen.Style := psClear;
        TCFDBGrid(Sender).Canvas.Rectangle(Rect);
        TCFDBGrid(Sender).Canvas.Pen.Style := OldPenStyle;
        case Column.Field.AsInteger of
            -1: TCFDBGrid(Sender).Canvas.Draw(Rect.Left + OffsetLeft,Rect.Top,ImageUsuarioNaoAplicavel.Picture.Graphic);
            0: TCFDBGrid(Sender).Canvas.Draw(Rect.Left + OffsetLeft,Rect.Top,ImageUsuarioNao.Picture.Graphic);
            1: TCFDBGrid(Sender).Canvas.Draw(Rect.Left + OffsetLeft,Rect.Top,ImageUsuarioSim.Picture.Graphic);
        end;
    end;
end;

procedure TXXXForm_AdminModule.CFDBGrid_PDG_RightKeyPress(Sender: TObject; var Key: Char);
begin
	inherited;
    CFDBGrid_PDG_RightCellClick(TXXXDataModule_Administration(MyDataModule).GetColumnByField(CFDBGrid_PDG_Right,CFDBGrid_PDG_Right.SelectedField));
end;

procedure TXXXForm_AdminModule.CFDBGrid_PDU_RightCellClick(Column: TColumn);
begin
    inherited;
    if Column.FieldName = Configurations.PermissionTableReadFieldName then
    	TXXXDataModule_Administration(MyDataModule).ToggleUserReadPermission
    else if (Column.FieldName = Configurations.PermissionTableInsertFieldName) then
		TXXXDataModule_Administration(MyDataModule).ToggleUserModifyPermission(mmInsert)
    else if (Column.FieldName = Configurations.PermissionTableUpdateFieldName) then
		TXXXDataModule_Administration(MyDataModule).ToggleUserModifyPermission(mmUpdate)
    else if (Column.FieldName = Configurations.PermissionTableDeleteFieldName) then
		TXXXDataModule_Administration(MyDataModule).ToggleUserModifyPermission(mmDelete);
end;

procedure TXXXForm_AdminModule.CFDBGrid_EDSMultiSelect(Sender: TObject);
begin
  	inherited;
    MyDataModule.SafeSetActionEnabled(TXXXDataModule_Administration(MyDataModule).Action_EDS_Delete,(CFDBGrid_EDS.SelectedRows.Count > 0) and TXXXDataModule_Administration(MyDataModule).Action_EDS_Delete.Allowed);
	MyDataModule.SafeSetActionEnabled(TXXXDataModule_Administration(MyDataModule).Action_PDU_PDG_Insert,(CFDBGrid_EDS.SelectedRows.Count > 0) and TXXXDataModule_Administration(MyDataModule).Action_PDU_PDG_Insert.Allowed);
end;

procedure TXXXForm_AdminModule.CFDBGrid_GDUMultiSelect(Sender: TObject);
begin
  	inherited;
    MyDataModule.SafeSetActionEnabled(TXXXDataModule_Administration(MyDataModule).Action_GDU_Delete,(CFDBGrid_GDU.SelectedRows.Count > 0) and TXXXDataModule_Administration(MyDataModule).Action_GDU_Delete.Allowed);
end;

procedure TXXXForm_AdminModule.DoChange_EDS(Sender: TObject);
begin
    inherited;
    TXXXDataModule_Administration(MyDataModule).LocalizarEntidadePorIdentificacaoETipo(LabeledEdit_EDS_VA_NOME,ComboBox_EDS_TI_TIPO);
end;

procedure TXXXForm_AdminModule.DoChange_PDG(Sender: TObject);
begin
    inherited;
    TXXXDataModule_Administration(MyDataModule).LocalizarPermissaoPorIdentificacaoETipo(LabeledEdit_PDG_VA_NOME
                                                                                       ,ComboBox_PDG_TI_TIPO,'G');
end;

procedure TXXXForm_AdminModule.DoChange_PDU(Sender: TObject);
begin
    inherited;
    TXXXDataModule_Administration(MyDataModule).LocalizarPermissaoPorIdentificacaoETipo(LabeledEdit_PDU_VA_NOME
                                                                                       ,ComboBox_PDU_TI_TIPO,'U');
end;

procedure TXXXForm_AdminModule.DoChanging(Sender: TObject; var AllowChange: Boolean);
var
	PageControl: TPageControl;
    MyDM: TXXXDataModule_Administration;
begin
	inherited;
	PageControl := TPageControl(Sender);
    MyDM := TXXXDataModule_Administration(MyDataModule);

	if PageControl = PageControl_Administration then
		case PageControl.ActivePageIndex of
			1,2:
				if (MyDM.USUARIOS.State in [dsInsert, dsEdit])
                or (MyDM.GRUPOS.State in [dsInsert, dsEdit]) then
				begin
					MessageBox(Handle,PChar(PAGE_CHANGE_NOT_ALLOWED), PChar(ACTION_NOT_ALLOWED_NOW), MB_ICONWARNING or MB_OK);
					AllowChange := False;
				end;
		end;
end;

procedure TXXXForm_AdminModule.LabeledEdit_GRU_VA_NOME2Change(Sender: TObject);
begin
    inherited;
    TXXXDataModule_Administration(MyDataModule).LocalizarGrupoPorNome(LabeledEdit_GRU_VA_NOME2);
end;

procedure TXXXForm_AdminModule.LabeledEdit_GRU_VA_NOMEChange(Sender: TObject);
begin
    inherited;
    TXXXDataModule_Administration(MyDataModule).LocalizarGrupoPorNome(LabeledEdit_GRU_VA_NOME);
end;

procedure TXXXForm_AdminModule.LabeledEdit_USU_VA_LOGIN2Change(Sender: TObject);
begin
    inherited;
    TXXXDataModule_Administration(MyDataModule).LocalizarUsuarioPorLogin(LabeledEdit_USU_VA_LOGIN2);
end;

procedure TXXXForm_AdminModule.LabeledEdit_USU_VA_LOGIN2Enter(Sender: TObject);
begin
    inherited;
    LabeledEdit_USU_VA_LOGIN2.Clear;
end;

procedure TXXXForm_AdminModule.LabeledEdit_USU_VA_LOGINChange(Sender: TObject);
begin
    inherited;
    TXXXDataModule_Administration(MyDataModule).LocalizarUsuarioPorLogin(LabeledEdit_USU_VA_LOGIN);
end;

procedure TXXXForm_AdminModule.LabeledEdit_USU_VA_LOGINEnter(Sender: TObject);
begin
    inherited;
    LabeledEdit_USU_VA_NOME.Clear;
end;

procedure TXXXForm_AdminModule.LabeledEdit_USU_VA_NOME2Change(Sender: TObject);
begin
    inherited;
    TXXXDataModule_Administration(MyDataModule).LocalizarUsuarioPorNome(LabeledEdit_USU_VA_NOME2);
end;

procedure TXXXForm_AdminModule.LabeledEdit_USU_VA_NOME2Enter(Sender: TObject);
begin
    inherited;
    LabeledEdit_USU_VA_NOME2.Clear;
end;

procedure TXXXForm_AdminModule.LabeledEdit_USU_VA_NOMEChange(Sender: TObject);
begin
    inherited;
    TXXXDataModule_Administration(MyDataModule).LocalizarUsuarioPorNome(LabeledEdit_USU_VA_NOME);
end;

procedure TXXXForm_AdminModule.LabeledEdit_USU_VA_NOMEEnter(Sender: TObject);
begin
    inherited;
    LabeledEdit_USU_VA_LOGIN.Clear;
end;

procedure TXXXForm_AdminModule.Label_FlushPrivilegesClick(Sender: TObject);
begin
  	inherited;
    TXXXDataModule_Administration(MyDataModule).ApplySecurityPolicies(MyDataModule.DataModuleMain.ZConnections[0].Connection);
end;

procedure TXXXForm_AdminModule.Label_FlushPrivilegesMouseEnter(Sender: TObject);
begin
  	inherited;
	TLabel(Sender).Font.Style := TLabel(Sender).Font.Style + [fsUnderline];
end;

procedure TXXXForm_AdminModule.Label_FlushPrivilegesMouseLeave(Sender: TObject);
begin
  	inherited;
	TLabel(Sender).Font.Style := TLabel(Sender).Font.Style - [fsUnderline];
end;

procedure TXXXForm_AdminModule.PageControl_USU_GRU_ConsultarChange(Sender: TObject);
begin
  	inherited;
    if TPageControl(Sender).ActivePageIndex = 0 then
    begin
		GroupBoxPermissoesDoGrupo.Visible := False;
	    GroupBoxPermissoesDoUsuario.Visible := True;
        TXXXDataModule_Administration(MyDataModule).Action_PDU_PDG_Insert.Caption := 'Adic. p/ usuário';
    	BitBtn_EDS_AdicionarA.Spacing := 8;
//	    BitBtn_EDS_AdicionarA.Caption := 'Adic. p/ usuário';
    end
    else
    begin
	    GroupBoxPermissoesDoUsuario.Visible := False;
    	GroupBoxPermissoesDoGrupo.Visible := True;
        TXXXDataModule_Administration(MyDataModule).Action_PDU_PDG_Insert.Caption := 'Adic. p/ grupo';
	    BitBtn_EDS_AdicionarA.Spacing := 14;
//    	BitBtn_EDS_AdicionarA.Caption := 'Adic. p/ grupo';

    end;
end;

end.
