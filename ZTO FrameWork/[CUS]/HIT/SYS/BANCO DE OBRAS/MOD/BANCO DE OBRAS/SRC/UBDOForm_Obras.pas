unit UBDOForm_Obras;

interface

uses
    Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
    Dialogs, UXXXForm_ModuleTabbedTemplate, ActnList, ExtCtrls, StdCtrls,
    DBCtrls, Mask, Buttons, ComCtrls, Grids, DBGrids, UCFDBGrid, UBDOTypesConstantsAndClasses,
    CFEdit, Types, _StdCtrls, _DBCtrls, StdActns, ExtActns, URichEdit2Actions;

type
    TBDOForm_Obras = class(TXXXForm_ModuleTabbedTemplate)
        PageControl_ConsultasECadastro: TPageControl;
        TabSheet_Filtragem: TTabSheet;
        PageControl_Filtragem: TPageControl;
        TabSheet_OBR_SCH: TTabSheet;
        Label_OBR_TI_REGIOES_ID_Filtrar: TLabel;
        Label_OBR_VA_NOMEDAOBRA_Filtrar: TLabel;
        Label_OBR_SM_PROJETISTAS_ID_Filtrar: TLabel;
        Label_OBR_DA_DATADEENTRADA1_Filtrar: TLabel;
        Label_OBR_VA_CONSTRUTORA_Filtrar: TLabel;
        Label_OBR_TI_SITUACOES_ID_Filtrar: TLabel;
        Label_OBR_DA_DATADEENTRADA2_Filtrar: TLabel;
        Label_OBR_TI_TIPOS_ID_Filtrar: TLabel;
        Shape_OBR_FILTRO_RegistrosValor: TShape;
        Label_OBR_SCH_Registros: TLabel;
        Label_OBR_SCH_RegistrosValor: TLabel;
        Shape6: TShape;
        Label14: TLabel;
        Label_OBR_SCH_PaginasValor: TLabel;
        CFDBGrid_OBR_SCH: TCFDBGrid;
        Panel_OBR_FILTRO_Layer: TPanel;
        SpeedButton_OBR_SCH_Previous: TSpeedButton;
        SpeedButton_OBR_SCH_Next: TSpeedButton;
        SpeedButton_OBR_SCH_Last: TSpeedButton;
        SpeedButton_OBR_SCH_Refresh: TSpeedButton;
        GroupBox_OBR_LOCALIDADE_Filtrar: TGroupBox;
        Edit_OBRAS_SEARCH_VA_NOMEDAOBRA: TEdit;
        Edit_OBRAS_SEARCH_VA_CONSTRUTORA: TEdit;
        Edit_OBRAS_SEARCH_VA_CIDADE: TEdit;
        ComboBox_OBRAS_SEARCH_CH_ESTADO: TComboBox;
        ComboBox_OBRAS_SEARCH_SM_PROJETISTAS_ID: TComboBox;
        ComboBox_OBRAS_SEARCH_TI_SITUACOES_ID: TComboBox;
        CheckBox_OBR_SCH_DA_DATADEENTRADA1: TCheckBox;
        DateTimePicker_OBR_SCH_DA_DATADEENTRADA1: TDateTimePicker;
        CheckBox_OBR_SCH_DA_DATADEENTRADA2: TCheckBox;
        DateTimePicker_OBR_SCH_DA_DATADEENTRADA2: TDateTimePicker;
        ComboBox_OBRAS_SEARCH_TI_TIPOS_ID: TComboBox;
        ComboBox_OBRAS_SEARCH_TI_REGIOES_ID: TComboBox;
        PanelAviso: TPanel;
        ShapeAviso: TShape;
        ImageAviso: TImage;
        LabelAviso: TLabel;
        Panel1: TPanel;
        SpeedButton_OBR_FILTRO_PriPa: TSpeedButton;
        SpeedButton_OBR_FILTRO_PaAnt: TSpeedButton;
        SpeedButton_OBR_FILTRO_ProPa: TSpeedButton;
        SpeedButton_OBR_FILTRO_UltPa: TSpeedButton;
        ComboBox_OBR_SCH_TI_SITUACOES_ID: TComboBox;
        GroupBox_OBR_ComOuSemPropostas: TGroupBox;
        RadioButton_OBRAS_SEARCH_ComESemPropostas: TRadioButton;
        RadioButton_OBRAS_SEARCH_ComPropostas: TRadioButton;
        RadioButton_OBRAS_SEARCH_SemPropostas: TRadioButton;
        Panel4: TPanel;
        Shape4: TShape;
        Label6: TLabel;
        TabSheet_PRO_SCH: TTabSheet;
        Shape1: TShape;
        Label_PRO_FILTRO_VA_NOMEDAOBRA: TLabel;
        Label_PRO_FILTRO_SM_INSTALADORES_ID: TLabel;
        Label1: TLabel;
        Label_PRO_SCH_PaginasValor: TLabel;
        Shape2: TShape;
        Label2: TLabel;
        Label_PRO_SCH_RegistrosValor: TLabel;
        Label_PRO_VA_CONTATO_Filtrar: TLabel;
        CFDBGrid_PRO_SCH: TCFDBGrid;
        Panel_PRO_FILTRO_Info: TPanel;
        Shape_PRO_FILTRO_Info: TShape;
        Image_PRO_FILTRO_Info: TImage;
        Label_PRO_FILTRO_Info: TLabel;
        Panel_PRO_FILTRO_Layer: TPanel;
        SpeedButton_PRO_FILTRO_Primeiro: TSpeedButton;
        SpeedButton_PRO_FILTRO_Anterior: TSpeedButton;
        SpeedButton_PRO_FILTRO_Proximo: TSpeedButton;
        SpeedButton_PRO_FILTRO_Ultimo: TSpeedButton;
        SpeedButton_PRO_FILTRO_Atualizar: TSpeedButton;
        Edit_PRO_SCH_VA_NOMEDAOBRA: TEdit;
        ComboBox_PRO_SCH_SM_INSTALADORES_ID: TComboBox;
        RadioGroup_PRO_SCH_BO_PROPOSTAPADRAO: TRadioGroup;
        GroupBox_PRO_FILTRO_CODIGO: TGroupBox;
        CFEdit_PRO_SCH_SM_CODIGO: TCFEdit;
        CFEdit_PRO_SCH_YR_ANO: TCFEdit;
        Panel2: TPanel;
        SpeedButton_PRO_FILTRO_PriPa: TSpeedButton;
        SpeedButton_PRO_FILTRO_PaAnt: TSpeedButton;
        SpeedButton_PRO_FILTRO_ProPa: TSpeedButton;
        SpeedButton_PRO_FILTRO_UltPa: TSpeedButton;
        Panel5: TPanel;
        Shape8: TShape;
        Label5: TLabel;
        Edit_PRO_SCH_VA_CONTATO: TEdit;
        TabSheet_Cadastro: TTabSheet;
        PageControl_Cadastro: TPageControl;
        TabSheet_OBR_PRO: TTabSheet;
        GroupBox_OBR_Dados: TGroupBox;
        Label_OBR_TI_REGIOES_ID: TLabel;
        Label_OBR_NomeDaObra: TLabel;
        Label_OBR_TX_CONDICAODEPAGAMENTO: TLabel;
        Label_OBR_TI_TIPOS_ID: TLabel;
        Label_OBR_SM_PROJETISTAS_ID: TLabel;
        Label_OBR_DATADEENTRADA: TLabel;
        Label_OBR_FL_ICMS: TLabel;
        Label_OBR_Frete: TLabel;
        Label_OBR_TX_CONDICOESGERAIS: TLabel;
        Label_OBR_TX_OBSERVACOES: TLabel;
        Label_OBR_Construtora: TLabel;
        Label_OBR_TI_SITUACOES_ID: TLabel;
        Label_OBR_PrazoDeEntrega: TLabel;
        Label_OBR_CaracteresRestantes1: TLabel;
        Label_OBR_CaracteresRestantes2: TLabel;
        Label_OBR_CaracteresRestantes3: TLabel;
        DBLookupComboBox_OBR_TI_REGIOES_ID: TDBLookupComboBox;
        GroupBox_OBR_Localidade: TGroupBox;
        DBEdit_OBR_DATADEENTRADA: TDBEdit;
        DBEdit_OBR_EN_FRETE: TDBComboBox;
        DBEdit_OBR_Construtora: TDBEdit;
        DBLookupComboBox_OBR_SM_PROJETISTAS_ID: TDBLookupComboBox;
        DBLookupComboBox_OBR_TI_SITUACOES_ID: TDBLookupComboBox;
        DBEdit_OBR_VA_PRAZODEENTREGA: TDBEdit;
        DBMemo_OBR_TX_OBSERVACOES: TDBMemo;
        DBLookupComboBox_OBR_TI_TIPOS_ID: TDBLookupComboBox;
        TDBEdit_OBR_VA_CIDADE: TDBEdit;
        TDBComboBox_OBR_CH_ESTADO: TDBComboBox;
        DBLookupComboBox_OBR_FL_ICMS: TDBLookupComboBox;
        Panel_OBR_Layer: TPanel;
        SpeedButton_OBR_Inserir: TSpeedButton;
        SpeedButton_OBR_Excluir: TSpeedButton;
        SpeedButton_OBR_Editar: TSpeedButton;
        SpeedButton_OBR_Cancelar: TSpeedButton;
        SpeedButton_OBR_Salvar: TSpeedButton;
        SpeedButton_OBR_Atualizar: TSpeedButton;
        Panel8: TPanel;
        Shape12: TShape;
        DBText_OBR_IN_OBRAS_ID: TDBText;
        TabSheet_ITE_EDI: TTabSheet;
        Shape_ITE_Info: TShape;
        Bevel_ITE_Info: TBevel;
        Label_ITE_Info: TLabel;
        Shape3: TShape;
        Label_ITE_SubtotalDaProposta: TLabel;
        DBText_PRO_SUBTOTAL: TDBText;
        Shape5: TShape;
        Label_ITE_TotalDaProposta: TLabel;
        DBText_PRO_TOTAL: TDBText;
        CFDBGrid_ITE: TCFDBGrid;
        Panel_ITE_Layer: TPanel;
        SpeedButton_ITE_Primeiro: TSpeedButton;
        SpeedButton_ITE_Anterior: TSpeedButton;
        SpeedButton_ITE_Proximo: TSpeedButton;
        SpeedButton_ITE_Ultimo: TSpeedButton;
        SpeedButton_ITE_Inserir: TSpeedButton;
        SpeedButton_ITE_Excluir: TSpeedButton;
        SpeedButton_ITE_Editar: TSpeedButton;
        SpeedButton_ITE_Salvar: TSpeedButton;
        SpeedButton_ITE_Cancelar: TSpeedButton;
        SpeedButton_ITE_Atualizar: TSpeedButton;
        GroupBox_ITE_Dados: TGroupBox;
        Label_ITE_VA_DESCRICAO: TLabel;
        Label_ITE_SM_QUANTIDADE: TLabel;
        Label_ITE_FL_DESCONTO: TLabel;
        Label_ITE_TI_FAMILIAS_ID: TLabel;
        Label_ITE_EN_VOLTAGEM: TLabel;
        DBComboBox_ITE_VA_DESCRICAO: TDBComboBox;
        GroupBox_ITE_EDI: TGroupBox;
        Panel_EDI_Info: TPanel;
        Label_EDI_Info: TLabel;
        CFDBGrid_EDI: TCFDBGrid;
        DBEdit_ITE_SM_QUANTIDADE: TDBEdit;
        DBEdit_ITE_FL_DESCONTOPERC: TDBEdit;
        GroupBox_ITE_Capacidade: TGroupBox;
        Label_ITE_CapacidadeTermica: TLabel;
        DBEdit_ITE_FL_CAPACIDADE: TDBEdit;
        DBLookupComboBox_ITE_TI_UNIDADES_ID: TDBLookupComboBox;
        SpeedButton_EDI_RemoverEQP: TSpeedButton;
        SpeedButton_EDI_AdicionarEQP: TSpeedButton;
        DBLookupComboBox_ITE_TI_FAMILIAS_ID: TDBLookupComboBox;
        GroupBox_ITE_Info: TGroupBox;
        Label_ITE_Info4: TLabel;
        Label_ITE_Info2: TLabel;
        Label_ITE_Info5: TLabel;
        Label_ITE_Equipamentos: TLabel;
        DBText_ITE_LUCROBRUTO: TDBText;
        DBText_ITE_TOTAL: TDBText;
        DBComboBox_ITE_EN_VOLTAGEM: TDBComboBox;
        GroupBox_ITE_EQP: TGroupBox;
        Panel_EQP_Info: TPanel;
        Label_EQP_Info: TLabel;
        CFDBGrid_EQP: TCFDBGrid;
        GroupBox_EQP_Filtro: TGroupBox;
        Label_EQP_VA_DESCRICAOContem: TLabel;
        Edit_EQP_VA_MODELO: TEdit;
        Panel_ITE_LayerOrdem: TPanel;
        SpeedButton_ITE_MoverParaCima: TSpeedButton;
        SpeedButton_ITE_MoverParaBaixo: TSpeedButton;
        Shape10: TShape;
        Shape11: TShape;
        Label7: TLabel;
        Panel_OBR_DiasParaExpiracao: TPanel;
        Shape_OBR_DA_DATADEEXPIRACAO: TShape;
        Label_OBR_DA_DATADEEXPIRACAO: TLabel;
        Action_OBR_Post: TAction;
        Action_OBR_Cancel: TAction;
        Action_OBR_Refresh: TAction;
        Action_ITE_Post: TAction;
        Action_OBR_SCH_First: TAction;
        Action_OBR_SCH_Previous: TAction;
        Action_OBR_SCH_Next: TAction;
        Action_OBR_SCH_Last: TAction;
        Action_OBR_SCH_Refresh: TAction;
        Action_OBR_SCH_FirstPage: TAction;
        Action_OBR_SCH_PreviousPage: TAction;
        Action_OBR_SCH_NextPage: TAction;
        Action_OBR_SCH_LastPage: TAction;
        Action_OBR_SCH_Reset: TAction;
        Action_OBR_SCH_Details: TAction;
        Action_PRO_SCH_Details: TAction;
        Action_PRO_SCH_First: TAction;
        Action_PRO_SCH_Previous: TAction;
        Action_PRO_SCH_Next: TAction;
        Action_PRO_SCH_Last: TAction;
        Action_PRO_SCH_Refresh: TAction;
        Action_PRO_SCH_FirstPage: TAction;
        Action_PRO_SCH_PreviousPage: TAction;
        Action_PRO_SCH_NextPage: TAction;
        Action_PRO_SCH_LastPage: TAction;
        Action_PRO_SCH_Reset: TAction;
        Action_PRO_Post: TAction;
        Action_PRO_Cancel: TAction;
        Action_PRO_Refresh: TAction;
        Action_PRO_First: TAction;
        Action_PRO_Previous: TAction;
        Action_PRO_Next: TAction;
        Action_PRO_Last: TAction;
        GroupBox_PRO_BloqueiaProposta: TGroupBox;
        Label3: TLabel;
        Panel_PRO_Dados: TPanel;
        Shape_PRO_Info: TShape;
        Label_PRO_Info: TLabel;
        Bevel_PRO_Info: TBevel;
        CFDBGrid_PRO: TCFDBGrid;
        GroupBox_PRO_Dados: TGroupBox;
        Label_OBR_INSTALADOR: TLabel;
        Label_PRO_TI_VALIDADE: TLabel;
        Label_PRO_FL_DESCONTOVAL: TLabel;
        Label_PRO_FL_DESCONTOPERC: TLabel;
        Label_PRO_VA_COTACOES: TLabel;
        Label_PRO_DA_DATADEENTRADA: TLabel;
        Label_PRO_Contato: TLabel;
        DBLookupComboBox_PRO_SM_INSTALADORES_ID: TDBLookupComboBox;
        DBEdit_PRO_TI_VALIDADE: TDBEdit;
        DBEdit_PRO_FL_DESCONTOPERC: TDBEdit;
        DBEdit_PRO_FL_DESCONTOVAL: TDBEdit;
        Panel_PRO_Layer: TPanel;
        SpeedButton_PRO_Primeiro: TSpeedButton;
        SpeedButton_PRO_Anterior: TSpeedButton;
        SpeedButton_PRO_Proximo: TSpeedButton;
        SpeedButton_PRO_Ultimo: TSpeedButton;
        SpeedButton_PRO_Inserir: TSpeedButton;
        SpeedButton_PRO_Excluir: TSpeedButton;
        SpeedButton_PRO_Editar: TSpeedButton;
        SpeedButton_PRO_Salvar: TSpeedButton;
        SpeedButton_PRO_Cancelar: TSpeedButton;
        SpeedButton_PRO_Atualizar: TSpeedButton;
        DBEdit_PRO_DA_DATADEENTRADA: TDBEdit;
        DBEdit_PRO_Contato: TDBEdit;
        Panel6: TPanel;
        Shape9: TShape;
        Label8: TLabel;
        Image_Padrao: TImage;
        Image_NaoPadrao: TImage;
        Panel3: TPanel;
        Shape7: TShape;
        DBText_PRO_IN_PROPOSTAS_ID: TDBText;
        Panel_PRO_TI_MOEDA_VA_COTACOES: TPanel;
        SpeedButton_PRO_VA_COTACOES: TSpeedButton;
        DBComboBox_PRO_TI_MOEDA: TDBComboBox;
        CFDBGrid_PRO_Padrao: TCFDBGrid;
        Action_ITE_Cancel: TAction;
        Action_ITE_Refresh: TAction;
        Action_ITE_First: TAction;
        Action_ITE_Previous: TAction;
        Action_ITE_Next: TAction;
        Action_ITE_Last: TAction;
        Panel7: TPanel;
        Shape13: TShape;
        DBText_ITE_IN_ITENS_ID: TDBText;
        Action_EDI_DesmarcarTodos: TAction;
        Label_PRO_REAJUSTE: TLabel;
        DBText_PRO_REAJUSTE: TDBText;
        Shape14: TShape;
        Shape15: TShape;
        DBText_PRO_SUBTOTALSEMCOTACOES: TDBText;
        Label_PRO_SUBTOTALSEMCOTACOES: TLabel;
        Label_OBR_JustificativaSalva: TLabel;
        ComboBox_PRO_SCH_TI_SITUACOES_ID: TComboBox;
        TabSheet_EQP_SCH: TTabSheet;
        Label_EQP_SCH_INSTALADOR: TLabel;
        ComboBox_EQP_SCH_SM_INSTALADORES_ID: TComboBox;
        GroupBox_EQP_SCH_CODIGO: TGroupBox;
        CFEdit_EQP_SCH_SM_CODIGO: TCFEdit;
        CFEdit_EQP_SCH_YR_ANO: TCFEdit;
        RadioGroup_EQP_SCH_BO_PROPOSTAPADRAO: TRadioGroup;
        LabeledEdit_EQP_SCH_VA_MODELO: TLabeledEdit;
        ComboBox_EQP_SCH_EN_VOLTAGEM: TComboBox;
        Label_EQP_SCH_EN_VOLTAGEM: TLabel;
        Panel9: TPanel;
        Shape16: TShape;
        Label4: TLabel;
        Shape17: TShape;
        Label9: TLabel;
        Label_EQP_SCH_PaginasValor: TLabel;
        Shape18: TShape;
        Label11: TLabel;
        Label_EQP_SCH_RegistrosValor: TLabel;
        CFDBGrid_EQP_SCH: TCFDBGrid;
        Panel10: TPanel;
        Shape19: TShape;
        Image1: TImage;
        Label13: TLabel;
        Panel11: TPanel;
        SpeedButton_EQP_SCH_First: TSpeedButton;
        SpeedButton_EQP_SCH_Previous: TSpeedButton;
        SpeedButton_EQP_SCH_Next: TSpeedButton;
        SpeedButton_EQP_SCH_Last: TSpeedButton;
        SpeedButton_EQP_SCH_Refresh: TSpeedButton;
        Panel12: TPanel;
        SpeedButton_EQP_SCH_FirstPage: TSpeedButton;
        SpeedButton_EQP_SCH_PreviousPage: TSpeedButton;
        SpeedButton_EQP_SCH_NextPage: TSpeedButton;
        SpeedButton_EQP_SCH_LastPage: TSpeedButton;
        Action_EQP_SCH_Details: TAction;
        Action_EQP_SCH_First: TAction;
        Action_EQP_SCH_Previous: TAction;
        Action_EQP_SCH_Next: TAction;
        Action_EQP_SCH_Last: TAction;
        Action_EQP_SCH_Refresh: TAction;
        Action_EQP_SCH_FirstPage: TAction;
        Action_EQP_SCH_PreviousPage: TAction;
        Action_EQP_SCH_NextPage: TAction;
        Action_EQP_SCH_LastPage: TAction;
        Action_EQP_SCH_Reset: TAction;
        Image2: TImage;
        Image3: TImage;
        Image4: TImage;
        DBEdit_OBR_VA_NOMEDAOBRA: TDBEdit;
        SpeedButton_OBR_ObrasSemelhantes: TSpeedButton;
        Action_OBR_ObrasSemelhantes: TAction;
        DBRichEdit_OBR_TX_CONDICOESGERAIS: TDBRichEdit;
        DBRichEdit_OBR_TX_CONDICAODEPAGAMENTO: TDBRichEdit;
        GroupBox_EntregaPrevistaPara: TGroupBox;
        DBComboBox_OBR_YR_ANOPROVAVELDEENTREGA: TDBComboBox;
        DBComboBox_OBR_TI_MESPROVAVELDEENTREGA: TDBComboBox;
        SpeedButton_OBR_SCH_First: TSpeedButton;
        BitBtn_OBR_Relatorio: TBitBtn;
        BitBtn_OBR_SCH_MaisDetalhes: TBitBtn;
        BitBtn_OBR_FILTRO_RedefinirFiltro: TBitBtn;
        BitBtn_OBR_ImprimirPropostaPadrao: TBitBtn;
        BitBtn_PRO_FILTRO_ReinicializarFiltro: TBitBtn;
        BitBtn_PRO_SCH_MaisDetalhes: TBitBtn;
        BitBtn_PRO_VisualizarImpressao: TBitBtn;
        BitBtn_PRO_Relatorio: TBitBtn;
    BitBtn_EQP_SCH_Reset: TBitBtn;
    BitBtn_EQP_SCH_Details: TBitBtn;
    BitBtn_EDI_Relatorio: TBitBtn;
        BitBtn_PRO_Imprimir: TBitBtn;
    BitBtn_ITE_Replicar: TBitBtn;
        Image_Expandir1: TImage;
        Image_Expandir2: TImage;
        Image_Expandir3: TImage;
        Image_Expandir: TImage;
        Image_Contrair: TImage;
    BitBtn_EDI_DesmarcarTodos: TBitBtn;
        procedure Label_OBR_TI_REGIOES_IDClick(Sender: TObject);
        procedure Label_OBR_TI_SITUACOES_IDClick(Sender: TObject);
        procedure Label_OBR_TI_TIPOS_IDClick(Sender: TObject);
        procedure Label_OBR_SM_PROJETISTAS_IDClick(Sender: TObject);
        procedure Label_OBR_FL_ICMSClick(Sender: TObject);
        procedure Label_OBR_TX_CONDICOESGERAISClick(Sender: TObject);
        procedure Action_OBR_CancelExecute(Sender: TObject);
        procedure Action_OBR_PostExecute(Sender: TObject);
        procedure Action_OBR_RefreshExecute(Sender: TObject);
        procedure DoResizeTabSheet(Sender: TObject);
        procedure DoShowTabSheet(Sender: TObject);
        procedure DBRichEdit_OBR_TX_CONDICAODEPAGAMENTOChange(Sender: TObject);
        procedure DBRichEdit_OBR_TX_CONDICOESGERAISChange(Sender: TObject);
        procedure DBMemo_OBR_TX_OBSERVACOESChange(Sender: TObject);
        procedure DBText_OBR_IN_OBRAS_IDClick(Sender: TObject);
        procedure FormCreate(Sender: TObject);
        procedure DoChangingPageControl(Sender: TObject; var AllowChange: Boolean);
        procedure Label_OBR_TI_REGIOES_ID_FiltrarClick(Sender: TObject);
        procedure Label_OBR_TI_TIPOS_ID_FiltrarClick(Sender: TObject);
        procedure Label_OBR_TI_SITUACOES_ID_FiltrarClick(Sender: TObject);
        procedure Label_OBR_SM_PROJETISTAS_ID_FiltrarClick(Sender: TObject);
        procedure Label_PRO_FILTRO_SM_INSTALADORES_IDClick(Sender: TObject);
        procedure Label_ITE_TI_FAMILIAS_IDClick(Sender: TObject);
        procedure Action_ITE_PostExecute(Sender: TObject);
        procedure Label_ITE_CapacidadeTermicaClick(Sender: TObject);
        procedure Action_OBR_SCH_FirstExecute(Sender: TObject);
        procedure Action_OBR_SCH_PreviousExecute(Sender: TObject);
        procedure Action_OBR_SCH_NextExecute(Sender: TObject);
        procedure Action_OBR_SCH_LastExecute(Sender: TObject);
        procedure Action_OBR_SCH_RefreshExecute(Sender: TObject);
        procedure Action_OBR_SCH_FirstPageExecute(Sender: TObject);
        procedure Action_OBR_SCH_PreviousPageExecute(Sender: TObject);
        procedure Action_OBR_SCH_NextPageExecute(Sender: TObject);
        procedure Action_OBR_SCH_LastPageExecute(Sender: TObject);
        procedure Action_OBR_SCH_ResetExecute(Sender: TObject);
        procedure CFDBGrid_OBR_SCHTitleClick(Column: TColumn);
        procedure ApenasNumeros(Sender: TObject; var Key: Char);
        procedure DoOBR_SCHClick(Sender: TObject);
        procedure DoOBR_SCHKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
        procedure DoOBR_SCHChange(Sender: TObject);
        procedure Action_OBR_SCH_DetailsExecute(Sender: TObject);
        procedure Action_PRO_SCH_DetailsExecute(Sender: TObject);
        procedure Action_PRO_SCH_FirstExecute(Sender: TObject);
        procedure Action_PRO_SCH_PreviousExecute(Sender: TObject);
        procedure Action_PRO_SCH_NextExecute(Sender: TObject);
        procedure Action_PRO_SCH_LastExecute(Sender: TObject);
        procedure Action_PRO_SCH_RefreshExecute(Sender: TObject);
        procedure Action_PRO_SCH_FirstPageExecute(Sender: TObject);
        procedure Action_PRO_SCH_PreviousPageExecute(Sender: TObject);
        procedure Action_PRO_SCH_NextPageExecute(Sender: TObject);
        procedure Action_PRO_SCH_LastPageExecute(Sender: TObject);
        procedure Action_PRO_SCH_ResetExecute(Sender: TObject);
        procedure CFDBGrid_PRO_SCHTitleClick(Column: TColumn);
        procedure DoPRO_SCHKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
        procedure DoPRO_SCHClick(Sender: TObject);
        procedure DoPRO_SCHChange(Sender: TObject);
        procedure ComboBox_OBR_PRO_SCH_TI_SITUACOES_IDChange(Sender: TObject);
        procedure CFDBGrid_OBR_PRO_SCHDblClick(Sender: TObject);
        procedure DBComboBox_PRO_TI_MOEDAChange(Sender: TObject);
        procedure DoKeyPress_PRO(Sender: TObject; var Key: Char);
        procedure DoDrawColumnCell(Sender: TObject; const Rect: TRect; DataCol: Integer; Column: TColumn; State: TGridDrawState);
        procedure Label_OBR_INSTALADORClick(Sender: TObject);
        procedure Action_PRO_PostExecute(Sender: TObject);
        procedure Action_PRO_CancelExecute(Sender: TObject);
        procedure Action_PRO_RefreshExecute(Sender: TObject);
        procedure Action_PRO_FirstExecute(Sender: TObject);
        procedure Action_PRO_PreviousExecute(Sender: TObject);
        procedure Action_PRO_NextExecute(Sender: TObject);
        procedure Action_PRO_LastExecute(Sender: TObject);
        procedure CFDBGrid_PRO_PadraoCellClick(Column: TColumn);
        procedure DBText_PRO_IN_PROPOSTAS_IDClick(Sender: TObject);
        procedure DBText_ITE_IN_ITENS_IDClick(Sender: TObject);
        procedure Action_ITE_CancelExecute(Sender: TObject);
        procedure Action_ITE_RefreshExecute(Sender: TObject);
        procedure Action_ITE_FirstExecute(Sender: TObject);
        procedure Action_ITE_PreviousExecute(Sender: TObject);
        procedure Action_ITE_NextExecute(Sender: TObject);
        procedure Action_ITE_LastExecute(Sender: TObject);
        procedure Edit_EQP_VA_MODELOChange(Sender: TObject);
        procedure Edit_EQP_VA_MODELOEnter(Sender: TObject);
        procedure Action_EDI_DesmarcarTodosExecute(Sender: TObject);
        procedure CFDBGrid_EDIDblClick(Sender: TObject);
        procedure CFDBGrid_EQPDblClick(Sender: TObject);
        procedure Label_OBR_JustificativaSalvaClick(Sender: TObject);
        procedure FormShow(Sender: TObject);
        procedure DoEQP_SCHKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
        procedure DoEQP_SCHChange(Sender: TObject);
        procedure DoEQP_SCHClick(Sender: TObject);
        procedure Label_EQP_SCH_INSTALADORClick(Sender: TObject);
        procedure CFDBGrid_EQP_SCHTitleClick(Column: TColumn);
        procedure Action_EQP_SCH_DetailsExecute(Sender: TObject);
        procedure Action_EQP_SCH_FirstExecute(Sender: TObject);
        procedure Action_EQP_SCH_PreviousExecute(Sender: TObject);
        procedure Action_EQP_SCH_NextExecute(Sender: TObject);
        procedure Action_EQP_SCH_LastExecute(Sender: TObject);
        procedure Action_EQP_SCH_RefreshExecute(Sender: TObject);
        procedure Action_EQP_SCH_FirstPageExecute(Sender: TObject);
        procedure Action_EQP_SCH_PreviousPageExecute(Sender: TObject);
        procedure Action_EQP_SCH_NextPageExecute(Sender: TObject);
        procedure Action_EQP_SCH_LastPageExecute(Sender: TObject);
        procedure Action_EQP_SCH_ResetExecute(Sender: TObject);
        procedure DBEdit_OBR_VA_NOMEDAOBRAChange(Sender: TObject);
        procedure Action_OBR_ObrasSemelhantesExecute(Sender: TObject);
        procedure Label_OBR_TX_CONDICAODEPAGAMENTOClick(Sender: TObject);
        procedure Image_Expandir1Click(Sender: TObject);
        procedure Image_Expandir2Click(Sender: TObject);
        procedure Image_Expandir3Click(Sender: TObject);
        procedure CFDBGrid_EDIAfterMultiselect(aSender: TObject; aMultiSelectEventTrigger: TMultiSelectEventTrigger);
        procedure CFDBGrid_EQPAfterMultiselect(aSender: TObject; aMultiSelectEventTrigger: TMultiSelectEventTrigger);
    private
        { Private declarations }
        procedure DoTimer(var Msg: TMessage);
        procedure AjustarCamposDeTexto;
        procedure InicializarRegioes;
        procedure InicializarTipos;
        procedure InicializarSituacoes;
        procedure InicializarProjetistas;
        procedure InicializarInstaladores(const aComboBox: TComboBox);
        procedure InicializarMoedas;
        procedure InicializarAnosDeConclusao;
        procedure OBR_SCH_Reset(aFiltrar: Boolean);
        procedure PRO_SCH_Reset(aFiltrar: Boolean);
        procedure EQP_SCH_Reset(aFiltrar: Boolean);
        function OBR_SCH_Filter: TOBRFilter;
        function PRO_SCH_Filter: TPROFilter;
        function EQP_SCH_Filter: TEQPFilter;
        function OBR_SCH_SortField: String;
        function PRO_SCH_SortField: String;
        function EQP_SCH_SortField: String;
        procedure OBR_SCH_ApplyFilter(const aGotoFirstPage: Boolean = True);
        procedure PRO_SCH_ApplyFilter(const aGotoFirstPage: Boolean = True);
        procedure EQP_SCH_ApplyFilter(const aGotoFirstPage: Boolean = True);

        procedure LocalizarObrasSemelhantes;
        procedure ExpandirAreaDeTexto(const aArea: Byte);
        procedure AjustarAreasDeTexto;
