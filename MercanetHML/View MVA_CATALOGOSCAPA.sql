---------------------------------------------------------------------------------------------------
-- VERSAO	DATA		AUTOR			ALTERACAO
-- 1.0000	13/12/2013	TIAGO PRADELLA	CRIACAO
-- 1.0001   31/01/2014  tiago           incluido campo de ordem
-- 1.0002   30/11/2015  tiago           incluido campos especificoIdioma_CAPC e idiomas_CAPC
-- 1.0003   24/02/2015  TIAGO           INCLUIDO CAMPO DATAALTER
---------------------------------------------------------------------------------------------------
ALTER VIEW MVA_CATALOGOSCAPA AS
SELECT DB_CATC_SEQUENCIA   SEQUENCIA_CAPC,
	   DB_CATC_CATALOGO	   CATALOGO_CAPC,
	   DB_CATC_TEMPLATE	   TEMPLATE_CAPC,
	   DB_CATC_ORDEM       ORDEM_CAPC,
	   DB_CATC_ESPECIDIOMA especificoIdioma_CAPC,
	   DB_CATC_IDIOMAS     idiomas_CAPC,
	   C.USUARIO,
	   C.DATAALTER
  FROM DB_CATALOGO_CAPA, MVA_CATALOGOS C
 WHERE C.CODIGO_CAT = DB_CATC_CATALOGO
