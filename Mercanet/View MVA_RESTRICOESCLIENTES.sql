---------------------------------------------------------------------------------------------------
-- VERSAO	DATA		AUTOR			ALTERACAO
-- 1.0000	10/07/2013	TIAGO PRADELLA	CRIACAO
---------------------------------------------------------------------------------------------------
ALTER VIEW  MVA_RESTRICOESCLIENTES AS
SELECT DB_RESTC_CODIGO	CODIGO_RESCLI,
       DB_RESTC_DESC	DESCRICAO_RESCLI
  FROM DB_RESTRICAO_CLI
