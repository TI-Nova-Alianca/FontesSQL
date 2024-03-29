---------------------------------------------------------------------------------------------------
-- VERSAO	DATA		AUTOR			ALTERACAO
-- 1.0000	13/12/2013	TIAGO PRADELLA	CRIACAO
-- 1.0002   31/01/2014  tiago           incluido replace
-- 1.0003   24/02/2015  TIAGO           INCLUIDO CAMPO DATAALTER
---------------------------------------------------------------------------------------------------
ALTER VIEW MVA_CAPAVISOESTEMPLATE AS
SELECT DB_VICT_SEQUENCIA	SEQUENCIA_CAPT,
	   DB_VICT_CHAVE	    CHAVE_CAPT,	   	 
	   replace(replace(replace(replace(DB_VICT_VALOR, '.png', '.PNGM'), '.jpg','.PNGM'), '\', '/'), '.mp4', '.MP4M')   VALOR_CAPT,
	   DB_VICT_CATALOGO	    CATALOGO_CAPT,
	   DB_VICT_VISAO	    VISAO_CAPT,
	   DB_VICT_VALOR_VISAO	VALORVISAO_CAPT,
	   C.USUARIO,
	   c.DATAALTER
  FROM DB_VISAO_CAPA_TMPL, MVA_CATALOGOS C
 WHERE C.CODIGO_CAT = DB_VICT_CATALOGO
