---------------------------------------------------------------------------------------------------
-- VERSAO   DATA	    AUTOR		       ALTERACAO
-- 1.0001   30/11/2015	TIAGO PRADELLA	   CRIACAO
---------------------------------------------------------------------------------------------------
ALTER VIEW MVA_LISTASSUGERIDASTRAD AS
 SELECT CODIGO_LISTA	CODIGOLISTA_LISTR,
		IDIOMA	        IDIOMA_LISTR,
		TEXTO_ORIGEM	TEXTOORIGEM_LISTR,
		TRADUCAO	    TRADUCAO_LISTR,
		LISTA.USUARIO
   FROM DB_CAT_LISTASUG_TRADUCOES  T,
        MVA_LISTASSUGERIDAS LISTA
  WHERE T.CODIGO_LISTA = LISTA.CODIGO_LISSUG	
	AND T.IDIOMA IN (SELECT MVA_IDIOMAS.CODIGO_IDI
	                   FROM MVA_IDIOMAS
					  WHERE MVA_IDIOMAS.USUARIO = LISTA.USUARIO)
