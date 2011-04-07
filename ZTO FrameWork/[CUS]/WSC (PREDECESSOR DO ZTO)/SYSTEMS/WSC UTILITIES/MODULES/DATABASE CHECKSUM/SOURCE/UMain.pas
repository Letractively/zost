unit UMain;

{

NA CONSULTA A SEGUIR OS REGISTROS RETORNADOS SERÃO AQUELES QUE DIFEREM NO SERVIDOR E NO CLIENTE.
A FALHA NESTE MÉTODO É QUE COMO ESTAMOS AGRUPANDO PELA CHAVE (1), CASO DUAS CHAVES SEJAM
DIFERENTES EM REGISTROS COM OUTROS DADOS DISTINTOS ELES NÃO SERÃO RETORNADOS

SELECT * FROM (
SELECT LOC.IN_OBRAS_ID
     , LOC.TI_REGIOES_ID
     , LOC.VA_NOMEDAOBRA
     , LOC.VA_CIDADE
     , LOC.CH_ESTADO
     , LOC.TI_SITUACOES_ID
     , LOC.VA_PRAZODEENTREGA
     , LOC.TX_CONDICAODEPAGAMENTO
     , LOC.FL_ICMS
     , LOC.EN_FRETE
     , LOC.TX_CONDICOESGERAIS
     , LOC.TX_OBSERVACOES
     , LOC.VA_CONSTRUTORA
     , LOC.TI_TIPOS_ID
     , LOC.SM_PROJETISTAS_ID
     , LOC.DA_DATADEEXPIRACAO
  FROM BANCODEOBRAS1.OBRAS LOC
UNION
SELECT REM.IN_OBRAS_ID
     , REM.TI_REGIOES_ID
     , REM.VA_NOMEDAOBRA
     , REM.VA_CIDADE
     , REM.CH_ESTADO
     , REM.TI_SITUACOES_ID
     , REM.VA_PRAZODEENTREGA
     , REM.TX_CONDICAODEPAGAMENTO
     , REM.FL_ICMS
     , REM.EN_FRETE
     , REM.TX_CONDICOESGERAIS
     , REM.TX_OBSERVACOES
     , REM.VA_CONSTRUTORA
     , REM.TI_TIPOS_ID
     , REM.SM_PROJETISTAS_ID
     , REM.DA_DATADEEXPIRACAO
FROM BANCODEOBRAS_REMOTEDBG.OBRAS REM) t

GROUP BY 1 HAVING COUNT(*) > 1;

-----------

SELECT * FROM (
SELECT REM.IN_PROPOSTAS_ID
     , REM.IN_OBRAS_ID
     , REM.SM_CODIGO
     , REM.YR_ANO
     , REM.SM_INSTALADORES_ID
     , REM.VA_CONTATO
     , REM.BO_PROPOSTAPADRAO
     , REM.FL_DESCONTOPERC
     , REM.FL_DESCONTOVAL
     , REM.TI_MOEDA
     , REM.VA_COTACOES
     , REM.TI_VALIDADE
  FROM BANCODEOBRAS_2.PROPOSTAS REM
UNION
SELECT REM.IN_PROPOSTAS_ID
     , REM.IN_OBRAS_ID
     , REM.SM_CODIGO
     , REM.YR_ANO
     , REM.SM_INSTALADORES_ID
     , REM.VA_CONTATO
     , REM.BO_PROPOSTAPADRAO
     , REM.FL_DESCONTOPERC
     , REM.FL_DESCONTOVAL
     , REM.TI_MOEDA
     , REM.VA_COTACOES
     , REM.TI_VALIDADE
FROM BANCODEOBRAS_1.PROPOSTAS REM) t

GROUP BY 1 HAVING COUNT(*) > 1;


=================

A CONSULTA A SEGUIR PODERIA SER ACRESCIDA DE MAIS CONDIÇÕES NO WHERE PARA VERIFICAR DIFERENÇAS.

SELECT LOC.*
  FROM BANCODEOBRAS1.OBRAS LOC
  JOIN BANCODEOBRAS_REMOTEDBG.OBRAS REM USING (IN_OBRAS_ID)
WHERE LOC.DA_DATADEEXPIRACAO <> REM.DA_DATADEEXPIRACAO
UNION
SELECT REM.*
  FROM BANCODEOBRAS1.OBRAS LOC
  JOIN BANCODEOBRAS_REMOTEDBG.OBRAS REM USING (IN_OBRAS_ID)
WHERE LOC.DA_DATADEEXPIRACAO <> REM.DA_DATADEEXPIRACAO;

}

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, UWSCTypesConstantsAndClasses, ExtCtrls;

