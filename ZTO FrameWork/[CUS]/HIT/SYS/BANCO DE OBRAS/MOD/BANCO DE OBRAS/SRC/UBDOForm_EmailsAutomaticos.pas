unit UBDOForm_EmailsAutomaticos;

interface

uses
    Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
    Dialogs, UBDOForm_DialogTemplate, ActnList, ExtCtrls, StdCtrls, ComCtrls;

type
    TBDOForm_EmailsAutomaticos = class(TBDOForm_DialogTemplate)
        PageControl_Principal: TPageControl;
        TabSheet_ConfiguracoesSMTP: TTabSheet;
        TabSheet_EmailsAutomaticos: TTabSheet;
        PageControl_EmailsAutomaticos: TPageControl;
        TabSheet_ObrasOciosas: TTabSheet;
        TabSheet_ObrasGanhas: TTabSheet;
        TabSheet_ObrasPerdidas: TTabSheet;
        ComboBox_UsuarioPrincipal: TComboBox;
        Label_UsuarioPrincipal: TLabel;
        Panel_EmailPrincipal: TPanel;
        TabSheet_InformacoesAdicionais: TTabSheet;
        TabSheet_ObrasExpirando: TTabSheet;
        Label_ConfiguracoesSMTP: TLabel;
        Bevel_Linha1: TBevel;
        Bevel_Linha2: TBevel;
        ComboBox_Priority: TComboBox;
        ComboBox_ContentType: TComboBox;
        ComboBox_SendMode: TComboBox;
        CheckBox_Confirm: TCheckBox;
        CheckBox_WrapMessageText: TCheckBox;
        ComboBox_ShareMode: TComboBox;
        Label_Priority: TLabel;
        Label_ContentType: TLabel;
        Label_SendMode: TLabel;
        Label_ShareMode: TLabel;
        procedure FormCreate(Sender: TObject);
        procedure ComboBox_UsuarioPrincipalClick(Sender: TObject);
        procedure FormDestroy(Sender: TObject);
    private
        { Private declarations }
    public
        { Public declarations }
    end;

implementation

uses
    UBDODataModule_EmailsAutomaticos;

{$R *.dfm}

procedure TBDOForm_EmailsAutomaticos.ComboBox_UsuarioPrincipalClick(Sender: TObject);
begin
    inherited;
    Panel_EmailPrincipal.Caption := TBDODataModule_EmailsAutomaticos(CreateParameters.MyDataModule).GetUserEmail(Integer(ComboBox_UsuarioPrincipal.Items.Objects[ComboBox_UsuarioPrincipal.ItemIndex]));
end;

procedure TBDOForm_EmailsAutomaticos.FormCreate(Sender: TObject);
begin
    inherited;
    TBDODataModule_EmailsAutomaticos(CreateParameters.MyDataModule).PreencherComUsuarios(ComboBox_UsuarioPrincipal.Items);

    TBDODataModule_EmailsAutomaticos(CreateParameters.MyDataModule).CarregarConfiguracoes;
end;

procedure TBDOForm_EmailsAutomaticos.FormDestroy(Sender: TObject);
begin
    inherited;
    TBDODataModule_EmailsAutomaticos(CreateParameters.MyDataModule).SalvarConfiguracoes;
end;

end.

{
1. E-MAIL "PROPOSTAS SEM MOVIMENTAÇÃO"
   De 15 em 15 dias (configurável) verificar o conjunto OBR-PRO-ITE-EDI
   selecionando as obras que tem mais de 30 dias desde a ultima modificação
   (DA_DATAEHORADAMODIFICACAO). Apenas OBRAS que foram criadas pelo usuário
   principal da aplicação serão retornadas
2. E-MAIL "PROPOSTAS GANHAS"
   Sempre que o status de uma obra tornar-se GANHA enviar um e-mail de felicitações
3. E-MAIL "PROPOSTAS PERDIDAS"
   Sempre que o status de uma obra tornar-se PERDIDA enviar um e-mail de condolências
4. E-MAIL "PRAZO PREVISTO EXPIRANDO"
   De x em x dias (configurável) verificar as OBRAS selecionando aquelas que tem
   30 dias ou menos para o prazo previsto de entrega. Apenas OBRAS que foram
   criadas pelo usuário principal da aplicação e que estejam com status EM
   ANDAMENTO A, B OU M serão retornadas Texto: "favor verificar o prazo de
   entrega dos equipamentos pois a proposta ainda nao foi fechada" (em andamento A, M, B)
5. Novo relatório entrega por equipamento. Exibir equipamento, voltagem e
   quantidade. no relatorio ao clicar no modelo exibir as propostas relacionados
   a aquele item
6. NOVO RELATÓRIO DE PROPOSTA POR SITUAÇÃO


}

