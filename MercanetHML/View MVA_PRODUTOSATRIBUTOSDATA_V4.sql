ALTER VIEW MVA_PRODUTOSATRIBUTOSDATA_V4 as
---------------------------------------------------------------------------------------------------
-- VERSAO  DATA    AUTOR      ALTERACAO
-- 1.0000  15/10/2012  TIAGO PRADELLA  CRIACAO
-- 1.0001  04/11/2013  Alencar  Envia a data do produto
---------------------------------------------------------------------------------------------------
SELECT DB_PRODA_CODIGO       PRODUTO_ATPRO,
       DB_PRODA_ATRIB        ATRIBUTO_ATPRO,
       DB_PRODA_VALOR        VALOR_ATPRO,
       DB_PROD_ULT_ALTER     DATAALTER,
       VPROD.USUARIO
  FROM DB_PRODUTO_ATRIB,
       DB_PRODUTO_USUARIO vprod,
	   DB_PRODUTO
 where vprod.PRODUTO = db_proda_codigo
   AND VPROD.PRODUTO = DB_PROD_CODIGO
