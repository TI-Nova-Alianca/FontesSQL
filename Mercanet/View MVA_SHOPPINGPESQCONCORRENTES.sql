---------------------------------------------------------------------------------------------------
-- VERSAO	DATA		AUTOR			ALTERACAO
-- 1.0001	15/10/2012	TIAGO PRADELLA	CRIACAO
---------------------------------------------------------------------------------------------------
ALTER VIEW MVA_SHOPPINGPESQCONCORRENTES  AS
SELECT DB_SHOPC_CODIGO     SHOPPINGPESQUISA_SPCON,
       DB_SHOPC_CONCOR     CONCORRENTES_SPCON,
	   USU.USUARIO
  FROM DB_SHOPPING_CONCOR, 
       DB_USUARIO    USU
 WHERE DB_SHOPPING_CONCOR.DB_SHOPC_CODIGO  IN (SELECT  CODIGO_SHOP
                                                FROM MVA_SHOPPINGPESQUISA
											   WHERE USU.USUARIO = USUARIO)
