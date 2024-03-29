---------------------------------------------------------------------------------------------------
-- VERSAO	DATA		AUTOR			ALTERACAO
-- 1.0000	16/12/2013	TIAGO PRADELLA	CRIACAO
---------------------------------------------------------------------------------------------------
ALTER VIEW MVA_CATALOGOCONFIGURACOES AS
SELECT DB_PRMC_CHAVE	CHAVE_CACON,
	   DB_PRMC_IDIOMA	IDIOMA_CACON,	  
	   replace(replace(replace(DB_PRMC_VALOR, '.png', '.PNGM'), '.jpg','.PNGM'), '\', '/')  	VALOR_CACON
  FROM DB_PARAM_CATALOGO
