ALTER VIEW  MVA_LINHASPRODUTOS AS
---------------------------------------------------------------------------------------------------
-- VERSAO	DATA		AUTOR			ALTERACAO
-- 1.0000	11/11/2013	TIAGO PRADELLA	CRIACAO
---------------------------------------------------------------------------------------------------
SELECT DB_LIN_CODIGO      CODIGO_LINPRO, 
       DB_LIN_DESCRICAO   DESCRICAO_LINPRO
  FROM DB_LINHA_PROD