type
  TForm1 = class(TForm)
    Label_Customers: TLabel;
    ListBox_Customers: TListBox;
    GroupBox1: TGroupBox;
    LabeledEdit_BancoDeDados: TLabeledEdit;
    LabeledEdit_HostName: TLabeledEdit;
    LabeledEdit_Login: TLabeledEdit;
    LabeledEdit_Password: TLabeledEdit;
    Button_GetChecksum: TButton;
    LabeledEdit_Port: TLabeledEdit;
    LabeledEdit_Protocol: TLabeledEdit;
    Label1: TLabel;
    Memo1: TMemo;
    procedure FormCreate(Sender: TObject);
    procedure ListBox_CustomersClick(Sender: TObject);
    procedure Button_GetChecksumClick(Sender: TObject);
  private
    { Private declarations }
    SelectedWSCCustomer: TWSCCustomer;
    procedure GetChecksum;
    procedure DoGetChecksum(aTableName: String; aTableNo, aTableCount: Word; aTableChecksum: String; const aIgnored: Boolean);
  public
    { Public declarations }
  end;

var
  Form1: TForm1;

implementation

uses
    UXXXDataModule, ZConnection, ZDbcIntfs;

{$R *.dfm}

procedure TForm1.Button_GetChecksumClick(Sender: TObject);
begin
    if ListBox_Customers.ItemIndex = -1 then
    begin
        MessageBox(Handle,'Por favor selecione um cliente na lista','Selecione um cliente primeiro',MB_ICONWARNING);
        ListBox_Customers.SetFocus;
        Exit;
    end;

    GetChecksum;
end;

procedure TForm1.DoGetChecksum(      aTableName: String;
                                     aTableNo
                                   , aTableCount: Word;
                                     aTableChecksum: String;
                               const aIgnored: Boolean);
begin
    if not aIgnored then
        Memo1.Lines.Add('Tabela: ' + UpperCase(aTableName) + ' (' + IntToStr(aTableNo) + '/' + IntToStr(aTableCount) + '), MD5: ' + aTableChecksum)
    else
        Memo1.Lines.Add('Tabela: ' + UpperCase(aTableName) + ' (' + IntToStr(aTableNo) + '/' + IntToStr(aTableCount) + '), IGNORADA!');
end;

procedure TForm1.FormCreate(Sender: TObject);
begin
	{ sUBSTITUIR POR CONSULTA A BASE INTERNA DA EMPRESA COM DADOS DO CLIENTE!}
    ListBox_Customers.Clear;
    ListBox_Customers.AddItem('WSC',TObject(0));
	ListBox_Customers.AddItem('Hitachi Ar Condicionado do Brasil',TObject(1));
end;

procedure TForm1.GetChecksum;
var
    ZConnection: TZConnection;
begin
    ZConnection := nil;
	case SelectedWSCCustomer of
        wcUnknown: raise Exception.Create('O cliente selecionado é desconhecido...');
        wcWSC: Application.ProcessMessages;
        wcHitachi: try { == HITACHI ========================================== }
            ZConnection := TZConnection.Create(Self);
            TXXXDataModule.InitializeZConnection(ZConnection
                                                ,LabeledEdit_Protocol.Text
                                                ,LabeledEdit_HostName.Text
                                                ,LabeledEdit_BancoDeDados.Text
                                                ,LabeledEdit_Login.Text
                                                ,LabeledEdit_Password.Text
                                                ,StrToIntDef(LabeledEdit_Port.Text,0)
                                                ,tiReadCommitted);

            Memo1.Clear;
            Label1.Caption := EmptyStr;
            Application.ProcessMessages;
            Label1.Caption := TXXXDataModule.MySQLDatabaseCheckSum(ZConnection
                                                                  ,LabeledEdit_BancoDeDados.Text
                                                                  ,['DELTA' { ambos}
                                                                   ,'SEQUENCIAS' { servidor }
                                                                   ,'SINCRONIZACOES' { cliente }
                                                                   ,'REGISTROSEXCLUIDOS'] { cliente - depreciada }
                                                                   ,['EN_SITUACAO']
                                                                  ,ExtractFilePath(Application.ExeName)
                                                                  ,DoGetChecksum);

        finally
            if Assigned(ZConnection) then
                ZConnection.Free;
        end; { ==================================================== HITACHI == }
    end;
end;

procedure TForm1.ListBox_CustomersClick(Sender: TObject);
begin
    SelectedWSCCustomer := wcUnknown;
    LabeledEdit_BancoDeDados.Text := '';
    LabeledEdit_HostName.Text := '';
    LabeledEdit_Protocol.Text := '';
    LabeledEdit_Port.Text := '';
    LabeledEdit_Login.Text := '';
    LabeledEdit_Password.Text := '';

    case Integer(ListBox_Customers.Items.Objects[ListBox_Customers.ItemIndex]) of
        0: SelectedWSCCustomer := wcWSC;
        1: begin
            SelectedWSCCustomer := wcHitachi;
            LabeledEdit_BancoDeDados.Text := 'BANCODEOBRAS';
            LabeledEdit_HostName.Text := '127.0.0.1';
            LabeledEdit_Port.Text := '3306';
            LabeledEdit_Protocol.Text := 'mysql-5';
            LabeledEdit_Login.Text := 'root';
            LabeledEdit_Password.Text := 'hitachiwsc';
        end;
    end;
end;

end.
