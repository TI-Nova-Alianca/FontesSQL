---------------------------------------------------------------------------------------------------
-- VERSAO	DATA		AUTOR			ALTERACAO
-- 1.0000	17/07/2017	TIAGO PRADELLA	DESENVOLVIMENTO
---------------------------------------------------------------------------------------------------
ALTER VIEW MVA_ORIGENSMOTIVOSOCORRENCIAS AS
 select CODIGO		codigo_ORMOOC,
		DESCRICAO	descricao_ORMOOC
   from DB_OC_ORIGENS
