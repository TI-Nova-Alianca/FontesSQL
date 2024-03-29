---------------------------------------------------------------------------------------------------
-- VERSAO	DATA		AUTOR			ALTERACAO
-- 1.0001	17/11/2015	TIAGO PRADELLA	CRIACAO
-- 1.0002   24/02/2015  TIAGO           INCLUIDO CAMPO DATAALTER
---------------------------------------------------------------------------------------------------
ALTER VIEW MVA_CATDETALHESPRODUTO  AS
 SELECT CATALOGO       CATALOGO_CDEP,
		AREA	       AREA_CDEP,
		ORDEM_COLUNA   ORDEMCOLUNA_CDEP,
		CAMPO	       CAMPO_CDEP,
		ORDEM_CAMPO	   ORDEMCAMPO_CDEP,
		LABEL	       LABEL_CDEP,
		ATRIBUTO	   ATRIBUTO_CDEP,
		COL.USUARIO,
		COL.DATAALTER
   FROM DB_CAT_DETALHEPROD DET,
        MVA_CATCOLUNASDETPROD COL
  WHERE DET.CATALOGO = COL.CATALOGO_COLD
    AND DET.AREA     = COL.AREA_COLD
	AND DET.ORDEM_COLUNA = COL.ORDEM_COLD
