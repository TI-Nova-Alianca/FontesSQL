---------------------------------------------------------------------------------------------------
-- VERSAO	DATA		AUTOR			ALTERACAO
-- 1.0001	01/06/2015	TIAGO PRADELLA	CRIACAO
---------------------------------------------------------------------------------------------------
ALTER VIEW  MVA_PRODUTOS_SIMILARES_ITENS AS
 SELECT CODIGO       CODIGO_PRODSIIT,
		PRODUTO      PRODUTO_PRODSIIT
  FROM DB_PROD_SIMILARES_IT, MVA_PRODUTOS_SIMILARES 
 WHERE CODIGO = CODIGO_PRODSI