//        procedure RessetarFormatacaoDeFonte(const aRichEditControl: TRichEdit);
    public
        { Public declarations }
    end;

implementation

uses
    UBDODataModule_Obras, UXXXTypesConstantsAndClasses, DB, DateUtils, Windows, RichEdit;

resourcestring
    RS_OBRASEMPROPOSTAS = 'Não é possível acessar a página de ítens e equipam' +
    'entos pois a obra atual não possui propostas. Cadastre ao menos uma prop' +
    'osta para só assim poder definir seus itens';

const
    IDT_AJUSTAR = 2; 

{$R *.dfm}

procedure TBDOForm_Obras.Label_OBR_TI_SITUACOES_IDClick(Sender: TObject);
begin
    inherited;
    TBDODataModule_Obras(MyDataModule).SITUACOES_LOOKUP.Refresh;
end;

procedure TBDOForm_Obras.Label_OBR_TI_SITUACOES_ID_FiltrarClick(Sender: TObject);
begin
    inherited;
    if MessageBox(Handle,'Isso vai atualizar esta lista, mas vai remover o filtro para este campo. Tem certeza?','Tem certeza?',MB_ICONQUESTION or MB_YESNO) = idYes then
    begin
        InicializarSituacoes;
        OBR_SCH_ApplyFilter;
    end;
