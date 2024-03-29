---------------------------------------------------------------------------------------------------
-- VERSAO	DATA		AUTOR			ALTERACAO
-- 1.0000	16/12/2013	TIAGO PRADELLA	CRIACAO
-- 1.0001   31/01/2014  tiago           incluido replace
-- 1.0002   24/02/2015  TIAGO           INCLUIDO CAMPO DATAALTER
---------------------------------------------------------------------------------------------------
ALTER VIEW MVA_CATIMAGENSCHAM AS
SELECT DB_CATIC_CATALOGO	CATALOGO_IMGCH,
	   DB_CATIC_COLUNA	    COLUNA_IMGCH,
	   DB_CATIC_VALOR	    VALOR_IMGCH,
	   replace(replace(replace(replace(DB_CATIC_IMAGEM, '.png', '.PNGM'), '.jpg','.PNGM'), '\', '/'), '.mp4', '.MP4M')   IMAGEM_IMGCH,
	   DB_CATIC_IDIOMA	    IDIOMA_IMGCH,
	   DB_CATIC_TAMANHO	    TAMANHO_IMGCH,
	   DB_CATIC_SEQUENCIA   sequencia_IMGCH,
	   C.USUARIO,
	   C.DATAALTER
  FROM DB_CATALOGO_IMG_CHAM, MVA_CATALOGOS C
 WHERE C.CODIGO_CAT = DB_CATIC_CATALOGO
