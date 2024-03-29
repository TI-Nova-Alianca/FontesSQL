---------------------------------------------------------------------------------------------------
-- VERSAO	DATA		AUTOR			ALTERACAO
-- 1.0000	13/12/2013	TIAGO PRADELLA	CRIACAO
-- 1.0002   31/01/2014  tiago           incluido replace
-- 1.0003   24/02/2015  TIAGO           INCLUIDO CAMPO DATAALTER
---------------------------------------------------------------------------------------------------
ALTER VIEW MVA_TOURCATTEMPLATE AS
SELECT DB_TOURCT_SEQUENCIA	 SEQUENCIA_TOUTE,
	   DB_TOURCT_CHAVE	     CHAVE_TOUTE,
	   replace(replace(replace(replace(DB_TOURCT_VALOR, '.png', '.PNGM'), '.jpg','.PNGM'), '\', '/'), '.mp4', '.MP4M')  VALOR_TOUTE,	   
	   DB_TOURCT_CODIGO	     CODIGO_TOUTE,
	   T.USUARIO,
	   T.DATAALTER
  FROM DB_TOUR_CAT_TMPL, MVA_TOURCATALOGO T
 WHERE T.CODIGO_TOUR = DB_TOURCT_CODIGO
   AND T.SEQUENCIA_TOUR = DB_TOURCT_SEQUENCIA
