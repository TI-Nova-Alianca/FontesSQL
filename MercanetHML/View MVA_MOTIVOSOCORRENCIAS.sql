---------------------------------------------------------------------------------------------------
-- VERSAO	DATA		AUTOR			ALTERACAO
-- 1.0000	17/07/2017	TIAGO PRADELLA	DESENVOLVIMENTO
---------------------------------------------------------------------------------------------------
ALTER VIEW MVA_MOTIVOSOCORRENCIAS AS
 select CODIGO	     codigo_MOTOC,
		DESCRICAO	descricao_MOTOC
   from DB_OC_MOTIVOS
