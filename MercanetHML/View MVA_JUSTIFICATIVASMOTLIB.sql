---------------------------------------------------------------------------------------------------
-- VERSAO	DATA	    AUTOR	    ALTERACAO
-- 1.0000   15/02/2016  TIAGO     DESENVIMENTO
---------------------------------------------------------------------------------------------------
CREATE  VIEW MVA_JUSTIFICATIVASMOTLIB  AS
 select DB_TBJL_CODIGO	    codigo_JULIB,
		DB_TBJL_DESCRICAO	descricao_JULIB,
		DB_TBJL_VAL_MOTIVO	motivo_JULIB,
		DB_TBJL_OBS_ADIC	observacao_JULIB
   from DB_TB_JUST_LIBER
