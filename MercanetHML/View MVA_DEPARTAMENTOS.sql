---------------------------------------------------------------------------------------------------
-- VERSAO	DATA		AUTOR			ALTERACAO
-- 1.0000	10/07/2013	TIAGO PRADELLA	CRIACAO
---------------------------------------------------------------------------------------------------
CREATE  VIEW  MVA_DEPARTAMENTOS AS
SELECT DB_TBDEP_CODIGO	    CODIGO_DEPTO,
       DB_TBDEP_DESCRICAO	DESCRICAO_DEPTO
  FROM DB_TB_DEPTO
