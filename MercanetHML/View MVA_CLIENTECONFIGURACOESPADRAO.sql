---------------------------------------------------------------------------------------------------
-- VERSAO	DATA		AUTOR			ALTERACAO
-- 1.0000	10/07/2013	TIAGO PRADELLA	CRIACAO
---------------------------------------------------------------------------------------------------
CREATE  VIEW  MVA_CLIENTECONFIGURACOESPADRAO AS
SELECT CAMPO	     CAMPO_CLICONPA,
       VALOR_PADRAO	 VALORPADRAO_CLICONPA
  FROM DB_CONFIGURACAO_CAMPOS	
 WHERE CADASTRO = 1
   and isnull(VALOR_PADRAO , '') <> ''