end;

procedure TBDOForm_Obras.Label_OBR_TI_TIPOS_IDClick(Sender: TObject);
begin
    inherited;
    TBDODataModule_Obras(MyDataModule).TIPOS_LOOKUP.Refresh;
end;

procedure TBDOForm_Obras.Label_OBR_TI_TIPOS_ID_FiltrarClick(Sender: TObject);
begin
    inherited;
    if MessageBox(Handle,'Isso vai atualizar esta lista, mas vai remover o filtro para este campo. Tem certeza?','Tem certeza?',MB_ICONQUESTION or MB_YESNO) = idYes then
    begin
        InicializarTipos;
        OBR_SCH_ApplyFilter;
    end;
end;

procedure TBDOForm_Obras.Label_PRO_FILTRO_SM_INSTALADORES_IDClick(Sender: TObject);
begin
    inherited;
    if MessageBox(Handle,'Isso vai atualizar esta lista, mas vai remover o filtro para este campo. Tem certeza?','Tem certeza?',MB_ICONQUESTION or MB_YESNO) = idYes then
    begin
        InicializarInstaladores(ComboBox_PRO_SCH_SM_INSTALADORES_ID);
        PRO_SCH_ApplyFilter;
    end;
end;

procedure TBDOForm_Obras.LocalizarObrasSemelhantes;
begin
    if TBDODataModule_Obras(MyDataModule).OBRAS.State = dsInsert then
    begin
        if TBDODataModule_Obras(MyDataModule).ObrasSemelhantes(DBEdit_OBR_VA_NOMEDAOBRA.Text) > 0 then
            Action_OBR_ObrasSemelhantes.ImageIndex := 27
        else
            Action_OBR_ObrasSemelhantes.ImageIndex := 26;
    end;
end;

function TBDOForm_Obras.OBR_SCH_SortField: String;
begin
    Result := 'IN_OBRAS_ID ASC';

    if CFDBGrid_OBR_SCH.SortArrow.Direction <> sadNone then
    begin
        Result := CFDBGrid_OBR_SCH.SortArrow.Column;
        case CFDBGrid_OBR_SCH.SortArrow.Direction of
            sadDescending: Result := Result + ' ASC';
            sadAscending: Result := Result + ' DESC';
        end;
    end;
end;

function TBDOForm_Obras.PRO_SCH_SortField: String;
begin
    Result := 'IN_PROPOSTAS_ID ASC';
    if CFDBGrid_PRO_SCH.SortArrow.Direction <> sadNone then
    begin
        Result := CFDBGrid_PRO_SCH.SortArrow.Column;
        case CFDBGrid_PRO_SCH.SortArrow.Direction of
            sadDescending: Result := Result + ' ASC';
            sadAscending: Result := Result + ' DESC';
        end;
    end;
end;

procedure TBDOForm_Obras.OBR_SCH_ApplyFilter(const aGotoFirstPage: Boolean = True);
var
    OBRFilter: TOBRFilter;
begin
    if csDestroying in ComponentState then
        Exit;

    { Obtém o filtro }
    OBRFilter := OBR_SCH_Filter;
    { Atualiza as métricas de acordo com o filtro e com o CFDBGrid }
    TBDODataModule_Obras(MyDataModule).OBR_SCH_UpdateMetrics(CFDBGrid_OBR_SCH,OBRFilter);
    { Aplica o filtro e coloca o conjunto de dados na página especificada }
    if aGotoFirstPage then
        TBDODataModule_Obras(MyDataModule).OBR_SCH_GotoPage(dpbFirst,OBRFilter,OBR_SCH_SortField)
    else
        TBDODataModule_Obras(MyDataModule).OBR_SCH_GotoPage(dpbCustom,OBRFilter,OBR_SCH_SortField,TBDODataModule_Obras(MyDataModule).OBR_SCH_CurrentPage)
end;

procedure TBDOForm_Obras.PRO_SCH_ApplyFilter(const aGotoFirstPage: Boolean = True);
var
    PROFilter: TPROFilter;
begin
    if csDestroying in ComponentState then
        Exit;

    { Obtém o filtro }
    PROFilter := PRO_SCH_Filter;
    { Atualiza as métricas de acordo com o filtro e com o CFDBGrid }
    TBDODataModule_Obras(MyDataModule).PRO_SCH_UpdateMetrics(CFDBGrid_PRO_SCH,PROFilter);
    { Aplica o filtro e coloca o conjunto de dados na página especificada }
    if aGotoFirstPage then
        TBDODataModule_Obras(MyDataModule).PRO_SCH_GotoPage(dpbFirst,PROFilter,PRO_SCH_SortField)
    else
        TBDODataModule_Obras(MyDataModule).PRO_SCH_GotoPage(dpbCustom,PROFilter,PRO_SCH_SortField,TBDODataModule_Obras(MyDataModule).PRO_SCH_CurrentPage)        
end;

function TBDOForm_Obras.OBR_SCH_Filter: TOBRFilter;
begin
	ZeroMemory(@Result,SizeOf(TOBRFilter));

	with Result do
    begin
		VA_NOMEDAOBRA := Edit_OBRAS_SEARCH_VA_NOMEDAOBRA.Text;
        VA_CIDADE := Edit_OBRAS_SEARCH_VA_CIDADE.Text;
        CH_ESTADO := ComboBox_OBRAS_SEARCH_CH_ESTADO.Text;
        VA_CONSTRUTORA := Edit_OBRAS_SEARCH_VA_CONSTRUTORA.Text;
                                                                  
        if RadioButton_OBRAS_SEARCH_ComPropostas.Checked then
        	ComPropostas := 'S'
        else if RadioButton_OBRAS_SEARCH_SemPropostas.Checked then
        	ComPropostas := 'N';

        TI_REGIOES_ID := Integer(ComboBox_OBRAS_SEARCH_TI_REGIOES_ID.Items.Objects[ComboBox_OBRAS_SEARCH_TI_REGIOES_ID.ItemIndex]);
        TI_TIPOS_ID := Integer(ComboBox_OBRAS_SEARCH_TI_TIPOS_ID.Items.Objects[ComboBox_OBRAS_SEARCH_TI_TIPOS_ID.ItemIndex]);
        TI_SITUACOES_ID := Integer(ComboBox_OBRAS_SEARCH_TI_SITUACOES_ID.Items.Objects[ComboBox_OBRAS_SEARCH_TI_SITUACOES_ID.ItemIndex]);

        if CheckBox_OBR_SCH_DA_DATADEENTRADA1.Checked then
			DA_DATADEENTRADA_I := DateTimePicker_OBR_SCH_DA_DATADEENTRADA1.Date;
        if CheckBox_OBR_SCH_DA_DATADEENTRADA2.Checked then
        	DA_DATADEENTRADA_F := DateTimePicker_OBR_SCH_DA_DATADEENTRADA2.Date;

        SM_PROJETISTAS_ID := Integer(ComboBox_OBRAS_SEARCH_SM_PROJETISTAS_ID.Items.Objects[ComboBox_OBRAS_SEARCH_SM_PROJETISTAS_ID.ItemIndex]);
    end;
    TBDODataModule_Obras(MyDataModule).OBR_SCH_UpdateMetrics(CFDBGrid_OBR_SCH,Result);
