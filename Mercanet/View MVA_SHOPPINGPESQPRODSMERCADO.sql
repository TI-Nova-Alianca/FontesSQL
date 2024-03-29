---------------------------------------------------------------------------------------------------
-- VERSAO	DATA		AUTOR			ALTERACAO
-- 1.0001	15/10/2012	TIAGO PRADELLA	CRIACAO
---------------------------------------------------------------------------------------------------
ALTER VIEW MVA_SHOPPINGPESQPRODSMERCADO  AS
SELECT DB_SHOPM_CODIGO    SHOPPINGPESQUISA_SPPRD,
       DB_SHOPM_PRODMERC  PRODUTOMERCADO_SPPRD,
	   USU.USUARIO 
  FROM DB_SHOPPING_PRODME,
	   DB_USUARIO    USU
 WHERE DB_SHOPPING_PRODME.DB_SHOPM_CODIGO IN (SELECT CODIGO_SHOP
                                                FROM MVA_SHOPPINGPESQUISA
											   WHERE USUARIO = USU.USUARIO)
