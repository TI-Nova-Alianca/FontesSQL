---------------------------------------------------------------------------------------------------
-- VERSAO	DATA		AUTOR			ALTERACAO
-- 1.0000	13/12/2013	TIAGO PRADELLA	CRIACAO
-- 1.0001   24/02/2015  TIAGO           INCLUIDO CAMPO DATAALTER
---------------------------------------------------------------------------------------------------
ALTER VIEW MVA_CATALOGOSATRIBUTO AS
SELECT DB_CATA_CATALOGO	  CATALOGO_ATRIB,
	   DB_CATA_ATRIB	  ATRIBUTO_ATRIB,
	   DB_CATA_TAG	      TAG_ATRIB,
	   C.USUARIO,
	   C.DATAALTER
  FROM DB_CATALOGO_ATRIB,  MVA_CATALOGOS C
 WHERE C.CODIGO_CAT = DB_CATA_CATALOGO
