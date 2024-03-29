---------------------------------------------------------------------------------------------------
-- VERSAO   DATA	    AUTOR		       ALTERACAO
-- 1.0001   13/10/2014	TIAGO PRADELLA	   CRIACAO
-- 1.0002   30/11/2015  tiago              incluido campos especificoIdioma_CAPS e idiomas_CAPS
-- 1.0003   24/02/2015  TIAGO           INCLUIDO CAMPO DATAALTER
---------------------------------------------------------------------------------------------------
ALTER VIEW MVA_CAPASUBVISOES AS
SELECT DB_SUBV_SEQUENCIA	   SEQUENCIA_CAPS,
	   DB_SUBV_CATALOGO	       CATALOGO_CAPS,
	   DB_SUBV_VISAO	       VISAO_CAPS,
	   DB_SUBV_VALOR	       VALORSUBVISAO_CAPS,
	   DB_SUBV_ORDEM	       ORDEM_CAPS,
	   DB_SUBV_TEMPLATE	       TEMPLATE_CAPS,
	   DB_SUBV_ORDEM_TEMPLATE  ORDEMTEMPLATE_CAPS,
	   DB_SUBV_ESPECIDIOMA     especificoIdioma_CAPS,
	   DB_SUBV_IDIOMAS         idiomas_CAPS,
	   USUARIO,
	   MVA_CATALOGOS.DATAALTER
  FROM DB_SUBVISAO_CAPA, MVA_CATALOGOS
 WHERE CODIGO_CAT = DB_SUBV_CATALOGO
