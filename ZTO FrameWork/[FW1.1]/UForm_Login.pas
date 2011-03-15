unit UForm_Login;

interface

uses
	{ VCL }
    Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
    Dialogs, StdCtrls, Buttons, ExtCtrls, DBCtrls, Grids, DB, ActnList,
    { FRAMEWORK }
    UXXXDataModule, UXXXTypesConstantsAndClasses, UXXXForm_DialogTemplate,
    { COMPONENTES }
    ZConnection, ZDataset, UCFDBGrid, CFEdit, DBGrids;

type
    TXXXForm_Login = class(TXXXForm_DialogTemplate)
	    Label2: TLabel;
    	EditLogin: TCFEdit;
	    DBGridUsuarios: TCFDBGrid;
    	Label3: TLabel;
	    DBTextNomeDoUsuario: TDBText;
    	Label4: TLabel;
	    EditSenha: TCFEdit;
    	BitBtn_Cancel: TBitBtn;
    	BitBtn_Ok: TBitBtn;
    	procedure FormShow(Sender: TObject);
    	procedure FormCreate(Sender: TObject);
	    procedure EditLoginChange(Sender: TObject);
	    procedure DBGridUsuariosEnter(Sender: TObject);
    	procedure BitBtn_OkClick(Sender: TObject);
    	procedure FormClose(Sender: TObject; var Action: TCloseAction);
    private
	    { Private declarations }
        FDataSource_Login: TDataSource;
        FExpandedMode: Boolean;
        FTentativas: Byte;
    	procedure DoDataChange(Sender: TObject; Field: TField);
    public
    	{ Public declarations }
        constructor Create(aOwner: TComponent; var aReference; aConfigurations: TXXXConfigurations); reintroduce;
        destructor Destroy; override;

        property LoginDataSource: TDataSource read FDataSource_Login write FDataSource_Login;
        property ExpandedMode: Boolean write FExpandedMode;
    end;

implementation

{$R *.dfm}

procedure TXXXForm_Login.BitBtn_OkClick(Sender: TObject);
var
	SenhaExistente, SenhaDigitada: ShortString;
begin
	inherited;
    {$IFDEF DEVELOPING}
    EditSenha.Text := '111';
    {$ENDIF}
    
	if EditLogin.Text = '' then
	begin
        if FExpandedMode then
             MessageBox(Handle,'Por favor digite seu login ou selecion-o na lista','Informe seu login',MB_ICONERROR)
        else
        	MessageBox(Handle,'Por favor digite seu login','Informe seu login',MB_ICONERROR);

		EditLogin.SetFocus;
		Exit;
	end;

    if EditSenha.Text = '' then
    begin
    	MessageBox(Handle,'Por favor digite uma senha no campo "Senha"','Digite uma senha',MB_ICONERROR);
        EditSenha.SetFocus;
        Exit;
    end;

    { TODO -cOTIMIZA��O : Isso deve ser mudando para fazer uma consulta no banco
    quando estiver no modo normal a fim de diminuir a banda usada pela consulta
    inicial (modo expandido) que traz todos os usu�rios }

    { In�cio da valida��o}

    { Caso estejamos no modo normal (n�o expandido) devemos fazer uma busca no
    DataSet pelo login }
    if not FExpandedMode and not FDataSource_Login.DataSet.Locate(CreateParameters.Configurations.UserTableUserNameFieldName,EditLogin.Text,[]) then
	begin
    	Inc(FTentativas);
		if FTentativas < 3 then
        begin
        	MessageBox(Handle,'Usu�rio inexistente ou inativo',PChar('Usu�rio inv�lido (' + IntToStr(FTentativas) + '� tentativa de 3 poss�veis)'),MB_ICONERROR);
			EditLogin.SelectAll;
			EditLogin.SetFocus;
		end
    	else
    	begin
        	MessageBox(Handle,'Usu�rio inexistente ou inativo. A aplica��o ser� fechada.','Login mal sucedido',MB_ICONERROR);
			ModalResult := mrCancel;
	    end;
        Exit;
	end;

	SenhaExistente := UpperCase(FDataSource_Login.DataSet.FieldByName(CreateParameters.Configurations.UserTablePasswordFieldName).AsString);
	SenhaDigitada := TXXXDataModule.GetStringCheckSum(EditSenha.Text,[CreateParameters.Configurations.PasswordCipherAlgorithm]);
    {$IFDEF DEVELOPING}
    SenhaDigitada := SenhaExistente;
    {$ENDIF}

	if SenhaExistente = SenhaDigitada then
	begin
        with CreateParameters.Configurations.AuthenticatedUser do
        begin
			Id := FDataSource_Login.DataSet.FieldByName(CreateParameters.Configurations.UserTableKeyFieldName).AsInteger;
			RealName := FDataSource_Login.DataSet.FieldByName(CreateParameters.Configurations.UserTableRealNameFieldName).AsString;
			Login := FDataSource_Login.DataSet.FieldByName(CreateParameters.Configurations.UserTableUserNameFieldName).AsString;
			Password := SenhaExistente;
    	end;

    	{ Guardando nas configura��es o usu�rio que conseguiu se logar }
		CreateParameters.Configurations.LastAuthenticatedUser := CreateParameters.Configurations.AuthenticatedUser.Id;

        { Aqui um log � salvo com a a��o, mas n�o sei se isso ser� necess�rio, e
        se for,  provavelmente  dever� ser  implementado como shared pois todo o
        sistema dever� usar tamb�m }
		// ModuloDeDados.SalvarAcoesDoUsuario(Format(rs_loginbemsucedido,[UsuarioLogado.Nome]),ModuloDeDados.ObterEntidade('USUARIOS',0),UsuarioLogado.Id);

    	ModalResult := mrOk;
	end
  	else
	begin
    	Inc(FTentativas);
		if FTentativas < 3 then
        begin
			MessageBox(Handle,'A senha digitada � incorreta. Tente novamente',PChar('Senha incorreta ('+ IntToStr(FTentativas) +'� tentativa de 3 poss�veis)'),MB_ICONERROR);
			EditSenha.SelectAll;
			EditSenha.SetFocus;
            { Novamente um log  seria salvo  aqui.  Diferentemente  do anterior,
            este log � externo em arquivo.  Quem sabe a implementa��o  de um log
            externo (sem participa��o do banco de dados) seja a solu��o? }
			// FPrincipal.SalvarLog(Format(rs_loginmalsucedido,[DBTextNomeDoUsuario.Caption]));
		end
    	else
    	begin
        	MessageBox(Handle,'A senha digitada � incorreta. A aplica��o ser� fechada.','Login mal sucedido',MB_ICONERROR);
			// MessageBox(Handle,'A senha digitada � incorreta. A aplica��o ser� fechada. Foi criado um log com todas as tentativas','Login mal sucedido',MB_ICONERROR);
            // FPrincipal.SalvarLog(Format(rs_loginmalsucedido,[DBTextNomeDoUsuario.Caption]));
			ModalResult := mrCancel;
	    end;
	end;
