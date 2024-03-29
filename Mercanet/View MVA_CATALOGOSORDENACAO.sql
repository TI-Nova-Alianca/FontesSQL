---------------------------------------------------------------------------------------------------
-- VERSAO	DATA		AUTOR			ALTERACAO
-- 1.0000	16/12/2013	TIAGO PRADELLA	CRIACAO
-- 1.0001   24/02/2015  TIAGO           INCLUIDO CAMPO DATAALTER
---------------------------------------------------------------------------------------------------
ALTER VIEW MVA_CATALOGOSORDENACAO AS
SELECT DB_CATOR_CATALOGO   CATALOGO_ORDE,
	   DB_CATOR_COLUNA	   COLUNA_ORDE,
	   DB_CATOR_ORDEM	   ORDEM_ORDE,
	   C.USUARIO,
	   C.DATAALTER
  FROM DB_CATALOGO_ORDEM, MVA_CATALOGOS C
 WHERE C.CODIGO_CAT = DB_CATOR_CATALOGO
