---------------------------------------------------------------------------------------------------
-- VERSAO   DATA	    AUTOR		       ALTERACAO
-- 1.0001   13/10/2014	TIAGO PRADELLA	   CRIACAO
-- 1.0002   24/02/2015  TIAGO              INCLUIDO CAMPO DATAALTER
---------------------------------------------------------------------------------------------------
ALTER VIEW MVA_CATALOGOORDIMAGENSCHAMADA AS
SELECT DB_CATCL_CATALOGO   CATALOGO_ORIMG,
	   DB_CATCL_COLUNA	   COLUNA_ORIMG,
	   DB_CATCL_ORDEM	   ORDEM_ORIMG,
	   USUARIO,
	   MVA_CATALOGOS.DATAALTER
  FROM DB_CAT_COLIMGCHAM, MVA_CATALOGOS
 WHERE CODIGO_CAT = DB_CATCL_CATALOGO