end;

function TBDOForm_Obras.PRO_SCH_Filter: TPROFilter;
begin
	ZeroMemory(@Result,SizeOf(TPROFilter));
	with Result do
    begin
        VA_CONTATO := Edit_PRO_SCH_VA_CONTATO.Text;
		VA_NOMEDAOBRA := Edit_PRO_SCH_VA_NOMEDAOBRA.Text;
        SM_CODIGO := StrToIntDef(CFEdit_PRO_SCH_SM_CODIGO.Text,0);
        YR_ANO := StrToIntDef(CFEdit_PRO_SCH_YR_ANO.Text,0);
        BO_PROPOSTAPADRAO := RadioGroup_PRO_SCH_BO_PROPOSTAPADRAO.ItemIndex;
        SM_INSTALADORES_ID := Integer(ComboBox_PRO_SCH_SM_INSTALADORES_ID.Items.Objects[ComboBox_PRO_SCH_SM_INSTALADORES_ID.ItemIndex]); 
    end;
    TBDODataModule_Obras(MyDataModule).PRO_SCH_UpdateMetrics(CFDBGrid_PRO_SCH,Result);
end;

procedure TBDOForm_Obras.OBR_SCH_Reset(aFiltrar: Boolean);
begin
    try
        Edit_OBRAS_SEARCH_VA_NOMEDAOBRA.Text := '';
        Edit_OBRAS_SEARCH_VA_CIDADE.Text := '';
        ComboBox_OBRAS_SEARCH_CH_ESTADO.ItemIndex := 0;
        ComboBox_OBRAS_SEARCH_TI_REGIOES_ID.ItemIndex := 0;
        CheckBox_OBR_SCH_DA_DATADEENTRADA1.Checked := False;
  	    DateTimePicker_OBR_SCH_DA_DATADEENTRADA1.Date := StrToDate('01/01/' + IntToStr(YearOf(Now)));
        CheckBox_OBR_SCH_DA_DATADEENTRADA2.Checked := False;
  	    DateTimePicker_OBR_SCH_DA_DATADEENTRADA2.Date := Now;
		ComboBox_OBRAS_SEARCH_TI_TIPOS_ID.ItemIndex := 0;
        ComboBox_OBRAS_SEARCH_TI_SITUACOES_ID.ItemIndex := 0;
        Edit_OBRAS_SEARCH_VA_CONSTRUTORA.Text := '';
        ComboBox_OBRAS_SEARCH_SM_PROJETISTAS_ID.ItemIndex := 0;
        RadioButton_OBRAS_SEARCH_ComESemPropostas.Checked := True;
    finally
	    CFDBGrid_OBR_SCH.SortArrow.Direction := sadNone;
        if aFiltrar then
            with TBDODataModule_Obras(MyDataModule) do
                OBR_SCH_GotoPage(dpbFirst,OBR_SCH_Filter,OBR_SCH_SortField);
    end;
end;

procedure TBDOForm_Obras.PRO_SCH_Reset(aFiltrar: Boolean);
begin
    try
        Edit_PRO_SCH_VA_CONTATO.Text := '';
        Edit_PRO_SCH_VA_NOMEDAOBRA.Text := '';
        CFEdit_PRO_SCH_SM_CODIGO.Text := '';
        CFEdit_PRO_SCH_YR_ANO.Text := '';
        RadioGroup_PRO_SCH_BO_PROPOSTAPADRAO.ItemIndex := 2;
  	    ComboBox_PRO_SCH_SM_INSTALADORES_ID.ItemIndex := 0;
    finally
	    CFDBGrid_PRO_SCH.SortArrow.Direction := sadNone;
        if aFiltrar then
            with TBDODataModule_Obras(MyDataModule) do
                PRO_SCH_GotoPage(dpbFirst,PRO_SCH_Filter,PRO_SCH_SortField);
    end;
end;

procedure TBDOForm_Obras.Action_OBR_SCH_ResetExecute(Sender: TObject);
begin
    inherited;
    OBR_SCH_Reset(True);
end;

procedure TBDOForm_Obras.Action_PRO_CancelExecute(Sender: TObject);
begin
    inherited;
    TBDODataModule_Obras(MyDataModule).DBButtonClick_PRO(dbbCancel,nil);
end;

procedure TBDOForm_Obras.Action_PRO_FirstExecute(Sender: TObject);
begin
    inherited;
    TBDODataModule_Obras(MyDataModule).DBButtonClick_PRO(dbbFirst,nil);
end;

procedure TBDOForm_Obras.Action_PRO_LastExecute(Sender: TObject);
begin
    inherited;
    TBDODataModule_Obras(MyDataModule).DBButtonClick_PRO(dbbLast,nil);
end;

procedure TBDOForm_Obras.Action_PRO_NextExecute(Sender: TObject);
begin
    inherited;
    TBDODataModule_Obras(MyDataModule).DBButtonClick_PRO(dbbNext,nil);
end;

procedure TBDOForm_Obras.Action_PRO_PostExecute(Sender: TObject);
begin
    inherited;
    TBDODataModule_Obras(MyDataModule).DBButtonClick_PRO(dbbPost,nil);
end;

procedure TBDOForm_Obras.Action_PRO_PreviousExecute(Sender: TObject);
begin
    inherited;
    TBDODataModule_Obras(MyDataModule).DBButtonClick_PRO(dbbPrevious,nil);
end;

procedure TBDOForm_Obras.Action_PRO_RefreshExecute(Sender: TObject);
begin
    inherited;
    { É necessário usar bookmarks aqui por que toda vez que os valores
    calculados mudam, o cursor é colocado no início! }
    TBDODataModule_Obras(MyDataModule).DBButtonClick_PRO(dbbRefresh,nil,True);
end;

//procedure TBDOForm_Obras.RessetarFormatacaoDeFonte(const aRichEditControl: TRichEdit);
//begin
//    aRichEditControl.DefAttributes.Name := aRichEditControl.Font.Name;
//    aRichEditControl.DefAttributes.Size := aRichEditControl.Font.Size;
//    aRichEditControl.DefAttributes.Color := aRichEditControl.Font.Color;
//    aRichEditControl.DefAttributes.Charset := aRichEditControl.Font.Charset;
//    aRichEditControl.DefAttributes.Pitch := aRichEditControl.Font.Pitch;
//    aRichEditControl.DefAttributes.Style := aRichEditControl.Font.Style;
//    aRichEditControl.DefAttributes.Height := aRichEditControl.Font.Height;
//end;

procedure TBDOForm_Obras.Label_OBR_TX_CONDICAODEPAGAMENTOClick(Sender: TObject);
var
    Texto: String;
begin
    inherited;
    Texto := MyDataModule.ShowTextsManager(Configurations.CurrentDir + '\OBR_TX_CONDICAODEPAGAMENTO.fot');

    if Trim(Texto) <> '' then
    begin
        if TBDODataModule_Obras(MyDataModule).OBRAS.State = dsBrowse then
            TBDODataModule_Obras(MyDataModule).OBRAS.Edit;

        TBDODataModule_Obras(MyDataModule).OBRASTX_CONDICAODEPAGAMENTO.AsString := Texto;
    end;
end;

procedure TBDOForm_Obras.Label_OBR_TX_CONDICOESGERAISClick(Sender: TObject);
var
    Texto: String;
begin
    inherited;
    Texto := MyDataModule.ShowTextsManager(Configurations.CurrentDir + '\OBR_TX_CONDICOESGERAIS.fot');

    if Trim(Texto) <> '' then
    begin
        if TBDODataModule_Obras(MyDataModule).OBRAS.State = dsBrowse then
            TBDODataModule_Obras(MyDataModule).OBRAS.Edit;

        TBDODataModule_Obras(MyDataModule).OBRASTX_CONDICOESGERAIS.AsString := Texto;
    end;
end;

procedure TBDOForm_Obras.Action_PRO_SCH_DetailsExecute(Sender: TObject);
begin
    inherited;
    TBDODataModule_Obras(MyDataModule).PRO_SCH_SelecionarObra;
    TabSheet_OBR_PRO.Show;
end;

procedure TBDOForm_Obras.Action_PRO_SCH_FirstExecute(Sender: TObject);
begin
    inherited;
    TBDODataModule_Obras(MyDataModule).DBButtonClick_PRO_SCH(dbbFirst);
end;

procedure TBDOForm_Obras.Action_PRO_SCH_FirstPageExecute(Sender: TObject);
begin
    inherited;
    TBDODataModule_Obras(MyDataModule).PRO_SCH_GotoPage(dpbFirst,PRO_SCH_Filter,PRO_SCH_SortField);
end;

procedure TBDOForm_Obras.Action_PRO_SCH_LastExecute(Sender: TObject);
begin
    inherited;
    TBDODataModule_Obras(MyDataModule).DBButtonClick_PRO_SCH(dbbLast);
end;

procedure TBDOForm_Obras.Action_PRO_SCH_LastPageExecute(Sender: TObject);
begin
    inherited;
    TBDODataModule_Obras(MyDataModule).PRO_SCH_GotoPage(dpbLast,PRO_SCH_Filter,PRO_SCH_SortField);
end;

procedure TBDOForm_Obras.Action_PRO_SCH_NextExecute(Sender: TObject);
begin
    inherited;
    TBDODataModule_Obras(MyDataModule).DBButtonClick_PRO_SCH(dbbNext);
end;

procedure TBDOForm_Obras.Action_PRO_SCH_NextPageExecute(Sender: TObject);
begin
    inherited;
    TBDODataModule_Obras(MyDataModule).PRO_SCH_GotoPage(dpbNext,PRO_SCH_Filter,PRO_SCH_SortField);
end;

procedure TBDOForm_Obras.Action_PRO_SCH_PreviousExecute(Sender: TObject);
begin
    inherited;
    TBDODataModule_Obras(MyDataModule).DBButtonClick_PRO_SCH(dbbPrevious);
end;

procedure TBDOForm_Obras.Action_PRO_SCH_PreviousPageExecute(Sender: TObject);
begin
    inherited;
    TBDODataModule_Obras(MyDataModule).PRO_SCH_GotoPage(dpbPrevious,PRO_SCH_Filter,PRO_SCH_SortField);
end;

procedure TBDOForm_Obras.Action_PRO_SCH_RefreshExecute(Sender: TObject);
begin
    inherited;
    //TBDODataModule_Obras(MyDataModule).DBButtonClick_PRO_SCH(dbbRefresh);
    PRO_SCH_ApplyFilter(False);
end;

procedure TBDOForm_Obras.Action_PRO_SCH_ResetExecute(Sender: TObject);
begin
    inherited;
    PRO_SCH_Reset(True);
end;

procedure TBDOForm_Obras.Action_EDI_DesmarcarTodosExecute(Sender: TObject);
begin
  	inherited;
    with TBDODataModule_Obras(MyDataModule) do
    begin
        EQUIPAMENTOS_LOOKUP.DisableControls;
        try
            EQUIPAMENTOS_LOOKUP.First;
            while not EQUIPAMENTOS_LOOKUP.Eof do
            begin
                CFDBGrid_EQP.SelectedRows.CurrentRowSelected := False;
                EQUIPAMENTOS_LOOKUP.Next;
            end;
        finally
            EQUIPAMENTOS_LOOKUP.EnableControls;
        end;
    end;
end;

procedure TBDOForm_Obras.Action_EQP_SCH_DetailsExecute(Sender: TObject);
begin
    inherited;
    TBDODataModule_Obras(MyDataModule).EQP_SCH_SelecionarObra;
    TabSheet_ITE_EDI.Show;
end;

procedure TBDOForm_Obras.Action_EQP_SCH_FirstExecute(Sender: TObject);
begin
    inherited;
    TBDODataModule_Obras(MyDataModule).DBButtonClick_EQP_SCH(dbbFirst);
end;

procedure TBDOForm_Obras.Action_EQP_SCH_FirstPageExecute(Sender: TObject);
begin
    inherited;
    TBDODataModule_Obras(MyDataModule).EQP_SCH_GotoPage(dpbFirst,EQP_SCH_Filter,EQP_SCH_SortField);
end;

procedure TBDOForm_Obras.Action_EQP_SCH_LastExecute(Sender: TObject);
begin
    inherited;
    TBDODataModule_Obras(MyDataModule).DBButtonClick_EQP_SCH(dbbLast);
end;

procedure TBDOForm_Obras.Action_EQP_SCH_LastPageExecute(Sender: TObject);
begin
    inherited;
    TBDODataModule_Obras(MyDataModule).EQP_SCH_GotoPage(dpbLast,EQP_SCH_Filter,EQP_SCH_SortField);
end;

procedure TBDOForm_Obras.Action_EQP_SCH_NextExecute(Sender: TObject);
begin
    inherited;
    TBDODataModule_Obras(MyDataModule).DBButtonClick_EQP_SCH(dbbNext);
