---------------------------------------------------------------------------------------------------
-- VERSAO   DATA	    AUTOR		       ALTERACAO
-- 1.0001   13/10/2014	TIAGO PRADELLA	   CRIACAO
-- 1.0002   24/02/2015  TIAGO           INCLUIDO CAMPO DATAALTER
---------------------------------------------------------------------------------------------------
ALTER VIEW MVA_CAPASUBVISTEMPLATE AS
SELECT DB_SUBCT_SEQUENCIA	    SEQUENCIA_CAPST,
	   DB_SUBCT_CHAVE	        CHAVE_CAPST,
	   replace(replace(replace(replace(DB_SUBCT_VALOR, '.png', '.PNGM'), '.jpg','.PNGM'), '\', '/'), '.mp4', '.MP4M')   VALOR_CAPST,
	   DB_SUBCT_CATALOGO	    CATALOGO_CAPST,
	   DB_SUBCT_VISAO	        VISAO_CAPST,
	   DB_SUBCT_VALOR_SUBVISAO	VALORSUBVISAO_CAPST,
	   USUARIO,
	   MVA_CATALOGOS.DATAALTER
  FROM DB_SUBVISAO_CAPA_TMPL, MVA_CATALOGOS
 WHERE CODIGO_CAT = DB_SUBCT_CATALOGO
