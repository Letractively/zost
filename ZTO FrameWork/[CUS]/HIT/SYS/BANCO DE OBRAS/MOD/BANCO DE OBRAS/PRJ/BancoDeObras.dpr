program BancoDeObras;

{ TODO :
ERROS BIZARROS:
- ACCESS VIOLATION ANTES DA APLICAÇÃO COMEÇAR
  * FALTA APPLICATION.RUN
  * FALTA APPLICATION.INITIALIZE (NÃO TESTADO)

OBS.:
> AS UNITS QUE PRECISAM SER ALTERADAS QUANDO NOVAS TABELAS OU CAMPOS SÃO ALTERADOS SÃO:
 UFSYGLOBALS, UFSYSYNCSTRUCTURES E UBDODATAMODULE_IMPORTAREXPORTAROBRAS
 DENTRO DE CADA UNIT TEM UMA EXPLICAÇÃO DO QUE DEVE SER FEITO
 OBVIAMENTE UM SCRIPT DE PATCH TEM DE SER ATUALIZADO DE ACORDO PARA QUE OS NOVOS
 CAMPOS OU TABELAS SEJAM ACESSÍVEIS

> OS TACTIONLIST DO FORM SÃO APENAS PARA CONTER AÇÕES COMPARTILHADAS PELO FORM
  MAS QUE NÃO SÃO PASSÍVEIS DE PERMISSÃO

> AQUILO QUE EU POSSO TER, COPIADO EM CADA UMA DAS INSTÂNCIAS CRIADAS EU POSSO
  HERDAR SEM PROBLEMAS, DO CONTRÁRIO NÃO!
  LEMBRANDO QUE SE EU COLOCO EM UM FORMULÁRIO PAI UMA COISA, ESTA COISA SERÁ
  REPLICADA EM CADA FORM HERDADO, OCUPANDO MEMORIA, POR ISSO NÃO É SEMPRE UMA
  BOA IDEIA

> OS COMPONENTES VISUAIS SÓ FICAM ACESSÍVEIS DENTRO DO EVENTO ONCREATE E NÃO NO
  CONSTRUTOR. LEMBRE-SE: CONSTRUTOR É BAIXO NÍVEL, ONCREATE OCORRE APÓS O
  CONSTRUTOR TERMINAR

> PODE SER INTERESSANTE FAZER ALGO SEMELHANTE AO QUE SE FEZ COM O ZCONNECTION
  COM OUTROS COMPONENTES COMO OS TIMAGELISTS

> Função que permite transformar um método de um objeto de forma que ele possa
  ser usado como uma função global (procedural): MAKEOBJECTINSTANCE

> Classes Interposer são colocadas dentro de Units que tem o mesmo nome das
  units das classes originais mas usando a seguinte notação

  ActnList ---> _ActnList

> A BARRA DE PROGRESSO DE CARGA DO MÓDULO É AUTOMATICAMENTE PREENCHIDA PELO
  FRAMEWORK PARA OS DATASETS, DATASOURCES E DURANTE A APLICAÇÃO DE PERMISSÕES
  PARA CADA AÇÃO ENCONTRADA. CASO O MÓDULO EM QUESTÃO TENHA OUTRAS COISAS
  CARREGÁVEIS ISSO DEVERÁ SER FEITO NO EVENTO DATAMODULECREATE APÓS O INHERITED,
  ASSIM:

    inherited;
	try
		ProgressBarModuleLoad.Position := 0;
		ProgressBarModuleLoad.Max := <Quantidade de coisas carregáveis>;
		ProgressBarModuleLoad.Show;

        <... Processo que incrementa o progressbar ...>

    finally
		ProgressBarModuleLoad.Hide;
	end;

}

{ TODO : Caso a configuração do ZConnection for específica do DataModule que
contém o TZQuery ou TZTable então o manipulador do evento BeforeOpen deve ser
sobrescrito dentro do DataModule que contém o TZQuery ou TZTable }

