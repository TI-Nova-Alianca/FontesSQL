---------------------------------------------------------------------------------------------------
-- VERSAO	DATA		AUTOR			ALTERACAO
-- 1.0000	08/05/2014	TIAGO PRADELLA	CRIACAO
---------------------------------------------------------------------------------------------------
ALTER VIEW  MVA_GRADES AS
select DB_GRD_CODIGO     codigo_GRAD,
	   DB_GRD_DESCRICAO  descricao_GRAD	
  from DB_GRADE_PAO
