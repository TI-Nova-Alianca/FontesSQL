---------------------------------------------------------------------------------------------------
-- VERSAO	DATA		AUTOR			ALTERACAO
-- 1.0000	13/12/2013	TIAGO PRADELLA	CRIACAO
-- 1.0002   31/01/2014  tiago           incluido replace
-- 1.0003   24/02/2015  TIAGO           INCLUIDO CAMPO DATAALTER
---------------------------------------------------------------------------------------------------
ALTER VIEW MVA_CAPACATTEMPLATE AS
SELECT DB_CATCT_SEQUENCIA	SEQUENCIA_CAPCT,
	   DB_CATCT_CATALOGO	CATALOGO_CAPCT,
	   DB_CATCT_CHAVE	    CHAVE_CAPCT,
	   replace(replace(replace(replace(DB_CATCT_VALOR, '.png', '.PNGM'), '.jpg','.PNGM'), '\', '/'), '.mp4', '.MP4M')   VALOR_CAPCT,
	   C.USUARIO,
	   c.DATAALTER
  FROM DB_CAPA_CAT_TMPL, MVA_CATALOGOS C
 WHERE C.CODIGO_CAT = DB_CATCT_CATALOGO
