---------------------------------------------------------------------------------------------------
-- VERSAO	DATA		AUTOR			ALTERACAO
-- 1.0001	20/10/2015	TIAGO PRADELLA	CRIACAO
---------------------------------------------------------------------------------------------------
ALTER VIEW MVA_POLITICASBONIREGRASFILTROS AS
SELECT REGRA         REGRA_POLBONIRF,       
       FILTRO        FILTRO_POLBONIRF
  FROM DB_POLBONI_REGRAS_FILTROS, MVA_POLITICASBONIFILTROSPROD
 WHERE DB_POLBONI_REGRAS_FILTROS.FILTRO = FILTRO_POLBONIF