{ TODO : 
Os evento automaticamente atribuíveis são

TDataSet
¯¯¯¯¯¯¯¯
> BeforeOpen
> BeforePost
> BeforeDelete
> BeforeCancel
> OnPostError
> OnEditError
> OnDeleteError

TDataSource
¯¯¯¯¯¯¯¯¯¯¯
> OnDataChange
> OnStateChange

Isso significa que estes eventos serão os eventos usados pelos componentes
descritos, mesmo que tenha sido atribuído algum evento manualmente, por isso
para usar estes eventos devemos simplesmente sobrescreve-los dentro de cada
datamodule e colocar lá a programação necessária, tomando o cuidado de manter o
comando inherited, de forma que a programação original não seja perdida.
Adicionalmente os seguintes evento também serão atribuídos, mas estes fazem
parte do framework e não devem ser sobrescritos

TApplication
¯¯¯¯¯¯¯¯¯¯¯¯
> OnException

A barra de progresso de carga do módulo não deve ser automatica no framework
porque é necessário dar ao programador a possibilidade de incluir mais coisas no
carregamento de um datamodule

A propriedade RefreshSQL do ZUpdateSQL deve ser preenchida com um SQL que
retorne, NO MÍNIMO, a chave da tabela em questão. Isso faz com que a chave
primária autoincrementável seja obtida imediatamente após a inserção do registro.
Esta atitude é suficiente para que tudo aconteça como deve, entretanto, caso
haja na query mais campos cujo valor é preenchido pelo servidor (uma data por
exemplo), estes também devem ser incluídos no RefreshSQL de forma que
imediatamente após a inserção do registros estes sejam visualizáveis}


//$(BDS)\lib\Componentes\ICS\dcu;$(BDS)\lib\Componentes\Zeos DBO\packages\delphi10\build;$(BDS)\lib\Componentes\CFEdit\dcu;$(BDS)\lib\Componentes\BalloonToolTip\dcu;$(BDS)\lib\Componentes\CFDBValidationChecks\dcu;$(BDS)\lib\Componentes\CFDBGrid\dcu;$(BDS)\lib\Componentes\CFDBGrid\res;$(BDS)\lib\Componentes\Mozilla Browser Type Library\dcu;..\..\..\..\..\..\..\[FW1.1];..\..\..\..\..\..\..\[FW1.1]\Form repository;..\..\..\..\..\..\..\[FW1.1]\Libraries;..\..\..\..\..\..\..\[FW1.1]\Libraries\Crypt;..\..\..\..\..\..\..\[FW1.1]\Libraries\Crypt\Hashes;..\..\..\..\..\..\..\[FW1.1]\Libraries\Interposer;..\..\..\..\FTP Synchronizer\Libraries

{ TODO -oCarlos Feitoza -cINFORMAÇÃO : Para simular uma operação como se
estivessemos usando o bdo, inclua no script as seguintes variáveis

SET @CURRENTLOGGEDUSER := 3;
SET @SYNCHRONIZING := FALSE;
SET @SERVERSIDE := FALSE;
SET @ADJUSTINGDB := FALSE;

para simular uma sincronização use:

no script a ser executado no servidor...

SET @CURRENTLOGGEDUSER := 3;
SET @SYNCHRONIZING := TRUE;
SET @SERVERSIDE := TRUE;
SET @ADJUSTINGDB := FALSE;

no script a ser executado no cliente...

SET @CURRENTLOGGEDUSER := 3;
SET @SYNCHRONIZING := TRUE;
SET @SERVERSIDE := FALSE;
SET @ADJUSTINGDB := FALSE;

 }

 { TODO 5 -oCarlos Feitoza -cEXPLICAÇÃO : É preciso revisar aquilo que está sendo
 exibido em DataModuleMain. Caso apenas seja usado a partir de datamodule Main,
 como algo mais global, todas as refrencias no frame devem apontar para
 FDataModuleMain.Propriedade caso a propriedade seja usada tanto localmente como
 globalmente, a regra é a mesma, mas deve-se tomar cuidado com aquilo que deve
 ser usado. Acho que ZConnections é um caso desses. veja o form de AutoSync e o
 altere para que ele funcione corretamente }

