---------------------------------------------------------------------------------------------------
-- VERSAO   DATA	    AUTOR		       ALTERACAO
-- 1.0001   13/10/2014	TIAGO PRADELLA	   CRIACAO
-- 1.0002   24/02/2015  TIAGO              INCLUIDO CAMPO DATAALTER
---------------------------------------------------------------------------------------------------
ALTER VIEW MVA_CAPASUBVISTRADUCAO AS
SELECT DB_SUBTR_IDIOMA	    IDIOMA_CSTRA,
	   replace(replace(replace(replace(DB_SUBTR_TRADUCAO, '.png', '.PNGM'), '.jpg','.PNGM'), '\', '/'), '.mp4', '.MP4M') 	TRADUCAO_CSTRA,
	   DB_SUBTR_SEQUENCIA	SEQUENCIA_CSTRA,
	   DB_SUBTR_CATALOGO	CATALOGO_CSTRA,
	   DB_SUBTR_VISAO    	VISAO_CSTRA,
	   DB_SUBTR_VALOR	    VALORSUBVISAO_CSTRA,
       DB_SUBTR_CHAVE	    CHAVE_CSTRA,
	   USUARIO,
	   DB_SUBTR_DATAALTER   DATAALTER
FROM DB_SUBVISAO_CAPA_TRAD, MVA_CATALOGOS
 WHERE CODIGO_CAT = DB_SUBTR_CATALOGO
