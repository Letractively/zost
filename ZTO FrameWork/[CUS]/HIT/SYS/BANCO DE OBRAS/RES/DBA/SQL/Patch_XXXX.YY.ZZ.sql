# CONFIGURE ABAIXO O NOME DO BANCO DE DADOS COLOCANDO-O ENTRE ASPAS NA
# ATRIBUI��O DA VARI�VEL E SEM ASPAS NO COMANDO "USE"
SET @BANCODEDADOS := 'BANCODEOBRAS3';
USE BANCODEOBRAS3;

# ==============================================================================
# O QUE EU ESTOU FAZENDO AQUI...

# ==============================================================================



ALTERE O NOME DA FUN��O "FNC_GET_CURRENCY_CODE" PARA "FNC_GET_CURRENCY_CODE_FROM_ITEM"
CRIE A FUN��O "GET_CURRENCY_CODE_FROM_PROPOSAL"

A PRIMEIRA FUN��O OBT�M O C�DIGO DA MEDA A PARTIR DO ITEM, SENDO QUE CADA ITEM TEM SEU PR�RPIO CODIGO DE MOEDA
A SEGUNDA � UMA FUN��O NOVA QUE OBT�M O C�DIGO DA MOEDA DADO UM C�DIGO DE PROPOSTA E PODE SER USADA NO CONTEXTO DE UM ITEM PARA SABER QUAL A MOEDA DA PROPOSTA RELACIONADA A UM ITEM












# == VARIAVEIS TEMPORRIAS ======================================================
# A VARI�VEL "SYNCHRONIZING" � �TIL APENAS NO CLIENTE POIS L� PODE HAVER A��ES
# EM TABELAS GERADAS DURANTE UMA SINCRONIZA��O OU N�O. NO SERVIDOR, QUANDO
# "SERVERSIDE" = TRUE, ESTA VARI�VEL � IGNORADA POIS NO SERVIDOR ESTAREMOS
# SEMPRE SINCRONIZANDO

# O USO DESTAS VARI�VEIS AQUI S� � EFETIVO SE HOUVER MANIPUL��O DE DADOS NESTE
# SCRIPT. SERVERSIDE = TRUE � CONDI��O SUFICIENTE PARA DIZER QUE SE EST�
# SINCRONIZANDO NO SERVIDOR POIS O SERVIDOR N�O � ACESS�VEL DIRETAMENTE, APENAS
# VIA SINCRONIZ��O
SET @SYNCHRONIZING = FALSE;
SET @CURRENTLOGGEDUSER = 1;
SET @SERVERSIDE = TRUE;
SET @ADJUSTINGDB = TRUE;
SET FOREIGN_KEY_CHECKS = 0;
# ATEN��O: QUANDO FOREIGN_KEY_CHECKS EST� DESATIVADO NENHUMA FUN��O RELACIONADA
# A INTEGRIDADE REFERENCIAL SER� EXECUTADA A SABER: ONDELETE E ONUPDATE. SE SUA
# INTEN��O � EXCLUIR PROPOSITALMENTE ALGUNS REGISTROS A T�TULO DE LIMPEZA, ISSO
# DEVE SER FEITO QUANDO "FOREIGN_KEY_CHECKS = 1" DO CONTR�RIO O BANCO FICAR�
# INCONSISTENTE (REGISTROS �RF�OS)
# ==============================================================================

# == STORED PROCEDURES =========================================================

# ------------------------------------------------------------------------------

# ------------------------------------------------------------------------------

# == VIEWS =====================================================================

# ==============================================================================
# A PARTIR DESTE PONTO TODAS AS A��ES FAR�O USO DA INTEGRIDADE REFERENCIAL, O
# QUE SIGNIFICA QUE OS DADOS TEM DE ESTAR CORRETOS
SET FOREIGN_KEY_CHECKS = 1;
# ==============================================================================

# ==============================================================================
