---------------------------------------------------------------------------------------------------
-- VERSAO	DATA		AUTOR			ALTERACAO
-- 1.0001	15/10/2012	TIAGO PRADELLA	CRIACAO
---------------------------------------------------------------------------------------------------
ALTER VIEW MVA_PRODUTOSMERCADO AS
SELECT DB_TBPROD_CODIGO      CODIGO_PROME,
       DB_TBPROD_DESCR       DESCRICAO_PROME,
	   DB_TBPROD_FAIXAI      FAIXAPRECOINICIAL_PROME,
	   DB_TBPROD_FAIXAF      FAIXAPRECOFINAL_PROME
  FROM DB_TB_PROD_MERCADO
