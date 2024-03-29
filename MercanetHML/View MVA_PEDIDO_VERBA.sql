---------------------------------------------------------------------------------------------------
-- VERSAO	DATA		AUTOR			ALTERACAO
-- 1.0001	08/09/2016	TIAGO PRADELLA	CRIACAO
---------------------------------------------------------------------------------------------------
ALTER VIEW MVA_PEDIDO_VERBA AS
 select db_pedv_pedido	pedido_PEDV,
		db_pedv_historico	historico_PEDV,
		DB_PEDV_DCTOCALC	descontoCalculado_PEDV,
		DB_PEDV_DCTOINF	descontoInformado_PEDV,
		DB_PEDV_FAMILIA familia_PEDV,
		MVA_PEDIDOS.usuario,
		MVA_PEDIDOS.dataalter
   from DB_PEDIDO_VERBA, MVA_PEDIDOS
  where DB_PEDIDO_VERBA.db_pedv_pedido = MVA_PEDIDOS.codigo_PEDID
