---------------------------------------------------------------------------------------------------
-- VERSAO	DATA		AUTOR			ALTERACAO
-- 1.0000	17/07/2017	TIAGO PRADELLA	DESENVOLVIMENTO
---------------------------------------------------------------------------------------------------
ALTER VIEW MVA_MOTIVOSOCORRENCIASORIGENS AS
 select CODIGO_MOTIVO	codigoMotivo_MOORG,
		CODIGO_ORIGEM	codigoOrigem_MOORG
  from DB_OC_MOTIVO_ORIGENS
