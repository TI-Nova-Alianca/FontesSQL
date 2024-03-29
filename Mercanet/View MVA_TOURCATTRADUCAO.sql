---------------------------------------------------------------------------------------------------
-- VERSAO	DATA		AUTOR			ALTERACAO
-- 1.0000	13/12/2013	TIAGO PRADELLA	CRIACAO
-- 1.0002   31/01/2014  tiago           incluido replace
-- 1.0003   24/02/2015  TIAGO           INCLUIDO CAMPO DATAALTER
---------------------------------------------------------------------------------------------------
ALTER VIEW MVA_TOURCATTRADUCAO AS
SELECT 
	   DB_TOURT_CODIGO	    CODIGO_TOUTR,
	   DB_TOURT_SEQUENCIA	SEQUENCIA_TOUTR,
	   DB_TOURT_CHAVE	    CHAVE_TOUTR,
	   DB_TOURT_IDIOMA	    IDIOMA_TOUTR,
	   replace(replace(replace(replace(DB_TOURT_TRADUCAO, '.png', '.PNGM'), '.jpg','.PNGM'), '\', '/'), '.mp4', '.MP4M')  TRADUCAO_TOUTR,	   	
	   T.USUARIO,
	   T.DATAALTER
  FROM DB_TOUR_TRADUCAO, MVA_TOURCATALOGO T
 WHERE T.CODIGO_TOUR = DB_TOURT_CODIGO
   AND T.SEQUENCIA_TOUR = DB_TOURT_SEQUENCIA