end;

procedure TBDOForm_Obras.Action_EQP_SCH_NextPageExecute(Sender: TObject);
begin
    inherited;
    TBDODataModule_Obras(MyDataModule).EQP_SCH_GotoPage(dpbNext,EQP_SCH_Filter,EQP_SCH_SortField);
end;

procedure TBDOForm_Obras.Action_EQP_SCH_PreviousExecute(Sender: TObject);
begin
    inherited;
    TBDODataModule_Obras(MyDataModule).DBButtonClick_EQP_SCH(dbbPrevious);
end;

procedure TBDOForm_Obras.Action_EQP_SCH_PreviousPageExecute(Sender: TObject);
begin
    inherited;
    TBDODataModule_Obras(MyDataModule).EQP_SCH_GotoPage(dpbPrevious,EQP_SCH_Filter,EQP_SCH_SortField);
end;

procedure TBDOForm_Obras.Action_EQP_SCH_RefreshExecute(Sender: TObject);
begin
    inherited;
    EQP_SCH_ApplyFilter(False);
end;

procedure TBDOForm_Obras.Action_EQP_SCH_ResetExecute(Sender: TObject);
begin
    inherited;
    EQP_SCH_Reset(True);
end;

procedure TBDOForm_Obras.Action_ITE_CancelExecute(Sender: TObject);
begin
    inherited;
    TBDODataModule_Obras(MyDataModule).DBButtonClick_ITE(dbbCancel,nil);
end;

procedure TBDOForm_Obras.Action_ITE_FirstExecute(Sender: TObject);
begin
    inherited;
    TBDODataModule_Obras(MyDataModule).DBButtonClick_ITE(dbbFirst,nil);
end;

procedure TBDOForm_Obras.Action_ITE_LastExecute(Sender: TObject);
begin
    inherited;
    TBDODataModule_Obras(MyDataModule).DBButtonClick_ITE(dbbLast,nil);
end;

procedure TBDOForm_Obras.Action_ITE_NextExecute(Sender: TObject);
begin
    inherited;
    TBDODataModule_Obras(MyDataModule).DBButtonClick_ITE(dbbNext,nil);
end;

procedure TBDOForm_Obras.Action_ITE_PostExecute(Sender: TObject);
begin
    inherited;
    TBDODataModule_Obras(MyDataModule).DBButtonClick_ITE(dbbPost,nil);
end;

procedure TBDOForm_Obras.Action_ITE_PreviousExecute(Sender: TObject);
begin
    inherited;
    TBDODataModule_Obras(MyDataModule).DBButtonClick_ITE(dbbPrevious,nil);
end;

procedure TBDOForm_Obras.Action_ITE_RefreshExecute(Sender: TObject);
begin
    inherited;
    TBDODataModule_Obras(MyDataModule).DBButtonClick_ITE(dbbRefresh,nil);
end;

procedure TBDOForm_Obras.Action_OBR_CancelExecute(Sender: TObject);
begin
    inherited;
    TBDODataModule_Obras(MyDataModule).DBButtonClick_OBR(dbbCancel,nil);
end;

procedure TBDOForm_Obras.Action_OBR_ObrasSemelhantesExecute(Sender: TObject);
begin
    inherited;
    if TBDODataModule_Obras(MyDataModule).OBRAS.State = dsInsert then
    begin
        if TBDODataModule_Obras(MyDataModule).ObrasSemelhantes(DBEdit_OBR_VA_NOMEDAOBRA.Text) > 0 then
            TBDODataModule_Obras(MyDataModule).ExibirObrasSemelhantes(DBEdit_OBR_VA_NOMEDAOBRA.Text)
        else
            MessageBox(Handle,'Nenhuma obra com nome semelhante ao atual foi encontrada','Nenhuma obra semelhante encontrada!',MB_ICONINFORMATION);
    end
    else
        MessageBox(Handle,'Quando há uma inserção em andamento, clicar neste botão exibe todas as obras cujos nomes são semelhantes àquele atualmente digitado','Nenhuma inserção em andamento',MB_ICONINFORMATION);
end;

procedure TBDOForm_Obras.Action_OBR_PostExecute(Sender: TObject);
begin
    inherited;
    TBDODataModule_Obras(MyDataModule).DBButtonClick_OBR(dbbPost,nil);
end;

procedure TBDOForm_Obras.Action_OBR_RefreshExecute(Sender: TObject);
begin
    inherited;
    TBDODataModule_Obras(MyDataModule).DBButtonClick_OBR(dbbRefresh,nil);
end;

procedure TBDOForm_Obras.Action_OBR_SCH_DetailsExecute(Sender: TObject);
begin
    inherited;
    TBDODataModule_Obras(MyDataModule).OBR_SCH_SelecionarObra;
    TabSheet_OBR_PRO.Show;
end;

procedure TBDOForm_Obras.Action_OBR_SCH_FirstExecute(Sender: TObject);
begin
    inherited;
    TBDODataModule_Obras(MyDataModule).DBButtonClick_OBR_SCH(dbbFirst);
end;

procedure TBDOForm_Obras.Action_OBR_SCH_FirstPageExecute(Sender: TObject);
begin
    inherited;
    TBDODataModule_Obras(MyDataModule).OBR_SCH_GotoPage(dpbFirst,OBR_SCH_Filter,OBR_SCH_SortField);
end;

procedure TBDOForm_Obras.Action_OBR_SCH_PreviousPageExecute(Sender: TObject);
begin
    inherited;
    TBDODataModule_Obras(MyDataModule).OBR_SCH_GotoPage(dpbPrevious,OBR_SCH_Filter,OBR_SCH_SortField);
end;

procedure TBDOForm_Obras.Action_OBR_SCH_NextPageExecute(Sender: TObject);
begin
    inherited;
    TBDODataModule_Obras(MyDataModule).OBR_SCH_GotoPage(dpbNext,OBR_SCH_Filter,OBR_SCH_SortField);
end;

procedure TBDOForm_Obras.Action_OBR_SCH_LastPageExecute(Sender: TObject);
begin
    inherited;
    TBDODataModule_Obras(MyDataModule).OBR_SCH_GotoPage(dpbLast,OBR_SCH_Filter,OBR_SCH_SortField);
end;

procedure TBDOForm_Obras.Action_OBR_SCH_LastExecute(Sender: TObject);
begin
    inherited;
    TBDODataModule_Obras(MyDataModule).DBButtonClick_OBR_SCH(dbbLast);
end;

procedure TBDOForm_Obras.Action_OBR_SCH_NextExecute(Sender: TObject);
begin
    inherited;
    TBDODataModule_Obras(MyDataModule).DBButtonClick_OBR_SCH(dbbNext);
end;

procedure TBDOForm_Obras.Action_OBR_SCH_PreviousExecute(Sender: TObject);
begin
    inherited;
    TBDODataModule_Obras(MyDataModule).DBButtonClick_OBR_SCH(dbbPrevious);
end;

procedure TBDOForm_Obras.Action_OBR_SCH_RefreshExecute(Sender: TObject);
begin
    inherited;
    { Usar refresh aqui não adianta pois as colunas calculadas nunca mudam! }
//    TBDODataModule_Obras(MyDataModule).DBButtonClick_OBR_SCH(dbbRefresh);
    OBR_SCH_ApplyFilter(False);
end;

procedure TBDOForm_Obras.DBComboBox_PRO_TI_MOEDAChange(Sender: TObject);
begin
    inherited;
    MessageBox(Handle,'A moeda de exibição foi alterada. Ajustes na tabela de cotações podem ser necessários.','Moeda de exibição alterada...',MB_ICONWARNING);
end;

procedure TBDOForm_Obras.DBEdit_OBR_VA_NOMEDAOBRAChange(Sender: TObject);
begin
    inherited;
    { TODO -oCarlos Feitoza -cEXPLICAÇÃO : O evento Change é sempre executado
    quando o form se fecha. Acredito que seja por que o datamodule é destruido
    antes do form, por isso o datasource do componente de edição é perdido e o
    evento change é lançado. }
    if csDestroying in ComponentState then
        Exit;

    LocalizarObrasSemelhantes;
end;

procedure TBDOForm_Obras.DoKeyPress_PRO(Sender: TObject; var Key: Char);
begin
  inherited;
    { Isso foi colocado devido a um pedido do sr. Marcelo Pinheiro... Não sei se
    causará problemas. Se causar, tire!

    Um problema de decodificação de teclas de atalho ocorre quando se usa esta
    forma de ativação de edição/inserção. Se o cursor estiver dentro de um edit que
    esteja usando este evento, o atalho de teclado não funciona!

    }
    if TBDODataModule_Obras(MyDataModule).PROPOSTAS.State = dsBrowse then
	    if TBDODataModule_Obras(MyDataModule).PROPOSTAS.RecordCount = 0 then
    		TBDODataModule_Obras(MyDataModule).PROPOSTAS.DataSource.DataSet.Insert
	    else
    		TDBEdit(Sender).DataSource.DataSet.Edit;

    if Sender = DBEdit_PRO_FL_DESCONTOVAL then
        DBEdit_PRO_FL_DESCONTOPERC.Field.Clear
    else if Sender = DBEdit_PRO_FL_DESCONTOPERC then
        DBEdit_PRO_FL_DESCONTOVAL.Field.Clear;
end;

procedure TBDOForm_Obras.DBRichEdit_OBR_TX_CONDICAODEPAGAMENTOChange(Sender: TObject);
begin
    inherited;
	Label_OBR_CaracteresRestantes1.Caption := IntToStr(Length(DBRichEdit_OBR_TX_CONDICAODEPAGAMENTO.Text)) + '/65535';
end;

procedure TBDOForm_Obras.DBRichEdit_OBR_TX_CONDICOESGERAISChange(Sender: TObject);
begin
    inherited;
	Label_OBR_CaracteresRestantes2.Caption := IntToStr(Length(DBRichEdit_OBR_TX_CONDICOESGERAIS.Text)) + '/65535';
end;

procedure TBDOForm_Obras.DBMemo_OBR_TX_OBSERVACOESChange(Sender: TObject);
begin
    inherited;
	Label_OBR_CaracteresRestantes3.Caption := IntToStr(Length(DBMemo_OBR_TX_OBSERVACOES.Text)) + '/65535';
end;

procedure TBDOForm_Obras.DBText_ITE_IN_ITENS_IDClick(Sender: TObject);
begin
    inherited;
    TBDODataModule_Obras(MyDataModule).ITE_Information;
end;

procedure TBDOForm_Obras.DBText_OBR_IN_OBRAS_IDClick(Sender: TObject);
begin
    inherited;
    TBDODataModule_Obras(MyDataModule).OBR_Information;
end;

procedure TBDOForm_Obras.DBText_PRO_IN_PROPOSTAS_IDClick(Sender: TObject);
begin
    inherited;
    TBDODataModule_Obras(MyDataModule).PRO_Information;
end;

procedure TBDOForm_Obras.DoChangingPageControl(Sender: TObject; var AllowChange: Boolean);
begin
    inherited;
    if (TBDODataModule_Obras(MyDataModule).DataSource_OBR.State in [dsInsert, dsEdit])
    or (TBDODataModule_Obras(MyDataModule).DataSource_PRO.State in [dsInsert, dsEdit])
    or (TBDODataModule_Obras(MyDataModule).DataSource_ITE.State in [dsInsert, dsEdit])
    or (TBDODataModule_Obras(MyDataModule).DataSource_EDI.State in [dsInsert, dsEdit]) then
    begin
        MessageBox(Handle,PChar(RS_PAGECHANGENOTALLOWEDNOW), PChar(RS_ACTIONNOTALLOWEDNOW), MB_ICONWARNING or MB_OK);
        AllowChange := False;
    end
    else if (TPageControl(Sender) = PageControl_Cadastro)
        and (TBDODataModule_Obras(MyDataModule).PROPOSTAS.RecordCount = 0) then
    begin
        MessageBox(Handle,PChar(RS_OBRASEMPROPOSTAS), PChar(RS_ACTIONNOTALLOWEDNOW), MB_ICONWARNING or MB_OK);
        AllowChange := False;
    end;
end;

procedure TBDOForm_Obras.DoDrawColumnCell(Sender: TObject; const Rect: TRect; DataCol: Integer; Column: TColumn; State: TGridDrawState);
var
	OffsetLeft: Byte;
    OldPenStyle: TPenStyle;
begin
    inherited;
    { Coloca a imagem de sim ou não no grid que indica a proposta padrão }
    if Sender = CFDBGrid_PRO_Padrao then
    begin
        // Ñão sei pra que isso embaixo por isso tirei
//        TCFDBGrid(Sender).DefaultDrawColumnCell(Rect, DataCol, Column, State);
        OffsetLeft := ((Rect.Right - Rect.Left) div 2) - 8;
        OldPenStyle := TCFDBGrid(Sender).Canvas.Pen.Style;
        TCFDBGrid(Sender).Canvas.Pen.Style := psClear;
        TCFDBGrid(Sender).Canvas.Rectangle(Rect);
        TCFDBGrid(Sender).Canvas.Pen.Style := OldPenStyle;
        if Column.Field.AsInteger = 0 then
            TCFDBGrid(Sender).Canvas.Draw(Rect.Left + OffsetLeft,Rect.Top,Image_NaoPadrao.Picture.Graphic)
        else
            TCFDBGrid(Sender).Canvas.Draw(Rect.Left + OffsetLeft,Rect.Top,Image_Padrao.Picture.Graphic);
    end
    { Pinta os lucros brutos de acordo com o valor no grid de itens }
    else if TCFDBGrid(Sender) = CFDBGrid_ITE then
    begin
	    if (DataCol = 7) and not (gdSelected in State) then
    		if TCFDBGrid(Sender).DataSource.DataSet.FieldByName('LUCROBRUTO').AsFloat < 0 then
            begin
			    TCFDBGrid(Sender).Canvas.Font.Color := clRed;
