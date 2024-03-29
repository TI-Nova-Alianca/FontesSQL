---------------------------------------------------------------------------------------------------
-- VERSAO	DATA		AUTOR			ALTERACAO
-- 1.0001	11/08/2016	TIAGO PRADELLA	CRIACAO, COPIA DA ORIGINAL, SOMENTE MUDA A DATA ALTER
---------------------------------------------------------------------------------------------------
ALTER VIEW MVA_PRODUTOSATRIBUTOSDATAAT_V4  AS
SELECT DB_PRODA_CODIGO      PRODUTO_ATPRO,
	   DB_PRODA_ATRIB       ATRIBUTO_ATPRO,
	   DB_PRODA_VALOR       VALOR_ATPRO,
	   DB_PRODA_DATA_ALTER  DATAALTER,
	   ISNULL(CASE WHEN (SELECT AT01_CADASTRAVEL
	               FROM MAT01
				  WHERE AT01_ATRIB = DB_PRODA_ATRIB) = 1 THEN (SELECT AT03_DESCRICAO
				                                                 FROM MAT03
																WHERE AT03_ATRIB = DB_PRODA_ATRIB
																  AND ISNULL(AT03_CODIGO, '') = ISNULL(DB_PRODA_VALOR , ''))
														 ELSE DB_PRODA_VALOR END, DB_PRODA_VALOR)                DESCRICAO_ATPRO,
	   VPROD.USUARIO
  FROM DB_PRODUTO_ATRIB,       
	   DB_PRODUTO_USUARIO VPROD
 WHERE VPROD.PRODUTO = DB_PRODA_CODIGO
