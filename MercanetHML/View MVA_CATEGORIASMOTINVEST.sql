---------------------------------------------------------------------------------------------------
-- VERSAO	DATA		AUTOR   ALTERACAO
-- 1.0001	02/01/2017	TIAGO 	CRIACAO
---------------------------------------------------------------------------------------------------
ALTER VIEW MVA_CATEGORIASMOTINVEST AS
select codigo		codigo_CATMOTINV
	  ,DESCRICAO	descricao_CATMOTINV
  from DB_MOT_INVEST_DESCTO_CATEGORIA
