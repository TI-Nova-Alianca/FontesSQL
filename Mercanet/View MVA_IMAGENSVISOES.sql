---------------------------------------------------------------------------------------------------
-- VERSAO	DATA		AUTOR			ALTERACAO
-- 1.0000	13/12/2013	TIAGO PRADELLA	CRIACAO
-- 1.0002   31/01/2014  tiago           incluido replace
-- 1.0003   24/02/2015  TIAGO           INCLUIDO CAMPO DATAALTER
---------------------------------------------------------------------------------------------------
ALTER VIEW MVA_IMAGENSVISOES AS
SELECT DB_VISI_CATALOGO	CATALOGO_IMGVI,
	   DB_VISI_VISAO	VISAO_IMGVI,
	   DB_VISI_VALOR	VALORVISAO_IMGVI,
	   DB_VISI_IDIOMA	IDIOMA_IMGVI,
	   replace(replace(replace(replace(DB_VISI_IMAGEM, '.png', '.PNGM'), '.jpg','.PNGM'), '\', '/'), '.mp4', '.MP4M')  IMAGEM_IMGVI,
	   C.USUARIO,
	   C.DATAALTER
  FROM DB_VISAO_IMAGEM, MVA_CATALOGOS C
 WHERE C.CODIGO_CAT = DB_VISI_CATALOGO
