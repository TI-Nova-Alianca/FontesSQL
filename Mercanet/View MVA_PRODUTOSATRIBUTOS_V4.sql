---------------------------------------------------------------------------------------------------
-- VERSAO	DATA		AUTOR			ALTERACAO
-- 1.0001	15/10/2012	TIAGO PRADELLA	CRIACAO
-- 1.0001   19/11/2013  TIAGO           INCLUIDO VPROD.DATAALTER
-- 1.0002   17/02/2014  TIAGO           INCLUIDO CAMPO DESCRICAO_ATPRO
---------------------------------------------------------------------------------------------------
ALTER VIEW MVA_PRODUTOSATRIBUTOS_V4  AS
SELECT DB_PRODA_CODIGO      PRODUTO_ATPRO,
	   DB_PRODA_ATRIB       ATRIBUTO_ATPRO,
	   DB_PRODA_VALOR       VALOR_ATPRO,
	   DB_PROD_ULT_ALTER    DATAALTER,
	   ISNULL(CASE WHEN (SELECT AT01_CADASTRAVEL
	               FROM MAT01
				  WHERE AT01_ATRIB = DB_PRODA_ATRIB) = 1 THEN (SELECT AT03_DESCRICAO
				                                                 FROM MAT03
																WHERE AT03_ATRIB = DB_PRODA_ATRIB
																  AND ISNULL(AT03_CODIGO, '') = ISNULL(DB_PRODA_VALOR , ''))
														 ELSE DB_PRODA_VALOR END, DB_PRODA_VALOR)                DESCRICAO_ATPRO,
	   VPROD.USUARIO
  FROM DB_PRODUTO_ATRIB,       
	   DB_PRODUTO_USUARIO VPROD,
	   DB_PRODUTO
 WHERE VPROD.PRODUTO = DB_PRODA_CODIGO
   AND VPROD.PRODUTO = DB_PROD_CODIGO
