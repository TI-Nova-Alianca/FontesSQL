---------------------------------------------------------------------------------------------------
-- VERSAO	DATA		AUTOR			ALTERACAO
-- 1.0000	16/12/2013	TIAGO PRADELLA	CRIACAO
-- 1.0001   31/01/2014  tiago           incluido replace
-- 1.0002   24/02/2015  TIAGO           INCLUIDO CAMPO DATAALTER
---------------------------------------------------------------------------------------------------
ALTER VIEW MVA_SELOS AS
SELECT DB_SELO_CODIGO	   CODIGO_SELO,
	   DB_SELO_DESCRICAO   DESCRICAO_SELO,
	   DB_SELO_IDIOMA	   IDIOMA_SELO,
	   replace(replace(replace(replace(DB_SELO_IMAGEM, '.png', '.PNGM'), '.jpg','.PNGM'), '\', '/'), '.mp4', '.MP4M') IMAGEM_SELO,
	   I.USUARIO,
	   I.DATAALTER
  FROM DB_SELOS, MVA_ITENSCATALOGO I
 WHERE I.SELO_ITCAT  = DB_SELO_CODIGO