end;

constructor TXXXForm_Login.Create(aOwner: TComponent; var aReference; aConfigurations: TXXXConfigurations);
var
    DialogCreateParameters: TDialogCreateParameters;
begin
	ZeroMemory(@DialogCreateParameters,SizeOf(TDialogCreateParameters));
    with DialogCreateParameters do
    begin
        Configurations := aConfigurations;
        AutoFree := False;
    end;
	inherited Create(aOwner,aReference,DialogCreateParameters);
    FDataSource_Login := TDataSource.Create(Self);
end;

destructor TXXXForm_Login.Destroy;
begin
	FreeAndNil(FDataSource_Login);
	inherited;
end;

procedure TXXXForm_Login.DBGridUsuariosEnter(Sender: TObject);
begin
	inherited;
    TCFDBGrid(Sender).Options := TCFDBGrid(Sender).Options + [dgAlwaysShowSelection];
	EditLogin.Text := FDataSource_Login.DataSet.FieldByName(CreateParameters.Configurations.UserTableUserNameFieldName).AsString;
end;

procedure TXXXForm_Login.EditLoginChange(Sender: TObject);
begin
  	inherited;
    if FExpandedMode then
    begin
	    DBGridUsuarios.Options := DBGridUsuarios.Options - [dgAlwaysShowSelection];
  		if FDataSource_Login.DataSet.Locate(CreateParameters.Configurations.UserTableUserNameFieldName,EditLogin.Text,[]) then
    		DBGridUsuarios.Options := DBGridUsuarios.Options + [dgAlwaysShowSelection];
    end;
end;

procedure TXXXForm_Login.FormClose(Sender: TObject; var Action: TCloseAction);
begin
//  inherited;

end;

procedure TXXXForm_Login.FormCreate(Sender: TObject);
begin
	inherited;
	FTentativas := 0;
    Caption := Application.Title + ' - Login';
	SetClassLong(Handle,GCL_STYLE,GetClassLong(Handle,GCL_STYLE) or CS_DROPSHADOW);
end;

procedure TXXXForm_Login.FormShow(Sender: TObject);
begin
	inherited;
    if not FExpandedMode then
    begin
        Height := Constraints.MinHeight;
        Label2.Caption := 'Login:';

		DBGridUsuarios.Hide;
		Label3.Hide;
		DBTextNomeDoUsuario.Hide;
    end
    else
    begin
        Label2.Caption := 'Digite seu login completo ou selecione-o na lista abaixo:';

        with CreateParameters.Configurations do
        begin
            if LastAuthenticatedUser <> 0 then
            begin
                FDataSource_Login.DataSet.Locate(UserTableKeyFieldName,LastAuthenticatedUser,[]);
                EditLogin.Text := FDataSource_Login.DataSet.FieldByName(UserTableUserNameFieldName).AsString;
                EditSenha.SetFocus;
            end;

            { Configurando o DBGrid }
            with DBGridUsuarios.Columns.Add do
            begin
                FieldName := UserTableUserNameFieldName;
                Alignment := taCenter;
                Title.Caption := 'Nomes de usu�rio';
                Title.Alignment := taCenter;
//                WidthMode := wmVariable;
            end;

            DBGridUsuarios.VariableWidthColumns := '<' + UserTableUserNameFieldName + '>';

            DBGridUsuarios.DataSource := FDataSource_Login;

            { Configurando o DBText }
            DBTextNomeDoUsuario.DataSource := FDataSource_Login;
            DBTextNomeDoUsuario.DataField := UserTableRealNameFieldName;

            { Definindo um manipulador para o evendo DataChange do DataSource }
            FDataSource_Login.OnDataChange := DoDataChange;

        end;
    end;
end;

procedure TXXXForm_Login.DoDataChange(Sender: TObject; Field: TField);
begin
	inherited;
	EditLogin.Text := TDataSource(Sender).DataSet.FieldByName(CreateParameters.Configurations.UserTableUserNameFieldName).AsString;
	{$IFDEF DEVELOPING}
	//EditSenha.Text := DCR_Password.SingleEncryptDecrypt(FSharedConfigurations.MasterPassword,TDataSource(Sender).DataSet.FieldByName(FSharedConfigurations.UserTablePasswordFieldName).AsString,dcDecriptar);
  {$ENDIF}
end;

end.
