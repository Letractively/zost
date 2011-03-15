# CONFIGURE ABAIXO O NOME DO BANCO DE DADOS COLOCANDO-O ENTRE ASPAS NA
# ATRIBUIÇÃO DA VARIÁVEL E SEM ASPAS NO COMANDO "USE"
SET @BANCODEDADOS := 'BANCODEOBRAS3';
USE BANCODEOBRAS3;

# ==============================================================================
# O QUE EU ESTOU FAZENDO AQUI...

# ==============================================================================



ALTERE O NOME DA FUNÇÃO "FNC_GET_CURRENCY_CODE" PARA "FNC_GET_CURRENCY_CODE_FROM_ITEM"
CRIE A FUNÇÃO "GET_CURRENCY_CODE_FROM_PROPOSAL"

A PRIMEIRA FUNÇÃO OBTÉM O CÓDIGO DA MEDA A PARTIR DO ITEM, SENDO QUE CADA ITEM TEM SEU PRÓRPIO CODIGO DE MOEDA
A SEGUNDA É UMA FUNÇÃO NOVA QUE OBTÉM O CÓDIGO DA MOEDA DADO UM CÓDIGO DE PROPOSTA E PODE SER USADA NO CONTEXTO DE UM ITEM PARA SABER QUAL A MOEDA DA PROPOSTA RELACIONADA A UM ITEM












# == VARIAVEIS TEMPORRIAS ======================================================
# A VARIÁVEL "SYNCHRONIZING" É ÚTIL APENAS NO CLIENTE POIS LÁ PODE HAVER AÇÕES
# EM TABELAS GERADAS DURANTE UMA SINCRONIZAÇÃO OU NÃO. NO SERVIDOR, QUANDO
# "SERVERSIDE" = TRUE, ESTA VARIÁVEL É IGNORADA POIS NO SERVIDOR ESTAREMOS
# SEMPRE SINCRONIZANDO

# O USO DESTAS VARIÁVEIS AQUI SÓ É EFETIVO SE HOUVER MANIPULÇÃO DE DADOS NESTE
# SCRIPT. SERVERSIDE = TRUE É CONDIÇÃO SUFICIENTE PARA DIZER QUE SE ESTÁ
# SINCRONIZANDO NO SERVIDOR POIS O SERVIDOR NÃO É ACESSÍVEL DIRETAMENTE, APENAS
# VIA SINCRONIZÇÃO
SET @SYNCHRONIZING = FALSE;
SET @CURRENTLOGGEDUSER = 1;
SET @SERVERSIDE = TRUE;
SET @ADJUSTINGDB = TRUE;
SET FOREIGN_KEY_CHECKS = 0;
# ATENÇÃO: QUANDO FOREIGN_KEY_CHECKS ESTÁ DESATIVADO NENHUMA FUNÇÃO RELACIONADA
# A INTEGRIDADE REFERENCIAL SERÁ EXECUTADA A SABER: ONDELETE E ONUPDATE. SE SUA
# INTENÇÃO É EXCLUIR PROPOSITALMENTE ALGUNS REGISTROS A TÍTULO DE LIMPEZA, ISSO
# DEVE SER FEITO QUANDO "FOREIGN_KEY_CHECKS = 1" DO CONTRÁRIO O BANCO FICARÁ
# INCONSISTENTE (REGISTROS ÓRFÃOS)
# ==============================================================================

# == STORED PROCEDURES =========================================================

# ------------------------------------------------------------------------------

# ------------------------------------------------------------------------------

# == VIEWS =====================================================================

# ==============================================================================
# A PARTIR DESTE PONTO TODAS AS AÇÕES FARÃO USO DA INTEGRIDADE REFERENCIAL, O
# QUE SIGNIFICA QUE OS DADOS TEM DE ESTAR CORRETOS
SET FOREIGN_KEY_CHECKS = 1;
# ==============================================================================

# ==============================================================================
