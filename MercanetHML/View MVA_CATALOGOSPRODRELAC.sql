---------------------------------------------------------------------------------------------------
-- VERSAO	DATA		AUTOR			ALTERACAO
-- 1.0000	13/12/2013	TIAGO PRADELLA	CRIACAO
-- 1.0001   24/02/2015  TIAGO           INCLUIDO CAMPO DATAALTER
---------------------------------------------------------------------------------------------------
ALTER VIEW MVA_CATALOGOSPRODRELAC AS
SELECT DB_CATR_CATALOGO	  CATALOGO_CPREL,
	   DB_CATR_COLUNA	  COLUNA_CPREL,
	   DB_CATR_ORDEM	  ORDEM_CPREL,
	   C.USUARIO,
	   C.DATAALTER
  FROM DB_CATALOGO_RELAC, MVA_CATALOGOS C
 WHERE C.CODIGO_CAT = DB_CATR_CATALOGO
