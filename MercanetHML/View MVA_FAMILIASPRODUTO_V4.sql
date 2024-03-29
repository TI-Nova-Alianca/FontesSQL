---------------------------------------------------------------------------------------------------
-- VERSAO	DATA		AUTOR			ALTERACAO
-- 1.0001	15/10/2012	TIAGO PRADELLA	CRIACAO
-- 1.0002   1/11/2012   TIAGO PRADELLA  INCLUIDA CONDICAO DE FAMILIA NO WHERE
-- 1.0003   20/02/2013  tiago           condicao para buscar familias que pertencem ao grupo cadastrado do usuario
-- 1.0004   18/02/2014  tiago           alterado join das tabelas para quem nao tem familia informada
-- 1.0005   11/12/2014  TIAGO           INCLUIDO NOVOS CAMPO: custoIndustrialProduzido_FAPRO, custoIndustrialRevenda_FAPRO, custoAdministrativo_FAPRO, custoComercial_FAPRO
-- 1.0006   15/09/2015  tiago           retirado distinct
---------------------------------------------------------------------------------------------------
ALTER VIEW MVA_FAMILIASPRODUTO_V4 AS
SELECT DISTINCT FAMILIA.DB_TBFAM_CODIGO     CODIGO_FAPRO,
       FAMILIA.DB_TBFAM_DESCRICAO         DESCRICAO_FAPRO,
	   CASE WHEN (SELECT ISNULL(DB_PRM_CUSTO_IND, 0) FROM DB_PARAMETRO1) = 0
	        THEN DB_TBFAM_CUSTO_IND
			ELSE DB_TBFAM_CFFAT_IND END      custoIndustrialProduzido_FAPRO,
		CASE WHEN (SELECT ISNULL(DB_PRM_CUSTO_ADM, 0) FROM DB_PARAMETRO1) = 0
	        THEN DB_TBFAM_CUSTO_INR
			ELSE DB_TBFAM_CFFAT_INR END         custoIndustrialRevenda_FAPRO,
		CASE WHEN (SELECT ISNULL(DB_PRM_CUSTO_IND, 0) FROM DB_PARAMETRO1) = 0
	        THEN DB_TBFAM_CUSTO_ADM
			ELSE DB_TBFAM_CFFAT_ADM  END custoAdministrativo_FAPRO,
		CASE WHEN (SELECT ISNULL(DB_PRM_CUSTO_COM, 0) FROM DB_PARAMETRO1) = 0
	        THEN DB_TBFAM_CUSTO_COM
			ELSE DB_TBFAM_CFFAT_COM END    custoComercial_FAPRO,
       USUARIO
  FROM DB_TB_FAMILIA       FAMILIA,
	   DB_PRODUTO_USUARIO,
	   DB_PRODUTO
 WHERE PRODUTO = DB_PROD_CODIGO
   AND DB_PROD_FAMILIA        = FAMILIA.DB_TBFAM_CODIGO
