---------------------------------------------------------------------------------------------------
-- VERSAO	DATA		AUTOR   ALTERACAO
-- 1.0001	02/01/2017	TIAGO 	CRIACAO
---------------------------------------------------------------------------------------------------
ALTER VIEW MVA_MOTINVESTDESCTOTIPO AS
select MOTIVO	motivo_MIDT
      ,TIPO		tipo_MIDT
  from DB_MOT_INVEST_DESCTO_TIPO
