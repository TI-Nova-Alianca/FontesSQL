---------------------------------------------------------------------------------------------------
-- VERSAO	DATA		AUTOR			ALTERACAO
-- 1.0001	17/11/2015	TIAGO PRADELLA	CRIACAO
-- 1.0002   24/02/2015  TIAGO           INCLUIDO CAMPO DATAALTER
---------------------------------------------------------------------------------------------------
ALTER VIEW MVA_CATCOLUNASDETPROD AS
 SELECT CATALOGO	   CATALOGO_COLD,
		AREA	       AREA_COLD,
		NRO_COLUNAS	   NUMEROCOLUNAS_COLD,
		TITULO_COLUNA  TITULOCOLUNA_COLD,
		ORDEM	       ORDEM_COLD,
		CAT.USUARIO,
		CAT.DATAALTER
   FROM DB_CAT_COLUNASDETPROD,
        MVA_CATALOGOS CAT
  WHERE CAT.CODIGO_CAT = CATALOGO
