---------------------------------------------------------------------------------------------------
-- VERSAO	DATA		AUTOR			ALTERACAO
-- 1.0000	16/12/2013	TIAGO PRADELLA	CRIACAO
-- 1.0001   24/02/2015  TIAGO           INCLUIDO CAMPO DATAALTER
---------------------------------------------------------------------------------------------------
ALTER VIEW MVA_CATALOGOSTRADUCAO AS
SELECT DB_CATT_CATALOGO	     CATALOGO_TRAD,
	   DB_CATT_TEXTO_ORIGEM	 TEXTOORIGEM_TRAD,
	   DB_CATT_IDIOMA	     IDIOMA_TRAD,
	   DB_CATT_TRADUCAO	     TRADUCAO_TRAD,
	   DB_CATT_HASH	         HASH_TRAD,
	   C.USUARIO,
	   DB_CATTDATAALTER      DATAALTER
  FROM DB_CATALOGO_TRADUCAO, MVA_CATALOGOS C
 WHERE C.CODIGO_CAT = DB_CATT_CATALOGO
