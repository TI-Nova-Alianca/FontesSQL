---------------------------------------------------------------------------------------------------
-- VERSAO	DATA		AUTOR			ALTERACAO
-- 1.0000	13/12/2013	TIAGO PRADELLA	CRIACAO
-- 1.0001   07/02/2014  tiago           incluido campo ordem template
-- 1.0002   30/11/2015  tiago           incluido campos especificoIdioma_CAPV e idiomas_CAPV
-- 1.0003   24/02/2015  TIAGO           INCLUIDO CAMPO DATAALTER
---------------------------------------------------------------------------------------------------
ALTER VIEW MVA_CAPAVISOES AS
SELECT DB_VISC_SEQUENCIA		SEQUENCIA_CAPV,
	   DB_VISC_CATALOGO			CATALOGO_CAPV,
	   DB_VISC_VISAO			VISAO_CAPV,
	   DB_VISC_VALOR			VALORVISAO_CAPV,
	   DB_VISC_ORDEM			ORDEM_CAPV,
	   DB_VISC_TEMPLATE			TEMPLATE_CAPV,
	   DB_VISC_COR	            CORABA_CAPV,
	   DB_VISC_ORDEM_TEMPLATE   ORDEMTEMPLATE_CAPV,
	   DB_VISC_ESPECIDIOMA      especificoIdioma_CAPV,
	   DB_VISC_IDIOMAS          idiomas_CAPV,
	   C.USUARIO,
	   c.DATAALTER
  FROM DB_VISAO_CAPA,  MVA_CATALOGOS C
 WHERE C.CODIGO_CAT = DB_VISC_CATALOGO
