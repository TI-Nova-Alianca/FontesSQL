---------------------------------------------------------------------------------------------------
-- VERSAO	DATA		AUTOR			ALTERACAO
-- 1.0000	13/12/2013	TIAGO PRADELLA	CRIACAO
-- 1.0001   10/03/2016  tiago           incluido campo data
---------------------------------------------------------------------------------------------------
ALTER VIEW MVA_PERMISSOESCATALOGO AS
SELECT DB_CAPERM_CATALOGO  CATALOGO_PERMC,
       DB_CAPERM_USUARIO   USUARIO_PERMC,
       DB_CAPERM_PADRAO	   PADRAO_PERMC,
	   DB_CAPERM_DATA      DATA_PERMC,
	   USU.USUARIO
  FROM DB_CAT_PERMISSOES, DB_USUARIO USU
 WHERE USU.CODIGO = DB_CAPERM_USUARIO
