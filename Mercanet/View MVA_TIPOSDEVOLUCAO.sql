---------------------------------------------------------------------------------------------------
-- VERSAO	DATA		AUTOR			ALTERACAO
-- 1.0001	08/01/2015	TIAGO PRADELLA	CRIACAO
---------------------------------------------------------------------------------------------------
ALTER VIEW MVA_TIPOSDEVOLUCAO AS
 SELECT DB_TPDEV_CODIGO    CODIGO_TPDEV,
		DB_TPDEV_DESCR     DESCRICAO_TPDEV		
   FROM DB_TB_TIPO_DEVOL