{%TogetherDiagram 'ModelSupport_BancoDeObras\default.txaPackage'}
{%TogetherDiagram 'ModelSupport_BancoDeObras\UBDOForm_JustificativaSalva\default.txaPackage'}
{%TogetherDiagram 'ModelSupport_BancoDeObras\UBDODataModule_AutoSync\default.txaPackage'}
{%TogetherDiagram 'ModelSupport_BancoDeObras\UBDODataModule\default.txaPackage'}
{%TogetherDiagram 'ModelSupport_BancoDeObras\UBDODataModule_Administration\default.txaPackage'}
{%TogetherDiagram 'ModelSupport_BancoDeObras\UBDOForm_Main\default.txaPackage'}
{%TogetherDiagram 'ModelSupport_BancoDeObras\UBDOTypesConstantsAndClasses\default.txaPackage'}
{%TogetherDiagram 'ModelSupport_BancoDeObras\UBDODataModule_ImportarExportarObras\default.txaPackage'}
{%TogetherDiagram 'ModelSupport_BancoDeObras\UBDOForm_Projetistas\default.txaPackage'}
{%TogetherDiagram 'ModelSupport_BancoDeObras\UBDOForm_InformacoesDoEquipamento\default.txaPackage'}
{%TogetherDiagram 'ModelSupport_BancoDeObras\UBDODataModule_InformacoesDaProposta\default.txaPackage'}
{%TogetherDiagram 'ModelSupport_BancoDeObras\UBDOForm_Relatorio_OBR\default.txaPackage'}
{%TogetherDiagram 'ModelSupport_BancoDeObras\UBDODataModule_Regioes\default.txaPackage'}
{%TogetherDiagram 'ModelSupport_BancoDeObras\UBDODataModule_Obras\default.txaPackage'}
{%TogetherDiagram 'ModelSupport_BancoDeObras\UBDOForm_Relatorio_JDO\default.txaPackage'}
{%TogetherDiagram 'ModelSupport_BancoDeObras\UBDOForm_AvailableRegions\default.txaPackage'}
{%TogetherDiagram 'ModelSupport_BancoDeObras\UBDODataModule_Relatorio_JDO\default.txaPackage'}
{%TogetherDiagram 'ModelSupport_BancoDeObras\UBDOForm_TiposDeObra\default.txaPackage'}
{%TogetherDiagram 'ModelSupport_BancoDeObras\UBDOForm_Obras\default.txaPackage'}
{%TogetherDiagram 'ModelSupport_BancoDeObras\UBDOForm_Regioes\default.txaPackage'}
{%TogetherDiagram 'ModelSupport_BancoDeObras\UBDOForm_GeneralConfigurations\default.txaPackage'}
{%TogetherDiagram 'ModelSupport_BancoDeObras\UBDODataModule_Main\default.txaPackage'}
{%TogetherDiagram 'ModelSupport_BancoDeObras\UBDODataModule_InformacoesDoEquipamento\default.txaPackage'}
{%TogetherDiagram 'ModelSupport_BancoDeObras\UBDOForm_Splash\default.txaPackage'}
{%TogetherDiagram 'ModelSupport_BancoDeObras\UBDODataModule_Situacoes\default.txaPackage'}
{%TogetherDiagram 'ModelSupport_BancoDeObras\UBDODataModule_Relatorio_EQP\default.txaPackage'}
{%TogetherDiagram 'ModelSupport_BancoDeObras\UBDOForm_Instaladores\default.txaPackage'}
{%TogetherDiagram 'ModelSupport_BancoDeObras\UBDOForm_GeradorDeProposta\default.txaPackage'}
{%TogetherDiagram 'ModelSupport_BancoDeObras\UBDOForm_Situacoes\default.txaPackage'}
{%TogetherDiagram 'ModelSupport_BancoDeObras\UBDODataModule_EquipamentosEFamilias\default.txaPackage'}
{%TogetherDiagram 'ModelSupport_BancoDeObras\UBDOForm_GeradorDeRelatorio\default.txaPackage'}
{%TogetherDiagram 'ModelSupport_BancoDeObras\UBDODataModule_TiposDeObra\default.txaPackage'}
{%TogetherDiagram 'ModelSupport_BancoDeObras\BancoDeObras\default.txaPackage'}
{%TogetherDiagram 'ModelSupport_BancoDeObras\UBDOForm_ObrasSemelhantes\default.txaPackage'}
{%TogetherDiagram 'ModelSupport_BancoDeObras\UBDOForm_Relatorio_FAM\default.txaPackage'}
{%TogetherDiagram 'ModelSupport_BancoDeObras\UBDOForm_AutoSync\default.txaPackage'}
{%TogetherDiagram 'ModelSupport_BancoDeObras\UBDODataModule_Relatorio_OBR\default.txaPackage'}
{%TogetherDiagram 'ModelSupport_BancoDeObras\UBDOForm_JustificativaParaObra\default.txaPackage'}
{%TogetherDiagram 'ModelSupport_BancoDeObras\UBDODataModule_TabelasAuxiliares\default.txaPackage'}
{%TogetherDiagram 'ModelSupport_BancoDeObras\UBDOForm_Relatorio_EQP\default.txaPackage'}
{%TogetherDiagram 'ModelSupport_BancoDeObras\UBDOForm_TabelasAuxiliares\default.txaPackage'}
{%TogetherDiagram 'ModelSupport_BancoDeObras\UBDOForm_DialogTemplate\default.txaPackage'}
{%TogetherDiagram 'ModelSupport_BancoDeObras\UBDODataModule_GeradorDeProposta\default.txaPackage'}
{%TogetherDiagram 'ModelSupport_BancoDeObras\UBDOForm_ImportarExportarObras\default.txaPackage'}
{%TogetherDiagram 'ModelSupport_BancoDeObras\UBDOForm_Relatorio_PRO\default.txaPackage'}
{%TogetherDiagram 'ModelSupport_BancoDeObras\UBDODataModule_Projetistas\default.txaPackage'}
{%TogetherDiagram 'ModelSupport_BancoDeObras\UBDOForm_InformacoesDaProposta\default.txaPackage'}
{%TogetherDiagram 'ModelSupport_BancoDeObras\UBDODataModule_Relatorio_FAM\default.txaPackage'}
{%TogetherDiagram 'ModelSupport_BancoDeObras\UBDOForm_AdminModule\default.txaPackage'}
{%TogetherDiagram 'ModelSupport_BancoDeObras\UBDODataModule_Relatorio_PRO\default.txaPackage'}
{%TogetherDiagram 'ModelSupport_BancoDeObras\UBDODataModule_Instaladores\default.txaPackage'}
{%TogetherDiagram 'ModelSupport_BancoDeObras\UBDOForm_EquipamentosEFamilias\default.txaPackage'}
{%TogetherDiagram 'ModelSupport_BancoDeObras\UBDODataModule_GeradorDeRelatorio\default.txaPackage'}
{%TogetherDiagram 'ModelSupport_BancoDeObras\default.txvpck'}
{%TogetherDiagram 'ModelSupport_BancoDeObras\UBDODataModule\default.txvpck'}
{%TogetherDiagram 'ModelSupport_BancoDeObras\UBDODataModule_Regioes\default.txvpck'}
{%TogetherDiagram 'ModelSupport_BancoDeObras\UBDOForm_ImportarExportarObras\default.txvpck'}
{%TogetherDiagram 'ModelSupport_BancoDeObras\UBDODataModule_GeradorDeRelatorio\default.txvpck'}
{%TogetherDiagram 'ModelSupport_BancoDeObras\UBDODataModule_GeradorDeProposta\default.txvpck'}
{%TogetherDiagram 'ModelSupport_BancoDeObras\UBDOForm_Splash\default.txvpck'}
{%TogetherDiagram 'ModelSupport_BancoDeObras\UBDODataModule_Relatorio_JDO\default.txvpck'}
{%TogetherDiagram 'ModelSupport_BancoDeObras\UBDOForm_InformacoesDaProposta\default.txvpck'}
{%TogetherDiagram 'ModelSupport_BancoDeObras\UBDOForm_Relatorio_JDO\default.txvpck'}
{%TogetherDiagram 'ModelSupport_BancoDeObras\UBDODataModule_Obras\default.txvpck'}
{%TogetherDiagram 'ModelSupport_BancoDeObras\UBDODataModule_Relatorio_FAM\default.txvpck'}
{%TogetherDiagram 'ModelSupport_BancoDeObras\UBDODataModule_Projetistas\default.txvpck'}
{%TogetherDiagram 'ModelSupport_BancoDeObras\UBDODataModule_TiposDeObra\default.txvpck'}
{%TogetherDiagram 'ModelSupport_BancoDeObras\UBDOForm_Main\default.txvpck'}
{%TogetherDiagram 'ModelSupport_BancoDeObras\UBDOForm_Situacoes\default.txvpck'}
{%TogetherDiagram 'ModelSupport_BancoDeObras\UBDOForm_GeneralConfigurations\default.txvpck'}
{%TogetherDiagram 'ModelSupport_BancoDeObras\UBDOForm_TiposDeObra\default.txvpck'}
{%TogetherDiagram 'ModelSupport_BancoDeObras\UBDOForm_AdminModule\default.txvpck'}
{%TogetherDiagram 'ModelSupport_BancoDeObras\UBDOForm_DialogTemplate\default.txvpck'}
{%TogetherDiagram 'ModelSupport_BancoDeObras\UBDODataModule_Instaladores\default.txvpck'}
{%TogetherDiagram 'ModelSupport_BancoDeObras\UBDOForm_Regioes\default.txvpck'}
{%TogetherDiagram 'ModelSupport_BancoDeObras\UBDODataModule_EquipamentosEFamilias\default.txvpck'}
{%TogetherDiagram 'ModelSupport_BancoDeObras\UBDOForm_ObrasSemelhantes\default.txvpck'}
{%TogetherDiagram 'ModelSupport_BancoDeObras\UBDODataModule_TabelasAuxiliares\default.txvpck'}
{%TogetherDiagram 'ModelSupport_BancoDeObras\UBDODataModule_Situacoes\default.txvpck'}
{%TogetherDiagram 'ModelSupport_BancoDeObras\UBDODataModule_Administration\default.txvpck'}
{%TogetherDiagram 'ModelSupport_BancoDeObras\UBDODataModule_Relatorio_OBR\default.txvpck'}
{%TogetherDiagram 'ModelSupport_BancoDeObras\UBDOForm_GeradorDeRelatorio\default.txvpck'}
{%TogetherDiagram 'ModelSupport_BancoDeObras\UBDOTypesConstantsAndClasses\default.txvpck'}
{%TogetherDiagram 'ModelSupport_BancoDeObras\UBDOForm_EquipamentosEFamilias\default.txvpck'}
{%TogetherDiagram 'ModelSupport_BancoDeObras\BancoDeObras\default.txvpck'}
{%TogetherDiagram 'ModelSupport_BancoDeObras\UBDOForm_Relatorio_EQP\default.txvpck'}
{%TogetherDiagram 'ModelSupport_BancoDeObras\UBDODataModule_ImportarExportarObras\default.txvpck'}
{%TogetherDiagram 'ModelSupport_BancoDeObras\UBDOForm_Projetistas\default.txvpck'}
{%TogetherDiagram 'ModelSupport_BancoDeObras\UBDODataModule_AutoSync\default.txvpck'}
{%TogetherDiagram 'ModelSupport_BancoDeObras\UBDOForm_TabelasAuxiliares\default.txvpck'}
{%TogetherDiagram 'ModelSupport_BancoDeObras\UBDOForm_JustificativaSalva\default.txvpck'}
{%TogetherDiagram 'ModelSupport_BancoDeObras\UBDOForm_Relatorio_FAM\default.txvpck'}
{%TogetherDiagram 'ModelSupport_BancoDeObras\UBDODataModule_Relatorio_EQP\default.txvpck'}
{%TogetherDiagram 'ModelSupport_BancoDeObras\UBDODataModule_Relatorio_PRO\default.txvpck'}
{%TogetherDiagram 'ModelSupport_BancoDeObras\UBDOForm_Obras\default.txvpck'}
{%TogetherDiagram 'ModelSupport_BancoDeObras\UBDODataModule_InformacoesDaProposta\default.txvpck'}
{%TogetherDiagram 'ModelSupport_BancoDeObras\UBDOForm_GeradorDeProposta\default.txvpck'}
{%TogetherDiagram 'ModelSupport_BancoDeObras\UBDOForm_Instaladores\default.txvpck'}
{%TogetherDiagram 'ModelSupport_BancoDeObras\UBDOForm_AutoSync\default.txvpck'}
{%TogetherDiagram 'ModelSupport_BancoDeObras\UBDOForm_AvailableRegions\default.txvpck'}
{%TogetherDiagram 'ModelSupport_BancoDeObras\UBDODataModule_Main\default.txvpck'}
{%TogetherDiagram 'ModelSupport_BancoDeObras\UBDOForm_JustificativaParaObra\default.txvpck'}
{%TogetherDiagram 'ModelSupport_BancoDeObras\UBDOForm_Relatorio_PRO\default.txvpck'}
{%TogetherDiagram 'ModelSupport_BancoDeObras\UBDOForm_Relatorio_OBR\default.txvpck'}
{%TogetherDiagram 'ModelSupport_BancoDeObras\UBDODataModule_InformacoesDoEquipamento\default.txvpck'}
{%TogetherDiagram 'ModelSupport_BancoDeObras\UBDOForm_InformacoesDoEquipamento\default.txvpck'}