//                TCFDBGrid(Sender).Canvas.Font.Style := [fsBold];
            end
    		else if TCFDBGrid(Sender).DataSource.DataSet.FieldByName('LUCROBRUTO').AsFloat > 0 then
            begin
            	TCFDBGrid(Sender).Canvas.Font.Color := clGreen;
//                TCFDBGrid(Sender).Canvas.Font.Style := [fsBold];
            end;

    	TCFDBGrid(Sender).DefaultDrawColumnCell(Rect, DataCol, Column, State);
    end
    { Ajusta a posição do combobox de edição }
    else if TCFDBGrid(Sender) = CFDBGrid_OBR_SCH then
    begin
	    if (DataCol = 4) and (gdSelected in State) then
    	begin
		    ComboBox_OBR_SCH_TI_SITUACOES_ID.Hide;
    	    ComboBox_OBR_SCH_TI_SITUACOES_ID.SetBounds(Rect.Left + CFDBGrid_OBR_SCH.Left + 1
                                                      ,Rect.Top + CFDBGrid_OBR_SCH.Top + 1
                                                      ,Rect.Right - Rect.Left + 2
                                                      ,Rect.Bottom - Rect.Top);
            TCFDBGrid(Sender).DefaultDrawColumnCell(Rect, DataCol, Column, State);
	    end;
    end
    else if TCFDBGrid(Sender) = CFDBGrid_PRO_SCH then
    begin
        { Ajusta a posição do combobox de edição }
	    if (DataCol = 3) and (gdSelected in State) then
    	begin
		    ComboBox_PRO_SCH_TI_SITUACOES_ID.Hide;
    	    ComboBox_PRO_SCH_TI_SITUACOES_ID.SetBounds(Rect.Left + CFDBGrid_PRO_SCH.Left + 1
                                                      ,Rect.Top + CFDBGrid_PRO_SCH.Top + 1
                                                      ,Rect.Right - Rect.Left + 2
                                                      ,Rect.Bottom - Rect.Top);

            CFDBGrid_PRO_SCH.DefaultDrawColumnCell(Rect, DataCol, Column, State);
	    end
        { Pinta os nomes SIM e NÃO no filtro de proposta }
        else if (DataCol = 6) and not (gdSelected in State) then
        begin
//            CFDBGrid_PRO_SCH.Canvas.Font.Style := [fsBold];
	        if not TBDODataModule_Obras(MyDataModule).PROPOSTAS_SEARCHBO_PROPOSTAPADRAO.IsNull and (TBDODataModule_Obras(MyDataModule).PROPOSTAS_SEARCHBO_PROPOSTAPADRAO.AsInteger <> 0) then
                CFDBGrid_PRO_SCH.Canvas.Font.Color := clGreen
            else
                CFDBGrid_PRO_SCH.Canvas.Font.Color := clRed;

            CFDBGrid_PRO_SCH.DefaultDrawColumnCell(Rect, DataCol, Column, State);
	    end;

    end
    else if TCFDBGrid(Sender) = CFDBGrid_EQP_SCH then
    begin
        { Pinta os nomes SIM e NÃO no filtro de equipamentos }
        if (DataCol = 4) and not (gdSelected in State) then
        begin
//            CFDBGrid_EQP_SCH.Canvas.Font.Style := [fsBold];
	        if not TBDODataModule_Obras(MyDataModule).EQUIPAMENTOS_SEARCHBO_PROPOSTAPADRAO.IsNull and (TBDODataModule_Obras(MyDataModule).EQUIPAMENTOS_SEARCHBO_PROPOSTAPADRAO.AsInteger <> 0) then
                CFDBGrid_EQP_SCH.Canvas.Font.Color := clGreen
            else
                CFDBGrid_EQP_SCH.Canvas.Font.Color := clRed;
            CFDBGrid_EQP_SCH.DefaultDrawColumnCell(Rect, DataCol, Column, State);
	    end;
    end;
end;

procedure TBDOForm_Obras.DoEQP_SCHChange(Sender: TObject);
begin
    inherited;
    EQP_SCH_ApplyFilter;
end;

procedure TBDOForm_Obras.DoEQP_SCHClick(Sender: TObject);
begin
    inherited;
    EQP_SCH_ApplyFilter;
end;

procedure TBDOForm_Obras.DoEQP_SCHKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
begin
    inherited;
    if (([ssCtrl] = Shift) or Configurations.UseEnterAloneToSearch) and (Key = 13) then
        EQP_SCH_ApplyFilter;
end;

procedure TBDOForm_Obras.DoOBR_SCHClick(Sender: TObject);
begin
    inherited;
    if Sender is TCheckBox then
    begin
        if TCheckBox(Sender) = CheckBox_OBR_SCH_DA_DATADEENTRADA1 then
            DateTimePicker_OBR_SCH_DA_DATADEENTRADA1.Enabled := TCheckBox(Sender).Checked
        else if TCheckBox(Sender) = CheckBox_OBR_SCH_DA_DATADEENTRADA2 then
            DateTimePicker_OBR_SCH_DA_DATADEENTRADA2.Enabled := TCheckBox(Sender).Checked;
    end;

    OBR_SCH_ApplyFilter;
end;

procedure TBDOForm_Obras.DoOBR_SCHChange(Sender: TObject);
begin
    inherited;
    OBR_SCH_ApplyFilter;
end;

procedure TBDOForm_Obras.DoOBR_SCHKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
begin
    if (([ssCtrl] = Shift) or Configurations.UseEnterAloneToSearch) and (Key = 13) then
        OBR_SCH_ApplyFilter;
end;

procedure TBDOForm_Obras.DoPRO_SCHChange(Sender: TObject);
begin
    inherited;
    PRO_SCH_ApplyFilter;
end;

procedure TBDOForm_Obras.DoPRO_SCHClick(Sender: TObject);
begin
    inherited;
    PRO_SCH_ApplyFilter;
end;

procedure TBDOForm_Obras.DoPRO_SCHKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
begin
    inherited;
    if (([ssCtrl] = Shift) or Configurations.UseEnterAloneToSearch) and (Key = 13) then
        PRO_SCH_ApplyFilter;
end;

procedure TBDOForm_Obras.DoResizeTabSheet(Sender: TObject);
begin
    inherited;
    if TTabSheet(Sender) = TabSheet_OBR_PRO then
    begin
        AjustarCamposDeTexto;
    end
    else if TTabSheet(Sender) = TabSheet_OBR_SCH then
    begin
        OBR_SCH_ApplyFilter;
    end
    else if TTabSheet(Sender) = TabSheet_PRO_SCH then
    begin
        PRO_SCH_ApplyFilter;
    end
    else if TTabSheet(Sender) = TabSheet_EQP_SCH then
    begin
        EQP_SCH_ApplyFilter;
    end;
end;

procedure TBDOForm_Obras.DoShowTabSheet(Sender: TObject);
begin
    inherited;
    if TTabSheet(Sender) = TabSheet_ITE_EDI then
    begin
        { Algumas vezes os labels a seguir não aumentavam de tamanho
        corretamente, por isso eles tem de ser ressetados ao menos uma vez }
        if GroupBox_ITE_Info.Tag = 0 then
        begin
            Label_ITE_Info2.Width := Label_ITE_Info2.Parent.Width - 16;
            Label_ITE_Info4.Width := Label_ITE_Info4.Parent.Width - 16;
            Label_ITE_Info5.Width := Label_ITE_Info5.Parent.Width - 16;

            Label_ITE_Equipamentos.Left := Label_ITE_Equipamentos.Parent.Width - Label_ITE_Equipamentos.Width - 8;
            DBText_ITE_TOTAL.Left := DBText_ITE_TOTAL.Parent.Width - DBText_ITE_TOTAL.Width - 8;
            DBText_ITE_LUCROBRUTO.Left := DBText_ITE_LUCROBRUTO.Parent.Width - DBText_ITE_LUCROBRUTO.Width - 8;

            MyDataModule.SetLabelDescriptionValue(Label_ITE_Info4,DBText_ITE_TOTAL);
            MyDataModule.SetLabelDescriptionValue(Label_ITE_Info5,DBText_ITE_LUCROBRUTO);
            MyDataModule.SetLabelDescriptionValue(Label_ITE_Info2,Label_ITE_Equipamentos,IntToStr(TBDODataModule_Obras(MyDataModule).EQUIPAMENTOSDOSITENS.RecordCount));

            GroupBox_ITE_Info.Tag := 1;
        end;
    end;
end;

procedure TBDOForm_Obras.DoTimer(var Msg: TMessage);
begin
    case TWMTimer(Msg).TimerID of
        IDT_AJUSTAR: begin
            AjustarAreasDeTexto;

            KillTimer(Handle,TWMTimer(Msg).TimerID);
        end;
    end;
end;

procedure TBDOForm_Obras.Edit_EQP_VA_MODELOChange(Sender: TObject);
begin
    inherited;
    TBDODataModule_Obras(MyDataModule).LocalizarEquipamento(Edit_EQP_VA_MODELO,'VA_MODELO');
end;

procedure TBDOForm_Obras.Edit_EQP_VA_MODELOEnter(Sender: TObject);
begin
    inherited;
    Edit_EQP_VA_MODELO.Clear;
    BitBtn_EDI_DesmarcarTodos.Click;
end;

procedure TBDOForm_Obras.EQP_SCH_ApplyFilter(const aGotoFirstPage: Boolean = True);
var
    EQPFilter: TEQPFilter;
begin
    if csDestroying in ComponentState then
        Exit;

    { Obtém o filtro }
    EQPFilter := EQP_SCH_Filter;
    { Atualiza as métricas de acordo com o filtro e com o CFDBGrid }
    TBDODataModule_Obras(MyDataModule).EQP_SCH_UpdateMetrics(CFDBGrid_EQP_SCH,EQPFilter);
    { Aplica o filtro e coloca o conjunto de dados na página especificada }
    if aGotoFirstPage then
        TBDODataModule_Obras(MyDataModule).EQP_SCH_GotoPage(dpbFirst,EQPFilter,EQP_SCH_SortField)
    else
        TBDODataModule_Obras(MyDataModule).EQP_SCH_GotoPage(dpbCustom,EQPFilter,EQP_SCH_SortField,TBDODataModule_Obras(MyDataModule).EQP_SCH_CurrentPage)
end;

function TBDOForm_Obras.EQP_SCH_Filter: TEQPFilter;
begin
	ZeroMemory(@Result,SizeOf(TPROFilter));
	with Result do
    begin
        VA_MODELO := LabeledEdit_EQP_SCH_VA_MODELO.Text;
		EN_VOLTAGEM := ComboBox_EQP_SCH_EN_VOLTAGEM.Text;
        SM_CODIGO := StrToIntDef(CFEdit_EQP_SCH_SM_CODIGO.Text,0);
        YR_ANO := StrToIntDef(CFEdit_EQP_SCH_YR_ANO.Text,0);
        BO_PROPOSTAPADRAO := RadioGroup_EQP_SCH_BO_PROPOSTAPADRAO.ItemIndex;
        SM_INSTALADORES_ID := Integer(ComboBox_EQP_SCH_SM_INSTALADORES_ID.Items.Objects[ComboBox_EQP_SCH_SM_INSTALADORES_ID.ItemIndex]);
    end;
    TBDODataModule_Obras(MyDataModule).EQP_SCH_UpdateMetrics(CFDBGrid_EQP_SCH,Result);
end;

procedure TBDOForm_Obras.EQP_SCH_Reset(aFiltrar: Boolean);
begin
    try
        LabeledEdit_EQP_SCH_VA_MODELO.Text := '';
        ComboBox_EQP_SCH_EN_VOLTAGEM.ItemIndex := 0;
        CFEdit_EQP_SCH_SM_CODIGO.Text := '';
        CFEdit_EQP_SCH_YR_ANO.Text := '';
        RadioGroup_EQP_SCH_BO_PROPOSTAPADRAO.ItemIndex := 2;
  	    ComboBox_EQP_SCH_SM_INSTALADORES_ID.ItemIndex := 0;
    finally
	    CFDBGrid_EQP_SCH.SortArrow.Direction := sadNone;
        if aFiltrar then
            with TBDODataModule_Obras(MyDataModule) do
                EQP_SCH_GotoPage(dpbFirst,EQP_SCH_Filter,EQP_SCH_SortField);
    end;
end;

function TBDOForm_Obras.EQP_SCH_SortField: String;
begin
    Result := 'IN_EQUIPAMENTOSDOSITENS_ID ASC';
    if CFDBGrid_EQP_SCH.SortArrow.Direction <> sadNone then
    begin
        Result := CFDBGrid_EQP_SCH.SortArrow.Column;
        case CFDBGrid_EQP_SCH.SortArrow.Direction of
            sadDescending: Result := Result + ' ASC';
            sadAscending: Result := Result + ' DESC';
        end;
    end;
end;

