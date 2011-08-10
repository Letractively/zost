unit UForm_Principal;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ComCtrls, StdCtrls, ZConnection, DB, DBTables, ExtCtrls, UConfiguracoes;

type
  TModoAplicacao = (acNoObjeto,acDoObjeto);

  TForm_Principal = class(TForm)
    PageControl_Principal: TPageControl;
    TabSheet_Status: TTabSheet;
    TabSheet_Configuracao: TTabSheet;
    GroupBox_Zeos: TGroupBox;
    GroupBox_BDE: TGroupBox;
    ZeosLibConnection: TZConnection;
    Button_VerificarBDE: TButton;
    Button_VerificarZeos: TButton;
    BDEConnection: TDatabase;
    Panel_LayerZeosLib: TPanel;
    Panel_LayerBDE: TPanel;
    GroupBox_ZeosLibSybase: TGroupBox;
    GroupBox_ZeosLibOracle: TGroupBox;
    GroupBox_BDEOracle: TGroupBox;
    GroupBox_BDESybase: TGroupBox;
    Image1: TImage;
    Image2: TImage;
    Image3: TImage;
    Image4: TImage;
    Image5: TImage;
    Image6: TImage;
    Image7: TImage;
    Image8: TImage;
    Image9: TImage;
    Image10: TImage;
    Image11: TImage;
    Image12: TImage;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    Label6: TLabel;
    Label7: TLabel;
    Label8: TLabel;
    Label9: TLabel;
    Label10: TLabel;
    Label11: TLabel;
    Label12: TLabel;
    Memo1: TMemo;
    GroupBox_OracleConfig: TGroupBox;
    GroupBox_SybaseConfig: TGroupBox;
    LabeledEdit_UsuarioDesenvOracle: TLabeledEdit;
    LabeledEdit_SenhaDesenvOracle: TLabeledEdit;
    LabeledEdit_TNSDesenvOracle: TLabeledEdit;
    LabeledEdit_DatabaseDesenvOracle: TLabeledEdit;
    LabeledEdit_UsuarioHomologOracle: TLabeledEdit;
    LabeledEdit_SenhaHomologOracle: TLabeledEdit;
    LabeledEdit_TNSHomologOracle: TLabeledEdit;
    LabeledEdit_DatabaseHomologOracle: TLabeledEdit;
    LabeledEdit_UsuarioProducaoOracle: TLabeledEdit;
    LabeledEdit_SenhaProducaoOracle: TLabeledEdit;
    LabeledEdit_TNSProducaoOracle: TLabeledEdit;
    LabeledEdit_DatabaseProducaoOracle: TLabeledEdit;
    LabeledEdit_UsuarioDesenvSybase: TLabeledEdit;
    LabeledEdit_SenhaDesenvSybase: TLabeledEdit;
    LabeledEdit_ServerNameDesenvSybase: TLabeledEdit;
    LabeledEdit_DatabaseDesenvSybase: TLabeledEdit;
    LabeledEdit_UsuarioHomologSybase: TLabeledEdit;
    LabeledEdit_SenhaHomologSybase: TLabeledEdit;
    LabeledEdit_ServerNameHomologSybase: TLabeledEdit;
    LabeledEdit_DatabaseHomologSybase: TLabeledEdit;
    LabeledEdit_UsuarioProdSybase: TLabeledEdit;
    LabeledEdit_SenhaProdSybase: TLabeledEdit;
    LabeledEdit_ServerNameProdSybase: TLabeledEdit;
    LabeledEdit_DatabaseProdSybase: TLabeledEdit;
    procedure TabSheet_StatusShow(Sender: TObject);
    procedure Button_VerificarBDEClick(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure Button_VerificarZeosClick(Sender: TObject);
  private
    { Private declarations }
    FImagens: array [0..3] of TImage;
    FConfiguracoes: TConfiguracoes;
    FArquivoConfiguracoes: TFileName;
    procedure ExecutaTestesZeosLib;
    procedure ExecutaTestesBDE;
    procedure StatusOK(aImage: TImage; aStatusID: String);
    procedure StatusNAOOK(aImage: TImage; aStatusID: String);
    procedure ImagemNAOTESTADO(aImage: TImage; aStatusID: String);
    procedure StatusTESTANDO(aImage: TImage; aStatusID: String);
    procedure AplicarConfiguracoes(aModoAplicacao: TModoAplicacao);
  public
    { Public declarations }
  end;

var
  Form_Principal: TForm_Principal;

implementation

{$R *.dfm}

{ Eu poderia ter resolvido todos os problemas com apenas um componente
ZConnection e um Database, mas coloquei um para cada instância a ser testada
porque não quis ter trabalho de reconfigurar componentes em runtime }

procedure TForm_Principal.Button_VerificarBDEClick(Sender: TObject);
begin
  ExecutaTestesBDE;
end;

procedure TForm_Principal.Button_VerificarZeosClick(Sender: TObject);
begin
  ExecutaTestesZeosLib;
end;

procedure TForm_Principal.ExecutaTestesBDE;
begin
  try
    Button_VerificarBDE.Enabled := False;
    Button_VerificarBDE.Update;

    ImagemNAOTESTADO(Image7,'');
    ImagemNAOTESTADO(Image8,'');
    ImagemNAOTESTADO(Image9,'');
    ImagemNAOTESTADO(Image10,'');
    ImagemNAOTESTADO(Image11,'');
    ImagemNAOTESTADO(Image12,'');

    Memo1.Clear;
    Memo1.Update;
    { oracle / desenvolvimento }
    try
      StatusTESTANDO(Image7,'BDE/ORACLE/DESENV: Testando...');
      with BDEConnection do
      begin
        Connected := False;
        DriverName := 'ORACLE';
        Params.Clear;
        Params.Add('SERVER NAME=' + TOracleOption(FConfiguracoes.OracleOptions.Items[0]).TNS);
        Params.Add('USER NAME=' + TOracleOption(FConfiguracoes.OracleOptions.Items[0]).Usuario);
        Params.Add('PASSWORD=' + TOracleOption(FConfiguracoes.OracleOptions.Items[0]).Senha);
        DatabaseName := TOracleOption(FConfiguracoes.OracleOptions.Items[0]).Database;
        Connected := True;
      end;
      StatusOK(Image7,'BDE/ORACLE/DESENV: Conexão estabelecida com sucesso!'#13#10'---------------------------------------------------------');
    except
      on E: Exception do
        StatusNAOOK(Image7,'BDE/ORACLE/DESENV: ' + E.Message + #13#10'---------------------------------------------------------');
    end;
    { oracle / homologação }
    try
      StatusTESTANDO(Image8,'BDE/ORACLE/HOMOL: Testando...');
      with BDEConnection do
      begin
        Connected := False;
        DriverName := 'ORACLE';
        Params.Clear;
        Params.Add('SERVER NAME=' + TOracleOption(FConfiguracoes.OracleOptions.Items[1]).TNS);
        Params.Add('USER NAME=' + TOracleOption(FConfiguracoes.OracleOptions.Items[1]).Usuario);
        Params.Add('PASSWORD=' + TOracleOption(FConfiguracoes.OracleOptions.Items[1]).Senha);
        DatabaseName := TOracleOption(FConfiguracoes.OracleOptions.Items[1]).Database;
        Connected := True;
      end;
      StatusOK(Image8,'BDE/ORACLE/HOMOL: Conexão estabelecida com sucesso!'#13#10'---------------------------------------------------------');
    except
      on E: Exception do
        StatusNAOOK(Image8,'BDE/ORACLE/HOMOL: ' + E.Message + #13#10'---------------------------------------------------------');
    end;
    { oracle / produção }
    try
      StatusTESTANDO(Image9,'BDE/ORACLE/PROD: Testando...');
      with BDEConnection do
      begin
        Connected := False;
        DriverName := 'ORACLE';
        Params.Clear;
        Params.Add('SERVER NAME=' + TOracleOption(FConfiguracoes.OracleOptions.Items[2]).TNS);
        Params.Add('USER NAME=' + TOracleOption(FConfiguracoes.OracleOptions.Items[2]).Usuario);
        Params.Add('PASSWORD=' + TOracleOption(FConfiguracoes.OracleOptions.Items[2]).Senha);
        DatabaseName := TOracleOption(FConfiguracoes.OracleOptions.Items[2]).Database;
        Connected := True;
      end;
      StatusOK(Image9,'BDE/ORACLE/PROD: Conexão estabelecida com sucesso!'#13#10'---------------------------------------------------------');
    except
      on E: Exception do
        StatusNAOOK(Image9,'BDE/ORACLE/PROD: ' + E.Message + #13#10'---------------------------------------------------------');
    end;
    { ------------------------------------------------------------------------ }
    { Sybase / desenvolvimento }
    try
      StatusTESTANDO(Image10,'BDE/SYBASE/DESENV: Testando...');
      with BDEConnection do
      begin
        Connected := False;
        DriverName := 'SYBASE';
        Params.Clear;
        Params.Add('DATABASE NAME=' + TSybaseOption(FConfiguracoes.SybaseOptions.Items[0]).Database);
        Params.Add('SERVER NAME=' + TSybaseOption(FConfiguracoes.SybaseOptions.Items[0]).ServerName);
        Params.Add('USER NAME=' + TSybaseOption(FConfiguracoes.SybaseOptions.Items[0]).Usuario);
        Params.Add('PASSWORD=' + TSybaseOption(FConfiguracoes.SybaseOptions.Items[0]).Senha);
        DatabaseName := TSybaseOption(FConfiguracoes.SybaseOptions.Items[0]).Database;
        Connected := True;
      end;
      StatusOK(Image10,'BDE/SYBASE/DESENV: Conexão estabelecida com sucesso!'#13#10'---------------------------------------------------------');
    except
      on E: Exception do
        StatusNAOOK(Image10,'ZEOSLIB/SYBASE/DESENV: ' + E.Message + #13#10'---------------------------------------------------------');
    end;
    { Sybase / homologação }
    try
      StatusTESTANDO(Image11,'BDE/SYBASE/HOMOL: Testando...');
      with BDEConnection do
      begin
        Connected := False;
        DriverName := 'SYBASE';
        Params.Clear;
        Params.Add('DATABASE NAME=' + TSybaseOption(FConfiguracoes.SybaseOptions.Items[1]).Database);
        Params.Add('SERVER NAME=' + TSybaseOption(FConfiguracoes.SybaseOptions.Items[1]).ServerName);
        Params.Add('USER NAME=' + TSybaseOption(FConfiguracoes.SybaseOptions.Items[1]).Usuario);
        Params.Add('PASSWORD=' + TSybaseOption(FConfiguracoes.SybaseOptions.Items[1]).Senha);
        DatabaseName := TSybaseOption(FConfiguracoes.SybaseOptions.Items[1]).Database;
        Connected := True;
      end;
      StatusOK(Image11,'BDE/SYBASE/HOMOL: Conexão estabelecida com sucesso!'#13#10'---------------------------------------------------------');
    except
      on E: Exception do
        StatusNAOOK(Image11,'BDE/SYBASE/HOMOL: ' + E.Message + #13#10'---------------------------------------------------------');
    end;
    { Sybase / produção }
    try
      StatusTESTANDO(Image12,'BDE/SYBASE/PROD: Testando...');
      with BDEConnection do
      begin
        Connected := False;
        DriverName := 'SYBASE';
        Params.Clear;
        Params.Add('DATABASE NAME=' + TSybaseOption(FConfiguracoes.SybaseOptions.Items[2]).Database);
        Params.Add('SERVER NAME=' + TSybaseOption(FConfiguracoes.SybaseOptions.Items[2]).ServerName);
        Params.Add('USER NAME=' + TSybaseOption(FConfiguracoes.SybaseOptions.Items[2]).Usuario);
        Params.Add('PASSWORD=' + TSybaseOption(FConfiguracoes.SybaseOptions.Items[2]).Senha);
        DatabaseName := TSybaseOption(FConfiguracoes.SybaseOptions.Items[2]).Database;
        Connected := True;
      end;
      StatusOK(Image12,'BDE/SYBASE/PROD: Conexão estabelecida com sucesso!'#13#10'---------------------------------------------------------');
    except
      on E: Exception do
        StatusNAOOK(Image12,'BDE/SYBASE/PROD: ' + E.Message + #13#10'---------------------------------------------------------');
    end;
  finally
    Button_VerificarBDE.Enabled := True;
  end;
end;

procedure TForm_Principal.ExecutaTestesZeosLib;
begin
  try
    Button_VerificarZeos.Enabled := False;
    Button_VerificarZeos.Update;

    ImagemNAOTESTADO(Image1,'');
    ImagemNAOTESTADO(Image2,'');
    ImagemNAOTESTADO(Image3,'');
    ImagemNAOTESTADO(Image4,'');
    ImagemNAOTESTADO(Image5,'');
    ImagemNAOTESTADO(Image6,'');

    Memo1.Clear;
    Memo1.Update;
    { oracle / desenvolvimento }
    try
      StatusTESTANDO(Image1,'ZEOSLIB/ORACLE/DESENV: Testando...');
      with ZeosLibConnection do
      begin
        Disconnect;
        Protocol := 'oracle';
        Database := TOracleOption(FConfiguracoes.OracleOptions.Items[0]).TNS;
        User := TOracleOption(FConfiguracoes.OracleOptions.Items[0]).Usuario;
        Password := TOracleOption(FConfiguracoes.OracleOptions.Items[0]).Senha;
        Connect;
      end;
      StatusOK(Image1,'ZEOSLIB/ORACLE/DESENV: Conexão estabelecida com sucesso!'#13#10'---------------------------------------------------------');
    except
      on E: Exception do
        StatusNAOOK(Image1,'ZEOSLIB/ORACLE/DESENV:' + E.Message + #13#10'---------------------------------------------------------');
    end;
    { oracle / homologação }
    try
      StatusTESTANDO(Image2,'ZEOSLIB/ORACLE/HOMOL: Testando...');
      with ZeosLibConnection do
      begin
        Disconnect;
        Protocol := 'oracle';
        Database := TOracleOption(FConfiguracoes.OracleOptions.Items[1]).TNS;
        User := TOracleOption(FConfiguracoes.OracleOptions.Items[1]).Usuario;
        Password := TOracleOption(FConfiguracoes.OracleOptions.Items[1]).Senha;
        Connect;
      end;
      StatusOK(Image2,'ZEOSLIB/ORACLE/HOMOL: Conexão estabelecida com sucesso!'#13#10'---------------------------------------------------------');
    except
      on E: Exception do
        StatusNAOOK(Image2,'ZEOSLIB/ORACLE/HOMOL:' + E.Message + #13#10'---------------------------------------------------------');
    end;
    { oracle / produção }
    try
      StatusTESTANDO(Image3,'ZEOSLIB/ORACLE/PROD: Testando...');
      with ZeosLibConnection do
      begin
        Disconnect;
        Protocol := 'oracle';
        Database := TOracleOption(FConfiguracoes.OracleOptions.Items[2]).TNS;
        User := TOracleOption(FConfiguracoes.OracleOptions.Items[2]).Usuario;
        Password := TOracleOption(FConfiguracoes.OracleOptions.Items[2]).Senha;
        Connect;
      end;
      StatusOK(Image3,'ZEOSLIB/ORACLE/PROD: Conexão estabelecida com sucesso!'#13#10'---------------------------------------------------------');
    except
      on E: Exception do
        StatusNAOOK(Image3,'ZEOSLIB/ORACLE/PROD:' + E.Message + #13#10'---------------------------------------------------------');
    end;
    { ------------------------------------------------------------------------ }
    { Sybase / desenvolvimento }
    try
      StatusTESTANDO(Image4,'ZEOSLIB/SYBASE/DESENV: Testando...');
      with ZeosLibConnection do
      begin
        Disconnect;
        Protocol := 'sybase';
        Database := TSybaseOption(FConfiguracoes.SybaseOptions.Items[0]).Database;
        HostName := TSybaseOption(FConfiguracoes.SybaseOptions.Items[0]).ServerName;
        User := TSybaseOption(FConfiguracoes.SybaseOptions.Items[0]).Usuario;
        Password := TSybaseOption(FConfiguracoes.SybaseOptions.Items[0]).Senha;
        Connect;
      end;
      StatusOK(Image4,'ZEOSLIB/SYBASE/DESENV: Conexão estabelecida com sucesso!'#13#10'---------------------------------------------------------');
    except
      on E: Exception do
        StatusNAOOK(Image4,'ZEOSLIB/SYBASE/DESENV:' + E.Message + #13#10'---------------------------------------------------------');
    end;
    { Sybase / homologação }
    try
      StatusTESTANDO(Image5,'ZEOSLIB/SYBASE/HOMOL: Testando...');
      with ZeosLibConnection do
      begin
        Disconnect;
        Protocol := 'sybase';
        Database := TSybaseOption(FConfiguracoes.SybaseOptions.Items[1]).Database;
        HostName := TSybaseOption(FConfiguracoes.SybaseOptions.Items[1]).ServerName;
        User := TSybaseOption(FConfiguracoes.SybaseOptions.Items[1]).Usuario;
        Password := TSybaseOption(FConfiguracoes.SybaseOptions.Items[1]).Senha;
        Connect;
      end;
      StatusOK(Image5,'ZEOSLIB/SYBASE/HOMOL: Conexão estabelecida com sucesso!'#13#10'---------------------------------------------------------');
    except
      on E: Exception do
        StatusNAOOK(Image5,'ZEOSLIB/SYBASE/HOMOL:' + E.Message + #13#10'---------------------------------------------------------');
    end;
    { Sybase / produção }
    try
      StatusTESTANDO(Image6,'ZEOSLIB/SYBASE/PROD: Testando...');
      with ZeosLibConnection do
      begin
        Disconnect;
        Protocol := 'sybase';
        Database := TSybaseOption(FConfiguracoes.SybaseOptions.Items[2]).Database;
        HostName := TSybaseOption(FConfiguracoes.SybaseOptions.Items[2]).ServerName;
        User := TSybaseOption(FConfiguracoes.SybaseOptions.Items[2]).Usuario;
        Password := TSybaseOption(FConfiguracoes.SybaseOptions.Items[2]).Senha;
        Connect;
      end;
      StatusOK(Image6,'ZEOSLIB/SYBASE/PROD: Conexão estabelecida com sucesso!'#13#10'---------------------------------------------------------');
    except
      on E: Exception do
        StatusNAOOK(Image6,'ZEOSLIB/SYBASE/PROD:' + E.Message + #13#10'---------------------------------------------------------');
    end;
  finally
    Button_VerificarZeos.Enabled := True;
  end;
end;

procedure TForm_Principal.FormCreate(Sender: TObject);
begin
  FArquivoConfiguracoes := GetCurrentDir + '\' + ChangeFileExt(ExtractFileName(Application.ExeName),'.config');

  FImagens[0] := TImage.Create(Self);
  FImagens[1] := TImage.Create(Self);
  FImagens[2] := TImage.Create(Self);
  FImagens[3] := TImage.Create(Self);

  FImagens[0].Picture.Assign(Image1.Picture); // OK
  FImagens[1].Picture.Assign(Image2.Picture); // NAO OK
  FImagens[2].Picture.Assign(Image3.Picture); // NAO TESTADO
  FImagens[3].Picture.Assign(Image4.Picture); // TESTANDO

  ImagemNAOTESTADO(Image1,'');
  ImagemNAOTESTADO(Image2,'');
  ImagemNAOTESTADO(Image3,'');
  ImagemNAOTESTADO(Image4,'');
  ImagemNAOTESTADO(Image5,'');
  ImagemNAOTESTADO(Image6,'');
  ImagemNAOTESTADO(Image7,'');
  ImagemNAOTESTADO(Image8,'');
  ImagemNAOTESTADO(Image9,'');
  ImagemNAOTESTADO(Image10,'');
  ImagemNAOTESTADO(Image11,'');
  ImagemNAOTESTADO(Image12,'');

  FConfiguracoes := TConfiguracoes.Create(Self);
  FConfiguracoes.LoadFromBinaryFile(FArquivoConfiguracoes);
  AplicarConfiguracoes(acDoObjeto);
end;

procedure TForm_Principal.AplicarConfiguracoes(aModoAplicacao: TModoAplicacao);
begin
  case aModoAplicacao of
    acNoObjeto: begin
      FConfiguracoes.OracleOptions.Clear;
      FConfiguracoes.SybaseOptions.Clear;

      with TOracleOption(FConfiguracoes.OracleOptions.Add) do
      begin
        IDConexao := 'ORACLE.DESENV';
        Usuario := LabeledEdit_UsuarioDesenvOracle.Text;
        Senha := LabeledEdit_SenhaDesenvOracle.Text;
        TNS := LabeledEdit_TNSDesenvOracle.Text;
        DataBase := LabeledEdit_DatabaseDesenvOracle.Text;
      end;

      with TOracleOption(FConfiguracoes.OracleOptions.Add) do
      begin
        IDConexao := 'ORACLE.HOMOL';
        Usuario := LabeledEdit_UsuarioHomologOracle.Text;
        Senha := LabeledEdit_SenhaHomologOracle.Text;
        TNS := LabeledEdit_TNSHomologOracle.Text;
        DataBase := LabeledEdit_DatabaseHomologOracle.Text;
      end;

      with TOracleOption(FConfiguracoes.OracleOptions.Add) do
      begin
        IDConexao := 'ORACLE.PROD';
        Usuario := LabeledEdit_UsuarioProducaoOracle.Text;
        Senha := LabeledEdit_SenhaProducaoOracle.Text;
        TNS := LabeledEdit_TNSProducaoOracle.Text;
        DataBase := LabeledEdit_DatabaseProducaoOracle.Text;
      end;

      with TSybaseOption(FConfiguracoes.SybaseOptions.Add) do
      begin
        IDConexao := 'SYBASE.DESENV';
        Usuario := LabeledEdit_UsuarioDesenvSybase.Text;
        Senha := LabeledEdit_SenhaDesenvSybase.Text;
        ServerName := LabeledEdit_ServerNameDesenvSybase.Text;
        DataBase := LabeledEdit_DatabaseDesenvSybase.Text;
      end;

      with TSybaseOption(FConfiguracoes.SybaseOptions.Add) do
      begin
        IDConexao := 'SYBASE.HOMOL';
        Usuario := LabeledEdit_UsuarioHomologSybase.Text;
        Senha := LabeledEdit_SenhaHomologSybase.Text;
        ServerName := LabeledEdit_ServerNameHomologSybase.Text;
        DataBase := LabeledEdit_DatabaseHomologSybase.Text;
      end;

      with TSybaseOption(FConfiguracoes.SybaseOptions.Add) do
      begin
        IDConexao := 'SYBASE.PROD';
        Usuario := LabeledEdit_UsuarioProdSybase.Text;
        Senha := LabeledEdit_SenhaProdSybase.Text;
        ServerName := LabeledEdit_ServerNameProdSybase.Text;
        DataBase := LabeledEdit_DatabaseProdSybase.Text;
      end;
    end;
    acDoObjeto: begin
      if FConfiguracoes.OracleOptions.Count = 3 then
      begin
        with TOracleOption(FConfiguracoes.OracleOptions.Items[0]) do
        begin
          LabeledEdit_UsuarioDesenvOracle.Text := Usuario;
          LabeledEdit_SenhaDesenvOracle.Text := Senha;
          LabeledEdit_TNSDesenvOracle.Text := TNS;
          LabeledEdit_DatabaseDesenvOracle.Text := DataBase;
        end;

        with TOracleOption(FConfiguracoes.OracleOptions.Items[1]) do
        begin
          LabeledEdit_UsuarioHomologOracle.Text := Usuario;
          LabeledEdit_SenhaHomologOracle.Text := Senha;
          LabeledEdit_TNSHomologOracle.Text := TNS;
          LabeledEdit_DatabaseHomologOracle.Text := DataBase;
        end;

        with TOracleOption(FConfiguracoes.OracleOptions.Items[2]) do
        begin
          LabeledEdit_UsuarioProducaoOracle.Text := Usuario;
          LabeledEdit_SenhaProducaoOracle.Text := Senha;
          LabeledEdit_TNSProducaoOracle.Text := TNS;
          LabeledEdit_DatabaseProducaoOracle.Text := DataBase;
        end;
      end;

      if FConfiguracoes.SybaseOptions.Count = 3 then
      begin
        with TSybaseOption(FConfiguracoes.SybaseOptions.Items[0]) do
        begin
          LabeledEdit_UsuarioDesenvSybase.Text := Usuario;
          LabeledEdit_SenhaDesenvSybase.Text := Senha;
          LabeledEdit_ServerNameDesenvSybase.Text := ServerName;
          LabeledEdit_DatabaseDesenvSybase.Text := DataBase;
        end;

        with TSybaseOption(FConfiguracoes.SybaseOptions.Items[1]) do
        begin
          LabeledEdit_UsuarioHomologSybase.Text := Usuario;
          LabeledEdit_SenhaHomologSybase.Text := Senha;
          LabeledEdit_ServerNameHomologSybase.Text := ServerName;
          LabeledEdit_DatabaseHomologSybase.Text := DataBase;
        end;

        with TSybaseOption(FConfiguracoes.SybaseOptions.Items[2]) do
        begin
          LabeledEdit_UsuarioProdSybase.Text := Usuario;
          LabeledEdit_SenhaProdSybase.Text := Senha;
          LabeledEdit_ServerNameProdSybase.Text := ServerName;
          LabeledEdit_DatabaseProdSybase.Text := DataBase;
        end;
      end;
    end;
  end;
end;

procedure TForm_Principal.FormDestroy(Sender: TObject);
begin
  AplicarConfiguracoes(acNoObjeto);
  FConfiguracoes.SaveToBinaryFile(FArquivoConfiguracoes);
  FConfiguracoes.Free;

  FImagens[3].Free;
  FImagens[2].Free;
  FImagens[1].Free;
  FImagens[0].Free;
end;

procedure TForm_Principal.StatusNAOOK(aImage: TImage; aStatusID: String);
begin
  aImage.Picture.Assign(FImagens[1].Picture);
  aImage.Update;

  if aStatusID <> '' then
    Memo1.Lines.Add(aStatusID)
end;

procedure TForm_Principal.ImagemNAOTESTADO(aImage: TImage; aStatusID: String);
begin
  aImage.Picture.Assign(FImagens[2].Picture);
  aImage.Update;

  if aStatusID <> '' then
    Memo1.Lines.Add(aStatusID)
end;

procedure TForm_Principal.StatusOK(aImage: TImage; aStatusID: String);
begin
  aImage.Picture.Assign(FImagens[0].Picture);
  aImage.Update;

  if aStatusID <> '' then
    Memo1.Lines.Add(aStatusID)
end;

procedure TForm_Principal.StatusTESTANDO(aImage: TImage; aStatusID: String);
begin
  aImage.Picture.Assign(FImagens[3].Picture);
  aImage.Update;

  if aStatusID <> '' then
    Memo1.Lines.Add(aStatusID)
end;

procedure TForm_Principal.TabSheet_StatusShow(Sender: TObject);
begin
  AplicarConfiguracoes(acNoObjeto);
end;

end.
