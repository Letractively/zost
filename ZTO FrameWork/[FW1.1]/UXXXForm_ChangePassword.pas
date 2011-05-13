unit UXXXForm_ChangePassword;
{ TODO : Neste form, DataModule = MainDataModule, devido a forma como esta tela
está sendo criada. Veja UForm_MainTabbedTemplate }
interface

uses
  	Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  	Dialogs, UXXXForm_DialogTemplate, StdCtrls, ActnList, ExtCtrls, Buttons, _StdCtrls;

type
  	TXXXForm_ChangePassword = class(TXXXForm_DialogTemplate)
    	Label1: TLabel;
	    Label_LoggedUser: TLabel;
    	Label6: TLabel;
        Label_Login: TLabel;
        Bevel1: TBevel;
        Label3: TLabel;
        Label7: TLabel;
        Edit_CurrentPassword: TEdit;
        Label4: TLabel;
        Label8: TLabel;
        Edit_NewPassword: TEdit;
        Label5: TLabel;
        Label9: TLabel;
        Edit_ConfirmPassword: TEdit;
        Label2: TLabel;
    	BitBtn_ChangePassword: TBitBtn;
    	BitBtn_Cancel: TBitBtn;
        procedure FormShow(Sender: TObject);
    	procedure BitBtn_ChangePasswordClick(Sender: TObject);
  	private
    	{ Private declarations }
  	public
    	{ Public declarations }
  	end;

implementation

uses
	UXXXDataModule, UXXXTypesConstantsAndClasses,

    ZAbstractRODataset, ZAbstractDataset, ZDataset;

{$R *.dfm}

procedure TXXXForm_ChangePassword.BitBtn_ChangePasswordClick(Sender: TObject);
var
  	NewPassword, CurrentPassword: AnsiString;
  	AuthenticatedUser: TAuthenticatedUser;
    USERS: TZReadOnlyQuery;
begin
  	inherited;
  	AuthenticatedUser := CreateParameters.Configurations.AuthenticatedUser;
    try
	    USERS := nil;
        CreateParameters.MyDataModule.DataModuleMain.ConfigureDataSet(CreateParameters.MyDataModule.DataModuleMain.ZConnections[0].Connection
                                                    ,USERS
                                                    ,AnsiString(Format(SQL_SELECT_LOGIN
                                                           ,[CreateParameters.Configurations.UserTableKeyFieldName
                                                            ,CreateParameters.Configurations.UserTableRealNameFieldName
                                                            ,CreateParameters.Configurations.UserTableUserNameFieldName
                                                            ,CreateParameters.Configurations.UserTablePasswordFieldName
                                                            ,CreateParameters.Configurations.UserTableTableName
                                                            ]
                                                           )
                                                     ));


		if USERS.Locate(String(CreateParameters.Configurations.UserTableKeyFieldName),AuthenticatedUser.Id,[]) then
        begin
            if Edit_CurrentPassword.Text <> '' then
            begin
                CurrentPassword := TXXXDataModule.GetStringCheckSum(AnsiString(Edit_CurrentPassword.Text),[CreateParameters.Configurations.PasswordCipherAlgorithm]);
                if CurrentPassword = AuthenticatedUser.Password then
                begin
                    if (Edit_NewPassword.Text <> '') and (Edit_ConfirmPassword.Text <> '') then
                    begin
                        if CompareStr(Edit_NewPassword.Text, Edit_ConfirmPassword.Text) = 0 then
                        begin
                            (* Apenas aqui todos os requisitos foram satisfeitos e a
                            nova senha será salva no registro do usuário e também na
                            viariavel de seção (AuthenticatedUser) *)
                            NewPassword := TXXXDataModule.GetStringCheckSum(AnsiString(Edit_ConfirmPassword.Text),[CreateParameters.Configurations.PasswordCipherAlgorithm]);
                            CreateParameters.MyDataModule.DataModuleMain.ExecuteQuery(CreateParameters.MyDataModule.DataModuleMain.ZConnections[0].Connection
                                                                      ,AnsiString(Format(SQL_UPDATE_PASSWORD
                                                                             ,[CreateParameters.Configurations.UserTableTableName
                                                                              ,CreateParameters.Configurations.UserTablePasswordFieldName
                                                                              ,QuotedStr(String(NewPassword))
                                                                              ,CreateParameters.Configurations.UserTableKeyFieldName
                                                                              ,AuthenticatedUser.Id
                                                                              ]
                                                                             )
                                                                      ));
                            AuthenticatedUser.Password := NewPassword;
                            CreateParameters.Configurations.AuthenticatedUser := AuthenticatedUser;
                            MessageBox(Handle,'Sua senha foi alterada com sucesso. Anote-a num lugar seguro!','Senha alterada com sucesso',MB_ICONINFORMATION);
                            ModalResult := mrOk;
                        end
                        else
                        begin
                            MessageBox(Handle,'Os campos "Nova senha" e "Confirmar nova senha" foram preenchidos com valores diferentes, favor corrigir.','Preenchimento incorreto',MB_ICONERROR);
                            Edit_NewPassword.SetFocus;
                        end;
                    end
                    else
                    begin
                        MessageBox(Handle,'Os campos "Nova senha" e "Confirmar nova senha" devem ser ambos preenchidos com o mesmo valor','Preenchimento requerido',MB_ICONERROR);
                        Edit_NewPassword.SetFocus;
                    end;
                end
                else
                begin
                    MessageBox(Handle,'A senha digitada está incorreta, por favor corrija','Senha incorreta',MB_ICONERROR);
                    Edit_CurrentPassword.SetFocus;
                end;
            end
            else
            begin
                MessageBox(Handle,'Digite sua senha no campo nomeado "Senha atual".','Senha atual não digitada',MB_ICONERROR);
                Edit_CurrentPassword.SetFocus;
            end;
        end
        else
        begin
            ZeroMemory(@CreateParameters.Configurations.AuthenticatedUser,SizeOf(TAuthenticatedUser));
            MessageBox(Handle,'O usuário atual não foi localizado. Portanto não deve haver privilégio algum para ele. Clique "OK" para efetuar logout','Usuário inexistente',MB_ICONERROR);
            CreateParameters.MyDataModule.DataModuleMain.ApplySecurityPolicies(CreateParameters.MyDataModule.DataModuleMain.ZConnections[0].Connection);
            ModalResult := mrOk;
        end;
        
    finally
        if Assigned(USERS) then
            USERS.Free;
    end;
end;

procedure TXXXForm_ChangePassword.FormShow(Sender: TObject);
begin
  inherited;
  Label_LoggedUser.Caption := String(CreateParameters.Configurations.AuthenticatedUser.RealName);
  Label_Login.Caption := String(CreateParameters.Configurations.AuthenticatedUser.Login);
end;

end.