procedure TBDOForm_Obras.ExpandirAreaDeTexto(const aArea: Byte);
begin
    Label_OBR_TX_CONDICAODEPAGAMENTO.Hide;
    Label_OBR_CaracteresRestantes1.Hide;
    Image_Expandir1.Hide;
    Label_OBR_TX_CONDICOESGERAIS.Hide;
    Label_OBR_CaracteresRestantes2.Hide;
    Image_Expandir2.Hide;
    Label_OBR_TX_OBSERVACOES.Hide;
    Label_OBR_CaracteresRestantes3.Hide;
    Image_Expandir3.Hide;
    DBRichEdit_OBR_TX_CONDICAODEPAGAMENTO.Hide;
    DBRichEdit_OBR_TX_CONDICOESGERAIS.Hide;
    DBMemo_OBR_TX_OBSERVACOES.Hide;

    case aArea of
        0: begin
            if DBRichEdit_OBR_TX_CONDICAODEPAGAMENTO.Tag = 1 then
                AjustarAreasDeTexto
            else
            begin
                DBRichEdit_OBR_TX_CONDICAODEPAGAMENTO.Width := DBMemo_OBR_TX_OBSERVACOES.Left - DBRichEdit_OBR_TX_CONDICAODEPAGAMENTO.Left + DBMemo_OBR_TX_OBSERVACOES.Width;
                DBRichEdit_OBR_TX_CONDICAODEPAGAMENTO.Tag := 1;
                Label_OBR_TX_CONDICAODEPAGAMENTO.Left := DBRichEdit_OBR_TX_CONDICAODEPAGAMENTO.Left;

                Image_Expandir1.Left := DBRichEdit_OBR_TX_CONDICAODEPAGAMENTO.Left + DBRichEdit_OBR_TX_CONDICAODEPAGAMENTO.Width - Image_Expandir1.Width;
                Image_Expandir1.Picture.Assign(Image_Contrair.Picture);
                Label_OBR_CaracteresRestantes1.Left := Image_Expandir1.Left - Label_OBR_CaracteresRestantes1.Width - 6;

                DBRichEdit_OBR_TX_CONDICAODEPAGAMENTO.Visible := True;
                Label_OBR_TX_CONDICAODEPAGAMENTO.Visible := True;
                Label_OBR_CaracteresRestantes1.Visible := True;
                Image_Expandir1.Visible := True;
            end;
        end;
        1: begin
            if DBRichEdit_OBR_TX_CONDICOESGERAIS.Tag = 1 then
                AjustarAreasDeTexto
            else
            begin
                DBRichEdit_OBR_TX_CONDICOESGERAIS.Left := DBRichEdit_OBR_TX_CONDICAODEPAGAMENTO.Left;
                DBRichEdit_OBR_TX_CONDICOESGERAIS.Tag := 1;
                DBRichEdit_OBR_TX_CONDICOESGERAIS.Width := DBMemo_OBR_TX_OBSERVACOES.Left - DBRichEdit_OBR_TX_CONDICOESGERAIS.Left + DBMemo_OBR_TX_OBSERVACOES.Width;
                Label_OBR_TX_CONDICOESGERAIS.Left := DBRichEdit_OBR_TX_CONDICOESGERAIS.Left;

                Image_Expandir2.Left := DBRichEdit_OBR_TX_CONDICOESGERAIS.Left + DBRichEdit_OBR_TX_CONDICOESGERAIS.Width - Image_Expandir2.Width;
                Image_Expandir2.Picture.Assign(Image_Contrair.Picture);
                Label_OBR_CaracteresRestantes2.Left := Image_Expandir2.Left - Label_OBR_CaracteresRestantes2.Width - 6;

                DBRichEdit_OBR_TX_CONDICOESGERAIS.Visible := True;
                Label_OBR_TX_CONDICOESGERAIS.Visible := True;
                Label_OBR_CaracteresRestantes2.Visible := True;
                Image_Expandir2.Visible := True;
            end;
        end;
        2: begin
            if DBMemo_OBR_TX_OBSERVACOES.Tag = 1 then
                AjustarAreasDeTexto
            else
            begin
                DBMemo_OBR_TX_OBSERVACOES.Width := DBMemo_OBR_TX_OBSERVACOES.Left - DBRichEdit_OBR_TX_CONDICAODEPAGAMENTO.Left + DBMemo_OBR_TX_OBSERVACOES.Width;
                DBMemo_OBR_TX_OBSERVACOES.Tag := 1;
                DBMemo_OBR_TX_OBSERVACOES.Left := DBRichEdit_OBR_TX_CONDICAODEPAGAMENTO.Left;
                Label_OBR_TX_OBSERVACOES.Left := DBMemo_OBR_TX_OBSERVACOES.Left;

                Image_Expandir3.Left := DBMemo_OBR_TX_OBSERVACOES.Left + DBMemo_OBR_TX_OBSERVACOES.Width - Image_Expandir3.Width;
                Image_Expandir3.Picture.Assign(Image_Contrair.Picture);
                Label_OBR_CaracteresRestantes3.Left := Image_Expandir3.Left - Label_OBR_CaracteresRestantes3.Width - 6;

                DBMemo_OBR_TX_OBSERVACOES.Visible := True;
                Label_OBR_TX_OBSERVACOES.Visible := True;
                Label_OBR_CaracteresRestantes3.Visible := True;
                Image_Expandir3.Visible := True;
            end;
        end;
    end;
end;

procedure TBDOForm_Obras.AjustarAreasDeTexto;
begin
    MyDataModule.EqualizeWidthsAndAdjust([DBRichEdit_OBR_TX_CONDICAODEPAGAMENTO, DBRichEdit_OBR_TX_CONDICOESGERAIS, DBMemo_OBR_TX_OBSERVACOES], [Label_OBR_TX_CONDICAODEPAGAMENTO, Label_OBR_TX_CONDICOESGERAIS, Label_OBR_TX_OBSERVACOES]);

    Image_Expandir1.Left := DBRichEdit_OBR_TX_CONDICAODEPAGAMENTO.Left + DBRichEdit_OBR_TX_CONDICAODEPAGAMENTO.Width - Image_Expandir1.Width;
    Image_Expandir1.Picture.Assign(Image_Expandir.Picture);
    Label_OBR_CaracteresRestantes1.Left := Image_Expandir1.Left - Label_OBR_CaracteresRestantes1.Width - 6;

    Image_Expandir2.Left := DBRichEdit_OBR_TX_CONDICOESGERAIS.Left + DBRichEdit_OBR_TX_CONDICOESGERAIS.Width - Image_Expandir2.Width;
    Image_Expandir2.Picture.Assign(Image_Expandir.Picture);
    Label_OBR_CaracteresRestantes2.Left := Image_Expandir2.Left - Label_OBR_CaracteresRestantes2.Width - 6;

    Image_Expandir3.Left := DBMemo_OBR_TX_OBSERVACOES.Left + DBMemo_OBR_TX_OBSERVACOES.Width - Image_Expandir3.Width;
    Image_Expandir3.Picture.Assign(Image_Expandir.Picture);
    Label_OBR_CaracteresRestantes3.Left := Image_Expandir3.Left - Label_OBR_CaracteresRestantes3.Width - 6;

    DBRichEdit_OBR_TX_CONDICOESGERAIS.Tag := 0;
    DBRichEdit_OBR_TX_CONDICAODEPAGAMENTO.Tag := 0;
    DBMemo_OBR_TX_OBSERVACOES.Tag := 0;

    DBRichEdit_OBR_TX_CONDICOESGERAIS.Refresh;
    DBRichEdit_OBR_TX_CONDICAODEPAGAMENTO.Refresh;
    DBMemo_OBR_TX_OBSERVACOES.Refresh;

    DBRichEdit_OBR_TX_CONDICAODEPAGAMENTO.Visible := True;
    Label_OBR_TX_CONDICAODEPAGAMENTO.Visible := True;
    Label_OBR_CaracteresRestantes1.Visible := True;
    Image_Expandir1.Visible := True;

    DBRichEdit_OBR_TX_CONDICOESGERAIS.Visible := True;
    Label_OBR_TX_CONDICOESGERAIS.Visible := True;
    Label_OBR_CaracteresRestantes2.Visible := True;
    Image_Expandir2.Visible := True;

    DBMemo_OBR_TX_OBSERVACOES.Visible := True;
    Label_OBR_TX_OBSERVACOES.Visible := True;
    Label_OBR_CaracteresRestantes3.Visible := True;
    Image_Expandir3.Visible := True;    
end;

procedure TBDOForm_Obras.FormCreate(Sender: TObject);
begin
    inherited;
    InicializarRegioes;
    InicializarTipos;
    InicializarSituacoes;
    InicializarProjetistas;
    InicializarInstaladores(ComboBox_PRO_SCH_SM_INSTALADORES_ID);
    ComboBox_EQP_SCH_SM_INSTALADORES_ID.Items.Assign(ComboBox_PRO_SCH_SM_INSTALADORES_ID.Items);
    InicializarMoedas;
    InicializarAnosDeConclusao;

 	MyDataModule.LoadComboBoxItems(DBComboBox_ITE_VA_DESCRICAO,Configurations.CurrentDir + '\ITE_VA_DESCRICAO.TXT');

    OBR_SCH_Reset(False);
    PRO_SCH_Reset(False);
    EQP_SCH_Reset(False);
end;

procedure TBDOForm_Obras.FormShow(Sender: TObject);
const
    EM_SETTYPOGRAPHYOPTIONS = (WM_USER + 202);
//    EM_GETTYPOGRAPHYOPTIONS = (WM_USER + 203);
    TO_ADVANCEDTYPOGRAPHY = $1;
begin
    inherited;
    CFDBGrid_ITE.Columns[7].Visible := TBDOConfigurations(Configurations).ExibirColunaLucroBrutoEmCadastroDeItens;
    SendMessage(DBRichEdit_OBR_TX_CONDICOESGERAIS.Handle,EM_SETTYPOGRAPHYOPTIONS,TO_ADVANCEDTYPOGRAPHY,TO_ADVANCEDTYPOGRAPHY);
    SendMessage(DBRichEdit_OBR_TX_CONDICAODEPAGAMENTO.Handle,EM_SETTYPOGRAPHYOPTIONS,TO_ADVANCEDTYPOGRAPHY,TO_ADVANCEDTYPOGRAPHY);
end;

procedure TBDOForm_Obras.AjustarCamposDeTexto;
begin
    { Usei Classes por que MakeObjectInstance existente em Forms foi depreciado }
    SetTimer(Handle,IDT_AJUSTAR,50,Classes.MakeObjectInstance(DoTimer));
end;

procedure TBDOForm_Obras.ApenasNumeros(Sender: TObject; var Key: Char);
begin
    inherited;
    Key := Char(MyDataModule.AllowedChars(AnsiChar(Key),['0'..'9']));
end;

procedure TBDOForm_Obras.InicializarRegioes;
begin
    TBDODataModule_Obras(MyDataModule).PreencherComRegioes(ComboBox_OBRAS_SEARCH_TI_REGIOES_ID.Items);
    ComboBox_OBRAS_SEARCH_TI_REGIOES_ID.ItemIndex := 0;
end;

procedure TBDOForm_Obras.InicializarTipos;
begin
    TBDODataModule_Obras(MyDataModule).PreencherComTipos(ComboBox_OBRAS_SEARCH_TI_TIPOS_ID.Items);
    ComboBox_OBRAS_SEARCH_TI_TIPOS_ID.ItemIndex := 0;
end;

procedure TBDOForm_Obras.InicializarSituacoes;
begin
    TBDODataModule_Obras(MyDataModule).PreencherComSituacoes(ComboBox_OBRAS_SEARCH_TI_SITUACOES_ID.Items);
    ComboBox_OBRAS_SEARCH_TI_SITUACOES_ID.ItemIndex := 0;

    ComboBox_OBR_SCH_TI_SITUACOES_ID.Clear;
    ComboBox_OBR_SCH_TI_SITUACOES_ID.Items.Assign(ComboBox_OBRAS_SEARCH_TI_SITUACOES_ID.Items);
    ComboBox_OBR_SCH_TI_SITUACOES_ID.Items.Delete(0);

    ComboBox_PRO_SCH_TI_SITUACOES_ID.Items.Assign(ComboBox_OBR_SCH_TI_SITUACOES_ID.Items);
end;

procedure TBDOForm_Obras.InicializarProjetistas;
begin
    TBDODataModule_Obras(MyDataModule).PreencherComProjetistas(ComboBox_OBRAS_SEARCH_SM_PROJETISTAS_ID.Items);
    ComboBox_OBRAS_SEARCH_SM_PROJETISTAS_ID.ItemIndex := 0;
end;

procedure TBDOForm_Obras.InicializarInstaladores(const aComboBox: TComboBox);
begin
    TBDODataModule_Obras(MyDataModule).PreencherComInstaladores(aComboBox.Items);
    aComboBox.ItemIndex := 0;
end;

procedure TBDOForm_Obras.InicializarMoedas;
var
    i: Byte;
begin
    DBComboBox_PRO_TI_MOEDA.Items.Clear;

    for i := 1 to High(CURRENCY_STRINGS) do
        DBComboBox_PRO_TI_MOEDA.Items.Add(CURRENCY_STRINGS[i]);
end;

procedure TBDOForm_Obras.Image_Expandir1Click(Sender: TObject);
begin
    inherited;
    ExpandirAreaDeTexto(0);
end;

procedure TBDOForm_Obras.Image_Expandir2Click(Sender: TObject);
begin
    inherited;
    ExpandirAreaDeTexto(1);
end;

procedure TBDOForm_Obras.Image_Expandir3Click(Sender: TObject);
begin
    inherited;
    ExpandirAreaDeTexto(2);
end;