uses
  Forms,
  XPMan,
  UBDOTypesConstantsAndClasses in '..\SRC\UBDOTypesConstantsAndClasses.pas',
  UBDODataModule in '..\SRC\UBDODataModule.pas' {BDODataModule: TDataModule},
  UBDOForm_GeradorDeRelatorio in '..\SRC\UBDOForm_GeradorDeRelatorio.pas' {BDOForm_GeradorDeRelatorio},
  UBDOForm_DialogTemplate in '..\SRC\UBDOForm_DialogTemplate.pas' {BDOForm_DialogTemplate},
  UBDODataModule_GeradorDeRelatorio in '..\SRC\UBDODataModule_GeradorDeRelatorio.pas' {BDODataModule_GeradorDeRelatorio: TDataModule},
  UBDODataModule_Main in '..\SRC\UBDODataModule_Main.pas' {BDODataModule_Main: TDataModule},
  UBDOForm_Main in '..\SRC\UBDOForm_Main.pas' {BDOForm_Main},
  UBDOForm_Situacoes in '..\SRC\UBDOForm_Situacoes.pas' {BDOForm_Situacoes},
  UBDODataModule_Situacoes in '..\SRC\UBDODataModule_Situacoes.pas' {BDODataModule_Situacoes: TDataModule},
  UBDOForm_Regioes in '..\SRC\UBDOForm_Regioes.pas' {BDOForm_Regioes},
  UBDODataModule_Regioes in '..\SRC\UBDODataModule_Regioes.pas' {BDODataModule_Regioes: TDataModule},
  UBDOForm_TiposDeObra in '..\SRC\UBDOForm_TiposDeObra.pas' {BDOForm_TiposDeObra},
  UBDODataModule_TiposDeObra in '..\SRC\UBDODataModule_TiposDeObra.pas' {BDODataModule_TiposDeObra: TDataModule},
  UBDOForm_Projetistas in '..\SRC\UBDOForm_Projetistas.pas' {BDOForm_Projetistas},
  UBDODataModule_Projetistas in '..\SRC\UBDODataModule_Projetistas.pas' {BDODataModule_Projetistas: TDataModule},
  UBDOForm_Instaladores in '..\SRC\UBDOForm_Instaladores.pas' {BDOForm_Instaladores},
  UBDODataModule_Instaladores in '..\SRC\UBDODataModule_Instaladores.pas' {BDODataModule_Instaladores: TDataModule},
  UBDOForm_EquipamentosEFamilias in '..\SRC\UBDOForm_EquipamentosEFamilias.pas' {BDOForm_EquipamentosEFamilias},
  UBDODataModule_EquipamentosEFamilias in '..\SRC\UBDODataModule_EquipamentosEFamilias.pas' {BDODataModule_EquipamentosEFamilias: TDataModule},
  UBDOForm_AutoSync in '..\SRC\UBDOForm_AutoSync.pas' {BDOForm_AutoSync},
  UBDODataModule_AutoSync in '..\SRC\UBDODataModule_AutoSync.pas' {BDODataModule_AutoSync: TDataModule},
  UBDOForm_GeneralConfigurations in '..\SRC\UBDOForm_GeneralConfigurations.pas' {BDOForm_GeneralConfigurations},
  UBDOForm_TabelasAuxiliares in '..\SRC\UBDOForm_TabelasAuxiliares.pas' {BDOForm_TabelasAuxiliares},
  UBDODataModule_TabelasAuxiliares in '..\SRC\UBDODataModule_TabelasAuxiliares.pas' {BDODataModule_TabelasAuxiliares: TDataModule},
  UBDODataModule_Administration in '..\SRC\UBDODataModule_Administration.pas' {BDODataModule_Administration: TDataModule},
  UBDOForm_AdminModule in '..\SRC\UBDOForm_AdminModule.pas' {BDOForm_AdminModule},
  UBDOForm_AvailableRegions in '..\SRC\UBDOForm_AvailableRegions.pas' {BDOForm_AvailableRegions},
  UBDOForm_Obras in '..\SRC\UBDOForm_Obras.pas' {BDOForm_Obras},
  UBDODataModule_Obras in '..\SRC\UBDODataModule_Obras.pas' {BDODataModule_Obras: TDataModule},
  UBDODataModule_GeradorDeProposta in '..\SRC\UBDODataModule_GeradorDeProposta.pas' {BDODataModule_GeradorDeProposta: TDataModule},
  UBDOForm_GeradorDeProposta in '..\SRC\UBDOForm_GeradorDeProposta.pas' {BDOForm_GeradorDeProposta},
  UBDODataModule_Relatorio_EQP in '..\SRC\UBDODataModule_Relatorio_EQP.pas' {BDODataModule_Relatorio_EQP: TDataModule},
  UBDOForm_Relatorio_EQP in '..\SRC\UBDOForm_Relatorio_EQP.pas' {BDOForm_Relatorio_EQP},
  UBDODataModule_Relatorio_FAM in '..\SRC\UBDODataModule_Relatorio_FAM.pas' {BDODataModule_Relatorio_FAM: TDataModule},
  UBDOForm_Relatorio_FAM in '..\SRC\UBDOForm_Relatorio_FAM.pas' {BDOForm_Relatorio_FAM},
  UBDODataModule_Relatorio_OBR in '..\SRC\UBDODataModule_Relatorio_OBR.pas' {BDODataModule_Relatorio_OBR: TDataModule},
  UBDOForm_Relatorio_OBR in '..\SRC\UBDOForm_Relatorio_OBR.pas' {BDOForm_Relatorio_OBR},
  UBDODataModule_Relatorio_PRO in '..\SRC\UBDODataModule_Relatorio_PRO.pas' {BDODataModule_Relatorio_PRO: TDataModule},
  UBDOForm_Relatorio_PRO in '..\SRC\UBDOForm_Relatorio_PRO.pas' {BDOForm_Relatorio_PRO},
  UBDOForm_InformacoesDaProposta in '..\SRC\UBDOForm_InformacoesDaProposta.pas' {BDOForm_InformacoesDaProposta},
  UBDODataModule_InformacoesDaProposta in '..\SRC\UBDODataModule_InformacoesDaProposta.pas' {BDODataModule_InformacoesDaProposta: TDataModule},
  UBDOForm_JustificativaParaObra in '..\SRC\UBDOForm_JustificativaParaObra.pas' {BDOForm_JustificativaParaObra},
  UBDOForm_JustificativaSalva in '..\SRC\UBDOForm_JustificativaSalva.pas' {BDOForm_JustificativaSalva},
  UBDOForm_ImportarExportarObras in '..\SRC\UBDOForm_ImportarExportarObras.pas' {BDOForm_ImportarExportarObras},
  UBDODataModule_ImportarExportarObras in '..\SRC\UBDODataModule_ImportarExportarObras.pas' {BDODataModule_ImportarExportarObras: TDataModule},
  UBDODataModule_Relatorio_JDO in '..\SRC\UBDODataModule_Relatorio_JDO.pas' {BDODataModule_Relatorio_JDO: TDataModule},
  UBDOForm_Relatorio_JDO in '..\SRC\UBDOForm_Relatorio_JDO.pas' {BDOForm_Relatorio_JDO},
  UBDOForm_ObrasSemelhantes in '..\SRC\UBDOForm_ObrasSemelhantes.pas' {BDOForm_ObrasSemelhantes},
  UBDODataModule_InformacoesDoEquipamento in '..\SRC\UBDODataModule_InformacoesDoEquipamento.pas' {BDODataModule_InformacoesDoEquipamento: TDataModule},
  UBDOForm_InformacoesDoEquipamento in '..\SRC\UBDOForm_InformacoesDoEquipamento.pas' {BDOForm_InformacoesDoEquipamento},
  UBDOForm_Splash in '..\SRC\UBDOForm_Splash.pas' {BDOForm_Splash};

{$R *.res}

begin
	{$IFDEF DEVELOPING}
	Application.MessageBox('Esta é uma cópia de desenvolvimento! Por favor fec'+
    'he o quanto antes esta aplicação e contate o desenvolvedor para substitui'+
    'ção imediata por uma cópia de produção. Ignorando este aviso você poderá '+
    'por em risco a integridade dos dados do sistema'#13#10'- É preciso conser'+
    'tar o CFDBGrid para que ele mostre as setas de ordenação não-gráficas cor'+
    'retamente'#13#10' - Talvez seja possível otimizar a geração de relatório '+
    'de famílias'#13#10'- O relatório de obras PODE E DEVE SER OTIMIZADO!'#13#10+
    '- Por que ao usar validação em forma de caixa de dialgo, o foco não vai par'+
    'a os componentes dbcombobox?','Cópia de desenvolvimento!',$00000030);
    {$ENDIF}
	Application.Initialize;
  	Application.Title := 'Banco De Obras';
    TBDOForm_Main.Create(Application,'Módulo principal',TBDOConfigurations.Create(Application),TBDODataModule_Main);
    Application.Run;
end.
