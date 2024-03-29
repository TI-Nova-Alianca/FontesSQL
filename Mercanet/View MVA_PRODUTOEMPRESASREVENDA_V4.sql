---------------------------------------------------------------------------------------------------
-- VERSAO	DATA		AUTOR			ALTERACAO
-- 1.0001	15/10/2012	TIAGO PRADELLA	CRIACAO
---------------------------------------------------------------------------------------------------
ALTER VIEW MVA_PRODUTOEMPRESASREVENDA_V4 AS
SELECT DB_PRODUTO.DB_PROD_CODIGO  PRODUTO_PREMP,
       E.DB_TBEMP_CODIGO          EMPRESAREVENDA_PREMP,
	   CASE  WHEN ISNULL(DB_PROD_ULT_ALTER, 0) > ISNULL(DB_PROD_ALT_CORP, 0) THEN DB_PROD_ULT_ALTER ELSE DB_PROD_ALT_CORP END DATAALTER, 
       PRODUSU.USUARIO AS USUARIO
  FROM DB_PRODUTO, 
       DB_PRODUTO_USUARIO PRODUSU,
	   DB_TB_EMPRESA E
 WHERE (DBO.MERCF_VALIDA_LISTA (E.DB_TBEMP_CODIGO,
                            DB_PRODUTO.DB_PROD_EMPREV,
                            0,
                            ',')) = 1 
   AND ISNULL(DB_PRODUTO.DB_PROD_EMPREV, '') <> ''
   AND DB_PRODUTO.DB_PROD_CODIGO = PRODUSU.PRODUTO