procedure TBDOForm_Obras.InicializarAnosDeConclusao;
var
    i: Word;
    Inicio: Word;
    Fim: Word;
begin
    Inicio := 2005;
    Fim := YearOf(Now) + 1;

    if Inicio > Fim then
        raise Exception.Create('A data do sistema parece estar errada. Não é possível inicializar a lista de anos de conclusão. Verifique a data do sistema imediatamente!');

    DBComboBox_OBR_YR_ANOPROVAVELDEENTREGA.Items.Clear;
    
    for i := Inicio to Fim do
        DBComboBox_OBR_YR_ANOPROVAVELDEENTREGA.Items.Add(IntToStr(i));
end;

procedure TBDOForm_Obras.CFDBGrid_EQP_SCHTitleClick(Column: TColumn);
begin
    inherited;
    { Uma limitação técnica impede a ordenação por valor }
	if Column.Index in [0,1,2] then
    begin
        if CFDBGrid_EQP_SCH.SortArrow.Column = Column.FieldName then
            if CFDBGrid_EQP_SCH.SortArrow.Direction = sadDescending then
                CFDBGrid_EQP_SCH.SortArrow.Direction := sadAscending
            else
                CFDBGrid_EQP_SCH.SortArrow.Direction := sadDescending
        else
        begin
            CFDBGrid_EQP_SCH.SortArrow.Column := Column.FieldName;
            CFDBGrid_EQP_SCH.SortArrow.Direction := sadDescending;
        end;

        with TBDODataModule_Obras(MyDataModule) do
        	EQP_SCH_Filtrar(EQP_SCH_Filter,EQP_SCH_CurrentPage,EQP_SCH_RecordsByPage,EQP_SCH_SortField);
    end;
end;

procedure TBDOForm_Obras.CFDBGrid_EDIAfterMultiselect(aSender: TObject; aMultiSelectEventTrigger: TMultiSelectEventTrigger);
begin
    inherited;
    MyDataModule.SafeSetActionEnabled(TBDODataModule_Obras(MyDataModule).Action_EDI_Delete
                                     ,(CFDBGrid_EDI.SelectedRows.Count > 0) and TBDODataModule_Obras(MyDataModule).Action_EDI_Delete.Allowed);
end;

procedure TBDOForm_Obras.CFDBGrid_EDIDblClick(Sender: TObject);
var
	BS: TBookmark;
begin
	inherited;
	try
        TCFDBGrid(Sender).DataSource.DataSet.DisableControls;
    	BS := TCFDBGrid(Sender).DataSource.DataSet.Bookmark;

        TCFDBGrid(Sender).DataSource.DataSet.First;
        while not TCFDBGrid(Sender).DataSource.DataSet.Eof do
        begin
          	TCFDBGrid(Sender).SelectedRows.CurrentRowSelected := False;
            TCFDBGrid(Sender).DataSource.DataSet.Next;
        end;

    	TCFDBGrid(Sender).DataSource.DataSet.Bookmark := BS;
        TCFDBGrid(Sender).SelectedRows.CurrentRowSelected := True;

        TBDODataModule_Obras(MyDataModule).Action_EDI_Delete.Execute;
    finally
        TCFDBGrid(Sender).DataSource.DataSet.EnableControls;
    end;
end;

procedure TBDOForm_Obras.CFDBGrid_EQPAfterMultiselect(aSender: TObject; aMultiSelectEventTrigger: TMultiSelectEventTrigger);
begin
    inherited;
    MyDataModule.SafeSetActionEnabled(TBDODataModule_Obras(MyDataModule).Action_EDI_Insert
                                     ,(CFDBGrid_EQP.SelectedRows.Count > 0) and TBDODataModule_Obras(MyDataModule).Action_EDI_Insert.Allowed);

    Action_EDI_DesmarcarTodos.Enabled := TCFDBGrid(aSender).SelectedRows.Count > 0;
    if Action_EDI_DesmarcarTodos.Enabled then
    begin
    	if TCFDBGrid(aSender).SelectedRows.Count > 1 then
	        Action_EDI_DesmarcarTodos.Caption := 'Desmarcar todos os ' + IntToStr(TCFDBGrid(aSender).SelectedRows.Count) + ' equipamentos marcados'
        else
	        Action_EDI_DesmarcarTodos.Caption := 'Desmarcar o único equipamento marcado';
    end
    else
        Action_EDI_DesmarcarTodos.Caption := 'Não há equipamentos marcados';
end;

procedure TBDOForm_Obras.CFDBGrid_EQPDblClick(Sender: TObject);
var
	BS: TBookmark;
begin
	inherited;
	try
        TCFDBGrid(Sender).DataSource.DataSet.DisableControls;
    	BS := TCFDBGrid(Sender).DataSource.DataSet.Bookmark;

        TCFDBGrid(Sender).DataSource.DataSet.First;
        while not TCFDBGrid(Sender).DataSource.DataSet.Eof do
        begin
           	TCFDBGrid(Sender).SelectedRows.CurrentRowSelected := False;
            TCFDBGrid(Sender).DataSource.DataSet.Next;
        end;

    	TCFDBGrid(Sender).DataSource.DataSet.Bookmark := BS;
        TCFDBGrid(Sender).SelectedRows.CurrentRowSelected := True;

        TBDODataModule_Obras(MyDataModule).Action_EDI_Insert.Execute;
    finally
        TCFDBGrid(Sender).DataSource.DataSet.EnableControls;
    end;
end;

procedure TBDOForm_Obras.CFDBGrid_OBR_PRO_SCHDblClick(Sender: TObject);
begin
    inherited;
    TBDODataModule_Obras(MyDataModule).ExibirComboDeSituacoes(Sender);
end;

procedure TBDOForm_Obras.CFDBGrid_OBR_SCHTitleClick(Column: TColumn);
begin
    inherited;
    { Uma limitação técnica impede a ordenação por valor padrão }
	if Column.Index in [0,1,2,3,4{,5}] then
    begin
        if CFDBGrid_OBR_SCH.SortArrow.Column = Column.FieldName then
            if CFDBGrid_OBR_SCH.SortArrow.Direction = sadDescending then
                CFDBGrid_OBR_SCH.SortArrow.Direction := sadAscending
            else
                CFDBGrid_OBR_SCH.SortArrow.Direction := sadDescending
        else
        begin
            CFDBGrid_OBR_SCH.SortArrow.Column := Column.FieldName;
            CFDBGrid_OBR_SCH.SortArrow.Direction := sadDescending;
        end;

        with TBDODataModule_Obras(MyDataModule) do
        	OBR_SCH_Filtrar(OBR_SCH_Filter,OBR_SCH_CurrentPage,OBR_SCH_RecordsByPage,OBR_SCH_SortField);
    end;
end;

procedure TBDOForm_Obras.CFDBGrid_PRO_PadraoCellClick(Column: TColumn);
begin
    inherited;
    TBDODataModule_Obras(MyDataModule).TogglePropostaPadrao;
end;

procedure TBDOForm_Obras.CFDBGrid_PRO_SCHTitleClick(Column: TColumn);
begin
    inherited;
    { Uma limitação técnica impede a ordenação por valor }
	if Column.Index in [0,1,2,3,4{,5,6}] then
    begin
        if CFDBGrid_PRO_SCH.SortArrow.Column = Column.FieldName then
            if CFDBGrid_PRO_SCH.SortArrow.Direction = sadDescending then
                CFDBGrid_PRO_SCH.SortArrow.Direction := sadAscending
            else
                CFDBGrid_PRO_SCH.SortArrow.Direction := sadDescending
        else
        begin
            CFDBGrid_PRO_SCH.SortArrow.Column := Column.FieldName;
            CFDBGrid_PRO_SCH.SortArrow.Direction := sadDescending;
        end;

        with TBDODataModule_Obras(MyDataModule) do
        	PRO_SCH_Filtrar(PRO_SCH_Filter,PRO_SCH_CurrentPage,PRO_SCH_RecordsByPage,PRO_SCH_SortField);
    end;
end;

procedure TBDOForm_Obras.ComboBox_OBR_PRO_SCH_TI_SITUACOES_IDChange(Sender: TObject);
var
    BS: TBookmark;
    IN_OBRAS_ID: Cardinal;
begin
    inherited;
    IN_OBRAS_ID := 0;
    
    if Sender = ComboBox_OBR_SCH_TI_SITUACOES_ID then
        IN_OBRAS_ID := TBDODataModule_Obras(MyDataModule).OBRAS_SEARCHIN_OBRAS_ID.AsInteger
    else if Sender = ComboBox_PRO_SCH_TI_SITUACOES_ID then
        IN_OBRAS_ID := TBDODataModule_Obras(MyDataModule).ObraDaProposta(TBDODataModule_Obras(MyDataModule).PROPOSTAS_SEARCHIN_PROPOSTAS_ID.AsInteger);

    try
        TBDODataModule_Obras(MyDataModule).DefinirNovaSituacao(Byte(TComboBox(Sender).Items.Objects[TComboBox(Sender).ItemIndex]),IN_OBRAS_ID);
        try
            if Sender = ComboBox_OBR_SCH_TI_SITUACOES_ID then
            begin
                TBDODataModule_Obras(MyDataModule).OBRAS_SEARCH.DisableControls;
                BS := TBDODataModule_Obras(MyDataModule).OBRAS_SEARCH.Bookmark;
                OBR_SCH_ApplyFilter(False);
            end
            else if Sender = ComboBox_PRO_SCH_TI_SITUACOES_ID then
            begin
                TBDODataModule_Obras(MyDataModule).PROPOSTAS_SEARCH.DisableControls;
                BS := TBDODataModule_Obras(MyDataModule).PROPOSTAS_SEARCH.Bookmark;
                PRO_SCH_ApplyFilter(False);
            end;

        finally
            if Sender = ComboBox_OBR_SCH_TI_SITUACOES_ID then
            begin
                TBDODataModule_Obras(MyDataModule).OBRAS_SEARCH.Bookmark := BS;
                TBDODataModule_Obras(MyDataModule).OBRAS_SEARCH.EnableControls;
            end
            else if Sender = ComboBox_PRO_SCH_TI_SITUACOES_ID then
            begin
                TBDODataModule_Obras(MyDataModule).PROPOSTAS_SEARCH.Bookmark := BS;
                TBDODataModule_Obras(MyDataModule).PROPOSTAS_SEARCH.EnableControls;
            end;
        end;
    finally
        TComboBox(Sender).Hide;
    end;
end;

procedure TBDOForm_Obras.Label_EQP_SCH_INSTALADORClick(Sender: TObject);
begin
    inherited;
    if MessageBox(Handle,'Isso vai atualizar esta lista, mas vai remover o filtro para este campo. Tem certeza?','Tem certeza?',MB_ICONQUESTION or MB_YESNO) = idYes then
    begin
        InicializarInstaladores(ComboBox_EQP_SCH_SM_INSTALADORES_ID);
        EQP_SCH_ApplyFilter;
    end;
end;

procedure TBDOForm_Obras.Label_ITE_CapacidadeTermicaClick(Sender: TObject);
begin
    inherited;
    TBDODataModule_Obras(MyDataModule).UNIDADES_LOOKUP.Refresh;
end;

procedure TBDOForm_Obras.Label_ITE_TI_FAMILIAS_IDClick(Sender: TObject);
begin
    inherited;
    TBDODataModule_Obras(MyDataModule).FAMILIAS_LOOKUP.Refresh;
end;

procedure TBDOForm_Obras.Label_OBR_FL_ICMSClick(Sender: TObject);
begin
    inherited;
    TBDODataModule_Obras(MyDataModule).ICMS_LOOKUP.Refresh;
end;

procedure TBDOForm_Obras.Label_OBR_INSTALADORClick(Sender: TObject);
begin
    inherited;
    TBDODataModule_Obras(MyDataModule).INSTALADORES_LOOKUP.Refresh;
end;

procedure TBDOForm_Obras.Label_OBR_JustificativaSalvaClick(Sender: TObject);
begin
    inherited;
    TBDODataModule_Obras(MyDataModule).ExibirJustificativa2(TBDODataModule_Obras(MyDataModule).OBRASIN_OBRAS_ID.AsInteger);
end;

procedure TBDOForm_Obras.Label_OBR_SM_PROJETISTAS_IDClick(Sender: TObject);
begin
    inherited;
    TBDODataModule_Obras(MyDataModule).PROJETISTAS_LOOKUP.Refresh;
end;

procedure TBDOForm_Obras.Label_OBR_SM_PROJETISTAS_ID_FiltrarClick(Sender: TObject);
begin
    inherited;
    if MessageBox(Handle,'Isso vai atualizar esta lista, mas vai remover o filtro para este campo. Tem certeza?','Tem certeza?',MB_ICONQUESTION or MB_YESNO) = idYes then
    begin
        InicializarProjetistas;
        OBR_SCH_ApplyFilter;
    end;
end;

procedure TBDOForm_Obras.Label_OBR_TI_REGIOES_IDClick(Sender: TObject);
begin
    inherited;
    TBDODataModule_Obras(MyDataModule).REGIOES_LOOKUP.Refresh;
end;

procedure TBDOForm_Obras.Label_OBR_TI_REGIOES_ID_FiltrarClick(Sender: TObject);
begin
    inherited;
    if MessageBox(Handle,'Isso vai atualizar esta lista, mas vai remover o filtro para este campo. Tem certeza?','Tem certeza?',MB_ICONQUESTION or MB_YESNO) = idYes then
    begin
        InicializarRegioes;
        OBR_SCH_ApplyFilter;
    end;
end;

end.
