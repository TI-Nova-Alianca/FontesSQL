---------------------------------------------------------------------------------------------------
-- VERSAO	DATA		AUTOR			ALTERACAO
-- 1.0000	13/12/2013	TIAGO PRADELLA	CRIACAO
-- 1.0001   20/10/2015  tiago           incluido campo exibe listagem
-- 1.0002   24/02/2015  TIAGO           INCLUIDO CAMPO DATAALTER
---------------------------------------------------------------------------------------------------
ALTER VIEW MVA_CATALOGOSVARIACAO AS
SELECT DB_CATV_CATALOGO	       CATALOGO_CVAR,
	   DB_CATV_COLUNA	       COLUNA_CVAR,
	   DB_CATV_ORDEM	       ORDEM_CVAR,
	   DB_CATV_EXIBELISTAGEM   EXIBELISTAGEM_CVAR,
	   C.USUARIO,
	   C.DATAALTER
  FROM DB_CATALOGO_VARIACAO, MVA_CATALOGOS C
 WHERE C.CODIGO_CAT = DB_CATV_CATALOGO
