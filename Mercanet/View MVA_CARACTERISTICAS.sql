---------------------------------------------------------------------------------------------------
-- VERSAO	DATA		AUTOR			ALTERACAO
-- 1.0000	16/12/2013	TIAGO PRADELLA	CRIACAO
-- 1.0001   31/01/2014  tiago           incluido replace
-- 1.0002   24/02/2015  TIAGO           INCLUIDO CAMPO DATAALTER
---------------------------------------------------------------------------------------------------
ALTER VIEW MVA_CARACTERISTICAS AS
SELECT DISTINCT (DB_CARAC_CODIGO)	CODIGO_CARAC,
	   DB_CARAC_DESCRICAO	        DESCRICAO_CARAC,
	   DB_CARAC_IDIOMA	            IDIOMA_CARAC,
	   replace(replace(replace(replace(DB_CARAC_IMAGEM, '.png', '.PNGM'), '.jpg','.PNGM'), '\', '/'), '.mp4', '.MP4M')     IMAGEM_CARAC,
	   I.USUARIO,
	   i.dataalter
  FROM DB_CARACTERISTICAS, MVA_ITENSCARACTERISTICAS I
 WHERE I.CARACTERISTICA_ITCAR = DB_CARAC_CODIGO
