---------------------------------------------------------------------------------------------------
-- VERSAO	DATA		AUTOR			ALTERACAO
-- 1.0000	13/12/2013	TIAGO PRADELLA	CRIACAO
-- 1.0002   31/01/2014  tiago           incluido replace
-- 1.0003   24/02/2015  TIAGO           INCLUIDO CAMPO DATAALTER
---------------------------------------------------------------------------------------------------
ALTER VIEW MVA_CAPAVISTRADUCAO AS
SELECT 
	   DB_VICTR_CATALOGO	 CATALOGO_CPVTRA,
	   DB_VICTR_SEQUENCIA	 SEQUENCIA_CPVTRA,
	   DB_VICTR_VISAO		 VISAO_CPVTRA,
	   DB_VICTR_VALOR	     VALORVISAO_CPVTRA,
	   DB_VICTR_CHAVE	     CHAVE_CPVTRA,
	   DB_VICTR_IDIOMA	     IDIOMA_CPVTRA,
	   replace(replace(replace(replace(DB_VICTR_TRADUCAO, '.png', '.PNGM'), '.jpg','.PNGM'), '\', '/'), '.mp4', '.MP4M')   TRADUCAO_CPVTRA,
	   C.USUARIO,
	   DB_VICTR_DATAALTER     DATAALTER
  FROM DB_VISAO_CAPA_TRAD, MVA_CATALOGOS C
 WHERE C.CODIGO_CAT = DB_VICTR_CATALOGO
