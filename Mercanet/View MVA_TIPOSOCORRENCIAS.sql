---------------------------------------------------------------------------------------------------
-- VERSAO	DATA		AUTOR			ALTERACAO
-- 1.0000	17/07/2017	TIAGO PRADELLA	DESENVOLVIMENTO
---------------------------------------------------------------------------------------------------
ALTER VIEW MVA_TIPOSOCORRENCIAS AS
 select	CODIGO		codigo_TPOC,
		DESCRICAO	descricao_TPOC
   from DB_OC_TIPOS
