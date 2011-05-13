unit UXXXForm_GeneralConfiguration;

interface

uses
  	Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  	Dialogs, StdCtrls, Buttons, ExtCtrls, UXXXForm_DialogTemplate, ActnList,
  	ComCtrls, CFEdit, CheckLst;

type
	TXXXForm_GeneralConfigurationClass = class of TXXXForm_GeneralConfiguration;
    
    TXXXForm_GeneralConfiguration = class(TXXXForm_DialogTemplate)
    	BitBtn_Ok: TBitBtn;
    	BitBtn_Cancel: TBitBtn;
        PageControl_ConfigurationCategories: TPageControl;
        TabSheet_DataBaseOptions: TTabSheet;
        TabSheet_LoginOptions: TTabSheet;
        LabelProtocolo: TLabel;
        LabelEnderecoDoHost: TLabel;
        LabelPorta: TLabel;
        LabelBancoDeDados: TLabel;
        LabelNomeDeUsuario: TLabel;
        LabelSenha: TLabel;
        EditEnderecoDoHost: TEdit;
        EditPorta: TEdit;
        EditBancoDeDados: TEdit;
        EditNomeDeUsuario: TEdit;
        EditSenha: TEdit;
        ComboBoxProtocolo: TComboBox;
    	TabSheet_OtherOptions: TTabSheet;
        CFEdit_UserTableName: TCFEdit;
        CFEdit_KeyFieldName: TCFEdit;
        CFEdit_RealNameFieldName: TCFEdit;
        CFEdit_UserNameFieldName: TCFEdit;
        CFEdit_PasswordFieldName: TCFEdit;
        Label_UserTableName: TLabel;
        Label_KeyFieldName: TLabel;
        Label_RealNameFieldName: TLabel;
        Label_UserNameFieldName: TLabel;
        Label_PasswordFieldName: TLabel;
        ComboBoxIsolationLevel: TComboBox;
        LabelIsolationLevel: TLabel;
    	PageControl_OtherOptions: TPageControl;
	    TabSheet_GeneralBehaviour: TTabSheet;
	    ComboBox_PasswordCipherAlgorithm: TComboBox;
    	TabSheet_PermissionOptions: TTabSheet;
    	CheckBox_UseBalloons: TCheckBox;
    	Label_EnterToTab: TLabel;
    	CheckListBox_EnterToTab: TCheckListBox;
    	CheckBox_ExpandedLoginDialog: TCheckBox;
    	Label_PasswordCipherAlgorithm: TLabel;
    	Label1: TLabel;
        CFEdit_EmailFieldName: TCFEdit;
        Label_EmailFieldName: TLabel;
    CheckBox_UseENTERToSearch: TCheckBox;
        procedure FormCreate(Sender: TObject);
    private
    	{ Private declarations }
    protected
    	{ Protected declarations }
    public
	    { Public declarations }
//        constructor Create(aOwner: TComponent; var aMyReference: TXXXForm_GeneralConfiguration); reintroduce;
    end;

implementation

uses
	UXXXTypesConstantsAndClasses;

{$R *.dfm}

{ TForm_GeneralConfiguration }

//constructor TXXXForm_GeneralConfiguration.Create(aOwner: TComponent; var aMyReference: TXXXForm_GeneralConfiguration);
//var
//    Dummy: TDialogCreateParameters;
//begin
//	ZeroMemory(@Dummy,SizeOf(TDialogCreateParameters));
//	inherited Create(aOwner, TXXXForm_DialogTemplate(aMyReference),Dummy);
//end;

procedure TXXXForm_GeneralConfiguration.FormCreate(Sender: TObject);
var
	i: THashAlgorithm;
begin
  	inherited;
    ComboBox_PasswordCipherAlgorithm.Clear;
        
    for i := Low(THashAlgorithm) to High(THashAlgorithm) do
    	ComboBox_PasswordCipherAlgorithm.Items.Add(String(HASH_ALGORITHMS[i]));
end;

end.

//    UserTableTableName := APPLICATION_USERTABLE_TABLENAME;
//    UserTableKeyFieldName := APPLICATION_USERTABLE_KEYFIELDNAME;
//    UserTableRealNameFieldName := APPLICATION_USERTABLE_REALNAMEFIELDNAME;
//    UserTableUserNameFieldName := APPLICATION_USERTABLE_USERNAMEFIELDNAME;
//    UserTablePasswordFieldName := APPLICATION_USERTABLE_PASSWORDFIELDNAME;

