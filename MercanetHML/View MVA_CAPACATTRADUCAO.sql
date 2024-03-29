---------------------------------------------------------------------------------------------------
-- VERSAO	DATA		AUTOR			ALTERACAO
-- 1.0000	16/12/2013	TIAGO PRADELLA	CRIACAO
-- 1.0001   31/01/2014  tiago           incluido replace
-- 1.0003   24/02/2015  TIAGO           INCLUIDO CAMPO DATAALTER
---------------------------------------------------------------------------------------------------
ALTER VIEW MVA_CAPACATTRADUCAO AS
SELECT 
	   DB_CAPTR_CATALOGO	 CATALOGO_CAPTRA,
	   DB_CAPTR_SEQUENCIA	 SEQUENCIA_CAPTRA,
	   DB_CAPTR_CHAVE	     CHAVE_CAPTRA,
	   DB_CAPTR_IDIOMA	     IDIOMA_CAPTRA,
	   replace(replace(replace(replace(DB_CAPTR_TRADUCAO, '.png', '.PNGM'), '.jpg','.PNGM'), '\', '/'), '.mp4', '.MP4M') TRADUCAO_CAPTRA,
	   C.USUARIO,
	   DB_CAPTR_DATAALTER     DATAALTER
  FROM DB_CAPA_CAT_TRADUCAO,  MVA_CATALOGOS C
 WHERE C.CODIGO_CAT = DB_CAPTR_CATALOGO
