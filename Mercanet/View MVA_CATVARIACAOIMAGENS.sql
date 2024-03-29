---------------------------------------------------------------------------------------------------
-- VERSAO	DATA		AUTOR			ALTERACAO
-- 1.0000	20/10/2015	TIAGO PRADELLA	CRIACAO
-- 1.0001   24/02/2015  TIAGO           INCLUIDO CAMPO DATAALTER
---------------------------------------------------------------------------------------------------
ALTER VIEW MVA_CATVARIACAOIMAGENS AS
 SELECT DB_CVARI_CATALOGO	CATALOGO_CVARI,
		DB_CVARI_COLUNA	    COLUNA_CVARI,
		DB_CVARI_VALOR	    VALORVARIACAO_CVARI,
		DB_CVARI_IDIOMA	    IDIOMA_CVARI,
		REPLACE(REPLACE(REPLACE(REPLACE(DB_CVARI_IMAGEM, '.png', '.PNGM'), '.jpg','.PNGM'), '\', '/'), '.mp4', '.MP4M') IMAGEM_CVARI ,
		C.USUARIO,
		C.DATAALTER
    FROM DB_CAT_VARIACAO_IMAGEM, MVA_CATALOGOS C   
   WHERE C.CODIGO_CAT = DB_CVARI_CATALOGO
